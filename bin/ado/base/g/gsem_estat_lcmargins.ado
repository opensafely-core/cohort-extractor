*! version 1.0.1  20sep2018
program gsem_estat_lcmargins, eclass
	version 15

	if `"`e(lclass)'"' == "" {
		error 301
	}

	gettoken cmd 0 : 0, parse(" ,")

	if "`cmd'" == "lcprob" {
		local EXTRAOPTS classpr CLASSPOSTeriorpr
	}

	syntax [, POST NOSE `EXTRAOPTS' *]

	if "`cmd'" == "lcprob" {
		opts_exclusive "`classpr' `classposteriorpr'"
	}

	if "`classposteriorpr'" == "" {
		local predict `"`e(`cmd'_margins)'"'
	}
	else {
		local predict `"`e(`cmd'_margins_classpost)'"'
	}
	if `"`predict'"' == "" {
		error 301
	}

	if "`cmd'" == "lcmean" {
		local TITLE Latent class marginal means
	}
	else if "`cmd'" == "lcprob" {
		if "`classposteriorpr'" == "" {
			local TITLE Latent class marginal probabilities
		}
		else {
			local TITLE Latent class marginal posterior probabilities
		}
	}

	_get_diopts diopts, `options'

	// may set macro 'nopvalues'
	mata: st_gsem_lcmargins_nopvalues("e(`cmd'_pclass)")
	if "`nopvalues'" != "" {
		local noci noci
		if `:list noci in diopts' {
			di as err "option {bf:noci} not allowed"
			exit 198
		}
		if !`:list nopvalues in diopts' {
			local diopts `diopts' nopvalues
		}
		local diopts : list diopts - coeflegend
	}

	if "`post'" == "" {
		local restore restore
	}

	tempname pclass b
	matrix `pclass' = e(`cmd'_pclass)
	if "`e(`cmd'_order)'" == "matrix" {
		tempname order
		matrix `order' = e(`cmd'_order)
	}

	if "`e(groupvar)'" != "" {
		local over over(`e(groupvar)')
		if "`cmd'" == "lcprob" {
			local DEPVAR `e(groupvar)'
		}
	}

	tempname ehold
	_est hold `ehold', `restore' copy
	capture						///
	noisily						///
	quietly						///
	margins,					///
		marginsallok				///
		`over'					///
		`predict'				///
		`nose'					///
		`diopts'				///
		post
	local rc = c(rc)
	if `rc' {
		_est unhold `ehold'
		exit `rc'
	}

	tempname b
	matrix `b' = e(b)

	if "`order'" == "" {
		matrix colna `b' = `:colfullna `pclass''
		ereturn repost b=`b', rename
	}
	else {
		mata: st_gsem_lcmargins_order("`b'", "`order'")
		matrix colna `b' = `:colfullna `pclass''
		ereturn repost b=`b', rename
		if "`nose'" == "" {
			matrix `b' = e(V)
			mata: st_gsem_lcmargins_order("`b'", "`order'")
			matrix colna `b' = `:colfullna `pclass''
			matrix rowna `b' = `:colfullna `pclass''
			ereturn repost V=`b'
		}
		mata: st_gsem_lcmargins_order("e(error)", "`order'")
	}
	ereturn matrix b_pclass `pclass'
	ereturn local title `"`TITLE'"'
	ereturn local depvar `"`DEPVAR'"'
	ereturn local model_vcetype
	ereturn local model_vce
	ereturn local over

	margins, nopredictlegend `diopts' `coeflegend'

	ereturn local classposteriorpr "`classposteriorpr'"

	SetR
	if "`post'" != "" {
		SetE
	}
end

program SetR, rclass
	tempname t

	matrix `t' = e(b)
	return matrix b `t'

	matrix `t' = r(table)
	return matrix table `t'

	if "`e(V)'" != "" {
		matrix `t' = e(V)
		return matrix V `t'
	}
	return scalar N = e(N)
	return local classposteriorpr `"`e(classposteriorpr)'"'
	return local title `"`e(title)'"'
end

program SetE, eclass
	tempname b
	matrix `b' = r(b)
	if "`r(V)'" == "matrix" {
		tempname V
		matrix `V' = r(V)
	}
	ereturn post `b' `V'
	_r2e, xmat(table) noclear
end

mata:

void st_gsem_lcmargins_nopvalues(string scalar s_mat)
{
	real	vector	mat
	class _b_pclass scalar PC

	mat = st_matrix(s_mat)
	if (allof(mat, PC.value("cilogit"))) {
		st_local("nopvalues", "nopvalues")
	}
}

void st_gsem_lcmargins_order(string scalar s_mat, string scalar s_ord)
{
	real	matrix	mat
	real	matrix	ord

	mat = st_matrix(s_mat)
	ord = st_matrix(s_ord)
	if (rows(mat) == 1) {
		mat = mat[ord]
	}
	else {
		mat = mat[ord,ord]
	}
	st_matrix(s_mat, mat)
}

end
exit
