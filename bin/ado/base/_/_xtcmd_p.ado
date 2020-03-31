*! version 1.1.0  30aug2016
program define _xtcmd_p, sclass
	version 14.1
	local vv : display "version " string(_caller()) ":"
	`vv' Predict `0'
	sreturn local exit exit
end

program Predict, eclass
	version 14.1
	local vv : display "version " string(_caller()) ":"

	if e(cmd) == "xtpoisson" {
		if "`e(model)'" != "re" | "`e(distrib)'" != "Gaussian" {
			di "{err}option {bf:n} not allowed"
			di "{err}{p 0 4 2}marginal predictions allowed " ///
				"only after {bf:xtpoisson, re normal}{p_end}"
			exit 198
		}
		local family poisson
		local link log
		syntax anything [if] [in] [, N *]
		local 0 `anything' `if' `in', mu `options'
	}
	else {
		local family bernoulli
		if e(cmd) == "xtlogit" {
			local link logit
		}
		else if e(cmd) == "xtprobit" {
			local link probit
		}
		else {
			local link cloglog
		}
		syntax anything [if] [in] [, pr *]
		local 0 `anything' `if' `in', pr `options'
		gettoken one two : anything
		if !missing("`two'") local one `two'
		local LABELCMD label var `one' "Pr(`e(depvar)'=1)"
	}

	tempname b sel esto

	mat `b' = e(b)
	_ms_omit_info `b'
	matrix `sel' = r(omit)
	local stripe : colna `b'
	local dim = colsof(`sel')
	local resize 0
	forval i = 1/`dim' {
		gettoken spec stripe : stripe
		if `sel'[1,`i'] {
			_msparse `"`spec'"' , noomit
			local spec `"`r(stripe)'"'
			local j = colnumb(`b', "`spec'")
			if `j' == `i' {
				matrix `sel'[1,`i'] = 0
			}
			else	local resize 1
		}
	}
	if `resize' {
		mata:__xtcmd_resize()
	}

	local ivar `e(ivar)'
	local depvar `e(depvar)'
	local cons = colnumb(`b', "`depvar':_cons") != .
	if "`e(offset1)'" != "" {
		local offset `e(offset1)'
	}
	else	local offset `e(offset)'
	if "`intpoints'" == "" local q `e(n_quad)'
	else local q `intpoints'
	local wexp "`e(wexp)'"
	local wtype "`e(wtype)'"

	matrix coleq `b' = `depvar'
	local names : colfullnames `b'
	mata:__xtcmd_stripe(1)
	local names `names' var(_u[`ivar']):_cons
	mat colnames `b' = `names'

	local k = colsof(`b')
	mat `b'[1,`k'] = exp(`b'[1,`k'])
	local k1 = `k'+1+!`cons'

	// margins needs this instead of `e(covariates)'
	local indeps : colnames `b'
	local indeps : subinstr local indeps "_cons" "", all word

	local N `e(N)'
	local intm `e(intmethod)'

 	local toadd `depvar':_u[`ivar']
 	if !`cons' local toadd `toadd' `depvar':_cons

	mata:__getgsemb("`toadd'",`cons')

	mat colnames `b' = `names'

	qui _est hold `esto', restore

	ereturn post `b'

	// scalars
	ereturn scalar N = `N'
	ereturn scalar k_autoCns = 0
	ereturn scalar k = `k1'
	ereturn scalar k_eq = 2
	ereturn scalar k_rs = 1
	ereturn scalar k_rc = 0
	ereturn scalar k_dv = 1
	ereturn scalar n_quad = `q'

	// hidden scalars
	ereturn scalar estimates = 0
	ereturn scalar k_eq_model = 0
	ereturn scalar mecmd = 0
	ereturn scalar xtcmd = 0
	ereturn scalar irtcmd = 0
	ereturn scalar adapt_maxiter = 1001
	ereturn scalar adapt_tol = 1.00000000000e-08
	ereturn scalar gsem_hascross = 0
	ereturn scalar gsem_ncross = 0
	ereturn scalar gsem_crossdim = 0
	ereturn scalar gsem_nlevels = 1
	ereturn scalar gsem_vers = 2
	ereturn scalar k_gauss = 0
	ereturn scalar k_mult = 0
	ereturn scalar yinfo1_nLsel = 1
	ereturn scalar yinfo1_nREsel = 1
	ereturn scalar yinfo1_cons = `cons'
	ereturn scalar yinfo1_yidx = 1
	ereturn scalar k_yinfo = 1
	ereturn scalar hinfo1_Ldim = 1
	ereturn scalar hinfo1_REpos2 = 1
	ereturn scalar hinfo1_REpos1 = 1
	ereturn scalar hinfo1_Lpos2 = 1
	ereturn scalar hinfo1_Lpos1 = 1
	ereturn scalar hinfo1_xpos2 = 1
	ereturn scalar hinfo1_xpos1 = 1
	ereturn scalar hinfo1_ypos2 = 0
	ereturn scalar hinfo1_ypos1 = 1
	ereturn scalar hinfo1_nLxvars = 1
	ereturn scalar hinfo1_nLyvars = 0
	ereturn scalar k_hinfo = 1
	ereturn scalar listwise = 1

	// macros
	ereturn local cmd "gsem"
	ereturn local method "ml"
	ereturn local intmethod "`intm'"
	ereturn local depvar "`depvar'"
	ereturn local marginsnotok "LATent1(passthru) LATent se(passthru)"
	ereturn local covariates "`indeps'"
	ereturn local marginsdefault "predict(pr outcome(`depvar'))"
	ereturn local link1 "`link'"
	ereturn local family1 "`family'"
	ereturn local offset1 "`offset'"
	ereturn local predict "gsem_p"
	ereturn local estat_cmd "gsem_estat"
	ereturn local wtype "`wtype'"
	ereturn local wexp "`wexp'"

	// hidden macros
	ereturn local yinfo1_finfo_link "`link'"
	ereturn local yinfo1_finfo_family "`family'"
	if "`offset'" != "" {
		if substr("`offset'",1,3) == "ln(" {
			local len : length local offset
			local offset = substr("`offset'",4,`len'-4)
			ereturn local yinfo1_offset "exposure(`offset')"
		}
		else {
			ereturn local yinfo1_offset "offset(`offset')"
		}
	}
	ereturn local yinfo1_xvars "`indeps'"
	ereturn local yinfo1_name "`depvar'"
	ereturn local hinfo1_Linfo1_xvars "_cons"
	ereturn local hinfo1_Linfo1_name "_u[`ivar']"
	ereturn local hinfo1_gvars "`ivar'"
	ereturn local REspec "_u[`ivar']"
	ereturn local Lspec "_u[`ivar']"
	ereturn local adapt_conv "no"

	// matrices
	_b_pclass PCDEF : default
	_b_pclass PCVAR : VAR
	mata: st_matrix("e(_N)",`N')
	mata: st_matrix("e(b_pclass)",(J(1,`=`k1'-1',`PCDEF'),`PCVAR'))

	// hidden matrices
	mata: st_matrix("e(yinfo1_Lsel)",1)
	mata: st_matrix("e(yinfo1_REsel)",1)
	mata: st_matrix("e(hinfo1_V)",1)
	mata: st_matrix("e(hinfo1_M)",0)
	mata: st_matrix("e(b_keep)",1..`k1')
	mata: st_matrix("e(b_idx)",1..`k1')
	mata: __fitorder("`indeps'")

	predict `0' marginal

	`LABELCMD'
end

version 14.1
mata:

void __xtcmd_resize()
{
	string	scalar	lb
	string	matrix	stripe
	real	vector	sel

	lb	= st_local("b")
	stripe	= st_matrixcolstripe(lb)
	sel	= selectindex(st_matrix(st_local("sel")):==0)

	st_matrix(lb, st_matrix(lb)[sel])
	st_matrixcolstripe(lb, stripe[sel,])
}

void __xtcmd_stripe(real scalar i) {
	string vector stripe
	stripe = tokens(st_local("names"))
	stripe = invtokens(stripe[1..cols(stripe)-i])
	st_local("names",stripe)
}

void __getgsemb(string scalar toadd, real scalar cons) {

	real scalar k
	real vector b, b_new
	string vector stripe
	
	b = st_matrix(st_local("b"))
	
	if (cons) {
		k = cols(b)
		b_new = b,b[k]
		b_new[k] = b[k-1]
		b_new[k-1] = 1

		stripe = tokens(st_local("names"))
		stripe = stripe,stripe[k]
		stripe[k] = stripe[k-1]
		stripe[k-1] = toadd
		stripe = invtokens(stripe)
	}
	else {
		k = cols(b)
		b_new = b,b[k],b[k]
		b_new[k+1] = 0
		b_new[k] = 1

		toadd = tokens(toadd)
		stripe = tokens(st_local("names"))
		stripe = stripe,stripe[k],stripe[k]
		stripe[k+1] = toadd[2]
		stripe[k] = toadd[1]
		stripe = invtokens(stripe)
	}
	
	st_matrix(st_local("b"),b_new)
	st_local("names",stripe)
}

void __fitorder(string scalar covars) {

	real scalar x
	real vector m
	string vector indeps
	
	indeps = tokens(covars)
	x = cols(indeps)
	
	if (x) {
		m = 1..x,x+2,x+1,x+3
	}
	else {
		m = (2,1,3)
	}

	st_matrix("e(b_fitorder)",m)
}

end
exit

