*! version 2.0.0  03may2009
program mixed_ll_reparm
	version 8.2
	args todo b lnf
	
	tempname d b2 beta rho err1 err2 s2 
	local p = colsof(`b')
	scalar `s2' = exp(2*`b'[1,`=$XTM_ctheta+1'])
	mat `beta' = `b'[1, 1..`=$XTM_ctheta+1']
	if $XTM_res {
		mat `rho' = `b'[1, `=$XTM_ctheta+2'...]
	}
	else {
		mat `rho' = 0
	}

	mata: _xtm_gamma_to_theta("`b2'","`beta'","`err1'")
	if scalar(`err1') == 1 {
		scalar `lnf' = .
	}
	else {
		mata: _xtm_theta_to_delta(`"`d'"',`"`b2'"',"`err2'")
		if scalar(`err2') == 1 {
			scalar `lnf' = .
		}
		else {
			mata: _xtm_mixed_ll(`"`d'"',"`rho'","`s2'",0)
			scalar `lnf' = r(ll)
		}
	}
end

