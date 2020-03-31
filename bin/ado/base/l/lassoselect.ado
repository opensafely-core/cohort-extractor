*! version 1.0.1  29jan2019
program lassoselect
	version 16.0

	if (`"`e(select_cmd)'"' == "") {
		error 301
	}

	
	local select_cmd `e(select_cmd)'

	`select_cmd' `0'
end
