*! version 1.1.0  15mar2018
program fracreg, properties(svyb svyj svyr mi bayes) eclass byable(onecall)
	version 14
	
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
        }
	
        `BY' _vce_parserun fracreg, noeqlist jkopts(eclass): `0'
        
	if "`s(exit)'" != "" {
                ereturn local cmdline `"fracreg `0'"'
                exit
        }

        if replay() {
		if `"`e(cmd)'"' != "fracreg" { 
                        error 301
                }
                else if _by() { 
                        error 190 
                }
                else {
                        Replay `0'
                }
                exit
        }
        `vv' ///
        `BY' Estimate `0'
        ereturn local cmdline `"fracreg `0'"'
end

program Estimate, eclass byable(recall)

	local estimator : word 1 of `0'
	local 0 : subinstr local 0 "`estimator'" ""
	CheckEstimator `estimator'
	local estimator `=s(estimator)'
	
	local vv : di "version " string(_caller()) ":"
	version 11
	syntax varlist(numeric ts fv) [if] [in]	///
		[fw pw iw] [,			///
		FROM(string)			///
		NOLOg LOg			///
		noCONstant			/// 
		OFFset(varname numeric)		///
		TECHnique(passthru)		///
		VCE(passthru)			///
		noWARNing			///
		CRITtype(passthru)		///
		SCORE(passthru)			///
		het(string)			///
		DOOPT				/// 
		notable				/// 
		noHeader			///
		NOCOEF				///
		OR				///
		moptobj(passthru)		/// not documented
		*				/// 
	]

	if "`nocoef'" != "" {
		local table notable
		local header noheader
	}

	// check syntax

	_get_diopts diopts options, `options'
	mlopts mlopts, `options' `technique' `vce' `tolerance' `ltolerance' ///
		`log' `nolog'
	local coll `s(collinear)'

	if "`weight'" != "" {
		local wgt "[`weight'`exp']"
	}
	if "`offset'" != "" {
		local offopt "offset(`offset')"
	}

	// mark the estimation sample
	
	marksample touse
	
	if `:length local offset' {
		markout `touse' `offset'
	}
	if `:length local clustvar' {
		markout `touse' `clustvar', strok
	}

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"	
	if `:length local log' {
		local skipline noskipline
	}

	// Checking for properties of depvar 
	
	gettoken lhs rhs : varlist
	_fv_check_depvar `lhs'
	quietly summarize `lhs'
	local notvary = r(sd)

	if `notvary'==0 {
		display as error "outcome variable {bf:`lhs'} does not vary"
		exit 2000
	}
	
	// Checking for fractional depvar
	
	tempvar fraccond
	qui generate `fraccond' = (float(`lhs')<=1)*(float(`lhs')>=0) if ///
				  (`lhs'!=. & `touse')
	qui sum `fraccond'
	local fraccheck = r(mean) 
	quietly summarize `lhs'
	local cuenta3 = r(mean)
	
	if (`fraccheck'!=1) {
		di in red as smcl "invalid outcome variable"
		di in red as smcl "{p 4 4 2}"
		di in red as smcl "Your outcome variable should"  ///
		  " contain values inside the interval [0,1]"
		di in red as smcl "{p_end}"
		exit 2000	
	}
	if (abs(`cuenta3')>1) {
		di in red as smcl "invalid outcome variable"
		di in red as smcl "{p 4 4 2}"
		di in red as smcl "Your outcome variable should"  ///
		  " contain values inside the interval [0,1] and" ///
		di in red as smcl "{p_end}"
		exit 2000	
	}

	_rmcoll `varlist' `wgt' if `touse',	///
	`coll'					///
	`skipline'				///
	`constant'				///
	`offopt'				///
	touse(`touse')				///
	expand	

	// Estimator consistency
	
	if ("`estimator'"=="logit" & "`het'"!="") {
		di as error "option {bf:het()} only valid with {bf:probit}"
		exit 198
	}
	
	if ("`estimator'"=="probit" & "`or'"!="") {
		di as error "option {bf:or} only valid with {bf:logit}"
		exit 198
	}

	// Estimating 
	qui _fractional_estimates `lhs' `wgt' if `touse',	///
	`doopt'							///
	`mlopts'						///
	`crittype'						///
	`score'							///
	estimator(`estimator')					///
	het(`het')						///
	`options' 
	local ll_0 = e(ll)
	_fractional_estimates `lhs' `rhs' `wgt' if `touse',	///
	`doopt'							///
	`mlopts'						///
	`crittype'						///
	`constant'						///
	`score'							///
	`coll'							///
	`constraints'						///
	offset(`offset')					///
	estimator(`estimator')					///
	het(`het')						///
	`options'						///
	llzeropollito(`ll_0')					///
	`moptobj'

	// save a title for -Replay- and the name of this command
		
	ereturn local title "Fractional `estimator' regression"	
	
	ereturn local predict fracreg_p
	ereturn local estat_cmd fracreg_estat
	ereturn local cmd fracreg 
	if "`het'"!="" {
		local estimator hetprobit
	}
	eret local estimator "`estimator'"
	local titles probit 
	if "`estimator'" == "logit"{
		local titles logistic
	}
	if "`estimator'" == "hetprobit" {
		local titles heteroskedastic probit
	}
	ereturn local title "Fractional `titles' regression"	
	
	ereturn hidden scalar noconstant=cond("`constant'" == "noconstant",1,0)
	ereturn hidden scalar consonly = cond("`rhs'" != "",0,1)	
	Replay , `table' `header' `grouped' `diopts' `or'
end

program Replay
	syntax [, notable noHeader NOCOEF GROUPED OR*]
	_get_diopts diopts, `options'
	if "`nocoef'" != "" {
		local table notable
		local header noheader
	}

	if "`or'"!="" {
		_prefix_display, `table' `header' `rules' `title' `diopts' ///
				  eform(Odds Ratio)
	}
	else {
		_prefix_display, `table' `header' `rules' `title' `diopts' 
	}
end

program CheckEstimator, sclass
	args input

	if ("`input'" == "probit") {
		sreturn local estimator "probit"
		exit
	}
	
	if ("`input'" == "logit") {
		sreturn local estimator "logit"
		exit
	}
	
	di as error "{bf:`input'} not a valid estimator"
	exit 198
		
end



exit
