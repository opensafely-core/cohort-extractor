*! version 1.0.1  20jan2015

/*
	Implements -forecast describe-; called by forecast.ado
*/
program fc_describe

	fc_problem_must_exist describe

	gettoken subcmd rest : 0, parse(" ,")

	local l = strlen("`subcmd'")

	if (`"`subcmd'"' == bsubstr("estimates", 1, max(2,`l'))) {
		fc_desc_estimates `rest'
		exit
	}
	else if (`"`subcmd'"' == bsubstr("exogenous", 1, max(2,`l'))) {
		fc_desc_exogenous `rest'
		exit
	}
					/* identities is undocumented */
	else if ( `"`subcmd'"' == bsubstr("identity", 1, max(2,`l'))	///
		| `"`subcmd'"' == bsubstr("identities", 1, max(,2,`l'))) {
		fc_desc_identity `rest'
		exit
	}
					/* documented as adjust	 */
	else if (`"`subcmd'"' == bsubstr("adjustments", 1, max(2, `l'))) {
		fc_desc_adjust `rest'
		exit
	}
	else if (`"`subcmd'"' == bsubstr("endogenous", 1, max(2, `l'))) {
		fc_desc_endogenous `rest'
		exit
	}
	else if (`"`subcmd'"' == bsubstr("solve", 1, max(2, `l'))) {
		fc_desc_solve `rest'
		exit
	}
	else if (`"`subcmd'"' == bsubstr("coefvector", 1, max(2, `l'))) {
		fc_desc_coefvector `rest'
		exit
	}
					/* _all is undocumented */
					/* Need to allow comma in case
					   options are specified	*/
	else if (`"`subcmd'"' == "" | `"`subcmd'"' == "_all" |		///
		 `"`subcmd'"' == ",") {
		if "`subcmd'" == "," {
			local rest , `rest'
		}
		fc_desc_all `rest'
		exit
	}
	else
		fc_desc_invalid_subcmd `"`subcmd'"'
	}
	
end

program fc_desc_all, rclass
	
	syntax [, Detail Brief]
	
	if "`detail'" != "" & "`brief'" != "" {
		di `isae' "may not specify both {bf:detail} and {bf:brief}"
		exit 198
	}
	
	fc_desc_estimates, `detail' `brief'
	fc_desc_identity, `detail' `brief'
	fc_desc_coefvector, `detail' `brief'
	fc_desc_exogenous, `detail' `brief'
	fc_desc_endogenous, `detail' `brief'
	fc_desc_adjust, `detail' `brief'
	fc_desc_solve, `detail' `brief'
	return clear
end

program fc_desc_estimates, rclass

	syntax	[, Detail Brief]
	
	local isat in smcl as text
	local isae in smcl as err
	
	if "`detail'" != "" & "`brief'" != "" {
		di `isae' "may not specify both {bf:detail} and {bf:brief}"
		exit 198
	}
	
	local nest
	mata:_fc_desc_get_nest("nest")
	
	fc_desc_get_head model head
	
	di
	if `nest' == 0 {
		di `isat' "{p 0 0 0 65}"
		di `isat' "`head'" "contains no estimation results.{p_end}"
		return scalar n_estimates = 0
		return local  model "`model'"
		exit
	}
	
	if `nest' > 1 {
		local s s
	}
	
	di `isat' "{p 0 0 0 65}"
	di `isat' "`head'" "contains {res:`nest'} estimation result`s'" _c
	
	if "`brief'" != "" {
		di `isat' ".{p_end}" 
		return scalar n_estimates = `nest'
		return local  model "`model'"
		exit
	}
	di `isat' ":{p_end}"
	
	local nlhs lhs estnames
	mata:_fc_desc_list_est("`detail'", "nlhs", "lhs", "estnames")
	
	return scalar n_estimates = `nest'
	return scalar n_lhs = `nlhs'
	return local  lhs "`lhs'"
	return local  estimates `"`estnames'"'
	return local  model `model'

end



program fc_desc_exogenous, rclass

	syntax [, Brief Detail]
	
	local isat in smcl as text
	local isae in smcl as err
	
	if "`detail'" != "" & "`brief'" != "" {
		di `isae' "may not specify both {bf:detail} and {bf:brief}"
		exit 198
	}
	
	local nexog
	mata:_fc_desc_get_nexog("nexog")
	
	fc_desc_get_head model head
	
	di
	if `nexog' == 0 {
		di `isat' "{p 0 0 0 65}"
		di `isat' "`head'" "contains no declared exogenous variables."
		di `isat' "{p_end}"
		return scalar n_exogenous = 0
		return local  model "`model'"
		exit
	}
	
	if `nexog' > 1 {
		local s s
	}
	
	di `isat' "{p 0 0 0 65}"
	di `isat' "`head'" _c
	di `isat' "contains {res:`nexog'} declared exogenous variable`s'" _c
	if "`brief'" != "" {
		di `isat' ".{p_end}"
		return scalar n_exogenous = `nexog'
		return local  model "`model'"
		exit
	}
	di `isat' ":{p_end}"
	
	local exoglist
	mata:_fc_desc_list_exog("exoglist")

	return local exogenous `exoglist'
	return local model "`model'"
	return scalar n_exogenous = `nexog'

end



program fc_desc_identity, rclass

	syntax [, Brief Detail]
	
	local isat in smcl as text
	local isae in smcl as err
	
	if "`detail'" != "" & "`brief'" != "" {
		di `isae' "may not specify both {bf:detail} and {bf:brief}"
		exit 198
	}
	
	local niden
	mata:_fc_desc_get_niden("niden")

	fc_desc_get_head model head
	
	di
	if `niden' == 0 {
		di `isat' "{p 0 0 0 65}"
		di `isat' "`head'" "contains no identities.{p_end}"
		return scalar n_identities = 0
		return local model "`model'"
		exit
	}
	
	di `isat' "{p 0 0 0 65}"
	di `isat' "`head'" _c
	if `niden' == 1 {
		di `isat' "contains {res:`niden'} identity" _c
	}
	else {
		di `isat' "contains {res:`niden'} identities" _c
	}
	
	if "`brief'" != "" {
		di `isat' ".{p_end}"
		return scalar n_identities = `niden'
		return local model "`model'"
		exit
	}
	
	di `isat' ":{p_end}"
	
	local vlist
	local idenlist
	mata:_fc_desc_list_iden("`detail'", "vlist", "idenlist")

	return scalar n_identities = `niden'
	return local lhs "`vlist'"
	return local identities "`idenlist'"
	return local model "`model'"
	
end


program fc_desc_adjust, rclass

	syntax [, Brief Detail]
	
	local isat in smcl as text
	local isae in smcl as err
	
	if "`detail'" != "" & "`brief'" != "" {
		di `isae' "may not specify both {bf:detail} and {bf:brief}"
		exit 198
	}
	
	local nadjvar
	local nadjtotal
	mata:_fc_desc_get_nadj("nadjvar", "nadjtotal")

	fc_desc_get_head model head
	
	di
	if `nadjvar' == 0 {
		di `isat' "{p 0 0 0 65}"
		di `isat' "`head'" "contains no variables with adjustments."
		di `isat' "{p_end}"
		return local  model "`model'"
		return scalar n_adjustments = `nadjtotal'
		return scalar n_adjust_vars = `nadjvar'
		exit
	}
	
	di `isat' "{p 0 0 0 65}`head'"
	if `nadjvar' == 1 {
		di `isat' "contains {res:`nadjvar'} adjusted variable with "
	}
	else {
		di `isat' "contains {res:`nadjvar'} adjusted variables with "
	}
	local percol "."
	if "`brief'" == "" local percol ":"
	if `nadjtotal' == 1 {
		di `isat' "{res:`nadjtotal'} adjustment`percol'{p_end}"
	}
	else {
		di `isat' "a total of"
		di `isat' "{res:`nadjtotal'} adjustments`percol'{p_end}"
	}
	
	if "`brief'" != "" {
		return local  model "`model'"
		return scalar n_adjustments = `nadjtotal'
		return scalar n_adjust_vars = `nadjvar'
		exit
	}
	
		/* Say there are three endogenous variables: x, y, and z.
		   x has 0 adjustments, y has 2, and z has 3.
		   Then vlist = "x y z"
		        adjcnt = "0 2 3"
		        adjlist has five elements: "y(1);y(2);z(1);z(2);z(3)"
		        ie adjlist has # elements, where # = total # adj
		*/
	local vlist 	
	local adjcnt
	local adjlist
	mata:_fc_desc_list_adj("`detail'", "vlist", "adjcnt", "adjlist")
	
	return local  model "`model'"
	return local  varlist "`vlist'"
	return local  adjust_cnt "`adjcnt'"
	return local  adjust_list "`adjlist'"
	return scalar n_adjustments = `nadjtotal'
	return scalar n_adjust_vars = `nadjvar'
end



program fc_desc_endogenous, rclass

	syntax [, Brief Detail]
	
	local isat in smcl as text
	local isae in smcl as err
	
	if "`detail'" != "" & "`brief'" != "" {
		di `isae' "may not specify both {bf:detail} and {bf:brief}"
		exit 198
	}
	
	local nendog
	mata:_fc_desc_get_nendog("nendog")
	
	fc_desc_get_head model head
	
	di 
	if `nendog' == 0 {
		di `isat' "`head'" "contains no endogenous variables."
		return local  model "`model'"
		return scalar n_endogenous = 0
		exit
	}
	
	if `nendog' > 1 {
		local s s
	}
	
	di `isat' "{p 0 0 0 65}"
	di `isat' "`head'" _c
	di `isat' "contains {res:`nendog'} endogenous variable`s'" _c
	
	if "`brief'" != "" {
		di `isat' ".{p_end}"
		return local  model "`model'"
		return scalar n_endogenous = `nendog'
		exit
	}
	
	di `isat' ":{p_end}"
	
	local vlist
	local srclist
	local adjcntlist
	
	mata:_fc_desc_list_endog("`detail'", "vlist", "srclist", "adjcntlist")
	
	return scalar n_endogenous = `nendog'
	return local varlist "`vlist'"
	return local model "`model'"
	return local source_list "`srclist'"
	return local adjust_cnt "`adjcntlist'"

end



program fc_desc_coefvector, rclass

	syntax [, Brief Detail]
	
	local isat in smcl as text
	local isae in smcl as err
	
	if "`detail'" != "" & "`brief'" != "" {
		di `isae' "may not specify both {bf:detail} and {bf:brief}"
		exit 198
	}
	
	local ncv nlhs
	mata:_fc_desc_get_ncv("ncv", "nlhs")

	fc_desc_get_head model head

	di
	if `ncv' == 0 {
		di `isat' "`head'" "contains no coefficient vectors."
		return scalar n_coefvectors = 0
		return scalar n_lhs = 0
		return local model "`model'"
		exit
	}
	
	if `ncv' > 1 {
		local s s
	}
	if `nlhs' > 0 {
		local es s
	}
	
	di `isat' "{p 0 0 0 65}"
	di `isat' "`head' contains {res:`ncv'} coefficient vector`s' " _c
	di `isat' "representing {res:`nlhs'} endogenous variable`es'" _c
	
	if "`brief'" != "" {
		di `isat' ".{p_end}"
		return scalar n_coefvectors = `ncv'
		return scalar n_lhs = `nlhs'
		return local model "`model'"
		exit
	}
	di `isat' ":{p_end}"
	local lhs
	local rhs
	local names
	local Vnames
	local Enames
	mata:_fc_desc_list_cv("`detail'", "lhs", "rhs", "names", 	///
				"Vnames", "Enames")
	
	return scalar n_lhs = `nlhs'
	return scalar n_coefvectors = `ncv'
	return local model "`model'"
	return local lhs "`lhs'"
	return local names "`names'"
	if "`detail'" != "" {
		return local Vnames "`Vnames'"
		return local Enames "`Enames'"
		return local rhs "`rhs'"
	}
	
end
	


program fc_desc_solve, rclass

	syntax [, Brief Detail]
	
	local isat in smcl as text
	local isae in smcl as err
	
	if "`detail'" != "" & "`brief'" != "" {
		di `isae' "may not specify both {bf:detail} and {bf:brief}"
		exit 198
	}
	
	fc_desc_get_head model head

	local solved
	mata:_fc_query_solve("solved")
	
	local isat in smcl as text
	
	di
	if "`solved'" == "" {
		di `isat' "`head'has not been solved."
		return local solved ""		// empty
		return local model "`model'"
		exit
	}
	
	di `isat' "`head'has been solved" _c
	if "`brief'" != "" {
		di "."
		return local solved "solved"
		return local model "`model'"
		exit
	}
	
	di ":"
	return local model "`model'"
		// r() macros set in Mata
	mata:_fc_desc_list_solve()

end


program fc_desc_invalid_subcmd

	args subcmd
	
	local isae in smcl as err
	
	di `isae' `"unrecognized subcommand {bf:`subcmd'}"'
	
	di `isae' "{p 4 4 2}"
	di `isae' "Valid {bf:forecast describe} subcommands are"
	di `isae' "{bf:estimates},"
	di `isae' "{bf:identity},"
        di `isae' "{bf:coefvector},"
	di `isae' "{bf:exogenous},"
        di `isae' "{bf:endogenous},"
        di `isae' "{bf:adjust}, and"
        di `isae' "{bf:solve}."
        di `isae' "{p_end}"
	
	exit 199
end



/*
	Returns header
		'The current model '
	or
		'Forecast model XXXXX '

	Puts model name in tgtmodel; may be ""
	Puts result into caller's local macro spec'd by 'target'
*/
program fc_desc_get_head

	args tgtmodel target

	mata:_fc_get_modelname_wrk("model")
	

	if "`model'" == "" {
		local head "The current model "
	}
	else {
		local head "Forecast model {res:`model'} "
	}
	
	c_local `target' `"`head'"'
	c_local `tgtmodel' `"`model'"'

end
exit
