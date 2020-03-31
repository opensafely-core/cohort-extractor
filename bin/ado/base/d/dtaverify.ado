*! version 1.0.2  14mar2017

/*								
	---------------------------------------------------------------
	dtaverify <filename>

	    returns
		0.  file is identifiable and verified 

		6.  file is identifiable but cannot be verified (no code)

              198.  syntax error

	      459.  file is identifiable, does not pass verification.

	      601.  file does not exist

	      610.  file is not identifiable 
	---------------------------------------------------------------

	Verification is performed by external commands named 
	dtaverify_<###>.ado.  Syntax is

		dtaverify_<###> <filename>

	These commands must return r(198) when called without arguments.
	---------------------------------------------------------------

	WHEN A NEW RELEASE OF STATA IS IMPLEMENTED, 

		1.  There is nothing to do, assuming that there is
		    no new .dta format.
		

	---------------------------------------------------------------

	WHEN A NEW DTA FORMAT IS IMPLEMENTED, do the following:

		1.  write dtaverify_<###>.ado.
		    Start by copying dtaverify_<###-1>.ado and
		    then modify that.

	        2.  Modify definition of local CURRENT_DTA_FMT 
		    in this file.

		3.  Modify dtaversion.ado to include 
		    the new format number.

	---------------------------------------------------------------

	Concerning testing of -dtaverify-, full syntax is 

		dtaverify <filename> [, {debugoldmsg|debugnewmsg}]

	    -debugoldmsg- shows the error message that -dtaverify- would 
	    show if asked to test a file that is too old. 

	    -debugnewmsg- shows the error message that -dtaverify- would
	    show if asked to test a file that is too new.
*/


program dtaverify
	version 13

	local CURRENT_DTA_FMT 119

	/* ------------------------------------------------------------ */
						/* parse		*/

	local 0 `"using `0'"'
	syntax using/ [, debugoldmsg debugnewmsg]
	confirm file `"`using'"'

	dtaversion `"`using'"'
	local ver = r(version)

	/* ------------------------------------------------------------ */
						/* test options		*/
	if ("`debugoldmsg'"!="") {
		cantverify 100
		/*NOTREACHED*/
	}
	else if ("`debugnewmsg'"!="") {
		cantverify 999 `CURRENT_DTA_FMT'
		/*NOTREACHED*/
	}

	/* ------------------------------------------------------------ */


	capture dtaverify_`ver' 
	if (_rc==198) {
		dtaverify_`ver' `"`using'"'
	}
	else {
		cantverify `ver' `CURRENT_DTA_FMT'
		/*NOTREACHED*/
	}
end


program cantverify
	args ver current_ver

	di as err "cannot verify .dta format-`ver' files"
	di as err "{p 4 4 2}"
	di as err "{bf:dtaverify} does not have a verifier for"
	di as err "format-`ver' files."

	if (`ver'<117) {		/* 117 never changes */
		cantverify_old 
	}
	else {
		cantverify_new `ver' `current_ver'
	}
	exit 6
end

program cantverify_old
	di as err "If you are concerned that this older file"
	di as err "might be corrupted, do the following:"
	di as err
	di as err "{p 8 12 2}"
	di as err "1.  Close Stata and relaunch."
	di as err "{p_end}"
	di as err "{p 8 12 2}"
	di as err "2.  {bf:use} the dataset and {bf:save} it under"
	di as err "a different name."
	di as err "{p_end}"
	di as err "{p 8 12 2}"
	di as err "3.  Close Stata and relaunch."
	di as err "{p_end}"
	di as err "{p 8 12 2}"
	di as err "4.  {bf:dtaverify} the file just saved."
	di as err "{p_end}"
	di as err
	di as err "{p 4 4 2}"
	di as err "If {bf:dtaverify} reports errors, then the original"
	di as err "file is corrupt."
	di as err
	di as err "{p 4 4 2}"
	di as err "Otherwise, you now know the new file is technically valid."
	di as err "That implies that the old file is probably valid,"
	di as err "but that is not certain."
	di as err "Since you were worried, 
	di as err "use the new file from now on, and first, review"
	di as err "the contents carefully."
	di as err "{p_end}"
end

program cantverify_new
	args ver current_ver

	di as err "Format `current_ver' is the current data format"
	di as err "for Stata `=c(stata_version)'."
	di as err "Format `ver' must have come afterwards."
	di as err "To read this file, you must {bf:{help update}}"
	di as err `"or {browse "http://www.stata.com":upgrade}"'
	di as err "your copy of Stata."
	di as err "{p_end}"
end

