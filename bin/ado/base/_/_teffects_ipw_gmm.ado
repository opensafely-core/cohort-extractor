*! version 1.1.0  30jul2018
* inverse probability weighting via GMM
* called by -_teffects_ipw- 

program define _teffects_ipw_gmm, rclass
	version 13
	syntax	[ varlist(numeric fv default=none) ], ///
		model(string)			///
		touse(varname)			///
		depvar(varname)			///
		tvar(varname)			///
		tlevels(string)			///
		stat(string) 			///
		epscd(passthru) 		///
		control(string) [		///
		treated(passthru)		///
		hvarlist(varlist fv)		///
		offset(varname)			///
		noconstant			///
		wtype(string) wvar(varname)	///
		enseparator			///
		verbose NOLOg LOg		///
		from(string) force 		///
		osample(passthru) * ]
	
	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'" == "" {
		local noi noi
		if ("`verbose'"=="") local iterlogonly iterlogonly
	}
	/* klev = 2 for probit and hetprobit				*/
	local klev : list sizeof tlevels
	local hetprobit = ("`model'"=="hetprobit")

	fvrevar ibn.`tvar' if `touse'
	local tvars `r(varlist)'
	if "`stat'" != "pomeans" {
		local jc : list posof "`control'" in tlevels
		local tc : word `jc' of `tvars'
		qui replace `tc' = 1 if `touse'
	}
	forvalues j=2/`klev' {
		local teqs `teqs' t`j'
	}
	if (`hetprobit') local heq het

	if "`varlist'" != "" {
		fvexpand `varlist' if `touse'
		local fvtvlist `r(varlist)'

		fvrevar `varlist' if `touse'
		local fvtrevar `r(varlist)'
	}
	local constant = ("`constant'"=="")
	if `constant' {
		tempvar cons 
		qui gen byte `cons' = 1 if `touse'
	}
	if `hetprobit' {
		fvexpand `hvarlist' if `touse'
		local fvhvlist `r(varlist)'

		fvrevar `hvarlist' if `touse'
		local fvhrevar `r(varlist)'
	}

	_teffects_omit_vars, klev(`klev') fvtvlist(`fvtvlist')           ///
		fvtrevar(`fvtrevar') tconst(`cons') fvhtvlist(`fvhvlist') ///
		fvhtrevar(`fvhrevar') 

	local komit = `r(komit)'
	local ind `"`r(index)'"'
	local fvotrevar `"`r(fvotrevar)'"'
	local fvohrevar `"`r(fvohtrevar)'"'
	local kpar0 = `r(k)'
	local k : list sizeof fvotrevar
	local kpar : list sizeof ind
	if `hetprobit' {
		local kh : list sizeof fvohrevar
		local hinstr "instruments(het: `fvohrevar', noconstant)"
		local hvopt hvarlist(`fvohrevar')
	}
	local init = 1
	if "`from'" != "" {
		ParseFrom `from'
		local ncol = `s(ncol)'
		local from `s(from)'
		local fopt `s(fopt)'
		local init = ("`fopt'"!="copy")
		if `ncol' & `init' {
			local init = (`ncol'!=`kpar0')
		}
	}
	tempname b0
	if `init' {
		_teffects_ipw_init `fvotrevar', model(`model')            ///
			depvar(`depvar')  tvar(`tvar') tlevels(`tlevels') ///
			control(`control') `treated' touse(`touse')       ///
			stat(`stat') wtype(`wtype') wvar(`wvar') `hvopt'  ///
			`verbose'
		mat `b0' = r(b)
		if ("`from'"!="") local fopt from(`from') `fopt'
	}
	else {
		if ("`fopt'"=="copy") mat `b0' = J(1,`kpar0',0)
		else mat `b0' = J(1,`kpar',0)

		local fopt from(`from') `fopt'
	}

	if "`from'" != "" {
		_teffects_from `b0', kpar(`kpar0') komit(`komit')         ///
			index(`ind') tvar(`tvar') tlevels(`tlevels')      ///
			stat(`stat') tmodel(`model') fvtvlist(`fvtvlist') ///
			fvhtvlist(`fvhvlist') control(`control')          ///
			tconstant(`constant') `fopt' `enseparator'

		mat `b0' = r(b)
		if "`verbose'" != "" {
			di as txt _n "{bf:from()} updated initial estimates"
			mat li `b0'
		}

	}
	_teffects_validate_overlap `fvotrevar', at(`b0') tvars(`tvars') ///
		tlevels(`tlevels') model(`model') depvar(`depvar')      ///
		touse(`touse') stat(`stat') control(`control')          ///
		`treated' `epscd' `hvopt' `osample' `force'

	if ("`wtype'"!="") local wts "[`wtype'=`wvar']"
	if ("`iterlogonly'"!="") di

	cap `noi' gmm _teffects_gmm_ipw if `touse' `wts',	///
		equations(`stat' `teqs' `heq')			///
		instruments(`stat': `tvars', noconstant)	///
		instruments(`teqs': `fvotrevar', noconstant)	///
		`hinstr' onestep 				///
		nparameters(`kpar')				///
		hasderivatives					///
		depvar(`depvar')				///
		tvars(`tvars') tlevels(`tlevels')		///
		control(`control') `treated'			///
		tvarlist(`fvotrevar') `hvopt'			///
		stat(`stat')					///
		model(`model') 					///
		from(`b0') `options' `iterlogonly' `mllog'

	local rc = c(rc)
	if `rc' {
		if (`rc'>1) di as err "{bf:gmm} estimation failed"

		exit `rc'
	}
	_teffects_ipwra_bv, kpar(`kpar0') komit(`komit') index(`ind')        ///
		tvar(`tvar') tlevels(`tlevels') stat(`stat') tmodel(`model') ///
		fvtvlist(`fvtvlist') fvhtvlist(`fvhvlist')                   ///
		control(`control') tconstant(`constant') `enseparator'

	return add
end

program define ParseFrom, sclass
	cap noi syntax anything(name=from equalok), [ copy skip ]
	local rc = c(rc)
	if `rc' {
		di as err "in option {bf:from()}"
		exit `rc'
	}
	if "`copy'"!="" & "`skip'"!="" {
		di as err "{p}suboptions {bf:copy} and {bf:skip} may not " ///
		 "be combined in option {bf:from()}{p_end}"
		exit 184
	}
	cap confirm matrix `from'
	if (!c(rc)) sreturn local ncol = colsof(`from')
	else sreturn local ncol = 0

	sreturn local from `from'
	sreturn local fopt `copy'`skip'
end

exit
