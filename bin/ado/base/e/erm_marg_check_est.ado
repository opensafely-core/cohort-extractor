*! version 1.0.0  18may2017
program erm_marg_check_est
	version 15
	Check `0'
end

program GetEqlist, sclass
	syntax [,					///
		OUTlevel(string)			///
		EQuation(string)			/// 
		*					///
	]
	_ms_parse_parts `depvar'
	if "`r(ts_op)'" != "" {
		local depvar "`r(ts_op)'.`r(name)'"
	}
	else	local depvar "`r(name)'"
	if "`depvar'" == "" {
		local depvar `e(odepvar)'
	}
	local eqlist `depvar'
	sreturn local eqlist `"`eqlist'"'
	sreturn local depvar `"`depvar'"'
end

program AddCons
	args L depvar if in

	local marginsprop `"`e(marginsprop)'"'
	if "`e(cutsinteract)'" != "" {
		local fvignore = 1	
	}
	else {
		local fvignore = 0
	}

	if `fvignore' {
		tempname b
		matrix `b' = e(b)
		local coleqnames: coleq `b'
		gettoken eq coleqnames: coleqnames
		local i = 0
		local tname  `eq'
		while "`tname'" == "`eq'" {
			local i = `i' +1
			gettoken tname coleqnames: coleqnames			
		}
		tempname btmp
		matrix `btmp' = `b'[1,1..`i']
		_ms_modify `btmp', fvignore(`fvignore')
		local k1 = `i' + 1
		local k2 = colsof(`b')
		matrix `btmp' = `btmp',`b'[1,`k1'..`k2']
		_ms_lf_info, matrix(`btmp')
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
		local pos = `pos' + `eqk`j''
	}
	tempname hold
	matrix rename `L' `hold'
	tempname gclevs
	local i0 0
	tempname ordinalvarmat
	matrix `ordinalvarmat' = e(isordinalvar)
	forval j = 1/`keq' {
		local i1 = `i0' + `eqk`j''
		local ++i0
		matrix `L' = nullmat(`L'), `hold'[1,`i0'..`i1']
		if `cons`j'' == 0 & (`ordinalvarmat'[1,`j']==1) {
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
			if `j' == 1 {
				local bmidx `"`e(cutsinteract)'"'
			}
			else {
				local bmidx 
			}

mata:			st_gsem_marg_count("`bmidx'", `i0', `i1')

			if `val' & (`"`e(cutsinteract)'"' != "" & `j' == 1) {
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
		OUTlevel(passthru)			///
		EQuation(passthru)			///
		*					///
	]
	GetEqlist, `outlevel' `equation'
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
