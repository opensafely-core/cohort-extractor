*! version 1.0.1  08nov2018
program gsem_factor, rclass sortpreserve
	version 15
	syntax [varlist(fv ts default=none)]	///
		[aw fw]				///
		,				///
		newid(name)			///
		dim(numlist >1)			///
		touse(varname)			///
		[reverse]

	fvrevar `varlist' if `touse'
	local VARLIST `"`r(varlist)'"'
	local VARLIST : list uniq VARLIST
	if `:list sizeof VARLIST' < 2 {
		sort `touse' `VARLIST', stable
	}
	else {
		quietly _rmcoll `VARLIST' if `touse', forcedrop
		local VARLIST `"`r(varlist)'"'

		capture					///
		factor `VARLIST'			///
			[`weight'`exp']			///
			if `touse',			///
			pcf
		if c(rc) == 0 & !inlist(e(f),.,0) {
			tempname score
			quietly predict `score'* if `touse', regression notable
			sort `touse' `score'*, stable
			drop `score'*
		}
		else {
			sort `touse' `VARLIST', stable
		}
	}

	capture confirm new variable `newid'
	if c(rc) == 0 {
		quietly gen `newid' = . in 1
	}

	if "`reverse'" == "" {
		local formula floor((_n-1)*`dim'/_N)+1
	}
	else {
		local formula `dim' - floor((_n-1)*`dim'/_N)
	}
	quietly by `touse' : replace `newid' = `formula' if `touse'
end
exit
