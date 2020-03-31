*! version 1.0.0  30mar2017
program _eoprobit_initci, rclass
	syntax, [ depvar(string)	///
		depvarl(string)		///
		depvaru(string)		///
		indepvars(string)	///
		noCONstant		///
		offset(passthru)	///
		tsel_depvar(string)	///
		tsel_indepvars(string)	///
		tsel_constant(string)	///
		tsel_offset(string)	///
		tsel_ll(string)		///
		tsel_ul(string)		///
		tsel_depvarind(string)	///
		sel_depvar(string)	///
		sel_indepvars(string)	///
		sel_constant(string)	///
		sel_offset(string)	///
		tr_depvar(string)	///
		tr_indepvars(string)	///
		tr_vals(string)		///
		extr_listnum(string)	///
		tr_listnum(string)	///
		tr_oprobit(string)	///
		tr_constant(string)	///
		tr_offset(string)	///
		oendog_depvars(string)	///
		bendog_depvars(string)	///
		endog_depvars(string)	///
		nbendog(string)		///
		noendog(string)		///
		nendog(string)		///
		wexp(string)		///
		touse(string) 		///
		extr_depvar(string)	/// 
		extr_n(string)		///
		tr_n(string) *]
	local cutdvnames
	local s 
	forvalues i=1/`noendog' {
		local s `s' oendog_n`i'(string) oendog_depvar`i'(string) ///
			oendog_indepvars`i'(string)			 ///
			oendog_constant`i'(string)		
	}
	forvalues i = 1/`nbendog' {
		local s `s' bendog_n`i'(string)		///
			bendog_depvar`i'(string)	///
			bendog_indepvars`i'(string)	///
 			bendog_constant`i'(string)	 	
	}
	forvalues i = 1/`nendog' {
		local s `s' endog_depvar`i'(string)		///
				endog_indepvars`i'(string)	///
				endog_constant`i'(string)
	}
	local 0, `options'
	if `"`s'"' != "" {
		syntax , [`s' *]
	}	

	local alldepvars `tr_depvar' `tsel_depvar'`sel_depvar' `depvar'`depvarl' 
	if `nbendog' > 0 {
		forvalues i = 1/`nbendog' {
			local alldepvars `bendog_depvar`i'' `alldepvars'
		}
	}
	if `noendog' > 0 {
		forvalues i = 1/`noendog' {
			local alldepvars `oendog_depvar`i'' `alldepvars'
		}
	}
	if `nendog' > 0 {
		forvalues i = 1/`nendog' {
			local alldepvars `endog_depvar`i'' `alldepvars'
		}
	}
	local dups: list dups alldepvars
	if "`dups'" != "" {
		di as error ///
			"same dependent variable used for multiple equations"
		exit 498
	}
	local j = 1
	foreach var of local alldepvars {
		local indepvars`j' 
		local depvar`j' `var'
		if "`var'" == "`depvar'" {
			fvexpand `indepvars'
			local checkvarlist `r(varlist)'
		}
		else if "`var'" == "`sel_depvar'" {
			fvexpand `sel_indepvars'
			local checkvarlist `r(varlist)'
		}
		else if "`var'" == "`tsel_depvar'" {
			fvexpand `tsel_indepvars'
			local checkvarlist `r(varlist)'
		}
		else if "`var'" == "`tr_depvar'" {
			fvexpand `tr_indepvars'
			local checkvarlist `r(varlist)'
		}
		forvalues i = 1/`nbendog' {
			if "`var'" == "`bendog_depvar`i''" {
				fvexpand `bendog_indepvars`i''
				local checkvarlist `r(varlist)'
			}
		}
		forvalues i = 1/`noendog' {
			if "`var'" == "`oendog_depvar`i''" {
				fvexpand `oendog_indepvars`i''
				local checkvarlist `r(varlist)'
			}
		}
		forvalues i = 1/`nendog' {
			if "`var'" == "`endog_depvar`i''" {
				fvexpand `endog_indepvars`i''
				local checkvarlist `r(varlist)'
			}
		}
		foreach word of local alldepvars {
			Check, check(`checkvarlist') for(`word')
			if `r(there)' == 1 {
				local indepvars`j' ///
					`indepvars`j'' `word'
			}
		} 
		local j = `j' + 1
	}
	local varcnt = `j' - 1
	forvalues i=1/`varcnt' {
		local indepvars`i': list uniq indepvars`i'
		local indepvars`i': list sort indepvars`i'
	}
	local done = 0
	while ~`done' {
		forvalues i = 1/`varcnt' {
			local m1indepvars`i' `indepvars`i''
		}
		forvalues i = 1/`varcnt' {
			local findepvars`i' `indepvars`i''
			foreach var of local indepvars`i' {
				forvalues j = 1/`varcnt' {
					if "`depvar`j''" == "`var'" {
						local findepvars`i' 	///
							`findepvars`i'' ///
							`indepvars`j''
					}
				}
			} 
		}
		forvalues i = 1/`varcnt' {
			local indepvars`i' `findepvars`i''
			local indepvars`i': list uniq indepvars`i'
			local indepvars`i': list sort indepvars`i'
		}
		local done = 1
		forvalues i = 1/`varcnt' {
			local done = `done' & ("`m1indepvars`i''" == ///
				"`indepvars`i''")
		}		
	}
	forvalues i = 1/`varcnt' {
		local rank`i': word count `indepvars`i''		
	}
	local vcntm1 = `varcnt' - 1
	tempname cov
	tempname icov
	local orderlist
	tempname ordermat
	tempname orderrev
	matrix `orderrev' = J(1,`varcnt',.)
	local k = `varcnt'
	forvalues i = 1/`varcnt' {
		matrix `orderrev'[1,`k'] = `i'
		local k = `k' - 1
	}
	matrix `ordermat' = J(1,`varcnt',0)
	forvalues i = 0/`vcntm1' {
		forvalues j = 1/`varcnt' {
			if `rank`j'' == `i' {
				local extraopts
				if "`resids'" != "" {
					local extraopts			///
						residuals(`resids')	/// 
						sigma22(`cov')		/// 	
						isigma22(`icov')	
				}
				tempvar resid`j'
				tempname initb_`j'
				tempname initcut_`j'
				matrix `initcut_`j'' = J(1,1,.)
				// DO j
				local jorder = `orderrev'[1,`j']
				matrix `ordermat'[1,`varcnt'-`k'] = `jorder'
				local k = `k'+1
				if "`depvar`j''" == "`depvar'`depvarl'" {
tempvar ttouse
qui gen `ttouse' = `touse'
if "`sel_depvar'" != "" {
	qui replace `ttouse' = 0 if ~`sel_depvar'
}
if "`tsel_depvarind'" != "" {
	qui replace `ttouse' = 0 if ~`tsel_depvarind'
}
_erm_oprobit_getsv `depvar' `indepvars' i.`extr_depvar'`tr_depvar' `wexp', /// 
	`offset' `constant' ///
	touse(`ttouse') storeresidual(`resid`j'') `extraopts'
	matrix `initcut_`j'' = r(bcut)
				}
				if "`depvar`j''" == "`sel_depvar'" {
_erm_probit_getsv `sel_depvar' `sel_indepvars' `wexp', 	///
	`sel_offset' `sel_constant' 			///
	touse(`touse') storeresidual(`resid`j'') `extraopts'
				}
				if "`depvar`j''" == "`tsel_depvar'" {
tempvar ttsel_ll ttsel_ul
qui gen double `ttsel_ll' = `tsel_depvar' if `tsel_depvarind' & `touse'
qui gen double `ttsel_ul' = `tsel_depvar' if `tsel_depvarind' & `touse'
if "`tsel_ll'" != "" {
	qui replace `ttsel_ul' = `tsel_ll' if ~`tsel_depvarind' & ///
		(`tsel_depvar' <= `tsel_ll') & `touse'
}
if "`tsel_ul'" != "" {
	qui replace `ttsel_ll' = `tsel_ul' if ~`tsel_depvarind' & ///
		(`tsel_depvar' >= `tsel_ul') & `touse'
}
_erm_intreg_getsv `tsel_indepvars' `wexp',	/// 
	ll(`ttsel_ll') ul(`ttsel_ul')		///
	touse(`touse')	storeresidual(`resid`j'') `extraopts' ///
	depvarname(`tsel_depvar') `tsel_constant'
				}
				if "`depvar`j''" == "`tr_depvar'" {
	if "`tr_oprobit'" != "" {
		local arg oprobit
	}
	else {
		local arg probit
	}
_erm_`arg'_getsv `tr_depvar' `tr_indepvars' `wexp', 	///
	`tr_offset' `tr_constant' 			///
	touse(`touse') storeresidual(`resid`j'') `extraopts'
if "`tr_oprobit'" != "" {
	matrix `initcut_`j'' = r(bcut)
}
				}
				forvalues h = 1/`nbendog' {
					if "`depvar`j''"==	///
					"`bendog_depvar`h''" {
_erm_probit_getsv `bendog_depvar`h'' `bendog_indepvars`h'' `wexp', 	///
	`bendog_constant`h'' touse(`touse')				/// 
	storeresidual(`resid`j'') `extraopts'
					}
				}
				forvalues h = 1/`noendog' {
					if "`depvar`j''"==	///
					"`oendog_depvar`h''" {
_erm_oprobit_getsv `oendog_depvar`h'' `oendog_indepvars`h'' `wexp', 	///
	`oendog_constant`h'' touse(`touse') 				///
	storeresidual(`resid`j'') `extraopts'
	matrix `initcut_`j'' = r(bcut)
					}
				}
				forvalues h = 1/`nendog' {
					if "`depvar`j''"==	///
					"`endog_depvar`h''" {
_erm_regress_getsv `endog_depvar`h'' `endog_indepvars`h'' `wexp', 	///
	`endog_constant`h'' touse(`touse') 				///
	storeresidual(`resid`j'') `extraopts'
					}
				}
				local resids `resid`j'' `resids'
				matrix `initb_`j'' = r(b)
				matrix `cov' = r(cov)
				matrix `icov' = r(icov)
			}				
		}
	}
	tempname ibigB 
	local isbigCutnames
	local sbigCutnames
	local fbigCutnames
	local isbigVnames
	local sbigVnames
	local fbigVnames
	local bigBnames
	forvalues i = 1/`varcnt' {
		if "`depvar`i''" == "`depvar'`depvarl'" {
			tempname ibigCut
			local ncuts = colsof(`initcut_`i'')
			matrix `ibigCut' = J(1,`extr_n'`tr_n'*`ncuts',0)
			forvalues k = 1/`ncuts' {
				forvalues j = 1/`extr_n'`tr_n' {
					matrix `ibigCut'[1,		///	
					(`k'-1)*`extr_n'`tr_n'+`j'] =	///
					-`initb_`i''[1,			///
					colsof(`initb_`i'')-		///
					`extr_n'`tr_n'+`j']+		///	
					`initcut_`i''[1,`k']
					local jval: word `j' of ///
					`tr_listnum'`extr_listnum' 	
					local base
					if `j' == 1 {
						local base b
					}
					local fbigCutnames	/// 
						`fbigCutnames'	///
	/`depvar'`depvarl':`jval'`base'.`tr_depvar'`extr_depvar'#c.cut`k'
					local isbigCutnames 	///
						`isbigCutnames' ///
						/dv_cut`j'_`k'
					local sbigCutnames	///
						`sbigCutnames'	///
						/:dv_cut`j'_`k'

				}
			}
			local tbigBnames: colfullnames `initb_`i''
			local tk = colsof(`initb_`i'')-`extr_n'`tr_n'
			tempname ibigB
			matrix `ibigB' = J(1,`tk',.)
			forvalues j = 1/`tk' {
				gettoken fname tbigBnames: tbigBnames
				local bigBnames `bigBnames' `fname'
				matrix `ibigB'[1,`j'] = `initb_`i''[1,`j']
			}			
			continue, break
		}
	}
	if "`tsel_depvar'" != "" {
		forvalues i = 1/`varcnt' {
			if "`depvar`i''" == "`tsel_depvar'" {
				matrix `ibigB' = `ibigB',`initb_`i''
				local tbigBnames: colfullnames `initb_`i''
				local bigBnames `bigBnames' `tbigBnames'
				continue, break
			}
		}
	}
	if "`sel_depvar'" != "" {
		forvalues i = 1/`varcnt' {
			if "`depvar`i''" == "`sel_depvar'" {
				matrix `ibigB' = `ibigB',`initb_`i''
				local tbigBnames: colfullnames `initb_`i''
				local bigBnames `bigBnames' `tbigBnames'
				continue, break
			}
		}
	}
	if "`tr_depvar'" != "" {
		forvalues i = 1/`varcnt' {
			if "`depvar`i''" == "`tr_depvar'" {
				matrix `ibigB' = `ibigB',`initb_`i''
				local tbigBnames: colfullnames `initb_`i''
				local bigBnames `bigBnames' `tbigBnames'
				if "`tr_oprobit'" != "" {
					matrix `ibigCut' = ///
						`ibigCut',`initcut_`i''
					local ncuts = colsof(`initcut_`i'')
					local abname = ustrleft(	///
						"`tr_depvar'",32-6)
					forvalues j = 1/`ncuts' {
						local fbigCutnames	/// 
							`fbigCutnames'	///
							/`abname':cut`j'
						local cutdvnames ///
							`cutdvnames' `abname' 
						local isbigCutnames 	///
							`isbigCutnames' ///
							/t_cut`j'
						local sbigCutnames	///
							`sbigCutnames'	///
							/:t_cut`j'
					}
				} 
				continue, break				
			}
		}
	}
	if `nbendog' > 0 {
		foreach var of local bendog_depvars {
			forvalues i = 1/`varcnt' {
				if "`depvar`i''" == "`var'" {
					matrix `ibigB' = `ibigB',`initb_`i''
					local tbigBnames: ///
						colfullnames `initb_`i''
					local bigBnames `bigBnames' ///
						`tbigBnames'
					continue, break
				}				
			}	
		}
	}
	if `noendog' > 0 {
		local k = 1
		foreach var of local oendog_depvars {
			forvalues i = 1/`varcnt' {
				if "`depvar`i''" == "`var'" {
					matrix `ibigB' = `ibigB',`initb_`i''
					local tbigBnames: colfullnames ///
						`initb_`i''
					local bigBnames `bigBnames'	///
						`tbigBnames'
					if "`ibigCut'" == "" {
						tempname ibigCut
						matrix `ibigCut' = ///
							`initcut_`i''
					}
					else {
						matrix `ibigCut' = ///
							`ibigCut',`initcut_`i''
					}
					local ncuts = colsof(`initcut_`i'')
					local abname = ustrleft(	///
						"`var'",32-6)
					forvalues j = 1/`ncuts' {
						local fbigCutnames	/// 
							`fbigCutnames'	///
						/`abname':cut`j'
						local cutdvnames ///
							`cutdvnames' `abname' 
						local isbigCutnames 	///
							`isbigCutnames' ///
							/o`k'_cut`j'
						local sbigCutnames	///
							`sbigCutnames'	///
							/:o`k'_cut`j'	
					}
					continue, break				
				}
			}
			local k = `k' + 1
		}
	}
	if `nendog' > 0 {
		foreach var of local endog_depvars {
			forvalues i=1/`varcnt' {
				if "`depvar`i''"=="`var'" {
					matrix `ibigB' = `ibigB',`initb_`i''
					local tbigBnames: colfullnames ///
						`initb_`i''
					local bigBnames `bigBnames'	///
						`tbigBnames'
				}
			}
		}	
	}
	tempname tmpCorr tmpCov
	mata: st_matrix("`tmpCov'",st_matrix("`cov'")[	///
		(invorder((st_matrix("`ordermat'")))),	///
		(invorder((st_matrix("`ordermat'"))))])
	mata: st_matrix("`tmpCorr'",corr(st_matrix("`tmpCov'")))
	matrix colnames `tmpCov' = `depvar' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' ///
			`bendog_depvars' `oendog_depvars' `endog_depvars'
	matrix rownames `tmpCov' = `depvar' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' ///
			`bendog_depvars' `oendog_depvars' `endog_depvars'
	matrix colnames `tmpCorr' = `depvar' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' ///
			`bendog_depvars' `oendog_depvars' `endog_depvars'
	matrix rownames `tmpCorr' = `depvar' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' ///
			`bendog_depvars' `oendog_depvars' `endog_depvars'
	if "`ibigCut'" != "" {
		matrix `ibigB' = `ibigB',`ibigCut'		
	}
	if colsof(`cov') > 1 {
		if "`tsel_depvar'" != "" {
			matrix `ibigB' = (`ibigB',`tmpCov'[2,2])
			local sbigVnames `sbigVnames' /:v_tsel
			local isbigVnames `isbigVnames' /v_tsel
			local fbigVnames `fbigVnames' ///
				/:var(e.`tsel_depvar')
		}
		if `nendog' > 0 {
			local index = colsof(`cov') -`nendog'
			forvalues i = 1/`nendog' {
				matrix `ibigB' = (`ibigB',	///
					`tmpCov'[`index'+`i',`index'+`i'])
				local sbigVnames `sbigVnames' /:v_`i'
				local isbigVnames `isbigVnames' /v_`i'
				local fbigVnames `fbigVnames' ///
					/:var(e.`endog_depvar`i'')
			}
		}
		local dvlist `depvar'`depvarl' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' 				///
			`bendog_depvars' `oendog_depvars' 	///
			`endog_depvars'
		forvalues i = 1/`varcnt' {
			local ip1 = `i' + 1
			forvalues j =`ip1'/`varcnt' {
				local dvi: word `i' of `dvlist'
				local dvj: word `j' of `dvlist'
				matrix `ibigB' = (`ibigB',	///
					`tmpCorr'[`i',`j'])
				local sbigVnames `sbigVnames'	///
					/:c_`j'_`i'
				local isbigVnames `isbigVnames'	///
					/c_`j'_`i'
				local fbigVnames `fbigVnames'	///
					/:corr(e.`dvj',e.`dvi')
			}
		}		
	}
	matrix colnames `ibigB' = `bigBnames' `sbigCutnames' `sbigVnames'
	return matrix bigB = `ibigB', copy
	return local cutdvnames `cutdvnames'
	return local sbigCutnames `isbigCutnames'
	return local sbigVnames `isbigVnames'
	return local fbigVnames `fbigVnames'
	return local fbigCutnames `fbigCutnames'
end

program Check, rclass
	syntax, [check(string) for(string)]
	local there = 0
	foreach word of local check {
		_ms_parse_parts `word'
		if "`r(type)'" == "variable" | "`r(type)'" == "factor" {
			if "`r(ts_op)'`r(name)'" == "`for'" {
				local there = 1
				continue, break
			}
		}
		else if "`r(type)'" == "interaction" | ///
			"`r(type)'" == "product" {
			local k = r(k_names)
			forvalues i = 1/`k' {
				if "`r(ts_op`i')'`r(name`i')'" == "`for'" {
					local there = 1
					continue, break
				}			
			}
			if `there' {
				continue, break
			}			
		}
	}
	return local there = `there'
end	
exit
