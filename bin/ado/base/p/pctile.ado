*! version 1.2.2  28jun2017
program define pctile, sort
	version 8 , born(01jul2003) missing /* require updated executable
					because _pctile limit changed */
        version 6.0, missing 	/* but then set back version just in case */
        
					/* parse weights if any */
        _parsewt "aweight fweight pweight" `0' 
        local wt "`s(weight)'" /* contains [weight=exp] or nothing */
	local 0 `"`s(newcmd)'"'

        tempvar touse q

	nobreak {
		syntax newvarname(gen) =/exp [if] [in] [, /*
        	*/ Nquantiles(integer 2) ALTdef Genp(string) ]
		rename `varlist' `q'
	}

	if `"`wt'"'!="" & "`altdef'"!="" {
		di in red "altdef option cannot be used with weights"
		exit 198
	}
        if `nquanti' < 2 {
                di in red "nquantiles() must be greater than or equal to 2"
                exit 198
        }
        if `nquanti' > _N + 1 {
                di in red "nquantiles() must be less than or equal to " /*
                */ "number of observations plus one"
                exit 198
        }
	if "`genp'"!="" {
		confirm new variable `genp'
		local nvar : word count `genp'
		if `nvar' > 1 {
			di in red "only one variable allowed in genp()"
			exit 198
		}
	}

/* Set up variable to give quantiles. */
        
        capture confirm variable `exp'
        if _rc {
		tempvar x
		qui gen double `x' = `exp'
        }
        else	local x `"`exp'"'

/* Mark/markout. */
        
        mark `touse' `wt' `if' `in'
        markout `touse' `x'

	qui count if `touse'
	if r(N) == 0 { error 2000 }
        
/* Get quantiles. */

	local last = `nquanti' - 1

	if `nquanti' <= 1001 {
		_pctile `x' `wt' if `touse', n(`nquanti') `altdef'
		local k 1
		while `k' <= `last' {
			qui replace `q' = r(r`k') in `k'
			local k = `k' + 1
		}
	}
	else {
		tempvar k
		qui gen `c(obs_t)' `k' = _n in 1/`last'
		local iold 1
		local j 1
		local i 1
		while `i' <= `last' {
			local pct = 100*`i'/`nquanti' 
			if "`plist'"=="" { local plist "`pct'" }
			else		   local plist "`plist',`pct'"

			if `j' == 1000 | `i' == `last' {
				_pctile `x' `wt' if `touse', p(`plist') `altdef'
				local k1 1
				local k2 `iold'
				while `k2' <= `i' {
					qui replace `q' = r(r`k1') if `k'==`k2'
					local k1 = `k1' + 1
					local k2 = `k2' + 1
				}
				local plist
				local iold = `i' + 1
				local j 1
			}
			local j = `j' + 1
			local i = `i' + 1
		}
	}

        label var `q' "percentiles of `exp'"
        rename `q' `varlist'
	if "`genp'"!="" {
		qui gen float `genp' = 100*_n/`nquanti' in 1/`last'
		label var `genp' "percentages for `q'"
	}
end
 
