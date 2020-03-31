*! version 1.0.2  06nov2002
program define _getfilename, rclass
	version 8

	gettoken pathfile rest : 0
	if `"`rest'"' != "" {
		exit 198
	}

	// get last word in pathfile, with separators \, /, :
	gettoken word rest : pathfile, parse("\/:")
	while `"`rest'"' != "" {
		gettoken word rest : rest, parse("\/:")
	}
	if inlist(`"`word'"', "\", "/", ":") {
		di as err `"incomplete path-filename; ends in separator `word'"'
		exit 198
	}

	return local filename `"`word'"'
end
exit

USAGE
	_getfilename quoted-path


PURPOSE
	returns in the r(filename) the filename from the quoted-path,
	stripping off the directories.

