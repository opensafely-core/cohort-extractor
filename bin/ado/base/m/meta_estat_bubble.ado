*! version 1.0.0  03may2019
program meta_estat_bubble
	version 16
	syntax  [if] [in] [,				///
		REWEIGHTed				///
		n(real 100)				///
		noREGline				///
		noci					///
		Level(string)				///
		*					///
	]

	if `"`e(cmd1)'"' != "meta_cmd_regress" {
		di as err "{bf:meta regress} estimation results not found"
		exit 301
	}
	if `"`e(depvar)'"' != "_meta_es" {
		di as err "{p}bubble plots are only available when the " ///
			"dependent variable is {bf:_meta_es}{p_end}"
		exit 198
	}
	
	if missing("`level'") {
		local level  : char _dta[_meta_level]
	}
	else {
		if !missing("`ci'") {
			di as err "options {bf:noci} and {bf:level()} may " ///
				"be combined"
			exit 184	
		}
		meta__validate_level "`level'"
		local level `s(mylev)'
	}
	
	if "`e(model)'"!="random" & !missing("`reweighted'") {
		di as txt "{p 0 6 2}"  					///
			"note: option {bf:reweighted} ignored because " ///
			"regression model is fixed-effects{p_end}"
		local reweighted 
	}
	
	
	_get_gropts, graphopts(`options') getallowed(CIOPts LINEOPts addplot)
	local options	`"`s(graphopts)'"'
	local ciopts	`"`s(ciopts)'"'
	local lineopts	`"`s(lineopts)'"'
	local addplot	`"`s(addplot)'"'
	_check4gropts ciopts, opt(`ciopts')
	_check4gropts lineopts, opt(`lineopts')

	tempname w
	if "`reweighted'" == "" {
		qui gen double `w' = 1/(_meta_se^2)
		local wgttype "Inverse-variance"
	}
	else {
		qui gen double `w' = 1/(_meta_se^2 + e(tau2))
		local wgttype "Random-effects"
	}
	
	local note note("Weights: `wgttype' ")
	
	local xvars "`e(indepvars)'"
	local nxvars : list sizeof xvars
	local msg "{bf:estat bubbleplot} is available only after simple " ///
		  "meta-regression with a continuous moderator"
	if `nxvars' != 1 {
		di as err "{p}`msg'{p_end}"
		exit 198	
	}
	else {
		fvexpand `xvars' 
		if "`r(fvops)'" == "true" {
			di as err "factor variables not allowed"
			di as err "{p 4 4 2}`msg'{p_end}"
			exit 101
		}	
	}
	
	local varlist `xvars'
	local xvar : copy local varlist
	
	if "`regline'" != "" {
		local ci noci
	}

	if "`ci'" == "" {
		cap confirm integer number `n'
		if _rc | `n' < 2 {
			di as err "option {bf:n()} invalid;"
			di as err ///
	"{bf:`n'} found where an integer of 2 or greater was expected"
			local rc = cond(_rc, _rc, 7)
			exit `rc'
		
		}
		
		tempname xmin xmax step xvar xhold fit sefit cv cil ciu
		sum `varlist' `if' `in', meanonly
		scalar `xmin' = r(min)
		scalar `xmax' = r(max)
		if `n' > _N {
			preserve
			qui set obs `n'
		}
		local ifin in 1/`n'

		scalar `step' = (`xmax' - `xmin') / (`n' - 1)
		qui gen double `xvar' = `xmin' + `step'*(_n-1) in 1/`n'
		local xlab : var label `varlist'
		if `"`xlab'"' == "" {
			local xlab `varlist'
		}
		label var `xvar' "`xlab'"

		rename `varlist' `xhold'
		rename `xvar' `varlist'
		qui predict `fit' `ifin'
		qui predict `sefit' `ifin', stdp
		rename `varlist' `xvar'
		rename `xhold' `varlist'

		local alpha = (100 - `level')/200
		qui scalar `cv'  = invnormal(`alpha')
		if ("`e(df_r)'" != "") qui scalar `cv' = invt(e(df_r), `alpha')
		qui gen double `cil' = `fit' + `cv'*`sefit' `ifin'
		qui gen double `ciu' = `fit' - `cv'*`sefit' `ifin'
		label var `cil' "`level'% CI"
		label var `ciu' "`level'% CI"

		local ciplot					///
			(rarea `cil' `ciu' `xvar' `ifin',	///
				pstyle(ci)			///
				`ciopts'			///
			)
	}
	else if "`regline'" == "" {
		local ifin `if' `in'
		tempname fit
		qui predict `fit' `ifin'
	}
	
	local ytitle `"ytitle(`: variable label _meta_es')"'
	local bubbleplot						///
		(scatter _meta_es `varlist' [aw=`w'] `if' `in',		///
			title("Bubble plot")				///
			pstyle(p1)					///
			msymbol(Oh)					///
			msize("scheme bubble")				///
			yvarlabel(Studies)				///
			`ytitle'					///
			`note'						///
			`options'					///
		)

	if "`fit'" != "" {
		local fitplot				///
			(line `fit' `xvar' `ifin',	///
				sort			///
				pstyle(p2)		///
				`lineopts'		///
			)
	}

	graph twoway		///
		`ciplot'	///
		`bubbleplot'	///
		`fitplot'	///
		|| `addplot'
end
exit

