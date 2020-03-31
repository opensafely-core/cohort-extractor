*! version 1.2.4  16feb2015
program define xttab, byable(recall) sort rclass
	version 6.0, missing
	syntax varlist(max=1) [if] [in] [, I(varname)]
	_xt, i(`i')
	local ivar "`r(ivar)'"

	local typ : type `varlist'
	if bsubstr("`typ'",1,3)=="str" { 
		di in red "`varlist' must be numeric"
		exit 109
	}

	preserve

	tempvar touse freqo freqb freqw nivar ni
	mark `touse' `if' `in'
	markout `touse' `varlist' `ivar'
	qui sum if `touse'== 1
	if r(N)==0 {
		noi di in red "no observations"
		exit 2000
	}
	local v "`varlist'"

	quietly { 
		keep if `touse'
		keep `v' `ivar'

		tempname outm 

		sort `ivar' `v'
		by `ivar': gen `c(obs_t)' `nivar' = _N
		by `ivar': gen byte `ni'=1 if _n==_N
		summ `ni'
		local N = r(sum)
		drop `ni' 
		by `ivar' `v': gen double `freqw' = _N/`nivar'

		sort `v' `ivar'
		by `v' `ivar': gen byte `ni'=1 if _n==_N
		replace `freqw' = . if `ni'!=1
		by `v': replace `freqw' = sum(`freqw')
		by `v' `ivar': replace `nivar' = 0 if _n!=_N
		by `v': replace `nivar' = sum(`nivar')

		by `v': gen `c(obs_t)' `freqo' = _N
		local Nv = _N
		by `v' `ivar': gen `c(obs_t)' `freqb' = 1 if _n==_N
		by `v': replace `freqb'=sum(`freqb')
		by `v': replace `freqb' = `freqb'[_N] 
		by `v':  keep if _n==_N
		replace `freqw' = `freqw'/`freqb'

		drop `ni' 
	}
	
	qui gen long `ni' = sum(`freqb')

	tempvar old
	qui gen `old' = `v'
	local vlab : value label `v'
	if "`vlab'"!="" { 
		tempvar new
		decode `v', gen(`new') maxlen(8)
		local v `new'
	}

	di _n _skip(18) in gr "Overall" _skip(13) "Between" _skip(12) "Within"
	di in smcl in gr %9s abbrev("`varlist'",9) /*
	*/ " {c |}    Freq.  Percent" _skip(6) "Freq.  Percent" /*
	*/ _skip(8) "Percent"
	di in smcl in gr "{hline 10}{c +}{hline 53}"


	matrix `outm' = J(_N+1, 6, .)
	local labs "value Overall:Freq Overall:Percent Between:Freq"
	local labs "`labs' Between:Percent Within:Percent"
	matrix colnames `outm' = `labs'
	local _N = _N
	forvalues i=1/`_N' {
		local stub = `v'[`i']
		if "`new'" != "" {
			local distub %9s "`stub'"
		}
		else {
			local distub %9.0g `stub' 
		}
		matrix `outm'[`i', 1] = `old'[`i'] 
		matrix `outm'[`i', 2] = `freqo'[`i'] 
		matrix `outm'[`i', 3] = 100*`freqo'[`i']/`Nv'
		matrix `outm'[`i', 4] = `freqb'[`i'] 
		matrix `outm'[`i', 5] = 100*`freqb'[`i']/`N' /*`ni'[_N]*/ 
		matrix `outm'[`i', 6] = 100*`freqw'[`i']

		di in smcl in gr `distub' " {c |}" in ye 	/*
		*/ %8.0f  `outm'[`i',2] 			/*
		*/ %10.2f `outm'[`i',3] 			/*
		*/ %10.0f `outm'[`i',4] 			/* 
		*/ %10.2f `outm'[`i',5] " "			/* 
		*/ %14.2f `outm'[`i',6]
	}

	tempvar overp 	
	quietly {
		gen double `overp'= sum( /*
			*/ (`freqb'/`ni'[_N])*100*(`freqw') /*
			*/ )
		replace `freqo'=sum(`freqo')
		replace `freqb'=sum(`freqb')

	}
	local np1 = _N+1
	matrix `outm'[`np1', 2] = `freqo'[_N] 
	matrix `outm'[`np1', 3] = 100
	matrix `outm'[`np1', 4] = `freqb'[_N] 
	matrix `outm'[`np1', 5] = 100*`freqb'[_N]/`N' 
	matrix `outm'[`np1', 6] = `overp'[_N]

	di in smcl in gr "{hline 10}{c +}{hline 53}"
	di in smcl in gr "    Total {c |}" in ye 	/*
		*/ %8.0f `outm'[`np1',2] 		/*
		*/ %10.2f 100            		/*
		*/ %10.0f `outm'[`np1', 4] 		/* 
		*/ %10.2f `outm'[`np1', 5] " "		/* 
		*/ %14.2f `outm'[`np1', 6]
	local base : di "(n = " `N'
	local col = 40 - length("`base'")
	di in gr _col(`col') "(n = " in ye `N' in gr ")"

	return matrix results = `outm'
	return scalar n  = `N'
end
exit
