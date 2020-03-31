*! version 1.0.0  06dec2017

program _bayes_model_headers, sclass

	args mcmcobject model
	
	if ("`model'"=="mlogit") {
		mata: `mcmcobject'.set_eq_base(`e(k_eq_base)', `"`e(baselab)'"')
		local headerstr1 = `""Base outcome: " as res "`e(baselab)'""'
	}
	else if ("`model'"=="mprobit") {
		mata: `mcmcobject'.set_eq_base(`e(k_eq_base)', `"`e(out`e(k_eq_base)')'"')
		local headerstr1 = `""Base outcome: " as res "`e(out`e(k_eq_base)')'""'
	}
	else if ("`model'"=="glm" | "`model'"=="binreg") {
		local cnames = "`e(varfunct)'"
		if "`e(varfunct)'" == "Binomial" {
			local cnames binomial `e(m)'
		}
		_bayes_family_title "`cnames'"
		local cnames `r(cnames)'
		local len = 0
		local headerstr1 = `""Family" _skip(`len') as txt " : " as res "`cnames'""'
		local cnames = lower("`e(linkt)'")
		if ("`cnames'"=="power" | "`cnames'"=="power(-2)") {
			local cnames power `e(power)'
		}
		else if ("`cnames'"=="odds power") {
			local cnames `cnames' `e(power)'
		}
		local len = 2
		local headerstr2 = `""Link" _skip(`len') as txt " : " as res "`cnames'""'
	}
	else if ("`model'"=="betareg") {
		local cnames = lower("`e(linkt)'")
		local headerstr1 = `""Link function" _skip(1) as txt " : " as res "`cnames'""'
		local cnames = lower("`e(slinkt)'")
		local headerstr2 = `""Slink function" _skip(0) as txt " : " as res "`cnames'""'
	}
	else if ("`model'"=="nbreg") {
		local disp `e(dispers)'
		local len = 10-bstrlen(`"`disp'"')
		if `len' < 0 local len 0
		local headerstr3 = `""Dispersion" _skip(13) " = " _skip(`len') as res "`disp'""'
	}
	else if ("`model'"=="tnbreg") {
		local headerstr1 = `""Truncation point: " as res "`e(llopt)'""'
		local disp `e(dispers)'
		local len = 10-bstrlen(`"`disp'"')
		if `len' < 0 local len 0
		local headerstr3 = `""Dispersion" _skip(13) " = " _skip(`len') as res "`disp'""'
	}
	else if ("`model'"=="zinb" || "`model'"=="zip") {
		local headerstr1 = `""Inflation model: " as res "`e(inflate)'""'
	}

	if ("`model'"=="truncreg") {
		local ll = `"`e(llopt)'"'
		if `"`ll'"' == "" {
			local ll = "-inf"
		}
		local ul = `"`e(ulopt)'"'
		if `"`ul'"' == "" {
			local ul = "+inf"
		}
	}
	else if ("`model'"=="tpoisson") {
		local ll `e(limit_l)'
		local ul `e(limit_u)'
	}
	if ("`model'"=="truncreg" | "`model'"=="tpoisson") {
		// ll after -tpoisson- may contain smcl tags
		local len = 10-bstrlen(smcl2txt(`"`ll'"'))
		if `len' < 0 local len 0
		local headerstr1 = `""Limits:" _skip(1) "lower = " _skip(`len') as res "`ll'""'
		local len = 10-bstrlen(`"`ul'"')
		if `len' < 0 local len 0
		local headerstr2 = `"_skip(8) "upper = " _skip(`len') as res "`ul'""'
	}
	
	sreturn local headerstr1 = `"`headerstr1'"'
	sreturn local headerstr2 = `"`headerstr2'"'
	sreturn local headerstr3 = `"`headerstr3'"'
end
