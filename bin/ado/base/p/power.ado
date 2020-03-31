*! version 1.2.0  15dec2017
program power
	version 13
	local version : di "version " string(_caller()) ":"
	tempname rhold
	_return hold `rhold'
	_parse comma lhs rhs : 0
        if (`"`rhs'"' == "") {
                cap noi `version' _power_rsafe `0', type(test)
        }
        else {
                cap noi `version' _power_rsafe `0' type(test)
        }
	if (_rc) {
		_return restore `rhold'
		exit _rc
	}
	sreturn clear
end
