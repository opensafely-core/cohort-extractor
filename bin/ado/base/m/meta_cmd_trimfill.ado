*! version 1.0.0  17may2019
program meta_cmd_trimfill, rclass
	version 16
	syntax [if] [in] [,				///
		ESTimator(string)			///
		EFORM1					///
		or					///
		rr					///
		EForm(string)				///
		ITERMETHod(string)			/// 
		POOLMETHod(string)			/// 
		fixed					///
		random(string)				///
		RANDOM1					///
		common					///
		Level(string)				///
		left					///
		right					///
		CFormat(string)				///
		PFormat(string)				///
		funnel(string)				///
		FUNNEL1					///
		NOMETASHOW				///
		METASHOW1				///
		log					///
		ITERate(real 100)]
	
	cap confirm variable _meta_es _meta_se
	if _rc {
		meta__notset_err
	}
	
	opts_exclusive "`left' `right'" 
	if !missing("`metashow1'") & !missing("`nometashow'") {
		di as err ///
		"only one of {bf:metashow} or {bf:nometashow} is allowed"
		exit 198
	}
	
	if missing("`level'") {
		local level  : char _dta[_meta_level]
	}
	else {
		meta__validate_level "`level'"
		local level `s(mylev)'
	}	
	
	if !missing("`funnel'") & !missing("`funnel1'") {
		di as err "only one of options {bf:funnel()} and " ///
			"{bf:funnel} is allowed"
		exit 184	
		
	}
		
	marksample touse
	
	qui count if `touse'
	local K = r(N)
	
	meta__eform_err, eform(`eform') `eform1' `or' `rr'
	
	_parseEstimator estimator : `estimator'
	
	local re = subinstr("`random'"," ", "_",.)
	
	local mod `"`re' `fixed' `random1' `common'"'
	
	if  (`:word count `mod'' > 1) {
		meta__model_err	  
	}
	
	if missing("`itermethod'`poolmethod'") {	
		meta__model_method, random(`random') `random1' `fixed' ///
			`common' iv 
		if "`method'"=="invvariance" | "`method'"=="ivariance" {
			local itermethod = ///
				cond("`model'"=="common", "common", "fixed")
		}
		else {
			local itermethod "`method'"
		}
		local poolmethod `itermethod'
	}
	else {
		if !missing("`random'`random1'`fixed'`common'") {
			di as err "{p}options {bf:random()}, {bf:random}, " ///
			"{bf:common}, or {bf:fixed} may not be " ///
			 "combined with either option {bf:itermethod()} " ///
			 "or option {bf:poolmethod()}{p_end}"
			exit 184
		}
	}
	
	if "`method'" == "mhaenszel" {
		
		meta__mh_err, cmd(meta trimfill)

		local itermethod = cond("`model'"=="common", "common", "fixed")
		local poolmethod = cond("`model'"=="common", "common", "fixed") 
	}
	
	meta__validate_method, meth(itermethod) `itermethod'
	local imethod `s(method)'
	local imethdesc `s(methdesc)'
	local imodeldesc `s(modeldesc)'
	local imodel `s(model)'
	
	meta__validate_method, meth(poolmethod) `poolmethod'
	local pmethod `s(method)'
	local pmethdesc `s(methdesc)'
	local pmodeldesc `s(modeldesc)'
	local pmodel `s(model)'
	
	meta__parse_format, cformat("`cformat'") pformat("`pformat'") 			
	local cformat `s(cformat)'
	local pformat `s(pformat)'
	
	_validateIterate, iterate(`iterate')
	
	tempname info
	
	if !missing("`funnel'") {
		_parseFunnel metric : `"`funnel'"'
	}
	
	if !missing("`funnel1'") {
		local metric "se"
	}
	
	_estimates hold eres, restore nullok
	
	if !missing("`left'`right'") local side  "`left'`right'"
	else {
		qui meta bias, egger trad
		tempname biasres
		mat `biasres' = r(table)
		// local side = cond(_b[_meta_se] <= 0, "right" , "left")
		local side = cond(`biasres'[1,1] <= 0, "right" , "left")
	}

	local estyp : char _dta[_meta_estype]
	local dtype : char _dta[_meta_datatype]
	
	local eslbl : char _dta[_meta_eslabel]
	
	if !missing("`or'`rr'") local eform1 eform1
	
	meta__eslabel, `eform1' estype(`estyp') eslbl(`eslbl')
	local eslab = cond(missing("`eform'"), "`s(eslab)'", "`eform'")
	
	
	local ilog = cond(missing("`log'"),0,cond("`log'"=="log",1,0))
	local ISERROR 0
	local ISWARNING 0
	
	mata: st_matrix("`info'", _trimfill("_meta_es", "_meta_se", ///
		"`estimator'", "`imethod'", "`pmethod'", "`metric'", ///
		"`side'", `ilog', `iterate', "`touse'"))
	
	if "`ISERROR'" == "1" {
		di as err "the trim-and-fill algorithm failed to converge"
		exit 430
	}
	
	return scalar converged = `r(converged)'
	tempname A B
	mat `A' = r(filledstudies)
	mat `B' = r(filledres)
	return matrix imputed = `A'
	return hidden matrix imputedres = `B'
	local k0 = r(k0)
	return scalar K_total = `=`K' +`k0''
	return scalar K_observed = `K'
	return hidden scalar K = `K'
	return scalar K_imputed = `k0'
	
	local exponen = cond(missing("`eform'`eform1'"),0,1)

	local global_metashow : char _dta[_meta_show]	
	if missing("`nometashow'`global_metashow'") | !missing("`metashow1'") {
		di
		meta__esize_desc, col(3)
	}
	
	di _n as txt "Nonparametric trim-and-fill analysis of publication bias" 
	
	mata: __di_meta_trim(st_matrix("`info'"), "`estimator'", `exponen')
	_parseFunnelModelandMethod, pmethod(`pmethod') pmodel(`pmodel')

	local thetaOpt theta(`theta4funnel') `modopt'
	if "`ISWARNING'" == "1" {
		di as txt "Warning: convergence not achieved"
	}
	
	// `toadd' comes from mata: _trimfill() 
	if !missing("`funnel'") | !missing("`funnel1'") {
		if !missing("`toadd'") {
			qui meta_cmd_funnel if `touse', ///
				yvarlab("Observed studies") `funnel' ///
				addplot(scatteri `toadd', ///
				 yvarlab("Imputed studies")) ///
				`thetaOpt' 
		}
		else {
			qui meta_cmd_funnel if `touse', `funnel' `thetaOpt'
		}	
	}
	
	matrix rownames `info' = Observed Total
	matrix colnames `info' = "Nb studies" "ES" "Lower CI" ///
		"Upper CI" 
	
	return local estimator "`estimator'"
	return local poolmethod "`poolmethod'"
	return local itermethod "`itermethod'"
	return local side = "`side'"
	return local level "`level'"
	return matrix table = `info'
	return hidden local toadd  `toadd'								
end


program _validateIterate
	syntax [, iterate(string)]
	local msg "option {bf:iterate()} must contain a nonnegative " ///
		"integer value"
	cap confirm integer number `iterate'
	if _rc {
		di as err "{p}`msg'{p_end}"
		exit 198
	}
	else {
		cap assert `iterate' >= 0
		if _rc {
			di as err "{p}`msg'{p_end}"
			exit 198
		}
	}
end	

program _parseEstimator
	args estimator colon estopt
	local 0 ,`estopt'

	syntax [, LINear QUADratic run *]
	if !missing("`options'") {
		di as err "{p}invalid option {bf:estimator()} " ///
			"specification: estimator {bf:`options'} not " ///
			"supported{p_end}"
		exit 198
	}
	
	opts_exclusive "`linear' `quadratic' `run'" estimator
	
	local which `linear' `quadratic' `run'
	
	local k : word count `which'
	if !`k'	local which linear
	
	c_local `estimator' "`which'"
end

program _parseFunnelModelandMethod
	
	syntax [, pmethod(string) pmodel(string)]
	
	if "`pmodel'" == "common" c_local modopt "common"
	else if "`pmodel'" == "fixed" c_local modopt "fixed"
	else c_local modopt "`pmodel'(`pmethod')"
end

program _parseFunnel
	
	args Yaxis colon funnelopts
	
	local 0, `funnelopts'
	syntax [, Metric(string) random(string) 	///
			RANDOM1				///
			fixed(string)  			///
			FIXED1  			///
			common(string)  		///
			COMMON1  			///
			NOMETASHOW			///
			METASHOW1			///
			addplot(string)			///
			by(string)			///
			*]
	
	local msg "not allowed within option {bf:funnel()}"
	if !missing("`fixed'`common'`random'`fixed1'`common1'`random1'") {
		di as err ///
		"{p}options {bf:random()}, {bf:random}, {bf:common()}, " ///
		"{bf:common}, {bf:fixed()}, and {bf:fixed} are `msg'{p_end}" 
		exit 198
	}
	if !missing("`addplot'") {
		di as err ///
		"{p}option {bf:addplot()} is `msg'{p_end}"
		exit 198
	}
	if !missing("`nometashow'`metashow1'") {
		di as err ///
		"{p}options {bf:nometashow} and {bf:metashow} are `msg'{p_end}"
		exit 198
	}
	if !missing("`by'") {
		di as err ///
		"{p}option {bf:by()} is `msg'{p_end}"
		exit 198
	}
	if missing("`metric'") local metric "se"
	else if inlist("`metric'", "n", "invn") {
		di as err "{p}filled funnel plots when the yaxis is the " ///
			"sample size or inverse sample size are not " ///
			"supported{p_end}"
		exit 198	
	}
	c_local `Yaxis' "`metric'"
end
