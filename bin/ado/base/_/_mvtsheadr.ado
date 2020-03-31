*! version 1.0.0  05feb2007
* Displays 'Sample:  <start> - <end>' and wraps to new line as necessary
* For use with multivariate TS estimators like -var-, -vec-, and -svar-

program define _mvtsheadr

	args t0 t1 indent

	version 10

	if "`e(N_gaps)'`e(N_gaps_var)'" != "" {
		if "`e(N_gaps)'" != "" {
			local N_gaps = e(N_gaps)
		}
		else {
			local N_gaps = e(N_gaps_var)
		}
		if `N_gaps' > 0 {
			local gapcoma ","
			if `N_gaps' == 1 {
				local gaptitl "but with a gap"
			}
			else {
				local gaptitl "but with gaps"
			}
		}
	}
	
	if `"`t0'"' == "" {
		local t0 `=trim(`"`: di `e(tsfmt)' e(tmin)'"')'
		local t1 `=trim(`"`:di `e(tsfmt)' e(tmax)'"')'
	}
	
	if `"`indent'"' == "" {
		local indent 0
	}
	local smpl1 "Sample:  " as res "`t0' -"
				/* NB smpl has extra 10 chars for " as res " */
	if (length(`"`smpl1'"') + length(`"`t1'`gapcoma' `gaptitl'"')) < ///
		(87-`indent') {
		local smpl1 `"`smpl1' `t1'`gapcoma' `gaptitl'"'
	}
	else if (length(`"`smpl1'"') + length(`"`t1'`gapcoma'"')) <	 ///
		(87-`indent') {
		local smpl1 `"`smpl1' `t1'`gapcoma'"
		local smpl2 `"`gaptitl'"'
	}
	else if (length(`"`t1'`gapcoma' `gaptitl'"')) < (45-`indent') {
		local smpl2 `"`t1'`gapcoma' `gaptitl'"'
	}
	else {
		local smpl2 "`t1'`gapcoma'"
		local smpl3 "`gaptitl'"
	}

	if `"`smpl3'"' != "" {
		di _col(`=1+`indent'') as text "`smpl1'"
		di _col(`=10+`indent'') as res "`smpl2'"
		if length(`"`smpl2'"') < (38-`indent') { // cluttered othrws
			di _col(`=10+`indent'') as res "`smpl3'" _c
		}
		else {
			di _col(`=10+`indent'') as res "`smpl3'" _c
		}		
	}
	else if `"`smpl2'"' != "" {
		di _col(`=1+`indent'') as text "`smpl1'"
		if length(`"`smpl2'"') < (38-`indent') {
			di _col(`=10+`indent'') as res "`smpl2'" _c
		}
		else {
			di _col(`=10+`indent'') as res "`smpl2'"
		}
	}
	else {
		if length(`"`smpl1'"') < (56-`indent') {
			di _col(`=1+`indent'') as text "`smpl1'" _c
		}
		else {
			di _col(`=1+`indent'') as text "`smpl1'"
		}
	}

end
