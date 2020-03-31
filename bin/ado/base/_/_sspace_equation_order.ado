*! version 1.2.0  30nov2010

program define _sspace_equation_order, rclass
	version 11
	syntax, gamma(string) [ state_deps(string) obser_deps(string) ]

	local eqns : coleq `gamma'
	local names : colfullnames `gamma'
	local n : word count `eqns'

	local eqns0 `state_deps' `obser_deps' `eqns'
	local ueqn : list uniq eqns0

	foreach eq of local ueqn {
		forvalues i=1/`n' {
			local eqi : word `i' of `eqns'
			if ("`eq'"=="`eqi'") {
				if ("`ind'"=="") local ind `i'
				else local ind `ind' `i'
			}
		}
	}
	tempname i
	local n : word count `ind'
	mata: `i' = J(1,`n',.)
	tokenize `"`ind'"'
	/* avoid mata literals' limit					*/
	forvalues j=1/`n' {
		mata: `i'[`j'] = ``j''
	}
	mata: st_matrix("`gamma'",st_matrix("`gamma'")[.,`i'])
	mata: st_local("names",invtokens(tokens("`names'")[`i']))
	mata: mata drop `i'

	mat colnames `gamma' = `names'
	if (`=rowsof(`gamma')'==3) mat rownames `gamma' = matno i j
	else mat rownames `gamma' = matno i j order

	return matrix gamma = `gamma'
end

exit
