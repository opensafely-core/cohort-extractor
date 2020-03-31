*! version 2.1.7  17sep2004
program define cusum_7, rclass sort
	version 6, missing

	syntax varlist(min=2 max=2 numeric) [if] [in] [, /*
		*/ YFit(varname) noGraph noCAlc GENerate(string) /*
		*/ Symbol(string) Connect(string) * ]
	local gen `"`generat'"'
	if "`gen'"!="" { confirm new var `gen' }
	marksample touse
	markout `touse' `yfit'

	tokenize `varlist'
	tempvar y x cusum
	quietly {
		gen `y' = `1' if `touse'
		gen `x' = `2' if `touse' 
		sum `x' if `touse'
		local obs = r(N)
                if `obs'<3 { exit 2001 }
		local jx = .00001*(r(max)-r(min))
/*
	To avoid ties and ensure a unique sort order for x,
	randomly jitter x by .00001 times its range using a fixed seed
	Answer: No, setting the seed screws up Monte Carlo experiments.
*/
		replace `x' = `x'+uniform()*`jx'
		sort `x'
		sum `y'
		local mean = r(mean)
		if r(min)<0 | r(max)>1 {
			di in red "Yvar has values outside range [0,1]"
			exit 459
		}
		if "`yfit'"!="" {
			gen `cusum' = sum(`yfit'-`y')
		}
		else 	gen `cusum' = sum(`mean'-`y')
		local cl : variable label `1'
		if `"`cl'"'=="" { local cl "`1'" }
		label var `cusum' `"Cusum (`cl')"'
                _crcslbl `x' `2'
	}
	if "`graph'"==""  {
		local symbol = cond("`symbol'"=="", ".", "`symbol'")
		local connect = cond("`connect'"=="", "l", "`connect'")
		gr7 `cusum' `x', s(`symbol') c(`connect') `options'
	}
	ret scalar N = `obs'
	ret scalar prop1 = `mean'
	global S_1 `obs'    /* double save in S_# and r() */
	global S_2 `mean'
	if "`calc'"==""  {
		/*
			P value for linear and quadratic cusums.
			Note that in log(cusum)-X*log(n), X is about pi/6.
		*/
		quietly {
			sum `cusum'
			local mcusl = max(-r(min), r(max))
			local lp = -abs(ln(`mean'/(1-`mean')))
			local mcusm = -1.0605-((`lp')^2)*(0.12684+0.010437*`lp')
			local mcuss = 0.3130+0.004261*`lp'
			local zl = (ln(`mcusl')-0.5236*log(`obs')-`mcusm') /*
			 */ /`mcuss'
			replace `y' = `cusum'-`cusum'[`obs'-_n]
			sum `y'
			local mcusq = max(-r(min), r(max))
			local mcusm = -1.1196-((`lp')^2)*(0.12093+0.009744*`lp')
			local mcuss = 0.3269+0.006547*`lp'
			local zq = (log(`mcusq')-0.5236*log(`obs')-`mcusm') /*
			 */ /`mcuss'
		}
		#delimit ;
		di in smcl in gr _n "Variable {c |}   Obs"
		 "{col 21}Pr(1)"
		 "{col 29}CusumL"
		 "{col 39}zL"
		 "{col 45}Pr>zL"
		 "{col 53}CusumQ"
		 "{col 63}zQ"
		 "{col 69}Pr>zQ" _n
		 "{hline 9}{c +}{hline 63}"
		;
		di in smcl in gr %8s abbrev("`1'",8) " {c |}"
		in ye
		 %6.0f `obs'
		 %9.4f `mean'
		 %9.2f `mcusl'
		 %8.3f `zl'
		 %7.3f normprob(-`zl')
		 %9.2f `mcusq'
		 %8.3f `zq'
		 %7.3f  normprob(-`zq') ;
		#delimit cr
		ret scalar cusuml = `mcusl'
		ret scalar zl = `zl'
		ret scalar P_zl = normprob(-`zl')
		ret scalar cusumq = `mcusq'
		ret scalar zq = `zq'
		ret scalar P_zq = normprob(-`zq')
		global S_3 `mcusl'        /* double save in S_# and r() */
		global S_4 `zl'
		global S_5 `return(P_zl)'
		global S_6 `mcusq'
		global S_7 `zq'
		global S_8 `return(P_zq)'
	}
	if "`gen'"!="" { 
		qui replace `cusum' = . if !`touse'
		rename `cusum' `gen' 
	}
end
