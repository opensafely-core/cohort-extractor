*! version 1.0.7  17aug2017

program define _teffects_ra, byable(onecall)
	version 13.0

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if replay() {
		if ("`e(cmd)'" != "teffects") error 301
		if ("`e(subcmd)'" != "ra") error 301
		if (_by()) error 190
		global S_1 = e(chi2_c)
		_teffects_replay `0'
		exit
	}
	_teffects_parse_canonicalize ra : `0'
	if `s(eqn_n)' == 1 {
		_teffects_error_msg, cmd(ra) case(1)
	}		
	if `s(eqn_n)' > 2 {
		_teffects_error_msg, cmd(ra) case(2)
	}
	local omodel `"`s(eqn_1)'"'
	local tmodel `"`s(eqn_2)'"'
	local if `"`s(if)'"'
	local in `"`s(in)'"'
	local wt `"`s(wt)'"'
	local options `"`s(options)'"'

	`BY' Estimate `if'`in' `wt', omodel(`omodel') tmodel(`tmodel') ///
		`options'
end

program define Estimate, eclass byable(recall)
	syntax [if] [in] [fw iw pw] [, 		///
			omodel(string)		///
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

	_teffects_options ra : `rest'
	local teopts `s(teopts)'
	local rest `s(rest)'
	if "`rest'" != "" {
		local wc: word count `rest'
		di as err `"{p}`=plural(`wc',"option")' {bf:`rest'} "' ///
		 `"`=plural(`wc',"is","are")' not allowed{p_end}"'
		exit 198
	}

	_teffects_getstat1 , `ate' `atet' `pomeans'
	local stat1 "`s(stat1)'"
	local stat `stat1'
	if ("`stat'"=="atet") local stat att

	marksample touse
	_teffects_count_obs `touse'

	if "`weight'" != "" {
		tempvar wvar
		qui gen double `wvar'`exp' if `touse'
		if ("`weight'"=="fweight") local wopt freq(`wvar')
	}
	ExtractVarlist t : `tmodel'
	local tvar `s(varlist)'
	local tops `s(options)'
	local ne_tvar : list sizeof tvar
	if `ne_tvar' > 1 {
		_teffects_error_msg, cmd(ra) case(3) rc(103)
	}
	/* check tvar, update `touse', check for control group		*/
	_teffects_parse_tvar `tvar', touse(`touse') `wopt' `tops' ///
		stat(`stat') cmd(ra) `control' `tlevel'
	local tvar `s(tvar)'
	local control = `s(control)'
	local treated = `s(tlevel)'
	local tlevels "`s(levels)'"
	local klev = `s(klev)'
	local tlevel `s(tlevel)'

	ExtractVarlist o : `omodel'
	local dvarlist `s(varlist)'
	local dopts `s(options)'

	_teffects_parse_dvarlist `dvarlist', touse(`touse') wtype(`weight') ///
			wvar(`wvar') `dopts'

	local depvar `s(depvar)'
	local dvarlist `s(dvarlist)'
	local fvdvarlist `s(fvdvarlist)'
	local kdvar = `s(k)'
	local kfvdvar = `s(kfv)'
	local omodel `s(omodel)'
	local constant `s(constant)'
	
	if ("`omodel'" == "hetprobit"|"`omodel'" == "fhetprobit") {
		local hvarlist `s(hvarlist)'
		local fvhdvarlist `s(fvhvarlist)'
		local hopt hvarlist(`fvhdvarlist')
	}

	_teffects_vlist_exclusive2, vlist1(`depvar')  ///
		vlist2(`tvar') case(1)
	if "`dvarlist'" != "" {
		_teffects_vlist_exclusive2, vlist1(`dvarlist') ///
			 vlist2(`tvar') case(2)
	}
	_teffects_count_obs `touse', why(observations with missing values) ///
			`wopt' tabulate(`tvar',levels(`klev'))
	local N = 0
	foreach lev of local tlevels {
		local n`lev' = `r(n`lev')'
		local N = `N' + `n`lev''
	}

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

	_teffects_ra_gmm `fvdvarlist', model(`omodel') depvar(`depvar') ///
		tvar(`tvar') tlevels(`tlevels') control(`control')      ///
		treated(`treated') stat(`stat') touse(`touse') `topt'   ///
		`constant' `hopt' wtype(`weight') wvar(`wvar') `teopts' ///
		`gmmopts'

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
	ereturn scalar treated = `tlevel'
	ereturn scalar control = `control'
	ereturn scalar converged = `converged'
	ereturn local enseparator `r(enseparator)'
	ereturn local title "Treatment-effects estimation"
	if "`weight'" != "" {
		ereturn local wexp "`exp'"
		ereturn local wtype "`weight'"
	}
	ereturn local stat `stat1'
	ereturn local omodel `omodel3'
	ereturn local cmd teffects
	ereturn local subcmd ra
        ereturn local tvar `tvar'
	ereturn local depvar `depvar'
	ereturn hidden local fvdvarlist `fvdvarlist'
	if ("`omodel2'" == "hetprobit"|"`omodel2'" == "fhetprobit") {
		ereturn hidden local fvhdvarlist `fvhdvarlist'
	}
	ereturn hidden local dconstant `constant'
	ereturn hidden local levelsnoc `levelsnoc'
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
			_teffects_error_msg, cmd(ra) case(5) rc(`rc')
		}
		else {
			_teffects_error_msg, cmd(ra) case(7) rc(`rc')
		}
		exit `rc'
	}
	sreturn local varlist `"`varlist'"'
	sreturn local options `"`options'"'
end

exit
