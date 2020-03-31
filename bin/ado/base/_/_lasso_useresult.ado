*! version 1.0.1  21may2019
/*
	_lasso_useresult 
		load esrf transformed dataset into memory
		return new eclass results for laout

	must be called with preserve and restore, old ereturn results must be
	stored.
*/
program _lasso_useresult
	version 16.0

	syntax [, clear laout(string) subspace(string)]

	laout_estat post `laout', subspace(`subspace')

	local cv : char _dta[cv]

	_lasso_get_lchar, subspace(`subspace')
	local coef_name `s(coef_name)'
	local indeps `s(indeps)'

	if (`cv' !=0 & `cv' != 1) {
		di as error "char _dta[cv] is misspecified"
		exit 198
	}

	if (`"`coef_name'"' == "") {
		di as error "char _dta[coef_name] cannot be empty" 
		exit 198
	}
	confirm numeric variable `coef_name', exact

	if (`"`indeps'"' == "") {
		di as error "char _dta[indeps] cannot be empty" 
		exit 198
	}
end
