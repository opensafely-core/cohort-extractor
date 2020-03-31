*! version 2.0.0
program define zt_ct_5
	version 5.0

/* 
               1    3   4   5  6     7
	st_ct by -> T Pop Die Cens Ent
*/

	local set : char _dta[_dta]
	if "`set'" != "st" {
		di in red "data not st"
		exit 198
	}
	local t1 : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d  : char _dta[st_d]
	local id : char _dta[st_id]
	local w  : char _dta[st_wv]


/* Input: */
	local by   "`1'"	/* opt, varnames or blank 	*/
/* Output: */
	local T    "`3'"	/* new, time variable		*/
	local Pop  "`4'"	/* new, pop at entry into T	*/
	local Die  "`5'"	/* new, number who die at T	*/
	local Cens "`6'"	/* new, number who cens at T	*/
	local Ent  "`7'"	/* new, number who ent at T	*/
	/*    by                   will be included in output	*/
	/* 	-- output data sorted by `by' `T'		*/

	if "`t0'"=="0" {
		local t0
	}
	if "`w'"=="1" {
		local w
	}
	if "`d'"=="1" {
		local d
	}

	keep `by' `w' `t0' `t1' `id' `d'
	tempvar touse op n
	quietly {
		gen byte `touse' = 1
		markout `touse' `w' `t0' `t1' `d'
		markout `touse' `by' `id', strok
		keep if `touse'
		drop `touse'

		if "`t0'" == "" {
			if "`id'" != "" {
				tempvar t0 
				local ty : type `t1'
				sort `id' `t1'
				by `id': gen `ty' `t0' = /* 
					*/ cond(_n==1,0,`t1'[_n-1])
				capture assert `t1'>`t0'
				if _rc { 
					di in red /* 
*/ "repeated records at same `t1' within `id'"
					exit 498
				}
				drop `id'
			}
			else	local t0 0
		}
	}

	capture assert `t1'>0
	if _rc { 
		di in red "survival time `t1' <= 0"
		exit 498
	}
	capture assert `t0' >= 0
	if _rc { 
		di in red "entry time `t0' < 0"
		exit 498
	}
	capture assert `t1'>`t0'
	if _rc { 
		di in red "entry time `t0' >= survival time `t1'"
		exit 498
	}


	if "`d'"=="" { 
		local d 1
	}

	if "`w'"=="" { 
		local w 1
	}
	


	quietly { 
		local N = _N 
		expand 2 
		gen byte `op' = 3/*add*/ in 1/`N'
		replace `t1' = `t0' in 1/`N'
		if "`t0'" != "0" {
			drop `t0' 
		}

		local N = `N' + 1
		replace `op'=cond(`d'==0,2/*cens*/,1/*death*/) in `N'/l
		if "`d'" != "1" {
			drop `d'
		}

		if "`by'" != "" {
			local byp "by `by':"
		}

		sort `by' `t1' `op'
		`byp' gen double `n' = sum(cond(`op'==3,`w',-`w'))
		if "`Die'" != "" {
			by `by' `t1': gen double `Die' = sum(`w'*(`op'==1))
			compress `Die'
		}
		if "`Cens'" != "" {
			by `by' `t1': gen double `Cens' = sum(`w'*(`op'==2))
			compress `Cens'
		}
		if "`Ent'" != "" {
			by `by' `t1': gen double `Ent' = sum(`w'*(`op'==3))
			compress `Ent'
		}
		by `by' `t1': keep if _n==_N

		if "`w'" != "1" { 
			drop `w'
		}

		`byp' gen double `Pop' = cond(_n==1,0,`n'[_n-1])
		drop `n'
		compress `Pop'
	}
	if "`t1'" != "`T'" {
		rename `t1' `T'
	}
end
exit
