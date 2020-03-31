*! version 7.1.11  18feb2015
program define roccomp_7, rclass
	version 6, missing
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
	       _roccom1 `varlist' `if' `in' `wtopt', /*
		*/ `graph' `summary' `options' /* ind */
	}
	else {
	       ROCcomp `varlist' `if' `in' `wtopt', /*
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
	syntax varlist(numeric min=3) [if] [in] [fweight] /*
	*/ [, BINormal Connect(string)  Level(cilevel) /*
	*/ Symbol(string) Bands(string) XLAbel(string) YLAbel(string) /*
	*/ XLIne(string) YLIne(string) Graph SEParate TEST(string) /* 
	*/ noREFline Pen(string) by(varname) SUMmary L2title(string) /*
	*/ KEY1(string) KEY2(string) KEY3(string) KEY4(string) * ]
	if "`graph'"=="" {
		syntax varlist [if] [in] [fweight] /*
       		*/ [, BINormal Level(cilevel) /*
	        */ Graph TEST(string) SUMmary ]
	}
	if "`by'"~="" {
		noi di in red "by() option not allowed with correlated samples"
		noi di in red "perhaps you meant to use separate"
		exit 198
	}
	marksample touse
	tempvar  w spec sens 
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
			/* remove blank spaces */
	if "`symbol'"~="" {
		local symbol=subinstr("`symbol'"," ","",.)
	}
	if "`connect'"~="" {
		local connect=subinstr("`connect'"," ","",.)
	}
	if "`pen'"~="" {
		local pen=subinstr("`pen'"," ","",.)
	}
	local i 1
	local haskey 0
	while `i'<=4 {
		if `"`key`i''"'~="" {
			local keylist `"`keylist' key`i'(`"`key`i''"')"'
			local haskey 1
		}
		local i=`i'+1
	}

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
		qui lsens, nograph gensens(`sens') genspec(`spec')
		if _b[`C']<0  {
			tempvar mark
			qui gen int `mark'=1 if `sens'==1 & `spec'==1
			qui replace `mark'=1 if `sens'==0 & `spec'==0
			qui replace `sens' = 1 -`sens'  if `mark'!=1
			qui replace `spec' = 1 -`spec'  if `mark'!=1
		}
		qui roctab `D' `C' `wt' , level(`level') 
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
				qui rocfit `D' `C' `wt' ,cont(.)
                	}
			else {
				qui rocfit `D' `C' `wt' 
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
		}

					/* set up keys, no more than 4 */
 		if `"`graph'"'~="" & `i'<=4 & !`haskey' {
			if "`symbol'"=="" {
				local sk="s(o)"
			}
			else {
				local msymbol=bsubstr("`symbol'",`i',1)
				local sk=`"s(`msymbol')"'
			}
			if "`connect'"=="" {
				local ck="c(l)"
			}
			else {
				local mconn=bsubstr("`connect'",`i',1)
				local ck=`"c(`mconn')"'
			}
			if "`pen'"=="" {
				local j=`i'+2
				local sp="p(`j')"
			}
			else {
				local mpen=bsubstr("`pen'",`i',1)
				local sp=`"p(`mpen')"'
			}
			local key `"key`i'(`sk' `ck' `sp' `"`aroc'"')"'
			local keylist `"`keylist' `key'"'
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
	if `"`graph'"' ~= `""' { /* set gr7 defaults */
		qui tab  `bygrp'
		local max=r(r)
		if `"`symbol'"' == `""' { 
			local i 1
			while `i'<=`max' {
				local symbol `"`symbol'o"' 
				if `"`binormal'"'~="" {
					local symbol `"`symbol'i"' 
				}
				local i=`i'+1
			}
		}
		else if `"`binormal'"'~="" {
			* local symbol=subinstr("`symbol'"," ","",.)
			local i 1
			while `i'<=`max' {
				local msymbol=bsubstr("`symbol'",`i',1)
				local nsymbol `"`nsymbol' `msymbol' i"' 
				local i=`i'+1
				mac shift
			}
			local symbol="`nsymbol'"
		}
			
		if `"`connect'"' == `""' { 
			local i 1
			while `i'<=`max' {
				if `"`binormal'"'~="" {
					local connect `"`connect'.l"' 
				}
				else local connect `"`connect'l"'
				local i=`i'+1
			}
		}
		else if `"`binormal'"'~="" {
			local i 1
			while `i'<=`max' {
				local mconn=bsubstr("`connect'",`i',1)
				local nconn `"`nconn'.`mconn'"' 
				local i=`i'+1
				mac shift
			}
			local connect="`nconn'"
		}

		if `"`pen'"' == `""' {
			local i 1
			while `i'<=`max' {
				local j=`i'+2
				if `"`binormal'"'~="" { 
					local pen=`"`pen'`j'`j'"'
				}
				else local pen=`"`pen'`j'"'
				local i=`i'+1
			}
		}
		else if `"`binormal'"'~="" {
			local i 1
			while `i'<=`max' {
				local mpen=bsubstr("`pen'",`i',1)
				local npen=`"`npen'`mpen'`mpen'"'
				local i=`i'+1
			}
			local pen="`npen'"
		}
		local penopt="pen(`pen'2)"

		if `"`bands'"'  == `""' { local bands  `"10"' }
		if `"`xlabel'"' == `""' { local xlabel `"0,.25,.5,.75,1"' }
		if `"`ylabel'"' == `""' { local ylabel `"0,.25,.5,.75,1"' }
		if `"`xline'"'  == `""' { local xline  `".25,.5,.75"' }
		if `"`yline'"'  == `""' { local yline  `".25,.5,.75"' }
		if `"`l2title'"' == `""' { local l2title  `"Sensitivity"' }

		qui gen `w' = cond(`x'==0, 0, cond(`x'==1, 1, .)) 
		label var `w' " "
		format `sensgr' `w' `x' %4.2f
		label var `x' `"1 - Specificity"'
		sort `x' `sensgr'
		if `"`separate'"'~="" {
			local byopt="by(`bygrp')"
			sort `bygrp' `x' `sensgr'
		}
		if `"`refline'"'=="" {
			local conopt="c(`connect'l)"
		}
		else {
			local conopt="c(`connect'.)"
		}

		* noi di "`keylist'"
		noi gr7 `sensgr' `w' `x', `conopt' s(`symbol'i)  /*
		*/  border bands(`bands') `penopt' `keylist' /*
		*/  xlabel(`xlabel') ylabel(`ylabel') xline(`xline') /*
		*/  yline(`yline') `options' l2title(`l2title') `byopt'
		drop `w'
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
		local cil `=string(`level')'
		local cil `=length("`cil'")'
		if `cil' == 2 {
			local spaces "      "
		}
		else if `cil' == 4 {
			local spaces "    "
		}
		else {
			local spaces "   "
		}
        	di in smcl in gr "`Gc'" _col(17) /*
		*/ "   Obs       Area     Std. Err." /*
*/ `"`spaces'[`=strsubdp("`level'")'% Conf. Interval]"' _n  "{hline 73}"

		local i 1
		while `i' <= `bymax' {
			qui replace `bygrp'=abbrev(`bygrp',12)
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

// The following was consumed from _roccom1.ado; this is the only file that
// will call this subroutine under version control.

// Date: 07oct2002
// *! version 7.0.11  11dec2001

program define _roccom1, rclass	    /* Independent (uncorrelated) ROC curves */
	version 6
	syntax varlist(numeric min=2 max=2) [if] [in] [ fweight], by(varname) /*
	*/ [ Connect(string) TEST(string) Level(cilevel) /*
	*/ Symbol(string) Bands(string) XLAbel(string) YLAbel(string) /*
	*/ XLIne(string) YLIne(string) Graph SEParate BINormal noREFline /*
	*/ saving(string) SUMmary L2title(string) PEN(string) /*
	*/ KEY1(string) KEY2(string) KEY3(string) KEY4(string) * ]

        if "`graph'"=="" {
		syntax varlist(numeric min=2 max=2) [if] [in] [ fweight], /*
		*/ by(varname) [ TEST(string) Level(cilevel) /*
		*/ Graph BINormal SUMmary ]
        }
	marksample touse
	tempvar cut p w spec sens ntouse
	tokenize `varlist'
	local D = `"`1'"'
	local C = `"`2'"'
	tokenize `options'
			/* remove blank spaces */
	if "`symbol'"~="" {
		local symbol=subinstr("`symbol'"," ","",.)
	}
	if "`connect'"~="" {
		local connect=subinstr("`connect'"," ","",.)
	}
	if "`pen'"~="" {
		local pen=subinstr("`pen'"," ","",.)
	} 
	local i 1
	local haskey 0
	while `i'<=4 {
		if `"`key`i''"'~="" {
			local keylist `"`keylist' key`i'(`"`key`i''"')"'
			local haskey 1
		}
		local i=`i'+1
	}

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

	if "`by'"=="" {
		di in red "must specify by() option"
                exit 198
	}
	_nostrl error : `by'
	local Gc "`by'"
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
	qui replace `touse'=0 if `newwt'==.
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
		qui lsens, nograph gensens(`sens') genspec(`spec')
		if _b[`C']<0 {
			tempvar mark
			qui gen int `mark'=1 if `sens'==1 & `spec'==1
			qui replace `mark'=1 if `sens'==0 & `spec'==0
			qui replace `sens' = 1 -`sens'  if `mark'!=1
			qui replace `spec' = 1 -`spec'  if `mark'!=1
		}
		qui roctab `D' `C' `wt' , level(`level') 
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
		qui keep `nbygrp' `x' sens`i' `N' `area' /*
		*/ `se' `lb' `ub' `D' `C' `wv' `by'
		qui gen int keep=1
		if `"`binormal'"'~= "" {
			di in gr "Fitting binormal model for: " /*
			*/ in ye`"`by'"' "==" in ye `by'[1]
			qui rocfit `D' `C' `wt' 
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
			qui replace `nbygrp'= `nbygrp'[_n-1] if `nbygrp'==.
			qui replace `x'=0 if `k'==1 & _n==`Nobs'+1
			qui replace `x'=`x'[_n-1]+1/300 if `x'==. & `k'==1
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
			/* save matrices for test */
			tempname B`i' V`i'
			qui mat B`i'=e(b)
			qui mat V`i'=e(V)
		}

					/* set up keys, no more than 4 */
 		if `"`graph'"'~="" & `i'<=4 & !`haskey' {
			if "`symbol'"=="" {
				local sk="s(o)"
			}
			else {
				local msymbol=bsubstr("`symbol'",`i',1)
				local sk=`"s(`msymbol')"'
			}
			if "`connect'"=="" {
				local ck="c(l)"
			}
			else {
				local mconn=bsubstr("`connect'",`i',1)
				local ck=`"c(`mconn')"'
			}
			if "`pen'"=="" {
				local j=`i'+2
				local sp="p(`j')"
			}
			else {
				local mpen=bsubstr("`pen'",`i',1)
				local sp=`"p(`mpen')"'
			}
			local key `"key`i'(`sk' `ck' `sp' `"`aroc'"')"'
			local keylist `"`keylist' `key'"'
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
	if `"`graph'"' ~= `""' { /* set gr7 defaults */
		qui tab  `nbygrp'
		local max=r(r)
		if `"`symbol'"' == `""' { 
			local i 1
			while `i'<=`max' {
				local symbol `"`symbol' o"' 
				if `"`binormal'"'~="" {
					local symbol `"`symbol' i"' 
				}
				local i=`i'+1
			}
		}
		else if `"`binormal'"'~="" {
			local i 1
			while `i'<=`max' {
				local msymbol=bsubstr("`symbol'",`i',1)
				local nsymbol `"`nsymbol' `msymbol' i"'
				local i=`i'+1
				mac shift
			}
			local symbol="`nsymbol'"
		}

		if `"`connect'"' == `""' { 
			local i 1
			while `i'<=`max' {
				if `"`binormal'"'~="" {
					local connect `"`connect'.l"' 
				}
				else local connect `"`connect'l"'
				local i=`i'+1
			}
		}
		else if `"`binormal'"'~="" {
			local i 1
			while `i'<=`max' {
				local mconn=bsubstr("`connect'",`i',1)
				local nconn `"`nconn'.`mconn'"'
				local i=`i'+1
				mac shift
			}
			local connect="`nconn'"
		}
		if `"`pen'"' == `""' {
			local i 1
			while `i'<=`max' {
				local j=`i'+2
				if `"`binormal'"'~="" { 
					local pen=`"`pen'`j'`j'"'
				}
				else local pen=`"`pen'`j'"'
				local i=`i'+1
			}
		}
		else if `"`binormal'"'~="" {
			local i 1
			while `i'<=`max' {
				local mpen=bsubstr("`pen'",`i',1)
				local npen=`"`npen'`mpen'`mpen'"'
				local i=`i'+1
			}
			local pen="`npen'"
		}
		local penopt="pen(`pen'2)"

		if `"`bands'"'  == `""' { local bands  `"10"' }
		if `"`xlabel'"' == `""' { local xlabel `"0,.25,.5,.75,1"' }
		if `"`ylabel'"' == `""' { local ylabel `"0,.25,.5,.75,1"' }
		if `"`xline'"'  == `""' { local xline  `".25,.5,.75"' }
		if `"`yline'"'  == `""' { local yline  `".25,.5,.75"' }
		if `"`l2title'"' == `""' { local l2title  `"Sensitivity"' }

		qui gen `w' = cond(`x'==0, 0, cond(`x'==1, 1, .)) 
		label var `w' " "
		format `sensgr' `w' `x' %4.2f
		label var `x' `"1 - Specificity"'
		sort `x' `sensgr'
		if `"`separate'"'~="" {
			local byopt="by(`nbygrp')"
			sort `nbygrp' `x' `sensgr'
		}
		if `"`refline'"'=="" {
			local conopt="c(l`connect')"
		}
		else {
			local conopt="c(.`connect')"
		}
		if "`saving'"~="" {
			local savopt="saving(`saving')"
		}
		noi gr7 `sensgr' `w' `x' , `conopt' s(i`symbol') /*
		*/ border bands(`bands') `penopt' `keylist' /*
		*/ xlabel(`xlabel') ylabel(`ylabel') xline(`xline') /*
		*/ yline(`yline') `options' l2title("`l2title'") `byopt' /*
		*/ `savopt'
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
		local cil `=string(`level')'
		local cil `=length("`cil'")'
		if `cil' == 2 { 
			local spaces "      " 
		}
		else if `cil' == 4 { 
			local spaces "    " 
		}
		else { 
			local spaces "   " 
		}
        	di in smcl in gr /*
		*/ "`Gc'" _col(17) "   Obs       Area     Std. Err." /*
        	*/"`spaces'[`level'% Conf. Interval]" _n  "{hline 73}"
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
