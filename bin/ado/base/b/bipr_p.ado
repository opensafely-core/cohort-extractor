*! version 1.4.2  15oct2019
program define bipr_p
	version 6, missing

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		ml score `0'
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

	local myopts P11 P01 P10 P00 PMARG1 PMARG2 XB1 XB2 
	local myopts `myopts' STDP1 STDP2 PCOND1 PCOND2 
	local myopts `myopts' d1(string) d2(string)


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

	syntax [if] [in] [, `myopts' noOFFset]


		/* Step 4:
			Concatenate switch options together
		*/

	local type  `p11'`p01'`p10'`p00'`pmarg1'`pmarg2'`xb1'`xb2'
	local type  `type'`stdp1'`stdp2'`pcond1'`pcond2'`psel1'`psel2'
	local args

	if `"`d1'`d2'"' != "" {
		if `"`d1'"' == "" & `"`d2'"' != "" {
			version 15
			di as err "option {bf:d2()} requires option {bf:d1()}"
			exit 198
		}
		if !inlist(`"`type'"', "", "p11", "p01", "p10", "p00", ///
					   "pmarg1", "pmarg2", ///
					   "pcond1", "pcond2") {
			version 15
			di as err ///
			"option {bf:d1()} not allowed with option {bf:`type'}"
			exit 198
		}
		if !inlist(`"`d1'"', "#1", "#2", "#3") {
			version 15
			di as err "option {bf:d1()} invalid;"
			di as err "{bf:`d1'} does not specify an equation index"
			exit 198
		}
		else if !inlist(`"`d2'"', "", "#1", "#2", "#3") {
			version 15
			di as err "option {bf:d2()} invalid;"
			di as err "{bf:`d2'} does not specify an equation index"
			exit 198
		}
	}

		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option.
		*/


	tokenize `e(depvar)'
	local dep1 `1'
	local dep2 `2'

	tempvar xb zg
	tempname r er
	if `:colnfreeparms e(b)' {
		scalar `r' = _b[/athrho]
	}
	else {
		scalar `r' = [athrho]_b[_cons]
	}
	scalar `er' = exp(2*`r')
	scalar `r' = (`er'-1)/(`er'+1)
	if `"`d1'`d2'"' != "" {
		tempname s dr d2r
		scalar `s' = sqrt(1-`r'*`r')
		scalar `dr' = 4*`er'/((`er'+1)*(`er'+1))
		scalar `d2r' = -2*`dr'*`r'
	}

				/* P11 */
	if ("`type'"=="" | "`type'" == "p11") & `"`args'"'=="" {
		if "`type'" == "" {
			version 15: di in gr "(option {bf:p11} assumed; Pr(`dep1'=1,`dep2'=1))"
		}
		local pred "Pr(`dep1'=1,`dep2'=1)"
		qui _predict double `xb' `if' `in', eq(#1) `offset' 
		qui _predict double `zg' `if' `in', eq(#2) `offset'
		if `"`d1'`d2'"' == "#1#1" {
			local q (`zg' - `r'*`xb')/`s'
			gen `vtyp' `varn' = ///
			- normalden(`q') * (`r'/`s') * normalden(`xb') ///
			- normal(`q') * `xb' * normalden(`xb') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#2", `"`d1'`d2'"', `"`d2'`d1'"') {
			local q (`zg' - `r'*`xb')/`s'
			gen `vtyp' `varn' = ///
			normalden(`q') * normalden(`xb') / `s' `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			local dq (2*`xb' - 2*`r'*`zg')
			gen `vtyp' `varn' =				///
				`dr'* exp(-`q'/(2*`s'*`s')) *		///
				(-`dq'/(2*`s'*`s')) /			///
				(2*c(pi)*`s') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'`d2'"' == "#2#2" {
			local q (`xb' - `r'*`zg')/`s'
			gen `vtyp' `varn' = ///
			- normalden(`q') * (`r'/`s') * normalden(`zg') ///
			- normal(`q') * `zg' * normalden(`zg') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#2#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			local dq (2*`zg' - 2*`r'*`xb')
			gen `vtyp' `varn' =				///
				`dr'* exp(-`q'/(2*`s'*`s')) *		///
				(-`dq'/(2*`s'*`s')) /			///
				(2*c(pi)*`s') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'`d2'"' == "#3#3" {
			// there are no predictors in this equation, so
			// -margins- will never need anything other than 0
			gen `vtyp' `varn' = 0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'"' == "#1" {
			local q (`zg' - `r'*`xb')/`s'
			gen `vtyp' `varn' = ///
			normal(`q') * normalden(`xb') `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'"' == "#2" {
			local q (`xb' - `r'*`zg')/`s'
			gen `vtyp' `varn' = ///
			normal(`q') * normalden(`zg') `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'"' == "#3" {
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			gen `vtyp' `varn' = ///
			`dr'*exp(-`q'/(2*`s'*`s'))/(2*c(pi)*`s') `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else {
			gen `vtyp' `varn' = binorm(`xb',`zg',`r') `if' `in'
			label var `varn' "`pred'"
		}
		exit
	}


		/* Step 6:
			mark sample (this is not e(sample)).
		*/


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

				/* pmarg1 */
	if "`type'" == "pmarg1" {
		qui _predict double `xb' `if' `in', eq(#1) `offset' 
		if `"`d1'`d2'"' == "#1#1" {
			gen `vtyp' `varn' = -`xb'*normalden(`xb') `if' `in'
			label var `varn' ///
			"d2 Pr(`dep1'=1) / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'`d2'"' == "#1" {
			gen `vtyp' `varn' = normalden(`xb') `if' `in'
			label var `varn' "d Pr(`dep1'=1) / d xb(`d1')"
		}
		else if `"`d1'`d2'"' == "" {
			gen `vtyp' `varn' = normal(`xb') `if' `in'
			label var `varn' "Pr(`dep1'=1)"
		}
		else {
			gen `vtyp' `varn' = 0 `if' `in'
			if "`d2'" != "" {
				label var `varn' ///
				"d2 Pr(`dep1'=1) / d xb(`d1') d xb(`d2')"
			}
			else {
				label var `varn' ///
				"d Pr(`dep1'=1) / d xb(`d1')"
			}
		}
		exit
	}
				/* pmarg2 */
	if "`type'" == "pmarg2" {
		qui _predict double `zg' `if' `in', eq(#2) `offset' 
		if `"`d1'`d2'"' == "#2#2" {
			gen `vtyp' `varn' = -`zg'*normalden(`zg') `if' `in'
			label var `varn' ///
			"d2 Pr(`dep2'=1) / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'`d2'"' == "#2" {
			gen `vtyp' `varn' = normalden(`zg') `if' `in'
			label var `varn' "d Pr(`dep2'=1) / d xb(`d1')"
		}
		else if `"`d1'`d2'"' == "" {
			gen `vtyp' `varn' = normal(`zg') `if' `in'
			label var `varn' "Pr(`dep2'=1)"
		}
		else {
			gen `vtyp' `varn' = 0 `if' `in'
			if "`d2'" != "" {
				label var `varn' ///
				"d2 Pr(`dep2'=1) / d xb(`d1') d xb(`d2')"
			}
			else {
				label var `varn' ///
				"d Pr(`dep2'=1) / d xb(`d1')"
			}
		}
		exit
	}
				/* P01 */
	if "`type'"=="p01" {
		qui _predict double `xb' `if' `in', eq(#1) `offset' 
		qui _predict double `zg' `if' `in', eq(#2) `offset'
		local pred "Pr(`dep1'=0,`dep2'=1)"
		if `"`d1'`d2'"' == "#1#1" {
			local q (`zg' - `r'*`xb')/`s'
			gen `vtyp' `varn' = ///
			  normalden(`q') * (`r'/`s') * normalden(`xb') ///
			+ normal(`q') * `xb' * normalden(`xb') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#2", `"`d1'`d2'"', `"`d2'`d1'"') {
			local q (`zg' - `r'*`xb')/`s'
			gen `vtyp' `varn' = ///
			- normalden(`q') * normalden(`xb') / `s' `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			local dq (2*`xb' - 2*`r'*`zg')
			gen `vtyp' `varn' =				///
				-`dr'*exp(-`q'/(2*`s'*`s')) *		///
				(-`dq'/(2*`s'*`s')) /			///
				(2*c(pi)*`s') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'`d2'"' == "#2#2" {
			local q (-`xb' + `r'*`zg')/`s'
			gen `vtyp' `varn' = ///
			  normalden(`q') * (`r'/`s') * normalden(`zg') ///
			- normal(`q') * `zg' * normalden(`zg') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#2#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			local dq (2*`zg' - 2*`r'*`xb')
			gen `vtyp' `varn' =				///
				- `dr'*exp(-`q'/(2*`s'*`s')) *		///
				(-`dq'/(2*`s'*`s')) /			///
				(2*c(pi)*`s') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'`d2'"' == "#3#3" {
			// there are no predictors in this equation, so
			// -margins- will never need anything other than 0
			gen `vtyp' `varn' = 0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'"' == "#1" {
			local q (`zg' - `r'*`xb')/`s'
			gen `vtyp' `varn' = ///
			- normal(`q') * normalden(`xb') `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'"' == "#2" {
			local q (-`xb' + `r'*`zg')/`s'
			gen `vtyp' `varn' = ///
			normal(`q') * normalden(`zg') `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'"' == "#3" {
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			gen `vtyp' `varn' = ///
			-`dr'*exp(-`q'/(2*`s'*`s'))/(2*c(pi)*`s') `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else {
			gen `vtyp' `varn' = binorm(-`xb',`zg',-`r') `if' `in'
			label var `varn' "`pred'"
		}
		exit
	}
				/* P10 */
	if "`type'"=="p10" {
		local pred "Pr(`dep1'=1,`dep2'=0)"
		qui _predict double `xb' `if' `in', eq(#1) `offset' 
		qui _predict double `zg' `if' `in', eq(#2) `offset'
		if `"`d1'`d2'"' == "#1#1" {
			local q (-`zg' + `r'*`xb')/`s'
			gen `vtyp' `varn' = ///
			  normalden(`q') * (`r'/`s') * normalden(`xb') ///
			- normal(`q') * `xb' * normalden(`xb') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#2", `"`d1'`d2'"', `"`d2'`d1'"') {
			local q (-`zg' + `r'*`xb')/`s'
			gen `vtyp' `varn' = ///
			- normalden(`q') * normalden(`xb') / `s' `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			local dq (2*`xb' - 2*`r'*`zg')
			gen `vtyp' `varn' =				///
				-`dr'* exp(-`q'/(2*`s'*`s')) *		///
				(-`dq'/(2*`s'*`s')) /			///
				(2*c(pi)*`s') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'`d2'"' == "#2#2" {
			local q (`xb' - `r'*`zg')/`s'
			gen `vtyp' `varn' = ///
			  normalden(`q') * (`r'/`s') * normalden(`zg') ///
			+ normal(`q') * `zg' * normalden(`zg') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#2#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			local dq (2*`zg' - 2*`r'*`xb')
			gen `vtyp' `varn' =				///
				-`dr'* exp(-`q'/(2*`s'*`s')) *		///
				(-`dq'/(2*`s'*`s')) /			///
				(2*c(pi)*`s') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'`d2'"' == "#3#3" {
			// there are no predictors in this equation, so
			// -margins- will never need anything other than 0
			gen `vtyp' `varn' = 0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'"' == "#1" {
			local q (-`zg' + `r'*`xb')/`s'
			gen `vtyp' `varn' = ///
			normal(`q') * normalden(`xb') `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'"' == "#2" {
			local q (`xb' - `r'*`zg')/`s'
			gen `vtyp' `varn' = ///
			- normal(`q') * normalden(`zg') `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'"' == "#3" {
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			gen `vtyp' `varn' = ///
			-`dr'*exp(-`q'/(2*`s'*`s'))/(2*c(pi)*`s') `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else {
			gen `vtyp' `varn' = binorm(`xb',-`zg',-`r') `if' `in'
			label var `varn' "`pred'"
		}
		exit
	}
				/* P00 */
	if "`type'"=="p00" {
		local pred "Pr(`dep1'=0,`dep2'=0)"
		qui _predict double `xb' `if' `in', eq(#1) `offset' 
		qui _predict double `zg' `if' `in', eq(#2) `offset'
		if `"`d1'`d2'"' == "#1#1" {
			local q (-`zg' + `r'*`xb')/`s'
			gen `vtyp' `varn' = ///
			- normalden(`q') * (`r'/`s') * normalden(`xb') ///
			+ normal(`q') * `xb' * normalden(`xb') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#2", `"`d1'`d2'"', `"`d2'`d1'"') {
			local q (-`zg' + `r'*`xb')/`s'
			gen `vtyp' `varn' = ///
			normalden(`q') * normalden(`xb') / `s' `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#1#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			local dq (2*`xb' - 2*`r'*`zg')
			gen `vtyp' `varn' =				///
				`dr'* exp(-`q'/(2*`s'*`s')) *		///
				(-`dq'/(2*`s'*`s')) /			///
				(2*c(pi)*`s') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'`d2'"' == "#2#2" {
			local q (-`xb' + `r'*`zg')/`s'
			gen `vtyp' `varn' = ///
			- normalden(`q') * (`r'/`s') * normalden(`zg') ///
			+ normal(`q') * `zg' * normalden(`zg') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if inlist("#2#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			local dq (2*`zg' - 2*`r'*`xb')
			gen `vtyp' `varn' =				///
				`dr'* exp(-`q'/(2*`s'*`s')) *		///
				(-`dq'/(2*`s'*`s')) /			///
				(2*c(pi)*`s') `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'`d2'"' == "#3#3" {
			// there are no predictors in this equation, so
			// -margins- will never need anything other than 0
			gen `vtyp' `varn' = 0 `if' `in'
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'"' == "#1" {
			local q (-`zg' + `r'*`xb')/`s'
			gen `vtyp' `varn' = ///
			- normal(`q') * normalden(`xb') `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'"' == "#2" {
			local q (-`xb' + `r'*`zg')/`s'
			gen `vtyp' `varn' = ///
			- normal(`q') * normalden(`zg') `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else if `"`d1'"' == "#3" {
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			gen `vtyp' `varn' = ///
			`dr'*exp(-`q'/(2*`s'*`s'))/(2*c(pi)*`s') `if' `in'
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else {
			gen `vtyp' `varn' = binorm(-`xb',-`zg',`r') `if' `in'
			label var `varn' "`pred'"
		}
		exit
	}
				/* PCOND1 */
	if "`type'"=="pcond1" {
		version 15
		local pred "Pr(`dep1'=1|`dep2'=1)"
		qui _predict double `xb' `if' `in', eq(#1) `offset' 
		qui _predict double `zg' `if' `in', eq(#2) `offset'
		tempname cdf2
		qui gen double `cdf2' = normal(`zg') `if' `in'
		if inlist(`"`d1'`d2'"', "", "#2", "#2#2") {
			tempname cdf3
			qui gen double `cdf3' = binorm(`xb',`zg',`r') `if' `in'
		}
		if inlist("#1","`d1'","`d2'") {
			tempname pdf1 cdf3_d1
			qui gen double `pdf1' = normalden(`xb') `if' `in'
			local q (`zg' - `r'*`xb')/`s'
			if inlist(`"`d1'`d2'"', "#1", "#1#1", "#1#2", "#2#1") {
				qui gen double `cdf3_d1' = ///
					normal(`q')*`pdf1' `if' `in'
			}
			if "`d1'" == "`d2'" {
				tempname cdf3_d1d1
				qui gen double `cdf3_d1d1' = ///
					- normalden(`q')*`pdf1'*`r'/`s' ///
					- `xb' * `cdf3_d1' `if' `in'
			}
			if inlist("#2","`d1'","`d2'") {
				tempname cdf3_d1d2
				qui gen double `cdf3_d1d2' = ///
					normalden(`q')*`pdf1'/`s' ///
					`if' `in'
			}
		}
		if inlist("#2","`d1'","`d2'") {
			tempname pdf2 cdf3_d2
			qui gen double `pdf2' = normalden(`zg') `if' `in'
			local q (`xb' - `r'*`zg')/`s'
			if inlist(`"`d1'`d2'"', "#2", "#2#2") {
				qui gen double `cdf3_d2' = ///
					normal(`q')*`pdf2' `if' `in'
			}
			if "`d1'" == "`d2'" {
				tempname cdf3_d2d2
				qui gen double `cdf3_d2d2' = ///
					- normalden(`q')*`pdf2'*`r'/`s' ///
					- `zg' * `cdf3_d2' `if' `in'
			}
		}
		if inlist("`d1'`d2'", "#3","#2#3","#3#2") {
			tempname cdf3_d3
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			qui gen double `cdf3_d3' = ///
				`dr'*exp(-`q'/(2*`s'*`s'))/(2*c(pi)*`s') ///
				`if' `in'
		}
		if inlist("#3","`d1'","`d2'") {
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			if inlist("#1","`d1'","`d2'") {
				local dq (2*`xb' - 2*`r'*`zg')
				tempname cdf3_d3d1
				qui gen double `cdf3_d3d1' = ///
					`dr'* exp(-`q'/(2*`s'*`s')) *	///
					(-`dq'/(2*`s'*`s')) /		///
					(2*c(pi)*`s') `if' `in'
			}
			if inlist("#2","`d1'","`d2'") {
				local dq (2*`zg' - 2*`r'*`xb')
				tempname cdf3_d3d2
				qui gen double `cdf3_d3d2' = ///
					`dr'* exp(-`q'/(2*`s'*`s')) *	///
					(-`dq'/(2*`s'*`s')) /		///
					(2*c(pi)*`s') `if' `in'
			}
		}
		if `"`d1'`d2'"' == "#3#3" {
			// there are no predictors in this equation, so
			// -margins- will never need anything other than 0
			gen `vtyp' `varn' = 0 `if' `in'
		}
		else if inlist("#2#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				`cdf3_d3d2' / `cdf2' ///
				- `cdf3_d3'*`pdf2' / (`cdf2'*`cdf2') ///
				`if' `in'
		}
		else if `"`d1'`d2'"' == "#2#2" {
			gen `vtyp' `varn' = ///
				`cdf3_d2d2' / `cdf2' ///
				- `pdf2' * `cdf3_d2' / (`cdf2'*`cdf2') ///
				+ `zg'*`pdf2' * `cdf3' / (`cdf2'*`cdf2') ///
				- `pdf2' * `cdf3_d2' / (`cdf2'*`cdf2') ///
				+ 2*`pdf2'*`pdf2'* `cdf3' / ///
					(`cdf2'*`cdf2'*`cdf2') ///
				`if' `in'
		}
		else if inlist("#1#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				`cdf3_d3d1' / `cdf2' ///
				`if' `in'
		}
		else if inlist("#1#2", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				`cdf3_d1d2' / `cdf2' ///
				- `cdf3_d1'*`pdf2' / (`cdf2'*`cdf2') ///
				`if' `in'
		}
		else if `"`d1'`d2'"' == "#1#1" {
			gen `vtyp' `varn' = ///
				`cdf3_d1d1' / `cdf2' ///
				`if' `in'
		}
		else if `"`d1'"' == "#3" {
			gen `vtyp' `varn' = `cdf3_d3' /`cdf2' `if' `in'
		}
		else if `"`d1'"' == "#2" {
			gen `vtyp' `varn' = ///
				`cdf3_d2' / `cdf2' ///
				- `pdf2' * `cdf3' / (`cdf2'*`cdf2') ///
				`if' `in'
		}
		else if `"`d1'"' == "#1" {
			gen `vtyp' `varn' = ///
				`cdf3_d1' / `cdf2' ///
				`if' `in'
		}
		else {
			gen `vtyp' `varn' = ///
				`cdf3' / `cdf2' ///
				`if' `in'
		}
		if `"`d2'"' != "" {
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'"' != "" {
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else {
			label var `varn' "`pred'"
		}
		exit
	}
				/* PCOND2 */
	if "`type'"=="pcond2" {
		version 15
		local pred "Pr(`dep2'=1|`dep1'=1)"
		qui _predict double `xb' `if' `in', eq(#1) `offset' 
		qui _predict double `zg' `if' `in', eq(#2) `offset'
		tempname cdf1
		qui gen double `cdf1' = normal(`xb') `if' `in'
		if inlist(`"`d1'`d2'"', "", "#1", "#1#1") {
			tempname cdf3
			qui gen double `cdf3' = binorm(`xb',`zg',`r') `if' `in'
		}
		if inlist("#1","`d1'","`d2'") {
			tempname pdf1
			qui gen double `pdf1' = normalden(`xb') `if' `in'
			local q (`zg' - `r'*`xb')/`s'
			if inlist(`"`d1'`d2'"', "#1", "#1#1") {
				tempname cdf3_d1
				qui gen double `cdf3_d1' = ///
					normal(`q')*`pdf1' `if' `in'
			}
			if "`d1'" == "`d2'" {
				tempname cdf3_d1d1
				qui gen double `cdf3_d1d1' = ///
					- normalden(`q')*`pdf1'*`r'/`s' ///
					- `xb' * `cdf3_d1' `if' `in'
			}
			if inlist("#2","`d1'","`d2'") {
				tempname cdf3_d1d2
				qui gen double `cdf3_d1d2' = ///
					normalden(`q')*`pdf1'/`s' ///
					`if' `in'
			}
		}
		if inlist("#2","`d1'","`d2'") {
			tempname pdf2
			qui gen double `pdf2' = normalden(`zg') `if' `in'
			local q (`xb' - `r'*`zg')/`s'
			if inlist(`"`d1'`d2'"', "#2", "#1#2", "#2#1", "#2#2") {
				tempname cdf3_d2
				qui gen double `cdf3_d2' = ///
					normal(`q')*`pdf2' `if' `in'
			}
			if "`d1'" == "`d2'" {
				tempname cdf3_d2d2
				qui gen double `cdf3_d2d2' = ///
					- normalden(`q')*`pdf2'*`r'/`s' ///
					- `zg' * `cdf3_d2' `if' `in'
			}
		}
		if inlist("`d1'`d2'", "#3","#1#3","#3#1") {
			tempname cdf3_d3
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			qui gen double `cdf3_d3' = ///
				`dr'*exp(-`q'/(2*`s'*`s'))/(2*c(pi)*`s') ///
				`if' `in'
		}
		if inlist("#3","`d1'","`d2'") {
			local q (`xb'*`xb' + `zg'*`zg' - 2*`r'*`xb'*`zg')
			if inlist("#1","`d1'","`d2'") {
				local dq (2*`xb' - 2*`r'*`zg')
				tempname cdf3_d3d1
				qui gen double `cdf3_d3d1' = ///
					`dr'* exp(-`q'/(2*`s'*`s')) *	///
					(-`dq'/(2*`s'*`s')) /		///
					(2*c(pi)*`s') `if' `in'
			}
			if inlist("#2","`d1'","`d2'") {
				local dq (2*`zg' - 2*`r'*`xb')
				tempname cdf3_d3d2
				qui gen double `cdf3_d3d2' = ///
					`dr'* exp(-`q'/(2*`s'*`s')) *	///
					(-`dq'/(2*`s'*`s')) /		///
					(2*c(pi)*`s') `if' `in'
			}
		}
		if `"`d1'`d2'"' == "#3#3" {
			// there are no predictors in this equation, so
			// -margins- will never need anything other than 0
			gen `vtyp' `varn' = 0 `if' `in'
		}
		else if inlist("#2#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				`cdf3_d3d2' / `cdf1' ///
				`if' `in'
		}
		else if `"`d1'`d2'"' == "#2#2" {
			gen `vtyp' `varn' = ///
				`cdf3_d2d2' / `cdf1' ///
				`if' `in'
		}
		else if inlist("#1#3", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				`cdf3_d3d1' / `cdf1' ///
				- `pdf1' * `cdf3_d3' / (`cdf1'*`cdf1') ///
				`if' `in'
		}
		else if inlist("#1#2", `"`d1'`d2'"', `"`d2'`d1'"') {
			gen `vtyp' `varn' = ///
				`cdf3_d1d2' / `cdf1' ///
				- `pdf1' * `cdf3_d2' / (`cdf1'*`cdf1') ///
				`if' `in'
		}
		else if `"`d1'`d2'"' == "#1#1" {
			gen `vtyp' `varn' = ///
				`cdf3_d1d1' / `cdf1' ///
				- `pdf1'*`cdf3_d1' / (`cdf1'*`cdf1') ///
				+ `xb'*`pdf1' * `cdf3' / (`cdf1'*`cdf1') ///
				- `pdf1' * `cdf3_d1' / (`cdf1'*`cdf1') ///
				+ 2*`pdf1'*`pdf1'* `cdf3' / ///
					(`cdf1'*`cdf1'*`cdf1') ///
				`if' `in'
		}
		else if `"`d1'"' == "#3" {
			gen `vtyp' `varn' = `cdf3_d3' / `cdf1' `if' `in'
		}
		else if `"`d1'"' == "#2" {
			gen `vtyp' `varn' = ///
				`cdf3_d2' / `cdf1' ///
				`if' `in'
		}
		else if `"`d1'"' == "#1" {
			gen `vtyp' `varn' = ///
				`cdf3_d1' / `cdf1' ///
				- `pdf1' * `cdf3' / (`cdf1'*`cdf1') ///
				`if' `in'
		}
		else {
			gen `vtyp' `varn' = ///
				`cdf3' / `cdf1' ///
				`if' `in'
		}
		if `"`d2'"' != "" {
			label var `varn' "d2 `pred' / d xb(`d1') d xb(`d2')"
		}
		else if `"`d1'"' != "" {
			label var `varn' "d `pred' / d xb(`d1')"
		}
		else {
			label var `varn' "`pred'"
		}
		exit
	}
				/* linear predictor for equation 1 */
	if "`type'" == "xb1" {	
		_predict `vtyp' `varn' `if' `in', eq(#1) `offset' 
		label var `varn' "Linear prediction of `dep1'"
		exit
	}
				/* Probit index standard error */
	if "`type'" == "stdp1" { 
		_predict `vtyp' `varn' `if' `in', stdp eq(#1) `offset'
		label var `varn' "S.E. of prediction of `dep1'"
		exit
	}
				/* Selection index standard error */
	if "`type'" == "stdp2" { 
		_predict `vtyp' `varn' `if' `in', stdp eq(#2) `offset'
		label var `varn' "S.E. of prediction of `dep2'"
		exit
	}

				/* linear prediction for equation 2 */
	if "`type'" == "xb2" { 
		_predict `vtyp' `varn' `if' `in', eq(#2) `offset' 
		label var `varn' "Linear prediction of `dep2'"
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

