*! version 1.1.5  20jul2018
program _labels2eqnames, rclass
	version 11
	syntax varname(numeric) [if] [in] [,	///
		VALues(name)			///
		noLABel				///
		stub(name)			///
		Indexfrom(integer 1)		///
		usprefix			///
		INTegers			///
		EQlist(string)			///
		RENUMber			///
		OLDNAMES			///
	]

	local oldnames : length local oldnames
	if "`stub'" == "" {
		local stub _eq_
	}
	if "`values'" == "" {
		local postvalues 1
		tempname hold values
		_est hold `hold', restore nullok estsystem
		capture _rmcoll `varlist' `if' `in',	///
			noskipline			///
			mlogit
		if c(rc) {
			sum `varlist' `if' `in', mean
			if r(N) == 0 {
				error 2000
			}
			if r(min) != r(max) {
				error c(rc)
			}
			matrix `values' = r(min)
		}
		else	matrix `values' = r(out)
	}
	else {
		local postvalues 0
		confirm matrix `values'
		if rowsof(`values') != 1 {
			di as err "option values() requires a row vector"
			exit 198
		}
	}
	local neq = colsof(`values')

	local usprefix : list sizeof usprefix

	if "`label'" == "" {
		local label : value label `varlist'
		capture label list `label'
		// `label' might be an empty value label name
		if (c(rc)) local label
	}
	else	local label

	local j `indexfrom'
	forval i = 1/`neq' {
		local val = `values'[1,`i']
		if missing(`val') {
			di as err "missing value found in `values' matrix"
			exit 459
		}
		if `:list val in vallist' {
			di as err "repeated values found in `values' matrix"
			exit 459
		}
		local tag
		if "`label'" != "" {
			local lab : label `label' `val' `c(namelenchar)'
			if `oldnames' {
				local hasspace = strpos(`"`macval(lab)'"'," ")
				capture {
					assert `hasspace' == 0
					confirm name `lab'
				}
				if !c(rc) {
					// found a valid name
					local tag `lab'
				}
				else {
					local tag `stub'`j'
				}
			}
		}
		else {
			local lab : copy local val
		}
		if "`tag'" == "" {
		    if "`integers'" != "" {
			capture confirm integer number `lab'
			if !c(rc) &	///
			( ("`renumber'" != "" | string(`val') == "`lab'") ) {
				// found (nonnegative) integer value
				if (`lab' >= 0) {
					local tag : copy local lab
				}
				else if `oldnames' {
					local tag `stub'`j'
				}
			}
		    }
		}
		if "`tag'" == "" {
			if `:list lab == val' | !`:length local lab' {
				local tag : copy local val
			}
			else {
				local tag = ustrtoname(`"`lab'"', `usprefix')
				if `usprefix' == 0 ///
				 & `:length local tag' == c(namelen) {
				    capture confirm name `tag'
				    if c(rc) {
					local tag = ustrtoname(`"`lab'"', 1)
				    }
				}
			}
		}
		if `:list tag in eqlist' {
			local tag `stub'`j'
			while `:list tag in eqlist' {
				local ++j
				local tag `stub'`j'
			}
		}
		local eqlist `eqlist' `tag'
		local labels `"`labels' `"`lab'"'"'
		local vallist `vallist' `val'
		local ++j
	}

	return scalar indexfrom = `j'
	return scalar k_eq = `neq'
	return local eqlist `"`eqlist'"'
	return local labels `"`:list clean labels'"'
	if `postvalues' {
		return matrix values `values'
	}
end

exit
