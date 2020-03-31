*! version 1.0.0  29may2019
program meta_cmd_bias, rclass
	version 16
	
	syntax [varlist (fv default = none)] [if] [in] [,	///
		noCONSTant					///
		NOMETASHOW					///
		METASHOW1					///
		TRADitional					///
		fixed						///
		common						///
		random(string)					///
		RANDOM1						///
		begg						///
		BEggopts(string)				/// UNDOC
		egger						///
		esphillips					///
		peters						///
		petersetal					///
		HARBord						///
		hesterne					///
		bmazumdar					///
		detail						///
		TDISTribution					/// t-distr
		se(string)					///
		MULTiplicative *]
	
	marksample touse
	
	if !missing("`esphillips'") local egger egger
	if !missing("`petersetal'") local peters peters
	if !missing("`hesterne'") local harbord harbord
	if !missing("`bmazumdar'") local begg begg
	
	cap confirm variable _meta_es _meta_se
	if _rc {
		meta__notset_err
	}
	
	if !missing("`se'") {
		meta__parse_seadj adjtype : `"`se'"'
	}
	if ("`adjtype'"=="khartung") local adj "Knapp-Hartung"
	else if ("`adjtype'"=="tkhartung") local adj "Truncated Knapp-Hartung"
	
	if !missing("`beggopts'") local begg begg
	
	if !missing("`metashow1'") & !missing("`nometashow'") {
		di as err ///
		"only one of {bf:metashow} or {bf:nometashow} is allowed"
		exit 198
	}
	opts_exclusive "`egger' `peters' `harbord' `begg'"
	
	local dtatyp : char _dta[_meta_datatype]
	local optls "`traditional'`fixed'`common'`random1'`random'"
	local msg "you must specify one of options "
	if missing("`egger'`peters'`harbord'`begg'") {
		if !missing("`optls'") {
			if "`dtatyp'"!="binary" {
				di as err ///
				"you must specify option {bf:egger}"
			}
			else {
				di as err ///
				"{p}`msg'{bf:egger}, {bf:peters}, " ///
				"or {bf:harbord}{p_end}"
			}			
		}
		else {
			if "`dtatyp'"!="binary" {
				di as err ///
				"{p}`msg'{bf:egger} or {bf:begg}{p_end}"
			}
			else {
				di as err "{p}`msg'{bf:egger}, {bf:peters}," ///
				" {bf:harbord}, or {bf:begg}{p_end}"
			}
			
		}
		exit 198  
	}
	
	if !missing("`constant'") {
		di as err "option {bf:noconstant} is not allowed"
		exit 198
	}
	
	
	if ("`dtatyp'"!="binary" & !missing("`peters'`harbord'")) {
		di as err "options {bf:peters} and {bf:harbord} may be " _c
		di as err "specified only with binary data"
		exit 198
	}
	
	local re = subinstr("`random'"," ", "_",.)
	
	local mod `"`re' `fixed' `random1' `common'"'
	if  (`:word count `mod'' > 1) {
		meta__model_err	  
	}
	
	
	meta__model_method, random(`random') `random1' `fixed' `common' iv 
		
	if "`method'"=="mhaenszel" & missing("`begg'") {
		meta__mh_err, cmd(meta bias)
		local method invvariance 
	}
	
	fvrevar `varlist', list
	local vars "`r(varlist)'"
	
	NotAllowedWithBegg, `begg' `multiplicative' `traditional' se(`se') ///
		model(`mod') varlist(`varlist')
	
	// moderators not allowed with common-effect model
	NotAllowedWithCommon, model("`model'") varlist("`varlist'") ///
		`multiplicative'
	
	
	if "`model'" == "common" local fixed fixed
	
	// Traditional FE reg models were based on t-dist with overdispersion
	// overdispersion may be requested via option -multip-
	if !missing("`traditional'") {
		local optls "`common'`random1'`random'"
		if !missing("`optls'") {
			di as err ///
			"{p}options {bf:random()}, {bf:random}, and " ///
			"{bf:common} are not allowed with option " ///
			"{bf:traditional}{p_end}"
			exit 198
		}
		if !missing("`varlist'") {
			di as err "{p}moderators are not supported with " ///
			"traditional regression-based tests{p_end}"
			exit 198
		}
		local optslist `"`re' `se'"'
		if  (`:word count `optslist'' > 0) {
			di as err "{p}options {bf:random()} and {bf:se()} " ///
				  "are not allowed with option " 	///
				  "{bf:traditional}{p_end}"
			exit 198
		}
		
		local model fixed
		local fixed fixed
		local method "invvariance"
		local multiplicative multiplicative
		local tdistribution tdistribution
	}
		
	local qui = cond(missing("`detail'"), "quietly", "")
	local Random random(`random')
	
	// needed if ran after -meta regress-
	_estimates hold old, restore nullok
	
	local estyp : char _dta[_meta_estype]
	if "`estyp'" != "lnoratio" & !missing("`peters'"){
		di as err "{p}Peters's test is supported only with " ///
			"effect size {bf:lnoratio}{p_end}"
		exit 198
	}
	if !inlist("`estyp'", "lnoratio", "lnrratio") & !missing("`harbord'") {
		di as err "{p}Harbord's test is supported only with " ///
			"effect sizes {bf:lnoratio} and " ///
			"{bf:lnrratio}{p_end}"
		exit 198
	}


	local global_metashow : char _dta[_meta_show]
	if missing("`nometashow'`global_metashow'") | !missing("`metashow1'") {
			di
			meta__esize_desc, col(3)
	}

	if (!missing("`egger'")) {
		`qui' meta_cmd_regress _meta_se `varlist', `fixed' ///
			`Random' `tdistribution' `multiplicative' ///
			se(`se')  nometashow `options'  
		local bias "_meta_se"
		local name "Egger"
			
	} // can be used with RR same w (see cochrane recommended tests table)
	else if (!missing("`peters'")) { 
		tempvar ninv tot w
		local binvarlist : char _dta[_meta_datavars]
		qui {
			egen `tot' = rowtotal(`binvarlist') 
			gen double `ninv' = 1/`tot'
			tokenize `binvarlist'
			gen double `w' = (`1'+`3')*(`2'+`4')*`ninv'
		}
		if ("`model'"=="random") {
			`qui' meta_cmd_regress `ninv' `varlist',  ///
				`Random' `tdistribution' ///
				se(`se') `options'  nometashow ///
				testtype("peters") tmpvar("`ninv'")
		}
		else {
		`qui' meta_cmd_regress `ninv' `varlist', wgtvar(`w') ///
			`fixed' `tdistribution' `multiplicative' `options' ///
			 nometashow testtype("peters") ///
			tmpvar("`ninv'")
		}	
			
		local bias "`ninv'"
		local name "Peters"
			
	}
	else if (!missing("`harbord'")) {
		// Z/V on 1/sqrt(V) weighed by V (test is on slope)
		// Harbord et al (2006), Moreno et al (2009)
		tempvar tot ctot ttot evtot nevtot e V Z rootVinv ZoverV w
		local binvarlist : char _dta[_meta_datavars]
		local db double
		qui egen `tot' = rowtotal(`binvarlist')

		tokenize `binvarlist'
		quietly {
			gen `db' `ttot'   = `1' + `2'      // treat total
			gen `db' `ctot'   = `3' + `4'      // control tot
			gen `db' `evtot'  = `1' + `3'      // event tot
			gen `db' `nevtot' = `2' + `4'      // non-event tot
			gen `db' `e' = `evtot'*`ttot'/(`tot')
		}
		if "`estyp'" == "lnrratio" {
			qui gen `db' `V'=  `e'*`ctot'/`nevtot' if `touse'
qui gen `db' `Z'= (`1'*`tot'-`evtot'*`ttot') /`nevtot' if `touse'
		}
		else if "`estyp'" == "lnoratio" {
			qui gen `db' `V' = `evtot'*`ttot'*`ctot'*`nevtot'   ///
				/(`tot'^2*(`tot'- 1)) if `touse'
			qui gen `db' `Z' = `1' - `e' if `touse'

		}		
		quietly {
			gen `db' `rootVinv'=1/sqrt(`V') if `touse'
			gen `db' `ZoverV' = `Z'/`V' if `touse'
		}
		
		`qui' meta_cmd_regress `rootVinv' `varlist',`fixed' `Random' ///
			depvar(`ZoverV') sevar(`rootVinv') `tdistribution' ///
			`multiplicative' se(`se') `options' nometashow ///
			depname("Z/V") testtype("harbord") ///
			tmpvar("`rootVinv'")	
		local bias "`rootVinv'"
		local name "Harbord"	
		
	}
	else if (!missing("`begg'")) {
			
		if "`options'"!="" {
			local s = cond(`:word count `options'' >1,"s","")
			di as err "option`s' {bf:`options'} not allowed"
			exit 198
			
		}
		
		tempvar meta_var vsj tsj
		tempname theta_info th vth 
		qui gen `db' `meta_var' = _meta_se^2
		
		qui meta summ, fixed(iv)
		scalar `vth' = `r(se)'^2
		scalar `th' = `r(theta)'
		gen `db' `vsj' = `meta_var' - `vth'
		gen `db' `tsj' = (_meta_es - `th')/sqrt(`vsj')
			
		`qui' di _n as txt "Estimation results from {bf:ktau}" _n
		`qui' di as txt "`tsj': Standardized {bf:_meta_es}"
		`qui' di as txt "`meta_var': Variance {bf:_meta_se}^2"
		`qui' ktau `tsj' `meta_var', `beggopts'
		
		local name "Begg's"
		
		tempname score se_score p
		scalar `score' = r(score)
		scalar `se_score' = r(se_score)
		scalar `p' = r(p)
		return scalar score = `score'
		return scalar se_score = `se_score'
		return scalar p = `p'
		
		di _n as txt "`name' test for small-study effects" _n 
		tempname z pval
		scalar `z' = (`return(score)'-1)/`return(se_score)'
		scalar `pval' = 2*(1-normal(`z'))
		di as txt  "Kendall's score = " as res %9.2f  `score' 
		di as txt _col(5) "SE of score = " as res %9.3f `se_score'
		di as txt _col(15) "z = " as res %9.2f  `z' 
		di as txt _col(6) "Prob > |z| = " as res %9.4f `pval'
		return scalar z = `z'
		return local testtype begg 
		exit
	}
	di as txt _n "Regression-based `name' test for small-study effects" 
	meta__model_desc, key("`method'") meth(`model') version(2)
	if !missing("`varlist'") {
			di "{p 0 12 0 `lnsz'}Moderators: {res}`vars'{p_end}"
	}
	if !missing("`se'") {
			di "SE adjustment: `adj'"
	}
	di

	if missing("`begg'") {
		tempname A stat pval phi tau2 b b_se
		scalar `tau2' = e(tau2)
		scalar `phi' = e(phi)
		matrix `A' = r(table)
		
		local rnames : rownames `A'
		local sta : word 3 of `rnames'
		scalar `b' = `A'[1, colnumb(`A',"`bias'")]
		scalar `b_se' = `A'[2, colnumb(`A',"`bias'")]
		scalar `stat' = `A'[3, colnumb(`A',"`bias'")]
		scalar `pval' = `A'[rownumb(`A', "pvalue"), ///
			colnumb(`A',"`bias'")]
		di as txt "H0: beta1 = 0; no small-study effects"
		di as txt _col(13) "beta1 = " as res %9.2f  `b' 
		di as txt _col(7) "SE of beta1 = " as res %9.3f `b_se'
		di as txt _col(17) "`sta' = " as res %9.2f `stat' 
		di as txt _col(8) "Prob > |`sta'| = " as res %9.4f `pval'
	
		return matrix table = `A'
		 	
		if `phi' < . return hidden scalar phi = `phi'
		if `tau2' < . return hidden scalar tau2 = `tau2'
		return scalar `sta' = `stat'
		return scalar p = `pval'
		return scalar beta1 = `b'
		return scalar se = `b_se'
		return local model "`model'"
		return local method "`method'"
		return local moderators "`varlist'"
	}
	
	return local testtype "`egger'`harbord'`peters'"
end

program NotAllowedWithBegg
	
	syntax [, begg MULTiplicative TRADitional se(string) ///
				model(string) varlist(string)]
	
	if !missing("`begg'") {
		if !missing("`varlist'") {
			local l = wordcount("`varlist'")
			local word = plural(`l', "moderator")
			di as err "`word' {bf:`varlist'} not allowed with " ///
				"option {bf:begg}"
			exit 184	
		}
		if  (`:word count `model'' > 0) {
			di as err "{p}options {bf:random()}, {bf:random}, " ///
				  "{bf:common}, and {bf:fixed} not " ///
				  "allowed with option {bf:begg}{p_end}"
			exit 184	  
		}
		if !missing("`se'") {
			di as err "SE adjustment not allowed with option " ///
				"{bf:begg}"
			exit 184	
		}
		if !missing("`multiplicative'") {
			di as err "option {bf:multiplicative} not allowed " ///
				"with option {bf:begg}"
			exit 184	
		}
		if !missing("`traditional'") {
			di as err "option {bf:traditional} not allowed " ///
				"with option {bf:begg}"
			exit 184	
		}
	}
	
end

program NotAllowedWithCommon
	syntax [, model(string) varlist(string) MULTIPlicative] 
	
	if "`model'"=="common" & !missing("`varlist'") {
		di as err "{p}{bf:meta bias} with moderators not " ///
		"supported with a common-effect model{p_end}"
		di as err "{p 4 4 2}The declared model is a common-effect " ///
		  "model, which assumes no heterogeneity. Specifying " 	    ///
		  "moderators that account for potential heterogeneity is " ///
		  "not valid in this case. You may override this assumption" ///
		  " by specifying one of options {bf:fixed} or " ///
		  "{bf:random({it:remethod})}.{p_end}"
		exit 498    	
	}
	
	if "`model'"=="common" & !missing("`multiplicative'") {
		di as err "{p}option {bf:multiplicative} may not be " ///
			"specified with common-effect models{p_end}"
		di as err "{p 4 4 2}The declared model is a common-effect " ///
		  "model, which assumes no heterogeneity. Specifying a "    ///
		  "multiplicative variance that accounts for " 		///
		  "potential heterogeneity is not valid in this " ///
		  "case. You may override this assumption by specifying " ///
		  "one of options {bf:fixed} or {bf:random({it:remethod})}." ///
		  "{p_end}"
		exit 498    	
	}
end
