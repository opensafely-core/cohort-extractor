*! version 1.1.4  23aug2019

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile __tempnames.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_object.matah
quietly include `"`r(fn)'"'

findfile __component.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_object.matah
quietly include `"`r(fn)'"'

findfile __sub_expr.matah
quietly include `"`r(fn)'"'

findfile nlparse_macros.matah
quietly include `"`r(fn)'"'

findfile nlparse.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

/* implementation: __sub_expr_elem 					*/
void __sub_expr_elem::new()
{
	m_comp = NULL
	m_properties = 0
	unlink()
}

void __sub_expr_elem::destroy()
{
//	errprintf("destroying __sub_expr_elem %s ",name()); &this
//	displayas("txt")
	/* call private version here					*/
	m_properties = 0
	_clear()
}

void __sub_expr_elem::clear()
{
	_clear()
}

void __sub_expr_elem::_clear()
{
	if (m_next != NULL) {
		m_next->clear()
	}
	unlink()
}

void __sub_expr_elem::unlink()
{
	real scalar i, k
	string vector vlist
	pointer (class __component_base) scalar pV

	if (m_comp != NULL) {
		if (m_comp->type() == `SUBEXPR_LV') {
			/* latent variable path variables		*/
			vlist = m_comp->data(`SUBEXPR_HINT_VARLIST')
			vlist = tokens(vlist)
			k = length(vlist)
			for (i=1; i<=k; i++) {
				/* special symbols for Bayes		*/
				if (vlist[i]=="_n" | vlist[i]=="_all") {
					continue
				}
				pV = m_data->lookup_component(
					(`SUBEXPR_VAR_GROUP',vlist[i]))
				if (pV == NULL) {
					continue
				}
				/* decrement path-variable component
				 *  reference count 			*/
				(void)pV->update(&this,`SUBEXPR_HINT_REMOVEOBJ')
				pV = NULL
			}
			vlist = m_comp->data(`SUBEXPR_HINT_COVARIATE')
			if (ustrlen(vlist[1])) {
				pV = m_data->lookup_component(("",vlist[1]))
				if (pV != NULL) {
					/* decrement variable component
					 *  reference count 		*/
					(void)pV->update(&this,
						`SUBEXPR_HINT_REMOVEOBJ')
				}
				pV = NULL
			}
		}
		(void)m_comp->update(&this,`SUBEXPR_HINT_REMOVEOBJ')
		m_comp = NULL
	}
	/* debug
	if (m_data) {
		sys_linkcount(*m_data)
	}
	*/
	m_data = NULL
	m_next = NULL
	m_prev = NULL
	m_group = NULL
	m_info = `SUBEXPR_NULL'
	m_options = J(1,0,"")
}

string scalar __sub_expr_elem::pt_stype(real scalar type)
{
	string vector pt_types

	pt_types = (`PT_STR_TYPES')
	
	if (type<1 | type>length(pt_types)) {
		return("unknown")
	}
	return(pt_types[type])
}

string vector __sub_expr_elem::key()
{
	if (m_comp != NULL) {
		return(m_comp->key())
	}
	return(("",""))
}

transmorphic __sub_expr_elem::data(real scalar hint)
{
	if (hint == `SUBEXPR_HINT_COMPONENT') {
		return(component())
	}
	if (hint == `SUBEXPR_HINT_PROPERTIES') {
		return(properties())
	}
	return(super.data(hint))
}

real scalar __sub_expr_elem::update(transmorphic data, real scalar hint)
{
	return(super.update(data,hint))
}

real scalar __sub_expr_elem::isequal(pointer (class __sub_expr_elem) scalar pE)
{
	if (m_comp == NULL) {
		return(`SUBEXPR_FALSE')
	}
	return(m_comp->isequal(pE->component()))
}

real scalar __sub_expr_elem::properties()
{
	return(m_properties)
}

void __sub_expr_elem::set_properties(real scalar prop)
{
	/* no checking, used while cloning				*/
	m_properties = prop
}

real scalar _sub_expr_has_property(real scalar prop0, real scalar prop1)
{
	/* properties are in powers of 10				*/
	return(mod(floor(prop0/prop1),2))
}

real scalar __sub_expr_elem::has_property(real scalar prop)
{
	real scalar hasp

	hasp = _sub_expr_has_property(m_properties,prop)

	return(hasp)
}

void __sub_expr_elem::add_property(real scalar prop)
{
	real scalar l10

	/* properties are in powers of 10				*/
	l10 = log10(prop)
	if (abs(l10-round(l10)) > epsilon(100)) {
		/* programmer error					*/
		errprintf("invalid property flag %g\n",prop)
		exit(498)
	}
	if (!has_property(prop)) {
		m_properties = m_properties + prop
	}
}

void __sub_expr_elem::remove_property(real scalar prop)
{
	real scalar l10

	/* properties are in powers of 10				*/
	l10 = log10(prop)
	if (floor(l10) != l10) {
		/* programmer error					*/
		errprintf("invalid property flag %g\n",prop)
		exit(498)
	}
	if (has_property(prop)) {
		m_properties = m_properties - prop
	}
}

void __sub_expr_elem::display(real scalar lev)
{
	real scalar ind

	if (m_comp == NULL) {
		return("")
	}
	m_comp->display(lev)
	if (m_comp->type()==`SUBEXPR_LC_PARAM' & m_info==`SUBEXPR_PARAM') {
		/* access LC parameter only, ignore associated
		 *  variable						*/
		ind = max((1,4*(missing(lev)?0:lev-1))) + 15
		printf("{col %g}{txt}(parameter only)\n", ind)
	}		
}

real scalar __sub_expr_elem::validate_options(string vector opts, 
		real vector kmin)
{
	real scalar rc
	string scalar errmsg

	pragma unset errmsg

	if (!has_options()) {
		return(0)
	}
	if (rc=__sub_expr_validate_options(m_options,opts,kmin,errmsg)) {
		m_data->set_errmsg(errmsg)
	}
	return(rc)
}

real scalar __sub_expr_elem::traverse_param(struct nlparse_node scalar node,
		|string scalar group)
{
	real scalar val, valdef, val0, type, rc
	string scalar tname
	struct nlparse_node opt
	class __tempnames scalar tn
	pointer (class __component_base) scalar pC

	pragma unset pC

	if (node.type != `PARAMETER') {
		/* programmer error					*/
		m_data->set_errmsg(sprintf("invalid object {%bf:%s}: " +
			"expected a free parameter, but got a %s",node.symb,
			pt_stype(node.type)))
		return(498)
	}
	type = `SUBEXPR_PARAM'
	valdef = m_data->param_default_value()
	val = .z	// not default missing value
	rc = 0
	if (node.narg) {
		opt = node.arg[1]	// options list or operator =
		if (opt.type == `OPTIONS') {
			opt = opt.arg[1]
			if (opt.symb != "matrix") {
				/* programmer error			*/
				m_data->set_errmsg(sprintf("invalid free " +
					"parameter {bf:%s}: option {bf:%s} " +
					"not allowed",node.symb,opt.symb))
				return(498)
			}
			type = `SUBEXPR_MATRIX'
		}
		else if (opt.type == `OPERATOR') {
			opt = opt.arg[1]
			if (opt.type == `CONSTANT') {
				val = opt.val
			}
			else if (opt.type == `SYMBOL') { // scalar
				val = st_numscalar(opt.symb)
			}
			else {
				rc = 498
			}
		}
		else {
			rc = 498
		}
		if (rc) {
			/* programmer error				*/
			m_data->set_errmsg(sprintf("invalid free parameter " +
				"{bf:%s}: expected options or initial value " +
				"but got %s",node.symb,pt_stype(opt.type)))
			return(rc)
		}
	}
	if (!ustrlen(group)) {
		group = `SUBEXPR_PARAM_GROUP'
	}
	if (rc=m_data->register_component(node.symb,group,type,pC)) {
		return(rc)
	}
	rc = set_component(pC)
	if (!rc) {
		if (type == `SUBEXPR_PARAM') {
			if (val != .z) {
				rc = pC->update(val,`SUBEXPR_HINT_VALUE')
			}
			else {
				val0 = pC->data(`SUBEXPR_HINT_VALUE')
				if (val0 == .z) {	// not set yet
					rc = pC->update(valdef,
						`SUBEXPR_HINT_VALUE')
				}
			}
		}
		else { // type == `SUBEXPR_MATRIX'
			tname = m_data->new_tempname(tn.MATRIX)
			(void)pC->update(tname,`SUBEXPR_HINT_TNAME')
		}
	}
	pC = NULL
	return(rc)
}

real scalar __sub_expr_elem::traverse_LV(struct nlparse_node scalar node,
			|real scalar existed)
{
	real scalar rc, i, k, pathvars, atval, valdef
	real scalar ipath, iatop, parexisted
	string scalar spath, msg, eq, lv
	string vector vlist
	pointer (class __lvpath) scalar path, path1
	pointer (class __component_base) scalar pC, pCv
	pointer (class __sub_expr_elem) scalar pE
	struct nlparse_node atop

	pragma unset pCv
	pragma unset existed
	pragma unset parexisted

	existed = `SUBEXPR_FALSE'
	rc = 0
// pt_display(node)
	if (node.type != `LATENTVAR') {
		/* programmer error					*/
		m_data->set_errmsg(sprintf("invalid object {bf:%s}: " +
			"expected a %s, but got a %s",node.symb,
			m_data->LATENT_VARIABLE,pt_stype(node.type)))
		return(498)
	}
	ipath = iatop = 0
	if (node.narg) {
		if (node.arg[1].type==`SYMBOL' | node.arg[1].type==`PATHOP') {
			/* always first					*/
			ipath = 1
		}
		else if (node.arg[1].type == `ATOP') {
			iatop = 1
		}
		if (node.narg >= 2) {
			if (node.arg[2].type == `ATOP') {
				iatop = 2
			}
		}
	}
	pathvars = `SUBEXPR_FALSE'
	path = NULL
	spath = ""
	if (ipath) {
		path = &__lvpath(1)
		if (rc=path->init(node.symb,"",node)) {
			m_data->set_errmsg(path->errmsg())
			path = NULL
			return(rc)
		}
		spath = sprintf("[%s]",path->path())
	}
	if (!__sub_expr_isLVsymbol(node.symb)) {
		if (strlen(spath)) {
			msg = sprintf("%s%s",node.symb,spath)
		}
		else {
			msg = node.symb
		}
		m_data->set_errmsg(sprintf("invalid %s specification " +
			"{bf:%s}: first character of a %s name must be " +
			"capitalized",m_data->LATENT_VARIABLE,msg,
			m_data->LATENT_VARIABLE))
		return(198)
	}
	lv = node.symb
	if (ustrlen(spath)) {
		lv = lv + spath
	}
	valdef = `SUBEXPR_TRUE'
	atval = .
	if (iatop) {
		atop = node.arg[iatop]
		if (m_data->application() == m_data->SPECIAL_APP_MENL) {
			m_data->set_errmsg(sprintf("invalid %s specification " +
				"{bf:{%s}}: operator {bf:%s} not allowed",
				m_data->LATENT_VARIABLE,lv,atop.symb))
			return(198)
		}
		if (rc=traverse_atop_node(lv,atop,atval)) {
			return(rc)
		}
		valdef = missing(atval)
	}
	pC = m_data->lookup_component((`SUBEXPR_LV_GROUP',node.symb))
	if (pC == NULL) {
		if (rc=m_data->register_component(node.symb,`SUBEXPR_LV_GROUP',
			`SUBEXPR_LV',pC)) {
			return(rc)
		}
		if (path != NULL) {
			if (rc=pC->update(path,`SUBEXPR_HINT_PATH_TREE')) {
				m_data->set_errmsg(pC->errmsg())
				path = NULL
				return(rc)
			}
			pathvars = `SUBEXPR_TRUE'
		}
	}
	else {
		existed = `SUBEXPR_TRUE'
		path1 = pC->data(`SUBEXPR_HINT_PATH_TREE')
		if (path!=NULL & path1!=NULL) {
			if (!path->isequal(*path1)) {
				m_data->set_errmsg(sprintf("%s {bf:%s} has " +
					"two different paths {bf:%s} and " +
					"{bf:%s}; this is not allowed",
					m_data->LATENT_VARIABLE,path->name(),
					path->path(),path1->path()))
				path = NULL
				path1 = NULL
				pC = NULL
				return(498)
			}
		}
		else if (path != NULL) {
			if (rc=pC->update(path,`SUBEXPR_HINT_PATH_TREE')) {
				m_data->set_errmsg(pC->errmsg())
			}
			pathvars = `SUBEXPR_TRUE'
		}
		path1 = NULL
	}
	if (pathvars) {
		/* add path variable components	to container		*/
		vlist = tokens(path->varlist())
		k = length(vlist)
		for (i=1; i<=k; i++) {
			if (length(path->m_hsyms)) {
				if (any(vlist[i]:==path->m_hsyms)) {
					continue
				}
			}
			if (rc=m_data->register_component(vlist[i],
				`SUBEXPR_VAR_GROUP',`SUBEXPR_VARIABLE',pCv)) {
				pC = NULL
				path = NULL
				return(rc)
			}
			(void)pCv->update(this,`SUBEXPR_HINT_DATAOBJ')
		}
		pCv = NULL
	}
	path = NULL
	if (rc=set_component(pC)) {
		return(rc)
	}
	pE = NULL
	/* only one equation in MENL: LV[path]@# not allowed		*/
	if (m_data->application() == m_data->SPECIAL_APP_MENL) {
		pC = NULL
		return(rc)
	}
	if (valdef) {
		atval = m_data->param_default_value()
	}
	/* set up scaling parameter					*/
	if (m_group != NULL) {
		pE = m_group->data(`SUBEXPR_HINT_EQUATION_OBJ')
		if (pE == NULL) {
			/* will set equation name when we resolve
			 *  expressions					*/
			pE = m_group
		}
	}
	if (pE == NULL) {
		/* programmer error, need to set the group object
		 *  before calling traverse_LV()			*/
		m_data->set_errmsg(sprintf("cannot construct the scaling " +
			"parameter for %s {bf:%s}",m_data->LATENT_VARIABLE,
			node.symb))
		pC = NULL
		return(499)
	}
	eq = pE->name()
	if (rc=m_data->register_component(node.symb,eq,`SUBEXPR_LV_PARAM',pCv,
		parexisted)) {
		return(rc)
	}
	if (!parexisted) {
		(void)pCv->update(atval,`SUBEXPR_HINT_VALUE')
		(void)pC->update(pCv,`SUBEXPR_HINT_PARAM')
	}
	else if (!valdef) {
		(void)pCv->update(atval,`SUBEXPR_HINT_VALUE')
	}
	if (!valdef) {
		/* parameter fixed @#					*/
		(void)pCv->update(`SUBEXPR_TRUE',`SUBEXPR_HINT_FIXED_PARAM')
	}
	pCv = NULL
	pC = NULL
	return(rc)
}

real scalar __sub_expr_elem::traverse_atop_node(string scalar parent,
			struct nlparse_node scalar atop, real scalar atval)
{
	string scalar at, msg

	atval = .
	if (!atop.narg) {
		return(0)
	}
	if (atop.arg[1].type == `SYMBOL') {
		atval = strtoreal(atop.arg[1].symb)
		at = sprintf("%s",atop.arg[1].symb)
		msg = sprintf("scalar {bf:%s} not found",atop.arg[1].symb)
	}
	else if (atop.arg[1].type == `CONSTANT') {
		atval = atop.arg[1].val
		at = "{it:#}"
		msg = "missing constant {it:#}"
	}
	else {
		at = "{it:#}"
		msg = "missing constant {it:#}"
	}
	if (missing(atval)) {
		/* should not happen					*/
		m_data->set_errmsg(sprintf("invalid @ specification " +
			"{bf:{%s@%s}}: %s", parent,at,msg))

		return(498)
	}
	return(0)
}

string scalar __sub_expr_elem::name()
{
	if (m_comp == NULL) {
		return("")
	}
	return(m_comp->name())
}

string scalar __sub_expr_elem::expression()
{
	return("")
}

string scalar __sub_expr_elem::tempname()
{
	real scalar tname
	if (m_comp == NULL) {
		return("")
	}
	tname = `SUBEXPR_TRUE'

	return(m_comp->name(tname))
}

string scalar __sub_expr_elem::group()
{
	if (m_comp == NULL) {
		return("")
	}
	if (m_comp->type() == `SUBEXPR_LV') {
		/* latent variable components do not belong to any
		 *  specific LC or parameter group; return the name
		 *  of the __sub_expr_group containing this		*/
		return(m_group->name())
	}
	return(m_comp->group())
}

real scalar __sub_expr_elem::group_type()
{
	if (m_group == NULL) {
		return(`SUBEXPR_UNDEFINED')
	}
	return(m_group->group_type())
}

void __sub_expr_elem::classname()
{
	::classname(this)
}

string scalar __sub_expr_elem::subexpr(|transmorphic extra)
{
	if (m_comp == NULL) {
		return("")
	}
	if (args()) {
		return(m_comp->subexpr(extra))
	}
	return(m_comp->subexpr())
}

real scalar __sub_expr_elem::estate()
{
	real scalar es
	pointer (struct __component_state) scalar state

	if (m_comp == NULL) {
		/* string expression					*/
		return(`SUBEXPR_EVAL_CLEAN')
	}
	state = m_comp->state()
	es = state->estate
	state = NULL

	return(es)
}

real scalar __sub_expr_elem::lhstype()
{
	real scalar type, lhstype
	pointer (struct __component_state) scalar state

	if (m_comp == NULL) {
		`SUBEXPR_EVAL_NULL'
	}
	state = m_comp->state()
	/* elements of the coefficient vector are ready			*/
	lhstype = state->lhstype
	if (lhstype != `SUBEXPR_EVAL_NULL') {
		/* been here, done that					*/
		state = NULL
		return(lhstype)
	}
	lhstype = `SUBEXPR_EVAL_NULL'

	if ((type=type()) == `SUBEXPR_VARIABLE') { 
		lhstype = `SUBEXPR_EVAL_VECTOR'
	}
	else if (type == `SUBEXPR_LV') {
		lhstype = `SUBEXPR_EVAL_VECTOR'
	}
	else if (type == `SUBEXPR_LC_PARAM' |
		 type == `SUBEXPR_FV_PARAM') {
		lhstype = `SUBEXPR_EVAL_VECTOR'
	}
	else if (type == `SUBEXPR_PARAM') {
		lhstype = `SUBEXPR_EVAL_SCALAR'
	}
	else if (type == `SUBEXPR_MATRIX') {
		/* assume matrix = fun(matrix)				*/
		lhstype = `SUBEXPR_EVAL_MATRIX'
	}
	state->lhstype = lhstype
	state = NULL

	return(lhstype)
}

real scalar __sub_expr_elem::type()
{
	if (m_comp == NULL) {
		return(`SUBEXPR_EXPRESSION')
	}
	return(m_comp->type())
}

string scalar __sub_expr_elem::stype()
{
	if (m_comp == NULL) {
		return(`SUBEXPR_STR_EXPRESSION')
	}
	return(m_comp->stype())
}

void __sub_expr_elem::set_dataobj(pointer (class __sub_expr) scalar data)
{
	m_data = data
}

void __sub_expr_elem::set_info(real scalar info)
{
	m_info = info
}

real scalar __sub_expr_elem::info()
{
	return(m_info)
}

void __sub_expr_elem::set_groupobj(pointer (class __sub_expr_group) scalar pG)
{
	m_group = pG
}

pointer (class __sub_expr_elem) scalar __sub_expr_elem::groupobj()
{
	return(m_group)
}

void __sub_expr_elem::set_next(pointer(class __sub_expr_elem) scalar pE)
{
	if (0 & m_next != NULL) {	// debug
		if (pE == NULL) {
			errprintf("erasing next pointer: replacing %s (%s)\n",
				m_next->name(),m_next->stype())
		}
		else if (m_next != pE) {
			errprintf("replacing next pointer: replacing %s (%s) "+
				"with %s (%s)\n",m_next->name(),m_next->stype(),
				pE->name(),pE->stype())
		}
		displayas("text")
	}
	m_next = pE
}

void __sub_expr_elem::set_prev(pointer(class __sub_expr_elem) scalar pE)
{
	if (0 & m_prev != NULL) {	// debug
		if (pE == NULL) {
			errprintf("erasing prev pointer: replacing %s (%s)\n",
				m_prev->name(),m_prev->stype())
		}
		else if (m_prev != pE) {
			errprintf("replacing prev pointer: replacing %s (%s) "+
				"with %s (%s)\n",m_prev->name(),m_prev->stype(),
				pE->name(),pE->stype())
		}
		displayas("text")
	}
	m_prev = pE
}

pointer (class __sub_expr_elem) scalar __sub_expr_elem::next()
{
	return(m_next)
}

pointer (class __sub_expr_elem) scalar __sub_expr_elem::prev()
{
	return(m_prev)
}

real scalar __sub_expr_elem::set_component(
			pointer (class __component_base) scalar pC)
{
	real scalar rc, ref

	rc = 0
	if (m_comp!=NULL & m_comp!=pC) {
		/* decrement reference count				*/
		if (rc=m_comp->update(&this,`SUBEXPR_HINT_REMOVEOBJ')) {
			return(rc)
		}
		ref = m_comp->refcount()
		if (ref <= 0) {
			(void)m_data->remove_component(m_comp)
		}
		if (pC == NULL) {
			m_comp = NULL
			return(rc)
		}
	}
	m_comp = pC
	if (m_comp != NULL) {
		/* increment reference count				*/
		rc = m_comp->update(&this,`SUBEXPR_HINT_DATAOBJ')
		if (m_comp->type() == `SUBEXPR_PARAM') {
			/* SUBEXPR_PARAM flag allows access to a LC param
			 *  but ignores the associated variable		*/
			m_info = m_comp->data(`SUBEXPR_HINT_PARAMTYPE')
		}
	}
	return(rc)
}

pointer (class __component_base) scalar __sub_expr_elem::component()
{
	return(m_comp)
}

void __sub_expr_elem::set_options(string vector options)
{
	m_options = options
}

string vector __sub_expr_elem::options()
{
	return(m_options)
}

real vector __sub_expr_elem::test_option(string scalar opt, |real scalar k)
{
	real scalar m

	m = has_options()
	if (!ustrlen(opt) | !m) {
		return(0)
	}
	return(__sub_expr_test_option(m_options,opt,k))
}

real scalar __sub_expr_elem::has_option(string scalar opt, |real scalar k)
{
	return(any(test_option(opt,k)))
}

real scalar __sub_expr_elem::has_options()
{
	return(length(m_options))
}

pointer (class __sub_expr_elem) scalar __sub_expr_elem::clone(
			|pointer (class __sub_expr_elem) scalar pE)
{
	pointer (class __component_base) scalar pC

	/* copy component and data pointers				*/
	if (pE == NULL) {
		/* at this level pE == NULL always			*/
		pE = &J(1,1,this)
		if ((pC=pE->component()) != NULL) {
			(void)pC->update(pE,`SUBEXPR_HINT_DATAOBJ')
		}
		pC = NULL
	}
	/* calling function will add pE to a linked list		*/
	pE->set_next(NULL)
	pE->set_prev(NULL)
	pE->set_options(options())

	return(pE)
}

string scalar __sub_expr_elem::traverse_expr(real scalar which)
{
	real scalar type, brace, gtype
	string scalar expr

	expr = ""
	if (m_comp == NULL) {
		return(expr)
	}
	brace = `SUBEXPR_FALSE'
	if (which != `SUBEXPR_SUBSTITUTED') {
		type = type()
		if (type==`SUBEXPR_PARAM' | type==`SUBEXPR_LV') {
			gtype = group_type()
			brace = (gtype==`SUBEXPR_GROUP_EXPRESSION' |
				gtype==`SUBEXPR_EQ_EXPRESSION')

			if (brace) {
				expr = "{"
			}
		}
	}
	expr = expr + m_comp->expression(which)
	if (brace) {
		expr = expr + "}"
	}

	return(expr)
}

real scalar __sub_expr_elem::_evaluate(string scalar expr, |transmorphic extra)
{
	real scalar nostripe, rc
	class __stmatrix scalar m
	pointer (struct __component_state) scalar state

	if (args() > 1) {
		expr = subexpr(extra)
	}
	else {
		expr = subexpr()
	}
	if (type() != `SUBEXPR_MATRIX') { 
		return(0)
	}
	state = m_comp->state()
	if (state->estate == `SUBEXPR_EVAL_DIRTY') {
		nostripe = `SUBEXPR_TRUE'
		if (group() == `SUBEXPR_MAT_GROUP') {
			/* Stata matrix in an expression, not
			 * substitutable				*/
			if (rc=m.st_getmatrix(name())) {
				m_data->set_errmsg("matrix {bf:%s} does " +
					"not exist",name())
				state = NULL
				return(rc)
			}
			(void)m_comp->update(m,`SUBEXPR_HINT_STMATRIX')
		}
		else {
			/* substitutable matrix, update Stata matrix	*/
			m = m_comp->data(`SUBEXPR_HINT_STMATRIX')
		}
		m.st_matrix(tempname(),nostripe)
		state->estate =`SUBEXPR_EVAL_CLEAN'
		if (m_data->trace()) {
			printf("%s: {bf:::st_matrix(%s)}\n",name(),subexpr())
		}
	}
	state = NULL

	return(0)
}

pointer (class __component_base) scalar __sub_expr_cov::lookup_component(
			string vector key)
{
	return(super.lookup_component(key))
}

end
exit
