*! version 3.0.9  20jan2020
program define integ, rclass byable(onecall) sort
	version 6.0, missing
	syntax varlist(min=2 max=2) [if] [in], [ Generate(string) /*
		*/ REPLACE BY(varlist) Trapezoid Initial(real 0) double float /*undoc.*/ ]
	if _by() {
		if "`by'"!="" { 
			di in red as smcl ///
			"{bf:by()} option and {bf:by} prefix may not be combined"
			exit 198
		}
		if (`"`generat'"'=="") {
			di in red as smcl ///
			"you must specify option {bf:generate()} with {bf:by} prefix"
			exit 198
		}
		local by "`_byvars'"
	}

	if (`"`generat'"'=="") {
		if ("`by'"!="") {
			di in red as smcl "you must specify option {bf:generate()} " ///
					  "with option {bf:by()}"
			exit 198
		}
		if ("`replace'"!="") {
			di in red as smcl "you must specify option {bf:generate()} " ///
					  "with option {bf:replace}"
			exit 198
		}
		if ("`double'"!="") {
			di in red as smcl "you must specify option {bf:generate()} " ///
					  "with option {bf:double}"
			exit 198
		}
	}
	opts_exclusive "`double' `float'"

	tokenize `varlist'
	local y `"`1'"'
	local x `"`2'"'
	
	if `"`generat'"'!="" {
		cap confirm new variable `generat'
		if (_rc==110 & "`replace'"!="") {
			drop `generat'
		}
		else if _rc {
			di as err as smcl "option {bf:generate()}:"
			confirm new variable `generat'
		}
		if `:word count `generat''>1 {
			di as err as smcl "option {bf:generate()}: " /// 
					  " too many variables specified"
			exit 103
		}
	}  

	tempvar doit ynew integ
	
	mark `doit' `if' `in'
	markout `doit' `y' `x'
	if !_by() {
		markout `doit' `by', strok	/* backwards compatibility */
	}
	
	sort `doit' `by' `x'
	
	Mean `ynew' `y' `x' `doit' `by'
	local y `"`r(mean)'"'

	quietly count if `doit'
	local n = r(N)
	if `n'==0 { error 2000 }
		
	if "`trapezoid'"=="" { /* use spline fit */
		tempvar y2
		
		spline_x `y2' `y' `x' `doit' `by'
		
		local spline /*
		*/ `"-cond(_N>2,(`x'-`x'[_n-1])^2*(`y2'+`y2'[_n-1])/12,0)"'
	}
	
	if ("`float'" != "") {
		local rettype float		
	}
	else {
		local rettype double
	}
	
	quietly by `doit' `by': gen `rettype' `integ' = `initial' /*
	*/	+ sum((`x'-`x'[_n-1])*(`y'+`y'[_n-1]`spline')/2) if `doit'


	if "`by'"=="" {
		ret scalar N_points = `n'
		ret scalar integral = `integ'[_N]
		global S_1 `n' 		/* double save in S_# and r() */
		global S_2 = `integ'[_N]
		local result : di %10.0g return(integral)
		di _n in gr `"number of points = "' in ye `"`n'"' _n(2) /*
		*/    in gr `"integral         = "' in ye trim(`"`result'"')
	} 

	if "`generat'"!="" { 
		if (("`double'"!="") | ///
		("`float'"=="" & c(type)=="double")) {
			rename `integ' `generat' 
		} 
		else {
			quietly gen float `generat' = `integ'
		}
	}
	
end

program define Mean, rclass
	args ynew y x doit /* ... */
	macro shift 4
	
	capture by `doit' `*': assert `x'!=`x'[_n-1] if _n>1 & `doit'
	if _rc==0 { /* `x' values are unique. */
		ret local mean `"`y'"'
		exit
	}
	
/* Compute mean of `y' at nonunique `x' values. */

	quietly by `doit' `*' `x': gen double `ynew' /* 
	*/	= cond(_n==_N,sum(`y')/_N,.) if `doit'
	markout `doit' `ynew'
	sort `doit' `*' `x'
	ret local mean `"`ynew'"'
end 
