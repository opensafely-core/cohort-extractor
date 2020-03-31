*! version 1.0.3  26feb2019
program _eregress_mean_ystar
	syntax, varn(string) [vart(string)] eq(string)		/// 
		[cond(string)] 			 		///
		touse(string)					///
		intpoints(string) intpoints3(string)		///
		[upper(string) lower(string)			///
		base(string) uppert(string) lowert(string) 	///
		target(string) noOFFSET]
	local linear `e(endogdepvars)' `e(tseldepvar)'
	local linearlist: list linear & cond
	local catlist: list cond - linearlist

	tempname allcatvals catvals 
	tempname isbinary nvals
	matrix `allcatvals' = e(catvals)
	matrix `isbinary' = e(binary)
	matrix `nvals' = e(nvals)
	local rowscat = rowsof(`allcatvals')
	tempname tfullvar
	if "`e(pocovariance)'" != "" {
		matrix `tfullvar' = e(varfull1)
	}
	else {
		matrix `tfullvar' = e(varfull)
	}
	local i = colnumb(`tfullvar',`"`eq'"')
	local catindlist `i'
	tempname cat1 catcond1
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
	if "`pomeaneq'" != "" {
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
		local npotreat = 1
		tempname fullvar1
		matrix `fullvar1' = e(varfull)
		tempvar touse1
		qui gen byte `touse1' = `touse'
	}
		qui replace `pomeaneq' = `storpomean'
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
		local npotreat = 1
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
				exit 198
			}
			qui replace `basedepvar`i'' = `baseindepvar`i'' ///
				if `touse'
		}
	}
	foreach name of local catlist {
		local i = colnumb(`allcatvals',"`name'")
		if `j' == 2 {
			mata:st_matrix("`catvals'",		/// 
				st_matrix("`allcatvals'")[1..`rowscat',`i'])	
		}
		else {
			mata:st_matrix("`catvals'",		/// 
				(st_matrix("`catvals'"),	///
				st_matrix("`allcatvals'")[1..`rowscat',`i']))
		}
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
	local mstorelist
	local mstorelistlow
	local mstorelisthigh
	tempvar outvar
	qui gen double `outvar' = . 
	local mstorelist `outvar'

	tempname lli1 uli1 ll1 ul1
	qui gen byte `lli1' = 0 if `touse'
	qui gen byte `uli1' = 0 if `touse'
	qui gen double `ll1' = -1000 if `touse'
	qui gen double `ul1' = 1000 if `touse'
	if "`lower'" != "" {
		qui replace `lli1' = ~missing(`lower') if `touse'
		qui replace `ll1' = `lower'-`catcond1' if `lli1' & `touse'
	}
	if "`upper'" != "" {
		qui replace `uli1' = ~missing(`upper') if `touse'
		qui replace `ul1' = `upper'-`catcond1' if `uli1' & `touse'
	}
	tempname lli1a uli1a ll1a ul1a
	qui gen byte `lli1a' = 0 if `touse'
	qui gen byte `uli1a' = 0 if `touse'
	qui gen double `ll1a' = -1000 if `touse'
	qui gen double `ul1a' = 1000 if `touse'
	local plow = 0
	qui count if `lli1' & `touse'
	if r(N) > 0 {
		local plow = 1
	}
	local phigh = 0
	qui count if `uli1' & `touse'
	if r(N) > 0 {
		local phigh = 1
	}
	tempvar lowtouse hightouse
	qui gen byte `lowtouse' = `touse' & `lli1'
	qui gen byte `hightouse' = `touse' & `uli1'
	forvalues i = 1/`npotreat' {
		tempvar lowtouse`i' hightouse`i'
		qui gen byte `lowtouse`i'' = `touse`i'' & `lli1'
		qui gen byte `hightouse`i'' = `touse`i'' & `uli1'
	}	
	if `plow'  {
		tempname lli1low uli1low ll1low ul1low 
		qui gen byte `lli1low' = 0 if `lowtouse'
		qui gen byte `uli1low' = `lli1' if `lowtouse'
		qui gen double `ll1low' = -1000 if `lowtouse'
		qui gen double 	`ul1low' = `ll1' if `lowtouse'
		local lowerlistlow `ll1low'
		local lowerindlistlow `lli1low'
		local upperlistlow `ul1low'
		local upperindlistlow `uli1low'
		
		tempname lli1lowu uli1lowu ll1lowu ul1lowu 
		qui gen byte `lli1lowu' = `lli1' if `lowtouse'
		qui gen byte `uli1lowu' = 0 if `lowtouse'
		qui gen double `ll1lowu' = `ll1' if `lowtouse'
		qui gen double `ul1lowu' = 1000 if `lowtouse'		 

		local lowerlistlowu `ll1lowu'
		local lowerindlistlowu `lli1lowu'
		local upperlistlowu `ul1lowu'
		local upperindlistlowu `uli1lowu'
		tempvar outvarlow
		qui gen double `outvarlow' = .
		local mstorelistlow `outvarlow'
	}
	if `phigh' {
		tempname lli1high uli1high ll1high ul1high
		qui gen byte `lli1high' = `uli1' if `hightouse'
		qui gen byte `uli1high' = 0 if `hightouse'
		qui gen double `ll1high' = `ul1' if `hightouse'
		qui gen double 	`ul1high' = 1000 if `hightouse'
		local lowerlisthigh `ll1high'
		local lowerindlisthigh `lli1high'
		local upperlisthigh `ul1high'
		local upperindlisthigh `uli1high'

		tempname lli1highl uli1highl ll1highl ul1highl
		qui gen byte `lli1highl' = 0 if `hightouse'
		qui gen byte `uli1highl' = `uli1' if `hightouse'
		qui gen double `ll1highl' = -1000 if `hightouse'
		qui gen double `ul1highl' = `ul1' if `hightouse'		

		local lowerlisthighl `ll1highl'
		local lowerindlisthighl `lli1highl'
		local upperlisthighl `ul1highl'
		local upperindlisthighl `uli1highl'

		tempvar outvarhigh
		qui gen double `outvarhigh' = .
		local mstorelisthigh `outvarhigh'
	}

	local lowerlist `ll1'
	local lowerindlist `lli1'
	local upperlist `ul1'
	local upperindlist `uli1'

	local lowerlista `ll1a'
	local lowerindlista `lli1a'
	local upperlista `ul1a'
	local upperindlista `uli1a'

	local g = 2
	foreach eqn of local catlist {
		tempvar catout`g'
		qui gen double `catout`g'' = .
		local mstorelist `mstorelist' `catout`g''
		local mstorelistlow `mstorelistlow' `catout`g''
		local mstorelisthigh `mstorelisthigh' `catout`g''

		tempvar ll`g' ul`g' lli`g' uli`g'
		if `isbinary'[1,colnumb(`isbinary',"`eqn'")] == 1 {
			qui gen double `uli`g'' = 1 if			/// 
				`eqn'==`catvals'[1,`g'-1] & `touse'
			qui gen double `ul`g'' = -`catcond`g'' if	/// 
				`eqn'==`catvals'[1,`g'-1] & `touse'
			qui gen double `lli`g'' = 0 if	///
				`eqn'==`catvals'[1,`g'-1] & `touse'
			qui gen double `ll`g'' = -1000 if	///	 
				`eqn'==`catvals'[1,`g'-1] & `touse'
			qui replace `uli`g'' = 0 if ///
				`eqn'==`catvals'[2,`g'-1] & `touse'	
			qui replace `ul`g'' = 1000 if 	///
				`eqn'==`catvals'[2,`g'-1] & `touse'	
			qui replace `ll`g'' = -`catcond`g'' if	/// 
				`eqn'==`catvals'[2,`g'-1] & `touse'
			qui replace `lli`g'' = 1 if	/// 
				`eqn'==`catvals'[2,`g'-1] & `touse'		
		}
		else {
			qui gen double `ll`g'' = -1000 if	/// 	
				`eqn'==`catvals'[1,`g'-1] & `touse'
			qui gen double `lli`g'' = 0 if ///
				`eqn'==`catvals'[1,`g'-1] & `touse'
			qui gen double `ul`g'' = (_b[/`eqn':cut1]	/// 
				- `catcond`g'')				/// 
				if `eqn'==`catvals'[1,`g'-1] & `touse'
			qui gen double `uli`g'' = 1 		/// 
				if `eqn'==`catvals'[1,`g'-1] & `touse'
			local k = `nvals'[1,colnumb(`nvals',"`eqn'")]
			local km1 = `k'-1
			forvalues i=2/`km1' {
				local j = `i'-1
				qui replace `ll`g'' =			///	
					(_b[/`eqn':cut`j']-		///
					`catcond`g'') if		///
					`eqn'==`catvals'[`i',`g'-1] & `touse'
				qui replace `lli`g'' = 1 if	///
 					`eqn'==`catvals'[`i',`g'-1] & `touse'
				qui replace `uli`g'' = 1 if	///
 					`eqn'==`catvals'[`i',`g'-1] & `touse'
				qui replace `ul`g'' = 			  ///
					(_b[/`eqn':cut`i']-`catcond`g'')  ///
					if				  ///
					`eqn'==`catvals'[`i',`g'-1] & `touse'
			}
			local k = `k'-1
			qui replace `lli`g'' = 1 if 	///
				`eqn'==`catvals'[`k'+1,`g'-1] & `touse'
			qui replace `ll`g'' = 				///
				(_b[/`eqn':cut`k']-`catcond`g'') if 	///
				`eqn'==`catvals'[`k'+1,`g'-1] & `touse'
			qui replace `uli`g'' = 0 if ///
				`eqn'==`catvals'[`k'+1,`g'-1] & `touse'
			qui replace `ul`g'' = 1000 if 			///
				`eqn'==`catvals'[`k'+1,`g'-1] & `touse'		
		}
		local lowerlist `lowerlist' `ll`g''
		local lowerindlist `lowerindlist' `lli`g''
		local upperlist `upperlist' `ul`g''
		local upperindlist `upperindlist' `uli`g''
		local lowerlista `lowerlista' `ll`g''
		local lowerindlista `lowerindlista' `lli`g''
		local upperlista `upperlista' `ul`g''
		local upperindlista `upperindlista' `uli`g''
		if `plow' {
			local lowerlistlow `lowerlistlow' `ll`g''
			local lowerindlistlow `lowerindlistlow' `lli`g''
			local upperlistlow `upperlistlow' `ul`g''
			local upperindlistlow `upperindlistlow' `uli`g''

			local lowerlistlowu `lowerlistlowu' `ll`g''
			local lowerindlistlowu `lowerindlistlowu' `lli`g''
			local upperlistlowu `upperlistlowu' `ul`g''
			local upperindlistlowu `upperindlistlowu' `uli`g''
		}
		if `phigh' {
			local lowerlisthigh `lowerlisthigh' `ll`g''
			local lowerindlisthigh `lowerindlisthigh' `lli`g''
			local upperlisthigh `upperlisthigh' `ul`g''
			local upperindlisthigh `upperindlisthigh' `uli`g''

			local lowerlisthighl `lowerlisthighl' `ll`g''
			local lowerindlisthighl `lowerindlisthighl' `lli`g''
			local upperlisthighl `upperlisthighl' `ul`g''
			local upperindlisthighl `upperindlisthighl' `uli`g''
		}
		local g = `g' + 1
	}
	tempvar ystar
	qui gen double `ystar' = 0 if `touse'
	if `plow' {
		tempvar problow
		qui gen double `problow' = .
		forvalues i = 1/`npotreat' {
			tempvar problow`i'
			qui gen double `problow`i'' = .
			mata:_erm_truncnorm_mean_prob_help(	///
				"`problow`i''", "`lowerlistlow'",	///
				"`upperlistlow'",		///
				"`lowerindlistlow'",		///
				"`upperindlistlow'",		///
				"`condvarfull`i''",		///
				`intpoints',`intpoints3',"`lowtouse`i''")
			qui replace `problow' = `problow`i'' if `lowtouse`i''
		}
		qui replace `ystar' = `ystar' + ///
			`problow'*(`ll1'+`catcond1') if `lowtouse'
		qui replace `ystar' = `ystar' +		/// 
			(1-`problow')*`catcond1' if 	///
			`lowtouse' & ~`hightouse'
		tempvar ttouse
		qui gen byte `ttouse' = ~`hightouse' & `lowtouse'
		qui count if `ttouse'		
		local nttouse = r(N)
		if "`catlist'" != "" & `nttouse' {
			forvalues i = 1/`npotreat' {
				tempvar ttouse`i'
				qui gen byte `ttouse`i'' = ///
					~`hightouse' & `lowtouse`i''
				mata:_erm_truncnorm_mean_help(		 ///
				"`mstorelistlow'", 			 ///
				"`lowerlistlowu'","`upperlistlowu'",	 ///
				"`lowerindlistlowu'",			 ///
				"`upperindlistlowu'",			 ///
				"`lowerlista'","`upperlista'",		 ///
				"`lowerindlista'","`upperindlista'",	 ///
				"`condvarfull`i''",`intpoints',		 ///
				`intpoints3',"`ttouse`i''")
				qui replace `ystar'=`ystar'+`outvarlow'	 /// 
					if `ttouse`i''
			}
		}
		else {
			forvalues i = 1/`npotreat' {
				tempvar ttouse`i'
				qui gen byte `ttouse`i'' = ///
					~`hightouse' & `lowtouse`i''		
				local sig`i' (sqrt(`condvarfull`i''[1,1]))
				qui replace `ystar' =  `ystar' + 	///
					(1-`problow')*`sig`i''*		///	
					normalden(`ll1'/`sig`i'')/	///
					normal(-`ll1'/`sig`i'') if	/// 
					`ttouse`i'' 
			}
		}
	}
	if `phigh' {
		tempvar probhigh
		qui gen double `probhigh' = .
		forvalues i = 1/`npotreat' {
			mata:_erm_truncnorm_mean_prob_help(	///
				"`probhigh'","`lowerlisthigh'", ///
				"`upperlisthigh'",		///
				"`lowerindlisthigh'",		///
				"`upperindlisthigh'",		///
				"`condvarfull`i''",		///
				`intpoints',`intpoints3',	///
				"`hightouse`i''")
		}
		qui replace `ystar' = `ystar' + ///
			`probhigh'*(`ul1'+`catcond1') if `hightouse'
		qui replace `ystar' = `ystar' +		/// 
			(1-`probhigh')*`catcond1' if 	///
			`hightouse' & ~`lowtouse'
		tempvar ttouse
		gen byte `ttouse' = ~`lowtouse' & `hightouse'
		qui count if `ttouse'
		local nttouse = r(N)
		if "`catlist'" != "" & `nttouse' {
			forvalues i = 1/`npotreat' {
				tempvar ttouse`i'
				qui gen byte `ttouse`i'' = ~`lowtouse' ///
					& `hightouse`i''
				mata:_erm_truncnorm_mean_help(		  ///
				"`mstorelisthigh'", 			  ///
				"`lowerlisthighl'","`upperlisthighl'",	  ///
				"`lowerindlisthighl'",			  ///
				"`upperindlisthighl'", 			  ///
				"`lowerlista'","`upperlista'",		  ///
				"`lowerindlista'","`upperindlista'",	  ///
				"`condvarfull`i''",`intpoints',		  ///
				`intpoints3',"`ttouse`i''")
				qui replace `ystar'=`ystar'+`outvarhigh' ///
					if `ttouse`i''
			}
		}
		else {
			forvalues i = 1/`npotreat' {
				tempvar ttouse`i'
				qui gen byte `ttouse`i'' = ///
					~`lowtouse' & `hightouse`i''		
				local sig`i' (sqrt(`condvarfull`i''[1,1]))
				qui replace `ystar' = `ystar' -	/// 
					(1-`probhigh')*`sig`i''*	///
					normalden(`ul1'/`sig`i'')/	///
					normal(`ul1'/`sig`i'') if `ttouse`i''
			}
		}
	}
	if `plow' & `phigh' {
		tempvar probmid 
		qui gen double `probmid' = 1-`probhigh'-`problow' ///
			if `lowtouse' & `hightouse'
		qui replace `ystar' = `ystar' +		///
			`probmid'*`catcond1' if		/// 	
			`hightouse' & `lowtouse'
		tempvar ttouse
		gen byte `ttouse' = `hightouse' & `lowtouse'
		qui count if `ttouse'
		local nttouse = r(N)
		if "`catlist'" != "" & `nttouse' {
			forvalues i = 1/`npotreat' {
				tempvar ttouse`i'
				qui gen byte `ttouse`i'' = `hightouse`i'' ///
					 & `lowtouse`i''
				mata:_erm_truncnorm_mean_help(		///
				"`mstorelist'",				///
				"`lowerlist'","`upperlist'",		///
				"`lowerindlist'","`upperindlist'",	///
				"`lowerlista'","`upperlista'",		///
				"`lowerindlista'","`upperindlista'",	///
				"`condvarfull`i''",`intpoints',		///
				`intpoints3',"`ttouse`i''")
				qui replace `ystar' = `ystar' + `outvar' ///
					if `ttouse`i''
			}
		}
		else {
			forvalues i = 1/`npotreat' {
				tempvar ttouse`i'
				qui gen byte `ttouse`i'' = ///
					`hightouse`i'' & `lowtouse`i''		
				local sig`i' (sqrt(`condvarfull`i''[1,1]))
				qui replace `ystar' = `ystar' +`probmid'* ///
					`sig`i''*(		  	  ///
					normalden(`ll1'/`sig`i'')-	  ///
					normalden(`ul1'/`sig`i''))/	  ///
					(normal(`ul1'/`sig`i'')-	  ///
					normal(`ll1'/`sig`i''))	 	  ///
					if `ttouse`i''
			}
		}
	}
	gen `vart' `varn' = `ystar' if `touse'	
	local lab
	if "`upper'`lower'" == "" {
		local lab `"mean of `eq'"'
	}
	else if "`upper'" != "" & "`lower'" != "" {
		local lab	///
	`"mean of `eq'* = max(`lowert',min(`eq',`uppert'))"'	
	}
	else if "`lower'" != "" & "`upper'" == "" {
		local lab 	///
			`"mean of `eq'* = max(`lowert',`eq')"'  	
	}
	else {
		// "`upper'" != "" & "`lower'" == ""
		local lab	///
			`"mean of `eq'*=max(`eq',`uppert')"'
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
			di as error "{bf:`base'`target'()} invalid;"
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
