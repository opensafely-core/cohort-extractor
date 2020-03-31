*!  version 5.0.0  05jul1996
program define zt_iss_5
	version 5.0
	local v "`1'"

	local 1 : char _dta[st_t]
	local 2 : char _dta[st_t0]
	local 3 : char _dta[st_d]
	local 4 : char _dta[st_id]
	local 5 : char _dta[st_w]
	local 6

	while "`1'"!="" {
		if "`1'"=="`v'" {
			global S_1 1
			exit
		}
		mac shift
	}
	global S_1 0
end
