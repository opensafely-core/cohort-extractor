*! version 6.2.7  11apr2019
program define arch_p, properties(notxb)
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

	local myopts AT(string) Dynamic(string) HET Residuals /*
		*/ STRuctural T0(string) Variance XB Y YResiduals

		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
			/* takes advantage that -myopts- produces error
			 * if -eq()- specified w/ other than xb and stdp */

	_pred_se "`myopts'" `0'
	if `s(done)' { exit }
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'


		/* Step 3:
			Parse your syntax.
		*/

	syntax [if] [in] [, `myopts' noOFFset]

	if "`structural'" != "" & "`e(ar)'`e(ma)'" == "" {
		noi di in blue "structural has no effect without ARMA terms"
		local structu
	}
	if "`dynamic'" != ""  {
		if "`at'" != "" {
			di in red "options at() and dynamic() may not be "  /*
				*/ "specified together"
			exit 198
		}
		if "`e(aparch)'`e(parch)'`e(pgarch)'`e(nparch)'`e(nparchk)'" /*
		*/ != "" & ("`variance'" != "" | "`e(archm)'" != "") {
			di in red "dynamic predictions involving the "	/*
			*/ "conditional variance not available "
			di in red "for models with power terms."
			exit 198
		}
	}

	if "`at'" != "" {
		PrsAt `"`at'"'
		local at_e `r(e_val)'
		capture confirm numeric variable `r(s2_val)'
		if _rc {			/* may refer to lags */
			tempvar at_s2
			gen double `at_s2' = `r(s2_val)'
		}
		else	local at_s2 `r(s2_val)'
	}
	else	local doat *


		/* Step 4:
			Concatenate switch options together
		*/

	local type  `het'`residuals'`variance'`xb'`y'`yresiduals'
	local args


		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/

		/* Step 6:
			mark sample (this is not e(sample)).
		*/
	marksample touse

			/* Set up one-step and dynamic samples */
	_ts timevar panvar, sort panel
	qui tsset, noquery
	local tfmt `r(tsfmt)'
	markout `touse' `timevar' `panvar'
	tempname touseS touseD
	gen byte `touseS' = `touse'
	gen byte `touseD' = 0
	if "`t0'" != "" { 
		qui replace `touseS' = 0 if `timevar' < `t0' 
		local t0opt "t0(`t0')"
	}
	if "`dynamic'" != "" {
		if missing(`dynamic') {
				/* See explanation at same place in arima_p.ado
				   for details				      */
			tempname tsdelta dynamic
			if "`e(ar)'" == "" {
				local armax = 0
			}
			else {
				GetMax armax : "`e(ar)'"
			}
			if "`e(ma)'" == "" {
				local mamax = 0
			}
			else {
				GetMax mamax : "`e(ma)'"
			}
			scal `dynamic' = `armax' + `mamax'
			sca `tsdelta' = `:char _dta[_TSdelta]'
			sca `dynamic' = `e(tmin)' + `tsdelta'*`dynamic'
di as text "Note: beginning dynamic predictions in period " `tfmt' `dynamic' "."
		}
		qui replace `touseD' = `touseS' & `timevar' >= `dynamic' 
		local dynopt "dyn(`dynamic')"
	}

			/* predicted variable labeling */

	if "`structural'" != "" { 
		local postlab `structural' 
	}
	if "`dynamic'" != "" { 
		local postlab = ltrim(`"`postlab' `dynopt'"') 
	}
	else	local postlab = ltrim("`postlab' one-step")
	if "`t0'" != "" { local postlab = ltrim("`postlab' t0(`t0')") }

		/* Step 7:
			handle options that take argument one at a time.
			Comment if restricted to e(sample).
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/

	/* Get type(s) of model based on saved results */

	if "`e(doarch)'" == "*"	  	 { local doarch  * }
	if "`e(mhet)'" == ""      	 { local dohet   * }
	if "`e(earch)'" == ""     	 { local doearch * }
	if "`e(egarch)'" == ""    	 { local doegrch * }
	if "`e(earch)'`e(egarch)'" == "" { local doeaeg  * }
	if "`e(archm)'" == ""     	 { local doarchm * }
	if "`e(archmexp)'" == ""  	 { local darchme * }
	if "`e(tarch)'" == ""     	 { local dotarch * }
	if "`e(ar)'`e(ma)'" == "" 	 { local doarma  * }
	if e(power) >= .          	 { local dopowa  * }
	if "`e(abarch)'`e(atarch)'`e(sdgarch)'" == "" { local doab * }
	if "`e(sdgarch)'" == ""   	 { local dosd    * }
	if "`e(atarch)'" == "" 		 { local dotabse * }
	if "`e(parch)'`e(pgarch)'`e(tparch)'" == "" { local dopow   * }


	/* Get beta and restripe it for scoring */

	tempname b
	mat `b' = e(b)
	local origeqs : coleq `b'

	if "`e(cmd)'"=="arch" {
		local eqnames `e(eqnames)'	
		local ct : word count `e(ar)'
		local i 1
		while `i' <= `ct' {
		    local eqnames : subinstr local eqnames "AR1_terms" "ARMA"
		    local i = `i' + 1
		}
		local eqnames : subinstr local eqnames "MA1_terms" "ARMA", all
		local eqnames : subinstr local eqnames "SIGMA" "HET"
		mat coleq `b' = `eqnames'
	}
	else mat coleq `b' = `e(eqnames)'

	/* Get x*beta (if there is an equation for it) */
	/* this xb does not recurse if depvar is in rhs of model */
	tempvar xb T

	gettoken xeqnam : origeqs
	if "`xeqnam'" == "ARCH" | "`xeqnam'" == "ARCHM"			/*
		*/ | "`xeqnam'" == "ARMA" | "`xeqnam'" == "HET"		/*
		*/ | "`xeqnam'" == "SIGMA2"  | "`xeqnam'" == "POWER" {
		qui gen byte `xb' = 0 
		local doxb *

		local nms : colfullnames `b'
	}
	else {
		qui _predict double `xb', xb `offset'

		tempname b1		/* must avoid var names later */
		capture mat `b1' = `b'[1,"`e(depvar)':"]
		if _rc { mat `b1' = `b'[1,"eq1:"] }
		local nms1 : colfullnames `b1'
		mat `b1' = `b'[1,colsof(`b1')+1...]
		local nms : colfullnames `b1'
	}

	/* We need a sigma2 variable regardless of whether doarch is `*' */
	tempvar sigma2 tvar
	qui gen double `sigma2' = .
	qui gen double `tvar' = .

	if "`dohet'" == "" {
		tempvar xbhet
		qui mat score `xbhet' = `b' if `touse', eq(HET)
		local hetterm + `xbhet'
		if "`e(earch)'`e(egarch)'" == "" {
			qui replace `xbhet' = exp(`xbhet')
			local hetdyn  update `sigma2' = `sigma2' + exp(`tvar')
		}
		else	local hetdyn  update `sigma2' = `sigma2' + `tvar'

		if "`doarch'" == "*" {
			qui replace `sigma2' = 0  if `touse'
		}
	}
	else if !e(archany) {
		qui capture qui mat `T' = `b'[1,"HET:"]
		if _rc {
			mat `T' = `b'[1,"SIGMA2:"]
		}
		qui replace `sigma2' = `T'[1,1]  if `touse'
		local dohet *
	}
	else {
		local dohet *
		if "`doarch'" == "*" {
			qui replace `sigma2' = 0  if `touse'
		}
	}

					/* NOTE, early processing of a 
					 * switch type */
	/* multiplicative heteroskedastic prediction */

	if "`type'" == "het" {
		if "`xbhet'" == "" {
			di in red "no multiplicative heteroskedasticity " /*
			*/ "component in model"
		}
		gen `vtyp' `varn' = `xbhet'
		label var `varn' `"Heteroskedasticity component"'
		exit
	}


	tempvar te sarch te2 
	qui gen double `te'    =  . in 1
	qui gen double `sarch' = `sigma2'  if `touse'

	if e(archany) {
		qui gen double `te2'    =  . in 1
		local sig2_0  = e(archi)
		local sig_0 = sqrt(e(archi))
		local abse_0  = sqrt(2*`sig2_0'/_pi) 
		local lsig2_0 = ln(`sig2_0')
		`dopowa' local sigp_0  = `sig2_0'^(e(power)/2)
	}

	/* power parameter */

	if e(power) < . { local pow = e(power) }


	/* temporary variables */

	tempvar xbfin sigma abse tabse tarchme tarchm tz absz tarch 
	tempvar earch earcha lnsig2 egarch tu sigmap abse_p tabse_p

	qui gen double `xbfin' 		   = .
	qui gen double `sigma'             = .	    /* needed pretty often */
	`doab'  qui gen double `abse'      = .
	`dotabse' qui gen double `tabse'   = .
	`darchme' qui gen double `tarchme' = .
	qui gen double `tarchm'            = 0
	`doearch' qui gen double `tz'      = .
	`doearch' qui gen double `absz'    = .
	`dotarch' qui gen double `tarch'   = .

	`doeaeg'  qui gen double `earch'   = 0
	`doeaeg'  qui gen double `earcha'  = 0
	`doegrch' qui gen double `lnsig2'  = .
	`doeaeg'  qui gen double `egarch'  = 0

	`dopowa'  qui gen double `sigmap'  = 0
	`dopow'   qui gen double `abse_p'  = .
	`dopow'   qui gen double `tabse_p' = .

	qui gen double `tu'                = .

	local normadj = sqrt(2/_pi)

	local nms `"`nms' "'
	local nms : subinstr local nms ".ar "     ".`tu' "     , all
	local nms : subinstr local nms ".ma "     ".`te' "     , all
	local nms : subinstr local nms ".arch "   ".`te2' "    , all
	local nms : subinstr local nms ".garch "  ".`sigma2' " , all
	local nms : subinstr local nms ".saarch " ".`te' "     , all

	`dotarch' local nms : subinstr local nms ".tarch "   ".`tarch' " , all

	`doab'    local nms : subinstr local nms ".abarch "  ".`abse' "   , all
	`dotabse' local nms : subinstr local nms ".atarch "  ".`tabse' "  , all
	`dosd'    local nms : subinstr local nms ".sdgarch " ".`sigma' "   , all

	`doearch' local nms : subinstr local nms ".earch_a " ".`absz' "  , all
	`doearch' local nms : subinstr local nms ".earch "   ".`tz' "    , all
	`doegrch' local nms : subinstr local nms ".egarch "  ".`lnsig2' ", all

	`doarchm' local nms : subinstr local nms ".sigma2 "  ".`sigma2' ", all
	`doarchm' local nms : subinstr local nms ".sigma2ex " ".`tarchme' ", all
	`darchme' local nms : subinstr local nms "ARCHM:sigma2ex"  /*
			*/ "ARCHM:`tarchme'"   , all
	`doarchm' local nms : subinstr local nms "ARCHM:sigma2"  /*
			*/ "ARCHM:`sigma2'"   , all

	`dopow' local nms : subinstr local nms ".pgarch "  ".`sigmap' "   , all
	`dopow' local nms : subinstr local nms ".parch "   ".`abse_p' "   , all
	`dopow' local nms : subinstr local nms ".tparch "  ".`tabse_p' "  , all

	if "`at'" != "" {
		local nms : subinstr local nms ".`sigma2' "  ".`at_s2' " , all
	}

	mat colnames `b' = `nms1' `nms'

	if "`structural'" != "" { clrARMA `b' }		/* clear ARMA coefs */

						/* arch in mean expressions */
	`darchme' local archmx `e(archmexp)'
	`darchme' local archmx : subinstr local archmx "X" "`sigma2'", all

						/* build update expressions */
							/* aparch and aarch */
	local powterm 0
	`dopow' local powterm `tvar'

	if "`e(aparch)'" != "" {
	    aparchEx aparchx : `b' `sigmap' `sigma2' `powterm' `sig_0' `te' 0 1
	}
	if "`e(aarch)'" != "" {
	    aparchEx aarchx  : `b' `sigma2' `sigma2'  0        `sig_0' `te' 0 0
	}
							/* narch and narchk   */
							/* nparch and nparchk */
	if "`e(nparch)'" != "" {
	     narchEx nparchx : `b' `sigmap' `sigma2' `powterm' `sig_0' `te' 0 1
	}
	if "`e(narch)'" != "" {
	     narchEx narchx  : `b' `sigma2' `sigma2'  0        `sig_0' `te' 0 0
	}

	if "`e(aparch)'`e(narch)'" == "" & "`dopow'" == "" {
		local aparchx update `sigmap' = `sigma2' + `tvar'
	}

	if "`doarma'" != "*" {			/*   ARMA term */
		tempvar tu_hat
		qui gen double `tu_hat' = . in 1
		local tuhterm " + `tu_hat'" 
		local tuterm " + `tu'" 
	}
	else	local tu_hat 0

				/* Perform computations, all 
				 * computation performed regardless
				 * of option */

					/* One-step ahead projections */

	qui _byobs {
		`doarch' score `sigma2' = `b', eq("ARCH") missval(`sig2_0')
		`dohet' update `sigma2' = `sigma2' `hetterm'
		`doab' score `tvar' = `b', eq("SDARCH") missval(`abse_0')
		`doab' update `sigma2' = `sigma2' + `tvar'^2

		`aarchx'
		`narchx' 

		`doearch' score `earch'  = `b', eq("EARCH") missval(0)
		`doearch' score `earcha' = `b', eq("EARCHa") missval(0)
		`doegrch' score `egarch' = `b', eq("EGARCH") missval(`lsig2_0')
	     `doeaeg' update `sigma2' = exp(`sigma2'+`egarch'+`earch'+`earcha')

		`dopow' score `tvar' = `b', eq("PARCH") missval(`sigp_0')
		`aparchx'
		`nparchx'
		`dopowa' update `sigma2' = `sigmap'^(2/e(power)) 

		`doegrch' update `lnsig2' = ln(`sigma2')

		`doat'`doegrch' update `lnsig2' = ln(`at_s2')
		`doat'`dopowa' update `sigmap' = `at_s2'^(e(power)/2)

		`darchme' update `tarchme' = `archmx'
		`doarchm' score `tarchm' = `b', eq("ARCHM") missval(`sig2_0')
	
		update `tu' = `e(depvar)' - `xb' - `tarchm'

		`doarma' score  `tu_hat' = `b', eq("ARMA") missval(0)
		update `xbfin' = `xb' + `tarchm' `tuhterm'
		update `te' = `tu' - `tu_hat'
		`doat' update `te' = `at_e'

		`doearch' update `tz'   = `te'/sqrt(`sigma2')
		`doat'`doearch' update `tz'   = `te'/sqrt(`at_s2')
		`doearch' update `absz' = abs(`tz') - `normadj'

		`doarch'  update `te2'   = `te'^2

		update `sigma' = sqrt(`sigma2')
		`doat' update `sigma' = sqrt(`at_s2')

		`dotarch' update `tarch' = (`te'>0) * `te2'
		`doab'    update `abse'  = abs(`te')
		`dotabse' update `tabse' = (`te'>0) * abs(`te')
		`dopow' update `abse_p'  = abs(`te')^e(power)
		`dopow' update `tabse_p' = (`te' > 0) * abs(`te')^e(power)

	} if `touseS' & !`touseD'


					/* Dynamic projections */

	if "`dynamic'" != "" {
		tempname te_d xbdyn		/* xbdyn to handle l#.y rhs */
		qui gen double `te_d' = `te'	/* for use in nonlin exps  */
		qui gen double `xbdyn' = `e(depvar)'
		op_colnm `b' `e(depvar)' `xbdyn'	/* for lagged depv */

						/* build update expressions */
							/* aparch and aarch */
		if "`e(aparch)'" != "" {
			aparchEx aparchx : `b' `sigmap' `sigma2' `powterm'  /*
				*/ `sig_0' `te_d' 1 1 `sigma'
		}
		if "`e(aarch)'" != "" {
			aparchEx aarchx  : `b' `sigma2' `sigma2'  0         /*
				*/ `sig_0' `te_d' 1 0 `sigma'
		}
							/* narch and narchk   */
							/* nparch and nparchk */
		if "`e(nparch)'" != "" {
			narchEx nparchx : `b' `sigmap' `sigma2' `powterm' /*
				*/ `sig_0' `te_d' 1 1 `sigma'
		}
		if "`e(narch)'" != "" {
			narchEx narchx  : `b' `sigma2' `sigma2'  0        /*
				*/ `sig_0' `te_d' 1 0 `sigma'
		}

		qui _byobs {
		   `doxb' score `xb' = `b', eq(#1)

		   `doarch' score `sigma2' = `b', eq("ARCH") missval(`sig2_0')
		   `dohet' score `tvar' = `b', eq("HET")
		   `hetdyn'
		   `doab' score `tvar' = `b', eq("SDARCH") /*
				*/ missval(`abse_0')
		   `doab' update `sigma2' = `sigma2' + `tvar'^2

		   `aarchx'
		   `narchx'

		   `doearch' score `earch'  = `b', eq("EARCH") missval(0)
		   `doearch' score `earcha' = `b', eq("EARCHa") missval(0)
		   `doegrch' score `egarch' = `b', /*
				*/ eq("EGARCH") missval(`lsig2_0')
		   `doeaeg'  update `sigma2' = exp(`sigma2'+`egarch'+ /*
				*/ `earch'+`earcha')

		   `dopow' score `tvar' = `b', eq("PARCH") /*
				*/ missval(`sigp_0')
		   `aparchx'
		   `nparchx'
		   `dopowa' update `sigma2' = `sigmap'^(2/e(power)) 

		   `doegrch' update `lnsig2' = ln(`sigma2')

		   `darchme' update `tarchme' = `archmx'
		   `doarchm' score `tarchm' = `b', /*
				*/ eq("ARCHM") missval(`sig2_0')
	
		   `doarma' score  `tu' = `b', eq("ARMA") missval(0)
		   update `xbdyn' = `xb' + `tarchm' `tuterm'
		   update `te' = 0

		   `doearch' update `tz'   = 0   /* `te'/sqrt(`sigma2')  */
		   `doearch' update `absz' = 0   /* E[|`tz'| - `normadj' */

		   `doarch'  update `te2'   = `sigma2'

		   update `sigma' = sqrt(`sigma2')

		   `dotarch' update `tarch' = .5*`sigma2'
		   `doab'    update `abse'  = sqrt(2*`sigma2'/_pi)
		   `dotabse' update `tabse' = 0.5*`abse'
		   `dopow' update `abse_p'  = _Eabsk(0, `sigma', e(power))
		   `dopow' update `tabse_p' = 0.5*`abse_p'

		} if `touseD'

		qui replace `xbfin' = `xbdyn' if `touseD'
	}


		/* Step 8:
			handle switch options that can be used in-sample or 
			out-of-sample one at a time.
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/

	if "`type'"=="" | "`type'" == "xb" {
		if "`type'" == "" {
			version 8: ///
			di "{txt}(option {bf:xb} assumed; linear prediction)"
		}
			/* 
			   This adjustment removed.  It was included only for
			   comparison to another package that did not include
			   the arch-in-mean component in the prediction.

			if "`dynamic'" == "" {
				`doarchm' local am "- `tarchm'"
			}
			*/
		gen `vtyp' `varn' = `xbfin' if `touse'
		label var `varn' `"xb prediction, `postlab'"'
		exit
	}

	if "`type'" == "y" {
		drop `xb'				/* borrow xb */
		op_inv `e(depvar)' `xbfin', gen(`xb') `dynopt', /*
			*/ if `touseS' | `touseD'
		gen `vtyp' `varn' = `xb'
		label var `varn' `"y prediction, `postlab'"'
		exit
	}

	if "`type'" == "residuals" {
		gen `vtyp' `varn' = `e(depvar)' - `xbfin'
		label var `varn' `"residual, `postlab'"'
		exit
	}

	if "`type'" == "yresiduals" {
		drop `xb'				/* borrow xb */
		op_inv `e(depvar)' `xbfin', gen(`xb') `dynopt', /*
			*/ if `touseS' | `touseD'
		tsrevar `e(depvar)', list
		gen `vtyp' `varn' = `r(varlist)' - `xb'
		label var `varn' `"residual, `postlab'"'
		exit
	}

	if "`type'" == "variance" {
		gen `vtyp' `varn' = `sigma2' if `touse'
		label var `varn' `"Conditional variance, `postlab'"'
		exit
	}

		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/


			/* Step 10.
				Issue r(198), syntax error.
				The user specified more than one option
			*/
	error 198
end

program define PrsAt, rclass

	tokenize `0', parse(", ")
	if "`2'" == "," { 
		local 2 `3' 
		local 3
	}

	if "`3'" != "" {
		di in red `"invalid at(`0')"'
		exit 198
	}

	local i 1
	while `i' <= 2 {
		capture confirm numeric variable `1'
		if _rc {
			capture confirm number `1'
			if _rc {
				if `i' != 2 | "``i''" != "." {
di in red "arguments to at() must be either numeric variables or a numbers"
					exit 198
				}
			}
		}
		local i = `i' + 1
	}

	return local e_val  `1'
	return local s2_val `2'
end

program define clrARMA
	args b

	local str " str."
	local i 1
	tokenize `e(eqnames)'
	while "``i''" != "" {
		if "``i''" == "ARMA" { mat `b'[1,`i'] = 0 }
		local i = `i'+1
	}
end


program define aparchEx
	args exp colon bfull target initial init2 sigma0 e_t dynamic ispow /*
		*/  sigma

	if `ispow' {
		local P  "P"
		local pp "p"
	}

	tempname b
	capture mat `b' = `bfull'[1, "A`P'ARCH:"]
	if _rc {
		c_local `exp'
		exit
	}

	tempname T

	local ex update `target' = `initial' + `init2'

	if `ispow'  {
		local p `e(power)'
	}
	else	local p 2

	local cols : colnames `b'
	tokenize `cols'
	local i 1
	SplitNam op sinam : "``i''"
	while "`sinam'" == "a`pp'arch" {

		local g = `b'[1,`i']
		local j = colnumb(`b', "`op'.a`pp'arch_e")
		local k = `b'[1,`j']
		local expval0 = (`sigma0'^`p'*2^(`p'/2-1)		/*
			*/ / sqrt(_pi))*((1-`k')^`p'+(1+`k')^`p')	/*
			*/ * exp(lngamma((`p'+1)/2))

		if `dynamic' {
			local expval (`op'.`sigma'^`p'*2^(`p'/2-1) /	  /*
				*/ sqrt(_pi))*((1-`k')^`p'+(1+`k')^`p') * /*
				*/ exp(lngamma((`p'+1)/2))

			local ex `ex' + `g' *			/* 
				*/ cond(`op'.`e_t'>=.,		/*
				*/    cond(`op'.`sigma'>=., 	/*
				*/	 `expval0', 		/*
				*/	 `expval'		/*
				*/    ),			/*
				*/    (abs(`op'.`e_t') + `k'*`op'.`e_t')^`p' /*
				*/ )
		}
		else {
			local ex `ex' + `g' * cond(`op'.`e_t'>=., `expval0', /*
				*/ (abs(`op'.`e_t') + `k'*`op'.`e_t')^`p')
		}

		local i = `i' + 1
		SplitNam op sinam : ``i''
	}

	c_local `exp' `ex'
end

program define narchEx
	args exp colon bfull target initial init2 sigma0 e_t dynamic ispow /*
		*/ sigma


	if `ispow' {
		local P  "P"
		local pp "p"
	}

	tempname b
	capture mat `b' = `bfull'[1, "N`P'ARCH:"]
	if _rc {
		c_local `exp'
		exit
	}

	tempname T

	local ex update `target' = `initial' + `init2'

	if `ispow'  {
		local p `e(power)'
	}
	else	local p 2

	local cols : colnames `b'
	tokenize `cols'
	local i 1
	SplitNam op sinam : "``i''"
	while "`sinam'" == "n`pp'arch" {
		local g = `b'[1,`i']
		capture local j = colnumb(`b', "`op'.n`pp'arch_k")
		if `j' >= . { local j = colnumb(`b', "n`pp'arch_k") }
		local k = `b'[1,`j']
		local expval0 = _Eabsk(`k', `sigma0', `p')

		if `dynamic' {
			local expval _Eabsk(`k', `op'.`sigma', `p')

			local ex `ex' + `g' * 				/*
				*/ cond(`op'.`e_t'>=., 			/*
				*/     cond(`op'.`sigma'>=., 		/*
				*/	   `expval0', 			/*
				*/	   _Eabsk(`k', `op'.`sigma', `p')  /*
				*/     ),				/*
				*/     abs(`op'.`e_t' - `k')^`p'	/*
				*/ )
		}
		else {
			local ex `ex' + `g' * cond(`op'.`e_t'>=., `expval0', /*
				*/ abs(`op'.`e_t' - `k')^`p')
		}

		local i = `i' + 1
		SplitNam op sinam : ``i''
	}

	c_local `exp' `ex'
end

program define SplitNam		/* assumes op.si */
	args opnam sinam colon name

	tokenize `name', parse(":.")

	c_local `opnam' `1'
	c_local `sinam' `3'
end

/*
	Takes a list of nonnegative numbers and finds the max.
	
	GetMax <localmacname> : <list of #s>
*/
program GetMax
	args macname colon list

	local max = 0
	foreach elem of local list {
		if real("`elem'") > `max' {
			local max = `elem'
		}
	}
	
	c_local `macname' `max'
end


exit



Notes:
------

1) Other packages may not include the arch-in-mean component in 
   the (xb) prediction.

2) Other packages may include the arma component of the mean even when 
   producing the static structural arch (variance) prediction.  This means
   that the static structural arch prediction would be no different than
   the static (nonstructural) arch prediction.

3) Other packages may not include the sqrt(2/_pi) term in the egarch
   type models.  This will cause the constant term in the arch part
   of the model to be different.  Also, it will affect forecasts.

4) In the dynamic loop, all of the references to terms including e_t have 
   been replaced with term's appropriate expected value.

----

+
-
data structure

archterm    addsto   expression                        E[expression]
--------    ------   ----------                        -----------------------
aarch       sigma2
aparch      sigmap   (abs(e_t) - aparch_e*e_t)^power   f(aparch_e, power, sigma)

