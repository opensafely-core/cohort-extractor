*! version 1.4.0  15mar2018
program factor, eclass byable(onecall)
	/* No version -- on purpose */

	local vv : di "version " string(_caller()) ":"

	if _caller() < 9 {
		if _by() {
			by `_byvars'`_byrc0' : factor_cmd8 `0'
		}
		else {
			factor_cmd8 `0'
		}
		exit
	}

	version 9	/* Now we can set version for the program */

	if replay() {
		if _by() {
			error 190
		}
		if "`e(cmd)'" != "factor" {
			error 301
		}
		Display `0'
		exit
	}

	if _by() {
		by `_byvars'`_byrc0' : Estimate "`vv'" `0'
	}
	else {
		Estimate "`vv'" `0'
	}
	ereturn local cmdline `"factor `0'"'
end


program Estimate, eclass byable(recall)
	gettoken vv 0 : 0

	#del ;
	syntax  varlist(numeric) [if] [in] [aw fw]
	[,
	     // valid factor extraction methods
		pcf 
		pf 
		IPf 
		ml

	     // no longer allowed pc = principal component
		pc                     // undocumented; used for err msg

	     // what matrix should be analyzed
		CORrelations           // undocumented
		COVariances            // undocumented

	     // number of factors
		FActors(str)
		COMponents(str)        // undocumented
		MINEigen(str)

	     // communality estimation
		CITerate(passthru)

	     // display/replay options
		BLanks(passthru)
		ALTDIVisor
		NOLOg LOg
		TRace
		PRotect(passthru)
		Random                 // short abbrev for backward comp.
		SEED(str)              // undocumented
		MEans                  // for backward comp. 
		
	     // used by -factormat-    
		cmatname(str)          // undocumented
		callver(str)           // undocumented

             // maximize-options		
		*                     
	];
	#del cr

	if `"`callver'"' != "" {
		// reset to -factormat- callers version when doing -set seed-
		local vv `"`callvar'"'
	}

	if (`"`ml'"'!="") {
		_parse_iterlog, `log' `nolog'
		local log "`s(nolog)'"
		local factor_opt   `citerate' `log' `trace' `protect' `random' /// 
	                   `options'
	}
	else if (`"`log'`nolog'"'!="")	{
		dis as err "options {cmd:log} and {cmd:nolog} " ///
			"are allowed for {cmd:ml} method only"
		exit 198
	}   
	else {
		local factor_opt   `citerate' `trace' `protect' `random' /// 
	                   `options'
	}
	local display_opt  `blanks' `means' `altdivisor'
	

	if "`pc'" != "" {
		NoPCA
	}

	if "`factors'" != "" & "`components'" != "" { 
		dis as err "factors() and components() are synonyms"
		exit 198
	}
	else if "`components'" != "" { 
		local factors `components' 
	}	
	
	local method `pcf' `pf' `ipf' `ml'
	if `:list sizeof method' > 1 {
		opts_exclusive "`method'"
	}
	else if "`method'" == "" {
		local method pf
	}

	if "`covariances'" != "" {
		dis as err "factor does not analyze covariance matrices"
		exit 198
	}

	marksample touse
	if "`weight'" != "" {
		local wght [`weight'`exp']
	}
	if "`factors'" != "" {
		local fopt factors(`factors')
	}
	if "`mineigen'" != "" {
		capture confirm number `mineigen'
		if c(rc) {  // factor_cmd8 will deal with producing the error
			local mopt mineigen(`mineigen')
		}
		else if `mineigen' < 5e-6 {
		  // factor_cmd8 silently resets mineigen() requests < 5e-6 to
		  // 5e-6 for all methods except -pcf-.  For -pcf- it sets it
		  // back to 1.  We enforce it to be 5e-6 in all cases.
			local mopt mineigen(5e-6)
		}
		else {
			local mopt mineigen(`mineigen')
		}
	}

	local old_seed `c(seed)'   
	if `"`seed'"' != "" {  
		if "`random'" == "" & `"`protect'"' == "" { 
			dis as err "option seed() allowed only with " /// 
			           "random and protect()" 
			exit 198
		}
		capture `vv' set seed `seed' 
		if _rc {
			dis as err "option seed() invalid"
			exit 198
		}	
	}
	local rngstate `"`c(seed)'"'
	
// estimation using the internal command factor_cmd8

	if "`protect'" != "" { 
		local log
	}
	
	if "`ml'" != "" { 
		_rmcoll `varlist' 
		local varlist `r(varlist)' 
	}
	
	factor_cmd8 `varlist' if `touse'  `wght' ,        ///
           `method' `fopt' `mopt' `factor_opt'            /// 
           notableout

         // do the process of checking zero variance again to update varlist
        tempname rtemp
        _return hold `rtemp'
        foreach v of local varlist {
                quietly summ `v' if `touse', meanonly
                if r(max) > r(min) {
                        local vlist `vlist' `v'
                }
        }
        local nvar : list sizeof vlist
        if `nvar' < 2 {
                error 102
        }
        local varlist `vlist'
        _return restore `rtemp'
	   
// extract information from r() and get() to return in e()

	tempname aic bic chi2_i df_i df_m df_r evsum f ll N p_i  //scalars
	tempname C Ev L Mean Phi Psi SD                          //matrices

	// scalars r(<name>) saved as r_<name>
	
	local rscalars : r(scalars)
	local omit       k_f N ll

	// Remark: LR-tests between models with different number of 
	//         factor is NOT chi2-distributed
	//                   
	//         this has been confirmed by simulations.
	//      
	// theory: under the null, the parameters are not identified
	//         and so implicit function theory does not apply 

	local omit `omit' df_0 chi2_0
	
	local rscalars : list rscalars - omit
	foreach s in `rscalars' {
		tempname r_`s'
		scalar `r_`s'' = r(`s')
	}
	scalar `f'  = r(k_f)
	scalar `N'  = r(N)
	scalar `ll' = r(ll)

	matrix `Mean' = get(Mean)
	matrix colnames `Mean' = `varlist'
	matrix rownames `Mean' = mean

	matrix `SD' = get(SD)
	matrix colnames `SD' = `varlist'
	matrix rownames `SD' = sd

	matrix `C' = get(Co)
	matrix colnames `C' = `varlist'
	matrix rownames `C' = `varlist'
	local k = colsof(`C')
	
	matrix `Psi' = get(Psi)
	matrix colnames `Psi' = `varlist'
	matrix rownames `Psi' = Uniqueness

	matrix `Ev' = get(Ev)
	forvalues j = 1 / `=colsof(`Ev')' {
		local flist `flist' Factor`j'
	}
	matrix colnames `Ev' = `flist'
	matrix rownames `Ev' = Eigenvalues

	scalar `evsum' = 0
	forvalues j = 1 / `=colsof(`Ev')' {
		if (`Ev'[1,`j']>=.) {
			continue
		}
		scalar `evsum' = `evsum' + `Ev'[1,`j'] 
	}
	
	if `f' > 0 { 
		matrix `L' = get(Ld)
		matrix rownames `L'  = `varlist'
		local flist
		forvalues j = 1 / `=colsof(`L')' {
			local flist `flist' Factor`j'
		}
		matrix colnames `L' = `flist'
				
		matrix `Phi' = I(`f')
		matrix colnames `Phi' = `flist' 
		matrix rownames `Phi' = `flist' 
	}
	
// test for independence (Basilevsky: 187)

	scalar `chi2_i' = -(`N' - (2*`k'+5)/6) * ln(det(`C'))
	scalar `df_i'   = `k'*(`k'-1)/2
	scalar `p_i'    = chi2tail(`df_i', `chi2_i')

// degrees of freedom for correlation model, ignoring heywood cases

	scalar `df_m' = min(`k'*(`k'-1)/2, `k'*`f' - `f'*(`f'-1)/2)
	scalar `df_r' = `k'*(`k'-1)/2 - `df_m'
	if `ll' != . {
		scalar `aic' = -2*`ll' + 2*`df_m'
		scalar `bic' = -2*`ll' + `df_m'*ln(`N')
	}
	
// check for heywood case: (Harman p117): communalities outside range [0,1]

	local heywood = 0
	forvalues i = 1/`=colsof(`Psi')' { 
		if !inrange(`Psi'[1,`i'],0.0001,0.9999) { 
			local ++heywood
		}
	}

// return in e()

	if "`cmatname'" == "" {
		ereturn post , esample(`touse')  // post e(sample)
	}
	else {
		ereturn local matrixname  `cmatname'
	}

	ereturn scalar f    = `f'
	ereturn scalar N    = `N'
	ereturn scalar df_m = `df_m'
	ereturn scalar df_r = `df_r'
	if `ll' != . {
		ereturn scalar ll  = `ll'
		ereturn scalar aic = `aic'
		ereturn scalar bic = `bic'
	}
	
	ereturn scalar chi2_i = `chi2_i' 
	ereturn scalar df_i   = `df_i' 
	ereturn scalar p_i    = `p_i' 

	foreach s in `rscalars' {
		ereturn scalar `s' = `r_`s''
	}

	ereturn scalar evsum = `evsum'      // sum of all eigenvalues
	ereturn matrix Ev    = `Ev'         // eigenvalues
	ereturn matrix Psi   = `Psi'        // uniqueness of variables
	if `f' > 0 { 
		ereturn matrix L   = `L'    // loadings
		ereturn matrix Phi = `Phi'  // variance common factors 
	}

	ereturn matrix C  = `C'             // correlation matrix analyzed
	if "`cmatname'" == "" {
		ereturn matrix means = `Mean'
		ereturn matrix sds   = `SD'
	}

	if "`wght'" != "" {
		ereturn local wtype   `weight'
		ereturn local wexp    `"`exp'"'
	}
	
	ereturn local method `method'
	Mtitle `method' 
	ereturn local mtitle `r(mtitle)' 

	ereturn local mineigen    `mopt'
	ereturn local factors     `fopt'
	if "`c(seed)'" != "`old_seed'" {
		ereturn hidden local seed `old_seed'
	}
	ereturn local rngstate `"`rngstate'"'

	if `heywood' > 0 { 
		ereturn local heywood "Heywood case"
	}

	ereturn local rotate_cmd  factor_rotate
	ereturn local estat_cmd   factor_estat
	ereturn local predict     factor_p

	ereturn local title       "Factor analysis"
	ereturn local properties  "nob noV eigen"
	ereturn local marginsnotok _ALL
	ereturn local cmd         factor

// display

	_returnclear
	Display , `display_opt'
end


program Display
	syntax [,            ///
	   BLanks(passthru)  /// small loadings are not shown
	   noROTated         /// show unrotated results
	   MEans             /// display summary statistics
	   ALTDIVisor        /// use trace(C) when dividing to get proportions
	]

	Header , `rotated' 
	
	if "`e(heywood)'" != "" { 
		dis _n _col(5) as txt ///
		"Beware: solution is a {help heywood_case##|_new:Heywood case}"
		dis _col(13) "(i.e., invalid or boundary values of uniqueness)"
	}	
	
	EigenTable , `rotated' `altdivisor'
	
	LoadingTable , `blanks' `rotated'

	if "`means'" != "" {
		dis _n as txt "Summary statistics of the variables" 
		estat summ, noheader
	}
end


program Header 
	syntax [, noROTated ]

	_rotate_text, `rotated' 
	local rtext `r(rtext)'
	
	dis _n as txt "Factor analysis/correlation"  ///
	     _col(50) "Number of obs    = " as res %10.0fc e(N)
	     
	dis  _col( 5)  as txt "Method: `e(mtitle)'" ///
	     _col(50) "Retained factors =   " as res %8.0fc e(f)
	     
	dis  _col( 5)  as txt "Rotation: `rtext'" /// 
	     _col(50) "Number of params =   " as res %8.0fc e(df_m)

	if "`e(ll)'" != "" {
		dis _col(50) as txt "Schwarz's BIC    =   " /// 
		             as res %8.0g e(bic)          ///
		 _n _col( 5) as txt "Log likelihood = "   ///
		             as res %9.0g e(ll)           ///
		    _col(50) as txt "(Akaike's) AIC   =   " ///
		             as res %8.0g e(aic)
	}
end


program EigenTable
	syntax [, noROTated ALTDIVisor ]

	tempname csum evsum Ev

	if ("`rotated'" == "") & ("`e(r_criterion)'" != "") { 
		local rpre r_
	}	
	matrix `Ev'  = e(`rpre'Ev)
	if "`altdivisor'" != "" {
		scalar `evsum' = trace(e(C))
	}
	else {
		scalar `evsum' = e(evsum) 
	}

	dis
	if "`rpre'" == "" | "`e(r_class)'" == "orthogonal" {
		if "`rpre'" != "" { 
			local Evtxt  Variance
			local m = e(f)
		}
		else { 
			local Evtxt  Eigenvalue
			local m = colsof(`Ev')
		}
	
		dis as txt _col(5) "{hline 13}{c TT}{hline 60}"
		dis as txt _col(5) "     Factor  {c |} {ralign 12:`Evtxt'}   "       ///
		    "Difference        Proportion   Cumulative"
		dis as txt _col(5) "{hline 13}{c +}{hline 60}"

		scalar `csum'  = 0		
		forvalues j = 1 / `m' {
			if (missing(`Ev'[1,`j'])) continue
			dis as txt _col(5) "{ralign 11:Factor`j'}  {c |}"  ///
			    as res " " %12.5f `Ev'[1,`j']                  ///
			    as res " " %12.5f `Ev'[1,`j']-`Ev'[1,`j'+1]    ///
			    _skip(4)                                       /// 
			    as res "  " %12.4f `Ev'[1,`j'] / `evsum'       ///
			    as res " " %12.4f (`csum'+`Ev'[1,`j'])/`evsum' 
			    
			scalar `csum' = `csum' + `Ev'[1,`j']
		}
		dis as txt _col(5) "{hline 13}{c BT}{hline 60}"
	}
	else { 
		
		dis as txt _col(5) "{hline 13}{c TT}{hline 60}"
		dis as txt _col(5) ///
		    "     Factor  {c |}     Variance   Proportion   "      ///
		    " Rotated factors are correlated"
		dis as txt _col(5) "{hline 13}{c +}{hline 60}"

		forvalues j = 1 / `=e(r_f)' {
			dis as txt _col(5) "{ralign 11:Factor`j'}  {c |}"  ///
			    as res " " %12.5f `Ev'[1,`j']                  /// 
			    as res " " %12.4f `Ev'[1,`j']/`evsum'
		}
		dis as txt _col(5) "{hline 13}{c BT}{hline 60}"
	}

// test for independence

	if ((e(chi2_i) > 0.005) & (e(chi2_i)<1e4)) {
		local fmt "%8.2f"
	}
	else {
		local fmt "%8.2e"
	}
	if e(df_i) < 10 {
		local predf  "  chi2("
		local postdf ")  ="
	}
	else if e(df_i) < 100 {
		local predf  "  chi2("
		local postdf ") ="
	}
	else if e(df_i) < 1000 {
		local predf  " chi2("
		local postdf ") ="
	}
	else {
		local predf  " chi2("
		local postdf ")="
	}
	dis as txt _col(5) "LR test: independent vs. saturated:`predf'" /// 
	    as res e(df_i)		///
	    as txt "`postdf'"		///
	    as res `fmt' e(chi2_i)	///
	    as txt " Prob>chi2 ="	///
	    as res %7.4f e(p_i)

// LR-tests against independence and saturated model (ML only)
	if e(df_1) == 0 {
		dis as txt _col(5) ///
			"(the model with `e(f)' factors is saturated)"
	}
	else if e(df_1) != . {
		if ((e(chi2_1) > 0.005) & (e(chi2_1)<1e4)) {
			local fmt "%8.2f"
		}
		else {
			local fmt "%8.2e"
		}
		if e(df_1) < 10 {
			local predf  "  chi2("
			local postdf ")  ="
		}
		else if e(df_1) < 100 {
			local predf  "  chi2("
			local postdf ") ="
		}
		else if e(df_1) < 1000 {
			local predf  " chi2("
			local postdf ") ="
		}
		else {
			local predf  " chi2("
			local postdf ")="
		}
		local xsp " "
		if e(f) != 1 {
			local fs "s"
			local xsp ""
		}
		dis as txt _col(5) "LR test:`xsp'"		///
		    as res %4.0f e(f)				///
		    as txt " factor`fs' vs. saturated:`predf'"	///
		    as res e(df_1)				///
		    as txt "`postdf'"				///
		    as res `fmt' e(chi2_1)			///
		    as txt " Prob>chi2 ="			///
		    as res %7.4f chi2tail(e(df_1),e(chi2_1))

		if `"`e(heywood)'"' != "" {
			dis as txt _col(5) "(tests formally not valid " /// 
				"because a " ///
				"{help heywood_case##|_new:Heywood case} " ///
				"was encountered)"
		}
	}
end


program LoadingTable
	syntax [, 		       ///	
	   noROTated                   /// unrotated results
	   BLanks(numlist max=1 >=0)   /// small loadings as blanks
	]

	if "`rotated'" != "" {
		// at this point it is known that rotated results are avail.	
		local rtxt     "Unrotated factor"
		local rprefix
	}
	else if "`e(r_criterion)'" != "" {
		local rtxt     "Rotated factor"
		local rprefix  r_
	}
	else {
		local rtxt     "Factor"
		local rprefix
	}

	
	if e(f) == 0 { 
		matlist e(Psi)' , border(bot) format(%10.0g)  ///
		   rowtitle(Variable) tindent(0) left(4)      /// 
		   title(Unique variances are 1 since no factors retained)
		exit
	}

	
	tempname X
	
	matrix `X' = e(`rprefix'L)
	if "`blanks'" != "" {
		_small2dotz `X' `blanks'
		local btxt  "(blanks represent abs(loading)<{res:`blanks'})"
	}

	local r = rowsof(`X')
	local c = colsof(`X')
	forvalues i = 2 / `r' {
		local hsp `hsp'&
	}
	forvalues i = 1 / `c' {
		local csp `csp' %8.4f
		if (`i' < `c') local csp `csp' &
	}
		
	matrix `X' = nullmat(`X') , e(Psi)'

	dis _n as txt "`rtxt' loadings (pattern matrix) and unique variances"
	
	matlist `X' , rowtitle(Variable) nodotz     ///
	   cspec(o4& %12s | `csp' | C w12 %10.4f o1&) ///
	   rspec(--`hsp'-)

	if "`btxt'" != "" {
		dis "    `btxt'"
	}
	   
	if "`rprefix'" != "" { 
		dis as txt _n "Factor rotation matrix"
		matlist e(r_T), format(%7.4f) border(row) left(4) 
	}	
end


program Mtitle, rclass
	args method
	
	if "`method'" == "pf" {
		return local mtitle  "principal factors"
	}
	else if "`method'" == "pcf" {
		return local mtitle  "principal-component factors"
	}
	else if "`method'" == "ipf" {
		return local mtitle  "iterated principal factors"
	}
	else if "`method'" == "ml" {
		return local mtitle  "maximum likelihood"
	}
	else {
		_stata_internalerror factor
	}
end


program NoPCA
	dis as err ///
	  "{p}principal component analysis (option {cmd:pc}) not " ///
	  "available in factor; see {help pca##|_new:help pca}{break}" ///
	  "specify option {cmd:pcf} for principal-components " ///
	  "factor analysis"
	exit 198
end
exit
