*! version 3.0.1  07jul2000
program define ml_debug 
	version 7
	if "$S_tmode" == "on" {
		di "-> `1' (rest suppressed because S_tmode is on)"
	}
	else	di `"-> `0'"'
	local begin `"capture noisily $ML_vers `0'"'
	local end `"set trace off"'
	set tr on 
	`begin'
	`end'
	exit _rc 
end
