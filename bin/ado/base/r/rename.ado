*! version 1.0.10  23sep2019

/*
	Syntax:

		rename <oldname> <newname>       [, <op1>]

		rename (<oldnames>) (<newnames>) [, <op1>]

		rename  <oldnames>               , {upper|lower|proper} [<op2>]


		     <op1> :=	addnumber[(#)]
				renumber[(#)]
				sort
				<opstd>
				<opnotdocumented>

		     <op2> :=	<opstd>
				<opnotdocumented>

		   <opstd> :=	dryrun
				r
		

	 <opnotdocumented> :=	debug
				test

	-----------------------------------------------------------
	Below, we use 

		<oldnames> := <oldpatterns>

		<newnames> := <newpatterns>

	Syntax is, 

		<oldpatterns> := <oldpattern>
				 (<oldpattern> [<oldpattern>]...)

		<oldpattern>  := <unadorned_varlist>
				 <adorned_varname>

	  <unadorned_varlist> := <varname> [<unadorned_varlist>]
				 <varname>-<varname> [<unadorned_varlist>]

		
	    <adorned_varname> := [<adorned_varname>]<*>[<adorned_varname>]
			      := <adorned_varname><#>[<adorned_varname>]
			      := [<adorned_varname>]<?>[<adorned_varname>]
			      := [<adorned_varname>]<c>[<adorned_varname>]

			  <*> := *

			  <#> := {# | (#) | (##) | ...}
			         {# | (#) | (##) | ...}<subscript>

			  <?> := {? | ?? | ??? | ...}
			      := {? | ?? | ??? | ...}


	The grammar is written sloppily above.  For instance, 
	"**" is not allowed.

	-----------------------------------------------------------

		<newpatterns> := <newpattern>
				 (<newpattern> [<newpattern>]...)
	
		<oldpattern>  := <unadorned_varlist>
				 <adorned_varname>
			
	  <unadorned_varlist> := <varname> [<unadorned_varlist>]

	    <adorned_varname> := [<adorned_varname>]<ch>[<adorned_varname>]

		         <ch> := <c>
				  .
				  =
				 <w>
				 <w><subscript>

			  <c> := {_|a|b|...|z|A|B|...|Z|0|1|...|9}

			  <w> := <*>
				 <?>
				 <#>

			  <#> := {# | (#) | (##) | ...}

			  <?> := {? | ?? | ??? | ...}

		  <subscript> := [<number>]     (brackets significant)

		     <number> := <a base 10 integer >= 1> 


	The above grammar is also written sloppily, but perhaps not as 
	much as the <oldpatterns> grammar.  "**" is allowed.
*/

/* ==================================================================== */
					/* main ado file		*/
program rename
	version 12

	mata: rename_cmd("`3'")
	/* 
	   It is important no commands that set r() be given after 
	   the call to mata: rename_cmd().  
	*/
end

					/* main ado file		*/
/* ==================================================================== */



/* -------------------------------------------------------------------- */
					/* type definitions, etc.	*/
version 12

local RS		real scalar
local RR		real rowvector
local RC		real colvector
local RM		real matrix
local SS		string scalar
local SR		string rowvector
local SC		string colvector
local SM		string matrix
local TC		transmorphic colvector

local CodeS		`RS'

local TokenEnv		transmorphic

local boolean		real scalar
local True		1
local False		0

local Linkloc		rename_linklocdf
local LinklocS		struct `Linkloc' scalar

local Rename		rename_renamedf
local RenameS		struct `Rename' scalar

local Pattern		rename_patterndf
local PatternS		struct `Pattern' scalar
local PatternR		struct `Pattern' rowvector

local Pel		rename_peldf
local PelS		struct `Pel' scalar
local PelR		struct `Pel' rowvector

local Option		rename_optiondf
local OptionS		struct `Option' scalar



local Token		string 
local TokenS		`Token' scalar

local ElementType	real
local ElementTypeS	`ElementType' scalar
local ETstrlist		(1)
local ETstr		(2)
local ETstar		(3)
local ETqm		(4)
local ETnum_v		(5)
local ETnum_f		(6)
local ETeq		(7)
local ETodot		(8)
local ET_numberof	(8)
					/* extended ElementType codes */
local ETnum_v_r		(9)
local ETnum_f_r		(10)

local PatternType	real
local PatternTypeS	`PatternType' scalar
local PTold		0
local PTnew		1

local MaxDigits		10		// used by (###..#)


mata:

struct `Pel' {				// Pel := Pattern Element
	`TokenS'	element
	`ElementTypeS'	elementtype
	`RS'		arg
	`RS'		match		// used by new patterns only
}

struct `Pattern' {			// Pattern := Pattern
	`PatternTypeS'	patterntype
	`SS'		original
	`PelR'		ellist
	`RR'		n_of
	`SR'		varnames
	`SM'		pieces		// used by old patterns only
}

struct `Option' {
	`boolean'	isrecase
	`boolean'	isrecase_upper, isrecase_lower, isrecase_proper
	`boolean'	isdryrun
	`boolean'	isrenumber, isaddnumber
	`RS'		from
	`boolean'	issort
	`boolean'	isdebug
	`boolean'	istest
	`boolean'	isr
}
void `Option'_init(`OptionS' option)
{
	option.isrecase = option.isdryrun = `False'
	option.isrecase_upper = option.isrecase_lower  = 
				option.isrecase_proper = `False'

	option.isrenumber = option.isaddnumber = `False'
	option.from       = 1
	option.issort     = `False'
	option.isdebug	  = `False'
	option.istest     = `False'
	option.isr        = `False'
}


struct `Rename' {
	`PatternR'	oldplist
	`PatternR' 	newplist
	`OptionS'	option
}

					/* type definitions, etc.	*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* main routines		*/

void rename_cmd(`SS' thirdarg)
{
	`SS'	input

	input = st_local("0")
	if (thirdarg == "") { 
		if (can_do_fast(input)) return
	}
	rename_cmd_u(input)
}


/*	_______
	whether = can_do_fast(input)
			      -----

	    Checks whether Stata's old built-in two-argument -rename- 
	    can be used to execute request and executes it that way 
	    if so.
	    Returns
		`True' 		yes it can, and was
		`False'		no it cannot
		abort		yes it can, it was, and it errored-out

	    This routine is included so that the command implemented here 
	    can displace the old -rename- command without sacrificing 
	    performance for those executing 10,000s of -rename- commands 
	    in tight loops.
*/
		

`boolean' can_do_fast(`SS' input)
{
	`SR'	token
	`RS'	rc

	token = tokens(input)
	if (length(token)!=2) return(`False')
	if (!st_isname(token[1])) return(`False')
	if (!st_isname(token[2])) return(`False')
	if (token[1] == token[2]) return(`False')
	if (rc=_stata("_rename " + input)) {
		exit(rc)
	}
	return(`True')
}


/*
	(void) rename_cmd_u(input)
			    -----

	    Executes -rename- using new logic and providing new features.
*/

void rename_cmd_u(`SS' input)
{
	`RenameS'	ren

	parse_cmd(ren, input)

	if (ren.option.isdebug) {
		dump_pattern(ren.oldplist, "old after parsing", `False')
		dump_pattern(ren.newplist, "new after parsing", `False')
	}

	if (ren.option.isrecase) 	xeq_recase(ren)
	else				xeq_old_to_new(ren)
}


/*			      ___
	(void) xeq_old_to_new(ren)
			      ---

	    Execute explicit old-to-new request.
	    Input has been parsed and filled into ren.oldplist and 
	    ren.newplist.
*/
	 
void xeq_old_to_new(`RenameS' ren)
{
	make_patternlist_lengths_equal(ren)

	link_patterns(ren)

	if (ren.option.isdebug) {
		dump_pattern(ren.oldplist, "old after linkage", `False')
		dump_pattern(ren.newplist, "new after linkage", `False')
	}

	fillin_old_varnames(ren.oldplist, ren.newplist, ren.option.issort)
	if (ren.option.isdebug) {
		dump_pattern(ren.oldplist, "old final", `True')
	}

	if (ren.option.issort) {
		sort_old_varnames(ren)
	}

	fillin_new_varnames(ren.oldplist, ren.newplist, ren.option.from)
	if (ren.option.isdebug) {
		dump_pattern(ren.newplist, "new final", `True')
	}

	perform_renames(build_toren(ren.oldplist, ren.newplist), ren.option)
}


/*			  ___
	(void) xeq_recase(ren)
			  ---
	    Execute rename, rescase request.
	    Parsing has been performed, and the oldnames have been 
	    parsed in to ren.oldplist.  ren.newplist is still 
	    uninitialized
*/

void xeq_recase(`RenameS' ren)
{
	build_recase_newpattern(ren)
	fillin_old_varnames(ren.oldplist, ren.newplist, `False')
	fillin_new_varnames_recase(ren)
	if (ren.option.isdebug) {
		dump_pattern(ren.oldplist, "old final", `True')
		dump_pattern(ren.newplist, "new final", `True')
	}
	perform_renames(build_toren(ren.oldplist, ren.newplist), ren.option)
}

					/* main routines		*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* parse user input		*/

void parse_cmd(`RenameS' ren, `SS' input)
{
	`RS'		c
	`SS'		lhs, ops
	`SS'		oldnames, newnames

	/* ------------------------------------------------------------ */
					/* split on comma: <lhs>, <ops> */
	
	if ((c = parse_cmd_commaloc(input))) {
		lhs = strtrim(bsubstr(input,   1, c-1))
		ops = strtrim(bsubstr(input, c+1,   .))
	}
	else {
		lhs = strtrim(input)
		ops = ""
	}
	input = ""				// done with `SS' input

	/* ------------------------------------------------------------ */
					/* parse <ops>			*/

	parse_cmd_options(ren.option, ops)
	ops = ""				// done with `SS' ops
	if (ren.option.isdebug) dump_options(ren)

	/* ------------------------------------------------------------ */
				/* parse <lhs> := <oldnames> <newnames> */

	pragma unset oldnames
	pragma unset newnames
	if (ren.option.isrecase) {
		if (bsubstr(lhs,1,1)!="(") {
			lhs = "(" + lhs + ")"
		}
	}
	getarg(lhs, oldnames, lhs)
	getarg(lhs, newnames, lhs)
	if (lhs!="") return(error_syntax())

	/* ------------------------------------------------------------ */
					/* check syntax			*/
	if (oldnames=="") return(error_syntax())
	if (ren.option.isrecase) {
		if (newnames!="") return(error_syntax())
	}
	else	if (newnames=="") return(error_syntax())

	/* ------------------------------------------------------------ */
				/* parse <oldnames> and <newnames>	*/

	parse_cmd_pat_els(ren.oldplist, oldnames, `PTold')
	if (!ren.option.isrecase) {
		parse_cmd_pat_els(ren.newplist, newnames, `PTnew')
	}
}


/*	_
	c = parse_cmd_commaloc(s)
			       -

	    Find comma in <lhs>, <options>
	    Returns
		0	there is no comma
		>=1	location of comma
		abort	paren nesting invalid
*/
	

`RS' parse_cmd_commaloc(`SS' s)
{
	`RS'	i, L
	`RS'	nestlev
	`SS'	c 

	nestlev = 0 
	L       = bstrlen(s)
	for (i=1; i<=L; i++) { 
		c = bsubstr(s, i, 1)
		if (!nestlev) {
			if (c==",") return(i)
		}
		if (c=="(") ++nestlev 
		else if (c==")") {
			if ((--nestlev) < 0) {
				error_parens_unbalanced()
				/*NOTREACHED*/
			}
		}
	}
	return(0) 
}


/*			     ___  ____
	(void) getarg(input, arg, rest)
		      -----

	    Get argument from `SS' input.
	    Returns
		arg	argument gotten
		rest	left over (for next call)

	    Note, input and rest may be the same `SS'.

	    Also note, 
		  <arg> := <token>
		        := (<anything>)

		<token> := /* anything not containing blank */
	     <anything> := /* literally anything, including more parens */
*/


void getarg(`SS' input, `SS' arg, `SS' rest)
{
	`RS'	L, npar, i
	`SS'	c
	

	if (bsubstr(input, 1, 1)=="(") {
		L    = bstrlen(input)
		npar = 1 
		for (i=2; i<=L; i++) {
			c = bsubstr(input, i, 1)
			if (c=="(") ++npar
			else if (c==")") {
				if ((--npar)<=0) {
					if (npar<0) error_parens_unbalanced()
					arg = strtrim(bsubstr(input, 2, i-2))
					rest= strtrim(bsubstr(input, i+1, .))
					return
				}
			}
		}
		error_parens_unbalanced()
	}
	if ((L = strpos(input, " "))) {
			arg = strtrim(bsubstr(input, 1, L-1))
			rest= strtrim(bsubstr(input, L+1, .))
			return 
	}
	arg = strtrim(input) 
	rest= ""
}

					/* parse user input		*/
/* -------------------------------------------------------------------- */
					/* option parsing		*/

/*				 ______
	(void) parse_cmd_options(option, ops)
				         ---

	    string scalar ops contains option string starting after the 
	    separating comma.
	    Returns:
		void	success
		abort	option error
*/


void parse_cmd_options(`OptionS' option, `SS' ops)
{
	`SS'		token
	`TokenEnv'	t

	`Option'_init(option)

	t = tokeninit(" ", ",", "()")
	tokenset(t, ops)

	while ((token=tokenget(t)) != "") parse_cmd_options_u(option, token, t)

	confirm_options_consistent(option)
}


/*
	(void) confirm_options_consistent(option)
					  ------
	    Returns
		void	consistent
		abort	inconsistent
*/

void confirm_options_consistent(`OptionS' option)
{
	`SR'	list

	pragma unset list
	if (option.isrecase_upper)  list = list, "upper"
	if (option.isrecase_lower)  list = list, "lower"
	if (option.isrecase_proper) list = list, "proper"

	if (length(list) > 1) {
		errprintf("options {bf:%s}", list[1])
		if (length(list)==2) errprintf(" and {bf:%s}", list[2])
		else errprintf(", {bf:%s}, and {bf:%s}", list[2], list[3])
		errprintf(" cannot be specified together\n")
		exit(198)
	}

	if (option.isrecase & option.isrenumber) {
		errprintf(
	"options {bf:%s} and {bf:renumber} cannot be specified together\n",
		list[1])
		exit(198)
	}
	if (option.isrecase & option.isaddnumber) {
		errprintf(
	"options {bf:%s} and {bf:addnumber} cannot be specified together\n",
		list[1])
		exit(198)
	}

/*
	if (option.issort & !(option.isrenumber | option.isaddnumber)) {
		errprintf("{p 0 0 2}\n")
		errprintf("option {bf:sort} may be specified only if option\n")
		errprintf( "{bf:renumber}[{bf:()}] or\n")
		errprintf("{bf:addnumber}[{bf:()}] is also specified\n")
		errprintf("{p_end}\n")
		exit(198)
	}
*/
}


/*				   ______	  _
	(void) parse_cmd_options_u(option, token, t)
					   -----  -

	    Parse current token (token stream t) into option.
	    Returns
		void		parsed
		abort		option invalid
*/

void parse_cmd_options_u(`OptionS' option, `SS' token, `TokenEnv' t)
{
	if (parse_cmd_options_u_std(option, token)) {
		return
	}
	if (parse_cmd_options_u_number(option, token, t)) return 
	option_not_allowed(token)
}


/*	_____				______
	valid = parse_cmd_options_u_std(option, source)
					------	------

	    Parse one-word option source into option.  All options are 
	    treated as one-word options.  If more follows the option, 
	    e.g., renumber(#), that is handled after the word 
	    renumber is identified.

	    Returns
		`True'		option parsed
		`False'		option invalid, caller must issue error

	
*/

`boolean' parse_cmd_options_u_std(`OptionS' option, `SS' source)
{
	`RS'	l

	l = bstrlen(source)

	if (source=="debug") {
		option.isdebug = `True'
	}
	else if (source == bsubstr("dryrun",1, l)) {
		option.isdryrun = `True'
	}
	else if (source == bsubstr("lower", 1, l)) {
		option.isrecase = option.isrecase_lower = `True'
	}
	else if (source == bsubstr("proper",1, l)) {
		option.isrecase = option.isrecase_proper= `True'
	}
	else if (source == "r") {
		option.isr = `True'
		st_rclear()
	}
	else if (source == bsubstr("sort", 1, l)) {
		option.issort = `True'
	}
	else if (source == "test") {
		option.istest = `True'
	}
	else if (source == bsubstr("upper", 1, l)) {
		option.isrecase = option.isrecase_upper = `True'
	}
	else 	return(`False')
	return(`True')
}


/*	_____				   ______	   _
	valid = parse_cmd_options_u_number(option, source, t)
					   ------  ------  -

	    Parse {renumber|addnumber}[(#)] option into option.
		   -----    ------
	    Returns
		`True'		option parsed
		`False'		option invalid, caller must issue error
*/
		

`boolean' parse_cmd_options_u_number(`OptionS' option, `SS' source, 
								`TokenEnv' t)
{
	`SS'		token
	`RS'		from
	`RS'		l
	`SS'		op

	if (option.isrenumber | option.isaddnumber)  return(`False')

	l = bstrlen(source)
	if (source==bsubstr("renumber", 1, max((5, l)))) {
		option.isrenumber = `True'
		op                = "renumber"
	}
	else if (source==bsubstr("addnumber", 1, max((6, l)))) {
		option.isaddnumber = `True' 
		op                 = "addnumber"
	}

	token = tokenpeek(t)
	if (bsubstr(token, 1, 1) != "(") {
		option.from       = 1
		return(`True')
	}

	token = tokenget(t)
	if (bsubstr(token, 1, 1) != "(" |
	    bsubstr(token,-1, 1) != ")") option_number_misspecified(op)
	token = bsubstr(token, 2, bstrlen(token)-2)

	pragma unset from
	if (_strtoreal(token, from)) option_number_misspecified(op) 
	if (from<0 | from>999999) option_number_misspecified(op)
	option.from       = from
	return(`True')
}



					/* option parsing		*/
/* -------------------------------------------------------------------- */
					/* pattern parsing		*/

/*
	A pattern is something like "ab?c*d#".
	The pattern elements, a.k.a elements, are ab, ?, c, *, d, #.
*/


/*				 ___
	(void) parse_cmd_pat_els(pat, toparse, pattype)
				      -------  -------

	    Parse pattern contained in toparse of type pattype into pat.
	    A pattern is formally equivalent to a pattern-element list.
	    Thus, in the code below, a pattern is called <els>, plural 
	    of <el>, and suggesting a pattern-element list.

	             <els> := <el> [<el> ...]

	              <el> := <namelist>
		           := <wcpat>

	        <namelist> := <name> [<namelist>]
		           := <name> - <name> [<namelist>]

	           <wcpat> := <token containing wildcard characters>

	    Returns
		void		pattern parsed
		abort		pattern invalid
*/

void parse_cmd_pat_els(`PatternR' pat, `SS' toparse, `PatternType' pattype)
{
	`SS'		token, curlist
	`TokenEnv'	t
	`boolean'	first

	t = tokeninit(" ", "-", "")
	tokenset(t, toparse)
	curlist = ""
	first   = `True'
	while ((token=tokenget(t))!="") {
		if (!st_isname(token)) {
			if (token=="-") {
				error_preceding_dash(pattype)
				/*NOTREACHED*/
			}
			if (!first) {
				parse_cmd_pat_el(pat, curlist, pattype)
				curlist  = ""
				first    = `True'
			}
			parse_cmd_pat_el(pat, token, pattype)
		}
		else {
			if (first) {
				curlist = token
				first   = `False'
			}
			else	curlist = curlist + (" " + token)

			if (tokenpeek(t)=="-") { 
				(void)  tokenget(t)
				token = tokenget(t)
				if (!st_isname(token)) {
					error_following_dash(pattype, token)
					/*NOTREACHED*/
				}
				curlist= curlist + ("-" + token)
			}
		}
	}
	if (!first) parse_cmd_pat_el(pat, curlist, pattype)
}



/*				___
	(void) parse_cmd_pat_el(pat, token, pattype)
				---  -----  -------

	    Parse pattern element contained in token of type pattype into pat.
	    Returns
		void		pattern element parsed
		abort		pattern element invalid
*/

void parse_cmd_pat_el(`PatternR' pat, `SS' token, `PatternType' pattype)
{
	`SS'		mytoken
	`PatternS' 	mypat 
	`RS'		i, j
	`RM'		found

	mypat.patterntype = pattype
	mypat.original    = mytoken = token 
	mypat.n_of        = J(1, `ET_numberof', 0)

	confirm_not_empty(mytoken, pattype==`PTold' ?  
				"varname or pattern" :
				"newvarname or pattern")

	if (strpos(mytoken, " ") | strpos(mytoken, "-")) {
		set_pat_ETstrlist(mypat, mytoken)
		pat = pat, mypat		/* returned result	*/
		return
	}
		
	while (mytoken!="") {
		found = J(0, 2, .)
		if (i=strpos(mytoken, "*")) found = (found \ (i, `ETstar'))
		if (i=strpos(mytoken, "?")) found = (found \ (i, `ETqm' ))
		if (i=strpos(mytoken, "#")) found = (found \ (i, `ETnum_v'))
		if (i=strpos(mytoken, "(")) found = (found \ (i, `ETnum_f'))
		if (i=strpos(mytoken, "=")) found = (found \ (i, `ETeq'))
		if (i=strpos(mytoken, ".")) found = (found \ (i, `ETodot'))


		if (!rows(found)) mytoken = set_pat_str(mypat, mytoken) 
		else {
			_sort(found, 1)
			j = found[1,1]
			i = found[1,2]
			if (i==`ETstar') {
				mytoken = set_pat_ETstar(mypat, mytoken, j)
				mytoken = set_subscript(mypat, mytoken, pattype)
			}
			else if (i==`ETqm') {
				mytoken = set_pat_ETqm(mypat, mytoken, j)
				mytoken = set_subscript(mypat, mytoken, pattype)

			}
			else if (i==`ETnum_v') {
				mytoken = set_pat_ETnum_v(mypat, mytoken, j)
				mytoken = set_subscript(mypat, mytoken, pattype)
			}
			else if (i==`ETnum_f') {
				mytoken = set_pat_ETnum_f(mypat, mytoken, j)
				mytoken = set_subscript(mypat, mytoken, pattype)
			}
			else if (i==`ETeq') {
				mytoken = set_pat_ETeq(mypat, mytoken, j)
			}
			else if (i==`ETodot') {
				mytoken = set_pat_ETodot(mypat, mytoken, j)
			}
			else	assert(0)
		}
	}
	pat = pat, mypat			/* returned result	*/
}

`SS' set_subscript(`PatternS' pat, `SS' token, `PatternType' pt)
{
	`RS'	i
	`SS'	c
	

	if (bsubstr(token, 1, 1) != "[") return(token)
	if (pt != `PTnew') {
		error_subscripts_in_old(pat)
		/*NOTREACHED*/
	}

	if (pt != `PTnew') 		return(token)
	for (i=2; 1; i++) {
		c = bsubstr(token, i, 1)
		if (c=="]") break 
		if (c=="") {
			error_no_right_bracket(pat.original)
			/*NOTREACHED*/
		}
	}

	if ( (pat.ellist[length(pat.ellist)].match = 
	      strtoreal(bsubstr(token, 2, i-2))) == .) {
		error_inside_brackets(pat.original)
		/*NOTREACHED*/
	}

	return(bsubstr(token, i+1, .))
}
	

/*			         ___
	(void) set_pat_ETstrlist(pat, token)
			         ---  -----

	    Parse token as ETstrlist (cannot fail) and store in pat.
	    Returns
		void		cannot fail

	   This set_pat_*() is different from the rest in that there is 
	   no remaining string to be returned
*/

void set_pat_ETstrlist(`PatternS' pat, `SS' token)
{
	`PelS'		el

	el.element     = token 
	el.elementtype = `ETstrlist'
	el.arg         = 0
	pat.n_of[`ETstrlist'] = pat.n_of[`ETstrlist'] + 1
	pat.ellist     = pat.ellist, el
}


/*	____		   ___
	rest = set_pat_str(pat, token)
			   ---  -----

	    Parse token as ETstr and store in pat.
	    Returns
		""	successfully parsed
*/
	

`SS' set_pat_str(`PatternS' pat, `SS' token)
{
	`PelS'		el

	el.element     = token 
	el.elementtype = `ETstr'
	el.arg         = ustrlen(token)
	pat.n_of[el.elementtype] = pat.n_of[el.elementtype] + 1
	pat.ellist     = pat.ellist, el
	return("")
}


/*	____		      ___
	rest = set_pat_ETstar(pat, token, loc)
			      ---  -----  ---

	    Parse token at loc as ETstar, prior to loc as ETstr.
	    Returns
		rest	bsubstr(token, loc+1, .)
*/


`SS' set_pat_ETstar(`PatternS' pat, `SS' token, `RS' loc) 
{
	`PelS'		el

	if (loc>1) {
		(void) set_pat_str(pat, bsubstr(token, 1, loc-1))
	}

	if (pat.patterntype == `PTold' && length(pat.ellist)) {
		if (pat.ellist[length(pat.ellist)].elementtype == `ETstar') {
			error_starstar_not_allowed()
			/*NOTREACHED*/
		}
	}
	
	el.element     = "*"
	el.elementtype = `ETstar'
	el.arg         = .
	pat.ellist     = pat.ellist, el
	pat.n_of[el.elementtype] = pat.n_of[el.elementtype] + 1
	return(bsubstr(token, loc+1, .))
}


/*	____		       ___
	rest = set_pat_ETnum_v(pat, token, loc)
			       ---  -----  ---

	    Parse token at loc as ETnum_v, prior to loc as ETstr.
	    Returns
		rest	bsubstr(token, loc+1, .)
*/

`SS' set_pat_ETnum_v(`PatternS' pat, `SS' token, `RS' loc) 
{
	`PelS'		el

	if (loc>1) {
		(void) set_pat_str(pat, bsubstr(token, 1, loc-1))
	}

	if (pat.patterntype == `PTold' && length(pat.ellist)) {
		if (pat.ellist[length(pat.ellist)].elementtype == `ETnum_v') {
			error_hashhash_not_allowed_old()
			/*NOTREACHED*/
		}
	}
/*
	else if (pat.patterntype == `PTnew' && length(pat.ellist)) {
		if (pat.ellist[length(pat.ellist)].elementtype == `ETnum_v') {
			error_hashhash_not_allowed_new()
			/*NOTREACHED*/
		}
	}
*/

	el.element     = "#"
	el.elementtype = `ETnum_v'
	el.arg         = .
	pat.ellist     = pat.ellist, el
	pat.n_of[el.elementtype] = pat.n_of[el.elementtype] + 1
	return(bsubstr(token, loc+1, .))
}


/*	____		    ___
	rest = set_pat_ETeq(pat, token, loc)
			    ---  -----  ---

	    Parse token at loc as ETeq, prior to loc as ETstr.
	    Returns
		rest	bsubstr(token, loc+1, .)
*/


`SS' set_pat_ETeq(`PatternS' pat, `SS' token, `RS' loc) 
{
	`PelS'	el

	if (loc>1) {
		(void) set_pat_str(pat, bsubstr(token, 1, loc-1))
	}

	if (pat.patterntype == `PTold') {
		error_equal_in_oldname()
		/*NOTREACHED*/
	}

	el.element     = "="
	el.elementtype = `ETeq'
	el.arg         = .
	pat.ellist     = pat.ellist, el
	pat.n_of[el.elementtype] = pat.n_of[el.elementtype] + 1
	return(bsubstr(token, loc+1, .))
}


/*	____		      ___
	rest = set_pat_ETodot(pat, token, loc)
			      ---  -----  ---

	    Parse token at loc as ETodot, prior to loc as ETstr.
	    Returns
		rest	bsubstr(token, loc+1, .)
*/


`SS' set_pat_ETodot(`PatternS' pat, `SS' token, `RS' loc) 
{
	`PelS'	el

	if (loc>1) {
		(void) set_pat_str(pat, bsubstr(token, 1, loc-1))
	}

	if (pat.patterntype == `PTold') {
		error_dot_in_oldname()
		/*NOTREACHED*/
	}

	el.element     = "."
	el.elementtype = `ETodot'
	el.arg         = .
	pat.ellist     = pat.ellist, el
	pat.n_of[el.elementtype] = pat.n_of[el.elementtype] + 1
	return(bsubstr(token, loc+1, .))
}


/*	____		    ___
	rest = set_pat_ETqm(pat, token, loc)
			    ---  -----  ---

	    Parse token at loc as ETqm, prior to loc as ETstr.
	    Returns
		rest	bsubstr(token, loc+1, .)
*/


`SS' set_pat_ETqm(`PatternS' pat, `SS' token, `RS' loc) 
{
	`PelS'	el

	if (loc>1) {
		(void) set_pat_str(pat, bsubstr(token, 1, loc-1))
	}

	el.element     = "?"
	el.elementtype = `ETqm'
	el.arg         = 0
	pat.ellist     = pat.ellist, el
	pat.n_of[el.elementtype] = pat.n_of[el.elementtype] + 1
	return(bsubstr(token, loc+1, .))
}



/*	____		       ___
	rest = set_pat_ETnum_f(pat, token, loc)
			       ---  -----  ---

	    Parse token at loc as ETnum_f, prior to loc as ETstr.
	    Returns
		rest	token starting at end of ETnum_f

	    Note, ETnum_f is (#), (##), ...
*/
	

`SS' set_pat_ETnum_f(`PatternS' pat, `SS' token, `RS' loc) 
{
	`PelS'		el
	`RS'		j

	if (loc>1) {
		(void) set_pat_str(pat, bsubstr(token, 1, loc-1))
	}

	for (j=loc+1; bsubstr(token, j, 1)=="#"; j++) ;
	if (bsubstr(token, j, 1) != ")") {
		error_parens_unbalanced()
		/*NOTREACHED*/
	}

	el.elementtype = `ETnum_f'
	el.element     = "(#)"
	el.arg         = j - loc - 1
	if (el.arg > `MaxDigits') {
		error_ETnum_f_too_long(el.arg)
		/*NOTREACHED*/
	}
	pat.ellist     = pat.ellist, el
	pat.n_of[el.elementtype] = pat.n_of[el.elementtype] + 1
	return(bsubstr(token, j+1, .))
}

					/* pattern parsing		*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* Pattern linkage verification	*/


/*					      ___
	(void) make_patternlist_lengths_equal(ren)
					      ---

	    Make length(ren.oldplist)==length(ren.plist) equal if 
	    not already equal, or abort if they cannot be made equal.
	    Returns
		abort	length(ren.oldplist) < length(ren.newplist)
		void	lengths were equal or now are equal
*/
	    
void make_patternlist_lengths_equal(`RenameS' ren)
{
	if (length(ren.oldplist) == length(ren.newplist)) return

	
	while (length(ren.newplist) < length(ren.oldplist)) {
		ren.newplist = 
			ren.newplist, ren.newplist[length(ren.newplist)]
	}
		
	if (length(ren.oldplist) != length(ren.newplist)) {
		error_patternlengths_unequal(ren.oldplist, ren.newplist)
		/*NOTREACHED*/
	}
}

	


/*				       ___
	(void) build_recase_newpattern(ren)
				       ---

	    This routine is the equivalent of make_patternlist_lengths_equal(),
	    but for use in when recasing ren.oldplist.  In this case, 
	    a phony-but-adequate ren.newplist is built from ren.oldplist.
	    Returns
		void		pattern built
*/

void build_recase_newpattern(`RenameS' ren)
{
	`RS'	i

	ren.newplist = `Pattern'(length(ren.oldplist))

	for (i=1; i<=length(ren.newplist); i++) {
		ren.newplist[i].patterntype = -1
		ren.newplist.original       = "recase"
	     // ren.newplist                = <omitted> 
		ren.newplist[i].n_of        = J(1, `ET_numberof', 0)
	     // ren.newplist[i].varnames    = <omitted>
	     // ren.newplist[i].pieces      = <omitted>
	}
}



/* -------------------------------------------------------------------- */
				/* pattern linkage			*/

/*			     ___
	(void) link_patterns(ren)
			     ---

            For all i: 

	    1. Verify that the pattern elements in each ren.oldplist[i] is
               compatible (links) with each ren.newplist[i].

	    2.  Fill in ren.newplist[i].ellist[j].match, which specifies 
		that this pattern element links with old pattern element 
		ren.oldplist[i].ellist[match]

	    Returns, 
		abort		problem; error message issued
		void		patterns confirmed and linked
*/


void link_patterns(`RenameS' ren)
{
	`RS'	i, jn

	assert(length(ren.oldplist)==length(ren.newplist))

	for (i=1; i<=length(ren.oldplist); i++) {

		jn = check_and_fix_ETnum(ren.newplist[i], ren.option) 
		link_patterns_u(ren.oldplist[i], ren.newplist[i], jn)
	}
}


/*	__		         ____
	jn = check_and_fix_ETnum(newp, option)
			         ----  ------ 

	    if option.isrenumber|option.isaddnumber, 
		1. confirm that there is at least one # in newp
		2. confirm that there is no more than one # 
		3. Change elementtype to renumber/addnumber elementtype
	    else
		1. do nothing
	    Returns
		abort		(error message issued)
		-1		!option.isaddnumber
		>0		option.isaddnumber, index of
*/

`RS' check_and_fix_ETnum(`PatternS' newp, `OptionS' option)
{
	`RS'		n, j, jn
	`ElementTypeS'	tt

	if (!(option.isrenumber | option.isaddnumber)) return(-1)

	n = 0
	for (j=1; j<=length(newp.ellist); j++) {
		tt = newp.ellist[j].elementtype
		if (tt==`ETnum_v' | tt==`ETnum_f') {
			(void) ++n 
			jn = j
			newp.ellist[j].elementtype = 
				(tt==`ETnum_v' ? `ETnum_v_r' : `ETnum_f_r')
		}
	}
	if (n==0) {
		error_missing_ETnum(
			option.isrenumber ? "renumber" : "addnumber", 
			newp)
		/*NOTREACHED*/
	}
	if (n>1) {
		error_too_many_renumbers(
			option.isrenumber ? "renumber" : "addnumber", 
			newp)
		/*NOTREACHED*/
	}

	return(option.isaddnumber ? jn : -1)
}

/*			     ____  ____
	(void_ link_patterns(oldp, newp, jn)
			     ----  ----  --

	    Link refers to filling in newp.ellist[].match with m, 
	    the index of the matching corresponding pattern element in 
	    oldp.ellist. 
            
	    Link oldp and newp. 

	    if jn==-1, then newp has no -addnumber- pattern element.
	    Otherwise, newp.ellist[jn] is the pattern element 
	    corresponding to -addnumber-, which is not linked to a 
	    pattern element in oldp.

	    In parsing, newp.ellist[j].match may have been filled 
	    in with nonmissing values for some j.  If so, that is 
	    the user-specified index of the wildcard in oldp.ellist[] 
	    to which the user wants the newp.ellist[j] element linked.
	    In that case, link_patterns() maps the wildcard index to 
	    its corresponding pel-index value.
*/


struct `Linkloc' {
	`RS'	j_old, last_sequential_j_old
	`RS'	j_new
	`RS'	jn
	`RR'	mapsub
}
void `Linkloc'_init(`LinklocS' ll, `RS' jn)
{
	ll.j_old = ll.last_sequential_j_old = ll.j_new = 0
	ll.jn    = jn 
	/* ll.mapsub is already 1x0 */
}

/*			      __
	(void) `Linkloc'_next(ll, oldp, newp)
			      --  ----  ----

	    Sets ll.j_old and ll.j_new to next pattern elements to 
	    be linked.
*/
	

void `Linkloc'_next(`LinklocS' ll, `PatternS' oldp, `PatternS' newp)
{
	`RS' subscr

	/* ------------------------------------------------------------ */
					/* find next wildcard in newp	*/
					/* skipping element ll.jn 	*/

	ll.j_new = find_next_wildcard(newp.ellist, ll.j_new)
	if (ll.j_new == ll.jn) {
		if (newp.ellist[ll.jn].match != .) {
			error_newnumber_subscripted(oldp, newp)
			/*NOTREACHED*/
		}
		ll.j_new = find_next_wildcard(newp.ellist, ll.jn)
	}

	subscr = (ll.j_new ? newp.ellist[ll.j_new].match : .)
	
	/* ------------------------------------------------------------ */
					/* for next oldp, use subscr    */
					/* if we have it, else use next */
					/* oldp				*/

	if (subscr == .) {
		ll.j_old = ll.last_sequential_j_old = 
			find_next_wildcard(oldp.ellist, ll.last_sequential_j_old)
	}
	else {
		ll.j_old = map_subscript(subscr, ll.mapsub, oldp, newp)
	}
}

/*	_______				______
	pel_idx = map_subscript(subscr, mapsub, oldp, newp)
				------  ------  ----  ----

	    Maps wildcard subscript to pel index using mapsub. 
	    If mapsub has not been filled in yet, mapsub is filled in.
	    oldp and newp are used solely for error messages.
	    Returns, 
		pel_idx		success
		abort		error, message issued
*/

`RS' map_subscript(`RS' subscr, `RR' mapsub, `PatternS' oldp, `PatternS' newp)
{
	if (!length(mapsub)) mapsub = pelidx_of_wcidx(oldp)
	if (subscr<1 | subscr>length(mapsub)) {
		error_subscript_invalid(oldp, newp, subscr)
		/*NOTREACHED*/
	}
	return(mapsub[subscr])
}
	

	
void link_patterns_u(`PatternS' oldp, `PatternS' newp, `RS' jn)
{
	`LinklocS'	ll

	/* ------------------------------------------------------------ */
	`Linkloc'_init(ll, jn)

	/* ------------------------------------------------------------ */
	`Linkloc'_next(ll, oldp, newp)
	while (ll.j_old & ll.j_new) {
		confirm_wildcards_link(oldp, ll.j_old, newp, ll.j_new)
		newp.ellist[ll.j_new].match = ll.j_old
	     // oldp.ellist[ll.j_old].match = ll.j_new

		`Linkloc'_next(ll, oldp, newp)
	}
	if (ll.j_new == 0) return 
	error_too_many_wildcards(oldp, newp, jn>0)
	/*NOTREACHED*/
}


/*	______
	mapvec = pelidx_of_wcidx(oldp)
				 ----

	    Build a vector to map wildcard-index to pel-index.
	    E.g., consider the old pattern 

			   1   2   3         wildcard index
			   |   |   |
			abc*def#ghi?jkl
                         | | | | | | |
                         1 2 3 4 5 6 7       pel index

	    mapvec would be (2, 4, 6) in this case.
	    wildcards are in the metric in which users think, and are 
	    all oldp.ellist[] elements except `ETstrlist' and `ETstr'.

	    Returns
		mapvec    1 x n vector, n = # of wildcards, 0 <= n
*/
		  
`RR' pelidx_of_wcidx(`PatternS' oldp)
{
	`RR'		toret
	`RS'		i
	`ElementTypeS'	tt

	toret = J(1, 0, .)
	for (i=1; i<=length(oldp.ellist); i++) {
		tt = oldp.ellist[i].elementtype
		if (tt!=`ETstrlist' & tt!=`ETstr') toret = (toret, i)
	}
	return(toret)
}



void confirm_wildcards_link(`PatternS' oldp, `RS' j_old, 
			    `PatternS' newp, `RS' j_new)
{
	`ElementTypeS'	tt_old, tt_new
	
	/* ------------------------------------------------------------ */
					/* new elementtype		*/

	tt_new = newp.ellist[j_new].elementtype
	if (tt_new == `ETstar') return
	if (tt_new == `ETodot')  return

	/* ------------------------------------------------------------ */
					/* old elementtype		*/

	tt_old = oldp.ellist[j_old].elementtype

	/* ------------------------------------------------------------ */
					/* compare			*/

	/*
				new
			-----------------------------------
		old	*	?	#	#r	.
		--------------------------------------------
		*	o	X1	X3	o	o
		?	o	o	X4	o	o
		#	o	X2	o	o	o
		--------------------------------------------
		o=okay, X=not_allowed.  # after indicates where handled.
		#r is # when option.isrenumber
		This routine not called when option.isaddnumber, 
		# when option.isaddnumber is not linked.

		Details:
			 * = ET_star
			 ? = ET_qm
			 # = ET_num_v   | ET_num_f   
			#r = ET_num_v_r | ET_num_f_r
			 . = ET_odot
	*/

	/* ------------------------------------------------------------ */
					/* X1 and X2			*/

	if (tt_new == `ETqm') {
		if (tt_old == `ETqm') return 
		error_wildcardmatch_qm(oldp, j_old, newp, j_new)
		/*NOTREACHED*/
	}

	/* ------------------------------------------------------------ */
					/* X3 and X4			*/

	if (tt_new==`ETnum_v' | tt_new==`ETnum_f') {
		if (tt_old==`ETnum_v' | tt_old==`ETnum_f') return
		error_wildcardmatch_hash(oldp, j_old, newp, j_new)
		/*NOTREACHED*/
	}

	/* ------------------------------------------------------------ */
}


/*
void add_r_to_ETnum(`PelS' el)
{
	if      (el.elementtype==`ETnum_v') el.elementtype = `ETnum_v_r'
	else if (el.elementtype==`ETnum_f') el.elementtype = `ETnum_f_r'
}
*/



`SS' printable_wildcard(`PelS' el)
{
	`ElementTypeS' 	tt 

	tt = el.elementtype
	if (tt == `ETstar')  return("*")
	if (tt == `ETqm')    return("?")
	if (tt == `ETodot')  return(".")
	if (tt == `ETnum_v') return("#")
	if (tt == `ETnum_f') return("(" + el.arg*"*" + ")")
	return("!")
}



`RS' count_wildcards(`PatternS' pat)
{
	return(pat.n_of[`ETstar']  + 
	       pat.n_of[`ETqm']    +
	       pat.n_of[`ETnum_v'] +
	       pat.n_of[`ETnum_f'] +
	       pat.n_of[`ETodot'])
}

`boolean' is_wildcard(`ElementTypeS' tt)
{
	return( tt == `ETstar'  |
		tt == `ETqm'    |
		tt == `ETnum_v' |
		tt == `ETnum_f' |
		tt == `ETnum_v_r' |
		tt == `ETnum_f_r' |
		tt == `ETodot'  )
}

`RS' find_next_wildcard(`PelR' d, `RS' j0)
{
	`RS'	j

	for (j=j0+1; j<=length(d); j++) {
		if (is_wildcard(d[j].elementtype)) return(j)
	}
	return(0)
}


/* unused routine 
`RS' index_of_ETnum(`PelR' ellist)
{
	`RS'		j
	`ElementTypeS'	tt

	for (j=1; j<=length(ellist); j++) {
		tt = ellist[j].elementtype 
		if (tt==`ETnum_v' | tt==`ETnum_f') return(j)
	}
	return(0) 
}
*/

				/* pattern linkage			*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
				/* fill in old variable names		*/


/*				   ________
	(void) fillin_old_varnames(oldplist, newplist, issort)
				   --------  --------  ------

	    For all i, fill in oldplist[i].varnames based on the patterns
	    recorded in oldplist[i].  newplist[] is passed to this 
	    routine for use in error messages.
	    Returns, 
		void		oldplist[i].varnames filled in
		abort		error; error message issued
*/
	    

void fillin_old_varnames(`PatternR' oldplist, `PatternR' newplist, 
							`boolean' issort)
{
	`RS'	i
	`SS'	tmpname

	tmpname = st_tempname()
	for (i=1; i<=length(oldplist); i++) {
		fillin_old_varnames_u(oldplist[i], newplist[i], issort, tmpname)
	}
}


/*				   ____
	(void) fillin_old_varnames(oldp, newp, issort, tmpname)
				   ----  ----  ------  -------

	    Actions
		1. fill in oldp.varnames 
		2. fill in oldp.ellist[*].pieces if necessary
*/

void fillin_old_varnames_u(`PatternS' oldp, `PatternS' newp, 
					`boolean' issort, `SS' tmpname)
{
	`SR'		varnames, piece
	`RS'		i, n, nvars, nels
	`SM'		pieces
	`ElementTypeS'	tt
	`boolean'	filter_varlist, fillin_pieces

	/* ------------------------------------------------------------ */
				/* set logic flags			*/

	filter_varlist = (oldp.n_of[`ETnum_v'] + oldp.n_of[`ETnum_f'] != 0)

	fillin_pieces  = (newp.n_of[`ETnum_v'] + newp.n_of[`ETnum_f'] +
			  newp.n_of[`ETstar']  + newp.n_of[`ETqm']    != 0)

	if (issort) fillin_pieces = `True'


	/* ------------------------------------------------------------ */
				/* obtain the varlist for pattern	*/


	oldp.varnames = expand_varlist(varlistpattern(oldp.ellist), tmpname)
	nvars         = length(oldp.varnames)

				/* remove _vars if appropriate		*/
	if (!filter_varlist) {
		if (length(oldp.ellist)) {
			tt = oldp.ellist[1].elementtype 
			if (tt==`ETstar' | tt==`ETqm') {
				oldp.varnames = select(oldp.varnames, 
						bsubstr(oldp.varnames,1,1):!="_")
				nvars         = length(oldp.varnames)
			}
		}
	}


	/* ------------------------------------------------------------ */
				/* initialize pieces as unfilled in	*/

	nels          = length(oldp.ellist)
	oldp.pieces   = J(0, nels, "")

	/* ------------------------------------------------------------ */
				/* perform matching			*/


	if (fillin_pieces & !filter_varlist) {
		oldp.pieces = J(nvars, nels, "")
		pragma unset piece
		for (i=1; i<=nvars; i++) {
			assert(
			    matchvarname(piece, oldp.ellist, oldp.varnames[i])
			      )
			oldp.pieces[i,.] = piece
		}
	}
	else if (fillin_pieces & filter_varlist) {
		varnames    = J(    1, nvars, "")
		pieces      = J(nvars,  nels, "")
		n = 0
		for (i=1; i<=nvars; i++) {
			if (matchvarname(piece, oldp.ellist, oldp.varnames[i])) {
				varnames[++n] = oldp.varnames[i]
				pieces[n,.]   = piece
			}
		}
		if (n) {
			oldp.varnames = varnames[|1\n|]
			oldp.pieces   = pieces[|1,1\n,nels|]
		}
		else 	oldp.varnames = J(1, 0, "")
	}
	else if (filter_varlist) {
		varnames    = J(    1, nvars, "")
		n = 0
		for (i=1; i<=nvars; i++) {
			if (matchvarname(piece, oldp.ellist, oldp.varnames[i])) {
				varnames[++n] = oldp.varnames[i]
			}
		}
		if (n) {
			oldp.varnames = varnames[|1\n|]
		}
		else 	oldp.varnames = J(1, 0, "")
	}
}


/*	_____________
	stata_pattern = varlistpattern(ellist)
				       ------

	    Return pattern understandable by Stata based on 
	    pattern stored in ellist.  Note that resulting stata_pattern
	    may result in more variables being selected that would 
	    the richer pattern in ellist.
	    Returns, 
		stata_pattern	pattern usable by Stata
*/

`SS' varlistpattern(`PelR' ellist)
{
	`RS'	j
	`SS'	result

	if (ellist[1].elementtype == `ETstrlist') return(ellist[1].element)

	result = ""
	for (j=1; j<=length(ellist); j++) { 
		result = result + varlist_el(ellist[j])
	}
	return(result)
}

`SS' varlist_el(`PelS' el)
{
	if (el.elementtype == `ETstr')    return(el.element)
	if (el.elementtype == `ETstar')   return("*")
	if (el.elementtype == `ETqm')     return("?")
	if (el.elementtype == `ETnum_v')  return("?*")
	if (el.elementtype == `ETnum_f')  return(el.arg*"?")
	assert(0)
	/*NOTREACHED*/
}

				/* fill in old variable names		*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
				/* input variable pattern matching	*/

/*
	pieces to filled in:  [j0, j1)
	string to use:        [i0, i1)
*/


end
local Matchres	real scalar
local		MRfailure	-1
local		MRirrel		0
local 		MRsuccess	1
local Match	rename_matchdf
local MatchS	struct `Match' scalar

local Exboolean	real scalar
local NotDone	(-1)

local Side	real scalar
local		Left	1
local		Right	0

local MatchDone		(m.i1<=m.i0 & m.j0<=m.j1)
local MatchNotDone	(m.i1 >m.i0 & m.j1> m.j0)

mata:

struct `Match' {
	`RS'	j0, j1
	`RS'	i0, i1
	`SS'	name
	`SR'	pieces
}

/*		     ______
	matchvarname(pieces, ellist, name)
			     ------  ----

	    Given a candidate variable, name, determine if it matches 
	    ellist, if it does, fill in pieces, and return `True'; 
	    else return `False'.

	    Example:  
		Assume ellist records pattern a*b#.

		If name = "aextrabx", it does not match the pattern, 
		and `False' is returned.

		If name = "aextrab23", it does match the pattern.
		pieces is filled in ("a", "extra", "b", "23") and 
		`True' is returned.

	    Returns
		`True'		name matches, pieces filled in
		`False'		name does not match
*/


`boolean' matchvarname(`SR' pieces, `PelR' ellist, `SS' name)
{
	`MatchS'	m

	if (length(ellist)) {
		if (ellist[1].elementtype==`ETstrlist') {
			pieces = name
			return(`True')
		}
	}

	match_setup(m, ellist, name)
	if (!match_step(m, ellist)) return(`False')
	pieces = m.pieces
	return(`True')
}


/*			   _
	(void) match_setup(m, ellist, name)
			      ------  ----

	    Initializes m to match name and pattern elements in ellist.
	    name is stored in m.  ellist is passed along to other 
	    routines along with m
*/

void match_setup(`MatchS' m, `PelR' ellist, `SS' name)
{
	m.i0     = m.j0 = 1
	m.i1     = ustrlen(name)+1
	m.j1     = length(ellist)+1
	m.name   = name
	m.pieces = J(1, length(ellist), "")
}

/*
/*
	The following routine is useful for debugging
*/

void match_dump(`SS' txt, `MatchS' m)
{
	`RS' 	i ; 

	printf("Match Dump %s\n", txt) ;
	printf("     |%s| [i0,i1) = [%g,%g)  ", m.name, m.i0, m.i1) 
	printf(": |%s|", usubstr(m.name, m.i0, m.i1-m.i0))
	printf("       [j0,j1) = [%g,%g)\n", m.j0, m.j1)

	printf("     ") ; 
	for (i=1; i<=length(m.pieces); i++) { 
		printf("|%s| ", m.pieces[i]) ; 
		if (i!=length(m.pieces)) printf(" + ") ; 
	}
	printf("\n") ; 
}
*/


/*	__              _
	mr = match_step(m, ellist)
			-  ------

	Perform matching of m.name with pattern in ellist.
	Returns
		`True'		pattern matches 
		`False'		pattern does not match

	Explanation of code logic:
	This routine may be (and is) called recursively.
	The routine's basic logic is

	    1. Perform Simplification Step, which removes 
	       all fixed-length patterns (ETstr, ETqm, and 
	       ETnum_f) from both ends.

            2. At that point, you have 0, 1, 2, or more remaining
	       patterns to match.  
		a.  0:  done.
		b.  1:  must be ETnum_v or ETstar.
		c.  2:  must be (ETstar, ETnum_v) or vice-versa
		d. 3+:  Four possibilities:
				ET_num_v ... ETnum_v
				ET_numv  ... ETstar
				ET_star  ... ETnum_v
				ET_star  ... ETstar
*/

`boolean' match_step(`MatchS' m, `PelR' ellist)
{
	`RS'		lefttomatch
	`Matchres'	mr
	`Exboolean'	r


	while (1) {
		if ((r=match_query_done(m))!=`NotDone') return(r)

		if (match_simplification(m, ellist)==`MRfailure') return(`False')
		if ((r=match_query_done(m))!=`NotDone') return(r)

		lefttomatch = m.j1 - m.j0
		if (lefttomatch==1) {
			if (match_step_1(m, ellist)==`MRfailure') return(`False')
			if ((r=match_query_done(m))!=`NotDone') return(r)
			return(`False')
		}
		else if (lefttomatch==2) {
			mr = match_step_2(m, ellist)
			if (mr==`MRfailure' | mr==`MRirrel') return(`False')
		}
		else {
			mr = match_step_3p(m, ellist)
			if (mr==`MRfailure' | mr==`MRirrel') return(`False')
		}
	}
	/*NOTREACHED*/
}

/*	__                _
	mr = match_step_1(m, ellist)
			  -  ------

	    If there is only one pattern element left, it must be 
	    * (ET_star) or # (ET_num_v).  Match it.
	    Returns
		`MRsuccess'	 last token matched
		`MRfailure'	 last token does not match
		abort-with-error last token not as expected

*/

`Matchres' match_step_1(`MatchS' m, `PelR' ellist)
{
	if (ellist[m.j0].elementtype==`ETnum_v') {
		return(match_ETnum_v(m, ellist, `Left'))
	}
	if (ellist[m.j0].elementtype==`ETstar') {
		return(match_ETstar_left(m, ellist))
	}
	return(`MRfailure')
	// assert(0)
	/*NOTREACHED*/
}

/*	__		  _
	mr = match_step_2(m, ellist)
			  -  ------

	If there are two pattern elements left, they must be *# or #*.
	Either way, the # must be done first.
	    Returns
		`MRsuccess'	 # (ET_num_v) matched
		`MRfailure'	 # (ET_num_v) does not match
		abort-with-error # (ET_num_v) not found
*/

`Matchres' match_step_2(`MatchS' m, `PelR' ellist)
{
	if (ellist[m.j0].elementtype==`ETnum_v') {
		return(match_ETnum_v(m, ellist, `Left'))
	}
	if (ellist[m.j0+1].elementtype==`ETnum_v') {
		return(match_ETnum_v(m, ellist, `Right'))
	}
	return(`MRfailure')
	// assert(0)
}

/*	__		   _
	mr = match_step_3p(m, ellist)
			   -  ------

	if there are three or more patterns left, they must be
		*...*	handle left  * first
		*...#	handle right # first
		#...*	handle left  # first
		#...#	handle left  # first
		
	If there are two pattern elements left, they must be *# or #*.
	Either way, the # must be done first.
	    Returns
		`MRsuccess'	 # (ET_num_v) matched
		`MRfailure'	 # (ET_num_v) does not match
		abort-with-error # (ET_num_v) not found
*/

`Matchres' match_step_3p(`MatchS' m, `PelR' ellist)
{
	`RS'	j

	if (ellist[m.j0].elementtype==`ETstar') {
		j = m.j1-1 
		if (ellist[j].elementtype==`ETstar') {
			return(match_ETstar_left(m, ellist))
		}
		if (ellist[j].elementtype==`ETnum_v') {
			return(match_ETnum_v(m, ellist, `Right'))
		}
		assert(0)
	}
	if (ellist[m.j0].elementtype==`ETnum_v') {
		return(match_ETnum_v(m, ellist, `Left'))
	}
	return(`MRfailure')
}
	

/*	________________
	extended_boolean = match_query_done(m)
					    -

	Checks whether all patterns are matched.
	Returns
		`True'		done; pattern fully matched
		`False'		done; pattern did not match
		`NotDone'	not done

	`NotDone' means either 
	    1.  there are characters left in m.name awaiting match, 
		and pattern elements in ellist waiting to be matched.

	    2.  There are no characters left in m.name awaiting match, 
		but there are pattern elements in ellist waiting to be
		matched.  (Perhaps they will match with <nothing>.)

	`False' really corresponds to
	    1.  All patterns in ellist are matched, but there are 
		still characters left in m.name.
*/


`Exboolean' match_query_done(`MatchS' m)
{
	if (m.j0 >= m.j1) {
		if (m.i0 < m.i1) return(`False')
		return(`True')
	}
	return(`NotDone')
}


/*	__			  _
	mr = match_simplification(m, ellist)
				  -  ------

		Performs simplification step (matching outside fixed-length
		patterns).
		Returns
			`MRsuccess'	(never returned by this routine)
			`MRfailure'	simplification failed
			`MRirrel'	simplification performed
*/

`Matchres' match_simplification(`MatchS' m, `PelR' ellist)
{
	`Matchres'	mr


	/* ------------------------------------------------------------ */
					/* match left fixed		*/

	while (`MatchNotDone') {
		mr = match_fixed(m, ellist, `Left')
		if (mr==`MRfailure') return(`MRfailure')
		if (mr==`MRirrel')   break
	}

	/* ------------------------------------------------------------ */
					/* match right fixed		*/
	while (`MatchNotDone') {
		mr = match_fixed(m, ellist, `Right')
		if (mr==`MRfailure') return(`MRfailure')
		if (mr==`MRirrel')   break
	}
	return(mr)
}



/*	__	         _
	mr = match_fixed(m, ellist, s)
		         -  ------  -

	Match a fixed-length pattern (ETstr, ETnum_f, ETqm) on side s.
	Returns
		`MRsuccess'	one fixed-length pattern matched
		`MRFailure'	fixed-length pattern found, cannot be matched
		`MRirrel'	fixed-length pattern not found on side s

	To match all fixed-length patterns, continue calling this 
	routine as long as it return `MRsuccess'.  The string does not 
	match the pattern if `MRfailure' is returned.  `MRirrel' merely 
	means there's no reason to keep calling.
*/


`Matchres' match_fixed(`MatchS' m, `PelR' ellist, `Side' s)
{
	`RS'	j


	j = (s==`Left' ? m.j0 : m.j1-1)

	if (ellist[j].elementtype==`ETstr')   return(match_ETstr(m, ellist, s))
	if (ellist[j].elementtype==`ETnum_f') return(match_ETnum_f(m, ellist, s))
	if (ellist[j].elementtype==`ETqm')    return(match_ETqm(m, ellist, s))


	return(`MRirrel')
}

/*	__		 _
	mr = match_ETstr(m, ellist, s)
			 -  ------  -

	match fixed string (ET_str) on side s.
	Returns
		`MRsuccess'	success (this one pattern matched)
		`MRFailure'	cannot be matched 
		`MRirrel'	ET_str not recorded pattern

	Complication due to abbreviations:
	    The eligible list was produced by Stata's -syntax- and 
	    may have expanded abbreviations.  Therefore, if 
	    ETstr is the only pattern and it matches, it will 
	    consume the entire string.  E.g., pattern is "displ"
	    and we are checking whether "displacement" matches. 
	    It does.
	
*/

	

`Matchres' match_ETstr(`MatchS' m, `PelR' ellist, `Side' s)
{
	`RS'	j, len


	j = (s==`Left' ? m.j0 : m.j1-1)
	if (ellist[j].elementtype != `ETstr') return(`MRirrel')


	len = ellist[j].arg
	if ((s==`Left' ?  usubstr(m.name, m.i0, len) : 
	                  usubstr(m.name, m.i1-len, len)) != ellist[j].element) {
		return(`MRfailure')
	}

/*
	if (m.j0==1 & length(ellist)==1) {
		post_match_piece(m, s, ustrlen(m.name))
	}
	else 	post_match_piece(m, s, len)
*/
	post_match_piece(m, s, len)

	return(`MRsuccess')
}


/*	__		   _
	mr = match_ETnum_f(m, ellist, s)
		           -  ------  -

	match (#..#) (ET_num_f) on side s.
	Returns
		`MRsuccess'	success (this one pattern matched)
		`MRFailure'	cannot be matched 
		`MRirrel'	(#..#) (ET_num_f) not recorded pattern
*/
	

`Matchres' match_ETnum_f(`MatchS' m, `PelR' ellist, `Side' s)
{
	`RS'	j, i, len
	`SS'	str, c
	
	j = (s==`Left' ? m.j0 : m.j1-1)
	if (ellist[j].elementtype != `ETnum_f') return(`MRirrel')

	len = ellist[j].arg
	str = (s==`Left' ?  usubstr(m.name, m.i0, len) : usubstr(m.name, -len, .)) 

	if (ustrlen(str)!=len) return(`MRfailure')
	for (i=1; i<=len; i++) {
		c = bsubstr(str, i, 1)
		if (c<"0" | c>"9") return(`MRfailure')
	}

	post_match_piece(m, s, len)
	return(`MRsuccess')
}



/*	__		_
	mr = match_ETqm(m, ellist, s)
			-  ------  -

	    match ? (ET_qm) on side s.
	    Returns
		`MRsuccess'	success (this one pattern matched)
		`MRFailure'	cannot be matched 
		`MRirrel'	? (ET_star) not recorded pattern
*/

		
`Matchres' match_ETqm(`MatchS' m, `PelR' ellist, `Side' s)
{
	if (ellist[s==`Left' ? m.j0 : m.j1-1].elementtype != `ETqm') {
		return(`MRirrel')
	}

	if (m.i0==m.i1) return(`MRfailure')
	post_match_piece(m, s, 1)
	return(`MRsuccess')
}



/*	__		   _
	mr = match_ETnum_v(m, ellist, s)
			   -  ------  -

	    Greedily match # (ET_num_v) on side s.
	    Returns
		`MRsuccess'	success (and all patterns are matched!)
		`MRfailure'	# (ET_num_v) cannot be matched
		`MRirrel'	# (ET_NUM_v) not recorded pattern

	    Note, this routine recursively calls back to match_step().
	    Thus, if `MRsuccess', the whole of the pattern has been 
	    matched and recorded and m.
*/


`Matchres' match_ETnum_v(`MatchS' m, `PelR' ellist, `Side' s)
{
	`RS'		j, i0, i1, len
	`SS'		c
	`SS'		c1
	`MatchS'	hold

	j = (s==`Left' ? m.j0 : m.j1-1)
	if (ellist[j].elementtype != `ETnum_v') return(`MRirrel')

	if (s==`Left') {
		for (i1=m.i0; i1<m.i1; i1++) {
			c  = usubstr(m.name, i1, 1)
			c1 = bsubstr(c, 1, 1)
			if (c1<"0" | c1>"9") break 
		}
		/* ##..# now bounded by [m.i0, i1) */
		len = i1-m.i0
	}
	else {
		for (i0=m.i1-1; i0>=m.i0; i0--) {
			c  = usubstr(m.name, i0, 1)
			c1 = bsubstr(c, 1, 1)
			if (c1<"0" | c1>"9") break 
		}
		(void) ++i0
		/* ##..# now bounded by [i0, m.i1) */
		len = m.i1 - i0
	}

	for (hold=m; len>0; --len) {
		post_match_piece(m, s, len)
		if (match_step(m, ellist)==`True') return(`MRsuccess')
		m = hold
		(void) --len
	}
	return(`MRfailure')
}

/*	__		       _
	mr = match_ETstar_left(m, ellist, s)
			       -  ------  -

	    Greedily match * (ET_star) on the left.
	    Returns
		`MRsuccess'	success (and all patterns are matched!)
		`MRfailure'	# (ET_star) cannot be matched
		`MRirrel'	# (ET_star) not recorded pattern

	    Note, this routine recursively calls back to match_step().
	    Thus, if `MRsuccess', the whole of the pattern has been 
	    matched and recorded and m.

	    This routine looks to see if next pattern element is 
	    # (ET_num_v) and, if it is, and if the greedily matched 
	    string includes digits at the end, the digits are given 
	    back so that they can be subsequently matched by #.
	    # is greedier than *.  This is to prevent

		*#...  from matching a12... as a1+2+... rather than 
		a+12+...
*/

`Matchres' match_ETstar_left(`MatchS' m, `PelR' ellist)
{
	`RS'		len, newlen
	`MatchS'	hold
	`boolean'	next_is_ETnum_v

	if (ellist[m.j0].elementtype != `ETstar') return(`MRirrel')
	
	len = m.i1 - m.i0 

	/* ------------------------------------------------------------ */
	if (m.j1-m.j0==1) {		/* if * is only pattern element
					   remaining ... */
		post_match_piece(m, `Left', len)
		return(`MRsuccess')
	}

	/* ------------------------------------------------------------ */
	next_is_ETnum_v = (ellist[m.j0+1].elementtype==`ETnum_v')
	for (hold=m; len>=0; --len) {
		post_match_piece(m, `Left', len)
		if (match_step(m, ellist)==`True') {
			if (next_is_ETnum_v) {
				newlen = mstargiveback(usubstr(m.name, 1, len))
				if (newlen<len) {
					m = hold
					post_match_piece(m, `Left', newlen)
					assert(match_step(m, ellist))
				}
			}
			return(`MRsuccess')
		}
		m = hold
	}
	return(`MRfailure')
}



`RS' mstargiveback(`SS' s)
{
	`RS'	l
	`SS'	c
	`SS'	c1
	
	for (l = ustrlen(s); l>0; --l) {
		c  = usubstr(s, l, 1)
		c1 = bsubstr(c, 1, 1)		
		if (c1<"0" | c1>"9") return(l)
	}
	return(l)
}


/*				_
	(void) post_match_piece(m, s, len)
			        -  -  ---

	    Records pattern on side s as matched and stores
	    characters corresponding to the match in the 
	    appropriate element of m.pieces[].
	
*/


void post_match_piece(`MatchS' m, `Side' s, `RS' len)
{
	if (s==`Left') {
		m.pieces[m.j0] = usubstr(m.name, m.i0, len)
		m.i0 = m.i0 + len
		(void) ++(m.j0)
	}
	else {
		(void) --(m.j1)
		m.pieces[m.j1] = usubstr(m.name, m.i1-len, len)
		m.i1 = m.i1 - len
	}
}
				/* input variable pattern matching	*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
				/* sort old variable names		*/

/*				 ___
	(void) sort_old_varnames(ren)
				 ---

	    For all i, sort ren.oldplist[i].varnames 
	    Returns, 
		(void)	ren.olplist[].varnames sorted
*/


void sort_old_varnames(`RenameS' ren)
{
	`RS' i

	for (i=1; i<=length(ren.oldplist); i++) {
		sort_appropriate_field(ren.oldplist[i], ren.newplist[i])
	}
}



void sort_appropriate_field(`PatternR' oldplist, `PatternR' newplist)
{
	`RS'		i
	`RS'		j

	for (i=1; i<=length(newplist); i++) {
		if ((j = j_of_renumber(newplist[i]))) {
		j = newplist[i].ellist[j].match
			sort_on_field(oldplist[i], j)
		}
		else {
			sort_on_field(oldplist[i], j_of_number(oldplist[i]))
		}
	}
}

/*	_
	j = j_of_renumber(plist)
			  -----

	    Search new plist for a renumber pattern element and 
	    return its location in plist.ellist[].  
	    Returns
		>= 1		found; location
		0		not found

	_
	j = j_of_number(plist)
		        -----

	    Search old plist for a number, star, or qm pattern and 
	    return its location in plist.ellist[].
		>= 1		found; location
		0		not found

*/

`RS' j_of_renumber(`PatternS' plist)
{
	`RS'		j
	`ElementTypeS'	tt
		
	for (j=1; j<=length(plist.ellist); j++) {
		tt = plist.ellist[j].elementtype
		if (tt==`ETnum_v_r' | tt==`ETnum_f_r') return(j)
	}
	return(0) 
}

`RS' j_of_number(`PatternS' plist)
{
	`RS'		j, jtoret
	`ElementTypeS'	tt

	jtoret = 0
	for (j=1; j<=length(plist.ellist); j++) {
		tt = plist.ellist[j].elementtype
		if (tt==`ETstar' | tt==`ETqm' | tt==`ETnum_v' | tt==`ETnum_f') {
			if (jtoret) return(0)
			jtoret = j 
		}
	}
	return(jtoret)
}
	

/*			     _____
	(void) sort_on_field(plist, j)
			     -----  -

	    Sort old plist.varnames on field j
	    j==0 means to put the variable in alphabetical order.
	    For j>0, the field is interpreted as numeric or string 
	    depending on plist.ellist[j].elementtype.
*/
	

void sort_on_field(`PatternS' plist, `RS' j)
{
	`ElementTypeS'	tt
	`RC'		o
	`SC'		vc
	
	if (j==0) {
		o = order(plist.varnames', 1)
	}
	else {
		tt = plist.ellist[j].elementtype
		if (tt==`ETnum_v' | tt==`ETnum_f') {
			o = order(strtoreal(plist.pieces[,j]), 1)
		}
		else {
			o = order(plist.pieces[,j], 1)
		}
	}
	_collate(plist.pieces, o)
	vc     = plist.varnames'
	_collate(vc, o)
	plist.varnames = vc'
}
	
				/* sort old variable names		*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
				/* fillin_new_varnames			*/

/*
	Note -- there are two variants of the routine below, one for 
	recasing and the other for oldname-to-newname.  The recase 
	routine is first because it is simpler.
*/


/*					  ___
	(void) fillin_new_varnames_recase(ren)
					  ---

	    Fill in ren.newplist[].varnames equal to corresponding 
	    ren.oldplist[].varnames, recased as specified by 
	    ren.option.isrecase_upper, ..._lower, ..._proper.
*/

void fillin_new_varnames_recase(`RenameS' ren)
{
	`RS'	i

	for (i=1; i<=length(ren.newplist); i++) {
		if (ren.option.isrecase_upper) {
			ren.newplist[i].varnames = 
				strupper(ren.oldplist[i].varnames)
		}
		else if (ren.option.isrecase_lower) {
			ren.newplist[i].varnames = 
				strlower(ren.oldplist[i].varnames)
		}
		else if (ren.option.isrecase_proper) {
			ren.newplist[i].varnames = 
				strproper(ren.oldplist[i].varnames)
		}
		else {
			assert(0)
		}
	}
}



/*					     ________
	(void) fillin_new_varnames(oldplist, newplist, from)
				   --------  --------  ----


	    This routine is for the oldname-to-newname case.

	    Fill in ren.newplist[].varnames equal to corresponding 
	    ren.oldplist[].varnames and linkage information in 
	    ren.newplist[] and ren.oldplist[].
*/

void fillin_new_varnames(`PatternR' oldplist, `PatternR' newplist, `RS' from)
{
	`RS'	i

	for (i=1; i<=length(newplist); i++) {
		fillin_new_varnames_u(oldplist[i], newplist[i], from)
	}
}

void fillin_new_varnames_u(`PatternS' oldp, `PatternS' newp, `RS' from)
{
	`RS'	i

	if (newp.ellist[1].elementtype==`ETstrlist') {
		newp.varnames = tokens(newp.original)
		if (length(newp.varnames)!=length(oldp.varnames)) {
			error_strlist_length(oldp, newp)
			/*NOTREACHED*/
		}
	}
	else {
		newp.varnames = J(1, length(oldp.varnames), "")
		for (i=1; i<=length(oldp.varnames); i++) {
			fillin_new_varnames_u_u(oldp, newp, from, i)
		}
	}
}


void fillin_new_varnames_u_u(`PatternS' oldp, `PatternS' newp, `RS' from, `RS' i)
{
	`RS'		j
	`SS'		name
	`ElementTypeS'	tt

	name = ""
	for (j=1; j<=length(newp.ellist); j++) {
		tt = newp.ellist[j].elementtype 
		if (tt==`ETstr') {
			name = name + newp.ellist[j].element
		}
		else if (tt==`ETstar') {
			name = name + oldp.pieces[i, newp.ellist[j].match]
		}
		else if (tt==`ETqm') {
			name = name + oldp.pieces[i, newp.ellist[j].match]
		}
		else if (tt==`ETnum_v') {
			name = name + oldp.pieces[i, newp.ellist[j].match]
		}
		else if (tt==`ETnum_f') {
			name = name + fmt_ETnum_f(oldp, newp, i, j)
		}
		else if (tt==`ETeq') {
			name = name + oldp.varnames[i]
		}
		else if (tt==`ETnum_v_r') {
			name = name + sprintf("%g", from++)
		}
		else if (tt==`ETnum_f_r') {
			name = name + fmt_ETnum_f_r(oldp, newp, j, from)
		}
		else if (tt != `ETodot') {
			assert(0)
			/*NOTREACHED*/
		}
	}
	newp.varnames[i] = name
}


`SS' fmt_ETnum_f(`PatternS' oldp, `PatternS' newp, `RS' i, `RS' j)
{
	`RS'	n, len
	`SS'	res, orig

	n   = newp.ellist[j].arg
	orig = oldp.pieces[i, newp.ellist[j].match]
	res = sprintf("%g", strtoreal(orig))
	if ((len=bstrlen(res)) >= n) return(res)
	return((n-len)*"0" + res)
}

/*
	fmt_ETnm_f_r(oldp, ...) ignores oldp. 

	The argument is included for consistency with other fmt_ETnum*()
	functions.
*/

`SS' fmt_ETnum_f_r(`PatternS' oldp, `PatternS' newp, `RS' j, `RS' from)
{
	`RS'	n, len
	`SS' res

	pragma unused oldp

	n   = newp.ellist[j].arg
	res = sprintf(strofreal(from++))
	if ((len=bstrlen(res)) >= n) return(res)
	return((n-len)*"0" + res)
}

				/* fillin_new_varnames			*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
				/* build toren[] 			*/

/*	_____
	toren = build_toren(oldplist, newplist)
			    --------  --------

	    1.  Builds toren: Nx2 containing (varnames_old, varnames_new)

	    2.  Removes duplicate rows (repeated instructions to perform 
		same rename) from toren to produce toren: nx2, n<=N

	    Returns
			 toren:   nx2
*/

	
`SM' build_toren(`PatternR' oldplist, `PatternR' newplist)
{
	`SM'	toren
	`RS'	i, N, n, k, k2
	`RC'	toselect
	`SR'	lastrow, newrow
	`boolean' hasomissions

	/* ------------------------------------------------------------ */
					/* obtain N			*/
	N = 0 
	for (i=1; i<=length(newplist); i++) {
		N = N + length(newplist[i].varnames)
	}

	toren = J(N, 2, "")
	if (N==0) return(toren)

	for (k=i=1; i<=length(newplist); i++) {
		n = length(newplist[i].varnames)
		k2 = k+n-1
		if (k2>=k) toren[|k,1\k2,2|] = 
				(oldplist[i].varnames \ newplist[i].varnames)'
		k = k2 + 1
	}

	/* ------------------------------------------------------------ */
					/* remove duplicates		*/
	if (N>1) {
		toselect = J(N, 1, 1)
		lastrow  = toren[1, .]
		for (k=2; k<=N; k++) {
			newrow = toren[k, .]
			if (newrow == lastrow) {
				toselect[k]  = 0
				hasomissions = `True'
			}
			else 	lastrow = newrow
		}
		if (hasomissions) toren = select(toren, toselect)
	}
	return(toren)
}

				/* build toren[] 			*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
				/* perform renames based on toren[]	*/

/*
	(void) perform_renames(toren, option)
			       -----  ------

	Perform the n variable renamings described in toren[]: nx2.
	Each row of toren records a single renaming request, namely 
	to rename toren[i,1] to toren[i,2].

	option.istest==`True' means no renaming be performed.
		Instead a summary of the renamings that would have 
		been performed be stored in s(n), s(intermediary), 
		and s(r1), s(r2), ...

	option.isdryrun==`True' specifies no renaming be performed.
		Instead, a table is produced showing the 
		renamings that would be performed.

	Properties required of toren[]:
	    1.  No duplicate rows.
	    2.  toren[.,1] are all unabbreviated, existing Stata 
		variable names

	Not required of toren[]:
	    1.  toren[,.2] are valid Stata variable names.
		perform_renames() fill find and report this error.
	
	    2.  That there be no contradictory rows, such as 
		rename a to b, and another row, rename a to c; 
		or rename a to b, and another row, rename c to b.
		perform_renames() fill find and report this error.

	    3.  That there be no rows renaming a variable to itself.
	        Such rows will be ignored.

	    4.  That the joint set of names toren[.,1]\toren[.,2] 
		be unique.  For instance, you can specify that 
		a be renamed to b and that c be renamed to a.

	    5.  That the new names not exist in the data.
		This is checked and the appropriate error message
		issued.
*/


void perform_renames(`SM' toren, `OptionS' option)
{
	`boolean' 	use_intermediary
	`SM'		toren_nonulls	


	/* ------------------------------------------------------------ */
	if (!rows(toren)) {
		printf("{txt}  (nothing to rename)\n")
		if (option.istest) perform_test(toren, 0)
		return
	}

	/* ------------------------------------------------------------ */
					/* confirm variable names	*/
		
	confirm_new_varnames_valid(toren)
	confirm_names_unique(toren)

	/* ------------------------------------------------------------ */
					/* remove null renames		*/

	toren_nonulls = select(toren, toren[,1]:!=toren[,2])
	if (!rows(toren_nonulls)) {
		if (option.isdryrun) {
			perform_dryrun(toren, toren_nonulls, `False')
		}
		else {
			printf("{txt}  (all {it:newnames}=={it:oldnames})\n")
		}
		return
	}

	/* ------------------------------------------------------------ */
					/* confirm newnames really new  */

	confirm_newnames_new(toren_nonulls)

	/* ------------------------------------------------------------ */
					/* set use_intermediary		*/
	use_intermediary = names_not_jointly_unique(toren_nonulls)

	/* ------------------------------------------------------------ */
					/* execute request		*/

	if (option.istest) {
		perform_test(toren_nonulls, use_intermediary)
	}
	else if (option.isdryrun) {
		perform_dryrun(toren, toren_nonulls, use_intermediary)
	}
	else {
		if (use_intermediary) perform_rename_intermediary(toren_nonulls)
		else		      perform_rename_straight(toren_nonulls)
	}

	if (option.isr & !option.istest) {
		perform_set_r(toren_nonulls)
	}
}

void confirm_newnames_new(`SM' toren)
{
	`RS'	i
	`RR'	varnum
	`SR'	tocheck, badvar

	if (rows(toren)==0) return

	tocheck = list_subtract(toren[,2]', toren[,1]')

	varnum =_st_varindex(tocheck)
	if (!rowsum(varnum)) return

	_editmissing(varnum, 0)
	badvar = select(tocheck, varnum)

	errprintf("%g variable%s already exist%s\n",
			length(badvar), 
			length(badvar)!=1 ? "s" : "",
			length(badvar)!=1 ? ""  : "s")

	for (i=1; i<=rows(toren); i++) {
		if (toren[i,2]==badvar[1]) break
	}
	errprintf("{p 4 4 2}\n")
	errprintf(length(badvar)!=1 ? "For instance, you\n" : "You\n")
	errprintf("requested that variable {bf:%s}\n", toren[i,1])
	errprintf("be renamed {bf:%s}.\n", badvar[1])
	errprintf("{bf:%s} is already\n", badvar[1])
	errprintf("an existing variable in the data.\n")

	if (length(badvar)>1) {
		errprintf("The variables you specified that already\n")
		errprintf("exist are\n")
		errprint_bf_list(badvar)
		errprintf(".\n")
	}
	printf("{p_end}\n")
	exit(110)
}

void perform_set_r(`SM' toren)
{
	st_numscalar("r(n)",        rows(toren))
	st_global(   "r(newnames)", invtokens(toren[.,2]'))
	st_global(   "r(oldnames)", invtokens(toren[.,1]'))
}


void perform_test(`SM' toren, `boolean' use_intermediary)
{
	`RS'	i

	stata("sreturn clear")
	st_global("s(n)", strofreal(rows(toren)))
	st_global("s(intermediary)", strofreal(use_intermediary))

	for (i=1; i<=rows(toren); i++) {
		st_global(sprintf("s(r%g)", i), 
			  sprintf("%s %s", toren[i,1], toren[i,2]))
	}
}


void perform_rename_straight(`SM' toren) 
{
	`RS'	i
	`RS'	breakstatus

	if (rows(toren)==0) return

	breakstatus = setbreakintr(0)
	for (i=1; i<=rows(toren); i++) {
		st_varrename(toren[i,1], toren[i,2])
	}
	(void) setbreakintr(breakstatus)
}

void perform_rename_intermediary(`SM' toren)
{
	`RS'	i
	`RS'	breakstatus
	`SR'	tmpname

	if (rows(toren)==0) return

	tmpname = st_tempname(rows(toren))

	breakstatus = setbreakintr(0)
	for (i=1; i<=rows(toren); i++) st_varrename(toren[i,1], tmpname[i])
	for (i=1; i<=rows(toren); i++) st_varrename(tmpname[i], toren[i,2])
	(void) setbreakintr(breakstatus)
}
	

void perform_dryrun(`SM' toren, `SM' toren_nonulls, `boolean' use_intermediary)
{
	`RS'	i
	`RS'	maxlen
	`SS'	sfmt, sfmtit

	maxlen = max(udstrlen(toren))
	if (maxlen < 8) maxlen = 8
	sfmt   = "%" + sprintf("%guds", maxlen)
	sfmtit = "{it:" + sfmt + "}"

	displayas("txt")
	printf("\n")
	printf("  ") ; printf(sfmtit, "oldname") ;
	printf(" {c |} {it:newname}\n")

	printf("  {hline %g}{c +}{hline %g}\n", maxlen+1, maxlen+1)

	for (i=1; i<=rows(toren); i++) {
		printf("  ") ; printf(sfmt, toren[i,1])
		printf(" {c |} %s\n", toren[i,2])
	}
	
	printf("  {hline %g}{c BT}{hline %g}\n", maxlen+1, maxlen+1)

	dryrun_note1(toren, toren_nonulls)

	dryrun_note2(toren_nonulls, use_intermediary)
}

void dryrun_note1(`SM' toren, `SM' toren_nonulls)
{
	`RS'	i
	`RS'	nulls

	if (!(nulls=rows(toren)-rows(toren_nonulls))) return

	for (i=1; i<=length(toren); i++) {
		if (toren[i,1]==toren[i,2]) break
	}

	printf("{p 2 8 2}\n")
	printf("{txt}Note: ")
	if (nulls==1) {
		printf("1 variable would be renamed to itself.\n")
		printf("Variable\n")
	}
	else {
		printf("%g variables would be renamed to themselves.\n", nulls)
		printf("For instance, variable\n")
	}
	printf("{bf:%s} would be renamed {bf:%s}.\n", toren[i,1], toren[i,1])
	printf("{bf:rename} can handle that.\n")
	printf("{p_end}\n")
}


void dryrun_note2(`SM' toren, `boolean' use_intermediary)
{
	`SC'	dupnames, newname, oldname

	if (!use_intermediary) return

	dupnames = nonuniqrows(toren[.,1] \ toren[.,2])
	newname  = corresponding_names(toren, dupnames[1], 1, 2)
	oldname  = corresponding_names(toren, dupnames[1], 2, 1)

	printf("{p 2 8 2}\n")
	printf("{txt}Note: %g name%s\n", length(dupnames), 
					 length(dupnames)==1 ? "" : "s")
	printf("appear%s in both the {it:oldname} and {it:newname} columns.\n",
		length(dupnames)==1 ? "s" : "")
	if (length(dupnames)>2) printf("For instance, existing\n")
	else			printf("Existing\n")
	printf("variable {bf:%s} would be renamed {bf:%s}\n", 
			dupnames[1], newname[1])
	printf("and existing variable {bf:%s}\n", oldname[1])
	printf("would be renamed {bf:%s}.\n", dupnames[1])
	printf("{bf:rename} can handle that.\n")
	printf("{p_end}\n")
}


`boolean' names_not_jointly_unique(`SM' toren)
{
	`RS'	n0, n1
	`SC'	fulllist

	n0 = length(fulllist = toren[.,1] \ toren[.,2])
	n1 = length(uniqrows(fulllist))
	return(n1!=n0)
}
	


void confirm_names_unique(`SM' toren)
{
	confirm_names_unique_1(toren, 1)
	confirm_names_unique_1(toren, 2)
}

void confirm_names_unique_1(`SM' toren, `RS' j)
{
	`SC'	names, corresponding
	`SS'	s
	`RS'	n

	names = nonuniqrows(toren[.,j])

	if ((n=rows(names))==0) return
	s = (n==1 ? "" : "s")

	if (j==1) {
		errprintf(
		"%g existing variable%s specified repeatedly in {it:oldname%s}\n",
		n, s, s)

		corresponding = corresponding_names(toren, names[1], 1, 2)
		errprintf("{p 4 4 2}\n")
		errprintf(length(names)==1 ? "You\n" : "For instance, you\n")
		errprintf("requested {bf:%s} be renamed to %g\n", 
				names[1], length(corresponding))
		errprintf("different names:\n")
		errprint_bf_list(corresponding) 
		errprintf(".\n")
		errprintf("{p_end}\n")
	}
	else {
		errprintf(
		"%g new name%s specified repeatedly in {it:newname%s}\n", 
		n, s, s)

		corresponding = corresponding_names(toren, names[1], 2, 1)
		errprintf("{p 4 4 2}\n")
		errprintf(length(names)==1 ? "You\n" : "For instance, you\n")
		errprintf("requested the name {bf:%s} be assigned to\n", 
				names[1])
		errprintf("%g existing variables:\n", length(corresponding))
		errprint_bf_list(corresponding) 
		errprintf(".\n")
		errprintf("{p_end}\n")
	}
	exit(198)
}

/*	_____
	names = corresponding_names(toren, name, js, jd)
				    -----  ----  --  --

            Return names from column jd of toren[] corresponding to name
            located in column js of toren.  This routine is used by 
	    error-message routines when name of type js is a known 
	    duplicate.
*/

`SC' corresponding_names(`SM' toren, `SS' name, `RS' js, `RS' jd)
{
	`RS'	i
	`SC'	dups

	pragma unset dups
	for (i=1; i<=rows(toren); i++) {
		if (toren[i,js]==name) dups = dups \ toren[i,jd]
	}
	return(dups)
}


/*
	(void) confirm_new_varnames_valid(toren)
					  -----

	    Verify that toren[.,2] are all valid Stata variable names.
	    Returns
		void		all names valid
		abort		some names invalid; error message issued
*/
	
void confirm_new_varnames_valid(`SM' toren)
{
	`RS'	i, n
	`RC'	bad

	bad = J(0, 1, .)
	n   = 0


	for (i=1; i<=rows(toren); i++) {
		if (!st_isvarname(toren[i,2])) {
			if (++n <= 3) bad = bad \ i
		}
	}
	if (!n) return
	errprintf("%g new variable name%s invalid\n", n, (n==1 ? "" :"s"))
	errprintf("{p 4 4 2}\n")

	i = bad[1] 
	errprintf("You attempted to rename {bf:%s} to {bf:%s}", 
						toren[i,1], toren[i,2])
	if (n>1) {
		i = bad[2] 
		errprintf(n==2 ? " and\n" : ",\n")
		errprintf("{bf:%s} to {bf:%s}", toren[i,1], toren[i,2])
		errprintf(n==2 ? ".\n" : ", ...\n")
	}
	else	errprintf(".\n") 
	if (n==1) {
		errprintf("That is an invalid Stata variable name.\n") 
	}
	else {
		errprintf("Those are invalid Stata variable names.\n") 
	}
	errprintf("{p_end}\n")
	exit(198)
}

				/* perform renames based on toren[]	*/
/* -------------------------------------------------------------------- */
	
	

/* -------------------------------------------------------------------- */
				/* utility routines			*/
	
	
/*
	(void) confirm_not_empty(str, expected)
				 ---  --------

	    abort with error if str==""
	    Returns
		void		str is not empty
		abort		str is empty
*/
	

void confirm_not_empty(`SS' str, `SS' expected)
{
	if (strtrim(str)!="") return
	errprintf("nothing found where %s expected\n", expected) 
	exit(198)
	/*NOTREACHED*/
}


/*
	(void) errprint_bf_list(list, [, MAXEL])
				----     -----

	    errprintf() boldfaced, comma-separated list.
	    use ellipses if list too long
	    Next errprintf() after this call will be character immediately
	    following last character of list, so caller can add punctuation.  
	    You must be in SMCL paragraph mode to use this utility.
*/


void errprint_bf_list(string vector list , |`RS' USER_MAXEL)
{
	`RS'		MAXEL
	`RS'		i, top
	`boolean'	chopped

	if (length(list)==0) return

	if (args()==1) 		MAXEL = 12
	else if (USER_MAXEL<12)	MAXEL = 12
	else			MAXEL = USER_MAXEL

	errprint_bf_string(list[1])
	if (length(list)==1) return

	if (length(list)>2) {
		if (length(list) > MAXEL) {
			top     = MAXEL - 3 
			chopped = `True'
		}
		else {
			top     = length(list)
			chopped = `False'
		}

		printf(",\n")
		for (i=2; i<top; i++) {
			errprint_bf_string(list[i])
			errprintf(",\n")
		}

		if (chopped) errprintf("...,\n")
	}
	else	errprintf(" ")
	errprintf("and\n")
	errprint_bf_string(list[length(list)])
}

/*
	(void) errprint_bf_string(s [, MAXLEN])
				  -    ------

	    errprintf() boldfaced string, which might be long.
	    If it is too long, place an ellipse in a reasonable 
	    location.  
	    Next errprintf() after this call will be character immediately
	    following last character output, so caller can add punctuation.

	    Below we set default MAXLEN to be > 32+3+32, to allow 
	    <varname> - <varname> without truncation.
*/

void errprint_bf_string(string scalar user_s, |`RS' USER_MAXLEN)
{
	`RS'		MAXLEN
	`RS'		len_last, target_last
	`RS'		len_remaining
	`RS'		i
	`SR'		els
	`SS'		s, first, last
	`boolean'	cont

	if (args()==1)			MAXLEN = 78
	else if (USER_MAXLEN < 32)	MAXLEN = 32
	else				MAXLEN = USER_MAXLEN

	els = tokens(s = strtrim(user_s))

	cont = `True'
	while (cont) {
		if (udstrlen(s)<=MAXLEN) {
			errprintf("{bf:%s}", s)
			return
		}

		if (length(els)==1) {
			errprintf("%s...%s", udsubstr(s, 1, MAXLEN-6), 
				     			udsubstr(s, -3, .))
			return
		}
		if (MAXLEN<=65) MAXLEN = 66 
		else		cont   = `False'
	}
		

	len_last     = udstrlen(last = els[length(els)])
	target_last  = floor(MAXLEN/3)
	if (target_last < 32) target_last = 32 
	if (len_last > target_last) len_last = target_last

	len_remaining = MAXLEN - len_last
	first = els[1]
	for (i=2; i<length(els); i++) {
		if (udstrlen(first) + 1 + udstrlen(els[i]) > len_remaining) break
		first = first + " " + els[i]
	}
	errprint_bf_string(first, len_remaining)
	errprintf("\n")
	errprintf("... ")
	errprint_bf_string(last, target_last)
}


				/* utility routines			*/
/* -------------------------------------------------------------------- */
	
/* -------------------------------------------------------------------- */
				/* error message routines		*/


void error_syntax()
{
	`SS'	indent

	indent = "        "

	errprintf("syntax error\n")
	errprintf("    Syntax is\n") 

	errprintf("%s{bf:rename}  {it:oldname}    {it:newname}   ", indent)
	errprintf("[{bf:, renumber}[{bf:(}{it:#}{bf:)}] ")
	errprintf("{bf:addnumber}[{bf:(}{it:#}{bf:)}] ")
	errprintf("{bf:sort} ...]\n")
	
	errprintf("%s{bf:rename (}{it:oldnames}{bf:) (}{it:newnames}{bf:)} ",
									indent)
	errprintf("[{bf:, renumber}[{bf:(}{it:#}{bf:)}] ")
	errprintf("{bf:addnumber}[{bf:(}{it:#}{bf:)}] ")
	errprintf("{bf:sort} ...]\n")

	errprintf("%s{bf:rename}  {it:oldnames}              {bf:,} {{bf:upper}|{bf:lower}|{bf:proper}}\n", indent)
	exit(198)
	/*NOTREACHED*/
}


void error_preceding_dash(`Patterntype' pattype)
{
	errprintf("syntax error\n") 
	errprintf("{p 4 4 2}\n")
	errprintf("In parsing {it:%s},\n", 
			(pattype==`PTold' ? "oldname" : "newname" ) )

	errprintf("either nothing or something invalid precedes the dash.\n")
	errprintf("The dash syntax is {it:varname}{bf:-}{it:varname},\n")
	errprintf("and the variable names cannot have wildcard characters\n")
	errprintf("in them.\n")
	errprintf("{p_end}\n") 
	exit(198)
	/*NOTREACHED*/
}


void error_following_dash(`Patterntype' pattype, `SS' what)
{
	errprintf("syntax error\n") 
	errprintf("{p 4 4 2}\n")
	errprintf("In parsing {it:%s},=n", 
			(pattype==`PTold' ? "oldname" : "newname" ) )

	if (what=="") {
		errprintf("you have nothing following the dash.\n")
	}
	else {
		errprintf("what follows the dash is invalid.\n")
	}
	errprintf("The dash syntax is {it:varname}{bf:-}{it:varname},\n")
	errprintf("and the variable names cannot have wildcard characters\n")
	errprintf("in them.\n")
	errprintf("{p_end}\n") 
	exit(198)
	/*NOTREACHED*/
}




void option_not_allowed(`SS' option)
{
	errprintf("option %s not allowed\n", option)
	exit(198)
	/*NOTREACHED*/
}


void option_number_misspecified(`SS' op)
{
	errprintf("option {bf:%s} misspecified\n", op) 

	errprintf("{p 4 4 2}\n")
	errprintf("Option's syntax is {bf:%s} or\n", op)
	errprintf("{bf:renumber(}{it:#}{bf:)}, where\n")
	errprintf("1 <= {it:#} <= 999999.\n")
	errprintf("If {bf:(#)} is not specified, {bf:(1)} is assumed.\n")
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}


void error_u_base_syntax_opening()
{
	errprintf("{p 4 4 2}\n")
	errprintf("Syntax is {bf:rename} {it:oldname} {it:newname}{break}\n") 
}
	

void error_starstar_not_allowed()
{
	errprintf("{bf:**} not allowed in {it:oldname}\n")

	error_u_base_syntax_opening()
	errprintf("{bf:*} in {it:oldname} means 0 or more\n")
	errprintf("characters go here.  {bf:*} is greedy,\n")
	errprintf("e.g., {bf:l*a} matches {bf:la} and it\n")
	errprintf("matches {bf:louisiana}.\n")
	errprintf("{bf:**} would have no meaning because\n")
	errprintf("the second {bf:*} would always match\n")
	errprintf("0 characters.\n")
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}

void error_hashhash_not_allowed_old()
{
	errprintf("{bf:##} not allowed in {it:oldname}\n")

	error_u_base_syntax_opening()
	errprintf("{bf:#} in {it:oldname} means 1 or more\n")
	errprintf("digits go here.  {bf:#} is greedy,\n")
	errprintf("e.g., {bf:a#} matches {bf:a1} and it\n")
	errprintf("matches {bf:a923}.\n")
	errprintf("{bf:##} would have no meaning because\n")
	errprintf("the second {bf:#} would always match\n")
	errprintf("0 characters and thus be an error.\n")
	errprintf("\n")
	errprintf("{p 4 4 2}\n")
	errprintf("If you want to match one-digit numbers,\n")
	errprintf("code {bf:(#)}; code {bf:(##)} for\n")
	errprintf("two-digit numbers; and so on.\n")
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}

void error_equal_in_oldname()
{
	errprintf("{bf:=} not allowed in {it:oldname}\n") 

	error_u_base_syntax_opening()
	errprintf("You used {bf:=} in {it:oldname}, not {it:newname}.\n")
	errprintf("{bf:=} is used in {it:newname}\n") 
	errprintf("to indicate that the entire old name goes here.\n") 
	errprintf(`"E.g., "{bf:rename *pop a=}" adds an {bf:a}\n"') 
	errprintf("to the front of every variable that ends in\n")
	errprintf("{bf:pop}.\n")
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}

void error_dot_in_oldname()
{
	errprintf("{bf:.} not allowed in {it:oldname}\n") 

	error_u_base_syntax_opening()
	errprintf("You used {bf:.} in {it:oldname}, not {it:newname}.\n")
	errprintf("{bf:.} is used in {it:newname}\n") 
	errprintf("to indicate that the corresponding wildcard in\n")
	errprintf("{it:oldname} be skipped.\n") 
	errprintf(`"E.g., "{bf:rename a*b* a.b*}" removes what\n"')
	errprintf("is between {bf:a} and {bf:b}; variable\n")
	errprintf("{bf:ausbvalue} would be renamed {bf:abvalue}.\n")
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}

/*
void error_hashhash_not_allowed_new()
{
	errprintf("{bf:##} not allowed in {it:newname}\n")

	error_u_base_syntax_opening()
	errprintf("{bf:#} in {it:newname} means put the number\n")
	errprintf("here using the minimum number of digits\n")
	errprintf("possible.  If you want two-digit\n")
	errprintf("numbers, code {bf:(##)}.  Code {bf:(###)}\n")
	errprintf("for three-digit numbers, and so on.\n")
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}
*/

void error_parens_unbalanced()
{
	errprintf("parentheses unbalanced\n") 
	exit(198)
	/*NOTREACHED*/
}


void error_ETnum_f_too_long(`RS' n_digits)
{
	errprintf("{bf:(###...#)} too long\n")

	errprintf("{p 4 4 2}\n")
	errprintf("The maximum number of {bf:#} signs allowed in\n")
	errprintf("the {bf:(###...#)} pattern is %g.\n", `MaxDigits')
	errprintf("You specified %g.\n", n_digits)
	errprintf("{p_end}\n")
	
	exit(198)
	/*NOTREACHED*/
}

void error_patternlengths_unequal(`PatternR' oldplist, `PatternR' newplist)
{
	`SS'	s_old, s_new

	s_old = (length(oldplist)==1 ? "" : "s")
	s_new = (length(newplist)==1 ? "" : "s")

	errprintf("{it:oldnames} and {it:newnames} do not match\n")

	errprintf("{p 4 4 2}\n")
	errprintf("You specified %g pattern%s or name%s\n",
			length(oldplist), s_old, s_old)
	errprintf("for {it:oldname%s} and\n", s_old)
	errprintf("%g pattern%s or name%s for {it:newname%s}.\n", 
			length(newplist), s_new, s_new, s_new)
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}


void error_too_many_renumbers(`SS' op, `PatternS' newp)
{
	errprintf("more than one {bf:#} specifier in {it:newname}\n")

	errprintf("{p 4 4 2}\n")
	errprintf("You specified {it:newname} {bf:%s}\n", newp.original)
	errprintf("and you specified option {bf:%s}.\n", op)
	errprintf("Only one {bf:#} specifier may appear in {it:newname}\n")
	errprintf("in this case.\n")
	errprintf("The one {it:#} may be specified in any of\n")
	errprintf("its guises: {bf:#}, {bf:(#)}, {bf:(##)}, ...\n")

	errprintf("You can have more than\n")
	errprintf("one {it:#} in {it:oldname} to filter\n")
	errprintf("which variables are renamed if you wish.\n")
	errprintf("In that case, you must match those extra {it:#}s\n")
	errprintf(" in {it:oldname} with {bf:*} in\n")
	errprintf("{it:newname}.  For example, you could specify\n")
	errprintf("{bf:rename y#m# y*m#, renumber} and there would.\n")
	errprintf("be no confusion as to which {bf:#} in {it:newname}\n")
	errprintf("the {bf:renumber} refers.\n")
		
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}



void error_strlist_length(`PatternS' oldp, `PatternS' newp)
{
	`RS'	n_old, n_new
	`SS'	s_old, s_new

	n_old = length(oldp.varnames)
	s_old = (n_old == 1 ? "" : "s")

	n_new = length(newp.varnames)
	s_new = (n_old == 1 ? "" : "s")
	

	errprintf("corresponding {it:oldnames} and {it:newnames} mismatch\n")

	errprintf("{p 4 4 2}\n")
	errprintf("You specified or implied %g {it:oldname%s}\n", 
			n_old, s_old)
	errprintf("and %g {it:newname%s};\n", n_new, s_new)
	errprintf("{p_end}\n") 
	exit(198)
	/*NOTREACHED*/
}

void error_missing_ETnum(`SS' opname, `PatternS' newp)
{
	errprintf("missing {bf:#} specifier in {it:newname}\n")

	errprintf("{p 4 4 2}\n")
	errprintf("You specified {it:newname}\n")
	errprint_bf_string(newp.original)
	errprintf(",\n")
	errprintf("and you specified option {bf:%s}.\n", opname)
	errprintf("Thus, {bf:rename} expects to see one {bf:#} specifier\n")
	errprintf("in {it:newname}.  {it:#} may be specified in any of\n")
	errprintf("its guises: {bf:#}, {bf:(#)}, {bf:(##)}, ...\n")
	errprintf("{p_end}\n") 
	exit(198) 
	/*NOTREACHED*/
}


void error_too_many_wildcards(`PatternS' oldp, `PatternS' newp, 
							`boolean' isaddnumber)
{
	errprintf("too many wildcards in {it:newname}\n")

	errprintf("{p 4 4 2}\n")
	errprintf("You requested\n")
	errprint_bf_string(oldp.original)
	errprintf("\n")
	errprintf("be renamed\n")
	errprint_bf_string(newp.original)
	errprintf(".\n")
	errprintf("There are more wildcards in {it:new} than in\n")
	errprintf("{it:old}.  Wildcards in {it:old} and {it:new}\n")
	errprintf("correspond one-to-one from left-to-right unless\n")
	errprintf("you specify explicit subscripts in {it:new}.\n")
	if (isaddnumber) { 
		errprintf("Because you specified option {bf:addnumber},\n")
		errprintf("you may specify an extra {bf:#}, {bf:(#)},\n") 
		errprintf("{bf:(##)}, etc.\n")
	}
	errprintf("Anyway, {bf:rename} ran out of wildcards in {it:old}\n")
	errprintf("when matching the wildcards in {it:new}.\n")
	errprintf("Perhaps you just made a mistake or perhaps you forgot\n")
	errprintf("an explicit subscript in {it:new}.\n")
	if (!isaddnumber) {
		errprintf("Or perhaps you forgot to specify option\n")
		errprintf("{bf:addnumber}, which allows you to specify\n")
		errprintf("an extra {bf:#}, {bf:(#)}, {bf:(##)}, ...\n")
	}
		
	errprintf("{p_end}\n")
	exit(198) 
}

void error_wildcardmatch_qm(`PatternS' oldp, `RS' j_old, 
			    `PatternS' newp, `RS' j_new)
{
	errprintf(
	"{bf:%s} in {it:newname} incompatible with {bf:%s} in {it:oldname}\n",
		printable_wildcard(newp.ellist[j_new]), 
		printable_wildcard(oldp.ellist[j_old])) 

	errprintf("{p 4 4 2}\n") 
	errprintf("You requested {bf:%s} be renamed {bf:%s}.\n", 
			oldp.original, newp.original)

	errprintf("Only {bf:?} or {bf:.} in {it:newname} are\n")
	errprintf("compatible with\n")
	errprintf("{bf:?} in {it:oldname}.  {bf:?} means\n")
	errprintf("substitute the character here.\n")
	errprintf("{bf:.} means to skip substituting\n")
	errprintf("the character altogether.\n")
	errprintf("{p_end}\n")
	exit(198)
}
	
void error_wildcardmatch_hash(`PatternS' oldp, `RS' j_old, 
			      `PatternS' newp, `RS' j_new)
{
	errprintf(
	"{bf:%s} in {it:newname} incompatible with {bf:%s} in {it:oldname}\n",
		printable_wildcard(newp.ellist[j_new]), 
		printable_wildcard(oldp.ellist[j_old])) 

	errprintf("{p 4 4 2}\n") 
	errprintf("You requested {bf:%s} be renamed {bf:%s}.\n", 
			oldp.original, newp.original)

	errprintf("Only numbers in both {it:oldname} and {it:newname}\n")
	errprintf("are compatible or, if option\n")
	errprintf(
		"{bf:renumber}[{bf:()}] is specified, number in {it:newname}\n")
	errprintf("is also compatible with {bf:*} or {bf:?} in {it:oldname}.\n")
	errprintf("{p_end}\n")
	exit(198)
}



void error_no_right_bracket(`SS' original)
{
	errprintf("syntax error\n")  

	errprintf("{p 4 4 2}\n") 
	errprintf("You specified {it:new} as\n")
	errprint_bf_string(original)
	errprintf(".\n")
	errprintf("You typed an open bracket [ without\n")
	errprintf("a corresponding closed bracket ].\n")
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}

void error_inside_brackets(`SS' original)
{
	errprintf("syntax error\n")  

	errprintf("{p 4 4 2}\n") 
	errprintf("You specified {it:new} as\n")
	errprint_bf_string(original)
	errprintf(".\n")
	errprintf("What appears inside brackets must be a number\n")
	errprintf("that indicates the corresponding wildcard in {it:old}.\n")
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}

void error_newnumber_subscripted(`PatternS' oldp, `PatternS' newp)
{
	errprintf(
	"{bf:addnumber} {bf:#}, {bf:(#)}, {bf:(##)}, ..., subscripted\n")  

	errprintf("{p 4 4 2}\n") 
	errprintf("You specified {it:old} =\n")
	errprint_bf_string(oldp.original)
	errprintf("\n")
	errprintf("and {it:new} =\n")
	errprint_bf_string(newp.original)
        errprintf("\n")
	errprintf("and you specified option {bf:addnumber}.\n")
	errprintf("Option {bf:addnumber} means that any {bf:#}, {bf:(#)},\n")
	errprintf("{bf:(##)}, ..., you specify is to be a new number.\n")
	errprintf("Ergo, subscripting it makes no sense.\n")
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}


void error_subscript_invalid(`PatternS' oldp, `PatternS' newp, `RS' subscr)
{
	errprintf("{it:new} pattern invalid\n")

	errprintf("{p 4 4 2}\n") 
	errprintf("You specified {it:old} =\n")
	errprint_bf_string(oldp.original)
	errprintf("\n")
	errprintf("and {it:new} =\n")
	errprint_bf_string(newp.original)
	errprintf(".\n")
	errprintf("There is no %g%s wildcard in {it:old}.\n",
					subscr, ordinal_suffix(subscr))
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}

void error_subscripts_in_old(`PatternS' pat)
{
	errprintf("open bracket not allowed\n")

	errprintf("{p 4 4 2}\n") 
	errprintf("You specified {it:old} =\n")
	errprint_bf_string(pat.original)
	errprintf(".\n")
	errprintf("The open square bracket appears to be the beginning of\n")
	errprintf("a subscript, and subscripts are not allowed in {it:old}.\n")
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}
	


				/* error message routines		*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
				/* debugging tools			*/

/*
	(void) dump_pattern(pat, typ, incl_names)
			    ---  ---  ----------

	    Debugging tool to dump pattern structure.
	    Returns
		void		success
		abort		pat has error
*/

void dump_pattern(`PatternR' pat, `SS' typ, `boolean' incl_names)
{
	`RS'	i, j, n
	`RS'	nv, k, m

	printf("{hline 60}\n")
	printf("Dump %s PatternR length=%g\n", typ, length(pat))
	for (i=1; i<=length(pat); i++) {
		printf("%g. original |%s| n=%g", i, pat[i].original, 
						n = length(pat[i].ellist))
		printf("   str=%g *=%g ?=%g #=%g (#)=%g ==%g .=%g\n", 
			pat[i].n_of[`ETstr'], 
			pat[i].n_of[`ETstar'], 
			pat[i].n_of[`ETqm'], 
			pat[i].n_of[`ETnum_v'],
			pat[i].n_of[`ETnum_f'],
			pat[i].n_of[`ETeq'], 
			pat[i].n_of[`ETodot'])


		for (j=1; j<=n; j++) {
			printf("    %g. |%s| %g=%-9uds %g -> %g\n", j,
				pat[i].ellist[j].element,
				pat[i].ellist[j].elementtype,
				dump_xlate_tt(pat[i].ellist[j].elementtype),
				pat[i].ellist[j].arg,
				pat[i].ellist[j].match)
		}
		if (incl_names) {
			nv = length(pat[i].varnames)
			if (rows(pat[i].pieces)) {
				assert(nv == rows(pat[i].pieces))
			}
			for (k=1; k<=nv; k++) {
				printf("    %8uds" , pat[i].varnames[k])
				if (rows(pat[i].pieces)) {
					printf(" = ")
					for (m=1; m<=cols(pat[i].pieces); m++) {
						printf("%s", pat[i].pieces[k,m])
						if (m != cols(pat[i].pieces)) {
							printf(" + ") 
						}
					}
				}
				printf("\n") 
			}
		}
	}
	printf("{hline 60}\n")
		
}

`SS' dump_xlate_tt(`ElementTypeS' t)
{
	if (t==`ETstrlist')	return("ETstrlist")
	if (t==`ETstr')		return("ETstr")
	if (t==`ETstar') 	return("ETstar")
	if (t==`ETqm')		return("ETqm")
	if (t==`ETnum_v')	return("ETnum_v")
	if (t==`ETnum_f')	return("ETnum_f")
	if (t==`ETeq')		return("ETeq")
	if (t==`ETodot')	return("ETodot")
	if (t==`ETnum_v_r')	return("ETnum_v_r")
	if (t==`ETnum_f_r')	return("ETnum_f_r")
	return("BROKEN")
}
	

void dump_options(`RenameS' ren)
{
	printf("options: isrecase = %g", ren.option.isrecase)
	if (ren.option.isrecase) {
		if (ren.option.isrecase_upper)  printf(" upper") 
		if (ren.option.isrecase_lower)  printf(" lower") 
		if (ren.option.isrecase_proper) printf(" proper") 
	}
	printf("\n") 
	printf("         isdryrun = %g\n", ren.option.isdryrun)
	printf("           istest = %g\n", ren.option.istest)
	printf("       isrenumber = %g, from=%g\n", 
					ren.option.isrenumber, ren.option.from)
	printf("      isaddnumber = %g\n", ren.option.isaddnumber)
	printf("         isrecase = %g\n", ren.option.isrecase)
}


void match_debug(`MatchS' m, `PelR' ellist, `SS' msg)
{
	printf("mdebug %s name=|%s| i0,i1=%g,%g j0,j1=%g,%g tt=",
		msg, m.name, 
		m.i0, m.i1, 
		m.j0, m.j1)

	if (m.j0>=1 & m.j0<=length(ellist)) {
		printf("%g,", ellist[m.j0].elementtype)
	}
	else	printf("!,")

	if (m.j1-1>=1 & m.j1-1<=length(ellist)) {
		printf("%g\n", ellist[m.j1-1].elementtype)
	}
	else	printf("!\n")
}

				/* debugging tools			*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
				/* utilities				*/

/*	_
	D = nonuniqrows(X)
			-

	    Given a matrix X which may have duplicate rows, return 
	    a unique list of the duplicate rows in D.

	    If X: r x c, then the returned is D: n x c, 0 <= n < r/2.
*/


transmorphic matrix nonuniqrows(transmorphic matrix x)
{
	real scalar		i, j, n, ns
	transmorphic matrix	sortx, res

	if (rows(x)<=1) return(J(      0, cols(x), missingof(x)))
	if (cols(x)==0) return(J(rows(x),       0, missingof(x)))

	sortx = sort(x, 1..cols(x))

	ns = 0
	n  = rows(x)
	for (i=2; i<=n; i++) {
		if (sum(sortx[i-1,]:==sortx[i,])) ns++
	}
	if (ns==0) return(J(0, cols(x), missingof(x)))

	res = J(ns, cols(x), sortx[1,1])
	j = 1
	for (i=2; i<=n; i++) {
		if (sum(sortx[i-1,] :== sortx[i,])) res[j++,] = sortx[i,]
	}
	return(uniqrows(res))
}


`SR' list_subtract(`SR' a, `SR' b)
{
	`SR' result

	st_local("A", invtokens(a))
	st_local("B", invtokens(b))
	stata("local C : list A - B")
	result = tokens(st_local("C"))
	st_local("A", "")
	st_local("B", "")
	st_local("C", "")
	return(result)
}

/*	______
	rowvec = expand_varlist(pattern, tmpname)
				-------  -------

	    Passed on Stata-interpretable pattern, return variables 
	    matching pattern.  Aborts with error if pattern=="" or 
	    no variables match specified pattern, or pattern invalid.
	    tmpname is just a tempname() that will 
	    be used to name a local macro, which will be cleared.
	    tmpname is passed so that expand_varlist() can be called 
	    repeatedly using the same varlist.
	    Returns, 
		void		success
		abort		Stata's -unab- returned error
*/

`SR' expand_varlist(`SS' pattern, `SS' tmpname)
{
	`RS'	rc
	`SR'	result

	rc = _stata("unab " + tmpname + " : " + pattern)
	if (rc) {
		exit(rc)
	}
	
	result = tokens(st_local(tmpname))

	(void) _stata("local " + tmpname)
	return(result)
}


/*	______
	suffix = ordinal_suffix(i)
			        -

	    Returns "th", "st", "nd", "rd", as appropriate.
*/


`SS' ordinal_suffix(`RS' i)
{
	`RS'	lastdigit 

	lastdigit = i - floor(i/10)*10
	if (lastdigit==0) return("th")
	if (lastdigit==1) return("st")
	if (lastdigit==2) return("nd")
	if (lastdigit==3) return("rd")
	return("th")
}
	


				/* utilities				*/
/* -------------------------------------------------------------------- */

end
