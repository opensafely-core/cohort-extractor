*! version 1.0.0  01feb2008
program _rob_genid, sort
	version 10
	args newid touse oldid
	sort `touse' `oldid'
	if `:length local touse' {
		quietly count if !`touse'
		local nobs1 = r(N) + 1
		local in in `nobs1'/l
	}
	quietly gen `newid' = `oldid' != `oldid'[_n-1] `in'
	quietly replace `newid' = 1 in `nobs1'
	quietly replace `newid' = sum(`newid') `in'
end
