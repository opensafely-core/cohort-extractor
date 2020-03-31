*! version 1.2.2  04sep2019

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile __tempnames.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_object.matah
quietly include `"`r(fn)'"'

findfile __component.matah
quietly include `"`r(fn)'"'

findfile __sub_expr.matah
quietly include `"`r(fn)'"'

findfile nlparse_macros.matah
quietly include `"`r(fn)'"'

findfile nlparse.matah
quietly include `"`r(fn)'"'

local KVAR 1
local KFAC 2
local KLAT 3

// local TRACE trace = 1

mata:

mata set matastrict on

/* implementation: __sub_expr_group					*/
void __sub_expr_group::new()
{
	unlink()
	m_options = J(1,0,"")
}

void __sub_expr_group::destroy()
{
//	errprintf("destroying __sub_expr_group %s ",name()); &this
//	displayas("txt")
	/* call private version here					*/
	_clear()
	unlink()
}

void __sub_expr_group::clear()
{
	_clear()
	super.clear()
	unlink()
}

void __sub_expr_group::_clear()
{
	real scalar ivar
	string scalar tname

	/* remove tempvar before clearing m_state in super		*/
	tname = tempname()
	if (strlen(tname)) {
		ivar = _st_varindex(tname)
		if (!missing(ivar)) {
			st_dropvar(ivar)
		}
	}
	m_LVnames = J(1,0,"")

	if (m_first) {
		if (!m_first->has_property(`SUBEXPR_PROP_TEMPLATE')) {
			m_first->clear()
		}
	}
	m_instance = .
}

void __sub_expr_group::unlink()
{
	/* decrement reference counts					*/
	m_kexpr = 0
	m_first = m_last = NULL
	m_state = NULL
	m_hascons = `SUBEXPR_MAYBE'
	m_coefref = `SUBEXPR_FALSE'
	m_eready = `SUBEXPR_FALSE'

	m_n = 0

	m_ptree.type = `NULL'
	m_ptree.symb = ""
	m_ptree.val = .
	m_ptree.narg = 0
	m_ptree.arg = nlparse_node(0)
	m_tsorder = J(1,3,0)
}

transmorphic __sub_expr_group::data(real scalar hint)
{
	pointer (class __component_group) scalar pC

	if (hint == `SUBEXPR_HINT_EQUATION_OBJ') {
		return(eqobj())
	}
	if (hint == `SUBEXPR_HINT_LV_NAMES') {
		return(LV_names())
	}
	if (hint == `SUBEXPR_HINT_INSTANCE_ID') {
		return(instance())
	}
	if (hint == `SUBEXPR_HINT_TS_ORDER') {
		return(TS_order())
	}
	if (hint == `SUBEXPR_HINT_GROUP_TYPE') {
		return(group_type())
	}
	if (hint == `SUBEXPR_HINT_GROUP_STYPE') {
		return(sgroup_type())
	}
	if (hint == `SUBEXPR_HINT_TSINIT_REQ') {
		pC = component()
		if (pC != NULL) {
			return(pC->TS_init_req())
		}
	}	
	return(super.data(hint))
}

real scalar __sub_expr_group::update(transmorphic data, real scalar hint)
{
	pointer (class __component_group) scalar pC

	if (hint == `SUBEXPR_HINT_INSTANCE_ID') {
		set_instance(data)
		return(0)
	}
	if (hint == `SUBEXPR_HINT_MARK_DIRTY') {
		mark_dirty()
		return(0)
	}
	if (hint == `SUBEXPR_HINT_TSINIT_REQ') {
		pC = component()
		if (pC != NULL) {
			pC->set_TS_init_req(data)
			return(0)
		}
	}	
	return(super.update(data,hint))
}

struct nlparse_node scalar __sub_expr_group::parse_tree()
{
	return(m_ptree)
}

void __sub_expr_group::set_parse_tree(struct nlparse_node tree)
{
	m_ptree = tree
}

void __sub_expr_group::set_TS_order(real vector order, |real scalar which)
{
	if (which == `TS_LORDER') {
		if (!missing(order[1]) & (order[1]>m_tsorder[`TS_LORDER'])) {
			m_tsorder[`TS_LORDER'] = order[1]
		}
	}
	else if (which == `TS_FORDER') {
		if (!missing(order[1]) & (order[1]>m_tsorder[`TS_FORDER'])) {
			m_tsorder[`TS_FORDER'] = order[1]
		}
	}
	else if (which == `TS_EXPR_LORDER') {
		if (!missing(order[1]) & 
			(order[1]>m_tsorder[`TS_EXPR_LORDER'])) {
			m_tsorder[`TS_EXPR_LORDER'] = order[1]
		}
	}
	else if (length(order) == 2) {
		set_TS_order(order[`TS_LORDER'],`TS_LORDER')
		set_TS_order(order[`TS_FORDER'],`TS_FORDER')
	}
	else if (length(order) == 3) {
		set_TS_order(order[`TS_LORDER'],`TS_LORDER')
		set_TS_order(order[`TS_FORDER'],`TS_FORDER')
		set_TS_order(order[`TS_EXPR_LORDER'],`TS_EXPR_LORDER')
	}
}

real vector __sub_expr_group::TS_order(|real scalar which, 
			real scalar depth_chk)
{
	real scalar i, k
	real vector tsorder, tso

	pointer (class __sub_expr_elem) scalar pE
	pointer (class __sub_expr_group) scalar pG

	depth_chk = ((depth_chk<0|depth_chk>5)?0:depth_chk)
	if (which == `TS_LORDER') {
		tsorder = m_tsorder[`TS_LORDER']
	}
	else if (which == `TS_FORDER') {
		tsorder = m_tsorder[`TS_FORDER']
	}
	else if (which == `TS_EXPR_LORDER') {
		tsorder = m_tsorder[`TS_EXPR_LORDER']
	}
	else {
		tsorder = m_tsorder
	}
	if ((--depth_chk) >= 0) {
		k = length(tsorder)
		pE = first()
		while (pE) {
			if (pE->type() != `SUBEXPR_GROUP') {
				goto Next
			}
			pG = pE
			tso = pG->TS_order(which,depth_chk)
			for (i=1; i<=k; i++) {
				tsorder[i] = max((tsorder[i],tso[i]))
			}
			Next: pE = pE->next()
		}
	}
	return(tsorder)
}

real scalar __sub_expr_group::isequal(pointer (class __sub_expr_elem) scalar pE)
{
	real scalar isequal, i, k
	real vector o1, o2
	string vector names1, names2
	pointer (class __sub_expr_group) scalar pSE
	pointer (class __sub_expr_elem) scalar pE1, pE2
	pointer (class __sub_expr_elem) vector vE1, vE2

	if (!super.isequal(pE)) {
		return(0)
	}
	pSE = pE
	isequal = `SUBEXPR_FALSE'
	if (!isdefined()) {
		if (!pSE->isdefined()) {
			isequal = `SUBEXPR_TRUE'
		}
		pSE = NULL
		return(isequal)
	}
	else if (!pSE->isdefined()) {
		pSE = NULL
		return(isequal)
	}
	pE1 = first()
	pE2 = pSE->first()
	if ((k=kexpr())!=pSE->kexpr()) {
		if (!((pSE->has_property(`SUBEXPR_PROP_TEMPLATE')|
			has_property(`SUBEXPR_PROP_TEMPLATE')) &
			all(key():==pSE->key()))) {
			pSE = NULL
			return(isequal)
		}
		if (pE1 != pE2) {
			pSE = NULL
			return(isequal)
		}
		k = pSE->kexpr()
	}	
	if (group_type() == `SUBEXPR_GROUP_LC') {
		/* allow variables to be in different order		*/
		vE1 = vE2 = J(k,1,NULL)
		names1 = names2 = J(k,1,"")
		i = 0
		isequal = `SUBEXPR_TRUE'
		while (pE1 & pE2) {
			names1[++i] = pE1->name()
			names2[i] = pE2->name()
			vE1[i] = pE1
			vE2[i] = pE2
			pE1 = pE1->next()
			pE2 = pE2->next()
		}
		if (i != k) {
			/* error condition				*/
			isequal = `SUBEXPR_FALSE'
		}
		else {
			o1 = order(names1,1)
			o2 = order(names2,1)
			isequal = `SUBEXPR_TRUE'
			for (i=1; i<=k; i++) {
				if (!vE1[o1[i]]->isequal(vE2[o2[i]])) {
					isequal = `SUBEXPR_FALSE'
					break
				}
			}
		}
		for (i=1; i<=k; i++) {
			vE1[i] = NULL
			vE2[i] = NULL
		}
		vE1 = vE2 = J(0,1,NULL)
		names1 = names2 = J(0,1,"")
	}
	else {
		isequal = `SUBEXPR_TRUE'
		while (isequal & pE1 & pE2) {
			isequal = pE1->isequal(pE2)
			pE1 = pE1->next()
			pE2 = pE2->next()
		}
	}
	pE1 = pE2 = NULL
	pSE = NULL

	return(isequal)
}

void __sub_expr_group::pt_display()
{
	if (m_ptree.type == `NULL') {
		return
	}
	printf("\n%s: {res}%s{txt}\n",sgroup_type(),name())
	::pt_display(m_ptree)
}

void __sub_expr_group::display(real scalar lev)
{
	real scalar lev1, ind, gtype
	string scalar tname, expr
	pointer (class __sub_expr_elem) scalar cur

	gtype = group_type()
	if (gtype==`SUBEXPR_EQ_LC' | gtype==`SUBEXPR_EQ_EXPRESSION') {
		printf("{txt}\nEquation: %s (%s)\n",name(),sgroup_type())
		printf("{txt}\noriginal expression:\n")
		printf("{res}{asis}%s{smcl}\n", m_expression)
		expr = traverse_expr(`SUBEXPR_FULL')
		printf("{txt}\nparsed expression:\n{res}{asis}%s{smcl}\n",expr)
		expr = traverse_expr(`SUBEXPR_CONDENSED')
		printf("{txt}\ncondensed expression:\n{res}{asis}%s{smcl}\n",
			expr)
		expr = traverse_expr(`SUBEXPR_SUBSTITUTED')
		printf("{txt}\nsubstituted expression:\n{res}%s\n",expr)
	}
	ind = (lev-1)*4+1
	if (type()!=`SUBEXPR_EQ_LC' & gtype!=`SUBEXPR_EQ_EXPRESSION') {
		printf("\n{txt}{col %g}group: {res}%s {txt}({res}%s{txt})\n",
				ind,name(),sgroup_type())
		super.display(lev)
		if (m_state == NULL) {
			tname =	super.tempname()
		}
		else {
			tname = m_state->tname
		}
		ind = 4*lev+1
		printf("{col %g}{txt}sub expr: {res}%s\n",ind,tname)
	}

	lev1 = lev + 1
	if (m_kexpr) {
		printf("\n{txt}level {res}%g\n", lev1)
		cur = m_first
		while (cur != NULL) {
			cur->display(lev1)
			cur = cur->next()
		}
	}
}

real scalar __sub_expr_group::set_group_type(real scalar gtype)
{
	real scalar rc
	pointer (class __component_group) scalar pG
	
	pG = component()
	if (pG == NULL) {
		/* programmer error					*/
		m_data->set_errmsg("attempting to modify object before " +
			"properly constructed")
		exit(498)
	}
	rc = pG->set_group_type(gtype)
	if (rc) {
		m_data->set_errmsg(pG->errmsg())
	}
	pG = NULL

	return(rc)
}

real scalar __sub_expr_group::group_type()
{
	real scalar gtype
	pointer (class __component_group) scalar pG

	pG = component()
	gtype = pG->group_type()
	pG = NULL

	return(gtype)
}

string scalar __sub_expr_group::sgroup_type()
{
	string scalar sgroup

	pointer (class __component_group) scalar pG

	pG = component()
	sgroup = pG->sgroup_type()
	pG = NULL

	return(sgroup)
}

pointer (class __sub_expr_group) scalar __sub_expr_group::eqobj()
{
	real scalar gtype
	pointer (class __sub_expr_group) scalar pG

	gtype = group_type()

	if (gtype==`SUBEXPR_EQ_EXPRESSION' | gtype==`SUBEXPR_EQ_LC') {
		return(&this)
	}
	pG = m_group		// group containing this group
	while (pG != NULL) {
		gtype = pG->group_type()
		if (gtype==`SUBEXPR_EQ_EXPRESSION' | gtype==`SUBEXPR_EQ_LC') {
			break
		}
		pG = pG->groupobj()
	}
	return(pG)
}

string scalar __sub_expr_group::tempname()
{
	if (m_state == NULL) {
		/* m_state can be NULL during destruction		*/
		return(super.tempname())
	}
	return(m_state->tname)
}

void __sub_expr_group::set_instance(real scalar instance)
{
	m_instance = instance
}

real scalar __sub_expr_group::instance()
{
	return(m_instance)
}

real scalar __sub_expr_group::set_touse(string scalar touse)
{
	real scalar rc
	string scalar errmsg

	pragma unset errmsg

	/* assumption: not abbreviated					*/
	if (rc=__sub_expr_validate_touse(touse,errmsg,`SUBEXPR_TRUE')) {
		m_data->set_errmsg(errmsg)
	}
	else if (has_property(`SUBEXPR_PROP_TS_INIT')) {
		m_state->touse_init = touse
	}
	else {
		m_state->touse = touse
	}
	return(rc)
}

string scalar __sub_expr_group::touse(|real scalar markout)
{
	real scalar nooutput
	string scalar touse, cmd
	pointer (class __component_group) scalar pG
	class __tempnames scalar tn

	markout = (missing(markout)?`SUBEXPR_FALSE':(markout!=`SUBEXPR_FALSE'))
	touse = ""
	if (has_property(`SUBEXPR_PROP_TS_INIT')) {
		if (ustrlen(m_state->touse_init)) {
			return(m_state->touse_init)
		}
	}
	else if (ustrlen(m_state->touse)) {
		return(m_state->touse)
	}
	nooutput = `SUBEXPR_TRUE'
	if (markout) {
		pG = component()
		if (pG->group_type() != `SUBEXPR_GROUP_PARAM') {
			/* must have its own estimation sample		*/
			touse = m_data->new_tempname(tn.VARIABLE)
		}
		if (ustrlen(touse)) {
			cmd = sprintf("gen byte %s = %s",touse,
				 m_data->touse())
			if (_stata(cmd,nooutput)) {
				touse = ""
			}
			if (set_touse(touse)) {
				touse = ""
			}
		}
		return(touse)
	}
	/* full estimation sample					*/
	return(m_data->touse())
}

void __sub_expr_group::set_hascons(real scalar hascons)
{
	if (hascons>=`SUBEXPR_MAYBE' & hascons<=`SUBEXPR_TRUE') {
		m_hascons = hascons
	}
}

real scalar __sub_expr_group::set_component(
			pointer (class __component_base) scalar pC)
{
	real scalar rc, type

	if (m_comp != NULL) {
		if (m_comp->state() == m_state) {
			m_state = NULL
		}
	}
	if (pC != NULL) {
		type = pC->type()
		if (type != `SUBEXPR_GROUP') {
			/* programmer error				*/
			m_data->set_errmsg(sprintf("type mismatch; attempting "
				+ "to set a %s component into a group object",
				pC->stype()))
			return(498)
		}
		/* share the state with the group component
		 *  might replace the state object during resolve stage	*/
		m_state = pC->state()
	}
	if (rc=super.set_component(pC)) {
		return(rc)
	}
	return(0)
}

real scalar __sub_expr_group::update_group_type(
		pointer (class __component_base) scalar pC)
{
	real scalar rc, type, gtype
	string scalar stype, group
	pointer (class __component_group) scalar pG

	pG = component()

	rc = 0
	if (pC == NULL) {
		type = `SUBEXPR_EXPRESSION'
		stype = "expression"
		group = ""
	}
	else {
		type = pC->type()
		stype = pC->stype()
		group = pC->group()
	}
	gtype = pG->group_type()

	if (gtype == `SUBEXPR_EQ_LC') {
		/* special case: {depvar} {indepvars}			*/
		if (!(type==`SUBEXPR_LC_PARAM' | type==`SUBEXPR_FV_PARAM' |
			type == `SUBEXPR_LV' | type==`SUBEXPR_FV')) {
			m_data->set_errmsg(sprintf("linear combination " +
				"{bf:%s} cannot contain an %s object",name(),
				stype))
			pG = NULL
			return(198)
		}
	}
	else if (gtype == `SUBEXPR_EQ_EXPRESSION') {
		if (type==`SUBEXPR_MATRIX' & group==name()) {
			rc = pG->set_group_type(`SUBEXPR_GROUP_PARAM')
		}
	}
	else if (type == `SUBEXPR_LC_PARAM') {
		if (gtype == `SUBEXPR_UNDEFINED') {
			rc = pG->set_group_type(`SUBEXPR_GROUP_LC')
		}
		else if (gtype != `SUBEXPR_GROUP_LC') {
			m_data->set_errmsg(sprintf("%s {bf:%s} cannot " +
				"contain an %s object",pG->sgroup_type(),name(),
				stype))
			pG = NULL
			return(198)
		}
	}
	else if (type == `SUBEXPR_PARAM')  {
		rc = pG->set_group_type(`SUBEXPR_GROUP_PARAM')
	}
	else if (type == `SUBEXPR_LV') {
		if (gtype == `SUBEXPR_UNDEFINED') {
			rc = pG->set_group_type(`SUBEXPR_GROUP_PARAM')
		}
	}
	else if (type==`SUBEXPR_VARIABLE') {
		rc = pG->set_group_type(`SUBEXPR_GROUP_EXPRESSION')
	}
	else if (type == `SUBEXPR_MATRIX') {
		if (group == name()) {
			rc = pG->set_group_type(`SUBEXPR_GROUP_PARAM')
		}
		else {
			rc = pG->set_group_type(`SUBEXPR_GROUP_EXPRESSION')
		}
	}
	else if (type == `SUBEXPR_EXPRESSION') {
		rc = pG->set_group_type(`SUBEXPR_GROUP_EXPRESSION')
	}
	else if (type == `SUBEXPR_GROUP') {
		rc = pG->set_group_type(`SUBEXPR_GROUP_EXPRESSION')
	}
	if (rc) {
		/* more information here: rewrite the message		*/
		if (pC == NULL) {
			m_data->set_errmsg(sprintf("an expression cannot be " +
				"in the %s {bf:%s}",pG->sgroup_type(),
				pG->name()))
		}
		else {
			m_data->set_errmsg(pG->errmsg())
		}
	}
	pG = NULL

	return(rc)
}

pointer (struct __component_state) scalar __sub_expr_group::state()
{
	return(m_state)
}

void __sub_expr_group::set_state(
			pointer (struct __component_state) scalar state)
{
	m_state = state
}

string scalar __sub_expr_group::subexpr()
{
	string scalar subexpr

	subexpr = m_state->subexpr
	if (!ustrlen(subexpr)) {
		subexpr = tempname()
	}
	return(subexpr) 
}

real scalar __sub_expr_group::coefref()
{
	return(m_coefref)
}

real scalar __sub_expr_group::estate()
{
	return(m_state->estate)
}

real scalar __sub_expr_group::lhstype()
{
	real scalar gtype

	if (m_state->lhstype != `SUBEXPR_EVAL_NULL') {
		return(m_state->lhstype)
	}
	gtype = group_type()
	if (gtype==`SUBEXPR_EQ_LC' | gtype==`SUBEXPR_EQ_EXPRESSION' |
		gtype==`SUBEXPR_GROUP_LC') {
		m_state->lhstype = `SUBEXPR_EVAL_VECTOR'
	}
	return(m_state->lhstype)
}

pointer (class __sub_expr_elem) scalar __sub_expr_group::first(
			|real scalar notemplate)
{
	pointer (class __sub_expr_group) scalar pSE

	if (m_first != NULL) {
		notemplate = (missing(notemplate)?`SUBEXPR_FALSE':
				(notemplate!=`SUBEXPR_FALSE'))
		if (!notemplate) {
			if (m_first->has_property(`SUBEXPR_PROP_TEMPLATE') &
				all(m_first->key():==key())) {
				pSE = m_first
				return(pSE->first())
			}
		}
	}
	return(m_first)
}

pointer (class __sub_expr_elem) scalar __sub_expr_group::last()
{
	return(m_last)
}

real scalar __sub_expr_group::traverse_expr_tree(struct nlparse_node tree)
{
	real scalar i, rc, narg, type
	string scalar expr, name
	struct nlparse_node scalar node
	pointer (class __component_param) scalar pC
	pointer (class __sub_expr_elem) scalar pE

	pragma unset pC

	rc = 0
	type = tree.type
	narg = tree.narg
	if (narg != 2) {
		rc = 499
	}
	if (type!=`EXPRESSION' & type!=`EQUATION') {
		rc = 499
	}
	if (rc) {
		m_data->set_errmsg(sprintf("invalid nonlinear expression " +
			"specification: expected a nonlinear expression " +
			"but got a %s",pt_stype(type)))
		return(rc)
	}
	name = tree.arg[1].symb
	if (tree.arg[1].type == `TSOP') {
		node = tree.arg[1]
		name = name + node.arg[1].symb
		m_data->set_errmsg(sprintf("invalid specification {bf:%s}: " +
			"operators are not allowed on the expression left " +
			"hand side",name))
		return(198)
	}
	if (name != name()) {
		/* programmer error					*/
		m_data->set_errmsg(sprintf("invalid nonlinear expression  " +
			"specification: expected expression name " +
			"{bf:%s}, but got {bf:%s}",name(),name))

		return(499)
	}
	/* no options allowed						*/
	if (rc=validate_options(J(1,0,""),0)) {
		return(rc)
	}
	m_ptree = tree
// pt_display()
	if (narg==2 & !has_property(`SUBEXPR_PROP_TS_INIT')) {
		node = m_ptree.arg[2]
		if (node.type == `SYMBOL') {
			/* free parameter				*/
			if (rc=set_group_type(`SUBEXPR_GROUP_PARAM')) {
				m_data->set_errmsg(sprintf("failed to create " +
					"free parameter group {bf:%s}",
					name()))
				return(498)
			}
			rc = m_data->register_component(node.symb,name(),
				`SUBEXPR_PARAM',pC)
			if (!rc) {
				pE = &__sub_expr_elem(1)
				pE->set_dataobj(m_data)
				pE->set_component(pC)
				rc = add_object(pE)
			}
			pE = NULL
			pC = NULL
			return(rc)
		}
		if (node.type==`TSOP' |node.type == `FACTOROP') {
			m_data->set_errmsg(sprintf("invalid free parameter " +
				"specification {bf:%s:%s%s}; operator " +
				"{bf:%s} not allowed",name(),node.symb,
				node.arg[1].symb,node.symb))
			return(498)
		}
	}
	for (i=2; i<=narg; i++) {
		expr = ""
 		if (rc=traverse_expr_node(m_ptree.arg[i],expr)) {
			return(rc)
		}
	}
	if (strlen(expr)) {
		/* add current string expression			*/
		rc = add_strexpression(expr)
		expr = ""
	}
	return(rc)
}

real scalar __sub_expr_left_opc_LT_opp(struct nlparse_node scalar opp,
		struct nlparse_node scalar opc)
{
	real scalar llogic

	if ((opc.symb=="-"|opc.symb=="!") & opc.narg==1) {
		/* unary minus or not operator				*/
		if (opp.symb == "^") {
			return(`SUBEXPR_TRUE')
		}
		return(`SUBEXPR_FALSE')
	}
	if ((opc.symb=="&") | (opc.symb=="|")) {
		return(`SUBEXPR_FALSE')
	}
	llogic = (opc.symb=="=="|opc.symb=="!="|opc.symb=="<="|
		opc.symb==">="|opc.symb=="<"|opc.symb==">")
	if (opp.symb == "-" & opp.narg==1) {
		/* unary minus						*/
		return((opc.symb=="+" | opc.symb=="-" | llogic))
	}
	if (llogic) {
		return(`SUBEXPR_TRUE')
	}
	if ((opp.symb=="&") | (opp.symb=="|")) {
		return(`SUBEXPR_TRUE')
	}
	if (opc.symb=="+" | opc.symb=="-") {
		return((opp.symb=="*" | opp.symb=="/" | opp.symb=="^" |
			opp.symb=="'"))
	}
	if (opc.symb=="*" | opc.symb=="/") {
		return((opp.symb=="^" | opp.symb=="'"))
	}
	/* more operators? */
	return(`SUBEXPR_FALSE')
}

real scalar __sub_expr_right_opc_LT_opp(struct nlparse_node scalar opp,
		struct nlparse_node scalar opc)
{
	real scalar llogic

	if ((opc.symb=="-"|opc.symb=="!") & opc.narg==1) {
		/* unary minus or not operator				*/
		return(`SUBEXPR_FALSE')
	}
	if ((opc.symb=="&") | (opc.symb=="|")) {
		return(`SUBEXPR_FALSE')
	}
	llogic = (opc.symb=="=="|opc.symb=="!="|opc.symb=="<="|
		opc.symb==">="|opc.symb=="<"|opc.symb==">")
	if (opp.symb == "-" & opp.narg==1) {
		/* unary minus						*/
		return((opc.symb=="+" | opc.symb=="-" | llogic))
	}
	if (llogic) {
		return(`SUBEXPR_TRUE')
	}
	if ((opp.symb=="&") | (opp.symb=="|")) {
		return(`SUBEXPR_TRUE')
	}
	if (opc.symb=="+" | opc.symb=="-") {
		return((opp.symb=="*" | opp.symb=="/" | opp.symb=="^" |
			opp.symb=="'") | opp.symb=="-")
	}
	if (opp.symb == "/") {
		return((opc.symb=="*"))
	}
	if (opc.symb=="*" | opc.symb=="/") {
		return((opp.symb=="^" | opp.symb=="'"))
	}
	/* more operators? */
	return(`SUBEXPR_FALSE')
}

real scalar _sub_expr_TS_order(string scalar symb, string scalar tsop)
{
	real scalar order, k

	order = 0
	k = ustrlen(symb)
	tsop = ""
	if (!k) {
		return(order)
	}
	tsop = strupper(ustrleft(symb,1))
	if (tsop!="L" & tsop!="D" & tsop!="F") {
		return(order)
	}
	order = 1
	if (k > 2) {
		order = __sub_expr_as_numeric(usubstr(symb,2,k-2))
	}
	return(order)
}

real scalar __sub_expr_group::traverse_expr_node(
		struct nlparse_node scalar node, string scalar expr) 
{
	real scalar type, gtype, i, k, kg, rc, index, closep
	real scalar existed, order, lvsym
	string scalar sym, group, covariate, tsop
	string vector key
	struct nlparse_node scalar nodei, top
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pCG
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __sub_expr_group) scalar pG

	pragma unset pC
	pragma unset pG
	pragma unset pE
	pragma unset existed
	pragma unset tsop

// pt_dump_node(node)
	rc = 0
	if (node.type == `OPERATOR') {
		k = node.narg
 		/* operator should only have 1 or 2 nodes		*/
		closep = `SUBEXPR_FALSE'
		/* left child						*/
		nodei = node.arg[1]
		if (k==1 & (node.symb=="-"|node.symb=="!")) {
			/* unary minus or not operator			*/
			expr = expr + node.symb
		}
		if (nodei.type == `OPERATOR') {
			if (__sub_expr_left_opc_LT_opp(node,nodei)) {
				expr = expr + "("
				closep = `SUBEXPR_TRUE'
			}
		}
		if (rc=traverse_expr_node(node.arg[1],expr)) {
			return(rc)
		}
		if (closep) {
			expr = expr + ")"
		}
		if (k == 1) {
			if (node.symb=="'" | node.symb=="^") {
				expr = expr + node.symb
			}
			return(rc)
		}
		if (top.type != `LVPARAM') {
			/* add operator					*/
			expr = expr + node.symb
		}

		/* right child						*/
		nodei = node.arg[2]
		closep = `SUBEXPR_FALSE'
		if (nodei.type == `OPERATOR') {
			if (__sub_expr_right_opc_LT_opp(node,nodei)) {
				expr = expr + "("
				closep = `SUBEXPR_TRUE'
			}
		}
		if (rc=traverse_expr_node(node.arg[2],expr)) {
			return(rc)
		}
		if (closep) {
			expr = expr + ")"
		}
		return(rc)
	}
	if (node.type == `TSOP') {
		if (rc=TS_op_node(node,pC,pE)) {
			return(rc)
		}
		if (pE != NULL) {
			/* add ts operator as a string expression	*/
			expr = expr + node.symb
		}
		if (ustrlen(expr)) {
			/* add current string expression                */
			if (rc=add_strexpression(expr)) {
				pC = NULL
				return(rc)
			}
		}
		expr = ""
		if (pE == NULL) {
			pE = &__sub_expr_elem(1)
			pE->set_dataobj(m_data)
			rc = pE->set_component(pC)
		}
		pE->add_property(`SUBEXPR_PROP_TS_OP')
		if (!rc) {
			rc = add_object(pE)
		}
		type = pE->type()
		if (order=_sub_expr_TS_order(node.symb,tsop)) {
			/* tsop always upper case			*/
			if (type == `SUBEXPR_GROUP') {
				/* TS_op_node() checks for L. only	*/
				if (order > 1) {
					m_data->set_errmsg("only 1-period " +
						"lag operator, {bf:L.} or " +
						"{bf:L1.}, is supported with " +
						"named expressions")
					return(498)
				}
				set_TS_order(order,`TS_EXPR_LORDER')
				(void)pE->update(order,`TS_LORDER')
			}
			else if (tsop=="L" | tsop=="D") {
				set_TS_order(order,`TS_LORDER')
			}
			else if (tsop == "F") {
				set_TS_order(order,`TS_FORDER')
			}
			else {
				m_data->set_errmsg(sprintf("invalid linear " +
					"combination {bf:%s}; {bf:%s} " +
					"time-series operator not allowed",
					expression(),tsop))
				return(198)
			}
			if (all(key():==pE->key())) {
				/* recursive; TS operator on an expression
				 * requires an additional expression to
				 * initialize the series		*/
				(void)update(`SUBEXPR_TRUE', ///
					`SUBEXPR_HINT_TSINIT_REQ')
			}
		}

		pC = NULL
		pE = NULL

		return(rc)
	}
	if (node.type == `FACTOROP') {
		/* check that the factor does not expand to more
		 *  than 1 variable					*/
		if (rc=factor_op_node(node,pC)) {
			return(rc)
		}
		expr = expr + node.symb
		/* add current string expression			*/
		if (rc=add_strexpression(expr)) {
			pC = NULL
			return(rc)
		}
		expr = ""
		pE = &__sub_expr_elem(1)
		pE->set_dataobj(m_data)
		if (!(rc=pE->set_component(pC))) {
			rc = add_object(pE)
		}
		pC = NULL
		pE = NULL
		return(rc)
	}
	if (node.type == `FUNCTION') {
		expr = expr + node.symb
		/* traverse arglist					*/
		rc = traverse_expr_node(node.arg[1],expr)

		return(rc)
	}
	if ((node.type==`ARGLIST') | (node.type==`VECTOR') |
		(node.type==`MATRIX')) {
		expr = expr + "("
		for (i=1; i<=node.narg; i++) {
 			if (rc=traverse_expr_node(node.arg[i],expr)) {
				break
			}
			if (i < node.narg) {
				if (node.type == `MATRIX') {
					expr = expr + "\"
				}
				else {
					expr = expr + ","
				}
			}
		}
		expr = expr + ")"

		return(rc)
	}
	sym = node.symb
	type = `SUBEXPR_NULL'
	if (node.type == `SYMBOL') {
		if (sym == "_cons") {
			m_data->set_errmsg(sprintf("specified reserved word " +
				"{bf:_cons} in expression {bf:%s}; this is " +
				"not allowed",name()))
			return(198)
		}
		else if (sym == "_pi") {	// other built-in constants?
			expr = expr + sym
			return(rc)
		}
		else if (__sub_expr_isvariable(sym)) {	// unabbreviate
			group = `SUBEXPR_VAR_GROUP'
			type = `SUBEXPR_VARIABLE'
			node.symb = sym
		}
		else if (st_matrix(sym) == J(0,0,.)) {
			if (sym == `SUBEXPR_YHAT') {
				m_data->set_errmsg(sprintf("invalid " +
					"expression {bf:%s}: symbol {bf:%s} " +
					"is a reserved word",expression(),sym))
				return(198)
			}
			/* add to string expression			*/
			expr = expr + node.symb
			return(0)
		}
		else {
			group = `SUBEXPR_MAT_GROUP'
			type = `SUBEXPR_MATRIX'
		}
		if (strlen(expr)) {
			/* add current string expression		*/
			if (rc=add_strexpression(expr)) {
				return(rc)
			}
			expr = ""
		}
		rc = m_data->register_component(sym,group,type,pC)
		if (!rc) {
			/* not a LV covariate				*/
			pE = &__sub_expr_elem(1)
			pE->set_dataobj(m_data)
			rc = pE->set_component(pC)
			if (type ==`SUBEXPR_MATRIX') {
				/* Stata matrix name substitutable
				 *  tempname 				*/
				(void)pC->update(sym,`SUBEXPR_HINT_TNAME')
			}
			rc = add_object(pE)
		}
		pC = NULL
		pE = NULL
		return(rc)
	}
	if (node.type == `SUBEXPR') {
		if (strlen(expr)) {
			/* add current string expression		*/
			if (rc=add_strexpression(expr)) {
				return(rc)
			}
			expr = ""
		}
		index = node.val
		if (!missing(index)) {
			/* have instance number, linear combination
			 *  already parsed				*/
			key = (`SUBEXPR_GROUP_SYMBOL',sym)
			pC = m_data->lookup_component(key)
			if (pC == NULL) {
				/* create place holder for group object
				 *  traversing pruned trees from another
				 *  __sub_expr object and group tree has
				 *  not been traversed yet		*/
				gtype = `SUBEXPR_GROUP_LC'
				/* must be a LC since a linear form can
				 *  be broken up into multiple LC's	*/
				if (rc=m_data->register_group(sym,pG,gtype)) {
					m_data->set_errmsg(sprintf("failed " +
						"to find instance %g of " +
						"{bf:%s}; parsing cannot " +
						"continue",index,sym))
					return(499)
				}
				pC = pG->component()
				/* set instance for future reference	*/
				pG->set_instance(node.val)
				pG = NULL
			}
			else if (key[2] != sym) {
				/* Bayes added / to name		*/
				key[2] = sym
				node.symb = sym
			}
			type = pC->type()
			if (type != `SUBEXPR_GROUP') {
				/* programmer error			*/
				m_data->set_errmsg(sprintf("invalid object " +
					"{bf:%s}: expected a substitutable " +
					"expression but got %s",sym,
					pC->stype()))
				pC = NULL
				return(499)
			}
			pCG = pC
			pC = NULL
			gtype = pCG->group_type()
			if (gtype != `SUBEXPR_GROUP_LC') {
				/* programmer error: has to be a LC because
				 *  linear form can be broken up into 
				 *  multiple LC's			*/
				m_data->set_errmsg(sprintf("invalid object " +
					"{bf:%s}: expected a linear " +
					"combination but got %s",sym,
					pCG->sgroup_type()))
				pCG = NULL
				return(499)
			}
			kg = pCG->group_count()
			for (i=1; i<=kg; i++) {
				pG = pCG->get_object(i)
				if (pG->instance() == index) {
					break
				}
				pG = NULL
			}
			pCG = NULL		
			if (pG == NULL) {
				/* programmer error			*/
				m_data->set_errmsg(sprintf("failed to find " +
					"instance %g of {bf:%s:}; parsing " +
					"cannot continue",index,sym))
				rc = 499
			}
			if (!rc) {
				rc = add_object(pG)
			}
			pG =  NULL
			return(rc)
		}
		gtype = `SUBEXPR_UNDEFINED'
		if (rc=m_data->register_group(sym,pG,gtype)) { 
			pG = NULL	// should still be NULL
			return(rc)
		}
		gtype = pG->group_type()
		/* allow a parameter group: resolve_expressions() will
		 * throw an error if the reference is ambiguous		*/
		if (gtype!=`SUBEXPR_UNDEFINED' &
			gtype!=`SUBEXPR_GROUP_EXPRESSION' & 
			gtype!=`SUBEXPR_GROUP_LC' & 
			gtype!=`SUBEXPR_GROUP_PARAM') {
			m_data->set_errmsg(sprintf("invalid object {bf:%s}: " +
				"the expression references a %s when a " +
				"named expression or linear combination is " +
				"expected",name(),pG->sgroup_type()))
			pG = NULL
			return(498)
		}
		if (!rc) {
			rc = add_object(pG)
		}
		pG = NULL
		return(rc)
	}
	group = ""
	pG = NULL
	if (node.type == `PARGROUP') {
		group = node.symb
		if (rc=m_data->register_group(group,pG,`SUBEXPR_GROUP_PARAM')) {
			return(rc)
		}
		node = node.arg[1]
	}
	if (node.type == `PARAMETER') {
		/* includes matrix parameters				*/
		if (strlen(expr)) {
			/* add current string expression		*/
			if (rc=add_strexpression(expr)) {
				return(rc)
			}
			expr = ""
		}
		pE = &__sub_expr_elem(1)
		pE->set_dataobj(m_data)
		pE->set_groupobj(&this)
		lvsym = __sub_expr_isLVsymbol(sym)
		if (lvsym) {
			if (node.narg == 1) {
				/* LV@#					*/
				lvsym = (node.arg[1].type==`ATOP')
			}
		}
		if (lvsym) {
			/* latent variable shortcut: no path		*/
			node.type = `LATENTVAR'
			if (rc=pE->traverse_LV(node,existed)) {
				return(rc)
			}
			if (existed) {
				pC = pE->component()
				covariate = pC->data(`SUBEXPR_HINT_COVARIATE')
				if (ustrlen(covariate)) {
					m_data->set_errmsg(sprintf("random " +
						"slope {bf:%s} is not " +
						"consistently specified for " +
						"%s {bf:%s}; this is not " +
						"allowed",covariate,
						m_data->LATENT_VARIABLE,sym))
					rc = 198
				}
			}
		}
		else if (!(rc=pE->traverse_param(node,group))) {
			if (pG != NULL) {
				/* could be referencing a LC parameter
				 *  see ::post_resolve()		*/
				pE->set_info(`SUBEXPR_PARAM')
				rc = pG->add_object(pE)
				pE = pG
			}
		}
		if (!rc) {
			rc = add_object(pE)
		}
		pG = NULL
		pE = NULL
		return(rc)
	}
	else if (node.type == `LVPARAM') {
		if (ustrlen(expr)) {
			if (rc=add_strexpression(expr)) {
				return(rc)
			}
			expr = ""
		}
		covariate = ""
		rc = LV_param_node(node.arg[1],covariate)

		return(rc)
	}
	/* add to string expression					*/
	if (node.type == `CONSTANT') {
		/* potential loss of precision, default format %9.0g	*/
		expr = expr + strofreal(node.val)
	}
	else {
		expr = expr + node.symb
	}
	return(rc)
}

real scalar __sub_expr_group::factor_op_node(struct nlparse_node scalar node,
		pointer (class __component_base) scalar pC)
{
	real scalar i, k, noisily, rc, type
	string scalar sym, touse, group
	string vector factors, vars
	string matrix lvars

	pragma unset factors
	pragma unset vars
	pragma unset lvars

	pC = NULL
	rc = 0
	if (node.type != `FACTOROP') {
		/* programmer error					*/
		m_data->set_errmsg(sprintf("expected a factor operator, " +
			"but got a %s parse node",pt_stype(node.type)))
		return(498)
	}
	sym = node.arg[1].symb
	if (!__sub_expr_isvariable(sym)) {
		m_data->set_errmsg(sprintf("invalid specification " +
			"{bf:%s%s}: variable {bf:%s} not found",
			node.symb,sym,sym))
		return(111)
	}
	if (node.symb == "c.") {
		/* _lvexpand will strip c.; need to retain		*/
		node.arg[1].symb = sym	// unabbreviated
	}
	else {
		sym = node.symb + sym
		touse = touse()
		noisily = `SUBEXPR_FALSE'
		if (rc=_lvexpand(sym,touse,noisily,factors,vars,lvars)) {
			m_data->set_errmsg(sprintf("could not expand " +
				"variable {bf:%s}",sym))
			return(rc)
		}
		else if ((k=length(vars)) > 1) {
			m_data->set_errmsg(sprintf("factor variable " +
				"{bf:%s} expands to %g indicator " +
				"variables; this is not allowed in " +
				"a nonlinear expression",sym,k))
			return(450)
		}
		if (sym != vars[1]) {
			/* unabbreviated			*/
				i = ustrpos(vars[1],".")
				k = ustrlen(vars[1])-i
				node.symb = usubstr(vars[1],1,i)
				sym = usubstr(vars[1],++i,k)
				node.arg[1].symb = sym
		}
		else {
			sym = node.arg[1].symb
		}
	}
	group = `SUBEXPR_VAR_GROUP'
	type = `SUBEXPR_VARIABLE'
	rc = m_data->register_component(sym,group,type,pC)

	return(rc)
}

real scalar __sub_expr_group::TS_op_node(struct nlparse_node scalar node,
		pointer (class __component_base) scalar pC,
		|pointer (class __sub_expr_elem) scalar pE)
{
	real scalar rc, type, yhat
	string scalar sym, group, op
	
	pE = NULL
	pC = NULL
	if (node.type != `TSOP') {
		/* programmer error					*/
		m_data->set_errmsg(sprintf("expected a time-series operator, " +
			"but got a %s parse node",pt_stype(node.type)))
		return(498)
	}
	sym = node.arg[1].symb
	rc = 0
	yhat = `SUBEXPR_FALSE'
	if (node.arg[1].type==`SYMBOL' & sym==`SUBEXPR_YHAT') {
		/* synonym for {depvar:} named expression		*/
		pE = eqobj()
		if (pE == NULL) {
			m_data->set_errmsg(sprintf("invalid expression " + 
				"{bf:%s%s}: dependent variable not found",
				node.symb,sym))
			return(111)
		}
		node.arg[1].type = `SUBEXPR'
		sym = pE->name()
		node.arg[1].symb = sym
		yhat = `SUBEXPR_TRUE'
		pE = NULL
	}
	if (node.arg[1].type == `SUBEXPR') {
		/* lagged substitutable expression			*/
		op = ustrleft(node.symb,1)
		if (strupper(op) != "L") {
			m_data->set_errmsg("only 1-period lag operator, " +
				"{bf:L.} or {bf:L1.}, is supported with " +
				"named expressions")
			return(198)
		}
		group = `SUBEXPR_GROUP_SYMBOL'
		pC = m_data->lookup_component((group,sym))
		if (pC == NULL) {
			/* assumption: not an equation name		*/
			type = `SUBEXPR_UNDEFINED' // LC or expression
			if (!(rc=m_data->register_group(sym,pE,type))) {
				pC = pE->component()
			}
		}
		else {
			type = pC->data(`SUBEXPR_HINT_GROUP_TYPE')
			if (type==`SUBEXPR_EQ_LC' |
				type==`SUBEXPR_EQ_EXPRESSION') {
				pE = m_data->new_group();
			}
			else if (type==`SUBEXPR_GROUP_LC' |
				type==`SUBEXPR_GROUP_EXPRESSION') {
				pE = m_data->new_group()
			}
			else {
				if (yhat) {
					sym = `SUBEXPR_YHAT'
				}
				else {
					sym = sprintf("{%s:}",sym)
				}
				m_data->set_errmsg(sprintf("invalid " +
					"specification {bf:%s%s}: " +
					"time-series operator not allowed",
					node.symb,sym))
				pC = NULL
				return(198)
			}
			pE->set_dataobj(m_data)
			(void)pE->set_component(pC)
		}
		/* TS op on object pE, allow recursive execution when
		 *  eval_status() == SUBEXPR_EVAL_EXPR, substitute
		 *  tempname						*/
		pE->add_property(`SUBEXPR_PROP_TS_OP')
	}
	else {
		if (!__sub_expr_isvariable(sym)) {	// unabbrev
			m_data->set_errmsg(sprintf("invalid specification " +
				"{bf:%s%s}: variable {bf:%s} not found",
				node.symb,sym,sym))
			return(111)
		}
		node.arg[1].symb = sym
		group = `SUBEXPR_VAR_GROUP'
		type = `SUBEXPR_VARIABLE'
		sym = node.symb+sym
		if (!(rc=m_data->register_component(sym,group,type,pC))) {
			(void)pC->update(node.symb,`SUBEXPR_HIT_OPERATOR')
		}
	}
	return(rc)
}

real scalar __sub_expr_group::LV_param_node(struct nlparse_node scalar node,
		string scalar covariate)
{
	real scalar rc, type
	string scalar covariate1, lv, sym, msg, group
	pointer (class __component_base) scalar pC
	pointer (class __sub_expr_elem) scalar pE

	pragma unset pC

// pt_dump_node(node)
	rc = 0
	sym = node.symb
	if (node.type == `OPERATOR') {
		if (sym != "#") {
			/* should not happen				*/
			m_data->set_errmsg(sprintf("expected a {bf:#} " +
				"operator but got a {bf:%s}",sym))
			return(498)
		}
		if (rc=LV_param_node(node.arg[1],covariate)) {
			return(rc)
		}
		if (node.arg[2].type != `LATENTVAR') {
			if (node.arg[2].type == `SYMBOL') {
				if (!__sub_expr_isLVsymbol(node.arg[2].symb)) {
					/* LV shortcut			*/
					covariate = covariate + sym
				}
			}
			else {
				covariate = covariate + sym
			}
		}
		if (rc=LV_param_node(node.arg[2],covariate)) {
			return(rc)
		}
	}
	else if (node.type == `TSOP') {
		/* TS op on a LV covariate				*/
		if (rc=TS_op_node(node,pC)) {
			return(rc)
		}
		// covariate = covariate + sym + node.arg[1].symb
		covariate = covariate + pC->name()
	}
	else if (node.type == `FACTOROP') {
		if (rc=factor_op_node(node,pC)) {
			return(rc)
		}
		covariate = covariate + node.symb + node.arg[1].symb
	}
	else if (node.type == `SYMBOL') {
		if (__sub_expr_isLVsymbol(sym)) {
			node.type = `LATENTVAR'
		}
		else if (sym == "_cons") {
			m_data->set_errmsg(sprintf("specified reserved word " +
				"{bf:_cons} in expression {bf:%s}; this is " +
				"not allowed",name()))
			return(198)
		}
		else if (!__sub_expr_isvariable(sym)) {	// unabbreviate
			m_data->set_errmsg(sprintf("variable {bf:%s} not " +
				"found",sym))
			return(111)
		}
		else {
			group = `SUBEXPR_VAR_GROUP'
			type = `SUBEXPR_VARIABLE'
			node.symb = sym
			covariate = covariate + sym
			rc = m_data->register_component(sym,group,type,pC)
		}
	}
	if (node.type == `LATENTVAR') {
		/* done traversing the `LVPARAM' subtree
		 *  LV is always the far-right branch			*/
		pE = &__sub_expr_elem(1)
		pE->set_dataobj(m_data)
		/* set the group object so the elem object can create
		 *  a LV scaling parameter				*/
		pE->set_groupobj(&this)
		if (!(rc=pE->traverse_LV(node))) {
			rc = add_object(pE)
		}
		if (rc) {
			pE = NULL
			return(rc)
		}
		if (ustrlen(covariate)) {
			/* put covariate interactions in consistent
			 *  order					*/
			covariate = __sub_expr_fixup_covariate(covariate)
		}
		pC = pE->component()
		sym = pC->name()
		if (pC->refcount() > 1) {
			covariate1 = pC->data(`SUBEXPR_HINT_COVARIATE')
			if (covariate1 != covariate) {
				if (!ustrlen(covariate1)) {
					msg = sprintf("{bf:%s} is ",covariate)
				}
				else if (!ustrlen(covariate)) {
					msg = sprintf("{bf:%s} is ",
						covariate1)
				}
				else {
					msg = sprintf("{bf:%s} and {bf:%s} " +
						"are",covariate1,covariate)
				}
				rc = 198
				lv = m_data->LATENT_VARIABLE
				m_data->set_errmsg(sprintf("random " +
					"slope covariate %s not consistently " +
					"specified for %s {bf:%s}",msg,lv,sym))
				pC = NULL
				pE = NULL
				return(rc)
			}
		}
		if (strlen(covariate)) {
			(void)pC->update(covariate,`SUBEXPR_HINT_COVARIATE')
		}
		pE = NULL
	}
	pC = NULL
	
	return(rc)
}

real scalar __sub_expr_group::traverse_LC_tree(struct nlparse_node tree)
{
	real scalar i, narg, rc, hasxb, var1, type, kv
	real vector kvar
	string scalar msg
	string vector key
	pointer (class __component_base) scalar pC

	rc = 0
	kvar = (0,0,0)
	narg = tree.narg
	type = tree.type
	if (narg == 0) {
		rc = 499
	}
	if (type != `LINCOM') {
		rc = 499
	}
	if (rc) {
		m_data->set_errmsg(sprintf("invalid linear combination " +
			"specification: expected a linear combination " +
			"but got a %s",pt_stype(type)))
		return(499)
	}
	key = (`SUBEXPR_GROUP_SYMBOL',tree.arg[1].symb)
	pC = m_data->lookup_component(key)
	if (pC != NULL) {
		/* Bayes does multiple parse/resolve's which can result
		 *  in a group marked as a parameter group during
		 *  parsing stage. e.g. /name:				*/
		tree.arg[1].symb = pC->name()
	}
	pC = NULL
	if (tree.arg[1].symb != name()) {
		if (group_type() == `SUBEXPR_EQ_LC') {
			msg = "dependent variable"
		}
		else {
			msg = "expression name"
		}
		m_data->set_errmsg(sprintf("invalid linear combination " +
			"specification: expected %s {bf:%s}, but got {bf:%s}",
			msg,name(),tree.arg[1].symb))

		return(111)
	}
	if (rc=validate_options(("xb","noconstant"),(2,6))) {
		return(rc)
	}
	m_ptree = tree
// pt_display()
	if (has_option("noconstant",6)) {
		m_hascons = `SUBEXPR_FALSE'
	}
	else {
		m_hascons = `SUBEXPR_MAYBE'
	}
	for (i=2; i<=narg; i++) {
 		if (rc=traverse_LC_node(m_ptree.arg[i],kvar)) {
			return(rc)
		}
	}
	hasxb = has_option("xb")
	if (group_type() == `SUBEXPR_GROUP_LC') {
		/* currently only the LC needs an instance ID because 
		 *  a linear form can be broken up into multiple LC's	*/
		/* set the instance ID in the tree in case we reuse
		 *  the tree, e.g. prune LV's and estimate NULL model	*/
		m_ptree.arg[1].val = instance()

		kv = max((kvar[`KVAR'],kvar[`KFAC']))
		var1 = ((kv==1 & !kvar[`KLAT']) | (!kv & kvar[`KLAT']==1))
		var1 = (var1 & (m_hascons<`SUBEXPR_TRUE'))
		if (var1 & !hasxb) {
			/* parameter varname or 
			 * c.varname1#c.varname2 or LV[path]		*/
			m_data->set_errmsg(sprintf("invalid expression " +
				"{bf:%s:%s}; option {bf:xb} required",name(),
				m_expression))
			return(119)	// out-of-context error
		}
	}
	if (m_hascons == `SUBEXPR_MAYBE') {
		m_hascons = `SUBEXPR_TRUE'
	}
	if (m_hascons) {
		if (!kvar[`KVAR'] & !kvar[`KLAT'] & !hasxb) {
			m_data->set_errmsg("option {bf:xb} required")
			return(119)	// out-of-context error
		}
		if (kvar[`KVAR']==1 & kvar[`KLAT']==0 & !hasxb) {
			/* traverse_expr() canonical form, xb implied	*/
			set_options((options(),"xb"))
		}	
		else if (kvar[`KVAR']==0 & kvar[`KLAT']==1 & !hasxb) {
			/* traverse_expr() canonical form, xb implied	*/
			set_options((options(),"xb"))
		}
		rc = add_constant()
	}
	return(rc)
}

real scalar __sub_expr_group::traverse_LC_node(struct nlparse_node scalar node,
		real vector kvar)
{
	real scalar i, rc, nooutput, existed, tssetoff
	real scalar kfac, kv, kl
	string scalar sym, vlist, covariate
	string vector vars
	string matrix lvars
	pointer (class __component_base) scalar pC
	pointer (class __sub_expr_elem) scalar pE

	pragma unset vars
	pragma unset lvars
	pragma unset vlist
	pragma unset pC
	pragma unset existed
	pragma unset kfac
	pragma unset kv

// ::pt_display(node)
	rc = 0
	tssetoff = `SUBEXPR_FALSE'
	if (node.type == `TSOP') {
		nooutput = `SUBEXPR_TRUE'
		rc = _stata("tsset",nooutput)
		if (rc == 111) {
			/* data not tsset; assumption: tsset after
			 *  resolving expressions			*/
			tssetoff = `SUBEXPR_TRUE'
		}
		rc = traverse_LC_param(node,kfac,tssetoff)
		kvar[`KVAR'] = kvar[`KVAR'] + 1
	}
	else if (node.type == `FACTOROP') {
		rc = traverse_LC_param(node,kfac)
		kvar[`KVAR'] = kvar[`KVAR'] + 1
		kvar[`KFAC'] = kvar[`KFAC'] + kfac
	}
	else if (node.type == `SYMBOL') {
		sym = node.symb
		if (__sub_expr_isLVsymbol(sym)) {
			pE = &__sub_expr_elem(1)
			pE->set_dataobj(m_data)
			pE->set_groupobj(&this)
			node.type = `LATENTVAR'
			rc = pE->traverse_LV(node,existed)
			if (!rc) {
				rc = add_object(pE)
			}
			if (existed & !rc) {
				pC = pE->component()
				covariate = pC->data(`SUBEXPR_HINT_COVARIATE')
				if (ustrlen(covariate)) {
					m_data->set_errmsg(sprintf("random " +
						"slope {bf:%s} is not " +
						"consistently specified for " +
						"%s {bf:%s}; this is not " +
						"allowed",covariate,
						m_data->LATENT_VARIABLE,sym))
					rc = 198
				}
			}
			pE = NULL
			pC = NULL
			kvar[`KLAT'] = kvar[`KLAT'] + 1
		}
		else if (sym == "_cons") {
			if (m_hascons == `SUBEXPR_FALSE') {
				m_data->set_errmsg("specified {bf:_cons} " +
					"with option {bf:noconstant}; this " +
					"is not allowed")
				rc = 198
			}
			if (m_hascons == `SUBEXPR_TRUE') {
				m_data->set_errmsg(sprintf("{bf:_cons} " +
					"specified more than once in " +
					"expression for {bf:{%s:}}",name()))
				rc = 198
			}
			m_hascons = `SUBEXPR_TRUE'
		}
		else {	// variable
			kv = 1
			if (ustrpos(node.symb,"*")) {
				rc = traverse_LC_param_WC(node,kv)
			}
			else {
				rc = traverse_LC_param(node,kfac)
			}
			kvar[`KVAR'] = kvar[`KVAR'] + kv
		}
	}
	else if (node.type == `LATENTVAR') {
		pE = &__sub_expr_elem(1)
		pE->set_dataobj(m_data)
		pE->set_groupobj(&this)
		if (!(rc=pE->traverse_LV(node))) {
			rc = add_object(pE);
		}
		pE = NULL
		kvar[`KLAT'] = kvar[`KLAT'] + 1
	}
	else if (node.type == `OPERATOR') {
		if (rc=traverse_LC_operator(node,vlist)) {
			m_data->set_errmsg(sprintf("invalid linear " +
				"combination {bf:%s}: %s",name(),
				m_data->errmsg()))
			return(rc)
		}
		/* expands (...)#(...) and ## operations		*/
		if (rc=__sub_expr_lvparse(vlist,vars,lvars)) {
			m_data->set_errmsg(sprintf("invalid linear " +
				"combination {bf:%s}",vlist))
			return(rc)
		}
		kv = length(vars)
		kl = cols(lvars)
		if (kv) {
			for (i=1; i<=kv; i++) {
				if (rc=add_LC_param(vars[i],kfac)) {
					return(rc)
				}
				kvar[`KFAC'] = kvar[`KFAC'] + kfac
			}
			kvar[`KVAR'] = kvar[`KVAR'] + kv
		}
		if (kl) {
			for (i=1; i<=kl; i++) {
				if (rc=add_LC_latentvar(lvars[.,i])) {
					return(rc)
				}
			}
			kvar[`KLAT'] = kvar[`KLAT'] + kl
		}
	}
	else if (node.type == `VARLIST') {
		for (i=1; i<=node.narg; i++) {
			if (rc=traverse_LC_node(node.arg[i],kvar)) {
				break
			}
		}
	}
	else {
		m_data->set_errmsg(sprintf("invalid linear " +
			"combination specification: %s not allowed",
			pt_stype(node.type)))
		rc = 198
	}
	return(rc)
}

real scalar __sub_expr_group::traverse_LC_operator(
		struct nlparse_node scalar node, string scalar lexpr)
{
	real scalar i, rc, existed, type
	string scalar var, vlist, path, group
	pointer (struct nlparse_node) scalar nodei
	pointer (class __component_base) scalar pC
	pointer (class __sub_expr_elem) scalar pE

	pragma unset existed
	pragma unset pC

	if (node.type == `OPERATOR') {
		if (node.symb!="#" & node.symb!="##") {
			m_data->set_errmsg(sprintf("invalid operator {bf:%s}",
				node.symb))
			return(198)
		}
	}
	else if (node.type != `VARLIST') {
		/* programmer error					*/
		m_data->set_errmsg(sprintf("expected a factor operator or " +				"variable list but got a %s", 
			pt_string_type(node.type)))
		return(198)
	}
	for (i=1; i<=node.narg; i++) {
		nodei = &node.arg[i]
// pt_dump_node(*nodei)
		if (nodei->type == `OPERATOR') {
			vlist = ""
			if (rc=traverse_LC_operator(*nodei,vlist)) {
				nodei = NULL
				return(rc)
			}
		}
		else if (nodei->type == `VARLIST') {
			vlist = ""
			if (rc=traverse_LC_operator(*nodei,vlist)) {
				nodei = NULL
				return(rc)
			}
			vlist = "("+vlist+")"
		}
		else if (nodei->type == `SYMBOL') {
			var = nodei->symb
			if (__sub_expr_isLVsymbol(var)) {
				/* latent variable shortcut: no path	*/
				group = `SUBEXPR_LV_GROUP'
				type = `SUBEXPR_LV'
			}
			else if (!__sub_expr_isvariable(var)) {
				m_data->set_errmsg(sprintf("variable {bf:%s} " +
					"not found",var))
				rc = 111
				break
			}
			else {
				group = `SUBEXPR_VAR_GROUP'
				type = `SUBEXPR_VARIABLE'
			}
			if (rc=m_data->register_component(var,group,type,pC,
				existed))  {
				break
			}
			if (type == `SUBEXPR_VARIABLE') {
				nodei->symb = var 	// unabbreviated
			}
			if (existed) {
				if (type == `SUBEXPR_LV') {
					path = pC->data(`SUBEXPR_HINT_PATH')
					if (ustrlen(path)) {
						var = sprintf("%s[%s]",var,path)
					}
					/* else update path from future
					 *  specification		*/ 
				}
			}
			vlist = var
			pC = NULL
		}
		else if (nodei->type == `LATENTVAR') {
			pE = &__sub_expr_elem(1)
			pE->set_dataobj(m_data)
			/* need to set the group object so we can
			 *  create LV scaling parameters		*/
			pE->set_groupobj(&this)
			if (rc=pE->traverse_LV(*nodei)) {
				pE = NULL
				break
			}
			pC = pE->component()
			path = pC->data(`SUBEXPR_HINT_PATH')
			var = sprintf("%s[%s]",pC->name(),path)
			vlist = var
			pE = NULL
			pC = NULL
		}
		else if (nodei->type==`FACTOROP' | nodei->type==`TSOP') {
			group = `SUBEXPR_VAR_GROUP'
			type = `SUBEXPR_VARIABLE'
			var = nodei->arg[1].symb
			if (!__sub_expr_isvariable(var)) {
				m_data->set_errmsg(sprintf("variable {bf:%s} " +
					"not found",var))
				rc = 111
				break
			}
			if (rc=m_data->register_component(var,group,type,pC,
				existed)) {
				return(rc)
			}
			nodei->arg[1].symb = var	// unabbreviated
			pC = NULL
			var = nodei->symb + var
			vlist = var
		}
		else {
			m_data->set_errmsg(sprintf("expected a variable or " +
				"%s but got a %s",m_data->LATENT_VARIABLE,
				pt_string_type(nodei->type)))
			rc = 498
			break
		}
		if (!strlen(lexpr)) {
			lexpr = vlist
		}
		else if (node.type == `OPERATOR') {
			lexpr = lexpr + node.symb + vlist
		}
		else if (node.type == `VARLIST') {
			lexpr = lexpr + " " + vlist
		}
	}
	nodei = NULL

	return(rc)
}

real scalar __sub_expr_group::traverse_LC_param_WC(
		struct nlparse_node scalar node, real scalar kvar)
{
	real scalar rc, i, noisily, kfac
	string scalar sym, touse
	string vector vars, factors
	string matrix lvars
	pointer (class __component_base) scalar pC

	pragma unset kfac
	pragma unset vars
	pragma unset factors
	pragma unset lvars
	pragma unset pC

	rc = 0
	kvar = 0
	if (node.type != `SYMBOL') {
		/* programmer error					*/
		m_data->set_errmsg(sprintf("invalid linear combination " +
			"specification {bf:%s}: invalid symbol {bf:%s}",
			name(),node.symb))
		return(198)
	}
	sym = node.symb
	touse = touse()
	noisily = `SUBEXPR_FALSE'
	if (rc=_lvexpand(sym,touse,noisily,factors,vars,lvars)) {
		m_data->set_errmsg(sprintf("could not expand wild card " +
			"variable {bf:%s}",sym))
		return(rc)
	}
	kvar = length(vars)
	for (i=1; i<=kvar; i++) {
		sym = node.symb = vars[i]	// unabbreviated
		/* add variable to list of variables (not parameter)	*/
		if (rc=m_data->register_component(sym,`SUBEXPR_VAR_GROUP',
			`SUBEXPR_VARIABLE',pC)) {
			return(rc)
		}
		pC = NULL
		/* now add parameter					*/
		rc = add_LC_param(sym,kfac)
	}
	return(rc)
}

real scalar __sub_expr_group::traverse_LC_param(struct nlparse_node scalar node,
			real scalar kfac, |real scalar tssetoff)
{
	real scalar rc, nocheck, order
	string scalar sym, tsop
	pointer (class __component_base) scalar pC

	pragma unset pC
	pragma unset tsop

	tssetoff = (missing(tssetoff)?`SUBEXPR_FALSE':
			(tssetoff!=`SUBEXPR_FALSE'))
// pt_dump_node(node)
	if (node.type==`TSOP') {
		sym = node.arg[1].symb
		if (node.arg[1].type == `SUBEXPR') {
			m_data->set_errmsg(sprintf("invalid linear " +
				"combination specification {bf:%s}; " +
				"{bf:%s{c 123}%s:{c 125}} not allowed",
				name(),node.symb,sym))
			return(198)
		}
	}
	else if (node.type==`FACTOROP') {
		sym = node.arg[1].symb
	}
	else if (node.type == `SYMBOL') {
		sym = node.symb
	}
	else {
		m_data->set_errmsg(sprintf("invalid linear combination " +
			"specification {bf:%s}: invalid symbol {bf:%s}",
			name(),node.symb))
		return(198)
	}
	if (!__sub_expr_isvariable(sym)) {	// unabbreviate
		m_data->set_errmsg(sprintf("invalid linear combination " +
			"specification {bf:%s}: variable {bf:%s} not found",
			name(),sym)) 

		return(111)
	}
	if (st_isstrvar(sym)) {
		m_data->set_errmsg(sprintf("invalid linear combination " +
			"specification {bf:%s}: string variable {bf:%s} not " +
			"allowed",name(),sym)) 
		return(109)
	}
	/* add variable to list of variables (not parameter)		*/
	if (rc=m_data->register_component(sym,`SUBEXPR_VAR_GROUP',
		`SUBEXPR_VARIABLE',pC)) {
		return(rc)
	}
	pC = NULL
	nocheck = `SUBEXPR_FALSE'
	if (node.type == `FACTOROP') {
		node.arg[1].symb = sym
		sym = node.symb + sym
	}
	else if (node.type == `TSOP') {
		if (order=_sub_expr_TS_order(node.symb,tsop)) {
			if (tsop=="L" | tsop=="D") {
				set_TS_order(order,`TS_LORDER')
			}
			else if (tsop == "F") {
				set_TS_order(order,`TS_FORDER')
			}
			else {
				m_data->set_errmsg(sprintf("invalid linear " +
					"combination {bf:%s}; {bf:%s} " +
					"time-series operator not allowed",
					expression(),tsop))
				return(198)
			}
		}
		/* do not check variable; may not tsset yet		*/
		node.arg[1].symb = sym
		sym = node.symb + sym
		nocheck = tssetoff
	}
	else if (node.type == `SYMBOL') {
		node.symb = sym
	}
	/* now add parameter						*/
	rc = add_LC_param(sym,kfac,nocheck)

	return(rc)
}

real scalar __sub_expr_group::add_LC_param(string scalar symbol,
			real scalar kfac, |real scalar nocheck)
{
	real scalar k, rc, noisily, type, val, existed
	string scalar group, touse, name
	string vector factors, vars
	string matrix lvars
	pointer (class __component_base) scalar pC
	pointer (class __sub_expr_elem) scalar pE

	pragma unset factors
	pragma unset vars
	pragma unset lvars
	pragma unset existed

	kfac = 0
	nocheck = (missing(nocheck)?`SUBEXPR_FALSE':(nocheck!=`SUBEXPR_FALSE'))
	group = name()
	/* recognizes FV variables and unabbreviates			*/
	if (!nocheck) {
		if (!__sub_expr_isvariable(symbol)) {
			m_data->set_errmsg(sprintf("invalid linear " +
				"combination specification {bf:%s}: " +
				"variable {bf:%s} not found",group,symbol))
			return(111)
		}
		if (__sub_expr_isstrvar(symbol)) {
			m_data->set_errmsg(sprintf("invalid linear " +
				"combination specification {bf:%s}; string " +
				"variable {bf:%s} not allowed",group,symbol))
			return(198)
		}
		touse = touse()		// incomplete estimation sample
		noisily = `SUBEXPR_FALSE'
		if (rc=_lvexpand(symbol,touse,noisily,factors,vars,lvars)) {
			m_data->set_errmsg(sprintf("could not expand " +
				"variable {bf:%s}",symbol))
			return(rc)
		}
	}
	else {
		vars = symbol
	}
	k = cols(vars)
	if (k == 1) {
		name = vars[1]
		if (length(factors)) {
			type = `SUBEXPR_FV_PARAM'
		}
		else {
			type = `SUBEXPR_LC_PARAM'
		}
	}
	else {
		kfac = k
		name = symbol
		type = `SUBEXPR_FV'
	}
	pC = NULL
	if (rc=m_data->register_component(name,group,type,pC,existed)) {
		pC = NULL	// should still be NULL
		return(rc)
	}
	pE = &__sub_expr_elem(1)
	pE->set_dataobj(m_data)
	if (!(rc=pE->set_component(pC))) {
		rc = add_object(pE)
	}
	if (!existed & type!=`SUBEXPR_FV') {
		val = m_data->param_default_value()
		(void)pC->update(val,`SUBEXPR_HINT_VALUE')
	}
	/* expand factor variables at expression resolve stage when all
	 *  expression variables and estimation sample are known	*/
	pE = NULL
	pC = NULL

	return(rc)
}

real scalar __sub_expr_group::add_LC_latentvar(string vector lvar)
{
	real scalar rc, k
	string scalar covariate, covariate1
	string vector tokens
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __component_base) scalar pC
	pointer (class __lvpath) scalar path0, path
	transmorphic te

	te = tokeninit("",("[","]"))
	tokenset(te,lvar[1])
	tokens = tokengetall(te)
	if (length(tokens) != 4) {
		/* programmer error					*/
		m_data->set_errmsg(sprintf("invalid %s specification {bf:%s}",
			m_data->LATENT_VARIABLE,lvar[1]))
		rc = 498
		goto Exit
	}
	path = &__lvpath(1)
	if (rc=path->init(tokens[1],tokens[3])) {
		m_data->set_errmsg(sprintf("invalid %s path {bf:%s}: %s",
			m_data->LATENT_VARIABLE,tokens[3],path->errmsg()))
		goto Exit
	}
	pC = m_data->lookup_component((`SUBEXPR_LV_GROUP',tokens[1]))
	if (pC == NULL) {
		/* should exist from ::traverse_LC_operator()		*/
		m_data->set_errmsg("%s {bf:%s} not found",
			m_data->LATENT_VARIABLE, lvar[1])
		rc = 111
		goto Exit
	}
	pE = &__sub_expr_elem(1)
	pE->set_dataobj(m_data)
	if (!(rc=pE->set_component(pC))) {
		rc = add_object(pE)
	}
	pE = NULL
	if (rc) {
		goto Exit
		return(rc)
	}
	covariate = covariate1 = ""
	if ((k=pC->refcount()) > 1) {
		covariate = pC->data(`SUBEXPR_HINT_COVARIATE')
		path0 = pC->data(`SUBEXPR_HINT_PATH_TREE')
	}
	if (path0 != NULL) {
		if (!path0->isequal(*path)) {
			m_data->set_errmsg(sprintf("inconsistent paths for " +
				"%s {bf:%s}: {bf:%s} and {bf:%s}",
				m_data->LATENT_VARIABLE,pC->name(),
				path0->path(),path->path()))
			rc = 498
			goto Exit
		}
	}
	else if (rc=pC->update(path,`SUBEXPR_HINT_PATH_TREE')) {
		m_data->set_errmsg(sprintf("failed to set %s {bf:%s} path " +
			"{bf:%s}",m_data->LATENT_VARIABLE,pC->name(),
			path->path()))
		rc = 498
		goto Exit
	}
	if (ustrlen(lvar[2])) {
		covariate1 = __sub_expr_fixup_covariate(lvar[2])
		if (k>1) {
			if (covariate != covariate1) {
				if (!ustrlen(covariate)) {
					covariate = sprintf("{bf:%s} is",
						covariate1)
				}
				else if (!ustrlen(lvar[2])) {
					covariate = sprintf("{bf:%s} is",
						covariate)
				}
				else {
					covariate = sprintf("{bf:%s} and " +
						"{bf:%s} are",covariate,
						covariate1)
				}
				rc = 198
			}
		}
		if (!rc) {
			(void)pC->update(covariate1,`SUBEXPR_HINT_COVARIATE')
		}
	}
	else if (ustrlen(covariate)) {
		covariate = sprintf("{bf:%s} is",covariate)
	}
	if (rc) {
		m_data->set_errmsg(sprintf("random slope covariate %s not " +
			"consistently specified for %s {bf:%s}",covariate,
			m_data->LATENT_VARIABLE,pC->name()))
	}
	Exit:
	pC = NULL
	pE = NULL
	path = NULL

	return(rc)
}

real scalar __sub_expr_group::add_constant()
{
	real scalar gtype, rc, val, existed
	pointer (class __component_base) scalar pC
	pointer (class __sub_expr_elem) scalar pE

	pragma unset existed

	rc = 0
	if ((gtype=group_type()) == `SUBEXPR_GROUP_EXPRESSION') {
		m_data->set_errmsg(sprintf("attempting to add a constant to " +
				"a %s object {bf:%s}",sgroup_type(),name()))
		return(119)	// out-of-context error
	}
	pC = NULL
	if (gtype == `SUBEXPR_GROUP_PARAM') {
		rc = m_data->register_component("_cons",name(),`SUBEXPR_PARAM',
				pC,existed)
	}
	else {	// LC and EQ_LC
		rc = m_data->register_component("_cons",name(),
				`SUBEXPR_LC_PARAM',pC,existed)
	}
	if (!rc) {
		pE = &__sub_expr_elem(1)
		pE->set_dataobj(m_data)
		if (!(rc=pE->set_component(pC))) {
			rc = add_object(pE)
		}
		if (!existed) {
			val = m_data->param_default_value()
			rc = pC->update(val,`SUBEXPR_HINT_VALUE')
		}
	}
	pC = NULL
	pE = NULL

	return(rc)
}

real scalar __sub_expr_group::add_object(
			pointer (class __sub_expr_elem) scalar pE)
{
	real scalar rc, iscons
	pointer (class __sub_expr_elem) scalar last

	rc = 0
	if (!m_kexpr) {
		m_first = m_last = pE
		if (pE->prev() == NULL) {
			/* use the address of `this', not `this' itself	*/
			pE->set_prev(&this)
		}
	}
	else {
		last = m_last
		m_last = pE
		last->set_next(m_last)
		m_last->set_prev(last)
	}
	if (!pE->has_property(`SUBEXPR_PROP_TEMPLATE')) {
		pE->set_groupobj(&this)
	}
	if (m_hascons == `SUBEXPR_MAYBE') {
		iscons = (pE->name()=="_cons")
		if (iscons & group_type()==`SUBEXPR_GROUP_LC') {
			m_hascons = `SUBEXPR_TRUE'
		}
	}
	m_kexpr = m_kexpr + 1
	last = NULL

	return(rc)
}

real scalar __sub_expr_group::swap_objects(
			pointer (class __sub_expr_elem) scalar pEold,
			pointer (class __sub_expr_elem) scalar pEnew)
{
	real scalar rc, notemplate
	pointer (class __sub_expr_elem) scalar last, pEp, pEn

	/* called by __sub_expr::register_equation(); have a recursive
	 *  equation but the lagged named expression with the same name
	 *  was parsed first in another expression
	 *  swap out the named expression for the equation object	*/
	rc = 0
	notemplate = `SUBEXPR_TRUE'
	last = first(notemplate)
	if (last == pEold) {
		m_first = pEnew
	}
	while (last != NULL) {
		if (last == pEold) {
			pEp = pEold->prev()
			pEn = pEold->next()
			pEp->set_next(pEnew)
			pEn->set_prev(pEnew)
			pEnew->set_next(pEn)
			pEnew->set_prev(pEp)
			pEold->set_next(NULL)
			pEold->set_prev(NULL)
			break
		}
		last = last->next()
	}
	if (last == NULL) {
		/* programmer error					*/
		m_data->set_errmsg(sprintf("failed to swap object {bf:%s} in " +
			"expression {bf:%s}",pEold->name(),name()))
		rc = 498
	}
	else if (last() == pEold) {
		m_last = pEnew
	}
	if (!rc) {
		pEold->set_groupobj(NULL)
		pEnew->set_groupobj(&this)
	}
	last = NULL

	return(rc)
}

real scalar __sub_expr_group::add_strexpression(string scalar expression)
{
	real scalar rc

	pointer (class __sub_expr_expr) scalar pSE

	if (!strlen(expression)) {
		return(0)
	}
	pSE = &__sub_expr_expr(1)
	pSE->set_expression(expression)

	rc = add_object(pSE)
	pSE = NULL

	return(rc)
}

real scalar __sub_expr_group::expand_FVs()
{
	real scalar i, k, fc, rc, nooutput, val
	string scalar touse, name, group, cmd
	string vector vars
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __component_base) scalar pC
	pointer (class __component_param) scalar pFV

	pragma unset pC

	nooutput = `SUBEXPR_TRUE'
	rc = 0
	touse = touse()
	group = name()
	pE = first()
	while (pE != NULL) {
		if (pE->type() != `SUBEXPR_FV') {
			goto Next
		}
		pFV = pE->component()
		fc  = pFV->fv_count()
		if (fc > 0) {
			/* already expanded: factor variable referenced 
			 *  multiple times, or Bayes multiple parse/resolve
			 *  cycles					*/
			goto Next
		}
		name = pE->name()
		cmd = sprintf("fvexpand %s if %s",name,touse)
		if (rc=_stata(cmd,nooutput)) {
			m_data->set_errmsg(sprintf("could not expand " +
				"variable {bf:%s}",name))
			break
		}
		vars = tokens(st_global("r(varlist)"))
		k = cols(vars)
		val = m_data->param_default_value()

		for (i=1; i<=k; i++) {
			if (rc=m_data->register_component(vars[i],group,
				`SUBEXPR_FV_PARAM',pC)) {
				break
			}
			if (rc=pFV->update(pC,`SUBEXPR_HINT_FV')) {
				break
			}
			(void)pC->update(val,`SUBEXPR_HINT_VALUE')
		}
		pC = NULL

		Next: pE = pE->next()
	}
	pE = NULL
	pFV = NULL
	pC = NULL
	return(rc)
}

real scalar __sub_expr_group::isdefined()
{
	if (m_first==NULL | m_last==NULL) {
		return(`SUBEXPR_FALSE')
	}
	return(`SUBEXPR_TRUE')
}

real scalar __sub_expr_group::kexpr()
{
	return(m_kexpr)
}

real scalar __sub_expr_group::hascons()
{
	return(m_hascons)
}

pointer (class __sub_expr_elem) scalar __sub_expr_group::clone(
			|pointer (class __sub_expr_elem) scalar pE)
{
	real scalar type, cpyprop
	pointer (class __component_base) scalar pC
	pointer (class __sub_expr_group) scalar pSE, pSE1
	pointer (class __sub_expr_elem) scalar pE1, pEc

	if (pE == NULL) {
		/* create new group object				*/
		pSE = pE = m_data->new_group()

		pC = component()
		pSE->set_dataobj(m_data)
		(void)pSE->set_component(pC)
		(void)pSE->set_expression(expression())
		(void)pC->update(pSE,`SUBEXPR_HINT_DATAOBJ')
		/* new object, copy properties				*/
		cpyprop = `SUBEXPR_TRUE'
	}
	else {
		type = pE->type()
		if (type != `SUBEXPR_GROUP') {
			/* programmer error, terminate			*/
			errprintf("{p}attempting to clone the contents of %s " +
				"object %s into a %s object %s:%s{p_end}\n",
				sgroup_type(),name(),pE->stype(),pE->group(),
				pE->name())
			exit(498)
		}
		/* assumption: this and pE have the same component
		 *  clone() is for copying this expression		*/
		pSE = pE

		/* existing object from parse, do not copy properties	*/
		cpyprop = `SUBEXPR_FALSE'
	}
	/* assumption: object does not have an defined expression,
	 * 	i.e. first() and last() are NULL			*/
	if (pSE->first() != NULL) {
		/* programmer error					*/
		errprintf("{p}attempting to create a clone of {bf:%s} to " +
			"an object that is already in an expression: this " +
			"is not allowed{p_end}\n",name())
		exit(498)
	}
	pSE->unlink()
	pSE->set_state(m_state)
	pSE1 = &this
	if (pSE->groupobj() == pSE1) {
		if (!sum(TS_order())) {
			/* programmer error: recursive expression
			 *  without a TS op				*/
			errprintf("{p}expression {bf:%s} is recursive " +
				"without any time-series operators: this is " +
				"not allowed{p_end}",name())
			exit(498)
		}
		/* exclude expression: when it evaluates it will simply
		 *  return the same tempvar name of this expression for
		 *   TS operation					*/
	}
	else if (m_kexpr) {
		/* clone contents					*/
		pEc = m_first
		while (pEc != NULL) {
			pE1 = pEc->clone()
			(void)pSE->add_object(pE1)
			pE1 = NULL
			pEc = pEc->next()
		}
		pE1 = NULL
	}
	pSE->set_options(options())
	pSE->set_hascons(m_hascons)
	pSE->set_parse_tree(m_ptree)
	pSE->set_TS_order(TS_order())
	if (cpyprop) {
		pSE->set_properties(properties())
	}
	return(pSE)
}

string scalar __sub_expr_group::options_string(real scalar which)
{
	real scalar i, k, type, check
	string scalar sp, expr

	expr = ""
	if (!(k=has_options())) {
		return(expr)
	}
	check = `SUBEXPR_FALSE'
	if (which == `SUBEXPR_DISPLAY') {
		sp = ", "
		/* variable or variable + _cons				*/
		check = (m_kexpr==1 | m_kexpr==2)
		if (check) {
			type = m_first->type()
			check = (type == `SUBEXPR_FV')
		}
	}
	else {
		sp = ","
	}
	for (i=1; i<=k; i++) {
		if (check & m_options[k]=="xb") {
			continue
		}	
		expr = expr + sp + m_options[i]
		sp = " "
	}
	return(expr)
}

string scalar __sub_expr_group::traverse_expr(real scalar which,
			|real scalar top)
{
	real scalar gtype;

	gtype = group_type()
	if (gtype==`SUBEXPR_EQ_LC' | gtype==`SUBEXPR_EQ_EXPRESSION') {
		if (has_property(`SUBEXPR_PROP_TS_INIT')) {
			return(_traverse_expr(which,top))
		}
		return(_traverse_eq(which,top))
	}
	else {
		return(_traverse_expr(which,top))
	}
}

string scalar __sub_expr_group::_traverse_expr(real scalar which, 
				|real scalar top)
{
	real scalar gtype, which1, unique, notemplate
	string scalar expr, sp, sp1, name
	pointer (class __sub_expr_elem) scalar cur
	pointer (class __component_group) scalar pG

	gtype = group_type()
	top = (missing(top)?`SUBEXPR_FALSE':(top!=`SUBEXPR_FALSE'))
	which = which1 = (missing(which)?`SUBEXPR_FULL':which)
	if (top) {
		which1 = `SUBEXPR_FULL'
	}
	notemplate = `SUBEXPR_TRUE'
	cur = first(notemplate)
	if (cur != NULL) {
		if (cur->has_property(`SUBEXPR_PROP_TEMPLATE')) {
			expr = cur->traverse_expr(which,top)
			return(expr)
		}
	}
	if (gtype == `SUBEXPR_GROUP_LC') {
		pG = component()
		unique = `SUBEXPR_TRUE'
		if (pG->group_count(unique) > 1) {
			if (pG->state() != state()) {
				/* does not share state object with	*/
				/* group component; does not have all	*/
				/* LC variables				*/
				which1 = `SUBEXPR_FULL'
			}
		}
		pG = NULL
	}
	if (which == `SUBEXPR_SUBSTITUTED') {
		expr = subexpr()
		if (ustrpos(expr,"+")) {
			expr = sprintf("(%s)",expr)
		}
		else if (ustrpos(expr,"-")) {
			expr = sprintf("(%s)",expr)
		}
	}
	else {
		name = name()
		if (gtype==`SUBEXPR_GROUP_PARAM' | gtype==`SUBEXPR_GROUP_LC') {
			if (usubstr(name,1,1)=="/") {
				/* syntax does not allow 
				 * {/<name>:<param>}			*/
				name = ustrright(name,ustrlen(name)-1)
			}
		}
		if (which!=`SUBEXPR_DISPLAY' | !top) {
			expr = "{" + name + ":"
		}
		if (which1==`SUBEXPR_FULL' | (which==`SUBEXPR_DISPLAY'&top)) {
			sp = ""
			while (cur != NULL) {
				sp1 = ""
				if (gtype==`SUBEXPR_GROUP_LC' |
					gtype==`SUBEXPR_EQ_LC') {
					/* canonical form excludes 
					 *  constant, option xb added
					 *  at parse-time if needed	*/
					if (cur->name() != "_cons") {
						sp1 = sp
						expr = expr + sp1 + 
						   cur->traverse_expr(which)
					}
				}
				else {
					expr = expr + sp1 + 
						cur->traverse_expr(which)
				}
				cur = cur->next()
				sp = " "
			}
			if (has_options()) {
				expr = expr + options_string(which)
			}
		}
		else if (gtype == `SUBEXPR_GROUP_PARAM') {
			if (m_first != NULL) {
				expr = expr + m_first->traverse_expr(which)
			}
		}
		else if (gtype==`SUBEXPR_GROUP_LC' | gtype==`SUBEXPR_EQ_LC') {
			if (coefref()) {
				/* referencing parameter of LC		*/
				expr = expr + m_first->name()
			}
		}
		if (which!=`SUBEXPR_DISPLAY' | !top) {
			expr = expr + "}"
		}
	}
	return(expr)
}

string scalar __sub_expr_group::_traverse_eq(real scalar which, 
			|real scalar top)
{
	real scalar gtype, k, cons
	string scalar expr, lc, sp
	pointer (class __sub_expr_elem) scalar cur

	gtype = group_type()
	if (first() == NULL) {
		/* lagged equation variable in expression		*/
		return(_traverse_expr(which))
	}
	top = `SUBEXPR_TRUE'
	if (gtype == `SUBEXPR_EQ_EXPRESSION') {
		/* bypass this: y = expression				*/
		expr = ""
		cur = first()
		while (cur != NULL) {
			expr = expr + cur->traverse_expr(which)
			cur = cur->next()
		}
		return(expr)
	}
	else if (which == `SUBEXPR_SUBSTITUTED') {
		return(_traverse_expr(which,top))
	}
	else if (gtype == `SUBEXPR_EQ_LC') {
		/* traverse linear form 				*/
		expr = ""
		sp = ""
		k = 0
		cons = `SUBEXPR_FALSE'
		cur = m_first
		while (cur != NULL) {
			lc = cur->traverse_expr(which)
			if (lc == "_cons") {
				cons = `SUBEXPR_TRUE'
			}
			else {
				k++
				expr = expr + sp + lc
			}
			cur = cur->next()
			sp = " "
		}
		if (cons == `SUBEXPR_TRUE') {
			if (k <= 1) {
				expr = expr + ",xb" 
			}
		}
		else {
			expr = expr + ",noconstant" 
		}
		return(expr)
	}
	/* include this: depvar varlist [ parmlist ]			*/
	return(_traverse_expr(which,top))
}

string scalar __sub_expr_group::expression()
{
	return(super.expression())
}

void __sub_expr_group::mark_dirty()
{
	/* could be a shared state object or unique to this group	*/
	m_state->estate = `SUBEXPR_EVAL_DIRTY'
}

real scalar __sub_expr_group::mark_dirty_contained(string vector marked)
{
	real scalar k, type, gtype
	string scalar name
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __sub_expr_group) scalar pSE

	name = name()
	if (k=__sub_expr_name_index(name,marked)) {
		mark_dirty()
		return(k)
	}
	pE = first()
	while (pE != NULL) {
		type = pE->type()
		if (type!=`SUBEXPR_GROUP' & 
			type!=`SUBEXPR_MATRIX') {
			pE = pE->next()
			continue
		}
		name = pE->name()
		if (k=__sub_expr_name_index(name,marked)) {
			mark_dirty()
			marked = (marked,name())
			pE = NULL
			return(k)
		}
		if (type == `SUBEXPR_GROUP') {
			pSE = pE
			gtype = pSE->group_type()
			/* named expression can reference other 
			 * expressions					*/
			if (gtype == `SUBEXPR_GROUP_EXPRESSION') {
				if (k=pSE->mark_dirty_contained(marked)) {
					mark_dirty()
					marked = (marked,name())
					pE = NULL
					pSE = NULL
					return(k)
				}
			}
			pSE = NULL
		}
		pE = pE->next()
	}
	return(0)
}

real scalar __sub_expr_group::_evaluate(string scalar expr, |transmorphic extra)
{
	real scalar rc, gtype, nooutput, eval, oinit, tsinitreq
	real scalar has_panel, trace, mxord, m, notemplate
	real vector order
	string scalar expri, tname, tname0, expr0, eq
	string scalar tsvar, panelvar, byy, msg
	pointer (class __sub_expr_elem) scalar pE, pE1, pInit
	pointer (class __component_group) scalar pG

	pragma unset expri
	pragma unset tname0

	expr = ""
	gtype = group_type()
	if (gtype==`SUBEXPR_GROUP_PARAM' | coefref()) {
		/* nothing to evaluate, parameter reference		*/
		pE = first()
		rc = pE->_evaluate(expr)
		pE = NULL
		return(rc)
	}
	if (gtype == `SUBEXPR_GROUP_LC' | gtype==`SUBEXPR_EQ_LC') {
		timer_on(2)
		rc = _evaluate_LC(expr)
		timer_off(2)
		return(rc)
	}
	/* `SUBEXPR_GROUP_EXPRESSION' 					*/
	if (m_state->estate == `SUBEXPR_EVAL_CLEAN') {
		/* already evaluated					*/
		expr = subexpr()
		return(0)
	}
	tname = tempname()
	pE1 = eqobj()
	if (pE1 != NULL) {
		eq = pE1->name()
	}
	notemplate = `SUBEXPR_TRUE'
	pG = component()
	pE = first(notemplate)
	expr = ""
	tsinitreq = pG->TS_init_req()
	if (tsinitreq) {
		pInit = pG->TS_initobj()
	}
	else {
		pInit = NULL
	}
	
	if (pE == NULL) {
		/* recursive TS operation within an expression or
		 *  equation						*/
		if (pInit != NULL) { 
			/* TS initializing expression will be executed
			 *  by parent expression or equation		*/
			expr = tname
			return(0)
		}
		/* programmer error: fail below				*/
	}
	else if (pE->has_property(`SUBEXPR_PROP_TEMPLATE') & 
		all(pE->key():==key())) {
		rc = pE->_evaluate(expr)
		return(rc)
	}
	if (pG->eval_status() == `SUBEXPR_EVAL_EXPR') {
		if (has_property(`SUBEXPR_PROP_TS_OP')) {
			/* referenced in an expression as a lagged
			 *  variable; recursion ok			*/
			if (pInit == NULL) {
				m_data->set_errmsg(sprintf("could not " +
					"evaluate expression {bf:%s}: " +
					"recursive call detected",name()))
				m_data->error_code(`SUBEXPR_ERROR_RECURSIVE')
				return(111)
			}	
			expr = tname
			return(0)
		}
		if (pE1 != NULL) {
			m_data->set_errmsg(sprintf("failed to evaluate " +
				"equation {bf:%s} at {bf:%s}: evidently " +
				"the %s is recursive",pE1->name(),name(),
				sgroup_type()))
		}
		else {
			m_data->set_errmsg(sprintf("failed to evaluate " +
				"{bf:%s}: evidently the %s is recursive",
				name(),sgroup_type()))
		}
		return(481)	// not identified
	}
	pG->set_eval_status(`SUBEXPR_EVAL_EXPR')
	trace=m_data->trace()
`TRACE'
	if (trace) {
		oinit = (0,0,0)
		if (args()==2) {
			if (isreal(extra)) {
				/* initialize TS expression		*/
				oinit = extra
			}
		}
		if (sum(oinit)) {
			printf("\n{txt}{p 0 8 2}initial substitution: " +
				"{res}%s = %s{p_end}\n",name(),
				traverse_expr(`SUBEXPR_DISPLAY',`SUBEXPR_TRUE'))
		}
		else {
			printf("\n{txt}{p 0 8 2}substitution: {res}%s = %s" +
				"{p_end}\n",name(),
				traverse_expr(`SUBEXPR_DISPLAY',`SUBEXPR_TRUE'))
		}
	}
	while (pE != NULL) {
		if (pE1 != NULL) {
			rc = pE->_evaluate(expri,eq)
		}
		else {
			rc = pE->_evaluate(expri)
		}
		if (rc) {
			pE = NULL
			pE1 = NULL
			pG->set_eval_status(`SUBEXPR_EVAL_IDLE')
			return(rc)
		}
		expr = expr + expri
		pE = pE->next()
	}
	pE1 = NULL
	eval = `SUBEXPR_TRUE'
	expr0 = expr
	order = oinit = (0,0,0)
	mxord = 0
	has_panel = `SUBEXPR_FALSE'
	if (m_state->lhstype == `SUBEXPR_EVAL_VECTOR') {
		order = TS_order()	// (#l,#f)
		mxord = max(order)
		panelvar = m_data->stata_panelvar()
		tsvar = m_data->stata_tsvar()
		has_panel = (ustrlen(panelvar)>0)

		if (mxord & !ustrlen(tsvar)) {
			m_data->set_errmsg(sprintf("%s {bf:%s} is poorly " +
				"specified: maximum time-series order is %g " +
				"but no time variable is set",sgroup_type(),
				name(),mxord))
			pG->set_eval_status(`SUBEXPR_EVAL_IDLE')
			return(498)
		}
		if (mxord) {
			if (pInit == NULL) { 
				if (tsinitreq) {
					/* TS is a on an expression and
					 *  requires another expression
					 *  to initialize it		*/
					m_data->set_errmsg(sprintf(
						"%s {bf:%s} is poorly " +
						"specified: time-series " +
						"initialization expression " +
						"not found",sgroup_type(),
						name()))
					m_data->error_code(
						`SUBEXPR_ERROR_TSINIT')
					pG->set_eval_status(`SUBEXPR_EVAL_IDLE')
					return(111)
				}
			}
			else if (tsinitreq) {
				pG->set_eval_status(`SUBEXPR_EVAL_INIT')
				if (rc=pInit->_evaluate(tname0,order)) {
					/* initialize TS series for L.
					 *  or D. operators on a named
					 *  expression			*/
					pG->set_eval_status(`SUBEXPR_EVAL_IDLE')
					return(rc)
				}
			}
			pG->set_eval_status(`SUBEXPR_EVAL_EXPR')
		}
		else if (args() == 2) {
			if (isreal(extra)) {
				/* initialize TS expression		*/
				oinit = extra
			}
		}
	}
	while (eval) {
		/* Stata evaluated expression				*/
		if (m_state->lhstype==`SUBEXPR_EVAL_SCALAR' |
			m_state->lhstype==`SUBEXPR_EVAL_NULL') {
			expr = sprintf("scalar %s = %s",tname,expr0)
			m_state->lhstype = `SUBEXPR_EVAL_SCALAR'
		}
		else if (m_state->lhstype == `SUBEXPR_EVAL_MATRIX') {
			expr = sprintf("matrix %s = %s",tname,expr0)
		}
		else if (m_state->lhstype == `SUBEXPR_EVAL_VECTOR') {
			byy = ""
			if (mxord) {
				if (has_panel) {
					byy = sprintf("by %s (%s):",panelvar,
						tsvar)
				}
			}
			else if (max(oinit)) {
				/* initialize TS expression		*/
				if (missing(_st_varindex(tname))) {
					expr = sprintf("qui gen double " +
						"%s = 0 if %s",tname,touse())
				}
				else {
					expr = sprintf("qui replace %s = 0 " +
						"if %s",tname,touse())
				}
				nooutput = `SUBEXPR_TRUE'
				(void)_stata(expr,nooutput)

				if (has_panel) {
					byy = sprintf("by %s (%s):",panelvar,
						tsvar)
				}
			}
			if (missing(_st_varindex(tname))) {
				msg = "gen double"
			}
			else {
				msg = "replace"
			}
			expr = sprintf("qui %s %s %s = %s if %s",byy,msg,
				tname,expr0,touse())
		}
		else {
			/* expression does not evaluate to anything	*/
			m_data->set_errmsg(sprintf("expression {bf:%s} is " +
				"poorly specified",name()))
			pG->set_eval_status(`SUBEXPR_EVAL_IDLE')
			return(498)
		}
		if (trace) {
			if (sum(oinit)) {
				msg = "initial "
			}
			else {
				msg = ""
			}
			printf("\n{txt}{p 0 8 2}%sevaluation %s: {res}%s%s " +
				"= %s if %s{p_end}\n",msg,name(),byy,tname,
				expr0,touse())
		}
		/* do not display Stata output, it will involve
		 *  tempnames						*/
		nooutput = (trace?`SUBEXPR_FALSE':`SUBEXPR_TRUE')
		rc = _stata(expr,nooutput)
		if (rc) {
			if (m_state->lhstype == `SUBEXPR_EVAL_SCALAR') {
				m_state->lhstype = `SUBEXPR_EVAL_MATRIX'
				rc = 0	// try again
			}
			else if (m_state->lhstype == `SUBEXPR_EVAL_MATRIX') {
				m_state->lhstype = `SUBEXPR_EVAL_VECTOR'
				rc = 0 	// try again
			}
			if (rc) {
				m_data->set_errmsg(sprintf("failed to " +
					"evaluate expression {bf:%s}",name()))
				/* original user expression before
				 *  parsing				*/
				m_data->set_message(expression())
				m_data->error_code(
					`SUBEXPR_ERROR_EXECUTION_FAILURE',
					name(),sgroup_type())
				pG->set_eval_status(`SUBEXPR_EVAL_IDLE')
				return(rc)
			}
		}
		else {
			eval = `SUBEXPR_FALSE'
		}
	}
	expr = tname
	m_state->estate = `SUBEXPR_EVAL_CLEAN'
	if (trace) {
		if (m_state->lhstype == `SUBEXPR_EVAL_VECTOR') {
			m_n = sum(st_data(.,touse()))
			m = min((m_n,20))
			if (strlen(panelvar)) {
				(void)_stata(sprintf("list %s %s %s %s in " +
					"1/%g, sepby(%s)",panelvar,tsvar,tname,
					touse(),m,panelvar))
			}
			else {
				(void)_stata(sprintf("list %s %s in 1/%g",tname,
					touse(),m))
			}
		}
		else {
			(void)_stata(sprintf("di %s",tname))
		}
	}
	pG->set_eval_status(`SUBEXPR_EVAL_IDLE')

	return(0)
}

real scalar __sub_expr_group::compose_LC_eval()
{
	real scalar trace, type, kfv, i
	string scalar expr, expri, plus, eq, vari
	pointer (class __component_base) scalar pC
	pointer (class __sub_expr_elem) scalar pE, pE1
	pointer (class __component_param) vector pFV

	pragma unset expri

	trace = (m_data->trace()==`SUBEXPR_ON')
`TRACE'
	if (trace) {
		printf("\n{txt}{p 0 8 2}substitution: {res}%s = %s{p_end}\n",
			name(),traverse_expr(`SUBEXPR_DISPLAY',`SUBEXPR_TRUE'))
	}
	expr = plus = ""
	pE = first()
	while (pE!=NULL) {
		pC = pE->component()
		type = pC->type()
		if (type == `SUBEXPR_LV') {
			pE1 = eqobj()
			if (pE1 != NULL) {
				eq = pE1->name()
				expri = pC->data(`SUBEXPR_HINT_SUBEXPR',eq)
			}
			else {
				expri = pC->data(`SUBEXPR_HINT_SUBEXPR')
			}
			expr = expr + plus + expri
			plus = "+"
		}
		else {
			kfv = 1
			if (type == `SUBEXPR_FV') {
				pFV = pC->data(`SUBEXPR_HINT_FV')
				kfv = length(pFV)
			}
			for (i=1; i<=kfv; i++) {
				if (type == `SUBEXPR_FV') {
					pC = pFV[i]
					pFV[i] = NULL
				}
				vari = pC->name()
				expri = pC->data(`SUBEXPR_HINT_SUBEXPR')
				if (vari == "_cons") {
					expr = expr + plus + expri
				}
				else {
					expr = expr + plus + vari + "*" + expri
				}
				plus = "+"
			}
		}
		pE = pE->next()
	}
	m_LCexpr = expr
	m_n = sum(st_data(.,touse()))
	m_eready = `SUBEXPR_TRUE'

	return(0)
}

real scalar __sub_expr_group::_evaluate_LC(string scalar expr)
{
	real scalar nooutput, rc, trace, gtype, m
	string scalar tvar, cmd, gen, expr0, panelvar, tsvar
	pointer (class __component_group) scalar pG

	gtype = group_type()
	if (gtype!=`SUBEXPR_GROUP_LC' & gtype!=`SUBEXPR_EQ_LC') {
		/* programmer error					*/
		m_data->set_errmsg(sprintf("%s object {bf:%s} cannot be " +
			"evaluated as a linear combination",sgroup_type(),
			name()))
		return(498)
	}
	if (m_state->estate == `SUBEXPR_EVAL_CLEAN') {
		/* already evaluated					*/
		expr = subexpr()
		return(0)
	}
	tvar = tempname()
	if (coefref()) {
		/* referencing param of LC, _00000x[1,icoef]		*/
		expr = tvar
		return(0)
	}
	pG = component()
	pG->set_eval_status(`SUBEXPR_EVAL_EXPR')
	if (!m_eready) {
		/* compose evaluate information				*/
		if (rc=compose_LC_eval()) {
			pG->set_eval_status(`SUBEXPR_EVAL_IDLE')
			return(rc)
		}
	}
	nooutput = `SUBEXPR_TRUE'
	if (missing(_st_varindex(tvar))) {
		gen = "gen double"
	}
	else {
		gen = "replace"
	}
	expr0 = sprintf("qui %s %s = %s if %s",gen,tvar,m_LCexpr,touse())

	trace = (m_data->trace()==`SUBEXPR_ON')
`TRACE'
	if (trace) {
		printf("\n{txt}{p 0 8 2}evaluation %s: {res}%s{p_end}\n",
				name(),expr0)
	}
	if (rc=_stata(expr0,nooutput)) {
		m_data->set_errmsg(sprintf("failed to evaluate linear " +
			"combination {bf:%s}",name()))
		/* original user expression before parsing	*/
		m_data->set_message(expression())
		pG->set_eval_status(`SUBEXPR_EVAL_IDLE')
		return(rc)
	}
		
	m_state->subexpr = expr = tvar
	m_state->estate = `SUBEXPR_EVAL_CLEAN'

	if (trace) {
		cmd = "list"
		panelvar = m_data->stata_panelvar()
		if (ustrlen(panelvar)) {
			cmd = sprintf("%s %s",cmd,panelvar)
		}
		tsvar = m_data->stata_tsvar()
		if (ustrlen(tsvar)) {
			cmd = sprintf("%s %s",cmd,tsvar)
		}
		m = min((m_n,20))
		cmd = sprintf("%s %s %s in 1/%g",cmd,tvar,touse(),m)
		if (ustrlen(panelvar)) {
			cmd = sprintf("%s, sepby(%s)",cmd,panelvar)
		}
		nooutput = `SUBEXPR_FALSE'
		(void)_stata(cmd,nooutput)
	}
	pG->set_eval_status(`SUBEXPR_EVAL_IDLE')

	return(0)
}

/* group is resolved, assess and set any necessary flags
 *  called by __sub_expr::resolve_expressions()				*/
real scalar __sub_expr_group::post_resolve()
{
	real scalar gtype

	gtype = group_type()
	if (gtype==`SUBEXPR_EQ_LC' | gtype==`SUBEXPR_EQ_EXPRESSION') {		
		return(post_resolve_eq())
	}
	else {
		return(post_resolve_expr())
	}
}

real scalar __sub_expr_group::post_resolve_expr()
{
	real scalar type, gtype, lhstype1, req
	class __tempnames scalar tn
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG

	gtype = group_type()
	pE = NULL
	pC = NULL
	m_eready = `SUBEXPR_FALSE'	// flag for ::compose_LC_eval()
	if (has_property(`SUBEXPR_PROP_TS_OP')) {
		m_state->lhstype = `SUBEXPR_EVAL_VECTOR'
	}
	else {
		req = data(`SUBEXPR_HINT_TSINIT_REQ')
		if (req == `SUBEXPR_TRUE') {
			m_state->lhstype = `SUBEXPR_EVAL_VECTOR'
		}
	}
	if (gtype == `SUBEXPR_GROUP_LC') {
		if (m_kexpr==1 & !has_option("xb")) {
			/* could be a single FV that expands to > 1
			 *  indicator variables				*/
			pE = first()
			if (pE->info() == `SUBEXPR_PARAM') {
				/* referencing param of LC		*/
				m_coefref = `SUBEXPR_TRUE'
				/* use the component state object	*/
				pC = pE->component()
				set_state(pC->state())

				pC = NULL
				pE = NULL
				m_hascons = `SUBEXPR_FALSE'
				return(0)
			}
			pE = NULL
		}
		if (m_hascons == `SUBEXPR_MAYBE') {
			if (has_option("noconstant")) {
				m_hascons = `SUBEXPR_FALSE'
			}
			else {
				m_hascons = `SUBEXPR_TRUE'
			}
		}
                if (!ustrlen(m_state->tname)) {
                        m_state->tname = m_data->new_tempname(tn.VARIABLE)
                }
                m_state->lhstype = `SUBEXPR_EVAL_VECTOR'
	}
	else if (gtype == `SUBEXPR_GROUP_PARAM') {
		pE = first()
		pC = pE->component()
		/* use the component state object			*/
		set_state(pC->state())
		pC = NULL
		pE = NULL
		m_state->lhstype = `SUBEXPR_EVAL_SCALAR'
		m_hascons = `SUBEXPR_FALSE'
	}
	else if (gtype==`SUBEXPR_GROUP_EXPRESSION') {
		/* lhstype may not be properly set. ::post_resolve()
		 *  is not called in dependency order			*/
		if (m_state == NULL) {
			/* should not happen				*/
			pC = component()
			/* use the component state object		*/
			set_state(pC->state())
			pC = NULL
		}
		if (!ustrlen(m_state->tname)) {
			/* temp name not set yet			*/
			m_state->tname = m_data->new_tempname(tn.VARIABLE)
		}
		if (lhstype() != `SUBEXPR_EVAL_NULL') {
			return(0)
		}
		/* guess what the return type will be			*/
		pE = first()
		while (pE != NULL) {
			type = pE->type()
			if (type == `SUBEXPR_EXPRESSION') {
				goto Next
			}
			lhstype1 = pE->lhstype()
			if (m_state->lhstype == `SUBEXPR_EVAL_NULL') {
				m_state->lhstype = lhstype1
			}
			else if (m_state->lhstype==`SUBEXPR_EVAL_SCALAR') {
				if (lhstype1 == `SUBEXPR_EVAL_VECTOR') {
					m_state->lhstype = lhstype1
				}
				if (lhstype1 == `SUBEXPR_EVAL_MATRIX') {
					m_state->lhstype = lhstype1
				}
			}
			else if (m_state->lhstype==`SUBEXPR_EVAL_VECTOR') {
				if (lhstype1 == `SUBEXPR_EVAL_MATRIX') {
					m_state->lhstype = lhstype1
				}
			}
			if (type != `SUBEXPR_GROUP') {
				goto Next
			}
			if (!pE->has_property(`SUBEXPR_PROP_TS_OP')) {
				goto Next
			}
			
			req  = pE->data(`SUBEXPR_HINT_TSINIT_REQ')
			if (req == `SUBEXPR_TRUE') {
                		m_state->lhstype = `SUBEXPR_EVAL_VECTOR'
				goto Next
			}
			pG = pE->component()
			gtype = pG->group_type()
			if (gtype==`SUBEXPR_EQ_LC' | 
				gtype==`SUBEXPR_EQ_EXPRESSION') {
				m_data->set_errmsg(sprintf("invalid %s " +
					"{bf:%s}; the expression may not " +
					"include the lagged %s {bf:%s}",
					sgroup_type(),name(),pG->sgroup_type(),
					pG->name()))
				m_data->error_code(`SUBEXPR_ERROR_LAG_EQ',
					name())
				return(498)
			}
			Next: pE = pE->next()
		}
		m_hascons = `SUBEXPR_FALSE'
	}
	return(0)
}

real scalar __sub_expr_group::post_resolve_eq()
{
	real scalar i, k, type, gtype, found, existed, val
	string scalar eq
	string vector LVs
	class __tempnames scalar tn
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __component_base) scalar pC, pC1

	pragma unset existed

	m_eready = `SUBEXPR_FALSE'	// flag for ::compose_LC_eval()

	gtype = group_type()
	if (gtype == `SUBEXPR_EQ_LC') {
		if (m_hascons == `SUBEXPR_MAYBE') {
			if (has_option("noconstant")) {
				m_hascons = `SUBEXPR_FALSE'
			}
			else {
				m_hascons = `SUBEXPR_TRUE'
			}
		}
	}
	else {
		m_hascons = `SUBEXPR_FALSE'
	}
	if (m_state == NULL) {
		/* should not happen					*/
		pC = component()
		/* use the component state object			*/
		set_state(pC->state())
		pC = NULL
	}
	if (!ustrlen(m_state->tname)) {
		m_state->tname = m_data->new_tempname(tn.VARIABLE)
	}
	m_state->lhstype = `SUBEXPR_EVAL_VECTOR'

	if ((m_data->eq_count()<=1)) {
		/* this is the only equation; don't need scaling
		 *  parameters for latent variables			*/
		return(0)
	}
	/* search for latent variables specified in this equation;
	 *  create scaling parameters					*/
	eq = name()
	val = m_data->param_default_value()
	pE = first()
	while(pE) {
		type = pE->type()
		if (type == `SUBEXPR_LV') {
			LVs = pE->name()
		}
		else if (type == `SUBEXPR_GROUP') {
			LVs = pE->data(`SUBEXPR_HINT_LV_NAMES')
		}
		else {
			goto Next
		}
		if (!(k=length(LVs))) {
			goto Next
		}
		for (i=1; i<=k; i++) {
			found = `SUBEXPR_FALSE'
			if (length(m_LVnames)) {
				found  = any(strmatch(m_LVnames,LVs[i]))
			}
			if (found) {
				goto Next
			}
			m_LVnames = (m_LVnames,LVs[i])
			(void)m_data->register_component(LVs[i],eq,
				`SUBEXPR_LV_PARAM',pC,existed)
			if (existed) {
				goto Next
			}
			/* parameter initial value			*/
			(void)pC->update(val,`SUBEXPR_HINT_VALUE')

			pC1 = m_data->lookup_component((`SUBEXPR_LV_GROUP',
				LVs[i]))
			if (pC1 != NULL) {	// should exist
				(void)pC1->update(pC,`SUBEXPR_HINT_PARAM')
			}
		}
		Next: pE = pE->next()
	}
	return(0)
}

void __sub_expr_group::resolve_TS_order()
{
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __sub_expr_group) scalar pSE
	pointer (class __component_group) scalar pG

	pG = component()
	if (pG->eval_status() == `SUBEXPR_EVAL_TS_ORDER') {
		/* user defined a recursive condition in their 
		 *  expressions: e.g. a->b->a				*/
		pG = NULL
		return
	}
	pG->set_eval_status(`SUBEXPR_EVAL_TS_ORDER')
	pE = first()
	while (pE != NULL) {
		if (pE->type() != `SUBEXPR_GROUP') {
			goto Next
		}
		pSE = pE
		pSE->resolve_TS_order()
		set_TS_order(pSE->TS_order())

		Next: pE = pE->next()
	}
	pG->set_eval_status(`SUBEXPR_EVAL_IDLE')
	pSE = NULL
	pG = NULL
}

real scalar __sub_expr_group::has_component(
			pointer (class __component_base) scalar pC)
{
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __component_base) scalar pC1

	pE = m_first
	while (pE != NULL) {
		pC1 = pE->component()
		if (pC == pC1) {
			pC1 = NULL
			return(`SUBEXPR_TRUE')
		}
		pE = pE->next()
	}
	pC1 = NULL

	return(`SUBEXPR_FALSE')
}

real scalar __sub_expr_group::group_size()
{
	return(m_kexpr)
}

string matrix __sub_expr_group::element_names()
{
	string matrix nlist
	pointer (class __sub_expr_elem) scalar pE

	nlist = J(0,2,"")
	pE = first()
	while (pE != NULL) {
		/* recursion if group?					*/
		if (pE->type() == `SUBEXPR_LV') {
			/* latent variables have no group		*/
			/* components can be shared among groups	*/
			nlist = (nlist\(`SUBEXPR_LV_GROUP',pE->name()))
		}
		else {
			nlist = (nlist\(pE->group(),pE->name()))
		}
		pE = pE->next()
	}
	return(nlist)
}

real scalar __sub_expr_group::markout(real scalar hassample)
{
	real scalar rc, i, markout, nooutput, ivar, k, so, nameonly
	real scalar gtype, markdepvar
	string scalar touse, cmd, panelvar
	string vector vlist
	real colvector tu, tuts, tui, pvar, io, jo
	real vector order, order1, ko
	real matrix pinfo
	pointer (class __sub_expr_group) scalar pSE
	pointer (class __component_group) scalar pG

	pragma unset tuts
	pragma unset pvar

	hassample = `SUBEXPR_FALSE'
	rc = 0
	/* hassample = TRUE: has its own estimation sample
 	 * hassample = FALSE: does not have an estimation sample	*/
	if (type() == `SUBEXPR_GROUP_PARAM') {
		return(rc)
	}
	nooutput = `SUBEXPR_TRUE'
	markout = `SUBEXPR_TRUE'
	touse = touse(markout)
	if (!ustrlen(touse)) {
		return(rc)
	}
	pG = component()
	if (has_property(`SUBEXPR_PROP_TS_INIT')) {
		if (!ustrlen(m_state->touse)) {
			/* programmer error; must markout the expression's
			 *  varlist before setting up the TS initializer
			 *  estimation sample				*/
			m_data->set_errmsg(sprintf("must generate the " +
				"estimation sample for %s {bf:%s} before " +
				"generating the time-series initializing " +
				"estimation sample",sgroup_type(),name()))
			return(111)
		}
		if (m_state->markout_init) {
			goto Exit	// already done
		}
		if (missing(ivar=_st_varindex(touse))) {
			ivar = st_addvar("byte",touse)
		}
		if (missing(ivar)) {
			rc = 499
			goto Exit
		}
		cmd = sprintf("replace %s = 0",touse)
		if (rc=_stata(cmd,nooutput)) {
			goto Exit
		}
		st_view(tuts,.,touse)
		/* assumption: the expression estimation sample did not
		 *  include TS operators in the markout			*/
		tu = st_data(.,m_state->touse)
		io = 1::rows(tu)
		k = pG->group_count()
		/* lagged expressions have order = (0,0,0), look for
		 *  true order vector					*/
		order = (0,0,0)
		so = 0
		for (i=1; i<=k; i++) {
			pSE = pG->get_object(i)	
			order1 = pSE->TS_order()
			if (sum(order1) > so) {
				order = order1
				so = sum(order1)
			}
		}
		k = order[`TS_EXPR_LORDER']	// must be 1
		panelvar = m_data->stata_panelvar()
		if (ustrlen(panelvar)) {
			st_view(pvar,.,panelvar)
			pinfo = panelsetup(pvar,1)
			for (i=1; i<=rows(pinfo); i++) {
				jo = panelsubmatrix(io,i,pinfo)
				tui = panelsubmatrix(tu,i,pinfo)
				if (max(tui) > 0) {
					tui = runningsum(tui)
					jo = select(jo,tui:==k)
					tuts[jo[1]] = 1
				}
			}
		}
		else {
			tu = runningsum(tu)
			i = select(io,(tu:==k))[1]
			tuts[i] = 1
		}
		hassample = `SUBEXPR_TRUE'
		if (order[`TS_EXPR_LORDER'] <= 1) {
			/* update expression estimate sample to exclude 
			 *  the TS init expression estimate sample	*/
			cmd = sprintf("qui replace %s = 0 if %s",m_state->touse,
				touse)
			rc = _stata(cmd,nooutput)
		}
		hassample = `SUBEXPR_TRUE'
		m_state->markout_init = `SUBEXPR_TRUE'
	}
	else {
		if (m_state->markout) {
			hassample = (touse!=m_data->touse())
			goto Exit	// already done
		}
		/* strip off TS ops if expression contains a lag of 
		 *  itself, initialization expression goes into lag
		 *  slot						*/
		nameonly = pG->TS_init_req()
		vlist = varlist(nameonly)
		if (!length(vlist)) {
			return(rc)
		}
		gtype = group_type()
		markdepvar = `SUBEXPR_TRUE'
		if (gtype==`SUBEXPR_EQ_LC' | gtype==`SUBEXPR_EQ_EXPRESSION') {
			if (!m_data->markout_depvar()) {
				/* allow sysmiss in dependent variable	*/
				if (any(ko=strmatch(vlist,name()))) {
					markdepvar = `SUBEXPR_FALSE'
					ko = selectindex(1:-ko)
					vlist = vlist[ko]
				}
			}
		}
		if (m_data->application() == m_data->SPECIAL_APP_BAYES) {
			cmd = sprintf("markout %s %s,strok",touse,
				invtokens(vlist))
		}
		else {
			cmd = sprintf("markout %s %s",touse,invtokens(vlist))
		}
		rc = _stata(cmd,nooutput)
		if (rc) {
			goto Exit
		}
		if (!markdepvar) {
			/* markout non sysmiss obs in dependent var	*/
			cmd = sprintf("markout %s %s, sysmissok",touse,name())
			rc = _stata(cmd,nooutput)
			if (rc) {
				goto Exit
			}
		}
		hassample = `SUBEXPR_TRUE'
		m_state->markout = `SUBEXPR_TRUE'

		pG = component()
		if (pG->TS_init_req()) {
			/* will markout touse when marking out 
			 *  initialization expression (above)		*/
			goto Exit
		}
		order = TS_order()
		if (!(k=order[`TS_EXPR_LORDER'])) {
			goto Exit
		}
		if (order[`TS_LORDER'] >= k) {	// already marked
			goto Exit
		}
		/* lag op L1 on a named expression; not on variable
		 *  markout by hand, k == 1				*/
		st_view(tuts,.,touse)
		tu = st_data(.,touse)
		io = 1::rows(tuts)
		panelvar = m_data->stata_panelvar()
		if (ustrlen(panelvar)) {
			st_view(pvar,.,panelvar)
			pinfo = panelsetup(pvar,1)
			for (i=1; i<=rows(pinfo); i++) {
				jo = panelsubmatrix(io,i,pinfo)
				tui = panelsubmatrix(tu,i,pinfo)
				if (max(tui) > 0) {
					tui = runningsum(tui)
					jo = select(jo,tui:<=k)
					tuts[jo] = J(rows(jo),1,0)
				}
			}
		}
		else {
			tu = runningsum(tu)
			jo = select(io,(tu:<=k))
			tuts[jo] = J(rows(jo),1,0)
		}
	}
	Exit:
	if (rc) {
		if (has_property(`SUBEXPR_PROP_TS_INIT')) {
			m_data->set_errmsg(sprintf("failed to generate the " +
				"estimation sample indicator variable for " +
				"the time-series initialization expression " +
				"{bf:%s}",name()))
		}
		else {
			m_data->set_errmsg(sprintf("failed to generate the " +
				"estimation sample indicator variable for " +
				"{bf:%s}",name()))
			m_data->set_message(sprintf("The estimation sample " +
				"variable list for {bf:%s} is {bf:%s}",name(),
				invtokens(vlist,",")))
		}
	}
	return(rc)
}

string vector __sub_expr_group::varlist(real scalar nameonly)
{
	real scalar type, gtype
	string vector vlist, vlist1
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __sub_expr_group) scalar pSE

	nameonly = (missing(nameonly)?`SUBEXPR_TRUE':
			(nameonly!=`SUBEXPR_FALSE'))
	vlist = J(1,0,"")
	
	gtype = group_type()
	if (gtype == `SUBEXPR_GROUP_PARAM') {
		return(vlist)
	}
	pG = component()
	if (pG->eval_status() == `SUBEXPR_EVAL_VARLIST') {
		/* user defined a recursive condition in their 
		 *  expressions: e.g. a->b->a				*/
		pG = NULL
		return(vlist)
	}
	if (gtype==`SUBEXPR_EQ_LC' | gtype==`SUBEXPR_EQ_EXPRESSION') {
		vlist = (name())
	}
	pG->set_eval_status(`SUBEXPR_EVAL_VARLIST')
	pE = first()
	while (pE != NULL) {
		type = pE->type()
		if (type==`SUBEXPR_EXPRESSION' | type==`SUBEXPR_MATRIX') {
			goto Next
		}
		if (type == `SUBEXPR_GROUP') {
			pSE = pE
			vlist1 = pSE->varlist(nameonly)
		}
		else {
			pC = pE->component()
			vlist1 = _sub_expr_varnames(pC,nameonly)
		}
		vlist = uniqrows((vlist,vlist1)')'
		
		Next: pE = pE->next()
	}
	if (length(vlist)) {
		vlist = sort(vlist',1)'
	}
	pG->set_eval_status(`SUBEXPR_EVAL_IDLE')
	pG = NULL
	pC = NULL
	pSE = NULL

	return(vlist)
}

string vector __sub_expr_group::LV_names()
{
	real scalar type
	string vector LVs
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __sub_expr_group) scalar pG

	LVs = J(1,0,"")
	pE = first()
	while (pE != NULL) {
		type = pE->type()
		if (type == `SUBEXPR_LV') {
			LVs = (LVs,pE->name())
		}
		else if (type == `SUBEXPR_GROUP') {
			pG = pE
			LVs = (LVs,pG->LV_names())
		}
		pE = pE->next()	
	}
	pG = NULL

	return(LVs)
}

end
exit

