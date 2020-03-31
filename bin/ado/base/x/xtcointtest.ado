*! version 1.0.0  27mar2017

program xtcointtest, rclass
	version 15.0

	_parse comma lhs rhs : 0
	gettoken method lhs : lhs
	local 0 `lhs' `rhs'
	
	if ("`method'"=="kao" | "`method'"=="pedroni" | 		    ///
		"`method'"=="westerlund") {
		local cmd xtcointtest
		local cmdline xtcointtest `method' `0'
	}
	else {
		di as err "{bf:`method'} is not a valid test"
		exit 198
	}

	tempname LastEstimates ModelEstimates
	cap qui {
		_estimates hold `LastEstimates', copy restore
		estimates store `ModelEstimates'
		eret clear
	}
	if c(rc) local _est 0
	else 	 local _est 1
	_`method' `0'
	return add
	eret clear
	if (`_est') qui estimates restore `ModelEstimates'

end

program _kao, rclass
	syntax varlist(ts fv) [if] [in], [ Lags(string) KERnel(string) demean ]

	gettoken depvar indepvars: varlist
	local indepvars = strtrim("`indepvars'")
	foreach var of local indepvars {
		if ("`var'"=="`depvar'") {
			di as err "{p}may not specify dependent variable as "
			di as err "one of the regressors{p_end}"
			exit 198
		}
	}
	if ("`indepvars'"=="") {
		di as err "{p}at least one regressor must be specified{p_end}"
		exit 198
	}	

	if (`"`lags'"'!="") {
		_xtur_parse_lags `"`lags'"'
		local adf_lags = `s(lags)'
		local maxadf_lags = `adf_lags'
		local adf_lagsel `s(lagsel)' 
	}
	else local adf_lags 1
	
	if (`"`kernel'"'!="") {
		_xtcoint_parse_kernel `"`kernel'"'
		local hac_kernel `s(hac_kernel)'
		local hac_lags = `s(hac_lags)'  
		local hac_bsel   `s(hac_bsel)'  
		if ("`hac_bsel'" != "" & "`hac_bsel'"!="nwest") {
			di as err "{p}must specify number of lags or "
			di as err "lag-selection algorithm in {bf:kernel()}"
			di as err "{p_end}"
			exit 198
		}
	}
	else {
		local hac_kernel bartlett
		local hac_lags = .
		local hac_bsel nwest
	}

	marksample touse
	_xt, trequired
	cap xtset
	tempname usrdelta
	local panelvar `r(panelvar)'
	local timevar `r(timevar)'
	scalar `usrdelta' = `r(tdelta)'
	local usrformat `r(tsfmt)'
	qui xtsum `panelvar' if `touse'
	local N `r(n)'

	/**check for strongly balanced sample**/
	qui _xtstrbal `panelvar' `timevar' `touse'
	if "`r(strbal)'" != "yes" {
		local unbalanced unbalanced
	}
	/**check for gaps**/
	cap bys `panelvar' (`timevar'): assert D.`timevar' == `usrdelta'    ///
		if `touse' & _n > 1
	if c(rc) {
		di as error "{p}Kao test does not allow gaps in data{p_end}"
		exit 498
	}

	/**remove cross-sectional averages for each time period**/
	if "`demean'" != "" {
		local opdepvar `depvar'
		local opindepvars `indepvars'
        	tempvar dmdepvar 
		_xturdemean `dmdepvar' : `depvar' `timevar' `touse'
		foreach var of local indepvars {
			_ms_parse_parts `var'
			local tmvar `r(name)'
			local tsop `r(ts_op)'
			tempvar dm`tmvar'_`tsop'
			_xturdemean `dm`tmvar'_`tsop'' : `var' `timevar' `touse'
			local dmindepvars `dmindepvars' `dm`tmvar'_`tsop''
		}
		local depvar `dmdepvar'
		local indepvars `dmindepvars'
		local dmeanmsg "Cross-sectional means removed"
	}

	tempvar  resd err_resd adf_err_resd
	tempname sigmasq0_nu sigmasq_nu
	
	tempvar err_y 
	qui {
		reg `depvar' l.`depvar' if `touse', nocons
		predict `err_y' if `touse', resid
		foreach var of local indepvars {
			_ms_parse_parts `var'
			local tmpvar `r(name)'
			local tsop `r(ts_op)'
			tempvar err_`tmpvar'_`tsop'
			reg `var' l.`var' if `touse', nocons
			predict `err_`tmpvar'_`tsop'' if `touse', resid
			local _err_x `_err_x' `err_`tmpvar'_`tsop''
		}
	}
	markout `touse' `err_y' `_err_x'
	mata: xtlrcov(st_data(.,"`panelvar' `err_y' `_err_x'","`touse'"),    ///
		"`hac_kernel'", `hac_lags')
	
	local haclagsel `r(lags)'
	return hidden scalar bw = r(bw)
	scalar `sigmasq0_nu' = r(sigmasq0_nu)
	scalar `sigmasq_nu' = r(sigmasq_nu)


	qui {
		xtreg `depvar' `indepvars' if `touse', fe
		predict `resd', e
		reg `resd' l.`resd' , nocons
	}
	local rho = _b[l.`resd']
	markout `touse' `resd' l.`resd'

	qui count if `touse'
	local Ntotal = r(N)
	local T = r(N)/`N'		/*balanced panel*/

	/**DF_rho_star test statistic***/
	local df_rho_star = (sqrt(`N')*`T'*(`rho'-1) + (3*sqrt(`N')*	    ///
		`sigmasq_nu')/`sigmasq0_nu')/sqrt(3+(36*`sigmasq_nu'^2)/(5* ///
		`sigmasq0_nu'^2))

	/**t_rho test statistic***/
	mata: st_local("trho",strofreal(trho(st_data(.,"`panelvar' `resd' l.`resd'","`touse'"))))

	/**DF_t_star test statistic***/
	local df_t_star = (`trho' + (sqrt(6*`N'*`sigmasq_nu')/(2*sqrt(	    ///
		`sigmasq0_nu'))))/sqrt((`sigmasq0_nu'/(2*`sigmasq_nu'))+(3* ///
		`sigmasq_nu')/(10*`sigmasq0_nu'))

	/**Lag selection for ADF regression**/
	if ("`adf_lagsel'"!="") {
		tempname mscrit allmat
		mat `mscrit' = J(`maxadf_lags',2,.)
		forvalues i=`maxadf_lags'(-1)1 {
			qui {
				if (`i'==`maxadf_lags') {
					reg `resd' l.`resd' 		    ///
						l(1/`i').D.`resd' , nocons
					local samp e(sample)
				}
				else {
					reg `resd' l.`resd' 		    ///
					l(1/`i').D.`resd' if `samp'  , nocons
				}
				estat ic
			}
			mat `allmat' = r(S)
			if ("`adf_lagsel'"=="aic") mat `mscrit'[`i',1] =    ///
				(`i',`allmat'[1,5])
			else if ("`adf_lagsel'"=="bic") mat `mscrit'[`i',1] ///
				= (`i',`allmat'[1,6])
			else if ("`adf_lagsel'"=="hqic") mat `mscrit'[`i',1] ///
				= (`i',-2*`allmat'[1,3]+2*log(log(	    ///
				`allmat'[1,1]))*`allmat'[1,4])
		}
		mata: st_local("adf_lags",strofreal(select(		    ///
		st_matrix("`mscrit'")[.,1],st_matrix("`mscrit'")[.,2]:==    ///
		colmin(st_matrix("`mscrit'")[.,2]))))
	}
	/**t_adf test statistic***/
	qui {
		reg `resd' l.`resd' l(1/`adf_lags').D.`resd', nocons
		predict `adf_err_resd', resid
	}

	local adfrho = _b[l.`resd']

	markout `touse' `resd' l.`resd' l(1/`adf_lags').D.`resd'
	mata: st_local("tadf",strofreal(tadf(st_data(.,			    ///
	"`panelvar' l.`resd' `adf_err_resd' l(1/`adf_lags').d.`resd'","`touse'"))))

/**ADF test statistic***/
	local adf = (`tadf' + (sqrt(6*`N'*`sigmasq_nu'))/(2*sqrt(	    ///
		`sigmasq0_nu')))/sqrt((`sigmasq0_nu'/(2*`sigmasq_nu'))+(3*  ///
		`sigmasq_nu')/(10*`sigmasq0_nu'))

/**DF_rho test statistic***/
	local df_rho = (sqrt(`N')*`T'*(`rho'-1) + 3*sqrt(`N'))/sqrt(51/5)

/**DF_t test statistic***/
	local df_t = sqrt(5/4)*`trho' + sqrt(15*`N'/8)


/**Output**/
	if ("`constant'"=="") 	local panelmean Included
	else			local panelmean Not included
	if ("`trend'"=="")	local timetrend Not included
	else			local timetrend Included
	if ("`adf_lags'"=="1") 	local oplag lag
	else			local oplag lags
	if ("`hac_kernel'"=="bartlett") local hackernel Bartlett
	else if ("`hac_kernel'"=="parzen") local hackernel Parzen
	else if ("`hac_kernel'"=="quadraticspectral") local hackernel Quad. Spectral
	if ("`hac_lags'"=="1")	local haclags `hac_lags' lag
	else 			local haclags `hac_lags' lags
	if ("`haclagsel'"=="1")	local ophaclag lag
	else			local ophaclag lags
	cap qui confirm integer number `haclagsel'
	if (_rc!=0) local ophaclag `ophaclag' average
	
	if ("`demean'"!="") {
		local depvar `opdepvar'
		local indepvars `opindepvars'
	}
	di 
	di as txt "Kao test for cointegration"
	di in smcl as text "{hline 26}"
	di as text "Ho: No cointegration" _col(45) "Number of panels"	    ///
		_col(68) "=" _col(69) as res %7.0g `N' 
	di as text "Ha: All panels are cointegrated" _c			
	if ("`unbalanced'"!="") {
		di as txt _col(45) "Avg. number of periods" _c
	}
	else di as txt _col(45) "Number of periods" _c
	di as txt _col(68) "=" _col(69) as res %7.0g `T' 
	di
	di as txt "Cointegrating vector: " as res "Same" 
	di as text "Panel means: " as res _col(23) "`panelmean'" _c
	di as text _col(45) "Kernel: " as res _col(63) "`hackernel'"   

	di as text "Time trend: " as res _col(23)"`timetrend'" _c
	di as txt _col(45) "Lags: " as res _col(62) %5.2f `haclagsel' _c
	if ("`hac_bsel'"=="nwest") {
		di as txt " (" as res "Newey-West" as txt ")"
		return local hac_method = "nwest"
	}
	else di 
	di as text "AR parameter: " as res _col(23) "Same" _c
	di as txt _col(45) "Augmented lags:" as res _col(63) "`adf_lags' " _c
	if ("`adf_lagsel'"!="") {
		di as txt "(" as res strupper("`adf_lagsel'") as txt")"
	}
	else di
	if ("`dmeanmsg'"!="") di _n as text "`dmeanmsg'"
	
	di in smcl as text "{hline 78}"
	di as text _col(45) "Statistic" _col(63) "p-value"
	di in smcl as text "{hline 78}"

	tempname padf pdfrhos pdfts pdfrho pdft
	scalar `padf' = 1-normal(abs(`adf'))
	scalar `pdfrhos' = 1-normal(abs(`df_rho_star'))
	scalar `pdfts' = 1-normal(abs(`df_t_star'))
	scalar `pdfrho' = 1-normal(abs(`df_rho'))
	scalar `pdft' = 1-normal(abs(`df_t'))

	di as text _col(2) "Modified Dickey-Fuller t"                       ///
		as res _col(45) %8.4f `df_rho_star' _c
		di as res _col(63) %6.4f `pdfrhos'
	di as text _col(2) "Dickey-Fuller t"				    ///
		as res _col(45) %8.4f `df_t_star'			    ///
		as res _col(63) %6.4f `pdfts'
	di as text _col(2) "Augmented Dickey-Fuller t"			    ///
		as res _col(45) %8.4f `adf'				    ///
		as res _col(63) %6.4f `padf'
	di as text _col(2) "Unadjusted modified Dickey-Fuller t"	    ///
		as res _col(45) %8.4f `df_rho'				    ///
		as res _col(63) %6.4f `pdfrho'
	di as text _col(2) "Unadjusted Dickey-Fuller t"			    ///
		as res _col(45) %8.4f `df_t'				    ///
		as res _col(63) %6.4f `pdft'
	di in smcl as text "{hline 78}"

/**Return result**/
	return scalar adf_lags = `adf_lags'
	return scalar hac_lagm = `haclagsel'
	return scalar N_g = `N'
	return scalar N_t = `T'
	return scalar N = `Ntotal'

	return local test = "kao"
	return local deterministics = "constant"
	return local hac_kernel = strlower("`hackernel'")
	return local adf_method = "`adf_lagsel'"
	return local demean = "`demean'"

	tempname rmat pmat
	mat `rmat' = [`df_rho_star',`df_t_star',`adf',`df_rho',`df_t']
	mat `pmat' = [`pdfrhos',`pdfts',`padf',`pdfrho',`pdft']
	mat colnames `rmat' = "DF rho*" "DF t*" "ADF" "DF rho" "DF t"
	mat colnames `pmat' = "DF rho*" "DF t*" "ADF" "DF rho" "DF t"
	return matrix stats = `rmat'
	return matrix p = `pmat'
	

end


program _pedroni, rclass
	syntax varlist(ts fv) [if] [in], [ noCONStant Trend Lags(string)    ///
		KERnel(string) demean ar(string) ]

	gettoken depvar indepvars: varlist
	local indepvars = strtrim("`indepvars'")
	local nreg = wordcount("`indepvars'")
	
	foreach var of local indepvars {
		if ("`var'"=="`depvar'") {
			di as err "{p}may not specify dependent variable as "
			di as err "one of the regressors{p_end}"
			exit 198
		}
	}
	if (`nreg'>7) {
		di as err "{p}number of regressors may not exceed 7{p_end}"
		exit 198
	}
	if ("`indepvars'"=="") {
		di as err "{p}at least one regressor must be specified{p_end}"
		exit 198
	}
	if ("`constant'" != "" & "`trend'" != "") {
		di as err "{p}cannot specify both {bf:noconstant} and "
		di as err "{bf:trend}{p_end}"
		exit 198
	}
	if ("`constant'"=="") local panelmean Included
	else {
		local panelmean Not included
		local type 1
	}
	if ("`trend'"=="")	local timetrend Not included
	else			local timetrend Included
	if ("`constant'"=="" & "`trend'"=="") local type 2
	if ("`constant'"=="" & "`trend'"!="") local type 3

	if (`"`lags'"'!="") {
		_xtur_parse_lags `"`lags'"'
		local adf_lags = `s(lags)'
		local maxadf_lags = `adf_lags'
		local adf_lagsel `s(lagsel)' 
	}
	else local adf_lags 1
	
	if (`"`kernel'"'!="") {
		_xtcoint_parse_kernel `"`kernel'"'
		local hac_kernel `s(hac_kernel)'
		local hac_lags = `s(hac_lags)'  
		local hac_bsel   `s(hac_bsel)'  
		if ("`hac_bsel'" != "" & "`hac_bsel'"!="nwest") {
			di as err "{p}must specify number of lags or "
			di as err "lag-selection algorithm in {bf:kernel()}"
			di as err "{p_end}"
			exit 198
		}
	}
	else {
		local hac_kernel bartlett
		local hac_lags = .
		local hac_bsel nwest
	}
	if (`"`ar'"'=="") {
		local ar "Panel specific" 
		local archk panels
	}
	else if (`"`ar'"'=="same") {
		local ar "Same"
		local archk same
	}
	else {
		local ar = bsubstr("`ar'",1,max(6,strlen(`"`ar'"')))
		local archk = bsubstr("`ar'",1,6)
		if (`"`archk'"'=="panels") 	local ar "Panel specific"
		else {
			di as err "{p}option {bf:ar()} must be one of "
			di as err " {bf:panelspecific} or {bf:same}{p_end}"
			exit 198
		}
	}

	marksample touse
	tempvar maintouse
	qui gen `maintouse' = `touse'
	_xt, trequired
	cap xtset
	tempname usrdelta
	local panelvar `r(panelvar)'
	local timevar `r(timevar)'
	scalar `usrdelta' = `r(tdelta)'
	local usrformat `r(tsfmt)'
	qui xtsum `panelvar' if `touse'
	local N `r(n)'
	qui count if `touse'
	local Ntotal = r(N)
	local T = r(N)/`N'		/*balanced panel*/

	/**check for strongly balanced sample**/
	qui _xtstrbal `panelvar' `timevar' `touse'
	if "`r(strbal)'" != "yes" {
		local unbalanced unbalanced
	}
	/**check for gaps**/
	cap bys `panelvar' (`timevar'): assert D.`timevar' == `usrdelta'    ///
		if `touse' & _n > 1
	if c(rc) {
		di as error "{p}Pedroni test does not allow gaps in data{p_end}"
		exit 498
	}

	/**remove cross-sectional averages for each time period**/
	if "`demean'" != "" {
		local opdepvar `depvar'
		local opindepvars `indepvars'
        	tempvar dmdepvar 
		_xturdemean `dmdepvar' : `depvar' `timevar' `touse'
		foreach var of local indepvars {
			_ms_parse_parts `var'
			local tmvar `r(name)'
			local tsop `r(ts_op)'
			tempvar dm`tmvar'_`tsop'
			_xturdemean `dm`tmvar'_`tsop'' : `var' `timevar' `touse'
			local dmindepvars `dmindepvars' `dm`tmvar'_`tsop''
		}
		local depvar `dmdepvar'
		local indepvars `dmindepvars'
		local dmeanmsg "Cross-sectional means removed"
	}

	tempvar resd err_resd adf_err_resd
	tempname L11
/**Fit panel cointegration regression and obtain residuals**/
	qui gen `resd' = .
	mata: getresd(st_data(.,"`panelvar' `depvar' `indepvars'","`touse'"),"","cmpresd")

/**Fit panel regression for the differenced series and obtain LRcov**/
	markout `touse' d.(`depvar' `indepvars')
	qui count if `touse'
	local Ntotal = r(N)
	local T = r(N)/`N'
	mata: getresd(st_data(.,"`panelvar' d.(`depvar' `indepvars')","`touse'"), "cmplrcov", "", "`hac_kernel'", `hac_lags')
	mat `L11' = r(L11)

	mata: getresd(st_data(.,"`panelvar' `resd' l.`resd'","`touse'"),"cmplrcov", "cmpresd", "`hac_kernel'", `hac_lags')
	local haclagsel `r(lags)'

/**Panel nu statistics**/
	if (`"`archk'"'=="same") {
		mata: pedstats(st_data(.,"`panelvar' l.`resd'","`touse'"),"panelnu")
		local panelnu = r(panelnu)
		mata: pedstats(st_data(.,"`panelvar' l.`resd' d.`resd'","`touse'"), "panelrho")
		local panelrho = r(panelrho)
		mata: pedstats(st_data(.,"`panelvar' l.`resd' d.`resd'","`touse'"), "paneltpp")
		local paneltpp = r(paneltpp)
	}
	if (`"`archk'"'=="panels") {
		mata: pedstats(st_data(.,"`panelvar' l.`resd' d.`resd'","`touse'"), "grouprho")
		local grouprho = r(grouprho)
		mata: pedstats(st_data(.,"`panelvar' l.`resd' d.`resd'","`touse'"), "grouptpp")
		local grouptpp = r(gstatval)
	}

/**Lag selection for ADF regression**/
	if ("`adf_lagsel'"!="") {
		tempname mscrit allmat adflagmat tmplrcovmat tmpccovmat
		mat `mscrit' = J(`maxadf_lags',2,.)
		mat `tmplrcovmat' = J(`N',1,.)
		mat `tmpccovmat' = J(`N',1,.)
		forvalues i= `maxadf_lags'(-1)1 {
			if (`i'==`maxadf_lags') {
qui reg `resd' l.`resd' l(1/`i').D.`resd' , nocons
local samp e(sample)
			}
			else {
qui reg `resd' l.`resd' l(1/`i').D.`resd' if `samp' , nocons
			}
			qui estat ic
			mat `allmat' = r(S)
			if ("`adf_lagsel'"=="aic") mat `mscrit'[`i',1] =    ///
				(`i',`allmat'[1,5])
			else if ("`adf_lagsel'"=="bic") mat `mscrit'[`i',1] ///
				= (`i',`allmat'[1,6])
			else if ("`adf_lagsel'"=="hqic") mat `mscrit'[`i',1] ///
				= (`i',-2*`allmat'[1,3]+2*log(log(	    ///
				`allmat'[1,1]))*`allmat'[1,4])
		}

		mata: st_local("adf_lags",strofreal(select(		    ///
		st_matrix("`mscrit'")[.,1],st_matrix("`mscrit'")[.,2]:==    ///
		colmin(st_matrix("`mscrit'")[.,2]))))

	}
	markout `touse' `resd' l.`resd' l(1/`adf_lags').d.`resd'
	mata: getresd(st_data(.,"`panelvar' `resd' l.`resd' l(1/`adf_lags').d.`resd'","`touse'"), "cmplrcov", "cmpresd", "`hac_kernel'", `hac_lags')

	markout `touse' l.`resd' d.`resd'
	if (`"`archk'"'=="same") {
		mata: pedstats(st_data(.,"`panelvar' l.`resd' d.`resd'","`touse'"), "paneltadf")
	}
	else if (`"`archk'"'=="panels") {
		mata: pedstats(st_data(.,"`panelvar' l.`resd' d.`resd'","`touse'"), "grouptadf")
	}


/**Output**/
	if ("`adf_lagsel'"!="") local lagsel (chosen by `adf_lagsel')
	if ("`adf_lags'"=="1") 	local oplag lag
	else			local oplag lags
	if ("`hac_kernel'"=="bartlett") local hackernel Bartlett
	else if ("`hac_kernel'"=="parzen") local hackernel Parzen
	else if ("`hac_kernel'"=="quadraticspectral") local hackernel Quad. Spectral
	if ("`hac_lags'"=="1")	local haclags `hac_lags' lag
	else 			local haclags `hac_lags' lags
	if ("`haclagsel'"=="1")	local ophaclag lag
	else			local ophaclag lags
	cap qui confirm integer number `haclagsel'
	if (_rc!=0) local ophaclag `ophaclag' average

	if ("`demean'"!="") {
		local depvar `opdepvar'
		local indepvars `opindepvars'
	}
	di 
	di as txt "Pedroni test for cointegration"
	di in smcl as text "{hline 30}"
	di as text "Ho: No cointegration" _col(45) "Number of panels"	    ///
		 _col(68) "=" _col(69) as res %7.0g `N' 
	di as text "Ha: All panels are cointegrated" _c
	if ("`unbalanced'"!="") {
		di as txt _col(45) "Avg. number of periods" _c
	}
	else di as txt _col(45) "Number of periods" _c
	di as txt _col(68) "=" _col(69) as res %7.0g `T' 
	di
	di as txt "Cointegrating vector: " as res "Panel specific" 
	di as text "Panel means: " as res _col(23) "`panelmean'" _c
	di as text _col(45) "Kernel: " as res _col(63) "`hackernel'"   
	

	di as text "Time trend: " as res _col(23)"`timetrend'" _c
	di as txt _col(45) "Lags: " as res _col(62) %5.2f `haclagsel' _c
	if ("`hac_bsel'"=="nwest") {
		di as txt " (" as res "Newey-West" as txt ")"
		return local hac_method = "nwest"
	}
	else di 
	di as text "AR parameter: " as res _col(23) "`ar'" _c
	di as txt _col(45) "Augmented lags:" as res _col(63) "`adf_lags' " _c
	if ("`adf_lagsel'"!="") {
		di as txt "(" as res strupper("`adf_lagsel'") as txt")"
	}
	else di
	if ("`dmeanmsg'"!="") di _n as text "`dmeanmsg'"

	di in smcl as text "{hline 78}"
	di as text _col(45) "Statistic" _col(63) "p-value"
	di in smcl as text "{hline 78}"

	tempname pvalpnu pvalprho pvalptpp pvalptadf pvalgrho pvalgtpp pvalgtadf
	if (`"`archk'"'=="same") {
		scalar `pvalpnu' = 1-normal(abs(`panelnu'))
		scalar `pvalprho' = 1-normal(abs(`panelrho'))
		scalar `pvalptpp' = 1-normal(abs(`paneltpp'))
		scalar `pvalptadf' = 1-normal(abs(`r(paneltadf)'))

		di as text _col(2) "Modified variance ratio" _c
		di as res _col(43) %10.4f `panelnu' _c	
		di as res _col(63) %6.4f `pvalpnu'

		di as text _col(2) "Modified Phillips-Perron t" _c
		di as res _col(43) %10.4f `panelrho' _c
		di as res _col(63) %6.4f `pvalprho'

		di as text _col(2) "Phillips-Perron t" _c
		di as res _col(43) %10.4f `paneltpp' _c
		di as res _col(63) %6.4f `pvalptpp'

		di as text _col(2) "Augmented Dickey-Fuller t" _c
		di as res _col(43) %10.4f r(paneltadf) _c
		di as res _col(63) %6.4f `pvalptadf'
	}
	else if (`"`archk'"'=="panels") {
		scalar `pvalgrho' = 1-normal(abs(`grouprho'))
		scalar `pvalgtpp' = 1-normal(abs(`grouptpp'))
		scalar `pvalgtadf' = 1-normal(abs(`r(gstatval)'))

		di as text _col(2) "Modified Phillips-Perron t" _c
		di as res _col(43) %10.4f `grouprho' _c
		di as res _col(63) %6.4f `pvalgrho'

		di as text _col(2) "Phillips-Perron t"	_c 
		di as res _col(43) %10.4f `grouptpp' _c
		di as res _col(63) %6.4f `pvalgtpp'

		di as text _col(2) "Augmented Dickey-Fuller t" _c
		di as res _col(43) %10.4f r(gstatval) _c
		di as res _col(63) %6.4f `pvalgtadf'
	}

	di in smcl as text "{hline 78}"

/**Return result**/
	return scalar adf_lags = `adf_lags'
	return scalar hac_lagm = `haclagsel'
	return scalar N_g = `N'
	return scalar N_t = `T'
	return scalar N = `Ntotal'
	return hidden scalar bw = r(bw)
	return local test = "pedroni"

	if ("`constant'"=="" & "`trend'"!="") {
		return local deterministics = "trend"
	}
	else if ("`constant'"=="" & "`trend'"=="") {
		return local deterministics = "constant"
	}
	return local hac_kernel = strlower("`hackernel'")
	return local adf_method = "`adf_lagsel'"
	return local demean = "`demean'"

	tempname rmat pmat
	if (`"`archk'"'=="same") {
		mat `rmat' = [`panelnu',`panelrho',`paneltpp',`r(paneltadf)']
		mat `pmat' = [`pvalpnu',`pvalprho',`pvalptpp',`pvalptadf']
		local cnames ""Panel nu" "Panel rho" "Panel t PP" "Panel t ADF""
	}
	else if (`"`archk'"'=="panels") {
		mat `rmat' = [`grouprho',`grouptpp',`r(gstatval)']
		mat `pmat' = [`pvalgrho', `pvalgtpp', `pvalgtadf']
		local cnames ""Group rho" "Group t PP" "Group t ADF""
	}

	mat colnames `rmat' = `cnames'
	mat colnames `pmat' = `cnames'
	return matrix stats = `rmat'
	return matrix p = `pmat'

end


program _westerlund, rclass
	syntax varlist(ts fv) [if] [in], [ Trend demean SOMEpanels ALLpanels]

	gettoken depvar indepvars: varlist
	local indepvars = strtrim("`indepvars'")
	local nreg = wordcount("`indepvars'")
	if (`nreg'>7) {
		di as err "{p}number of regressors may not exceed 7{p_end}"
		exit 198
	}
	foreach var of local indepvars {
		if ("`var'"=="`depvar'") {
			di as err "{p}may not specify dependent variable as "
			di as err "one of the regressors{p_end}"
			exit 198
		}
	}
	if ("`indepvars'"=="") {
		di as err "{p}at least one regressor must be specified{p_end}"
		exit 198
	}

	if ("`noconstant'" != "" & "`trend'" != "") {
		di as err "{p}cannot specify both {bf:noconstant} and "
		di as err "{bf:trend}{p_end}"
		exit 198
	}
	if ("`trend'"=="") local type 2
	else local type 3
	if (`"`somepanels'"'=="" & `"`allpanels'"'=="" | `"`somepanels'"'!="") {
		local whichtest somep
		local ar "Panel specific"
	}
	else if (`"`allpanels'"'!="") {
		local whichtest allp
		local ar "Same" 
	}
	opts_exclusive "`somepanels' `allpanels'"


	marksample touse
	_xt, trequired
	cap xtset
	tempname usrdelta
	local panelvar `r(panelvar)'
	local timevar `r(timevar)'
	scalar `usrdelta' = `r(tdelta)'
	local usrformat `r(tsfmt)'
	qui xtsum `panelvar' if `touse'
	local N `r(n)'
	qui count if `touse'
	local Ntotal = r(N)
	local T = r(N)/`N'		/*balanced panel*/



	/**check for strongly balanced sample**/
	qui _xtstrbal `panelvar' `timevar' `touse'
	if "`r(strbal)'" != "yes" {
		local unbalanced unbalanced
	}

	/**check for gaps**/
	cap bys `panelvar' (`timevar'): assert D.`timevar' == `usrdelta'    ///
		if `touse' & _n > 1
	if c(rc) {
		di as error "{p}Westerlund test does not allow gaps in data{p_end}"
		exit 498
	}
	/**remove cross-sectional averages for each time period**/
	if "`demean'" != "" {
		local opdepvar `depvar'
		local opindepvars `indepvars'
        	tempvar dmdepvar 
		_xturdemean `dmdepvar' : `depvar' `timevar' `touse'
		foreach var of local indepvars {
			_ms_parse_parts `var'
			local tmvar `r(name)'
			local tsop `r(ts_op)'
			tempvar dm`tmvar'_`tsop'
			_xturdemean `dm`tmvar'_`tsop'' : `var' `timevar' `touse'
			local dmindepvars `dmindepvars' `dm`tmvar'_`tsop''
		}
		local depvar `dmdepvar'
		local indepvars `dmindepvars'
		local dmeanmsg "Cross-sectional means removed"
	}

	tempvar resd
	qui gen `resd' = .
	mata: getresd(st_data(.,"`panelvar' `depvar' `indepvars'","`touse'"),"","cmpresd")
	mata: weststats(st_data(.,"`panelvar' `resd'","`touse'"))

/**Output**/
	if ("`constant'"=="") 	local panelmean Included
	else			local panelmean Not included
	if ("`trend'"=="")	local timetrend Not included
	else			local timetrend Included

	if ("`demean'"!="") {
		local depvar `opdepvar'
		local indepvars `opindepvars'
	}
	di 
	di as txt "Westerlund test for cointegration"
	di in smcl as text "{hline 33}"
	di as text "Ho: No cointegration" _col(45) "Number of panels"	    ///
		 _col(68) "=" _col(69) as res %7.0g `N' 
	if (`"`whichtest'"'=="allp") {
		di as text "Ha: All panels are cointegrated" _c
	}
	else if (`"`whichtest'"'=="somep") {
		di as text "Ha: Some panels are cointegrated" _c
	}

	if ("`unbalanced'"!="") {
		di as txt _col(45) "Avg. number of periods" _c
	}
	else di as txt _col(45) "Number of periods" _c
	di as txt _col(68) "=" _col(69) as res %7.0g `T' 
	di
	di as txt "Cointegrating vector: " as res "Panel specific" 
	di as text "Panel means: " as res _col(23) "`panelmean'" 
	di as text "Time trend: " as res _col(23)"`timetrend'"
	di as text "AR parameter: " as res _col(23) "`ar'"
	if ("`dmeanmsg'"!="") di _n as text "`dmeanmsg'"

	di in smcl as text "{hline 78}"
	di as text _col(45) "Statistic" _col(63) "p-value"
	di in smcl as text "{hline 78}"

	tempname pvalvrp pvalvrg 
	if (`"`whichtest'"'=="allp") {
		scalar `pvalvrp' = 1-normal(abs(r(VRp)))
		di as text _col(2) "Variance ratio" _c
		di as res _col(43) %10.4f r(VRp) _c
		di as res _col(63) %6.4f `pvalvrp' 
	}
	else if (`"`whichtest'"'=="somep") {
		scalar `pvalvrg' = 1-normal(abs(r(VRg)))
		di as text _col(2) "Variance ratio" _c
		di as res _col(43) %10.4f r(VRg) _c
		di as res _col(63) %6.4f `pvalvrg'
	}

	di in smcl as text "{hline 78}"

/**Return result**/
	return scalar N_g = `N'
	return scalar N_t = `T'
	return scalar N = `Ntotal'
	return local test = "westerlund"
	if ("`constant'"=="" & "`trend'"!="") {
		return local deterministics = "trend"
	}
	else if ("`constant'"=="" & "`trend'"=="") {
		return local deterministics = "constant"
	}
	return local demean = "`demean'"

	tempname rmat pmat
	if (`"`whichtest'"'=="somep") {
		return scalar stat = r(VRg)
		return scalar p = `pvalvrg'
	}
	else if (`"`whichtest'"'=="allp") {
		return scalar stat = r(VRp)
		return scalar p = `pvalvrp'
	}

end
