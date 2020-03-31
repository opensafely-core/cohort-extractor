*! version 1.0.4  16feb2015

program mi_cmd_ptrace, rclass
	version 11

	gettoken cmd 0 : 0, parse(" ,")
	local l = strlen("`cmd'")
	if ("`cmd'"==bsubstr("describe", 1, max(1, `l'))) {
		mi_cmd_ptrace_describe `0'
	}
	else if ("`cmd'"=="use") {
		mi_cmd_ptrace_use `0'
	}
	else {
		mi_cmd_ptrace_error "`cmd'"
	}
	return add
end

program mi_cmd_ptrace_error
	args cmd

	if ("`cmd'"=="") {
		di as err "syntax error"
		di as err "{p 4 4 2}"
		di as err "{bf:mi ptrace} must be followed by a subcommand."
		di as err "You can type"
		di as err "{bf:mi ptrace describe} and {bf:mi ptrace use}."
		di as err "{p_end}"
		exit 198
	}
	else {
		di as err "{bf:`cmd'}: unrecognized {bf:mi ptrace} subcommand."
		di as err "{p 4 4 2}"
		di as error "Valid commands are"
		di as err "{bf:mi ptrace describe} and {bf:mi ptrace use}."
		di as err "{p_end}"
		exit 198
	}
end

program mi_cmd_ptrace_describe, rclass

	local hasusing 0
	gettoken token rest : 0, parse(" ,")
	if (`"`token'"'=="using") {
		gettoken token : rest, parse(" ,")
		if (`"`token'"'!="" & `"`token'"'!=",") {
			local hasusing 1
		}
	}
	if (!`hasusing') {
		local 0 `"using `0'"'
	} 

	syntax using/ [, CERTIFYMODE]

	capture noisily {
		mata: u_mi_get_mata_instanced_var("h", "_mi_ptrace_describe")
		mata: cmd_describe(`h', `"`using'"', "`certifymode'")
	}
	nobreak {
		local rc = _rc
		capture mata: u_mi_ptrace_safeclose(`h')
		capture mata: mata drop `h'
		if (`rc') {
			exit `rc'
		}
	}
end

program mi_cmd_ptrace_use
	local 0 `"using `0'"'
	syntax using/ [, CLEAR DOUBLE SELect(string)]

	if (c(changed) & "`clear'"=="") {
		error 4
	}
	local typ = cond("`double'"=="", "float", "double")

	capture noisily {
		mata: u_mi_get_mata_instanced_var("h", "_mi_ptrace_use")
		mata: cmd_use(`h', `"`using'"', `"`select'"', "`typ'")
		quietly compress m iter
	}
	nobreak {
		local rc = _rc
		capture mata: u_mi_ptrace_safeclose(`h')
		capture mata: mata drop `h'
		if (`rc') {
			exit `rc'
		}
	}
end



version 11
local RS	real scalar
local RC	real colvector
local SS	string scalar
local RM	real matrix
local SR	string rowvector

local boolean	`SS'
local Code	`RS'

local togetname	u_mi_ptrace_use_tgdf
local Toget	struct `togetname' scalar
local Togetinit	`togetname'init

mata:
struct `togetname' 
{
	`SS'	filename
	`SR'	ystripe, xstripe
	`SR'	bnames, Vnames
	`SR'	blabels, Vlabels
	`RM'	b, V
	`SS' 	selforerr
}

void `Togetinit'(`Toget' tg)
{
	tg.b = tg.V = J(0, 2, .)
}



void cmd_use(h, `SS' filename, `SS' select, `SS' typ)
{
	`Toget'	tg

	`Togetinit'(tg)

	tg.filename = u_mi_ptrace_ffname(filename)

	/* ------------------------------------------------------------ */
	h = u_mi_ptrace_open(tg.filename, "r")
	tg.ystripe = tokens(u_mi_ptrace_get_ystripe(h))
	tg.xstripe = tokens(u_mi_ptrace_get_xstripe(h))
	u_mi_ptrace_close(h)

	/* ------------------------------------------------------------ */
	if (length(tg.ystripe)==0 & length(tg.xstripe)==0) {
		if (select=="") {
			cmd_use_empty()
			return
		}
		cmd_use_notfound(tg.filename, select)
		errprintf("    file is empty\n")
		exit(111)
		/*NOTREACHED*/
	}

	/* ------------------------------------------------------------ */
	if (select=="") setup_all(tg)
	else		setup_sel(tg, select)

	/* ------------------------------------------------------------ */

	h = u_mi_ptrace_open(tg.filename, "r")
	select_data(tg, typ, h)
	u_mi_ptrace_close(h)
}

void select_data(`Toget' tg, `SS' typ, transmorphic h)
{
	`RS'	i, nb, nV, j
	`RS'	m, iter
	`RM'	b, V
	`RM'	View_miter, View_b, View_V

	st_dropvar(.)
	(void) st_addvar("long", ("m", "iter"))
	(void) st_addvar(typ, tg.bnames)
	(void) st_addvar(typ, tg.Vnames)

	nb = length(tg.bnames)
	nV = length(tg.Vnames)
	for (i=1; i<=nb; i++) st_varlabel(tg.bnames[i], tg.blabels[i])
	for (i=1; i<=nV; i++) st_varlabel(tg.Vnames[i], tg.Vlabels[i])

	st_addobs(u_mi_ptrace_get_nrecs(h))

	pragma unset View_miter
	pragma unset View_b
	pragma unset View_V
	st_view(View_miter, ., ("m", "iter"))
	st_view(View_b,     ., tg.bnames)
	st_view(View_V,     ., tg.Vnames)

	pragma unset m
	pragma unset iter
	pragma unset b
	pragma unset V
	for (i=1; u_mi_ptrace_read_iter(h, m,iter,b,V)==0; i++) {
		View_miter[i,.] = (m, iter)
		for (j=1; j<=nb; j++) View_b[i, j] = b[| tg.b[j,.] |]
		for (j=1; j<=nV; j++) View_V[i, j] = V[| tg.V[j,.] |]
	}
}


void setup_all(`Toget' tg)
{
	`RS'	ny, nx
	`RS'	i, j, k, l

	ny = length(tg.ystripe)
	nx = length(tg.xstripe)

	tg.b = J(ny*nx, 2, .)
	tg.V = J(ny*(ny+1)/2, 2, .)

	tg.bnames = tg.blabels = J(1, ny*nx, "")
	tg.Vnames = tg.Vlabels = J(1, ny*(ny+1)/2, "")

	k = l = 0
	for (i=1; i<=ny; i++) {
		for (j=1; j<=nx; j++) {
			tg.b[++k, .]  = (i, j)
			tg.bnames[k]  = sprintf("b_y%gx%g", i, j)
			tg.blabels[k] = sprintf("%s, %s", 
						tg.ystripe[i], tg.xstripe[j])
		}
		for (j=1; j<=i; j++) {
			tg.V[++l, .]  = (i, j)
			tg.Vnames[l]  = sprintf("v_y%gy%g", i, j)
			tg.Vlabels[l] = sprintf("%s, %s", 
						tg.ystripe[i], tg.ystripe[j])
		}
	}
}


void cmd_use_notfound(`SS' filename, `SS' notfound)
{
	errprintf("{p 0 0 2}\n")
	errprintf(notfound)
	errprintf("\n")
	errprintf("not found in file %s\n", filename)
	errprintf("{p_end}\n")
}

void cmd_use_empty()
{
	st_dropvar(.)
	(void) st_addvar("byte", "m")
	(void) st_addvar("byte", "iter")
	printf("{txt}(file is empty)\n")
}


/*                     __
	void setup_sel(tg, `SS' select)
		       --       ------

	Inputs:
		select			indices to select (input format)
		tg.ystripe		names of y 
		tg.xstripe		names of x
	Outputs:
		tb.b			indices to select
		tb.V			indices to select
		tg.bnames		
		tg.Vnames
		tg.blabels
		tg.Vlabels
*/

`SR' mytokens(`SS' s)
{
	`RS'		i, l, start
	`RS'		nb
	`SS'		t, c
	`SR'		r
	
	r = J(1, 0, "")
	if ((l = bstrlen(t = strtrim(s)))==0) return(r)
	
	nb = 0
	for (start=i=1; i<=l; i++) {
		c = bsubstr(t, i, 1)
		if (nb) {
			if (c=="[") nb++ 
			else if (c=="]") nb--
		}
		else {
			if (c=="[") nb++
			else if (c==" ") {
				r = r, strtrim(bsubstr(s, start, i-start))
				start = i
			}
		}
	}
	r = r , strtrim(bsubstr(s, start, .))
	return(r)
}


void setup_sel(`Toget' tg, `SS' select)
{
	`RS'	i, k, ii, jj
	`SR'	sels

	sels = mytokens(select)

	for (i=1; i<=length(sels); i++) {
		setup_sel_el(tg, sels[i])
	}

	tg.b = sort(uniqrows(tg.b), (1,2))
	tg.V = sort(uniqrows(tg.V), (1,2))

	tg.bnames = tg.blabels = J(1, rows(tg.b), "")
	k = 0 
	for (i=1; i<=rows(tg.b); i++) {
		ii = tg.b[i, 1]
		jj = tg.b[i, 2]
		tg.bnames[++k] = sprintf("b_y%gx%g", ii, jj)
		tg.blabels[k]  = sprintf("%s, %s", 
					tg.ystripe[ii], tg.xstripe[jj])
	}
		
	tg.Vnames = tg.Vlabels = J(1, rows(tg.V), "")
	k = 0
	for (i=1; i<=rows(tg.V); i++) {
		ii = tg.V[i, 1]
		jj = tg.V[i, 2]
		tg.Vnames[++k] = sprintf("v_y%gy%g", ii, jj)
		tg.Vlabels[k]  = sprintf("%s, %s", 
					tg.ystripe[ii], tg.ystripe[jj])
	}
}

/*			  __
	void setup_sel_el(tg, `SS' sel)
			  --       ---


		<sel>   := b[<yidx1>, <xidx>]
			   v[<yidx1>, <yidx2>]
			   y<yidx1>x<xidx>
			   y<yidx1>y<yidx2>
		
		<yidx1> := <yname>
			   <#>
			   *

		<xidx>  := <xname>
			   <#>
			   *

		<yidx2> := <yidx1>
			   =
			   >=
			   <=
			   >
			   <
*/

void setup_sel_el(`Toget' tg, `SS' sel)
{
	`SS'	y1, y2, x2, q2, c1
	`Code'	typ
	`RM'	list1, list2

	pragma unset y1
	pragma unset y2
	pragma unset x2
	pragma unset q2

	tg.selforerr = sel 
	c1 = bsubstr(sel, 1, 1)

	if (c1=="b") {
		split_bracketed(y1, x2, sel)
		list1 = parse_yidx1(tg, y1)
		list2 = parse_xidx(tg, x2)
		tg.b = tg.b \ crosslists(list1, list2)
	}
	else if (c1=="v") {
		split_bracketed(y1, y2, sel)
		list1 = parse_yidx1(tg, y1)
		tg.V = tg.V \ parse_yidx2(tg, list1, y2)
	}
	else if (c1=="y") {
		typ = split_runtogether(y1, q2, sel)
		list1 = parse_yidx1(tg, y1)
		if (typ==1/*yidx2*/) {
			tg.V = tg.V \ parse_yidx2(tg, list1, q2)
		}
		else /*xidx*/ {
			list2 = parse_xidx(tg, q2)
			tg.b = tg.b \ crosslists(list1, list2)
		}
	}
	else	bad_sel_el(tg.selforerr, 198)
}

void bad_sel_el(`SS' sel, `Code' rc)
{
	`SS'	rest

	if (rc==111)		rest = "not found"
	else if (rc==125)	rest = "out of range" 
	else 			rest = "invalid"

	errprintf("syntax error\n")
	errprintf("    selection {bf:%s} %s\n", sel, rest)
	exit(rc)
}


`Code' split_runtogether(y1, q2, `SS' sel)
{
	`RS'	l, ly, lx
	`SS'	mid

	/* sel = y#x#  or y#y# */

	mid = bsubstr(sel, 2, .)		/* #x# or #y#	*/
	ly  = strpos(mid, "y")
	lx  = strpos(mid, "x")
	if ( (ly & lx) | !(ly | lx) ) bad_sel_el(sel, 198)
	l   = ly + lx
	y1  = strtrim(bsubstr(mid,   1, l-1))
	q2  = strtrim(bsubstr(mid, l+1,   .))
	return(ly ? 1 : 0)
}


`RC' parse_yidx1(`Toget' tg, `SS' s)
{
	`RS'	i, num

	if ((num = strtoreal(s)) != .) {
		if (num<1 | num>length(tg.ystripe)) bad_sel_el(tg.selforerr,125)
		return(num)
	}

	if (s=="*") return(1::length(tg.ystripe))

	for (i=1; i<=length(tg.ystripe); i++) {
		if (s==tg.ystripe[i]) return(i)
	}

	bad_sel_el(tg.selforerr, 198)
}

`RM' parse_yidx2(`Toget' tg, `RC' y1, `SS' s)
{
	`RS'	i, j, num
	`RS'	y
	`RM'	r

	if ((num = strtoreal(s)) != .) {
		if (num<1 | num>length(tg.ystripe)) bad_sel_el(tg.selforerr,125)
		return(crosslists(y1, num))
	}
	
	if (s=="*") return(crosslists(y1, 1::length(tg.ystripe)))

	if (s=="=") return((y1, y1))


	r = J(0, 2, .)

	if (s==">") {
		for (i=1; i<=length(y1); i++) { 
			y = y1[i]
			for (j=y+1; j<=length(tg.ystripe); j++) r = r \ (y, j)
		}
	}

	else if (s==">=") {
		for (i=1; i<=length(y1); i++) { 
			y = y1[i]
			for (j=y; j<=length(tg.ystripe); j++) r = r \ (y, j)
		}
	}

	else if (s=="<") {
		for (i=1; i<=length(y1); i++) { 
			y = y1[i]
			for (j=1; j<y; j++) r = r \ (y, j)
		}
	}

	else if (s=="<=") {
		for (i=1; i<=length(y1); i++) { 
			y = y1[i]
			for (j=1; j<=y; j++) r = r \ (y, j)
		}
	}

	else	bad_sel_el(tg.selforerr, 198)

	return(r)
}
				
		
`RC' parse_xidx(`Toget' tg, `SS' s)
{
	`RS'	i, num

	if ((num = strtoreal(s)) != .) {
		if (num<1 | num>length(tg.xstripe)) bad_sel_el(tg.selforerr,125)
		return(num)
	}

	if (s=="*") return(1::length(tg.xstripe))

	for (i=1; i<=length(tg.xstripe); i++) {
		if (s==tg.xstripe[i]) return(i)
	}

	bad_sel_el(tg.selforerr,198)
}

`RM' crosslists(`CV' y, `CV' x)
{
	`RS'	i, j, k
	`RM'	r

	r = J(length(y)*length(x), 2, .)
	k = 0 
	for (i=1; i<=length(y); i++) {
		for (j=1; j<=length(x); j++) r[++k,.] = (y[i], x[j])
	}
	return(r)
}


void split_bracketed(lft, rgt, `SS' sel)
{
	`RS'	cma
	`SS'	mid

	if (bsubstr(sel,2,1)!="[" | bsubstr(sel,-1, 1)!="]") bad_sel_el(sel,198)

	mid = bsubstr(sel, 3, .)
	mid = bsubstr(mid, 1, strlen(mid)-1)
	if ((cma = strpos(mid, ","))==0) bad_sel_el(sel,198)
	lft = strtrim(bsubstr(mid, 1, cma-1))
	rgt = strtrim(bsubstr(mid, cma+1, .))
	if (lft=="" | rgt=="") bad_sel_el(sel, 198)
}


void cmd_describe(h, `SS' filename, `SS' certifymode)
{
	`SR'	ystripe, xstripe
	`SS'	yorig, xorig, id
	`RS'	nrecs
	`RS'	tc

	h       = u_mi_ptrace_open(filename, "r")
	ystripe = tokens(yorig = u_mi_ptrace_get_ystripe(h))
	xstripe = tokens(xorig = u_mi_ptrace_get_xstripe(h))
	nrecs   = u_mi_ptrace_get_nrecs(h)
	id      = u_mi_ptrace_get_id(h)
	tc      = u_mi_ptrace_get_tc(h)
	u_mi_ptrace_close(h)

	if (certifymode!="") tc = 0

	describe_dense(filename, id, tc, ystripe, xstripe, nrecs)

	st_numscalar("return(ny)", length(ystripe))
	st_numscalar("return(nx)", length(xstripe))
	st_numscalar("return(tc)", tc)
	st_global("return(y)", yorig)
	st_global("return(x)", xorig)
	st_global("return(id)", id)
}

`RS' lenofstrrep(`RS' x) return(strlen(sprintf("%g", x)))

void describe_dense(`SS' fn, `SS' id, `RS' tc, 
			`SR' ystripe, `SR' xstripe, `RS' nrecs)
{
	`RS'	i
	`RS'	nb, nv
	`SS'	work

	nb = length(ystripe)*length(xstripe)
	nv = (length(ystripe)*(length(ystripe)+1))/2

	printf("{txt}\n")
	printf("{p 2 2 2}\n") 
	printf("file %s created\n", u_mi_ptrace_ffname(fn))
	if (id!="") printf("by {res:%s}\n", id)
	printf("on %tcdd_Mon_CCYY_HH:MM \n", tc)
	work = sprintf("%18.0gc", nrecs)
	printf("contains %s records (obs.) on\n", strtrim(work))
	printf("{p_end}\n")
	printf("      {res:m}{col 30}1 variable\n")
	printf("      {res:iter}{col 30}1 variable\n")
	printf("      {res:b[{it:y}, {it:x}]}{col %g}%g %s (%g {it:x} %g)\n", 
			31-lenofstrrep(nb), 
			nb, 
			(nb==1 ? "variable" : "variables"),
			length(ystripe), length(xstripe)
	      )
	printf(
    "      {res:v[{it:y}, {it:y}]}{col %g}%g %s (%g {it:x} %g, symmetric)\n", 
			31-lenofstrrep(nv), 
			nv, 
			(nv==1 ? "variable" : "variables"),
			length(ystripe), length(ystripe)
	       )
	printf("{txt}\n") 
	printf("  where {res:{it:y}} and {res:{it:x}} are\n")

	printf("{p 6 10 2}\n")
	printf("{res:{it:y}}:  ")
	for (i=1; i<=length(ystripe); i++) {
		printf("(%g){bind: }%s{bind: }\n", i, ystripe[i])
	}
	printf("{p_end}\n")

	// printf("\n")
	printf("{p 6 10 2}\n")
	printf("{res:{it:x}}:  ")
	for (i=1; i<=length(xstripe); i++) {
		printf("(%g){bind: }%s{bind: }\n", i, xstripe[i])
	}
	printf("{p_end}\n")
}

end
