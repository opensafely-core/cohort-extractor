*!  version 5.0.1  16sep2004
program define ztvary_5
	version 5.0, missing
	di in gr "(you are running stvary from Stata version 5)"
	local varlist "opt ex"
	local if "opt"
	local in "opt"
	local options "noSHow"
	parse "`*'"

	zt_is_5
	zt_sho_5 `show'

	tempvar touse 
	zt_smp_5 `touse' "`if'" "`in'"

	local id : char _dta[st_id]
	local t  : char _dta[st_t]

	sort `touse' `id' `t'

	DispHdr
	parse "`varlist'", parse(" ")
	while "`1'" != "" {
		zt_iss_5 `1'
		if $S_1==0 {
			qui DoStat "`id'" `touse' `1'
			DispStat `1'
		}
		mac shift
	}
end

program define DoStat /* id touse v */
	local id "`1'"
	local touse "`2'"
	local v "`3'"

	tempvar notmis j base cnt
	mark `notmis'
	markout `notmis' `v', strok

	if "`id'"=="" {
		count if `touse'
		local nsubj = _result(1)
		count if `notmis'==0 & `touse'
		local always = _result(1)
		local never = `nsubj' - `always'
		local varies = 0
		local cons = `nsubj' - `varies' - `always'

		global S_1 `cons'
		global S_2 `varies'
		global S_3 = `never'
		global S_4 `always'
		global S_5 0
		exit
	}

	by `touse' `id': gen byte `j'=1 if _n==1 & `touse'
	replace `j' = sum(`j') 
	local nsubj = `j'[_N]
	drop `j'


	gen long `j' = . 
	by `touse' `id': replace `j' = cond(`j'[_n-1]<.,`j'[_n-1], /* 
		*/ cond(`notmis',_n,.))
	by `touse' `id': replace `j' = `j'[_N]

	local ty : type `v'
	by `touse' `id': gen `ty' `base' = `v'[`j'[_N]]

	by `touse' `id': gen double `cnt' = cond(_n==_N, /* 
		*/ sum(`v'==`base' & `notmis')==sum(`notmis'),0)
	summ `cnt' if `touse'
	local cons = _result(18)

	by `touse' `id': replace `cnt' = cond(_n==_N, /*
		*/ sum(`v'!=`base' & `notmis')!=0,0) 
	summ `cnt' if `touse'
	local varies = _result(18) 


	by `touse' `id': replace `cnt' = cond(_n==_N, /*
		*/ (sum(`notmis')==_N)!=0,0) 
	summ `cnt' if `touse'
	local never = _result(18)

	by `touse' `id': replace `cnt'= cond(_n==_N, /* 
		*/ sum(`notmis')==0,0) 
	summ `cnt' if `touse'
	local always = _result(18) 

	global S_1 = `cons' - `always'
	global S_2 `varies'
	global S_3 `never'
	global S_4 `always'
	global S_5 = `nsubj' - `never' - `always'
end
	

program define DispHdr
	di _n in gr _col(12) "subjects for whom the variable is" _n /*
	*/ _col(46) "never" _col(55) "always" _col(64) "sometimes" _n /*
	*/ "variable |  constant" _col(25) "varying" /*
	*/ _col(42) _dup(3) "   missing" _n /* 
	*/ _dup(9) "-" "+" _dup(62) "-"
end

program define DispStat
	local len = 8 - length("`1'")
	di in gr _skip(`len') "`1' |  " in ye  /* 
	*/ %8.0g ($S_1) "  " %9.0g ($S_2) /* 
	*/ _col(43) %9.0g ($S_3) %10.0g ($S_4) %10.0g ($S_5)
end
exit
           subjects for whom the variable is
                                             never    always   sometimes 
variable |  constant     varies          123missing123missing123missing
---------+--------------------------------------------------------------
----+----1----+----2----+----3----+----4----+----5----+----6----+----7
longlong |  12345678   12345678            12345678  12345678  12345678

ng

