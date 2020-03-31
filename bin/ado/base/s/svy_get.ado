*! version 2.0.1  29sep2004
program define svy_get, sclass
/*
   Syntax:

	svy_get key [varname] [, OPTional REQuired]

	If "optional" specified, it will not produce an error
	message if varname is not given and name is not set.
	Note: "required" is the default.

	Output:  s(varname)
*/
	version 8, missing
	gettoken key 0 : 0, parse(" ,")
	capture confirm name `key'
	if _rc {
		di as err "keyword incorrect"
		error 198
	}

	capture syntax [varlist(max=1 default=none)] [, OPTional REQuired ]
	if _rc {
		di as err "keyword incorrect"
		error 198
	}

	if "`optional'"!="" & "`required'"!="" {
		error 198
	}
	if `"`varlist'"' != "" {
		if `"`key'"' == "pweight" {
			local option [`key'=`varlist']
		}
		else {
			local option , `key'(`varlist')
		}
	}
	capture noi qui svyset `option'
	if _rc {
		exit _rc
	}

	/* return variable name and/or "required" error message */
	local varname `r(`key')'
	sreturn clear
	sreturn local varname `varname'
	global S_1 "`varname'"          /* double save */
	if "`varname'"=="" & "`optional'"=="" {
		di as error "`key'() required"
		exit 100
	}
end

exit

