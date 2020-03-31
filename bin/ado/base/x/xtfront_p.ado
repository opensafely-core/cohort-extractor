*! version 1.1.2  04apr2019
program define xtfront_p
        version 8 

		/* Step 1:
			place command-unique options in local myopts
			Note that standard options are
			LR:
				Index XB Cooksd Hat 
				REsiduals RSTAndard RSTUdent
				STDF STDP STDR noOFFset
			SE:
				Index XB STDP noOFFset
		*/

	local myopts "U M TE"

		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/

	_pred_se "`myopts'" `0'
	if `s(done)' {
		exit
	}
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'

		/* Step 3:
			Parse your syntax.
		*/

	syntax [if] [in] [, `myopts']

	marksample touse

        local sumt = ("`u'"!="") + ("`te'"!="") + ("`m'"!="")
        if `sumt' >1 {
                di as err "only one statistic may be specified"
                exit 198
        }
        else { 
                if `sumt' == 0 {
                        local stat "xb"
                        di as txt "(option {bf:xb} assumed; fitted values)"
                }
		else    local stat "`u'`m'`te'"
        }

	Calc `"`vtyp'"' `varn' `stat' `touse'

end

program define Calc, sortpreserve
        args vtyp varn stat cond
                        /* vtyp: type of new variable
                           varn: name of new variable
                           cond: if & in
                           stat: option specified 
                        */

        local y=e(depvar)
        local ivar=e(ivar)
        local by "by `ivar'"
        if "`e(model)'" == "tvd" {
                local tvar=e(tvar)
        }
        if "`e(function)'" == "cost" {
		local COST=-1
	}
        else	local COST=1

        sort `ivar' `tvar' `cond'
                                        /* Predict xb, and get ei */
        tempvar xb res
        qui _predict double `xb' if e(sample), xb
        qui gen double `res'=`y'-`xb' if e(sample)

        if "`stat'"=="xb" {
                qui gen `vtyp' `varn'=`xb' if `cond'
		label var `varn' `"`:var label `xb''"'
                exit
        }
        else {
                tempname sigma_u2 sigma_v2 eta mu       
                scalar `sigma_u2' = e(sigma_u)^2
                scalar `sigma_v2' = e(sigma_v)^2
                scalar `mu' = [mu]_cons
                
                tempvar eta_e eta2 mui sigmai2 expu T
                if "`e(model)'" == "tvd" {
                        scalar `eta' = [eta]_cons
                        qui `by': egen double `T' = max(`tvar') if e(sample)
                        local td `:char _dta[_TSdelta]'
                        if "`td'" == "" {
                        	local td 1
                        }
                        local eta_it (exp(-`eta'*(`tvar'-`T')/`td'))
                }
                else {
                        local eta_it 1        
                }

                quietly {
                        `by': gen double `eta_e' = cond( _n==_N, /*
                        */ sum(`eta_it'*`res'), . ) if e(sample)
                        `by': gen double `eta2' = cond( _n==_N, /*
                        */ sum(`eta_it'^2), . ) if e(sample)
                        gen double `mui' = (`mu'*`sigma_v2' /*
                        */ - `COST'*`eta_e'*`sigma_u2')/(`sigma_v2' /*
                        */ + `eta2'*`sigma_u2') 
                        gen double `sigmai2' = `sigma_v2'*`sigma_u2' /*
                        */ /(`sigma_v2' + `eta2'*`sigma_u2') 
                        `by': replace `mui' = `mui'[_N] if `cond'
                        `by': replace `sigmai2' = `sigmai2'[_N] if `cond'
                        local sigmai (sqrt(`sigmai2'))  
                }
        }

                                        /* Get estimates for u=E(u|e) */
        if "`stat'"=="u" {
                gen `vtyp' `varn' = `mui'+`sigmai' /*
                        */ *normd(-`mui'/`sigmai') /*
                        */ /(1-norm(-`mui'/`sigmai')) if `cond'
		label var `varn' "E(u|e)"
                exit
        }
                                        /* Get estimates for M(u|e) */
        if "`stat'"=="m" {
                qui `by': replace `eta_e' = `eta_e'[_N] if `cond'
                gen `vtyp' `varn' = cond(`mui'>=0, `mui', 0) if `cond'
		label var `varn' "M(u|e)"
                exit
        }
                        /* Get estimates for Technical Efficiency (TE) */
        if "`stat'"=="te" {
                gen `vtyp' `varn' = /*
                        */ (1-norm(`COST'*`eta_it'*`sigmai' /*
                        */ - (`mui'/sqrt(`sigmai2')))) /*
                        */ /(1-norm(-`mui'/sqrt(`sigmai2'))) /*
                        */ *exp(-`COST'*`eta_it'*`mui' /*
                        */ +0.5*`eta_it'^2*`sigmai2') /*
                        */ if `cond'
		label var `varn' "Technical efficiency"
                exit
        }
end
