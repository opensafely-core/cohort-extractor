*! version 3.1.2  10dec2002
program define ml_graph
	version 6
	gettoken comma : 0, parse(" ,")
	if "`comma'"=="" | "`comma'"=="," {
		local num 20
	}
	else {
		gettoken num 0 : 0, parse(", ")
		capture confirm integer number `num'
		if _rc {
			di in red "# must be between 2 and 20"
			exit 198
		}
	}
	syntax [, NAME(string asis) SAVing(string asis)]
	if `"`saving'"' != "" {
		local saving `"saving(`saving')"'
	}
	if `"`name'"' != "" {
		local name `"name(`name')"'
	}

	GetAcc
	local mat `s(mat)'
	local ic `s(ic)'
	if `s(ic)'<=20 {
		local fp 1
		local lp `s(ic)'
		local n  `lp'
	}
	else {
		local lp = mod(`s(ic)'-1,20)+1
		local fp = cond(`lp'+1>20,1,`lp'+1)
		local n 20
	}
	preserve
	drop _all
	quietly set obs `n'
	quietly gen n = _n
	quietly gen lnf = .
	local i 1
	while `i' <= `n' {
		qui replace lnf = el(`mat',1,`fp') in `i'
		local i = `i' + 1
		local fp = `fp' + 1
		if `fp'>20 { local fp 1 }
	}
	if _N > `num' {
		local f = _N - `num' + 1
		local in "in `f'/l"
	}
	qui replace n =  n - n[_N]+`ic'-1
	qui summ n `in'
	local min `r(min)'
	local max `r(max)'
	if `min'==`max' {
		local max = `max' + 1
	}
	local np = `max' - `min' + 1
	if `np' <= 10 {
		local xlab "xlab(`min'/`max')"
	}
	else {
		local xlab "xlab(`min'(2)`max')"
	}

	version 8: graph twoway			///
	(connected ln n				///
		`in',				///
		ytitle("ln L()")		///
		xtitle("Iteration number")	///
		`xlab'				///
		`saving'			///
		`name'				///
	)					///
	// blank
end


program define GetAcc, sclass
	if "$ML_stat"=="model" {
		if "$ML_ic"!="" {
			capture di ML_log[1,1]
			if _rc==0 {
				sret local mat "ML_log"
				sret local ic  $ML_ic
				exit
			}
		}
		di in red "no current estimates"
		exit 301
	}
	if "`e(opt)'"=="ml" {
		sret local mat "e(ilog)"
		sret local ic = e(ic)+1
		exit
	}
	error 301
end
