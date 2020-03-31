*! version 1.1.8  16jan2020

program define menl_estat
	local vv : di "version " string(_caller()) ":"
	version 15.0

	if "`e(cmd)'" != "menl" {
		error(301)
	}
	gettoken sub rest: 0, parse(" ,")
	local lsub = length(`"`sub'"')
	if "`sub'" == "sd" {
		SD `rest'
		exit
	}
	if "`sub'" == bsubstr("group",1,max(2,`lsub')) {
		menl, grouponly	
		exit
	}
	if "`sub'" ==  bsubstr("recovariance",1,max(5,`lsub')) {
		RECovariance `rest'
		exit
	}
	if "`sub'" ==  bsubstr("wcorrelation",1,max(4,`lsub')) {
		`vv' WCorrelation `rest'
		exit
	}
	estat_default `0'
end

program define SD
	syntax, [ VARiance verbose post COEFLegend ]

	if "`variance'" == "" {
		local which stddev
	}
	else {
		local which variance
	}
	tempname b V bs Vs bf Vf

	local kf = e(k_f)
	mat `bf' = e(b)
	mat `Vf' = e(V)
	mat `bf' = `bf'[1,1..`kf']
	mat `Vf' = `Vf'[1..`kf',1..`kf']
	if "`which'" == "stddev" {
		mat `bs' = e(b_sd)
		mat `Vs' = e(V_sd)
	}
	else {
		mat `bs' = e(b_var)
		mat `Vs' = e(V_var)
	}
	mat `b' = (`bf',`bs')
	local k = colsof(`b')

	mata: st_matrix("`V'",blockdiag(st_matrix("`Vf'"),st_matrix("`Vs'")))
	local stripe : colfullnames `b'
	mat colnames `V' = `stripe'
	mat rownames `V' = `stripe'
	if "`post'" != "" {
		SDe, which(`which') `coeflegend' b(`b') v(`V')

		HideRETable
	}
	else if "`verbose'"!="" {
		SDr, which(`which') `coeflegend' b(`b') v(`V')
	}
	else if "`coeflegend'" != "" {
		di as err "{p}{bf:coeflegend} allowed only with options " ///
		 "{bf:post} or {bf:verbose}{p_end}"
		exit 198
	}
	else {
		SDr, which(`which') b(`b') v(`V') nofetable
	}
end

program define SDe, eclass
	syntax, which(string) b(name) v(name) [ coeflegend ]

	menl, `which' noheader `coeflegend' estatsdpost

	ereturn post `b' `v'
	ereturn local cmd "estat sd"
end

program define SDr, rclass
	syntax, which(string) b(name) v(name) [coeflegend * ]

	menl, `which' noheader `coeflegend' `options'

	tempname table

	mat `table' = r(retable)

	return add

	return mat b = `b'
	return mat V = `v'
	return mat table = `table'
end

program define HideRETable, rclass

	tempname retable

	mat `retable' = r(retable)
	local level = r(level)

	return hidden mat retable = `retable'
	return hidden scalar level = `level'
end

program define RECovariance, rclass
	syntax, [ RELEVel(string) CORRelation ///
		FORmat(string) TITLe(string) * ]

	if "`relevel'" != "" & "`relevel'"!="_all" {
		menl_validate_relevel, relevel(`relevel')
		local relevel `s(relevel)' 	// unabr variable
		local ilev = `s(ilevel)'	// index level
		local repath `s(repath)'	// canonical path
		local il1 = `ilev'
		local il2 = `ilev'
		local klev = `s(klevels)'	// # levels in model
		local relevels = 1
	}
	else {
		menl_parse_ehierarchy
		local klev = `s(klevels)'	// # levels in model
		local il1 = 1
		local il2 = `klev'
		local relevels = `klev'
	}
	if `klev' == 0 {
		di as err "{p}random effects covariance cannot be " ///
		 "computed; there are no random effects in the model{p_end}"
		exit 322
	}
	forvalues i=1/`klev' {
		local path`i' `s(path`i')'
		local lvs`i' `s(lvs`i')'
		local klv`i' = `s(klv`i')'
	}
	return scalar relevels = `relevels'
	forvalues il = `il1'/`il2' {
		local lvs : subinstr local lvs`il' " " "," , all
		tempname cov
		mat `cov' = e(cov_`il')

		if "`correlation'" != "" {
			tempname D
			mat `D' = invsym(cholesky(diag(vecdiag((`cov')))))
			mat `cov' = `D'*`cov'*`D'
			mat `cov' = (`cov'+`cov'')/2

			if "`title'" != "" {
				local title title(corr(`lvs'))
			}
			if ("`format'"=="") local format %9.4f
		}
		else {
			if "`title'" != "" {
				local title title(cov(`lvs'))
			}
			if ("`format'" == "") local format %9.0g
		}

		matlist `cov', format(`format') `title' `options'

		/* convert level to Stata level				*/
		local k = `klev'+2-`il'
		if "`correlation'" != "" {
			return mat corr`k' = `cov'
		}
		else {
			return mat cov`k' = `cov'
		}
	}
end

program define WCorrelation, rclass 
	local vv : di "version " string(_caller()) ":"

	tempvar sample

	`vv' WCorrelation0 `sample' : `0'

	if "`r(list)'" != "" {
		local depvar `e(depvar)'
		/* list the data for some reason			*/
		local ivars `e(ivars)'
		local varlist `e(varlist)'
		local varlist : list varlist - ivars
		local varlist : list varlist - depvar
		list `ivars' `e(depvar)' `varlist' if `sample'
	}
	return add
	return local list
end

program define WCorrelation0, rclass sortpreserve
	local vv : di "version " string(_caller()) ":"

	_on_colon_parse `0'

	local sample `s(before)'
	local 0 `s(after)'

	tempname EXPR
	mata: _menl_create_instance("`EXPR'")

	cap tsset
	local tsset = !c(rc)

	if !`tsset' {
		tempvar panels tsvar
	}

	`vv' cap noi WCorrelation1 `EXPR' `sample' `tsvar' `panels' : `0'
	local rc = c(rc)

	mata: _menl_remove_instance(`EXPR',"`EXPR'")

	if !`tsset' {
		tempname Corr Cov sd path

		/* tsset is rclass					*/
		mat `Corr' = r(Corr)
		mat `Cov' = r(Cov)
		mat `sd' = r(sd)
		mat  `path' =  r(path)
		local list `r(list)'

		/* -predict- tsset the data with tempvars		*/
		cap tsset
		if !c(rc) {
			tsset, clear
		}
		capture // clear c(rc)

		/* repost						*/
		return mat Corr = `Corr'
		return mat Cov = `Cov'
		return mat sd = `sd'
		return mat path = `path'
		return local list `list'
	}
	else {
		return add
	}
	exit `rc'
end

program define WCorrelation1, rclass
	local vv : di "version " string(_caller()) ":"

	_on_colon_parse `0'

	local EXPR `s(before)'
	local 0 `s(after)'

	gettoken EXPR sample: EXPR
	gettoken sample tsvname: sample

	if "`tsvname'" != "" {
		gettoken tsvname panels: tsvname

		local tsvname : list retokenize tsvname
		local panels : list retokenize panels
	}

	syntax, [ at(passthru) all COVariance list NOSORT format(string) ///
		ITERate(passthru) TOLerance(passthru) NRTOLerance(passthru) ///
		NONRTOLerance log * ]
	/* undocumented: log	- RE PNLS optimization log		*/

	if "`all'"!="" & "`at'"!="" {
		di as err "{p}options {bf:at()} and {bf:all} cannot both " ///
		 "be specified{p_end}"
		exit 184
	}
	`vv' ParseIterTol, `iterate' `tolerance' `nrtolerance' `nonrtolerance'
	local iterate = `s(iterate)'
	local tolerance = `s(tolerance)'
	local nrtolerance = `s(nrtolerance)'	// missing is nonrtolerance

	if "`all'" == "" {
		tempname path
		ValidatePath, `at'
		mat `path' = r(path)
		local spath `r(spath)'
	}
	else {
		local spath all
	}
	if `"`format'"' == "" {
		local format %6.3f
	}
	tempvar touse

	qui count if e(sample)
	if !r(N) {
		di as txt "{p 0 6 2}note: estimation sample indicator " ///
		 "function no longer exists; using full dataset{p_end}"
		marksample touse
	}
	else {
		gen byte `touse' = e(sample)
	}

	tempvar tivar obs
	if "`panels'" == "" {
		tempvar panels
	}
	if "`e(tsmissing)'" != "" {
		tempvar touse2
	}
	if "`e(timevar)'"!="" & "`path'"!="" {
		/* if a full path is not specified, repeated time values
		 * will potentially occur in the corr matrix stripe	*/
		local obs `e(timevar)'
		local rowtitle `obs'
	}
	else {
		/* observation indices before hierarchical sort		*/
		gen long `obs' = _n
		local rowtitle obs
	}
	/* construct Mata __menl_expr object from ereturn		*/
	menl_ereturn_construct, obj(`EXPR') touse(`touse') tivar(`tivar') ///
		panels(`panels') tsvname(`tsvname') touse2(`touse2') quietly

	local touse `s(touse)'	// equation estimation sample
	if "`nosort'" == "" {
		local oopt obsorder(0) 
	}
	else {
		local oopt obsorder(1)
	}
	tempname corr sd cov

	WCorrelation2 `corr' `sd' `cov', object(`EXPR') path(`path') ///
			iterate(`iterate') tolerance(`tolerance')    ///
			nrtolerance(`nrtolerance') sample(`sample')  ///
			touse(`touse') obs(`obs') `oopt' `log' `trace'

	if "`all'" == "" {
		return hidden mat path = `path'
	}
	if "`covariance'" == "" {
		di as txt _n "{p 0 4 2}Standard deviations and " ///
		 "correlations for `spath':{p_end}"
		matlist `sd', format(`format') rowtitle(`rowtitle') ///
			title(Standard deviations:) `options'
		matlist `corr', format(`format') rowtitle(`rowtitle') ///
			title(Correlations:) `options'
	}
	else {
		di as txt _n "{p 0 4 2}Covariances for `spath':{p_end}"
		matlist `cov', format(`format') rowtitle(`rowtitle') ///
			`options'
	}
	return mat Corr = `corr'
	return mat sd = `sd'
	return mat Cov = `cov'
	return local list `list'
end

program define WCorrelation2, sclass
	version 15.0
	syntax namelist(min=3 max=3), object(name) iterate(integer)    ///
			tolerance(real) nrtolerance(real) sample(name) ///
			touse(varname) obs(varname) obsorder(integer)  ///
			[ path(name) trace log ]

	local EXPR `object'

	if "`e(Cns)'" != "" {
		tempname Cm T a b est
		local cnsopt cns(`Cm' `T' `a')

		/* restripe coefficient vector to the same state that
		 * it was just after parsing. Stata can adorn o.
		 * operators						*/
		mat `b' = e(b)
		local stripe `e(bstripe)'
		mat colnames `b' = `stripe'
		mat `Cm' = e(Cns)
		local cstripe : colfullnames `Cm'
		local k = colsof(`Cm')
		local astripe : word `k' of `cstripe'
		local cstripe `"`stripe' `astripe'"'
		mat colnames `Cm' = `cstripe'
		estimates store `est'

		/* do not really need matrix Cm for factor variable 
		 *  auto constraints					*/
		_make_constraints, b(`b') constraints(`Cm')

		/* make all stripes consistent, stata interchanges
		 * o. and b. operators					*/
		mat `T' = e(T)
		mat rownames `T' = `stripe'
		mat `Cm' = e(Cm)
		mat colnames `Cm' = `cstripe'
		mat `a' = e(a)
		mat colnames `a' = `stripe'

		qui estimate restore `est'

		estimates drop `est'
	}
	if e(k_hierarchy) { //  model has random effects
		if e(misdepvar) {
			/* second estimation sample for PNLS evaluation	*/
			tempvar touse2

			gen byte `touse2' = `touse'
			markout `touse2' `e(depvar)'
		}
		/* missing nrtolerance if nonrtolerance			*/
		/* errors out if a problem				*/
		mata: _menl_lbates_blups(`EXPR',`iterate',`tolerance',   ///
			`nrtolerance',"`log'",0,("`e(method)'"=="REML"), ///
			"`Cm' `T' `a'","`touse2'")
	}
	/* errors out if a problem					*/
	gen byte `sample' = 0
	mata: _menl_estat_wcorrelation(`EXPR',"`path'","`namelist'","`obs'", ///
			"`sample'",`obsorder',("`T'","`a'"))
end

program define ValidatePath, rclass
	syntax, [ at(string) ]

	menl_parse_ehierarchy

	local klevels = `s(klevels)'
	forvalues i=1/`klevels' {
		local path`i' `s(path`i')'
		local path `path`i''
		while "`path'" != "" {
			gettoken levvar path : path, parse(">")
		}
		local levvar`i' `levvar'
		if ustrpos("`path'","#") {
			/* # invalid stripe character			*/
			local stripe `stripe' [`path`i'']:`levvar'
		}
		else {
			local stripe `stripe' `path`i'':`levvar'
		}
			
	}
	if "`e(groupvar)'" != "" {
		local `++klevels'
		local path`klevels' Residual
		local levvar`klevels' `e(groupvar)'
		local stripe `stripe' `path`klevels'':`levvar`klevels''
	}
	if !`klevels' {
		/* should not happen					*/
		di as err "{p}invalid {bf:menl} object; no hierarchy or " ///
		 "residual group variable exists{p_end}"
		exit 322
	}
	tempname mpath
	mat `mpath' = J(1,`klevels',.)
	mat colnames `mpath' = `stripe'
	if "`at'" == "" {
		tempvar touse iv
		qui gen byte `touse' = 1
		/* default						*/
		forvalues i=1/`klevels' {
			markout `touse' `levvar`i''
		}
		/* must be a better way to find the 1st nonzero index	*/
		local ind = 0
		local N = _N
		forvalues i=1/`N' {
			if `touse'[`i'] {
				local ind = `i'
				continue, break
			}
		}
		if !`ind' {
			/* should not happen				*/
			error 2000
		}
		forvalues i=1/`klevels' {
			local lev = `levvar`i''[`ind']
			mat `mpath'[1,`i'] = `lev'
			local spath `spath'`c' `levvar`i'' = `lev'
			local c ,
		}
		local spath : list retokenize spath
		return mat path = `mpath'
		return local spath "`spath'"
		exit
	}

	local path `at'
	local kpath = 0
	local imax = 0
	while "`path'" != "" {
		gettoken levvar path1 : path, parse("=")
		if "`levvar'" == "`path'" {
			di as err "{p}invalid {bf:at()} specification at " ///
			 "{bf:`levvar'}; equal sign required{p_end}"
			exit 198
		}
		gettoken equal path : path1, parse("=")
		
		cap noi unab levvar : `levvar'
		local rc = c(rc)
		if `rc' {
			di as err "(error in option {bf:at()})"
			exit `rc'
		}
		local vlabel : value label `levvar'
		gettoken level path : path, parse(" ,")
		cap confirm integer number `level'
		local rc = c(rc)
		if `rc' {
			Label2Level, vlabel(`vlabel') label(`level') at(`at')
			local level = `r(level)'
		}
		local ilev = 0
		forvalues i=1/`klevels' {
			if "`levvar'" == "`levvar`i''" {
				local ilev = `i'
				continue, break
			}
		}
		if !`ilev' {
			di as err "{p}invalid {bf:at()} specification; " ///
			 "level variable {bf:`levvar'} is not in the "   ///
			 "hierarchy{p_end}"
			exit 198
		}
		mat `mpath'[1,`ilev'] = `level'
		if `ilev' > `imax' {
			/* record the lowest level specified 		*/
			local imax = `ilev'
		}
		local `++kpath'
		
		gettoken comma path1 : path, parse(",")
		if "`comma'" == "," {
			local path `path1'
		}
	}
	forvalues i=1/`kpath' {
		if missing(`mpath'[1,`i']) {
			di as err "{p}invalid {bf:at()} specification; " ///
			 "must specify upper level values prior to "     ///
			 "{bf:`path`imax''}{p_end}"
			exit 198
		}
		local val = `mpath'[1,`i']
		local check `check' `a' `levvar`i'' == `val'
		local spath "`spath'`c' `levvar`i'' = `val'"
		local c ,
		local a &
	}
	qui count if `check'
	if !r(N) {
		local path : list retokenize path
		di as err "{p}invalid {bf:at()} specification; level " ///
		 "{bf:`path'} does not exist{p_end}"
		exit 459
	}
	if `kpath' < `klevels' {
		mat `mpath' = `mpath'[1,1..`kpath']
	}
	return mat path = `mpath'
	return local spath "`spath'"
end

program define Label2Level, rclass
	syntax, vlabel(string) label(string) at(string)

	cap label list `vlabel'
	local rc = c(rc)
	if !`rc' {
		local min = r(min)
		local max = r(max)
		local found = 0
		forvalues i=`min'/`max' {
			local x : label `vlabel' `i'
			if "`x'" == "`label'" {
				return local level = `i'
				local found = 1
				exit	// exits the loop not the function?
			}
		}
		if `found' {
			exit 	// exit again
		}
	}
	local k : list sizeof level
	di as err "{p}invalid {bf:at(`at')} specification; specified " ///
	 "level value must be an integer or value label{p_end}"
	exit 198
end

program define ParseIterTol, sclass
	local vv = _caller()

	syntax, [ ITERate(passthru) TOLerance(passthru) ///
		NRTOLerance(passthru) NONRTOLerance ]

	if "`iterate'" == "" {
		sreturn local iterate = 50
	}
	else {
		local 0, `iterate'
		syntax, ITERate(integer)

		if `iterate'<0 | floor(float(`iterate'))!=`iterate' {
			di as err "{p}invalid {bf:iterate(#)} " ///
			 "specification; nonnegative integer required{p_end}"
			exit 198
		}
		sreturn local iterate = `iterate'
	}

	if "`tolerance'" == "" {
		if `vv' < 16 {
			/* original default				*/
			sreturn local tolerance = 1E-4
		}
		else {
			/* standard Stata default			*/
			sreturn local tolerance = 1E-6
		}
	}
	else {
		local 0, `tolerance'
		syntax, TOLerance(real)

		if `tolerance' < 0 {
			di as err "{p}invalid {bf:tolerance(#)} " ///
			 "specification; nonnegative real " ///
			 "value required{p_end}"
			exit 198
		}
		sreturn local tolerance = `tolerance'
	}
	if "`nrtolerance'"!="" & "`nonrtolerance'"!="" {
		di as err "{p}option {bf:nrtolerance(#)} and " ///
		 "{bf:nonrtolerance} cannot both be specified{p_end}"
		exit 184
	}
	if "`nonrtolerance'" != "" {
		sreturn local nrtolerance .
	}
	else if "`nrtolerance'" == "" {
		sreturn local nrtolerance = 1E-5
	}
	else {
		local 0, `nrtolerance'
		syntax, NRTOLerance(real)

		if `nrtolerance' < 0 {
			di as err "{p}invalid {bf:nrtolerance(#)} " ///
			 "specification; nonnegative real " ///
			 "value required{p_end}"
			exit 198
		}
		sreturn local nrtolerance = `nrtolerance'
	}
end

exit
