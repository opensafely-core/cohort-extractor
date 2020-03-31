*! version 1.1.1  12jun1998
program define nlinit
	version 6
	local val `1'
	confirm number `val'
	mac shift 
	while "`1'"!="" {
		global `1' `val'
		mac shift
	}
end
