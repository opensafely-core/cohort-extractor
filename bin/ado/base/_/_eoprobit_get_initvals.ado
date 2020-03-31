*! version 1.0.1  16dec2019
program _eoprobit_get_initvals, rclass
	version 15
	syntax, [depvar(string)		///
		indepvars(string)	///
		noCONstant		///
		offset(passthru)	///
		sel_depvar(string)	///
		sel_indepvars(string)	///
		sel_constant(string)	///
		sel_offset(string)	///
		tr_depvar(string)	///
		tr_n(string)		///
		tr_indepvars(string)	///
		tr_vals(string)		///
		tr_oprobit(string)	///
		tr_constant(string)	///
		tr_offset(string)	///
		endog_depvars(string)	///
		endog_indepvars(string)	///
		nbendog(string)		///
		noendog(string)		///
		nendog(string)		///
		wexp(string)		///
		touse(string)		/// 
		depvar_n(string)	///
		depvar_vals(string) *]

	local cutdvnames
	local s 
	forvalues i=1/`noendog' {
		local s `s' oendog_n`i'(string) oendog_depvar`i'(string) ///
			oendog_indepvars`i'(string) oendog_vals`i'(string) ///
			oendog_constant`i'(string)		
	}
	forvalues i = 1/`nbendog' {
		local s `s' bendog_n`i'(string)		///
			bendog_depvar`i'(string)	///
			bendog_indepvars`i'(string)	///
 			bendog_constant`i'(string)	 	
	}
	forvalues i = 1/`nendog' {
		local s `s' endog_constant`i'(string)
	}
	local 0, `options'
	if `"`s'"' != "" {
		syntax , [`s' *]
	}
	local s2lin
	forvalues i = 1/`nendog' {
		local s2lin `s2lin' endog_constant`i'(`endog_constant`i'')
	}
	local bendog_depvars
	forvalues i = 1/`nbendog' {
		local bendog_depvars `bendog_depvars' `bendog_depvar`i''
	}
	local oendog_depvars
	forvalues i = 1/`noendog' {
		local oendog_depvars `oendog_depvars' `oendog_depvar`i''
	}

	tempname tmpVar
	matrix `tmpVar' = 1
	tempname initCov
	local initCovdim = 1 + ("`sel_depvar'" != "") + ///
				("`tr_depvar'" != "") + ///
				`nbendog' + `noendog' ///
				+ `nendog'
	tempname bigB bigCut
	local bigBnames
	local fbigCutnames
	local bigCutnames
	local sbigCutnames
	matrix `bigB' = J(1,1,.)
	matrix `bigCut' = J(1,1,.)
	matrix `initCov' = J(`initCovdim',`initCovdim',.)
	if `nendog' > 0  {
		tempname covCorr
		matrix `covCorr' = J(1,`nendog',.)
		forvalues i = 1/`nendog' {
			tempvar resid`i'
			local resids `resids' `resid`i''
		}
		local residsnosel `resids'
		_eprobit_svgetsigma `wexp', ///
			endog(`endog_depvars')	/// 
			exog(`endog_indepvars')	///
			touse(`touse') ///
			resids(`resids') ///
			nendog(`nendog') `s2lin'
		tempname YContCov YContb IYContCov
		matrix `YContb' = r(b)
		matrix `YContCov' = r(Cov)
		matrix `IYContCov' = invsym(`YContCov')
		local Cov `YContCov'
		local ICov `IYContCov' 
		local nresids: word count `resids'
		local cntresids `resids'			
		matrix `bigB' = `YContb',`bigB'
		local f: colfullnames `YContb'
		local bigBnames `f' `bigBnames'
	}
	if `nendog' > 0 & `noendog' > 0 {
		local i = `noendog'
		while `i' >= 1 {
			tempname oendog`i'b oendog`i'Cov	///
				oendog`i'Corr oendog`i'Cut	/// 
				oendog`i'xb
			tempvar oresid`i'
			local ncuts = `oendog_n`i'' - 1
			_eprobit_getsvpronresid			/// 
				`oendog_depvar`i'' 		/// 
				`oendog_indepvars`i'' `wexp',	/// 
				`oendog_constant`i''		///
				cov(`YContCov') 		///
				icovycont(`IYContCov') 		/// 
				resids(`cntresids') 		///
				touse(`touse') 			///
				ncuts(`ncuts')			/// 
				vals(`oendog_vals`i'') 		///
				newresid(`oresid`i'')		///
				storxb(`oendog`i'xb')			
			local residsnosel `oresid`i'' `residsnosel'
			matrix `oendog`i'b' = r(b)
			matrix `bigB' = `oendog`i'b',`bigB'
			local f: colfullnames `oendog`i'b'
			local bigBnames `f' `bigBnames'
			matrix `oendog`i'Cut' = r(cut)
			local fcoln
			local coln
			local scoln
			local m = `ncuts'
			while `m' >= 1 {
				local abname=ustrleft("`oendog_depvar`i''",32-6)
				local cutdvnames `abname' `cutdvnames'
				local fcoln ///
				/`abname':cut`m' `fcoln'
				local coln ///
				/:o`i'_cut`m' `coln'
				local scoln ///
				/o`i'_cut`m' `scoln'
				local m = `m'-1
			}
			matrix colnames `oendog`i'Cut' = `coln'
			matrix `bigCut' = `oendog`i'Cut',`bigCut'
			local fbigCutnames `fcoln' `fbigCutnames'
			local bigCutnames `coln' `bigCutnames'
			local sbigCutnames `scoln' `sbigCutnames'
			matrix `oendog`i'Corr' = r(corr)
			matrix `oendog`i'Cov' = r(corr)
			local nresids: word count `cntresids'
			forvalues j = 1/`nresids' {
				matrix `oendog`i'Cov'[1,`j']=	 ///
					`oendog`i'Cov'[1,`j']* ///
					sqrt(`YContCov'[`j',`j']) 
			}
			matrix `covCorr' = `oendog`i'Cov' \ `covCorr'
			local i = `i' - 1
		}
	}
	else if `noendog' > 0 {
		local i = `noendog'
		while `i' >= 1 {
			tempname oendog`i'b oendog`i'Cut	/// 
				oendog`i'xb
			tempvar oresid`i'
			local ncuts = `oendog_n`i'' - 1
			_eprobit_getsvpronresid			/// 
				`oendog_depvar`i'' 		/// 
				`oendog_indepvars`i'' `wexp',	/// 
				`oendog_constant`i''		///
				touse(`touse') 			///
				ncuts(`ncuts')			/// 
				vals(`oendog_vals`i'') 		///
				newresid(`oresid`i'')		///
				storxb(`oendog`i'xb')	
			local residsnosel `oresid`i'' `residsnosel'
			matrix `oendog`i'b' = r(b)
			matrix `bigB' = `oendog`i'b',`bigB'
			local f: colfullnames `oendog`i'b'
			local bigBnames `f' `bigBnames'
			matrix `oendog`i'Cut' = r(cut)
			local fcoln
			local coln
			local scoln
			local m = `ncuts'
			while `m' >= 1 {
				local abname=ustrleft(	///
					"`oendog_depvar`i''",32-6)
				local cutdvnames `abname' `cutdvnames'
				local fcoln ///
				/`abname':cut`m' `fcoln'
				local coln ///
				/:o`i'_cut`m' `coln'
				local scoln ///
				/o`i'_cut`m' `scoln'
				local m = `m'-1
			}
			matrix colnames `oendog`i'Cut' = `coln'
			matrix `bigCut' = `oendog`i'Cut',`bigCut'
			local fbigCutnames `fcoln' `fbigCutnames'
			local bigCutnames `coln' `bigCutnames'
			local sbigCutnames `scoln' `sbigCutnames'
			local i = `i' - 1 
		}			
	}
	if `nendog' > 0 & `nbendog' > 0 {
		local i = `nbendog'
		while `i' >= 1 {
			tempname bendog`i'b bendog`i'Cov	///
				bendog`i'Corr bendog`i'Cut	/// 
				bendog`i'xb
			tempvar bresid`i'
			local ncuts = `bendog_n`i'' - 1
			_eprobit_getsvpronresid			/// 
				`bendog_depvar`i'' 		/// 
				`bendog_indepvars`i'' `wexp',	/// 
				`bendog_constant`i''		///
				cov(`YContCov') 		///
				icovycont(`IYContCov') 		/// 
				resids(`cntresids') 		///
				touse(`touse') 			///	
				vals(`bendog_vals`i'') 		///
				newresid(`bresid`i'')		///
				storxb(`bendog`i'xb')		
			local residsnosel `bresid`i'' `residsnosel'
			matrix `bendog`i'b' = r(b)
			matrix `bigB' = `bendog`i'b',`bigB'
			local f: colfullnames `bendog`i'b'
			local bigBnames `f' `bigBnames'
			matrix `bendog`i'Cut' = r(cut)
			matrix `bendog`i'Corr' = r(corr)
			matrix `bendog`i'Cov' = r(corr)
			local nresids: word count `cntresids'
			forvalues j = 1/`nresids' {
				matrix `bendog`i'Cov'[1,`j']=	 ///
					`bendog`i'Cov'[1,`j']* ///
					sqrt(`YContCov'[`j',`j']) 
			}
			matrix `covCorr' = `bendog`i'Cov' \ `covCorr'
			local i = `i' - 1
		}
	}
	else if `nbendog' > 0 {
		local i = `nbendog'
		while `i' >= 1 {
			tempname bendog`i'b bendog`i'Cut	/// 
				bendog`i'xb
			tempvar bresid`i'
			local ncuts = `bendog_n`i'' - 1
			_eprobit_getsvpronresid			/// 
				`bendog_depvar`i'' 		/// 
				`bendog_indepvars`i'' `wexp',	/// 
				`bendog_constant`i''		///
				touse(`touse') 			///	
				vals(`bendog_vals`i'') 		///
				newresid(`bresid`i'')		///
				storxb(`bendog`i'xb')		
			local residsnosel `bresid`i'' `residsnosel'
			matrix `bendog`i'b' = r(b)
			matrix `bigB' = `bendog`i'b',`bigB'
			local f: colfullnames `bendog`i'b'
			local bigBnames `f' `bigBnames'
			matrix `bendog`i'Cut' = r(cut)
			local i = `i' - 1
		}			
	}
	if `nendog' > 0 & "`tr_depvar'" != "" & ///
		"`tr_oprobit'" != ""{
		tempname trb trCov ///
			trCut ItrCov trCorr trxb
		local ncuts = `tr_n'-1
		tempvar trresid
		_eprobit_getsvpronresid `tr_depvar' 	/// 
			`tr_indepvars' `wexp',	/// 
			`tr_constant'		///
			`tr_offset'		///
			cov(`YContCov') 	///
			icovycont(`IYContCov') 	/// 
			resids(`cntresids') touse(`touse') ///
			ncuts(`ncuts') vals(`tr_vals') 	///
			newresid(`trresid') storxb(`trxb')
		local residsnosel `trresid' `residsnosel'
		matrix `trb' = r(b)
		matrix `bigB' = `trb',`bigB'
		local f: colfullnames `trb'
		local bigBnames `f' `bigBnames'
		matrix `trCut' = r(cut)
		local fcoln
		local coln
		local scoln
		local m = `ncuts'
		while `m' >= 1 {
			local abname=ustrleft("`tr_depvar'",32-6)
			local cutdvnames `abname' `cutdvnames'
			local fcoln ///
			/`abname':cut`m' `fcoln'
			local coln ///
			/:t_cut`m' `coln'
			local scoln ///
			/t_cut`m' `scoln'
			local m = `m'-1
		}
		matrix colnames `trCut' = `coln'
		matrix `bigCut' = `trCut',`bigCut'
		local bigCutnames `coln' `bigCutnames'
		local sbigCutnames `scoln' `sbigCutnames'
		local fbigCutnames `fcoln' `fbigCutnames'
		matrix `trCorr' = r(corr)
		matrix `trCov' = `trCorr'
		local nresids: word count `cntresids'
		forvalues i = 1/`nresids' {
			matrix `trCov'[1,`i'] =	///
				`trCov'[1,`i']*	///
				sqrt(`YContCov'[`i',`i'])
		}
		matrix `covCorr' = `trCov' \ `covCorr'
	}	
	else if "`tr_depvar'" != "" & "`tr_oprobit'" != "" {
		tempname trb  ///
		trCut  trxb
		local ncuts = `tr_n'-1
		tempvar trresid
		_eprobit_getsvpronresid `tr_depvar' 	/// 
			`tr_indepvars' `wexp',	/// 
			`tr_constant'		///
			`tr_offset'		///
			touse(`touse') ///
			ncuts(`ncuts') vals(`tr_vals') 	///
			newresid(`trresid') storxb(`trxb')
		local residsnosel `trresid' `residsnosel'
		matrix `trb' = r(b)
		matrix `bigB' = `trb',`bigB'
		local f: colfullnames `trb'
		local bigBnames `f' `bigBnames'
		matrix `trCut' = r(cut)
		local fcoln
		local coln
		local scoln
		local m = `ncuts'
		while `m' >= 1 {
			local abname=ustrleft("`tr_depvar'",32-6)
			local cutdvnames `abname' `cutdvnames'
			local fcoln ///
			/`abname':cut`m' `fcoln'
			local coln ///
			/:t_cut`m' `coln'
			local scoln ///
			/t_cut`m' `scoln'
			local m = `m'-1
		}
		matrix colnames `trCut' = `coln'
		matrix `bigCut' = `trCut',`bigCut'
		local bigCutnames `coln' `bigCutnames'
		local sbigCutnames `scoln' `sbigCutnames'
		local fbigCutnames `fcoln' `fbigCutnames'
	}
	if `nendog' > 0 & "`tr_depvar'" != "" & ///
		"`tr_oprobit'"== ""{
			tempname trb trCov ///
				ItrCov trCorr trxb
			local ncuts = `tr_n'-1
			tempvar trresid
			_eprobit_getsvpronresid `tr_depvar' 	/// 
				`tr_indepvars' `wexp',	/// 
				`tr_constant'		///
				`tr_offset'		///
				cov(`YContCov') 		///
				icovycont(`IYContCov') 		/// 
				resids(`cntresids') touse(`touse') ///
				vals(`tr_vals') 	///
				newresid(`trresid') storxb(`trxb')
			local residsnosel `trresid' `residsnosel'
			matrix `trb' = r(b)
			matrix `bigB' = `trb',`bigB'
			local f: colfullnames `trb'
			local bigBnames `f' `bigBnames'
			local treatb `trb'
			matrix `trCorr' = r(corr)
			matrix `trCov' = `trCorr'
			local nresids: word count `cntresids'
			forvalues i = 1/`nresids' {
				matrix `trCov'[1,`i'] =	///
					`trCov'[1,`i']*	///
					sqrt(`YContCov'[`i',`i'])
			}
			matrix `covCorr' = `trCov' \ `covCorr'
	}
	else if "`tr_depvar'" != "" & "`tr_oprobit'" == "" {
		tempname trb trxb
		local ncuts = `tr_n'-1
		tempvar trresid
		_eprobit_getsvpronresid `tr_depvar' 	/// 
			`tr_indepvars' `wexp',	/// 
			`tr_constant'		///
			`tr_offset'		///
			touse(`touse') ///
			vals(`tr_vals') 	///
			newresid(`trresid') storxb(`trxb')
		local residsnosel `trresid' `residsnosel'
		matrix `trb' = r(b)
		matrix `bigB' = `trb',`bigB'
		local f: colfullnames `trb'
		local bigBnames `f' `bigBnames'
		local treatb `trb'
	}
	if `nendog' > 0 & "`sel_depvar'" != "" {
		tempvar residsel selxb	
		_eprobit_getsvpronresid `sel_depvar' 	/// 
			`sel_indepvars' `wexp',		///
			`sel_constant'			///
			`sel_offset'			///
			cov(`YContCov') 		///
			icovycont(`IYContCov') 		/// 
			resids(`cntresids')		/// 
			touse(`touse')			///
			newresid(`residsel') 		///
			storxb(`selxb')
		local residsnosel `residsel' `residsnosel'
		tempname selb selCov selCorr
		matrix `selb' = r(b)
		matrix `bigB' = `selb',`bigB'
		local f: colfullnames `selb'
		local bigBnames `f' `bigBnames'
		matrix `selCorr' = r(corr)
		matrix `selCov' = `selCorr'
		forvalues i = 1/`nresids' {
			matrix			/// 
			`selCov'[1,`i'] =	///
			`selCov'[1,`i']*	///
			sqrt(`YContCov'[`i',`i'])
		}
		matrix `covCorr' = `selCov' \ `covCorr'
	}
	else if "`sel_depvar'" != "" {
		tempvar residsel selxb	
		_eprobit_getsvpronresid `sel_depvar' 	/// 
			`sel_indepvars' `wexp',		///
			`sel_constant'			///
			`sel_offset'			///
			cov(`YContCov') 		///
			icovycont(`IYContCov') 		/// 
			resids(`cntresids')		/// 
			touse(`touse')			///
			newresid(`residsel') 		///
			storxb(`selxb')
		local residsnosel `residsel' `residsnosel'
		tempname selb selCov selCorr
		matrix `selb' = r(b)
		matrix `bigB' = `selb',`bigB'
		local f: colfullnames `selb'
		local bigBnames `f' `bigBnames'
	}
	if `nendog' > 0  & (("`tr_depvar'" != "" | "`sel_depvar'" != "") ///	
		| `nbendog' | `noendog') {
		mata: st_matrix("`covCorr'",st_matrix(	///	 
			"`covCorr'")[1..(		///
			`initCovdim'-`nendog'-1),])
		mata: st_matrix("`initCov'",		/// 
			(1,J(1,`initCovdim'-1,.) \ 	///
			(J(`initCovdim'-1,1,.),		///
			(I(`initCovdim'-`nendog'-1),	///
			st_matrix("`covCorr'") \ 	///
			st_matrix("`covCorr'")', 	///
			st_matrix("`YContCov'")))))
	}
	else if `nendog' > 0 {
		matrix `initCov' = (1,J(1,rowsof(`YContCov'),0) \	///
				J(rowsof(`YContCov'),1,0),`YContCov') 	
	}
	else {
		mata: st_matrix("`initCov'",I(`initCovdim'))
	}		
	// Get Correlation of sel with all
	// this also gives sel residuals
	// These are bivariate generalized residuals.  
	if "`sel_depvar'" != "" & `noendog' > 0 {
		local i = `noendog'
		while `i' >= 1 {
			tempname oendog`i'b oendog`i'Cut
			tempname oendog`i'Corrsel
			tempvar oresid`i'sel
			local ncuts = `oendog_n`i'' - 1
			_eprobit_getsvpronresid			/// 
				`oendog_depvar`i'' 		/// 
				`oendog`i'xb' `wexp',		/// 
				cov(`tmpVar') 			///
				icovycont(`tmpVar') 		/// 
				resids(`residsel') 		///
				touse(`touse') 			///
				ncuts(`ncuts')			/// 
				vals(`oendog_vals`i'') 		///
				newselresid(`oresid`i'sel')	///
				selxb(`selxb') 			///
				selvar(`sel_depvar')
			matrix `oendog`i'b' = r(b)
			matrix `oendog`i'Cut' = r(cut)	
				local resids `oresid`i'sel' `resids' 
				local residsnosel
				matrix `oendog`i'Corrsel' = r(corr)	
				local k2 = `initCovdim' - `nendog' ///
					- `noendog' + `i'
				matrix `initCov'[`k2',2]=	/// 
					`oendog`i'Corrsel'[1,1]
				matrix `initCov'[2,`k2']=	/// 
					`oendog`i'Corrsel'[1,1]
				local i = `i' - 1
			}
		}
	if "`sel_depvar'" != "" & `nbendog' > 0 {
		local i = `nbendog'
		while `i' >= 1 {
			tempname bendog`i'b
			tempname bendog`i'Corrsel 
			tempvar bresid`i'sel
			local ncuts = `bendog_n`i'' - 1
			_eprobit_getsvpronresid			/// 
				`bendog_depvar`i'' 		/// 
				`bendog`i'xb' `wexp',		/// 
				cov(`tmpVar') 			///
				icovycont(`tmpVar') 		/// 
				resids(`residsel') 		///
				touse(`touse') 			///
				vals(`bendog_vals`i'') 		///
				newselresid(`bresid`i'sel')	///
				selxb(`selxb') 			///
				selvar(`sel_depvar') noconstant
			matrix `bendog`i'b' = r(b)
			local resids `bresid`i'sel' `resids'
			matrix `bendog`i'Corrsel' = r(corr)	
			local k2 = `initCovdim' - `nendog' ///
				- `nbendog' - `noendog' + `i'
			matrix `initCov'[`k2',2]=		/// 
				`bendog`i'Corrsel'[1,1]
			matrix `initCov'[2,`k2']=		///
				`bendog`i'Corrsel'[1,1]
			local i = `i' - 1
		}
	}
	if "`sel_depvar'" != "" & "`tr_depvar'" != "" & ///
		"`tr_oprobit'" != ""{
		tempname trb trCut
		tempname trCorrsel
		local ncuts = `tr_n'-1
		tempvar trresidsel
		_eprobit_getsvpronresid `tr_depvar' 	/// 
			`trxb' `wexp',			/// 
			cov(`tmpVar') 			///
			icovycont(`tmpVar') 		/// 
			resids(`residsel')		///	
			touse(`touse') 			///
			ncuts(`ncuts') vals(`tr_vals') 	///
			newselresid(`trresidsel')	///
			selxb(`selxb')			///
			selvar(`sel_depvar')
		local resids `trresidsel' `resids'		
		matrix `trb' = r(b)
		matrix `trCut' = r(cut)
		matrix `trCorrsel' = r(corr)
		local k2 = `initCovdim' - `nendog' ///
			- `nbendog' - `noendog'
		matrix `initCov'[`k2',2]=	/// 
			`trCorrsel'[1,1]
		matrix `initCov'[2,`k2']=	/// 
			`trCorrsel'[1,1]
	}
	if "`sel_depvar'" != "" & "`tr_depvar'" != "" & ///
		"`tr_oprobit'" == "" {
		tempname trb
		tempname trCorrsel
		local ncuts = `tr_n'-1
		tempvar trresidsel
		_eprobit_getsvpronresid `tr_depvar' 	/// 
			`trxb' `wexp',			/// 
			cov(`tmpVar') 			///
			icovycont(`tmpVar') 		/// 
			resids(`residsel')		///	
			touse(`touse') 			///
			vals(`tr_vals') 		///
			newselresid(`trresidsel')	///
			selxb(`selxb')			///
			selvar(`sel_depvar')
		local resids `trresidsel' `resids'		
		matrix `trb' = r(b)
		matrix `trCorrsel' = r(corr)
		local k2 = `initCovdim' - `nendog' ///
			- `nbendog' - `noendog'
		matrix `initCov'[`k2',2]=	/// 
			`trCorrsel'[1,1]
		matrix `initCov'[2,`k2']=	/// 
			`trCorrsel'[1,1]
	}
	// Get Correlation of tr with all
	if "`tr_depvar'" != "" & `noendog' > 0 {
		local i = `noendog'
		while `i' >= 1 {
			tempname oendog`i'Corrtr 
			local ncuts = `oendog_n`i'' - 1
			_eprobit_getsvpronresid			/// 
				`oendog_depvar`i'' 		/// 
				`oendog`i'xb' `wexp',		/// 
				cov(`tmpVar') 			///
				icovycont(`tmpVar') 		/// 
				resids(`trresid') 		///
				touse(`touse') 			///
				ncuts(`ncuts')			/// 
				vals(`oendog_vals`i'') 	
			matrix `oendog`i'Corrtr' = r(corr)	
			local k2 = `initCovdim' - `nendog' ///
				- `noendog' + `i'
			local k3 = `initCovdim' - `nendog' ///
				- `noendog' - `nbendog' 
			matrix `initCov'[`k2',`k3']=		/// 
				`oendog`i'Corrtr'[1,1]
			matrix `initCov'[`k3',`k2']=		/// 
				`oendog`i'Corrtr'[1,1]
			local i = `i' - 1
		}
	}
	if "`tr_depvar'" != "" & `nbendog' > 0 {
		local i = `nbendog'
		while `i' >= 1 {
			tempname bendog`i'Corrtr 
			local ncuts = `bendog_n`i'' - 1
			_eprobit_getsvpronresid			/// 
				`bendog_depvar`i'' 		/// 
				`bendog`i'xb' `wexp',		/// 
				cov(`tmpVar') 			///
				icovycont(`tmpVar') 		/// 
				resids(`trresid') 		///
				touse(`touse') 			///
				vals(`bendog_vals`i'') noconstant	
			matrix `bendog`i'Corrtr' = r(corr)	
			local k2 = `initCovdim' - `nendog' ///
				- `noendog' -`nbendog' + `i'
			local k3 = `initCovdim' - `nendog' ///
				- `noendog' - `nbendog' 
			matrix `initCov'[`k2',`k3']=		/// 
				`bendog`i'Corrtr'[1,1]
			matrix `initCov'[`k3',`k2']=		/// 
				`bendog`i'Corrtr'[1,1]
			local i = `i' - 1
		}
	}
	if `nbendog' > 0 {
		forvalues h = 1/`nbendog' {
			local i = `noendog'
			while `i' >= 1 {
				tempname oendog`i'Corrb`h' 
				local ncuts = `oendog_n`i'' - 1
				_eprobit_getsvpronresid		/// 
				`oendog_depvar`i'' 		/// 
				`oendog`i'xb' `wexp',		/// 
				cov(`tmpVar') 			///
				icovycont(`tmpVar') 		/// 
				resids(`bresid`h'') 		///
				touse(`touse') 			///
				ncuts(`ncuts')			/// 
				vals(`oendog_vals`i'') 	
				// we reestimate the cut here..
				matrix `oendog`i'Corrb`h'' = r(corr)	
				local k2 = `initCovdim' - ///
					`nendog' - `noendog' + `i'
				local k3 = `initCovdim' - ///
					`nendog' - `noendog' ///
					- `nbendog' + `h'
				matrix `initCov'[`k2',`k3']=	/// 
					`oendog`i'Corrb`h''[1,1]
				matrix `initCov'[`k3',`k2']=	/// 
					`oendog`i'Corrb`h''[1,1]
				local i = `i' - 1
			}
			local i = `nbendog'
			while `i' > `h' {
				tempname bendog`i'Corrb`h' 
				_eprobit_getsvpronresid		/// 
				`bendog_depvar`i'' 		/// 
				`bendog`i'xb' `wexp',		/// 
				cov(`tmpVar') 			///
				icovycont(`tmpVar') 		/// 
				resids(`bresid`h'') 		///
				touse(`touse') 			///
				vals(`bendog_vals`i'')  noconstant	
				matrix `bendog`i'Corrb`h'' = r(corr)	
				local k2 = `initCovdim' - ///
					`nendog' ///
					- `noendog' -`nbendog' + `i'
				local k3 = `initCovdim' - ///
					`nendog' ///
					- `noendog' - `nbendog' + `h'
				matrix `initCov'[`k2',`k3']=	/// 
					`bendog`i'Corrb`h''[1,1]
				matrix `initCov'[`k3',`k2']=	/// 
					`bendog`i'Corrb`h''[1,1]
				local i = `i' - 1
			}
		}
	}
	if `noendog' > 0 {
		forvalues h = 1/`noendog' {
			local i = `noendog'
			while `i' > `h' {
				tempname oendog`i'Corro`h' 
				_eprobit_getsvpronresid		/// 
				`oendog_depvar`i'' 		/// 
				`oendog`i'xb' `wexp',		/// 
				cov(`tmpVar') 			///
				icovycont(`tmpVar') 		/// 
				resids(`oresid`h'') 		///
				touse(`touse') 			///
				vals(`oendog_vals`i'') 		
				matrix `oendog`i'Corro`h'' = r(corr)	
				local k2 = `initCovdim' - ///
					`nendog' ///
					- `noendog' + `i'
				local k3 = `initCovdim' - ///
					`nendog' ///
					- `noendog' + `h'
				matrix `initCov'[`k2',`k3']=	/// 
					`oendog`i'Corro`h''[1,1]
				matrix `initCov'[`k3',`k2']=	/// 
					`oendog`i'Corro`h''[1,1]
				local i = `i' - 1
			}
		}
	}
	if "`sel_depvar'" == "" {
		local resids `residsnosel'
	}
	else {
		local resids `residsel' `resids'
	}
	tempname tempCov ItempCov Outb
	if (("`tr_depvar'" != "" | "`sel_depvar'" != "") ///	
		| `nbendog' | `noendog') {
		mata: st_matrix("`tempCov'",st_matrix("`initCov'")[	///
			2..`initCovdim',2..`initCovdim'])
		matrix `ItempCov' = invsym(`tempCov')
	}
	else {
		matrix `tempCov' = `YContCov'
		matrix `ItempCov' = `IYContCov'
	}

	local ncuts = `depvar_n'-1
	tempname oCorr oCov
	tempvar txb
	tempvar ttouse
	qui gen `ttouse' = `touse'
	if "`sel_depvar'" != "" {
		qui replace `ttouse' = 0 if ~`sel_depvar'
	}
        
        // avoid duplicate stripes
        qui _rmcoll `indepvars' if `touse'
        local indepvars `r(varlist)'

	_eprobit_getsvpronresid			/// 
		`depvar' 			/// 
		`indepvars' `wexp',		/// 
		cov(`tempCov') 			///
		icovycont(`ItempCov') 		/// 
		resids(`resids') 		///
		touse(`ttouse') storxb(`txb')	///
		ncuts(`ncuts') 			///
		vals(`depvar_vals')		///
		`offset' `constant'
	matrix `Outb' = r(b)
	matrix `bigB' = `Outb',`bigB'
	local f: colfullnames `Outb'
	local bigBnames `f' `bigBnames'
	tempname tCut
	matrix `tCut' = r(cut)
	local fcoln
	local coln
	local scoln
	local m = `ncuts'
	while `m' >= 1 {
		local abname=ustrleft("`depvar'",32-6)
		local cutdvnames `abname' `cutdvnames'
		local fcoln ///
		/`abname':cut`m' `fcoln'
		local coln ///
		/:dv_cut`m' `coln'
		local scoln ///
		/dv_cut`m' `scoln'
		local m = `m'-1
	}
	matrix colnames `tCut' = `coln'
	matrix `bigCut' = `tCut',`bigCut'
	local bigCutnames `coln' `bigCutnames'
	local sbigCutnames `scoln' `sbigCutnames'
	local fbigCutnames `fcoln' `fbigCutnames'	
	local k = colsof(`bigB')
	mata:st_matrix("`bigB'",st_matrix("`bigB'")[1,1..`k'])
	local nresids: word count `resids'
	tempname oCorr oCov
	matrix `oCorr' = r(corr)
	matrix `oCov' = r(corr)
	forvalues j = 1/`nresids' {
		matrix `oCov'[1,`j']=	 ///
			`oCov'[1,`j']* ///
				sqrt(`tempCov'[`j',`j']) 
		matrix `initCov'[1,`j'+1] = `oCov'[1,`j']
		matrix `initCov'[`j'+1,1] = `oCov'[1,`j']
	}

	tempname oinitCov
	matrix `oinitCov' = `initCov'	
	local colnames `depvar' 	///
		`sel_depvar'		///
		`tr_depvar' 		///
		`bendog_depvars'	/// 
		`oendog_depvars'	///
		`endog_depvars'
	matrix colnames `initCov' = `colnames'
	matrix rownames `initCov' = `colnames'
	tempname bigV
	local k = `initCovdim'
	local km1 = `k'-1
	mata:st_matrix("`bigV'",vech(lowertriangle(	///
		corr(st_matrix("`initCov'"))[2..`k',1..`km1'])))
	matrix `bigV' = `bigV''
	local fcoln
	local sfcoln
	local ffcoln
	forvalues i = 1/`k' {
		local ip1 = `i'+1
		forvalues j=`ip1'/`k' {
			local wi: word `i' of `colnames'
			local wj: word `j' of `colnames'
			local fcoln `fcoln' /:c_`j'_`i'
			local sfcoln `sfcoln' /c_`j'_`i' 	 
			local ffcoln `ffcoln' /:corr(e.`wj',e.`wi')
		} 
	}
	matrix colnames `bigV' = `fcoln'
	if `nendog' {
		local prefcoln
		local presfcoln
		forvalues i = 1/`nendog' {
			local prefcoln `prefcoln' /:v_`i'
			local presfcoln `presfcoln' /v_`i'
		}
		local fcoln `prefcoln' `fcoln'
		local sfcoln `presfcoln' `sfcoln'
		tempname tbigV
		matrix `tbigV' = vecdiag(`YContCov')
		matrix `bigV' = `tbigV',`bigV'
		local lab3 = subinstr(`"`endog_depvars'"'," ",	///
			") /:var(e.",.)
		local lab3 /:var(e.`lab3')
		local ffcoln `lab3' `ffcoln'			
	}
	local sbigVnames `sfcoln'
	local fbigVnames `ffcoln'
	local bigVnames `fcoln'
	local k = colsof(`bigB')-1 
	mata:st_matrix("`bigB'", st_matrix("`bigB'")[1,1..`k'])
	matrix colnames `bigB' = `bigBnames'
	local k = colsof(`bigCut') -1
	if `k' > 0 {
		mata:st_matrix("`bigCut'",	/// 
			st_matrix("`bigCut'")[1,1..`k'])
		matrix `bigB' = `bigB',`bigCut',`bigV'
		matrix colnames `bigB' ///
			= `bigBnames' `bigCutnames' `bigVnames'
	}
	else {
		matrix `bigB' = `bigB',`bigV'
		matrix colnames `bigB' = `bigBnames' `bigVnames'
	}
	return matrix bigB = `bigB', copy
	return local cutdvnames `cutdvnames'
	return local sbigCutnames `sbigCutnames'
	return local sbigVnames `sbigVnames'
	return local fbigVnames `fbigVnames'
	return local fbigCutnames `fbigCutnames'
end

exit
