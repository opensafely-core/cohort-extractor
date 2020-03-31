*! version 1.1.1  17may2012

version 10

mata:

real scalar st_fopen(string scalar filepath, string scalar suffix, 
	             string scalar mode, 
		    |real scalar replace, real scalar publicf)
{
	real scalar	fd
	real scalar	errcode
	real scalar	repl

	if (pathsuffix(filepath) == "") filepath = filepath + suffix

	/* ------------------------------------------------------------ */
	if (mode=="r") {
		if ((fd = _fopen(filepath, "r")) >= 0) return(fd) 
		if (fd == -601) { 
			errprintf("file %s not found\n", filepath) 
			exit(601)
			/*NOTREACHED*/
		}
		errprintf("file %s could not be opened\n", filepath)
		exit(-fd)
		/*NOTREACHED*/
	}

	if (mode=="rw") {
		repl = (replace<. ? replace : 0)
		if (repl) {
			if (fileexists(filepath)) {
				if (abs(repl)==1) {
				    if (errcode=_unlink(filepath)) {
					errprintf(
					    "file %s could not be erased\n", 
					    filepath)
					exit(-errcode)
					/*NOTREACHED*/
				    }
				}
			}
			else if (repl>0) {
				printf("{txt}(note: file %s not found)\n",
					 filepath)
			}
		}
		else {
			if (fileexists(filepath)) {
				errprintf("file %s already exists\n", filepath)
				exit(602)
				/*NOTREACHED*/
			}
		}

		if ((fd = _fopen(filepath, "rw", publicf)) >= 0) return(fd) 
		errprintf("file %s could not be opened\n", filepath)
		exit(-fd) 
		/*NOTREACHED*/
	}

	/* ------------------------------------------------------------ */
	if (mode=="w") {
		repl = (replace<. ? replace : 0)
		if (repl) {
			if (fileexists(filepath)) {
				if (errcode=_unlink(filepath)) {
					errprintf(
					    "file %s could not be erased\n", 
					    filepath)
					exit(-errcode)
					/*NOTREACHED*/
				}
			}
			else if (repl>0) {
				printf("{txt}(note: file %s not found)\n",
					 filepath)
			}
		}
		else {
			if (fileexists(filepath)) {
				errprintf("file %s already exists\n", filepath)
				exit(602)
				/*NOTREACHED*/
			}
		}

		if ((fd = _fopen(filepath, "w", publicf)) >= 0) return(fd) 
		errprintf("file %s could not be opened for output\n", filepath)
		exit(-fd) 
		/*NOTREACHED*/
	}
	/* ------------------------------------------------------------ */
	_error("mode must be r or w")
	/*NOTREACHED*/
}

end
