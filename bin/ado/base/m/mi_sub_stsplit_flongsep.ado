*! version 1.0.1  25jun2009

program mi_sub_stsplit_flongsep
	version 11

	local name "`_dta[_mi_name]'"
	local M     `_dta[_mi_M]'
	local stid  `_dta[st_id]'

	di as txt
	di as txt "performing {bf:stsplit} on {it:m}=0:"
	local hold "`_dta[_mi_marker]'"
	char  _dta[_mi_marker] 
	stsplit `0'
	char  _dta[_mi_marker] "`hold'"

	local N = _N
	sort _st `stid' _t0
	// quietly by _st `stid' _t0: assert _N==1 (stsplit will check)
	qui replace _mi_id = _n
	sort _mi_id
	if (`M'==0) {
		exit
	}
	if (`M') {
		qui save `name', replace
		forvalues m=1(1)`M' {
			di as txt ""
			di as txt "(performing {bf:stsplit} on {it:m}=`m')"
			qui use _`m'_`name', clear 
			local hold "`_dta[_mi_marker]'"
			char  _dta[_mi_marker] 
			stsplit `0'
			char  _dta[_mi_marker] "`hold'"
			if (_N != `N') {
				unexpected_error `N' `m'
				/*NOTREACHED*/
			}
			sort _st `stid' _t0
			qui replace _mi_id = _n
			sort _mi_id
			qui save _`m'_`name', replace
		}
		di as txt ""
		di as txt "(combining results)"
		qui use `name', clear
	}
end

program unexpected_error
	args N m

	di as err "results could not be duplicated"
	di as err "{p 4 4 2}
	di as err "Performing {bf:stsplit} on {it:m}=0 resulted in `N' obs."
	di as err "Performing the same operation on {it:m}=`m' resulted in"
	di as err _N "obs.  Results should have been the same."
	di as err "{p_end}"
	exit 459
end
