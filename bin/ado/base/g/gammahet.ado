*! version 1.4.3  01feb2017
program define gammahet, eclass byable(recall)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	else {
		local vv "version 8.1:"
	}
	version 7
	if replay() {
		if `"`e(cmd)'"' != "gammahet" { error 301 } 
		if _by() { error 190 }
		Display `0'
		error `e(rc)'
		exit
	}
	
	syntax [varlist(fv)] [if] [in] [fweight pweight iweight] /*
		*/ [, noCOEF FRailty(string) SHared(string)/*
		*/ CLuster(varname) Dead(varname numeric)/*
		*/ DEBUG FROM(string) noHEADer /*
		*/ noCONstant Level(cilevel) noLOg /*
		*/ OFFset(varname numeric) noLRtest/*
		*/ Robust SCore(string) T0(varname numeric) SKIP TR /*
		*/ moptobj(passthru) *]
	if _by() {
		_byoptnotallowed score() `"`score'"'
	}

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	tokenize `varlist'
	local t `1'
	mac shift 
	local rhs `*'

	if `"`shared'"'!="" {
di as error "shared() currently not available with gamma regression"
		exit 198
	}
	if "`cluster'"!="" {
		local cluopt cluster(`cluster')
	}
	if "`from'" != "" { local iniopt init(`from') }
	if "`offset'" !="" { local offopt = "offset(`offset')" }
	_get_diopts diopts options, `options'
	mlopts options, `options'
	local coll `s(collinear)'
	local cns `s(constraints)'
		
	GetFrailty `frailty'
	local mlprog `r(prog)'
	local frtitle `r(frt)'
	local pred `r(pred)'

	if "`score'" != "" { 
		local n : word count `score'
		if `n'==1 & bsubstr("`score'",-1,1)=="*" { 
			local score = /*
			*/ bsubstr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2 `score'3 `score'4
			local n 4
		}
		if `n' != 4 { 
			di as err /*
		*/ "score() invalid:  four new variable names required"
			exit 198 
		}
		confirm new var `score'
		local scopt "score(`score')"
	}

	if "`weight'" != "" { 
		tempvar wv
		qui gen double `wv' `exp'
		local w [`weight'=`wv']
	}

	tempvar touse 
	mark `touse' `w' `if' `in'
	markout `touse' `t' `rhs' `dead' `t0' `offset'
	markout `touse' `cluster', strok

	if "`dead'" != "" {
		local sdead "`dead'"
		capture assert `dead'==0 | `dead'==1 if `touse'
		if _rc { 
			tempvar mydead 
			qui gen byte `mydead' = `dead'!=0 if `touse'
			local dead "`mydead'"
		}
	}
	else {
		tempvar dead 
		qui gen byte `dead'=1
		local sdead 1
	}
	if "`t0'" == "" {
		local t0 0
	}
	else { local topt t0(`t0') }

	capture assert `t0' < `t' if `touse'
	if _rc {
		di as err "`t0' >= `t' in some obs."
		exit 498
	}

	if `fvops' {
		local rmcoll "version 11: _rmcoll"
	}
	else	local rmcoll _rmcoll
	`rmcoll' `rhs' `w' if `touse', `constant' `coll'
	local rhs "`r(varlist)'"
	global S_1

	if "`log'"!="" { local nlog="*" }

	if `"`from'"'=="" & "`lrtest'"=="" {
		if "`robust'`cns'`cluster'"!="" | "`weight'"=="pweight" {
			local lrtest "nolrtest"
		}
		`nlog' di as txt _n "Fitting gamma model:"

		`vv' ///
		qui gamma `t' `rhs' `w' if `touse', nocoef /*
		*/ dead(`dead') `topt' `offopt' `constant' `mlopts' 
		
		tempname bp
		mat `bp' = e(b)
		
		if "`lrtest'"=="" {
			tempname llc
			scalar `llc' = e(ll)
		}
	}

	else if `"`from'"'=="" { /*nolrtest*/
		`nlog' di as txt _n "Fitting gamma model:"
		`vv' ///
		qui gamma `t' `rhs' `w' if `touse', nocoef /*
		*/ dead(`dead') `topt' `offopt' `constant' `mlopts' 
		tempname bp
		mat `bp' = e(b) 
	}
	
	if "`constant'"!="" {
		local skip = "skip"
		`nlog' di as txt _n "Fitting full model:"
	}
	
	global EREGd `dead'
	global EREGt `t'
	global EREGt0 `t0'

	if _caller() < 15 {
		local lnsig ln_sig
		local lnthe ln_the
	}
	else {
		local lnsig lnsigma
		local lnthe lntheta
	}	
	if "`rhs'" != "" & "`skip'"=="" { 
		`nlog' di ""
		`nlog' di as txt "Fitting constant-only model:"
		`vv' ///
		ml model lf `mlprog' (`t': `t'=, `offopt') /*
			*/ /`lnsig' /kappa /`lnthe' /* 
			*/ `w' if `touse', /*
			*/ missing collin nopreserve wald(0) `mlopts' /*
			*/ max search(quietly) noout `log' `options' /*
			*/ `robust' nocnsnotes
		local converged_cons = e(converged)
		if `converged_cons' == 0 { local cont wald(1) }
		else { local cont continue }
		`nlog' di ""
		`nlog' di as txt "Fitting full model:"
	}
	else {
		 local cont wald(1)
	}

	if `"`from'"'=="" {
		tempname b0
		mat `b0' = (0)
		if _caller() < 15 {
			mat colnames `b0' = `lnthe':_cons
		}
		else {
			mat colnames `b0' = /`lnthe'
		}
		mat `bp' = (`bp',`b0')
		local iniopt "init(`bp')"
	}
	else { local iniopt `"init(`from')"' }


	global GLIST : all globals "EREG*"
	
	`vv' ///
	ml model lf `mlprog' /*
		*/ (`t': `t'=`rhs' , `offopt' `constant') /*
		*/ /`lnsig' /kappa /`lnthe' `w' if `touse', `cont' noout /*
		*/ `robust' `cluopt' `scopt' `iniopt' `mlopts' /*
		*/ missing collin nopreserve /*
		*/ max search(quietly) `log' /*
		*/ diparm(`lnsig', exp label(sigma)) /*
		*/ diparm(`lnthe', exp label(theta)) /*
		*/ `options' `moptobj'

	if "`e(wtype)'" != "" {
		est local wexp `"`exp'"'
	}
	if _caller() < 15 {
		est local title2 "accelerated failure-time form"
	}
	est local fr_title `frtitle'
	est local predict `pred'
	est local t0 "`t0'"
       	est local dead `sdead'
	est local stcurve="stcurve"
	est scalar kappa = _b[/kappa]
	est scalar sigma = exp(_b[/`lnsig'])        
	est scalar theta = exp(_b[/`lnthe'])
	cap est hidden scalar converged_cons = `converged_cons'

	if `"`lrtest'"'=="" & `"`from'"'=="" { 
		est scalar ll_c = `llc' 
		if (_b[/`lnthe'] < -20) | (e(ll)<e(ll_c)) {
			est scalar chi2_c = 0
			est scalar p_c = 1
		}
		else {
			est scalar chi2_c = 2*(e(ll)-e(ll_c))
			est scalar p_c = chi2tail(1, e(chi2_c))*0.5
		}
	}
	est scalar k_aux = 3
	est local footnote streghet_footnote 
	est local cmd gammahet 

	global S_E_cmd gammahet
	macro drop EREGd EREGt EREGt0 
	
	Display, level(`level') `coef' `header' `tr' `diopts'
	error `e(rc)'
end

program define GetFrailty, rclass
	local frailty `"`1'"'
	if "`frailty'"=="" {
		di as err "must specify -frailty(gamma | invgauss)-"
		exit 198
	}
	
	local l = length("`frailty'")
	if bsubstr("gamma",1,max(1,`l')) == "`frailty'" {
		return local prog gamhet_glf
		return local frt "Gamma frailty"
		return local pred gamhet_gp 
	}
	else if bsubstr("invgaussian",1,max(1,`l')) == "`frailty'" {
		return local prog gamhet_ilf
		return local frt "Inverse-Gaussian frailty"
		return local pred gamhet_ip
	}
	else {
		di as err "unknown distribution frailty(`frailty')"
		exit 198
	}
end
		
program define Display 
	syntax [, Level(cilevel) noCOEF noHEADer TR *]
	_get_diopts diopts options, `options'
	if "`coef'"=="" {
		if `"`tr'"'!=`""' {
			local hr `"eform(Time Ratio)"'
                }

		if "`header'" == "" {
			di _n as txt /*
			*/ "Gamma AFT regression, " /* 
			*/ "`e(fr_title)'" " -- entry time `e(t0)'"
		}
		version 9: ///
		ml di, `header' `hr' level(`level') title(`e(title2)')	///
			nofootnote `diopts'
		_prefix_footnote
	}
end
exit
