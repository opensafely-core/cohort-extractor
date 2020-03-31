*! version 2.3.4  04oct2016
program define qnorm, sort
	version 6, missing
	if _caller() < 8 {
		qnorm_7 `0'
		exit
	}

	syntax varname [if] [in] [, Grid * ]

	_get_gropts , graphopts(`options') getallowed(RLOPts plot addplot)
	local options `"`s(graphopts)'"'
	local rlopts `"`s(rlopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts rlopts, opt(`rlopts')

	tempvar touse Z Psubi
	quietly {
		gen byte `touse' = !missing(`varlist') `if' `in'
		sort `varlist'
		gen float `Psubi' = sum(`touse')
		replace `Psubi' = cond(`touse'>=.,.,`Psubi'/(`Psubi'[_N]+1))
		sum `varlist' if `touse'==1, detail
		gen float `Z' = invnorm(`Psubi')*r(sd) + r(mean)
		label var `Z' "Inverse Normal"
		local xttl : var label `Z'
		local fmt : format `varlist'
		format `fmt' `Z'
	}
	if "`grid'"!="" {
		local ytl = string(r(p5))	///
			+ " " + string(r(p50))	///
			+ " " + string(r(p95))
		local yn = "`ytl'"		///
			+ " " + string(r(p10))	///
			+ " " + string(r(p25))	///
			+ " " + string(r(p75))	///
			+ " " + string(r(p90))

		local sic "*sqrt(r(Var)) + r(mean)"
		local xtl = string(r(mean))		///
			+ " "				///
			+ string(invnorm(.95)`sic')	///
			+ " "				///
			+ string(invnorm(.05)`sic')
		local xn = "`xtl'" 			///
			+ " "				///
			+ string(invnorm(.25)`sic')	///
			+ " "				///
			+ string(invnorm(.75)`sic')	///
			+ " " 				///
			+ string(invnorm(.90)`sic')	///
			+ " " 				///
			+ string(invnorm(.10)`sic')

		local yl yaxis(1 2)		///
			ytitle("",		///
				axis(2)		///
			)			///
			ylabels(`ytl',		///
				nogrid		///
				axis(2)		///
			)			///
			yticks(`yn',		///
				grid		///
				gmin		///
				gmax		///
				axis(2)		///
			)			///
			// blank

		local xl xaxis(1 2)		///
			xtitle("",		///
				axis(2)		///
			)			///
			xlabels(`xtl',		///
				nogrid		///
				axis(2)		///
			)			///
			xticks(`xn',		///
				grid		///
				gmin		///
				gmax		///
				axis(2)		///
			)			///
			// blank

		local note	///
`"Grid lines are 5, 10, 25, 50, 75, 90, and 95 percentiles"'
	}
	local yttl : var label `varlist'
	if `"`yttl'"' == "" {
		local yttl `varlist'
	}
	if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}
	version 8: graph twoway			///
	(scatter `varlist' `Z' if `touse'==1,	///
		sort				///
		ytitle(`"`yttl'"')		///
		xtitle(`"`xttl'"')		///
		`legend'			///
		ylabels(, nogrid)		///
		xlabels(, nogrid)		///
		`yl'				///
		`xl'				///
		note(`"`note'"')		///
		`options'			///
	)					///
	(function y=x,	 	 		///
		range(`Z')			///
		n(2)				///
		lstyle(refline)			///
		yvarlabel("Reference")		///
		yvarformat(`fmt')		///
		`rlopts'			///
	)					///
	|| `plot' || `addplot'			///
	// blank
end
