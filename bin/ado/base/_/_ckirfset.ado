*! version 1.0.2  18jun2004
program define _ckirfset
	version 8.2

	syntax , [ set(string) ]

	if `"`set'"' == "" {
		exit
	}
	else {
		varirf set `set' 
	}
	local fname `"$S_vrffile"' 
	if "`fname'" == "" {
		di as err "no irf file active"	
		di as err "specify set() option or use irf set command"	
		exit 198
	}

end

exit
