*! version 1.0.2  08jul2004
program define varirf_drop, rclass
	version 8
	syntax	anything(name=irf_list id="varirf name list") 		/*
	*/	[,							/*
	*/ 	set(string)						/*
	*/	 noCHECK ]				/* do not document
	*/

	local irf `irf_list'

	if `"`set'"' != "" {
		varirf set `set'
	}

	preserve
	local irf_file `"$S_vrffile"'
	
	qui describe using `"`irf_file'"'
	if r(N) == 0 {
		di as err `"there are no observations $S_vrffile"'
		exit 198
	}	
	_virf_use `"`irf_file'"' , irf(`irf') `check'
	local irflist  `r(irflist)'
	local irfnames `r(irfnames)'

	_virf_char , remove(`irflist')
	foreach irfname of local irflist {
		qui drop if irfname==`"`irfname'"'
		di as txt "(`irfname' dropped)"
	}
	qui save `"`irf_file'"', replace
	di as txt `"file `irf_file' updated"'
	return local dropped `irflist'
	restore
end

exit

syntax [<varirf_name_list>] , 
	[ set(cmd)
	 noCHECK ]

usage: 
	varirf works on the currently active varirf file

	foreach irf name in irf_list
	varirf_drop removes 
		i)  the data for that irf 
		ii) the characteristics that correspond to that irf
	from the requested irf_file.

	Specifying set(cmd) make the specified file the active varirf file.
	varirf drop operates on this newly activated varirf file and it
	remains the active varirf file when varirf_drop is done. 

