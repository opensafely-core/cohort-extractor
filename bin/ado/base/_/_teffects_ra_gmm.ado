*! version 1.0.1  03jun2015
* regression adjustment via GMM
* called by -_teffects_ra- 

program define _teffects_ra_gmm, rclass
	version 13
	syntax [ varlist(numeric fv default=none) ], ///
		model(string)			///
		depvar(varname)			///
		tvar(varname)			///
		tlevels(string)			///
		stat(string)			///
		touse(varname) [		///
		control(passthru)		///
		treated(passthru)		///
		hvarlist(varlist fv)		///
		noconstant 			///
		wtype(string) wvar(varname)	///
		enseparator			///
		verbose nolog from(string) * ]

	if "`log'" == "" {
		local noi noi
		if ("`verbose'"=="") local iterlogonly iterlogonly
	}
	local klev : list sizeof tlevels
	local hetprobit = ("`model'"=="hetprobit"|"`model'" == "fhetprobit")

	fvrevar ibn.`tvar' if `touse'
	local tvars `r(varlist)'

	forvalues j=1/`klev' {
		local meqs `meqs' `stat'`j'
		local teqs `teqs' t`j'
		if (`hetprobit') local heqs `heqs' v`j'
	}
	if "`varlist'" != "" {
		fvexpand `varlist' if `touse'
		local fvdvlist `r(varlist)'

		fvrevar `varlist' if `touse'
		local fvdrevar `r(varlist)'
	}
	if `hetprobit' {
		fvexpand `hvarlist' if `touse'
		local fvhvlist `r(varlist)'

		fvrevar `hvarlist' if `touse'
		local fvhrevar `r(varlist)'
	}	
	local constant = ("`constant'"=="")
	if `constant' {
		tempvar cons 
		qui gen byte `cons' = 1 if `touse'
	}
	/* get varlist with omitted variables removed			*/
	_teffects_omit_vars, klev(`klev') fvdvlist(`fvdvlist')            ///
		fvdrevar(`fvdrevar') dconst(`cons') fvhdvlist(`fvhvlist') ///
		fvhdrevar(`fvhrevar')
	local komit = `r(komit)'
	local ind `"`r(index)'"'
	local fvodrevar `"`r(fvodrevar)'"'
	local fvohrevar `"`r(fvohdrevar)'"'
	local kpar0 = `r(k)'
	local kpar : list sizeof ind

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
		_teffects_ra_init `fvodrevar', model(`model')            ///
			depvar(`depvar') tvar(`tvar') tlevels(`tlevels') ///
			`control' `treated' touse(`touse') stat(`stat')  ///
			hvarlist(`fvohrevar') `verbose' wtype(`wtype')   ///
			wvar(`wvar')
		mat `b0' = r(b)
		if ("`from'"!="") local fopt from(`from') `fopt'
	}
	else {
		if ("`fopt'"=="copy") mat `b0' = J(1,`kpar0',0)
		else mat `b0' = J(1,`kpar',0)

		local fopt from(`from') `fopt'
	}
	if "`from'" != "" {
		_teffects_from `b0', kpar(`kpar0') komit(`komit')            ///
			index(`ind') stat(`stat') omodel(`model')            ///
			tvar(`tvar') tlevels(`tlevels') fvdvlist(`fvdvlist') ///
			fvhdvlist(`fvhvlist') dconstant(`constant')          ///
			`control' `enseparator' `fopt' 

		mat `b0' = r(b)
		if "`verbose'" != "" {
			di as txt _n "{bf:from()} updated initial estimates"
			mat li `b0'
		}
	}
	if `hetprobit' {
		local hinstr `"instruments(`heqs':`fvohrevar', noconstant)"'
	}

	if ("`wtype'"!="") local wts [`wtype'=`wvar']
	if ("`iterlogonly'"!="") di

	local model2 `model'
	
	if ("`model'"=="flogit") {
		local model2 logit
	}
	if ("`model'"=="fprobit") {
		local model2 probit
	}
	if ("`model'"=="fhetprobit") {
		local model2 hetprobit 
	}

	cap `noi' gmm _teffects_gmm_ra if `touse' `wts',	///
		equations(`meqs' `teqs' `heqs')			///
		instruments(`meqs':)				///
		instruments(`teqs':`fvodrevar', noconstant) 	///
		`hinstr' nparameters(`kpar') 			///
		onestep 					///
		hasderivatives					///
		tvars(`tvars')					///
		tlevels(`tlevels')				///
		`control' `treated'				///
		depvar(`depvar')				///
		dvarlist(`fvodrevar') 				///
		stat(`stat') 					///
		model(`model2')					///
		hvarlist(`fvohrevar') 				///
		from(`b0') `options' `iterlogonly'

	local rc = c(rc)
	if `rc' {
		if (`rc'>1) di as err "{bf:gmm} estimation failed"

		exit `rc'
	}
	_teffects_ipwra_bv, kpar(`kpar0') komit(`komit') index(`ind')        ///
		stat(`stat') omodel(`model2') tvar(`tvar') tlevels(`tlevels') ///
		fvdvlist(`fvdvlist') fvhdvlist(`fvhvlist') `control'         ///
		dconstant(`constant')  `enseparator'

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
