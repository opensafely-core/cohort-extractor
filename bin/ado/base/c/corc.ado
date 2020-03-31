*! version 3.7.2  01sep2000
program define corc, eclass
	version 6.0
	local options `"Level(int $S_level) noDW"'
	if replay() {
		if `"`e(cmd)'"'!=`"corc"' { error 301 } 
		syntax [, `options']
	}
	else { 
		syntax varlist [if] [in]  [, `options' /* 
			*/ T(string) noLOg TOl(real .001) /* 
			*/ Iterate(integer 100) FORCE ]

		tempfile CORCITR
		tempvar X RES LRES DW
		tempvar lest			/* estimates	*/

		if `"`log'"'!=`""' { local log `"*"' } 
		else local log `"noisily di"'

		xt_tis `t'
		local tvar `"`s(timevar)'"'
	
		tempvar touse
		mark `touse' `if' `in'
		markout `touse' `varlist' `tvar'
		preserve
		quietly {
			drop if `touse'==0
			sort `tvar'
			keep `varlist' `tvar' 
			noisily confirm new var _inter
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
			save `"`CORCITR'"', replace
			`log' in gr `"Iteration 0:  rho = "' in ye `"0.0000"'
			regress `varlist' 
			predict double `RES', resid

                        gen double `DW'=/*
                        */ sum((`RES'-`RES'[_n-1])^2)/sum(`RES'*`RES')
			local dwo = `DW'[_N]

			gen double `LRES' = `RES'[_n-1]
			regress `RES' `LRES', nocons
			local rho = _b[`LRES']
			local rrr = `rho'
			use `"`CORCITR'"', clear
			tokenize `varlist'
			local depv `"`1'"'
			local lrho 2
			local i 1
			while (`i' < `iterate' & abs(`rho'-`lrho')>`tol') { 
				`log' in gr /*
				*/ `"Iteration `i':  rho = "' in ye %6.4f `rho'
				gen double _inter = 1 - `rho'
				tokenize `varlist'
				while `"`1'"'!=`""' {
					gen double `X'=`1'-(`rho')*`1'[_n-1]
					drop `1'
					rename `X' `1'
					mac shift
				}
				regress `varlist' _inter, hascons
				use `"`CORCITR'"', clear
				gen _inter=1
				predict double `RES', resid
				gen double `LRES' = `RES'[_n-1]
				local lrho `"`rho'"'
				capture estimates drop `lest'
				estimates hold `lest'
				regress `RES' `LRES', nocons
				local rho = _b[`LRES']
				drop _inter `RES' `LRES'
				local i = `i' + 1 
			}
			local nobs = e(N)
			local rho = _b[`LRES']
			local serho = _se[`LRES']
			local dof = e(df_r)
			if `"`dw'"' == `""' {
				local nvar : word count `varlist'
				local i 1
				while `i' <= `nvar' {
					local v : word `i' of `varlist'
					tempvar v`i'
					gen `v`i'' = `v' - `rho'*`v'[_n-1]
					local vlist `"`vlist' `v`i''"'
					local i = `i'+1
				}
				reg `vlist'
				tempvar e en ed
				predict double `e', res
				local i 1
				while `i' <= `nvar' {
					capture drop `v`i''
					local i = `i'+1
				}
				gen double `en' = (`e'[_n+1]-`e')^2
				gen double `ed' = (`e')^2
				summ `en', meanonly
				local nn = r(sum)
				summ `ed', meanonly
				local nd = r(sum)
			}
			capture estimate unhold `lest'

			/* double save in e() and S_E_<stuff>  */
			est local ll	/* drop what saved by regress */
			est local ll_0	/* drop what saved by regress */
			est scalar N = `nobs'
			est scalar rho = `rho'
			est scalar se_rho = `serho'
			est scalar df_r = `dof'
			est local depvar `"`depv'"'
			global S_E_rho `rho'
			global S_E_srho `serho'
			global S_E_nobs `nobs'
			global S_E_tdf `dof'
			global S_E_depv `"`depv'"'
			global S_E_vl `"`varlist'"'
			global S_E_if `"`if'"'
			global S_E_in `"`in'"'
			if `"`dw'"' == `""' {
				est scalar dw = `nn'/`nd'
				est scalar dw_o = `dwo'
				global S_E_dw = e(dw)
				global S_E_dwo = `dwo'
			}
			restore
			est repost, esample(`touse')
			global S_E_cmd `"corc"'
			est local cmd `"corc"'
		}
	}
	if `level'<10 | `level'>99 { local level 95 } 

	global S_1 = e(rho)
	global S_2 = e(se_rho)
	local trho = e(rho)/e(se_rho)
	local prho = tprob(e(df_r),`trho')
	local invt = invt(e(df_r),`level'/100)

	noisily di _n in gr `"(Cochrane-Orcutt regression)"'
	noisily regress, level(`level') plus
	noisily di in smcl in gr /*
		*/ `"         rho {c |}"' in ye `"  "' %9.4f e(rho) /*
		*/ `"  "' %9.4f e(se_rho) %9.2f `trho'  /*
		*/ %8.3f `prho' /*
		*/ `"    "' %9.4f e(rho)-`invt'*e(se_rho) /*
		*/ `"   "' %9.4f e(rho)+`invt'*e(se_rho) /*
		*/ _n /*
		*/ in gr  "{hline 13}{c BT}{hline 64}"
	if `"e(dw)"' != `""' & `"`dw'"' == `""' {
		noi di in gr _n `"Durbin-Watson statistic (original)    "' /*
			*/ in ye %8.6f e(dw_o)
		noi di in gr `"Durbin-Watson statistic (transformed) "' /*
			*/ in ye %8.6f e(dw)
	}
end
