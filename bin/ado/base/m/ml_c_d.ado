*! version 3.0.1  21dec1998
program define ml_c_d /* { count <arguments> | debug <arguments> } */
	version 6
	local cmd "`1'"
	mac shift
	if "`cmd'"=="trace" { 
		MLtrace `*'
	}
	else if "`cmd'"=="count" { 
		MLcnt `*'
	}
	else	error 199
end

program define MLtrace /* { on | off } */
	ml_defd
	MLicmd `"`0'"' ml_debug trace
end

program define MLcnt /* { clear | on | off | <nothing> } */
	if `"`0'"'=="" {
		if "$ML_stat"=="model" { 
			FindCmd ml_cnt
			if r(i)==. { 
				di in gr "count off"
				exit
			}
			CntList `"$ML_ouser"' /*
			*/"$ML_cnt0" "$ML_cnt1" "$ML_cnt2" "$ML_cnt_"
			exit
		}
		else if "`e(opt)'"=="ml" { 
			CntList `"`e(user)'"' /*
			*/ "`e(cnt0)'" "`e(cnt1)'" "`e(cnt2)'" "`e(cnt_)'"
			exit
		}
	}
	ml_defd
	if `"`0'"'=="clear" { 
		global ML_cnt0 0
		global ML_cnt1 0
		global ML_cnt2 0
		global ML_cnt_ 0
		exit
	}
	if `"`0'"'=="on" { 
		FindCmd ml_cnt
		if r(i)==. { 
			ml count clear 
		}
		MLicmd on ml_cnt count
		exit
	}
	if `"`0'"'=="off" {
		global ML_cnt0
		global ML_cnt1
		global ML_cnt2
		global ML_cnt_
		MLicmd off ml_cnt count
		exit
	}
	MLicmd `"`0'"' ml_cnt count
end


program define CntList /* userprogname 0 1 2 other */, rclass
	local user `"`1'"'
	mac shift
	if "`1'"=="" & "`2'"=="" & "`3'"=="" & "`4'"=="" {
		di in red "you did not -ml count on- before estimation"
		di in red "no counts recorded"
		exit 198
	}
	if `1'==0 & `2'==0 & `3'==0 & `4'==0 { 
		di in gr "(all counts are zero)"
		exit
	}
	if `1'!=0 { 
		di in gr `"`user' 0"' in ye %9.0g `1'
	}
	if `2'!=0 { 
		di in gr `"`user' 1"' in ye %9.0g `2'
	}
	if `3'!=0 { 
		di in gr `"`user' 2"' in ye %9.0g `3'
	}
	if `4'!=0 { 
		di in gr `"`user'  "' in ye %9.0g `4'
	}
end


program define FindCmd /* cmdname */, rclass
	local c "`1'"
	tokenize "$ML_user"
	local i 1 
	while "``i''" != "" { 
		if "``i''" == "`c'" { 
			return scalar i = `i'
			exit
		}
		local i = `i' + 1
	}
	return scalar i = .
end

program define RmCmd /* cmdname */
	local c "`1'"
	tokenize "$ML_user"
	local i 1
	while "``i''" != "" { 
		if "``i''" == "`c'" { 
			local `i' " "
			global ML_user `*'
			exit
		}
		local i = `i' + 1
	}
end

	
program define MLicmd /* {on|off} progname word_name */
	local user `"`1'"'
	local prog `2'
	local name `3'

	FindCmd `prog'
	if `"`1'"'=="on" { 
		if r(i)==. { 
			global ML_user `prog' $ML_user
		}
		else	di in gr "(`name' already on)"
	}
	else if `"`1'"'=="off" {
		if r(i)!=. { 
			RmCmd `prog'
		}
		else 	di in gr "(`name' was off)"
	}
	else if `"`1'"'=="" {
		if r(i)==. {
			di in gr "`name' off"
		}
		else	di in gr "`name' on"
	}
	else	error 198
end
exit
