*! version 1.1.0  22aug2002
program define _svar_newcns, rclass
	version 8.0
	syntax anything(name=cns id="constraint" equalok)

	constraint free
	local free = r(free)
	constraint define `free' `cns'
	return local new `free'
end

exit

Syntax

	_svar_newcns <cns>

This command defines the constraint in <cns> using -constraint- and the next
free constraint identification number.  The new constraint id number is
returned in `r(new)'.

