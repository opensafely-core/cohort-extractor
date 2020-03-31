*! version 1.0.4  13feb2015 
* This is used by commands that allow substitutable expressions and
* derivatives --- -gmm- and -mlexp-.
program _parse_sexp_deriv, sclass
	version 13
	args derivative eqnames

	sreturn clear
	// separate [<eq>]/param = deriv
	gettoken first deriv : derivative, p("=") bind
	gettoken equal deriv : deriv, p("=") bind
	if "`equal'" != "=" {
		di as err "{p}option {bf:derivative(`derivative')} is "    ///
		 "invalid; an equal sign, {bf:=}, is required delimiting " ///
	 	 "the equation identifier and the derivative expression{p_end}"
		exit 498
	}

	// deriv has expression; first has [<eq>]/param
	gettoken eqn param : first, p("/") bind
	gettoken slash param : param, p("/") bind

	// if user just types /param, eqn has "/" and slash has parameter
	if "`eqn'" == "/" {
		local param `slash'
		local slash "/"
		local eqn 1
	}
	if "`slash'" != "/" {
		di as err "{p}option {bf:derivative(`derivative')} is " ///
		 "invalid; a forward slash, {bf:/}, is required "       ///
		 "identifying the parameter name{p_end}"
		exit 498
	}
	if "`eqn'" == "" {
		local eqn 1
	}
	else {
		// undocumented: can specify deriv(#1/b0=...) -- #sign
		if bsubstr(`"`eqn'"',1,1) == "#" {
			local eqn `= bsubstr(`"`eqn'"',2,.)'
		}
		capture confirm integer number `eqn'
		if _rc {
			local 0 , equation(`eqn')
			syntax , [EQuation(string)]
			local eqn : list posof "`equation'" in eqnames
			if `eqn' == 0 {
				di as err "{p}option "               ///
				 "{bf:derivative(`derivative')} is " ///
				 "invalid; equation `equation' not found{p_end}"
				exit 303
			}
		}
	}
	local param : list retokenize param
	local deriv : list clean deriv
	sreturn local param "`param'"
	sreturn local eqn "`eqn'"
	sreturn local deriv `"`deriv'"'
end
