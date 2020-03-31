*! version 1.2.4  12jul2002
program define xthausman, rclass
	version 4.0
	if "`e(cmd)'" != "xtreg" { error 301 }
	if "`e(model)'" != "re" {
		di in red "last estimates not xtreg, re"
		exit 301
	}
	if "`*'"!="" { error 198 }
	if `e(sigma_u)' == 0 {
		di in red "Estimate of sigma_u = 0, random-effects " 	/*
			*/ "estimator has degenerated to pooled"
		di in red "OLS and the Wald test from xthausman may not " /*
			*/ "be appropriate.  See [R] hausman"
		di in red "for a more general implementation of the "	/*
			*/ "Hausman test."
		exit 459
	}

	if (_caller()>=8) {
		local ms = cond(_caller()>=9, "as err" , "as txt")
		di as smcl `ms' "{p 0 1}"
		di as smcl `ms' "(Warning:"
		di as smcl `ms' "xthausman is no longer a supported command;" 
		di as smcl `ms' "use -hausman-." 
		di as smcl `ms' "For instructions, see help {help hausman}.)"
		di as smcl `ms' "{p_end}"
		if _caller() >= 9 { 
			exit 199
		}
		di as smcl
	}

	tempvar touse
	tempname b_fe v_fe b_re v_re

	qui gen byte `touse' = e(sample)

	di _n in gr "Hausman specification test"

	matrix `b_re' = get(_b)
	matrix `v_re' = get(VCE)

	if colsof(matrix(e(bf)))!=colsof(`b_re') {
		di in red "xthausman:  program bug, matrices not conformable"
		exit 9998
	}
	local n = colsof(matrix(e(bf)))-1 
	if `n'==0 { 
		di in red "no independent variables other than constant"
		exit 498
	}

	matrix `b_fe' = e(bf)
	matrix `b_fe' = `b_fe'[1,1..`n']
	matrix `b_re' = `b_re'[1,1..`n']
	matrix `v_fe' = e(VCEf)
	matrix `v_fe' = `v_fe'[1..`n',1..`n']
	matrix `v_re' = `v_re'[1..`n',1..`n']

				/* eliminate rows and columns that are not 
				   estimated */

	if diag0cnt(`v_fe')==rowsof(`v_fe') {
		di in red "xthausman:  all regressors constant within panel " /*
		*/	  "in fixed-effects model"
		exit 498
	}

	local i 1
	while `i'<=`n' { 
		if `v_fe'[`i',`i']==0 {
			_rfxrm `i' `b_fe'
			_rfxrm `i' `b_re'
			_rfxrm `i' `v_fe'
			_rfxrm `i' `v_re'
			local n = `n' - 1
		}
		else	local i=`i'+1
	}


	di _n in smcl in gr /*
		*/ _col(17) "{hline 4} Coefficients {hline 4}" _n /*
		*/ _col(14) "{c |}"  _col(21) "Fixed" _col(33) "Random" _n /*
		*/ %12s abbrev("`e(depvar)'",12) " {c |}" /*
		*/ _col(19) "Effects" _col(32) "Effects" /*
		*/ _col(46) "Difference" _n /*
		*/ "{hline 13}{c +}{hline 41}"

	local names : rownames(`v_fe')
	parse "`names'", parse(" ")
	local i 1
	while "``i''"!="" {
		di in smcl in gr /*
			*/ %12s "``i''" " {c |}  " in ye /*
			*/ %9.0g `b_fe'[1,`i'] "    " /*
			*/ %9.0g `b_re'[1,`i'] _skip(8) /*
			*/ %9.0g `b_fe'[1,`i']-`b_re'[1,`i']
		local i=`i'+1
	}
			

	matrix `b_re' = `b_re' - `b_fe'
	matrix `v_re' = `v_fe' - `v_re'		/* sic */
	matrix `v_re' = syminv(`v_re')
	matrix `v_re' = `b_re' * `v_re'
	matrix `v_re' = `v_re' * `b_re' '

	di _n in gr _col(5) /*
	*/ "Test:  Ho:  difference in coefficients not systematic" 

	di _n in gr _col(18) "chi2(" in ye %3.0f `n' in gr /*
		*/ ") = (b-B)'[S^(-1)](b-B), S = (S_fe - S_re)" _n /*
		*/ _col(28) "=" in ye %9.2f `v_re'[1,1] _n /* 
		*/ in gr _col(18) "Prob>chi2 = " /*
		*/ in ye %10.4f chiprob(`n',`v_re'[1,1])
	/* double save in S_# and r() */
	ret scalar df = `n'
	ret scalar chi2 = `v_re'[1,1]
	global S_1 `n'
	global S_2 = `v_re'[1,1]
end


*  version 1.0.0  07/13/94  stroke row/col from matrix utility
program define _rfxrm /* i matname */
	version 4.0
	local i `1'
	local M `2'

	tempname M11 M12 M1 M2
	local n = colsof(`M')
	local nm1 = `n'-1
	local im1 = `i'-1
	local ip1 = `i'+1
	if rowsof(`M')==1 {
		if `i'==1 { 
			matrix `M' = `M'[1,2..`n']
		}
		else if `i'==`n' {
			matrix `M' = `M'[1,1..`nm1']
		}
		else {
			matrix `M1' = `M'[1, 1..`im1']
			matrix `M2' = `M'[1, `ip1'..`n']
			matrix `M' = `M1', `M2'
		}
		exit
	}
	if `i'==1 { 
		matrix `M' = `M'[2..`n', 2..`n']
	}
	else if `i'==`n' {
		matrix `M' = `M'[1..`nm1', 1..`nm1']
	}
	else {
		matrix `M11' = `M'[1..`im1', 1..`im1']
		matrix `M12' = `M'[1..`im1', `ip1'..`n']
		matrix `M1'  = `M11', `M12'
		matrix `M11' = `M'[`ip1'..`n',1..`im1']
		matrix `M12' = `M'[`ip1'..`n',`ip1'..`n']
		matrix `M11' = `M11', `M12'
		matrix `M'   = `M1' \ `M11'
	}
end
