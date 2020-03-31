*! version 1.0.0  25nov2015
/* utility used by -ivprobit-, -ivtobit-, -ivfprobit-			*/
program define ivmodel_parse, sclass
	version 14.0
	_on_colon_parse `0'
	local which `s(before)'
	local 0 `s(after)'
	local n = 0

	gettoken lhs 0 : 0, parse(" ,[") match(paren)
	IsStop `lhs'
	if `s(stop)' { 
		error 198 
	}  
	local syntax "{it:dependent variable} "
	local syntax "`syntax' {bf:[}{it:exogenous variables}{bf:]}"
	local syntax2 "{bf:(}{it:all instrumented variables}{bf: = }"
	local syntax2 "`syntax2' {it:instrument variables}{bf:)}"
	local syntax "`syntax' `syntax2'"
	while `s(stop)'==0 {
		if "`paren'"=="(" {
			local n = `n' + 1
			if `n'>1 {
				capture noi error 198
				di as txt "{phang}The syntax is: " ///
				 "`syntax'{p_end}"
				exit 198
			}
			gettoken p lhs : lhs, parse(" =")
			while "`p'"!="=" {
				if "`p'"=="" {
					capture noi error 198
					di as txt "{phang}The syntax is: " ///
					 "`syntax2'.  The equal sign is "  ///
					 "required{p_end}"
					exit 198
				}
				local end`n' `end`n'' `p'
				gettoken p lhs : lhs, parse(" =")
			}
			local end`n' : list retokenize end`n'
			if "`end`n''" != "" {
				fvunab end`n' : `end`n''
			}
			local lhs : list retokenize lhs
			if "`lhs'" != "" {
				fvunab exog`n' : `lhs'
			}
		}
		else {
			local exog `exog' `lhs'
		}
		gettoken lhs 0 : 0, parse(" ,[") match(paren)
		IsStop `lhs'
	}
	local rest `"`lhs' `0'"'

	if !`n' {
		gettoken which ex : which
		di as err "no endogenous variables; use " ///
		 "{helpb `which'}{bf:`ex'} instead"
		exit 498
	}
	else if "`end1'" == "" {
		di as err "endogenous model incorrectly specified"
		di as txt "{phang}At least one endogenous variable is " ///
		 "required on the left side of the equal sign.{p_end}"
		exit 198
	}
	cap noi _fv_check_depvar `end1'
	local rc = c(rc)
	if `rc' {
		local k : list sizeof end1
		local vars = plural(`k',"variable")
		local are = plural(`k',"is","are")
		di as txt "{phang}The endogenous `vars' `are' incorrectly " ///
		 "specified{p_end}"
		exit `rc'
	}
	Subtract inst : "`exog1'" "`exog'"
	if "`inst'" == "" {
		di as err "no instrument variables specified"
		di as txt "{phang}The syntax is: `syntax2'{p_end}"
		exit 481
	}
	gettoken lhs exog : exog, bind
	_fv_check_depvar `lhs'

	foreach vlist in exog inst {
		/* exog could be empty					*/
		if "``vlist''" != "" {
			local 0 ``vlist''
			syntax varlist(numeric ts fv)
			local `vlist' `varlist'
		}
	}
	foreach vlist in lhs end1 {
		local 0 ``vlist''
		syntax varlist(numeric ts)
		local `vlist' `varlist'
	}
	sreturn local end1 `end1'
	sreturn local inst `inst'
	sreturn local exog `exog'
	sreturn local lhs `lhs'
	sreturn local options `"`rest'"'
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

// Borrowed from ivreg.ado	
program define Subtract   // <cleaned> : <full> <dirt> 
	args cleaned   ///  /*  macro name to hold cleaned list		*/
	     colon     ///  /*  ":"					*/
	     full      ///  /*  list to be cleaned			*/
	     dirt      ///  /*  tokens to be cleaned from full 		*/

	tokenize `dirt'
	local i 1
	while "``i''" != "" {
		local full : subinstr local full "``i''" "", word all
		local i = `i' + 1
	}

	tokenize `full'                 /* cleans up extra spaces */
	c_local `cleaned' `*'
end

exit

