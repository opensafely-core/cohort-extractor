*! version 1.0.5  05sep2019

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile __stmatrix.matah
quietly include `"`r(fn)'"'

findfile __stparam_vector.matah
quietly include `"`r(fn)'"'

findfile __tempnames.matah
quietly include `"`r(fn)'"'

findfile __lvhierarchy.matah
quietly include `"`r(fn)'"'

findfile __component.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_object.matah
quietly include `"`r(fn)'"'

findfile __sub_expr.matah
quietly include `"`r(fn)'"'

findfile __bayes_expr.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

void __bayes_expr::new()
{
	clear()
	set_special(NULL,SPECIAL_APP_BAYES)

	m_parind.reinit("string")
	m_parind.notfound(J(1,0,0))
}

void __bayes_expr::destroy()
{
	clear()
}

void __bayes_expr::clear()
{
	super.clear()

	m_parind.clear()
	m_markout_depvar = `SUBEXPR_FALSE'
}

void __bayes_expr::reset_parse()
{
	real scalar type, i, bi
	real rowvector o
	string scalar el, group, name
	string rowvector vstripe
	string matrix stripe
	pointer (class __component_base) scalar pC

	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_EXP') {
		return	// nothing to do
	}
	if (m_param.cols()) {
		stripe = m_param.colstripe()
		vstripe = (stripe[.,1]:+":":+stripe[.,2])'
		/* store all initialized coefficient values		*/
		pC = iterator_init()
		while (pC != NULL) {
			type = pC->type()
			if (type!=`SUBEXPR_LC_PARAM' & type!=`SUBEXPR_PARAM' &
				type!=`SUBEXPR_FV_PARAM' & 
				type!=`SUBEXPR_LV_PARAM') {
				goto Next
			}
			group = pC->group()
			name = pC->name()
			if (!ustrlen(group)) {
				group = "/"
			}
			el = sprintf("%s:%s",group,name)
			o = strmatch(vstripe,el)
			if (!any(o)) {
				goto Next
			}
			i = selectindex(o)[1]
			bi = m_param.el(1,i)
			(void)pC->update(bi,`SUBEXPR_HINT_VALUE')
		
			Next: pC = iterator_next()
		}
	}
	m_parind.clear()
	m_parind.notfound(J(1,0,0))

	m_exprdep.clear()
	m_exprdep.notfound(J(1,0,NULL))

	if (!m_multi_eq) {
		m_multi_eq = .	// reset to unknown
	}
	m_dirty = `SUBEXPR_DIRTY_PARSED'
}

real scalar __bayes_expr::_parse_equation(string scalar expression,
			|string scalar eqname, string scalar touse)
{
	if (m_dirty <= `SUBEXPR_DIRTY_RESOLVED_EXP') {
		/* programmer error					*/
		set_errmsg("cannot parse after resolving expressions; use " +
			"class function {bf:__bayes_expr::reset_parse()} to " +
			"allow further parsing")
		return(498)
	}
	return(super._parse_equation(expression,eqname,touse))
}

real scalar __bayes_expr::_parse_expression(string scalar expression,
			|string scalar exname, string scalar touse)
{
	real scalar rc

	if (m_dirty <= `SUBEXPR_DIRTY_RESOLVED_EXP') {
		/* programmer error					*/
		set_errmsg("cannot parse after resolving expressions; use " +
			"class function {bf:__bayes_expr::reset_parse()} to " +
			"allow further parsing")
		return(498)
	}
	if (rc=super._parse_expression(expression,exname,touse)) {
		return(rc)
	}
	return(rc)
}

real scalar __bayes_expr::_parse_expr_init(string scalar exinit)
{
	return(super._parse_expr_init(exinit))
}

void __bayes_expr::update_dirty_ready()
{
	if (m_dirty <= `SUBEXPR_DIRTY_RESOLVED_EXP') {
		m_dirty = `SUBEXPR_DIRTY_READY'
	}
}

void __bayes_expr::error_code(real scalar ec, |transmorphic arg1, 
		transmorphic arg2, transmorphic arg3, transmorphic arg4,
		transmorphic arg5)
{
	super.error_code(ec,arg1,arg2,arg3,arg4,arg5)
}

/* virtual function for special resolve handling 			*/
real scalar __bayes_expr::_resolve_group(
		pointer (class __component_group) scalar pG,
		pointer (class __component_group) vector pargrps)
{
	pragma unused pG
	pragma unused pargrps

	return(0)
}

real scalar __bayes_expr::_resolve_expressions(|string scalar tvar,
			string scalar gvar)
{
	if (m_dirty > `SUBEXPR_DIRTY_PARSED') {
		set_errmsg("not ready to resolve expressions")
		dirty_message()
		return(498)
	}
	if (m_dirty <= `SUBEXPR_DIRTY_RESOLVED_EXP') {
		/* programmer error					*/
		set_errmsg("expressions are already resolved; use class " +
			"function {bf:__bayes_expr::reset_parse()} to allow " +
			"further parsing and to resolve expressions")
		return(498)
	}
	return(super._resolve_expressions(tvar,gvar))
}

real scalar __bayes_expr::set_param_from_spec(string scalar init, 
			|real scalar skip)
{
	return(super.set_param_from_spec(init,skip))
}

real scalar __bayes_expr::set_param_from_vec(real vector b)
{
	return(super.set_param_from_vec(b))
}

real scalar __bayes_expr::set_param_by_stripe(real vector b, string matrix spec)
{
	string matrix stripe
	real vector ind

	if (rows(spec)==1 & cols(spec)==1) {
		/* equation name					*/
		ind = m_parind.get(spec[1,1])
		if (length(ind)) {
			return(super.set_param_by_index(b,ind))
		}
		stripe = expr_stripe(spec)	// updates m_parind
	}
	else {
		stripe = spec
	}
	return(super.set_param_by_stripe(b,stripe))
}

string matrix _bayes_expr_matrix_group_stripe(
			pointer (class __sub_expr_group) pG)
{
	string scalar gname
	string matrix stripe
	pointer (class __sub_expr_elem) scalar pE

	gname = pG->name()
	stripe = J(0,2,"")
	pE = pG->first()
	while (pE != NULL) {
		if (pE->type() != `SUBEXPR_MATRIX') {
			goto Next
		}
		if (pE->group() == gname) {
			/* parameter matrix in this group		*/
			stripe = (stripe\(gname,pE->name()))
		}
		Next: pE = pE->next()
	}
	return(stripe)	
}

real scalar __bayes_expr::set_param_by_index(real vector b, real vector index)
{
	return(super.set_param_by_index(b,index))
}

class __stmatrix scalar __bayes_expr::stparameters()
{
	return(super.stparameters())
}

void _bayes_expr_append_stripe(string matrix stripe, string matrix stripe1,
		|real vector types, real scalar type)
{
	real scalar i, k
	real colvector io
	string scalar name
	string vector vstripe

	if (!rows(stripe1)) {
		return
	}
	if (!rows(stripe)) {
		stripe = stripe1
		if (args() > 2) {
			types = J(1,rows(stripe),type)
		}
		return
	}
	if (stripe1[1,1] == "/") {
		/* free parameter: rows(stripe1) == 1			*/
		io = strmatch(stripe[.,2],stripe1[1,2])
		if (any(io)) {
			io = selectindex(io)
			if (!any(strmatch(stripe[io,1],"/"))) {
				stripe = (stripe\stripe1[1,.])
				if (args() > 2) {
					types = (types,type)
				}
			}
		}
		else {
			stripe = (stripe\stripe1[1,.])
			if (args() > 2) {
				types = (types,J(1,rows(stripe1),type))
			}
		}
		return
	}
	/* LC or parameter group					*/
	vstripe = stripe[.,1]:+":":+stripe[.,2]
	k = rows(stripe1)
	for (i=1; i<=k; i++) {
		name = stripe1[i,1]+":"+stripe1[i,2]
		io = strmatch(vstripe,name)
		if (!any(io)) {
			stripe = (stripe\stripe1[i,.])
			if (args() > 2) {
				types = (types,type)
			}
		}
	}
}

string matrix __bayes_expr::mat_stripe(|string scalar exname)
{
	real scalar i, k, type, gtype, gtype1
	string scalar name
	string matrix stripe, stripe1
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pCG, pCG1
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __sub_expr_group) scalar pG

	stripe = J(0,2,"")
	if (!ustrlen(exname)) {
		return(stripe)
	}
	pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',exname))
	if (pC == NULL) {	// not a group name
		add_warning(sprintf("group {bf:%s} not found",exname))
		return(stripe)
	}
	pCG = pC		// cast to a group component
	gtype = pCG->group_type()
	if (gtype!=`SUBEXPR_GROUP_EXPRESSION' &
		gtype!=`SUBEXPR_EQ_EXPRESSION' &
		gtype!=`SUBEXPR_GROUP_PARAM') {
		add_warning(sprintf("matrix parameters cannot be contained " +
			"in a %s object",pCG->sgroup_type()))
		return(stripe)		
	}
	k = pCG->group_count()
	for (i=1; i<=k; i++) {
		pG = pCG->get_object(i)
		pE = pG->first()
		while (pE != NULL) {
			pC = pE->component()
			if (pC == NULL) { // string expression if NULL
				goto Next
			}
			type = pC->type()
			name = pC->name()
			if (type == `SUBEXPR_GROUP') {
				pCG1 = pC
				gtype1 = pCG1->group_type()
				if (gtype1 == `SUBEXPR_GROUP_PARAM') {
					stripe1 = 
					_bayes_expr_matrix_group_stripe(pE)
				}
				else if (gtype1 == `SUBEXPR_GROUP_EXPRESSION') {
					if (name == exname) {
						/* should not happen	*/
						goto Next
					}
					stripe1 = mat_stripe(name)
				}
				else {
					goto Next
				}
				if (rows(stripe1)) {
					_bayes_expr_append_stripe(stripe,
						stripe1)
				}
			}
			else if (type == `SUBEXPR_MATRIX') {
				if (pC->group() != `SUBEXPR_MAT_GROUP') {
					/* do not include matrices in 
					 * the expression that are not
					 * parameters			*/
					_bayes_expr_append_stripe(stripe,
						(pC->group(),name))
				}
			}
			Next: pE = pE->next()
		}
	}
	k = rows(stripe)
	if (k > 1) {
		stripe = sort(stripe,(1,2))
	}
	return(stripe)
}

string matrix __bayes_expr::expand_FV_stripe(string matrix stripe,
		real vector types)
{
	real scalar i, k, ks
	string vector fvnames
	string matrix stripe1
	pointer (class __component_base) scalar pC

	k = rows(stripe)
	if (!k) {
		return(J(0,2,""))
	}
	if (!any(types:==`SUBEXPR_FV')) {
		return(stripe)
	}
	stripe1 = J(0,2,"")
	for (i=1; i<=k; i++) {
		if (types[i] != `SUBEXPR_FV') {
			stripe1 = (stripe1\stripe[i,.])
			continue
		}
		pC = lookup_component(stripe[i,.])
		if (pC == NULL) {
			/* should not happen				*/
			continue
		}
		fvnames = pC->data(`SUBEXPR_HINT_FV_NAMES')
		ks = length(fvnames)
		if (ks) {
			stripe1 = (stripe1\(J(ks,1,stripe[i,1]),fvnames'))
		}
	}
	return(stripe1)
}

real scalar __bayes_expr::update_parindex(string scalar exname,
			string matrix stripe)
{
	real scalar i, k, j
	real vector ind, io
	string matrix parstripe

	k = rows(stripe)
	ind = J(1,k,.)
	parstripe = m_param.colstripe()
	for (i=1; i<=k; i++) {
		io = strmatch(parstripe,stripe[i,.])
		j = selectindex(io[.,1]:&io[.,2])
		if (!length(j)) {
			/* should not happen				*/
			set_errmsg(sprintf("parameter {bf:%s} not found",
				invtokens(stripe[i,.],":")))
			return(111)
		}
		ind[i] = j[1]
	}
	m_parind.put(exname,ind)

	return(0)
}

string matrix __bayes_expr::expr_stripe(|string scalar exname0)
{
	real scalar i, k, ks, klv, rc
	real vector types, io, jo, ind
	real matrix ieq
	string scalar exname
	string matrix stripe, stripe0, stripe1, LVstripe, LVstripe1
	string matrix cstripe
	pointer (class __component_base) scalar pC

	exname = exname0
	stripe0 = stripe = J(0,2,"")

	if (m_dirty <= `SUBEXPR_DIRTY_RESOLVED_EXP') {
		stripe = super.param_stripe()
		if (!strlen(exname)) {
			return(stripe)
		}
		ind = m_parind.get(exname)
		if (length(ind)) {
			stripe = stripe[ind,.]
			return(stripe)
		}
	}	
	if (!ustrlen(exname)) {
		return(stripe)
	}
	pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',exname))
	if (pC == NULL) {	// not a group name
		if (usubstr(exname,1,1) != "/") {
			exname = "/"+exname
			pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',exname))
		}
	}
	if (pC == NULL) {
		add_warning(sprintf("group {bf:%s} not found",exname))
		return(stripe)
	}
	stripe = LVstripe = J(0,2,"")
	types = J(1,0,0)
	rc = _expr_stripe(pC,stripe0,types,LVstripe)

	pC = NULL
	if (rc) {
		return(stripe)
	}
	k = rows(stripe0)
	klv = rows(LVstripe)
	if (!(k+klv)) {
		return(stripe)
	}
	if (m_dirty <= `SUBEXPR_DIRTY_RESOLVED_EXP') {
		stripe = super.param_stripe()
	}
	if (rows(stripe)) {
		stripe0 = expand_FV_stripe(stripe0,types)
		k = rows(stripe0)
		if (rows(klv)) {
			stripe0 = (stripe0\LVstripe)
			k = k + klv
		}
		/* put in m_param stripe order				*/
		io = J(k,1,.)
		for (i=1; i<=k; i++) {
			jo = strmatch(stripe,stripe0[i,.])
			jo = selectindex(jo[.,1]:&jo[.,2])
			if (length(jo)) {
				/* always				*/
				io[i] = jo[1]
			}
		}
		k = length(io)
		if (k) {
			io = order(io,1)	// missings to the end
			stripe = stripe0[io,.]
		}
	}
	else if (rows(stripe0)) {
		ieq = panelsetup(stripe0,1)
		stripe = stripe0[ieq[.,1],1]
		io = order(stripe,1)
		ieq = ieq[io,.]
		k = rows(ieq)
		stripe = J(0,2,"")
		for (i=1; i<=k; i++) {
			stripe1 = stripe0[|ieq[i,1],1\ieq[i,2],2|]
			stripe1 = sort(stripe1,2)
			ks = rows(stripe1)
			io = strmatch(stripe0[.,2],"_cons")
			cstripe = J(0,2,"")

			if (any(io)) {
				cstripe = stripe1[select(1::ks,io),.]
				io = 1:-io
				stripe1 = stripe1[select(1::ks,io),.]
			}
			if (klv) {
				io = strmatch(LVstripe[.,1],stripe1[1,1])
				if (any(io)) {
					LVstripe1 = LVstripe[selectindex(io),.]
					LVstripe1 = sort(LVstripe1,2)
					stripe1 = (stripe1\LVstripe1)
				}
			}
			if (rows(cstripe)) {	
				stripe1 = (stripe1\cstripe)
			}
			stripe = (stripe\stripe1)
		}
		/* now expand FV					*/
		stripe = expand_FV_stripe(stripe,types)
	}
	else if (klv) {
		stripe = sort(LVstripe,(1,2))
	}
	if (rows(stripe)) {
		(void)update_parindex(exname, stripe)
	}

	return(stripe)
}

real scalar __bayes_expr::_expr_stripe(
		pointer (class __component_group) scalar pC,
		string matrix stripe, real vector types,
		|string matrix LVstripe)
{
	real scalar i, k, rc
	pointer (class __sub_expr_group) scalar pG

	rc = 0
	if (pC == NULL) {
		return(0)
	}

	k = pC->group_count()
	for (i=1; i<=k; i++) {
		pG = pC->get_object(i)
		if (rc=group_stripe(pG,stripe,types,LVstripe)) {
			break
		}
	}
	pC = NULL
	pG = NULL
	return(rc)
}

real scalar __bayes_expr::group_stripe(
		pointer (class __sub_expr_group) scalar pG, 
		string matrix stripe, real vector types,
		|string matrix LVstripe)
{
	real scalar type, gtype, lvstripe
	real scalar index, rc
	string matrix stripe1
	pointer (class __component_base) scalar pC
	pointer (class __sub_expr_elem) scalar pE, pEq

	rc = 0
	if (pG == NULL) {
		return(rc)
	}
	lvstripe = has_multi_eq()
	gtype = pG->group_type()
	pE = pG->first()
	while (pE != NULL) {
		type = pE->type()
		if (type == `SUBEXPR_GROUP') {
			if (rc=group_stripe(pE,stripe,types,LVstripe)) {
				break
			}
		}
		else if (type == `SUBEXPR_PARAM') {
			if (gtype == `SUBEXPR_GROUP_PARAM') {
				stripe1 = (pG->name(),pE->name())
			}
			else {
				stripe1 = ("/",pE->name())
			}
			_bayes_expr_append_stripe(stripe, stripe1, types, type)
		}
		else if (type==`SUBEXPR_LC_PARAM' |
			type==`SUBEXPR_FV_PARAM' |
			type==`SUBEXPR_FV') {
			stripe1 = (pG->name(),pE->name())
			_bayes_expr_append_stripe(stripe, stripe1, types, type)
		}
		else if (type==`SUBEXPR_LV' & lvstripe) {
			pC = pE->component()
			pEq = pG->eqobj()
			if (pEq == NULL) {
				goto Next
			}
			index = pC->data(`SUBEXPR_HINT_COEF_INDEX',pEq->name())
			if (index) {
				stripe1 = (pEq->name(),pE->name())
				_bayes_expr_append_stripe(LVstripe, stripe1,
					types, type)
			}
		}
		Next: pE = pE->next()
	}
	pE = NULL
	pEq = NULL
	pC = NULL

	return(rc)
}

void __bayes_expr::set_mat_parameter(transmorphic spec, |string scalar name,
		string scalar option)
{
	real scalar rc

	if (rc=_set_mat_parameter(spec,name,option)) {
		error_and_exit(rc)	// black hole
	}
}

real scalar __bayes_expr::_set_mat_parameter(transmorphic spec, 
			|string scalar name, string scalar option)
{
	if (isstring(spec)) {
		/* spec: matname = values				*/
		return(set_matrix_from_spec(spec,name,option))
	}
	/* spec is a Mata matrix and option is the destination name	*/
	return(set_matrix_from_mat(spec,name,option))
}

real scalar __bayes_expr::set_matrix_from_spec(string scalar spec,
		|string scalar name0, string scalar option)
{
	real scalar rc
	string scalar tok, errmsg, name, group
	real matrix X
	pointer (class __component_base) scalar pC
	transmorphic te

	pragma unset errmsg
	pragma unset X
	pragma unset group

	rc = 0
	name = name0
	if (ustrlen(name0) == 0) {
		te = tokeninit(" ",("="))
		tokenset(te,spec)

		name = tokenget(te)
		tok = tokenpeek(te)
		if (tok == "=") {
			tok = tokenget(te)
		}
		__sub_expr_decompose_name(name, group)

		if (rc | !st_isname(name)) {
			set_errmsg("invalid matrix initialization; if a " +
				"matrix name argument is not used " +
				"specification format is: {it:name} = " +
				"{it:number_list}")
			return(198)
		}
		if (ustrlen(group)) {
			name0 = group+":"+name
		}
		else {
			name0 = name
		}
	}
	else {
		__sub_expr_decompose_name(name, group)
		if (!st_isname(name)) {
			set_errmsg(sprintf("invalid matrix name {bf:%s}",name))
			return(198)
		}
	}
	pC = lookup_component((group,name))
	if (pC == NULL) {
		if (ustrlen(group)) {
			if (usubstr(group,1,1) != "/") {
				group = "/"+group
			}
		}
		else {
			group = "/"
		}
		pC = lookup_component((group,name))
	}
	if (pC == NULL) {
		set_errmsg(sprintf("matrix {bf:%s} not found",name0))
		return(111)
	}
	if (pC->type() != `SUBEXPR_MATRIX') {
		set_errmsg(sprintf("expected a matrix but {bf:%s} is a " +
			"%s",name0,pC->stype()))
		return(459)
	}
	spec = tokenrest(te)
	rc = _parse_initial_matrix(name,spec,option,X,errmsg)
	if (rc) {
		set_errmsg(errmsg)
		return(rc)
	}
	if (rc=pC->update(X,`SUBEXPR_HINT_MATRIX')) {
		set_errmsg(pC->errmsg())
	}
	return(rc)
}

real scalar __bayes_expr::set_matrix_from_mat(real matrix mat,
		string scalar name0, |string scalar option)
{
	real scalar rc, r, c
	real matrix X
	string scalar group, name
	pointer (class __component_base) scalar pC

	pragma unset group

	name = name0
	__sub_expr_decompose_name(name, group)
	if (!st_isname(name)) {
		set_errmsg(sprintf("invalid matrix name {bf:%s}",name))
		return(198)
	}
	pC = lookup_component((group,name))
	if (pC == NULL) {
		if (ustrlen(group)) {
			if (usubstr(group,1,1) != "/") {
				group = "/"+group
				pC = lookup_component((group,name))
			}
		}
	}
	if (pC == NULL) {
		set_errmsg(sprintf("matrix {bf:%s} not found",name0))
		return(111)
	}
	if (pC->type() != `SUBEXPR_MATRIX') {
		set_errmsg(sprintf("expected a matrix but {bf:%s} is a " +
			"%s",name0,pC->stype()))
		return(459)
	}
	r = rows(mat)
	c = cols(mat)
	if (!r | !c) {
		set_errmsg(sprintf("invalid initialization matrix: dimension " +
			"is %g x %g",r,c))
		return(503)
	}
	if (option == "invvech") {		// matrix = invvech(vector)
		if (r>1 & c>1) {
			set_errmsg("invalid initialization matrix when " +
				"using option {bf:invvech}: vector required")
			return(503)
		}
		if (c == 1) {
			X = invvech(mat)
		}
		else {
			X = invvech(mat')
		}
	}
	else if (option == "vech") {		// vector =vech(matrix)
		X = vech(mat)
	}
	else if (option == "diagonal") {	// vector = diagonal(matrix)
		if (r != c) {
			set_errmsg("invalid initialization matrix " +
				"when using option {bf:diagonal}: square " +
				"matrix required")
			return(503)
		}
		X = diagonal(mat)
	}
	else if (option == "diag") {		// matrix = diag(vector)
		if (r>1 & c>1) {
			set_errmsg("invalid initialization matrix when " +
				"using option {bf:diag}: vector required")
			return(503)
		}
		X = diag(mat)
	}
	else {
		X = mat
	}
	if (rc=pC->update(X,`SUBEXPR_HINT_MATRIX')) {
		set_errmsg(pC->errmsg())
	}
	return(rc)
}

class __stmatrix scalar __bayes_expr::mat_stparameter(string name0)
{
	string scalar name, group
	pointer (class __component_base) scalar pC
	class __stmatrix scalar nullmat, X

	pragma unset group

	name = name0
	__sub_expr_decompose_name(name,group)
	pC = lookup_component((group,name))
	if (pC == NULL) {
		if (ustrlen(group)) {
			if (usubstr(group,1,1) != "/") {
				group = "/"+group
			}
		}
		else {
			group = "/"
		}
		pC = lookup_component((group,name))
	}
	if (pC == NULL) {
		add_warning(sprintf("matrix {bf:%s} not found",name0))
		return(nullmat)
	}
	if (pC->type() != `SUBEXPR_MATRIX') {
		add_warning(sprintf("expected a matrix but {bf:%s} is a " +
				"%s",name0,pC->stype()))
		return(nullmat)
	}
	X = pC->data(`SUBEXPR_HINT_STMATRIX')

	return(X)
}

real matrix __bayes_expr::mat_parameter(string scalar name)
{
	return((mat_stparameter(name)).m())
}

real scalar __bayes_expr::_gen_hierarchy_panel_info(|string scalar expr)
{
	return(super._gen_hierarchy_panel_info(expr))
}

real matrix __bayes_expr::path_index_matrix(string scalar path)
{
	real scalar k, i, nooutput, ivar, n, rc
	real vector isstr
	real matrix index
	string scalar type, cmd, tvar
	string vector varlist

	/* returns the path varlist data in hierarchy order		*/
	if (!ustrlen(path)) {
		return(J(1,0,""))
	}
	varlist = path_index_varlist(path)
	k = length(varlist)
	if (!k) {
		/* no variables; path involves special symbol,
		 * e.g. _n, return copy of generated vector		*/
		return(J(1,1,path_index_vector(path)))
	}
	isstr = J(1,k,`SUBEXPR_FALSE')
	for (i=1; i<=k; i++) {
		type = st_vartype(varlist[i])
		isstr[i] = (substr(type,1,3)=="str")
	}
	if (!any(isstr)) {
		/* no string variables					*/
		return(st_data(.,varlist,m_touse))
	}
	n = sum(st_data(.,m_touse))
	index = J(n,k,.)
	tvar = st_tempname()	// Stata tempname ok here
	nooutput = `SUBEXPR_TRUE'
	for (i=1; i<=k; i++) {
		if (!isstr[i]) {
			index[.,i] = st_data(.,varlist[i],m_touse)
			continue
		}
		cmd = sprintf("egen long %s = group(%s) if %s",tvar,varlist[i],
			m_touse)
		if (rc=_stata(cmd,nooutput)) {
			/* must exit					*/
			set_errmsg(sprintf("could not generate index vector " +
				"for string variable {bf:%s}",varlist[i]))
			exit(rc)
		}
		index[.,i] = st_data(.,tvar,m_touse)
		ivar = _st_varindex(tvar)
		if (!missing(ivar)) {
			st_dropvar(ivar)
		}
	}
	return(index)
}

string vector __bayes_expr::path_index_varlist(string scalar path)
{
	real scalar rc
	class __lvpath scalar tree

	/* returns the path varlist in hierarchy order			*/
	if (!ustrlen(path)) {
		return(J(1,0,""))
	}
	if (!m_hierarchy.path_count()) {
		return(J(1,0,""))
	}
	if (rc=tree.init("__temp",path)) {
		set_errmsg(sprintf("invalid path {bf:%s}: %s",path,
			tree.errmsg()))
		error_and_exit(rc)	// black hole
	}
	return(tokens(tree.varlist()))
}

string vector __bayes_expr::varlist(|string scalar ename, real scalar nameonly)
{
	return(super.varlist(ename,nameonly))
}

void __bayes_expr::return_post(|real scalar ereturn)
{
	super.return_post(ereturn)
}

void __bayes_expr::cert_post()
{
	super.cert_post()
}

void __bayes_expr::display_equations()
{
	super.display_equations()
}

void __bayes_expr::display_expressions()
{
	super.display_expressions()
}

pointer (class __component_base) scalar __bayes_expr::lookup_component(
			string vector key)
{
	pointer (class __component_base) scalar pC
	string vector key1

	pC = super.lookup_component(key)
	if (pC==NULL & key[1]==`SUBEXPR_GROUP_SYMBOL' & 
		usubstr(key[2],1,1)!="/") {
		key1 = (key[1],"/"+key[2])
		/* Bayes does multiple parse/resolve's which can result
		 *  in a group marked as a parameter group during
		 *  parsing stage e.g. /name:				*/
		pC = super.lookup_component(key1)
		if (pC != NULL) {
			key = key1
		}
	}
	return(pC)
}

end

exit
