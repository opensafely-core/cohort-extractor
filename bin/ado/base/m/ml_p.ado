*! version 1.0.2  12sep2018
program ml_p
	version 9
	local version : di "version " string(_caller()) ":"
	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		if `"`e(opt)'"' == "ml" {
			`version' ml score `0'
		}
		else {
			`version' mopt score `0'
		}
		exit
	}
	`version' _predict `0'
end
exit
