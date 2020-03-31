*! version 1.1.0  22feb2007
program define _linemax   
	version 6.0
	args        xval   /* point where fn is maximized -- scalar
		*/  yval   /* function value at maximum -- scalar 
		*/  ic     /* iteration count
		*/  colon  /*  :       
		*/  fn     /* function which produces value to be maximized 
		*/  name   /* name for iteration log 
		*/  smid   /* starting point for evaluation (a scalar name)
		*/  sstep  /* step size (a scalar name)
		*/  max_ic /* maximum iteration 
		*/  tol    /* convergence tolerance (a scalar name) */

	mac shift 10
	local 0 `"`*'"'

	syntax [ , trace nolog ]
	global TL_trace `trace'

	tempname start mid end try sval eval mval tval step golden /*
		*/ goldmlt changed
	scalar `mid' = `smid'
	scalar `step' = `sstep'
	


	`fn' `mval' : `mid'

	scalar `golden' = .38197
	scalar `goldmlt' = (1 - `golden') / `golden'

	if `step' == 0 {
		di in red "cannot perform line maximization with a 0 stepsize"
		exit 198
	}

	/* initial step search -- find a bracketed point */
	scalar `sval' = .
	local done 0
	di 
	while !`done' {
		scalar `try' = `mid' + `step'
		`fn' `tval' : `try'
		if `tval' > `mval' {
			/* still stepping */
			scalar `start' = `mid'
			scalar `sval' = `mval'
			scalar `mid' = `try'
			scalar `mval' = `tval'
			scalar `step' = `step' * `goldmlt'
			if "`trace'" != ""  { di ">" _c }
		}
		else if `sval' != . {
			/* we're done -- found bracket */
			scalar `end' = `try'
			scalar `eval' = `tval'
			local done 1
			if "`trace'" != "" { di "." }
		} 
		else {
			/* reverse direction */
			scalar `start' = `try'
			scalar `sval' = `tval'
			scalar `step' = -`step'         
			if "`trace'" != "" { di "<--|" _c }
		}
	}

	local it_ct 1

	if "`trace'" != "" {
		di in gr "Parabolic search step:"
		di in gr "bracketed points:  " `start' ", " `mid' ", " `end'
		di in gr "fn values:  " `sval' ", " `mval' ", " `eval'
	}
	if "`log'" != "nolog" { 
		di in gr "Iteration `it_ct':  `name' = " in ye %6.4f `mid' /*
			*/ in gr " , criterion = ", `mval'
	}

	/* loop over parabolic and golden searches to find maximum */
	local left_ct = 0
	local rite_ct = 0
	while abs(`end' - `start') > 2*`tol' & `it_ct' < `max_ic' {

		tryNear `start' `mid' `end' `sval' `mval' `eval' `fn' /*
			*/ `tol' `changed'
		if !`changed' {
			/* try maximum of parabola */
			maxBola `start' `mid' `end' `sval' `mval' `eval' `try'
		}

		if `try'>`start' & `try'>`end' | `try'<`start' & /*
		*/ `try'<`end' | `left_ct' > 2 | `rite_ct' > 2 {
			goldStep `start' `mid' `end' `sval' `mval' `eval' `fn'
			local left_ct 0
			local rite_ct 0
		}
		else {
			`fn' `tval' : `try'

			if `tval' >= `mval' {
				if `try'>`start' & `try'<`mid' | /*
				*/ `try'<`start' & `try'>`mid'{
					scalar `end' = `mid'
					scalar `eval' = `mval'
					local left_ct = `left_ct' + 1
					local rite_ct = 0
				}
				else {
					scalar `start' = `mid'
					scalar `sval' = `mval'
					local rite_ct = `rite_ct' + 1
					local left_ct = 0
				}
				scalar `mid' = `try'
				scalar `mval' = `tval'
			} 
			else  {
				goldStep `start' `mid' `end' `sval' /*
					*/ `mval' `eval' `fn'
				local left_ct 0
				local rite_ct 0
			}
		}

		local it_ct = `it_ct' + 1

		if "`trace'" != "" {
			di "Parabolic search step:"
			di "bracketed points:  " `start' ", " `mid' ", " `end'
			di "fn values:  " `sval' ", " `mval' ", " `eval'
		}
		if "`log'" != "nolog" { 
			di in gr "Iteration `it_ct':  `name' = " /*
				*/ in ye %6.4f `mid' /*
				*/ in gr " , criterion = ", `mval'
		}

	}
	
	capture macro drop TL_*
	scalar `ic' = `it_ct'
	scalar `xval' = `mid'
	scalar `yval' = `mval'

end


/*  Find the x for which a parabola passed through 3 points is maximized */
cap prog drop maxBola
program define maxBola /* s m e f(a) f(b) f(c) xmax */
	args a b c fa fb fc xmax

	tempname ba bc fbfa fbfc 

	scalar `ba' = `b' - `a'
	scalar `bc' = `b' - `c'
	scalar `fbfa' = `fb' - `fa'
	scalar `fbfc' = `fb' - `fc'

	scalar `xmax' = `b' - .5 * ( (`ba'^2 * `fbfc' - `bc'^2 * `fbfa') /  /*
		*/  (`ba' * `fbfc' - `bc' * `fbfa') )
	
end

                        /* ----- --- --- ---- ---- ---- -- */
program define goldStep /* start mid end sval mval eval fn */
                        /* ----- --- --- ---- ---- ----    */
	args  start mid end sval mval eval fn

	if "$TL_trace" != "" { di "Golden search step" }
	tempname try tryval golden

	scalar `golden' = .38197

	if abs(`start' - `mid') > abs(`end' - `mid') {
		scalar `try' = `mid' - `golden' * (`mid' - `start')
		`fn' `tryval' : `try'
		if `tryval' > `mval' {
			scalar `end' = `mid'
			scalar `eval' = `mval'
			scalar `mid' = `try'
			scalar `mval' = `tryval'
		}
		else {
			scalar `start' = `try'
			scalar `sval' = `tryval'
		}
	}
	else {
		scalar `try' = `mid' + `golden' * (`end' - `mid')
		`fn' `tryval' : `try'
		if `tryval' > `mval' {
			scalar `start' = `mid'
			scalar `sval' = `mval'
			scalar `mid' = `try'
			scalar `mval' = `tryval'
		}
		else {
			scalar `end' = `try'
			scalar `eval' = `tryval'
		}
	}

end

                        /* ----- --- --- ---- ---- ---- -- ---       */
program define tryNear  /* start mid end sval mval eval fn tol chged */
                        /* ----- --- --- ---- ---- ----        ----- */
	args  start mid end sval mval eval fn tol changed

	scalar `changed' = 0
	if 5 * abs(`start' - `mid') < abs(`end' - `mid') {
		tempname try tryval 
		scalar `try' = 2 * `mid' - `start'
		`fn' `tryval' : `try'
		if `tryval' < `mval' {
			scalar `end' = `try'
			scalar `eval' = `tryval'
			scalar `changed' = 1
			if "$TL_trace" != "" { di "Accept near step" }
		}
	}
	else {
		if abs(`start' - `mid') > 5 * abs(`end' - `mid') {
			tempname try tryval 
			scalar `try' = 2 * `mid' - `end'
			`fn' `tryval' : `try'
			if `tryval' < `mval' {
				scalar `start' = `try'
				scalar `sval' = `tryval'
				scalar `changed' = 1
				if "$TL_trace" != "" { di "Accept near step" }
			}
		}
	}

end
