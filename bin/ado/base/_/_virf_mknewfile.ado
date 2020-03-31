*! version 1.0.6  02dec2013
program define _virf_mknewfile 
	version 8.0
	syntax anything(id="new irf filename" name=fname) /*
		*/ [, replace exact loud ]
/* anything passes in strings asis, so any quotes are still on	
 *  the string in the macro
 * use local assignment to strip off quotes
 *
 * exact is undocumented it removes the automatic appending of 
 * 	".vrf" extension to irf files
 *
 */
 
 	preserve 

 	local fname `fname'
	_virf_fck `"`fname'"', `exact'
 	local fname `"`r(fname)'"'

	qui drop _all
	qui set obs 1
	qui gen double irf = 1
	qui label var irf  "impulse-response function (irf)"
	qui drop in 1
	char _dta[_signature] vrf
	char _dta[_version] 1.1
	qui save `"`fname'"', `replace'
	if "`loud'" != "" {
		di as txt `"(file `fname' created)"'
	}	
	restore
end
