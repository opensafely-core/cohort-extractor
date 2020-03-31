*! version 1.0.2  14jun2019
program define lasso_opts_wrk_dlg, sclass
	syntax[, depvar(string) voi(string) defined(string)]

	if ("`depvar'" != "") {
		local lasso_vars "`depvar' `voi'"
		if (strlen(strtrim("`defined'"))==0) {
			sreturn local undefined `"`lasso_vars'"'
		}

		local lasso_vars "`depvar' `voi'"
		local undefined : list lasso_vars - defined
		sreturn local undefined `"`undefined'"'
	}
	else {
		local edep "`e(lasso_depvars)'"
		local dvars : list uniq edep
		sreturn local lasso_depvars `"`dvars'"'
	}
end
