*! version 1.0.5  08jul2004
program define _virf_use, rclass
	version 8
	syntax	[anything]		/*
	*/	[,			/*
	*/	irf(string)		/*
	*/	impulse(string)		/*
	*/	response(string)	/*
	*/	noCHECK			/*
	*/	one			/*
	*/	exact			/* do not document 
	*/	]			/*
	*/
/* anything passes strings asis, use local assignment to strip off 
 * quotes
 *
 * exact suppresses automatic addition of ".vrf" extension
 */
	local anything `anything'

	if `"`anything'"' == "" {
		if `"$S_vrffile"' == "" {
			di as err "no active irf file, use irf set"
			exit 198
		}
		local vrffile `"$S_vrffile"' 
	}
	else {
		local vrffile `"`anything'"'
		_virf_fck `"`vrffile'"' , `exact'
		local vrffile `"`r(fname)'"'
	}

	if `"`one'"' == "" {
		qui use `"`vrffile'"' , clear
	}
	else {
		qui use in 1 using `"`vrffile'"' , clear 
	}	
	local allnames : char _dta[irfnames]
	capture noi {
		qui assert `"`allnames'"' != ""
		confirm string var irfname
		confirm string var response
		confirm string var impulse
		confirm numeric var irf
		confirm numeric var stdirf
		confirm numeric var cirf
		confirm numeric var stdcirf
		confirm numeric var oirf
		confirm numeric var stdoirf
		confirm numeric var coirf
		confirm numeric var stdcoirf
		confirm numeric var fevd
		confirm numeric var stdfevd
		confirm numeric var mse
		confirm numeric var step
		confirm numeric var sirf
		confirm numeric var stdsirf
		confirm numeric var sfevd
		confirm numeric var stdsfevd
	}
	if _rc {
		di as err `"file `vrffile' is not a valid irf file"'
		exit 198
	}
	if `"`check'"' == "" {
		if `"`irf'"' != "" {
			foreach name of local irf {
				local junk :				/*
				*/ subinstr loc allnames "`name'" "" ,	/*
				*/ all word count(local count)
				if `count' {
					local irflist `irflist' `name'
				}
				else {
					di as err /*
*/ `"`vrffile' does not contain `name'"'
					exit 198
				}
				local irfcnt = `irfcnt' + `count'
			}
			local count : word count `allnames'
			if `count' == `irfcnt' {
				local irflist `allnames'
			}
		}
		else	local irflist `allnames'

		local namelist `impulse' `response'
		foreach name of local namelist {
			count if response == "`name'"
			if r(N) == 0 {
				di as err "`name' is not a valid response"
				exit 198
			}
		}
	}
	else	local irflist `irf'

	return local filelist `vrffile'
	return local irflist  `irflist'
	return local irfnames `allnames'
end

exit

Usage:

  _virf_use [<vrffile>] [, irf(<namelist>) ]

By default, _virf_use, uses the active .irf or .vrf dataset set by -irf set-
and checks that it contains the required characteristics.  Optionally, it
uses the -irf- dataset identified by <vrffile>, and, optionally, checks that
<namelist> is a subset of the data characteristic _dta[irfnames].

<end>
