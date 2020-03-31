*! version 1.1.0  30mar2018
   
program define _teffects_options, sclass
	version 13
	_on_colon_parse `0'
	local wh `s(before)'
	local 0, `s(after)'

	if "`wh'" == "ipw" {
		local psopt PSTOLerance(real 1e-5)
		local osample OSample(name)
	}
	syntax, [ from(passthru) NOLOg LOg ENSeparator verbose `force' ///
		`psopt' `osample' * ]

	/* undocumented options:					*/
	/* 	verbose 	- detailed display			*/
	/* 	force		- drop observations that fail overlap	*/

	if "`pstolerance'" != "" {
		if `pstolerance'<0 | `pstolerance'>=1 {
			di as err "{p}{bf:pstolerance()} must be greater " ///
			 "than or equal to 0 and less than 1{p_end}"
			exit 198
		}
		local epscd epscd(`pstolerance')
	}
	if "`osample'" != "" {
		cap confirm variable `osample'
		if !c(rc) {
			di as err "{p}invalid option "              ///
			 "{bf:osample({it:newvarname})}; variable " ///
			 "{bf:`osample'} already exists{p_end}"
			exit 110
		}
		local osopt osample(`osample')
	}

	local teopts "`from' `log' `nolog'"
	local teopts "`teopts' `enseparator' `verbose' `epscd' `osopt'"

	sreturn local teopts "`teopts'"
	sreturn local rest `"`options'"'
end

exit
