*! version 1.2.5  08jul2004
program define varirf_set, rclass
	version 8
	syntax [anything(name=filename id="irf filename")] /*
		*/[,		/*
		*/ New		/* 	undocumented
		*/ replace 	/*
		*/ clear 	/*
		*/ QUIetly	/* 	undocumented
		*/ ]
		
	if "`quietly'" == "" {
		local loud loud
	}
	else {
		local loud 
	}
	
	local filename `filename'

	if `"`filename'"' == "" & "`replace'" != "" {
		di as err "an irf filename must be specified when"/*
			*/ " replace is specified"
		exit 198
	}	

	if "`clear'" != "" & `"`filename'`replace'"' != "" {
		di as err "clear must be specified by itself" 
		exit 198
	}	
	if "`clear'" != "" {
		global S_vrffile ""
		di as txt `"irf file has been cleared"'
		exit
	}	
	if `"`filename'"' == "" {
		if `"$S_vrffile"' == "" {
			di as txt "no irf file active"
			exit
		}	
		cap confirm file `"$S_vrffile"'
		if _rc > 0 {
di as err `"file $S_vrffile is active but $S_vrffile can no longer be found"'
			exit
		}	
		return local irffile $S_vrffile
		di as txt `"(file $S_vrffile now active)"'
		exit
	}

/* anything passes in string asis, so any quotes are still on
	use local assignment to strip them off
 */

 	local filename `filename'
	local fnorig `"`filename'"'
	
	_virf_fck `"`filename'"'
	local filename `"`r(fname)'"'


	if "`replace'" != "" {
		preserve
		_virf_mknewfile `"`filename'"' , `replace' `loud' 
		restore
	}
	else {
		if "`new'" != "" {
			capture confirm new file `"`filename'"'
			preserve
			_virf_mknewfile `"`filename'"' , `loud'
			restore
		}
		else {
			capture confirm file `"`filename'"'
			if _rc == 601 {
// here because could not find filename with .irf extension
// now look for filename with .vrf extension for backward compatibility
// if filename with .vrf extension is not found create new file with .irf
// extension
				_virf_fck `"`fnorig'"' , vrf
				local filenamevrf `"`r(fname)'"'

				capture confirm file `"`filenamevrf'"'
				local rc = _rc
				if `rc' == 601 {
					preserve
					_virf_mknewfile `"`filename'"' , `loud' 
					restore
				}
				else if `rc' == 0 {
					local filename `"`filenamevrf'"'
				}
				else {
// should never be here, but exit cleanly
					di as err `"error looking  "	///
						"for `filenamevrf'"'
					exit `rc'
				}
			}
		}	
		else {
			error _rc
		}
	}

	global S_vrffile `"`filename'"'
	return local irffile $S_vrffile
	di as txt `"(file $S_vrffile now active)"'
end

exit

