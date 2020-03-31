*! version 1.2.6  06sep2011
program define _virf_add
	version 8.0
	syntax , fromfile(string)	/*
		*/ [			/*
		*/ newfile(string)	/*
		*/ newirf(string) 	/* 
		*/ oldirf(string)  	/*
		*/ new 			/*
		*/ all			/*
		*/ ]
/* exact is undocumented 
 *  it implies that both old and newfilename are exact, no .vrf extension
 *  will be added
 */

	local 0 `"`fromfile'"'
	syntax anything(name=fromfile id="from irf file name") [, exact]
	local fromfile `fromfile'
	if "`exact'" != "" {
		local oexact exact
	}	

	if "`all'" == "" {
		local nirfs : word count `newirf'
		local oirfs : word count `oldirf'
		if `nirfs' == 0  | `oirfs' == 0 {
			di as err "internal irf error"
			di as err "newirf or oldirf list is empty "/*
				*/ "in _virf_add"
			exit 198
		}
		if `nirfs' != `oirfs' {
			di as err "internal varirf error"
			di as err "newirf and oldirf lists do not match "
				*/ " in _virf_add"
			exit 198
		}	
	}
	else {
		if "`newirf'`oldirf'" != "" {
			di as err "internal varirf error"
			di as err "all cannot be specified "/*
				*/ " with either newirf() or oldirf()"
			exit 198	
		}
	}

	if `"`newfile'"' == "" {
		local newfile `"$S_vrffile"'
	}
	else {
		local 0 `"`newfile'"'
		syntax anything(name=newfile id="new irf file name") [, exact]
		local newfile `newfile'
		if "`exact'" != "" {
			local nexact exact
		}	
		_virf_fck `"`newfile'"'	, `nexact'
		local newfile `"`r(fname)'"'
		if "`new'" != "" {
			_virf_mknewfile `"`newfile'"' , `nexact'
		}
	}

	_virf_fck `"`fromfile'"' , `oexact'
	local fromfile `"`r(fname)'"'

	qui preserve	

	use `"`newfile'"' ,clear
	local irfs_in_new : char _dta[irfnames]

	if "`all'" != "" {
		_virf_use `"`fromfile'"', `oexact'
		local irfs_in_old : char _dta[irfnames]
		CK_old_not_in_new , old(`irfs_in_old') new(`irfs_in_new') /*
			*/ newfile(`newfile')

		use `"`newfile'"', clear 
		append using `"`fromfile'"' 
		char _dta[irfnames] `irfs_in_new' `irfs_in_old'
		save `"`newfile'"', replace
		restore
		exit
	}

/* if here or below then all is empty and newirf and oldirf are 
 * 	specified and line up
 */
 
	tempfile t_file
/* 
 * note: use newirf in check because those are the names that
 *       will be used in new file
 */
	CK_old_not_in_new , old(`newirf') new(`irfs_in_new')	/*
		*/ newfile(`newfile')
	_virf_use `"`fromfile'"', irf(`oldirf') `oexact'

	local irfs2drop : char _dta[irfnames]

	foreach irf of local oldirf {
		local irfs2drop : subinstr local irfs2drop /*
			*/ "`irf'" "" , word
	}


	local dwords : word count `irfs2drop'
	if `dwords' > 0 {
		_virf_char , remove(`irfs2drop')
	}	
	foreach irfname of local irfs2drop {
		qui drop if irfname==`"`irfname'"'
		_virf_char , remove(`irfname')
	}

	local i 1
	foreach irf of local oldirf {
		local nirf : word `i' of `newirf'
		if "`irf'" != "`nirf'" {
			qui _virf_char , rename irf(`irf' `nirf') 
		}	
		local ++i
	}
	
	local addirfs : char _dta[irfnames]
	qui save `"`t_file'"', replace

	qui use `"`newfile'"', clear
	local irf_orig : char _dta[irfnames]
	
	qui append using `"`t_file'"'
	
	char _dta[irfnames] `irf_orig' `addirfs'	
	qui save `"`newfile'"', replace
	di as txt `"(file `newfile' updated)"'
	restore
end

program define CK_old_not_in_new 
	syntax , old(string) newfile(string) [ new(string) ]

	local irfs_in_old `old'
	local irfs_in_new `new'

	foreach irf of local irfs_in_old {
		local tmp : subinstr local irfs_in_new /*
			*/ "`irf'" "`irf'" , word count(local err)
		if `err' > 0 {
			di as err `"irfname `irf' is already in "'/*
				*/ `"`newfile'"'
			exit 198
		}	
	}
end
exit

syntax _virf_add , fromfile(ofile[,oexact]) 
	[ { { oldirf(irflist) newirf(irflist)} | all } 
	 newfile(nfile[,nexact])
	 exact 
	]
usage: 
	1) gets oldirf data and characteristics from fromfile
	2a) if all is specified then just append fromfile to file
		checking that each irfname in fromfile is not in new
		file
	2b) if oldirf() and newirf() are specified then they must
		have the same number of elements, this is checked in
                the file.  Also note, either they are both empty or 
		they are both specified.

		if newirf() and oldirf() are specified then foreach 
		irfname in _dta[irfnames] in fromfile
			if irfname is in oldirfname list 
				keep data and characteristics for irfname
				(optionally rename to corresponding newirfname)
		after loop append kept data and characteristics to newfile
		after checking that newirfnames are not already in new file.
		
        -oexact- and -nexact- options are undocumented.  They remove the
        check that the newfile have a ".vrf" extension from the new and old
	names respectively.


