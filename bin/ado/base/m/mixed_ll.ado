*! version 2.1.0  03jul2009
program mixed_ll
	version 8.2
	args todo b lnf

	tempname s d err theta drho rho
	scalar `s' = -1
	if $XTM_ctheta {
		mat `theta' = `b'[1, 1..$XTM_ctheta]
	}
	else {
		mata: _xtm_null_rowvector("`theta'")
	}
	if $XTM_res {
		mat `drho' = `b'[1, `=$XTM_ctheta+1'...]
	}
	else {
		mat `drho' = 0
	}
	mata: _xtm_drho_to_rho("`drho'", "`rho'", "`err'")
	if scalar(`err') == 1 {
		scalar `lnf' = . 
	}
	mata: _xtm_theta_to_delta(`"`d'"',`"`theta'"',"`err'")
	if scalar(`err') == 1 {
		scalar `lnf' = .
	}
	else {
		mata: _xtm_mixed_ll(`"`d'"',"`rho'","`s'",0)
		scalar `lnf' = r(ll)
	}
end

