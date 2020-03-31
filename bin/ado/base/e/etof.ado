*! version 2.1.0  02/27/93
program define etof
	version 3.1
	local varlist "req ex max(1)"
	local if "opt"
	local in "opt"
	local options "Generate(string)"
	parse "`*'"
	if "`generat'"=="" { error 198 }
	conf new var `generat'
	tempvar mo da yr 
	quietly etomdy `varlist' `if' `in', gen(`mo' `da' `yr')
	mdytof `mo' `da' `yr' `if' `in', gen(`generat')
end
