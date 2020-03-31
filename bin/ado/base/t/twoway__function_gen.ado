*! version 1.2.0  28jan2015
// parse and optionally generate variables for -graph twoway function-
program twoway__function_gen, rclass sortpreserve
	version 8.0

	syntax anything(id="expression"		///
			name=expofx		///
			equalok			///
		)				///
		[if],				///
		Range(string asis)		///
		Xis(name)			///
		[				///
		ALLOWEMPTYRANGE			///
		N(integer 1)			///
		GENerate(string asis)		///
		DROPlines(numlist sort)		///
	]

//	preserve, changed
	CheckGenOpt `generate'
	local generate `s(varlist)'
	if `"`generate'"' != "" & `"`s(replace)'"' == "" {
		confirm new var `generate'
	}

	/* parse the expression (in `expofx'):
	 *
	 * 	[[<y>] =] <expression>
	 *
	 * note: we cannot use "= exp" because <expression> is a function of
	 * "X" (or something else) which is to be created/substituted later
	 *
	 * note: the name <y> is returned in r(yis)
	 */

	gettoken y : expofx , parse(" =")
	capture confirm name `y'
	if !_rc {
		gettoken y expofx : expofx , parse(" =")
		gettoken equal expofx : expofx , parse("=")
		if `"`equal'"' != "=" {
			if `"`expofx'"' == "" {
				local expofx `y'
				local y
			}
			else {
				di as err ///
				`"\'`equal'\' found where '=' expected"'
				exit 111
			}
		}
	}
	else if `"`y'"' == "=" {
		gettoken y expofx : expofx , parse("=")
		local y
	}
	else {
		local y
	}
	if `"`expofx'"' == "" {
		di as err `"nothing found where expression expected"'
		exit 111
	}
	if `"`y'"' == "" {
		local y y
	}

	if `"`range'"' != "" {
		capture confirm name `range'
		if !_rc {
			capture confirm numeric var `range'
			local range_isvar 1
		}
		else {
			CheckRange , range(`range')
			local range_isvar 0
		}
	}
	if `n' < 1 {
		di as err "option n() requires a positive integer"
		exit 198
	}

	if `"`xvarformat'`yvarformat'"' != "" {
		tempvar x
		if _N == 0 {
			qui set obs 1
		}
		qui gen byte `x' = 0
		if `"`xvarformat'"' != "" {
			format `xvarformat' `x'
		}
		if `"`yvarformat'"' != "" {
			format `yvarformat' `x'
		}
		qui drop `x'
	}

	// Saved results
	if `range_isvar' {
		sum `range' `if', mean
		if r(N) == 0 {
			if "`allowemptyrange'" == "" {
				error 2000
			}
		}
		return scalar min = r(min)
		return scalar max = r(max)
	}
	else {
		tokenize `range'
		return scalar min = `1'
		return scalar max = `2'
	}
	if `n' == 1 {
		return scalar delta = .		// on purpose
	}
	else	return scalar delta = (return(max)-return(min))/(`n'-1)
	return scalar n = `n'
	return local xvarformat `"`xvarformat'"'
	return local yvarformat `"`yvarformat'"'
	return local range `"`range'"'
	return local exp `"`: list retok expofx'"'
	return local xis `xis'
	return local yis `y'

	if `"`droplines'"' != "" {
		local ndrops : word count `droplines'
	}
	else	local ndrops 0

	if _N < `n' {
		return local preserve "preserve"
	}

quietly {

	if `"`droplines'"' != "" {
		if _N < `ndrops' {
			preserve
			local restore restore
			set obs `ndrops'
		}
		tempvar ydrop xdrop hold
		gen `xdrop' = .
		tokenize `droplines'
		forval i = 1/`ndrops' {
			replace `xdrop' = ``i'' in `i'
		}
		sum `xdrop', mean
		if r(min) < `return(min)' | `return(max)' < r(max) {
			di as err ///
			"some droplines not within range() option"
			exit 198
		}
		capture unab xfull : `xis'
		if "`xfull'" != "" {
			capture rename `xfull' `hold'
		}
		capture {
			rename `xdrop' `xis'
			if "`._Gr_Global.isa'" != "" {
				local callerver = string(`._Gr_Global.callerver')
			}

			
			if "`callerver'" != "" {
				version `callerver': GenData double `ydrop' = `expofx' in 1/`ndrops'
			}
			else {
				gen double `ydrop' = `expofx' in 1/`ndrops'			
			}
			rename `xis' `xdrop'
		}
		local rc = _rc
		if "`xfull'" != "" {
			capture rename `hold' `xfull'
		}
		if `rc' {
			di as err `"error in expression: `expofx'"'
			exit `rc'
		}
		// build the dropline "x y" pairs
		local drop_xy
		forval i = 1/`ndrops' {
			local xx = `xdrop'[`i']
			local yy = `ydrop'[`i']
			local drop_xy `"`drop_xy' "`xx' `yy'""'
		}
		return local dropxy `"`: list retok drop_xy'"'
		if `"`restore'"' != "" {
			`restore'
			local restore
		}
	}

} // quietly

	// parsing is finished, so exit if no variables to generate

	if (`"`generate'"' == "") exit

quietly {

	/* check the current number of observations here instead of above; it
	 * is irrelevant if variables are not being generated
	 */

	if _N < `n' {
		set obs `n'
	}

	// generate variables
	tempvar y x hold
	gen double `x' = return(min) in 1
	if `n' >= 2 {
		replace `x' = return(min) + return(delta)*(_n-1) in 2/`n'
	}
	local xfull
	capture unab xfull : `xis'
	if "`xfull'" != "" {
		capture rename `xfull' `hold'
	}
	capture  {
		rename `x' `xis'
		if "`._Gr_Global.isa'" != "" {
			local callerver = string(`._Gr_Global.callerver')
		}
					
		if "`callerver'" != "" {
		
			version `callerver': GenData double `y' = `expofx' in 1/`n'
		}
		else {
			gen double `y' = `expofx' in 1/`n'
		}
		
		rename `xis' `x'
	}
	local rc = _rc
	if "`xfull'" != "" {
		capture rename `hold' `xfull'
	}
	if `rc' {
		di as err `"error in expression: `expofx'"'
		exit `rc'
	}

} // quietly

	// we wouldn't be here if `generate' was empty
	tokenize `generate'
	capture drop `1'
	capture drop `2'
	rename `y' `1'
	rename `x' `2'
end

/* parse the contents of the -generate- option:
 * generate(y x [, replace])
 */

program CheckGenOpt, sclass
	syntax [namelist] [, replace ]

	if `"`replace'`namelist'"' != "" {
		if 0`:word count `namelist'' != 2 {
			di as err "option generate() incorrectly specified"
			exit 198
		}
	}
	sreturn clear
	sreturn local varlist `namelist'
	sreturn local replace `replace'
end

program CheckRange
	cap syntax , range(numlist min=2 max=2 sort)
	local rc = _rc
	if _rc {
		di as err ///
		"option range() requires two numbers"
		exit `rc'
	}
end

program GenData
	gen `0'
end

exit
