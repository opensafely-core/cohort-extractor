*! version 7.2.14  09feb2015
program define roccomp_8, rclass
	version 6, missing
	if _caller() < 8 {
		roccomp_7 `0'
		return add
		exit
	}

	local vv : display "version " string(_caller()) ": "

	syntax varlist(numeric min=2) [if] [in] [fweight] [, Graph SUMmary * ]

	if "`if'"~="" {
		local ifopt = "if `if'"	
	}
	if "`in'"~="" {
		local ifopt = "in `in'"	
	}
	if "`weight'"~="" {
		local wtopt = "[fweight `exp']"	
	}
	local vars:  word count `varlist'
	if `vars'==2 {
	       `vv' _roccom1 `varlist' `if' `in' `wtopt', /*
		*/ `graph' `summary' `options' /* ind */
	}
	else {
	       `vv' ROCcomp `varlist' `if' `in' `wtopt', /*
		*/ `graph' `summary'  `options' /* corr */
	}
	if"`graph'"=="" | "`summary'"~=""  {
		return scalar p = `r(p)'
		return scalar df = `r(df)'
		return scalar chi2 = `r(chi2)'
		return scalar N_g = `r(groups)'
		tempname V
		mat `V'=r(V)
		return matrix V `V'
	}
end

program define ROCcomp, sclass         /* Dependent (correlated) ROC curves */
	version 6
	local vv : display "version " string(_caller()) ": "

	syntax varlist(numeric min=3)		///
		[if] [in] [fweight]		///
		[,				///
		BINormal			///
		Level(integer $S_level)		///
		Graph				///
		SEParate			///
		TEST(string)			///
		noREFline			///
		SUMmary				///
		*				///
	]


	if "`graph'"=="" {
		syntax varlist(numeric min=3)		///
			[if] [in] [fweight]		///
			[,				///
			BINormal			///
			by(passthru)			///
			Level(integer $S_level)		///
			Graph				///
			TEST(string)			///
			SUMmary				///
		]
	}
	else {
		_get_gropts , graphopts(`options')	///
			grbyable			///
			nobycheck			///
			getallowed(rlopts plot)
		local by `"`s(varlist)'"'	// causes error if not empty
		local byopts `"`s(byopts)'"'	// used with separate opt
		local options `"`s(graphopts)'"'
		local rlopts `"`s(rlopts)'"'
		local plot `"`s(plot)'"'
		_check4gropts rlopts, opt(`rlopts')
		if `"`plot'"' != "" {
			di in red "option plot() not allowed"
			exit 198
		}
	}

	if `level'<10 | `level'>99 {
		di in red "level() invalid"
		exit 198
	}
	if "`by'"~="" {
		noi di in red "by() option not allowed with correlated samples"
		noi di in red "perhaps you meant to use separate"
		exit 191
	}
	marksample touse
	tempvar  spec sens 
	local bymax: word count `varlist'
	local bymax= `bymax' - 1
	gettoken D 0:0 
	unab D : `D'
	tokenize `varlist'
	local i 1
	local j 2
	while  `j'<=`bymax'+1 {
		local C`i'="``j''"
		local i=`i'+1
		local j=`j'+1

	}
	local grplist="`varlist'"

	cap assert `D'==0 | `D'==1 if `touse'
	if _rc~=0 {
		noi di in red "true status variable `D' must be 0 or 1"
		exit 198
 	}
	if "`test'"~="" {
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
	
	qui summ `D' if `touse', meanonly
	if r(min) == r(max) {
		di in red "Outcome does not vary"
		exit 198
	}
	tempfile gphfile
	tempfile corfile
	local sensgr=" "
	tempvar id order
	qui gen `c(obs_t)' `id'=_n
	qui compress `id'
	if `"`weight'"' =="" {
		tempvar wv
		qui gen int `wv' = 1 if `touse'
		local weight="fweight"
	}
	else {
		tempvar wv
		qui gen double `wv' `exp'
	}
	local wt=`"[fweight=`wv']"'
	tempvar bygrp x N area se lb ub
	qui gen str12 `bygrp'= ""
	label var `bygrp' "group"
	qui gen double `x' = .
	qui gen long `N'=.
	qui gen double `area'=.
 	qui gen double `se'=.
	qui gen double `lb'=.
	qui gen double `ub'=.
	local  i 1
	while `i' <= `bymax' {
		preserve
		qui keep if `touse' 
		tempvar C
		gen double `C'=`C`i''
		qui compress `C'	
		tokenize `grplist'
		qui keep `D' `C' `wv'  `bygrp' `C`i'' /*
		*/ `id' `x' `N' `area' `se' `lb' `ub'
		qui logistic `D' `C' `wt', asis
		tempvar sens spec
		qui `vv' lsens, nograph gensens(`sens') genspec(`spec')
		if _b[`C']<0  {
			tempvar mark
			qui gen int `mark'=1 if `sens'==1 & `spec'==1
			qui replace `mark'=1 if `sens'==0 & `spec'==0
			qui replace `sens' = 1 -`sens'  if `mark'!=1
			qui replace `spec' = 1 -`spec'  if `mark'!=1
		}
		qui `vv' roctab `D' `C' `wt' , level(`level') 
		qui replace `N'=r(N)
		qui replace `area'=r(area)
	 	qui replace `se'=r(se)     
		qui replace `lb'=r(lb)    
		qui replace `ub'=r(ub)   
		local group="`C`i''"
		qui replace `bygrp'= `"`group'"'
		gen `order'=`i'
		rename `sens' sens`i'
		local troc="0"+string(round(`area',0.0001))
		local aroc=`"`group' ROC area: `troc'"' 
		label var sens`i' `"`aroc'"'
		qui replace `x' = 1-`spec'
		local sensgr="`sensgr' sens`i'"
		local symbol `"`symbol' ."'
		qui keep `bygrp' `x' sens`i' `N' `area' `se' /*
		*/ `lb' `ub' `D' `C' `wv' `id' `order'
		qui gen int keep=1
		if `"`binormal'"'~= "" {
			di in gr "Fitting binormal model for: " in ye "`group'"
			qui inspect `C' 
			if r(N_unique)>20 & "`continuous'"=="" {
                        di in gr in smcl "{p 3 3}note: " /*
                        */ "variable " in ye abbrev("`group'",12) /*
                        */ in gr " has over 20 unique values; rocfit's " /*
                        */ "continuous(.) option assumed {p_end}"
				qui `vv' rocfit `D' `C' `wt' ,cont(.)
                	}
			else {
				qui `vv' rocfit `D' `C' `wt' 
			}

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
			qui replace `bygrp'= `bygrp'[_n-1] if `bygrp'==""
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
		}

		sum `wv' if `D'==0, meanonly
		local nn = r(sum)
		sum `wv' if `D'==1, meanonly
		local na = r(sum)
		local mgrp= `bygrp'
 
		if `i'~=1 {
			qui append using `"`gphfile'"'
		}
		qui save `"`gphfile'"', replace

		qui keep if `bygrp'==`"`mgrp'"'
		qui keep `id' `D' `C'  `area' `wv' `order'
		tempvar v01 v10
		qui gen double `v01'=.
		qui gen double `v10'=.
		COMparea `D' `C' `wv' `na' `nn' `area' `v01' `v10'
		rename `v01' v01`i'
		rename `v10' v10`i'
		rename `wv' wv
		qui keep `D' `id' v01`i'  v10`i' wv `order'
		sort `id'
		if `i'~=1 {
			qui merge `id'  using `"`corfile'"'
			qui drop _merge
		}
		sort `id'
		qui save `"`corfile'"', replace
		restore
		local i=`i'+1
	}
	preserve
	qui use `"`gphfile'"', clear
	if `"`graph'"' ~= `""' { /* set graph7 defaults */
		format `sensgr' `x' %4.2f
		label var `x' `"1 - Specificity"'
		sort `x' `sensgr'
		if `"`separate'"'~="" {
			local byopt `"by(`bygrp', `byopts')"'
			sort `bygrp' `x' `sensgr'
		}
		if `"`refline'"'=="" {
			local rlgraph			///
			(function y=x,			///
				range(`x')		///
				n(2)			///
				clstyle(refline)	///
				yvarlabel("Reference")	///
				`rlopts'		/// graph opts
			)
		}

		noi version 8: graph twoway		///
		(connected `sensgr' `x',		///
			sort				///
			msymbol(`symbol')		/// 
			ytitle("Sensitivity")		///
			xtitle("1-Specificity")		///
			ylabels(0(.25)1, pgmgrid)	///
			xlabels(0(.25)1, pgmgrid)	///
			legend(order(`lorder'))		///
			`byopt'				///
			`options'			/// graph opts
		)					///
		`rlgraph'				///
		// blank
	} 
	if `"`binormal'"'~="" {
		qui keep if keep==1
	}
	qui keep if `bygrp'~=""
	sort `bygrp'
	if "`graph'"=="" | "`summary'" ~=""  {
		qui by `bygrp':keep if _n==1
        	qui gen double p=round(`area'*`N', 1)

		sort `order'
		if `"`binormal'"'~= "" {
        		di in gr _n _col(31) "ROC" 
		}
		else  {
        		di in smcl in gr _n _col(31) /*
			*/ "ROC"  _col(54) "{c -}Asymptotic Normal{hline 2}"
		}
        	di in smcl in gr "`Gc'" _col(17) /*
		*/ "   Obs       Area     Std. Err." /*
        	*/"      [`level'% Conf. Interval]" _n  "{hline 73}"

		qui replace `bygrp'=abbrev(`bygrp',12)
		local i 1
		while `i' <= `bymax' {
        		di in ye `bygrp'[`i'] _col(15) in yel %8.0f `N'[`i'] /*
			*/ _col(26) %8.4f `area'[`i'] _col(39) %8.4f `se'[`i']/*
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
			*/ "area(" in ye `bygrp'[`i'] in gr ") = " _c
					}

					local i=`i'+1
					local j=`j'+1
				}
				else {
					local j=`k'+1
					local k=`k'+1
				}
	        	} 
			di in gr  "area(" in ye `bygrp'[`bymax'] in gr ")
		}
		else {
			di in gr /*
			*/ "Ho: Comparison as defined by contrast matrix: " /*
			*/ in ye `"`test'"'
        	}
        	MYTEst `bymax' `D' `nn' `na' `area' `"`test'"' `"`corfile'"' 
	}
end

prog def COMparea, sclass
	args D C wv na nn area v01 v10
	tempvar Phi
	qui gen double `Phi'=.
	sort `D' `C'
	local i=1
	while `i'<=_N {
		tempvar phi
		local x=`C'[`i'] 
		if `D'[`i']==1  {
			qui gen float `phi'=`wv' if `C'<`x' & `D'==0
			qui replace   `phi'= 0.5*`wv'  if `C'==`x' & `D'==0
			qui replace   `phi'= 0  if `C'>`x' & `D'==0 
			qui sum `phi', meanonly
			qui replace `Phi'=r(sum) if _n==`i'
		}
		else {
			qui gen float `phi'=`wv' if `C'>`x' & `D'==1
                        qui replace   `phi'= 0.5*`wv'  if `C'==`x' & `D'==1
                        qui replace   `phi'= 0  if `C'<`x' & `D'==1
			qui sum `phi', meanonly
			qui replace `Phi'=r(sum) if _n==`i'
		}
		qui drop `phi'
	local i=`i'+1 
	}
	qui replace `v10'=`Phi'/(`nn') if `D'==1
	qui replace `v01'=`Phi'/(`na') if `D'==0
	qui drop `Phi'
	qui replace `v01'=(`v01'-`area')
	qui replace `v10'=(`v10'-`area')
	
end

prog def MYTEst, rclass
	gettoken bymax 0:0
	gettoken D 0:0
	gettoken nn 0:0
	gettoken na 0:0
	gettoken area 0:0
	gettoken test 0:0
	local corfile `0'
	tempname T 
	mat `T'=J(1, `bymax',1)
	local i 1
	while `i'<=`bymax' {
		mat `T'[1,`i']=`area'[`i']
		local i=`i'+ 1
	}
	qui use `"`corfile'"', clear
	tempname S10 S01 S
	mat `S10'=J(`bymax',`bymax',1)
	mat `S01'=J(`bymax',`bymax',1)
	local r 1
	while `r'<=`bymax' {
		local c 1
		while `c'<=`bymax' {
			tempvar pd01 pd10 sd01 sd10
			qui gen double `pd01'=v01`r'*v01`c'
			qui gen double `pd10'=v10`r'*v10`c'
			qui egen double `sd01'=sum(`pd01'*wv)
			qui egen double `sd10'=sum(`pd10'*wv)
			qui replace `sd10'=`sd10'/(`na'-1)
			qui replace `sd01'=`sd01'/(`nn'-1)
			local d10=`sd10'
			local d01=`sd01'
			mat `S10'[`r',`c'] = `d10'
			mat `S01'[`r',`c'] = `d01'
			local c=`c'+1
		}
		local r=`r'+1
	}
	mat `S'=(1/`na')*`S10' + (1/`nn')*`S01'
	tempname Cont L V R x2 iV
	mat `L'=`test'
	mat `Cont'=`L'*`T''
	mat `V'=`L'*`S'*`L''
	mat `iV'=syminv(`V')
	local df=colsof(`V')-diag0cnt(`iV')
	mat `R'=`Cont''*`iV'*`Cont'
	scalar `x2'=`R'[1,1]
	di in gr "    chi2(" in ye `df' in gr ") = " in ye %8.2f `x2' /*
	*/ in gr "       Prob>chi2 = " in ye %8.4f chiprob(`df',`x2')
	return local groups=`bymax'
	return local chi2=`x2'
	return local df=`df'
	return local p=chiprob(`df',`x2')
	return matrix V `S'
end
