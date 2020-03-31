*! version 1.0.8  09sep2019

/*
	spmatrix userdefined <Wmatname> = <fcnname>(<varlist>) 
			     [if] [in] [, <options>]

	    <fcnname> := S<name>     matrix is  symmetric
	                 A<name>     matrix is asymmetric

	   <options> := 
		normalize(spectral)	default
		normalize(minmax)
		normalize(row)
		normalize(nonew)
		replace
		donotpost               test mode
*/

program spmatrix_userdefined
	version 15


	// -------------------------------------------------------- parse ---
	gettoken Wmatname 0 : 0, parse(",()=")
	gettoken equals   0 : 0, parse(",()=")
	gettoken fcnname  0 : 0, parse(",()=")
	gettoken oparen   0 : 0, parse(",()=")

	tok_exists "`Wmatname'" "matrix name"
	tok_exists "`equals'"   "{bf:=} sign"
        tok_exists "`fcnname'"  "function name"
	tok_exists "`oparen'"  "open parenthesis"

	tok_is     "`equals'"   "="
	tok_is     "`oparen'"   "("

	// 0 expected to contain "<varlist>) [if] [in] [, <options>]"
	local i = strpos(`"`0'"', ")")
	local j = strpos(`"`0'"', ",") 
	if (`i'==0) { 
		di as err "matching close parenthesis not found"
		exit 198
	}
	if (`i'==1 | (`j'!=0 & `j' <= `i') ){
		fcname_error, fcnname(`fcnname')
	}

	local 0 = substr(`"`0'"', 1, `i'-1) + substr(`"`0'"', `i'+1, .)
	syntax varlist(numeric) [if] [in] ///
			[, NORMalize(string) REPLACE DONOTPOST]
	marksample touse

	/* Summary
		Wmatname     matrix name (not yet verified)
                fcnname      function name (not yet verified) 
		varlist      variable names (verified)
		touse        touse variable
                normalize    normalize option (not yet verified)
		replace      "replace" if -replace- specified
		donotpost    "donotpost" if testmode
	*/

	proc_Wmatname Wmatname : "`Wmatname'" 
	proc_replace isreplace : "`replace'"
	proc_normalize norm : "`normalize'"
	proc_fcnname   "`fcnname'"


	// ------------------------------------------------------ summary ---

        /*
		Wmatname replace     matrix name and whether replace
                fcnname              function name 
		varlist              variable names (one or more)
		touse                touse variable
                norm                 "spectral|minmax|row|none"
		donotpost    	     "donotpost" if testmode
	*/

	local nopost = ("`donotpost'"!="")

	local symmetric = (substr("`fcnname'", 1, 1)=="S")

	__sp_parse_id	
	local id `s(id)'

	mata: buildandpost("`Wmatname'",                              ///
                           `symmetric', &`fcnname'(), "`varlist'",    ///
			   "`touse'",                                 ///
			   "`norm'", `nopost', `isreplace', `"`id'"')
end


program tok_exists
	args  tok expected 

	if ("`tok'"=="") {
		di as err "nothing found where `expected' expected"
		exit 198
	}
end

program tok_is
	args   tok is

	if ("`tok'" != "`is'") {
		di as err "{bf:`tok'} found where {bf:`is'} expected"
		exit 198
	}
end

program proc_normalize
	args ret colon norm

	local norm = strtrim(`"`norm'"')
	if (`"`norm'"' == "") {
		c_local `ret' spectral
		exit
	}

	local   l = strlen(`"`norm'"')

	if ("`norm'"==substr("spectral", 1, max(`l', 4))) {
		c_local `ret' spectral
	}
	else if ("`norm'"==substr("minmax", 1, max(`l', 4))) {
		c_local `ret' minmax
	}
	else if ("`norm'"=="row") {
		c_local `ret' row
	}
	else if ("`norm'"==substr("none", 1, max(`l', 1))) {
		c_local `ret' none
	}
	else {
		di as err "{bf:normalize(`norm')} invalid"
		di as err "    Allowed are"
		di as err "        {bf:normalize(spectral)}"
		di as err "        {bf:normalize(minmax)}"
		di as err "        {bf:normalize(row)}"
		di as err "        {bf:normalize(none)}"
		di as err "    {bf:normalize(spectral)} is the default."
		exit 198
	}
end

program proc_fcnname
	args fcnname

	local fcnname = strtrim(`"`fcnname'"')
	if (strlen(`"`fcnname'"')>=2) {
		local c = substr(`"`fcnname'"', 1, 1)
		if ("`c'"=="S" | "`c'"=="A") {
			test_fcn `fcnname'
			exit
			// NotReached
		}
	}
	di as err "function name {bf:`fcnname'()} invalid"
	di as err "{p 4 4 2}"
	di as err "Function name must be of the form {bf:S}{it:name}"
	di as err "or {bf:A}{it:name} such as {bf:SinvD}"
	di as err "or {bf:Awind}.  
	di as err "{p_end}"
	exit 198
end


program test_fcn
	args fcnname

	capture mata: `fcnname'()
	local rc = _rc 

	if (`rc'==0) {
		di as err "function `fcnname'() written incorrectly"
		di as err "{p 4 4 2}"
		di as err "The function must take two arguments, not zero."
		di as err "{p_end}"
		looks_like_this
		exit 3001
	}

	if (`rc' == 3499) {
		di as err "function `fcnname'() not found"
		di as err "{p 4 4 2}"
		di as err "Write in Mata a function named {bf:`fcnname'()}"
		di as err "before using the {bf:spmatrix userdefined}"
		di as err "command."
		di as err "{p_end}"
		looks_like_this
		exit 111
	}
end

program looks_like_this
	di as err "    Here is an example:"
	di as err
	di as err _col(8) "mata:"
	di as err _col(8) "function SinvD(vi, vj)"
	di as err _col(8) "{c -(}"
	di as err _col(16) "return(1/sqrt((vi-vj)*(vi-vj)'))"
	di as err _col(8) "{c )-}"
	di as err _col(8) "end"
	di as err
	di as err "{p 4 4 2}"
	di as err "The function takes two arguments.  They are row vectors."
	di as err "It returns a scalar, the potential spillover from"
        di as err "a place with characteristics {bf:b} to a place with"
        di as err "characteristics {bf:a}."
	di as err "{p_end}"

end

program proc_Wmatname
	args	ret colon Wmatname 

	local Wmatname = strtrim("`Wmatname'")
	c_local `ret' `Wmatname'

	capture confirm name `Wmatname'
	if (_rc) {
		di as err "Wmatname {bf:`Wmatname'} invalid"
		exit 198
	}
end

program proc_replace
	args ret colon replace

	if (`"`replace'"'== "") {
		local isreplace = 0
	}
	else {
		local isreplace = 1
	}

	c_local `ret' = `isreplace'
end

program fcname_error
	syntax [, fcnname(string) ]
	di as err "syntax error"
	di as err "{p 4 4 2}"
	di as err "syntax is {bf:`fcnname'(}{it:varlist}{bf:)}"
	di as err "{p_end}"
	exit 198
end


	
local RS	real scalar
local RR	real rowvector
local RC	real colvector
local RM	real matrix
local SS	string scalar
local SR	string rowvector
local boolean	`RS'
local pFCN      pointer(real scalar function) scalar

mata:

mata set matastrict on

void buildandpost(`SS' Wmatname, 
		  `boolean' symmetric, `pFCN' pfcn, `SS' varnames, 
		  `SS' tousevar,
	          `SS' norm, `boolean' donotpost, `boolean' isreplace,	///
		  `SS' idvar)
{
	`RS'    N, i, j
	`RM'	W, C
	`RR'	ci
	`RC'    id

	C = st_data(., tokens(varnames), tousevar)
        N = rows(C)
	W = J(N, N, 0) 

	if (symmetric) {
		for (i=1; i<=N; i++) {
			ci = C[i, .]
			for (j=1; j<i; j++) {
				W[i,j] = W[j,i] = (*pfcn)(ci, C[j, .])
			}
			checkWrow(W, symmetric, i)
		}
	}
	else {
		for (i=1; i<=N; i++) {
			ci = C[i, .]
			for (j=1; j<=N; j++) {
				if (i!=j) {
					W[i,j] = (*pfcn)(ci, C[j, .])
				}
			}
			checkWrow(W, symmetric, i)
		}
	}

	if (donotpost) {
		printf("Debug mode: saving matrix as global W\n")
		rmexternal("W")
		*crexternal("W") = W
		return
	}


	// ------------------------------------------------- post W ---

	id = st_data(., idvar, tousevar)
	_SPMATRIX_create_object(	///
		Wmatname,		///
		isreplace,		///
		&W,			///
		id,			///
		"",			///
		norm,			///
		"custom")
}

void checkWrow(`RM' W, `boolean' symmetric, `RS' i)
{
	`RR'	row
	`RS'	neg, mis

	if (symmetric) row = W[| i,1 \i,i |]
	else           row = W[i, .]

	
	neg = rowsum(row :< 0) 
	mis = hasmissing(row)
	if (!neg & !mis) return

	errprintf("user-defined function returned inappropriate value\n")
	errprintf("{p 4 4 2}\n")
	errprintf("When working on row %f\n", i) 
	errprintf("of the matrix, the user-defined function returned\n")
	if (neg & mis) { 
		errprintf("negative and, separately, missing values.\n")
	}
	else if (neg) errprintf("negative values.\n")
	else          errprintf("missing values.\n") 
	errprintf("{p_end}\n")
	exit(459)
}

end
