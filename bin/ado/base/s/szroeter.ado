*! version 2.3.5  12oct2017
program define szroeter, rclass sort
	version 8

	if "`e(cmd)'" == "anova" {
		if 0`e(version)' < 2 {
			// not allowed with old anova (but is with new anova)
			di as err ///
		      "szroeter not allowed after anova run with version < 11"
			exit 301
		}
	}
	else if "`e(cmd)'" != "regress" {
		di as err "szroeter is only possible after regress"
		exit 301
	}
	if "`e(wtype)'" != "" {
		di as err "szroeter does not allow weights"
		exit 101
	}
	if "`e(clustvar)'" != "" {
		di as err "szroeter does not allow cluster()"
		exit 498
	}
	_ms_op_info e(b)
	if r(tsops) {
		quietly tsset, noquery
	}

	syntax [varlist(default=none numeric fv ts)] [, Rhs Mtest2(passthru)]
	local fvops = "`s(fvops)'" == "true"
	local tsops = "`s(tsops)'" == "true"

	// check that mtest has valid value
	if `"`mtest2'"' != "" {
		_mtest syntax , `mtest2'
		local mtmethod `r(method)'
	}
	else 	local mtmethod noadjust

	if "`rhs'" != "" {
		local xvar : colnames e(b)
		local xvar : subinstr local xvar "_cons" "", word
		local varlist `varlist' `xvar'
		// in case user specifies a variable that is also in
		// RHS, this ensures table only contains variable once
		local varlist : list uniq varlist
	}
	else if `fvops' {
		fvexpand `varlist' if e(sample)
		local varlist `"`r(varlist)'"'
	}
	local nvar : word count `varlist'
	if `nvar' == 0 {
		di as err "you must specify either {it:varlist} or "	///
			"option {bf:rhs}"
		exit 198
	}
	else if `nvar' == 1 {
		local vlist `varlist'
		local mtmethod
	}
	else local vlist variable

	// compute test statistics
	// -----------------------

	tempname test
	mat `test' = J(`nvar',3,0)
	mat colnames `test' = chi2 df p
	version 11: ///
	mat rownames `test' = `varlist'

	tokenize `varlist'
	forvalues i = 1/`nvar' {
		Szroeter ``i''
		mat `test'[`i',1] = r(Q)
		mat `test'[`i',2] = 1
		mat `test'[`i',3] = r(p)
	}

	if "`mtmethod'" != "" {
		_mtest adjust `test' , mtest(`mtmethod') pindex(3) append
		mat `test' = r(result)
		_ms_build_info `test' if e(sample), row
		local indexp 4
	}
	else	local indexp 3


	// display test statistics
	// ------------------------

	local vartxt = cond(`nvar'==1,"`varlist'","variable")

	di as txt _n "Szroeter's test for homoskedasticity" _n
	di as txt _col(5) "Ho: variance constant"
	di as txt _col(5) "Ha: variance monotonic in `vartxt'" _n

	if `nvar' == 1 {
		di as txt _col(10) "chi2(1)"     _col(23) "=" ///
		   as res %9.2f `test'[1,1]
		di as txt _col(10) "Prob > chi2" _col(23) "=" ///
		   as res %9.4f `test'[1,3]
	}
	else {
		di as txt "{hline 13}{c TT}{hline 25}"
		di as txt "    Variable {c |}      chi2   df      p "
		di as txt "{hline 13}{c +}{hline 25}"

		local first
		forvalues i = 1/`nvar' {
			_ms_display,	matrix(`test')	///
					row		///
					el(`i')		///
					`first'		///
					vsquish		///
					nobase		///
					noomit		///
					noempty
			if r(output) {
				local first
			}
			else {
				if r(first) {
					local first first
				}
				continue
			}
			di as txt " "       ///
			   as res _col(16)  %9.2f  `test'[`i',1]  ///
			          _col(24)  %5.0f  `test'[`i',2]  ///
			          _col(33)  %6.4f  `test'[`i',`indexp'] " #"
		}
		di as txt "{hline 13}{c BT}{hline 25}"

		_mtest footer 39 "`mtmethod'" "#"
	}

	// return values
	// -------------

	if `nvar' == 1 {
		return scalar chi2 = `test'[1,1]
		return scalar df   = `test'[1,2]
		return scalar p    = `test'[1,3]
	}

	return matrix mtest    `test'
	return local  mtmethod `mtmethod'
end


/* Szroeter varname

   returns in r(Q) the test statistic
              r(p) the p-value of Q under Ho
*/
program define Szroeter , rclass
	args var

	tempname h mh n vh
	tempvar ht res touse

	quietly {
		gen byte `touse' = e(sample)
		markout `touse' `var'
		egen `ht' = rank(`var') if `touse'
		summ `ht' if `touse'
		scalar `n'  = r(N)
		scalar `mh' = r(mean)
		scalar `vh' = r(Var)

		predict `res', res
		summ `ht' [aw=`res'^2] if `touse', meanonly
		scalar `h' = r(mean)

		ret scalar Q = (`n'^2 / (2*(`n'-1))) * (`h'-`mh')^2 / `vh'
		ret scalar p = chi2tail(1, return(Q))
	}
end
exit

szroeter's heteroskedasticity test with King's weights (Judge et al 1985: 450-2)

