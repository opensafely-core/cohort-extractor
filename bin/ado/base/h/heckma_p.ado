*! version 3.4.2  19feb2019
program define heckma_p
	version 8.0, missing

	syntax [anything] [if] [in] [, SCores SCORESEL * ]
	if `"`scores'`scoresel'"' != "" {
		if "`e(method)'" != "ml" {
			local scores : word 1 of `scores' `scoresel'
			di as err ///
"option `scores' is not allowed with `e(method)' results"
			exit 198
		}
		if "`scoresel'" != "" {
			local scores scores
			local eq eq(#2)
		}
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
		ml score `anything' if `touse', `scores' `eq' missing	///
			`options'
		exit
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

	local myopts YCond E(string) YExpected Mills NShazard Pr(string) /*
		*/ SELconst(varname numeric) PSel STDPSel XBSel  /*
		*/ STDF YStar(string) d1(string) d2(string)


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

	if "`e(prefix)'" == "svy" {
		_prefix_nonoption after svy estimation, `stdf'
	}

	if "`nshazard'" != "" & "`mills'" != "" {
		local mills
		di in blue "options nshazard and mills are synonyms, " /*
			*/ "mills ignored."
	}


		/* Step 4:
			Concatenate switch options together
		*/

	local type  `ycond'`yexpect'`mills'`nshazard'`psel'/*
		*/`xbsel'`stdpsel'`stdf'
	local args `"`pr'`e'`ystar'"'

	if `"`d1'`d2'"' != "" {
		if `"`d1'"' == "" & `"`d2'"' != "" {
			version 15: ///
			di as err "option {bf:d2()} requires option {bf:d1()}"
			exit 198
		}
		if `"`args'"' != "" {
			version 15: di as err ///
			"option {bf:d1()} not allowed with option {bf:`args'}"
			exit 198
		}
		if !inlist(`"`type'"',	"psel", ///
					"ycond", ///
					"yexpected", ///
					"mills", ///
					"nshazard") {
			if `"`type'"' == "" {
				local type xb
			}
			version 15: di as err ///
			"option {bf:d1()} not allowed with option {bf:`type'}"
			exit 198
		}
	}

		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/

	if "`constan'" != "" { local constan "constant(`constan')" }

	if "`type'"=="" & `"`args'"'=="" {
		version 15: ///
		di in gr "(option {bf:xb} assumed; fitted values)"
		_predict `vtyp' `varn' `if' `in', `offset' `constan'
		exit
	}

		/* Step 6: was
			mark sample (this is not e(sample)).
		*/


		/* Step 7:
			handle options that take argument one at a time.
			Comment if restricted to e(sample).
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/

	tempname sigma rho lambda drho d2rho
	if "`e(method)'"=="ml" | bsubstr("`e(cmd)'",1,3) == "svy" ///
	 | `"`e(prefix)'"' == "svy" {
		if `:colnfreeparms e(b)' {
			local tau _b[/athrho]
		}
		else 	{
			local tau [athrho]_b[_cons]
		}
		scalar `rho' = (expm1(2*`tau')) / (exp(2*`tau')+1)
		if `:colnfreeparms e(b)' {
			scalar `sigma' = exp(_b[/lnsigma])
		}
		else {
			scalar `sigma' = exp([lnsigma]_b[_cons])
		}
		scalar `lambda' = `rho'*`sigma'
		tempname er
		scalar `er' = exp(2*`tau')
		scalar `drho' = 4*`er'/((`er'+1)*(`er'+1))
		scalar `d2rho' = -2*`drho'*`rho'
	}
	else {
		scalar `rho' = e(rho)
		scalar `sigma' = e(sigma)
		scalar `lambda' = e(lambda)
		scalar `drho' = 0
		scalar `d2rho' = 0
	}
	
	if `"`args'"'!="" {
		if "`type'"!="" { error 198 }
		marksample touse
		regre_p2 "`vtyp'" "`varn'" "`touse'" "`offset'" `"`pr'"'  /*
			*/ `"`e'"' `"`ystar'"' "`sigma'" "`constan'"
		exit
	}


		/* Step 8:
			handle switch options that can be used in-sample or 
			out-of-sample one at a time.
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/



				/* Set up varnames and select constant
				 * option. */
	tokenize `e(depvar)'
	local depname `1'
	local selname = cond("`2'"=="", "select", "`2'")
	if "`selcons'" != "" { local selcons "constant(`selcons')" }

				/* Selection index standard error */
	if "`type'" == "stdpsel" { 
		marksample touse
		_predict `vtyp' `varn', stdp eq(#2) `offset' `selcons', /*
			*/ if `touse'
		label var `varn' "S.E. of prediction of `selname'"
		exit
	}

				/* Get selection model index, required 
				 * for all remaining options */

				/* Selection index */
	if "`type'" == "xbsel" { 
		_predict `vtyp' `varn' `if' `in', xb eq(#2) `offset' `selcons'
		label var `varn' "Linear prediction of `selname'"
		exit
	}

	tempvar Xbprb Xb 
	qui _predict double `Xbprb' `if' `in', xb eq(#2) `offset' `selcons'


				/* Probability observed, from selection 
				 * equation */
	if "`type'" == "psel" {
		if `"`d1'`d2'"' == "#2#2" {
			gen `vtyp' `varn' = -`Xbprb'*normalden(`Xbprb') `if' `in'
			label var `varn' ///
			"d2 Pr(`selname') / d xb(`selname') d xb(`selname')"
		}
		else if `"`d1'`d2'"' == "#2" {
			gen `vtyp' `varn' = normalden(`Xbprb') `if' `in'
			label var `varn' "d Pr(`selname') / d xb(`selname')"
		}
		else if `"`d1'`d2'"' == "" {
			gen `vtyp' `varn' = normal(`Xbprb') `if' `in'
			label var `varn' "Pr(`selname')"
		}
		else {
			gen `vtyp' `varn' = 0 `if' `in'
			if "`d2'" != "" {
				label var `varn' ///
			"d2 Pr(`selname') / d xb(`d1') d xb(`d2')"
			}
			else {
				label var `varn' ///
				"d Pr(`selname') / d xb(`d1')"
			}
		}
		exit
	}

				/* Get the model index (Xb), 
				 * required for all remaining options */

	marksample touse
	qui _predict double `Xb', xb `offset' `constan', if `touse'

				/* E(y)|observed */
	if "`type'" == "ycond" {
		tempname pdf cdf
		qui gen double `pdf' = normalden(`Xbprb') `if' `in'
		qui gen double `cdf' = normal(`Xbprb') `if' `in'
		local pred "E(`depname'|Zg>0)"
		if inlist("#4#4", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				`sigma' * `rho' * `pdf' / `cdf' ///
				`if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#3#4", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				`sigma' * `drho' * `pdf' / `cdf' ///
				`if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#3#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				`sigma' * `d2rho' * `pdf' / `cdf' ///
				`if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#2#4", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = `sigma' * `rho' * ( ///
				- `Xbprb' * `pdf' / `cdf' ///
				- `pdf'*`pdf' / (`cdf'*`cdf') ///
				) `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#2#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = `sigma' * `drho' * ( ///
				- `Xbprb' * `pdf' / `cdf' ///
				- `pdf'*`pdf' / (`cdf'*`cdf') ///
				) `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#2#2", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = `sigma' * `rho' * ( ///
				- `pdf' / `cdf' ///
				+ `Xbprb'*`Xbprb' * `pdf' / `cdf' ///
				+ 3*`Xbprb'*`pdf'*`pdf' / (`cdf'*`cdf') ///
				+ 2*`pdf'*`pdf'*`pdf' / (`cdf'*`cdf'*`cdf') ///
				) `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#4", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' =  0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' =  0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#2", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' =  0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#1", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' =  0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'`d2'"' == "#4" {
			gen `vtyp' `varn' = ///
				`sigma' * `rho' * `pdf' / `cdf' ///
				`if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'`d2'"' == "#3" {
			gen `vtyp' `varn' = ///
				`sigma' * `drho' * `pdf' / `cdf' ///
				`if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'`d2'"' == "#2" {
			gen `vtyp' `varn' = `sigma' * `rho' * ( ///
				- `Xbprb' * `pdf' / `cdf' ///
				- `pdf'*`pdf' / (`cdf'*`cdf') ///
				) `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'`d2'"' == "#1" {
			gen `vtyp' `varn' =  1 `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else {
			gen `vtyp' `varn' = ///
				`Xb' + `sigma' * `rho' * `pdf' / `cdf' ///
				`if' `in'
			label var `varn' "`pred'"
		}
		exit
	}

				/* E(y) if unobserved y_i taken to be 0 */
	if "`type'" == "yexpected" {
		tempname pdf cdf
		qui gen double `pdf' = normalden(`Xbprb') `if' `in'
		qui gen double `cdf' = normal(`Xbprb') `if' `in'
		local pred "E(`depname'*|Pr(`selname'))"
		if inlist("#4#4", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				`sigma' * `rho' * `pdf' ///
				`if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#3#4", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				`sigma' * `drho' * `pdf' ///
				`if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#3#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				`sigma' * `drho' * `pdf' ///
				`if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#2#4", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				- `sigma' * `rho' * `Xbprb' * `pdf' ///
				`if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#2#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				- `sigma' * `drho' * `Xbprb' * `pdf' ///
				`if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#2#2", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				- `Xb' * `Xbprb' * `pdf' ///
				- `sigma' * `rho' * `pdf' ///
				+ `sigma' * `rho' * `Xbprb'*`Xbprb' * `pdf' ///
				`if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#4", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' =  0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' =  0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#2", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' =  `pdf' `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#1", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' =  0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'`d2'"' == "#4" {
			gen `vtyp' `varn' = ///
				`sigma' * `rho' * `pdf' ///
				`if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'`d2'"' == "#3" {
			gen `vtyp' `varn' = ///
				`sigma' * `drho' * `pdf' ///
				`if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'`d2'"' == "#2" {
			gen `vtyp' `varn' = ///
				`Xb' * `pdf' ///
				- `sigma' * `rho' * `Xbprb' * `pdf' ///
				`if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'`d2'"' == "#1" {
			gen `vtyp' `varn' =  `cdf' `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else {
			gen `vtyp' `varn' = ///
				`Xb' * `cdf' ///
				+ `sigma' * `rho' * `pdf' ///
				`if' `in'
			label var `varn' "`pred'"
		}
		exit
	}

				/* Mills' ratio */
	if "`type'" == "mills" | "`type'" == "nshazard" {
		tempname pdf cdf
		qui gen double `pdf' = normalden(`Xbprb') `if' `in'
		qui gen double `cdf' = normal(`Xbprb') `if' `in'
		local pred "Mills' ratio"
		if inlist("#4#4", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				`sigma' * `rho' * `pdf' ///
				`if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#3#4", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = 0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#3#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = 0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#2#4", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = 0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#2#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = 0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#2#2", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				- `pdf' / `cdf' ///
				+ `Xbprb'*`Xbprb' * `pdf' / `cdf' ///
				+ 3*`Xbprb' * `pdf'*`pdf' / (`cdf'*`cdf') ///
				+ 2*`pdf'*`pdf'*`pdf' / (`cdf'*`cdf'*`cdf') ///
				`if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#4", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' =  0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' =  0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#2", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = 0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#1", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = 0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'`d2'"' == "#4" {
			gen `vtyp' `varn' = 0 `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'`d2'"' == "#3" {
			gen `vtyp' `varn' = 0 `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'`d2'"' == "#2" {
			gen `vtyp' `varn' = ///
				- `Xbprb' * `pdf' / `cdf' ///
				- `pdf' * `pdf' / (`cdf'*`cdf') ///
				`if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'`d2'"' == "#1" {
			gen `vtyp' `varn' = 0 `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else {
			gen `vtyp' `varn' = ///
				`pdf' / `cdf' ///
				`if' `in'
			label var `varn' "`pred'"
		}
		exit
	}


	if "`type'"=="stdf" {
		tempvar stdp
		qui _predict double `stdp' if `touse', stdp `offset' `constan'
		gen `vtyp' `varn' = sqrt(`stdp'^2 + `sigma'^2) if `touse'
		label var `varn' "S.E. of the forecast"
		exit
	}


		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/
	*qui replace `touse'=0 if !e(sample)


			/* Step 10.
				Issue r(198), syntax error.
				The user specified more than one option
			*/
	error 198
end

