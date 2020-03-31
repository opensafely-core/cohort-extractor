*! version 1.2.6  13feb2015
program define _parmlist , rclass

	version 8

	/* parses an expression that contains parameters, where parameters can
	   be {parmname} or {parmname=initializer}.  Spaces before or after
	   parmname, "=", or initializer are tolerated and removed from the
	   returned expression.

	   Returns:
	   	r(expr)      the expression with initializers removed and all
		             parameters cleaned up to be {parmname}.

		r(parmlist)  a list of the parameters with each parameter
			     listed only once.
			     
		r(initmat)   a matrix of initializers that may NOT be aligned
			     with parmlist (access be name) parmlist and 
			     which contains 0 for parameter that have not 
			     been assigned initializers. 

		r(k)	     number of parameters

	   example:

		_parmlist {a=5} * mpg / price { b=4}*{ a = 7 }*{ c }

	   returns:
		r(k)	    = 3
		r(expr)     : "{a} * mpg / price {b} * {a} * {c}"
		r(parmlist) : "a b c"
		r(inttmat)  = 7 , 4 , 0

	*/

					/* get rid of possible spaces 
					   in { parmname }	*/
	local ct 1
	while `ct' > 0 {
		local 0 : subinstr local 0 "{ " "{", all count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local 0 : subinstr local 0 " }" "}", all count(local ct)
	}
					/* Pick off parameters -- {parmname} */
	local parmlist
	tempname initmat mat1 ival
	gettoken pre rest : 0 , parse("{")
	while "`rest'" != "" {
		local pre : subinstr local pre "{" ""
		local expr `expr' `pre'

					/* find end of {parmname [=init]} */
		gettoken parminit rest : rest , parse("}")
		if bsubstr("`rest'",1,1) != "}" {
			di as error "invalid expression equation"
			di as error "`0'"
			exit 198
		}

		local parminit : subinstr local parminit "{" ""
		local rest : subinstr local rest "}" ""

				/* Is parminit a linear combination? */
		local parminit : subinstr local parminit " :" ":", all
		local parminit : subinstr local parminit ": " ":", all
		gettoken eqname vars : parminit , parse(":")
		if "`vars'" != "" {	
			local vars : subinstr local vars ":" "", all
			tsunab vars  : `vars'
			local varcnt 1
			foreach var in `vars' {
				confirm numeric variable `var'
				local varpar "`eqname'_`var'"

				local parmlist `parmlist' `varpar'
				if `varcnt' == 1 {
					local expr "`expr' ({`varpar'} *`var'"
				}
				else {
					local expr "`expr' {`varpar'} *`var'"
				}
				if "`ferest()'" != "" {
					local expr "`expr' +"
				}
				else {
					local expr "`expr')"
				}
				local `++varcnt'
			}	
		}	
		else { 		/* Just a single parameter */
						/* evaluate or create initial
						   value */
			gettoken parm init : parminit, parse("=")
			local parm `parm'	/* sic, trimblanks */

			if "`init'" != "" {
				local initlist 				///
				`"`initlist' "`parm' `=usubstr("`init'",2,.)'""'
			}

						/* maintain parmlist */
			local parmlist `parmlist' `parm' 

						/* put {parmname} into expr */
			local expr "`expr' {`parm'}"
		}

		gettoken pre rest : rest , parse("{")
	}
	
	local expr `expr' `pre'

	local parmlist0 : list uniq parmlist
	local parmlist

	local i 0
	foreach parm of local parmlist0 {
		if ustrlen("`parm'") > 32 {
			local parmfix = usubstr("`parm'", 1, 25) + 	///
					string(`++i', "%05.0f")
	      		local expr : subinstr local expr		///
				     "{`parm'}" "{`parmfix'}", all
			local parmlist `parmlist' `parmfix'
		}
		else	local parmlist `parmlist' `parm'
	}

	matrix `initmat' = J(1, `:list sizeof parmlist', 0)
	matrix colnames `initmat' = `parmlist'
	foreach init of local initlist {
		gettoken parm ival : init
		matrix `initmat'[1, colnumb(`initmat', "`parm'")] = `ival'
	}


					/* Return results */
	return matrix initmat 	`initmat'
	return scalar k		= `:word count `parmlist''
	return local  parmlist	`parmlist'
	return local  expr	`expr'

end

