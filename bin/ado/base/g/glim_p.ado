*! version 1.3.3  15oct2019
program define glim_p
	version 9, missing
	local vv : display "version " string(_caller()) ", missing:"
	if "$SGLM_running" == "" {
		local drop drop
		global SGLM_V	`"`e(varfunc)'"'
		global SGLM_L	`"`e(link)'"'
		global SGLM_A	// not used
		global SGLM_y	`"`e(depvar)'"'
		global SGLM_m	`"`e(m)'"'
		global SGLM_a	`"`e(a)'"'
		global SGLM_p	`"`e(power)'"'
		global SGLM_f	// not used
		global SGLM_mu	// filled later
		global SGLM_s1 = `"`fam'"'=="glim_v2" | ///
			`"`fam'"'=="glim_v3" | `"`fam'"'=="glim_v6"
		global SGLM_ph	`e(phi)'
	}
	capture noisily `vv' PREDICT `0'
	if "`drop'" != "" {
		macro drop SGLM_*
	}
	exit c(rc)
end

program PREDICT
	version 9, missing
	local vv : display "version " string(_caller()) ", missing:"
	syntax anything(name=vspec id="varlist") [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		if inlist("`e(opt)'", "ml", "moptimize") {
			marksample touse, novarlist
			$SGLM_V -1 `touse'
			$SGLM_L -1 `touse'
			ml score `vspec' if `touse', `scores' `options'
			exit
		}
		else {
			_score_spec `vspec'
			local vspec `s(typlist)' `s(varlist)'
		}
	}

	version 6, missing

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

	local xopts "Anscombe Cooksd Deviance Hat Likelihood"
	local xopts "`xopts' Response Pearson Working T(varname)"
	local xopts "`xopts' STAndardized STUdentized MODified ADJusted"
	local svyopts Eta Mu Scores xb
	local myopts `xopts' `svyopts'



		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/

	_pred_se "`myopts'" `vspec' `if' `in', `scores' `options'
	if `s(done)' { exit }
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'

		/* Step 3:
			Parse your syntax.
		*/
	syntax [if] [in] [, `myopts' noOFFset] 

	if "`e(prefix)'" == "svy" {
		if "`t'" != "" {
			local topt t(`t')
		}
		_prefix_nonoption after svy estimation,		///
			`anscombe' `cooksd' `deviance' `hat'	///
			`likelihood' `pearson'			///
			`working' `topt' `standardized'		///
			`studentized' `modified' `adjusted'
	}


		/* Step 4:
			Concatenate switch options together
		*/
        local type "`anscombe'`cooksd'`deviance'`eta'`hat'`likelihood'`mu'"
	local type "`type'`response'`pearson'`scores'`working'`xb'"

	local mod  "`standardized'`studentized'`modified'"

	if "`adjusted'" != "" & "`type'" != "deviance" {
		version 7: di in red "option {bf:adjusted} allowed only with option {bf:deviance}"
		exit 198
	}


		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/


		/* Step 6:
			mark sample (this is not e(sample)).
		*/
	marksample touse

	tempvar tvar
	local y "`e(depvar)'"
	if "`mod'" != "" {
		local q "qui" 
	}

		/* Step 7:
			handle options that take argument one at a time.
			Comment if restricted to e(sample).
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/

	/* all statistics require eta and mu below */
	quietly {
		tempvar eta mu
		_predict double `eta' if `touse', xb `offset'
		`e(link)' 1 `eta' `mu'
		replace `mu' = . if `touse'==0
	}

	if ("`type'"=="" & "`t'"=="") | "`type'"=="mu" {
		if "`type'"=="" {
			version 7: di in gr /*
			*/ "(option {bf:mu} assumed; predicted mean {bf:`y'})"
		}
		qui gen double `tvar' = `mu' if `touse'
		local lab "Predicted mean `y'"
	}

	else if "`type'"=="xb" | "`type'" == "eta" {
		qui gen double `tvar' = `eta' if `touse' 
		local lab `"`:var label `eta''"'
	}

	else if "`type'"=="deviance" {
		tempvar dev
		qui `e(varfunc)' 3 `eta' `mu' `dev'
		if "`adjusted'" == "" {
			qui gen double `tvar' = sign(`y'-`mu')*sqrt(`dev') /*
				*/ if `touse'
			local lab "deviance residual"
		}
		else {
			tempvar adj
			qui `e(varfunc)' 6 `eta' `mu' `adj'
			qui gen double `tvar' = /*
				*/ sign(`y'-`mu')*sqrt(`dev')+`adj' /*
				*/ if `touse'
			local lab "adjusted deviance residual"
		}
	}

	else if "`type'"=="response" {
		tempvar v
		qui `e(varfunc)' 1 `eta' `mu' `v'
		qui gen double `tvar' = (`y'-`mu') if `touse'
		local lab "response residual"
	}

	else if "`type'"=="pearson" {
		tempvar v
		qui `e(varfunc)' 1 `eta' `mu' `v'
		qui gen double `tvar' = (`y'-`mu')/sqrt(`v') if `touse'
		local lab "Pearson residual"
	}

	else if "`type'"=="anscombe" {
		tempvar a
		qui `e(varfunc)' 4 `eta' `mu' `a'
		qui gen double `tvar' = `a' if `touse'
		local lab "Anscombe residual"
	}

	else if "`type'"=="scores" {
		tempvar v dmu
		qui `e(varfunc)' 1 `eta' `mu' `v'
		qui `e(link)' 2 `eta' `mu' `dmu'
		qui gen double `tvar' = `dmu'*(`y'-`mu')/`v'
		local lab "score residual"
	}

	else if "`type'"=="working" {
		tempvar v dmu
		qui `e(link)' 2 `eta' `mu' `dmu'
		qui gen double `tvar' = (1/`dmu')*(`y'-`mu')
		local lab "working residual"
	}

	else if "`t'" != "" {
		tempvar pt
		qui gen double `pt' = _b[`t']*`t'

		tempvar v dmu
		qui `e(link)' 2 `eta' `mu' `dmu'
		qui gen double `tvar' = `dmu'*(`y'-`mu')+`pt'
		local lab "partial(`t') residual"
	}

	else {
		local notdone 1
	}

	if "`mod'" == "" & "`notdone'" == "" {
		gen `vtyp' `varn' = `tvar'
		label var `varn' "`lab'"
		exit
	}

	if "`studentized'" != "" {
		local phi "`e(phi)'"
		local stuf "* 1/sqrt(`phi')"
		local lab "Studentized `lab'"
	}
	if "`modified'" != "" {
		local disp "`e(disp)'"
		if "`disp'" == "" {
			local disp 1
		}
		tempvar wt1
		if "`e(wexp)'" == "" {
                        qui gen byte `wt1' = e(sample)
                }
                else {
                        qui gen double `wt1' `e(wexp)' if e(sample)
                        if `"`e(wtype)'"'=="aweight" {
                                qui summ `wt1'
                                qui replace `wt1' = `wt1'/r(mean)
                        }
                }
		local modf "* 1/sqrt(`disp'/`wt1')"
		local lab "modified `lab'"
	}

	if "`standardized'" == "" & "`notdone'" == "" {
		gen `vtyp' `varn' = `tvar' `stuf' `modf' 
		lab var `varn' "`lab'"
		exit
	}
		
	/* All statistics below here require the hat diagonals */

	if "`e(vcetype)'" == "Robust" {
		version 7: di in red "option {bf:standardized} not allowed after robust estimation"
		exit 198
	}
	quietly {
		/* We need to calculate the hats over e(sample) and then 
		   limit the generated variable to `touse' */

		tempvar   z dmu v W wt hat d2mu dv
		tempname  ll bb

		mat `bb' = e(b)
		local xvars : colnames(`bb')
		local nx : word count `xvars'
		parse "`xvars'", parse(" ")
		if "``nx''" == "_cons" { local `nx' }
		local xvars "`*'"
		if "`e(wexp)'" == "" {
			gen byte `wt' = e(sample)
		}
		else {
			gen double `wt' `e(wexp)' if e(sample)
			if `"`e(wtype)'"'=="aweight" {
				qui summ `wt'
				qui replace `wt' = `wt'/r(mean)
			}
		}
		local y "`y'"
		if "`e(offset)'" != "" {
			local moffset "-`e(offset)'"
		}
		tempvar eta mu
		_predict double `eta' if e(sample), xb `offset'
		`e(link)' 1 `eta' `mu'
		`e(varfunc)' 1 `eta' `mu' `v'
		`e(link)' 2 `eta' `mu' `dmu'

		gen double `z' = `eta' + (`y'-`mu')/`dmu' `moffset' if e(sample)

		if 0 {   // rgg--leverage only makes sense in an IRLS-setting
			`e(varfunc)' 2 `eta' `mu' `dv'
			`e(link)' 3 `eta' `mu' `d2mu'
			gen double `W' = `dmu'*`dmu'/`v' - /*
				*/ (`mu'-`y')*(`dmu'*`dmu'*`dv'/(`v'*`v') - /*
				*/ `d2mu'/`v') if e(sample)
		}
		else {
			gen double `W' = `dmu'*`dmu'/`v' if e(sample)
		}
                        tempname constr
                cap version 11: matrix `constr' = e(Cns)
                if _rc==0 {
                 	local regcmd cnsreg
                }
		_ms_op_info e(b)
		if r(fvops)==1 {
			local vvreg version 11:
		}
		nobreak {
			estimates hold `ll'
			summ `W' if e(sample)
			if "`regcmd'"=="cnsreg" {
				`vv' ///
				cnsreg `z' `xvars' [iw=`W'*`wt'], ///
    					mse1 `e(cons)' constraint(`constr')
			}
			else {
				`vvreg' reg `z' `xvars' [iw=`W'*`wt'], ///
					mse1 `e(cons)'
			}
			_predict double `hat', stdp /* sic -- no `offset' */
			replace `hat' = `hat'*`hat'*`W'

			*replace `hat' = min(`hat',.9999) if `hat'<.
			*replace `hat' = max(`hat',.0001) if `hat'<.

			estimates unhold `ll'
		}
	}

	if "`type'"=="hat" {
		if "`mod'" != "" {
			version 7: di in red "option {bf:`mod'} not allowed with hat residuals"
			exit 198
		}
		gen `vtyp' `varn' = `hat' if `touse'
		label var `varn' "hat diagonal"
		exit
	}

	if "`type'"=="likelihood" {
		if "`mod'" != "" {
			version 7: di in red "option {bf:`mod'} not allowed with likelihood residuals"
			exit 198
		}
		tempvar dev spe
		qui gen double `spe' = (`y'-`mu')/sqrt(`v'*(1-`hat')) if `touse'
		qui `e(varfunc)' 3 `eta' `mu' `dev'
		gen `vtyp' `varn' = /*
			*/ sign(`y'-`mu')*sqrt(`hat'*`spe'*`spe' + `dev') /*
			*/ if `touse'
		label var `varn' "likelihood residual"
		exit
	}

	else if "`type'"=="cooksd" {
		tempvar pp
		qui gen double `pp' = (`y'-`mu')/sqrt(`v'*`e(phi)')
		gen `vtyp' `varn'  = /*
			*/ `hat'*`pp'*`pp'/(e(rank)*(1-`hat')^2) if `touse'
		label var `varn' "Cook's distance"
		exit 
	}

	gen `vtyp' `varn' = `tvar' `stuf' `modf' * 1/sqrt(1-`hat')
	lab var `varn' "standardized `lab'"
end
