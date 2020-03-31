*! version 1.0.0  15dec2004
version 9.0

mata:

void rmdir(string scalar dirpath)
{
	if (_rmdir(dirpath)) {
		errprintf("could not create directory %s\n", dirpath)
		_error(693, "could not remove directory")
		/*NOTREACHED*/
	}
}

end
