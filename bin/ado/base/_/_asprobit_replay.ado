*! version 1.4.2  07mar2018
*  asmprobit and asroprobit replay program

program _asprobit_replay
	syntax [, Level(cilevel) *]

	_get_diopts diopts, `options' level(`level')

	local ncov = e(k_rho)+e(k_sigma)
	local ncasecf : word count `"`e(casevars)'"'
	local const = `e(const)' != 0
	local ncasecf = `ncasecf' + `const'

	local noheader noheader 
	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + ///
		bsubstr(`"`e(crittype)'"',2,.)
	di _n in gr `"`e(title)'"' _col(48) "Number of obs" _col(67) "= " ///
	 in ye %10.0gc e(N)
	di in gr `"Case ID variable: `=abbrev("`e(case)'",24)'"' _col(48) /// ID
	 "Number of cases" _col(67) "= " in ye %10.0gc e(N_case) 
	if ("`e(cmd)'"=="asroprobit" & e(N_ties) > 0)            ///
		di in gr _col(48) "Number of ties" _col(67) "= " ///
		in ye %10.0g e(N_ties) 
	di
	local altvar `=abbrev("`e(altvar)'",17)'
	di in gr `"Alternatives variable: `altvar'"' _col(48)              /// Alternatives
	 "Alts per case: min = " in ye %10.0g e(alt_min) _n _col(63) in gr ///
	 "avg = " in ye %10.1fc e(alt_avg) _n _col(63) in gr "max = "       ///
	 in ye %10.0gc e(alt_max)
	local lencr = length("`e(crittype)'")
	if ("`e(mc_method)'" != "") {
/****************************************************************************/
local sk = `lencr'-length("`e(mc_method)'") - 8
di in smcl in gr "Integration sequence:" _skip(`sk') "`e(mc_method)'" 
local sk = `lencr'-21
local intpoints ///
	`""Integration points:" _skip(`sk') in ye %15.0g `=e(mc_points)'"'
/****************************************************************************/
	}
	else local intpoints _n

	if "`e(chi2type)'" == "Wald" {
		local stat chi2
        	local cfmt=cond(e(chi2)<1e+7,"%10.2f","%10.3e")
       		if e(chi2) >= . {
			local h help j_robustsingular:
			di in gr `intpoints' in gr _col(51)    ///
			 "{`h'Wald chi2(`e(df_m)'){col 67}= }" ///
			 in ye `cfmt' e(chi2)
       		}
        	else {
			di in gr `intpoints' in gr _col(51)     	   ///
			 "`e(chi2type)' chi2(" in ye "`e(df_m)'" in gr ")" ///
			 _col(67) "= " in ye `cfmt' e(chi2)
       		}
	}
	else {
		/* F statistic from test after _robust */
		local stat F
		local cfmt=cond(e(F)<1e+7,"%10.2f","%10.3e")
		if e(F) < . {
			di in gr `intpoints' in gr _col(51) 		///
			 "F(" in ye %3.0f e(df_m) in gr "," in ye %6.0f ///
			 e(df_r) in gr ")" _col(67) "= " in ye `cfmt' e(F)
		}
		else {
			local dfm = e(df_m)
			local dfr = e(df_r)
			local h help j_robustsingular:

			di in gr `intpoints' in gr _col(51) ///
			 "{`h'F( `dfm', `dfr')}" _col(67) "{`h'=          .}"
		}
	}
	di in gr "`crtype' = " in ye %10.0g e(ll) _col(51) in gr ///
	 "Prob > `stat'" _col(67) "= "  in ye %10.4f e(p) _n

	_coef_table, cmdextras `diopts'

	if e(k_alt) > 2 {
		local i = `e(i_base)'
		local base `"`e(alt`i')'"'
		local base = abbrev(`"`macval(base)'"', 17)
		if `:list sizeof base' > 1 {
			local base `""`macval(base)'""'
		}
        	di in gr `"{p}(`altvar'=`macval(base)' is the alternative "' ///
		 `"normalizing location){p_end}"'
		if (`e(i_scale)' < .) {
			local i = `e(i_scale)'
			local scale `"`e(alt`i')'"'
			local scale = abbrev(`"`macval(scale)'"', 17)
			if `:list sizeof scale' > 1 {
				local scale `""`macval(scale)'""'
			}
		        di in gr `"{p}(`altvar'=`macval(scale)' is the "' ///
			 `"alternative normalizing scale){p_end}"'
		}
	}
	ml_footnote
end

exit
