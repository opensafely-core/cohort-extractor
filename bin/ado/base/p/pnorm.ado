*! version 2.3.3  07mar2005
program define pnorm, sort
	version 6, missing
	if _caller() < 8 {
		pnorm_7 `0'
		exit
	}
	syntax varname [if] [in] [, Grid * ]

	_get_gropts , graphopts(`options') getallowed(RLOPts plot addplot)
	local options `"`s(graphopts)'"'
	local rlopts `"`s(rlopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts rlopts, opt(`rlopts')

	tempvar touse F Psubi
	quietly { 
		gen byte `touse' = !missing(`varlist') `if' `in'
		sort `varlist' 
		sum `varlist' if `touse'==1
		gen float `F' = normprob((`varlist'-r(mean)) /* 
			*/ /sqrt(r(Var))) if `touse'==1
		gen float `Psubi' = sum(`touse')
		replace `Psubi' = cond(`F'>=.,.,`Psubi'/(`Psubi'[_N]+1))
	}
	local yttl "Normal F[(`varlist'-m)/s]"
	label var `F' "`yttl'"
	local xttl "Empirical P[i] = i/(N+1)"
	format `F' `Psubi' %9.2f
	if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}

	version 8: graph twoway			///
	(scatter `F' `Psubi',			///
		sort				///
		ylabel(0(.25)1, nogrid `grid')	///
		xlabel(0(.25)1, nogrid `grid')	///
		ytitle(`"`yttl'"')		///
		xtitle(`"`xttl'"')		///
		`legend'			///
		`options'			///
	)					///
	(function y=x,				///
		lstyle(refline)			///
		range(`Psubi')			///
		n(2)				///
		yvarlabel("Reference")		///
		`rlopts'			///
	)					///
	|| `plot' || `addplot'			///
	// blank
end
