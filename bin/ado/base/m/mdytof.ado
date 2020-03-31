*! version 2.1.0  02/27/93
program define mdytof
	version 3.1
	local varlist "req ex min(3) max(3)"
	local if "opt"
	local in "opt"
	local options "Generate(string)"
	parse "`*'"
	if "`generat'"=="" { error 198 }
	conf new var `generat'
	parse "`varlist'", parse(" ")
	tempvar g touse good
	quietly {
		gen long `g' = (`3'-1900)*10000 + `1'*100 + `2' `if' `in'
		gen byte `touse' = 1 `if' `in'
	}
	gen byte `good'=1 if `touse'==1 & `1'>=1 & `1'<=12 & /*
			*/ `2'>=1 & `2'<=31 & `3'>=1901 & `3'<=1999
	quietly replace `g' = . if `good'!=1
	rename `g' `generat'
end
