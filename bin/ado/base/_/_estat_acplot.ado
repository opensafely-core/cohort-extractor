*! version 1.0.4  11feb2019
program define _estat_acplot
	version 13
	preserve

	qui count
	local N = r(N)
	if (!`N') error 2000
	if (`N'<2) error 2001
	local T = max(2, min(floor(`N'/2)-2,40))

	local acopts Level(cilevel) 			///
		LAGs(integer `T')			///
		COVariance				///
		SMEMory					///
		SAving(string)				///
		LEGend(string asis)			///
		by(string asis)

	local gropts * 

	syntax [, `acopts' `gropts' ]
	if "`saving'" != "" {
		Parsesaving `saving'
		local double `s(double)'
		local filename `s(filename)'
		local stub `s(name)'
		local replace `s(replace)'
	}
	_get_gropts, graphopts(`options') ///
		getallowed(CIOPts)
	local options `"`s(graphopts)'"'
	local ciopts `"`s(ciopts)'"'
	if ("`by'" != "") {
		di as error "option {bf:by()} not allowed"
		exit 198
	}
	if ("`legend'" == "") {
		local legend legend(off)
	}
	else {
		local legend legend(`legend')
	}
	_check4gropts ciopts, opt(`ciopts')
	
	capture drop `stub'lag
	capture drop `stub'ac
	capture drop `stub'se
	capture drop `stub'ci_l 
	capture drop `stub'ci_u
	local ac `stub'ac
	confirm new variable `ac'
	local se `stub'se
	confirm new variable `se'
	local lo `stub'ci_l
	confirm new variable `lo'
	local hi `stub'ci_u
	confirm new variable `hi'
	
	if `lags' > `N' qui set obs `lags'
	
	if "`covariance'"=="" local stat correlation
	else local stat covariance
	
	local cmd `e(cmd)'
	if "`cmd'"=="arch" local cmd arima
	
	if "`cmd'"!="arima" & "`cmd'"!="arfima" {
		di "{err}{bf:estat acplot} can only be run after " ///
			"{bf:arima} or {bf:arfima}"
		exit 198
	}
	
	if "`cmd'"=="arima" & "`smemory'"=="smemory" {
		di "{err}option {bf:smemory} not allowed after {bf:arima}"
		exit 198
	}
	
	if `lags'<1 {
		di as error "{bf:lags()} must specify an integer greater " ///
			"than or equal to 1"
	    	exit 198
	}

	tempname b V
	_acf_getb
	mat `b' = r(b)
	mat `V' = r(V)
	local mult `r(mult)'
	
	local names : colfullnames `b'
	local hasd _acf_:d
	local hasd : list hasd in names
	local hasd = `hasd'
	if (`hasd') local diff = _b[ARFIMA:d]
	
	local version = cond(missing(e(version)),1,e(version))

	if "`cmd'"=="arima" local sigma2 = _b[sigma:_cons]^2
	else if `version' < 2 local sigma2 = _b[sigma2:_cons]
	else  local sigma2 = _b[/sigma2]

	
	if "`smemory'"!="" {
		local hasd 0
		local cmd arima
	}

	qui gen `double' `ac' = .
	label var `ac' "Auto`stat's"
	qui gen `double' `se' = .
	label var `se' "Std. error of auto`stat's: `ac'"
	noi capture mata: _acf`mult'("`b'","`V'")
	local rc = _rc
	if `rc' {
		exit `rc'
	}
	local tvar = `"`_dta[_TStvar]'"'
	qui gen `c(obs_t)' `stub'lag = _n if !missing(`ac')
	local lag `stub'lag
	local tf: format `tvar'
	local switch = usubstr("`tf'",3,1)
	if ("`switch'" == "t") {
		local switch = usubstr("`tf'",4,1)
	}
	if ("`switch'" == "d") {
		label var `lag' "daily lag"
	}
	else if ("`switch'" == "w") {
		label var `lag' "weekly lag"
	}
	else if ("`switch'" == "m") {
		label var `lag' "monthly lag"
	}
	else if ("`switch'" == "q") {
		label var `lag' "quarterly lag"
	}
	else if ("`switch'" == "h") {
		label var `lag' "half-yearly lag"
	}
	else if ("`switch'" == "y") {
		label var `lag' "yearly lag"
	}

	qui gen `double' `lo' = `ac' - invnorm((100+`level')/200)*`se' ///
		if !missing(`ac')
	qui gen `double' `hi' = `ac' + invnorm((100+`level')/200)*`se' ///
		if !missing(`ac')
	label var `lo' `"`=strsubdp("`level'")'% lower bound: `ac'"'
	label var `hi' `"`=strsubdp("`level'")'% upper bound: `ac'"'

	local f: variable label `ac'
	local lcf = lower(`"`f'"')
	local abbrev = abbrev("`e(depvar)'",12)
	qui keep if !missing(`ac')

	graph twoway	(rcap `lo' `hi' `lag'		///
				,			///
				pstyle(p1)		///
				`ciopts'		///
			)				///
			(connected `ac' `lag' 		///
				if !missing(`ac')	///
				,			///
				ytitle("`f'") 		///
			title(`"Parametric `lcf' of `abbrev'"' /// 
				`"with `level'% confidence intervals"') ///
				pstyle(p1)		///
				`legend'		///
				`options'		///
			)				
	if ("`saving'" != "") {
		keep `lag' `ac' `se' `lo' `hi'
		order `lag' `ac' `se' `lo' `hi'
		qui compress
		save `filename', `replace'
	}

	restore
end

program _acf_getb, rclass

	local cmd `e(cmd)'
	if "`cmd'"=="arch" local cmd arima
	
	tempname b V bAR bMA
	
	local version = cond(missing(e(version)),1,e(version))
	if "`e(mar1)'`e(mma1)'"!= "" { // multiplicative ARIMA
		
		local eq `e(eqnames)'
		mat `b' = e(b)
		mat `V' = e(V)
		
		foreach s in `e(seasons)' {
			local eq : subinstr local eq "AR`s'_terms" "_acf_", all
			local eq : subinstr local eq "MA`s'_terms" "_acf_", all
		}
		
		local eq : subinstr local eq "SIGMA" "_acf_", all
				
		mat coleq `b' = `eq'
		mat `b' = `b'[1,"_acf_:"]
		
		mat roweq `V' = `eq'
		mat coleq `V' = `eq'
		mat `V' = `V'["_acf_:","_acf_:"]
		
		return local mult _mult
	}
	else { // ARFIMA or additive ARIMA
		
		mat `b' = e(b)
		mat `V' = e(V)
		local eq : coleq `b'
		
		local eq : subinstr local eq "ARMA" "_acf_", all
		local eq : subinstr local eq "ARFIMA" "_acf_", all
		if `version' < 2 {
			local eq : subinstr local eq "sigma" "_acf_", all word
			local eq : subinstr local eq "sigma2" "_acf_", all word
		}
		else {
			local eq : subinstr local eq "/" "_acf_", all word
		}
		
		mat coleq `b' = `eq'
		mat roweq `V' = `eq'
		mat coleq `V' = `eq'
		
		mat `b' = `b'[1,"_acf_:"]
		mat `V' = `V'["_acf_:","_acf_:"]
	}
	
	return matrix b = `b'
	return matrix V = `V'

end

program Parsesaving, sclass
        capture noisily                                 ///
        syntax anything(id="file name" name=fname) [,   ///
                DOUBle                                  ///
                name(string)				///
                REPLACE                                 ///
        ]
        local rc = `c(rc)'
        if `rc' {
                di as err "invalid saving() option"
                exit `rc'
        }
        sreturn local filename  `"`fname'"'
        sreturn local double    `"`double'"'
        sreturn local replace   `"`replace'"'
	sreturn local name `"`name'"'
end

exit
