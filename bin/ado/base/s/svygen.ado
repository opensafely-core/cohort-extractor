*! version 1.3.0  31mar2015
program svygen, sortpreserve
	version 9

	// get the subroutine
	gettoken cmd 0 : 0, parse(" ,")
	local lcmd : length local cmd

	// generate weights adjust for poststratification
	if "`cmd'" == bsubstr("poststratify",1,max(4,`lcmd')) {
		Post `0'
		exit
	}

	// generate jackknife weights
	if "`cmd'" == bsubstr("jknife",1,max(2,`lcmd')) ///
	 | "`cmd'" == bsubstr("jackknife",1,max(4,`lcmd')) {
		JKnife `0'
		exit
	}

	// generate brr weights
	if "`cmd'" == bsubstr("brr",1,max(2,`lcmd')) {
		BRR `0'
		exit
	}

	// generate SDR weights
	if "`cmd'" == "sdr" {
		SDR `0'
		exit
	}

	// ERROR: invalid subroutine
	if "`cmd'" != "" {
		local cmd ": `cmd'"
	}
	di as err `"unrecognized svygen subcommand`cmd'"'
	exit 199
end

program Post, rclass sortpreserve
	syntax newvarname [pw iw] [if] [in] ,	///
		POSTStrata(varname)		///
		POSTWeight(varname numeric)	///
		[ nocheck ]

	tempvar wgt
	marksample touse, novarlist zeroweight

	local postid `poststrata'
	local postwt `postweight'
	markout `touse' `postid', strok
	markout `touse' `postwt'

	local by `touse' `postid'
	sort `by', stable

	if "`check'" == "" {
		_svy_check_postw `touse' `postid' `postwt'
		quietly tab `poststrata' if `touse'
		return scalar N_poststrata = r(r)
	}

	local all1 0
	if "`weight'" != "" {
		quietly gen double `wgt' `exp' if `touse'
		capture assert `wgt' == 1 if `touse'
		if ! c(rc) {
			local ++all1
		}
	}
	else {
		quietly gen double `wgt' = `touse'
		local ++all1
	}
	if `all1' {
		quietly by `by' : replace `wgt' = (_n==1)*`postwt'
		sum `wgt', mean
		quietly replace `wgt' = r(sum)/r(N)
	}

	tempvar sum
	quietly by `by' : gen double `sum' = sum(`wgt') if `touse'
	quietly by `by' : replace `wgt' = `wgt'*`postwt'/`sum'[_N] if `touse'
	rename `wgt' `varlist'
end

program JKnife, rclass
	syntax newvarlist(min=1 max=2)		///
		[pw iw] [if] [in] [,		///
		STRata(varname)			///
		psu(varname)			///
		fpc(varname numeric)		///
		POSTStrata(passthru)		///
		POSTWeight(passthru)		///
		TWOperstratum			///
		nocheck				///
	]

	if `"`poststrata'"' != "" {
		local postopt `"`poststrata' `postweight'"'
		tempvar postw
	}

	if `:word count `varlist'' == 1 {
		tempname multiplier
		local tmultiplier double
		local stub `varlist'
		local tstub `typlist'
	}
	else {
		tokenize `varlist'
		args stub multiplier
		tokenize `typlist'
		args tstub tmultiplier
	}
	marksample touse, novarlist zeroweight
	markout `touse' `strata' `psu', strok
	markout `touse' `fpc'
	tempvar wvar npsu npsuobs nstrobs

	quietly count if `touse'
	if r(N) == 0 {
		error 2000
	}

quietly {

	if "`exp'" != "" {
		gen double `wvar' `exp' if `touse'
		markout `touse' `wvar'
	}
	else	gen byte `wvar' = `touse'

	sort `touse' `strata' `psu', stable
	by `touse' `strata' : gen `tmultiplier' `multiplier' = _n==1
	count if `multiplier'
	local nstrata = r(N)

	if "`twoperstratum'" != "" {
		if "`strata'" == "" {
			di as err ///
			"option strata() required with twoperstratum option"
			exit 198
		}
		if "`fpc'" != "" {
			di as err ///
			"option fpc() not allowed with twoperstratum option"
			exit 198
		}
	}

	if "`psu'" == "" {
		by `touse' `strata' : gen `c(obs_t)' `npsu' = _N
		by `touse' `strata' : replace `multiplier' = (_N-1)/_N
		count if `touse'
		local nreps = r(N)
		gen byte `npsuobs' = 1
	}
	else {
		// count number of PSU's to compute multiplier
		by `touse' `strata' `psu' : gen `npsuobs' = _n == 1
		count if `npsuobs' & `touse'
		local nreps = r(N)
		by `touse' `strata' : ///
			replace `npsuobs' = sum(`npsuobs') if `touse'
		by `touse' `strata' : ///
			replace `multiplier' = (`npsuobs'[_N]-1)/`npsuobs'[_N]
		// count number of observations in each PSU
		by `touse' `strata' `psu' : replace `npsuobs' = _N
	}

	// count number of observations in each stratum
	by `touse' `strata' : gen `c(obs_t)' `nstrobs' = _N

	local p1 1
	local p2 = `npsuobs'[1]
	local n1 1
	local n2 = `nstrobs'[1]
	noisily di
	noisily _dots 0, title(Jackknife replicate weights) reps(`nreps')
	forval i = 1/`nreps' {
		if "`twoperstratum'" != "" {
			if mod(`i',2) == 1 {
				local p1 = `p2' + 1
				local p2 = `p2' + `npsuobs'[`p1']
				noisily _dots `i' -1
				continue
			}
			else	local j = `i'/2
		}
		else	local j `i'
		// start with the original weights
		gen `tstub' `stub'`j' = `wvar'
		// adjust all the weights in the current stratum
		replace `stub'`j' = `wvar'/`multiplier' in `n1'/`n2'
		// zero out the weights for the deleted PSU
		replace `stub'`j' = 0 in `p1'/`p2'
		// add characteristics for the variance adjustment
		if "`twoperstratum'" == "" {
			char `stub'`j'[jk_multiplier] `=`multiplier'[`n1']'
			if "`strata'" != "" {
				char `stub'`j'[jk_stratum] `=`strata'[`n1']'
			}
		}
		if "`fpc'" != "" {
			char `stub'`j'[jk_fpc] `=`fpc'[`n1']'
		}
		// find the observation range for the next PSU
		local p1 = `p2' + 1
		local p2 = `p2' + `npsuobs'[`p1']
		if `p1' > `n2' {
			// find the observation range for the next stratum
			local n1 = `n2' + 1
			local n2 = `n2' + `nstrobs'[`n1']
		}
		if "`postw'" != "" {
			Post `postw' [iw=`stub'`j'], `postopt' `nocheck'
			quietly replace `stub'`j' = `postw'
			drop `postw'
			local nocheck nocheck
		}
		noisily _dots `i' 0
	}
	noisily _dots `nreps'

} // quietly

	// saved results
	return scalar N_reps = `nreps'
	return scalar N_psu = `nreps'
	return scalar N_strata = `nstrata'
end

program BRR, rclass
	syntax newvarname [pw iw] [if] [in] ,		///
		Hadamard(name)				///
		STRata(varname)				///
		[					///
			psu(varname)			///
			FAY(numlist >=0 <= 2 max=1)	///
			POSTStrata(passthru)		///
			POSTWeight(passthru)		///
			nocheck				///
		]

	if `"`poststrata'"' != "" {
		local postopt `"`poststrata' `postweight'"'
		tempvar postw
	}

	if "`fay'" == "" {
		local fay 0
	}
	if `fay' == 1 {
		di as err "option fay(1) is not allowed"
		exit 198
	}

	// check -hadamard()- option
	_hadamard_verify `hadamard', optname(hadamard)
	local ncols = r(order)

	local stub `varlist'
	local tstub `typlist'

	tempvar wvar strid psuid

	marksample touse, novarlist zeroweight
	markout `touse' `strata' `psu', strok

	quietly count if `touse'
	if r(N) == 0 {
		error 2000
	}

	if "`exp'" != "" {
		quietly gen double `wvar' `exp' if `touse'
		markout `touse' `wvar'
	}
	else	quietly gen byte `wvar' = `touse'

	sort `touse' `strata' `psu', stable
	by `touse' `strata' : gen `strid' = _n==1 if `touse'
	quietly count if `strid' == 1
	local nstrata = r(N)
	quietly replace `strid' = sum(`strid') if `touse'
	if `nstrata' > `ncols' {
		di as err ///
		"too few columns in matrix specified in hadamard() option"
		exit 198
	}

	if "`psu'" == "" {
		quietly by `touse' `strata': gen `psuid' = _n
	}
	else {
		quietly by `touse' `strata' `psu':	///
			gen `psuid' = _n==1 if `touse'
		quietly by `touse' `strata':	///
			replace `psuid' = sum(`psuid') if `touse'
	}
	capture by `touse' `strata': assert `psuid'[_N] == 2 if `touse'
	if c(rc) {
		di as err "brr requires that all strata have 2 PSUs"
		exit 459
	}

	if `fay' == 0 {
		local inwgt "2*`wvar'"
		local outwgt "0"
	}
	else if `fay' == 2 {
		local inwgt "0"
		local outwgt "2*`wvar'"
	}
	else {
		local inwgt "(2-`fay')*`wvar'"
		local outwgt "`fay'*`wvar'"
	}

	tempname h
	matrix `h' = (J(`ncols',`ncols',3)-`hadamard')/2
	di
	_dots 0, title(BRR replicate weights) reps(`ncols')
	forval i = 1/`ncols' {
		quietly gen `tstub' `stub'`i' = ///
		cond(`h'[`i',`strid']==`psuid',`inwgt',`outwgt') if `touse'
		if "`postw'" != "" {
			Post `postw' [iw=`stub'`j'], `postopt' `nocheck'
			quietly replace `stub'`j' = `postw'
			drop `postw'
			local nocheck nocheck
		}
		_dots `i' 0
	}
	_dots `ncols'

	// saved results
	return scalar N_reps = `ncols'
	return scalar N_psu = 2*`nstrata'
	return scalar N_strata = `nstrata'
end

program SDR
	syntax newvarname [pw iw] [if] [in],		///
		Hadamard(name)				///
		[					///
			PSU(varname)			///
			STRata(varname)			///
			POSTStrata(passthru)		///
			POSTWeight(passthru)		///
			nocheck				///
		]

	if `"`poststrata'"' != "" {
		local postopt `"`poststrata' `postweight'"'
		tempvar postw
	}

	// check -hadamard()- option
	_hadamard_verify `hadamard', optname(hadamard)
	local ncols = r(order)

	tempname wvar su1 f
	marksample touse, novarlist zeroweight
	markout `touse' `strata' `psu', strok

	quietly count if `touse'
	if r(N) == 0 {
		error 2000
	}

	if "`exp'" != "" {
		gen double `wvar' `exp' if `touse'
		markout `touse' `wvar'
	}
	else	gen byte `wvar' = `touse'

	sort `touse' `strata' `psu', stable
	if "`psu'" == "" {
		gen `su1' = _n
	}
	else {
		by `touse' `strata' `psu': gen `su1' = _n==1
		quietly replace `su1' = sum(`su1')
	}
	sum `su1' if `touse', meanonly
	local N = r(max)

	mata: st_sdrmat("`f'", "`hadamard'", `N')

	local stub `varlist'
	local tstub `typlist'

	di
	_dots 0, title(SDR replicate weights) reps(`ncols')
	forval i = 1/`ncols' {
		quietly gen `tstub' `stub'`i' = `wvar'*`f'[`su1',`i'] if `touse'
		if "`postw'" != "" {
			Post `postw' [iw=`stub'`i'], `postopt' `nocheck'
			quietly replace `stub'`j' = `postw'
			quietly drop `postw'
			local nocheck nocheck
		}
		_dots `i' 0
	}
end

mata:

void st_sdrmat(string scalar matname, string scalar hname, real scalar n)
{
	real scalar k
	real scalar i
	real matrix f
	real vector s
	real scalar c

	f = st_matrix(hname)
	k = rows(f)
	if (k < n+2) {
		errprintf("Hadamard matrix too small for sample size\n")
		exit(459)
	}
	s = rowsum(f :== 1) :== k
	if (any(s)) {
		if (s[1] == 0) {
			// move the rows of 1's to be the first
			for (i=1; i<=k; i++) {
				if (s[i]) {
					s = f[i,.]
					f[i,.] = f[1,.]
					f[1,.] = s
					break
				}
			}
		}
	}
	c = 1/sqrt(8)
	for (i=1; i<=n; i++) {
		f[i,.] = 1 :+ (f[i+1,.]:-f[i+2,.])*c
	}
	st_matrix(matname, f[|_2x2(1,1,n,k)|])
}

end

exit
