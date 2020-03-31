*! version 1.1.1  09may2017

program u_mi_postbv
	version 11

	nobreak mata: _e_repost(0, "", 1)
	mata: st_global("e(cmd)", st_global("e(ecmd_mi)"))
	mata: st_global("e(cmd2)", st_global("e(ecmd2_mi)"))
	if "`e(cmd_mi)'"=="regress" & "`e(prefix)'"=="" {
		mata: st_global("e(prefix)", "mi estimate")
	}
	mata: st_global("e(predict)", st_global("e(_predict_mi)"))
	mata: st_global("e(marginsok)", st_global("e(_marginsok_mi)"))
	mata: st_global("e(estat_cmd)", st_global("e(_estat_cmd_mi)"))
end

program postbV, eclass
	
	tempname b V
	mat `b' = e(b_mi)
	mat `V' = e(V_mi)
        if ("`e(Cns_mi)'"=="matrix") {
                tempname C
                mat `C' = e(Cns_mi)
        }
	eret clear
	eret post `b' `V' `C'
end


version 11

local TS	transmorphic scalar
local RS	real scalar
local SS	string scalar
local SV	string vector
local SC	string colvector

local EV	struct _e_element vector

mata:

struct _e_element {
	`SS'	typecode	// "mac": macro
				// "n"	: numscalar
				// "s"	: string scalar
				// "m"	: matrix
				// "mr"	: matrix rowstripe
				// "mc"	: matrix colstripe
				// "mfv": matrix colstripe fvinfo
	`SS'	name
	`TS'	contents
}

/*
	'ltype' =  0:  all estim. results are saved (default)
	'ltype' = -1:  all estim. results except 'list' are saved
	'ltype' =  1:  all estim. results in 'list' are saved
*/
void _e_repost(`RS' ltype, `SS' strlist, |`RS' postbV)
{
	transmorphic	e
	`SV'		list

	list = tokens(strlist)

	if (ltype==0) {
		if (postbV!=1) return 
	}
	else if (ltype<0) {
		if (length(list)==0) return 
	}
	else {
		if (length(list)==0) {
			st_eclear()
			return
		}
	}
	e = _e_save(ltype, list)
	//-estimates save- requires -eret post- to be run
	stata(sprintf("postbV")) 
	_e_post(e, -1, tokens("b V Cns"))
}


`EV' _e_save(|`RS' ltype, `SV' list)
{
	`EV'	e
	`SC'	macro, numscalar, strscalar, mat
	`SS'	basename
	`RS'	i, k

	if (args()==0) {
		ltype = 0
		list  = J(0, 1, "")
	}
	else if (args()==1) {
		_error(3001)
	}

	macro     = _e_filter(st_dir("e()", "macro", "*"), 	ltype, list)
	numscalar = _e_filter(st_dir("e()", "numscalar", "*"),	ltype, list)
	strscalar = _e_filter(st_dir("e()", "strscalar", "*"),	ltype, list)
	mat       = _e_filter(st_dir("e()", "matrix", "*"),	ltype, list)

	e = _e_element(1, rows(macro) + rows(numscalar) + 
				rows(strscalar) + 4*rows(mat))

	k = 0
	for (i=1; i<=rows(macro); i++) { 
		e[++k].typecode = "mac"
		e[k].name     = macro[i]
		e[k].contents = st_global(sprintf("e(%s)", macro[i]))
	}

	for (i=1; i<=rows(numscalar); i++) {
		e[++k].typecode = "n"
		e[k].name       = numscalar[i]
		e[k].contents   = st_numscalar(sprintf("e(%s)", numscalar[i]))
	}

	for (i=1; i<=rows(strscalar); i++) {
		e[++k].typecode = "s"
		e[k].name       = strscalar[i]
		e[k].contents   = st_numscalar(sprintf("e(%s)", strscalar[i]))
	}

	for (i=1; i<=rows(mat); i++) {
		basename = sprintf("e(%s)", mat[i])

		e[++k].typecode = "m"
		e[k].name       = mat[i]
		e[k].contents   = st_matrix(basename)

		e[++k].typecode = "mr"
		e[k].name       = mat[i]
		e[k].contents   = st_matrixrowstripe(basename)
		
		e[++k].typecode = "mc"
		e[k].name       = mat[i]
		e[k].contents   = st_matrixcolstripe(basename)
		
		e[++k].typecode = "mfv"
		e[k].name       = mat[i]
		e[k].contents   = st_matrixcolstripe_fvinfo(basename)
	}
	return(e)
}

/* static */ `SC' _e_filter(`SC' vec, `RS' ltype, `SV' list)
{
	`RS'	n, m, i
	`SC'	result

	if (ltype == 0) return(vec)
	if ((rows(list))==0) return(ltype<0 ? vec : J(0, 1, ""))
	
	n = rows(vec)
	result = J(n,  1, "")
	m = 0
	if (ltype==(-1)) {	// 'list' contains elements to be removed
		for (i=1; i<=n; i++) { 
			if (!_e_in(vec[i], list)) result[++m] = vec[i]
		}
	}
	else {		// 'list' contains elements to be kept
		for (i=1; i<=n; i++) { 
			if (_e_in(vec[i], list)) result[++m] = vec[i]
		}
	}
	return(m ? result[1..m] : J(0, 1, ""))
}

void _e_post(`EV' e, |`RS' ltype, `SV' list)
{
	`RS'	in, i
	`SS'	fullname

	if (args()==1) {
		ltype = 0 
		list  = J(0, 1, "")
	}
	else if (args()==2) {
		_error(3001)
	}
	in = 1
	for (i=1; i<=cols(e); i++) {
		if (ltype) {
			in = _e_in(e[i].name, list) 
			if (ltype<0) in = !in
		}
		if (in) {
			fullname = sprintf("e(%s)", e[i].name)
			if (e[i].typecode == "mac") {
				st_global(fullname, e[i].contents)
			}
			else if (e[i].typecode == "n") {
				st_numscalar(fullname, e[i].contents)
			}
			else if (e[i].typecode == "s") {
				st_strscalar(fullname, e[i].contents)
			}
			else if (e[i].typecode == "m") {
				st_matrix(fullname, e[i].contents)
			}
			else if (e[i].typecode == "mr") {
				st_matrixrowstripe(fullname, e[i].contents)
			}
			else if (e[i].typecode == "mc") {
				st_matrixcolstripe(fullname, e[i].contents)
			}
			else if (e[i].typecode == "mfv") {
				st_matrixcolstripe_fvinfo(fullname,
					e[i].contents)
			}
			else {
				errprintf("_e_post(): unknown typecode\n")
				_error(3498)
				/*NOTREACHED*/
			}
		}
	}
}


`RS' _e_in(`SS' el, `SV' list)
{
	`RS'	i, n

	n = length(list) 
	for (i=1; i<=n; i++) {
		if (el==list[i]) return(1) 
	}
	return(0)
}

end

exit
