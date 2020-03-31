*! version 1.0.0  04jan2017
program define ivestat, rclass
	version 15 
	_on_colon_parse `0'
	local which `s(before)'
	local options `s(after)'

	/* assumption: options macro starts with a comma		*/
	`which' `options'

	return add 
end

program define Cov, rclass
	syntax, [ * ]

	tempname cov

	if "`e(method)'" == "twostep" {
		di as err "not available after {bf:`e(cmd)', twostep}"
		exit 322
	}

	mat `cov' = e(Sigma)

	Matlist `cov', `options'

	return mat cov = `cov'
end

program define Cor, rclass
	syntax, [ * ]

	tempname cor sig

	if "`e(method)'" == "twostep" {
		di as err "not available after {bf:`e(cmd)', twostep}"
		exit 322
	}

	mat `cor' = e(Sigma)
	local lab : colfullnames `cor'
	mata: st_matrix("`sig'",diag(1:/sqrt(diagonal(st_matrix("`cor'")))))
	mat `cor' = `sig'*`cor'*`sig'
	mat `cor' = 0.5*(`cor'+`cor'')
	mat colnames `cor' = `lab'
	mat rownames `cor' = `lab'

	Matlist `cor', `options'

	return mat cor = `cor'
end

program Matlist
	syntax namelist(min=1 max=1), [ FORmat(passthru) left(integer 2) * ]

	if "`options'" != "" {
		ParseBorder, `options'

		local border `s(border)'
	}
	else {
		local border border(all)
	}
	matlist `namelist', title(`title') `format' `border' left(`left')
end

program define ParseBorder, sclass
	syntax, [ BORder(passthru) * ]

	local 0, `options'
	if "`border'" != "" {
		if "`options'" != "" {
			gettoken options rest : options, bind
			di as err "option `options' not allowed"
			exit 198
		}
	}
	else {
		syntax, [ BORder ]
	}
	sreturn local border `border'
end
exit
