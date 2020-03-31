*! version 1.0.0  18sep2014
* put factor variable expression into matrix stripe form

program define _parse_sexp_matrix_form, sclass
	syntax anything(id="parameter list" name=params)

	local k = 0
	while "`params'" != "" {
		gettoken par params : params, bind
		gettoken eq mpar : par, parse(":")
		if "`eq'" == "`par'" {
			local mpar `par'
			local eq
		}
		else {
			gettoken colon mpar : mpar, parse(":")
		}
		/* put into matrix form					*/
		_ms_unab mpar : `mpar'
		if "`eq'" != "" {
			local mpar `eq':`mpar'
		}
		local mparams `"`mparams' `mpar'"'
		local `++k'
	}
	local mparams : list retokenize mparams

	sreturn local k = `k' 
	sreturn local parameters `mparams'
end

exit
