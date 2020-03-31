*! version 1.0.1  06mar2019

/*
    frlink rebuild <varname> [, frame(<frname2>) makeerror

    Option -makeerror- is used in testing -frlink rebuild-. 

    Saved results:
	same as -frlink {1:1|m:1} ...
*/

program frlink_rebuild
	version 16

	/* ------------------------------------------------------------ */
					// parse

	syntax varname [, FRAME(string) MAKEERROR ]

	frlink__var `varlist' 		// verify <varname> frlink var


	if (`"`frame'"' != "") { 	// verify frame() exists if specified
		frame `c(frame)': cwf `frame'
	}

	/* ------------------------------------------------------------ */
					// obtain command

	frlink__cmd cmd : `varlist' debug `frame'
	if ("`makeerror'" != "") {
		local cmd `cmd' bad
	}

	/* ------------------------------------------------------------ */
					// execute command

	tempvar hold
	capture noisily {
		rename `varlist' `hold' 
		di as txt
		di as txt "rebuilding variable {bf:`varlist'}; executing"
		di as txt "{hline}"
		di as txt "-> " as res `"`cmd'"'
		`cmd'
	}
	nobreak {
		if (_rc) {
			local rc = _rc
			di in txt "r(`rc');"
			di as txt "{hline}"
			rename `hold' `varlist'
			di as err "{bf:frlink} could not rebuild variable {bf:`varlist'}"
			di as err "{p 4 4 2}"
			di as err "{bf:frlink} output is shown above."
			di as err "Variable {it:`varlist'} restored to its"
			di as err "original content just as if you had"
			di as err "never tried to rebuild it."
			di as err "{p_end}"
		}
		else {
			di as txt "{hline}"
			di as txt "{p 0 0 2}"
			di as txt "variable {bf:`varlist'} successfully"
			if ("`frame'"!="") {
				di as txt "rebuilt; it now links to"
				di as txt "frame {bf:`frame'}"
			}
			else {
				di as txt "rebuilt"
			}
			di as txt "{p_end}"
		}
	}
	exit `rc'
end
