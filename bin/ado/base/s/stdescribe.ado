*! version 1.0.2  16feb2015
program define stdescribe, rclass byable(recall) sort
	version 6, missing
	if _caller()<6 {
		if _by() { error 190 }
		ztdes_5 `0'
		exit
	}
	st_is 2 full
	syntax [if/] [in] [, noSHow Weight]
        local tmpwgt "`weight'"
        local weight
        marksample touse
        local weight "`tmpwgt'"
        local tmpwgt
	qui replace `touse' = 0 if _st==0

	local id : char _dta[st_id]
	local w  : char _dta[st_wv]
	local realw `"`w'"'

	if `"`weight'"'=="" { 
		local w 
	}

	st_show `show'
	di
	DispHdr `"`realw'"' `"`w'"'

	local realid `"`id'"'

	tempvar z
	quietly {
		if `"`w'"'=="" {
			local w 1
		}
		if "`id'"=="" {
			tempvar id 
			gen `c(obs_t)' `id' = _n if `touse'
		}
		sort `touse' `id' _t
		by `touse' `id': gen double `z'=`w' if _n==1 & `touse'
		summ `z' if `touse'
		local nsubj = r(sum)
		drop `z'
	}
	Displine "no. of subjects" `nsubj'

	quietly {
		if `"`w'"'!="1" {
			summ `w' if `touse', meanonly
			local nrec = r(sum)
		}
		else {
			count if `touse'
			local nrec = r(N)
		}
		by `touse' `id': gen `c(obs_t)' `z' = _N if _n==1 & `touse'
		summ `z' [aw=`w'] if `touse', detail
		local mrec = r(mean)
		local mnrec = r(min)
		local mdrec = r(p50)
		local mxrec = r(max)
		drop `z'
	}
	Displine "no. of records" `nrec' `mrec' `mnrec' `mdrec' `mxrec'

	qui by `touse' `id': gen double `z'=_t0 if _n==1 & `touse'
	qui summ `z' [aw=`w'] if `touse', detail
	local mt0 = r(mean)
	local mnt0 = r(min)
	local mdt0 = r(p50)
	local mxt0 = r(max)
	drop `z'
	
	di
	Displine "(first) entry time" "" `mt0' `mnt0' `mdt0' `mxt0'

	quietly { 
		by `touse' `id': gen double `z'=_t if _n==_N & `touse'
		qui summ `z' [aw=`w'] if `touse', detail
		local mt1 = r(mean)
		local mnt1 = r(min)
		local mdt1 = r(p50)
		local mxt1 = r(max)
		drop `z'
	}
	Displine "(final) exit time" "" `mt1' `mnt1' `mdt1' `mxt1'

	di
	if `"`realid'"'==`""' {
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
		qui by `touse' `id': gen double `z' = _t0-_t[_n-1] if `touse'
		tempvar hasgap
		qui by `touse' `id': gen double `hasgap'=/*
			*/ cond(_n==_N,`w'*(sum(`z'>0 & `z'<.)!=0),.) /*
			*/ if `touse'
		qui summ `hasgap' if `touse', meanonly
		local ngsub = r(sum)
		Displine "subjects with gap" `ngsub'
		drop `hasgap'

		qui replace `z'=. if `z'==0 & `touse'
		qui summ `z' [aw=`w'] if `touse', detail
		local mgap = r(mean)
		local mngap = r(min)
		local mdgap = r(p50)
		local mxgap = r(max)
		local ttlgap = r(sum)
		drop `z'
		Displine "time on gap if gap" /*
			*/ `ttlgap' `mgap' `mngap' `mdgap' `mxgap'
	}

	quietly {
		gen double `z' = _t - _t0 if `touse'
		by `touse' `id': replace `z' = /*
			*/ cond(_n==_N,sum(`z'), .) if `touse'
		qui summ `z' [aw=`w'] if `touse', detail
		local mr = r(mean)
		local mnr = r(min)
		local mdr = r(p50)
		local mxr = r(max)
		local ttlr = r(sum)
		drop `z'
	}
	Displine "time at risk" `ttlr' `mr' `mnr' `mdr' `mxr'

	quietly { 
		by `touse' `id': gen double `z' = cond(_n==_N,sum(_d!=0),.) /*
			*/ if `touse'
		summ `z' [aw=`w'] if `touse', detail
		local mf = r(mean)
		local mnf = r(min)
		local mdf = r(p50)
		local mxf = r(max)
		local ttlf = r(sum)
		drop `z'
	}
	di
	Displine "failures" `ttlf' `mf' `mnf' `mdf' `mxf'
	di in smcl in gr "{hline 78}"

	ret scalar N_sub    =  `nsubj'
	ret scalar N_total  =  `nrec'
	ret scalar N_mean   =  `mrec'
	ret scalar N_min    =  `mnrec'
	ret scalar N_med    =  `mdrec'
	ret scalar N_max    =  `mxrec'
	ret scalar t0_mean  =  `mt0'
	ret scalar t0_min   =  `mnt0'
	ret scalar t0_med   =  `mdt0'
	ret scalar t0_max   =  `mxt0'
	ret scalar t1_mean  =  `mt1'
	ret scalar t1_min   =  `mnt1'
	ret scalar t1_med   =  `mdt1'
	ret scalar t1_max   =  `mxt1'
	ret scalar N_gap    =  `ngsub'
	ret scalar gap      =  `ttlgap'
	ret scalar gap_mean =  `mgap'
	ret scalar gap_min  =  `mngap'
	ret scalar gap_med  =  `mdgap'
	ret scalar gap_max  =  `mxgap'
	ret scalar tr       =  `ttlr'
	ret scalar tr_mean  =  `mr'
	ret scalar tr_min   =  `mnr'
	ret scalar tr_med   =  `mdr'
	ret scalar tr_max   =  `mxr'
	ret scalar N_fail   =  `ttlf'
	ret scalar f_mean   =  `mf'
	ret scalar f_min    =  `mnf'
	ret scalar f_med    =  `mdf'
	ret scalar f_max    =  `mxf'

	/* Double saves */
	global S_1 `return(N_sub)'
	global S_2 `return(N_total)'
	global S_3 `return(N_mean)'
	global S_4 `return(N_min)'
	global S_5 `return(N_med)'
	global S_6 `return(N_max)'
	global S_7 `return(t0_mean)'
	global S_8 `return(t0_min)'
	global S_9 `return(t0_med)'
	global S_10 `return(t0_max)'
	global S_11 `return(t1_mean)'
	global S_12 `return(t1_min)'
	global S_13 `return(t1_med)'
	global S_14 `return(t1_max)'
	global S_15 `return(N_gap)'
	global S_16 `return(gap)'
	global S_17 `return(gap_mean)'
	global S_18 `return(gap_min)'
	global S_19 `return(gap_med)'
	global S_20 `return(gap_max)'
	global S_21 `return(tr)'
	global S_22 `return(tr_mean)'
	global S_23 `return(tr_min)'
	global S_24 `return(tr_med)'
	global S_25 `return(tr_max)'
	global S_26 `return(N_fail)'
	global S_27 `return(f_mean)'
	global S_28 `return(f_min)'
	global S_29 `return(f_med)'
	global S_30 `return(f_max)'
end



program define DispHdr /* realw w */
	di in smcl in gr _col(36) /*
	*/ "{c LT}{hline 14} per subject {hline 14}{c RT}"
	if `"`1'"'!=`""' {
		if `"`2'"'!=`""' {
			local word " weighted"
		}
		else	local word "unweighted"
		di in gr _col(25) "`word'" _col(38) "`word'" _col(60) "`word'"
	}
	di in smcl in gr "Category" _col(28) "total" _col(41) "mean" /* 
	*/ _col(54) "min" _col(62) "median" _col(76) "max" _n /* 
	*/ "{hline 78}"
end

program define Displine /* cat total mean min med max */
	args cat total mean min med max

	di in gr `"`cat'"' _col(23) _c
	if `"`total'"'!=`""' {
		di in ye %10.0g `total' "   " _c
	}
	else	di _skip(13) _c
	if `"`mean'"'=="" {
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


