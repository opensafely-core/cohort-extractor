*! version 1.4.1  13jan2020
program _xtmixed_estimate, sortpreserve eclass byable(recall)
	local is_replay = replay()
	if _caller() >= 11 {
		local vv : di "version " string(min(14.9,_caller())) ":"
		local VV : di "version " string(_caller()) ":"
	}
	else {
		local vv "version 10:"
	}

	version 9
	local globopts `"Level(cilevel) PPARSEPOST"'
	local globopts `"`globopts' REML MLe EMITERate(integer 20)"'
	local globopts `"`globopts' EMTOLerance(real 1e-10) EMLOG EMDOTs"'
	local globopts `"`globopts' noGRoup noHEADer ESTMetric"'
	local globopts `"`globopts' noSTDerr noLRtest NOLOg LOg"'
	local globopts `"`globopts' EMONLY NOEMSHOW"'
	local globopts `"`globopts' noFETable noRETable matsqrt matlog"'
	local globopts `"`globopts' posttheta RESiduals(string)"'
	local globopts `"`globopts' standardize(varname)"'
	local globopts `"`globopts' vce(passthru) Robust CLuster(passthru)"'
	local globopts `"`globopts' pwscale(string)"'
	local globopts `"`globopts' VARiance STDDEViations"'
	local globopts `"`globopts' DFMethod(string) DFTABle DFTABle1(string)"'
	local globopts `"`globopts' SMALL"'

	// undocumented, for use by predict and estat

	local globopts `"`globopts' grouponly"'
	local globopts `"`globopts' getblups(string) REISE getblups_se(string)"'
	local globopts `"`globopts' getscores(string)"'

	// mlopts

	local mlopts `"NONRTOLerance NRTOLerance(string) SHOWTOLerance"'
	local mlopts `"`mlopts' TRace GRADient HESSian showstep"'
	local mlopts `"`mlopts' TECHnique(string) SHOWNRtolerance"'
	local mlopts `"`mlopts' ITERate(string) TOLerance(string)"'
	local mlopts `"`mlopts' LTOLerance(string) GTOLerance(string)"'
	local mlopts `"`mlopts' DIFficult dots"'

	// diopts
	local diopts	Level(string)		///
			vsquish			///
			ALLBASElevels		///
			NOBASElevels		/// [sic]
			BASElevels		///
			noCNSReport		///
			FULLCNSReport		///
			noOMITted		///
			noEMPTYcells		///
			NOFVLABEL		///
			NOCI			///
			NOPValues		///
			fvwrap(passthru)	///
			fvwrapon(passthru)	///
			cformat(passthru)	///
			pformat(passthru)	///
			sformat(passthru)	///
			NOLSTRETCH		///
			COEFLegend		///
			SELEGEND

	local sort : sortedby
	local globallow `"`globopts' `mlopts' `diopts'"'

	// parse

	_parse expand cmd glob : 0 , common(`globallow') gweight

	// Parse global if/in and global weight

	forvalues k = 1/`cmd_n' {		
                local cmds `"`cmds' `"`cmd_`k''"'"'
        }

        _mixed_parseifin xtmixed `=`cmd_n'+1' `cmds'  /// 
	                 `"`glob_if' `glob_in' `glob_wt'"'

	// If linear regression and residual structure, insert an _all
	// empty level

	local 0 `", `glob_op'"'
	syntax [ , RESiduals(string) *]
	if (`cmd_n' == 1) & `"`residuals'"' != "" {
		local cmd_n 2
		local cmd_2 _all:, noconstant
	}

	forvalues k=0/`=`cmd_n'-1' {			// Parse subcmds
		qui _mixed_parsecmd xtmixed `k' `cmd_`=`k'+1''
		`s(msg)'
		if `k' > 0 {
			if "`varnames_`k''" != "" {
				NoOmit `varnames_`k''
				local varnames_`k' "`r(vars_noomit)'"
			}
		}
		local allnms `allnms' `levnm_`k'' `varnames_`k''
	}
	if "`depname'" == "" {
		di as err "dependent variable not specified"
		exit 198
	}

	local allnms `allnms' `depname'

	local 0 `"`glob_if' `glob_in'"'			// set estimation sample
	syntax [if] [in]
	marksample touse
	local allnms : subinstr local allnms "_all" "" , word all
	markout `touse' `allnms' , strok

	tempvar one					// processing macs
	qui gen byte `one' = 1 if `touse'
	local lev_beg 0
	local last_levnm "______"
	tempname lev_nvars sublevels
	if (`cmd_n' > 1)  matrix `sublevels' = J(1,`=`cmd_n'-1', 0)

	// Create list of all level names for dealing with weights later
	
	forvalues k=1/`=`cmd_n'-1' {
		if `=`:list sizeof levnm_`k''' > 1 {
			di as err "level {bf:`levnm_`k''} incorrectly specified"
			exit 198
		}
		local wtnames `wtnames' `levnm_`k''
	}

	forvalues k=0/`=`cmd_n'-1' {			// reconcile levels
		local k1 = `k' - 1			// and sublevels

		if "`levnm_`k''" != "`last_levnm'" {

			if `k' > 0 {			// level var repeated
				if 0`:list levnm_`k' in levnms' {	
					if `"`levnm_`k''"' != `""' {
						RepeatedLevelError `levnm_`k''
						exit 198
					}
				}
				local levnms `levnms' `levnm_`k''

				_mixed_fixupconstant `lev_beg' `k1' /// 
						     `last_const'
				_mixed_setsublevels  `lev_beg' `k1' `sublevels'
				`VV' ///
				_mixed_rmcollevel `lev_beg' `k1' `depname'  ///
					   "`lev_constant'" "`lev_isfctrs'" ///
					   "`collin_`k1''" `touse'	    ///
					   `lev_varnames'

			}

			local lev_varnames `""`varnames_`k''""'
			if "`constant_`k''" != "" {
				local lev_constant 0
			}
			else {
				local lev_constant 1
			}
			local last_const   = cond("`constant_`k''"=="", `k', -1)
			local lev_isfctrs  `isfctr_`k''
			local lev_beg      `k'
		}
		else {
			local lev_varnames `"`lev_varnames' "`varnames_`k''""'
			local lev_isfctrs `lev_isfctrs' `isfctr_`k''

			if "`constant_`k''" != "" {
				local lev_constant `lev_constant' 0
			}
			else {
				local lev_constant `lev_constant' 1
			}
			if "`constant_`k''" == "" {
				local last_const = `k'
			}
		}

		local last_levnm `levnm_`k''
		local kh `k'
	}

	_mixed_fixupconstant `lev_beg' `kh' `last_const'
	_mixed_setsublevels  `lev_beg' `kh' `sublevels'
	`VV' ///
	_mixed_rmcollevel `lev_beg' `kh' `depname' "`lev_constant'"	///
		   "`lev_isfctrs'" "`collin_`kh''" `touse' `lev_varnames'

	tempname fctrlevs hasfv noomit noomitcols

	set fvbase off
	forvalues k=0/`=`cmd_n'-1' {
		if `isfctr_`k'' {			// create factors
			tempvar ifctr
			qui egen long `ifctr' = group(`varnames_`k'') if `touse'
			label variable `ifctr'				///
			      `"R.`:subinstr local varlist_`k' " " " R."'"'
			local varlist_`k' `ifctr'

			sum `ifctr' , meanonly
			matrix `fctrlevs' = (nullmat(`fctrlevs'), r(max))
		}
		else {				// handle ts ops
			if `k' == 0 {
				local varlist_00 `varnames_0'
			}
			fvrevar `varnames_`k'' if `touse'
			local varlist_`k' `r(varlist)'
		}

		if "`constant_`k''" == "" {		// handle constants
			local varlist_`k' `varlist_`k'' `one'
			if `k' == 0 {
				local varlist_00 `varlist_00' `one'
			}
			local varnames_`k' `varnames_`k'' _cons
		}
		if `k' == 0 {
			if "`varlist_0'" != "" {
				NoOmit `varlist_00'
				local omitted `r(omitted)'
				matrix `noomitcols' = r(noomitcols)
				scalar `hasfv' = `r(hasfv)'
				matrix `noomit' = r(noomit)
			}
			else {
				scalar `hasfv' = 0
				local omitted 0
			}
		}
		if `k' > 0 & !`isfctr_`k'' {
			foreach var of local varlist_`k' {
				matrix `fctrlevs' = (nullmat(`fctrlevs'), 1)
			}
							// Fixup covariance
			if (`:list sizeof varlist_`k'' + 		///
			    ("`constant_`k''"=="")) <= 1 {
				local cov_`k' = "identity"
			}
		}

	}
	tsrevar `depname' if `touse'			// handle ts depvar
	local depvar `r(varlist)'

	foreach nm of local levnms {			// encode levels
		tempvar level 
		if ("`nm'" == "_all")  local nm `one'
		local nms `nms' `nm'
		qui egen long `level' = group(`nms') if `touse'
		local levelvars `levelvars' `level'
	}

	// global options are in glob_op  -- your parsing goes here
	local 0 `", `glob_op'"'
	syntax [ , `globopts' *]

	_get_diopts diopts options, `options'
	mlopts mlopts, `options' `log' `nolog'
	
	local coll `s(collinear)'
	local 0 `", `mlopts'"'
	syntax [, technique(string) COLlinear *]
	if `:list posof "bhhh" in technique' {
		di as err "option technique(bhhh) not allowed"
		exit 198
	}
	local mlopts `"technique(`technique') `options'"'

// error checking options goes here

	if "`mle'`reml'" == "" & $XTM_ver >= 12 { // default changed under
						  // version control
		local mle mle
	}
	if "`mle'" != "" {
		local ml ml
	}
	if "`ml'" != "" {
		if "`reml'" != "" {
			di as err "ml and reml may not be specified at " _c
			di as err "the same time"
			exit 198
		}
		local reml 0
		local method ML
	}
	else {
		local reml 1
		local method REML
	}
	if "`emonly'" != "" & "`emdots'" == "" & "`noemshow'" == "" {   
		local emlog emlog
	}
	if "`emlog'" != "" & "`emdots'" != "" {
		di as err "emlog and emdots may not be specified together"
		exit 198
	}
	if "`variance'"!="" & "`stddeviations'"!="" {
	    di as err "variance and stddeviations may not be specified together"
	    exit 198
	}
	local var_opt `variance' `stddeviations'
	if "`var_opt'" != "" & "`estmetric'" != "" {
		di as err "`var_opt' and estmetric may not be specified together"
		exit 198
	}

	if "`pparsepost'" != "" {
		ereturn clear
		foreach mac in depvar depname cmd_n {
			ereturn local `mac' ``mac''
		}
		forvalues l = 0/`=`cmd_n'-1' {
			foreach mac in levnm isfctr cov	k sublevels	///
				       constant varlist varnames {
				ereturn local `mac'_`l' ``mac'_`l''
			}
		}
		exit
	}

							// set up _xtm_model

	// Process weights
	// First, make sure only one specification per level, and place it first
	local m : word count `wtnames'
	forvalues k = 1/`m' {
		local pws `"`pws' `"`pweight_`k''"'"'
		local fws `"`fws' `"`fweight_`k''"'"'
	}
	FixUpWeights `"`wtnames'"' `"`pws'"' `"`fws'"'
	
	local wtype1
	local pwlev 0
	local fwt 0
	local pwt 0
	local weighted = (`"`glob_wt'"' != "")
	local obsweighted = `weighted'		
	forvalues k=0/`=`cmd_n'-1' {
		if `"`pweight_`k''"' != "" {
			local weighted 1
		}
		if `"`fweight_`k''"' != "" {
			local weighted 1
		}
	}
	if `weighted' {
		local method ML
		if `reml' {
			di as err "{p 0 4 2}REML not supported with "
			di as err "weights{p_end}"
			exit 101
		}
		tempvar wt0
		local 0 `glob_wt'
		syntax [pw fw]
		if `"`weight'"' != "" {
			cap gen double `wt0' `exp' if `touse'
			if _rc {
				di as err "{p 0 4 2}weight expression "
				di as err "invalid{p_end}"
				exit 111
			}
			local wtype1 `weight'
			local wtype `weight'
			local wexp `"`exp'"'
			if "`wtype'" == "pweight" {
				local pwt 1
			}
			else {
				local fwt 1
			}
		}
		else {
			gen double `wt0' = 1 if `touse'	
		}
		markout `touse' `wt0'
		local m : word count `levelvars'
		forvalues k = 1/`m' {
			if `"`pweight_`k''"' != "" {
				local pwt 1
				local weight_`k' `"`pweight_`k''"'
				local pwlev 1
			}
			if `"`fweight_`k''"' != "" {
				local fwt 1
				local m = `=`m'+1'
				local weight_`k' `"`fweight_`k''"'
			}
			if `fwt' & `pwt' {
				di as err "{p 0 4 2}cannot mix pweights with "
				di as err "fweights{p_end}"
				exit 198
			}
			tempvar wt`k'
			local weightvars `weightvars' `wt`k''
			if `"`weight_`k''"' != "" {
				cap gen double `wt`k''=`weight_`k'' if `touse'
				if _rc {
					di as err "{p 0 4 2}weight expression "
					di as err "invalid{p_end}"
					exit 111
				}
			}
			else {
				qui gen double `wt`k'' = 1 if `touse'
			}
			markout `touse' `wt`k''
			local lev : word `k' of `levelvars'
			cap CheckConstantWithin `lev' `wt`k'' `touse' 
			if _rc {
				local lev : word `k' of `levnms'
				di as err "{p 0 4 2}weights not constant "
				di as err "within groups defined "
				di as err "by `lev'{p_end}"
				exit 459
			}
		}
		local weightvars `weightvars' `wt0'
		if "`wtype1'" == "" {
			if `fwt' {
				local wtype1 fweight
			}
			else {
				local wtype1 pweight
			}
		}
		if "`wtype1'" == "pweight" {
			local lrtest nolrtest
			local robust robust
		}
		// if you have fweights you need an overall product
		// weight for the likelihood comparison test
		if "`wtype1'" == "fweight" & "`lrtest'" == "" {
			local m : word count `levelvars'
			tempvar fwprod
			qui gen long `fwprod' = `wt0' if `touse'
			forvalues k = 1/`m' {
				qui replace `fwprod' = `fwprod' * `wt`k'' ///
					if `touse'
			}
			local glob_wt [fw=`fwprod']
		}
	}

	// process pwscale() option
	
	if `"`pwscale'"' != "" {
		if "`wtype1'" != "pweight" {
			di as err "{p 0 4 2}pwscale() allowed only with "
			di as err "pweights{p_end}"
			exit 198
		}
		local k : word count `levelvars'
		if `k' != 1 {
			di as err "{p 0 4 2}pwscale() allowed only with "
			di as err "two-level models{p_end}"
			exit 198
		}
		local lev : word 1 of `levelvars'
		RescaleWeights `"`pwscale'"' `wt0' `wt1' `lev' `touse'
	}

	// vce()
	
	local vceopt = `:length local vce'		| 	///
		       `:length local cluster'          |       ///
		       `:length local robust'

	if `vceopt' {
		local robust robust
		local lrtest nolrtest
		_vce_parse, argopt(CLuster) opt(OIM Robust) old ///
		:, `vce' `cluster' `robust'
		local robust `r(robust)'
		local vcetype `r(vce)'

		if "`r(cluster)'" != "" {
			local clustvar `r(cluster)'
			local clustopt cluster(`clustvar')
			local lev : word 1 of `levelvars'
			if "`lev'" != "" {
cap CheckConstantWithin `lev' `clustvar' `touse'  
if _rc {
	di as err "{p 0 4 2}highest-level groups "
	di as err "are not nested within `clustvar'"
	di as err "{p_end}"
	exit 459
}
			}
			markout `touse' `clustvar', strok
			local userclust userclust
		}
		else {
			local clustvar : word 1 of `levnms'
			local clustopt cluster(`clustvar')
		}
	}

	if `"`levnms'"' != "" {
		local w1 : word 1 of `levnms'
		if `"`w1'"' == "_all" & "`robust'" != "" {
			di as err "{p 0 4 2}robust variances and pweights not "
			di as err "supported when highest-level group "
			di as err "encompasses all the data{p_end}"
			exit 498
		}
	}

	if "`robust'" != "" & `reml' {
		di as err "{p 0 4 2}REML not supported with "
		di as err "robust variance estimation{p_end}"
		exit 198
	}

	// Get residual variance structure

	if `"`levelvars'"' != "" {
		local k : word count `levelvars'
		local lastlev : word `k' of `levelvars'
	}

	tempvar nn rgroup
	GetVarStruct `"`residuals'"' "`touse'" "`rgroup'" "`lastlev'"
	local rstructure `s(structure)'
	local tvar	 `s(tvar)'
	local origgroup	 `s(ogroup)'
	local rgroup	 `s(rgroup)'
	local nrgroups	 `s(nrgroups)'
	local rglabels  `"`s(rglabels)'"'
	local rstructlab `"`s(rstructlab)'"'
	local rgvalues	 `s(rgvalues)'
	local order `s(order)'
	tempname ar_p ma_q max_t
	scalar `ar_p' = `s(ar_p)'
	scalar `ma_q' = `s(ma_q)'

	// observation weights allowed only with independent structures; 
	// you cannot write out the observation likelihood L_ij otherwise
	// so how are you supposed to weight it? 

	if `obsweighted' & (`"`rstructure'"' != "independent") {
		cap assert `wt0' == 1 if `touse'
		if _rc {
			di as err "{p 0 4 2}observation-level weights "
			di as err "not allowed with correlated residual "
			di as err "structures{p_end}"
			exit 101
		}
	}

	// Handle time variable for certain residual structures

	tempvar time gap 
	tempname umap
	ProcessTimeVar "`tvar'" `time' `gap' `rstructure' ///
	               `touse' "`lastlev'" `umap' `order'

	if "`maxt'" != "" {
		scalar `max_t' = `maxt'
		// Need to remap default order to max order for banded
		if "`rstructure'" == "banded" & `order' == -1 {
			local order = `maxt'-1
			local rstructlab Banded(`order')
		}
		if "`rstructure'" == "toeplitz" & `order' == -1 {
			local order = `maxt'-1
			local rstructlab Toeplitz(`order')
		}
		if `maxt' < 2 {
			di as err "{p 0 4 2}This residual structure "
			di as err "requires at least two unique time "
			di as err "points{p_end}"
			exit 459
		}
	}

	global XTM_res = ("`rstructure'" != "independent") | "`rgroup'" != "" 

	local nlevs = `cmd_n' - 1
	local allempty 1
	forvalues k=1/`nlevs' {			// check for empty levels
		if "`varlist_`k''" != "" {
			local allempty 0
		}
	}
	if `allempty' & `nlevs' & !$XTM_res {
		di as txt "{p 0 4 2}Note: all random-effects equations are "
		di as txt "empty; model is linear regression{p_end}"
		local cmd_n 1
		local levelvars
	}

	if $XTM_res & "`stderr'" != "" {
		di as err "{p 0 4 2}nostderr allowed only with the default "
		di as err "identity residual-variance structure{p_end}"
		exit 198
	}

	if ($XTM_res | `weighted') & "`emonly'" != "" {
		di as err "{p 0 4 2}emonly allowed only with unweighted "
		di as err "estimation using the default "
		di as err "identity residual-variance structure{p_end}"
		exit 198
	}
	if ("`small'"!="") {
		if (!`is_replay' | "`e(dfmethod)'"=="") {
			di as err "{p}option {bf:small} is allowed only upon"
			di as err "replay and requires that option"
			di as err "{bf:dfmethod()} is specified with"
			di as err "{bf:mixed} during estimation{p_end}"
			exit 198
		}
	}
	if `"`dftable'"'!= "" & `"`dftable1'"'!="" {
		di as err "{p 0 4 2}option {bf:dftable} may not be " ///
			"combined with option {bf:dftable()}{p_end}"
		exit 198
	}
	if (`"`dftable'`dftable1'"'=="" & "`small'"!="") local dftable dftable
	if `"`dftable'"' != "" local dftable "default"
	else local dftable `dftable1'

	if ("`dfmethod'"!="") {		
		if $ME_QR == 0 {
			di as err "{p 0 4 2}option {bf:dfmethod()} is " ///
				"available only with {bf:mixed}{p_end}"
			exit 198 
		}

		if "`varlist_0'" == "" {
			di as err "{p}option {bf:dfmethod()} is not allowed"
			di as err "for a model with no fixed effects{p_end}"
			exit 198
		}

		if "`stderr'" != "" {
			di as err "{p}computing degrees of freedom " ///
 				"requires standard-error computation{p_end}"
			exit 198
		}

		if `weighted' {
			di as err ///
			    "{p}option {bf:dfmethod()} is not allowed " ///
				"with weighted estimation{p_end}"
			exit 198
		}

		if `"`vce'"' != "" & `"`vcetype'"'!= "oim"{
			di as err ///
			"{p}option {bf:dfmethod()} is not allowed with " ///
				"option {bf:vce(`vcetype')}{p_end}"
			exit 198
		}

		CheckDfType,  method(`method') type(`dfmethod')
		local dftype = r(dftype)
		if "`dftype'"=="kroger" | "`dftype'"=="satterthwaite" {
			local useinfo = r(useinfo)
		}

		if `cmd_n'== 1 & "`dftype'"!="residual" {
			di as err ///
				"{p 0 4 2}model is linear regression;  " ///
                                "option {bf:dfmethod(residual)} should be " ///
                                "used{p_end}"
			exit 198
		}

		if `"`dftype'"'=="repeated" { 
			local k : word count `levelvars'
			if `k' > 1 {
				di as err ///
				    "{p}option {bf:dfmethod(repeated)} " ///
				    "is not available for models with more " ///
				    "than two levels{p_end}"
				exit 198
			}	
		}

		if "`dftable'"!= "" {
			if `"`dftable1'"'!="" local dfmesg "dftable()"
			else if ("`small'"!="") local dfmesg "small"
			else local dfmesg "dftable"

			if `"`fetable'"'!= "" {
				di as err "{p}option {bf:nofetable} may " ///
					"not be combined with option " ///
					"{bf:`dfmesg'}{p_end}"
				exit 198
			}
			CheckDftable, ///
			    dftable(`dftable') diopts(`diopts') dfmesg(`dfmesg')
			local dfdisp `r(dfdisp)'
		}
		else local dfdisp default 
	}
	else {
		if "`dftable1'"!="" {
			di as err ///
				"{p}option {bf:dftable()} requires " ///
				"option {bf:dfmethod()}{p_end}"
			exit 198
		}
		else if "`dftable'"!="" {
			di as err ///
				"{p}option {bf:dftable} requires " ///
				"option {bf:dfmethod()}{p_end}"
			exit 198
		}
	}

	// At this point, I need to recode levelvars to reflect markouts
	// due to weights and resids().

	local nms
	local k : word count `levelvars'
	forvalues i = 1/`k' {
		tempvar nlev`i'
		local lev : word `i' of `levelvars'
		local nms `nms' `lev'
		qui egen long `nlev`i'' = group(`nms') if `touse'
		local nlevelvars `nlevelvars' `nlev`i''
	}
	cap drop `levelvars'
	local levelvars `nlevelvars'

	// check if dataset is balanced
	if `"`levelvars'"'!="" {
		CheckBalance `levelvars'
		local balanced `r(balanced)'
	}	

	qui gen `c(obs_t)' `nn' = _n if `touse'
	gsort -`touse' `levelvars' `time' `nn'

	tempname obs re_n
	qui count if `touse'
	scalar `obs' = r(N)
	scalar `re_n' = `cmd_n' - 1

	// Set the parameterization method

	if "`matsqrt'`matlog'" == "" {
		if $XTM_ver < 11 {
			local matlog matlog
		}
	}
	if "`matlog'" != "" {
		if "`matsqrt'" != "" {
			di as err "{p 0 6 2}at most one of matlog and"
			di as err " matsqrt may be specified{p_end}"
			exit 198
		}
	}
	
	mata: _xtm_setup()

	// See if scores are desired

	if `"`getscores'"' != "" {
		PredictScores `"`getscores'"' `touse'
		exit
	}

	// obtain blups if specified and exit
	
	if `"`getblups'"' != "" {
		CheckBlups `getblups'
		SetBlupMats `touse'
		if `"`getblups_se'"' != "" {
			GetBlups `"`getblups'"'
		}
		else 	GetBlups `"`getblups'"' `reise'
		
		if `"`getblups_se'"' != "" {
			SetBlupMats `touse'
			GetBlups `"`getblups_se'"' reise
		}
		
		exit
	}
	if "`standardize'" != "" {
		mata: _xtm_standardize_res()
		exit
	}

	if `reml' {
		local crittype log restricted-likelihood
	}
	else {
		local crittype log likelihood
	}
	if ("`wtype1'" == "pweight") | ("`robust'" != "") {
		local crittype log pseudolikelihood
	}
	
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"	
	if "`log'" != "" {
		local q qui
	}

	tempname delta deltaf theta thetaf gamma s h err beta Vbeta V rho

// fit reference regression model
	
	if `cmd_n' == 1 | "`lrtest'" == "" {
		`vv' ///
		MyReg `depvar' `varlist_0' `glob_wt' if `touse', reml(`reml') 
		local ll_0 `r(ll0)'
		local gam `r(lnsig)'
		local conv = 1
	}

	if `cmd_n' == 1 { 	// model is linear regression 
		local ll_2 `ll_0'
		mat `beta' = e(b)    // from regress
		mat `Vbeta' = e(V)  
		local c = colsof(`Vbeta')
		if !`reml' & `c'{         // ml uses different sigma^2
			mat `Vbeta' = `Vbeta' * e(df_r)/e(N)
		}
		mat `gamma' = `gam'
		mat colnames `gamma' = lnsig_e:_cons
		mat `V' = 0
		if "`stderr'" == "" {
			mat `V' = 1/(2*e(N))
		}
		local lrtest nolrtest
		local emconv 1
		local iter = e(ic)
		mat `rho' = 0
		local omitted 0
	}
	else {
// starting values

		mata: _xtm_start("`delta'",0.375)   

// EM iterations
		if `emiterate' {
		   `q' IterateEM `delta', crit(`crittype') iter(`emiterate') ///
			tol(`emtolerance') `emlog' `emdots' ///
			weighted(`weighted')
		    local emconv = r(converged)
		    local iter = r(ic)
		}
		else {
			local emconv = 0
		}
		mat `deltaf' = `delta'

// Transform to NR parameterization

		mata: _xtm_delta_to_theta("`theta'","`delta'","`err'")
		if scalar(`err') {
			di as err "initial values/EM solution not feasible"
			exit 430 
		}
		mat `thetaf' = `theta'
		mata: _xtm_ml_eqlist("eqlist")

// Equation list and starting values for residual variance parameters

		tempname startval
		mata: _xtm_res_eqlist("reqlist")
		if !$XTM_res {
			mat `rho' = 0
			mat `startval' = `theta'
		}
		else {
			mata: _xtm_res_start("`rho'")
			mat `startval' = `theta', `rho'
		}
		global XTM_ctheta = colsof(`theta')

		local df_c : word count `eqlist' `reqlist'
		mat `h' = J(1,`df_c',1)

		if _caller() >= 11 {
			local dscale derivscale(`h')
		}
		else {
			local dscale dzeros(`h')
		}
	
		if "`emonly'" == "" {
			`q' di
			`q' di as txt "Performing gradient-based optimization: " 
			`vv' ///
			cap noi `q' ml model d0 mixed_ll `eqlist' ///
			        `reqlist', ///
				max init(`startval', copy) ///
				search(off) crittype(`crittype') `dscale' ///
				collinear missing nopreserve `mlopts' 

			/* pre 15.1 behavior
			if _rc | "`e(converged)'" == "0" {	
				if _rc == 1 {
					exit 1
				}
				local noconv noconv
				mat `delta' = `deltaf'
				mat `theta' = `thetaf'
			}
			*/
			if _rc {
				exit _rc
			}
			local conv = e(converged)
			local iter = e(ic)

			tempname bb
			mat `bb' = e(b)
			if $XTM_ctheta {
				mat `theta' = `bb'[1,1..$XTM_ctheta]
			}
			else {
				mata: _xtm_null_rowvector("`theta'")
			}
			if $XTM_res {
				mat `rho' = `bb'[1,`=$XTM_ctheta+1'...]
			}
			mata: _xtm_theta_to_delta("`delta'", ///
						  "`theta'","`err'")
			local opt `e(opt)'	
			local ml_method `e(ml_method)'
			local technique `e(technique)'
		}
		if $XTM_res {
			tempname rho2
			mata: _xtm_drho_to_rho("`rho'","`rho2'","`err'")
			mat `rho' = `rho2'
		}
		scalar `s' = -1 
		mata: _xtm_mixed_ll("`delta'","`rho'","`s'",0)
		local ll_1 = r(ll)
		scalar `s' = r(mse)
		local ll_2 = `ll_1'

// Reparameterize
		mata: _xtm_theta_to_gamma("`gamma'","`theta'","`s'")
		tempname initfinal
		mat `initfinal' = `gamma'
		if $XTM_res {
			mat `initfinal' = `gamma', `rho'
		}
		if "`emonly'" == "" & "`stderr'" == "" {
			if _caller() >= 11 {
				mat `h' = e(ml_scale), 1
			}
			else {
				mat `h' = e(ml_d0_s), 1
			}
			local c = colsof(`theta')
			forvalues i = 1/`c' {
			    mat `h'[1,`i'] = `h'[1,`i'] * ///
				abs(`gamma'[1,`i']/`theta'[1,`i'])
			}
			`q' di
			`q' di as txt "Computing standard errors:" 
			`vv' ///
			cap ml model d0 mixed_ll_reparm ///
			    `eqlist' /lnsig_e `reqlist', ///
			    max init(`initfinal',copy) search(off) iter(0) ///
			    `dscale' collinear missing nopreserve `mlopts'

			if _rc {
				if _rc == 1 {
					exit 1
				}
				local nostd nostd
				local ll_2 = `ll_1'
			}
			else {
				local ll_2 = e(ll)
				if reldif(`ll_1',`ll_2') > 1e-10 {
					local nostd nostd
				}
			}
			if "`nostd'" != "" {
				di as txt "standard-error calculation has " ///
				 "failed"
				if $XTM_res {
					ereturn clear
					error 430
				}
			}
		}

// Get final beta
        	mata: _xtm_mixed_ll("`delta'","`rho'","`s'",1) 
		mata: _xtm_beta("`beta'","`Vbeta'","`s'")
		if "`emonly'"=="" & "`nostd'" == "" & "`stderr'"=="" {
			mat `gamma' = e(b)
			mat `V' = e(V)	
		}
		else {
			local eqnames : subinstr local eqlist "/" "", all
			mat coleq `gamma' = `eqnames' lnsig_e
			mat colnames `gamma' = _cons
			local c = colsof(`gamma')
			mat `V' = J(`c',`c',0)
		}
	}

// Post Parameters

	if `"`varnames_0'"' == "" {
		`vv' ///
		PostParms `depname', re(`gamma') vre(`V') touse(`touse') ///
		     noomit(`noomit') omitted(`omitted')
	}
	else {
		`vv' ///
		PostParms `depname' `varnames_0', beta(`beta') ///
			vbeta(`Vbeta') re(`gamma') vre(`V') /// 
			touse(`touse') noomit(`noomit') omitted(`omitted')
	}

// Out of the variance estimates, count how many sigmas and rhos 

	mat `gamma' = e(b)
	local eqs : coleq `gamma'
	local k_rs 0
	forval i = `=e(k_f)+1'/`e(k)' {
		local eq : word `i' of `eqs'
		if bsubstr("`eq'",1,3) == "lns" | ///
					bsubstr("`eq'",1,5) == "r_lns" {
			local ++k_rs
		}
	}
	ereturn scalar k_rs = `k_rs'
	ereturn scalar k_rc = e(k_r) - e(k_rs)
	ereturn scalar k_res = cond($XTM_res, colsof(`rho'), 0)

	if "`emonly'" != "" {
		ereturn local emonly emonly
		ereturn scalar converged = `emconv'
		ereturn hidden scalar nostderr = 1
	}
	else {
		ereturn scalar converged = `conv'
		ereturn hidden scalar se_failed = ("`nostd'"!="")
		ereturn hidden scalar nostderr = ("`stderr'"!="")
	}
	capture ereturn scalar ic = `iter'
	ereturn local depvar `depname'
	ereturn scalar ll = `ll_2'

	if (e(k_f)!=0) {
		ereturn hidden matrix noomit = `noomit' 
    	}

// Comparison test
	
	if `cmd_n' > 1 & "`lrtest'" == "" {
		ereturn scalar ll_c = `ll_0'
		ereturn scalar df_c = `df_c'
		ereturn scalar chi2_c = 2*(e(ll) - e(ll_c))
		if e(chi2_c) < 0 {
			ereturn scalar chi2_c = 0
		}
		ereturn scalar p_c = chi2tail(e(df_c),e(chi2_c))
		if e(df_c) == 1 & e(chi2_c) > 1e-5 & !$XTM_res {
			ereturn scalar p_c = 0.5*e(p_c)
		}
	}

//  data resorted in what follows

	local wopt
	if "`wtype1'" == "fweight" {
		local wopt `"`weightvars'"'
	}
	SaveGroupInfo `"`levelvars'"' `"`wopt'"'

	if "`matlog'" == "" {
		ereturn local optmetric matsqrt
	}
	else {
		ereturn local optmetric matlog
	}

	if "`posttheta'" != "" {
		ereturn matrix theta = `theta'
	}

	ereturn hidden local crittype `crittype'
	ereturn local method `method'
	ereturn local opt `opt'
	ereturn local ml_method `ml_method'
	ereturn local technique `technique'
	ereturn local title Mixed-effects `e(method)' regression

	if $ME_QR {
		ereturn local cmd mixed
		ereturn hidden scalar mecmd = 0
	}
	else {
		ereturn local cmd xtmixed
		ereturn hidden scalar mecmd = 0
	}
	
	ereturn local wexp `"`wexp'"'
	ereturn local wtype `wtype'
	if "`wtype'" != "" {
		local margwtype "`wtype'"
		gettoken EQUAL margwexp : wexp
		local margwexp `"(`:list retok margwexp')"'
		local PROD "*"
	}
	if ("`wtype1'" == "pweight") | "`robust'" != "" {
		ereturn local title Mixed-effects regression
		forvalues k = 1/`=`cmd_n'-1' {
			ereturn local pweight`k' `"`pweight_`k''"'
			if "`pweight_`k''" != "" {
				local margwtype "pweight"
				local margwexp	///
				`"`margwexp'`PROD'(`pweight_`k'')"'
				local PROD "*"
			}
		}
 	}	
	if ("`wtype1'" == "fweight") {
		forvalues k = 1/`=`cmd_n'-1' {
			ereturn local fweight`k' `"`fweight_`k''"'
			if "`fweight_`k''" != "" {
				local margwtype "fweight"
				local margwexp	///
				`"`margwexp'`PROD'(`fweight_`k'')"'
				local PROD "*"
			}
		}
	}
	if ("`wtype1'" == "pweight") & !`pwlev' & (`cmd_n' > 1) {
		ereturn hidden local pw_warn pw_warn
	}
	ereturn local pwscale `pwscale'

	if _caller() >= 14 {
		if "`margwtype'" != "" {
			ereturn local marginswtype "`margwtype'"
			ereturn local marginswexp "= `margwexp'"
		}
	}
	ereturn hidden local marginsprop allcons

	forvalues k=1/`=`cmd_n'-1' {
		if `isfctr_`k'' {
			local varnames_`k'				///
			      `"R.`:subinstr local varnames_`k' " " " R."'"'
		}
		local zvars     `"`zvars' `varnames_`k''"'
		local vartypes  `"`vartypes' `=proper("`cov_`k''")'"'
		local lvnms     `"`lvnms' `levnm_`k''"'
		local dimz	`"`dimz' `:list sizeof varnames_`k''"'
	}
	ereturn local revars `zvars'
	ereturn local vartypes `vartypes'
	ereturn local ivars `lvnms'
	ereturn local redim `dimz'
	if $ME_QR {
		ereturn local predict mixed_p
		ereturn local estat_cmd mixed_estat
	}
	else {
		ereturn local predict xtmixed_p
		ereturn local estat_cmd xtmixed_estat
	}
	ereturn local resopt `"`residuals'"'
	ereturn local rstructure `rstructure'
	ereturn local rbyvar `origgroup'	
	ereturn local rglabels `"`rglabels'"'
	ereturn hidden local rgvalues `rgvalues'
	ereturn local rstructlab `"`rstructlab'"'
	ereturn scalar nrgroups = `nrgroups'
	if "`time'" != "" {
		ereturn local timevar `tvar'
	}
	if `ar_p' {
		ereturn scalar ar_p = `ar_p'
	}
	if `ma_q' {
		ereturn scalar ma_q = `ma_q'	
	}
	if `order' >= 0 {
		ereturn scalar res_order = `order'
	}
	if "`e(rstructure)'" == "unstructured" | 	/// 
	   "`e(rstructure)'" == "banded" {
		ereturn matrix tmap = `umap'
	}

	ereturn local chi2type Wald
	ereturn scalar rc = cond(`e(converged)',0,430)
	ereturn hidden local iccok "ok"

// Robust variance estimators

	if "`robust'" != "" {
		tempname nc
		scalar `nc' = 0
		if `weighted' & `cmd_n' > 1 & "`wtype1'" == "fweight" {
			// In linear regression, scores are self-weighted.
			// This way, svy will just pop through in the 
			// case of linear regression.  as far as svy is
			// concerned, scores are always self-weighted,
			// because weights can be applied only at the 
			// observation level
			local wopt wopt([`wtype1' = `wt1'])
			cap assert `wt1' == 1 if e(sample)
			if _rc {
				tempvar tosum cl
				if "`userclust'" == "" {
					local m : word 1 of `levelvars'
					qui bysort `m': gen byte `tosum' = ///
					    (_n == 1 & e(sample))
					qui sum `wt1' if `tosum',  meanonly
					scalar `nc' = r(sum)
				}
				else {
					qui egen long `cl' =  ///
					    group(`clustvar') if e(sample)
					qui sum `cl', meanonly
					scalar `nc' = r(max)
				}
				qui replace `wt1' = sqrt(`wt1') if e(sample)
				qui replace `wt1' = `wt1' * ///
					sqrt(`nc'/(`nc'-1)) if e(sample)
				local minusopt minus(0)
       				local wopt wopt([iw = `wt1']) 
			}
		}
		else if `weighted' & `cmd_n' > 1 {	// just pweights
			local wopt wopt([`wtype1' = `wt1'])
		}
		local me_qr $ME_QR
		local xtm_ver $XTM_ver
		if "`sort'" != "" {
			sort `sort'
		}
		GetRobustVCE if e(sample), `clustopt' `wopt' `minusopt'
		global ME_QR `me_qr'
		global XTM_ver `xtm_ver'
		if(`nc') {
			ereturn scalar N_clust = `nc'
		}
	}

	// Wald test
	if "`varnames_0'" == "_cons"  | "`varnames_0'" == "" {
		ereturn scalar chi2 = .
		ereturn scalar p = .
		ereturn scalar df_m = 0
	}
	else {
		_prefix_model_test xtmixed
	}

	// Sign data signature
	SignData 

	// Calculate df if specified
	if `"`dftype'"' != "" & e(k_f) {
		`q' di
		`q' di as txt "Computing degrees of freedom:" 

		tempname dfmat V_df
		tempvar touse

		qui _mixed_ddf, method(`dftype') post `useinfo'
		ereturn scalar small = 1  
	}
	else ereturn scalar small = 0
	
	// return e(b_sd), e(V_sd), and e(b_pclass)
	_xtme_estatsd

	_xtmixed_display, level(`level') `lrtest' ///
		`var_opt' `group' `header' `estmetric' ///
		`grouponly' `fetable' `retable' `diopts' dftable(`dfdisp')
end

program ConstantNote
	args lev_k

	di as text							///
"{p 0 6}Note: level `lev_k' already has a constant, {cmd:noconstant} assumed for all other entries for the level{p_end}"

end

program RepeatedLevelError
    di as error 							///
    "{p 0 4}`0' level variable, specified at more than one level{p_end}"
end

program PostParms, eclass
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	syntax [anything] [, beta(string) vbeta(string) re(string) ///
			    vre(string) touse(string) noomit(name) ///
			    omitted(integer 0)]
	tempname bc vc Cns
	GetCns `Cns' k_autoCns
	local r2 = colsof(`re')
	if "`beta'" != "" {	
		local r1 = colsof(`beta') + `omitted'
	}
	else {
		local names: colfullnames `re'
		mat colnames `vre' = `names'
		mat rownames `vre' = `names'
		_ms_op_info `re'
		if r(tsops) {
			quietly tsset, noquery
		}
		eret post `re' `vre' `Cns', depname(`depvar') ///
			esample(`touse') buildfvinfo
		_post_vce_rank
		if `:length local Cns' {
			ereturn hidden scalar k_autoCns = `k_autoCns'
		}
		eret scalar k_f = 0
		eret scalar k_r = `r2'
		eret scalar k = `r2'
		exit
	}
	gettoken depvar xvars : anything

	if strpos("`depvar'",".") {
		gettoken ts rest : depvar, parse(".")
		gettoken dot depvar : rest, parse(".")
	}

	foreach v of local xvars {
		local col `col' `depvar':`v'
	}	
	if `omitted' {
		mata: _add_omitted("`beta'","`vbeta'","`noomit'",`omitted')
	}
	`vv' ///
	mat colnames `beta' = `col'
	mat `bc' = `beta', `re'	
	mat `vc' = (`vbeta' , J(`r1',`r2',0) \ J(`r2',`r1',0), `vre')
	local names: colfullnames `bc'
	`vv' ///
	mat colnames `vc' = `names'
	`vv' ///
	mat rownames `vc' = `names'
	_ms_op_info `bc'
	if r(tsops) {
		quietly tsset, noquery
	}
	eret post `bc' `vc' `Cns', depname(`depvar') esample(`touse') ///
		buildfvinfo
	_post_vce_rank
	if `:length local Cns' {
		ereturn hidden scalar k_autoCns = `k_autoCns'
	}
	eret scalar k_f = `r1'
	eret scalar k_r = `r2'
	eret scalar k = `r1' + `r2'
end

program SaveGroupInfo, eclass
	args levnames wtvars

	tempvar obsc
	qui gen long `obsc' = 1 if e(sample)

	if `"`wtvars'"' != "" {
		local k : word count `wtvars'
		forval i = 1/`k' {
			local wt`i' : word `i' of `wtvars'
			qui replace `obsc' = `obsc' * `wt`i'' if e(sample)
		}
	}

	qui sum `obsc' if e(sample)
	ereturn scalar N = `r(sum)'

	local levels : list uniq levnames
	local k : word count `levels'
	if `k' == 0 {
		exit
	}
		
	tempname gmin gmax gavg Ng
	mat `Ng' = J(1,`k',0)
	mat `gmin' = J(1,`k',0)
	mat `gavg' = J(1,`k',0)
	mat `gmax' = J(1,`k',0)

	tempvar fw
	qui gen long `fw' = 1 if e(sample)
	local wopt [fw = `fw']

	forvalues i = 1/`k' {
		if `"`wt`i''"' != "" {
			qui replace `obsc' = `obsc' / `wt`i'' if e(sample)
			qui replace `fw' = `fw' * `wt`i'' if e(sample)
		}
		GroupStats `:word `i' of `levels'' if e(sample) `wopt', ///
			obsvar(`obsc')
		mat `Ng'[1,`i'] = r(ng)
		mat `gmin'[1,`i'] = r(min)
		mat `gavg'[1,`i'] = r(avg)
		mat `gmax'[1,`i'] = r(max)
	}
	ereturn matrix N_g `Ng'
	ereturn matrix g_min `gmin'
	ereturn matrix g_avg `gavg'
	ereturn matrix g_max `gmax'
end

program GroupStats, rclass
	syntax name [fw] [if], obsvar(varname)
	marksample touse

	if "`namelist'" == "_all" {
		tempvar one
		qui gen byte `one' = 1 if `touse'
		local namelist `one'
	}
	if "`weight'" != "" {
		local wopt [`weight'`exp']
	}
	tempname T
	qui {
		local obstype = c(obs_t)
		if "`obstype'" != "double" {
			local obstype "long"
		}
		bysort `touse' `namelist': /// 
			gen `obstype' `T' = cond(_n==_N,sum(`obsvar'),.) if `touse'
		sum `T' `wopt' if `touse'
	}
	return scalar ng = r(N)
	return scalar min = r(min)
	return scalar max = r(max)
	return scalar avg = r(mean)
end

program IterateEM, rclass
	syntax name(name=theta) [, iter(integer 1) tol(real 1.0) ///
			crit(string) weighted(integer 0) emlog emdots ]

	tempname thetaold s lold lnew delta err
	mat `thetaold' = `theta'

	if "`emlog'" == "" {
		local st *
	}
	if $XTM_res | `weighted' {
		di as txt _n "Obtaining starting values by EM: " _c
	}
	else {
		di as txt _n "Performing EM optimization: " _c
	}
	if "`emdots'" != "" {
		local didot `"di as txt "." _c"'
	}
	else {
		di
		`st' di
	}
	scalar `lold' = -1
	scalar `lnew' = 1
	
	local i 0	
	while `i' <= `iter'-1 & ///
	   reldif(scalar(`lold'),scalar(`lnew')) > `tol' {
		mata: _xtm_em_iter("`thetaold'","`theta'","`s'")
		if missing(r(ll)) {
			if "`emdots'" != "" {
				di _n
			}
			di as err "likelihood evaluates to missing"
			exit 430
		}
`st'di as txt "Iteration `i':" _col(16) "`crit' = " as res %10.0g `r(ll)'
		`didot'
		mat `thetaold' = `theta'
		scalar `lold' = scalar(`lnew')
		scalar `lnew' = r(ll)
		local ++i
	}
	scalar `s' = -1
	mata: _xtm_mixed_ll("`theta'","","`s'",0)
`st'di as txt "Iteration `i':" _col(16) "`crit' = " as res %10.0g `r(ll)'
	if "`emdots'" != "" {
		di 
	}
	return scalar converged = (`i'<`iter')
	return scalar ic = `i'
end

program MyReg, rclass
	version 9
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	syntax anything(name=model) [if] [pw iw fw] [, reml(integer 0)]
	
	gettoken depvar xvars : model

	// strip _cons off the end of xvars
	local k: word count `xvars'
	if `k' {
		if "`:word `k' of `xvars''" == "_cons" {
			local xvars : subinstr local xvars "_cons" ""
		}
		else {
			local nocons nocons
		}
	}
	else {
		local nocons nocons
	}
	if "`weight'" != "" {
		if "`weight'" == "fweight" {
			local wopt [fw`exp']
		}
		else {
			local wopt [iw`exp']
		}
	}
	`vv' ///
	qui _regress `depvar' `xvars' `if' `wopt', `nocons' 
	tempname lnsig ll0 logdet fact
	if `reml' {	
		mata: _xtm_logdetr00("`logdet'")
		scalar `lnsig' = log(e(rmse))
		scalar `ll0' = -e(df_r)/2*(log(2*_pi) + 1 + 2*`lnsig') ///
			       -`logdet'
	}
	else {		
		scalar `lnsig' = log(e(rss)/e(N))/2
		scalar `ll0' = e(ll)
		
	}
	return scalar lnsig = `lnsig'
	return scalar ll0 = `ll0'
end

program SetBlupMats 
	args touse
	tempname gamma theta delta err s2 b rho

	if `"`e(cmd)'"' != "xtmixed" & `"`e(cmd)'"' != "mixed" {
di as err `"BLUP calculations require a previously fitted {cmd:`e(cmd)'} model"'
		exit 301
	}

	local fweighted 0
	if `"`e(wtype)'"' == "fweight" {
		local fweighted 1
	}
	local k : word count `e(ivars)'
	forvalues i = 1/`k' {
		if `"`e(fweight`i')'"' != "" {
			local fweighted 1 
		}
	}

	qui count if `touse'
	if (r(N) != e(N)) & !`fweighted' {
	    di as err "BLUP calculation failed; estimation data have changed"
	    exit 459
	}

	mat `b' = e(b)
	mat `b' = `b'[1,`=e(k_f)+1'...]
	local k = colsof(`b') - e(k_res)
	mat `gamma' = `b'[1,1..`k']
	local p = colsof(`gamma')
	scalar `s2' = exp(2*`gamma'[1,`p'])
	if `e(k_res)' {
		mat `rho' = `b'[1,`=`k'+1'...]
	}
	else {
		mat `rho' = 0
	}

	local k 0
	capture {
		 mata: _xtm_gamma_to_theta("`theta'","`gamma'","`err'")
		 local k = scalar(`err')
		 mata: _xtm_theta_to_delta("`delta'","`theta'","`err'")
		 local k = `k' + scalar(`err')
	}
	if `k' | _rc {
		di as err "BLUP calculation failed; e(b) unsuitable"
		exit 459
	}
	local ll 0
	capture {
		mata: _xtm_mixed_ll("`delta'","`rho'","`s2'",2)
		local ll = r(ll)
	}
	if _rc | reldif(`ll',e(ll)) > 1e-12 {
	    di as err "BLUP calculation failed; estimation data have changed"
	    exit 459
	}
end

program CheckBlups
	local k : word count `0'
	if mod(`k',2) {
		di as err "getblups() incorrectly specified"
		exit 198
	}
	forvalues i = 1/`=`k'/2' {
		gettoken level 0 : 0
		gettoken stub 0 : 0
		if `:list stub in stublist' {
			di as err "stubs must be unique"
			exit 198
		}
		local stublist `stublist' `stub'
		if `"`level'"' != "_all" {
			unab level : `level'
		}
		local ivars `e(ivars)'
		local p : list posof "`level'" in ivars
		if !`p' {
			di as err `"`level' is not a group variable"'
			exit 198
		}
		local m 0
		forvalues j = `p'/`:word count `ivars'' {
			if `"`:word `j' of `ivars''"' != "`level'" {
				continue, break
			}
			local np : word `j' of `e(redim)'	
			forvalues k = 1/`np' {
				confirm new variable `stub'`=`m'+`k''
			}
			local m = `m' + `np'
		}
	}
end

program GetBlups
	args blist reise
	mata: _xtm_fillBmat() 

	local k : word count `blist'
	forvalues i = 1/`=`k'/2' {
		gettoken level blist : blist
		gettoken stub blist : blist
		if `"`level'"' != "_all" {
			unab level : `level'
		}
		GetBlupsLevel `level' `stub' `reise'
	}
end

program GetBlupsLevel
	args lvar stub reise

	local ivars `e(ivars)'
	local zvars `e(revars)'

	// get z variables
	local w : word count `ivars'
	forvalues i = 1/`w' {
		local lev : word `i' of `ivars'
		local dim : word `i' of `e(redim)'
		if "`lev'" != "`lvar'" {
			local dont *
		}
		forvalues j = 1/`dim' {
			gettoken z zvars : zvars 
			`dont'local zs `zs' `z'
		}
		local dont
	}

	local uivars : list uniq ivars
	local p : list posof "`lvar'" in uivars 	// p is the true level
	local nz : word count `zs'

	if "`reise'" != "" {
		local lab r.e. std. errors
		local dose 1
	}
	else {
		local lab r.e.
		local dose 0
	}

	forvalues i = 1/`nz' {
		qui gen double `stub'`i' = . 
		label var `stub'`i' `"BLUP `lab' for `lvar': `:word `i' of `zs''"'
	}
	
	mata: _xtm_blup_save("`stub'",`p',`dose')
end

program GetVarStruct, sclass sort
	args structspec touse rgroup lastlev

	local 0 `structspec'
	syntax [anything] [, by(varname) t(varname numeric)]
	local group `by'

	local struct `anything'
	ParseVarStruct `"`struct'"' 
	sreturn local tvar `t'
	sreturn local rstructlab `s(structlab)'
	sreturn local order `s(order)'
	local structure `s(structure)'

	if "`group'" != "" {
		qui replace `touse' = 0 if missing(`group')
		qui egen long `rgroup' = group(`group') if `touse'
		if "`lastlev'" != "" & "`structure'" != "independent" {
			CheckConstantWithin `lastlev' `rgroup' `touse'
		}
		qui sum `rgroup' if `touse', meanonly
		if r(max) == 1 {
			di as txt "{p 0 4 2}Note: grouping variable constant "
			di as txt "over estimation data; by() option "
			di as txt "ignored{p_end}"
			local rgroup
			sreturn local nrgroups 1
		}
		else {
			sreturn local nrgroups `r(max)'
			GetGroupLabels `group' `touse'
			sreturn local rglabels `"`s(rglabels)'"'
		}
		sreturn local ogroup `group'
		sreturn local rgroup `rgroup'
		
		capture confirm numeric variable `group'
		if _rc {
			qui levelsof `group' if `touse'
			local rlevels `"`r(levels)'"'
			local k : list sizeof rlevels
			forvalues i=1/`k' {
				local rgvalues `rgvalues' `i'.`group'
			}
		}
		else {
			tempname m
			qui tab `group' if `touse', matrow(`m')
			local k = rowsof(`m')
			forvalues i=1/`k' {
				local v = `m'[`i',1]
				local rgvalues `rgvalues' `v'.`group'
			}
		}
		sreturn local rgvalues `rgvalues'
	}
	else {
		sreturn local nrgroups 1
	}
	sreturn local structure `structure'
end

program GetGroupLabels, sclass
	args group touse
	preserve
	qui drop if !`touse'
	tempvar tokeep
	sort `group'
	qui by `group': gen byte `tokeep' = _n == 1
	qui keep if `tokeep'
	// Now loop over the "data"
	cap confirm string variable `group'
	if !_rc {
		forval i = 1/`=_N' {
			local lab = abbrev(`group'[`i'], 30)
			local rglabels `"`rglabels' `"`lab'"'"'
		}
		sreturn local rglabels `"`rglabels'"'
		exit
	}
	local vl : value label `group'
	if "`vl'" != "" {
		forval i = 1/`=_N' {
			local lab : label (`group') `=`group'[`i']' 30
			local rglabels `"`rglabels' `"`lab'"'"'
		}
		sreturn local rglabels `"`rglabels'"'
		exit
	}
	forval i = 1/`=_N' {
		cap confirm integer number `=`group'[`i']'
		if _rc {
			di as err "{p 0 4 2}numeric by() variable must be "
			di as err "integer-valued{p_end}"
			exit 459
		}
		local lab : di `group'[`i'] 
		local lab = abbrev(`"`lab'"', 30)
		local rglabels `"`rglabels' `"`lab'"'"'
	}
	sreturn local rglabels `"`rglabels'"'
end

program ParseVarStruct, sclass
	args struct 
	local k : word count `struct'
	if `k' == 1 {
		gettoken struct rest : struct, parse("0123456789")	
	}
	else {
		gettoken struct rest : struct
	}
	local k : word count `rest'
	if `k' > 1 {
		di as err "{p 0 4 2}invalid residuals() specification{p_end}"
		exit 198
	}
	local ar_p 0
	local ma_q 0 
	local l = length(`"`struct'"')
	if `"`struct'"' == "ar" {
		local resid ar
		if "`rest'" == "" {
			local ar_p 1
		}
		else {	
			local ar_p `rest'
		}
		confirm integer number `ar_p'
		cap assert `ar_p' > 0
		if _rc {
			di as err "{p 0 4 2}AR parameter must be a "
			di as err "positive integer{p_end}"
			exit 198
		}
		local structlab AR(`ar_p')
		local order `ar_p'
		local rest
	}
	else if `"`struct'"' == "ma" {
		local resid ma
		if "`rest'" == "" {
			local ma_q 1
		}
		else {
			local ma_q `rest'
		}
		confirm integer number `ma_q'
		cap assert `ma_q' > 0
		if _rc {
			di as err "{p 0 4 2}MA parameter must be a "
			di as err "positive integer{p_end}"
			exit 198
		}
		local structlab MA(`ma_q')
		local order `ma_q'
		local rest
	}
	else if `"`struct'"' == bsubstr("toeplitz", 1, max(2, `l')) {
		local resid toeplitz
		if "`rest'" == "" {
			local to_p -1
			local specified 0
		}
		else {
			local to_p `rest'
			local specified 1
		}
		confirm integer number `to_p'
		cap assert `to_p' >= 0
		if _rc & `specified' {
			di as err "{p 0 4 2}Toeplitz parameter must be a "
			di as err "nonnegative integer{p_end}"
			exit 198
		}
		if `to_p' == 0 {
			di as txt "{p 0 4 2}Note: A Toeplitz structure of "
			di as txt "order 0 is the independent structure{p_end}"
			sreturn local structure independent
			sreturn local structlab Independent
			sreturn local ar_p `ar_p'
			sreturn local ma_q `ma_q'
			sreturn local order -1
			exit
		}
		local structlab Toeplitz(`to_p')
		local order `to_p'
		local rest
	}
	else if `"`struct'"' == bsubstr("banded", 1, max(2, `l')) {
		local resid banded
		if "`rest'" == "" {
			local ba_p -1
			local specified 0
		}
		else {
			local ba_p `rest'
			local specified 1
		}
		confirm integer number `ba_p'
		cap assert `ba_p' >= 0 
		if _rc & `specified' {
			di as err "{p 0 4 2}Banded parameter must be a "
			di as err "nonnegative integer{p_end}"
			exit 198
		}
		local structlab Banded(`ba_p')
		local order `ba_p'
		local rest
	}
	else if `"`struct'"' == bsubstr("exchangeable", 1, max(2, `l')) {
		local resid exchangeable
		local structlab Exchangeable
	}
	else if `"`struct'"' == bsubstr("unstructured", 1, max(2, `l')) {
		local resid unstructured
		local structlab Unstructured
	}
	else if `"`struct'"' == bsubstr("exponential", 1, max(3, `l')) {
		local resid exponential
		local structlab Exponential
	}
	else if `"`struct'"' == bsubstr("independent", 1, max(3, `l')) {
		local resid independent
		local structlab Independent
	}
	else if `"`struct'"' == "" {
		local resid independent
		local structlab Independent
	}
	else {
		di as err "{p 0 4 2}invalid residual() structure{p_end}"
		exit 198
	}
	if "`rest'" != "" {
		di as err "{p 0 4 2}residual() structure does not take "
		di as err "any additional arguments{p_end}"
		exit 198
	}
	sreturn local structure `resid'
	sreturn local structlab `structlab'
	sreturn local ar_p `ar_p'
	sreturn local ma_q `ma_q'
	if "`order'" == "" {
		local order -1
	}
	sreturn local order `order'
end

program CheckConstantWithin, sortpreserve
	// check that group is constant within lev
	args lev group touse

	tempvar gr
	qui egen long `gr' = group(`lev' `touse')
	sort `gr'
	cap by `gr': assert `group' == `group'[1] if `touse'
	if _rc {
		di as err "{p 0 4 2}option residuals(): by variable is not "
		di as err "constant within lowest-level panels{p_end}"
		exit 459
	}
end

program ProcessTimeVar, sort
	args tvar time gap struct touse level umap order

	if "`struct'" == "ar"  | "`struct'" == "ma" | 		/// 
	   "`struct'" == "toeplitz" {
		if "`tvar'" == "" {
			di as err "{p 0 4 2}t() required for this structure"
			di as err "{p_end}"
			exit 198
		}
		qui replace `touse' = 0 if missing(`tvar')
		cap assert `tvar' == int(`tvar') if `touse'
		if _rc {
			di as err "{p 0 4 2}time variable must be "
			di as err "integer-valued{p_end}"
			exit 459
		}
		tempvar gr diff
		qui egen long `gr' = group(`level' `touse')
		sort `gr' `tvar'
		qui bysort `gr': gen long `time' = `tvar'-`tvar'[1]+1 ///
				 if `touse' 
		qui by `gr': gen long `diff' = `time' - `time'[_n-1] /// 
				 if _n > 1 & `touse'
		cap assert `diff' > 0 if `touse' & !missing(`diff')
		if _rc {
			di as err "{p 0 4 2}repeated time values within 
			di as err "lowest-level panels{p_end}"
			exit 459
		}
		qui by `gr': gen byte `gap' = `time'[_N] > _N if `touse'
		cap assert !`gap' if `touse'
		if _rc {
			di as txt "{p 0 4 2}Note: time gaps exist in the "
			di as txt "estimation data{p_end}"
		}
		drop `diff'
		if "`struct'" != "toeplitz" {
			qui by `gr': gen byte `diff' = _N > `order' if `touse'
			qui count if `diff' & `touse'
			if !r(N) {
				local tt = upper("`struct'")
				di as err "{p 0 4 2}`tt' order must be less "
				di as err "than the size of the largest "
				di as err "lowest-level panel{p_end}"
				exit 459
			}
		}
		else {
			qui by `gr': gen byte `diff' = _N > `order' if `touse'
			qui count if `diff' & `touse'
			if !r(N) {
				di as err "{p 0 4 2}Toeplitz order must be "
				di as err "less than the size of the "
				di as err "largest lowest-level panel{p_end}"
				exit 459
			}
			qui sum `time' if `touse'
			local maxt = r(max)
			c_local maxt `maxt'
		}
		exit
	}
	else if "`struct'" == "unstructured" | "`struct'" == "banded" {
		if "`tvar'" == "" {
			di as err "{p 0 4 2}t() required for this structure"
			di as err "{p_end}"
			exit 198
		}
		qui replace `touse' = 0 if missing(`tvar')
		cap assert `tvar' == int(`tvar') if `touse'
		if _rc {
			di as err "{p 0 4 2}t() variable must be "
			di as err "integer-valued{p_end}"
			exit 459
		}
		cap assert `tvar' >= 0 if `touse'
		if _rc {
			di as err "{p 0 4 2}t() variable must be "
			di as err "nonnegative-valued{p_end}"
			exit 459
		}
		tempvar gr 
		qui egen long `gr' = group(`level' `touse')
		qui levelsof `tvar' if `touse', local(levs)
		qui egen long `time' = group(`tvar') if `touse'
		local maxt : word count `levs'
		matrix `umap' = J(1, `maxt', 0)
		local j 1
		foreach i of local levs {
			mat `umap'[1, `j'] = `i'
			local ++j
		}
		sort `gr' `time' 
		cap by `gr': assert `time' != `time'[_n-1] if `touse'
		if _rc {
			di as err "{p 0 4 2}repeated t() values within "
			di as err "lowest-level panels{p_end}"
			exit 459
		}
		qui by `gr': gen byte `gap' = (`time' != _n) | ///
		                              (_N != `maxt') if `touse'
		gsort `gr' -`gap'
		qui by `gr': replace `gap' = `gap'[1] if `touse'
		if "`struct'" == "banded" & `order' > `maxt' - 1 {
			di as err "{p 0 4 2}banded order must be less "
			di as err "than the number of unique time values{p_end}"
			exit 459
		}
		c_local maxt `maxt'
		exit
	}
	else if "`struct'" == "exponential" {
		if "`tvar'" == "" {
			di as err "{p 0 4 2}t() required for this structure"
			di as err "{p_end}"
			exit 198
		}
		qui replace `touse' = 0 if missing(`tvar')
		qui gen double `time' = `tvar' if `touse'
		c_local gap
		exit
	}
	else if "`tvar'" != "" {
		di as txt "{p 0 4 2}Note: t() not required for this residual "
		di as txt "structure; ignored{p_end}"
		c_local time
		c_local gap
		exit
	}
	c_local time
	c_local gap
end

program PredictScores
	args stub touse 

	local w : word count `stub'

	if `w' != 1 {
		di as err "getscores() incorrectly specified"
		exit 198
	}

	tempname err eb llf romit

	if `"`e(cmd)'"' != "xtmixed" & `"`e(cmd)'"' != "mixed" {
di as err "{p 0 4 2}score calculations require a previously fitted " 
di as err "{cmd:`e(cmd)'} model{p_end}"
		exit 301
	}

	mat `eb' = e(b)		// Scores at final parameter estimates

	_ms_omit_info `eb'
	mat `romit' = r(omit)

	local cnames : colnames `eb'
	local ceq: coleq `eb'

	local w = colsof(`eb')
	forvalues i = 1/`w' {
		if `i' <= `e(k_f)' { 		// fixed-effect
			local ll : word `i' of `cnames'
		}
		else {
			local ll : word `i' of `ceq'
			local ll [`ll']
		}
		confirm new variable `stub'`i'
		qui gen double `stub'`i' = . if `touse'
		label var `stub'`i' /// 
			`"parameter-level score for `ll' from `e(cmd)'"'
		local scvars `scvars' `stub'`i'
	}

	mata: _xtm_get_scores_st("`eb'", "e(k_r)", "e(k_res)",   ///
	                         "`scvars'", "`llf'", "`err'")

	if reldif(scalar(`llf'), e(ll)) > 1e-10 {
		di as err "{p 0 4 2}scores calculation failed; estimation "
		di as err "data have changed{p_end}"
		cap drop `scvars'
		exit 459
	}

	if scalar(`err') {
		di as err "scores calculation failed"
		cap drop `scvars'
		exit 430
	}
end

program GetRobustVCE, eclass

	syntax [if] [, cluster(passthru) wopt(string) minus(passthru)]
	
	tempname b
	mat `b' = e(b)
	local nc = colsof(`b')

	forvalues i = 1/`nc' {
		tempname sc`i'
		local scvars `scvars' `sc`i''
	}
	cap predict double `scvars' `if', scores
	if _rc {
		di as err "error obtaining scores for robust variance"
		exit 430
	}
	cap _robust2 `scvars' `wopt' `if', allcons `cluster' `minus'
	if _rc {
		di as err "error calculating robust variance"
		exit 430
	}
end

program RescaleWeights, sortpreserve
	args method wt0 wt1 level touse

	local k : word count `method'
	if `k' > 1 {
		di as err "{p 0 4 2}invalid pscale(){p_end}"
		exit 198
	}
	tempvar sumw
	qui bysort `touse' `level': gen double `sumw' = ///
			sum(`wt0') if `touse'
	qui by `touse' `level': replace `sumw' = `sumw'[_N] if `touse'

	local l = length(`"`method'"')
	if `"`method'"' == bsubstr("size", 1, max(4, `l')) {
		tempvar nj
		qui by `touse' `level': gen double `nj' = _N if `touse'
		qui replace `wt0' = `wt0'*`nj'/`sumw' if `touse'
	}
	else if `"`method'"' == bsubstr("effective", 1, max(3, `l')) {
		tempvar sumsqw
		qui by `touse' `level': gen double `sumsqw' = ///
			sum(`wt0'*`wt0') if `touse'
		qui by `touse' `level': replace `sumsqw' = `sumsqw'[_N] ///
			if `touse'
		qui replace `wt0' = `wt0'*`sumw'/`sumsqw' if `touse'
	}
	else if `"`method'"' == bsubstr("gk", 1, max(2, `l')) {
		tempvar wt01
		qui by `touse' `level': gen double `wt01' = ///
			sum(`wt0'*`wt1') if `touse'
		qui by `touse' `level': replace `wt01' = `wt01'[_N]/_N ///
			if `touse'
		qui replace `wt1' = `wt01' if `touse'
		qui replace `wt0' = 1 if `touse'
	}
	else {
		di as err "{p 0 4 2}invalid pscale(){p_end}"
		exit 198
	}
end

program FixUpWeights
	args wtnames pws fws

	local uniqnames : list uniq wtnames
	local m : word count `uniqnames'
	local pos 1
	forvalues k = 1/`m' {
		local lev : word `k' of `uniqnames'
		local wtn : word `pos' of `wtnames'
		local isweighted 0
		while `"`wtn'"' == `"`lev'"' {
			local ww pw
			local weight : word `pos' of `pws'
			if `"`weight'"' == "" {
				local weight : word `pos' of `fws'
				local ww fw
			}
			if `"`weight'"' != "" {
				if `isweighted' {
					di as err "{p 0 4 2}you cannot have "
					di as err "multiple weight specifications "
					di as err "within the same model level"
					di as err "{p_end}"
					exit 198
				}
				c_local `ww'eight_`k' `"`weight'"'
				local isweighted 1
			}
			local ++pos
			local wtn : word `pos' of `wtnames'
		}
	}
	local mm : word count `wtnames'
	forvalues k = `=`m'+1'/`mm' {
		c_local pweight_`k'
		c_local fweight_`k'
	}
end

program GetCns
	version 11
	args Cns autoCns
	if "`e(Cns)'" == "matrix" {
		version 11: matrix `Cns' = e(Cns)
		c_local `autoCns' = e(k_autoCns)
	}
	else	c_local Cns
end

program NoOmit, rclass
	syntax varlist(fv ts)
	local hasfv = "`s(fvops)'" == "true"	
	fvexpand `varlist'
	local full_list `r(varlist)'
	local cols : word count `full_list'
	tempname noomit noomitcols
	mat `noomit' = J(1,`cols',1)
	local omitted 0
	local i 1
	foreach var of local full_list {
		_ms_parse_parts `var'
		if `r(omit)' {
			local ++omitted	
			mat `noomit'[1,`i'] == 0
			if !`hasfv' {
				local hasfv 1
			}
		}
		else {
			local vars_noomit "`vars_noomit' `var'"
			capture assert `noomitcols'[1,1]>0
			if !_rc {
				mat `noomitcols' = `noomitcols'[1,1...],`i'
			}
			else {
				mat `noomitcols' = J(1,1,`i')
			}
		}
		local ++i
	}
	return local omitted = "`omitted'"
	return local vars_noomit "`vars_noomit'"
	return matrix noomitcols = `noomitcols'
	return scalar hasfv = `hasfv'
	return matrix noomit = `noomit'
end

version 11
local SS        string scalar
local RS        real scalar
local RRVEC     real rowvector
local RMAT      real matrix
mata:

void _add_omitted(`SS' bname, `SS' vname, `SS' noomitname, `RS' k)
{
        `RS'            ncols, p
        `RRVEC'         noomitcols, b
        `RMAT'          V


        p = cols(st_matrix(noomitname))
        ncols = cols(st_matrix(bname))+k

        noomitcols = range(1,ncols,1)'
        noomitcols = select(noomitcols,(st_matrix(noomitname),J(1,ncols-p,1)))

        b = J(1,ncols,0)
        V = J(ncols,ncols,0)
        b[noomitcols] = st_matrix(bname)
        V[noomitcols', noomitcols] = st_matrix(vname)

        st_matrix(bname, b)
        st_matrix(vname, V)
}

end

program CheckDfType, rclass

	syntax [, method(string) type(string)]

	local 0 `type'

	syntax anything [, EIM OIM * ]

	if `"`options'"' != "" {
		di as err "{p}suboption {bf:`options'} in option "
		di as err "{bf:dfmethod()} is not valid{p_end}"
		exit 198
	}

	local 0 , `anything' 

	syntax [, KRoger SATterthwaite RESidual REPeated ANOVA *]

	if `"`options'"' != "" {
		di as err "{p}invalid method {bf:`options'} in option {bf:dfmethod()}{p_end}" 
		exit 198
	}

	local types "`kroger' `satterthwaite'"
	local types "`types' `residual' `repeated' `anova'"

	local w: word count `types'

	if `w' >1 {
		di as err "{p}only one method is allowed in option {bf:dfmethod()}{p_end}"
		exit 198
	}
	
	local type = strtrim("`types'")

	if ("`method'"=="ML" & ///
	   ("`type'"=="kroger" | "`type'"=="satterthwaite")) {
        	di as err "{p 0 4 2}option {bf:dfmethod(`type')} is allowed"
	        di as err "only with REML estimation{p_end}"
        	exit 198
	}

	if ("`eim'"!="" | "`oim'"!="") {
		if ("`eim'"!="" & "`oim'"!="") {
			di as err "{p}only one of {bf:eim} or {bf:oim} is"
			di as err "allowed in option {bf:dfmethod()}{p_end}"
			exit 198
		} 

		local useinfo "`eim'`oim'"
	}
	
	if ("`type'" == "residual" | "`type'"=="anova" | ///
		"`type'" == "repeated") {
		if "`useinfo'" != "" {
			di as err "{p}suboption {bf:`useinfo'} can only"
			di as err "be specified when option {bf:dfmethod()}"
			di as err "contains {bf:kroger} or"
			di as err "{bf:satterthwaite}{p_end}"
			exit 198
		}
	}
	else if ("`useinfo'"=="") local useinfo eim

	if ("`type'" == "kroger" | "`type'" == "satterthwaite") {
		return local useinfo = "`useinfo'"
	}
	return local dftype = "`type'"
end

program CheckBalance, rclass sortpreserve
	syntax varlist
	local nvars : list sizeof varlist
	
	local imbal = 0
	forvalues i=1/`nvars' {
		local var: word `i' of `varlist'
	
		sort `var'
		tempvar nobs
		quietly by `var' : gen `c(obs_t)' `nobs'=_N
		cap assert `nobs'== `nobs'[1]
		if c(rc) {
			local imbal = `imbal'+1	
		}	
		else local imbal = `imbal'+ 0 	
	}

	if `imbal' {
		local bal unbalanced
	}
	else local bal balanced

	return local balanced `bal'
end

program CheckDftable, rclass

	syntax [, dftable(string) diopts(string) dfmesg(string) ]

	local 0, `dftable'
	syntax [, DEFault CI PValue * ]
 
	if `"`options'"' != "" {
		di as err "{p}{bf:`options'} not allowed in option {bf:dftable()}{p_end}"
		exit 198
	}

	opts_exclusive "`default' `ci' `pvalue'" dftable

	local 0, `diopts'
	syntax [, COEFLegend SELEGEND NOCI NOPValues * ]

	if `"`coeflegend'"'!= "" {
		di as err "{p}option {bf:coeflegend} may not be combined " ///
			"with option {bf:`dfmesg'}{p_end}"
		exit 198
	} 
	if `"`selegend'"'!= "" {
		di as err "{p}option {bf:selegend} may not be combined " ///
			"with option {bf:`dfmesg'}{p_end}"
		exit 198
	}
	if `"`noci'"'!= "" & `"`nopvalues'"'!= "" {
		di as err "{p}only one of {bf:noci} or {bf:nopvalues}" ///
			" is allowed{p_end}"
		exit 198
	}
	if `"`ci'"'!= "" & `"`noci'`nopvalues'"'!="" {
		di as err "{p}only one of {bf:dftable(ci)} or "	///
			"{bf:`noci'`nopvalues'} is allowed{p_end}"
		exit 198
	}
	if `"`pvalue'"'!= "" & `"`noci'`nopvalues'"'!="" {
		di as err "{p}only one of {bf:dftable(pvalue)} or "	///
			"{bf:`noci'`nopvalues'} is allowed{p_end}"
		exit 198
	}

	if `"`pvalue'"' != "" return local dfdisp "pvalue"
	else if `"`ci'"' != "" return local dfdisp "ci"
	else return local dfdisp "default" 
end

program SignData
	version 14

	if (`e(k_f)' > 0) {
		tempname beta
		mat `beta' = e(b)
		mat `beta' = `beta'[1, 1..`e(k_f)']
		local varlist : colnames `beta'
		local varlist : subinstr local varlist "_cons" "", all word
	}
	
	local depvar `e(depvar)'
	local ivars `e(ivars)'
	local ivars : subinstr local ivars "_all" "", all word
	local revars `e(revars)'
	local revars : subinstr local revars "_cons" "", all
	local revars : subinstr local revars "R." "", all
	local rbyvar `e(rbyvar)'
	local timevar `e(timevar)'
	local clustvar `e(clustvar)'

	local varnames `depvar' `varlist' `ivars' `revars' 
	local varnames `varnames' `rbyvar' `timevar' `clustvar'
	local varnames : list uniq varnames 

	foreach var of local varnames {
		_ms_parse_parts `var'
		if "`r(k_names)'" != "" {
			forvalues i = 1/`r(k_names)' {
				local vars `vars' `r(name`i')'
			}
		}
		else {
			local vars `vars' `r(name)'
		}	
	}
	local vars : list uniq vars

	signestimationsample `vars'
end

exit
