*! version 1.0.1  23may2019
/*
	laout_estat cvplot, options
*/
					//----------------------------//
					// laout cvplot
					//----------------------------//
program _laout_estat_cvplot
	version 16.0

	laout_estat check_cmd
						//  store eclass results
	tempname est
	qui estimates store `est'
						//  draw CV
	cap noi DrawCV `0'
	local rc = _rc
						//  restore eclass results
	qui estimates restore `est'
	if `rc' exit `rc'
end
					//----------------------------//
					// Draw CV
					//----------------------------//
program DrawCV

	_on_colon_parse `0'
	local before `s(before)'
	local after `s(after)'

	local 0 `before'
	syntax [anything(name=laout_name)] [,subspace_list(string)]

	local 0 `after'
	syntax [anything(everything name=gph_xvar)]	///
		[,name(passthru)			///
		saving(passthru)]

	if (`"`laout_name'"' == "") {
		esrf default_filename
		local laout_name `s(stxer_default)'
	}

	local gph_combine `name' `saving'

	local i = 1
	local good_k = 0
	foreach sub of local subspace_list {
		laout_estat info `laout_name', subspace(`sub')
		local depvar `r(depvar)'

		cap lassograph cvplot `gph_xvar', laout(`laout_name') 	///
			xytitle subspace(`sub')

		if (_rc == 0) {
			local good_k = `good_k' + 1
			local subspace_new_list `subspace_new_list' `sub'
			local lasso_new_depvars `lasso_new_depvars' `depvar'
			local sub_good `sub'
			local xvar `s(xvar)'
		}
		local i = `i' + 1
	}

	if (`"`xvar'"' == "l1normraw01" | `"`xvar'"' == "nlength2") {
		local xscale_com_xvar xscale(off fill)
		local xcommon xcommon
	}
	else {
		local xscale_com_xvar xscale(on)
	}
						// case 1 : no C.V found
	if (`good_k' == 0) {
		di as txt "note: no cross-validation found"	
		exit
		// NotReached
	}
	else if (`good_k' == 1) {		// case 2 : only one C.V
		lassograph cvplot `gph_xvar', laout(`laout_name') 	///
			`subtitle' `gph_combine' subspace(`sub_good')
		exit
		// NotReached
	}

						// case 3: multiple CV
	local i = 1
	local k_laout : list sizeof subspace_new_list
	foreach sub of local subspace_new_list {
		local depvar : word `i' of `lasso_new_depvars'
		local subtitle subtitle(`depvar', box lwidth(none) size(small))
		tempname tmp_name

		if (mod(`i', 2) == 0 | `i' == `k_laout') {
			local xscale xscale(on)
		}
		else {
			local xscale `xscale_com_xvar'
		}
		local extra 			///
			laout(`laout_name')	///
			subspace(`sub')		///
			nodraw			///
			name(`tmp_name')	///
			xtitle("")		///
			ytitle("")		///
			scale(1.5)		///
			`xscale'		///
			`subtitle'
		lassograph cvplot `gph_xvar', `extra'
		local i = `i' + 1
		local gph_list `gph_list' `tmp_name'
	}

	gettoken sub tmp : subspace_new_list

	lassograph cvplot `gph_xvar', laout(`laout_name') xytitle 	///
		subspace(`sub')
	local enp_title `s(enp_title)'

	graph combine `gph_list', `enp_title' colfirst rows(2)	///
			altshrink imargin(zero) `gph_combine' 	///
			`xcommon'
end

