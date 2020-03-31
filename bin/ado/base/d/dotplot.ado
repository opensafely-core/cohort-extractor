*! version 3.5.5  28jan2015  
program define dotplot, rclass sort
	version 6.0, missing
	if _caller() < 8 {
		dotplot_7 `0'
		return add
		exit
	}

	syntax varlist(numeric) [if] [in] [,	///
		OVER(varname)	BY(varname)	///
		NX(int 0)			///
		NY(int 35)			///
		BOunded				///
		Incr(int 1)			///
		CEntre CEnter			///
		Bar				///
		MEAN				///
		MEDian				///
		noGRoup				///
		EXact_y				/// not documented
		AVerage(string)			/// not documented
		SHOWGR				/// not documented
		*				///
		YLOg				///
		XLOg				///
	]

	_nostrl error : `over'

	if _caller() < 9 {
		if `"`by'"' != "" & `"`over'"' != "" {
			di as err "options by() and over() cannot be combined"
			exit 198
		}
	}
	else if `"`by'"' != "" {
		di as err "option by() not allowed"
		exit 198
	}
	local by `by' `over'

	local centre = (`"`centre'`center'"'!=`""')

	if `"`mean'"'!="" {
		if `"`average'"'!="" {
			error 198
		}
		local average `"mean"'
	}
	if `"`median'"'!="" {
		if `"`average'"'!="" {
			error 198
		}
		local average `"median"'
	}
	if `"`group'"'!="" {		/* if nogroup */
		local exact_y `"exact_y"'
	}
	if `"`by'"'!="" {
		local wcnt : word count `varlist'
		if `wcnt' > 1 {
			di in red `"only 1 variable may be plotted with by()"'
			exit 198
		}
	}
	if `incr' <= 0 {
		di in red `"incr() must be greater than 0"'
		exit 198
	}

	tempvar touse x y xc yc
	tempname xlbl

/* mark/markout. */

	mark `touse' `if' `in'

/* Put names of y-variables and integers 1, 2, ... into xdef. */

	tokenize `varlist'
	local nyvars 1
	local usefmt 1
	while `"``nyvars''"'!="" {
		local yname : var lab ``nyvars''
		if `"`yname'"'==`""' {
			local yname `"``nyvars''"'
		}
		local fmt : format ``nyvars''
		if "`prevfmt'" != "" {
			if "`fmt'" != "`prevfmt'" {
				local usefmt 0
			}
		}
		local prevfmt `fmt'

		local xdef `"`xdef' `nyvars' `"`yname'"'"'

		local nyvars = `nyvars' + 1
	}
	if `usefmt' {
		local yvarfmt yvarformat(`fmt')
	}

	local nyvars = `nyvars' - 1

quietly {
	// need to create a label for the x-axis
	if `"`by'"'!=`""' {
		local by0 `by'
		capture confirm string variable `by'
		if !_rc {
			tempvar by2 bylab
			encode `by', gen(`by2')	label(`bylab')
			_crcslbl `by2' `by'
			local by `by2'
		}
		else {
			local bylab : value label `by'
			if `"`bylab'"' == "" {
				tempname bylab
				label define `bylab' 0 "0"
			}
		}
		markout `touse' `varlist' `by'
		local xttl : var label `by'
		if `"`xttl'"' == "" {
			local xttl `by'
		}

		count if `touse'
		if r(N)==0 {
			noisily error 2000
		}

		gen `y' = `varlist' if `touse'
		local ylbl : value label `varlist'
		gen `x' = `by' if `touse'

		/* get unique values for x-axis labels */
		sort `x'
		gen byte `xc'= -(`x'!=`x'[_n-1]) if `touse'
		count if `xc'==-1
		local cols = r(N)
		if `cols'/`incr' > 25 {
			local incr = int(`cols'/25) + 1
		}
		sort `xc' `x'
		local xunique
		local xlabels
		local j 1
		local xj = .
		while `j' > 0 & `j' < `cols'+1 {
			local xj0 = `x'[`j']
			local xj1 = round(`x'[`j'],.01)
			if `xj1'!=`xj' {
				local xj = `xj1'
				local xunique `"`xunique' `xj'"'
				local xlab : label `bylab' `xj0'
				local xlabels `"`xlabels' `xj' `"`xlab'"'"'
			}
			local j	= `j'+`incr'
			if `xc'[`j']==0 {
				local j 0
			}
		}
		if `"`xunique'"'==`"`xj'"' {
			local xj1 = `x'[1]
			local xj = `x'[`cols']
			local xunique `"`xj1' `xj'"'
		}
		if `cols' > 1 | `centre' {
			_crcslbl `xc' `by'
			local xlbl : value label `by'
		}

		local xlabel `"xlabels(`xlabels')"'
	}
	else { /* no by() */
		if `nyvars' > 1 {
			CheckLabelOpts , `options'
			preserve
			keep if `touse'
			keep `varlist'

			local xlabels
			tokenize `varlist'
			local i 1
			while `i' <= `nyvars' {
				local vl : var label ``i''
				if `"`vl'"' == "" {
					local vl ``i''
				}
				local xlabels `"`xlabels' `i' `"`vl'"'"'
				local i = `i' + 1
			}

			stack `varlist', into(`y') clear
			local ylbl : value label `y'

			drop if `y'>=.
			local touse 1

			if _N == 0 {
				noisily error 2000
			}

			local x `"_stack"'
			local xlabel `"xlabels(`xlabels')"'
		}
		else {
			markout `touse' `varlist'

			count if `touse'
			if r(N)==0 { noisily error 2000 }

			gen `y' = `varlist' if `touse'
			local ylbl : value label `varlist'

			gen byte `x' = 1 if `touse'
		}

		gen `xc' = .
		label var `xc' " " /* ??? */
		label define `xlbl' `xdef'
		local cols `nyvars' /* no. of columns to be plotted */

		if `cols'/`incr' > 25 {
			local incr = int(`cols'/25) + 1
		}
	}

	label values `xc' `xlbl'

/*
   Xoffset expands the plotting range for the x-axis
   by .5 of an x unit.
*/
	Xoffset `x' `cols' `centre' `"`xlog'"'
	local x0 = r(xlower)
	local x1 = r(xupper)
	local xrange = r(xrange)

/* Create `yc' plotting variable for y-axis. */

	if `"`exact_y'"'!="" {
		gen `yc' = `y' if `touse'
	}
	else { /* group `y' */
		Group_y `y' `yc' `ny' `"`ylog'"' `"`bounded'"'
	}
	lab val `yc' `ylbl'

	if `"`average'"'!="" {
		tempvar ym
		capture egen `ym' = `average'(`y'), by(`x')
		if _rc {
			noisily di /*
			*/ `"`average' not valid with average()"'
			exit 198
		}
		local ymvar `ym'
		local ymsym plus
	}

	if `"`bar'"'!="" {
		tempvar yb1 yb2 dash
		if bsubstr(`"`average'"',1,3)=="mea" {
			egen `yb1' = sd(`y'), by(`x')
			gen `yb2' = `ym'+`yb1'
			replace `yb1' = `ym'-`yb1'
		}
		else {
			egen `yb1' = pctile(`y'), p(25) by(`x')
			egen `yb2' = pctile(`y'), p(75) by(`x')
		}
		gen str1 `dash' = "-"
		local barvars `yb1' `yb2'
		local barsyms none none
		local barlabs mlabels(. `dash' `dash')
		local barlpos mlabposition(. 0 0)
	}

	sort `x' `yc'

	if `centre' {
		by `x' `yc': replace `xc' = _n - (_N+1)/2

		if `"`vert'"'!="" {
			cap replace `me' =. if (`xc'>.5)|(`xc'< -.5)
			cap replace `yb1'=. if (`xc'>.5)|(`xc'< -.5)
			cap replace `yb2'=. if (`xc'>.5)|(`xc'< -.5)
		}
	}
	else {
		by `x' `yc': replace `xc' = (_n-1)

		if `"`vert'"'!="" & `cols'>1 {
			cap replace `me'=. if `xc'!=0
			cap replace `yb1'=. if `xc'!=0
			cap replace `yb2'=. if `xc'!=0
		}
	}

	if `nx'==0 {
		summarize `xc' if  `x'< . & `yc'< .
		local nx = int(`cols'* /*
		*/	((1+`centre')*r(max)+(`cols')^.3))
	}

	ret scalar nx = `nx'
	local nx = `nx'/`xrange'

	if `"`xlog'"'== "" {
		replace `xc' = `x'+`xc'/`nx'
	}
	else {
		replace `xc' = exp(log(`x')+`xc'/`nx')
		local xlog xscale(log)
	}
	if `"`ylog'"' != "" {
		local ylog yscale(log)
	}

	if  !`centre' & `cols'==1 {
		local xlabel
		label values `xc'
		by `x' `yc': replace `xc' = _n
		local xttl `"Frequency"'
		local x0 0
		local x1 `nx'
		if `"`vert'"'!="" {
			count if `x'< .
			if r(N)==_N {
				preserve
				local NN = _N + 1
				set obs `NN'
			}

			cap summarize `me'
			cap replace `me' = r(mean)
			cap replace `me' = . if `x'< .
			cap summarize `yb1'
			cap replace `yb1' = r(mean)
			cap replace `yb1' = . if `x'< .
			cap summarize `yb2'
			cap replace `yb2' = r(mean)
			cap replace `yb2' = . if `x'< .
		}
		replace `xc' = 0 if `x' >= .
	}

	if `"`by'"'!="" | `cols'==1 {
		local yttl `"`yname'"'
	}
	else	local yttl

	local symbol smcircle `sym_st' `sym_da'
	local lab_sym . `lab_st' `lab_da'
	local labp_sym . `lab_st' `lab_da'

} // quietly

	ret scalar ny = `ny'

	local grcmd					///
	version 8: graph twoway				///
	(scatter `yc' `barvars' `ymvar' `xc',		///
		`yvarfmt'				///
		msymbol(. `barsyms' `ymsym')		///
		`barlabs'				///
		`barlpos'				///
		ylabel(, nogrid)			///
		xlabel(, nogrid)			///
		ytitle(`"`yttl'"')			///
		xtitle(`"`xttl'"')			///
		xscale(range(`x0' `x1'))		///
		`xlabel'				///
		legend(nodraw)				/// no legend
		`xlog' `ylog'				///
		`options'				///
	)						///
	// blank

	/* show the graph command */
	if `"`showgr'"'!="" {
		di _n as txt in smcl `"{p 0 6 2}`grcmd'"'
		exit
	}
	/* execute the graph command */
	`grcmd'

	/* double save in S_# and r()  */
	global S_1 `return(nx)'
	global S_2 `return(ny)'
end

program define Xoffset, rclass
	/*
	xoffset expands the plotting range for the x-axis by .5 of an x unit.

	Plotting range returned in r(xlower) and r(xupper).
	xrange returned in r(xrange).
	*/
	args x cols centre xlog
	local small  1e-6

	quietly summarize `x', meanonly
	local min = r(min)
	local max = r(max)

	if `"`xlog'"'=="" {
		local xrange = `max'-`min'
		if abs(`xrange') < `small' { local xrange 1 }
		local xoffset =0.5*(`xrange'/`cols')
		ret scalar xlower = `min'-`xoffset'*(1+`centre')
		ret scalar xupper = `max'+`xoffset'*2
		ret scalar xrange = `xrange'
		exit
	}

	/* Here if xlog. */

	if `min'<= 0 { error 411 }

	local xrange = log(`max')-log(`min')
	if abs(`xrange') < `small' { local xrange 1 }
	local xoffset =0.5*(`xrange'/`cols')
	ret scalar xlower = exp(log(`min')-`xoffset'*(1+`centre'))
	ret scalar xupper = exp(log(`max')+`xoffset'*2)
	ret scalar xrange = `xrange'
end

program define Group_y
	/*
	Create grouped `yc' variable from `y'.
	*/
	args y yc ny ylog bounded

	quietly {
		sort `y'
		summarize `y', meanonly
		local min = r(min)
		local max = r(max)
		local yprec 0

		if `"`ylog'"'=="" {
			gen `yc' = `y'-`y'[_n-1]
			summarize `yc' if `yc'>0

			if r(min)< . { local yprec = r(min) }

			if (`max'-`min')/`ny' < `yprec' { local yprec 0 }
			else local yprec = round((`max'-`min')/`ny',`yprec')

			if `"`bounded'"'!="" & `yprec'>0 {
				replace `yc' = /*
				*/ autocode(`y',`ny',`min',`max') /*
				*/ -(`max'-`min')/(2*`ny')
			}
			else replace `yc' = round(`y',`yprec')

			exit
		}

	/* Here if ylog. */

		if `min' <= 0 { error 411 }

		gen `yc' = log(`y')-log(`y'[_n-1])
		summarize `yc' if `yc'>0

		if r(min)< . { local yprec = r(min) }

		local yr = (log(`max')-log(`min'))/`ny'

		if `yr' < `yprec' { local yprec 0 }
		else local yprec = round(`yr',`yprec')

		if `"`bounded'"'!="" & `yprec'>0 {
			replace `yc' = exp( /*
			*/ autocode(log(`y'),`ny',log(`min'),log(`max')) /*
			*/ - `yr'/2 )
		}
		else replace `yc' = exp(round(log(`y'),`yprec'))
	}
end

program CheckLabelOpts
	syntax [, *				///
		mlabel(passthru)		/// options not allowed
		MLABPosition(passthru)		///
		MLABVPosition(passthru)		///
		MLABGap(passthru)		///
		MLABANGle(passthru)		///
		MLABSize(passthru)		///
		MLABColor(passthru)		///
		MLABTextstyle(passthru)		///
		MLABSTYle(passthru)		///
	]

	// check for marker label options that are not allowed
	local badops mlabel mlabposition mlabvposition mlabgap mlabangle ///
		mlabsize mlabcolor mlabtextstyle mlabstyle
	foreach op of loca badops {
		if `"``op''"' != "" {
			di as err "option `op'() not allowed"
			exit 198
		}
	}
end

