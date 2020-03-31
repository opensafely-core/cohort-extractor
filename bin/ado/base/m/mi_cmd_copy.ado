*! version 1.0.0  09mar2009

/*
	mi copy <newname> [, replace syscall]

		replace: change to <newname> even if <newname> 
			 already exists

		syscall: called by system and we have already 
			 verified that the data are acceptable
*/

program mi_cmd_copy 
	version 11

	u_mi_assert_set

	gettoken name 0 : 0, parse(" ,[]()-")
	if ("`name'"=="," | "`name'"=="") { 
		di as err "nothing found where name expected"
		di as smcl as err "    syntax is {bf:mi copy} {it:name}"
		exit 198
	}
	confirm name `name'

	syntax [, REPLACE SYSCALL]


	/* ------------------------------------------------------------ */
					/* phase II, acceptable		*/

	if ("`syscall'"=="") {
		u_mi_certify_data, acceptable
	}

	if ("`_dta[_mi_style]'"!="flongsep") {
		if (`"`c(filename)'"' == "`name'.dta") { 
			di as txt ///
			"(`_dta[_mi_style]' data already named `name')"
			exit
		}
		local oldname `"`c(filename)'"'
		if (`"`oldname'"'!="") {
			mata: st_local("oldname", pathrmsuffix(pathbasename(`"`oldname'"')))
		}

		if ("`replace'"=="") {
			confirm new file `name'.dta
		}
		nobreak {
			mata: u_mi_flongsep_erase("`name'", 0, 0)
			qui save `name'.dta
		}
		di as txt as smcl "{p}"
		di as smcl as txt `"(`_dta[_mi_style]' data `oldname'"'
		di as smcl as txt "copied to `name'; you are now working"
		di as smcl as txt "with file `name'.dta)"
		di as smcl "{p_end}"
		exit
	}

	else {
		if ("`name'"=="`_dta[_mi_name]'") {
			di as txt "(flongsep data already named `name')"
			exit
		}

		if ("`replace'"=="") {
			confirm new file `name'.dta
		}
		mata: u_mi_flongsep_erase("`name'", 0, 0)


		local M      `_dta[_mi_M]'
		local oldname `_dta[_mi_name]'
		local files  `name'.dta
		preserve 
		nobreak {
			quietly {
				forvalues m=1(1)`M' {
					use _`m'_`oldname', clear 
					char _dta[_mi_name] `name'
					save _`m'_`name', replace
					local files `files' _`m'_`name'.dta
				}
				restore
				char _dta[_mi_name] `name'
				save `name', replace
			}
		}
	}

	local n : word count `files'
	local filesword = cond(`n'==1, "file", "files")

	di as txt as smcl "{p}"
	di as smcl `"(`oldname' copied to `name'; you are now working with"'
	di as smcl "`filesword' `files')"
	di as smcl "{p_end}"
end
