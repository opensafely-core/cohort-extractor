*! version 1.0.2  09apr2017
program lpoly_npreg, rclass sortpreserve
	version 10
	syntax varlist(min=2 max=2 numeric fv)	///
		[if] [in] [fw aw] [,		///
		CI				///
		GENerate(string)		///
		AT(varname)			///
		N(integer 50)			///
		DEGree(integer 0)		///
		BWidth(string)			///
		PWidth(string)			///
		Var(string)			///
		SE(string)			///
		Level(cilevel)			///
		Kernel(string)			///
		noGRaph				///
		noSCatter			///
/*old syntax*/	BIweight			///
		COSine				///
		EPanechnikov			///
		GAUssian			///	
		PARzen				///
		RECtangle			///
		TRIangle			///
		EPAN2				///
		GENERATECI(string)		///
		GENERATEVAR(name)		///
		LEGend(string)			///
		ygorro(varname)			///
		senpreg(string)			///
		*				/// graph opts
		]
	_get_gropts , graphopts(`options') gettwoway	///
		getallowed(LINEOPts addplot CIOPts)
	local options `"`s(graphopts)'"'
	local twopts `"`s(twowayopts)'"'
        local lineopts `"`s(lineopts)'"'
	local ciopts `"`s(ciopts)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts lineopts, opt(`lineopts')
	_check4gropts ciopts, opt(`ciopts')
	marksample touse
	qui {
		count if `touse'	
		cap assert r(N)>1
		if _rc { 
			error cond(r(N)==0, 2000, 2001) 
		}
	}
	if `"`pwidth'"' != "" {
		cap confirm number `pwidth'
		if _rc {
			di as err "{bf:pwidth()} must be a positive number"
			exit 198
		}
		if `pwidth' <=0 {
                	di as err "{bf:pwidth()} must be a positive number"
                	exit 198
        	}
		local ci ci
		local doSE = 1
	}
	else {
		local pwidth = 0
	}
	if `degree' < 0 {
		di as err "{bf:degree()} must be a nonnegative number"
                exit 198
	}
	if `n' <= 0 {
                di as err "{bf:n()} must be a positive number"
                exit 198
        }
	if `"`generateci'"' != "" {
		local ci ci
	}
	local savevar=0
	if `"`generatevar'"'!="" {
		local ci ci
		local savevar = 1
		tempvar yvar
		qui gen double `yvar' = .
		
	}
	local kernel_old `biweight' `cosine' `epanechnikov' `gaussian'  ///
		     `parzen' `rectangle' `triangle' `epan2' 		///
		     `triweight' `Li-Racine'
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
				di as err "{bf:kernel()}: old syntax "    ///
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
	tokenize `generate'	
	local k : word count `generate'
	if `"`at'"' != "" {
		cap confirm numeric variable `at'
		if _rc {
			di as err `"{bf:at()}: `at' is not a numeric variable"'
			exit 198
		}
	}
	if `k' { 
		if `k' == 1 {
			if `"`at'"' == "" {
				di as err "{bf:at()} must be specified "  ///
					"for {bf: generate()} to work "   ///
					"with one variable"
				exit 198
			}
			confirm new var `1'
			local yname `"`1'"'
			local xname `"`at'"'
			local nsave 1
		}
		else {
			if `k' > 2 {
				di as err "{bf:generate()}: too many "
				"variables specified"
				exit 198
			}
			confirm new var `1'	
			confirm new var `2'
			local xname `"`1'"'
			local yname `"`2'"'
			local nsave 2
		}
	}
	local k: word count `generateci'
	if `k' {
		if `k' != 2 {
			di as err "Two variables must be specified"
			exit 198
		}
		tokenize `generateci'
		confirm new var `1'
		confirm new var `2'
		local cilname `"`1'"'
		local ciuname `"`2'"'
	}
	local doSE = 0
	if `"`se'"' != "" {
		if `"`at'"'=="" & `"`generate'"'=="" {
			di as err "{bf:se()} requires the specification" ///
				  " of {bf:at()} or {bf:generate()}"
			exit 198
		}
		confirm new var `se'
		local sename `"`se'"'
		local doSE = 1
	}
	if "`ci'" != "" {
		local doSE = 1
	}
	tokenize `varlist'
	local y `1'
	local x `2'
	tempname bw tousegrid
	qui gen byte `tousegrid' = 1	
	if `"`at'"' != "" {
		markout `tousegrid' `at'
	}
	if `"`bwidth'"' == "" {
		qui gen byte `bw'= 0
	}
	else {
		cap confirm number `bwidth'
	        if _rc {
			cap confirm  variable `bwidth'
			unab bwidth: `bwidth', name(bwidth())
			if `"`at'"' != "" {
				if _rc {
di as err `"{bf:bwidth()}: variable `bwidth' not found"'
exit 111
				}
				cap confirm numeric variable `bwidth'
				if _rc {
di as err `"{bf:bwidth()}: `bwidth' is not a numeric variable"'
exit 198
				}
				markout `tousegrid' `bwidth'
				capture assert `bwidth' > 0 if `tousegrid'
				if _rc {
di as err `"{bf:bwidth()}: `bwidth' has nonpositive values"'
exit 499
				}
			}
			else {
				di as err "variable name in {bf:bwidth()} " ///
				 "is allowed only with {bf:at()} option"
				exit 198
			}
		}
		else if `bwidth' <= 0 {
			di as err "{bf:bwidth()} must be a positive number" 
			exit 198
		}
		qui gen double `bw' = `bwidth' if `tousegrid'
	}

	tempvar variance
	if `"`var'"' == "" {
		qui gen byte `variance'= 0
	}
	else {
		local ci ci
		local doSE = 1
		cap confirm number `var'
	        if _rc {
			cap confirm  variable `var'
			unab var: `var', name(var())
			if `"`at'"' != "" {
				if _rc {
di as err `"{bf:var()}: variable `var' not found"'
exit 111
				}
				cap confirm numeric variable `var'
				if _rc {
di as err `"{bf:var()}: `var' is not a numeric variable"'
exit 198
				}
				markout `tousegrid' `var'
				capture assert `var' > 0 if `tousegrid'
				if _rc {
di as err `"{bf:var()}: `var' has nonpositive values"'
exit 499
				}
			}
			else {
				di as err "variable name in {bf:var()} " ///
				"is allowed only with {bf:at()} option"
				exit 198
			}
		}
		else if `var' <= 0 {
			di as err "{bf:var()} must be a positive number" 
			exit 198
		}
		qui gen double `variance' = `var' if `tousegrid'
	}
	tempvar xgrid yhat SE
	qui {
		gen double `xgrid' = `x'
		gen double `yhat' = `ygorro'
		gen double `SE' = `senpreg'
	}
	if `"`at'"' != `""' {
		qui count if `at' < .
		local n = r(N)
		qui replace `xgrid' = `at'
	}
	else {
		if `n' <= 1 {
			local n = 50
		}
		if `n' > _N {
			local n = _N
			noi di in gr "(n() set to " `n' ")"
		}
		qui summ `x' if `touse'
		tempname delta
		scalar `delta' = (r(max) - r(min))/(`n' - 1)
		qui replace `xgrid' = r(min) + (_n - 1)*`delta' in 1/`n'
		markout `tousegrid' `xgrid'
		label variable `xgrid' "smoothing grid"
	}
	* handle weights
	tempvar wgt
	gen double `wgt' = 1
	if `"`weight'"' != "" {
		qui replace `wgt' `exp' if `touse'
		if `"`weight'"' == "aweight" {
			summ `wgt' if `touse', meanonly
			qui replace `wgt' = `wgt'*r(N)/r(sum)
		}
	}
	* get lower and upper bounds for integral computation
	qui sum `x' if `touse', meanonly
	local l = r(min) + 0.05*(r(max) - r(min))
	local u = r(max) - 0.05*(r(max) - r(min))
	sort `x', stable
	tempvar id
	qui gen `id' = _n
	qui count if `yhat' < . 
	ret scalar ngrid = r(N)
	ret scalar degree = `degree'
	ret local kernel `"`kernel'"'
	
	qui if "`ci'" != "" {
		local prob = 0.5*(1 - `level'/100) + `level'/100
		local crval = invnormal(`prob')
		tempname cil ciu
		gen double `cil' = `yhat' -  `crval'*`SE' if `tousegrid'
		gen double `ciu' = `yhat' +  `crval'*`SE' if `tousegrid'
		label variable `cil' `"`level'% CI"'
		label variable `ciu' `"`level'% CI"'
	}
	qui if `"`generateci'"' != "" {
		gen `cilname' = `cil' if `tousegrid'
		gen `ciuname' = `ciu' if `tousegrid'
		label variable `cilname' `"`level'% CI"'
		label variable `ciuname' `"`level'% CI"'
	}
	
	/* Graph (if required) */
	if "`graph'" == "" { 
		local title title("Mean function of `e(depvar)'")
		local bw = string(round(`bw',0.00000001))
		local note kernel = `return(kernel)'
		if ("`e(estimator)'"=="linear") {
			local subtn "Local-linear estimates"
		}
		else {
			local subtn "Local-constant estimates"			
		}
		local note `note' bandwidth = `bw'`pw_note' 
		local yttl : var label `e(lhs)'
		if `"`yttl'"' == "" {
			local yttl `y'
		}
		local xttl : var label `x'
		if `"`xttl'"' == "" {
			local xttl `x'
		}
		label var `yhat' "smooth line of estimates"
		local nlabel = 1
		if "`ci'" != "" {
			local ciplot (rarea `cil' `ciu' `xgrid'		///
						if `tousegrid',		///
						sort cmissing(no)	///
						pstyle(ci)		///
						`ciopts' )
		}
		if `"`legend'"' != "" {
			local legend legend(`legend')
		}
		else if "`ci'" != "" {
			local legend label(`nlabel' `"`level'% CI"')
			if `"`addplot'"' == "" {
				local rows rows(1)
			}
			local legend legend(`rows' `legend')
			local ++nlabel
		}
		else if `"`addplot'"' == "" {
			local legend legend(nodraw)
		}
		local linestyle p1
		if "`scatter'" == "" {
			local linestyle p2
			local scat (scatter `y' `x' if `touse', pstyle(p1)
			local scat `scat' `options') 
			local ++nlabel
		}
		graph twoway					///
		`ciplot'					///
		`scat'						///
		(line `yhat' `xgrid' if `tousegrid',		///
			sort					///
			`title'					///
			`subtitle'				///
			note(`"`subtn'"' `"`note'"')		///
			ytitle(`"`yttl'"')			///	
			xtitle(`"`xttl'"')			///
			cmissing(no)				///
			pstyle(`linestyle')			///
			`lineopts'				///
		)						///
		|| `addplot' ||					///
		, `legend' `twopts'				///
		// blank
	}
	if `savevar'==1 {
		rename `yvar' `generatevar'
		label var `generatevar' "conditional variance"
	}
	if `"`nsave'"' != "" {
		local ylab : var label `y'
		if `"`ylab'"' == "" {
			local ylab `y'
		}
		label var `yhat' `"lpoly smooth: `ylab'"'
		rename `yhat' `yname'
		if `nsave' >= 2 {
			rename `xgrid' `xname'
			label var `xname' `"lpoly smoothing grid"'
		}
	}
	if `"`se'"' != "" {
		rename `SE' `sename'
		label var `sename' `"lpoly SEs"'
	}
end

// parsing facility to retrieve kernel name
program _get_kernel_name, sclass
	syntax , KERNEL(string)
	local kernlist epan2 epanechnikov biweight	///
			cosine gaussian parzen		///
			rectangle triangle triweight Li-Racine
	local maxabbrev 5 2 2 3 3 3 3 3 3 9
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
