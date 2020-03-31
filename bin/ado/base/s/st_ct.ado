*! version 6.1.1  06jun2011
program define st_ct
	version 6
	if _caller()<6 {
		zt_ct_5 `0'
		exit
	}
	args by ARROW T Pop Die Cens Ent RCens

/*
		by 		varnames | <nothing>
		T		newvarname, time variable
		Pop		newvarname, pop at entry into T
		Die		newvarname, number who die at T
		Cens		newvarname, number who cens at T
		Ent		newvarname, number who ent at T
		RCens		newvarname, Real number cens at T

	in addition, variable(s) `by' will be included in output dataset.
	output data will be sorted by `by' `T'
*/

	if `"`_dta[_dta]'"'!="st" | `"`_dta[st_ver]'"'!="2" {
		st_is 2 full
	}

	local id : char _dta[st_id]
	local w  : char _dta[st_wv]

	quietly {
		keep if _st
		keep `by' `w' _t0 _t `id' _d

		tempvar touse op n
		gen byte `touse' = 1
	/* backwards compatibility */
		markout `touse' `w' _t0 _t _d
	/* end backwards compatibility */
		markout `touse' `by' `id', strok
		keep if `touse'
		drop `touse' 

	}

/* Backwards compatibility */
	capture assert _t>0
	if _rc { 
		di in red "survival time _t <= 0"
		exit 498
	}
	capture assert _t0 >= 0
	if _rc { 
		di in red "entry time _t0 < 0"
		exit 498
	}
	capture assert _t>_t0
	if _rc { 
		di in red "entry time _t0 >= survival time _t"
		exit 498
	}
/* end Backwards compatibility */

	if "`w'"=="" { 
		local w 1
	}
	
	quietly { 
		tempvar lstid
		qui  gen int `lstid'=1
		if "`id'"~="" {
			sort `by' `id' _t
			qui by `by' `id': replace `lstid'=0 if _n~=_N
		}
		local N = _N 
		expand 2 
		gen byte `op' = 3/*add*/ in 1/`N'
		replace _t = _t0 in 1/`N'
		drop _t0 

		local N = `N' + 1
		replace `op'=cond(_d==0,2/*cens*/,1/*death*/) in `N'/l
		drop _d

		if "`by'" != "" {
			local byp "by `by':"
		}

		sort `by' _t `op'
		`byp' gen double `n' = sum(cond(`op'==3,`w',-`w'))
		if "`Die'" != "" {
			by `by' _t: gen double `Die' = sum(`w'*(`op'==1))
			compress `Die'
		}
		if "`Cens'" != "" {
			by `by' _t: gen double `Cens' = sum(`w'*(`op'==2))
			compress `Cens'
		}
		if "`Ent'" != "" {
			by `by' _t: gen double `Ent' = sum(`w'*(`op'==3))
			compress `Ent'
		}
		if "`RCens'"~="" {
			by `by' _t: /*
			     */ gen double `RCens' = sum(`w'*(`op'==2)*`lstid')
			compress `RCens'
		}
		by `by' _t: keep if _n==_N

		if "`w'" != "1" { 
			local dupname `by' `w'
			local dupname: list dups dupname
			if `"`dupname'"' == "" {
				drop `w'
			}
		}

		`byp' gen double `Pop' = cond(_n==1,0,`n'[_n-1])
		drop `n'
		compress `Pop'
	}
	if "_t" != "`T'" {
		rename _t `T'
	}
end
exit
