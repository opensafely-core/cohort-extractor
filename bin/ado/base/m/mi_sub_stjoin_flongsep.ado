*! version 1.0.2  09feb2015
program mi_sub_stjoin_flongsep
	version 11

	local name "`_dta[_mi_name]'"
	local M     `_dta[_mi_M]'
	local stid  `_dta[st_id]'

	di as txt
	di as txt "performing {bf:stjoin} on {it:m}=0:"
	drop _mi_id
	local hold "`_dta[_mi_marker]'"
	char _dta[_mi_marker]
	stjoin `0'
	char _dta[_mi_marker] "`hold'"

	local N = _N
	sort _st `stid' _t0
	// quietly by _st `stid' _t0: assert _N==1  (stjoin will check)
	qui gen `c(obs_t)' _mi_id = _n
	qui compress _mi_id
	sort _mi_id

	if (`M') {
		qui save `name', replace
		forvalues m=1(1)`M' {
			di as txt ""
			di as txt "(performing {bf:stjoin} on {it:m}=`m')"
			qui use _`m'_`name', clear 
			drop _mi_id
			local hold "`_dta[_mi_marker]'"
			char _dta[_mi_marker]
			stjoin `0'
			char _dta[_mi_marker] "`hold'"
			if (_N != `N') {
				unexpected_error `N' `m'
				/*NOTREACHED*/
			}
			sort _st `stid' _t0
			qui gen `c(obs_t)' _mi_id = _n
			qui compress _mi_id
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
	di as err "Performing {bf:stjoin} on {it:m}=0 resulted in `N' obs."
	di as err "Performing the same operation on {it:m}=`m' resulted in"
	di as err _N "obs.  Results should have been the same."
	di as err "{p_end}"
	exit 459
end
