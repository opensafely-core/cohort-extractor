*! version 1.0.1  29sep2008
program fvunab
	version 11

	_on_colon_parse `0'
	local 0	`"`s(before)'"'
	syntax name(id="macro name" name=user)

	local 0	`"`s(after)'"'
	syntax [varlist(ts fv default=none)] [,	///
		MIN(integer 1)			///
		MAX(integer 32000)		///
		NAME(string)			///
	]

	c_local `user' `varlist'
	local n : list sizeof varlist

	if (`min' <= `n' & `n' <= `max') exit

	if `"`name'"' == "" {
		di as err "{p 0 0 2}"
		di as err `"`varlist':"'
		di as err "{p_end}"
		error cond(`n'<`min', 102, 103)
	}

	if `n' < `min' {
		di as err `"`name': too few variables specified"'
	}
	else {
		di as err `"`name': too many variables specified"'
	}
	local l : length local name
	local l = `l' + 4
	di as err "{p `l' `l' 2}"
	if `min' == `max' {
		if `max' > 1 {
			local s s
		}
		di as err "`min' variable`s' required"
	}
	else if `min' <= 0 {
		if `max'==1 {
			di as err "0 or 1 variables required"
		}
		else {
			di as err "`max' or fewer variables required"
		}
	}
	else if `max'>=32000 {
		di as err "`min' or more variables required"
	}
	else {
		di as err "`min' - `max' variables required"
	}
	di as err "{p_end}"

	exit cond(`n'<`min', 102, 103)
end
exit
