*! version 2.1.3  28apr2018
program irt_report
	version 14

	if `"`e(cmd2)'"' != "irt" {
		exit 301
	}

	_irtrsm_check
	
	if "`e(cmd)'" == "estat" {
		Replay `0'
		exit
	}

	if "`e(groupvar)'" == "" {
		Display `0'
	}
	else	GDisplay `0'
end

program Replay, rclass
	syntax [, notable noHEADer *]
	_get_diopts diopts, `options'

	if "`table'" == "notable" {
		local qui qui
	}

	if "`e(b_eqmat)'" == "matrix" {
		local eqmat eqmat(e(b_eqmat))
	}

	if "`header'" == "" {
		_coef_table_header
	}
	`qui'				///
	_coef_table,	`eqmat'		///
			showeq		///
			noeqcheck	///
			baselevels	///
			vsquish		///
			`options'
	return add

	tempname t
	matrix `t' = e(b)
	return matrix b `t'
	if "`e(V)'" == "matrix" {
		matrix `t' = e(V)
		return matrix V `t'
	}
	if "`e(V)'" == "matrix" {
		matrix `t' = e(V)
		return matrix V `t'
	}
end

program Display, rclass
	syntax [anything] [,			///
			ALABel(name)		///
			BLABel(name)		///
			CLABel(name)		///
			BYParm			///
			sort(string asis)	///
			verbose			/// NOT DOCUMENTED
			SEQlabel		///
			POST			///
			COEFLegend		///
			SELEGEND		/// NOT DOCUMENTED
			notable			/// NOT DOCUMENTED
			noHEADer		/// NOT DOCUMENTED
			hybrid			/// NULL OPT
			novce			/// NULL OPT
			*			/// display_options
	]

	if `"`sort'"' != "" {
		// creates the following local macros:
		//	sort
		//	descending
		ParseSort `sort'
	}

	_get_diopts diopts, `options'

	tempname x
	local ITEMS `e(item_list)'
	if "`anything'" == "" local anything `ITEMS'
	local dim : list sizeof ITEMS
	matrix `x' = J(1,`dim',0)
	matrix colna `x' = `ITEMS'
	capture _unab `anything', mat(`x')
	if _rc {
		local anything : list uniq anything
		local junk : list anything - ITEMS
		di as err "variable {bf:`junk'} not in the model"
		exit 111
	}
	local anything `r(varlist)'

	local LEGEND `coeflegend' `selegend'
	if "`LEGEND'" != "" & "`post'" == "" {
		di as err ///
		"option {bf:`LEGEND'} not allowed without option {bf:post}"
		exit 198
	}

	if "`table'" == "notable" {
		local qui qui
	}

	tempname b v Cns pclass eq

	// _irt_parms_build() is aware of the following local macros:
	//	anything
	//	alabel
	//	blabel
	//	clabel
	//	byparm
	//	sort
	//	descending
	//	verbose
	//	seqlabel
	//	post

	mata: _irt_parms_build()
	return add

	matrix `b' = return(b)
	matrix `v' = return(V)
	matrix `Cns' = return(Cns)
	matrix `pclass' = return(b_pclass)
	if "`return(eq_models)'" == "matrix" {
		matrix `eq' = return(eq_models)
		local eqmat eqmat(`eq')
	}

	if "`header'" == "" {
		_coef_table_header, nodvheader
	}
	`qui'				///
	_coef_table,	bmat(`b')	///
			vmat(`v')	///
			cnsmat(`Cns')	///
			pclassmat(`pclass') ///
			`eqmat'		///
			showeq		///
			noeqcheck	///
			nocnsreport	///
			baselevels	///
			vsquish		///
			`LEGEND'	///
			`options'
	return add
end

program GDisplay, rclass
	syntax [anything] [,			///
			ALABel(name)		///
			BLABel(name)		///
			CLABel(name)		///
			BYParm			///
			sort(string asis)	///
			verbose			/// NOT DOCUMENTED
			SEQlabel		///
			POST			///
			COEFLegend		///
			SELEGEND		/// NOT DOCUMENTED
			notable			/// NOT DOCUMENTED
			noHEADer		/// NOT DOCUMENTED
			hybrid			/// NULL OPT
			novce			/// NULL OPT
			*			/// display_options
	]

	if `"`sort'"' != "" {
		// creates the following local macros:
		//	sort
		//	descending
		ParseSort `sort'
	}

	_get_diopts diopts, `options'

	tempname x

	local groupvar `e(groupvar)'
	local groups `e(group_levels)'
	local grlbls `"`e(group_labels)'"'
	local grps `groups'
	local k = e(N_groups)
	
	forvalues i =1/`k' {
		local ALLITEMS `ALLITEMS' `e(m`i'_item_list)'
	}
	local ALLITEMS : list uniq ALLITEMS
	if "`anything'" == "" local anything `ALLITEMS'
	local dim : list sizeof ALLITEMS
	matrix `x' = J(1,`dim',0)
	matrix colna `x' = `ALLITEMS'
	capture _unab `anything', mat(`x')
	if _rc {
		local anything : list uniq anything
		local junk : list anything - ALLITEMS
		di as err "variable {bf:`junk'} not in the model"
		exit 111
	}
	local anything `r(varlist)'

	local LEGEND `coeflegend' `selegend'
	if "`LEGEND'" != "" & "`post'" == "" {
		di as err ///
		"option {bf:`LEGEND'} not allowed without option {bf:post}"
		exit 198
	}

	if "`table'" == "notable" {
		local qui qui
	}

	if "`header'" == "" {
		_coef_table_header, nodvheader
	}
	
	tempname b v Cns pclass eq

	// _irt_parms_build() is aware of the following local macros:
	//	anything
	//	alabel
	//	blabel
	//	clabel
	//	byparm
	//	sort
	//	descending
	//	verbose
	//	seqlabel
	//	post

	local anything_o `anything'
	
	local group_levels 

	forvalues i =1/`k' {

		tempname b`i' v`i' Cns`i' pclass`i'

		local gg : word `i' of `grps'
		local g `"`e(grlabel`gg')'"'

		if udstrlen(`"`g'"') > 27 {
			local g = udsubstr(`"`g'"',1,27)
			local g `"`g'.."'
		}
		
		local ITEMS `e(m`i'_item_list)'
		local anything `anything_o'		
		_unab `anything', mat(`x')
		local anything `"`r(varlist)'"'
		local anything : list anything & ITEMS
		if "`anything'" == "" {
			di
			di as txt `"{txt}Group: {res}`g' {txt}(omitted)"'
			continue
		}
		
		di
		di `"{txt}Group: {res}`g'"'
		di
		
		mata: _irt_parms_build(`i')
		return add

		matrix `b' = return(b)
		matrix `v' = return(V)
		matrix `Cns' = return(Cns)
		matrix `pclass' = return(b_pclass)
		
		matrix `b`i'' = `b'
		matrix `v`i'' = `v'
		matrix `Cns`i'' = `Cns'
		matrix `pclass`i'' = `pclass'

		if "`return(eq_models`i')'" == "matrix" {
			matrix `eq' = return(eq_models`i')
			local eqmat eqmat(`eq')
			local neq
		}
		else local eqmat

		`qui'				///
		_coef_table,	bmat(`b')	///
				vmat(`v')	///
				cnsmat(`Cns')	///
				pclassmat(`pclass') ///
				`eqmat'		///
				showeq		///
				noeqcheck	///
				nocnsreport	///
				baselevels	///
				vsquish		///
				`LEGEND'	///
				`options'
		return add
	}
	
	mata: _irt_group_post()
	return add

end

program ParseSort
	capture syntax name(name=ptype id=type) [, Descending]
	if c(rc) {
		di as err "invalid sort() option;"
		syntax name(name=ptype id=type) [, Descending]
		exit 198	// [sic]
	}
	if !inlist("`ptype'", "a", "b", "c") {
		di as err "invalid sort() option;"
		di as err "parameter `ptype' not recognized"
		exit 198
	}
	c_local sort `ptype'
	c_local descending `descending'
end

exit
