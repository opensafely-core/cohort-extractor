*! version 1.2.1  17may2016
program define censobs_table
	version 14
				    /* interval ll ul -- optional */
	args uncens leftcens rightcens interval	ll ul

	local dep : word 1 of `e(depvar)'
	local dep = abbrev("`dep'", 12)

	if !missing("`ll'") & `leftcens' != 0 {
		local ll `" at `dep' <= {res}`ll'"'
	}
	else	local ll
	local s = cond(`leftcens'==1, " ", "s")
	di as res %14.0fc `leftcens'	///
	   as txt `"  left-censored observation`s'`ll'"'

	local s = cond(`uncens'==1, " ", "s")
	di as res %14.0fc `uncens'	///
	   as txt `"     uncensored observation`s'"'

	if !missing("`ul'") & `rightcens' != 0 {
		local ul `" at `dep' >= {res}`ul'"'
	}
	else	local ul
	local s = cond(`rightcens'==1, " ", "s")
	di as res %14.0fc `rightcens'	///
	   as txt `" right-censored observation`s'`ul'"'

	if "`interval'" == "" {
		exit
	}
	local s = cond(`interval'==1,"","s")
	di as res %14.0fc `interval'	///
	   as txt `"       interval observation`s'"'
end
exit

----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
 9,999,999,999   left-censored observations at var456789012 <= 1,234,567
 9,999,999,999      uncensored observations
 9,999,999,999  right-censored observations

