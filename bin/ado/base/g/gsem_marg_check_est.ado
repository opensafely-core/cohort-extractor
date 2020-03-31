*! version 1.0.0  17may2017
program gsem_marg_check_est
	version 15

	if "`e(lclass)'" == "" {
		Check `0'
	}
	else {
		CheckLC `0'
	}
end

program GetEqlist, sclass
	syntax [,					///
		Outcome(string)				///
		EQuation(string)			/// NOT documented
		*					///
	]

	if `:length local equation' {
		if `:length local outcome' {
			opts_exclusive "outcome() equation()"
		}
		local outcome : copy local equation
	}

	local dvlist "`e(depvar)'"

	gettoken depvar level : outcome
	if "`depvar'" == "" {
		gettoken depvar : dvlist
	}
	local DEPVAR : copy local depvar

	if "`level'" == "" {
		_ms_parse_parts `depvar'
		if "`r(ts_op)'" != "" {
			local depvar "`r(ts_op)'.`r(name)'"
		}
		else	local depvar "`r(name)'"
	}

	local i : list posof "`depvar'" in dvlist

	if `i' == 0 {
		di as err "outcome `DEPVAR' not found"
		exit 198
	}

	local hasg = "`e(groupvar)'`e(lclass)'" != ""
	if `hasg' {
		local G = rowsof(e(gclevs))
		local hasg = `G' > 1
	}
	else	local G = 1

	forval g = 1/`G' {
		if `hasg' {
			local pref m`g'_
		}

		local m = 0
		forval i = 1/`e(`pref'k_mult)' {
			if `"`e(`pref'mult`i'_name)'"' == "`depvar'" {
				local m = `i'
				continue, break
			}
		}
		if `m' {
			local dim : colsof e(`pref'mult`m'_map)
			forval i = 1/`dim' {
				if `i' == e(`pref'mult`m'_ibase) {
					continue
				}
				local lev = el(e(`pref'mult`m'_map),1,`i')
				local eqlist `eqlist' `lev'.`depvar'
			}
		}
		else	local eqlist : copy local depvar
	}
	local eqlist : list uniq eqlist

	sreturn local eqlist `"`eqlist'"'
	sreturn local depvar `"`depvar'"'
end

program AddCons
	args L depvar if in

	local marginsprop `"`e(marginsprop)'"'
	if `:list posof "addcons" in marginsprop' == 0 {
		exit
	}

	if "`e(b_fvignore)'" != "" {
		local fvignore = e(b_fvignore)
	}
	else	local fvignore 0

	if `fvignore' {
		tempname b
		matrix `b' = e(b)
		_ms_modify `b', fvignore(`fvignore')
		_ms_lf_info, matrix(`b')
	}
	else {
		_ms_lf_info
	}
	local pos 1
	local keq = r(k_lf)
	forval j = 1/`keq' {
		local eqspec`j' "`r(lf`j')'"
		local eqk`j' = r(k`j')
		local cons`j' = r(cons`j')
		if `fvignore' {
			if el(e(b_midx),1,`pos') < 0 {
				local cons`j' = 1
			}
		}
		local pos = `pos' + `eqk`j''
	}

	tempname hold
	matrix rename `L' `hold'

	local bmidx `"`e(lclass)'`e(groupvar)'"'
	if "`e(groupvar)'" != "" {
		tempname gclevs
	}

	local i0 0
	forval j = 1/`keq' {
		local i1 = `i0' + `eqk`j''
		local ++i0
		matrix `L' = nullmat(`L'), `hold'[1,`i0'..`i1']
		if `cons`j'' == 0 {
			if "`eqspec`j''" == "`depvar'" {
				local val 1
			}
			else {
				local val 0
			}

			// Macro:
			//	k	- number of val's to add to L
			//
			// Matrix:
			//	gclevs	- colstripe contains the group
			//		  spec in FV notation to ensure
			//		  the proper group-specific
			//		  vals'

mata:			st_gsem_marg_count("`bmidx'", `i0', `i1')

			if `val' & `"`e(groupvar)'"' != "" {
				// `gclevs' created by st_gsem_marg_count()
				_ms_means `gclevs' `if' `in',	///
					fill0 ignoreomit allownotfound
				matrix `L' = `L', r(means)
			}
			else {
				matrix `L' = `L', J(1,`k',`val')
			}
		}
		local i0 = `i1'
	}
end

program Check, rclass
	syntax [if] [in] [fw aw iw pw] [,		///
		mult(name)				///
		TOLerance(real 1e-7)			///
		Outcome(passthru)			///
		EQuation(passthru)			///
		*					///
	]

	GetEqlist, `outcome' `equation'
	local eqlist `"`s(eqlist)'"'
	local depvar `"`s(depvar)'"'

	local opts	eclass		///
			fill0		///
			ignoreomit	///
			allownotfound

	tempname H L LH

	_get_hmat `H'
	if r(rc) {
		exit
	}

	local first 1
	foreach eq of local eqlist {
		capture _ms_means b `if' `in' [`weight'`exp'], `opts' eq(`eq')
		if c(rc) {
			continue
		}
		if `first' {
			matrix `L' = r(means)
			local first 0
		}
		else {
			matrix `L' = `L' + r(means)
		}
	}
	if `:length local mult' {
mata:		st_matrix("`L'", st_matrix("`L'"):*st_matrix("`mult'"))
	}

	AddCons `L' `depvar' "`if'" "`in'"

	matrix `LH' = `L'*`H'
	if mreldif(`L', `LH')  > `tolerance' {
		return scalar not_estimable = 1
	}
	else	return scalar not_estimable = 0
end

program CheckClassPrior, rclass
	syntax [if] [in] [fw aw iw pw] [,		///
		mult(name)				///
		TOLerance(real 1e-7)			///
		*					///
	]

	tempname bmidx

	matrix `bmidx' = e(b_midx)

	_ms_lf_info
	local keq = r(k_lf)
	forval j = 1/`keq' {
		local eqspec`j' "`r(lf`j')'"
		local eqk`j' = r(k`j')
	}
	local pos 1
	forval j = 1/`keq' {
		if `bmidx'[1,`pos'] > 0 {
			continue, break
		}
		_ms_parse_parts `eqspec`j''
		if r(omit) == 0 {
			local eqlist `eqlist' `eqspec`j''
		}
		local pos = `pos' + `eqk`j''
	}

	local opts	eclass		///
			fill0		///
			ignoreomit	///
			allownotfound

	tempname H L LH

	_get_hmat `H'
	if r(rc) {
		exit
	}

	local first 1
	foreach eq of local eqlist {
		capture _ms_means b `if' `in' [`weight'`exp'], `opts' eq(`eq')
		if c(rc) {
			continue
		}
		if `first' {
			matrix `L' = r(means)
			local first 0
		}
		else {
			matrix `L' = `L' + r(means)
		}
	}
	capture confirm matrix `L'
	if c(rc) {
		return scalar not_estimable = 0
		exit
	}
	if `:length local mult' {
mata:		st_matrix("`L'", st_matrix("`L'"):*st_matrix("`mult'"))
	}

	AddCons `L'

	matrix `LH' = `L'*`H'
	if mreldif(`L', `LH')  > `tolerance' {
		return scalar not_estimable = 1
	}
	else	return scalar not_estimable = 0
end

program CheckLC, rclass
	syntax [if] [in] [fw aw iw pw] [,		///
		mult(name)				///
		TOLerance(real 1e-7)			///
		Outcome(passthru)			///
		EQuation(passthru)			///
		CLASSPR					///
		CLASSPOSTeriorpr			///
		PMARginal				///
		CLASS(passthru)				///
		*					///
	]

	if "`classpr'`classposteriorpr'`pmarginal'" != "" | "`class'" == "" {
		CheckClassPrior `0'
		if r(not_estimable) != 0 | "`classpr'" != "" {
			return add
			exit
		}
	}

	GetEqlist, `outcome' `equation'
	local eqlist `"`s(eqlist)'"'
	local depvar `"`s(depvar)'"'

	local lclass `"`e(lclass)'"'
	local nlcvars : list sizeof lclass

	local opts	eclass		///
			fill0		///
			ignoreomit	///
			allownotfound	///
			fvignore(`nlcvars')

	tempname b bmidx pos

	matrix `b' = e(b)
	matrix `bmidx' = e(b_midx)
	tempname H L LH

	_get_hmat `H'
	if r(rc) {
		exit
	}

	local eqnotfound 0
	local first 1
	foreach eq of local eqlist {
		capture	_ms_means b `if' `in' [`weight'`exp'], `opts' eq(`eq')
		if c(rc) {
			// NOTE: possible to have empty/missing
			// prediction equation for ordinal outcomes
			if c(rc) == 303 {
				local eqnotfound 1
			}
			continue
		}
		if `first' {
			matrix `L' = r(means)
			local first 0
		}
		else {
			matrix `L' = `L' + r(means)
		}
	}
	capture confirm matrix `L'
	if c(rc) {
		if `eqnotfound' {
			return scalar not_estimable = 0
		}
		else	return scalar not_estimable = 1
		exit
	}
	if `:length local mult' {
mata:		st_matrix("`L'", st_matrix("`L'"):*st_matrix("`mult'"))
	}

	AddCons `L' `depvar'

	matrix `LH' = `L'*`H'
	if mreldif(`L', `LH')  > `tolerance' {
		return scalar not_estimable = 1
	}
	else	return scalar not_estimable = 0
end

mata:

void st_gsem_marg_count(
	string	scalar	st_bmidx,
	real	scalar	i0,
	real	scalar	i1)
{
	real	vector	bmidx
	real	matrix	info
	real	scalar	dim
	string	matrix	stripe

	if (st_bmidx == "") {
		st_local("k", "1")
		return
	}

	bmidx	= sort(st_matrix("e(b_midx)")[(i0..i1)]',1)
	info	= panelsetup(bmidx,1)
	dim	= rows(info)
	st_local("k", strofreal(dim))

	if (st_local("gclevs") != "") {
		bmidx = bmidx[info[,1],1]
		stripe = st_matrixrowstripe("e(gclevs)")[bmidx,]
		dim = rows(stripe)
		st_matrix(st_local("gclevs"), J(1,dim,0))
		st_matrixcolstripe(st_local("gclevs"), stripe)
	}
}

end

exit
