*! version 1.0.0  24aug2016
program define _erm_censobs_table
	version 15
	if "`e(seldepvar)'`e(tseldepvar)'" == "" {
		censobs_table `0'
		exit
	}
	else {
		local 0 e(N_cens) `0'
	}
	args cens uncens leftcens rightcens interval
	local s = cond(`cens'==1, " ", "s")
	di as res %14.0fc `cens'	///
	   as txt `"  selection-censored observation`s'"'
	local dep : word 1 of `e(depvar)'
	local dep = abbrev("`dep'", 12)
	local s = cond(`leftcens'==1, " ", "s")
	di as res %14.0fc `leftcens'	///
	   as txt `"       left-censored observation`s'"'
	local s = cond(`uncens'==1, " ", "s")
	di as res %14.0fc `uncens'	///
	   as txt `"          uncensored observation`s'"'
	local s = cond(`rightcens'==1, " ", "s")
	di as res %14.0fc `rightcens'	///
	   as txt `"      right-censored observation`s'"'
	local s = cond(`interval'==1,"","s")
	di as res %14.0fc `interval'	///
	   as txt `"            interval observation`s'"'
end
exit

----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
 9,999,999,999   left-censored observations at var456789012 <= 1,234,567
 9,999,999,999      uncensored observations
 9,999,999,999  right-censored observations

