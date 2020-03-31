*! version 2.7.2  01feb2010
program define fracplot, sortpreserve
	version 8
	if _caller() < 8 {
		fracplot_7 `0'
		exit
	}

	if "`e(fp_cmd)'"!="fracpoly" error 301	// generic fracpoly class supported
	if "`e(cmd2)'"=="stpm" local cmd stpm
	else local cmd "`e(cmd)'"

	if inlist("`cmd'", "clogit", "mlogit", "mprobit", "stcrreg") {
		di in red "`cmd' not supported by fracplot"
		exit 198
	}

	local dist = e(fp_dist)
	local y "`e(fp_depv)'"

	syntax [varlist(default=none)] [if] [in] [, * ]

	_get_gropts , graphopts(`options') 	///
		getallowed(PLOTOPts CIOPts LINEOPts RLOPts plot addplot)
	local options `"`s(graphopts)'"'
	local ciopts `"`s(ciopts)'"'
	local rlopts `"`s(rlopts)'"'
	local lopts `"`s(lineopts)'"'
	local plopts `"`s(plotopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts ciopts, opt(`ciopts')
	_check4gropts rlopts, opt(`rlopts')
	_check4gropts lineopts, opt(`lopts')
	_check4gropts plotopts, opt(`plopts')

	if "`varlist'"=="" {
		local num 1 
		local rhs `e(fp_x1)'
		local x `rhs'
	}
	else {
		local n : word count `varlist'
		if `n'>2 error 103
		tokenize `varlist'
		local rhs `1'
		local x `2'			/* X-axis variable for plot */
		if "`x'"=="" local x `rhs'
		local i 0
		while `i'<e(fp_nx) {
			local i=`i'+1
			if "`rhs'"=="`e(fp_x`i')'" & "`e(fp_k`i')'"!="." {
				local num `i'
				local i =  e(fp_nx)
			}
		}
		if "`num'"=="" {
			di in red "`rhs' not in model"
			exit 198	
		}
	}
	local powers `e(fp_k`num')'

quietly {

	tempvar dr
	fracpred `dr', dresid
	frac_mdp 4 `powers'
	local title `"`e(fp_t1t)' ($S_1)"'
	if e(fp_nx)>1 {
		local title `"`"`title',"' "adjusted for covariates""'
	}
	tempvar etahat
	fracpred `etahat', for(`rhs')
	lab var `etahat' "Fitted component"
	tempvar se low high
	fracpred `se', for(`rhs') stdp
	tempname z
	scalar `z'=-invnorm(0.5-$S_level/200)
	gen `low'=`etahat'-`z'*`se'
	gen `high'=`etahat'+`z'*`se'
	label var `low' "$S_level% CI"
	label var `high' "$S_level% CI"
	tempvar yv
	gen `yv'=`etahat'+`dr'
	if e(fp_nx)>1 local ppp "Partial predictor"
	else local ppp "Predictor"
	count if !missing(`yv')
	if r(N)==0 local yttl "`ppp' of `y'"
	else local yttl "`ppp'+residual of `y'"
	lab var `yv' "`yttl'"
	local symbol smcircle none
	local connect none direct

	if `"`plot'`addplot'"' == "" local legend legend(nodraw)

} // quietly

	/*
		Component (-plus partial-residual) plot
	*/
	local xttl : var label `x'
	if `"`xttl'"' == "" {
		local xttl `x'
	}
	sort `x', stable
	graph twoway	///
	(rarea `low' `high' `x'			/// the CI bands
		`if' `in',			///
		pstyle(ci)			///
		`ciopts'			///
	)					///
	(scatter `yv' `x'			/// partial residuals
		`if' `in',			///
		title(`title')			/// no `""' on purpose
		ytitle(`"`yttl'"')		///
		xtitle(`"`xttl'"')		///
		pstyle(p1)			///
		`legend'			///
		`options'			///
		`plopts'			///
	)					///
	(line `etahat' `x'			/// the fit
		`if' `in',			///
		lstyle(refline)			///
		pstyle(p2)			///
		`rlopts'			///
		`lopts'				///
	)					///
	|| `plot' || `addplot'			///
	// blank
end


program define frac_mdp
	* 1=decimal places, rest=numbers sep by spaces
	* Output in $S_1.
	args dp
	mac shift
	while "`1'"!="" {
		cap confirm num `1'
		if _rc local ddp `ddp' `1'
		else {
			if int(2*`1')==(2*`1') { 
				local ddp `ddp' `1' 	/* respect .5 */
			} 
			else {
				frac_ddp `1' `dp'
				local ddp `ddp' `r(ddp)'
			}
		}
		mac shift
	}
	global S_1 `ddp'
end

