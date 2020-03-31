*! version 6.1.1  29jan2015
program define st
	version 6
	if _caller()<6 {
		di in gr "(you are running st from Stata version 5)"
		if "`*'"!="" { error 198 }
		ztset_5
		exit
	}
	syntax [, noCmd noTable MI]
	if ("`mi'"=="") {
		u_mi_not_mi_set "st"
	}
	st_is 2 full

	if "`cmd'"=="" {
		ShowCmd
	}
	if "`table'"!="" {
		exit
	}

	di 
/*
	if `"$S_FN"' != "" {
		di in gr _col(7) "dataset name:  " in ye `"$S_FN"'
	}
*/

	if `"`_dta[st_id]'"' != "" {
		di in gr _col(17) "id:  " in ye `"`_dta[st_id]'"'
	}

	if `"`_dta[st_bd]'"' != "" {
		*di in gr _col(5) "event variable:  " in ye `"`_dta[st_bd]'"'
		di in gr _col(6) "failure event:  " _c
		if `"`_dta[st_ev]'"' != "" {
			di in ye `"`_dta[st_bd]' == `_dta[st_ev]'"'
		}
		else	di in ye `"`_dta[st_bd]' != 0 & `_dta[st_bd]' < ."'
	}
	else {
		di in gr _col(6) "failure event:  " in ye /*
		*/ `"(assumed to fail at time=`_dta[st_bt]')"'
	}

	di in gr "obs. time interval:  " in ye "(" _c
	if `"`_dta[st_bt0]'"' != "" { 
		di in ye `"`_dta[st_bt0]'"' _c 
	}
	else if `"`_dta[st_id]'"' != "" { 
		di in ye `"`_dta[st_bt]'[_n-1]"' _c
	}
	else if `"`_dta[st_orig]'"' != "" { 
		di in ye `"origin"' _c
	}
	else {
		di in ye "0" _c
	}
	di in ye `", `_dta[st_bt]']"'

	if `"`_dta[st_enter]'"' != "" { 
		di in gr " enter on or after:  " in ye `"`_dta[st_enter]'"'
	}
	di in gr " exit on or before:  " _c
	if `"`_dta[st_exit]'"' != "" { 
		di in ye `"`_dta[st_exit]'"'
	}
	else	di in ye "failure"


	if `"`_dta[st_orig]'"'!="" | `"`_dta[st_bs]'"'!="1" {
		di in gr _col(5) "t for analysis:  " _c
		if `"`_dta[st_orig]'"' != "" {
			di in ye "(time-origin)" _c
		}
		else	di in ye "time" _c
		if `"`_dta[st_bs]'"'!="1" {
			di in ye `"/`_dta[st_bs]'"' _c
		}
		di
		if `"`_dta[st_orig]'"' != "" { 
			di in gr _col(13) "origin:  " in ye `"`_dta[st_orig]'"'
		}
	}

	if `"`_dta[st_w]'"' != "" {
		di in gr _col(13) "weight:  " in ye /* */ `"`_dta[st_w]'"'
	}

	if `"`_dta[st_ifexp]'"' != "" {
		di in gr _col(13) "if exp:  "  in ye `"`_dta[st_ifexp]'"'
	}
	if `"`_dta[st_if]'"' != "" {
		di in gr _col(17) "if:  "  in ye `"`_dta[st_if]'"'
	}
	if `"`_dta[st_ever]'"' != "" {
		di in gr _col(15) "ever:  "  in ye `"`_dta[st_ever]'"'
	}
	if `"`_dta[st_never]'"' != "" {
		di in gr _col(14) "never:  "  in ye `"`_dta[st_never]'"'
	}
	if `"`_dta[st_after]'"' != "" {
		di in gr _col(14) "after:  "  in ye `"`_dta[st_after]'"'
	}
	if `"`_dta[st_befor]'"' != "" {
		di in gr _col(13) "before:  "  in ye `"`_dta[st_befor]'"'
	}

	capture confirm integer number `_dta[st_n0]'
	if _rc == 0 { 
		di _col(15) in gr "note:  " in ye `"`_dta[st_n1]'"'
		local i 2
		while `i' <= `_dta[st_n0]' { 
			di in ye _col(22) `"`_dta[st_n`i']'"'
			local i = `i' + 1 
		}
	}
end


program define ShowCmd
	if `"`_dta[st_full]'"'=="" {
		local enter `"`_dta[st_enter]'"'
		local exit `"`_dta[st_exit]'"'
		local orig `"`_dta[st_orig]'"'
		local if `"`_dta[st_if]'"'
		local ever `"`_dta[st_ever]'"'
		local before `"`_dta[st_befor]'"'
		local after `"`_dta[st_after]'"'
	}
	else {
		local enter `"`_dta[st_fente]'"'
		local exit `"`_dta[st_fexit]'"'
		local orig `"`_dta[st_forig]'"'
		local if `"`_dta[st_fif]'"'
		local ever `"`_dta[st_fever]'"'
		local before `"`_dta[st_fbefo]'"'
		local after `"`_dta[st_fafte]'"'
	}

	if `"`_dta[st_wt]'"' != "" {
		local cmd `"`cmd' [`_dta[st_wt]'=`_dta[st_wv]']"'
	}

	if `"`_dta[st_ifexp]'"' != "" {
		local cmd `"`cmd' if `_dta[st_ifexp]'"'
	}

	local cmd `"`cmd',"'

	if "`_dta[st_id]'" != "" {
		local cmd `"`cmd' id(`_dta[st_id]')"'
	}

	if `"`_dta[st_bd]'"' != "" {
		local arg `"`_dta[st_bd]'"'
		if `"`_dta[st_ev]'"' != "" {
			local arg `"`arg'==`_dta[st_ev]'"'
		}
		local cmd `"`cmd' failure(`arg')"'
	}

	if `"`_dta[st_bt0]'"' != "" {
		local cmd `"`cmd' time0(`_dta[st_bt0]')"'
	}

	if `"`enter'"' != "" {
		local cmd `"`cmd' enter(`enter')"'
	}

	if `"`exit'"' != "" {
		local cmd `"`cmd' exit(`exit')"'
	}

	if `"`orig'"' != "" {
		local cmd `"`cmd' origin(`orig')"'
	}

	if `"`_dta[st_bs]'"' != "1" {
		local cmd `"`cmd' scale(`_dta[st_bs]')"'
	}

	if `"`if'"' != "" {
		local cmd `"`cmd' if(`if')"'
	}

	if `"`ever'"' != "" {
		local cmd `"`cmd' ever(`ever')"'
	}

	if `"`_dta[st_never]'"' != "" {
		local cmd `"`cmd' never(`_dta[st_never]')"'
	}

	if `"`after'"' != "" {
		local cmd `"`cmd' after(`after')"'
	}

	if `"`before'"' != "" {
		local cmd `"`cmd' before(`before')"'
	}

	if `"`_dta[st_show]'"' != "" {
		local cmd `"`cmd' `_dta[st_show]'"'
	}


	if `"`cmd'"' == "" {
		di in gr `"-> stset `_dta[st_bt]'"'
	}
	else {
		local isblnk = bsubstr(`"`cmd'"',1,1)==" "
		local bcmd `"-> stset `_dta[st_bt]'"'
		local l = length("`bcmd'"') + 2
		local plen = 78 - `l'
		local a : piece 1 `plen' of `"`cmd'"'
		if `isblnk' {
			di in gr `"`bcmd' `a'"'
			local l = `l' - 1
		}
		else	di in gr `"`bcmd'`a'"'
		local i 2 
		local a : piece `i' `plen' of `"`cmd'"'
		while `"`a'"' != "" { 
			di in gr _skip(`l') `"`a'"'
			local i = `i' + 1
			local a : piece `i' `plen' of `"`cmd'"'
		}
	}
		
	if `"`_dta[st_full]'"' != "" {
		di in gr `"-> streset, full `_dta[st_full]'"'
	}
end
