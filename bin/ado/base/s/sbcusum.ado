*! version 1.0.0  03jan2017

program sbcusum
	version 15.0

	tempname b LastEstimates
	tempvar touse


/**get regressorlist from previous regression**/
	mat `b' = e(b)
	local varlist : colnames `b'
	local nvar : word count `varlist'
	local varlist : subinstr local varlist "_cons" "", word 	    ///
		count(local hascons)
	if (!`hascons') local cons "noconstant"

	qui gen byte `touse' = e(sample)


/**get time variables**/
        _ts timevar panelvar if `touse', sort onepanel
	local fmt : format `timevar'
	markout `touse' `timevar'

	qui tsreport if `touse', `detail'
	local gaps `r(N_gaps)'
	if (`gaps'!=0) {
		di as err "{p 0 8 2} gaps not allowed{p_end}"
		exit 198
	}

	tempname LastEstimates ModelEstimates
	_estimates hold `LastEstimates', copy restore
	estimates store `ModelEstimates'	
	local modelvars `varlist'

	syntax [, GENerate(string) RECursive ols Level(cilevel)    	    ///
			nograph * ]
	_get_gropts, graphopts(`options') getallowed(cbopts plot addplot)
	local graphopts `"`s(graphopts)'"'
	local cbopts	`"`s(cbopts)'"'
	local plot	`"`s(plot)'"'
	local addplot	`"`s(addplot)'"'
	_check4gropts cbopts, opt(`cbopts')

	local statistic `recursive' `ols' 
	sbtest_cusum `modelvars', mcons(`cons') touse(`touse') 		    ///
			model_est(`ModelEstimates') tform(`fmt')      	    ///
			gen(`generate') timevar(`timevar') 		    ///
			statistic(`statistic') level(`level') `graph' 	    ///
			cbopts(`cbopts') addplot(`addplot')	    	    ///
			twowayopts(`graphopts') 

end


program sbtest_cusum, rclass
	syntax [anything] [, mcons(string) touse(string) model_est(string)  ///
				tform(string) gen(string) timevar(string)   ///
				statistic(string) level(cilevel) nograph    ///
				graphopts(string) cbopts(string asis) 	    ///
				addplot(string asis) twowayopts(string asis) ]

	local method `statistic'
	opts_exclusive "`method'"
	local lkey = length(`"`method'"')
	if ("`method'"== "" | "`method'" == bsubstr("recursive",1,	    ///
		max(3,`lkey'))) {
		local method recursive 
	}
/*	else if ("`method'" == bsubstr("squared",1,max(2,`lkey'))) {
		local method squared
	}*/
	else if ("`method'"== "ols") local method ols
	else {
		di as err "{p}unknown method {bf:`method'}{p_end}"
		exit 198
	}
	
	local varlist `anything'
	if ("`mcons'"!="") 	local allvars `varlist'
	else 			local allvars `varlist' _cons
	
	qui estimates restore `model_est'
	local nparams = `e(rank)'
	local T = `e(N)'
	local depvar "`e(depvar)'"
	if (`"`e(cmd)'"'!="regress") {
		di as err "{p}{bf:estat sbcusum} may only be used after"    ///
		di as err "{bf:regress}{p_end}"
		exit 198
	}


/**Generate variables to hold stats**/
	tempvar recursive_stat recursive_ub recursive_lb squared_stat  
	tempvar squared_ub squared_lb ols_ub ols_lb ols_stat olsresid

	qui gen double `recursive_stat' = .
	qui gen double `recursive_ub'	= .
	qui gen double `recursive_lb'	= .
	qui gen double `squared_stat'   = .
	qui gen double `squared_ub'     = .
	qui gen double `squared_lb'     = .

	tempname critval
	if (`"`method'"'!="ols") {
		mata: sbs_est_cusum(`nparams',`level',"`depvar'",	    ///
			"`varlist'", "`mcons'","`touse'","`dots'",	    ///
			"`timevar'", "`method'")
		local cval `r(critval)'

		label var ``method'_stat' 	"`method' cusum"
		label var ``method'_ub' 	"`level'% upper bound"
		label var ``method'_lb' 	"`level'% lower bound"
	}
	else if (`"`method'"'=="ols") {
		qui predict `olsresid' if `touse', resid
		tempvar abc
		qui gen double `abc' = `olsresid'^2
		qui sum `abc'
		local ols_sd = sqrt(r(sum)/(r(N)-`nparams'))
		qui gen double `ols_stat' = sum(`olsresid')/(`ols_sd'*sqrt(r(N))) if `touse'
		label var `ols_stat'	"ols cusum"
	}

	tempvar  teststatvar ctr 
	tempname df teststat cv99 cv95 cv90 cvalues

	scalar `df' = `T'-`nparams'
	qui egen `ctr' = seq() if `touse', from(1) 
	if (`"`method'"'=="recursive") {
		scalar `cv99' = 1.142972691
		scalar `cv95' = 0.9479006054
		scalar `cv90' = 0.8499248005
		qui gen double `teststatvar' = (abs(`recursive_stat'))/(1+  ///
				2*((`ctr' - `nparams')/`df')) if `touse'
		qui sum `teststatvar'
		scalar `teststat' = r(max)
		
	}
	if (`"`method'"'=="ols") {
		tempvar ols_lb ols_ub
		qui gen double `teststatvar' = abs(`ols_stat')
		qui sum `teststatvar'
		scalar `teststat' = r(max)

		scalar `cv99' = 1.627615001
		scalar `cv95' = 1.358097216
		scalar `cv90' = 1.223847243
		if (`level'==99 | `level'==95 | `level'==90) {
			local cval = `cv`level''
		}
		else {
			tempname tmpcval
			mata: st_numscalar("`tmpcval'",findolscusumcv(1-    ///
				`level'/100))
			local cval = `tmpcval'
		}
		qui gen double `ols_lb' = -`cval'	
		qui gen double `ols_ub' = `cval'
	}
/*
	if (`"`method'"'=="squared") {
		qui replace ``method'_lb'=0 if ``method'_lb'<0 
		qui replace ``method'_ub'=1 if ``method'_ub'>1 
		qui gen `teststatvar' = `squared_stat'-((`ctr'-`nparams')/`df')
		qui sum `teststatvar'
		scalar `teststat' = r(max)
	}
*/

/**Check generate option**/
	if ("`gen'"!="") {
		_parse comma gstat gci : gen
		if (wordcount("`gstat'")>1) {
			di as err "{p}option {bf:generate()} does not allow"
			di as err "multiple names{p_end}"
			exit 198
		}
		confirm new var `gstat'
		qui gen double `gstat' = ``method'_stat'
		if (`"`method'"'=="ols") local dimethod OLS
		else			 local dimethod `method'
		label var `gstat' "cusum test statistic of `dimethod' residuals"
		/*
		if (`"`gci'"'!="") {
			di as err "{p}invalid name {bf:`gci'}{p_end}"
			exit 198
		}
		*/
		local 0 `gci'
		syntax [, ci]
		if (`"`ci'"'!="") {
			qui gen double `gstat'_lb = ``method'_lb'
			qui gen double `gstat'_ub = ``method'_ub'
			label var `gstat'_lb "`level'% lower bound"
			label var `gstat'_ub "`level'% upper bound"
		}
		
	}
	

/**Plots**/
	tempvar __N
	qui gen `__N' = _n
	qui sum `__N' if `touse'
	local mindate = `r(min)'
	local maxdate = `r(max)'

	_ts timevar panelvar if `touse', sort onepanel
	qui tsset
	if ("`r(unit1)'"==".") {
		local beg_samp   = `mindate'
		local end_samp   = `maxdate'
	}
	else {
		qui levelsof `timevar' if _n==`mindate', local(beg_samp)
		qui levelsof `timevar' if _n==`maxdate', local(end_samp)
		local beg_samp   : di `tform' `beg_samp'
		local end_samp   : di `tform' `end_samp'
	}
	if (`"`graph'"'=="") {

		local 0 ,`twowayopts'
		syntax [varlist(ts fv)] [, title(string) subtitle(string) *]
		local ciplot (rarea ``method'_lb' ``method'_ub' `timevar',  ///
			pstyle(ci) yvarlabel("`level' % CI" "`level' % CI") ///
			`cbopts' )

		local lineplot (line ``method'_stat' `timevar', `twowayopts')
		if ("`method'"=="recursive") 	local tmethod Recursive
		else				local tmethod OLS
		if (`"`title'"'=="") {
			local title title("`tmethod' cusum plot of `depvar'")
		}
		else {
			local title title("`title'")
		}
		if (`"`subtitle'"'=="") {
			local subtitle subtitle("with `level'% confidence bands around the null")
		}
		else {
			local subtitle subtitle("`subtitle'")
		}
		graph twoway `ciplot' `lineplot' || `addplot' || if `touse', `title' `subtitle' legend(off)
	}


/**Output**/
	if (`"`method'"'!="squared") {
		local spacelen = 30 + length(`"`start_trim'"')
		di as txt _n "Cumulative sum test for parameter stability"
		di _n "{txt:Sample}:{res: `beg_samp' - `end_samp'} " 	    ///
			"{col 52}Number of obs = " as res %10.0fc e(N)
		di as txt "Ho: No structural break" _newline

		di as txt _col(32)  "1% Critical"  _col(50)  "5% Critical"  ///
			_col(67) "10% Critical"
		di as txt " Statistic" _col (14) "Test Statistic" _col(36)  ///
			"Value" _col(54)  "Value" _col(72) "Value"
		di as txt "{hline 78}"
		di as txt _col(2) "`method'" _col(13) as res %10.04f 	    ///
			`teststat' _col(31) %10.04f `cv99' _col(49) %10.04f ///
			`cv95'  _col(67) %10.3f `cv90'
		di as txt "{hline 78}"
	}


/**Return result**/
	return scalar df = `df'
	return scalar level = `level'
	if (`"`method'"'!="squared") {
		return scalar cusum = `teststat'
		matrix `cvalues'  = (`cv99',`cv95',`cv90')
		matrix colnames `cvalues' = "1% value" "5% value" "10% value"
		return matrix cvalues = `cvalues'
	}
	return local tmins = "`beg_samp'"
	return local tmaxs = "`end_samp'"
	return local statistic = "`method'"

end
