*! version 1.2.4  20mar2019
program define mgarch_ccc, sortpreserve eclass byable(recall)
	local version = string(_caller())
	local vv "version `version':"
	version 11.1
	
	syntax anything [if] [in],                        ///
		[                                         ///
		vce(string)                               ///
		ARch(numlist integer >0 sort)             ///
		GArch(numlist integer >0 sort)            ///
		het(varlist ts fv numeric)		  ///
		CONSTraints(numlist integer >=1 <= 1999)  ///
		noCNSReport				  ///
		from(name)				  ///
		DIFficult				  ///
		TECHnique(string asis)			  ///
		ITERate(numlist max=1 integer >=0)	  ///
		TRace					  ///
		GRADient				  ///
		showstep				  ///
		HESSian					  ///
		SHOWTOLerance				  ///
		TOLerance(real 1e-6)			  ///
		LTOLerance(real 1e-7)			  ///
		NRTOLerance(real 1e-5)			  ///
		NONRTOLerance				  ///
		NOLOg LOg				  ///
		UNconcentrated				  ///
		DISTribution(string)			  ///
		*					  ///
		]
	
	local concentrated 1
	if "`unconcentrated'"!="" local concentrated 0
	
	// process distribution
	
	_mgarch_util CheckDist, dist(`distribution')
	local sdist `s(sdist)'
	local dist `s(dist)'
	local df `s(df)'
	local estdf `s(estdf)'
	local name `s(name)'
	
	// process maximization options
	
	if "`iterate'" == "" local iterate = c(maxiter)
	if "`technique'" == "" local technique = "bhhh 10 nr 16000"
	if `"`from'"' != "" {
		confirm matrix `from'
		tempname initb
		mata:`initb'=st_matrix("`from'")
	}
	
	// MGARCH_mlinfo_parse() parses optimize options in Mata and
	// returns a structure which is in turn passed to MGARCH_main_CCC()
	
	tempname mlopts
	c_local matanames `mlopts' `init'
	
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"	
	mata: `mlopts' = MGARCH_mlinfo_parse("`difficult'", "`technique'",   ///
		"`log'", "`trace'", "`showstep'", "`gradient'","`hessian'",  ///
		"`showtolerance'", "`nonrtolerance'",`iterate', `tolerance', ///
		`ltolerance', `nrtolerance',`initb')
	
	marksample touse
	
	_ts tvar pvar if `touse', onepanel sort
	
	_get_diopts diopts other, `options'
	
        _parse expand eqninfo left : anything
        
        local k_0 = `eqninfo_n'
	
	// common arch, garch, and het options
	local has_arch  = !("`arch'"=="")
	local has_garch = !("`garch'"=="")
	local has_het   = !("`het'"=="")
	local arch_com `arch'
	local garch_com `garch'
	
	if (`has_het') {
		_rmcoll `het', expand
		local het_com `r(varlist)'
	}
	
	// count the number of depvars (equations)
	
	local k_eq = 0
	forvalues i = 1/`k_0' {
		gettoken depvars junk : eqninfo_`i', parse("=")
		fvunab depvars : `depvars'
		_fv_check_depvar `depvars'
		local howmany : word count `depvars'
		local k_eq = `k_eq' + `howmany'
	}
	
	if (`k_eq'==1 & "`unconcentrated'" != "") {
		di "{err}option {cmd}unconcentrated {err}not allowed "	///
			"with a univariate time series"
		exit 498
	}

	qui tsset, noquery
	local delta `r(tdelta)'
	
	// process individual equations and create locals to be used by Mata
	
	local addtouse = ""
	local resids = ""
	local mean_eq = 0
	local k = 1
	forvalues i = 1/`k_0' {
		
                local 0 `"`eqninfo_`i''"'
                
		syntax anything(equalok) 			///
                	[, 					///
                	noCONStant 				///
                	ARch(numlist integer >0 sort)		///
			GArch(numlist integer >0 sort)		///
			het(varlist fv ts)			///
			]
		
		gettoken deps indeps : anything, parse("=")
		
		local indeps : subinstr local indeps "=" ""
		if ("`indeps'" != "") {
			_rmcoll `indeps', expand
			local indeps "`r(varlist)'"
			local COVARS `"`COVARS' `indeps'"'
		}
		
		if "`het'" != "" {
			_rmcoll `het' `het_com', expand
			local het "`r(varlist)'"
			local COVARS `"`COVARS' `het'"'
		}
		
		fvunab deps : `deps'
		local howmany : word count `deps'
		
		forvalues j=1/`howmany' {
			
			local dv : word `j' of `deps'
			
			local DEPVARS `"`DEPVARS' `dv'"'
			
			_mgarch_util Check, depvar(`dv') 		///
				hasarch(`has_arch') arch(`arch') 	///
				hasgarch(`has_garch') garch(`garch') 	///
				hashet(`has_het') het(`het')
			
			// locals for the mean equation
			local y`k' 		"`dv'"
			local y`k'_cons		"`constant'"
			local y`k'_xb		"`indeps'"
			
			// locals for the variance equation
			local s`k'_cons		""
			local s`k'_arch		"`arch'`arch_com'"
			local s`k'_garch	"`garch'`garch_com'"
			local s`k'_xb		"`het'`het_com'"
			
			local addtouse `addtouse' `dv' `indeps' `s`k'_xb'
			
			if "`indeps'" != "" {
				foreach i of local indeps {
					local STRIPE `"`STRIPE' `dv':`i'"'
					local TLIST `"`TLIST' [`dv']`i'"'
				}
				local space " "
			}
			else local space ""
			
			if "`constant'" == "" {
				local STRIPE `"`STRIPE' `dv':_cons"'
				local c = "_cons"
			}
			else local c
			
			if ("`c'" == "" & "`indeps'" == "") {
				local dot "."
			}
			else {
				local dot
				local ++mean_eq
				local DV_EQS `"`DV_EQS' `dv'"'
			}
			
			local INDEPS `"`INDEPS'; `indeps'`space'`c'`dot'"'
			
			if "`s`k'_arch'" != "" {
				foreach i of numlist `s`k'_arch' {
					local nm "ARCH_`dv':L`i'.arch"
					local STRIPE `"`STRIPE' `nm'"'
				}
				local ARCH `"`ARCH';`s`k'_arch'"'
			}
			else local ARCH "`ARCH';0"
			
			if "`s`k'_garch'" != "" {
			
				if "`s`k'_arch'" == "" {
di "{cmd:garch()} {err}may only be specified with {cmd:arch()}"
di "{err}GARCH terms are not identified without ARCH terms in the model."
exit 498
				}
				
				foreach i of numlist `s`k'_garch' {
					local nm "ARCH_`dv':L`i'.garch"
					local STRIPE `"`STRIPE' `nm'"'
				}
				local GARCH `"`GARCH';`s`k'_garch'"'
			}
			else local GARCH `"`GARCH';0"'
				
			if "`s`k'_xb'" != "" {
				foreach i of local s`k'_xb {
					local STRIPE `"`STRIPE' ARCH_`dv':`i'"'
				}
				local space " "
			}
			else local space ""
			local HET `"`HET' ; `s`k'_xb'`space'_cons"'
			
			local COVARS `"`COVARS' `s`k'_xb'"'
			
			local STRIPE `"`STRIPE' ARCH_`dv':_cons"'
			
			local ++k
		}
        }
	
	if `k_eq'>1 {
		local r = `k_eq'-1
		forvalues i = 1/`r' {
			local dep1 : word `i' of `DEPVARS'
			local c = `i'+1
			forvalues j = `c'/`k_eq' {
				local dep2: word `j' of `DEPVARS'
				if `version' < 16 {
					local CORR "corr(`dep1',`dep2'):_cons"
				}
				else {
					local CORR "/:corr(`dep1',`dep2')"
				}
				local STRIPE `"`STRIPE' `CORR'"'
			}
		}
	}
	
	if (`estdf') {
		if `version' < 16 {
			local STRIPE `"`STRIPE' `name':_cons"'
		}
		else {
			local STRIPE `"`STRIPE' /:`name'"'
		}
	}
	
	_b_post0 `STRIPE'
	
	tempname b V
	mat `b' = e(b)
	mat `V' = e(V)
    	
	// +++++++++++++++++++++++++++++++++++++++++++++++++ process constraints
    	
	if "`cnsreport'" =="" local display "display"
    	tempname Cns
	local constraints : subinstr local constraints "," " ", all
	makecns `constraints', nocnsnotes //`display'
	local k_autoCns = r(k_autoCns)
	capture matrix `Cns' = get(Cns)
	capture scalar rowsofCns = rowsof(`Cns')
	if _rc scalar rowsofCns = 0
	if scalar(rowsofCns)==0 macro drop _Cns
	
	// +++++++++++++++++++++++++++++++++++++++++++++++++ process misc things
    	
	local COVARS : list uniq COVARS
	
	gettoken junk INDEPS : INDEPS, parse(";")
	gettoken junk HET : HET, parse(";")
	gettoken junk ARCH : ARCH, parse(";")
	gettoken junk GARCH : GARCH, parse(";")
	
	qui _rmcoll `DEPVARS'
	if `r(k_omitted)' > 0 {
		local deps `r(varlist)'
		foreach i of local deps {
			_ms_parse_parts `i'
			if `r(omit)' local odeps `odeps' `r(name)'
		}
		di "{cmd:`odeps'} {err}collinear with other dependent variables"
		exit 498
	}
        
	_mgarch_util CheckHetvars, depvars(`DEPVARS') hetvars(`HET')
        
	markout `touse' `addtouse'
        
	tempname tmin tmax
	qui sum `tvar' if `touse' , meanonly
	scalar `tmax' = r(max)
	scalar `tmin' = r(min)
	local fmt : format `tvar'
	local tmins = trim(string(r(min), "`fmt'"))
	local tmaxs = trim(string(r(max), "`fmt'"))

	qui count if `touse'
	local T = r(N)
	
	// +++++++++++++++++++++++++++++++++++++++++++++++++ report gaps in data
	
	tsreport if `touse', report `detail'
	local gaps `r(N_gaps)'
	if (`gaps') di "{txt}(note: conditioning reset at each gap)"
	
	// +++++++++++++++++++++++++++++++++++++++++++++++++++++++ process vce()
	
	_vce_parse, optlist(oim Robust) : , vce(`vce')
	if "`r(robust)'" != "" {
		local isrobust 1
		local vce "robust"
	}
	else {
		local isrobust 0
		local vce "oim"
	}
	
	mata: MGARCH_main_CCC(`k_eq',"`touse'",`T',`mlopts',"`tvar'",	///
		`concentrated', `isrobust')
	
	// return list
	
	tempname b V V_mb C H grad Hess ilog pinfo
	
	matrix `b'     = r(b)
	matrix `V'     = r(V)
	if (`isrobust') matrix `V_mb' = r(V_mb)
	matrix `grad'  = r(gradient)
	matrix `Hess'  = r(hessian)
	matrix `ilog'  = r(ilog)
	matrix `pinfo' = r(pinfo)
	
	mat rownames `pinfo' = `DEPVARS'
	
	local ll = r(ll)
	local converged = r(converged)
	local rc = r(rc)
	local ic = r(ic)
	local rank = r(rank)
	local k = r(k)
	local k_dv = r(k_dv)
	local technique `r(technique)'
	
	`vv' ///
	mat rownames `V' = `STRIPE'
	`vv' ///
	mat colnames `V' = `STRIPE'
	`vv' ///
	mat colnames `b' = `STRIPE'
	
	ereturn post `b' `V' `Cns', obs(`T') esample(`touse') buildfvinfo
	
	if "`sdist'" == "t" {
		_b_pclass PCDEF : default
		_b_pclass PCDF : df

		tempname pclass
		matrix `pclass' = e(b)
		local dim = colsof(`pclass')
		matrix `pclass'[1,1] = J(1,`dim',`PCDEF')
		matrix `pclass'[1,`dim'] = `PCDF'
		`vv' ///
		matrix colnames `pclass' = `STRIPE'
		ereturn hidden matrix b_pclass `pclass'
	}
	capture test `TLIST'
	if !_rc {
		local ttest = 1
		local p = r(p)
		local df_m = r(df)
	        local chi2 = r(chi2)
	        local chi2type Wald
        }
        else local ttest = 0
        
	local k_aux = .5*`k_eq'*(`k_eq'-1)
	local k_extra = `estdf'
	local tot_eq = `mean_eq' + `k_eq' + `k_aux' + `k_extra'
	
	// scalars
	if `version' < 16 {
		ereturn hidden scalar version = 1
	}
	else {
		ereturn hidden scalar version = 2
	}
	ereturn scalar rank = `rank'
	ereturn scalar k = `k'
	ereturn scalar k_extra = `k_extra'
	if `version' < 16 {
		ereturn scalar k_aux = `k_aux'
	}
	ereturn scalar k_eq = `tot_eq'
	if ("`k_autoCns'" != "") ereturn hidden scalar k_autoCns = `k_autoCns'
	if (`ttest') ereturn scalar p = `p'
	if (`ttest') ereturn scalar df_m = `df_m'
	if (`ttest') ereturn scalar chi2 = `chi2'
	ereturn scalar tmin = `tmin'
	ereturn scalar tmax = `tmax'
	ereturn scalar N_gaps = `gaps'
	ereturn scalar ll = `ll'
	ereturn scalar k_dv = `k_dv'
	ereturn scalar estdf = `estdf'
	capture ereturn scalar usr = `df'
	ereturn scalar converged = `converged'
	ereturn scalar ic = `ic'
	ereturn scalar rc = `rc'
	
	// macros
	ereturn local estat_cmd "_mgarch_ccc_estat"
	ereturn local predict "mgarch_ccc_p"
	if (`ttest') ereturn local chi2type `chi2type'
	ereturn hidden local crittype "log likelihood"
	if (`isrobust') {
		ereturn hidden local crittype "log pseudolikelihood"
		matrix colnames `V_mb' = `STRIPE'
		matrix rownames `V_mb' = `STRIPE'
	}
	ereturn local tmaxs `tmaxs'
	ereturn local tmins `tmins'
	ereturn local marginsok     "xb Variance default"
	ereturn local marginsnotok  "Residuals"
	ereturn local tvar "`tvar'"
	ereturn local hetvars `HET'
	ereturn local garch "`GARCH'"
	ereturn local arch "`ARCH'"
	if `:length local COVARS' {
		ereturn local covariates `COVARS'
		foreach dv of local DEPVARS {
			local mdflt `mdflt' predict(xb equation(`dv'))
		}
		ereturn local marginsdefault `"`mdflt'"'
	}
	else {
		ereturn local covariates _NONE
	}
	ereturn local indeps `INDEPS'
	ereturn local dv_eqs `DV_EQS'
	ereturn local depvar `DEPVARS'
	ereturn local dist `sdist'
	ereturn hidden local estimator "ml"
	ereturn local technique `technique'
	ereturn local vce "`vce'"
	if (`isrobust') ereturn local vcetype "Robust"
	ereturn local model "ccc"
	ereturn local cmd "mgarch"
	ereturn local title "Constant conditional correlation MGARCH model"
	
	// matrices
	ereturn matrix ilog = `ilog'
	ereturn matrix hessian = `Hess'
	ereturn matrix gradient = `grad'
	ereturn matrix pinfo = `pinfo'
	if (`isrobust') ereturn matrix V_modelbased `V_mb'
	
	_mgarch_util Replay, `diopts' `cnsreport'
	
end
