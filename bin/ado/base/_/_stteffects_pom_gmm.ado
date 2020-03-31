*! version 1.0.0  22dec2014

program define _stteffects_pom_gmm, sclass
	version 14.0
	syntax, stripe(string) levels(string) stat(string) [ control(string) ]

	/* assumption: klev = 2 					*/
	local klev : list sizeof levels

	/* doctor up POM stripe names, not valid in ms functions	*/
	local str0 `stripe'
	if "`stat'" == "pomeans" {
		forvalues j=1/`klev' {
			local lev : word `j' of `levels'

			gettoken expr str0 : str0, bind
			local eqvar  POmean`lev'
			local str1 `"`str1' `eqvar':_cons"'

			local meqs `"`meqs' `eqvar'"'
			local param `"`param' {`eqvar'}"'
		}
		local meqs : list retokenize meqs
	}
	else {
		if "`control'" == "" {
			/* programmer error				*/
			di "{bf:control()} required for statistic `stat'"
			exit 198
		}
		local STAT = strupper("`stat'")
		forvalues j=1/`klev' {
			gettoken expr str0 : str0, bind
			
			local lev : word `j' of `levels'
			if `lev' == `control' {
				continue
			}
			local eq `STAT'`lev'
			local meqs "`meqs' `eq'"
			local param "`param' {`eq'}"
			local str1 "`str1' `eq':_cons"
		}
		local eq POmean`control'
		local meqs "`meqs' `eq'"
		local param "`param' {`eq'}"
		local str1 "`str1' `eq':_cons"
	}
	sreturn local stripe `"`str1' `str0'"'
	sreturn local eqs `"`meqs'"'
	sreturn local param `"`param'"'
end

exit
