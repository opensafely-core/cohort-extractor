*! version 1.0.1  15jan2007
program _applycoding, rclass
	version 9
	
	syntax newvarname [if] [in], coding(name) [ MISSing ]
	
	confirm matrix `coding' 
	local ncat = rowsof(`coding')
	local nvar = colsof(`coding')
	
	local vlist : colnames `coding' 
	capture confirm variable `vlist' 
	if _rc {
		dis as err ///
		     "nonexisting variable among column names of coding matrix" 
		exit 111
	}
	capture confirm numeric variable `vlist' 
	if _rc {
		dis as err "string variable among column names of coding matrix"
		exit 111
	}
		
	local codes : rownames `coding' 
	capture numlist `"`codes'"' // missing values not allowed
	if _rc {
		dis as err ///
			"nonnumeric value(s) among row names of coding matrix" 
		exit 121
	}
	
// input verified

	marksample touse, novarlist
	if ("`missing'"=="") { 
		markout `touse' `vlist'
	}	

	tempname uncodedobs unusedcodes
	tempvar  g touse2

	// beware: tricky macro code
	// generate a mask for an if condition with nvar clauses ....
	
	tokenize `vlist' 
	local mask
	forvalues j = 1/`nvar' { 
		// note: nothing before , 
		local mask `mask' & (``j''==`coding'[,`j'])
	}	
	
	// substitute in \`i' before the comma, 
	// note that the backslash delays macro substitution	
	local mask : subinstr local mask "[," "[\`i',", all

	qui gen `typlist' `g' = .
	scalar `unusedcodes' = 0
	forvalues i = 1 / `ncat'{
		gettoken c codes : codes 

		capture drop `touse2' 
		qui gen `touse2' = `touse' `mask' 
		qui count if `touse2'==1
		if r(N) > 0 { 	
			qui replace `g' = `c' if `touse2'
		}
		else {
			scalar `unusedcodes' = `unusedcodes' + 1
		}
	}

	qui count if missing(`g') & `touse' 
	scalar `uncodedobs' = r(N)

	gen `typlist' `varlist' = `g' 

	return scalar uncodedobs  = `uncodedobs'   
	return scalar unusedcodes = `unusedcodes' 
end	
exit
