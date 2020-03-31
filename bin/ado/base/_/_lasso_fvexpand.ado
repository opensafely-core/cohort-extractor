*! version 1.0.1  18may2019
program _lasso_fvexpand, rclass
	version 16.0
	
	syntax [anything(name=myvars)]	///
		[if] [, notransform]
	
	if (`"`transform'"' == "notransform") {
		local is_baseoff = 0
	}
	else {
		local is_baseoff = 1
	}
	
	if (`is_baseoff') {
		set fvbase off
	}

	fvexpand `myvars' `if'
	local varlist `"`r(varlist)'"'

	local hasbase 0
	foreach var of local varlist {
		_ms_parse_parts `var'
		if r(omit) & `is_baseoff' {
			di as txt "`var' omitted"
			continue
		}
		if "`r(type)'" == "interaction" {
			local k = r(k_names)
			forval i = 1/`k' {
				if "`r(base`i')'" != "" {
					// factor - check for base
					if r(base`i') {
						local hasbase 1
						continue, break
					}
				}
			}
		}
		else if "`r(type)'" == "factor" {
			local hasbase = r(base)
		}

		if (`is_baseoff') {
			mata: st_lasso_remove_base("var", "`var'")
		}
		local newvarlist `newvarlist' `var'
	}

	local newvarlist : list uniq newvarlist

	if (`hasbase') {
		di as txt "{p}note:base levels in {it:othervars} ignored{p_end}"
	}

	ret local varlist `newvarlist'
end

mata:
void st_lasso_remove_base(string scalar lmac, string scalar spec)
{
	real	scalar	rc

	rc = _msparse(spec, -2)
	if (rc) exit (rc)

	st_local(lmac, spec)
}

end
