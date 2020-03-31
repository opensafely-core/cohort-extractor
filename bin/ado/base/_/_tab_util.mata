*! version 1.0.0  18may2010
version 11

mata:

string scalar _tab_check_color(string scalar color)
{
	if (any(strmatch(color, tokens("text txt green")))) {
		return("text")
	}
	if (any(strmatch(color, tokens("error err red")))) {
		return("error")
	}
	if (any(strmatch(color, tokens("input inp yellow")))) {
		return("input")
	}
	if (any(strmatch(color, tokens("result res white")))) {
		return("result")
	}
	errprintf("invalid color specification\n")
	exit(198)
}

void _tab_check_nformat(string scalar format)
{
	if (!st_isnumfmt(format)) {
		errprintf("invalid numeric format\n")
		exit(198)
	}
}

void _tab_check_sformat(string scalar format)
{
	real	scalar	rc

	rc = missing(fmtwidth(format))
	if (rc == 0) {
		rc = !st_isstrfmt(format)
	}
	if (rc) {
		errprintf("invalid string format\n")
		exit(198)
	}
}

end
