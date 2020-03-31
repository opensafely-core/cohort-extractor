*! version 1.0.0  24mar2007
program discrim_logistic_estat, rclass
	version 10

	if "`e(cmd)'" != "discrim" & "`e(subcmd)'" != "logistic" {
		error 301
	}

	gettoken key rest : 0, parse(", ")
	local lkey = length(`"`key'"')
	if `"`key'"' == "ic" | `"`key'"' ==  "vce" {
		// ic and vce are allowed since we have e(V) and e(ll)
		estat_default `0'
	}
	else {	// turn control over for remaining common subcommands
		discrim_estat_common `0'
	}

	return add
end
