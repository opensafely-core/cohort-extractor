*! version 1.1.1  30sep2004 
program define xcorr_7
	version 6.0, missing
/* This block of code is currently not doing anything -- jml
	if _caller()<6 {
		capture which bl_xcorr
		if _rc { 
			di in red "You have set version " _caller()
			di in red "xcorr was not a command of Stata " _caller()
			exit 199
		}
		bl_xcorr `0'
		exit
	}
*/

	syntax varlist(ts) [if] [in]   /*
                */ [, LAGs(int -1) GENerate(string) /*
                */ B1title(string) B2title(string) YLIne(string) /*
                */ XLAbel(string) YLAbel(string) RLAbel(string) /*
                */ Symbol(string) Connect(string) Pen(string) /*
                */ L1title(string) NEEDLE TABle noPLOT *]

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
			if "`plot'" == "" {
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
				noi DiLine `i' `ac'[`obsp'] `plot'
				local i = `i' + 1
				local obsp = `obsp' + 1
			}
			if "`generate'" != "" {
				rename `ac' `generate'
				format `generate' %9.0g
			}
			exit
		}
                if "`xlabel'" == "" {
                        local xlab "xlab"
                }
                else {
                        local xlab "xlabel(`xlabel')"
                }
                if "`ylabel'" == "" {
                        local ylab "ylabel(-1,-.75,-.50,-.25,0,.25,.50,.75,1)"
                }
                else {
                        local ylab "ylabel(`ylabel')"
                }
                if "`rlabel'" == "" {
                        local rlab "rlabel(-1,-.75,-.50,-.25,0,.25,.50,.75,1)"
                }
                else {
                        local rlab "rlabel(`rlabel')"
                }
                if "`b1title'" == "" {
                        local b1title "Cross-correlogram"
                }
                if "`b2title'" == "" {
                        local b2title "Lag"
                }
                if "`l1title'" == "" {
                        local l1title "Cross-correlations of `x' and `y'"
                }
                if "`symbol'" == "" {
                        if "`needle'" != "" {
                                local sym "s(oii)"
                        }
                        else {
                                local sym "s(o)"
                        }
                }
                else {
                        local sym "s(`symbol')"
                }
                if "`connect'" == "" {
                        if "`needle'" != "" {
                                local con "c(.||)"
                        }
                        else {
                                local con "c(l)"
                        }
                }
                else {
                        local con "c(`connect')"
                }
                if "`pen'" == "" {
                        if "`needle'" != "" {
                                local pen "pen(222)"
                        }
                        else {
                                local pen "pen(2)"
                        }
                }
                else {
                        local pen "pen(`pen')"
                }
                if "`yline'" == "" {
                        local yline "yline(0)"
                }
                else {
                        local yline "yline(`yline')"
                }
        }

        if "`needle'" != "" {
                tempvar zero
                gen byte `zero' = 0
                local args "`ac' `ac' `zero'"
        }
        else {
                local args "`ac'"
        }
        gr7 `args' `obs', /*
                */ b1title("`b1title'")  /*
                */ b2title("`b2title'") /*
                */ l1title("`l1title'") /*
                */ `ylab' `xlab' `rlab' `sym' `con' `pen' `yline' /*
                */ `options'
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
			if `vb' <= `k' & `k' <= `ve' { local char "{hline 1}" }
			if `k'==9 { 
	                        if `vb' == 9 & `ve' == 9 { local char "{c |}" }
       		                if `vb' == 9 & `ve' > 9 { local char "{c LT}" }
                        	if `vb' < 9 & `ve' == 9 { local char "{c RT}" }
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

