*! version 1.0.0  03jan2005
program _prefix_checkopt, sclass
	version 9
	gettoken SPEC 0 : 0, parse(",")

	sreturn clear
	if (`"`SPEC'"' == ",") {
		local SPEC
		local 0 `", `0'"'
	}

	syntax [, `SPEC' * ]
	while `"`:list retok SPEC'"' != "" {
		gettoken NAME SPEC : SPEC, parse(" ()") match(PAR) bind
		if "`NAME'" != "" & "`PAR'" == "" {
			local NAME = lower("`NAME'")
			sreturn local `NAME' `"``NAME''"'
		}
	}
	sreturn local options `"`:list retok options'"'
end
exit
