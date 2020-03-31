*! version 2.2.5  08oct2008
program define tab2, byable(recall)
	version 6, missing
	syntax varlist(min=2) [if] [in] [fweight] [, FIRSTonly *]
	tempvar touse
	mark `touse' `if' `in' [`weight'`exp']
	local weight "[`weight'`exp']"
	capture { 
		tokenize `varlist'
		local stop : word count `varlist'
		local i 1
		while `i' <= `stop' {
			local L "``i''"
			mac shift
			local varlist "`*'"
			local stop : word count `varlist'
			local j 1
			while `j' <= `stop' {		
				#delimit ;
				noisily di _n 
				  `"-> tabulation of `L' by ``j'' `if' `in'"' ;
				cap noisily tab `L' ``j'' 
				  if `touse' `weight' , `options' ;
				#delimit cr
				if _rc!=0 & _rc!=1001 { exit _rc }
				local j = `j' + 1
			}
			if "`firstonly'" ~= "" { exit _rc }
			tokenize `varlist'
		}
	}
	error _rc 
end
