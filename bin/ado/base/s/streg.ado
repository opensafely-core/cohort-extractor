*! version 6.4.9  28feb2017
program define streg, eclass byable(onecall) sort ///
		prop(st swml nohr hr tr tratio svyb svyj svyr mi bayes)
	version 6, missing
	local version : di "version " string(_caller()) ", missing:"

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`version' `BY' _vce_parserun streg, stdata noneedvarlist	///
		mark(STrata OFFset SHared ANCillary anc2 CLuster) 	///
		numdepvars(0) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"streg `0'"'
		exit
	}
	if replay() {
		if _by() { error 190 }
		syntax [, Distribution(string) *]
		if "`distrib'"=="" {
			if "`e(cmd2)'" != "streg" { error 301 } 
			if "`e(prefix)'" == "svy" {
				_prefix_display `0'
				exit
			}
			Display `0'
			exit 
		}
	}
	`version' `BY' Estimate `0'
	version 10: ereturn local cmdline `"streg `0'"'
end

program Estimate, eclass byable(recall)
	local vv : di "version " string(_caller()) ", missing:"
	version 6, missing
	st_is 2 analysis
	syntax [varlist(default=empty fv)] [fw pw iw aw] [if] [in] /*
		*/ [, CLuster(passthru) CMD Level(cilevel) /*
		*/ Distribution(string) /*documented abbrev. -dist- */ /*
		*/ TIme /* documented abbrev. -time- */  /* 
		*/ FRailty(string) SHared(varname) noHEADer /*
		*/ Robust TRatio noHR noSHow SCore(passthru) noCOEF /* 
		*/ STrata(passthru) ANCillary(passthru) /*
		*/ anc2(passthru) noCONstant VCE(passthru) /*
		*/ FORCESHARED sttewt(varname) moptobj(passthru) *]

	if "`tratio'" != "" { 
		local tr tr
	}

	/* undocumented: sttewt() - stteffects iweights, precedence	*/
	/*				over stset weights		*/
	_get_diopts diopts options, `options'
	_vce_parse, argopt(CLuster) opt(Robust OIM OPG) old	///
		: [`weight'`exp'], `cluster' `robust' `vce'
	local robust `r(robust)'
	local cluster `r(cluster)'
	if "`robust'`cluster'" == "" {
		local options `"`options' `r(vceopt)'"'
	}
	if _by() {
		_byoptnotallowed score() `"`score'"'
	}
	if "`weight'" != "" {
		di as err "weights must be stset"
		exit 101
	}
	if (`"`frailty'"'!="" & `"`shared'"'=="") {
		local fronly 1
	}
	else {
		local fronly 0
	}
	`vv' GetCmd `"`distrib'"' `"`frailty'"' `"`shared'"'
	local ecmd `s(cmd)'
	local frailty `s(frailty)'
	local shared `s(shared)'

	if "`shared'" != "" {
		if "`cluster'" != "" { 
			di as err "vce(cluster) not allowed with shared()"
			exit 198
		}
		if "`robust'" != "" {
			di as error "vce(robust) not allowed with shared()"
			exit 101
		}
		if "`weight'" == "pweight" {
			di as error "pweights not allowed with shared()"
			exit 101
		}
	}

	GetClass `ecmd'
	local class `s(class)'

	Opt_`class', `time' `tr' `hr'
	local etime `s(etime)'
	local otime `s(otime)'
	local rotime `s(rotime)'

	if `level' != $S_level {
		local otime `"level(`level') `otime'"'
		local rotime `"level(`level') `rotime'"'
	}


					/* obtain info from -st- 	*/
	local t0 "t0(_t0)"
	local d "dead(_d)"
	local id : char _dta[st_id]
	if "`sttewt'" != "" {
		local w [iweight=`sttewt']
		local wt iweight
	}
	else {
		local w  : char _dta[st_w]
		local wt : char _dta[st_wt]
	}

					/* identify estimation subsample */
	tempvar touse 
	st_smpl `touse' `"`if'"' "`in'" "`cluster'"
	markout `touse' `varlist'
	if _by() {
		version 7, missing
		local byind "`_byindex'"
		version 6, missing
		qui replace `touse'=0 if `byind'!=_byindex()
		local byind
	}
	_st_err_sharedgaps "`shared'" "`forceshared'" "`touse'"
	if (`fronly') {
		qui stdescribe
		if (`r(N_max)'>1) {
			local astxt as txt as smcl
di `astxt' "{p 0 9}Warning: multiple-record data detected in conjunction with "
di `astxt' "the {bf:frailty()} option.  If you have time-varying covariates, "
di `astxt' "the results may be biased.  You should consider specifying "
di `astxt' "option {bf:shared(`_dta[st_id]')} in addition to {bf:frailty()}."
di `astxt' "{p_end}"
		}
	}
					/* shut off eform if appropriate */

	if `"`strata'`ancillary'`anc2'"' != "" {
		local noeform noeform
	}

					/* determine command arguments 	*/

	if `"`wt'"'=="pweight" {
		local robust `"robust"'
	}

	if "`robust'"!="" & "`cluster'"=="" & "`id'"!="" {
		local cluster "`id'"
	}
	if "`cluster'"!="" {
		local cluster "cluster(`cluster')"
	}
	if "`frailty'"!="" {
		local frailty "frailty(`frailty')"
	}
	if "`shared'"!="" {
		local shared "shared(`shared')"
	}
	if "`constant'" != "" {
		local nvar : word count `varlist'
		if `nvar' == 0 {
			di as err "independent variables required " _c
			di as err "with noconstant option"
			exit 100
		}
	}
			
	st_show `show'

	*di

	if "`cmd'"!="" {
		di _n in gr `"-> `ecmd' _t `varlist' `w' `if' `in', "' /*
		*/ `"`etime' `otime' `robust' `cluster' `t0' `d' `score'"' /*
		*/ `"`frailty' `shared' `strata' `ancillary' `constant' `anc2' `options'"'
		exit
	}
	
	`vv'	`ecmd' _t `varlist' `w' if `touse', `frailty'  /* 
		*/ `shared' nocoef /* 
		*/`etime' `otime' `robust' `cluster' `t0' `d' `score' /*
		*/ `strata' `ancillary' `constant' `anc2' `options' `moptobj'

	if `class'==2 { 
		est local frm2 "hazard"
	}
	else if `class'==3 { 
		est local frm2 "time"
	}
	`vv' SetTitle
	st_hc `touse' 
	global S_E_cmd2 streg 		/* Double save */
	est local cmd2 streg 
	est hidden local marginsprop `e(marginsprop)' nochainrule
	if "`noeform'" != "" {          /* eform not appropriate */
		est hidden local noeform noeform
	}
	est local predict_sub `e(predict)'
	est local predict streg_p
	est hidden local marginsfootnote _multirecordcheck

	Display, `rotime' `header' `coef' `diopts'
end

program define Display
	syntax [, noHR TRatio noHEADer noCOEF Level(cilevel) *]
	if "`tratio'" != "" {
		local tr tr
	}
	_get_diopts diopts, `options'
	if "`e(frm2)'" == "hazard" {
		if "`tr'"!="" {
			di in red "tr not allowed" 
			exit 198
		}
		if "`hr'"=="" {
			local hr "hr"
		}
		else	local hr
	}
	else {
		if "`hr'"!="" {
			di in red "nohr not allowed"
			exit 198
		}
	}

	if "`header'"=="" {
		di 
		if "`e(shared)'" == "" {
			di in gr "`e(title)'"
			if `"`e(fr_title)'"' != "" {
				di in gr "`e(fr_title)'"
			}
			st_hcd
		}
		else {
			st_hcd_sh
		}
	}

	if "`coef'"=="" {
		di
		if "`e(noeform)'" != "" {
			`e(cmd)', level(`level') nohead `diopts'
			if "`tr'"!="" {
di as txt "Note: tr ignored; not appropriate with strata() or ancillary() options"
			}
		}
		else {
			`e(cmd)', `hr' `tr' level(`level') nohead `diopts'
			if "`hr'`tr'"!="" {
				capture di _b[_cons]
				if _rc {
di as txt "Note: No constant term was estimated in the main equation." 
				}
			}
		}
	}
	
	if e(converged_cons) == 0 & e(converged) == 1 {
		local astxt as txt as smcl
di `astxt' "{p 0 6 2 `s(width)'} Note: Constant-only model did not converge;" 
di `astxt' "Wald model test is reported." 
di `astxt' "{p_end}"		
	}	
	
end

program SetTitle, eclass
	version 9
	local vv = _caller()
	local cmd `e(cmd)'
	local l : length local cmd
	if "`e(frm2)'"=="hazard" {
		local metric "PH"
	}
	if "`e(frm2)'"=="time" {
		local metric "AFT"
	}
	if "`cmd'"==bsubstr("weibullhet",1,`l') | ///
	   "`cmd'"==bsubstr("weibull",1,`l') {
		ereturn local title "Weibull `metric' regression"
		exit
	}
	if "`cmd'"==bsubstr("ereghet",1,`l') | ///
	   "`cmd'"==bsubstr("ereg",1,`l') {
		ereturn local title "Exponential `metric' regression"
		exit
	}
	if "`cmd'"==bsubstr("lnormalhet",1,`l') | ///
	   "`cmd'"==bsubstr("lnormal",1,`l') {
		ereturn local title "Lognormal `metric' regression"
		exit
	}
	if "`cmd'"==bsubstr("llogistichet",1,`l') | ///
	   "`cmd'"==bsubstr("llogistic",1,`l') {
		ereturn local title "Loglogistic `metric' regression"
		exit
	}
	if "`cmd'"==bsubstr("gammahet",1,`l') | ///
	   "`cmd'"==bsubstr("gamma",1,`l') {
		ereturn local title "Generalized gamma `metric' regression"
		exit
	}
	if "`cmd'"==bsubstr("gompertzhet",1,`l') | ///
	   "`cmd'"==bsubstr("gompertz",1,`l') {
		ereturn local title "Gompertz `metric' regression"
		exit
	}
end

program define GetCmd, sclass
	args dist frailty shared
	local vv = _caller()
	if "`dist'"=="" {
		/* default command */ 
		if "`e(cmd2)'"=="streg" & "`e(fr_title)'"~="" {
			if "`frailty'"=="" {
				local frailty=lower(bsubstr("`e(fr_title)'",1,1))
			}
			if "`shared'"=="" {
				local shared "`e(shared)'"
			}
			sret local cmd "`e(cmd)'"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
			exit
		}

		if "`e(cmd2)'"=="streg" {
			if "`frailty'"!="" {
				local het het
			}
			sret local cmd "`e(cmd)'`het'"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
			exit
		}
		di as err "must specify " as input "distribution()"
		exit 198
	}

	if `"`shared'"' != "" & `"`frailty'"' == "" {
		local frailty "gamma"
		di as txt _n "Note: frailty(gamma) assumed."
	}
	local l = length("`dist'")
	if bsubstr("exponential",1,max(1,`l')) == "`dist'" { 
		if "`frailty'"=="" {
			sret local cmd "ereg"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
		}
		else {
			sret local cmd "ereghet"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
		}
		exit
	}
	local l = length("`dist'")
	if bsubstr("ereg",1,max(1,`l')) == "`dist'" { 
		if "`frailty'"=="" {
			sret local cmd "ereg"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
		}
		else {
			sret local cmd "ereghet"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
		}
		exit
	}
	if bsubstr("weibull",1,max(1,`l')) == "`dist'" { 
		if "`frailty'"=="" {
			sret local cmd "weibull"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
		}
		else {
			sret local cmd "weibullhet"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
		}
		exit
	}
	if bsubstr("lognormal",1,max(`l',4)) == "`dist'" | /*
 		*/ bsubstr("lnormal",1,max(`l',2)) == "`dist'" {
		if "`frailty'"=="" {
 			sret local cmd "lnormal"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
		}
		else {
 			sret local cmd "lnormalhet"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
		}
 		exit
	}
	if bsubstr("loglogistic",1,max(`l',4))  == "`dist'"  | /*
 		*/ bsubstr("llogistic",1,max(`l',2)) == "`dist'"  {
		if "`frailty'"=="" {
			sret local cmd "llogistic"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
		}
		else {
			sret local cmd "llogistichet"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
		}
 		exit
	}
	if bsubstr("gompertz",1,max(3,`l')) == "`dist'" {
		if "`frailty'"=="" {
			sret local cmd "gompertz"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
		}
		else {
			sret local cmd "gompertzhet"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
		}
 		exit
	}
	if `vv' < 14 {
 		local gg gamma
 		local m 3
 	}
	else {
 		local gg ggamma
 		local m 4
 	}
	if bsubstr("`gg'",1,max(`m',`l')) == "`dist'" {
		if "`frailty'"=="" {
			sret local cmd "gamma"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
		}
		else {
			sret local cmd "gammahet"
			sret local frailty "`frailty'"
			sret local shared "`shared'"
		}
		exit
	}
	if `vv' >= 14 & "`dist'"==bsubstr("gamma",1,max(3,`l')) {
 		di in red "unknown distribution: `dist'"
 		di in red "{p 4 4 2}For the generalized gamma " ///
 			"distribution, use {bf:distribution(ggamma)}.{p_end}"
 		exit 198
 	}
	di in red "unknown distribution: `dist'"
	exit 198 
end

program define GetClass, sclass
	args cmd 
	if "`cmd'"=="ereg" | "`cmd'"=="weibull"  | "`cmd'"=="weibullhet" /*
		*/  | "`cmd'"=="ereghet" {
		sret local class 1
		exit
	}
	if "`cmd'"=="gompertz" | "`cmd'"=="gompertzhet" {
		sret local class 2
		exit
	}
	if "`cmd'"=="lnormal" | "`cmd'"=="llogistic" | "`cmd'"=="gamma" {
		sret local class 3
		exit
	}
	if "`cmd'"=="lnormalhet" | "`cmd'"=="llogistichet" | /*
		*/ "`cmd'"=="gammahet" {
		sret local class 3
		exit
	}

	error 301
end

program define Opt_1, sclass
	syntax [, noHR TIme TR]
	if "`time'"!="" | "`tr'"!="" { 
		sret local etime /*nothing*/
		sret local otime `tr'
		sret local rotime `tr'
	}
	else {
		sret local etime hazard
		if "`hr'"=="" {
			sret local otime hr
			sret local rotime 
		}
		else {
			sret local otime /*nothing*/
			sret local rotime nohr
		}
	}
end

program define Opt_2, sclass
	syntax [, noHR]
	sret local etime /*nothing*/
	if "`hr'"=="" {
		sret local otime hr
		sret local rotime /*nothing*/
	}
	else {
		sret local otime
		sret local rotime nohr
	}
end
		

program define Opt_3, sclass
	syntax [, TIme TR]
	sret local etime /*nothing*/
	sret local otime `tr'
	sret local rotime `tr'
end
	
exit

Concerning GetClass returns 

        s(class)        1 ln time/ln hazard command
			2 ln hazard command 
                        3 ln time command 

A class-1 command: 
     1)  defaults to estimating results in ln time metric;
         a)  reports coefficients by default 
         b)  the -tr- option will report coefficients as ratios
     2)  the -hazard- option will estimate in the ln hazard metric; 
         a)  reports coefficients by default
         b)  the -hr- option will report coefficients as ratios;
     3)  A class-1 command fills in e(frm2) with "hazard" or "time" 
         depending on metric.
     4)  e(t0) contains t0 variable or 0
Examples are -weibull- and -ereg-

A class-2 command:
    1)  estimates in the ln hazard metric 
        a) by default, reports coefficients
        b) the -hr- option will report coefficients as ratios
    2)  A class-2 command does NOT fill in e(frm2)
    3)  e(t0) contains t0 variable or 0
Examples are -gompertz-

A class-3 command:
    1)  estimates in the ln time metric
        a) by default, reports coefficients 
        b) the -tr- option will report coefficients as ratios
    2)  A class-3 command does NOT fill in e(frm2)
    3)  e(t0) contains t0 variable or 0
Examples are -lnormal-.

-streg- works like this:

    1)  Estimates in the ln hazard metric if possible.
        a)  reports coefficients as hazard ratios by default
        b)  the -nohr- option will report coefficients

        c)  estimates in ln time metric if option -time- is specified
        d)  reports coefficients by default
        e)  reports ratios if option -tr-

    2)  If only ln hazard is allowed:
        a)  reports coefficients as hazard ratios by default
        b)  the -nohr- option will report coefficients

    3)  If only ln time is allowed:
        a)  may specify option -time- or not; it makes no difference
        d)  reports coefficients by default
        c)  reports ratios if option -tr-

So, options are -nohr-, -time-, and -tr-.  They map like this:

    Class 1:            Est options            Display options
         <none>         hazard                 hr
         nohr           hazard     
         time      
         tr                                    tr
	 time tr                               tr
    Class 2:
         <none>                                hr
         nohr
    Class 3:
         <none>
         time
         tr                                    tr
         time tr                               tr


