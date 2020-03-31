*! version 1.4.8  14dec1998 updated 12aug2019
program define hlu, eclass
	version 6.0
	local options `"Level(int $S_level) noDW"'
	if bsubstr(`"`1'"',1,1)==`","' | `"`1'"'==`""' { 
		if `"`e(cmd)'"'!=`"hlu"' { error 301 } 
		parse
	}
	else {
		syntax varlist [if] [in] [, `options' /* 
			*/ noLOg T(string) TOl(real .001) /* 
			*/ Iterate(integer 100) FORCE ]

		tempfile HLUITR
		tempvar X RES LRES DW
		tempname lest
		if `"`log'"'!=`""' { local log `"*"' } 
		else local log `"noisily di"'

                xt_tis `t'
                local tvar `"`s(timevar)'"'

		preserve
		quietly {
			tempvar touse
                        mark `touse' `if' `in'
                        markout `touse' `varlist' `tvar'
                        drop if `touse'==0
			sort `tvar'
			keep `varlist' `tvar' 
			noisily confirm new var _inter
			if `"`force'"' == `""' {
				tempvar td
				gen double `td' = `tvar'-`tvar'[_n-1]
				summ `td', meanonly
				if r(min) != r(max) {
					noi di in red /*
*/ `"`tvar' is not regularly spaced -- use the force option to override"'
					exit 198
				}
                                if r(min) == 0 {
                                        noi di in red /*
					*/ `"`tvar' has duplicate values"'
                                        exit 198
                                }
				capture drop `td'
			}
			save `"`HLUITR'"' , replace
			`log' in gr `"Iteration 0:  rho = "' in ye `"0.0000"'
			regress `varlist'

                        predict double `RES', resid
                        gen double `DW'=/*
                        */ sum((`RES'-`RES'[_n-1])^2)/sum(`RES'*`RES')
                        local dwo = `DW'[_N]
			drop `RES'

			local rhol = 0.0
			local ssel = e(rss)
			use `"`HLUITR'"', clear
			`log' in gr `"Iteration 1:  rho = "' in ye `"0.9999"'
			local rhoh = .9999
			gen double _inter = 1 - `rhoh'
			tokenize `varlist'
			local depv = `"`1'"'
			while `"`1'"'!=`""' {
				gen float `X'=`1'-(`rhoh')*`1'[_n-1]
				drop `1'
				rename `X' `1'
				mac shift
			}
			regress `varlist' _inter, hascons
                        predict double `RES', resid

                        gen double `LRES' = `RES'[_n-1]
                        regress `RES' `LRES', nocons
			local sseh = e(rss)
			local rhom = (`rhoh'+`rhol')/2
			local srho = _se[`LRES']
			local lrho = 2
			local i = 2
			use `"`HLUITR'"', clear
                        while (`i' < `iterate' & abs(`rhom'-`lrho')>`tol') {
				`log' in gr `"Iteration `i':  rho = "' /*
				*/ in ye %6.4f `rhom'
				gen _inter = 1 - `rhom'
				tokenize `varlist'
				while `"`1'"'!=`""' {
					gen float `X'=`1'-(`rhom')*`1'[_n-1]
					drop `1'
					rename `X' `1'
					mac shift
				}
				regress `varlist' _inter, hascons
				local ssem = e(rss)


				if `ssel'<=`ssem' & `ssel'<=`sseh' {
					local rhoh = `rhom'
					local sseh = `ssem'
				}
				else if `sseh'<=`ssem' & `sseh'<=`ssel' {
					local rhol = `rhom'
					local ssel = `ssem'
				}
				else if `ssel'<=`sseh' {
					local rhoh = `rhom'
					local sseh = `ssem'
				}
				else {
					local rhol = `rhom'
					local ssel = `ssem'
				}
				use `"`HLUITR'"', clear
				gen _inter=1
                                predict double `RES', resid
                                gen double `LRES' = `RES'[_n-1]
				local lrho = `rhom'
				local rhom = (`rhoh'+`rhol')/2
                                capture estimates drop `lest'
                                estimates hold `lest'
                                regress `RES' `LRES', nocons
                                drop _inter `RES' `LRES'
				local i = `i'+1
			}
			local nobs = e(N)
			local dof = e(df_r)
			local srho = _se[`LRES']
			if `"`dw'"'==`""' {
                                local nvar : word count `varlist'
                                local i 1
                                while `i' <= `nvar' {
                                local v : word `i' of `varlist'
                                        tempvar v`i'
                                        gen double `v`i'' = `v' - /*
					*/ `rhom'*`v'[_n-1]
                                        local vlist `"`vlist' `v`i''"'
                                        local i = `i'+1
                                }
                                reg `vlist'
                                tempvar e en ed
                                predict double `e', res
                                local i 1
                                while `i' <= `nvar' {
                                local v : word `i' of `varlist'
                                        drop `v`i''
                                        local i = `i'+1
                                }
                                gen double `en' = (`e'[_n+1]-`e')^2
                                gen double `ed' = (`e')^2
                                summ `en', meanonly
                                local nn = r(mean)*r(N)
                                summ `ed', meanonly
                                local nd = r(mean)*r(N)
			}
			estimate unhold `lest'
			est scalar rho = `rhom'
			est scalar se_rho = `srho'
			est scalar df_r = `dof'
			est local depvar `"`depv'"'
			est scalar N = `nobs'
			/* double save in S_E_ and e() */
			global S_E_rho = `rhom'
			global S_E_srho = `srho'
			global S_E_tdf = `dof'
			global S_E_depv = `"`depv'"'
			global S_E_vl `"`varlist'"'
			global S_E_if `"`if'"'
			global S_E_in `"`in'"'
			global S_E_nobs = `nobs'
                        if `"`dw'"' == `""' {
				est scalar dw = `nn'/`nd'
				est scalar dw_o = `dwo'
                                global S_E_dw = e(dw)
                                global S_E_dwo = `dwo'
                        }
			global S_E_cmd "hlu"
			est local cmd "hlu"
		}
	}

        global S_1 = e(rho)
        global S_2 = e(se_rho)
        local trho = e(rho)/e(se_rho)
        local prho = tprob(e(df_r),`trho')
        local invt = invt(e(df_r),`level'/100)

	if `level'<10 | `level'>99 { local level 95 } 

	noisily di _n in gr `"(Hildreth-Lu regression)"'
	noisily regress, level(`level') plus
	noisily di in smcl in gr /*
		*/ `"         rho {c |}"' in ye `"  "' %9.4f e(rho) /*
                */ `"  "' %9.4f e(se_rho) %9.2f `trho'  /*
                */ %8.3f `prho' /*
                */ `"    "' %9.4f e(rho)-`invt'*e(se_rho) /*
                */ `"   "' %9.4f e(rho)+`invt'*e(se_rho) /*
		*/ _n in gr  "{hline 13}{c BT}{hline 64}"
        if `"`e(dw)'"' != `""' & `"`dw'"' == `""' {
                noi di in gr _n `"Durbin-Watson statistic (original)    "' /*
                        */ in ye %8.6f e(dw_o)
                noi di in gr `"Durbin-Watson statistic (transformed) "' /*
                        */ in ye %8.6f e(dw)
        }

end
exit
