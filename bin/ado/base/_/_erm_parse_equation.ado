*! version 1.0.0  11may2017
program _erm_parse_equation, sclass
	version 15
	syntax, EQuation(string)	///
		FNEQuation(string)	///		
		NEQuation(string) 	///
		NDepvar(string)		///
		NINDepvars(string) 	///
		[SEXTraopts(string)	///	
		EXtraopts(string)	///
		plural]
	// error macro for potential later use
	local es "{p 0 4 2}invalid specification of {bf:`nequation'()}; "
	local esl "invalid specification of {bf:`nequation'()}; "
	gettoken depvar rest:  equation, parse("=,")
	capture fvexpand `depvar'
	if (_rc) {
		di as error `"`esl'"'
		fvexpand `depvar'
	}
	local throughlist `r(varlist)'
	local l: word count `throughlist'
	foreach lname of local throughlist {
	        _ms_parse_parts `lname'
	        if inlist("`r(type)'", "factor") {
			di as error `"`es'"'
			if "`plural'" != "" {
				di as err "`ndepvar' cannot contain a "	///
					"factor variable{p_end}" 		
				exit 198
			}
			else if "`plural'" == "" {
				di as err "`ndepvar' cannot be a " ///
					"factor variable{p_end}" 		
				exit 198
			}
		}
		else if inlist("`r(type)'", "interaction")	{
			di as error `"`es'"'
			if "`plural'" != "" {
				di as err "`ndepvar' cannot contain an " ///
					"interaction{p_end}" 			
		                exit 198
			}
			else if "`plural'" == "" {
				di as error "`ndepvar' cannot be an "	///
					"interaction{p_end}" 			
				exit 198
			}
		}
		if `l' > 1 & "`plural'" == "" {
			di as error `"`es'"'
			di as error `"only one `ndepvar' is allowed{p_end}"'
			exit 198
		}
	}

	foreach word of local depvar {
		tempvar testnum
		capture gen double `testnum' = `word' 
		if (_rc) {
			di as error `"`es'"'
			di as error  ///
			"`ndepvar' must be numeric{p_end}"
			exit 198
		}
	}
	fvexpand `depvar'
	local depvar `r(varlist)'	
	gettoken eqs rest: rest, parse(" =,")
	if ("`eqs'" == ",") {
		local 0, `rest'
	}
	else {
		if ("`eqs'" != "=") {
			if (!("`rest'" == "" & "`eqs'" == "")) {
				di as error `"`es'"'
				if length("`eqs'") > 0 {
					di as error 		///
					"`eqs' invalid in `fnequation'"	///
					" equation "			///
					"specification{p_end}"
				}
				exit 198
			}
			else {
				local 0, `rest'
			}
		}
		else {
			local 0 `"`rest'"'
			capture syntax anything, [ * ]
			if !_rc {
				local indepvars `anything' 
				local 0 , `options'
			}
		}		
	}
	if ("`sextraopts'" != "") {
		local b = ltrim(rtrim("`sextraopts'"))
		local b = subinstr("`b'"," ", "(string) ",.)
		local b `b'(string)
	}
	local a syntax, 			///
		[noCONstant			///
		EXPosure(varname numeric ts) 	///
		OFFset(varname numeric ts)   	///
		`b' `extraopts']
	capture `a'
	if (_rc) {
		di as error `"`esl'"'
		`a'
		exit 198
	}
	if ("`exposure'" != "" & "`offset'" != "") {
		di as error `"`esl'"'
		opts_exclusive "exposure() offset()"
	}
	sreturn local depvar `depvar'
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
		if usubstr("`lname'",1,2) == "no" {
			local lc = lower(usubstr(	///
				"`lname'",3,ustrlen("`lname'")))
			sreturn local `lc' ``lc''
		}
		else {
			local lc = lower("`lname'")
			sreturn local `lc' ``lc''
		}
	}
end
exit
