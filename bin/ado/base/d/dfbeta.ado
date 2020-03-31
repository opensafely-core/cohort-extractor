*! version 4.2.0  28may2009
program define dfbeta
	if _caller() < 11 {
		dfbeta_10 `0'
		exit
	}
	version 11
	local vv : display "version " string(_caller()) ", missing:"
	_isfit cons newanovaok

	syntax [varlist(default=none fv ts)] [, stub(name)]

	if !`:length local varlist' {
		local varlist : colna e(b)
		local USCONS _cons
		local varlist : list varlist - USCONS
	}
	_ms_extract_varlist `varlist', noomit
	local varlist `"`r(varlist)'"'

	if "`stub'" == "" {
		local stub _dfbeta_
	}
	local l : length local stub
	if `l' > 20 {
		di as err "stub name too long, must be at most 20 characters"
		exit 198
	}

	local i 1
	foreach x of local varlist {
		MakeNewName name i : `stub' `i'
		`vv' predict float `name', dfbeta(`x')
		di as txt %32s "`name'" ": dfbeta(`x')"
	}
end

program MakeNewName
	args c_name c_i COLON stub i

	capture confirm new var `stub'`i'
	while c(rc) {
		local ++i
		capture confirm new var `stub'`i'
	}
	c_local `c_name' `stub'`i'
	c_local `c_i' `i'
end
exit
