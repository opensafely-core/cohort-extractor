*! version 1.2.4  30sep2004
program define bsample_7
	version 6, missing
	if `"`0'"'=="" { /* fast method for resample of size _N */
		quietly {
			tempvar r w
			gen double `r' = int(uniform()*_N + 1)
			gen double `w' = uniform()
			sort `r' `w'
			replace `w' = cond(`r'==`r'[_n-1], `w'[_n-1]+1, 1)
			keep if `w'[_n+1]==1 | _n==_N
			expand `w'
			exit
		}
	}

	gettoken comma : 0, parse("=, ")
	if `"`comma'"'!="," {
		local 0 `"= `0'"'
	}

	syntax [=/exp] [, CLuster(varlist) IDcluster(string)]

	if `"`exp'"'!="" {
		local nsamp = round(`exp',1e-7)
		confirm integer number `nsamp'
		if `nsamp' < 1 {
			di in red "resample size must be greater than zero"
			exit 498
		}
	}

	if "`cluster'"=="" {
		if "`idclust'"!="" {
			di in red "idcluster() can only be specified with " /*
			*/ "cluster() option"
			exit 198
		}
		if "`nsamp'"=="" { local nsamp = _N }
		if `nsamp' > _N {
			di in red /*
	*/ "resample size must not be greater than number of observations"
			exit 498
		}
		quietly {
			tempvar r w
			gen double `r' = int(uniform()*_N + 1)
			gen double `w' = uniform()
			sort `r' `w'
			replace `w' = cond(`r'==`r'[_n-1], `w'[_n-1]+1, 1)
			keep if `w'[_n+1]==1 | _n==_N
			expand `w'
			if `nsamp' == _N { exit }
			replace `w' = uniform()
			sort `w'
			keep in 1/`nsamp'
			exit
		}
	}

	confirm variable `cluster'
	if "`idclust'"!="" {
		capture confirm new variable `idclust'
		if _rc {
			confirm variable `idclust'
			drop `idclust'
		}
	}

	quietly {
		tempvar clid obsid r w

		gen double `obsid' = _n 	/* obs id (double for speed) */
		sort `cluster' `obsid'		/* sort on `obsid' so it is
		                                   deterministic within cluster,
						   not random; otherwise,
						   results may not be
						   reproducible
						*/
		replace `obsid' = _n		/* used as an index later */
		by `cluster': gen byte `clid' = (_n==1)
		count if `clid'
		local nclust = r(N)          	/* number of clusters */
		replace `clid' = sum(`clid') 	/* cluster id */

		if `nclust' == 1 {
			di in red "only one cluster detected"
			exit 460
		}
		if "`nsamp'"=="" { local nsamp = `nclust' }
		else if `nsamp' > `nclust' {
			di in red /*
	*/ "resample size must not be greater than number of clusters"
			exit 498
		}

	/* Generate bootstrap sample of `clid' in 1/`nclust'. */

		gen double `r' = int(uniform()*`nclust' + 1) in 1/`nclust'
		gen double `w' = uniform() in 1/`nclust'
		sort `r' `w' `obsid'
		replace `w' = cond(`r'==`r'[_n-1],`w'[_n-1]+1,1) in 1/`nclust'
		local ncl1 = `nclust' - 1
		replace `w' = 0 if `w'[_n+1]!=1 in 1/`ncl1'
		replace `r' = `w'[`obsid'] in 1/`nclust'
		replace `w' = `r'[`clid']
		keep if `w'
		expand `w'

		if "`idcluster'"=="" & `nsamp'==`nclust' { exit }

	/* Create new cluster id variable. */

		sort `clid' `obsid'
		by `clid' `obsid': replace `r' = (`clid'-1)*`nclust'+_n-1
		sort `r' `obsid'

		if `nsamp'!=`nclust' { /* randomly order clusters */
			by `r': replace `w' = cond(_n==1,uniform(),`w'[_n-1])
			sort `w' `r' `obsid'
				/* sort by `r' in case of ties in `w' */
		}
		else local w

	/* Make cluster id be 1, 2, 3, .... */

		by `w' `r': replace `clid' = (_n==1)
		replace `clid' = sum(`clid')
		keep if `clid' <= `nsamp'
	}

	if "`idclust'"!="" {
		label variable `clid' "Bootstrap sample cluster id"
		rename `clid' `idclust'
	}
end
exit
