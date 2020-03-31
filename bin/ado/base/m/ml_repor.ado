*! version 7.1.0  30jun2008
program define ml_repor /* Allow_Ev ml_repor */
	version 6 
	if `"`0'"' != "" {
		error 198
	}
	scalar $ML_f = .
	capture mat drop $ML_g
	capture mat drop $ML_V
	if $ML_C == 1 {
	dis in blue "note: optimization is conducted on the constrained space"
	}
	di in gr _n "Current coefficient vector:"
	mat list $ML_b, noheader format(%9.0g) noblank
	capture noisily $ML_eval 2
	if _rc {
		capture mat drop $ML_V
		capture noisily $ML_eval 1
		if _rc {
			capture mat drop $ML_g
			$ML_eval 0
		}
	}
	if scalar($ML_f)==. {
		di _n in blu "(function cannot be evaluated at this point)"
		exit
	}

/* Display log-likelihood (criterion). */

	di _n in gr "Value of $ML_crtyp function = " /*
		*/ in ye %10.0g scalar($ML_f)
	capture di $ML_g[1,1]
	if _rc {
		di _n in blu "($ML_meth does not provide derivatives)"
		exit
	}

/* Display gradient. */

	tempname inv scale gn

	mat `gn' = $ML_g * $ML_g '
	local glen = sqrt(`gn'[1,1])
	mat `gn' = (1/`glen')*$ML_g /* steepest-ascent direction */

	version 11: _cpmatnm $ML_b, vec($ML_g `gn')

	di _n in gr "Gradient vector (length =" in ye %9.0g `glen' in gr "):"
	mat list $ML_g, noheader format(%9.0g) noblank

	capture di $ML_V[1,1]
	if _rc {
		di _n in gr "Steepest-ascent direction:"
		mat list `gn', noheader format(%9.0g) noblank

		di _n in blu "($ML_meth does not provide negative Hessian)"
		exit
	}

/* Display Hessian and direction vectors. */

	local dim = matrix(colsof($ML_V))
	mat `inv' = syminv($ML_V)
	local rank = `dim' - matrix(diag0cnt(`inv'))

	mat `inv' = $ML_g * `inv'
	mat `scale' = `inv' * `inv' '
	local ilen = sqrt(`scale'[1,1])
	local adj = 1/`ilen'
	if `adj'==. { local adj 0 }
	mat `inv' = `inv' * `adj'

	version 11: _cpmatnm $ML_b, vec(`inv') square($ML_V)

	di _n in gr "Negative Hessian matrix " _c

	if `rank'==`dim' {
		di in gr "(concave; matrix is full rank):"
	}
	else 	di in gr "(nonconcave; rank = `rank' < " `dim' "):"

	mat list $ML_V, noheader format(%9.0g) noblank

	di _n in gr "Steepest-ascent direction:"
	mat list `gn', noheader format(%9.0g) noblank
	di _n in gr "Newton-Raphson direction (length before normalization =" /*
	*/ in ye %9.0g `ilen' in gr "):"
	mat list `inv', noheader format(%9.0g) noblank
end
