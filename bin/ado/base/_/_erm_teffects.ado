*! version 1.0.2  02mar2018
program _erm_teffects, rclass
	syntax [, *]
	_get_diopts diopts options, `options'
        local 0 `", `options'"'
	syntax [, TLevel(numlist)		 ///				
		ate				 ///
		atet 		 		 ///
		POMean		 		 /// 
		OUTLevel(numlist) 		 ///
		subpop(passthru) 		 ///
		total      /* undocumented */    ///
		STRuctural /* undocumented */ ]
	if "`structural'" == "" {
		local total total
	}
	if "`structural'" !="" & "`atet'" != "" {
		opts_exclusive "structural atet"
	}
	if "`structural'" != "" & "`total'" != "" {
		opts_exclusive "structural total"
	}
	if "`e(trdepvar)'`e(extrdepvar)'" == "" {
		di as err "{bf:estat teffects} not appropriate;"
		di as err "model has no treatment"
		exit 498
	}
	if "`ate'`atet'`pomean'" == "" {
		local ate ate
	}
	if "`ate'" != "" & "`e(treatrecursive)'"!="" {
		di as error "{p 0 4 2}endogenous "
		di as error "regressors depend on "
		di as error "the treatment; try "
		di as error "{bf:atet} instead{p_end}"
		exit 498
	}
	if "`pomean'" != "" &"`e(treatrecursive)'"!="" {
		di as error "{p 0 4 2}endogenous "
		di as error "regressors depend on "
		di as error "the treatment{p_end}"
		exit 498
	}
	else if "`pomean'" != "" & "`ate'" != "" {
		opts_exclusive "pomean ate"
	}
	else if "`pomean'" != "" & "`atet'" != "" {
		opts_exclusive "pomean atet"
	}
	else if "`ate'" != "" & "`atet'" != "" {
		opts_exclusive "ate atet"
	}
	if "`atet'" != "" & "`subpop'" == "" {
		local alltvals `e(trvalues)'`e(extrvalues)'
		local wc = wordcount("`alltvals'")
		local sub: word 2 of `alltvals'
		if `wc' > 2 {
			di as text "{p 0 4 2}(subpopulation of first "
			di as text ///
			"non-control treatment level assumed){p_end}"
		}
		local subpop subpop(if `e(extrdepvar)'`e(trdepvar)'==`sub')
	}
	if "`tlevel'" != "" {
		foreach num of numlist `tlevel' {
			capture Eq `"`num'"' `e(extrdepvar)'`e(trdepvar)'
			if _rc {
				di as err "{bf:tlevel()} "	///
					"incorrectly specified;"
				Eq `"`tlevel'"' `e(trdepvar)'
			}
			else if `s(icat)' == 1  & "`ate'`atet'" != "" {
				di as error 				///	
				"{bf:tlevel()} must contain valid " 	///
				"noncontrol treatment levels"
				exit 198
			}
		}
	}
	else {
		local tlevel `e(trvalues)'`e(extrvalues)'
		if "`ate'`atet'" != "" {
			gettoken control tlevel: tlevel
		}
	}
	local outlevelspec 0
	if "`outlevel'" != "" {
		if inlist("`e(cmd)'", "eregress", "eintreg", 	///
					"xteregress", "xteintreg") {
			di as err "{bf:outlevel()} incorrectly " ///
				"specified;"
			di as err "{p 0 4 2}an outcome value "	
			di as err "may only be specified for "	
			di as err "categorical dependent "
			di as err "variables{p_end}"
			exit 498
		}
		foreach num of numlist `outlevel' {
			capture Eq `"`num'"' `e(odepvar)'			
			if _rc {
				di as err "{bf:outlevel()} "	///
					"incorrectly specified;"
				Eq `"`num'"' `e(odepvar)'
			}
		}
		local outlevelspec 1		
	}
	else {
		local outlevel
		if "`e(cmd)'" == "eoprobit"  | "`e(cmd)'" == "xteoprobit" {
			local k = e(k_cat1)
			tempname cat
			matrix `cat' = e(cat1)
			forvalues i = 1/`k' {
				local outval = `cat'[`i',1]
				local outlevel `outlevel' `outval'
			}
		}
		else if "`e(cmd)'" == "eprobit" | "`e(cmd)'" == "xteprobit" {
			local outlevel 1
		}
	}
	if "`atet'`ate'" != "" {
		local alllevels `e(extrvalues)'`e(trvalues)'
		gettoken control alllevels: alllevels		
	}

	// determine stripes
	if inlist("`e(cmd)'","eregress","eintreg",		///
				"xteregress", "xteintreg") | 	///
		(("`e(cmd)'" == "eprobit" | "`e(cmd)'" 		///
		== "xteprobit") & ~`outlevelspec') {
		local stripes 
		foreach num of numlist `tlevel' {
			if "`ate'" != "" {
				local stripes `stripes' ///
			ATE:r`num'vs`control'.`e(extrdepvar)'`e(trdepvar)'	
			}
			else if "`atet'" != "" {
				local stripes `stripes' ///
			ATET:r`num'vs`control'.`e(extrdepvar)'`e(trdepvar)'	
			}
			else {
				local stripes ///
			`stripes' POmean:`num'.`e(extrdepvar)'`e(trdepvar)'
			}
		}
	}
	else {
		local i = 1
		foreach onum of numlist `outlevel' {
			local ostripe`i' 
			local dstripe`i'
			local f: value label `e(odepvar)'
			local flab 0
			if "`f'" != "" {
				local flab 1
				local f: label `f' `onum'	
			}
			else {
				local f `onum'
			}
			if "`atet'" != "" {
				local ostripe`i' ATET_Pr`onum'			
			}
			else if "`ate'" != "" {
				local ostripe`i' ATE_Pr`onum'
			}
			else {					
				local ostripe`i' POmean_Pr`onum'
			}
			if `flab' {
				if "`structural'" != "" & ///
					wordcount("`e(depvar_dvlist)'") > 1 {
					local dstripe`i' Structural ///
						Pr(`e(odepvar)'=`onum'=`f')
				}
				else {
					local dstripe`i' ///
						Pr(`e(odepvar)'=`onum'=`f')
				}
			}
			else {
				tempname v
				matrix `v' = e(varfull)
				if "`structural'" != "" & ///
					wordcount("`e(depvar_dvlist)'") > 1 {
					local dstripe`i' Structural ///
						Pr(`e(odepvar)'=`onum')

				}
				else {
					local dstripe`i' ///
						Pr(`e(odepvar)'=`onum')
				}
			}
			foreach num of numlist `tlevel' {
				if "`atet'" != "" {
					local stripes `stripes' ///
		ATET_Pr`onum':r`num'vs`control'.`e(extrdepvar)'`e(trdepvar)'	
				}
				else if "`ate'" != "" {
					local stripes `stripes' ///
		ATE_Pr`onum':r`num'vs`control'.`e(extrdepvar)'`e(trdepvar)'	
				}
				else {
					local stripes ///
		`stripes' POmean_Pr`onum':`num'.`e(extrdepvar)'`e(trdepvar)'
				}
			}
			local i = `i' + 1
		}
	}
	local margop `subpop'
	if "`e(vcetype)'" == "Robust" | "`e(vcetype)'" == "Linearized" {
		local margop `margop'  vce(unconditional) 
	}

	// Form margins command
	if inlist("`e(cmd)'","eregress","eintreg","xteregress","xteintreg") {
		foreach num of numlist `tlevel' {
			if "`ate'" != "" {
				local arg te
			}
			else if "`atet'" != "" {
				local arg tet
			}
			else {
				local arg pomean
			}
			if "`structural'" != "" {
				local arg `arg' structural
			}
			if "`total'" != "" {
				local arg `arg' total
			}
			local margop `margop' predict(`arg' tlevel(`num'))
		}
	}
	else {
		foreach onum of numlist `outlevel' {
			// if there is a label for outcome level
			// put that value in
			local f: value label `e(odepvar)'
			if "`f'" != "" {
				local f: label `f' `onum'	
			}
			else {
				local f `onum'
			}
			foreach num of numlist `tlevel' {
				if "`ate'" != "" {
					local arg te
				}
				else if "`atet'" != "" {
					local arg tet
				}
				else {
					local arg pomean
				}
				if "`structural'" != "" {
					local arg `arg' structural
				}
				if "`total'" != "" {
					local arg `arg' total
				}
				local margop `margop' ///
					predict(`arg' tlevel(`num') ///
					outlevel(`f'))
			}
		}
	}
	local ecmd = "`e(cmd)'"
	tempvar touse otouse ttouse
	gen `touse' = e(sample)
	gen `ttouse' = `touse'
	gen `otouse' = `touse'
	tempfile estres
	qui estimates save "`estres'"
	qui margins, `margop' post
	local clustvar = "`e(clustvar)'"
	local vce `e(vce)'
	local vcetype `e(vcetype)'
	tempname b V
	matrix `b' = e(b)
	matrix `V' = e(V)
	matrix colnames `b' = `stripes'
	matrix rownames `V' = `stripes'
	matrix colnames `V' = `stripes'
	DummyPost, b(`b') v(`V') touse(`ttouse')
	mata: st_global("e(PredLegend)","_erm_teffects_pred_legend")
	if ("`ecmd'" == "eoprobit" | "`e(cmd)'" == "xteoprobit") ///
		| `outlevelspec' {
		local i = 1
		foreach onum of numlist `outlevel' {
			mata:st_global("e(ostripe`i')",`"`ostripe`i''"')
			mata:st_global("e(dstripe`i')",`"`dstripe`i''"')
			local i = `i' + 1
		}
		mata st_numscalar("e(kod)",`i'-1)
		margins, `diopts'
		local i = 1
		foreach onum of numlist `outlevel' {
			mata:st_global("e(ostripe`i')","")
			mata:st_global("e(dstripe`i')","")
			local i = `i' + 1
		}
	}
	else {
		margins, `diopts' nopredictlegend
	}
	tempname table
	matrix `table' = r(table)
	mata: st_global("e(PredLegend)","")	
	qui estimates use "`estres'"
	qui estimates esample: if `otouse', replace	
	return matrix b = `b'
	return matrix V = `V'
	return local vce `vce'
	if "`vce'" == "delta" {
                di ""
                di as text ///
                "{p 0 6 2 67}Note: Standard errors treat sample covariate " ///
                "values as fixed and not a draw from the population.  " ///
                "If your interest is in population rather than " ///
		"sample effects, refit your model using " ///
		"{bf:vce(robust)}.{p_end}"		
	}
	return local vcetype `vcetype'
	return local clustvar `clustvar'
	return matrix table = `table'
end

program DummyPost, eclass
	syntax, b(string) v(string) touse(string)
	tempname tb tV
	matrix `tb' = `b'
	matrix `tV' = `v'
	ereturn repost b=`tb' V=`tV', esample(`touse') rename
end

program define Eq, sclass
	sret clear
	args out eqvar
	tempname eqvals
	tempname eqnval
	if "`eqvar'" == "`e(extrdepvar)'" {
		local roweqvar: word count `e(extrvalues)'
		matrix `eqvals' = J(1,`roweqvar',.)
		local vallist `e(extrvalues)'
		forvalues i = 1/`roweqvar' {
			gettoken val vallist: vallist
			matrix `eqvals'[1,`i'] = `val' 
		}
	}
	else {
		matrix `eqvals' = e(catvals)
		matrix `eqnval' = e(nvals)
		local coleqvar = colnumb(`eqvals',"`eqvar'")
		local roweqvar = `eqnval'[1,`coleqvar']
		local neqvarvals = `roweqvar'
		matrix `eqvals' = `eqvals'[1..`roweqvar',`coleqvar']'
	}	
	local i = 1
	local f: value label `eqvar'
	local icat
	if "`f'" != "" {
		cap label list `f'
		local k1 = r(min)
		local k2 = r(max)
		local j = 1
		forvalues i = `k1'/`k2' {
			local f2: label `f' `i'
			if ltrim(`"`out'"') == ltrim(`"`f2'"') {
				local icat `j'
				continue, break
			}
			local j = `j' + 1
		}
		if "`icat'" != "" {
			sret local icat `icat'
			exit
		}
	}
	if substr(ltrim(`"`out'"'),1,1)=="#" {
		local out = substr(ltrim(`"`out'"'),2,.)
		Chk, eqvar(`eqvar') test(confirm integer number `out')
		Chk, eqvar(`eqvar') test(assert `out' >= 1)
		capture assert `out' <= `roweqvar'
		local cat = `roweqvar'
		if _rc {
			di in red "there is no outcome #`out'" _n /*
			*/ "there are only `cat' categories of `eqvar'"
			exit 111
		}
		sret local icat `"`out'"'
		exit
	}
	Chk, eqvar(`eqvar') test(confirm number `out')
	local i = 1
	while `i' <= `roweqvar' {
		if `out' == el(`eqvals',1,`i') {
			sret local icat `i'
			exit
		}
		local i = `i' + 1
	}

	di in red `"outcome `out' not found for `eqvar'"'
	Chk, eqvar(`eqvar') test(assert 0) /* return error */
end

program define Chk
	syntax, eqvar(string) test(string)
	capture `test'
	if _rc {
		di in red "must specify a value of `eqvar'," /*
		*/ _n "or #1, #2, ..."
		exit 111
	}
end

	
	

