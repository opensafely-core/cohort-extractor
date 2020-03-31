*! version 1.0.2  08mar2003
program define gr_setscheme
	version 8
	args scheme
	syntax [ , SCHeme(string) COPYSCHeme REFSCHeme * ]

	if "`copyscheme'`refscheme'" != "" {
		if "`scheme'" == "" {
			if "`.`c(curscm)'.scheme_name'" != "`c(scheme)'" {
				local newscheme 1
			}
			else	local scheme `c(curscm)'
		}
		else if "`.`scheme'.classname'" != "scheme" {
			local newscheme 1
		}

		if ! 0`newscheme' {
			if "`refscheme'" != "" {
			    if "`.__SCHEME.objkey'" != "`.`scheme'.objkey'" {
				capture _cls free __SCHEME
				.__SCHEME = .`scheme'.ref
			    }
			}
			else	.__SCHEME = .`scheme'.copy
		}

	}
	else	local newscheme 1

	if 0`newscheme' {			/* a saved base scheme */
		capture _cls free __SCHEME
		if "`scheme'" == "" {
			if "`c(scheme)'" == "" {
				local scheme s2color
			}
			else	local scheme `c(scheme)'
		}
		.__SCHEME = .scheme.new, scheme(`scheme')
	}

	set curscm `.__SCHEME.objkey'

end
