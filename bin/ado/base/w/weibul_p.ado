*! version 6.3.2  15oct2019
program define weibul_p, sort
	version 7, missing

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		if inlist("`e(user)'","weib_lf0","weib_lf") {
			confirm variable `e(dead)'
			global EREGd `e(dead)'
			confirm variable `e(depvar)'
			global EREGt `e(depvar)'
			confirm variable `e(t0)'
			global EREGt0 `e(t0)'
			global EREGa 0
			tempname hold
			version 9: _est hold `hold', copy restore
			if "`e(frm2)'" == "time" {
				ChangeUser weib1_lf
			}
			else	ChangeUser weib2_lf
			ml score `0'
		}
		else {
			confirm variable `e(dead)'
			global EREGd `e(dead)'
			confirm variable `e(depvar)'
			global EREGt `e(depvar)'
			confirm variable `e(t0)'
			global EREGt0 `e(t0)'
			global EREGa 0
			ml score `0'
		}
		macro drop EREG*
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
	if "`time'"~="" & "`lntime'"~="" {
		di as err /*
		*/ "options {bf:time} and {bf:lntime} may not be specified together"
		exit 198
	}
	local type /*
*/ "`xb'`index'`stdp'`time'`lntime'`hazard'`hr'`surv'`deviance'`csnell'`mgale'`csurv'`ccsnell'`cmgale'"

	local type2 "`type'`median'`mean'"

		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/


		/* Step 6:
			mark sample (this is not e(sample)).
		*/
	marksample touse

	if "`e(cmd2)'"=="stweib" | "`e(cmd2)'"=="streg" { 
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

	if _caller() < 7 {
		if "`type'"==""	{
			di as txt "(option {bf:time} assumed; predicted time)"
			local flag 6
		}
		if "`type'"=="lntime"	{
			local flag 7
		}
	}
	else {
		local flag 0
		if "`type'"==""         { local flag 1 }
		if "`type2'"=="median"   { local flag 2 }
		else if "`type2'"=="mean"     { local flag 3 }
		else if "`type2'"=="time"     { local flag 4 }
		else if "`type2'"=="lntime"   { local flag 5 }
		if `flag'==1 | 	`flag'==2 | `flag'==4 {
			local type="time"
			local median="median"
			di as txt /*
		*/ "(option {bf:median time} assumed; predicted median time)"
		}
		else if `flag'==5 {
			local type="lntime"
			local median="median"
			di as txt /*
	*/ "(option {bf:median lntime} assumed; predicted median log time)"
		}
		else if `flag'==3 {
			local type="time"
			local median
			local mean="mean"
			di as txt /*
		*/ "(option {bf:mean time} assumed; predicted mean time)"
		}
        } 

	if "`e(prefix)'" == "svy" {
		if inlist("`type'", "csnell", "mgale", "deviance", ///
				    "ccsnell", "cmgale") {
			di as err "{p 0 4 2}option `type' not allowed after "
			di as err " svy estimation{p_end}"
			exit 322
		}
	}

	tempvar sgn rgn aux_p
	qui _predict double `aux_p' if `touse', xb `offset' eq(#2)
	qui replace `aux_p'=exp(`aux_p') if `touse'
	qui gen double `sgn' = cond(e(frm2)=="time", 1, -1/`aux_p') if `touse'
	qui gen double `rgn' = cond(e(frm2)=="time", -`aux_p', 1) if `touse'

	if "`type'"=="time" & "`median'"=="median" {
		if "`type'"=="" {
		}
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset'
                gen `vtyp' `varn'=exp(`sgn'*`xb'+ log(log(2))/ `aux_p') /*
		*/  if `touse'
                label var `varn' "Predicted median `e(depvar)'"
                exit
	}

	if "`type'"=="xb" | "`type'"=="index" | "`type'"=="stdp" {
		_predict `vtyp' `varn' if `touse', `type' `offset' eq(#1)
		exit
	}
	if "`flag'"=="6" {
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset' eq(#1)
		gen `vtyp' `varn'=exp(`sgn'*`xb') if `touse'
		label var `varn' "Predicted `e(depvar)'"
		exit
	}
	if "`flag'"=="7" {
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset' eq(#1)
		gen `vtyp' `varn'=`sgn'*`xb' + digamma(1)/e(aux_p) if `touse'
		label var `varn' "Predicted ln(`e(depvar)')"
		exit
	}
	if "`type'"=="time" & "`mean'"=="mean" {
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset' eq(#1)
		gen `vtyp' `varn'=/*
			*/ exp(lngamma(1+1/`aux_p'))*exp(`sgn'*`xb') if `touse'
		label var `varn' "Predicted mean `e(depvar)'"
		exit
	}

        if  "`type'"=="lntime" & "`mean'"~="" {
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset' eq(#1)
		gen `vtyp' `varn'=`sgn'*`xb'+digamma(1)/ `aux_p' if `touse'
		label var `varn' "Predicted mean log `e(depvar)'"
		exit
	}
	if "`type'"=="lntime" & "`median'"=="median" {
		tempvar elnt
		qui weibul_p double `elnt' if `touse', time median
		gen `vtyp' `varn'= ln(`elnt') if `touse'
		label var `varn' "Predicted median log `e(depvar)'"
		exit
        }
	if "`type'"=="hr" {
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset' eq(#1)
		tempname b
		mat `b' = e(b)
		local name : colfullname `b'
		local depvar `e(depvar)'
		local cons : list posof "`depvar':_cons" in name
		if `cons' > 0 { 
		    gen `vtyp' `varn'=exp(`rgn'*(`xb'-_b[_cons])) if `touse'
		}
		else {
		    gen `vtyp' `varn'=exp(`rgn'*`xb') if `touse'
		}
		label var `varn' "Predicted hazard ratio"
		exit
	}


	if "`type'"=="hazard" {
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset' eq(#1)
		gen `vtyp' `varn'=( `aux_p'*`t'^( `aux_p'-1))*exp(`rgn'*`xb') /*
			*/ if `touse'
		label var `varn' "Predicted hazard"
		exit
	}

	if "`type'" =="surv" {
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset' eq(#1)
		gen `vtyp' `varn' = /*
			*/ exp( -exp(`rgn'*`xb')* `t'^`aux_p' ) / /*
			*/ exp( -exp(`rgn'*`xb')*`t0'^`aux_p' ) if `touse'
		if "`t0'"=="0" { 
			label var `varn' "S(`t')"
		}
		else	label var `varn' "S(`t'|`t0')"
		exit
	}

	if "`type'"=="csnell" {
		tempvar mg
		qui weibul_p double `mg' if `touse', mgale `offset'
		gen `vtyp' `varn' = (`d'!=0) - `mg' if `touse'
		if "`id'"!="" { local part "partial " }
		label var `varn' "`part'Cox-Snell residual"
		exit
	}

	if "`type'"=="mgale" { 
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset' eq(#1)
		gen `vtyp' `varn' = (`d'!=0) - exp(`rgn'*`xb')* /*
			*/ (`t'^ `aux_p'-`t0'^ `aux_p') if `touse'
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
			qui weibul_p double `cmg' if `touse', cmgale `offset' /*
				*/ `oos'
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
				weibul_p `vtyp' `varn' if `touse' & `es', /*
				*/ surv `offset' 
				exit
			}
			tempvar surv
			qui weibul_p double `surv' if `es', surv `offset'
			sort `es' `_dta[st_id]' `t'
			qui by `es' `_dta[st_id]': replace /*
				*/ `surv'=`surv'*`surv'[_n-1] if _n>1 & `es'
			gen `vtyp' `varn' = `surv' if `touse'
			label var `varn' "S(`t'|earliest `t0' for subj.)"
			exit
		}
		if "`type'"=="ccsnell" {
			if "`_dta[st_id]'" == "" {
				weibul_p `vtyp' `varn' if `touse' & `es', /*
				*/ csnell `offset' 
				exit
			}
			tempvar cs
			qui weibul_p double `cs' if `es', cs `offset'
			sort `es' `_dta[st_id]' `t'
			qui by `es' `_dta[st_id]': replace /*
				*/ `cs'=cond(_n==_N,sum(`cs'),.) if `es'
			gen `vtyp' `varn' = `cs' if `touse'
			label var `varn' "cum. Cox-Snell residual"
			exit
		}
		if "`type'"=="cmgale" {
			if "`_dta[st_id]'" == "" {
				weibul_p `vtyp' `varn' if `touse' & `es', /*
				*/ mgale `offset' 
				exit
			}
			tempvar mg
			qui weibul_p double `mg' if `es', mg `offset'
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

program ChangeUser, eclass
	version 9
	ereturn local user `0'
end
exit
