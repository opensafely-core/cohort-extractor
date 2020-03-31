*! version 1.1.8  04sep2019

findfile __stmatrix.matah
quietly include `"`r(fn)'"'

findfile __lvhierarchy.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_object.matah
quietly include `"`r(fn)'"'

findfile __component.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_object.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

/* base virtual class for all substitutable expression components	*/
void __component_base::new()
{
	m_errmsg = ""
	m_ref = 0
	m_state.estate = `SUBEXPR_EVAL_DIRTY'
	m_state.lhstype = `SUBEXPR_EVAL_NULL'
	m_state.subexpr = ""
	m_state.tname = ""
	m_state.touse = ""
	m_state.touse_init = ""
	m_state.markout = `SUBEXPR_FALSE'
	m_state.markout_init = `SUBEXPR_FALSE'
}

void __component_base::destroy()
{
	/* debug */
//	errprintf("destroying __component_base %s\n",name())
//	displayas("txt")
}

void __component_base::set_name(string scalar name)
{
	m_name = name
}

string vector __component_base::key()
{
	return((m_group,m_name))
}

real scalar __component_base::refcount()
{
	return(m_ref)
}

void __component_base::set_group(string scalar group)
{
	m_group = group
}

string scalar __component_base::name(|real scalar tname)
{
	tname = (missing(tname)?0:(tname!=0))
	if (tname) {
		return(m_state.tname)
	}
	return(m_name)
}

string scalar __component_base::group()
{
	return(m_group)
}

string scalar __component_base::subexpr(|transmorphic extra)
{
	pragma unused extra

	return(m_state.subexpr)
}

pointer (struct __component_state) scalar __component_base::state()
{
	return(&m_state)
}

real scalar __component_base::type()
{
	return(`SUBEXPR_UNDEFINED')
}

string scalar __component_base::stype()
{
	return(`SUBEXPR_STR_UNDEFINED')
}

real scalar __component_base::isequal(
		pointer (class __component_base) scalar pC)
{
	pointer (class __component_base) scalar pC0

	/* check for equivalent objects 				*/
	pC0 = &this
	if (pC == pC0) {
		pC0 = NULL
		return(`SUBEXPR_TRUE')
	}
	if (pC == NULL) {
		/* should not happen					*/
		return(`SUBEXPR_FALSE')
	}
	pC0 = NULL
	if (pC->type()==type() & pC->name()==name() & pC->group()==group()) {
		return(`SUBEXPR_TRUE')
	}
	return(`SUBEXPR_FALSE')
}

real scalar __component_base::update(transmorphic data, real scalar hint)
{
	real scalar ivar

	if (hint == `SUBEXPR_HINT_REMOVEOBJ') {
		m_ref--
		// printf("%s decrement ref = %g\n",m_name,m_ref)
		if (m_ref<0 & 0) {	// debug
			/* programmer error				*/
			errprintf("reference counter for object %s (%s) " +
				"is less than zero\n",name(),stype())
			displayas("txt")
			m_ref = 0
		}
		if (!m_ref) {
			if (strlen(m_state.tname)) {
				ivar = _st_varindex(m_state.tname)
				if (!missing(ivar)) {
					st_dropvar(ivar)
				}
			}
		}
	}
	else if (hint == `SUBEXPR_HINT_DATAOBJ') {
		if (data != NULL) {
			m_ref++
		}
		// printf("%s increment ref = %g\n",m_name,m_ref)
	}
	else if (hint == `SUBEXPR_HINT_MARK_DIRTY') {
		m_state.estate = `SUBEXPR_EVAL_DIRTY'
	}
	return(0)
}

transmorphic __component_base::data(real scalar hint, |transmorphic extra)
{
	pragma unused extra

	if (hint == `SUBEXPR_HINT_REFCOUNT') {
		return(m_ref)
	}
	return(NULL)
}

real scalar __component_base::validate()
{
	if (!st_isname(m_name)) {
		m_errmsg = sprintf("symbol {bf:%s} is not a valid Stata name",
			m_name)
		return(198)
	}
	return(0)
}

string scalar __component_base::errmsg()
{
	return(m_errmsg)
}

void __component_base::display(|real scalar lev)
{
	real scalar ind
	string scalar subexpr

	subexpr = subexpr()
	printf("{txt}:{res}%s\n",name())
	if (ustrlen(subexpr)) {
		ind = 4*(missing(lev)?1:lev)+1
		printf("{col %g}{txt}sub expr: {res}%s\n",ind,subexpr)
	}
}

string scalar __component_base::expression(|real scalar which)
{
	pragma unused which

	return("")
}


/* variable component class						*/
void __component_var::new()
{
	m_operator = ""
}

void __component_var::destroy()
{
	m_operator = ""
}

void __component_var::set_name(string scalar name)
{
	m_name = m_state.subexpr = name
}

void __component_var::set_group(string scalar group)
{
	if (!ustrlen(group)) {
		return
	}
	super.set_group(group)
}

real scalar __component_var::type()
{
	return(`SUBEXPR_VARIABLE')
}

string scalar __component_var::stype()
{
	return(`SUBEXPR_STR_VARIABLE')
}

real scalar __component_var::isequal(
		pointer (class __component_base) scalar pC)
{
	return(super.isequal(pC))
}

void __component_var::set_operator(string scalar op)
{
	m_operator = op
	if (strlen(m_operator)) {
		m_state.subexpr = m_operator + m_name
	}
	else {
		m_state.subexpr = m_name
	}
}

string scalar __component_var::_operator()
{
	return(m_operator)
}

real scalar __component_var::update(transmorphic data, |real scalar hint)
{
	if (hint == `SUBEXPR_HINT_OPERATOR') {
		set_operator(data)
		return(0)
	}
	return(super.update(data,hint))
}

transmorphic __component_var::data(real scalar hint, |transmorphic extra)
{
	pragma unused extra

	if (hint == `SUBEXPR_HINT_OPERATOR') {
		return(_operator())
	}
	return(super.data(hint))
}

real scalar __component_var::validate()
{
	real scalar ivar, rc

	if (rc=super.validate()) {
		return(rc)
	}

	ivar = st_varindex(m_name)
	if (missing(ivar)) {
		m_errmsg = sprintf("variable {bf:%s} does not exist",m_name)
		return(111)
	}
	return(0)
}

void __component_var::display(|real scalar lev)
{
	real scalar ind

	ind = 4*(missing(lev)?0:lev-1)+1

	printf("{col %g}{txt}variable ", ind)
	if (!strlen(m_operator)) {
		super.display(lev)
	}
	else {
		printf("{txt}:{res}%s%s\n",m_operator,name())
	}
}

string scalar __component_var::subexpr(|transmorphic extra)
{
	if (args()) {
		return(super.subexpr(extra))
	}
	return(super.subexpr())
}

string scalar __component_var::expression(|real scalar which)
{
	real scalar tname
	string scalar expr

	if (which == `SUBEXPR_SUBSTITUTED') {
		expr = subexpr()
		if (!ustrlen(expr)) {
			tname = `SUBEXPR_TRUE'
			if (strlen(m_operator)) {
				expr = m_operator + name(tname)
			}
			else {
				expr = name(tname)
			}
		}
		return(expr)
	}
	if (strlen(m_operator)) {
		expr = m_operator+name()
		return(expr)
	}
	return(name())
}

/* latent variable component class					*/
void __component_lv::new()
{
	m_path = NULL
	m_param = J(1,0,NULL)
}

void __component_lv::destroy()
{
	real scalar ivar

	m_path = NULL	// release reference
	m_covariate = ""

	if (strlen(m_state.tname)) {
		ivar = _st_varindex(m_state.tname)
		if (!missing(ivar)) {
			st_dropvar(ivar)
		}
	}
	remove_param(NULL)
}

void __component_lv::set_name(string scalar name)
{
	super.set_name(name)
}

void __component_lv::set_group(string scalar group)
{
	super.set_group(group)
}

real scalar __component_lv::type()
{
	return(`SUBEXPR_LV')
}

string scalar __component_lv::stype()
{
	return(`SUBEXPR_STR_LV')
}

pointer (class __lvpath) scalar __component_lv::path_tree()
{
	/* return pointer to this tree					*/
	return(m_path)
}

void __component_lv::set_path_tree(pointer (class __lvpath) scalar path)
{
	/* share LV tree with another component				*/
	m_path = path
}

void __component_lv::add_param(pointer (class __component_param) scalar param)
{
	real scalar k, i, found
	string scalar eq, eqi

	if (param == NULL) {
		return
	}
	if (param->type() != `SUBEXPR_LV_PARAM') {
		return
	}
	k = length(m_param)
	found = `SUBEXPR_FALSE'
	eq = param->group()	// group name is an equation name
	for (i=1; i<=k; i++) {
		eqi = m_param[i]->group()
		if (eqi == eq) {
			found = `SUBEXPR_TRUE'
			break
		}
	}
	if (!found) {
		m_param = (m_param,param)
		/* increment ref count on param				*/
		(void)param->update(&this,`SUBEXPR_HINT_DATAOBJ')
	}
}

void __component_lv::remove_param(
			pointer (class __component_param) scalar param)
{
	real scalar k, i, j

	if (param != NULL) {
		if (param->type() != `SUBEXPR_LV_PARAM') {
			return
		}
	}
	k = length(m_param)
	for (i=1; i<=k; i++) {
		if (param==NULL | m_param[i]==param) {
			/* decrement __component ref count		*/
			(void)m_param[i]->update(NULL,`SUBEXPR_HINT_REMOVEOBJ')
 			/* decrement Mata ref count			*/
			m_param[i] = NULL
			if (param != NULL) {
				j = i
				break
			}
		}
	}
	if (param==NULL | k==1) {
		m_param = J(1,0,NULL)
	}
	else {
		for (i=j; i<k; i++) {
			m_param[i] = m_param[i+1]
		}
		m_param = m_param[|1\--k|]
	}
}

pointer (class __component_param) scalar __component_lv::param(string scalar eq)
{
	real scalar i, k
	string scalar eqi

	k = length(m_param)
	for (i=1; i<=k; i++) {
		eqi = m_param[i]->group()
		if (eqi == eq) {
			return(m_param[i])
		}
	}
	return(NULL)
}

pointer (class __component_param) vector __component_lv::param_vec()
{
	return(m_param)
}

real scalar __component_lv::param_index(string scalar eq)
{
	pointer (class __component_param) scalar par

	par = param(eq)
	if (par == NULL) {
		return(.)
	}
	return(par->param_index())
}

real scalar __component_lv::isequal(
			pointer (struct __component_base) scalar pC)
{
	real scalar iseq
	string scalar covariate
	pointer (class __component_lv) scalar pLV
	pointer (class __lvpath) scalar path

	iseq = `SUBEXPR_FALSE'
	if (!super.isequal(pC)) {
		return(iseq)
	}
	if (m_path == NULL) {
		return(iseq)
	}
	pLV = pC
	path = pLV->path_tree()
	if (path == NULL) {
		pLV = NULL
		return(iseq)
	}
	if (!m_path->isequal(*path)) {
		pLV = NULL
		return(iseq)
	}
	covariate = pLV->covariate()
	iseq = (m_covariate==covariate)
	pLV = NULL

	return(iseq)
}

real scalar __component_lv::update(transmorphic data, |real scalar hint)
{
	if (hint == `SUBEXPR_HINT_PATH') {
		m_state.lhstype = `SUBEXPR_EVAL_VECTOR'
		return(parse_path(data))
	}
	if (hint == `SUBEXPR_HINT_COVARIATE') {
		set_covariate(data)
		return(0)
	}
	if (hint == `SUBEXPR_HINT_SUBEXPR') {
		/* matel() expression					*/
		m_state.subexpr = data
		return(0)
	}
	if (hint == `SUBEXPR_HINT_TNAME') {
		/* level id variable tempname 				*/
		m_state.tname = data
		return(0);
	}
	if (hint == `SUBEXPR_HINT_PATH_TREE') {
		set_path_tree(data)
		return(0)
	}
	if (hint == `SUBEXPR_HINT_PARAM') {
		add_param(data)
		return(0)
	}
	if (hint == `SUBEXPR_HINT_PARAM_CLEAR') {
		remove_param(NULL)
		return(0)
	}
	if (hint == `SUBEXPR_HINT_REMOVE_PARAM') {
		remove_param(data)
		return(0)
	}
	return(super.update(data,hint))
}

transmorphic __component_lv::data(real scalar hint, |transmorphic extra)
{
	string scalar expr

	if (hint == `SUBEXPR_HINT_VARLIST') {
		return(varlist())
	}
	if (hint == `SUBEXPR_HINT_PATH') {
		return(path())
	}
	if (hint == `SUBEXPR_HINT_COVARIATE') {
		return(m_covariate)
	}
	if (hint == `SUBEXPR_HINT_HIERARCHY') {
		return(hierarchy())
	}
	if (hint == `SUBEXPR_HINT_SUBEXPR') {
		/* matael() expression					*/
		if (args() > 1) {
			/* 'extra' is the name of the scale param	*/
			expr = subexpr(extra)
		}
		else {
			expr = subexpr()
		}
		return(expr)
	}
	if (hint == `SUBEXPR_HINT_PATH_TREE') {
		return(path_tree())
	}
	if (hint == `SUBEXPR_HINT_PARAM') {
		/* 'extra' == equation name				*/
		return(param(extra))
	}
	if (hint == `SUBEXPR_HINT_PARAM_VEC') {
		return(param_vec())
	}
	if (hint == `SUBEXPR_HINT_COEF_INDEX') {
		/* extra == equation name				*/
		return(param_index(extra))
	}
	return(super.data(hint))
}

void __component_lv::set_covariate(string scalar covariate)
{
	m_covariate = covariate
}

string scalar __component_lv::covariate()
{
	return(m_covariate)
}

real scalar __component_lv::parse_path(string scalar path)
{
	real scalar rc

	m_path = &__lvpath(1)
	if (rc=m_path->init(name(),path)) {
		m_errmsg = sprintf("invalid path {bf:%s:%s}: %s",name(),
			path,m_path->errmsg())
	}
	return(rc)
}

string scalar __component_lv::path()
{
	if (m_path == NULL) {
		return("")
	}
	return(m_path->path())
}

string scalar __component_lv::varlist()
{
	if (m_path == NULL) {
		return("")
	}
	return(m_path->varlist())
}

string vector __component_lv::hierarchy()
{
	if (m_path == NULL) {
		return(J(1,0,""))
	}
	return(m_path->hierarchy())
}

real scalar __component_lv::validate()
{
	return(super.validate())
}

void __component_lv::display(|real scalar lev)
{
	real scalar ind
	string scalar path

	ind = 4*(missing(lev)?0:lev-1)+1

	printf("{txt}{col %g}latent variable ",ind)
	super.display(lev)
	path = path()
	if (!ustrlen(path)) {
		return
	}
	ind = ind + 4
	printf("{txt}{col %g}path: {res}%s\n",ind,path)
	if (ustrlen(m_covariate)) {
		printf("{txt}{col %g}covariate: {res}%s\n",ind,m_covariate)
	}
}

string scalar __component_lv::subexpr(|transmorphic extra)
{
	string scalar subexpr
	pointer (class __component_param) scalar par

	subexpr = super.subexpr()

	if (args()) {
		par = param(extra)
		if (par != NULL) {
			subexpr = sprintf("%s*%s",par->subexpr(),subexpr)
		}
	}
	return(subexpr)	
}

string scalar __component_lv::expression(|real scalar which, transmorphic extra)
{
	string scalar expr, xvar
	pointer (class __component_param) scalar par

	if (which == `SUBEXPR_SUBSTITUTED') {
		if (args() > 1) {
			expr = subexpr(extra)
		}
		else {
			expr = subexpr()
		}
	}
	else {
		expr = sprintf("%s[%s]",name(),path())
		if (args() > 1) {
			par = param(extra)
			if (par != NULL) {
				expr = par->expression()+"*"+expr
			}
		}
		if (ustrlen(m_covariate)) {
			xvar = m_covariate
			if (ustrpos(xvar,".")) {
				/* operator exists			*/
				expr = xvar + "#" + expr
			}
			else {
				/* assume continuous			*/
				expr = "c." + xvar + "#" + expr
			}
		}
	}
	return(expr)
}


/* parameter component class						*/
void __component_param::new()
{
	m_param_type = `SUBEXPR_PARAM'
	m_state.lhstype = `SUBEXPR_EVAL_SCALAR'
	m_value = .z	// not default missing value
	m_iparam = 0	// invalid index
	m_fixed = `SUBEXPR_FALSE'	// not fixed
	clear_factors()
}

void __component_param::destroy()
{
	m_fvex = NULL	// decrement reference count
}

void __component_param::set_name(string scalar name)
{
	m_name = name
}

void __component_param::set_group(string scalar group)
{
	super.set_group(group)
}

real scalar __component_param::type()
{
	/* SUBEXPR_PARAM or SUBEXPR_LP_PARAM				*/
	return(m_param_type)
}

string scalar __component_param::stype()
{
	if (m_param_type == `SUBEXPR_PARAM') {
		return(`SUBEXPR_STR_PARAM')
	}
	else if (m_param_type == `SUBEXPR_LC_PARAM') {
		return(`SUBEXPR_STR_LC_PARAM')
	}
	else if (m_param_type == `SUBEXPR_FV') {
		return(`SUBEXPR_STR_FV')
	}
	else if (m_param_type == `SUBEXPR_FV_PARAM') {
		return(`SUBEXPR_STR_FV_PARAM')
	}
	else if (m_param_type == `SUBEXPR_LV_PARAM') {
		return(`SUBEXPR_STR_LV_PARAM')
	}
	/* should not happen						*/
	return(".")
}

real scalar __component_param::isequal(
		pointer (class __component_base) scalar pC)
{
	real scalar i, j, k
	pointer (class __component_param) vector fvex
	pointer (class __component_param) scalar pP

	if (pC->type() != m_param_type) {
		return(`SUBEXPR_FALSE')
	}
	if (m_param_type == `SUBEXPR_FV') {
		k = pC->data(`SUBEXPR_HINT_COUNT')
		if (fv_count() != k) {
			return(`SUBEXPR_FALSE')
		}
		fvex = pC->data(`SUBEXPR_HINT_FV_VECTOR')
		for (i=1; i<=k; i++) {
			pP = factor_var(i)
			if (!(pP->isequal(fvex[i]))) {
				for (j=i; j<=k; j++) {
					fvex[j] = NULL
				}
				return(`SUBEXPR_FALSE')
			}
			pP = fvex[i] = NULL
		}
	}
	return(super.isequal(pC))
}

real scalar __component_param::param_index()
{
	return(m_iparam)
}

real scalar __component_param::value()
{
	/* value set using @# (fixed), or =# (initial)			*/
	return(m_value)
}

void __component_param::set_value(real scalar value)
{
	m_value = value
}

real scalar __component_param::is_fixed()
{
	/* flag: TRUE if m_value set using @#				*/
	return(m_fixed)
}

void __component_param::set_fixed(real scalar fixed)
{
	m_fixed = (fixed==`SUBEXPR_FALSE'?fixed:(fixed!=`SUBEXPR_FALSE'))
}

real scalar __component_param::update(transmorphic data, |real scalar hint)
{
	if (hint == `SUBEXPR_HINT_VALUE') {
		set_value(data)
		return(0)
	}
	if (hint == `SUBEXPR_HINT_FIXED_PARAM') {
		set_fixed(data)
		return(0)
	}
	if (hint == `SUBEXPR_HINT_PARAMTYPE') {
		m_param_type = data
		if (m_param_type == `SUBEXPR_PARAM') {
			m_state.lhstype = `SUBEXPR_EVAL_SCALAR'
		}
		else if (m_param_type == `SUBEXPR_LC_PARAM' | 
			m_param_type ==`SUBEXPR_FV_PARAM' |
			m_param_type==`SUBEXPR_LV_PARAM') {
			m_state.lhstype = `SUBEXPR_EVAL_VECTOR'
		}
		else if (m_param_type == `SUBEXPR_FV') {
			/* not an expanded FV				*/
			m_state.lhstype = `SUBEXPR_EVAL_NULL'
		}
		else {
			/* programmer error				*/
			m_errmsg = sprintf("invalid parameter type code %g; " +
				"only codes %g=%s and %g=%s are allowed",
				m_param_type,`SUBEXPR_PARAM',`SUBEXPR_STR_PARAM',
				`SUBEXPR_LC_PARAM',`SUBEXPR_STR_LC_PARAM')
			return(109)
		}
		return(0)
	}
	if (hint == `SUBEXPR_HINT_SUBEXPR') {
		m_state.subexpr = data
		return(0)
	}
	if (hint == `SUBEXPR_HINT_TNAME') {
		m_state.tname = data
		return(0)
	}
	if (hint == `SUBEXPR_HINT_COEF_INDEX') {
		m_iparam = data
		return(0)
	}
	if (hint == `SUBEXPR_HINT_FV') {
		if (m_param_type != `SUBEXPR_FV') {
			/* programmer error				*/
			m_errmsg = sprintf("attempting to add a factor " +
				"variable element into %s %s:%s",stype(),
				group(),name())
			return(498)
		}
		add_factor_var(data)
		return(0)
	}
	if (hint == `SUBEXPR_HINT_FV_CLEAR') {
		clear_factors()
	}
	return(super.update(data,hint))
}

transmorphic __component_param::data(real scalar hint, |transmorphic extra)
{
	real scalar i, k
	string vector names

	if (hint == `SUBEXPR_HINT_VALUE') {
		return(m_value)
	}
	if (hint == `SUBEXPR_HINT_FIXED_PARAM') {
		return(m_fixed)
	}
	if (hint == `SUBEXPR_HINT_PARAMTYPE') {
		return(m_param_type)
	}
	if (hint == `SUBEXPR_HINT_SUBEXPR') {
		return(m_state.subexpr)
	}
	if (hint == `SUBEXPR_HINT_COEF_INDEX') {
		return(param_index())
	}
	if (hint == `SUBEXPR_HINT_COUNT') {
		return(fv_count())
	}
	if (hint == `SUBEXPR_HINT_FV') {
		if (args()>1) {
			return(factor_vars(extra))
		}
		return(factor_vars())
	}
	if (hint == `SUBEXPR_HINT_FV_NAMES') {
		k = length(m_fvex)
		names = J(1,k,"")
		for (i=1; i<=k; i++) {
			names[i] = m_fvex[i]->name()
		}
		return(names)
	}
	return(super.data(hint))
}

real scalar __component_param::validate()
{
	real scalar val, rc

	if (rc=super.validate()) {
		return(rc)
	}
	val = st_numscalar(m_name)
	if (missing(val)) {
		m_errmsg = sprintf("scalar %s does not exist", m_name)
		return(111)
	}
	return(0)
}

void __component_param::display(|real scalar lev)
{
	real scalar ind

	ind = 4*(missing(lev)?0:lev-1)+1

	printf("{col %g}{txt}%s ",ind,stype())

	super.display(lev)
}

string scalar __component_param::subexpr(|transmorphic extra)
{
	if (args()) {
		return(super.subexpr(extra))
	}
	return(super.subexpr())
}

string scalar __component_param::expression(|real scalar which)
{
	real scalar i, k
	string scalar expr, expri, sp

	k = fv_count()
	if (which == `SUBEXPR_SUBSTITUTED') {
		if (m_param_type==`SUBEXPR_FV' & k) {
			expr = sp = ""
			for (i=1; i<=k; i++) {
				expri = m_fvex[i]->expression(which)
				expr = expr + sp + expri
				sp = " "
			}
		}
		else {
			expr = subexpr()
			if (!ustrpos(expr,"[")) {
				/* not a matrix element			*/
				expr = "scalar("+expr+")"
			}
		}
	}
	else if (which == `SUBEXPR_FULL') {
		if (m_param_type==`SUBEXPR_FV' & k) {
			expr = sp = ""
			for (i=1; i<=k; i++) {
				expri = m_fvex[i]->expression(which)
				expr = expr + sp + expri
				sp = " "
			}
		}
		else {
			expr = name()
		}
	}
	else {
		// expr = "{"+name()+"}"	// braces?
		expr = name()
	}
	return(expr)
}

void __component_param::clear_factors()
{
	real scalar i, k
	
	k = length(m_fvex)
	for (i=1; i<=k; i++) {
		(void)m_fvex[i]->update(&this,`SUBEXPR_HINT_REMOVEOBJ')
	}
	m_fvex = J(1,0,NULL)
}

void __component_param::add_factor_var(
			pointer (class __component_param) scalar pC)
{
	real scalar i, k
	string scalar name

	name = pC->name()
	if (k = length(m_fvex)) {
		for (i=1; i<=k; i++) {
			if (m_fvex[i]->name() == name) {
				return
			}
		}
	}
	(void)pC->update(&this,`SUBEXPR_HINT_DATAOBJ') // increment pC->m_ref
	m_fvex = (m_fvex,pC)
}

real scalar __component_param::fv_count()
{
	if (m_param_type != `SUBEXPR_FV') {
		return(0)
	}
	return(length(m_fvex))
}

pointer (class __component_param) vector __component_param::factor_vars(
				|real scalar k)
{
	real scalar kfv

	if (missing(k)) {
		return(m_fvex)
	}
	kfv = fv_count()
	if (k<=0 | k>kfv) {
		return(J(1,0,NULL))
	}
	return(m_fvex[k])	
}


/* matrix component class						*/
void __component_matrix::new()
{
	m_state.lhstype = `SUBEXPR_EVAL_MATRIX'
}

void __component_matrix::destroy()
{
	if (strlen(m_state.tname)) {
		if (group() != `SUBEXPR_MAT_GROUP') {
			st_matrix(m_state.tname,J(0,0,.))
		}
	}
	m_stmatrix.erase()
}

void __component_matrix::set_name(string scalar name)
{
	(void)m_stmatrix.set_name(name)
	super.set_name(name)
}

void __component_matrix::set_group(string scalar group)
{
	super.set_group(group)
}

real scalar __component_matrix::type()
{
	return(`SUBEXPR_MATRIX')
}

string scalar __component_matrix::stype()
{
	return(`SUBEXPR_STR_MATRIX')
}

real scalar __component_matrix::update(transmorphic data, |real scalar hint)
{
	if (hint == `SUBEXPR_HINT_MATRIX') {
		return(set_matrix(data))
	}
	if (hint == `SUBEXPR_HINT_STMATRIX') {
		return(set_stmatrix(data))
	}
	if (hint==`SUBEXPR_HINT_ROWSTRIPE' | hint==`SUBEXPR_HINT_COLSTRIPE' |
		hint==`SUBEXPR_HINT_MATSTRIPE') {
		return(set_stripe(data,hint))
	}
	if (hint == `SUBEXPR_HINT_TNAME') {
		/* tempname to store as Stata matrix			*/
		m_state.tname = data
		/* substitutable expression is the Stata matrix name	*/
		m_state.subexpr = m_state.tname
	}
	return(super.update(data,hint))
}

transmorphic __component_matrix::data(real scalar hint, |transmorphic extra)
{
	pragma unused extra

	if (hint == `SUBEXPR_HINT_MATRIX') {
		return(m_stmatrix.m())
	}
	if (hint == `SUBEXPR_HINT_STMATRIX') {
		return(m_stmatrix)
	}
	if (hint == `SUBEXPR_HINT_COLSTRIPE') {
		return(m_stmatrix.stripe(m_stmatrix.COLUMN))
	}
	if (hint == `SUBEXPR_HINT_ROWSTRIPE') {
		return(m_stmatrix.stripe(m_stmatrix.ROW))
	}
	return(super.data(hint))
}

real scalar __component_matrix::isequal(
		pointer (class __component_base) scalar pC)
{
	if (pC->type() != `SUBEXPR_MATRIX') {
		return(`SUBEXPR_FALSE')
	}
	if (!m_stmatrix.isequal(pC->data(`SUBEXPR_HINT_STMATRIX'))) {
		return(`SUBEXPR_FALSE')
	}
	return(super.isequal(pC))
}

real scalar __component_matrix::validate()
{
	real scalar rc
	real matrix val

	if (rc=super.validate()) {
		return(rc)
	}
	val = st_matrix(m_name)
	if (!rows(val) | !cols(val)) {
		m_errmsg = sprintf("matrix %s does not exist", m_name)
		return(111)
	}
	return(0)
}

void __component_matrix::display(|real scalar lev)
{
	real scalar ind

	ind = 4*(missing(lev)?0:lev-1)+1

	printf("{col %g}{txt}matrix ",ind)
	super.display(lev)
}

string scalar __component_matrix::subexpr(|transmorphic extra)
{
	if (args()) {
		return(super.subexpr(extra))
	}
	return(super.subexpr())
}

string scalar __component_matrix::expression(|real scalar which)
{
	real scalar tname
	string scalar expr

	if (which == `SUBEXPR_SUBSTITUTED') {
		tname = 1
		expr = name(tname)
	}
	else {
		expr = "{"+name()+",matrix}"
	}
	return(expr)
}

real scalar __component_matrix::set_matrix(real matrix mat)
{
	real scalar rc

	m_state.lhstype = `SUBEXPR_EVAL_MATRIX'
	if (rc=m_stmatrix.set_matrix(mat)) {
		m_errmsg = m_stmatrix.errmsg()
	}
	return(rc)
}

real scalar __component_matrix::set_stmatrix(class __stmatrix scalar mat)
{
	real matrix m
	string matrix stripe

	m_stmatrix.erase()
	m = mat.m()
	(void)m_stmatrix.set_matrix(m)
	stripe = mat.colstripe()
	if (rows(stripe)) {
		(void)m_stmatrix.set_colstripe(stripe)
	}
	stripe = mat.rowstripe()
	if (cols(stripe)) {
		(void)m_stmatrix.set_rowstripe(stripe)
	}
	m_state.lhstype = `SUBEXPR_EVAL_MATRIX'

	return(0)
}

class __stmatrix scalar __component_matrix::stmatrix()
{
	return(m_stmatrix)
}

real scalar __component_matrix::set_stripe(string matrix stripe,
			real scalar hint)
{
	real scalar rc

	if (hint == `SUBEXPR_HINT_ROWSTRIPE') {
		rc = m_stmatrix.set_stripe(stripe,m_stmatrix.ROW)
	}
	else {
		rc = m_stmatrix.set_stripe(stripe,m_stmatrix.COLUMN)
	}
	if (rc) {
		m_errmsg = m_stmatrix.errmsg()
	}
	return(rc)
}

string matrix __component_matrix::stripe(|real scalar hint)
{
	if (hint == `SUBEXPR_HINT_ROWSTRIPE') {
		return(m_stmatrix.stripe(m_stmatrix.ROW))
	}
	return(m_stmatrix.stripe(m_stmatrix.COLUMN))
}


/* named expression component class					*/
void __component_group::new()
{
	m_exprobj = J(1,0,NULL)
	m_initobj = NULL
	m_tsinit_req = `SUBEXPR_FALSE'
	m_kunique = 0
	m_instance_count = 0
	m_group_type = `SUBEXPR_UNDEFINED' 	// determine in parse/resolve
	m_eval_status = `SUBEXPR_EVAL_IDLE'	// not being evaluated
	if (!length(m_sgroup_types)) {
		m_sgroup_types = (`SUBEXPR_STR_UNDEFINED',
			`SUBEXPR_STR_GROUP_EXPRESSION',
			`SUBEXPR_STR_GROUP_LC',
			`SUBEXPR_STR_GROUP_PARAM',
			`SUBEXPR_STR_EQ_EXPRESSION',
			`SUBEXPR_STR_EQ_LC')
	}
}

void __component_group::destroy()
{
	real scalar i, k, ivar

//	errprintf("destroying __component_group %s\n",m_name)

	/* decrement reference counters					*/
	k = length(m_exprobj)
	for (i=1; i<=k; i++) {
		m_exprobj[i] = NULL
	}
	m_exprobj = J(1,0,NULL)

	if (strlen(m_state.tname)) {
		ivar = _st_varindex(m_state.tname)
		if (!missing(ivar)) {
			st_dropvar(ivar)
		}
	}	
	m_instance_count = 0
}

void __component_group::set_name(string scalar name)
{
	super.set_name(name)
}

void __component_group::set_group(string scalar group)
{
	/* programmer error: __component_group only has a name		*/
//	errprintf("attempting to set group member to %s of group object " +
//		"object %s\n",group,name())
//	displayas("text")
	super.set_group(group)		// (rbg) try group:group name
}

real scalar __component_group::type()
{
	return(`SUBEXPR_GROUP')
}

string scalar __component_group::stype()
{
	return(`SUBEXPR_STR_GROUP')
}

/*			to
 * 	from	undef	expr	LC	param
 *	undef	x.	x.	x.	x.	
 *	expr		x.
 *	LC		x.	x
 *	param		x.	?	x				*/
real scalar __component_group::set_group_type(real scalar gtype)
{
	if (m_group_type == gtype) {
		return(0)		// nothing to do 
	}
	if (gtype<1 | gtype>`SUBEXPR_EQ_LC') {
		/* programmer error					*/
		m_errmsg = sprintf("invalid specification for group {bf:%s}",
			name())
		return(109)
	}
	if (m_group_type == `SUBEXPR_UNDEFINED') {
		m_group_type = gtype	// allow anything
		if (m_group_type==`SUBEXPR_EQ_LC' |
			m_group_type==`SUBEXPR_EQ_EXPRESSION') {
			m_state.lhstype = `SUBEXPR_EVAL_VECTOR'
		}

		return(0)
	}
	if (gtype == `SUBEXPR_GROUP_EXPRESSION') {
		m_group_type = gtype
		return(0)
	}
	if (gtype==`SUBEXPR_GROUP_LC' & m_group_type==`SUBEXPR_GROUP_PARAM') {
		/* could be referencing a LC parameters			*/
		/*  hopefully catch a bad conversion later		*/
		m_group_type = gtype
		return(0)
	}
	if (gtype==`SUBEXPR_GROUP_PARAM' & m_group_type==`SUBEXPR_GROUP_LC') {
		/* could be referencing a LC parameters			*/
		/*  hopefully catch a bad conversion later		*/
		m_group_type = gtype
		return(0)
	}
	/* error condition						*/
	m_errmsg = sprintf("invalid specification for group {bf:%s}; " +
			"conversion of a %s to a %s is not allowed",name(),
			sgroup_type(),m_sgroup_types[gtype])
	return(109)
}

real scalar __component_group::group_type()
{
	return(m_group_type)
}

string scalar __component_group::sgroup_type()
{
	/* keep m_sgroup_types string array in sync with group type
	 * indices in __sub_expr_macros.matah				*/
	return(m_sgroup_types[m_group_type])
}

real scalar __component_group::isequal(
		pointer (class __component_base) scalar pC)
{
	real scalar iseq
	pointer (class __component_group) scalar pG

	if (!super.isequal(pC)) {
		return(`SUBEXPR_FALSE')
	}
	pG = pC
	iseq = (group_type()==pG->group_type())
	pG = NULL

	return(iseq)
}

real scalar __component_group::update(transmorphic data, real scalar hint)
{
	real scalar k, i, j, rc, found, prop
	pointer (class __sub_expr_object) scalar pSG

	rc = 0
	if (hint==`SUBEXPR_HINT_DATAOBJ' | hint==`SUBEXPR_HINT_REMOVEOBJ') {
		pSG = data
		prop = pSG->data(`SUBEXPR_HINT_PROPERTIES')
		if (_sub_expr_has_property(prop,`SUBEXPR_PROP_TS_INIT')) {
			if (hint == `SUBEXPR_HINT_REMOVEOBJ') {
				if (m_initobj == pSG) {
					set_TS_initobj(NULL)
				}
				else {
					rc = super.update(data,hint)
				}
			}
			else if (!(rc=pSG->update(`SUBEXPR_INSTANCE_ID_INIT',
				`SUBEXPR_HINT_INSTANCE_ID'))) {
				set_TS_initobj(pSG)
			}
			return(rc)
		}

		k = length(m_exprobj)
		m_kunique = 0	// reset unique count

		found = `SUBEXPR_FALSE'
		for (i=1; i<=k; i++) {
			if (pSG == m_exprobj[i]) {
				found = `SUBEXPR_TRUE'
				if (hint == `SUBEXPR_HINT_REMOVEOBJ') {
					m_exprobj[i] = NULL
					for (j=i+1; j<=k; j++) {
						m_exprobj[j-1] = m_exprobj[j]
					}
					m_exprobj[k] = NULL
					k--
					if (k <= 0) {
						m_exprobj = J(1,0,NULL)
					}
					else {
						m_exprobj = m_exprobj[|1\k|]
					}
					break
				}
			}
		}
		if (hint == `SUBEXPR_HINT_DATAOBJ') {
			if (!found) {
				m_instance_count++
				m_exprobj = (m_exprobj,pSG)
				if (rc=pSG->update(m_instance_count,
					`SUBEXPR_HINT_INSTANCE_ID')) {
					return(rc)
				}
			}
		}
		rc = super.update(data,hint)
		if (0 & m_ref!=length(m_exprobj)) {	// debug
			/* programmer error				*/
			errprintf("group %s (%s): reference count is %g, " +
				"but array length is %g\n",name(),sgroup_type(),
			m_ref,length(m_exprobj))
			displayas("txt")
		}
		return(rc)
	}
	if (hint == `SUBEXPR_HINT_TSINIT_REQ') {
		set_TS_init_req(data)
		return(rc)
	}
	if (rc=super.update(data,hint)) {
		return(rc)
	}
	if (hint == `SUBEXPR_HINT_MARK_DIRTY') {
		k = length(m_exprobj)
		for (i=1; i<=k; i++) {
			pSG = m_exprobj[i]
			/* independent state object	if k > 1	*/
			if (rc=pSG->update(NULL,`SUBEXPR_HINT_MARK_DIRTY')) {
				break
			}
		}
		pSG = NULL
	}
	return(rc)
}

transmorphic __component_group::data(real scalar hint, |transmorphic extra)
{
	real scalar i

	if (hint == `SUBEXPR_HINT_DATAOBJ') {
		i = extra
		if (i>0 & i<=length(m_exprobj)) {
			return(m_exprobj[i])
		}
		return(NULL)
	}
	if (hint == `SUBEXPR_HINT_INITOBJ') {
		return(TS_initobj())
	}
	if (hint == `SUBEXPR_HINT_TSINIT_REQ') {
		return(TS_init_req())
	}
	if (hint == `SUBEXPR_HINT_GROUP_TYPE') {
		return(group_type())
	}
	return(super.data(hint))
}

real scalar __component_group::validate()
{
	real scalar i, j, rc
	string name
	pointer (class __component_base) scalar comp

	if (rc=super.validate()) {
		return(rc)
	}
	if (m_ref!=length(m_exprobj)) {	
		m_errmsg = printf("component group has a reference count " +
			"of %g, but %g group objects are referencing it",
			m_ref,length(m_exprobj))
		return(503)
		
	}
	i = 0
	while (++i <= m_ref) {
		if (m_exprobj[i] == NULL) {
			for (j=i; j<m_ref; j++) {
				m_exprobj[j] = m_exprobj[j+1]
			}
			m_ref--
			continue
		}
		comp = m_exprobj[i]->data(`SUBEXPR_HINT_COMPONENT')
		if (comp != this) {
			/* programmer error				*/
			if (comp == NULL) {
				name = "NULL"
			}
			else {
				name = comp->name()
			}
			m_errmsg = sprintf("component group {bf:%s} has a " +
				"mismatched object {bf:%s}",name(),name)
			return(498)
		}
	}
	return(0)
}

void __component_group::display(|real scalar lev)
{
	pragma unused lev

	if (m_group_type==`SUBEXPR_EQ_LC' | 
		m_group_type==`SUBEXPR_EQ_EXPRESSION') {
		printf("{txt}equation ")
	}
	printf("{txt}component:{res}%s\n",name())
}


void __component_group::set_TS_init_req(real scalar req)
{
	m_tsinit_req = (req!=`SUBEXPR_FALSE')
}

real scalar __component_group::TS_init_req()
{
	return(m_tsinit_req)
}

real scalar __component_group::group_count(|real scalar unique)
{
	real scalar i, j, k, iseq
	pointer (class __sub_expr_group) scalar pSE
	pointer (class __sub_expr_group) vector vSE

	k = length(m_exprobj)
	unique = (missing(unique)?`SUBEXPR_FALSE':(unique!=`SUBEXPR_FALSE'))
	if (!unique) {
		return(k)
	}
	if (m_kunique) {
		return(m_kunique)
	}
	if (!k) {
		return(0)
	}
	if (m_group_type == `SUBEXPR_GROUP_PARAM') {
		m_kunique = k
		return(m_kunique)	// all different
	}
	else if (m_group_type == `SUBEXPR_EQ_LC' |
		m_group_type == `SUBEXPR_EQ_EXPRESSION' |
		m_group_type == `SUBEXPR_GROUP_EXPRESSION') {
		m_kunique = 1
		return(m_kunique)	// unique
	}
	/* linear combination group, can have multiple forms		*/
	for (i=1; i<=k; i++) {
		/* look for a template object				*/
		pSE = m_exprobj[i]
		if (pSE->has_property(`SUBEXPR_PROP_TEMPLATE')) {
			m_kunique = 1
			break
		}
	}
	pSE = NULL
	if (m_kunique) {
		return(m_kunique)
	}
	/* no template, first will do					*/
	vSE = m_exprobj[1]
	for (i=2; i<=k; i++) {
		iseq = 0
		pSE = m_exprobj[i]
		for (j=1; j<=length(vSE); j++) {
			if (pSE->isequal(vSE[j])) {
				iseq = 1
				break
			}
		}
		if (!iseq) {
			vSE = (vSE,pSE)
		}
		pSE = NULL
	}
	m_kunique = length(vSE)
	for (i=1; i<=m_kunique; i++) {
		vSE[i] = NULL
	}
	vSE = J(1,0,NULL)

	/* after resolve_expressions m_kunique must equal k 		*/
	return(m_kunique)
}

pointer (class __sub_expr_object) scalar __component_group::get_object(
			real scalar i)
{
	if (i<1 | i>group_count()) {
		return(NULL)
	}
	return(m_exprobj[i])
}

void __component_group::set_eval_status(real scalar status)
{
	
	if (group_type()!=`SUBEXPR_GROUP_EXPRESSION' &
		group_type()!=`SUBEXPR_EQ_EXPRESSION') {
		/* should not do this					*/
		return
	}
	if (status == `SUBEXPR_EVAL_EXPR') {
		m_eval_status = status
	}
	else if (status == `SUBEXPR_EVAL_INIT') {
		m_eval_status = status
	}
	else if (status == `SUBEXPR_EVAL_VARLIST') {
		m_eval_status = status
	}
	else if (status == `SUBEXPR_EVAL_TS_ORDER') {
		m_eval_status = status
	}
	else if (status == `SUBEXPR_EVAL_DEPENDENCY') {
		m_eval_status = status
	}
	else if (status == `SUBEXPR_EVAL_TS_RECURSIVE') {
		m_eval_status = status
	}
	else {
		m_eval_status = `SUBEXPR_EVAL_IDLE'
	}
}

real scalar __component_group::eval_status()
{
	return(m_eval_status)
}

void __component_group::set_TS_initobj(
		pointer (class __sub_expr_object) scalar pInit)
{
	m_initobj = pInit
}

pointer (class __sub_expr_object) scalar __component_group::TS_initobj()
{
	return(m_initobj)
}

string scalar __component_group::subexpr(|transmorphic extra)
{
	if (args()) {
		return(super.subexpr(extra))
	}
	return(super.subexpr())
}

string scalar __component_group::expression(|real scalar which)
{
	if (which == `SUBEXPR_SUBSTITUTED') {
		return(subexpr())
	}
	if (which == `SUBEXPR_CONDENSED') {
		return("{"+name()+":}")
	}
	return("")
}

end
exit

