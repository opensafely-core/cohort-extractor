*! version 1.4.3  01feb2017
program define gompertzhet, eclass byable(recall) sort prop(ml_score)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
	}
	else {
		local vv "version 8.1:"
		local mm d2
	}
	version 7
	if replay() {
		if `"`e(cmd)'"' != "gompertzhet" { error 301 } 
		if _by() { error 190 }
		Display `0'
		error `e(rc)'
		exit
	}

	syntax [varlist(fv)] [if] [in] [fweight pweight iweight] /*
		*/ [, noCOEF FRailty(string) SHared(varname) /*
		*/ CLuster(varname) Dead(varname numeric)/*
		*/ DEBUG FROM(string) noHEADer HR MLMethod(string) /*
		*/ noCONstant Level(cilevel) noLOg /*
		*/ OFFset(varname numeric) noLRtest/*
		*/ Robust SCore(string) T0(varname numeric) SKIP /*
		*/ moptobj(passthru) *]
	if _by() {
		_byoptnotallowed score() `"`score'"'
	}

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	tokenize `varlist'
	local t `1'
	mac shift 
	local rhs `*'

	if "`shared'"!="" & "`robust'"!="" {
		di as error "robust/pweights not allowed with shared()"
		exit 101
	}

	if "`cluster'"!="" {
		local cluopt cluster(`cluster')
		if "`shared'" != "" {
			di as err "cluster() not allowed with shared()"
			exit 198
		}
	}
	if "`from'" != "" { local iniopt init(`from') }
	if "`mlmethod'" == "" { local mlmethod = "`mm'" }
	if "`offset'" !="" { local offopt = "offset(`offset')" }
	_get_diopts diopts options, `options'
	mlopts options, `options'
	local coll `s(collinear)'
	local cns `s(constraints)'
		
	GetFrailty `frailty' "`shared'"
	local mlprog `r(prog)'
	local frtitle `r(frt)'
	local pred `r(pred)'
	
	if "`shared'"!="" {
		local mlprog "`mlprog'_sh"
		if "`mlmethod'" == "e2" {
			local mlmethod d2
		}
	}

	if "`score'" != "" {
		if "`shared'" != "" {
			di as err "score() not allowed with shared()"
			exit 198
		}
		local n : word count `score'
		if `n'==1 & bsubstr("`score'",-1,1)=="*" { 
			local score = /*
			*/ bsubstr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2 `score'3 
			local n 3
		}
		if `n' != 3 { 
			di as err /*
		*/ "score() invalid:  three new variable names required"
			exit 198 
		}
		confirm new var `score'
		local scopt "score(`score')"
	}

	tempvar touse 
	mark `touse' `if' `in'
	markout `touse' `t' `rhs' `dead' `t0' `offset'
	markout `touse' `cluster' `shared', strok

	if "`weight'" != "" { 
		tempvar wv
		qui gen double `wv' `exp'
		markout `touse' `wv'
		local w [`weight'=`wv']
		if `"`shared'"'!="" {
			/* weights should be constant within group */
			if "`weight'" != "iweight" {
di as error "only iweights are allowed with shared()"
				exit 101
			}
			CheckWgt `shared' `w' if `touse'
		}
	}

	if `"`shared'"' != "" {      /* internal _mlmatbysum code requires */
		tempvar shid         /* numeric by() variable */
		qui egen double `shid' = group(`shared') if `touse'
		local realsh "`shared'"
		local shared `shid'
	}

	if `"`_dta[st_id]'"' != "" {
		local subid `_dta[st_id]'
	}

	if `"`shared'"' != "" & `"`subid'"' != "" {
		tempvar diff
		sort `touse' `subid' `shared'
		qui by `touse' `subid': gen long `diff' = /*
			*/ `shared'-`shared'[_n-1] if `touse'
		capture assert `diff'==0 if !missing(`diff') & `touse'
		if _rc {
			local warn warn
		}
		drop `diff'
	}

	tempvar nn
	gen `c(obs_t)' `nn' = _n
	sort `touse' `shared' `nn'

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
		`nlog' di as txt _n "Fitting Gompertz model:"

		`vv' ///
		qui gompertz `t' `rhs' `w' if `touse', nocoef /*
		*/ dead(`dead') `topt' `offopt' `constant' `mlopts' 
		
		tempname bp
		mat `bp' = e(b)
		
		if "`lrtest'"=="" {
			tempname llc
			scalar `llc' = e(ll)
		}
	}

	else if `"`from'"'=="" { /*nolrtest*/
		`nlog' di as txt _n "Fitting Gompertz model:"
		`vv' ///
		qui gompertz `t' `rhs' `w' if `touse', nocoef /*
		*/ dead(`dead') `topt' `offopt' `constant' `mlopts' 
		tempname bp
		mat `bp' = e(b) 
	}
	
	global EREGd `dead'
	global EREGt `t'
	global EREGt0 `t0'
	if "`shared'"!="" {
		global EREG_by "`touse' `shared'"
		global EREG_sh "`shared'"
	}

	if _caller() < 15 {
		local lntheta ln_the
	}
	else {
		local lntheta lntheta
	}	
	tempvar num den

	quietly {
                if "`weight'"=="aweight" | "`weight'"=="pweight" {
                        tempvar wvn
                        summ `wv' if `touse', meanonly
                        gen double `wvn' = `wv'/r(mean) 
                        local wvngen 1
                }
                else if "`weight'"!="" {
                        local wvn `wv'
                }
                else {
                        local wvn 1
                }
                gen double `num' = sum(`wvn'*`dead'*`touse')  
                gen double `den' = sum(`wvn'*(`t'-$EREGt0)*`touse') 
                local cons = ln(`num'[_N]/`den'[_N])
                drop `num' `den'
                if "`wvngen'"!=""  { drop `wvn' }
		local initopt init(_cons=`cons' /gamma=0 /`lntheta'=0)
        }

	
	if "`constant'"!="" {
		local skip = "skip"
		`nlog' di as txt _n "Fitting full model:"
	}
	
	
	if "`rhs'" != "" & "`skip'"=="" { 
		`nlog' di ""
		`nlog' di as txt "Fitting constant-only model:"
		`vv' ///
		ml model `mlmethod' `mlprog' (`t': `t'=, `offopt') /*
			*/ /gamma /`lntheta' /* 
			*/ `w' if `touse', `initopt' /*
			*/ missing collin nopreserve wald(0) `mlopts' /*
			*/ max search(quietly) noout `log' `options' /*
			*/ `robust' nocnsnotes `negh'
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
			mat colnames `b0' = `lntheta':_cons
		}
		else {
			mat colnames `b0' = /`lntheta'
		}
		mat `bp' = (`bp',`b0')
		local iniopt "init(`bp')"
	}
	else { local iniopt `"init(`from')"' }

	global GLIST : all globals "EREG*"
	
	`vv' ///
	ml model `mlmethod' `mlprog' /*
		*/ (`t': `t'=`rhs' , `offopt' `constant') /*
		*/ /gamma /`lntheta' `w' if `touse', `cont' noout /*
		*/ `robust' `cluopt' `scopt' `iniopt' `mlopts' /*
		*/ missing collin nopreserve /*
		*/ max search(quietly) `log' `options' /*
		*/ diparm(`lntheta', exp label(theta)) `negh' `moptobj'

	if "`e(wtype)'" != "" {
		est local wexp `"`exp'"'
	}
	if _caller() < 15 {
		est local title2 "log relative-hazard form"
	}
	est local fr_title `frtitle'
	est local predict `pred'
	est local t0 "`t0'"
       	est local dead `sdead'
	est local shared `realsh'
	est local stcurve stcurve 
	est scalar gamma = _b[/gamma]        
	est scalar theta = exp(_b[/`lntheta'])
	if "`shared'" != "" {
		SaveGrpInfo `shared' `touse' `w'
		if "`warn'"!="" {
			est local sh_warn sh_warn
		}
	}
	cap est hidden scalar converged_cons = `converged_cons'

	if `"`lrtest'"'=="" & `"`from'"'=="" { 
		est scalar ll_c = `llc' 
		if (_b[/`lntheta'] < -20) | (e(ll)<e(ll_c)) {
			est scalar chi2_c = 0
			est scalar p_c = 1
		}
		else {
			est scalar chi2_c = 2*(e(ll)-e(ll_c))
			est scalar p_c = chi2tail(1, e(chi2_c))*0.5
		}
	}
	est scalar k_aux = 2
	est local footnote streghet_footnote
	est local cmd gompertzhet

	global S_E_cmd gompertzhet
	macro drop EREGd EREGt EREGt0 EREG_by EREG_sh
	
	Display, level(`level') `coef' `header' `hr' `diopts'
	error `e(rc)'
end

program define CheckWgt
	syntax varname [if] [iweight fweight pweight]
	
	marksample touse, strok
	if "`weight'"!="" {
		tempvar w
		qui gen double `w' `exp'
		sort `touse' `varlist'
		_crcchkw `varlist' `w' `touse'
		drop `w'
	}
end

program define GetFrailty, rclass
	local frailty `"`1'"'
	local shared `"`2'"'
	if `"`shared'"'!="" {
		local shared "shared "
	}
	if "`frailty'"=="" {
		di as err "must specify -frailty(gamma | invgauss)-"
		exit 198
	}
	
	local l = length("`frailty'")
	if bsubstr("gamma",1,max(1,`l')) == "`frailty'" {
		return local prog gomphet_glf
		return local frt "Gamma `shared'frailty"
		return local pred gomphet_gp 
	}
	else if bsubstr("invgaussian",1,max(1,`l')) == "`frailty'" {
		return local prog gomphet_ilf
		return local frt "Inverse-Gaussian `shared'frailty"
		return local pred gomphet_ip
	}
	else {
		di as err "unknown distribution frailty(`frailty')"
		exit 198
	}
end
		
program define SaveGrpInfo, eclass
	syntax varlist(min=2  max=2) [fw aw iw]
	tokenize `varlist' 
	local gvar `1'
	local touse `2'
	tempvar T w
	if "`weight'"=="fweight" {
		qui gen double `w' `exp' if `touse'
		qui by `touse' `gvar': gen long `T' = sum(`w'*`touse')  
		qui by `touse' `gvar': replace `T' = . if _n!=_N
		summarize `T', meanonly
	}
	else {
		qui by `touse' `gvar': gen `c(obs_t)' `T' = _N if _n==1 & `touse'
		summarize `T' if `touse', meanonly
	}
	est scalar N_g = r(N)
	est scalar g_min = r(min)
	est scalar g_max = r(max)
	est scalar g_avg = r(mean)
end

program define Display 
	syntax [, Level(cilevel) noCOEF noHEADer HR *]
	_get_diopts diopts, `options'
	if "`coef'"=="" {
		if `"`hr'"'!=`""' {
			local hr `"eform(Haz. Ratio)"'
                }

		else {local hr }

		if "`header'" == "" {
			di _n as txt /*
			*/ "Gompertz PH regression, " /* 
			*/ "`e(fr_title)'" " -- entry time `e(t0)'"
		}
		version 9: ///
		ml di, `header' `hr' level(`level') title(`e(title2)')	///
			nofootnote `diopts'
		_prefix_footnote
	}
end
exit
