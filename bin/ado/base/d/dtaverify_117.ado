*! version 1.0.4  24mar2015 

/*
	This ado-file is suitable for use, unmodified, in Stata 13 
	and forward.
*/


local cmdname "dtaverify_117"
program `cmdname'
	version 13
	local 0 `"using `0'"'
	syntax using/
	confirm file `"`using'"'
	mata: verify_dta_file(`"`using'"')
end

/* -------------------------------------------------------------------- */
				/* Format 117 values			*/

local RELEASE		117
local MaxVarlabLen	80	/* sic */	/* excludes \0 */
local MaxNameLen	32	/* sic */	/* excludes \0 */
local MaxFmtLen		48	/* sic */	/* excludes \0 */
local MaxCharLen	67784			/* INCLUDES \0 */
local MaxVallabCntsLen	32001			/* INCLUDES \0 */
local MaxVar		32767
local MaxObs 		2147483647
local MaxInt4		2147483647

local MAPELEMENTS	14
local MAP_SOF		1
local MAP_MAP		2
local MAP_VARTYPES	3
local MAP_VARNAMES	4
local MAP_SORTLIST	5
local MAP_FORMATS	6
local MAP_VALLABNAMES	7
local MAP_VARLABS	8
local MAP_CHARS		9
local MAP_DATA		10
local MAP_STRLS 	11
local MAP_VALLABS	12
local MAP_ENDMARKER	13
local MAP_EOF		14

local Vartype		real
local VartypeS		`Vartype' scalar
local VartypeC		`Vartype' colvector
local VT_strBOT		1
local VT_strTOP		2045
local VT_strL		32768		/* sic, because it is a datafile */
local VT_double		65526
local VT_float		65527
local VT_long		65528
local VT_int		65529
local VT_byte		65530
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
				
	if ((rc = f_confirm_str(fi, "<stata_dta>"))) return(rc)



	if ((rc = read_header(     fi, fc))) return(cantcont(rc))
	if ((rc = read_map(        fi, fc))) return(cantcont(rc))
	if ((rc = read_vartypes(   fi, fc))) return(cantcont(rc))
	if ((rc = read_varnames(   fi, fc))) return(cantcont(rc))
	if ((rc = read_sortorder(  fi, fc))) return(cantcont(rc))
	if ((rc = read_formats(    fi, fc))) return(cantcont(rc))
	if ((rc = read_vallblnames(fi, fc))) return(cantcont(rc))
	if ((rc = read_varlabels(  fi, fc))) return(cantcont(rc))
	if ((rc = read_chars(      fi, fc))) return(cantcont(rc))
	if ((rc = read_data(       fi, fc))) return(cantcont(rc))
	if ((rc = read_strls(      fi, fc))) return(cantcont(rc))
	if ((rc = read_vallabs(    fi, fc))) return(cantcont(rc))

	if ((rc = f_confirm_str(fi, "</stata_dta>"))) return(rc)


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



/* -------------------------------------------------------------------- */
				/* 1. check header			*/
				/*    <header>...</header>		*/

`RetcodeS' read_header(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc

	printf("\n")
	printf("{txt}{bf} 1. reading and verifying header{rm}\n") 

	if ((rc = f_confirm_str(fi, "<header>"))) return(rc)

	if ((rc = read_header_release(fi, fc))) return(rc) 
	printf("{txt}    release is %f\n", fc.rel) 
	if (fc.rel != `RELEASE') return(err_msg("release not 117"))

	if ((rc = read_header_byteorder(fi, fc))) return(rc) 
	if ((rc = read_header_K(        fi, fc))) return(rc) 
	if ((rc = read_header_N(        fi, fc))) return(rc) 
	if ((rc = read_header_label(    fi, fc))) return(rc) 
	if ((rc = read_header_timestamp(fi, fc))) return(rc) 

	if ((rc = f_confirm_str(fi, "</header>"))) return(rc)

	return(0) 
}
	

`RetcodeS' read_header_release(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc 
	`SS'		rel

	if ((rc = f_confirm_str(fi, "<release>"))) return(rc)

	pragma unset rel
	if ((rc=fileread(rel, fi.h, 3))) return(rc) 
	if (strlen(rel)!=3) {
		serious()
		errprintf("<release> value not 3 digits long\n")
		return(`SERIOUS') 
	}
	fc.hdr.release = rel 
	fc.rel         = strtoreal(rel)
	
	if ((rc = f_confirm_str(fi, "</release>"))) return(rc)

	return(0) 
}


`RetcodeS' read_header_byteorder(`FileinfoS' fi, `FilecntsS' fc)
{
	
	`RetcodeS'	rc 
	`SS'		bo 

	if ((rc = f_confirm_str(fi, "<byteorder>"))) return(rc)

	pragma unset bo
	if ((rc=fileread(bo, fi.h, 3))) return(rc) 
	printf("{txt}    byteorder %s\n", bo) 
	if (bo!="MSF" && bo!="LSF") {
		serious()
		errprintf("byteorder invalid\n") 
		return(`SERIOUS') 
	}
	fc.hdr.byteorder = bo 

	if ((rc = f_confirm_str(fi, "</byteorder>"))) return(rc)

	fc.bufbyteorder = (bo=="MSF" ? 1 : 2)

	return(0) 
}


`RetcodeS' read_header_K(`FileinfoS' fi, `FilecntsS' fc)
{
	
	`RetcodeS'	rc 
	`SS'		C
	`RS'		K

	if ((rc = f_confirm_str(fi, "<K>"))) return(rc)

	C = bufio() 
	bufbyteorder(C, fc.bufbyteorder)
	pragma unset K
	if ((rc = filebufget(K, C, fi.h, "%2bu"))) return(rc) 

	printf("{txt}    K (# of vars) is %f\n", K)
	if (K>`MaxVar') return(err_msg("K>`MaxVar' invalid"))
	fc.K = K
	
	if ((rc = f_confirm_str(fi, "</K>"))) return(rc)
	return(0) 
}

`RetcodeS' read_header_N(`FileinfoS' fi, `FilecntsS' fc)
{
	
	`RetcodeS'	rc 
	`SS'		C
	`RS'		N

	if ((rc = f_confirm_str(fi, "<N>"))) return(rc)

	C = bufio() 
	bufbyteorder(C, fc.bufbyteorder)
	pragma unset N
	if ((rc = filebufget(N, C, fi.h, "%4bu"))) return(rc)
	printf("{txt}    N (# of obs) is %f\n", N)
	if (N>`MaxObs') return(err_msg("N>`MaxObs' invalid"))
	fc.N = N
	
	if ((rc = f_confirm_str(fi, "</N>"))) return(rc)
	return(0) 
}

`RetcodeS' read_header_label(`FileinfoS' fi, `FilecntsS' fc)
{
	
	`RetcodeS'	rc 
	`SS'		C, text

	if ((rc = f_confirm_str(fi, "<label>"))) return(rc)

	C = bufio()
	bufbyteorder(C, fc.bufbyteorder)
	pragma unset text
	if ((rc=read_generic_string("label", fi.h, text))) return(rc) 
	printf("{txt}    label length %f", strlen(text))
	if (strlen(text)>`MaxVarlabLen') {
		serious()
		errprintf("label length invalid") 
		fc.serious = `True'
	}
	printf("{txt} |%s|\n", text)

	if ((rc = f_confirm_str(fi, "</label>"))) return(rc)
	return(0) 
}


`RetcodeS' read_header_timestamp(`FileinfoS' fi, `FilecntsS' fc)
{
	
	`RetcodeS'	rc 
	`SS'		text
	`RS'		l 


	if ((rc = f_confirm_str(fi, "<timestamp>"))) return(rc)

	pragma unset text
	if ((rc = read_generic_string(text, fi.h, text))) return(rc)
	l    = strlen(text)
	printf("{txt}    date length %f |%s|\n", l, text)
	if (l!=0 && l!=17) {
		if (l>17) {
			(void) err_msg("date length invalid")
			fc.serious = `True'
		}
		else {
			warning()
			errprintf("date length not 0 or 17\n") 
			fc.warning = `True'
		}
	}
	if ((rc = f_confirm_str(fi, "</timestamp>"))) return(rc)
	return(0) 
}

				/* 1. check header			*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
				/* 2. Verify map			*/
				/*    <map>...</map>			*/


`RetcodeS' read_map(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc 
	`RS'		i


	printf("\n") 
	printf("{txt}{bf: 2. reading and verifying map}\n") 

	if ((rc = f_confirm_str(fi, "<map>"))) return(rc)

	fc.map = J(`MAPELEMENTS', 1, 0)
	for (i=1; i<=14; i++) {
		if ((rc=read_map_element(fi, fc, i))) return(rc) 
		printf("{txt}    map[%2.0f] = %20.0g\n", i, fc.map[i])
	}

	if ((rc = f_confirm_str(fi, "</map>"))) return(rc)

	if ((rc = read_map_verify(fi, fc))) return(rc) 

	return(0)
}

`RetcodeS' read_map_verify(`FileinfoS' fi, `FilecntsS' fc)
{
	`RS'		curpos
	`booleanS'	serious

	curpos = ftell(fi.h) 
	printf("{txt}    verifying map\n") 


	serious = `False'

	printf("{txt}    1") 
	if (fc.map[`MAP_SOF']) {
		serious()
		errprintf("map[`MAP_SOF'] invalid\n") 
		serious = `True'
	}

	printf("{txt} 2") 
	fseek(fi.h, fc.map[`MAP_MAP'], -1)
	if ((f_confirm_str(fi, "<map>"))) serious = `True'

	printf("{txt} 3") 
	fseek(fi.h, fc.map[`MAP_VARTYPES'], -1)
	if ((f_confirm_str(fi, "<variable_types>"))) serious = `True'

	printf("{txt} 4") 
	fseek(fi.h, fc.map[`MAP_VARNAMES'], -1)
	if ((f_confirm_str(fi, "<varnames>"))) serious = `True'

	printf("{txt} 5") 
	fseek(fi.h, fc.map[`MAP_SORTLIST'], -1)
	if ((f_confirm_str(fi, "<sortlist>"))) serious = `True'

	printf("{txt} 6") 
	fseek(fi.h, fc.map[`MAP_FORMATS'], -1)
	if ((f_confirm_str(fi, "<formats>"))) serious = `True'

	printf("{txt} 7") 
	fseek(fi.h, fc.map[`MAP_VALLABNAMES'], -1)
	if ((f_confirm_str(fi, "<value_label_names>"))) serious = `True'

	printf("{txt} 8") 
	fseek(fi.h, fc.map[`MAP_VARLABS'], -1)
	if ((f_confirm_str(fi, "<variable_labels>"))) serious = `True'

	printf("{txt} 9") 
	fseek(fi.h, fc.map[`MAP_CHARS'], -1)
	if ((f_confirm_str(fi, "<characteristics>"))) serious = `True'

	printf("{txt} 10") 
	fseek(fi.h, fc.map[`MAP_DATA'], -1)
	if ((f_confirm_str(fi, "<data>"))) serious = `True'

	printf("{txt} 11") 
	fseek(fi.h, fc.map[`MAP_STRLS'], -1)
	if ((f_confirm_str(fi, "<strls>"))) serious = `True'

	printf("{txt} 12") 
	fseek(fi.h, fc.map[`MAP_VALLABS'], -1) 
	if ((f_confirm_str(fi, "<value_labels>"))) serious = `True'

	printf("{txt} 13") 
	fseek(fi.h, fc.map[`MAP_ENDMARKER'], -1)
	if ((f_confirm_str(fi, "</stata_dta>"))) serious = `True'

	printf("{txt} 14") 
	if (ftell(fi.h) != fc.map[`MAP_EOF']) {
		(void) err_msg("map[`MAP_SOF'] invalid") 
		serious = `True'
	}
	printf("\n") 

	if (serious) fc.serious = serious 
	
	fseek(fi.h, curpos, -1)
	return(0)
}



`RetcodeS' read_map_element(`FileinfoS' fi, `FilecntsS' fc, `RS' i)
{
	`RetcodeS'	rc
	`SS'		C
	`RS'		p1, p0, hold


	C = bufio() 
	bufbyteorder(C, fc.bufbyteorder)
	pragma unset p1
	pragma unset p0
	if ((rc = filebufget(p1, C, fi.h, "%4bu"))) return(rc) 
	if ((rc = filebufget(p0, C, fi.h, "%4bu"))) return(rc) 

	if (fc.bufbyteorder == 2) {
		hold = p1 
		p1   = p0 
		p0   = hold 
	}

	/*
		1.0x+20 = 2^32 because 0x20 = 32
	*/
	
	fc.map[i] = (1.0x+20)*p1 + p0

	return(0) 
}

				/* 2. Verify map			*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
				/* 3. Verify vartypes			*/
				/* <variables_types>...</variable_types>*/
	
`RetcodeS' read_vartypes(`FileinfoS' fi, `FilecntsS' fc)
{
	`SS'		C
	`RetcodeS'	rc 
	`RS'		i
	`VartypeS'	vt
	`booleanS'	serious

		
	printf("\n") 
	printf("{txt}{bf: 3. reading and verifying vartypes}\n") 

	if ((rc = f_confirm_str(fi, "<variable_types>"))) return(rc)
	C = bufio()
	bufbyteorder(C, fc.bufbyteorder)

	serious     = `False'
	fc.vartypes = J(fc.K, 1, .)
	pragma unset vt
	for (i=1; i<=fc.K; i++) {
		if ((rc = filebufget(vt, C, fi.h, "%2bu"))) return(rc)
		fc.vartypes[i] = vt
		if ((rc=verify_vartype(fc.vartypes[i]))) serious = `True'
	}
	if (serious) return(`SERIOUS')		/* sic */

	if ((rc = f_confirm_str(fi, "</variable_types>"))) return(rc)

	return(0) 
}
	
`RetcodeS' verify_vartype(`VartypeS' vt)
{
	if (vt>=`VT_strBOT' & vt<=`VT_strTOP') return(0) 
	if (vt==`VT_strL')   return(0) 
	if (vt==`VT_double') return(0) 
	if (vt==`VT_float')  return(0) 
	if (vt==`VT_long')   return(0) 
	if (vt==`VT_int')    return(0) 
	if (vt==`VT_byte')   return(0) 
	
	serious()
	errprintf("invalid vartype %g\n", vt) 
	return(`SERIOUS') 
}

`RS'	len_of_vartype(`VartypeS' vt)
{
	if (vt>=`VT_strBOT' & vt<=`VT_strTOP') return(vt) 

	if (vt==`VT_strL')   return(8) 
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
	
				/* 3. Verify vartypes			*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
				/* 4. Verify varnames			*/

`RetcodeS' read_varnames(`FileinfoS' fi, `FilecntsS' fc)
{
	`SS'		buf, char0
	`RetcodeS'	rc 
	`RS'		i, pos
	`booleanS'	muststop

	printf("\n") 
	printf("{txt}{bf: 4. reading and verifying varnames}\n") 

	char0 = char(0)
		
	if ((rc = f_confirm_str(fi, "<varnames>"))) return(rc)
	pragma unset buf
	if ((rc = fileread(buf, fi.h, fc.K*(`MaxNameLen'+1)))) return(rc)
	if (strlen(buf)!=fc.K*(`MaxNameLen'+1)) {
		return(err_msg("varnames buffer too short"))
	}
	if ((rc = f_confirm_str(fi, "</varnames>"))) return(rc)
	
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
		serious()
		errprintf("name not unique\n") 
		fc.serious = `True'
	}

	return(0) 
}

				/* 4. Verify varnames			*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
				/* 5. Verify sortorder			*/
				/*    <sortorder>...</sortorder>	*/

`RetcodeS' read_sortorder(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc 
	`RC'		order
	`RS'		i, last, val
	`SS'		C

	printf("\n")
	printf("{txt}{bf: 5. reading and verifying sort order}\n") 
	
	if ((rc = f_confirm_str(fi, "<sortlist>"))) return(rc) 

	/* K+1 unsigned 2-byte integers */

	order = J(fc.K+1, 1, .)

	C = bufio() 
	bufbyteorder(C, fc.bufbyteorder)
	for (i=1; i<=fc.K+1; i++) {
		pragma unset val
		if ((rc = filebufget(val, C, fi.h, "%2bu"))) return(rc)
		order[i] = val
	}
		
	if ((rc = f_confirm_str(fi, "</sortlist>"))) return(rc)

	printf("{txt}    verifying contents\n")

		/* find the end */
	last = -1 
	for (i=1; i<=fc.K+1 & last==-1; i++) {
		if (order[i]==0) last = i
	}
	if (last== -1) {
		(void) err_msg("sortlist not (Int4) 0000 terminated")
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
				/* 5. Verify sortorder			*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
				/* 6. Verify formats			*/
				/*    <formats>...</formats>		*/

`RetcodeS' read_formats(`FileinfoS' fi, `FilecntsS' fc)
{
	`SS'		buf, char0
	`RetcodeS'	rc 
	`RS'		i, pos
	`SS'		fmt
	`booleanS'	serious

	char0 = char(0)
		
	printf("\n") 
	printf("{txt}{bf: 6. reading and verifying display formats}\n") 
	if ((rc = f_confirm_str(fi, "<formats>"))) return(rc)

	pragma unset buf
	if ((rc = fileread(buf, fi.h, fc.K*(`MaxFmtLen'+1)))) return(rc)
	if (strlen(buf) != fc.K*(`MaxFmtLen'+1)) {
		return(err_msg("format buffer too short"))
	}
	if ((rc = f_confirm_str(fi, "</formats>"))) return(rc)


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

				/* 6. Verify formats			*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
				/* 7. Verify value-label assignment	*/
			/* <value_label_names>...</values_label_names	*/

`RetcodeS' read_vallblnames(`FileinfoS' fi, `FilecntsS' fc)
{
	`SS'		buf, char0
	`RetcodeS'	rc 
	`RS'		i, pos
	`SS'		name

	char0 = char(0)
		
	printf("\n")
	printf("{txt}{bf: 7. reading and verifying value-label assignment}\n") 
	if ((rc = f_confirm_str(fi, "<value_label_names>"))) return(rc) 
	pragma unset buf
	if ((rc = fileread(buf, fi.h, fc.K*(`MaxNameLen'+1)))) return(rc) 
	if (strlen(buf) != fc.K*(`MaxNameLen'+1)) {
		return(err_msg("value-label-names buffer too short"))
	}
	if ((rc = f_confirm_str(fi, "</value_label_names>"))) return(rc)

	
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

				/* 7. Verify value-label assignment	*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
				/* 8. Verify variable labels		*/
			/*    <variable_labels>...</variable_labels>	*/


`RetcodeS' read_varlabels(`FileinfoS' fi, `FilecntsS' fc)
{
	`SS'		buf, char0
	`RetcodeS'	rc 
	`RS'		i, pos
	`SS'		name

	char0 = char(0)
		
	printf("\n")
	printf(
	"{txt}{bf: 8. reading and verifying variable-label assignment}\n")
	if ((rc = f_confirm_str(fi, "<variable_labels>"))) return(rc) 

	pragma unset buf
	if ((rc = fileread(buf, fi.h, fc.K*(`MaxVarlabLen'+1)))) return(rc)
	if (strlen(buf) != fc.K*(`MaxVarlabLen'+1)) {
		return(err_msg("variable-labels buffer too short"))
	}
	if ((rc = f_confirm_str(fi, "</variable_labels>"))) return(rc)

	
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

				/* 8. Verify variable labels		*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
				/* 9. Verify characteristics		*/
				/* <characteristics>...</characteristics> */

`RetcodeS' read_chars(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc 

	printf("\n")
	printf("{txt}{bf: 9. reading and verifying characteristics}\n") 

	if ((rc = f_confirm_str(fi, "<characteristics>"))) return(rc)

	if ((rc = read_chars_ch(fi, fc))) return(rc) 

	if ((rc = f_confirm_str(fi, "</characteristics>"))) return(rc)
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
	if (erc != -1) return(erc) 

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
	`RS'		curpos 
	`SS'		buf, C, char0
	`RS'		llll, buflen, pos
	`RS'		i
	

	/* ------------------------------------------------------------ */
				/* if not <ch>, reset file pointer	*/
				/* and return -1			*/
	curpos = ftell(fi.h) 
	pragma unset buf
	if ((rc = fileread(buf, fi.h, strlen("<ch>")))) return(rc)
	if (buf!="<ch>") {
		fseek(fi.h, curpos, -1) 
		return(-1) 	/* sic */
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

		total bytes for contents cannot exceed MaxCharLen, 
		including terminating 0.  
	*/

	char0 = char(0)

	/* ------------------------------------------------------------ */
					/* read llll			*/
	C = bufio() 
	bufbyteorder(C, fc.bufbyteorder)
	pragma unset llll
	if ((rc = filebufget(llll, C, fi.h, "%4bu"))) return(rc) 

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
		   buflen is the physical length, in bytes, of contents,
		   including \0.  buflen may not exceed `MaxCharLen'.
		*/

		if (buflen>`MaxCharLen') {
			errprintf("{p 0 2 2}\n") 
			serious()
			errprintf("characteristic\n")
			errprintf("contents length %f,\n", buflen)
			errprintf("may not exceed `MaxCharLen'\n") 
			errprintf("{p_end}\n") 
			fc.serious = `True'
		}

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

	if ((rc = f_confirm_str(fi, "</ch>"))) return(rc)


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
	

				/* 9. Verify characteristics		*/
/* -------------------------------------------------------------------- */

	
/* -------------------------------------------------------------------- */
				/* 10. Verify data			*/
				/*    <data>...</data>			*/


`RetcodeS' read_data(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc
	`ExtRetcodeS'	erc

	printf("\n") 
	printf("{txt}{bf:10. reading and verifying data}\n") 
	printf("    (`cmdname' cannot verify that values are correct)\n") 
	printf("    verifying construction\n") 

	if ((rc  = f_confirm_str(fi, "<data>"))) return(rc)
	if ((erc = read_data_u(fi, fc))>0) return(erc) 
	if (erc<0) {
		/* skip <data>...</data> contents; no strLs	*/
		fseek(fi.h, calculate_lrecl(fc)*fc.N, 0)
	}

	if ((rc = f_confirm_str(fi, "</data>"))) return(rc)
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



`ExtRetcodeS' read_data_u(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc
	`RS'		i 
	`VartypeS'	vt
	`RS'		off
	`RC'		varno, offset

	
	varno = offset = J(0, 1, .)
	off   = 0
	for (i=1; i<=fc.K; i++) {
		vt  = fc.vartypes[i]
		if (vt == `VT_strL') {
			varno =  varno  \ i
			offset = offset \ off
		}
		off = off + len_of_vartype(vt) 
	}
	printf("    (%f strL variables)\n", rows(varno))
	if (rows(varno)==0) return(-1) 

	printf("{txt}    verifying strL construction\n") 
	if ((rc = read_data_u_strls(fi, fc, varno, offset))) return(rc)

	return(0) 
}

`RetcodeS' read_data_u_strls(`FileinfoS' fi, `FilecntsS' fc, 
					`RC' varno, `RC' offset)
{
	`RetcodeS'	rc 
	`RS'		j
	`RS'		lrecl
	`SS'		buf 
	

	lrecl = calculate_lrecl(fc) 

	fc.vo = J(0, 2, .)
	for (j=1; j<=fc.N; j++) {
		pragma unset buf
		if ((rc=fileread(buf, fi.h, lrecl))) return(rc)
		if ((rc=strl_process_obs(fc, buf, j, varno, offset))) {
			return(rc)
		}
	}
	return(0) 
}

`RetcodeS' strl_process_obs(`FilecntsS' fc, `SS' buf, `RS' j, 
					`RC' varno, `RC' offset)
{
	`RetcodeS'	rc
	`RS'		ci, i
	`RS'		v, o
	`SS'		C

	C = bufio() 
	bufbyteorder(C, fc.bufbyteorder)

	for (ci=1; ci<=rows(varno); ci++) {
		i = varno[ci]
		v = bufget(C, buf, offset[ci]  , "%4bu")
		o = bufget(C, buf, offset[ci]+4, "%4bu")
		if (v==0 | o==0) { 
			if (v!=0 | o!=0) {
				dstrlmsg(i, j, v, o, "warning", 
					"(v,o) should be (0,0)")
				fc.warning = `True'
			}
		}
		else {
			if ((rc = chkijvo(fc, i, j, v, o))) return(rc)
			fc.vo = fc.vo \ (v, o)
		}
	}

	return(0)
}

`RetcodeS' chkijvo(`FilecntsS' fc, `RS' i, `RS' j, `RS' v, `RS' o)
{
	if (v==i & o==j) return(0) 
	if (v!=i) {
		if (fc.vartypes[v]!=`VT_strL') {
			dstrlmsg(i, j, v, o, "SERIOUS", "v not strL") 
			fc.serious = `True'
			return(0) 
		}
	}
	if (o< j) return(0) 
	if (o==j & v<=i) return(0) 
	dstrlmsg(i, j, v, o, "SERIOUS", "(v,o) is forward reference")
	fc.serious = `True'
	/* we continue */
	return(0) 
}




void dstrlmsg(`RS' i, `RS' j, `RS' v, `RS' o, `SS' msgtyp, `SS' txt)
{
	errprintf("{p 0 2 2}\n") 
	if (msgtyp=="warning")  warning() 
	else			serious()
	errprintf("(var,obs)=(%f,%f) has (v,o)=(%f,%f);\n", i, j, v, o)
	errprintf("%s\n", txt) 
	errprintf("{p_end}\n") 
}
	
		
				/* 10. Verify data			*/
/* -------------------------------------------------------------------- */
		

/* -------------------------------------------------------------------- */
				/* 11. Verify strls			*/
				/*     <strls>...</strls>		*/

`RetcodeS' read_strls(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc

	printf("\n") 
	printf("{txt}{bf:11. reading and verifying strLs}\n") 
	printf("    verifying construction\n") 
	printf("    (%f strLs expected)\n", rows(fc.vo))

	if ((rc = f_confirm_str(fi, "<strls>"))) return(rc)
	if (rows(fc.vo)) {
		if ((rc=read_strls_u(fi, fc))) return(rc)
	}
	if ((rc = f_confirm_str(fi, "</strls>"))) return(rc)
	return(0)
}

`RetcodeS' read_strls_u(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc
	`RS'		ci
	`RS'		v, o, t, len
	`SS'		C
	`SS'		asciistr


/* 
	<strls>GSOdefGSOdef...GSOdef</strls>

	GSOdef:
                     o           len
                      \         /        contents
                       ---- ----         /
                GSOvvvvooootllllxxxxxxxxxxxxxxx...x
                   ----    -   (---- len bytes ----)
                  /        |
                 v       type


            name    length          contents
            -----------------------------------------------------------
                         3          GSO (fixed string)
            v            4          unsigned 4-byte integer, v of (v,o)
            o            4          unsigned 4-byte integer, o of (v,o)
            t            1          unsigned 1-byte integer
            len          4          unsigned 4-byte integer
            contents   len          contents of strL
            -----------------------------------------------------------
            v, o, and len are recorded per byteorder.

            t is encoded:
                129 (decimal)        binary
                130 (decimal)        ascii
            if t==129,
                contents contains the string AS-IS.
                len contains the length of contents.
            if t==130, 
                contents must contain trailing \0.
                len contains the length of the string including \0.
                If using C, len = strlen(string) + 1.
*/

	pragma unset v
	pragma unset o
	pragma unset t
	pragma unset len
	pragma unset asciistr
	C = bufio() 
	bufbyteorder(C, fc.bufbyteorder)
	for (ci=1; ci<=rows(fc.vo); ci++) {
		if ((rc = f_confirm_str(fi, "GSO"))) return(rc)
		if ((rc = filebufget(v,   C, fi.h, "%4bu"))) return(rc) 
		if ((rc = filebufget(o,   C, fi.h, "%4bu"))) return(rc) 
		if ((rc = filebufget(t,   C, fi.h, "%1bu"))) return(rc) 
		if ((rc = filebufget(len, C, fi.h, "%4bu"))) return(rc) 
		if (t==130) {
			if ((rc = fileread(asciistr, fi.h, len))) return(rc)
		}
		else {
			fseek(fi.h, len, 0)
		}

		if (!(v==fc.vo[ci,1] & o==fc.vo[ci,2])) {
			strLmsg(v, o, sprintf("found where (%f,%f) expected",
						fc.vo[ci,1], fc.vo[ci,2]))
			fc.serious = `True' 
			if (findinvo(fc.vo, v, o)) {
				strLmsg(v, o, "should not even be defined")
			}
		}
		else {
			if (!(t==129 | t==130)) {
				strLmsg(v, o, sprintf("t = %f", t))
				fc.serious = `True' 
			}
			if (t==130) {
				if (bsubstr(asciistr, len, 1)!=char(0)) {
					strLmsg(v, o, "string not terminated")
					fc.serious = `True' 
				}
			}
		}
	}
	return(0) 
}
				

`booleanS' findinvo(`RM' vo, `RS' v, `RS' o) 
{
	`RS'	ci 

	for (ci=1; ci<=rows(vo); ci++) {
		if (v==vo[ci,1] & o==vo[ci,2]) return(`True')
	}
	return(`False')
}
		

void strLmsg(`RS' v, `RS' o, `SS' txt)
{
	errprintf("{p 0 2 2}\n") 
	serious()
	errprintf("(v,o)=(%f,%f):\n", v, o)
	errprintf("%s\n", txt) 
	errprintf("{p_end}\n") 
}



				/* 11. Verify strls			*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
				/* 12. Verify value label definitions	*/
				/*     <value_labels>... </value_labels>*/


`RetcodeS' read_vallabs(`FileinfoS' fi, `FilecntsS' fc)
{
	`RetcodeS'	rc
	
	printf("\n") 
	printf("{txt}{bf:12. reading and verifying value label definitions}\n") 
	printf("{txt}    verifying construction\n") 

	if ((rc = f_confirm_str(fi, "<value_labels>"))) return(rc)

	if ((rc = read_vallabs_lab(fi, fc))) return(rc) 

	if ((rc = f_confirm_str(fi, "</value_labels>"))) return(rc)
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
			errprintf("label names not unique\n")
			fc.serious = `True'
		}
	}

	return(erc>0 ? erc : 0) 
}

`RetcodeS' read_vallabs_lab_u(`FileinfoS' fi, `FilecntsS' fc, labelname)
{
	`RetcodeS'	rc
	`RS'		curpos
	`RS'		llll, pos
	`SS'		C, buf, char0
	`SS'		padding, table

	/* ------------------------------------------------------------ */
				/* if not <lbl>, reset file pointer	*/
				/* and return -1			*/

	curpos = ftell(fi.h) 
	pragma unset buf
	if ((rc = fileread(buf, fi.h, strlen("<lbl>")))) return(rc)
	if (buf!="<lbl>") { 
		fseek(fi.h, curpos, -1)
		return(-1) 		/* sic */
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

	if ((rc = fileread(buf, fi.h, strlen("</lbl>")))) return(rc)
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

	Individual txt[] entries may not exceed `MaxVallabCntsLen'
	including \0.
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
		errprintf("{p 0 2 2}\n")
		serious()
		errprintf("value label %s has more than `MaxInt4' entries\n",
				lblname)
		errprintf("{p_end}\n") 
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
		errprintf("value label %s has txtlen of 0\n", lblname)
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
		   label value found at [pos, pos+zeroat].  Thus, 
		   zeroat is the total length INCLUDING \0.
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
	
				/* 12. Verify value label definitions	*/
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

