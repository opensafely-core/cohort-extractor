*! version 1.0.4  26feb2019
program _eprobit_mean
	version 15
	syntax, varn(string) [vart(string)] eq(string)		/// 
		[cond(string)] outcomeorder(string) 		///
		touse(string)					///
		intpoints(string) intpoints3(string)		///
		[pomeaneq(string) pomeanval(string) 		///
		base(string)					///
		defaultpr pomeanasf target(string) noOFFSET]

	local linear `e(endogdepvars)' `e(tseldepvar)'
	local linearlist: list linear & cond
	local catlist: list cond - linearlist

	if "`e(cutsinteract)'" != "" & "`eq'" == "`e(odepvar)'" {
		local abname = ustrleft("`eq'",32-6)
		local cutlpref ///
		/`abname':`pomeanval'.`e(extrdepvar)'`e(trdepvar)'
	}
	tempname allcatvals catvals 
	tempname isbinary nvals
	matrix `allcatvals' = e(catvals)
	matrix `isbinary' = e(binary)
	matrix `nvals' = e(nvals)
	local rowscat = rowsof(`allcatvals')
	local i = colnumb(`allcatvals',"`eq'")	
	mata:st_matrix("`catvals'",	///
		st_matrix("`allcatvals'")[1..`rowscat',`i'])
	tempname tfullvar
	if "`e(pocovariance)'" != "" {
		matrix `tfullvar' = e(varfull1)
	}
	else {
		matrix `tfullvar' = e(varfull)
	}
	if "`c(marginsatvars)'" != "" {
		local addtobase
		local marginsatvars `c(marginsatvars)'
		local marginsatdvars `e(_erm_marginsatvarsd)'
		local allcatvars: colnames `allcatvals'
		foreach lav of local marginsatvars {
			gettoken dvar marginsatdvars: marginsatdvars
			_ms_parse_parts `lav'
			if "`r(type)'" == "factor" {
				local name `r(name)'
				local atlevel `r(level)'
				local init: list name in allcatvars
				if `init' {
					tab `dvar' if `touse', missing
					capture assert ///
					`dvar'==0 | `dvar' ==1 if `touse'
					local a di as error
					if _rc {
						`a' "{p 0 4 2} fractional "
						`a' "values for categorical "
						`a' "variables in {bf:at()} "
						`a' "are not supported "
						`a' "with {bf:`e(cmd)'}{p_end}"
						exit 498
					}
					qui count if `dvar'==1 & `touse'
					if (r(N) > 0) {
						local addtobase `addtobase' ///
						`name' = `atlevel'
					}
				}
			}
		}
		local base `addtobase' `base'
		local target `addtobase' `target'
	}
	local i = colnumb("`tfullvar'",`"`eq'"')
	local catindlist `i'
	tempname cat1 catcond1
	if "`pomeaneq'" != "" {
		nobreak {
			local pomeanvartype: type `pomeaneq'
			tempvar storpomean
			qui gen `pomeanvartype' `storpomean' = `pomeaneq'
			qui replace `pomeaneq' = `pomeanval'		
			qui _predict double `cat1' if `touse', ///
				xb equation(`eq') `offset'
	if "`e(pocovariance)'" != "" {
		local npotreat = wordcount("`e(pocovariance_vals)'")
		tempvar pocovariance_depvar
		qui gen byte `pocovariance_depvar' = .
		GenTreat, pocovariance_depvar(`pocovariance_depvar') ///
				pomeanval(`pomeanval') touse(`touse')
		forvalues i = 1/`npotreat' {
			tempvar touse`i'
			local val: word `i' of `e(pocovariance_vals)'
			qui gen byte `touse`i'' = `touse' & ///
				`pocovariance_depvar'==`val'
			tempname fullvar`i'
			matrix `fullvar`i'' = e(varfull`val')
		}
	}
	else {
		local npotreat 1
		tempname fullvar1
		matrix `fullvar1' = e(varfull)
		tempvar touse1
		qui gen byte `touse1' = `touse'	
	}
			qui replace `pomeaneq' = `storpomean'
		}
	}
	else {
		nobreak {
			// go through fixed values
			ParseUbase, u(`target') target
			local nvarstarg = `r(nvars)'
			forvalues i = 1/`nvarstarg' {
				local targdepvar`i' `r(var`i')'
				tempvar otarg`i'
				local stotype: type `targdepvar`i''
				qui gen `stotype' `otarg`i'' ///
					= `targdepvar`i'' ///
					 if `touse'
			}
			forvalues i = 1/`nvarstarg' {
				tempvar targindepvar`i'
				capture qui gen double `targindepvar`i'' ///
					= `r(expr`i')' if `touse'
				if _rc {
					di as error "{bf:target()} invalid; "
					qui gen double `targindepvar`i'' ///
						= `r(expr`i')' if `touse'
				}
				qui replace `targdepvar`i'' ///
					= `targindepvar`i'' if `touse'
			}
			if `"`e(extrdepvar)'`e(trdepvar)'"' != "" {
				tempvar otdepvar
				qui gen double `otdepvar' = ///
					`e(extrdepvar)'`e(trdepvar)'
			}
			qui _predict double `cat1' if `touse', ///
				xb equation(`eq') `offset'
	if "`e(pocovariance)'" != "" {
		local npotreat = wordcount("`e(pocovariance_vals)'")
		tempvar pocovariance_depvar
		qui gen byte `pocovariance_depvar' = .
		GenTreat, pocovariance_depvar(`pocovariance_depvar') ///
				pomeanval(`pomeanval') touse(`touse')
		forvalues i = 1/`npotreat' {
			tempvar touse`i'
			local val: word `i' of `e(pocovariance_vals)'
			qui gen byte `touse`i'' = `touse' & ///
				`pocovariance_depvar'==`val'
			tempname fullvar`i'
			matrix `fullvar`i'' = e(varfull`val')
		}
	}
	else {
		local npotreat 1
		tempname fullvar1
		matrix `fullvar1' = e(varfull)
		tempvar touse1
		qui gen byte `touse1' = `touse'	
	}
			forvalues i = 1/`nvarstarg' {
				qui replace `targdepvar`i'' = ///
					`otarg`i'' if `touse'
			}
		}
	}
	if "`pomeanasf'" != "" {
		tempvar holder ul1 ll1 catcond1
		qui gen double `catcond1' = `cat1' if `touse'
		qui gen double `holder' = . if `touse'
		if `isbinary'[1,colnumb(`isbinary',"`eq'")] == 1 {
			qui gen double `ul1' = -`catcond1' if	/// 
				`outcomeorder'==1 & `touse'
			qui gen double `ll1' = -1000 if ///
				`outcomeorder' == 1 & `touse'
			qui replace `holder' = normal(`ul1') if ///
				`outcomeorder'==1 & `touse'
			qui replace `ul1' = 1000 if ///	 
				`outcomeorder' == 2 & `touse'	
			qui replace `ll1' = -`catcond1' if	/// 
				`outcomeorder'==2 & `touse'
			qui replace `holder' = normal(-`ll1') if ///
				`outcomeorder'==2 & `touse'			
		}
		else {
			qui gen double `ll1' = -1000 if ///
				`outcomeorder'==1 & `touse'
			local abname = ustrleft("`eq'",32-6)
			if "`e(cutsinteract)'" == "" {
				qui gen double `ul1'=(_b[/`abname':cut1]- ///
					`catcond1') if		/// 
					`outcomeorder'==1 & `touse'
			}
			else  {
				qui gen double `ul1' = 	///
				(_b[`cutlpref'#cut1] 	///
				- `catcond1') if	///
				`outcomeorder' == 1 & `touse'
			}
			qui replace `holder' = normal(`ul1') if ///
				`outcomeorder'==1 & `touse'	
			local k = `nvals'[1,colnumb(`nvals',"`eq'")]
			local km1 = `k' - 1
			forvalues i=2/`km1' {
				local j = `i'-1
				if "`e(cutsinteract)'" == "" {
					qui replace `ll1' = 		///
						(_b[/`abname':cut`j']-	///
						`catcond1') if		///
						`outcomeorder'==`i' & `touse'
					qui replace `ul1'=		///
						(_b[/`abname':cut`i']-	///
						`catcond1') if		///
						`outcomeorder'==`i' & `touse'
				}
				else {
					qui replace `ll1' = 		///
						(_b[`cutlpref'#cut`j']-	///
						`catcond1') if		///
						`outcomeorder'==`i' & `touse'
					qui replace `ul1'=		///
						(_b[`cutlpref'#cut`i']-	///
						`catcond1') if		///
						`outcomeorder'==`i' & `touse'	
				}
				qui replace `holder' =	/// 
					normal(`ul1')-	///
					normal(`ll1') 	///
					if `outcomeorder'==`i' & `touse'
			}
			local k = `k'-1
			if "`e(cutsinteract)'" == "" {
				qui replace `ll1' =			/// 
				(_b[/`abname':cut`k']-`catcond1') if 	///
					`outcomeorder'==`k'+1 & `touse'
				qui replace `ul1' = 1000 if 		///
					`outcomeorder'==`k'+1 & `touse'	
			}
			else {
				qui replace `ll1' =			/// 
				(_b[`cutlpref'#cut`k']-`catcond1') if 	///
					`outcomeorder'==`k'+1 & `touse'
				qui replace `ul1' = 1000 if 		///
					`outcomeorder'==`k'+1 & `touse'	
			}
			qui replace `holder' = normal(-`ll1') if ///
				`outcomeorder'==`k'+1 & `touse'		
		}		
		gen `vart' `varn' = `holder' if `touse'	
		local eqval = `allcatvals'[`outcomeorder',	///
			colnumb(`allcatvals',"`eq'")]
		_ms_parse_parts `eq'
		if "`r(ts_op)'" != "" {
			local leqval: value label `r(name)'
		}
		else {
			local leqval: value label `eq'
		}
		if "`leqval'" != "" {
			local leqval: label `leqval' `eqval'
		}
		else {
			local leqval `eqval'
		}
		_ms_parse_parts `pomeaneq'		
		if "`r(ts_op)'" != "" {
			local lpomeanval: value label `r(name)'
		}
		else {
			local lpomeanval: value label `pomeaneq'
		}
		if "`lpomeanval'" != "" {
			local lpomeanval: label `lpomeanval' `pomeanval'
		}
		else {
			local lpomeanval `pomeanval'
		}
		if wordcount("`e(depvar_dvlist)'") > 1 {		
			local lab Structural potential-outcome mean ///
			Pr(`eq'==`leqval'), `pomeaneq': `lpomeanval'
		}
		else {
			local lab potential-outcome mean ///
			Pr(`eq'==`leqval'), `pomeaneq': `lpomeanval'
		}
		label variable `varn' `"`lab'"' 
		exit
	}	
	local catxblist `cat1'
	qui gen double `catcond1' = .
	local catcondlist `catcond1'
	local j = 2

	if "`base'" != "" {
		ParseUbase, u(`base') base
		local nvarsbase = `r(nvars)'
		forvalues i = 1/`nvarsbase' {
			local basedepvar`i' `r(var`i')'
			tempvar obase`i'
			local stotype: type `basedepvar`i''
			qui gen `stotype' `obase`i'' = `basedepvar`i'' ///
				 if `touse'
		}
	}
	local nb break
	if "`base'" != "" {
		local nb nobreak
	}
capture noi `nb' {
	if "`base'" != "" {
		forvalues i = 1/`nvarsbase' {
			tempvar baseindepvar`i'
			capture qui gen double `baseindepvar`i'' ///
				= `r(expr`i')' if `touse'
			if _rc {
				di as error "{bf:base()} invalid; "
				qui gen double `baseindepvar`i'' ///
					= `r(expr`i')' if `touse'
			}
			qui replace `basedepvar`i'' = `baseindepvar`i'' ///
				if `touse'
		}
	}

	foreach name of local catlist {
		local i = colnumb(`allcatvals',"`name'")
		mata:st_matrix("`catvals'", (st_matrix("`catvals'"),	///
			st_matrix("`allcatvals'")[1..`rowscat',`i']))
		local i = colnumb(`fullvar1',"`name'")
		local catindlist `catindlist', `i'
		tempname cat`j'
		qui _predict double `cat`j'' if `touse', ///
			xb equation(`name') `offset'
		local catxblist `catxblist' `cat`j''
		tempname catcond`j'
		qui gen double `catcond`j'' = .
		local catcondlist `catcondlist' `catcond`j''
		local j = `j' + 1
	}
	local linearindlist
	local linearresidlist
	local j = 1
	foreach name of local linearlist {
		local i = colnumb(`fullvar1',"`name'")
		if "`linearindlist'" == "" {
			local linearindlist `i'
		}
		else {
			local linearindlist `linearindlist',`i'
		}
		tempname linearresid`j'
		qui _predict double `linearresid`j'' if `touse', ///
			xb equation(`name') `offset'
		qui replace `linearresid`j'' = ///
			`name' - `linearresid`j'' if `touse'		
		local linearresidlist `linearresidlist' `linearresid`j''
		local j = `j' + 1
	}
	tempname catindmat
	capture matrix `catindmat' = (`catindlist')
	tempname linearindmat
	capture matrix `linearindmat' = (`linearindlist')

	forvalues i = 1/`npotreat' {
		tempname condvarfull`i' 
		mata: eprobit_cond_mean_var("`fullvar`i''",		///
				"`catindmat'",				///
				"`linearindmat'", "`catcondlist'",	///
				"`catxblist'","`linearresidlist'",	///
				"`touse`i''","`condvarfull`i''")
	}

	local toplowerlist
	local topupperlist
	local botlowerlist
	local botupperlist
	tempname ll1 ul1
	if `isbinary'[1,colnumb(`isbinary',"`eq'")] == 1 {
		qui gen double `ul1' = .
		forvalues i = 1/`npotreat' {
			qui replace `ul1' = -`catcond1'/	///
				sqrt(`condvarfull`i''[1,1]) if	/// 
				`outcomeorder'==1 & `touse`i''
		}
		qui gen double `ll1' = -1000 if `outcomeorder' == 1 & `touse'
		qui replace `ul1' = 1000 if `outcomeorder' == 2 & `touse'
		forvalues i = 1/`npotreat' {	
			qui replace `ll1' = -`catcond1'/	///
				sqrt(`condvarfull`i''[1,1]) if	/// 
				`outcomeorder'==2 & `touse`i''
		}		
	}
	else {
		qui gen double `ll1' = -1000 if `outcomeorder'==1 & `touse'
		if "`e(cutsinteract)'" == "" | "`eq'" != "`e(odepvar)'" {
			local abname = ustrleft("`eq'",32-6)
			qui gen double `ul1' = .
			forvalues i = 1/`npotreat' {
				qui replace `ul1' = ///
					(_b[/`abname':cut1] - `catcond1')/ ///
					sqrt(`condvarfull`i''[1,1]) if	   /// 
					`outcomeorder'==1 & `touse`i''
			}
		}
		else if "`pomeanval'" != "" {
			qui gen double `ul1' = .
			forvalues i = 1/`npotreat' {
				qui replace `ul1' = ///
					(_b[`cutlpref'#cut1] - `catcond1')/ ///
					sqrt(`condvarfull`i''[1,1]) if      ///
					`outcomeorder'==1 & `touse`i''
			}
		}
		else {
			qui gen double `ul1' = .
			foreach val of numlist `e(trvalues)'`e(extrvalues)' {
				local abname = ustrleft("`eq'",32-6)
				local cutlpref ///
				/`abname':`val'.`e(extrdepvar)'`e(trdepvar)'
				forvalues i = 1/`npotreat' {
					qui replace `ul1' = 		///
						(_b[`cutlpref'#cut1] - 	///
						`catcond1')/ 		///
					sqrt(`condvarfull`i''[1,1]) if	/// 
					`outcomeorder'==1 & 		///
					`otdepvar'==`val' &		///
					`touse`i''
				}
			}
		}
		local k = `nvals'[1,colnumb(`nvals',"`eq'")]
		local km1 = `k' - 1
		forvalues i=2/`km1' {
			local j = `i'-1
			if "`e(cutsinteract)'" == "" | ///
				"`eq'" != "`e(odepvar)'" {
				forvalues l = 1/`npotreat' {			
					qui replace `ll1' = 		///
					(_b[/`abname':cut`j']		///
					-`catcond1')/			///
					sqrt(`condvarfull`l''[1,1]) if	///
					`outcomeorder'==`i' & `touse`l''
					qui replace `ul1'=		///
					(_b[/`abname':cut`i']		///
					-`catcond1')/			///
					sqrt(`condvarfull`l''[1,1]) if	///
					`outcomeorder'==`i' & `touse`l''
				}
			}
			else if "`pomeanval'" != "" {
				forvalues l = 1/`npotreat' {
					qui replace `ll1' = 		///
					(_b[`cutlpref'#cut`j']		///
					-`catcond1')/			///
					sqrt(`condvarfull`l''[1,1]) if	///
					`outcomeorder'==`i' & `touse`l''
					qui replace `ul1'=		///
					(_b[`cutlpref'#cut`i']		///
					-`catcond1')/			///
					sqrt(`condvarfull`l''[1,1]) if	///
					`outcomeorder'==`i' & `touse`l''
				}
			}
			else {
				foreach val ///
				of numlist `e(trvalues)'`e(extrvalues)' {
					local abname = ustrleft("`eq'",32-6)
					local cutlpref ///
				/`abname':`val'.`e(extrdepvar)'`e(trdepvar)'
					forvalues l = 1/`npotreat' {
						qui replace `ll1' = 	///
						(_b[`cutlpref'#cut`j']	///
						-`catcond1')/		///
						sqrt(`condvarfull`l''[	///
						1,1]) if		///
						`outcomeorder'==`i' & 	///
						`touse`l'' & 		///
						`otdepvar'==`val'
						qui replace `ul1'=	///
						(_b[`cutlpref'#cut`i']	///
						-`catcond1')/		///
						sqrt(`condvarfull`l''[	///
						1,1]) if		///
						`outcomeorder'==`i' & 	///
						`touse`l'' & 		///
						`otdepvar'==`val'
					}
				}
			}
		}
		local k = `k'-1
		if "`e(cutsinteract)'" == "" | ///
			"`eq'" != "`e(odepvar)'" {
			forvalues l = 1/`npotreat' {
				qui replace `ll1' =			/// 
				(_b[/`abname':cut`k']-`catcond1')/	///
				sqrt(`condvarfull`l''[1,1]) if 		///
				`outcomeorder'==`k'+1 & `touse`l''
			}
		}
		else if "`pomeanval'" != "" {
			forvalues l = 1/`npotreat' {
				qui replace `ll1' =			/// 
				(_b[`cutlpref'#cut`k']-`catcond1')/	///
				sqrt(`condvarfull`l''[1,1]) if 		///
				`outcomeorder'==`k'+1 & `touse`l''
			}
		}
		else {
			foreach val ///
			of numlist `e(trvalues)'`e(extrvalues)' {
				local abname = ustrleft("`eq'",32-6)
				local cutlpref ///
				/`abname':`val'.`e(extrdepvar)'`e(trdepvar)'
				forvalues l = 1/`npotreat' {
					qui replace `ll1' =		/// 
					(_b[`cutlpref'#cut`k']-		///
					`catcond1')/			///
					sqrt(`condvarfull`l''[1,1]) if 	///
					`outcomeorder'==`k'+1 & 	///
					`touse`l'' & `otdepvar'==`val'
				}
			}
		}
		qui replace `ul1' = 1000 if 		///
			`outcomeorder'==`k'+1 & `touse'			
	}
	local toplowerlist `ll1'
	local topupperlist `ul1'
	local g = 2
	foreach eqn of local catlist {
		tempvar ll`g' ul`g'
		if `isbinary'[1,colnumb(`isbinary',"`eqn'")] == 1 {
			qui gen double `ul`g'' = -`catcond`g''/		///
				sqrt(`condvarfull1'[`g',`g']) if	/// 
				`eqn'==`catvals'[1,`g'] & `touse'
			qui gen double `ll`g'' = -1000 if	///	 
				`eqn'==`catvals'[1,`g'] & `touse'
			qui replace `ul`g'' = 1000 if 	///
				`eqn'==`catvals'[2,`g'] & `touse'	
			qui replace `ll`g'' = -`catcond`g''/		///
				sqrt(`condvarfull1'[`g',`g']) if	/// 
				`eqn'==`catvals'[2,`g'] & `touse'		
		}
		else {
			local abname = ustrleft("`eqn'",32-6)
			qui gen double `ll`g'' = -1000 if	/// 	
				`eqn'==`catvals'[1,`g'] & `touse'
			qui gen double `ul`g'' = (_b[/`abname':cut1]	/// 
				- `catcond`g'')/		///
				sqrt(`condvarfull1'[`g',`g'])	/// 
				if `eqn'==`catvals'[1,`g'] & `touse'
			local k = `nvals'[1,colnumb(`nvals',"`eqn'")]
			local km1 = `k'-1
			forvalues i=2/`km1' {
				local j = `i'-1
				qui replace `ll`g'' = 			  ///	
					(_b[/`abname':cut`j']		  ///	
					-`catcond`g'')/ 		  ///
					sqrt(`condvarfull1'[`g',`g']) if  ///
					`eqn'==`catvals'[`i',`g'] & `touse'
				qui replace `ul`g'' = 			  ///
					(_b[/`abname':cut`i']-		  ///
					`catcond`g'')/			  ///
					sqrt(`condvarfull1'[`g',`g']) if  ///
					`eqn'==`catvals'[`i',`g'] & `touse'
			}
			local k = `k'-1
			qui replace `ll`g'' = 				///
				(_b[/`abname':cut`k']-`catcond`g'')/ 	///
				sqrt(`condvarfull1'[`g',`g']) if 	///
				`eqn'==`catvals'[`k'+1,`g'] & `touse'
			qui replace `ul`g'' = 1000 if 			///
				`eqn'==`catvals'[`k'+1,`g'] & `touse'		
		}
		local toplowerlist `toplowerlist' `ll`g''
		local topupperlist `topupperlist' `ul`g''
		local botlowerlist `botlowerlist' `ll`g''
		local botupperlist `botupperlist' `ul`g''
		local g = `g' + 1
	}
	tempvar holder
	qui gen double `holder' = .
	forvalues i = 1/`npotreat' {
		tempvar holder`i'
		qui gen double `holder`i'' = .
		mata: eprobit_mean_calc("`holder`i''","`touse`i''",	///
				"`toplowerlist'","`topupperlist'",	///
				"`botlowerlist'","`botupperlist'",	///
				"`condvarfull`i''",`intpoints',`intpoints3')
		qui replace `holder' = `holder`i'' if `touse`i''
	}
	gen `vart' `varn' = `holder' if `touse'	
	local eqval = `allcatvals'[`outcomeorder',	///
		colnumb(`allcatvals',"`eq'")]
	_ms_parse_parts `eq'
	local leqval: value label `r(name)'
	if "`leqval'" != "" {
		local leqval: label `leqval' `eqval'
	}
	else {
		local leqval `eqval'
	}
	
	if "`pomeaneq'" != "" {
		_ms_parse_parts `pomeaneq'
		local lpomeanval: value label `r(name)'
		if "`lpomeanval'" != "" {
			local lpomeanval: label `lpomeanval' `pomeanval'
		}
		else {
			local lpomeanval `pomeanval'
		}		
		local lab potential-outcome mean ///
			Pr(`eq'==`leqval'), `pomeaneq': `lpomeanval'
	}
	else {
		if "`defaultpr'" != "" {
			di as text ///
				"(option {bf:pr} assumed; Pr(`eq'==`eqval'))"
		}
		local lab `"Pr(`eq'==`leqval')"'
	}
	label variable `varn' `"`lab'"' 
}
	local rc = _rc
nobreak {
	if "`base'" != "" {
		forvalues i = 1/`nvarsbase' {
			qui replace `basedepvar`i'' = `obase`i'' if `touse'
		}
	}
}
	if `rc' {
		exit `rc'
	
	}
end

program ParseUbase, rclass
	syntax, [u(string) base target]
	if "`u'" == "" {
		return local nvars = 0
		exit
	} 
	local ou `u'
	local i = 1

	while "`u'" != "" {
		gettoken var u: u, bind parse("=")
		capture confirm variable `var'
		if _rc {
			di as error "{bf:`base'`target'()} invalid; "
			confirm variable `var'
			exit 198
		}
		return local var`i' `var'
		gettoken eq u: u, bind parse("=")
		capture assert "`eq'" == "=" 
		if _rc {
			di as error "{bf:`base'`target'()} invalid"
			exit 198
		}
		gettoken expr u: u, bind parse(" ")
		local ok 0
		capture confirm number `expr'
		if !_rc {
			local ok 1
		}
		capture confirm variable `expr'
		if !_rc {
			local ok 1
		}
		if ~`ok' {
			local lu = ustrltrim(ustrrtrim(`"`expr'"'))
			local ok = usubstr(`"`lu'"',1,1)=="(" & ///
				   usubstr(`"`lu'"',-1,1)==")" 
		}
		if ~`ok' {
			di as error "{bf:`base'`target'()} invalid"
			exit 198
		}					
		return local expr`i' `expr'
		local i = `i' + 1		
	}
	return local nvars = `i'-1	
end


program GenTreat
	syntax, [pocovariance_depvar(string) pomeanval(string) touse(string)]
	tempname pocovariance_catcombomat
	matrix `pocovariance_catcombomat' = e(pocovariance_catcombomat)
	if "`pomeanval'" != "" & colsof(`pocovariance_catcombomat') > 1 {
		local k = e(pocovariance_n)
		tempname submat
		local cc = colsof(`pocovariance_catcombomat')
		matrix `submat' = J(1,`cc',.)
		forvalues i = 1/`k' {
			if `pocovariance_catcombomat'[`i',1] == `pomeanval' {
				matrix `submat' = `submat' \	///
				(`pocovariance_catcombomat'[`i',2..`cc'],`i')
			}
		}
		local rs = rowsof(`submat')
		local cs = colsof(`submat')
		matrix `submat' = `submat'[2..`rs',1..`cs']
		// so we have values followed by pocovariance index value
		local rs = `rs'-1
		local pocovariance_vars `e(pocovariance_vars)'
		gettoken poc pocovariance_vars: pocovariance_vars  
		tempvar isit
		qui gen byte  `isit' = 1 if `touse'
		forvalues i = 1/`rs' {		
			qui replace `isit' = 1 if `touse'
			local j = 1
			foreach var of varlist `pocovariance_vars' {
				qui replace `isit' = `isit' & ///
					`var'==`submat'[`i',`j'] if `touse'		
				local j = `j' + 1
			}
			qui replace `pocovariance_depvar' = ///
				`submat'[`i',`cs'] if `isit' & 	`touse'
		}	
	}
	else if "`pomeanval'" != "" {
		local k = e(pocovariance_n)
		local pocovariance_vars `e(pocovariance_vars)'
		tempvar isit
		qui gen byte  `isit' = 1 if `touse'
		tempname submat
		matrix `submat' = `pocovariance_catcombomat'
		local rs = rowsof(`submat')
		forvalues i = 1/`rs' {		
			if `submat'[`i',1] == `pomeanval' {
				qui replace `pocovariance_depvar' ///
					= `i' if `touse'
			}
		}			
	}
	else {
		local rs =rowsof(`pocovariance_catcombomat')
		local cs =colsof(`pocovariance_catcombomat')
		tempvar isit
		local pocovariance_vars `e(pocovariance_vars)'
		qui gen byte  `isit' = 1 if `touse'
		forvalues i = 1/`rs' {		
			qui replace `isit' = 1 if `touse'
			local j = 1
			foreach var of varlist `pocovariance_vars' {
				qui replace `isit' = `isit' & 		///
				`var'==`pocovariance_catcombomat'[	///
				`i',`j'] if `touse'		
				local j = `j' + 1
			}
			qui replace `pocovariance_depvar' = `i' if ///
				`isit' & `touse'
		}		
	}
end
exit
