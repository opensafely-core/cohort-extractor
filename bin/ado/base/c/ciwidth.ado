*! version 1.0.0  05june2018
program ciwidth
	version 16
	local version : di "version " string(_caller()) ":"
	tempname rhold
	_return hold `rhold'
	_parse comma lhs rhs : 0
	if (`"`rhs'"' == "") {
		cap noi `version' _power_rsafe `0', type(ci)
	}
	else {
		cap noi `version' _power_rsafe `0' type(ci)
	}
	if (_rc) {
		_return restore `rhold'
		exit _rc
	}
	sreturn clear
end
