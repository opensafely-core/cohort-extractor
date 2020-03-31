*! version 1.0.4  07feb2019
program define arfima_estat, rclass
	version 12

	if "`e(cmd)'" != "arfima" {
		di as err "{help arfima##|_new:arfima} estimation results " ///
		 "not found"
		exit 301
	}
	gettoken sub rest: 0, parse(" ,")

	local lsub = length("`sub'")
	if "`sub'" == "acplot"	{
		_estat_acplot `rest'
	}
	else if "`sub'" == bsubstr("acf",1,max(3,`lsub')) {
		/* estat acf is undocumented				*/
		ACF `rest'
	}
	else if "`sub'"=="ic" & "`e(method)'"=="mpl" {
		di as err "{p}information criterion will not be "   ///
		 "computed for an {bf:arfima} model fit using the " ///
		 "modified profile likelihood, option {bf:mpl}{p_end}" 
		exit 322
	}
	else if `"`sub'"' == bsubstr("summarize",1,max(2,`lsub')) {
		if ("`e(covariates)'"=="_NONE") estat_summ `e(depvar)'
		else estat_summ `e(depvar)' `e(covariates)'
	}
	else estat_default `0'
end

program ACF, rclass
	syntax, [ n(integer 0) noPLOT GENerate(string) COVariance ///
			TITle(passthru) * ]

	tempname b d v version
	tempvar acf

	if (!`n') local n = e(N)
	else if `n' < 0 {
		di as err "{bf:n(#)} must be a positive integer"
		exit 198
	}
	else if `n' > _N {
		di as err "{p}{bf:n(`n')} must be less than or equal to " ///
		 "the number of observations in the data set{p_end}"
		exit 198
	}
	if (`n'<_N) local nn 1..`n'
	else local nn .

	local nm "[|2\\`=`n'+1'|]"

	if "`generate'" != "" {
		ParseGenerate `generate'
		local varlist `s(varlist)'
		local typlist `s(typlist)'
	}
	else if "`plot'" != "" {
		di as error "nothing to do"
		exit 198
	}
	mat `b' = e(b)
	scalar `version' = e(version)
	if missing(`version') {
		scalar `version' = 1
	}
	local lar = 0
	if e(ar_max) {
		tempname bar

		foreach l in `e(ar)' {
			if (`l'==1) mat `bar' = `b'[1,"ARFIMA:L.ar"]
			else {
				mat `bar' = (nullmat(`bar'), ///
					`b'[1,"ARFIMA:L`l'.ar"])
			}
			local `++lar'
		}
	}
	local lma = 0
	if e(ma_max) {
		tempname bma

		foreach l in `e(ma)' {
			if (`l'==1) mat `bma' = `b'[1,"ARFIMA:L.ma"]
			else {
				mat `bma' = (nullmat(`bma'), ///
					`b'[1,"ARFIMA:L`l'.ma"])
			}
			local `++lma'
		}
	}
	cap scalar `d' = _b[ARFIMA:d]
	if c(rc) {
		scalar `d' = 0
		local dd = 0
	}
	else local dd : di %5.3f `d'

	if ("`e(method)'"=="mpl") cap scalar `v' = e(s2)
	else if `version' < 2 {
		cap scalar `v' = [sigma2]_b[_cons]
	}
	else {
		cap scalar `v' = [/]_b[sigma2]
	}

	local cor = ("`covariance'"=="")

	qui gen double `acf' = .
	mata: _arfima_entry_e(`n', "`bar'", "`bma'", "`d'", "`v'", `cor', ///
			"`acf'")
	scalar `v' = r(v)

	qui count if missing(`acf') & _n<=`n'
	if (r(N)) di as txt "note: {bf:acf} generated `=r(N)' missing values"
	
	if (`cor') local lab "autocorrelation"
	else local lab "autocovariance"

	if "`plot'" == "" {
		if "`title'" == "" {
			local title title(ARFIMA(`lar',`dd',`lma'))	
		}
		label variable `acf' "`lab'"
		tempvar del
		qui tsset
		local obstype = c(obs_t)
		if "`obstype'" != "double" {
			local obstype "long"
		}
		qui gen `obstype' `del' = _n*r(tdelta)
		if ("`r(unit)'"!="") local unit `"= `r(unit)'"'

		label variable `del' "lag `unit'"
		twoway scatter `acf' `del' if _n<=`n', msize(small) || 	///
			spike `acf' `del' if _n<=`n', yline(0) 		///
			legend(off) `title' `options'
	}
	if "`generate'" != "" {
		qui gen `typlist' `varlist' = `acf'
		label variable `varlist' "`lab'"
	}
	return clear
	return scalar v = `v'
end

program ParseGenerate, sclass
	syntax newvarlist(max=1)

	sreturn local varlist `varlist'
	sreturn local typlist `typlist'
end

exit
