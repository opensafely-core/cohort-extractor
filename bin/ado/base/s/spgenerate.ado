*! version 1.0.3  24mar2017
program define spgenerate, sortpreserve
	version 15.0
/*
	spgenerate [<vartype>] <newvar>  = <Wname>*<varname> [if] [in]
*/
	
	syntax anything(name=eq equalok)	///
		[if] [in] 			///
		[, id(string)]
	
	marksample touse

 	__sp_parse_id, id(`id')
	local id `s(id)'

	ParseEq, eq(`eq')
	local vartype `s(vartype)'
	local newvar `s(newvar)'
	local objname `s(objname)'
	local oldvar `s(oldvar)'
						// resort data to match id in
						// objname
	_spreg_match_id, id(`id') touse(`touse') lag_list(`objname')
						// compute W*y
	mata : _SPMATRIX_lag(	///
		"`vartype'",	///
		"`newvar'",	///
		"`objname'",	///
		"`oldvar'", 	///
		"`touse'")
end

					//-- ParseEq --//
program ParseEq, sclass
/*
	eq :
		[<vartype>] <newvar>  = <Wname>*<varname> 
*/
	syntax , eq(string)

	gettoken lhs rhs : eq, parse("=")
	gettoken equal rhs : rhs, parse("=")
						// parse vartype newvar : lhs
	local n_lhs : list sizeof lhs
	if (`n_lhs' >=3 | `n_lhs' <=0 ) {
		ErrorInvalidSyntax
	}
	if (`n_lhs' == 1) {
		local newvar `lhs'
		local vartype float
	}
	else if (`n_lhs' == 2) {
		gettoken vartype newvar : lhs
	}

	if (`"`vartype'"'!="double" & `"`vartype'"' != "float") {
		di as err "invalid type"
		exit 498
	}
	ConfirmNames, names(`newvar')
	capture confirm new variable `newvar'
	if _rc {
		di as err `"variable {bf:`newvar'} already defined"'
		exit 110
	}
						// parse objname oldvar : rhs
	local n_rhs : list sizeof rhs
	if (`n_rhs' != 1) { 
		ErrorInvalidSyntax
	}

	gettoken objname oldvar : rhs, parse("*")	
	gettoken star oldvar : oldvar, parse("*")

	if (`"`star'"'!="*") {
		ErrorInvalidSyntax
	}

	local n_objname : list sizeof objname
	if (`n_objname' != 1) {
		ErrorInvalidSyntax
	}

	local n_oldvar : list sizeof oldvar
	if (`n_oldvar' != 1) {
		ErrorInvalidSyntax
	}

	ConfirmNames, names(`objname' `oldvar')

	capture mata : _SPMATRIX_assert_object("`objname'")
	if _rc SPMAT_error `objname'

	capture confirm numeric variable `oldvar'
	if _rc {
		di as err "{bf: `oldvar'} must be a numeric variable"	
		exit 498
	}

	sret local vartype `vartype'
	sret local newvar `newvar'
	sret local objname `objname'
	sret local oldvar `oldvar'
end
					//-- ErrorInvalidSyntax --//
program ErrorInvalidSyntax
	di as err "invalid syntax"
	exit 198
end
					//-- ConfirmNames --//
program ConfirmNames
	syntax , names(string)

	foreach name of local names {
		capture confirm names `name'
		if _rc {
			di as err "invalid name {it : `name'}
			exit 198
		}
	}
end
					//-- SPMAT_error --//
program define SPMAT_error

	args objname
	
	di "{err}weighting matrix {bf:`objname'} not found"
	exit 111
end
