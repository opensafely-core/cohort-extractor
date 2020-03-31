*! version 6.0.0  09apr1998
program define _mvec
	version 6

	tokenize `"`0'"', parse(" :")
	if "`2'" != ":" {
		di in red "_mvec expects -- new_matrix : existing_matrix"
		exit 198
	}

	local Mvec "`1'"
	local M "`3'"

	local cols = colsof(`M')
	mat `Mvec' = `M'[1..., 1]
	local j 2
	while `j' <= `cols' {
		mat `Mvec' = `Mvec' \ `M'[1..., `j']
		local j = `j' + 1
	}

end
