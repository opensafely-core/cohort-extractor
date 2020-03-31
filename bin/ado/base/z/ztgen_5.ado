*! version 5.0.5  16feb2015
program define ztgen_5 /* stegen type newvar = exp ... */
	version 5.0, missing
	di in gr "(you are running stgen from Stata version 5)"

	zt_is_5

	if "`*'"=="" {
		exit 198
	}

	GetType "`1'"
	local typ $S_1
	if $S_2 {
		mac shift
	}

	GetVn "`1'"
	local vn "$S_1"
	if "$S_2"!="" {
		local 1 "$S_2"
	}
	else	mac shift

	Getchar = "`1'"
	if "$S_2"!="" {
		local 1 "$S_2"
	}
	else	mac shift

	GetFcn "`1'"
	local fcn "$S_1"
	local 1 "$S_2"

	if "`1'"=="()" {
		mac shift 
		if "`*'"!="" {
			error 198 
		}
	}
	else {
		local exp "req noprefix"
		local 1 "=`1'"
		parse "`*'"
	}

	* st_show

	local pgm = bsubstr("`fcn'",1,6) 
	if "`typ'"!="" {
		tempvar user 
		local user `vn'
	}
	else	local user `vn'

	capture z_`pgm' `user' "`exp'"
	if _rc==199 { 
		di in red "unknown function `fcn'()"
		exit 133
	}
	if _rc { 
		local rc = _rc
		capture drop `user'
		error `rc'
	}
	if "`typ'" != "" {
		qui gen `typ' `vn' = `user'
	}
	quietly count if `vn'>=.
	if _result(1) {
		if _result(1)!=1 {
			local s s
		}
		di in gr "(" _result(1) " missing value`s' generated)"
	}
end



program define GetType /* [type] */
	if "`1'"=="byte" | "`1'"=="int" | "`1'"=="float" | "`1'"=="double" {
		global S_1 "`1'"
		global S_2 1
		exit
	}
	global S_1
	global S_2 0
end

program define GetVn /* name[=...] */
	local i = index("`1'","=")
	if `i' {
		local vn =bsubstr("`1'",1,`i'-1)
		local rest = bsubstr("`1'",`i',.)
	}
	else	local vn "`1'"
	local n : word count `vn'
	if `n' != 1 { error 103 }
	confirm new var `vn'
	global S_1 "`vn'"
	global S_2 "`rest'"
end

program define Getchar /* char "<char><rest>" */
	if substr("`2'",1,1) != "`1'" {
		di in red _quote "`2'" _quote " found where `1' expected"
		exit 198
	}
	global S_2 = substr("`2'",2,.)
end



program define GetFcn /* fcn(...) */
	local i = index("`1'","(")
	if `i'==0 { 
		di in red _quote "`1'" _quote /*
		*/ " found where function(...) expected"
		exit 198
	}
	global S_1 = bsubstr("`1'",1,`i'-1)
	global S_2 = bsubstr("`1'",`i',.)
end


program define z_ever /* varname exp */
	local vn "`1'"
	local exp "`2'"

	if "`exp'"=="" {
		exit 198
	}
	local t : char _dta[st_t]
	local id : char _dta[st_id]
	tempvar z 

	sort `id' `t'
	gen double `z' = `exp'
	if "`id'"=="" {
		gen byte `vn' = `z'!=0 if `z'<.
	}
	else {
		by `id': replace `z'=sum(`z'!=0)
		by `id': gen byte `vn' = `z'[_N]!=0
	}
end


program define z_never /* varname exp */
	local vn "`1'"
	local exp "`2'"

	if "`exp'"=="" {
		exit 198
	}
	local t : char _dta[st_t]
	local id : char _dta[st_id]
	tempvar z 

	sort `id' `t'
	gen double `z' = `exp'
	if "`id'"=="" {
		gen byte `vn' = `z'==0 if `z'<.
	}
	else {
		by `id': replace `z'=sum(`z'!=0)
		by `id': gen byte `vn'=`z'[_N]==0
	}
end

program define z_always /* varname exp */
	local vn "`1'"
	local exp "`2'"

	if "`exp'"=="" {
		exit 198
	}

	local t : char _dta[st_t]
	local id : char _dta[st_id]
	tempvar z 

	sort `id' `t'
	gen double `z' = `exp'
	if "`id'"=="" {
		gen byte `vn' = `z'!=0 if `z'<.
	}
	else {
		by `id': replace `z'=sum(`z'==0)
		by `id': gen byte `vn'=`z'[_N]==0	
	}
end

program define z_nfailu /* vn exp */
	local vn "`1'"
	local exp "`2'"

	if "`exp'"!="" { exit 198 }

	local t : char _dta[st_t]
	local id : char _dta[st_id]
	local d : char _dta[st_d]

	if "`id'"=="" {
		gen byte `vn' = 0 
	}
	else {
		local obstype = c(obs_t)
		if "`obstype'" != "double" {
			local obstype "long"
		}
		sort `id' `t'
		by `id': gen `obstype' `vn' = sum(`d'[_n-1]!=0)-1
		compress `vn'
	}
end

program define z_gaplen /* vn exp */
	local vn "`1'"
	local exp "`2'"

	if "`exp'"!="" { exit 198 }

	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local id : char _dta[st_id]

	if "`id'"=="" {
		gen byte `vn' = 0
		exit
	}
	sort `id' `t'
	by `id': gen double `vn' = cond(_n==1,0,`t0'-`t'[_n-1])
	compress `vn'
end

program define z_hasgap /* vn exp */
	local vn "`1'"
	local exp "`2'"

	if "`exp'"!="" { exit 198 }

	local id : char _dta[st_id]
	if "`id'"=="" { 
		gen byte `vn' = 0
		exit
	}

	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	sort `id' `t'
	by `id': gen byte `vn' = cond(_n==_N,sum(`t0'-`t'[_n-1])>0,0)
	by `id': replace `vn' = `vn'[_N]
end


program define z_ngaps /* vn exp */
	local vn "`1'"
	local exp "`2'"

	if "`exp'"!="" { exit 198 }

	local id : char _dta[st_id]
	tempvar z

	if "`id'"=="" {
		qui gen byte `vn' = 0
		exit
	}
	z_gaplen `z'
	by `id': gen long `vn' = sum(`z'!=0)
	compress `vn'
end
exit
