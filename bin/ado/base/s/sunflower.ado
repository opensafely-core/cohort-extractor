*! version 1.0.9  16may2014
program sunflower, sortpreserve
	version 8.0

	syntax varlist(numeric min=2 max=2)	///
		[fweight] [if] [in] [,		///
		noGRAPH				///
		noTABle				///
		BINWidth(passthru)		/// -twoway sunflower- opts
		BINAR(passthru)			///
		YCENter(passthru)		///
		XCENter(passthru)		///
		LIght(passthru)			///
		DArk(passthru)			///
		PETALWeight(passthru)		///
		PETALLength(passthru)		///
		FLOWERsonly			///
		noSINGLEpetal			///
		*				/// -graph twoway- opts
	]
	_gs_by_combine by options : `"`options'"'
	_get_gropts , grbyable			///
		totalallowed			///
		graphopts(`options' `by')	///
		getallowed(plot addplot name SAVing namear)
	local byvars	`"`s(varlist)'"'
	local byopts	`s(byopts)' `s(total)'
	local options	`"`s(graphopts)'"'
	local plot	`"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	if `"`s(name)'"' != "" {
		local name `"name(`s(name)')"'
	}
	if `"`s(saving)'"' != "" {
		local saving `"saving(`s(saving)')"'
	}
	if `"`s(namear)'"' != "" {
		local namear `"name(`s(namear)')"'
	}
	else if `"`binar'"' == "" {
		local namear `"name(`s(name)')"'
		NameOpt name `s(name)'
	}

	if "`weight'" != "" {
		local wgt [`weight'`exp']
	}
	if "`flowersonly'" != "" {
		local flowers lbcolor(none) dbcolor(none)
	}
	marksample touse

	local sf_args `varlist' `wgt' if `touse'
	local sf_opts		///
		`binwidth'	///
		\`binar'	/// possibly to be filled in later
		`ycenter'	///
		`xcenter'	///
		`light'		///
		`dark'		///
		`petalweight'	///
		`petallength'	///
		`singlepetal'	///
		// blank

	if `"`byvars'`byopts'"' != "" {
		local byopt by(`byvars', `byopts')
		local table notable
	}

	if "`graph'" == "" {
		if `"`binar'"' == "" {
			// get the current graphics setting: -on- or -off-
			local grset `c(graphics)'

capture noisily {	// make sure to restore the graphics setting

			set graphics off
			graph twoway				///
				sunflower `sf_args', `sf_opts'	///
				`namear'			///
				`byopt'				///
				`options'			///
				|| `plot' || `addplot'		///
				|| , norescaling		///
				// blank

} // capture noisily

			local rc = c(rc)

			// restore the graphics setting
			set graphics `grset'
			// exit if there was an error
			if `rc' exit `rc'

			// aspect ratio
			_sunflower_binar , `byopt' // adjust
			local binar binar(`r(binar)')
		}

		graph twoway				///
			sunflower `sf_args', `sf_opts'	///
			`byopt'				///
			`name'				///
			`saving'			///
			`flowers'			///
			`options'			///
			|| `plot' || `addplot'		///
			|| , norescaling		///
			// blank
	}

	if ("`table'" != "") local qui quietly

	`qui' DisplayTable `sf_args', `sf_opts'

end

program NameOpt
	gettoken lname 0 : 0
	capture syntax name [, REPLACE]
	if c(rc) == 0 {
		c_local `lname' name(`namelist', replace)
	}
end

program DisplayTable, rclass
	tempvar y c x
	twoway__sunflower_gen `0' generate(`y' `c' `x')
	return add

	preserve

quietly {

	summarize `c', mean
	return scalar binmax = r(max)
	if `return(pw)' < 1 {
		return scalar pw = max(1,ceil(r(max)/14))
	}

	keep if !missing(`c')
	tempvar ftype pw np nf eo ao
	gen `ftype' = (`c' >= return(light)) + (`c' >= return(dark))
	gen `nf' = cond(`ftype'==0, 0, 1)
	gen `pw' = `ftype'
	replace `pw' = return(pw) if `ftype'==2
	gen `np' = max(1,round(`c'/`pw',1))
	gen `eo' = cond(`ftype'==0, 1 ,`pw'*`np')
	gen `ao' = `c'
	sort `ftype' `pw' `np'
	collapse (sum) `nf' `eo' `ao', by(`ftype' `pw' `np')

	sum `eo', mean
	local eosum = r(sum)
	sum `ao', mean
	local aosum = r(sum)

} // quietly

	// Table header
	di as txt "Bin width"			///
			_col(20) "= " as res %9.6g `return(binwidth)'
	di as txt "Bin height"			///
			_col(20) "= " as res %9.6g `return(binheight)'
	di as txt "Bin aspect ratio"		///
			_col(20) "= " as res %9.6g `return(binar)'
	di as txt "Max obs in a bin"		///
			_col(20) "= " as res %9.6g `return(binmax)'
	di as txt "Light"			///
			_col(20) "= " as res %9.6g `return(light)'
	di as txt "Dark"			///
			_col(20) "= " as res %9.6g `return(dark)'
	di as txt "X-center"			///
			_col(20) "= " as res %9.6g `return(xc)'
	di as txt "Y-center"			///
			_col(20) "= " as res %9.6g `return(yc)'
	di as txt "Petal weight"		///
			_col(20) "= " as res %9.6g `return(pw)'

	// Table parameters
	local ncol 6
	local wcol 11
	local lw = `ncol'*`wcol'
	local skip 4
	local wfmt = `wcol' - `skip'

	// Display the Table
	di as txt "{hline `lw'}"
	di as txt			///
		%`wcol's "flower"	///
		%`wcol's "petal"	///
		%`wcol's "No. of"	///
		%`wcol's "No. of"	///
		%`wcol's "estimated"	///
		%`wcol's "actual"	///
		// blank
	di as txt			///
		%`wcol's "type"		///
		%`wcol's "weight"	///
		%`wcol's "petals"	///
		%`wcol's "flowers"	///
		%`wcol's "obs."		///
		%`wcol's "obs."		///
		// blank
	di as txt "{hline `lw'}"
	local flowertype none light dark
	forval i = 1/`=_N' {
		local ft : word `=`ftype'[`i']+1' of `flowertype'
		if "`ft'" == "none" {
			di as txt %`wcol's "`ft'"		///
					_skip(`=`wcol'*3')	///
					_skip(`skip')		///
					as res			///
					%`wfmt'.0g `eo'[`i']	///
					_skip(`skip')		///
					%`wfmt'.0g `ao'[`i']	///
					// blank
		}
		else {
			di as txt 			///
				%`wcol's "`ft'"		///
				_skip(`skip')		///
				as res			///
				%`wfmt'.0g `pw'[`i']	///
				_skip(`skip')		///
				%`wfmt'.0g `np'[`i']	///
				_skip(`skip')		///
				%`wfmt'.0g `nf'[`i']	///
				_skip(`skip')		///
				%`wfmt'.0g `eo'[`i']	///
				_skip(`skip')		///
				%`wfmt'.0g `ao'[`i']	///
				// blank
		}
	}
	di as txt "{hline `lw'}"
	di as txt _skip(`=`wcol'*4')		///
			_skip(`skip')		///
			as res			///
			%`wfmt'.0g `eosum'	///
			_skip(`skip')		///
			%`wfmt'.0g `aosum'	///
			// blank

end

exit
