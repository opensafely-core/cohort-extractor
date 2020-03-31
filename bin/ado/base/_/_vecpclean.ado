*! version 1.0.1  14jul2004
program define _vecpclean, nclass 
	version 8.2

	capture drop _trend

	capture constraint drop $T_VECacnslist
	capture macro drop T_VECacnslist

	capture noi syntax , rank(integer) 

	local rc = _rc

	if `rank' < 1 | `rc' > 0 {
di as err "rank(`rank') invalid"
di as err "{p 4 4 4}cannot drop predicted cointegrating equations{p_end}"
exit 498
	}

	forvalues i = 1/`rank' {
		capture drop _ce`i'
	}


end

exit

This program cleans up after the vec postestimation work routines.
Specifically, it drops any constraints on alpha, held in the global 
T_VECacnslist, the global T_VECacnslist, _ce1,  _ce{r} and _trend.


