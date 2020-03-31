*! version 1.3.5  10jan2019
program _mcmc_parse
	gettoken cmd 0 : 0
	_mcmc_parse_`cmd' `0'
end

program _mcmc_parse_ifincomma, sclass
	local lhs
	local rhs `0'
	local next
	local tobreak 0
	while `"`next'"' != "if" & `"`next'"' != "in" & ///
	      `"`next'"' != "," & `"`rhs'"' != "" & !`tobreak'{
	        local tobreak 0
		if bsubstr(`"`rhs'"', 1, 1) == " " {
			local lhs = `"`lhs' "'
			local tobreak 1
		}
		gettoken next rhs: rhs, parse("\ ,[{}") bind
		if `"`next'"' == "if" | `"`next'"' == "in" | ///
		   `"`next'"' == "," {
			continue
		}
		if `"`next'"' == "[" & `tobreak'{
			continue
		}
		local tobreak 0
		if `"`next'"' == "{" {
			gettoken next rhs: rhs, parse("{}") bind
			if `"`next'"' == "}" {
				di as error `"{} not allowed"'
				exit 198
			}
			local lhs = `"`lhs'{`next'"'
			gettoken next rhs: rhs, parse("{}") bind
			if `"`next'"' != "}" {
			
			di as error `"{bf:`next'} found where } expected"'
			exit 198
			
			}
			local lhs = `"`lhs'}"'
		}
		else local lhs = `"`lhs'`next'"'
	}
	local rhs `"`next' `rhs'"'
	local lhs `lhs'
	local rhs `rhs'
	sreturn clear
	sreturn local lhs = `"`lhs'"'
	sreturn local rhs = `"`rhs'"'
end

program _mcmc_parse_word, sclass

	sreturn clear

	local prefix  .
	local varval  1
	local latval  0
	local factval 0
	local matval  0	
	local initval .
	local omitval 0
	local tsval   0

	local word `0'
	gettoken next 0: 0, parse("{}=")

	local isparam 0
	local opencur 0
	while `"`next'"' == "{" {
		// must be a parameter, not variable 
		local varval  0
		local isparam 1
		local opencur = `opencur'+1
		gettoken next 0: 0, parse("{}=")
	}

	local ispref = regexm(`"`next'"', ":")
	if `ispref' == 1 {
		tokenize `"`next'"', parse(":")
		local prefix `1'
		capture _ms_parse_parts `prefix'
		if _rc == 0 {
			if "`r(ts_op)'" != "" {
				if `"`r(op)'.`r(name)'"' != `"`prefix'"' {
					local lglobal MCMC_TSSUB_`r(ts_op)'
					global `lglobal' = $`lglobal' + 1
					local lglobal MCMC_TSSUB_`r(ts_op)'_words
					global `lglobal' $`lglobal' `prefix'
				}
				local prefix `r(op)'.`r(name)'
			}
			else if "`r(op)'" == "" {
				local prefix `r(name)'
			}
		}
		mac shift 2
		local next ""
		while "`*'" != "" {
			local next `"`next'`1'"' 
			mac shift
		}
	}

	if `isparam' == 0 {
		if bsubstr("`next'",1,2) == "r." {
			local factval 1
			local l = max(3,length("`next'"))
			local next = bsubstr("`next'",3,`l')
		}
	}

	if `"`next'"' == "" {
		_mcmc_paramnotfound `"`word'"'
		exit 198
	}

	local word `next'
	gettoken next 0 : 0, parse("{}=")
	if `"`next'"' == "=" {
		gettoken next 0: 0, parse("{}")
		if `"`next'"' == "}" | `"`next'"' == "{"{
			di as err `"invalid specification of {bf:`word'}"'
			exit 198
	
		}
		// set init value
		local initval `next'
		gettoken next 0: 0, parse("{}=")
	}
	while `opencur' > 0 {
		if `"`next'"' != "}" {
			di as err `""{bf:`next'}" found where } expected "' ///
				`"after {bf:`word'}"'
			exit 198
	
		}
		local opencur = `opencur'-1
		gettoken next 0: 0, parse("{}=")
	}

	_parse comma word rhs : word
	local rhs : subinstr local rhs "," ""
	local l   = max(1,length("`rhs'"))
	local ext = bsubstr("`rhs'",1,`l')
	if "`ext'" != "" {
		if "`ext'" == bsubstr("latent",1,`l') {
			di as err "option {bf:`rhs'} for " ///
				"parameter {bf:`word'} not allowed"
			exit 198
			local latval 1
		}
		else {
			if "`ext'" == bsubstr("matrix",1,`l') {
				// ustrlen(matrixname_xxx_xxx) <= 32
				if ustrlen(`"`word'"') > 24 {
					di as err ///
					`"matrix name {bf:`word'} is too long"'
					exit 7
				}
				local matval 1
			}
			else {
				di as err "option {bf:`rhs'} for " ///
					"parameter {bf:`word'} is not allowed"
				exit 198
			}
		}
	}

	local scalelv 0
	local lvname MCMC_latent_`word'
	cap confirm name `lvname'
	if _rc == 0 & "`prefix'" != "." & `"$`lvname'"' != "" {
		// scale  coefficient to a latent variable
		local scalelv 1
	}

	capture confirm number `word'
	if _rc == 0 {
		local varval 0
	}
	else {
		// check for valid name 
		if `isparam' {
			// refer {U} to {U[id]}
			local lname "MCMC_latent_`word'"

			if !`scalelv' {
				tokenize `lname', parse("[].")
				if "`2'" == "" {
					local lname `1'
					capture confirm name `lname'
					if _rc == 0 & "$`lname'" != "" {
						local word "$`lname'"
					}
				}
			}

			if `"`word'"' == "_index"	|	///
			`"`word'"' == "_loglik"		|	///
			`"`word'"' == "_ll"	 	|	///
			`"`word'"' == "_loglikelihood"	|	///
			`"`word'"' == "_logposter"	|	///
			`"`word'"' == "_lp"	 	|	///
			`"`word'"' == "_logposterior" {
				di as err `"parameter name {bf:`word'} "' ///
					"not allowed"
				exit 198
			}

			capture _ms_parse_parts `word'
			if _rc == 0 {
				local omitval `r(omit)'
				if "`r(type)'" == "latent" {
					local latval 1
				}
				else if "`r(ts_op)'" != "" {
					if `"`r(op)'.`r(name)'"' != `"`word'"' {
						local lglobal MCMC_TSSUB_`r(ts_op)'
						global `lglobal' = $`lglobal' + 1
						local lglobal MCMC_TSSUB_`r(ts_op)'_words
						global `lglobal' $`lglobal' `word'
					}
					local word `r(op)'.`r(name)'
				}
			}
		}
		else {
			capture confirm name `word'
			if _rc != 0 {
				capture _ms_parse_parts `word'
				local omitval `r(omit)'
				if "`r(type)'" != "factor" &	  ///
				   "`r(type)'" != "interaction" & /// 
				   "`r(type)'" != "variable" &    ///
				   "`r(type)'" != "latent" {
					// must be name 
					// trigger error
					capture confirm name `word'
				}
				if "`r(type)'" == "latent" {
					local latval 1
					local varval 1
				}
				else if "`r(type)'" == "variable" & "`r(ts_op)'" != ""{
					capture confirm name `r(name)'
					local word `r(op)'.`r(name)'
					local tsval 1
				}
				else if "`r(type)'" == "variable" {
					if `omitval' != 1 {
						// must be omitted variable
						// trigger error
						capture confirm name `word'
					}
					// strip o.
					local word `r(name)'
				}
			}
		}

		// . is special
		if _rc != 0 & `"`word'"' != "." {
			if `varval' {
				di as err `"invalid name {bf:`word'}"'
			}
			else {
				di as err `"invalid parameter name {bf:`word'}"'
			}
			exit 198
		}
	}


	// allow . as +infinity 
	if `"`word'"' == "." {
		local varval 0
	}

	if `isparam' == 0 & `latval' == 1 {
		local varval 1
	}

	if !`isparam' & "`prefix'" == "." {
		capture confirm matrix `word'
		if _rc == 0 {
			local matval 1
		}
	}

	if `scalelv' {
		// scale  coefficient to a latent variable
		local varval 0
		local latval 0
	}

	sreturn local word	= "`word'"
	sreturn local prefix	= "`prefix'"
	sreturn local latval	= `latval'
	sreturn local factval	= `factval'
	sreturn local varval	= `varval'
	sreturn local matval	= `matval'
	sreturn local initval	= `initval'
	sreturn local omitval	= `omitval'
	sreturn local tsval	    = `tsval'

end

program _mcmc_parse_args, sclass

	// parse comma-separated arguments
	sreturn clear

	local largs
	local tok
	local param
	local ndargs 0

	// is it an expression (<expr>)
	gettoken expr next : 0, match(paren) parse("({},\ ")
	if `"`paren'"' == "(" & `"`0'"' == `"(`expr')"' {
		sreturn local args  = `"`0'"'
		sreturn local nargs = 1
		exit 0
	}

	local lastparen
	gettoken next 0 : 0, match(paren) parse("{},\ ") bind
	while `"`next'"' != "" | `"`tok'"' != "" {
		if `"`next'"' == "," | `"`next'"' == "" {
			local ndargs = `ndargs'+1
			// variables and expressions should be in paren 
			local paren (
			// numbers and matrices should not be in paren 
			capture confirm number `tok'
			if _rc == 0 {
				local paren
				sreturn local number`ndargs' = `"`tok'"'
			}
			capture confirm matrix `tok'
			if _rc == 0 {
				local paren
				sreturn local matrix`ndargs' = `"`tok'"'
			}
			// {param}s should not be in paren
			if `"`param'"' != "" {
				local paren
				sreturn local param`ndargs' = `"`tok'"'
			}
			if `"`paren'"' == "(" & `"`lastparen'"' != "(" {
				local largs `largs'(`tok')
			}
			else {
				local largs `largs'`tok'
			}
			local lastparen
			local tok
			local param
			local largs `largs'`next'
		}
		else if `"`next'"' == "{" {
			gettoken param 0: 0, match(paren) parse("{}")
			gettoken next  0: 0, match(paren) parse("{}")
			if `"`param'"' == "}" | `"`param'"' == "" |	///
						`"`next'"' != "}" {
				di as err `"parameter {bf:`param'`next'} "' ///
					"not allowed"
				exit 198
			
			}
			local next `tok'
			local tok `tok'{`param'}
			if `"`next'"' != "" {
				local param
			}
		}
		else {
			if `"`paren'"' == "(" {
				local lastparen (
				local tok `tok'(`next')
			}
			else {
				local lastparen
				local tok `tok'`next'
			}
			local param
		}
		gettoken next 0: 0, match(paren) parse("{},\ ") bind
	}

	sreturn local args = `"`largs'"'
	sreturn local nargs = `ndargs'
	
end

program _mcmc_parse_expression, sclass

	args strexpr xargcount 

	tempname minit mtype

	sreturn clear
	sreturn local input = "`strexpr'"

	_mcmc_parmlist `strexpr'

	if (`"`r(lablist)'"'!="" & "`r(parmlist)'"=="") {
		di as err `"invalid linear form {bf:{`r(lablist)':}}"'
		exit 198
	}
				
	sreturn local expr	= "`r(expr)'"
	sreturn local x		= "`r(parmlist)'"
	sreturn local xomit	= "`r(omitlist)'"
	sreturn local xprefix	= "`r(lablist)'"
	sreturn local varnames	= "`r(varnames)'"

	local nparms: word count `r(parmlist)'
	matrix `minit' = r(initmat)
	matrix `mtype' = r(typemat)

	local xinit
	local xisvar
	local xismat
	local xislat
	local xisfact
	local xargnum

	local i 0
	while `i' < `nparms' {
		local `++i'
		local lres = `minit'[1,`i']
		local xinit = "`xinit' `lres'"
		local lres  = `mtype'[1,`i']==1
		local xismat = "`xismat' `lres'"
		local lres  = `mtype'[1,`i']==2
		local xislat = "`xislat' `lres'"
		if `lres' == 1 {
			local xisvar = "`xisvar' 1"
		}
		else {
			local xisvar = "`xisvar' 0"
		}
		local xargnum = "`xargnum' `xargcount'"
	}
	
	local x	= "`r(parmlist)'"
	gettoken tok x : x
	while `"`tok'"' != "" {
		tokenize `"`tok'"', parse(".")
		if `"`1'"' != "" & `"`2'"' == "." & `"`3'"' != "" {
			local xisfact = "`xisfact' 1"
		}
		else {
			local xisfact = "`xisfact' 0"
		}
		gettoken tok x : x
	}

	sreturn local xinit	= "`xinit'"
	sreturn local xisvar	= "`xisvar'"
	sreturn local xismat	= "`xismat'"
	sreturn local xislat    = "`xislat'"
	sreturn local xisfact	= "`xisfact'"
	sreturn local xargnum   = "`xargnum'"
	sreturn local ehasvar   = "`r(varnames)'" != ""
end

program _mcmc_parse_expand, sclass

	sreturn clear

	local eqline
	local isparen 0
	local eqline
	local next `0'

	while "`next'" != "" {
		local whitepad = bsubstr("`0'", 1, 1) == " "
		gettoken next 0 : 0, parse("{()") match(paren)

		if "`paren'" == "(" {
			local isparen = `isparen' + 1
			local eqline `eqline'(
			local 0 `next')`0'
			continue
		}
		if "`next'" == ")" {
			local isparen = `isparen' - 1
			local eqline `eqline')
			continue
		}
		// work within braces only but not in paren 
		// exclude ({...}) 
		if "`next'" != "{" | `isparen' > 0 {
			if `whitepad' == 1 {
				local eqline "`eqline' `next'"
			}
			else {
				local eqline "`eqline'`next'"
			}
			continue
		}

		local prefix
		gettoken next 0: 0, parse("{}")
		gettoken enext 0: 0, parse("{}")
		if "`next'" == "" | "`enext'" != "}" {
			di as err "invalid specification {bf:`next'`enext'`0'}"
			exit 198
		}
		gettoken next option : next, parse(",") bind
		if "`next'" == "," {
			local next ""
			local option ",`option'"
		}

		tokenize "`next'", parse(":")
		if "`1'" != "" & "`2'" == ":" {
			local prefix `1':
			mac shift 2
			local next
			while "`*'" != "" {
				local next `next'`1'
				mac shift
			}
		}
		// this is the :name case which should be passed through 
		if "`1'" == ":" & "`2'" != "" {
			local eqline "`eqline'{`prefix'`next'`option'}"
			continue
		}

		local latlist $MCMC_latent
		gettoken ylabel latlist : latlist
		while `"`ylabel'"' != "" & ///
		`"`prefix'"' != `"`ylabel'"' & `"`prefix'"' != `"`ylabel':"' {
			gettoken ylabel latlist : latlist
		}
		if `"`ylabel'"' != "" {
			if `"`prefix'"' == `"`ylabel':"' & `"`next'"' != "" {
				local eqline "`eqline'{`prefix'`next'`option'}"
			}
			else {
				local eqline "`eqline'{`ylabel'`next'`option'}"
			}
			// make sure `next' is not empty
			local next `ylabel'
			continue
		}

		local ct 1
		while `ct' > 0 {
		local next : subinstr local next "= " "=", count(local ct)
		}
		local ct 1
		while `ct' > 0 {
		local next : subinstr local next " =" "=", count(local ct)
		}

		local enext
		if `"`next'"' == "" {
			local next {`prefix'`tok'`option'}
			
		}
		else {
			local enext `next'
			local next
		}

		while "`enext'" != "" {
			gettoken tok enext: enext, parse("\ ") match(paren) bind
			if "`paren'" == "(" {
				// expand (# #) lists 
				gettoken suffix enext: enext, parse("\ ")
				tokenize "`tok'", parse("\ /")
				if `"`2'"' == "" | `"`2'"' == "/"  {	
		// expand (#/#) ranges 
		// `next' may be :name, thus use "`next'" 
		capture confirm number `1'
		if _rc==0 capture confirm number `3'
		if _rc==0 & "`1'" != "" & "`2'" == "/" & "`3'" != "" {
			local tok `1'
			while `tok' <= `3' {
				local next ///
				  `next'{`prefix'`tok'`suffix'`option'}
				local tok = `++tok'
			}
		}
		else {
			local next 
			while "`*'" != "" {
				local next ///
				  `next'{`prefix'`1'`suffix'`option'}
				mac shift
			}
		}
				}
				else {
					while "`*'" != "" {
						local next ///
					`next'{`prefix'`1'`suffix'`option'}
						mac shift
					}
				}
			}
			else {
				tokenize "`tok'", parse(":")
				if "`1'" == ":" & "`2'" != "" {
	 	 		 	 local tok `2'
				}
				else if "`1'" != "" & "`2'" == ":" {
					if "`3'" == "" {

					di as err "invalid parameter {bf:`tok'}"
					exit 196
				
					}
					local prefix `1':
					local tok `3'
				}
				if "`tok'" != "" {
					local next `next'{`prefix'`tok'`option'}
				}
			}
		}
		// space pad on the right 
		local eqline "`eqline'`next'"
	}

	local eqline `eqline'`next'`0'
	local ct 1
	while `ct' > 0 {
		local eqline : subinstr local eqline "( " "(", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local eqline : subinstr local eqline " )" ")", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local eqline : subinstr local eqline " }" "}", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local eqline : subinstr local eqline "{ " "{", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local eqline : subinstr local eqline "}(" "} (", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local eqline : subinstr local eqline "){" ") {", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local eqline : subinstr local eqline "}{" "} {", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local eqline : subinstr local eqline "  " " ", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local eqline : subinstr local eqline ": " ":", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local eqline : subinstr local eqline " :" ":", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local eqline : subinstr local eqline ", " ",", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local eqline : subinstr local eqline " ," ",", count(local ct)
	}

	sreturn local eqline = "`eqline'"
end

program _mcmc_parse_equation, sclass

	local eval	""
	local expr	""
	local exprhasvar ""
	local dist	""
	local y		""
	local yisvar	""
	local yismat	""
	local yislat	""
	local yprefix	""
	local yinit	""
	local yomit	""
	local x	 	""
	local xisvar	""
	local xismat	""
	local xislat	""
	local xisfact	""
	local xprefix	""
	local xargnum	""
	local xinit	""
	local xomit	""
	local isprogram  0
	local evallist	""
	local varlist	""
	local exvarlist ""
	local exprlist	""

	local eqline `"`0'"'
	// _mcmc_scan_identmats after add_predict_factor
	_mcmc_scan_identmats `eqline'
	local eqline `"`s(eqline)'"'

	sreturn clear

	// extend right side prefixed parameters 
	_mcmc_parse_expand `eqline'
	local eqline `"`s(eqline)'"'
	tokenize `"`eqline'"', parse(",")
	local 0 `1'

	if $MCMC_debug {
		di " "
		di _asis `"		eqline: `eqline'"'
	}

	_mcmc_parse_comma `eqline'
	local eqline `s(lhs)'
	local rest   `s(rhs)'

	gettoken next eqline: eqline, parse("\ ,{}")
	// parse data/params until next = or , 
	// programs start with (, skip it 
	while "`next'" != "" {
		if "`next'" == "{" {
			gettoken next eqline: eqline, parse("{}")
			if "`next'" == "}" {
				di as err `"{} not allowed"'
				exit 198		
			}
			gettoken enext eqline: eqline, parse("{}")
			if "`enext'" != "}" {
				di as err `"{bf:`enext'} found where } expected"'
				exit 198
			}
			local next = "{`next'}"
		}

		_mcmc_parse_word `next'

		local y		= "`y' `s(word)'"
		local yprefix	= "`yprefix' `s(prefix)'"
		local yisvar	= "`yisvar' `s(varval)'"
		local yismat	= "`yismat' `s(matval)'"
		local yislat	= "`yislat' `s(latval)'"
		local yinit	= "`yinit' `s(initval)'"
		local yomit	= "`yomit' `s(omitval)'"

		if `s(varval)' & !`s(matval)' {
			local varlist = "`varlist' `s(word)'"
		}

		gettoken next eqline: eqline, parse("\ ,{}")
	}

	local eqline `rest'
	gettoken next eqline: eqline, parse("\ ()")

	if "`next'" == "(" { 
		// must be Stata program 
		local `isprogram' 1
	}
	else {
		// distributions/functions 
		_mcmc_distr checkname "`next'"
		local dist `s(distribution)'
		gettoken next eqline: eqline, parse("\ ()")
		if "`next'" != "(" & "`next'" != "" { 
			di as err "{bf:`next'} found where ( expected " ///
				"after {bf:`dist'}"
			exit 198
		}
	}

	// start counting from 0 
	local argcount 0

	gettoken next eqline: eqline, parse("\ ,{}()")
	while "`next'" != ")" & "`next'" != "" {

		while "`next'" == "," {
			gettoken next eqline: eqline, parse("\ ,{}()")
		}
		if "`next'" == ")" {
			continue
		}

		local evalfunc = "NULL"
		local `++argcount'

		// expressions 
		if "`next'" == "(" {
			local eqline `"(`eqline'"'
			gettoken expr eqline: eqline, match(paren)
			if "`paren'" != "(" {
				di as err `"( expected in {bf:`eqline'}"'
				exit 198
			}
			local next ")"
			local expr `"(`expr')"'

			_mcmc_parse_expression `"`expr'"' `argcount'

			local x		= "`x' `s(x)'"
			local xprefix   = "`xprefix' `s(xprefix)'"
			local xisvar	= "`xisvar' `s(xisvar)'"
			local xismat	= "`xismat' `s(xismat)'"
			local xislat	= "`xislat' `s(xislat)'"
			local xisfact	= "`xisfact' `s(xisfact)'"
			local xinit	= "`xinit' `s(xinit)'"
			local xomit	= "`xomit' `s(xomit)'"
			local xargnum   = "`xargnum' `s(xargnum)'"
			local exprhasvar= "`exprhasvar' `s(ehasvar)'"
			local varlist   = "`varlist' `s(varnames)'"
			local exvarlist = "`exvarlist' `s(varnames)'"
			local exprlist = "`exprlist' `s(input)'"

			if `isprogram' { // remove parentheses 
				gettoken expr: expr, match(paren)
				local eval = `"`eval' "`expr'""'
			}
			else {
				local eval = `"`eval' "`s(expr)'""'
			}

			local evallist = "`evallist' NULL"

			// check for valid names 
			tokenize `s(x)', parse("\ ")
			while "`*'" != "" {
				_mcmc_parse_word `1'
				mac shift
			}

			if "`dist'" != "" { // it is NOT a Stata program 
				gettoken next eqline: eqline, parse("\ ,(){}=")
				// move to the next argument 
				if  `"`next'"' == "," {
					gettoken next eqline: eqline, ///
						parse("\ ,(){}=")
				}	
			}
			
			continue
		} // end of expressions 

		local evalvar 0	
		while `"`next'"' != ")" & `"`next'"' != "," & `"`next'"' != "" {

			local xval "`next'"
			if "`next'" == "{" {
				gettoken next eqline: eqline, parse("{}")
				if "`next'" == "}" {
		 	 	 	 di as err `"{} not allowed"'
		 	 	 	 exit 198
				}
				local xval = "`xval'`next'"
				gettoken next eqline: eqline, parse("{}")
				if "`next'" != "}" {
					di as err "{bf:`next'} found " ///
						"where } expected"
					exit 198
				}
				local xval = "`xval'`next'"
			}

			_mcmc_parse_word `xval'

			if `s(varval)' {
				local evalvar 1
			}
			// sanity check
			local nxs: word count `s(word)'
			local nprefx: word count `s(prefix)'
			if `nxs' != `nprefx' {
				di as err "parameter {bf:`xval'} not allowed"
				exit 198
			}

			local x		= "`x' `s(word)'"
			local xprefix	= "`xprefix' `s(prefix)'"
			local xinit	= "`xinit' `s(initval)'"
			local xomit	= "`xomit' `s(omitval)'"
			local xisvar	= "`xisvar' `s(varval)'"
			local xismat	= "`xismat' `s(matval)'"
			local xislat	= "`xislat' `s(latval)'"
			local xisfact	= "`xisfact' `s(factval)'"
			local xargnum	= "`xargnum' `argcount'"
			
			if `s(varval)' & !`s(matval)' & ///
				"`s(word)'" != "_cons" & !`s(latval)' {
				local varlist = "`varlist' `s(word)'"
			}
		
			gettoken next eqline: eqline, parse("\ ,{})") bind
		}

		if `evalvar' & "`evalfunc'" == "NULL" {
			local evalfunc "xb"
		}

		if "`evalfunc'" != "" & "`evalfunc'" != "NULL" {
			local evallist = "`evallist' `evalfunc'"
		}
		else {
			local evallist = "`evallist' NULL"
		}
		
		local eval       `"`eval' `evalfunc'"'
		local exprhasvar `"`exprhasvar' 0"'
		
		// move to the next argument 
	}

	// end of dist segment 
	if `argcount' > 0 & "`next'" != ")" {
		di as err `"{bf:`next'} found where ) expected"'
		exit 198
	}
	
	gettoken next eqline: eqline, parse("\ ,()")

	// parse data/params until the first option 
	while "`next'" == "," {
		gettoken next eqline: eqline, parse("\ ,()")
	}

	local nocons 0

	while "`next'" != ")" & "`next'" != "" {
		if "`next'" == "nocons" {
			local nocons 1
		}
		gettoken next eqline: eqline, parse("\ ,()")
	}

	// end of model/prior segment 
	if "`next'" != "" {
		di as err `"equation ({bf:`0'}) ended unexpectedly"'
		exit 198
	}

	// trim white spaces 
	local exprhasvar `exprhasvar'

	local y	   	`y'
	local yprefix	`yprefix'
	local yisvar	`yisvar'
	local yismat	`yismat'
	local yislat	`yislat'
	local yinit	`yinit'
	local yomit	`yomit'

	local x		`x'
	local xprefix	`xprefix'
	local xisvar	`xisvar'
	local xismat	`xismat'
	local xislat	`xislat'
	local xisfact	`xisfact'
	local xinit	`xinit'
	local xomit	`xomit'
	local xargnum	`xargnum'

	local exprlist  `exprlist'
	local exprhasvar `exprhasvar'

	local varlist   `varlist'
	local exvarlist `exvarlist'

	if $MCMC_debug {	 	
		di " "
		di `"               y: `y'"'
		di `"         yprefix: `yprefix'"'
		di `"           yinit: `yinit'"'
		di `"           yomit: `yomit'"'
		di `"          yisvar: `yisvar'"'
		di `"       yislatent: `yislat'"'
		di `"          yismat: `yismat'"'
		di `"            dist: `dist'"'
		di `"               x: `x'"'
		di `"         xprefix: `xprefix'"'
		di `"           xinit: `xinit'"'
		di `"           xomit: `xomit'"'
		di `"          xisvar: `xisvar'"'
		di `"       xislatent: `xislat'"'
		di `"          xismat: `xismat'"'
		di `"         xisfact: `xisfact'"'
		di `"         xargnum: `xargnum'"'
		di `"            eval: `eval'"'
		di `"       exvarlist: `exvarlist'"'
		di `"          nocons: `nocons'"'
		di `"      exprhasvar: `exprhasvar'"'
	}

	sreturn local dist		= "`dist'"
	// eval may contain expressions, use compound quotes 
	sreturn local eval		= `"`eval'"'
	sreturn local exprlist		= `"`exprlist'"'
	sreturn local evallist		= "`evallist'"
	sreturn local exprhasvar	= "`exprhasvar'"
	sreturn local argcount		= "`argcount'"

	sreturn local y	 	= "`y'"
	sreturn local yprefix	= "`yprefix'"
	sreturn local yisvar	= "`yisvar'"
	sreturn local yismat	= "`yismat'"
	sreturn local yislat	= "`yislat'"
	sreturn local yinit	= "`yinit'"
	sreturn local yomit	= "`yomit'"

	sreturn local x		= "`x'"
	sreturn local xprefix	= "`xprefix'"
	sreturn local xisvar	= "`xisvar'"
	sreturn local xismat	= "`xismat'"
	sreturn local xislat	= "`xislat'"
	sreturn local xisfact   = "`xisfact'"
	sreturn local xinit	= "`xinit'"
	sreturn local xomit	= "`xomit'"
	sreturn local xargnum	= "`xargnum'"
	
	sreturn local varlist	= "`varlist'"
	sreturn local exvarlist	= "`exvarlist'"

	sreturn local nocons	= "`nocons'"
end

program _mcmc_parse_blocks, sclass

	sreturn clear

	local params	""
	local parids	""
	local prefix	""
	local lmatrix	""
	local llatent	""
	local lsampler	""
	local lsplit	""
	local lscale	""
	local lcov	""
	local larate	""
	local latol	""
	local id	1

	// trim white space and starting commas 
	local 0 `0'
	if `"`0'"' == "" {
		exit 0
	}
	while regexm(`"`0'"', "^;") {
		local 0 = regexr(`"`0'"', "^;", "")
	}

	// extend right side prefixed parameters 
	_mcmc_parse_expand `0'
	local eqline `s(eqline)'

	if $MCMC_debug {
		di " "
		di _asis `"  block eqline: `eqline'"'
	}

	local fullparams
	gettoken 0 eqline: eqline, parse(";")
	while `"`0'"' != "" {

		if `"`0'"' == ";" {
			gettoken 0 eqline: eqline, parse(";")
			continue
		}

		scalar numparams = 0
		gettoken next 0: 0, parse("\ ,{}")
		while `"`next'"' != "" & `"`next'"' != "," {
			// block can have optional parameters 
			if `"`next'"' == "{" {
				gettoken paramname 0: 0, parse("{}")
				gettoken next 0: 0, parse("\ ,{}")
				if `"`next'"' != "}" {
					di as err `"invalid block"'
					exit 198
				}			
			}
			else {
				local paramname `next'
			}
			
			// parse parameter in parentheses 
			_mcmc_parse_word {`paramname'}
			if `"`s(word)'"' == "" {
				gettoken next 0: 0, parse("\ ,{}")
				continue
			}

			local parids  = "`parids' `id'"
			local prefix  = "`prefix' `s(prefix)'"
			local params  = "`params' `s(word)'"
			local lmatrix = "`lmatrix' `s(matval)'"
			local llatent = "`llatent' `s(latval)'"

		if "`s(prefix)'" != "" & "`s(prefix)'" != "." {
			local fullparams `"`fullparams' `s(prefix)':`s(word)'"'
		}
		else {
			local fullparams `"`fullparams' `s(word)'"'
		}

			scalar numparams = numparams + 1
			gettoken next 0: 0, parse("\ ,{}")
		}

		// increase the index if the current block is non-empty
		if `"`parids'"' != "" {
			local `++id'
		}

		if `"`next'"' == "," {
			local 0 ,`0'
		}

		// gaussian random walk is default 
		local sampler grw
		syntax [anything] [, GIBBS SPLIT REffects ///
			SCale(string) COVariance(string) ADAPTation(string)]

		if `"`gibbs'"' != "" & `"`reffects'"' != "" {
			di as err "in option {bf:block()}, options " ///
				"{bf:gibbs} and {bf:reffects} cannot be combined"
			exit 198
		}
		if `"`reffects'"' != "" & `"`split'"' != "" {
			di as err "in option {bf:block()}, options " ///
			"{bf:split} and {bf:`reffects'} cannot be combined"
			exit 198
		}
		
		if `"`covariance'"' != "" & numparams < 2 {
			di as err "in {bf:block()} with one parameter, " ///
				"option {bf:covariance()} cannot be specified"
			exit 198
		}
		if `"`covariance'"' != "" & `"`split'"' != "" {
			di as err "in option {bf:block()}, " ///
				"options {bf:covariance()} and {bf:split} " ///
				"may not be combined"
			exit 198
		}
		if `"`covariance'`scale'`adaptation'"' != "" & "`gibbs'" != "" {
			di as err "in option {bf:block()}, option "     ///
			        "{bf:gibbs} may not be combined with " ///
				"options {bf:scale()}, {bf:covariance()}, " ///
				"and {bf:adaptation()}"
			exit 198
		}
		if (`"`scale'"'!="") {
			local rc
			cap confirm number `scale'
			local rc = _rc
			if `rc'==0 {
				if (`scale'<0) {
					local rc 198
				}
			}
			if `rc' {
				di as err "option {bf:scale()} must " ///
					  "contain a positive number"
				exit 198
			}
		}
		else {
			local scale 0
		}

		if `"`gibbs'"' != "" {
			local sampler gibbs
		}
		if `"`reffects'"' != "" {
			local sampler reffects
		}
		if `"`split'"' != "" {
			local split 1
		}
		else {
			local split 0
		}
		local lsampler  = "`lsampler' `sampler'"
		local lsplit  = "`lsplit' `split'"

		if `scale' < 0 {
			di as err "in option {bf:block()}, " ///
				  "option {bf:scale()} must " ///
				  "contain a positive number"
			exit 198
		}

		if `"`covariance'"' != "" {
			confirm matrix `covariance'
		}
		else {
			local covariance .
		}
		local lcov   = "`lcov' `covariance'"
		local lscale = "`lscale' `scale'"

		local 0 ,`adaptation'

		syntax [anything] [, TARATE(string) TOLerance(real 0.01)]

		if `"`tarate'"' != "" {
			local 0 , tarate(`tarate')
			syntax [anything],[TARATE(real 0)]
			if `tarate' <= 0 | `tarate' >= 1 {
				di as err "in option {bf:block()}, option " ///
					  "{bf:tarate()} must " ///
					"contain a number between 0 and 1"
				exit 198
			}
		}
		else {
			// this triggers default initialization
			local tarate 0
		}
		if `tolerance' <= 0 | `tolerance' >= 1 {
			di as err "in option {bf:block()}, option " ///
				  "{bf:tolerance()} must " ///
				  "contain a number between 0 and 1"
			exit 198
		}

		local larate = "`larate' `tarate'"
		local latol  = "`latol'  `tolerance'"

		gettoken 0 eqline: eqline, parse(";")
	}

	local params `params'
	if "`params'" == "" {
		_mcmc_paramnotfound `"`0'"'
		exit 198
	}

	local fullparams `fullparams'
	local ldups: list dups fullparams
	if `"`ldups'"' != "" {
		di as err `"{bf:`ldups'} already included in a block"'
		exit 198
	}

	sreturn local fullparams= "`fullparams'"
	sreturn local params	= "`params'"
	sreturn local prefix	= "`prefix'"
	sreturn local parids	= "`parids'"
	sreturn local matrix	= "`lmatrix'"
	sreturn local latent	= "`llatent'"
	sreturn local sampler	= "`lsampler'"
	sreturn local split	= "`lsplit'"
	sreturn local scale	= "`lscale'"
	sreturn local cov	= "`lcov'"
	sreturn local arate	= "`larate'"
	sreturn local atol	= "`latol'"
end
