*! version 1.0.2  07may2019

program define _stteffects_surv_init, rclass
	syntax varname, touse(varname) survdist(string) stat(string) ///
		levels(string) control(integer) tlevel(integer)      ///
		[ survvars(string) survshape(string) wvar(varname)   ///
		fuser verbose * ]

	/* fuser macro indicates user specified from()			*/
	local pomeans = ("`stat'"=="pomeans")
	local tvar `varlist'
	if "`verbose'" != "" {
		di as txt _n "Fitting the survival model"
		local noi noi
		local baselev allbaselevels nofvlabel
	}
	else local nolog nolog

	FVCompatibleVlist, vlist(`survvars') tvar(`tvar') touse(`touse')
	local fsurvvars `"`s(varlist)'"'
	local constant = `s(constant)'
	if `constant' {
		local consvars `"`s(consvars)'"'
	}
	if inlist("`survdist'","weibull","gamma","lnormal") {
		FVCompatibleVlist, vlist(`survshape') tvar(`tvar') ///
			touse(`touse')
		local avlist `survshape'
		local fsurvshape `"`s(varlist)'"'
		local ancconst = `s(constant)'
		local ancopt ancillary(`fsurvshape',noconstant)
		if `ancconst' {
			local anconstvars `"`s(consvars)'"'
			local ancopt0 ancillary(`anconstvars',noconstant)
		}
		else if `constant' {
			/* use full ancillary model			*/
			local ancopt0 `ancopt'
		}
	}
	if "`survdist'" == "gamma" {
		if "`wvar'" == "" {
			/* check sttset					*/
			local wtype : char _dta[st_wt]
			if "`wtype'" != "" {
				local wvar : char _dta[st_wv]
			}
		}
		else {
			local wtype iweight
		}
		if "`wvar'" != "" {
			local wopt wtype(`wtype') wvar(`wvar')
		}
		cap `noi' _stteffects_gamma, touse(`touse')          ///
			vars(`fsurvvars') `wopt' noconstant `ancopt' ///
			noancconst `verbose' `options'
	}
	else {
		if "`wvar'" != "" {
			/* censoring/IP weights				*/
			local wopt sttewt(`wvar')
		}
		if `constant' {
			/* constant only model				*/
			cap `noi' streg `consvars' if `touse', time ///
				distribution(`survdist') noconstant ///
				`ancopt0' `nolog' `options' `baselev' `wopt'

			tempname b0
			mat `b0' = e(b)
			local fopt from(`b0')
		}
		cap `noi' streg `fsurvvars' if `touse', time         ///
			distribution(`survdist') noconstant `ancopt' ///
			`nolog' `options' `baselev' `wopt' `fopt'
	}
	local rc = c(rc)
	if (`rc') {
		di as err "{p}outcome-model estimation has failed; " ///
		 "computations cannot proceed{p_end}"
		exit `rc'
	}
	if !e(converged) & "`fuser'"=="" {
		di as txt "{p 0 6 2}note: outcome-model estimation, " ///
		 "convergence not achieved{p_end}"
	}

	tempname sb mb rb b est
	mat `sb' = e(b)

	CoefByTreatment, dist(`survdist') vlist(`survvars') avlist(`avlist') ///
		levels(`levels') control(`control') b(`sb')
	mat `sb' = r(b)
	local snames : colfullnames `sb'

	if !`pomeans' {
		qui estimates store `est'
	}

	if "`stat'" == "atet" {
		tempvar wt

		qui gen byte `wt' = (`tvar'==`tlevel') if `touse'
		local subopt subpop(`wt')
	}
	local wtype : char _dta[st_wt]
	if "`wtype'" != "" {
		local wvar : char _dta[st_wv]
		local wgt [`wtype'=`wvar']
	}
	else {
		local noweights noweights
	}

	cap `noi' margins i.`tvar' if `touse' `wgt', predict(mean time) ///
		noesample nose `noweights' `subopt' post
	local rc = c(rc)
	if `rc' {
		di as err "{p}failed to compute initial estimates of the " ///
		 "potential outcome means; computations cannot proceed{p_end}"
		exit `rc'
	}
	mat `mb' = e(b)

	if (`pomeans') mat coleq `mb' = POmeans
	else mat coleq `mb' = POmean

	local mnames : colfullnames `mb'

	if !`pomeans' {
		qui estimates restore `est'
		if "`stat'" == "cot" {
			local stat0 atet
		}
		else {
			local stat0 `stat'
		}
		local ustat = strupper("`stat0'")
		tempname rb
		cap `noi' margins rb`control'.`tvar' if `touse' `wgt',    ///
			predict(mean time) contrast noesample `noweights' ///
			nose `subopt' post
		local rc = c(rc)
		if `rc' {
			di as err "{p}failed to compute initial estimates " ///
			 "of the `ustat'; computations cannot proceed{p_end}"
			exit `rc'
		}
		mat `rb' = e(b)
		mat coleq `rb' = `ustat'
		local rnames : colfullnames `rb'
	}

	local kcntl : list posof "`control'" in levels
	if !`pomeans' {
		local mn : word `kcntl' of `mnames'
		mat `mb' = (`rb',`mb'[1,`kcntl'])
		local mstripe `rnames' `mn'
		mat colnames `mb' = `mstripe'
	}
	return mat b = `sb'
	return mat mb = `mb'
end

program define FVCompatibleVlist, sclass
	syntax, tvar(name) touse(name) [ vlist(passthru) ]

	fvexpand ibn.`tvar' if `touse'
	local tvlist `r(varlist)'

	_stteffects_split_vlist, `vlist'
	local vlist `"`s(vlist)'"'
	local constant `s(constant)'

	/* assumption vlist is fvexpand'ed				*/
	while `"`vlist'"' != "" {
		gettoken expr vlist : vlist, bind

		_ms_parse_parts `expr'

		if "`r(type)'"=="variable" & "`r(op)'"=="" {
			local expr c.`expr'
		}
		local tvlist0 `tvlist'
		local fvlist0
		while "`tvlist0'" != "" {
			gettoken texp tvlist0 : tvlist0, bind
			local fvlist0 `"`fvlist0' `expr'#`texp'"'
		}
		local fvlist `"`fvlist' `fvlist0'"'
	}
	/* matrix stripe form						*/
	if "`constant'" == "" {
		local fvlist `"`fvlist' `tvlist'"'
	}
	local fvlist : list retokenize fvlist

	/* put back into syntax form					*/
	local 0 `"`fvlist'"'
	syntax varlist(numeric fv)

	sreturn local varlist `"`varlist'"'
	sreturn local constant = ("`constant'"=="")
	sreturn local consvars `"`tvlist'"'
end

program define GetSurvAncillary
	syntax, touse(name) sb(name) klev(integer) ancillary(string)

	tempname b0 b1 bc s

	fvexpand `ancillary' if `touse'
	local vlist1 `r(varlist)'
	local n1 : list sizeof vlist1
	local `++n1'

	local nc = colsof(`sb')

	local k1 = `nc'-`n1'
	mat `b0' = `sb'[1,1..`k1']
	local `++k1'

	mat `b1' = `sb'[1,`k1'..`nc']
	local eq1 : coleq `b1'
	local eq1 : word 1 of `eq1'
	scalar `s' = `b1'[1,`n1']

	local k = `n1'-`klev'
	/* treatment constants						*/
	mat `bc' = `b1'[1,`k'..`--n1']
	mat `bc' = `bc' + J(1,`klev',`s')
	if `k' > 1 {
		/* ancillary regressors					*/
		mat `b1' = `b1'[1,1..`--k']
		mat `b1' = (`b1',`bc')
	}
	else mat `b1' = `bc'

	mat colnames `b1' = `vlist1'
	mat coleq `b1' = `eq1'

	mat `sb' = (`b0',`b1')
end

program define CoefByTreatment, rclass
	syntax, dist(string) vlist(passthru) levels(string) b(name) ///
		control(integer) [ avlist(string) ]

	tempname bs ba ba2

	_stteffects_split_vlist, `vlist'
	local vlist `"`s(vlist)'"'
	local constant = ("`s(constant)'"=="")

	if `"`avlist'"' != "" {
		_stteffects_split_vlist, vlist(`avlist')
		local avlist `"`s(vlist)'"'
		local avconst = ("`s(constant)'"=="")
	}
	local klev : list sizeof levels
	local kvar : list sizeof vlist
	local kavar : list sizeof avlist
	local eqb : coleq `b'
	local eqb : list uniq eqb
	local nc = colsof(`b')

	local ks = `kvar'+`constant'
	local kb = `klev'*`ks'
	mat `bs' = J(1,`nc',0)

	if "`dist'" != "exponential" {
		local ka = `kavar'+`avconst'
		local ka = `klev'*`ka'

		mat `ba' = J(1,`ka',0)
		local ja = `kb'
		local j = `ja'+`ka'
		mat `ba' = `b'[1,`=`ja'+1'..`j']
	}
	else {
		local ka = 0
		local ja = 0
	}
	local k = 0
	forvalues i=1/`klev' {
		local ij = `i'
		local lev : word `i' of `levels'
		local eq OME`lev'
		forvalues j=1/`kvar' {
			mat `bs'[1,`++k'] = `b'[1,`ij']
			local ij = `ij' + `klev'
			local var : word `j' of `vlist'
			local stripe `"`stripe' `eq':`var'"'
		}
		if `constant' {
			local stripe `"`stripe' `eq':_cons"'
			mat `bs'[1,`++k'] = `b'[1,`ij']
		}
		if `ka' {
			/* ancillary					*/
			local ij = `ja' + `i'
			local eq0 `eq'_lnshape
			forvalues j=1/`kavar' {
				mat `bs'[1,`++k'] = `b'[1,`ij']
				local ij = `ij' + `klev'
				local var : word `j' of `avlist'
				local stripe `"`stripe' `eq0':`var'"'
			}
			if `avconst' {
				local stripe `"`stripe' `eq0':_cons"'
				mat `bs'[1,`++k'] = `b'[1,`ij']
			}
		}
	}
	mat colnames `bs' = `stripe'
	return mat b = `bs'
end

exit
