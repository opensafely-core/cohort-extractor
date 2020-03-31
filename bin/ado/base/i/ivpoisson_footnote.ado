*! version 1.0.0  03jun2012
program ivpoisson_footnote
	version 13.0
	syntax [, noLINE ]
	local w = `"`s(width)'"'
	capture {
		confirm integer number `w'
	}
	if c(rc) {
		local w 78
	}
	local rmargin = c(linesize) - `w' + 2
	if "`e(instd)'" == "" {
		di as txt "(no endogenous regressors)"
	}
	else {
	local instd "`e(instd)'"
	local insts "`e(insts)'" 
	tempname rhold
	_return hold `rhold'
	foreach var of local instd {
		_ms_parse_parts `var'
		if !r(omit) {
			local instd1 "`instd1' `var'"
		}
	} 
	foreach var of local insts {
		_ms_parse_parts `var'
		if !r(omit) {
			local insts1 "`insts1' `var'"
		}
	} 
	_return restore `rhold'
	local instd : list clean instd1
	local insts : list clean insts1
		di as txt 	///
		    "{p 0 15 `rmargin'}Instrumented:{space 2}`instd'{p_end}"
		di as txt 	///
		    "{p 0 15 `rmargin'}Instruments:{space 3}`insts'{p_end}"
	}
	if "`line'" == "" {
		di as txt "{hline `w'}"
	}
end
exit
