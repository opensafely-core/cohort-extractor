*! version 1.0.0  22sep2008
/* used by -ir-, -cc-, -cs-, and -mhodds- to parse the -by()- option */
program _epitab_by_parse, sclass
	version 11.0
	syntax [varlist(default=none)] [, MISsing ]
	local by `varlist'
	if ("`by'"=="" & "`missing'" != "") {
		di in smcl as err "suboption {cmd:missing} requires "	///
				  "variable name in {cmd:by()}"
		exit 198
	}
	sret local by `by'
	sret local missing `missing'
end
