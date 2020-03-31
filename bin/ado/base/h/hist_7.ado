*! version 1.0.4  21sep2004
program define hist_7
* touched by kth, jml
	version 6.0, missing
	syntax varname [if] [in] [fw/] [, Incr(integer 1) *]
	local v `"`varlist'"'
	marksample touse
	qui count if `touse'
	if r(N)==0 { error 2000 }
	quietly { 
		if `"`exp'"'!="" {
			tempvar w
			gen float `w'=`exp'
			local weight `"[`weight'=`w']"'
				
		}
		summ `v' if `touse'
		local min=r(min)
		local max=r(max)
		capture assert `min'==int(`min') & `max'==int(`max') if `touse'
		if _rc { 
			di in red `"`v' must take on integer values"'
			exit 198
		}
		local i=`max'-`min'+1
		if `i'<2 {
			di in red `"`v' is a constant"'
			exit 198
		}
		if `i'>50 {
			di in red "requires more than 50 bins"
			exit 198
		}
		local bin `"bin(`i')"'
		local incr=max(`incr',1)
		if `i'>25 & `incr'==1 {
			local incr 2
		}

		local i = `min'
		local lbl `"`i'"'
		local i=`i'+`incr'
		while `i'<=`max' {
			local lbl `"`lbl',`i'"'
			local i=`i'+`incr'
		}
		local m0 = `min'-.5
		local m1 = `max'+.5
	}
	gr7 `v' `weight' if `touse', /*
	*/ hist xsca(`m0',`m1') xlab(`lbl') `bin' `options'
end
