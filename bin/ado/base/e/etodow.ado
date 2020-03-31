*! version 2.1.0  03/27/93
program define etodow
	version 3.1
	local varlist "req ex max(1)"
	local if "opt"
	local in "opt"
	local options "Generate(string)"
	parse "`*'"
	parse "`generat'", parse(" ")
	if "`1'"=="" | "`2'"~="" { etodow }
	conf new var `generat'
	tempvar gen
	#delimit ;
	gen int `gen' = cond((`varlist')+5==0,0,
			cond((`varlist')>=0,mod((`varlist')+5,7),
			6-mod(abs(`varlist')+8,7)))
			`if' `in' ;
	capture label define Dayslab 
		0 "Sun." 1 "Mon." 2 "Tue." 3 "Wed."
		4 "Thu." 5 "Fri." 6 "Sat.", modify ;
	#delimit cr
	label values `gen' Dayslab
	rename `gen' `generat'
end
