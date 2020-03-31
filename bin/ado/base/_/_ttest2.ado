*! version 2.2.2  29jan1998
program define _ttest2
* touched by jwh

* This comment added 01nov2001
* 
* This file used to be part of the official Stata ado-files under Version 6,
* but was taken out of Version 7.  It is not being called by any official
* Stata ado file.  However, StataQuest, which people can download and use
* within Stata, calls directly to this routine.
*
* We have reinserted _ttest2.ado (through an ado-file update) as part of the
* official Stata ado files.

	local name = trim(substr(trim(`"`1'"'),1,8))
	local n "`2'"
	local mean "`3'"
	local se "`4'"
	if `n' == 1 | `n' == . {
		local se = .
	}
	local normal = "`5'"     /* dont take = sign away */
	local level "`6'"

	local tval = `mean'/`se'
	if "`normal'" == "" {
		local df   = `n' - 1
		local pval = tprob(`df',`tval')
	
		local beg = 9 - length(`"`name'"')
		noi di in gr _col(`beg') `"`name'"' /*
			*/ in gr _col(10) "|" in ye /*
			*/ _col(12) %9.0g  `mean'   /*
			*/ _col(24) %9.0g  `se'     /*
			*/ _col(35) %8.0g  `tval'   /*
			*/ _col(46) %6.4f  `pval'   /*
			*/ _col(58) %9.0g  `mean'-invt(`df',`level'/100)/*
			*/ *`se'   /*
			*/ _col(70) %9.0g  `mean'+invt(`df',`level'/100)*`se'
	}
	else {
		local tval = abs(`tval')
		local pval = 2*(1 - normprob(`tval'))
	
		local vval = (100 - (100-`level')/2)/100
		local beg = 9 - length(`"`name'"')
		noi di in gr _col(`beg') `"`name'"' /*
			*/ in gr _col(10) "|" in ye /*
			*/ _col(12) %9.0g  `mean'   /*
			*/ _col(24) %9.0g  `se'     /*
			*/ _col(35) %8.0g  `tval'   /*
			*/ _col(46) %6.4f  `pval'   /*
			*/ _col(58) %9.0g  `mean'-invnorm(`vval')/*
			*/ *`se'   /*
			*/ _col(70) %9.0g  `mean'+invnorm(`vval')*`se'
	}
end
exit
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
   _cons |   6165.257   342.8719     17.981   0.000       5481.914      6848.6

