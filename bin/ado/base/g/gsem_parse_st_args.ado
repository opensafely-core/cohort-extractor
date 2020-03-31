*! version 1.1.0  22mar2017
program gsem_parse_st_args, sclass
	version 14

	local OPTS	FAILure(passthru)	///
			LTruncated(passthru)	///
			PH			///
			AFT
	capture noi syntax name(id=family name=family) [, `OPTS']
	if c(rc) {
		di as err "option family() invalid;"
		syntax name(id=family name=family) [, `OPTS']
		exit 198	// [sic]
	}
	if "`family'" == "exponential" {
		local PARM	ph		/// default
				aft		///
						 // blank
	}
	else if "`family'" == "gamma" {
		local PARM	aft		/// default
						 // blank
	}
	else if "`family'" == "weibull" {
		local PARM	ph		/// default
				aft		///
						 // blank
	}
	else if "`family'" == "lognormal" {
		local PARM	aft		/// default
						 // blank
	}
	else if "`family'" == "loglogistic" {
		local PARM	aft		/// default
						 // blank
	}

	local parm `ph' `aft'
	local rest : list parm - PARM
	if `: list sizeof rest' {
		gettoken parm : rest
		di as err	///
"suboption `parm' is not allowed with family `family'"
		exit 198
	}
	opts_exclusive "`parm'" "family()"

	if "`parm'" == "" {
		gettoken parm : PARM
	}

	parseit, `failure' `ltruncated'
	sreturn local fargs `s(fargs)' `parm'
end

program parseit, sclass
	local OPTS	failure(string)		///
			LTruncated(string)
	capture syntax [, `OPTS']
	if c(rc) {
		di as err "option family() invalid;"
		syntax [, `OPTS']
		exit 198	// [sic]
	}
	CheckNumVar failure `failure'
	if "`failure'" != "" {
		local fargs failure(`failure')
	}
	if "`ltruncated'" != "" {
		capture confirm number `ltruncated'
		if c(rc) {
			CheckNumVar ltruncated `ltruncated'
		}
		local fargs `fargs' ltruncated(`ltruncated')
	}
	sreturn local failure `failure'
	sreturn local ltruncated `ltruncated'
	sreturn local fargs `fargs'
end

program CheckNumVar
	args name spec

	local 0 `", `name'(`spec')"'
	capture syntax [, `name'(varname numeric)]
	if c(rc) {
		di as err "option family() invalid;"
		syntax [, `name'(varname numeric)]
		exit 198	// [sic]
	}
	c_local `name' `"``name''"'
end

exit
