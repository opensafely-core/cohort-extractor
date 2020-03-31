*! version 1.2.5  26may2009
program define pchi
	version 6, missing
	if _caller() < 8 {
		pchi_7 `0'
		exit
	}

	syntax varname [if] [in] [, DF(real 1) Grid * ]

	_get_gropts , graphopts(`options') getallowed(RLOPts plot addplot)
	local options `"`s(graphopts)'"'
	local rlopts `"`s(rlopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts rlopts, opt(`rlopts')

	marksample doit

        tempvar chip p
        sort `varlist'
	qui gen `chip' = 1 - chiprob(`df', `varlist') if `doit'
	qui count if `doit'
	qui gen `p' = sum(`doit')/(r(N) + 1) if `doit'
	local yttl "{&chi}{superscript:2}(`varlist') d.f. = `df'"
	label var `chip' `"`yttl'"'
	local xttl "Empirical P[i] = i/(N+1)"
	format `chip' `p' %9.2f
	if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}
	version 8: graph twoway			///
	(scatter `chip' `p'			///
		if `doit',			///
		sort				///
		ylabel(0(.25)1, nogrid `grid')	///
		xlabel(0(.25)1, nogrid `grid')	///
		ytitle(`"`yttl'"')		///
		xtitle(`"`xttl'"')		///
		`legend'			///
		`options'			///
	)					///
	(function y=x, 	 			///
		lstyle(refline)			///
		range(`p')			///
		n(2)				///
		yvarlabel("Reference")		///
		`rlopts'			///
	)					///
	|| `plot' || `addplot'			///
	// blank
end
