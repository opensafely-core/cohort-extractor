*! version 1.0.5  20jan2015
program define inbase, rclass
	version 6
	args b x nothing
	capture confirm integer number `b'
	if _rc { 
		di in red `"inbase:  "`b'" invalid base"'
		exit 198
	}
	capture confirm existence `x'
	if _rc { 
		di in red "inbase:  number to be converted not specified"
		exit 198
	}
	capture confirm number `x'
	if _rc { 
		di in red `"inbase:  "`x'" is not a valid base 10 number"'
		exit 198
	}
	capture confirm integer number `x'
	if _rc { 
		di in red "inbase:  cannot convert nonintegers"
		exit 198
	}

	capture confirm existence `nothing'
	if _rc==0 { 
		di in red `"inbase:  "`nothing'" found where nothing expected"'
		exit 198
	}
	if `x'<0 {
		di in red "inbase:  cannot convert negative numbers"
		exit 198
	}

	if `b'>62 | `b'<2 {
		di in red "inbase:  base must be between 2 and 62"
		exit 198
	}
	if `b'!=int(`b') { 
		di in red "inbase:  base must be integral"
		exit 198
	}
	if `x'!=int(`x') { 
		di in red "inbase:  number to be converted must be integral"
		exit 198
	}

	if `x'==0 { 
		return local base "0"
		di "0"
		exit
	}

	tempname v p
	scalar `v' = `x'
	local l = int(ln(`v')/ln(`b')) + 1
	scalar `p' = 1
	local i = 1
	while `i' <= `l' { 
		scalar `p' = `p'*`b'
		local i = `i' + 1
	}
	local res
	local i = `l'
	while `i' >= 0 {
		local d = int(`v'/`p')
		scalar `v' = `v' - `d'*`p'
		if `d' > 9 {
			local d = bsubstr("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",`d'-9,1)
		}
		if !(`i'==`l' & "`d'"=="0") {
			local res "`res'`d'"
		}
		scalar `p' = `p'/`b'
		local i = `i' - 1
	}
	return local base "`res'"
	di "`res'"
end
