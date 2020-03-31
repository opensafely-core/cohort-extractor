*! version 1.0.2  08feb2015 

/*
	This ado-file is suitable for use, unmodified, in Stata 13 
	and forward.
*/


local cmdname "dtaverify_115"
program `cmdname'
	version 13
	local 0 `"using `0'"'
	syntax using/
	confirm file `"`using'"'
	mata: verify_dta_file(`"`using'"')
end

/* -------------------------------------------------------------------- */
				/* Format 117 values			*/

local RELEASE		115
local MaxVarlabLen	80	/* sic */	/* excludes \0 */
local MaxNameLen	32	/* sic */	/* excludes \0 */
local MaxFmtLen		48	/* sic */	/* excludes \0 */
local MaxCharLen	67784			/* INCLUDES \0 */
local MaxVallabCntsLen	32001			/* INCLUDES \0 */
local MaxVar		32767			
local MaxObs 		2147483647
local MaxInt4		2147483647


local Vartype		real
local VartypeS		`Vartype' scalar
local VartypeC		`Vartype' colvector
local VT_strBOT		1
local VT_strTOP		244 
local VT_double		255
local VT_float		254
local VT_long		253
local VT_int		252
local VT_byte		251
				/* /Format 117 values			*/
/* -------------------------------------------------------------------- */

* The following is the return code for serious errors:
local SERIOUS		459

* return code 9 is used for warnings


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
	
/* -------------------------------------------------------------------- */
				/* Types unique to this program		*/


local FileinfoName	fileinfodf
local Fileinfo		struct `FileinfoName'
local FileinfoS		`Fileinfo' scalar

local FilecntsName	filecntsdf
local Filecnts		struct `FilecntsName'
local FilecntsS		`Filecnts' scalar

local HeaderName	headerdf
local Header		struct `HeaderName'
local HeaderS		`Header' scalar


mata:

/* -------------------------------------------------------------------- */
				/* type Fileinfo			*/
`Fileinfo' {
	`FildesS' 	h	/* open file descriptor		*/
	`SS'		fn	/* file name			*/
}

/* -------------------------------------------------------------------- */
				/* Type Filecnts			*/

/*
	Filecnts
		Header
*/

`Header' {
	`SS'	release
	`SS'	byteorder
}

`Filecnts' {
	`RS'		rel 		/* .dta file format 117	*/
	`RS'		bufbyteorder	/* 1=MSF 2=LSF 		*/
	`RS'		K		/* # of vars		*/
	`RS'		N		/* # of obs		*/
	`RC'		map		/* 14 x 1 		*/
	`SC'		varnames	/*  K x 1		*/
	`VartypeC'	vartypes	/*  K x 1 		*/
	`RM'		vo		/*  K x 2;  (v,o)	*/

	`HeaderS'	hdr

	/* ------------------------------------------------------------ */
					/* Postponed construction errors*/
	`booleanS'	warning		/* - poor construction found  	*/
	`booleanS'	serious		/* - invalid construction found */
	/* ------------------------------------------------------------ */
}

/* -------------------------------------------------------------------- */
					/* Entry point			*/
/*
	entry point opens and closes the file
*/

void verify_dta_file(`SS' filename)
{
	`FileinfoS'	fi
	`RetcodeS'	rc

	fi.fn = filename 
	fi.h  = fopen(fi.fn, "r") 

	rc = readfile(fi)

	fclose(fi.h) 
	if (rc) exit(rc) 
}


/* -------------------------------------------------------------------- */
					/* main driver			*/

/*
	rc = readfile(fi)

	File is open; check the file.
*/

`RetcodeS' readfile(`FileinfoS' fi) 
{
	`RetcodeS'	rc
	`FilecntsS'	fc 

	fc.warning = fc.serious = `False'

	/* ------------------------------------------------------------ */
					/* verify file			*/
	/* 
	   Individual routines called below
	   problems in any of the following ways:

		return(<nonzero>):
		    serious error; further file verification is not 
		    possible.

		return(0) and set fc.serious=`True':
		    serious error; even so, we can continue verification.

		return(0) and set fc.warning=`True':
		    Questionable (barely acceptable) construction found.

	*/

	if ((rc = read_header(     fi, fc))) return(cantcont(rc))
	if ((rc = read_vartypes(   fi, fc))) return(cantcont(rc))
	if ((rc = read_varnames(   fi, fc))) return(cantcont(rc))
	if ((rc = read_sortorder(  fi, fc))) return(cantcont(rc))
	if ((rc = read_formats(    fi, fc))) return(cantcont(rc))
	if ((rc = read_vallblnames(fi, fc))) return(cantcont(rc))
	if ((rc = read_varlabels(  fi, fc))) return(cantcont(rc))
	if ((rc = read_chars(      fi, fc))) return(cantcont(rc))
	if ((rc = read_data(       fi, fc))) return(cantcont(rc))

	if (!iseof(fi.h)) {
		if ((rc = read_vallabs(    fi, fc))) return(cantcont(rc))
		if (!iseof(fi.h)) {
			serious()
			errprintf("file continues after eof expected\n") 
			fc.serious = `True'
		}
	}


	/* ------------------------------------------------------------ */
					/* report result summary	*/
	if (fc.serious) {
		errprintf("\n")
		errprintf("serious errors detected\n") 
		errprintf("    See errors reported above.\n")
		return(`SERIOUS') 
	}
	if (fc.warning) {
		errprintf("\n")
		errprintf("warnings reported\n")
		errprintf("{p 4 4 2}\n")
		errprintf("This .dta file does not match protocol,\n") 
		errprintf("but it should be readable.\n")
		errprintf("{p_end}\n")
		return(9) 
	}
	printf("\n")
	printf("{txt}no errors or warnings above; .dta file valid\n") 
	return(0)
}


`RetcodeS' cantcont(`RetcodeS' rc) 
{
	errprintf("{p 4 4 2}\n")
	errprintf("Stopping; this error prevents continuing\n")
	errprintf("to check for other errors.\n") 
	errprintf("Serious errors detected\n") 
	errprintf("{p_end}\n")
	return(rc)
}

`booleanS' iseof(`FildesS' h)
{
	`SS'	pos 

	pos = ftell(h)
	if (_fread(h, 1)==J(0,0,"")) return(`True') 
	fseek(h, pos, -1) 
	return(`False')
}


/* -------------------------------------------------------------------- */
				/* 1. check header			*/

`RetcodeS' read_header(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc

	printf("\n")
	printf("{txt}{bf} 1. reading and verifying header{rm}\n") 

	if ((rc = read_header_release(fi, fc))) return(rc) 
	printf("{txt}    release is %f\n", fc.rel) 
	if (fc.rel != `RELEASE') return(err_msg("release not 115"))

	if ((rc = read_header_byteorder(fi, fc))) return(rc) 
	if ((rc = read_header_filetype( fi, fc))) return(rc) 
	if ((rc = read_header_unused(   fi, fc))) return(rc) 
	if ((rc = read_header_K(        fi, fc))) return(rc) 
	if ((rc = read_header_N(        fi, fc))) return(rc) 
	if ((rc = read_header_label(    fi, fc))) return(rc) 
	if ((rc = read_header_timestamp(fi, fc))) return(rc) 

	return(0) 
}

`RetcodeS' read_header_release(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc 
	`SS'		rel

	pragma unset rel
	if ((rc=fileread(rel, fi.h, 1))) return(rc)
	fc.hdr.release = strofreal(ascii(rel))
	fc.rel         = ascii(rel)
	return(0) 
}

`RetcodeS' read_header_byteorder(`FileinfoS' fi, `FilecntsS' fc)
{
	
	`RetcodeS'	rc 
	`SS'		bo 

	pragma unset bo
	if ((rc=fileread(bo, fi.h, 1))) return(rc) 
	if (     ascii(bo)==1) fc.hdr.byteorder = "MSF"
	else if (ascii(bo)==2) fc.hdr.byteorder = "LSF"
	else {
		serious()
		errprintf("byteorder invalid, value %f\n", ascii(bo)) 
		return(`SERIOUS') 
	}

	printf("{txt}    byteorder %g\n", ascii(bo)) 

	fc.bufbyteorder = (bo=="MSF" ? 1 : 2)

	return(0) 
}

`RetcodeS' read_header_filetype(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc 
	`SS'		ft

	pragma unused fc
	pragma unset ft
	if ((rc=fileread(ft, fi.h, 1))) return(rc)
	if ((ascii(ft)!=1)) {
		serious() 
		errprintf("filetype invalid, value %f\n", ascii(ft))
		return(`SERIOUS') 
	}
	return(0) 
}
	
`RetcodeS' read_header_unused(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc 
	`SS'		unused

	pragma unset unused
	if ((rc=fileread(unused, fi.h, 1))) return(rc)
	if ((ascii(unused)!=0)) {
		warning()
		errprintf("unused field invalid, value %f\n", ascii(unused))
		fc.warning = `True' 
	}
	return(0) 
}


`RetcodeS' read_header_K(`FileinfoS' fi, `FilecntsS' fc)
{
	
	`RetcodeS'	rc 
	`SS'		C
	`RS'		K

	C = bufio() 
	bufbyteorder(C, fc.bufbyteorder)
	pragma unset K
	if ((rc = filebufget(K, C, fi.h, "%2bu"))) return(rc) 

	printf("{txt}    K (# of vars) is %f\n", K)
	if (K>`MaxVar') return(err_msg("K>`MaxVar' invalid"))
	fc.K = K
	
	return(0) 
}

`RetcodeS' read_header_N(`FileinfoS' fi, `FilecntsS' fc)
{
	
	`RetcodeS'	rc 
	`SS'		C
	`RS'		N

	C = bufio() 
	bufbyteorder(C, fc.bufbyteorder)
	pragma unset N
	if ((rc = filebufget(N, C, fi.h, "%4bu"))) return(rc)
	printf("{txt}    N (# of obs) is %f\n", N)
	if (N>`MaxObs') return(err_msg("N>`MaxObs' invalid"))
	fc.N = N
	
	return(0) 
}

`RetcodeS' read_header_label(`FileinfoS' fi, `FilecntsS' fc)
{
	`RS'		lbllen, len
	`RetcodeS'	rc 
	`SS'		text

	lbllen = 81 /* bytes */

	pragma unset text
	if ((rc = fileread(text, fi.h, lbllen))) return(rc) 
	len = strpos(text, char(0))
	if (!len) {
		serious()
		errprintf("label not \0 terminated\n") 
		fc.serious = `True'
		len = 1
	}
	text = bsubstr(text, 1, len-1)
	printf("{txt}    label |%s|\n", text)

	return(0) 
}


`RetcodeS' read_header_timestamp(`FileinfoS' fi, `FilecntsS' fc)
{
	
	`RetcodeS'	rc 
	`SS'		text
	`RS'		l 


	pragma unset text
	if ((rc = fileread(text, fi.h, 18))) return(rc) 
	l = strpos(text, char(0))
	if (!l) {
		serious() 
		errprintf("timestamp not \0 terminated\n") 
		fc.serious = `True'
		l = 1
	}
	text = bsubstr(text, 1, l=l-1)
	printf("{txt}    date length %f |%s|\n", l, text)
	if (l!=0 && l!=17) {
		serious()
		errprintf("date length not 0 or 17\n") 
		fc.serious = `True'
	}
	return(0) 
}

				/* 1. check header			*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
				/* 2. Verify vartypes			*/
	
`RetcodeS' read_vartypes(`FileinfoS' fi, `FilecntsS' fc)
{
	`SS'		C
	`RetcodeS'	rc 
	`RS'		i
	`VartypeS'	vt
	`booleanS'	serious

		
	printf("\n") 
	printf("{txt}{bf: 2. reading and verifying vartypes}\n") 

	C = bufio()
	bufbyteorder(C, fc.bufbyteorder)

	serious     = `False'
	fc.vartypes = J(fc.K, 1, .)
	pragma unset vt
	for (i=1; i<=fc.K; i++) {
		if ((rc = filebufget(vt, C, fi.h, "%1bu"))) return(rc)
		fc.vartypes[i] = vt
		if ((rc=verify_vartype(fc.vartypes[i]))) serious = `True'
	}
	if (serious) return(`SERIOUS')		/* sic */


	return(0) 
}
	
`RetcodeS' verify_vartype(`VartypeS' vt)
{
	if (vt>=`VT_strBOT' & vt<=`VT_strTOP') return(0) 
	if (vt==`VT_double') return(0) 
	if (vt==`VT_float')  return(0) 
	if (vt==`VT_long')   return(0) 
	if (vt==`VT_int')    return(0) 
	if (vt==`VT_byte')   return(0) 
	
	serious()
	errprintf("invalid vartype %g\n", vt) 
	return(`SERIOUS') 
}

`RS' len_of_vartype(`VartypeS' vt)
{
	if (vt>=`VT_strBOT' & vt<=`VT_strTOP') return(vt) 

	if (vt==`VT_double') return(8) 
	if (vt==`VT_float')  return(4) 
	if (vt==`VT_long')   return(4) 
	if (vt==`VT_int')    return(2) 
	if (vt==`VT_byte')   return(1) 
	return(.)
}
	

`booleanS' vartype_is_numeric(`VartypeS' vt)
{
	if (vt==`VT_double') return(`True') 
	if (vt==`VT_float')  return(`True') 
	if (vt==`VT_long')   return(`True') 
	if (vt==`VT_int')    return(`True') 
	if (vt==`VT_byte')   return(`True') 
	return(`False')
}
	
				/* 2. Verify vartypes			*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
				/* 3. Verify varnames			*/

`RetcodeS' read_varnames(`FileinfoS' fi, `FilecntsS' fc)
{
	`SS'		buf, char0
	`RetcodeS'	rc 
	`RS'		i, pos
	`booleanS'	muststop

	printf("{txt}\n") 
	printf(" {bf:3. reading and verifying varnames}\n") 

	char0 = char(0)
		
	pragma unset buf
	if ((rc = fileread(buf, fi.h, fc.K*(`MaxNameLen'+1)))) return(rc)
	if (strlen(buf)!=fc.K*(`MaxNameLen'+1)) {
		return(err_msg("varnames buffer too short"))
	}
	
	muststop    = `False'
	fc.varnames = J(fc.K, 1, "")
	for (i=1; i<=fc.K; i++) {
		fc.varnames[i] = bsubstr(buf, (i-1)*(`MaxNameLen'+1)+1, 
						`MaxNameLen'+1)
		pos  = strpos(fc.varnames[i], char0)
		if (pos==0) {
			(void) err_msg("variable name not \0 terminated") 
			muststop = `True'
		}
		fc.varnames[i] = bsubstr(fc.varnames[i], 1, pos-1) 
		if (!st_isname(fc.varnames[i])) {
			(void) err_msg("variable name "+ fc.varnames[i]+
								" invalid")
			muststop = `True'
		}
	}
	if (muststop) return(`SERIOUS') 

	printf("{txt}    verifying varnames unique\n") 
	if (rows(fc.varnames) != rows(uniqrows(fc.varnames))) {
		warning()
		errprintf("name not unique\n") 
		fc.warning = `True'
	}

	return(0) 
}

				/* 3. Verify varnames			*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
				/* 4. Verify sortorder			*/

`RetcodeS' read_sortorder(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc 
	`RC'		order
	`RS'		i, last, val
	`SS'		C

	printf("\n")
	printf("{txt}{bf: 4. reading and verifying sort order}\n") 
	

	/* K+1 unsigned 2-byte integers */

	order = J(fc.K+1, 1, .)

	C = bufio() 
	bufbyteorder(C, fc.bufbyteorder)
	for (i=1; i<=fc.K+1; i++) {
		pragma unset val
		if ((rc = filebufget(val, C, fi.h, "%2bu"))) return(rc)
		order[i] = val
	}
		

	printf("{txt}    verifying contents\n")

		/* find the end */
	last = -1 
	for (i=1; i<=fc.K+1 & last==-1; i++) {
		if (order[i]==0) last = i
	}
	if (last== -1) {
		(void) err_msg("sortlist not 0000 terminated")
		fc.serious = `True' 
		return(0) 	// cannot perform next test
	}

	if (last==  1) return(0) 
	order = order[|1 \ (last-1)|]
	for (i=1; i<=cols(order); i++) {
		if (order[i]<0 || order[i]>fc.K) {
			serious()
			errprintf("sortlist contains var# out of range\n")
			fc.serious = `True'
			errprintf("here is the sortlist:\n") 
			order'
			return(0) 	// we continue
		}
	}

	return(0) 
}
				/* 4. Verify sortorder			*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
				/* 5. Verify formats			*/

`RetcodeS' read_formats(`FileinfoS' fi, `FilecntsS' fc)
{
	`SS'		buf, char0
	`RetcodeS'	rc 
	`RS'		i, pos
	`SS'		fmt
	`booleanS'	serious

	char0 = char(0)
		
	printf("\n") 
	printf("{txt}{bf: 5. reading and verifying display formats}\n") 

	pragma unset buf
	if ((rc = fileread(buf, fi.h, fc.K*(`MaxFmtLen'+1)))) return(rc)
	if (strlen(buf) != fc.K*(`MaxFmtLen'+1)) {
		return(err_msg("format buffer too short"))
	}


	serious = `False' 
	printf("{txt}    verifying formats\n") 
	printf("{txt}    verifying formats correspond to variable type\n") 
	for (i=1; i<=fc.K; i++) {
		fmt = bsubstr(buf, (i-1)*(`MaxFmtLen'+1)+1, `MaxFmtLen'+1)
		pos  = strpos(fmt, char0)
		if (pos==0) return(err_msg("format not \0 terminated"))
		fmt = bsubstr(fmt, 1, pos-1) 
		if (!st_isfmt(fmt)) {
			(void) err_msg("format " + fmt + " invalid")
			serious = `True'
		}
		else if (vartype_is_numeric(fc.vartypes[i])) {
			if (!st_isnumfmt(fmt)) {
				err_msg("format "+fmt+" invalid numeric fmt")
				serious =`True' 
			}
		}
		else {
			if (!st_isstrfmt(fmt)) {
				err_msg("format "+fmt+" invalid str fmt")
				serious =`True' 
			}
		}
	}
	if (serious) fc.serious = serious 

	return(0) 
}

				/* 5. Verify formats			*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
				/* 6. Verify value-label assignment	*/

`RetcodeS' read_vallblnames(`FileinfoS' fi, `FilecntsS' fc)
{
	`SS'		buf, char0
	`RetcodeS'	rc 
	`RS'		i, pos
	`SS'		name

	char0 = char(0)
		
	printf("\n")
	printf("{txt}{bf: 6. reading and verifying value-label assignment}\n") 
	pragma unset buf
	if ((rc = fileread(buf, fi.h, fc.K*(`MaxNameLen'+1)))) return(rc) 
	if (strlen(buf) != fc.K*(`MaxNameLen'+1)) {
		return(err_msg("value-label-names buffer too short"))
	}

	
	printf("{txt}    verifying value-label construction\n") 
	printf(
	"{txt}    verifying value label and corresponding variable types\n") 
	for (i=1; i<=fc.K; i++) {
		name = bsubstr(buf, (i-1)*(`MaxNameLen'+1)+1, `MaxNameLen'+1)
		pos  = strpos(name, char0)
		if (pos==0) {
			err_msg("value-label name not \0 terminated")
			fc.serious = `True'
		}
		else if (pos!=1) {
			name = bsubstr(name, 1, pos-1) 
			if (!st_isname(name)) {
				err_msg("value-label name " + name+" invalid")
				fc.serious = `True'
			}
			if (!vartype_is_numeric(fc.vartypes[i])) {
				err_msg("string variable has value label")
				fc.serious = `True'
			}
		}
	}

	return(0) 
}

				/* 6. Verify value-label assignment	*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
				/* 7. Verify variable labels		*/


`RetcodeS' read_varlabels(`FileinfoS' fi, `FilecntsS' fc)
{
	`SS'		buf, char0
	`RetcodeS'	rc 
	`RS'		i, pos
	`SS'		name

	char0 = char(0)
		
	printf("\n")
	printf(
	"{txt}{bf: 7. reading and verifying variable-label assignment}\n")

	pragma unset buf
	if ((rc = fileread(buf, fi.h, fc.K*(`MaxVarlabLen'+1)))) return(rc)
	if (strlen(buf) != fc.K*(`MaxVarlabLen'+1)) {
		return(err_msg("variable-labels buffer too short"))
	}

	
	printf("{txt}    verifying variable labels construction\n") 
	for (i=1; i<=fc.K; i++) {
		name = bsubstr(buf, (i-1)*(`MaxVarlabLen'+1)+1, `MaxVarlabLen'+1)
		pos  = strpos(name, char0)
		if (pos==0) {
			err_msg("variable label not \0 terminated")
			fc.serious = `True'
		}
	}

	return(0) 
}

				/* 7. Verify variable labels		*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
				/* 8. Verify characteristics		*/

`RetcodeS' read_chars(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc 

	printf("\n")
	printf("{txt}{bf: 8. reading and verifying characteristics}\n") 


	if ((rc = read_chars_ch(fi, fc))) return(rc) 

	return(0) 
}

`RS' read_chars_ch(`FileinfoS' fi, `FilecntsS' fc)
{
	`RS' 	erc
	`SS'	varname, charname
	`SM'	chars
	
	
	chars = J(0, 2, "")
	pragma unset varname
	pragma unset charname
	while( (erc=read_chars_ch_u(fi, fc, varname, charname)) == 0) {
		if (varname!="" & charname!="") {
			chars = chars \ (varname, charname)
		}
	}

	printf("{txt}    (%f characteristics in file)\n", rows(chars))
	if (rows(chars)>1) {
		printf("{txt}    verifying construction\n")
		printf("{txt}    verifying characteristics unique\n") 
		if (rows(chars) != rows(uniqrows(chars))) {
			serious()
			errprintf("characteristics not unique")
			fc.serious = `True'
		}
	}

	return(erc>0 ? erc : 0) 
}


`RS' read_chars_ch_u(`FileinfoS' fi, `FilecntsS' fc, 
 						`SS' varname, `SS' charname)
{
	`RetcodeS'	rc
	`SS'		buf, C, char0
	`RS'		llll, buflen, pos, typ, len
	`RS'		i
	

	/* ------------------------------------------------------------ */
				/* if typ==len==0, we're done		*/

	C  =  bufio() 
	bufbyteorder(C, fc.bufbyteorder)
	pragma unset typ
	pragma unset len
	if ((rc = filebufget(typ, C, fi.h, "%1bu"))) return(rc) 
	if ((rc = filebufget(len, C, fi.h, "%4bu"))) return(rc) 
	if (typ==0 & len==0) return(-1) 	/* -1 means we're done */
	if (typ==0 | len==0) {
		serious()
		errprintf("typ/len invalid; ")
		if (typ==0) errprintf("typ==0 & len!=0\n")
		else	    errprintf("typ!=0 & len==0\n") 
		fc.serious = `True'
		return(-1)
	}


	/* ------------------------------------------------------------ */
	/* 
	   To read

                    0            33             66       l-1
                    |             |              |        |
		llllvarname\0.....charname\0.....contents\0
                    |--------- llll bytes ----------------|

		where 33 = MaxNameLen+1
		      66 = MaxNameLen+1 + MaxNameLen+1
	*/

	char0 = char(0)

	/* ------------------------------------------------------------ */
					/* llll is the len we just read */

	llll = len

	/* ------------------------------------------------------------ */
					/* read varname			*/

	if ((rc = fileread(varname, fi.h, `MaxNameLen'+1))) return(rc)
	if (strlen(varname) != `MaxNameLen'+1) {
		return(err_msg("characteristic varname buffer too short\n"))
	}
	pos = strpos(varname, char0)
	if (pos==0) {
		varname = ""
		serious()
		errprintf("characteristic varname not \0 terminated\n")
		fc.serious = `True'
	}
	else if (pos==1) {
		varname = ""
		serious()
		errprintf("characteristic varname is just \0\n")
		fc.serious = `True'
	}
	else 	varname = bsubstr(varname, 1, pos-1)

	/* ------------------------------------------------------------ */
					/* read charname		*/ 
	
	if ((rc = fileread(charname, fi.h, `MaxNameLen'+1))) return(rc)
	if (strlen(charname) != `MaxNameLen'+1) {
		return(err_msg("characteristic charname buffer too short\n"))
		/*NOTREACHED*/
	}
	pos = strpos(charname, char0)
	if (pos==0) {
		charname = ""
		serious()
		errprintf("characteristic charname not \0 terminated")
		fc.serious = `True'
	}
	else if (pos==1) {
		charname = ""
		serious()
		errprintf("characteristic charname is just \0\n")
		fc.serious = `True'
	}
	else 	charname = bsubstr(charname, 1, pos-1)

	/* ------------------------------------------------------------ */
					/* read contents		*/

	buflen = llll - 2*(`MaxNameLen'+1)
	if (buflen<0) {
		return(err_msg("characteristic buffer has negative length"))
		/*NOTREACHED*/
	}
	if (buflen==0) {
		serious()
		errprintf("characteristic buffer has zero length\n")
		fc.serious = `True'
	}
	else {
		/* 
		   buflen is the physical length, in bytes, of contents
		   It may not exceed `MaxCharLen'
		*/

		if (buflen>`MaxCharLen') {
			errprintf("{p 0 2 2}\n") 
			serious()
			errprintf("characteristic contents length %f,\n", 
									buflen)
			errprintf("may not exceed `MaxCharLen'\n") 
			errprintf("{p_end}\n") 
			fc.serious = `True'
		}

		pragma unset buf
		if (( rc = fileread(buf, fi.h, buflen))) return(rc)
		if (strlen(buf) != buflen) {
			return(err_msg(
			"characteristic contents buffer too short"))
			/*NOTREACHED*/
		}
		pos = strpos(buf, char0) 
		if (pos==0) {
			serious()
			errprintf("characteristic contents not \0 terminated\n")
			fc.serious = `True'
		}
		else if (pos==1) {
			serious()
			errprintf("characteristic contents is just \0\n")
			fc.serious = `True'
		}
	}
	/* ------------------------------------------------------------ */
					/* read end marker		*/



	/* ------------------------------------------------------------ */
				/* look up name				*/

	if (varname!="" & varname!="_dta") {
		for (i=1; i<=fc.K; i++) {
			if (fc.varnames[i]==varname) return(0)
		}
		errprintf("{p 0 2 2}\n")
		serious()
		errprintf("characteristic set for varname |%s|,\n", varname)
		errprintf("yet no such variable exists.\n") 
		errprintf("{p_end}\n") 
		fc.serious = `True'
	}
		
		
	/* ------------------------------------------------------------ */
	return(0)
}
	

				/* 8. Verify characteristics		*/
/* -------------------------------------------------------------------- */

	
/* -------------------------------------------------------------------- */
				/* 9. Verify data			*/


`RetcodeS' read_data(`FileinfoS' fi, `FilecntsS' fc)
{
	printf("\n") 
	printf("{txt}{bf: 9. reading and verifying data}\n") 
	printf("    (`cmdname' cannot verify that values are correct)\n") 
	printf("    verifying construction\n") 

	fseek(fi.h, calculate_lrecl(fc)*fc.N, 0)
	if (iseof(fi.h)) {
		serious()
		errprintf("unexpected end of file\n") 
		return(`SERIOUS')
	}
	return(0)
}

`RS' calculate_lrecl(`FilecntsS' fc)
{
	`RS'	i
	`RS'	lrecl
	
	lrecl=0 
	for (i=1; i<=fc.K; i++) {
		lrecl = lrecl + len_of_vartype(fc.vartypes[i])
	}
	return(lrecl)
}


				/*  9. Verify data			*/
/* -------------------------------------------------------------------- */
		


/* -------------------------------------------------------------------- */
				/* 10. Verify value label definitions	*/


`RetcodeS' read_vallabs(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc
	
	printf("\n") 
	printf("{txt}{bf:10. reading and verifying value label definitions}\n") 
	printf("{txt}    verifying construction\n") 


	if ((rc = read_vallabs_lab(fi, fc))) return(rc) 

	return(0) 
}


`RetcodeS' read_vallabs_lab(`FileinfoS' fi, `FilecntsS' fc)
{
	`RS'	erc
	`SS'	lblname
	`SC'	lblnames

	lblnames = J(0, 1, "")

	pragma unset lblname
	while ( (erc = read_vallabs_lab_u(fi, fc, lblname))==0) {
		if (lblname!="") lblnames = lblnames \ lblname
	}
	if (erc>0) return(erc)

	printf("{txt}    (%f labels in file)\n", rows(lblnames))
	if (rows(lblnames)>1) {
		printf("{txt}    verifying value label names unique\n")
		if (rows(lblnames) != rows(uniqrows(lblnames))) {
			serious()
			errprintf("label names not unique")
			fc.serious = `True'
		}
	}

	return(erc>0 ? erc : 0) 
}

`RetcodeS' read_vallabs_lab_u(`FileinfoS' fi, `FilecntsS' fc, labelname)
{
	`RetcodeS'	rc
	`RS'		llll, pos
	`SS'		C, char0
	`SS'		padding, table

	/* ------------------------------------------------------------ */
				/* if end-of-file, we're done		*/


	if (iseof(fi.h)) {
		return(-1)	/* meaning no more labels		*/
	}
	
	/* ------------------------------------------------------------ */
	/*
	   To read

            len   labelname                  padding  value_label_table
              |   |                                |  |
              llllcccccccccccccccccccccccccccccccccppp...................
                  |-------- 33 characters --------|   |--- len bytes ---|

		where 33 = MaxNameLen
	*/

	char0 = char(0) 

	/* ------------------------------------------------------------ */
					/* read llll			*/
	C = bufio() 
	bufbyteorder(C, fc.bufbyteorder)
	pragma unset llll
	if ((rc = filebufget(llll, C, fi.h, "%4bu"))) return(rc) 

	/* ------------------------------------------------------------ */
					/* read labelname		*/

	if ((rc = fileread(labelname, fi.h, `MaxNameLen'+1))) return(rc)
	if (strlen(labelname) != `MaxNameLen'+1) {
		return(err_msg("value-label buffer too short"))
	}
	pos = strpos(labelname, char0)
	if (pos==0) {
		labelname = "" 
		serious()
		errprintf("value-label name not \0 terminated\n")
		fc.serious = `True' 
	}
	else if (pos==1) {
		labelname = ""
		serious()
		errprintf("value-label name is just \0\n")
		fc.serious = `True'
	}
	else	labelname = bsubstr(labelname, 1, pos-1)

	/* ------------------------------------------------------------ */
					/* read padding			*/

	pragma unset padding
	if ((rc = fileread(padding, fi.h, 3))) return(rc)
	
	/* ------------------------------------------------------------ */
					/* read table			*/

	pragma unset table
	if ((rc = fileread(table, fi.h, llll))) return(rc) 
	
	/* ------------------------------------------------------------ */
					/* read trailing marker		*/

	/* ------------------------------------------------------------ */

	if ((rc = verify_vallabtable(labelname, table, fc))) {
		fc.serious = `True'
	}
	/* ------------------------------------------------------------ */

	return(0) 
}

`RetcodeS' verify_vallabtable(`SS' labelname, `SS' tab, `FilecntsS' fc)
{
	`SS'		C, lblname
	`RS'		pos, txt
	`RS'		i, n_entries, txtlen, zeroat
	`RC'		offset, values
	`RC'		truoffset


	lblname = labelname
	if (lblname=="") lblname = "<unnamed>"

/*
        value_label_table      len   format     comment
        ----------------------------------------------------------
        n                        4   int        number of entries
        txtlen                   4   int        length of txt[]
        off[]                  4*n   int array  txt[] offset table
        val[]                  4*n   int array  sorted value table
        txt[]               txtlen   char       text table
        ----------------------------------------------------------
*/


	/* ------------------------------------------------------------ */
	C = bufio() 
	bufbyteorder(C, fc.bufbyteorder)

	/* ------------------------------------------------------------ */
					/* n_entries			*/

	n_entries = bufget(C, tab, pos=0, "%4bu")
	pos       = pos + 4
	if (n_entries<1)  {
		serious()
		errprintf("value label %s has 0 entries\n", lblname)
		/* abort remaining tests for this value label */
		fc.serious = `True'
		return(0) 
	}
	if (n_entries>=`MaxInt4') {
		serious()
		errprintf("value label %s has more than `MaxInt4' entries\n",
				lblname)
		/* abort remaining tests for this value label */
		fc.serious = `True'
		return(0) 
	}

	/* ------------------------------------------------------------ */
					/* txtlen			*/

	txtlen = bufget(C, tab, pos, "%4bu")
	pos    = pos + 4
	if (txtlen<1) {
		serious()
		errprintf("value label %s has txtlen of 0 \n", lblname)
		/* abort remaining tests for this value label */
		fc.serious = `True'
		return(0)
	}
	if (txtlen > strlen(tab)-4-4-4*n_entries-4*n_entries) { 
		errprintf("{p 0 2 2}\n")
		serious()
		errprintf("value label %s txtlen too small\n", lblname) 
		errprintf("to hold desired contents\n")
		errprintf("{p_end}\n") 
		/* abort remaining tests for this value label */
		fc.serious = `True'
		return(0) 
	}

	/* ------------------------------------------------------------ */
					/* offset[]			*/
		
	offset = J(n_entries, 1, .)
	for (i=1; i<=n_entries; i++) {
		offset[i] = bufget(C, tab, pos, "%4bu")
		pos       = pos + 4
	}

	/* ------------------------------------------------------------ */
					/* values[]			*/

	values = J(n_entries, 1, .) 
	for (i=1; i<=n_entries; i++) {
		values[i] = bufget(C, tab, pos, "%4bs") /* sic, signed */
		pos       = pos + 4
	}

	if (values != sort(values, 1)) {
		errprintf("{p 0 2 2}\n")
		serious()
		errprintf("value label %s\n", lblname)
		errprintf("value-table not in ascending-value order\n")
		errprintf("{p_end}\n") 
		fc.serious = `True'
		/* continue remaining tests for this value label */
	}

	if (values != uniqrows(values)) {
		errprintf("{p 0 2 2}\n")
		serious()
		errprintf("value label %s\n", lblname)
		errprintf("value-table has duplicate values\n")
		errprintf("{p_end}\n") 
		fc.serious = `True'
		/* continue remaining tests for this value label */
	}

	/* ------------------------------------------------------------ */
					/* txt[]			*/
	truoffset = J(n_entries, 1, .)
	txt = pos + 1 			/* txt 1-based for bsubstr()	*/
					/* bsubstr(tab, txt, .) is	*/
					/* the txt[] table		*/

	pos = 0				/* pos 0-based w/i bsubstr()	*/
	for (i=1; i<=n_entries; i++) {
		truoffset[i] = pos 
		/* find terminating \0 */
		zeroat = strpos(bsubstr(tab, txt+pos, .), char(0))
		if (zeroat==0) {
			errprintf("{p 0 2 2}\n")
			serious()
			errprintf("value label %s\n", lblname)
			errprintf("has at least one txt[] entry that\n")
			errprintf("is not zero terminated\n")
			errprintf("{p_end}\n") 
			fc.serious = `True'
			/* abort rest of tests for this value-label */
			return(0) 
		}

		/*
		   label value found at [pos, pos+zeroat].
		   Thus, zeroat is the total length INCLUDING \0.
		*/
		if (zeroat > `MaxVallabCntsLen') {
			errprintf("{p 0 2 2}\n")
			serious()
			errprintf("value label %s\n", lblname)
			errprintf("has text entry of length %f\n", zeroat)
			errprintf("including \0;\n") 
			errprintf("max. allowed is `MaxVallabCntsLen'\n")
			errprintf("{p_end}\n") 
			fc.serious = `True'
		}

		pos = pos + zeroat /* -1 + 1 */
	}
	if (sort(offset,1) != truoffset) {
		errprintf("{p 0 2 2}\n")
		serious()
		errprintf("value label %s\n", lblname)
		errprintf("offset table contains incorrect offsets\n") 
		errprintf("{p_end}\n") 
		sort(offset,1), truoffset
		fc.serious = `True'
		/* we can continue */
	}

	return(0) 
}
	
				/* 10. Verify value label definitions	*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
				/* File utilities			*/


`RetcodeS' fileread(`SS' buf, `Fildes' fh, `RS' len)
{
	if ((buf=_fread(fh, len))==J(0,0,"")) {
		serious() 
		errprintf("unexpected end of file\n") 
		return(`SERIOUS')
	}
	return(0)
}


`RetcodeS' filebufget(`RS' res, transmorphic C, `Fildes' h, `SS' fmt)
{
	res = fbufget(C, h, fmt) 
	if (fstatus(h)<0) {
		serious()
		errprintf("unexpected end of file\n") 
		return(`SERIOUS')
	}
	return(0) 
}

`RetcodeS' f_confirm_str(`Fileinfo' fi, `SS' contents)
{
	`RetcodeS'	rc
	`RS'		len 
	`SS'		buf

	if (!(len=strlen(contents))) return(0) 
	pragma unset buf
	if ((rc = fileread(buf, fi.h, len))) return(rc)
	return(buf!=contents ? err_unexpected(buf, contents) : 0) 
}

`RetcodeS' f_confirm_binarystr(`Fileinfo' fi, `SS' contents)
{
	`RetcodeS'	rc
	`RS'		len 
	`SS'		buf

	if (!(len=strlen(contents))) return(0) 
	pragma unset buf
	if ((rc = fileread(buf, fi.h, len))) return(rc)
	if (buf==contents) return(0) 

	errprintf("{p 0 2 0}\n") 
	serious()
	errprintf("bytes ") 
	f_confirm_binarystr_u(buf)
	errprintf(" found where ") 
	f_confirm_binarystr_u(contents)
	errprintf(" expected\n") 
	errprintf("{p_end}\n") 
	return(`SERIOUS') 
}

void f_confirm_binary_str_u(`SS' s)
{
	`RS'	i

	errprintf("|") 
	for (i=1; i<=strlen(s); i++) {
		if (i!=1) errprintf(" ")
		errprintf("%f", ascii(bsubstr(s, i, 1)))
	}
	errprintf("|") 
}


`RetcodeS' read_generic_string(`SS' what, `Fildes' h, `SS' buf)
{
	`RetcodeS'	rc
	`SS'		C
	`RS'		l 

	C = bufio() 
	pragma unset l
	if ((rc = filebufget(l, C, h, "%1bu"))) return(rc) 
	if ((rc = fileread(buf, h, l))) return(rc) 
	if (strlen(buf)!=l) {
		err_msg(what + " buffer too short") 
		return(`SERIOUS') 
	}
	return(0)
}


`RetcodeS' err_unexpected(`SS' actual, `SS' expected)
{
	`RS'	i, len
	`SS'	s, c

	len = strlen(actual)
	s = "" 
	for (i=1; i<=len; i++) {
		c = bsubstr(actual, i, 1) 
		if (ascii(c)<32 | ascii(c)>127) c = "."
		s = s + c
	}
	serious()
	errprintf("|%s| found where |%s| expected\n", s, expected)
	return(`SERIOUS') 
}
				/* File utilities			*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
				/* Error-message utilities		*/


void serious() errprintf("SERIOUS ERROR: ")

void warning() errprintf("Warning: ")


`RetcodeS' err_msg(`SS' line)
{
	serious()
	errprintf("%s\n", line) 
	return(`SERIOUS') 
}

void warn_msg(`FilecntsS' fc, `SS' line)
{	
	fc.warning = `bTrue'
	warning()
	errprintf("%s\n", line) 
}

				/* Error-message utilities		*/
/* -------------------------------------------------------------------- */

end

