*! version 1.0.2  14apr2011

program	_sspace_epost, eclass
	version 11

	syntax, obser_deps(string)					///
		k_state_err(integer) k_obser_err(integer) 		///
		dnames(string) [ state_deps(string) method(string)	///
		indeps(string) hidden ]

	tempname ilog z0 Rz0 A B C D F G R Q V grad

	ereturn local initial_values `r(initval)'
	ereturn scalar rank = r(rank)
	if "`r(vce)'" == "robust" {
		mat `V' = r(V_modelbased)
		mat rownames `V' = `dnames'
		mat colnames `V' = `dnames'
		ereturn matrix V_modelbased = `V'
	}
	mat `ilog' = r(ilog)
	mat `grad' = r(gradient)
	mat colnames `grad' = `dnames'

	mat `z0' = r(z0)
	local ncz = colsof(`z0')
	if (`ncz' == 1) mat colnames `z0' = state
	else {
		local `--ncz'
		if `ncz' > 1 {
			forvalues i=1/`ncz' {
				local znames `znames' diffuse`i'
			}
		}
		else local znames diffuse

		mat colnames `z0' = state `znames'
	}
	mat `A' = r(A)
	local k_state = rowsof(`A')

	if ("`state_deps'"!="") local state_lab `state_deps'
	else {
		forvalues i=1/`k_state' {
			local state_lab `state_lab' st`i'
		}
	} 
	mat colnames `A' = `state_lab'
	mat rownames `A' = `state_lab'

	mat rownames `z0' = `state_lab'
	ereturn `hidden' mat z0 = `z0'
	mat `Rz0' = r(chol_Sz0)
	mat colnames `Rz0' = `state_lab'
	mat rownames `Rz0' = `state_lab'
	ereturn `hidden' mat chol_Sz0 = `Rz0'

	if (r(p)<. & r(q)<.) {
		local p = r(p)
		local q = r(q)
		/* q1 should equal the # of factors			*/
		local q1 = r(q1)
		/* q2 should equal the # of obs eq			*/
		local q2 = r(q2)
		if `q2' {
			tempname Q2
			ereturn `hidden' local Q2_structure `r(Q2_struct)'

			forvalues i=1/`q2' {
				local qerr `qerr' e`i'
			}
			mat `Q2' = r(chol_Q2)
			mat colnames `Q2' = `qerr'
			mat rownames `Q2' = `qerr'
			ereturn `hidden' mat chol_Q2 = `Q2'
		}
		if `q1' {
			tempname Q1
			ereturn `hidden' local Q1_structure `r(Q1_struct)'

			local qerr
			forvalues i=1/`q1' {
				local qerr `qerr' v`i'
			}
			mat `Q1' = r(chol_Q1)
			mat colnames `Q1' = `qerr'
			mat rownames `Q1' = `qerr'
			ereturn `hidden' mat chol_Q1 = `Q1'
		}
	}
	else {
		ereturn `hidden' local Q_structure `r(Q_struct)'
		ereturn `hidden' local R_structure `r(R_struct)'

		cap mat li r(chol_R)
		if _rc == 0 {
			forvalues i=1/`k_obser_err' {
				local oerr `oerr' v`i'
			}
			mat `R' = r(chol_R)
			mat colnames `R' = `oerr'
			mat rownames `R' = `oerr'
			ereturn `hidden' mat chol_R = `R'
		}
		cap mat li r(chol_Q)
		if _rc == 0 {
			forvalues i=1/`k_state_err' {
				local serr `serr' e`i'
			}
			mat `Q' = r(chol_Q)
			mat colnames `Q' = `serr'
			mat rownames `Q' = `serr'
			ereturn `hidden' mat chol_Q = `Q'
		}
	}
	cap mat li r(G)
	if _rc == 0 {
		mat `G' = r(G)
		mat colnames `G' = `oerr'
		mat rownames `G' = `obser_deps'
		ereturn `hidden' mat G = `G'
	}
	cap mat li r(F)
	if _rc == 0 {
		mat `F' = r(F)
		mat colnames `F' = `indeps'
		mat rownames `F' = `obser_deps'
		ereturn `hidden' mat F = `F'
	}
	mat `D' = r(D)
	mat colnames `D' = `state_lab'
	mat rownames `D' = `obser_deps'
	ereturn `hidden' mat D = `D'
	cap mat li r(C)
	if _rc == 0 {
		mat `C' = r(C)
		mat colnames `C' = `serr'
		mat rownames `C' = `state_lab'
		ereturn `hidden' mat C = `C'
	}
	cap mat li r(B)
	if _rc == 0 {
		mat `B' = r(B)
		mat colnames `B' = `indeps'
		mat rownames `B' = `state_lab'
		ereturn `hidden' mat B = `B'
	}
	ereturn scalar stationary = r(stationary)
	if (!r(stationary)) & "`method'"!="kdiffuse" & "`method'"!="user" {
		tempname d

		cap mat li r(d)
		/* may not exist if optimization failed			*/
		if _rc == 0 {
			mat `d' = r(d)
			if (`ncz'==`k_state') mat rownames `d' = `state_deps'
			else mat rownames `d' = `znames'
		
			mat colnames `d' = diffuse
			ereturn `hidden' matrix d = `d'
			if `ncz' < `k_state' {
				mat `d' = r(T)
				ereturn `hidden' matrix T = `d'
				mat `d' = r(M)
				ereturn `hidden' matrix M = `d'
			}
		}
	}
	ereturn `hidden' mat A = `A'

	if ("`method'"=="") ereturn local method hybrid
	else ereturn local method `method'

	ereturn local vcetype `r(vce_type)'
	ereturn local vce `r(vce)'
	ereturn scalar ic = rowsof(`ilog')
	ereturn matrix ilog = `ilog'
	ereturn matrix gradient = `grad'
	ereturn scalar rc = r(rc)
	ereturn scalar converged = r(converged)
	ereturn scalar ll = r(ll)
	ereturn scalar rank = r(rank)
	ereturn local technique `r(technique)'
	ereturn local tech_steps `r(tech_steps)'
	ereturn local opt optimize
	ereturn hidden local crittype `r(crittype)'
end

exit
