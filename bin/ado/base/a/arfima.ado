*! version 1.1.5  06mar2019

program define arfima, eclass byable(onecall)
	local vv : display "version " _caller() ":"
	version 12

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if replay() {
		if ("`e(cmd)'"!="arfima") error 301

		Replay `0'
		exit
	}
	`vv' `BY' Estimate `0'
end

program define Estimate, eclass byable(recall) sortpreserve
	local version = string(_caller())
	local vv "version `version':"
	version 12

	syntax varlist(numeric fv ts) [if][in], [ 	///
			noCONStant			///
			ar(numlist integer>0 max=10 sort)	///
			ma(numlist integer>0 max=10 sort)	///
			SMEMory				///
			CONSTraints(numlist integer >=1 <=1999)	///
			COLlinear			///
			from(string)			///
			noARIMA				///
			debug				///
			INITSample(real 0.1)		///
			mpl MLe				///
			* ]

	/* undocumented options: 					*/
	/*	noARIMA - do not use -arima- in computing initial	*/
	/* 	  	  estimates					*/
	/*	INITSample - sampling fraction for Geweke & 		*/
	/* 		     Porter-Hudak method for estimating d	*/
	/*      debug	- debug displays				*/

        local cmdline `"arfima `:list retokenize 0'"'

	gettoken depvar indep : varlist

	_fv_check_depvar `depvar'
 
	/* get optimize options						*/
	_parse_optimize_options, `options'
	local mlopt `s(mlopts)'

	if  "`s(tech1)'"=="bhhh" | "`s(tech2)'"=="bhhh" {
		di as err "{bf:technique(bhhh)} is not allowed"
		exit 198
	}
	_get_diopts diopts rest, `s(rest)'
	if "`rest'" != "" {
		local wc: word count `s(rest)'
		di as err `"{p} `=plural(`wc',"option")' {bf:`s(rest)'} "' ///
		 `"`=plural(`wc',"is","are")' not allowed{p_end}"'
		exit 198
	}
	local k: word count `mpl' `mle'
	if `k' == 2 {
		di as err "options {bf:mpl} and {bf:mle} may not be combined"
		exit 184
	}
	if (!`k') local method mle
	else local method `mpl'`mle'

	if "`method'"=="mpl" & "`s(vce)'"=="robust" {
		di as err "{p}options {bf:mpl} and {bf:vce(robust)} may " ///
		 "not be combined{p_end}"
		exit 184
	}
	if "`method'"=="mpl" & "`smemory'"!="" {
		di as err "{p}options {bf:mpl} and {bf:smemory} may not " ///
		 "be combined{p_end}"
		exit 184
	}

	marksample touse, novarlist
	qui count if `touse'
	local N = r(N)
	if (`N'==0) error 2000

	_ts tvar panvar if `touse', sort onepanel
	markout `touse' `varlist' `tvar'
	qui count if `touse'
	local N = r(N)
	if (`N'==0) error 2000

	_check_ts_gaps `tvar', touse(`touse')

	_rmdcoll `depvar' `indep' if `touse', `constant' `collinear'
	local fvindep `r(varlist)'

	tempname tmin tmax
	summarize `tvar' if `touse', meanonly
	scalar `tmax' = r(max)
	scalar `tmin' = r(min)
	local fmt : format `tvar'
	local tmins = trim(string(r(min), "`fmt'"))
	local tmaxs = trim(string(r(max), "`fmt'"))

	if "`smemory'" != "" {
		local d = 0
		local initd = 0
	}
	else {
		local d .
		local initd = 1
	}
	if "`ar'" != "" {
		local arv: subinstr local ar " " ",", all
		local arv (`arv')
	}
	else local arv J(1,0,0)

	if "`ma'" != "" {
		local mav: subinstr local ma " " ",", all
		local mav (`mav')
	}
	else local mav J(1,0,0)

	local const = ("`constant'"=="")
	local kind : word count `fvindep'
	local keq = ("`method'"=="mle")
	if !`keq' & !(`kind'+`const') {
		di as err "{p}option {bf:mpl} is not allowed when there " ///
		 "are no covariates and no constant term in the model{p_end}"
		exit 198
	}
	if `kind' {
		local `++keq'
		local eqs `depvar'
		foreach var in `fvindep' {
			local namesb `namesb' `depvar':`var'
		}
	} 
	if `const' {
		local keq = `keq' + (!`kind')

		local namesb `namesb' `depvar':_cons
		if ("`arima'"=="") local inames `depvar':_cons
	}
	if "`ar'"!="" | "`ma'"!="" | `d' {
		local `++keq'
		local eqs `eqs' ARFIMA
	}
	foreach i in `ar' {
		local names `names' ARFIMA:L`i'.ar
	}
	foreach i in `ma' {
		local names `names' ARFIMA:L`i'.ma
	}
	if ("`arima'"=="") local inames `inames' `names'
	if (`d') local names `names' ARFIMA:d 

	if `:word count `names'' > 0 {
		Constraints, constraints(`constraints') names(`names') cap
		if `e(ncns)' {
			tempname T1 a1 C1
			mat `T1' = e(T)
			mat `a1' = e(a)
			mat `C1' = e(C)
		}
	}
	if ("`method'"=="mle") {
		if `version' < 16 {
			local names `names' sigma2:_cons
		}
		else {
			local names `names' /:sigma2
		}
	}
	if ("`arima'"=="") {
		if `version' < 16 {
			local inames `inames' sigma2:_cons
		}
		else {
			local inames `inames' /:sigma2
		}
	}
	local names `namesb' `names'
	Constraints, constraints(`constraints') names(`names') 
	if `e(ncns)' {
		tempname T a C
		mat `T' = e(T)
		mat `a' = e(a)
		mat `C' = e(C)
	}
	local csropt ("`C'","`T'","`a'"\"`C1'","`T1'","`a1'")

	if "`from'" != "" {
		cap mat li `from'
		if c(rc) {
			di as err "{bf:from(`from')} must be a row vector"
			exit 198
		}
		local from ("`from'","user")
	}
	else if "`arima'" == "" {
		/* use -arima- for initial estimates			*/
		if ("`debug'"!="") local cap cap noi
		else local cap cap

		tempname b b0 v

		fvrevar `depvar', list
		local dep `r(varlist)'

		tempvar r z x i
		tempname d0

		if "`debug'" != "" {
			tempname g1 g2 g3
			local cap noi
			local grname name(`g1')
		}
		else {
			local cap cap 
			local nograph nograph
		}
		if `const' | `kind' {
			/* use regress in case of factor variables	*/
			/*  -arima- does not allow FV's			*/
			if `:word count `namesb'' > 0 {
				Constraints, constraints(`constraints') ///
					names(`namesb') cap
				if `e(ncns)' {
					tempname Cb
					mat `Cb' = e(C)
				}
			}
			if "`Cb'" != "" {
				`cap' cnsreg `depvar' `indep' if `touse', ///
					`constant' constraints(`Cb')
			}
			else {
				`cap' regress `depvar' `indep' if `touse', ///
					`constant'
			}
			mat `b0' = e(b)

			qui predict double `r' if `touse', residuals
			if "`debug'" != "" {
				tempvar r0
				qui gen double `r0' = `r'
				label variable `r0' "residuals"
			}
		}
		else qui gen double `r' = `depvar' if `touse'

		if `initd' {
			/* estimate d using Geweke & Porter-Hudak 	*/
			/*  method					*/
			pergram `r' if `touse', gen(`z') `grname' `nograph'

			qui gen long `i' = sum(`touse')
			local N = `i'[_N]
			qui replace `i' = ((1<`i' & ///
				`i'<=max(ceil(`initsample'*`N'),11)) & `touse')
			qui count if `i'
			local n = r(N)

			qui replace `z' = log(`z') if `i'
			qui gen double `x' = log((2*sin(c(pi)*_n/_N))^2) if `i'

			if ("`debug'"!="") scatter `z' `x' if `i', name(`g2')

			`cap' regress `z' `x' if `i'

			local d = -_b[`x']

			if (`d'>0.49) local d = 0.4
			if (`d'<-0.49) local d = -0.4

			mata: st_store(.,"`r'","`touse'",fracdiff( ///
				st_data(.,"`r'","`touse'"),`d'))

			if "`debug'" != "" {
				label variable `r' "power difference"
				tsline `r' `r0' `depvar' if `touse', name(`g3')
			}
		}
		if `:word count `inames'' {
			Constraints, constraints(`constraints') ///
				names(`inames') cap
			if `e(ncns)' {
				tempname Ci
				mat `Ci' = e(C)
				local csnopt constraints(`Ci')
			}
		}
		if ("`ma'"!="") local maopt ma(`ma')
		if ("`ar'"!="") local aropt ar(`ar')

		`cap' arima `r' if `touse', `aropt' `maopt' iter(10) ///
			`csnopt' tech(bhhh) 

		if c(rc) {
			/* should not happen				*/
			di as err "{p}initial estimates from {bf:arima} "  ///
			 "failed; use the {bf:from()} option to provide " ///
			 "initial estimates{p_end}"
			exit 498
		}
		mat `b' = e(b)

		if "`ar'"!="" | "`ma'"!="" {
			mat `b0' = (nullmat(`b0'),`b'[.,"ARMA:"])
		}
		if (`d'!=0) mat `b0' = (nullmat(`b0'),`d')

		if "`method'" == "mle" {
			scalar `v' = [sigma]_b[_cons]
			scalar `v' = `v'*`v'

			mat `b0' = (nullmat(`b0'),`v')
		}
		local from ("`b0'","arima")
		if ("`debug'"!="") mat li `b0', title("initial estimates")
	}
	else local from J(1,0,"")
	
	cap noi mata: _arfima_entry("`depvar'","`fvindep'","`touse'",     ///
			`const', `arv',`mav',`d',`mlopt',`from',`csropt', ///
			"`method'")
	local rc = c(rc)
	if (`rc') exit `rc'

	tempname b V rank Vmb ll conv ilog rc gr v ic
	mat `b' = r(b)
	local k = colsof(`b')
	mat `V' = r(V)
	scalar `rank' = r(rank)
	mat `Vmb' = r(V_modelbased)
	scalar `conv' = r(converged)
	mat `ilog' = r(ilog)
	local tech `r(technique)'
	local tech_steps `r(tech_steps)'
	local crittype `r(crittype)'
	local vcetype `r(vcetype)'
	local vce `r(vce)'
	local method `r(method)'
	mat `gr' = r(gradient)
	scalar `rc' = r(rc)
	scalar `ll' = r(ll)
	scalar `v' = r(v)
	scalar `ic' = r(ic)

	`vv' ///
	mat colnames `b' = `names'
	mat rownames `b' = `depvar'
	`vv' ///
	mat colnames `V' = `names'
	`vv' ///
	mat rownames `V' = `names'
	`vv' ///
	mat colnames `Vmb' = `names'
	`vv' ///
	mat rownames `Vmb' = `names'

	ereturn post `b' `V' `C', depname(`depvar') obs(`N') ///
		esample(`touse') buildfvinfo

	ereturn hidden scalar version = cond(`version'<16,1,2)

	local dfm = 0
	foreach eq of local eqs {
		qui test [`eq'], `accum'
		local dfm = r(df)
		local accum accum
	}
	ereturn scalar p = r(p)
	ereturn scalar df_m = `dfm'
	ereturn scalar chi2 = r(chi2)
	ereturn local chi2type Wald

	ereturn matrix V_modelbased = `Vmb'
	ereturn local vcetype `vcetype'
	ereturn local vce `vce'
	ereturn scalar constant = ("`constant'"=="")
	ereturn scalar rank = `rank'
	ereturn scalar converged = `conv'
	ereturn scalar ic = `ic'
	ereturn scalar ll = `ll'
	if "`mpl'" != "" {
		ereturn hidden local crittype Log modified profile likelihood
	}
	else if "`vce'"=="robust" {
		ereturn hidden local crittype Log pseudolikelihood
	}
	else ereturn hidden local crittype Log likelihood

	ereturn local method "`method'"
	if ("`method'"=="mpl") ereturn scalar s2 = `v'

	ereturn matrix ilog = `ilog'
	ereturn local technique `tech'
	ereturn local tech_steps `tech_steps'
	ereturn scalar rc = `rc'

	if "`ar'" != "" { 
		local ar_max : word `:word count `ar'' of `ar'
		ereturn local ar `ar'
	}
	else local ar_max = 0

	ereturn scalar ar_max = `ar_max'

	if "`ma'" != "" {
		local ma_max : word `:word count `ma'' of `ma'
		ereturn local ma `ma'
	}
	else local ma_max = 0

	if "`mpl'" != "" {
		/* idiosyncratic error variance, e(s2), is not in e(b)	*/
		ereturn local marginsnotok _ALL
	}
	else {
		ereturn local marginsok default xb
		ereturn local marginsnotok residuals rstandard fdifference
	}
	ereturn matrix gradient = `gr'
	ereturn scalar ma_max = `ma_max'
	ereturn scalar tmax = `tmax'
	ereturn scalar tmin = `tmin'
	ereturn local tmins `tmins'
	ereturn local tmaxs `tmaxs'
	ereturn scalar k_eq = `keq'
	tempname pb
	_b_pclass PCDEF : default
	if "`method'" == "mle" {
		_b_pclass PCVAL : VAR
		if `version' < 16 {
			ereturn scalar k_aux = 1
		}
		else {
			ereturn hidden scalar k_var = 1
		}
		if `k' > 1 {
			mat `pb' = (J(1,`k'-1,`PCDEF'),`PCVAL')
		}
		else mat `pb' = J(1,1,`PCVAL')
	}
	else {
		if `version' < 16 {
			ereturn scalar k_aux = 0
		}
		else {
			ereturn hidden scalar k_var = 0
		}
		mat `pb' = J(1,`k',`PCDEF')
	}
	mat colnames `pb' = `names'
	ereturn hidden matrix b_pclass = `pb'
	ereturn scalar k = `k'
	ereturn local eqnames `eqs'

	if (`kind') ereturn local covariates `fvindep'
	else ereturn local covariates _NONE

	ereturn local tvar `tvar'
	qui tsset
	ereturn hidden local tsfmt = r(tsfmt)
	ereturn hidden local timevar = r(timevar)
	ereturn local depvar `depvar'
	ereturn local predict arfima_p
	ereturn local estat_cmd arfima_estat
	ereturn local title ARFIMA regression
	ereturn local cmdline `cmdline'
	ereturn local cmd arfima

	Replay, `diopts'
end

program define Replay
	version 12
	syntax, [ * ]

	/* throw any parsing errors before printing header		*/
	_get_diopts diopts rest, `options'

	local ever = cond(missing(e(version)),1,e(version))
	if "`rest'" != "" {
		if `:word count `rest'' > 1 {
			di as err "{p}options {bf:`rest'} are not " ///
			 "allowed{p_end}"
		}
		else  di as err "{p}option {bf:`rest'} is not allowed{p_end}"

		exit 198
	}

	if (e(df_m)==0) _coef_table_header, nomodeltest
	else _coef_table_header

	_coef_table, `diopts'

	local kvar = cond(`ever'==1,e(k_aux),e(k_var))
	if `kvar' {
		di as smcl "{p 0 6 0 79}" ///
		 "Note: The test of the variance against " ///
		 "zero is one sided, and the two-sided confidence interval " ///
		 "is truncated at zero.{p_end}"
	}
	if !e(converged) di as smcl "Note: Convergence not achieved."

end

program define Constraints, eclass
	version 12
	syntax, names(string) [ constraints(numlist)  cap ]

	if "`constraints'" == "" {
		ereturn local ncns = 0
		exit
	}
	local k: word count `names'
	tempname b V
	mat `b' = J(1,`k',1)
	mat `V' = `b''*`b'

	mat colnames `b' = `names'
	mat colnames `V' = `names'
	mat rownames `V' =  `names'

	ereturn post `b' `V'

	`cap' makecns `constraints' 

	local k_autoCns = r(k_autoCns)
	local ncns = 0
	if "`constraints'"!="" | `k_autoCns' {
		tempname T a C
		cap matcproc `T' `a' `C'
		if c(rc) {
			/* all constraints were dropped in makecns	*/
			local C
			local T
			local a
		}
		else {
			local ncns = rowsof(`C')
			ereturn matrix C = `C'
			ereturn matrix a = `a'
			ereturn matrix T = `T'
		}	
	}
	ereturn local ncns = `ncns'
end

exit
