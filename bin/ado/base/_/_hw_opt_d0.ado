*! version 1.1.5  06nov2002
program define _hw_opt_d0
	version 8.0
	args todo b lnf 

	tempname alpha beta atilde btilde

	qui mleval `alpha' = `b', eq(1) scalar
	qui mleval `beta'  = `b', eq(2) scalar


	scalar `atilde' = 1/(1+exp(-1*`alpha'))
	scalar `btilde' = 1/(1+exp(-1*`beta'))

	local lim 12 

	tempvar new err pen pen2 

	if abs(`alpha') > `lim' {
		gen double `pen' = ((abs(`alpha')-`lim')^2)
		local pent " - `pen' "
	}	

	if abs(`beta') > `lim' {
		gen double `pen2' = ((abs(`beta')-`lim')^2)
		local pent "`pent' - `pen2' "
	}	

	qui _hw_comp `new', oldvar($T_oldvar) alpha(`atilde') 	/*
		*/ beta(`btilde') a0i($T_a0) b0i($T_b1) 		/*
		*/ firstin($T_firstin) lastin($T_lastin)

	qui gen double `err' =-1*($ML_y1 - `new')^2 `pent' if $T_touse == 1 
	qui mlsum `lnf' = `err'
end

exit

This is the evaluator for the non-seasonal Holt-Winters penalize RSS.
