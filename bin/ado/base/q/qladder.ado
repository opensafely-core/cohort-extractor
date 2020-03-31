*! version 1.3.2  19jan2006
program define qladder
	version 6, missing
	if _caller() < 8 {
		qladder_7 `0'
		exit
	}
	local vv : display "version " string(_caller()) ", missing:"

	syntax varname(numeric) [if] [in] [,	///
		Grid				///
		SCHEME(passthru)		///
		*				///
	]

	_get_gropts , graphopts(`options') getcombine getallowed(plot addplot)
	local options `"`s(graphopts)' `grid'"'
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

	// no requirements on domain
	tempname f1 f2 f3
	`vv' Qplot =`v'^3 if `touse' ,	///
		name(`f1')		///
		subtitle(cubic)		///
		`options' `scheme'
	`vv' Qplot =`v'^2 if `touse' ,	///
		name(`f2')		///
		subtitle(square)	///
		`options' `scheme'
	`vv' Qplot =`v'   if `touse' ,	///
		name(`f3')		///
		subtitle(identity)	///
		`options' `scheme'

	// requirement: domain v>=0
	if (`type' == 1) | (`type' == 0) {
		tempname f4
		`vv' Qplot =sqrt(`v') if `touse' ,	///
			name(`f4')			///
			subtitle(sqrt)			///
			`options' `scheme'
	}

	// requirement: domain v>0
	if `type' == 0 {
		tempname f5 f6
		`vv' Qplot =log(`v') if `touse' ,	///
			name(`f5')			///
			subtitle(log)			///
			`options' `scheme'
		`vv' Qplot =-1/sqrt(`v') if `touse' ,	///
			name(`f6')			///
			subtitle(1/sqrt)		///
			`options' `scheme'
	}

	// requirement: domain v != 0
	if (`type' == 0) | (`type' == 2) {
		tempname f7 f8 f9
		`vv' Qplot =-1/(`v') if `touse' ,	///
			name(`f7')			///
			subtitle(inverse)		///
			`options' `scheme'
		`vv' Qplot =-1/(`v'^2) if `touse' ,	///
			name(`f8')			///
			subtitle(1/square)		///
			`options' `scheme'
		`vv' Qplot =-1/(`v'^3) if `touse' ,	///
			name(`f9')			///
			subtitle(1/cubic)		///
			`options' `scheme'
	}

	if "`grid'" != "" {
	   local note2	"Grid lines are 5,10,25,50,75,90, and 95 percentiles"
	}

	local xttl : var label `v'
	if "`xttl'" == "" {
		local xttl `v'
	}

	local graphs `f1' `f2' `f3' `f4' `f5' `f6' `f7' `f8' `f9'
	local note Quantile-Normal plots by transformation
	version 8: graph combine `graphs',		///
		l1title("")				///
		b1title(`"`xttl'"')			///
		note(`"`note'"' `"`note2'"')		///
		`gcopts' `scheme'			///
		// blank
	version 8: graph drop `graphs'
end

program define Qplot
	syntax =/exp if [, * ]
	tempvar fv
	qui gen `fv' = `exp' `if'
	// suppress grid note from -qnorm-
	qnorm `fv' `if',	///
		ytitle("")	///
		xtitle("")	///
		note("")	///
		nodraw		///
		`options'
end
