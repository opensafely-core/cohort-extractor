*! version 6.0.0  20nov1997
program define st_show
* touched by jwh 
	version 6.0

	if _caller()>=6 {

		st_is 2 full
		if "`1'" == "noshow" | `"`_dta[st_show]'"' != "" {
			exit 
		}

		di


		di _col(10) in gr "failure _d:  " _c
		if `"`_dta[st_bd]'"' != "" {
			if `"`_dta[st_ev]'"' != "" {
				di in ye `"`_dta[st_bd]' == `_dta[st_ev]'"'
			}
			else	di in ye `"`_dta[st_bd]'"'
		}
		else	di in ye "1" in gr " (meaning all fail)"

		di in gr _col(4) "analysis time _t:  " _c
		if `"`_dta[st_orig]'"' != "" {
			di in ye `"(`_dta[st_bt]'-origin)"' _c
		}
		else	di in ye `"`_dta[st_bt]'"' _c 
		if `"`_dta[st_bs]'"' != "1" {
			di in ye `"/`_dta[st_bs]'"'
		}
		else	di

		if `"`_dta[st_orig]'"' != "" {
			di in gr _col(14) "origin:  " in ye `"`_dta[st_orig]'"'
		}

		if `"`_dta[st_enter]'"' != "" {
			di in gr "  enter on or after:  " in ye /*
			*/ `"`_dta[st_enter]'"'
		}
		if `"`_dta[st_exit]'"' != "" {
			di in gr "  exit on or before:  " in ye /*
			*/ `"`_dta[st_exit]'"'
		}
		if `"`_dta[st_id]'"' != "" {
			di _col(18) in gr "id:  " in ye `"`_dta[st_id]'"'
		}
		if `"`_dta[st_w]'"' != "" {
			di in gr _col(14) "weight:  " in ye `"`_dta[st_w]'"'
		}
		capture confirm integer number `_dta[st_n0]'
		if _rc { exit }
		di _col(16) in gr "note:  " in ye `"`_dta[st_n1]'"'
		local i 2 
		while `i' <= `_dta[st_n0]' {
			di _col(23) `"`_dta[st_n`i']'"'
			local i = `i' + 1
		}
		exit
	}
	zt_sho_5
end
