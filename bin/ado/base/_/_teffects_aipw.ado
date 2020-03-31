*! version 1.0.4  17aug2017

program define _teffects_aipw, byable(onecall)
	version 13.0

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if replay() {
		if ("`e(cmd)'" != "teffects") error 301
		if ("`e(subcmd)'" != "aipw") error 301
		if (_by()) error 190
		global S_1 = e(chi2_c)
		_teffects_replay `0'
		exit
	}
	_teffects_parse_canonicalize aipw : `0'
	if `s(eqn_n)' == 1 {
		_teffects_error_msg, cmd(aipw) case(1)
	}		
	if `s(eqn_n)' > 2 {
		_teffects_error_msg, cmd(aipw) case(2)
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
	syntax [if] [in] [fw iw] [, 	///
		omodel(string)		///
		tmodel(string)		///
		ate POMeans		///
		nls wnls		///
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

	local k : word count `ate' `pomeans'
	if `k' > 1 {
		di as err "{p}{bf:ate} and {bf:pomeans} cannot both be " ///
		 "specified{p_end}"
		exit 184
	}
	if (!`k') local stat ate
	else local stat `ate'`pomeans'

	local k : word count `nls' `wnls'
	if `k' > 1 {
		di as err "{p}{bf:nls} and {bf:wnls} cannot both be " ///
		 "specified{p_end}"
		exit 184
	}
	if (!`k') local cmm aipw
	else local cmm `nls'`wnls'

	marksample touse
	_teffects_count_obs `touse'

	if "`weight'" != "" {
		tempvar wvar
		qui gen double `wvar'`exp' if `touse'
		if ("`weight'"=="fweight") local wopt freq(`wvar')
	}
	ExtractVarlist t : `tmodel'
	local tvarlist `s(varlist)'
	local tops `s(options)'
	_teffects_parse_tvarlist `tvarlist', `tops' touse(`touse') `wopt' ///
			stat(`stat') `control' `tlevel' cmd(aipw)
	local tvar `s(tvar)'
	local tvarlist `s(tvarlist)'
	local fvtvarlist `s(fvtvarlist)'
	local ktvar = `s(k)'
	local kfvtvar = `s(kfv)'
	local tmodel `s(tmodel)'
	local control = `s(control)'
	local treated `s(tlevel)'
	if "`tmodel'" == "hetprobit" {
		local htvarlist `s(hvarlist)'
		local fvhtvarlist `s(fvhvarlist)'
		local thopt htvarlist(`fvhtvarlist')
	}
	local tconstant = ("`s(constant)'"=="")
	/* treatment levels in tvar					*/
	local tlevels "`s(levels)'"
	local klev = `s(klev)'

	ExtractVarlist o : `omodel'
	local dvarlist `s(varlist)'
	local dops `s(options)'
	_teffects_parse_dvarlist `dvarlist', touse(`touse') wtype(`weight') ///
			wvar(`wvar') `dops'
	local depvar `s(depvar)'
	local dvarlist `s(dvarlist)'
	local fvdvarlist `s(fvdvarlist)'
	local kdvar = `s(k)'
	local kfvdvar = `s(kfv)'
	local omodel `s(omodel)'
	local dconstant = ("`s(constant)'"=="")
	if ("`omodel'" == "hetprobit"|"`omodel'" == "fhetprobit") {
		local hdvarlist `s(hvarlist)'
		local fvhdvarlist `s(fvhvarlist)'
		local dhopt hdvarlist(`fvhdvarlist')
	}
	_teffects_vlist_exclusive2, vlist1(`depvar')  ///
		vlist2(`tvar') case(1)
	if "`dvarlist'" != "" {
		_teffects_vlist_exclusive2, vlist1(`dvarlist') ///
			 vlist2(`tvar') case(2)
	}
	if ("`wnls'"!="" & ///
	("`omodel'" == "hetprobit"|"`omodel'" == "fhetprobit")  ///
	& "`tmodel'"=="hetprobit") {
		di as err "{p}options {bf:wnls}, {bf:omodel(`omodel')}, "  ///
	     	   "and {bf:tmodel(`tmodel')} cannot be specified "       ///
		   "together; the model is not identified{p_end}"
		exit 184
	}
	_teffects_count_obs `touse', why(observations with missing values) ///
			`wopt' tabulate(`tvar',levels(`klev'))
	local N = 0
	foreach lev in `tlevels' {
		local n`lev' = `r(n`lev')'
		local N = `N' + `n`lev''
	}
	_teffects_ipwra_gmm `fvtvarlist', touse(`touse') tmodel(`tmodel')    ///
		omodel(`omodel') depvar(`depvar') dvarlist(`fvdvarlist')     ///
		tvar(`tvar') tlevels(`tlevels') control(`control')           ///
		treated(`treated') stat(`stat') wtype(`weight') wvar(`wvar') ///
		cmm(`cmm') tconstant(`tconstant') dconstant(`dconstant')     ///
		`teopts' `gmmopts' `thopt' `dhopt'

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

	local omodel3 `omodel'
	local omodel2 `omodel'
	
	if ("`omodel'"=="flogit") {
		local omodel3 fractional logistic 
	}
	if ("`omodel'"=="fprobit") {
		local omodel3 fractional probit 
	}
	if ("`omodel'"=="fhetprobit") {
		local omodel3 fractional heteroskedastic probit  
	}

	ereturn scalar k_eq = `keq'
	ereturn scalar k_levels = `klev'
	if "`nls'`wnls'" == "" {
		local cme ml
	}
	else {
		local cme `nls'`wnls'
	}
	ereturn local cme `cme'
	ereturn local tlevels `tlevels'
	ereturn scalar control = `control'
	ereturn scalar treated = `treated'
	ereturn scalar converged = `converged'
	ereturn local enseparator `r(enseparator)'
	ereturn local title "Treatment-effects estimation"
	if "`weight'" != "" {
		ereturn local wexp "`exp'"
		ereturn local wtype "`weight'"
	}
	ereturn local stat `stat'
	ereturn local omodel `omodel3'
	ereturn local tmodel `tmodel'
	ereturn local cmd teffects
	ereturn local subcmd aipw
        ereturn local tvar `tvar'
	ereturn local depvar `depvar'
	ereturn hidden local fvtvarlist `fvtvarlist'
	ereturn hidden local fvdvarlist `fvdvarlist'
	ereturn hidden local tconstant `tconstant'
	ereturn hidden local dconstant `dconstant'
	if "`tmodel'" == "hetprobit" {
		ereturn hidden local fvhtvarlist `fvhtvarlist'
	}
	if ("`omodel2'" == "hetprobit"|"`omodel2'" == "fhetprobit") {
		ereturn hidden local fvhdvarlist `fvhdvarlist'
	}
	ereturn local vce `vce'
	ereturn local vcetype `vcetype'
	ereturn local clustvar `clustvar'
	if (`N_clust'!=.) ereturn scalar N_clust = `N_clust'
	_teffects_replay, `diopts'
end

program define ExtractVarlist, sclass
	gettoken w 0 : 0, parse(":")
	gettoken colon 0 : 0, parse(":")
	local w : list retokenize w

	cap noi syntax varlist(numeric fv), [ * ]
	local rc = c(rc)
	if `rc' {
		if "`w'" == "t" {
			_teffects_error_msg, cmd(aipw) case(5) rc(`rc')
		}
		else {
			_teffects_error_msg, cmd(aipw) case(7) rc(`rc')
		}
	}
	sreturn local varlist `"`varlist'"'
	sreturn local options `"`options'"'
end
exit
