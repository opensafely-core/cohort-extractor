*! version 2.0.2  09feb2015
program define _xtreg_chk_cl, sort
	version 9.0 


/*
        Throw error if the clusters are nested within panels.  The data have
        already been restricted to `touse'.

	clusters are nested within panels if 
		
		(1) id does not vary within cluster, and
		(2) cluster varies within id

	utility called by xtreg_re and xtreg_fe
*/

	args clvar ivar

	tempvar Tb2 Tb vary

					/* tempvar will have non-zero obs
					 * if id varies within cluster
					 */
	sort `ivar'
	qui by `ivar': gen `c(obs_t)' `Tb' = cond(_n==1,1,0) 
	qui replace `Tb' = sum(`Tb')

	sort `clvar' `ivar' 
	qui by `clvar' : gen long `Tb2' = `Tb'[1]-`Tb'[_N]


	qui count if `Tb2' != 0
	scalar `vary' = r(N)
						/* true when clvar does not 
						 * vary within cluster 
						 */
	if `vary' == 0 {	

					/* tempvar will have non-zero obs
					 * if cluster varies within id
					 */
					 
		qui capture drop `Tb'
		sort `clvar'
		qui by `clvar': gen `c(obs_t)' `Tb' = cond(_n==1,1,0) 
		qui replace `Tb' = sum(`Tb')

		capture drop `Tb2'
		sort `ivar' `clvar' 
		qui by `ivar' : gen long `Tb2' = `Tb'[1]-`Tb'[_N]


		qui count if `Tb2' != 0
		scalar `vary' = r(N)

		if `vary' > 0 {
			di as err "clusters nested within panels"
			exit 498

		}

	}
end
