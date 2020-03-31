*! version 1.4.3  01feb2017
program define ereghet, eclass byable(recall) sort prop(ml_score)
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
		if `"`e(cmd)'"' != "ereghet" { error 301 } 
		if _by() { error 190 }
		Display `0'
		error `e(rc)'
		exit
	}
	
	syntax [varlist(fv)] [if] [in] [fweight pweight iweight] /*
		*/ [, noCOEF FRailty(string) SHared(varname)/*
		*/ CLuster(varname) Dead(varname numeric)/*
		*/ DEBUG FROM(string) noHEADer MLMethod(string) /*
		*/ noCONstant Level(cilevel) noLOg /*
		*/ noLRtest HAzard OFFset(varname numeric) /*
		*/ Robust SCore(string) T0(varname numeric) SKIP TR HR /*
		*/ moptobj(passthru) *]
	if _by() {
		_byoptnotallowed score() `"`score'"'
	}

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	tokenize `varlist'
	local t `1'
	mac shift 
	local rhs `*'

	if "`cluster'"!="" {
		local cluopt cluster(`cluster')
		if "`shared'"!="" { 
			di as err "cluster() not allowed with shared()"
			exit 198
		}
	}
	
	if "`from'" != "" { local iniopt init(`from') }
	if "`mlmethod'" == "" { local mlmethod = "`mm'" }

	if "`shared'"!="" & "`robust'"!="" {
		di as error "robust/pweights not allowed with shared()"
		exit 101
	}

	_get_diopts diopts options, `options'
	mlopts options, `options'
	local coll `s(collinear)'
	local cns `s(constraints)'

	GetFrailty, frailty(`frailty') shared(`shared') hazard(`hazard')
	local mlprog `r(prog)'
	local frtitle `r(frt)'
	local pred `r(pred)'

	if "`shared'"!="" {
		local mlprog "`mlprog'_sh"
		if "`mlmethod'" == "e2" {
			local mlmethod d2
		}
	}
		
	if "`hazard'"!="" {
                if "`tr'"!="" {
                        di as err "tr invalid with hazard option"
                        exit 198
                }
        }
        else if "`hr'"!="" {
                local hazard "hazard"
	}

	if "`score'" != "" { 
		if "`shared'"!="" {
                        di as err "score() not allowed with shared() "
                        exit 198
		}
		local n : word count `score'
		if `n'==1 & bsubstr("`score'",-1,1)=="*" { 
			local score = /*
			*/ bsubstr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2 
			local n 2
		}
		if `n' != 2 { 
			di as err /*
		*/ "score() invalid:  two new variable names required"
			exit 198 
		}
		confirm new var `score'
		local scopt "score(`score')"
	}

	if "`offset'" != "" {
		local offopt offset(`offset')
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
		`nlog' di as txt _n "Fitting exponential model:"

		/* Note: I estimate in the PH metric, so I use haz option 
			 here for good starting values. 
		   Update: not anymore, all models are now fit in their metric,
		     obtaining starting values accordingly.   
		*/

		`vv' ///
		qui ereg `t' `rhs' `w' if `touse', nocoef `hazard' /*
		*/ dead(`dead') `topt'  `constant' `offopt' `mlopts'

		tempname bp
		mat `bp' = e(b)
		
		if "`lrtest'"=="" {
			tempname llc
			scalar `llc' = e(ll)
		}
	}

	else if `"`from'"'=="" { /*nolrtest*/
		`vv' ///
		`nlog' di as txt _n "Fitting exponential model:"
		qui ereg `t' `rhs' `w' if `touse', nocoef `hazard' /*
		*/ dead(`dead') `topt' `constant' `offopt' `mlopts' 		
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
		local lntheta ln_the
	}
	else {
		local lntheta lntheta
	}
	
	if "`shared'"!="" {
		global EREG_by "`touse' `shared'"
		global EREG_sh "`shared'"
	}
	
	if "`rhs'" != "" & "`skip'"=="" { 
		`nlog' di ""
		`nlog' di as txt "Fitting constant-only model:"
		`vv' ///
		ml model `mlmethod' `mlprog' (`t': `t'=, `offopt') /*
			*/ /`lntheta' /* 
			*/ `w' if `touse', /*
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
		*/ (`t': `t'=`rhs' ,  `constant' `offopt') /*
		*/ /`lntheta' `w' if `touse', `cont' noout /*
		*/ `robust' `cluopt' `scopt' `iniopt' `mlopts' /*
		*/ missing collin nopreserve /*
		*/ max search(quietly) `log' `options' /*
		*/ diparm(`lntheta', exp label(theta)) `negh' /*
		*/ `moptobj'

	if "`e(wtype)'" != "" {
		est local wexp `"`exp'"'
	}
	if "`hazard'"=="" {
		if _caller() < 15 {
			est local title2 "accelerated failure-time form"
		}
		est local frm2 "time"
	}
	else {
		if _caller() < 15 {
			est local title2 "log relative-hazard form"
		}
		est local frm2 "hazard"
	}
	est local fr_title `frtitle'
	est local predict `pred'
	est local shared `shared'
	est local t0 "`t0'"
	est local dead `sdead'
	est local shared `realsh'
	est scalar theta = exp(_b[/`lntheta'])
	est local stcurve stcurve
	if "`shared'" != "" {
		SaveGrpInfo `shared' `touse' `w'
		if "`warn'"!="" {
			est local sh_warn sh_warn
		}
	}
	cap est hidden scalar converged_cons = `converged_cons'

	if `"`lrtest'"'=="" & `"`from'"'==""{ 
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
	est scalar k_aux = 1
	est local footnote streghet_footnote 
	est local cmd ereghet 
	global S_E_cmd ereghet
	macro drop EREGd EREGt EREGt0 EREG_by EREG_sh
	
	Display, level(`level') `coef' `header' `tr' `hr' `diopts'
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

	syntax, frailty(string) [ shared(string) hazard(string) ]
	
	if `"`shared'"'!="" {
		local shared "shared "
	}
	if "`frailty'"=="" {
		di as err "must specify -frailty(gamma | invgauss)-"
		exit 198
	}
	
	local l = length("`frailty'")
	if bsubstr("gamma",1,max(1,`l')) == "`frailty'" {
		if "`hazard'" != "" {
			return local prog ereghet_glf
		}
		else {
			return local prog ereghet2_glf
		}	
		return local frt "Gamma `shared'frailty"
		return local pred ereghet_gp	
	}
	else if bsubstr("invgaussian",1,max(1,`l')) == "`frailty'" {
		if "`hazard'" != "" {
			return local prog ereghet_ilf
		}
		else {
			return local prog ereghet2_ilf
		}	
		return local frt "Inverse-Gaussian `shared'frailty"
		return local pred ereghet_ip	
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
	if "`e(frm2)'"=="hazard" {
                local options "HR"
        }
        else    local options "TR"

	syntax [, Level(cilevel) noCOEF noHEADer `options' *]
	if "`coef'"=="" {
		_get_diopts diopts, `options'
	        if "`hr'"!="" {
                        local eform "eform(Haz. Ratio)"
	        }
        	else if "`tr'"!="" {
                        local eform "eform(Time Ratio)"
                }

		if "`header'" == "" {
			if `"`e(frm2)'"'=="time" {
				local metric "AFT"
			}
			else local metric "PH"

			di _n as txt /*
			*/ "Exponential `metric' regression, " /* 
			*/ "`e(fr_title)'" " -- entry time `e(t0)'"
		}
		version 9: ///
		ml di, `header' `eform' level(`level')	///
			title(`e(title2)') nofootnote `diopts'
		_prefix_footnote
	}
end
exit
