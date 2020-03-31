*! version 1.0.2  10mar2005
version 9.0

mata:

void mkdir(string scalar dirpath, |real scalar ispublic)
{
	if (args()==1) ispublic = 0
	if (_mkdir(dirpath, ispublic)) {
		errprintf("could not create directory %s\n", dirpath)
		_error(693, "could not create directory")
		/*NOTREACHED*/
	}
}

end
