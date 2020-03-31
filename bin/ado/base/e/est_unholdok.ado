*! version 1.0.0  22apr2002
program est_unholdok
	args name 

	capt confirm byte var _est_`name'
	if _rc {
		di as err "variable _est_`name' is missing"
		di as err "impossible to unhold results stored under `name'"
		exit 198
	}
end

