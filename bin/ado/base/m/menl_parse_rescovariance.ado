*! version 1.0.8  30nov2018

program define menl_parse_rescovariance, sclass
	syntax, [ rescorrelation(string) resvariance(string) ///
		rescovariance(string) ]

	sreturn clear
	if "`rescorrelation'"!="" | "`resvariance'"!="" {
                ParseRescorrelation `rescorrelation'
                local rescor `s(rescor)'        // residual corr structure
                sreturn local cbyvar `s(byvar)' // corr by variable
                sreturn local ctvar `s(tvar)'   // time variable
                sreturn local order `s(order)'  // AR, MA order
		local cgrvar `s(grvar)'		// correlation group var
		local civar `s(ivar)'   	// unstruct corr index variable
		sreturn local cgrvar `cgrvar'
		sreturn local civar `civar'

		/* clear to reuse					*/
		sreturn local byvar
		sreturn local ivar

                ParseResvariance `resvariance'
                local resvar `s(resvar)'         // residual variance structure
                sreturn local vbyvar `s(byvar)'  // var by variable
                sreturn local vpvar `s(varname)' // linear, power, expo variable
                sreturn local varopt `s(varopt)' // residual variance options
		local vgrvar `s(grvar)'		 // variance group var
                local vivar `s(ivar)'    	 // unequal var index variable
		sreturn local vgrvar `vgrvar'
		sreturn local vivar `vivar'

		if "`cgrvar'"!="" & "`vgrvar'"!= "" & "`vgrvar'"!="`cgrvar'" {
			di as err "{p}options " ///
			 "{bf:resvariance(distinct)} and " ///
			 "{bf:rescorrelation(unstructured)} must " ///
			 "specify the same {bf:group()} variable{p_end}"
			exit 198
		}
		if "`civar'"!="" & "`vivar'"!="" & "`civar'"!="`vivar'" { 
			di as err "{p}options " ///
			 "{bf:resvariance(distinct)} and " ///
			 "{bf:rescorrelation(unstructured)} must " ///
			 "specify the same {bf:index()} variable{p_end}"
			exit 198
		}
                local resvaropt `s(resvaropt)'
		exit
        }
	ParseRescovariance `rescovariance'
	/* posts sreturn
	 * s(rescov)	// covariance option
	 * s(rescor)	// residual corr structure
	 * s(cbyvar)	// corr by variable
	 * s(ctvar	// time variable
	 * s(order)	// AR, MA order
	 * s(grvar)	// unstructured covariance group variable

	 * s(resvar)	// residual variance structure
	 * s(vbyvar)	// var by variable
	 * s(vivar)	// unequal var index variable
	 * s(varopt)	// residual variance options
	 * s(rescovopt)	// user residual covariance options		 */

	sreturn local vpvar `s(varname)' // linear, power, expo variable
end

program define ParseRescovariance, sclass
	cap noi syntax [ anything(id="residual covariance structure" ///
		name=rescov) ], [ * ]
	local rc = c(rc)
	if `rc' {
		di as err "(error in option {bf:rescovariance())})"
		exit `rc'
	}
	local covopts `options'

	local 0, `rescov'
	syntax, [ IDentity INDependent ar ma ctar1 EXChangeable UNstructured ///
			BAnded TOeplitz * ]
	
	local which `identity' `independent' `ar' `ma' `ctar1' `exchangeable'
	local which `which' `unstructured' `banded' `toeplitz'
	local k : word count `which'
	if `k' > 1 {
		di as err "{p}invalid {bf:rescovariance()} specification: " ///
		 "only one of {bf:identity}, {bf:independent}, {bf:ar}, "   ///
		 "{bf:ma}, {bf:ctar1}, {bf:exchangeable}, "                 ///
		 "{bf:unstructured}, {bf:banded}, or {bf:toeplitz} can be " ///
		 "specified{p_end}"
		exit 184
	}
	if !`k' {
		if "`options'" != "" {
			gettoken op options : options, bind
			di as err "{p}invalid {bf:rescovariance()} " ///
		 	 "specification: covariance structure {bf:`op'} " ///
			 "not allowed{p_end}"
			exit 198
		}
		local identity identity
		local which identity
	}
	else {
		local which : list retokenize which
	}
	sreturn local rescov `which'
	if "`ar'"!="" | "`ma'"!="" | "`banded'"!="" | "`toeplitz'"!="" {
		local k : word count `options'
		if `k' > 1 {
			/* definitely not the AR/MA/banded order	*/
			di as err "{p}invalid {bf:rescovariance()} " ///
		 	 "specification{p_end}"
			exit 198
		}
		if "`toeplitz'" != ""  {
			ParseToeplitz rescovariance: `options', `covopts'
			sreturn local resvar identity
		}
		else if "`banded'" != ""  {
			ParseBanded rescovariance: `options', `covopts'
			sreturn local resvar distinct
			sreturn local civar `s(ivar)'
			sreturn local ctvar `s(ivar)'
			sreturn local vivar `s(ivar)'
			sreturn local varopt variances
		}
		else {
			ParseARMA rescovariance `ar'`ma' : `options', `covopts'
			sreturn local resvar identity
		}
		local rescovopt `which'
		if (!missing(`s(order)')) {
			local rescovopt `rescovopt' `s(order)'
		}
		if "`banded'" != "" {
			local rescovopt `rescovopt', index(`s(ivar)')
		}
		else {
			local rescovopt `rescovopt', t(`s(tvar)')
		}
		sreturn local rescor `which'
		sreturn local rescov `which'
		sreturn local ctvar `s(tvar)'
		if "`s(byvar)'" != "" {
			sreturn local vbyvar `s(byvar)'
			sreturn local varopt variances
			sreturn local cbyvar `s(byvar)'

			local rescovopt `rescovopt' by(`s(byvar)')
		}
		sreturn local rescovopt `rescovopt'
		exit
	}
	if "`options'" != "" {
		gettoken op options : options, bind
		di as err "{p}invalid {bf:rescovariance(`which')} " ///
	 	 "specification: {bf:`op'} not allowed{p_end}"
		exit 198
	}
	if "`ctar1'" != "" {
		ParseCAR1 rescovariance : `covopts'
		sreturn local resvar identity
		sreturn local rescor ctar1
		sreturn local order = 1 
		sreturn local ctvar `s(tvar)'
		local rescovopt ctar1, t(`s(tvar)')
		if "`s(byvar)'" != "" {
			sreturn local vbyvar `s(byvar)'
			sreturn local varopt variances
			sreturn local cbyvar `s(byvar)'

			local rescovopt `rescovopt' by(`s(byvar)')
		}
		sreturn local rescovopt `rescovopt'
		exit
	}
	if "`identity'" != "" {
		sreturn local resvar identity
		sreturn local rescor identity	// independent

		local rescovopt identity

		ParseByOpt rescovariance(identity): `covopts'
		if "`s(byvar)'" != "" {
			sreturn local vbyvar `s(byvar)'
			sreturn local varopt variances

			local rescovopt `rescovopt', by(`s(byvar)')
		}
		sreturn local rescovopt `rescovopt'
		exit
	}
	if "`independent'" != "" {
		sreturn local resvar distinct	// unequal variances
		sreturn local rescor identity
		local rescovopt independent
		ParseIndependentOpts, `covopts'
		if "`s(ivar)'" != "" {
			sreturn local vivar `s(ivar)'
			sreturn local varopt variances	// no var ratios

			local rescovopt `rescovopt', index(`s(ivar)')
		}
		sreturn local rescovopt `rescovopt'
		exit
	}
	if "`exchangeable'" != "" {
		sreturn local resvar identity
		sreturn local rescor exchangeable
		local rescovopt exchangeable

		ParseExchangeable rescovariance : `covopts'
		local c ,
		if "`s(byvar)'" != "" {
			sreturn local vbyvar `s(byvar)'
			sreturn local cbyvar `s(byvar)'
			sreturn local varopt variances

			local rescovopt `rescovopt'`c' by(`s(byvar)')
			local c
		}
		if "`s(grvar)'" != "" {
			local rescovopt `rescovopt'`c' group(`s(grvar)')
		}
		sreturn local rescovopt `rescovopt'
		exit
	}
	if "`unstructured'" != "" {
		sreturn local resvar distinct	// unequal variances
		sreturn local rescor unstructured
		local rescovopt unstructured

		ParseUnstructuredOpts rescovariance : `covopts'

		sreturn local varopt variances	// no var ratios always
		sreturn local vivar `s(ivar)'
		sreturn local civar `s(ivar)'

		local rescovopt `rescovopt', index(`s(ivar)')

		if "`s(grvar)'" != "" {
			local rescovopt `rescovopt' group(`s(grvar)')
		}
		sreturn local rescovopt `rescovopt'
	}
end

program define ParseRescorrelation, sclass
	cap noi syntax [ anything(id="residual correlation structure" ///
		name=rescor) ], [ * ]
	local rc = c(rc)
	if `rc' {
		di as err "(error in option {bf:rescorrelation())})"
		exit `rc'
	}
	local coropts `options'

	local 0, `rescor'
	syntax, [ IDentity ar ma ctar1 EXChangeable UNstructured ///
			BAnded TOeplitz * ]
	local which `identity' `ar' `ma' `ctar1' `exchangeable' `unstructured'
	local which `which' `banded' `toeplitz'
	local k : word count `which'
	if `k' > 1 {
		di as err "{p}invalid {bf:rescorrelation()} specification: " ///
		 "only one of {bf:identity}, {bf:ar}, {bf:ma}, {bf:ctar1}, " ///
		 "{bf:exchangeable}, {bf:unstructured}, {bf:banded}, or "    ///
		 "{bf:toeplitz} can be specified{p_end}"
		exit 184
	}
	if !`k' {
		if "`options'" != "" {
			gettoken op options : options, bind
			di as err "{p}invalid {bf:rescorrelation()} " ///
		 	 "specification: correlation structure {bf:`op'} " ///
			 "not allowed{p_end}"
			exit 198
		}
		local identity identity
		local which identity
	}
	sreturn local rescor `which'
	if "`ar'"!="" | "`ma'"!="" | "`banded'"!="" | "`toeplitz'"!= "" {
		local k : word count `options'
		if `k' > 1 {
			/* definitely not the AR/MA/banded order	*/
			di as err "{p}invalid {bf:rescorrelation(`which')} " ///
		 	 "specification{p_end}"
			exit 198
		}
		/* options contains the order				*/
		if "`toeplitz'" != "" {
			ParseToeplitz rescorrelation: `options', `coropts'
		}
		else if "`banded'" != "" {
			ParseBanded rescorrelation: `options', `coropts'
		}
		else {
			ParseARMA rescorrelation `ar'`ma' : `options', `coropts'
		}
		local rescoropt `which'
		if (!missing(`s(order)')) {
			local rescoropt `rescoropt' `s(order)'
		}
		if "`banded'" != "" {
			local rescoropt `rescoropt', index(`s(ivar)')
		}
		else {
			local rescoropt `rescoropt', t(`s(tvar)')
		}
		if "`s(byvar)'" != "" {
			local rescoropt `rescoropt' by(`s(byvar)')
		}
		if "`s(grvar)'" != "" {
			local rescoropt `rescoropt' group(`s(grvar)')
		}
		sreturn local rescoropt `rescoropt'
		exit
	}
	if "`options'" != "" {
		gettoken op options : options, bind
		di as err "{p}invalid {bf:rescorrelation()} " ///
	 	 "specification: {bf:`op'} not allowed{p_end}"
		exit 198
	}
	if "`ctar1'" != "" {
		ParseCAR1 rescorrelation : `coropts'

		sreturn local rescor ctar1
		local rescoropt ctar1, t(`s(tvar)')
		if "`s(byvar)'" != "" {
			/* flag to report by(variances) not ratios	*/
			sreturn local varopt variances
			local rescoropt `rescoropt' by(`s(byvar)')
		}
		if "`s(grvar)'" != "" {
			local rescoropt `rescoropt' group(`s(grvar)')
		}
		sreturn local rescoropt `rescoropt'
		exit
	}
	if "`identity'" != "" {
		if "`coropts'" != "" {
			gettoken op coropts : coropts, bind
			di as err "{p}invalid {bf:rescorrelation(`which')} " ///
		 	 "specification: option {bf:`op'} not allowed{p_end}"
			exit 198
		}
		sreturn local rescoropt identity
		exit
	}
	if "`exchangeable'" != "" {
		ParseExchangeable rescorrelation : `coropts'

		sreturn local rescor exchangeable
		local rescoropt exchangeable
		local c ,
		if "`s(byvar)'" != "" {
			local rescoropt `rescoropt'`c' by(`s(byvar)')
			local c
		}
		if "`s(grvar)'" != "" {
			local rescoropt `rescoropt'`c' group(`s(grvar)')
		}
		sreturn local rescoropt `rescoropt'
		exit
	}
	if "`unstructured'" != "" {
		ParseUnstructuredOpts rescorrelation : `coropts'

		sreturn local rescor unstructured
		local rescoropt unstructured, index(`s(ivar)')
		if "`s(grvar)'" != "" {
			local rescoropt `rescoropt' group(`s(grvar)')
		}
		sreturn local rescoropt `rescoropt'
		exit
	}
	if "`options'" != "" {
		gettoken opt options : options, bind
		di as err "{p}invalid {bf:rescorrelation()} specification: " ///
		 "{bf:`opt'} not allowed{p_end}"
		exit 198
	}
end

program define ParseARMA, sclass
	_on_colon_parse `0'
	local wh `s(before)'
	gettoken eoption wh : wh
	local wh : list retokenize wh
	local WH = strupper("`wh'")
	local 0 `s(after)'
	cap noi syntax [ anything(id="`WH' order" name=`wh') ], ///
		t(varname numeric) [ by(varname numeric)        ///
		group(varname numeric) ]
	local rc = c(rc)
	if `rc' {
		di as err "(error in option {bf:`eoption'(`wh')})"
		exit `rc'
	}
	if "``wh''" == "" {
		sreturn local order = 1
	}
	else {
		cap confirm integer number ``wh''
		local rc = c(rc)
		if !`rc' {
			if ``wh'' <= 0 {
				local rc = 198
			}
		}
		if `rc' {
			di as err "{p}invalid "                          ///
			 "{bf:`eoption'(`wh'} {it:#}{bf:)} "             ///
			 "specification: the {bf:`wh'} order must be a " ///
			 "positive integer{p_end}"
			exit 198
		}
		sreturn local order = ``wh''
	}
	sreturn local tvar `t'
	sreturn local byvar `by'
	sreturn local grvar `group'
end

program define ParseToeplitz, sclass
	_on_colon_parse `0'
	local eoption `s(before)'
	local 0 `s(after)'
	cap noi syntax [ anything(id="toeplitz order" name=order) ], ///
		t(varname numeric) [ group(varname numeric) 	     ///
		by(varname numeric) ]
	local rc = c(rc)
	if `rc' {
		di as err "(error in option {bf:`eoption'(toeplitz)})"
		exit `rc'
	}
	if "`order'" == "" {
		sreturn local order .	// full
	}
	else {
		cap confirm integer number `order'
		local rc = c(rc)
		if !`rc' {
			if `order' <= 0 {
				local rc = 198
			}
		}
		if `rc' {
			di as err "{p}invalid "                             ///
			 "{bf:`eoption'(toeplitz} {it:#}{bf:)} "            ///
			 "specification: the {bf:`which'} order must be a " ///
			 "positive integer{p_end}"
			exit 198
		}
		sreturn local order = `order'
	}
	sreturn local tvar `t'
	sreturn local grvar `group'
	sreturn local byvar `by'
end

program define ParseBanded, sclass
	_on_colon_parse `0'
	local eoption `s(before)'
	local 0 `s(after)'
	cap noi syntax [ anything(id="banded order" name=order) ], ///
		index(varname numeric) [ group(varname numeric) ]
	local rc = c(rc)
	if `rc' {
		di as err "(error in option {bf:`eoption'(banded)})"
		exit `rc'
	}
	if "`order'" == "" {
		sreturn local order .	// full
	}
	else {
		cap confirm integer number `order'
		local rc = c(rc)
		if !`rc' {
			if `order' <= 0 {
				local rc = 198
			}
		}
		if `rc' {
			di as err "{p}invalid "                             ///
			 "{bf:`eoption'(banded} {it:#}{bf:)} "              ///
			 "specification: the {bf:`which'} order must be a " ///
			 "positive integer{p_end}"
			exit 198
		}
		sreturn local order = `order'
	}
	sreturn local ivar `index'
	sreturn local grvar `group'
end

program define ParseCAR1, sclass
	_on_colon_parse `0'
	local eoption `s(before)'
	local 0, `s(after)'

	cap noi syntax, t(varname numeric) [ by(varname numeric) ///
			group(varname numeric) ]
	local rc = c(rc)
	if `rc' {
		di as err "(error in option {bf:`eoption'(ctar1)})"
		exit `rc'
	}
	sreturn local tvar `t'
	sreturn local byvar `by'
	sreturn local grvar `group'
	sreturn local order = 1
end

program define ParseExchangeable, sclass
	_on_colon_parse `0'
	local eoption `s(before)'
	local 0, `s(after)'

	cap noi syntax, [ by(varname numeric) group(varname numeric) ]

	local rc = c(rc)
	if `rc' {
		di as err "(error in option {bf:`eoption'(exchangeable)})"
		exit `rc'
	}
	sreturn local byvar `by'
	sreturn local grvar `group'
end

program define ParseResvariance, sclass
	syntax [ anything(id="residual variance structure" name=resvar) ], [ * ]

	if "`resvar'" == "" {
		if "`options'" != "" {
			gettoken opt options : options, bind
			di as err "{p}invalid {bf:resvar} specification: " ///
			 "{bf:`opt'} not allowed{p_end}"
			exit 198
		}
		sreturn local resvar identity
		sreturn local resvaropt identity
		exit
	}
	local resopts: list retokenize options
	local 0, `resvar'
	cap noi syntax, [ IDentity POWer LINear EXPonential DIStinct * ]
	local rc = c(rc)
	if `rc' {
		di as err "(in option resvariance())"
		exit `rc'
	}
	local choice `identity' `power' `linear' `exponential' `distinct'
	local k : word count `choice'
	if `k' > 1 {
		di as err "{p}invalid {bf:resvariance} specification: only " ///
		 "one of {bf:identity}, {bf:linear}, {bf:power}, "           ///
		 "{bf:exponential}, or {bf:distinct} can be specified{p_end}"
		exit 184
	}
	if `k' == 0 {
		if "`options'" != "" {
			gettoken opt options : options, bind
			di as err "{p}invalid {bf:resvariance()} " ///
			 "specification: variance structure {bf:`opt'} not " ///
			 "allowed{p_end}"
			exit 198
		}
		local identity identity
	}
	local varname `options'
	if "`identity'" != "" {
		if "`varname'" != "" {
			di as err "{p}invalid {bf:resvariance(identity)} " ///
			 "specification: {bf:`varname'} not allowed{p_end}"
			exit 198
		}
		if "`resopts'" != "" {
			gettoken opt resopts : resopts, bind
			di as err "{p}invalid {bf:resvariance(identity)} " ///
			 "specification: option {bf:`opt'} not allowed{p_end}"
			exit 198
		}
		local resvaropt identity
		sreturn local resvar identity
		sreturn local resvaropt `resvaropt'
		exit
	}
	if "`power'" != "" {
		if "`varname'" == "" {
			di as err "{p}invalid {bf:resvariance(power)} " ///
			 "specification: {it:varname} or {bf:_yhat} " ///
			 "required{p_end}"
			exit 198
		}
		if "`varname'" != "_yhat" {
			ParseVarVarname power : `varname'
			local varname `s(varname)'
		}
		if "`resopts'" != "" {
			ParsePowerOpts, `resopts'
		}
		local resvaropt power `varname'
		local comma ,
		if "`s(byvar)'" != "" {
			local resvaropt `resvaropt'`comma' strata(`s(byvar)')
			local comma
		}
		if "`s(noconstant)'" != "" {
			local resvaropt `resvaropt'`comma' noconstant
		}
		sreturn local varname `varname'
		sreturn local resvar power
		sreturn local varopt `varname' `s(noconstant)'
		sreturn local resvaropt `resvaropt'
		exit
	}
	if "`linear'" != "" {
		if "`varname'" == "" {
			di as err "{p}invalid {bf:resvariance(linear)} "  ///
			 "specification: {it:varname} required{p_end}"
			exit 198
		}
		ParseVarVarname linear : `varname'
		local varname `s(varname)'

		if "`resopts'" != "" {
			gettoken opt resopts : resopts, bind
			di as err "{p}invalid {bf:resvariance(linear)} " ///
			 "specification: option {bf:`opt'} not allowed{p_end}"
			exit 198
		}
		sreturn local varopt `varname'
		local resvaropt linear `varname'
		sreturn local varname `varname'
		sreturn local resvar linear
		sreturn local resvaropt `resvaropt'
		exit
	}
	if "`exponential'" != "" {
		if "`varname'" == "" {
			di as err "{p}invalid "                          ///
			 "{bf:resvariance(exponential)} specification: " ///
			 "{it:varname} or {bf:_yhat} required{p_end}"
			exit 198
		}
		if "`varname'" != "_yhat" {
			ParseVarVarname exponential : `varname'
			local varname `s(varname)'
		}
		if "`resopts'" != "" {
			ParseByOpt resvariance(exponential) : `resopts'
		}
		local resvaropt exponential `varname'
		if "`s(byvar)'" != "" {
			local resvaropt `resvaropt', strata(`s(byvar)')
		}
		sreturn local varname `varname'
		sreturn local resvar exponential
		sreturn local varopt `varname' 
		sreturn local resvaropt `resvaropt'
		exit
	}
	if "`distinct'" != "" {
		if "`varname'" != "" {
			di as err "{p}invalid {bf:resvariance(distinct)} " ///
			 "specification: {bf:`varname'} not allowed{p_end}"
			exit 198
		}
		ParseDistinctOpts, `resopts'

		sreturn local varopt variances	// no var ratios always
		local resvaropt distinct, index(`s(ivar)')
		if "`s(grvar)'" != "" {
			local resvaropt `resvaropt' group(`s(grvar)')
		}
		sreturn local resvar distinct
		sreturn local resvaropt `resvaropt'
		exit
	}
	if "`options'" != "" {
		gettoken opt options : options, bind
		di as err "{p}invalid {bf:resvariance()} specification: " ///
		 "{bf:`opt'} not allowed{p_end}"
		exit 198
	}
end

program define ParseVarVarname, sclass
	_on_colon_parse `0'
	local which `s(before)'
	local 0 `s(after)'
	cap noi syntax varname
	local rc = c(rc)
	if `rc' {
		di as err "(error in option {bf:resvariance(`which')})"
		exit `rc'
	}
	sreturn local varname `varlist'
end

program define ParseByOpt, sclass
	_on_colon_parse `0'
	local which `s(before)'
	local 0, `s(after)'

	if "`which'" == "resvariance(exponential)" {
		cap noi syntax, [ strata(varname numeric) ]

		local by `strata'
	}
	else {
		cap noi syntax, [ by(varname numeric) ]
	}
	local rc = c(rc)
	if `rc' {
		di as err "(error in option {bf:`which'})"
		exit `rc'
	}
	sreturn local byvar `by'
end

program define ParsePowerOpts, sclass
	cap noi syntax, [ strata(varname numeric) NOCONStant ]
	local rc = c(rc)
	if `rc' {
		di as err "(error in option {bf:resvariance(power)})"
		exit `rc'
	}
	sreturn local byvar `strata'
	sreturn local noconstant `noconstant'
end

program define ParseIndependentOpts, sclass
	cap noi syntax, index(varname numeric) [ VARiances ///
		group(varname numeric) ]
	local rc = c(rc)
	if `rc' {
		di as err "(error in option {bf:rescovariance(independent)})"
		exit `rc'
	}
	sreturn local ivar `index'
	sreturn local varopt `variances'
	sreturn local grvar `group'
end

program define ParseUnstructuredOpts, sclass
	_on_colon_parse `0'
	local eoption `s(before)'
	local 0, `s(after)'
	cap noi syntax, index(varname numeric) [ VARiances ///
		group(varname numeric) ]
	local rc = c(rc)
	if `rc' {
		di as err "(error in option {bf:`eoption'(unstructured)})"
		exit `rc'
	}
	sreturn local ivar `index'
	sreturn local varopt `variances'
	sreturn local grvar `group'
end

program define ParseDistinctOpts, sclass
	cap noi syntax, index(varname numeric) [ group(varname numeric) ///
			VARiances ]
	local rc = c(rc)
	if `rc' {
		di as err "(error in option {bf:resvariance(distinct)})"
		exit `rc'
	}
	if "`index'" != "" {
	}
	sreturn local ivar `index'
	sreturn local varopt `variances'
	sreturn local grvar `group'
end

exit
