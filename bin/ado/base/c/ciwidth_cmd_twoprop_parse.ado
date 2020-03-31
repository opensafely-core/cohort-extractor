*! version 1.0.0  11jan2019
program ciwidth_cmd_twoprop_parse
        version 16

        syntax [anything] [, test ci * ]
        local type `test' `ci'
        _ciwidth_twoprop_`type'_parse `anything', `options' `type'

end

program _ciwidth_twoprop_ci_parse
	version 16

	syntax [anything(name=args)] , pssobj(string) 	///
				[	CItype(string)	///
					PARAMeter(string)	///
					cluster 	///
					k1(string)      ///
					k2(string)	///
					m1(string)	///
					m2(string)	///
					CVCLuster(string) /// 
					initll(string)	///
					initul(string)	///
					ADDHALF		///
					*		/// 
				]

		
	mata: `pssobj'.getsolvefor("solvefor")
	mata: `pssobj'.getonesided("onesided_num")
	mata: `pssobj'.getsdefdir("dir")

	local len_p = length(`"`parameter'"')
	local len_c = length(`"`citype'"')

	if (`"`parameter'"'=="diff" | ///
	(`"`parameter'"'=="" & `"`citype'"'=="")  ///
| ( `"`parameter'"'==bsubstr("rdiff", 1, `len_p') & `len_p'>1)) {
		if (`"`parameter'"'==bsubstr("rdiff", 1, `len_p')&`len_p'>1) {
			local parameter rdiff
		}
		else local parameter diff
		if (`"`citype'"'=="") {
			local citype wald 
		}
		else if (!inlist(`"`citype'"', "wald", "wilson")) {
			di as err ///
		`"{p}option {bf:citype()}: invalid {bf:`citype'} "' ///
		`" for {bf:parameter(`parameter')}{p_end}"'
			exit 198
		}	
	}	
	else if (`"`parameter'"'==bsubstr("oratio", 1, `len_p') & ///
		`len_p'>1) {
		local parameter oratio
                if (`"`citype'"'=="") {
			local citype lnoratio
		}
		else if (`"`citype'"'==bsubstr("lnoratio",1,`len_c') ///
		 & `len_c'>3 | `"`citype'"'=="logor" ) {
			local citype lnoratio
		}
		else if (`"`citype'"'==bsubstr("oratio",1,`len_c') ///
		 & `len_c'>1 ) {
			local citype oratio
		}
		else if (`"`citype'"'!= "exact") {
			di as err ///
		`"{p}option {bf:citype()}: invalid {bf:`citype'} "' ///
		`" for {bf:`parameter'(`parameter')}{p_end}"'
			exit 198
		}
	}	
	else if ((`"`parameter'"'==bsubstr("rrisk", 1, `len_p')  & ///
		`len_p'>1 ) | `"`parameter'"'== "ratio") {
		if (`"`parameter'"'== "ratio") {
			local parameter ratio
		}
		else local parameter rrisk
		if (`"`citype'"'=="" | (`"`citype'"'==bsubstr("lnrrisk",1,`len_c') ///
		 & `len_c'>3) | `"`citype'"'=="logrr" ) {
			local citype lnrrisk
		}
		else {
			di as err ///
		`"{p}option {bf:citype()}: invalid {bf:`citype'} "' ///
		`" for {bf:parameter(`parameter')}{p_end}"'
			exit 198
		}
	}
	else if (`"`parameter'"'!="") {
		di as err ///
	`"{p}option {bf:parameter()}: invalid parameter {bf:`parameter'}{p_end}"'
		exit 198
	}

	if (`"`parameter'"'=="" & `"`citype'"'!="") {
		if (inlist("`citype'", "wald", "wilson")) {
			local parameter diff
		}
		else if ((`"`citype'"'==bsubstr("lnoratio",1,`len_c') ///
		 & `len_c'>3) | `"`citype'"'=="logrr" |`"`citype'"'=="exact" ///
		 | (`"`citype'"'==bsubstr("oratio",1,`len_c') ///
		 & `len_c'>1)) {
			local parameter oratio
			if ((`"`citype'"'==bsubstr("lnoratio",1,`len_c') ///
		 & `len_c'>3) | `"`citype'"'=="logrr") {
				local citype lnoratio
			}
			else if (`"`citype'"'==bsubstr("oratio",1,`len_c') ///
		 & `len_c'>1) {
				local citype oratio
			}
		}
		else if ((`"`citype'"'==bsubstr("lnrrisk",1,`len_c') ///
		 & `len_c'>3) | `"`citype'"'=="logrr" ) {
			local parameter rrisk
			local citype lnrrisk
		}
		else {
			di as err ///
		`"{p}option {bf:citype()}: invalid citype {bf:`citype'}{p_end}"'
			exit 198
		}
	}
	local 0 , `options' citype(`citype') parameter(`parameter') ///
		`cluster' k1(`k1') k2(`k2') ///
		 m1(`m1') m2(`m2') cvcluster(`cvcluster') ///
		  initll(`initll') initul(`initul') `addhalf'

	local is_cls = 0
	local crd cluster randomized design
	// when it is a crd 
	if ("`cluster'"!="" | `"`k1'`k2'`m1'`m2'"' !="") local is_cls = 1

	if (`"`citype'"'=="exact") {
		if ("`solvefor'"=="n"|"`solvefor'"=="n1" | "`solvefor'"=="n2") {
			di as err "{p}Sample-size computation is not " ///
		"supported for the conditional exact method. Specify " ///
		"sample size in option {bf:n()} to compute " ///
		"confidence-interval width{p_end}"
			exit 198
		}
	}

	//to check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n"| "`solvefor'"=="n1" | "`solvefor'"=="n2") {
		if (`"`citype'"'=="wald") {
			local msg sample size for the {bf:wald} CI
		}
		else if (`"`citype'"'=="oratio" & "`addhalf'"=="") {
			local msg sample size for the citype {bf:citype(oratio)}
	local msg "`msg' without the 1/2 adjustment to cell size"
		}
		else if (`"`citype'"'=="lnoratio" & "`addhalf'"=="" &  ///
		`onesided_num'==1) {
			local msg sample size for a {bf:onesided} CI
			local msg "`msg' of type {bf:citype(lnorato)}"
	local msg "`msg' without the 1/2 adjustment to cell sizes"
		}	
		else if (inlist(`"`parameter'"', "ratio", "rrisk") & ///
				`onesided_num'==1) {
			local msg sample size using {bf:onesided}
			local msg "`msg' {bf:parameter(`parameter'))}"
		}
		else {
			local isiteropts 1
			local star init(string) *
		}	
	}
	else if ("`solvefor'"=="width") {
		if (`"`citype'"'=="exact") {
			local isiteropts 1
			local star init(string) *
		}
		else local msg CI width
	}
	if (!`isiteropts') {
		_pss_error iteroptsnotallowed , ///
			`options' txt(when computing `msg')
	}

	local clu_opt cluster k1(string)  k2(string) KRATio(string) ///
		m1(string) m2(string) MRATio(string) ///
		rho(string) cvcluster(string)
	_pss_syntax SYNOPTS : twoci

	syntax [, 		`SYNOPTS' 	///
				citype(string)	///
				parameter(string)	///
				CONTINuity	///
				addhalf		///
				`clu_opt'	///
				initll(string)	///
				initul(string)	///
				`star'		///
		]

	if ("`init'"!="" & (`"`citype'"'=="exact")) {
		di as err "{p}options {bf:citype(exact)} and " ///
		"{bf:init()} may not be combined; use option " ///
		"{bf:initll()} or {bf:initul()} for the initial value " ///
		"for CI limits{p_end}"
		exit 184
	}
	if ("`initll'"!="" & !(`"`citype'"'=="exact" & ///
	(`onesided_num'==0 | (`onesided_num'==1 & `dir'==0)))){
		di as err "{p}option {bf:initll()} is only allowed for " ///
		"computing a two-sided or a lower one-sided exact CI{p_end}"
		exit 198
	}
	if ("`initul'"!="" & !((`"`citype'"'=="exact") & ///
	(`onesided_num'==0 | (`onesided_num'==1 & `dir'==1)))){
		di as err "{p}option {bf:initul()} is only allowed for " ///
		"computing a two-sided or an upper one-sided exact CI{p_end}"
		exit 198
	}


	if (`isiteropts') {
		local validate = substr("`solvefor'",1,1)
		if ( (`"`citype'"'=="exact") & "`solvefor'"=="width") {
			local validate orc
			_pss_chk_iteropts `validate', `options' ///
			init(`initul') pssobj(`pssobj')
			_pss_chk_iteropts `validate', `options' ///
			init(`initll') pssobj(`pssobj')
		}
		else {
			_pss_chk_iteropts `validate', `options' init(`init') ///
			pssobj(`pssobj')
		}	
		_pss_error optnotallowed `"`s(options)'"'
	}
	if (`"`citype'"'=="exact" & "`nfractional'"!="") {
		di as err "{p}options {bf:citype(exact)} and " ///
		"{bf:nfractional} may not be combined{p_end}"
		exit 184
	}
	if (!inlist("`citype'", "wald", "wilson") & "`continuity'"!="") {
		di as err "{p}options {bf:citype(`citype')} and " ///
		"{bf:continuity} may not be combined; {bf:continuity} " ///
		"is only allowed with {bf:citype(wald)} and " ///
		"{bf:citype(wilson)}{p_end}"
		exit 184
	}
	if (!inlist("`citype'", "oratio", "lnoratio") & "`addhalf'"!="") {
		di as err "{p}options {bf:citype(`citype')} and " ///
		"{bf:addhalf} may not be combined; {bf:addhalf} " ///
		"is only allowed with {bf:citype(oratio)} " ///
		"and {bf:citype(lnoratio)}{p_end}"
		exit 184
	}
	
	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)

	local nargs 0
	if `"`arg1'"'!="" {
		capture numlist "`arg1'", range(> 0 <1)
		if (_rc!=0) {
			di as err "{p}control-group proportion must " ///
			  "be between 0 and 1{p_end}"		
			exit 198
		}
		local ++nargs
	}
	if `"`arg2'"'!="" {
		capture numlist "`arg2'", range(>0 <1)
		if (_rc!=0) {
			di as err "{p}experimental-group proportion must " ///
			  "be between 0 and 1{p_end}"		
			exit 198
		}
		local ++nargs
	}
	if `"`args'"'!="" {
		local ++nargs
	}

	if (`nargs' >2) {
		di as err "{p}too many arguments specified;{p_end}"
                di as err "{p 4 4 2}If you are specifying multiple " ///
		 "values, remember to enclose them in parentheses.{p_end}"
                exit 198
	}
	if (`nargs'==1){
		di as err "experimental-group proportion must be specified"
		exit 198
	}
	if (`nargs'==0){
		di as err "{p}control-group proportion must be specified{p_end}"
		exit 198
	}

	if (`"`width'"'!="" & inlist(`"`parameter'"', "rdiff","diff")) {
		capture numlist "`width'", range(<2)
		if (_rc!=0) {
			di as err "{p}CI width for " ///
		"proportions difference must be less than 2{p_end}"		
			exit 198
		}
	}

	mata: `pssobj'.initonparse("`parameter'", "`citype'", ///
		`"`continuity'"'!="" , `"`addhalf'"'!="", ///
		`"`initll'"', `"`initul'"')
end
