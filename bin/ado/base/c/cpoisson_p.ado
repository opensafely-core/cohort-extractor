*! version 1.0.7  15mar2018
program define cpoisson_p
	version 14
	syntax [anything] [if] [in] 					     ///
		[, 							     ///
			SCores 						     ///
			N						     ///
			IR						     ///
			CM     						     ///
			Pr(string)					     ///
			CPr(string)					     ///
			xb						     ///
			stdp						     ///
			noOFFset ]
	
/* Mark sample (this is not e(sample)). */
	marksample touse
	
	 _stubstar2names `anything', nvars(1)
	local varlist = s(varlist)
	local typlist = s(typlist)
	local numsc: list sizeof varlist
	local stub = real("`s(stub)'")	

	cap confirm new variable `varlist'
	if (_rc!= 0) {
		di as err "newvarlist invalid"
		exit 198
	}			
	local nword : word count `varlist'
	if (`nword'>1) {
		di as smcl as err "{p}newvarlist must contain the " 	     ///
		"name of only one new variable"
		di as smcl as err "{p_end}"
		exit 103
	}
	
	if (`"`anything'"'=="") {
		di as err  "newvarlist required"
		exit 100			
	}

/* get model info from e() */	
	local modelnum = e(emodelnum)
	local y = e(depvar)
	local xvars = e(exvars)
	local addcons = e(eaddcons)
	local lc = e(llopt)
	local rc = e(ulopt)
	local isllnumvar = e(eisllnumvar)
	local isulnumvar = e(eisulnumvar)
	local exposure = e(eexposure)
	local eoff = e(offset)
	tempname b
	matrix `b' = e(b)
	tempname V
	matrix `V' = e(V)
	
	if (`"`pr'"'=="" & `"`cpr'"'=="") {
		foreach op in `options'	{
			if ("`op'"=="pr" | "`op'"=="cpr") {
				di as err "option {bf:`op'} " 		     ///
					"incorrectly specified"
				exit 198
			}			
		}
	}
	
	local nstat = ("`scores'"!="") + ("`n'"!="") + ("`ir'"!="") 	     ///
		+ ("`cm'"!="") + (`"`pr'"'!="") + (`"`cpr'"'!="") 	     ///
		+ ("`xb'"!="") + ("`stdp'"!="")
	if (`nstat'>1) {
		di as err "may not specify too many options"
		exit 198
	}
	
	tempvar ynew
	if (`modelnum'==1) {
		qui gen double `ynew' = `y'
	}
	else if (`modelnum'==2 | `modelnum'==3) {
		tempvar diff isrc
		qui gen double `diff' = `rc'-`y' if `touse'
		qui gen int `isrc' = (`diff'<=0) if `touse'
		qui gen double `ynew' = `y'
		qui replace `ynew' = `rc' if (`touse' & `isrc'==1)		
	}
	else if (`modelnum'==4 | `modelnum'==7) {
		tempvar diff islc
		qui gen double `diff' = `y'-`lc' if `touse'
		qui gen int `islc' = (`diff'<=0) if `touse'
		qui gen double `ynew' = `y'
		qui replace `ynew' = `lc' if (`touse' & `islc'==1)			
	}
	else {
		tempvar diff1 diff2 islc isrc
		qui gen double `diff1' = `y'-`lc' if `touse'
		qui gen int `islc' = (`diff1'<=0) if `touse'	
		qui gen double `diff2' = `rc'-`y' if `touse'
		qui gen int `isrc' = (`diff2'<=0) if `touse'	
		qui gen double `ynew' = `y'
		qui replace `ynew' = `lc' if (`touse' & `islc'==1)
		qui replace `ynew' = `rc' if (`touse' & `isrc'==1)		
	}
			
/* score */	
	if ("`scores'"!="") {
		tempvar scorevar
		if ("`offset'"!="") {
			local offabr "nooff nooffs nooffse nooffset "
			local check: list offabr & rest
			di as err "option {bf:`check'} not allowed"
			exit 198
		}
		else {
			qui gen double `scorevar' = .
			mata: _cpoisson_p( `modelnum', `"`touse'"', 	     ///
				st_matrix("`b'"), `"`ynew'"', `"`xvars'"',   ///
				`"`scorevar'"', `"`lc'"', `"`rc'"',          ///
				`isllnumvar', `isulnumvar', 		     ///
				`"`eoff'"', `"`exposure'"', `addcons', 	     ///
				"score", "", "", "", 0, 0, st_matrix("`V'"))
			gen `typlist' `varlist' = `scorevar'
			label var `varlist' "Equation-level score from cpoisson"
		}	
		exit	
	}
		
/* ir */
	if ("`ir'"!="") {
		tempvar irvar	
		qui gen double `irvar' = .
		mata: _cpoisson_p( `modelnum', `"`touse'"', 		     ///
			st_matrix("`b'"), `"`ynew'"', `"`xvars'"', 	     ///
			`"`irvar'"', `"`lc'"', `"`rc'"', 	  	     ///
			`isllnumvar', `isulnumvar', 			     ///
			`"`eoff'"', `"`exposure'"', `addcons', 		     ///
			"ir", "`offset'", "", "", 0, 0, st_matrix("`V'"))	
		gen `typlist' `varlist' = `irvar'	
		label var `varlist' "Predicted incidence rate"
		exit
	}
	
/* cm */	
	if ("`cm'"!="") {
		tempvar cmvar		
		qui gen double `cmvar' = .
		mata: _cpoisson_p( `modelnum', `"`touse'"', 		     ///
			st_matrix("`b'"), `"`ynew'"', `"`xvars'"',	     ///
			`"`cmvar'"', `"`lc'"', `"`rc'"', 		     ///
			`isllnumvar', `isulnumvar', 			     ///
			`"`eoff'"', `"`exposure'"', `addcons', 		     ///
			"cm", "`offset'", "", "", 0, 0, st_matrix("`V'"))	
		gen `typlist' `varlist' = `cmvar'	
		if (`modelnum'==1) {	
			label var `varlist' "Conditional mean"
		}
		else if (`modelnum'==2 | `modelnum'==3) {
			label var `varlist' "Conditional mean of n<ul(`rc')"
		}
		else if (`modelnum'==4 | `modelnum'==7) {
			label var `varlist' "Conditional mean of n>ll(`lc')"
		}
		else if (`modelnum'==5 | `modelnum'==6 			     ///
			| `modelnum'==8 | `modelnum'==9) {
			label var `varlist' 				     ///
				"Conditional mean of ll(`lc')<n<ul(`rc')"
		}
		exit
	}
	
/* pr or cpr */	
	if (`"`pr'"'!="") +  (`"`cpr'"'!="")  > 1 {
		di as err "may not specify both option {bf:pr()} " 	     ///
			"and option {bf:cpr()} "
		exit 198
	}
	local tvar  ""
	if (`"`pr'"'!="") {
		local tvar `"`pr'"'
		local opt "pr"
	}
	else if (`"`cpr'"'!="") {
		local tvar `"`cpr'"'
		local opt "cpr"
	}
	
	if(`"`tvar'"'!="") {	
		gettoken lower tvar: tvar, parse(", ")					
		if (`"`tvar'"'=="") {  	
/* only one argument detected */
			qui cap confirm number `lower'
			if _rc {	
				// lower is not a number 
				qui cap confirm numeric variable `lower'
				if _rc {	
					// not a numeric variable
					qui cap confirm string variable `lower'
					if !_rc {							
						tempvar cond 		
						qui gen `cond' = (`lower'!=".")
						qui sum `cond'	 	     ///
							if `touse', meanonly
						if (r(max)>0) {	
							di as err "option "  ///
							"{bf:`opt'()} must"  ///
							" contain a number"  ///
							" or numeric variable"
							exit 198
						}
					}
					else {								
						if (`"`lower'"'!=".") {	
							di as err "option "  ///
							"{bf:`opt'()} must"  ///
							" contain a number"  ///
							" or numeric variable"
							exit 198
						}
						else {				
							local islowervar = 0
						}						
					}

				}
				else {	
					// lower is a numeric variable 
					local islowervar = 1	
					// all values must be nonnegative								
					qui sum `lower' if `touse', meanonly
					if (r(min)<0) {
						di as err "option " 	     ///
						"{bf:`opt'()}"     	     ///
						" must contain "	     ///
						"nonnegative integers"
						exit 198
					}
					// all values must be integer
					tempvar dfloor nonint
					qui gen double `dfloor'  	     ///
						= `lower'-int(`lower')       ///
						if `touse'
					qui gen int `nonint'=1 		     ///
						if `dfloor'!=0 &`touse'	
					qui sum `nonint' if `touse', meanonly
					local m = r(sum)
					if (`m'>0) {
						local s
						if `m' > 1 {
							local s s
						}
di as smcl as err "option {bf:`opt'()} invalid"
di as smcl as err "{p 4 4 2}"						
di as smcl as err "Option {bf:`opt'()} contains `m' noninteger value`s'."
di as smcl as err "Option {bf:`opt'()} must contain nonnegative integers."
di as smcl as err "{p_end}"
exit 198
					}			
				}
			}
			else {	
				//lower is a number 
				local islowervar = 0				
				if (`lower'<0) {
					di as err "option {bf:`opt'()} "     ///
					"must contain nonnegative integers" 
					exit 198
				}							
				cap confirm integer number `lower'
				if _rc {
					di as err "option {bf:`opt'()} "     ///
					"must contain nonnegative integers"
					exit 198				
				}
			}
			
/* all values must be in the non-censored range for cpr*/
			if ("`opt'"=="cpr") {
				if (`modelnum'==2 | `modelnum'==3) {
					// lower must be less than rc if rc is 
					// not missing
					tempvar diff isc 				
					qui gen double `diff'=`lower'-`rc'   ///
						if `touse'&`rc'!=.						
					qui gen int `isc'=1 if `diff'>=0     ///
						& `touse'&`rc'!=.
					qui sum `isc' 			     ///
						if `touse'&`rc'!=., meanonly			
					local m = r(sum)
					if (`m'>0) {
						local s
						if `m' > 1 {
							local s s
						}
						if (`islowervar'==1) {
di as smcl as err "option {bf:`opt'(`lower')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower')} contains `m' value`s' "        ///
	"greater than or equal to the right censoring point {bf:`rc'}."
di as smcl as err "{p_end}"
	
						}
						else if (`islowervar'==0) {
di as smcl as err "option {bf:`opt'(`lower')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower')} contains a value "	     ///
	"greater than or equal to the right censoring point {bf:`rc'}."
di as smcl as err "{p_end}"							
						}
						exit 198	
					}
					drop `diff' `isc'
				}	
				else if (`modelnum'==4|`modelnum'==7) {			
					// lower must be greater than lc 
					// if lc is not missing
					tempvar diff isc 
					qui gen double `diff'=`lower'-`lc'   ///
						if `touse' & `lc'!=.					
					qui gen int `isc'=1 if `diff'<=0     ///
						& `touse' & `lc'!=.							
					qui sum `isc' 			     ///
						if `touse' & `lc'!=., meanonly
					local m = r(sum)					
					if (`m'>0) {
						local s
						if `m' > 1 {
							local s s
						}
						if (`islowervar'==1) {
di as smcl as err "option {bf:`opt'(`lower')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower')} contains `m' value`s' " 	     ///
	"less than or equal to the left censoring point {bf:`lc'}."
di as smcl as err "{p_end}"		
						}
						else if (`islowervar'==0) {
di as smcl as err "option {bf:`opt'(`lower')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower')} contains a value "	     ///
	"less than or equal to the left censoring point {bf:`lc'}."	
di as smcl as err "{p_end}"						
						}
						exit 198	
					}	
					drop `diff' `isc'
				}	
				else if (`modelnum'==5 |`modelnum'==6 	     ///
					|`modelnum'==8 |`modelnum'==9) {
					// lower must be greater than lc 
					// if lc is not missing, 
					// and less than rc 
					// if rc is not missing
					tempvar diff1 diff2
					qui gen double `diff1'=`lower'-`lc'  ///
						if `touse'&`lc'!=.
					qui sum `diff1' 		     ///
						if `touse'&`lc'!=., meanonly
					local lcmin = r(min)
					qui gen double `diff2'=`rc'-`lower'  ///
						if `touse'&`rc'!=.
					qui sum `diff2'  		     ///
						if `touse'&`rc'!=., meanonly
					local rcmin = r(min)
					if (`lcmin'<=0 & `rcmin'<=0 ) {
di as smcl as err "option {bf:`opt'(`lower')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower')} contains values less than "    ///
	"or equal to the left censoring point `lc'" 			     ///
	" and values greater than or equal to the right censoring "	     ///
	"point {bf:`rc'}."
di as smcl as err "{p_end}"	
exit 198
					}
					else if (`lcmin'<=0 & `rcmin'>0 ){
di as smcl as err "option {bf:`opt'(`lower')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower')} contains values "		     ///
	"less than or equal to the left censoring point {bf:`lc'}."
di as smcl as err "{p_end}"
exit 198		
					}
					else if (`lcmin'>0 & `rcmin'<=0 ){
di as smcl as err "option {bf:`opt'(`lower')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower')} contains values " 	     ///
	"greater than or equal to the right censoring point {bf:`rc'}."
di as smcl as err "{p_end}"	
exit 198	
					}
					drop `diff1' `diff2'												
				}
			}	
				
			tempvar prcprvar
			if (`lower'==.) {
				local lowerin = "."
			}
			else {
				local lowerin = `"`lower'"'
			}
			local upperin = ""
			qui gen double `prcprvar' = .
			
			mata: _cpoisson_p( `modelnum', `"`touse'"', 	     ///
				st_matrix("`b'"), `"`ynew'"', `"`xvars'"',   ///
				`"`prcprvar'"', `"`lc'"', `"`rc'"', 	     ///
				`isllnumvar', `isulnumvar', 		     ///
				`"`eoff'"', `"`exposure'"', `addcons', 	     ///
				"`opt'", "`offset'", `"`lowerin'"',"", 	     ///
				`islowervar',0, st_matrix("`V'"))
			gen `typlist' `varlist' = `prcprvar'	
			if ("`opt'"=="pr") {
				label var `varlist' "Pr(`y'=`lower')"
			}
			else if ("`opt'"=="cpr") {
				if (`modelnum'==1) {
					local cond ")"
				}
				else if (`modelnum'==2 | `modelnum'==3) {
					local cond "|`y'<`rc')"
				}
				else if (`modelnum'==4 | `modelnum'==7) {
					local cond "|`y'>`lc')"
				}
				else if (`modelnum'==5 |`modelnum'==6 	     ///
					|`modelnum'==8 |`modelnum'==9) {
					local cond "|`lc'<`y'<`rc')"
				}
				label var `varlist' "Pr(`y'=`lower'`cond'"
			}			
		}
		else {	
/* more than one argument detected */
			gettoken comma tvar: tvar, parse(",")
			gettoken upper tvar: tvar, parse(", ")
			local tvar `"`tvar'"'
			local comma `"`comma'"'
			if (`"`tvar'"'!="" | "`comma'"!=",") {
				di as err "option {bf:`opt'} incorrectly "   ///
						"specified"
				exit 198
			}	

/* check lower bound argument */
			qui cap confirm number `lower'
			if _rc {	
				// lower is not a number
				qui cap confirm numeric variable `lower'
				if _rc {
					// not a numeric variable
					qui cap confirm string variable `lower'
					if !_rc {	
						tempvar cond 		
						qui gen `cond' = (`lower'!=".")
						qui sum `cond' 		     ///
							if `touse', meanonly
						if (r(max)>0) {	
							di as err "option "  ///
							"{bf:`opt'()} must"  ///
							" contain numbers"   ///
							" or numeric variables"
							exit 198
						}
					}
					else {					
						if (`"`lower'"'!=".") {	
							di as err "option "  ///
							"{bf:`opt'()} must"  ///
							" contain numbers"   ///
							" or numeric variables"
							exit 198
						}
						else {				
							local islowervar = 0
						}						
					}
				}
				else {	
					// lower is a numeric variable
					local islowervar = 1
					// all values must be nonnegative
					qui sum `lower' if `touse', meanonly
					if r(min) < 0 {
						di as err "option " 	     ///
						"{bf:`opt'()}"     	     ///
						" must contain all "	     ///
						"nonnegative integers"
						exit 198
					}		
					
					// all values must be integer			
					tempvar diff nonint
					qui gen double `diff'  		     ///
						= `lower'-int(`lower') 	     ///
						if `touse'&`lower'!=.
					qui gen int `nonint'=1 	 	     ///
						if `diff'!=0 &`touse'&`lower'!=.
					qui sum `nonint' 		     ///
						if `touse'&`lower'!=., meanonly
					local m = r(sum)
					if (`m'>0) {	
						local s
						if `m' > 1 {
							local s s
						}					
di as smcl as err "option {bf:`opt'()} invalid"
di as smcl as err "{p 4 4 2}"												
di as smcl as err "Option {bf:`opt'()} contains `m' noninteger value`s'."
di as smcl as err "Option {bf:`opt'()} must contain nonnegative integers."	
di as smcl as err "{p_end}"	
exit 198
					}				
				}				
			}
			else {			
				// lower is a number
				local islowervar = 0					
				if (`lower'<0) {
					di as err "option {bf:`opt'()} "     ///
					"must contain nonnegative integers" 
					exit 198
				}							
				cap confirm integer number `lower'
				if _rc {
					di as err "option {bf:`opt'()} "     ///
					"must contain nonnegative integers"
					exit 198				
				}
			}
			
/* check upper bound argument */
			qui cap confirm number `upper'			
			if _rc {
				// upper is not a number
				qui cap confirm numeric variable `upper'
				if _rc {
					// not a numeric variable
					qui cap confirm string variable `upper'
					if !_rc {							
						tempvar cond 		
						qui gen `cond' = (`upper'!=".")
						qui sum `cond' 		     ///
							if `touse', meanonly
						if (r(max)>0) {	
							di as err "option"   ///
							" {bf:`opt'()} must" ///
							" contain numbers"   ///
							" or numeric variables"
							exit 198
						}
					}
					else {									
						if (`"`upper'"'!=".") {	
							di as err "option"   ///
							" {bf:`opt'()} must" ///
							" contain numbers"   ///
							" or numeric variable"
							exit 198
						}
						else {								
							local isuppervar = 0
						}				
					}
				}
				else {		
					// upper is a numeric variable
					local isuppervar = 1	
					// all values must be nonnegative				
					qui sum `upper' if `touse', meanonly
					if r(min) < 0 {
						di as err "option "	     ///
						"{bf:`opt'()} " 	     ///
						"must contain all " 	     ///
						"nonnegative integers"
						exit 198
					}
					// all values must be integer								
					tempvar diff nonint
					qui gen double `diff'  		     ///
						= `upper'-int(`upper') 	     ///
						if `touse'&`upper'!=.
					qui gen int `nonint'=1 		     ///
						if `diff'!=0 &`touse'&`upper'!=.
					qui sum `nonint'		     ///
						if `touse'&`upper'!=., meanonly
					local m = r(sum)
					if (`m'>0) {
						local s
						if `m' > 1 {
							local s s
						}	
di as smcl as err "option {bf:`opt'()} invalid"
di as smcl as err "{p 4 4 2}"												
di as smcl as err "Option {bf:`opt'()} contains `m' noninteger "   	     ///
	"value`s' in the upper bound variable {bf:`upper'}."
di as smcl as err "{p_end}"	
exit 198								
					}								
				}					
			}			
			else {	
				// upper is a number
				local isuppervar = 0				
				if (`upper'<0) {
					di as err "option {bf:`opt'()} "     ///
						"must contain"               ///
						" nonnegative integers" 
					exit 198
				}								
				cap confirm integer number `upper'
				if _rc {
					di as err "option {bf:`opt'()} "     ///
					"must contain nonnegative integers"
					exit 198				
				}					
			}

/* Non-missing values in lower bound argument
 must be in the non-censored range for cpr() */
			if ("`opt'"=="cpr") {			
				if (`modelnum'==2 | `modelnum'==3) {
					// lower must be less than rc 
					// if rc is not missing
					tempvar diff isc 
					qui gen double `diff'=`lower'-`rc'   ///
						if `touse'&`rc'!=.&`lower'!=.
					qui gen int `isc'=1 if `diff'>=0     ///
						& `touse'&`rc'!=.&`lower'!=.
					qui sum `isc' if `touse' 	     ///
						&`rc'!=.&`lower'!=. 	     ///
						, meanonly
					local m = r(sum)
					if (`m'>0) {
						local s
						if `m' > 1 {
							local s s
						}
						if (`islowervar'==1) {
di as smcl as err "option {bf:`opt'(`lower', `upper')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower', `upper')} contains `m' "        ///
	"value`s' greater than or equal to the right censoring "             ///
	"point {bf:`rc'} in the first argument."
di as smcl as err "{p_end}"	
						}
						else if (`islowervar'==0) {
di as smcl as err "option {bf:`opt'(`lower', `upper')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower', `upper')} contains a value "    ///
	"greater than or equal to the right censoring point {bf:`rc'}"	     ///
	" in the first argument."		
di as smcl as err "{p_end}"						
						}
						exit 198	
					}
					drop `diff' `isc'
				}
				else if (`modelnum'==4|`modelnum'==7) {		
					// lower must be greater than lc 
					// if lc is not missing
					tempvar diff isc 
					qui gen double `diff'=`lower'-`lc'   ///
						if `touse'&`lc'!=.&`lower'!=.
					qui gen int `isc'=1 if `diff'<=0     ///
						& `touse'&`lc'!=.&`lower'!=.
					qui sum `isc' if `touse' 	     ///
						&`lc'!=.&`lower'!=. 	     ///
						, meanonly
					local m = r(sum)
					if (`m'>0) {
						local s
						if `m' > 1 {
							local s s
						}
						if (`islowervar'==1) {
di as smcl as err "option {bf:`opt'(`lower', `upper')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower', `upper')} contains `m' " 	     ///
	"value`s' less than or equal to the left censoring point {bf:`lc'}"  ///
	" in the first argument."
di as smcl as err "{p_end}"	
						}
						else if (`islowervar'==0) {
di as smcl as err "option {bf:`opt'(`lower', `upper')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower', `upper')} contains a value "    ///
	"less than or equal to the left censoring point {bf:`lc'}" 	     ///
	" in the first argument."	
di as smcl as err "{p_end}"						
						}
						exit 198	
					}
					drop `diff' `isc'						
				}
				else if (`modelnum'==5 |`modelnum'==6 	     ///
					|`modelnum'==8 |`modelnum'==9) {
					// lower must be greater than lc 
					// if lc is not	missing, 
					// and less than rc 
					// if rc is not missing
					tempvar diff1 diff2
					qui gen double `diff1'=`lower'-`lc'  ///
						if `touse'&`lc'!=.&`lower'!=.
					qui sum `diff1' if `touse' 	     ///
						&`lc'!=.&`lower'!=. 	     ///
						, meanonly
					local lcmin = r(min)
					qui gen double `diff2'=`rc'-`lower'  ///
						if `touse'&`rc'!=.&`lower'!=.
					qui sum `diff2' if `touse'           ///
						&`rc'!=.&`lower'!=. 	     ///
						, meanonly
					local rcmin = r(min)
					if (`lcmin'<=0 & `rcmin'<=0 ) {
di as smcl as err "option {bf:`opt'(`lower', `upper')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower', `upper')} "                     ///
	"contains values less than "   					     ///
	"or equal to the left censoring point {bf:`lc'} "		     ///
	"and values greater than or equal to the right censoring point"	     ///
        " {bf:`rc'} in the first argument."	
di as smcl as err "{p_end}"	
exit 198					
					}
					else if (`lcmin'<=0 & `rcmin'>0) {
di as smcl as err "option {bf:`opt'(`lower', `upper')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower', `upper')} contains values "     ///
	"less than or equal to the left censoring point {bf:`lc'}" 	     ///
	" in the first argument."
di as smcl as err "{p_end}"		
exit 198								
					}
					else if (`lcmin'>0 & `rcmin'<=0) {
di as smcl as err "option {bf:`opt'(`lower', `upper')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower', `upper')} contains values "     ///
	"greater than or equal to the right censoring point {bf:`rc'}" 	     ///
	" in the first argument."
di as smcl as err "{p_end}"	
exit 198							
					}
					drop `diff1' `diff2'												
				}	
			}
			
/* Non-missing values in upper bound argument
 must be in the non-censored range for cpr() */	
			if ("`opt'"=="cpr") {
				if (`modelnum'==2 | `modelnum'==3) {		
					// upper must be less than rc 
					// if rc is not missing
					tempvar diff isc 
					qui gen double `diff'=`upper'-`rc'   ///
						if `touse'&`rc'!=.&`upper'!=.
					qui gen int `isc'=1 if `diff'>=0     ///
						& `touse'&`rc'!=.&`upper'!=.
					qui sum `isc' if `touse' 	     ///
						&`rc'!=.&`upper'!=. 	     ///
						, meanonly
					local m = r(sum)
					if (`m'>0) {
						local s
						if `m' > 1 {
							local s s
						}
						if (`isuppervar'==1) {
di as smcl as err "option {bf:`opt'(`lower', `upper')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower', `upper')} contains `m' "        ///
	"value`s' greater than or equal to the right censoring point "	     ///
	"{bf:`rc'} in the second argument."
di as smcl as err "{p_end}"	
						}
						else if (`isuppervar'==0) {
di as smcl as err "option {bf:`opt'(`lower', `upper')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower', `upper')} contains a value "    ///
	"greater than or equal to the right censoring point {bf:`rc'}"	     ///
	" in the second argument."
di as smcl as err "{p_end}"		
						}
						exit 198	
					}
					drop `diff' `isc'
				}
				else if (`modelnum'==4|`modelnum'==7) {		
					// upper must be greater than lc 
					// if lc is not missing
					tempvar diff isc 
					qui gen double `diff'=`upper'-`lc'   ///
						if `touse'&`lc'!=.&`upper'!=.
					qui gen int `isc'=1 if `diff'<=0     ///
						& `touse'&`lc'!=.&`upper'!=.
					qui sum `isc' if `touse' 	     ///
						&`lc'!=.&`upper'!=. 	     ///
						, meanonly
					local m = r(sum)
					if (`m'>0) {
						local s
						if `m' > 1 {
							local s s
						}
						if (`isuppervar'==1) {
di as smcl as err "option {bf:`opt'(`lower', `upper')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower', `upper')} contains `m' " 	     ///
	"value`s' less than or equal to the left censoring point {bf:`lc'}"  ///
	" in the second argument."	
di as smcl as err "{p_end}"
						}
						else if (`isuppervar'==0) {
di as smcl as err "option {bf:`opt'(`lower', `upper')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower', `upper')} contains a value "    ///
	"less than or equal to the left censoring point {bf:`lc'}"	     ///
	" in the second argument."	
di as smcl as err "{p_end}"
						}
						exit 198	
					}
					drop `diff' `isc'
				}
				else if (`modelnum'==5 |`modelnum'==6 	     ///
					|`modelnum'==8 |`modelnum'==9) {
					// upper must be greater than lc 
					// if lc is not missing, 
					// and less than rc 
					// if rc is not missing
					tempvar diff1 diff2
					qui gen double `diff1'=`upper'-`lc'  ///
						if `touse'&`lc'!=.&`upper'!=.
					qui sum `diff1' if `touse' 	     ///
						&`lc'!=.&`upper'!=. 	     ///
						, meanonly
					local lcmin = r(min)
					qui gen double `diff2'=`rc'-`upper'  ///
						if `touse'&`rc'!=.&`upper'!=.
					qui sum `diff2' if `touse'           ///
						&`rc'!=.&`upper'!=.          ///
						, meanonly
					local rcmin = r(min)
					if (`lcmin'<=0 & `rcmin'<=0 ) {
di as smcl as err "option {bf:`opt'(`lower', `upper')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower', `upper')} contains values"      ///
	" less than or equal to the left censoring point {bf:`lc'} "	     ///
	"and values greater than or equal to the right censoring point"	     ///
        " {bf:`rc'} in the second argument."	
di as smcl as err "{p_end}"	
exit 198							
					}
					else if (`lcmin'<=0 & `rcmin'>0 ){
di as smcl as err "option {bf:`opt'(`lower', `upper')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower', `upper')} contains values "     ///
	"less than or equal to the left censoring point {bf:`lc'}" 	     ///
	" in the second argument."
di as smcl as err "{p_end}"	
exit 198				
					}
					else if (`lcmin'>0 & `rcmin'<=0 ){
di as smcl as err "option {bf:`opt'(`lower', `upper')} invalid"
di as smcl as err "{p 4 4 2}"
di as smcl as err "Option {bf:`opt'(`lower', `upper')} contains values "     ///
	"greater than or equal to the right censoring point {bf:`rc'}" 	     ///
	" in the second argument."
di as smcl as err "{p_end}"
exit 198		
					}
					drop `diff1' `diff2'												
				}	
			}		
		
/* check if lower < upper */
			tempvar isless
			qui gen int `isless' = (`lower' > `upper') 	     ///
				if `touse' & `upper'!=. & `lower'!=. 
			qui su `isless' if `touse' & `upper'!=.              ///
					& `lower'!=. , meanonly 			
			local m = r(sum)
			if (`m'>0) {
				di in blu "note: "    			     ///
					"{bf:`lower'} is greater" 	     ///
					" than {bf:`upper'} "   	     ///
					"for some observations"
			}
			
/* compute pr(a,b) or cpr(a,b) */			
			tempvar prcprvar
			qui gen double `prcprvar' = .				
			if (`lower'==.) {
				local lowerin = "."
			}
			else {
				local lowerin = `"`lower'"'
			}
			if (`upper'==.) {
				local upperin = "."				
			}
			else {
				local upperin = `"`upper'"'
			}					

			mata: _cpoisson_p( `modelnum', `"`touse'"', 	     ///
				st_matrix("`b'"), `"`ynew'"', `"`xvars'"',   ///
				`"`prcprvar'"', `"`lc'"', `"`rc'"', 	     ///
				`isllnumvar', `isulnumvar', 	  	     ///
				`"`eoff'"', `"`exposure'"', `addcons', 	     ///
				"`opt'", "`offset'", `"`lowerin'"', 	     ///
				`"`upperin'"', `islowervar', `isuppervar',   ///
				st_matrix("`V'"))					
			gen `typlist' `varlist' = `prcprvar'	
			
			if ("`opt'"=="pr") {
				label var `varlist' "Pr(`lower'<=`y'<=`upper')"
			}
			else if ("`opt'"=="cpr") {
				if (`modelnum'==1) {
					local cond ")"
				}
				else if (`modelnum'==2 | `modelnum'==3) {
					local cond "|`y'<`rc')"
				}
				else if (`modelnum'==4 | `modelnum'==7) {
					local cond "|`y'>`lc')"
				}
				else if (`modelnum'==5 |`modelnum'==6 	     ///
					|`modelnum'==8 |`modelnum'==9) {
					local cond "|`lc'<`y'<`rc')"
				}
				label var `varlist' 			     ///
					"Pr(`lower'<=`y'<=`upper'`cond'"				
			}
		}		
	}

/* xb */	
	if ("`xb'"!="") {
		tempvar xbvar
		qui gen double `xbvar' = .
		mata: _cpoisson_p( `modelnum', `"`touse'"', 		     ///
			st_matrix("`b'"), `"`ynew'"', `"`xvars'"', 	     ///
			`"`xbvar'"', `"`lc'"', `"`rc'"', 		     ///
			`isllnumvar', `isulnumvar', 			     ///
			`"`eoff'"', `"`exposure'"', `addcons', 		     ///
			"xb", "`offset'", "", "", 0, 0, st_matrix("`V'"))	
		gen `typlist' `varlist' = `xbvar'	
		label var `varlist' "Linear prediction"
		exit					
	}

/* stdp */
	if ("`stdp'"!="") {
		tempvar stdpvar
		qui gen double `stdpvar' = .
		mata: _cpoisson_p( `modelnum', `"`touse'"', 		     ///
			st_matrix("`b'"), `"`ynew'"', `"`xvars'"', 	     ///
			`"`stdpvar'"', `"`lc'"', `"`rc'"', 		     ///
			`isllnumvar', `isulnumvar', 			     ///
			`"`eoff'"', `"`exposure'"', `addcons', 		     ///
			"stdp", "`offset'", "", "", 0, 0, st_matrix("`V'"))	
		gen `typlist' `varlist' = `stdpvar'	
		label var `varlist' "S.E. of the prediction"
		exit					
	}

/* number of events (default) */	
	local type "`score'`n'`ir'`cm'`pr'`cpr'`xb'`stdp'"
	if ("`type'"=="" | "`type'"=="n" | `"`n'"'!="") {
		tempvar nvar 
		if "`type'"=="" {
			di in txt 				   	     ///
				"(option {bf:n} assumed;"                    ///
				" predicted number of events)"
		}		
		qui gen double `nvar' = .
		mata: _cpoisson_p( `modelnum', `"`touse'"', 		     ///
			st_matrix("`b'"), `"`ynew'"', `"`xvars'"', 	     ///
			`"`nvar'"', `"`lc'"', `"`rc'"', 	   	     ///
			`isllnumvar', `isulnumvar', 			     ///
			`"`eoff'"', `"`exposure'"', `addcons', 		     ///
			"n", "`offset'", "", "", 0, 0, st_matrix("`V'"))	
		gen `typlist' `varlist' = `nvar'	
		label var `varlist' "Predicted number of events"
		exit
	}		
	
end

