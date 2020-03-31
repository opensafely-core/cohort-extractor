*! version 6.0.0  09apr1998
program define _mfrmvec
	version 6

	tokenize `"`0'"', parse(" :,")
	if "`2'" != ":" {
		di in red "_mfrmvec expects -- new_matrix : existing_matrix"
		exit 198
	}

	local M "`1'"
	local Mvec "`3'"
	mac shift 3

	local 0 `"`*'"'
	syntax [ , Rows(integer -1) Columns(integer -1) ]

	local vecrows = rowsof(`Mvec')
	if "`rows'" != "-1" {
		local chunk = `rows'
		capture confirm integer number `chunk'
		if _rc != 0 {
			di in red "conformability error, _mfrmvec"
			exit 503
		}

		if "`columns'" != "-1" {
			if `vecrows' / `columns' != `chunk' {
				di in red "row and columns options incompatible, _mvecfrm"
				exit 198
			}
		}
	} 
	else {
		if "`columns'" == "-1" {
			di in red "Must specify rows or columns, _mfrmvec"
			exit 198
		}

		local chunk = `vecrows' / `columns'
	}

	mat `M' = `Mvec'[1..`chunk', 1]
	local cur = 1 + `chunk'
	local j 2
	while `cur' <= `vecrows' {
		mat `M' = `M' , `Mvec'[`cur'..`cur'+`chunk'-1 , 1]
		local cur = `cur' + `chunk'
	}

end

exit

     _mfrmvec M : Mvec , rows(#) | columns(#)

