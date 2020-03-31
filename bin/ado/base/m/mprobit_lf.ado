*! version 1.2.1  06jun2011
program mprobit_lf
	version 9

	args todo b lnf g negH

	/* compute utilities */
	local neq = 0
	forvalues i = 1/$MPROBIT_NALT {
		tempvar u`i'
		local util `"`util' `u`i''"'
		if `i' == $MPROBIT_BASE {
			gen double `u`i'' = 0
			/* one score variable generated by _mprobitEstimator */
			if (`todo'>0) local scrs `"`scrs' $MPROBIT_SCRS"'
		}
		else if `todo' < 0 {
			local eq : word `i' of $MPROBIT_ALTEQS
			matrix score double `u`i'' = `b', eq(`eq')
		}
		else {
			mleval `u`i'' = `b', eq(`++neq')
			if `todo' > 0 {
				local gi = 5 + `neq'
				local scrs `"`scrs' ``gi''"'
			}
		}
	}

	if (`todo' < 0) {
		/* computing probabilities for predict */
		local lf `6'
	}
	else {
		tempvar lf
		gen double `lf' = 0.0
	}
	mata: _mprobit_quadrature(`"$MPROBIT_CHOICE"',$MPROBIT_NALT,`"`util'"',`"`lf'"', ///
		`"`scrs'"',`todo',$MPROBIT_PROBITPARAM,`"$MPROBIT_QX"',`"$MPROBIT_QW"',	 ///
		`"$MPROBIT_TOUSE"')

	if (`todo' < 0) exit 0

	mlsum `lnf' = `lf'
	if (`todo'==0) exit 0

	if "$ML_ec" == "*" {
		exit
	}
	tempname g1
	local neq = 0
	local is = 0
	forvalues j = 1/$MPROBIT_NALT {
		if `j' == $MPROBIT_BASE {
			local `++is'
			continue
		}

		local si : word `++is' of `scrs'

		if `neq' == 0 {
			mlvecsum `lnf' `g' = `si', eq(`++neq')
		}
		else {
			mlvecsum `lnf' `g1' = `si', eq(`++neq')
			matrix `g' = (`g',`g1')
		}
	}
end

