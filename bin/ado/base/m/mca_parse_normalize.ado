*! version 1.0.1  01feb2012
program mca_parse_normalize, sclass
	version 9
	args arg

/* NOTE: we document norm(st) and norm(pr) as minimal abbreviations to
agree with -ca- even though norm(s) and norm(p) are permissible */
	local 0, `arg'
	capt syntax [, Standard Principal] 
	if _rc {
		dis as err `"normalize() invalid: `arg' not allowed"'
		exit 198
	}
	
	local opt `standard' `principal'
	if "`opt'" == "" {
		local opt standard
	}
	else if `:list sizeof opt' > 1 {
		dis as err "normalize() invalid: " ///
		           "standard and principal are exclusive"
		exit 198
	}

	sreturn clear
	sreturn local norm `opt'
end
exit

