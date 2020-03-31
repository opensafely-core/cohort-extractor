*! version 1.1.2  19feb2016
program define _xtreg_chk_cl2, sort
	version 9.0

/*
        Throw error if the panels are not the same as or not nested within
        panels.  

        You must either first restrict the sample to the observations you
        intend to use or else pass an optional third argument here which
        indicates 1 if the panel is in the estimation sample and 0 otherwise.
        
        Panels are nested within clusters if cluster does not vary within
        id.

*/

	args clvar ivar pantouse

	if "`clvar'" == "`ivar'" exit

	if "`pantouse'" != "" local touse if `pantouse'

	tempvar Tb2 Tb vary
	

					/* tempvar will have non-zero obs
					 * if cluster varies within id
					 */
					 
	sort `clvar'
	qui by `clvar': gen `c(obs_t)' `Tb' = cond(_n==1,1,0) `touse'
	qui replace `Tb' = sum(`Tb')

	sort `ivar' `clvar' 
	qui by `ivar' : gen long `Tb2' = `Tb'[1]-`Tb'[_N]

	if "`pantouse'" != "" {
		qui count if `Tb2' != 0 & `pantouse'
	}
	else {
		qui count if `Tb2' != 0
	}
	scalar `vary' = r(N)

	if `vary' > 0 {
		di as err "panels are not nested within clusters"
		exit 498
	}

end
