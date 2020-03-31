*! version 1.2.5  26may2009
program define qchi, sort
	version 6, missing
	if _caller() < 8 {
		qchi_7 `0'
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

	if `df' <= 0 {
		di in red "df() must be greater than zero"
		error 499
	}
	tempvar echi
	qui count if `doit'
	sort `varlist' 
	qui gen `echi' = 2*invgammap(`df'/2, sum(`doit')/(r(N) + 1)) /*
	*/	if `doit'
	local xttl "Expected {&chi}{superscript:2} d.f. = `df'"
	local fmt : format `varlist'
	if "`grid'"~="" {
		qui summ `varlist' if `doit', detail
		local ytl = string(r(p5))	///
			+ " " + string(r(p50))	///
			+ " " + string(r(p95))
		local yn = "`ytl'"		///
			+ " " + string(r(p10))	///
			+ " " + string(r(p25))	///
			+ " " + string(r(p75))	///
			+ " " + string(r(p90))

		local sic "2*invgammap(`df'/2,"
		local xtl = string(`sic'.05))		///
			+ " " + string(`sic'.50))	///
			+ " " + string(`sic'.95))
		local xn = "`xtl'" 			///
			+ " " + string(`sic'.25))	///
			+ " " + string(`sic'.75))	///
			+ " " + string(`sic'.90))	///
			+ " " + string(`sic'.10))

		local yl yaxis(1 2)		///
			ytitle("",		///
				axis(2)		///
			)			///
			ylabels(`ytl',		///
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
	(scatter `varlist' `echi'		///
		if `doit',			///
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
	(function y=x				///
		if `doit',			///
		range(`echi')			///
		n(2)				///
		lstyle(refline)			///
		yvarlabel("Reference")		///
		yvarformat(`fmt')		///
		`rlopts'			///
	)					///
	|| `plot' || `addplot'			///
	// blank
end
