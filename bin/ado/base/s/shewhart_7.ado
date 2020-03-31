*! version 2.1.5  28sep2004
program define shewhart_7
	version 6, missing
	syntax varlist(min=2) [if] [in] [, SAVing(passthru) BATCH * ]
	tempfile shew1 shew2 shew3

	local wasgr : set graphics
	local wasmore : set more

	capture { 
		set graphics off
		set more 1

		xchart `varlist' `if' `in', `options' saving(`"`shew1'"')
		rchart `varlist' `if' `in', `options' saving(`"`shew2'"')
		gr7 using, saving(`"`shew3'"')
		set graphics `wasgr'
		set more `wasmore'
		gr7 using `"`shew1'"' `"`shew3'"' `"`shew2'"', `saving'
	}
	local rc=_rc
	set graphics `wasgr'
	set more `wasmore'
	error `rc'
end
