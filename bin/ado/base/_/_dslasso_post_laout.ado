*! version 1.0.2  28may2019
program _dslasso_post_laout, eclass
	version 16.0
	syntax , laout_name(string) 	///
		[subspace_list(string)	///	
		inst_vars(string) 	///
		tt_vars(string)		///
		exog(string)		///
		iv]
						//  lasso selection 
	local i = 1
	foreach sub of local subspace_list {
		laout_estat info `laout_name', subspace(`sub')
		local depvar_i `r(depvar)'
		local selected_indeps_i `r(selected_indeps)'
		local sel_p_i = r(selected_p)
		local lasso_selection_i `r(lasso_selection)'

		local unique : list unique | selected_indeps_i

		eret hidden local lasso_depvar_`i' `depvar_i'
		eret hidden local lasso_selected_`i' `selected_indeps_i'
		eret hidden scalar lasso_sel_p_`i' = `sel_p_i'
		eret hidden local lasso_selection_`i' `lasso_selection_i'
		local lasso_depvars `lasso_depvars' `depvar_i'
		local i = `i' + 1
	}

	eret local lasso_depvars `lasso_depvars'

	local tmp : list sort unique
	local unique : list tmp - tt_vars
						
	local uniq_inst : list unique & inst_vars
	local uniq_controls : list unique - uniq_inst

	local uniq_controls : list uniq_controls - exog
	local uniq_inst : list uniq_inst - exog

	eret local controls_sel `uniq_controls'
	eret scalar k_controls_sel = `:list sizeof uniq_controls'

	if (`"`iv'"' != "") {
		eret local inst_sel `uniq_inst'
		eret scalar k_inst_sel = `:list sizeof uniq_inst'
	}

	eret hidden local subspace_list `subspace_list'
	eret hidden local laout_name `laout_name'
end
