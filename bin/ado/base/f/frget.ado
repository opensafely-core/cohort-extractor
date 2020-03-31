*! version 1.0.1  29apr2019
program frget
	version 16
	syntax anything(equalok),	///
		from(varname)		///
	[	PREfix(string)		///
		SUFfix(string)		///
		EXclude(string)		///
	]

	frlink_dd certify `from'
	frlink_dd get frame : `from' fname2
	frlink_dd get match : `from' vl2p

	local EQ = ustrpos(`"`anything'"', "=")
	if `EQ' {
		if `"`prefix'"' != "" {
			di as err "option {bf:prefix()} not allowed"
			exit 198
		}
		if `"`suffix'"' != "" {
			di as err "option {bf:suffix()} not allowed"
			exit 198
		}
		if `"`exclude'"' != "" {
			di as err "option {bf:exclude()} not allowed"
			exit 198
		}

		// generated macros:
		// 	K	- number of pairs
		// 	src#	- source variable in #th pair
		// 	new#	- new variable in #th pair
		ParseEQ `frame' `anything'
	}
	else {
		if "`prefix'" != "" {
			CheckNamePart prefix `"`prefix'"'
		}
		if "`suffix'" != "" {
			CheckNamePart suffix `"`suffix'"'
		}

		// generated macros:
		// 	K	- number of pairs
		// 	src#	- source variable in #th pair
		// 	new#	- new variable in #th pair
		//	xcluded	- list of excluded variables 
		ParseList `frame' `anything' ,	///
			prefix(`prefix')	///
			suffix(`suffix')	///
			exclude(`exclude')	///
			match(`match')
	}

	forval i = 1/`K' {
		_frget `from' `new`i'' = `src`i''
		local newlist `newlist' `new`i''
		local srclist `srclist' `src`i''
	}
	Post "`newlist'" "`srclist'" "`xcluded'"
end

program Post, rclass
	args newlist srclist xcluded
	local k : list sizeof newlist
	if `k' != 1 {
		local s s
	}
	di as txt "{p 2 3 2}"
	di as txt "(`k' variable`s' copied from linked frame)"
	di as txt "{p_end}"
	return scalar k = `k'
	return local newlist `newlist'
	return local srclist `srclist'
	return local excluded `xcluded'
end

program CheckNamePart
	args name value

	local p : list sizeof prefix
	if `p' > 1 {
		di as err "invalid {bf:`name'()} option;"
		di as err "only one word can be used as a `name'"
		exit 198
	}
	capture confirm name `value'
	if c(rc) {
		di as err "invalid {bf:`name'()} option;"
		di as err "{bf:`value'} found where a name `name' expected"
		exit 198
	} // c(rc)
end

program NotName
	local n : list sizeof 0
	if `n' == 0 {
		exit
	}
	if `n' == 1 {
		di as err "{bf:`0'} found where a name was expected"
		exit 7
	}
	di as err "{bf:`1'} found where a name was expected;"
	di as err "{p 0 0 2}"
	di as err "invalid name specifications: "
	di as err "`0'"
	di as err "{p_end}"
	exit 7
end

program Ambig
	local n : list sizeof 0
	if `n' == 0 {
		exit
	}
	if `n' == 1 {
		di as err "{bf:`0'} ambiguous abbreviation"
		exit 111
	}
	di as err "{bf:`1'} ambiguous abbreviation;"
	di as err "{p 0 0 2}"
	di as err "ambiguous abbreviations: "
	di as err "`0'"
	di as err "{p_end}"
	exit 111
end

program NotFound, rclass
	local n : list sizeof 0
	if `n' == 0 {
		exit
	}
	return local notfound `"`0'"'
	if `n' == 1 {
		di as err "variable {bf:`0'} not found"
		exit 111
	}
	di as err "{p 0 0 2}"
	di as err "variables not found: "
	di as err "{bf}`0'{reset}"
	di as err "{p_end}"
	exit 111
end

program NewVarlist, rclass
	local reps : list dups 0
	local reps : list uniq reps
	local nreps : list sizeof reps
	if `nreps' {
		if `nreps' > 1 {
			local s s
		}
		di as err "{p 0 0 2}"
		di as err "duplicate new variable names not allowed;{break}"
		di as err "duplicate name`s': {bf}`reps'{reset}"
		di as err "{p_end}"
		exit 110
	}

	foreach v of local 0 {
		capture confirm new variable `v'
		if c(rc) {
			local dups `dups' `v'
		}
	}

	local ndups : list sizeof dups
	if `ndups' == 0 {
		exit
	}
	return local dups `"`dups'"'
	if `ndups' == 1 {
		di as err "variable {bf:`dups'} already exists"
		exit 110
	}
	di as err "{p 0 0 2}"
	di as err "variables that already exist: "
	di as err "{bf}`dups'{reset}"
	di as err "{p_end}"
	exit 110
end

program ParseEQ
	// Syntax:
	// 	<frame> <pair> [<pair> ...]
	//
	// 	<pair>:
	// 		<newvarname> = <varname>
	//
	// <newvarname> is new in the current frame
	// <varname> refers to a variable in frame <frame>
	gettoken frame 0 : 0

	local i 0
	while `:list sizeof 0' {
		local ++i
		gettoken new`i' 0 : 0, parse(" =")
		capture confirm name `new`i''
		if c(rc) {
			local notname `notname' `new`i''
		}
		local newlist `newlist' `new`i''
		gettoken EQ 0 : 0, parse(" =")
		if `"`EQ'"' != "=" {
			di as err ///
			`"{bf:`EQ'} found where equal sign, {bf:=}, expected"'
			exit 198
		}
		gettoken src`i' 0 : 0, parse(" =")
		capture confirm name `src`i''
		if c(rc) {
			local notname `notname' `src`i''
		}
	}

	NotName `notname'

	local K = `i'

	frame `frame' {
		forval i = 1/`K' {
			capture _unab `src`i''
			if c(rc) {
				if c(varabbrev) == "on" {
					capture _unab `src`i''*
					if c(rc) == 0 {
						local ambig `ambig' `src`i''
						local src`i'
					}
				}
				local notfound `notfound' `src`i''
			}
			else {
				local src`i' = r(varlist)
			}
		}
	}

	Ambig `ambig'
	NotFound `notfound'
	NewVarlist `newlist'

	forval i = 1/`K' {
		c_local src`i' `src`i''
		c_local new`i' `new`i''
	}
	c_local K `K'
end

program Excluded
	local n : list sizeof 0
	if `n' == 0 {
		exit
	}
	local 0 : list retok 0
	if `n' > 1 {
		local s s
	}
	di as txt "{p 2 3 2}(variable`s' not copied from linked"
	di as txt "frame: {bf}`0'{reset})"
	di as txt "{p_end}"
end

program ParseList
	gettoken frame 0 : 0

	frame `frame' {
		syntax varlist [,		///
			prefix(string)		///
			suffix(string)		///
			exclude(varlist)	///
			match(varlist)		///
		]
	}

	local varlist : list uniq varlist
	local xcluded : list varlist & exclude
	local varlist : list varlist - exclude
	local matched : list varlist & match
	local varlist : list varlist - match
	local system
	foreach v of local varlist {
		if substr("`v'",1,1) == "_" {
			local system `system' `v'
		}
	}
	local varlist : list varlist - system

	Excluded `xcluded' `matched' `system'

	local i 0
	foreach v of local varlist {
		local ++i
		c_local src`i' `v'
		local new `prefix'`v'`suffix'
		c_local new`i' `new'
		local newlist `newlist' `new'
	}
	c_local K `i'

	NewVarlist `newlist'

	c_local xcluded `xcluded' `matched' `system'
end

exit
