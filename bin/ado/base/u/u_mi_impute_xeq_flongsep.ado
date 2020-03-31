*! version 1.0.0  26jun2011
program u_mi_impute_xeq_flongsep
	version 12
	args m colon command
	local basename `_dta[_mi_name]'
	if (`m'==0) {
		qui use `basename', clear
		sort _mi_id
	}
	else {
		qui use _`m'_`basename', clear
		sort _mi_id
	}
	char _dta[_mi_impute_m] `m'
	cap noi `command'
	char _dta[_mi_impute_m]
	local rc = _rc
	nobreak {
		qui save, replace
		if (`m'>0) {
			qui use `basename', clear
			qui save, replace
		}
		else { //to add __mi_fv* vars to m>0 if augmented regression
			cap unab fvvars : __mi_fv*
			if (_rc==0) {
				qui u_mi_certify_data, acceptable proper
			}
		}
	}
	exit `rc'
end
