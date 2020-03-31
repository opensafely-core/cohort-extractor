*! version 1.0.4  03apr2009
program define anova_terms , rclass
	version 8

	if "`e(cmd)'" != "anova" & "`e(cmd)'" != "manova" {
		error 301
	}

	if "`e(version)'`e(cmd)'" == "2anova" | ///
			"`e(version)'`e(cmd)'" == "2manova" {
		// modern (m)anova: uses # instead of * and doesn't have cont()
		local old "*"	// comment out "old" code
	}
	else {
		local new "*"	// comment out "new" code
	}

	local noconst "noconstant"  /* noconstant until proven otherwise */
	anovadef, alt
	local i 1
	local tname `r(tn`i')'

	while "`tname'" != "" {
		/* with new (m)anova the constant will not be first in list */
		if "`tname'" == "1" { /* there is a constant in the model */
			local noconst
			local i = `i' + 1
			local tname `r(tn`i')'
		}

		local tlev `r(tl`i')'

		if "`tname'" != "`prevname'" {
			if "`tlev'" == "c" {
				AddUniq cterms "`tname'" "`cterms'"
				local rhs `rhs' `tname'
			}
			else {
				local n : word count `tname'
				local aterm : word 1 of `tname'
				local alev : word 1 of `tlev'
				if "`alev'" == "c" {
					AddUniq cterms "`aterm'" "`cterms'"
				}
				forvalues j = 2/`n' {
					local item : word `j' of `tname'
`old'					local aterm "`aterm'*`item'"
`new'					local aterm "`aterm'#`item'"
					local alev : word `j' of `tlev'
					if "`alev'" == "c" {
						AddUniq cterms "`item'" /*
							*/ "`cterms'"
					}
				}

				local rhs `rhs' `aterm'
			}
		}


		local prevname `tname'
		local i = `i' + 1
		local tname `r(tn`i')'
	}

	local opts `noconst'
	// version 2 (m)anova  (stata >= 11) does not use the cont() option
	if "`cterms'" != "" {
`old'		local opts `opts' cont(`cterms')
	}

	return local continuous `cterms'
	return local opts `opts'
	return local rhs `rhs'
end


program define AddUniq /* lclmacname item list */
	args lclmacname item list
	foreach x of local list {
		if "`x'" == "`item'" {
			local found 1
			continue, break
		}
	}
	if "`found'" == "" {
		if "`list'" == "" {
			c_local `lclmacname' "`item'"
		}
		else {
			c_local `lclmacname' "`list' `item'"
		}
	}
	else {
		c_local `lclmacname' "`list'"
	}
end

