*! version 3.2.5  12apr2019
program merge 
	version 11

	gettoken mtype 0 : 0, parse(" ,")

	/* ------------------------------------------------------------ */
				/* linkage to prior version		*/
	if (!strpos("`mtype'", ":") & "`mtype'"!="") {
		if (_caller()>=11) {
			di as smcl as txt "{p}"
			di as smcl "(note: you are using old"
			di as smcl "{bf:merge} syntax; see"
			di as smcl "{bf:{help merge:[D] merge}} for new syntax)"
			di as smcl "{p_end}"
		}
		merge_10 `mtype' `0'
		exit
	}

	local origmtype `"`mtype'"'
	mata: map_mtype(`"mtype"')

	/* ------------------------------------------------------------ */
				/* parsing				*/
				/* we have pulled off <mtype> from 0	*/
	gettoken token : 0, parse(" ,")
	if ("`token'"=="_n") {
		if ("`mtype'"!="1:1") {
			error_seq_not11 "`mtype'" "`origmtype'"
			/*NOTREACHED*/
		}
		gettoken token 0 : 0, parse(" ,")
		local mtype "_n"
	}

	syntax [varlist(default=none)] using/ [,	///
		  ASSERT(string)			///
		  DEBUG					///
		  GENerate(name)			///
		  FORCE					///
		  KEEP(string)				///
		  KEEPUSing(string)			///
		noLabels				///
		  NOGENerate			        ///
		noNOTEs					///
		  REPLACE				///
		noREPort				///	
		  SORTED				///
		  UPDATE       				///
		]

	if ("`mtype'"!="_n") {
		local origmtype `"`mtype'"'
		mata: map_mtype(`"mtype"')
		if ("`varlist'"=="") {
			error_mat_varlist "`mtype'" "`origmtype'"
			/*NOTREACHED*/
		}
	}
	else {
		if ("`mtype'"=="_n") { 
			if ("`varlist'"!="") { 
				error_seq_varlist 
				/*NOTREACHED*/
			}
		}
	}

	mata: fullfilename("using", "usingfull", "using")
	// confirm file "`usingfull'"

	mata: resultlist("assert")
	mata: resultlist("keep")

	if ("`generate'"!="") { 
		if ("`nogenerate'"!="") {
			di as smcl err "{p}"
			di as smcl "options -generate()- and -nogenerate-"
			di as smcl "may not be specified together."
			di as smcl err "{p_end}"
		}
		confirm new var `generate'
	}

	if ("`replace'"!="") {
		if ("`update'"=="") {
			error_replace
			/*NOTREACHED*/
		}
	}

					/* parsing			*/
	/* ------------------------------------------------------------ */


	/* ------------------------------------------------------------ */
					/* check sort			*/
	if ("`sorted'"=="" & "`mtype'"!="_n") {
		local sortedby : sortedby
		checksort "`sortedby'" "`varlist'"
		if (!r(sorted)) { 
			sort `varlist'
		}
		quietly describe using "`using'", varlist short
		local sortedby "`r(sortlist)'"
		checksort "`sortedby'" "`varlist'"
		if (!r(sorted)) { 
			preserve 
			qui use "`using'", clear 
			sort `varlist'
			tempfile using 
			qui save "`using'", replace
			restore
		}
	}
					/* check sort			*/
	/* ------------------------------------------------------------ */


	/* ------------------------------------------------------------ */
					/* build _merge command		*/
	if ("`nogenerate'"!="") {
		tempvar mergevar
		local mergevaristemp 1
	}
	else {
		local mergevar = cond("`generate'"!="", "`generate'", "_merge")
		local mergevaristemp 0
	}

	local options `update' `replace' `notes' `labels' _merge(`mergevar') ///
			`force'
	if (bsubstr("`mtype'", 1, 1)=="1") {
		local options `options' uniqmaster
	}
	if (bsubstr("`mtype'", 3, 1)=="1") {
		local options `options' uniqusing
	}
	if ("`keepusing'"!="") { 
		local options `options' keep(`keepusing')
	}

	if ("`keep'"  !="" & !strpos("`keep'"  , "2")) {
		local options `options' nokeep
	}

	if (_caller() > 15) {
		local version : di "version " string(_caller()) ": "
	}

	local _merge `"`version'_merge `varlist' using "`using'", nowarn"'
	local _merge `"`_merge' `options' tabulate(mresults)"'
					/* build _merge command		*/
	/* ------------------------------------------------------------ */


	/* ------------------------------------------------------------ */
					/* perform merge		*/
	if ("`debug'"!="") {
		di as txt _n "command is"
		di `"`_merge'"' _n 
	}
	`_merge'
					/* perform merge		*/
	/* ------------------------------------------------------------ */


	/* ------------------------------------------------------------ */
					/* label _merge			*/
	if (!`mergevaristemp') {
		capture label list _merge
		if (_rc) { 
			label define _merge ///
			1 "master only (1)" 2 "using only (2)" ///
			3 "matched (3)" ///
			4 "missing updated (4)" 5 "nonmissing conflict (5)"
		}
		label values `mergevar' _merge
	}
					/* label _merge			*/
	/* ------------------------------------------------------------ */


	/* ------------------------------------------------------------ */
				/* process results			*/

				/* 1.  check assert()		*/
	if ("`assert'"!="") {
		if (_caller() < 13) {
			buildexpr expr : `mergevar' "`assert'"
			capture assert `expr'
			if (_rc) {
				error_assert `mergevar' "`assert'"
				/*NOTREACHED*/
			}
		}
		else {
			capture checkmresults "`mresults'" "`assert'"
			if (_rc) {
				error_assert `mergevar' "`assert'"
				/*NOTREACHED*/
			}
		}
	}

				/* 2.  process keep()		*/
	if ("`keep'"!="") {
		buildexpr expr : `mergevar' "`keep'"
		quietly keep if `expr'
	}
				/* process results			*/
	/* ------------------------------------------------------------ */



	/* ------------------------------------------------------------ */
				/* reestablish sort order		*/
	if ("`mtype'"=="1:1") {
		qui count if `mergevar'==2
		if (r(N)==0) {
			sort `varlist'
		}
	}
	/* ------------------------------------------------------------ */


	/* ------------------------------------------------------------ */
				/* present table			*/
	if (c(noisily) & "`report'"=="") {
		local isupdate = ("`replace'"!="" | "`update'"!="")
		present_table `isupdate' `mergevar' `mergevaristemp'
	}
	/* ------------------------------------------------------------ */
end


program error_replace
	di as smcl as err "option {bf:replace} not allowed"
	di as smcl as err "{p 4 4 2}"
	di as smcl as err "option {bf:replace} requires you also specify"
	di as smcl as err "option {bf:update}, thus demonstrating your"
	di as smcl as err "understanding that an update will be performed"
	di as smcl as err "{p_end}"
	exit 198
end


program error_assert 
	args mergevar assert

	local n     : word count `assert'
	local comma = cond(`n'>2, ",", "")
	local nm1   = `n' - 1

	local type : word 1 of `assert'
	mata: resulttext("text", `type')

	di as smcl as err "{p 0 4 2}"
	di as smcl as err "merge:  after merge, not all observations"
	di as smcl as err "`text'`comma'"

	forvalues i=2(1)`nm1' {
		local type : word `i' of `assert'
		mata: resulttext("text", `type')
		di as smcl as err "`text'`comma'"
	}

	if (`n'>1) {
		local type : word `n' of `assert'
		mata: resulttext("text", `type')
		di as smcl as err "or `text'"
	}

	di as smcl as err "{p_end}"
	di as err _col(9) "(merged result left in memory)"
	exit 9
end


program present_table 
	args isupdate mergevar mergevaristemp

	if (!`mergevaristemp') {
		local v1 "(`mergevar'==1)"
		local v2 "(`mergevar'==2)"
		local v3 "(`mergevar'==3)"
		local v4 "(`mergevar'==4)"
		local v5 "(`mergevar'==5)"
	}
	quietly { 
		count if `mergevar'==1
		local m1 = r(N)
		count if `mergevar'==2
		local m2 = r(N)
		if (`isupdate') { 
			count if `mergevar'==3
			local m3 = r(N)
			count if `mergevar'==4
			local m4 = r(N)
			local m5 = _N - `m1' - `m2' - `m3' - `m4'
		}
		else {
			local m3 = _N - `m1' - `m2' 
		}
	}

	di
	di as smcl as txt _col(5) "Result" _col(38) "# of obs."
	di as smcl as txt _col(5) "{hline 41}"
	di as smcl as txt _col(5) "not matched" ///
		_col(30) as res %16.0fc (`m1'+`m2')
	if (`m1'|`m2') { 
		di as smcl as txt _col(9) "from master" ///
			_col(30) as res %16.0fc `m1' as txt "  `v1'"
		di as smcl as txt _col(9) "from using" ///
			_col(30) as res %16.0fc `m2' as txt "  `v2'"
		di
	}
	if (!`isupdate') {
		di as smcl as txt _col(5) "matched" ///
		_col(30) as res %16.0fc `m3' as txt "  `v3'"
	}
	else {
		if (`m1'==0 & `m2'==0) {
			di
		}
		di as smcl as txt _col(5) "matched" ///
			_col(30) as res %16.0fc (`m3'+`m4'+`m5')
		di as smcl as txt _col(9) "not updated" ///
			_col(30) as res %16.0fc `m3' as txt "  `v3'"
		di as smcl as txt _col(9) "missing updated" ///
			_col(30) as res %16.0fc `m4' as txt "  `v4'"
		di as smcl as txt _col(9) "nonmissing conflict" ///
			_col(30) as res %16.0fc `m5' as txt "  `v5'"
	}
	di as smcl as txt _col(5) "{hline 41}"
end
	

program buildexpr 
	args userexpr  colon  varname numbers 

	gettoken first numbers : numbers
	local list `varname'==`first'
	
	foreach el of local numbers {
		local list `list' | `varname'==`el'
	}

	c_local `userexpr' "(`list')"
end


program checkmresults 
	args mresults numbers 

	tokenize "`mresults'"

	foreach el of local numbers {
		local `el' 0
	}

	assert `1'==0 & `2'==0 & `3'==0 & `4'==0 & `5'==0
end


program checksort, rclass
	args is should

	local i 0
	return scalar sorted = 1
	foreach v1 of local should {
		local ++i
		local v2 : word `i' of `is'
		if ("`v1'"!="`v2'") {
			return scalar sorted = 0
			continue, break
			/*NOTREACHED*/
		}
	}
end

program error_seq_not11
	args mptype origmtype
	di as smcl as err "{bf:`origmtype' _n} invalid"
	di as smcl as err "{p 4 4 2}"
	di as smcl as err ///
	"the syntax for a sequential merge is {bf: merge 1:1 _n} ...{break}" 
	di as smcl as err "the syntax for a `origmtype' match merge is"
	di as smcl as err "{bf:merge `origmtype'} {it:varlist} ..."
	di as smcl as err "{p_end}"
	exit 198
end

program error_mat_varlist
	args mtype origmtype
	if ("`mtype'"=="1:1") {
		di as smcl as err ///
		"{it:varlist} or {bf:_n} required after {bf:merge 1:1}"
		di as smcl as err "{p 4 4 2}"
		di as smcl as err "for a match merge," 
		di as smcl as err "you must specify the key variables"
		di as smcl as err "after {bf:merge 1:1} or, if you want a sequential"
		di as smcl as err "merge, specify {bf:merge 1:1 _n}"

	}
	else {
		di as smcl as err ///
		"{it:varlist} must be specified after {bf:merge `origmtype'}"
		di as smcl as err "{p 4 4 2}"
		di as smcl as err "you must specify the key variables"
		di as smcl as err "after {bf:merge `origmtype'}"
	}
	di as smcl "{p_end}"
	exit 198
end

program error_seq_varlist
	args mtype
	di as smcl as err "{it:varlist} cannot be specified after {bf:1:1 _n}"
	di as smcl as err "{p 4 4 2}"
	di as smcl as err ///
		"{bf:1:1 _n} specifies a sequential merge and in that case"
	di as smcl as err "there are no key variables;"
	di as smcl as err "if you want a match merge on key variables, omit 
	di as smcl as err "the {bf:_n} and specify {bf:1:1} {it:varlist}"
	di as smcl as err "{p_end}"
	exit 198
end



local RS	real scalar
local RC	real colvector
local SS	string scalar
local SR	string rowvector
local SC	string colvector

mata:
version 11.0

void resultlist(`SS' macname)
{
	`SR'	src
	`SC'	res
	`RS'	i

	src = tokens(st_local(macname))
	if (!cols(src)) return

	res = J(cols(src), 1, "")
	for (i=1; i<=cols(src); i++) {
		res[i] = result(src[i])
	}
	st_local(macname, invtokens(uniqrows(res)'))
}

`SS' result(`SS' result)
{
	`RS'	l

	if (result>="1" & result<="5") return(result)
	l = strlen(result)
	if (bsubstr("masters",        1, max((3,l)))==result) return("1") 
	if (bsubstr("usings" ,        1, max((2,l)))==result) return("2") 
	if (bsubstr("matches",        1, max((3,l)))==result) return("3") 
	if (bsubstr("matched",        1, max((3,l)))==result) return("3") 
	if (bsubstr("match_updates",  1, max((8,l)))==result) return("4") 
	if (bsubstr("match_conflicts",1, max((8,l)))==result) return("5") 

	errprintf("%s:  invalid {it:resulttype}\n", result)
	errprintf("{p 4 4 2}\n")
	errprintf(
		"results, specified in options {bf:assert()} and {bf:keep()},\n")
	errprintf("are the integers 1 through 5, or\n")
	errprintf("{bf:master} (equivalent to 1),\n")
	errprintf("{bf:using} (2),\n")
	errprintf("{bf:match} (3),\n")
	errprintf("{bf:match_update} (4), or\n")
	errprintf("{bf:match_conflict} (5).  The last two arise only when\n")
	errprintf("option {cmd:update} is specified.\n")
	errprintf("{p_end}\n")
	exit(198)
	/*NOTREACHED*/
}

void resulttext(`SS' macroname, `RS' i)
{
	`SS'	toret

	if (i==1)          toret = "from master"
	else if (i==2)     toret = "from using"
	else if (i==3)     toret = "matched"
	else if (i==4)     toret = "matched and updated"
	else if (i==5)     toret = "matched and conflicting"
	else               toret = "of unknown type"

	st_local(macroname, toret)
}
	
void map_mtype(`SS' macname)
{
	`SS'	input, toret

	input = st_local(macname)
	if (input=="1:1")		toret = "1:1"
	else if (input=="1:m")		toret = "1:m"
	else if (input=="m:1")		toret = "m:1"
	else if (input=="m:m")		toret = "m:m"
	else if (input=="1:n")		toret = "1:m"
	else if (input=="n:1")		toret = "m:1"
	else if (input=="n:n")		toret = "m:m"
	else if (input=="n:m")		toret = "m:m"
	else if (input=="m:n")		toret = "m:m"
	else {
		errprintf("{bf:merge %s}:  invalid merge type\n", input)
		errprintf("{p 4 4 2}\n") 
		if (input=="_n") {
			errprintf("for a sequential merge,")
			errprintf("specify {bf:1:1 _n}")
		}
		else {
			errprintf("merge types are {bf:1:1}, {bf:1:m},\n")
			errprintf("{bf:m:1}, or {bf:m:m}\n")
		}
		errprintf("{p_end}\n")
		exit(198)
	}
	st_local(macname, toret) 
}

void fullfilename(`SS' forstatamac, `SS' fullnamemac, `SS' macname)
{
	`SS'	fullname, path, filename
	`RS' 	l

	fullname = st_local(macname)
	pragma unset filename
	pragma unset path
	pathsplit(fullname, path, filename)
	if ((l=strpos(filename,"."))==0) {
		fullname = fullname + ".dta"
		st_local(forstatamac, fullname)
		st_local(fullnamemac, fullname)
	}
	else if (l==strlen(filename)) {
		st_local(forstatamac, fullname)
		st_local(fullnamemac, bsubstr(fullname, 1, l-1))
	}
	else {
		st_local(forstatamac, fullname)
		st_local(fullnamemac, fullname)
	}
}

end
