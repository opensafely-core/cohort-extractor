*! version 1.0.4  14mar2017

/*
	dtaversion  <filename>

            If <filename> .dta file of recognized version:
	        Displays dta file-format version and return version 
	        in scalar r(version).

            otherwise, 
		issues not-Stata-format error message, r(610)
	---------------------------------------------------------------

	TO UPDATE THIS FILE FOR NEWER VERSION OF STATA:

		1. There is nothing to do assuming the dta format 
		   has not changed.  This program updates itself.

	---------------------------------------------------------------

	WHEN A NEW DTA FORMAT IS IMPLEMENTED, do the following

		1.  Update program stataversionmsg below
		    to include the new .dta format number.
		    Search for "LAST MESSAGE".

		2.  Follow generic instructions for modifying 
		    other files in dtaverify.ado.

	---------------------------------------------------------------
*/

program dtaversion, rclass
	version 13
	local 0 `"using `0'"'
	syntax using/
	confirm file `"`using'"'
	mata: version_of_dta_file("version", `"`using'"')
	return scalar version = `version'
	message `"`using'"' `version'
end

program message 
	args filename version 

	di as txt "{p 2 3 2}"
	di as txt "(file {bf}"
	di as txt `""`filename'""'
	di as txt "{rm} is .dta-format `version'"
	stataversionmsg `version'
	di as txt "{p_end}"
end

program stataversionmsg 
	args version

	if (`version'==102) {
		di as txt "from Stata 1)"
		exit
	}
	if (`version'==103) {
		di as txt "from Stata 2 or 3)"
		exit
	}
	if (`version'==104) {
		di as txt "from Stata 4)"
		exit
	}
	if (`version'==105) {
		di as txt "from Stata 5)"
		exit
	}
	if (`version'==106 | `version'==107) {
		di as txt "from a never-released interim format"
		di as txt "during the development of Stata 6)"
		exit
	}
	if (`version'==108) {
		di as txt "from Stata 6)"
		exit
	}
	if (`version'==109) {
		di as txt "from a never-released interim format"
		di as txt "during the development of Stata 7)"
		exit
	}
	if (`version'==110 | `version'==111) {
		di as txt "from Stata 7)"
		exit
	}
	if (`version'==112 | `version'==113) {
		di as txt "from Stata 8 or 9)"
		exit
	}
	if (`version'==114) {
		di as txt "from Stata 10 or 11)"
		exit
	}
	if (`version'==115) {
		di as txt "from Stata 12)"
		exit
	}
	if (`version'==116) {
		di as txt "from a never-released interim format"
		di as txt "during the development of Stata 13)"
		exit
	}
	if (`version'==117) {
		di as txt "from Stata 13)"
		exit
	}

	/* LAST MESSAGES */
	if (`version'==118) {
		makereleaselist list : 14
		di as txt "from Stata `list')"
		exit
	}

	if (`version'==119) {
		makereleaselist list : 15
		di as txt "from Stata `list')"
		exit
	}

	di as txt "from a Stata after Stata `=c(stata_version)')"
end


program makereleaselist
	args macname colon intro_rel

	local cur_rel = floor(c(stata_version))

	if (`intro_rel'==`cur_rel') {
		c_local `macname' `cur_rel'
		exit
	}

	if (`intro_rel'==`cur_rel'-1) {
		c_local `macname' "`intro_rel' or `cur_rel'"
		exit
	}

	local intro_rel_p1 = `intro_rel' + 1
	local cur_rel_m1   = `cur_rel'   - 1

	local toret `intro_rel'
	forvalues i=`intro_rel_p1'(1)`cur_rel_m1' {
		local toret "`toret', `i'"
	}
	local toret "`toret', or `cur_rel'"

	c_local `macname' "`toret'"
end
	
/* -------------------------------------------------------------------- */
				/* Standard types			*/

local SS		string scalar
local SC		string colvector
local SM		string matrix
local RS		real scalar 
local RC		real colvector
local RM		real matrix

local FildesS 		`RS'		/* File Descriptor	*/
local RetcodeS		`RS'		/* Return code		*/
local ExtRetcodeS	`RetcodeS'	/* Extended return code	*/
local ErrcodeS		`RetcodeS'	/* Error code		*/

local boolean	real
local booleanS	`boolean' scalar
local True	1
local False	0

/* 
   StataCorp jargon:

	A Retcode is a Stata return code.  If a routine returns a
	    Retcode, then the routine displays the error message. 

	An Errcode is a Stata return code.  If a routine returns an 
           Errcode, then the error message has *NOT* been displayed.
*/

mata:

/* -------------------------------------------------------------------- */
					/* Entry point			*/
/*
	entry point opens and closes the file
*/

void version_of_dta_file(`SS' macroname, `SS' filename)
{
	`RetcodeS'	rc
	`FildesS'	h
	`RS'		fmtno

	pragma unset fmtno

	h  = fopen(filename, "r") 
	rc = diagnosefile(fmtno, h, filename)
	fclose(h) 
	if (rc) {
		exit(rc)
	}

	st_local(macroname, strofreal(fmtno))
}


`RetcodeS' diagnosefile(`RS' fmtno, `FiledesS' h, `SS' fn)
{
	if (diagnose_117_(   fmtno, h)) return(0) 

	fseek(h, 0, -1) 
	if (diagnose_103_115(fmtno, h)) return(0) 

	fseek(h, 0, -1) 
	if (diagnose_102(    fmtno, h)) return(0) 

	errprintf("file not Stata .dta file or ...\n") 
	errprintf("{p 4 4 2}\n")
	errprintf("File %s\n", fn) 
	errprintf("is not a known .dta-file format.\n") 
	errprintf("The file {it:might} be\n")
	errprintf("a horribly corrupted .dta file, but\n")
	errprintf("the most likely explanation is simply that\n") 
	errprintf("the file is not a .dta file.\n")
	errprintf("{p_end}\n")

	return(610)
}

`booleanS' diagnose_117_(`RS' fmtno, `FildesS' h)
{
	`SS'	fmtno_str

	if (!f_confirm_str(h, "<stata_dta>")) return(`False') 
	if (!f_confirm_str(h, "<header>")   ) return(`False') 
	if (!f_confirm_str(h, "<release>")  ) return(`False') 

	fmtno_str = fread(h, 3) 
	if (strlen(fmtno_str)!=3) return(`False')

	if ( (fmtno = strtoreal(fmtno_str)) != .) {
		if (fmtno < 116 /*sic*/)            return(`False')
		if (f_confirm_str(h, "</release>")) return(`True') 
	}
	return(`False')
}


`booleanS' diagnose_103_115(`RS' fmtno, `FildesS' h)
{
	`RS'	border, ftype

	pragma unset border
	pragma unset ftype

	if (!read_one_byte(fmtno, h)) return(`False')
	if (!read_one_byte(border,h)) return(`False') 
	if (!read_one_byte(ftype, h)) return(`False') 

	return( ( fmtno >=103 &  fmtno <=116) & 
	        (border ==  1 | border ==  2) &
                (ftype  ==  1)                   )
}

`booleanS' diagnose_102(`RS' fmtno, `FildesS' h)
{
	`RS'	ftype, zero1, zero2

	pragma unset ftype
	pragma unset zero1
	pragma unset zero2

	if (!read_one_byte(fmtno, h)) return(`False')
	if (!read_one_byte(zero1, h)) return(`False')
	if (!read_one_byte(ftype, h)) return(`False')
	if (!read_one_byte(zero2, h)) return(`False')
	
	return(  fmtno==102 & ftype==1 & zero1==0 & zero2==0 )
}



`booleanS' f_confirm_str(`FildesS' h, `SS' expected)
{
	`RS'		len 

	if (!(len=strlen(expected))) return(`True') 
	return( (fread(h, len)==expected) )
}


`booleanS' read_one_byte(`RS' v, `Fildes' h)
{
	`SS'	c

	if (strlen(c = fread(h, 1)) == 1) {
		v = ascii(c)
		return(`True')
	}
	return(`False')
}

end
