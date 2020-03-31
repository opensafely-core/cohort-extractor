*! version 4.4.1  11sep2015
program define lrtest, rclass

	local caller = _caller()
	if `caller' < 8 {
		_lrtest7 `0'
		return add
		exit
	}

	version 8

	// translate old syntax into new syntax

	if `"`e(prefix)'"' == "svy" {
		di as err ///
		"{bf:lrtest} is not appropriate with survey estimation results"
		exit 322
	}

	gettoken tok : 0, parse(" ,")
	if `"`tok'"' == "," | `"`tok'"' == "" {
		OldSyntax `caller' `"`0'"'
		local 0 `r(newsyntax)'
		if `"`0'"' == "" {
			exit
		}
	}

	// extract the specification of the models for the test

	ParseSpecTest `"`0'"'
	local model1 `r(model1)'
	local model2 `r(model2)'
	local 0 `r(rest)'
	if !replay() {
		di as err `"invalid input following specifications: `0'"'
		exit 198
	}
	local nmodel1 : word count `model1'
	local nmodel2 : word count `model2'
	local Qcomposite = (`nmodel1' > 1) | (`nmodel2' > 1)


	// parse the rest of the syntax

	syntax [, Df(str) FORCE STats DIr ASIS ]

	local Qforce = ("`force'" != "")
	local Qasis  = ("`asis'"  != "")
	local Qdir   = ("`dir'"   != "")
	local Qstats = ("`stats'" != "")

	if "`df'" == "-9" {
		// for compatibility with versions <=7
		local df
	}

	if "`df'" != "" {
		confirm number `df'
		capt assert `df' > 0
		if _rc {
			di as err "df() should be positive"
			exit 198
		}
		capt confirm integer number `df'
		if _rc {
			di as txt "(specified degrees of freedom is not " ///
			   "an integer (`df'))"
		}
	}


	/*
		extract results from retained models into scalars with

			prefix  r = restricted   model
			prefix  u = unrestricted model
	*/

	tempname u_N u_df u_ll u_ll0  r_N r_df r_ll r_ll0 tmp	///
		u_num_ce r_num_ce u_kf u_krc u_krs r_kf r_krc r_krs ///
		u_num_st r_num_st

	local unrestricted `model1'   // guess the unrestricted model
	local restricted   `model2'   // maybe swap below

	GetInfo "`unrestricted'" `Qforce'
	scalar `u_N'      = r(N)
	scalar `u_df'     = r(df)
	scalar `u_ll'     = r(ll)
	scalar `u_ll0'    = r(ll_0)
	scalar `u_num_ce' = r(num_ce)
	scalar `u_num_st' = r(num_st)
	local  u_cmd        `r(cmd)'
	local  u_depvar     `r(depvar)'
	//
	local  u_mixed_method `r(mixed_method)'
	local  u_model `r(model)'
	scalar `u_kf' = r(k_f)
	scalar `u_krc' = r(k_rc)
	scalar `u_krs' = r(k_rs)

	GetInfo "`restricted'" `Qforce'
	scalar `r_N'      = r(N)
	scalar `r_df'     = r(df)
	scalar `r_ll'     = r(ll)
	scalar `r_ll0'    = r(ll_0)
	scalar `r_num_ce' = r(num_ce)
	scalar `r_num_st' = r(num_st)
	local  r_cmd        `r(cmd)'
	local  r_depvar     `r(depvar)'
	//
	local  r_mixed_method `r(mixed_method)'
	local  r_model `r(model)'
	scalar `r_kf' = r(k_f)
	scalar `r_krc' = r(k_rc)
	scalar `r_krs' = r(k_rs)
	local k1 = "`u_model'"=="nbinomial" & "`r_model'"=="Poisson"
	local k2 = "`r_model'"=="nbinomial" & "`u_model'"=="Poisson"
	if `k1' | `k2' local conservative conservative

	if (`u_df' < `r_df')  &  (!`Qasis') {
		// guessed wrong which was unrestricted model
		// swap restricted and unrestricted
		local unrestricted `model2'
		local restricted   `model1'

		foreach m in cmd depvar mixed_method {  	//  macros
			local bup   `u_`m''
			local u_`m' `r_`m''
			local r_`m' `bup'
		}
		foreach m in N df ll ll0 kf krc krs { 	// scalars
			scalar `tmp'   = `u_`m''
			scalar `u_`m'' = `r_`m''
			scalar `r_`m'' = `tmp'
		}
	}

	if `"`u_cmd'"'`"`r_cmd'"'=="mswitch" & `u_num_st'!=`r_num_st' {
		di as err "{p}cannot compute test statistic after " ///
			"{bf:mswitch} when the number of states are "	     ///
			"different{p_end}"
		exit 498
	}

	/*
		check assumptions for LR test (nesting...),
		only for non-composite models
	*/

	tempname tdf
	scalar `tdf' = `u_df' - `r_df'
	if "`df'" != "" {
		scalar `tdf' = `df'
	}

	if !`Qforce' {

		if ("`u_cmd'" == "vec" | "`r_cmd'" == "vec" ) {
			if `u_num_ce' != `r_num_ce' {
				di as err "{p 0 4}constrained and "	/// 
					"unconstrained models do not "	///
					"have the same number of " 	///
					"cointegrating equations{p_end}
				exit 498	
			}
		}


	
		if `tdf' < 0 {
			di as err "df(unrestricted) < df(restricted): " ///
			   `u_df' " < " `r_df'
			exit 498
		}
		else if `tdf' == 0 {
			di as err "df(unrestricted) = df(restricted) = " `u_df'
			exit 498
		}
	}
	
	if !`Qforce' & !`Qcomposite' {
		
		local is_me = "`e(mecmd)'"!=""
		local is_xtme = inlist("`e(mecmd)'","xtmixed","xtmelogit", ///
			"xtmepoisson","mixed","meqrlogit","meqrpoisson")
		
		if `is_me' | `is_xtme' {
			if `u_kf' < `r_kf' | `u_krc' < `r_krc' | ///
			   `u_krs' < `r_krs' {
di as err "{p 0 4 2}Mixed models are not nested{p_end}"
				exit 498
			}
			if ("`u_mixed_method'" != "`r_mixed_method'") {
di as err "cannot compare a REML model with an ML model"
				exit 498
			}
			if ("`u_mixed_method'" == "REML") {
				if `u_kf' != `r_kf' {
di as err "{p 0 4 2}REML criterion is not comparable under different "
di as err "fixed-effects specifications{p_end}"
					exit 498
				}
				local remlnote remlnote
			}
			
			if (`u_krs' != `r_krs') {
				local conservative conservative
			}
		}

		if `u_N' != `r_N' {
			di as err "observations differ: " `u_N' " vs. " `r_N'
			exit 498
		}

		// note that "_est hold name" saves e(sample) into a byte
		// varname _est_name.  Note that this var may have been dropped.

		local smp1 = cond("`model1'"!=".", "_est_`model1'", "e(sample)")
		local smp2 = cond("`model2'"!=".", "_est_`model2'", "e(sample)")
		capt assert `smp1'==0 | `smp2'==0
		if _rc==0 {
			di as txt "(samples cannot be compared, sample info is missing)"
		}
		else {
			capt assert `smp1'==`smp2' if `smp1'>=. & `smp2'>=.
			if _rc == 9 {
				di as err "samples differ"
				exit 498
			}
			capt assert `smp1'!=1 if `smp2'>=.
			if _rc == 9 {
				di as err "samples differ"
				exit 498
			}
			capt assert `smp2'!=1 if `smp1'>=.
			if _rc == 9 {
				di as err "samples differ"
				exit 498
			}
		}

		if "`u_cmd'" != "`r_cmd'" {
			di as err "test involves different estimators: " ///
			   "`u_cmd' vs. `r_cmd'"
			exit 498
		}

		if ("`u_depvar'" != "") & ("`r_depvar'" != "") & ///
		   (!`:list u_depvar === r_depvar') {
			di as err "dependent variables differ: " ///
			   "`u_depvar' vs. `r_depvar'"
			exit 498
		}

		if !missing(`u_ll0') & !missing(`r_ll0') {
			if reldif(`u_ll0',`r_ll0') > 1E-6 {
				di as err "log likelihood of null" ///
				   " models differ:" ///
				   %9.0g `u_ll0' " vs. " %9.0g `r_ll0'
				exit 498
			}
		}
	}

	/*
		compute test
	*/
	
	ret scalar df   = `tdf'
	ret scalar chi2 = -2*(`r_ll' - `u_ll')
	if "`chibar'" == "" {
		ret scalar p    = chiprob(return(df), return(chi2))
	}
	else {
		ret local chibar chibar
		if return(df) == 1 {
			ret scalar p = cond(return(chi2)>1e-5, ///
				chiprob(return(df), return(chi2))/2, 1)
		}
		else {
			ret scalar p = ///
			   0.5*chiprob(return(df)-1,return(chi2)) + ///
			   0.5*chiprob(return(df),return(chi2))
		}
	}	

	// double save for backward compatibility
	global S_3 = return(df)
	global S_6 = return(chi2)
	global S_7 = return(p)

	/*
		display result
	*/

	if "`chibar'" == "" {
		di as txt _n "Likelihood-ratio test" _col(55)  ///
	   	   "LR chi2(" as res return(df) as txt ")"     ///
	   	   _col(67) "=" as res %10.2f return(chi2)
	}
	else {
		if return(df) == 1 {
			local dfdisp 01
		}
		else {
			local dfdisp : display return(df)-1 "_" return(df)
		}
		di as txt _n "Likelihood-ratio test" _col(51)  ///
		   "{help j_chibar##|_new:LR chibar2(`dfdisp')}" ///
                   _col(68) "{help j_chibar##|_new:=}" as res %10.2f return(chi2)
	}

	if !`Qcomposite' {
		local rabbrev "`restricted'"
		local uabbrev "`unrestricted'"
		if "`restricted'" != "." {	// abbrev returns "" for "."
			local rabbrev : display abbrev("`restricted'", 14)
		}
		if "`unrestricted'" != "." {
			local uabbrev : display abbrev("`unrestricted'", 14)
		}
		di as txt "(Assumption: "                                    ///
		   as res "{stata est replay `restricted':`rabbrev'}"        ///
		   as txt " nested in "                                      ///
		   as res "{stata est replay `unrestricted':`uabbrev'}"      ///
		   as txt ")" _c

		if "`chibar'" == "" {
			di as txt _col(55) "Prob > chi2 = " as res   ///
				%9.4f return(p)
		}
		else {
			di as txt _col(51) "Prob > chibar2   = " as  ///
				res %9.4f return(p)
		}
	}
	else {
		di _col(55) as txt "Prob > chi2 = " as res %9.4f return(p) _n

		di as txt "{p}Assumption: (" _c
		foreach m of local restricted {
			di as res "{stata est replay `m':`m'}" _c
			if "`ferest()'" != "" {
				di as txt ", " _c
			}
		}
		di as txt ") nested in (" _c
		foreach m of local unrestricted {
			di as res "{stata est replay `m':`m'}" _c
			if "`ferest()'" != "" {
				di as txt ", " _c
			}
		}
		di as txt "){p_end}"
	}
	if "`conservative'" != "" {
		di 
di as txt "{p 0 6 2}Note: The reported degrees of freedom assumes the null hypothesis is not on the boundary of the parameter space.  If this is not true, then the reported test is {help j_mixedlr##|_new:conservative}.{p_end}"
	}
	if "`remlnote'" != "" {
		if "`conservative'" == "" {
			di 
		}
di as txt "{p 0 6 2}Note: LR tests based on REML are valid "
di as txt "only when the fixed-effects specification is identical for "
di as txt "both models.{p_end}"
	}

	if "`stats'" != "" {
		est stats `restricted' `unrestricted'
	}
	if "`dir'" != "" {
		est dir `restricted' `unrestricted' , width(78)
	}
end


// ----------------------------------------------------------------------------
//   subroutines
// ----------------------------------------------------------------------------


/* GetInfo

   returns in r()
     N     number of obs
     df    df of model (rank e(V))
     ll    log likelihood of model
     ll_0  log likelihood of null-model
   With composite specifications, these values are summed over all model
   in the namelist.
*/
program define GetInfo, rclass
	args namelist Qforce

	tempname V rank N df ll ll_0 hcurrent esample num_ce 

	scalar `N'    = 0
	scalar `df'   = 0
	scalar `ll'   = 0
	scalar `ll_0' = 0

	_est hold `hcurrent' , restore nullok estsystem

	foreach name of local namelist {
		nobreak {
			if "`name'" != "." {
				est_unhold `name' `esample'
			}
			else	_est unhold `hcurrent'


			capture noisily {
				if !`Qforce' {
					if "`e(vcetype)'" == "Robust" {
						di as err ///
						"LR test likely invalid for models with robust vce"
						exit 498
					}
					if "`e(clustvar)'" != "" {
						di as err ///
						"LR test likely invalid with cluster(`e(clustvar)')"
						exit 498
					}
					if "`e(wtype)'" == "pweight" {
						di as err ///
						"LR test invalid in case of pweighted estimators"
						exit 498
					}
					if "`e(crittype)'" == "log pseudolikelihood" {
						di as err ///
						"LR test likely invalid with log pseudolikelihoods"
						exit 498
					}
				}

				if "`e(cmd)'" == "vec" {
					local n_names: word count `namelist'
					if `n_names' > 1 {
						di as err	///
						"composite models not "	///
						"after {cmd:vec}"
						exit 498
					}
					scalar `rank' = e(k_rank)
					if `rank' >= . {
						di as err 	///
						"number of estimated "	///
						"parameters not "	///
						"available for model "	///
						"`name'"

						exit 498
					}
					scalar `num_ce' = e(k_ce)

				}
				else {
					scalar `rank' = e(rank)
					scalar `num_ce'  =   .
				}

				if "`e(cmd)'" == "mswitch" {
					return scalar num_st = e(states)
				}

				tempname k_f k_rc k_rs
				
				local is_me = "`e(mecmd)'"!=""
				local is_xtme = inlist("`e(mecmd)'",	///
					"xtmixed","xtmelogit","xtmepoisson", ///
					"mixed","meqrlogit","meqrpoisson")
				
				if `is_me' | `is_xtme' {
					local n_names: word count `namelist'
					if `n_names' > 1 {
						di as err	///
						"composite models not "	///
						"allowed after {cmd:`e(cmd)'}"
						exit 498
					}
					scalar `k_f' = e(k_f)
					scalar `k_rc' = e(k_rc)
					scalar `k_rs' = e(k_rs)	
					scalar `rank' = e(rank)
					local mixed_method `e(method)'
					local model `e(model)'
				}
				else {
					scalar `k_f' = .
					scalar `k_rc' = .
					scalar `k_rs' = .
				}
				if `rank' == . {
					// 24mar2003  confirm matrix e(V) does not work !
					capt mat `V' = syminv(e(V))					
					if _rc == 111 {
						dis as txt "(`name' does not contain matrix e(V); rank = 0 assumed)"
						scalar `rank' = 0
					}
					else if _rc != 0 {
						// produce error message
						mat `V' = syminv(e(V))
					}
					else {
						scalar `rank' = rowsof(`V') - diag0cnt(`V')
						if `rank' == 0 {
							dis as err "(`name' has e(V) with rank = 0)"
							// exit 498
						}	
					}
				}

				capt confirm scalar e(ll)
				if _rc {
					di as err "`name' does not contain scalar e(ll)"
					exit 498
				}
				if e(ll) == . {
					di as err "`name': e(ll) is missing"
					exit 498
				}

				scalar `N'    = `N'  + e(N)
				scalar `df'   = `df' + `rank'
				scalar `ll'   = `ll' + e(ll)
				scalar `ll_0' = `ll_0' + e(ll_0)

				local cmd    `cmd' `e(cmd)'
				local depvar `depvar' `e(depvar)'
			}
			local rc = _rc

			if "`name'" != "." {
				est_hold `name' `esample'
			}
			else	_est hold `hcurrent', restore nullok estsystem
		}
		if `rc' {
			exit `rc'
		}
	}

	return local cmd     `cmd'
	return local depvar  `depvar'

	return scalar N      = `N'
	return scalar df     = `df'
	return scalar ll     = `ll'
	return scalar ll_0   = `ll_0'
	return scalar num_ce = `num_ce'
	return scalar k_f    = `k_f'
	return scalar k_rc   = `k_rc'
	return scalar k_rs   = `k_rs'

	return local mixed_method `mixed_method'
	return local model `model'
end


/* ParseSpecTest cmdline

   parses the specifications of the restricted and unrestricted models,
   returning the expanded lists in r(model1) and r(model2).

   The rest of cmdline is returned in r(rest).
*/
program define ParseSpecTest, rclass
	args cmdline

	// get specification of model 1 (unrestricted model)

	gettoken model1 cmdline : cmdline , parse(" ,") match(parens)
	if inlist(`"`model1'"', "", ",") {
		di as err "name(s) of estimation results expected"
		exit 198
	}
	est_expand "`model1'"
	local model1 `r(names)'
	local nmodel1 : word count `model1'

	// get specification of model 2 (unrestricted model)

	gettoken model2 : cmdline , parse(" ,") match(parens)
	if inlist(`"`model2'"', "", ",") {
		// model2 not specified; default to . (last est results)
		if "`e(cmd)'" != "" {
			local model2  .
		}
		else {
			di as err "last estimates not found"
			di as err "second specification expected"
			error 301
		}
	}
	else {
		gettoken model2 cmdline : cmdline , parse(" ,") match(parens)
	}
	est_expand "`model2'"
	local model2 `r(names)'
	local nmodel2 : word count `model2'

	// check for "overlap" between models

	local overlap : list model1 & model2 
	if "`overlap'" != "" {
		di as err "models `overlap' specified more than once"
		exit 198
	}

	return local rest   `cmdline'
	return local model1 `model1'
	return local model2 `model2'
end


/* OldSyntax

   returns in r(newsyntax) a command line in the new syntax.
   The option -saving()- is implemented via -estimates store-.
*/
program define OldSyntax, rclass
	args caller cmdline

	local 0 `"`cmdline'"'
	syntax [, Saving(string) Using(string) Model(string) Df(passthru) FORCE]

	if `"`saving'"' != "" {
		/*
		   store with a prefix LRTEST_
		   lrtest did not enforce that the names were valid identifiers

		   lrtest used to return rc=301 if N, e(ll), or df were missing
		   we mimick this behavior here.
		*/

		capture confirm integer number `e(N)'
		if _rc {
			di as err "`e(cmd)' does not store e(N)"
			exit 301
		}
		capture confirm number `e(ll)'
		if _rc {
			di as err "`e(cmd)' does not store e(ll)"
			exit 301
		}
		capture confirm matrix e(V)
		if _rc {
			di as err "`e(cmd)' does not store e(V)"
			exit 301
		}

		est store LRTEST_`saving', title(saved by lrtest--old syntax)

		if `"`using'`model'"' == "" {
			exit
		}
	}

	// using() : -unrestricted- ; defaults to 0 (stored as LRTEST_0)
	// model() : -restricted- ; defaults to . (last estimation result)

	if "`using'" == "" {
		capt est_cfexist LRTEST_0
		if _rc {
			di as err "{p}" ///
			  "In the old syntax, the unrestricted model defaulted " ///
			  "to a model saved under the name 0.  This model was not " ///
			  "found.{p_end}"
			exit 198
		}
		local using LRTEST_0
	}
	else {
		local using LRTEST_`using'
	}


	if "`model'" == "" {
		if "`e(cmd)'" == "" {
			di as err "{p}"
			  "In the old syntax, the restricted model defaulted to " ///
			  "the last estimation results.  These were not found."   ///
			  "{p_end}"
			exit 198
		}
		local model .
	}
	else {
		local model LRTEST_`model'
	}

	return local newsyntax `"`using' `model' , `force' `df'"'

	if `caller' > 7 {
		di "{p}" as txt
		di  "You ran lrtest using the old syntax. "
		di "Click {help lrtest##|_new:here} to learn about the new syntax."
		di "{p_end}" _n
	}
end
exit
