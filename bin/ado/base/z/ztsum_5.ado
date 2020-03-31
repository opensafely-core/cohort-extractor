*! version 5.0.3  09feb2015
program define ztsum_5
	version 5.0, missing
	di in gr "(you are running stsum from Stata version 5)"

	zt_is_5
	local if "opt"
	local in "opt"
	local options "BY(string) noSHow"
	parse "`*'"

	if "`by'"!="" {
		unabbrev `by'
		local by "$S_1"
	}
	tempvar touse
	zt_smp_5 `touse' "`if'" "`in'" "`by'" ""

	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	quietly {
		if "`t0'"!="" {
			tempvar atrisk
			gen double `atrisk' = `t'-`t0' if `touse'
		}
		else 	local atrisk "`t'"
	}

	zt_sho_5 `show'
	di
	DispHdr `by'

	if "`by'" != "" {
		tempvar grp subuse
		sort `touse' `by' 
		qui by `touse' `by': gen `c(obs_t)' `grp'=1 if _n==1 & `touse'
		qui replace `grp'=sum(`grp') if `touse'
		local ng = `grp'[_N]
		local i 1
		while `i' <= `ng' {
			qui gen byte `subuse'=`touse' & `grp'==`i'
			DoStats `subuse' `atrisk' "`by'"
			drop `subuse'
			local i = `i' + 1
		}
		di in gr _dup(9) "-" "+" _dup(69) "-"
	}
	DoStats `touse' `atrisk' ""
end

program define DoStats /* touse atrisk by */
	local touse "`1'"
	local atrisk "`2'"
	local by "`3'"

	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local reald : char _dta[st_d]
	local id : char _dta[st_id]
	local wv  : char _dta[st_wv]

	tempvar d
	if "`reald'"=="" {
		qui gen byte `d' = 1
	}
	else {
		qui gen byte `d' = (`reald'!=0)
	}

	tempname tatr m s j0
	quietly {
		if "`wv'"=="" {
			summ `atrisk' if `touse'
			scalar `tatr' = _result(18)
			summ `d' if `touse'
			local fail = _result(18)
			if "`id'"=="" {
				count if `touse'
				local nsubj = _result(1)
			}
			else {
				sort `touse' `id'
				by `touse' `id': /*
				*/ gen byte `m'=1 if _n==1 & `touse'
				summ `m'
				local nsubj = _result(18)
			}
		}
		else {
			tempvar z
			gen double `z' = `wv'*`atrisk'
			summ `z' if `touse'
			scalar `tatr' = _result(18)
			replace `z' = `wv'*`d'
			summ `z' if `touse'
			local fail = _result(18)
			drop `z'
			if "`id'"=="" {
				summ `wv' if `touse'
				local nsubj = _result(18)
			}
			else {
				sort `touse' `id'
				by `touse' `id': /*
				*/ gen double `z'=`wv' if _n==1 & `touse'
				summ `z' if `touse'
				local nsubj = _result(18)
			}
		}

		Settitle `touse' "`by'"
		local ttl "$S_1"

		* stcox if `touse', estimate bases(`s')
		capture GetS `touse' `s'
		if _rc==0 { 
			replace `touse' = 0 if `s'>=.
			sort `touse' `t' 
			gen `c(obs_t)' `j0' = _n if `touse'==0
			summ `j0'
			local j0 = cond(_result(6)>=.,1,_result(6)+1)

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
	Displine "`ttl'" `tatr' `ir' `nsubj' `p25' `p50' `p75'
	global S_1 = `tatr'
	global S_2 `ir'
	global S_3 `nsubj'
	global S_4 `p25'
	global S_5 `p50'
	global S_6 `p75'
end

program define Findptl /* percentile s `j0' */
	local p `1'
	local s "`2'"
	local j0 `3'

	if `j0'>=. {
		global S_1 . 
		exit
	}

	tempvar j
	quietly {
		gen `c(obs_t)'  `j' = _n if `s'<=`p' in `j0'/l
		summ `j' in `j0'/l
		local j=_result(5)
	}
	local t : char _dta[st_t]
	global S_1 = `t'[`j']
end

program define Settitle /* touse byvars */
	local touse "`1'"
	local byvars "`2'"

	if "`byvars'"=="" {
		global S_1 "total"
		exit
	}
	quietly {
		tempvar j
		gen `c(obs_t)' `j' = _n if `touse'
		summ `j'
		local j = _result(5)
	}
	parse "`byvars'", parse(" ")
	while "`1'"!="" {
		local ty : type `1'
		if bsubstr("`ty'",1,3)=="str" {
			local v = substr(trim(`1'[`j']),1,8)
		}
		else {
			local lab : value label `1'
			local v = `1'[`j']
			if "`lab'"!="" {
				local v : label `lab' `v'
			}
		}
		if index("`v'"," ") {
			local v = substr("`v'",1,index("`v'"," ")-1)
		}
		local list "`list' `v'"
		mac shift 
	}
	global S_1 "`list'"
end


program define DispHdr /* by */
	local n : word count `*'
	local i 1 
	while `i' <= `n'-2 {
		di in gr "`1'" _col(10) "|"
		mac shift 
		local i = `i' + 1
	}
	if "`2'"=="" {
		local ttl2 "`1'"
	}
	else {
		local ttl1 "`1'"
		local ttl2 "`2'"
	}

	di in gr "`ttl1'" _col(10) "|" _col(26) "incidence" /*
	*/ _col(42) "no. of" /*
	*/ _col(52) "|------ Survival time -----|"
	di in gr "`ttl2'" _col(10) "| time at risk" _col(29) "rate" /*
	*/ _col(41) "subjects" /*
	*/ _col(57) "25%" _col(67) "50%" _col(77) "75%" _n /* 
	*/ _dup(9) "-" "+" _dup(69) "-"
end

program define Displine 
	local ttl = trim("`1'")
	local tatr `2'
	local ir `3'
	local nsubj `4'
	local s25 `5'
	local s50 `6'
	local s75 `7'

	if length("`ttl'") > 8 {
		local n : word count `ttl'
		local i 1
		while `i' < `n' {
			local this : word `i' of `ttl'
			local skip = 8-length("`this'")
			di in gr _skip(`skip') "`this' |"
			local i = `i' + 1
		}
		local ttl : word `n' of `ttl'
	}
	local skip = 8-length("`ttl'")
	di in gr _skip(`skip') "`ttl' | " in ye /*
	*/ %12.0g `tatr' "  " %9.0g `ir' /*
	*/ _col(40) %9.0g `nsubj' "  " /*
	*/ %9.0g `s25' " " %9.0g `s50' " " %9.0g `s75'
end

program define GetS /* touse s */
	local touse "`1'"
	local s "`2'"

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

