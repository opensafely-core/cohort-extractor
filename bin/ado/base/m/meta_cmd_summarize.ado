*! version 1.2.0  11jan2020
program meta_cmd_summarize, rclass
	version 16

	syntax [if] [in] [,				///
		sort(string)				/// 
		*]

	if "`sort'" != "" {
		tempname copy
		local curframe `c(frame)'
		frame copy `c(frame)' `copy'
		tempvar id o
		frame `copy' {
			local 0 `"`0' frame("`curframe'")"'
			SUMM `0'
		}
		return add
		
		gen `id' = _frval(`copy', _id_, _n)
		
		qui mata: ordwgt("`id'")
		
		if !missing(`"`transf_es_lbl'"') {
			local trvars "es cil ciu"
			foreach x of local trvars {
				cap drop _meta_`x'_transf
				qui gen double _meta_`x'_transf = ///
					_frval(`copy', _meta_`x'_transf, `o')
				label var _meta_`x'_transf `"`transf_`x'_lbl'"'	
			}
		}
		cap drop _meta_weight
		qui gen double _meta_weight = _frval(`copy', _meta_weight, `o')
		label var _meta_weight `"`wgtlbl'"'
	}
	else {
		SUMM `0'
	}
	
	return add
end


program SUMM, rclass
	version 16
	syntax [if] [in] [, _forestok *]
	if "`_forestok'" != "" {
		local forestopts "*"
	}
	local 0 `if' `in', `options'
	
	syntax [if] [in] [,				///
		noSTUDies				///
		nostudy					///
		random(string) 				///
		RANDOM1					///
		fixed(string)  				///
		FIXED1  				///
		common(string)  			///
		COMMON1  				///
		PREDINTerval1				///
		PREDINTerval(string)			///
		se(string)				///
		EForm(string)				///
		EFORM1					///
		or					///
		rr					///
		WGTvar(varname numeric)			/// Undoc
		noTABle					/// Undoc
		noFOOTer				/// Undoc
		sort(string)				/// 
		TRANSForm(string)			///
		TRANSForm1				/// Undoc
		frame(string)				/// Undoc
		i2(string)				///
		tau2(string)				///
		Level(string)				/// 
		CFormat(string)				///
		wgtformat(string)			///
		PFormat(string)				///
		SFormat(string)				///
		ordformat(string)			///
		CUMULative(string)			///
		SUBGRoup(varlist)			///
		TDISTribution				///
		noHEADer				///
		NOMETASHOW				///
		METASHOW1				///
		from(string)				///
		ITERate(string)				/// tau estim maxiter
		TOLerance(string)			/// tau estim itol
		NRTOLerance(string)			/// tau estim itol	
		NONRTOLerance				///
		SHOWTRace 				/// tau estim iter log
		`forestopts']
	
	if `=_N' == 0 error 3
	
	local forestopts `options'
	
	if !missing("`transform1'") {
		di as err "{p}you must specify a transformation in option " ///
			"{bf:transform()}{p_end}"
		exit 198
	}
	cap confirm variable _meta_es _meta_se
	if _rc {
		meta__notset_err	
	}
	
	if !missing("`footer'") local qfoot quietly
	if !missing("`table'") local qtab quietly
	if !missing("`header'") local qhead quietly
	
	if !missing("`cumulative'") {
		if !missing("`sort'") {
			di as err "options {bf:cumulative()} and " ///
				"{bf:sort()} may not be combined"
			exit 184	
		}
		_parseCumul ordervar byvar direction : `"`cumulative'"'
	}

	marksample touse 
	markout `touse' _meta_es _meta_se `wgtvar' `ordervar' 

	qui count if `touse'
	local nobs = r(N)
	
	if !`nobs' {
		di as err "no observations" 
		exit 2000
	}
	
	cap drop  _meta_weight
	if !missing("`se'") {
		meta__parse_seadj adjtype : `"`se'"'
	}
	if ("`adjtype'"=="khartung") local khartung khartung
	else if ("`adjtype'"=="tkhartung") local tkhartung tkhartung
	
	meta__eform_err, eform(`"`eform'"') `eform1' `or' `rr' ///
		transform(`"`transform'"')
	
	local re = subinstr("`random'", " ", "_", .)
	local fe = subinstr("`fixed'", " ", "_", .)
	local co = subinstr("`common'", " ", "_", .)
	local mod `"`re' `fe' `fixed1' `co' `common1' `random1'"'
	if  (`:word count `mod'' > 1) {
		meta__model_err, mh	  
	}
	
	if !missing("`se'") & !missing("`tdistribution'") {
		di as err "{p}options {bf:tdistribution} and {bf:se()} may " ///
			"not be combined{p_end}"
		exit 184	
	}
	
	opts_exclusive	`predinterval' `predinterval1'
	opts_exclusive	`studies' `study'
	if !missing("`metashow1'") & !missing("`nometashow'") {
		di as err ///
		"only one of {bf:metashow} or {bf:nometashow} is allowed"
		exit 198
	}
	// will create local -model- and -method-
	meta__model_method, random(`random') `random1' `fixed1' ///
		fixed(`fixed') `common1' common(`common')
	
	meta__parse_maxopts, from(`from') iter(`iterate') tol(`tolerance') ///			 
		nrtol(`nrtolerance') model(`model') method(`method') ///
		i2(`i2') tau2(`tau2') `nonrtolerance' `showtrace' 
	
	if !missing("`predinterval'") {
		meta__validate_level "`predinterval'"
		local predinterval `s(mylev)'
	}
	
	if !missing("`tau2'") & !missing("`i2'") {
		di as err "{p}options {bf:i2()} and {bf:tau2()} may not " ///
			"be combined{p_end}"
		exit 184	
	}
	if !missing("`tau2'") local fixvalue "tau2 `tau2'"
	if !missing("`i2'") local fixvalue "i2 `i2'"
	if !missing("`study'") local studies "nostudies"
	if !missing("`nonrtolerance'") local nrtolerance .
	
	if inlist("`model'", "fixed", "common") {
		local opt = cond(!missing("`fixed1'"), "fixed", ///
			cond(!missing("`common1'"), "common",   ///
			cond(!missing("`common'"), "common()",  ///
			cond(!missing("`fixed'"), "fixed()", ""))))
		if !missing("`khartung'`tkhartung'") & !missing("`opt'") {
			di as err "options {bf:se()} " ///
			  "and {bf:`opt'} may not be combined"	
			di as err "{p 4 4 2}Knapp-Hartung adjustment is " ///
			  "available only with random-effects models.{p_end}"
			exit 184
		}
		else if !missing("`khartung'`tkhartung'") & missing("`opt'") {
			di as err "{p}option {bf:se()}" ///
			  " may be specified only with random-effects " ///
			  "models{p_end}"				
			exit 198
		}
		if !missing("`fixvalue'") & !missing("`opt'") {
			di as err "options {bf:i2()} and {bf:tau2()} may " ///
			  "not be combined with option {bf:`opt'}"
			di as err "{p 4 4 2}Sensitivity analysis based on " ///
			  "fixing the value of {it:tau2} or {it:I2} is " ///
			  "available only with random-effects models.{p_end}"
			exit 184
		}
		else if !missing("`fixvalue'") & missing("`opt'") {
			di as err "{p}options {bf:i2()} and {bf:tau2()} " ///
			  "may be specified only with random-effects " ///
			  "models.{p_end}"
			exit 198
		}
		if !missing("`predinterval'`predinterval1'") {
			di as err "{p}options {bf:predinterval} and " ///
			  "{bf:predinterval(`predinterval')} may be " ///
			  "specified only with random-effects models{p_end}"
			  exit 198
		}			
	}
	local iscumul = cond(missing("`cumulative'"), "", "iscumul")	
	meta__parse_format, cformat("`cformat'") wgtformat("`wgtformat'") ///
		pformat("`pformat'") ordformat("`ordformat'") ///
		sformat("`sformat'") studies("`studies'") `iscumul'				
	
	local cformat `s(cformat)'
	local wgtformat `s(wgtformat)'
	local sformat `s(sformat)'
	local ordformat `s(ordformat)'
	local pformat `s(pformat)'
	
	if !missing("`wgtvar'")  & (!missing("`tkhartung'") | ///
		!missing("`khartung'") | !missing("`fixvalue'")) {
			di as err "{p}option {bf:wgtvar()} may not be " ///
			  "combined with options {bf:tau2()}, {bf:i2()}, " ///
			  "or {bf:se()}{p_end}"
			exit 184	
	}
	
	local estyp : char _dta[_meta_estype]
	local dtype : char _dta[_meta_datatype]
	
	if !missing("`or'`rr'") local eform1 eform1
	
	meta__validate_esize, dtype(`dtype') estype(`estyp') `eform1'
	local eslbl : char _dta[_meta_eslabel]

	meta__eslabel, `eform1' estype(`estyp') eslbl(`eslbl')
	local eslab = cond(missing(`"`eform'"'), "`s(eslab)'", `"`eform'"')
	local eslabvarmid "`s(eslabvarmid)'"	// for labeling sys wgtvar
	
	if missing("`level'") {
		local level  : char _dta[_meta_level]
	}
	else {
		meta__validate_level "`level'"
		local level `s(mylev)'
	}	
	
	local alpha = (100 -`level')/200
	
	
	if `"`cumulative'"' !=`""' & "`subgroup'" != "" {
		di as err "options {bf:cumulative()} and " ///
			"{bf:subgroup()} may not be combined"
		di as err "{p 4 4 2}If you wish to perform a cumulative " ///
		  "meta-analysis stratified by groups, you can " 	///
		  "specify {bf:cumulative(`cumulative', by(`subgroup'))}." ///
		  "{p_end}"	
		exit 184	  
	}
	
	local exponen = cond(missing(`"`eform1'`eform'"'),0,1)
	
	local studies = cond(missing("`studies'"),1,0)
	local iterlog = cond(missing("`showtrace'"), 0, 1)
	
	// _meta_weight changes with locally specified `method'
	// run it here so -sort(_meta_weight)- is allowed
	qui meta__compute_wgt, method(`method') touse(`touse') 		///
		eslbl(`eslabvarmid')
	qui compress _meta_weight
	c_local wgtlbl `"`: variable label _meta_weight'"'
	
	local iscumul = cond(missing("`cumulative'"), 0, 1)
	local nvars : word count `subgroup'
	local isover =  cond(`nvars'> 1, 1, 0)
	
	if !missing("`sort'") {	
		_parseSortvar "`touse'" svars vars : `"`sort'"'		
		qui gen _id_ = _n
		gsort `svars' _meta_id	// _meta_id used to break ties
		quietly meta update, keepweight keepstudylbl
	}
	
	if !missing(`"`transform'"') {
		// creates local legend 0/1 for fcn label above table
		meta__parse_transform fn invfn fnlbl : `"`transform'"'
	
		meta__compute_transf_vars, eslbl(`eslabvarmid') 	///
			fnlbl(`"`fnlbl'"') fn("`fn'") touse("`touse'")	
		
		c_local transf_es_lbl  `"`: variable label _meta_es_transf'"'
		c_local transf_cil_lbl `"`: variable label _meta_cil_transf'"'
		c_local transf_ciu_lbl `"`: variable label _meta_ciu_transf'"'
		
		local iscumover = cond(`iscumul' | `isover', 1,0)
		meta__set_transf_label, tr_fn("`tr_fn'") 		///
			fnlbl(`"`fnlbl'"') iscumul(`iscumul')		///
			isover(`isover') hidestudies(`=1-`studies'') 	
			
			
		local l_eslab `"`l_eslab'"' 
		local eslab `"`t_eslab'"'

		local abvtbl_l `"`abvtbl_l'"'
		local overall = cond(`=`iscumover' + (1-`studies')', 	///
			"Overall ", "")
		local fcn "`fn'"
		if ("`fcn'" == "-expm1(@)") local fcn "1 - exp(@)"
		local abvtbl_r  = cond(ustrlen(`"`fnlbl'"') < 12, 	///
			"`fcn'", `"`overall'`fnlbl'"')
	}
	
	
	// compute width of id column 
	qui mata: __compute_idcolwidth("`touse'", `iscumul', `isover')
	local idcolwidth = r(idw)
	local fixwidth = r(fixwidth)
	
	if `isover' & !missing("`sort'") {
		di as err "option {bf:sort()} not allowed with multiple " ///
			"{bf:subgroup()} variables"
		exit 198	
	}
	
	return hidden local fp_eslab = cond(missing(`"`transform'"'), ///
		`"`eslab'"', `"`fp_eslab'"')
	return hidden local forestopts `forestopts'
	return local model `model'
	return local method `method'
	return scalar level = `level'
	return scalar N = `nobs'
	tempname N
	mat `N' = `nobs'
	return hidden matrix _N = `N'
	
	local global_metashow : char _dta[_meta_show]	
	
	return hidden scalar eform = `exponen'
	return hidden scalar transform = cond(missing(`"`transform'"'), 0, 1)
	return hidden local transf = "`fn'"
	return hidden local invtransf = "`invfn'"
	
	if !missing("`subgroup'") {
		FixSeTdistErr, opt(subgroup) f(`fixvalue') t(`tkhartung') ///
			k(`khartung') tdist(`tdistribution') ///
			pint(`predinterval'`predinterval1')
		
		if missing("`nometashow'`global_metashow'") | ///
			!missing("`metashow1'") {
			di
			meta__esize_desc, col(3) showstudlbl			
		}
		
		
		local pos = `=`fixwidth' +`idcolwidth'+2 - 24' 
		local pos = cond(`nvars'==1,cond(`studies',`pos',54 ),`pos') -1 
		
		`qhead' meta__header_desc, nobs(`nobs') anal(Subgroup) ///
			model(`model') meth(`method') col(`pos') ///
			subgr(`subgroup') sortvar(`"`vars'"')
		return add
		di
		if  (`nvars' == 1) {
			cap confirm numeric variable `subgroup'
			if !_rc {	
				markout `touse' `subgroup'
				`qtab' mata: _sma_subgr("`subgroup'", ///
					"`method'", `exponen', `studies', ///
					"`touse'", `iterate', `tolerance', ///
					`iterlog', `nrtolerance')
			}
			else {
				tempvar grp
				encode `subgroup', gen(`grp')
				markout `touse' `grp'
				`qtab' mata: _sma_subgr("`grp'","`method'", ///
					`exponen', `studies', "`touse'", ///
					`iterate', `tolerance', `iterlog', ///
					`nrtolerance')
			}
			return scalar Q_b = r(Q_b)
			return scalar df_Q_b = r(df_Q_b)
			return scalar p_Q_b = r(p_Q_b)
		}
		else {	
			foreach var of varlist `subgroup' {
				cap confirm numeric variable `var'
				if (!_rc) {
					local over "`over' `var'"
				}
				else {
					tempvar grp
					encode `var', gen(`grp')
					local over "`over' `grp'"
				}
			}
			markout `touse' `over'
			`qtab' mata: _sma_over("`over'", "`method'", ///
				`exponen',"`touse'", `iterate', `tolerance', ///
				`iterlog', `nrtolerance')
		}
		
		local msg "Convergence not achieved during tau2 estimation "
		if ("`isERROR'"=="1") {
			di as err "`msg'"
			exit 430
		}	
		local  iswarn `isWARNING'
		if "`iswarn'"=="1" di as txt "Warning: `msg'"
		return local subgroupvars "`subgroup'"
		
		tempname esgr hetgr diffgr	
		mat `esgr' = r(esgroup)
		return matrix esgroup = `esgr'
		
		if "`model'"!= "common" {
			mat `hetgr' = r(hetgroup)
			return matrix hetgroup = `hetgr'
		}
		
		mat `diffgr' = r(diffgroup)
		return matrix diffgroup = `diffgr'
		
		tempname G O B N res // grp, overall, between results, #of rows
		mat `G' = r(grres)
		return hidden matrix grres = `G'
		mat `O' = r(ores)
		return hidden matrix ores = `O'
		mat `B' = r(btwgrres)
		return hidden matrix btwgrres = `B'
		mat `N' = r(_N)
		return hidden matrix _N = `N'
		mat `res' = r(res)
		return hidden matrix res = `res'
		if (!missing(`"`transform'"') | `exponen') {
			tempname res_transf
			mat `res_transf' = r(res_transf)
			return hidden matrix res_transf = `res_transf'
		}
		exit
	}
	
	if !missing("`cumulative'") {
		FixSeTdistErr, opt(cumulative) f(`fixvalue') t(`tkhartung') ///
			k(`khartung') tdist(`tdistribution') ///
			pint(`predinterval'`predinterval1')
		
		local anal "Cumulative"
		if missing("`direction'") local direction ascending
		local bvar "`byvar'"
		if !missing("`byvar'") {
			cap confirm numeric variable `byvar'
			if _rc {
				tempvar grp
				encode `byvar', gen(`grp')
				local bvar "`grp'"
			}
			markout `touse' `bvar'
			local anal "Stratified cumulative"
		}
		// markout `touse' `ordervar' `bvar'
		if missing("`nometashow'`global_metashow'") | ///
			!missing("`metashow1'") {
			di
			meta__esize_desc, col(3) showstudlbl	
		}
		local pos = `fixwidth' + `idcolwidth'+2 - 25  
						   // 25 =length(Number of..)-1	
		
		`qhead'	meta__header_desc, nobs(`nobs') anal(`anal') ///
			model(`model') meth(`method') col(`pos') ///
			cumulative(`cumulative')
		return add
		di
			
	`qtab' mata: (void) _sma_cuml("`ordervar'", "`bvar'", "`method'", ///
			 `exponen', "`direction'", "`touse'", `iterate', ///
			  `tolerance', `nrtolerance')
		
		
		local msg "Convergence not achieved during tau2 estimation "
		if ("`isERROR'"=="1") {
			di as err "`msg'"
			exit 430
		}	
		local  iswarn `isWARNING'
		if "`iswarn'"=="1" di as txt "Warning: `msg'"
		return local subgroupvars "`subgroup'"
		
		tempname res N 
		mat `res' = r(cumres)
		mat `N' = r(_N)
		return matrix cumul = `res', copy
		return hidden matrix res = `res'
		return hidden matrix _N = `N'
		return local byvar "`byvar'"
		return local ordervar "`ordervar'"
		return local direction "`direction'"
		if (!missing(`"`transform'"') | `exponen') {
			tempname res_transf
			mat `res_transf' = r(res_transf)
			return hidden matrix res_transf = `res_transf'
		}
		exit
	}
	
	
	tempname theta_info Q th seth zval i2 h2 tau2 qkh ll LogLik
	if !missing("`wgtvar'") {
		if "`method'"=="mhaenszel" {
			di as err "{p}user-defined weights not available " ///
				"with the Mantel-Haenszel method{p_end}"
			exit 498	
		}
		cap assert `wgtvar' > 0
		if _rc {
			di as err "{p}weight variable {bf:`wgtvar'} must " ///
				"contain nonnegative values in option " ///
				"{bf:wgtvar()}{p_end}"
			exit 402
		}
		local lbl : var label `wgtvar'
		if missing("`lbl'") {
			local lbl "user-defined weights by var. `wgtvar'"
		}
		qui replace _meta_weight = `wgtvar' if `touse'
		label var _meta_weight `"`lbl'"'
		mata: st_matrix("`theta_info'", _sma_wgt("_meta_es", ///
			"`wgtvar'", "`touse'"))
					
		local cont cont	
		local anal "Sensitivity"
	}
	else if !missing("`fixvalue'") {
		gettoken param val : fixvalue
		
		cap confirm number `val' 
		if _rc { 
			di as err "in option {bf:`param'()}: " _c
			confirm number `val'
		}
		if inlist("`param'", "tausq", "tau2") {
			cap assert `val' >= 0
			if _rc {
				di as err "{p}in option {bf:tau2({it:#})}: " ///
				"{it:#} must be a nonnegative number{p_end}"
				exit 198
			} 
		}
		if inlist("`param'", "isq", "i2") {
			cap assert `val' >= 0 & `val' < 100
			if _rc {
				di as err "{p}in option {bf:i2({it:#})}: " ///
				"{it:#} must be a number in [0,100){p_end}"
				exit 198
			} 
		}
		local istau2 = cond(inlist("`param'", "tausq", "tau2"), 1 , 0 )
		mata: st_matrix("`theta_info'", _sma_iv_fixval("_meta_es", ///
			"_meta_se", `val', `istau2', "`touse'"))
		
		local method "sa"
		local model random
		local cont cont
		local anal "Sensitivity"
		
	}
	else if "`method'" == "mhaenszel" {
		
		mata: st_matrix("`theta_info'", _sma_mh("_meta_es", ///
			"`estyp'", "`touse'"))
		
	}
	else {
		mata: st_matrix("`theta_info'", _sma_iv("_meta_es", ///
			"_meta_se", "`method'", "`touse'", `iterate', ///
			`tolerance', `iterlog', `nrtolerance')) 
		
		local msg "Convergence not achieved during tau2 estimation "
		if ("`isERROR'"=="1") {
			di as err "`msg'"
			exit 430
		}	
		scalar `ll' = cond(r(LogLik) < ., r(LogLik), .)
		if `ll' < . return hidden scalar ll     = `ll'
		local  iswarn `isWARNING'
	}
	tempname res res2 res_transf
	mat `res' = r(res)
	mat `res2' = r(res)
	
	//return hidden matrix res = `res'	
	
	local df = `nobs' - 1
	
	scalar `th' = `theta_info'[1,1]
	scalar `seth' = `theta_info'[1,2]	
	scalar `tau2' = `theta_info'[1,5]
	scalar `Q' = `theta_info'[1,6]
	scalar `i2' = `theta_info'[1,7]
	scalar `h2' = `theta_info'[1,8]
	
	local stat "z"
	
	// qkh will be missing with mhaenszel
	scalar `qkh' = (`theta_info'[1,9])/`df' 
	return hidden scalar qkh = `qkh'
	tempname Qkh th_lb th_ub
	scalar `th_lb' = `theta_info'[1,3]
	scalar `th_ub' = `theta_info'[1,4]
							
	if !missing("`tkhartung'`khartung'")  & ("`model'"=="random") {
		scalar `Qkh' = ///
			cond(!missing("`tkhartung'"), max(`qkh', 1),`qkh')
		scalar `seth' = sqrt(`Qkh')*`seth'
		local stat "t"
		scalar `th_lb' = `th' + invt(`df', `alpha')*`seth'
		scalar `th_ub' = `th' + invt(`df', 1-`alpha')*`seth'
		mat `res'[1,2] = `seth'
		mat `res'[1,3] = `th_lb'
		mat `res'[1,4] = `th_ub'
		mat `res'[1,13] = `th'/`seth'
		mat `res'[1,14] = 2*(1-t(`df', abs(`th'/`seth')))
		local dfinfo `"as txt "(" as res `df' as txt ")""'
		return scalar seadj = `qkh'
	}
	
	return hidden matrix res = `res'
	
	// prediction interval
	if "`model'" == "random" & !missing("`predinterval'`predinterval1'") {
		tempname pil piu
		
		if (missing("`predinterval'")) local predinterval = 95
		local pi_alpha = (100 - `predinterval') / 200
			
		scalar `pil' = `th' + invt(`df'-1, `pi_alpha')* ///
			sqrt(`seth'^2 + `tau2')
		scalar `piu' = `th' + invt(`df'-1, 1-`pi_alpha')* ///
			sqrt(`seth'^2 + `tau2')
		return scalar pi_lb = `pil'
		return scalar pi_ub = `piu'
		return scalar pilevel = `predinterval'
	}
	if !missing("`tdistribution'") {
		local stat "t"
		scalar `th_lb' = `th' + invt(`df', `alpha')*`seth'
		scalar `th_ub' = `th' + invt(`df', 1-`alpha')*`seth'
		local dfinfo `"as txt "(" as res `df' as txt ")""'
	}

	return scalar Q     = `Q'
	
	if "`model'"=="common" {
		local hidce hidden
	}
	if "`model'"=="fixed" {
		local hidce 
		local hidfe hidden
	}
	
	return `hidce' scalar I2    = `i2'
	return `hidce' scalar H2    = `h2'	 
	return `hidce' `hidfe' scalar tau2 = `tau2'
		
	return scalar theta    = `th'
	return scalar se = `seth'
	return scalar ci_lb = `th_lb'
	return scalar ci_ub = `th_ub'
	
	return local model `model'
	return local method `method'
	return scalar level = `level'
	
	if "`model'"=="common" {
		local hidce hidden
	}
	
	return `hidce' scalar df_Q = `df'
	
	if !missing("`se'") return local seadjtype = ///
		cond("`adjtype'"=="khartung", "knapp-hartung", ///
			"truncated knapp-hartung")
	return hidden scalar khartung = cond(missing("`khartung'"),0,1)
	return hidden scalar tkhartung = ///
		cond(missing("`tkhartung'"),0,1)
	
	//----- Above table info
	
	if missing("`nometashow'`global_metashow'") | !missing("`metashow1'") {
		di
		meta__esize_desc, col(3) showstudlbl
	}
	
	local pos = cond(`studies', `=`fixwidth' +`idcolwidth'+2 - 24', 54 )- 1
		
	`qhead'	meta__header_desc, nobs(`nobs') tau2(`tau2') i2(`i2') ///
		h2(`h2') model(`model') meth(`method') col(`pos') ///
		se(`adjtype') fixparam(`param') anal(`anal') ///
		wgt(`wgtvar') sortvar(`"`vars'"')
	return add
	
	//--------- output table
	if (("`model'"!= "fixed") | "`studies'"=="0") di

	`qtab' mata: __di_meta_summ(`exponen', 1, `studies', "`touse'")
	
	mat `res_transf' = r(res_transf)
	mat `res_transf' = `res_transf', `res2'[1, 5...]
	if (!missing(`"`transform'"') | `exponen') {	
		ret hidden matrix res_transf = `res_transf'
	}	
	if inlist("`method'", "reml", "ml", "ebayes", "pmandel") {
			return scalar converged = 1
	}
	if "`iswarn'"=="1" {
		di as txt "Warning: `msg'"
		return scalar converged = 0
	}	
		
	scalar `zval' = `th'/`seth'
	tempname pval
	if !missing("`khartung'`tkhartung'") {
		scalar `pval' = 2*(1-t(`df', abs(`zval')))
	}
	else {
		scalar `pval' = 2*(1-normal(abs(`zval')))
	}
	// pvalue for H0: ES = 0 
	return scalar p = `pval'
	if "`stat'"=="z" return scalar z = `zval'
	else {
		return scalar t = `zval'
		return scalar df= `df'
	}
	
	//---------- Footer
	if !missing("`predinterval'`predinterval1'") {
		local pil = cond(`exponen', exp(`pil'), `pil')
		local piu = cond(`exponen', exp(`piu'), `piu')
		if !missing(`"`transform'"') {
			local pil = `=subinstr("`fn'", "@", "`pil'",.)'
			local piu = `=subinstr("`fn'", "@", "`piu'",.)'
		}
		local thetalbl = cond(`exponen', "exp(theta)", ///
			cond(!missing(`"`transform'"'), "f(theta)", "theta"))
		`qfoot' di as res `predinterval' as txt ///
			"% prediction interval " ///
			"for `thetalbl': [" as res %6.3f `pil' as txt "," ///
			as res %6.3f `piu' as txt "]" _n
	}
	// fixcolwidth(49) + 1 (space) + 1 added to id_w - 18 (strlen(Prob > .))
	local pos = cond(`studies', `fixwidth' + `idcolwidth'+2 - 18, 60)
	if `studies' {
		if !missing("`sort'") {
			`qfoot' di as txt "Sorted by: " as res `"`vars'"'
		}
		`qfoot' di as txt "Test of theta = 0: `stat'" ///
		`dfinfo' as txt " = " ///
		as res %3.2f = `zval' as txt ///
		 _col(`pos') "Prob > |`stat'| = " as res %5.4f = `pval'
	}
	if "`model'"!= "common" {
		`qfoot' di as txt "Test of homogeneity: Q = chi2(" ///
		as res `df' ///
		as txt ") = " as res %3.2f = `Q' as txt _col(`=`pos'+2') ///
		"Prob > Q = " as res %5.4f = chi2tail(`df', `Q')
	}
	return `hidce' scalar p_Q = chi2tail(`df', `Q')
	
end


program FixSeTdistErr
	syntax [, opt(string) f(string) t(string) k(string) ///
		tdist(string) pint(string)]
	
	if !missing("`f'") {
			di as err "{p}options {bf:tau2()} and {bf:i2()}" ///
				" may not be combined with option " ///
				"{bf:`opt'()}{p_end}"
			exit 184
		}
	if !missing("`t'`k'") {
		di as err "{p}option {bf:`opt'()} may not be " ///
			"combined with option {bf:se()}{p_end}"
		exit 184
	}
	if !missing("`tdist'") {
		di as err "{p}option {bf:tdistribution} may not be " ///
			"combined with option {bf:`opt'()}{p_end}"
		exit 184
	}
	if !missing("`pint'") {
		di as err "{p}options {bf:predinterval()} and " ///
			"{bf:predinterval} may not be combined with option " ///
			"{bf:`opt'()}{p_end}"
		exit 184
	}
	
end

program _parseCumul
	args ordervar byvar direction colon cumulspec
	
	_parse comma lhs rhs : cumulspec
	local 0 `lhs'
	cap syntax varname(numeric)
	local rc = _rc
	if _rc {
		di as err "in option {bf:cumulative()}: " _c
		local msg = cond(_rc==111,"variable {bf:`lhs'} not found", ///
			"{bf:`lhs'} must be a numeric variable")
		di as err "`msg'"
		exit `rc'
	}
	c_local `ordervar' "`varlist'"

	if "`rhs'" == "" | "`rhs'" == "," {
		c_local `byvar' ""	
	}
	else {
		local 0 `rhs'
		syntax [, by(varname) ASCending DESCending *]
		opts_exclusive "`ascending' `descending'" cumulative
		if "`options'" != "" {
			di as err "in option {bf:cumulative()}: " _c
			di as err "option {bf:`options'} is not allowed"
			exit 198
		}
		if !missing("`by'") {
			cap confirm variable `by'
			if _rc {
				di as err "{p}in option {bf:cumulative()}: " ///
				  "variable {bf:`by'} not found in " ///
				  "suboption {bf:by()}{p_end}" 
				exit _rc
			}
			else if `: word count `by'' > 1 {
				di as err "invalid option {bf:by()}: too " ///
				" many variables specified"
				exit 103
			}
			c_local `byvar' "`by'"
		}
		
		c_local `direction' "`ascending'`descending'"
	} 
end

program _parseSortvar
	args touse sortvars svarnames colon sortspec
	
	local 0 `sortspec'
	local syntax syntax varlist [, ASCending DESCending *]
	capture `syntax'
	if c(rc) {
		di as err "option {bf:sort()} invalid;"
		`syntax'
		error 198	
	}
	opts_exclusive "`ascending' `descending'" sort
	if `:length local options' {
		gettoken tok : options, bind
		di as err "option {bf:sort()} invalid;"
		di as err "option {bf:`tok'} not allowed"
		exit 198
	}
	markout `touse' `varlist', strok
	if "`descending'" != "" {
		local sort
		foreach var of local varlist {
			local sort `sort' -`var'
		}
	}
	else {
		local sort : copy local varlist
	}
	
	c_local `sortvars' `"`sort'"'
	c_local `svarnames' `"`varlist'"'
end
