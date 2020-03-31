*! version 1.1.0  13feb2019

program define _pss_chk_init
	args which init m0 direction

	tempname val
	cap scalar `val' = `init'
	local rc = c(rc)
	if c(rc) {
		di as err "{p}invalid option {bf:init(`init')}; expected a number "
		exit 198
	}
	if ("`direction'"!="") local direction = usubstr("`direction'",1,1)
	if "`direction'" == "l" {
		if `val' >= `m0' {
			local extra "less "
			local extra2 "option {bf:direction(lower)}"
			local rc = 198
		}
	}
	else if `val' <= `m0' {
		local extra "greater"
		local rc = 198
		if "`direction'" != "" {
			local extra2 "option {bf:direction(upper)}"
		}
		else {
			local extra2 "the default direction upper"
		}
	}
	if (!`rc') exit

	di as err "{p}invalid option {bf:init(`init')}; the value must be " ///
	 "`extra' than the `which' with `extra2'{p_end}"
	exit `rc'
end
exit
