*! version 3.1.2  20dec2004
program define mcc, rclass
* touched by kth
	version 6, missing
	syntax varlist(min=2 max=2) [if] [in] [fw] [, /*
		*/ Level(cilevel) TB ]
	tokenize `varlist'
	local excas `1'
	local excon `2'

	marksample use
	tempvar WGT one
	quietly { 
		if "`weight'"!="" { 
			gen double `WGT' `exp' if `use'
			local w "[fweight=`WGT']"
		}
	}

	quietly { 
		gen byte `one'=1
		safesum `one' `w' if `excas' & `excon' & `use'
		local a=r(sum)
		safesum `one' `w' if `excas' & `excon'==0 & `use'
		local b=r(sum)
		safesum `one' `w' if `excas'==0 & `excon' & `use'
		local c=r(sum)
		safesum `one' `w' if `excas'==0 & `excon'==0 & `use'
		local d=r(sum)
	}
	mcci `a' `b' `c' `d', level(`level') `tb'
	ret add   /* return the r() values from mcci call */
end
