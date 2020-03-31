*! version 1.0.5  02feb2015

/*
	These utilities are used by [R] mi

	Provided below are

		u_mi_flongsep_erase()

		u_mi_wide_swapvars()

		u_mi_rm_dta_chars()

		u_mi_parse_xeq()


		u_mi_get_mata_instanced_var()

		u_mi_cpchars_get()
		u_mi_cpchars_put()
*/



local RS	real scalar
local RC	real colvector
local SS	string scalar
local SR	string rowvector
local SC	string colvector
local SV	string vector
local SM	string matrix
local PS	pointer(transmorphic) scalar

/* -------------------------------------------------------------------- */
/*
	u_mi_flongsep_erase(basename, from [, output])

	    Inputs:
		from		`RS', where to begin erasing (0 usual)
		output		`RS', whether to produce output
	    Outputs:
		<none>

	    Purpose:
		If from==0, then erase mi dataset(s) <basename>.
	        This includes _1_<basename>, _2_<basename>, ...

		if from>0, erase mi datasets _<from>_<basename>, 
		_<from+1>_<basename>, ...

		May be used with flongsep data, or regular datasets.
*/


version 11
mata:
void u_mi_flongsep_erase(`SS' basename, `RS' from, |`RS' output)
{
	`RS'	i, loc, m, zeroerased
	`SS'	potential, torm
	`SS' 	fullname, name
	`RC'	o, idx

	if (args()==2) output = 1

	if (strtrim(basename)=="") { 
		errprintf("u_mi_flongsep_erase(): missing basename\n")
		exit(198)
	}

	fullname = basename + ".dta"

	potential = dir(".", "files", "_?*_" + fullname)
	torm     = J(0,1,"")
	idx      = J(0,1,.)
	for (i=1; i<=length(potential); i++) {
		name = bsubstr(potential[i], 2)
		if ((loc = strpos(name, "_"))) {
			m = strtoreal(bsubstr(name, 1, loc-1))
			if (m>=from & m<10000) {
				if (bsubstr(name, loc+1, .)==fullname) {
					torm = (torm \ potential[i])
					idx  = (idx  \ m)
				}
			}
		}
	}
	zeroerased = 0
	if (from==0) {
		if (fileexists(fullname)) {
			unlink(fullname)
			zeroerased = 1
		}
	}
	for (i=1; i<=length(torm); i++) unlink(torm[i])

	if (output) { 
		if (zeroerased | length(torm)) { 
			printf("{txt}{p}")
			printf(zeroerased + length(torm)==1 ? 
						"(file\n" : "(files\n")
			if (zeroerased) printf("%s\n", fullname)
			if (length(torm)) {
				o = order(idx, 1)
				_collate(torm, o)
				// _sort(torm, 1)
				for (i=1; i<=length(torm); i++) {
					printf("%s\n", torm[i])
				}
			}
			printf("erased)\n") 
			printf("{p_end}\n")
		}
		else if (output==2) { 
			printf("{txt}(no files found to erase)\n")
		}
	}
}
end



/* -------------------------------------------------------------------- */
/*
	u_mi_wide_swapvars(`RS' m, `SS' tmpvar)

	    Inputs:
		m		`RS' swap m and 0
		tmpvar		`SS' name of tempvar that does not exist
		
	    Outputs:
		<none>		(m and 0 swapped)

	    Purpose:
		Obtaining the list of variables from _dta[_mi_pvars] and
		_dta[_mi_ivars], for each variable <x>, swap <x> and _m_<x>

		This function is its own inverse assuming _dta[_mi_pvars]
		and _dta[_mi_ivars] do not change.
*/

version 11
mata:
void u_mi_wide_swapvars(`RS' m, `SS' tmpvar)
{
	`SR'	var
	`SS'	v, newv
	`RS'	i

	if (m==0) return

	var = tokens(st_global("_dta[_mi_ivars]") + " " + 
				st_global("_dta[_mi_pvars]"))

	for(i=1; i<=length(var); i++) {
		newv = sprintf("_%g_%s", m, v=var[i])
		st_varrename(v, tmpvar)
		st_varrename(newv, v)
		st_varrename(tmpvar, newv)
	}
}
end




/* -------------------------------------------------------------------- */
/*
	u_mi_rm_dta_chars()

	    Purpose
		remove all _dta[_mi_*] characteristics
*/

version 11
mata:

void u_mi_rm_dta_chars()
{
	`RS'	i
	`SC'	list

	list = st_dir("char", "_dta", "*", 1)
	for (i=1; i<=length(list); i++) {
		if (bsubstr(list[i], 1, 9)!="_dta[_mi_") {
			st_global(list[i], "")
		}
	}
}
end



/* -------------------------------------------------------------------- */
/*
	u_mi_parse_xeq(`SS' args)

	    Inputs:
		args		`SS' containing colon-separated commands
	    Outputs:
		N		Stata local, # of commands saved
		cmd1		Stata local, 1st command
		cmd2		Stata local, 2nd command
		..		..
		cmd`N'		Stata local, `N'th command

	Purpose:
		Specialized utility used by -mi xeq-.

*/

version 11
mata:
void u_mi_parse_xeq(`SS' args)
{
	`RS'	i, l
	`RS'	in_simple_quotes, n_compound_quotes
	`SS'	c1, c2, cmd
	`SV'	cmds


	args = strtrim(args)

	in_simple_quotes = n_compound_quotes = 0
	cmds = J(1, 0, "")
	cmd  = ""
	l = strlen(args)
	for(i=1; i<=l; i++) {
		c1  = bsubstr(args,   i, 1)
		c2  = bsubstr(args, i+1, 1)
		if (n_compound_quotes) {
			if (c1=="`" & c2==`"""') {
				cmd = cmd + c1 + c2
				++n_compound_quotes
				++i
			}
			else if (c1==`"""' & c2=="'") {
				cmd = cmd + c1 + c2
				--n_compound_quotes
				++i
			}
			else	cmd = cmd + c1
		}
		else if (in_simple_quotes) {
			if (c1==`"""') {
				cmd = cmd + c1
				in_simple_quotes = 0
			}
			else	cmd = cmd + c1
		}
		else if (c1=="`" & c2==`"""') {
			cmd = cmd + c1 + c2
			++n_compound_quotes
			++i
		}
		else if (c1==`"""') { 
			cmd = cmd + c1
			in_simple_quotes = 1
		}
		else if (c1==";") {
			cmds = cmds , cmd
			cmd  = ""
		}
		else {
			cmd = cmd + c1
		}
	}
	if (in_simple_quotes | n_compound_quotes) {
		errprintf("quotes do not balance\n")
		exit(198)
	}
	if (cmd!="") cmds = cmds, cmd
		
	st_local("N", strofreal(length(cmds)))
	for (i=1; i<=length(cmds); i++) { 
		st_local(sprintf("cmd%g", i), strtrim(cmds[i]))
	}
}
end

/* -------------------------------------------------------------------- */

/*
	u_mi_get_mata_instanced_var("<macname>", "<basename>" [, i_value])

	Inputs:
		"<macname>"		name of localmacro
		"<basename>"		base name of instanced variable
		i_value			initial value (0x0 real default)

	Outputs:
		`<macname>'		creates mata var and stores name 
					in <macname>

	Purpose:
	    Find a new Mata global -- base the name on "<basename>" --
	    and create.  Return name of variable in local <macname>.
            Optionally, initialize the variable with i_value.
	    Default initialization is 0x0 real.

	Usage:
		...
		local var
		capture noisily {
			mata: u_mi_get_mata_instanced_var("var", "myvar")
			...
			... use `var' as you wish ...
			...
		}
		nobreak {
			local rc = _rc
			capture mata: mata drop `var'
			if (`rc') {
				exit `rc'
			}
		}
		...
*/

version 11
mata:
void u_mi_get_mata_instanced_var(`SS' macname, `SS' basename, |transmorphic ival)
{
	`RS'	i
	`SS'	fullname
	`PS'	p

	for (i=1; 1; i++) {
		fullname = sprintf("%s%g", basename, i)
		if ((p=crexternal(fullname)) != NULL) {
			if (args()==3) *p = ival
			st_local(macname, fullname)
			return
		}
	}
	/*NOTREACHED*/
}

/* -------------------------------------------------------------------- */

/*
	u_mi_cpchars_get(matavar)
	u_mi_cpchars_put(matavar, {0|1|2})

	Inputs, u_mi_cpchars_get()
	    matavar		variable; contents irrelevant

	Ouputs, u_mi_cpchars_get()
	    matavar		contains chars

	Inputs, u_mi_cpchars_put()
	    matavar             chars from u_mi_cpchars_get()
	    {0|1|2}		how to treat _dta[_mi_*]

	Purpose:
	    Replace characteristics in one dataset with those of another.

            u_mi_cpchars_get(matavar) stores chars of data in memory in
            matavar.  Data in memory remains unchanged.

            u_mi_cpchars_put(matavar, #) replaces chars of data in memory 
            with those in matavar.  REPLACES, not merges.

	Usage:
	    Declare matavar transmorphic.

	    If calling from these routines from Stata, obtain matavar from 
	    u_mi_get_mata_instanced_var().

	    Second argument concerns source of _dta[_mi_*] macros in 
	    destination dataset:
		0	delete them
		1	get from source (no special treatment)
		2	retain from destination

	    u_mi_cpchars_put() may be used multiple times.
*/

void u_mi_cpchars_get(transmorphic res)
{
	real scalar	i

	res = st_char_dir()
	res = res, J(rows(res), 1, "")

	for (i=1; i<=rows(res); i++) res[i,2] = st_global(res[i,1])
}

void u_mi_cpchars_put(`SM' res, `RS' mitreatment)
{
	real scalar		i
	string colvector	michars, micnts
	string colvector	todel

	/* ------------------------------------------------------------ */
	/*
		optionally retain current _dta[_mi_*]
	*/

	if (mitreatment == 2) {
		michars = st_dir("char", "_dta", "_mi_*", 1)
		micnts  = J(rows(michars), 1, "")
		for (i=1; i<=rows(michars); i++) {
			micnts[i] = st_global(michars[i])
		}
	}

	/* ------------------------------------------------------------ */
	/*
		delete *[*]
		set chars equal to *[*] stored in res
	*/

	st_char_rm()
	for (i=1; i<=rows(res); i++) (void) _st_global(res[i,1], res[i,2])

	/* ------------------------------------------------------------ */
	/*
		optionally delete _dta[_mi_*]
	*/
	if (mitreatment!=1) {
		todel = st_dir("char", "_dta", "_mi_*", 1)
		for (i=1; i<=rows(todel); i++) {
			st_global(todel[i], "")
		}
	}

	/* ------------------------------------------------------------ */
	/*
		optionally restore _dta[_mi_*] previously saved
	*/
	if (mitreatment==2) {
		for (i=1; i<=rows(michars); i++) {
			st_global(michars[i], micnts[i])
		}
	}
}
end
/* -------------------------------------------------------------------- */
