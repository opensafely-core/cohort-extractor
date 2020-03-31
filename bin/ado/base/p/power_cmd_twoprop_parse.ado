*! version 1.2.0  11jan2019
program power_cmd_twoprop_parse
	version 13

	syntax [anything] [, test ci * ]
	local type `test' `ci'
	_power_twoprop_`type'_parse `anything', `options'

end

program _power_twoprop_test_parse

	syntax [anything(name=args)] , pssobj(string) 	///
				[	ONESIDed 	///
					test(string)	///
					CHI2		///	// undoc.
					FISHER		///	// undoc.
					LRCHI2		///	// undoc.
					cluster 	///
					k1(string)      ///
					k2(string)	///
					m1(string)	///
					m2(string)	///
					CVCLuster(string) /// 
					*		/// 
				]
	if (`"`test'"'!="") {
		if (`"`test'"'=="lrchi2") local lrchi2 lrchi2
		else if (`"`test'"'=="fisher") local fisher fisher
		else if (`"`test'"'!="chi2") {
			di as err ///
		`"{p}option {bf:test()}: invalid method {bf:`test'}{p_end}"'
			exit 198
		}
	}

	local 0 , `options' `onesided' `fisher' `lrchi2' ///
		`cluster' k1(`k1') k2(`k2') ///
		 m1(`m1') m2(`m2') ///
		 cvcluster(`cvcluster')

	local is_cls = 0
	local crd cluster randomized design
	// when it is a crd 
	if ("`cluster'"!="" | `"`k1'`k2'`m1'`m2'"' !="") local is_cls = 1
		
	mata: `pssobj'.getsolvefor("solvefor")

	if (`"`fisher'"'!="") {
		if ("`solvefor'"!="power") {
			di as err "{p}sample-size and effect-size " ///
	"computations are not supported for the Fisher's" ///
	" exact method. Specify sample size in option {bf:n()} to " ///
	"compute power{p_end}"
			exit 198
		}
		if (`"`lrchi2'"'!="") {
			di as err "{p}only one of {bf:fisher} or " ///
			 "{bf:lrchi2} is allowed{p_end}" 
			exit 198
		}
	}

	//to check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n") {
		if ("`onesided'"=="") {
			local isiteropts 1
			local star init(string) *
		}
		else {
			local msg "sample sizes for a one-sided test"	
		}
	}
	else if ("`solvefor'"=="n1" | "`solvefor'"=="n2") {
		local isiteropts 1
		local star init(string) *
	}
	else if ("`solvefor'"=="k") {
		if ("`onesided'"=="" | `"`m1'`m2'"'=="") {
			local isiteropts 1
			local star init(string) *
		}
		else {
			local msg "numbers of clusters for a one-sided test"	
			local msg "`msg' given cluster sizes"
		}
	}
	else if ("`solvefor'"=="k1"|"`solvefor'"=="k2") {
			local isiteropts 1
			local star init(string) *
	
	}
	else if ("`solvefor'"=="m" | "`solvefor'"=="m1"|"`solvefor'"=="m2") {	
			local isiteropts 1
			local star init(string) *	
	}
	else if ("`solvefor'"=="esize") {
		local isiteropts 1
		local star init(string) *
	}
	else if ("`solvefor'"=="power") {
		local msg power
	}
	if (!`isiteropts') {
		_pss_error iteroptsnotallowed , ///
			`options' txt(when computing `msg')
	}

	local clu_opt cluster k1(string)  k2(string) KRATio(string) ///
		m1(string) m2(string) MRATio(string) ///
		rho(string) cvcluster(string)
	_pss_syntax SYNOPTS : twotest  

	syntax [, 		`SYNOPTS' 	///
				diff(string)	///
				RDiff(string)	///
				ratio(string)	///
				RRisk(string)	///
				ORatio(string)	///
				effect(string)	///
				FISHER		///
				LRCHI2		///
				CONTINuity	///
				`clu_opt'	///
				`star'		///
		]

	// options not allowed for crd
	if (`is_cls') {
		if (`"`continuity'"'!="") {
			di as err "{p}{bf:power twoproportions}: " ///
			"option {bf:continuity} is not allowed for `crd'{p_end}"
			exit 198
		}	
		if(`"`test'"'!="" & `"`test'"'!="chi2") {
			di as err "{p}{bf:power twoproportions}: " ///
				"only option {bf:test(chi2)} is " ///
				"allowed for `crd'{p_end}"
			exit 198
		}
		if(`"`lrchi2'`fisher'"'!="") {
			di as err "{p}{bf:power twoproportions}: " ///
	" option {bf:`lrchi2'`fisher'} or {bf:test(`lrchi2'`fisher')} " ///
			"is not allowed for `crd'{p_end}"
			exit 198
		}
		local test chi2
	}

	if (`isiteropts') {
		local validate = substr("`solvefor'",1,1)
		if ("`validate'"!="n" & "`validate'"!="m" & ///
			"`validate'"!="k") local validate proportion

		_pss_chk_iteropts `validate', `options' init(`init') ///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
	}
	if "`fisher'"!="" & "`nfractional'"!="" {
		di as err "{p}options {bf:fisher} and {bf:nfractional} may " ///
		 "not be combined{p_end}"
		exit 184
	}
	if "`fisher'"!="" & "`continuity'"!="" {
		di as err "{p}options {bf:fisher} and {bf:continuity} may " ///
		 "not be combined{p_end}"
		exit 184
	}
	if "`lrchi2'"!="" & "`continuity'"!="" {
		di as err "{p}options {bf:lrchi2} and {bf:continuity} may " ///
		 "not be combined{p_end}"
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
		local a1list `r(numlist)'
		local ka1 : list sizeof a1list
		local ++nargs
	}

	if `"`arg2'"'!="" {
		capture numlist "`arg2'", range(>0 <1)
		if (_rc!=0) {
			di as err "{p}experimental-group proportion must " ///
			  "be between 0 and 1{p_end}"		
			exit 198
		}
		local a2list `r(numlist)'
		local ka2 : list sizeof a2list
		local ++nargs

		if `ka1'==1 & `ka2'==1 {
			if reldif(`a1list',`a2list') < 1e-10 {
				di as err "{p}control and experimental " ///
				 "proportions are equal; this is not "   ///
				 "allowed{p_end}"
				exit 198
			}
		}
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

	local effopts "`diff'`rdiff'`ratio'`rrisk'`oratio'"
	local effectopts "`diff' `rdiff' `ratio' `rrisk' `oratio'"
	local effmsgand "options {bf:diff()}, {bf:rdiff()}, {bf:ratio()}"
	local effmsgand "`effmsgand', {bf:rrisk()}"
	local effmsgor  "`effmsgand', or {bf:oratio()}"
	local effmsgand "`effmsgand', and {bf:oratio()}"
	
	if ("`solvefor'"=="esize") {
		if (`"`effopts'"'!="") {
			di as err "{p}`effmsgand' not allowed with " ///
			 "effect-size determination{p_end}"
			exit 198
		}
		if (`nargs' > 1) {
			di as err "{p}too many arguments specified with " ///
			 "effect-size determination{p_end}"
			exit 198
		}
		else if (`nargs'==0){
			di as err "{p}control-group proportion must be " ///
	 		 "specified with effect-size determination{p_end}"
			exit 198
		}
		if "`init'"!="" & `ka1'==1 {
			_pss_chk_init "control proportion" "`init'" ///
				"`a1list'" "`direction'"
		}
	} 
	else {
		if (`nargs'==2) {
			if (`"`effopts'"'!="") {
				di as err "{p}`effmsgand' not allowed " ///
				 "when both control- and "              ///
				 "experimental-group proportions are "  ///
				 "specified{p_end}"	
				exit 198
			}
		}
		else if (`nargs'==1) {
			if (`"`effopts'"'=="") {
				di as err "{p}one of `effmsgor' or the " ///
				"experimental-group proportion must be " ///
				"specified{p_end}"
				exit 198
			}
			local nopts 0
			if (`"`diff'"'!="") local ++nopts
 			if (`"`rdiff'"'!="") local ++nopts
 			if (`"`ratio'"'!="") local ++nopts
 			if (`"`rrisk'"'!="") local ++nopts
 			if (`"`oratio'"'!="") local ++nopts

			if (`nopts'>1) {
				di as err "{p} only one of `effmsgor' is " ///
				 "allowed{p_end}"
				exit 198
			}
		}
		else {
			di as err "{p}either two proportions or "   ///
			 "control-group proportion and one of the " ///
			 "`effmsgor' must be specified{p_end}"	
			exit 198
		}
	}

	// not allowed to calculate sample size or effect size using binomial
	if (("`solvefor'"=="n" | "`solvefor'"=="esize") & `"`fisher'"'!="") {
		if ("`solvefor'"=="n") {
			local dimsg "sample"
		}
		else {
			local dimsg "effect"
		}
		di as err "{p}{bf:power twoproportions}: `dimsg'-size "
		di as err "determination is not allowed.{p_end}"
		di as err "{p 4 4 2} " proper("`dimsg'") "-size determination "
		di as err "is not allowed for the Fisher's exact test.  "
                di as err "Power function of the Fisher's exact test is often nonmonotonic; see  {mansection PSS powertwoproportionsRemarksandexamplesex8:{it:Saw-toothed power function}} for details.{p_end}"
		exit 198 	
	}
	if (`"`fisher'"'!="") {
		if (`"`lrchi2'"'!="") {
			di as err "{p}only one of {bf:fisher} or " ///
			 "{bf:lrchi2} is allowed{p_end}" 
			exit 198
		}
	}

	if (`"`diff'"'!= "") {
		cap numlist `"`diff'"', range(>= -1 <= 1)
		if (_rc) {
			di as err "{p}{bf:diff()} must contain values " ///
			 "between -1 and 1{p_end}" 
			exit 198
		}
		local rlist `r(numlist)'
		local k : list sizeof rlist
		if `k'==1 & `ka1'==1 {
			tempname p1

			scalar `p1' = `a1list' + `rlist'
		}
	}
	if (`"`rdiff'"'!= "") {
		cap numlist `"`rdiff'"', range(>= -1 <= 1)
		if (_rc) {
			di as err "{p}{bf:rdiff()} must contain values " ///
			 "between -1 and 1{p_end}" 
			exit 198
		}
		local rdlist `r(numlist)'
		local n_rd : list sizeof rdlist
		if `n_rd'==1 & `ka1'==1 {
			tempname p1
			scalar `p1' = `a1list' + `rdlist'
		}
	}
	
	if (`"`oratio'"'!="") {
		cap numlist `"`oratio'"', range(>0)
		if(_rc) {
			di as err "{p}{bf:oratio()} must contain positive " ///
			 "numbers{p_end}"
			exit 198
		}
		local which oratio
		local orlist `r(numlist)'
		local n_or : list sizeof orlist
		if `n_or'==1 & `ka1'==1 {
			tempname p1 
			scalar `p1' = `a1list'*`orlist'/	///
				(1-`a1list'+`a1list'*`orlist')
		}
	}
	if (`"`ratio'"'!="") {
		cap numlist `"`ratio'"', range(>0)
		if(_rc) {
			di as err "{p}{bf:ratio()} must contain positive " ///
			 "numbers{p_end}"
			exit 198
		}
		local which ratio
		local ratlist `r(numlist)'
		local n_rat : list sizeof ratlist
		if `n_rat'==1 & `ka1'==1 {
			tempname p1 
			scalar `p1' = `a1list'*`ratlist'
		}
	}
	if (`"`rrisk'"'!="") {
		cap numlist `"`rrisk'"', range(>0)
		if(_rc) {
			di as err "{p}{bf:rrisk()} must contain positive " ///
			 "numbers{p_end}"
			exit 198
		}
		local which rrisk
		local rrlist `r(numlist)'
		local n_rr : list sizeof rrlist
		if `n_rr'==1 & `ka1'==1 {
			tempname p1
			scalar `p1' = `a1list'*`rrlist'
		}
	}
	if "`which'" != "" {
		local rlist `r(numlist)'
		local k : list sizeof rlist
		if `k' == 1 {
			if reldif(`rlist',1) < 1e-10 {
				di as err "{p}invalid "               ///
				 "{bf:`which'(`rlist')}; one is not " ///
				 "allowed{p_end}"
				exit 198
			}
		}
	}
	if "`p1'" != "" {
		local extra
		if (`p1'>=1) local extra "greater than or equal to 1"
		if (`p1'<=0) local extra "less than or equal to 0"
		if "`extra'" != "" {
			di as err "{p}the resulting experimental-group" ///
				  " proportion is `extra'; this is not "  ///
				  "allowed{p_end}"
			exit 198
		}
	}

	// handle effect()
	_pss_twoprop_parseeffect effect : `"`effect'"' `nargs' ///
					  "`diff'" "`rdiff'"  ///
					  "`ratio'" "`rrisk'" "`oratio'"
	if ("`effopts'"!="") {
		if (`"`rrisk'"'!="") local effopt rrisk
		else if (`"`rdiff'"'!="") local effopt rdiff
		else if (`"`oratio'"'!="") local effopt oratio
		else if (`"`ratio'"'!="") local effopt ratio
		else local effopt diff
	}
	
	mata: `pssobj'.initonparse("`effopt'","`effect'", ///
				   "`chi2'`fisher'`lrchi2'")
end
