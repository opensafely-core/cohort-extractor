*! version 1.0.1  07feb2011
/*
        Checks if expressions specified in <explist> are valid.  Issues an
        error only after all expressions in the list are checked.

	Assumptions:
		([<newvarname>:]<exp>)		numeric expression
		<exp>				numeric variable
		allows factor variables

	Returns in r():
		(below <stub> is <newvarname> if specified and <stub>, o.w.)
		xvars			names of variables (unabbrev., unique)
		k_exp			# of expressions
		expnames		names (<newvarname> or <stub>_#) for 
					each expression
		<stub>_1_exp		expr. corresponding to <stub>_1
		<stub>_2_exp		expr. corresponding to <stub>_2
		...
		<stub>_<k_exp>_exp	expr. corresponding to <stub>_<k_exp>
		xlist			original <explist> with expr. replaced
					    by respective <stub>_# and variables
					    unabbreviated and expanded
		
*/
program u_mi_impute_parse_exp, rclass
	version 11.0

	args stub explist errname

	if (`"`explist'"'=="") {
		ret clear
		ret scalar k_exp = 0
		exit
	}
	if ("`stub'"=="") {
		local stub __expr
	}

	ret clear
	local k_exp 1
	local k_stub 1
	gettoken term explist : explist, parse(" ") bind
	local haserr 0
	tempname val
	while (`"`term'"'!="") {
		local rc 0
		local par = substr(`"`term'"',1,1)
		if ("`par'"!="(") {
			local 0 `term'
			cap noi syntax varlist(default=none numeric fv)
			local rc = _rc
			if (!`rc') {
				local xlist `xlist' `varlist'
				unopvarlist `term'
				local xvars `xvars' `r(varlist)'
			}
		}
		else {
			gettoken nopar : term, parse("()") match(p) quotes
			gettoken name expr : nopar, parse(":") quotes
			mata: st_local("expr",strtrim(st_local("expr")))
			if (`"`expr'"'=="") {
				local expr `"`name'"'
				local name `stub'_`k_stub'
				local ++k_stub
			}
			else if ("`name'"!=":") {
				gettoken colon expr : expr, parse(":")
				cap noi confirm new variable `name'
				local rc = _rc
			}
			else {
				local name `stub'_`k_stub'
				local ++k_stub
			}
			local name = trim(`"`name'"')
			// to preserve quotes
			mata: st_local("expr",strtrim(st_local("expr")))
			local expr `"(`expr')"'
			if (!`rc') {
				cap noi scalar `val' = `expr'
				local rc = _rc
			}
			if (!`rc') {
				mata: ///
		st_local("notnumber",strofreal(!cols(st_numscalar("`val'"))))
				if (`notnumber') {
					cap noi confirm number `=`val''
					local rc = _rc
				}
				if (!`rc') {
					local expnames `expnames' `name'
					ret local `name'_exp `expr'
					local xlist `xlist' `name'
				}
				local ++k_exp
			}
		}
		if (`rc') {
			errexp1 `rc' `"`term'"'
			local ++haserr
		}
		gettoken term explist : explist, parse(" ") bind
	}
	local --k_exp
	local xvars : list uniq xvars

	ret scalar k_exp = `k_exp'
	ret local xvars 	"`xvars'"
	ret local expnames 	"`expnames'"
	ret local xlist		"`xlist'"
	if (`haserr') {
		if ("`errname'"!="noerr") {
			errexp2 `haserr' "`errname'"
		}
		exit 198
	}
end

program errexp1
	args rc term
	di as err "{p 4 4 2}incorrectly specified " ///
		  `"term {bf:`term'}{p_end}"'
end

program errexp2
	args rc name

	if (!`rc') exit
	if ("`name'"!="") {
		local name "{bf:`name'}:  "
	}

	di as err `"{p 0 0 2}`name'"' ///
		  "invalid expressions found{p_end}"
	di as err "{p 4 4 2}see error messages specific to the "	///
		  "invalid expressions and remember to enclose "	///
		  "expressions in {bf:()}{p_end}"
end
