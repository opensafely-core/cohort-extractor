*! version 2.0.4  09jul2000
program define runtest, rclass
	version 3.1
	local varlist "req max(1)"
        local in "opt"
        local options "Continuity Drop Mean Split Threshold(str)"
	parse "`*'"
/*
	Determine usable sample.  Quit if any interior missing values.
*/
        if "`drop'"!="" { preserve }
        quietly {
		count if `varlist'!=. `in'
		if r(N)==0 { noi error 2000 } 
		if "`in'"=="" { local in "in f/l" }
		parse "`in'", parse(" /")
		local f "`2'"
		if "`f'"=="f" { local f 1 }
		local l "`4'"
		if "`l'"=="l" { local l = _N }
                while (`varlist'[`f']==.) { local f = `f' + 1 }
                while (`varlist'[`l']==.) { local l = `l' - 1 }
                local in "in `f'/`l'"
		count if `varlist'!=. `in'
		local N = r(N)
		if `N'<2 { 
			noi error 2001
		}
                if (`N'<(`l'-`f'+1)) {
			noi di in re /*
			*/ "`varlist' has internal missing observations"
			exit 498
		}
/*
        Calculate run test.  First calculate the threshold.  By default, 
        use the median.  If the mean option is specified, use the mean
        instead.  If the mean option is not specified, but the threshold
        option, use the threshold expression.
*/
                tempvar thresh
                sum `varlist' `in', d
                local thresh = r(p50)
                if "`mean'"!="" { local thresh = r(mean) }
                else if "`thresho'"!="" { local thresh = `thresho' }
/*
        Now create a binary variable for the "heads" and "tails".  By 
        default, values exactly equal to the threshold are counted as 
        below the threshold.  If the drop option is specified, equal
        values are dropped.  If the split option is specified, equal
        values are randomly split between above and below.
*/
                tempvar sign equal adjust
                if ("`drop'"!="" | "`split'"!="") {
                        gen byte `equal' = `varlist'==`thresh' `in'
                        if "`split'"!="" {              /* split option */
                                local Nequal = 0
                                gen byte `adjust' = uniform()<.5 if `equal' `in'
                        }
                        else {                          /* drop option */
                                count if `equal'
                                local Nequal = r(N)
                                if `Nequal'>0 { 
                                        drop if `equal' `in'
                                        local l = `l' - `Nequal'
                                        local in "in `f'/`l'"
                                        local N = `N'-`Nequal'
		                        if `N'<2 { 
						noi error 2001
                                        }
                                }
                                gen byte `adjust' = 0 if `equal' `in'
		        }
                }
                else {                                  /* default */
                        local Nequal = 0
                        gen byte `equal' = 0 `in'
                        gen byte `adjust' = 0 `in'
                }
                gen byte `sign'=cond(!`equal',`varlist'>`thresh',`adjust') `in'
		sum `varlist'
		tempvar runs
		gen long `runs' = 0 `in'
                local two = `f' + 1
		replace `runs' = `sign'!=`sign'[_n-1] in `two'/`l'
		replace `runs' = sum(`runs') `in'
		local nruns = 1 + `runs'[`l']
                count if !`sign' `in'
		local n0 = r(N)
                count if `sign' `in'
		local n1 = r(N)
		local x = 2*`n0'*`n1'
		local mean = 1 + `x'/(`N')
		local var = `x'*(`x'-`N')/(`N'^2 * (`N'-1))
                local cc = cond("`continu'"=="",0,0.5)
		local zz = (`nruns'-`mean'+`cc')/sqrt(`var')
                local z = sign(`zz')*int(100*abs(`zz')+.5)/100
		local pp = 2*normprob(-abs(`zz'))
		local p = int(100*`pp'+.5)/100
	}
	local abbrev = abbrev("`varlist'",12)
	local col = length("`abbrev'")
        di in gr " N(" in ye "`abbrev'" in gr " <= " in ye "`thresh'" in gr ") = " in ye "`n0'"
        di in gr " N(" in ye "`abbrev'" in gr " >  " in ye "`thresh'" in gr ") = " in ye "`n1'"
	di in gr _col(`col') _skip(7) "obs = " in ye "`N'"
	di in gr _col(`col') _skip(3) "N(runs) = " in ye "`nruns'"
	di in gr _col(`col') _skip(8) "z  = " in ye "`z'"
	di in gr _col(`col') _skip(2) "Prob>|z| = " in ye "`p'"

        return scalar N  = `N'
        return scalar n_runs = `nruns'
        return scalar N_below = `n0'
        return scalar N_above = `n1'
        return scalar mean = `mean'
        return scalar Var = `var'
        return scalar z = `zz'
        return scalar p = `pp'

	/* Double saves */
        mac def S_1 "`return(N)'"
        mac def S_2 "`return(n_runs)'"
        mac def S_3 "`return(N_below)'"
        mac def S_4 "`return(N_above)'"
        mac def S_5 "`return(mean)'"
        mac def S_6 "`return(Var)'"
        mac def S_7 "`return(z)'"
        mac def S_8 "`return(p)'"
end
