*! version 1.0.3  02feb2015

version 11

/*
	`SS' u_mi_ptrace_ffname(`SS' fn)
		optional utility; returns filename with suffix or 
		unchanged if already has suffix.

	h = u_mi_ptrace_open(filename, {"r"|"w"} [, {0|1}])

		open filename (w/ or w/o suffix) for "r"ead or for "w"rite.
		Last argument relevant for "w" only:  1 -> replace.
		returns `RWhandle' h (may be declared transmorphic).
		Lots of errors are possible; all produce Stata error 
		messages except for call errors.

	void u_mi_ptrace_write_stripes(h, `SS' id, `SS' ystripe, `SS' xstripe)
		Write id and the stripes.  Must do this first.

	void u_mi_ptrace_write_iter(h, m,iter,b,V)
		Write m, iter, b, and V.
		b must be length(ystripe) x length(xstripe)
		V must be length(ystripe) x length(ystripe)
		May be called repeatedly.

	void u_mi_ptrace_close(h)
	void u_mi_ptrace_safeclose(h)
		close file.
		use u_mi_ptrace_safeclose() if calling from Stata.


	To read:
	
	h = u_mi_ptrace_open(filename, {"r"|"w"} [, {0|1}])

	`RS' u_mi_ptrace_get_tc()
	`SS' u_mi_ptrace_get_id()
	`SS' u_mi_ptrace_get_ystripe()
	`SS' u_mi_ptrace_get_xstripe()
	`RS' u_mi_ptrace_get_nrecs()
		may be called in any order and even repeatedly 
		after open for read.

	`RS' u_mi_ptrace_read_iter(h, m,iter,b,V)
		reads iteration, fills in m, iter, b, and V.
		returns 0 (success), 1 (EOF)

	
	void u_mi_ptrace_close(h)  or  u_mi_ptrace_safeclose(h)
*/
	

/* -------------------------------------------------------------------- */
					/* Definitions			*/
/*
	Definition of ptrace file:

	    1.  Signature, first line:
					   29
                                            |
		----+----1----+----2----+----3----+----4---
		ptrace_stata_175234 rrrrrrrr\0

		File version number rr..r is currently sevenspaces and a 1.


	    2.  Signature, second line:
			                 27
                                          |
		----+----1----+----2----+----3----+----4---
                yyyyyyyy yyyyyyyy nnnnnnnn\0
                   |        |         |
                  ny       nx        nrecs

	    3.  Info and Stripes
			`RS' tc				(fputmatrix())
			`SS' id				(fputmatrix())
			`SS' ystripe			(fputmatrix())
			`SS' xstripe			(fputmatrix())

	    4.  Repeated nrecs times:
			 1 x 2  matrix (m, iter)        (fputmatrix())
			ny x nx matrix b		(fputmatrix())
			ny x ny matrix V		(fputmatrix())

	    5.  EOF
*/


local SIGNATURE1 	`"("ptrace_stata_175234        1" + char(0))"'
local LEN_SIGNATURE1	29
local LEN_SIGNATURE2	27
local FILESUFFIX	`"".stptrace""'
local HANDLEDF		u_mi_ptrace_handledf

/* -------------------------------------------------------------------- */
					/* base types			*/
local RS	real scalar
local RV	real vector
local RR	real rowvector
local RC	real colvector
local RM	real matrix
local TM	transmorphic matrix

local SS	string scalar
local SV	string vector
local SR	string rowvector
local SC	string colvector
local SM	string matrix
/* -------------------------------------------------------------------- */
					/* derived types		*/

local Fildes	`RS'
local Code	`RS'
local boolean	`RS'
local 		False	0
local 		True	1

local Status	`Code'
local		READ	1
local		WRITE	2
local 		CLOSED	3

local Wmodifier	`Code'
local		NEWFILE		0
local		REPLACEFILE	1

local RWhandle	struct `HANDLEDF' scalar
local RWhandleinit	`HANDLEF'init


/* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- */


mata:

/*static*/ struct `HANDLEDF' 
{
	`SS'		fname			// file name
	`Status'	fstatus			// READ | WRITE | CLOSED
	`Fildes'	fh			// file handle

	`RS'		nrecs			// number of records written
	`RS'		ny			/* # of tokens of ystripe */
	`RS'		nx			/* # of tokens of xstripe */
	`RS'		tc
	`SS'		id
	`SS'		ystripe
	`SS'		xstripe
	`boolean'	read_eof
	`boolean'	write_stripewritten

	/* ------------------------------------------ status==WRITE --- */
	`boolean'	stripewritten
	/* ------------------------------------------ status==WRITE --- */
	
}
void `RWhandleinit'(`RWhandle' h, `SS' fname)
{
	h.fname               = fname 
	h.fstatus	      = `CLOSED'
	h.fh                  = -1

	h.nrecs               = 0
	h.ny = h.nx           = 0
	h.ystripe = h.xstripe = ""
	h.write_stripewritten = `False'
	h.read_eof	      = `False'
}


/* -------------------------------------------------------------------- */

/*
	`RWhandle' u_mi_ptrace_open(filename, mode [, modifier])

	 Inputs:
		filename	`SS' filename to open, w/ or w/o suffix
		mode		`SS' "r" or "w"
		modifier	`RS' (only if mode=="r") 
					NEWFILE     -> new file (default)
					REPLACEFILE -> replace if existing
	Outputs:
		`RWhandle'	handle for now open file

	Comment:
		Lots of errors are possible; all except call errors 
		produce Stata error messages and nonzero return codes.
*/


`RWhandle' u_mi_ptrace_open(`SS' filename, `SS' mode, |`Wmodifier' modifier)
{
	if (mode=="r") {
		return(u_mi_ptrace_open_existing(filename))
	}
	else if (mode=="w") {
		if (args()==2) modifier = `NEWFILE'
		return(u_mi_ptrace_open_new(filename, modifier))
	}
	else 	_error(3300)
}


/*
	void u_mi_ptrace_safeclose(h)

	Routine to handle Stata instance variable.
	Assumes if h is not 0x0, then it must be an `RWhandle', 
	and closes the file
*/


void u_mi_ptrace_safeclose(transmorphic h)
{
	if (h!=J(0,0,.)) u_mi_ptrace_close(h)
}
		

/*
	void u_mi_ptrace_close(h)

	Inputs:
		handle		`RWhandle' of open file
	Comment:
		closes file.
*/


void u_mi_ptrace_close(`RWhandle' h) {
	`RS'	bk

	if (h.fstatus != `CLOSED') {
		if (h.fstatus==`WRITE') {
			u_mi_ptrace_rewrite_sig(h)
			fseek(h.fh, 0, 1)
		}
		
		bk = setbreakintr(0)
		fclose(h.fh)
		h.fstatus = `CLOSED'
		(void) setbreakintr(bk)
	}
}

/* -------------------------------------------------------------------- */
/*
	void u_mi_ptrace_write_stripes(h, id, ystripe, xtripe)

	Inputs:
		h		`RWhandle' of open file, mode "w"
		id		`SS' containing id or ""
		ystripe		`SS' containing human-readable ystripe
		xstripe		`SS' containing human-readable xstripe

	Comment:
		The stripe must be written immediately after 
		opening the file, and before use  of
		u_mi_ptrace_write_iter().
*/

void u_mi_ptrace_write_stripes(`RWhandle' h, 
					`SS' id, `SS' ystripe, `SS' xstripe)
{
	u_mi_ptrace_assert_wmode(h)

	h.tc = clock(c("current_date")+" "+c("current_time"), "DMYhms")
	h.id = id
	h.ny = cols(tokens(ystripe))
	h.nx = cols(tokens(xstripe))

	fputmatrix(h.fh, h.tc)
	fputmatrix(h.fh, id)
	fputmatrix(h.fh, ystripe)
	fputmatrix(h.fh, xstripe)

	h.write_stripewritten = `True'
}

/*
	void u_mi_ptrace_write_iter(h, m, iter, b, V)

	Inputs:
		h		`RWhandle' of open file, mode "w"
		m		`RS' m to be written
		iter		`RS' iteration # to be written
		b		`RM' coefficient matrix to be written
		V		`RM' variance matrix
		
	Comment:
		Errors are possible but highly unlikely.
		Call sequence is 

			h = u_mi_ptrace_open(filename, "w")
			u_mi_ptrace_write_stripe(h, ystripe, xtripe)

			u_mi_ptrace_write_iter(h, ...)
			u_mi_ptrace_write_iter(h, ...)
			...
			u_mi_ptrace_write_iter(h, ...)
			u_mi_ptrace_safeclose(h)  (or _close() if Mata)
*/


void u_mi_ptrace_write_iter(`RWhandle' h, `RS' m, `RS' iter, `RM' b, `RM' V)
{
	u_mi_ptrace_assert_wmode(h)

	if (!(h.write_stripewritten)) _error("stripe not yet written")

	if (rows(b)!=h.ny | cols(b)!=h.nx) _error(3200)
	if (rows(V)!=h.ny | cols(V)!=h.ny) _error(3200)

	fputmatrix(h.fh, (m, iter))
	fputmatrix(h.fh, b)
	fputmatrix(h.fh, vech(V))

	(void) ++(h.nrecs)
}



/* -------------------------------------------------------------------- */

`SS' u_mi_ptrace_get_id(`RWhandle' h)
{
	u_mi_ptrace_assert_rmode(h)
	return(h.id)
}

`RS' u_mi_ptrace_get_tc(`RWhandle' h)
{
	u_mi_ptrace_assert_rmode(h)
	return(h.tc)
}

`SS' u_mi_ptrace_get_ystripe(`RWhandle' h)
{
	u_mi_ptrace_assert_rmode(h)
	return(h.ystripe)
}
	
`SS' u_mi_ptrace_get_xstripe(`RWhandle' h)
{
	u_mi_ptrace_assert_rmode(h)
	return(h.xstripe)
}

`RS' u_mi_ptrace_get_nrecs(`RWhandle' h)
{
	u_mi_ptrace_assert_rmode(h)
	return(h.nrecs)
}


/*
	`RS' u_mi_ptrace_read_iter(h, m, iter, b, V)
	
	Inputs:
		h		`RWhandle' of open file, mode "r"
	Outputs
		m		`RS' m
		iter		`RS' iter
		b		`RM' b
		V		`RM' V
		/returns/	 0 = record read
				 1 = no record read / EOF
*/

`RS' u_mi_ptrace_read_iter(`RWhandle' h, m, iter, b, V)
{
	`RM'	EOF
	`RV'	vec

	u_mi_ptrace_assert_rmode(h)

	if (h.read_eof) return(1) 

	EOF = J(0, 0, .)
	if ((vec=fgetmatrix(h.fh))==EOF) {
		h.read_eof = `True' 
		return(1)
	}
	m    = vec[1]
	iter = vec[2]

	if ((b=fgetmatrix(h.fh))!=EOF) {
		if ((V=fgetmatrix(h.fh))!=EOF) {
			V = invvech(V)
			return(0)
		}
	}
	u_mi_ptrace_eof_error(h)
	/*NOTREACHED*/
}

/*static*/ void u_mi_ptrace_eof_error(`RWhandle' h)
{
	errprintf("{p 0 4 2}\n") 
	errprintf("%s:\n", h.fname)
	errprintf("unexpected end-of-file\n")
	errprintf("{p_end}\n")
	u_mi_ptrace_close(h)
	exit(612)
	/*NOTREACHED*/
}



/* -------------------------------------------------------------------- */
/*
	`SS' u_mi_ptrace_ffname(filename)

	Inputs:
		filename		filename, w/ or w/o suffix
	Outputs:
		/returns/		filename, w/ suffix
*/

/*static*/ `SS' u_mi_ptrace_ffname(`SS' filename)
{
	return(pathsuffix(filename)=="" ? filename+`FILESUFFIX' : filename)
}




/* -------------------------------------------------------------------- */
/*
	void u_mi_ptrace_rewrite_sig(h)

	Inputs:
		h			`RWhandle', opened mode "w"

	Comments:
		rewrites signature based on current values in h.
		called before closing the file when file mode is "w"
*/


/*static*/ void u_mi_ptrace_rewrite_sig(`RWhandle' h)
{
	fseek(h.fh, 0, -1)		// start of file
	fwrite(h.fh, `SIGNATURE1')
	fwrite(h.fh, sprintf("%8.0f %8.0f %8.0f", h.ny, h.nx, h.nrecs) + 
								char(0))
}



/* -------------------------------------------------------------------- */
/*static*/ `RWhandle' u_mi_ptrace_open_new(`SS' filename, `Wmodifier' modifier)
{
	`RWhandle'	h

	`RWhandleinit'(h, u_mi_ptrace_ffname(filename))

	if (fileexists(h.fname)) {
		if (modifier==`REPLACEFILE') unlink(h.fname)
		else {
			errprintf("file %s already exists\n", h.fname)
			exit(602)
			/*NOTREACHED*/
		}
	}

	h.fh     = my_fopen(h.fname, "rw")
	h.fstatus = `WRITE'
	u_mi_ptrace_rewrite_sig(h)
	return(h)
}

/* static */ `Fildes' my_fopen(`SS' filename, `SS' mode) 
{
	`Fildes'	h
	`SS'		errtxt
	`boolean'	found


	if ((h = _fopen(filename, mode)) >= 0) return(h) 

	found = `True'

	if      (h == -601) 	errtxt = "file %s not found\n"
	else if (h == -602)	errtxt = "file %s already exists\n"
	else if (h == -603)	errtxt = "file %s could not be opened\n"
	else if (h == -608)     errtxt = "file %s is read-only\n"
	else if (h == -692)	errtxt = "file %s I/O error\n"
	else {
		errtxt = "file %s error\n"
		found = `False'
	}

	errprintf(errtxt, filename)
	if (found) exit(-h)
	error(-h)
}


/* static */ `RWhandle' u_mi_ptrace_open_existing(`SS' filename)
{
	`RWhandle'	h
	`SS'		line
	`RM'		EOF
	`TM'		w

	`RWhandleinit'(h, u_mi_ptrace_ffname(filename))

	if (!fileexists(h.fname)) {
		errprintf("file %s not found\n", h.fname)
		exit(601)
		/*NOTREACHED*/
	}

	h.fh      = my_fopen(h.fname, "r")
	h.fstatus = `READ'
	
	if (fread(h.fh, `LEN_SIGNATURE1') != `SIGNATURE1') {
		u_mi_ptrace_err_notptrace(h)
		/*NOTREACHED*/
	}

	line = fread(h.fh, `LEN_SIGNATURE2')
	if (bsubstr(line, `LEN_SIGNATURE2', 1)!=char(0)) {
		u_mi_ptrace_err_notptrace(h)
		/*NOTREACHED*/
	}
	h.ny       = strtoreal(bsubstr(line, 1, 8))
	h.nx       = strtoreal(bsubstr(line, 10, 8))
	h.nrecs    = strtoreal(bsubstr(line, 19, 8))

	h.stripewritten = `True'
	EOF = J(0, 0, .)

	if ((w=fgetmatrix(h.fh)) == EOF) u_mi_ptrace_eof_error(h)
	h.tc = w
	if ((w=fgetmatrix(h.fh)) == EOF) u_mi_ptrace_eof_error(h)
	h.id = w

	if ((h.ystripe = fgetmatrix(h.fh))!=EOF) {
		if ((h.xstripe = fgetmatrix(h.fh))!=EOF) return(h)
	}
	u_mi_ptrace_eof_error(h)
	/*NOTREACHED*/
}
	

/*static*/ void u_mi_ptrace_err_notptrace(`RWhandle' h)
{
	`RS'	bk

	if (h.fstatus != `CLOSED') {
		bk = setbreakintr(0)
		(void) _fclose(h.fh)
		h.fstatus = `CLOSED'
		(void) setbreakintr(bk)
	}
	errprintf("file %s not ptrace format\n", h.fname)
	exit(610)
	/*NOTREACHED*/
}

void u_mi_ptrace_assert_wmode(`RWhandle' h)
{
	if (h.fstatus==`WRITE') return

	if (h.fstatus==`CLOSED') {
		errprintf("attempt to write closed ptrace file\n")
	}
	else if (h.fstatus==`READ') {
		errprintf("{p 0 4 2}j\n")
		errprintf("%s:\n", h.fname)
		errprintf("attempt to write file opened for read\n")
		errprintf("{p_end}\n")
		u_mi_ptrace_close(h)
	}
	exit(119)
	/*NOTREACHED*/
}
		
void u_mi_ptrace_assert_rmode(`RWhandle' h)
{
	if (h.fstatus==`READ') return

	if (h.fstatus==`CLOSED') {
		errprintf("attempt to read closed ptrace file\n")
	}
	else if (h.fstatus==`WRITE') {
		errprintf("{p 0 4 2}j\n")
		errprintf("%s:\n", h.fname)
		errprintf("attempt to read file opened for write\n")
		errprintf("{p_end}\n")
		u_mi_ptrace_close(h)
	}
	exit(119)
	/*NOTREACHED*/
}

/* -------------------------------------------------------------------- */
end
