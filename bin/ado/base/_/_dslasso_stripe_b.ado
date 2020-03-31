*! version 1.0.1  21may2019
program _dslasso_stripe_b, eclass
	version 16.0

	syntax , lasso_noneed(string)	/// 
		[dvars_omit(string)	///
		dvars_full(string) ]
	
	if (`lasso_noneed') {
		exit
		// NotReached
	}
	
	tempname b V		
	mat `b' = e(b)
	mat `V' = e(V)

	mata : update_colname(		///
		`"`b'"',		///
		`"`V'"',		///
		`"`dvars_omit'"',	///
		`"`dvars_full'"')

	ereturn repost b=`b' V=`V', resize buildfvinfo ADDCONS
	ereturn hidden local marginsprop addcons
end

/*---------------------------------------------------------------------------*/
/*
	mata utility
*/
/*---------------------------------------------------------------------------*/
mata :
					//----------------------------//
					// update b and V colstripe
					//----------------------------//
void update_colname(			///
	string scalar	_b,		///
	string scalar	_V,		///
	string scalar	_dvars_omit,	///
	string scalar	_dvars_full)
{
	add_omit(_b, _V, _dvars_omit)
	reorder_mat(_b, _V, _dvars_full)
}
					//----------------------------//
					// add omitted vars to b and V
					//----------------------------//
void add_omit(			///
	string scalar	_b,	///
	string scalar	_V,	///
	string scalar	_dvars_omit)
{
	real vector	b, b_tmp
	real matrix	V, V_tmp
	string matrix	rown, coln, coln_tmp
	string vector	dvars_omit
	real scalar	k

	dvars_omit = tokens(_dvars_omit)
	_lasso_add_bn(dvars_omit)
	k = length(dvars_omit)
	if (k == 0){
		return	
		// NotReached
	}
						//  initial set up
	b = st_matrix(_b)
	V = st_matrix(_V)
	coln = st_matrixcolstripe(_b)
	rown = st_matrixrowstripe(_b)
						// add omit to b
	b_tmp = J(1, k, 0)
	b = (b_tmp, b)
						// add omit to V
	V_tmp = J(k, k, 0)
	V = blockdiag(V_tmp, V)
						// add omit to colname		
	coln_tmp = J(k, 2, "")
	coln_tmp[1..k, 1] = J(k, 1, coln[1,1])
	coln_tmp[1..k, 2] = dvars_omit'
	coln = coln_tmp \ coln
						// reset b and V
	st_matrix(_b, b)
	st_matrix(_V, V)
	st_matrixcolstripe(_b, coln)
	st_matrixrowstripe(_b, rown)
	st_matrixcolstripe(_V, coln)
	st_matrixrowstripe(_V, coln)
}
					//----------------------------//
					// reorder matrix to match the original
					// order
					//----------------------------//
void reorder_mat(		///
	string scalar	_b,	///
	string scalar	_V,	///
	string scalar	_dvars_full)
{
	string matrix	coln_tmp, full_tmp, coln, rown
	real scalar	idx, i
	real matrix	b, V
						//  join by name
	full_tmp = tokens(_dvars_full)
	_lasso_add_bn(full_tmp)

	coln_tmp = st_matrixcolstripe(_b)[., 2]'
	_lasso_add_bn(coln_tmp)

	idx = J(1, 0, .)
	for(i=1; i<=length(full_tmp); i++) {
		idx = (idx, selectindex(coln_tmp:==full_tmp[i]))
	}

	if (length(idx) != length(full_tmp)) {
		errprintf("conformability error\n")
		exit(503)
	}

						//  reorder b and V
	b = st_matrix(_b)
	V = st_matrix(_V)
	b = b[idx]
	V = V[idx, idx]

	coln = st_matrixcolstripe(_b)
	coln = coln[idx, .]
	coln[., 2] = tokens(_dvars_full)'
	rown = st_matrixrowstripe(_b)

	st_matrix(_b, b)
	st_matrixcolstripe(_b, coln)
	st_matrixrowstripe(_b, rown)

	st_matrix(_V, V)
	st_matrixcolstripe(_V, coln)
	st_matrixrowstripe(_V, coln)
}

end
