*! version 1.0.2  16jul2004
program define vec_fevd
	version 8.2

	syntax namelist(name=fevdmats id="fevd matrix names") , 	///
		pmats(string)						///
		[ mse ]


	_ckvec vec_fevd
	
	local eqs  = e(k_eq)

// pmats are orthogonalized or structural impulse response functions

	capture confirm names `pmats'
	if _rc > 0 { 
		di as err "names of orthogonalized/structural IRF "	///
			"matrices are not valid"
		di as err "cannot estimate FEVDs"
		exit 498
	}

	local step : word count `pmats'
	local ck : word count `fevdmats'
	

	foreach mat of local pmats {

		capture noi confirm matrix `mat'
		if _rc > 0 {
			di as err ""orthogonalized/structural IRF "	///
				"matrix not valid"
			di as err "cannot estimate FEVDs"
			exit 498
		}

		if rowsof(`mat') != `eqs' | colsof(`mat') != `eqs' {
			di as err ""orthogonalized/structural IRF "	///
				" matrix does not have the correct dimensions"
			di as err "cannot estimate FEVDs"
			exit 498
		}
	}

	tempname M E F Ik

	mat `M' = J(`eqs',`eqs', 0)
	mat `E' = J(`eqs',`eqs', 0)
	mat `Ik' = I(`eqs')
	
	if "`mse'" == "" {
		local cnt = 1

		gettoken fevd fevdmats:fevdmats
		mat `fevd' = `E'

		foreach fevd of local fevdmats {	
			local pmat : word `cnt' of `pmats'

			mat `M' = hadamard(`pmat',`pmat')  + `M'
			mat `E' = `pmat'*(`pmat'') + `E'
			mat `F' = hadamard(`E',`Ik')

			mat `fevd' = syminv(`F')*`M'
			local ++cnt
		}
	}
	else {
		local cnt = 1
		gettoken fevd fevdmats:fevdmats
		mat `fevd' = `E'

		foreach fevd of local fevdmats {	
			local pmat : word `cnt' of `pmats'

			mat `E' = `pmat'*(`pmat'') + `E'
			mat `F' = hadamard(`E',`Ik')

			mat `fevd' = (`F')
			local ++cnt
		}

	}
end

exit


This program calculates the FEVD matrices given a set of
orthogonalized\structural impulse response function matrices


syntax 

vec_fevd  {namelist_1} , pmats(namelist_2)


namelist_1 is a list of names for the new FEVD matrices.  The number of names
determines the number of steps computed.  The number of names in namelist_1
must be the same as the number of names in namelist_2, which holds the names
of the orthogonalized/structural IRF matrices used to compute the FEVDs.

namelist_2 holds the names of the orthogonalized/structural IRF matrices
used to compute the FEVDs.
