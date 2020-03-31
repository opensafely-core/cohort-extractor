*! version 1.0.0  21nov2016
program _censobs_limits
	version 15
	args ll ul colon llopt ulopt

	if (`"`llopt'"'=="" | `"`ulopt'"'=="") {
		exit
	}
	// handle lower limit
	cap confirm number `llopt'
	if _rc {
		local llopt = abbrev("`llopt'", 25)
	}
	else {
		cap confirm integer number `llopt'
		if _rc {
			local fmt %10.2f
		}
		else {
			local fmt %10.0gc
		}
		local llopt : display " " `fmt' `llopt'
		local llopt `llopt'
	}
	// handle upper limit
	cap confirm number `ulopt'
	if _rc {
		local ulopt = abbrev("`ulopt'", 25)
	}
	else {
		cap confirm integer number `ulopt'
		if _rc {
			local fmt %10.2f
		}
		else {
			local fmt %10.0gc
		}
		local ulopt : display " " `fmt' `ulopt'
		local ulopt `ulopt'
	}
	// store results
	c_local `ll' `llopt'
	c_local `ul' `ulopt'
end
