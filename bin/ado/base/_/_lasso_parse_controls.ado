*! version 1.0.6  04jun2019
/*
	given local 0    varlist1 (varlist2) varlist3

	output:

		ainclude = varlist2
		othervars = varlist1 + varlist3

		indepvars ainclude + othervars
*/
program _lasso_parse_controls, sclass

	version 16.0

	syntax [anything(name=eq)] [, infer_lasso]
					//  check alwaysvars paren
	CheckAlwaysParen , eq(`eq') `infer_lasso'

					//  split eq into ainclude and
					//  othervars
	SplitEq, eq(`eq') `infer_lasso'
end


					//----------------------------//
					// Check always var paren
					//----------------------------//
program CheckAlwaysParen
	syntax [, eq(string) infer_lasso]

	tempname tmp
	local eq `tmp' `eq' `tmp'

	if (ustrpos(`"`eq'"', " (")) {
		local stop = 0
	}
	else {
		local stop = 1
	}

	local cnt = 0
	while (!`stop') {
		gettoken lhs eq : eq , match(paren) bind

		if (`"`paren'"' == "(" 	& usubstr(`"`eq'"', 1, 1) == " ") {
			local cnt = `cnt' + 1
		}

		if (`"`eq'"' == "") {
			local stop = 1
		}
	}

	if (`cnt' > 1) {
		_lasso_errors_eq, `infer_lasso'
	}
end
					//----------------------------//
					// split equation
					//----------------------------//
program SplitEq, sclass
	syntax , [eq(string) infer_lasso]

	if (`"`eq'"' == "") {
		exit	
		// NotReached
	}

	tempname tmp
	local eq `tmp' `eq' `tmp'

	if (ustrpos(`"`eq'"', " (")) {
		local stop = 0
	}
	else {
		local stop = 1
		local othervars `eq'
	}


	local connect = 0
	while (!`stop') {
		gettoken lhs eq : eq , match(paren) bind

		if (`"`paren'"' == "(") {
			if (usubstr(`"`eq'"', 1, 1) == " ") {
				local ainclude `lhs'
				local othervars `othervars' `eq'
				local stop = 1
				local connect = 0

				if (strtrim(`"`eq'"') == "`tmp'") {
					_lasso_errors_eq, `infer_lasso' empty
				}
			}
			else {
				local othervars `othervars' (`lhs')
				local stop = 0
				local connect = 1
			}
		}
		else {
			if (`connect') {
				local othervars `othervars'`lhs'
			}
			else {
				local othervars `othervars' `lhs'
			}
			local stop = 0
			local connect = 0
		}

		if (`"`eq'"' == "") {
			local stop = 1
		}
	}

	local othervars : list othervars - tmp
	local othervars : list othervars - tmp
	local indepvars `ainclude' `othervars'

	if (`"`othervars'"' == "") {
		_lasso_errors_eq, `infer_lasso' empty
	}

	sret local ainclude `ainclude'
	sret local othervars `othervars'
	sret local indepvars `indepvars'
end
