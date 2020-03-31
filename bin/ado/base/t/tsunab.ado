*! version 1.0.1  19mar1998
program define tsunab, sclass
	version 6
	gettoken user  0: 0, parse(" :")
	gettoken colon 0: 0, parse(" :") 
	if `"`colon'"' != ":" { error 198 }

	syntax [varlist(ts default=empty)] /*
		*/ [, MIN(integer 1) MAX(integer 32000) NAME(string)]
	c_local `user' `varlist'
	local n : word count `varlist'
	if `n'>=`min' & `n'<=`max' { exit }

	if `"`name'"' == "" {
		di in red "`varlist':"
		error cond(`n'<`min', 102, 103)
	}

	if `n'<`min' {
		di in red `"`name':  too few variables specified"'
	}
	else	di in red `"`name':  too many variables specified"'

	local l = length(`"`name'"') + 4 
	di in red _col(`l') _c
	if `min'==`max' {
		if `max' > 1 {
			local s s
		}
		di in red "`min' variable`s' required"
	}
	else if `min'<=0 {
		if `max'==1 {
			di in red "0 or 1 variables required"
		}
		else {
			di in red "`max' or fewer variables required"
		}
	}
	else if `max'>=32000 {
		di in red "`min' or more variables required"
	}
	else {
		di in red "`min' - `max' variables required"
	}
	exit cond(`n'<`min', 102, 103)
end
exit
