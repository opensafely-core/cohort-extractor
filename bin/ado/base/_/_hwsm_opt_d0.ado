*! version 1.1.5  06nov2002
program define _hwsm_opt_d0
	version 8.0
	args todo b lnf 

	tempname alpha beta gamma alpha2 beta2 gamma2 

	qui mleval `alpha' = `b', eq(1) scalar
	qui mleval `beta'  = `b', eq(2) scalar
	qui mleval `gamma' = `b', eq(3) scalar

	local lim 12

	scalar `alpha2' = exp(`alpha')/(1+exp(`alpha'))
	scalar `beta2'  = exp(`beta')/(1+exp(`beta'))
	scalar `gamma2' = exp(`gamma')/(1+exp(`gamma'))

	tempvar new err pen pen2 pen3

	_hwsm_comp double `new', oldvar($T_oldvar) 			/*
		*/ alpha(`alpha2') beta(`beta2') gamma(`gamma2') 	/*
		*/ sn0($T_sn0) a0i($T_a0) b1i($T_b1) 			/*
		*/ firstin($T_firstin) mvar($T_m) period($T_per)	/*
		*/ lastin($T_lastin)

	if abs(`alpha') > `lim' {
		gen double `pen' = ((abs(`alpha')-`lim')^2)
		local pent " - `pen' "
	}	

	if abs(`beta') > `lim' {
		gen double `pen2' = ((abs(`beta')-`lim')^2)
		local pent "`pent' - `pen2' "
	}	

	if abs(`gamma') > `lim' {
		gen double `pen3' = ((abs(`gamma')-`lim')^2)
		local pent "`pent' - `pen3' "
	}	

	qui gen double `err' =-1*($ML_y1 - `new')^2  `pent' if $T_touse == 1 	

	qui mlsum `lnf' = `err'

end

exit

This is the d0 evaluator for the  penalized RSS for the Multiplicative
Holt-Winters model

