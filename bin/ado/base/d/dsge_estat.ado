*! version 2.2.2  07mar2019
program dsge_estat

	version 15 

	if (("`e(cmd)'" != "dsge") & ///
	("`e(cmd)'" != "dsgenl" & "`e(solvetype)'" != "firstorder")) error 301
 
	gettoken subcmd rest : 0, parse(" ,")
	local lkey = length("`subcmd'")
    
	if("`subcmd'"=="transition") {
		_Transition `rest'
	}
	else if("`subcmd'"=="policy") {
		_Policy `rest'
	}
	else if("`subcmd'"=="steady") {
		_Steady`rest'
	}
	else if("`subcmd'"=="stable") {
		_Stable `rest'
	}
	else if ("`subcmd'"=="covariance") {
		_Covariance `rest'
	}
	else if("`subcmd'"=="vce"|"`subcmd'"=="ic") {
		estat_default `subcmd' `rest'
	}
	else if("`subcmd'"== bsubstr("summarize",1,max(2,`lkey'))) {
		local depvars = e(observed)
		estat_summ `depvars'
	}
	else {
		error 321
	}
end

program define _Policy
	syntax [, post *]

	_Policy_work , `options'
	if ("`post'"=="post") {
		postrtoe
	}
end

program define _Policy_work, rclass
	syntax [, COMPact *]
	_get_diopts opts, `options'

	tempname policy
	matrix `policy' = e(policy)
	local hasmissing = matmissing(`policy')
	if (`hasmissing' > 0) {
		error 504
	}
	
	disp _newline(0)
	disp in green "Policy matrix"
	disp _newline(0)
	

	if ("`compact'" != "") {
		_matrix_table e(policy)

		tempname gx_b p
		matrix `p' = e(policy)
		matrix `gx_b' = vec(e(policy)')'
		return matrix b = `gx_b'
		return matrix policy = `p'
	}
	else {
		tempname gx_b gx_V mainest b V p
		matrix `gx_b' = vec(e(policy)')'
		matrix `gx_V' = e(po_deriv)*e(V)*e(po_deriv)'
		local thestripe: colfullnames `gx_b'
		matrix rownames `gx_V' = `thestripe'
		matrix colnames `gx_V' = `thestripe'
		matrix `b' = `gx_b'
		matrix `V' = `gx_V'

		local n = `:colsof `gx_V''
		local notefl=0
		forvalues i = 1/`n' {
			if (`gx_V'[`i',`i'] < 2.2e-16) {
				matrix `gx_V'[`i',`i'] = 0
				local notefl = 1
			}
		}

		_estimates hold `mainest'

		local vn "constrained policy matrix values"
		cap nois break {
			_Post, b(`gx_b') vce(`gx_V')
			_Display, `opts'

			if (`notefl'==1) {
				di as txt "{p 0 6 2}"
				di as txt "Note: Standard errors reported"
				di as txt "as missing for"
				di as txt "{help j_dsgenl_steady:`vn'}."
				di as txt "{p_end}"
			}
		}
		local rc = _rc
		_estimates unhold `mainest'
		if `rc' {
			exit `rc'
		}
		matrix `p' = e(policy)
		return matrix b = `b'
		return matrix V = `V'
		return matrix policy = `p'
	}
end

program define _Transition
	syntax [, post *]

	_Transition_work , `options'
	if ("`post'"=="post") {
		postrtoe
	}
end

program define _Transition_work, rclass
	syntax [, COMPact *]
	_get_diopts opts, `options'

	tempname transition 
	matrix `transition' = e(transition)
	local hasmissing = matmissing(`transition')
	if (`hasmissing' > 0) {
		error 504
	}

	disp _newline(0)
	disp in green "Transition matrix of state variables"
	disp _newline(0)
	
	if ("`compact'" != "") {
		_matrix_table e(transition)
		tempname gx_b t
		matrix `t' = e(transition)
		matrix `gx_b' = vec(e(transition)')'
		return matrix b = `gx_b'
		return matrix transition = `t'
	}
	else {
		tempname hx_b hx_V mainest b V t
		matrix `hx_b' = vec(e(transition)')'
		matrix `hx_V' = e(tr_deriv)*e(V)*e(tr_deriv)'
		local thestripe: colfullnames `hx_b'
		matrix rownames `hx_V' = `thestripe'
		matrix colnames `hx_V' = `thestripe'
		matrix `b' = `hx_b'
		matrix `V' = `hx_V'
		
		local n = `:colsof `hx_V''
		local notefl=0
		forvalues i = 1/`n' {
			if (`hx_V'[`i',`i'] < 2.2e-16) {
				matrix `hx_V'[`i',`i'] = 0
				local notefl=1
			}
		}

		_estimates hold `mainest'
		local vn "constrained transition matrix values"
		cap nois break {
			_Post, b(`hx_b') vce(`hx_V')
			_Display, `opts'

			if (`notefl'==1) {
				di as txt "{p 0 6 2}"
				di as txt "Note: Standard errors reported"
				di as txt "as missing for"
				di as txt "{help j_dsgenl_steady:`vn'}."
				di as txt "{p_end}"
			}
		}
		local rc = _rc
		_estimates unhold `mainest'
		if `rc' {
			exit `rc'
		}
		matrix `t' = e(transition)
		return matrix b = `b'
		return matrix V = `V'
		return matrix transition = `t'
	}

end

program define _Stable, rclass

	syntax [, *]

	display _newline(0)

	tempname values urtest
	matrix `values' = e(eigenvalues)

	mata: st_numscalar("`urtest'",		///
		min(abs(st_matrix("e(eigenvalues)") :- 1)))
	local uroot = `urtest' < 1e-13

	local k_states = e(k_state)
	local k_stable = e(k_stable)

	local title "Stability results"
	matlist `values'', 			///
		border(top bottom)		///
		twidth(10) 			///
		title(`title')			///
		format(%12.4g)
	if `k_states'!=`k_stable' {
		local not "not "
	}
	local note "The process is `not'saddle-path stable"
	display "{p 0 4}`note'.{p_end}"

	if ("`not'" != "") {
		local k_unstable = colsof(`values') - `k_states'
		local note "The process is saddle-path stable when "
		local note "`note'there are `k_states' stable eigenvalues "
		local note "`note'and `k_unstable' unstable eigenvalues"
		display "{p 0 4}`note'.{p_end}"
	}
	
	if `uroot' {
		local note "There may be a unit root in the model.  "
		local note "`note'Unit roots caused by nonstationary state "
		local note "`note'variables are not allowed."
		display as txt "{p 0 4}Warning: `note'{p_end}"
	}

	local issta = ((`k_states' == `k_stable'))
	return scalar stable = `issta'
	return matrix eigenvalues = `values'

end


program define _Steady, rclass

	syntax  [, COMPACT compare(string) format(string) *]

	if (e(cmd)=="dsge") {
		di as err "{bf:estat steady} only available after" _cont
		di as err " {bf:dsgenl}"
		exit 321
	}
	
	_get_diopts opts, `options'
	if ("`format'"=="") {
		local format "%7.2f"
	}

	disp _newline(0)
	disp in green "Location of model steady-state"
	disp _newline(0)
	
	tempname steady
	matrix `steady' = e(steady)
	matrix colnames `steady' = `"`"Coef."'"'

	if ("`compare'" != "" & "`compact'" == "") {
		di as err "option {bf:compare()} must be specified " _cont
		di as err "with option {bf: compact}"
		exit 198
	}
	
	if ("`compare'" != "") {
		matrix yssvar = `steady'["`compare'",1]
		scalar yss    = yssvar[1,1]
		matrix relss  = `steady' / yss
		matrix colnames relss = relss
		
		matrix `steady' = (`steady', relss)
	}

	if ("`compact'" != "") {
		_matrix_table `steady', format(`format' `format')
	}
	else {
		tempname b V mainest
		matrix `b'          = e(steady)'
		matrix `V'          = e(st_deriv)*e(V)*e(st_deriv)'
		matrix colnames `V' = `:colnames `b''
		matrix rownames `V' = `:colnames `b''
		_estimates hold `mainest'
		cap nois break {
			_Post, b(`b') vce(`V')
			_Display, `opts'
			local v "constrained steady-state values"

			di as txt "{p 0 6 2}"
			di as txt "Note: Standard errors "
			di as txt "reported as missing for "
			di as txt "{help j_dsgenl_steady:`v'}."
			di as txt "{p_end}"
		}
		local rc = _rc
		_estimates unhold `mainest'
		if `rc' {
			exit `rc'
		}
	}

	return matrix steady = `steady'

end



program define _Covariance
	syntax [anything] [, post *]

	_Covariance_work `anything' , `options'
	if ("`post'"=="post") {
		postrtoe
	}
end

program define _Covariance_work, rclass
	syntax [anything] [, ADDCOVariance(string) NOCOVariance * ]
	
	_get_diopts opts, `options'

	local variance "`anything'"

	if (("`addcovariance'" != "") & ("`nocovariance'" != "")) {
		opts_exclusive "addcovariance() nocovariance"
	}

	if ("`nocovariance'" == "") {
		local co "co"
	}
	else {
		local co ""
	}
	
	disp _newline(0)
	disp in green "Estimated `co'variances of model variables"
	disp _newline(0)

	tempname gx hx et Q
        matrix `gx' = e(policy)
        matrix `hx' = e(transition)
        matrix `et' = e(shock_coeff)
	matrix `Q' = `et'*`et''

	// get Sigx
	tempname Sigx Sigy0 Sigy1
	local sH st_matrix("`hx'")
	local sQ st_matrix("`Q'")
	local op luinv(I(rows(`sH')^2)-`sH'#`sH')*vec(`sQ')
	mata: st_matrix("`Sigx'", colshape(`op', rows(`sH')))
	
	// get Sigy
	matrix `Sigy0' = `gx'*`Sigx'*`gx''
	matrix `Sigy0' = 0.5*(`Sigy0' + `Sigy0'')

	// Get Sigy1
	matrix `Sigy1' = `gx'*`hx'*`Sigx'*`gx''
	matrix `Sigy1' = 0.5*(`Sigy1' + `Sigy1'')
	
	local c1: colsof e(policy)
	local r1: rowsof e(policy)
	local c2: colsof e(transition)
	local r2: rowsof e(transition)
	local c3: colsof e(shock_coeff)
	local r3: rowsof e(shock_coeff)
	tempname gxd hxd shd
	mata: st_matrix("`gxd'", Kmatrix(`c1',`r1')*st_matrix("e(po_deriv)"))
	mata: st_matrix("`hxd'", Kmatrix(`c2',`r2')*st_matrix("e(tr_deriv)"))
	mata: st_matrix("`shd'", Kmatrix(`c3',`r3')*st_matrix("e(sh_deriv)"))

	// Derivative of Sigx
	tempname Sigxd
	tempname p1 p2a p2b p2c
	local nx  = e(k_state)
	local ny  = e(k_control)
	local nsh = e(k_shock)

	local nx2 = `nx'^2
	matrix `p1' = inv(I(`nx2') - (`hx'#`hx'))
	matrix `p2a' = ((`hx'*`Sigx')#I(`nx'))*`hxd'
	matrix `p2b' = (I(`nx')#(`hx'*`Sigx'))*e(tr_deriv)
	matrix `p2c' = (I(`nx')#`et')*e(sh_deriv) + (`et'#I(`nx'))*`shd'
	matrix `Sigxd' = `p1'*(`p2a'+`p2b'+`p2c')


	// build (b, V)
	tempname b V mud mud0 mud1
	mata:st_matrix("`b'",vec((st_matrix("`Sigy0'"),st_matrix("`Sigy1'"))))

	matrix `mud0' = (I(`ny')#(`gx'*`Sigx'))*e(po_deriv)  ///
			+ (`gx'#`gx')*`Sigxd'                ///
			+ ((`gx'*`Sigx'')#I(`ny'))*`gxd'

	matrix `mud1' = (I(`ny')#(`gx'*`hx'*`Sigx'))*e(po_deriv)    ///
			+ (`gx'#(`gx'*`hx'))*`Sigxd'                ///
			+ ((`gx'*`Sigx'')#`gx')*`hxd'               ///
			+ ((`gx'*`Sigx''*`hx'')#I(`ny'))*`gxd'
 
	
	matrix `mud' = (`mud0' \ `mud1')
	matrix  `V' = `mud'*e(V)*`mud''

	// build stripe
	local vars: colnames `Sigy0'
	local count: word count `vars'

	local stripe = ""
	forvalues i = 1/`count' {
		local eq: word `i' of `vars'
		forvalues j = 1/`count' {
			if (`i'==`j') {
				local stripe = "`stripe' `eq':var(`eq')"
			}
			else {
				local va: word `j' of `vars'
				local stripe = "`stripe' `eq':cov(`eq',`va')"
			}
		}
	}

	local stripe2 = ""
	forvalues i = 1/`count' {
		local eq: word `i' of `vars'
		forvalues j = 1/`count' {
			local va: word `j' of `vars'
			local stripe2 = "`stripe2' `eq':cov(`eq',L.`va')"
			
		}
	}
	matrix rownames `b' = `stripe' `stripe2'
	matrix colnames `V' = `stripe' `stripe2'
	matrix rownames `V' = `stripe' `stripe2'
	matrix `b' = `b''

	// (b, V) populated and striped

	tempname b2 V2

	// obtain lists containing desired elements
	if ("`variance'" == "") {
		local init = e(control)
		local addcovariance : list addcovariance - init
	}
	else {
		local init = "`variance'"
		local addcovariance : list addcovariance - init
	}
	if ("`variance'"=="" & "`addcovariance'"=="" & "`nocovariance'"=="") {
		local con = e(control)
		local nc: word count `con'
		forvalues i = 1/`nc' {
			forvalues j = `i'/`nc' {
				local n = `nc'*(`i'-1) + `j'
				local l2 = "`l2', `n'"
			}
		}
		local l2 = substr("`l2'",2,.)          // numeric
		
		local l1 ""
		local rest = "`con'"
		foreach c of local con {
			local l1 "`l1' (`c' `rest') "
			gettoken first rest: rest
		}
		_parse_anything `l1'
		local list = r(list)                   // stripes
	}
	else {
		if ("`variance'"=="") {
			local variance = e(control)
		}
		if ("`addcovariance'" == "") {
			local addcovariance = "`variance'"
		}
		else {
			local addcovariance = "`variance' `addcovariance'"
		}
		if ("`nocovariance'"=="nocovariance") {
			local addcovariance = ""
		}

		_get_list, var(`variance') cov(`addcovariance')
		local anything = r(toget)
		_dups `anything'
		_parse_anything `anything'
		local list = r(list)    // stripes
		local l2 = r(add)       // numeric
	}
	
	capture {
		mata: st_matrix("`b2'",(st_matrix("`b'"))[1,(`l2')])
	}
	if (_rc) error 111
	mata: st_matrix("`V2'",(st_matrix("`V'"))[(`l2'),(`l2')])
	matrix colnames `b2' = `list'   // restripe
	matrix colnames `V2' = `list'
	matrix rownames `V2' = `list'
	matrix `b' = `b2'
	matrix `V' = `V2'

	tempname main
	_estimates hold `main'
	cap nois break {
                _Post, b(`b') vce(`V')
                _Display, `opts'
        }
        local rc = _rc
        _estimates unhold `main'
        if `rc' {
                exit `rc'
        }

	return matrix b = `b2'
	return matrix V = `V2'
end


program define _get_list, rclass
	syntax [, var(string) cov(string)]
	
	local var: list uniq var
	local cov: list uniq cov
	local toget = ""
	foreach v of local var {
		local rhs = "`v' `cov'"
		local rhs: list uniq rhs
		local toget = "`toget' (`v' `rhs')"
	}
	return local toget  "`toget'"

end






program define _dups
	syntax anything
	
	local depv = ""
	
	while ("`anything'" != "") {
		gettoken eq anything: anything, match(paren) bind
		local first: word 1 of `eq'
		local depv "`depv' `first'"
	}
	local c1: word count `depv'
	local c2: word count `:list uniq depv'
	if (`c1' != `c2') {
		di as err "repeated comparison variable"
		exit 198

	}
end

program define _parse_anything, rclass
	syntax [anything]

	gettoken first rest: anything, parse(" ") match(paren) bind

	local con = e(control)
	local nc: word count `con'
	tempname conmat
	matrix `conmat' = 1
	forvalues i = 2/`nc' {
		matrix `conmat' = (`conmat', `i')
	}
	forvalues i = 1/`nc' {
		local j = `i'+`nc'^2
		matrix `conmat' = (`conmat', `j')
		local lname = "`lname' L.`:word `i' of 	`con''"
	}
	matrix colnames `conmat' = `con' `lname'

	local list = ""
	local add  = ""
	_parse_eqn `first'
	local lista = r(list)
	local list = "`list' `lista'"
	_numer_eqn `first', mat(`conmat')
	local adda = r(add)
	local add = "`add' `adda'" 
	while ("`rest'" != "") {
		gettoken first rest: rest, match(paren) bind
		_parse_eqn `first'
		local lista = r(list)
		local list = "`list' `lista'"

		_numer_eqn `first', mat(`conmat')
		local adda = r(add)
		local add = "`add'  `adda'" 
	}
	local add = strtrim("`add'")
	local add = substr("`add'", 2, .)

	return local list `list'
	return local add  `add'
end

program define _parse_eqn, rclass
	syntax anything

	gettoken first rest: anything, parse(" ")
	local rest: list uniq rest
	if ("`rest'"=="") {
		error 198
	}

	local list ""
	foreach w of local rest {
		if ("`w'"=="`first'") {
			local list "`list' `first':var(`w') "
		}
		else {
			local list "`list' `first':cov(`first',`w') "
		}
	}
	return local list  `list'
end

program define _numer_eqn, rclass
	syntax anything, mat(string)

	gettoken first rest: anything, parse(" ")
	local rest: list uniq rest

	tempname fi se
	local con = e(control) 
	local nc: word count `con'
	matrix `fi' = `mat'[1,"`first'"]
	scalar `fi' = el(`fi',1,1)
	foreach w of local rest {
		matrix `se' =  `mat'[1, "`w'"]
		scalar `se' = el(`se',1,1)
	
		local co = `fi'
		local ro = `se'
		local cur =  `nc'*(`co'-1)+`ro'
		local add = "`add', `cur'"
	}
	return local add = "`add'"
end


program define _Post, eclass
	syntax, b(string) vce(string)
	ereturn post `b' `vce'
	ereturn local vcetype = "Delta-method"

end

program define _Display
	syntax [, *]
	_get_diopts opts, `options'
	ereturn display, `opts'
end





