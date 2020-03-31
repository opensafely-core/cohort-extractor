*! version 1.2.2  08jul2019

program putmata, rclass
	version 11

	syntax [anything(name=putlist id="putlist" equalok)] [if] [in] ///
		[, OMITmissing REPLACE VIEW]

	marksample touse, novarlist 

	if ("`in'"!="") {
		local in = bsubstr("`in'", 3, .)
	}

	mata: put("`touse'", "`in'")
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

local boolean	`RS'
local		True	1
local		False	0


local BUILDSIZE	100

/* -------------------------------------------------------------------- */
mata:

struct elinfo {
	`boolean'	isnumeric
	`boolean'	hasnumeric
	`SS'		name
	`SR'		contents
}

struct prinfo {
	`boolean'			op_copy
	`boolean' 			op_replace
	`boolean'			op_omitmissing

	`RS'				N

	`RR'				inrange
	`SS'				touse

	pointer(`ELEMENT') rowvector	el
}
	
/* -------------------------------------------------------------------- */

void put(`SS' touse, `SS' in)
{
	`RR'		count
	`PROBLEM'	pr


	setup_problem(pr, touse, in)
					
	parse_putlist(pr)
	assert_names_unique(pr)
/*
	dump_problem(pr) /* wwg */
*/

	if (length(pr.el)==0) {
		st_numscalar("return(K_views)", 0)
		st_numscalar("return(K_copies)", 0)
		st_numscalar("return(N)", .)
		printf("{txt}(0 matrices posted)\n")
		return
	}

			/* Remove this line to allow views onto strLs */
	if (!pr.op_copy) verify_no_strls(pr) 

	set_obs_touse(pr)
	pr.N = count_obs(pr)

	if (pr.op_replace) remove_element_names(pr)
	else	 	   verify_element_names(pr)

	post_elements_to_matrices(pr)

	count = count_elements(pr)
	st_numscalar("return(K_views)",    count[2])
	st_numscalar("return(K_copies)", count[1])
	st_numscalar("return(N)",        pr.N)
}


void setup_problem(`PROBLEM' pr, `SS' touse, `SS' in)
{
	`RS'		l, lb, ub

	pr.touse = touse

	pr.op_copy        = (st_local("view")        == "")  // sic
	pr.op_replace     = (st_local("replace")     != "")
	pr.op_omitmissing = (st_local("omitmissing") != "")

	if ((in=strtrim(in)) != "") {
		l  = strpos(in, "/")
		lb = strtoreal(bsubstr(in,   1, l-1))
		ub = strtoreal(bsubstr(in, l+1,   .))
		pr.inrange = lb, ub
	}
	else	pr.inrange = .
}

/* -------------------------------------------------------------------- */
					/* parsing of <putlist> 	*/

/*
	<putlist> := 
			*                 [<putlist>]
			<name>=<varname>  [<putlist>]
			<name>=(evarlist) [<putlist>}
			<varlist>         [<putlist>]

	<evarlist> :=
			# <evarlist>
			<varlist>
			<varlist> # <evarlist>
*/


void parse_putlist(`PROBLEM' pr)
{
	`SS'	putlist


	if ((putlist = strtrim(st_local("putlist")))=="") {
		parse_putlist_empty()
		/*NOTREACHED*/
	}
	parse_putlist_nonempty(putlist, pr)
}

void parse_putlist_empty()
{
	errprintf("{it:putlist} required\n")
	errprintf(
"    Syntax is   {bf:putmata} {it:putlist} [{bf:if}] [{bf:in}] [{bf:,} {it:options}]\n")
	errprintf("\n")
        errprintf("    To create Mata vectors from specified variables, type\n")
	errprintf("        . {bf:putmata} {it:varname} {it:varname} ...\n")
	errprintf("\n")
        errprintf("    To create Mata vectors from all variables, type\n")
	errprintf("        . {bf:putmata *} ...\n")
	errprintf("\n")
        errprintf("    To create Mata matrices from specified variables, type\n")
	errprintf(
"        . {bf:putmata} {it:matname}{bf:=(}{it:varname varname} ...{bf:)} ...\n")
	exit(100)
}


void parse_putlist_nonempty(`SS' putlist, `PROBLEM' pr)
{
	`Tr'	t
	`SS'	token
	`SS'	varlist

	t = tokeninit(" ", "=", "()")

	tokenset(t, putlist)

	varlist = ""

	for (token=tokenget(t); token != ""; token = tokenget(t)) {
		if (token=="*" | token=="_all") {
			parse_putlist_finish(varlist, pr)
			varlist = "" 
			parse_putlist_star(pr)
		}
		else if (tokenpeek(t)=="=") {
			parse_putlist_finish(varlist, pr)
			varlist = ""
			parse_putlist_name_equal(t, token, pr)
		}
		else {
			varlist = varlist + " " + token
		}
	}
	parse_putlist_finish(varlist, pr)
}

void parse_putlist_star(`PROBLEM' pr)
{
	`RS'	i, n
	`RS'	j
	`SS'	name
	
	n      = st_nvar()
	j      = length(pr.el)
	pr.el  = pr.el, J(1, (pr.touse!="" ? n-1 : n), NULL)

	for (i=1; i<=n; i++) {
		name  = st_varname(i)
		if (name != pr.touse) {
			pr.el[++j] = &(elinfo())
			setelement(*(pr.el[j]), st_isnumvar(i), `False', 
								name, name)
		}
	}
}





void parse_putlist_finish(`SS' varlist, `PROBLEM' pr)
{
	`SR'	names
	`SS'	name
	`RS'	i, j

	// printf("parse_putlist_finish |%s|\n", varlist)

	names = parse_varlist(pr, varlist, 1)
	j     = length(pr.el)
	pr.el = pr.el, J(1, length(names), NULL)
	for (i=1; i<=length(names); i++) {
		name = names[i]
		pr.el[++j] = &(elinfo())
		setelement(*(pr.el[j]), st_isnumvar(name), `False', name, name)
	}
}
	

void parse_putlist_name_equal(`Tr' t, `SS' name, `PROBLEM' pr)
{
	`RS'	j
	`SS'	token
	`SR'	contents

	(void) tokenget(t)		// skip equal sign

	token = tokenget(t)
	if (bsubstr(token,1,1) == "(") {
		parse_putlist_name_equal_paren(name, token, pr)
		return
	}

	// token contains contents

	contents = parse_varlist(pr, token, 0)

	pr.el = pr.el, &(elinfo())
	j     = length(pr.el)
	setelement(*(pr.el[j]), st_isnumvar(contents), `False', name, contents)
}

void parse_putlist_name_equal_paren(`SS' name, `SS' list, `PROBLEM' pr)
{
	`RS'		i, j
	`SS'		evarlist
	`SR'		contents
	`boolean'	isnumeric, hasnumeric

	pragma unset hasnumeric

	evarlist = bsubstr(list, 1, strlen(list)-1)
	contents = parse_evarlist(pr, bsubstr(evarlist, 2, .), 0, hasnumeric)

	isnumeric = isnumvar_or_number(contents[1])
	for (i=2; i<=length(contents); i++) {
		if (isnumvar_or_number(contents[i]) != isnumeric) { 
			errprintf("matrix {bf:%s} would be of mixed type\n",
									name)
			errprintf("{p 4 4 2}\n")
			errprintf("When creating {bf:%s=(...)},\n", name)
			errprintf("the variables inside the parentheses\n")
			errprintf("must all be real or all be string.\n")
			errprintf("If numeric constants appear inside the\n")
			errprintf("parentheses, any variables that also\n")
			errprintf("appear must be numeric.\n")
			errprintf("{p_end}\n")
			exit(109)
		}
	}
	pr.el = pr.el, &(elinfo())
	j     = length(pr.el)
	setelement(*(pr.el[j]), isnumeric, hasnumeric, name, contents)
}


`boolean' isnumvar_or_number(`SS' s)
{
	`RS'	r

	pragma unset r

	if (_strtoreal(s, r)==0) return(1)
	return(st_isnumvar(s))
}


/*	________				     __________
	contents = parse_evarlist(pr, evarlist, emptyok, hasnumeric)
				  --  --------  -------  

	returns 1xk of variables or numeric constants to be placed 
	in element.  Sets hasnumeric=`True' if any numeric constants.
*/

`SR' parse_evarlist(`PROBLEM' pr, `SS' evarlist, `boolean' emptyok, `boolean' hasnumeric)
{
	`SR'	result, toparse

	result = J(1, 0, "")
	hasnumeric = `False'

	if (strtrim(evarlist)=="") {
		if (emptyok) return(result)
		errprintf("{p 0 0 2}\n")
		errprintf("nothing found in parentheses where\n")
		errprintf("extended varlist expected\n")
		errprintf("{p_end}\n")
		errprintf("{p 4 4 2}\n")
		errprintf("Syntax is {it:name}{bf:=(}{it:evarlist}{bf:)}\n")
		errprintf("where {it:evarlist} contains varlist and/or\n")
		errprintf("numeric constants.\n")
		errprintf("{p_end}\n")
		exit(198)
	}

	toparse = split_on_number(evarlist)
	while (length(toparse)==3) {
		hasnumeric = `True'
		result = (result, parse_varlist(pr, toparse[1], 1), toparse[2])
		toparse = split_on_number(toparse[3])
	}
	return((result, parse_varlist(pr, toparse, 1)))
}


/*
	split_on_number(evarlist) processes strings of the form

		(1)     [<varlist>] # [<evarlist>]
		(2)     [<varlist>]

	N.B., returned value is 1x1 or 1x3.

	If string of form 1, returned is 1x3 vector containing the 
	three pieces (pieces that do not appear are "").

	If string of form 2, returned is 1x1 containing the input.
*/

`SR' split_on_number(`SS' evarlist)
{
	`Tr'	t
	`SS'	token, lhs
	`RS'	r

	t = tokeninit(" ", "", "()")
	tokenset(t, evarlist)
	lhs = ""
	pragma unset r
	while ((token=tokenget(t))!="") {
		if (_strtoreal(token, r)==0) {
			return((strtrim(lhs), token, strtrim(tokenrest(t))))
		}
		lhs = lhs + " " + token
	}
	return(evarlist)
}
	
	
	

`SR' parse_varlist(`PROBLEM' pr, `SS' varlist, `boolean' emptyok)
{
	`RS'	rc
	`SS'	result

	if (emptyok) {
		if (strtrim(varlist)=="") return(J(1,0,""))
	}
	rc = _stata(sprintf("unab _parse_varlist : %s", varlist))
	if (rc) exit(rc)

	if (pr.touse != "") {
		rc = _stata(sprintf("local _parse_varlist : list _parse_varlist - touse"))
		if (rc) exit(rc)
	}

	result = st_local("_parse_varlist")
	st_local("_parse_varlist", "")
	return(tokens(result))
}


void setelement(`ELEMENT' el, 
	`boolean' isnumeric, `boolean' hasnumeric, `SS' name, `SR' contents)
{
	el.isnumeric  = isnumeric
	el.hasnumeric = hasnumeric
	el.name       = name
	el.contents   = contents
}

void assert_names_unique(`PROBLEM' pr)
{
	`RS'	i, n
	`SC'	name, bad
	`SS'	s_matrix

	name = J(n=length(pr.el), 1, "")
	for (i=1; i<=n; i++) name[i] = (pr.el[i])->name
	_sort(name, 1)

	bad = J(0, 1, "")
	for (i=2; i<=n; i++) {
		if (name[i]==name[i-1]) bad = bad \ name[i]
	}
	if (length(bad)==0) return

	bad = uniqrows(bad)
	s_matrix = (length(bad)==1 ? "matrix" : "matrices")
	errprintf("%s multiply defined\n", s_matrix)

	errprintf("\n")
	errprintf("{p 4 4 2}\n")
	errprintf("You attempted to create {bf}\n")
	for (i=1; i<=length(bad); i++) errprintf("%s\n", bad[i])
	errprintf("{rm}more than once.  Perhaps you typed")
	errprintf("\n")
	errprintf("\n")
	errprintf("        . {bf:putmata} ... {bf:%s} ... {bf:%s} ...\n", 
		bad[1], bad[1])

	errprintf("    or\n")
	errprintf(
	"        . {bf:putmata} ... {bf:%s=(}...{bf:)} ... {bf:%s} ...\n", 
		bad[1], bad[1])
	errprintf("    or\n")
	errprintf(
	"        . {bf:putmata} ... {bf:%s=(}...{bf:)} ... {bf:%s=(}...{bf:)} ...\n", 
		bad[1], bad[1])

	if (length(bad)>1) {
		errprintf("\n")
		errprintf("{p 4 4 2}\n")
		errprintf("You did this with {bf:%s}", bad[1])
		if (length(bad)==2) {
			errprintf(" and with {bf:%s}.", bad[2])
		}
		else {
			errprintf(", with {bf:%s}, {it:etc.}\n", bad[2])
		}
		errprintf("{p_end}\n")
	}

	exit(198)
}
	


					/* parsing of <putlist> 	*/
/* -------------------------------------------------------------------- */
					/* set observations to use	*/

/*
	set_obs_touse(pr)
		if option -omitmissing- specified, updates 
		touse variable to exclude missing values
*/

void set_obs_touse(`PROBLEM' pr)
{
	`RS'	i, j, k
	`RS'	nvars
	`SC'	vars
	`SR'	v

	if (!pr.op_omitmissing) return 

	nvars = 0 
	for (i=1; i<=length(pr.el); i++) {
		nvars = nvars + length(numeric_varnames_of_el(*(pr.el[i])))
	}
	vars = J(nvars, 1, "")
	k    = 0
	for (i=1; i<=length(pr.el); i++) {
		v = numeric_varnames_of_el(*(pr.el[i]))
		for (j=1; j<=length(v); j++) vars[++k] = v[j]
	}
	if (length(vars)==0) return
	vars = uniqrows(vars)

	stata(sprintf("markout %s %s", pr.touse, invtokens(vars')))
}

`RS' count_obs(`PROBLEM' pr)
{
	`RC'	touse

	if (pr.touse=="") {
		if (pr.inrange==(.,.)) return(st_nobs())
		return(pr.inrange[2]-pr.inrange[1]+1)
	}
	pragma unset touse
	st_view(touse, pr.inrange, pr.touse)
	return(colsum(touse))
}

		
					/* set observations to use	*/
/* -------------------------------------------------------------------- */
					/* element name verification	*/


void verify_element_names(`PROBLEM' pr)
{
	`RS'	i
	`SR'	problem

	problem = J(1, 0, "")
	for (i=1; i<=length(pr.el); i++) {
		if (findexternal(pr.el[i]->name)!=NULL) {
			problem = problem, pr.el[i]->name
		}
	}
	if (length(problem)) {
		errprintf("{p 0 4 2}\n")
		errprintf("the following Mata matrices already exist:\n")
		for (i=1; i<=length(problem); i++) {
			errprintf("%s\n", problem[i])
		}
		errprintf("{p_end}\n")
		errprintf("{p 4 4 2}\n")
		errprintf("You can specify option {bf:replace} to replace\n")
		errprintf("existing matrices.\n")
		errprintf("{p_end}\n")
		exit(110)
	}
}
		

void remove_element_names(`PROBLEM' pr)
{
	`RS'		i

	for (i=1; i<=length(pr.el); i++) {
		if (findexternal(pr.el[i]->name) != NULL) {
			rmexternal(pr.el[i]->name)
		}
	}
}

					/* element name verification	*/
/* -------------------------------------------------------------------- */
					/* post elements		*/

void post_elements_to_matrices(`PROBLEM' pr)
{
	`RS'		i, n, nv, nm

	n  = length(pr.el)
	nv = nm = 0
	for (i=1; i<=n; i++) {
		post_matrix(pr, *(pr.el[i]))
		if ( cols((pr.el[i])->contents) == 1) ++nv
	}
	nm = n - nv
	printf("{txt}(")
	if (nv+nm) {
		if (nv) {
			printf("%g %s", nv, (nv==1 ? "vector" : "vectors"))
			if (nm) printf(", ")
		}
		if (nm) {
			printf("%g %s", nm, (nm==1 ? "matrix" : "matrices"))
		}
		printf(" posted)\n") 
	}
	else	printf("(0 vectors and matrices posted)\n")
}

void post_matrix(`PROBLEM' pr, `ELEMENT' el)
{
	pointer(`Tr') scalar	p
	
	p = crexternal(el.name)
	if (el.hasnumeric) {
		*p = post_matrix_mixed(pr.inrange, el.contents, pr.touse, pr.N)
	}
	else if (pr.op_copy) {
		if (el.isnumeric) {
			*p = st_data(pr.inrange, el.contents, pr.touse)
		}
		else 	*p = st_sdata(pr.inrange, el.contents, pr.touse)
	}
	else {
		if (el.isnumeric) {
			st_view(*p, pr.inrange, el.contents, pr.touse)
		}
		else 	st_sview(*p, pr.inrange, el.contents, pr.touse)
	}
}


`RM' post_matrix_mixed(`RR' inrange, `SR' contents, `SS' touse, `RS' N)
{
	`RS'	i
	`RC'	r
	`RM'	X

	X = J(N, 0, .)

	for (i=1; i<=length(contents); i++) {
		pragma unset r
		if (_strtoreal(contents[i], r)==0) {
			X = X, J(N, 1, r)
		}
		else {
			r  = find_i0i1(contents, i)
			X = X, st_data(inrange, contents[|r|], touse)
			i = r[2]
		}
	}
	return(X)
}


`RC' find_i0i1(`SR' contents, `RS' i0)
{
	`RS'	i, r

	for (i=i0; i<=length(contents); i++) {
		pragma unset r
		if (_strtoreal(contents[i], r)==0) return(i0\i-1)
	}
	return(i0\length(contents))
}
	

					/* post elements		*/
/* -------------------------------------------------------------------- */
					/* return value count		*/
`RR' count_elements(`PROBLEM' pr)
{
	`RS'	i, n, na

	n = length(pr.el)
	if (pr.op_copy) return((n, 0))

	na = 0
	for (i=1; i<=n; i++) na = na + (pr.el[i])->hasnumeric
	return((na, n-na))
}

					/* return value count		*/
/* -------------------------------------------------------------------- */
					/* utilities			*/


`SR' numeric_varnames_of_el(`ELEMENT' el)
{
	return(el.isnumeric ? el.contents : J(1, 0, ""))
}


void verify_no_strls(`PROBLEM' pr) 
{
	if (!has_strls(pr)) return 

	errprintf("strLs not allowed\n") 
	errprintf("{p 4 4 2}\n")
	errprintf("You may not form views onto strLs.\n") 
	errprintf("Either omit the {bf:view} option or omit the\n") ; 
	errprintf("strL variables.\n") ; 
	errprintf("{p_end}\n")
	exit(109)
	/*NOTREACHED*/
}

`boolean' has_strls(`PROBLEM' pr) 
{

	`RS'	i
	for (i=1; i<=length(pr.el); i++) {
		if (has_strls_j(*(pr.el[i]))) return(`True') 
	}
	return(`False') 
}

`boolean' has_strls_j(`ELEMENT' el)
{
	`RS'	j

	for (j=1; j<=length(el.contents); j++) {
		if (st_vartype(el.contents[j])=="strL") return(`True') 
	}
	return(`False')
}

		
/*
void dump_problem(`PROBLEM' pr)
{
	`RS' 	i

	printf("   op_omitmissing = %g\n", pr.op_omitmissing)
	printf("          op_copy = %g\n", pr.op_copy)
	printf("       op_replace = %g\n", pr.op_replace)
	printf("    length(pr.el) = %g\n", length(pr.el))

	for (i=1; i<=length(pr.el); i++) {
		dump_element(i, *(pr.el[i]))
	}
}

void dump_element(`RS' seqno, `ELEMENT' el)
{
	`RS'	j
	printf("%g.  name |%s|  isnumeric=%g", seqno, el.name, el.isnumeric)
	for (j=1; j<=length(el.contents); j++) {
		printf(" %s", el.contents[j])
	}
	printf("\n")
}
*/


					/* utilities			*/
/* -------------------------------------------------------------------- */
	
end
