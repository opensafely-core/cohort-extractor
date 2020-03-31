*! version 2.0.6  21sep2004
program define hotel, rclass
	version 6, missing
	syntax varlist [if] [in] [aw fw] [, BY(varname numeric) noTable ]
	marksample touse
	markout `touse' `by'

	quietly count if `touse'
	if r(N)<2 { error 2001 }

	if `"`weight'"'!="" {
		tempvar wgtvar
		quietly gen `wgtvar' `exp' if `touse'
		local weight `"[`weight'=`wgtvar']"'
	}
	tempname moment xx xg gg idf gxxg df idf tsqrd farg pval
	if (`"`by'"'!="") {
		preserve
		_rmcoll `varlist' `weight' if `touse'
		local varlist "`r(varlist)'"
		keep `by' `varlist' `touse' `wgtvar'
		quietly keep if `touse'
		qui tab `by', gen(__Sa)
		capture confirm var __Sa2
		if _rc {
			di in red "by() variable takes on only one value"
			exit 198
		}
/* check that not more than two groups */
		capture confirm var __Sa3
		if _rc==0 { 
			di in red "too many by() values"
			exit 134
		}
/* check ends */
		drop __Sa1
		local nvar : word count `varlist'
		local nvar1 = `nvar' + 1
		qui mat accum `moment' = `varlist' __Sa* if `touse' /*
			*/ `weight', dev nocons
		local nobs = r(N)
		local ndim = rowsof(`moment')
		scalar `df' = `nobs' - `ndim' + `nvar' - 1
		if `df' <= 0 {
			di in red "calculation would incur df<=0"
			exit 198
		}
		mat `xx' = `moment'[1..`nvar',1..`nvar']
		mat `xg' = `moment'[1..`nvar',`nvar1'...]
		mat `gg' = syminv(`moment'[`nvar1'...,`nvar1'...])
		mat `xx' = `moment'[1..`nvar',1..`nvar'] - `xg'*`gg'*`xg''
		scalar `idf' = 1/`df'
		mat `xx' = syminv(`xx' * `idf')  /* covariance of the xs */
		mat `gg' = cholesky(`gg')
		mat `xg' = `xg'*`gg'
		mat `gxxg' = `xg'' * `xx' * `xg'
		local tdf = `nobs'-`nvar1'
		sort `by'
		if (`"`table'"'=="") {
			by `by': summarize `varlist' if `touse' `weight'
		}
		if (rowsof(`gxxg')==1) {
			local ttl "2-group Hotelling's T-squared"
			scalar `tsqrd' = `gxxg'[1,1]
		}
		di
		scalar `farg' = `tsqrd'*(`nobs'-`nvar'-1)/((`nobs'-2)*`nvar')
		scalar `pval' = fprob(`nvar',`tdf',`farg')
		di in gr `"`ttl' = "' in ye `tsqrd'
		di in gr "F test statistic: " in ye "((" `nobs' "-" `nvar' /*
		*/ "-1)/(" `nobs' "-2)(" `nvar' "))" /*
		*/ " x " `tsqrd' in gr " = "  in ye `farg'
		di 
		di in gr "H0: Vectors of means are equal for the two groups"
		di in gr _col(10) "     F(" in ye `nvar' in gr "," /* 
		*/ in ye `tdf' /*
		*/ in gr ") = " in ye %9.4f `farg'
		di in gr _col(8) "Prob > F(" in ye `nvar' in gr "," /*
		*/ in ye `tdf' in gr ") = " in ye %9.4f `pval'
	}
	else {		/* not by'd */
		_rmcoll `varlist' `weight' if `touse'
		local varlist "`r(varlist)'"
		qui matrix accum `moment' = `varlist' `weight' if `touse', /*
			*/ nocons dev means(`xg')
		local nobs = r(N)
		local nvar = rowsof(`moment')
		scalar `idf' = 1/(`nobs'*(`nobs'-1))
		mat `moment' = syminv(`moment' * `idf')
		mat `gxxg' = `xg' * `moment' * `xg''
		scalar `idf' = 1/`nvar'
		local tdf = `nobs' - `nvar'
		if `tdf' <= 0 {
			di in red "calculation would incur df<=0"
			exit 198
		}
		scalar `tsqrd' = `gxxg'[1,1]
		local ttl "1-group Hotelling's T-squared"
		if (`"`table'"'=="") {
			summarize `varlist' `weight' if `touse'
		}
		di
		scalar `farg' = `tsqrd'*(`nobs'-`nvar')/((`nobs'-1)*`nvar')
		scalar `pval' = fprob(`nvar',`tdf',`farg')
		di in gr `"`ttl' = "' in ye `tsqrd'
		di in gr "F test statistic: " in ye "((" `nobs' "-" `nvar' /*
		*/ ")/(" `nobs' "-1)(" `nvar' "))" /*
		*/ " x " `tsqrd' in gr " = "  in ye `farg'
		di 
		di in gr "H0: Vector of means is equal to a vector of zeros"
		di in gr _col(10) "     F(" in ye `nvar' in gr "," /* 
		*/ in ye `tdf' /*
		*/ in gr ") = " in ye %9.4f `farg'
		di in gr _col(8) "Prob > F(" in ye `nvar' in gr "," /*
		*/ in ye `tdf' in gr ") = " in ye %9.4f `pval'
	}
	ret scalar N = `nobs'
	ret scalar k = `nvar'
	ret scalar df = `tdf'
	ret scalar T2 = `tsqrd'
	/* double save in S_# and r() */
	global S_1 `nobs'
	global S_2 `nvar'
	global S_3 `tdf'
	global S_4 = `tsqrd'
end
