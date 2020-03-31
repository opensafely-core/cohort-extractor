*! version 1.1.1  19feb2019
program define betareg_p
	version 14.0
	if `"`e(cmd)'"'!="betareg" {
		error 301
	}
	syntax [anything] [if] [in] [, SCores *]
	if `"`scores'"'=="" {
		BetaregPNoscore `0'
		exit
	}
	else {
		BetaregPScore `0'
	}
	
end

program define BetaregPScore
	syntax anything [if] [in], SCores
	marksample touse, novarlist
	local y `e(depvar)'
	
	_score_spec `anything' 
	local varlist `s(varlist)'
	local typlist `s(typlist)'
	local nvars: word count `varlist'

	tempvar mu phi dl_dmu dl_dphi dmu_dxb dphi_dzr s1 s2

	PredictCmean double `mu', touse(`touse')
	PredictScale double `phi', touse(`touse')
						// load dmu_dxb
	LoadDmuDxb `dmu_dxb', touse(`touse') mu(`mu')
						// load dphi_dzr
	LoadDphiDzr `dphi_dzr', touse(`touse') phi(`phi')
	
	qui gen double `dl_dmu' = `phi'*(digamma((1-`mu')*`phi')-	  ///
				digamma(`mu'*`phi') +log(`y')-log1m(`y'))

	qui gen double `dl_dphi'= digamma(`phi')-`mu'*digamma(`mu'*`phi') ///
				-(1-`mu')*digamma((1-`mu')*`phi') 	  ///
				+`mu'*log(`y')+(1-`mu')*log1m(`y') if `touse'
	
	qui gen double `s1' = `dl_dmu'*`dmu_dxb' if `touse'
	qui gen double `s2' = `dl_dphi'*`dphi_dzr' if `touse'
	
	forval i=1/`nvars' {
		local typ : word `i' of `typlist'
		local var : word `i' of `varlist'
		local eq  : word `i' of `y' scale
		gen `typ' `var'=`s`i''
		label var `var' "equation-level for [`eq'] score from betareg"
	}
	
end

program define LoadDmuDxb
	syntax newvarname [, mu(string) touse(string)]
	tempvar xb
	qui _predict double `xb' if `touse', xb equation(`e(depvar)') 
	local link `e(link)'
	
	if `"`link'"'=="probit" {
		qui gen double `varlist' = normalden(invnormal(`mu')) ///
			if `touse'  
	}
	else if `"`link'"'=="logit" {
		qui gen double `varlist' = `mu'*(1-`mu') if `touse'
	}
	else if `"`link'"'=="cloglog" {
		qui gen double `varlist' = exp(`xb'-exp(`xb')) if `touse'
	}
	else if `"`link'"'=="loglog" {
		qui gen double `varlist' = exp(-`xb'-exp(-`xb')) if `touse' 
	}

end

program define LoadDphiDzr
	syntax newvarname [,touse(string) phi(string)]
	tempvar zr
	qui _predict double `zr' if `touse', xb equation(scale)
	local slink `e(slink)'

	if `"`slink'"'=="identity" {
		qui gen double `varlist'=1 if `touse' 
	}
	else if `"`slink'"'=="root" {
		qui gen double `varlist'=2*`zr' if `touse'
	}
	else if `"`slink'"'=="log" {
		qui gen double `varlist'=exp(`zr') if `touse'
	}

end

program define BetaregPNoscore
	syntax newvarname [if] [in] [,	/// 
		CMean 			///
		CVARiance 		///
		xb 			///
		XBSCAle 		///
		stdp			///
		d1(passthru)		///
		d2(passthru)		///
	]

	marksample touse, novarlist
	
	local eq1 `e(depvar)'
	local eq2 scale

	local case : word count /// 
		`cmean' `cvariance' `xb' `xbscale' `stdp'
	if `case'>1 {
		di as err "only one {it:statistic} may be specified"
		exit 498
	}

	if `case'==0 {
		local cmean cmean
		di  as txt "(option {bf:cmean} assumed)" 
	}

	local type `cmean' `cvariance' `xb' `xbscale' `stdp'
	if `"`type'"' != "cmean" {
		if `"`d1'"' != "" {
			di as err "option d1() not allowed with option `type'"
			exit 198
		}
		else if `"`d2'"' != "" {
			di as err "option d2() not allowed with option `type'"
			exit 198
		}
	}
	else if `"`d1'"' == "" & `"`d2'"' != "" {
		di as err "option d2() requires option d1()"
		exit 198
	}

	if `"`xb'"'!="" {
					// predict xb
		_predict `typlist' `varlist' if `touse', xb equation(`eq1')
		label var `varlist' "Linear prediction in `e(depvar)' equation"
	}
	else if `"`xbscale'"'!="" {
					// predict xbscale 
		_predict `typlist' `varlist' if `touse', xb equation(`eq2')
		label var `varlist' "Linear prediction in scale equation"
	}
	else if `"`stdp'"'!="" {
					// predict stdp
		_predict `typlist' `varlist' if `touse', stdp equation(`eq1')
		label var `varlist' "S.E. of the linear prediction"
	}
	else if `"`cmean'"'!="" {
					// predict cmean
		PredictCmean  `typlist' `varlist',touse(`touse') `d1' `d2'
		label var `varlist' "Conditional mean of `e(depvar)'"
	}
	else if `"`cvariance'"'!="" {
					// predict cvar 
		PredictCvar `typlist' `varlist', touse(`touse')
		label var `varlist' "Conditional variance of `e(depvar)'"
	}
end

				//-- PredictCmean--//
program define PredictCmean 
	local link `"`e(link)'"'
	if `"`link'"' == "logit" {
		PredictCmLogit `0'
	}
	if `"`link'"' == "probit" {
		PredictCmProbit `0'
	}
	if `"`link'"' == "cloglog" {
		PredictCmCloglog `0'
	}
	if `"`link'"' == "loglog" {
		PredictCmLoglog `0'
	}
end

				//-- PredictCmLogit--//
program define PredictCmLogit 
	syntax newvarname [, touse(string) d1(string) d2(string)]
	local vtyp : copy local typlist
	local varn : copy local varlist
	local dv `"`e(depvar)'"'
	if `"`d1'`d2'"' == "#1#1" {
		tempvar xb
		_predict double `xb' if `touse', xb
		local p `varn'
		local q `xb'
		qui gen `vtyp' `varn' = invlogit(`xb') if `touse'
		qui replace `q' = invlogit(-`xb') if `touse'
		qui replace `varn' = `p'*`q'*(`q'-`p') if `touse'
		label var `varn' "d2 cmean / d xb(`dv') d xb(`dv')"
	}
	else if `"`d1'`d2'"' == "#1" {
		tempvar xb
		_predict double `xb' if `touse', xb
		qui gen `vtyp' `varn' = ///
			invlogit(`xb')*invlogit(-`xb') if `touse'
		label var `varn' "d cmean / d xb(`dv')"
	}
	else if `"`d1'`d2'"' == "" {
		tempvar xb
		_predict double `xb' if `touse', xb
		qui gen `vtyp' `varn' = invlogit(`xb') if `touse'
		label var `varn' "Conditional mean of `dv'"
	}
	else {
		gen `vtyp' `varn' = 0 if `touse'
		if "`d1'" == "#1" | "`d2'" == "#1" {
			label var `varn' "d2 cmean / d xb(`dv') d xb(#2)"
		}
		else {
			label var `varn' "d cmean / d xb(#2)"
		}
	}
end

				//-- PredictCmProbit--//
program define PredictCmProbit 
	syntax newvarname [, touse(string) d1(string) d2(string)]
	local vtyp : copy local typlist
	local varn : copy local varlist
	local dv `"`e(depvar)'"'
	if `"`d1'`d2'"' == "#1#1" {
		tempvar xb
		_predict double `xb' if `touse', xb
		qui gen `vtyp' `varn' = -`xb'*normalden(`xb') if `touse'
		label var `varn' "d2 cmean / d xb(`dv') d xb(`dv')"
	}
	else if `"`d1'`d2'"' == "#1" {
		tempvar xb
		_predict double `xb' if `touse', xb
		qui gen `vtyp' `varn' = normalden(`xb') if `touse'
		label var `varn' "d cmean / d xb(`dv')"
	}
	else if `"`d1'`d2'"' == "" {
		tempvar xb
		_predict double `xb' if `touse', xb
		qui gen `vtyp' `varn' = normal(`xb') if `touse'
		label var `varn' "Conditional mean of `dv'"
	}
	else {
		gen `vtyp' `varn' = 0 if `touse'
		if "`d1'" == "#1" | "`d2'" == "#1" {
			label var `varn' "d2 cmean / d xb(`dv') d xb(#2)"
		}
		else {
			label var `varn' "d cmean / d xb(#2)"
		}
	}
end

				//-- PredictCmCloglog--//
program define PredictCmCloglog 
	syntax newvarname [, touse(string) d1(string) d2(string)]
	local vtyp : copy local typlist
	local varn : copy local varlist
	local dv `"`e(depvar)'"'
	if `"`d1'`d2'"' == "#1#1" {
		tempvar xb
		_predict double `xb' if `touse', xb
		tempvar exb
		qui gen double `exb' = exp(`xb') if `touse'
		qui gen `vtyp' `varn' = exp(`xb'-`exb')*(1-`exb') if `touse'
		label var `varn' "d2 cmean / d xb(`dv') d xb(`dv')"
	}
	else if `"`d1'`d2'"' == "#1" {
		tempvar xb
		_predict double `xb' if `touse', xb
		qui gen `vtyp' `varn' = exp(`xb'-exp(`xb')) if `touse'
		label var `varn' "d cmean / d xb(`dv')"
	}
	else if `"`d1'`d2'"' == "" {
		tempvar xb
		_predict double `xb' if `touse', xb
		qui gen `vtyp' `varn' = -expm1(-exp(`xb')) if `touse'
		label var `varn' "Conditional mean of `dv'"
	}
	else {
		gen `vtyp' `varn' = 0 if `touse'
		if "`d1'" == "#1" | "`d2'" == "#1" {
			label var `varn' "d2 cmean / d xb(`dv') d xb(#2)"
		}
		else {
			label var `varn' "d cmean / d xb(#2)"
		}
	}
end

				//-- PredictCmLoglog--//
program define PredictCmLoglog 
	syntax newvarname [, touse(string) d1(string) d2(string)]
	local vtyp : copy local typlist
	local varn : copy local varlist
	local dv `"`e(depvar)'"'
	if `"`d1'`d2'"' == "#1#1" {
		tempvar xb
		_predict double `xb' if `touse', xb
		tempvar exb
		qui gen double `exb' = exp(-`xb') if `touse'
		qui gen `vtyp' `varn' = exp(-`exb')*`exb'*(`exb'-1) if `touse'
		label var `varn' "d2 cmean / d xb(`dv') d xb(`dv')"
	}
	else if `"`d1'`d2'"' == "#1" {
		tempvar xb
		_predict double `xb' if `touse', xb
		tempvar exb
		qui gen double `exb' = exp(-`xb') if `touse'
		qui gen `vtyp' `varn' = exp(-`exb')*`exb' if `touse'
		label var `varn' "d cmean / d xb(`dv')"
	}
	else if `"`d1'`d2'"' == "" {
		tempvar xb
		_predict double `xb' if `touse', xb
		qui gen `vtyp' `varn' = exp(-exp(-`xb')) if `touse'
		label var `varn' "Conditional mean of `dv'"
	}
	else {
		gen `vtyp' `varn' = 0 if `touse'
		if "`d1'" == "#1" | "`d2'" == "#1" {
			label var `varn' "d2 cmean / d xb(`dv') d xb(#2)"
		}
		else {
			label var `varn' "d cmean / d xb(#2)"
		}
	}
end

				//--predict scale--//
program PredictScale
	syntax newvarname [,touse(string)]
	local slink `e(slink)'
	local eqn scale
	tempvar xbv
	quietly _predict double `xbv' if `touse', xb equation(`eqn')
	if `"`slink'"'=="log" {
		qui gen `typlist' `varlist'=exp(`xbv') if `touse' 
	}
	else if `"`slink'"'=="identity" {
		qui gen `typlist' `varlist'=`xbv' if `touse'
	}
	else if `"`slink'"'=="root" {
		qui gen `typlist' `varlist'= `xbv'^2 if `touse'
	}
end

				//--predict cvar--//
program PredictCvar
	syntax newvarname [,touse(string)] 
	tempvar mu_p phi_p
	PredictCmean `typlist' `mu_p', touse(`touse')
	PredictScale `typlist' `phi_p', touse(`touse')
	qui gen `typlist' `varlist' =`mu_p'*(1-`mu_p')/(1+`phi_p') 
end
