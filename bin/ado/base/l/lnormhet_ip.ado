*! version 1.6.1  15oct2019
program define lnormhet_ip, sort
	version 7, missing

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		if "`e(shared)'" != "" {
			di as err ///
"option {bf:scores} is not allowed with shared frailty"
			exit 322
		}
		confirm variable `e(dead)'
		global EREGd `e(dead)'
		confirm variable `e(depvar)'
		global EREGt `e(depvar)'
		confirm variable `e(t0)'
		global EREGt0 `e(t0)'
		ml score `0'
		macro drop EREG*
		exit
	}

	syntax newvarname [if] [in] [, ALPHA1 UNCONDitional *]
	local 0 `typlist' `varlist' `if' `in', `options'
	if "`alpha1'"!="" & "`unconditional'"!="" {
 		di as error /*
*/ "options {bf:alpha1} and {bf:unconditional} may not be specified together"
		exit 198
	}
	if "`alpha1'`unconditional'"=="" {
		if "`e(shared)'"!="" {local alpha1 alpha1}
		else {local unconditional unconditional}
local disclaim `"di as txt "(option {bf:`alpha1'`unconditional'} assumed)""'
	}
	tempname theta sigma b
	mat `b' = e(b)
	local freeparm : colnfreeparms `b'
	if `freeparm' == 0 {
		scalar `theta' = exp(_b[/ln_the])
		scalar `sigma' = exp(_b[/ln_sig])
	}
	else {
		scalar `theta' = exp(_b[/lntheta])
		scalar `sigma' = exp(_b[/lnsigma])
	}
	if "`alpha1'"!="" | `theta' < exp(-20) {
		`disclaim'
		lnorma_p `0'
		exit
	}
		/* Step 1:
			place command-unique options in local myopts
			Note that standard options are
			LR:
				Index XB Cooksd Hat 
				REsiduals RSTAndard RSTUdent
				STDF STDP STDR noOFFset
			SE:
				Index XB STDP noOFFset
		*/

	local myopts /*
*/ "XB Index STDP Time LNTime HAzard HR Surv DEViance CSnell MGale CSUrv CCSnell CMgale OOS MEDian MEAN"

		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/

	_pred_se "`myopts'" `0'
	if `s(done)' { exit }
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'

		/* Step 3:
			Parse your syntax.
		*/

	syntax [if] [in] [, `myopts' noOFFset]

		/* Step 4:
			Concatenate switch options together
		*/
	if "`median'"~="" & "`mean'"~="" {
		di as err /*
		*/ "options {bf:median} and {bf:mean} may not be specified together"
		exit 198
	}
	if "`mean'"~="" {
		di as err /*
*/ "unconditional mean predictions for frailty models currently unavailable"
		exit 198
	}

	local type /*
*/ "`xb'`index'`stdp'`time'`lntime'`hazard'`hr'`surv'`deviance'`csnell'`mgale'`csurv'`ccsnell'`cmgale'"

		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/

		/* Step 6:
			mark sample (this is not e(sample)).
		*/

	marksample touse

	if "`e(cmd2)'"=="streg" { 
		st_is 2 full
		local is_st yes
		local id `_dta[st_id]'
		local t  `_dta[st_t]'
		local t0 `_dta[st_t0]'
		local d  `_dta[st_d]'
		qui replace `touse'=0 if _st==0
	}
	else {
		local t `e(depvar)'
		local t0 `e(t0)'
		local d `e(dead)'
	}

	if "`e(prefix)'" == "svy" {
		if inlist("`type'", "csnell", "mgale", "deviance", ///
				    "ccsnell", "cmgale") {
			di as err "{p 0 4 2}option {bf:`type'} not allowed after"
			di as err " svy estimation{p_end}"
			exit 322
		}
	}
	`disclaim'

	if "`type'"=="" | "`type'"=="time" {
		if "`type'"=="" | "`median'"=="" {
			di as txt /*
			*/ "(option {bf:median time} assumed; predicted median time)"
		}
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset'
		tempname cc
		scalar `cc' = invnorm(-expm1(0.5/`theta'*(1-(1-`theta'* /*
			*/ ln(0.5))^2)))
		gen `vtyp' `varn'=exp(`sigma'*`cc'+`xb') if `touse'
		label var `varn' "Predicted median `e(depvar)'"
		exit
	}

	if "`type'"=="lntime" {
		if "`median'"=="" {
			di as txt /*
*/ "(option {bf:median lntime} assumed; predicted median log time)"
		}
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset'
		tempname cc
		scalar `cc' = invnorm(-expm1(0.5/`theta'*(1-(1-`theta'* /*
			*/ ln(0.5))^2)))
		gen `vtyp' `varn'= `sigma'*`cc'+`xb' if `touse'
		label var `varn' "Predicted median ln(`e(depvar)')"
		exit
	}

	if "`median'"!="" {                 /* I've gone too far */
		di as err "option {bf:median} invalid"
		exit 198
	}

	if "`type'"=="xb" | "`type'"=="index" | "`type'"=="stdp" {
		_predict `vtyp' `varn' if `touse', `type' `offset'
		exit
	}
	
	if "`type'"=="hr" {
		di as err /*
*/ "Hazard ratios only available for those models with a natural"
		di as err /*
*/ "proportional-hazards parameterization"
		exit 498
	}

	if "`type'"=="hazard" {
		tempvar xb ff kk
		qui _predict double `xb' if `touse', xb `offset'
		qui gen double `kk' = (ln(`t')-`xb')/`sigma' if `touse'
		qui gen double `ff'= /*
		*/ normd(`kk')/(`t'*`sigma') if `touse'
		qui replace `ff'= /*
		   */ `ff'/(1-norm(`kk')) if `touse'
		qui replace `ff'=`ff'/sqrt(1-2*`theta'*ln1m(norm(`kk'))) /*
		   */ if `touse'
		gen `vtyp' `varn'= `ff' if `touse'
		label var `varn' "Predicted hazard"
		exit
	}

	if "`type'" =="surv" {
		tempvar xb ff ff0
		qui _predict double `xb' if `touse', xb `offset'
		qui gen double `ff'= 1-norm((ln(`t')-`xb')/`sigma') /*
			*/ if `touse'
		qui gen double `ff0'=1-norm((ln(`t0')-`xb')/`sigma') /*
			*/ if `t0'>0 & `touse'
		qui replace `ff' = exp((1-sqrt(1-2*`theta'*ln(`ff')))/ /*
			*/ `theta') if `touse'
		qui replace `ff0' = exp((1-sqrt(1-2*`theta'*ln(`ff0')))/ /*
			*/ `theta') if `t0'>0 & `touse'
		qui replace `ff' = `ff'/`ff0' if `t0'>0 & `touse'
		gen `vtyp' `varn' = `ff' if `touse'
		if "`t0'"=="0" { 
			label var `varn' "S(`t')"
		}
		else	label var `varn' "S(`t'|`t0')"
		exit
	}

	if "`type'"=="csnell" {
		tempvar mg
		qui predict double `mg' if `touse', mgale `offset' uncond
		gen `vtyp' `varn' = (`d'!=0) - `mg' if `touse'
		if "`id'"!="" { local part "partial " }
		label var `varn' "`part'Cox-Snell residual"
		exit
	}

	if "`type'"=="mgale" { 
		tempvar xb ff
		qui _predict double `xb' if `touse', xb `offset'
		qui gen double `ff'= /*
		*/ (`d'!=0)+(1/`theta')* /*
		*/ (1-sqrt(1-2*`theta'* /*
		*/ ln1m(norm((ln(`t')-`xb')/`sigma')))) if `touse'
		qui replace /*
		*/ `ff'=`ff'-(1/`theta')* /*
		*/ (1-sqrt(1-2*`theta'*ln1m(norm((ln(`t0')-`xb') /*
		*/ /`sigma')))) if `t0'>0 & `touse'
		gen `vtyp' `varn' = `ff' if `touse' 
		if "`id'"!="" { local part "partial " }
		label var `varn' "`part'Martingale-like resid."
		exit
	}

		/* Step 7:
			handle options that take argument one at a time.
			Comment if restricted to e(sample).
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/

		/* Step 8:
			handle switch options that can be used in-sample or 
			out-of-sample one at a time.
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/

	if "`is_st'"=="yes" {
		if "`type'"=="deviance" {
			tempvar cmg 
			qui predict double `cmg' if `touse', cmgale `offset' /*
				*/ `oos' uncond
			gen `vtyp' `varn' = sign(`cmg')*sqrt( /* 
			*/ -2*(`cmg' + (`d'!=0)*(ln((`d'!=0)-`cmg')))) /*
			*/ if `touse'
			label var `varn' "deviance residual"
			exit
		}

		if "`oos'"=="" {
			tempvar es
			qui gen byte `es' = e(sample)
		}
		else	local es "`touse'"

		if "`type'"=="csurv" {
			if "`_dta[st_id]'" == "" {
				qui predict `vtyp' `varn' if `touse' & `es', /*
				*/ surv `offset' uncond
				exit
			}
			tempvar surv
			qui predict double `surv' if `es', surv `offset' uncond
			sort `es' `_dta[st_id]' `t'
			qui by `es' `_dta[st_id]': replace /*
				*/ `surv'=`surv'*`surv'[_n-1] if _n>1 & `es'
			gen `vtyp' `varn' = `surv' if `touse'
			label var `varn' "S(`t'|earliest `t0' for subj.)"
			exit
		}
		if "`type'"=="ccsnell" {
			if "`_dta[st_id]'" == "" {
				qui predict `vtyp' `varn' if `touse' & `es', /*
				*/ csnell `offset' uncond
				exit
			}
			tempvar cs
			qui predict double `cs' if `es', cs `offset' uncond
			sort `es' `_dta[st_id]' `t'
			qui by `es' `_dta[st_id]': replace /*
				*/ `cs'=cond(_n==_N,sum(`cs'),.) if `es'
			gen `vtyp' `varn' = `cs' if `touse'
			label var `varn' "cum. Cox-Snell residual"
			exit
		}
		if "`type'"=="cmgale" {
			if "`_dta[st_id]'" == "" {
				qui predict `vtyp' `varn' if `touse' & `es', /*
				*/ mgale `offset' uncond
				exit
			}
			tempvar mg
			qui predict double `mg' if `es', mg `offset' uncond
			sort `es' `_dta[st_id]' `t'
			qui by `es' `_dta[st_id]': replace /*
				*/ `mg'=cond(_n==_N,sum(`mg'),.) if `es'
			gen `vtyp' `varn' = `mg' if `touse'
			label var `varn' "cum. Martingale-like resid."
			exit
		}
	}

		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/

	* qui replace `touse'=0 if !e(sample)

		/* Step 10.
			Issue r(198), syntax error.
			The user specified more than one option
		*/
	error 198
end
