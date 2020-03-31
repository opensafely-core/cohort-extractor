*! version 1.0.3  13feb2015
program _mgarch_p_names, sclass
	version 11
	syntax [anything(name=vlist)] 				///
		, 						///
		suffix(varlist ts)				///
		stat(string)					///
		[ EQuation(string) ]
	
	// check syntax
	if `"`vlist'"' == "" {
		local 0
		syntax newvarlist
		exit 100	// [sic]
	}
	
	local 0 ", `stat'"
	syntax , [ xb Residuals Variance Correlation ]
	opts_exclusive "`xb' `residuals' `variance'`correlation'"
	local stat "`xb'`residuals'`variance'`correlation'"
	
	local nvars : word count `suffix'
	if "`stat'"=="variance"| "`stat'"=="correlation" {
		local nvars = .5*`nvars'*(`nvars'+1)
		local vech 1
	}
	else local vech 0
	
	if index(`"`vlist'"',"*") {
		local stub 1
	}
	else local stub 0
	
	local userlist 0
	
	if `stub' & `"`equation'"' != "" {
		di "{err}equation() may not be specified with stub* syntax"
		exit 198
	}
	
	// parse vlist
	if (`stub') {
		
		// allow: [<vartype>] <stub>*
		//        [<vartype>] (<stub>*)
		gettoken first vlist : vlist, match(par) bind
		if index(`"`first'"',"*") {
			if ("`vlist'"!="") error 103

			local type `c(type)'
			local vlist `first'
		}
		else {
			tempvar newvar
			local 0 `first' `newvar'
			syntax newvarname
			local type `typlist'
		}
		gettoken vlist rest : vlist, match(par) bind
		if (`"`rest'"'!="" | `:word count `vlist''!=1) error 103

		if index("`vlist'","*") != `:length local vlist' {
			di as err "{it:stub}{bf:*} incorrectly specified"
			exit 198
		}
		local vlist = bsubstr("`vlist'",1,length("`vlist'")-1)
		// turn <stub>* into `varlist' (<stub>1 <stub>2 ...)
		local newvarlist
		local typlist
		
		if (`vech') {
			local neq : word count `suffix'
			forvalues i = 1/`neq' {
				local w1 : word `i' of `suffix'
				local L1 : subinstr local w1 "." "_"
				forvalues j = `i'/`neq' {
					local w2 : word `j' of `suffix'
					local L2 : subinstr local w2 "." "_"
					local newvarlist `newvarlist' `vlist'_`L2'_`L1'
					local typlist `typlist' `type'
					local lablist `lablist' (`w2',`w1')
				}
			}
		}
		else {
			local neq : word count `suffix'
			forvalues i = 1/`neq' {
				local w1 : word `i' of `suffix'
				local L1 : subinstr local w1 "." "_"
				local newvarlist `newvarlist' `vlist'_`L1'
				local typlist `typlist' `type'
				local lablist `lablist' (`w1')
			}
		}
		
		confirm new var `newvarlist'
	}
	else {
		
		// generate `typlist' and `varlist'
		local 0 `"`vlist'"'
		syntax newvarlist
		
		local newvarlist `varlist'
		local kvars : word count `newvarlist'
		if `kvars'>1 local userlist 1
		
		if (`vech') {
			
			if (`userlist') {
				local check : word count `suffix'
				local check = .5*`check'*(`check'+1)
				if `kvars'!=`check' {
					di "{err}incorrect number of "	///
						"variables in {it:newvarlist}"
					exit 198
				}
			}
			
			local neq : word count `suffix'
			local k 1
			forvalues i = 1/`neq' {
				
				local w1 : word `i' of `suffix'
				
				forvalues j = `i'/`neq' {
					
					local newvar : word `k' of `newvarlist'
					
					local w2 : word `j' of `suffix'
					
					local tmplist `tmplist' `newvar'
					local typlist `typlist' `type'
					local lablist `lablist' (`w2',`w1')
					local ++k
				}
			}
			local newvarlist `tmplist'
		}
		else {
			
			if (`userlist') {
				local check : word count `suffix'
				if `kvars'!=`check' {
					di "{err}incorrect number of "	///
						"variables in {it:newvarlist}"
					exit 198
				}
			}
			
			forvalues i = 1/`kvars' {
				local name : word `i' of `suffix'
				local lablist `lablist' (`name')
			}
		}
	}
	
	local nnew : word count `newvarlist'
	
	// parse equation option
	
	if `"`equation'"' != "" {
		local 0 `equation'
		syntax anything(name=first) [, *]
		
		_parse_eq_option `first', `options' stat(`stat')
		
		local ix1 `r(ix1)'
		local ix2 `r(ix2)'
		local label1 `r(label1)'
		local label2 `r(label2)'
		
		if "`label2'"=="" {
			local lablist (`label1')
		}
		else local lablist (`label1',`label2')
	}
	else {
		local ix1 1
		local label1 : word 1 of `e(depvar)'
		if `nnew'==1 local lablist (`label1')
		if "`stat'" == "variance" | "`stat'"=="correlation" {
			local ix2 `ix1'
			if `nnew'==1 local lablist (`label1',`label1')
		}
	}
	
	if `nnew'==1 & !inlist("`stat'","variance","correlation") {
		local suffix : word `ix1' of `suffix'
	}
	
	if (`stub' | `userlist') {
		local ix1
		local ix2
	}
	
	sreturn clear
	sreturn local ix2	 `ix2'
	sreturn local ix1	 `ix1'
	sreturn local depvars	 `suffix'
	sreturn local lablist	 `lablist'
	sreturn local newvarlist `newvarlist'
	sreturn local typlist	 `typlist'
	sreturn local stub	 `stub'
end

program define _parse_eq_option, rclass

	syntax anything(name=first) [ , stat(string) * ]
	
	local depvars `e(depvar)'
	
	gettoken pound : first, parse("#")
	if "`pound'" == "#" {
		di "{cmd:equation(#}{it:i}{cmd:)} {err}syntax not allowed"
		exit 498
	}
	
	local cnt : word count `first'
	if `cnt' > 1 {
		di "{cmd:equation(`equation')} {err}invalid"
		exit 498
	}
	
	local ix1 : list posof "`first'" in depvars
	
	if `ix1'==0 {
		di "{inp}`first' {err}is not a valid equation name"
		exit 498
	}
	
	local second = "`options'"
	
	if "`second'"=="" & inlist("`stat'","variance","correlation") {
		local second `first'
	}
	
	if "`second'"!="" & !inlist("`stat'","variance","correlation") {
		di "{inp}`stat' {err}requires one equation name in {inp}equation()"
		exit 498
	}
	
	if "`second'"!="" {
		gettoken pound : second, parse("#")
		if "`pound'" == "#" {
			di "{cmd:equation(#}{it:i}{cmd:)} {err}syntax not allowed"
			exit 498
		}
	
		local cnt : word count `second'
		if `cnt' > 1 {
			di "{cmd:equation(`second')} {err}invalid"
			exit 498
		}
		
		local ix2 : list posof "`second'" in depvars
	
		if `ix2'==0 {
			di "{inp}`second' {err}is not a valid equation name"
			exit 498
		}
	}
	
	return local ix1 `ix1'
	return local ix2 `ix2'
	return local label1 "`first'"
	return local label2 "`second'"	
end

exit
