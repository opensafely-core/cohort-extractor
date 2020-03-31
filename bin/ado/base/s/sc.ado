*! version 1.2.0  16apr2007
program define sc

	if      (_caller() < 8.2)  version 8
	else if (_caller() < 10 )  version 8.2
	else			   version 10

	scatter `0'
end
