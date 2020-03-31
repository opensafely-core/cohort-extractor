*! version 1.0.1  03jun2015

program define _teffects_ipwra_gmm, rclass
	version 13
	syntax	[ varlist(numeric fv default=none) ], ///
		tmodel(string)			///
		omodel(string)			///
		touse(varname)			///
		depvar(varname)			///
		tvar(varname)			///
		tlevels(string)			///
		stat(string)			///
		epscd(passthru) 		///
		control(passthru) [		///
		treated(passthru)		///
		htvarlist(varlist fv)		///
		tconstant(integer 1)		///
		dvarlist(varlist fv)		///
		hdvarlist(varlist fv)		///
		dconstant(integer 1)		///
		wtype(string) wvar(varname)	///
		enseparator			///
		verbose nolog 			///
		cmm(string) from(string)	///
		force osample(passthru) * ]

	if "`log'" == "" {
		local noi noi
		if ("`verbose'"=="") local iterlogonly iterlogonly
	}
	fvrevar ibn.`tvar' if `touse'
	local tvars `r(varlist)'
	/* klev = 2 for probit and hetprobit				*/
	local klev : list sizeof tlevels
	local pshetprobit = ("`tmodel'"=="hetprobit")
	local dhetprobit = ("`omodel'"=="hetprobit"|"`omodel'"=="fhetprobit")

	local deqs d1
	local meqs `stat'1
	if (`dhetprobit') local dheq dhet1

	forvalues j=2/`klev' {
		local teqs `teqs' t`j'
		local deqs `deqs' d`j'
		local meqs `meqs' `stat'`j'
		if (`dhetprobit') local dheq `dheq' dhet`j'
	}
	if (`pshetprobit') local psheq pshet
	if "`varlist'" != "" {
		fvexpand `varlist' if `touse'
		local fvtvlist `r(varlist)'

		fvrevar `varlist' if `touse'
		local fvtrevar `r(varlist)'
	}
	if `tconstant' | `dconstant' {
		tempvar cons 
		qui gen byte `cons' = 1 if `touse'

		if (`tconstant') local tconst tconst(`cons')
		if (`dconstant') local dconst dconst(`cons')
	}
	if "`dvarlist'" != "" {
		fvexpand `dvarlist' if `touse'
		local fvdvlist `r(varlist)'

		fvrevar `dvarlist' if `touse'
		local fvdrevar `r(varlist)'
	}
	if `pshetprobit' {
		fvexpand `htvarlist' if `touse'
		local fvhtvlist `r(varlist)'

		fvrevar `htvarlist' if `touse'
		local fvhtrevar `r(varlist)'
	}
	if `dhetprobit' {
		fvexpand `hdvarlist' if `touse'
		local fvhdvlist `r(varlist)'

		fvrevar `hdvarlist' if `touse'
		local fvhdrevar `r(varlist)'
	}
	_teffects_omit_vars, klev(`klev') fvtvlist(`fvtvlist')       ///
		fvtrevar(`fvtrevar') `tconst' fvhtvlist(`fvhtvlist') ///
		fvhtrevar(`fvhtrevar') fvdvlist(`fvdvlist')          ///
		fvdrevar(`fvdrevar') `dconst' fvhdvlist(`fvhdvlist') ///
		fvhdrevar(`fvhdrevar')

	local komit = `r(komit)'
	local ind `"`r(index)'"'
	local fvotrevar `"`r(fvotrevar)'"'
	local fvohtrevar `"`r(fvohtrevar)'"'
	local fvodrevar `"`r(fvodrevar)'"'
	local fvohdrevar `"`r(fvohdrevar)'"'
	local kpar0 = `r(k)'
	local k : list sizeof fvotrevar
	local kpar : list sizeof ind
	if `pshetprobit' {
		local htinstr "instruments(`psheq': `fvohtrevar', noconstant)"
		local htvopt htvarlist(`fvohtrevar')
	}
	if `dhetprobit' {
		local hdinstr "instruments(`dheq': `fvohdrevar', noconstant)"
		local hdvopt hdvarlist(`fvohdrevar')
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
	tempname b0 b1
	if `init' {
		InitialEstimates `fvotrevar', tmodel(`tmodel')          ///
			omodel(`omodel') depvar(`depvar') tvar(`tvar')  ///
			tvars(`tvars') tlevels(`tlevels') `control'     ///
			`treated' dvarlist(`fvodrevar') touse(`touse')  ///
			stat(`stat') `epscd' wtype(`wtype') wvar(`wvar') ///
			`htvopt' `hdvopt' `verbose' cmm(`cmm')
		mat `b0' = r(b)
		if ("`from'"!="") local fopt from(`from') `fopt'
	}
	else {
		if ("`fopt'"=="copy") mat `b0' = J(1,`kpar0',0)
		else mat `b0' = J(1,`kpar',0)

		local fopt from(`from') `fopt'
	}

	if "`from'" != "" {
		_teffects_from `b0', `fopt' kpar(`kpar0') komit(`komit') ///
			index(`ind') tvar(`tvar') tlevels(`tlevels')     ///
			`control' stat(`stat') omodel(`omodel')          ///
			tmodel(`tmodel') fvdvlist(`fvdvlist')            ///
			fvhdvlist(`fvhdvlist') fvtvlist(`fvtvlist')      ///
			fvhtvlist(`fvhtvlist') dconstant(`dconstant')    ///
			tconstant(`tconstant') `enseparator'
		mat `b0' = r(b)
		if "`verbose'" != "" {
			di as txt _n "{bf:from()} updated initial estimates"
			mat li `b0'
		}
	}
	/* extract TE and PS components of initial estimates to test	*/
	/*  the overlap assumption					*/
	local kom : list sizeof fvodrevar
	local kh : list sizeof fvohdrevar
	local k = `klev' + `klev'*(`kom'+`kh') + 1
	mat `b1' = (`b0'[1,1..`klev'],`b0'[1,`k'...])
	_teffects_validate_overlap `fvotrevar', at(`b1') tvars(`tvars') ///
		tlevels(`tlevels') model(`tmodel') depvar(`depvar')     ///
		touse(`touse') stat(`stat') `control' `treated' `epscd' ///
		hvarlist(`fvohtrevar') `osample' `force'

	if ("`wtype'"!="") local wts "[`wtype'=`wvar']"
	if ("`iterlogonly'"!="") di

	if "`cmm'" == "" {
		/* IPWRA						*/
		cap `noi' gmm _teffects_gmm_ipwra if `touse' `wts',	///
			equations(`meqs' `deqs' `dheq' `teqs' `psheq')	///
			instruments(`meqs':)				///
			instruments(`deqs': `fvodrevar', noconstant)	///
			instruments(`teqs': `fvotrevar', noconstant)	///
			`htinstr' `hdinstr' onestep 			///
			nparameters(`kpar')				///
			hasderivatives					///
			depvar(`depvar')				///
			tvars(`tvars') tlevels(`tlevels')		///
			`control' `treated'				///
			tvarlist(`fvotrevar') `htvopt'			///
			dvarlist(`fvodrevar') `hdvopt'			///
			stat(`stat')					///
			tmodel(`tmodel') 				///
			omodel(`omodel') 				///
			from(`b0') `options' `iterlogonly'
	}
	else {
		/* AIPW							*/
		cap `noi' gmm _teffects_gmm_aipw if `touse' `wts',	///
			equations(`meqs' `deqs' `dheq' `teqs' `psheq')	///
			instruments(`meqs':)				///
			instruments(`deqs': `fvodrevar', noconstant)	///
			instruments(`teqs': `fvotrevar', noconstant)	///
			`htinstr' `hdinstr' onestep 			///
			nparameters(`kpar')				///
			hasderivatives					///
			depvar(`depvar')				///
			tvars(`tvars') tlevels(`tlevels')		///
			`control' 					///
			psvars(`fvotrevar') ohvars(`fvohdrevar')	///
			ovars(`fvodrevar') pshvars(`fvohtrevar')	///
			stat(`stat')					///
			tmodel(`tmodel') 				///
			ofform(`omodel') cmm(`cmm')			///
			from(`b0') `options' `iterlogonly'
	}
	local rc = c(rc)
	if `rc' {
		if (`rc'>1) di as err "{bf:gmm} estimation failed"

		exit `rc'
	}
	_teffects_ipwra_bv, kpar(`kpar0') komit(`komit') index(`ind')  ///
		tvar(`tvar') tlevels(`tlevels') `control' stat(`stat') ///
		omodel(`omodel') tmodel(`tmodel') fvdvlist(`fvdvlist') ///
		fvhdvlist(`fvhdvlist') fvtvlist(`fvtvlist')            ///
		fvhtvlist(`fvhtvlist') dconstant(`dconstant')          ///
		tconstant(`tconstant') `enseparator'

	return add
end

program define InitialEstimates, rclass
	syntax varlist(numeric), tmodel(string) omodel(string) 	         ///
			depvar(passthru) tvar(passthru) tvars(passthru)  ///
			tlevels(string) control(passthru)                ///
			dvarlist(varlist) touse(passthru) stat(passthru) ///
			epscd(passthru) [ treated(passthru)              ///
			hdvarlist(varlist) htvarlist(varlist) verbose    ///
			wtype(passthru) wvar(passthru) cmm(string) ]

	tempvar ipw
	tempname bipw bra b b0
	local klev : list sizeof tlevels

	if ("`cmm'"!="") local noscale noscale
	/* IPW stage							*/
	_teffects_ipw_init `varlist', model(`tmodel') `depvar' `tvar'     ///
		tlevels(`tlevels') `control' `treated' `touse' `stat'     ///
		hvarlist(`htvarlist') `verbose' `wtype' `wvar' ipw(`ipw') ///
		`noscale'
	mat `bipw' = r(b)

	if "`cmm'"=="" | "`cmm'"=="aipw" {
		/* RA stage, IPWRA or vanilla AIPW			*/
		_teffects_ra_init `dvarlist', model(`omodel') `depvar' ///
			`tvar' tlevels(`tlevels') `control' `treated'  ///
			`touse' `stat' hvarlist(`hdvarlist') `verbose' ///
			`wtype' `wvar' ipw(`ipw') `cmm'
	}
	else {
		/* AIPW with cmm == nls, or cmm == wnls			*/
		NLinit `dvarlist', model(`omodel') `depvar' `tvars'     ///
			tlevels(`tlevels') `control' `touse' `stat'     ///
			hvarlist(`hdvarlist') ipw(`ipw') `wtype' `wvar' ///
			cmm(`cmm') `verbose'
	}
	mat `bra' = r(b)
	mat `b' = (`bra',`bipw')
	if "`verbose'" != "" {
		mat li `b', title("initial estimates")
	}
	return mat b = `b'
end

program define NLinit, rclass
	syntax varlist(numeric), model(string) depvar(varname)               ///
			tvars(varlist) tlevels(string) control(string)       ///
			touse(varname) stat(string) cmm(string) ipw(varname) ///
			[ hvarlist(varlist) verbose wtype(string) wvar(varname)]

	if ("`verbose'"!="") local noi noi

	tempvar cm mc
	tempname b bj t t0 bh

	if "`cmm'" == "wnls" {
		tempvar wtsv
		if "`wtype'" == "fweight" {
			/* -_teffects_ipw_init- weights ipw with freqs	*/
			qui gen double `wtsv' = `ipw' if `touse'
			qui replace `ipw' = `ipw'/`wvar' if `touse'
			qui replace `wtsv' = `wtsv'*(`ipw'-1) if `touse'
		}
		else qui gen double `wtsv' = `ipw'*(`ipw'-1) if `touse'

		local wts [iw=`wtsv']
	}
	else if "`wtype'" == "fweight" {
		/* _teffects_ipw_init weights ipw with freqs		*/
		qui replace `ipw' = `ipw'/`wvar'
		local wts [fw=`wvar']
	}
	if "`wtype'" == "fweight" {
		/* weights for summarize				*/
		local swt [fw=`wvar']
	}
	if "`model'" == "linear" {
		local ccmd "regress `depvar' `varlist'"
		local extra "noconstant"
	} 
	else if "`model'" == "poisson" {
		local ccmd "nl (`depvar' = exp({xb:`varlist'}))"
		local extra iterate(100) 
	}
	else if ("`model'" == "probit"|"`model'" == "fprobit") {
		local ccmd "nl (`depvar' = normal({xb:`varlist'}))" 
		local extra iterate(100)
	}
	else if ("`model'" == "logit"|"`model'" == "flogit") {
		local ccmd "nl (`depvar' = invlogit({xb:`varlist'}))" 
		local extra iterate(100)
	}
	else if ("`model'" == "hetprobit"|"`model'" == "fhetprobit") {
		local ccmd "nl (`depvar' = normal(({xb:`varlist'})/"
		local ccmd "`ccmd'exp({zb:`hvarlist'})))" 
		local extra iterate(100)
		local iv : list sizeof varlist
		local ih = `iv'+1
	}
	else error 498 // programmer error

	local klev : list sizeof tvars
	mat `t' = J(1,`klev',0)
	qui gen double `mc' = . if `touse'
	local noconv = 0
	forvalues j=1/`klev' {
		local tj : word `j' of `tvars'

		cap `noi' `ccmd' if `tj' & `touse' `wts', `extra'
		local rc = c(rc)
		if `rc' {
			if `rc' > 1 {
				/* programmer error			*/
				di as err "{p}{it:omodel} {cmd:`model'} " ///
				 "{cmd:`cmm'} initial estimates failed{p_end}"
				exit `rc'
			}
		}
		if "`model'" != "linear" {
			local noconv = `noconv' + !e(converge)
		}
		mat `bj' = e(b)
		if ("`model'" == "hetprobit" |"`model'" == "fhetprobit"){
			mat `bh' = (nullmat(`bh'),`bj'[1,`ih'...])
			mat `bj' = `bj'[1,1..`iv']
		}
		mat `b' = (nullmat(`b'),`bj')

		qui predict double `cm' if `touse'

		qui replace `mc' =  `cm' + cond(`tj', ///
			`ipw'*(`depvar'-`cm'),0) if `touse'

		summarize `mc' if `touse' `swt', meanonly	
		matrix `t'[1,`j'] = r(mean)
		qui drop `cm'
	}		
	if `noconv' {
		di as txt "{p 0 6 2}Note: {it:omodel} {cmd:`model'} "      ///
		 "{cmd:`cmm'} initial estimates did not converge for "     ///
		 "`noconv' of the `klev' treatment levels; the model may " ///
		 "not be identified{p_end}" 
	}

	if ("`model'"=="hetprobit"|"`model'" == "fhetprobit") ///
		mat `b' = (`b',`bh')

	if "`stat'" != "pomeans" {
		local ic : list posof "`control'" in tlevels
		scalar `t0' = `t'[1,`ic']
		forvalues i=1/`klev' {
			if (`i'!=`ic') mat `t'[1,`i'] = `t'[1,`i']-`t0'
		}
	}
	if "`verbose'"!="" {
		mat li `t', title(treatment effects)
	}
	mat `b' = (`t',`b')
	mat colnames `b' = ""
	mat coleq `b' = ""

	return mat b = `b'
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
