*! version 3.2.5  16oct2015
program define lroc, rclass sortpreserve
	local vcaller = string(_caller())
	version 6.0, missing
	if `vcaller' < 8.0 {
		lroc_7 `0'
		return add
		exit
	}

	/* Parse and generate `touse', `p' (predicted probabilities),
	   and `w' (weights).
	*/
	if "`e(cmd)'" == "ivprobit" {
		local vv version `vcaller':
	}
	tempvar touse p w spec sens
	`vv' ///
	lfit_p `touse' `p' `w' `0'
	local y `"`s(depvar)'"'	
	ret scalar N = `s(N)'
	global S_1 `"`return(N)'"'    /* double save */

	/* Parse other options. */
	local 0 `", `s(options)'"'
	sret clear
	syntax [, noGraph * ]

	if "`graph'" != "" & `"`options'"' != "" {
		syntax [, noGraph ]
	}

	_get_gropts , graphopts(`options') getallowed(RLOPts plot addplot)
	local options `"`s(graphopts)'"'
	local rlopts `"`s(rlopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts rlopts, opt(`rlopts')

	local old_N = _N

capture {

	lsens_x `touse' `p' `w' `y' `sens' `spec' one

	/* Compute area under ROC curve. */
	replace `p' = sum((`spec'-`spec'[_n-1])*(`sens'+`sens'[_n-1]))
	
	return scalar area = `p'[_N]/2
	global S_2  `"`return(area)'"'    /* double save  */

	local area : di %6.4f return(area)
	local note `"Area under ROC curve = `area'"'

	if `"`graph'"' == `""' {
		format `sens' `spec' %4.2f
		local yttl : var label `sens'
		local xttl : var label `spec'
		if `"`plot'`addplot'"' == "" {
			local legend legend(nodraw)
		}
		noi version 8, missing: graph twoway	///
		(connected `sens' `spec',		///
			sort				///
			ylabel(0(.25)1, grid)		///
			ytitle(`"`yttl'"')		///
			xlabel(0(.25)1, grid)		///
			xtitle(`"`xttl'"')		///
			note(`"`note'"')		///
			`legend'			/// no legend
			`options'			///
		)					///
		(function y=x,				///
			lstyle(refline)			///
			range(`spec')			///
			n(2)				///
			yvarlabel("Reference")		///
			`rlopts'			///
		)					///
		|| `plot' || `addplot'			///
		// blank
	}
	#delimit ;
	noi di in gr _n 
		cond(`"`e(cmd)'"'=="probit"|`"`e(cmd)'"'=="dprobit"|
		     `"`e(cmd)'"'=="ivprobit",
			"Probit","Logistic")
		`" model for `y'"' _n(2)
		`"number of observations = "' in yel %8.0f return(N) _n
		in gr `"area under ROC curve   = "' 
		in yel %8.4f return(area) ;
	#delimit cr

} // capture

	nobreak {
		local rc = _rc
		if _N > `old_N' {
			qui drop if `touse' >= .
		}
		if `rc' {
			error `rc'
		}
	}
end
