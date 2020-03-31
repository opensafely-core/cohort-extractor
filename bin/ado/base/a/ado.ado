*! version 1.0.0  21nov2018
program define ado
	version 15
	local version : di "version " string(_caller()) ":"

	gettoken key 0m1 : 0, parse(" ,:")

	if `"`key'"' == "update" {
		adoupdate `0m1'
		exit
	}

	`version' _ado `0'
end
