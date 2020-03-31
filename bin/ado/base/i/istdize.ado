*! version 2.2.1  18feb2015  
program define istdize, rclass 
	version 6, missing
	syntax varlist(min=3) using/ [if] [in] [, /* 
		*/ BY(varlist) POPvars(string) PRint /*
		*/ Format(string) Level(cilevel) RATE(string) /*
		*/ ]

	tokenize `varlist'
	local cases `1'
	local pop `2'
	mac shift 2
	local Ga `*'

	local nblnk = 0

	if `"`format'"'=="" {
		local format "%10.6f"
		local format1 "%8.6f"
	}
	else 	local format1  "`format'"
	quietly capture di `format' 4.2
	if _rc {
		di in red "invalid format string"
		exit 198
	}

	tokenize `"`format'"', parse("%.fg")
	if "`popvars'"=="" & "`rate'"=="" {
		di in red "must specify either rate() or popvars() option"
		exit 198
	}
	if "`popvars'"!="" & "`rate'"!="" {
		di in red /*
		*/ "options rate() and popvars() may not be specified together"
		exit 198
	}
	local dot=index(`"`using'"',".")
	if `dot'==0 { local using = `"`using'.dta"' }
	
	if "`rate'"!="" {
		tokenize "`rate'"
		local rate `1'
		local crd `2'	
		if "`rate'"=="" | "`crd'"=="" {
			di in red /*
			*/ "must specify standards population's stratum-level" 
			di in red /*
			*/ "rate variable and crude rate (variable or value)"
			exit 198
		}
	}
	if "`popvars'"!="" {
		tokenize `popvars'
		local popcase `1' 
		local popvar `2'
		if "`popcase'"=="" {
			di in red /*
		  */ "must specify standards population's cases count variable"
			exit 198
		}       
		if "`popvar'"=="" {
			di in red /*
			*/ "must specify standards population's count variable"
			exit 198
		}
	}

	tempvar touse
	mark `touse' `if' `in'
	preserve 

	tempfile std 
	tempvar cnt one
	if "`popvars'"!="" {
		qui use `"`using'"', clear 	/* Use standard population */
		sum `popcases', meanonly
		local numera=r(sum)
		sum `popvar', meanonly
		local denom=r(sum)
		sort `Ga'
		
		tempvar scase svar 
		qui by `Ga': gen `scase'=sum(`popcase')
		qui by `Ga': gen `svar'=sum(`popvar')
		qui by `Ga': keep if _n==_N
		qui replace `popcase'=`scase' 
		qui replace `popvar'=`svar'	

		tempvar rate crd
		qui gen double  `rate'=`popcases'/`popvar'
		qui gen double  `crd'=`numera'/`denom'
		keep `Ga' `rate' `crd'
	}
	else {
		qui use `"`using'"', clear  	/* Use standard population */
	}
	capture confirm variable `rate'
	if _rc {
		di in red "In using data: variable `rate' not found"
		exit 198
	}
	capture confirm number `crd'
	if _rc {
		capture confirm variable `crd'
		if _rc {
			di in red "In using data: variable `popcrd' not found"
			exit 198
		}
	}
	tempvar  popcrd	
	capture confirm number `crd'
	if _rc {
		qui gen double  `popcrd'=`crd'
	}
	else 	qui gen double  `popcrd'=`crd'
 	qui sum `popcrd'
	if r(min)<0 | r(max)>1 {
		di in red "Pop Crude Rate must be between 0 and 1" 
		exit 198
	}
	if r(min) == r(max) {
		qui replace `popcrd'=r(min)
	}
	else {
		di in red "In using data: crude rate not the same for all obs."
		exit 198
	}
 	qui sum `rate'
	if r(min)<0 | r(max)>1 {
		di in red "In using data: Rates must be between 0 and 1" 
		exit 198
	}
	capture confirm variable `Ga' `rate' `popcrd'
	if _rc {
		di in red "In using data: " _c
		confirm variable `Ga' `rate' `popcrd'
	}
	qui keep `Ga' `rate' `popcrd'
	qui gen int `one'= 1
	sort `Ga'
	quietly {
		by `Ga': gen int `cnt'=sum(`one')
		count if `cnt'>1
               	if r(N) !=0 {  
			di in red "In using data: One or more repeated strata"
			exit 198
		}
		qui drop `one' `cnt'
	}
	/* drop any missing values in standard population*/

    qui save `"`std'"'
	if "`print'"!="" {
		Prnstd  `rate' `popcrd' `Ga'
	}               

	restore, preserve
	if "`by'"!="" {
		local Gc "`by'"
		markout `touse' `Ga' `Gc' `dead', strok
		qui keep if `touse'
		tempvar topop npop
		sort `Gc'
		qui by `Gc': gen `topop'=sum(`pop')
		qui by `Gc': replace `topop'=`topop'[_N]
		sort `Gc' `cases'
		qui by `Gc' : replace `cases'=`cases'[_n-1] if `cases'>=.
		capture by `Gc' : assert `cases' == `cases'[_n-1] if _n > 1
		if _rc {
			di in red "values of `cases' must be the same for all observations in a group"
			exit 499
		}
	}
	else  {
		local Gc 
		markout `touse' `Ga'  `dead', strok
		qui keep if `touse'
		tempvar  topop npop
		qui gen `topop'=sum(`pop')
		qui replace `topop'=`topop'[_N]
		sort `cases'
		qui replace `cases'=`cases'[_n-1] if `cases'>=.
		capture assert `cases' == `cases'[_n-1] if _n > 1
		if _rc {
			di in red "values of `cases' must be the same for all observations"
			exit 499
		}
	}
	egen `npop'=sum(`pop'), by(`Gc' `Ga')
	sort `Gc' `Ga'
	qui by `Gc' `Ga': replace `npop'=. if _n!=_N
	capture assert `cases' >=0 & int(`cases')==`cases'
	if _rc {
		di in red "`cases' must have nonnegative integer values"
		exit 499
	}

	capture assert `npop' >=0 & int(`npop')==`npop'
	if _rc {
		di in red "`pop' must have nonnegative integer values"
		exit 499
	}
	
	capture assert `cases'<=`topop'
	if _rc {
		di in red "total `cases' must be <= total `pop'"
		exit 499
	}
	markout `touse' `Ga' `Gc' `dead'  `npop', strok
	qui keep if `touse'!=0
	sort `Ga' `Gc'  
	qui merge `Ga' using `"`std'"'
	qui keep if _merge==3
	sort `Gc' `Ga'
	/* calculate frac */
	tempvar expd gctot exdead 
	qui by `Gc' `Ga' : gen double  `gctot'=sum(`npop')
	qui by `Gc' `Ga' : replace `gctot' = `gctot'[_N]
	qui by `Gc' `Ga' : replace `gctot' = . if  _n !=_N
	qui gen double `exdead'=`gctot'*`rate'
	qui drop if `exdead'>=.

	/* print out the tables */
	tempvar marker counter 
	if "`Gc'"!="" {
		sort `Gc' `Ga'
		qui by `Gc': gen int `counter' = 1 if _n==1
	}
	else 	qui gen int `counter' = 1 if _n==1
	qui replace `counter'=sum(`counter')
	tokenize "`Ga'"
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
	tempvar scrude sadj ssmr sleft sright sexp ssmru ssmrl
	qui gen double `scrude'=.
	qui gen double `sadj'=.
	qui gen double `ssmr'=.
	qui gen double `sleft'=.
	qui gen double `sright'=.
	qui gen double `sexp'=.
	qui gen double `ssmrl'=.
	qui gen double `ssmru'=.
	local j 1                   /* Labels subroutine */
	tempvar order
	sort `Ga' 
	qui gen `order'=_n	
	tokenize "`Ga'"
	while "``j''"!="" {
		local vl : value label ``j''
		if "`vl'" != "" {
			tempvar lab`j'
			decode ``j'', generate(`lab`j'')
			qui drop ``j''
			rename `lab`j'' ``j''
		}
		local j = `j' + 1
	}
	while `start'<=`stop' { 	/*loop over groups */
		di
		local dashes = cond(`dashes'>=80,80,`dashes')
		di in smcl in gr "{hline `dashes'}"
		qui replace `marker'=1 if `counter'==`start' 
		sort `marker'
		if "`Gc'"!="" {
			di in bl "-> `Gc'= " _c
			tokenize "`Gc'"
			local j 1
			while "``j''"!="" {
				di in bl ``j'' " " _c
				local j = `j' + 1
			}
		}
		else if `"`if'"'!="" {
 			di in bl "-> " bsubstr(`"`if'"',3,20) 
			local ind=index(`"`if'"',"=")
			local ind1=index(`"`if'"',"f")
			local by=  bsubstr(`"`if'"',`ind1'+2,`ind'-`ind1'-2)
			local Gc=  bsubstr(`"`if'"',`ind1'+2,`ind'-`ind1'-2)
		}
		else 	di in bl "-> Total Sample" 
		di 
		sort `order'
		di in gr _col(`col') /*
		  */"                 Indirect Standardization   "
		di " "
		di in gr _col(`col') /*
		 */"                 Standard                     "
		di in gr _col(`col') /*
		*/"                Population     Observed      Cases    "
		di in gr _col(`col') /*
		  */"Stratum            Rate       Population    Expected "
		di in smcl in gr "{hline `dashes'}"
		local i 1
		while `i' <= _N {
			if `marker'[`i']==1 {
				tokenize "`Ga'"
				local j 1
				while "``j''"!="" {
					local type : type ``j''
					if bsubstr("`type'",1,3)=="str" {
						local cl = 10-length(``j''[`i'])
						di in gr /*
						 */_col(`cl') ``j''[`i'] _c
				    	}
				    	else {
						di in gr %9.0g ``j''[`i'] _c
				    	}
				    	local j = `j' + 1
				}
				di %17.4f `rate'[`i'] _c
				di %14.0gc `gctot'[`i'] _c
				di %13.2fc `exdead'[`i'] 
			}
			local i = `i' + 1
		}
		local dashes = cond(`dashes'>=80,80,`dashes')
		di in smcl in gr "{hline `dashes'}"
	
		tempname total totde crude smr adj  left right
		sort `marker'
		local cl = `col' + 24
		sum `gctot' if `marker'==1, meanonly
		scalar `total'=r(sum)
		sum `exdead' if `marker'==1, meanonly
		scalar `totde'=r(sum)
		scalar `crude'=`cases'/`total'	
		scalar `smr' =(`cases'/`totde')
		tempname vars smrl smru nci nci1 nci2
		scalar `vars'=`cases'/(`totde')^2
		scalar `adj' =(`cases'/`totde')*`popcrd'
		scalar `nci' = invnorm(.5+`level'/200)
		scalar `nci1'= (1-(`nci'/(2*sqrt(`cases')) ))^2
		scalar `nci2'= (1+(`nci'/(2*sqrt(`cases'+1)) ))^2
		scalar  `smrl' = max(0,`smr'*`nci1')
		scalar  `smru' = `smr'*((`cases'+1)/`cases')*`nci2'
		*noi di in red `smr' "  " `smrl' " - " `smru' 
		scalar  `left' = max(0,`smrl'*`popcrd') 
		scalar  `right' = `smru'*`popcrd' 
		qui replace `scrude'=`crude' if `marker'==1
		qui replace `sadj'=`adj' if `marker'==1
		qui replace `ssmr'=`smr' if `marker'==1
     		qui replace `sleft' = `left' if `marker'==1
		qui replace `sright' =`right'  if `marker'==1
		qui replace `sexp' =`totde'  if `marker'==1
		qui replace `ssmru' =`smru'  if `marker'==1
		qui replace `ssmrl' =`smrl'  if `marker'==1
		/* exact smr CI */
		qui cii 1 `cases',poisson level(`level')
        	scalar  `smrl' = max(0,$S_5/`sexp')
        	scalar  `smru' = $S_6/`sexp' 
        	qui replace `ssmru' =`smru'  if `marker'==1
        	qui replace `ssmrl' =`smrl'  if `marker'==1
		local pexact= "Exact"
		local cil `=string(`level')'
		local cil `=length("`cil'")'
		local spaces "   "
		if `cil' == 4 {
			local spaces " "
		}
		else if `cil' == 5 {
			local spaces ""
		}
		di in gr /*
		 */ "Totals:" in ye _col(`cl') %14.0g `total' %13.2f `totde'
		local cl =  24
		di ""
        	di in gr /*
		*/ _col(`cl') _skip(26) "Observed Cases:" in ye %9.0fc `cases'
		di in gr /*
		 */ _col(`cl') _skip(27) "SMR (Obs/Exp):" in ye %9.2f `smr'
		di in gr _col(`cl') /*
*/ "`spaces'  SMR exact " `"`=strsubdp("`level'")'"' /*
		*/ "% Conf. Interval: [" in ye %6.4f `smrl' ", " /*
		*/ %6.4f `smru' in gr "]"
		di in gr /*
		 */_col(`cl') _skip(30) "Crude Rate:" in ye %9.4f `crude'
		di in gr /*
		 */ _col(`cl') _skip(27) "Adjusted Rate:" in ye %9.4f `adj'
di in gr _col(`cl') _skip(10) "`spaces'  " `"`=strsubdp("`level'")'"' /*
			*/ "% Conf. Interval: [" in ye %6.4f `left' ", " /*
			*/ %6.4f `right' in gr "]"
		local start = `start' + 1
		qui replace `marker'=.
	} 
	global P_Ex `pexact'
 	Prnsmr1 `cases' `scrude' `sadj' `sleft' `sright' `format' `format1' `Gc'
	ret add
 	Prnsmr /*
	 */`cases' `sexp' `ssmr' `sadj' `ssmrl' `ssmru' `format' `format1' `Gc'
	ret add
end

program def Prnsmr1, rclass
	args cases scrude sadj sleft sright format format1
	mac shift 7
	local Gc `*'	
	di " "
	di " "
	di
	di in gr  "Summary of Study Populations (Rates):"
	di ""
	tokenize "`Gc'"
	local pr = `: word count `Gc'' - 1
	local j 1
	while "``j''"!="" {
		local k=`j'+1
		if "``k''"=="" { local cflag "_c" }
		else           { local cflag " "  }
		local cl = 10-length(abbrev("``j''",8))
		if `pr' == 0 { di in gr _col(17) "Cases" }
		else {
			if `j' == `pr' { local dic = `"_col(17) "Cases""' }
			else local dic
		}
		di in gr _col(`cl') abbrev("``j''",8) `dic' `cflag'
		local j=`j'+1
	}
	tempvar marker counter 
	qui gen `marker'=.
	local nblnk 0
	if `pr' < 0 { di in gr _col(8) "Cases" }
	di _col(5) in gr "Observed" in gr _col(18) "Crude"/*
	    */ _col(26) in gr "Adj_Rate" _col(36)  "Confidence Interval"
	di in smcl in gr "{hline 74}"
	if "`Gc'"!="" {
		sort `Gc'
		qui by `Gc': replace `marker'=1 if _n==1
	}
	else 	qui replace `marker'=1 if _n==1
	
	tempname crmat adj lb_adj ub_adj
	
	local i=1
	while `i'<=_N {
		if `marker'[`i'] == 1 {
			local nblnk = cond(`nblnk'>=79,79,`nblnk')
			tokenize "`Gc'"
			local j 1
			while "``j''"!="" {
				local k=`j'+1
				if "``k''"=="" { local cflag "_c" }
				else 	local cflag " "
				local type : type ``j''
				if bsubstr("`type'",1,3)=="str" {
					local cl = 11-length(``j''[`i'])
					di in gr _col(`cl') ``j''[`i'] `cflag'
				}
	 			else {
					di in gr %9.0g ``j''[`i'] `cflag'
			    	}
				local j = `j' + 1
			}
			#delimit ;
				di 
				in ye _col(2) 
				%10.0fc `cases'[`i'] 
				_col(8) _skip(`nblnk') 
				`format' `scrude'[`i'] 
				_col(23) _skip(`nblnk')  
				`format' `sadj'[`i']   
				_col(35) in gr "["
				in ye  `format1' `sleft'[`i'] 
				in gr ", "   
				`format1' in ye `sright'[`i'] in gr "]" ;
			#delimit cr

			mat `crmat' = (nullmat(`crmat'), `scrude'[`i'])
			mat `adj' = (nullmat(`adj'), `sadj'[`i'])
			mat `lb_adj' = (nullmat(`lb_adj'), `sleft'[`i'])
			mat `ub_adj' = (nullmat(`ub_adj'), `sright'[`i'])
		}
		local i=`i'+1
	}

	return matrix ub_adj = `ub_adj'
	return matrix lb_adj = `lb_adj'
	return matrix adj = `adj'
	return matrix crude = `crmat'
	
end

program def Prnsmr, rclass
	args cases sexp ssmr sadj sleft sright format format1
	mac shift 8
	local Gc `*'	
	di " "
	di " "
	di in gr  "Summary of Study Populations (SMR):"
	di ""
	tokenize "`Gc'"
	local pr = `: word count `Gc'' - 1	
	local j 1
	while "``j''"!="" {
		local k=`j'+1
		if "``k''"=="" { local cflag "_c" }
		else             local cflag " " 
		local cl = 10-length(abbrev("``j''",8))	
		if `pr' == 0 { di in gr _col(17) "Cases        Cases                   $P_Ex" }
		else {
			if `j' == `pr' { local dic = `"_col(17) "Cases" _col(30) "Cases" _col(54) "$P_Ex""' }
			else local dic
		}
		di in gr _col(`cl') abbrev("``j''",8) `dic' `cflag'
		local j=`j'+1
	}
	tempvar marker counter 
	qui gen `marker'=.
	local nblnk = 0
	if `pr' < 0 { di in gr _col(8) "Cases        Cases                   $P_Ex" }
	di _col(5) in gr "Observed" in gr _col(18) "Expected" _col(30)  "SMR"/*
	    */  _col(38)  "Confidence Interval"
	di in smcl in gr "{hline 74}"
	if "`Gc'"!="" {
		sort `Gc'
		qui by `Gc': replace `marker'=1 if _n==1
	}
	else {
		qui replace `marker'=1 if _n==1
	}
	
	tempname cmat cemat smrmat lb_smr ub_smr 
	local mk 1
	local i=1
	while `i'<=_N {
		if `marker'[`i'] == 1 {
			local nblnk = cond(`nblnk'>=79,79,`nblnk')
			tokenize "`Gc'"
			local c`mk'=""
			local j 1
			while "``j''"!="" {
				local k=`j'+1
				if "``k''"=="" { local cflag "_c" }
				else { local cflag " " }
				local type : type ``j''
				if bsubstr("`type'",1,3)=="str" {
					local cl = 11-length(``j''[`i'])
					di in gr _col(`cl') ``j''[`i'] `cflag'
					local temp=``j''[`i']
					local c`mk' `"`c`mk'' `"`temp'"'"'	  					
				}
				else {
					di in gr %9.0g ``j''[`i'] `cflag'
					local temp=``j''[`i']
					local c`mk' `"`c`mk'' `"`temp'"'"'					
				}
				local j = `j' + 1
			}
			
			#delimit ;
				di 
				in ye _col(2) 
				%10.0fc `cases'[`i'] 
				_col(15) _skip(`nblnk')  
				%10.2fc `sexp'[`i'] 
				_col(25) _skip(`nblnk')  
				%8.3f `ssmr'[`i'] 
				_col(37) in gr "["
				in ye  `format1' `sleft'[`i'] 
				in gr ", "   
				`format1' in ye `sright'[`i'] in gr "]" ;
			#delimit cr
		
			return local c`mk'= `"`c`mk''"'
			local pops = `mk'
			local mk=`mk'+1
		
			mat `cmat' = (nullmat(`cmat'), `cases'[`i'])
			mat `cemat' = (nullmat(`cemat'), `sexp'[`i'])
			mat `smrmat' = (nullmat(`smrmat'), `ssmr'[`i'])
			mat `lb_smr' = (nullmat(`lb_smr'), `sleft'[`i'])
			mat `ub_smr' = (nullmat(`ub_smr'), `sright'[`i'])
		}
		local i=`i'+1
	}

	return local by =`"`Gc'"'
	return scalar k = `pops'
	return matrix ub_smr = `ub_smr'
	return matrix lb_smr = `lb_smr'
	return matrix smr = `smrmat'
	return matrix cases_exp = `cemat'
	return matrix cases_obs = `cmat'

end

program def Prnstd
	args rate popcrd
	mac shift 2
	local Ga `*'
	sort `Ga'
	di
	/* take care of any value labels */
	local j 1
	tokenize "`Ga'"
	while "``j''"!="" {
		local vl : value label ``j''
		if "`vl'" != "" {
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
	di in smcl in gr "{hline `d2'}Standard Population{hline `d2'}"
	di in gr _col(`col') /*
	*/"Stratum               Rate"
	local dashes = cond(`dashes'>=80,80,`dashes')
	di in smcl in gr "{hline `dashes'}"
	local i 1
	while `i' <= _N {
		tokenize "`Ga'"
		local j 1
		while "``j''"!="" {
			local type : type ``j''
			if bsubstr("`type'",1,3)=="str" {
				local cl = 10-length(``j''[`i'])
				di in gr _col(`cl') ``j''[`i'] _c
			}
			else {
				di in gr %9.0g ``j''[`i'] _c
			}
			local j = `j' + 1
		 }
		 di "  " %19.5f `rate'[`i'] 
		 local i = `i' + 1
	}
	local dashes = cond(`dashes'>=80,80,`dashes')
	di in smcl in gr "{hline `dashes'}"
	di in gr "Standard population's crude rate:" /*
		*/  in ye _col(`col') _skip(4) %10.5f `popcrd'[1]

end

