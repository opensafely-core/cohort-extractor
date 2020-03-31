*! version 1.0.4  01apr2005
program define _mka2, 
	version 8.0
	syntax varlist , lags(integer) aname(string) b_ts(string) /*
		*/ [cons ] 

	tempname row b

	if "`e(cmd)'" != "var" & "`e(cmd)'" != "svar" {
		di as err "_mka2 only works with estimates from "	/*
			*/ "{help var##|_new:var} and {help svar##|_new:svar}"
		exit 198
	}

	if "`e(cmd)'" == "svar" {
		local svar _var 
	}

	mat `b'=`b_ts'

	local eqlist "`e(eqnames`svar')'"
	local i 1
	if "`cons'" != "" {
		foreach var of local eqlist {
			if `i' == 1 {
				matrix `aname'cons=  `b'[1,"`var':_cons"]
			}
			else {
				matrix `aname'cons= `aname'cons \ /*
					*/ `b'[1,"`var':_cons"]
			}
			local i =`i' + 1	
		}
	}

	forvalues i=1(1)`lags' {
		
		local firstrow "yes"
		foreach var of local eqlist {
			capture matrix drop `row'
			local first "yes"
			foreach var2 of local varlist {
				if "`first'" == "yes" {
					matrix `row' = /*
						*/ `b'[1,"`var': L`i'.`var2'"]
					local first ""	
				}
				else {
					matrix `row' = `row',/*
						*/ `b'[1,"`var': L`i'.`var2'"]

				}
			}
			if "`firstrow'" == "yes" {
				matrix `aname'`i'=`row'
				local firstrow ""
			}
			else {
				matrix `aname'`i'=`aname'`i' \ `row'
			}	
	
		}
		matrix rownames `aname'`i' = `varlist'
		matrix coleq `aname'`i' = _: 
	}
end
