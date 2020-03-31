*! version 1.0.0  08may2019
version 16

mata:

class st_matrix__joinbyname {

protected:

	// set by the caller

	string	scalar		type
	string	rowvector	list
	real	scalar		missCode
	real	scalar		consolidate
	real	scalar		encode_omit
	real	scalar		ignore_omit

	// status

	real	scalar		nfrom

	real	scalar		valid
	real	scalar		built

	string	scalar		st_result

	real	matrix		result
	string	matrix		rowstripe
	string	matrix		colstripe

	// subroutines

	void			require_valid()
	void			require_built()
	void			check_target()

	void			addEmptyRows()
	void			Join1()
	string	rowvector	SplitOnEq()
	void			Join()
	void			Consolidate()
	void			OmitUnset()
	void			EncodeOmits()

public:

	// constructor

	void			new()

	// setup

				type()
				list()

	// options

				missing_code()
				consolidate()
				encode_omit()
				ignore_omit()

	// actions

	void			validate()
	void			join()
	void			post()

	real	matrix		result()
	string	matrix		rowstripe()
	string	matrix		colstripe()
}

// private methods ----------------------------------------------------------

void st_matrix__joinbyname::require_valid()
{
	assert(valid)
}

void st_matrix__joinbyname::require_built()
{
	require_valid()
	assert(built)
}

void st_matrix__joinbyname::check_target(string scalar name)
{
	string	scalar	target
	string	vector	notallowed

	target = strtrim(name)
	if (target == "") {
		errprintf("target matrix name not specified\n")
		exit(198)
	}

	notallowed = tokens("e(b) e(V) e(Cns)")
	if (anyof(notallowed, target)) {
		exit(error(198))
	}
}

void st_matrix__joinbyname::addEmptyRows(
	string	scalar	to,
	string	matrix	fm)
{
	real	scalar	rc
	string	matrix	torstripe
	string	matrix	tocstripe
	string	matrix	fmrstripe
	real	matrix	mmat

	torstripe = st_matrixrowstripe(to)
	tocstripe = st_matrixcolstripe(to)
	fmrstripe = st_matrixrowstripe(fm)
	mmat = st_matrix(to)
	mmat = mmat \ J(rows(fmrstripe),cols(mmat),missCode)
	torstripe = torstripe \ fmrstripe
	st_matrix(to, mmat)
	rc = _st_putmatrixrowstripe(to, torstripe)
	if (rc) exit(rc)
	rc = _st_putmatrixcolstripe(to, tocstripe)
	if (rc) exit(rc)
}

void st_matrix__joinbyname::Join1(
	string	scalar	to,
	string	scalar	fm)
{
	// Purpose:
	// 	stack the rows of 'to' onto the rows of 'fm', while
	// 	matching on their column stripe
	//
	// Assumption:
	// 	'to' and 'fm' have the same equation in their column
	// 	stripes

	real	scalar	rc
	real	matrix	tomat
	string	matrix	tostripe
	real	scalar	todim
	real	vector	toremain
	real	vector	tosubidx
	string	scalar	tosub
	real	matrix	fmmat
	real	vector	fmremain
	string	matrix	fmstripe
	string	matrix	rstripe
	real	scalar	rows
	real	scalar	cols
	real	matrix	resmat
	real	scalar	r1
	real	scalar	r2
	real	scalar	dim
	real	scalar	i
	string	vector	copy
	real	scalar	pos
	string	scalar	tapp
	string	scalar	cmd

	tomat = st_matrix(to)
	tostripe = st_matrixcolstripe(to)
	todim = cols(tomat)
	toremain = J(1,todim,1)
	tosubidx = selectindex(toremain)
	tosub = st_tempname()
	cmd = sprintf("matrix %s = %s", tosub, to)
	rc = _stata(cmd)
	if (rc) exit(rc)

	fmmat = st_matrix(fm)
	fmremain = J(1,cols(fmmat),1)
	fmstripe = st_matrixcolstripe(fm)

	rstripe = st_matrixrowstripe(to) \ st_matrixrowstripe(fm)

	rows = rows(rstripe)
	cols = rows(tostripe)
	resmat = J(rows,cols,missCode)
	resmat[|_2x2(1,1,rows(tomat),todim)|] = tomat
	r1 = rows(tomat) + 1
	r2 = rows(tomat) + rows(fmmat)

	dim = rows(fmstripe)
	for (i=1; i<=dim; i++) {
		pos = st_matrixcolnumb(tosub, fmstripe[i,])
		if (pos == .) {
			copy = fmstripe[i,2]
			rc = _msparse(copy, -1)
			if (rc) exit(rc)
			copy = fmstripe[i,1], copy
			pos = st_matrixcolnumb(tosub, copy)
		}
		if (pos == .) {
			continue
		}

		fmremain[i] = 0
		pos = tosubidx[pos]
		toremain[pos] = 0
		resmat[|_2x2(r1,pos,r2,pos)|] = fmmat[,i]

		tosubidx = selectindex(toremain)
		if (cols(tosubidx) == 0) {
			break
		}

		st_matrix(tosub, tomat[,tosubidx])
		rc = _st_putmatrixcolstripe(tosub, tostripe[tosubidx,])
		if (rc) exit(rc)
	}

	cmd = sprintf("matrix drop %s", tosub)
	rc = _stata(cmd)
	if (rc) exit(rc)

	st_matrix(to, resmat)
	rc = _st_putmatrixrowstripe(to, rstripe)
	if (rc) exit(rc)
	rc = _st_putmatrixcolstripe(to, tostripe)
	if (rc) exit(rc)

	if (any(fmremain)) {
		fmremain = selectindex(fmremain)
		dim = cols(fmremain)
		fmmat = J(rows(tomat),dim,missCode) \ fmmat[,fmremain]
		tapp = st_tempname()
		st_matrix(tapp, fmmat)
		rc = _st_putmatrixrowstripe(tapp, rstripe)
		if (rc) exit(rc)
		rc = _st_putmatrixcolstripe(tapp, fmstripe[fmremain,])
		if (rc) exit(rc)

		cmd = sprintf("matrix %s = %s , %s", to, to, tapp)
		rc = _stata(cmd)
		if (rc) exit(rc)

		cmd = sprintf("matrix drop %s", tapp)
		rc = _stata(cmd)
		if (rc) exit(rc)
	}
}

string rowvector st_matrix__joinbyname::SplitOnEq(
	string	scalar		m,
	|string	rowvector	eqlist)
{
	// Purpose:
	// 	split Stata matrix named in 'm' into separate temporary
	// 	matrices for each of its column equations

	real	scalar		rc
	real	matrix		mmat
	real	scalar		rows
	string	matrix		rstripe
	string	matrix		cstripe
	real	matrix		info
	real	scalar		neq
	string	vector		tlist
	real	scalar		eq
	real	matrix		submat
	string	matrix		substripe

	mmat = st_matrix(m)
	rows = rows(mmat)
	rstripe = st_matrixrowstripe(m)
	cstripe = st_matrixcolstripe(m)
	info = panelsetup(cstripe, 1)
	neq = rows(info)

	tlist = J(1,neq,"")
	for (eq=1; eq<=neq; eq++) {
		submat = mmat[|_2x2(1,info[eq,1],rows,info[eq,2])|]
		substripe = cstripe[|_2x2(info[eq,1],1,info[eq,2],2)|]
		tlist[eq] = st_tempname()
		st_matrix(tlist[eq], submat)
		rc = _st_putmatrixrowstripe(tlist[eq], rstripe)
		if (rc) exit(rc)
		rc = _st_putmatrixcolstripe(tlist[eq], substripe)
		if (rc) exit(rc)
	}

	eqlist = cstripe[info[,1],1]'

	return(tlist)
}

void st_matrix__joinbyname::Join(string scalar from)
{
	string	rowvector	tolist
	string	rowvector	eqlist
	real	scalar		nto
	real	scalar		r0
	string	rowvector	fmlist
	real	scalar		nfm
	real	rowvector	fmused
	real	scalar		i
	real	scalar		pos
	string	matrix		rstripe
	string	matrix		cstripe
	real	scalar		rows
	real	matrix		res
	real	matrix		t
	real	scalar		rc
	string	scalar		cmd

	pragma unset eqlist

	tolist = SplitOnEq(st_result, eqlist)
	nto = cols(tolist)
	res = st_matrix(tolist[1])
	r0 = rows(res)

	fmlist = SplitOnEq(from)
	nfm = cols(fmlist)
	fmused = J(1,nfm,0)

	for (i=1; i<=nto; i++) {
		if (eqlist[i] == "") {
			eqlist[i] = "_"
		}
		pos = st_matrixcoleqnumb(from, eqlist[i])
		if (pos == .) {
			addEmptyRows(tolist[i], from)
		}
		else if (fmused[pos]) {
			addEmptyRows(tolist[i], from)
		}
		else {
			fmused[pos] = 1
			Join1(tolist[i], fmlist[pos])
		}
	}

	rstripe = st_matrixrowstripe(tolist[1])
	cstripe = J(0,2,"")
	rows = rows(rstripe)
	res = J(rows,0,missCode)
	for (i=1; i<=nto; i++) {
		res = res, st_matrix(tolist[i])
		cstripe = cstripe \ st_matrixcolstripe(tolist[i])
		cmd = sprintf("matrix drop %s", tolist[i])
		rc = _stata(cmd)
		if (rc) exit(rc)
	}

	for (i=1; i<=nfm; i++) {
		if (fmused[i] == 0) {
			t = st_matrix(fmlist[i])
			t = J(r0,cols(t),missCode) \ t
			res = res, t
			cstripe = cstripe \ st_matrixcolstripe(fmlist[i])
		}
		cmd = sprintf("matrix drop %s", fmlist[i])
		rc = _stata(cmd)
		if (rc) exit(rc)
	}

	st_matrix(st_result, res)
	rc = _st_putmatrixrowstripe(st_result, rstripe)
	if (rc) exit(rc)
	rc = _st_putmatrixcolstripe(st_result, cstripe)
	if (rc) exit(rc)
}

void st_matrix__joinbyname::Consolidate(string scalar smat)
{
	string	scalar	rhold
	string	scalar	cmd
	real	scalar	rc
	string	matrix	msinfo
	string	matrix	rstripe
	string	matrix	cstripe
	real	matrix	info
	real	scalar	neq
	real	scalar	dim
	real	matrix	order
	real	scalar	pos
	transmorphic	Emap
	transmorphic	Tmap
	real	scalar	eq
	real	scalar	Eidx
	real	scalar	nel
	real	scalar	el
	string	scalar	term
	real	scalar	Tidx
	real	matrix	mmat

	// preserve -r()-
	rhold = st_tempname()
	cmd = sprintf("_return hold %s", rhold)
	rc = _stata(cmd)
	if (rc) exit(rc)

	msinfo = sprintf("_ms_element_info, matrix(%s)", smat)
	rstripe = st_matrixrowstripe(smat)
	cstripe = st_matrixcolstripe(smat)
	info = panelsetup(cstripe,1)
	neq = rows(info)
	dim = info[neq,2]
	order = J(dim,3,missCode)
	pos = 0
	Tmap = asarray_create("string", 1, dim)
	asarray_notfound(Tmap, 0)
	Emap = asarray_create("string", 1, dim)
	asarray_notfound(Emap, 0)
	for (eq=1; eq<=neq; eq++) {
		Eidx = asarray(Emap, cstripe[pos+1,1])
		if (Eidx == 0) {
			Eidx = eq
			asarray(Emap, cstripe[pos+1,1], Eidx)
		}
		nel = info[eq,2] - info[eq,1] + 1
		for (el=1; el<=nel; el++) {
			cmd = sprintf("%s eq(#%f) el(%f)", msinfo, eq, el)
			rc = _stata(cmd)
			if (rc) exit(rc)

			pos++
			order[pos,1] = Eidx
			order[pos,3] = pos

			term = st_global("r(term)")
			Tidx = asarray(Tmap, term)
			if (Tidx == 0) {
				if (term == "_cons") {
					Tidx = .
				}
				else {
					Tidx = pos
				}
				asarray(Tmap, term, Tidx)
			}
			order[pos,2] = Tidx
		}
	}

	order = order(order, (1,2,3))
	cstripe = cstripe[order,]
	mmat = st_matrix(smat)[,order]
	st_matrix(smat, mmat)
	rc = _st_putmatrixrowstripe(smat, rstripe)
	if (rc) exit(rc)
	rc = _st_putmatrixcolstripe(smat, cstripe)
	if (rc) exit(rc)

	// restore -r()-
	rc = _stata("_prefix_clear, rclass")
	if (rc) exit(rc)
	cmd = sprintf("_return restore %s", rhold)
	rc = _stata(cmd)
	if (rc) exit(rc)
}

void st_matrix__joinbyname::EncodeOmits(string scalar smat)
{
	string	scalar	rhold
	string	scalar	cmd
	real	scalar	rc
	real	matrix	omit
	real	matrix	mmat
	real	matrix	codes
	real	scalar	dim
	real	scalar	rows
	real	scalar	i
	string	matrix	rstripe
	string	matrix	cstripe
	real	matrix	info

	// preserve -r()-
	rhold = st_tempname()
	cmd = sprintf("_return hold %s", rhold)
	rc = _stata(cmd)
	if (rc) exit(rc)

	cmd = sprintf("_ms_omit_info %s, code", smat)
	rc = _stata(cmd)
	if (rc) exit(rc)
	omit = st_matrix("r(omit)")
	mmat = st_matrix(smat)

	// restore -r()-
	rc = _stata("_prefix_clear, rclass")
	if (rc) exit(rc)
	cmd = sprintf("_return restore %s", rhold)
	rc = _stata(cmd)
	if (rc) exit(rc)

	codes = strtoreal(tokens(".o .b .e"))

	dim = cols(mmat)
	rows = rows(mmat)
	for (i=1; i<=dim; i++) {
		if (omit[i]) {
			if (allof(mmat[,i],0)) {
				mmat[,i] = J(rows,1,codes[omit[i]])
			}
		}
	}

	if (any(omit)) {
		rstripe = st_matrixrowstripe(smat)
		cstripe = st_matrixcolstripe(smat)
		info = st_matrixcolstripe_fvinfo(smat)
		st_matrix(smat, mmat)
		rc = _st_putmatrixrowstripe(smat, rstripe)
		if (rc) exit(rc)
		rc = _st_putmatrixcolstripe(smat, cstripe)
		if (rc) exit(rc)
		st_matrixcolstripe_fvinfo(smat, info)
	}
}

void st_matrix__joinbyname::OmitUnset(string scalar smat)
{
	real	scalar	rc
	string	scalar	cmd

	cmd = sprintf("_ms_omit_unset %s", smat)
	rc = _stata(cmd)
	if (rc) exit(rc)

	cmd = sprintf("_ms_omit_unset %s, row", smat)
	rc = _stata(cmd)
	if (rc) exit(rc)
}

// public methods -----------------------------------------------------------

void st_matrix__joinbyname::new()
{
	type = "row"
	list = J(1,0,"")
	missCode = .
	consolidate = 1
	encode_omit = 0
	ignore_omit = 0

	nfrom = 0

	valid = 0
	built = 0
}

function st_matrix__joinbyname::type(|string scalar typ)
{
	if (args() == 0) {
		return(type)
	}

	string	scalar	msg

	valid = 0
	built = 0
	if (typ == "row") {
		type = "row"
	}
	else if (typ == substr("column",1,max((3,strlen(typ))))) {
		type = "column"
	}
	else {
		if (typ == "") {
			msg = "nothing"
		}
		else {
			msg = sprintf("{bf:%s}", typ)
		}
		errprintf(
			"%s found where {bf:row} or {bf:column} expected\n",
			msg)
		exit(198)
	}
}

function st_matrix__joinbyname::list(|string vector from)
{
	if (args() == 0) {
		return(list)
	}

	real	scalar	i
	string	scalar	cmd
	real	scalar	rc

	valid = 0
	built = 0

	list = strtrim(rowshape(from,1))
	list = select(list, list:!="")
	nfrom = cols(list)
	for (i=1; i<=nfrom; i++) {
		cmd = sprintf("confirm matrix %s", list[i])
		rc = _stata(cmd)
		if (rc) exit(rc)
	}
}

function st_matrix__joinbyname::missing_code(|real scalar z)
{
	if (args() == 0) {
		return(missCode)
	}

	valid = 0
	built = 0
	missCode = z
}

function st_matrix__joinbyname::consolidate(|real scalar onoff)
{
	if (args() == 0) {
		return(consolidate)
	}

	valid = 0
	built = 0
	consolidate = onoff != 0
}

function st_matrix__joinbyname::encode_omit(|real scalar onoff)
{
	if (args() == 0) {
		return(encode_omit)
	}

	valid = 0
	built = 0
	encode_omit = onoff != 0
}

function st_matrix__joinbyname::ignore_omit(|real scalar onoff)
{
	if (args() == 0) {
		return(ignore_omit)
	}

	valid = 0
	built = 0
	ignore_omit = onoff != 0
}

void st_matrix__joinbyname::validate(|string scalar name)
{
	if (args()) {
		check_target(name)
	}

	if (valid) {
		return
	}

	if (nfrom == 0) {
		errprintf("no source matrices specified\n")
		exit(198)
	}

	if (encode_omit) {
		string	scalar	msg

		msg = ""
		if (missCode == .b) {
			msg = ".b"
		}
		else if (missCode == .e) {
			msg = ".e"
		}
		else if (missCode == .o) {
			msg = ".o"
		}
		if (msg != "") {
			errprintf("invalid {bf:missing()} option;\n")
			errprintf("{bf:missing(%s)} is not allowed ", msg)
			errprintf("when encoding omitted matrix \n")
			errprintf("%s name elements\n", type)
			exit(198)
		}

		ignore_omit = 1
	}

	valid = 1
	built = 0
}

void st_matrix__joinbyname::join()
{
	if (!valid) {
		validate()
	}
	if (built) {
		return
	}

	real	scalar	rc
	string	scalar	cmd
	real	scalar	i
	string	scalar	tname

	st_result = st_tempname()

	for (i=1; i<=nfrom; i++) {
		tname = st_tempname()
		if (type == "column") {
			cmd = sprintf("matrix %s = %s'", tname, list[i])
		}
		else {
			cmd = sprintf("matrix %s = %s", tname, list[i])
		}
		rc = _stata(cmd)
		if (rc) exit(rc)

		if (encode_omit) {
			EncodeOmits(tname)
		}

		if (ignore_omit) {
			OmitUnset(tname)
		}

		if (consolidate) {
			Consolidate(tname)
		}

		list[i] = tname
	}

	cmd = sprintf("matrix %s = %s", st_result, list[1])
	rc = _stata(cmd)
	if (rc) exit(rc)

	for (i=2; i<=nfrom; i++) {
		Join(list[i])
	}

	if (consolidate) {
		Consolidate(st_result)
	}

	if (type == "column") {
		cmd = sprintf("matrix %s = %s'", st_result, st_result)
		rc = _stata(cmd)
		if (rc) exit(rc)
	}

	result = st_matrix(st_result)
	rowstripe = st_matrixrowstripe(st_result)
	colstripe = st_matrixcolstripe(st_result)

	cmd = sprintf("matrix drop %s", st_result)
	rc = _stata(cmd)
	if (rc) exit(rc)

	built = 1
}

void st_matrix__joinbyname::post(string scalar name)
{
	real	scalar	rc

	require_built()

	check_target(name)

	st_matrix(name, result)
	rc = _st_putmatrixrowstripe(name, rowstripe)
	if (rc) exit(rc)
	rc = _st_putmatrixcolstripe(name, colstripe)
	if (rc) exit(rc)
}

real matrix st_matrix__joinbyname::result()
{
	require_built()
	return(result)
}

string matrix st_matrix__joinbyname::rowstripe()
{
	require_built()
	return(rowstripe)
}

string matrix st_matrix__joinbyname::colstripe()
{
	require_built()
	return(colstripe)
}

// public functions ---------------------------------------------------------

void st_matrix__join_by_name(
	string	scalar	type,
	string	scalar	tomat,
	string	scalar	list,
	real	scalar	missing_code,
	real	scalar	consolidate,
	real	scalar	encode_omit,
	real	scalar	ignore_omit)
{
	class st_matrix__joinbyname scalar p

	p.type(type)
	p.list(tokens(list))
	p.missing_code(missing_code)
	if (!missing(consolidate)) {
		p.consolidate(consolidate != 0)
	}
	if (!missing(encode_omit)) {
		p.encode_omit(encode_omit != 0)
	}
	if (!missing(ignore_omit)) {
		p.ignore_omit(ignore_omit != 0)
	}
	p.validate(tomat)
	p.join()
	p.post(tomat)
}

end
