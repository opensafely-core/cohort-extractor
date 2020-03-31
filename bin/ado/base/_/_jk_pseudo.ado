*! version 1.0.1  16feb2015
program _jk_pseudo
	version 9
	syntax varlist(numeric) [fw] [if] , b(name) [ strata(varname) ]

	confirm matrix `b'
	local K : word count `varlist'
	marksample touse

	tempname wnclust
	if "`weight'" == "fweight" {
		sum `touse' [`weight'`exp'] if `touse', mean
		scalar `wnclust' = r(sum)
	}
	else {
		if "`strata'" == "" {
			quietly count if `touse'
			scalar `wnclust' = r(N)
		}
		else {
			sort `touse' `strata', stable
			quietly by `touse' `strata' : ///
				gen `c(obs_t)' `wnclust' = _N
		}
	}

	// generate the pseudovalues
	forval i = 1/`K' {
		local var : word `i' of `varlist'
		quietly replace `var' = `var'+`wnclust'*(`b'[1,`i']-`var')
	}
end
exit
