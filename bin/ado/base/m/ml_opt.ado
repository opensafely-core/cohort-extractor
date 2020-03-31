*! version 7.4.5  04feb2015
program define ml_opt
	version 6 
	syntax [, DIFficult EIGEN(real 1e-7) noWARNing]
		/* eigen() should not have to be reset; it only applies
		   to -difficult- method.
		*/

	local sayback 6  /* print out "(backed up)" if it backed up `sayback' or
	                    more times */

	if "`difficu'"=="" {
		local inverse "Inverse"
		local ncstep  "NCStep"
	}
	else {
		local inverse "DiffInv"
		local ncstep  "DiffStep"
	}

	if `:length global ML_evalp' {
		local precall PreIterEval
	}

	if $ML_trace==1       { local dilike "DiLike" }
	else if $ML_trace==0  { local dilike "*" }

	if $ML_trace>1 | $ML_dider  { local dilike "DiLikeTr" }
	else local tr "*"
		/* `tr'=="" => display BIG iteration log, set off by dashes */

	if "$ML_nrsho" != "" & $ML_trace != 0 {
		local dinrval "DiNRvalue"
	}
	else	local dinrval "*"

	if $ML_trace==2 | $ML_trace==4 { local dicoef "DiCoef" }
		/* display coefficient vector */

	if $ML_dider | $ML_trace > 2 { local dider "DiDer" }
	else local dider "*"
		/* display gradient length, gradient vector, and/or hessian */

	if $ML_dider < 2 { local saveH "*" }

	`tr'   $ML_dots
	`tr'   di in smcl in gr "{hline 78}" _n "Iteration 0:"
	`dicoef'

	if $ML_C {	/* initial points for constraint model */ 
		mat $ML_b = $ML_b*$ML_CT
		mat $ML_b = $ML_b*$ML_CT' + $ML_Ca
	}

	$ML_eval 2
	if scalar($ML_f)==. {
		di in red "initial values not feasible"
		exit 1400
	}
	ml_log
	
	if $ML_C { 		/* unconstraint => constraint */
		mat $ML_b = ($ML_b-$ML_Ca)*$ML_CT
		mat $ML_V = $ML_CT'*$ML_V*$ML_CT
		mat $ML_g = $ML_g*$ML_CT
	}


	tempname b0 f0 H gPg bPb
	local kback 0
	local nc_ct 0
	local back_ct 0
	local ic 1
	local conv 0
	while !`conv' & `ic'<=$ML_iter {
		if "`tr'" == "*" {
			$ML_dots
		}
		`precall'
		scalar `f0' = scalar($ML_f)
		mat `b0' = $ML_b
		`saveH' mat `H' = $ML_V
		`inverse'
		local notcc = r(notcc)
		if `notcc' {
			`dilike' "(not concave)"
			`dinrval' `nrval'
			`dider' `H'
			`ncstep' `eigen'
			local kback 0
			local nc_ct = `nc_ct' + 1
		}
		else {
			if `kback' >= `sayback' {
				`dilike' "(backed up)"
				`dinrval' `nrval'
					/* when it stepped to this point, it
					   did `sayback' or more step halvings
					*/
				local back_ct = `back_ct' + 1
			}
			else {
				`dilike'
				`dinrval' `nrval'
				local back_ct 0
			}

			`dider' `H'
			Step
			local kback = r(k_back)
			local nc_ct = 0
		}

		`tr' $ML_dots
		`tr' di in smcl in gr "{hline 78}" _n "Iteration `ic':"
		`dicoef'

		if `ic' == 1 & $ML_iton1 {
			continue, break
		}
		if `ic' == $ML_iter & $ML_stpal {
			global ML_ic = $ML_ic + 1
			continue, break
		}

		CnsEval 2 text

		if scalar($ML_f) == . {
			di in red "discontinuous region encountered"
			di in red "cannot compute an improvement"
			exit 430
		}

		if `ic' == 1 {
			chk4scores
		}

		ml_log

		local conv = mreldif(matrix($ML_b),`b0')<=$ML_tol | /*
		*/ reldif(scalar($ML_f),`f0')<=$ML_ltol

		if `conv' {
			if "$ML_gtol" != "" {
				ChkGrad
				local conv = ( r(grad_ok) /*
				*/ | `back_ct' > 30 | `nc_ct' > 30)
			}
		}
		if (`conv' & "$ML_nrtol" != "") {
			ChkNRtol conv nrval :
			if `conv' {
				local kback 0
			}
		}
		else {
			local nrval
		}

		local ic = `ic' + 1
	}

	$ML_dots
	`precall'
	`saveH' mat `H' = $ML_V
	if "$ML_noinv" == "" {
		capture mat $ML_V = syminv($ML_V)
		if _rc {
			di in red "Hessian has become unstable or asymmetric"
			exit _rc
		}
	}
	local notcc = diag0cnt(matrix($ML_V))
	if `notcc' {
		_ms_omit_info $ML_V
		local dim = colsof(r(omit))
		local notcc = 0
		forval i = 1/`dim' {
			if $ML_V[`i',`i'] == 0 & el(r(omit),1,`i') == 0 {
				local ++notcc
				continue, break
			}
		}
	}
	if `notcc' {
		`dilike' "(not concave)"
		`dinrval' `nrval'
	}
	else if `kback' >= `sayback' {
		`dilike'  "(backed up)"
		`dinrval' `nrval'
	}
	else {
		`dilike'
		`dinrval' `nrval'
	}
	`dider' `H'

	`tr' di in smcl in gr "{hline 78}"

	if `conv' {
		global ML_rc 0
		global ML_conv 1
	}
	else if "`warning'" == "" {
		if $ML_rc { di in red "convergence not achieved" }
		else	  { di in blu "convergence not achieved" }
	}
	
	if $ML_C { 		/* constraint => unconstraint */
		mat $ML_b = $ML_b*$ML_CT' + $ML_Ca
		mat $ML_V = $ML_CT*$ML_V*$ML_CT'
		mat $ML_g = $ML_g*$ML_CT'
	}

end

program chk4scores
	version 8.0
	if "$ML_sclst" != "" & ///
	("$ML_vce" == "robust" | "$ML_vce2" == "OPG") {
		local opt = cond("$ML_vce"=="robust","robust","vce(opg)")
		local ok 0
		foreach var of global ML_sclst {
			capture assert missing(`var')
			if (_rc) local ++ok
		}
		if !`ok' {
			di as err ///
	"$ML_user failed to compute scores required by the `opt' option"
			exit 504
		}
	}
end

program define DiLike /* "message" */
	local ic = $ML_ic - 1
	di in smcl in gr "Iteration `ic':" _col(16) "$ML_crtyp = " /*
	*/ in ye %10.0g scalar($ML_f) in blu "  `*'"
end

program DiNRvalue
	args val
	if "`val'" == "" {
		exit
	}
	local nrname "g inv(H) g'"
	local len1 = length("$ML_crtype")
	local len2 = length("`nrname'")
	if $ML_trace == 1 {
		local col = 16 + max(`len1',`len2') - 1
		di in smcl as txt _col(16) "`nrname'" _col(`col') " = " ///
			in ye %10.0g `val'
	}
	else {
		local col = 66 - `len2'
		di in smcl as txt _col(`col') "`nrname' = " ///
			in ye %10.0g `val'
	}
end

program define DiLikeTr /* "message" */
	*if $ML_trace == 2 { local nl "_n" }
	local col = 66-length("$ML_crtyp")
	di `nl' in gr _col(`col') "$ML_crtyp = " in ye %10.0g scalar($ML_f)

	if "`*'"!="" {
		local col = 79 - length("`*'")
		di in blu _col(`col') "`*'"
	}
end

program define DiCoef
	di in gr "Coefficient vector:"
	mat list $ML_b, noheader noblank format(%9.0g)
	di /* blank line */
end

program define DiDer
	args H
	tempname c
	mat `c' = $ML_g*$ML_g'

	if $ML_dider == 0 | ($ML_dider == 2 & $ML_trace == 3) {
		di in gr "Gradient vector length =" in ye %9.0g sqrt(`c'[1,1])
		if $ML_dider == 0 { exit }
		di /* blank line */
	}

	if $ML_dider == 1 {
		version 11: _cpmatnm $ML_b, vec($ML_g)
	}
	else if $ML_dider == 2 {
		version 11: _cpmatnm $ML_b, square(`H')
	}
	else	version 11: _cpmatnm $ML_b, vec($ML_g) square(`H')

	if ($ML_dider == 1 | $ML_dider == 3) /*
	*/ & (bsubstr("$ML_meth",3,.)!="debug" | $ML_trace == 4) {
		di in gr "Gradient vector (length =" in ye %9.0g /*
		*/ sqrt(`c'[1,1]) in gr "):"
		mat list $ML_g, noheader noblank format(%9.0g)
		local newline "_n"
	}
	if $ML_dider > 1 & bsubstr("$ML_meth",3,.)!="debug" {
		di `newline' in gr "Negative Hessian:"
		mat list `H', noheader noblank format(%9.0g)
	}
end

program define Inverse, rclass
	tempname H
	mat rename $ML_V `H', replace
	if "$ML_noinv" == "" {
		capture mat $ML_V = syminv(`H')
		if _rc {
			di in red "Hessian has become unstable or asymmetric"
			exit _rc
		}
	}
	else	mat $ML_V = `H'
	IsOk `H' $ML_V
	if r(okay) {
		return scalar notcc = 0	/* meaning not concave is FALSE */
		exit
	}
	return scalar notcc = 1		/* meaning not concave is TRUE	*/
	if "$ML_noinv" != "" {
		capture mat `H' = syminv($ML_V)
		if _rc {
			di in red "Hessian has become unstable or asymmetric"
			exit _rc
		}
	}

	tempname origt amt adj
	scalar `origt' = trace($ML_V)
	scalar `amt' = 1.1			/* amt must be > 1	*/
	while !r(okay) {
		local dim = matrix(colsof(`H'))
		local i 1
		while `i' <= `dim' {
			mat `H'[`i',`i'] = `H'[`i',`i']+`amt'*abs(`H'[`i',`i'])
			local i = `i' + 1
		}
		scalar `amt' = 2*`amt'
		capture mat $ML_V = syminv(`H')
		if _rc {
			di in red "Hessian has become unstable or "	/*
				*/ "asymmetric (NC)"
			exit _rc
		}
		IsOk `H' $ML_V
	}
	scalar `adj' = `origt'/trace($ML_V)
	if `adj' > 0 {
		mat $ML_V = `adj'*$ML_V
	}
end

program define DiffInv, rclass
	tempname Hinv
	if "$ML_noinv" == "" {
		capture mat `Hinv' = syminv($ML_V)
		if _rc {
			di in red "Hessian has become unstable or "	/*
				*/ "asymmetric (D)"
			exit _rc
		}
	}
	else	mat `Hinv' = $ML_V
	IsOk $ML_V `Hinv'
	if r(okay) {
		mat rename `Hinv' $ML_V, replace
		return scalar notcc = 0	/* meaning not concave is FALSE */
		exit
	}
	return scalar notcc = 1		/* meaning not concave is TRUE	*/
	if "$ML_noinv" != "" {
		capture mat `H' = syminv($ML_V)
		if _rc {
			di in red "Hessian has become unstable or asymmetric"
			exit _rc
		}
	}
end

program define IsOk /* H invH */, rclass
	args H V
	if diag0cnt(matrix(`V'))==0 {
		return scalar okay = 1
		exit
	}
	if diag0cnt(matrix(`H'))==0 {
		return scalar okay = 0
		exit
	}
	local dim = matrix(colsof(`H'))
	local i 1
	while `i' <= `dim' {
		if `V'[`i',`i']==0 & `H'[`i',`i']!=0 {
			return scalar okay = 0
			exit
		}
		local i = `i' + 1
	}
	return scalar okay = 1
end

program define Step, rclass
	if $ML_trace < 3 { local show "*" }

	tempname f0 b0 d
	scalar `f0' = scalar($ML_f)
	mat `b0' = $ML_b
	mat `d' = $ML_g*$ML_V
	mat $ML_b = `d' + $ML_b

	`show' DiStep `d'

	CnsEval 0 -1
	`show' DiLikeTr

	if scalar($ML_f)==. | scalar($ML_f)<`f0' {
		`show' di in blu _col(61) "(initial step bad)"
		Backward `f0' `b0' 60
		return scalar k_back = r(k_back)
		exit
	}

	`show' di in blu _col(60) "(initial step good)"

	Forward `f0' `b0' `d' 0.125 2

	return scalar k_back = 0
end

program define DiStep
	args step
	tempname c
	mat `c' = `step'*`step''

	if $ML_trace == 3 {
		if !$ML_dider {
			di in gr "Step length            =" /*
			*/ in ye %9.0g sqrt(`c'[1,1]) _n /*
			*/ in gr "Stepping b + step -> new b"
		}
		else {
			di _n in gr "Step length =" /*
			*/ in ye %9.0g sqrt(`c'[1,1]) _n /*
			*/ in gr "Stepping b + step -> new b"
		}
		exit
	}

	version 11: _cpmatnm $ML_b, vec(`step')
	di _n in gr "Step (length =" in ye %9.0g sqrt(`c'[1,1]) in gr "):"
	mat list `step', noheader noblank format(%9.0g)

	di _n in gr "b + step -> new b:"
	mat list $ML_b, noheader noblank format(%9.0g)
	di /* blank line */
end

program define NCStep, rclass
	if $ML_trace < 3 { local show "*" }

	tempname f0 b0 d
	scalar `f0' = scalar($ML_f)
	mat `b0' = $ML_b
	mat `d' = $ML_g*$ML_V    /* Newton-Raphson step */

	Stepsize `f0' $ML_g `d'  /* `d' = scaled Newton-Raphson step. */

	mat $ML_b = `d' + $ML_b

	`show' DiStep `d'

	CnsEval 0 -1
	`show' DiLikeTr

	if scalar($ML_f)==. | scalar($ML_f)<`f0' {
		`show' di in blu _col(61) "(initial step bad)"
		Backward `f0' `b0' 60
		return scalar k_back = r(k_back)
		exit
	}

	`show' di in blu _col(60) "(initial step good)"

	Forward `f0' `b0' `d' 1 2

	return scalar k_back = 0
end

program define Backward, rclass /* routine does NOT reset `f0' or `b0'  */
	args f0 b0 maxhalf message

			/* f0      = previous log likelihood (crit) value
			   b0      = previous vector of coefficients
			   maxhalf = maximum number of step halvings allowed
			   message = additional message to display, if any
	                */

	if $ML_trace >= 3 {
		tempname c
		mat `c' = $ML_b - `b0'
		mat `c' = `c'*`c''
		scalar `c' = sqrt(`c'[1,1])
	}
	else	local sdv "*"

	if $ML_trace!=3 { local sd "*" } /* 3 = show description only */
	if $ML_trace!=4 { local sv "*" } /* 4 = show vectors          */

	local istep 1
	while `istep'<=`maxhalf' & (scalar($ML_f)==. | scalar($ML_f)<`f0') {
		mat $ML_b = ($ML_b + `b0')/2

		`sdv' scalar `c' = 0.5*`c'
		`sv' di _n in gr "(`istep') Reducing step size (step " /*
		*/ "length =" in ye %9.0g `c' in gr ")`message' -> new b:"
		`sv' mat list $ML_b, noheader noblank format(%9.0g)
		`sv' di /* blank line */
		`sd' di in gr "(`istep') Reducing step size`message', " /*
		*/ "step length =" in ye %9.0g `c'

		CnsEval 0 -1
		`sdv' DiLikeTr
		local istep = `istep' + 1
	}

	if `istep' > `maxhalf' { mat $ML_b = `b0' }

	return scalar k_back = `istep' - 1
end

program define Forward /* routine resets `f0' and `b0' */
	args f0 b0 d start inc message

			/* f0      = previous log likelihood (crit) value
			   b0      = previous vector of coefficients
			   d       = step direction
			   start   = initial stepsize
			   inc     = stepsize increase for next step
			   message = additional message to display, if any
	                */

	mat `d' = `start'*`d'

	if $ML_trace >= 3 {
		tempname c
		mat `c' = `d'*`d''
		scalar `c' = sqrt(`c'[1,1])
	}
	else	local sdv "*"

	if $ML_trace!=3 { local sd "*" } /* 3 = show description only */
	if $ML_trace!=4 { local sv "*" } /* 4 = show vectors          */

	local istep 1
	while `istep'==1 | (scalar($ML_f)>`f0' & scalar($ML_f)!=.) {
		scalar `f0' = scalar($ML_f)
		mat `b0' = $ML_b
		mat $ML_b = `d' + `b0'

		`sv' di _n in gr "(`istep') Stepping forward (step length =" /*
		*/ in ye %9.0g `c' in gr ")`message' -> new b:"
		`sv' mat list $ML_b, noheader noblank format(%9.0g)
		`sv' di /* blank line */
		`sd' di in gr "(`istep') Stepping forward`message', " /*
		*/ "step length =" in ye %9.0g `c'

		CnsEval 0 -1
		`sdv' DiLikeTr

		mat `d' = `inc'*`d'
		`sdv' scalar `c' = `inc'*`c'

		local istep = `istep' + 1
	}
	`sdv' di in blu _col(59) "(ignoring last step)"

	mat $ML_b = `b0'
end

program define Stepsize
	args f g d
/*
    Input:  f = log likelihood (crit) value for scaling
    Input:  g = gradient vector
    Input:  d = step direction
    Output: d = c*d = scaled step direction

    Computes length of steepest-ascent stepsize:

	(change in f) = gradient * step',

	where  step = c * d  and  (change in f) = eps * |f|

    Thus,

	c = eps * |f| / gradient * d

    The parameter eps is chosen according to the following rules:

    1. lower <= eps <= upper.

    2. If iteration <=2, then eps = upper.

    3. If iteration > 2, then eps = 0.1*(fractional improvement of the
       log likelihood (crit) in the last iteration).  If eps < lower, it is set
       to lower; if eps > upper, it is set to upper.

   Note:  The value of eps only affects efficiency since we step half or step
   double from initial step.  Based on many tests, it is better for it to
   be too small than too large.  Hard problems prefer it to be small.
*/
	tempname upper lower eps last
	scalar `upper' = 1e-2  /* upper limit on eps */
	scalar `lower' = 1e-8  /* lower limit on eps */

	if $ML_ic <= 2 { scalar `eps' = `upper' }
	else {
		scalar `last' = ( ML_log[1,mod($ML_ic-1,20)+1]   /*
		*/              - ML_log[1,mod($ML_ic-2,20)+1])  /*
		*/           /abs(ML_log[1,mod($ML_ic-2,20)+1])

		scalar `eps' = min(`upper', max(`lower',0.1*`last'))
	}

	tempname c
	mat `c' = `g'*`d''
	tempname fctr
	scalar `fctr' = (`eps'*abs(`f')/`c'[1,1]) 
	if `fctr' == . { scalar `fctr' = 2 }
	mat `d' = `fctr' * `d'
end

program define DiffStep
	args eigen     /* eigen = cutoff for eigenvalues (default 1e-7) */
	local maxnc 10 /* maximum number of halving steps in nonconcave space */

/* Notes:

   `eigen' value of 1e-7 is based on experience.  This is a key parameter.

   `maxnc' value does occasionally get reached.  If we back up 3 or 4 times in
   nonconcave space, then it is a bad direction (from the position after the
   concave step) and it is highly likely will back up until the step is zero.
   For efficiency, it is best to stop this backing up fairly quickly.  This is
   not a problem since we just go back to the concave step result.
*/

	if $ML_trace!=3 { local sd "*" }  /* 3 = show description only */
	if $ML_trace!=4 { local sv "*" }  /* 4 = show vectors          */
	if $ML_trace< 3 { local sdv "*" } /* 3 or 4                    */

	tempname b0 f0 f00 X Xk lam gx d c

	mat `b0' = $ML_b
	scalar `f0' = scalar($ML_f)
	scalar `f00' = `f0'

/* Compute eigenvectors and eigenvalues. */

	mat symeigen `X' `lam' = $ML_V

	`sdv' di _n in gr "Dividing space into concave/nonconcave regions " /*
	*/ "based on eigenvalues " _n "of negative Hessian" _c
	`sv' di in gr ":"
	`sv' mat list `lam', noblank noheader nonames format(%9.0g)
	`sd' di

	mat `gx' = $ML_g*`X'  /* gradient in `X' metric */
	local dim = matrix(colsof(`lam'))

/* Split off all eigenvectors with eigenvalues >= `eigen'*(largest one) */

	if `lam'[1,1] > 0 & `dim' >= 2 {
		local k `dim'
		while `k'>=2 & `lam'[1,`k']<`eigen'*`lam'[1,1] {
			local k = `k' - 1
		}
		local k = min(`k', `dim' - 1)

	/* Compute Newton-Raphson step for large-eigenvalue space. */

		mat `d'   = `gx'[1,1..`k']
		mat `Xk'  = `X'[1...,1..`k']
		capture mat `d'   = `d'*syminv(diag(`lam'[1,1..`k']))*`Xk''
		if _rc {
			di in red "Hessian has become unstable or "	/*
				*/ "asymmetric (D2)"
			exit _rc
		}
		mat $ML_b = `d' + `b0'

		`sdv' mat `c' = `d'*`d''
		`sv' di _n in gr "Concave-space (dim = " in ye "`k'" in gr  /*
		*/ ") Newton-Raphson step (length =" in ye %9.0g /*
		*/ sqrt(`c'[1,1]) in gr "):"
		`sv' version 11: _cpmatnm $ML_b, vec(`d')
		`sv' mat list `d', noheader noblank format(%9.0g)
		`sv' di _n in gr "b + step -> new b:"
		`sv' mat list $ML_b, noheader noblank format(%9.0g)
		`sv' di /* blank line */
		`sd' di _n in gr "Concave-space (dim = " in ye "`k'" in gr /*
		*/ ") Newton-Raphson step length =" in ye %9.0g sqrt(`c'[1,1])
		`sd' di in gr "Stepping b + step -> new b"

		CnsEval 0 -1
		`sdv' DiLikeTr

		if scalar($ML_f)==. | scalar($ML_f)<`f0' {
			`sdv' di in blu _col(61) "(initial step bad)"
			Backward `f0' `b0' 60 " in concave space"
			scalar `f0' = scalar($ML_f)
			mat `b0' = $ML_b
		}
		else {
			`sdv' di in blu _col(60) "(initial step good)"
			Forward `f0' `b0' `d' 0.125 2 " in concave space"
		}
	}
	else 	local k 0

/* Split off eigenvectors for small positive and negative eigenvalues. */

	local k = `k' + 1  /* max `k' above is `dim' - 1; min `k' is 0 */
	mat `d'  = `gx'[1,`k'..`dim']
	mat `Xk' = `X'[1...,`k'..`dim']

	Stepsize `f00' `d' `d'  /* compute step = scalar * `d' */

	mat `d' = `d'*`Xk''     /* `d' in standard metric; note `Xk'
	                           is a unitary matrix, so this does
	                           not affect the computation by Stepsize
			        */

	mat $ML_b = `d' + `b0'

	`sdv' local dimk = `dim' - `k' + 1
	`sdv' mat `c' = `d'*`d''
	`sv' di _n in gr "Nonconcave-space (dim = " in ye "`dimk'" in gr ") " /*
	*/ "steepest-ascent step (length =" in ye %9.0g sqrt(`c'[1,1]) /*
	*/ in gr "):"
	`sv' version 11: _cpmatnm $ML_b, vec(`d')
	`sv' mat list `d', noheader noblank format(%9.0g)
	`sv' di _n in gr "b + step -> new b:"
	`sv' mat list $ML_b, noheader noblank format(%9.0g)
	`sv' di /* blank line */
	`sd' di _n in gr "Nonconcave-space (dim = " in ye "`dimk'" in gr ") " /*
	*/ "steepest-ascent step length =" in ye %9.0g sqrt(`c'[1,1])
	`sd' di in gr "Stepping b + step -> new b"

	CnsEval 0 -1
	`sdv' DiLikeTr

	if scalar($ML_f)==. | scalar($ML_f)<`f0' {
		`sdv' di in blu _col(61) "(initial step bad)"
		Backward `f0' `b0' `maxnc' " in nonconcave space"

		if scalar($ML_f)==. | scalar($ML_f)<`f0' {
			`sdv' di in blu _col(47) /*
			*/ "(going back to last improvement)"
			mat $ML_b = `b0'
		}
		exit
	}

/* If here, it was an improvement, try stepping forward. */

	`sdv' di in blu _col(60) "(initial step good)"

	Forward `f0' `b0' `d' 1 2 " in nonconcave space"
end


program define ChkGrad, rclass
	local cols = colsof($ML_b)
	local i 1
	while `i' <= `cols' {
		if abs($ML_g[1,`i'])*(abs($ML_b[1,`i']) + 1e-7) > $ML_gtol {
			return scalar grad_ok = 0
			exit
		}
		local i = `i' + 1
	}
	return scalar grad_ok = 1
end


// Check Newton-Raphson tolerance

program ChkNRtol
	version 8

	args conv val colon

	c_local `conv' 0

	tempname C gHgp
	capture mat `C' = syminv($ML_V)
	if _rc {
		di in red "Hessian has become unstable or asymmetric"
		exit _rc
	}

	if "$ML_noinv" == "" {
		IsOk $ML_V `C'
		if (! r(okay))  exit

		matrix `gHgp' = $ML_g * `C' * $ML_g'
	}
	else {
		IsOk `C' $ML_V
		if (! r(okay))  exit

		matrix `gHgp' = $ML_g * $ML_V * $ML_g'
	}

	c_local `val' = `gHgp'[1,1]
	c_local `conv' = `gHgp'[1,1] < $ML_nrtol
end

program define PreIterEval
	// NOTE: The users $ML_evalp command should not change $ML_b.
	tempname b
	if $ML_C { 
		mat `b' = $ML_b*$ML_CT' + $ML_Ca
	}
	else	local b $ML_b
	$ML_evalp `b'
end

program define CnsEval /* code  */ 
	args c dottype

/* structure:	constraints => unconstraints
		$ML_eval `c'
		unconstraints => constraints
*/
	if $ML_C { 
		mat $ML_b = $ML_b*$ML_CT' + $ML_Ca
		mat $ML_V = $ML_CT*$ML_V*$ML_CT'	// needed by DFP, BFGS
	}
	$ML_eval `c' `dottype'
	if $ML_C {
		mat $ML_b = ($ML_b-$ML_Ca)*$ML_CT
		mat $ML_V = $ML_CT'*$ML_V*$ML_CT	// needed by DFP, BFGS
		if (`c' == 2) & ($ML_f != .) {
			mat $ML_g = $ML_g*$ML_CT
		} 
	}
end
	
		

exit

************ Code below is for looking in gradient direction ************

*---- in NCStep

TrySteps $ML_g

*---- in DiffStep

tempname dx
mat `dx' = `d'*`Xk''

	Stepsize `f00' `d'      /* compute step = scalar * `d' */

	mat `d' = `d'*`Xk''     /* `d' in standard metric; note `Xk'
	                           is a unitary matrix, so this does
	                           not affect the computation by Stepsize
			        */
mat $ML_b = `b0'
scalar $ML_f = `f0'
TrySteps `dx'

*----

program define TrySteps
	args g
	tokenize "1e-8 1e-6 1e-4 1e-3 1e-2"
	local i 1
	while "``i''"!="" {
		TakeStep `g' ``i''
		local i = `i' + 1
	}
end

program define TakeStep
	args g eps
	tempname f b d
	scalar `f' = scalar($ML_f)
	mat `b' = $ML_b

	mat `d' = `g'*`g''
	scalar `d' = `eps'*abs(`f')/`d'[1,1]
	mat `d' = `d'*`g'

	mat $ML_b = `d' + `b'

	CnsEval 0

	local change = (scalar($ML_f) - `f')/abs(`f')

	if `change'/`eps' < 0.5 { local flag " *" }

	di _n "Target change = " %11.3e `eps'          /*
	*/ _n "Actual change = " %11.3e `change'       /*
	*/ _n "actual/target = " %11.3e `change'/`eps' "`flag'"

	mat $ML_b = `b'
	scalar $ML_f = `f'
end


************ Code for checking gradient using its total length  **********

		mat `gPg' = $ML_g*$ML_g'
		mat `bPb' = $ML_b*$ML_b'
		local conv = ( mreldif(matrix($ML_b),`b0')<=$ML_tol |	/*
		*/ reldif(scalar($ML_f),`f0')<=$ML_ltol ) &		/*
		*/ (`gPg'[1,1] / (1 + `bPb'[1,1]) < 1e-3 | 		/*
		*/   `back_ct' > 3 | `nc_ct' > 5 )

**************************** display options *****************************

	ML_trace                ML_dider
	--------		--------
	0 = nolog		0 = nothing
	1 = log			1 = gradient
	2 = trace		2 = hessian
	3 = showstep		3 = gradient and hessian
	4 = showstep trace

	Note: $ML_trace==4 => $ML_dider==1 or 3

<end of file>
