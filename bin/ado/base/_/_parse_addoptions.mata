*! version 1.0.1  02feb2015
version 11.0

/*
	Syntax
        ------

	mata:  _parse_addoptions("<cmdmacro>", "<options>")

	    Inputs:
		<cmdmacro>            name of macro containing Stata cmd
	        <options>             options to be added to end

	    Outputs
		<cmdmacro>            now contains Stata_cmd, <options> 


	Purpose
        -------

	To add Stata options onto the end of any Stata command.

	The only assumption made is that commas (,) appearing outside 
	of binding characters are optionwise significant.  
*/

mata:
void _parse_addoptions(string scalar macroname, string scalar options)
{
	real scalar	i, l, n_commas
	real scalar	n_compound_quotes, n_brackets
	real scalar	in_simple_quotes
	string scalar	c1, c2
	string scalar	cmd

	/* ------------------------------------------------------------ */
	if (strtrim(options)=="") return
	cmd = strtrim(st_local(macroname))
	/* ------------------------------------------------------------ */
					/* just for speed		*/
	if (!strpos(cmd, ",")) {
		st_local(macroname, cmd + ", " + options)
		return
	}

	/* ------------------------------------------------------------ */

	n_commas = in_simple_quotes = n_compound_quotes = n_brackets = 0
	l = strlen(cmd)
	for (i=1; i<=l; i++) { 
		c1 = bsubstr(cmd,   i, 1)
		c2 = bsubstr(cmd, i+1, 1)

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

		if (c1==",") n_commas = !n_commas
		/* ---------------------------------------------------- */
						/* regular character	*/
		/* ---------------------------------------------------- */
	}
	st_local(macroname, cmd + (n_commas ? " " : ", ") + options)
}
end
