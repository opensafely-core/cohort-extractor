*! version 1.0.2  22feb2019

program define ivgetfrom, rclass
	local version = string(_caller())
	version 15
	syntax, from(string) depvar(varname) envars(string) ///
		[ exvars(string) ivvars(string) noconstant probit ]

	/* assumption: varlists are expanded				*/
	local kex : list sizeof exvars	// # exogenous variables
	local ken : list sizeof envars	// # endogenous variables
	local kiv : list sizeof ivvars  // # instrument variables

	ParseFrom `from'
	local ismat = `r(ismatrix)'
	local from `"`r(from)'"'
	local fopt `r(option)'

	tempname b b1 b2 b3 a

	/* exogenous equation						*/
	local k1 = `ken' + `kex' + ("`constant'"=="")
	mat `b1' = J(1,`k1',0)
	local stripe1 `"`envars' `exvars'"'
	if "`constant'" == "" {
		local stripe1 `"`stripe1' _cons"'
	}
	mat colnames `b1' = `stripe1'
	mat coleq `b1' = `depvar'

	/* endogenous equations						*/
	local k2 = `kiv'+`kex'+1
	forvalues i=1/`ken' {
		local eq : word `i' of `envars'
		mat `a' = J(1,`k2',0)
		mat colnames `a' = `exvars' `ivvars' _cons
		mat coleq `a' = `eq'
		mat `b2' = (nullmat(`b2'),`a')
	}

	/* std.dev. correlations					*/
	local ken1 = `ken'+1
	local k3 = `ken'*`ken1'/2 + `ken'
	if "`probit'" != "" {
		local i1 = 2
	}
	else {
		/* sigma1						*/
		local `++k3'
		local i1 = 1
	}
	mat `b3' = J(1,`k3',0)
	forvalues i=1/`ken1' {
		forvalues j=`=`i'+1'/`ken1' {
			if `version' < 16 {
				local stripe3 `stripe3' athrho`j'_`i':_cons
			}
			else {
				local stripe3 `stripe3' /:athrho`j'_`i'
			}
		}
	}
	forvalues i=`i1'/`ken1' {
		if `version' < 16 {
			local stripe3 `stripe3' lnsigma`i':_cons
		}
		else {
			local stripe3 `stripe3' /:lnsigma`i'
		}
	}
	mat colnames `b3' = `stripe3'
	mat `b' = (`b1',`b2',`b3')

	if "`fopt'" == "copy" {
		local stripe : colfullnames `b'
		local colopt colnames(`stripe')
	}
	else {
		local upopt  update
	}
	cap noi _mkvec `b', from(`from',`fopt') `upopt' `colopt'
	local rc = c(rc)
	if `rc' {
		di as text "{phang}The {bf:from()} specification is " ///
		 "invalid.{p_end}"
		exit `rc'
	}
	return mat b = `b'
end

program ParseFrom, rclass
	cap noi syntax anything(name=from id="from()" equalok), [ copy skip ]
	local rc = c(rc)

	if `rc' {
		di as txt "{phang}Option {bf:from()} is not specified " ///
		 "correctly.{p_end}"
		exit `rc'
	}
	cap confirm matrix `from'

	local k : word count `copy' `skip'
	if `k' == 2 {
		di as err "{p}{bf:from()} sub-options {bf:copy} and " ///
		 "{bf:skip} cannot be specified together{p_end}"
		exit 184
	}

	return local ismatrix = (c(rc)==0)
	return local from `"`from'"'
	return local option `copy'`skip'
end

exit
