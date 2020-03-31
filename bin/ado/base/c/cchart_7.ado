*! version 2.1.3  17jun1999
program define cchart_7
	version 6
	syntax varlist(min=2 max=2) [, *] 
	tokenize `varlist'
	local DEFECTS "`1'"
	local UNIT "`2'"
	tempvar CBAR NUNITS
		/*
		   calculate _cbar, the mean number of defects
		*/
	gen long `NUNITS' = sum(`DEFECTS'~=. & `DEFECTS'>=0 & `UNIT'~=.)
	gen float `CBAR' = sum(`DEFECTS')
	local cbar = `CBAR'[_N]/`NUNITS'[_N]
		/*
		   calculate the control limits and draw the c-chart
		*/
	local UCL = `cbar' + 3*sqrt(`cbar')
	local LCL = cond(`cbar'>3*sqrt(`cbar'),`cbar'-3*sqrt(`cbar'),0)
	quietly replace `NUNITS' = sum(`DEFECTS'<`LCL' | `DEFECTS'>`UCL')
	local top "(1 unit is out of control)"
	if `NUNITS'[_N]!=1 {
		local top = `NUNITS'[_N]
		local top = "(`top' units are out of control)"
	}
	#delimit ;
	gr7 `DEFECTS' `UNIT', c(l) s(o) sort `options'
		rlab(`cbar',`UCL',`LCL') yline(`UCL',`LCL')
		t1("`top'") l1("Number of defects") ;
	#delimit cr
end
