*! version 1.0.3  11apr2019
program dfactor_p, properties(notxb)
	version 11

	if "`e(cmd)'" != "dfactor" {
		di as err "{help dfactor##|_new:dfactor} estimation " ///
		 "results not found"
		exit 301
	}
	syntax anything(name=vlist id="varlist") [if] [in],  [, y     ///
		xbf xb FACtors STates Residuals RSTAndard INnovations ///
		EQuation(string) rmse(string) SMETHod(string) 	      ///
		DYNamic(passthru) * ]

	local which `y' `xb' `xbf' `factors' `residuals' `innovations'
	/* undocumented: let -states- and -rstandard- option pass thru	*/
	/*  to -_sspace_p-						*/
	local which `which' `states' `rstandard'

	if `:word count `which'' > 1 {
		di as err "{p}only one of {bf:factors}, {bf:y}, {bf:xb}, " ///
		 "{bf:xbf}, {bf:residuals}, or {bf:innovations} is "	   ///
		 "allowed{p_end}"
		exit 184
	}
	ParseSmethod, `smethod'
	local how `s(method)'

	if "`which'" == "" {
		if "`how'" == "" {
			di "({txt}option {bf:y} assumed; fitted values)"
		}
		local which y
	}
	if ("`how'"=="") local how onestep

	marksample touse, novarlist
	qui count if `touse'
	if (r(N)==0) error 2000

	local kf = e(k_factor)
	local callss = 1
	local postss = 0

	if "`which'" == "residuals" {
		if "`rmse'"!="" {
			di as err "{p}options {bf:residuals} and " ///
			 "{bf:rmse()} may not be combined{p_end}"
			exit 184
		}
	}
	local sswhich `which'
	if "`which'"=="xb" | "`which'"=="xbf" {
		if "`dynamic'" != "" {
			di as err "{p}options {bf:`which'} and " ///
			 "{bf:dynamic} may not be combined{p_end}"
			exit 184
		}
		Get_DFVars `vlist', eqlist(`e(obser_deps)') eq(`equation')
		local neq = `s(neq)'
		local vindex `s(vindex)'
		local varlist `s(varlist)'
		local eqlist `s(eqlist)'
		local ty `s(ty)'
		forvalues k=1/`=e(k_obser)' {
			tempname stub
			local ssvlist `ssvlist' `stub'
		}
		if "`which'"=="xb" & "`smethod'"!="" {
			di as err "{p}options {bf:xb} and {bf:smethod()} " ///
			 "may not be combined{p_end}"
			exit 184
		}
		else if "`how'" == "filter" {
			di as err "{p}options {bf:xbf} and " ///
			 "{bf:smethod(filter)} may not be combined{p_end}"
			exit 184
		}
		local rest `options'
		if ("`rmse'"!="") local rest `rest' rmse(`rmse')

		Do_XB_F `ssvlist', which(`which') touse(`touse') `rest' 

		if "`which'"=="xbf" & e(k_factor)>0 { 
			/* get the factors using recursion	*/
			forvalues k=1/`kf' {
				tempname stub
				local fvlist `fvlist' `stub'
			}
			dfactor_p double `fvlist' if `touse', factors ///
				smethod(`how')
	
			Do_XB_D `ssvlist', factors(`fvlist') touse(`touse') ///
				how(`how') 
		}
		local callss = 0
		local postss = 1
		local ssty double
		local cplab cplab
	}
	else if "`which'" == "factors" {
		if "`e(model)'"=="SUR" | "`e(model)'"=="VAR" {
			di as err "{p}there are no factors in the " ///
			 "dynamic factor parameterization of the "  ///
			 "`e(model)' model{p_end}"
			exit 321
		}
		Get_DFVars `vlist', eqlist(`e(factor_deps)') eq(`equation')
		local neq = `s(neq)'
		local vindex `s(vindex)'
		local varlist `s(varlist)'
		local eqlist `s(eqlist)'
		local ty `s(ty)'
		forvalues k=1/`=e(k_state)' {
			tempname stub
			local ssvlist `ssvlist' `stub'
		}
		if "`rmse'" != "" {
			_stubstar2names `rmse', nvars(`neq') 
			local rmselist `"`s(varlist)'"'
			local rty : word 1 of `s(typlist)'

			forvalues k=1/`=e(k_state)' {
				tempname stub
				local rlist `rlist' `stub'
			}
			local rmseopt rmse(double `rlist')

			local alllist `"`varlist' `rmselist'"'
			local kall : word count `alllist'
			local alllist : list uniq alllist
			if `:word count `alllist'' != `kall' {
				di as err "{p}duplicate names exist in " ///
				 "the {bf:varlist} and the {bf:rmse()} " ///
				 "option{p_end}"

				exit 198
			}
		}
		local sswhich states
		local ssty double
		local callss = 1
		local postss = 1
	}
	else if "`which'"=="residuals" & e(o_ar_max)>0 {
		if "`e(model)'"=="DFAR" {
			local off = `kf'*e(f_ar_max)
		}
		else if "`e(model)'"=="SFAR" {
			local off = `kf'
		}
		else loca off = 0	// VAR

		Get_DFVars `vlist', eqlist(`e(obser_deps)') eq(`equation') ///
			off(`off')

		local neq = `s(neq)'
		local vindex `s(vindex)'
		local varlist `s(varlist)'
		local eqlist `s(eqlist)'
		local ty `s(ty)'

		local sswhich states
		local ssty double
		local postss = 1
		local callss = 1

		forvalues k=1/`=e(k_state)' {
			tempname stub
			local ssvlist `ssvlist' `stub'
		}
	}
	else {
		Get_DFVars `vlist', eqlist(`e(obser_deps)') eq(`equation')
		local neq = `s(neq)'
		local ssvlist `s(varlist)'
		local eqopt equation(`s(eqlist)')
		local ssty `s(ty)'

		if "`rmse'" != "" {
			if "`which'" == "innovations" {
				di as err "{p}options {bf:innovations} and " ///
				 "{bf:rmse()} may not be combined{p_end}"
				exit 184
			}
			
			local rmseopt rmse(`rmse')
		}
		if "`how'" == "filter" {
			di as err "{p}options {bf:`which'} and " ///
			 "{bf:smethod(filter)} may not be combined{p_end}"
			exit 184
		}
		if ("`which'"=="y") local sswhich xb
		else if ("`which'"=="innovations") {
			if "`dynamic'" != "" {
				di as err "{p}options {bf:innovations} and " ///
				 "{bf:dynamic()} may not be combined{p_end}"
				exit 184
			}
			local sswhich "residuals"
		}
	}
	if `callss' {
		_sspace_p `ssty' `ssvlist' if `touse', `sswhich' `eqopt' ///
			`rmseopt' smethod(`how') `dynamic' `options'

		if "`which'"=="innovations" | "`which'"=="y"{
			local vlist `"`r(vlist)'"'
			foreach v of local vlist {
				local lab : variable label `v'
				local lab : subinstr local lab "`sswhich'" ///
					"`which'" 
				label variable `v' `"`lab'"'
			}
			if "`rmse'" != "" {
				local vlist `"`r(rvlist)'"'
				foreach v of local vlist {
					local lab : variable label `v'
					local lab : subinstr local lab ///
						"`sswhich'" "`which'" 
					label variable `v' `"`lab'"'
				}
			}
		}
		if (!`postss') exit
	}
	/* -factors-, -xbf, -xb-, or -residuals-			*/
	local k = 0
	foreach i of local vindex {
		local vi : word `++k' of `varlist'
		local eq : word `k' of `eqlist'
		local tvi : word `i' of `ssvlist'
		qui gen `ty' `vi' = `tvi'

		if "`xb'`xbf'" == "" {
			if ("`dynamic'"=="") local more `how'
			else local more `dynamic'

			local lab "`which', `eq', `more'"
		}
		else if "`xbf'"!="" {
			local lab "`which' prediction, `eq', `how'"
		}
		else {
			local lab "`which' prediction, `eq'"
		}
		label variable `vi' `"`lab'"'

		if "`rmse'" != "" {
			local vi : word `k' of `rmselist'
			local eq : word `k' of `eqlist'
			local tvi : word `i' of `rlist'
			qui gen `ty' `vi' =  `tvi'
			if "`nolab'" == "" {
				label variable `vi' `"`which' RMSE, `eq', `more'"'
			}
		}
	}
	foreach v of local ssvlist {
		cap drop `v'
	}
	if "`rmse'" != "" {
		foreach v of local rlist {
			cap drop `v'
		}
	}
end

program CheckEQ, sclass
	syntax anything(name=elist id="equation"), eq(string) ///
		[ off(integer 0) ]

	local neq : word count "`eq'"

	foreach ei of local elist {
		local i : list posof "`ei'" in eq
		if `i' == 0 {
			di as err "{p}equation `ei' is not in the model; " 
			if `:word count `eq'' == 1 {
				di as err "only available equation name "  ///
				 "is {bf:`eq'}{p_end}"
			}
			else {
				di as err "available equation names are "  ///
				 "{bf:`eq'}{p_end}"
			}
			exit 322
		}
		local ind `ind' `=`i'+`off''
		local eqlist `eqlist' `ei'
	}
	sreturn local n `:word count `ind''
	sreturn local vindex `ind'
	sreturn local eqlist `eqlist'
end

program Do_XB_F
	syntax newvarlist, which(string) touse(varname) [ * ]
	
	if "`options'" != "" {
		local n : word count `options'
		di as err `"{p}`=plural(`n',"option")' {bf:`options'} may "' ///
		 "not be combined with {bf:`which'}{p_end}"
		exit 184
	}
	cap mat li e(F)
	if _rc {
		foreach v in `varlist' {
			qui gen double `v' = 0 if `touse'
		}
		exit
	}
	tempname F f

	Gammaofdelta `F', which(F)

	forvalues i=1/`=rowsof(`F')' {
		local xb : word `i' of `varlist'
		mat `f' = `F'[`i',1...]
		matrix score double `xb' = `f' if `touse'
		label variable `xb' `"xb prediction"'
	}
end

program Do_XB_D
	syntax varlist, factors(varlist) touse(varname) how(string) 
	
	tempname D d
	local kf : word count `factors'

	Gammaofdelta `D', which(D)

	mat `D' = `D'[1...,1..`kf']
	mat colnames `D' = `factors'
	forvalues i=1/`=rowsof(`D')' {
		tempvar tmp
		local xb : word `i' of `varlist'
		mat `d' = `D'[`i',1...]
		matrix score double `tmp' = `d' if `touse'
		qui replace `xb' = `xb' + `tmp'
		label variable `xb' `"xbf prediction, `eq', `how'"'
		cap drop `tmp'
	}
end

program Get_DFVars, sclass
	syntax anything(name=vlist id="varlist"), eqlist(string) ///
		[ eq(string) off(integer 0) ]

	if "`eq'" != "" {
		CheckEQ `eq', eq(`eqlist') off(`off')
		local vindex `s(vindex)'
		local neq = `s(n)'
		local eqlist0 `s(eqlist)'

		_stubstar2names `vlist', nvars(`neq') 
	}
	else {
		local neq : word count `eqlist'
		cap _stubstar2names `vlist', nvars(`neq')
		if c(rc) {
			_stubstar2names `vlist', nvars(1)
			/* default to first equation			*/
			local neq = 1
			local vindex = `off'+1
			local eqlist0 : word 1 of `eqlist'
		}
		else {
			numlist "`=`off'+1'/`=`off'+`neq''"
			local vindex `r(numlist)'
			local eqlist0 `eqlist'
		}
	}
	local varlist `"`s(varlist)'"'
	local typlist `"`s(typlist)'"'

	sreturn local neq = `neq'
	sreturn local vindex `vindex'
	sreturn local varlist `varlist'
	sreturn local ty `: word 1 of `typlist''
	sreturn local eqlist `eqlist0'
end

program ParseSmethod, sclass
	syntax, [ ONEstep FIlter SMooth * ]

	sreturn clear
	if "`options'" != "" {
		di as err "{p}method(`options') is not allowed; use one of " ///
		 "{bf:onestep}, {bf:filter}, or {bf:smooth}{p_end}"
		exit 198
	}
	local method `onestep' `filter' `smooth'
	local n : word count `method'
	if `n' > 1 {
		di as err "{p}only one of {bf:onestep}, {bf:filter}, or " ///
		 "{bf:smooth} is allowed in option {bf:smethod()}{p_end}"
		exit 184
	}
	if (`n'==1) sreturn local method `method'
end

program Gammaofdelta
	syntax name(name=mat), which(string)

	local ssmats A B C D F G
	local index : list posof "`which'" in ssmats
		
	cap mat `mat' = e(`which')
	local rc = _rc
	if (`rc') return `rc'

	if (`index'==0) exit

	forvalues k=1/`=colsof(e(gamma))' {
		if el(e(gamma),1,`k') == `index' {
			local i = el(e(gamma),2,`k')
			local j = el(e(gamma),3,`k')
			mat `mat'[`i',`j'] = el(e(b),1,`k')
		}
	}
end

exit
