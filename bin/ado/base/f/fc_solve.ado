*! version 1.2.0  16apr2018

/*
	forecast solve ...
*/
program fc_solve, rclass

	version 13

	fc_problem_must_exist solve

	syntax [, PREfix(string) SUFfix(string) 			///
		  Begin(string) End(string) PERiods(integer -1)		///
		  SIMulate(string)					///
		  DOuble						///
		  TECHnique(string)					///
		  VTOLerance(real -1)					///
		  ZTOLerance(real -1)					///
		  ITERate(integer 500)					///
		  NOLOG	 /* UNDOCUMENTED -- for syntax parsing */	///
		  LOG1	 /* UNDOCUMENTED -- for syntax parsing */	///
		  LOg(string)						///
		  STatic						///
		  ACtuals						///
	       ]

	       		// Clear out existing Solve information in
	       		// case we've already solved this model;
	       		// may have information no longer correct.
	mata:fc_reset_solve()

	// Parse log()
	if "`nolog'" != "" {
		local logtype off
	}
	else if "`log1'" != "" {
		local logtype on
	}
	else {
		fc_parse_log `"`log'"'
		local logtype `s(logtype)'
	}
	mata:fc_set_logtype("`logtype'")
	
	if "`prefix'" != "" & "`suffix'" != "" {
		di in smcl as error 					///
			"cannot specify both {opt prefix()} and {opt suffix()}"
			exit 184
	}
	if "`prefix'`suffix'" == "" {
		local prefix f_
	}
	
	mata:fc_set_actuals("`actuals'")
	
	// Parse technique() and related options
	_fc_solve_technique `"`technique'"'
	local tech `s(tech)'
	if "`tech'" == "dampedgaussseidel" {
		local damp `s(damping)'
	}
	fc_check_tolerance `"`vtolerance'"' `"`ztolerance'"'
	local vtolerance `s(vtolerance)'
	local ztolerance `s(ztolerance)'
	fc_check_iterate `"`iterate'"'
	local iterate `s(iterate)'

	// This populates Mata structs if it worked properly
	if `"`simulate'"' != "" {
		fc_parse_sim `simulate'
		local nreps = s(sim_nreps)
		local sim_technique `s(sim_technique)'
	}

	// Back up user's estimation results
	tempname usrest
	_estimates hold `usrest', nullok restore

	// Make sure estimation results for predict commands are available
	mata:fc_check_estimates()
	
	// We use this flag below. `is_xt' = 1 if panel data, 0 o.w.
	mata:forecast_is_xt("is_xt")
	
	// Ensure -tsset- or -xtset- correctly
	tempvar panelvar
	if `is_xt' {
		_xt, trequired
		local usr_panelvar	: char _dta[_TSpanel]
		local timevar		: char _dta[_TStvar]
				// In place of touse, we use 1 below to check
				// all observations, not just an est. sample
		_xtstrbal `usr_panelvar' `timevar' 1
		if r(strbal) == "no" {
			di as error "must have strongly balanced panel data"
			exit 198
		}
		sort `usr_panelvar' `timevar'
		fc_make_contig_ivar `panelvar' : `usr_panelvar' 
	}
	else {
		_ts, sort
		local timevar : char _dta[_TStvar]
		quietly gen byte `panelvar' = 1 
	}
	mata:fc_set_tvar_ivar("`timevar'", "`usr_panelvar'", "`panelvar'")
	
	summ `panelvar', mean
	local Npanels = r(max)
	qui count
	local capT = r(N) / `Npanels'
	mata:fc_set_panel_dims(`Npanels', `capT')
	
	local rc 0
		// See if all endog vars are in dataset.  We don't parse 
		// begin() or end() till after this, because the user may not 
		// have specified them, and to determine them automatically
		// requires us to know that all the variables are available.
	mata:fc_check_endog_vars("rc")
	if `rc' ErrOut `rc'
		// ditto for exogenous variables
	mata:fc_check_exog_vars_present("rc")
	if `rc' ErrOut `rc'
	
		// Parse start and end of forecast period
	if `"`begin'"' != "" {
		_fc_parse_timeper `panelvar' `timevar' `"`begin'"' begin
		local first_obs = s(obsno)
	}
	else {
		_fc_find_begin_end_t `capT' begin
		local autobegin yes
		local first_obs = s(obsno)
	}
	
	if `"`end'"' != "" & `periods' != -1 {
		_fc_end_per_error
			/* Not Reached */
	}
	if `"`end'"' != "" {
		_fc_parse_timeper `panelvar' `timevar' `"`end'"' end
		local last_obs = s(obsno)
	}
	else if `periods' != -1 {
		_fc_parse_periods `panelvar' `timevar' `periods' `first_obs'
		local last_obs = s(obsno)
	}
	else {
		_fc_find_begin_end_t `capT' end
		local autoend yes
		local last_obs = s(obsno)
	}
	if `last_obs' < `first_obs' {
		fc_obs_err `first_obs' `last_obs' "`autobegin'" "`autoend'"
			/* NOT REACHED */
	}
	
		// Now that we know the time span of the forecast horizon,
		// check (declared) exogenous variables to make sure they
		// are populated
	mata:fc_check_exog_vars_values(`first_obs', `last_obs')
	
		// At this point, we are going to change the user's dataset.
	preserve

		// (Try to) create forecast vars.
	mata:fc_create_fcast_vars("rc", "`prefix'", "`suffix'")
	if `rc' ErrOut `rc'

		// (Re)cast endogenous vars as doubles.
	mata:fc_cast_endog_vars("rc")
	if `rc' ErrOut `rc'

	// Set up equation solver options
	mata:fc_solve_setup("rc", 					///
		"`tech'", "`vtolerance'", "`ztolerance'", "`damp'",	///
		"`static'", "`iterate'")
	if `rc' ErrOut `rc'

		// Copy adjustments to each Est or Iden. object.  We need to do
		// this to handle multiple-equation commands; we want to apply
		// the adjustment to each endogenous variable as soon as that
		// variable is calculated, not after all the LHS variables of
		// that Estimate are calculated.  If we decide later there is
		// no benefit to applying the adj. right after, the code hit
		// is easy, whereas not allowing that flexibility in the first
		// place would make for a PITA to hack in later.
	mata:fc_fillin_adj("rc")
	if `rc' ErrOut `rc' 
	
		// Go through each Estimate and restore the beta vector;
		// this is necessary in case we previously did a solve with
		// simulations of the betas.
	mata:fc_restore_beta("rc")
	if `rc' ErrOut `rc'
	
		// Fill in equation-level betas for 'XBable' 
	mata:fc_fillin_eqbeta("rc")
	if `rc' ErrOut `rc'

		// This is what we use as our constant term
	capture drop __fc_problem
	qui gen byte __fc_problem = 1
	
		// Create var_tempvar and var_predict tempvars used for
		// -predict- and similar work
	mata:fc_create_temp_vars()
			
		// Set up output
	fc_header, first_obs(`first_obs') last_obs(`last_obs') 		///
		   npanels(`Npanels') is_xt_bool(`is_xt')		///
		   prefix("`prefix'") suffix("`suffix'")		///
		   static("`static'")

		// Set permanent record of first panel's first and
		// last obs. to forecast; we need these in case we 
		// are doing simulations
	mata:fc_set_fcast_obs_perm(`first_obs', `last_obs')
	
	// If any -arima- estimates, set up their Kalman filters
	mata:fc_setup_arima("rc")
	if `rc' ErrOut `rc'

		// At this point all variables have been created.
		// This mata routine moves all tempvars to the end of the
		// varlist, then builds the variable indices
	mata:fc_set_var_idx()
	forvalues i = 1/`Npanels' {
		if (`is_xt' & "`logtype'" !=  "off") {
			di in smcl "{txt}Solving panel {res}`i'"
		}

		// (re)Set first and last observations to forecast.  The 
		// macros first_obs and last_obs refer to the first panel's
		// observations; since we require strongly balanced data, we
		// can easily recalculate for subsequent panels
		local curr_start = (`i'-1)*`capT' + `first_obs'
		local curr_last  = (`i'-1)*`capT' + `last_obs'
		mata:fc_set_fcast_obs(`curr_start', `curr_last')
		mata:fc_set_fcast_panel(`i')

		// Back up endogenous vars into forecast vars
		mata:fc_fillin_fcast_vars("rc")
		if `rc' ErrOut `rc'

		// Create equation-level data
		mata:fc_fillin_eqdata("rc", "__fc_problem")
		if `rc' ErrOut `rc'

		// Solve
		mata:fc_solve("rc")
		if `rc' ErrOut `rc'

		// During solve we overwrite endog vars with forecasts, while
		// forecast vars were used as backups.  Here we swap and 
		// restore actual vars.  However, if we did static
		// forecasts, then this swap is done for each time period
		// as it is forecast, so we do not do it now in that case.
		if "`static'" == "" {
			mata:fc_swap_fcast_act("rc")
			if `rc' ErrOut `rc'
		}

		// By convention we fill in the forecast variables with the
		// actuals for periods prior to the start of the forecast
		mata:fc_pad_fcast_act("rc")
		if `rc' ErrOut `rc'
	}
		
		// Needed to clean up output
	if "`logtype'" == "brief" & `Npanels' > 1 {
		di
	}
	
		// We now have the forecast variables.  The endogenous variables
		// have been restored, but are still doubles.  The forecast
		// Solve structure is still filled in and valid, and we 
		// filled in the Simulate structure when we parsed simulate()
	if `"`simulate'"' != "" {
		fc_solve_sim, reps(`nreps')
	}

	if "`double'" == "" {
			// Don't retain fcast and simulation vars as doubles
		mata:fc_recast_fcast_vars("rc")
		if `rc' Errout `rc' "drop"
	}

		// Restore the original vartypes of the endog vars --
		// fc_cleanup() also does this if necessary; here we're
		// just being explicit (and paranoid).
	mata:fc_recast_endog_vars("rc")
	if `rc'  ErrOut `rc'
	
		// We are done, and our forecast succeeded.
	mata:fc_solve_success()
		// Cancel the -preserve-; the data in memory is good.
	restore, not
		// Drop any estimation results we may have read in from disk
	capture estimates drop _forecast_ster*
	
	fc_footer `Npanels' `first_obs' `last_obs' "`actuals'"
	
	capture drop __fc_problem
	
	local Nvar xt			// set in mata code
	mata:_fc_get_footer_info("Nvar", "xt")
	
	return scalar	first_obs = 	`first_obs'
	return scalar	last_obs  = 	`last_obs'
	return scalar	Npanels	  =	`Npanels'
	return scalar	Nvar	  =	`Nvar'
	
	return scalar vtolerance = `vtolerance' 	
	return scalar ztolerance = `ztolerance' 	
	return scalar iterate	 = `iterate' 	
	
	return local technique	"`tech'"
	if ("`tech'" == "dampedgaussseidel") {
		return scalar damping = `damp'
	}
	
	if "`prefix'" != "" {
		return local prefix  = "`prefix'"
	}
	else {
		return local suffix = "`suffix'"
	}
	
	if "`actuals'" != ""	return local actuals "actuals"
	if "`static'" != ""	return local static "static"
	if "`double'" != ""	return local double "double"
	
	if `"`simulate'"' != "" {
		return local  sim_technique `sim_technique'
		return scalar sim_nreps = `nreps'
	}
	return local logtype = "`logtype'"

end



/*
	fc_solve_sim
		All the syntax parsing and details have been worked
		out at the top of fc_solve and by fc_parse_sim, below.
		Everything we need to know is in a Simulation structure
		in Mata waiting for us.
		
		This program must be eclass, so that if we do beta simulations
		we can doctor up e()
*/
program fc_solve_sim, eclass

	syntax , reps(integer)
	
	local rc 0

		// Are we resampling from the residuals?
	mata:fc_sim_check_type("resid", "fcasttype")
	if "`resid'" != ""  {
			// Get static forecasts and corresponding residuals
		di as text "Obtaining static forecast residuals"
		fc_solve_sim_do_statfc
		di
	}
		// Create set of variables to hold simulation result
	mata:fc_sim_create_vars("rc")
	if `rc' ErrOut `rc' "drop"
	
		// `dots' will contain "nodots" if we are not to do dots
		// and "" otherwise
	mata:_fc_query_simdot("dots")

	if "`dots'" == "" {
		_dots 0, title("Performing simulations") reps(`reps')
	}
	else {
		di in smcl as text "Performing " as res `reps' 	///
			   as text " simulations."
	}
	
		// Set up results file if req'd.
		// this just quietly exits and we continue
		// if we are not saving results to disk.
	mata:fc_sim_file_open("rc")
	if `rc' ErrOut `rc'

		// Do the actual sims
	mata:fc_sim_do("rc")

	if `rc' ErrOut `rc'

end



program fc_solve_sim_do_statfc

	mata:fc_solve_sim_do_statfc_wrk("rc")
	if `rc' ErrOut `rc'

end



/*
	fc_parse_sim	
		
		Parses the simulate() option of -fc solve-
		Results are put into the Solve struct and its children if
		there are no errors

	..., simulate(<method>, reps(#) statistic(statopt) noDOTS	///
				statistic(statopt) saving(fname [, ...]))
	
	<method> = [ betas ] [ {residuals | errors} ]
	
	statopt = <stat>, { prefix() | suffix() } 
	<stat>  = mean | variance | stddev | ...
*/
program fc_parse_sim, sclass

	syntax anything(id="simulation method" name=umethod),	[	///
		Reps(integer 50) noDOTS					///
		SAving(string)						///
		*	/* for STATistic */				///
		]
	
	local isae in smcl as err
	
	local j : word count `umethod'
	if `j' > 2 {
		di `isae' "invalid syntax"
		fc_parse_sim_err
			/* Not Reached */
	}
	
	local i 1
	foreach m of local umethod {
		local l = strlen("`m'")
		if ("`m'" == bsubstr("betas", 1, max(2, `l'))) {
			local method`i' = "betas"
		}
		else if ("`m'" == bsubstr("errors", 1, max(2, `l'))) {
			local method`i' = "errors"
		}
		else if ("`m'" == bsubstr("residuals", 1, max(2, `l'))) {
			local method`i' = "residuals"
		}
		else {
			di `isae' "invalid simulation method"
			fc_parse_sim_err
		}
		local `++i'
	}
	
	if "`method1'`method2'" == "errorsresiduals" |			///
	   "`method1'`method2'" == "residualserrors" {
	   	di `isae' "may not specify both {bf:errors} and {bf:residuals}"
	   	fc_parse_sim_err
	   			/* Not Reached */
	}
	
	if `"`saving'"' != "" {
		_prefix_saving `saving'
		local filename	    `s(filename)'
		local replace	    `s(replace)'
		local double	    `s(double)'
		local every	    `s(every)'
	}
	
	if `reps' < 2 {
		di `isae' "syntax error"
		di `isae' "{p 4 4 2}"
		di `isae' "{opt reps()} must be an integer greater than one."
		di `isae' "{p_end}"
		exit 198
	}
	
	// Parse statistic()
	if `"`options'"' != "" {
		local zero `0'
		local 0, `options'
		local stop 0
		local i 0
		while !`stop' {
			syntax , [ STATistic(string) *]
			if `"`statistic'"' != "" {
				local `++i'
				if `i' > 3 {
					fc_parse_sim_statlimit 
						/* NOT REACHED */
				}
				fc_parse_sim_stat `statistic'
				local stat`i' 	`s(stat)'
				local pfx`i'	`s(pfx)'
				local sfx`i'	`s(sfx)'
				local 0 , `options'
			}
			else {
				if `"`options'"' != "" {
					di `isae' `"`options' not allowed"'
					di `isae' "{p 4 4 2}"
					di `isae' "In option {bf:simulate()}, "
					di `isae' "valid suboptions are "
					di `isae' "{bf:reps()}, "
					di `isae' "{bf:statistic()}, and"
					di `isae' "{bf:saving()}."
					di `isae' "{p_end}"
					exit 198
				}
				local stop 1
			}
		}
		local 0 `zero'
	}
	if `"`stat1'"' == "" fc_parse_sim_nostat	/* Not reached */
	
			// Now that there are no syntax errors, populate
			// Mata structures.  In Mata we peek at these local
			// macros; do not change names here unless you
			// know what you are doing. Macro i contains the
			// number of statistics we are recording.
	mata:fc_sim_setup("`i'")
	
			// Make sure we have the information needed to
			// actually do the simulations:
			//	if betas, do we have full-rank V for all ests?
	mata:fc_sim_check_b_V_rank("rc")
	if `rc' ErrOut `rc'
			//	if MVN errors, do we have full-rank Vars?

	mata:fc_sim_check_err_vars("rc")
	if `rc' ErrOut `rc'
		
	sreturn local sim_technique "`=strtrim("`method1' `method2'")'"
	sreturn local sim_nreps = `reps'
end


program fc_parse_sim_err

	local isae in smcl as error
	
	di `isae' "{p 4 4 2}"
	di `isae' "Valid simulation methods are {bf:betas}, "
	di `isae' "{bf:residuals}, and {bf:errors}.  You can "
	di `isae' "specify one of the three methods, or you can "
	di `isae' "specify {bf:betas} and one of {bf:residuals} and "
	di `isae' "{bf:errors}.  You cannot specify both {bf:residuals} "
	di `isae' "and {bf:errors}.{p_end}"
	
	exit 198

end


/*
	fc_parse_sim_stat
	
		parses the statistic(...) suboption in
		option simulate(..., statistic(...))
*/
program fc_parse_sim_stat, sclass

	syntax anything(id="simulation statistic" name=stat), 		///
		[ PREfix(string) SUFfix(string) ]

	if "`prefix'" == ""  & "`suffix'" == "" fc_parse_sim_stat_nopfxsfx
	if "`prefix'" != ""  & "`suffix'" != "" fc_parse_sim_stat_nopfxsfx
	
	local l = strlen("`stat'")
	if "`stat'" == bsubstr("mean", 1, max(1, `l')) {
		local stat "mean"
	}
	else if "`stat'" == bsubstr("variance", 1, max(1, `l')) {
		local stat "variance"
	}
	else if "`stat'" == bsubstr("stddev", 1, max(1, `l')) {
		local stat "stddev"
	}
	else fc_parse_sim_stat_error	/* Not reached */
	
	sreturn local stat =	"`stat'"
	sreturn local pfx  =	"`prefix'"
	sreturn local sfx  =	"`suffix'"

end

program fc_parse_sim_stat_error

	local ae as error
	di `ae' "syntax error"
	di `ae' "{p 4 4 2}"
	di `ae' "Valid statistics in the {bf:statistic()} option of "
	di `ae' "{bf:simulate()} are {bf:mean}, "
	di `ae' "{bf:variance}, and {bf:stddev}."
	di `ae' "{p_end}"
	exit 198
end

program fc_parse_sim_stat_nopfxsfx

	local ae as error
	di `ae' "must specify {bf:prefix()} or {bf:suffix()}"
	di `ae' "{p 4 4 2}"
	di `ae' "You must specify either a valid variable prefix or suffix "
	di `ae' "in the {bf:statistic()} option of {bf:simulate()}."
	di `ae' "{p_end}"
	exit 198
end


program fc_parse_sim_nostat

	local ae as error
	di `ae' "option {bf:statistic()} required"
	di `ae' "{p 4 4 2}"
	di `ae' "You must specify the {bf:statistic()} option at least once "
	di `ae' "in {bf:simulate()}.{p_end}"
	exit 198
end


program fc_parse_sim_statlimit

	local isae in smcl as error
	di `isae' "syntax error"
	di `isae' "{p 4 4 2}"
	di `isae' "You can specify the {bf:statistic()} option of "
	di `isae' "{bf:simulate()} at most three times.{p_end}"
	exit 198
end



/*
	Error handler
		rc	return code to user

*/
program ErrOut

	args rc 
	mata:fc_cleanup()
	exit `rc'
end


/*
	NB this just prints the range of the time var.  Does not exit
	with an error message or anything like that.
*/
program _fc_timeper_outofrange

	args tvar min max
	
	local fmt : format `tvar'
	local isae in smcl as error

	local nicemin : di `fmt' `min'
	local nicemax : di `fmt' `max'
	
	di `isae' "Time variable {bf:`tvar'} runs from " _c
	di `isae' "{bf:`nicemin'} through {bf:`nicemax'}."
	
end

/*
	Returns observation number of dataset currently in memory of time 
	period specified (for first panel, if panel data).
*/
program _fc_parse_timeper, sclass

			/* renamed 'period' to 'tper' to avoid confusion with
			   periods() option
			*/
	args ivar tvar tper optname
	
	local isae in smcl as err
	summ `tvar' if `ivar' == 1, mean
	local min = r(min)
	local max = r(max)
	if ((`tper' < `min') | (`tper' > `max')) {
		di `isae'  "{bf:`optname'(`tper')} out of range"
		di `isae'  "{p 4 4 2}"
		_fc_timeper_outofrange `tvar' `min' `max'
		if (`tper' > `max') {
			di `isae' "To forecast beyond the end of this dataset "
			di `isae' "you must use {bf:tsappend} to expand the "
			di `isae' "dataset, and you must populate the "
			di `isae' "exogenous variables in the model."
		}
		di `isae' "{p_end}"
		exit 459
			/* Not Reached */
	}
	
			/* Can this test ever be true? */
	qui count if `tvar' == `tper' & `ivar' == 1
	if r(N) == 0 {
		local fmt : format `tvar'
		di `isae' "{bf:`optname'(`tper')} invalid"
		di `isae' "{p 4 4 2}"
		di `isae' "time period " `fmt' `tper' _c
		di `isae' " not found in dataset. "
		_fc_timeper_outofrange `tvar' `min' `max'
		di `isae' "{p_end}"
		exit 459
	}
	
	summ `tvar' if `tvar' < `tper' & `ivar' == 1, mean
	
	sreturn local obsno = r(N)+1

end



/*
	Handles periods() option
*/
program _fc_parse_periods, sclass

	args ivar tvar periods first
	
	local isae in smcl as err
	if `periods' < 1 {
		di `isae' "syntax error"
		di `isae' "{p 4 4 2}"
		di `isae' "Option {opt periods()} must be a positive integer."
		di `isae' "{p_end}"
		exit 198
	}
	
	local last_obs = `first' + `periods' - 1

	qui count if `ivar' == 1
	if (r(N) < `last_obs') {
		summ `tvar' if `ivar' == 1
		di `isae' "invalid {opt periods()} specification"
		di `isae'  "{p 4 4 2}"
		_fc_timeper_outofrange `tvar' `r(min)' `r(max)'
		di `isae' "To forecast beyond the end of this dataset "
		di `isae' "you must use {bf:tsappend} to expand the "
		di `isae' "dataset, and you must populate the "
		di `isae' "exogenous variables in the model."
		di `isae' "{p_end}"
		exit 459
	}

	sreturn local obsno = `last_obs'
	
end


/*
	When finding the beginning time period, start at T and go backwards.
	Find the most recent (latest) t for which all of var_endog have 
	non-missing data.  Then return t+1.  That time represents the
	time at which we no longer have historical data and therefore
	need to start forecasting.
	
	When finding the ending time period, find the most recent (latest)
	t for which all of (var_all - var_endog) variables have valid 
	data.  [(var_all - var_endog) represents the exogenous variable.]
	
	syntax:
	
		_fc_find_begin_end_t <timevar> {min|max}
		
			depending on whether you're searching for
			minimum or maximum time period
			
	For a time series, obsno is the actual observation number, as
	if the time variable ran from 1, 2, ..., T.
	
	For panel data, obsno is the actual observation number, as if
	the time variable ran from 1, 2, ..., T FOR THE FIRST PANEL.
*/

program _fc_find_begin_end_t, sclass

	args capT beginend
	
	local obsno
	mata:fc_find_begin_end_t_wrk(`capT', "`beginend'", "obsno")

	if "`beginend'" == "begin" & `obsno' == -1 {
		local ae as error
		di `ae' "cannot determine first period to forecast"
		di `ae' "{p 4 4 2}"
		di `ae' "No time periods at the end of dataset have missing " _c
		di `ae' "values for endogenous variables. Therefore, " _c
		di `ae' "{cmd:forecast solve} cannot determine the period " _c
		di `ae' "in which forecasting should begin. Use option " _c
		di `ae' "{opt begin()} to specify the first period to " _c
		di `ae' "forecast.{p_end}"
		exit 459 
	}
	
	if "`beginend'" == "end" & `obsno' == 0 {
		local ae as error
		di `ae' "cannot determine last period to forecast"
		di `ae' "{p 4 4 2}"
		di `ae' "No time periods have non-missing values for " _c
		di `ae' "exogenous variables. Therefore, " _c
		di `ae' "{cmd:forecast solve} cannot determine " _c
		di `ae' "which periods to forecast. Use option " _c
		di `ae' "{opt end()} to specify the last period to " _c
		di `ae' "forecast.{p_end}"
		exit 459 
	}
	
	sreturn local obsno = `obsno'
end

/*
	fc_solve_technique `"`technique'"'
*/
program _fc_solve_technique, sclass

	args input
	
	local ae as error
	
	gettoken usr opts : input
	
			// Get technique
	local l = strlen("`usr'")
	if `"`usr'"' == bsubstr("gaussseidel", 1, max(3, `l')) {
		local tech	"gaussseidel"
	}
	else if `"`usr'"' == bsubstr("dampedgaussseidel", 1, max(3, `l')) {
		local tech	"dampedgaussseidel"
	}
	else if `"`usr'"' == bsubstr("broydenpowell", 1, max(3, `l')) {
		local tech	"broydenpowell"
	}
	else if `"`usr'"' == bsubstr("newtonraphson", 1, max(3, `l')) 	///
		| `"`usr'"' == "nr" {
		local tech	"newton"
	}
	else if `"`usr'"' != "" {
		di `ae' "invalid solver technique"
		exit 198
	}

			// Get damped GS damping
	if "`tech'" == "dampedgaussseidel" & `"`opts'"' != "" {
		local optnum = real(`"`opts'"')
		if `optnum' >= 1 | `optnum' < 0 {
			di `ae' "invalid damping factor"
			di `ae' "{p 4 4 2}"
			di `ae' "Damping factor for solver method "
			di `ae' "{opt dampedgaussseidel} must be at least "
			di `ae' "zero (no damping) and less than one "
			di `ae' "(maximal damping).{p_end}"
			exit 198
		}
	}
	
	if "`tech'" != "dampedgaussseidel" & `"`opts'"' != "" {
		di `ae' "cannot specify damping parameter with {opt `tech'}"
		exit 198
	}
	
	if "`tech'" == "" {
		local tech "dampedgaussseidel"			// default
	}
	if "`tech'" == "dampedgaussseidel" & "`optnum'" == "" {
		local optnum = 0.2			// default
	}
	
	sreturn local tech = "`tech'"
	if "`tech'" == "dampedgaussseidel" {
		sreturn local damping = `optnum'
	}
end


/*
	This is called only if last_obs < first_obs
	the auto macros are "yes" if we searched for them automatically
*/
program fc_obs_err 

	args first_obs last_obs autobegin autoend
	
	local ae "as error"
	if "`autobegin'" == "yes" & "`autoend'" == "yes" {
		di `ae' "no apparent forecast period"
		di `ae' "{p 4 4 2}"
		di `ae' "There are no periods "
		di `ae' "in which the exogenous variables contain "
		di `ae' "valid data while the endogenous variables contain "
		di `ae' "missing values. "
		di `ae' "{p_end}"
		exit 498
			/* NOT REACHED */
	}
	else if "`autobegin'`autoend'" != "" {
		di `ae' "could not determine periods in which forecasts " _c
		di `ae' "should be made"
		di `ae' "{p 4 4 2}"
		di `ae' "Specify starting and ending periods "
		di `ae' "explicitly using options "
		di `ae' "{bf:begin()} and either {bf:end()} or {bf:periods()}."
		di `ae' "{p_end}"
		exit 498
			/* NOT REACHED */
	}
	else {
		di `ae' "{bf:end()} cannot be less than {bf:begin()}"
		exit 198
	}

end



/*
	Makes a panel var = 1, 2, ... based on user's panel variable
	so we can loop more easily.
	
	Assumes data already sorted by user's panel variable!
*/
program fc_make_contig_ivar

	args newvar colon oldvar 
	
	qui {
		bys `oldvar' : gen `c(obs_t)' `newvar' = 1 if _n == 1
		replace `newvar' = sum(`newvar')
	}

end



/*
	Verify specified convergence tolerances are sane
*/

program fc_check_tolerance, sclass

	args vtolerance ztolerance
	
	foreach type in v z {
		capture confirm number ``type'tolerance'
		if _rc {
			fc_tolerance_err "`type'"
				// Not reached
		}
		
		if ``type'tolerance' != -1 {
			if ``type'tolerance' >= 1 | ``type'tolerance' <= 0 {
				fc_tolerance_err "`type'"
					// Not reached
			}
		}
		else {
			local `type'tolerance = 1e-9
		}
		sreturn local `type'tolerance = ``type'tolerance'
	}

end

program fc_tolerance_err

	args t
	
	di in smcl as error "{opt `t'tolerance()} must be between 0 and 1"
	exit 125
	
end

/*
	iterate() default is 500.  We do not look at whatever 
	-set maxiter- is; the default of 16000 is way too much
	for our purposes.  Even 500 is a lot.  Moreover, iterate()
	must be in [1, 16000].  Setting iter(0) makes no sense here.
*/
program fc_check_iterate, sclass

	args iter
	
	capture confirm integer number `iter'
	if _rc	fc_iterate_err				/* Not Reached */
	
	if (`iter' < 1 | `iter' > 16000) fc_iterate_err	/* Not Reached */
	
	sreturn local iterate = `iter'
	
end

program fc_iterate_err

	di in smcl as error "{opt iterate()} must be between 1 and 16,000"
	exit 198

end
	



/*
	log(DEtail)
	log(ON)			-- These two are equivalent when we
	log(BRief)		-- are not solving a panel-data model
	log(OFf)
	
	brief is the default (log(on) could produce copious amounts of
			      output with a very large panel dataset)
*/
program fc_parse_log, sclass

	args input

			// Default case
	if `"`input'"' == "" {
		if (c(iterlog)=="off") {
			sreturn local logtype "off"
		}
		else {	
			sreturn local logtype "brief"
		}	
		exit
	}
	
	local keylen = strlen("`input'")
	if "`input'" == bsubstr("detail", 1, max(2, `keylen')) {
		sreturn local logtype "detail"
		exit
	}
	else if "`input'" == bsubstr("on", 1, max(2, `keylen')) {
		sreturn local logtype "on"
		exit
	}
	else if "`input'" == bsubstr("brief", 1, max(2, `keylen')) {
		sreturn local logtype "brief"
		exit
	}
	else if "`input'" == bsubstr("off", 1, max(2, `keylen')) {
		sreturn local logtype "off"
		exit
	}
	else {
		local isae in smcl as error
		di `isae' "loglevel `input' not allowed"
		di `isae' "{p 4 4 2}Valid {it:loglevel}s for option "
		di `isae' "{opt log(loglevel)} are "
		di `isae' "{bf:detail}, "
		di `isae' "{bf:on}, "
		di `isae' "{bf:brief}, and"
		di `isae' "{bf:off}"
		di `isae' "{p_end}"
		exit 198
	}
	
end



program _fc_end_per_error

	local isae in smcl as error
	
	di `isae' "cannot specify {opt periods()} and {opt end()}"
	di `isae' "{p 4 4 2}"
	di `isae' "You can specify the number of periods to forecast using the "
	di `isae' "{opt periods()} option or the final period to forecast "
	di `isae' "using the {opt end()} option, but you cannot specify both."
	di `isae' "{p_end}"
	
	exit 198

end


/*
	Output footer
	
	Forecast ## variables spanning ## periods. (38 + # chars long)
						   (37 + if one period)
						   (37 + if one variable)
	Forecast ## variables spanning ## periods for ## panels. 
						(50 + )
						(48 + if 1 per & panel)
	Forecasts used actual values if available. (42) (if actuals != "")
*/
program fc_footer

	args Npanels first_obs last_obs actuals

	local is in smcl
	
	local Nvar xt			// set in mata code
	mata:_fc_get_footer_info("Nvar", "xt")
	
	local Nper = `last_obs' - `first_obs' + 1
	
	local ts ""
	if `Nper' > 1		local ts "s"
	
	local pans ""
	if `Npanels' > 1	local pans "s" 
	
	local vars ""
	if `Nvar' > 1		local vars "s"
	
	di `is' as text "Forecast "				///
		as res  `Nvar'					///
		as text " variable`vars' spanning "		///
		as res  `Nper'					///
		as text " period`ts'" _c
		
	if "`xt'" != "" {
		di `is' as text " for "				///
			as res  `Npanels'			///
			as text " panel`pans'."
	}
	else {
		di `is' as text "."
	}

	local Nvarstr : di `Nvar'
	local Nperstr : di `Nper'
	local howlong = 36 + strlen("`Nvarstr'") + 		///
			     strlen("`Nperstr'") +		///
			     ("`ts'" != "") + ("`vars'" != "")
	if "`xt'" != "" {
		local Npanstr : di `Npanels'
		local howlong = `howlong' + 11 + 			///
				strlen("`Npanstr'") +			///
				("`pans'" != "")
	}
	
	if "`actuals'" != "" {
		di in smcl as text "Forecasts used actual values if available."
		local howlong = max(`howlong', 42)
	}
	
	di in smcl as txt "{hline `howlong'}"
	
end
	


/*
	Output header

	          static
	          -------
	Computing dynamic forecasts for model <modelname>.
	--------------------------------------------------
	Starting period: <2012m1>
	Ending period:   <2015m12>
	Forecast suffix: <_suffix>    (or prefix)

*/

program fc_header

	syntax,   first_obs(integer) last_obs(integer)			///
		  npanels(integer)   is_xt_bool(integer)		///
		[ prefix(string)     suffix(string) 			///
		  static(string) ]
	
	
	fc_get_modelname
	local name  `r(modelname)'
	
	if "`static'" != "" {
		local type static
	}
	else {
		local type dynamic
	}
	if "`name'" == "" {
		local title "Computing `type' forecasts for current model."
	}
	else {
		local title "Computing `type' forecasts for model `name'."
	}
	local title_len = strlen("`title'")
	
		// We know data is tsset or xtset
	local tvar `:char _dta[_TStvar]'
	local tformat : format `tvar'
	
	summ `tvar' in `first_obs', mean
	local start : display `tformat' `r(mean)'
	local start = strtrim("`start'")
	
	summ `tvar' in `last_obs', mean
	local end : display `tformat' `r(mean)'
	local end = strtrim("`end'")
		// Save for potential reuse later
	mata:_fc_set_pretty_times("`start'", "`end'")
		
	local is in smcl
	local at as text
	local ar as result
	
	di
	di `is' `at' "Computing " _c
	di `is' `ar' "`type' " _c
	di `is' `at' "forecasts for " _c
	if "`name'" == "" {
		di `is' `at' "current model."
	}
	else {
		di `is' `at' "model " `ar' "`name'."
	}
	di `is' `at' "{dup `title_len':{c -}}"
	di `is' `at' "Starting period:  " `ar' "`start'"
	di `is' `at' "Ending period:    " `ar' "`end'"
	
	if `is_xt_bool' {
		di `is' `at' "Number of panels: " `ar' "`npanels'"
	}
	
	if "`prefix'" != "" {
		di `is' `at' "Forecast prefix:  " `ar' "`prefix'"
	}
	else {
		di `is' `at' "Forecast suffix:  " `ar' "`suffix'"
	}
	di
	
end



exit
