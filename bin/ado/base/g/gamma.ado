*! version 1.7.5  08aug2017
program define gamma, eclass byable(recall) prop(ml_score)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
	}
	else {
		local vv "version 8.1:"
		local mm d2
	}
	version 7.0, missing
	if replay() {
		if `"`e(cmd)'"' != "gamma" { error 301 } 
		if _by() { error 190 } 
		syntax [, Level(cilevel) noCOEF noHEADer TR *]
		if "`e(sigma)'"=="" {
			local ancilla 1
		}
		_get_diopts diopts, `options'
	}
	else {
		syntax [varlist(fv)] [if] [in] [fweight pweight iweight] /*
			*/ [, noCOEF CLuster(string) Dead(string)/*
			*/ DEBUG FROM(string) noHEADer MLMethod(string) /*
			*/ MLOpt(string) SHApe(real 1 ) noCONstant /*
			*/ Level(cilevel) noLOg OFFset(string) /*
			*/ Robust SCore(string) T0(string) SKIP TR /*
			*/ ANCillary(varlist fv) ANC2(varlist fv) /*
			*/ STrata(varname fv) moptobj(passthru) *]

		if _by() {
			_byoptnotallowed score() `"`score'"'
		}

		local fvops = "`s(fvops)'" == "true" | _caller() >= 11

		tokenize `varlist'
		local t `1'
		mac shift 
		local rhs `*'
		if "`strata'"~="" {
			if "`ancillary'"~="" | "`anc2'"~="" {
				noi di as err /*
				*/ "options strata() and ancillary()" /*
				*/ " may not be specified together"
				exit 198
			}
			if _caller() >= 15 {
				local rhs `rhs' i.`strata'
				local ancillary i.`strata'
				local anc2 i.`strata'
			}
			else {
				qui xi, prefix(_S) i.`strata'
				local rhs `rhs' _S*
				local ancillary _S*
				local anc2 _S*
			}
		}

		unab t0 : `t0', min(0) max(1) name(t0())
		unab dead: `dead', min(0) max(1) name(dead())
		unab offset: `offset', min(0) max(1) name(offset())

		if "`cluster'"!="" {
			unab cluster:  `cluster', max(1) name(cluster())
			local cluopt cluster(`cluster')
		}
		if "`from'" != "" { local iniopt init(`from') }
		if "`offset'" !="" { local offopt = "offset(`offset')" }
		_get_diopts diopts options, `options'
		mlopts options, `options'
		local coll `s(collinear)'

		if "`score'" != "" { 
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

		if "`weight'" != "" { 
			tempvar wv
			qui gen double `wv' `exp'
			local w [`weight'=`wv']
		}

		tempvar touse 
		mark `touse' `w' `if' `in'
		markout `touse' `t' `rhs' `dead' `t0' `offset'
		markout `touse' `cluster', strok

/*
		preserve
		quietly keep if `touse'
*/

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

		global EREGd `dead'
		global EREGt0 `t0'
		*global S_K = `shape'  /* Keep for reference if 2 parameters */
		
		if _caller() < 15 {
			local lnsig ln_sig
		}
		else {
			local lnsig lnsigma
		}
		if `"`ancillary'`anc2'"' == "" {
			local dip diparm(`lnsig', exp label(sigma))
			if _caller() >= 15 {
				local fparm1 ", freeparm"
				local fparm2 ", freeparm"
			}
		}
		else if "`ancillary'" != "" & "`anc2'" == "" {
			if _caller() >= 15 {
				local fparm2 ", freeparm"
			}
		}
		else if "`ancillary'" == "" & "`anc2'" != "" {
			if _caller() >= 15 {
				local fparm1 ", freeparm"
			}
		}

		if "`log'"!="" { local nlog="*" }
		tempvar mysamp num den
		tempname b f V  g b0 bc0
		quietly { 
			tempvar swt
			if "`weight'"=="aweight" | "`weight'"=="pweight" {
				tempvar wvn
				summ `wv' if `touse', meanonly 
				gen double `wvn' = `wv'/r(mean)
				local wvngen 1
				qui sum `wvn', meanonly 
				gen double `swt'=r(sum)
			}
			else if "`weight'"!="" {
				local wvn `wv' 
				qui sum `wvn', meanonly 
				gen double `swt'=r(sum)
			}
			else {
				local wvn 1
				count if `touse'
				gen `swt'=r(N)
			}
			gen double `num' = `wvn'*ln(`t') if `touse' & `dead'
			replace `num' = sum(`num')
			global EREGa = `num'[_N]/`swt'
			drop `num' `sw'
			if "`wvngen'"!=""  { drop `wvn' }
		}
		if "`constant'"!="" {
			local skip = "skip"
			`nlog' di as txt "Fitting full model:"
		}
		if "`rhs'" != "" & "`skip'"=="" { 
			summ `dead' if `touse', meanonly
			local mysumd = r(sum)
			summ `t' if `touse', meanonly
			local mysumt = r(sum)
			local cval = -ln(`mysumd'/`mysumt')
			if "`offset'"!="" {
				summ `offset' if `touse', meanonly
				local cval = `cval' - r(mean)
			}
			`nlog' di ""
			`nlog' di as txt "Fitting constant-only model:"
			`vv' ///
			ml model `mm' gamma_d2 (`t': `t'=, `offopt') /*
			*/ (`lnsig': `ancillary' `fparm1') /*
			*/ (kappa: `anc2' `fparm2') `w' /*
			*/ if `touse', /*
			*/ init(_cons=`cval' /`lnsig'=0 /kappa=1) /*
			*/ missing collin nopreserve wald(0) `mlopt' /*
			*/ max noout `log' `options' search(off) `robust' /*
			*/ nocnsnotes `negh'
			
			local converged_cons = e(converged)
			tempname b0
			if `converged_cons' == 0 {
				mat `b0' = e(b)
				if "`from'" == "" {
					local iniopt "init(`b0', skip)"
				}	
			}	
			else {
				local cont continue
			}
			`nlog' di ""
			`nlog' di as txt "Fitting full model:"
		}
		else {
			
			local cont wald(1)
			if "`iniopt'"=="" {
				if "`constant'"=="" { 
					summ `dead' if `touse', meanonly
					local mysumd = r(sum)
					summ `t' if `touse', meanonly
					local mysumt = r(sum)
					local cval = -ln(`mysumd'/`mysumt')
					local iniopt= /*
				    */ "init(_cons=`cval' /`lnsig'=1 /kappa=1)"
				}
				else {
					local iniopt= /*
				      */ "init( /`lnsig'=1 /kappa=1)"
				}
			}
		}
		
		global GLIST : all globals "EREG*"
		
		`vv' ///
		ml model `mm' gamma_d2 /*
			*/ (`t': `t'=`rhs' , `offopt' `constant' )  /*
			*/ (`lnsig': `ancillary' `fparm1') /*
			*/ (kappa: `anc2' `fparm2') `w' /*
			*/ if `touse', `cont' noout /*
			*/ `robust' `cluopt' `scopt' `iniopt' `mlopt' /*
			*/ missing collin nopreserve /*
			*/ max search(off) `log' `dip' `options' `negh' /*
			*/ `moptobj'
		if "`e(wtype)'" != "" { 
			est local wexp "`exp'"
		}
		cap est hidden scalar converged_cons = `converged_cons'
		if _caller() < 15 {
			est local title2 "accelerated failure-time form"
		}
		est local predict gamma_p
		est local t0 `t0'
		est local dead `sdead'

		if `"`ancillary'`anc2'"' == "" {
			est scalar k_aux = 2
		}
		if "`ancillary'" =="" & "`ancilla'" =="" {
			local bg "_b[/`lnsig']"
			local bb "_b[/kappa]"
			est scalar sigma = exp(`bg')
			est scalar kappa = `bb'
			est local stcurve="stcurve"
		}
		if "`strata'" != "" {
			est local strata = "`strata'"
		}
		est local cmd gamma 

		global S_E_cmd gamma
	}
	global EREGw
	global EREGd
	global EREGt
	global EREGt0
	global EREGa

	if "`coef'"=="" {
		if `"`tr'"'!=`""' {
			local hr `"eform(Time Ratio)"'
                }
		if "`header'" == "" {
	     	    di _n as txt "Gamma AFT regression -- entry time `e(t0)'"
		}
		version 9:	///
		ml di, `header' `hr' level(`level') title(`e(title2)') ///
			`diopts'
	}
end
