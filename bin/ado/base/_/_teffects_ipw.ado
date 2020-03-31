*! version 1.0.5  17aug2017

program define _teffects_ipw, byable(onecall)
	version 13.0

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if replay() {
		if ("`e(cmd)'" != "teffects") error 301
		if ("`e(subcmd)'" != "ipw") error 301
		if (_by()) error 190
		global S_1 = e(chi2_c)
		_teffects_replay `0'
		exit
	}
	_teffects_parse_canonicalize ipw : `0'
	if `s(eqn_n)' == 1 {
		_teffects_error_msg, cmd(ipw) case(1)
	}		
	if `s(eqn_n)' > 2 {
		_teffects_error_msg, cmd(ipw) case(2)
	}
	local omodel `"`s(eqn_1)'"'
	local tmodel `"`s(eqn_2)'"'
	local if `"`s(if)'"'
	local in `"`s(in)'"'
	local wt `"`s(wt)'"'
	local options `"`s(options)'"'

	`BY' Estimate `if'`in' `wt', omodel(`omodel') tmodel(`tmodel') `options'
end

program define Estimate, eclass byable(recall)
	syntax [if] [in] [fw iw pw], [	///
		omodel(string) 		///
		tmodel(string)		///
		ate atet POMeans	///
		AEQuations		///
		CONtrol(passthru)	///
		TLEvel(passthru)	///
		* ]

	_get_diopts diopts rest, `options'
	local diopts `diopts' `aequations'

	_teffects_gmmopts, `rest' 
	local gmmopts `s(gmmopts)'
	local rest `s(rest)'
	local vce `s(vce)'
	local vcetype `s(vcetype)'
	local clustvar `s(clustvar)'

	_teffects_options ipw : `rest'
	local teopts `s(teopts)'
	local rest `s(rest)'
	if "`rest'" != "" {
		local wc: word count `rest'
		di as err `"{p} `=plural(`wc',"option")' {bf:`rest'} "' ///
		 `"`=plural(`wc',"is","are")' not allowed{p_end}"'
		exit 198
	}

	_teffects_getstat1 , `ate' `atet' `pomeans'
	local stat1 "`s(stat1)'"
	local stat `stat1'
	if ("`stat'"=="atet") local stat att

	ParseDepvar `omodel'
	local depvar `s(depvar)'

	marksample touse
	markout `touse' `depvar'
	_teffects_count_obs `touse'

	if "`weight'" != "" {
		tempvar wvar
		qui gen double `wvar'`exp' if `touse'
		if ("`weight'"=="fweight") local wopt freq(`wvar')
	}
	ExtractVarlist `tmodel'
	local tvarlist `s(varlist)'
	local tops `s(options)'

	_teffects_parse_tvarlist `tvarlist', `tops' touse(`touse') `wopt' ///
			stat(`stat') `control' `tlevel' cmd(ipw)
	local tvar `s(tvar)'
	/* factor variable notation to recreate treatment variable(s)	*/
	local tvarlist `s(tvarlist)'
	local fvtvarlist `s(fvtvarlist)'
	local ktvar = `s(k)'
	local kfvtvar = `s(kfv)'
	local tmodel `s(tmodel)'
	local control = `s(control)'
	/* treatment level						*/
	local treated `s(tlevel)'
	if "`tmodel'" == "hetprobit" {
		local hvarlist `s(hvarlist)'
		local fvhvarlist `s(fvhvarlist)'
		local hopt hvarlist(`fvhvarlist') 
	}

	_teffects_vlist_exclusive2, vlist1(`depvar')  ///
		vlist2(`tvar') case(1)

	local constant `s(constant)'
	/* treatment levels in tvar					*/
	local tlevels "`s(levels)'"
	local klev = `s(klev)'
	local N = 0
	foreach lev of local tlevels {
		local n`lev' = `s(n`lev')'
		local N = `N' + `n`lev''
	}

	_teffects_ipw_gmm `fvtvarlist', touse(`touse') model(`tmodel')     ///
		depvar(`depvar') tvar(`tvar') tlevels(`tlevels')           ///
		control(`control') treated(`treated') stat(`stat')         ///
		wtype(`weight') wvar(`wvar') `constant' `gmmopts' `teopts' ///
		`hopt'

	local converged = e(converged)
	local N_clust	= e(N_clust)

	tempname b V
	mat `b' = r(b)
	mat `V' = r(V)
	local keq = `r(keq)'

	ereturn post `b' `V', obs(`N') esample(`touse')
	
	forvalues i=`klev'(-1)1 {
		local lev : word `i' of `tlevels'
		ereturn scalar n`lev' = `n`lev''
	}

	/* reset hidden stripe info associated with factor variables	*/
	_ms_setvalues b, eclass

	ereturn scalar k_eq = `keq'
	ereturn scalar k_levels = `klev'
	ereturn local tlevels `tlevels'
	ereturn scalar treated = `treated'
	ereturn scalar control = `control'
	ereturn scalar converged = `converged'
	ereturn local enseparator `r(enseparator)'
	ereturn local title "Treatment-effects estimation"
	if "`weight'" != "" {
		ereturn local wexp "`exp'"
		ereturn local wtype "`weight'"
	}
	ereturn local stat `stat1'
	ereturn local tmodel `tmodel'
	ereturn local cmd teffects
	ereturn local subcmd ipw
        ereturn local tvar `tvar'
	ereturn local depvar `depvar'
	ereturn local tmodel `tmodel'
	ereturn hidden local fvtvarlist `fvtvarlist'
	if "`tmodel'" == "hetprobit" {
		ereturn hidden local fvhtvarlist `fvhvarlist'
	}
	ereturn hidden local tconstant = ("`constant'"=="")
	ereturn local vce `vce'
	ereturn local vcetype `vcetype'
	ereturn local clustvar `clustvar'
	if (`N_clust'!=.) ereturn scalar N_clust = `N_clust'
	_teffects_replay, `diopts'
end

program define ParseDepvar, sclass
	cap noi syntax varname(numeric)
	local rc = c(rc)
	if `rc' {
		if `rc' == 103 {
			_teffects_error_msg, cmd(ipw) case(4) rc(`rc')
		} 
		else {
			di as txt "{phang}The outcome model is "	///
				"misspecified.{p_end}"
			exit `rc'
		}
	}
	sreturn local depvar `varlist'
end

program define ExtractVarlist, sclass
	cap noi syntax varlist(numeric fv), [ * ]
	local rc = c(rc)
	if `rc' {
		_teffects_error_msg, cmd(ipw) case(5) rc(`rc')
	}
	sreturn local varlist `"`varlist'"'
	sreturn local options `"`options'"'
end

exit

