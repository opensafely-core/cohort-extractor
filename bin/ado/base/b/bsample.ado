*! version 2.0.7  19may2014
program define bsample,
	version 8.0
	// version control
	if _caller() < 8 {
		bsample_7 `0'
		exit
	}
	local vv : di "version " string(max(11,_caller())) ", missing:"

	capture syntax [, weight(varname) ]
	if _rc == 0 {
		// fast method for resample of size _N
		tempvar w	/// frequency weight variable
			r	/// discrete uniform variate: obs id
			// blank
		gen double `r' = int(uniform()*_N + 1)
		gen double `w' = uniform()
		sort `r' `w'
		quietly {
		replace `w' = cond(`r' == `r'[_n-1], `w'[_n-1]+1, 1)
		if "`weight'" != "" {
			replace `w' = 0 if !(`w'[_n+1] == 1 | _n == _N)
			replace `weight' = `w'
		}
		else {
			keep if `w'[_n+1] == 1 | _n == _N
			expand `w'
		}
		} // quietly
		exit
	}

	// push "=" as first token when there is an expression
	gettoken comma : 0, parse("=, ")
	if !inlist(`"`comma'"',"",",","if","in") {
		local 0 `"= `0'"'
	}
	syntax [=/exp] [if] [in] [,	///
		CLuster(varlist)	///
		IDcluster(string)	///
		STRata(varlist)		///
		Weight(varname)		///
	]

	// mark sample
	tempvar touse
	mark `touse' `if' `in'
	markout `touse' `strata' , strok

	// no need to sort on touse if it includes the whole dataset
	quietly count if `touse'
	local nmax = r(N)
	if `nmax' < _N {
		quietly replace `touse' = . if !`touse'
	}
	else	{
		local touse
	}
	if `"`touse'`strata'`cluster'"' != "" {
		sort `touse' `strata' `cluster', stable
	}

	if `"`cluster'"' == "" {
		if "`idcluster'" != "" {
			di as err ///
		"idcluster() can only be specified with the cluster() option"
			exit 198
		}

		if `"`strata'"' == "" {
			quietly			///
				SRSWR		///
				`nmax'		///
				`"`exp'"'	///
				`"`weight'"'	///
				// blank
		}
		else {
			quietly			///
				StrSRSWR	///
				`"`touse'"'	///
				`"`exp'"'	///
				`"`weight'"'	///
				`"`strata'"'	///
				// blank
		}
	}
	else {
		confirm variable `cluster'
		if "`idcluster'" != "" {
			if `"`weight'"' != "" {
				di as err ///
			"options idcluster() and weight() may not be combined"
				exit 198
			}
			capture confirm new variable `idcluster'
			if _rc {
				confirm variable `idcluster'
				drop `idcluster'
			}
		}
		if `"`strata'"' == "" {
			quietly			///
				ClustSRSWR	///
				`nmax'		///
				`"`touse'"'	///
				`"`exp'"'	///
				`"`weight'"'	///
				`"`cluster'"'	///
				`"`idcluster'"'	///
				// blank
		}
		else {
			quietly			///
			`vv'			///
				StrClustSRSWR	///
				`"`touse'"'	///
				`"`exp'"'	///
				`"`weight'"'	///
				`"`strata'"'	///
				`"`cluster'"'	///
				`"`idcluster'"'	///
				// blank
		}
	}

end

// simple random sample with replacement
program SRSWR
	args	nmax		///
		exp		///
		weight		///
		// blank

	tempvar w		/// frequency weight variable
		r		/// discrete uniform variate: obs id
		// blank

	if `"`exp'"' != "" {
		tempvar nsamp
		gen double `nsamp' = `exp' in 1/`nmax'
		capture assert `nsamp'==`nsamp'[1] in 2/`nmax'
		if _rc {
			di as err "expression: `exp': is not constant"
			exit 198
		}
		local nsamp = `nsamp'[1]
		capture assert abs(`nsamp'-int(`nsamp')) < 1e-7
		if _rc {
			di as err "expression: `exp': is not an integer"
			exit 198
		}
		capture assert `nsamp' > 0
		if _rc {
			di as err "resample size must be greater than zero"
			exit 498
		}
		if `nsamp' > `nmax' {
			di as err ///
		"resample size must not be greater than number of observations"
			exit 498
		}
	}
	else	local nsamp `nmax'

	gen double `r' = int(uniform()*`nmax' + 1)
	gen double `w' = uniform()
	sort `r' `w' in 1/`nmax'
	replace `w' = cond(`r' == `r'[_n-1],`w'[_n-1]+1,1) in 1/`nmax'
	if "`weight'" != "" {
		replace `w' = 0 if ! (`w'[_n+1] == 1 | _n == `nmax')
		if (`nsamp' != `nmax') {
			tempvar id kept
			gen double `id' = _n in 1/`nmax'
			drop `r'
			local nobs = _N
			expand `w'
			if (`nobs' < _N) {
				tempvar copy
				gen byte `copy' = 1 if _n > `nobs'
				local dropcpy drop if `copy' == 1
			}
			else	local dropcpy "*"
			gen double `r' = uniform() if `w' & !missing(`w')
			sort `r'
			gen byte `kept' = 1 in 1/`nsamp'
			sort `id' `copy'
			by `id': replace `w' = sum(`kept')
			`dropcpy'
		}
		replace `weight' = 0
		replace `weight' = `w' in 1/`nmax'
	}
	else {
		keep if `w'[_n+1] == 1 | _n == `nmax'
		expand `w'
		if (`nsamp' == `nmax') exit
		replace `w' = uniform()
		sort `w'
		keep in 1/`nsamp'
	}
end

// stratified simple random sample with replacement
program StrSRSWR
	args	touse		///
		exp		///
		weight		///
		strata		///
		// blank

	tempvar w		/// frequency weight variable
		r		/// discrete uniform variate: obs id
		// blank

	local by "by `touse' `strata':"
	if `"`touse'"' != "" {
		local iftouse "if `touse'==1"
	}
	if `"`exp'"' != "" {
		tempvar nsamp
		`by' gen double `nsamp' = `exp' `iftouse'
		capture `by' assert `nsamp'==`nsamp'[1] `iftouse'
		if _rc {
			di as err ///
			"expression: `exp': is not constant within strata"
			exit 198
		}
		capture assert abs(`nsamp'-int(`nsamp')) < 1e-7 `iftouse'
		if _rc {
			di as err "expression: `exp': is not an integer"
			exit 198
		}
		capture assert `nsamp' > 0 `iftouse'
		if _rc {
			di as err "resample size(s) must be greater than zero"
			exit 498
		}
		capture `by' assert `nsamp' <= _N `iftouse'
		if _rc {
			di as err ///
"resample sizes must not be greater than number of observations with strata"
			exit 498
		}
	}
	else	local nsamp _N

	`by' gen double `r' = int(uniform()*_N + 1)
	gen double `w' = uniform()
	sort `touse' `strata' `r' `w'
	`by' replace `w' = cond(`r' == `r'[_n-1],`w'[_n-1]+1,1)
	if "`weight'" != "" {
		`by' replace `w' = 0 if !(`w'[_n+1] == 1 | _n == _N)
		if `"`iftouse'"' != "" {
			replace `w' = 0 if `touse' != 1
		}
		capture by `touse' `strata': assert `nsamp' == _N `iftouse'
		if (_rc) {
			tempvar id kept
			`by' gen double `id' = _n `iftouse'
			drop `r'
			local nobs = _N
			expand `w'
			if (`nobs' < _N) {
				tempvar copy
				gen byte `copy' = 1 if _n > `nobs'
				local dropcpy drop if `copy' == 1
			}
			else	local dropcpy "*"
			gen double `r' = uniform() if `w' & !missing(`w')
			sort `touse' `strata' `r'
			`by' gen byte `kept' = 1 if _n<=`nsamp'
			sort `touse' `strata' `id' `copy'
			by `touse' `strata' `id': replace `w' = sum(`kept')
			`dropcpy'
		}
		replace `weight' = `w'
		if `"`iftouse'"' != "" {
			replace `weight' = 0 if `touse' != 1
		}
	}
	else {
		`by' keep if `w'[_n+1] == 1 | _n == _N
		expand `w'
		capture by `touse' `strata': assert `nsamp' == _N `iftouse'
		if (! _rc) exit
		replace `w' = uniform()
		sort `touse' `strata' `w'
		`by' keep if _n<=`nsamp'
		if `"`iftouse'"' != "" {
			keep `iftouse'
		}
	}
end

// clustered simple random sample with replacement
program ClustSRSWR
	args	nmax		///
		touse		///
		exp		///
		weight		///
		cluster		///
		idcluster	///
		// blank

	tempvar w		/// frequency weight variable
		r		/// discrete uniform variate: cluster id
		obsid		/// observation id
		clid		/// cluster id
		nclust		/// number of clusters
		// blank

	if `"`touse'"' != "" {
		local iftouse "if `touse'==1"
		local andtouse "& `touse'==1"
	}

	by `touse' `cluster': gen byte `clid' = (_n == 1) `iftouse'
	replace `clid' = sum(`clid') in 1/`nmax'
	local nclust = `clid'[`nmax']
	if `nclust' == 1 {
		di as err "singleton cluster detected"
		exit 460
	}

	if `"`exp'"' != "" {
		tempvar nsamp
		gen double `nsamp' = `exp' in 1/`nmax'
		capture assert `nsamp'==`nsamp'[1] in 1/`nmax'
		if _rc {
			di as err "expression: `exp': is not constant"
			exit 198
		}
		local nsamp = `nsamp'[1]
		capture assert abs(`nsamp'-int(`nsamp')) < 1e-7 
		if _rc {
			di as err "expression: `exp': is not an integer"
			exit 198
		}
		capture assert `nsamp' > 0
		if _rc {
			di as err "resample size(s) must be greater than zero"
			exit 498
		}
		if `nsamp' > `nclust' {
			di as err ///
		"resample size must not be greater than number of clusters"
			exit 498
		}
	}
	else	local nsamp `nclust'

	// Generate bootstrap samples of `clid' in 1/`nclust'
	gen double `obsid' = _n
	gen double `r' = int(uniform()*`nclust' + 1) in 1/`nclust'
	gen double `w' = uniform() in 1/`nclust'
	sort `r' `w' `obsid' in 1/`nclust'
	replace `w' = cond(`r' == `r'[_n-1],`w'[_n-1]+1,1) in 1/`nclust'
	local ncl1 = `nclust' - 1
	replace `w' = 0 if `w'[_n+1] != 1 in 1/`ncl1'
	replace `r' = `w'[`obsid'] in 1/`nclust'
	replace `w' = `r'[`clid']
	if `"`iftouse'"' != "" {
		replace `w' = 0 if `touse' != 1
	}
	if "`weight'" != "" {
		if (`nsamp' != `nclust') {
			ClustSubWgt		///
				`""'		///
				`"`nclust'"'	///
				`"`clid'"'	///
				`"`obsid'"'	///
				`"`r'"'		///
				`"`w'"'		///
				`"`nsamp'"'
		}
		replace `weight' = `w'
	}
	else {
		keep if `w'
		expand `w'
		if ( (`nsamp' != `nclust') | ("`idcluster'" != "") ) {
			NewClustID		///
				`"`idcluster'"'	///
				`""'		///
				`"`cluster'"'	///
				`"`nclust'"'	///
				`"`clid'"'	///
				`"`obsid'"'	///
				`"`r'"'		///
				`"`w'"'		///
				`"`nsamp'"'
		}
	}
end

// stratified and clustered simple random sample with replacement
program StrClustSRSWR
	version 8.0
	if _caller() > 13 {
		local uniq uniq
	}
	local iduniq = _caller() > 13
	args	touse		///
		exp		///
		weight		///
		strata		///
		cluster		///
		idcluster	///
		// blank

	tempvar w		/// frequency weight variable
		r		/// discrete uniform variate: cluster id
		obsid		/// observation id
		clid		/// cluster id
		nclust		/// number of clusters
		// blank

	if `"`touse'"' != "" {
		local iftouse "if `touse'==1"
		local andtouse "& `touse'==1"
	}
	local by   "by `touse' `strata' :"

	by `touse' `strata' `cluster' : gen byte `clid' = (_n == 1) `iftouse'
	`by' replace `clid' = sum(`clid') `iftouse'
	`by' gen double `nclust' = `clid'[_N] `iftouse'
	capture assert `nclust' != 1 `iftouse'
	if _rc {
		di as err "singleton cluster detected"
		exit 460
	}

	if `"`exp'"' != "" {
		tempvar nsamp
		`by' gen double `nsamp' = `exp' `iftouse'
		capture `by' assert `nsamp'==`nsamp'[1] `iftouse'
		if _rc {
			di as err ///
			"expression: `exp': is not constant within strata"
			exit 198
		}
		capture assert abs(`nsamp'-int(`nsamp')) < 1e-7 `iftouse'
		if _rc {
			di as err "expression: `exp': is not an integer"
			exit 198
		}
		capture assert `nsamp' > 0
		if _rc {
			di as err "resample size(s) must be greater than zero"
			exit 498
		}
		capture assert `nsamp' <= `nclust' `iftouse'
		if _rc {
			di as err ///
		"resample size must not be greater than number of clusters"
			exit 498
		}
	}
	else	local nsamp `nclust'

	/// Generate bootstrap samples of `clid' in 1/`nclust' by strata
	`by' gen double `obsid' = _n
	`by' gen double `r' = int(uniform()*`nclust' + 1)	///
		if _n <= `nclust' `andtouse'
	`by' gen double `w' = uniform()				///
		if _n <= `nclust' `andtouse'
	sort `touse' `strata' `r' `w' `obsid'
	`by' replace `w' = cond(`r' == `r'[_n-1],`w'[_n-1]+1,1) ///
		if _n <= `nclust'
	`by' replace `w' = 0 ///
		if ! (`w'[_n+1] == 1 | _n == `nclust') | _n > `nclust'
	`by' replace `r' = `w'[`obsid'] if _n <= `nclust'
	`by' replace `w' = `r'[`clid']
	if `"`iftouse'"' != "" {
		replace `w' = 0 if `touse' != 1
	}
	if "`weight'" != "" {
		capture assert `nsamp' == `nclust' `iftouse'
		if (_rc) {
			ClustSubWgt		///
				`"`strata'"'	///
				`"`nclust'"'	///
				`"`clid'"'	///
				`"`obsid'"'	///
				`"`r'"'		///
				`"`w'"'		///
				`"`nsamp'"'
		}
		replace `weight' = `w'
		if `"`iftouse'"' != "" {
			replace `weight' = 0 if `touse' != 1
		}
	}
	else {
		if `"`iftouse'"' != "" {
			keep `iftouse' & `w'
		}
		else	keep if `w'
		expand `w'
		capture assert `nsamp' == `nclust'
		if ( _rc | ("`idcluster'" != "") ) {
			NewClustID		///
				`"`idcluster'"'	///
				`"`strata'"'	///
				`"`cluster'"'	///
				`"`nclust'"'	///
				`"`clid'"'	///
				`"`obsid'"'	///
				`"`r'"'		///
				`"`w'"'		///
				`"`nsamp'"'	///
				`"`uniq'"'
		}
	}
end

program ClustSubWgt
	args	strata		///
		nclust		///
		clid		///
		obsid		///
		r		///
		w		///
		nsamp		///
		// blank

	if `"`strata'"' != "" {
		local by "by `strata':"
	}

	tempvar kept newclid
	local nobs = _N
	replace `clid' = 0 if `w' == 0 | missing(`w')
	expand `w'
	if (`nobs' < _N) {
		tempvar copy
		gen byte `copy' = 1 if _n > `nobs'
		local dropcpy drop if `copy' == 1
	}
	else	local dropcpy "*"
	sort `strata' `clid' `obsid'
	by `strata' `clid' `obsid': replace `r' = (`clid'-1)*`nclust'+_n-1
	sort `strata' `r' `obsid'
	by `strata' `r': replace `w' = cond(_n==1, uniform(), `w'[_n-1]) ///
		if `clid'
	sort `strata' `w' `r' `obsid'
	by `strata' `w' `r': gen byte `newclid' = (_n == 1) if `clid'
	`by' replace `newclid' = sum(`newclid') if `clid'
	by `strata' `w' `r': gen byte `kept' = _n==1 if `newclid' <= `nsamp'
	sort `strata' `clid'
	by `strata' `clid': replace `w' = sum(`kept')
	by `strata' `clid': replace `w' = `w'[_N]
	`dropcpy'
	if `"`strata'"' != "" {
		replace `w' = 0 if !`clid'
	}
end

program NewClustID
	args	idcluster	///
		strata		///
		cluster		///
		nclust		///
		clid		///
		obsid		///
		r		///
		w		///
		nsamp		///
		uniq		///
		// blank

	if `"`strata'"' != "" {
		local by "by `strata':"
	}

	// Create new cluster id variable
	sort `strata' `clid' `obsid'
	by `strata' `clid' `obsid': replace `r' = (`clid'-1)*`nclust'+_n-1
	sort `strata' `r' `obsid'

	// randomly order clusters
	capture assert `nsamp' == `nclust'
	if _rc {
		by `strata' `r': replace `w' = cond(_n == 1,uniform(),`w'[_n-1])
		// sort by `r' in case of ties in `w'
		sort `strata' `w' `r' `obsid'
	}
	else	local w

	// Make cluster id be 1, 2, 3, ....
	by `strata' `w' `r': replace `clid' = (_n == 1)
	`by' replace `clid' = sum(`clid')
	keep if `clid' <= `nsamp'
	if "`uniq'" != "" {
		by `strata' `w' `r': replace `clid' = (_n == 1)
		replace `clid' = sum(`clid')
	}
	if "`idcluster'" != "" {
		label variable `clid' "Bootstrap sample cluster id"
		rename `clid' `idcluster'
	}
end

exit
