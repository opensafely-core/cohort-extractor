*! version 1.1.0  25aug2015

program define power_cmd_repeated_parse
	version 13
	syntax [anything], [ test * ]

	_power_repeated_test_parse `anything', `options'

	c_local lhs 
	c_local rest `"`s(rhs)'"'
end

program define _power_repeated_test_parse, sclass
	syntax [anything(name=meansspec)], pssobj(string) [ * ]
	local 0, `options'

	mata: st_local("solvefor", `pssobj'.solvefor)
	_pss_syntax SYNOPTS : multitest
	syntax, [ 	`SYNOPTS'		/// 
			VAREFFect(string)	///
			VARBetween(string) 	///
			VARWithin(string)	///
			VARBWithin(string)	///
			NGroups(string) 	///
			NREPeated(string)	///
			VARERRor(string)	///
			CORR(string)		///
			COVMATrix(string)	///
			SHOWMATrices		///
			SHOWMEAns		///
			Factor(string)	* ]

	/* rewrite right hand side, rhs macro; no abbreviations,	*/
	/* otherwise pssobj will ignore pssobj.numopts built in 	*/
	/* call psobj.initonparse() below				*/

	local varb `varbetween'
	local varw `varwithin'
	local varbw `varbwithin'
	local varerr `varerror'

	local kvar = ("`varb'"!="")+("`varw'"!="")+("`varbw'"!="")+ ///
		("`vareffect'"!="")
	local varopt = cond("`vareffect'"!="","vareffect", ///
			cond("`varb'"!="","varbetween",    ///
			cond("`varw'"!="","varwithin",    ///
			cond("`varbw'"!="","varbwithin",""))))
	local nreps = 0
	local ngrps = 0
	if "`nrepeated'" != "" {
		cap numlist `"`nrepeated'"', int range(>=2) max(1)
		if (_rc) {
			di as err "{p}invalid {bf:nrepeated()} "    ///
			 "specification; one integer greater than " ///
			 "1 is required{p_end}" 
			exit 198
		}
		local nreps = `nrepeated'
	}
	
	if (`"`covmatrix'"' != "") {
		if (`"`varerr'`corr'"' != "") {
			if ("`varerr'"=="") local opt corr
			else local opt varerror

			di as err "{p}options {bf:covmatrix()} and " ///
			 "{bf:`opt'()} cannot be specified together{p_end}"
			exit 184
		}
		tempname covspec
		_pss_chk_matspec "{bf:covmatrix()}" cov : `"`covmatrix'"'
		mat `covspec' = r(mat)
		mata: `pssobj'.setmatrix("`covspec'","cov") 

		local nreps0 = colsof(`covspec')	
		if `nreps' & `nreps' != `nreps0' {
			di as err "{p}option {bf:nrepeated(`nreps')}, " ///
			 "but the covariance has dimension `nreps0'{p_end}"
			exit 503
		}
		else local nreps = `nreps0'

		if `nreps' < 2 {
			di as err "{p}covariance matrix must have a " ///
			 "dimension of at least 2{p_end}"
			exit 503
		}
		local verror Cov
	}
	else if (`"`varerr'`corr'"' == "") {
		di as err "{p}option {bf:covmatrix()} or option " ///
		 "{bf:corr()} must be specified{p_end}"
		exit 198
	}
	else {
		local verror Var_e
		if (`"`varerr'"'=="") {
			local varerr 1
		}
		else {
			cap numlist `"`varerr'"', range(> 0)
			if (_rc) {
				di as err "{p}invalid {bf:varerror()} " ///
				 "specification; positive numbers are " ///
				 "required{p_end}"
				exit 198
			}
			local varerr `r(numlist)'
		}
	
		if (`"`corr'"'=="") {
			di as err "{p}option {bf:corr()} must be specified " ///
			 "with {bf:varerror()}{p_end}"
			exit 198
		}
		else {
			cap numlist `"`corr'"', range(>=-1 <=1)
			if (_rc) {
				di as err "{p}invalid {bf:corr()} "         ///
				 "specification; numbers between -1 and 1 " ///
				 "are required{p_end}"
				exit 198
			}
			local corr `r(numlist)'
		}
		local rhs `"`rhs' varerror(`varerr') corr(`corr')"'
	}
	if "`ngroups'" != "" {
		cap numlist `"`ngroups'"', int range(>=1) max(1)
		if (_rc) {
			di as err "{p}invalid {bf:ngroups()} "     ///
			 "specification: one positive integer is " ///
			 "required{p_end}"
			exit 198  
		}
		local ngrps = `ngroups'
	}

	local npergr balanced
	if (`"`meansspec'"' != "") {
		if (`kvar') {
			di as err "{p}options {bf:varbetween()}, "    ///
			 "{bf:varwithin()}, {bf:varbwithin()}, and "  ///
			 "{bf:vareffect()} are not allowed when the " ///
			 "means are specified{p_end}"
			exit 198
		}
		if "`solvefor'" == "esize" {
			di as err "{p}cell means are not allowed when " ///
			 "solving for effect size{p_end}"
			exit 198
		}

		_pss_chk_matspec "{err:group means}" : `"`meansspec'"'
		local ngrps0 = `r(nrows)' // number of Between factor levels
		local nreps0 = `r(ncols)' // number of Within factor levels
		if `ngrps' & `ngrps'!=`ngrps0' {
			di as err "{p}option {bf:ngroups(`ngrps')}, but " ///
			 "`ngrps0' " plural(`ngrps0',"row") " of means "  ///
			 "are specified{p_end}"
			exit 503
		}
		else local ngrps = `ngrps0'

		if `nreps' & `nreps'!=`nreps0' {
			if "`nrepeated'" != "" {
				di as err "{p}option "                      ///
				 "{bf:nrepeated(`nreps')}, but `nreps0' "   ///
				 plural(`nreps0',"column") " of means are " ///
				 "specified{p_end}"
				exit 503
			}
			else {
				di as err "{p}covariance has dimension " ///
				 "`nreps' but `nreps0' "                 ///
				 plural(`nreps0',"column") " of means "  ///
				 "are specified{p_end}"
				exit 503
			}
		}
		else local nreps = `nreps0'

		tempname mspec
		mat `mspec' = r(mat) 
		mata: `pssobj'.setmatrix("`mspec'","means")

		if `nreps'<=1 {
			di as err "{p}invalid number of replications; a "   ///
			 "cell-means table with at least one row (groups) " ///
			 "and two columns (repeated measures) required{p_end}"
			exit 503
		}
		/* allow m#_# output table columns			*/
		local means means
	}
	/* parse/validate -npergroup()- -grweights()- -n#()-	*/
	local options `"`options' n(`n') grweights(`grweights')"'
	local options `"`options' npergroup(`npergroup') `nfractional'"'
	_pss_chk_multisample `ngrps' 1 groups `solvefor' : `"`options'"'
	local options `r(options)'
	if !`ngrps' & `r(nlevels)' {
		local ngrps = `r(nlevels)'
	}
	/* grweights, n#, npergroup				*/
	if ("`r(which)'"!="" & "`r(which)'"!="n") local npergr `r(which)'
	local rhs `"`rhs' `r(nlist)'"'

	if (`"`meansspec'"' == "") {
		// check ngroups()
		if (!`ngrps') {
			di as err "{p}option {bf:ngroups()} is required" _c
			if "`varop'" != "" {
				di as err " with option {bf:`varopt'()}"
			}
			di "{p_end}"
			exit 198
		}
		if (!`nreps') {
			di as err "{p}option {bf:nrepeated()} is required " ///
			 "with option {bf:corr()}{p_end}"
			exit 198
		}
		local rhs `"`rhs' nrepeated(`nreps')"'
	}
	if (`ngrps' < 1) {
		di as err "{p}invalid number of groups; the number of " ///
		 "groups must be greater than or equal to 1{p_end}"
		exit 198
	}
	if (`nreps' <= 1) {
		di as err "{p}invalid number of replications; the number " ///
		 "of replications must be greater than 1{p_end}"
		exit 198
	}
	local rhs `"`rhs' nrepeated(`nreps') ngroups(`ngrps')"'

	if ("`solvefor'"=="n" | "`solvefor'"=="esize") {
		if ("`solvefor'"=="n") local validate N
		else local validate effect

                _pss_chk_iteropts `validate', `options' pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'

	}
	else if ("`options'" != "") {
		_pss_error iteroptsnotallowed , `options' ///
			txt(when computing `solvefor')

		_pss_error optnotallowed "`options'" 
	}
	if `ngrps' == 1 {
		Parse1Group, solvefor(`solvefor') kvar(`kvar') ///
			varopt(`varopt') factor(`factor') `means'
	}
	else {
		ParseKGroups, solvefor(`solvefor') kvar(`kvar') ///
			varopt(`varopt') factor(`factor') `means'
	}
	local factor `s(factor)'
	local rhs `"`rhs' factor(`factor')"'

	if `kvar' {
		/* check varb(), varw(), varbw() and vareffect()	*/
		cap numlist `"`varb'`varw'`varbw'`vareffect'"', range(>0)
		if (_rc) {
			di as err "{p}invalid {bf:`varopt'()} " ///
			 "specification; positive numbers are required{p_end}"
			 exit 198
		}
		local vareffect `r(numlist)'
		local rhs `"`rhs' vareffect(`vareffect')"'
	}

	sreturn local lhs 
	sreturn local rhs `"`rhs'"'

	local show "`showmatrices' `showmeans'"

	/* initialize the number of levels in pss_repeated_test object	*/
	mata: `pssobj'.initonparse((`ngrps',`nreps'),"`factor'","`verror'", ///
			"`npergr'","`means'","`show'")
end

program define ParseFactor, sclass
	_on_colon_parse `0'
	local default `s(before)'
	local 0, `s(after)'

	cap syntax, [ Between Within BWithin ]
	loca rc = c(rc)
	if !`rc' {
		local k : word count `between' `within' `bwithin'
		if !`k' {
			sreturn local factor `default'
			exit
		}
		else if `k'==1 {
			sreturn local factor `between'`within'`bwithin'
			exit
		}
	}
	if "`default'" == "within" {
		di as err "{p}invalid {bf:factor(`factor')}; when there is " ///
		 "only one group only {bf:factor(within)} is allowed{p_end}"
	}
	else {
		di as err "{p}invalid {bf:factor()} specification; must be " ///
		 "one of {bf:between}, {bf:within}, or {bf:bwithin}{p_end}"
	}
	exit 198
end

program define Parse1Group, sclass
	syntax, solvefor(string) kvar(string) [ varopt(string) ///
		factor(string) means ]

	if ("`solvefor'"=="n") local sfor "sample size"
	else local sfor `solvefor'

	local factor0 `factor'
	ParseFactor within: `factor'
	local factor `s(factor)'

	if "`factor'" != "within" {
		di as err "{p}invalid {bf:factor(`factor')}; when "  ///
		 "there is only one group only {bf:factor(within)} " ///
		 "is allowed{p_end}"
		exit 198
	}
	if "`means'" == "means" { 
		/* user input means					*/
		sreturn local factor `factor'
		exit
	}
	if "`solvefor'" != "esize" {
		if !`kvar' & "`factor0'"!="" {
			di as err "{p}option {bf:vareffect()} is required " ///
			 "when specifying {bf:factor(within)} and solving " ///
			 "for `sfor'{p_end}"
			exit 198
		}
		else if !`kvar' {
			di as err "{p}option {bf:varwithin()} or "       ///
			 "{bf:vareffect()} ({bf:factor(within})) is "    ///
			 "required when there is one group and solving " ///
			 "for `sfor'{p_end}"
			exit 198
		}
		else if `kvar'>1 | ("`varopt'"!="vareffect" &  ///
			"`varopt'"!="varwithin") {
			di as err "{p}invalid {bf:`varopt'()}; only "    ///
			 "options {bf:varwithin()} or {bf:vareffect()} " ///
			 "({bf:factor(within)}) can be specified when "  ///
			 "there is one group and solving for `sfor'{p_end}"
			exit 198
		}
		if "`factor0'"!="" & "`varopt'"!="vareffect" {
			/* we could allow this				*/
			di as err "{p}options {bf:varwithin()} and " ///
			 "{bf:factor()} cannot be specified together{p_end}"
			exit 184
		}
	}
	else if `kvar' {
		di as err "{p}option {bf:`varopt'()} is not allowed when " ///
		 "computing effect size{p_end}"
		exit 198
	}
	sreturn local factor `factor'
end

program define ParseKGroups, sclass
	syntax, solvefor(string) kvar(string) [ varopt(string) ///
		factor(string) means ]

	if ("`solvefor'"=="n") local sfor "sample size"
	else local sfor `solvefor'

	local factor0 `factor'
	ParseFactor between: `factor'
	local factor `s(factor)'

	if "`means'" == "means" { 
		/* user input means					*/
		sreturn local factor `factor'
		exit
	}
	if "`solvefor'" != "esize" {
		if (!`kvar') {
			di as err "{p}option {bf:varbetween()}, "        ///
			 "{bf:varwithin()}, {bf:varbwithin()}, or "      ///
			 "{bf:vareffect()} must be specified{p_end}"
			exit 198
		}
		else if (`kvar' > 1) {
			di as err "{p}only one of {bf:varbetween()}, " ///
			 "{bf:varwithin()}, {bf:varbwithin()}, or "    ///
			 "{bf:vareffect()}  can be specified{p_end}"
			exit 198
		}
		if "`varopt'"!="vareffect" & "`factor0'" != "" {
			di as err "{p}options {bf:`varopt'()} and " ///
			 "{bf:factor()} cannot be specified together{p_end}"
			exit 184
		}
		if "`varopt'" != "vareffect" {
			local factor = bsubstr("`varopt'",4,length("`varopt'"))
		}
	}
	else if `kvar' {
		di as err "{p}option {bf:`varopt'()} is not allowed when " ///
		 "computing effect size{p_end}"
		exit 198
	}
	sreturn local factor `factor'
end

exit
