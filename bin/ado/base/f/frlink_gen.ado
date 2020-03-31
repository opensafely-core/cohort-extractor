*! version 1.0.4  25sep2019


/*
    frlink_gen.ado is called by frlink.ado 

    ---------------------------------------------------------------------
    Syntax:

	frlink  {1:1|m:1} <varlist1>, frame(<frname> [<varlist2>])
                                      [generate(<newvar>)]
				      [debug(nodate d v)]

    ---------------------------------------------------------------------
    Defaults:

	1.  <varlist2> defaults to <varlist1>.

        2.  <newvar> defaults to <frname> 

    ---------------------------------------------------------------------
    -frlink- records characteristics:

	<newvar>[frlink_ver]       1                          (see note 1)
	<newvar>[frlink_mtyp]     {1:1|m:1}
	<newvar>[frlink_fname1]   <current frame at time frlink issued>
	<newvar>[frlink_fname2]   <fname>
	<newvar>[frlink_vl1]      <varlist1>
	<newvar>[frlink_vl2]      <varlist2>   (might be blank)
	<newvar>[frlink_vl2p]     <varlist2> if not blank, else <varlist1>
	<newvar>[frlink_gen]      <newvar>
	<newvar>[frlink_date]     `c(current_date)' `c(current_time)'
				    -- or --
                                   "01jan1960 11:00:00" if -nodate-
				   
	<newvar>[frlink_N2]       # (# obs in <fname>)
        <newvar>[frlink_FN]       `c(filename)' of <frname>

	<newvar>[frlink_FD]       `c(filedate)' of <frname>
				    -- or --
                                   "01jan1960 11:00:00" if -nodate-

	<newvar>[frlink_sig2]     _datasignature, nonames

	<newvar>[frlink_debug]    <debug ops>

	Notes:
	    1.  The 1 is version number of <newvar>[] characteristics.
		
    ---------------------------------------------------------------------
     -frlink- returns in r()

	scalar r(unmatched)        # of obs in <fname1> that are unmatched

     FYI, _N-r(unmatched) observations are matched.


*/

program frlink_gen, rclass sortpreserve
	version 16

	/* ------------------------------------------------------------ */
					// set frame1

	local frame1 `c(frame)'

	
	/* ------------------------------------------------------------ */
					// parse
	gettoken mtyp 0 : 0

	syntax varlist , FRame(string)	  ///
		         [ GENerate(name) ///
			   DEBUG(string)     ]


	// ---------------------------------------------------------------
					// parse frame(<frame2> [<varlist2]]

	frameop_parse frame2 varlist2 :   `"`frame'"'

					// parse debug([nodate] [d|v])
					// sets    
					//        usedate = 1|0 (default 1)
					//        usedata = 1|0 
					// usedate means phony date
					// usedata means use st_data

					// set default for usedata
	local usedata_default 1		// use 0=st_view(), 1=st_data()
	debugop_parse usedate usedata  : `usedata_default' `"`debug'"'

	// ---------------------------------------------------------------
					// generate(<newvarname>) 

	if ("`generate'"=="") {
		local generate `frame2'
	}
	capture confirm new variable `generate'
	if (_rc) {
		di as err "variable `generate' already exists"
		exit 110
	}

	// ---------------------------------------------------------------
					// check variables 
	if ("`varlist2'" != "") {
		confirm_var_cnt        "`varlist'"          "`varlist2'"
		confirm_var_typ_match  "`varlist'" `frame2' "`varlist2'"
	}
	else {
		confirm_var_exist      "`varlist'" `frame2' 
		confirm_var_typ_match  "`varlist'" `frame2' "`varlist'"
	}

	/* ------------------------------------------------------------ */
					// make varlist2p

	if ("`varlist2'"=="") {
		local varlist2p `varlist'
	}
	else {
		local varlist2p `varlist2'
	}
		
	/* ------------------------------------------------------------ */
					// create <newvar> as tmp `mvar'
					// later renamed to `generate'
	
	tempvar mvar
	quietly gen double `mvar' = . 

					// set characteristics of <newvar>
	char `mvar'[frlink_ver]   1
	char `mvar'[frlink_mtyp]   `mtyp'
	char `mvar'[frlink_fname1] `frame1'
	char `mvar'[frlink_fname2] `frame2'
	char `mvar'[frlink_vl1]    `varlist'
	char `mvar'[frlink_vl2]    `varlist2'
	char `mvar'[frlink_vl2p]   `varlist2p'
	char `mvar'[frlink_gen]    `generate'
	if (`usedate'==0) {
		local fd "01jan1960 11:00:00"
	}
	else	local fd `c(current_date)' `c(current_time')
	char `mvar'[frlink_date]   `fd'

	frame `frame2' {
		quietly cwf `frame2'
		local  x : di %12.0f _N
		local fn `"`c(filename)'"'
		local fd   `c(filedate)'
		local N2 : di %14.0f c(N)
	}

	local N2 = strtrim("`N2'")
	char `mvar'[frlink_N2]        `N2'
	char `mvar'[frlink_FN]     `"`fn'"'
	if (`usedate'==0 & "`fd'"!="") {
		local fd "01jan1960 11:00:00"
	}
	char `mvar'[frlink_FD]      `fd'

	if ("`debug'"!="") {
		char `mvar'[frlink_debug] `debug'
	}

	// char `mvar'[frlink_sig2]   not yet filled in. See below.

	/* ------------------------------------------------------------ */
					// sort frames  and check them


					// frame1: 
	sort `varlist'
	if ("`mtyp'"=="1:1") {
		capture by `varlist': assert _n==1
		if (_rc) {
			frlink_err_frame1_notuniq "`varlist'"
			// NotReached
		}
	}

					// frame2:
	capture frame `frame2' {
		sort `varlist2p'
		by `varlist2p': assert _n==1
	}
	if (_rc) {
		frlink_err_frame2_notuniq "`varlist2p'" "`frame2'"
		// NotReached
	}

					// set _datasignature
	frame `frame2' {
		qui _datasignature `varlist2p', nonames
	}
	char `mvar'[frlink_sig2] `r(datasignature)'
	
	/* ------------------------------------------------------------ */
					// merge frames

	frame `frame1' {
		mata: merge("`mvar'", "`frame1'", "`varlist'",   ///
				      "`frame2'", "`varlist2p'", ///
			      `usedata') 
	}

	/* ------------------------------------------------------------ */
					// display output
	tempname unmatched
	quietly count if `mvar'==.
	return scalar unmatched = r(N)
	if (r(N)==0) {
		di as txt "  (all observations in frame {bf:`frame1'} matched)"
	}
	else if (r(N)==_N) {
		di as txt "  (no observations in {bf:`frame1'} matched!)"
	}
	else {
		local s = cond(r(N)==1, "", "s")
		local n : display %18.0fc r(N)
		local n = strtrim("`n'") 
		di as txt "  (`n' observation`s' in frame {bf:`frame1'} unmatched)"
	}

	/* ------------------------------------------------------------ */
					// compress and rename mvar
	quietly compress `mvar'
	rename `mvar' `generate'
end


program frlink_err_frame1_notuniq
	args varlist1

	local n : list sizeof varlist1
	if (`n'==1) {
		local variables variable
		local do        does
	}
	else {
		local variables variables
		local do        do
	}

	di as err "invalid match variables for {bf:1:1} match"
	di as err "{p 4 4 2}"
	di as err "The `variables'"
	di as err "{bf:`varlist1'} `do' not uniquely identify the"
	di as err `"observations in frame {bf:`c(frame)'}."'
	di as err "Perhaps you meant to specify {bf:m:1}"
	di as err "instead of {bf:1:1}."
	di as err "{p_end}"
	exit 459
end

program frlink_err_frame2_notuniq
	args varlist2p frame2

	local n : list sizeof varlist2p
	if (`n'==1) {
		local variables variable
		local do        does
	}
	else {
		local variables variables
		local do        do
	}

	di as err "invalid match variables for 1:1 or m:1 match"
	di as err "{p 4 4 2}"
	di as err "The `variables' you specified for matching"
	di as err "`do' not uniquely identify the observations"
	di as err "in frame {bf:`frame2'}."
	di as err "Each observation in the current frame {bf:`c(frame)'}"
	di as err "must link to {it:one} observation in {bf:`frame2'}."
	di as err "{p_end}"
	exit 459
end

program confirm_var_cnt
	args varlist1 varlist2
	local n1 : list sizeof varlist1
	local n2 : list sizeof varlist2
	if (`n1'==`n2') {
		exit
	}
	local s1 = cond(`n1'==1, "", "s")
	local s2 = cond(`n2'==1, "", "s")

	di as err "variables misspecified"
	di as err "{p 4 4 2}"
	di as err "You specified `n1' variable`s1' after the "
	di as err "{bf:frlink} command, but `n2' variable`s2'"
	di as err "in the {bf:frame()} option.  There must be"
	di as err "a one-to-one correspondence between the two"
	di as err "variable lists."
	di as err "{p_end}"
	exit 198
end

/* -------------------------------------------------------------------- */
						// confirm_var_typ_match
/*
    confirm_var_typ_match "<varlist1>" <frame2> "<varlist2>"

	Confirm that <default>::<varlist1> variables have the 
	same type as <frame2>::<varlist2>.

	This routine assumes there are the same number of variables in 
	each varlist.
*/

program confirm_var_typ_match
	args varlist1 frame2 varlist2

	foreach name1 of local varlist1 {
		gettoken name2 varlist2 : varlist2
		confirm_var_typ_u g2 : `name1'
		frame `frame2': confirm_var_typ_u g1 : `name2'
		if ("`g1'"!="`g2'") { 
			if ("`name1'"=="`name2'") {
				di as err "`name1' variable types mismatch"
			}
			else {
				di as err ///
				"`name1'/`name2' variable types mismatch"
			}
			exit 459
		}
	}
end
		
program confirm_var_typ_u 
	args	gtypemac colon varname

	local typ : type `varname'
	if (substr("`typ'", 1, 3) == "str") {
		c_local `gtypemac' str
	}
	else {
		c_local `gtypemac' num
	}
end


/* -------------------------------------------------------------------- */
					// confirm_var_exist

/*
    confirm_var_exist "<varlist1>" <frame2>

	Confirm that each unabbreviated variable name in <varlist1>
	exists in <frame2> in unabbreviated form.
	Issues error message
*/


program confirm_var_exist
	args varlist1 frame2

	/* ------------------------------------------------------------ */
				// confirm vars exist, perhaps
				// in abbreviated form

	foreach name1 of local varlist1 {
		capture frame `frame2': confirm var `name1'
		if (_rc) {
			di as err ///
			"variable {bf:`name1'} not found in frame `frame2'"
			exit 111
		}
	}

	/* ------------------------------------------------------------ */
				// unabbreviate <varlist1> in <frame2>
				// we know this will not error out
				// because we just checked existence

	frame `frame2': unab ulist2 : `varlist1'

	/* ------------------------------------------------------------ */
				// verify unabbreviated names equal 
				// names in <varlist1> 

	foreach name1 of local varlist1 {
		gettoken name2 ulist2 : ulist2
		if ("`name1'"!="`name2'") {
			di as err ///
			"variable {bf:name1} not found in frame `frame2'"
			exit 111
		}
	}
end


/* -------------------------------------------------------------------- */
					// debugop_parse
/*
	framedebug_parse usedate usedate : dflt_usedata str

	Parse
		[nodate [d|v]]
	
	Return
		usedate	0|1,            0 if -nodate- specified
		usedata 0|1, dflt_usedata if -d- and -v- not specified
                                        1 if -d- specified
				        0 if -v- specified
				    error if -d- and -v- specified
*/

program debugop_parse
	args m_usedate m_usedata colon dflt_usedata str

	local 0 `", `str'"'
	syntax [, NODATE D V]

	// -----------------------------------------------------------
						// set m_usedate

	local x = cond("`nodate'"=="", 1, 0)
	c_local `m_usedate' `x'

	// -----------------------------------------------------------
						// set m_usedata


	local dv = "`d'`v'"
	if ("`dv'"=="") {
		c_local `m_usedata' `dflt_usedata'
		exit
		// NotReached
	}

	if ("`dv'"=="d") {
		local x 1 
	}
	else if ("`dv'"=="v") {
		local x 0
	}
	else {
		di as err "option {bf:debug()} used incorrectly"
		exit 198
	}

	c_local `m_usedata' `x'
	local y = cond(`x', "st_data()", "st_view()")
	local z = cond(`x'!=`dflt_usedata', "(overriding default)", ///
					    "(which is default)")
	di as txt "  DEBUG: using `y' `z'"
end

	
/* -------------------------------------------------------------------- */
					// frameop_parse

/*
	frameop_parse m1 m2 : str

	Parse
		<frname> [<varlist_in_frname>]

	return:
		m1   <frname>
                m2   <varlist_in_frname> or ""
*/
	
	
program frameop_parse
	args frame2mac varlist2mac colon str


	local frame1 `c(frame)'

	/* ------------------------------------------------------------ */
						// Parse <frname>
	gettoken frame2 0 : str
	if ("`frame2'" == "") {
		frameop_err `"`frame(`frameop')"'
		// NotReached
	}

	/* ------------------------------------------------------------ */
						// Check <frname> is specified
						// in a valid manner

	capture confirm name `frame2'
	if (_rc) {
		local rc = _rc 
		di as err "{bf:frame()} option specified incorrectly"
		di as err "{p 4 4 2}"
		di as err "The option requires a name of an existing frame,"
		di as err "optionally followed by the names of one or more"
		di as err "match variables in that frame.  You specified"
		di as err `""{bf:`frame2'}" as the frame name, which Stata"'
		di as err "thinks is not a valid name.  Perhaps you included"
		di as err "punctuation such as a comma."
		di as err "{p_end}"
		exit `rc'
	}

	/* ------------------------------------------------------------ */
						// Check <frname> exists
						// Parse <varlist> 
	
	capture noi frame `frame2': syntax [varlist(default=none)]
	if (_rc) {
		local rc = _rc 
		di as err "{p 4 4 2}"
		di as err "The error refers to a variable in frame `frame2'."
		di as err "Perhaps you made an obvious mistake."
		di as err "If, however, the variables used for matching"
		di as err "have different names in the two frames, then"
		di as err "{p_end}"
		di as err "{p 8 12 2}"
		di as err "1.  Specify `frame1''s variable name(s) just as you"
		di as err "are now doing, following the {bf:frlink}"
		di as err "command."
		di as err "{p_end}"
		di as err "{p 8 12 2}"
		di as err "2.  Specify `frame2''s corresponding name(s)"
		di as err "in the {bf:frame(`frame2')} option.  The"
		di as err "syntax is {bf:frame(`frame2'} {it:varlist}{bf:)}."
		di as err "{p_end}"
		exit `rc'
	}


	/* ------------------------------------------------------------ */
						// Done

	c_local   `frame2mac' `frame2'
	c_local `varlist2mac' `varlist'
end

program frameop_err
	args	specified
	di as err "option frame() misspecified"
	di as err "{p 4 4 2}"
	di as err `"You specified {bf:`specified'}."'
	di as err "The syntax of frame() is"
	di as err "{p_end}"
	di as err
	di as err "{col 8}{bf:frame(}{it:framename}{bf:)}" 
	di as err "   {it:or}"
	di as err "{col 8}{bf:frame(}{it:framename}{bf:)} {it:varlist}{bf:)}" 
	di as err 
	di as err "{p 4 4 2}"
	di as err "Use the first syntax when the match variables have"
	di as err "the same name in {it:framename} as they do in"
	di as err "the current frame.  The second is for when they differ."
	di as err "{p_end}"
	exit 198
end

					// frameop_parse
/* -------------------------------------------------------------------- */



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

/* -------------------------------------------------------------------- */
					// TC_M and TS_R

local pTCr	pointer(`TC') rowvector
local pTSr	pointer(`TS') rowvector

local TC_M	`pTCr'
local TS_R	`pTSr'

/*
    Comment about pTCr and pTSr (and TC_M and TS_R)

	pTCr can be a matrix with columns of different types 
	Example:

	    pTCr M   =   (ptr,      ptr,  ...,    ptr)
                           |         |             |
		          \|/       \|/           \|/
                      colvector colvector     colvector

	Think of the above as a "transmorphic-column matrix", TC_M.
	You refer to the             matrix as    M.
	You refer to a               column as  (*M[j]).
	You refer to an             element as ((*M[j])[i]).

	The TC_M has cols(M)     columns.
	The TC_M has rows(*M[1]) rows    if rows(*M[j]) are all equal.

	pTSr is like a row from the above matrix:

	    pTSr m   =   (ptr,      ptr,  ...,    ptr)
                           |         |             |
		          \|/       \|/           \|/
                         scalar   scalar        scalar

	Think of it as a "transmorphic-scalar rowvector", TS_R.
	You refer to the       vector as   m.
	You refer to an       element as (*m[j]). 

	The TS_R has cols(m) columns (or vector is of length(m) if you 
	prefer).

	To construct m = row i of M, code:

	    m = J(1, cols(M), NULL)
	    for (j=1; j<=cols(M); j++) m[i] = &((*M[j])[i])
*/

					// TC_M and TS_R
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					// Mata code

mata:

/*	      ____
	merge(mvar, frame1, vl1, frame2, vl2, usedata)
	      ----  ------  ---- ------  ---- ------

	Inputs:
	    mvar	name of existing variable in frame1, current 
			contents irrelevant.  Variable should be 
			-double-.  Caller can -compress- after this 
			routine runs. 

	    frame1      lhs frame
	    vl1         list of key variable names in frame1

	    frame2      rhs frame
	    vl1         list of key variable names in frame1

	    usedata     use 1=st_date(), 0=st_view() 

        Outputs:
	    mvar:       values of variable updated to contain matching 
			frame2 obs. 

	Assumptions:

	    1.  frame1 data are in ascending order of idx1 vars.

	    2.  frame2 data are in ascending order of idx2 vars.

	    3.  Each idx1 and idx2 variable can be numeric or string, 
		but if variables in same position must having matching 
		numeric or string types.

	This routine produces no errors except for --break--, r(1).
*/

void merge(`SS' mvar, `SS' frame1, `SS' vl1, 
                      `SS' frame2, `SS' vl2, `booleanS' usedata)
{
	`RR'	idx1, idx2
	`RR'	isstrvar
	`RC'	mvals 
	`RS'	n1, cnt_isstrvar

	/* ------------------------------------------------------------ */
					// if obs == 0 in either dataset,
					// there are no matches and 
					// we are done
	st_framecurrent(frame1) 
	if (((n1=st_nobs()))==0) return 

	st_framecurrent(frame2) 
	if (st_nobs()==0) return 

	/* ------------------------------------------------------------ */
					// get var indices
					// get string/numeric types
	idx1 = varnum(frame1, vl1) 
	idx2 = varnum(frame2, vl2) 

					// get string/numeric types
					// 1 & 2 have same types
	isstrvar     = isstr(frame1, idx1)
	cnt_isstrvar = sum(isstrvar)

	/* ------------------------------------------------------------ */
					// allocate mvals

	mvals = J(n1, 1, .) 

	/* ------------------------------------------------------------ */
					// split per complication 

	if (cnt_isstrvar == 0) {
		mvals = merge_same(`True', frame1, idx1, 	  ///
					   frame2, idx2, usedata) 
	}
	else if (cnt_isstrvar == length(isstrvar)) {              ///
		mvals = merge_same(`False', frame1, idx1, 
					    frame2, idx2, usedata) 
	}
	else {
		mvals = merge_mixed(isstrvar,		     ///
					frame1, idx1, 	     ///
					frame2, idx2, usedata)
	}

	/* ------------------------------------------------------------ */
					// save m in frame1::mvar

	st_framecurrent(frame1) 
	st_store(., mvar, mvals) 
}


/*	----------
	varnumlist = varnum(frame, vl)
			    -----  --

	Inputs:
	    frame	name of frame
	    vl		string scalar varname list in frame containing 
			k names 

	Outputs:
	    varnumlist  1 x k vector corresponding variable indices
*/


`RR' varnum(`SS' frame, `SS' vl)
{
	st_framecurrent(frame) 
	return(st_varindex(tokens(vl)))
}


/*	________
	isstrtyp = isstr(frame, idx)

	Inputs:
	    frame	name of frame
	    idx		1 x k vector of variable indices in frame

	Output:
	    isstrvar    1 x k vector
			isstrvar[i] `True'  if idx[i] is string var
				    `False' if           real   var
*/
	
`booleanR' isstr(`SS' frame, `RR' idx)
{
	`RS'		i
	`booleanR'	typ

	st_framecurrent(frame) 

	typ = J(1, length(idx), .) 
	for (i=1; i<=length(idx); i++) {
		typ[i] = (substr(st_vartype(idx[i]), 1, 3)=="str") 
	}
	return(typ)
}



/*	_
	m = merge_same(isnumeric, frame1, idx1, frame2, idx2, usedata)
		       ---------  ------  ----  ------  ----  -------

	Inputs:
	    isnumeric	key variables all numeric; else all string

	    frame1      name of frame1 (lhs)
	    idx1        1 x k: indices of key variables in frame1

	    frame2      name of frame2 (rhs)
	    idx2	1 x k:  indices of key variables in frame2

	    usedata     use 1=st_data(), 0=st_view()

	Output:
	    match	n1 x 1:  match[i] = obsno in frame2 of
				            obs. i in frame1;
				            . if no match 

	Note: Code assumes data in frame1 in ascending order idx1 values.
	      Code assumes data in frame2 in ascending order idx2 values. 
*/

/*           			       _
    (void) myst_data(isnumeric, usedata, M, i)
		     ---------  -------     -

	Load M using st_data() or st_sdata(),
                  or st_view() or st_sview()
*/

void myst_data(`booleanS' isnumeric, `booleanS' usedata, `TM' M, `RR' i)
{
	if (usedata) {
		M = (isnumeric ? st_data(., i) : st_sdata(., i))
	}
	else {
		if (isnumeric) st_view( M, ., i)
		else	       st_sview(M, ., i)
	}
}
	

`RC' merge_same(`booleanS' isnumeric, 
		`SS' frame1, `RR' idx1, 
		`SS' frame2, `RR' idx2, `booleanS' usedata) 
{
	`RC'	match			// returned result
	`TM'	M1			// n1 x k, frame1 keys
	`TM'	M2			// n2 x k, frame2 keys

	`TR'	m1			// 1 x k: M1[i1, .]
	`TR'	m2			// 1 x k: M2[i1, .]

	`RS'	i1, i2			// cur. row of M1, M2
	`RS'	n1, n2			// # of rows M1, M2

	`RS'	signum			// -1, 0, 1 for <, ==, >

	/* ------------------------------------------------------------ */
					// load keys into M1, M2
					// M1, M2 copies, but could be 
					// views. 
	
	pragma unset M1
	pragma unset M2

	st_framecurrent(frame2) 
	myst_data(isnumeric, usedata, M2, idx2)
	st_framecurrent(frame1) 
	myst_data(isnumeric, usedata, M1, idx1)
	

	/* ------------------------------------------------------------ */
					// set n1, n2
					// make match

	n1    = rows(M1)
	n2    = rows(M2)
	match = J(n1, 1, .) 
		
	/* ------------------------------------------------------------ */
					// merge

	/*
	    At the start of while() loop, code considers a combination 
	    of (i1,i2) no previously considered, and assumes that 
	    m1 = M1[i1,.] and m2 = M2[i2,.].
	*/
	
	i1 = i2 = 1 			// cur. is row 1 of M1 and M2
	m1 = M1[i1, .]			// cur. m1 = M1[i1,.]
	m2 = M2[i2, .]			// cur. m2 = M2[i2,.]

	while (1) {
		signum = compar(m1, m2) 
		if (signum == 0) {			// match
			match[i1] = i2
			if (++i1 > n1) return(match)
			m1 = M1[i1, .]
		}
		else if (signum < 0) {			// m1 < m2
			if (++i1 > n1) return(match)
			m1 = M1[i1, .]
		}
		else {					// m1 > m2
			if (++i2 > n2) return(match)
			m2 = M2[i2, .]
		}
	}
	// NotReached
	return(match) 	// anyway
}


/*	______
	signum = compar(m1, m2)
			--  --

	Inputs:
		m1, m2: 1 x n vectors, both string or both real

	Output:
		-1	m1 < m2
		 0	m1 == m2
		 1      m1 >  m2
*/
		
`RS' compar(`TR' m1, `TR' m2)
{
	`RS'		i		// index into m1, m2
	`RS'		n		// length(m1) (equal to length(m2))

	n = length(m1) 
	for (i=1; i<=n; i++) {
		if (m1[i]<m2[i]) return(-1)
		if (m1[i]>m2[i]) return( 1)
	}
	return(0) 
}
		

/*	_
	m = merge_mixed(isstrvar, frame1, idx1, frame2, idx2, usedata)
		        --------  ------  ----  ------  ----  -------

	Note: This is the same logic as merge_same(), but works 
	with variables of mixed types (string/numeric).

	Inputs:
	    isstrvar    1 x k: bTrue of var is string

	    frame1      name of frame1 (lhs)
	    idx1        1 x k: indices of key variables in frame1

	    frame2:     name of frame2 (rhs)
	    idx2	1 x k:  indices of key variables in frame2

	    usedata     use 1=st_data(), 0=st_view()

	Output:
	    match	n1 x 1:  match[i] = obs. # in frame2 
					    of obs. i in frame1;
				            . if no match 

	Note: Code assumes data in frame1 in ascending order idx1 values.
	      Code assumes data in frame2 in ascending order idx2 values. 

	To understand the following code, see 
	"Comment about pTCr and pTSr (and TC_M and TS_R)".

	TC_M stands for transmorphic-column matrix.

	TS_R stands for transmorphic-scalar rowvector and is a row 
	of a TC_M. 

*/


`TC' newcol() 
{
	return(J(0,1,.))
}


`RC' merge_mixed(`booleanR' isstrvar,
		 `SS' frame1, `RR' idx1, 
		 `SS' frame2, `RR' idx2, `booleanS' usedata) 
{
	`RC'	match			// returned result

	`TC_M' M1			// 1 x k, frame 1 keys
					// *(M1[j]): n1 x 1 of key j values 

	`TC_M'  M2			// 1 x k, frame 2 keys
					// *(M1[j]): n2 x 1 of key j values 

	`TS_R'  m1                      // 1 x k:  key val for obs. i1
	`TS_R'  m2                      // 1 x k:  key val for obs. i2

	`RS'	i1, i2			// cur. row of M1, M2
	`RS'	n1, n2			// # of rows M1, M2
	
	`RS'	k, K			// index to key vars, # of key vars

	`RS'	signum			// -1, 0, 1 for <, ==, >

	/* ------------------------------------------------------------ */
					// load keys into M1, M2
					// M1, M2 copies, but could be 
					// views. 

	K  = length(idx1) 		// # of key vars 

	st_framecurrent(frame2) 
	M2 = J(1, K, NULL) 

	for (k=1; k<=K; k++) {
		M2[k] = (&(newcol()))
		myst_data(!isstrvar[k], usedata, *(M2[k]), idx2[k])
	}

	st_framecurrent(frame1)
	M1 = J(1, K, NULL) 
	for (k=1; k<=K; k++) {
		M1[k] = (&(newcol()))
		myst_data(!isstrvar[k], usedata, *(M1[k]), idx1[k])
	}

	/* ------------------------------------------------------------ */
					// set n1, n2

	n1 = rows(*M1[1])		
	n2 = rows(*M2[1])
					// make match
	match = J(rows(*M1[1]), 1, .) 

		
	/* ------------------------------------------------------------ */
					// merge

	/*
	    At the start of while() loop, code considers a combination 
	    of (i1,i2) not previously considered, and assumes that 
	    m1 = (row i of M1) and m2 = (row i of M2). 
	*/
	

	i1 = i2 = 1 			// cur. is row 1 of M1 and M2
	m1 = TS_R_of(M1, i1)		// cur. m1 = row i1 of M1
	m2 = TS_R_of(M2, i2)		// cur. m2 = row i2 of M2


	while (1) {
		signum = compar_mixed(m1, m2) 
		if (signum == 0) {			// match
			match[i1] = i2
			if (++i1 > n1) return(match)
			m1 = TS_R_of(M1, i1)
		}
		else if (signum < 0) {			// m1 < m2
			if (++i1 > n1) return(match)
			m1 = TS_R_of(M1, i1)
		}
		else {					// m1 > m2
			if (++i2 > n2) return(match)
			m2 = TS_R_of(M2, i2)
		}
	}
	// NotReached
	return(match) 	// anyway
}


`TS_R' TS_R_of(`TC_M' M, `RS' i) 
{
	`TS_R' 	m
	`RS'	k, K

	m = J(1, K = cols(M), NULL)
	for (k=1; k<=K; k++) m[k] = &((*M[k])[i])
	return(m)
}

`RS' compar_mixed(`TS_R' m1, `TS_R' m2)
{
	`RS'		i		// index into m1, m2
	`RS'		n		// length(m1) (equal to length(m2))

	n = length(m1) 
	for (i=1; i<=n; i++) {
		if ((*m1[i]) < (*m2[i])) return(-1)
		if ((*m1[i]) > (*m2[i])) return( 1)
	}
	return(0) 
}

end

					// Mata code
/* -------------------------------------------------------------------- */
