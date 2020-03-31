*! version 2.0.6  21jul2015

/* 
	parses an expression that contains parameters, where parameters can
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
		tempname parseobj
		.`parseobj' = ._parse_sexp_c.new 
		local expr {a=5} * mpg / price { b=4}*{ a = 7 }*{ c }
		_parse_sexp `parseobj' `"`expr'"'

	   returns:
		r(k)	    = 3
		r(expr)     : "{a} * mpg / price {b} * {a} * {c}"
		r(parmlist) : "a b c"
		r(initmat)  = (7 , 4 , 0)

	   If you pass an expression with an already-defined linear
	   combination in short form (such as {xb:}), _parse_sexp will
	   recognize that {xb:} has been previously defined as a linear
	   combination and return the expression with the elements of 
	   the linear combination fully listed.  Only in the case of
	   a re-used linear combination, r(k), r(parmlist), etc., do
	   not reflect elements of the already-declared linear combi-
	   nation.
	   
	   For single-equation examples, see -mlexp-.
	   For multiple-equation examples, see -gmm-.

	   You must pass an instance of class _parse_sexp.
	
*/

program define _parse_sexp , rclass
	version 14
	syntax, parseobj(name) expression(string) [ eqn(string) ///
		touse(varname) cc(string) NOINIT NOREUSE lfonly collinear ]

	local vn = _caller()
	local vv : di "version `vn':"
	
	local 0 `expression'
	local kcollin = 0
	/* get rid of possible spaces in { parmname }			*/
	local ct 1
	while `ct' > 0 {
		local 0 : subinstr local 0 "{ " "{", all count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local 0 : subinstr local 0 " }" "}", all count(local ct)
	}
	
	/* see note at bottom of file 					*/
	local lcnames_preveq `.`parseobj'.lcnamesfetch'
	local k : word count `lcnames_preveq'
	forvalues i = 1/`k' {
		local lcreuse_first `lcreuse_first' 1
	}
	local lcreuse_nparm = 0
	
	
	/* pick off parameters -- {parmname} 				*/
	tempname initmat mat1 ival 
	ExtractEqName "`eqn'" `"`0'"'
	local pre `"`s(pre)'"'
	local rest `"`s(rest)'"'
	local eqn `s(eqn)'
	
	while "`rest'" != "" {
		local pre : subinstr local pre "{" ""
		local pre : list clean pre
		local pre : subinstr local pre " " "", all
		local expr `"`expr'`pre'"'
		local exprlf `"`exprlf'`pre'"'
		local lcreuse 0

		ExtractEqVars `vn' `"`pre'"' `"`rest'"' "`noinit'"

		local rest `"`r(rest)'"'
		local expi `"`r(expr)'"'
		local eqname `r(eqname)'
		local eqname0 `eqname'
		local vars `"`r(vars)'"'
		local kvar = `r(kvar)'
		local const = `r(const)'
		if `const' {
			if `vn' < 14 {
				di as err "{p}parameter `eqname':_cons is " ///
				 "not allowed{p_end}"
				exit 198
			}
		}
		/* expression either a LC {eqname:varlist} or {eqname:}	*/
		/* or a parameter {paramname}				*/
		local lcref = `r(lcref)'
		scalar `ival' = r(init)
		local isfirst = 0
		local lcisin = `.`parseobj'.islcin `eqname''
		local parse = (`kvar'>0) + `const'
		if `lcisin' {
			/* LC {eqname:varlist} already defined		*/
			if `lcref' {
				/* referenced {eqname:}; get varlist	*/
				local lcreuse = 1
				local vars `.`parseobj'.lcvarfetch `eqname''
				local kvar : list sizeof vars
				local const = `.`parseobj'.lcconst `eqname''
				local parse = (`kvar'>0)+`const'
			}
			else if "`noreuse'" != "" {
				di as err "{p}linear form `eqname' is " ///
				 "declared more than once{p_end}"
				exit 198
			}
			else {
				/* check for param ref {eqname:_cons} 	*/
				/* or {eqname:var} in {eqname:varlist}	*/
				ValidateParameterSpec, parseobj(`parseobj') ///
					eqname(`eqname') kvar(`kvar')       ///
					var(`vars') const(`const') vn(`vn') ///
					eqn(`eqn') `lfonly'
				local var `r(var)'
				local vars `var'
				/* reference existing parameter		*/
				local lcreuse = 1
				local parse = 0
			}
			/* check if we are reusing a parameter	*/
			/* from earlier calls to _parse_sexp	*/
			local j : list posof "`eqname'" in lcnames_preveq
			if `j' > 0 {
				local isfirst : word `j' of `lcreuse_first'
			}
		}		
		else if `lcref' {
			/* colon in expression references LC		*/
			di as err "{p}equation `eqn' is invalid; you must " ///
			 "define linear form `eqname' before referencing "  ///
			 "to it{p_end}"
			exit 198
		}
		else if !`parse' & `vn'>=14 {
			/* parameter {eqname} specified, {eqname:_cons}	*/
			/* implied					*/
			local const = 1
			local parse = 1
		}
		if `parse' {
			local check = !`lcisin'
			ParseExpression, vn(`vn') vars(`vars')          ///
				const(`const') touse(`touse')           ///
				lcreuse(`lcreuse') parseobj(`parseobj') ///
				initmat(`initmat') eqname(`eqname')     ///
				parmlist(`parmlist') ival(`ival') cc(`cc') ///
				`collinear' checkcollin(`check')

			local expr `"`expr'`r(expr)'"'
			local exprlf `"`exprlf'`r(exprlf)'"'
			local parmlist `"`r(parmlist)'"'
			local varcnt = `r(varcnt)'
			local kcollin = `kcollin' + `r(kcollin)'
			local eqlist `"`eqlist' `eqname'"'

			if `isfirst' {
				/* LC from earlier call to _parse_sexp	*/
				/*  first time in this equation 	*/
				UpdateLCR lcreuse_first : `j' "`lcreuse_first'"
				local lcreuse_nparm = `lcreuse_nparm'+`varcnt'
			}
		}	
		else {
			if `vn' < 14 {
				local varpar `eqname'
				local mvarpar `varpar'
				local eqlist `"`eqlist' `eqname'"'
				if !`lcreuse' {
					.`parseobj'.lcadd "`eqname'" ""
					if (missing(`ival')) scalar `ival' = 0
				}
				local vsymbol 
			}
			else {
				local varpar `eqname':`var'
				local vsymbol `var'
				_parse_sexp_matrix_form `varpar'
				local mvarpar `s(parameters)'
			}
			if !missing(`ival') {
				/* maintain initial values matrix 	*/
				matrix `mat1' = `ival'
				UpdateInitVals `initmat' "`mvarpar'" `mat1' ///
					`"`cc'"' 0 `vn'
			}
			/* maintain parmlist                            */
			local void : subinstr local parmlist "`mvarpar'" ///
				"`mvarpar'", count(local ct) word
			if !`ct' { 
				local parmlist `parmlist' `varpar' 
				if !`lcreuse' {
					.`parseobj'.lcparmadd "`eqname'" ///
						"`vsymbol'" "`varpar'"
                                }
                        }

			/* put {parmname} into expr 			*/
			local expr `"`expr'{`mvarpar'}"'
			local exprlf "`exprlf'{`eqname0':}"
		}
		gettoken pre rest : rest , parse("{")
	}
	if "`expr'"=="" & "`pre'"!="" & "`noinit'"!="" {
		if strpos("`pre'","=") {
			di as err "invalid expression {bf:`pre'}"
			exit 198
		}
	}
	local expr `expr'`pre'
	local exprlf `exprlf'`pre'
	local eqlist : list uniq eqlist
					/* return results */
	// if we call _parse_sexp after the initial parse, the subst.
	// expressions will have initial values removed, so `initmat'
	// may not have been created/updated.
	// Also, `initmat' will not get created if we're passed
	// an expression without parameters.
	capture confirm matrix `initmat'
	if !_rc {
		return matrix initmat 	`initmat'
	}
	else {
		/* clear return code					*/
		capture
	}
	local parmlist : list retokenize parmlist
	
	return scalar k	= `:word count `parmlist'' + `lcreuse_nparm'
	return local parmlist `"`parmlist'"'
	return local expr `"`expr'"'
	return local exprlf `"`exprlf'"'
	return local eqn `eqn'
	return local eqlist `eqlist'
	return local kcollin = `kcollin'
end

program ParseExpression, rclass
	version 14
	syntax, vn(real) lcreuse(integer) parseobj(string) initmat(name) ///
		eqname(string) const(integer) checkcollin(integer)       ///
		[ vars(string) cc(string) touse(name) parmlist(string)   ///
		ival(name) collinear ]

	tempname mat1

	local kcollin = 0
	if "`touse'" != "" {
		local iff if `touse'
	}
	if "`vars'" != "" {
		if `vn' < 14 {
			tsunab vars : `vars'
		}
		else if `checkcollin' {
			if !`const' {
				local noconst noconstant
			}
			_rmcoll `vars' `iff', `noconst' expand `collinear'
			local vars `r(varlist)'
			local kcollin = `r(k_omitted)'
		}
		else {
			fvexpand `vars' `iff'
			local vars `r(varlist)'
		}
	}
	if `vn'>=14 & `const' {
		local vars `"`vars' _cons"'
		local vars : list clean vars
	}

	if !`lcreuse' {
		.`parseobj'.lcadd "`eqname'" `"`vars'"'
	}
	local vlist `vars'
	local varcnt = 0
	
	while "`vlist'" != "" {
		gettoken vari vlist : vlist, bind
	
		local omit = 0
		if `vn' < 14 {
			tsrevar `vari', list
			confirm numeric variable `r(varlist)'
			local varn : subinstr local vari "." "_", all
			local varpar = usubstr("`eqname'_`varn'", 1, 25)
			local mvarpar `varpar'
		}
		else {
			local varpar `eqname':`vari'
			if "`vari'" != "_cons" {			
				_ms_parse_parts `vari'
				local omit = r(omit)
			}
			_parse_sexp_matrix_form `varpar'
			local mvarpar `s(parameters)'
		}
		mat `mat1' = 0
		if (!missing(`ival')) mat `mat1'[1,1] = `ival'

		if !`lcreuse' {
			UpdateInitVals `initmat' "`mvarpar'" `mat1' `"`cc'"' ///
				`omit' `vn'
			local parmlist `parmlist' `mvarpar'
			.`parseobj'.lcparmadd "`eqname'" "`vari'" "`mvarpar'"
		}
		if `++varcnt' > 1 {
			local expr "`expr'+"
		}
		if "`vari'" != "_cons" {
			local expr `"`expr'{`mvarpar'}*`vari'"'
		}
		else {
			local expr `"`expr'{`mvarpar'}"'
		}
	}
	if `varcnt' > 1 {
		local expr "(`expr')"
	}
	local exprlf "`exprlf'{`eqname':}"

	local c : word 2 of `cc'
	cap confirm matrix `c'
	if !c(rc) {
		local C : word 1 of `cc'
		cap confirm matrix `C'
		if c(rc) {
			/* never came across a constraint		*/
			mat drop `c'
		}
	}
	return local eqn `eqn'
	return local expr `"`expr'"'
	return local exprlf `"`exprlf'"'
	return local parmlist `"`parmlist'"'
	return local varcnt = `varcnt'
	return local kcollin = `kcollin'
end

program ExtractEqName, sclass
	args eqn expr

	gettoken pre rest : expr, parse("{")
	if "`pre'" == "{" {
		/* no equation name					*/
		local pre
		local rest `"`expr'"'
	}
	else if "`eqn'" != "" { // input equation number
		/* get equation name, if it exists			*/
		gettoken seqn after : pre, parse(":")
		if "`after'" != "" {
			gettoken colon after : after, parse(":")
			if "`colon'"==":" {
				local eqn : list retokenize seqn
				local pre : list clean after
				/* strip eq name out of space before	*/
				/*  operator				*/
				local pre = subinstr(`"`pre'"'," ","",1)
			}
		}
	}
	sreturn local expr `"`expr'"'
	sreturn local pre `"`pre'"'
	sreturn local rest `"`rest'"'
	sreturn local eqn `eqn'
end

/*
	Extract eqname and varlist from expression.
*/
program ExtractEqVars, rclass
	args vn pre rest noinit

	/* find end of {parmname [=init]} 				*/
	local rest0 `rest'
	gettoken expr rest : rest , parse("}")
	if bsubstr("`rest'",1,1) != "}" {
		local rest0 : subinstr local rest0 "{" "{c -(}"
		di as error "{p}expression {bf:`pre'`rest0'} is invalid; " ///
		 "missing closing brace{p_end}"
		exit 198
	}

	local expr : subinstr local expr "{" ""
	/* if an open brace exists a closing brace is missing		*/
	local tmp : subinstr local expr "{" "{", all count(local k)
	if `k' {
		local rest0 : subinstr local rest0 "{" "{c -(}"
		di as err `"{p}expression {bf:`pre'`rest0'} is invalid; "' ///
		 "missing closing brace{p_end}"
		exit 198
	}
	local rest : subinstr local rest "}" ""

	/* clean up excessive spaces					*/
	local expr : list retokenize expr
	local expr0 `expr'
	/* expr a linear combination? 				*/
	gettoken expr init : expr, parse("=")
	gettoken eqname vars : expr , parse(":")
	local kvar = 0
	local const = 0
	local lcref = 0
	local k : list sizeof eqname
	if `k' != 1 {
		di as err "{p}expression {bf:`expr0'} is invalid{p_end}"
		exit 198
	}
	if "`eqname'" != "" {
		cap noi confirm name `eqname'
		if (c(rc)) exit 198
	}
	if "`vars'" != "" {
		gettoken colon vars : vars , parse(":")
		/* allow specifying {eqname: varlist _cons}		*/
		RemoveConst `"`vars'"'
		local vars `"`s(vars)'"'
		local const = `s(const)'
		/* vars could be empty now if specified {eqname:}	*/
		if "`vars'" != "" {
			if `vn' < 14 {
				tsunab vars : `vars'
				local kvar : list sizeof vars
			}
			else {
				fvunab vars : `vars'
				local vars0 `vars'
				local kvar = 0
				while "`vars0'" != "" {
					gettoken expr vars0 : vars0, bind
					local `++kvar'
				}
			}
		}
		/* colon with no varlist: reference to a LC		*/
		local lcref = !(`kvar'+`const')
	}
	if "`init'" != "" {
		if `kvar'>1 | "`noinit'"!="" {
			di as err "{p}expression {bf:`expr0'} is " ///
			 "invalid{p_end}"
			exit 198
		}
		tempname ival
		cap scalar `ival' `init'
		if c(rc) {
			di as err "failed to evaluate {bf:`init'}"
			exit 198
		}
	}
	return local rest `"`rest'"'
	return local eqname `"`eqname'"'
	return local vars `"`vars'"'
	return local kvar = `kvar'
	return local expr `"`expr0'"'
	return local const = `const'
	return local lcref = `lcref'
	if "`ival'" != "" {
		return scalar init = `ival'
	}
end

program RemoveConst, sclass
	args vars

	local vcons _cons
	local vars : list clean vars
	local vars0 `"`vars'"'
	local vcons : list vars0 & vcons
	local vars : list vars0 - vcons
	local vars : list clean vars

	sreturn local const = ("`vcons'"=="_cons")
	sreturn local vars `"`vars'"'
end

program define ValidateParameterSpec, rclass
	syntax, parseobj(name) eqname(string) kvar(integer) const(integer) ///
		vn(real) [ eqn(string) var(string) lfonly ]

	/* assumption: {eqname:} or {eqname} is already defined		*/
	/* validate {eqname:var} or {eqname:_cons} exists		*/
	if "`eqn'" != "" {
		local eqn " `eqn'"
	}
	local kvarc = `kvar' + `const'
	if `kvarc'>1 {
		di as err "{p}equation`eqn' is invalid; " _c
		if `vn' >= 14 {
			di as err "linear form `eqname' is declared more " ///
			 "than once{p_end}"
		}
		else {
			di as err "parameter {`eqname:var'} not found{p_end}"
		}
		exit 198
	}
	if `vn' >= 14 {
		if !`kvarc' {
			local conly = `.`parseobj'.islcconsonly `eqname''
			/* specified {eq}, but eq is not constant only 	*/
			if !`conly' {
				di as err "equation`eqn' is invalid"
				di as txt "{phang}The {`eqname'} notation "  ///
				 "is only valid for referencing parameters " ///
				 "(i.e. a linear form with constant only). " ///
				 "Use {`eqname':} to reference an existing " ///
				 "linear form, or {`eqname':varname} to "    ///
				 "reference an individual parameter of an "  ///
				 "existing linear form.{p_end}"
				 exit 198
			}
			local const = 1
		}
		else if `kvar' & "`lfonly'"!="" {
			di as err "{p}equation`eqn' is invalid; linear " ///
			 "form `eqname' is declared more than once{p_end}"
			exit 198
		}
	}
	if `const' {
		local var _cons
	}
	else if "`var'" != "" {
		_parse_sexp_matrix_form `"`var'"'
		local var `"`s(parameters)'"'
	}
	else {
		exit
	}
	/* parameter {eq:var} already defined?				*/
	local lcvarisin = `.`parseobj'.isvarinlc "`eqname'" "`var'"'

	if !`lcvarisin' {
		di as err "{p}equation`eqn' is invalid; linear form  "       ///
		 "`eqname' is already defined and parameter `eqname':`var' " ///
		 "is not in it{p_end}"
		exit 198
	}
	return local var `var'
end

/*
	Set's the `pos' element of `list' to 0 and returns list in
	caller's local macro named is usr_mac
*/
program UpdateLCR

	args usr_mac colon pos list
	
	local len : list sizeof list
	
	forvalues i = 1/`=`pos'-1' {
		local j : word `i' of `list'
		local newlist `newlist' `j'
	}
	local newlist `newlist' 0 
	forvalues i = `=`pos'+1'/`len' {
		local j : word `i' of `list'
		local newlist `newlist' `j'
	}
	
	c_local `usr_mac' "`newlist'"
end

program UpdateInitVals
	version 14
	args initmat parm ivalmat Cc omit vn

	tempname X
	local C : word 1 of `Cc'
	local c : word 2 of `Cc'
	local col "."
	cap local col = colnumb(`initmat', "`parm'")
	if _rc | missing(`col') {
		if `:word count `parm'' > 1 {
			di as error "`parm' is an invalid name"
			exit 7
		}
		if `vn' < 14 {
			confirm names `parm'
		}
		/* If no initial value, set to zero */
		if `ivalmat'[1,1] >= . {
			mat `ivalmat'[1,1] = 0
		}
		mat colnames `ivalmat' = `parm'
		mat `initmat' = (nullmat(`initmat'), `ivalmat')
		if "`C'" == "" {
			exit
		}
		local j = 0
		cap confirm matrix `C'
		if (!c(rc)) {
			cap local col = colnumb(`C',"`parm'")
			if (missing(`col')) local j = rowsof(`C')
		}
		else local j = 1

		if (`j') {
			mat `X' = J(`j',1,0)
			mat colnames `X' = `parm'
			mat `C' = (nullmat(`C'), `X')
		}
		if `omit' {
			local k = colsof(`C')
			local r = 1
			if `j' == 1 {
				mat `X' = `C'*`C''
				if `X'[1,1] == 0 {
					mat `C'[1,`k'] = 1
					local r = 0
				}
			}
			if `r' {
				mat `X' = J(1,`k',0)
				mat `X'[1,`k'] = 1
				mat `C' = (`C' \ `X')
			}
			mat `c' = (nullmat(`c') \ 0)
		}
	}
	else if `ivalmat'[1,1] < . {
		mat `initmat'[1, `col'] = `ivalmat'[1,1]
	}
end

exit

Note 2012-09-27

Say user types

	. gmm (mpg - {xb:gear turn one}) (head - {xb:}) ...
	
Other than the parameters that already appeared in the first equation, the
second equation doesn't have any additional parameters.  

The macros lcreuse_first and lcreuse_nparm are used to keep track of this 
situation when parsing the second equation and correctly returning the
number of parameters to be three.  Previously, zero had been returned,
which is nonsense.  We need to use the lcreuse_first flag so that we can
mark (1) that we are reusing an existing linear combination and (2) that's
the first time this linear combination appears in the equation (to avoid
double counting).  Moreover, we need an entire list of flags, because 
multiple l.c.'s may have been declared in prior equations.
