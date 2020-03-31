*! version 6.1.0  25mar2018
program define ml_searc /* AllowEv ml_searc ... */
	version 6
	ml_defd
	parse, parse("/, ")
	while "`1'" != "," & "`1'"!="" {
		if "`1'"!="/" {
			local eqname "`1'"
			if bsubstr("`eqname'",-1,1)==":" {
				local eqname = /*
				*/ bsubstr("`eqname'",1,length("`eqname'")-1)
			}
			capture confirm number `eqname'
			if _rc ==0 {
				confirm number `2'
				global ML_lb1 `1'
				global ML_ub1 `2'
				mac shift 2
			}
			else {
				confirm number `2'
				confirm number `3'
				FindEq `eqname'
				global ML_lb`r(k)' `2'
				global ML_ub`r(k)' `3'
				mac shift 3
			}
		}
		else	mac shift
	}
	#delimit ;
	local options "Repeat(integer 10) RESTart NOLOg LOg 
			MAXFEAS(integer 1000) noRESCale TRace" ;
	#delimit cr
	parse "`*'"
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'"!="" {
		local log "*"
	}
	if "`trace'"!="" {
		local tr
		local log
	}
	else	local tr "*"


				/* determine whether we call FindFeas */
	if "`restart'"=="" {
		if scalar($ML_f)==. {
			$ML_eval 0
		}
	}
	else {
		scalar $ML_f = .
		local rescale norescale
	}

	if scalar($ML_f)==. {	/* ... we do call */
		local log		/* turn on logging	*/
		DiMsg "`log'" "initial:"
		FindFeas `maxfeas' "`tr'" "`restart'"
		DiMsg "`log'" "feasible:"
	}
	else 	DiMsg "`log'" "initial:"


					/* improve initial values	*/
	if `repeat'>0 {
		`tr' di in gr "improving initial values " _c
		Random best `repeat' `tr'
		* FindBett `repeat' `tr'
		DiMsg "`log'" "improve:"
	}

					/* rescale initial values	*/
	if "`rescale'"=="" {
		tempname len
		mat `len' = $ML_b * $ML_b '
		if `len'[1,1]==0 {
			`tr' di in gr "trying nonzero initial values " _c
			tempname b0 f0
			mat `b0' = $ML_b
			scalar `f0' = scalar($ML_f)
			scalar $ML_f = .
			TryCons `tr'
			`tr' di
			if scalar($ML_f)==. {
				mat $ML_b = `b0'
				scalar $ML_f = `f0'
				DiMsg "`log'" "final:"
				exit
			}
			DiMsg "`log'" "alternative:"
		}
		Rescale `tr'
		DiMsg "`log'" "rescale:"
		if $ML_n>1 {
			RescEqs `tr'
			if r(rescaled)==1 {
				RescEqs `tr'
			}
			DiMsg "`log'" "rescale eq:"
		}
		if "`b0'"!="" {
			if scalar($ML_f)<`f0' {
				mat $ML_b = `b0'
				scalar $ML_f = `f0'
				DiMsg "`log'" "final"
			}
		}
	}
end

program define DiMsg /* log "<message>" */
	if "`1'"!="" { exit }
	di in gr "`2'" _col(16) "$ML_crtyp = " _c
	if scalar($ML_f)==. {
		di in ye "    -<inf>" in blu "  (could not be evaluated)"
	}
	else	di in ye %10.0g scalar($ML_f)
end


program define RescEqs, rclass
	local log `1'
	return scalar rescaled = 0
	if $ML_n == 1 {
		exit
	}
	`log' di in gr "rescaling equations " _c
	local i 1
	while `i' <= $ML_n {
		RescEq `i' `log'
		return scalar rescaled = return(rescaled) | r(rescaled)
		local i = `i' + 1
	}
	`log' di
end

program define RescEq, rclass
	local i `1'
	local log `2'

	local sc = ${ML_fp`i'}
	local ec = ${ML_lp`i'}

	tempname b0 f0 sb0
	mat `b0' = $ML_b
	scalar `f0' = scalar($ML_f)

	return scalar rescaled = 0
	mat `sb0' = $ML_b[1,`sc'..`ec']
	mat `sb0' = .5 * `sb0'
	scalar $ML_f = .
	mat sub $ML_b[1,`sc'] = `sb0'
	$ML_eval 0
	if scalar($ML_f!=. & $ML_f>`f0' & reldif($ML_f,`f0')>1e-12) {
		return scalar rescaled = 1
		while scalar($ML_f!=. & $ML_f>`f0' & /*
		*/ reldif($ML_f,`f0')>1e-12) {
			`log' di "+" _c
			mat `b0' = $ML_b
			scalar `f0' = scalar($ML_f)
			mat `sb0' = .5 * `sb0'
			mat sub $ML_b[1,`sc'] = `sb0'
			$ML_eval 0
		}
		qui {
			mat `sb0' = 2 * `sb0'
			tempvar sizevar
			mat score double `sizevar' = `sb0' if $ML_samp
			summarize `sizevar' if $ML_samp, meanonly
			local size = r(mean)
			drop `sizevar'
		}
		if abs(`size')<1e-8 {
			`log' di in gr "." _n "sign reverse " in ye "+" _c
			mat `sb0' = -4 * `sb0'
			mat sub $ML_b[1,`sc'] = `sb0'
			$ML_eval 0
			while scalar($ML_f!=. & $ML_f>`f0' & /*
			*/ reldif($ML_f,`f0')>1e-12) {
				`log' di "+" _c
				mat `b0' = $ML_b
				scalar `f0' = scalar($ML_f)
				mat `sb0' = 2 * `sb0'
				mat sub $ML_b[1,`sc'] = `sb0'
				$ML_eval 0
			}
		}
	}
	else {
		`log' di in gr "." _c
		scalar $ML_f = .
		mat `sb0' = 4 * `sb0'
		mat sub $ML_b[1,`sc'] = `sb0'
		$ML_eval 0
		while scalar($ML_f)!=. & scalar($ML_f)>`f0' {
			return scalar rescaled = 1
			`log' di "+" _c
			mat `b0' = $ML_b
			scalar `f0' = scalar($ML_f)
			mat `sb0' = 2 * `sb0'
			mat sub $ML_b[1,`sc'] = `sb0'
			$ML_eval 0
		}
	}
	`log' di in gr "." _c
	mat $ML_b = `b0'
	scalar $ML_f = `f0'
end


program define Rescale /* `log' */
	local log `1'


	`log' di in gr "rescaling entire vector " _c
	if $ML_n == 1 {
		RescEq 1 `log'
		`log' di
		exit
	}


	tempname b0 f0
	mat `b0' = $ML_b
	scalar `f0' = scalar($ML_f)
	scalar $ML_f = .
	mat $ML_b = .5 * $ML_b
	$ML_eval 0
	if scalar($ML_f)!=. & scalar($ML_f)>`f0' {
		while scalar($ML_f)!=. & scalar($ML_f)>`f0' {
			`log' di "+" _c
			mat `b0' = $ML_b
			scalar `f0' = scalar($ML_f)
			mat $ML_b = .5 * $ML_b
			$ML_eval 0
		}
	}
	else {
		`log' di in gr "." _c
		scalar $ML_f = .
		mat $ML_b = 2 * `b0'
		$ML_eval 0
		while scalar($ML_f)!=. & scalar($ML_f)>`f0' {
			`log' di "+" _c
			mat `b0' = $ML_b
			scalar `f0' = scalar($ML_f)
			mat $ML_b = 2 * $ML_b
			$ML_eval 0
		}
	}
	`log' di in gr "."
	mat $ML_b = `b0'
	scalar $ML_f = `f0'
end


program define FindBett /* # `log' */
	local n `1'
	local log `2'

	if `n'==0 { exit }

	tempname lastb lastf
	mat `lastb' = $ML_b
	scalar `lastf' = scalar($ML_f)

	`log' di in gr "improving initial values " _c
	local i 1
	while `i' <= `n' {
		TryRdm 1 *
		if scalar($ML_f)!=. & scalar($ML_f)>`lastf' {
			`log' di "+" _c
			mat `lastb' = $ML_b
			scalar `lastf' = scalar($ML_f)
		}
		else {
			`log' di in gr "." _c
		}
		local i = `i' + 1
	}
	mat $ML_b = `lastb'
	scalar $ML_f = `lastf'
	`log' di _n in gr "$ML_crtyp = " in ye %10.0g scalar($ML_f)
	exit
end

program define FindFeas /* #_maxfeas `log' `restart' */
	local maxfeas `1'
	local log `2'
	local restart `3'

	`log' di in gr "searching for feasible values " _c

	if "`restart'"=="" {
		TryCons "`log'" /* .5 1.25 2.5 10 -.5 -1.25 -2.5 -10 */
	}
	if scalar($ML_f)==. {
		Random first `maxfeas' `log'
		* TryRdm `maxfeas' `log'
		if scalar($ML_f)==. {
			di in red _n "could not find feasible values"
			exit 491
		}
	}
	`log' di
end

/*
program define TryCons /* `log' #-list */
	local log `1'
	mac shift
	while "`1'"!="" {
		SetCons `1'
		$ML_eval 0
		if scalar($ML_f)!=. {
			`log' di "+"
			exit
		}
		`log' di in gr "." _c
		mac shift
	}
end
*/

program define TryCons /* `log' */
	local log "`1'"
	BestCons "`log'" -.5 .5
	BestCons "`log'" -1.25 1.25
	BestCons "`log'" -2.5 2.5
	BestCons "`log'" -10 10
end


program define BestCons /* `log' #-list */
	local log `1'

	if scalar($ML_f)!=. { exit }

	tempname f0
	mac shift
	SetCons `1'
	$ML_eval 0
	scalar `f0' = scalar($ML_f)
	if `f0'!=. {
		`log' di "+" _c
	}
	local bestcon `1'
	mac shift
	while "`1'"!="" {
		SetCons `1'
		$ML_eval 0
		if scalar($ML_f)!=. & (scalar($ML_f)>`f0' | `f0'==.) {
			scalar `f0' = scalar($ML_f)
			local bestcon `1'
			`log' di "+" _c
		}
		else {
			`log' di in gr "." _c
		}
		mac shift
	}
	SetCons `bestcon'
	scalar $ML_f = `f0' 	/* which may be missing */
end


program define Random /* {first|best} #_to_try `log' */
	local rule "`1'"
	local n `2'
	local log "`3'"

	if "`rule'"=="best" {
		tempvar f_best b_best
		scalar `f_best' = scalar($ML_f)
		mat `b_best' = $ML_b
	}

	local range "1 5 10 25 100 1000"
	local nr 6
	local ir 1
	local k 1
	while `k' <= `n' {
		ml init
		local i 1
		local defr : word `ir' of `range'
		while `i' <= $ML_n {
			if "${ML_lb`i'}"=="" {
				local z = uniform()*2*`defr' + `defr'
			}
			else	local z = uniform()*(${ML_ub`i'}-${ML_lb`i'}) /*
					*/ + ${ML_lb`i'}
			SetEqCon `i' `z'
			local i = `i' + 1
		}
		$ML_eval 0
		if scalar($ML_f)!=. {
			if "`rule'"=="first" {
				`log' di "+" _c
				`log' di
				exit
			}
			else if scalar($ML_f)>`f_best' {
				`log' di "+" _c
				mat `b_best' = $ML_b
				scalar `f_best' = scalar($ML_f)
			}
			else {
				`log' di in gr "." _c
			}

		}
		else {
			`log' di in gr "." _c
		}
		local ir = `ir' + 1
		if `ir' > `nr' {
			local ir 1
		}
		local k = `k' + 1
	}
	`log' di
	if "`rule'"!="first" {
		mat $ML_b = `b_best'
		scalar $ML_f = `f_best'
	}
end



program define TryRdm /* #_to_try `log' */
	local n 1
	local log "`2'"
	while `n' <= `1' {
		ml init
		local i 1
		while `i' <= $ML_n {
			if "${ML_lb`i'}"=="" {
				local z = (uniform()*2000-1000)
			}
			else	local z = uniform()*(${ML_ub`i'}-${ML_lb`i'}) /*
					*/ + ${ML_lb`i'}
			SetEqCon `i' `z'
			local i = `i' + 1
		}
		`log' di _c in gr "."
		$ML_eval 0
		if scalar($ML_f)!=. { exit }
		local n = `n' + 1
	}
end



program define SetCons /* # */
	local z `1'
	ml init
	local i 1
	while `i' <= $ML_n {
		SetEqCon `i' `z'
		local i = `i' + 1
	}
end



program define SetEqCon /* eqnumber value */
	local i `1'
	local z `2'

	tempvar cons
	tempname b0
	if "${ML_xc`i'}"!="nocons" {
		ml init /${ML_eq`i'} = `z'
	}
	else {
		qui gen `cons' = `z' if $ML_samp
		qui reg `cons' ${ML_x`i'}, nocons
		mat `b0' = get(_b)
		mat coleq `b0' = ${ML_eq`i'}
		ml init `b0'
	}
end


program define FindEq /* eqname */, rclass
	return local k 1
	while `return(k)' <= $ML_n {
		if "`1'" == "${ML_eq`return(k)'}" {
			exit
		}
		return local k = `return(k)' + 1
	}
	di in red "equation `1' not found"
	exit 111
end
exit
