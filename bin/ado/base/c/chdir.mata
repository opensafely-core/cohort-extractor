*! version 1.0.1  15dec2004
version 9.0
mata:

void chdir(string scalar path)
{
	if (_chdir(path)) { 
		errprintf("could not change to directory %s\n", path)
		_error(170, "could not change directory")
		/*NOTREACHED*/
	}
}

end
