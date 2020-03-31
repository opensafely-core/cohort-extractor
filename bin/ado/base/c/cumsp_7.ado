*! version  1.1.8  17sep2004
program define cumsp_7
	version 6.0, missing
	syntax varname(ts) [if] [in] [, GENerate(string) /*
                */ B1title(string) B2title(string) YLIne(string) /*
                */ XLAbel(string) YLAbel(string) RLAbel(string) /*
                */ Symbol(string) Connect(string) Pen(string) /*
                */ L1title(string) T1title(string) *]

	local gen `"`generat'"'
	local generat

	marksample touse
	_ts t1 panelvar `if' `in', sort onepanel
	markout `touse' `t1'
	local targ ", t(`t1')"

	if "`gen'" != "" {
		capture gen byte `gen' = 0
		if _rc {
			di in red "generate() should name one new variable"
			exit 198
		}
		capture drop `gen'
	}

	quietly {
		tempvar  pg spg omega ourn
		tempname R0

		count if `touse'
		local n = r(N)
		pergram `varlist' if `touse', gen(`pg') nograph
		gen double `spg' = sum(`pg')
		cap local vlab : var label `varlist'
		if "`vlab'" == "" { local vlab "`varlist'" }
		label var `spg' "`vlab'"

		gen long `ourn' = sum(1) if `touse'
		compress `ourn'
		gen double `omega' = (`ourn'-1)/`n'

		sum `pg' if `omega' <= .5
		local rden = r(sum)
		
		replace `spg' = `spg'/`rden'
		
                format `omega' `spg' %-5.2f

                if "`xlabel'" == "" {
                        local xlab "xlabel(0,.1,.2,.3,.4,.5)"
                }
                else {
                        local xlab "xlabel(`xlabel')"
                }
                if "`ylabel'" == "" {
                        local ylab "ylabel(0,.2,.4,.6,.8,1.0)"
                }
                else {
                        local ylab "ylabel(`ylabel')"
                }
                if "`rlabel'" == "" {
                        local rlab "rlabel(0,.2,.4,.6,.8,1.0)"
                }
                else {
                        local rlab "rlabel(`rlabel')"
                }
                if "`t1title'`t2title'" == "" {
                        local t1title "Sample spectral distribution function"
                        local t2title "evaluated at the natural frequencies"
                }
                if "`l2title'" == "" {
                        local l2title "Cumulative spectral distribution"
                }
                if "`symbol'" == "" {
                        local sym "s(o)"
                }
                else {
                        local sym "s(`symbol')"
                }
                if "`connect'" == "" {
                        local con "c(l)"
                }
                else {
                        local con "c(`connect')"
                }
                if "`yline'" == "" {
                        local yline "yline(0)"
                }
                else {
                        local yline "yline(`yline')"
                }
                label var `omega' "Frequency"
	}

	gr7 `spg' `omega' if `omega' <= .5, /*
                */ t1title("`t1title'") /*
                */ t2title("`t2title'") /*
                */ l2title("`l2title'") /*
                */ `ylab' `xlab' `rlab' `sym' `con' `pen' `yline' /*
                */ `options'

	if "`gen'" != "" {
		qui replace `spg' = . if `omega' > .5
		rename `spg' `gen'
		format `gen' %10.0g
	}
end
