*! version 1.1.15  16feb2015
// generate heights and bin centers for a histogram
program twoway__histogram_gen, rclass sortpreserve
	version 8.0

	syntax varname(numeric) [fw] [if] [in]	///
	[,					///
		DISCrete			///
		BIN(numlist max=1 >0 integer)	/// number of bins
		Width(numlist max=1 >0)		/// width of bins
		START(numlist max=1)		/// first bin position
		DENsity FRACtion FREQuency	/// height type
		PERCENT				///
		RETurn				/// save results in r()
		GENerate(string asis)		/// generate(y x [, replace])
		display				/// display a note
	]

	CheckGenOpt `generate'
	local generate `s(varlist)'
	if `"`generate'"' != "" & `"`s(replace)'"' == "" {
		confirm new var `generate'
	}

	// note: options discrete and bin() are mutually exclusive

	if `"`discrete'"' != "" & `"`bin'"' != "" {
		di as error "options discrete and bin() may not be combined"
		exit 198
	}

	// note: bin() and width() are mutually exclusive

	if `"`bin'"' != "" & `"`width'"' != "" {
		di as err "options bin() and width() may not be combined"
		exit 198
	}

	// note: options density, fraction, frequency, and percent are
	// mutually exclusive

	local type `density' `fraction' `frequency' `percent'
	local k : word count `type'
	if `k' > 1 {
		local type : list retok type
		di as err "options `type' may not be combined"
		exit 198
	}
	else if `k' == 0 {
		local type density
	}
	if "`display'" != "" {
		local return return
	}

	// only check the syntax
	if ("`generate'`return'" == "") exit

	marksample touse
	local v `varlist'

	tempname		///
		h		/// bin width
		min		/// minimum value
		max		/// maximum value
		nobs		/// number of obs (including fw)
		// blank

	if `"`weight'"' != "" {
		local wgt [`weight'`exp']
	}
	// get the range of values
	sum `v' `wgt' if `touse', meanonly
	if r(N) == 0 {
		if "`generate'" != "" {
			DropGenVars `generate'
			gettoken y x : generate
			quietly gen `y' = .
			local Type = upper(bsubstr("`type'",1,1))	///
				+bsubstr("`type'",2,.)
			label var `y' "`Type'"
			quietly gen `x' = .
		}
		return scalar area = 0
		return scalar max = 0
		return scalar min = 0
		return scalar start = 0
		return scalar width = 0
		return scalar bin = 1
		return scalar N = 1
		return local type `type'
		return scalar n_x = 1
		exit
	}
	scalar `nobs' = r(N)
	scalar `min'  = r(min)
	scalar `max'  = r(max)
	if `min' == `max' & `"`width'"' == "" {
		local width 1
	}

	if `"`start'"' != "" {
		if `min' < `start' & reldif(`min',`start') > 1e-5 {
			di as err ///
			"option start() may not be larger than minimum of `v'"
			exit 198
		}
		local user_start yes
		if `"`discrete'"' == "" {
			scalar `min' = `start'
		}
	}
	else {
		tempname start
		scalar `start' = `min'
	}

	// calculate number of bins and bin widths
	if `"`discrete'"' == "" {
		if `"`width'"' == "" {
			if `"`bin'"' == "" {
			    local bin = int(			///
				    min(			///
					sqrt(`nobs'),		///
					10*log(`nobs')/log(10)	///
				    )				///
			    )
			    local bin = max(1,`bin')
			}
			scalar `h' = (`max'-`min')/`bin'
		}
		else {	// width() specified
			scalar `h' = `width'
			local bin = ceil((`max'-`min')/`h')
			local bin = max(1,`bin')
		}
		if `"`display'"' != "" {
			display as txt "(bin=" as res `bin'		///
				as txt ", start=" as res `start'	///
				as txt ", width=" as res `h'		///
				as txt ")"
		}
	}
	else {
		if `"`width'"' == "" {
			tempvar diff v2 io
			qui gen `io' = _n	// restore sort order later
			sort `touse' `v', stable
			qui gen `v2' = `v' if `touse'
			qui gen `diff' = `v2'-`v2'[_n-1] if `touse'
			sum `diff' if `diff'>0, meanonly
			scalar `h' = cond(missing(r(min)), 1, r(min))
			sort `io', stable
			drop `io'
		}
		else	scalar `h' = `width'
		if `"`display'"' != "" {
			display as txt "(start=" as res `start'	///
				as txt ", width=" as res `h'	///
				as txt ")"
		}
		scalar `min' = `min'-`h'/2
		local bin = int((`max'-`min')/`h' + .5)
	}

	// Saved results
	// area of the combined bars in a histogram
	if `"`type'"' == "frequency" {
		return scalar area = `nobs'*`h'
	}
	else if `"`type'"' == "fraction" {
		return scalar area = `h'
	}
	else if `"`type'"' == "percent" {
		return scalar area = `h'*100
	}
	else	return scalar area = 1
	// min and max are the range for the x-axis
	return scalar max = `min'+`h'*`bin'
	return scalar min = `min'
	return scalar start = `start'
	return scalar width = `h'
	return scalar bin = `bin'
	return scalar N = `nobs'
	return local type `type'

	// parsing is finished, so exit if no variables to generate

	if `"`generate'"' == "" {
		exit
	}

quietly {

	// generate bin centers
	tempvar			///
		midbin		/// midpoint of the bin
		height		/// height of the bin
		// blank
	gen `midbin' = floor((`v'-`min')/`h') if `touse'
	// fix edge problems between -float- and -double- precision
	replace `midbin' = 0 if `touse' & `midbin' < 0
	replace `midbin' = `bin'-1 if `touse' & `midbin' == `bin'
	// frequency of observations
	tempname x ht
	capture tabulate `midbin' `wgt', matcell(`ht') matrow(`x')
	if _rc {
		di as err "too many bins"
		exit _rc
	}
	local obins = r(r)
	replace `midbin' = `min' + `h'/2 + `h'*`x'[_n,1] in 1/`obins'
	if `obins' < _N {
		replace `midbin' = . in `=`obins'+1'/l
	}
	gen `height' = `ht'[_n,1] in 1/`obins'
	matrix drop `x'
	matrix drop `ht'

	format `:format `v'' `midbin'
	_crcslbl `midbin' `v'

	if `"`type'"' == "density" {
		replace `height' = `height'/(`nobs'*`h')
	}
	else if `"`type'"' == "fraction" {
		replace `height' = `height'/`nobs'
	}
	else if `"`type'"' == "percent" {
		replace `height' = 100*`height'/`nobs'
	}
	if "`user_start'" != "" & `obins' < _N {
		local ++obins
		replace `midbin' = return(start) in `obins'
	}

} // quietly

	// we wouldn't be here if `generate' was empty
	DropGenVars `generate'
	tokenize `generate'
	gettoken y x : generate
	rename `height' `y'
	local Type = upper(bsubstr("`type'",1,1))+bsubstr("`type'",2,.)
	label var `y' "`Type'"
	rename `midbin' `x'
	// number of nonmissing values in `x'
	return scalar n_x = `obins'
end

program DropGenVars
	foreach var of local 0 {
		capture confirm var `var'
		if !_rc {
			unab vv : `var'
			if "`vv'" == "`var'" {
				drop `var'
			}
		}
	}
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

exit

