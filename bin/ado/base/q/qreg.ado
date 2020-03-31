*! version 4.4.1  17sep2019
program qreg, eclass byable(onecall) prop(sw mi)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if replay() {
		if ("`BY'"!="") error 190
		if ("`e(cmd)'"!="qreg") error 301
		Replay `0'
		exit
	}
	local vv : di "version " string(_caller()) ":"

	`vv' `BY' Estimate `0'
end

program Estimate, eclass byable(recall) sort prop(sw mi)
	local vc = _caller()
	local cmdline : copy local 0
	version 13, missing

	if `vc' <= 12 {
		syntax varlist(numeric fv) [fw aw] [if] [in] [,		///
				Quantile(real 0.5) WLSiter(integer 1)	///
				NOLOg LOg Level(cilevel) * ]
	}
	else {
		syntax varlist(numeric fv) [fw iw pw] [if] [in] [,	///
				Quantile(real 0.5) WLSiter(integer 1)	///
				vce(string) NOLOg LOg Level(cilevel) * ]
	}
	_get_diopts diopts options, `options'
	local fvops = ("`s(fvops)'"=="true" | `vc'>12)

	OptimizeParse opopts options, `options'
	if "`options'" != "" {
		local k : word count `options'
		local options : list retokenize options
		local options : subinstr local options " " ", "
		di as err "{p}" plural(`k',"option") " {bf:`options'} " ///
		 plural(`k',"is","are") " not allowed{p_end}"
		exit 198
	}
	local quant = `quantile'
	if (`quant'>=1) local quant = `quant'/100

	if `quant' <= 0 | `quant' >= 1 {
		di as err "{bf:quantile(`quantile')} is out of range"
		exit 198
	}
	if `wlsiter' < 1 { 
		di as err "{p}{bf:wlsiter(`wlsiter')} must be a positive " ///
		 "integer{p_end}"
		exit 198 
	}
	if "`weight'" != "" {
		local wweight `weight'
		if ("`weight'"=="pweight") local wweight iweight

		local weights [`wweight'`exp']
	}
	VCEParse `vce'
	local vce `r(vce)'
	local bwidth `r(bwidth)'
	local method `r(method)'
	local kernel `r(kernel)'
	local clustvar `r(clustvar)'
	if ("`vce'"=="robust" | "`vce'"=="cluster") & "`method'"=="residual" {
		di as err "{p}option {bf:vce(`vce', residual)} is invalid; " ///
		 "{bf:residual} may not be specified as a suboption to "     ///
		 "{bf:vce(`vce')}{p_end}"
		exit 184
	}
	if "`vce'"=="iid" & "`weight'"=="pweight" {
		di as err "{p}option {bf:vce(iid)} is not possible with " ///
		 "pweighted data; pweights imply robust{p_end}"
		exit 404
	}
	if "`vce'" == "" {
		/* find default						*/
		if "`weight'" == "pweight" {
			if "`method'" == "residual" {
				di as err "{p}option {bf:vce(,residual)} " ///
				 "is not possible with pweighted data{p_end}"
				exit 404
			}
			local vce robust
		}
		else local vce iid
	}
	if ("`vce'"=="cluster" | "`vce'"=="robust") local vcetype Robust

	marksample touse
	qui count if `touse'
	local N = r(N)
	if (!`N') error 2000
	if (`N'<=2) error 2001

	gettoken dep indep : varlist

	if (`fvops') local mse1 mse1
	else local rmopt forcedrop

	_rmcoll `indep' `weights' if `touse', `rmopt'
	local indep `r(varlist)' 
	local varlist `dep' `indep'

	tempvar r i p
	qui gen `c(obs_t)' `i' = _n

	/* initial estimates via weighted least squares 		*/
	_qregwls `varlist' `weights' if `touse', r(`r') ///
		iterate(`wlsiter') quant(`quant') `log' `nolog'

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if ("`log'"!="") local qui quietly

	/* stable sort							*/
	sort `r' `i'
	drop `r'

	`qui' _qreg `varlist' if `touse' `weights', quant(`quant') `opopts'
	if r(convcode) != 1 { 
		di as err "convergence not achieved." 
		local rc = 430
	}
	else local rc = 0

	tempname b f_r rq rsd msd sum_w tol

	mat `b' = e(b)
	scalar `f_r' = r(f_r)
	scalar `rq' = r(q_v)
	scalar `rsd' = r(sum_rdev)
	scalar `msd' = r(sum_adev)
	scalar `sum_w' = r(sum_w)
	scalar `tol' = r(tolerance)
	if ("`weight'"=="fweight") local N = r(sum_w)

	local basis0 `"`r(basis)'"'
	foreach b0 of numlist `basis0' {
		local bi = `i' in `b0'
		local basis `basis' `bi'
	}
	drop `i'
	if "`method'" == "residual" {
		if !strlen("`basis'") {
			di as err "{p}cannot compute "                    ///
			 "{bf:vce(,residual)} because the basis numlist " ///
			 "exceeds the maximum macro length; try options " ///
			 "{bf:vce(,fitted)} or {bf:vce(,kernel()){p_end}"
			exit 123
		}
	}
	if `vc' <= 12 {
		local vce
		local vcetype

		tempvar s2
		/* old standard errors					*/
		qui _predict double `r' if `touse', resid
		qui gen double `s2' = abs(`r')
		summ `s2', meanonly
		qui replace `r' = 0 if `s2'<10e-10*r(mean)
		qui drop `s2'
		qui replace `r' = `quant' if `r'>0 & `r'<.
		qui replace `r' = (`quant' - 1) if `r'<0
		qui replace `r' = `r' / `f_r'
		qui _predict double `p' if `touse'
		qui reg `p' `indep' if `touse' [`weight'`exp'], dep(`dep') ///
			`mse1'

		local df_m = e(df_m)
		if `fvops' {
			_robust `r' [`weight'`exp'], minus(0)
			_post_vce_rank
			local df_r = r(N) - e(rank)
			ereturn local vce
			ereturn local vcetype
			ereturn local F
			ereturn local r2
			ereturn local mss
			ereturn local rss
			ereturn local rmse
			ereturn local r2_a
			ereturn local ll_0
			ereturn local ll
			ereturn local title
			ereturn local marginsok
			ereturn local model
			ereturn local estat_cmd
			ereturn local V_modelbased
		}
		else {
			local df_r = e(df_r)
			capture assert `touse'
			if _rc { 
				preserve
				qui keep if `touse'
			}
			qui gen byte `s2' = 1 if `touse'
			qui _huber `r' `s2' [`weight'`exp']
			ereturn repost, buildfvinfo
		}
	}
	else {
		/* new standard errors					*/
		if "`method'" != "fitted" | "`vce'"=="cluster" {
			qui predict double `r', residuals
			local ropt resid(`r')
		}
		_ms_eq_info
		local k = r(k1)
		_ms_omit_info e(b)
		local nparm = `k'-r(k_omit)
		local df_m = `nparm' - !el(r(omit),1,`k')

		GetVCE `dep' `indep' `weights',		///
			bwidth(`bwidth')		///
			method(`method')		///
			vce(`vce')			///
			touse(`touse')			///
			tau(`quant')			///
			level(`level')			///
			basis(`basis0')			///
			`ropt'				///
			kernel(`kernel')		///
			nparm(`nparm')			///
			clustvar(`clustvar')		///
			`opopts'

		tempname V sparsity bwidth kband
		mat `V' = r(V)
		scalar `sparsity' = r(sparsity)
		scalar `bwidth' = r(bwidth)
		local bwmeth `r(bwmeth)'
		scalar `f_r' = 1/`sparsity'

		if "`vce'" == "cluster" {
			local df_r = r(df_r)
			local N_clust = r(N_clust)
		}

		if ("`method'"=="kernel") scalar `kband' = r(kband)

		local names : colfullnames `b'
		mat rownames `V' = `names'
		mat colnames `V' = `names'

		ereturn post `b' `V', esample(`touse')

		_post_vce_rank
		local df_r = `N' - e(rank)

		ereturn local depvar `dep'
		ereturn scalar sparsity = `sparsity'
		ereturn scalar bwidth = `bwidth'
		ereturn local bwmethod "`bwmeth'"
		ereturn local denmethod "`method'"
		if "`vce'" == "cluster" {
			ereturn local clustvar `clustvar'
			ereturn scalar N_clust = `N_clust'
		}
	}
	ereturn local vce `vce'
	if "`vce'" != "iid" {
		ereturn local vcetype "`vcetype'"
	}
	if "`method'" == "kernel" {
		ereturn local kernel "`kernel'"
		ereturn scalar kbwidth = `kband'
	}	
	ereturn hidden local basis `"`basis'"'
	ereturn scalar df_m = `df_m'
	ereturn scalar df_r = `df_r'
	ereturn scalar f_r = `f_r'
	ereturn scalar N = `N'
	ereturn scalar sum_w = `sum_w'
	ereturn scalar q_v = `rq'
	ereturn scalar q = `quant'
	ereturn scalar sum_rdev = `rsd'
	ereturn scalar sum_adev = `msd'
	ereturn scalar convcode = `rc'
	ereturn hidden scalar tolerance = `tol'

	ereturn local marginsnotok stdp stddp residuals

	global S_E_mdf = `df_m'
	global S_E_tdf = `df_r'
	global S_E_rd = `f_r'
	global S_E_nobs = `N'
	global S_E_q = `quant'
	global S_E_rq = `rq'
	global S_E_rsd = `rsd'
	global S_E_msd = `msd'
	global S_E_vl "`varlist'"
	global S_E_frc = `rc'

	if "`weight'" != "" {
		ereturn local wexp = "`exp'"
		ereturn local wtype = "`weight'" 
	}
	ereturn local properties "b V"

	global S_E_cmd "qreg"
	ereturn local predict "qreg_p"
	ereturn local cmdline `"qreg `cmdline'"'
	ereturn local cmd "qreg"

	Replay, `diopts' level(`level')
end

program define Replay
	syntax [, * ]

	_get_diopts diopts options, `options'
	if "`options'" != "" {
		local k : word count `options'
		di as err "{p}" plural(`k',"option") " {bf:`options'} " ///
		 plural(`k',"is","are") " not allowed{p_end}"
		exit 198
	}
	di
	if (e(q)==0.5) { 
		di in gr "Median regression"  ///
		 _col(53) "Number of obs = " in ye %10.0gc e(N) 
	}
	else { 
		di in gr e(q) " Quantile regression" ///
		 _col(53) "Number of obs = " in ye %10.0gc e(N) 
	}
	di in gr "  Raw sum of deviations" in ye %9.0g e(sum_rdev) ///
	 in gr " (about " in ye e(q_v) in gr ")" 
	di in gr "  Min sum of deviations" in ye %9.0g e(sum_adev) _col(53) ///
	 in gr "Pseudo R2     = " in ye %10.4f 1 - (e(sum_adev)/e(sum_rdev)) _n

	_coef_table, `diopts'

	error e(convcode)
end

program define OptimizeParse, sclass
	syntax namelist(max=2) [, ITERate(passthru) NOLOg LOg trace *]

	gettoken c_opopts c_opts : namelist

	local opts `options'
	if "`iterate'" != "" {
		local 0, `iterate'
		cap syntax, iterate(integer)
		local rc = _rc
		if (!`rc') local rc = (`iterate'<=0)
		if `rc' {
			di as err "{p}{bf:iterate({it:#})} must be a " ///
			 "nonnegative integer{p_end}"
			exit 198
		}
		local iterate iterate(`iterate')
	}
	c_local `c_opopts' `iterate' `log'`nolog' `trace'
	c_local `c_opts' `"`opts'"'
end

program define VCEParse, rclass
	syntax [anything(name=vcetype id="vce type")] [, FITted RESidual ///
		residuals KERnel(string) * ]

	if "`vcetype'" != "" {
		VCETypeParse, `vcetype'
		return add
	}
	if "`residuals'" != "" {
		local residual residual
		local residuals
	}
	local k = ("`fitted'"!="") + ("`residual'"!="") + ("`kernel'"!="")
	if `k' > 1 {
		di as err "{p}invalid {bf:vce()} specification; only one " ///
		 "of {bf:fitted}, {bf:residual}, or {bf:kernel()} is "     ///
		 "allowed{p_end}"
		exit 198
	}
	if !`k' {
		/* check for kernel without option			*/
		local 0, `options'
		syntax, [ Kernel * ]
		local method `kernel'
		local kernel
	}
	if "`kernel'"!="" | "`method'"!="" {
		KernelParse, `kernel'
		/* r(kernel)						*/
		return add
		local method kernel
	}
	else local method `fitted'`residual'

	if ("`method'"=="") local method fitted

	return local method `method'

	BWidthParse, `options'
	/* r(bwidth)							*/
	return add
end

program VCETypeParse, rclass
	syntax, [ iid Robust EXCLuster * ]
	/* undocumented : excluster - cluster robust VCE (experimental)	*/

	if "`excluster'" != "" {
		local cluster cluster
		if "`options'" == "" {
			di as err "{p}invalid {bf:vce(excluster)} "      ///
			 "specification; a numeric cluster variable is " ///
			 "required{p_end}"
			exit 198
		}
		local 0 `options'
		cap syntax varname(numeric)
		if c(rc) {
			local clust excluster
			if ("`options'"!="") local clust `clust' `options'

			di as err "invalid {bf:vce(`clust')} specification;"
			syntax varname(numeric)
		}
		return local vcetype  Robust
		return local vce `cluster'
		return local clustvar `varlist'
		exit
	}
	if "`options'" != "" {
		di as err "{p}option {bf:vce(`robust'`iid' `options')} is " ///
		 "not allowed{p_end}"
		exit 198
	}
	local vce `robust' `iid' 
	local k : word count `vce'
	if `k' > 1 {
		di as err "{p}invalid {bf:vce()} specification; only one " ///
		 "of {bf:iid} or {bf:robust} is allowed{p_end}"
		exit 198
	}
	return local vce `vce'
end

program define BWidthParse, rclass
	capture syntax [, BOfinger HSheather CHamberlain ]
	if _rc {
		local 0: subinstr local 0 "," ""
		local 0: list retokenize 0
		di as err "{p}invalid {bf:vce()} specification; suboption " ///
		 "{bf:`0'} is not allowed{p_end}"
		exit 198
	}

	local cnt : word count `bofinger' `hsheather' `chamberlain'
	if `cnt' > 1 {
		di as err "{p}invalid {bf:vce()} specification; only " ///
		 "one of {bf:bofinger}, {bf:hsheather}, or "              ///
		 "{bf:chamberlain} is allowed{p_end}"
		exit 198
	}
	if (`cnt'==0) local bwidth hsheather
	else local bwidth `bofinger'`hsheather'`chamberlain'

	return local bwidth `bwidth'
end

program define KernelParse, rclass
	capture syntax [, EPanechnikov 		///
			  epan2 		///
			  BIweight 		///
			  COSine		///
		 	  GAUssian 		///
			  PARzen 		///
			  RECtangle 		///
			  TRIangle  ]
	if _rc {
		local 0: subinstr local 0 "," ""
		local 0: list retokenize 0
		di as err "{p}invalid {bf:vce()} specification; suboption " ///
		 "{bf:kernel(`0')} is not allowed{p_end}"
		exit 198
	}
	local kernel `epanechnikov' `epan2' `biweight' `cosine'	
	local kernel `kernel' `gaussian' `parzen' `rectangle' 
	local kernel `kernel' `triangle' 

	local k : word count `kernel'
	if `k' > 1 {
		di as err "{p}invalid {bf:vce(,kernel())} specification; "  ///
		 "only one of {bf:epanechnikov}, {bf:epan2}, "		    ///
		 "{bf:biweight}, {bf:cosine}, {bf:gaussian}, {bf:parzen}, " ///
		 "{bf:rectangle}, or {bf:triangle} is allowed{p_end}"
		exit 198
	}
	if (!`k') local kernel epanechnikov

	return local kernel `kernel'
end

program define GetVCE, rclass
	syntax 	varlist(numeric fv) [fw iw/],		///
			bwidth(string)			///
			method(string) 			///
			vce(string)			///
			touse(varname)			///
			tau(string)			///
			level(string)			///
			[				///
			basis(numlist)			///
			resid(varname)			///
			kernel(string) 			///
			nparm(integer 0)		///
			clustvar(string)		///
			* ]
	tempname alpha
	scalar `alpha' = 1 - `level'/100

	gettoken dep indep : varlist

	tempname J H N

	if ("`vce'"!="iid") local robust robust

	if "`weight'" != "" {
		tempvar wvar
		qui gen double `wvar' = `exp' if `touse'

		local weights [`weight'=`wvar']
		if "`weight'" == "iweight" {
			local weights2 [`weight'=`wvar'*`wvar']
		}
		else {
			local weights2 `weights'
		}
	}
	if "`vce'" != "cluster" {
		qui mat accum `J' = `indep' if `touse' `weights2'
	}
	else summarize `touse' `weights', meanonly

	if "`weight'" == "iweight" { 
		qui count if `touse'
	}
	scalar `N' = r(N)

	tempname s band m
	scalar `s' = .

	if "`method'" == "fitted" {
		VCE_fitted `varlist', n(`=`N'') tau(`tau') bwidth(`bwidth') ///
			alpha(`alpha') touse(`touse') weight(`weight')      ///
			wvar(`wvar') options(`options') `robust' `options'

		scalar `band' = r(band)

		if ("`vce'"=="iid") scalar `s' = r(s)
		else mat `H' = r(H)
	}
	else if "`method'" == "residual" {
		tempname F_l F_u
		tempvar ruse i ares

		qui gen double `ares' = abs(`resid')
		qui gen byte `ruse' = `touse'
		/* new count						*/
		if "`weight'" == "fweight" {
			foreach j of numlist `basis' {
				qui replace `wvar' = `wvar'-1 in `j'
				if (!`wvar'[`j']) qui replace `ruse' = 0 in `j'
			}
			summarize `ruse' `weights', meanonly
			scalar `N' = r(sum)
		}
		else {
			foreach j of numlist `basis' {
				qui replace `ruse' = 0 in `j'
			}
			qui count if `ruse'
			scalar `N' = r(N)
		}
		if !`N' {
			di as err "{p}no observations remain after " 	  ///
			 "dropping residuals associated with the linear " ///
			 "programming basis{p_end}"
			exit 2000
		}
		mata: _qreg_bwidth(`=`N'',`tau',"`bwidth'",`=`alpha'')
		scalar `band' = r(bwidth)

		tempname tau_l tau_u cenl cenu
		/* do not restrict (tau_l,tau_u) in (0,1); doing so	*/
		/*  produces std.errs. that are too small		*/
		scalar `tau_l' = `tau' - `band'
		scalar `tau_u' = `tau' + `band'
		if `tau_l'<0 | `tau_u'>1 {
			di as err "{p}VCE computation failed; try a "    ///
			 "different {help qreg##qreg_bwidth:bandwidth} " ///
			 "or {helpb bsqreg}{p_end}"
			exit 498
		}
		scalar `cenl' = 100*`tau_l'
		scalar `cenu' = 100*`tau_u'

		qui gen `c(obs_t)' `i' = _n
		/* stable sort						*/
		sort `ares' `i'
		drop `ares'
		drop `i'

		qui _pctile `resid' if `ruse' `weights', ///
			percentiles(`=`cenl'' `=`cenu'')

		scalar `F_l' = r(r1)   
		scalar `F_u' = r(r2)   

		scalar `s' = (`F_u'-`F_l')/(2*`band')
		if `s' <  epsdouble() {
			di as err "{p}sparsity estimate of " %10.0g `s' ///
			 " is too small; computation of coefficient "   ///
			 "standard errors cannot be completed{p_end}"
			exit 498
		}
		qui drop `ruse'
	}
	else { // "`method'" == "kernel"
		VCE_kernel, resid(`resid') touse(`touse') n(`=`N'')    ///
			tau(`tau') bwidth(`bwidth') alpha(`alpha')     ///
			kernel(`kernel') weight(`weight') wvar(`wvar') ///
			indep(`indep') `robust'

		tempname kband

		scalar `band' = r(band)	
		scalar `kband' = r(kband)

		if ("`vce'"=="iid") scalar `s' = r(s)
		else mat `H' = r(H)
	}
	tempname V
	if "`vce'" == "iid" {
		mat `J' = invsym(`J')
		mat `V' = `tau'*(1-`tau')*(`s'^2)*`J'
	}
	else if "`vce'" == "robust" {
		mat `V' = `tau'*(1-`tau')*`H'*`J'*`H'	
	}
	else { // cluster
		tempvar score ruse
		qui gen byte `ruse' = cond(abs(`resid')<1e-10,0,`touse')
		qui gen double `score' = cond(`resid'>0,-`tau',1-`tau') ///
			if `ruse'
		mat `V' = `H'

		_robust `score' `weights' if `ruse', variance(`V') ///
			cluster(`clustvar')
		/* scalars r(N_clust) and r(df_r)			*/
		return add
	}
	if ("`method'"=="kernel") return scalar kband = `kband'

	return scalar sparsity = `s'
	return matrix V = `V' 
	return scalar bwidth = `band'
	return local bwmeth "`bwidth'"
	return scalar N = `N'
end

program define KernelBWidth, rclass
	syntax, sd(name) irq(name) tau(real) h(name)

	tempname kband sr k tph tmh
	scalar `sr' = `irq'/1.34
	scalar `k' = cond(`sd'<`sr', `sd', `sr')

	scalar `tph' = `tau'+`h'
	scalar `tmh' = `tau'-`h'

	if (`tmh'<=0 |`tph'>=1) return scalar kband = .
	else return scalar kband = `k'*(invnormal(`tph')-invnormal(`tmh'))
end

program define VCE_kernel, rclass
	syntax, resid(varname) 		///
		touse(varname)		///
		n(real)			///
		tau(real)		///
		bwidth(string)		///
		alpha(name)		///
		kernel(string)		///
		[			///
		robust			///
		indep(string)		///
		weight(string)		///
		wvar(varname)		///
		]

	tempname H sd irq band kband

	if ("`weight'"!="") local weights [`weight'=`wvar']

	if "`weight'" == "iweight" {
		qui _pctile `resid' if `touse' `weights', percentiles(25 75)
		scalar `irq' = r(r2) - r(r1)	
		qui sum `resid' if `touse' `weights'
	}
	else {
		qui sum `resid' if `touse' `weights', detail
		scalar `irq' = r(p75) - r(p25)
	}
	scalar `sd'  = r(sd)

	mata: _qreg_bwidth(`n',`tau',"`bwidth'",`=`alpha'')
	scalar `band' = r(bwidth)

	KernelBWidth, sd(`sd') irq(`irq') tau(`tau') h(`band') 

	scalar `kband' = r(kband)	
	if missing(`kband') {
		di as err "{p}VCE computation failed; try a different " ///
		 "{help qreg##qreg_bwidth:bandwidth} or {helpb bsqreg}{p_end}"
		exit 498
	}
	if "`robust'" != "" {
		tempvar kvar

		qui gen double `kvar' = .
		mata: _qreg_kernel("`kernel'",`=`kband'',"`resid'", ///
				"`touse'","`wvar'","`kvar'")

		if ("`weight'"!="") local wt `wvar'*`kvar'
		else local wt `kvar'

		qui mat accum `H' = `indep' [iw=`wt'] if `touse' 
		mat `H' = invsym(`H'/`kband')
		
		return matrix H = `H'
	}
	else {
		mata: _qreg_kernel("`kernel'",`=`kband'',"`resid'", ///
			"`touse'","`wvar'")
		return add
	}
	return scalar band = `band'
	return scalar kband = `kband'
end

program define VCE_fitted, rclass
	syntax varlist(numeric fv), 	///
		n(real) 		///
		tau(real) 		///
		bwidth(string) 		///
		alpha(name)		///
		touse(varname)		///
		[			///
		weight(string)		///
		wvar(varname)		///
		options(string)		///
		robust			///
		indep(string)		///
		* ]

	gettoken dep indep : varlist

	tempname F_l F_u H tau_l tau_u s band
	tempvar  xb_l xb_u fi 

	mata: _qreg_bwidth(`n',`tau',"`bwidth'",`=`alpha'')
	scalar `band' = r(bwidth)

	/* do not restrict (tau_l,tau_u) in (0,1); doing so produces	*/
	/*  std.errs. that are too small				*/
	scalar `tau_l' = `tau' - `band' 
	scalar `tau_u' = `tau' + `band'
	if `tau_l'<=0 | `tau_u'>=1 {
		di as err "{p}VCE computation failed; try a different " ///
		 "{help qreg##qreg_bwidth:bandwidth} or {helpb bsqreg}{p_end}"
		exit 498
	}
	if ("`weight'"!="") local weights [`weight'=`wvar']

	qui _qreg `varlist' if `touse' `weights', quant(`=`tau_l'') `options'
	if r(convcode) != 1 { 
		di as err "{p}VCE computation failed; try increasing the " ///
		 "maximum number of iterations or try {helpb bsqreg}{p_end}"
		exit 498
	}
	qui predict double `xb_l' if `touse', xb

	qui _qreg `varlist' if `touse' `weights', quant(`=`tau_u'') `options'
	if r(convcode) != 1 { 
		di as err "{p}VCE computation failed; try increasing the " ///
		 "maximum number of iterations or try {helpb bsqreg}{p_end}"
		exit 498
	}
	qui predict double `xb_u' if `touse', xb

	if "`robust'" != "" {
		tempname m

		qui gen double `fi' = `xb_u'-`xb_l'
		qui replace `fi' = cond(`fi'>sqrt(c(epsdouble)), ///
			(2*`band')/`fi',0)

		if ("`weight'"!="") local wt `wvar'*`fi'
		else local wt `fi'

		qui mat accum `H' = `indep' [iw=`wt'] if `touse' 
		mat `H' = invsym(`H')

		return matrix H = `H'
	}
	else {
		sum `xb_l' if `touse' `weights', meanonly
		scalar `F_l' = r(mean)

		sum `xb_u' if `touse' `weights', meanonly
		scalar `F_u' = r(mean)

		scalar `s' = (`F_u'-`F_l')/(2*`band')

		return scalar s = `s'
	}
	return scalar band = `band'
end

mata:

void _qreg_bwidth(real scalar n,	///
		real scalar tau, 	///
		string scalar method,	/// 
		|real scalar alpha)	/// hsheather & chamberlain
{
	real scalar 	z, invtau, h

	invtau = invnormal(tau)

	if (method=="hsheather") {
		z = invnormal(1-alpha/2)
		h = (n^(-1/3))*(z^(2/3))*	///
			(1.5*normalden(invtau)^2/(2*invtau^2+1))^(1/3) 
	}
	else if (method=="bofinger") {
		h = n^(-1/5)*((4.5*normalden(invtau)^4)/(2*invtau^2+1)^2)^(1/5)
	}
	else { // (method=="chamberlain") 
		z = invnormal(1-alpha/2)
		h = z*sqrt(n^(-1)*tau*(1-tau))
	}

	st_rclear()
	st_numscalar("r(bwidth)", h)
}

void _qreg_kernel(string scalar kernel, 	///
		real scalar band,		/// 
		string scalar x,		///
		string scalar touse,		///
		string scalar wvar,		///
		|string scalar kvar)
{
	real colvector	xvec, val, cnd, wvec

	xvec = st_data(.,x,touse)
	xvec = xvec/band

	if (kernel == "biweight") {
		val = (15/16)*((1 :- xvec:^2):^2)	
		cnd = abs(xvec) :< 1
		val = val:*cnd 
	}
	else if (kernel == "cosine") {
		val = 1 :+ cos(2*pi()*xvec)
		cnd = abs(xvec) :< 0.5
		val = val:*cnd
	}
	else if (kernel == "epanechnikov") {
		val = (3/4)*(1 :- 0.2*xvec:^2)/sqrt(5)
		cnd = abs(xvec) :< sqrt(5)
		val = val:*cnd
	}
	else if (kernel == "epan2") {
		val = (3/4)*(1 :- xvec:^2)
		cnd = abs(xvec) :<  1
		val = val:*cnd
	}
	else if (kernel == "gaussian") {
		val = normalden(xvec)
	}
	else if (kernel == "parzen") {
		val = 4/3 :- 8*xvec:^2 + 8*abs(xvec):^3
		cnd = abs(xvec) :<= 0.5
		val = val:*cnd
		cnd = (0.5 :< abs(xvec) :& abs(xvec) :<= 1)
		val = val + ((8/3)*(1 :- abs(xvec)):^3):*cnd
	}
	else if (kernel == "rectangle") {
		val = 0.5*(abs(xvec) :< 1)
	}
	else { // (kernel=="triangle") {
		val = (1 :-abs(xvec)) :* (abs(xvec) :< 1)
	}	

	st_rclear()
	if (kvar == "") {
		if (wvar=="") st_numscalar("r(s)", band/mean(val) )
		else {
			wvec = st_data(.,wvar,touse)
			st_numscalar("r(s)", band/mean(val,wvec) )
		}
	}
	else st_store(., kvar, touse, val)
}
end
exit

References

Koenker, R. (2005) Quantile Regression. Cambridge University Press.
