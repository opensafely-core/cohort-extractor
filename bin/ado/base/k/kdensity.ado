*! version 2.8.5  15oct2019
program define kdensity, rclass sortpreserve
	version 8.0, missing
	if _caller() < 8 {
		kdensity_7 `0'
		return add
		exit
	}

	syntax varname(numeric)			///
		[if] [in] [fw aw iw] [,		///
		Generate(string)		///
		AT(varname)			///
		N(integer 50)			///
		Width(real 0.0)			///
		BWidth(real 0.0)		///
		noGRaph				///
		Kernel(string)			///
/*old syntax*/	BIweight			/// _KDE opts
		COSine				///
		EPanechnikov			///
		GAUssian			///
		PARzen				///
		RECtangle			///
		TRIangle			///
		epan2				///
		NORmal				/// graph opts
		STUdent(int 0)			///
		*				///
	]

	if `"`graph'"' != "" {
		_get_gropts , graphopts(`options')
		syntax varname(numeric)			///
			[if] [in] [fw aw iw] [,		///
			Generate(string)		///
			AT(varname)			///
			N(integer 50)			///
			Width(real 0.0)			///
			BWidth(real 0.0)		///
			noGRaph				///
			Kernel(string)			///
			BIweight			/// _KDE opts
			COSine				///
			EPanechnikov			///
			GAUssian			///
			PARzen				///
			RECtangle			///
			TRIangle			///
			epan2				///
		]
		
	}
	_get_gropts , graphopts(`options')	///
		getallowed(STOPts NORMOPts plot addplot)
	local options `"`s(graphopts)'"'
	local normopts `"`s(normopts)'"'
	local stopts `"`s(stopts)'"'
	_check4gropts normopts, opt(`normopts')
	_check4gropts stopts, opt(`stopts')
	if `"`normopts'"' != "" {
		local normal normal
	}
	if `"`stopts'"' != "" & `student' < 1 {
		di as err "option {bf:student()} is required by option {bf:stopts()}"
		exit 198
	}
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'

	// check syntax
	if "`at'"!="" & `n'!=50 {
		di in red "options {bf:at()} and {bf:n()} may not be specified together"
		exit 198
	}
	local kernel_old	`biweight'	///
				`cosine'	///
				`epanechnikov'	///
				`gaussian'	///
				`parzen'	///
				`rectangle'	///
				`triangle'	///
				`epan2'
	local k : word count `kernel_old'
		if `"`kernel'"' == "" {
			if `k' > 1 {
				di as err "only one kernel may be specified"
				exit 198
			}
			if `k' == 0 {
				local kernel epanechnikov
			}
			else {
				local kernel `kernel_old'
			}
		}
		else {
			if `k' != 0 {
				di as err "option {bf:kernel()}: old syntax "    ///
					  "may not be combined with new syntax"
				exit 198
			}
			local k : word count `kernel'
			if `k' > 1 {
				di as err "only one kernel may be specified"
				exit 198
			}
			_get_kernel_name, kernel(`"`kernel'"')
			local kernel `s(kernel)'
			if `"`kernel'"' == "" {
				di as err "invalid kernel function"
				exit 198
			}
		}
	local ix `"`varlist'"'
	local xttl: variable label `ix'
	if `"`xttl'"'=="" { 
		local xttl "`ix'"
	}
	if `bwidth' != 0 {
		if `width' != 0 {
			di as err ///
			     "options {bf:width()} and {bf:bwidth()} may not be specified together"
			exit 198
		}
		local width = `bwidth'
	}
	if `width' < 0 {
		di as err ///
		     "bandwidth must be positive"
		exit 198
	}
	marksample use
	qui count if `use'
	local nobs = r(N)

	tokenize `generate'
	local wc : word count `generate'
	if `wc' { 
		if `wc' == 1 {
			if `"`at'"' == `""' {
				error 198
			}
			confirm new var `1'
			local yname  `"`1'"'
			local xname `"`at'"'
			local nsave 1
		}
		else {
			if `wc' != 2 {
				error 198
			}
			confirm new var `1'
			confirm new var `2'
			local xname  `"`1'"'
			local yname  `"`2'"'
			local nsave 2		
		}
	}

	tempvar d m
	qui gen double `d'=.
	qui gen double `m'=.

	if `"`at'"' != `""' {
		qui count if `at' < . 
		local n = max(1,r(N))
		qui replace `m' = `at' 
		tempvar obssrt
		gen `obssrt' = _n
		sort `m' `obssrt'
	}
	else {
		if `n' <= 1 {
			local n = 50
		}
		if `n' > _N { 
			local n = _N
			noi di in gr `"(n() set to "' `n' `")"'
		}
	}

	local wgt `weight'
	if `"`wgt'"' == "iweight" {
		quietly summ `ix' if `use', detail
	}
	else {
		quietly summ `ix' [`wgt'`exp'] if `use', detail
	}
	local ixmean = r(mean)
	local ixsd   = r(sd)

	local wwidth = `width'
	/*default bandwidth calculation */
	if `wwidth' == 0.0 { 
		local wwidth = min( r(sd) , (r(p75)-r(p25))/1.349)
		if `wwidth' <= 0.0 {
			local wwidth = r(sd)	
		}
		local wwidth = 0.9*`wwidth'/(r(N)^.20)
	}

	tempname delta
	scalar `delta' = (r(max)-r(min)+2*`wwidth')/(`n'-1)

	if `"`at'"' == `""' {
		qui replace `m' = r(min)-`wwidth'+(_n-1)*`delta' in 1/`n'
	}

	// KDE of `ix' at `m' using window width `wwidth' and `kernel'
	if `nobs' {
		_KDE `ix' [`weight'`exp'] if `use' , ///
			`kernel' at(`m') kde(`d') width(`wwidth')
	}
	// label the "x" variable
	label var `m' `"`xttl'"'

	qui summ `d' in 1/`n', meanonly
	tempname scale
	scalar `scale' = 1/(`n'*r(mean))

	label var `d' `"Kernel density estimate"'

	if `"`graph'"'==`""' {
		if `"`normal'"' != "" | `student' > 0 {
			sum `m', mean
			if `"`normal'"' != `""' {
				local Ngraph				///
				(function normden(x,`ixmean',`ixsd'),	///
					range(`r(min)' `r(max)')	///
					yvarlabel("Normal density")	///
					`normopts'			///
				)
			}
			if `student' > 0 {
				local Tgraph				///
				(function				///
					tden = 				///
					tden(`student',			///
						(x-`ixmean')/`ixsd'	///
					)/`ixsd'			///
				,					///
					range(`r(min)' `r(max)')	///
					yvarlabel(			///
				`"t density, df = `student'"'		///
					)				///
					`stopts'			///
				)
			}
		}
		if _caller() >= 10 {
			local title title("Kernel density estimate")
			local note kernel = `kernel', 
			local bw = string(round(`wwidth',0.0001))
			if `bw' == 0 {
				local bw : display %10.3e `wwidth'
			}
			else {
				local bw : display %6.4f `wwidth'
			}
			if `wwidth' == 0 {
				local bw = 0
			}
			local note `note' bandwidth = `bw'
			local note note(`"`note'"')
		}
		graph twoway					///
		(line `d' `m',					///
			`title'					///
			ytitle(`"Density"')			///
			xtitle(`"`xttl'"')			///
			legend(cols(1))				///
			`note'					///
			`options'				///
		)						///
		`Ngraph'					///
		`Tgraph'					///
		|| `plot' || `addplot'				///
		// blank
	}
	// double save in S_# and r()
	ret clear
	ret local kernel `"`kernel'"'
	if _caller() < 10 {
		ret scalar width = `wwidth'
	}
	else {
		ret scalar bwidth = `wwidth'
	}
	ret scalar n = `n'           // (sic)
	global S_1   `"`kernel'"'
	global S_3 = `wwidth'
	global S_2 = `n'
	global S_4 = scalar(`scale')
	ret scalar scale = scalar(`scale')

	if `"`nsave'"' != "" {
		label var `d' `"density: `xttl'"'
		rename `d' `yname'
		if `nsave' == 2 {
			rename `m' `xname'	// already labeled
		}
	}
end

// parsing facility to retrieve kernel name
program _get_kernel_name, sclass
	syntax , KERNEL(string)
	local kernlist epan2 epanechnikov biweight	///
			cosine gaussian parzen		///
			rectangle triangle
	local maxabbrev 5 2 2 3 3 3 3 3
	tokenize `maxabbrev'
	local i = 1
	foreach kern of local kernlist {
		if bsubstr("`kern'",1,length(`"`kernel'"')) == `"`kernel'"' ///
					     & length(`"`kernel'"') >= ``i'' {
			sreturn local kernel `kern'
			continue, break
		}
		else {
			sreturn local kernel
		}
		local ++i
	}
end
exit

Syntax for _KDE:

	_KDE varlist(min=1,max=1) [weight] [if] [in] ,
		[ kern_opt ]
		at(varname)
		kde(varname)
		width(#)

where kern_opt is one of the optional kernel density weight functions, the
default being -epanechnikov-.

REQUIRED options:
	at(varname)     - variable of points to estimate the density at
	kde(varname)    - variable to save the kernel density estimates
	width(#)        - window width


