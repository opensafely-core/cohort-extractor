*! version 1.2.6  09oct2019
program ivregress_estat
	local vv : di "version " string(_caller()) ":"
	version 10
	
	if "`e(cmd)'" != "ivregress" {
		exit 301
	}
	
	gettoken sub rest: 0, parse(" ,")

	NoOmit `e(insts)' `e(exogr)'
	local hasfv = `r(hasfv)'
	if `hasfv' {
		if _caller()<11 {
			local vv "version 11: "
		}
	}
	local lsub = length("`sub'")
	if "`sub'" == bsubstr("firststage",1,max(5,`lsub')) {
		`vv' ///
		FirstStage `rest'
	}
	else if "`sub'" == bsubstr("overid",1,max(4,`lsub')) {
		`vv' ///
		OverID `rest'
	}
	else if "`sub'" == bsubstr("endogenous",1,max(5,`lsub')) {
		`vv' ///
		Endog `rest'
	}
	else if "`sub'" == "sbknown" | "`sub'" == "sbsingle" {
		if ("`e(estimator)'"!="2sls") { 
			di as err "{p}{bf:estat `sub'} is only allowed after"
			di as err "{bf:ivregress} estimated with"
			di as err "{bf:2sls}{p_end}"
			exit 198
		}
		if _caller() < 13 {
			di as err "{p}{bf:estat `sub'} not allowed after"
			di as err "{bf:ivregress} run with version < 13{p_end}"
			exit 301
		}
		else `vv' `sub' `rest'
	}
	else estat_default `0'
end

program OverID

	local vv : di "version " string(_caller()) ":"
	syntax , [ FORCEWEIGHTS * ]
	if "`forceweights'" == "" {
		if "`e(wtype)'" != "" & "`e(wtype)'" != "fweight" {
			di as err "not available after estimation with " ///
				"`e(wtype)'s; use {cmd:forceweights} "	///
				"to override"
			exit 498
		}
	}

	`vv' ///
	OverID`e(estimator)', `options'

end

program OverID2sls, rclass

	local vv : di "version " string(_caller()) ":"
	syntax , [ Lags(integer -1) FORCENONROBUST ]
	if "`e(vcetype)'" != "HAC" & `lags' != -1 {
		di as error "lags() only valid with models with HAC VCEs"
		exit 198
	}
	if "`e(vcetype)'" == "HAC" {
		if `lags' == -1 {
			local lags = 1
		}
		else if `lags' < 0 {
			di as error "lags() must be nonnegative"
			exit 198
		}
	}

	// Get info we need from estimation before we clobber e()
	// with temporary regressions
	
	GetNoverid
	local noverid = r(noverid)
	
	tempname b
	mat `b' = e(b)

	local constant "`e(constant)'"

	if "`econstant'" == "hasconstant" {
		local constant
	}

	local allinst `e(insts)'
	local endog `e(instd)'
	local inclinst : colnames `b'
	if "`constant'" == "" {
		local inclinst : subinstr local inclinst "_cons" "", word
	}
	local inclinst : list inclinst - endog
	local exclinst : list allinst - inclinst

	local wtype `e(wtype)'
	local wexp `"`e(wexp)'"'
	local wt [`wtype'`wexp']
	local vcetype "`e(vcetype)'"
	local vce "`e(vce)'"
	tempvar touse
	qui gen byte `touse' = e(sample)
	tempname eqnrss
	sca `eqnrss' = e(rss)
	
	tempvar resids
	qui predict double `resids' if `touse', residual

	tempname userest
	_estimates hold `userest', restore

	tempname basmann sargan
	if "`vcetype'" == "" | ("`forcenonrobust'" != "") {
		`vv' ///
		qui _regress `resids' `allinst' if `touse' `wt' , `constant'
		scalar `sargan' = e(N) * (1 - e(rss)/`eqnrss')
		mat `basmann' = e(b)
		_ms_omit_info `basmann'
		local k = colsof(`basmann') - `r(k_omit)'
		scalar `basmann' = `sargan'* (e(N)- `k') / (e(N) - `sargan')
	}
	else {
		scalar `sargan'  = .
		scalar `basmann' = .
	}
	// Wooldridge's score test
	// NB, if we assume homoskedastic errors, then it's 
	// the same as Sargan's test.  Otherwise, it's not.
	tempname score
	if "`vcetype'" == "" {
		sca `score' = `sargan'
	}
	else if ("`vcetype'" == "Robust" | "`vcetype'" == "HAC") &	///
		"`vce'" != "cluster" {
		// Get projections of endog regressors
		local endoghat
		local i 1
		fvrevar `endog'
		local endog2 `r(varlist)'
		foreach var of local endog2 {
		`vv' ///
		qui _regress `var' `allinst' if `touse' `wt',`constant'
		tempvar endoghat`i'
		qui predict double `endoghat`i''  if `touse'
		local endoghat `endoghat' `endoghat`i''
			local `++i'
		}
		// Now get k_t = u_t * r_t where r_t is residual
		// from regressing each of Q extra instruments
		// on xhat_t, where xhat_t are the projected
		// endog regressors as well as the incl. exog
		// regressors. Which Q excluded exog. vars is 
		// irrelevant -- statistic is the same.
		local khat
		local i 1
		foreach var of local exclinst {
			_ms_parse_parts `var'
			if !`r(omit)' {
			  if "`r(type)'" == "variable" {
				`vv' ///
				qui _regress `var' `endoghat' `inclinst' ///
					if `touse' `wt', `constant'
				tempvar khat`i'
				qui predict double `khat`i'' if `touse', res
				qui replace `khat`i'' = `khat`i'' * `resids'
				local khat `khat' `khat`i''
				if `i' == `noverid' {
					// We have Q overidentifying restr.
					continue, break
				}
			  }
			  else {
				// next line in case of factor variable ops
				tempvar var2
				gen `var2' = `var'
				`vv' ///
				qui _regress `var2' `endoghat' `inclinst' ///
					if `touse' `wt', `constant'
				tempvar khat`i'
				qui predict double `khat`i'' if `touse', res
				qui replace `khat`i'' = `khat`i'' * `resids'
				local khat `khat' `khat`i''
				if `i' == `noverid' {
					// We have Q overidentifying restr.
					continue, break
				}
				drop `var2'
			  }
			  local `++i'
			}
		}
		tempvar one
		qui gen byte `one' = 1 if `touse'
		if "`vcetype'" == "Robust" | 	///
			("`vcetype'" == "HAC" & `lags'==0) {
			`vv' ///
			qui _regress `one' `khat' if `touse' `wt' , nocons
			sca `score' = e(N) - e(rss)
		}
		else {		// must prewhiten k's
			// only weights that can occur here are aweights
			cap tsset, noquery
			qui mvreg `khat' = L(1/`lags').(`khat')		///
				if `touse' `wt', nocons
			local ehat
			forvalues i = 1/`noverid' {
				tempvar ehat`i'
				qui predict double `ehat`i'' , resid eq(#`i')
				local ehat `ehat' `ehat`i''
			}
			`vv' ///
			qui _regress `one' `ehat' if `touse' `wt', nocons
			sca `score' = e(N) - e(rss)
			
		}
	}	
	_estimates unhold `userest'

	if "`vcetype'" == "" | ("`forcenonrobust'" != "") {
		local adds s
	}
	di
	di as text _col(3) "Test`adds' of overidentifying restrictions:"
	di
	if "`vcetype'" == ""  | ("`forcenonrobust'" != "") {
		if "`forcenonrobust'" == "" {
			local scorelab "(score) "
		}
		else {
			local scorelab ""
		}
		di as text _col(3) "Sargan `scorelab'chi2("		///
			as res `noverid' as text ")" _col(26) "="	///
			as res _col(28) %8.0g `sargan'			///
			as text _col(38) "(p = "			///
			as res %5.4f chi2tail(`noverid', `sargan')	///
			as text ")"
		di as text _col(3) "Basmann chi2(" 			///
			as res `noverid' as text ")" _col(26) "="	///
			as res _col(28) %8.0g `basmann'			///
			as text _col(38) "(p = "			///
			as res %5.4f chi2tail(`noverid', `basmann') 	///
			as text ")"
	}
	if "`vcetype'" != "" {
		if "`vce'" == "cluster" {
			di as error _n _col(3) 	///
"robust tests of overidentifying restrictions after 2SLS"
			di as error _col(3)	///
"estimation not available with cluster-robust standard errors"
			if "`forcenonrobust'" == "" {
				exit 498
			}
		}
		else {
			di as text _col(3) "Score chi2(" 		  ///
				as res `noverid' as text ")" _col(26) "=" ///
				as res _col(28) %8.0g `score'		  ///
				as text _col(38) "(p = "		  ///
				as res %5.4f chi2tail(`noverid', `score') ///
				as text ")"
			local adds
			if `lags' > 1 {
				local adds "s"
			}
			if `lags' > 0 {
				di as text _col(5) 	///
				"(Prewhitening performed with `lags' lag`adds')"
			}
			else if `lags' == 0 {
				di as text _col(5) "(No prewhitening performed)"
			}
		}
	}
	if `sargan' < . {
		return scalar sargan = `sargan'
		return scalar p_sargan = chi2tail(`noverid', `sargan')
	}
	if `basmann' < . {
		return scalar basmann = `basmann'
		return scalar p_basmann = chi2tail(`noverid', `basmann')
	}
	if "`vce'" != "cluster" {
		return scalar score = `score'
		return scalar p_score = chi2tail(`noverid', `score')
	}
	return scalar df = `noverid'
	if `lags' > -1 {
		return scalar lags = `lags'
	}
	
end

program OverIDliml, rclass

	syntax , [ FORCENONROBUST ]

	if "`e(estimator)'" != "liml" {
		di as error "invalid estimator"
		exit 301
	}
	
	if "`e(vcetype)'" != "" & "`forcenonrobust'" == "" {
		di as error 	///
"tests not available after LIML estimation with robust VCE" _n	///
"use {cmd:forcenonrobust} to override"
		exit 498
	}
			
	GetNoverid
	local noverid = r(noverid)

	local inst "`e(insts)'"
	NoOmit `inst'
	local nallinst = `r(noomitted)'
	if "`e(constant)'" == "" {
		local `++nallinst'
	}

	tempname arubin basmann
	qui count if e(sample)
	sca `arubin' = r(N)*(e(kappa) - 1)
	sca `basmann' = (e(kappa)-1)*(e(N)-`nallinst') /	///
			`noverid'
	local bman_df_n `noverid'
	local bman_df_d `=e(N) - `nallinst''

	di
	di as text _col(3) "Tests of overidentifying restrictions:"
	di
	di as text _col(3) "Anderson-Rubin chi2(" 		///
		as res `noverid' 				///
		as text") ="					///
		_col(28) as res %8.0g `arubin' 			///
		as text "  (p = "				///
		as res %5.4f chi2tail(`noverid', `arubin')	///
		as text ")"
	di as text _col(3) "Basmann F("				///
		as res `bman_df_n' as text ", "			///
		as res `bman_df_d' as text ")"			///
		_col(26) as text "="				///
		_col(28) as res %8.0g `basmann'			///
		as text "  (p = "				///
		as res %5.4f 					///
		Ftail(`bman_df_n', `bman_df_d', `basmann')	///
		as text ")"
	return scalar ar = `arubin'
	return scalar p_ar = chi2tail(`noverid', `arubin')
	return scalar ar_df = `noverid'
	return scalar basmann = `basmann'
	return scalar p_basmann = Ftail(`bman_df_n', `bman_df_d', `basmann')
	return scalar basmann_df_n = `bman_df_n'
	return scalar basmann_df_d = `bman_df_d'

end

program OverIDgmm, rclass
	
	syntax , [ * ]
	if "`options'" != "" {
		di as error "`options' not allowed after GMM estimation"
		exit 198
	}

	if "`e(estimator)'" != "gmm" {
		di as error "invalid estimator"
		exit 301
	}

	GetNoverid
	local noverid = r(noverid)
		
	// _iv_gmm calculated J stat and returned in e(J)
	di
	di as text _col(3) "Test of overidentifying restriction:"
	di
	di as text _col(3) "Hansen's J chi2("			///
		as res `noverid'				///
		as text ") ="					///
		as res %8.0g e(J)				///
		as text " (p = "				///
		as res %5.4f chi2tail(`noverid', e(J))		///
		as text ")"
	return scalar HansenJ = e(J)
	return scalar p_HansenJ = chi2tail(`noverid', e(J))
	return scalar J_df = `noverid'

end

program GetNoverid, rclass

	tempname b
	mat `b' = e(b)
	local allinst `e(insts)'
	local nallinst : word count `allinst'
	local endog `e(instd)'
	NoOmit `endog'
	local nendog = `r(noomitted)'
	local inclinst : colnames `b'
	if "`constant'" == "" {
		local inclinst : subinstr local inclinst "_cons" "", word
	}
	local inclinst : list inclinst - endog
	local exclinst : list allinst - inclinst
	NoOmit `exclinst'
	local nexclinst = `r(noomitted)'
	local noverid `=`nexclinst' - `nendog''
	if `noverid' <= 0 {
		di as error "no overidentifying restrictions"
		exit 498
	}

	return scalar noverid = `noverid'

end

program FirstStage, rclass sortpreserve

	local vv : di "version " string(_caller()) ":"
	syntax [ , ALL FORCENONROBUST ] 

	local multi 0
	local single 0	
	if `:word count `e(instd)'' > 1 | "`all'" == "all" {
		local multi 1
	}
	if `:word count `e(instd)'' == 1 | "`all'" == "all" {
		local single 1
	}
	if `:word count `e(instd)'' == 0 {
		di as error "model contains no endogenous variables"
		exit 198
	}
	
	local endog `e(instd)'
	local allexog `e(insts)'
	local nendog : word count `endog'
	local nexog : word count `allexog'
	local constant `e(constant)'
	local wtype `e(wtype)'
	local wexp `"`e(wexp)'"'
	local estimator `"`e(estimator)'"'
	local vceclustvar `e(clustvar)'
	local ninst = `nexog'
	if "`constant" == "" {
		local `++ninst'
	}
	local vcespec `e(vce)'
	local vcedisp `e(vcetype)'
	tempvar touse
	gen byte `touse' = e(sample)

	local wt `"[`wtype'`wexp']"'
	
	tempname b
	mat `b' = e(b)
	local inclexog : colnames `b'
	foreach v of local endog {
		local inclexog : subinstr local inclexog "`v'" "", word
	}
	local inclexog : subinstr local inclexog "_cons" "", word
	local exclexog : list allexog - inclexog
	local ninclexog : list sizeof inclexog
	foreach x of local inclexog {
		_ms_parse_parts `x'
		if r(omit) {
			local --ninclexog
		}
	}
	local nexclexog : list sizeof exclexog
	foreach x of local exclexog {
		_ms_parse_parts `x'
		if r(omit) {
			local --nexclexog
		}
	}
	local depvar `e(depvar)'

	tempname userest
	_estimates hold `userest', restore

	tempvar one
	if "`constant'" != "noconstant" {
		gen byte `one' = 1
		local inclexog1 `inclexog' `one'
	}
	if "`constant'" == "hasconstant" {
	noi di "here"
		local constant
	}

	// singleresults has r-sq, adj. r-sq, partial F, F numerator df,
	// F denom df, F pval, lags for HAC vce
	tempname singleresults
	if `single' {
		local Mxinst
		foreach v of local exclexog {
			_ms_parse_parts `v'
			if !`r(omit)' {
			  if "`r(type)'" == "variable" {
			    	// next line in case of time series ops
				local vn : subinstr local v "." "_"
				tempvar Mx`vn'
				`vv' ///
				qui _regress `v' `inclexog' `wt' ///
					if `touse', `constant'
				qui predict double `Mx`vn'', residuals
				local Mxinst `Mxinst' `Mx`vn''
			  }
			  else {
				// next line in case of factor variable ops
				tempvar v2
				gen `v2' = `v'
				tempvar Mx`vn'
				`vv' ///
				qui _regress `v2' `inclexog' `wt' ///
					if `touse', `constant'
				qui predict double `Mx`vn'', residuals
				local Mxinst `Mxinst' `Mx`vn''
				drop `v2'
			  }
			}
		}
		ParseVCE `"`vcespec'"'
		local vcetype `s(vcetype)'
		local vcehac `s(vcehac)'
		local vcehaclag `s(vcehaclag)'
		tempvar Mxy resid
		tempname r2 ar2 F Fn Fd p haclagused
		if "`vcetype'" == "robust" {
			local vceopt "vce(robust)"
		}
		else if "`vcetype'" == "cluster" {
			local vceopt "vce(cluster `vceclustvar')"
		}
		else if "`vcetype'" == "hac" {
			local vceopt "vce(hac `vcehac' `vcehaclag')"
		}
		sca `haclagused' = .
		tempvar endotmp
		foreach v of local endog {
			qui gen double `endotmp' = `v' if `touse'
			`vv' ///
			qui ivregress 2sls `endotmp' `allexog' ///
				[`wtype'`wexp'] ///
				if `touse', `constant' `vceopt' small
			sca `r2' = e(r2)
			sca `ar2' = e(r2_a)
			if "`vcehaclag'" != "" {
				if `vcehaclag' == -1 {
					sca `haclagused' = e(vcelagopt)
				}
				else {
					sca `haclagused' = `vcehaclag'
				}
			}
			qui test `exclexog'
			sca `F' = r(F)
			sca `Fn' = r(df)
			sca `Fd' = r(df_r)
			sca `p' = Ftail(`Fn', `Fd', `F')
			// partial r2
			`vv' ///
			qui _regress `endotmp' `inclexog' `wt' if `touse', ///
				`constant'
			qui predict double `Mxy', residuals
			`vv' ///
			qui _regress `Mxy' `Mxinst' `wt' if `touse', `constant'
			cap drop `Mxy'
			mat `singleresults' = nullmat(`singleresults') \ ///
			(`r2', `ar2', e(r2), `F', `Fn', `Fd', `p',`haclagused')
			drop `endotmp'
		}
	}

	if `multi' {
		tempname results
		// Shea's partial R^2
		local allvhat
		local allresid
		local i 1
		tempvar endotmp
		foreach v of local endog {
			tempvar vhat`i' resid`i'
			qui gen double `endotmp' = `v' if `touse'
			`vv' ///
			qui _regress `endotmp' `allexog' `wt' if `touse', ///
				`constant'
			qui predict double `vhat`i'' if `touse'
			qui predict double `resid`i'' if `touse', residual
			local allvhat `allvhat' `vhat`i''
			local allresid `allresid' `resid`i''
			local `++i'
			drop `endotmp'
		}
		// results has Shea's partial r-sq, adj. partial r-sq.
		tempname x1tilde x1bar
		local i 1
		tempvar endotmp
		foreach v of local endog {
			cap drop `x1tilde' `x1bar'
			local endog2 : subinstr local endog "`v'" "", word
			qui gen double `endotmp' = `v' if `touse'
			`vv' ///
			qui _regress `endotmp' `endog2' ///
				`inclexog' if `touse' ///
				`wt', `constant'
			qui predict double `x1tilde' if `touse', residuals
			local vhatnoti : 				///
				subinstr local allvhat "`vhat`i''" "", word
			`vv' ///
			qui _regress `vhat`i'' `vhatnoti' `inclexog' 	///
				if `touse' `wt', `constant'
			qui predict double `x1bar' if `touse', residuals
			`vv' ///
			qui _regress `x1tilde' `x1bar' if `touse' `wt', ///
				`constant'
			mat `results' = nullmat(`results') \ 		///
				( e(r2), 1-((e(N)-1)/(e(N)-`nexog'))*(1-e(r2)) )
			local `++i'
			drop `endotmp'
		}
	}

	if ("`wtype'" == "" | "`wtype'" == "fweight") &			///
		("`vcedisp'" == "" | "`forcenonrobust'" != "") {
		tempvar normwt 
		if `"`e(wexp)'"' != "" {
			qui gen double `normwt' `e(wexp)' if `touse'
		}
		else {
			qui gen double `normwt' = 1 if `touse'
		}
		summ `normwt' if `touse', mean
		local normN = r(sum)
		// Cragg & Donald / Stock & Yogo generalization of F-test
		tempname mineig mineigcv
		foreach set in depvar endog inclexog1 exclexog {
			fvrevar ``set'', tsonly
			local `set'2 `r(varlist)'
		}
		tempname incl_cols excl_cols
		NoOmit `inclexog1', touse(`touse')
		mat `incl_cols' = r(noomitcols)
		local hasfv = `r(hasfv)'
		NoOmit `exclexog', touse(`touse')
		mat `excl_cols' = r(noomitcols)
		if !`hasfv' {
			local hasfv = `r(hasfv)'
		}
		mata: _iv_craggdonald_wrk("`depvar2'", "`endog2'", 	 ///
					  "`inclexog12'", "`exclexog2'", ///
					  "`touse'", "`normwt'",	 ///
					  `normN', "`mineig'", `hasfv')
		Calcmineigcv `nendog' `nexclexog' `"`estimator'"' `mineigcv'
	}

	_estimates unhold `userest'

	// Output
	tempname mytab
	if `single' {
		di
		di as text _col(3) "First-stage regression summary statistics"
		.`mytab' = ._tab.new, col(6) lmargin(2)
		.`mytab'.width  13   | 12    12   12    12   12
		.`mytab'.pad     .      2     2    3     3    3
		.`mytab'.numfmt  . %5.4f %5.4f %5.4f %8.0g %5.4f
		.`mytab'.titlefmt %12s %8s %8s %9s %11s %10s
		.`mytab'.sep, top
		di as text _col(16) "{c |}" _col(29) "Adjusted" 	///
			   _col(43) "Partial" _c
		if "`vcedisp'" != "" {
			local pos 57
			if "`vcedisp'" == "HAC" {
				local pos 59
			}
			disp as text _col(`pos') "`vcedisp'"
		}
		else {
			di
		}
local ftitle : di "F(" `singleresults'[1,5] "," `singleresults'[1,6] ")"
		.`mytab'.titles "Variable" 				///
				"R-sq." 				///
				"R-sq." 				///
				"R-sq."					///
				"`ftitle'" 				///
				"Prob > F"
		.`mytab'.sep, middle
		local i 1
		foreach v of local endog {
			local vname `=abbrev("`v'", 12)'
			.`mytab'.row "`vname'"				///
				     `singleresults'[`i',1]		///
				     `singleresults'[`i',2]		///
				     `singleresults'[`i',3]		///
				     `singleresults'[`i',4]		///
				     `singleresults'[`i',7]
			local `++i'
		}
		.`mytab'.sep, bottom
		if "`vcetype'" == "hac" {
			local klag = `singleresults'[1,8]
			if "`vcehac'" == "quadraticspectral" {
				local ktyp "Quadratic spectral"
				local klagfmt -6.3f
			}
			else {
				local ktyp `=proper("`vcehac'")'
				local klagfmt -6.0f
			}
			local adds s
			if `klag' == 1 {
				local adds ""
			}
			if (rowsof(`singleresults') == 1) {
				di as text _col(3) "HAC VCE:" _col(18) _c
			}
			else {
				di as text _col(3) "HAC VCEs:" _col(18) _c
			}			
			if `vcehaclag' != -1 {
				di as text "`ktyp' kernel with " 	///
					`:di %`klagfmt' `klag'' 	///
					" lag`adds'"
			} 
			else {
				if (rowsof(`singleresults') == 1) {
					di as text "`ktyp' kernel with " ///
					   `:di %`klagfmt' `klag'' 	 ///
					   " lag`adds'"
				}
				else {
					di as text "`ktyp' kernel with " ///
					   "various lags"
				}
				di as text _col(3) "HAC Lags:"		///
					 _col(18)		 	///
					"Chosen by Newey-West method"
			}
		}
		else if "`vceclustvar'" != "" {
			local adds "s"
			if (rowsof(`singleresults') == 1) {
				local adds ""
			}
			di as text _col(3) 				///
				"(F statistic`adds' adjusted for "	///
				as res `e(N_clust)' 			///
				as text " clusters in `e(clustvar)')"
		}
		di 
	}
	
	if `multi' {
		di
		di as text _col(3) "Shea's partial R-squared"
		.`mytab' = ._tab.new, col(3) lmargin(2)
		.`mytab'.width    13    | 18    18
		.`mytab'.pad       .       5     6
		.`mytab'.numfmt    .   %5.4f  %5.4f
		.`mytab'.titlefmt %12s %15s %15s
		.`mytab'.sep, top
		di as text _col(16) "{c |}"				///
			   _col(22) "Shea's" 				///
			   _col(41) "Shea's"
		.`mytab'.titles "Variable" 				///
				"Partial R-sq."				///
				"Adj. Partial R-sq."
		.`mytab'.sep, middle
		local i 1
		foreach v of local endog {
			local vname `=abbrev("`v'", 12)'
			.`mytab'.row "`vname'"				///
				     `results'[`i',1]			///
				     `results'[`i',2]
			local `++i'
		}
		.`mytab'.sep, bottom
		di
	}

	if ("`wtype'" == "" | "`wtype'" == "fweight") &			///
		("`vcedisp'" == "" | "`forcenonrobust'" != "") {
		di
		di as text _col(3) 					///
			"Minimum eigenvalue statistic = " 		///
			as res %-12.6g `mineig'
		di
		di as text _col(3)  "Critical Values" 			///
			   _col(40) "# of endogenous regressors:" 	///
			   as res %5.0f `nendog'
		di as text _col(3)  "Ho: Instruments are weak"		///
			   _col(40) "# of excluded instruments: " 	///
			   as res %5.0f `nexclexog'
		di as text _col(3)  "{hline 35}{c TT}{hline 33}"
		di as text _col(38) "{c |}"				///
			   _col(43) "5%     10%     20%     30%"
		di as text _col(3)  "2SLS relative bias"		///
			   _col(38) "{c |}" _c
		if `mineigcv'[1,1] < . {
			di as res  _col(41) %5.2f `mineigcv'[1,1]	///
				   _col(49) %5.2f `mineigcv'[1,2]	///
				   _col(57) %5.2f `mineigcv'[1,3]	///
				   _col(65) %5.2f `mineigcv'[1,4]
		}
		else {
			di as text _col(48) "(not available)"
		}
		di as text _col(3)  "{hline 35}{c +}{hline 33}"
		di as text _col(38) "{c |}"				///
			   _col(42) "10%     15%     20%     25%"
		di as text _col(3)  "2SLS Size of nominal 5% Wald test"	///
			   _col(38) "{c |}" _c
		if `mineigcv'[2,1] < . {
			di as res  _col(41) %5.2f `mineigcv'[2,1]	///
				   _col(49) %5.2f `mineigcv'[2,2]	///
				   _col(57) %5.2f `mineigcv'[2,3]	///
				   _col(65) %5.2f `mineigcv'[2,4]
		}
		else {
			di as text _col(48) "(not available)"
		}
		di as text _col(3)  "LIML Size of nominal 5% Wald test"	///
			   _col(38) "{c |}" _c
		if `mineigcv'[2,1] < . {
			di as res  _col(41) %5.2f `mineigcv'[3,1]	///
				   _col(49) %5.2f `mineigcv'[3,2]	///
				   _col(57) %5.2f `mineigcv'[3,3]	///
				   _col(65) %5.2f `mineigcv'[3,4]
		}
		else {
			di as text _col(48) "(not available)"
		}
		di as text _col(3)  "{hline 35}{c BT}{hline 33}"
		di
	}
	if `single' {
		return matrix singleresults = `singleresults'
	}
	if `multi' {
		return matrix multiresults = `results'
	}
	if ("`wtype'" == "" | "`wtype'" == "fweight") &		///
		("`vcedisp'" == "" | "`forcenonrobust'" != "") {
		return scalar mineig = `mineig'
		return matrix mineigcv = `mineigcv'
	}
	
end

program Endog

	local vv : di "version " string(_caller()) ":"
	syntax [anything] , [ FORCEWEIGHTS * ]
	if "`forceweights'" == "" {
		if "`e(wtype)'" != "" & "`e(wtype)'" != "fweight" {
			di as err "not available after estimation with " ///
				"`e(wtype)'s; use {cmd:forceweights} "	///
				"to override"
			exit 498
		}
	}

	if "`e(estimator)'" == "2sls" {
		`vv' ///
		Endog2sls `anything', `options'
	}
	else if "`e(estimator)'" == "gmm" {
		`vv' ///
		Endoggmm `anything', `options'
	}
	else {
		di as error "not available after " _c
		di in smcl `"{cmd:`=upper("`e(estimator)'")'}"' _c
		di as error " estimator"
		exit 321
	}

end

program Endog2sls, rclass

	local vv : di "version " string(_caller()) ":"
	syntax [varlist(numeric default=none)] , [ FORCENONROBUST 	///
		FORCEWEIGHTS Lags(integer -1) 				///
		DOALLTESTS ]  /* undocumented, for certification script */
	
	if "`e(vcetype)'" != "HAC" & `lags' != -1 {
		di as error "lags() only valid with models with HAC VCEs"
		exit 198
	}
	if "`e(vcetype)'" == "HAC" {
		if `lags' == -1 {
			local lags = 1
		}
		else if `lags' < 1 {
			di as error "lags() must be positive"
			exit 198
		}
	}

	local test `varlist'
	
	local depvar `e(depvar)'
	local exog `e(exogr)'
	local inst `e(insts)'
	local endog `e(instd)'
	local N = e(N)
	local k = `=e(df_m) + ("`e(constant)'"=="")'

	if "`test'" == "" {
		local test `endog'
	}
		
	local leftover : list test - endog
	if "`leftover'" != "" {
		di as error "`leftover' not endogenous in original model"
		exit 498
	}
	
	local exogeff  `exog' `test'
	local endogeff : list endog - test
	local addlinst : list inst - exog

	if "`e(vce)'" != "unadjusted" & "`endogeff'" != ""  	///
		& "`forcenonrobust'" == "" {
		di as err "cannot test a subset of endogenous regressors if a"
		di as err "robust, cluster, or HAC VCE was used at estimation"
		exit 498
	}

	if "`e(constant)'" != "" {
		local nocons "noconstant"
	}
	local wtype `e(wtype)'
	local wexp `"`e(wexp)'"'
	if "`wtype'" != "" {
		local wt [`wtype'`wexp']
	}
	local vcetype "`e(vcetype)'"
	tempvar touse
	gen byte `touse' = e(sample)

	if "`e(vce)'" == "unadjusted" | "`forcenonrobust'" != "" {
		local doDurbWu "yes"
	}
	if "`e(vce)'" == "robust" & "`endogeff'" == "" {
		local doRobReg "yes"
		local doRobWool "yes"
	}
	if "`e(vce)'" == "cluster" & "`endogeff'" == "" {
		local doRobReg "yes"
	}
	if "`e(vcetype)'" == "HAC" & "`endogeff'" == "" {
		local doAcReg "yes"
		local doAcWool "yes"
	}
	
	if "`doalltests'" != "" {
		local doRobReg "yes"
		local doRobWool "yes"
		local doDurbWu "yes"
	}
			
	// hold onto -ivregress- results
	tempname hold
	tempname durbin wu wool robwool acwool regF regFn regFd
	
	local df : list sizeof test

quietly {

	if "`doDurbWu'" == "yes" {
		// get consistent model residuals
		tempvar uc
		predict double `uc' if `touse', residuals
		_estimates hold `hold'
	
		// get efficient model residuals
		if "`endogeff'" == "" {
			`vv' ///
			_regress `depvar' `exogeff' `wt' if `touse', `nocons'
		}
		else {
			`vv' ///
			 ivregress 2sls `depvar' `exogeff' 		///
				(`endogeff' = `addlinst') 		///
				`wt' if `touse', `nocons'
		}
		tempvar ue
		predict double `ue' if `touse', residuals
		// also get unrestricted SSR
		tempname USSR
		sca `USSR' = e(rss)

		// reg ue on list of inst in efficient model
		`vv' ///
		_regress `ue' `exogeff' `addlinst' `wt' if `touse', `nocons'
		tempname uePue
		sca `uePue' = e(mss)
	
		// reg uc on list of inst in consistent model
		`vv' ///
		_regress `uc' `exog' `addlinst' `wt' if `touse', `nocons'
		tempname ucPuc
		sca `ucPuc' = e(mss)

		sca `durbin' = (`uePue' - `ucPuc') / (`USSR' / `N')
		local dfFdenom = `N' - `k' - `df'
		sca `wu' = (`uePue' - `ucPuc') / `df' /			///
			((`USSR' - (`uePue' - `ucPuc')) / `dfFdenom')
		_estimates unhold `hold'
		
		return scalar durbin = `durbin'
		return scalar p_durbin = chi2tail(`df', `durbin')
		return scalar wu = `wu'
		return scalar p_wu = Ftail(`df', `dfFdenom', `wu')
		return scalar wudf_r = `dfFdenom'
	}
	if "`doRobWool'`doAcWool'" != "" {
		_estimates hold `hold'
		// get uhat
		tempvar uhat
		`vv' ///
		_regress `depvar' `exog' `endog' `wt' if `touse', `nocons'
		predict double `uhat', residuals
		// get x2hat
		local i 1
		if "`x2hat'" == "" {	// don't have fitted endog yet
			foreach var of local endog {
				tempvar endotmp
				qui gen double `endotmp' = `var' if `touse'
				tempvar endhat`i'
				`vv' ///
				_regress `endotmp' `exog' `addlinst'	///
					`wt' if `touse', `nocons'
				predict double `endhat`i''
				local x2hat `x2hat' `endhat`i''
				local `++i'
				drop `endotmp'
			}
		}
		local i 1
		local rhat
		foreach var of varlist `x2hat' {
			tempvar rhat`i'
			`vv' ///
			_regress `var' `exog' `endog'	///
				`wt' if `touse', `nocons'
			predict double `rhat`i'', residuals
			replace `rhat`i'' = `rhat`i''*`uhat'
			local rhat `rhat' `rhat`i''
		}
		tempvar one
		gen byte `one' = 1
		if "`doRobWool'" == "yes" {
			`vv' ///
			_regress `one' `rhat' `wt' if `touse', nocons
			sca `robwool' = e(N) - e(rss)
			return scalar r_score = `robwool'
			return scalar p_r_score = chi2tail(`df', `robwool')
		}
		if "`doAcWool'" == "yes" {	// must prewhiten rhat's
			cap tsset, noquery
			mvreg `rhat' = L(1/`lags').(`rhat')	///
				`wt' if `touse', nocons
			local i 1
			local ehat
			foreach var of varlist `rhat' {
				tempvar ehat`i'
				predict double `ehat`i'', residuals eq(#`i')
				local ehat `ehat' `ehat`i''
				local `++i'
			}
			`vv' ///
			_regress `one' `ehat' if `touse' `wt', nocons
			sca `acwool' = e(N) - e(rss)
			return scalar hac_score = `acwool'
			return scalar p_hac_score = chi2tail(`df', `acwool')
			return scalar lags = `lags'
		}	
		_estimates unhold `hold'
	}
	if "`doReg'`doRobReg'`doAcReg'" != "" {
		if "`doRobReg'" == "yes" {
			if "`e(clustvar)'" != "" {
				local vceopt "vce(cluster `e(clustvar)')"
			}
			else if "`e(vce)'" == "robust" {
				local vceopt "vce(robust)"
			}
		}
		else if "`doAcReg'" == "yes" {
			ParseVCE `"`e(vce)'"'
			local kernel `s(vcehac)'
			local klags `s(vcehaclag)'
			if `s(vcehaclag)' == -1 {
				local vceopt "vce(hac `kernel' opt)"
			}
			else {
				local vceopt /*
					*/ "vce(hac `kernel' `klags')"
			}
		}
		_estimates hold `hold'
		if "`x2hat'" == "" {	// don't have fitted endog yet --
					// because we didn't do score test
			local i 1
			foreach var of local test {
				tempvar endotmp
				qui gen double `endotmp' = `var' if `touse'
				tempvar testhat`i'
				`vv' ///
				_regress `endotmp' `exog' `addlinst'	///
					`wt' if `touse', `nocons'
				predict double `testhat`i''
				local x2hat `x2hat' `testhat`i''
			}
		}
		if "`endogeff'" != "" {
			local endterm (`endogeff' = `addlinst')
		}
		tempname haclagused
		RobReg "`depvar'" "`exog' `test' `x2hat' `endterm'"	///
			"`nocons'"					///
			"`wtype'" "`wexp'" "`touse'"	 		///
			"`vceopt'" "`x2hat'" :				///
			"" "" "" "`haclagused'" 			///
			"`regFn'" "`regFd'" "`regF'"
		return scalar regF = `regF'
		return scalar p_regF = Ftail(`regFn', `regFd', `regF')
		return scalar regFdf_n = `regFn'
		return scalar regFdf_d = `regFd'
		_estimates unhold `hold'
	}
	return scalar df = `df'
}	// end quietly block

	di
	di as text _col(3) "Tests of endogeneity"
	di as text _col(3) "Ho: variables are exogenous"
	di

	if "`doDurbWu'" == "yes" {
		di as text _col(3) "Durbin (score) chi2("		///
			as res `df' as text ")"				///
			as text _col(35) "=" 				///
			as res _col(37) %8.0g `durbin'			///
			as text "  (p = "				///
			as res %5.4f chi2tail(`df', `durbin')		///
			as text ")"
		di as text _col(3) "Wu-Hausman F(" as res `df' 		///
			as text "," as res `dfFdenom' as text ")"	///
			as text _col(35) "=" 				///
			as res _col(37) %8.0g `wu'			///
			as text "  (p = "				///
			as res %5.4f Ftail(`df', `dfFdenom', `wu')	///
			as text ")"
	}
	if "`doRobWool'" != "" {
		di as text _col(3) "Robust score chi2(" 		///
			as res `df' as text ")"				///
			as text _col(35) "=" 				///
			as res _col(37) %8.0g `robwool'			///
			as text "  (p = "				///
			as res %5.4f chi2tail(`df', `robwool')		///
			as text ")"
	}
	if "`doAcWool'" != "" {
		di as text _col(3) "HAC score chi2(" 			///
			as res `df' as text ")"				///
			as text _col(35) "=" 				///
			as res _col(37) %8.0g `acwool'			///
			as text "  (p = "				///
			as res %5.4f chi2tail(`df', `acwool')		///
			as text ")"
		if `lags' != 1 {
			local s s
		}
		di as text _col(5) 					///
			"(Prewhitening performed with `lags' lag`s')"
		if "`doAcReg'" != "" {
			di	// otherwise looks cluttered
		}
	}
	if "`doReg'`doRobReg'`doAcReg'" != "" {
		if "`doRobReg'" == "yes" {
			local tit "Robust r"
		}
		else if "`doAcReg'" == "yes" {
			local tit "HAC r"
		}
		else {
			local tit "R"
		}
		di as text _col(3) "`tit'egression F(" as res `regFn'	///
			as text "," as res `regFd' as text ")"		///
			as text _col(35) "=" 				///
			as res _col(37) %8.0g `regF'			///
			as text "  (p = "				///
			as res %5.4f Ftail(`regFn', `regFd', `regF')	///
			as text ")"
		if "`e(vce)'" == "cluster" {
			di as text _col(5) "(Adjusted for "		///
				e(N_clust) " clusters in `e(clustvar)')"
		}
		else if "`e(vcetype)'" == "HAC" {
			local k2 "Bartlett"
			if "`kernel'" == "parzen" {
				local k2 "Parzen"
			}
			if "`kernel'" == "quadraticspectral" {
				local k2 "quadratic spectral"
			}
			if `haclagused' < . {
				local klags = `haclagused'
			}
			if `klags' != 1 {
				local s s
			}
			di as text _col(5) "(Based on `k2' kernel "	///
				"with `klags' lag`s')"
			if `haclagused' < . {
				di as text _col(5) "(HAC lags chosen "	///
					"by Newey-West method)"
			}
		}
	}

end

program Endoggmm, rclass

	syntax [varlist(numeric default=none)] [, *]
	
	if "`options'" != "" {
		di as err "`options' not allowed"
		exit 198
	}

	local test `varlist'
	
	local depvar `e(depvar)'
	local exog `e(exogr)'
	local inst `e(insts)'
	local endog `e(instd)'
	local N = e(N)
	
	if "`test'" == "" {
		local test `endog'
	}
	local leftover : list test - endog
	if "`leftover'" != "" {
		di as error "`leftover' not endogenous in original model"
		exit 498
	}
	
	local exogeff `exog' `test'
	local endogeff : list endog - test
	local addlinst : list inst - exog
	
	local wmattype `e(wmatrix)'
	if `"`e(constant)'"' != "" {
		local nocons "noconstant"
	}
	else {
		tempvar one
		qui gen byte `one' = 1
	}
	
	tempvar touse
	gen byte `touse' = e(sample)
	
	tempvar normwt
	local wtype `e(wtype)'
	local wexp `"`e(wexp)'"'
	if "`wtype'" != "" {
		local wt [`wtype'`wexp']
		qui gen double `normwt' `wexp' if `touse'
		if "`wtype'" == "aweight" | "`wtype'" == "pweight" {
			summ `normwt' if `touse', mean
			qui replace `normwt' = r(N)*`normwt' / r(sum)
		}
	}
	else {
		qui gen double `normwt' = 1 if `touse'
	}
	
	tempname hold
	_estimates hold `hold'
	
	// Fit efficient model
	qui ivregress gmm `depvar' `exogeff' (`endogeff' = `addlinst')	///
		if `touse' `wt', wmat(`wmattype') `nocons'
	
	tempname J Weff Seff Wcon
	local N = e(N)
	sca `J' = e(J)
	mat `Weff' = e(W)
	mat `Seff' = invsym(`Weff')
	
	// Now remove the rows/cols of Seff corresponding to the vars
	// whose orthogonality conditions we are challenging
	foreach x of local test {
		DropRowCol `Seff' : `Seff' `x'
	}
	mat `Wcon' = invsym(`Seff')
	// Fit consistent model, using weight matrix `Wcon'
	tempname bjunk Vjunk Jprime
	mata: _iv_gmm_cstat("`depvar'", "`endog'", "`exog' `one'", 	///
		"`addlinst'", "`touse'", "`normwt'", "`N'", 		///
		"`Wcon'", "`bjunk'", "`Vjunk'", "`Jprime'")

	_estimates unhold `hold'
	tempname C Cp
	sca `C' = `J' - `Jprime'
	local df : list sizeof test
	sca `Cp' = chi2tail(`df', `C')
	
	di
	di as text _col(3) "Test of endogeneity (orthogonality conditions)"
	di as text _col(3) "Ho: variables are exogenous"
	di
	di as text _col(3) "GMM C statistic chi2(" as res `df' 		///
			as text ") = " 	///
			as res %8.0g `C' as text "  (p = " 		///
			as res %5.4f `Cp' as text ")"
			
	return scalar df = `df'
	return scalar C  = `C'
	return scalar p_C = `Cp'

end


/* UTILITIES FROM HERE ON DOWN
*/

/* Parse what's stored in e(vce).  -ivregress- created this,
   so it will contain valid information.  No error trapping.
*/
program ParseVCE, sclass

	args vcestr
	
	sreturn clear
	if `"`: word 1 of `vcestr''"' == "robust" {
		sreturn local vcetype "robust"
		exit
	}
	
	if `"`: word 1 of `vcestr''"' == "cluster" {
		sreturn local vcetype "cluster"
		exit
	}
	
	if `"`: word 1 of `vcestr''"' == "hac" {
		sreturn local vcetype "hac"
		sreturn local vcehac `: word 2 of `vcestr''
		local j : word 3 of `vcestr' {
			if "`j'" == "opt" {
				sreturn local vcehaclag -1
			}
			else {
				sreturn local vcehaclag `j'
			}
		}
		exit
	}
	
end


/* Fits a regression of <dep> on <indep>, computes desired type of 
   VCE, and conducts an F-test of variables in "test" option.  All
   returned arguments are optional; pass "" if you do not want them.
   The outputs, listed after the colon, are names of scalars to be
   filled in.
*/
program RobReg, eclass

	args	dep		/* regressand
	    */	indep		/* regressors
	    */	constant	/* "" or "noconstant"
	    */	wtype		/* "", fweight, aweight, etc.
	    */	wexp		/* "" or "=<exp>"
	    */	touse		/* 0/1 variable
	    */	vceopt		/* "vce(<stuff>)"
	    */	test		/* list of regressors to test
	    */	colon		/* ":"
	    */	r2		/* rsquared
	    */	ar2		/* adj. rsquared
	    */	nclust		/* # of clusters if vcetype=="cluster"
	    */	haclagused	/* # lags used if vcetype=="hac"
	    */	Fn		/* numerator df for F test
	    */	Fd		/* denominator df for F test
	    */	F		/* F statistic */

	if "`colon'" != ":" {
		di as error "RobReg called improperly"
		exit 2000
	}

	ivregress 2sls `dep' `indep' [`wtype'`wexp'] if `touse',	///
		`constant' `vceopt' small

	if "`test'" != "" {
		tempname F2
		test `test'
		scalar `F2' = r(F)
		local Fn2 = r(df)
		local Fd2 = r(df_r)
	}

	// return to user
	if "`r2'" != "" {
		scalar `r2' = e(r2)
	}
	if "`ar2'" != "" {
		scalar `ar2' = e(r2_a)
	}
	if "`nclust'" != "" {
		scalar `nclust' = e(N_clust)
	}
	if "`haclagused'" != "" {
		scalar `haclagused' = e(vcelagopt)
	}
	if "`Fn2'" != "" & "`Fn'" != "" {
		scalar `Fn' = `Fn2'
	}
	if "`Fd2'" != "" & "`Fd'" != "" {
		scalar `Fd' = `Fd2'
	}
	if "`F2'" != "" & "`F'" != "" {
		scalar `F' = `F2'
	}

end

// Given a square matrix with row and column names, deletes the row
// and column corresponding the variable name in the final argument.
// Exits with an error if name not found.  Used to extract submatrix
// of weight matrix when calculating GMM C statistic
// DropRowCol <result_matrix> : <orig_matrix> varname
program DropRowCol

	args new COLON old col
	
	if "`COLON'" != ":" {
		exit 2000
	}
	local i = rowsof(`old')
	local j = colsof(`old')
	if `i' != `j' {
		exit 2000
	}
	
	local names : colnames `old'
	local k : list sizeof names
	if `"`:word 1 of `names''"' == "`col'" {
		mat `new' = `old'[2..., 2...]
	}
	else if `"`:word `k' of `names''"' == "`col'" {
		mat `new' = `old'[1..`=`k'-1', 1..`=`k'-1']
	}
	else {
		local m : list posof "`col'" in names
		if `m' == 0 {
			di as error "`col' not found in `old'"
			exit 2000
		}
		local mn1 = `m' - 1
		local mp1 = `m' + 1
		mat `new' = `old'[1..`mn1', 1..`mn1'] ,		///
				`old'[1..`mn1', `mp1'...] \	///
			    `old'[`mp1'..., 1..`mn1'] ,		///
			        `old'[`mp1'..., `mp1'...]
	}

end
		


/* Critical values from Stock & Watson (2005)
*/
program Calcmineigcv

	args nendog ninst estimator cv

	tempname tslssize limlsize tslsbias
#delimit ;
/* Rows represent number of instrumental variables
   cols are CV's for worst-case rejection rates of
   0.10, 0.15, 0.20, and 0.25 for n=1 endogenous
   regressor (cols 1-4) and for n=2 endogenous
   regressors (cols 5-8).
*/
matrix `tslssize' = (
16.38,  8.96,  6.66,  5.53,     .,     .,     .,     . \
19.93, 11.59,  8.75,  7.25,  7.03,  4.58,  3.95,  3.63 \
22.30, 12.83,  9.54,  7.80, 13.43,  8.18,  6.40,  5.45 \
24.58, 13.96, 10.26,  8.31, 16.87,  9.93,  7.54,  6.28 \
26.87, 15.09, 10.98,  8.84, 19.45, 11.22,  8.38,  6.89 \
29.18, 16.23, 11.72,  9.38, 21.68, 12.33,  9.10,  7.42 \
31.50, 17.38, 12.48,  9.93, 23.72, 13.34,  9.77,  7.91 \
33.84, 18.54, 13.24, 10.50, 25.64, 14.31, 10.41,  8.39 \
36.19, 19.71, 14.01, 11.07, 27.51, 15.24, 11.03,  8.85 \
38.54, 20.88, 14.78, 11.65, 29.32, 16.16, 11.65,  9.31 \
40.90, 22.06, 15.56, 12.23, 31.11, 17.06, 12.25,  9.77 \
43.27, 23.24, 16.35, 12.82, 32.88, 17.95, 12.86, 10.22 \
45.64, 24.42, 17.14, 13.41, 34.62, 18.84, 13.45, 10.68 \
48.01, 25.61, 17.93, 14.00, 36.36, 19.72, 14.05, 11.13 \
50.39, 26.80, 18.72, 14.60, 38.08, 20.60, 14.65, 11.58 \
52.77, 27.99, 19.51, 15.19, 39.80, 21.48, 15.24, 12.03 \
55.15, 29.19, 20.31, 15.79, 41.51, 22.35, 15.83, 12.49 \
57.53, 30.38, 21.10, 16.39, 43.22, 23.22, 16.42, 12.94 \
59.92, 31.58, 21.90, 16.99, 44.92, 24.09, 17.02, 13.39 \
62.30, 32.77, 22.70, 17.60, 46.62, 24.96, 17.61, 13.84 \
64.69, 33.97, 23.50, 18.20, 48.31, 25.82, 18.20, 14.29 \
67.07, 35.17, 24.30, 18.80, 50.01, 26.69, 18.79, 14.74 \
69.46, 36.37, 25.10, 19.41, 51.70, 27.56, 19.38, 15.19 \
71.85, 37.57, 25.90, 20.01, 53.39, 28.42, 19.97, 15.64 \
74.24, 38.77, 26.71, 20.61, 55.07, 29.29, 20.56, 16.10 \
76.62, 39.97, 27.51, 21.22, 56.76, 30.15, 21.15, 16.55 \
79.01, 41.17, 28.31, 21.83, 58.45, 31.02, 21.74, 17.00 \
81.40, 42.37, 29.12, 22.43, 60.13, 31.88, 22.33, 17.45 \
83.79, 43.57, 29.92, 23.04, 61.82, 32.74, 22.92, 17.90 \
86.17, 44.78, 30.72, 23.65, 63.51, 33.61, 23.51, 18.35  );

/* Rows represent number of instrumental variables
   cols are CV's for worst-case rejection rates of
   0.10, 0.15, 0.20, and 0.25 for n=1 endogenous
   regressor (cols 1-4) and for n=2 endogenous
   regressors (cols 5-8).
*/
matrix `limlsize' = (
16.38, 8.96, 6.66, 5.53,    .,    .,    .,    . \
 8.68, 5.33, 4.42, 3.92, 7.03, 4.58, 3.95, 3.63 \
 6.46, 4.36, 3.69, 3.32, 5.44, 3.81, 3.32, 3.09 \
 5.44, 3.87, 3.30, 2.98, 4.72, 3.39, 2.99, 2.79 \
 4.84, 3.56, 3.05, 2.77, 4.32, 3.13, 2.78, 2.60 \
 4.45, 3.34, 2.87, 2.61, 4.06, 2.95, 2.63, 2.46 \
 4.18, 3.18, 2.73, 2.49, 3.90, 2.83, 2.52, 2.35 \
 3.97, 3.04, 2.63, 2.39, 3.78, 2.73, 2.43, 2.27 \
 3.81, 2.93, 2.54, 2.32, 3.70, 2.66, 2.36, 2.20 \
 3.68, 2.84, 2.46, 2.25, 3.64, 2.60, 2.30, 2.14 \
 3.58, 2.76, 2.40, 2.19, 3.60, 2.55, 2.25, 2.09 \
 3.50, 2.69, 2.34, 2.14, 3.58, 2.52, 2.21, 2.05 \
 3.42, 2.63, 2.29, 2.10, 3.56, 2.48, 2.17, 2.02 \
 3.36, 2.57, 2.25, 2.06, 3.55, 2.46, 2.14, 1.99 \
 3.31, 2.52, 2.21, 2.03, 3.54, 2.44, 2.11, 1.96 \
 3.27, 2.48, 2.18, 2.00, 3.55, 2.42, 2.09, 1.93 \
 3.24, 2.44, 2.14, 1.97, 3.55, 2.41, 2.07, 1.91 \
 3.20, 2.41, 2.11, 1.94, 3.56, 2.40, 2.05, 1.89 \
 3.18, 2.37, 2.09, 1.92, 3.57, 2.39, 2.03, 1.87 \
 3.21, 2.34, 2.06, 1.90, 3.58, 2.38, 2.02, 1.86 \
 3.39, 2.32, 2.04, 1.88, 3.59, 2.38, 2.01, 1.84 \
 3.57, 2.29, 2.02, 1.86, 3.60, 2.37, 1.99, 1.83 \
 3.68, 2.27, 2.00, 1.84, 3.62, 2.37, 1.98, 1.81 \
 3.75, 2.25, 1.98, 1.83, 3.64, 2.37, 1.98, 1.80 \
 3.79, 2.24, 1.96, 1.81, 3.65, 2.37, 1.97, 1.79 \
 3.82, 2.22, 1.95, 1.80, 3.67, 2.38, 1.96, 1.78 \
 3.85, 2.21, 1.93, 1.78, 3.74, 2.38, 1.96, 1.77 \
 3.86, 2.20, 1.92, 1.77, 3.87, 2.38, 1.95, 1.77 \
 3.87, 2.19, 1.90, 1.76, 4.02, 2.39, 1.95, 1.76 \
 3.88, 2.18, 1.89, 1.75, 4.12, 2.39, 1.95, 1.75  );

/* Rows represent number of instrumental variables
   cols are CV's for worst-case relative biases of
   0.05, 0.10, 0.20, and 0.30 for n=1 endogenous
   regressors (cols 1-4), n=2 endogenous regress-
   ors (cols 5-8), and n=3 endogenous regressors
   (cols 9-12).
*/
matrix `tslsbias' = (
    .,     .,    .,    .,     .,     .,    .,    .,     .,     .,    .,    . \
    .,     .,    .,    .,     .,     .,    .,    .,     .,     .,    .,    . \
13.91,  9.08, 6.46, 5.39,     .,     .,    .,    .,     .,     .,    .,    . \
16.85, 10.27, 6.71, 5.34, 11.04,  7.56, 5.57, 4.73,     .,     .,    .,    . \
18.37, 10.83, 6.77, 5.25, 13.97,  8.78, 5.91, 4.79,  9.53,  6.61, 4.99, 4.30 \
19.28, 11.12, 6.76, 5.15, 15.72,  9.48, 6.08, 4.78, 12.20,  7.77, 5.35, 4.40 \
19.86, 11.29, 6.73, 5.07, 16.88,  9.92, 6.16, 4.76, 13.95,  8.50, 5.56, 4.44 \
20.25, 11.39, 6.69, 4.99, 17.70, 10.22, 6.20, 4.73, 15.18,  9.01, 5.69, 4.46 \
20.53, 11.46, 6.65, 4.92, 18.30, 10.43, 6.22, 4.69, 16.10,  9.37, 5.78, 4.46 \
20.74, 11.49, 6.61, 4.86, 18.76, 10.58, 6.23, 4.66, 16.80,  9.64, 5.83, 4.45 \
20.90, 11.51, 6.56, 4.80, 19.12, 10.69, 6.23, 4.62, 17.35,  9.85, 5.87, 4.44 \
21.01, 11.52, 6.53, 4.75, 19.40, 10.78, 6.22, 4.59, 17.80, 10.01, 5.90, 4.42 \
21.10, 11.52, 6.49, 4.71, 19.64, 10.84, 6.21, 4.56, 18.17, 10.14, 5.92, 4.41 \
21.18, 11.52, 6.45, 4.67, 19.83, 10.89, 6.20, 4.53, 18.47, 10.25, 5.93, 4.39 \
21.23, 11.51, 6.42, 4.63, 19.98, 10.93, 6.19, 4.50, 18.73, 10.33, 5.94, 4.37 \
21.28, 11.50, 6.39, 4.59, 20.12, 10.96, 6.17, 4.48, 18.94, 10.41, 5.94, 4.36 \
21.31, 11.49, 6.36, 4.56, 20.23, 10.99, 6.16, 4.45, 19.13, 10.47, 5.94, 4.34 \
21.34, 11.48, 6.33, 4.53, 20.33, 11.00, 6.14, 4.43, 19.29, 10.52, 5.94, 4.32 \
21.36, 11.46, 6.31, 4.51, 20.41, 11.02, 6.13, 4.41, 19.44, 10.56, 5.94, 4.31 \
21.38, 11.45, 6.28, 4.48, 20.48, 11.03, 6.11, 4.39, 19.56, 10.60, 5.93, 4.29 \
21.39, 11.44, 6.26, 4.46, 20.54, 11.04, 6.10, 4.37, 19.67, 10.63, 5.93, 4.28 \
21.40, 11.42, 6.24, 4.43, 20.60, 11.05, 6.08, 4.35, 19.77, 10.65, 5.92, 4.27 \
21.41, 11.41, 6.22, 4.41, 20.65, 11.05, 6.07, 4.33, 19.86, 10.68, 5.92, 4.25 \
21.41, 11.40, 6.20, 4.39, 20.69, 11.05, 6.06, 4.32, 19.94, 10.70, 5.91, 4.24 \
21.42, 11.38, 6.18, 4.37, 20.73, 11.06, 6.05, 4.30, 20.01, 10.71, 5.90, 4.23 \
21.42, 11.37, 6.16, 4.35, 20.76, 11.06, 6.03, 4.29, 20.07, 10.73, 5.90, 4.21 \
21.42, 11.36, 6.14, 4.34, 20.79, 11.06, 6.02, 4.27, 20.13, 10.74, 5.89, 4.20 \
21.42, 11.34, 6.13, 4.32, 20.82, 11.05, 6.01, 4.26, 20.18, 10.75, 5.88, 4.19 \
21.42, 11.33, 6.11, 4.31, 20.84, 11.05, 6.00, 4.24, 20.23, 10.76, 5.88, 4.18 \
21.42, 11.32, 6.09, 4.29, 20.86, 11.05, 5.99, 4.23, 20.27, 10.77, 5.87, 4.17  );

#delimit cr

	tempname relbias tsls liml
	
	if (`nendog' > 3) | `ninst' > 30 {
		mat `relbias' = J(2,4,.)
	}
	else if `nendog' == 1 {
		mat `relbias' = `tslsbias'[`ninst', 1..4]
	}
	else if `nendog' == 2 {
		mat `relbias' = `tslsbias'[`ninst', 5..8]
	}
	else {
		mat `relbias' = `tslsbias'[`ninst', 9..12]
	}

	if (`nendog' > 2) | `ninst' > 30 {
		mat `tsls' = J(1,4,.)
	}
	else if `nendog' == 1 {
		mat `tsls' = `tslssize'[`ninst', 1..4]
	}
	else {
		mat `tsls' = `tslssize'[`ninst', 5..8]
	}

	if (`nendog' != 1 & `nendog' != 2) | `ninst' > 30 {
		mat `liml' = J(1,4,.)
	}
	else if `nendog' == 1 {
		mat `liml' = `limlsize'[`ninst', 1..4]
	}
	else {
		mat `liml' = `limlsize'[`ninst', 5..8]
	}
	
	mat `cv' = `relbias' \ `tsls' \ `liml'

end

program NoOmit, rclass
	syntax [varlist(fv ts default=none)] [,touse(string)]
	if "`touse'" != "" {
		local if "if `touse'"
	}
	
	if "`varlist'" == "" {
		local hasfv = 0
		local noomitted 0
		return scalar noomitted = `noomitted'
		return scalar hasfv = `hasfv'
		exit
	}
	local hasfv = "`s(fvops)'" == "true"	
	fvexpand `varlist' `if'
	local full_list `r(varlist)'
	local cols : word count `full_list'
	tempname noomitcols
	local noomitted 0
	local i 1
	foreach var of local full_list {
		_ms_parse_parts `var'
		if `r(omit)' {
			if !`hasfv' {
				local hasfv 1
			}
		}
		else {
			local ++noomitted
			capture assert `noomitcols'[1,1]>0
			if !_rc {
				mat `noomitcols' = `noomitcols'[1,1...],`i'
			}
			else {
				mat `noomitcols' = J(1,1,`i')
			}
		}
		local ++i
	}
	return scalar noomitted = `noomitted'
	return matrix noomitcols = `noomitcols'
	return scalar hasfv = `hasfv'
end

version 10
mata:

void _iv_craggdonald_wrk(string scalar deps, 	  string scalar endogs,
			 string scalar inclexogs, string scalar exclexogs,
			 string scalar touse,	  string scalar wts,
			 real scalar capn,	  string scalar Fs,
			 real scalar hasfv)
{

	real matrix endog, inclexogorig, inclexog, 
			exclexogorig, exclexog, wt
	real matrix XpX, XpXi, XpY, XpZ, YpZ, ZpZ, YpMxZ, ZpMxZ
	real matrix YpY, YpMzbarY, YpZbar, ZbarpZbar, Sigvv, Sigvvisq, F
	
	pragma unset inclexog
	pragma unset exclexog
	pragma unused deps
	
	st_view(endog=., ., tokens(endogs), touse)
	if(hasfv) {
	  st_view(inclexogorig=., ., tokens(inclexogs), touse)
	  st_subview(inclexog,inclexogorig,.,st_matrix(st_local("incl_cols")))
	  st_view(exclexogorig=., ., tokens(exclexogs), touse)
	  st_subview(exclexog,exclexogorig,.,st_matrix(st_local("excl_cols")))
	}
	else {
	  st_view(inclexog=., ., tokens(inclexogs), touse)
	  st_view(exclexog=., ., tokens(exclexogs), touse)
	}
	st_view(wt=., ., tokens(wts), touse)
	
	XpX = quadcross(inclexog, wt, inclexog)
	XpY = quadcross(inclexog, wt, endog)
	XpZ = quadcross(inclexog, wt, exclexog)
	YpZ = quadcross(endog, wt, exclexog)
	YpZbar = quadcross(endog, wt, (inclexog, exclexog))
	ZpZ = quadcross(exclexog, wt, exclexog)
	ZbarpZbar = quadcross((inclexog, exclexog), wt, (inclexog, exclexog))
	XpXi = cholinv(XpX)
	YpMxZ = YpZ - XpY'*XpXi*XpZ
	ZpMxZ = ZpZ - XpZ'*XpXi*XpZ
	YpY = quadcross(endog, wt, endog)
	YpMzbarY = YpY - YpZbar*cholinv(ZbarpZbar)*YpZbar'

	Sigvv = YpMzbarY / (capn - cols(inclexog) - cols(exclexog))
	Sigvvisq = matpowersym(0.5*(Sigvv + Sigvv'), -0.5)
	F = Sigvvisq * (YpMxZ*cholinv(ZpMxZ)*YpMxZ') * Sigvvisq / cols(exclexog)
	if (!issymmetric(F)) {
		_makesymmetric(F)
	}
	F = min(symeigenvalues(F))
	st_numscalar(Fs, F)

}


/*	This routine computes the GMM estimates and J statistic
	given a weighting matrix W.  Unlike _iv_gmm_wrk, this
	function does not compute the weighting matrix for you.

	This function is intended for use in computing the C
	statistic for testing overidentifying restrictions and
	similar applications.
	
	See Hayashi (2000, pp. 218-221) for background on the
	C statistic.
*/
void _iv_gmm_cstat(string scalar deps,
		 string scalar endogs, 
		 string scalar exogs,
		 string scalar insts,
		 string scalar touse,
		 string scalar wts,
		 string scalar capns,
		 string scalar Ws,
		 string scalar bs,		// output
		 string scalar Vs,		// output
		 string scalar Js		// output
)
{

	real matrix dep, endog, exog, inst, wt
	real matrix uPZ, ZPY, ZPX, ALL, W
	real matrix var, beta, err, data
	real scalar J, i, j, i2, j2, capn

	// Get data into matrices
	st_view(data=., .,
		tokens(deps + " " + endogs + " " + exogs + " " + insts),
		touse)
	st_subview(dep=., data, ., 1)
	
	i = 1 + cols(tokens(endogs))
	if (i > 1) {
		st_subview(endog=., data, ., (2..i))
	}
	else {
		endog = J(rows(data), 0, 0)	// no columns
	}

	j = i + cols(tokens(exogs))
	++i
	if (i <= j) {
		st_subview(exog=., data, ., (i..j))
	}
	else {
		exog = J(rows(data), 0, 0)
	}

	i = j + cols(tokens(insts))
	++j
	if (j <= i) {
		st_subview(inst=., data, ., (j..i))
	}
	else {
		inst = J(rows(data), 0, 0)
	}

	capn = strtoreal(capns)
	st_view(wt=., ., tokens(wts), touse)
	ALL = quadcross(data, wt, data)
	i = 2 + cols(endog)
	i2 = rows(ALL)

	j2 = 1 + cols(endog) + cols(exog)
	ZPX = ALL[|i, 2 \ i2, j2|]
	ZPY = ALL[|i, 1 \ i2, 1|]

	W = st_matrix(Ws)

	var = qrinv(ZPX'*W*ZPX)
	beta = var*ZPX'*W*ZPY
	var = capn*var
	if (!issymmetric(var)) {
		_makesymmetric(var)
	}
	err = dep
	if (cols(endog) > 0) {
		err = err - endog*beta[1::cols(endog), 1]
	}
	if (cols(exog) > 0) {
		err = err - exog*beta[(cols(endog)+1)::rows(beta), 1]
	}
	uPZ = quadcross(err, wt, (exog, inst)) / capn
	J = capn*uPZ*W*uPZ'
	st_matrix(bs, beta')
	st_matrix(Vs, var)
	st_numscalar(Js, J)

}

end
exit

