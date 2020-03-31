*! version 1.0.1  22oct2019

program sg__variables_vlist
	version 13.0
	gettoken subcmd 0: 0
	if ("`subcmd'" == "getVars") {
		getVars `0'
	}
	else if ("`subcmd'" == "getLevels") {
		getLevels `0'
	}
	else if ("`subcmd'" == "getLevelsStr") {
		getLevelsStr `0'
	}
end

program getVars
	args clsarray

	local cnt = 1
	`clsarray'.Arrdropall
	foreach var of varlist _all {
		capture confirm numeric variable `var'
		if _rc == 0 {
			`clsarray'[`cnt++'] = "`var'"
		}
	}
end

program getLevels
	args var clsarray clsarrar_val
	
	local maxlength 24
	local cnt = 1
	`clsarray'.Arrdropall
	`clsarrar_val'.Arrdropall
	
	capture levelsof `var'
	if _rc == 0 {
		local rlevels `"`r(levels)'"'
	}
	foreach level in `rlevels' {
		local vl : label (`var') `level' `maxlength'
		if `"`vl'"' != "`level'" {
			local lab `"`level':`vl'"'
		}
		else {
			local lab `"`level'"'
		}
		`clsarray'[`cnt'] = "`lab'"
		`clsarrar_val'[`cnt++'] = "`level'"
	}	
end

program getLevelsStr
	args var clsstr
	
	local cnt = 0
	`clsstr' = ""
	
	capture confirm variable `var', exact
	if (_rc) {
		exit
	}

	capture levelsof `var'
	if _rc == 0 {
		local rlevels "`r(levels)'"
	}
	local cnt : word count `rlevels'
	
	if `cnt' <= 50 {
		capture numlist "`rlevels'", integer
		if (!_rc) {
			local cnt = 0
			foreach level in `rlevels' {
				local cnt = `cnt' + 1 
				if (`cnt' > 1) {
					local levels "`levels' `level'"
				}
				else {
					local levels "`level'b"
				}
			}
			`clsstr' = "`levels'"
		}
	}
end
