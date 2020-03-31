*! version 1.1.1  26mar2019
program define _svariden, rclass
	local version = string(_caller())
	local vv : display "version `version':"
	version 8.0

	syntax , b(string) cnsa(numlist) cnsb(numlist) neqs(integer) /*
		*/ sigma(string) bigt(integer) 	[impcns(numlist) ]

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

	tempname A B K BI b_a b_b C_a C_b g bac bbc nres_m Nn tmp

	mat `A' = J(`neqs', `neqs', 0)
	mat `B' = J(`neqs', `neqs', 0)

	local base = `neqs'*`neqs'
	local base2 = `base'*2
	
	forvalues i = 1/`neqs' {
		forvalues j = 1/`neqs' {
			if `version' < 16 {
				local anames `" `anames' a_`j'_`i':_cons"'
				local bnames `" `bnames' b_`j'_`i':_cons"'
			}
			else {
				local anames `" `anames' /A:`j'_`i'"'
				local bnames `" `bnames' /B:`j'_`i'"'
			}

		}
	}

	mat `b_a' = `b'[1,1..`base']
	mat colnames `b_a' = `anames'

	local basep1 = `base' + 1
	mat `b_b' = `b'[1,`basep1'...]
	mat colnames `b_b' = `bnames'


	`vv' ///
	getCmat , b(`b_a') cnslist(`cnsa') bc(`bac') name(A)
	mat colnames `bac' = `anames'

	mat `C_a' = r(Cns)
	local cdim = colsof(`C_a') - 1

	mat `C_a' = `C_a'[1...,1..`cdim']
	local rowsa = rowsof(`C_a')

	`vv' ///
	getCmat , b(`b_b') cnslist(`cnsb') bc(`bbc') name(B)
	mat colnames `bbc' = `bnames'

	mat `C_b' = r(Cns)
	local cdim = colsof(`C_b') - 1
	mat `C_b' = `C_b'[1...,1..`cdim']
	local rowsb = rowsof(`C_b')
	

	mat `b' = `bac', `bbc'

	local eqn 0
	forvalues i = 1/`neqs' {
		forvalues j = 1/`neqs' {
			local ++eqn
			local eqnb = `base' + `eqn'

			mat `A'[`j',`i']  = `b'[1,`eqn']
			mat `B'[`j',`i']  = `b'[1,`eqnb']
	

		}
	}

	capture mat `BI' = inv(`B')
	if _rc > 0 {
		di as err "B matrix is singular"
		di as err "check identification restriction and "	/*
			*/ "starting values "
		if "`impcns'" != "" {
			constraint drop `impcns'
		}	
		exit 498
	}	

/* check that A is invertible */
	capture mat `tmp' = inv(`A')
	if _rc > 0 {
		di as err "A matrix is singular"
		di as err "check identification restriction and "	/*
			*/ "starting values "
		if "`impcns'" != "" {
			constraint drop `impcns'
		}	
		exit 498
	}	

	capture mat `K' = `BI'*`A'
	if _rc > 0 {
		di as err "could not form A matrix"
		if "`impcns'" != "" {
			constraint drop `impcns'
		}	
		exit 498
	}	

/* now make Nn for top part of V* matrix */


	
	_mkkmn , k(`Nn') m(`neqs') n(`neqs')
	mat `Nn' = .5*(I(`base') + `Nn')

	
	mat `C_a' = `C_a'*(`K''#`B')
	mat `C_a' = (`C_a',  J(`rowsa',`base',0)  )

	mat `C_b' = `C_b'*(I(`neqs') # `B')
	mat `C_b' = (J(`rowsb',`base',0)  ,`C_b')  
	

	tempname I_aug I_augI

	mat `I_aug' = ( (`Nn' , `Nn') \ (`Nn' , `Nn')  \ `C_a' \ `C_b')
	mat `I_aug' = `I_aug''*`I_aug'
	mat `I_augI' = syminv(`I_aug')

	local rank 0
	forvalues i = 1/`base2' {
		if `I_augI'[`i',`i'] > 1e-15 {
			local ++rank
		}
	}	

	local iden_rank = `base2'

	if `rank' < `iden_rank' {
		di as err "{p 0 4 0}With the current starting values, "	/*
			*/ "the constraints are not sufficient for " 	/*
			*/ "identification{p_end}"

			
		local order =2*`neqs'^2-`neqs'*.5*(`neqs'+1)
		tempname C	

		`vv' ///
		getCmat , b(`b') cnslist(`cnsa' `cnsb')	name(A and B)
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
		di as err "The constraints placed on A and B are "
		constraint list `cnsa' `cnsb'
		di as err "{p 0 4 0}These constraints place `nres' "	/*
			*/ "independent constraints on A and B{p_end}"
		di as err "The order condition requires at least "	/*
			*/ "`order' constraints."
		di as err "{p 0 4 0}Identification requires a rank "	///
			"of `iden_rank', but the "			///
			"identification matrix only has rank "		///
			"`rank'{p_end}"
		if "`impcns'" != "" {
			constraint drop `impcns'
		}	
		exit 498
	}

end


program define getCmat, rclass
	local version = string(_caller())
	local vv : display "version `version':"
	version 8.0

	syntax , b(string) cnslist(numlist) name(string) [bc(string) ]

		/* b is 1 x k row vector with names that agree with 
		 * constraints in cnslist 
		 */

	tempname e_res bt v C T a C2 bca Ci
	tempvar samp
	
	nobreak {
		capture _est hold `e_res', copy restore nullok 	/*
			*/ varname(`samp')
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
			`vv' cap noi matcproc `T' `a' `C2'
			if _rc == 0 {
				mat `bca' = `b'*`T'
				mat `bc'  = `bca'*`T'' + `a'
			}	
			else {
				local cdim = colsof(`C') 
				local cdim1 = `cdim'- 1
				mat `C2' = `C'[1...,1..`cdim1']
				capture noi mat `Ci' = inv(`C2')
				if _rc == 0 {
					mat `bc' = (`Ci'*`C'[1...,`cdim'])'
				}
				else {
					di as err "constraints on `name' "/*
						*/ "are not consistent"
					exit 498	
				}
			}
		}
		capture _est unhold `e_res'
	}

	ret matrix Cns = `C'
end
