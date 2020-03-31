*! version 4.1.0  18nov1998 updated 09oct2000
program define glmpred
	version 4.0

	if !("`e(cmd)'"=="glm" & "`e(predict)'"=="glm_p") { 
		error 301
	}

	tempvar new
	local varlist "new max(1) min(1)"
	local options "All Deviance Mu Pearson Stdp XB"
	nobreak {
		parse "`*'"
		rename `varlist' `new'
	}

	tempvar eta MU V dresq

	local nopt = ("`devianc'" != "") /*
			*/ + ("`mu'" != "" ) + ("`xb'" != "") /*
			*/ + ("`pearson'" != "") + ("`stdp'" != "")

	if `nopt'>1 { error 198 }
	if `nopt' == 0 { 
		local mu "mu"
	}

	if "`all'" == "" { 
		local all "if e(sample)"
	}
	else	local all


	local k "`e(k)'"
	local delta "`e(delta)'"

	quietly { 

				/* Calc offset-adjusted linear predictor */

		_predict double `eta'
		if "`e(offset)'"!="" { 
			replace `eta' = `eta'+ `e(offset)'
		}

		if "`xb'" != "" {
			label var `new' "Linear predictor"
			replace `new'=`eta' `all'
			rename `new' `varlist'
			exit
		}

					/* stdp 		*/
		if "`stdp'" != "" {
			_predict double `MU', stdp
			replace `new' = `MU' `all'
			label var `new' "S.E. of linear prediction"
			rename `new' `varlist'
			exit
		}

					/* Calc predicted mean	*/
		gen double `MU'=.
		_crcglil `eta' `MU' `e(power)' `e(m)' `k' `e(bernoul)'
		if "`mu'" != "" {
			replace `new'=`MU' `all'
			label var `new' "Predicted mean of `e(depvar)'"
			rename `new' `varlist'
			exit
		}


		local y `e(depvar)'

/*
	Calc (unstandardized, scaled) deviance residual.
*/
		if "`devianc'"!="" {
			gen double `dresq' = 0
				/* note, wt purposefully set to        1   */
			_crcgldv `y' `e(family)' `e(bernoul)' `e(m)' `k' `MU' 1 `dresq'
			replace `new'=sign(`y'-`MU')*sqrt(`dresq') `all'
			lab var `new' "Deviance residual"
			rename `new' `varlist'
			exit
		}

		if "`pearson'" != "" {
			pearson `V' `MU'
			replace `new' = (`y'-`MU')/sqrt(`V') `all'
			label var `new' "Pearson residual"
			rename `new' `varlist'
			exit
		}
	}
end


program define pearson /* V mu */
	version 4.0

	local V "`1'"
	local mu "`2'"

	if "`e(family)'"=="bin" {
		gen double `V' = `mu'*(1-`mu'/`e(m)')
	}
	else if "`e(family)'"=="gam" {
		gen double `V' = `mu'^2
	}
	else if "`e(family)'"=="gau" {
		gen double `V' = 1
	}
	else if "`e(family)'"=="ivg" {
		gen double `V' = `mu'^3
	}
	else if "`e(family)'"=="nb" {
		gen double `V' = (`mu'+`e(k)'*`mu'^2)
	}
	else if "`e(family)'"=="poi" {
		gen double `V' = `mu'
	}
end
