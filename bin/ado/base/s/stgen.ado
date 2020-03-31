*! version 6.0.7  17feb2015
program define stgen, sort /* stegen type newvar = exp ... */
	version 6, missing

	if _caller()<6 {
		ztgen_5 `0'
		exit
	}

	st_is 2 full

	gettoken w1 0 : 0, parse(" =")
	gettoken w2 0 : 0, parse(" =")
	if `"`w2'"' != "=" {
		gettoken w3 0 : 0, parse(" =")
		if `"`w3'"' != "=" { error 198 }
		local typ `"`w1'"'
		local vn  `"`w2'"'
		ChkType `w1'
	}
	else 	local vn `"`w1'"'
	confirm new var `vn'

	/* we have now pulled =, 0 contains "<fcn>(<exp>)" */

	gettoken fcn 0 : 0, parse(" (")
	gettoken paren 0 : 0, parse(" (")
	if `"`paren'"' != "(" { error 198 }

	local np 1
	local exp 
	while `np' {
		gettoken piece 0 : 0, parse(" ()") quotes
		if `"`piece'"' == "(" { 
			local np = `np' + 1
		}
		else if `"`piece'"' == ")" { 
			local np = `np' - 1
			if `np'==0 {
				local piece 
			}
		}
		else if `"`piece'"' == "" {
			di in red "too few ')'"
			exit 132
		}
		local exp `"`exp'`piece'"'
	}
	if `"`0'"' != "" { 
		exit 198
	}

	if `"`exp'"' != "" {
		local 0 `"=`exp'"'
		syntax =/exp
	}

	local pgm = bsubstr(`"`fcn'"',1,6) 
	if "`typ'"!="" {
		tempvar user 
	}
	else	local user `vn'

	capture z_`pgm' `user' `"`exp'"'
	if _rc {
		local rc = _rc
		capture drop `user'
		if `rc'==199 { 
			di in red "unknown function `fcn'()"
			exit 133
		}
		error `rc'
	}

	if "`typ'" != "" {
		qui gen `typ' `vn' = `user'
	}
	qui count if `vn'==.
	if r(N) {
		di in gr "(" r(N) /*
		*/ " missing value" cond(r(N)>1,"s","") " generated)"
	}
end


program define ChkType /* type */
	if "`1'"=="byte" | "`1'"=="int" | "`1'"=="float" | "`1'"=="double" {
		exit
	}
	di in red `"`1' invalid storage type"'
	exit 198
end


program define z_ever /* varname exp */
	args vn exp 

	if `"`exp'"'=="" {
		exit 198
	}
	local id : char _dta[st_id]
	tempvar z 

	gen double `z' = `exp' if _st
	if "`id'"=="" {
		gen byte `vn' = `z'!=0 if `z'<. & _st
	}
	else {
		sort _st `id' _t
		by _st `id': replace `z'=sum(`z'!=0) if _st
		by _st `id': gen byte `vn' = `z'[_N]!=0 if _st
	}
end


program define z_never /* varname exp */
	args vn exp 

	if `"`exp'"'=="" {
		exit 198
	}
	local id : char _dta[st_id]
	tempvar z 

	gen double `z' = `exp' if _st
	if "`id'"=="" {
		gen byte `vn' = `z'==0 if `z'<. & _st
	}
	else {
		sort _st `id' _t
		by _st `id': replace `z'=sum(`z'!=0) if _st
		by _st `id': gen byte `vn'=`z'[_N]==0 if _st
	}
end

program define z_always /* varname exp */
	args vn exp 

	if `"`exp'"'=="" {
		exit 198
	}

	local id : char _dta[st_id]
	tempvar z 

	gen double `z' = `exp' if _st
	if "`id'"=="" {
		gen byte `vn' = `z'!=0 if `z'<. & _st
	}
	else {
		sort _st `id' _t
		by _st `id': replace `z'=sum(`z'==0) if _st
		by _st `id': gen byte `vn'=`z'[_N]==0 if _st
	}
end

program define z_max 
	args vn exp
	if `"`exp'"'=="" {
		exit 198
	}
	
	local id : char _dta[st_id]
	gen double `vn' = `exp' if _st
	if "`id'"!="" {
		sort _st `id' _t
		by _st `id': replace `vn' = `vn'[_n-1] if ( /*
				*/ (`vn'<`vn'[_n-1] & `vn'[_n-1]<.) | /*
				*/ (`vn'==.) /*
				*/ ) & _st
		by _st `id': replace `vn' = `vn'[_N] if _st
	}
	compress `vn'
end

program define z_min 
	args vn exp
	if `"`exp'"'=="" {
		exit 198
	}
	
	local id : char _dta[st_id]
	gen double `vn' = `exp' if _st
	if "`id'"!="" {
		sort _st `id' _t
		by _st `id': replace `vn' = `vn'[_n-1] if ( /*
				*/ (`vn'[_n-1]<`vn') ) & _st
		by _st `id': replace `vn' = `vn'[_N] if _st
	}
	compress `vn'
end

program define z_when
	args vn exp

	if `"`exp'"'=="" { exit 198 }

	local id : char _dta[st_id]
	local t  : char _dta[st_bt]

	if "`id'" != "" {
		sort _st `id' _t
		by _st `id': gen double `vn' = `t' if (`exp')!=0 & _st
		by _st `id': replace `vn' = `vn'[_n-1] /*
				*/ if `vn'[_n-1]<`vn' & _st
		by _st `id': replace `vn' = `vn'[_N] if _st
	}
	else	gen `vn' = `t' if (`exp')!=0 & _st
	compress `vn'
end
		
program define z_when0
	args vn exp

	if `"`exp'"'=="" { exit 198 }

	local id : char _dta[st_id]
	local t  : char _dta[st_bt0]
	if "`t'" == "" {
		tempvar t 
		gen double `t' = `_dta[st_bt]'*`_dta[st_s]'+`_dta[st_o]' if _st
	}

	if "`id'" != "" {
		sort _st `id' _t
		by _st `id': gen double `vn' = `t' if (`exp')!=0 & _st
		by _st `id': replace `vn' = `vn'[_n-1] /*
				*/ if `vn'[_n-1]<`vn' & _st
		by _st `id': replace `vn' = `vn'[_N] if _st
	}
	else	gen `vn' = `t' if (`exp')!=0 & _st
	compress `vn'
end

program define z_count0
	args vn exp
	if `"`exp'"' == "" { error 198 }
	local id : char _dta[st_id]
	gen float `vn' = (`exp')!=0 if _st
	if "`id'"!="" {
		sort _st `id' _t
		by _st `id': replace `vn' = sum(`vn') if _st
	}
	compress `vn'
end


program define z_count
	args vn exp
	if `"`exp'"' == "" { error 198 }
	local id : char _dta[st_id]
	if "`id'"=="" {
		gen byte `vn' = 0
		exit
	}
	tempvar b 
	gen byte `b' = (`exp')!=0 if _st
	sort _st `id' _t
	by _st `id': gen float `vn' = sum(`b'[_n-1]!=0)-1 if _st
	compress `vn'
end

program define z_maxage
	args vn exp
	if `"`exp'"' == "" { error 198 }
	gen float `vn' = (_t*`_dta[st_s]'+`_dta[st_o]'-(`exp'))/`_dta[st_s]' /*
		*/ if _st
end

program define z_minage
	args vn exp
	if `"`exp'"' == "" { error 198 }
	gen float `vn' = (_t0*`_dta[st_s]'+`_dta[st_o]'-(`exp'))/`_dta[st_s]' /*
		*/ if _st
end

program define z_avgage
	args vn exp
	tempvar min max 
	z_maxage `max' `"`exp'"'
	z_minage `min' `"`exp'"'
	gen float `vn' = (`min'+`max')/2 if _st
end


program define z_nfailu /* vn exp */
	args vn exp

	if `"`exp'"'!="" { exit 198 }

	local id : char _dta[st_id]

	if "`id'"=="" {
		gen byte `vn' = 0 if _st
	}
	else {
		sort _st `id' _t
		by _st `id': gen `c(obs_t)' `vn' = sum(_d[_n-1]!=0)-1 if _st
		compress `vn'
	}
end

program define z_gaplen /* vn exp */
	args vn exp

	if `"`exp'"'!="" { exit 198 }

	local id : char _dta[st_id]

	if "`id'"=="" {
		gen byte `vn' = 0 if _st
		exit
	}
	sort _st `id' `t'
	by _st `id': gen double `vn' = cond(_n==1, 0, _t0-_t[_n-1]) if _st
	compress `vn'
end

program define z_hasgap /* vn exp */
	args vn exp

	if `"`exp'"'!="" { exit 198 }

	local id : char _dta[st_id]
	if "`id'"=="" { 
		gen byte `vn' = 0 if _st
		exit
	}

	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	sort _st `id' `t'
	by _st `id': gen byte `vn' = cond(_n==_N,sum(_t0-_t[_n-1])>0,0) if _st
	by _st `id': replace `vn' = `vn'[_N] if _st
end


program define z_ngaps /* vn exp */
	args vn exp

	if `"`exp'"'!="" { exit 198 }

	local id : char _dta[st_id]
	tempvar z

	if "`id'"=="" {
		qui gen byte `vn' = 0 if _st
		exit
	}
	z_gaplen `z'
	by _st `id': gen long `vn' = sum(`z'!=0) if _st
	compress `vn'
end
exit
