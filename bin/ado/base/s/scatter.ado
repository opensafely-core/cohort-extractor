*! version 1.2.0  16apr2007
program define scatter

	if      (_caller() < 8.2)  version 8
	else if (_caller() < 10 )  version 8.2
	else			   version 10

	if `"`0'"' == `""' {
		graph `0'				// replay
	}
	else {
		graph twoway scatter `0'
	}
end
