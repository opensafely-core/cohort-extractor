*! version 1.0.6  04nov2015  


/* -------------------------------------------------------------------- */
						/* main			*/

program forecast, rclass

	version 13

	gettoken subcmd rest : 0, parse(" ,")

	local l = strlen("`subcmd'")

	if (`"`subcmd'"' == "clear") {
		fc_clear `rest'
	}
	else if (`"`subcmd'"' == bsubstr("create", 1, max(2,`l'))) {
		fc_create `rest'
	}
	else if (`"`subcmd'"' == bsubstr("describe", 1, max(1, `l'))) {
		fc_describe `rest'
	}
	else if (`"`subcmd'"' == bsubstr("drop", 1, max(2, `l'))) {
		fc_drop `rest'
	}
	else if (`"`subcmd'"' == "dump") {
		fc_dump `rest'
	}
	else if (`"`subcmd'"' == bsubstr("estimates", 1, max(3, `l'))) {
		fc_estimates `rest'
	}
	else if (`"`subcmd'"' == bsubstr("exogenous", 1, max(2, `l'))) {
		fc_exogenous `rest'
	}
	else if (`"`subcmd'"' == bsubstr("coefvector", 1, max(2, `l'))) {
		fc_coefvector `rest'
	}
	else if (`"`subcmd'"' == bsubstr("identity", 1, max(2, `l'))) {
		fc_identity `rest'
	}
	else if (`"`subcmd'"' == bsubstr("adjust", 1, max(2, `l'))) {
		fc_adjust `rest'
	}
	else if (`"`subcmd'"' == bsubstr("list", 1, max(1, `l'))) {
		fc_list `rest'
	}
	else if (`"`subcmd'"' == bsubstr("query", 1, max(1, `l'))) {
		fc_query `rest'
	}
	else if (`"`subcmd'"' == bsubstr("solve", 1, max(1, `l'))) {
		capture noisily fc_solve `rest'
		if _rc {
			local rc = _rc
			mata: fc_cleanup()
			mata: fc_drop()
			exit `rc'
		}
	}
	else {
		invalid_subcmd `"`subcmd'"'
		/*NOTREACHED*/
	}
	return add
end


program invalid_subcmd
	args subcmd

	mata: forecast_started("begun")

	if (`"`subcmd'"'=="") {
		di as err "missing {bf:forecast} subcommand"
		local rc 198
	}
	else {
		di as err ///
		`"unrecognized {bf:forecast} subcommand:  {bf:`subcmd'}"'
		local rc = 199
	}

	di as err "{p 4 4 2}"
	di as err "{bf:forecast} subcommands are"
	di as err "{bf:create},"
        di as err "{bf:estimates},"
        di as err "{bf:identity},"
        di as err "{bf:coefvector},"
        di as err "{bf:exogenous},"
        di as err "{bf:solve},"
        di as err "{bf:adjust},"
        di as err "{bf:describe},"
        di as err "{bf:list},"
        di as err "{bf:clear},"
	di as err "{bf:drop},"
	di as err "and"
	di as err "{bf:query}."
	if (!`begun') {
		di as err "You have not started a forecast model yet, so"
		di as err "you must begin with {bf:forecast create}."
	}
	di as err "{p_end}"
	exit `rc'
end


						/* main			*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
						/* subcommands		*/

/*
	forecast create [name] [, replace]
*/

program fc_create
	syntax [name(name=probname)] [, REPLACE]
	
	mata: forecast_started("begun")

	if (`begun') {
		if ("`replace'"=="") { 
			mata:_fc_get_modelname_wrk("name")
			if "`name'" == "" {
				di as err "no; a forecast model already exists"
			}
			else {
				di as err				///
				"no; forecast model {bf:`name'} already exists"
			}
			di as err "{p 4 4 2}"
			di as err `"Type {bf:forecast create, replace}"'
			di as err "to discard the existing forecast"
			di as err "model and start a new one."
			di as err "{p_end}"
			exit 4
		}
		else {
			forecast clear
		}
	}
	mata: fc_create_instance("`probname'")
	if "`probname'" != "" {
		di in smcl as txt "  Forecast model {res:`probname'} started."
	}
	else di as txt "  Forecast model started."
end



/*
	forecast clear
*/

program fc_clear
	syntax

	mata: forecast_started("begun")
	if (!`begun') {
		di as txt "  (no forecast model in process; no action taken)"
		exit
	}
	mata: _fc_get_modelname_wrk("name")
	mata: fc_clear_instance()
	if "`name'" == "" {
		di as txt "  (Forecast model ended.)"
	}
	else {
		di as txt "  (Forecast model {res:`name'} ended.)"
	}
end



/*
	forecast list [, SAVing(filename, [replace]) noTRim]
*/
program fc_list

	fc_problem_must_exist list
	
	syntax, [SAVing(string asis) noTRim]
	
	if `"`saving'"' != "" {
		fc_list_fchk `saving'
		local fname `"`r(fname)'"'
	}
	
	mata: fc_list(`"`fname'"', "`trim'")
	
end

program fc_list_fchk, rclass

	syntax [anything(name = fname)] [, replace]

				// anything retains quotes if user specifies
				// a quoted filename w/ spaces in path, so 
				// following will still be n=1 if correct
	local n : word count `fname'	
	if `n' > 1 {
		di as error `"`fname' not a valid filename"'
		exit 198
	}
	
	local fname `=trim(`"`fname'"')'

	if bsubstr(`"`fname'"', -3, .) != ".do" {
		local fname `"`fname'.do"'
	}
	
	cap confirm new file `"`fname'"'
	local rc = _rc
	if `rc' == 602 & "`replace'" == "" {
		di as error `"`fname' already exists"'
		exit 602
	}
	else if `rc' == 602 & "`replace'" == "replace" {
		rm `"`fname'"'
	}
	else if `rc' == 0 & "`replace'" == "replace" {
		di as text `"(note: file `fname' not found)"'
	}
	
	return local fname `"`fname'"'

end



/*
	forecast query
*/
program fc_query, rclass
	
	syntax
	
	mata: forecast_started("begun")
	if (`begun') {
		mata:_fc_get_modelname_wrk("name")
	}
	
	if (`begun') {
		if "`name'" != "" {
			di as txt "  Forecast model " as res "`name'" 	///
					as text " exists."
			return local name "`name'"
		}
		else { 
			di as txt "  Forecast model exists."
		}
		return scalar found = 1
	}
	else {
		di as txt "  No forecast model exists."
		return scalar found = 0
	}
end



/*
	forecast dump , [ALL]
*/
program fc_dump
	
	mata: forecast_started("begun")
	if (`begun') {
		syntax [, ALL]
		mata: fc_dump(`"`all'"')
	}
	else {
		di as txt "  (forecast model not found)"
		exit 111
	}
end



/*
	forecast estimates {<name> | using <name>} [, NAmes() 
			PRedict() ADvise NUmber() ]
*/
program fc_estimates
	
	fc_problem_must_exist estimates
	
	gettoken estname : 0, parse(" ,")
	if ("`estname'"=="using") {
		syntax using/ [, NUmber(integer -1) * ]
		if `number' == -1 {
			local num = 1
		}
		else {
			local num = `number'
		}
			// We can always specify number(1), but we keep track
			// of whether the user specified a number for output
			// purposes and to mimic exactly what the user typed.
		estimate use `"`using'"', number(`num')
		local estname 
		if `number' == -1 {
			local orig `"estimates using "`using'""'
		}
		else {
			local orig `"estimates using "`using'", number(`num')"'
		}
			// We use -syntax- below to parse options, and that
			// wipes out the using macro
		local myusing `"`using'"'
	}
	else if `"`0'"' == "" {
	 	fc_estimates_no_name	/* Not Reached */
	}
	else {
		gettoken junk 0 : 0, parse(" ,")
		syntax [, *]
		capture estimates restore `estname'
		if _rc {
			fc_estimates_bad_name `estname'
						/* Not Reached */
		}
		local orig "estimates `estname'"
	}
	if `"`options'"' != "" {
		if "`num'" != "" & "`number'" != "-1" {
				// We already added a comma for number() opt */
			local orig `"`orig' `options'"'
		}
		else {
			local orig `"`orig', `options'"'
		}
		local 0 , `options'
		syntax [, NAmes(string) PRedict(string asis) ADvise]
		if "`names'" != "" {
			local 0 `names'
			syntax namelist(name=names) [, REPLACE]
		}
	}

	mata:fc_estimates_unsupported_cmd("`e(cmd)'")
	
	if "`e(cmd)'" == "mgarch" {
		fc_estimates_check_mgarch `"`predict'"'
	}
	
	fc_estimates_check_depvar `"`names'"' "`replace'"
	
	fc_estimates_check_xt

	if `"`predict'"' != "" {
		fc_estimates_check_predict `"`predict'"'
	}
	
	tempname beta
	capture mat `beta' = e(b)
	if !_rc {
		local rhs : colnames `beta'
		local rhs : list uniq rhs
		fc_check_forward_op `"`rhs'"'
			/*Not reached if an error occurred */
	}
	mata: fc_estimates(`"`orig'"',		/* original line     */ ///
			   "`estname'",		/* memname	     */ ///
			   `"`myusing'"',	/* diskname 	     */	///
			   `"`number'"',	/* est num on disk   */	///
			   `"`predict'"',	/* predict() option  */	///
			   `"`names'"',		/* name() option     */ ///
			   `"`advise'"'		/* advise option     */ ///
			   )

end



/*
	Dynamic predictions after -mgarch- are not allowed if the depvars
	contain time-series operators.  -forecast- needs dynamic predictions,
	so we have to check -mgarch- estimates and exit if there are TS ops.
		-- r(498)'s if we find any
		
	Also, we are only allowing predict option xb (or empty, which
	defaults to xb).  No way to ensure that if user requests
	variance predictions that we'll get s new variables from
	-predict- given s depvars.
		-- r(321)'s if any predictions other than xb

*/
program fc_estimates_check_mgarch

	args	predopt
	
	local isae in smcl as error
		
	if "`e(cmd)'" != "mgarch"	exit

	if `"`predopt'"' != "" & `"`predopt'"' != "xb" {
		di `isae' `"{bf:predict(`predopt')} not allowed"'
		di `isae' "{p 4 4 2}"
		di `isae' "Only linear predictions from {cmd:mgarch} models "
		di `isae' "can be used in forecast models."
		di `isae' "{p_end}"
		exit 321
	}
	
	local error false
	foreach var in `e(depvar)' {
		_ms_parse_parts `var'
		if "`r(ts_op)'" != "" | "`r(op)'" != "" {
			local error true
		}
	}
	
	if "`error'" == "true" {
		di `isae' 				///
		"dependent variables with time-series operators not allowed"
		di `isae' "{p 4 4 2}"
		di `isae' "Because {bf:mgarch} does not allow dynamic "
		di `isae' "predictions when a dependent variable has "
		di `isae' "time-series operators, {bf:forecast} "
		di `isae' "cannot use these estimation results."
		di `isae' "{p_end}"
		exit 321
	}

end

/*
	Checks varlist for forward or lag operators and exits with
	an error if found
*/
program fc_depvar_tsops, sclass

	args depvar
	
	local hastsops 0
	foreach var of local depvar {
		GetTSOps "`var'"
		if `s(k)' {
			/* no forward operators 			*/
			if inlist("F",`s(ts_ops)') {
				fc_no_forward_op "`var'"
				/* NOT REACHED */
			}
			/* no lag operators 				*/
			if inlist("L",`s(ts_ops)') {
				fc_no_lag_op "`var'"
				/* NOT REACHED */
			}
			/* any difference (or seas diff) operators 	*/
			if inlist("D",`s(ts_ops)') {
				local hastsops 1
			}
			if inlist("S",`s(ts_ops)') {
				local hastsops 1
			}
		}
	}
	sreturn local diffops = `hastsops'
end

/*
	We have already restored the estimates we are looking at here
*/
program fc_estimates_check_depvar

	args names replace

		/* Fills in depvar macro with correct depvar list.
		   Some commands (e.g. -vec-) don't save the relevant
		   varlist in e(depvar) but rather someplace else.
		*/
	mata:fc_estimates_find_depvars_mac("depvar")
	
	if "`depvar'" == "" {
		fc_estimates_no_edepvar
			/* Not Reached */
	}
	local depvar1 : list uniq depvar
	local depvar1 : list depvar - depvar1
	if "`depvar1'" != "" {
		local k : list sizeof depvar1
		local var = plural(`k',"variable")
		local is = plural(`k',"is","are")
		di as err "cannot add estimation result"
		di as txt "{phang}Endogenous `var' `depvar1' `is' in " ///
		 "multiple equations. You cannot add an endogenous "   ///
		 "variable to the forecast model multiple times as a " ///
		 "dependent variable.{p_end}"
		 exit 322
	}
			/* Check for operators */
	fc_depvar_tsops `depvar'
	local hastsops = s(diffops)
	
	local nnames  : word count `names'
	local ndepvar : word count `depvar'
	
	if (!`hastsops' & `nnames' == 0) {
		exit
	}
	
	if (`nnames' != `ndepvar') {
		fc_estimates_names_reqd `nnames' `ndepvar' `hastsops'
			/* NOT REACHED */
	}
	
			/* Now make sure that for each depvar with a TS
			   operator, we have a valid name that we can use.
			   If name already exists as a variable, replace
			   and warn. */
	local i 1
	foreach var of local depvar {
		local name : word `i' of `names'
		capture confirm new variable `name'
		if !_rc {
			qui gen double `name' = `var'
		}
		else if "`replace'" != "" {
			qui replace `name' = `var'
		}
		else {
			fc_estimates_name_exists `name'
				/* NOT REACHED */
		}
		local `++i'
	}
	
end

program fc_estimates_name_exists

	args name
	
	local isae in smcl as error
	
	di `isae' "`name' already defined"
	di `isae' "{p 4 4 2}"
	di `isae' "In the {bf:names()} option of {bf:forecast estimates} "
	di `isae' "you must either specify a new variable name or specify "
	di `isae' "the {bf:replace} option to reuse an existing variable."
	di `isae' "{p_end}"
	exit 110
end

program fc_estimates_bad_name

	args name
	local isae in smcl as error
	
	di `isae' "estimation result `name' not found"
	di `isae' "{p 4 4 2}"
	di `isae' "Could not restore estimation result {bf:`name'}.  Use "
	di `isae' "{bf:estimates dir} to list results stored in memory."
	di `isae' "If the estimation results are saved on disk, use "
	di `isae' "{bf:forecast estimates using} along with the name "
	di `isae' "of a file containing saved estimation results."
	di `isae' "{p_end}"
	exit 111
	
end

program fc_estimates_no_name

	local isae in smcl as error
	
	di `isae' "syntax error"
	di `isae' "{p 4 4 2}"
	di `isae' "You must specify the name of a stored estimation result "
	di `isae' "or use {bf:forecast estimates using} along with the name "
	di `isae' "of a file containing saved estimation results."
	di `isae' "{p_end}"
	exit 198
end

program fc_estimates_names_reqd

	args nnames numdep hastsops

	local isae in smcl as error
	if (`numdep' > 1) {
		local s s
		local a "alternative"
	}
	else {
		local a "an alternative"
	}
	
	if `nnames' == 0 {
		di `isae' "option {bf:names()} required"
	}
	else {
		di `isae' "option {bf:names()} incorrectly specified"
	}
	di `isae' "{p 4 4 2}"
	if "`hastsops'" == "1" {
		di `isae' "Because the dependent variable`s' specified with "
		di `isae' "{bf:`e(cmd)'} included time-series operators, you "
	}
	else {
		di `isae' "You "
	}
	di `isae' "must specify `a' name`s' in the {bf:names()} option of "
	di `isae' "{bf:forecast estimates}. {bf:`e(cmd)'} reports `numdep' "
	di `isae' "dependent variable`s', so you must specify `numdep' "
	di `isae' "name`s' in {bf:names()}."
	di `isae' "{p_end}"
	
	exit 322
end

program fc_estimates_no_edepvar
	
	local isae in smcl as error
	di `isae' "could not determine left-hand-side variable"
	di `isae' "{p 4 4 2}"
	di `isae' "Because estimation command {bf:`e(cmd)'} does not store "
	di `isae' "{bf:e(depvar)}, {bf:forecast estimates} could not "
	di `isae' "determine the endogenous variable to be added to the "
	di `isae' "model."
	di `isae' "{p_end}"
	
	exit 322
	
end

/*
	We have already restored the estimates we are looking at here
*/
program fc_estimates_check_xt

	mata:forecast_is_xt("is_xt")
	
					/* cmd_xt gets set to 1 (true) if     */
					/* if the command was an xt cmd;      */
					/* 0 (false) otherwise.		      */
	fc_estimates_check_xt_cmd cmd_xt
	
	if ( `cmd_xt' &  `is_xt') exit		/* Both xt, no problem 	      */
	if (!`cmd_xt' & !`is_xt') exit		/* neither xt, no problem     */
	
	if `cmd_xt' {
				/* User just specified xt command,
				   is_xt flag not set yet		*/
		mata:forecast_any_est_added("est_added")
		
		
		if (`est_added') {
				/* Already added non-xt commands, so
				   cannot add this xt command		*/
			fc_err_xt_cmd
			exit 498
		}
		else {
				/* Set the is_xt flag, then return and
				   proceed as normal			*/
			mata:forecast_set_xt()
			exit
		}
	}
	
	if !`cmd_xt' {
				/* User specified non-xt command, but 
				   already added an xt command		*/
		fc_err_non_xt_cmd
	}
	
			/* Not Reached */

end

program fc_estimates_check_xt_cmd

	args cmd_xt
	
	local xt = 0
	
				/* Need to handle xt commands which are	      */
				/* wrappers for non-xt commands		      */
	if "`e(cmd)'" == "clogit" & "`e(cmd2)'" == "xtlogit" {
		local xt = 1
	}
	else if bsubstr(e(cmd), 1, 2) == "xt" {
		local xt = 1
	}
	
	c_local `cmd_xt' `xt'
	
end
	


program fc_err_xt_cmd

	local isae in smcl as err
	di `isae' "cannot add {bf:XT} command estimates"
	di `isae' "{p 4 4 2}"
	di `isae' "You cannot add estimates from a panel-data command to a "
	di `isae' "forecast model after non-panel-data estimates have already "
	di `isae' "been added."
	di `isae' "{p_end}"
	
	exit 498

end


program fc_err_non_xt_cmd

	local isae in smcl as err
	di `isae' "cannot add estimates from non-panel-data command"
	di `isae' "{p 4 4 2}"
	di `isae' "You cannot add estimates from a non-panel-data command to a "
	di `isae' "forecast model once panel-data estimates have already "
	di `isae' "been added."
	di `isae' "{p_end}"
	
	exit 498

end

program fc_estimates_check_predict

	args predopts
	
	local neq : list sizeof predopts
	
	local isae in smcl as err
	tempvar wrk
	
	// See if we need to add eq(##) opt <- multiple equation and
	// user did not specify eq(##) for any equations
	local addeqopt 0
	if (`neq' > 1 & strpos(`"`predopts'"', "eq(") == 0) {
		local addeqopt 1
	}
	
	forvalues i = 1/`neq' {
		local opt : word `i' of `predopts'
		if (`addeqopt') {
			local eqopt eq(#`i')
		}
		capture predict double `wrk', `opt' `eqopt'
		if _rc {
			local myrc = _rc
			di `isae' "could not predict {bf:`opt'} " _c
			if `neq' > 1 {
				di `isae' "for equation `i'"
			}
			else {
				di
			}
			di `isae' "{p 4 4 2}"
			di `isae' "When calling {bf:predict} with option "
			di `isae' "{bf:`opt'} "
			if `neq' > 1 {
				di `isae' "for equation {bf:`i'} "
			}
			di `isae' "using the syntax {p_end}
			di `isae' "{p 8 8 2}"
			di `isae' "{bf:predict double }{it:varname}, {bf:`opt'} "
			di `isae' "{bf:`eqopt'}{p_end}"
			di `isae' "{p 4 4 2}"
			di `isae' "{bf:forecast} obtained an error.  See "
			if "`e(cmd2)'" != "" {
				di `isae' "{helpb `e(cmd2)' postestimation} "
			}
			else {
				di `isae' "{helpb `e(cmd)' postestimation} "
			}
			di `isae' "for the appropriate {bf:predict} options."
			di `isae' "{p_end}"
			exit `myrc'
		}
		cap drop `wrk'
	}

end



/*
	forecast identity <name> = <exp> , [ GENerate DOuble ]
*/
program fc_identity, rclass
	
	fc_problem_must_exist identity

	syntax [ anything(equalok) ] , [ GENerate DOuble ]
	
	if "`generate'" == "" & "`double'" != "" {
		di as err "syntax error"
		di as err "{p 4 4 2}"
		di as err "You cannot specify option {bf:double} unless you "
		di as err "also specify option {bf:generate}."
		di as err "{p_end}"
		exit 198
	}
	
	if `"`anything'"' == "" {
		di as err "invalid syntax"
		fc_iden_err 198
			/* Not reached */
	}

	local orig `"identity `0'"'

	gettoken lhs anything : anything, parse(" =")
	gettoken eq  rhs : anything, parse(" =")

				// confirming 'name' automatically precludes
				// use of TS and FV operators.  Don't need to
				// check separately
	capture noi confirm name `lhs' 
	if (_rc) {
		fc_iden_err _rc
		/*NOTREACHED*/
	}
	if (`"`eq'"' != "=") {
		di as err "syntax error"
		di as err "{p 4 4 2}"
		if `"`eq'"' == "" {
			di as err "nothing found where equal sign expected."
		}
		else {
			di as err `"{bf:`eq'} found where equal sign expected."'
		}
		di as err "{p_end}"
		fc_iden_err 198
		/*NOTREACHED*/
	}

	if "`generate'" == "" {
		capture unab lhs : `lhs'
		if _rc {
			fc_expr_check_ambig "`lhs'"
				// Nope, variable not found
			di as err "variable `lhs' not found"
			fc_iden_err 111
		}
	}
	else {
		fc_iden_gen `lhs' `"`rhs'"' `double'
	}
	
	fc_expr `rhs'
	local rhs	`"`r(expr)'"'
	local fullnames	"`r(fullnames)'"
	local basenames "`r(basenames)'"

					// Make sure no F. operators on
					// RHS; no return if true 
	fc_check_forward_op `"`fullnames'"'
	
	mata: fc_identity(`"`orig'"', "`lhs'", `"`rhs'"',		///
			  "`fullnames'", "`basenames'")
	
	local rhs `rhs'					// remove extra space
	return local lhs	"`lhs'"
	return local rhs	"`rhs'"
	return local fullnames	"`fullnames'"
	return local basenames	"`basenames'"

end

program fc_iden_err

	args rc
	
	di as err "{p 4 4 2}"
	di as err "The basic syntax for {bf:forecast identity} is "
	di as err "{break}{space 4}"
	di as err "{bf:forecast identity} {it:varname} {bf:=} {it:...}"
	di as err "{p_end}"
	di as err "{p 4 4 2}"
	di as err "Click {helpb forecast identity:here} for more information."
	di as err "{p_end}"

	exit `rc'
	
end

program fc_iden_gen 

	args lhs rhs double

	capture confirm new var `lhs'
	if _rc {
		di as err "`lhs' already exists"
		di as err "{p 4 4 2}"
		di as err "Variable `lhs' is already in the dataset, so you "
		di as err "cannot specify option {bf:generate} with "
		di as err "{bf:forecast identity}."
		di as err "{p_end}"
		exit 110
	}
	
	capture gen `double' `lhs' = `rhs'
	if _rc {
		di as err "could not generate new variable `lhs'"
		di as err "{p 4 4 2}"
		di as err "While executing the command "
		di as err "{p_end}"
		di as err "{p 8 8 2}"
		if "`double'" == "" {
			local sdouble ""
		}
		else {
			local sdouble " double"	// NB leading space
		}
		di as err `"{bf:generate`sdouble' `lhs' = `rhs'}"'
		di as err "{p_end}"
		di as err "{p 4 4 2}"
		di as err "{bf:forecast identity} received an error."
		di as err "{p_end}"
		exit _rc
	}
	
	label var `lhs' `"= `rhs'"'
	
end


	


/*
	forecast adjust <varname> = <exp> [if] [in]
		-- varname must be an already-declared endogenous
		   variable in the model.
*/
program fc_adjust, rclass

	fc_problem_must_exist adjust

	local orig `"adjust `0'"'

	gettoken lhs 0   : 0, parse(" =")
	gettoken eq  0   : 0, parse(" =")

	syntax anything(name = rhs id="adjustment function") [if] [in]
	
	capture confirm name `lhs' 
	if (_rc) {
		di as err "syntax error"
		di as err "{p 4 4 2}"
		di as err `"{bf:`lhs'} is an invalid variable name."'
		di as err "{p_end}"
		exit 198
		/*NOTREACHED*/
	}
	if (`"`eq'"' != "=") {
		di as err "syntax error"
		di as err "{p 4 4 2}"
		di as err `"{bf:`eq'} found where equals sign expected."'
		di as err "{p_end}"
		exit 198
		/*NOTREACHED*/
	}

	capture unab lhs : `lhs'
	if _rc {
		fc_expr_check_ambig "`lhs'"
			// Nope, variable not found
		di as err "variable `lhs' not found"
		exit 111
	}
	
				// Now take care of RHS
	fc_expr `rhs'
	local rhs	`"`r(expr)'"'
	local fullnames	"`r(fullnames)'"
	local basenames "`r(basenames)'"
	
	fc_check_forward_op `"`fullnames'"'

	local if `=strtrim("`if'")'

	if `"`in'"' != "" {
		fc_adj_parse_in `"`in'"'
		local obs_1 `r(obs_1)'
		local obs_2 `r(obs_2)'
	}
	else {
		local obs_1 1
		local obs_2 .
	}
	
	mata: fc_adjust(`"`orig'"', "`lhs'", `"`rhs'"', "`basenames'",	///
			`obs_1', `obs_2', `"`if'"')
	
	return local lhs	"`lhs'"
	return local rhs	"`rhs'"
	return local fullnames	"`fullnames'"
	return local basenames	"`basenames'"

end

/*
	Takes something like "in 5/l" and returns
		r(obs_1)	5
		r(obs_2)	.		(. means last)
	
	If you specify, say, -6/-2, then the negative indices refer
	to the sample size of the current dataset in memory now.
	
	input has been parsed by -syntax-, so we know the numbers are
	either valid or "f" or "l" for first and last obs.
*/
program fc_adj_parse_in, rclass

	args inspec
	
	if bsubstr(`"`inspec'"', 1, 3) != "in " {
		di as error "fc_adj_parse_in called incorrectly"
		exit 198
	}
	
	local inspec = bsubstr(`"`inspec'"', 4, .)
	
	gettoken first inspec : inspec , parse("/")
	gettoken slash last   : inspec , parse("/")
	
	if "`first'" == "f" | "`first'" == "F" {
		local first = 1
	}
	if "`last'" == "l" | "`last'" == "L" {
		local last = .
	}
	
	if `first' < 0 {
		qui count
		local first = r(N) + `first' + 1
	}
	if `last' < 0 {
		qui count
		local last = r(N) + `last' + 1
	}
	
	if (missing(`first') | `first' < 1) {
		di as err "invalid obs no"
		exit 198
	}
	
	return sca obs_1 = `first'
	return sca obs_2 = `last'

end

/*
	fc_exogenous <varlist>
*/
program fc_exogenous

	fc_problem_must_exist exogenous
	
	local orig `"exogenous `0'"'
	
	syntax varlist(min=1 numeric)
	
	mata:fc_exogenous(`"`orig'"', "`varlist'")
end	



/*
	fc_drop, [prefix() suffix()]
*/
program fc_drop, rclass

	fc_problem_must_exist drop
	
	syntax , [PREfix(string) SUFfix(string)]

	if "`prefix'" != "" & "`suffix'" != "" {
		di in smcl as error 					///
			"cannot specify both {bf:prefix()} and {bf:suffix()}"
			exit 184
	}
	
	local n
	mata:fc_drop("`prefix'", "`suffix'", "n")
	local s "s"
	if `n' == 1 {
		local s ""
	}
	di as text "  (dropped " as res `n' as text " variable`s')"
	return scalar n_dropped = `n'
	
end



/*
	fc_coefvector <matname>, [ Variance(<matname>) ERRorvariance(<matname>) 
				   NAmes(namelist [, REPLACE]) ]
*/
program fc_coefvector

	local orig_line `"coefvector `0'"'

			/* We're not r-class, but we call stuff that
			   uses r(), so we need to back up user's stuff 
			*/
	tempname hold
	cap _return hold `hold'
	
	syntax name(name=beta id="coefficient vector") , [ 	///
		Variance(name) NAmes(string) 			///
		ERRorvariance(name) ]

	fc_problem_must_exist coefvector
	
	if "`names'" != "" {
		local 0 `names'
		syntax namelist(name=names) [, REPLACE]
	}
	
	local isae in smcl as error
	
			/* Simple syntax checks; more specific checks 
			   are done momentarily.			*/
	capture confirm matrix `beta'
	local myrc = _rc
	if `myrc' {
		di `isae' "matrix `beta' not found"
		fc_coefvector_error `myrc'
	}
	if "`variance'" != "" {
		capture confirm matrix `variance'
		local myrc = _rc
		if `myrc' {
			di `isae' "matrix `variance' not found"
			fc_coefvector_error `myrc'
		}
	}
	if "`errorvariance'" != "" {
		capture confirm matrix `errorvariance'
		local myrc = _rc
		if `myrc' {
			di `isae' "matrix `errorvariance' not found"
			fc_coefvector_error `myrc'
		}
	}
	
	fc_coefvector_check_b `beta' "`replace'" : `names'
	local k_eq = s(k_eq)
	local eqnames `s(eqnames)'
	
	if "`variance'" != "" {
		fc_coefvector_check_V `variance' `=colsof(`beta')'
	}
	if "`errorvariance'" != "" {
		fc_coefvector_check_Sigma `errorvariance' `k_eq'
	}

		/* We call an r-class program but do not set r() 
		   ourselves; here we preserve whatever the user
		   might have in r()
		*/

	local allvars : colnames(`beta')
	foreach v of local allvars {
		if "`v'" == "_cons" {
			local basenames `basenames' _cons
			continue
		}
		fc_check_forward_op `v'
		capture fvrevar `v', list
		local myrc = _rc
		if `myrc' {
			di `isae' "`v' not a variable"
			fc_coefvector_stripe_err "`v'" `myrc'
					/* NOT REACHED */
		}
		local basename `r(varlist)'
		capture confirm numeric variable `basename'
		local myrc = _rc
		if `myrc' {
			di `isae' "`v' not a numeric variable"
			fc_coefvector_stripe_err "`v'" `myrc'
					/* NOT REACHED */
		}
		local basenames `basenames' `basename'
	}

	// Now that we have definite equation names, modify stripe if necessary
	if "`names'" != "" {
		local fullstripe : colfullnames(`beta')
		local curreq : coleq(`beta')
		local curreq : list uniq curreq
		
		local m : word count `curreq'
		local n : word count `eqnames'
		if `m' != `n' {		/* Should be impossible at this point */
			di `isae' "equation name mismatch in " _c
			di `isae' "{bf:forecast coefvector}!"
			exit 9999
		}
		
		local i 1
		foreach eq of local curreq {
			local neweq : word `i' of eqnames
			// It may be the case that an equation name is also
			// a variable name in another equation; add colon to
			// end to make sure we only substitute equation names
			local eqc `eq':
			local neweqc `neweq':
			local fullstripe : subinstr local 		///
					   fullstripe "`eqc'" "`neweqc'", all 
			local `++i'
		}
	}
	
	mat colnames `beta' = `fullstripe'
	mata:_fc_coefvector(`"`orig_line'"', "`beta'",			/// 
			     "`variance'", "`errorvariance'",		///
			     "`basenames'")
	cap _return restore `hold'

end



program fc_coefvector_stripe_err 

	args token rc
	
	local isae in smcl as error
	
	di `isae' "{p 4 4 2}"
	di `isae' "The matrix stripe attached to the coefficient vector has "
	di `isae' "item {bf:`token'} that does not represent a numeric variable."
	di `isae' "{p_end}"
	exit `rc'
end



program fc_coefvector_Sigma_dims

	args length
	
	local isae in smcl as error
	di `isae' "{p 4 4 2}"
	di `isae' "The error variance matrix must have `length' rows and "
	di `isae' "`length' columns to conform with the number of "
	di `isae' "equations in the coefficient vector."
	di `isae' "{p_end}"
	exit 503

end

program fc_coefvector_check_Sigma

	args Sigma length error
	
	local isae in smcl as error
	
	local r = rowsof(`Sigma')
	local c = colsof(`Sigma')
	
	if (`r' != `c') {
		di `isae' "`Sigma' not square"
		fc_coefvector_Sigma_dims `blength' `error'
				/* NOT REACHED */
	}
	
	if (`r' != `length') {
		di `isae' "`Sigma' has wrong dimensions"
		fc_coefvector_Sigma_dims `blength' `error'
				/* NOT REACHED */
	}
		
end



program fc_coefvector_V_dims

	args blength
	
	local isae in smcl as error
	di `isae' "{p 4 4 2}"
	di `isae' "The variance matrix must have `blength' rows and "
	di `isae' "`blength' columns to conform with the coefficient "
	di `isae' "vector."
	di `isae' "{p_end}"
	exit 503

end

program fc_coefvector_check_V

	args V blength
	
	local isae in smcl as error
	
	local r = rowsof(`V')
	local c = colsof(`V')
	
	if (`r' != `c') {
		di `isae' "`V' not square"
		fc_coefvector_V_dims `blength'
				/* NOT REACHED */
	}
	
	if (`r' != `blength') {
		di `isae' "`V' has wrong dimensions"
		fc_coefvector_V_dims `blength'
				/* NOT REACHED */
	}
		
end
	
program fc_coefvector_check_b, sclass

	gettoken beta 0 : 0
	gettoken replace 0 : 0
	gettoken colon 0 : 0
	local names `0'
	
	local isae in smcl as error
	
	local rows = rowsof(`beta')
	local cols = colsof(`beta')
	
	if `rows' != 1 		fc_coefvector_error 503
	
	forvalues i = 1/`cols' {
		if `beta'[1,`i'] >= . {
			fc_coefvector_error 504
		}
	}
	
				// First look at stripe; we do this
				// even if the names() option is 
				// specified
	fc_coefvector_check_eqn `beta'
	local eqnames 	`s(eqnames)'
	local k_eq	`s(k_eq)'
	local diffops	`s(diffops)'
	
	if `diffops' & "`names'" == "" {
		di `isae' "option {bf:names()} required"
		fc_coefvector_name_error `beta' `k_eq'
	}
	
	if "`names'" != "" {
		fc_coefvector_check_names `beta' "`replace'" : `names'
		local eqnames `s(eqnames)'
	}

	sreturn local eqnames `eqnames'
	sreturn local k_eq = `k_eq'

end



program fc_coefvector_check_eqn, sclass
	
	args beta
	
	local isae in smcl as error
	_ms_eq_info, matrix(`beta')
	local k_eq = r(k_eq)
	forvalues i = 1/`k_eq' {
		local eq `r(eq`i')'
		if "`eq'" == "_" {
			di `isae' "equation name not found"
			fc_coefvector_error 111
		}
		capture fvrevar `eq', list
		if _rc {
			di `isae' "invalid matrix stripe; `eq' not a variable"
			fc_coefvector_error 111
		}
		local eqnames `eqnames' `eq'
	}
	fc_depvar_tsops `eqnames'
	local diffops = s(diffops)
	
	sreturn local diffops = `diffops'
	sreturn local eqnames "`eqnames'"
	sreturn local k_eq = `k_eq'

end

program fc_coefvector_name_error

	args beta k_eq
	
	local isae in smcl as error
	if `k_eq' == 1 {
		local isare "is"
		local s ""
		local sing "s"
	}
	else {
		local isare "are"
		local s "s"
		local sing ""
	}
	di `isae' "{p 4 4 2}"
	di `isae' "Because the equation name`s' attached to `beta' "
	di `isae' "contain`sing' time-series operators, you must "
	di `isae' "specify the {bf:names()} option.  There `isare' "
	di `isae' "`k_eq' equation name`s', so you must specify "
	di `isae' "`k_eq' name`s' in {bf:names()}."
	di `isae' "{p_end}"
	exit 322

end


program fc_coefvector_check_names, sclass

	gettoken beta 0 : 0
	gettoken replace 0 : 0
	gettoken colon 0 : 0
	local names `0'
	
			/* At this point we know the equation names are
			   (mostly) good				*/
	_ms_eq_info, matrix(`beta')
	local k_eq = r(k_eq)
	local k_names : list sizeof names
	if (`k_names' != `k_eq') {
		di in smcl as error "option {bf:names()} misspecified"
		fc_coefvector_name_error `beta' `k_eq'
	}
			/* Now create newvars if possible	*/
	forvalues i = 1/`k_names' {
		local name : word `i' of `names'
		capture confirm new variable `name'
		if !_rc {
			capture gen double `name' = `r(eq`i')'
			local myrc = _rc
		}
		else if "`replace'" != "" {
			capture replace `name' = `r(eq`i')'
			local myrc = _rc
		}
		else {
			fc_coefvector_name_exists `name'
					/* NOT REACHED */
		}
		if `myrc' {
			fc_coefvector_name_bad "`name'" "`r(eq`i')'" `myrc'
		}
	}
	sreturn local eqnames `names'

end

program fc_coefvector_name_bad

	args name expression rc
	
	local isae in smcl as error
	
	di `isae' "`expression' invalid"
	di `isae' "{p 4 4 2}"
	di `isae' "{bf:forecast coefvector} could not create variable `name' "
	di `isae' "equal to the expression above."
	di `isae' "{p_end}"
	exit `rc'
end



program fc_coefvector_name_exists

	args name
	
	local isae in smcl as error
	
	di `isae' "`name' already defined"
	di `isae' "{p 4 4 2}"
	di `isae' "In the {bf:names()} option of {bf:forecast coefvector} "
	di `isae' "you must either specify a new variable name or specify "
	di `isae' "the {bf:replace} option to reuse an existing variable."
	di `isae' "{p_end}"
	exit 110
end


program fc_coefvector_error

	args rc
	
	local isae in smcl as error
	
	di `isae' "{p 4 4 2}"
	di `isae' "To use {bf:forecast coefvector} you must specify a valid "
	di `isae' "Stata matrix with one row.  By default left-hand-side "
	di `isae' "variables are obtained from that matrix's equation names, and "
	di `isae' "righthand-side variables are obtained from the matrix's "
	di `isae' "column names.  Use the {bf:names()} option if the matrix "
	di `isae' "contains equation names with time-series operators. "
	di `isae' "Use the {bf:variance()} option if you wish to specify a "
	di `isae' "covariance matrix for the coefficients."
	di `isae' "{p_end}"
	
	exit `rc'
end






						/* subcommands		*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
						/* utilities		*/
/*
	The next several programs take an expression from, say, 
	-forecast identity- and return a list of full variable names
	that may include TS and FV operators as well as a list of 
	basenames, which have those operators removed.  Also returned
	is the expression with nice spacing between elements.
*/
program fc_expr, rclass

	local parse `"~!@#$%^&*()-+=|\{}[]:;<>?/"'

	local varnames
	gettoken cur 0 : 0, parse(`"`parse'"') 
	gettoken nxt 0 : 0, parse(`"`parse'"')
	if `"`nxt'"' == "(" {
		local cur `cur'(
		gettoken nxt 0 : 0, parse(`"`parse'"')
	}	
	while (`"`cur'"' != "") {
		local cur = strtrim("`cur'")
		local is_var 0
			// * expands to all vars in the dataset, so 
			// it messes up our variable-checking code
			// (and we know it's not a variable).
		if `"`cur'"' != "*" {
			fc_expr_chk_var is_var basename tsfvops : 	///
					`"`cur'"' `"`nxt'"'
		}
		
		if (`is_var' == 1) {
			local basenames `basenames' `basename'
			local fullnames `fullnames' `tsfvops'`basename'
			local newexpr `"`newexpr' `tsfvops'`basename'"'
		}
		else {
			fc_expr_add_space space : `"`cur'"'
			local newexpr `"`newexpr'`space'`cur'"'
		}
		
		local cur `"`nxt'"'
		gettoken nxt 0 : 0, parse(`"`parse'"')
	}
	
	fc_expr_trim_space newexpr : `"`newexpr'"'
	
	return local expr `"`newexpr'"'
	return local fullnames `"`fullnames'"'
	return local basenames `"`basenames'"'
	
end

program fc_expr_add_space

	args c_space colon token
	
	if inlist(`"`token'"',						/// 
		"[", "{", "(", ")", "}", "]", "*", "/", "^") {
		c_local `c_space' ""
	}
	else {
		c_local `c_space' " "
	}
end

program fc_expr_trim_space

	args c_expr colon expr
	
	foreach op in "[" "{" "(" "*" "/" "^" {
		local expr : subinstr local expr "`op' " "`op'", all
		local expr : subinstr local expr " `op'" "`op'", all
	}
	foreach op in ")" "}" "]" {
		local expr : subinstr local expr " `op'" "`op'", all
	}
	
	c_local `c_expr' `"`expr'"'
	
end

program fc_expr_chk_var

	args c_is_var c_basename c_tsfvops colon input nxt
	
		// Get full name
	capture fvunab input : `input', max(1) min(1)
	if _rc {
		fc_expr_check_ambig "`input'"
			
			// Nope, must be something else
		c_local `c_is_var' 0
		exit
	}
	
		// Split varname from TS and FV ops
	capture fvrevar `input', list
	if _rc {
		c_local `c_is_var' 0
		exit
			// Not reached
	}
		// Need to allow for possibility that varname is something
		// stupid like LD, which is also a valid combo. of TS opers.
	local basename `r(varlist)'
	local ilen = ustrlen("`input'")
	local blen = ustrlen("`basename'")
	if (`ilen' > `blen') {
		local tsfvops = usubstr("`input'", 1, (`ilen' - `blen'))
	}
	else {
		// Make sure this is a variable whose name happens to
		// be a valid stata function, not a stata function
		if ("`nxt'" == "(") {
			c_local `c_is_var' 0
			exit
				// Not reached
		}
	}
	
	c_local `c_is_var' 1
	c_local `c_basename' `basename'
	c_local `c_tsfvops' `tsfvops'
	
end



program fc_check_forward_op

	args vlist
	
	foreach var of local vlist {
		GetTSOps "`var'"
		if `s(k)' {
			if inlist("F",`s(ts_ops)') {
				fc_no_forward_op "`var'"
				/* NOT REACHED */
			}
		}
	}
end


program expr, rclass

/* old -- don't think _ should be in list
	local parse `"~!@#$%^&*()_-+=|\{}[]:;<>?/"'
*/
	local parse `"~!@#$%^&*()-+=|\{}[]:;<>?/"'

	local varnames
	gettoken cur 0 : 0, parse(`"`parse'"') 
	gettoken nxt 0 : 0, parse(`"`parse'"')
	while (`"`cur'"' != "") {
		capture confirm name `cur'
		if (_rc==0) { 
			expr_chknext excl : `"`nxt'"'
			if (`excl'==0) { 
				unab fullname : `cur'
				local varnames `varnames' `fullname'
			}
		}
		local cur `"`nxt'"'
		gettoken nxt 0 : 0, parse(`"`parse'"')
	}
	return local varnames `varnames'
end

program expr_chknext 
	args macname colon nxt
	if (`"`nxt'"'=="(" | `"`nxt'"'==".") {
		c_local `macname' 1
	}
	else	c_local `macname' 0
end

program fc_no_forward_op

	args vname
	
	local isae in smcl as error
	if "`vname'" != "" {
		di `isae' "`vname' not allowed"
	}
	else {
		di `isae' "forward operators not allowed"
	}
	di `isae' "{p 4 4 2}"
	di `isae' "Variables in forecast models may not be adorned by the "
	di `isae' "forward operator {it:F}."
	di `isae' "{p_end}"
	
	exit 498
end

program fc_no_lag_op

	local isae in smcl as error
	
	di `isae' "lag operators not allowed on dependent variables"
	di `isae' "{p 4 4 2}"
	di `isae' "You cannot use the lag operator on the dependent variables "
	di `isae' "of models to be added to forecast models."
	di `isae' "{p_end}"
	
	exit 498
	
end

program fc_expr_check_ambig

	args input

		// Was it because there are multiple vars that match?
	capture describe `input'*, varlist
	if `:word count `r(varlist)'' > 1 {
		fc_expr_ambig_abbrev `"`input'"'
			/* NOT REACHED */
	}

end
	

program fc_expr_ambig_abbrev 

	args input
	
	local isae in smcl as error
	di `isae' "`input' ambiguous abbreviation"
	di `isae' "{p 4 4 2}"
	di `isae' "In the previous expression, {bf:`input'} matches multiple "
	di `isae' "variables.  Respecify the expression using a more "
	di `isae' "complete variable name."
	di `isae' "{p_end}"
	
	exit 111
end

program define GetTSOps, sclass
	args expr

	_ms_parse_parts `expr'
	local k = 0
	if !missing(r(k_names)) {
		forvalues i=1/`r(k_names)' {
			if "`r(ts_op`i')'" != "" {
				local `++k'
				local tsop = substr("`r(ts_op`i')'",1,1)
				local ts_ops `"`ts_ops'`c'"`tsop'""'
				local c ,
			}
		}
	}
	else if "`r(ts_op)'" != "" {
		local `++k'
		local tsop = substr("`r(ts_op)'",1,1)
		local ts_ops `""`tsop'""'
	}
	sreturn local k = `k'
	sreturn local ts_ops `"`ts_ops'"'
end

exit
