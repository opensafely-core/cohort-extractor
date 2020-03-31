*! version 1.0.2  15oct2019
program ca_p
	version 8

	if "`e(cmd)'" != "ca" {
		error 301
	}

	if "`e(ca_data)'" == "matrix" {
		dis as err "predict not available after camat"
		exit 321
	}

	#del ;
	syntax newvarlist(max=1 numeric) [if] [in] 
	[, 
		Fit 
		ROWscore(str) 
		COLscore(str)
	] ;
	#del cr

	local nstat = ("`fit'"!="") + (`"`rowscore'"'!="") + (`"`colscore'"'!="")
	if `nstat' == 0 { 
		dis as txt "(option {bf:fit} assumed)"
		local fit fit
	}
	else if `nstat' > 1 { 
		dis as err "options are exclusive"
		exit 198
	}

	if `"`rowscore'`colscore'"' != "" { 
		confirm integer number `rowscore' `colscore' 
		if !inrange(`rowscore' `colscore', 1, `e(f)') { 
			dis as err "dimension out of range"
			exit 198
		}
	}

	marksample touse, novarlist

// recreate 1/2/3... coded row and column classification variables 

	tempvar r_i c_j f rc Coding

	local nr = colsof(e(Rcoding)) 
	local nc = colsof(e(Ccoding))
	local nf = e(f)

	matrix `Coding' = e(Rcoding)' 
	qui _applycoding `r_i' if `touse', coding(`Coding') miss

	matrix `Coding' = e(Ccoding)' 
	qui _applycoding `c_j' if `touse', coding(`Coding') miss

// predict variables

	if "`fit'" != "" { 
		gen double `f' = 0 
		forvalues k = 1 / `nf' {
			qui replace `f' = `f' + el(e(Sv),1,`k') * /// 
			   el(e(R),`r_i',`k') * el(e(C),`c_j',`k')
		}
		qui gen double `rc' = el(e(r),`r_i',1) * el(e(c),`c_j',1)
		qui replace `f' = `rc' + sqrt(`rc') * `f'

		gen `typlist' `varlist' = `f' if `touse' 
		label var `varlist' "predicted values" 
		exit
	}

	if "`rowscore'" != "" { 
		gen `typlist' `varlist' = el(e(TR),`r_i',`rowscore') if `touse'
		label var `varlist' "`e(Rname)' score(`rowscore') in `e(norm)' norm." 
		exit
	}

	if "`colscore'" != "" { 
		gen `typlist' `varlist' = el(e(TC),`c_j',`colscore') if `touse' 
		label var `varlist' "`e(Cname)' score(`colscore') in `e(norm)' norm." 
		exit
	}
end
exit
