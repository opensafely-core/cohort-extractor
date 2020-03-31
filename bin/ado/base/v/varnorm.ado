*! version 1.2.8  03nov2008
program define varnorm, rclass sort
	version 8.0
	syntax , [ Jbera				/*
		*/ Skewness 				/*
		*/ Kurtosis 				/*
		*/ Cholesky   				/*
		*/ ESTimates(string) 			/*
		*/ SEParator(numlist max=1 integer >=0)	/*
		*/ ]

	if "`jbera'`skewness'`kurtosis'" == "" {
		local jbera jbera
		local skewness skewness
		local kurtosis kurtosis
	}	

	if "`separator'" == "" {
		local separator 0
	}	


	tempname sig_u P Pinv prow w w_3 w_4 b1 b2 b2_c jb lam1m /*
		*/ lam1 lam2m lam2 lam3 w_3 w_4  chi2 b1_chi b1_p /*
		*/ b2_chi b2_p jb_s jb_p lrow pest 
	tempvar samp
	
	if "`estimates'" == "" {
		local estimates .
	}

	_estimates hold `pest', copy restore nullok varname(`samp')
	capture est restore `estimates'
	if _rc > 0 {
		di as err "cannot restore estimates(`estimates')"
		exit 198
	}	
	
	if "`e(cmd)'" != "var" & "`e(cmd)'" != "svar" {
		di as err "{help varnorm##|_new:varnorm} only works with "/*
	*/ "results from {help var##|_new:var} and {help svar##|_new:svar}"
		exit 198
	}	

	if "`e(cmd)'" == "svar" {
		local svar _var
	}	
	else {
		if "`cholesky'" != "" {
			di as err "cholesky cannot be specified after "	///
				"{cmd:var}"
			exit 198
		}	
	}	
	
	local neqs = e(neqs)
	local T    = e(N)
	mat `sig_u'= e(Sigma)
	local eqnames  "`e(eqnames`svar')'"

	local dfk   "`e(dfk`svar')'"

	if "`svar'" == "" | "`cholesky'" != "" {
		mat `P'    = cholesky(`sig_u')
		mat `Pinv' = inv(`P')
	}
	else {
		tempname bimat 
		capture mat `bimat' = inv(e(B))
		if _rc > 0 {
			di as err "estimate B matrix is not invertible"
			exit 498
		}	
		mat `Pinv' = `bimat'*e(A) 
		if matmissing(`Pinv') == 1 {
			di as err "estimated structural decomposition "/*
				*/ "contains missing values"
			exit 498
		}	
	}
	
	
	forvalues i=1(1)`neqs' {
		tempname u`i'
		qui predict double `u`i'' if e(sample), res equation(#`i')
		local cnames "`cnames' `u`i'' "
	}

	_est unhold `pest'

	mat colnames `Pinv' = `cnames'
	
	forvalues i=1(1)`neqs' {
		mat `prow'            = `Pinv'[`i',1...]
		qui capture drop `w'
		qui capture drop `w_3'
		qui capture drop `w_4'
		mat score double `w'  = `prow'
		
		qui gen double `w_3'=(`w')^3 if e(sample)
		qui gen double `w_4'=(`w')^4 if e(sample)
	
		qui sum `w_3', meanonly 
		mat `b1'=(nullmat(`b1') \ r(mean))
		scalar `chi2'= (`T'/6)*(r(mean)^2)
		mat `b1_chi'=(nullmat(`b1_chi') \ `chi2')
		mat `b1_p'=(nullmat(`b1_p') \ chi2tail(1,`chi2'))

		qui sum `w_4', meanonly 
		mat `b2'=(nullmat(`b2') \ (r(mean)-3))
		scalar `chi2'= (`T'/24)*((r(mean)-3)^2)
		mat `b2_chi'=(nullmat(`b2_chi') \ `chi2')
		mat `b2_p'=(nullmat(`b2_p') \ chi2tail(1,`chi2'))
		
		scalar `jb_s' = (`T'*((`b1'[`i',1])^2 /6 + /* 
			*/ (`b2'[`i',1])^2 / 24) ) 
		mat `jb'=(nullmat(`jb') \ `jb_s' )
		mat `jb_p'=(nullmat(`jb_p') \ chi2tail(2,`jb_s'))

	}
	
	mat `lam1m'      = (`T'/6) * `b1''*`b1'
	scalar `lam1'    = `lam1m'[1,1]

	mat `lam2m'      = (`T'/24) * `b2''*`b2'
	scalar `lam2'    = `lam2m'[1,1]
	
	scalar `lam3'    = `lam1' + `lam2'
	
	mat `b2'=J(`neqs',1,3)+`b2'
	

	local jb_df = 2*`neqs'

	local neqsp1 = `neqs'+1
	local eqnames  `eqnames' ALL

/* jb contains Jarque-Bera results */

	if "`jbera'" != ""  {

		local width 48
		mat `jb'=`jb',J(`neqs',1,2),`jb_p'
		mat `lrow' = ( `lam3', `jb_df', chi2tail(`jb_df',`lam3') )
		mat `jb' = `jb' \ `lrow'
	
		mat colnames `jb' = Jarque-Bera df p
		mat rownames `jb' = `eqnames' 

		DTable `table', tests(Jarque-Bera) mname(`jb') 	///
			separator(`separator')

		ret matrix jb  `jb'
	}

/* b1 contains skewness results */

		mat `b1'=`b1',`b1_chi',J(`neqs',1,1),`b1_p'
		mat `lrow' = (.b, `lam1', `neqs' , chi2tail(`neqs',`lam1') )
		mat `b1' = `b1' \ `lrow'
		mat colnames `b1' = skewness chi2 df p
		mat rownames `b1' = `eqnames' 

	if "`skewness'" != "" {
		DTable `table', tests(Skewness) mname(`b1') 	///
			separator(`separator')
	}

	ret matrix skewness  `b1'
	
/* b2 contains kurtosis results */

	mat `b2'=`b2',`b2_chi',J(`neqs',1,1),`b2_p'
	mat `lrow' = ( .b, `lam2', `neqs',  chi2tail(`neqs',`lam2'))
	mat `b2' = `b2' \ `lrow'
	mat colnames `b2' = kurtosis chi2 df p
	mat rownames `b2' = `eqnames' 

	if "`kurtosis'" != ""  {
		DTable `table', tests(Kurtosis) mname(`b2') 	///
			separator(`separator')
	}
	DfkMsg , `dfk'
	ret matrix kurtosis  `b2'
	
	ret local dfk "`dfk'"
end

program define DfkMsg
	syntax , [ dfk ]

	if "`dfk'" != "" {
		di as txt "{p 3 6}dfk estimator "	///
			"used in computations{p_end}"
	}
end

program define DTable

	syntax , tests(string)	///
		mname(name) separator(numlist integer max=1 >=0)
		
/* specify global table options */

	tempname table
	.`table' = ._tab.new, col(5) separator(`separator') ignore(.b)
	.`table'.width |20|10 8 4 13|
	.`table'.strcolor green . . . .
	.`table'.numcolor . yellow  yellow  yellow  yellow 
	.`table'.numfmt . %7.6g %7.3f %3.0f %6.5f
	.`table'.pad . 1 0 . 3

	
	tempname results 

	mat `results' = `mname'

	capture confirm matrix `results'
	if _rc > 0 {
		di as err "`tests' results matrix not available"
		exit 498
	}	

	local eqnames : rownames `results' 

	if "`tests'" != "Jarque-Bera" local theader `tests'


	di _n as txt "{col 4}`tests' test"

	.`table'.sep, top
	.`table'.titles  "Equation"   		/// 1
			"`theader'"		/// 2
			"chi2 "			/// 3
			"df"			/// 4
			"Prob > chi2"		//  5
	.`table'.sep, middle

	local rows = rowsof(`mname')
	
	forvalues i = 1/`rows' {
		local eqn : word `i' of `eqnames'

		if "`tests'" != "Jarque-Bera" {
			.`table'.row 	"`eqn'"			///
					`results'[`i',1]	///
					`results'[`i',2]	///
					`results'[`i',3]	///
					`results'[`i',4]
		}
		else {
			.`table'.row 	"`eqn'"			///
					" "			///
					`results'[`i',1]	///
					`results'[`i',2]	///
					`results'[`i',3]
		}
	}

	.`table'.sep, bot

end
exit 
