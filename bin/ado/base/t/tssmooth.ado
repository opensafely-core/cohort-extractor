*! version 1.5.5  06sep2012
program define tssmooth, sortpreserve rclass
	version 8.0

/* syntax 
 *	tssmooth smoother [type] newvarname  = exp [if] [in] , options 
 */	
	gettoken new left : 0, parse("=")
/* left contains = exp [if] [in] , options */	
	gettoken sm new : new
/* sm contains smoother, new contains [type] newvarname */
	
	local 0 ", `sm'"
	capture syntax , [Ma nl Exponential Dexponential Hwinters Shwinters]
	if _rc > 0 {
		di as err "`sm' is not a valid smoother"
		exit 198
	}
	if "`ma'`nl'`exponential'`dexponential'`hwinters'`shwinters'" /*
		*/ == ""  {
		di as err "Smoother not found"
		exit 198
	}	
	

/* save off any current e() results */	

	tempvar esamp
	tempname pest 
	
	_estimates hold `pest', copy restore nullok varname(`esamp')

	cknew , `new' 

	local 0 "`left'"
	syntax =exp [if] [in] [, *]
	local opts ", `options'"

	local myexp2 `"`exp'"'

	marksample touse, novarlist

	tempvar count1

	gen long `count1' = (`touse' > 0)
	qui count if `count1' >0
	local Nobs = r(N)
	if r(N) ==0 {
		di as err "no observations"
		exit 198
	}	

/* must include check for left in case user omits comma */
	if "`new'" == "" | "`left'" == "" {
		error 198
	}

	
	
/* check that data is tsset */

	qui tsset, noquery
	local tvar `r(timevar)'

	if "`r(panelvar)'" != "" {
		local pvar "`r(panelvar)'"
		local panel "panel"
		qui sum `pvar' if `touse'
		if r(min) < r(max) {
			local byp " by `pvar' : "
		}	
		else {
			local panelp = r(min)
			local panelp "panelp(`panelp') "
		}
	}

	qui sort `pvar' `tvar'

	qui `byp' replace `count1' = sum(`count1')
	qui `byp' replace `count1' = `count1'[_N] 
	if "`pvar'" == "" {
		qui sum `count1'
		local Nobs2 = int(r(max)/2)
	}
	else {
		qui xtsum `count1'
		local Nobs2 = int(r(max)/2)
	}

/* create old from expression */
	tempvar old tousef
	
	qui`byp' gen double `old' `myexp2' if `touse'
	label variable `old' `"`myexp2'"'

	qui tsreport if `touse', panel 
	local pgaps = r(N_gaps)
	qui tsreport if `touse' 
	local gaps = r(N_gaps)
	if  `pgaps' != `gaps' & "`nl'" != "" {
		di as err "tssmooth , nl() does not work with more" /*  
			*/ " than one panel in a sample"
		exit 198	
	}			 

/* parse out replace if present
 * 
 */
 	local 0 " `opts'"
	syntax [, replace *] 

/* check for type 
 *	n=1 => name only set type to float
 *	n=2 => type specified
 *	n>2 => syntax error
 */	
	local n : word count `new'
	if `n' == 1 {
		local nname "`new'"
		local new "float `new'"
	}
	if `n' == 2 {
		tokenize `new' 
		local nname "`2'"
	}
	if `n' > 2 {
		capture drop `old'
		error 198
	}	
	if "`replace'" == "" {
		confirm new variable `nname'
	}	
	else {
		capture drop `nname'
	}
/* local new now contains type
 * and local nname contains name of new variable
 */ 

	local 0 " `opts'"
	syntax , [  Forecast(numlist min=1 max=1 >=0 <=500) * ] 
	if "`forecast'"  != "" {
		myadd `old' if `touse', fcast(`forecast') `panelp'
	}

/* define tousef = forecasting sample */

	gen byte `tousef'=cond(`touse'<.,`touse',1)

/* update touse = estimation sample, excludes observations added
 * for forecasting 
 */
	qui replace `touse' = 0 if `touse' >=.


/* now parse each smoother and call work program */	

	if "`ma'" != "" {
		local 0 " `opts'"
		syntax , [ Window(numlist integer min=1 max=3 >=0 <=`Nobs2')/*
			*/ WEights(string) replace]

		if "`window'" != "" & "`weights'" != "" {
			di as err "specify either window() or weights(), not "/*
				*/ "both"
			exit 198
		}
		if "`window'`weights'" == "" {
			di as err "either window() or weights() must be "/*
				*/ "specified"
			exit 198
		}

		if "`window'" != "" {

			local wels : word count `window'
			tokenize `window'

			if `wels' < 1 {
				di as error "window(`window') invalid"
				exit 198
			}	

			if `wels' > 3 {
				di as error "window(`window') invalid"
				exit 198
			}	
		
			if `wels' == 1 {
				local bt `1' 
				local a0 0
				local ft 0
			}	
		
			if `wels' == 2 {
				local bt `1' 
				local a0 `2'
				local ft 0
			}	
		
			if `wels' == 3 {
				local bt `1' 
				local a0 `2'
				local ft `3'
			}	

			if `a0' < 0 | `a0' > 1 {
				di as err "coefficient on x(t) specified " /*
					*/ "in window() is neither 0 nor 1"
				di as err "window(`window') invalid"
				exit 198
			}	
			local lbl "`a0'*x(t)"
			local terms `a0'

			forvalues i = 1/`bt' {
				local back "`back' 1 "
				local lbl "x(t-`i') + `lbl'"
			}
			if `bt' >= 1 {
				local backward "backward(`back')"
			}
			else {
				local backward 
			}
			
			forvalues i = 1/`ft' {
				local forw "`forw' 1 "
				local lbl "`lbl' + x(t+`i')"
			}
			if `ft' >= 1 {
				local forward " forward(`forw') "
			}
			else {
				local forward 
			}

			local terms = `a0' + `bt' + `ft' 

			local lbl "(1/`terms')*[`lbl']"
			local lblen : length local lbl
			if `lblen' > 80 {
				local lbl0 = "`lbl'"
				trs2space, s0("`lbl0'")
				local lbl0 "`s(string)'"
				local lbl0 "`lbl0' ..."
			}	
			else {
				local lbl0  "`lbl'"
			}
			local lbl "`byp'`lbl'; x(t)`myexp2'"	
			local lbl0 "`byp'`lbl0'; x(t)`myexp2'"	
			_tsma `new' `old' , `backward' a0(`a0') /*
				*/ `forward' touse(`touse')

			ret add

			di as txt "The smoother applied was"
			di as res "{p 5 5 5}`lbl0'{p_end}"

			char `nname'[tssmoother] `lbl'
			local lbl2 "ma: x(t)`myexp2': window(`window')"	
			label variable `nname' "`lbl2'" 

			local myexp2 : subinstr local myexp2 "= " ""
			local myexp2 : subinstr local myexp2 "=" ""
			ret local exp "`myexp2'"
			
			exit
		}
/* below is the weights section */		

/* begin parse weights*/
		local tmp : subinstr local weights "<" "<", count(local bc)
		if `bc' != 1 {
			di as err "missing < in weights()"
			di as err "weights(`weights') invalid"
			exit 198
		}
		local tmp : subinstr local weights ">" ">", count(local bc)
		if `bc' != 1 {
			di as err "missing > in weights()"
			di as err "weights(`weights') invalid"
			exit 198
		}
		
			// Numlists can be at most 1600 elements long
		local maxlistlen = min(`Nobs2', 1600) 
		gettoken num1  lefta : weights , parse("<")
		if "`num1'" != "<" {
			local left "`lefta'"
			capture numlist "`num1'", max(`maxlistlen')
			if _rc > 0 {
				di as err "First numlist in " /*
					*/ "weights(`weights') invalid"
				exit 198
			}	
			local back "`r(numlist)'"
		}
		else {
			local left "`weights'"
			local back 
		}


		gettoken b1 left : left , parse("<")


		gettoken a0 left : left , parse(">")
		capture confirm number `a0'
		if _rc > 0 {
			di as err "coefficient for x(t) in " /*
				*/ "weights(`weights') invalid"
			exit 198
		}	


		gettoken b2 num2 : left , parse(">")
		if "`num2'" != "" {
			capture numlist "`num2'" , max(`maxlistlen')
			if _rc > 0 {
				di as err "Second numlist in "/*
					*/ "weights(`weights') invalid"
				exit 198
			}	
			local forw "`r(numlist)'"
		}
		else {
			local forw 
		}

/* end parse weights*/

		local lbl "`a0'*x(t)"
		local terms `a0'

		local bcnt : word count `back'
		local i 1
		foreach b of local back   {
			local j = `bcnt' - `i' + 1
			local bi : word `j' of `back'
			local lbl "`bi'*x(t-`i') + `lbl'"
			local terms = `terms' + `b'
			local i = `i' + 1
		}
		local backward "backward(`back')"
			

		local i 1
		foreach ft of local forw   {
			local lbl "`lbl' + `ft'*x(t+`i')"
			local terms = `terms' + `ft'
			local i = `i' + 1
		}
		local forward " forward(`forw') "
			

		if abs(`terms') < 1e-7 {
			di as err "coefficients in weights() sum to zero"
			exit 198
		}	

		local lbl "(1/`terms')*[`lbl']"

		local lblen : length local lbl
		if `lblen' > 80 {
			local lbl0 = "`lbl'"
			trs2space, s0("`lbl0'")
			local lbl0 "`s(string)'"
			local lbl0 "`lbl0' ..."
		}	
		else {
			local lbl0  "`lbl'"
		}
		local lbl0 "`byp'`lbl0'; x(t)`myexp2'"	

		local lbl "`byp'`lbl'; x(t)`myexp2'"	

		_tsma `new' `old' , `backward' a0(`a0') /*
			*/ `forward' touse(`touse')
		ret add

		di as txt "The smoother applied was"
		di as res "{p 5 5 5}`lbl0'"

		char `nname'[tssmoother] `lbl'
		local lbl2 "ma: x(t)`myexp2': weights(`weights')"	
		label variable `nname' "`lbl2'"

		ret local timevar `tvar'
		ret local panelvar `pvar'
		local myexp2 : subinstr local myexp2 "= " ""
		local myexp2 : subinstr local myexp2 "=" ""
		ret local exp "`myexp2'"
		ret local method "ma"
		exit
		
		
	}
	

	
	if "`nl'" != "" {
		local 0 " `opts'"
		syntax , [ SMoother(string) replace]

		_ts_nlsmooth `new' `old' , smoother(`smoother') touse(`touse')
		ret add

		local lbl "nl: x(t)`myexp2': smoother(`smoother')"	
		char `nname'[tssmoother] `lbl'
		label variable `nname' "`lbl'"

		ret local timevar `tvar'
		ret local panelvar `pvar'
		ret local smoother "`smoother'"
		ret local method "nl"
		exit
	}


	if "`exponential'" != "" {
		local 0 " `opts'"
		syntax , [ Parms(numlist max=1 >0 <1) 			/*
			*/ SAmp0(numlist max=1 >1 <=`Nobs' integer) 	/*
			*/ s0(numlist max=1 )				/*
undocumented		*/ noDIsplay 					/*
			*/ Forecast(numlist max=1 >=0 <=500 integer )	/*
			*/ replace 					/*
			*/  ]

		if "`parms'" != "" & "`nls'" != "" {
			di as err "specify parms() or nls, not both"
			exit 198
		}	
		if "`samp0'" != "" & "`s0'" != "" {
			di as err "specify samp0() or s0(), not both"
			exit 198
		}
		if "`samp0'" != "" {
			local s0samp "s0samp(`samp0')"
		}

		if "`s0'" != "" {
			local s10 "s10(`s0')"
		}
		if "`forecast'" != "" {
			local fcast "fcast(`forecast')"			
		}

		if "`parms'" != "" {
			qui gen `new'=. 
			capture noi `byp' _ts_exp `new' `old', 		/*
				*/ a(`parms') `s0samp' touse(`touse') 	/*
				*/ `fcast' `s10' `display'
			ret add	
			if _rc > 0 {
				local rc = _rc
				capture drop `nname'
				exit `rc'
			}

			ret local timevar `tvar'
			ret local panelvar `pvar'
			local myexp2 : subinstr local myexp2 "= " ""
			local myexp2 : subinstr local myexp2 "=" ""
			ret local exp "`myexp2'"
			ret local method "exponential"
			exit
		}
		/* if here then opt via bi-section assumed */ 
		qui gen `new'=. 
		capture noi `byp' _ts_exp `new' `old', a(opt) /*
			*/ `s0samp' touse(`touse') `fcast' /*
			*/ `s10' `display' 
		ret add

		if _rc > 0 {
			local rc = _rc
			capture drop `nname'
			exit `rc'
		}
		local lbl : var label `nname'
		char `nname'[tssmoother] `lbl'

		ret local timevar `tvar'
		ret local panelvar `pvar'
		local myexp2 : subinstr local myexp2 "= " ""
		local myexp2 : subinstr local myexp2 "=" ""
		ret local exp "`myexp2'"
		ret local method "exponential"
		exit

	}


	if "`dexponential'" != "" {
		local 0 " `opts'"
		syntax , [ Parms(numlist max=1 >0 <1)	 		/*
			*/ SAmp0(numlist max=1 >1 <=`Nobs' integer )	/*
			*/ s0(numlist min=2 max=2 ) 			/*
undocumented		*/ noDIsplay 					/*
			*/ Forecast(numlist max=1 >=0 <=500 integer )	/*
undocumented		*/ fcomp					/* 
			*/ replace]
/* fcomp forces
 * dexponential to compute
 * the forecasted series instead
 * of the smoothed series
 */ 
		if "`parms'" != "" & "`nls'" != "" {
			di as err "specify parms() or nls, not both"
			exit 198
		}	
		if "`samp0'" != "" & "`s0'" != "" {
			di as err "specify samp0() or s0(), not both"
			exit 198
		}
		if "`samp0'" != "" {
			local s0samp "s0samp(`samp0')"
		}
		if "`s0'" != "" {
			tokenize `s0'
			if "`1'" == "" | "`2'" =="" {
				di as err "s0(`s0') invalid"
				exit 198
			}	
			local s10 "s10(`1')"
			local s20 "s20(`2')"
		}
		if "`forecast'" != "" {
			local fcast "fcast(`forecast')"			
		}

		if "`parms'" != "" {
			qui gen `new'=. 
			capture noi `byp' _ts_dexp `new' `old', 	/*
				*/ a(`parms')  `s0samp' touse(`touse')	/*
				*/ `fcast' `s10' `s20' `display' `fcomp'
			ret add

			if _rc > 0 {
				local rc = _rc
				capture drop `nname'
				exit `rc'
			}
			ret local timevar `tvar'
			ret local panelvar `pvar'
			local myexp2 : subinstr local myexp2 "= " ""
			local myexp2 : subinstr local myexp2 "=" ""
			ret local exp "`myexp2'"
			ret local method "dexponential"
			exit
		}
		/* if here then opt via bisection assumed */ 
		qui gen `new'=. 
		capture noi `byp' _ts_dexp `new' `old', a(opt) 	/*
			*/ `s0samp' touse(`touse') `fcast' 	/*
			*/ `s10' `s20' `display' 		/*
			*/ `fcomp'
		ret add	

		if _rc > 0 {
			local rc = _rc
			capture drop `nname'
			exit `rc'
		}
		local lbl : var label `nname'
		char `nname'[tssmoother] `lbl'
		ret local timevar `tvar'
		ret local panelvar `pvar'
		local myexp2 : subinstr local myexp2 "= " ""
		local myexp2 : subinstr local myexp2 "=" ""
		ret local exp "`myexp2'"
		ret local method "dexponential"

		exit

	}

	if "`hwinters'" != "" {
		local 0 " `opts'"
		syntax , [ Parms(numlist min=2 max=2 >=0 <=1) 	/*
			*/ SAmp0(numlist max=1 >1 <=`Nobs'	/*
			*/ 	integer)			/*
			*/ s0(numlist min=2 max=2 ) 		/*
			*/ Forecast(numlist max=1 >=0 <=500	/*
			*/ 	integer ) 			/*
			*/ Diff 				/*
			*/ FRom(numlist min=2 max=2 >=0 <=1) 	/*
undocumented		*/ noDIsplay				/*
			*/ noLOG				/*
			*/ replace				/*
			*/ NODIFficult				/*
undoc (err checking)	*/ DIFficult				/*
			*/ * ]
		
		mlopts mlopts, `options'

		if "`nodifficult'" != ""  & "`difficult'" != "" {
			di as err "nodifficult cannot be specified "	/*
				*/ "with difficult"
			exit 198
		}		

		if "`nodifficult'" == ""  {
			local difficult difficult
		}
		
		if "`samp0'" != "" & "`s0'" != "" {
			di as err "specify samp0() or s0(), not both"
			exit 198
		}
		if "`s0'" != "" & "`diff'" != "" {
			di as err "specify diff or s0(), not both"
			exit 198
		}
		if "`samp0'" != "" {
			local s0samp "s0samp(`samp0')"
		}
		if "`s0'" != "" {
			tokenize `s0'
			if "`1'" == "" | "`2'" =="" {
				di as err "s0(`s0') invalid"
				exit 198
			}	
			local s10 "s10(`1')"
			local s20 "s20(`2')"
		}
		if "`parms'" != ""  & "`from'" != "" {
			di as err "from() cannot be specified with parms()"
			exit 198
		}
		if "`forecast'" != "" {
			local fcast "fcast(`forecast')"			
		}

		if "`from'" == "" {
			local from "init( .5 .5 ) "
		}
		else {
			local from "init( `from' ) "
		}

		if "`parms'" != "" {
			local ap "a(`parms')"
			local from ""
		}	
		if "`parms'" == "" {
			local ap "a(opt)"
		}	

		if _caller() >= 11 {
			local vv : di "version " string(_caller()) ":"
		}
		qui gen `new'=. 
		`vv' ///
		capture noi `byp' _ts_hw `new' `old', `ap' 	/*
			*/ `s0samp' touse(`touse') `fcast' 	/*
			*/ `s10' `s20' `diff' `from' `log'	/*
			*/ `display'				/*
			*/ `mlopts' `difficult'
		ret add	
		if _rc > 0 {
			local rc = _rc
			capture drop `nname'
			exit `rc'
		}
		local lbl : var label `nname'
		char `nname'[tssmoother] `lbl'
		ret local timevar `tvar'
		ret local panelvar `pvar'
		local myexp2 : subinstr local myexp2 "= " ""
		local myexp2 : subinstr local myexp2 "=" ""
		ret local exp "`myexp2'"
		ret local method "hwinters"

		exit
	}

	if "`shwinters'" != "" {
		local 0 " `opts'"
		syntax , [PERiod(numlist max=1 integer >=2 <=`Nobs2')	/*
			*/ Parms(numlist min=3 max=3 >=0 <=1) 		/*
			*/ SAmp0(numlist max=1 >1 <=`Nobs') 		/*
			*/ s0(numlist min=2 max=2 ) 			/*
			*/ Forecast(numlist max=1 >=0 <=500 integer) 	/*
			*/ FRom(numlist min=3 max=3 >=0 <=1) 		/*
			*/ sn0_0(varname) 				/*
			*/ sn0_v(string) 				/*
			*/ snt_v(string) 				/*
			*/ replace 					/*
			*/ ADDitive 					/*
			*/ ALTstarts 					/*
			*/ Normalize 					/*
			*/ noLOG					/*
undocumented		*/ noDISplay					/*
			*/ NODIFficult					/*
undocumented		*/ DIFficult					/*
			*/ * ] 

		mlopts mlopts , `options' 

		if "`display'" != "" {
			local log nolog
		}

		if "`nodifficult'" != "" & "`difficult'" != "" {
			di as err "nodifficult cannot be specified "	/*
				*/ "with difficult"
			exit 198
		}

		if "`nodifficult'" == "" {
			local difficult difficult
		}	

		if "`altstarts'" != "" & "`sn0_0'" != "" {
			di as err "specify either altstarts or "	/*
				*/ "sn0_0(), not both"
			exit 198
		}	
		if "`altstarts'" != "" & "`s0'" != "" {
			di as err "specify either altstarts or "	/*
				*/ "s0(), not both"
			exit 198
		}	
		if "`period'" == "" {
			qui tsset, noquery
			local fmt "`r(unit1)'"
			if "`fmt'" == "d" {
				local period 365
			}
			if "`fmt'" == "w" {
				local period 52
			}
			if "`fmt'" == "m" {
				local period 12
			}
			if "`fmt'" == "q" {
				local period 4
			}
			if "`fmt'" == "h" {
				local period 2
			}
			if "`fmt'" == "y" {
				di as err "period set by tsset is invalid, "/*
					*/ period must be greater than 1"
				exit 198	
			}
			if "`period'" == "" {
				di as err "period not set by tsset, specify "/*
				*/ "period()"
				exit 198	
			}	
		}
					/* check that sn0_0, which is name
					 *  of variable containing 
					 *  starting values for seasonal
					 *  process, exists and is numeric
					 */
		if "`sn0_0'" != "" {
			capture confirm numeric variable `sn0_0'	
			if _rc >0 {
				di as error "sn0_0() does not specify a "/*
					*/ "numeric variable"
				exit 198
			}	
			local sn0_0m "sn0_0(`sn0_0')"
		}	
					/* check that sn0_v, which is name
					 *  of variable that will contain 
					 *  starting values computed 
					 *  for seasonal
					 *  process, does not exist
					 */
		if "`sn0_v'" != "" {
			capture confirm new variable `sn0_v'	
			if _rc >0 {
				di as error "sn0_v() does not specify a "/*
					*/ "new variable"
				exit 198
			}	
			local sn0_vm "sn0_v(`sn0_v')"
		}	
		if "`sn0_v'" != "" & "`sn0_0'" != "" {
			di as err "sn0_0() and sn0_v() cannot both be"/*
				*/ " specified"
			exit 198	
		}
					/* check that snt_v, which is name
					 *  of variable that will contain 
					 *  the computed values
					 *  for the seasonal
					 *  process, does not exist
					 */
		if "`snt_v'" != "" {
			capture confirm new variable `snt_v'	
			if _rc >0 {
				di as error "snt_v() does not specify a "/*
					*/ "new variable"
				exit 198
			}	
			local snt_vm "snt_v(`snt_v')"
		}	

		if "`samp0'" != "" & "`s0'" != "" {
			di as err "specify samp0() or s0(), not both"
			exit 198
		}
		if "`samp0'" != "" {
			local s0samp "s0samp(`samp0')"
		}
		if "`s0'" != "" {
			tokenize `s0'
			if "`1'" == "" | "`2'" =="" {
				di as err "s0(`s0') invalid"
				exit 198
			}	
			local s10 "s10(`1')"
			local s20 "s20(`2')"
		}
		if "`parms'" != ""  & "`from'" != "" {
			di as err "from() cannot be specified with parms()"
			exit 198
		}
		if "`forecast'" != "" {
			local fcast "fcast(`forecast')"			
		}

		if "`from'" == "" {
			local from "init( .5 .5 .5 ) "
		}
		else {
			local from "init( `from' ) "
		}	


		if "`parms'" != "" {
			local am "a(`parms')"
		}
		if "`parms'" == "" {
			/* if parms are empty 
			 * then opt via ml assumed 
			 */ 
			local am "a(opt)"
		}

		if _caller() >= 11 {
			local vv : di "version " string(_caller()) ":"
		}
		if "`additive'" == "" {
			local func "_ts_hwsm"
		}
		else {
			local func "_ts_hwsa"
		}

		local periodm "period(`period')"

		if _caller() >= 11 {
			local vv : di "version " string(_caller()) ":"
		}
		qui gen `new'=. 
		`vv' ///
		capture noi `byp' `func' `new' `old', `am' 	/*
			*/ `s0samp' touse(`touse') `fcast' 	/*
			*/ `s10' `s20' `from' `log' `display'	/*
			*/ `sn0_vm' `sn0_0m' `snt_vm' `periodm'	/*
			*/ `altstarts' `normalize' `mlopts'	/*
			*/ `difficult'
		ret add	
		if _rc > 0 {
			local rc = _rc
			capture drop `nname'
			exit `rc'
		}
		local lbl : var label `nname'
		char `nname'[tssmoother] `lbl'
		ret local timevar `tvar'
		ret local panelvar `pvar'
		local myexp2 : subinstr local myexp2 "= " ""
		local myexp2 : subinstr local myexp2 "=" ""
		ret local exp "`myexp2'"

		if "`additive'" != "" {
			ret local method "shwinters, additive"
		}
		else {
			ret local method "shwinters, multiplicative"
		}
		if "`normalize'" != "" {
			ret local normalize "normalize"
		}	

		exit
	}

	/* if here smoother not found */

	capture drop `old'
	di as error "`opts' does not define a known smoother "
	exit 198

end

program define _ts_nlsmooth, rclass

/* syntax is _ts_nlsmooth type new old, SMoother(string) touse(byte varname)
*/
	gettoken vars left : 0 , parse(",") match(parns) 
	tokenize `vars'
	local type "`1'"
	local newvar "`2'"
	local oldvar "`3'"

	tempname N

	if "`type'" == "" {
		di as err "type not specified"
		exit 198
	}
	if "`oldvar'" == "" {
		di as err "old variable not specified"
		exit 198
	}
	if "`newvar'" == "" {
		di as err "new variable not specified"
		exit 198
	}

	
	local 0 "`left'"
	syntax , touse(varlist) SMoother(string)

	local smoother : subinstr local smoother " " "" 
	markout `touse' `oldvar'
	tsreport if `touse'
	if r(N_gaps) > 0 {
		di as err "cannot apply nl smoothers to variables with "/*
			*/ "missing values"
		exit 198
	}	

	qui count if `touse' ==1
	scalar `N' 	 = r(N)

	smooth `smoother' `oldvar' if `touse', gen(`newvar') /* 
		*/ type(`type') vlabel

	ret scalar N = `N'
end

program define cknew_old 
	syntax , [ma Wma nl Exponential Dexponential Hwinters Shwinters *]
	if "`ma'`nl'`exponential'`dexponential'`hwinters'`shwinters'" /*
		*/ != ""  {
		di as err "More than one smoother found"
		exit 198
	}	
end

program define cknew
	syntax , [double float byte int long *]
	if "`byte'`int'`long'" != ""  {
		di as err "type invalid"
		exit 198
	}	
	local n : word count `options'
	if `n' > 1 {
		di as err "smoother invalid"
		exit 198
	}	
end



program define myadd, sortp

	syntax varlist(min=1 max=1 numeric) [if] [in] , fcast(integer) [ /*
		*/ panelp(numlist integer min=1 max=1) ]

	if "`panelp'" != "" {
		local panelp "panel(`panelp')"
	}
	marksample touse

	tempvar mtvar outz out outvar
	qui tsset, noquery
	local tvar `r(timevar)'
	
	qui gen `mtvar' = -1*`tvar'

	if "`r(panelvar)'" != "" {
		local pvar "`r(panelvar)'"
		local pbyp "by `pvar': "
	}

	qui sort `pvar' `mtvar'

	qui gen `outz' = (`touse'==1)

	qui `pbyp' replace `outz' = sum(`outz')
	qui gen `out' = (`outz' == 0)
	qui `pbyp' gen `outvar' = sum(`out') 
	qui `pbyp' replace `outvar' = `outvar'[_N] 
	qui sum `outvar' 
	if r(min)<`fcast' {
		local add = `fcast' - r(min)
		tsappend , add(`add') `panelp'
	}	
	
end	

program define trs2space, sclass
	syntax , s0(string)

	local s2 = "`s0'"
	local len = length("`s2'")
	
	while `len' > 0 {
		local --len
		local space = substr("`s2'",-1,1)
		local s2 = substr("`s2'",1,`len')
		if "`space'" == "" {
			sret local string "`s2'"
			exit
		}
	}

	sret local string "`s0'"
	
end	

exit 
