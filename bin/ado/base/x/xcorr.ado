*! version 1.2.1  05oct2004
program define xcorr
	version 6.0, missing
	if _caller() < 8 {
		local vv = string(_caller())
		version `vv', missing: xcorr_7 `0'
		exit
	}

	syntax varlist(ts) [if] [in] [,		///
		LAGs(int -1)			///
		GENerate(string)		///
		TABle				///
		noPLOT				///
		*				///
	]

	local diplot `plot'

	// parse graph options
	_get_gropts , graphopts(`options') getallowed(plot addplot)
	local options `"`s(graphopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'

	tokenize `varlist'
	local x "`1'"
	local y "`2'"

	marksample touse
	_ts tvar panelvar `if' `in', sort onepanel
	markout `touse' `tvar'

	if "`generate'" != "" {
		capture gen byte `generate' = 0
		if _rc {
			di in red "generate() should name one new variable"
			exit 198
		}
		capture drop `generate'
	}

quietly {

	tempvar  xm ym ac tmp obs 
	tempname R0x R0y 

	describe
	local orig = r(N)

	local sby : sortedby

	summ `x' if `touse'
	scalar `R0x' = r(Var)*(r(N)-1)
	gen double `xm' = `x'-r(mean) if `touse'
	local nx = r(N)

	summ `y' if `touse'
	scalar `R0y' = r(Var)*(r(N)-1)
	gen double `ym' = `y'-r(mean) if `touse'
	local ny = r(N)

	local no = min(`nx',`ny')

	if `lags' < 0 {
		local lags = min(max(1,int(`no'/2)-2),20)
	}
	if `lags' >= int(`no'/2)-2 {
		di in red "lags() too large.  Must be " /*
			*/ "less than " int(`no'/2)-2
		exit 198
	}
	gen long `obs' = .
	gen double `tmp' = .
	gen double `ac'  = .
	local obsp = 1
	local i =  -`lags'       
	while `i' <= `lags' {
		if `i' < 0 {
			local ni = -`i'
			replace `tmp' = `xm'*L`ni'.`ym'
		}
		else {
			replace `tmp' = `xm'*F`i'.`ym'
		}
		summ `tmp' if `touse', meanonly
		replace `ac' = r(sum)/sqrt(`R0x'*`R0y') in `obsp'

		replace `obs' = `i' in `obsp'

		local obsp = `obsp'+1
		local i = `i'+1
	}

	format `ac' %-5.2f

	if "`table'" != "" {
		if "`diplot'" == "" {
			noi di in gr _n /*
			*/ "                 -1       0       1"
			noi di in gr /*
			*/ " LAG      CORR   [Cross-correlation]
			noi di in smcl in gr "{hline 36}"
		}
		else {
			noi di in gr _n " LAG      CORR"
			noi di in smcl in gr "{hline 15}"
		}
		local obsp = 1
		local i = -`lags'
		while `i' <= `lags' {
			noi DiLine `i' `ac'[`obsp'] `diplot'
			local i = `i' + 1
			local obsp = `obsp' + 1
		}
		if "`generate'" != "" {
			rename `ac' `generate'
			format `generate' %9.0g
		}
		exit
	}
} // quietly

	local yttl "Cross-correlations of `x' and `y'"

	version 8: graph twoway			///
	(dropline `ac' `obs',			///
		yaxis(1 2)			///
		ylabels(-1(.5)1, axis(1))	///
		ylabels(-1(.5)1, axis(2))	///
		yticks(0,			///
			grid gmin gmax		///
			notick			///
		)				///
		ytitle(`"`yttl'"')		///
		ytitle(`""', axis(2))		///
		xtitle(`"Lag"')			///
		title("Cross-correlogram")	///
		legend(nodraw)			/// no legend
		`options'			///
	)					///
	|| `plot' || `addplot'			///
	// blank

	if "`generate'" != "" {
		rename `ac' `generate'
		format `generate' %9.0g
	}
end

program define DiLine
	args m ac plot

	local s1
	if "`plot'" == "" {
		if `ac' >= 0 {
			local vb = 9
			local ve = int(8*`ac') + `vb'
		}
		else {
			local ve = 9
			local vb = int(8*`ac') + `ve'
		}
		local k 1
		while `k' <= 17 {
			local char " "
			if `vb' <= `k' & `k' <= `ve' {
				local char "{hline 1}"
			}
			if `k'==9 { 
				if `vb' == 9 & `ve' == 9 {
					local char "{c |}"
				}
       				if `vb' == 9 & `ve' > 9 {
					local char "{c LT}"
				}
				if `vb' < 9 & `ve' == 9 {
					local char "{c RT}"
				}
			}
			local s1 `"`s1'`char'"'
			local k = `k'+1
		}
	}

	di in smcl in gr %-6.0g `m' in ye /*
		*/ _col(9)  %7.4f `ac' /*
		*/ _col(19) `"`s1'"' 
end

exit
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
                 -1       0       1
 LAG       AC    [Cross-correlation]
######  S#.####   AAAAAAAAAAAAAAAAA
 %6.0g   %6.4f         %17s

