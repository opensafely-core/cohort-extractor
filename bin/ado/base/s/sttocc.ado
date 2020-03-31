*! version 6.1.2  09feb2015
program define sttocc
	version 6, missing
	st_is 2 analysis
	syntax [varlist] [, noDOTs GENerate(string) Match(varlist) /*
			*/  Number(integer 1) noSHow ]
	tokenize "`generate'"
	local d "`1'" 
	if "`d'"=="" {
		local d "_case"
	}
	local setid "`2'"
	if "`setid'"=="" {
		local setid "_set"
	}
	local ctime "`3'"
	if "`ctime'"=="" {
		local ctime "_time"
	}
	confirm new var `d' `setid' `ctime'
	if "`4'" != "" {
		di in red "more than 3 variables specified with generate() option"
		di in red "only 3 variables are generated"
	        exit 198
	}
	st_show `show'
	if "`match'"!="" {
		di in gr "       matching for:  " in ye "`match'"
	}

	local wv : char _dta[st_wv]
	local ttype : type _t 
	local ftype : type _d
	
	* trim down to the dataset to be saved
	keep `varlist' _d  _t  _t0  `wv' `match'
tempvar mid
gen `mid'=uniform()

	tempvar idd sel include timein timeout new tied
	tempname nc obs tmpobs incr jitter

	* generate d, timein and timeout variables

	gen `ftype' `d' = _d 
	gen `ttype' `timeout' = _t 
	gen `ttype' `timein' = _t0 

	qui {

		/* checks on ties in timeout */
		/* place censorings after failures 
			and randomly jitter failures */
/* -- don't use jitter --
		summ `timeout'
		if r(Var) > 0 {
			local jitter = sqrt(r(Var))*0.0001
		}
		else local jitter = 0.000001
*/
		sort `timeout' `mid'
		by `timeout': gen int `tied' = (`d'!=0 & _N!=1)
		by `timeout': replace `tied' = sum(`tied')
		by `timeout': replace `tied' = 0 if _n<_N
		count if `tied'>0
		local nties = r(N)
		if `nties'>0 {
			noi di
			noi di in gr /*
			*/ "There were `nties' tied times involving failure(s)"
			noi di in gr _col(3) /*
			*/  "- failures assumed to precede censorings,"
			noi di in gr _col(3) /*
			*/ "- tied failure times split at random"
/*
			by `timeout': replace `timeout'=`timeout' + /*
			*/ cond(`d'==0, 5*`jitter', /*
			*/ invnorm(uniform())*`jitter') /*
			*/ if _N != 1
*/
		}

		/* sorts with cases first, in order of timeout */

		replace `d' = 1-`d'
		sort `d' `timeout' `mid'
		replace `d' = 1-`d'
	
		/* counts number of cases */
	
		count if `d'==1
		scalar `nc'=r(N)
		noi di
		noi di in gr "There are " in ye `nc' in gr " cases"
	
		/* sets initial values */
	
		gen `c(obs_t)' `idd'=_n
		gen long `setid'=.
		scalar `obs'=_N
		scalar `tmpobs'=_N 
		gen byte `include'=.
		gen `ttype' `ctime'=.
		lab var `d' "0 for controls; 1 for cases"
		lab var `setid' "case-control ID"
		lab var `ctime' "analysis time of the case's failure"
	
		/* sample each set in turn */
	
		noi di in gr "Sampling " in ye "`number'" in gr /*
		*/ " controls for each case "
		local case = 1
		while `case'<=`nc' {
			if "`dots'"=="" {
				noi di  "." _continue
			}
			local ftime = `timeout'[`case']
			replace `include'= (_n != `case')
			tokenize "`match'"
			while "`1'" != "" {
				/* sets include=1 for all records which pass
				the matching criteria except the current case */
				replace `include' = /*
				*/ `include' & (`1' == `1'[`case'])
				mac shift
       		  	}
			replace `include'=`include' & `timein'<=`ftime' /*
			*/ & `timeout'>=`ftime' & `idd'<.
	
			/* selects random sample from all records with
							 include = 1 */
			noi RSamp `idd' if `include', gen(`sel') n(`number')
			/* counts how many controls are selected */

			count if `sel'==1
			scalar `incr'=r(N) + 1
	
			/* expands selected controls and current case*/
	
			expand 2 if `idd'==`idd'[`case'] | `sel'==1
			replace `setid'=`case' if _n>`tmpobs'
			replace `ctime'=`timeout'[`case'] if _n>`tmpobs'
			replace `d'=0 if /*
			*/ `d'==1 & _n> `tmpobs' & `idd' != `idd'[`case']
			replace `idd'=. if _n>`obs'
			local case = `case'+1
			scalar `tmpobs' = `tmpobs' + `incr'
			drop `sel'
		}
		drop if _n<=`obs'
	}
	di
	sort `setid' `d' `mid'
	st_set clear
end

program define RSamp
	version 6, missing
	syntax varname [if] [, GENerate(string) Number(integer 1) ]
	tokenize `varlist'
	local id `1'
	tempvar u include
	confirm new var `generate'
	qui {
		qui gen `generate'=0
		qui count `if' `in'
		if r(N)<`number' {
			noi di in bl /*
			*/ " Warning: sample requested greater" /*
			*/ " than population. Only " r(N) " controls selected"
			replace `generate' = 1 `if' `in'
			exit 
		}
		qui gen `u'=uniform() `if' `in'
		sort `u'
		qui replace `generate'=1 in 1/`number'
		sort `id'
	}
end

/*
	note: the old -sttocc- (version 6.0.8 and previous) uses a jitter
	      value to break the tied failures
	      and censored data, which may not be necessary.  This version
	      does not use jitter, but changes the condition:

			replace `include'=`include' & `timein'<=`ftime' /*
			*/ & `timeout'>=`ftime' & `idd'<.

	      This should also take care of the cases where the enter time is
	      the same as failure time.
*/

