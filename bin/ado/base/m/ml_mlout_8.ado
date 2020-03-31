*! version 6.1.7  25mar2004 (updated 12feb2015)
program define ml_mlout_8
	version 8
	if "`e(cmd)'" == "" | "`e(opt)'"!="ml" { 
		error 301
	}
	if "`e(svyml)'" != "" {
		svy_dreg `0'
		exit
	}
	syntax [,			///
		Level(cilevel)		///
		PLus			///
		noHeader		///
		First			///
		NEQ(integer -1)		///
		*			/// eform options
	]
	_get_eformopts , eformopts(`options') soptions allowed(__all__)
	local eform `s(eform)'
	// `diparm' should only contain -diparm()- options
	local diparm `s(options)'
	_get_diparmopts , diparmopts(`diparm') level(`level')

	// check for auxiliary parameters
	if (e(k_eq)==1)		local first first
	if ("`first'" != "")	local neq 1
	// -neq()- overrides the default display of auxiliary parameters
	if `neq' <= 0 {
		// just in case e(k_aux) is a macro instead of a scalar
		capture confirm integer number `e(k_aux)'
		if _rc	local k_aux = .
		else	local k_aux = `e(k_aux)'
		if e(k_eq) > `k_aux'  {
			local neq = e(k_eq) - `k_aux'
			if (`neq' == 1) local first first
			local kaux = `neq' + 1
			tempname b
			mat `b' = e(b)
			local eqnames : coleq `b'
			mat drop `b'
			local eqnames : list uniq eqnames
			if `:word count `eqnames'' != `e(k_eq)' {
				di as err ///
"estimation command error: e(k_eq) does not equal the number of equations"
				exit 459
			}
			forval i = `kaux'/`e(k_eq)' {
				local eqn : word `i' of `eqnames'
				local mydiparm `mydiparm' diparm(`eqn')
			}
			if `"`diparm'"' != "" {
				local mydiparm `mydiparm' diparm(__sep__)
			}
			local diparm `mydiparm' `diparm'
		}
	}
	if (`neq' > 0)	local neq neq(`neq')
	else		local neq
	local dibot bottom
	if `"`eform'"' == "" & `"`diparm'"' != "" {
		if "`plus'" != "" {
			local dibot plus
		}
		else	local plus plus
	}

	if "`header'"=="" {
		local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
			*/ bsubstr(`"`e(crittype)'"',2,.)
		di _n in gr `"`e(title)'"' /*
		*/ _col(51) in gr "Number of obs" _col(67) "= " /*
			*/ in ye %10.0g e(N)
		local cfmt=cond(e(chi2)<1e+7,"%10.2f","%10.3e")
		if "`e(chi2type)'"=="Wald" & e(chi2) == . {
			di in smcl _col(51) /* 
		*/ "{help j_robustsingular:Wald chi2(`e(df_m)'){col 67}= }" /*
			*/ in ye `cfmt' e(chi2)
		}
		else {
			di _col(51) in gr "`e(chi2type)' chi2(" /*
			*/ in ye "`e(df_m)'" in gr ")" _col(67) "= " /*
			*/ in ye `cfmt' e(chi2)
		}
		if e(r2_p)==. {
			di in gr "`crtype' = " in ye %10.0g e(ll) /*
			*/ _col(51) in gr "Prob > chi2" _col(67) "= " /*
			*/ in ye %10.4f e(p)
		}
		else {
			di _col(51) in gr "Prob > chi2" _col(67) "= " /*
			*/ in ye %10.4f e(p)
			di in gr "`crtype' = " in ye %10.0g e(ll) /*
			*/ _col(51) in gr "Pseudo R2" _col(67) "= " /*
			*/ in ye %10.4f e(r2_p)
		}
		di
	}

	/* Were there constraints ? */
	tempname cns
	capture mat `cns' = get(Cns)
	if !_rc {
		matrix dispCns
	}

	ereturn display, `first' `eform' level(`level') `neq' `plus'
	if e(rc)==504 { 
		di in red "Variance matrix missing because `e(user)' failed" /*
		*/ " to compute scores or computed" _n /*
		*/ "scores with missing values."
		exit 504
	}
	if (e(rc)) error `e(rc)'

	// display auxiliary parameters, if any
	if `"`eform'"' == "" & `"`diparm'"' != "" {
		_get_diparmopts, diparmopts(`diparm') level(`level')	///
			execute `dibot'
	}
end

exit
