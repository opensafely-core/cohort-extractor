*! version 1.1.0  30mar2018

program define _stteffects_estimate, eclass
	version 14.0

	_on_colon_parse `0'
	local args `s(before)'
	gettoken subcmd touse : args
	local 0 `s(after)'

	syntax [fw iw pw] [, 			///
			omodel(string)		///
			tmodel(string)		///
			cmodel(string)		///
			ate atet POMeans	///
			AEQuations		///
			CONtrol(passthru)	///
			TLEvel(passthru)	///
			NOLOg LOg		///
			noSHow			///
			VERBose			///
			* ]

	/* undocumented: VERBose -- spew output				*/

	_teffects_gmmopts, `options'
	local gmmopts `s(gmmopts)'
	local rest `s(rest)'

	ParseInitOptions `subcmd' : `rest'
	local initopts `s(initopts)'
	local rest `s(rest)'
	local from `s(from)'
	if "`rest'" != "" {
		local wc: word count `rest'
		di as err `"{p}`=plural(`wc',"option")' {bf:`rest'} "' ///
		 `"`=plural(`wc',"is","are")' not allowed{p_end}"'
		exit 198
	}

	_teffects_getstat1, `ate' `atet' `pomeans'
	local stat "`s(stat1)'"
	if "`stat'" == "pomeans" {
		local keq = 1
	}
	else {
		local keq = 2
	}
	if "`weight'" != "" {
		di as err "{p}weights are not allowed; use {helpb stset} " ///
		 "to set weights{p_end}"
		exit 101
	}
	local wtype : char _dta[st_wt]
	local wvar : char _dta[st_wv]
	if "`wtype'" != "" {
		local wopts wtype(`wtype') wvar(`wvar')
		if ("`wtype'"=="fweight") local fwopt freq(`wvar')
	}
	/* assumption stset						*/
	/* survival time variable					*/
	local to : char _dta[st_bt]
	if "`to'" == "" {  // should not happen
		di as err "{p}survival time variable could not be found; " ///
		 "be sure to {bf:stset} your data{p_end}"
		exit 119
	}
	/* failure event variable					*/
	local fo : char _dta[st_bd]
	/* entry time expression					*/
	local entexp : char _dta[st_enter]
	if "`entexp'" != "" {
		di as err "{p}entry time expression {bf:`entexp'} is "    ///
		 "defined; a survival entry-time is not allowed{p_end}"
		exit 119
	}
	/* exit time expression						*/
	local exexp : char _dta[st_exit]
	if "`exexp'" != "" {
		di as err "{p}exit time expression {bf:`exexp'} is "    ///
		 "defined; a survival exit-time is not allowed{p_end}"
		exit 119
	}
	/* id for multiple record data					*/
	local id : char _dta[st_id]
	if "`id'" != "" {
		di as err "{p}ID expression {bf:`id'} is defined; " ///
		 "multiple-record-per-subjects survival data not allowed{p_end}"
		exit 119
	}
	/* time0 options						*/
	local time0 : char _dta[st_bt0]
	if "`time0'" != "" {
		di as err "{p}{bf:tsset} option {bf:time0(`time0')} is " ///
		 "not allowed{p_end}"
		exit 119
	}
	/* mark out internal time and failure variables			*/
	local to : char _dta[st_t]
	if "`fo'" != "" {
		local fo : char _dta[st_d]
	}
	markout `touse' `to' `fo' 
	
	/* [if] expression						*/
	local tu : char _dta[st_ifexp]
	if "`tu'" != "" {
		/* should already be marked out				*/
		qui replace `touse' = (`touse' & (`tu'))
	}
	/* if() option							*/
	local stif : char _dta[st_if]
	if "`stif'" != "" {
		/* should already be marked out				*/
		qui replace `touse' = (`touse' & (`stif'))
	}
	_teffects_count_obs `touse', `fwopt' ///
		why(observations with missing values)
	
	local regadj = ("`subcmd'"=="ra" | "`subcmd'"=="wra")
	
	ExtractVarlist treatment : `tmodel'
	local tvarlist `s(varlist)'
	local tops `s(options)'
	if `regadj' {
		if `:list sizeof tvar' > 1 {
			di as err "{p}too many variables in the treatment " ///
			 "model; only the treatment indicator variable is " ///
			 "expected for the {bf:`subcmd'} estimator{p_end}"
			exit 103
		}
		/* check tvar, update `touse', check for control group	*/
		_teffects_parse_tvar `tvarlist', touse(`touse') `fwopt'      ///
			`tops' stat(`stat') cmd(`subcmd') `control' `tlevel'
		local tmodel
		local klev = `s(klev)'
	}
	else {
		local ip ip
		/* check tvar tvarlist, update `touse', check for 	*/ 
		/*  control group					*/
		_teffects_parse_tvarlist `tvarlist', touse(`touse') `fwopt'  ///
			`tops' stat(`stat') cmd(`subcmd') `control' `tlevel' 

		local klev = `s(klev)'
		local keq = `keq'+`klev'-1
		local tvarlist `"`s(tvarlist)'"'
		local fvtvarlist `"`s(fvtvarlist)'"'
		local tmodel `s(tmodel)'
		local tconstant `s(constant)'
		local topts `"tmodel(`tmodel') treatvars(`fvtvarlist'"'
		if ("`tconstant'"!="") local topts `"`topts', noconstant"'
		local topts `"`topts')"'
		if "`tmodel'" == "hetprobit" {
			local keq = `keq'+`klev'-1
			local hvarlist `"`s(hvarlist)'"'
			local fvhvarlist `"`s(fvhvarlist)'"'
			local hpopts treat2vars(`fvhvarlist')
		}
	}
	local tvar `s(tvar)'
	local control = `s(control)'
	local tlevel = `s(tlevel)'
	local levels "`s(levels)'"

	if `"`omodel'"' != "" {
		/* outcome (survival) model				*/
		ExtractVarlist outcome : `omodel'
		local ovarlist `s(varlist)'
		local oopts `s(options)'

		_stteffects_parse_stvarlist model(outcome) tvar(`tvar') ///
			touse(`touse') `wopts': `ovarlist', `oopts'
		local keq = `keq' + `klev'
		local ovarlist `s(varlist)'
		local fvovarlist `s(fvvarlist)'
		local oconstant `s(constant)'

		local odist `s(dist)'
		local keq = `keq' + `klev'*("`odist'"!="exponential")
		/* lgamma, weibull, & gamma				*/
		local oshapevlist `s(shapevlist)'
		local fvoshapevlist `s(fvshapevlist)'
		local oshapeconst `s(shapeconst)'

		local srvopts "survdist(`odist')"
		local srvopts `"`srvopts' survvars(`fvovarlist',`oconstant')"'
		local srvopts `"`srvopts' survshape(`fvoshapevlist',"'
		local srvopts `"`srvopts'`oshapeconst')"'
	}
	else if ("`subcmd'"!="ipw") local odist exponential

	if `"`cmodel'"' != "" {
		/* censoring model 					*/
		if "`fo'" == "" {
			di as err "{p}censoring model requires that you " ///
			 "{bf:stset} a failure event variable{p_end}"
			exit 119
		}
		ExtractVarlist censoring : `cmodel'
		local cvarlist `s(varlist)'
		local copts `s(options)'

		_stteffects_parse_stvarlist model(censoring) tvar(`tvar') ///
			touse(`touse') `wopts': `cvarlist', `copts'
		local `++keq'
		local cvarlist `s(varlist)'
		local cconstant `s(constant)'
		local fvcvarlist `s(fvvarlist)'
		local cdist `s(dist)'
		local keq = `keq' + ("`cdist'"!="exponential")
		/* weibull & gamma					*/
		local cshapevlist `s(shapevlist)'
		local cshapeconst `s(shapeconst)'
		local fvcshapevlist `s(fvshapevlist)'

		local cenopts `"censordist(`cdist')"'
		local cenopts `"`cenopts' censorvars(`fvcvarlist',`cconstant')"'
		local cenopts `"`cenopts' censorshape(`fvcshapevlist',"'
		local cenopts `"`cenopts'`cshapeconst')"'

		/* completed markout; use _d to check if all failed	*/
		summarize _d if `touse', meanonly
		if r(min) == 1 {
			di as err "{p}censoring model cannot be estimated; " ///
			 "all subjects failed after excluding observations " ///
			 "with missing values{p_end}"
			exit 459
		}
	}
	else if "`subcmd'" == "wra" {
		local cdist exponential
		local cenopts censordist(exponential)
	}
	else if "`subcmd'" == "ipw" {
		/* no censoring model, must all fail			*/
		summarize _d if `touse', meanonly
		if r(min) == 0  {
			di as err "all observations must fail for the "  ///
			 "IPW model without a censoring distribution; " ///
			 "this is not the case"
			exit 459
		}
	}
	if "`fo'" != "" {
		/* completed markout; specified failure()		*/
		/* check for any failures				*/
		summarize `fo' if `touse', meanonly
		if r(min)==0 & r(max)==0 {
			di as err "{p}there are no failures in the dataset " ///
			 "after excluding observations with missing "        ///
			 "values; this is not allowed{p_end}"
			exit 459
		}
	}
	_stteffects_`ip'wra_init `tvar', touse(`touse') `topts' `hpopts' ///
		`srvopts' `cenopts' stat(`stat') control(`control')      ///
		tlevel(`tlevel') levels(`levels') `initopts' `verbose' 

	tempname b0
	mat `b0' = r(b)
	
	/* matrix stripe routines put varlists into canonical form	*/
	/* could be small changes					*/
	if !`regadj' {
		local fvtvarlist `"`r(treatvars)'"'
		if "`tmodel'" == "hetprobit" {
			local fvhvarlist `"`r(treat2vars)'"'
			local hpopts treat2vars(`fvhvarlist')
		}
		local topts `"tmodel(`tmodel') treatvars(`fvtvarlist',"'
		local topts `"`topts'`tconstant')"'
	}
	if "`odist'" != "" {
		local fvovarlist `"`r(survvars)'"'
		local srvopts "survdist(`odist')"
		local srvopts `"`srvopts' survvars(`fvovarlist',`oconstant')"'
		if "`odist'" != "exponential" {
			local fvoshapevlist `"`r(survshape)'"'
			local srvopts `"`srvopts' survshape(`fvoshapevlist',"'
			local srvopts `"`srvopts'`oshapeconst')"'
		}
	}
	if "`cdist'" != "" {
		local fvcvarlist `"`r(censorvars)'"'
		local cenopts `"censordist(`cdist')"'
		local cenopts `"`cenopts' censorvars(`fvcvarlist',`cconstant')"'
		if "`cdist'" != "exponential" {
			local fvcshapevlist `"`r(censorshape)'"'
			local cenopts `"`cenopts' censorshape(`fvcshapevlist',"'
			local cenopts `"`cenopts'`cshapeconst')"'
		}
	}
	if "`from'" != "" {
		_stteffects_from, b(`b0') `from'
	}
	st_show `show'
	_stteffects_ipwra_gmm `tvar', from(`b0') stat(`stat') touse(`touse') ///
		`topts' `hpopts' `srvopts' `cenopts' `wopts' `log' `nolog' ///
		control(`control') tlevel(`tlevel') levels(`levels')         ///
		`gmmopts' `verbose'

	ereturn local tvar `tvar'
	if !`regadj' {
		ereturn local tmodel `tmodel'
		ereturn hidden local tvarlist `tvarlist'
		ereturn hidden local fvtvarlist `fvtvarlist'
		ereturn hidden scalar tconstant = ("`tconstant'"=="")
		if "`tmodel'" == "hetprobit" { 
			ereturn hidden local htvarlist `hvarlist'
			ereturn hidden local fvhtvarlist `fvhvarlist'
		}
	}
	tempname ni
	qui tabulate `tvar' if `touse', matcell(`ni')
	forvalues i=1/`klev' {
		local lev : word `i' of `levels'
		ereturn scalar n`lev' = `ni'[`i',1]
	}
	ereturn scalar control = `control'
	ereturn scalar treated = `tlevel'
	ereturn scalar k_levels = `klev'
	ereturn local tlevels `levels'
	ereturn local stat `stat'
	ereturn scalar k_eq = `keq'

	ereturn local depvar : char _dta[st_t]		// always _t
	ereturn hidden local _depvar : char _dta[st_bt]	// user variable
	ereturn local dead : char _dta[st_d]		// always _d
	ereturn hidden local _dead : char _dta[st_bd]	// user variable

	if "`odist'" != "" {
		ereturn local omodel `odist'
		ereturn hidden local ovarlist `ovarlist'
		ereturn hidden scalar oconstant = ("`oconstant'"=="")
		ereturn hidden local fvovarlist `fvovarlist'
		if "`odist'" != "exponential" {
			ereturn hidden local oshapevlist `oshapevlist'
			ereturn hidden scalar oshapeconst = ///
				("`oshapeconst'"=="")
			ereturn hidden local fvoshapevlist `fvoshapevlist'
		}
	}
	if "`cdist'" != "" {
		ereturn local cmodel `cdist'
		ereturn hidden local cvarlist `cvarlist'
		ereturn hidden scalar cconstant = ("`cconstant'"=="")
		ereturn hidden local fvcvarlist `fvcvarlist'
		if "`cdist'" != "exponential" {
			ereturn hidden scalar cshapeconst = ///
				("`cshapeconst'"=="")
			ereturn hidden local cshapevlist `cshapevlist'
			ereturn hidden local fvcshapevlist `fvcshapevlist'
		}
	}
	if "`wtype'" != "" {
		ereturn local wexp "=`wvar'"
		ereturn local wtype "`wtype'"
	}
	ereturn local marginsnotok _ALL
end

program define ExtractVarlist, sclass
	_on_colon_parse `0'

	local model `s(before)'
	local 0 `s(after)'

	if "`model'" == "treatment" {
		cap noi syntax varlist(numeric fv), [ * ]
	}
	else {
		cap noi syntax [ varlist(numeric fv default=none) ], [ * ]
	}
	local rc = c(rc)
	if `rc' {
		di as txt "{phang}The `model' model is misspecified.{p_end}"
		exit `rc'
	}
	sreturn local varlist `"`varlist'"'
	sreturn local options `"`options'"'
end

program define ParseInitOptions, sclass
	_on_colon_parse `0'
	local cmd `s(before)'
	local 0, `s(after)'

	if "`cmd'"=="ipw" | "`cmd'"=="ipwra" | "`cmd'"=="wra" {
		local psopts  PSTOLerance(real 1e-5) OSample(name)
	}
	syntax, [ iterinit(passthru) from(string) `psopts' * ] 

	if `"`from'"' != "" {
		gettoken from fopt : from, parse(",")
		if "`fopt'" != "" {
			local 0 `fopt'
			cap noi syntax, [ skip copy ]
			local rc = c(rc)
			if `rc' {
				di as txt "{phang}Option {bf:from()} is " ///
				 "incorrectly specified{p_end}"
				exit `rc'
			}
			local k : word count `skip' `copy'
			if `k' == 2 {
				di as err "{p}{bf:from()} suboptions "     ///
				 "{bf:skip} and {bf:copy} cannot both be " ///
				 "specified{p_end}"
				exit 184
			}
		}
		if "`copy'`skip''" != "" {
			sreturn local foption `copy'`skip'
			sreturn local from from(`from',`copy'`skip')
		}
		else {
			sreturn local from from(`from')
		}
		/* fuser indicates user specified from() option		*/
		/* use initialization routines to get a stripped vector	*/
		local initopts fuser
	}
	if "`iterinit'" != "" {
		local 0, `iterinit'
		cap noi syntax, iterinit(integer)
		local rc = c(rc)
		if !`rc' {
			cap assert `iterinit' > 0
			local rc = c(rc)
		}
		if `rc' {
			di as err "{p}invalid {bf:iterinit(`iterinit')} " ///
			 "option; a positive integer is required{p_end}"
			exit 198
		}
	}
	else if "`from'" != "" {
		/* to get stripe					*/
		if "`foption'" == "copy" {
			local iterinit = 0
		}
		else {
			local iterinit = 10
		}
	}
	else {
		/* default						*/
		local iterinit = 100
	}
	local initopts `initopts' iterate(`iterinit')

	if "`pstolerance'" != "" {
		if `pstolerance'<0 | `pstolerance'>=1 {
			di as err "{p}{bf:pstolerance()} must be greater " ///
			 "than or equal to 0 and less than 1{p_end}"
			exit 198
		}
	}
	else {
		/* default						*/
		local pstolerance = 1e-5
	}
	local initopts `initopts' pstol(`pstolerance')

	if "`osample'" != "" {
		cap confirm variable `osample'
		if !c(rc) {
			di as err "{p}invalid option "              ///
			 "{bf:osample({it:newvarname})}; variable " ///
			 "{bf:`osample'} already exists{p_end}"
			exit 110
		}
		local initopts `initopts' osample(`osample')
	}
	sreturn local initopts `"`initopts'"'
	sreturn local rest `"`options'"'
end

exit
