*! version 1.0.4  28apr2016

/* Used by -gmm- to parse wmat() and vce() options */	
program _parse_covmat, sclass

	args cov covtype touse
	
	sret clear
	
	if "`covtype'" != "vce" & "`covtype'" != "wmatrix" {
		di as error "ParseCovMat called improperly"
		exit 2000
	}

	gettoken cov options : cov, parse(",")
	gettoken clustvar options : options, parse(",")
	local options : list clean options	// remove leading space
	if "`options'" != "" {
		local optlen : length local options
		if "`options'" == bsubstr("independent", 1, max(5, `optlen')) {
			sreturn local covopt "independent"
		}
		else {
			di as error	///
				"option {opt `covtype'()} incorrectly specified"
				exit 198
		}
	}

	local lkey : length local cov
	if "`covtype'" == "wmatrix" & "`cov'" == "" {	// default wmat(r)
		sreturn local covtype "robust"
		exit
	}
	if "`cov'" == "" | "`cov'" == bsubstr("unadjusted", 1, max(2, `lkey')) {
		sreturn local covtype "unadj"
		exit
	}
	if `"`cov'"' == bsubstr("robust", 1, max(1,`lkey')) {
		sreturn local covtype "robust"
		exit
	}

	// Cluster ?
	local word1 : word 1 of `cov'
	local clustvar : word 2 of `cov'
	local word1len : length local word1
	if `"`word1'"' == bsubstr("cluster",1,max(2,`word1len')) {
		capture noi confirm var `clustvar'
		if _rc {
			di as error ///
				"option {opt `covtype'()} incorrectly specified"
			exit 198
		}
		unab clustvar : `clustvar'
		sreturn local covtype "cluster"
		sreturn local covclustvar "`clustvar'"
		exit
	}

	// HAC
	if `"`word1'"' != "hac" {
		di as error "option {opt `covtype'()} incorrectly specified"
		exit 198
	}

	local kernel : word 2 of `cov'
	local kernlen : length local kernel
	local ktype ""
	if `"`kernel'"' == bsubstr("nwest", 1, max(2,`kernlen')) |	///
		`"`kernel'"' == bsubstr("bartlett", 1, max(2,`kernlen')) {
		local ktype "bartlett"
	}
	else if `"`kernel'"' == bsubstr("gallant", 1, max(2,`kernlen')) | ///
		`"`kernel'"' == bsubstr("parzen", 1, max(2,`kernlen')) {
		local ktype "parzen"
	}
	else if `"`kernel'"' == 					///
		bsubstr("quadraticspectral", 1, max(2, `kernlen')) |	///
		`"`kernel'"' == bsubstr("andrews", 1, max(2,`kernlen')) {
		local ktype "quadraticspectral"
	}
	
	if "`ktype'" == "" {
		di as error "invalid kernel in option {opt `covtype'()}"
		exit 198
	}
	sreturn local covtype "hac"
	sreturn local covhac "`ktype'"

	local wordcnt : word count `cov'
	if `wordcnt'==3 | `wordcnt'==4 {
		if _caller()<14.1 & `wordcnt'==4 {
			di as error "option {opt `covtype'()} incorrectly specified"
			exit 198
		}

		local lag : word 3 of `cov'
		if `"`lag'"' == bsubstr("optimal", 1, 			///
					max(3,`:length local lag')) {
			local tune : word 4 of `cov'
			sreturn local covhacopt "optimal"
			sreturn local covhaclag -1
			if ("`tune'"=="")	exit
			else {
				cap confirm integer number `tune'
				if _rc {
di as error "option {opt `covtype'()} incorrectly specified"
exit 198
				}
				else {
					if (`tune'<=1) { 
di as err "{p}must specify a positive integer greater than 1 in option "
di as err "{opt `covtype'()}{p_end}""
exit 198
					}
					sreturn local covopt `tune'
				}
				exit
			}
		}
		else {		
			if ("`options'"!="") {
				di as error ///
				"option {opt `covtype'()} incorrectly specified"
				exit 198
			}

			if "`ktype'" == "bartlett" | "`ktype'" == "parzen" {
				capture confirm integer number `lag'
				if _rc {
					di in smcl as error ///
"invalid lag specification in {opt `covtype'()}"
					exit 198
				}
				if `lag' < 0 {
					di in smcl as error ///
"number of lags in {opt `covtype'()} cannot be negative"
					exit 198
				}
				qui count if `touse'
				if `lag' >= r(N) {
					di as error	///
"number of lags in {opt `covtype'()} must be less than the sample size"
					exit 198
				}
			}
			else if "`ktype'" == "quadraticspectral" {
				capture confirm number `lag'
				if _rc {
					di as error ///
"invalid lag specification in option {opt `covtype'()}"
					exit 198
				}
				if `lag' < 0 {
					di in smcl as error ///
"number of lags in {opt `covtype'()} cannot be negative"
					exit 198
				}
			}
			sreturn local covhaclag `lag'
			exit
		}
	}
	if `wordcnt' == 2 {
		if ("`options'"!="") {
			di as error ///
				"option {opt `covtype'()} incorrectly specified"
			exit 198
		}
		qui count if `touse'
		sreturn local covhaclag `=`r(N)' - 2'
		exit
	}

	di as error "option {opt `covtype'()} incorrectly specified"
	exit 198

end
