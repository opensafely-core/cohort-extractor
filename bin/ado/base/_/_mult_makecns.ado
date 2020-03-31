*! version 1.0.0  07may2014
program _mult_makecns, eclass
	version 13.1
	syntax ,	EQlist(string)		///
			ibase(integer)		///
			Constraints(string)	///
		[	OUTcomes(name)		///
			rhs(string)		///
			noCONStant		///
		]

	if "`constant'" == "" {
		local rhs `rhs' _cons
	}
	local dim : list sizeof rhs
	local neq : list sizeof eqlist

	tempname E bi b

	local EQLIST : copy local eqlist
	forval i = 1/`neq' {
		gettoken eq EQLIST : EQLIST
		matrix `bi' = J(1,`dim',0)
		matrix colna `bi' = `rhs'
		matrix coleq `bi' = `eq'
		matrix `b' = nullmat(`b'), `bi'
	}

	_est hold `E', nullok restore
	ereturn post `b', eqvalues(`outcomes')

	capture confirm matrix `constraints'
	if c(rc) {
		MakeCnsList ,	ibase(`ibase')			///
				constraints(`constraints')	///
				rhs(`rhs')
	}
	else {
		MakeCnsMat `ibase' `constraints'
	}
end

program MakeCnsList, rclass
	syntax , ibase(integer) constraints(numlist integer) rhs(string)

	tempname c
	_ms_eq_info
	local neq = r(k_eq)
	local dim = r(k1)

	forval i = 1/`dim' {
		gettoken xvar rhs : rhs
		constraint free
		constraint `r(free)' [#`ibase']:`xvar' = 0
		local clist0 `clist0' `r(free)'
	}

	makecns `clist0' `constraints', r
	if r(k) <= `dim' {
		exit
	}
	matrix `c' = e(Cns)
	mata: _mult_makecns_drop_base_eq("`c'", `ibase', `dim', `r(k_autoCns)')
	return matrix Cns `c'
	return local nocnsreport nocnsreport
end

program MakeCnsMat, rclass
	args ibase constraints

	tempname I J sel c
	_ms_eq_info
	local neq = r(k_eq)
	local dim = r(k1)

	if colsof(`constraints') == (`neq'-1)*`dim' + 1 {
		return matrix Cns `constraints'
		exit
	}
	matrix `I' = I(`dim')
	matrix `J' = J(`dim',`dim',0)
	forval i = 1/`neq' {
		if `i' == `ibase' {
			matrix `c' = nullmat(`c'), `I'
		}
		else {
			matrix `c' = nullmat(`c'), `J'
		}
	}
	matrix `c' = `c', J(`dim',1,0)
	if colsof(`constraints') != colsof(`c') {
		di as err "invalid constraints() option;"
		di as err "matrix `constraints' is not conformable"
		exit 198
	}
	matrix `c' = `c' \ `constraints'
	makecns `c', r nocnsnotes
	if r(k) <= `dim' {
		di as txt ///
"(note: constraint matrix '`constraints'' caused error {search r(412)})"
		exit
	}
	matrix `c' = e(Cns)
	mata: _mult_makecns_drop_base_eq("`c'", `ibase', `dim', `r(k_autoCns)')
	return matrix Cns `c'
	return local nocnsreport nocnsreport
end

mata:

void _mult_makecns_drop_base_eq(
	string	scalar	st_cmat,
	real	scalar	ibase,
	real	scalar	dim,
	real	scalar	k_auto)
{
	string	matrix	stripe
	real	matrix	cmat
	real	vector	rsel
	real	vector	csel
	real	scalar	p0
	real	scalar	p1

	stripe	= st_matrixcolstripe(st_cmat)
	cmat	= st_matrix(st_cmat)
	rsel	= J(rows(cmat),1,1)
	csel	= J(1,cols(cmat),1)

	p1	= ibase*dim
	p0	= p1 - dim + 1

	csel[|_2x2(1,p0,1,p1)|] = J(1,dim,0)
	rsel[|_2x2(k_auto+1,1,k_auto+dim,1)|] = J(dim,1,0)

	cmat	= select(select(cmat, csel), rsel)
	stripe	= select(stripe, csel')

	p0	= rows(cmat)
	p1	= cols(cmat) - 1 

	rsel	= rowsum(cmat[|_2x2(1,1,p0,p1)|] :== 0) :!= p1

	if (anyof(rsel,0)) {
		cmat = select(cmat, rsel)
	}

	st_matrix(st_cmat, cmat)
	st_matrixcolstripe(st_cmat, stripe)
}

end

exit
