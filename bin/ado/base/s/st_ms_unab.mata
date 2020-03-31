*! version 1.0.0  05mar2013

mata:

void st_ms_unab(string scalar spec)
{
	real	scalar	rc

	rc = _st_ms_unab(spec, 1)
	if (rc) exit(rc)
}

end
exit
