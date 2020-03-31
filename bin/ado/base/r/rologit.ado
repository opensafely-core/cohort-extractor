*! version 1.8.1  19aug2019
program rologit, eclass byable(onecall) prop(cm)
	version 8.0
	local vv : di "version " string(_caller()) ", missing:"

	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	
	if replay() {
		if "`e(cmd)'" != "rologit" & "`e(cmd)'" != "cmrologit" {
			error 301
		}
		if _by() {
			error 190
		}
		Display `0'
		exit
	}
	
	local cmdline : copy local 0
	local cmdline : list retokenize cmdline

	qui syntax [anything] [fw iw pw] [if] [in], ///
		GRoup(varname)			    ///
		[ 				    ///
                  Cluster(varname)                  ///
                  VCE(passthru)                     ///
                  CM                                /// 
                  *                                 ///
                ]

	if ("`cm'" != "") {
		local cmd       cmrologit
		local groptname tempcaseid
		local grmark    TEMPCASEID
	}
	else {
		local cmd       rologit
		local groptname group
		local grmark    GRoup
	}

	if (`"`vce'"' != "") {
		local group0 `group'
		tempname id
		
		_vce_cluster `cmd',		///
			groupvar(`group')	///
			newgroupvar(`id')	///
			groptname(`groptname')	///
			`vce'			///
			cluster(`cluster')
		
		local vce   `"`s(vce)'"'
		local idopt   `s(idopt)'
		local clopt   `s(clopt)'
		local gropt   `s(gropt)'
		local bsgropt `s(bsgropt)'
		
		if "`s(cluster)'" != "" {
			local ccheckopt clustercheck(`s(cluster)')
		}
		
		if ("`weight'" != "") {
			local wgt [`weight'`exp']
		}
		
		local vceopts jkopts(`clopt' notable noheader)               ///
			bootopts(`clopt' `idopt' `bsgropt' notable noheader) ///
			mark(`grmark' OFFset CLuster)
		
		`vv' ///
		`by' _vce_parserun `cmd', `vceopts' : ///
			`anything' `wgt' `if' `in',   ///
			`gropt' `vce' `options' `ccheckopt'
		
		if ("`s(exit)'" != "") {
			
			RemoveClusterCheck `e(command)'
			
			if ("`cm'" != "") {
				ereturn        local caseid `group'
				ereturn hidden local group  `group'
				
				// Remove tempcaseid() option when -cmrologit-
				// and reset e(command).
				
				RemoveTempcaseid `e(command)' 
			}
			else {
				ereturn local group `group'

				// Remove tempvar `id' from group() option when 
				// -rologit-.
			
				local cmd1 `"`e(command)'"'

				if "`cluster'" == "" & "`cm'" == "" {
					local cmd2 : subinstr local cmd1 "`id'" "`group'"
				}
				
				local cmd2 : list retokenize cmd2

				ereturn local command  `"`cmd2'"'
			}
			
			ereturn local cluster `cluster'
			ereturn local cmdline  `"`cmd' `cmdline'"'
			
			local 0 , `options'
			
			syntax [, Level(string asis) * ]
			
			if !`:length local level' {
				local level `"`s(level)'"'
			}

			_get_diopts diopts options, `options'
			
			Display, level(`level') `cm' `diopts'
			exit
		}
		
		qui syntax [anything] [fw iw pw] [if] [in] [, GRoup(varname) * ]

		local 0 `"`anything' [`weight'`exp'] `if' `in'"'
		local 0 `"`0', group(`group0') `options'"'
	}

	`vv' ///
	`by' Estimate `0'
	
	ereturn local cmdline `"rologit `0'"'
end

program RemoveTempcaseid, eclass
	syntax [anything] [fw pw iw] [if] [in], tempcaseid(passthru) [ * ]
	
	local cmd1 `0'
					
	local cmd2 : subinstr local cmd1 "`tempcaseid'" ""
					
	local cmd2 `cmd2'  // trim
				
	local len = udstrlen(`"`cmd2'"')
	
	// If comma is last, remove it.
					
	if (udsubstr(`"`cmd2'"', `len', 1) == ",") {
		local cmd2 = udsubstr(`"`cmd2'"', 1, `len' - 1)
	}
	
	local cmd2 : list retokenize cmd2

	ereturn local command `"`cmd2'"'	
end

program RemoveClusterCheck, eclass
	syntax [anything] [fw pw iw] [if] [in] [, clustercheck(passthru) * ]
	
	if ("`clustercheck'" != "") {
		local cmd1 `0'
		local cmd2 : subinstr local cmd1 "`clustercheck'" ""
		local cmd2 : list retokenize cmd2

		ereturn local command `"`cmd2'"'
	}	
end

program Estimate, eclass sortpreserve byable(recall)
	local vv : di "version " string(_caller()) ", missing:"

	syntax varlist(min=2 numeric fv) [if] [in] [fw pw iw] ,       ///
	   GRoup(varname) [ TIES(str) noTEstrhs REVerse               ///
	   INComplete(int 0) Robust CLuster(passthru) NOLOg LOg TRace ///
	   OFFset(varname) Level(passthru) VCE(passthru)              ///
	   CM CLUSTERCHECK(varname) * ]

    	if "`cm'" != "" {
    		local groupname "case"
    	}
    	else {
    		local groupname "`group'"
    	}
		    	
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
        if `fvops' {
                local vv: di "version " string(max(11,_caller())) ", missing:"
        }

	_get_diopts diopts options, `options'
	
	_vce_parse, argopt(CLuster) opt(OIM Robust) old	///
		: [`weight'`exp'], `vce' `robust' `cluster'
	
	local robust  `r(robust)'
	local cluster `r(cluster)'
	local coxopt  `options'

	/*
		if _by() {
			_byoptnotallowed score() `"`score'"'
		}
	*/

	if "`ties'" != "" {
		TiesOption `ties'
		local ties `r(ties)'
	}
	
	if "`weight'" != "" {
		local wght   `"[`weight'`exp']"'
		if "`weight'" == "pweight" {
			local robust robust
			if "`ties'"=="exactm" {
				di as err "ties(exactm) may not be " /*
				*/ "specified with pweights"
				exit 184
			}
		}
		
		if "`ties'"=="efron" {
			di as err "ties(efron) may not be specified with " /*
			*/ "weights"
			exit 184
		}
	}

	quietly {
		tempvar fail markg g y
		tempname ng gavg gmin gmax

		marksample touse
		markout `touse' `group' , strok

		// offset()

		if "`offset'" != "" {
			markout `touse' `offset'
			local offopt offset(`offset')
		}

		// cluster()

		local prefix `c(prefix)' 
		local isloop : list posof "_loop" in prefix

		if "`cluster'" != "" | ("`clustercheck'" != "" & !`isloop') {
	
			// Check that cases (groups) are nested within clusters.
		
			if "`cluster'" != "" {
				local cvar `cluster'
			}
			else {
				local cvar `clustercheck'
			}

			cap assertnested `cvar' `group' if `touse'
			if _rc == 459 {
				
				if "`cm'" != "" {
					
di as err "{p}cases must be nested within clusters{p_end}"
				
				}
				else {
					
di as err "{p}{bf:cluster()} must be constant within {bf:`group'}{p_end}"
				
				}
			
				exit 459
			}
			else if _rc {
				error _rc
			}
		}
		
		if "`cluster'" != "" {
			
			if "`ties'" == "exactm" {
				di as err "{p}{bf:vce(cluster `cluster')} " /*
				*/ "not allowed with {bf:exactm} method for " /*
				*/ "handling ties{p_end}"
				exit 184
			}
			
			local robust robust
			local clopt "cluster(`cluster')"
		}
		else if "`robust'" != "" {
			// beware: cluster() is necessary for robust!
			
			local clopt "cluster(`group')"
			
			if "`ties'" == "exactm" {
				di as err "{bf:vce(robust)} not allowed " /*
				*/ "with {bf:exactm} method for handling ties"
				exit 184
			}
		}

		// group structure (#groups, avg size etc)

		count if `touse'
		if r(N) == 0 {
			noi error 2000
		}
		
		bys `touse' `group' : gen `c(obs_t)' `g' = _N if _n==1
		summ `g' if `touse' , meanonly
		scalar `ng'   = r(N)
		scalar `gmin' = r(min)
		scalar `gavg' = r(mean)
		scalar `gmax' = r(max)
		drop `g'

	/*
		key variables for -cox-

		cox        rologit
		-------------------
		timevar == ranking   1: shortest time <==> most preferred,
		                     2: 2nd shortest time <==> preferred second
		                     etc

		failure == whether preference was expressed;
		           if no pref is expressed ("waiting time incomplete")
		           it is interpreted as being less attractive than all
		           alternatives mentioned. The associated waiting time
			   is set to #alternatives + 1.

		strata  == rologit-group()
	*/

		gettoken lhs rhs : varlist
		_fv_check_depvar `lhs'
		gen byte `fail' = `lhs' != `incomplete' if `touse'
		
		count if !`fail'
		if r(N) > 0 {
			di as txt "incomplete rankings encountered"
		}
		
		summ `lhs' if `touse' & `fail', meanonly
		
		if "`reverse'" == "" {
			// higher value of lhs == "more attractive"
			//   == "shorter waiting time"
			gen `y'=cond(`fail',r(max)-`lhs'+1,r(max)+2) if `touse'
		}
		else {
			// low value of lhs == "more attractive"
			//   == "shorter waiting time"
			gen `y'=cond(`fail',`lhs'-r(min)+1,r(max)+2) if `touse'
		}

		// tie handling via any of Cox method's

		capt bys `touse' `group' `fail' `y' : /*
			*/ assert _N==1 if `touse' & `fail'

		if _rc {
			if (_rc==1) {
				exit 1
			}
			
			local hasties yes
			
			if "`ties'" == "none" {
				noi di as err "ties exist in your data and " /*
				*/ "you specified ties(none)"
				exit 459
			}
			else if "`ties'" == "" {
				// default ties() option depends on options
				
				if "`weight'" == "pweight" {
					local ties breslow
				}
				else if "`robust'" != "" {
					if "`weight'" != "" {
						di as err "ties(efron) may " ///
						 "not be specified with "    ///
						 "weights"
						exit 184
					}
					
					local ties efron
				}
				else {
					local ties exactm
				}
			}
			
			local coxties `ties'
		}

		// warning message if data are not 1,2,.. coded
		// only checked if there are no ties

		if "`hasties'" == "" {
			capt by `touse' `group' `fail' (`y') : /*
				*/ assert `y' == _n if `touse' & `fail'
			if _rc {
				noi di as txt "(preferences are not coded " /*
				*/ "as sequential integers)"
			}
		}

		// test that rhs variables vary between alternatives

		if "`testrhs'" == "" {
		    if `fvops' {
		    	sort `touse' `group'
			
			fvexpand `rhs' if `touse'
			local rhs `"`r(varlist)'"'
			
			fvrevar `rhs' if `touse'
			local rerhs `"`r(varlist)'"'
			local k : list sizeof rerhs
			
			forval i = 1/`k' {
			    gettoken v  rhs   : rhs
			    gettoken rv rerhs : rerhs
			    
			    _ms_parse_parts `v' 
			    
			    if !r(omit) {
				cap by `touse' `group' : /*
					*/ assert `rv'==`rv'[1] if `touse'
				if (_rc==1) {
					exit 1
				}
				if !_rc {
					local cnsvar `cnsvar' `v'
					gettoken V v : v, parse("#")
					local ov o.`V'
					while `:length local v' {
						gettoken S v : v, parse("#")
						gettoken V v : v, parse("#")
						local ov `ov'#o.`V'
					}
					local v : copy local ov
				}
			    }
			    local RHS `RHS' `v'
			}
			local rhs : copy local RHS
		    }
		    else {
			foreach v of local rhs {
				capt bys `touse' `group' (`v') : /*
				 */ assert `v'==`v'[1] if `touse'
				if (_rc==1) {
					exit 1
				}
				if !_rc {
					local cnsvar `cnsvar' `v'
				}
				else	local newrhs `newrhs' `v'
			}
			
			if "`cnsvar'" != "" {
				local rhs `newrhs'
			}
		    }
		    
		    if "`cnsvar'" != "" {
		    	
			noi di as txt "{p 0 6 2}note: `cnsvar' omitted " ///
				"because of no within-`groupname' "      ///
				"variance{p_end}"
		    }
		}

	} /* quietly */

	// estimate the exploded logit model via cox,
	// displaying the log/trace, but no header or table

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	
	`vv' ///
	cox `y' `rhs' if `touse' `wght' , dead(`fail') strata(`group') ///
	    `robust' `clopt' `coxties' `log' `trace' `offopt'    ///
	    `coxopt' nocoef noheader

	local chi2type "`e(chi2type)'"
	
	// e() are inherited from -cox-
	
	_repost "rologit" "`lhs'"              // no longer a Cox estimator
	
	ereturn repost, buildfvinfo ADDCONS

	_post_vce_rank
	
	if "`chi2type'"=="Wald" {
                _prefix_model_test rologit
        }
        else {
                local df_m = cond("`e(rank)'"!="","`e(rank)'","0")
                ereturn scalar df_m = `df_m'
        }
       
        ereturn local chi2type `chi2type'

	ereturn local  method
	ereturn local  strata
	ereturn local  old_cmd

	if ("`cluster'" != "") {
		ereturn local vce cluster
	}
	else if ("`robust'" != "") {
		ereturn local vce robust
	}
	
	ereturn scalar code_inc = `incomplete' // code for incomplete prefs

	ereturn hidden local marginsprop addcons

	ereturn local marginsok	     XB
	ereturn local marginsnotok   Pr stdp default
	ereturn local marginsdefault predict(xb)
	ereturn local reverse        `reverse'      // reverse ordering
	ereturn local depvar         `lhs'
	ereturn local ties           `ties'
	
	ereturn scalar N_ic = `ng'

	if ("`cm'" != "") {
		ereturn hidden scalar N_g   = `ng'   // N of groups
		ereturn hidden scalar g_min = `gmin' // min  #obs within subject
		ereturn hidden scalar g_avg = `gavg' // mean #obs within subject
		ereturn hidden scalar g_max = `gmax' // max  #obs within subject

		ereturn scalar N_case  = `ng'
		ereturn scalar alt_min = `gmin'
		ereturn scalar alt_avg = `gavg'
		ereturn scalar alt_max = `gmax'

		ereturn hidden local group `group'

		ereturn local key_N_ic cases
		ereturn local caseid   `group'
		ereturn local predict  cmrologit_p
		ereturn local title    "Rank-ordered logit choice model"
		ereturn local cmd      cmrologit
	}
	else {
		ereturn scalar N_g   = `ng'          // N of groups
		ereturn scalar g_min = `gmin'        // min  #obs within subject
		ereturn scalar g_avg = `gavg'        // mean #obs within subject
		ereturn scalar g_max = `gmax'        // max  #obs within subject

		ereturn local key_N_ic groups
		ereturn local group    `group'
		ereturn local predict  rologit_p
		ereturn local title    "Rank-ordered logistic regression"
		ereturn local cmd      rologit
	}

	Display, `level' `diopts' `cm'
end

program Display
	syntax [, Level(cilevel) CM *]
	
	if "`cm'" != "" {
		local grouptype "case"
		local vartype   "Case ID"
	}
	else {
		local grouptype "group"
		local vartype   "Group"
	}

	_get_diopts diopts, `options'
	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
		*/ bsubstr(`"`e(crittype)'"',2,.)

	di _n      as txt "`e(title)'" ///
	  _col(49) as txt "Number of obs" _col(67) "= " as res %10.0fc e(N)
	di         as txt "`vartype' variable: " as res abbrev("`e(group)'",12) ///
	  _col(49) as txt "Number of `grouptype's" _col(67) "= " as res %10.0f e(N_g) _n

	if "`e(ties)'" != "none" & "`e(ties)'" != "" {
		if ("`e(ties)'"=="breslow") local ties Breslow
		else if ("`e(ties)'"=="efron") local ties Efron
		else local ties `e(ties)'

		di as txt "Ties handled via the `ties' method" _c
	}
	else 	di as txt "No ties in data" _c

	di _col(49) as txt "Obs per `grouptype':"
	di _col(49) as txt "              min = " as res %10.0fc e(g_min)
	di _col(49) as txt "              avg = " as res %10.2fc e(g_avg)
	di _col(49) as txt "              max = " as res %10.0fc e(g_max) _n

	if "`e(df_r)'" == "" {
		if !missing(e(chi2)) {
			di _col(49) as txt "`e(chi2type)' chi2(" ///
				as res "`e(df_m)'" as txt ")" ///
			_col(67) "= " as res %10.2f e(chi2) _n ///
				as txt "`crtype' = " as res %9.0g e(ll) ///
			_col(49) as txt "Prob > chi2       = " ///
				as res %10.4f chi2tail(e(df_m),e(chi2)) _n
		}
		else {
			di _col(49) "{help j_robustsingular##|_new:" ///
				"`e(chi2type)' chi2(`e(df_m)')}" ///
			_col(67) "= " as res %10.2f . _n ///
				as txt "`crtype' = " as res %9.0g e(ll) ///
			_col(49) as txt "Prob > chi2       = " ///
				as res %10.4f . _n
		}
	}
	else {
		if !missing(e(F)) {
			di _col(49) as txt "F(" as res %4.0f e(df_m) ///
				as txt "," as res %9.0f e(df_r) as txt ")" ///
			_col(67) "= " as res %10.2f e(F) _n ///
				as txt "`crtype' = " as res %9.0g e(ll) ///
			_col(49) as txt "Prob > F          = " ///
				as res %10.4f Ftail(e(df_m),e(df_r),e(F)) _n
		}
		else {
			local dfm_l : di %4.0f e(df_m)
			local dfm_l2: di %7.0f `df'
			di _col(49) "{help j_robustsingular##|_new:F(" ///
				"`dfm_l',`dfm_l2')}" ///
			_col(67) "= " as res %10.2f . _n ///
				as txt "`crtype' = " as res %9.0g e(ll) ///
			_col(49) as txt "Prob > F          = " ///
				as res %10.4f . _n
		}
	}

	_coef_table, level(`level') `diopts'
end


program TiesOption, rclass
	local narg : word count `0'
	if `narg' != 1 {
		di as err "invalid ties(): exactly one value expected"
		exit 198
	}
	local 0 `", `0'"'
	syntax , [EXactm exactp EFRon BREslow NONE]

	if "`exactp'" != "" {
		di as err "tie-handling method exactp is not allowed"
		exit 198
	}

	return local ties `exactm' `efron' `breslow' `none'
end
exit

HISTORY

1.2.1  change in display formatting

1.2.0  Support for all tie-handling methods in Cox
       rologit is no longer set up as a wrapper around cox--though it
         still uses cox
       predict command

