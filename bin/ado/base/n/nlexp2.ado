*! version 2.0.0  03jan2005
program nlexp2, rclass

	if _caller() < 9 {
		nlexp2_7 `0'
		exit
	}

	version 8
	
	syntax varlist(min=2 max=2) [aw fw iw] if
	tokenize `varlist'
	
	/* Initial values */
	tempvar Y
	generate double `Y' = log(`1') 
	reg `Y' `2' [`weight'`exp'] `if'
	
	return local eq "`1' = {b1=exp(_b[_cons])}*{b2=exp(_b[`2'])}^`2'"
	return local title "2-parameter exp. growth curve, `1' = b1*b2^`2'"

end
