*! version 5.0.1  24feb2005
program ds
	version 9
	local version : di "version " string(_caller()) ":"
	if (_caller() <= 4) {
		`version' describe, simple
		exit
	}
	else {
		ds_util `0'
		exit
	}
end

