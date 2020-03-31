*! version 1.1.0  05sep2014

program mswitch, eclass byable(onecall)
	version 14.0

	if _by() {
		local by `"by `_byvars' `_byrc0':"'
	}
	if replay() {
		if _by() {
			error 190
		}
		if ("`e(cmd)'"!="mswitch" | "`e(_cmd_comp)'"=="") {
			error 301
		}
		if ("`0'"=="") _mswitch_print `e(cmdline)'
		else _mswitch_print `0'
		exit
	}

	`by' _mswitch `0'

end
