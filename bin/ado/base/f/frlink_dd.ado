*! version 1.1.3  16sep2019

/* -------------------------------------------------------------------- */
					// frlink dir
					// frlink describe

/*
   End user:
	frlink dir   			(see frlink_dir below)
	frlink describe <varname>	(see frlink_describe below)

   Internal:
	frlink_dd certify <varname> [, test]

*/

program frlink_dd, rclass
	version 16

	gettoken subcmd 0 : 0, parse(" ,")

	if ("`subcmd'"=="certify") {
		frlink_certify `0'
		exit
	}

	if ("`subcmd'"=="dir") {
		frame `c(frame)' {
			mata: frlink_dir()
		}
		exit
	}

	if ("`subcmd'"=="describe") {
		frame `c(frame)' {
			frlink_describe `0'
		}
		exit
	}

	if ("`subcmd'"=="get") {
		tokenize `0'
		args retmac colon linkvar thing
		c_local `retmac' ``linkvar'[frlink_`thing']'
		exit
	}

	di as err "invalid frlink_dd subcommand"
	exit 197
end


/* -------------------------------------------------------------------- */
					// frlink_certify

/*
    frlink_dd certify <varname> [, test]

	Certifies that the linkage is valid. 
	Option -test- does a more thorough test and is recommended.
*/


program frlink_certify
	syntax varname [, TEST]

	frlink__var `varlist'
	frame `c(frame)' {
		mata: frlink_certify("`varlist'", "`test'"!="")
	}
end


/* -------------------------------------------------------------------- */
					// frlink_describe

/*
    frlink describe <varname>

	Note that -frlink describe- does not call -frlink_dd certify- 
	because the describe command is a certify command, with 
	additional output.
*/


program frlink_describe, rclass
	syntax varname

	frlink__var `varlist'

	/* ------------------------------------------------------------ */
					// check version #

	frlink__var `varlist'
	frlink__cmd cmd : `varlist' nodebug

	frame `c(frame)' {
		mata: frlink_describe("`varlist'", "`cmd'")
	}
end


/* -------------------------------------------------------------------- */
					// Begin Mata code

					// standard header

version 16
set matastrict on

local RS	real scalar
local RR	real rowvector
local RC	real colvector
local RM	real matrix

local SS	string scalar
local SR	string rowvector
local SC	string colvector
local SM	string matrix

local TS	transmorphic scalar
local TR	transmorphic rowvector
local TC	transmorphic colvector
local TM	transmorphic matrix

local booleanS	`RS'
local booleanR	`RR'
local booleanC	`RC'
local booleanM	`RM'
local 		True	(1)
local 		False	(0)

					// specific header
local		BLKSIZE	20

local LinkInfoName	frlink_info
local LinkInfo		struct `LinkInfoName'
local LinkInfoS		`LinkInfo' scalar
local LinkInfoInit	`LinkInfoName'Init


mata:

/* -------------------------------------------------------------------- */
					// LinkInfo

`LinkInfo'
{
	`SS'	curframe		// Current frame
	`SS'    linkvar                 // Linkage being described

	// version not loaded, it is 1
	`SS'	mtyp			// {1:1|m:1}
	`SS'	fname1			// LHS frame at time created
	`SS'	fname2			// RHS frame at time created
	`SS'	vl1			// LHS varlist
	`SS'	vl2			// RHS varlist specified
	`SS'	vl2p			// RHS varlist 
	`SS'	gen			// varname
	`SS'	date			// date & time created

	`SS'	sig2			// _datasignature, nonames

	`RS'	obs2			// # of obs in fname2
	`SS'	sobs2			// obs2, str, with commas
	`SS'	FN			// c(filename) of fname2
	`SS'    FD			// c(filedate) of fname2
}

void `LinkInfoInit'(`LinkInfoS' m, `SS' linkvar) 
{
	if (st_global(linkvar+"[frlink_ver]")!="1") {
		exit(error(9))
	}

	m.curframe = st_framecurrent()
	m.linkvar  = linkvar

	m.mtyp   = st_global(linkvar+"[frlink_mtyp]")
	m.fname1 = st_global(linkvar+"[frlink_fname1]")
	m.fname2 = st_global(linkvar+"[frlink_fname2]")
	m.vl1    = st_global(linkvar+"[frlink_vl1]")
	m.vl2    = st_global(linkvar+"[frlink_vl2]")
	m.vl2p   = st_global(linkvar+"[frlink_vl2p]")
	m.gen    = st_global(linkvar+"[frlink_gen]")
	m.date   = st_global(linkvar+"[frlink_date]")

	m.sig2   = st_global(linkvar+"[frlink_sig2]")

	m.obs2   = strtoreal(st_global(linkvar+"[frlink_N2]"))
	m.sobs2  = strtrim(sprintf("%20.0gc", m.obs2))
	m.FN     = st_global(linkvar+"[frlink_FN]")
	m.FD     = st_global(linkvar+"[frlink_FD]")
}

					// LinkInfo
/* -------------------------------------------------------------------- */





/* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- */
					// frlink_certify()

void frlink_certify(`SS' linkvar, `booleanS' test)
{
	`LinkInfoS'	m

	/* ------------------------------------------------------------ */
						// set up
	
	pragma unset m
	`LinkInfoInit'(m, linkvar) 		// fill in m

	/* ------------------------------------------------------------ */

	frlink_certify_frameexists(m)	
	frlink_certify_match1(m)
	frlink_certify_N_and_match2(m)

	frlink_verify_sort(m, `False')

	frlink_certify_sig2(m)

	if (test) {
		frlink_certify_test(m, `False')
	}
}


void frlink_certify_frameexists(`LinkInfoS' m)
{
	if (st_frameexists(m.fname2)) return 

	errprintf("linked frame {bf:%s} not found\n", m.fname2) 

	errprintf("{p 4 4 2}\n")
	errprintf("Create the frame and load the data into it:\n")
	errprintf("{p_end}\n") 

	errprintf("{p 8 12 2}\n")
	errprintf("{bf:. frame create %s}\n", m.fname2)
	errprintf("{p_end}\n") 
	
	errprintf("{p 8 12 2}\n")
	errprintf(`"{bf:. frame %s: use "%s"}\n"', 
				m.fname2, (m.FN=="" ? "..." : m.FN))
	errprintf("{p_end}\n") 
	exit(459) 
	//NotReached
}

void frlink_certify_match1(`LinkInfoS' m)
{
	`RS'		n

	n = length(tokens(m.vl1))
	if (frlink_util_confirmvars(m.vl1)) return 

	errprintf("match %s not found in current frame\n", 
		   plural(n, "variable"))

	errprintf("{p 4 4 2}\n") 
	errprintf(n==1 ? "The match variable is\n" :
			 "The match variables are\n") 
	errprintf("{bf:%s}.\n", m.vl1) 
	if (n==1) { 
		errprintf("It was not found.\n") 
		errprintf("It must be restored before\n") 
	}
	else {
		errprintf("Some or all were not found.\n") 
		errprintf("They must be restored before\n") 
	}
	errprintf("the linkage can work or be rebuilt.\n")  
	errprintf("{p_end}\n") 
	exit(459)
	//NotReached
}

void frlink_certify_N_and_match2(`LinkInfoS' m) 
{
	`booleanS'	goodN, goodM

	goodN = frlink_certify_N(m)
	goodM = frlink_certify_match2(m)
	if (goodN && goodM) return 

	if (goodM) {
		errprintf("{p 4 4 2}\n") 
		errprintf("Type {bf:frame rebuild %s}\n", m.linkvar)
		errprintf("to update the linkage.\n") 
		errprintf("{p_end}\n")
		exit(459)
	}
	if (!goodN & !goodM) { 
		errprintf("{p 4 4 2}\n") 
		errprintf("The data in frame {bf:%s}\n", m.fname2)
		errprintf("has the wrong number of observations\n")
		errprintf("{it:and} is missing variables.\n") 
		errprintf("Do you have the right dataset\n") 
		errprintf("loaded into the frame?") 
		errprintf("{p_end}\n")
		errprintf("\n")
		errprintf("{p 4 4 2}\n")
		errprintf("If you do, the problems\n") 
	}
	else {
		errprintf("{p 4 4 2}\n") 
		errprintf("This problem\n") 
	}
	errprintf("can be fixed if you can restore\n") 
	errprintf("the missing match variable(s) to the data in\n")
	errprintf("frame {bf:%s}.\n", m.fname2) 
	errprintf("Do that and type\n") 
	errprintf("{p_end}\n")
	errprintf("{p 8 10 2}\n")
	errprintf("{bf:. frlink rebuild %s}.\n", m.linkvar)
	errprintf("{p_end}\n")
	exit(459)
}
	
// subr of frlink_certify_N_and_match2():
`booleanS' frlink_certify_N(`LinkInfoS' m) 
{
	`RS'	obs

	st_framecurrent(m.fname2)
	obs = st_nobs() 
	st_framecurrent(m.curframe)

	if (obs==m.obs2) return(`True') 

	errprintf("{p 0 4 2}\n") 
	errprintf("too %s observations in frame {bf:%s}\n", 
			(obs>m.obs2 ? "many" : "few"),
			m.fname2)
	errprintf("{p_end}\n") 
	return(`False')
}


// subr of frlink_certify_N_and_match2():
`booleanS' frlink_certify_match2(`LinkInfoS' m) 
{
	`booleanS'	result

	st_framecurrent(m.fname2)
	result = frlink_util_confirmvars(m.vl2p) 
	st_framecurrent(m.curframe)

	if (result) return(`True')

	errprintf("{p 0 4 2}\n") 
	errprintf("match %s not found in frame {bf:%s}\n", 
		plural(length(tokens(m.vl2p)), "variable"),
		m.fname2)
	errprintf("{p_end}\n") 
	return(`False')
}


void frlink_certify_sig2(`LinkInfoS' m)
{
	`RS'	n 
	`SS'	variables, have

	st_framecurrent(m.fname2)
	stata(sprintf("_datasignature %s, nonames", m.vl2p), 1, 1)
	st_framecurrent(m.curframe)
	if (m.sig2 == st_global("r(datasignature)")) return

	n         = length(tokens(m.vl2p))
	variables = plural(n, "variable") 
	have      = (n==1 ? "has" : "have") 
	

	errprintf("match %s %s changed in frame {bf:%s}\n", 
			variables, have, m.fname2)
	errprintf("{p 4 4 2}\n")
	errprintf("The match %s\n", variables) 
	errprintf("{bf:%s}\n", m.vl2p) 
	errprintf("%s changed since the linkage was built.\n", have) 
	errprintf("The linkage is invalid but fixable.  Type\n") 
	errprintf("{p_end}\n") 
	errprintf("{p 8 8 2}\n") 
        errprintf("{bf:. frlink rebuild %s}\n", m.linkvar)
	errprintf("{p_end}\n") 
	exit(459)
}

void frlink_certify_test(`LinkInfoS' m, `booleanS' noisy)
{
	`RS'	i, rc
	`SS'	cmd
	`SS'	lhs, rhs, rhsfcn

	lhs = tokens(m.vl1) 
	rhs = tokens(m.vl2p) 

	cmd = "assert "
	for (i=1; i<=length(lhs); i++) {
		if (i!=1) cmd = cmd + "|"
		rhsfcn = sprintf("_frval(%s,%s,%s)", 
						m.fname2, rhs[i], m.linkvar)
		cmd = cmd + sprintf("%s==%s", lhs[i], rhsfcn)
		frlink_certify_test_vtypes(m, lhs[i], rhs[i])
	}
	cmd = cmd + sprintf(" if %s!=.", m.linkvar) 
	// printf("{txt}To execute |%s|\n", cmd) 
	if ((rc = _stata(cmd, 1, 1))==0) {
		if (noisy) printf("{txt}  Linkage is up to date.\n")
		pragma unused rc
		return
	}

	errprintf("out-of-date linkage produces incorrect results\n")
	errprintf("{p 4 4 2}\n") 
	errprintf("It produces incorrect results because of changes\n")
	errprintf("that have been made in the data since the linkage\n")
	errprintf("was built.  It is fixable.  Type")
	errprintf("{p_end}\n") 
	errprintf("{p 8 8 2}\n") 
        errprintf("{bf:. frlink rebuild %s}\n", m.linkvar)
	errprintf("{p_end}\n") 
	exit(459)
}

void frlink_certify_test_vtypes(`LinkInfoS' m, `SS' vn1, `SS' vn2)
{
	`booleanS'	isnum1, isnum2

	isnum1   = st_isnumvar(vn1) 
	st_framecurrent(m.fname2)

	isnum2   = st_isnumvar(vn2) 
	st_framecurrent(m.curframe)

	if (isnum1==isnum2) return

	errprintf("match variables' types differ\n")
	errprintf("{p 4 4 2}\n")
	errprintf("Match variable {bf:%s} in the current frame is %s\n",
			vn1, (isnum1 ? "numeric" : "string"))
	errprintf("and {bf:%s} in frame {bf:%s} is %s.\n", 
			vn2, m.fname2, (isnum2 ? "numeric" : "string"))
	errprintf("They were of the same type when the linkage\n") 
	errprintf("was created.  To fix the problem, restore the\n")
	errprintf("original match variables and type\n") 
	errprintf("{p_end}\n") 
	errprintf("{p 8 8 2}\n") 
	errprintf("{bf:. frame rebuild %s}\n", m.linkvar)
	errprintf("{p_end}\n")
	exit(459) 
}


`booleanS' frlink_util_confirmvars(`SS' s)
{
	return(hasmissing(_st_varindex(tokens(s), 0))==0)
}


					// frlink_certify()
/* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- */
					// frlink_describe()
	
void frlink_describe(`SS' linkvar, `SS' cmd) 
{
	`LinkInfoS'	m


	/* ------------------------------------------------------------ */
						// fill in m
	
	`LinkInfoInit'(m, linkvar) 

	/* ------------------------------------------------------------ */
						// intro

	frlink_describe_history(   m, cmd)
	frlink_certify_frameexists(m)	
	frlink_describe_current(   m)

	/* ------------------------------------------------------------ */
						// certify

	printf("  Verifying linkage...\n") 

	frlink_certify_match1(      m)
	frlink_certify_N_and_match2(m)

	frlink_verify_sort(m, `True')
	frlink_certify_sig2(m)
		
	/* ------------------------------------------------------------ */
						// Test

	frlink_certify_test(m, `True')
}


void frlink_describe_history(`LinkInfoS' m, `SS' cmd)
{
	`SS'		dirname, filename, div


	/* ------------------------------------------------------------ */
				// Link variables created by ... 
	
	printf("{txt}\n")
	printf("  History:\n")
	printf("  {hline}\n")
	printf("{p 4 4 2}\n") 
	printf("{txt}Link variable {bf:%s} created on %s by\n", m.linkvar, m.date)
	printf("{p_end}\n")
	printf("\n")
	printf("{p 4 11 2}\n")
	printf("{bf:. %s}\n", cmd) 
	printf("{p_end}\n")

	printf("\n")
	printf("{txt}{p 4 4 2}\n")
	printf("Frame {res:%s} contained\n", m.fname2) 

	if (m.FN=="") {
		printf("{txt}an unnamed dataset\n") ;
	}
	else {
		pragma unset dirname
		pragma unset filename
		pathsplit(m.FN, dirname, filename)
		printf("{res:%s}\n", filename) 
		if (dirname!="") {
			div = usubstr(m.FN, ustrlen(m.FN)-ustrlen(filename),1)
			printf("stored in\n")
			printf("{res:%s}\n", dirname+div) 
		}
		
	}
	printf("{p_end}\n") 
	printf("  {hline}\n")
}

void frlink_describe_current(`LinkInfoS' m)
{
	`booleanS'	iswindows 
	`SS'		hfullname, hdirname, hfilename	// historic
	`SS'		cfullname, cdirname, cfilename  // current

	/* ------------------------------------------------------------ */
				// define hfullname, cfullname

	iswindows = (st_global("S_OS")=="Windows")

	hfullname = (iswindows ? subinstr(m.FN, "/", "\")
			       : subinstr(m.FN, "\", "/") )
			
	st_framecurrent(m.fname2)
	cfullname = c("filename") 
	st_framecurrent(m.curframe)

	/* ------------------------------------------------------------ */
				// done if hfullname==cfullname

	if (iswindows) {
		if (strlower(hfullname)==strlower(cfullname)) return
	}
	else {
		if (hfullname==cfullname) return
	}

	/* ------------------------------------------------------------ */
				// done if hfilename==cfilename

	pragma unset hdirname
	pragma unset hfilename
	pragma unset cdirname
	pragma unset cfilename
	pathsplit(hfullname, hdirname, hfilename)
	pathsplit(cfullname, cdirname, cfilename)
	if (iswindows) {
		if (strlower(hfilename)==strlower(cfilename)) return
	}
	else {
		if (hfilename==cfilename) return
	}

	/* ------------------------------------------------------------ */
				// filenames differ

	printf("{p 2 4 2}\n") 
	printf("The file in frame {bf:%s} is now named\n", m.fname2)
	printf("{bf:%s}.\n", cfullname) 
	printf("{p_end}\n") 
}




void frlink_verify_sort(`LinkInfoS' m, `boolean' noisy)
{
	/* ------------------------------------------------------------ */
	st_framecurrent(m.fname2)
	stata("describe, varlist", 1, 1)
	if (m.vl2p == st_global("r(sortlist)")) {
		st_framecurrent(m.curframe)
		return 
	}
	stata("sort " + m.vl2p, 1, 1)
	st_framecurrent(m.curframe)

	if (noisy) {
		printf("{txt}{p 2 2 2}\n")
		printf(" Data in frame {bf:%s}\n", m.fname2) 
		printf("needed to be sorted on match %s, and have been.\n", 
			plural(length(tokens(m.vl2p)), "variable"))
		printf("{p_end}\n") 
	}
}


					// frlink_describe()
/* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- */
					// frlink_dir 

void frlink_dir()
{
	`SR'	vnames, toonew
	`RS'	i, n

	/* ------------------------------------------------------------ */
					// obtain names

	pragma unset vnames
	pragma unset toonew
	frlink_vars(vnames, toonew) 

	/* ------------------------------------------------------------ */
					// set return results

	st_numscalar("return(n_toonew)", length(toonew), "hidden")
	st_numscalar("return(n_vars)",   length(vnames))
	if (length(vnames)) { 
		st_global("return(vars)",         invtokens(vnames))
	}
	if (length(toonew)) {
		st_global("return(toonew)",       invtokens(toonew), "hidden") 
	}

	/* ------------------------------------------------------------ */
					// display output

	if ( (n=length(toonew)) ) {
		printf("{p 2 2 3}\n")
		printf("{txt}(%f %s -- \n", n, plural(n, "variable"))
		for (i=1; i<=n; i++) printf("{bf:%s}\n", toonew[i])
		printf("-- ignored because\n")
		printf(n==1 ? "it was\n" : "they were\n")
		printf("created by a more recent version of\n")
		printf("{bf:frlink}.  Update your Stata to use them.\n")
		printf("{p_end}\n") 
	}
	if ( (n=length(vnames)) == 0 ) {
		printf("{p 2 2 3}\n")
		printf("{txt}(no variables created by {bf:frlink} found)\n")
		printf("{p_end}\n") 
		return 
	}
	printf("{txt}  (%f {bf:frlink} %s found)\n", n, plural(n, "variable"))
	for(i=1; i<=n; i++) {
		printf("  {hline}\n")
		printf("{p 2 24 2}\n")
		printf("{txt}{res:%s} created by\n", vnames[i])
		printf("{txt}{bf:%s}\n", frlink_cmd(vnames[i]))
		printf("{p_end}\n")
	}
	printf("  {hline}\n")
	printf("{p 2 2 2}\n")
	printf(`"Note: Type "{bf:frlink describe} {it:varname}" to\n"')
	printf("find out more, including whether the variable is\n")
	printf("still valid.\n")
	printf("{p_end}\n")

}

void frlink_vars(`TM' vnames, `TM' toonew)
{
	`RS'	k, K		// var index and # of vars

	`SS'	vname
	`SS'	char
	`RS'	n		// # elements vname currently defined 
	`RS'	N		// # elements vname currently allocated


				// allocate
	vnames = J(1, `BLKSIZE', "") 
	N      = `BLKSIZE'
	n      = 0

	toonew = J(1, 0, "") 

				// build vnames[]
	K = st_nvar()
	for (k=1; k<=K; k++) {
		vname = st_varname(k) 
		char = st_global(vname + "[frlink_ver]")
		if (char=="1") {
			if (++n > N) {
				vnames = vnames, J(1, `BLKSIZE', "")
				N = N + 10
			}
			vnames[n] = vname
		}
		else if (char!="") { 
			toonew = (toonew, vname)
		}
	}
	vnames = (n ? vnames[|1\n|] :  J(1,0,""))
}


/*	______
	cmdstr = frlink_cmd(varname)
			     -------

	Returns command that created frlink variable varname.
	This routine is just a call to the Stata ado-file 
	-frlink__cmd-.
*/


`SS' frlink_cmd(`SS' varname)
{
	`SS'	result

	stata(sprintf("frlink__cmd frlinkcmd : %s nodebug", varname),1,1)
	result = st_local("frlinkcmd")
	st_local("frlinkcmd", "") 
	return(result) 
}

	
					// frlink_dir 
/* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- */

end
