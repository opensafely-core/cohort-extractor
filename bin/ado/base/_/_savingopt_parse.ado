*! version 1.0.0  30jun2009

/*
	_savingopt_parse <mfname> <mreplace> : <opname> "<ext>" `"<contents>'"

	where <contents> contains	<nothing>
					<filename>
					<filename>, replace

	return full filename in local <mfilename> and 
	return "replace" or "" in local <mreplace>
*/

program _savingopt_parse
	version 11
	args mfilename mreplace  colon  opname ext contents

	if (`"`contents'"'=="") {
		c_local `mfilename'
		c_local `mreplace'
		exit
	}

	gettoken filename rest : contents, parse(" ,")
	mata: fixfilename("filename","`ext'")
	c_local `mfilename' `"`filename'"'
	c_local `mreplace'

	gettoken comma rest : rest, parse(" ,")
	if ("`comma'"=="") {
		exit
	}
	if ("`comma'"==",") {
		gettoken option rest : rest, parse(" ,")
	 	if ("`option'"=="") {
			exit
		}
		if ("`option'"=="replace") {
			c_local `mreplace' replace
			gettoken nothing rest : rest, parse(" ,")
			if ("`nothing'"=="") {
				exit
			}
		}
	}
	di as smcl as err "{bf:`opname'()} invalid syntax"
	exit 198
end

mata:
version 11
void fixfilename(string scalar macname, string scalar extension)
{
	string scalar	filename

	filename = st_local(macname)
	if (pathsuffix(filename)=="") filename = filename + extension
	st_local(macname, filename)
}
end
