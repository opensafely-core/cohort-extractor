*! version 1.3.4  16feb2015
program define gladder
	version 6, missing
	if _caller() < 8 {
		gladder_7 `0'
		exit
	}
	local vv : display "version " string(_caller()) ", missing:"

	syntax varname(numeric) [if] [in] [,	///
		Bin(int -1)			///
		Width(passthru)			///
		DENsity FRACtion FREQuency	/// mutually exclusive
		percent				///
		noNORMAL			///
		SCHEME(passthru)		///
		*				///
	]

	if `"`width'"' != "" {
		di as err "option width() not allowed"
		exit 198
	}

	local yttl `density' `fraction' `frequency' `percent'
	local k : word count `yttl'
	if `k' > 1 {
		local yttl : list retok yttl
		di as err "options `yttl' may not be combined"
		exit 198
	}
	else if `k' == 0 {
		local yttl density
	}
	if `"`normal'"' == "" {
		local options `options' normal
	}

	_get_gropts , graphopts(`options' `yttl') getcombine ///
		getallowed(plot addplot)
	local options `"`s(graphopts)'"'
	local gcopts `"`s(combineopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	if `"`plot'"' != "" {
		di in red "option plot() not allowed"
		exit 198
	}
	if `"`addplot'"' != "" {
		di in red "option addplot() not allowed"
		exit 198
	}	

	local v `varlist'
	marksample touse

	qui count if `touse'
	if r(N) < 3 {
		error 2001
	}
	qui count if `touse' & (`v') < 0
	local r1 = r(N)
	qui count if `touse' & (`v') == 0
	local r2 = r(N)

	local type 3
	if `r1'>0 & `r2'==0  {
		local type 2		/* negative only */
	}
	if `r1'==0 & `r2'>0 {
		local type 1		/* zero only */
	}
	if `r1'==0 & `r2'==0 {
		local type 0		/* all positive */
	}

	// compute the number of bins
	if `bin'<=0 { 
		local bin = max( /*
			*/ int(min(sqrt(_N),10*log(_N)/log(10))+.5),/*
			*/ 2) 
	}
	local binopt bin(`bin')

	// no requirements on domain
	tempname f1 f2 f3
	`vv' HIST =`v'^3 if `touse' ,	///
		`binopt'		///
		name(`f1')		///
		subtitle(cubic)		///
		`options' `scheme'
	`vv' HIST =`v'^2 if `touse' ,	///
		`binopt'		///
		name(`f2')		///
		subtitle(square)	///
		`options' `scheme'
	`vv' HIST =`v'   if `touse' ,	///
		`binopt'		///
		name(`f3')		///
		subtitle(identity)	///
		`options' `scheme'

	// requirement: domain v>=0
	if (`type' == 1) | (`type' == 0) {
		tempname f4
		`vv' HIST =sqrt(`v') if `touse' ,	///
			`binopt'			///
			name(`f4')			///
			subtitle(sqrt)			///
			`options' `scheme'
	}

	// requirement: domain v>0
	if `type' == 0 {
		tempname f5 f6
		`vv' HIST =log(`v') if `touse' ,	///
			`binopt'			///
			name(`f5')			///
			subtitle(log)			///
			`options' `scheme'
		`vv' HIST =-1/sqrt(`v') if `touse' ,	///
			`binopt'			///
			name(`f6')			///
			subtitle(1/sqrt)		///
			`options' `scheme'
	}

	// requirement: domain v != 0
	if (`type' == 0) | (`type' == 2) {
		tempname f7 f8 f9
		`vv' HIST =-1/(`v') if `touse' ,	///
			`binopt'			///
			name(`f7')			///
			subtitle(inverse)		///
			`options' `scheme'
		`vv' HIST =-1/(`v'^2) if `touse' ,	///
			`binopt'			///
			name(`f8')			///
			subtitle(1/square)		///
			`options' `scheme'
		`vv' HIST =-1/(`v'^3) if `touse' ,	///
			`binopt'			///
			name(`f9')			///
			subtitle(1/cubic)		///
			`options' `scheme'
	}

	local yttl = upper(bsubstr("`yttl'",1,1))+bsubstr("`yttl'",2,.)
	local xttl : var label `v'
	if "`xttl'" == "" {
		local xttl `v'
	}

	local graphs `f1' `f2' `f3' `f4' `f5' `f6' `f7' `f8' `f9'
	local note Histograms by transformation
	version 8: graph combine `graphs',	///
		l1title(`"`yttl'"')		///
		b1title(`"`xttl'"')		///
		note(`"`note'"')		///
		`gcopts' `scheme'		///
		// blank
	version 8: graph drop `graphs'
end

program define HIST
	syntax =/exp if [, * ]
	tempvar fv
	qui gen `fv' = `exp' `if'
	qui histogram `fv'	///
		`if',		///
		ytitle("")	///
		xtitle("")	///
		nodraw		///
		`options'
end
