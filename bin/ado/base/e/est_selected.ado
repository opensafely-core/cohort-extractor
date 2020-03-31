*! version 1.0.6  21jun2019
program est_selected, rclass
	version 16

	syntax [anything] [,			///
		DIsplay(string)			///
		sort(string)			///
		noLEGend			///
		lassocoef			/// not documented
		NOALLBASElevels	ALLBASElevels	/// not allowed
		NOBASElevels	BASElevels	/// not allowed
		NOEMPTYcells	EMPTYcells	/// not allowed
		NOOMITted	OMITted		/// not allowed
		*				///
	]

	if "`legend'" == "" {
		local Legend Legend
	}
	else	local Legend "*"

	NotAllowed,			///
		`noallbaselevels'	///
		`allbaselevels'		///
		`nobaselevels'		///
		`baselevels'		///
		`noemptycells'		///
		`emptycells'		///
		`noomitted'		///
		`omitted'		///
					 // blank

	ParseEstList `anything', default(.)
	local names `s(names)'
	local subspace_list `s(subspace_list)'

	if (`"`names'"' == "") {
		exit
	}

	ParseDisplay `display'
	local info	"`s(info)'"
	local eform	"`s(eform)'"
	local format	"`s(format)'"
	local ctype	"`s(coef_type)'"

	ParseSort `sort'
	local sort_on	"`s(sort_on)'"
	local csort	"`s(coef_type)'"

	_get_diopts diopts, `options'

	tempname hcurrent
	_est hold `hcurrent', restore nullok

	tempname Md

	local skip names none
	if "`sort_on'" == "coef" {
		tempname Ms
	}

	local i 0
	foreach name of local names {
		local ++i
		local subspace : word `i' of `subspace_list'

		if (`"`subspace'"' != "_NONE") {
			RestoreLasso `name', subspace(`subspace')
			local eqname `s(eqname)'
			GetCoef `i' `eqname' `Md' "`ctype'" `info' 0
			if "`Ms'" != "" {
				GetCoef `i' `eqname' `Ms' "`csort'" `info' 1
			}
		}
		else if "`name'" != "." {
			quietly estimates restore `name', nostxerfile

			CheckInferLasso,  `lassocoef'

			GetCoef `i' `name' `Md' "`ctype'" `info' 0
			if "`Ms'" != "" {
				GetCoef `i' `name' `Ms' "`csort'" `info' 1
			}
		}
		else {
			_est unhold `hcurrent'
		capture noisily {
			CheckInferLasso,  `lassocoef'

			GetCoef `i' active `Md' "`ctype'" `info' 0
			if "`Ms'" != "" {
				GetCoef `i' `name' `Ms' "`csort'" `info' 1
			}
		}
		local rc = c(rc)
			_est hold `hcurrent', restore nullok
			if `rc' {
				exit `rc'
			}
		}
		local coefused `coefused' `coef`i''
		if "`Ms'" != "" {
			local sortused `sortused' `sort`i''
		}
	}

	matrix `Md' = `Md''
	if "`Ms'" != "" {
		matrix `Ms' = `Ms''
	}
	if "`sort_on'" == "names" {
		mata: _est_sel_sortnames("`Md'")
	}
	else if "`sort_on'" == "coef" {
		mata: _est_sel_sortcoef("`Md'", "`Ms'"')
	}

	if inlist("`info'", "x", "u") {
		mata: _est_sel_xcode("`Md'")
		local center center
	}
	else if "`eform'" != "" {
		mata: _est_sel_eform("`Md'")
	}

	local c = colsof(`Md')
	forval i = 1/`c' {
		local formats `formats' `format'
	}

	local diopts codes `center' format(`formats') `diopts'

	local w = fmtwidth("`format'") + 1
	local width = c(linesize) - 14
	local maxcols = floor(`width'/`w')
	if `maxcols' < 2 {
		local maxcols 2
	}
	if `c' <= `maxcols' {
		display
		_matrix_table `Md', `diopts' puttab
		return add
		`Legend' `info'
	}
	else {
		tempname sub
		local i 0
		local PT 0
		while `i' < `c' {
			local ++PT
			mata: _est_sel_sub("i","`Md'", "`sub'", `maxcols')
			display
			_matrix_table `sub', `diopts' puttabsuffix(`PT')
			return add
			local put_tables `put_tables' PT`PT'
			`Legend' `info'
		}
		return hidden local put_tables `put_tables'
	}
	return local names "`names'"
	return matrix coef `Md'
	return hidden local coef_list `"`coefused'"'
	if "`Ms'" != "" {
		return hidden local sort_list `"`sortused'"'
	}
end

program NotAllowed
	syntax [, NOOPTIONS]
end

program ParseDisplay, sclass
	gettoken info : 0, parse(" ,")
	if inlist(`"`info'"', ",", "") {
		local info x
	}
	else {
		gettoken info 0 : 0, parse(" ,")
	}

	local arglist x u coef
	if `:list info in arglist' == 0 {
		di as err "option {bf:display(`info')} invalid;"
		di as err "{bf:`info'} not recognized"
		exit 198
	}

	local nooptions x u
	if `:list info in nooptions' {
		capture syntax [, NOOPTIONS]
		if c(rc) {
			di as err "option {bf:display(`info')} invalid;"
			di as err "suboptions not allowed"
			exit 198
		}
	}
	else if "`info'" == "coef" {
		local syntax		///
		syntax [,		///
			eform		///
			Format(string)	///
			*		///
		]
		capture `syntax'
		if c(rc) {
			di as err "option {bf:display(coef)} invalid;"
			`syntax'
			exit 198 // [sic]
		}
		if `:list sizeof format' > 1 {
			di as err "option {bf:display(coef)} invalid;"
			di as err ///
	"too many formats specified in suboption {bf:format()}"
			exit 198
		}
		if "`format'" != "" {
			capture confirm numeric format `format'
			if c(rc) {
				di as err "option {bf:display(coef)} invalid;"
				confirm numeric format `format'
				exit 7 // [sic]
			}
		}
		local coef_type	`options'
		if `:list sizeof coef_type' > 1 {
			di as err "option {bf:display(coef)} invalid;"
			opts_exclusive "`coef_type'"
			exit 198 // [sic]
		}
	}
	if "`format'" == "" {
		local format %9.0g
	}
	sreturn local info	"`info'"
	sreturn local eform	"`eform'"
	sreturn local format	"`format'"
	sreturn local coef_type	"`coef_type'"
end

program ParseSort, sclass
	gettoken on : 0, parse(" ,")
	if inlist(`"`on'"', ",", "") {
		local on none
	}
	else {
		gettoken on 0 : 0, parse(" ,")
	}

	if `"`on'"' == "name" {
		local on names
	}
	local arglist none names coef
	if `:list on in arglist' == 0 {
		di as err "option {bf:sort(`on')} invalid;"
		di as err "{bf:`on'} not recognized"
		exit 198
	}

	if `"`on'"' == "coef" {
		local syntax syntax [, *]
		capture `syntax'
		if c(rc) {
			di as err "option {bf:sort(coef)} invalid;"
			`syntax'
			exit 198 // [sic]
		}
		local coef_type	`options'
		if `:list sizeof coef_type' > 1 {
			di as err "option {bf:sort(coef)} invalid;"
			opts_exclusive "`coef_type'"
			exit 198 // [sic]
		}
	}
	else {
		capture syntax [, NOOPTIONS]
		if c(rc) {
			di as err "option {bf:sort(`on')} invalid;"
			di as err "suboptions not allowed"
			exit 198
		}
	}

	sreturn local sort_on "`on'"
	sreturn local coef_type "`coef_type'"
end

program CheckType
	args C_MAC COLON NAME TYPE ISSORT

	local COEFOPTS	`"`e(est_sel_coefopts)'"'
	local B		`"`e(est_sel_b)'"'
	local COEFDFLT	`"`e(est_sel_coefdefault)'"'

	if `"`TYPE'`COEFOPTS'"' == "" {
		// nothing to check
		exit
	}

	if `ISSORT' {
		local OPT "sort()"
	}
	else {
		local OPT "display()"
	}

	if `"`TYPE'"' == "" {
		local LC = strlower(`"`COEFOPTS'"')
		if `"`COEFDFLT'"' == "" {
			local list : subinstr local LC " " ", "
			di as err `"option {bf:`OPT'} invalid for {bf:`NAME'};"'
			di as err `"{p 0 0 2}"'
			di as err `"please select one of the following"'
			di as err `"coefficient vectors:"'
			di as err `"`LC'"'
			di as err `"{p_end}"'
			exit 198
		}
		local TYPE `"`COEFDFLT'"'
	}

	local 0 `", `TYPE'"'
	capture syntax [, `COEFOPTS']
	if c(rc) {
		di as err `"option {bf:`OPT'} invalid for {bf:`NAME'};"'
		di as err `"{p 0 0 2}"'
		di as err `"coefficient vector {bf:`TYPE'} not recognized"'
		di as err `"{p_end}"'
		exit 198
	}

	foreach COEF of local COEFOPTS {
		local LC = strlower("`COEF'")
		if `"``LC''"' != "" {
			local FOUND : copy local LC
			continue, break
		}
	}

	if `"`FOUND'"' == "" {
		di as err `"option {bf:`OPT'} invalid for {bf:`NAME'};"'
		di as err `"{p 0 0 2}"'
		di as err `"coefficient vector {bf:`TYPE'} not recognized"'
		di as err `"{p_end}"'
		exit 322
	}
	if `"`FOUND'"' == "`B'" {
		exit
	}
	c_local `C_MAC' e(b_`FOUND')
end

program GetCoef
	args i name M type info issort

	tempname b

	local eb e(b)
	CheckType eb : `name' "`type'" `issort'
	if `"``eb''"' != "matrix" {
		di as err "matrix {bf:`eb'} not found in {bf:`name'}"
		exit 322
	}
	matrix `b' = `eb'
	matrix `b' = `b'[1,"#1:"]
	mata: _est_sel_stripe_fixup("`b'", "`name'")
	if "`info'" == "u" {
		mata: _est_sel_lasso_add_z("`b'")
		local missing ".u"
	}
	else	local missing ".z"

	if `i' == 1 {
		local join `b'
	}
	else {
		local join `M' `b'
	}
	matrix rowjoinbyname `M' = `join', code missing(`missing')

	if `issort' {
		c_local sort`i' `eb'
	}
	else {
		c_local coef`i' `eb'
	}
end

program Legend
	args info
	di as txt "Legend:"
	di as txt "  b - base level" 
	di as txt "  e - empty cell"
	di as txt "  o - omitted" 
	if inlist("`info'", "x", "u") {
		di as txt "  x - estimated"
	}
	if "`info'" == "u" {
		di as txt "  u - not selected for estimation"
	}
end

program ParseEstList, sclass
	syntax [anything] [, *]

	while (`"`anything'"' != "") {
		gettoken tmp anything: anything , match(paren)
		if (`"`paren'"' == "") {
			local regular_list `regular_list' `tmp'
		}
		else {
			CheckLassoEst `tmp'
			local lasso_list `lasso_list' || `tmp'
		}
	}

	if (!(`"`lasso_list'"' != "" & `"`regular_list'"' == "")) {
		est_expand `"`regular_list'"', `options'
		local regular_names `r(names)'
		local regular_names : list uniq regular_names
	}

	lasso_est_expand , lasso_list(`lasso_list')
	local lasso_names `r(lasso_names)'
	local lasso_subspace `r(lasso_subspace)'
	
	foreach sub of local regular_names {
		local dummy_subspace `dummy_subspace' _NONE
	}

	local names `lasso_names' `regular_names'
	local subspace_list `lasso_subspace' `dummy_subspace'
	
	sret local names `names'
	sret local subspace_list `subspace_list'
end

program RestoreLasso, sclass
	syntax anything(name=namelist), subspace(passthru)

	esrf post_stored `namelist', `subspace'

	local depvar `e(depvar)'
	local xfold_idx `e(xfold_idx)'
	local resample_idx `e(resample_idx)'

	if (`"`namelist'"' != ".") {
		local eqname `namelist':`depvar'
	}
	else {
		local eqname `depvar'
	}

	if (`"`xfold_idx'"' != "") {
		local eqname `eqname'_`xfold_idx'
	}

	if (`"`resample_idx'"' != "") {
		local eqname `eqname'_`resample_idx'
	}

	sret local eqname `eqname'
end

program CheckLassoEst
	syntax [anything(name=est)] [, *]

	if (`"`est'"' == "") {
		di as err "invalid syntax"
		exit 198
	}
end

program CheckInferLasso
	syntax [, lassocoef ]

	if (`"`lassocoef'"' == "") {
		exit
		// NotReached
	}

	if (`"`e(lasso_infer)'"' != "") {
		di as err "option {bf:for()} required after {bf:`e(cmd)'}" 
		exit 198
	}
		
end

mata:

void _est_sel_stripe_fixup(string scalar m, string scalar name)
{
	string	matrix	stripe
	real	matrix	info

	stripe = st_matrixcolstripe(m)
	stripe[,1] = J(rows(stripe),1,"")
	info = st_matrixcolstripe_fvinfo(m)
	st_matrixcolstripe(m, stripe)
	st_matrixcolstripe_fvinfo(m, info)

	st_matrixrowstripe(m, ("", name))
}

void _est_sel_lasso_add_z(string scalar m)
{
	string	vector	allvars
	real	scalar	dim
	real	vector	add
	real	scalar	i
	string	scalar	name
	real	scalar	rc
	real	scalar	pos
	real	matrix	M
	real	scalar	cols
	string	matrix	rstripe
	string	matrix	cstripe

	if (st_global("e(lasso)") != "lasso") {
		return
	}

	allvars = tokens(st_global("e(allvars)"))
	dim = cols(allvars)
	add = J(1,dim,0)
	for (i=1; i<=dim; i++) {
		name = allvars[i]
		rc = _msparse(name, -1, 1)
		if (rc) exit(rc)
		pos = st_matrixcolnumb(m, ("", name))
		if (missing(pos)) {
			add[i] = 1
		}
	}
	if (allof(add, 0)) {
		return
	}
	add = selectindex(add)
	allvars = allvars[add]
	dim = cols(add)

	M = st_matrix(m)
	cols = cols(M)
	M = M, J(1,dim,.z)
	rstripe = st_matrixrowstripe(m)
	cstripe = J(cols+dim, 2, "")
	cstripe[|_2x2(1,1,cols,2)|] = st_matrixcolstripe(m)
	cstripe[|_2x2(cols+1,2,cols+dim,2)|] = allvars'

	st_matrix(m, M)
	st_matrixrowstripe(m, rstripe)
	st_matrixcolstripe(m, cstripe)
}

void _est_sel_sortnames(string scalar md)
{
	real	vector	order
	real	matrix	M
	string	matrix	rstripe
	string	matrix	cstripe

	order	= st_matrixrowstripe_order(md)
	M	= st_matrix(md)
	rstripe	= st_matrixrowstripe(md)
	cstripe	= st_matrixcolstripe(md)
	st_matrix(md, M[order,])
	st_matrixrowstripe(md, rstripe[order,])
	st_matrixcolstripe(md, cstripe)
}

void _est_sel_sortcoef(
	string	scalar	md,
	string	matrix	ms)
{
	real	matrix	M
	string	matrix	rstripe
	string	matrix	cstripe
	real	vector	order

	M = st_matrix(ms)
	order = order((-abs(editmissing(M,0)),(1::rows(M))), (1..(cols(M)+1)))
	if (md != ms) {
		M = st_matrix(md)
	}
	rstripe = st_matrixrowstripe(md)
	cstripe = st_matrixcolstripe(md)

	st_matrix(md, M[order,])
	st_matrixrowstripe(md, rstripe[order,])
	st_matrixcolstripe(md, cstripe)
}

void _est_sel_xcode(string scalar m)
{
	real	matrix	M
	string	matrix	rstripe
	string	matrix	cstripe
	real	scalar	r, rows
	real	scalar	c, cols
	real	vector	sel

	M = st_matrix(m)
	rstripe = st_matrixrowstripe(m)
	cstripe = st_matrixcolstripe(m)

	rows = rows(M)
	cols = cols(M)
	for (r=1; r<=rows; r++) {
		for (c=1; c<=cols; c++) {
			if (!missing(M[r,c])) {
				M[r,c] = .x
			}
		}
	}

	sel = rowsum(M:==.b)+rowsum(M:==.e)+rowsum(M:==.o)+rowsum(M:==.x)
	M = select(M, sel)
	rstripe = select(rstripe, sel)

	st_matrix(m, M)
	st_matrixrowstripe(m, rstripe)
	st_matrixcolstripe(m, cstripe)
}

void _est_sel_eform(string scalar m)
{
	real	matrix	M
	string	matrix	rstripe
	string	matrix	cstripe
	real	scalar	r, rows
	real	scalar	c, cols

	M = st_matrix(m)
	rstripe = st_matrixrowstripe(m)
	cstripe = st_matrixcolstripe(m)

	rows = rows(M)
	cols = cols(M)
	for (r=1; r<=rows; r++) {
		for (c=1; c<=cols; c++) {
			if (!missing(M[r,c])) {
				M[r,c] = exp(M[r,c])
			}
		}
	}

	st_matrix(m, M)
	st_matrixrowstripe(m, rstripe)
	st_matrixcolstripe(m, cstripe)
}

void _est_sel_sub(
	string	scalar	imacro,
	string	scalar	m,
	string	scalar	sub,
	real	scalar	maxcols)
{
	real	matrix	M
	real	scalar	cols
	string	matrix	rstripe
	string	matrix	cstripe
	real	vector	sel
	real	scalar	i
	real	scalar	i0
	real	scalar	i1

	M = st_matrix(m)
	cols = cols(M)
	rstripe = st_matrixrowstripe(m)
	cstripe = st_matrixcolstripe(m)

	if (cols < maxcols) {
		maxcols = cols
	}

	i = strtoreal(st_local(imacro))
	if (i == 0) {
		i0 = 2
		i1 = maxcols
	}
	else {
		i0 = i+1
		i1 = i+maxcols
		if (i1 > cols) {
			i1 = cols
		}
		if (i0 > i1) {
			i0 = i1
		}
	}
	sel = 1, (i0..i1)

	st_matrix(sub, M[,sel])
	st_matrixrowstripe(sub, rstripe)
	st_matrixcolstripe(sub, cstripe[sel,])

	st_local(imacro, strofreal(i1))
}

end

exit
