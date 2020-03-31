*! version 6.0.7  31jul2001
program define stvary, rclass byable(recall) sort
	version 7, missing
	if _caller()<6 {
		ztvary_5 `0'
		exit
	}

	syntax [varlist] [if] [in] [, noSHow]

	st_is 2 full
	st_show `show'

	tempvar touse 
	st_smpl `touse' `"`if'"' `"`in'"'
	if _by() {
		qui replace `touse'=0 if `_byindex' != _byindex()
	}
	

	local id : char _dta[st_id]

	sort `touse' `id' _t

	DispHdr
	tokenize `varlist'
	while `"`1'"' != `""' {
		st_issys `1'
		if `r(boolean)'==0 {
			qui DoStat `"`id'"' `touse' `1'
/* It would be handy to have a -ret add, all- which overwrites */
	                ret scalar cons = r(cons)
                	ret scalar varies = r(varies)
                	ret scalar never = r(never)
                	ret scalar always = r(always)
                	ret scalar miss = r(miss)

			DispStat `1'
		}
		mac shift
	}
end

program define DoStat, rclass /* id touse v */
	args id touse v

	tempvar notmis j base cnt
	mark `notmis'
	markout `notmis' `v', strok

	if `"`id'"'==`""' {
		count if `touse'
		local nsubj = r(N)
		count if `notmis'==0 & `touse'
		local always = r(N)
		local never = `nsubj' - `always'
		local varies = 0
		local cons = `nsubj' - `varies' - `always'

		ret scalar cons = `cons'
		ret scalar varies = `varies'
		ret scalar never = `never'
		ret scalar always = `always'
		ret scalar miss = 0

		/* Double saves */

		global S_1 `return(cons)'
		global S_2 `return(varies)'
		global S_3 `return(never)'
		global S_4 `return(always)'
		global S_5 `return(miss)'
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
	local cons = r(sum)

	by `touse' `id': replace `cnt' = cond(_n==_N, /*
		*/ sum(`v'!=`base' & `notmis')!=0,0) 
	summ `cnt' if `touse'
	local varies = r(sum) 


	by `touse' `id': replace `cnt' = cond(_n==_N, /*
		*/ (sum(`notmis')==_N)!=0,0) 
	summ `cnt' if `touse'
	local never = r(sum)

	by `touse' `id': replace `cnt'= cond(_n==_N, /* 
		*/ sum(`notmis')==0,0) 
	summ `cnt' if `touse'
	local always = r(sum) 

	ret scalar cons = `cons' - `always'
	ret scalar varies = `varies'
	ret scalar never = `never'
	ret scalar always = `always'
	ret scalar miss = `nsubj' - `never' - `always'

	/* Double saves */

	global S_1 `return(cons)'
	global S_2 `return(varies)'
	global S_3 `return(never)'
	global S_4 `return(always)'
	global S_5 `return(miss)'

end
	

program define DispHdr
	di _n in smcl as txt _col(16) `"subjects for whom the variable is"' _n /*
	*/ _col(50) `"never"' _col(59) `"always"' _col(68) `"sometimes"' _n /*
	*/ `"    variable {c |}  constant"' _col(29) `"varying"' /*
	*/ _col(46) _dup(3) `"   missing"' _n /* 
	*/ "{hline 13}{c +}{hline 62}"
end

program define DispStat
	di in smcl as txt %12s abbrev(`"`1'"',12) " {c |}  " as res  /* 
	*/ %8.0g (`r(cons)') `"  "' %9.0g (`r(varies)') /* 
	*/ _col(47) %9.0g (`r(never)') %10.0g (`r(always)') %10.0g (`r(miss)')
end
exit
           subjects for whom the variable is
                                             never    always   sometimes 
variable |  constant     varies          123missing123missing123missing
---------+--------------------------------------------------------------
----+----1----+----2----+----3----+----4----+----5----+----6----+----7
longlong |  12345678   12345678            12345678  12345678  12345678

ng

