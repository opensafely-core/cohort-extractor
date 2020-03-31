*! version 1.0.2  19jan2010

/*
	u_mi_get_flongsep_tmpname <macname> : <basename>

	Create temporary flongsep name from basename, store in 
	local <macname>.

	Typical use:

		u_mi_get_flongsep_tmpname master : __mimaster

	It is recommended that <basename> begin with the characters 
	__mi (two underscores followed by mi).

	Note, before creation of file, you must go into -capture- and
        - nobreak-, and you must use 
        -mata: u_mi_flongsep_erase("`<macname>'",0,0)- to erase:

		...
		u_mi_get_flongsep_tmpname master : __mimaster
		capture {
			...
		}
		nobreak {
			local rc = _rc 
			mata: u_miflongsep_erase("`master'", 0, 0)
			if (_rc) {
				exit `rc'
			}
		}
		...
*/

program u_mi_get_flongsep_tmpname 
	version 11

	args name colon  basename 
	local i 1
	while (1) {
		capture confirm new file "`basename'`i'.dta"
		if (_rc==0) {
			c_local `name' `basename'`i'
			exit
		}
		local ++i
		if (`i'>200) {
			di as err "{p 0 0 2}"
			di as err ///
		"could not find a filename for temporary flongsep file"
			di as err "{p_end}"
			di as err "{p 4 4 2}"
			di as err ///
			"I tried `basename'1.dta through `basename'200.dta."
			di as err "Perhaps you do not have write permission"
			di as err "in the current directory.  This may occur,"
			di as err "for example, if you started Stata by"
			di as err "clicking directly on the Stata executable"
			di as err "on a network drive.  You should make sure"
			di as err "you have write permission for the"
			di as err "current directory or use {helpb cd} to"
			di as err "change to a directory that has write"
			di as err "permission.  Use {helpb pwd}"
			di as err "to determine your current directory."
			di as err "{p_end}"
			exit 603
		}
	}
	/*NOTREACHED*/
end
