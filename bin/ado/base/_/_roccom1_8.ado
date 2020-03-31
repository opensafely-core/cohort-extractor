*! version 7.2.15  29jan2015
program define _roccom1_8, rclass    /* Independent (uncorrelated) ROC curves */
	version 6, missing

	local vv : display "version " string(_caller()) ", missing: "

	syntax varlist(numeric min=2 max=2)		///
		[if] [in]				///
		[fweight] [,				///
		BINormal				///
		Level(integer $S_level)			///
		Graph					///
		SEParate				///
		TEST(string)				///
		noREFline				///
		SUMmary					///
		*					///
	]

        if "`graph'"=="" {
		syntax varlist [if] [in] [fweight] [, /*
		*/ by(passthru) TEST(string) Level(integer $S_level) /*
		*/ Graph BINormal SUMmary ]
		_get_gropts , graphopts(`by') grbyable
		local by `s(varlist)'
		if 0`:word count `by'' != 1 {
			local 0 , by(`by')
			syntax , by(varname)
			error 198		// should not get here
		}
		local options `"`s(graphopts)'"'
        }
	else {
		_get_gropts , graphopts(`options') grbyable	///
			getallowed(rlopts plot)
		local by `s(varlist)'
		if 0`:word count `by'' != 1 {
			local 0 , by(`by')
			syntax , by(varname)
			error 198		// should not get here
		}
		local byopts `"`s(byopts)'"'
		local options `"`s(graphopts)'"'
		local rlopts `"`s(rlopts)'"'
		local plot `"`s(plot)'"'
		_check4gropts rlopts, opt(`rlopts')
		if `"`plot'"' != "" {
			di in red "option plot() not allowed"
			exit 198
		}
	
		if "`separate'"=="" & `"`byopts'"' != "" {
			local 0 , `byopts'
			syntax [, ZZ_OPTION_TO_GET_ERROR_MESSAGE ]
			error 198	// should not get here
		}
	}

	marksample touse
	tempvar cut p spec sens ntouse
	tokenize `varlist'
	local D = `"`1'"'
	local C = `"`2'"'

	cap assert `D'==0 | `D'==1 if `touse'
	if _rc~=0 {
		noi di in red "true status variable `D' must be 0 or 1"
		exit 198
 	}
	qui summ `D' if `touse', meanonly
        if r(min) == r(max) {
		di in red "Outcome does not vary"
		exit 198
        }
	if "`table'"~="" {
		tabulate `D' `C' [`weight'`exp'] if `touse'
	}
	if `level'<10 | `level'>99 {
		di in red "level() invalid"
		exit 198
	}

	if "`by'"=="" {
		di in red "must specify by() option"
                exit 198
	}
	_nostrl error : `by'
	local Gc "`by'"
	local bylbl : var label `by'
	if `"`bylbl'"' == "" {
		local bylbl `by'
	}
	markout `touse' `Gc', strok
	local type: type `Gc'
	tempvar bygrp
	qui egen `bygrp'=group(`Gc') if `touse'
	qui sum `bygrp' if `touse', meanonly
	local bymax = r(max)
	tempfile gphfile
	local sensgr=" "
	if "`test'"~= "" {
	capture di `test'[1,1]
		if _rc~=0 {
			noi di in red "matrix `test' not found"
			exit 198
		}
		local rows = colsof(`test')
		capture assert `rows'==`bymax'
		if _rc~=0 {
			noi di in red "matrix `test' not of correct dimensions"
			exit 198
		}
	}
	/* BEGIN-create freq weighted summary data */
	 if `"`weight'"' =="" {
		tempvar wv
		qui gen int `wv' = 1 if `touse'
		local weight="fweight"
	}
	else {
		tempvar wv
		qui gen double `wv' `exp'
	}
	tempvar newwt
	sort `touse' `bygrp' `D' `C'
	qui by `touse' `bygrp' `D' `C': gen `newwt'=sum(`wv') if `touse'
	qui by `touse' `bygrp' `D' `C': replace `newwt'=. if _n~=_N
	qui replace `newwt'=. if `newwt'==0
	qui replace `touse'=0 if `newwt'>=.
	qui replace `wv'=`newwt'
	local wt=`"[fweight=`wv']"'
	tempvar MN
	sort `touse' `bygrp' `D' `C'
	qui by `touse' `bygrp' `D' : gen long `MN' = sum(`wv')
	qui by `touse' `bygrp' `D' : replace `MN' = `MN'[_N]
	qui replace `MN'=. if `touse'==0
	drop `newwt'
	/* END -create freq weighted summary data */
	local  i 1

	tempvar nbygrp N area se lb ub x
	while `i' <= `bymax' {
		preserve
		qui keep if `touse' & `bygrp'==`i'
		qui keep `D' `C' `wv' `by' `bygrp'
		qui logistic `D' `C' `wt', asis
		tempvar sens spec
		qui `vv' lsens, nograph gensens(`sens') genspec(`spec')
		if _b[`C']<0 {
			tempvar mark
			qui gen int `mark'=1 if `sens'==1 & `spec'==1
			qui replace `mark'=1 if `sens'==0 & `spec'==0
			qui replace `sens' = 1 -`sens'  if `mark'!=1
			qui replace `spec' = 1 -`spec'  if `mark'!=1
		}
		qui `vv' roctab `D' `C' `wt' , level(`level') 
		qui gen `N'=r(N)
		qui gen `area'=r(area)
	 	qui gen `se'=r(se)     
		qui gen `lb'=r(lb)    
		qui gen `ub'=r(ub)   
		local group=`Gc'
		if bsubstr("`type'",1,3)=="str" {
		 	qui gen `type' `nbygrp'= "`group'"
		}
		else {
			qui gen `type' `nbygrp'= `group'
		}
		rename `sens' sens`i'
		local troc="0"+string(round(`area',0.0001))
		local aroc=`"`group' ROC area: `troc'"' 
		label var sens`i' `"`aroc'"'
		qui gen double `x' = 1-`spec'
		local sensgr="`sensgr' sens`i'"
		local symbol `"`symbol' ."'
		qui keep `nbygrp' `x' sens`i' `N' `area' /*
		*/ `se' `lb' `ub' `D' `C' `wv' `by'
		qui gen int keep=1
		if `"`binormal'"'~= "" {
			di in gr "Fitting binormal model for: " /*
			*/ in ye`"`by'"' "==" in ye `by'[1]
			qui `vv' rocfit `D' `C' `wt' 
			local a=_b[intercep]
			local b=_b[slope]
			qui replace `area' = e(area)
			qui replace `se' = e(se_area)
			local alpha=invnorm(.5+`level'/200)
			qui replace `lb' = `area' - `alpha'*`se'
			qui replace `ub' = `area' + `alpha'*`se'
			qui replace `N' = e(N)
			local Nobs=_N
			local nobs=`Nobs'+300
			qui set obs `nobs'
			tempvar k zfpf 
			qui gen int `k'=1 if _n>`Nobs'
			qui replace `nbygrp'= `nbygrp'[_n-1] if `nbygrp'>=.
			qui replace `x'=0 if `k'==1 & _n==`Nobs'+1
			qui replace `x'=`x'[_n-1]+1/300 if `x'>=. & `k'==1
			qui gen double `zfpf'= invnorm(`x') if `k'==1
			qui gen double yhat`i'=`b'*`zfpf' + `a'
			qui replace yhat`i'=normprob(yhat`i')
			qui replace yhat`i'=0 if _n==_N
        		qui replace `x'=0 if _n==_N
			qui replace sens`i'=0 if _n==_N
			qui replace yhat`i'=1 if _n==_N-1
			qui replace `x'=1 if _n==_N-1
			qui replace `x'=1 if sens`i'==1
			qui replace sens`i'=1 if `x'==1
			local troc="0"+string(round(`area',0.0001))
			local aroc=`"`group' ROC area: `troc'"' 
			label var sens`i' `"`aroc'"'
			local sensgr="`sensgr' yhat`i'"
			local symbol `"`symbol' none"'
			/* save matrices for test */
			tempname B`i' V`i'
			qui mat B`i'=e(b)
			qui mat V`i'=e(V)
		}

		sum `wv' if `D'==0, meanonly
		local nn = r(sum)
		sum `wv' if `D'==1, meanonly
		local na = r(sum)
		qui drop `D' `C' `wv' `k' `zfpf' `by'
		if `i'~=1 {
			append using `"`gphfile'"'
		}
		qui save `"`gphfile'"', replace
		restore
		local i=`i'+1
	}
	preserve
	qui use `"`gphfile'"', clear
	if `"`graph'"' ~= `""' { /* set graph defaults */
		format `sensgr' `x' %4.2f
		label var `x' `"1 - Specificity"'
		sort `x' `sensgr'
		if `"`separate'"'~="" {
			local byopt="by(`nbygrp', `byopts')"
			label var `nbygrp' "`bylbl'"
			sort `nbygrp' `x' `sensgr'
		}
		if `"`refline'"'=="" {
			local conopt="c(l`connect')"
		}
		else {
			local conopt="c(.`connect')"
		}
		noi version 8: graph twoway		///
		(connected `sensgr' `x',		///
			msymbol(`symbol')		/// 
			ytitle("Sensitivity")		///
			xtitle("1-Specificity")		///
			ylabels(0(.25)1, grid)		///
			xlabels(0(.25)1, grid)		///
			`byopt'				///
			`options'			///
		)					///
		(function y=x,				///
			range(`x')			///
			n(2)				///
			clstyle(refline)		///
			yvarlabel("Reference")		///
			`rlopts'			///
		)					///
		// blank
	}
	if "`graph'"=="" | "`summary'" ~="" {
		if `"`binormal'"'~="" {
			qui keep if keep==1
		}
		sort `nbygrp'
		qui by `nbygrp':keep if _n==1
        	qui gen double p=round(`area'*`N', 1)

		if `"`binormal'"'~= "" {
        		di in gr _n _col(31) "ROC" 
		}
		else {
        		di in smcl in gr _n _col(31) /*
			*/ "ROC"  _col(54) "{c -}Asymptotic Normal{hline 2}"
		}
        	di in smcl in gr /*
		*/ "`Gc'" _col(17) "   Obs       Area     Std. Err." /*
        	*/"      [`level'% Conf. Interval]" _n  "{hline 73}"
		local i 1
		while `i' <= `bymax' {
        			di in ye `nbygrp'[`i']  _col(15) in yel %8.0f `N'[`i'] /*
			*/  _col(26) %8.4f `area'[`i']  _col(39) %8.4f `se'[`i'] /*
			*/  _col(54) %8.5f `lb'[`i'] _col(66) %8.5f `ub'[`i']
			local i=`i'+1
		}	
		di in smcl in gr "{hline 73}"
		if "`test'"=="" {
			di in gr "Ho: " _c
			tempname test
			mat `test'=J(comb(`bymax',2), `bymax', 0)
			local i 1       /* row */
			local j 1      /* col */
			local k 1
			local mymax=`bymax'
			while `i' <= comb(`bymax',2) {
        	                if `j'<`mymax' {
					mat `test'[`i',`k'] = 1
					mat `test'[`i',`j'+1] = -1
					if `i'<`mymax' {
						di in gr /*
					   */ "area(" in ye `nbygrp'[`i'] in gr ") = " _c
					}
					local i=`i'+1
					local j=`j'+1
				}
				else {
					local j=`k'+1
					local k=`k'+1
				}
			}
			di in gr  "area(" in ye `nbygrp'[`bymax'] in gr ")
		}
		else {
			di in gr /*
			*/ "Ho: Comparison as defined by contrast matrix: " /*
			*/ in ye `"`test'"'
		}
		MYTEs1 `bymax' `D' `nn' `na' `area' `se'  `"`test'"'
		return local p = `r(p)'
		return local df = `r(df)'
		return local chi2= `r(chi2)'
		return local groups = `bymax'
		tempname V
		matrix `V' = r(V) 
		return  matrix V `V'
	}
end
prog def MYTEs1, rclass
	gettoken bymax 0:0
	gettoken D 0:0
	gettoken nn 0:0
	gettoken na 0:0
	gettoken area 0:0
	gettoken se 0:0
	gettoken test 0:0
	tempname T 
	mat `T'=J(1, `bymax',1)
	local i 1
	while `i'<=`bymax' {
		mat `T'[1,`i']=`area'[`i']
		local i=`i'+ 1
	}
	tempname S10 S01 S
	mat `S10'=J(`bymax',`bymax',0)
	mat `S01'=J(`bymax',`bymax',0)
	mat `S'=J(`bymax',`bymax',0)
	local r 1
	while `r'<=`bymax' {
		mat `S'[`r',`r'] = (`se'[`r'])^2
		local r=`r'+1
	}
	tempname Cont L V R x2 iV
	mat `L'=`test'
	mat `Cont'=`T'*`L''
	mat `V'=`L'*`S'*`L''
	mat `iV'=syminv(`V')
	local df=colsof(`V')-diag0cnt(`iV')
	mat `R'=`Cont'*`iV'*`Cont''
	scalar `x2'=`R'[1,1]
	di in gr "    chi2(" in ye `df' in gr ") = " in ye %8.2f `x2' /*
	*/ in gr "       Prob>chi2 = " in ye %8.4f chiprob(`df',`x2')
	return local chi2=`x2'
	return local df=`df'
	return local p = chiprob(`df',`x2')
	return matrix V `S'
end
prog define BITest, sclass
	gettoken bymax 0:0
	gettoken D 0:0
	gettoken nn 0:0
	gettoken na 0:0
	gettoken test 0:0
	tempname  sS B
	mat `sS' = J(`bymax',`bymax',0)
	mat `B' = J(1,`bymax',0)
	local i 1
	while `i'<=`bymax' {
		tempname B`i' S`i' sS`i'
		mat `B`i''= B`i'[1, 1..`bymax']
		mat `S`i''= V`i'[1..`bymax', 1..`bymax']
		mat `sS'= `sS' + syminv(`S`i'')
		mat `B' = `B' + `B`i''*syminv(`S`i'')
		local i=`i'+1
	}
	tempname AoBo 
	mat `AoBo' = `B'* syminv(`sS')
	tempname X2 		
	mat `X2' = J(1,1,0)
	local i 1
	while `i'<=`bymax' {
		tempname X2`i'
		mat `X2`i''= (`B`i''-`AoBo')*syminv(`S`i'')*(`B`i'''-`AoBo'')
            mat  `X2'= `X2' + `X2`i''
      	local i=`i'+1
      }
	tempname x2
	scalar `x2'=`X2'[1,1]
	local df=2*(`bymax'-1)
	di in gr "    chi2(" in ye `df' in gr ") = " in ye %8.2f `x2' /*
	*/ in gr "       Prob>chi2 = " in ye %8.4f chiprob(`df',`x2')

	sreturn local chi2=`x2'
	sreturn local df=`df'
	sreturn local p = chiprob(`df',`x2')

end
