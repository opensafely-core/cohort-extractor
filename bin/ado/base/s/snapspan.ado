*! version 1.0.7  09feb2015
program define snapspan
	version 6
	syntax varlist(min=3) [, Generate(string) REPLACE CLEAR]
	tokenize `varlist'
	local id `1'
	local t `2'
	mac shift 2
	local event `*'

	if "`clear'"!="" { 
		local replace REPLACE
	}

	if `"`generat'"' != "" {
		local n : word count `generat'
		if `n'!=1 { 
			di in red "generate():  " _c
			error 198 
		}
		confirm new var `generat'
		local tfmt : format `t'
	}
				/* parsing complete 	*/

	qui count if missing(`id')
	if r(N) { 
		local n = r(N)
		if `n'>1 {
			local s s
			local them them
			local have have
		}
		else {
			local them it
			local have has
		}

		capture confirm string var `id'
		local miss = cond(_rc, "`id'==.", `"`id'=="""')
		di in red `"`n' observation`s' `have' `miss'"'
		di in red "either fill `them' in with appropriate values or" 
		di in red `"drop `them' by typing "' in white `"drop if `miss'"'
		exit 459
	}

	qui count if `t'==.
	if r(N) { 
		local n = r(N)
		if `n'>1 {
			local s s
			local them them
			local have have
		}
		else {
			local them it
			local have has
		}
		di in red "`n' observation`s' `have' `t'==."
		di in red "either fix `them' or drop `them'"
		di in red "by typing " in white `"drop if `t'==."'
		exit 459
	}

	sort `id' `t'
	tempvar cnt
	qui by `id': gen `c(obs_t)' `cnt' = `t'==`t'[_n-1] | `t'==`t'[_n+1]
	qui count if `cnt'
	if r(N) { 
		local ndup = r(N)
		qui by `id': replace `cnt' = cond(_n==_N,sum(`cnt'),0)
		qui count if `cnt'
		local nsubj = r(N)
		if `nsubj'>1 { 
			local s s
			local have have
		}
		else	local have has
		di in red /*
		*/ "`nsubj' subject`s' `have' `ndup' duplicate `t' values"
		di in red /*
		*/ "it is unclear which record to use at the specified time"
		di in red "perhaps"
		di in red /*
		*/ "    1.  `id' is wrong and the records are not really for"
		di in red "        the same subject, or 
		di in red /*
		*/ "    2.  `t' is wrong and one record occurs after the other"
		exit 459
	}
	
	if "`replace'"=="" {
		qui desc, short
		if r(changed) { error 4 }
	}

	tempvar obsper
	qui by `id': gen `c(obs_t)' `obsper' = _N if _n==1
	qui count if `obsper'==1
	if r(N) { 
		local obsper1 = r(N)
		if r(N)>1 { 
			local have "have"
			local they "they"
		}
		else {
			local have "has"
			local they "it"
		}
		qui count if `obsper' != .
		local percent : di %9.1f 100*`obsper1'/r(N)
		local percent = trim("`percent'")
		di in gr "note:  " `obsper1' " obs. (`percent'%) "/*
		*/ "`have' only a single record; `they' will be ignored"
		if `obsper1'==r(N) { 
			di in red "no observations"
			exit 2000
		}
	}
	drop `obsper'

	preserve 
	quietly {
		by `id':  keep if _n==1
		keep `id' `t' `event'
		tempfile first
		save `"`first'"', replace

		restore, preserve

		tempvar t0
		local type : type `t'
		gen `type' `t0' = `t'

		by `id': replace `t' = `t'[_n+1]

		tokenize `event'
		while "`1'" != "" {
			by `id': replace `1' = `1'[_n+1]
			mac shift
		}
		
		by `id': drop if _n==_N
		append using `"`first'"'
		sort `id' `t'
	}
	if "`generat'" != "" {
		format `t0' `tfmt'
		rename `t0' `generat'
	}
	global S_FN 
	global S_FNDATE
	restore, not
end
exit


snapspan id t evars...


/* 

id   t   x    e      becomes   t0   t    x   e
 1  t1   x1   e1                .   t1   .   e1
 1  t2   x2   e2               t1   t2  x1   e2
 1  t3   x3   e3               t2   t3  x2   e3
 1  t4   x4   e4               t3   t4  x3   e4
*/

forward forever
forward forever and backwards
forward amt of time 

spanfill id t varlist, forwards(.) backwards


fillbf(varlist)
fillff(varlist)
fillf(# varlist # varlist # varlist ...)



fill(forward . 






