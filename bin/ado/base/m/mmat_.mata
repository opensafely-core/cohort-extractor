*! version 1.0.2  06nov2017
version 9.0

/*
	: mata matsave 
	: mata matuse 
	: mata matdescribe 

	are implemented by ado-files mata_matsave.ado, mata_matuse.ado, 
	and mata_matdescribe.ado.  Those ado-files call mmat_save(), 
	mmat_use(), and mmat_describe.
*/

local	MMAT_SUFFIX		`"".mmat""'
local	MMAT_SIGNATURE		`"(char((14, 87, 03, 01)) + "mmat")"'
local	MMAT_VER		`"(char(0) + char(1))"'

mata:

void mmat_save(string scalar fn, string scalar names, string scalar replace)
{
	real scalar		fh, i
	string colvector	name
	pointer colvector	p 
	string scalar		signature, ver, datetime

	/* ------------------------------------------------------------ */
	name = mmat_expandlist(names)
	/* ------------------------------------------------------------ */
	if (pathsuffix(fn)=="") fn = fn + `MMAT_SUFFIX'
	if (replace=="") {
		if (fileexists(fn)) {
			errprintf("file %s already exists\n", fn)
			exit(602)
		}
	}
	else {
		if (_unlink(fn)<0) {
			errprintf("file %s could not be replaced\n", fn)
			exit(693)
		}
	}
	/* ------------------------------------------------------------ */
	displayas("text")
	printf("{p 0 1 2}\n")
	printf("(saving\n") 
	p = J(rows(name), 1, NULL)
	for (i=1; i<=rows(name); i++) {
		p[i] = findexternal(name[i])
		printf("%s", name[i])
		if (rows(*(p[i]))!=1 | cols(*(p[i]))!=1) {
			printf("[%g,%g]", rows(*(p[i])), cols(*(p[i])))
		}
		printf(i<rows(name) ? ",\n" : ")\n")
	}
	printf("{p_end}\n")
	/* ------------------------------------------------------------ */
	signature = `MMAT_SIGNATURE'
	ver       = `MMAT_VER'
	datetime  = c("current_date") + " " + c("current_time")
	assert(strlen(datetime)==20)

	if ((fh = _fopen(fn, "w"))<0) {
		errprintf("file %s could not be opened for output\n", fn)
		exit(603)
	}

	if (_fwrite(fh, signature)<0) mmat_writeerror(fh, fn)
	if (_fwrite(fh, ver      )<0) mmat_writeerror(fh, fn)
	if (_fwrite(fh, datetime )<0) mmat_writeerror(fh, fn)

	if (_fputmatrix(fh, name)<0) mmat_writeerror(fh, fn)
	if (_fputmatrix(fh, p)<0) mmat_writeerror(fh, fn)
	if (_fclose(fh)<0) mmat_writeerror(fh, fn)
	/* ------------------------------------------------------------ */
	printf("{txt:file %s saved}\n", fn)
}



void mmat_use(string scalar fn, string scalar replace)
{
	real scalar		fh, err, i
	string colvector	name
	pointer colvector	p 
	transmorphic matrix	isnew
	string scalar		signature, ver
	
	if (pathsuffix(fn)=="") fn = fn + `MMAT_SUFFIX'

	if (!fileexists(fn)) {
		errprintf("file %s not found\n", fn) 
		exit(601)
	}

	/* ------------------------------------------------------------ */
	if ((fh = _fopen(fn, "r"))<0) {
		errprintf("file %s could not be opened for input", fn)
		exit(603)
	}

	signature = `MMAT_SIGNATURE'
	ver       = `MMAT_VER'

	if (_fread(fh, strlen(signature)) != signature) {
		errprintf("file %s not .mmat-format file\n", fn)
		(void) _fclose(fh)
		exit(610)
	}
	if (_fread(fh, strlen(ver)) != ver) {
		errprintf("file %s from more recent version of Stata\n", fn)
		(void) _fclose(fh)
		exit(610)
	}
	if (_fread(fh, 20)==J(0,0,"")) mmat_readerror(fh, fn)
	/* ------------------------------------------------------------ */

	if ((name = _fgetmatrix(fh)) == J(0,0,.)) mmat_readerror(fh, fn)

	/* ------------------------------------------------------------ */
	if (replace=="") {
		err = 0
		for (i=1; i<=rows(name); i++) {
			if (findexternal(name[i])) {
				errprintf("global %s already exists\n", name[i])
				err = 1 
			}
		}
		if (err) {
			errprintf("nothing loaded\n")
			(void) _fclose(fh)
			exit(110)
		}
	}
	/* ------------------------------------------------------------ */

	if ((p = _fgetmatrix(fh)) == J(0,0,.)) mmat_readerror(fh, fn)
	(void) _fclose(fh)

	/* ------------------------------------------------------------ */
	displayas("text")
	printf("{p 0 1 2}\n")
	printf("(loading\n")
	for (i=1; i<=rows(name); i++) {
		rmexternal(name[i])
		isnew = crexternal(name[i])
		swap(*isnew, *(p[i]))
		printf("%s", name[i])
		if (rows(*isnew)!=1 | cols(*isnew)!=1) {
			printf("[%g,%g]", rows(*isnew), cols(*isnew))
		}
		printf(i==rows(name) ? ")\n" : ",\n")
	}
	printf("{p_end}\n")
}


void mmat_describe(string scalar fn)
{
	real scalar		fh, i
	string colvector	name
	string scalar		signature, ver, datetime
	
	if (pathsuffix(fn)=="") fn = fn + `MMAT_SUFFIX'

	if (!fileexists(fn)) {
		errprintf("file %s not found\n", fn) 
		exit(601)
	}

	/* ------------------------------------------------------------ */
	if ((fh = _fopen(fn, "r"))<0) {
		errprintf("file %s could not be opened for input", fn)
		exit(603)
	}

	signature = `MMAT_SIGNATURE'
	ver       = `MMAT_VER'

	if (_fread(fh, strlen(signature)) != signature) {
		errprintf("file %s not .mmat-format file\n", fn)
		(void) _fclose(fh)
		exit(610)
	}
	if (_fread(fh, strlen(ver)) != ver) {
		errprintf("file %s from more recent version of Stata\n", fn)
		(void) _fclose(fh)
		exit(610)
	}
	if ((datetime=_fread(fh, 20))==J(0,0,"")) mmat_readerror(fh, fn)
	/* ------------------------------------------------------------ */

	if ((name = _fgetmatrix(fh)) == J(0,0,.)) mmat_readerror(fh, fn)
	(void) _fclose(fh)
	/* ------------------------------------------------------------ */

	displayas("text")
	printf("{p 2 2 2}\n")
	printf("file %s saved on %s contains\n", fn, datetime)
	for (i=1; i<=rows(name); i++) {
		printf("%s", name[i])
		printf(i==rows(name) ? "\n" : ",\n")
	}
	printf("{p_end}\n")
}


string colvector mmat_expandlist(string scalar base)
{
	real scalar		i
	string  rowvector	tok
	string colvector	res, toadd

	/* ------------------------------------------------------------ */
	if (base=="") {
		errprintf("nothing found where matrix namelist expected\n")
		exit(198)
	}
	/* ------------------------------------------------------------ */
	res = J(0,1,"")
	tok = tokens(base)
	for (i=1; i<=cols(tok); i++) {
		if (strpos(tok[i], "*") | strpos(tok[i], "?")) {
			if ((toadd = direxternal(tok[i]))==J(0,1,"")) {
				errprintf("matrix %s not found\n", tok[i])
				exit(111)
			}
			res = res \ toadd
		}
		else {
			if (findexternal(tok[i])==NULL) {
				errprintf("matrix %s not found\n", tok[i]) ;
				exit(198)
			}
			res = res \ tok[i]
		}
	}
	return(uniqrows(res))
}
			
void mmat_writeerror(real scalar fh, string scalar fn)
{
	errprintf("error writing file %s", fn) 
	(void) _fclose(fh)
	(void) _unlink(fh)
	exit(693)
}
	
void mmat_readerror(real scalar fh, string scalar fn)
{
	errprintf("error reading file %s\n", fn) 
	(void) _fclose(fh)
	exit(692)
}
	
end
