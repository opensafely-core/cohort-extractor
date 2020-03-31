*! version 1.1.5  10dec2018

findfile _bayesmh_parse_sub_expr.mata
quietly include `"`r(fn)'"'

program _mcmc_parmlist, rclass

	tempname initmat mat1 ival typemat
	local parmlist
	local omitlist
	local varnames
	
	local vv = _caller()

	// get rid of possible spaces { parmname }
	local ct 1
	while `ct' > 0 {
		local 0 : subinstr local 0 "{ " "{", all count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local 0 : subinstr local 0 " }" "}", all count(local ct)
	}
	
	// replace xbdefines and redefines
	_mcmc_definereplace `"`0'"'
	local expr `"`s(expr)'"'

	gettoken next : expr, match(paren)
	if `"`expr'"' != `"(`next')"' {
		local next `"`expr'"'
		local lparen
	}
	else {
		local lparen (
	}

	local eqlatent
	local feparams
	local matparams

	if `vv' >= 15.0 {
		// don't use the new syntax for varlist or matrices
		capture confirm numeric variable `next'
		if _rc == 0 {
			local vv 14.0
		}
		capture confirm matrix `next'
		if _rc == 0 {
			local vv 14.0
		}
		tempname tmat
		capture matrix `tmat' = `next'
		if _rc == 0 {
			local vv 14.0
		}
	}

	gettoken eqname next : next , parse(":") bind bindcurly
	local nolabelexpr `eqname'
	if `"`next'"' == "" {
		tempname lname
		if `vv' >= 16.0 {
			local exprcount $MCMC_exprcount
			if `"`exprcount'"' == "" {
				local exprcount 0
			}
			global MCMC_exprcount = `exprcount' + 1
			local lname __expr`exprcount'
		}
		local next `lname':`eqname'
		local eqname
	}
	else {
		gettoken pre next : next , parse(":") bind bindcurly
		local nolabelexpr `next'
		local next `eqname':`next'
	}

	if `vv' >= 16.0 {
		mata: _bayesmh_parse_sub_expr(0, 0, "`next'", "", "",    ///
			"eqexpr", "eqnolatent", "eqlatent", "eqlatname", ///
			"pathlist", "varnames", "feparams", "initlist",  ///
			"matparams", "totalre", "retcode")
		if retcode != 0 exit retcode
		if `"`eqlatent'`feparams'"' == "" {
			local vv 14.0
		}
	}
	else if `vv' >= 15.0 {
		mata: _bayesmh_parse_sub_expr(0, 0, "`next'", "", "",    ///
			"eqexpr", "eqnolatent", "eqlatent", "eqlatname", ///
			"pathlist", "varnames", "feparams", "",          ///
			"matparams", "totalre", "retcode")
		if retcode != 0 exit retcode
		if `"`eqlatent'`feparams'"' == "" {
			local vv 14.0
		}
	}
	else {
		capture mata: _bayesmh_parse_sub_expr(0, 0, "`next'", "", "", ///
			"eqexpr", "eqnolatent", "eqlatent", "eqlatname",      ///
			"pathlist", "varnames", "feparams", "",               ///
			"matparams", "totalre", "retcode")
		local vv 15.0
		if _rc != 0 | `"`eqlatent'`feparams'"' == "" {
			local vv 14.0
		}
		if `"`eqlatent'`eqname'"' == "" {
			local vv 14.0
		}
		local eqlatent `eqlatent'
		local feparams `feparams'
		local matparams `matparams'
	}

	if `vv' >= 15.0 {
		local expr `"(`eqexpr')"'
		local parmlist
		// update $MCMC_latent with the list of latent variables
		foreach next of local feparams {
			local parmlist = `"`parmlist' `next'"'
			tokenize `next', parse(":")
			if `"`2'"' == ":" & `"`3'"' != ""  {
				_ms_parse_parts `"`3'"'
				if `"`r(omit)'"' == "0" {
					local omitlist `omitlist' 0
				}
				else {
					local omitlist `omitlist' 1
				}
			}
			else {
				local omitlist `omitlist' 0
			}
		}
		foreach next of local matparams {
			local parmlist = `"`parmlist' `next',m"'
			local omitlist `omitlist' 0
		}
		foreach next of local eqlatent {
			tokenize `next', parse("[]")
			local lname MCMC_latent_`1'
			global `lname' `next'
			global MCMC_latent `"$MCMC_latent`next' "'
			local parmlist = `"`parmlist' `next',l"'
			local omitlist `omitlist' 0
		}
	}
	else {

	// pick off parameters -- {parmname} 
	local 0 `"`nolabelexpr'"'
	local expr
//	local varnames  // (rbg) include varnames from _bayesmh_parse_sub_expr

	gettoken pre rest : 0 , parse("{")
	while "`rest'" != "" {
	
		local pre : subinstr local pre "{" ""
		local expr `expr'`pre'

		// find end of {parmname [=init]} 
		gettoken parminit rest : rest , parse("}")
		if bsubstr("`rest'",1,1) != "}" {
			di as err "invalid expression equation"
			di as err "`0'"
			exit 198
		}

		local parminit : subinstr local parminit "{" ""
		local rest     : subinstr local rest	 "}" ""

		// Is parminit a linear combination? 
		local parminit : subinstr local parminit " :" ":", all
		local parminit : subinstr local parminit ": " ":", all

		gettoken eqname vars : parminit , parse(":")
		local vars : subinstr local vars ":" "", all
		capture fvunab vars  : `vars'

		if _rc == 0 {
			_mcmc_fv_decode `"`vars'"'
			local vars `s(outstr)'
			local omitlist `omitlist' `s(omitlist)'

			local varcnt 1
			foreach var in `vars' {
			local varpar "`eqname'_`var'"

			local parmlist `parmlist' `varpar'
			
			if `varcnt' == 1 {
				local expr "`expr'({`varpar'}*`var'"
			}
			else {
				local expr "`expr'{`varpar'}*`var'"
			}
			if "`ferest()'" != "" {
				local expr "`expr'+"
			}
			else {
				local expr "`expr')"
			}
			local `++varcnt'
			}

		}
		else {	 // single parameter

			if `"`vars'"' != "" {
				local nparms: word count `vars'
				if `nparms' != 1 {
					di as err `"invalid expression `0'"'
					exit _rc
				}
			}

			// evaluate or create initial value 
			gettoken parm init : parminit, parse("=")
			local parm `parm' // sic, trimblanks

			// trim options
			_parse comma init rhs : init

			if "`init'" != "" {
			local initlist	 ///
				`"`initlist' "`parm' `=bsubstr("`init'",2,.)'""'
			}

			// for labeled params
			// convert the first : to _
			gettoken parm vars : parm , parse(":")
			if `"`vars'"' != "" {
				local vars = bsubstr(`"`vars'"',2,.)
				local parm `"`parm'_`vars'"'
			}

			// move options to parm
			local parm `"`parm'`rhs'"'
			// maintain parmlist
			local parmlist `parmlist' `parm' 
			local omitlist `omitlist' 0
			// put {parm} into expr 
			local expr "`expr'{`parm'}"
		}

		gettoken pre rest : rest , parse("{")
	
	}

		local expr `expr'`pre'

		if "`lparen'" == "(" {
			local expr `"(`expr')"'
		}
		else {
			local expr `"`expr'"'
		}
	}

	local parmlist0 `parmlist'
	local parmlist
	local nparms: word count `parmlist0'

	if `nparms' < 1 {
		capture qui expr_query (`expr')
		if _rc == 0 local varnames `varnames' `r(varnames)'
		return scalar k = 0
		return local  omitlist `omitlist'
		return local  varnames `varnames'
		return local  expr     `expr'
		exit 0
	}

	matrix `typemat' = J(1,`nparms',0)
	local queryexpr `expr'
	local lablist

	local i 0
	local n 0
	foreach parm of local parmlist0 {

		local queryexpr : subinstr local queryexpr "{`parm'}" "1", all
		local `++n'

		local islatent 0
		_parse comma lhs rhs : parm
		if `"`rhs'"' != "" {
			local rhs : subinstr local rhs "," ""
			local l = length(`"`rhs'"')
			if bsubstr("matrix",1,max(1,`l')) == `"`rhs'"' {
				matrix `typemat'[1,`n'] = 1
			}
			else if bsubstr("latent",1,max(1,`l')) == `"`rhs'"' {
				matrix `typemat'[1,`n'] = 2
				local islatent 1
			}
			else {
				di as err "invalid expression option"
				di as err "`rhs'"
				exit 198
			}
			local expr : subinstr local expr "`parm'" "`lhs'", all
			local parm `"`lhs'"'
		}

	if `vv' >= 15.0 {
		gettoken lab rhs : parm , parse(":")
		if `"`rhs'"' != "" & !`islatent' {
			local parm : subinstr local rhs ":" ""
			local lablist `lablist' `lab'
		}
		else {
			local parm `lab'`rhs'
			local lablist `lablist' .
		}
	}
	else {
		gettoken lab rhs : parm , parse("_")
		if `"`rhs'"' != "" & !`islatent' {
			local parm : subinstr local rhs "_" ""
			local lablist `lablist' `lab'
		}
		else {
			local parm `lab'`rhs'
			local lablist `lablist' .
		}
	}
		if ustrlen(`"`parm'"') > 32 {
			di as err `"invalid name {bf:`parm'}"'
			di as err "{p 4 4 2}Parameter names may not exceed"
			di as err "32 characters.{p_end}"
			exit 7
		}

		local parmlist `parmlist' `parm'
	}

	capture qui expr_query (`queryexpr')
	if _rc == 0 local varnames `varnames' `r(varnames)'
	local varnames : list uniq varnames

	// return results 
	return scalar k	  = `:word count `parmlist''
	return local  parmlist `parmlist'
	return local  omitlist `omitlist'
	return local  varnames `varnames'
	return local  lablist  `lablist'
	return local  expr     `expr'
	return matrix typemat  `typemat'

	if `"`parmlist'"' != "" {
		matrix `initmat' = J(1, `:list sizeof parmlist', .)
		matrix colnames `initmat' = `parmlist'
		if `vv' >= 16.0 {
			matrix coleq `initmat' = `lablist'
		}
		foreach init of local initlist {
			gettoken parm ival : init
			if `vv' < 16.0 {
				gettoken lab parm  : parm , parse("_")
				if `"`parm'"' != "" {
					local parm : subinstr local parm "_" ""
				}
				else {
					local parm `lab'
				}
			}
			matrix `initmat'[1, colnumb(`initmat', "`parm'")] = `ival'
		}
		return matrix initmat  `initmat'
	}

end
exit

Parses an expression that contains parameters, where parameters can
be {parmname} or {parmname=initializer}.  Spaces before or after
parmname, "=", or initializer are tolerated and removed from the
returned expression.

Returns:
	
r(expr)	 	the expression with initializers removed and all
	 	parameters cleaned up to be {parmname}.

r(parmlist)  	a list of the parameters with each parameter listed only once.
r(omitlist)  	0/1 indicators, one for each element of r(parmlist), set to 1 
		for parameters corresponding to base levels of factor variables. 
	 
r(lablist)   	a list of the parameter labels. Parameters with 
	 	different labels are considered different. 
		Use missing . when no label is available. 
	
r(varnames)  	a list of variables.
	
r(initmat)   	a matrix of initializers that may NOT be aligned
		with parmlist (access be name) parmlist and 
		which contains 0 for parameter that have not 
		been assigned initializers. 

r(typemat)   	a matrix of parameter types that may NOT be aligned
		with parmlist (access be name); 
		0 - scalars, 1 - matrices, 2 - latent 

r(k)	 	number of parameters

Example:

parmlist {a=5}*mpg/price+{cc_b=4,latent}*{a = 7}*{c,matrix}+{bb_b}

Returns:

r(k)	    = 4
r(expr)	    : "{a} * mpg / price + {cc_b} * {a} * {c} + {bb_b}"
r(parmlist) : "a b c b"
r(lablist)  : ". cc . bb"
r(varnames) : "price mpg"
r(inttmat)  = 7 , 4 , 0 , 0
r(typemat)  = 0 , 2 , 1 , 0
