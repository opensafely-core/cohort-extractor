*! version 6.3.2  13feb2015 
program define _tsheadr
	version 6.0

	syntax [, noCNSReport]

	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
		*/ bsubstr(`"`e(crittype)'"',2,.)

	if e(N_gaps) > 0 { 
		local gapcoma ","
		if e(N_gaps) == 1 {
			local gaptitl "but with a gap"
		}
		else {
			local gaptitl "but with gaps"
		}
	}
	
	di _n in gr "`e(title)'"
	if `"`e(title2)'"' != "" { di in gr "`e(title2)'" }

	local x1 = strtrim(`"`e(tmins)'"')
	local x2 = strtrim(`"`e(tmaxs)'"')
	local smpl1 "Sample:  " in ye "`x1' -"
			/* NB smpl has extra 9 chars for " in ye " */
	if (length(`"`smpl1'"') + length(`"`x2'`gapcoma' `gaptitl'"')) < 87 {
		local smpl1 "`smpl1' `x2'`gapcoma' `gaptitl'"
	}
	else if (length(`"`smpl1'"') + length(`"`x2'`gapcoma'"')) < 87 {
		local smpl1 "`smpl1' `x2'`gapcoma'"
		local smpl2 "`gaptitl'"
	}
	else if (length(`"`x2'`gapcoma' `gaptitl'"')) < 45 {
		local smpl2 "`x2'`gapcoma' `gaptitl'"
	}
	else {
		local smpl2 "`x2'`gapcoma'"
		local smpl3 "`gaptitl'"
	}
	
	if `"`smpl3'"' != "" {
		di in gr _n "`smpl1'"
		di in ye _col(10) "`smpl2'"
		if length(`"`smpl2'"') < 36 {	// cluttered otherwise
			local osmpl in ye _col(10) "`smpl3'"
		}
		else {
			di in ye _col(10) "`smpl3'"
		}
	}
	else if `"`smpl2'"' != "" {
		di in gr _n "`smpl1'"
		if length(`"`smpl2'"') < 36 {
				// will fit in line w/ # of obs
				// without being too cluttered
			di in ye _c
			local osmpl _col(10) "`smpl2'"
		}
		else {
				// won't fit, say it now
			di in ye _col(10) "`smpl2'"
		}
	}
	else {
		if length(`"`smpl1'"') < 56 {
			local osmpl in gr _n "`smpl1'"
		}
		else {
			di in gr _n "`smpl1'"
		}
	}
	local x1
	local x2

	di `osmpl'							/*
		*/ _col(49) in gr "Number of obs" in gr _col(67) "="	/*
		*/ in ye _col(69) %10.0g e(N)

	if !missing(e(df_r)) {
		local model _col(49) as txt "F(" ///
			as res %3.0f e(df_m) as txt "," ///
			as res %6.0f e(df_r) as txt ")" _col(67) ///
			"=" _col(70) as res %9.2f e(F)
		local pvalue _col(49) as txt "Prob > F" _col(67) ///
			"=" _col(73) as res %6.4f Ftail(e(df_m),e(df_r),e(F))
	}
	else {
		if "`e(chi2type)'" == "" {
			local chitype Wald
		}
		else	local chitype `e(chi2type)'
		local model _col(49) as txt `"`chitype' chi2("' ///
			as res e(df_m) as txt ")" _col(67) ///
			"=" _col(70) as res %9.2f e(chi2)
		local pvalue _col(49) as txt "Prob > chi2" _col(67) ///
			"=" _col(73) as res %6.4f chiprob(e(df_m),e(chi2))
	}

	di `model'
	if "`e(ll)'" != "" {
		di in gr "`crtype' = " in ye %9.0g e(ll) `pvalue'
	}
	else {
		di `pvalue'
	}
	di

	if "`cnsreport'" == "" {
		mat dispCns
	}
end
exit
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
Main title of time-series model 

Sample: 1940w32 to 1960w45                      Number of obs     =        543
                                                Wald chi2(2)      =       0.61
Log likelihood = -66.372364                     Prob > chi2       =     0.7382

