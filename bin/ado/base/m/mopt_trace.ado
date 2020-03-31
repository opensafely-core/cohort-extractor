*! version 1.0.0  26jul2007
program mopt_trace
	version 10
	if "$S_tmode" == "on" {
		di "-> `1' (rest suppressed because S_tmode is on)"
	}
	else	di `"-> `0'"'
	local vv : di "version " string(_caller()) ":"
	local begin	`"capture noisily `vv' `0'"'
	local end 	`"set trace off"'
	set trace on
	`begin'
	`end'
	exit c(rc)
end
