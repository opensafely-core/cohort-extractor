*! version 1.1.1  13sep2019
program define _eintreg_get_scores
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
	tempvar s0catcombo s0catcombomatind	///
		as1catcombo as1catcombomatind	///
		s1catcombo s1catcombomatind	///
		order s1touse s0touse 		///
		catcombo catcombomatind		///
		icatcombo icatcombomatind	///
		is1catcombo is1catcombomatind	///
		as1touse is1touse itouse nitouse

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
			
	tempvar touse ttouse otouse
	gen `touse' = e(sample)
	gen `ttouse' = `touse'
	gen `otouse' = `touse'
	tempvar intcens 
	qui gen byte `intcens' = -1 if missing(`e(depvarl)') &	/// 
		!missing(`e(depvaru)') & `touse' 
	qui replace `intcens' = 1 if missing(`e(depvaru)') & ///
		!missing(`e(depvarl)') & `touse' 
	qui replace `intcens' = 0 if `touse' & missing(`intcens') & ///
		`e(depvarl)' < `e(depvaru)' 
	if "`e(seldepvar)'" != "" {
		qui replace `intcens'=. if			///	 
			~(`e(seldepvar)') & `touse'
	}
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
	local ins1combos = 0
	if "`e(ins1combos)'" != "" {
		local ins1combos = `e(ins1combos)'
	}
	local ans1combos = 0
	if "`e(ans1combos)'" != "" {
		local ans1combos = `e(ans1combos)'
	}
	local incombos = 0
	if "`e(incombos)'" != "" {
		local incombos = `e(incombos)'
	}
	if "`e(s1depvars)'" != "" & "`e(seldepvar)'" != "" {
		gen `s0touse' = `e(seldepvar)' == 0 if e(sample)
		GetCatCombos `s0touse' `e(s0depvars)', 	///
			touse(`s0touse')		/// 
			catcombo(`s0catcombo')		/// 	
			catcombomatind(`s0catcombomatind')
		gen `s1touse' = `e(seldepvar)' == 1 & 	///
			missing(`intcens') if e(sample)
		GetCatCombos `s1touse' `e(s1depvars)', 	///
			touse(`s1touse')		/// 
			catcombo(`s1catcombo')		/// 	
			catcombomatind(`s1catcombomatind')
		local s0depvars `e(s0depvars)'
		local s1depvars `e(s1depvars)'
		gen `is1touse' = ~missing(`intcens') if e(sample)
		GetCatCombos `intcens' `e(seldepvar)' `e(trdepvar)' 	///
			`e(bendogdepvars)' `e(oendogdepvars)',		/// 
			touse(`is1touse') catcombo(`is1catcombo')	/// 
			catcombomatind(`is1catcombomatind')
		local is1depvars `intcens' `e(seldepvar)' `e(trdepvar)' ///
			`e(bendogdepvars)' `e(oendogdepvars)'
		if "`has_pocovariance'" != "" {
			tempvar iis1touse 
			qui gen `iis1touse'= `e(seldepvar)' == 1 if e(sample)
			tempvar s1catcombopo s1catcombomatindpo
			GetCatCombos `iis1touse' `pocovariance_vars',	/// 	
				touse(`iis1touse')			///
				catcombo(`s1catcombopo') 		///
				catcombomatind(`s1catcombomatindpo')		
			tempvar pocovariance_depvar
			tempname pocovariance_catcombomat
			qui gen byte `pocovariance_depvar' = .
			mata: filltreat("`pocovariance_depvar'",	///
					"`s1catcombopo'",		///
					"`s1catcombomatindpo'",		///
					"`pocovariance_vars'",		///
					"`tempesample'",		///
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
		qui replace `intcens'=. if			///	 
			~(`tsel_depvarind') & `touse'
		tempvar tseldummy
		gen byte `tseldummy' = `tsel_depvarind' > 0 if `touse'
		qui gen `s0touse' = `tseldummy' == 0 if `touse'
		qui gen `s1touse' = `tseldummy' == 1 &	/// 	
			missing(`intcens') if `touse'
		qui gen `is1touse' = ~missing(`intcens') if `touse'
		GetCatCombos `s0touse' `vtseldepvarind'	 	///
			`e(trdepvar)' `e(bendogdepvars)'	///	
			`e(oendogdepvars)',			///
			touse(`s0touse')			///
			catcombo(`s0catcombo')			///
			catcombomatind(`s0catcombomatind')	
		GetCatCombos `s1touse' `tseldummy' 		///
			`e(trdepvar)' `e(bendogdepvars)'	/// 		
			`e(oendogdepvars)',			///
			touse(`s1touse')			///
			catcombo(`s1catcombo')			///
			catcombomatind(`s1catcombomatind')		
		local s0depvars `vtsel_depvarind' `e(trdepvar)' ///
			`e(bendogdepvars)' `e(oendogdepvars)'
		local s1depvars `tseldummy'	///
			`e(trdepvar)' `e(bendogdepvars)' `e(oendogdepvars)'
		GetCatCombos `intcens' `tseldummy' `e(trdepvar)' 	///
			`e(bendogdepvars)' `e(oendogdepvars)',		/// 
			touse(`is1touse') catcombo(`is1catcombo')	/// 
			catcombomatind(`is1catcombomatind')
		local is1depvars `intcens' `tseldummy' `e(trdepvar)' 	///
			`e(bendogdepvars)' `e(oendogdepvars)'
		qui gen `as1touse' = `s1touse'
		local as1depvars `e(trdepvar)' `e(bendogdepvars)' 	///
			`e(oendogdepvars)'
		if "`as1depvars'" != "" {
			GetCatCombos `as1touse' `as1depvars',	/// 	
				touse(`as1touse')		///	 
				catcombo(`as1catcombo')		///
				catcombomatind(`as1catcombomatind')
		}
		if "`has_pocovariance'" != "" {
			tempvar iis1touse 
			qui gen `iis1touse'= `tseldummy' == 1 if `touse'
			tempvar s1catcombopo s1catcombomatindpo
			GetCatCombos `iis1touse' `pocovariance_vars',	/// 	
				touse(`iis1touse')			///
				catcombo(`s1catcombopo') 		///
				catcombomatind(`s1catcombomatindpo')
			tempvar pocovariance_depvar
			tempname pocovariance_catcombomat
			qui gen byte `pocovariance_depvar' = .
			mata: filltreat("`pocovariance_depvar'",	///
					"`s1catcombopo'",		///
					"`s1catcombomatindpo'",		///
					"`pocovariance_vars'",		///
					"`tempesample'",		///
					"`pocovariance_catcombomat'")
			local pocovariance_n = ///
				rowsof(`pocovariance_catcombomat')
			tempname pocovariance_vals
			mata: st_matrix("`pocovariance_vals'",	///
				(1..`pocovariance_n'))
		}

	}
	else if "`e(catdepvars)'" != "" {
		qui gen `nitouse' = missing(`intcens') & `touse'
		GetCatCombos `nitouse' `e(catdepvars)',	/// 	
			touse(`nitouse')			///
			catcombo(`catcombo')		///
			catcombomatind(`catcombomatind')
		gen `itouse' = ~missing(`intcens') if `touse'
		GetCatCombos `intcens' `e(trdepvar)'	/// 
			`e(bendogdepvars)' `e(oendogdepvars)',	/// 	
			touse(`itouse')				///
			catcombo(`icatcombo') 			///
			catcombomatind(`icatcombomatind')
		local icatdepvars `intcens' `e(trdepvar)'	/// 
			`e(bendogdepvars)' `e(oendogdepvars)'
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
					"`tempesample'",		///
					"`pocovariance_catcombomat'")
			local pocovariance_n = ///
				rowsof(`pocovariance_catcombomat')
			tempname pocovariance_vals
			mata: st_matrix("`pocovariance_vals'",	///
				(1..`pocovariance_n'))
		}
	}
	else if "`e(pocovariance)'" != "" {
		local pocovariance_n = `e(pocovariance_n)'
		tempname pocovariance_vals
		mata: st_matrix("`pocovariance_vals'",	///
			(1..`pocovariance_n'))
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
	}	  
nobreak {
	if "`e(pocovariance)'" == "" {
		tempname relistmat 
		if "`e(repanvar)'" != "" {
			matrix `relistmat' = e(relistmat)
		}
		qui	mata: _eintreg_init(  "initsa",			///
				"`intcens'",				///
				"`e(depvarl)'",				///	
				"`e(depvaru)'",				///
				"`e(seldepvar)'",			///
				"`e(trdepvar)'",			///
				`e(nendog)',				///
				`e(nbendog)',				///
				`e(noendog)',				///
				"`s1depvars'",				///
				"e(s1vals)",				///
				"e(s1nvals)",				///
				"e(s1binary)",				///
				"`s1catcombo'",				///
				"`s1catcombomatind'",			///
				"`is1depvars'",				///
				"e(is1vals)",				///
				"e(is1nvals)",				///
				"e(is1binary)",				///
				"`is1catcombo'",			///
				"`is1catcombomatind'",			///
				"`as1depvars'",				///
				"e(as1vals)",				///
				"e(as1nvals)",				///
				"e(as1binary)",				///
				"`as1catcombo'",			///
				"`as1catcombomatind'",			///
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
				"`icatdepvars'",			///
	 			"e(icatvals)",				///
				"e(icatnvals)",				///
				"e(icatbinary)",			///
				"`icatcombo'",				///
				"`icatcombomatind'",			///
				"`touse'",				///
				`e(intpoints)',				///
				`e(intpoints3)',			///
				"`tsel_depvarind'",			///
				"`tsel_cutoff'",			///
				"`vtsel_depvarind'",			///
				"`e(repanvar)'",`e(reintpoints)',	///
				`e(ndv)',"","`relistmat'")
	}
	else {
		tempname povarindexmat
		tempname pocorrindexmat
		if (`e(povariance_n)' > 0) {
			matrix `povarindexmat' = e(povarindexmat)
		}
		if (`e(pocorrelation_n)' > 0) {
			matrix `pocorrindexmat' = e(pocorrindexmat)
		}
		tempname relistmat 
		if "`e(repanvar)'" != "" {
			matrix `relistmat' = e(relistmat)
		}
		qui	mata: _eintreg_treat_init(`pocovariance_n',	///
				"initsa",				///
				"`intcens'",				///
				"`e(depvarl)'",				///	
				"`e(depvaru)'",				///
				"`e(seldepvar)'",			///
				"`e(trdepvar)'",			///
				"`pocovariance_depvar'",		///
				`e(nendog)',				///
				`e(nbendog)',				///
				`e(noendog)',				///
				"`s1depvars'",				///
				"e(s1vals)",				///
				"e(s1nvals)",				///
				"e(s1binary)",				///
				"`s1catcombo'",				///
				"`s1catcombomatind'",			///
				"`is1depvars'",				///
				"e(is1vals)",				///
				"e(is1nvals)",				///
				"e(is1binary)",				///
				"`is1catcombo'",			///
				"`is1catcombomatind'",			///
				"`as1depvars'",				///
				"e(as1vals)",				///
				"e(as1nvals)",				///
				"e(as1binary)",				///
				"`as1catcombo'",			///
				"`as1catcombomatind'",			///
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
				"`icatdepvars'",			///
	 			"e(icatvals)",				///
				"e(icatnvals)",				///
				"e(icatbinary)",			///
				"`icatcombo'",				///
				"`icatcombomatind'",			///
				"`touse'",				///
				`e(intpoints)',				///
				`e(intpoints3)',			///
				"`tsel_depvarind'","`tsel_cutoff'",	///
				"`vtsel_depvarind'",			///
				"`pocovariance_vals'", 			///
				"`pocorrindexmat'",			///
				`e(pocorrelation_n)',			///
				"`povarindexmat'",			///
				`e(povariance_n)',			///
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
	ml_p `sclist' if `otouse', scores userinfo(`initsa') missing	
	qui estimates use "`estres'"
	qui estimates esample: if `otouse', replace
	matrix `b' = e(b)
	if "`e(repanvar)'" == "" {
		local eqnames: coleq `b'
		local eqnames: list uniq eqnames
		local i = 1
		foreach eq of local eqnames {
			if "`eq'" == "/" {
				continue, break
			}
			gettoken var varlist: varlist
			gettoken typ typlist: typlist
			qui gen `typ' `var' = `tmpsc`i'' if `predtouse'
			label variable `var' ///
				"equation-level score for [`eq'] from eintreg"
			local i = `i' + 1
		}
		local cnames: colnames `b'
		if ~missing(e(k_aux)) { 
			local k = colsof(`b')-e(k_aux) + 1
			foreach var of local varlist {
				gettoken typ typlist: typlist
				qui gen `typ' `var' = `tmpsc`i'' if `predtouse'
				local w: word `k' of `cnames'		
				label variable `var'	/// 
				"equation-level score for [`w'] from eintreg"
				local i = `i' + 1
				local k = `k' + 1
			}
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
capture mata: rmexternal("`initsa'")
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
	ereturn local depvar `e(oedepvar)'
end

program GetCatCombos, sortpreserve
	syntax varlist(ts fv), catcombo(string) ///
		catcombomatind(string) touse(string)
	tempvar order
	gen `order' = _n
	fvrevar `varlist' 
	local tmplist `r(varlist)'
	sort `tmplist' `order', stable
	qui gen `catcombo' = .
	qui by  `tmplist': replace	///
		`catcombo' = _n == 1 if `touse'
	qui gen `catcombomatind' = !missing(`catcombo')
	qui replace `catcombomatind' = 0 if `catcombo'==0
	qui replace `catcombo' = sum(`catcombo') if `touse'
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

exit

