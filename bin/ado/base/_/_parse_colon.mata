*! version 1.0.1  02feb2015
version 11.0

/*
	Syntax
        ------

	mata:  _parse_colon("hascolon", "rhscmd")

	    Inputs:
		Stata local macro     0

	    Outputs
		Stata local macro     0
	        Stata local macro     hascolon
	        Stata local macro     rhscmd

	Purpose
        -------

        _parse_colon() is useful for implementing in ado code Stata prefix
         commands that have syntax:

		<prefixcmd> [<anything>] [: <anything>]

        where <anything> is anything including nothing.

        _parse_colon("hascolon", "rhscmd") parses `0' and returns 
        `hascolon', `rhscmd', and `0'.


        Returned results 
        ----------------

	    `hascolon'  contains 1 if `0' included a colon, and 0 otherwise

	    `0'         is reset to contain the original `0' up to but 
                        not including the colon.

            `subcmd'    is set to contain `0' following the colon or to 
                        contain nothing.

        Note 1:  This routine never returns an error.

	Note 2:  As written, this routine will match any open bracket 
        to any close bracket.  That will not matter because subsequent 
        parsing will fix the mistake, but this routine could easily
        be fixed.

*/

mata:
void _parse_colon(string scalar hascolon, string scalar subcmd)
{
	real scalar	i, l
	real scalar	n_compound_quotes, n_brackets
	real scalar	in_simple_quotes
	string scalar	orig, c1, c2

	/* ------------------------------------------------------------ */
					/* just for speed		*/
        if (!(strpos(orig = strtrim(st_local("0")), ":"))) {
		st_local(hascolon, "0")
		st_local(subcmd, "")
		return
	}
	/* ------------------------------------------------------------ */

			
	in_simple_quotes = n_compound_quotes = n_brackets = 0
	l = strlen(orig)
	for (i=1; i<=l; i++) { 
		c1 = bsubstr(orig,   i, 1)
		c2 = bsubstr(orig, i+1, 1)

		/* ---------------------------------------------------- */
						/* quotes		*/ 
		if (c1=="`" & c2==`"""') {
			if (!in_simple_quotes) {
				++n_compound_quotes
				++i
			}
			continue
		}

		if (n_compound_quotes) {
			if (c1==`"""' & c2=="'") {
				--n_compound_quotes
				++i
				continue
			}
		}
		else {
			if (c1==`"""') { 
				in_simple_quotes = !in_simple_quotes
				continue
			}
			else if (in_simple_quotes) continue
		}
		/* ---------------------------------------------------- */
						/* not in quotes	*/
		if (strpos("([{", c1)) {
			++n_brackets
			continue
		}
		if (n_brackets) { 
			if (strpos(")]}", c1)) --n_brackets
			continue
		}
		/* ---------------------------------------------------- */
						/* not in brackets	*/

		if (c1==":") { 
			st_local(hascolon, "1")
			st_local("0",      strrtrim(bsubstr(orig,   1, i-1)))
			st_local(subcmd,   strltrim(bsubstr(orig, i+1,   .)))
			return
			/*NOTREACHED*/
		}
		/* ---------------------------------------------------- */
						/* regular character	*/
		/* ---------------------------------------------------- */
	}
	st_local(hascolon, "0")
	st_local(subcmd, "")
}

end
