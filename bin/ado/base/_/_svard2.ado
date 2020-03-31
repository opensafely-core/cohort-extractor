*! version 1.0.5  21sep2010
program define _svard2
	version 8.0

	args todo b lnf g h

	tempname A B K TR trace det BI

	local eqn 0
	local base = $T_neqs*$T_neqs
	forvalues i = 1/$T_neqs {
		forvalues j = 1/$T_neqs {
			local ++eqn
			local eqnb = `base' + `eqn'
			tempname a_`j'_`i' b_`j'_`i'
			mleval `a_`j'_`i'' = `b', scalar eq(`eqn')
			mleval `b_`j'_`i'' = `b', scalar eq(`eqnb')
		}
	}


	mat `A' = J($T_neqs, $T_neqs, 0)
	mat `B' = J($T_neqs, $T_neqs, 0)

	forvalues i = 1/$T_neqs {
		forvalues j = 1/$T_neqs {
			mat `A'[`j',`i'] = `a_`j'_`i''
			mat `B'[`j',`i'] = `b_`j'_`i''
		}
	}

	capture mat `BI' = inv(`B')
	if _rc > 0 {
		di as err "B matrix is not invertible"
		exit 498
	}	

	capture mat `K' = `BI'*`A'
	if _rc > 0 {
		scalar `lnf' = .

		exit
	}	

	if matmissing(`K') {
		scalar `lnf' = .
		exit
	}	

	mat `TR' = (`K')'*`K'*$T_sigma
	scalar `trace' = trace(`TR')

	scalar `lnf' = -(.5*$T_T*$T_neqs)*ln(2*_pi) +		/*
		*/ .5*($T_T)*ln((det(`K')^2))/*
		*/ -(.5*$T_T)*`trace'

	if `todo' == 0 {
		exit
	}	

/* now calculate and insert gradient */

	tempname KIP Kr Krp vecK vecKp Q1 Q2 Q2a Q2b BIP Q4 KI
	

	capture mat `KIP' = inv(`K'')
	if _rc > 0 {
		scalar `lnf' = .
		exit
	}

	mat `Kr' = vec(`KIP')

	mat `Krp' = `Kr''
	mat `vecK' = vec(`K')

	mat `vecKp' = `vecK''
	mat `Q1' = $T_T*`Krp' -$T_T*`vecKp'*($T_sigma#I($T_neqs))
	
	mat `Q2a' = I($T_neqs)#`BI'
	mat `BIP' = inv(`B'')
	mat `Q2b' = -1*(`A''*`BIP')#`BI'

	mat `Q2' = `Q2a',`Q2b'

	mat `g' = `Q1'*`Q2'


	if `todo' == 1 {
		exit
	}	

/* now calculate and insert expected information matrix */

	tempname In2 Kmm Q3 h2

	_mkkmn , k(`Kmm') m($T_neqs) n($T_neqs)

	mat `In2' = I(`base')
	mat `KI' = `KIP''
	
	mat `Q4' = (`KI'#`BIP') \ -(I($T_neqs)#`BIP')
	mat `h' = $T_T*`Q4'*(`In2'+`Kmm')*`Q4''
end

