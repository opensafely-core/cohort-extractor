*! version 1.1.4  15apr2013

program _iv_parse, sclass
	
	local n 0

	gettoken lhs 0 : 0, parse(" ,[") match(paren) bind
	if (strpos("(",`"`lhs'"')) {
		fvunab lhs : `lhs'
		if `:list sizeof lhs' > 1 {
			gettoken lhs rest : lhs
			local 0 `"`rest' `0'"'
		}
	}
	IsStop `lhs'
	if `s(stop)' { 
		error 198 
	}  
	_fv_check_depvar `lhs'
	while `s(stop)'==0 {
		if "`paren'"=="(" {
			local n = `n' + 1
			if `n'>1 {
				capture noi error 198
di as error `"syntax is "(all instrumented variables = instrument variables)""'
				exit 198
			}
			gettoken p lhs : lhs, parse(" =") bind
			while "`p'"!="=" {
				if "`p'"=="" {
					capture noi error 198
di as error `"syntax is "(all instrumented variables = instrument variables)""'
di as error `"the equal sign "=" is required"'
					exit 198
				}
				local end`n' `end`n'' `p'
				gettoken p lhs : lhs, parse(" =") bind
			}
			/* An undocumented feature is that we can specify
			   ( = <insts>) with GMM estimation to impose extra
			   moment conditions 
			*/ 
			if "`end`n''" != "" {
				fvunab end`n' : `end`n''
			}
			fvunab exog`n' : `lhs'
		}
		else {
			local exog `exog' `lhs'
		}
		gettoken lhs 0 : 0, parse(" ,[") match(paren) bind
		IsStop `lhs'
	}
	mata: st_local("0",strtrim(st_local("lhs")+ " " + st_local("0")))

	fvunab exog : `exog'
	fvexpand `exog'
	local exog `r(varlist)'
	tokenize `exog'
	local lhs "`1'"
	local 1 " "
	local exog `*'
	
	// Eliminate vars from `exog1' that are in `exog'
	local inst : list exog1 - exog
	if ("`end1'" != "") {
		fvunab end1 : `end1'
		fvexpand `end1'
		local end1 `r(varlist)'
	}
	
	// `lhs' contains depvar, 
	// `exog' contains RHS exogenous variables, 
	// `end1' contains RHS endogenous variables, and
	// `inst' contains the additional instruments
	// `0' contains whatever is left over (if/in, weights, options)
	
	sret local lhs `lhs'
	sret local exog `exog'
	sret local endog `end1'
	sret local inst `inst'
	sret local zero `"`0'"'

end

// Borrowed from ivreg.ado	
program define IsStop, sclass

	if `"`0'"' == "[" {
		sret local stop 1
		exit
	}
	if `"`0'"' == "," {
		sret local stop 1
		exit
	}
	if `"`0'"' == "if" {
		sret local stop 1
		exit
	}
	if `"`0'"' == "in" {
		sret local stop 1
		exit
	}
	if `"`0'"' == "" {
		sret local stop 1
		exit
	}
	else {
		sret local stop 0
	}

end

