*! version 1.0.0  13nov2016
program gsem_parse_poisson_args, sclass
	version 15

	local OPTS	LTruncated(passthru)
	capture syntax [, `OPTS']
	if c(rc) {
		di as err "option family() invalid;"
		di as err "invalid option for family gaussian"
		syntax [, `OPTS']
		exit 198	// [sic]
	}
	local fargs `ltruncated'
	local fargs : list retok fargs
	sreturn local fargs `fargs'

	parseit, `fargs'
end

program parseit, sclass
	local OPTS	LTruncated(string)
	capture syntax [, `OPTS']
	if c(rc) {
		di as err "option family() invalid;"
		syntax [, `OPTS']
		exit 198	// [sic]
	}
	if "`ltruncated'" != "" {
		capture confirm number `ltruncated'
		if c(rc) {
			CheckNumVar ltruncated `ltruncated'
		}
	}
	sreturn local ltruncated `ltruncated'
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
