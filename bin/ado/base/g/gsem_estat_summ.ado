*! version 1.2.0  10jan2017
program gsem_estat_summ, rclass
	version 13

	if "`e(cmd)'" != "gsem" {
		error 301
	}

	if !missing("`e(cmd2)'") local cmd `e(cmd2)'
	else local cmd `e(cmd)'

	capture assert e(sample)==0
	if !_rc {
		dis as err "e(sample) information not available"
		exit 498
	}

	syntax  [anything(name=eqlist)] [, 	/// ignored
		EQuation			/// ignored
		GROup				///
		GROup2(passthru)		///
		*				///
		]

	if "`equation'"!="" {
		dis as txt "after `cmd', option equation ignored"
		local equation
	}
	if `:length local group2' {
		dis as err "group() option not allowed; specify group"
		exit 198
	}

	if `:length local eqlist' {
		local vlist `eqlist'
	}
	else {
		if "`e(b_fvignore)'" != "" {
			// produces macros for temp matrices:
			// 	bc	- e(b) for lclass outcomes
			// 	bo	- e(b) for observed outcomes
			mata: st_gsem_split()

			if "`bc'" != "" {
				if "`e(groupvar)'" != "" {
					_ms_modify `bc', fvignore(1)
				}
				local vlist `"`: colvarlist `bc''"'
			}

			local fvignore = e(b_fvignore)
			_ms_modify `bo', fvignore(`fvignore')
			local vlist `"`e(depvar)' `vlist' `: colvarlist `bo''"'
		}
		else {
			local vlist `"`e(depvar)' `: colvarlist e(b)'"'
		}
		if "`e(groupvar)'" == "" {
			local REspec "`e(REspec)'"
		}
		else {
			local ng = e(N_groups)
			forval i = 1/`ng' {
				local REspec "`REspec' `e(m`i'_REspec)'"
			}
		}
		local vlist : list uniq vlist
		local vlist : subinstr local vlist "bn." ".", all
		local Llist `"`REspec' o._cons _cons"'
		local vlist : list vlist - Llist
		fvrevar `vlist', list
		confirm numeric variable `r(varlist)'
	}

	if `:length local group' {
		if "`e(groupvar)'"!="" {
			capture confirm variable `e(groupvar)'
			if _rc {
			  di as err "group() variable `e(groupvar)' not found"
			  exit 111
			}
		}
		else {
			di as err "no group() variable found"
			exit 498
		}
		tempname GrpVal stats
		matrix `GrpVal' = e(groupvalue)
		local ng = e(N_groups)
		forvalues g = 1/`ng' {
			sem_groupheader `g', noafter nohline
			local grpval = `GrpVal'[1,`g']
			estat_summ `vlist', `options' ///
				group(`e(groupvar)'==`grpval')
			matrix `stats' = r(stats)
			return matrix stats_`g' = `stats'
		}
		return scalar N_groups = `ng'
	}
	else {
		estat_summ `vlist' , `options'
		return add
	}
end

mata:

void st_gsem_split()
{
	real	vector	b
	string	matrix	stripe
	real	vector	sel
	string	scalar	tname

	b	= st_matrix("e(b)")
	stripe	= st_matrixcolstripe("e(b)")
	sel	= st_matrix("e(b_midx)") :< 0

	if (any(sel)) {
		tname	= st_tempname()
		st_matrix(tname, select(b, sel))
		st_matrixcolstripe(tname, select(stripe, sel'))
		st_local("bc", tname)
	}

	tname	= st_tempname()
	sel	= sel :== 0
	st_matrix(tname, select(b, sel))
	st_matrixcolstripe(tname, select(stripe, sel'))
	st_local("bo", tname)
}

end

exit
