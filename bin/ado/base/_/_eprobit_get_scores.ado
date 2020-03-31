*! version 1.1.1  13sep2019
program define _eprobit_get_scores
	syntax [anything] [if] [in], SCores 
	if "`e(repanvar)'" == "" {
		local k = e(k_eq)
	}
	else {
		local k = e(k)
	}
	_stubstar2names `anything', nvars(`k') nosubcommand
	local varlist `s(varlist)'
	local typlist `s(typlist)'
	tempname predtouse
	marksample predtouse, novarlist

	if "`e(nullcons)'" != "" {
		NullScores, vars(`varlist') ///
			types(`typlist') touse(`predtouse') 		
		exit 0
	}
	if "`e(pocovariance)'" != "" {
		tempvar tpocovariance_depvar
		qui gen byte `tpocovariance_depvar' = .
		tempvar tempesample
		qui gen byte `tempesample' = e(sample)
		GenTreat, pocovariance_depvar(`tpocovariance_depvar') ///
				touse(`tempesample')
		local has_pocovariance pocovariance
		local pocovariance_vars `tpocovariance_depvar'
	}

	tempvar s0catcombo s0catcombomatind		///
		s1catcombo s1catcombomatind	///
		order s1touse s0touse 		///
		catcombo catcombomatind
	tempvar touse ttouse otouse
	gen `touse' = e(sample)
	gen `ttouse' = `touse'
	gen `otouse' = `touse'
	local ns0combos = 0
	if "`e(ns0combos)'" != "" {
		local ns0combos = e(ns0combos)
	}
	local ns1combos = 0
	if "`e(ns1combos)'" != "" {
		local ns1combos = e(ns1combos)
	}
	local ncombos = 0
	if "`e(ncombos)'" != "" {
		local ncombos = e(ncombos)
	}
	if "`e(s1depvars)'" != "" & "`e(seldepvar)'" != "" {
		gen `s0touse' = `e(seldepvar)' == 0 if e(sample)
		GetCatCombos `s0touse' `e(s0depvars)', 	///
			touse(`s0touse')		/// 
			catcombo(`s0catcombo')		/// 	
			catcombomatind(`s0catcombomatind')
		gen `s1touse' = `e(seldepvar)' == 1 if e(sample)
		GetCatCombos `s1touse' `e(s1depvars)', 	///
			touse(`s1touse')		/// 
			catcombo(`s1catcombo')		/// 	
			catcombomatind(`s1catcombomatind')
		local s0depvars `e(s0depvars)'
		local s1depvars `e(s1depvars)'
		if "`has_pocovariance'" != "" {
			tempvar s1catcombopo s1catcombomatindpo
			GetCatCombos `s1touse' `pocovariance_vars',	/// 	
				touse(`s1touse')			///
				catcombo(`s1catcombopo') 		///
				catcombomatind(`s1catcombomatindpo')		
			tempvar pocovariance_depvar
			tempname pocovariance_catcombomat
			qui gen byte `pocovariance_depvar' = .
			mata: filltreat("`pocovariance_depvar'",	///
					"`s1catcombopo'",		///
					"`s1catcombomatindpo'",		///
					"`pocovariance_vars'",		///
					"`touse'",			///
					"`pocovariance_catcombomat'")	
			local pocovariance_n = ///
				rowsof(`pocovariance_catcombomat')
			tempname pocovariance_vals
			mata: st_matrix("`pocovariance_vals'",	///
				(1..`pocovariance_n'))
		}
	}
	else if "`e(s1depvars)'" != "" & "`e(tseldepvar)'" != "" {
		if "`e(tsell)'" != "" {
			tempvar tsell
			qui gen double `tsell' = `e(tsell)'
		}
		if "`e(tselu)'" != "" {
			tempvar tselu
			qui gen double `tselu' = `e(tselu)'
		}
		tempvar tsel_depvarind vtsel_depvarind tsel_cutoff
		qui gen byte `tsel_depvarind' = 1 if `touse'
		qui gen byte `vtsel_depvarind' = .
		qui gen double `tsel_cutoff' = 0
		if "`tsell'" != "" {
			qui replace `vtsel_depvarind' = 0 if	///
				`e(tseldepvar)' <= `tsell' & 	///
				~missing(`tsell') & `touse'
			qui replace `tsel_cutoff' = `tsell' if 	///
				`e(tseldepvar)' <= `tsell' & 	///
				~missing(`tsell') & `touse'
			qui replace `tsel_depvarind' = 0 if ///
				`e(tseldepvar)' <= `tsell' &  ///
				~missing(`tsell') & `touse'
		}
		if "`tselu'" != "" {
			qui replace `vtsel_depvarind' = 1 if	///
				`e(tseldepvar)' >= `tselu' &	///
				~missing(`tselu') & `touse'
			qui replace `tsel_cutoff' = `tselu' if 	///
				`e(tseldepvar)' >= `tselu' & 	///
				~missing(`tselu') & `touse'
			qui replace `tsel_depvarind' = 0 if ///
				`e(tseldepvar)' >= `tselu' &  ///
				~missing(`tselu') & `touse'
		}
		qui gen `s0touse' = `tsel_depvarind' == 0 if `touse'
		qui gen `s1touse' = `tsel_depvarind' == 1 if `touse'
		GetCatCombos `s0touse' `vtsel_depvarind' `e(trdepvar)'	///
			`e(bendogdepvars)' `e(oendogdepvars)',		///
			touse(`s0touse')				///
			catcombo(`s0catcombo')				///
			catcombomatind(`s0catcombomatind')
		tempvar ddepvar
		if "`e(cmd)'" == "eprobit" {
			qui gen `ddepvar' = `e(odepvar)' > 0 if `s1touse'
		}
		else {
			qui gen `ddepvar' = `e(odepvar)' if `s1touse'
		}
		GetCatCombos `s1touse' `ddepvar' `tsel_depvarind' ///
			`e(trdepvar)' `e(bendogdepvars)'	/// 		
			`e(oendogdepvars)',			///
			touse(`s1touse')			///
			catcombo(`s1catcombo')			///
			catcombomatind(`s1catcombomatind')		
		local s0depvars `vtsel_depvarind' `e(trdepvar)' ///
			`e(bendogdepvars)' `e(oendogdepvars)'
		local s1depvars `e(odepvar)' `tsel_depvarind'	///
			`e(trdepvar)' `e(bendogdepvars)' `e(oendogdepvars)'
		if "`has_pocovariance'" != "" {
			tempvar s1catcombopo s1catcombomatindpo
			GetCatCombos `s1touse' `pocovariance_vars',	/// 	
				touse(`s1touse')			///
				catcombo(`s1catcombopo') 		///
				catcombomatind(`s1catcombomatindpo')
			tempvar pocovariance_depvar
			tempname pocovariance_catcombomat
			qui gen byte `pocovariance_depvar' = .
			mata: filltreat("`pocovariance_depvar'",	///
					"`s1catcombopo'",		///
					"`s1catcombomatindpo'",		///
					"`pocovariance_vars'",		///
					"`touse'",			///
					"`pocovariance_catcombomat'")
			local pocovariance_n = ///
				rowsof(`pocovariance_catcombomat')
			tempname pocovariance_vals
			mata: st_matrix("`pocovariance_vals'",	///
				(1..`pocovariance_n'))
		}
	}
	if "`e(catdepvars)'" != "" {
		tempvar ddepvar
		if "`e(cmd)'" == "eprobit" {
			qui gen `ddepvar' = `e(odepvar)' > 0 if `touse'
		}
		else {
			qui gen `ddepvar' = `e(odepvar)' if `touse'
		}
		local catdepvars `ddepvar' `e(trdepvar)' ///
			`e(bendogdepvars)'	/// 	
			`e(oendogdepvars)'
		GetCatCombos `touse' `catdepvars',	/// 	
			touse(`touse')			///
			catcombo(`catcombo')		///
			catcombomatind(`catcombomatind')
		if "`has_pocovariance'" != "" {
			tempvar catcombopo catcombomatindpo
			GetCatCombos `touse' `pocovariance_vars',	/// 	
				touse(`touse')				///
				catcombo(`catcombopo') 			///
				catcombomatind(`catcombomatindpo')	
			tempvar pocovariance_depvar
			tempname pocovariance_catcombomat
			qui gen byte `pocovariance_depvar' = .
			mata: filltreat("`pocovariance_depvar'",	///
					"`catcombopo'",			///
					"`catcombomatindpo'",		///
					"`pocovariance_vars'",		///
					"`touse'",			///
					"`pocovariance_catcombomat'")
			local pocovariance_n = ///
				rowsof(`pocovariance_catcombomat')
			tempname pocovariance_vals
			mata: st_matrix("`pocovariance_vals'",	///
				(1..`pocovariance_n'))
		}
	}	  
nobreak {
	if "`e(cutsinteract)'" == "" & "`e(pocovariance)'" == "" {
		tempname relistmat 
		if "`e(repanvar)'" != "" {
			matrix `relistmat' = e(relistmat)
		}
		mata:							/// 
		_eprobit_init(  "inits",				///
				"`e(odepvar)'","`e(seldepvar)'",	///
				"`e(trdepvar)'",			///
				`e(nendog)',`e(nbendog)',`e(noendog)',	///
				"`s1depvars'",				///
				"e(s1vals)",				///
				"e(s1nvals)",				///
				"e(s1binary)",				///
				"`s1catcombo'",				///
				"`s1catcombomatind'",			///
				"`s0depvars'",				///
	 			"e(s0vals)",				///
				"e(s0nvals)",				///
				"e(s0binary)",				///
				"`s0catcombo'",				///
				"`s0catcombomatind'",			///
				"`catdepvars'",				///
	 			"e(catvals)",				///
				"e(catnvals)",				///
				"e(catbinary)",				///
				"`catcombo'",				///
				"`catcombomatind'",			///
				"`touse'",				///
				`e(intpoints)',`e(intpoints3)',		///
				"`tsel_depvarind'","`tsel_cutoff'", 	///
				"`e(repanvar)'",`e(reintpoints)',	///
				`e(ndv)',"","`relistmat'")
	}
	else if "`e(cutsinteract)'" == "" & "`e(pocovariance)'" != "" {
		tempname relistmat 
		if "`e(repanvar)'" != "" {
			matrix `relistmat' = e(relistmat)
		}
		qui mata: _eprobit_treat_init(`pocovariance_n',		///
				"inits",				///
				"`e(odepvar)'","`e(seldepvar)'",	///
				"`pocovariance_depvar'"	///
				,`e(nendog)',`e(nbendog)',`e(noendog)',	///
				"`s1depvars'",				///
				"e(s1vals)",				///
				"e(s1nvals)",				///
				"e(s1binary)",				///
				"`s1catcombo'",				///
				"`s1catcombomatind'",			///
				"`s0depvars'",				///
	 			"e(s0vals)",				///
				"e(s0nvals)",				///
				"e(s0binary)",				///
				"`s0catcombo'",				///
				"`s0catcombomatind'",			///
				"`catdepvars'",				///
	 			"e(catvals)",				///
				"e(catnvals)",				///
				"e(catbinary)",				///
				"`catcombo'",				///
				"`catcombomatind'",			///
				"`touse'",				///
				`e(intpoints)',`e(intpoints3)',		///
				"`tsel_depvarind'","`tsel_cutoff'",	///
				"`pocovariance_vals'",		 	///
				"`e(repanvar)'",`e(reintpoints)',	///
				`e(ndv)',"","`relistmat'")
	}
	else if "`has_pocovariance'" == "" & "`e(cutsinteract)'" != "" {
		local trn = wordcount("`e(extrvalues)'`e(trvalues)'")
		local trvals = subinstr("`e(extrvalues)'`e(trvalues)'", ///
		" ",",",.)
		tempname trvalmat
		matrix `trvalmat' = (`trvals')
		tempname relistmat 
		if "`e(repanvar)'" != "" {
			matrix `relistmat' = e(relistmat)
		}
		qui mata:						/// 
		_eoprobit_treat_init(`trn',				///  
				"inits",				///
				"`e(odepvar)'","`e(seldepvar)'",	///
				"`e(extrdepvar)'`e(trdepvar)'",		///
				`e(nendog)',`e(nbendog)',`e(noendog)',	///
				"`s1depvars'",				///
				"e(s1vals)",				///
				"e(s1nvals)",				///
				"e(s1binary)",				///
				"`s1catcombo'",				///
				"`s1catcombomatind'",			///
				"`s0depvars'",				///
	 			"e(s0vals)",				///
				"e(s0nvals)",				///
				"e(s0binary)",				///
				"`s0catcombo'",				///
				"`s0catcombomatind'",			///
				"`e(catdepvars)'",			///
	 			"e(catvals)",				///
				"e(catnvals)",				///
				"e(catbinary)",				///
				"`catcombo'",				///
				"`catcombomatind'",			///
				"`touse'",				///
				`e(intpoints)',`e(intpoints3)',		///
				"`tsel_depvarind'","`tsel_cutoff'",	///
				"`trvalmat'",				///
				"`e(repanvar)'",`e(reintpoints)',	///
				`e(ndv)',"","`relistmat'")
	}
	else {
               local trn = wordcount("`e(extrvalues)'`e(trvalues)'")
               local trvals = subinstr("`e(extrvalues)'`e(trvalues)'", ///
                       " ",",",.)
               tempname trvalmat
               matrix `trvalmat' = (`trvals')
		tempname relistmat 
		if "`e(repanvar)'" != "" {
			matrix `relistmat' = e(relistmat)
		}
		mata: _eoprobit_potreat_init(			///
				`trn',  "inits",		///
                                "`e(odepvar)'","`e(seldepvar)'",	///
				"`e(extrdepvar)'`e(trdepvar)'",		///
				`e(nendog)',`e(nbendog)',`e(noendog)',	///
				"`s1depvars'",				///
				"e(s1vals)",				///
				"e(s1nvals)",				///
				"e(s1binary)",				///
				"`s1catcombo'",				///
				"`s1catcombomatind'",			///
				"`s0depvars'",				///
	 			"e(s0vals)",				///
				"e(s0nvals)",				///
				"e(s0binary)",				///
				"`s0catcombo'",				///
				"`s0catcombomatind'",			///
				"`catdepvars'",				///
	 			"e(catvals)",				///
				"e(catnvals)",				///
				"e(catbinary)",				///
				"`catcombo'",				///
				"`catcombomatind'",			///
				"`touse'",				///
				`e(intpoints)',`e(intpoints3)',		///
				"`tsel_depvarind'","`tsel_cutoff'",	///
				"`trvalmat'","`pocovariance_depvar'",	///
				"`pocovariance_vals'",`pocovariance_n',	///
				"`e(repanvar)'",`e(reintpoints)',	///
				`e(ndv)',"","`relistmat'")

	}	
}
capture noisily break {
	tempfile estres
	qui estimates save "`estres'"
	tempname b
	matrix `b' = e(borig)
	DummyPost, init(`b') touse(`ttouse')
	local sclist
	forvalues i = 1/`k' {
		tempname tmpsc`i'
		local sclist `sclist' double `tmpsc`i''
	}	
	ml_p `sclist' if `otouse', scores userinfo(`inits') missing
	qui estimates use "`estres'"
	qui estimates esample: if `otouse', replace
	matrix `b' = e(b)
	if "`e(repanvar)'" == "" {
		local names: collfnames `b'
		local names: list uniq names
		local i = 1
		foreach eq of local names {
			gettoken var varlist: varlist
			gettoken typ typlist: typlist
			qui gen `typ' `var' = `tmpsc`i'' if `predtouse'
			label variable `var' ///
			"equation-level score for [`eq'] from `e(cmd)'"
			local i = `i' + 1
		}
	}
	else {
		local names: colfullnames `b'
		forvalues i = 1/`k' {
			gettoken var varlist: varlist
			gettoken typ typlist: typlist
			gettoken name names: names
			qui gen `typ' `var' = `tmpsc`i'' if `predtouse'
			label variable `var' ///
			"Score for _b[`name'] from `e(cmd)'"
		}		
	}
}
local erc = _rc
capture mata: rmexternal("`inits'")
if `erc' {
	exit `erc'
}
end

program DummyPost, eclass
	syntax, init(string) touse(string)
	gettoken init1 : init
	tempname tmat
	matrix `tmat' = `init1'
	ereturn repost b=`tmat', esample(`touse') rename
end

program GetCatCombos, sortpreserve
	syntax varlist(ts fv), catcombo(string) ///
		catcombomatind(string) touse(string)
	tempvar ttouse
	qui gen `ttouse' = `touse'
	qui replace `ttouse' = 0 if missing(`touse')
	tempvar order
	gen `order' = _n
	fvrevar `varlist' 
	local tmplist `r(varlist)'
	sort `tmplist' `order', stable
	qui gen `catcombo' = .
	qui by  `tmplist': replace	///
		`catcombo' = _n == 1 if `ttouse'
	qui gen `catcombomatind' = !missing(`catcombo')
	qui replace `catcombomatind' = 0 if `catcombo'==0
	qui replace `catcombo' = sum(`catcombo') if `ttouse'
	qui replace `catcombo' = -1 if missing(`catcombo')
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
		local rs = colsof(`submat')
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

program NullScores
	syntax, vars(string) types(string) touse(string)
	tempname catmat
	matrix `catmat' = e(cat1)
	local catnvals = rowsof(`catmat')
	local catnvalsm1 = `catnvals'-1
	forvalues k = 1/`catnvalsm1' {
		tempname score`k'
		qui gen `score`k'' = 0 if `touse'
	}
	qui replace `score1' = normalden(_b[/cut1])/normal(_b[/cut1]) ///
		if `e(depvar)' == `catmat'[1,1] & `touse'
	forvalues k = 2/`catnvalsm1' {
		local km1 = `k'-1
		qui replace `score`k'' = `score`k'' + 			///
			normalden(_b[/cut`k'])/(normal(_b[/cut`k']) - 	///
			normal(_b[/cut`km1'])) 				///
			if `touse' & `e(depvar)' == `catmat'[`k',1]
		qui replace `score`km1'' = `score`km1''- 		///
			normalden(_b[/cut`km1'])/(normal(_b[/cut`k']) - ///
			normal(_b[/cut`km1'])) 	///
			if `touse' & `e(depvar)' == `catmat'[`k',1]
	}
	qui replace `score`catnvalsm1'' =  			///
		`score`catnvalsm1'' - 				///	
		normalden(_b[/cut`catnvalsm1'])/		///
		(1-normal(_b[/cut`catnvalsm1']))		///
		if `touse' & `e(depvar)' == `catmat'[`catnvals',1]
	forvalues i = 1/`catnvalsm1' {
		gettoken var vars: vars
		gettoken typ types: types
		gen `typ' `var' = `score`i'' if `touse'
		label variable `var' ///
			"equation-level score for /cut`i' from eoprobit"
	}
end

exit

