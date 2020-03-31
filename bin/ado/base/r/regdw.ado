*! version 4.1.8  29jan2015
program define regdw, eclass
	version 6.0
	local options `"Level(integer $S_level)"'
	if bsubstr(`"`1'"',1,1)==`","' | `"`1'"'==`""' { 
		if `"`e(cmd)'"'!=`"regdw"' { error 301 } 
		parse
	}
	else { 
		syntax varlist [if] [in] [, `options' T(string) FORCE ]

                xt_tis `t'
                local tvar `"`s(timevar)'"'

		tempvar RES DW
		preserve
		quietly {
                        tempvar touse
                        mark `touse' `if' `in'
                        markout `touse' `varlist' `tvar'
                        drop if `touse'==0
                        sort `tvar'
                        keep `varlist' `tvar'

                        if `"`force'"' == `""' {
                                tempvar td
                                gen `td' = `tvar'-`tvar'[_n-1]
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
                                drop `td'
                        }

			tokenize `varlist'
			local depv `"`1'"'
			regress `varlist', `options'
			local nobs = e(N)
			local dof = e(df_r)
			predict double `RES' `in', res
			capture assert `RES'!=. `in'
			if _rc { 
				noisily di in red `"missing values encountered"'
				exit 412
			}
			gen double `DW'=/*
			*/ sum((`RES'-`RES'[_n-1])^2)/sum(`RES'*`RES')
		}

		est scalar dw   = `DW'[_N]
		est scalar N    = `nobs'
		est scalar df_m = `dof'
		est local cmd     `"regdw"'
		est local depvar  `"`depv'"'
		est local ll
		est local ll_0

		/* Double saves */

		global S_E_dw    `"`e(dw)'"'
		global S_E_nobs  `"`e(N)'"'
		global S_E_tdf   `"`e(df_m)'"'
		global S_E_cmd   `"`e(cmd)'"'
		global S_E_if    `"`if''"'
		global S_E_in    `"`in'"'
		global S_E_vl    `"`varlist'"'
		global S_E_depv  `"`e(depvar)'"'
	}
	if `level'<10 | `level'>99 { local level 95 } 
	global S_1 `e(dw)'	/* may not be needed */
	regress, level(`level')
	di _n in gr `"Durbin-Watson Statistic = "' in ye %9.0g e(dw)
end
