*! version 3.0.3  09feb2015
program define wilcoxon
	ChkVer
	version 3.1
	local varlist "req ex min(1) max(2)"
	local if "opt"
	local in "opt"
	local options "BY(string)"
	parse "`*'"
	parse "`varlist'", parse(" ")
	if "`by'"=="" { error 198 } 
	conf var `by'
	tempvar cens r2a r1a r1 r2
	preserve
	quietly {
		drop if `1'==. | `by'==.
		gen long `cens'=0
		if "`2'"!="" {
			drop if `2'==.
			replace `2'=1 if `2'!=0
			replace `cens'=1-`2'
		}
		if "`if'`in'"~="" {
			keep `if' `in'
		}
		keep `1' `cens' `by'
		sort `1' `cens'
		gen `c(obs_t)' `r2a' = _n - sum(`cens')
		gen `c(obs_t)' `r1a' = `r2a'[_n-1]
		replace `r1a' = 0 if _n==1
		by `1' `cens': gen `r1' = (`r1a'[1]+`r1a'[_N])/2
		replace `r2a' = (1-`cens')*(_N-_n)
		by `1' `cens': gen `r2' = (`r2a'[1]+`r2a'[_N])/2
		count if `by'==`by'[1]
		local nn = _result(1)
		replace `r1' = `r1' - `r2'
		replace `r2' = `r1'^2
		replace `r1' = 0 if `by'!=`by'[1]
		replace `r1' = sum(`r1')
		local V = `r1'[_N]
		replace `r2' = sum(`r2')
		local h2 = `r2'[_N]
		local vs = `V'/sqrt(`nn'*(_N-`nn')*`h2'/_N/(_N-1))
		global S_7=`by'[1]
		global S_8 `V'
		global S_9 `vs'
		noisily di _n in gr "Test:  `by'==" in ye `by'[1] in gr /*
			*/ " has longer survival time" _n /*
			*/ _col(8) "Wilcoxon-Gehan statistic = " /*
			*/ in ye %9.0g `V' _n in gr /*
			*/ _col(31) "z = " in ye %9.2f `vs' _n in gr /*
			*/ _col(26) "Pr>|z| = " in ye /*
			*/ %9.4f 2*normprob(-abs(`vs'))
	}
end

program define ChkVer
	quietly version 
	if _result(1)<5 { exit }
	version 5.0
	#delimit ;
	di in ye "wilcoxon" in gr 
	" is an out-of-date command.  Its replacement is " in ye "sts test"
	in gr "." _n(2) in ye "wilcoxon" 
	in gr " will, however, work:" _n ;
	di _col(8) in gr ". " in ye "version 4.0" _n 
	_col(8) in gr ". " in ye "wilcoxon" in gr " ..." _n
	_col(8) ". " in ye "version 5.0" _n ;
	di in gr "Better is to see help " in ye "sts"  in gr "." ;
	#delimit cr
	exit 199
end
exit
