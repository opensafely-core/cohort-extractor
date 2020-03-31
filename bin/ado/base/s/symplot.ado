*! version 2.3.3  07mar2005
program define symplot, sort
	version 6, missing
	if _caller() < 8 {
		symplot_7 `0'
		exit
	}

	syntax varname [if] [in] [, *] 

	_get_gropts , graphopts(`options') getallowed(RLOPts plot addplot)
	local options `"`s(graphopts)'"'
	local rlopts `"`s(rlopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts rlopts, opt(`rlopts')

	tempvar VAR ABOVE BELOW CNT

quietly {

	gen double `VAR' = `varlist' `if' `in'
	sort `VAR'
	gen long `CNT'=sum(`VAR'<.)
	if `CNT'[_N]==0 {
		error 2000
	}
	local midpt = int(`CNT'[_N]+1)/2
	#delimit ;
	local median=cond(int(`CNT'[_N]/2)*2==`CNT'[_N],
			(`VAR'[`midpt']+`VAR'[`midpt'+1]) / 2,
			`VAR'[`midpt']) ;
	#delimit cr
	gen `BELOW'=`VAR'-(`median')
	sort `BELOW'
	gen `ABOVE'=`BELOW'[`CNT'[_N]+1-_n]
	replace `BELOW'=abs(`BELOW')
	local yttl "Distance above median"
	label var `ABOVE' "`yttl'"
	local xttl "Distance below median"
	label var `BELOW' "`yttl'"
	local w : variable label `varlist'
	if "`w'"=="" {
		local w "`varlist'"
	}
	if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}

} // quietly

	version 8: graph twoway			///
	(scatter `ABOVE' `BELOW'		///
		if _n<=`midpt',			///
		title(`"`w'"')			///
		ytitle(`"`yttl'"')		///
		xtitle(`"`xttl'"')		///
		`legend'			///
		`options'			///
	)					///
	(function y=x 				///
		if _n<=`midpt',			///
		range(`BELOW')			///
		n(2)				///
		lstyle(refline)			///
		yvarlabel("Reference")		///
		`rlopts'			///
	)					///
	|| `plot' || `addplot'			///
	// blank
end
