*! version 1.4.7  02dec2019

program define frac_154, eclass
	local vv : di "version " string(_caller()) ":"
	version 8

	if replay() {
		if "`e(cmd)'" == "" | "`e(fp_cmd2)'" != "fracpoly" {
			error 301
		}
		syntax [, COMpare SEQuential *]
		if `"`e(cmd2)'"' != "" {
			di in blue `"->`e(cmd2)'"'
			`e(cmd2)', `options'
		}
		else {
			di in blue `"->`e(cmd)'"'
			`e(cmd)', `options'
		}
		fraccomp, `compare' `sequential'
		exit
	}

	gettoken cmd 0 : 0, parse(" ,")
	frac_chk `cmd' 
	if `s(bad)' {
		di as err "invalid or unrecognized command, {bf:`cmd'}"
		exit 198
	}
	/*
		dist=0 (normal), 1 (binomial), 2 (poisson), 3 (cox), 4 (glm),
		5 (xtgee), 6 (ereg/weibull), 7 (stcox/streg).
	*/
	local dist `s(dist)'
	local glm `s(isglm)'
	local qreg `s(isqreg)'
	local xtgee `s(isxtgee)'
	local normal `s(isnorm)'

	if `dist' != 7 {
		gettoken lhs 0 : 0, parse(" ,")
		if `dist' == 8 {
			gettoken lhs2 0 : 0, parse(" ,")
			local lhs `lhs' `lhs2'
		}
	}
	gettoken star 0 : 0, parse(" ,")
	local star "`lhs' `star'"
	/*
		Look for fixpowers
	*/
	local done 0
	gettoken nxt : 0, parse(" ,")
	while !`done' {
		local done 1 
		if "`nxt'"!="" & "`nxt'"!="," { 
			cap confirm num `nxt'
			if _rc==0 { 
				local fixpowe `fixpowe' `nxt'
				local done 0 
				gettoken nxt 0 : 0, parse(" ,")
				gettoken nxt   : 0, parse(" ,")
			}
		}
	}
	local 0 `"`star' `0'"'
	local search = ("`fixpowe'"=="")
	if `search' {
		local srchopt ADDpowers(str) DEVthr(real 1e30) /*
			*/ POwers(numlist) DEGree(int 2) LOg COMpare SEQuential
	}

	if `dist' == 8 local minv 3
	else if `dist' != 7 local minv 2
	else local minv 1

	syntax varlist(min=`minv') [if] [in] [aw fw pw iw] [, ///
	 restrict(string) DEAD(str) CATzero EXPx(str) ORIgin(str) ZERo ///
	 noCONstant noSCAling ADJust(str) CENTer(str) NAme(str) `srchopt' * ]
	local small 1e-6

	if ("`adjust'"=="") {
		local adjust "`center'"
	}
	else if ("`center'"!="") {
		di as err "options {bf:adjust()} and {bf:center()} may not be specified together"
		exit 198
	}

	if "`constant'"=="" & "`cmd'"=="regress" & "`options'"!="" {
		/* -regress- has syntax noConstant		*/
		/*  do not let it quietly passthru to -regress- */
		/*  in the options macro			*/
		CheckForNoConstant, `options' 
		local constant `s(constant)'
		local options `"`s(options)'"'
	}

	frac_cox "`dead'" `dist'
	local cz="`catzero'"!=""
	if `cz' local zero zero
	if `search' {
		if `degree'<1 | `degree'>9 {
			di as err "invalid option {bf:degree()}"
			exit 198
		}
		local df=2*`degree'
		local odddf=(2*int(`df'/2)<`df')
	}
	else 	local df 1

	local lin=("`fixpowe'"=="1") & ("`zero'"=="") & ("`catzero'"=="")

	if "`constant'"=="noconstant" {
		if "`cmd'"=="fit" | "`cmd'"=="cox" | "`cmd'"=="stcox" | /*
			*/ "`cmd'"=="streg" | "`cmd'"=="clogit" |	/*
			*/ "`cmd'"=="logistic" {
			di as err "option {bf:noconstant} invalid with command {bf:`cmd'}"
			exit 198
		}
		local options "`options' nocons"
	}

	/*
	 	Read powers to be searched into a variable, `p'
	*/
	if `search' {
		if "`powers'"=="" local powers "-2,-1,-.5,0,.5,1,2,3"
		local pwrs "`powers' `addpowers'"
		frac_pq "`pwrs'" 1 1
		local np `r(np)'
		if `np'<1 {
			di as err "no powers given"
			exit 2002
		}
		local pwrs "`r(powers)'"
		forvalues i=1/`np' {
			local p`i' `r(p`i')'
		}
	}
	ereturn clear 		
	tokenize `varlist'
	if `dist' == 8 {	// intreg
		local y1 `1'
		local y2 `2'
		local y `y1' `y2'
		local rhs `3'
		mac shift 3
	}
	else if `dist' != 7 {
		local y `1'
		local rhs `2'
		mac shift 2
	}
	else {	// dist = 7: stcox, streg, stpm
		local y  _t
		local rhs `1'
		mac shift
	}
	local base `*'
	tempvar touse x lnx
	
	quietly {
		mark `touse' [`weight' `exp'] `if' `in'
		if `dist' == 8 {
			replace `touse' = 0 if `y1'>=. & `y2'>=.
			markout `touse' `rhs' `base' `dead'
		}
		else markout `touse' `rhs' `y' `base' `dead'
		lab var `touse' "fracpoly sample"
		if "`dead'"!="" {
			local options "`options' dead(`dead')"
		}
		if "`restrict'"!="" {
/*
	-restrict()- becomes part of touse for estimation purposes;
	only for fracgen is the original touse used.
*/
			tempvar touse_user
			gen byte `touse_user' = 1 `if'	// ! PR bug fix
			frac_restrict `touse' `restrict'
			local restrict restrict(`restrict')
		}
		else	local touse_user `touse'
	/*
		Deal with weights.
	*/
		frac_wgt `"`exp'"' `touse' `"`weight'"'
		local mnlnwt = r(mnlnwt) /* mean log normalized weights */
		local wgt `r(wgt)'
		gen double `x'=`rhs' if `touse'
		gen double `lnx'=.
		frac_xo `x' `lnx' `lin' "`expx'" "`origin'" /*
			*/ "`zero'" "`scaling'" `rhs' `touse'
		local nobs = r(N)
		if r(shifted)==0 {
			local zeta `r(zeta)'
			local shift 0
		}
		else 	local shift `r(zeta)'
		local kx `"`r(expxest)'"'
		local scalfac `r(scale)'
		if `cz' {
			tempvar catz
			gen byte `catz'=`x'<=0
		}
	}
	if `dist' != 7 local yvar `y'
	/*
		Determine residual and model df.
	*/
	qui regress `y' `base' `wgt' if `touse'
	local rdf=e(df_r)+("`constant'"=="noconstant")
	/*
		Calc deviance=-2(log likelihood) for regression on covars only,
		allowing for possible weights.
	*/
	if "`constant'"!="" & `dist'>0 {
		if `dist' == 1 {
			/* logit will allow zero vector to be dropped	*/
			/*  by _rmcoll and complete w/out error		*/
			tempvar z0
			qui gen `z0' = 0
		}
		else {
			/* all others dev0 = 0				*/
			local scale = 1
			local dev0 = .
		}
	}
	if "`dev0'" == "" {
		`vv' ///
		qui `cmd' `yvar' `z0' `base' `wgt' if `touse', `options'
		if `xtgee' & "`base'"=="" global S_E_chi2 0
		if `glm' {
			/* Note: with Stata 8 scale param is e(phi); 	*/
			/*  was e(delta) in Stata 6			*/
			/* Also e(dispersp) has become e(dispers_p).	*/
			local scale 1
 			if abs(e(dispers_p)/e(phi)-1)>`small' & /*
			*/ abs(e(dispers)/e(phi)-1)>`small' {
				local scale = e(phi)
 			}
		}
		frac_dv `normal' "`wgt'" `nobs' `mnlnwt' `dist' /*
			*/ `glm' `xtgee' `qreg' "`scale'"
		local dev0 = r(deviance)
		if `normal' local rsd0= e(rmse)
	}
	if `search' {
		local m `degree'
		if "`log'"!="" {
			di _n as txt "Model #      Deviance " _cont
			if `normal' di as txt "  Res S.D. " _cont
			forvalues i=1/`m' {
				di as txt " Power " `i' _cont
			}
			di _n
		}
	/*
		Go!
	*/
		forvalues i=1/`np' {
			local pi `p`i''
			tempvar x`i'
			qui gen double `x`i''=cond(`pi'==0, `lnx', /*
		 	*/ cond(`pi'==1, `x', cond(`x'==0,0,`x'^`pi')))
		}
		local i 0
		while `i'<`m' {
			local j`i' 0
			local ++i
			tempvar xp`i'
			qui gen double `xp`i''=.
			local j=`i'+`i'-1
			local dev`j' `dev0' /* min deviance for df=j */
			local ++j
			local dev`j' `dev0'
		}
		local j`m' 1
		local i `m'
		local kount 0  /* no. of models processed */
		local kountd 0 /* no. of models with deviance<`devthr' */
		local deg `j`m''
		local done 0
		while !`done' {
			if `i'<`m' {
				local ji `j`i''
				qui replace `xp`i''=`x`ji''
				local l `i'
				while `l'<`m' {
					local l=`l'+1
					local j`l' `ji'
					local l1=`l'-1
					qui replace `xp`l''=`xp`l1''*`lnx'
				}
				if "`log'"=="" di "." _cont
			}
			else qui replace `xp`m''=`x`j`m'''
	/*
		Test for any power being 1 (i.e. odd-df model)
	*/
			local one 0
			local l 0
			while `l'<`m' {
				local ++l
				if "`p`j`l'''"=="1" local one 1
			}
			if !`odddf' | (`deg'<`m') | `one' {
				local dfi=2*`deg'-`one'
				local i 1
				local xlist
				while `i'<=`m' {
					if `j`i''>0 { 
						local xlist "`xlist' `xp`i''" 
					}
					local ++i
				}
				local ++kount
				`vv' ///
				cap `cmd' `yvar' `xlist' `catz' `base' `wgt' /*
					*/ if `touse', `options'
				if _rc == 0 {
					frac_dv `normal' "`wgt'" `nobs'    /*
					 */ `mnlnwt' `dist' `glm' `xtgee'  /*
					 */ `qreg' "`scale'"
					local dev = r(deviance)
					if `normal' {
						local rsd=e(rmse)
						if `dfi'==1 local rsd1 `rsd'
					}
				}
				else if _rc==1 {
					error 1
				}
				else local dev = .
				
				if `dev'<`dev`dfi'' {
					local dev`dfi' `dev'
					if `normal' local rsd`dfi' `rsd'
					local i 1
					local pm`dfi'
					while `i'<=`m' {
						if `j`i''>0 {
							local pm `p`j`i'''
							local pm`dfi' /*
							 */" `pm`dfi'' `pm'"
						}
						local ++i
					}
				}
				if `dev'<`devthr' local ++kountd
				if "`log'"!="" {
					di as res %5.0f `kount' /*
				 	*/ _col(10) %12.3f `dev' _cont
					if `normal' di "   " %8.0g `rsd' _cont
					local i `m'
					while `i'>0 {
						if `j`i''==0 di _skip(6) ". " _cont
						else di as res %8.1f `p`j`i''' _cont
						local --i
					}
					di
				}
				if `deg'==1 {
					local fppow `p`j`m'''
					local fpdev`j`m'' "`fppow' `dev'"
				}
			}
	/*
		Increment the first possible index (of loop i) among indices of
		loops m, m-1, m-2, ..., 1
	*/
			local i `m'
	/*
		Finish after all indices have achieved their upper limits (np).
	*/
			while `j`i''==`np' {
				local --i
			}
			if `i'==0 local done 1
			else {
				if `j`i''==0 local deg = `m'-`i'+1
				local ++j`i'
			}
		}
	/*
		Update the results for even df to include odd df
	*/
		local i 2
		while `i'<=`df' {
			local j=`i'-1
			if `dev`j''<`dev`i'' {
				local dev`i' `dev`j''
				if `normal' local rsd`i' `rsd`j''
				local pm`i' "`pm`j''"
			}
			local i=`i'+2
		}
		if "`log'"=="" di
	}
	/*
		Create FP transformation(s) of xvar for final model
	*/
	if `search' local pwrs `pm`df''
	else local pwrs `fixpowe'
	if "`expx'"!=""   local e "expx(`expx')"
	if "`origin'"!="" local o "origin(`origin')"
	if "`adjust'"!="" local a "adjust(`adjust')"
	if "`name'"!=""   local n "name(`name')"
	if !`lin' | (`lin' & "`e'`o'`a'"!="") {
		fracgen `rhs' `pwrs' if `touse_user', `restrict' sayesamp replace /*
	 	*/ `zero' `catzero' `scaling' `a' `e' `o' `n'
		local xp `r(names)'
	}
	else local xp `rhs'
	/*
		Fit final model with permanent e(sample)=`touse' filter
	*/
	`vv' ///
	`cmd' `yvar' `xp' `base' `wgt' if `touse', `options'
	if !`search' {
	/*
		Deviance for fixed-powers model.
		Note that `dev1' is stored in e(fp_dlin), deviance for a
		linear model, even when `fixpowe' is not 1; similarly 
		for `rsd1'.
	*/
		frac_dv `normal' "`wgt'" `nobs' `mnlnwt' `dist' `glm' /*
	 	*/ `xtgee' `qreg' "`scale'"
		local dev1 = r(deviance)
		if `normal' local rsd1=e(rmse)
		local pm1 `fixpowe'
	}
	di as txt "Deviance:" as res %9.2f `dev`df'' as txt ". " _cont
	local dev `dev`df''
	if `search' {
		di as txt "Best powers of " as res "`rhs'" as txt " among " /*
	 	*/ as res `kount' as txt " models fit: " as res "`pwrs'" _cont
		if `devthr'<1e30 { 
			di _n as txt "Number of models with deviance < " /*
	 		*/ as res `devthr' as txt ": " as res `kountd' _cont 
		}
		di as txt "." _cont
	}
	di
	ereturn scalar fp_d0 = `dev0'
	cap ereturn scalar fp_s0 = `rsd0'
	ereturn scalar fp_dlin = `dev1'
	global S_E_d0 `dev0'				/* double save */
	global S_E_s0 `rsd0'				/* double save */
	global S_E_dlin `dev1'				/* double save */
	if `normal' {
		ereturn scalar fp_slin = `rsd1'
		* global S_E_slin `rsd1' 			/* double save */
	}
	local i 2
	local j 1
	while `i'<=`df' {
		ereturn scalar fp_d`j' = `dev`i''
		ereturn local fp_p`j' `pm`i''		/* PR bug fix */
		global S_E_d`j' `dev`i''		/* double save */
		global S_E_p`j' `pm`i''			/* double save */
		if `normal' {
			ereturn scalar fp_s`j' = `rsd`i''
			global S_E_s`j' `rsd`i''	/* double save */
		}
		local i=`i'+2
		local j=`j'+1
	}
	/*
		New code in v 1.4.7 for consistency with mfracpol
	*/
	ereturn local fp_x1 `rhs'
	ereturn local fp_k1 `pwrs'
	local nbase: word count `base'
	local i 0
	while `i'<`nbase' {
		local i=`i'+1
		local j=`i'+1
		ereturn local fp_x`j' : word `i' of `base'
		ereturn local fp_k`j' 1
	}
	/*
		End of new code in v 1.4.7 for consistency with mfracpol
	*/
	if `search' {
		local i `np'
		while `i'>0 {
			ereturn local fp_bt`i' `fpdev`i''
			local i=`i'-1
		}
	}
	ereturn scalar fp_dev = `dev'
	ereturn scalar fp_catz = `cz'
	ereturn scalar fp_nx = `nbase'+1
	ereturn scalar fp_df = `df'
	ereturn scalar fp_rdf = `rdf'
	ereturn scalar fp_N = `nobs'
	ereturn local  fp_opts `options'
	ereturn local  fp_t1t "Fractional Polynomial"
	ereturn local  fp_pwrs `pwrs'
	ereturn local  fp_wgt "`weight'"
	ereturn local  fp_wexp "`exp'"
	ereturn local  fp_xp `xp'
	ereturn local  fp_base `base'
	ereturn local  fp_rhs `rhs'
	ereturn local  fp_depv `y'
	ereturn local  fp_fvl `xp' `base'
	ereturn scalar fp_dist = `dist'
	ereturn local  fp_fprp "no"
	ereturn scalar fp_srch = `search'
	ereturn scalar fp_sfac = `scalfac'
	ereturn scalar fp_shft = `shift'
	ereturn local  fp_xpx `kx'
	ereturn local  fp_cmd "fracpoly"
	ereturn local  fp_cmd2 "fracpoly"

	global S_E_base `base'			/* double save */
	global S_E_df `df'			/* double save */
	global S_E_depv `y'			/* double save */
	global S_E_wgt "`weight'"		/* double save */
	global S_E_exp "`exp'"			/* double save */
	global S_E_fp fracpoly			/* double save */
	global S_E_fp2 fracpoly			/* double save */
	global S_E_nobs `nobs'			/* double save */
	global S_E_pwrs `pwrs'			/* double save */
	global S_E_rdf `rdf'			/* double save */
	global S_E_rhs `rhs'			/* double save */
	global S_E_xp `xp'			/* double save */
	global S_E_cmd `cmd'			/* double save */

	fraccomp, `compare' `sequential'
end

program define fraccomp /* report model comparisons */
	syntax [, COMpare SEQuential ]
	if "`compare'`sequential'"=="" | e(fp_srch)==0 exit
	local normal=(e(fp_dist)==0)
	local cz = e(fp_catz)
	if `cz' local catz " (+)"
	local dash "       {hline 2}"
	local ddup=63+15*`normal'
	di as txt _n "Fractional polynomial model comparisons:"
	di as txt "{hline `ddup'}"
	di as txt abbrev("`e(fp_rhs)'",12) _col(18) "df       Deviance   " _cont
	if `normal' di as txt "   Res. SD   " _cont
	di as txt "Dev. dif.  P (*)  Powers" 
	di as txt "{hline `ddup'}"
	local maxdf = e(fp_df)
	local degree = 1+int((`maxdf'-1)/2)
// PR 22mar2009 -start-
	frac_eqmodel k
	if "`sequential'"=="" {		// default is closed-test-style presentation
		local n1_0 = (`k'+1)*`degree' + `k'*`cz' // df for highest fp
		local n2 = e(fp_rdf) - `n1_0' // residual df 
		local dev0 = e(fp_d`degree')
		local j 0
		while `j'<=`maxdf' {
			local m = 1 + int((`j' - 1) / 2)	// degree of model being reported
			if `j' == 0 local idf 0
			else local idf = cond(`j' == 1, `k' * (1 + `cz'), (`k' + 1) * `m' + `k' * `cz')
			if `j'<`maxdf' {
				// denominator df for F-tests (`n1' is numerator)
// PR deletion 14May2017: `n2' does not change since most complex model
// does not change
//				local n2 = e(fp_rdf) - `idf'
				if `j'==0 {
					di as txt "Not in model" _col(18) as res %2.0f `idf' _col(22) _cont
					local dev = e(fp_d0)
					local rsd = e(fp_s0)
					if `maxdf' == 1 local n1 = `k' * (1 + `cz')
					else local n1 = (`k' + 1) * `degree' + `k' * `cz'
					local pwr
				}
				else if `j'==1 {
					di as txt "Linear`catz'" _col(18) as res %2.0f `idf' _col(22) _cont
					local dev = e(fp_dlin)
					local rsd = e(fp_slin)
					local n1 = (`k' + 1) * `degree' - `k'
					local pwr 1
				}
				else {
					di as txt "m = `m'`catz'" _col(18) as res %2.0f `idf' _col(22) _cont
					local dev = e(fp_d`m')
					local rsd = e(fp_s`m')
					local n1 = (`degree' - `m') * (`k' + 1)
					local pwr `e(fp_p`m')'
				}
				local d = `dev'-`dev0'
				frac_pv `normal' "`e(fp_wgt)'" `e(fp_N)' `d' `n1' `n2'
				local P = r(P)

				if `j'==1 global S_E_Plin `P'
				else global S_E_P`m' `P'

				di as res %13.3f `dev' _cont
				if `normal' di as res _skip(5) %8.0g `rsd' _cont
				di as res _skip(3) %7.3f `d' %9.3f `P' _skip(2) "`pwr'"
			}
			else {
				di as txt "m = `degree'`catz'" _col(18) as res %2.0f `idf' /*
					*/ _col(22) %13.3f `dev0' _cont
				if `normal' di as res _skip(5) %8.0g e(fp_s`degree') _cont
				di as txt _skip(1) "`dash'`dash'" as res _skip(2) "`e(fp_p`degree')'"
			}
			local j = `j' + cond(`j'<2, 1, 2)
		}
	}
	else {
		di as txt "Not in model" as res _col(18) " 0" /*
		*/ _col(22) %13.3f e(fp_d0) _cont
		if `normal' di as res _skip(5) %8.0g e(fp_s0) _cont
		di as txt _skip(1) "`dash'`dash'"
		local i 1
		while `i'<=`maxdf' {
			local m = 1 + int((`i' - 1) / 2)	// degree of model being reported
			local idf = cond(`i' == 1, `k' * (1 + `cz'), (`k' + 1) * `m' + `k' * `cz')
			if `i'==1 {
				di as txt "Linear`catz'" _col(18) as res /*
					*/ %2.0f `idf' _col(22) _cont
				local dev = e(fp_dlin)
				local rsd = e(fp_slin)
				local d = e(fp_d0)-`dev'
				local n1 `idf'
				local n2 = e(fp_rdf) - `idf'
				local pwr 1
			}
			else {
				di as txt "m = `m'`catz'" _col(18) as res /*
					*/ %2.0f `idf' _col(22) _cont
				local dev = e(fp_d`m')
				local rsd = e(fp_s`m')
				local d = `devlast'-`dev'
				local n1 = cond(`m'==1, 1, `k' + 1)
				local n2 = e(fp_rdf) - `idf'
				local pwr `e(fp_p`m')'
			}
// PR 22mar2009 -end-
			frac_pv `normal' "`e(fp_wgt)'" `e(fp_N)' `d' `n1' `n2'
			local P = r(P)

			if `i'==1 global S_E_Plin `P'
			else global S_E_P`m' `P'

			di as res %13.3f `dev' _cont
			if `normal' di as res _skip(5) %8.0g `rsd' _cont
			di as res _skip(3) %7.3f `d' %9.3f `P' _skip(2) "`pwr'"
			local devlast `dev'
			local i = `i' + cond(`i'==1, 1, 2)
		}
	}
	di as txt "{hline `ddup'}"
	if "`sequential'"=="" ///
	 di as txt "(*) P-value from deviance difference comparing reported model with m = `degree' model"
	else ///
	 di as txt "(*) P-value from dev. dif. comparing reported model with next lower df model"
	if `cz' ///
	 di as txt "(+) indicates dummy variable for `e(fp_rhs)'==0 included in model"
end

program CheckForNoConstant, sclass
	syntax [, noConstant * ]

	sreturn local constant `constant'
	sreturn local options `"`options'"'
end
exit

1.2.0/PR/JSP:- replace -all- option with -restrict()- option
1.1.13/PR:- mods in output for compare option for Stata 10.
1.1.12/PR:- translated to Stata 8
1.1.11/JML:- support for extended missing values   
1.1.10/PR:- fixed bug in support for streg, stcox
1.1.9/RG:- added support for streg, stcox
1.1.8/WG:- %9.2g changed to %9.2f
1.1.4/WG:- minor title changes
1.1.3/PR:- saves adjustments stored by -fracgen-.
	 - change frac_pp to frac_pq and avoid storing powers in a variable.
1.1.2/PR:- kludge to avoid bug in -glm- with no covariate and noconstant.
1.1.1/PR:- bug fixed, not saving fp_p`j'. Flag fp_cmd2 added and checked.
1.1.0/WG:- translated to Stata 6
1.0.2/PR:- `all' option added to facilitate out-of-sample predictions.
	   Double precision for transformations of xvar.
1.0.1/PR:- added name() option to be passed to fracgen to enable more
	   careful name control by calling program (fracpoly or mfracpol).


	Version 1.5.4 of old fracpoly (12Jul98).
	Now used as slave routine for fracpoly.ado and mfracpol.ado.
