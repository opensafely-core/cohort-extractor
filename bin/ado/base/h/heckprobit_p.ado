*! version 1.3.0  19feb2019
program define heckprobit_p
	version 6, missing

	version 9: syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		version 9
		marksample touse
		marksample touse2
		_ms_lf_info
		local xvars `"`r(varlist1)'"'
		local depvar = e(depvar)
		gettoken dep1 dep2 : depvar
		if `:length local dep2' {
			local if if `dep2'
		}
		else {
			local if if !missing(`dep1')
		}
		markout `touse2' `xvars'
		quietly replace `touse' = 0 `if' & !`touse2'

nobreak {
		tempname hold
		_est hold `hold', restore copy

		local depvars = e(depvar)
		if `:list sizeof depvars' == 1 {
			tempvar y2
			quietly gen byte `y2' = `depvars' < .
			SetDepvar `depvars' `y2'
		}
		// setup 
		local w: word 1 of `e(depvar)'
		if ("`e(seldep)'" != "") {
			mata: heckprob_init("inits", ///
			"`e(seldep)'","`w'","`touse'")
		}
		else {
		       	tempvar seldep
			gen byte `seldep' = `touse'
			markout `seldep' `w'
			mata: heckprob_init("inits", ///
				"`seldep'", "`w'","`touse'")
		}
		local udat userinfo(`inits')
capture noisily break {
		ml score `anything' if `touse', `scores' missing `options' ///
		`udat'
} // capture noisily break	
	local rc = c(rc)
	SetDepvar `depvars'
	capture mata: rmexternal("`inits'")	
} // nobreak
		exit `rc'
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

	local myopts P11 P01 P10 P00 PMargin PSel PCond XB STDP XBSel STDPSel


		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
			/* takes advantage that -myopts- produces error
			 * if -eq()- specified w/ other that xb and stdp */

	_pred_se "`myopts'" `0'
	if `s(done)' { exit }
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'


		/* Step 3:
			Parse your syntax.
		*/

	syntax [if] [in] [, `myopts' CONstant(varname numeric) noOFFset]


		/* Step 4:
			Concatenate switch options together
		*/

	local type  `p11'`p01'`p10'`p00'`pmargin'`pcond'`xb'`psel'
	local type  `type'`xbsel'`stdp'`stdpsel'
	local args


		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/


	tokenize `e(depvar)'
	local depname `1'
	local selname = cond("`2'"=="", "select", "`2'")
	if "`constan'" != "" { local constan "constant(`constan')" }
	if "`selcons'" != "" { local selcons "constant(`selcons')" }

	tempvar xb zg
	tempname r
	qui _predict double `xb' `if' `in', eq(#1) `offset' `constan'
	qui _predict double `zg' `if' `in', eq(#2) `offset' `selcons'
	if `:colnfreeparms e(b)' {
		scalar `r' = _b[/athrho]
	}
	else {
		scalar `r' = [athrho]_b[_cons]
	}
	scalar `r' = (expm1(2*`r'))/(exp(2*`r')+1)
	

	if ("`type'"=="" | "`type'" == "pmargin") & `"`args'"'=="" {
		if "`type'" == "" {
			di in smcl in gr ///
			"(option {bf:pmargin} assumed; Pr(`depname'=1))"
		}
		gen `vtyp' `varn' = normprob(`xb')
		label var `varn' "Pr(`depname'=1)"
		exit
	}

		/* Step 6:
			mark sample (this is not e(sample)).
		*/
	marksample touse


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


				/* P11 */
	if "`type'"=="p11" {
		gen `vtyp' `varn' = binorm(`xb',`zg',`r')
		label var `varn' "Pr(`depname'=1,`selname'=1)"
		exit
	}
				/* P01 */
	if "`type'"=="p01" {
		gen `vtyp' `varn' = binorm(-`xb',`zg',-`r')
		label var `varn' "Pr(`depname'=0,`selname'=1)"
		exit
	}
				/* P10 */
	if "`type'"=="p10" {
		gen `vtyp' `varn' = binorm(`xb',-`zg',-`r')
		label var `varn' "Pr(`depname'=1,`selname'=0)"
		exit
	}
				/* P00 */
	if "`type'"=="p00" {
		gen `vtyp' `varn' = binorm(-`xb',-`zg',`r')
		label var `varn' "Pr(`depname'=0,`selname'=0)"
		exit
	}
				/* PCOND */
	if "`type'"=="pcond" {
		gen `vtyp' `varn' = binorm(`xb',`zg',`r')/normprob(`zg')
		label var `varn' "Pr(`depname'=1|`selname'=1)"
		exit
	}
				/* linear predictor for equation 1 */
	if "`type'" == "xb" {	
		gen `vtyp' `varn' = `xb'
		label var `varn' "Linear prediction of `depname'"
		exit
	}
				/* Probit index standard error */
	if "`type'" == "stdp" { 
		_predict `vtyp' `varn', stdp eq(#1) `offset' `constan', /*
			*/ if `touse'
		label var `varn' "S.E. of prediction of `depname'"
		exit
	}
				/* Selection index standard error */
	if "`type'" == "stdpsel" { 
		_predict `vtyp' `varn', stdp eq(#2) `offset' `selcons', /*
			*/ if `touse'
		label var `varn' "S.E. of prediction of `selname'"
		exit
	}

				/* Selection index */
	if "`type'" == "xbsel" { 
		gen `vtyp' `varn' = `zg'
		label var `varn' "Linear prediction of `selname'"
		exit
	}
				/* Probability observed, from selection 
				 * equation */
	if "`type'" == "psel" {
		gen `vtyp' `varn' = normprob(`zg')
		label var `varn' "Pr(`selname')"
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

program SetDepvar, eclass
	version 9
	ereturn local depvar `0'
end

