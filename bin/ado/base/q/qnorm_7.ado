*! version 2.1.11  28sep2004
program define qnorm_7, sort
	version 6, missing
	syntax varname [if] [in] [, /*
		*/ Symbol(string) Connect(string) T1(str) Grid noBorder * ]

	if "`symbol'"=="" { local symbol "oi" }
	else { local symbol "`symbol'i" }
	if "`t1'" != "" { local t1 t1(`t1') }
	if "`connect'"=="" { local connect ".l" }
	else { local connect "`connect'l" }
	tempvar touse Z Psubi
	quietly {
		gen byte `touse' = cond(`varlist'>=.,.,1) `if' `in'
		sort `varlist'
		gen float `Psubi' = sum(`touse')
		replace `Psubi' = cond(`touse'>=.,.,`Psubi'/(`Psubi'[_N]+1))
/*
		replace `Psubi' = cond(`touse'>=.,.,(`Psubi'-.5)/`Psubi'[_N])
*/
		sum `varlist' if `touse'==1, detail
		gen float `Z' = invnorm(`Psubi')*sqrt(r(Var)) + r(mean)
		label var `Z' "Inverse Normal"
		local fmt : format `varlist'
		format `Z' `fmt'
		if "`grid'"!="" {
			local ytl = string(r(p5))+","+/*
				*/ string(r(p50))+","+string(r(p95))
			local yn = "`ytl'" + ","+ /*
				*/ string(r(p10))+","+string(r(p25))+","+ /*
				*/ string(r(p75))+","+ string(r(p90))

			local xtl = string(r(mean))+","+ /*
				*/ string(invnorm(.95)*sqrt(r(Var))+r(mean))+ /*
				*/ "," + string(invnorm(.05)*sqrt(r(Var))+ /*
				*/ r(mean))
			local xn = "`xtl'" + "," + /*
				*/ string(invnorm(.25)*sqrt(r(Var))+r(mean))+ /*
				*/ ","+ /*
				*/ string(invnorm(.75)*sqrt(r(Var))+r(mean))+ /*
				*/ "," + /*
				*/ string(invnorm(.9)*sqrt(r(Var))+r(mean))+ /*
				*/ "," + /*
				*/ string(invnorm(.1)*sqrt(r(Var))+r(mean))
			local yl "ylin(`yn') rtic(`yn') rlab(`ytl')"
			local xl "xlin(`xn') ttic(`xn') tlab(`xtl')"
			if `"`t1'"' == "" {
				local t1 "t1(Grid lines are 5, 10, 25, 50, 75, 90, and 95 percentiles)"
			}
			noisily gr7 `varlist' `Z' `Z', c(`connect') /*
				*/ s(`symbol') /*
				*/ ylin(`yn') rtic(`yn') rlab(`ytl') /*
				*/ xlin(`xn') ttic(`xn') tlab(`xtl') /*
				*/ `options' `t1' t2(" ")
		}
		else {
			if "`border'"=="" { local b "border" }
			noisily gr7 `varlist' `Z' `Z', c(`connect') /*
			*/ s(`symbol') `b' `options' `t1' 
		}
	}
end
