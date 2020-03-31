*! version 2.1.0  02/27/93
program define mdytoe
	version 3.1
	local varlist "req ex min(3) max(3)"
	local if "opt"
	local in "opt"
	local options "Generate(string)"
	parse "`*'"
	if "`generat'"=="" { error 198 }
	conf new var `generat'
	local Exp "int(((`1')-14)/12)"
	parse "`varlist'", parse(" ")
	tempvar g touse good
	quiet { 
		#delimit ;
		gen long `g' =
			(`2') - 2469010 + int(1461*((`3')+4800+`Exp')/4)
			+ int(367*((`1')-2-`Exp'*12)/12)
			- int(3*int(((`3')+4900+`Exp')/100)/4) `if' `in';
		gen byte `touse'=1 `if' `in';
		#delimit cr
	}
	gen byte `good'=1 if `touse'==1 & `1'>=1 & `1'<=12 & /*
			*/ `2'>=1 & `2'<=31 & `3'>=1 & `3'!=. 
	quietly replace `g'=. if `good'!=1
	capture assert `3'>99 if `good'==1
	if _rc { 
		di in blu /* 
*/ "(warning:  `3'<100 taken as early christian era, not 20th century)"
	}
	rename `g' `generat'
end
