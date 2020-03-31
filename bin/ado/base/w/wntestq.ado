*! version 1.0.10 30sep2004
program define wntestq, rclass
	version 6.0, missing

	local vv : display "version " string(_caller()) ", missing:"

	syntax varname(ts) [if] [in] [, Lags(passthru)]

	marksample touse
	_ts t1 panelvar `if' `in', sort onepanel
	markout `touse' `t1'

	tempvar p
	`vv' ac `varlist' if `touse', gen(`p') `lags' nograph

	quietly {
		count if `touse'
		local n = r(N)
		count if `p' <.
		local df = r(N)
		replace `p' = sum(`p'^2/(`n'-_n))
	}

	return scalar stat = `p'[_N] * `n' * (`n'+2)
	return scalar p    = chiprob(`df',return(stat))
	return scalar df   = `df'

	di _n in gr "Portmanteau test for white noise"
	di in smcl in gr "{hline 39}"
	di in gr " Portmanteau (Q) statistic = " in ye %10.4f return(stat)
	di in gr " Prob > chi2(" in ye `df' in gr ") " _col(28) "= " /*
		*/ in ye %10.4f return(p)
end
