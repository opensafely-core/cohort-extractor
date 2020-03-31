*! version 1.0.0  18may2015
program _rob_calw, sort
	version 14
	args wnew touse worig
	if `:length local worig' {
		local wt [iweight=`worig']
	}
	quietly svyset
	quietly							///
	svycal `r(calmethod)' `r(calmodel)' if `touse' `wt',	///
		`r(calopts)' generate(`wnew')
end
