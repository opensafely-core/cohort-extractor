*! version 1.2.0  08apr2019
program define quadchk
	local vv : di "version " string(_caller()) ", missing: "
	local vvn= _caller()
	version 6
	if "`e(mecmd)'"=="1" | "`e(xtcmd)'"=="1" {
		local cmd "`e(cmd2)'"
	}
	else {
		local cmd "`e(cmd)'"
	}
	local stcmd = inlist("`cmd'","mestreg","xtstreg")
	
	local q1  "`e(n_quad)'"
	if !`stcmd' {
		local dep "`e(depvar)'"
	}
	if "`e(quadchk)'" == "0" {
		version 16: di as error ///
			"{bf:quadchk} not supported after {bf:`cmd'}"
		exit 498
	}
	
	local intmeth "`e(intmethod)'"

	if "`cmd'"=="" | "`e(b)'"=="" {
		di in red "last estimates not found"
		exit 301
	}
	if "`q1'"=="" {
		di in red "last estimates not calculated with quadrature"
		exit 301
	}

	local i 2
	while `i' <= 3 {
		gettoken q`i' 0 : 0, parse(", ")
		if "`q`i''"=="," | "`q`i''"=="" {
			local 0 ", `0'"
			local q`i' /* erase macro */
			local i 4  /* exit */
		}
		else {
			confirm integer number `q`i''
			local i = `i' + 1
		}
	}

	Qcheck `q2'
	Qcheck `q3'

	syntax [, noOUTput noFROM]

	if "`output'"!="" {
		local quietly "quietly"
	}

	if "`q2'"=="" {
		if `vvn' < 10.0 { /* version control */
			if `q1' >= 12 {
				local q2 = `q1' - 4
			}
			else {
				local q2 = `q1' + 4
				local q3 = `q1' + 8
			}
		}
		else {
			if `q1' >= 12 {
				local d1 = int(`q1'/3)
				local q2 = `q1' - `d1'
			}
			else {
				local q2 = `q1' + 4
				local q3 = `q1' + 8
			}
		}
	}

	if "`q3'"=="" {
		if `vvn' < 10.0 { /* version control */
			local q3 = `q1' + 4*sign(`q1'-`q2')
		}
		else {
			local q3 = `q1' + sign(`q1'-`q2')*(`q1'-`q2')
		}
		if `q3' > 195 { local q3 195 }
		if `q3' < 8  { local q3  8 }
	}

	local opts "iter(200) collinear"
	
	if `stcmd' {
		local opts "`opts' distribution(`e(distribution)')"
	}
	if "`e(cmd)'" == "xtpoisson" {
		local opts "`opts' normal"
	}
	if "`e(cmd)'" == "xttobit" {
		if `"`e(llopt)'"' != "" {
			local opts "`opts' ll(`e(llopt)')"
		}
		if `"`e(ulopt)'"' != "" {
			local opts "`opts' ul(`e(ulopt)')"
		}
	}
	if "`e(offset)'`e(offset1)'" != "" {
		if bsubstr("`e(offset)'",1,3) == "ln(" {
			local var = ///
			bsubstr("`e(offset)'",4,length("`e(offset)'")-4)
			local opts "`opts' exposure(`var')"
		}
		else if bsubstr("`e(offset1)'",1,3) == "ln(" {
			local var = ///
			bsubstr("`e(offset1)'",4,length("`e(offset1)'")-4)
			local opts "`opts' exposure(`var')"
		}
		else if `"`e(offset)'"' != "" {
			local opts "`opts' off(`e(offset)')"
		}
		else {
			local opts "`opts' off(`e(offset1)')"
		}
	}
	if "`e(wtype)'"!= "" {
		local wei [`e(wtype)'`e(wexp)']
	}
	if `"`e(Cns)'"' == "matrix" {
		tempname cns
		mat `cns' = e(Cns)
		local opts "`opts' constraint(`cns')"
	}
	else if `"`e(constraint)'"' != "" {
		tempname cns
		mat `cns' = e(constraint)
		local opts "`opts' constraint(`cns')"
	}
	local opts "`opts' i(`e(ivar)')"
	

	tempname b1 b2 b3 bb ll1 ll2 ll3 ff
	tempvar use

	mat `b1' = e(b)
	scalar `ll1' = e(ll)

	mat `bb' = `b1'[1,1..1]
	local coleq : coleq(`bb')
	mat `bb' = `b1'[1,"`coleq':"]
	local names : colnames(`bb')
	local nn : word count `names'
	local ln : word `nn' of `names'

	if "`ln'" != "_cons" { /* nocons */
		if "`e(family)'" != "ordinal" { local opts "`opts' nocons" }
		local varlist "`names'"
	}
	else { /* erase _cons from `names' */
		tokenize `names'
		local `nn' /* erase macro */
		local varlist "`*'"
	}

	quietly gen byte `use' = e(sample)

	nobreak {
		estimates hold `ff'
		local quad intpoints
		if `vvn' >=9.0 {
			local opts "`opts' intmethod(`intmeth')"
		}
		capture noisily break {
			di in gr _n "Refitting model intpoints() = " in ye %2.0f `q2'
			if "`from'" =="" {
				`vv' `quietly' `cmd' `dep' `varlist' `wei'/*
				*/ if `use', `opts' `quad'(`q2')  from(`b1')
			} 
			else{
				`vv' `quietly' `cmd' `dep' `varlist' `wei'/*
				*/ if `use', `opts' `quad'(`q2') 
			}

			mat `b2' = e(b)
			scalar `ll2' = e(ll)

			`quietly' di /* blank line */
			di in gr "Refitting model intpoints() = " in ye %2.0f `q3'
			if "`from'" =="" {
				`vv' `quietly' `cmd' `dep' `varlist' `wei'/*
				*/ if `use', `opts' `quad'(`q3') from(`b1') 
			}
			else{
				`vv' `quietly' `cmd' `dep' `varlist' `wei'/*
				*/ if `use', `opts' `quad'(`q3') 
			}

			mat `b3' = e(b)
			scalar `ll3' = e(ll)
		}
		local rc = _rc

		estimates unhold `ff'

		if `rc' == 0 {
			DisCoef `b1' `b2' `b3' `q1' `q2' `q3' `ll1' `ll2' `ll3'
		}
		else {
			if `rc' != 1 { di in red "error refitting model" }
			exit `rc'
		}
	}
end

program define Qcheck
	args q
	if "`q'"=="" { exit }
	if `q' < 4 | `q' > 195 {
		di in red "number of quadrature points must be between 4 and 195"
		exit 198
	}
	if `q' > e(N) {
		di in red "number of quadrature points must be less than " /*
		*/ "or equal to number of obs"
		exit 198
	}
end

program define DisCoef
	args b1 b2 b3 q1 q2 q3 ll1 ll2 ll3

	tempname omit
	_ms_omit_info `b1'
	matrix `omit' = r(omit)
	local col1 14
	local col2  = `col1' + 15
	local col3  = `col2' + 15
	local end   = `col3' +  9
	local com   = `end'  +  4
	local col1p2 = `col1' +  2
	local col2m3 = `col2' -  3

	di in gr _n _col(`col2m3') "Quadrature check"
	di in gr _n _col(`col1p2') "Fitted" /*
	*/          _col(`col2')  "Comparison" /*
	*/          _col(`col3')  "Comparison"
	di in gr _col(`col1') "quadrature" /*
	*/       _col(`col2') "quadrature" /*
	*/       _col(`col3') "quadrature"
	di in gr _col(`col1') "`q1' points" /*
	*/       _col(`col2') "`q2' points" /*
	*/       _col(`col3') "`q3' points"
	di in smcl in gr "{hline `end'}"

	di in gr "Log" /*
	*/ in ye _col(`col1') in ye %10.0g `ll1' /*
	*/ _col(`col2') in ye %10.0g `ll2' /*
	*/ _col(`col3') in ye %10.0g `ll3'

	di in gr "likelihood" /*
	*/ in ye _col(`col2') %10.0g `ll2'-`ll1' /*
	*/ _col(`col3') in ye %10.0g `ll3'-`ll1' /*
	*/ in gr _col(`com') "Difference"

	di in ye _col(`col2') %10.0g (`ll2'-`ll1')/`ll1' /*
	*/ _col(`col3') in ye %10.0g (`ll3'-`ll1')/`ll1' /*
	*/ in gr _col(`com') "Relative difference"

	di in smcl in gr "{hline `end'}"

	local names : colnames(`b1')
	local ename : coleq(`b1')
	local n = colsof(`b1')
	local i 1
	while `i' <= `n' {
	    if `omit'[1,`i'] == 0 {
		local name : word `i' of `names'
		local eq   : word `i' of `ename'
		local len = length("`name'")
		local s = 9 - `len'

		di in gr _col(1) "`eq':" /*
		*/ _col(`col1') in ye %10.0g `b1'[1,`i'] /*
		*/ _col(`col2') in ye %10.0g `b2'[1,`i'] /*
		*/ _col(`col3') in ye %10.0g `b3'[1,`i']

		di in gr _col(`s') abbrev("`name'",12) /*
		*/ in ye _col(`col2') %10.0g `b2'[1,`i']-`b1'[1,`i'] /*
		*/ _col(`col3') in ye %10.0g `b3'[1,`i']-`b1'[1,`i'] /*
		*/ in gr _col(`com') "Difference"

		di in ye _col(`col2') %10.0g /*
		*/ (`b2'[1,`i']-`b1'[1,`i'])/`b1'[1,`i'] /*
		*/ _col(`col3') in ye %10.0g /*
		*/ (`b3'[1,`i']-`b1'[1,`i'])/`b1'[1,`i'] /*
		*/ in gr _col(`com') "Relative difference"

		di in smcl in gr "{hline `end'}"
	    }

		local i = `i'+1
	}
end

