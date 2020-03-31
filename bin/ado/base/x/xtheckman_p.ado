*! version 1.0.0  20feb2019
program xtheckman_p
	version 16
	syntax [anything] [if] [in], [,	///
		xb			///
		XBSel			///
		Pr(passthru)		///
		e(passthru)		///
		YStar(passthru)		///
		YCond			///
		PSel			///
                noOFFset                ///
		SCores]	
	// xbsel
	// psel
	// ycond
	if "`xbsel'" != "" {
		if "`xb'" != "" {
			opts_exclusive "xb xbsel"
		}
		if "`pr'" != "" {
			opts_exclusive "pr() xbsel"
		}
		if "`e'" != "" {
			opts_exclusive "e() xbsel"
		}
		if "`ystar'" != "" {
			opts_exclusive "ystar() xbsel"
		}
		if "`ycond'" != "" {
			opts_exclusive "ycond xbsel"
		}
		if "`psel'" != "" {
			opts_exclusive "psel xbsel"
		}
		if "`scores'" != "" {
			opts_exclusive "scores xbsel"
		}
	}
	if "`psel'" != "" {
		if "`xb'" != "" {
			opts_exclusive "xb psel"
		}
		if "`pr'" != "" {
			opts_exclusive "pr() psel"
		}
		if "`e'" != "" {
			opts_exclusive "e() psel"
		}
		if "`ystar'" != "" {
			opts_exclusive "ystar() psel"
		}
		if "`ycond'" != "" {
			opts_exclusive "ycond psel"
		}
		if "`xbsel'" != "" {
			opts_exclusive "xbsel psel"
		}
		if "`scores'" != "" {
			opts_exclusive "scores psel"
		}
	}
	if "`ycond'" != "" {
		if "`xb'" != "" {
			opts_exclusive "xb ycond"
		}
		if "`pr'" != "" {
			opts_exclusive "pr() ycond"
		}
		if "`e'" != "" {
			opts_exclusive "e() ycond"
		}
		if "`ystar'" != "" {
			opts_exclusive "ystar() ycond"
		}
		if "`psel'" != "" {
			opts_exclusive "psel ycond"
		}
		if "`xbsel'" != "" {
			opts_exclusive "xbsel ycond"
		}
		if "`scores'" != "" {
			opts_exclusive "scores ycond"
		}
	}
	local stat "`xb'`pr'`e'`ystar'`ycond'`xbsel'`psel'`scores'"
	if "`stat'" == "" {
		local xb xb
		di as text "(option {bf:xb} assumed; linear prediction"
	}
	if "`ycond'" != "" {
		// set up target and base for ycond
		local target mean target(`e(seldepvar)'=1) cond(`e(seldepvar)')
		local base base(`e(seldepvar)'=1) 
	}
	if "`xbsel'" != "" {
		local equation equation(`e(seldepvar)')
		local xb xb
	}
	if "`psel'" != "" {
		local equation equation(`e(seldepvar)')
		local pr pr
	}
	if "`scores'" == "" {
		ParseAnything `anything'
		local varlist `r(varlist)'	
	}	
	eregress_p `anything' `if' `in', `scores' ///
		`xb' `pr' `e' `ystar' `equation' `target' `base' `offset'
	// label selection linear prediction
	if "`xbsel'" != "" {
		label variable `varlist' "Linear prediction of `e(seldepvar)'" 
	}
	if "`ystar'" != "" {
		local lab: variable label `varlist' 
		gettoken lab1 lab2 : lab, parse("=")
		local lab2 = usubstr("`lab2'",3,.)
		local lab2 E(`lab2')
		label variable `varlist' "`lab2'"
	}
end

program ParseAnything, rclass
	syntax newvarlist
	return local varlist `varlist'
end 
