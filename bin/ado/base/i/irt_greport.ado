*! version 1.0.2  03dec2018
program irt_greport
	version 16

	if `"`e(cmd2)'"' != "irt" {
		exit 301
	}

	if "`e(cmd)'" == "estat" {
		Replay `0'
		exit
	}

	if "`e(groupvar)'" == "" {
		error 321
	}
	else	Display `0'
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
			GRWidth(string)		///
			PARMWidth(string)	///
			COEFLegend		/// NULL OPT
			SELEGEND		/// NOT DOCUMENTED
			notable			/// NOT DOCUMENTED
			noHEADer		/// NOT DOCUMENTED
			hybrid			/// NULL OPT
			novce			/// NULL OPT
			Level(string)		/// not allowed
			*			/// est table options
	]

	if `"`sort'"' != "" {
		// creates the following local macros:
		//	sort
		//	descending
		ParseSort `sort'
	}

	if `"`anything'"' != "" {
		di as err "varlist not allowed"
		exit 198
	}
	if `"`level'"' != "" {
		di as err "option {bf:level()} not allowed"
		exit 198
	}
	
	local groupvar `e(groupvar)'
	local groups `e(group_levels)'
	local grlbls `"`e(group_labels)'"'
	local k = e(N_groups)
	
	local verbose verbose
		
	tempname est vlabels
	
	forvalues i =1/`k' {
		local g : word `i' of `groups'
		local gg `"`e(grlabel`g')'"'
		
		if `"`g'"' == `"`gg'"' {
			local estlab `g'.`groupvar'
		}
		else 	local estlab `gg'
		
		local names `names' `estlab'
		
		_est hold `est', copy restore

		mata: _irt_parms_build(`i', "`vlabels'")

		tempname b`i' v`i' Cns`i' pclass`i'
		matrix `b`i'' = r(b)
		matrix `v`i'' = r(V)
		matrix `Cns`i'' = r(Cns)
		matrix `pclass`i'' = r(b_pclass)

		capture postrtoe, resize
		if _rc == 0 {
			if `"`e(alabel)'"' != "" {
				label copy `vlabels' `e(alabel)', eclass
			}
			if `"`e(blabel)'"' != "" {
				label copy `vlabels' `e(blabel)', eclass
			}
			if `"`e(blabel)'"' != "" {
				label copy `vlabels' `e(clabel)', eclass
			}
		}

		tempname m`i'
		
		qui est store `m`i'', label(`estlab')

		_est unhold `est'
		
		local estlist `estlist' `m`i''
		
//		local sort
//		local descending
	}

	// use the last _irt_parms_build() results so that
	// the full set of labels are used by -est table-
	_est hold `est', restore
	qui est restore `m`k''

	local opt plabel(Parameter) modelwidth(`grwidth') ///
		varwidth(`parmwidth') nounderscore nofvnotes
	
	est table `estlist', `opt' `options'
	return add
	
	return local names `names'
	
	tempname coef
	mat `coef' = return(coef)
	return hidden matrix coef = `coef'
	
	if "`post'" != "" {
		_est unhold `est'
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

