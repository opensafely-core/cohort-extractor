*! version 1.0.4  23aug2019

findfile nlparse_macros.matah
quietly include `"`r(fn)'"'

findfile nlparse.matah
quietly include `"`r(fn)'"'

local GRAPH_LEN		100

local GRAPH_DEL		1	// distance of graph columns
local GRAPH_EPS		3	// distance of graph lines

local TREE_NODE_SIZE	5

local TRUE		1
local FALSE		0

mata:

mata set matastrict on

struct nlparse_gr_sym {
	real scalar col
	string scalar sym
}
	
struct nlparse_gr_sym_array
{
	struct nlparse_gr_sym vector syms
}

struct nlparse_graph {
	struct nlparse_gr_sym_array vector graph
	real scalar del, eps	// distance of graph columns and lines
}

void pt_graph_init(struct nlparse_graph scalar gr, real scalar len)
{
	gr.graph = nlparse_gr_sym_array(len)
	gr.del = `GRAPH_DEL'
	gr.eps = `GRAPH_EPS'
}

real scalar _nlparse(string scalar expr, struct nlparse_node scalar tree,
			|string scalar errmsg)
{
	real scalar rc
	pointer vector ptree

	pragma unset ptree
	pragma unset tree

	if (!ustrlen(expr)) {
		tree = nlparse_node(0)
		return(0)
	}
	if (rc=_nlparse_u(expr,ptree,errmsg)) {
		tree = nlparse_node(0)
	}
	else {
		rc = _nlparse_build_tree(ptree,tree)
	}
	return(rc)
}

real scalar _nlparse_build_tree(pointer vector pnode,
			struct nlparse_node scalar node)
{
	real scalar i, rc
	pointer vector parg
	
	if (pnode == NULL) {
		return(0)
	}
	if (length(pnode) != `TREE_NODE_SIZE') {
		return(498)
	}
	node.type = *pnode[1]
	node.val = *pnode[2]
	node.symb = *pnode[3]
	node.narg = *pnode[4]
	node.arg = nlparse_node(node.narg)
	parg = *pnode[5]
	rc = 0
	for (i=1; i<=node.narg; i++) {
		if (rc=_nlparse_build_tree(*parg[i],node.arg[i])) {
			break;
		}
	}
	return(rc)
}

real scalar _pt_validate_type(real scalar type, string scalar errmsg)
{
	real scalar rc

	rc = 0
	errmsg = ""
	if (type<0 | type>`KTYPES' | floor(type)!=type) {
		errmsg = sprintf("invalid parse	tree type %g",type)
		rc = 498
	}
	return(rc)
}

string scalar pt_string_type(real scalar type)
{
	string scalar errmsg
	string vector pt_types

	pragma unset errmsg

	if (_pt_validate_type(type,errmsg)) {
		return("")
	}
	pt_types = `PT_STR_TYPES'
	return(pt_types[type])
}

string scalar pt_tree2expr(struct nlparse_node tree)
{
	real scalar rc
	string scalar expr, errmsg

	pragma unset errmsg

	expr = ""
	rc = _pt_tree2expr(tree,expr,errmsg)
	if (rc) {
		errprintf("{p}%s{p_end}\n",errmsg)
		exit(rc)
	}
	return(expr)
}

real scalar _pt_tree2expr(struct nlparse_node scalar tree, string scalar expr,
			string scalar errmsg)
{
	real scalar rc

	if (rc=_pt_validate_type(tree.type,errmsg)) {
		return(rc)
	}
	if (tree.type!=`EXPRESSION' & tree.type!=`EQUATION' & 
		tree.type!=`LINCOM') {
		errmsg = sprintf("expected %s, %s, or %s but got %s",
			pt_string_type(`EXPRESSION'),pt_string_type(`EQUATION'),
			pt_string_type(`LINCOM'),pt_string_type(tree.type))
		return(498)
	}
	if (tree.narg!=2) {
		errmsg = "invalid parse tree"
		return(498)
	}
	expr = tree.arg[1].symb + tree.symb

	rc = _pt_node2expr(tree.arg[2],tree,tree,expr,errmsg)

	return(rc)
}


real scalar _pt_left_opc_LT_opp(struct nlparse_node scalar opp,
		struct nlparse_node scalar opc)
{
	real scalar llogic

	if (opc.symb == "-" & opc.narg==1) {
		/* unary minus						*/
		if (opp.symb == "^") {
			return(`TRUE')
		}
		return(`FALSE')
	}
	llogic = (opc.symb=="=="|opc.symb=="!="|opc.symb=="<="|
		opc.symb==">="|opc.symb=="<"|opc.symb==">")
	if (opp.symb == "-" & opp.narg==1) {
		/* unary minus						*/
		return((opc.symb=="+" | opc.symb=="-" | llogic))
	}
	if (llogic) {
		return(`TRUE')
	}
	if (opc.symb=="+" | opc.symb=="-") {
		return((opp.symb=="*" | opp.symb=="/" | opp.symb=="^" |
			opp.symb=="'"))
	}
	if (opc.symb=="*" | opc.symb=="/") {
		return((opp.symb=="^" | opp.symb=="'"))
	}
	if (opp.symb=="#") {
		return((opc.type==`VARLIST'))
	}
	/* more operators? 						*/
	return(`FALSE')
}

real scalar _pt_right_opc_LT_opp(struct nlparse_node scalar opp,
		struct nlparse_node scalar opc)
{
	real scalar llogic

	if (opc.symb == "-" & opc.narg==1) {
		/* unary minus						*/
		return(`FALSE')
	}
	llogic = (opc.symb=="=="|opc.symb=="!="|opc.symb=="<="|
		opc.symb==">="|opc.symb=="<"|opc.symb==">")
	if (opp.symb == "-" & opp.narg==1) {
		/* unary minus						*/
		return((opc.symb=="+" | opc.symb=="-" | llogic))
	}
	if (llogic) {
		return(`TRUE')
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
	if (opp.symb=="#") {
		return((opc.type==`VARLIST'))
	}
	/* more operators? 						*/
	return(`FALSE')
}

real scalar _pt_node2expr(struct nlparse_node scalar node, 
			struct nlparse_node scalar parent, 
			struct nlparse_node scalar top0,
			string scalar expr, string scalar errmsg)
{
	real scalar rc, i, k, closep
	string scalar expar, path, at
	struct nlparse_node scalar nodei, top

	pragma unset expar
	pragma unset path
	pragma unset at

	if (rc=_pt_validate_type(node.type,errmsg)) {
		return(rc)
	}
	if (parent.type == `VARLIST') {
		if (k=ustrlen(expr)) {
			if (!any(usubstr(expr,k,1):==(" ","(",":","="))) {
				expr = expr + " "
			}
		}
		top = parent
	}
	else {
		top = top0
	}
// pt_dump_node(node)
	k = node.narg
	if (node.type == `OPERATOR') {
		k = node.narg
 		/* operator should only have 1 or 2 nodes		*/
		closep = `FALSE'
		if (node.symb == "=") {
			expr = expr + node.symb
		}
		/* left child						*/
		nodei = node.arg[1]
		if (k==1 & node.symb=="-") {
			/* unary minus					*/
			expr = expr + "-"
		}
		if (nodei.type == `OPERATOR') {
			if (_pt_left_opc_LT_opp(node,nodei)) {
				expr = expr + "("
				closep = `TRUE'
			}
		}
		else if (nodei.type == `VARLIST') {
			expr = expr + "("
			closep = `TRUE'
		}
		if (rc=_pt_node2expr(node.arg[1],node,top,expr,errmsg)) {
			return(rc)
		}
		if (closep) {
			expr = expr + ")"
		}
		if (k == 1) {
			if (node.symb=="'" | node.symb=="^") {
				expr = expr + node.symb
			}
		}
		else {
			/* add operator				*/
			expr = expr + node.symb
				
			/* right child					*/
			nodei = node.arg[2]
			closep = `FALSE'
			if (nodei.type == `OPERATOR') {
				if (_pt_right_opc_LT_opp(node,nodei)) {
					expr = expr + "("
					closep = `TRUE'
				}
			}
			else if (nodei.type == `VARLIST') {
				expr = expr + "("
				closep = `TRUE'
			}
			if (rc=_pt_node2expr(node.arg[2],node,top,expr,
				errmsg)) {
				return(rc)
			}
			if (closep) {
				expr = expr + ")"
			}
		}
	}
	else if (node.type == `ARGLIST') {
		expr = expr + "("
		for (i=1; i<=k; i++) {
 			if (rc=_pt_node2expr(node.arg[i],node,top,expr,
				errmsg)) {
				break
			}
			if (i < node.narg) {
				expr = expr + ","
			}
			else {
				expr = expr + ")"
			}
		}
	}
	else if (node.type == `SUBEXPR') {
		if (!missing(node.val)) {
			/* instance number				*/
			expr = expr + sprintf("{%s:@%g}",node.symb,node.val)
		}
		else {
			expr = expr + sprintf("{%s:}",node.symb)
		}
	}
	else if (node.type == `PARGROUP') {
		if (rc=_pt_node2expr(node.arg[1],node,top,expar,errmsg)) {
			return(rc)
		}
		expr = expr + sprintf("{%s:%s}",node.symb,expar)
	}
	else if (node.type == `PARAMETER') {
		expar = ""
		if (node.narg) {
			/* options or initial values			*/
			if (rc=_pt_node2expr(node.arg[1],node,top,expar,
				errmsg)) {
				return(rc)
			}
		}
		if (parent.type == `PARGROUP') {
			expr = expr + sprintf("%s%s",node.symb,expar)
		}
		else {
			expr = expr + sprintf("{%s%s}",node.symb,expar)
		}
	}
	else if (node.type == `LVPARAM') {
		/* LV with covariates in an expression;
		 *  enclose in braces					*/
		expr = expr + "{"
		if (rc=_pt_node2expr(node.arg[1],node,top,expr,errmsg)) {
			return(rc)
		}
		expr = expr + "}"
	}
	else if (node.type == `LATENTVAR') {
		assert(k==1 | k==2) 	// !debug
		if (rc=_pt_node2expr(node.arg[1],node,top,path,errmsg)) {
			return(rc)
		}
		if (k == 2) {
			if (rc=_pt_node2expr(node.arg[2],node,top,at,errmsg)) {
				return(rc)
			}
			expr = expr + sprintf("%s[%s]%s",node.symb,path,at)
		}
		else {
			expr = expr + sprintf("%s[%s]",node.symb,path)
		}
	}
	else if (node.type == `PATHOP') {
		assert(k==1|k==2)
		if (rc=_pt_node2expr(node.arg[1],node,top,expr,errmsg)) {
			return(rc)
		}
		if (k > 1) {
			expr = expr + node.symb	// ">" or "#"
			if (rc=_pt_node2expr(node.arg[2],node,top,expr,
				errmsg)) {
				return(rc)
			}
		}
	}
	else if (node.type == `CONSTANT') {
		/* potential loss of precision, default format %9.0g	*/
		expr = expr + strofreal(node.val)
	}
	else {
		if (node.type == `MATRIX') {
			expr = expr + "("
		}
		else if (node.type == `VECTOR') {
			if (k > 1) {
				expr = expr + "("
			}
		}
		else if (node.type != `VARLIST') {
			expr = expr + node.symb
		}
		for (i=1; i<=k; i++) {
			if (rc=_pt_node2expr(node.arg[i],node,top,expr,
				errmsg)) {
				break
			}
			if (node.type == `MATRIX') {
				if (i < k) {
					expr = expr + "\"
				}
			}
			if (node.type == `VECTOR') {
				if (i < k) {
					expr = expr + ","
				}
			}
		}
		if (node.type == `MATRIX') {
			expr = expr + ")"
		}
		else if (node.type == `VECTOR') {
			if (k > 1) {
				expr = expr + ")"
			}
		}
	}
	return(rc)	
}

struct nlparse_node scalar pt_clone_tree(struct nlparse_node scalar tree0)
{
	real scalar i
	struct nlparse_node scalar tree

	tree.symb = tree0.symb
	tree.type = tree0.type
	tree.val = tree0.val
	tree.narg = tree0.narg
	tree.arg = nlparse_node(tree.narg)
	for (i=1; i<=tree0.narg; i++) {
		tree.arg[i] = pt_clone_tree(tree0.arg[i])
	}
	return(tree)
}

void pt_dump_node(struct nlparse_node scalar node)
{
	if (node.type == `NULL') {
		printf("\ntype\t\t%g (null)\n",node.type)
	}
	else {
		printf("\ntype\t\t%g (%s)\n",node.type,
			pt_string_type(node.type))
	}
	printf("value\t\t%g\n",node.val)
	printf("symbol\t\t'%s'\n",node.symb)
	printf("# children\t%g\n",node.narg)
}

/* translated from http://eparerpress.com/lexandyacc			*/
void pt_display(struct nlparse_node scalar pt, |real scalar len) 
{
	real scalar ce, cm, asis
	struct nlparse_graph scalar gr

	pragma unused gr

	if (args() == 1) {
		len = `GRAPH_LEN'
	}

	pt_graph_init(gr,len)

	ce = cm = 0
	pt_draw_node(pt,gr,1,1,ce,cm)

	// asis = `TRUE'
	asis = `FALSE'
	pt_draw_graph(gr,asis)
}

string scalar pt_graph_row_str(struct nlparse_gr_sym vector symar)
{
	real scalar i, k
	string scalar str

	k = length(symar)
	str = ""
	for (i=1; i<=k; i++) {
		str = sprintf("%s{col %g}%s",str,symar[i].col,
			symar[i].sym)
	}
	return(str)
}

void pt_draw_graph(struct nlparse_graph scalar gr, |real scalar asis)
{
	real scalar lmax, i, k

	asis = (missing(asis)?`FALSE':(asis!=`FALSE'))
	k = lmax = length(gr.graph)
	
	for (i=1; i<=k; i++) {
		if (length(gr.graph[i].syms)) {
			lmax = i
		}
	}
	printf("\n")
	if (asis) {
		printf("{asis}")
	}
	for (i=1; i<=lmax; i++) {
		printf("%s\n",pt_graph_row_str(gr.graph[i].syms))
	}
	if (asis) {
		printf("{smcl}")
	}
}

void pt_draw_node(struct nlparse_node scalar node,
		struct nlparse_graph scalar gr, real scalar x0,
		real scalar y0, real scalar xr, real scalar xm)
{
	real scalar i, type, w, h, more
	real scalar xbar, x, y, xl, x0r, x0m
	string scalar sym, s

	pragma unset w
	pragma unset h

	x = x0
	y = y0
	x0r = x0m = 0
	type = node.type
	sym = node.symb
	
	if (type == `CONSTANT') {
		s = sprintf("(%g)",node.val)
	}
	else if (type == `SYMBOL') {
		s = "s("+sym+")"
	}
	else if (type==`OPERATOR' | type==`FACTOROP' | type==`ARGLIST' |
		type==`PATHOP' | type==`VARLIST' | type==`TSOP' | 
		type==`ATOP') {
		s = "["+sym+"]"
	}
	else if (type == `FUNCTION') {
		s = "f("+sym+")"
	}
	else if ((type==`MATRIX') | (type==`VECTOR')) {
		s = "["+sym+"]"
	}
	else if (type==`EQUATION' | type==`EXPRESSION' | type==`LINCOM') {
		s = "["+sym+"]"
	}
	else if (type == `LVPARAM') {
		s = "{"+sym+"}"
	}
	else if (type == `LATENTVAR') {
		s = "LV("+sym+")"
	}
	else if (type == `PARAMETER') {
		s = "{"+sym+"}"
	}
	else if (type == `SUBEXPR') {
		if (!missing(node.val)) {
			s = sprintf("{%s:@%g}",sym,node.val)
		}
		else {
			s = sprintf("{%s:}",sym)
		}
	}
	else if (type == `PARGROUP') {
		s = "pg("+sym+")"
	}
	else if (type == `OPTIONS') {
		s = "[,]"
	}
	else {
		s = "<unknown>"	// huh?
	}
	pt_graph_box(s,w,h)

	xbar = x
	xr = x + w
	xm = x + floor(w/2);
	xl = x
	if (type==`OPERATOR' | type==`PATHOP') {
		/* narg == 2 or narg == 1 (unary minus)			*/
		for (i=1; i<=node.narg; i++) {
			pt_draw_node(node.arg[i],gr,xl,y+h+gr.eps,x0r,x0m)
			xl = x0r
		}
	}
	else if (type==`FACTOROP' | type==`TSOP' | type==`ATOP' |
		type==`FUNCTION' | type==`LVPARAM') {
		pt_draw_node(node.arg[1],gr,xl,y+h+gr.eps,x0r,x0m)
		xl = x0r
	}
	else if (type==`ARGLIST' | type==`VARLIST' | type==`LATENTVAR' |
		type==`MATRIX' | type==`VECTOR') {
		for (i=1; i<=node.narg; i++) {
			pt_draw_node(node.arg[i],gr,xl,y+h+gr.eps,x0r,x0m)
			xl = x0r
		}
	}
	else if (type==`LINCOM' | type==`EQUATION' | type==`EXPRESSION') {
		for (i=1; i<=node.narg; i++) {
			pt_draw_node(node.arg[i],gr,xl,y+h+gr.eps,x0r,x0m)
			xl = x0r
		}
	}
	else if ((type==`PARGROUP' | type==`SUBEXPR' | type==`PARAMETER' |
		type==`SYMBOL' | type==`OPTIONS') & node.narg==1) {
		pt_draw_node(node.arg[1],gr,xl,y+h+gr.eps,x0r,x0m)
		xl = x0r
	}
	else {
		pt_draw_box(s,gr,xbar+gr.del,y)
		return
	}
	/* total node width						*/
	if (w < x0r - x) {
		xbar = xbar + floor((x0r-x-w)/2)
		xr = x0r
		xm = floor((x+x0r)/2)
	}
	pt_draw_box(s,gr,xbar+gr.del,y)
	xl = x
	if (type==`OPERATOR' | type==`PATHOP') {
		/* narg == 2 or narg == 1 (una1Gry minus)		*/
		for (i=1; i<=node.narg; i++) {
			pt_draw_node(node.arg[i],gr,xl,y+h+gr.eps,x0r,x0m)
			if (node.narg == 1) {
				x0m = xm
			}
			pt_draw_branch(gr,xm,y+h,x0m,y+h+gr.eps-1)
			xl = x0r
		}
	}
	else if (type==`FACTOROP' | type==`TSOP' | type==`ATOP' | 
		type==`FUNCTION' | type==`LVPARAM') {
		pt_draw_node(node.arg[1],gr,xl,y+h+gr.eps,x0r,x0m)
		x0m = xm
		pt_draw_branch(gr,xm,y+h,x0m,y+h+gr.eps-1)
		xl = x0r
	}
	else if (type == `ARGLIST' | type==`VARLIST' | type==`LATENTVAR' |
		type==`MATRIX' | type==`VECTOR') {
		for (i=1; i<=node.narg; i++) {
			pt_draw_node(node.arg[i],gr,xl,y+h+gr.eps,x0r,x0m)
			if (node.narg == 1) {
				x0m = xm
			}
			more = (i>1 & i<node.narg)
			pt_draw_branch(gr,xm,y+h,x0m,y+h+gr.eps-1,more)
			xl = x0r
		}
	}
	else if (type==`LINCOM' | type==`EQUATION' | type==`EXPRESSION') {
		for (i=1; i<=node.narg; i++) {
			pt_draw_node(node.arg[i],gr,xl,y+h+gr.eps,x0r,x0m)
			more = (i>1 & i<node.narg)
			pt_draw_branch(gr,xm,y+h,x0m,y+h+gr.eps-1,more)
			xl = x0r
		}
	}
	else if ((type==`PARGROUP' | type==`SUBEXPR' | type==`PARAMETER' |
		type==`SYMBOL' | type==`OPTIONS') & node.narg==1) {
		/* arg is an AtOp					*/
		pt_draw_node(node.arg[1],gr,xl,y+h+gr.eps,x0r,x0m)
		x0m = xm
		pt_draw_branch(gr,xm,y+h,x0m,y+h+gr.eps-1)
		xl = x0r
	}
}

void pt_graph_box(string scalar s, real scalar w, real scalar h)
{
	w = ustrlen(s) + `GRAPH_DEL'
	h = 1
}

void pt_check_bounds(real scalar i, struct nlparse_graph scalar gr)
{
	if (i > length(gr.graph)) {
		errprintf("graph index %g exceeds row dimension %g\n",
			i,rows(gr.graph))
		exit(503)
	}
}

void pt_draw_box(string scalar s, struct nlparse_graph scalar gr, real scalar x,
		real scalar y)
{
	real scalar i, k
	struct nlparse_gr_sym scalar sym

	pt_check_bounds(y,gr)
	k = length(gr.graph[y].syms)
	sym.col = x
	sym.sym = s
	for (i=1; i<=k; i++) {
		if (gr.graph[y].syms[i].col == sym.col) {
			/* replace symbol				*/
			gr.graph[y].syms[i].sym = s
			return
		}
		else if (gr.graph[y].syms[i].col > sym.col) {
			if (i == 1) {
				gr.graph[y].syms = (sym,gr.graph[y].syms)
			}
			else if (i == k) {
				gr.graph[y].syms = (gr.graph[y].syms,sym)
			}
			else { // (i>1 & i<k)
				gr.graph[y].syms = (gr.graph[y].syms[|1\i-1|],
					sym,gr.graph[y].syms[|i\k|])
			}
			return
		}
	}
	gr.graph[y].syms = (gr.graph[y].syms,sym)
}

void pt_draw_branch(struct nlparse_graph scalar gr, real scalar x10,
		real scalar y10, real scalar x20, real scalar y20,
		|real scalar more)
{
	real scalar m, x1, x2, y1, y2, c, tlc, trc

	more = (missing(more)?`FALSE':(more!=`FALSE'))
	y1 = y10
	y2 = y20
	x1 = x10
	x2 = x20

	// pt_check_bounds(y1,x1,gr)
	// pt_check_bounds(y2,x2,gr)
	pt_check_bounds(y1,gr)
	pt_check_bounds(y2,gr)

	m = floor((y1+y2)/2)
	while (y1 != m) {
		// gr.graph[y1] = sprintf("%s{col %g}{c |}",gr.graph[y1],x1)
		pt_draw_box("{c |}",gr,x1,y1)

		if (y1<y2) y1++
		else y1--
	}
	c = 0
	tlc = (x1>x2)
	trc = (x1<x2)
	while (x1 != x2) {
		if (!c) {
		// 	gr.graph[y1] = sprintf("%s{col %g}{c BT}",gr.graph[y1],
		//			x1)
			pt_draw_box("{c BT}",gr,x1,y1)
		}
		else {
		//	gr.graph[y1] = sprintf("%s{col %g}{c -}",gr.graph[y1],
		//			x1)
			pt_draw_box("{c -}",gr,x1,y1)
		}
		c++

		if (x1<x2) x1++
		else x1--
	}
	c = 0
	if (tlc) {
		tlc = c
		trc = -1
	}
	else if (trc) {
		trc = y2-y1-1
		tlc = -1
	}
	else {
		tlc = trc = -1
	}
	while (y1 != y2) {
		if (c == tlc) {
			if (more) {
			//	gr.graph[y1] = sprintf("%s{col %g}{c TT}",
			//		gr.graph[y1],x1)
				pt_draw_box("{c TT}",gr,x1,y1)
			}
			else {
			//	gr.graph[y1] = sprintf("%s{col %g}{c TLC}",
			//		gr.graph[y1],x1)
				pt_draw_box("{c TLC}",gr,x1,y1)
			}
		}
		else if (c == trc) {
			if (more) {
				/* gets clobbered			*/
			//	gr.graph[y1] = sprintf("%s{col %g}{c TT}",
			//		gr.graph[y1],x1)
				pt_draw_box("{c TT}",gr,x1,y1)
			}
			else {
			//	gr.graph[y1] = sprintf("%s{col %g}{c TRC}",
			//		gr.graph[y1],x1)
				pt_draw_box("{c TRC}",gr,x1,y1)
			}
		}
		else {
		//	gr.graph[y1] = sprintf("%s{col %g}{c |}",gr.graph[y1],
		//			x1)
			pt_draw_box("{c |}",gr,x1,y1)
		}
		c++

		if (y1<y2) y1++
		else y1--
	}
	// gr.graph[y1] = sprintf("%s{col %g}{c |}",gr.graph[y1],x1)
	pt_draw_box("{c |}",gr,x1,y1)
}

void pt_post_cert(struct nlparse_node scalar pt)
{
	real scalar depth, i, k
	string colvector stack

	pragma unset stack

	st_rclear()
	depth = -1
	_pt_post_cert(pt,depth,stack)

	k = rows(stack)
	/* post reverse order so that the return order is by node#	*/
	for (i=k; i>=1; i--) {
		st_global(sprintf("r(node%g)",i),stack[i])
	}
}

void _pt_post_cert(struct nlparse_node scalar node, real scalar depth, 
			string colvector stack)
{
	real scalar i
	string scalar snode
	string vector node_types

	node_types = (`PT_ABR_TYPES')

	depth++
	if (node.type == `SUBEXPR') {
		if (!missing(node.val)) {
			snode = sprintf("depth %g: type=%s, value=%g, " +
				"symbol='%s',children=%g",depth,
				node_types[node.type],node.val,node.symb,
				node.narg)
		}
		else {
			snode = sprintf("depth %g: type=%s, symbol='%s', " +
				"children=%g",depth,node_types[node.type],
				node.symb,node.narg)
		}
	}
	else if (node.type==`PARAMETER' | node.type==`CONSTANT') {
		snode = sprintf("depth %g: type=%s, value=%g, symbol='%s', " +
				"children=%g",depth,node_types[node.type],
				node.val,node.symb,node.narg)
	}
	else {
		snode = sprintf("depth %g: type=%s, symbol='%s', children=%g",
				depth,node_types[node.type],node.symb,
				node.narg)
	}
	stack = (stack\snode)

	for (i=1; i<=node.narg; i++) {
		_pt_post_cert(node.arg[i],depth,stack)
	}
	depth--
}

end
exit
