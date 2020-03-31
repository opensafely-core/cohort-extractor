*! version 1.1.2  27feb2019

program define _tebalance_overid, rclass
	version 14.0
	syntax, [ BCOnly * ]

	ParseMLOpts, `options'
	local mlopts `s(mlopts)'
	local grest `s(rest)'
	if "`grest'" != "" {
		local wc: word count `grest'
		local option = plural(`wc',"Option")
		local is = plural(`wc',"is","are")
		di as err "{p}`option' {bf:`grest'} `is' not allowed{p_end}"
		exit 198
	}

	tempname b b0 ptol dfv
	tempvar touse p
	qui gen byte `touse' = e(sample)

	/* use estimation default ptolerance()				*/
	scalar `ptol' = 1e-5
	qui predict double `p' if `touse', ps
	qui count if `p' < `ptol' & `touse'
	local ntol = r(N)
	if `ntol' {
		di as txt "{p 0 6 2}note: `ntol' observations have a " ///
		 "propensity score less than " %9.4g `ptol' 	       ///
		 "; overid computations might be prone to numerical "  ///
		 "instability{p_end}"
	}
	qui count if `p' > `=1-`ptol'' & `touse'
	local ntol = r(N)
	if `ntol' {
		di as txt "{p 0 6 2}note: `ntol' observations have a " ///
		 "propensity score greater than 1 -" %9.4g `ptol'      ///
		 "; overid computations might be prone to numerical "  ///
		 "instability{p_end}"
	}
	local tmodel `e(tmodel)'
	local tlevels `e(tlevels)'
	local klev = e(k_levels)
	if `klev' > 2 {
		di as err "{p}{bf:tebalance overid} is not allowed " ///
		 "when the treatment variable has more than 2 "      ///
		 "levels{p_end}" 
		exit 322
	}
	local control = `e(control)'
	local treated = `e(treated)'
	local stat `e(stat)'
	local tvar `e(tvar)'
	local hetprobit = ("`tmodel'" == "hetprobit")
	fvrevar ibn.`tvar' if `touse'
	local tvars `r(varlist)'
	if "`e(wtype)'" == "fweight" {
		tempvar wt
		qui gen long `wt'`e(wexp)'
		local wgts [fw=`wt']

		summarize `wt' if `touse', meanonly
		local N = r(sumw)
	}
	else {
		qui count if `touse'
		local N = r(N)
	}
	if `e(tconstant)' {
		local constant = 1
		tempvar cons

		qui gen byte `cons' = 1 if `touse'
	}
	else local constant = 1

	mat `b' = e(b)
	foreach lev of local tlevels {
		if `lev' == `control' {	
			continue
		}
		mat `b0' = (nullmat(`b0'),`b'[1,"TME`lev':"])
	}
	GetMLModel `b0' `cons'
	local model `"`r(model)'"'
	/* full model including polynomials and interactions		*/
	local tvlist `"`r(vlist)'"'
	/* variables only						*/
	local tvlist0 `"`r(vlist0)'"'
	scalar `dfv' = `r(df)'
	local kvar : list sizeof tvlist
	local which `tmodel'
	if (`hetprobit') {
		tempname b1
		local which probit
		foreach lev of local tlevels {
			if `lev' == `control' {	
				continue
			}
			mat `b1' = (nullmat(`b1'),`b'[1,"TME`lev'_lnsigma:"])
		}
		GetMLModel `b1' `cons'
		local hmodel `"`r(model)'"'
		local hvlist `"`r(vlist)'"'
		local hvlist0 `"`r(vlist0)'"'
		scalar `dfv' = scalar(`dfv') + `r(df)'

		local hvar : list sizeof hvlist
		local kvar = `kvar' + `hvar'
		mat `b0' = (`b0',`b1') 
	}
	if "`bconly'" != "" {
		/* balance on the variables only, no interactions etc	*/
		local bhvlist `hvlist0'
		local bvlist `tvlist0'
	}
	else {
		/* balance variables and higher order terms		*/
		local bhvlist `hvlist'
		local bvlist `tvlist'
	}
	/* cannot have the same variables in both eqs in the		*/
	/*  overidentified equations					*/
	local bhvlist : list bhvlist - bvlist

	tempname ereturn W W0 W1 Winv df rw rw0 rv

	qui estimates store `ereturn'
	cap noi {
		global TEFFECTS_tvars `tvars'
		global TEFFECTS_tmodel `tmodel'
		global TEFFECTS_fvlist `tvlist'
		global TEFFECTS_fhvlist `hvlist'
		global TEFFECTS_bvlist `bvlist'
		global TEFFECTS_bhvlist `bhvlist'
		global TEFFECTS_stat `stat'
		global TEFFECTS_tlevels `tlevels'
		global TEFFECTS_control `control'
		global TEFFECTS_treated `treated'
		global TEFFECTS_kvar = `kvar'
		global TEFFECTS_W `W'
		global TEFFECTS_W0 `W0'
		global TEFFECTS_W1 `W1'
		global TEFFECTS_wtype `e(wtype)'

		ml model d0 _tebalance_overid_`which' `model' `hmodel' ///
			if `touse' `wgts', nooutput init(`b0') search(off) ///
			max nopreserve crittype("criterion") novce `mlopts'
	}
	local rc = c(rc)

	tempname chi2 p V rankV
	scalar `chi2' = 1/e(ll)-1
	global TEFFECTS_wtype
	global TEFFECTS_tvars
	global TEFFECTS_tmodel
	global TEFFECTS_fvlist
	global TEFFECTS_fhvlist
	global TEFFECTS_bvlist
	global TEFFECTS_bhvlist
	global TEFFECTS_stat
	global TEFFECTS_tlevels
	global TEFFECTS_control
	global TEFFECTS_treated
	global TEFFECTS_kvar
	global TEFFECTS_W
	global TEFFECTS_W0
	global TEFFECTS_W1
	global TEFFECTS_rank

	local e1 "overidentification statistic cannot be computed"

	if !`rc' & !e(converged) local rc = 430
	if `rc' {
		di as err `"{p}`e1'{p_end}"'
		qui estimates restore `ereturn'
		qui estimates drop `ereturn'
		exit `rc'
	}
	mat `b' = e(b)
	local names : colfullnames `b0'
	mat colnames `b' = `names'
	mat `W0' = syminv(`W0')
	scalar `rw0' = colsof(`W0')-diag0cnt(`W0')
	mat `Winv' = syminv(`W')
	scalar `rw' = colsof(`Winv')-diag0cnt(`Winv')
	scalar `df' = scalar(`rw')-scalar(`rw0')
	scalar `p' = chi2tail(`df',`chi2')
	qui estimates restore `ereturn'
	qui estimates drop `ereturn'
	if "`verbose'" != "" {
		mat li `W', title("weight matrix")
	}
	if `df' <= 0 {
		di as err `"{p}`e1'; "' 				///
		 "the {bf:gmm} model is exactly identified{p_end}"
		exit 322
	}
	di
	di as text "Overidentification test for covariate balance"
	di as text _col(10) "H0: Covariates are balanced:"
	di
	di as text _col(10) "chi2("		///
		as res `df'			///
		as text ")"			///
		_col(23) as text "= "		///
		as res %8.0g `chi2'		
	di as text _col(10) "Prob > chi2"	///
		_col(23) as text "=   "		///
		as res %5.4f `p'

	return scalar chi2 = `chi2'
	return scalar df = `df'
	return scalar p = `p'
//	return mat b = `b' 
//	return mat W = `W'
end

program define ParseMLOpts, sclass
	syntax, [ ITERate(passthru) TECHnique(passthru) DIFficult NOLOG ///
		log TRace GRADient showstep HESSian SHOWTOLerance       ///
		TOLerance(passthru) LTOLerance(passthru) 	        ///
		NRTOLerance(passthru) * ]

	if "`technique'" == "" {
		local technique technique(bfgs)
	}
	if "`iterate'" == "" {
		local iterate(50)
	}
	if "`log'"!="" & "`nolog'"!="" {
		di as err "{p}options {bf:log} and {bf:nolog} cannot both " ///
		 "be specified{p_end}"
		exit 184
	}
	if "`c(iterlog)'" == "off" {
		if "`log'" == "" {
			local nolog nolog
		}
	}
	local mlopts `iterate' `technique' `difficult' `nolog' `log' `trace'
	local mlopts `mlopts' `gradient' `showstep' `hessian' `showtolerance'
	local mlopts `mlopts' `tolerance' `ltolerance' `nrtolerance'

	sreturn local mlopts `"`mlopts'"'
	sreturn local rest `"`options'"'
end

program define GetMLModel, rclass
	args b cons collin

	local eqs : coleq `b'
	local eqs : list uniq eqs
	local keq : list sizeof eqs

	local stripe : colfullnames `b'
	_ms_split `b', width(1000)
	local kcol = r(k_cols)
	local krow = r(k_rows)
	local k = 1
	local j = 1
	local l = 0
	foreach eq of local eqs {
		local `++l'
		local bcons = 0
		while "`r(str`k'_`j')'" == "`eq':" {
			gettoken bexpr stripe : stripe, bind
			gettoken beq bexpr : bexpr, parse(":")
			gettoken colon bexpr : bexpr, parse(":")

			local expr
			while `++j' <= `kcol' {
				if "`r(str`k'_`j')'" == "_cons" {
					local bcons = 1
					if `l' == 1 {
						local expr `"`cons'"'
						continue, break
					}
				}
				else {
					local el `r(str`k'_`j')'
					local expr `"`expr'`el'"'
				}
			}
			if "`expr'" != "`cons'" {
				if "`expr'" != "`bexpr'" {
					/* _ms_split drop base-none op?	*/
					CheckDroppedOp, sexpr(`expr') ///
						bexpr(`bexpr')
					local expr `s(expr)'
				}
				local eq`l' `"`eq`l'' `expr'"'
			}

			local vlist `"`vlist' `expr'"'
			local j = 1
			local `++k'
		}
		/* factor variable notation into syntax form		*/
		local 0 `eq`l''
		syntax varlist(numeric fv)
		local eq`l' `"`eq':`varlist'"'
		if (!`bcons') local eq`l' `"`eq`l'', noconstant"'

		local model `"`model' (`eq`l'')"'
	}
	local vlist : list uniq vlist
	local vlist : list retokenize vlist
	local model : list retokenize model

	local vlist1 `vlist'
	local df = 0
	while "`vlist1'" != "" {
		gettoken expr vlist1 : vlist1
		_ms_parse_parts `expr'
		local df = `df' + !r(omit)
		if "`r(type)'" == "variable" {
			local vlist0 `"`vlist0' `expr'"'
		}
		else if "`r(type)'" == "factor" {
			local vlist0 `"`vlist0' `expr'"'
		}
	}
	local vlist0 : list retokenize vlist0

	return local model `"`model'"'
	return local vlist `"`vlist'"'
	return local vlist0 `"`vlist0'"'
	return local df = `df'
end

program define CheckDroppedOp, sclass
	syntax, sexpr(string) bexpr(string)

	/* do not use _ms_ tools and destroy return			*/
	/* calling program needs the existing return results		*/
	local tmp : subinstr local bexpr `"#"' `"#"', all count(local k)
	if `k' {
		/* use _ms_split expression				*/
		sreturn local expr `sexpr'
	}
	gettoken bop rest : bexpr, parse(".")
	if "`bop'" != "`bexpr'" {
		local k = strlen("`bop'")-1
		if `k' > 1 {
			local bn = bsubstr("`bop'",`k',2)
			if "`bn'" == "bn" {
				local `--k'
				local ii = bsubstr("`bop'",1,`k')
				cap confirm integer number `ii'
				if !c(rc) {
					/* _ms_split drop base-none op	*/
					/* use original expression	*/
					sreturn local expr `bexpr'
					exit
				}
			}
		}
	}
	/* use _ms_split expression					*/
	sreturn local expr `sexpr'
end
	
exit
