*! version 1.2.0  01nov2018

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile __lvhierarchy.matah
quietly include `"`r(fn)'"'

findfile nlparse_macros.matah
quietly include `"`r(fn)'"'

findfile nlparse.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

void __lvpath_varlist_from_node(struct nlparse_node scalar node,
			string scalar varlist)
{
	if (node.type == `PATHOP') {
		__lvpath_varlist_from_node(node.arg[1], varlist)
		__lvpath_varlist_from_node(node.arg[2], varlist)
		return
	}
	if (ustrlen(varlist)) {
		varlist = varlist + " " + node.symb
	}
	else {
		varlist = node.symb
	}
}


/* lvpath implementation						*/

void __lvpath::new()
{
	if (!strlen(LATENT_VARIABLE)) {
		LATENT_VARIABLE = "latent variable"
	}
	clear()
}

void __lvpath::destroy()
{
	clear()
}

string scalar __lvpath::name(|real scalar full)
{
	full = (missing(full)?`SUBEXPR_FALSE':(full!=`SUBEXPR_FALSE'))
	if (full) {
		return(m_name+"["+path()+"]")
	}
	return(m_name)
}

string scalar __lvpath::errmsg()
{
	return(m_errmsg)
}

void __lvpath::display()
{
	if (m_top.type==`PATHOP' | m_top.type==`SYMBOL') {
		pt_display(m_top)
	}
}

real scalar __lvpath::init(string scalar name, string scalar path,
			|struct nlparse_node node)
{
	real scalar rc

	rc = 0
	m_name = ustrtrim(name)
	if (!ustrlen(m_name)) {
		m_errmsg = "name required"
		return(198)
	}
	if (ustrlen(path)) {
		rc = parse_path(path)
	}
	else {
		clear()
		if (args() > 2) {
			m_top = node[1,1]
			if (m_top.type == `LVPARAM') {
				m_top = m_top.arg[1]
			}
			if (m_top.type == `LATENTVAR') {
				m_top = m_top.arg[1]
			}
			if (m_top.type!=`PATHOP' & m_top.type!=`SYMBOL') {
				clear()
				m_errmsg = "path required"
				return(198)
			}
			rc = sort_crossed()
		}
	}
	if (!rc) {
		/* check path variable existence			*/
		rc = validate()
	}
	return(rc)
}

real scalar __lvpath::parse_path(string scalar path)
{
	real scalar rc
	string scalar lvspec
	struct nlparse_node scalar tree

	if (ustrpos(path,">") & ustrpos(path,"<")) {
		m_errmsg = "both {bf:<} and {bf:>} specified"
		return(198)
	}
	lvspec = sprintf("%s:{%s[%s]}",m_name,m_name,path)
	if (rc=_nlparse(lvspec,tree,m_errmsg)) {
		return(rc)
	}
	if (tree.narg != 2) {
		rc = 198
	}
	else {
		m_top = tree.arg[2]
		if (m_top.type == `LVPARAM') {
			m_top = m_top.arg[1]
		}
		if (m_top.type != `LATENTVAR') {
			rc = 198
		}
		else {
			m_top = m_top.arg[1]
		}
	}
	if (rc) {
		m_errmsg = "path structure invalid"
	}
	else {
		rc = sort_crossed()
	}
	return(rc)
}

real scalar __lvpath::sort_crossed()
{
	real scalar i, k, reparse, rc
	string scalar lvspec, path
	string vector vars, hier
	struct nlparse_node scalar tree

	hier = hierarchy()
	k = length(hier)
	rc = 0
	if (!k) {
		return(0)
	}
	reparse = `SUBEXPR_FALSE'
	/* crossed terms, insure a consistent order			*/
	for (i=1; i<=k; i++) {
		vars = tokens(hier[i])
		if (length(vars) > 1) {
			/* crossed terms				*/
			hier[i] = invtokens(sort(tokens(hier[i])',1)',"#")
			reparse = `SUBEXPR_TRUE'
		}
	}
	if (reparse) {
		path = invtokens(hier,">")
		lvspec = sprintf("%s:{%s[%s]}",m_name,m_name,path)
		if (rc=_nlparse(lvspec,tree,m_errmsg)) {
			return(rc)
		}
		else if (tree.narg != 2) {
			rc = 198
		}
		else {
			m_top = tree.arg[2]
			if (m_top.type == `LVPARAM') {
				m_top = m_top.arg[1]
			}
			if (m_top.type != `LATENTVAR') {
				rc = 198
			}
			else {
				m_top = m_top.arg[1]
			}
		}
		if (rc) {
			m_errmsg = "path structure invalid"
		}
	}
	return(rc)
}

real scalar __lvpath::validate()
{
	real scalar rc, i, k
	string scalar vlist
	string vector vars

	pragma unset vlist

	rc = 0
	if (missing(m_top.type)) {
		return(rc)
	}
	_traverse(m_top,`SUBEXPR_HINT_VALIDATE',rc)
	if (rc) {
		return(rc)
	}
	_traverse(m_top,`SUBEXPR_HINT_VARLIST',vlist)
	vars = tokens(vlist)
	k = length(vars)
	for (i=1; i<=k; i++) {
		if (sum(strmatch(vars,vars[i])) > 1) {
			rc = 498
			m_errmsg = sprintf("multiple references to " +
				"index variable {bf:%s} found in " +
				"the path",vars[i])
			return(rc)
		}
	}
	return(rc)
}

struct nlparse_node scalar __lvpath::_clone(
		struct nlparse_node scalar node)
{
	real scalar i
	struct nlparse_node scalar node1

	node1 = node
	for (i=1; i<=node.narg; i++) {
		node1.arg[i] = _clone(node.arg[i])
	}
	return(node1)
}

class __lvpath scalar __lvpath::clone()
{
	class __lvpath scalar tree
	struct nlparse_node scalar node

	m_errmsg = ""
	/* could reparse path()						*/
	node = _clone(m_top)
	(void)tree.init(name(),"",node)

	return(tree)
}

void __lvpath::_traverse(struct nlparse_node scalar node, real scalar hint, 
			|transmorphic val)
{
	real scalar k, hsym
	string scalar sym

	if (node.narg > 0) {
		_traverse(node.arg[1], hint, val)
	}

	if (hint == `SUBEXPR_HINT_PATH') {
		if (node.type == `PATHOP') {
			val = val + node.symb
		}
		else if (node.type == `SYMBOL') {
			val = val + node.symb
		}
	}
	else if (hint == `SUBEXPR_HINT_VARLIST') {
		if (node.type == `SYMBOL') {
			hsym = `SUBEXPR_FALSE'
			if (length(m_hsyms)) {
				hsym = any(node.symb:==m_hsyms)
			}
			if (!hsym) {
				if (strlen(val)) {
					val = val + " "
				}
				val = val + node.symb
			}
		}
	}
	else if (hint == `SUBEXPR_HINT_HIERARCHY') {
		if (node.type == `SYMBOL') {
			k = length(val)
			if (!k) {
				val = J(1,1,"")
				k = 1
			}
			else if (strlen(val[k])) {
				val[k] = val[k] + " "
			}
			val[k] = val[k] + node.symb
		}
		else if (node.type == `PATHOP') {
			if (node.symb == ">") {
				/* now level				*/
				val = (val,"")
			}
		}
	}
	else if (hint == `SUBEXPR_HINT_COUNT') {
		val = val + (node.type==`SYMBOL')
	}
	else if (hint == `SUBEXPR_HINT_VALIDATE') {
		if (val) {	
			return
		}
		if (node.type == `SYMBOL') {
			sym = node.symb
			hsym = `SUBEXPR_FALSE'
			if (length(m_hsyms)) {
				hsym = any(sym:==m_hsyms)
			}
			if (!hsym) {
				/* unabbreviate				*/
				if (!__sub_expr_isvariable(sym)) {
					m_errmsg = sprintf("variable {bf:%s} " +
						"not found",sym)
					val = 111
					return
				}
				node.symb = sym
			}
		}
	}
	if (node.narg > 1) {
		_traverse(node.arg[2], hint, val)
	}
}

/* reverse traversal							*/
void __lvpath::_esrevart(struct nlparse_node scalar node,
		real scalar hint, |transmorphic val)
{
	real scalar k

	if (node.narg > 1) {
		_esrevart(node.arg[2], hint, val)
	}
	if (hint == `SUBEXPR_HINT_HIERARCHY') {
		if (node.type == `SYMBOL') {
			k = length(val)
			if (!k) {
				val = J(1,1,"")
				k = 1
			}
			else if (strlen(val[k])) {
				val[k] = val[k] + " "
			}
			val[k] = val[k] + node.symb
		}
		else if (node.type == `PATHOP') {
			if (node.symb == ">") {
				val = (val,"")
			}
		}
	}
	if (node.narg > 0) {
		_esrevart(node.arg[1], hint, val)
	}
}

string scalar __lvpath::path()
{
	string scalar path

	path = ""
	if (m_top.type==`PATHOP' | m_top.type==`SYMBOL') {
		_traverse(m_top, `SUBEXPR_HINT_PATH', path)
	}
	return(path)
}

string scalar __lvpath::varlist()
{
	string scalar vlist

	vlist = ""
	_traverse(m_top, `SUBEXPR_HINT_VARLIST', vlist)

	return(vlist)
}

void __lvpath::clear()
{
	m_errmsg = ""
	if (m_top.narg == 0) {
		return
	}
	m_top = nlparse_node(1)
	m_top.narg = 0
	m_top.type = .
}

real scalar __lvpath::kvar()
{
	real scalar kvar

	kvar = 0
	_traverse(m_top, `SUBEXPR_HINT_COUNT', kvar)

	return(kvar)
}

string vector __lvpath::hierarchy(|real scalar rev)
{
	string vector hier

	rev = (missing(rev)?0:(rev!=0))
	hier = J(1,0,"")
	if (rev) {
		/* bottom of hierarchy at index 1			*/
		_esrevart(m_top, `SUBEXPR_HINT_HIERARCHY', hier)
	}
	else {
		/* top of hierarchy at index 1				*/
		_traverse(m_top, `SUBEXPR_HINT_HIERARCHY', hier)
	}
	return(hier)
}

real vector __lvpath::order()
{
	real scalar i, k
	real vector order
	string vector hier

	hier = hierarchy()
	k = length(hier)
	order = J(1,k,0)
	for (i=1; i<=k; i++) {
		order[i] = length(tokens(hier[i]))
	}
	return(order)
}

real scalar __lvpath::isequal(class __lvpath scalar tree)
{
	string vector hier1, hier2

	hier1 = hierarchy()
	hier2 = tree.hierarchy()
	if (length(hier1) != length(hier2)) {
		return(0)
	}
	return(all(hier1:==hier2))
}

real scalar __lvpath::iscompatible(class __lvpath scalar tree)
{
	real scalar i, j, l, k0, k1, o0, o1
	string vector hier0, hier1, lev0, lev1

	hier0 = hierarchy()
	hier1 = tree.hierarchy()
	k0 = length(hier0)
	k1 = length(hier1)
	if (k0==1 & k1==1) {
		return(1)
	}
	if (k0 > 1) {
		for (i=1; i<=k0; i++) {
			lev0 = tokens(hier0[i])
			o0 = length(lev0)	// order: # LV interacted
			for (j=1; j<=k1; j++) {
				lev1 = tokens(hier1[j])
				o1 = length(lev1)
				/* cannot have LV's in lower order hier
				 *  level included in a hier level of 
				 *  higher order			*/
				if (o1 > o0) {
					for (l=1; l<=o0; l++) {
						if (any(lev0[l]:==lev1)) {
							return(0)
						}
					}
				}
			}
		}
	}
	if (k1 > 1) {
		for (i=1; i<=k1; i++) {
			lev1 = tokens(hier1[i])
			o1 = length(lev1)	// order: # LV interacted
			for (j=1; j<=k0; j++) {
				lev0 = tokens(hier0[j])
				o0 = length(lev0)
				if (o0 > o1) {
					for (l=1; l<=o1; l++) {
						if (any(lev1[l]:==lev0)) {
							return(0)
						}
					}
				}
			}
		}
	}
	if (k0 == k1) {
		for (i=1; i<=k0; i++) {
			if (any(hier0[i]:==hier1)) {
				/* all LV's should match		*/
				return(all(hier0:==hier1))
			}
		}
	}
	return(1)
}

end
exit
