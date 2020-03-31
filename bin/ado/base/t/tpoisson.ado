*! version 1.1.0  14mar2018
program tpoisson, eclass byable(onecall) ///
		prop(irr ml_score svyb svyj svyr bayes)
	version 11.0
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun tpoisson, mark(EXPosure OFFset CLuster) : `0'
	if "`s(exit)'" != "" {
		version 11: ereturn local cmdline `"tpoisson `0'"'
		exit
	}

	version 8.1
	local version : di "version " string(_caller()) ":"
	if replay() {
		if ("`e(cmd)'" != "tpoisson") error 301
		if (_by()) error 190
		Display `0'
		error `e(rc)'
		exit
	}
	`version' `BY' Estimate `0'
	ereturn local cmdline `"tpoisson `0'"'
end

program Estimate, eclass byable(recall)

/* Parse. */

	syntax varlist(numeric fv ts) [fw pw iw] [if] [in] [, IRr /*
		*/ FROM(string) Level(cilevel) OFFset(varname numeric ts) /*
		*/ Exposure(varname numeric ts) noCONstant Robust /*
		*/ CLuster(varname) LL(string) UL(string) SCore(string) /*
		*/ noDISPLAY CRITTYPE(passthru) moptobj(passthru) * ]

	version 11.0
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	if _by() {
		_byoptnotallowed score `"`score'"'
	}

	_get_diopts diopts options, `options'
	mlopts mlopts, `options'
	local coll `s(collinear)'
	local cns `s(constraints)'
	local mlopts `mlopts' `crittype'

/* Check syntax. */
	if `"`score'"'!="" {
		confirm new variable `score'
		local nword : word count `score'
		if `nword' > 1 {
			di as error "{cmd:score()} must contain the " ///
			"name of only one new variable"
			exit 198
		}
		tempvar scvar
		local scopt score(`scvar')
	}
	if "`offset'"!="" & "`exposure'"!="" {
		di as error "only one of {cmd:offset()} or " ///
		"{cmd:exposure()} can be specified"
		exit 198
	}
	if "`constant'"!="" {
		local nvar : word count `varlist'
		if `nvar' == 1 {
			di as error "independent variables required with " /*
			*/ "{cmd:noconstant} option"
			exit 100
		}
	}

/* Mark sample except for offset/exposure. */

	marksample touse

	if `"`cluster'"'!="" {
		markout `touse' `cluster', strok
		local clopt cluster(`cluster')
	}
	tokenize "`ll'", parse(" ,")
	if "`2'" != "" {
		di as error "must specify only one argument in ll()"
		error 200
	}
	cap confirm numeric variable `ll'
	local isvar = 0
	if _rc==0 {
		unab ll : `ll', max(1)
		markout `touse' `ll'
		local isvar = 1
	}
	else {
		cap noisily
	}

	/* check syntax and grab ll() */
	if (`"`ll'"' == "" & `"`ul'"' == "") {
 		local tp = 0
	}
	if ("`ll'" != ""){
		cap confirm names `ll'
		if _rc!=0 {
		/* it is not a name, should be a number */
			cap confirm number `ll'
			if _rc!=0{
				di as error "{cmd:ll(`ll')} must specify " ///
					"a nonnegative value"
				exit 200
			}
			else{
				local tp = `ll'
				capture noisily
			}
		}
		else{
		/* ll() does not contain a number */
			if `isvar'==0 {
			/* ll() contains a name that is not a variable */
			/* possibly it is a scalar                     */
				local tp = `ll'
				cap confirm number `tp'
				if _rc!=0{
					di as error "{cmd:ll(`ll')} must " ///
						"specify a nonnegative value"
					exit 200
				}
			}
			else {
			/* ll() contains the name of a variable */
				local tp `ll'
				qui summarize `tp' if `touse', meanonly
				if r(min) < 0 {
					di as error "{cmd:ll(`ll')} " ///
						"must contain all "   ///
						"nonnegative values"
					exit 200
				}
				tempvar _d _n
				qui gen double `_d'  = `tp' - int(`tp') ///
					if `touse'
				qui gen int `_n'  = 1 if `_d'!=0 & `touse'
				qui sum `_n' if `touse', meanonly
				local m = r(N)
				if `m' > 0 {
					local s
					if `m' > 1 {
						local s s
					}
					di as error "{cmd:ll(`ll')} " ///
					"contains `m' noninteger value`s'"
					exit 200
				}
			}
		}
		if `isvar'==0 {
			if `tp' < 0{
				di as error "{cmd:ll(`ll')} must specify " ///
					"a nonnegative value"
				exit 198
			}
			local a = `ll'
			cap confirm integer number `a'
			if _rc!=0 {
				di as error "{cmd:ll(`ll')} " ///
					"must specify an integer"
				exit 198
			}
		}
	}
	ereturn local llopt `tp'
							// parse ul()
	ParseUL, ul(`ul') touse(`touse')
	local ul_tp `s(ul_tp)'
	local ul_isvar `s(ul_isvar)'

/* Process offset/exposure. */

	if "`exposure'"!="" {
		capture assert `exposure' > 0 if `touse'
		if _rc!=0 {
			di as error "{cmd:exposure()} must be greater " ///
				"than zero"
			exit 459
		}
		tempvar offset
		qui gen double `offset' = ln(`exposure')
		local offvar "ln(`exposure')"
	}

	if "`offset'"!="" {
		markout `touse' `offset'
		local offopt "offset(`offset')"
		if "`offvar'"=="" {
			local offvar "`offset'"
		}
	}

/* Count obs and check for no-positive values of `y'. */

	gettoken y xvars : varlist
	_fv_check_depvar `y'
	tsunab y : `y'
	local yname : subinstr local y "." "_"

	if "`weight'"!="" {
		if "`weight'"=="fweight" {
			local wt `"[fw`exp']"'
		}
		else local wt `"[aw`exp']"'
	}

	qui summarize `y' `wt' if `touse', meanonly
	if (r(N) == 0)  error 2000
	if (r(N) == 1)  error 2001
	tempname mean nobs
	scalar `mean' = r(mean)
	scalar `nobs' = r(N) /* #obs for checking #missings in calculations */
	local   min   = r(min)
	local 	max   = r(max)
	if `min' < 0 {
		di as error "`y' must be greater than zero"
		exit 459
	}
							// Check LL against y
	CheckDepLL, tp(`tp') min(`min')	isvar(`isvar')	///
		y(`y') touse(`touse')
							// Check UL against y
	CheckDepUL, ul_tp(`ul_tp') ul_isvar(`ul_isvar') 	///
		dep(`y') max_dep(`max') touse(`touse')

/* Check whether `y' is integer-valued. */
	if "`display'"=="" {
		capture assert `y' == int(`y') if `touse'
		if _rc!=0 {
			di in gr "note: you are responsible for " /*
			*/ "interpretation of noncount dep. variable"
			capture noisily
		}
	}

/* Get lf0 = constant-only model log likelihood. */

	if "`constant'`cns'"=="" & "`cluster'"=="" & "`weight'"!="pweight" {
				/* pseudo-R2 is OK for robust */
		tempname c
		if "`offset'"!="" {
			SolveC `y' `offset' [`weight'`exp'] if `touse', /*
			*/ n(`nobs') mean(`mean')
			scalar `c' = r(_cons)
			if `c'>=. {
				di in gr /*
				*/ "note: exposure = exp(`offvar') "/*
				*/ _n /*
				*/ "overflows; could not estimate "/*
				*/ "constant-only model" _c
				if "`exposure'"=="" {
					di in gr _n /*
					*/ "      use exposure() option for "/*
					*/ "exposure = `offvar'"
				}
				else 	di in gr
				local cfail 1
			}
			local c "`c'+`offset'"
		}
		else	scalar `c' = ln(`mean')
		if "`cfail'"=="" {
			LikePois2 `y' `c' [`weight'`exp'] /*
				*/if `touse', n(`nobs') tp(`tp') ul_tp(`ul_tp')

			if r(lnf)<. {
				local ll0 "lf0(1 `r(lnf)')"
			}
			else {
				di in gr "note: could not compute " /*
				*/ "constant-only model log likelihood"
			}
		}
	}

/* Remove collinearity. */

	if `fvops' {
		local rmcoll "version 11: _rmcoll"
		local vv : di "version " string(max(11,_caller())) ", missing:"
		local mm e2
		local negh negh
	}
	else {
		local rmcoll _rmcoll
		local mm d2
	}
	`rmcoll' `xvars' [`weight'`exp'] if `touse', `constant' `coll'
	local xvars `r(varlist)'

/* Get initial values. */
	if "`from'"=="" {
		`vv' ///
		Ipois `y' `xvars' [`weight'`exp'] if `touse', 		///
			n(`nobs') mean(`mean') `constant' 		///
			`offopt' tp(`tp') ul_tp(`ul_tp')

		if "`r(b0)'"!="" {
			tempname from
			mat `from' = r(b0)
		}
	}

	if "`from'"!="" {
		local initopt `"init(`from') search(off)"'
	}
	else local initopt "search(on) maxfeas(50)"

	global ZTP_tp_ `tp'
	global ZTP_ul_tp_ `ul_tp'
	if `"`ul_tp'"'=="" {
		local lnL tpoiss_d2
	}
	else {
		local lnL tpoiss_ul_d2
	}

	// save all globals needed by the recallable evaluator
	// GLIST is consumed by moptimize_init_macros in moptimize_init.ado
	global GLIST : all globals "ZTP_*"

	`vv' ml model `mm' `lnL' /*
	*/ (`yname': `y' = `xvars', `constant' `offopt') /*
	*/ [`weight'`exp'] if `touse', collinear missing max nooutput /*
	*/ nopreserve `mlopts' /*
	*/ `scopt' `robust' title("Truncated Poisson regression") /*
	*/ `clopt' `initopt' `ll0' `negh' `moptobj'
	if `isvar' == 0 {
		local tle = abbrev("`tp'", 12)
	}
	else {
		local tle = abbrev("`ll'", 12)
	}
	local tul = abbrev(`"`ul_tp'"', 12)
	eret hidden local title2 "Truncation point: {res:`tle' `tul'}"
	eret local title "Truncated Poisson regression"
	eret hidden local ul_isvar = `ul_isvar'
	macro drop ZTP_tp_
	macro drop ZTP_ul_tp_

	if "`score'" != "" {
		label var `scvar' "Score index from poisson"
		rename `scvar' `score'
		eret local scorevars `score'
	}
	eret scalar r2_p = 1 - e(ll)/e(ll_0)
	eret local offset  "`offvar'"
	eret local offset1 /* erase; set by -ml- */
	eret local predict "tpoisson_p"
	eret local cmd     "tpoisson"
	eret local llopt "`tp'"
	eret local ulopt "`ul_tp'"
						//  limit_l
	if (`"`tp'"'=="") {
		eret hidden local limit_l "{txt}(none)"
	}
	else {
		eret hidden local limit_l `tp'
	}
						//  limit_u
	if (`"`ul_tp'"'=="") {
		eret hidden local limit_u "+inf"
	}
	else {
		eret hidden local limit_u `ul_tp'
	}

	if "`display'"=="" {
			Display, `irr' level(`level') `diopts'
	}

	eret hidden local title2 "Truncation points: `tle' `tul'"
	eret local title "Truncated Poisson regression"
	error `e(rc)'

end

program Display
	syntax [, Level(cilevel) IRr *]
	if "`irr'"!="" {
		local eopt "eform(IRR)"
	}
	_get_diopts diopts, `options'

	if "`e(prefix)'" == "svy" {
		_prefix_display `0'
		exit
	}

  	Head
	version 9: ml di, level(`level') `eopt' nofootnote `diopts' noheader
	_prefix_footnote
end

program Head
//--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----
						// title
	local title _n as txt `"Truncated Poisson regression"' 
						// Number of obs
	local n_obs as txt _col(49) `"Number of obs"' 	///
		as txt _col(67) "= " as res %10.0fc e(N)
						//  Number of replications if
						//  exists
	if !missing(e(N_reps)) {
		local n_reps as txt _col(49) "Replications" _col(67) "=" ///
			_col(69) as res %10.0fc e(N_reps)
	}
						//  p-value and test
	if !missing(e(df_r)) {
		local model as txt _col(49) 		///
			"F(" 				///
			as res %4.0f e(df_m) 		///
			as txt "," 			///
			as res %7.0f e(df_r) as txt ")"	///
			_col(67) "= " as res %10.2f e(F)

		local pvalue _col(49) as txt "Prob > F"	///
			_col(67) "= " as res %10.4f e(p)
	}
	else {
		if "`e(chi2type)'" == "" {
			local chitype Wald
		}
		else	local chitype `e(chi2type)'
		local model _col(49) as txt `"`chitype' chi2("' ///
			as res e(df_m) as txt ")" 		///
			_col(67) "= " as res %10.2f e(chi2)
		local pvalue _col(49) as txt "Prob > chi2"	///
			_col(67) "= " as res %10.4f e(p)
	}
						//  Limits
	cap confirm var `e(llopt)'
	if _rc {
		local llopt: display %10.0g `e(llopt)'
	}
	else local llopt: display %10s "`e(llopt)'" 
	cap confirm var `e(ulopt)'
	if _rc {
		local ulopt: display %10.0g `e(ulopt)'
	}
	else local ulopt: display %10s "`e(ulopt)'" 

	if (`"`e(llopt)'"'=="") {
		local llopt "    {txt}(none)" 
	}

	if (`"`e(ulopt)'"'=="") {
		local ulopt "      +inf" 
	}

	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
	*/ bsubstr(`"`e(crittype)'"',2,.)
	local crlen = length(`"`crtype'"')
	local crlow = `crlen' - length("Limits:")

	local limit_ll as txt "Limits:" as txt %`crlow's  /// 
     		"lower" " = " as res "`llopt'" 

	local limit_ul as txt %`crlen's "upper" " = " as res "`ulopt'" 

						// ll and  pseudo-R2
	local r2
	if (e(r2_p)!=.) {
		local r2 _col(49) as txt "Pseudo R2" _col(67)	///
			"= " as res %10.4f e(r2_p)
	}
	local ll as txt `"`crtype' = "' as res %10.0g e(ll) 

						//  Display Header	
	if (`"`r2'"'!="") {
		if (`"`n_reps'"'=="") {
			di `title' `n_obs'
			di `limit_ll' `model'
			di `limit_ul' `pvalue'
			di `ll' `r2'
		}
		else {
			di `title' `n_obs'
			di `limit_ll' `n_reps'
			di `limit_ul' `model'	
			di `pvalue'
			di `ll' `r2'
		}
	}
	else {
		if (`"`n_reps'"' == "") {
			di `title'
			di `limit_ll' `n_obs'
			di `limit_ul' `model'
			di `ll' `pvalue'
		}
		else {
			di `title' `n_obs'
			di `limit_ll' `n_reps'  
			di `limit_ul' `model'
			di `ll' `pvalue'
		}
	}
	di
end

program LikePois, rclass
	gettoken y  0 : 0
	gettoken xb 0 : 0
	syntax [fw aw pw iw] [if] , Nobs(string) tp(string)
	if "`weight'"!="" {
		if "`weight'"=="fweight" {
			local wt `"[fw`exp']"'
		}
		else	local wt `"[aw`exp']"'
	}
	tempvar lnf
	qui gen double `lnf' = `y'*(`xb')-exp(`xb')-lngamma(`y'+1) /*
			*/ -ln(poissontail(exp(`xb'),`tp'+1)) `if'
	summarize `lnf' `wt' `if', meanonly
	if (r(N) != `nobs')  exit
	ret scalar lnf = r(sum)
end
						//----LikePois2 with ul_tp----//
program LikePois2, rclass
	gettoken y  0 : 0
	gettoken xb 0 : 0
	syntax [fw aw pw iw] [if] , Nobs(string) [tp(string) ul_tp(string)]
	if "`weight'"!="" {
		if "`weight'"=="fweight" {
			local wt `"[fw`exp']"'
		}
		else	local wt `"[aw`exp']"'
	}
	tempvar lnf
	if `"`ul_tp'"' == "" {
						//  Pr_B = Pr(ll< y)
		local Pr_B poissontail(exp(`xb'),`tp'+1)	
	}
	else if `"`tp'"' == "" {
						//  Pr_B = Pr(y< ul)
		local Pr_B poisson(exp(`xb'),`ul_tp'-1)
	}
	else if `"`tp'"' != "" {	
						//   Pr_B = Pr(ll < y <ul)
		local Pr_B poisson(exp(`xb'),`ul_tp'-1)-poisson(exp(`xb'),`tp')
	}
	qui gen double `lnf' = `y'*(`xb')-exp(`xb')-lngamma(`y'+1) /*
			*/ -ln(`Pr_B') `if'
	summarize `lnf' `wt' `if', meanonly
	if (r(N) != `nobs')  exit
	ret scalar lnf = r(sum)
end


program SolveC, rclass /* note: similar code is found in nbreg.ado */
	gettoken y  0 : 0
	gettoken xb 0 : 0
	syntax [fw aw pw iw] [if] , Nobs(string) Mean(string)
	if "`weight'"=="pweight" | "`weight'"=="iweight" {
		local weight "aweight"
	}
	capture confirm variable `xb'
	if _rc!=0 {
		tempvar xbnew
		qui gen double `xbnew' = (`xb') `if'
		local xb `xbnew'
		capture noisily
	}
	summarize `xb' [`weight'`exp'] `if', meanonly
	if (r(N) != `nobs') exit
	if (r(max) - r(min) > 2*709 ) { /* unavoidable exp() over/underflow */
		exit /* r(_cons) is missing */
	}
	if r(max) > 709 | r(min) < -709  {
		tempname shift
		if r(max) > 709 { scalar `shift' =  709 - r(max) }
		else		  scalar `shift' = -709 - r(min)
		local shift "+`shift'"
	}
	tempvar expoff
	qui gen double `expoff' = exp(`xb'`shift') `if'
	summarize `expoff' [`weight'`exp'], meanonly
	if (r(N) != `nobs')  exit  /* should not happen */
	return scalar _cons = ln(`mean')-ln(r(mean))`shift'
end

program Ipois, rclass
	syntax varlist(fv ts) [fw aw pw iw/] [if] , Nobs(string) Mean(string)/*
		*/[ tp(string) noCONstant OFFset(string) ul_tp(string)]
	gettoken y xvars : varlist

	tempvar xb z
	tempname b1 b2 lnf1

	if "`weight'"!="" {
		local awt `"[aw=`exp']"'
		local wt  `"(`exp')*"'
		local exp `"=`exp'"'
	}
	quietly {

	/* Initial values: b1 = b/mean, where b are coefficients
	   from reg `y' `xvars' and mean is mean of `y'.
	*/
		if "`offset'"!="" {
			tempvar ynew
			qui gen double `ynew' = `y' - `offset'*`mean' `if'
			local poff "+`offset'"
		}
		else	local ynew `y'

		`vv' ///
		_regress `ynew' `xvars' `awt' `if', `constant'
		mat `b1' = (1/`mean')*e(b)
		mat score double `xb' = `b1' `if'
		LikePois2 `y' `xb'`poff' [`weight'`exp'] `if', /*
			*/ n(`nobs') tp(`tp') ul_tp(`ul_tp')
		scalar `lnf1' = r(lnf)
	}

	/* Solve for _cons (change) for poisson likelihood given b1. */

	if "`constant'"=="" {
		SolveC `y' `xb'`poff' [`weight'`exp'] `if', /*
		*/ n(`nobs') mean(`mean')
		tempname c
		scalar `c' = r(_cons)
		if `c'<. {
			local c "+`c'"
		}
		else	local c /* erase macro */
		LikePois2 `y' `xb'`poff'`c' [`weight'`exp'] `if', /*
			*/ n(`nobs') tp(`tp') ul_tp(`ul_tp')
		tempname lnf1c
		scalar `lnf1c' = r(lnf)
	}
	else	local lnf1c .

	/* Take iteratively reweighted least-squares step to get b2. */
	capture {
		qui gen double `z' = `y'*exp(-(`xb'`poff'`c'))-1 /*
		*/ +`xb'`c' `if'

		`vv' ///
		_regress `z' `xvars' [aw=`wt'exp(`xb'`poff'`c')] `if', /*
		*/ `constant'
		mat `b2' = e(b)
		drop `xb'
		_predict double `xb' `if'
		LikePois2 `y' `xb'`poff' [`weight'`exp'] `if', /*
			*/ n(`nobs') tp(`tp') ul_tp(`ul_tp')
		tempname lnf2
		scalar `lnf2' = r(lnf)
	}
	if _rc!=0 {
		local lnf2 .
		capture noisily
	}
	if (`lnf1'>=. & `lnf1c'>=. & `lnf2'>=.)  exit
	if `lnf2'<.&(`lnf2'>`lnf1'|`lnf1'>=.)&(`lnf2'>`lnf1c'|`lnf1c'>=.) {
		ret matrix b0 `b2' /* `lnf2' best */
		exit
	}
	if `lnf1'<.&(`lnf1'>`lnf1c'|`lnf1c'>=.)&(`lnf1'>`lnf2'|`lnf2'>=.) {
		ret matrix b0 `b1' /* `lnf1' best */
		exit
	}

	local dim = colsof(`b1')
	mat `b1'[1,`dim'] = `b1'[1,`dim']`c'
	ret matrix b0 `b1' /* `lnf1c' best */
end
							//---------ParseUL----//
program ParseUL, sclass
	syntax [, UL(string) touse(string)]		
						// too many argument errors
	tokenize "`ul'", parse(" ,")
	if `"`2'"'!="" {
		di as error "must specify only one argument in {bf:ul()}"	
		error 200
	}
	
	local ul_tp 
	
	CheckVarUL, ul(`ul') touse(`touse')
	local ul_isvar = `s(ul_isvar)'
	local ul_tp `s(ul_tp)'

	if `"`ul'"' != "" {
		cap confirm names `ul'
		if _rc != 0 {
			CheckNumberUL, ul(`ul')
			local ul_tp = `s(ul_tp)'
		}
		else if `ul_isvar' == 0 {
			CheckScalarUL, ul(`ul')
			local ul_tp = `s(ul_tp)'
		}

		if `ul_isvar' == 0 {
			CheckNumberTPUL, ul(`ul') ul_tp(`ul_tp')
		}
	}

	sreturn local ul_tp `ul_tp'
	sreturn local ul_isvar `ul_isvar'
end
							//--CheckNumberTPUL---//
program CheckNumberTPUL
	syntax [, ul(string) ul_tp(string)]
	if `ul_tp' < 0 {
		di as error "{bf: ul(`ul')} must specify a nonnegative value"	
		exit 198
	}
	local a = `ul'
	cap confirm integer number `a'
	if _rc != 0 {
		di as error "{bf: ul(`ul')} must specify an integer"
		exit 198
	}
end
							//-----CheckNumberUL--//
program CheckNumberUL, sclass
	syntax [, ul(string)]
	cap confirm number `ul'
	if _rc !=0 {
		ErrorUL, ul(`ul')
	}
	else {
		local ul_tp = `ul'
	}
	sreturn local ul_tp = `ul_tp'
end
							//-----CheckScalarUL--//
program CheckScalarUL, sclass
	syntax [, ul(string)]	
	local ul_tp = `ul'
	cap confirm number `ul_tp'
	if _rc !=0 {
		ErrorUL, ul(`ul')
	}
	sreturn local ul_tp = `ul_tp'
end
							//-----CheckVarUL-----//
program CheckVarUL, sclass
	syntax [, ul(string) touse(string)]
	capture confirm numeric variable `ul'
	local ul_isvar = 0
	if _rc == 0 {
		unab ul : `ul', max(1)	
		markout `touse' `ul'
		local ul_isvar = 1
							// negative ul
		local ul_tp  `ul'
		qui sum `ul_tp' if `touse', meanonly
		if (r(min) < 0) {
			ErrorVarUL, ul(`ul')
		}
							// noninteger ul
		capture assert `ul_tp' == int(`ul_tp') if `touse'
		if _rc != 0 {
			ErrorNonintUL, ul(`ul')
		}
	}
	sreturn local ul_isvar = `ul_isvar'
	sreturn local ul_tp   `ul_tp'
end
							//---ErrorNonintUL---//
program ErrorNonintUL
	syntax [, ul(string) ]

	di as error "{bf:ul(`ul')} contains noninteger values" 
	exit 200
end
							//------ErrorVarUL----//
program ErrorVarUL
	syntax [, ul(string) ]

	di as error "{bf:ul(`ul')} must contain all nonnegative values" 
	exit 200
end
							//--------ErrorUL-----//
program ErrorUL
	syntax [, ul(string) ]

	di as error "{bf:ul(`ul')} must specify" ///
		" a nonnegative value" 
	exit 200
end
							//------CheckDepUL--//
program CheckDepUL
	syntax [, ul_tp(string) 	///
		ul_isvar(string) 	///
		dep(string) 		///
		max_dep(string) 	///
		touse(string)]
	
	if (`"`ul_tp'"' == "") {
		cap noisily	
	}
	else if (`ul_isvar' == 0) {
		if `max_dep' >= `ul_tp' {
			di as error	///
				"{p 0 4 2}truncation value specified in "  ///
				"{bf:ul()} must be "			   ///
				"greater than `max_dep', the greatest "  ///
				"value in `dep'{p_end}"
			exit 459
		}
	}
	else if (`ul_isvar' == 1) {
		cap assert `ul_tp' > `dep' if `touse'
		if _rc != 0{
			di as error ///
				"{p 0 4 2}values in `dep' must be smaller " ///
				"than their truncation value specified "  ///
				"in {bf:ul(`ul_tp')}{p_end}"
			exit 459
		}
	}
end
							//-- CheckDepLL --//
program CheckDepLL
	syntax [, tp(string)	///
		min(string)	///
		isvar(string)	///
		y(string)	///
		touse(string)]	
	
	if (`"`tp'"' == "") {
		exit	
		// NotReached
	}

	if `min' == 0 {
		di as error ///
			"{p 0 4 2}some observations on `y' are zero, "   ///
			"truncated Poisson model is inappropriate{p_end}"
			exit 459
	}

	if `isvar'==0 {
		if `min' <= `tp' {
			di as error  ///
				"{p 0 4 2}truncation value specified in "  ///
				"{bf:ll()} must be " 			   ///
				"less than `min', the smallest value "	   ///
				"in `y'{p_end}"
			exit 459
		}
	}
	else {
		tempvar _dif
		quietly gen double `_dif' = `y' - `tp' if `touse'
		quietly summarize `_dif' if `touse', meanonly
		if r(min) <= 0 {
			di as error ///
				"{p 0 4 2}values in `y' must be greater " ///
				"than their truncation value specified "  ///
				"in {bf:ll(`tp')}{p_end}"
			exit 459
		}
		drop `_dif'
	}
end
