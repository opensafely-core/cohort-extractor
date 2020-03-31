*! version 3.4.1  05jun2013
program define egen, byable(onecall) sortpreserve
	version 6, missing

	local cvers = _caller()

	gettoken type 0 : 0, parse(" =(")
	gettoken name 0 : 0, parse(" =(")

	if `"`name'"'=="=" {
		local name `"`type'"'
		local type : set type
	}
	else {
		gettoken eqsign 0 : 0, parse(" =(")
		if `"`eqsign'"' != "=" {
			error 198
		}
	}

	confirm new variable `name'

	gettoken fcn 0 : 0, parse(" =(")
	gettoken args 0 : 0, parse(" ,") match(par)
	if "`c(adoarchive)'"=="1" {
		capture qui _stfilearchive find _g`fcn'.ado	
		if _rc {
			di as error "unknown egen function `fcn'()"
			exit 133
		}
	}
	else {
		capture qui findfile _g`fcn'.ado
		if (`"`r(fn)'"' == "") {
			di as error "unknown egen function `fcn'()"
			exit 133
		}
	}
	
	if `"`par'"' != "(" { 
		exit 198 
	}
	if `"`args'"' == "_all" | `"`args'"' == "*" {
		version 7.0, missing
		unab args : _all
		local args : subinstr local args "`_sortindex'"  "", all word
		version 6.0, missing
	}

	syntax [if] [in] [, *]
	if _by() { 
		local byopt "by(`_byvars')"
		local cma ","
	}
	else if `"`options'"' != "" { 
		local cma ","
	}
	tempvar dummy
	global EGEN_Varname `name'
	version 7.0, missing
	global EGEN_SVarname `_sortindex'
	version 6.0, missing
	if ("`fcn'" == "mode" | "`fcn'" == "concat") {
		local vv : display "version " string(`cvers') ", missing:"
	}
	capture noisily `vv' _g`fcn' `type' `dummy' = (`args') `if' `in' /*
		*/ `cma' `byopt' `options'
	global EGEN_SVarname
	global EGEN_Varname
	if _rc { exit _rc }
	quietly count if missing(`dummy')
	if r(N) { 
		local s = cond(r(N)>1,"s","")
		di in bl "(" r(N) " missing value`s' generated)"
	}
	rename `dummy' `name'
end
exit
/*
	syntax is:
		egen type varname = xxx(something) if exp in exp, options
		passed to xxx is
			<type> <varname> = (something) if exp in exp, options

		If xxx expects varlist, 
			gettoken type 0 : 0
			gettoken vn   0 : 0
			gettoken eqs  0 : 0    /* known to be = */
			syntax varlist ...

		If xxx expects exp
			syntax newvarname =exp ...

	Note, the utility routine should not present unnecessary messages
	and must return nonzero if there is a problem.  The new variable 
	can be left created or not; it will be automatically dropped.
	If the return code is zero, a count of missing values is automatically
	presented.
*/
