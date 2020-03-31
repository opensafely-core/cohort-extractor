*! version 1.0.0  11jan2019
program ciwidth_cmd_oneprop_parse
        version 16

        syntax [anything] [, test ci * ]
        local type `test' `ci'
        _ciwidth_oneprop_`type'_parse `anything', `options' `type'

end

program _ciwidth_oneprop_ci_parse

	version 16
	syntax [anything(name=args)] , pssobj(string)	///
				[	CItype(string)	///
					CONTINuity	///
					cluster k(string) ///
					m(string) CVCLuster(string) ///
					*		///
				]

	
	mata: `pssobj'.getsolvefor("solvefor")

	local ci confidence limit
	local is_cls 0
	local crd cluster randomized design

	// when it is a crd 
	if ("`cluster'"!="" | `"`k'`m'"' !="") local is_cls 1
					
	if (`"`citype'"'!="") {
		local len = length(`"`citype'"')
		if (`"`citype'"'=="wald") local wald wald
		else if (`is_cls') {
			di as error "only option {bf:citype(wald)} is " ///
			"allowed with `crd'"
			exit 198
		}
		else if (!inlist(`"`citype'"',  ///
		"agresti", "exact", "wilson", "jeffreys")) {
			di as err ///
			`"{p}{bf:citype()}: invalid method {bf:`citype'}; "' ///
			`"need to specify one of {bf:wald}, {bf:wilson}, "' /// 
			`"{bf:agresti}, {bf:jeffreys}, and {bf:exact}{p_end}"'
			exit 198
		}
	}
	else {
		local citype wald
	}
	local 0, `options' `continuity' ///
		`cluster' k(`k') m(`m') cvcluster(`cvcluster')

	// check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n") {
		if (`"`citype'"'=="exact" | `"`citype'"'=="jeffreys" | ///
			(`"`citype'"'=="wilson" & "`continuity'"!="")  ) {
			local isiteropts 1
			local star init(string) *
		}
		else if (`"`citype'"'=="wilson" & "`continuity'"=="") {
			local msg ///
			    "when computing sample size based on `citype' CI"
			local msg `msg' " without continuity correction"    
		}
		else {
			local msg ///
			    "when computing sample size based on `citype' CI"
		}
	}
	else if ("`solvefor'"=="width") {
		local msg "when computing CI width"
	}
	if (!`isiteropts') {
		_pss_error iteroptsnotallowed ,  ///
			`options' txt(`msg')
	}


	local clu_opt cluster k(string) m(string) rho(string) cvcluster(string)
	_pss_syntax SYNOPTS : oneci
	syntax [,	`SYNOPTS' 			///
			CONTINuity			///
			`clu_opt'			///
			`star'				///
		]

	if (!inlist(`"`citype'"', "wald", "wilson") & "`continuity'"!="") {
		di as err "{p}option {bf:continuity} is allowed only with " ///
"Wald CI (default or option {bf:citype(wald)}) or Wilson CI (option " ///
"{bf:citype(wilson)}){p_end}"
		exit 184
	}

	// options not allowed for crd
	if (`is_cls') {
		if (`"`citype'"'!="" & `"`citype'"'!="wald") {
			di as err "{p}{bf:ciwidth oneproportion}: only " /// 
			"{bf:citype(wald)} is allowed for `crd'{p_end}"
                        exit 198
		}
	}

	if (`isiteropts') {
		local validate `solvefor'
	
		_pss_chk_iteropts `validate', `options' init(`init') ///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
	}
			
	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)

	if `"`arg1'"'!="" {
		capture numlist "`arg1'", range(>=0 <=1)
		if (_rc!=0) {
			di as err "{p}sample proportion must be between 0 " ///
			 "and 1{p_end}"
			exit 198
		}
		capture numlist "`arg1'", range(>0 <1)
		if (_rc!=0 & "`citype'"!="exact" ) {
			di as err "{p}{bf:ciwidth oneproportion}: sample " ///
				"proportion can be 0 " ///
			 "or 1 for {bf:citype(exact)} only{p_end}"
			exit 198
		}
	// if not numlist, report an error
		if ("`arg1'"=="0") {
			di as err "{p}only upper confidence limit can be " ///
			"computed for sample proportion of 0; " ///
			"specify {bf:upper}{p_end}"
			exit 198
		}
		else if ( "`arg1'"=="1") {
			di as err "{p}only lower confidence limit can be " ///
			"computed for sample proportion of 1; specify" ///
			" {bf:lower}{p_end}"
			exit 198
		}
	}
	else {
		di as err "{p}sample proportion is required{p_end}"
		exit 198	
	}
	if `"`arg2'"'!="" {
		_pss_error argsonetest 3
	}
	
	if `"`width'"'!="" {
		capture numlist "`width'", range(<1)
		if (_rc!=0) {
			di as err "{p}{bf:ciwidth oneproportion}:" ///
	"confidence-interval width must be less than 1{p_end}"
			exit 198
		}
	}

	mata: `pssobj'.initonparse("`citype'", `"`continuity'"'!="")
end
