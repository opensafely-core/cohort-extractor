*! version 1.0.0  21oct2016
program gsem_randomid, rclass
	version 15
	args newid dim touse

	quietly gen int `newid' = runiformint(1,`dim') if `touse'
	check_levels `newid' `dim' `touse'
	while r(passed) == 0 {
		quietly replace `newid' = runiformint(1,`dim') if `touse'
		check_levels `newid' `dim' `touse'
	}
end

program check_levels, rclass
	args newid dim touse

	local passed 1
	forval i = 1/`dim' {
		quietly count if `touse' & `newid' == `i'
		if r(N) == 0 {
			local passed 0
			continue, break
		}
	}

	return scalar passed = `passed'
end
exit
