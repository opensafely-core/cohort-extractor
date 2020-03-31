*! version 1.0.0  07jan2020
program meta__set_transf_label

	version 16.1
	syntax [, tr_fn(string) fnlbl(string) iscumul(real 0) isover(real 0) ///
		hidestudies(real 0)]

	
	if `"`tr_fn'"' == `"tanh"' {
		local leftlbl "tanh(theta)"
		local fn "tanh"
		local toplbl  ""
	} 
	else if `"`tr_fn'"' == `"exp"'  {
		local leftlbl "exp(theta)"
		local fn "exp"	
		local estype : char _dta[_meta_estype]
		if "`estype'" == "lnrratio" {
			local fnlbl = cond(missing(`"`fnlbl'"'), "Risk Ratio", ///
				`"`fnlbl'"')
		} 
		else if "`estype'" == "lnoratio" {
			local fnlbl = cond(missing(`"`fnlbl'"'), "Odds Ratio", ///
				`"`fnlbl'"')
		}  
	}
	else if `"`tr_fn'"' == `"invlogit"'  {
		local leftlbl "invlogit(theta)"
		local fn "invlogit"
	}
	else if `"`tr_fn'"' == `"efficacy"'  {
		local leftlbl "1 - exp(theta)"
		local fnlbl = cond(missing(`"`fnlbl'"'),"Efficacy",`"`fnlbl'"')
		local fn "1 - exp"
	}
	else if `"`tr_fn'"' == `"corr"'  {
		local leftlbl "tanh(theta)"
		local fnlbl = cond(missing(`"`fnlbl'"'),"Correlation",`"`fnlbl'"')
		local fn "tanh"
	}

	// will handle undoc f(@) cases
	if missing("`fn'") {
		local fn "f"
		local leftlbl "f(theta)"
	}
	
	local abvtbl_l = cond(`hidestudies', `"`fn'(theta)"', ///
		cond(`=`iscumul'+`isover'', `"`fn'(theta)"', `"`fn'(ES)"'))
	local toplbl = cond(missing(`"`fnlbl'"'), "`abvtbl_l'", `"`fnlbl'"')
	
	local eslab_fp `"`toplbl'"'
	
	// 12 is width of 1st col in -meta summ, nostudies- output
	if ((("`fn'" == "f") | (ustrlen(`"`leftlbl'"') > 12)) & `hidestudies') {
		local leftlbl "f(theta)"
		local abvtbl_l = cond(missing(`"`fnlbl'"'), "f(@)", ///
			cond(ustrlen(`"`fnlbl'"') < 12, "f(@)", "f(theta)"))
	}
	
	if (`iscumul' & ((ustrlen(`"`toplbl'"') > 12) | ("`fn'" == "f"))) {
		local toplbl = cond(ustrlen(`"`toplbl'"') > 12, "f(theta)", ///
			"`toplbl'")
		local abvtbl_l = cond(missing(`"`fnlbl'"'), "f(@)", ///
			cond(ustrlen(`"`fnlbl'"') < 12, "f(@)", "f(theta)"))	
	}
	
	c_local fp_eslab `"`eslab_fp'"'	
	c_local l_eslab	 `"`leftlbl'"'
	c_local t_eslab  `"`toplbl'"'
	c_local abvtbl_l `"`abvtbl_l'"'
	c_local fnlbl 	 `"`fnlbl'"'
end
