*! version 1.0.0  11may2017
program _erm_parse_equation_noeq, sclass
	version 15
	syntax, EQuation(string) 	///
		NEQuation(string) 	///
		NINDepvars(string) 	///
		[SEXTraopts(string) 	///
		EXTraopts(string) 	///
		plural]
	// error macro for potential later use
	local es "invalid specification of {bf:`nequation'()};"
	local 0 `equation'
	capture syntax anything, [ * ]
	if (_rc) {
		di in smcl as error `"`es'"'
		syntax anything, [ * ]
		exit 198
	}
	local indepvars `anything'
	fvexpand `indepvars'
	local indepvars `r(varlist)'
	local 0 , `options'
	local b = ltrim(rtrim("`sextraopts'"))
	local b = subinstr(`"`b'"'," ", "(string) ",.)
	local b `b'(string)
	local a syntax, [noCONstant		///
		EXPosure(varname numeric ts)	///
		 OFFset(varname numeric ts)	///
		`b' `extraopts']
	capture `a'
	if (_rc) {
		di in smcl as error `"`es'"'
		`a'
		exit 198
	}
	if ("`exposure'" != "" & "`offset'" != "") {
		di in smcl as error `"`es'"'
		opts_exclusive "exposure() offset()"
	}
	sreturn local indepvars `indepvars'
	sreturn local constant `constant'
	if ("`exposure'" != "") {
		sreturn local exposure exposure(`exposure')
	}
	if ("`offset'" != "") {
		sreturn local offset offset(`offset')
	}
	foreach lname of local sextraopts {
		local lc = lower("`lname'")
		sreturn local `lc' ``lc''
	}
	foreach lname of local extraopts {
		local lc = lower("`lname'")
		sreturn local `lc' ``lc''
	}
end
exit
