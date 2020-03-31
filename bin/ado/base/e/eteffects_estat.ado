*! version 1.0.2  21jul2015

program define eteffects_estat
	version 14
	
        if "`e(cmd)'" != "eteffects" {
                di as err "{help eteffects##_new:eteffects} estimation " ///
                 "results not found"
                exit 301
        }
	
	gettoken sub rest: 0, parse(" ,")
	local lsub = length("`sub'")
	
	if ("`sub'" == bsubstr("endogenous",1,max(5,`lsub'))){
		EstatEndog `"`0'"'
	}
	else if ("`e(stat)'"=="pomeans") {
		estat_default `0'
	}
	else EstatSummarize `"`0'"'
	
end	

/* special handling of the ATE & ATT contrast style equation            */

program define EstatSummarize, eclass
        args options

        tempname b b0 V V0

        mat `b' = e(b)
        mat `V' = e(V)
        local names : colnames `b'
        local tlevels `e(tlevels)'
        local control = e(control)
        local tlevnoc : list tlevels - control

        forvalues i=1/`=e(k_levels)-1' {
                local nm : word `i' of `names'
                local lev : word `i' of `tlevnoc'
                gettoken r var: nm, parse(".")

                local names : subinstr local names "`r'" "`lev'" 
        }
        local names : subinstr local names "r`control'" "`control'" 
        mat `b0' = `b'
        mat `V0' = `V'

        mat colnames `b' = `names'
        mat colnames `V' = `names'
        mat rownames `V' = `names'
        nobreak {
                ereturn repost b=`b' V=`V', rename

                estat_default `options'

                ereturn repost b=`b0' V=`V0', rename
        }
end

program EstatEndog, rclass

	quietly capture test  _b[TEOM0:_cons] =  _b[TEOM1:_cons] = 0
	
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	
	di
	di as text _col(3) "Test of endogeneity"
	di as text _col(3) "Ho: treatment and outcome unobservables" ///
				" are uncorrelated"
	di			
	di as txt _col(12) "chi2(" %3.0f `df' ") =" as res %8.2f `chi2'
	di as txt _col(10) "Prob > chi2 =  " as res %8.4f `p'

	return scalar chi2 = `chi2'
	return scalar df   = `df'
	return scalar p    = `p'
end 

exit
