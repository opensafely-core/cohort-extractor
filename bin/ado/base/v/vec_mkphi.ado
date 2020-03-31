*! version 1.0.3  16jul2004
program define vec_mkphi
	version 8.2

	syntax namelist , 		///
		[			///
		p0mat(name)		///
		]


	_ckvec vec_mkphi
	
	local mlag = e(n_lags) 
	local eqs  = e(k_eq)

// p0mat is used to calculate orthogonalized or structural IRFs

	if "`p0mat'" != "" {
		capture noi confirm matrix `p0mat'
		if _rc > 0 {
			di as err "structural matrix not valid"
			di as err "cannot create " 		///
				"orthogonalized/structural IRFs"
			exit 498
		}

		if rowsof(`p0mat') != `eqs' | colsof(`p0mat') != `eqs' {
			di as err "structural matrix does not have "	///
				"the correct dimensions"
			di as err "cannot create " 		///
				"orthogonalized/structural IRFs"
			exit 498

		}

		
		local p0mult "*`p0mat'"
	}
	else {
		local p0mult 
	}
	
	local pm1 = `mlag' -1

	tempname A biga	 jmat atemp

	_vecmka `A'

	var_mkcompanion , mlag(`mlag') lm1(`pm1') eqs(`eqs')	///
		aname(`A') bigap(`biga') 

	if `pm1' > 0 {
		mat `jmat' = I(`eqs'), J(`eqs',`eqs'*`pm1',0)
	}
	else {
		mat `jmat' = I(`eqs')
	}
	
	mat `atemp' = I(`eqs'*`mlag')

	gettoken phi namelist:namelist
	mat `phi' = I(`eqs') `p0mult'

	foreach phi of local namelist {	
		mat `atemp' = `atemp'*`biga'
		mat `phi' = `jmat'*`atemp'*`jmat'' `p0mult'
	}

end

exit

This program computes the simple (unit) impulse response functions for vecm
models and puts the computations into matrices with the names specified to
the command.

syntax {list_of_names_for_new_matrices} ,


{list_of_names_for_new_matrices} list names for matrices that will hold
estimated impulse responses.

The number of names specified determines the number of steps for which the
impulse response functions are estimated.

EX

vec_mkphi phi1 phi2 , 

	will estimate the unit impulse response functions for steps 0 and 1
	The columns of each matrix correspond to the "from variables", i.e.
	the shock occur to these variables".  The rows correspond to the "to
	variables", i.e., the shock on the from variable affects the row
	variable.



