*! version 1.1.0  07mar2019
program define _svaridenlr, rclass
	local version = string(_caller())
	local vv : display "version `version':"
	version 8.0

	syntax , b(string) cnsk(numlist) neqs(integer) /*
		*/ sigma(string) bigt(integer) abar(string) abari(string) /*
		*/ [ impcns(numlist) ]

				/* b hold 2*eqs^2 x 1 vector of parameters
	 			 * for A and B matrices
				 * cnsa holds constraints for 
				 * parameters in A
				 * cnsb holds constraints for 
				 * parameters in B
				 * 
				 * neqs = number of equations
				 *
				 *sigma holds e(Sigma) from VAR
				 *
				 * bigT holds number of obs in VAR
				 */

	tempname lrK K BI b_ki C_ki bkic Nn Q1 Ci

	mat `lrK' = J(`neqs', `neqs', 0 )
	local base = `neqs'*`neqs'
	
	forvalues i = 1/`neqs' {
		forvalues j = 1/`neqs' {
			if `version' < 16 {
				local knames `" `knames' c_`j'_`i':_cons"'
			}
			else {
				local knames `" `knames' /C:`j'_`i'"'
			}
		}
	}

	mat `b_ki' = `b'
	mat colnames `b_ki' = `knames'

	`vv' ///
	getCmat , b(`b_ki') cnslist(`cnsk') bc(`bkic')
	mat `C_ki' = r(Cns)
	local cdim = colsof(`C_ki') - 1

	mat `C_ki' = `C_ki'[1...,1..`cdim']
	local rowski = rowsof(`C_ki')

	local eqn 0
	forvalues i = 1/`neqs' {
		forvalues j = 1/`neqs' {
			local ++eqn
			mat `lrK'[`j',`i']  = `bkic'[1,`eqn']
		}
	}


	capture mat `Ci' = inv(`lrK')
	if _rc > 0 {
		di as err "C matrix is singular"
		di as err "check identification restrictions and starting "/*
			*/ "values"
		if "`impcns'" != "" {
			constraint drop `impcns'
		}	
		exit 498
	}	

	mat `BI' = `Ci'*`abari'

	

	_mkkmn , k(`Nn') m(`neqs') n(`neqs')
	mat `Nn' = (I(`base') + `Nn')

	mat `Q1' = I(`neqs')#(`Ci')

	tempname I_aug I_augI

	mat `I_aug' = ( (`Q1'')*`Nn'*`Q1' ) \ `C_ki'
	mat `I_aug' = `I_aug''*`I_aug'
	mat `I_augI' = syminv(`I_aug')

	local rank 0
	forvalues i = 1/`base' {
		if `I_augI'[`i',`i'] > 1e-15 {
			local ++rank
		}
	}	

	local iden_rank = `base'

	if `rank' < `iden_rank' {
		di as err "{p 0 4 0}With the current starting values, "	/*
			*/ "the constraints are not sufficient for " 	/*
			*/ "identification{p_end}"

		local order = `neqs'^2-`neqs'*.5*(`neqs'+1)
		tempname C	
		`vv' ///
		getCmat , b(`bkic') cnslist(`cnsk' )	
		mat `C' = r(Cns)
		local colsc = colsof(`C')
		mat `C' = `C'[1...,1..`colsc'-1]
		mat `C' = `C'*`C''
		local nres = 0 
		local rowsc = rowsof(`C')
		mat `C' = syminv(`C')
		forvalues i = 1/`rowsc' {
			if `C'[`i',`i'] > 1e-16 {
				local ++nres
			}	
		}
		di as err "The constraints placed on C  are "
		constraint list `cnsk' 
		di as err "These constraints place `nres' "	/*
			*/ "independent constraints on C "
		di as err "The order condition requires at least "	/*
			*/ "`order' constraints"
		
		if "`impcns'" != "" {
			constraint drop `impcns'
		}	
		exit 498
	}

		

end


program define getCmat, rclass
	local version = string(_caller())
	local vv : display "version `version':"
	syntax , b(string) cnslist(numlist) [bc(string) ]

		/* b is 1 x k row vector with names that agree with 
		 * constraints in cnslist 
		 */

	tempname e_res bt v C T a C2 bca
	
	nobreak {
		capture _est hold `e_res'
		mat `v' = `b''*`b'
		mat `bt' = `b'
		eret post `bt' `v'
		if `version' < 16 {
			matrix makeCns `cnslist'
		}
		else {
			`vv' _makecns `cnslist'
		}

		mat `C' = get(Cns)
		if "`bc'" != "" {
			`vv' capture matcproc `T' `a' `C2'
			if _rc > 0 {
				di as err "the constraints: "
				matrix dispCns
				di as err "define a full rank constraint "/*
					*/ "matrix"
				di as err "the long-run constraint matrix "/*
					*/ "may not be of full rank"
				exit 498
			}
				
			mat `bca' = `b'*`T'
			mat `bc'  = `bca'*`T'' + `a'

			if `version' >= 16 {
				/* free-parameter stripe can be mangled	*/
				local stripe : colfullnames `b'
				mat colnames `bc' = `stripe'
			}
		}
		capture _est unhold `e_res'
	}

	ret matrix Cns = `C'
end
