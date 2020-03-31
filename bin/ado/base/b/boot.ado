*! version 2.0.5  16feb2015
program define boot
	/*
		Bootstrap replications
	*/
	version 3.1
	parse "`*'", parse(" ,")
	local prog "`1'"
	mac shift 
	local options /*
	*/ "SIze(integer -9) CLEAR Iterate(integer 20) Verbose Cluster(str) Args(str) Opts(str)"
	parse "`*'"
	if (`size' == -9) { local size "_N" }
	else if (`size' <= 0) { 
		di in red "size() invalid"
		exit 198
	}
	quietly describe
	if _result(4)-20 < `iterate' {
		di in red "insufficient memory (observations)"
		exit 901 
	}
	local ns = _result(1)
	if "`cluster'"!="" {
		confirm variable `cluster'
	}
			
	if "`clear'"=="" {
		di in blu "warning:  data in memory will be lost." _n /*
		*/ "Press enter to continue, Ctrl-Break to abort."
		set more 0
		more 
	}
	* set more 1 

	di _n in gr "Bootstrap:" _n /* 
	*/ _col(10) "Program:" _col(30) in ye "`prog'" 
	di in gr  _col(10) "Arguments:" _col(30) in ye "`args'" 
	di in gr _col(10) "Options:" _col(30) in ye "`opts'" _n

	di /*
	*/ in gr _col(10) "Replications:" _col(30) in ye "`iterate'" _n /*
	*/ in gr _col(10) "Data set size:" _col(30) in ye "`ns'"

	tempfile BOOTMST BOOTRES BOOTIT1 BOOTCLS
	tempvar CCOUNT

	if "`cluster'"!="" { 
		sort `cluster'
		quietly save "`BOOTMST'", replace
		keep `cluster'
		quietly by `cluster': keep if _n==_N
		quietly save "`BOOTCLS'", replace
		quietly describe
		di in gr /*
		*/ _col(10) "Cluster variables:" _col(30) in ye "`cluster'" /*
		*/ _n /*
		*/ in gr _col(10) "No. of clusters:" _col(30) in ye _result(1)
		local sfx "clusters"
	}
	else {
		quietly save "`BOOTMST'", replace
	}
	di in gr _col(10) "Sample size:" _col(30) in ye "`size' `sfx'"

	if "`verbose'"=="" { local verbose "*" } 
	else { local verbose "noisily" }

	if "`opts'"!="" { local opts ", `opts'" }

	quietly {
		drop _all
		set obs 1 
		gen long _rep = 1 
		save "`BOOTRES'", replace

		local i "1"
		while (`i' <= `iterate') { 
			`verbose' di in blu _n "Iteration `i'`:"
			if "`cluster'"=="" { 
				use "`BOOTMST'", clear
				bootsamp `size'
			}
			else {
				use "`BOOTCLS'", clear
				bootsamp `size'
				sort `cluster'
				by `cluster':  gen `c(obs_t)' `CCOUNT' = _N
				by `cluster':  keep if _n==_N
				save "`BOOTIT1'", replace
				use "`BOOTMST'", clear
				merge `cluster' using "`BOOTIT1'"
				keep if _merge==3
				expand =`CCOUNT', replace
				drop _merge `CCOUNT'
			}
			local obs = _N
			`prog' `args' `opts'
			`verbose' list, noobs
			gen long _rep = `i'
			gen `c(obs_t)' _obs = `obs'
			save "`BOOTIT1'", replace
			use "`BOOTRES'", clear 
			append using "`BOOTIT1'"
			save "`BOOTRES'", replace 
			local i = `i' + 1 
		}
		if "`cluster'"=="" { label data "`prog' bootstrap" }
		else { label data "`prog' clustered bootstrap" }
		label var _rep "replication"
		label var _obs "observations"
		mac def S_FN
		quietly drop in 1
	}
	describe, nodate
end
