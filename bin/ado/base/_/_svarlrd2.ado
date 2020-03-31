*! version 1.0.4  17oct2002
program define _svarlrd2
	version 8.0

	args todo b lnf g h

	tempname B lrK K TR trace det BI
	tempname KIP Kr Krp vecK vecKp Q1 Q2 Ci 

	mat `lrK' = J($T_neqs,$T_neqs,0)

	local eqn 0
	local base = $T_neqs*$T_neqs
	forvalues i = 1/$T_neqs {
		forvalues j = 1/$T_neqs {
			local ++eqn
			tempname ki_`j'_`i'
			mleval `ki_`j'_`i'' = `b', scalar eq(`eqn')
			mat `lrK'[`j',`i'] = `ki_`j'_`i''
		}
	}


	mat `B' = $T_Abar*`lrK'

	capture mat `Ci' = inv(`lrK')
	if _rc > 0 {
		di as err "C matrix is singular"
		scalar `lnf' = .
		exit
	}	

	mat `BI' = `Ci'*$T_Abari

	capture mat `K' = `BI'
	if _rc > 0 {
		scalar `lnf' = .

		exit
	}	

	mat `TR' = (`K')'*`K'*$T_sigma
	scalar `trace' = trace(`TR')


	scalar `lnf' = -(.5*$T_T*$T_neqs)*ln(2*_pi) +			/*
		*/ .5*($T_T)*ln((det(`K')^2))/*
		*/ -(.5*$T_T)*`trace'

	if `todo' == 0 {
		exit
	}	

/* now calculate and insert gradient */

	
	mat `KIP' = `B''
	mat `Kr' = vec(`KIP')
	mat `Krp' = `Kr''
	mat `vecK' = vec(`K')
	mat `vecKp' = `vecK''
	mat `Q1' = $T_T*`Krp' -$T_T*`vecKp'*($T_sigma#I($T_neqs))


/* note lrK = C and T_Abar = Abar */

	mat `Q2' = -1*($T_Abari'*`Ci'')#`Ci'
	mat `g' = `Q1'*`Q2'

	if `todo' == 1 {
		exit
	}	

/* now calculate and insert expected information matrix */

	tempname In2 Kmm Q3 Q4 h2

	_mkkmn , k(`Kmm') m($T_neqs) n($T_neqs)

	mat `In2' = I(`base')

	mat `Q4' = (-I($T_neqs)#(`Ci''))
	mat `h' = $T_T*`Q4'*(`In2'+`Kmm')*`Q4''

end
