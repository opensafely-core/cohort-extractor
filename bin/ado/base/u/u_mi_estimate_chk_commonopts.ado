*! version 1.0.9  29jan2015
/*
	checks options common to -mi estimate-, -mi estimate using-,
	-mi predict-, -mi predictnl-
*/
program u_mi_estimate_chk_commonopts, sclass
	version 11

	// get command name first
	syntax , [ CMD(string) usingspec * ]

	// get all common opts
	u_mi_estimate_get_commonopts `cmd' "`usingspec'"
	local syntax_opts `s(common_opts)'

	// parse and check common options
	// note:  new display opts must be added to macro 'diopts' below
	syntax , [	MAXM(string)		///
			IMPLIST(numlist)	///
			CMD(string)		///
			`syntax_opts'		/// // mi common opts
			COEFLegend		///
			SELEGEND		///
			*  			/// // other opts
		]
	opts_exclusive "`mcerror' `coeflegend'" 
	opts_exclusive "`mcerror' `selegend'" 
	if ("`implist'"!="") {
		local maxm : list sizeof implist
	}
	else {
		if ("`maxm'"=="") {
			di as err "option maxm() must be specified"
			exit 198
		}
		qui numlist "1/`maxm'"
		local implist `r(numlist)'
		local range range(>=1 <=`maxm')
	}

	//check -estimations()- first (available with using specification)
	if (`"`estimations'"'!="") {
		if ("`nimputations'"!="" | "`imputations'"!="") {
			di as err "{bf:estimations()}, {bf:nimputations()}," ///
				" and {bf:imputations()} cannot be combined"
			exit 198
		}

		local dups: list dups estimations
		if ("`dups'"!="") {
			di as err "{bf:estimations()} must contain "	///
				  "unique elements"
			exit 198
		}
		cap numlist "`estimations'", integer min(2) max(`maxm') /// 
					     range(>=1 <=`maxm')
	        if (_rc==121) {
        	        di as err "{bf:estimations()}:  invalid numlist"
                	exit 121
	        }
        	else if (_rc) {
			if (`maxm'==2) {
				local msg 2
			}
			else {
				local msg "at least 2 and at most `maxm'"
			}
                	di as err as smcl "{p}"
	                di as err "{bf:estimations()} must contain "
        	        di as err "`msg' integer numbers "
                        di as err "between 1 and `maxm'"
                	di as err as smcl "{p_end}"
	                exit _rc
		}
	}

	// check -nimputations()- and -imputations()-
	if ("`nimputations'"=="" & "`imputations'"=="") {
		local imputations `implist'
	}
	else if ("`nimputations'"!="") {
		cap confirm integer number `nimputations'
		if _rc {
			di as err "{bf:nimputations()} must be integer " ///
				  "number between 2 and M=`maxm'"
			exit _rc
		}
		if (`nimputations'<2 | `nimputations'>`maxm') {
			di as err "{bf:nimputations()} must be integer " ///
				  "number between 2 and M=`maxm'"
			exit 198
		}
		if ("`imputations'"!="") {
			di as err "{bf:nimputations()} and "	///
				  "{bf:imputations()} cannot be combined"
			exit 198
		}
		// take the first 'nimputations' imputations
		tokenize `implist'
		forvalues i=1/`nimputations' {
			local imputations `imputations' ``i''
		}
	}
	local dups : list dups imputations
	if ("`dups'"!="") {
		di as err "{bf:imputations()} must contain unique elements"
		exit 198
	}
	cap numlist "`imputations'", integer min(2) max(`maxm') `range'
	if (_rc==121) {
		di as err "{bf:imputations()}:  invalid numlist"
		exit 121
	}
	else if (_rc) {
		if (`maxm'==2) {
			local msg 2
		}
		else {
			local msg at least 2 and at most M=`maxm'
		}
		di as err as smcl "{p}"
		di as err "{bf:imputations()} must contain "
		di as err "`msg' integer numbers "
		if ("`range'"!="") {
			di as err "between 1 and `maxm'"
		}
		di as err as smcl "{p_end}"
		exit _rc
	}
	local imputations `r(numlist)'

	// check if imputations consistent with the saved imputation list
	local bad : list imputations - implist
	if ("`bad'"!="") {
		di as err "{p}"
		di as err "{bf:imputations()} must contain at least 2 "
		di as err "integer numbers from the available list (`implist') "
		di as err "of saved imputation results"
		di as err "{p_end}"
		exit 125
	}

	if ("`usingspec'"!="") {
		// build estimation list
		if ("`estimations'"=="") {
			local M: list sizeof imputations
			tokenize `imputations'
			forvalues i=1/`M' {
				local pos : list posof "``i''" in implist
				local estimations `estimations' `pos'
			}
		}
		if ("`mcerror'"!="" & `:word count `estimations''<3) {
			di as err "Monte Carlo error computation "	///
				  "(option {bf:mcerror}) "		///
				  "requires at least 3 imputations"
			exit 198
		}
	}

	if ("`mcerror'"!="" & `:word count `imputations''<3) {
		di as err "Monte Carlo error computation "	///
			  "(option {bf:mcerror}) "		///
			  "requires at least 3 imputations"
		exit 198
	}

	// check -noi- and -nodots-
	if ("`noisily'"!="" & "`dots'"!="") {
		di as err as smcl "only one of {bf:noisily} or {bf:dots} " ///
				  "is allowed"
		exit 198
	}
	// -citable-, -nocitable-
	if ("`citable'"!="" & "`nocitable'"!="") {
		di as err as smcl "only one of {bf:citable} and "	///
				  "{bf:nocitable} is allowed"
		exit 198
	}
	opts_exclusive "`citable' `coeflegend'"
	opts_exclusive "`citable' `selegend'"
	opts_exclusive "`dftable' `coeflegend'"
	opts_exclusive "`dftable' `selegend'"

	// mixed-effects models
	local is_xtme = inlist("`cmd'","xtmixed","xtmelogit","xtmepoisson")
	local is_meqr = inlist("`cmd'","mixed","meqrlogit","meqrpoisson")
	if `is_xtme'|`is_meqr' {
		if "`estmetric'"!="" & "`variance'`noretable'`nofetable'"!="" {
			di as err "option {bf:estmetric} not allowed with " ///
				"options {bf:nofetable}, {bf:noretable}, "  ///
				"and {bf:variance}"
			exit 198
		}
		if "`dftable'"!="" & "`variance'`noretable'`nofetable'"!="" {
			di as err "option {bf:dftable} not allowed with " ///
				"options {bf:nofetable}, {bf:noretable}, "  ///
				"and {bf:variance}"
			exit 198
		}
		if "`vartable'"!="" & "`variance'`noretable'`nofetable'"!="" {
			di as err "option {bf:vartable} not allowed with " ///
				"options {bf:nofetable}, {bf:noretable}, "  ///
				"and {bf:variance}"
			exit 198
		}
		if ("`dftable'`vartable'"!="" & "`estmetric'"=="") {
			di as txt "note: {bf:dftable} or {bf:vartable} imply {bf:estmetric}"
			local estmetric estmetric
		}
		if `is_meqr' & "`variance'"=="" local stddeviations stddeviations
		local diopts `diopts' `variance' `stddeviations' `noretable'
		local diopts `diopts' `nofetable' `estmetric' `nogroup'
		local cmddiopts `diopts'
	}
	else if (bsubstr("`cmd'",1,2)=="xt") {
		local diopts `diopts' `nogroup'
	}
	if ("`level'"!="") {
		local level level(`level')
	}
	local diopts `diopts' `vartable' `notable' `nocitable' `mcerror'
	local diopts `diopts' `nomcerror' `citable' `dftable'
	local diopts `diopts' `nocoef' `notrcoef' `nowarning' 
	local diopts `diopts' `noheader' `nolegend' `nocmdlegend'
	local diopts `diopts' `post' `coef' `nohr' `level' `nocmdnote'
 
	sret clear
	sret local diopts "`diopts'"
	sret local cmddiopts "`cmddiopts'"
	sret local imputations	"`imputations'"
	sret local estimations	"`estimations'"
end
exit

/* ---------------------------------------------------- common options ---*/
/*			NImputations(string) 	///
			Imputations(string)	///
			NOSMALL 		///
			UFMITest		///
			MCERRor			///
			NOIsily			/// // reporting opts
			DOTS			///
			Level(cilevel)		///
			VARTable		///
			NOVARCoef		///
			NOVARTRansf		///
			DFTable			///
			NOCITable		///
			NOCOEF			///
			NOTRANSF		///
			NOHEADer		///
			NOMIHEADer		///
			DFHEADer		///
			NOLEGend		///
			POST			///
			NOCMDNOTE		/// //undoc.
			NOMCERRor		/// // undoc.
*/

