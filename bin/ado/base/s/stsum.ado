*! version 6.1.0  22feb2015
program define stsum, rclass byable(recall) sort
	version 6, missing

	if _caller()>=6 {
		st_is 2 analysis
		syntax [if] [in] [, BY(varlist) noSHow]

		tempvar touse
		st_smpl `touse' `"`if'"' `"`in'"' `"`by'"' `""'
		if _by() {
			version 7, missing
			local byind "`_byindex'"
			version 6, missing
			qui replace `touse'=0 if `byind'!=_byindex()
			local byind
		}

		quietly {
			tempvar atrisk
			gen double `atrisk' = _t - _t0 if `touse'
		}

		st_show `show'
		di
		DispHdr `by'

		if `"`by'"' != "" {
			tempvar grp subuse
			sort `touse' `by' 
			qui by `touse' `by': gen `c(obs_t)' `grp'=1 if _n==1 & `touse'
			qui replace `grp'=sum(`grp') if `touse'
			local ng = `grp'[_N]
			local i 1
			while `i' <= `ng' {
				qui gen byte `subuse'=`touse' & `grp'==`i'
				DoStats `subuse' `atrisk' `"`by'"'
				drop `subuse'
				local i = `i' + 1
			}
			di in smcl in gr "{hline 9}{c +}{hline 69}"
		}
		DoStats `touse' `atrisk' `""'
		ret add
		exit
	}
	ztsum_5 `0'
end

program define DoStats, rclass /* touse atrisk by */
	args touse atrisk by

	local id : char _dta[st_id]
	local wv  : char _dta[st_wv]

	tempname tatr m s j0
	quietly {
		if `"`wv'"'==`""' {
			summ `atrisk' if `touse'
			scalar `tatr' = r(sum)
			summ _d if `touse'
			local fail = r(sum)
			if `"`id'"'==`""' {
				count if `touse'
				local nsubj = r(N)
			}
			else {
				sort `touse' `id'
				by `touse' `id': /*
				*/ gen byte `m'=1 if _n==1 & `touse'
				summ `m'
				local nsubj = r(sum)
			}
		}
		else {
			tempvar z
			gen double `z' = `wv'*`atrisk'
			summ `z' if `touse'
			scalar `tatr' = r(sum)
			replace `z' = `wv'*_d
			summ `z' if `touse'
			local fail = r(sum)
			drop `z'
			if `"`id'"'==`""' {
				summ `wv' if `touse'
				local nsubj = r(sum)
			}
			else {
				sort `touse' `id'
				by `touse' `id': /*
				*/ gen double `z'=`wv' if _n==1 & `touse'
				summ `z' if `touse'
				local nsubj = r(sum)
			}
		}

		Settitle `touse' `"`by'"'
		local ttl `"$S_1"'

		* stcox if `touse', estimate bases(`s')
		capture GetS `touse' `s'
		if _rc==0 { 
			replace `touse' = 0 if `s'>=.
			sort `touse' _t 
			gen `c(obs_t)' `j0' = _n if `touse'==0
			summ `j0'
			local j0 = cond(r(max)>=.,1,r(max)+1)

			Findptl .75 `s' `j0'
			local p25 $S_1
			Findptl .5 `s' `j0'
			local p50 $S_1
			Findptl .25 `s' `j0'
			local p75 $S_1
		}
		else {
			local p25 .
			local p50 .
			local p75 .
		}
	}

	local ir = `fail'/`tatr'
	Displine `"`ttl'"' `tatr' `ir' `nsubj' `p25' `p50' `p75'

	
	ret scalar risk = `tatr'
	ret scalar ir = `ir'
	ret scalar N_sub = `nsubj'
	ret scalar p25 = `p25'
	ret scalar p50 = `p50'
	ret scalar p75 = `p75'

	/* Double saves */

	global S_1 `return(risk)'
	global S_2 `return(ir)'
	global S_3 `return(N_sub)'
	global S_4 `return(p25)'
	global S_5 `return(p50)'
	global S_6 `return(p75)'
end

program define Findptl /* percentile s `j0' */
	args p s j0

	if `j0'>=. {
		global S_1 . 
		exit
	}

	tempvar j
	quietly {
		gen `c(obs_t)'  `j' = _n if float(`s')<=float(`p') in `j0'/l
		summ `j' in `j0'/l
		local j=r(min)
	}
	local t : char _dta[st_t]
	global S_1 = _t[`j']
end

program define Settitle /* touse byvars */
	args touse byvars

	if `"`byvars'"'==`""' {
		global S_1 `"total"'
		exit
	}
	quietly {
		tempvar j
		gen `c(obs_t)' `j' = _n if `touse'
		summ `j'
		local j = r(min)
	}
	tokenize `"`byvars'"'
	while `"`1'"'!=`""' {
		local ty : type `1'
		if bsubstr(`"`ty'"',1,3)==`"str"' {
			local v = trim(udsubstr(trim(`1'[`j']),1,8))
		}
		else {
			local v = `1'[`j']
			local v : label (`1') `v' 8
		}
/*
		if index(`"`v'"',`" "') {
			local v = bsubstr(`"`v'"',1,index(`"`v'"',`" "')-1)
		}
wwg and next line hit too
*/
		local list `"`list' "`v'""'
		mac shift 
	}
	global S_1 `"`list'"'
end


program define DispHdr /* by */
	local n : word count `*'
	local i 1 
	while `i' <= `n'-2 {
		di in smcl in gr abbrev(`"`1'"',8) _col(10) `"{c |}"'
		mac shift 
		local i = `i' + 1
	}
	if `"`2'"'==`""' {
		local ttl2 = abbrev(`"`1'"',8)
	}
	else {
		local ttl1 = abbrev(`"`1'"',8)
		local ttl2 = abbrev(`"`2'"',8)
	}

	di in smcl in gr `"`ttl1'"' _col(10) `"{c |}"' _col(26) `"incidence"' /*
	*/ _col(42) `"no. of"' /*
	*/ _col(52) "{c LT}{hline 6} Survival time {hline 5}{c RT}" 
	di in smcl in gr /*
	*/ `"`ttl2'"' _col(10) `"{c |} time at risk"' _col(29) `"rate"' /*
	*/ _col(41) `"subjects"' /*
	*/ _col(57) `"25%"' _col(67) `"50%"' _col(77) `"75%"' _n /* 
	*/ "{hline 9}{c +}{hline 69}"
end

program define Displine 
	args ttl tatr ir nsubj s25 s50 s75

	local ttl = trim(`"`ttl'"')

	if udstrlen(`"`ttl'"') > 8 + 2 {	/* +2 to account for quotes */
		local n : word count `ttl'
		local i 1
		while `i' < `n' {
			local this : word `i' of `ttl'
			local skip = 8-udstrlen(`"`this'"')
			di in smcl in gr _skip(`skip') `"`this' {c |}"'
			local i = `i' + 1
		}
		local ttl : word `n' of `ttl'
	}
	else {				/* strip quotes */
		tokenize `"`ttl'"'
		local ttl `*'
	}
	local skip = 8-udstrlen(`"`ttl'"')
	di in smcl in gr _skip(`skip') `"`ttl' {c |} "' in ye /*
	*/ %12.0g `tatr' `"  "' %9.0g `ir' /*
	*/ _col(40) %9.0g `nsubj' `"  "' /*
	*/ %9.0g `s25' `" "' %9.0g `s50' `" "' %9.0g `s75'
end

program define GetS /* touse s */
	args touse s 

	tempname prior
	capture {
		capture estimate hold `prior'
		stcox if `touse', estimate bases(`s')
	}
	local rc=_rc
	capture estimate unhold `prior'
	exit `rc'
end
exit


         |               incidence       no. of    |--- time until failure ---|
  sample | time at risk     rate        subjects        25%       50%       75%
---------+---------------------------------------------------------------------
   total | 123456789012  123456789     123456789  123456789 123456789 123456789

