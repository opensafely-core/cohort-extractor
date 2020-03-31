*! version 1.0.1  04apr2011
program _asprobit_diparm
	version 12

	if e(k_factors) < . {
		exit
	}

	local cholesky = e(cholesky)
	if (`cholesky' != 0) exit

	local nalt = e(k_alt)

	local idx 0
	if !e(fullcov) local P P
	if e(k_sigma) > 0 {
		Sigma `idx' `P'
	}
	if e(k_rho) > 0 {
		Rho `idx' `P'
	}
end

program Sigma, eclass
	args idx P
	local nalt = e(k_alt)
	forvalues i = 1/`nalt' {
		if (el(e(stdpattern),1,`i') >= .) {
			if (`i'==e(i_base)) {
				local cmnt "(base alternative)"
			}
			else if (`i'==e(i_scale)) {
				local cmnt "(scale alternative)"
			}
			else	local cmnt "(fixed)"

			local ++idx
			ereturn hidden local diparm`idx'		///
				__lab__,			///
				label(sigma`i')			///
				value(`=el(e(stdfixed),1,`i')')	///
				comment("`cmnt'")
		}
		else {
			if e(fullcov) {
				local ii `i'
			}
			else	local ii = el(e(stdpattern),1,`i')

			local ++idx
			ereturn hidden local diparm`idx'		///
				lnsigma`P'`ii',			///
				label(sigma`i')			///
				exp
		}
	}
	c_local idx `idx'
end

program Rho, eclass
	args idx P
	local nalt = e(k_alt)
	c_local idx `idx'

	if (e(k_sigma) > 0) {
		local ++idx
		ereturn hidden local diparm`idx' __sep__
	}
	forvalues j=1/`nalt' {
		local j1 = `j'+1
	forvalues i=`j1'/`nalt' {
		if e(fullcov) {
			local ij `i'_`j'
		}
		else	local ij = el(e(corpattern),`i',`j')

		if (el(e(corpattern),`i',`j') >= .) {
			if `i'== e(i_base) | `j' == e(i_base) {
				if (el(e(corfixed),`i',`j')==0) {
					continue
				}
				else	local cmnt "(base alternative)"
			}
			else {
				local cmnt "(fixed)"
			}

			local ++idx
			ereturn hidden local diparm`idx'		///
				__lab__,				///
				label(rho`i'_`j')			///
				value(`=el(e(corfixed),`i',`j')')	///
				comment("`cmnt'")
		}
		else {
			local ++idx
			ereturn hidden local diparm`idx'	///
				atanhr`P'`ij',			///
				tanh				///
				label(rho`i'_`j')
		}

	} // i
	} // j
end

exit
