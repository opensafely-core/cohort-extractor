*! version 1.1.2  20jan2015
program define wntestb_7
	version 6.0, missing
	capture noisily WNtestb `0'
	mac drop S_GPH_ax S_GPH_bx S_GPH_ay S_GPH_by S_1 
	exit _rc
end


program define WNtestb, rclass

	syntax varname(ts) [if] [in] [, Level(integer $S_level) /*
		*/ SAving(passthru) GRaph TAble T1title(string) /*
		*/ XLAbel(string) L1title(string) T2title(string) /*
		*/ YLAbel(string) xsize(passthru) ysize(passthru) *]

	marksample touse
	_ts tvar panelvar `if' `in', sort onepanel
	markout `touse' `tvar'

	if "`graph'" != "" & "`table'" != "" {
		di in red "must choose only one of table or graph options"
		exit 198
	}
	local graph "`table'"


	if `level'<10 | `level'>99 {
                local level 95
        }

	quietly {

		_crcchkt if `touse', t(`tvar')

		* Sample is set and t variable verified to be good

		tempvar x xr xi w 
		gen double `x' = `varlist' if `touse'

                preserve
                keep if `touse'

		local N    = _N
		local samp "in 1/`N'"
		local n1   = int(`N'/2)+1

		gen double `w'=((_n-1)/`N') in 1/`n1'

		fft `x', gen(`xr' `xi')
		replace `xr' = 0 in 1
		replace `xi' = 0 in 1
		replace `xr' = sum(`xr'*`xr'+`xi'*`xi')
		local    ss  = `xr' in `n1'
		replace `xr' = `xr'/`ss'
	}
	label var `xr' "Cumulative periodogram for `varlist'"
	label var `w'  "Frequency"

	qui replace `x' = .
	qui replace `x' = abs(`xr'-2*`w') in 1/`n1'
	qui sum `x'
	local stat = sqrt(`n1')*r(max)     
	qui bartcdf `stat'
	local pvalue = 1-r(prob)

	* Add test in here and save results in the S_# macros

	if "`graph'" == "" {

		gph open, `saving' `xsize' `ysize'

		if `"`t1title'"' == "" {
			local t1title "Cumulative Periodogram White Noise Test"
		}
		if `"`t2title'"' == "" {
			local t2title : di "Bartlett's (B) statistic = " /*
				*/ %8.2f `stat' "   Prob > B = " %6.4f `pvalue'
		}
		if `"`l1title'"' == "" {
			local l1title "Cumulative Periodogram for `varlist'"
		}
		if `"`xlabel'"' == "" {
			local xlabel "0,.1,.2,.3,.4,.5"
		}

		if `"`ylabel'"' == "" {
			local ylabel "0,.2,.4,.6,.8,1"
		}

		format `xr' `w' %-5.2f

		gr7 `xr' `w', s(i) xlab(`xlabel') ylab(`ylabel') `options' /*
			*/  l1(`"`l1title'"') border t1(`"`t1title'"') /*
			*/  t2(`"`t2title'"')
		gphsave
		gph pen 2

		tempvar size
		qui gen int `size' = 175
		qui gphdt vpoint `xr' `w' `size' `samp'

		* qui gphdt text 1 .25 0 0 /*$S_3*/  /* don't display $S_3 */
		gph pen 1

		gph pen 3
		qui gphdt li 0 0 1 .5

		local lev = `level'/100
		bartq `lev'
				
		local sq1 = r(u)/sqrt(`n1')
		local sq2 = 1.-`sq1'
		local sq3 = `sq2'/2
		local sq4 = `sq1'/2

		if "$S_OS"  ==  "Unix" {
			gph pen 5
		}
		else    gph pen 4

		gphdt line `sq1' 0 1 `sq3' 
		gphdt line 0 `sq4' `sq2'  .5 

		gph close
	}

	else {
		di _n in gr "Cumulative periodogram white noise test"
		di in smcl in gr "{hline 39}"
		di in gr " Bartlett's (B) statistic  = " in ye %10.4f `stat'
		di in gr " Prob > B                  = " in ye %10.4f `pvalue'
	}

	return scalar stat = `stat'
	return scalar p    = `pvalue'
end

program define bartcdf, rclass
	confirm number `1'

	local a `1'
	local eps = .00001

	if `a' < 0.3 {
		local prob = 0
	}
	else {
		local prob = 1
		local i    = 1

		while `i' <= 100 {
			local del = 2*(-1.)^`i'*exp(-2*`a'^2*`i'^2)

			if abs(`del') < `eps'*`prob' { 
				local i = 101
			}
			else {
				local prob = `prob'+`del'
				local i = `i'+1
			}
		}

	}
	return scalar prob = `prob'
end


program define bartq, rclass
	confirm number `1'
	local u `1'

	if `u' <= 0.0 | `u' >= 1.0 {
		noi di in red "argument of bartq must be in (0,1)"
		exit 198
	}

	local left=.3
	local right=2.
	local middle=1.15
	local eps=.0001

	local i=1
	while `i' <= 100 {

		bartcdf `middle'

		if r(prob) < `u' { local left  = `middle' }
		else             { local right = `middle' }

		local del=`right'-`left'

		if `del' < `eps' {
			local i  = 101
			local S2 = `middle'
		}			
		else {
			local i = `i'+1
			local middle = (`left'+`right')/2.
		}
						
	}

	return scalar u = `S2'
end


program define _crcchkt
	syntax [if] [in] [, t(varname)]
 
	xt_tis `t'

	local realt "`s(timevar)'"
	tempvar tt
	gen `tt' = D.`realt' `if' `in'
	summ `tt' `if' `in'
	capture assert r(min)==r(max) `if' `in'
	if _rc {
		noi di in red "time variable does not have constant step size"
		exit 198
	}
	if r(min) == 0 {
		noi di in red "tied values in time variable not allowed"
		exit 198
	}
end


program define gphsave
	global S_GPH_ax = r(ax)
	global S_GPH_bx = r(bx)
	global S_GPH_ay = r(ay)
	global S_GPH_by = r(by)
end



program define gphdt
	chksave
			/* clear point vpoint vpoly arc	*/
			/* line vline box text vtext	*/
	local cmd "`1'"  
	mac shift

	GetCmd `cmd'
	local cmd "$S_1" 
	`cmd' `*'
end

program define point
	args y x size symbol

	if "`size'" == "" {
		local size 275
	}
	if "`symbol'" == "" {
		local symbol 0
	}
	ChkNum `y' 
	ChkNum `x' 
	ChkNum `size' 0 20000 integer
	ChkNum `symbol' 0 6 integer
	
	local mapy = ($S_GPH_ay)*`y' + ($S_GPH_by)
	local mapx = ($S_GPH_ax)*`x' + ($S_GPH_bx)

	gph point `mapy' `mapx' `size' `symbol'
end

program define vpoint
	syntax varlist(min=2 max=4) [if] [in] [, /*
		*/ SYmbol(integer 4) SIze(integer 275) ]
	tokenize `varlist'
	local y "`1'"
	local x "`2'"
	local si "`3'"
	local sy "`4'"

	ChkNumv , args(`y')
	ChkNumv , args(`x')
	if "`si'" != ""   { 
		ChkNumv `if' `in', args(`si' 0 .)
	}
	else {
		ChkNum `size' 0 .    
		local args "size(`size')"
	}
	if "`sy'" != "" { 
		ChkNumv `if' `in', args(`sy' 0 6 integer)
	}
	else {
		ChkNum `symbol' 0 6 integer
		local args "`args' symbol(`symbol')"
	}

	tempvar mapy mapx
	gen int `mapy' = ($S_GPH_ay)*`y' + ($S_GPH_by)
	gen int `mapx' = ($S_GPH_ax)*`x' + ($S_GPH_bx)

	gph vpoint `mapy' `mapx' `si' `sy' `if' `in' , `args'
end

program define vpoly
	syntax varlist(min=4) [if] [in]
	local n : word count  `varlist'
	local i = int(`n'/2)*2

	if `i' != `n' { gpherr "Must be an even number of variables in vpoly"}

	local i = int(`n'/2)

	tempvar mapy1 mapx1 mapy2 mapx2

	local inarg: word 1 of `varlist'
	gen int `mapy1'=($S_GPH_ay)*`inarg' + ($S_GPH_by)
	local inarg: word 2 of `varlist'
	gen int `mapx1'=($S_GPH_ax)*`inarg' + ($S_GPH_bx)

	gen int `mapy2'=0
	gen int `mapx2'=0

	local k=3
	local j = 1
	while `j' < `i' {

		if `j' > 1 {
			replace `mapy1'=`mapy2'
			replace `mapx1'=`mapx2'
		}

		local inarg: word `k' of `varlist'
		local k=`k'+1
		replace `mapy2'=($S_GPH_ay)*`inarg' + ($S_GPH_by)
		local inarg: word `k' of `varlist'
		local k=`k'+1
		replace `mapx2'=($S_GPH_ax)*`inarg' + ($S_GPH_bx)

		gph vpoly `mapy1' `mapx1' `mapy2' `mapx2' `if' `in'

		local j=`j'+1

	}

end

program define arc
	args y x rad ang1 ang2 shade

	ChkNum `y' 
	ChkNum `x' 
	ChkNum `rad'
	ChkNum `ang1'
	ChkNum `ang2'
	ChkNum `shade' 0 4 integer

	local mapy=($S_GPH_ay)*`y' +($S_GPH_by)
	local mapx=($S_GPH_ax)*`x' +($S_GPH_bx)
	local rad=($S_GPH_ax)*`rad'
	local ang1=mod(`ang1',360)
	if `ang1' < 0 { local ang1=360+`ang1' }
	local ang1=32767*`ang1'/360
	local ang2=mod(`ang2',360)
	if `ang2' < 0 { local ang2=360+`ang2' }
	local ang2=32767*`ang2'/360

	gph arc `mapy' `mapx' `rad' `ang1' `ang2' `shade'

end

program define line
	args y1 x1 y2 x2

	ChkNum `y1' 
	ChkNum `x1' 
	ChkNum `y2' 
	ChkNum `x2' 

	local mapy1 = ($S_GPH_ay)*`y1' + ($S_GPH_by)
	local mapx1 = ($S_GPH_ax)*`x1' + ($S_GPH_bx)
	local mapy2 = ($S_GPH_ay)*`y2' + ($S_GPH_by)
	local mapx2 = ($S_GPH_ax)*`x2' + ($S_GPH_bx)

	gph line `mapy1' `mapx1' `mapy2' `mapx2'
end

program define vline
	syntax varlist(min=2 max=2) [if] [in]
	tokenize `varlist'
	local y "`1'"
	local x "`2'"

	ChkNumv , args(`y')
	ChkNumv , args(`x')

	tempvar mapy mapx
	gen int `mapy' = ($S_GPH_ay)*`y' + ($S_GPH_by)
	gen int `mapx' = ($S_GPH_ax)*`x' + ($S_GPH_bx)

	gph vline `mapy' `mapx' `if' `in'
end


program define box
	args y1 x1 y2 x2 shade

	if "`shade'" == "" {
		local shade 4
	}
	ChkNum `y1' 
	ChkNum `x1' 
	ChkNum `y2' 
	ChkNum `x2' 

	ChkNum `shade' 0 5 integer
	

	local mapy1 = ($S_GPH_ay)*`y1' + ($S_GPH_by)
	local mapx1 = ($S_GPH_ax)*`x1' + ($S_GPH_bx)
	local mapy2 = ($S_GPH_ay)*`y2' + ($S_GPH_by)
	local mapx2 = ($S_GPH_ax)*`x2' + ($S_GPH_bx)

	if `shade'==5 {
		gph line `mapy1' `mapx1' `mapy2' `mapx1'
		gph line `mapy2' `mapx1' `mapy2' `mapx2'
		gph line `mapy2' `mapx2' `mapy1' `mapx2'
		gph line `mapy1' `mapx2' `mapy1' `mapx1'
	}
	else{
		gph box `mapy1' `mapx1' `mapy2' `mapx2' `shade'
	}

end

program define clear
	args y1 x1 y2 x2

	ChkNum `y1' 
	ChkNum `x1' 
	ChkNum `y2' 
	ChkNum `x2' 

	local mapy1 = ($S_GPH_ay)*`y1' + ($S_GPH_by)
	local mapx1 = ($S_GPH_ax)*`x1' + ($S_GPH_bx)
	local mapy2 = ($S_GPH_ay)*`y2' + ($S_GPH_by)
	local mapx2 = ($S_GPH_ax)*`x2' + ($S_GPH_bx)

	gph clear `mapy1' `mapx1' `mapy2' `mapx2'

end

program define text
	args y x rot align

	local i 5
	while "``i''" != "" {
		local txt "`txt' ``i''"
		local i = `i'+1
	}

	if "`rot'" == "" {
		local rot 0
	}
	if "`align'" == "" {
		local align 0
	}
	ChkNum `y' 
	ChkNum `x' 
	ChkNum `rot' 0 1 integer
	ChkNum `align' -1 1 integer
	
	local mapy = ($S_GPH_ay)*`y' + ($S_GPH_by)
	local mapx = ($S_GPH_ax)*`x' + ($S_GPH_bx)

	gph text `mapy' `mapx' `rot' `align' `txt'
end

program define vtext
	syntax varlist(min=3 max=3) [if] [in]
	tokenize `varlist'
	local y "`1'"
	local x "`2'"
	local txt "`3'"

	ChkNumv , args(`y')
	ChkNumv , args(`x')
	ChkNumv , args(`txt')

	tempvar mapy mapx
	gen int `mapy' = ($S_GPH_ay)*`y' + ($S_GPH_by)
	gen int `mapx' = ($S_GPH_ax)*`x' + ($S_GPH_bx)

	gph vtext `mapy' `mapx' `txt' `if' `in'
end

program define GetCmd
			/* Point VPOInt VPOLy Arc	*/
			/* Line VLine Box Text VText	*/
	local cmd "`1'"

	local l = length("`cmd'")

	if "`cmd'" == bsubstr("point",1,max(`l',1))       { global S_1 "point" }
	else if "`cmd'" == bsubstr("vpoint",1,max(`l',4)) { global S_1 "vpoint"}
	else if "`cmd'" == bsubstr("clear",1,max(`l',1))  { global S_1 "clear"}
	else if "`cmd'" == bsubstr("vpoly",1,max(`l',4))  { global S_1 "vpoly" }
	else if "`cmd'" == bsubstr("arc",1,max(`l',1))    { global S_1 "arc"   }
	else if "`cmd'" == bsubstr("line",1,max(`l',1))   { global S_1 "line"  }
	else if "`cmd'" == bsubstr("vline",1,max(`l',2))  { global S_1 "vline" }
	else if "`cmd'" == bsubstr("box",1,max(`l',1))    { global S_1 "box"   }
	else if "`cmd'" == bsubstr("text",1,max(`l',1))   { global S_1 "text"  }
	else if "`cmd'" == bsubstr("vtext",1,max(`l',2))  { global S_1 "vtext" }
	else {
		capture gph close
		noi di in red "unknown gphdt command: `cmd'"
		exit 198
	}
end
	
	
program define chksave
	capture {
		confirm number $S_GPH_ax
		confirm number $S_GPH_bx
		confirm number $S_GPH_ay
		confirm number $S_GPH_by
	}
	if _rc {
		capture gph close
		noi di in red "graphics conversion parameters were not saved"
		exit 198
	}
end

program define ChkNum
	args num min max typ

	capture confirm number `num'
	if _rc { gpherr "argument was not a number" }

	if "`min'" != "" {
		if `num' < `min' | `num' > `max' {
			gpherr "argument out of range"
		}
	}

	if "`typ'" != "" {
		capture confirm `typ' number `num'
		if _rc { gpherr "argument `num' should be of type `typ'" }
	}
end

program define ChkNumv
	syntax [if] [in], args(string)

	local num : word 1 of `args'
	local min : word 2 of `args'
	local max : word 3 of `args'
	local typ : word 4 of `args'

	capture confirm variable `num'
	if _rc { gpherr "argument `num' was not a numeric variable" }

	if "`min'" != "" {
		summ `num' `if' `in'
		if r(min) < `min' | r(max) > `max' {
			gpherr "argument `num' has values out of range"
		}
	}

	if "`typ'" != "" {
		tempvar r
		gen `r' = int(`num') `if' `in'
		capture assert `num'==`r' `if' `in'
		if _rc { gpherr "argument `num' should have `typ' values" }
	}
end

program define gpherr
	local mesg "`1'"
	capture gph close
	noi di in red "`mesg'"
	exit 198
end
