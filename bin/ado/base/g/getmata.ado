*! version 1.2.1  16feb2015

/*
getmata <getlist> [, id([varname=]vecname) double replace update force]

	<getlist> := 
			<namelist> <getlist>
			<varname>=<vecname> <getlist>
			(<varnamelist>)=<matname> <getlist>

	<varnamelist> :=
			<varname> <varnamelist>
			<varname>* <varnamelist>
*/


program getmata, rclass
	version 11

	syntax [anything(name=getlist id="getlist" equalok)] ///
		[, DOUBLE FORCE ID(string) REPLACE UPdate]

	mata: get()
end



/* -------------------------------------------------------------------- */

local Tr	transmorphic
local SS	string scalar
local SC	string colvector
local SR	string rowvector
local RS	real scalar
local RR	real rowvector
local RC	real colvector
local RM	real matrix
local PROBLEM	struct prinfo scalar
local ELEMENT	struct elinfo scalar
local ID	struct idinfo scalar

local boolean	`RS'
local		True	1
local		False	0


local BUILDSIZE	100

/* -------------------------------------------------------------------- */
mata:


struct elinfo {
	`boolean'		isnumeric
	`SR'			varname
	`SS'			matname
	pointer(matrix) scalar	matptr
	`RR'			varexists
}

struct prinfo {
	`boolean'			op_id
	`boolean'			op_replace
	`boolean'			op_force
	`boolean'			op_double
	`boolean'			op_update

	`ELEMENT'			id
	`RC'				id_lhsmap, id_rhsmap

	`RS'				minrows, maxrows
	`SS'				tempname

	`RS'				ret_K_new
	`RS'				ret_K_existing

	pointer(`ELEMENT') rowvector	el
}
	
/* -------------------------------------------------------------------- */

void get()
{
	`PROBLEM'	pr

	setup_problem(pr)

	parse_getlist(pr)

	assert_varnames_unique(pr)
	set_minmaxrows(pr)
	assert_row_conformability(pr)

	// dump_problem(pr)
	setup_id(pr)
	post_variables(pr)

	st_numscalar("return(K_new)",     pr.ret_K_new)
	st_numscalar("return(K_existing)", pr.ret_K_existing)
}

void setup_problem(`PROBLEM' pr)
{
	pr.ret_K_new = pr.ret_K_existing = 0

	pr.op_replace = (st_local("replace") != "")
	pr.op_force   = (st_local("force")   != "")
	pr.op_double  = (st_local("double")  != "")
	pr.op_update  = (st_local("update")  != "")

	if (st_nobs()==0 & c("k")==0) {
		pr.op_force = `True'
	}

	if (pr.op_update & pr.op_replace) {
		setup_problem_err1()
		/*NOTREACHED*/
	}

	if (!pr.op_double) pr.op_double  = (c("type")=="double") 
	if ( pr.op_update) pr.op_replace = `True'

	pr.tempname = st_tempname()
	
	setup_problem_id(pr)
}

void setup_problem_err1()
{
	errprintf(
	    "options {bf:update} and {bf:replace} may not both be specified\n"
	    )
	errprintf("{p 4 4 2}\n") 
	errprintf("Specify one or the other.\n")
	errprintf("Specify {bf:update} if you want values not updated\n")
	errprintf("left as they are, and {bf:replace} if you want them\n")
	errprintf("changed to missing values.\n")
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}


void setup_problem_id(`PROBLEM' pr)
{
	`SS'	idstr
	`SR'	idvec
	`SS'	varname

	if ((idstr = strtrim(st_local("id"))) == "") {
		pr.op_id  = `False'
		return
	}
	pr.op_id = `True'
	idvec = tokens(idstr, " =")

	if (length(idvec)==1) {
		varname = unabvarname(idstr)
		post_to_el(pr.id, varname, varname, `True')
		return
	}

	if (length(idvec)==3) {
		if (idvec[2]=="=") {
			varname = unabvarname(idvec[1])
			post_to_el(pr.id, varname, idvec[3], `True')
			return
		}
	}

	errprintf("{p 0 0 2}\n")
	errprintf("{bf:id(%s)} invalid\n")
	errprintf("{p_end}\n")
	errprintf("{p 4 4 2}\n")
	errprintf("Syntax is {bf:id(}{it:varname}{bf:)} or\n")
	errprintf("{bf:id(}{it:varname}{bf:=}{it:vecname}{bf:)}.\n")
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}
	

void assert_matexists(`SS' matname)
{
	if (!st_isname(matname)) {
		if (strtrim(matname)=="") {
			errprintf("nothing found where matrix name expected\n")
		}
		else {
			errprintf("{bf:%s} invalid vector or matrix name\n", 
				matname)
		}
		exit(198)
		/*NOTREACHED*/
	}
	if (findexternal(matname)==NULL) {
		errprintf("vector or matrix {bf:%s} not found\n", matname)
		exit(111)
		/*NOTREACHED*/
	}
}


/*
	<getlist> := 
			<varnamelist>              <getlist>
			<varname>=<vecname>        <getlist>
			(<evarnamelist>)=<matname> <getlist>

	<evarnamelist> :=
			<varname>    <varnamelist>
			<varname>*   <varnamelist>
*/


void parse_getlist(`PROBLEM' pr)
{
	`Tr'	t
	`SS'	getlist, token, varname

	if ((getlist = strtrim(st_local("getlist")))=="") {
		parse_getlist_empty()
		/*NOTREACHED*/
	}

	t = tokeninit(" ", "=", "()")
	tokenset(t, getlist)

	for (token=tokenget(t); token != ""; token = tokenget(t)) {
		if (bsubstr(token, 1, 1)=="(") {
			parse_getlist_paren(t, token, pr)
		}
		else if (tokenpeek(t)=="=") {
			(void) tokenget(t)
			varname = token 
			token = tokenget(t)
			if (token=="") {
				errprintf(
				  "nothing found where matrix name expected\n")
				exit(198)
			}
			add_to_el(pr, varname, token)
		}
		else {
			add_to_el(pr, token, token)
		}
	}
}

void parse_getlist_empty()
{
	errprintf("{it:getlist} required\n")
	errprintf(
	"    Syntax is  {bf:getmata} {it:getlist} [{bf:,} {it:options}]\n")

	errprintf("\n")
	errprintf("{p 4 4 2}\n")
	errprintf("To get Mata vector {it:name} into\n")
	errprintf("Stata variable {it:name}, type\n")
	errprintf("{p_end}\n")
	errprintf("        . {bf:getmata} {it:name} ...\n")

	errprintf("\n")
	errprintf("{p 4 4 2}\n")
	errprintf("To get Mata vector {it:vecname} into\n")
	errprintf("Stata variable {it:varname}, type\n")
	errprintf("{p_end}\n")
	errprintf("        . {bf:getmata} {it:varname}{bf:=}{it:vecname} ...\n")

	errprintf("\n")
	errprintf("{p 4 4 2}\n")
	errprintf("To get, for example,\n")
	errprintf("Mata {it:N x} 3 matrix {it:matname} into Stata variables\n")
	errprintf("{it:varname1}, {it:varname2}, and {it:varname3}, type\n")
	errprintf("{p_end}\n")
	errprintf("        . {bf:getmata (}{it:varname1 varname2 varname3}{bf:)=}{it:matname} ...\n")
	exit(100)
}

void parse_getlist_paren(`Tr' callerst, `SS' boundlist, `PROBLEM' pr)
{
	`Tr'	t
	`SS'	toparse, token, evarnamelist

	toparse = bsubstr(boundlist,   2, .)
	toparse = bsubstr(toparse,     1, bstrlen(toparse)-1)

	t = tokeninit(" ", "=", "()")
	tokenset(t, toparse)

	evarnamelist = ""
	for (token=tokenget(t); token!=""; token = tokenget(t)) {
		evarnamelist = evarnamelist + " " + token
	}
	if ((evarnamelist = strtrim(evarnamelist))=="") {
		parse_getlist_err("", "{it:evarnamelist}")
	}

	if ((token = tokenget(callerst)) != "=") {
		parse_getlist_err(token, "equal sign (=)")
	}

	if ((token = tokenget(callerst)) == "") {
		parse_getlist_err("", "matrix name")
	}

	add_to_el(pr, tokens(evarnamelist), token)
}


void parse_getlist_err(`SS' found, `SS' expected)
{
	`SS'	ftxt

	if (found!="") ftxt = sprintf("{bf:%s}", found)
	else	       ftxt = "nothing"

	errprintf("%s found where %s expected\n", ftxt, expected)
	errprintf("{p 4 4 2}\n")
	errprintf("Syntax of parentheses bound list is\n")
	errprintf("{bf:(}{it:evarnamelist}{bf:)=}{it:matrixname}.\n")
	errprintf("{p_end}\n")
	exit(198)
}
	



void add_to_el(`PROBLEM' pr, `SR' evarnamelist, `SS' matname)
{
	`RS'	j

	pr.el = pr.el, &(elinfo())
	j = length(pr.el)
	post_to_el(*(pr.el[j]), evarnamelist, matname, pr.op_replace)
}


void post_to_el(`ELEMENT' el, 
			`SR' evarnamelist, `SS' matname, `boolean' existsok)
{
	`RS'		i, rc
	`SS'		eltype, too, mtyp
	`boolean'	isexpandlist


	/* ------------------------------------------------------------ */

	isexpandlist = 0
	if (length(evarnamelist)==1) {
		if (bsubstr(evarnamelist, -1, 1) == "*") isexpandlist = 1
	}
	/* ------------------------------------------------------------ */
					/* store matrix info		*/

				/* 
				   get_matrix_pointer() checks name
				   and that cols()>=1
				*/
	el.matptr = get_matrix_pointer(el.matname = matname, isexpandlist)

	eltype = eltype(*el.matptr)
	if (eltype == "real") 		el.isnumeric = 1
	else if (eltype == "string") 	el.isnumeric = 0
	else {
		errprintf("matrix {bf:%s} is %s\n", matname, eltype)
		exit(109)
	}

	/* ------------------------------------------------------------ */
					/* store variable(s) info	*/
	if (length(evarnamelist)==0) {
		errprintf("nothing found where variable name expected\n")
		exit(198)
	}
	el.varname = expand_evarnamelist(evarnamelist, cols(*el.matptr))

			/* ------------------- check conformability --- */
	if (length(el.varname) != cols(*(el.matptr))) {
		if (length(el.varname) < cols(*(el.matptr))) {
			too = "too few"
			rc  = 102
		}
		else {
			too = "too many"
			rc  = 103
		}
		mtyp = (cols(*(el.matptr))==1 ? "vector" : "matrix")
		errprintf("%s variables specified for %s {bf:%s}\n", 
			too, mtyp, el.matname)
		exit(rc)
	}


			/* --------------------------- check types --- */
			/* ------------------------check varexists --- */
	el.varexists = J(1, length(el.varname), .)
	for (i=1; i<=length(el.varname); i++) {
		assert_is_name(el.varname[i], "variable")
		if ((el.varexists[i] = (_st_varindex(el.varname[i],0)!=.))) {
			if (!existsok) var_exists_error(el.varname[i])
			assert_vartype_matches(el.varname[i], 
					el.isnumeric, el.matname)
		}
	}
}


`SR' expand_evarnamelist(`SR' evarnamelist, `RS' n)
{
	`RS'	i
	`SS'	basename
	`SR'	toret

	if (length(evarnamelist) != 1) 		return(evarnamelist)
	if (bsubstr(evarnamelist, -1, 1) != "*") return(evarnamelist)

	basename = bsubstr(evarnamelist, 1, strlen(evarnamelist)-1)
	toret = J(1, n, "")
	for (i=1; i<=n; i++) {
		toret[i] = sprintf("%s%g", basename, i)
	}
	return(toret)
}

	
				
void var_exists_error(`SS' varname)
{
	errprintf("variable {bf:%s} already exists\n", varname)
	errprintf("{p 4 4 2}\n")
	errprintf("Either specify a different variable name or\n")
	errprintf("specify {bf:getmata}'s {bf:replace} option.\n")
	errprintf("{p_end}\n")
	exit(110)
}

void assert_vartype_matches(`SS' varname, `boolean' isnumeric, `SS' matname)
{
	`boolean'	isnumvar

	isnumvar = st_isnumvar(varname)
	if (isnumeric & isnumvar) return
	else if (!isnumvar) return

	errprintf("type mismatch\n")
	errprintf("{p 4 4 2}\n")
	errprintf("Existing variable {bf:%s} is %s\n", 
		varname, isnumvar ? "numeric" : "string")
	errprintf("and matrix %s is %s.\n", 
		matname, isnumeric ? "real" : "string")
	errprintf("{p_end}\n") 
	exit(109)
}
	


void assert_is_name(`SS' name, `SS' nametype)
{
	if (!st_isname(name)) {
		errprintf("{bf:%s} invalid %s name\n", name, nametype)
		exit(198)
	}
}
	
pointer(matrix) scalar get_matrix_pointer(`SS' matname, `boolean' isexpandlist)
{
	pointer scalar	p

	assert_is_name(matname, "vector or matrix")

	if ( (p=findexternal(matname)) == NULL) {
		errprintf("vector or matrix {bf:%s} not found\n", matname)
		exit(111)
	}

	if ((cols(*p)==0) & (!isexpandlist)) {
		errprintf("matrix {bf:%s} has 0 columns\n", matname)
		exit(459)
	}
	return(p)
}
	
		

`SR' parse_varnamelist(`SS' varnamelist, `boolean' emptyok)
{
	`RS'	i
	`SR'	list

	if (strtrim(varnamelist)=="") {
		if (emptyok) return(J(1,0,""))
		errprintf("nothing found where variable name expected\n")
		exit(198)
	}

	list = tokens(varnamelist)
	for (i=1; i<=length(list); i++) {
		if (!st_isname(list[i])) {
			errprintf("{bf:%s} invalid variable name\n")
			exit(198)
		}
	}
	return(list)
}


`SS' unabvarname(`SS' uservarname)
{
	`RS'	i
	`SS'	varname

	if ( (varname=strtrim(uservarname)) == "") {
		errprintf("nothing found where variable name expected\n")
		exit(198)
	}
	if (length(tokens(varname)) != 1) {
		errprintf("{p 0 0 2}\n")
		errprintf(
		    `""{bf:%s}" found where single variable name expected\n"',
		    varname)
		exit(198)
		errprintf("{p_end}\n")
		exit(198)
	}

	if ( (i=_st_varindex(varname, 1)) == .) {
		errprintf("variable {bf:%s} not found\n", varname)
		exit(111)
	}
	return(st_varname(i))
}


void assert_varnames_unique(`PROBLEM' pr)
{
	`RS'	i,  j, n_el
	`SC'	varname, bad
	`SS'	s_variable

	varname = J(0, 1, "")
	n_el    = length(pr.el)
	for (i=1; i<=n_el; i++) {
		for (j=1; j<=length(pr.el[i]->varname); j++) {
			varname = varname \ (pr.el[i])->varname[j]
		}
	}

	_sort(varname, 1)

	bad = J(0, 1, "")
	for (i=2; i<=length(varname); i++) {
		if (varname[i]==varname[i-1]) bad = bad \ varname[i]
	}
	if (length(bad)==0) return

	bad = uniqrows(bad)
	s_variable = (length(bad)==1 ? "variable" : "variables")
	errprintf("%s multiply defined\n", s_variable)

	errprintf("\n")
	errprintf("{p 4 4 2}\n")
	errprintf("You attempted to create {bf}\n")
	for (i=1; i<=length(bad); i++) errprintf("%s\n", bad[i])
	errprintf("{rm}more than once.  Perhaps you typed")
	errprintf("\n")
	errprintf("\n")
	errprintf("        . {bf:getmata} ... {bf:%s} ... {bf:%s} ...\n", 
		bad[1], bad[1])

	errprintf("    or\n")
	errprintf("        . {bf:getmata} ... {bf:%s=}...  ... {bf:%s=}...  ...\n", 
		bad[1], bad[1])
	errprintf("    or\n")
	errprintf(
	"        . {bf:getmata} ... {bf:(}... {bf:%s} ... {bf:%s} ...{bf:)=X} ...\n", 
		bad[1], bad[1])
	errprintf("    or\n")
	errprintf(
	"        . {bf:putmata} ... {bf:(}... {bf:%s} ...{bf:)=X} ... {bf:(}... {bf:%s} ...{bf:)=Y} ...\n", 
		bad[1], bad[1])

	errprintf("\n")
	errprintf("{p 4 4 2}\n")
	errprintf("or something else equivalent.\n")

	if (length(bad)>1) {
		errprintf("You did this with {bf:%s}", bad[1])
		if (length(bad)==2) {
			errprintf(" and with {bf:%s}.", bad[2])
		}
		else {
			errprintf(", with {bf:%s}, {it:etc.}\n", bad[2])
		}
	}
	errprintf("{p_end}\n")

	exit(198)
}

void set_minmaxrows(`PROBLEM' pr)
{
	`RS'	i
	`RR'	rows

	rows = J(1, length(pr.el), .)
	for (i=1; i<=length(pr.el); i++) {
		rows[i] = rows(*(pr.el[i]->matptr))
	}
	pr.minrows = rowmin(rows)
	pr.maxrows = rowmax(rows)
}

void assert_row_conformability(`PROBLEM' pr)
{
	`RS'		N

	if (pr.op_force) return

	N = ( pr.op_id ? rows(*(pr.id.matptr)) : st_nobs() )

	if (pr.minrows==N & pr.maxrows==N) return

	errprintf(length(pr.el)==1 ? 
		"rows of matrix != " :
		"rows of matrices != " )
	errprintf(pr.op_id ? "rows of {bf:id()} vector\n" : "_N\n")

	errprintf("{p 4 4 2}\n")
	errprintf(length(pr.el)==1 ? 
		"The matrix contains\n" : 
		"The matrices contain\n")

	if (pr.minrows==pr.maxrows) {
		errprintf("%g\n", pr.minrows)
		errprintf(pr.minrows==1 ? "row\n" : "rows\n")
	}
	else {
		errprintf("between %g and %g rows\n", pr.minrows, pr.maxrows)
	}

	if (pr.op_id) {
		errprintf("and the {bf:id()} vector %s\n", pr.id.matname)
		errprintf("has %g\n", N)
		errprintf(N==1 ? "observation.\n" : "observations.\n")
		errprintf("The vector and matrices being gotten must\n")
		errprintf("have the same number of rows as the\n")
		errprintf("{bf:id()} vector.\n")
	}
	else {
		errprintf("and the data have %g\n", N)
		errprintf(N==1 ? "observation.\n" : "observations.\n")

		errprintf("Specify {bf:putmata}'s option {bf:id()} to\n")
		errprintf("control alignment or specify option {bf:force}\n")
		errprintf("to align with the first observation and to\n")
		errprintf("extend the data if necessary.\n")
	}
	errprintf("{p_end}\n")
	exit(459)
}

void setup_id(`PROBLEM' pr)
{
	colvector	vec

	if (!pr.op_id) return
	pragma unset vec			// vec used to ...
	pragma unused vec
	setup_id_u(pr, vec = *(pr.id.matptr))	// ... pass a copy
}

void setup_id_u(`PROBLEM' pr, pointer(colvector) vec)
{
	`RS'		i_d, i_v
	`RS'		N_d, N_v, N_m
	colvector	data
	colvector	obsno, rowno
	`RC'		p_d, p_v
	`RM'		map
	`boolean'	cont

	data = (st_isnumvar(pr.id.varname) ? 
		st_data(., pr.id.varname) :
		st_sdata(., pr.id.varname) )

	assert_uniq(pr, data, vec)

	N_d = rows(data)
	N_v = rows(vec)

	/* for speed, uncomment this line 
	if (pr.mincols==rows(data) & pr.maxcols==rows(data)) {
		if (vec==data) {
			pr.op_id = `False'
			return
		}
	}
	*/


	if (N_v==0 | N_d==0) {
		pr.id_lhsmap = J(0, 1, .)
		return
	}
		
	_collate(data,         p_d = order(data, 1))
	_collate(obsno=1::N_d, p_d)

	_collate(vec,          p_v = order(vec, 1))
	_collate(rowno=1::N_v, p_v)

	map = J(rowmin((N_d, N_v)), 2, .)
	N_m = 0
	i_d = i_v = 1
	cont = 1
	while (cont) {
		if (cont=goforward(vec, i_v,  data, i_d)) {
			if (cont=goforward(data, i_d, vec, i_v)) {
				if (vec[i_v] == data[i_d]) {
					map[++N_m, 1] = obsno[i_d++]
					map[  N_m, 2] = rowno[i_v++]
					cont = (i_d <= N_d & i_v <= N_v)
				}
			}
		}
	}
	map = (N_m ? map[|1,1\N_m,2|] : J(0, 2, .))
	_sort(map, 2)
	pr.id_lhsmap = map[., 1]
	pr.id_rhsmap = map[., 2]
}


`boolean' goforward(colvector a, `RS' i_a, colvector b, `RS' i_b)
{
	while (a[i_a] < b[i_b]) {
		if ((++i_a) > rows(a)) return(`False')
	}
	return(`True')
}



void assert_uniq(`PROBLEM' pr, colvector data, colvector vec)
{
	`boolean'	data_uniq, vec_uniq
	
	data_uniq = whether_uniq(data)
	vec_uniq  = whether_uniq(vec)

	if (data_uniq & vec_uniq) return

	errprintf("{bf:id()} variable/matrix not proper id\n")
	errprintf("{p 4 4 2}\n")
	if (!data_uniq & !vec_uniq) {
		errprintf("Neither the {bf:id()} variable {bf:%s}\n",
			pr.id.varname)
		errprintf("nor the {bf:id()} vector {bf:%s} contain\n",
			pr.id.matname)
		errprintf("unique identifiers.\n")
	}
	else if (!data_uniq) {
		errprintf("The id() variable {bf:%s}\n", pr.id.varname)
		errprintf("does not contain unique identifiers,\n")
		errprintf("although the {bf:id()} vector\n")
		errprintf("{bf:%s} does.\n", pr.id.matname)
	}
	else {
		errprintf("The id() vector {bf:%s}\n", pr.id.matname)
		errprintf("does not contain unique identifiers,\n")
		errprintf("although the {bf:id()} variable\n")
		errprintf("{bf:%s} does.\n", pr.id.varname)
	}
	errprintf("{bf:id()} values must be unique.\n")
	errprintf("{p_end}\n")
	exit(459)
}
		


`boolean' whether_uniq(colvector x)
{
	return(rows(x) == rows(uniqrows(x))) 
}


void post_variables(`PROBLEM' pr)
{
	`RS'	i

	expand_dataset(pr)

	for (i=1; i<=length(pr.el); i++) {
		post_variables_i(pr, *(pr.el[i]))
	}
}

void expand_dataset(`PROBLEM' pr)
{
	if (st_nobs() < pr.maxrows) {
		st_addobs(pr.maxrows - st_nobs())
	}
}
		

void post_variables_i(`PROBLEM' pr, `ELEMENT' el)
{
	`RS'	j

	for (j=1; j<=length(el.varname); j++) {
		post_variables_i_j(pr, el, *el.matptr, j)
	}
}

void post_variables_i_j(`PROBLEM' pr, `ELEMENT' el, matrix values, `RS' j)
{
	`SS'			varname
	`SS'			dflt_vartype, orig_vartype
	`SS'			comp_vartype, new_vartype
	`RS'			rc, n1, N_up
	`RS'			up_strlen, orig_strlen, up_isstrl, orig_isstrl
	`RS'			maxstrflen
	 colvector		original, tempvar, v
	`boolean'		isnumeric, isvec, noinfo, nodata
	 pointer(`RM') scalar	r

	/* ------------------------------------------------------------ */
					/* increment ret_K counters	*/

	if (el.varexists[j]) pr.ret_K_existing = pr.ret_K_existing + 1
	else		     pr.ret_K_new      = pr.ret_K_new      + 1

	/* ------------------------------------------------------------ */
					/* setup 			*/
	isnumeric    = el.isnumeric
	varname      = el.varname[j]
	N_up         = rows( (pr.op_id ? pr.id_lhsmap : values) )
	noinfo       = (N_up==0)
	nodata       = (st_nobs()==0)
	dflt_vartype = (isnumeric ? (pr.op_double ? "double" : "float") :
				    "str1")

	/* ------------------------------------------------------------ */
					/* handle no data and no info	*/
	if (nodata) {
		if (el.varexists[j]) return
		if (rc = _st_addvar(dflt_vartype, varname)) exit(-rc)
		return
	}

	if (noinfo) {
		if (el.varexists[j]) {
			if (!pr.op_update) {
				if (isnumeric) {
					st_store(.,varname, J(st_nobs(), 1, .))
				}
				else	st_store(.,varname, J(st_nobs(), 1, ""))
			}
		}
		else {
			if (rc = _st_addvar(dflt_vartype, varname)) exit(-rc)
		}
		return
	}

	/* ------------------------------------------------------------ */
				/* handle update & var==updated		*/
	if (el.varexists[j] & pr.op_update) {
		if (has_no_updates(pr, el, values, j)) return
	}
			
	/* ------------------------------------------------------------ */
					/* more setup			*/
	isvec = (cols(values)==1)

	v = (isvec ? values : values[.,j])
	if (pr.op_id) v = v[pr.id_rhsmap]

	if (pr.op_id) 			r   = &( pr.id_lhsmap )
	else if (N_up==st_nobs()) 	r   = &( . )
	else 				r   = &( (1, N_up) )

	/* ------------------------------------------------------------ */
					/* create or recast variable	*/
	
	maxstrflen = st_numscalar("c(maxstrvarlen)") 
	if (isnumeric) {
		if (el.varexists[j]) {
			orig_vartype = st_vartype(varname)
			stata(sprintf("quietly recast double %s", varname))
			if (!pr.op_update) {
				st_store(., varname, J(st_nobs(), 1, .))
			}
		}
		else {
			orig_vartype = ""
			if ((rc = _st_addvar("double", varname))<0) exit(-rc)
		}
	}
	else {
	
		if (el.varexists[j] & !pr.op_update) {
			st_sstore(., varname, J(st_nobs(), 1, ""))
		}

		up_strlen = colmax(strlen(v))
		up_isstrl = 0
		if (up_strlen > maxstrflen) up_isstrl = 1  
		else if (colsum(strpos(v, char(0)))) up_isstrl = 1 

		if (up_isstrl==0) {
			up_strlen = (up_strlen<1 ? 1 : up_strlen)
		}
		if (el.varexists[j]) {
			orig_isstrl = 0
			if(st_vartype(varname) == "strL") {
				orig_isstrl = 1
			}
			if(orig_isstrl) {
				orig_strlen = strtoreal(
					bsubstr(st_vartype(varname), 4, .))
			}
			
			if(up_isstrl==0 & orig_isstrl==0) {
				if (up_strlen > orig_strlen) {
					stata(sprintf("quietly recast str%g %s", 
					rowmax((up_strlen, orig_strlen)), varname))
				}
			}
			else if (up_isstrl==1 & orig_isstrl==0) {
					stata(sprintf("quietly recast strL %s", varname))			
			}
		}
		else {
			if(up_isstrl==0) {
				if ((rc = _st_addvar(sprintf("str%g", up_strlen), 
							varname))<0) exit(-rc)
			}
			else {
				if ((rc = _st_addvar("strL", varname))<0) exit(-rc)			
			}
		}
	}


	/* ------------------------------------------------------------ */
					/* store values			*/
	if (isnumeric) 	st_store(*r, varname, v)
	else           st_sstore(*r, varname, v)
		  
	/* ------------------------------------------------------------ */
					/* compress & possibly recast  */
	if (isnumeric) {
		(void) _stata(sprintf("quietly compress %s", varname))
		comp_vartype = st_vartype(varname)

		if (el.varexists[j]) {
			new_vartype = combine_num_vartype(orig_vartype, 
								comp_vartype)
			if (new_vartype != comp_vartype) {
				(void) _stata(sprintf(
					"quietly recast %s %s, force", 
					new_vartype, varname))
			}
		}
		else {
			if (!pr.op_double & st_vartype(varname)=="double") {
				(void) st_addvar("float", pr.tempname)
				pragma unset original
				st_view(original, ., varname)
				pragma unset tempvar
				st_view(tempvar,  ., pr.tempname)
				tempvar[.] = original
				n1 = colsum(tempvar :== .)
				st_dropvar(pr.tempname)
				if (n1 == colsum(original :== .)) {
					(void) _stata(sprintf(
					    "quietly recast float %s, force", 
					     varname))
				}
			}
		}
	}
	else {
		if (*r==.) {
			(void) _stata(sprintf("quietly compress %s", varname))
		}
	}
}


/*
	user    |  byte    int     long    float   double
	--------+-----------------------------------------
	byte    |  byte    int     long    float   double
	int     |  int     int     long    float   double
	long    |  long    long    long    double  double
	float   |  float   float   double  float   double
	double  |  double  double  double  double  double

*/


`SS' combine_num_vartype(`SS' typ_user, `SS' typ_comp)
{
	if (typ_user=="double") 	return("double")
	if (typ_comp=="double") 	return("double")
	if (typ_comp==typ_user)		return(typ_comp)

	if (typ_user=="float") {
		if (typ_comp=="long")	return("double")
		return("float")
	}

	if (typ_user=="long") {
		if (typ_comp=="float")	return("double")
 		return("long")
	}

	if (typ_user=="int") {
		if (typ_comp=="byte")	return("int")
		return(typ_comp)
	}

	return(typ_comp)
}



`boolean' has_no_updates(`PROBLEM' pr, `ELEMENT' el, matrix v, `RS' j)
{
	colvector	original
	colvector	update
	`RS'		N_up

	N_up    = rows( (pr.op_id ? pr.id_lhsmap : v) )
	if (st_nobs()==0 | N_up==0) return(`True')

	pragma unset original
	if (el.isnumeric) {
		st_view(original, (pr.op_id ? pr.id_lhsmap : .), el.varname[j])
	}
	else   st_sview(original, (pr.op_id ? pr.id_lhsmap : .), el.varname[j])

	if (pr.op_id) {
		update = (rows(v)==1 ? v : v[.,j])[pr.id_rhsmap]
		return(original == update)
	}
	return(original == (rows(v)==1 ? v : v[.,j])) 
}
		

/*
void dump_problem(`PROBLEM' pr)
{
	`RS' 	i


	printf("            op_id = %g\n", pr.op_id)
	printf("       op_replace = %g\n", pr.op_replace)
	printf("        op_update = %g\n", pr.op_update)
	printf("         op_force = %g\n", pr.op_force)
	printf("        op_double = %g\n", pr.op_double)
	printf("	   mincol = %g\n", pr.minrows)
	printf("	   maxcol = %g\n", pr.maxrows)
	printf("    length(pr.el) = %g\n", length(pr.el))

	dump_element(0, pr.id)
	
	for (i=1; i<=length(pr.el); i++) {
		dump_element(i, *(pr.el[i]))
	}
}

void dump_element(`RS' seqno, `ELEMENT' el)
{
	`RS'	j

	printf("%g.  isnumeric=%g (", seqno, el.isnumeric)
	for (j=1; j<=length(el.varname); j++) printf("%s ", el.varname[j])
	printf(") = %s\n", el.matname)
}
*/

end

