*! version 1.0.5  02feb2015
version 10

local FHEADERVERSION	10

local BACKR = char(13)
local BACKN = char(10)
local BRBN = "`BACKR'`BACKN'"

local LINE1 "*! Stata(R) ???.?? Binary File Header_version ????`BRBN'"
local LINE1c "*! Stata(R) ???,?? Binary File Header_version ????`BRBN'"
local V10LINE2 "*! Date ?????????????????? ?????????????????????????????????????`BRBN'"
local V10LINE3 "*! Byteorder ????`BRBN'"
local V10LINE4 "*! Filetype ???????????????????????????????? Version ????`BRBN'"
local V10LINE5 "*! <end_of_header>`BRBN'"
local V10LINE6 "1`BACKR'2`BACKN'3`BRBN'"

local LINE1LEN = strlen(`"`LINE1'"')
local V10LINE2LEN = strlen(`"`V10LINE2'"')
local V10LINE3LEN = strlen(`"`V10LINE3'"')
local V10LINE4LEN = strlen(`"`V10LINE4'"')
local V10LINE5LEN = strlen(`"`V10LINE5'"')
local V10LINE6LEN = strlen(`"`V10LINE6'"')

local V9LINE2 "*! Date ??????????????????`BRBN'"
local V9LINE3 "*! Byteorder ????`BRBN'"
local V9LINE4 "*! Filetype ???????????????????????????????? Version ????`BRBN'"
local V9LINE5 "*! <end_of_header>`BRBN'"
local V9LINE6 "1`BACKR'2`BACKN'3`BRBN'"

local V9LINE2LEN = strlen(`"`V9LINE2'"')
local V9LINE3LEN = strlen(`"`V9LINE3'"')
local V9LINE4LEN = strlen(`"`V9LINE4'"')
local V9LINE5LEN = strlen(`"`V9LINE5'"')
local V9LINE6LEN = strlen(`"`V9LINE6'"')


local Fildes	real scalar
local Errcode	real scalar
local boolean	real scalar

mata:
mata set matastrict on

/*
Version 10 header:
----+----1----+----2----+----3----+----4----+----5----+----6----+----7
*! Stata(R) ###.## Binary File Header_version ####rn
*! Date 01jan2000 14:15:03                                      rn
*! Byteorder HILOrn
*! Filetype ---name goes here -2----+----3-- Version 0001rn
*! <end_of_header>`BRBN'"
1r
2n
3rn
*/

/*
Version 9 header:
----+----1----+----2----+----3----+----4----+----5----+----6----+----7
*! Stata(R) ###.## Binary File Header_version ####rn
*! Date 01jan2000 14:15:03rn
*! Byteorder HILOrn
*! Filetype ---name goes here -2----+----3-- Version 0001rn
*! <end_of_header>rn
1r
2n
3rn
*/

`Errcode' _st_fwritesignature(`Fildes' fh, string scalar name,
					 real scalar vers, `boolean' quiet)
{
	string scalar	line1, line2, line3, line4, line5, line6
	string scalar	datetime
	string scalar	byteorder
	`Errcode'	ec

	line1 = "`LINE1'"
	line2 = "`V`FHEADERVERSION'LINE2'"
	line3 = "`V`FHEADERVERSION'LINE3'"
	line4 = "`V`FHEADERVERSION'LINE4'"
	line5 = "`V`FHEADERVERSION'LINE5'"
	line6 = "`V`FHEADERVERSION'LINE6'"

	if (strlen(name) > 32) {
		_error("name too long")
		/*NOTREACHED*/
	}

	if (vers<1 || vers>9999 || vers!=round(vers)) {
		_error("version invalid")
		/*NOTREACHED*/
	}

	datetime = sprintf("%tc",
			clock(st_global("c(current_date)") +
		   	      " " +
		   	      st_global("c(current_time)"), "DMYhms"))

	byteorder = (byteorder()==1 ? "HILO" : "LOHI")

	_substr(line1, sprintf("%06.2f", stataversion()/100), 13)
	_substr(line1, sprintf("%04.0f", `FHEADERVERSION'), 47)

	if (strlen(name) < 32) {
		name = name + (32-strlen(name))*" "
	}

	_substr(line2, datetime, 9)
	_substr(line2, 5*" "+32*" ", 28)

	_substr(line3, byteorder, 14)

	_substr(line4, name, 13)
	_substr(line4, sprintf("%04.0f", vers), 54)

	if ((ec = _fwrite(fh, line1+line2+line3+line4+line5+line6)) < 0) {
		if (!quiet) errprintf("%s\n", ferrortext(ec))
		return(freturncode(ec))
	}
	return(0)
}


void st_fwritesignature(`Fildes' fh, string scalar name,
					 real scalar vers)
{
	`Errcode'	ec

	if ((ec = _st_fwritesignature(fh, name, vers, 0)) < 0) {
		fclose(fh)
		exit(-ec)
	}
}


`Errcode' _st_freadsignature(`Fildes' fh, string scalar name,
			  real scalar vers, `boolean' quiet,
			  real scalar f_vers,
			  |real scalar f_byteorder, real scalar f_date)
{
	string scalar	line1
	real scalar	fh_vers
	real scalar	st_vers
	`Errcode'	ec

	line1 = _fread(fh, `LINE1LEN')
	if ((ec = fstatus(fh)) < 0) {
		if (!quiet) errprintf("%s\n", ferrortext(ec))
		return(freturncode(ec))
	}

	if (strmatch(line1, "`LINE1c'")) {
		line1 = bsubstr(line1,1,15) + "." + bsubstr(line1,17,.)
	}
	if (!strmatch(line1, "`LINE1'")) {
		return(st_sig_notanidfile(name,quiet))
	}

	st_vers = strtoreal(bsubstr(line1,13,6)) * 100
	if (st_vers >= .) return(st_sig_notanidfile(name,quiet))

	fh_vers = strtoreal(bsubstr(line1,47,4))
	if (fh_vers > `FHEADERVERSION') {
		return(st_sig_toonew(st_vers, quiet))
	}
	else if (fh_vers < 9) {
		return(st_sig_corrupted(quiet))
	}
	else if (fh_vers==9) {
		ec = _st_freadsignature_v9(fh, name, st_vers, vers, quiet,
						f_vers, f_byteorder, f_date)
	}
	else if (fh_vers==10) {
		ec = _st_freadsignature_v10(fh, name, st_vers, vers, quiet,
						f_vers, f_byteorder, f_date)
	}

	return(ec)
}



/*static*/
`Errcode' _st_freadsignature_v9(`Fildes' fh, string scalar name,
			  real scalar st_vers, real scalar vers,
			  `boolean' quiet, real scalar f_vers,
			  real scalar f_byteorder, real scalar f_date)
{
	`Errcode'	ec
	string scalar	rest, line2, line3, line4, line5, line6
	string scalar	f_name
	string scalar	byteorder
	real scalar	where
	real scalar	restlen

	restlen=`V9LINE2LEN'+`V9LINE3LEN'+`V9LINE4LEN'+`V9LINE5LEN'+`V9LINE6LEN'
	rest = _fread(fh, restlen)
	if ((ec = fstatus(fh)) < 0) {
		if (!quiet) errprintf("%s\n", ferrortext(ec))
		return(freturncode(ec))
	}

	if (strlen(rest) != restlen) {
		return(st_sig_notanidfile(name,quiet))
	}

	line2 = bsubstr(rest,  where=1,                 `V9LINE2LEN')
	line3 = bsubstr(rest,  where=(where+`V9LINE2LEN'),`V9LINE3LEN')
	line4 = bsubstr(rest,  where=(where+`V9LINE3LEN'),`V9LINE4LEN')
	line5 = bsubstr(rest,  where=(where+`V9LINE4LEN'),`V9LINE5LEN')
	line6 = bsubstr(rest,  where=(where+`V9LINE5LEN'),`V9LINE6LEN')

	if (!strmatch(line2, "`V9LINE2'"))
		return(st_sig_notanidfile(name,quiet))
	if (!strmatch(line3, "`V9LINE3'"))
		return(st_sig_notanidfile(name,quiet))
	if (!strmatch(line4, "`V9LINE4'"))
		return(st_sig_notanidfile(name,quiet))
	if (!strmatch(line5, "`V9LINE5'"))
		return(st_sig_notanidfile(name,quiet))

	if (!strmatch(line6, "`V9LINE6'"))
		return(st_sig_translated(quiet))

	if ((f_date = clock(bsubstr(line2,9,18),"DMYhms"))==.) {
		return(st_sig_corrupted(quiet))
	}

	byteorder = bsubstr(line3,14,4)
	if (byteorder=="HILO") f_byteorder = 1
	else 	if (byteorder=="LOHI") f_byteorder = 2
	else 	return(st_sig_corrupted(quiet))


	f_name = strrtrim(bsubstr(line4,13,32))
	if (f_name!=name) {
		if (!quiet) {
			errprintf("file is %s, not %s\n", f_name, name)
		}
		return(-610)
	}

	if ((f_vers = strtoreal(bsubstr(line4,54,4)))==.) {
		return(st_sig_corrupted(quiet))
	}
	if (f_vers > vers) {
		return(st_sig_toonew(st_vers, quiet))
	}

	return(0)
}


/*static*/
`Errcode' _st_freadsignature_v10(`Fildes' fh, string scalar name,
			  real scalar st_vers, real scalar vers,
			  `boolean' quiet, real scalar f_vers,
			  real scalar f_byteorder, real scalar f_date)
{
	`Errcode'	ec
	string scalar	rest, line2, line3, line4, line5, line6
	string scalar	f_name
	string scalar	byteorder
	real scalar	where
	real scalar	restlen

	restlen=`V10LINE2LEN'+`V10LINE3LEN'+`V10LINE4LEN'+`V10LINE5LEN'+
								`V10LINE6LEN'
	rest = _fread(fh, restlen)
	if ((ec = fstatus(fh)) < 0) {
		if (!quiet) errprintf("%s\n", ferrortext(ec))
		return(freturncode(ec))
	}

	if (strlen(rest) != restlen) {
		return(st_sig_notanidfile(name,quiet))
	}

	line2 = bsubstr(rest,  where=1,                   `V10LINE2LEN')
	line3 = bsubstr(rest,  where=(where+`V10LINE2LEN'),`V10LINE3LEN')
	line4 = bsubstr(rest,  where=(where+`V10LINE3LEN'),`V10LINE4LEN')
	line5 = bsubstr(rest,  where=(where+`V10LINE4LEN'),`V10LINE5LEN')
	line6 = bsubstr(rest,  where=(where+`V10LINE5LEN'),`V10LINE6LEN')

	if (!strmatch(line2,"`V10LINE2'"))
		return(st_sig_notanidfile(name,quiet))
	if (!strmatch(line3,"`V10LINE3'"))
		return(st_sig_notanidfile(name,quiet))
	if (!strmatch(line4,"`V10LINE4'"))
		return(st_sig_notanidfile(name,quiet))
	if (!strmatch(line5,"`V10LINE5'"))
		return(st_sig_notanidfile(name,quiet))

	if (!strmatch(line6,"`V10LINE6'"))
		return(st_sig_translated(quiet))

	if ((f_date = clock(bsubstr(line2,9,18),"DMYhms"))==.) {
		return(st_sig_corrupted(quiet))
	}

	byteorder = bsubstr(line3, 14, 4)
	if (byteorder=="HILO") f_byteorder = 1
	else 	if (byteorder=="LOHI") f_byteorder = 2
	else 	return(st_sig_corrupted(quiet))


	f_name = strrtrim(bsubstr(line4,13,32))
	if (f_name!=name) {
		if (!quiet) {
			errprintf("file is %s, not %s\n", f_name, name)
		}
		return(-610)
	}

	if ((f_vers = strtoreal(bsubstr(line4,54,4)))==.) {
		return(st_sig_corrupted(quiet))
	}
	if (f_vers > vers) {
		return(st_sig_toonew(st_vers, quiet))
	}

	return(0)
}



void st_freadsignature(`Fildes' fh, string scalar name,
			  real scalar vers, real scalar f_vers,
			  |real scalar f_byteorder, real scalar f_date)
{
	`Errcode'	ec

	if ((ec = _st_freadsignature(fh, name, vers, 0, f_vers,
					f_byteorder, f_date)) < 0) {
		fclose(fh)
		exit(-ec)
	}
}

/*static*/ `Errcode' st_sig_translated(`boolean' quiet)
{
	if (!quiet) {
		errprintf("{p}\n")
		errprintf("file is corrupt because end-of-line characters\n")
		errprintf("have been translated even though it is a\n")
		errprintf("binary file\n")
		errprintf("{p_end}\n")
	}
	return(-610)
}

/*static*/ `Errcode' st_sig_corrupted(`boolean' quiet)
{
	if (!quiet) {
		errprintf("file is corrupt\n")
	}
	return(-610)
}


/*static*/ `Errcode' st_sig_notanidfile(string scalar name, `boolean' quiet)
{
	if (!quiet) {
		errprintf("file not %s\n", name)
	}
	return(-610)
}

/*static*/ `Errcode' st_sig_toonew(real scalar st_vers, `boolean' quiet)
{
	if (!quiet) {
		errprintf("{p}\n") 
		errprintf("file is from a more recent version of Stata;\n")
		if (st_vers <= stataversion()) {
		    errprintf("you need to update your version; type\n") 
		    errprintf("-update all- and follow the instructions\n")
		}
		else {
		    errprintf("you need to upgrade your Stata;\n")
		    errprintf(`"visit {browse "http://www.stata.com/"}\n"')
		}
		errprintf("{p_end}\n") 
	}
	return(-610)
}


end
