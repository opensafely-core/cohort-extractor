*! version 1.2.0  20feb2019
program screeplot, rclass sortpreserve
	local vv : display "version " string(_caller()) ":"
	version 9

	// handle special case where ci() is specified...
	//   and set the default to asymptotic
	local 0 : subinstr local 0 "ci()" "ci(asymptotic)" 
	
	syntax [anything(name=eig)]	/// name of matrix with eigenvalues
	[,				///
		Neigen(integer 32000)	/// max #evals to be displayed
		MEan			/// horizontal line of mean
		MEANLopts(string asis)	/// mean line options
		CI			/// default ci with asymptotic
	        CI1(string asis)	/// ci-method; only valid after pca
	        addplot(string asis)	///
		*			///
	]

	// parse ci options
	if `"`ci1'"' != "" | "`ci'" != "" {
		// ci and eig are not allowed together
		if `"`eig'"' != "" {
			display as error "eigenvalues and ci may not be " ///
			"specified together"
			exit 198
		}
		ParseCI , `ci1'
		local ci `s(ci)'
		local reps `s(reps)'
		local level `s(level)'
		local seed `s(seed)'
		local table `s(table)'
		local ciPlotOpts `s(ciPlotOpts)'
	}

	local ytitle "Eigenvalues"
	local title "Scree plot of eigenvalues"
	if `"`eig'"' == "" {
		if "`e(cmd)'" == "" {
			error 301
		}
		local title
		if "`e(cmd)'" == "manova" {
			local eig e(eigvals_m) // eigvals
		}
		if "`e(cmd)'" == "canon" {
			local eig e(ccorr) //canonical correlations ~ eigvals
			local title "Scree plot of canonical correlations"
			local ytitle "Canonical correlations"
		}
		if "`e(cmd)'" == "ca" {
			local eig e(Sv) // singular values ~ eigvals
			local title "Scree plot of singular values after ca"
			local ytitle "Singular values"
		}
		if "`e(cmd)'" == "mca" {
			local eig e(Ev) // eigvals (principal inertias)
			local title "Scree plot of principal inertias after mca"
			local ytitle "Principal inertias"
		}
		if "`e(cmd)'" == "mds" & "`e(method)'" == "modern" {
			di in smcl as err /// 
				"{p} screeplot only valid after mds with " ///
				"method(classical){p_end}"
			exit 321
		}
		if "`title'"=="" {
			local title "Scree plot of eigenvalues after `e(cmd)'"
		}
		if "`eig'"=="" & !has_eprop(eigen) {
			dis in smcl as err ///
				"{p} screeplot only valid after manova, " ///
				 "canon, ca, and estimation " ///
				"commands with e(property) {cmd:eigen}{p_end}"
			exit 321
		}
		if "`eig'"=="" {
			local eig e(Ev)  // eigvals
		}
	}

	// parse graphics options
	_get_gropts , graphopts(`options')
	local options   `"`s(graphopts)'"'	
	_check4gropts meanlopts, opt(`meanlopts')

	// get from e(): eigenvalues ev
	tempname emean ev
	confirm matrix `eig'
	matrix `ev' = `eig'
	if colsof(`ev')!=1 & rowsof(`ev')!=1 {
		dis as err "matrix `eig' invalid; vector expected"
		exit 503
	}
	if rowsof(`ev') > 1 {
		matrix `ev' = `ev''
	}
	local k = colsof(`ev')

	matrix `emean' = `ev' * J(`k',1,1/`k')
	scalar `emean' = chop(`emean'[1,1], 1e-6)

	// turn eigenvalues/ci into variables
	if `k' > c(N) {
		preserve
		drop _all
		quietly set obs `k'
	}

	// assure that Neigen is valid, and if not ignore
	local num = min(`k',`neigen')

	tempvar eigen meigen high low number

	quietly gen float `eigen'  = `ev'[1,_n]  in 1/`k'
	quietly gen `meigen' = - `eigen'
	sort `meigen'
	forval i = 1/`k' {
		matrix `ev'[1,`i'] = `eigen'[`i']
	}

	// Confidence interval
	if `"`ci'"' != "" {
		if "`e(cmd)'" != "pca" {
			dis as err "ci only available after pca"
			exit 498
		}

		if "`e(Ctype)'" == "" {
			local Ctype = ///
			cond(`esum'==`k',"correlation","covariance")
			dis as txt ///
			"(type of matrix e(Ctype) not found; `Ctype' assumed)"
		}
		else {
			local Ctype `e(Ctype)'
			if !inlist("`Ctype'","correlation","covariance") {
				dis as err "e(Ctype) invalid"
				exit 198
			}
		}

		if ("`ci'" == "asymptotic") & ("`Ctype'" == "correlation") {
			dis as txt ///
			  "{p 0 1 2}(caution is advised in interpreting an" ///
			  " asymptotic theory-based confidence interval of" ///
			  " eigenvalues of a correlation matrix){p_end}"
		}

		confirm scalar e(N)	
		
		// compute CIs
		tempname CI evh
		if "`ci'" == "asymptotic" {
			NormalCI `ev', n(`e(N)') level(`level')
			matrix `CI' = r(ci)
		}
		else if "`ci'" != "" {
			if "`ci'" == "homoskedastic" {
				matrix `evh' = J(1,`k',`emean')
			}
			else {
				matrix `evh' = `ev'
			}
			if "`seed'" != "" {
				`vv' set seed `seed'
			}
			local keep_seed `c(seed)'
			SimulateCI `evh', reps(`reps') n(`e(N)') level(`level')
			matrix `CI' = r(ci)
		}
		matrix colnames `CI' = low high

		// table
		if "`table'" != "" {
			tempname X
			matrix `X' = `ev''
			matrix colnames `X' = eigval
			matrix roweq `X' = _
			matrix `X' = `X' , `CI'
			matrix `X' = `X'[1..`num', 1...]
			matlist `X' , border(rows)
		}
		quietly gen `low'  = `CI'[_n,1]  in 1/`k'
		quietly gen `high' = `CI'[_n,2]  in 1/`k'
	}

	// Plot
	quietly gen byte  `number' = _n in 1/`k'
	label var `number' "Number"
	label var `eigen'  "`ytitle'"

	if "`mean'" != "" {
		quietly summarize `eigen' in 1/`num', meanonly
		local meanline "(function y = `r(mean)'"
		summarize `number' in 1/`num', meanonly 
		local meanline `"`meanline', range(`r(min)' `r(max)')"'
		local meanline `"`meanline' yvarlabel("Mean")"'
		local meanline `"`meanline' lstyle(refline) n(2)"'
		local meanline `"`meanline' `meanlopts')"'
	}

	if "`ci'" == "" {
		graph twoway ///
		   (connected `eigen' `number' in 1/`num', 		///
		                title(`title') `options') 		///
		   `meanline'						///
		   `addplot'
	}
	else {
		twoway  (rarea `low' `high' `number' in 1/`num', 	///
			  sort bstyle(ci) `ciPlotOpts')			///
			(connected `eigen' `number'  in 1/`num'		///
			  , title(`title') ytitle(Eigenvalues) 		///
legend(label(1 `=strsubdp("`level'")'% CI) label(2 Eigenvalues)) ///
			  `options')					///
			`meanline'					///
			`addplot'		
	}

	// return results
	return clear
	if "`ci'" != "" {
		return local ci    `ci'
		return scalar level = `level'
		return local Ctype `Ctype'
		return hidden local seed  `keep_seed'
		return local rngstate  `keep_seed'

		return matrix eigvals = `ev'
		return matrix ci      = `CI'
	}
end


// simulate distribution of eigenvalues of covariance matrix
// from a multivariate normal sample
//
program SimulateCI, rclass
	syntax anything(name=ev), n(int) level(cilevel) reps(int)

	confirm matrix  `ev'
	assert rowsof(`ev') == 1
	local k = colsof(`ev')

	assert `n' >= 1
	assert `reps' >= 1

	tempname framework framesave
	// simulate nrep samples of n observations
	quietly {
	    frame create `framework'
	    frame `framework' {
		set obs `n'

		tempname C U V CI

		// pspec := expression-list for eigenvalues
		forvalues i = 1/`k' {
			gen x`i' = .
			local evs   `evs'   ev`i'
			local pspec `pspec' (`V'[1,`i'])
		}

		frame create `framesave' `evs'
		forvalues r = 1/`reps' {
			forvalues i = 1/`k' {
				replace x`i' = ///
					sqrt(`ev'[1,`i']) * invnorm(uniform())
			}
			matrix accum `C' = x*, dev nocons
			matrix `C' = `C'/(`n'-1)
			matrix symeigen `U' `V' = `C'
			frame post `framesave' `pspec'
		}
	    }
	}

	// estimate CI via percentile method
	frame `framesave' {
		matrix `CI' = J(`k',2,.)
		local p1 = (100-`level')/2
		local p2 = 100-`p1'
		forvalues i = 1/`k' {
			_pctile ev`i' , p(`p1' `p2')
			matrix `CI'[`i',1]  = r(r1)
			matrix `CI'[`i',2]  = r(r2)
		}

		return matrix ci = `CI'
	}
end


// NormalCI returns a CI for the eigenvalues of ev assuming that these are
// the eigenvalues of a covariance matrix, following a Wishart distribution
//
// The CI is obtained from the asymptotic distribution of the sample eigenvalue
//    sqrt(n)(log(Lambda(i) - lambda(i)) ~ N(0,2)
//
program NormalCI, rclass
	syntax anything(name=ev), n(int) level(cilevel)

	confirm matrix  `ev'
	assert rowsof(`ev') == 1
	assert `n' >= 1

	tempname CI gamma
	scalar `gamma' = exp( invnorm(0.5+`level'/200) * sqrt(2/`n') )
	matrix `CI' = J(colsof(`ev'),2,.)
	forvalues i = 1 / `=colsof(`ev')' {
		matrix `CI'[`i',1] = `ev'[1,`i'] / `gamma'
		matrix `CI'[`i',2] = `ev'[1,`i'] * `gamma'
	}

	return matrix ci = `CI'
end


program ParseCI, sclass
	syntax [, ASymptotic HOmoskedastic HEteroskedastic	///
	        Reps(numlist min=1 max=1 integer > 1) 		///
	        Level(cilevel)					///
	        seed(str)					///
	        TABle						///
	        *						///
	]

	if `level' < 50 {
		di as err "level() may not be less than 50"
		exit 198
	}

	local type `asymptotic' `homoskedastic' `heteroskedastic'
	if `: word count `type'' > 1 {
		display as err "{p}Only one of asymptotic, homoskedastic," ///
		  " or heteroskedastic may be specified with ci(){p_end}"
		exit 198
	}
	else if `: word count `type'' == 0 {
		local asymptotic "asymptotic"
	}

	if "`asymptotic'" != "" & "`reps'" != "" {
		display as error "option reps() not allowed with asymptotic"
		exit 198
	}

	if `"`reps'"' == "" {
		local reps = 200 	// set to default
	}
	if `"`level'"' == "" {
		local level = $S_level	// set to default
	}

	// parse graphics options
	_check4gropts ci, opt(`options')

	sreturn clear
	sreturn local ci `asymptotic' `homoskedastic' `heteroskedastic'
	sreturn local reps `reps'
	sreturn local level `level'
	sreturn local seed `seed'
	sreturn local table `table'
	sreturn local ciPlotOpts `options'
end
exit
