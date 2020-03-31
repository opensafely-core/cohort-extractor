*! version 1.1.4  06nov2002
program define _hwsa_opt_d0
	version 8.0
	args todo b lnf 

	tempname alpha beta gamma alpha2 beta2 gamma2

	local lim 12

	qui mleval `alpha' = `b', eq(1) scalar
	qui mleval `beta'  = `b', eq(2) scalar
	qui mleval `gamma' = `b', eq(3) scalar

	scalar `alpha2' = exp(`alpha')/(1+exp(`alpha'))
	scalar `beta2' = exp(`beta')/(1+exp(`beta'))
	scalar `gamma2' = exp(`gamma')/(1+exp(`gamma'))

	tempvar new err pen pen2 pen3
	
	tempvar a0 b1  snt


	_hwsa_comp double `new' , oldvar($T_oldvar) alpha(`alpha2')	/*
		*/ beta(`beta2') gamma(`gamma2') sn0($T_sn0) 		/*
		*/ a0i($T_a0) 	/*
		*/ b0i($T_b1) snt(`snt') firstin($T_firstin) 		/*
		*/ lastin($T_lastin) period($T_per) m($T_m) 

	if abs(`alpha') > `lim' {
		gen `pen' = (abs(`alpha')-`lim')^2
		local pent " - `pen' "
	}	

	if abs(`beta') > `lim' {
		gen `pen2' = (abs(`beta')-`lim')^2
		local pent "`pent' - `pen2' "
	}	

	if abs(`gamma') > `lim' {
		gen `pen3' = (abs(`gamma')-`lim')^2
		local pent "`pent' - `pen3' "
	}	

	qui gen double `err' =-1*($ML_y1 - `new')^2 `pent' if $T_touse == 1 	

	qui mlsum `lnf' = `err'
end

exit

This is the evaluator for the penalized RSS for the additive Holt-Winters
model.
