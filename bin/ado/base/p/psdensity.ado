*! version 1.0.5  27feb2019
program define psdensity
	version 12

	syntax newvarlist(min=2 max=2) [if][in] [, PSPECTrum ///
			range(passthru) CYCle(string) SMEMory ]

	if "`e(cmd)'"!="ucm" & "`e(cmd)'"!="arima" & "`e(cmd)'"!="arfima" {
		di as err "{p}{bf:arfima}, {bf:arima}, or {bf:ucm} estimation"
		di as err "results not found{p_end}"
		exit 301
	} 
	local type : word 1 of `typlist'

	gettoken dvar avar : varlist

	local maxd = 1
	if "`cycle'" != "" {
		if "`e(cmd)'" != "ucm" {
			di as err "{p}option {bf:cycle(#)} is not allowed " ///
			 "after {bf:`e(cmd)'}{p_end}"
			exit 322
		}
	}
	if "`smemory'" != "" {
		if "`e(cmd)'" == "ucm" {
			di as err "{p}option {bf:smemory} is not allowed " ///
			 "after {bf:ucm}{p_end}"
			exit 322
		}
		if "`e(cmd)'" == "arima" {
			di as txt "{p 0 6 2}note: option {bf:smemory} has " ///
			 "no effect; {bf:arima} models have short memory{p_end}"
		}
	}
	if "`e(cmd)'" == "ucm" {
		if !e(k_cycles) {
			di as err "{p}cycle spectral density cannot be " ///
			 "computed; the {bf:ucm} model has no cycles{p_end}"
			exit 322
		} 
		local ncycles = e(k_cycles)
		if ("`cycle'"=="") local cycle = 1
		else {
			cap confirm integer number `cycle'
			if c(rc) {
				di as err "{p}{bf:cycle(`cycle')} must be " ///
				 "the cycle number, an integer{p_end}"
				exit 7
			}	
		}
		if `cycle'<1 | `cycle'>`ncycles' {
			di as err "{p}{bf:cycle(`cycle')} is invalid;  " ///
			 "the model has `ncycles' cycles{p_end}"
			exit 498
		}
	}
	ParseRange, `range'
	local r1 = `r(r1)'
	local r2 = `r(r2)'

	marksample touse, novarlist

	qui count if `touse'
	local N = r(N)
	if (!`N') error 2000
	if (`N'<2) error 2001

	if "`e(cmd)'" == "ucm" {
		UCMSpectralDensity `type' `avar' `dvar', touse(`touse') ///
			range(`r1' `r2') cycle(`cycle') `pspectrum'
		exit
	}
	/* arima or arfima						*/
	tempvar av s1
	tempname b bi

	local version = cond(missing(e(version)),1,e(version))

	mat `b' = e(b)

	qui gen double `s1' = .
	qui gen double `av' = .

	if ("`e(cmd)'"=="arfima") local name ARFIMA
	else local name ARMA

	mata: get_arma()
	local ar `ar'
	local ma `ma'

	local ps = ("`pspectrum'"!="")
	if "`e(cmd)'" == "arfima" {
		cap local d = [ARFIMA]_b[d]
		if c(rc) {
			local d = 0.0
			if "`smemory'" != "" {
				di as txt "{p 0 6 2}note: option "  ///
				 "{bf:smemory} has no effect; the " ///
				 "fractional difference parameter is 0{p_end}"
				local d = 0.0
			}
		}
		else if ("`smemory'"!="") local d = 0.0

		if (!(`d')) local smtext short-memory
		else local smtext long-memory

		if ("`e(method)'"=="mpl") local v = e(s2)
		else if `version' < 2 {
			local v = [sigma2]_b[_cons]
		}
		else {
			local v = [/]_b[sigma2]
		}
		cap noi mata: st_store(.,("`s1'","`av'"), "`touse'", ///
			arfimapsdensity(`N',`ar',`ma',`d',`v',`ps',  ///
			(`r1',`r2')))
	}
	else {
		if `version' < 2 {
			local v = [sigma]_b[_cons]^2
		}
		else {
			local v = [/]_b[sigma]^2
		}
		cap noi mata: st_store(.,("`s1'","`av'"), "`touse'", ///
			arfimapsdensity(`N',`ar',`ma',0,`v',`ps',(`r1',`r2')))
	}
	if (c(rc)) {
		/* mata-2-stata error code				*/
		if (c(rc)==3498) exit 322
		else if (c(rc)==3300) exit 322
		else exit 498
	}
	local name `=upper("`name'")'
	if "`name'" == "ARFIMA" {
		
	}
	qui gen `type' `dvar' = `s1'
	if ("`pspectrum'"!="") local label power spectrum
	else local label spectral density

	label variable `dvar' "`name' `smtext' `label'"

	qui gen `type' `avar' = `av'
	label variable `avar' "Frequency"
end

program define UCMSpectralDensity
	version 12
	syntax newvarlist, range(string) cycle(integer) touse(varname) ///
		[ PSPECTrum ]

	local type : word 1 of `typlist'

	gettoken avar dvar : varlist

	tempname b g fi ri oi vi  

	mat `g' = e(gamma)
	mat `b' = e(b)
	local version = cond(missing(e(version)),1,e(version))

	local rmin : word 1 of `range'
	local rmax : word 2 of `range'

	local ps = ("`pspectrum'"!="")

	cap scalar `fi' = _b[cycle`cycle':frequency]
	if (missing(`fi')) {
		di as err "{bf:cycle(`cycle')} does not exist"
		exit 322
	}
	if `fi' > `rmax' {
		di as txt "{p 0 6 2}note: the requested cycle is a " ///
		 "frequency that exceeds the requested {bf:range()}{p_end}"
	}
	local lbda = `fi'

	cap scalar `ri' = _b[cycle`cycle':damping]
	local rho = `ri'

	cap mat `oi' = `g'[4,"cycle`cycle':frequency"]
	local order =`oi'[1,1]

	if `ps' {
		if `version' < 2 {
			cap scalar `vi' = _b[var(cycle`cycle'):_cons]
		}
		else {
			cap scalar `vi' = [/]_b[var(cycle`cycle')]
		}
		local v `v'`=`vi''
	}
	else local v J(0,1,0)

	tempvar sd  f
	qui gen double `sd' = .
	qui gen double `f' = .

	local vars `"("`sd'","`f'")"'

	qui count if `touse'
	local N = r(N)

	cap noi mata: st_store(.,`vars',"`touse'", ///
		ucmpsdensity(`N',`rho',`lbda',`order',`v',(`rmin',`rmax')))
	
	if (c(rc)) {
		/* mata-2-stata error code				*/
		if (c(rc)==3498) exit 322
		else if (c(rc)==3300) exit 322
		else exit 498
	}
	qui gen `type' `avar' = `f'
	label variable `avar' "Frequency"

	qui gen `type' `dvar' = `sd'
	if "`pspectrum'" != "" {
		local label UCM cycle `cycle' power spectrum
	}
	else local label UCM cycle `cycle' spectral density

	label variable `dvar' "`label'"
end

program define ParseRange, rclass
	version 12
	syntax, [ range(string) ]
	
	if "`range'" == "" {
		return local r1 = 0
		return local r2 = _pi
		exit
	}
	local range0 `range'

	/* -numlist- precision loss, do not save values			*/
	syntax, range(numlist ascending min=2 max=2 >=0)

	gettoken r1 r2 : range0, parse(" ,")
	tempname val
	cap scalar `val' = `r2'
	if (c(rc)) gettoken tmp r2 : r2, parse(" ,")

	if `r2' > c(pi) {
		di as err "{p}range() invalid -- invalid numlist has " ///
		 "elements outside of allowed range{p_end}"
		exit 125
	}
	return local r1 = `r1'
	return local r2 = `r2'
end

exit
