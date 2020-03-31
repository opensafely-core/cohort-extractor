*! version 5.0.3  16feb2015
program define ztdes_5
	version 5.0, missing
	di in gr "(you are running stdes from Stata version 5)"
	zt_is_5
	local if "opt"
	local in "opt"
	local options "noSHow Weight"
	parse "`*'"


	if "`if'"!="" | "`in'" !="" {
		preserve
		qui keep `if' `in'
	}

	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d : char _dta[st_d]
	local id : char _dta[st_id]
	local w  : char _dta[st_wv]
	local realw "`w'"

	if "`d'"=="" {
		local d 1
	}

	if "`weight'"=="" { 
		local w 
	}

	zt_sho_5 `show'
	di
	DispHdr "`realw'" "`w'"

	local realid "`id'"

	tempvar z
	quietly {
		if "`w'"=="" {
			local w 1
		}
		if "`id'"=="" {
			tempvar id 
			gen `c(obs_t)' `id' = _n
		}
		sort `id' `t'
		by `id': gen double `z'=`w' if _n==1
		summ `z'
		local nsubj = _result(18)
		drop `z'
	}
	Displine "no. of subjects" `nsubj'

	quietly {
		if "`w'"!="1" {
			summ `w', meanonly
			local nrec = _result(18)
		}
		else	local nrec = _N
		by `id': gen `c(obs_t)' `z' = _N if _n==1
		summ `z' [aw=`w'], detail
		local mrec = _result(3)
		local mnrec = _result(5)
		local mdrec = _result(10)
		local mxrec = _result(6)
		drop `z'
	}
	Displine "no. of records" `nrec' `mrec' `mnrec' `mdrec' `mxrec'

	if "`t0'"=="" {
		local mt0 0
		local mnt0 0
		local mdt0 0
		local mxt0 0
	}
	else {
		qui by `id': gen double `z'=`t0' if _n==1
		qui summ `z' [aw=`w'], detail
		local mt0 = _result(3)
		local mnt0 = _result(5)
		local mdt0 = _result(10)
		local mxt0 = _result(6)
		drop `z'
	}
	di
	Displine "(first) entry time" "" `mt0' `mnt0' `mdt0' `mxt0'

	quietly { 
		by `id': gen double `z'=`t' if _n==_N
		qui summ `z' [aw=`w'], detail
		local mt1 = _result(3)
		local mnt1 = _result(5)
		local mdt1 = _result(10)
		local mxt1 = _result(6)
		drop `z'
	}
	Displine "(final) exit time" "" `mt1' `mnt1' `mdt1' `mxt1'

	di
	if "`realid'"=="" {
		local ngsub 0
		local ttlgap 0
		local mgap .
		local mngap .
		local mdgap .
		local mxgap .
		Displine "subjects with gap" 0 
		Displine "time on gap if gap" 0
	}
	else {
		qui by `id': gen double `z' = `t0'-`t'[_n-1]
		tempvar hasgap
		qui by `id': gen double `hasgap'=cond(_n==_N,`w'*(sum(`z'>0 & `z'<.)!=0),.)
		qui summ `hasgap', meanonly
		local ngsub = _result(18)
		Displine "subjects with gap" `ngsub'
		drop `hasgap'

		qui replace `z'=. if `z'==0
		qui summ `z' [aw=`w'], detail
		local mgap = _result(3)
		local mngap = _result(5)
		local mdgap = _result(10)
		local mxgap = _result(6)
		local ttlgap = _result(18)
		drop `z'
		Displine "time on gap if gap" /*
			*/ `ttlgap' `mgap' `mngap' `mdgap' `mxgap'
	}

	quietly {
		if "`t0'"=="" {
			gen double `z' = `t'
		}
		else	gen double `z' = `t' - `t0'
		by `id': replace `z' = cond(_n==_N,sum(`z'), .)
		qui summ `z' [aw=`w'], detail
		local mr = _result(3)
		local mnr = _result(5)
		local mdr = _result(10)
		local mxr = _result(6)
		local ttlr = _result(18)
		drop `z'
	}
	Displine "time at risk" `ttlr' `mr' `mnr' `mdr' `mxr'

	quietly { 
		by `id': gen double `z' = cond(_n==_N,sum(`d'!=0),.)
		summ `z' [aw=`w'], detail
		local mf = _result(3)
		local mnf = _result(5)
		local mdf = _result(10)
		local mxf = _result(6)
		local ttlf = _result(18)
		drop `z'
	}
	di
	Displine "failures" `ttlf' `mf' `mnf' `mdf' `mxf'
	di in gr _dup(78) "-"

	global S_1 `nsubj'

	global S_2 `nrec'
	global S_3 `mrec'
	global S_4 `mnrec'
	global S_5 `mdrec'
	global S_6 `mxrec'

	global S_7 `mt0'
	global S_8 `mnt0'
	global S_9 `mdt0'
	global S_10 `mxt0'

	global S_11 `mt1'
	global S_12 `mnt1'
	global S_13 `mdt1'
	global S_14 `mxt1'

	global S_15 `ngsub'

	global S_16 `ttlgap'
	global S_17 `mgap'
	global S_18 `mngap'
	global S_19 `mdgap'
	global S_20 `mxgap'

	global S_21 `ttlr'
	global S_22 `mr'
	global S_23 `mnr'
	global S_24 `mdr'
	global S_25 `mxr'

	global S_26 `ttlf'
	global S_27 `mf'
	global S_28 `mnf'
	global S_29 `mdf'
	global S_30 `mxf'
end



program define DispHdr /* realw w */
	di in gr _col(36) "|" _dup(14) "-" " per subject " _dup(14) "-" "|"
	if "`1'"!="" {
		if "`2'"!="" {
			local word " weighted"
		}
		else	local word "unweighted"
		di in gr _col(25) "`word'" _col(38) "`word'" _col(60) "`word'"
	}
	di in gr "Category" _col(28) "total" _col(41) "mean" /* 
	*/ _col(54) "min" _col(62) "median" _col(76) "max" _n /* 
	*/ _dup(78) "-"
end

program define Displine /* cat total mean min med max */
	local cat "`1'"
	local total `2'
	local mean `3'
	local min `4'
	local med `5'
	local max `6'

	di in gr "`cat'" _col(23) _c
	if "`total'"!="" {
		di in ye %10.0g `total' "   " _c
	}
	else	di _skip(13) _c
	if "`mean'"=="" {
		di
		exit
	}
	di in ye %9.0g `mean' "   " /* 
	*/ %9.0g `min' "  " /* 
	*/ %9.0g `med' "  " /*
	*/ %9.0g `max'
end

	
exit
                                   |-------------- per subject --------------|
Category                   total        mean        min      median        max 
------------------------------------------------------------------------------
No. of subjects               27
No. of records        1234567890   123456789   123456789  123456789  123456789
                                123         123         12         12
(first) entry time                           0         0     0       0
(final) exit time                           22        24    25      30
Gaps                        29384
time-at-risk               238493           ..

failures                     ...          
-----------------------------------------------------------------------------


