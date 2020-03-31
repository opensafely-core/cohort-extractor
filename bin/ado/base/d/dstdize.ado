*! version 1.5.7  15mar2016
program define dstdize, rclass
	version 6.0 , missing
	syntax varlist(min=3) [if] [in], BY(varlist) [ /*
		*/ BAse(string) USing(string) nores /*
		*/ SAVing(string) PRint Format(string) Level(cilevel) ]
	tempvar touse
	mark `touse' `if' `in'

	qui count if `touse'
	if `r(N)'==0 {
		error 2000
	}
	
	tokenize `varlist'
	local death `1'
	local pop `2'
	mac shift 2
	local Ga `*'

	local nblnk = 0
	if `"`format'"'=="" {
		local format "%10.6f"
	}
	quietly capture di `format' 4.2
	if _rc {
		di in red "invalid format string"
		exit 198
	}

	tokenize `"`format'"', parse("%.fg")
	capture confirm number `2'
	if _rc {
                di in red "invalid format string"
                exit 198
        }
	local fwid = int(`2')

	local nblnk = cond(10-`fwid'<=0,0,10-`fwid')
		
	local Gc `"`by'"'
	capture assert `death' >=0 & int(`death')==`death' if `touse'
	if _rc {
		di in red `"`death' must have nonnegative integer values"'
		exit 499
	}
	capture assert `pop' >=0 & int(`pop')==`pop' if `touse'
	if _rc {
		di in red `"`pop' must have nonnegative integer values"'
		exit 499
	}
	capture assert `death'<=`pop' if `touse'
	if _rc {
		di in red `"`death' must be <= `pop'"'
		capture assert `death'<=`pop' if `death'<.
		if !_rc {
			di in red `"`death' has missing values which "' _c
			di in red `"you need to manually exclude"'
		}
		exit 499
	}
	if `"`using'"'!="" & `"`base'"'!="" { 
		di in red "using() and base() may not be specified together"
		exit 198 
	}
	if `"`base'"'!="" {
		tokenize `Gc', parse(" ")
		if "`2'"~="" {
			di in red /*
		       */ "may only specify one by() variable when using base()"
                	exit 198
		} 
		local method 2
	}
	else if `"`using'"'!="" {
		capture confirm file `"`using'"'
		local rc1 = _rc
		capture confirm file `"`using'.dta"'
		local rc2 = _rc
		if `rc1' & `rc2' {
			di as err `"file `using' not found"'
			exit 601
		}
		local method 3
	}
	else  local method 1
	if `"`saving'"'!="" { 
		tokenize `"`saving'"', parse(",")
		if "`3'"=="" {
			confirm new file `1'.dta 
		}
	}
	preserve 
	tempfile std 
	tempvar newpop 
	if `method'==1 {
		qui keep if `touse'
		qui keep `Ga' `pop'
		sort `Ga'
		quietly {
			by `Ga': gen double `newpop'=sum(`pop')
			qui by `Ga': keep if _n==_N
			qui drop `pop'
			rename `newpop' `pop'
		}
	}
	else if `method'==2 {
		local type : type `Gc'
		if bsubstr(`"`type'"',1,3)=="str" {
			qui keep if `Gc' == `"`base'"'
			qui count
			if r(N)==0 {
				di in red "base(" `"`base'"' ") value invalid"
				exit 499
			}
		}
		else {
			local cont=1
			local vlab : value label `Gc'
			if "`vlab'"~="" {
				sort `Gc'
				tempvar kp
				qui gen int `kp'=.
				local i 1
				while `i'<=_N {
					local j=`Gc'[`i']
					local y : label (`Gc')  `j'
					if "`y'"==`"`base'"' {
						qui replace `kp'= 1 if _n==`i'
					}
					local i = `i'+1
				}
				qui count if `kp'==1
				if r(N)~=0 {
					qui keep if `kp'==1
					local cont=0
				}
				drop `kp'
			}
			
			if "`vlab'"=="" | `cont'==1 {
				capture confirm number `base'
				if _rc {
				  di in red "base(" `"`base'"' ") value invalid"
                        	        exit 499
				}
				qui keep if `Gc'==`base'
				qui count
				if r(N)==0 {
					di in red "base(`base') value invalid"
					exit 499
				}
			}
		}

		qui keep if `touse'
		qui keep `Ga' `pop'
		sort `Ga'
		quietly {
			by `Ga': gen double `newpop'=sum(`pop')
			qui by `Ga': keep if _n==_N
			qui drop `pop'
			rename `newpop' `pop'
		}
	}
	else { /* method==3 */
		qui use `"`using'"', clear
		cap mark `touse' `if' `in'
		cap keep if `touse'
		capture confirm variable `Ga' `pop'
		if _rc {
			di in red "In using data: " _c
			confirm variable `Ga' `pop'
		}
		qui keep `Ga' `pop' 
		sort `Ga'
		quietly {
			by `Ga': gen double `newpop'=sum(`pop')
			qui by `Ga': keep if _n==_N
			qui drop `pop'
			rename `newpop' `pop'

		}
	}
	/* drop any missing values in standard population*/
	local j 1
	tokenize `"`Ga'"'
	while "``j''"!="" {
		qui capture drop if ``j''>=.
		qui capture drop if ``j''==""
		local j = `j' + 1
	}

	/* we need to compute and save the standard group fraction before
	   continuing */
	qui sum `pop' [w=`pop']
	tempvar stdfrac
	local totpop = r(sum_w)
	qui gen `stdfrac' = `pop'/r(sum_w)
	sort `Ga'
	qui save `"`std'"'
	if "`saving'"~="" {
		rename `stdfrac' _stdrate 
		qui save `saving'
		rename _stdrate `stdfrac'  
	}

	if `"`print'"'!="" {
		di
		/* take care of any value labels */

		local j 1
		tokenize `"`Ga'"'
		while "``j''"!="" {
			local vl : value label ``j''
			if `"`vl'"' != "" {
				tempvar lab`j'
				decode ``j'', generate(`lab`j'') maxlength(8)
				qui drop ``j''
				rename `lab`j'' ``j''
			}
			local j = `j' + 1
	    	}

		/* now.  print out the table */
		local j 1
		local col -6
		while "``j''"!="" {
			local col = 9 + `col'
			local j = `j' + 1
		}
		local dashes = 28+`col'
		local d2 = round((`dashes'-19)/2,1)
		local d2 = cond(`d2'>=80,80,`d2')
		di in smcl in gr "{hline `d2'}" "Standard Population" /*
			*/ "{hline `d2'}"
		sort `Ga'
		di in gr _col(`col') /*
		*/"Stratum       Pop.     Dist."
		local dashes = cond(`dashes'>=80,80,`dashes')
		di in smcl in gr "{hline `dashes'}"
		local i 1
		while `i' <= _N {
			tokenize `"`Ga'"'
			local j 1
			while "``j''"!="" {
				local type : type ``j''
				if bsubstr(`"`type'"',1,3)=="str" {
					local cl = 10-udstrlen(``j''[`i'])
					di in gr _col(`cl') ``j''[`i'] _c
				}
				else 	di in gr %9.0g ``j''[`i'] _c
				local j = `j' + 1
			 }
		 	di "  " %9.0g `pop'[`i'] %10.3f `stdfrac'[`i']
		 	local i = `i' + 1
	    	}
	    	local dashes = cond(`dashes'>=80,80,`dashes')
	    	di in smcl in gr "{hline `dashes'}"
	    	di in gr "Total:" in ye _col(`col') %14.0g `totpop'
	}               
	restore, preserve
	qui keep if `touse'
	qui keep `Ga' `Gc' `death' `pop' 
	sort `Ga' `Gc'  
	/* drop any missing values in data */
	local j 1
	tokenize `"`Ga'"'
	local start = _N
	while "``j''"!="" {
		capture drop if ``j''>=.
		capture drop if ``j''==""
		local j = `j' + 1
	}
	local stop = _N
	local num = `start' - `stop'
	if `num' > 0 { 
		di in bl "(" `num' " observation" _c
		if `num'!=1 { di in bl "s" _c }
		di in bl " excluded because of missing values)"
	}

	tempvar gcpop gcdeath left right se crude adj 
	qui gen double `left' = .
	qui gen double `right' = .
	qui gen `se' = .
	qui by `Ga' `Gc' : gen double `gcpop'=sum(`pop')
	qui by `Ga' `Gc' : gen double `gcdeath'=sum(`death')
	qui by `Ga' `Gc' : keep if _n==_N
	qui drop `pop' `death'
	sort `Ga'
	qui merge `Ga' using `"`std'"'
	/* at this point, the data set contains variables `Ga'  
	   `Gc', `gcpop', `gcdeath', `pop' and `stdfrac'.  We need to 
	   calculate `frac' `gcrate', and  `pdeath' */

	sort `Gc'
	/* calculate frac */
	tempvar gctot frac gcdt
	qui by `Gc' : gen double `gctot'=sum(`gcpop')
	qui by `Gc' : gen `frac' = `gcpop'/`gctot'[_N]
	qui by `Gc' : replace `gctot' = `gctot'[_N]

	qui by `Gc' : gen double `gcdt'=sum(`gcdeath')
	qui by `Gc' : replace `gcdt' = `gcdt'[_N]
	qui gen double `crude' = `gcdt'/`gctot'

	/* calculate `gcrate' */
	tempvar gcrate 
	qui gen `gcrate' = `gcdeath'/`gcpop'



	/* calculate pdeath */
	tempvar pdeath pdtot
	qui gen `pdeath' = `gcdeath'*`stdfrac'/`frac'
	qui by `Gc' : gen `pdtot'= sum(`pdeath')
	qui by `Gc' : replace `pdtot' = `pdtot'[_N]
	qui gen `adj' = `pdtot'/`gctot'

	/* take care of any value labels */
	local j 1
	tokenize `"`Ga'"'
	while "``j''"!="" {
		local vl : value label ``j''
		if `"`vl'"' != "" {
			tempvar lab`j'
			decode ``j'', generate(`lab`j'') maxlength(8)
			qui drop ``j''
			rename `lab`j'' ``j''
		}
		local j = `j' + 1
	}

	/* now.  print out the table */
	sort `Gc'
	tempvar marker counter 
	qui by `Gc': gen int `counter' = 1 if _n==1
	qui replace `counter'=sum(`counter')
	local j 1
	local col -6
	while "``j''"!="" {
		local col = 9 + `col'
		local j = `j' + 1
	}
	local dashes = 55+`col'
	qui sum `counter'
	local start = r(min)
	local stop = r(max)
	qui gen byte `marker'=.
	while `start'<=`stop' {
		di
		local dashes = cond(`dashes'>=80,80,`dashes')
		di in smcl in gr "{hline `dashes'}"
		qui replace `marker'=1 if `counter'==`start' 
		* sort `Gc'
		sort `marker'
		di in bl "-> `Gc'= " _c
		tokenize `"`Gc'"'
		local j 1
		while "``j''"!="" {
			di in bl ``j'' " " _c
			local j = `j' + 1
		}
		di 
		sort `Ga'
		di in smcl in gr _col(`col') /*
		  */"                       {hline 5}Unadjusted{hline 5}  Std."
		di in gr _col(`col') /*
		  */"                              Pop.  Stratum  Pop.  "
		di in gr _col(`col') /*
		  */"Stratum       Pop.     Cases  Dist. Rate[s] Dst[P]  s*P"
		di in smcl in gr "{hline `dashes'}"
		local i 1
		local ci_sum 0  /* sum up for conf. intervals */ 
		while `i' <= _N {
		    if `marker'[`i']==1 {
			tokenize `"`Ga'"'
			local j 1
			while "``j''"!="" {
			    local type : type ``j''
			    if bsubstr(`"`type'"',1,3)=="str" {
				local cl = 10-udstrlen(``j''[`i'])
				di in gr _col(`cl') ``j''[`i'] _c
			    }
			    else {
				di in gr %9.0g ``j''[`i'] _c
			    }
			    local j = `j' + 1
			}
			di %11.0g `gcpop'[`i'] _c
			di %10.0g `gcdeath'[`i'] _c
			di %7.3f `frac'[`i'] _c
			di %7.4f `gcrate'[`i'] _c
			di %7.3f `stdfrac'[`i'] _c
			di %7.4f `gcrate'[`i'] * `stdfrac'[`i']
			local ci_sum=`ci_sum' +     /*
				*/   `stdfrac'[`i']*`stdfrac'[`i'] *    /*
				*/   `gcrate'[`i'] *       /*
				*/   (1-`gcrate'[`i']) /   /*
				*/   `gcpop'[`i'] 
		    }
		    local i = `i' + 1
		}
	    local dashes = cond(`dashes'>=80,80,`dashes')
	    di in smcl in gr "{hline `dashes'}"
	    sort `marker'
	    local cl = `col' + 6
	    local ci = invnorm(.5+`level'/200)*sqrt(`ci_sum')
	    qui replace `se' = sqrt(`ci_sum') if `marker'==1
	    qui replace `left' = max(0,`pdtot'/`gctot'-`ci') if `marker'==1
	    qui replace `right' = `pdtot'/`gctot'+`ci' if `marker'==1
	
	    local cil `=string(`level')'
	    local cil `=length("`cil'")'
	    local spaces ""
	    if `cil' == 2 {
	    	local spaces "   "
	    }
	    else if `cil' == 4 {
	    	local spaces " "
	    }
	    di in gr "Totals:" in ye _col(`cl') %12.0g `gctot' %10.0g `gcdt' in gr "    Adjusted Cases:" in ye %9.1f `pdtot'
	    di in gr _col(`cl') _skip(30) "Crude Rate:" in ye %9.4f `crude'
	    di in gr _col(`cl') _skip(27) "Adjusted Rate:" in ye %9.4f `adj'
di in gr _col(`cl') _skip(12) "`spaces'" `"`=strsubdp("`level'")'"' /*
		*/ "% Conf. Interval: [" in ye %6.4f `left' ", " /*
		*/ %6.4f `right' in gr "]"
	    local start = `start' + 1
	    * qui drop if `marker'==1
	    qui replace `marker'=.
	} 

	di
	di in gr  "Summary of Study Populations:"
	tokenize `by'
	local j 1
	while "``j''"!="" {
		local k=`j'+1
		if "``k''"=="" { local cflag "_c" }
		else           { local cflag " "  }
		local cl = 10-udstrlen(abbrev("``j''",8))
		di in gr _col(`cl') abbrev("``j''",8) `cflag'
		local j=`j'+1
	}

	di _col(14) in gr "N" _col(21) in gr "Crude" /*
	    */ _col(31) in gr "Adj_Rate" _col(46) in gr "Confidence Interval"
	di in smcl in gr " {hline 74}"

	if "`res'"~="" {
		local star = "*"
	}

	`star' tempname Nobs Crude Adj Left Right SE

	sort `Gc'
	qui by `Gc': replace `marker'=1 if _n==1
	`star' qui count if `marker'==1
	`star' ret scalar k = r(N)
	`star' mat `Nobs'=J(1,`r(N)',0)
	`star' mat `Crude'=J(1,`r(N)',0)
	`star' mat `Adj'=J(1,`r(N)',0)
	`star' mat `Left'=J(1,`r(N)',0)
	`star' mat `Right'=J(1,`r(N)',0)
	`star' mat `SE'=J(1,`r(N)',0)
	`star' mat rown `Nobs' = Nobs
	`star' mat rown `Crude' = Crude
	`star' mat rown `Adj' = Adjusted
	`star' mat rown `Left' = Left
	`star' mat rown `Right' = Right
	`star' mat rown `SE' = Se
	local mk 1
	local i 1
	while `i'<=_N {
		if `marker'[`i'] == 1 {
			local nblnk = cond(`nblnk'>=79,79,`nblnk')

			tokenize `"`Gc'"'
			local j 1
			`star' local c`mk'=""

			while "``j''"!="" {
			    local k=`j'+1
			    if "``k''"=="" { local cflag "_c" }
			    else { local cflag " " }
			    local type : type ``j''
			    if bsubstr(`"`type'"',1,3)=="str" {
				local cl = 10-udstrlen(``j''[`i'])
				if `cl'<=0 {
					local cl=1
					local dispji = udsubstr(``j''[`i'],1,9)
					if udstrlen(`"`dispji'"') < 9 {
						local dispji = `"`dispji'"' + " "
					}					
					di in gr _col(`cl') /*
					*/ `"`dispji'"' `cflag'
					local temp=``j''[`i']
				       `star' local c`mk' `"`c`mk'' `"`temp'"'"'
				}
				else {
					di in gr _col(`cl') /*
					*/ `myfrm' ``j''[`i'] `cflag'
					local temp=``j''[`i']
				       `star' local c`mk' `"`c`mk'' `"`temp'"'"'
				}
			    }
			    else {
				di in gr %9.0g ``j''[`i'] `cflag'
				local temp=``j''[`i']
				`star' local c`mk' `"`c`mk'' `"`temp'"'"'

			    }
			    local j = `j' + 1
			}
			#delimit ;
			di 
				in ye _col(4) 
				%11.0g `gctot'[`i'] 
				_col(16) _skip(`nblnk')  
				`format' `crude'[`i'] 
				_col(29) _skip(`nblnk')  
				`format' `adj'[`i']   
				_col(43) in gr "["
				in ye _skip(`nblnk') `format' `left'[`i'] 
				in gr "," _col(57) _skip(`nblnk')  
				`format' in ye `right'[`i'] in gr "]" ;
			#delimit cr
			`star' mat `Nobs'[1,`mk']=`gctot'[`i']
			`star' mat `Crude'[1,`mk']= /* 
			*/ cond(`crude'[`i']>=.,9,`crude'[`i']) 
			`star' mat `Adj'[1,`mk']= /*
			*/ cond(`adj'[`i']>=.,9,`adj'[`i'])
			`star' mat `Left'[1,`mk']= `left'[`i']
			`star' mat `Right'[1,`mk']= `right'[`i']
			`star' mat `SE'[1,`mk']= `se'[`i']
		        `star' ret local c`mk'= `"`c`mk''"'
			local mk=`mk'+1
		}
		local i=`i'+1
	}
	return local by =`"`by'"' 
	`star' return mat Nobs `Nobs'
	`star' return mat crude `Crude'
	`star' return mat adj `Adj'
	if _caller() < 14 {
		`star' return mat lb `Left'
		`star' return mat ub `Right'
	}
	else {
		`star' return mat lb_adj `Left', copy
		`star' return mat ub_adj `Right', copy
		`star' return hidden mat lb `Left'
		`star' return hidden mat ub `Right'
	}
	`star' return mat se `SE'
end
