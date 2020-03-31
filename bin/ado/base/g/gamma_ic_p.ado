*! version 1.0.5  25oct2017
program define gamma_ic_p, sort
	version 15

	syntax [anything] [if] [in] [, SCores * ]

	marksample touse

	tokenize "`e(depvar)'"
	local ltime `1'
	local rtime `2'
	local epsilon `e(eps_str)'
	local dep_title "interval(`ltime', `rtime')"

	tempvar fail
	qui gen byte `fail' = .
	/* uncensored */
	qui replace `fail' = 1 if (`rtime'-`ltime')<=`epsilon' & `touse'
	/* right-censored */ 
	qui replace `fail' = 2 if `rtime' >= . & `touse'
	/* left-censored */
	qui replace `fail' = 3 if (`ltime' >= . | `ltime'==0) & `touse'
	/* interval-censored */
	qui replace `fail' = 4 if (`rtime'-`ltime')>`epsilon' & ///
			`fail'!=3  & `fail' != 2 & `touse'

	if `"`scores'"' != "" {
		tempname hold
		_est hold `hold', copy restore
		ChangeDepvar `ltime' `rtime' `fail'

		ml score `anything' `if' `in', missing
	
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
	local myopts ///
"XB STDP Time LNTime HAzard HR Surv CSnell MGale MEDian MEAN"
	local myopts "`myopts' ADJUSTed OOS LOWer UPper"

		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
	_pred_se_ic "`myopts'" `0'
	if `s(done)'  exit 
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'
	local nvar `s(nvar)'

		/* Step 3:
			Parse your syntax.
		*/
	syntax [if] [in] [, `myopts' noOFFset]


		/* Step 4:
			Concatenate switch options together
		*/
	if "`median'"~="" & "`mean'"~="" {
		di as err /*
		*/ "options median and mean may not be specified together"
		exit 198
	}
	if "`time'"~="" & "`lntime'"~="" {
		di as err /*
		*/ "options time and lntime may not be specified together"
		exit 198
	}

	local type ///
	"`xb'`stdp'`time'`lntime'`hazard'`hr'`surv'`csnell'`mgale'"
	local type2 "`type'`mean'`median'"


		/* Step 5:
			setup flag
		*/

	local flag 0
	if "`type'"==""          local flag 1 
	if "`type2'"=="median"    local flag 2 
	else if "`type2'"=="mean"      local flag 3 
	else if "`type2'"=="time"      local flag 4 
	else if "`type2'"=="lntime"    local flag 5 
	if `flag'==1 | 	`flag'==2 | `flag'==4 {
		local type="time"
		local median="median"
		di as txt ///
	"(option {bf:median time} assumed; predicted median time)"
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
		di as txt ///
		"(option {bf:mean time} assumed; predicted mean time)"
	}

	if "`e(prefix)'" == "svy" {
		if inlist("`type'", "csnell", "mgale") {
			di as err "{p 0 4 2}option `type' not allowed after "
			di as err " svy estimation{p_end}"
			exit 322
		}
	}

	tempvar sigma kappa
	qui _predict double `sigma' if `touse', xb eq(#2)
	qui replace `sigma'=exp(`sigma') if `touse'
	qui _predict double `kappa' if `touse', xb eq(#3)

	if "`type'"=="time" & "`median'"=="median" {
		tempvar xb sgn
		qui _predict double `xb' if `touse', xb `offset' eq(#1)
		qui gen double `sgn'=cond( `kappa'<0,-1,1) if `touse'
		gen `vtyp' `varn'= /*
		*/ invgammap((1/((`kappa')^2)),0.5)*((`kappa')^2) if `touse'
		qui replace `varn'= `sgn'*log(`varn')*`sigma' /*
		*/ +(abs(`kappa')*`xb') 
		qui replace `varn'= exp(`varn'/(abs(`kappa'))) if `touse'
		label var `varn' "Predicted median for `dep_title'"
		exit
	}

	if "`type'"=="xb" | "`type'"=="stdp" {
		_predict `vtyp' `varn' if `touse', `type' `offset' eq(#1)
		exit
	}

        if  "`type'"=="lntime" & "`mean'"~="" {
		tempvar xb sgn nkappa
		qui gen double `sgn'=cond( `kappa'<0,-1,1)		
		qui gen double `nkappa'=abs( `kappa') if `touse'
		qui _predict double `xb' if `touse', xb `offset' eq(#1)
		gen `vtyp' `varn'=`sgn'*(`xb' /*
		*/ +  `sigma'/ `nkappa'*(digamma(`nkappa'^-2) /*
		*/ -log(`nkappa'^-2))) if `touse'
		label var `varn' "Predicted mean log for `dep_title'"
		exit
	}
	if "`type'"=="lntime" & "`median'"=="median" {
		tempvar elnt
		qui gamma_ic_p double `elnt' if `touse', time median 
		gen `vtyp' `varn'= ln(`elnt') if `touse'
		label var `varn' "Predicted median log for `dep_title'"
		exit
	}
	if "`type'"=="time" & "`mean'"=="mean" {
		tempvar xb aa bb cc
		qui _predict double `xb' if `touse', xb `offset' eq(#1)
		capture assert `kappa'>0 if `touse'
		if _rc {
			di as txt "note: mean time prediction not available" _c
			di as txt " when estimated kappa < 0;"
			di as txt "      one or more observations set to missing"	
		}
    		qui gen double `aa' = cond(`kappa'>0,(1/`kappa')^2,.) if `touse'
                qui gen double `bb' = `aa'^(-`sigma'*sqrt(`aa'))*exp(`xb') /*
			*/ if `touse'
    		qui gen double `cc' = `sigma'*sqrt(`aa') /*
			*/ if `touse'
		gen `vtyp' `varn' = `bb'*exp(lngamma(`aa'+`cc') - /*
			*/ lngamma(`aa')) if `touse'
		label var `varn' "Predicted mean for `dep_title'"
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
		tempvar xb ff z s sgn l
		qui gen double `sgn'=cond( `kappa'<0,-1,1) if `touse'
		qui gen double `l'= (abs(`kappa'))^(-2)	if `touse'
		qui _predict double `xb' if `touse', xb `offset' eq(#1)
		if "`lower'" != "" {
			qui gen double `z'= ///
				`sgn'*(ln(`ltime')-`xb')/ `sigma' if `touse'
                	qui gen double `s'= ///
				gammap(`l',`l'*exp(`z'/sqrt(`l'))) if `touse'
                	qui replace `s'=cond(`sgn'==1,1-`s',`s') if `touse'

			qui gen double `ff'=((`l'-0.5)*ln(`l')) /*
		   	*/  + (`z'*sqrt(`l'))-`l'*exp(`z'/sqrt(`l')) /*
		   	*/ -lngamma(`l') - ln(`ltime'* `sigma') if `touse'
			qui replace `ff'= exp(`ff') if `touse'

			gen `vtyp' `varn'= `ff'/`s' if `touse'
			label var `varn' "Predicted hazard for `ltime'"
			exit
		}
		if "`upper'" != "" {
			qui gen double `z'= ///
				`sgn'*(ln(`rtime')-`xb')/ `sigma' if `touse'
                	qui gen double `s'= ///
				gammap(`l',`l'*exp(`z'/sqrt(`l'))) if `touse'
                	qui replace `s'=cond(`sgn'==1,1-`s',`s') if `touse'

			qui gen double `ff'=((`l'-0.5)*ln(`l')) /*
		   	*/  + (`z'*sqrt(`l'))-`l'*exp(`z'/sqrt(`l')) /*
		   	*/ -lngamma(`l') - ln(`rtime'* `sigma') if `touse'
			qui replace `ff'= exp(`ff') if `touse'

			gen `vtyp' `varn'= `ff'/`s' if `touse'
			label var `varn' "Predicted hazard for `rtime'"
			exit
		}
		if `nvar' == 1 {
			qui gen double `z'= ///
				`sgn'*(ln(`ltime')-`xb')/ `sigma' if `touse'
                	qui gen double `s'= ///
				gammap(`l',`l'*exp(`z'/sqrt(`l'))) if `touse'
                	qui replace `s'=cond(`sgn'==1,1-`s',`s') if `touse'

			qui gen double `ff'=((`l'-0.5)*ln(`l')) /*
		   	*/  + (`z'*sqrt(`l'))-`l'*exp(`z'/sqrt(`l')) /*
		   	*/ -lngamma(`l') - ln(`ltime'* `sigma') if `touse'
			qui replace `ff'= exp(`ff') if `touse'

			gen `vtyp' `varn'= `ff'/`s' if `touse'
			label var `varn' "Predicted hazard for `ltime'"
			exit
		}
		else {
			tokenize `varn'
			local var1 `1'
			local var2 `2'

			qui gen double `z'= ///
				`sgn'*(ln(`ltime')-`xb')/ `sigma' if `touse'
                	qui gen double `s'= ///
				gammap(`l',`l'*exp(`z'/sqrt(`l'))) if `touse'
                	qui replace `s'=cond(`sgn'==1,1-`s',`s') if `touse'

			qui gen double `ff'=((`l'-0.5)*ln(`l')) /*
		   	*/  + (`z'*sqrt(`l'))-`l'*exp(`z'/sqrt(`l')) /*
		   	*/ -lngamma(`l') - ln(`ltime'* `sigma') if `touse'
			qui replace `ff'= exp(`ff') if `touse'

			gen `vtyp' `var1' = `ff'/`s' if `touse'
			label var `var1' "Predicted hazard for `ltime'"

			qui replace `z'= ///
				`sgn'*(ln(`rtime')-`xb')/ `sigma' if `touse'
                	qui replace `s'= ///
				gammap(`l',`l'*exp(`z'/sqrt(`l'))) if `touse'
                	qui replace `s'=cond(`sgn'==1,1-`s',`s') if `touse'

			qui replace `ff'=((`l'-0.5)*ln(`l')) /*
		   	*/  + (`z'*sqrt(`l'))-`l'*exp(`z'/sqrt(`l')) /*
		   	*/ -lngamma(`l') - ln(`rtime'* `sigma') if `touse'
			qui replace `ff'= exp(`ff') if `touse'

			gen `vtyp' `var2' = `ff'/`s' if `touse'
			label var `var2' "Predicted hazard for `rtime'"
			exit
		}
	}

	if "`type'" =="surv" {
		tempvar xb ff z
		tempname sgn l
		qui gen double `sgn'=cond( `kappa'<0,-1,1) if `touse'
		qui gen double `l'= (abs(`kappa'))^(-2)	if `touse'
		qui _predict double `xb' if `touse', xb `offset' eq(#1)
		if "`lower'" != "" {
			qui gen double `z' = ///
				`sgn'*(ln(`ltime')-`xb')/ `sigma' if `touse'
			qui gen double `ff'= ///
				gammap(`l',`l'*exp(`z'/sqrt(`l'))) if `touse'
			qui replace `ff'=cond(`sgn'==1,1-`ff',`ff') if `touse'

			gen `vtyp' `varn' = `ff' if `touse'
			label var `varn' "Predicted S(`ltime')"
			exit
		}

		if "`upper'" != "" {
			qui gen double `z' = ///
				`sgn'*(ln(`rtime')-`xb')/ `sigma' if `touse'
			qui gen double `ff'= ///
				gammap(`l',`l'*exp(`z'/sqrt(`l'))) if `touse'
			qui replace `ff'=cond(`sgn'==1,1-`ff',`ff') if `touse'

			gen `vtyp' `varn' = `ff' if `touse'
			label var `varn' "Predicted S(`rtime')"
			exit
		}
		if `nvar' == 1 {
			qui gen double `z' = ///
				`sgn'*(ln(`ltime')-`xb')/ `sigma' if `touse'
			qui gen double `ff'= ///
				gammap(`l',`l'*exp(`z'/sqrt(`l'))) if `touse'
			qui replace `ff'=cond(`sgn'==1,1-`ff',`ff') if `touse'

			gen `vtyp' `varn' = `ff' if `touse'
			label var `varn' "Predicted S(`ltime')"
			exit
		}
		else {
			tokenize `varn'
			local var1 `1'
			local var2 `2'

			qui gen double `z' = ///
				`sgn'*(ln(`ltime')-`xb')/ `sigma' if `touse'
			qui gen double `ff'= ///
				gammap(`l',`l'*exp(`z'/sqrt(`l'))) if `touse'
			qui replace `ff'=cond(`sgn'==1,1-`ff',`ff') if `touse'

			gen `vtyp' `var1' = `ff' if `touse'
			label var `var1' "Predicted S(`ltime')"

			qui replace `z' = ///
				`sgn'*(ln(`rtime')-`xb')/ `sigma' if `touse'
			qui replace `ff'= ///
				gammap(`l',`l'*exp(`z'/sqrt(`l'))) if `touse'
			qui replace `ff'=cond(`sgn'==1,1-`ff',`ff') if `touse'

			gen `vtyp' `var2' = `ff' if `touse'
			label var `var2' "Predicted S(`rtime')"
		
			exit
		}
	}
	tempvar es
	if "`oos'" == "" {
		qui gen byte `es' = e(sample) & `touse'
	}
	else qui gen byte `es' = `touse'

	if "`type'"=="csnell" {
		tempvar surv
		qui gamma_ic_p double `surv'_L `surv'_R ///
			if `touse', surv `offset'

		if "`adjusted'" != "" {
			tempvar ff
		    	qui {
			gen double `ff' = (`surv'_L*(1-log(`surv'_L)) - ///
				     	     `surv'_R*(1-log(`surv'_R))) / ///
				            (`surv'_L - `surv'_R) ///
				    	if `es' & `fail' == 4
			replace `ff' = 1 - log(`surv'_L) ///
					if `es' & `fail' == 2
			replace `ff' = ///
					(1 - `surv'_R*(1-log(`surv'_R))) / ///
				 	(1 - `surv'_R) ///
					if `es' & `fail' == 3
			replace `ff' = -log(`surv'_L) ///
					if `es' & `fail' == 1
			}
			gen `vtyp' `varn' = `ff'
			label var `varn' "Adjusted Cox-Snell residual"
			exit
		}
	
		if "`lower'" != "" {
			gen `vtyp' `varn' = -log(`surv'_L) if `es'
			label var `varn' "Cox-Snell residual for `ltime'"
			exit
		}
		if "`upper'" != "" {
			gen `vtyp' `varn' = -log(`surv'_R) if `es'
			label var `varn' "Cox-Snell residual for `rtime'"
			exit
		}	
		if `nvar' == 1 {
			gen `vtyp' `varn' = -log(`surv'_L) if `es'
			label var `varn' "Cox-Snell residual for `ltime'"
			exit
		}
		else {
			tokenize `varn'
			local var1 `1'
			local var2 `2'

			gen `vtyp' `var1' = -log(`surv'_L) if `es'
			gen `vtyp' `var2' = -log(`surv'_R) if `es'

			label var `var1' "Cox-Snell residual for `ltime'"
			label var `var2' "Cox-Snell residual for `rtime'"

			exit
		}
	}

	if "`type'"=="mgale" { 
		predict `vtyp' `varn' if `touse', csnell adjusted `oos'
		qui replace `varn' = 1 - `varn'
		label var `varn' "Martingale-like residual"

		exit
	}
	error 198
end
program ChangeDepvar, eclass

	eret local depvar `0'

end
exit

