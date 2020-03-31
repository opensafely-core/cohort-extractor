*! version 1.1.5  03dec2000 updated 28sep2004
program define qladder_7
	version 6, missing

	syntax varname(numeric) [if] [in] [, Grid Margin(passthru) /*
	*/	 scale(real 1.25) SYmbol(passthru) SAVing(passthru) ]

	local v `varlist'
	marksample touse

	if `scale'<=0 | `scale'>400 { 
		di in red "scale() must be between 1 and 400; default is 1.25"
		exit 198
	}

	qui count if `touse'
	if r(N) < 3 {
		error 2001
	}
	qui count if `touse' & (`v') < 0
	local r1 = r(N)
	qui count if `touse' & (`v') == 0
	local r2 = r(N)

	local type 3
	if `r1'>0 & `r2'==0  {
		local type 2		/* negative only */
	}
	if `r1'==0 & `r2'>0 {
		local type 1		/* zero only */
	}
	if `r1'==0 & `r2'==0 {
		local type 0		/* all positive */
	}

	* use larger symbols in subplots
	local tsize : set textsize
	local ntsize = min(int(`tsize' * `scale'), 400)
	set textsize `ntsize'

	local wasgr : set graphics
	qui set graphics off

	* no requirements on domain
	tempfile f1 f2 f3
	Qplot =`v'^3 if `touse' , saving(`f1') ti(cubic)  `grid'  `symbol'
	Qplot =`v'^2 if `touse' , saving(`f2') ti(square)  `grid' `symbol'
	Qplot =`v'^1 if `touse' , saving(`f3') ti(identity) `grid' `symbol'

	* requirement: domain v>=0
	if (`type' == 1) | (`type' == 0) {
		tempfile f4
		Qplot =sqrt(`v') if `touse' , saving(`f4') ti(sqrt) /*
			*/ `grid' `symbol'
	}

	* requirement: domain v>0
	if `type' == 0 {
		tempfile f5 f6
		Qplot =log(`v') if `touse' , saving(`f5') ti(log) /*
			*/ `grid' `symbol'
		Qplot =-1/sqrt(`v') if `touse' , saving(`f6') ti(1/sqrt) /*
			*/ `grid' `symbol'
	}

	* requirement: domain v != 0
	if (`type' == 0) | (`type' == 2) {
		tempfile f7 f8 f9
		Qplot =-1/(`v') if `touse' , saving(`f7') ti(inverse) /*
			*/  `grid' `symbol'
		Qplot =-1/(`v'^2) if `touse' , saving(`f8') ti(1/square) /*
			*/ `grid' `symbol'
		Qplot =-1/(`v'^3) if `touse' , saving(`f9') ti(1/cube) /*
			*/ `grid' `symbol'
	}

	set textsize `tsize'

	if "`grid'" != "" {
	   local t2 "t2(Grid lines are 5,10,25,50,75,90, and 95 percentiles)"
	}

	local vn : var label `v'
	if "`vn'" == "" {
		local b2 b2(`v')
	}
	else	local b2 b2(`vn')

	qui set graphics `wasgr'

	gr7 using `f1' `f2' `f3' `f4' `f5' `f6' `f7' `f8' `f9' , /*
		*/ `t2' `b2' b1(Quantile-Normal Plots by Transformation) /*
		*/ `margin' `saving'
end

program define Qplot
	syntax =/exp if , saving(passthru) Title(str) [ grid symbol(passthru)]
	tempvar fv
	qui gen `fv' = `exp' `if'
	nobreak {
		capture qnorm `fv' `if', `saving' `grid' `symbol'/*
			*/ t1(`title') b1(" ") b2(" ") l1(" ")
	}
end
