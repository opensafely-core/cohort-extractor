*! version 1.0.1  21jun2017

program define menl_validate_relevel, sclass
	syntax, [ relevel(string) ]

	sreturn clear

	if "`e(cmd)'" != "menl" {
		return(301)
	}
	local relevel0 `relevel'
	local pathspec = 0
	if "`relevel'" != "" {
		mata: menl_parse_path("`relevel'")
		local rc = `s(rc)'
		if `rc' {
			di as err "{p}invalid {bf:relevel(`relevel0')} " ///
			 "specification: `s(errmsg)'{p_end}"
			exit `rc'
		}
		local repath `s(path)'		// canonical form
		local krel = `s(klevel)'
		local relevel `s(level`krel')'	// bottom level
		local krevar =  `s(kvar)'
		local ivars `e(ivars)'	// path index variables used in model
		forvalues i=1/`krevar' {
			local revar `s(var`i')'
			local k :list posof `"`revar'"' in local ivars
			if !`k' {
				di as err "{p}invalid "                     ///
				 "{bf:relevel(`relevel')} specification; " ///
				 "variable {bf:`revar'} is not a level-"   ///
				 "index variable in this model{p_end}"
				exit 198
			}
		}
		local pathspec = ("`repath'"!="`relevel'")
	}
	/* Parse full hierarchy						*/
	menl_parse_ehierarchy
	local klev = `s(klevels)'
	if !`klev' {
		/* no hierarchy						*/
		sreturn local ilevel = 0
		sreturn local relevel
		sreturn local repath

		exit
	}
	forvalues i=1/`klev' {
		local path`i' `s(path`i')'
		local lvs`i' `s(lvs`i')'
		local klv`i' = `s(klv`i')'
		if "`repath'" == "`path`i''" {
			local ilev = `i'
		}
		else if !`pathspec' {
			/* can specify only the bottom level variable
			 *  of a path					*/
			mata: menl_parse_path("`path`i''") // adds to sreturn
			local kl = `s(klevel)'
			local level `s(level`kl')'
			if "`relevel'" == "`level'" {
				local ilev = `i'
				local repath `s(path)'		// full path
			}
		}
		if `i' > 1 {
			/* cumulative sum				*/
			sreturn local nlv`i' = `klv`i'' + `s(nlv`=`i'-1')'
		}
		else {
			sreturn local nlv`i' = `klv`i''
		}
	}
	if "`ilev'" == "" {
		if "`relevel0'" != "" {
			di as err "{p}invalid {bf:relevel(`relevel0')} " ///
			 "specification; path {bf:`repath'} not found{p_end}"
			exit 198
		}
		local ilev = `klev'
		mata: menl_parse_path("`path`klev'")	// adds to sreturn
		local kl = `s(klevel)'
		local relevel `s(level`kl')'
		local repath `path`klev''
	}
	sreturn local ilevel = `ilev'
	sreturn local relevel `relevel'
	sreturn local repath `repath'
end

exit
