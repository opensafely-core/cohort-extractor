*! version 2.0.1  09feb2015
program _qsort_index, rclass sort
	version 8

	if `"`0'"' == "" {
		exit
	}
	
// parse command line on "\" into list1 list2 (quotes strings) etc,
// and on options.  A list "*" is translated into 1..n
//
//   m := number of lists
//   n := length of lists

	local m = 1
	gettoken tok : 0, parse(" ,\")
	while !inlist(`"`tok'"', "", ",") {
		gettoken tok 0 : 0, parse(" ,\")
		
		if `"`tok'"' == "*" & `"`list`m''"' == "" {
			if `m' == 1 {
				dis as err /// 
				    "shorthand * not allowed as first list"
				exit 198
			}
			numlist `"1/`:list sizeof list1'"'
			local list`m' `r(numlist)'
		}
		else if `"`tok'"' == "\" {
			local ++m
		}
		else  {
			local list`m' `list`m'' `tok'
		}
		
		gettoken tok : 0, parse(" ,\")
	}

	local n : list sizeof list1
	forvalues i = 2/`m' {
		if `n' != `:list sizeof list`i'' {
			dis as err /// 
			    "number of words in lists 1 and `i' differ"
			exit 198
		}
	}

	syntax [, Ascending Descending ALpha DIsplay ]

	if "`ascending'"!="" & "`descending'"!="" {
		opts_exclusive "ascending descending"
	}
	
	if `n' == 0 { 
		return clear
		exit 0
	}
	
	if `n' > c(N) { 
		preserve
		quietly set obs `n' 
	}
	
	tempvar x keyvar 
	quietly gen `c(obs_t)' `keyvar' = _n

	tokenize `"`list1'"'
	if "`alpha'" == "" { 
		quietly gen `x' = . 
		forvalues i = 1/`n' { 
			quietly replace `x' = ``i'' in `i' 
		}
		if "`descending'" != "" {
			quietly replace `x' = - `x' in 1/`n' 
		}
	}	
	else { 
		quietly gen `x' = ""
		forvalues i = 1/`n' { 
			quietly replace `x' = `"``i''"' in `i' 
		}
	}
	
// stable sorting of x

	sort `x' in 1/`n', stable
	
// store permutation in macros
	
	if ("`descending'" != "") & ("`alpha'" != "") { 
		// note: ties are not properly handled
		forvalues i = 1/`n' { 
			local key`i' = `keyvar'[`n'+1-`i']
		}	
	}
	else {
		forvalues i = 1/`n' { 
			local key`i' = `keyvar'[`i']
		}
	}
	
	local order 
	forvalues i = 1/`n' { 
		local order `order' `key`i''
	}
	
	return local order `order'

// apply sort ordering to the m lists
// returning results in slist1, slist2, .. etc

	forvalues j = 1/`m' {
		local list
		if `j' > 1 {
			tokenize `"`list`j''"'
		}
		forvalues i = 1/`n' {
			local list `list' ``key`i'''
		}
		
		return local slist`j' `list'
		
		if "`display'" != "" {
			dis as txt "{p 0 4 2}" /// 
			    `"`j': `list`j'' {hline 2}> `list'{p_end}"'
		}
	}
end
exit
