*! version 1.0.3  10jan2020

program define _npreg_series, eclass byable(onecall)
        version 16

        if _by() {
                local BY `"by `_byvars'`_byrc0':"'
        }
        
        `BY' _vce_parserun _npreg_series, noeqlist jkopts(eclass): `0'
        
        if "`s(exit)'" != "" {
                ereturn local cmdline `"_npreg_series `0'"'
                exit
        }

        if replay() {
                if `"`e(cmd)'"' != "_npreg_series" { 
                        error 301
                }
                else if _by() { 
                        error 190 
                }
                else {
                        Display `0'
                }
                exit
        }
        `vv' ///
        `BY' Estimate `0'
        ereturn local cmdline `"_npreg_series `0'"'       
end

program define Estimate, eclass byable(recall)
	syntax varlist(numeric fv) [if] [in] [fw iw]	///
		[,					///
		NOCONstant				///
		CONstant				///
		NOLOg					///
		LOg					///
		criterion(string)			///
		asis(string)				///
		Level(cilevel)                          ///
		ITERate(integer 30)			///
		TOLerance(real 1e-4)			///
		POLYNOMIALs(string)			///
		CONSTraints(string)			///
		SPLINEs(string)				///
		BSPLINEs(string)			///
		BSPLINEs1				///
		SPLINEs1				///
		POLYNOMIALs1				///
		vce(string)				///
		rescale(string)				/// 
		knots(string)				///
		knotsmat(string)			///
		NOINTERact(string)			///
		basis(string)				///
		aequations				///
		UNIFORMknots				///
		distinct(integer 10)			///
		*					///
		]
	
	marksample touse 
	quietly count if `touse'
	local N = r(N)
	gettoken lhs rhs: varlist 
	_fv_check_depvar `lhs' 

	// vce 
	
	_check_vce_cluster, vce(`vce')
	local vce = "`s(vce)'"

	// iterlog 
	
	if ("`c(iterlog)'"=="off" & "`log'"=="") {
		local log nolog 
	}
	if ("`nolog'"!="") {
		local log nolog
	}
	
	// aequations 
	
	local aeq = 0 
	if ("`aequations'"!="") {
		local aeq = 1 
	}

	// Parsing options 

	_get_diopts diopts rest, `options'
	qui cap Display, `diopts' `rest'
	if _rc==198 {
                Display, `diopts' `rest'
        }
	
	// parsing minlevel
	
	local minlevel = `distinct'
	_parse_min_level, minlevel(`minlevel')
	
	// rescaling 
	
	local rescala = 0 
	if ("`rescale1'"!=""| "`rescale'"!="") {
		local rescala = 1 
	}
	
	// Constraints not allowed 
	
	if ("`constraints'"!="") {
		display as error ///
			"constraints are not allowed with series estimation"
		exit 198
	}
	
	tempname b V G Vgmm S matknots matmm matmm2 V_modelbased minmaxp ///
	         matcnint matdnint matmm3 milog 

	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
		local wtype "`weight'"
		local wexp  "`exp'"
		gettoken peso pesos: exp
	}

	// Checking optimization criterion 
	
	local criterion2 "`criterion'"
	if ("`criterion'"=="" & "`knots'"=="" & "`knotsmat'"==""){
		local criterion "cv"
		local cname "cross validation"
		local sname "cross-validation"
		local iname "Cross-validation"
	}
	if ("`criterion'"!="" & "`knots'"=="" & "`knotsmat'"=="") {
		_ccheck, criterion("`criterion'")
		local criterion = "`s(crit)'"
		local cname     = "`s(cname)'"
		local iname     = "`s(iname)'"
		local sname     = "`s(sname)'"
	}
	if ("`criterion2'"!="" & ("`knots'"!=""| "`knotsmat'"!="")) {
		di as txt "{p 0 6 2}"					///
		"note: option {bf:criterion()} is ignored when " 	///
		"{bf:knots()} or {bf:knotsmat()} are specified {p_end}"
		local cname "none"
	}
	
	if ("`criterion2'"!="" & "`polynomials'"!="") {
		di as txt "{p 0 6 2}"					///
		"note: option {bf:criterion()} is ignored when " 	///
		"option {bf:polynomial()} is specified {p_end}"
		local cname "none"
	}
	
	// Predict options
	
	local predict "`basis'"
	
	// Constant and B-splines (might change later)

	opts_exclusive "`constant' `noconstant'"	
	if ("`constant'"=="" & "`noconstant'"=="") {
		local constant ""
	}
	if ("`constant'"=="constant") {
		local constant ""
	}
	if ("`noconstant'"=="noconstant") {
		local constant "noconstant"
	}
	
	// Polynomial or Polynomials
	
	local polynomial "`polynomials'"
	if ("`polynomials1'"!="") {
		local polynomial1 "polynomial1" 
	}
	
	if (("`polynomials1'"!="" | "`polynomials'"!="") &	///
		(("`predict'"!="")|("`rescale'"!=""))) {
			display in red "{bf:basis()} and {bf:rescale()}" /// 
			" not valid with polynomial-series estimation"
			exit 198
	}

	if (("`polynomials1'"!="" | "`polynomials'"!="") &	///
		(("`knots'"!="")|("`knotsmat'"!=""))) {
			display in red "{bf:knots()} and {bf:knotsmat()}" /// 
			" not valid with polynomial-series estimation"
			exit 198
	}
	
	if (("`polynomials1'"!="" | "`polynomials'"!="") & ///
		"`uniformknots'"!="") {
			display in red "{bf:uniformknots}" /// 
			" not valid with polynomial-series estimation"
			exit 198			
	}
	
	if ("`polynomials'"!="") {
		_polycheck, polynomials(`polynomials')
	}
	
	// Constant only
	
	if ("`asis'"=="" & "`rhs'"=="") {
		display as error "at least one regressor should be specified"
		exit 198
	} 
	
	// Covariate list for margins and parsing asis()
	
	if ("`asis'"!="") {
		local known "`asis'"
		_known_errs `asis'
	}
	local knppr = 0 
	if ("`known'"!="") {
		_covariates_known if `touse' `wgt', rhs(`rhs')	///
			`constant' known(`known')  		///
			polynomial(`polynomial') `polynomial1'	
		local newmgcovar "`r(newcovars)'"
		local covariates "`newmgcovar'"
		local known "`r(known)'"
		local knownp "`r(knownp)'"
		local knownj "`r(knownj)'"
		local knppr = r(knpr)

		matrix `minmaxp' = r(minmaxp)	 
		_contordisc if `touse' `wgt', vars("`newmgcovar'")	///
			`constant' known(`knownj') minlevel(`minlevel')
		local cknown = "`s(cnoms)'"
		local dknown = "`s(dnoms)'"
		local ckk: list sizeof cknown 
		if ("`cknown'"!="") {
			matrix `matmm3' = J(`ckk', 2, .)
			forvalues i=1/`ckk' {
				local xckk: word `i' of `cknown'
				quietly summarize `xckk' if `touse' `wgt'
				matrix `matmm3'[`i', 1] = r(min)
				matrix `matmm3'[`i', 2] = r(max)
			}
		}
	}
	else {
		fvexpand `rhs' if `touse'
		local covariates = r(varlist)
	}
		
	// Series term options 
	
	_series_opts if `touse', polynomial(`polynomial')	///
				 spline(`splines') 		///
				 `splines1'			///
				 `bsplines1'			///
				 `polynomial1'			///	
				 bspline(`bsplines')		///
				 knots(`knots')			
	local sorder = r(sorder)
	local estis  = r(estis)
	local fijo   = r(fijo)
	local stit   "`r(stit)'" 
	
	// Getting nointeract() variables 
	
	if ("`nointeract'"!="") {
		_contordisc if `touse' `wgt', vars("`nointeract'") ///
			`constant' inter minlevel(`minlevel')	
		local nointernoms   = "`s(noms)'"
		local nointercnoms  = "`s(cnoms)'"
		local nointerdnoms  = "`s(dnoms)'"
		local nointeractlist "`nointeract'"
	}

	// Getting variable list for series 

	if ("`rhs'"!="") {
		_contordisc if `touse' `wgt', vars("`rhs'") ///
			`constant' minlevel(`minlevel')
		local noms   = "`s(noms)'"
		local cnoms  = "`s(cnoms)'"
		local dnoms  = "`s(dnoms)'"
		local dnp    = "`s(dnp)'" 
		local queda  = "`s(queda)'"
	}

	matrix `matcnint' = .
	matrix `matdnint' = .
	
	if ("`nointeract'"!="") {
		local espoly ""
		if ("`polynomial'"!="") {
			local espoly "espoly"
		}
		_intersect_list, orig(`cnoms' `dnoms') nointer(`nointeract') 
		_nointer_cont_disc if `touse', dvars(`dnoms')	///
			 cvars(`cnoms') estis(`estis') 		///
			 nointer(`nointeract') orden(`sorder')	///
			 vars(`noms') `espoly'
		local precnoms "`cnoms'"
		local prednoms "`dnoms'"
		if (`estis'==1) {
			local cnoms "`s(newcvars)'"
			local dnoms "`s(newdvars)'"
			local noms "`s(newvars)'"
		}
		local newnointer "`s(intvars)'"
		local nointercnoms  = "`s(intcvars)'"
		local nointerdnoms  = "`s(intdvars)'"	
		if (`estis'>1) {
			_contordisc if `touse' `wgt', 			///
				vars(`nointercnoms' `nointerdnoms')	///
				`constant' minlevel(`minlevel')
			local nointercnoms  = "`s(cnoms)'"
			local nointerdnoms  = "`s(dnoms)'"	
			_mat_cvar_dvar, cvars(`precnoms')	///
				intcvars(`nointercnoms')	///
				dvars(`prednoms')		///
				intdvars(`nointerdnoms')	
			matrix `matcnint' = r(cinter)
			matrix `matdnint' = r(dinter)
		}
	}

	// knot matrix 
	
	if ("`knots'"!="" & "`knotsmat'"!="") {
		display as error "only one of {bf:knots()}" ///
			" and {bf:knotsmat()} is allowed"
		exit 198
	}
	local knotsmatrix = 0
	if ("`cnoms'"!="" & "`knotsmat'"!="") { 
		tempname matknn
		making_knot_matrix if `touse' `wgt', mat(`knotsmat')	///
			cvars(`cnoms') rescale
		matrix `matknn' = r(knotsmat)
		local knotsmatrix = 1
	}
	
	if ("`knots'"!="") {
		_string_or_real if `touse', mystring("`knots'") optn("knots")
		_knotcheck if `touse', knots(`knots')
	}

	// Title 
	
	local titulo "Polynomial-series estimation"
	local titulo2 "Regression results for polynomial-series estimation"
	local root "Polynomial order"
	
	// Which criterion
	
	if (`estis'==2) {
		local optimizer "_criterion_spline"
		local titulo "`stit'"
		local titulo2 "Regression results for natural-spline estimation"
		local root "Number of knots"
		local basis "splines"
	}
	if (`estis'==1) {
		local optimizer "_criterion"
		local basis "polynomial"
	}
	if (`estis'==3) {
		local optimizer "_criterion_bspline"
		local basis "bsplines"
		local titulo "`stit'"
		local titulo2 "Regression results for B-spline estimation"
	}
	
	if ("`dnoms'"!="") {
		fvexpand `dnoms' if `touse'
		local newdnoms "`r(varlist)'"
	}
	
	// Computing optimal series terms 
	nobreak {
		capture noisily break { 
			`optimizer' if `touse' `wgt', vars("`noms'") 	///
				    y("`lhs'") 				///
				    `constant' 				///
				    `log'				///
				    criterion("`criterion'") 		///
				    iterate(`iterate')			///
				    known(`known')			///
				    tolerance(`tolerance')		///
				    vce(`vce')				///
				    cells("`cells'")			///
				    mat(`mat')				///
				    polynomial(`polynomial')		///
				    cname(`cname')			///
				    iname(`iname')			///
				    sname(`sname')			///
				    dnoms(`dnoms')			///
				    dnp(`dnp')				///
				    orden(`sorder') 			///
				    rescale(`rescale')			///
				    cnointer("`nointercnoms'")		///
				    dnointer("`nointerdnoms'")		///
				    nointer("`newnointer'")		///
				    cvars("`cnoms'")			///
				    csvars("`csnoms'")			///
				    dvars("`dnoms'")			///
				    knots(`knots') 			///
				    `espoly'				///
				    knotsmat(`matknn')			///
				    predict(`predict')			///
				    matcint(`matcnint')			///
				    matdint(`matdnint')			///
				    `uniformknots'	
		}
	}
	local rc = _rc
	if (`rc') {
		if ("`predict'"!=""|"`rescale'"!="") {
			if ("`predict'"!="") {
				capture drop `predict'*
			}
			if ("`rescale'"!="") {
				capture drop `rescale'*
			}
		}
		else {
			capture drop *__knot_*
			capture drop __*rs
			capture drop *__b*
			capture drop __*p
		}	
		exit `rc'
	}

	local comparison  = r(comparison)
	local ilog        = r(ilog)
	if (`ilog') {
		matrix `milog'      = r(milog)
	}
	local renoms "`r(renoms)'"
	local checknoms "`r(checknoms)'"
	matrix `matknots' = r(matknots)
	matrix `matmm'    = r(matmm)
	matrix `matmm2'   = r(matmm2)
	if ("`known'"==""|"`cknown'"=="") {
		matrix `matmm3' = `matmm2'
	}
	local nudos       = r(nudos)
	local catnames  "`r(catnames)'"
	matrix `b' = r(b)
	matrix `V' = r(V)
	local converged  = r(converged)
	local regressors = "`r(regressors)'"
	local cantes     = "`r(cantes)'"
	local vce "`r(vce)'"
	if ("`r(vce)'"=="robust") {
		matrix `V_modelbased' = r(V_modelbased)
	}
	local vcetype "`r(vcetype)'"
	local depvar "`lhs'"
	local order = r(order)
	local ll_0  = r(ll_0)
	local ll    = r(ll)
	local r2    = r(r2)
	local r2_a  = r(r2_a)
	local norsq = r(norsq)
	local rank  = r(rank)
	local cv    = r(cv)
	
	// discrete list for prediction 
	
	local dinter "`r(dinter)'"
	_dvar_list_p, dvars("`dinter'") queda("`queda'")
	local dinter2 "`s(dinter)'"
	
	if (`matdnint'[1,1]!=.) {
		local dinter "`nointerdnoms'"
		_dvar_list_p, dvars("`dinter'") queda("`queda'")
		local dinter "`dinter2' `s(dinter)'"
	}
	else {
		local dinter "`dinter2'"
	}
	if ("`basis'"=="polynomial") {
		local dinter  "`regressors'"
		fvexpand `dinter'
		local dinter "`r(varlist)'"
		local dinter2 "`dinter'" 
		quietly mata: _dinter_expand_bn("`dinter'")
		local regressors "`dinter'"
		local dinter "`dinter2'"
	}

	ereturn post `b' `V', esample(`touse') obs(`N') depname(`lhs') ///
			      buildfvinfo
	
	// Data signature  

	quietly signestimationsample `covariates'
	
			      
	ereturn scalar converged = `converged'
	if ("`vce'"=="robust") {
		ereturn matrix V_modelbased = `V_modelbased'
	}
	ereturn local vce "`vce'"
	ereturn local vcetype "`vcetype'"
	ereturn local depvar "`lhs'"
	ereturn scalar order = `order'
	if ("`constant'"=="") {
		ereturn scalar ll_0 = `ll_0'
	}
	ereturn scalar ll    = `ll'
	ereturn hidden local ilog =`ilog'
	if (`ilog') {
		ereturn hidden matrix milog = `milog'
	}
	ereturn scalar r2    = `r2'
	ereturn scalar  r2_a = `r2_a'
	ereturn scalar norsq = `norsq'
	ereturn scalar  rank = `rank'
	ereturn hidden scalar  comparison = `comparison'
	ereturn hidden local known "`knownp'"
	ereturn hidden local root "`root'"
	ereturn hidden local fijo "`fijo'"
	ereturn hidden local renoms "`renoms'"
	ereturn hidden scalar estis = `estis'
	if (`knppr'>0) {
		ereturn hidden matrix minmaxp = `minmaxp' 
	}
	ereturn hidden scalar knppr = `knppr'
	ereturn hidden scalar knotsmatrix = `knotsmatrix'
	ereturn hidden matrix matcnint = `matcnint' 
	ereturn hidden matrix matdnint = `matdnint'
	ereturn local knots "`nudos'"
	ereturn hidden local criterion "`cname'"
	ereturn hidden matrix matknots = `matknots'
	ereturn hidden matrix matmm    = `matmm'
	ereturn hidden matrix matmm3   = `matmm3'
	ereturn hidden matrix matmm2   = `matmm2'
	ereturn local wtype "`wtype'"
	ereturn local wexp  "`wexp'"
	ereturn local estat_cmd "regress_estat"
	ereturn hidden local espoly "`espoly'"
	ereturn local cmd "_npreg_series"
	ereturn local title "`titulo'"
	ereturn hidden local title2 "`titulo2'"
	ereturn local predict "npregress_series_p"
	ereturn hidden local regressors "`regressors'"
	ereturn hidden local cantes "`cantes'"
	ereturn hidden local checknoms "`checknoms'"
	ereturn hidden local covariates "`covariates'"
	ereturn hidden local dvars "`newdnoms'"
	ereturn hidden local cvars "`cnoms'"
	ereturn hidden local catnames "`catnames'"
	ereturn hidden local dnp "`dnp'"
	ereturn hidden local dinter "`dinter'"
	ereturn hidden local hascons "`constant'" 
	ereturn hidden local lnointeract "`nointeractlist'"
	ereturn scalar cv = `cv'
	ereturn hidden scalar rescala = `rescala'
	ereturn local basis "`basis'"
	ereturn hidden local queda "`queda'"
	ereturn local marginsok "default Mean"
	ereturn local marginsnotok "SCores Residuals"
	ereturn local marginsprop "noeb"
	ereturn local omitir "`omitir'"
	ereturn hidden local cmd_loco "_npreg_series"
	ereturn hidden local margins_cmd margins4series
	ereturn scalar aeq = `aeq' 

	Display, bmatrix(e(b)) vmatrix(e(V)) level(`level')	///
		 `rest' `diopts' `omitir'

end

 ///////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////
 /////////////////////////////// SUBROUTINES ///////////////////////////////
 ///////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////

program define Display
        syntax [, bmatrix(passthru) vmatrix(passthru) noTABle aequations *]

        _get_diopts diopts other, `options'
        local myopts `bmatrix' `vmatrix'
                
        if "`other'"!=""{
                display "{err}option {bf:`other'} not allowed"
                exit 198
        }
        local r2         = e(r2)
	local r2_a       = e(r2_a)
	local titulo     = "`e(title)'"
	local bwsel      = "`e(bselector)'"
	local root       = "`e(root)'"
	local crit       = "`e(criterion)'"
	local fijo       = e(fijo)
	local estis      = e(estis)
	local knots      = e(knots)
	local level      = e(nivel)
	local cvars      = "`e(cvars)'"
	local N          = e(N)      
	local order      = e(order)
	local comparison = e(comparison)
	local criterion  = e(cv)
	local aeq        = e(aeq)
	
	if (`estis'>1) {
		local root "Number of knots "
		local order = `knots'  
		if ("`cvars'"=="") {
			local order = 0 
		}
	}
       
       if (`aeq'==1 | "`aequations'"!="") {
	        display ""
		di as text "`titulo' " 		///
			as text _col(44) "Number of obs      =  "	///
			as result %13.0gc `N'
			if (`order'>0) {
				noi display as text _col(44)  ///
				"`root'   =  "  ///
				as result %13.0f `order'
			}
			noi display as text _col(44)  ///
			"R-squared          =  "  ///
			as result %13.4f `r2'
			if (e(cv)!=.) {
				di as txt "`crit' = " as res %10.0g e(cv) ///
				as txt _col(44) ///
				"Adj R-squared" _col(62) " =  " ///
				as res %13.4f `r2_a'
			}
			else {
				di as txt as txt _col(44) ///
				"Adj R-squared" _col(62) " =  " ///
				as res %13.4f `r2_a'			
			}
		if ("`table'"=="") {
			_coef_table,  `diopts' `myopts' notest 
		}
			ml_footnote
	}
	
end


program define _contordisc, sclass 
	syntax [if] [in] [fw pw iw], [vars(string) noCONstant ///
		inter minlevel(integer 10) known(string)]
	
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
	}
	local blb ""
	if ("`inter'"!="") {
		local blb "for the {bf:nointeract()} option"
	}
	
	marksample touse 
	tempname matbase cuentas allvals 
	
	_rmcoll `vars' if `touse' `wgt', `constant'
	local vars2 = r(varlist)
	fvexpand `vars2' if `touse'
	local newvars = r(varlist)
	local k: list sizeof newvars 
	local nombres ""
	local cnames ""
	local dnp ""
	local jf  = 0 
	local jnb = 0 
	local jb  = 0
	local jn  = 0

	forvalues i=1/`k' {
		local x: word `i' of `newvars'
		_ms_parse_parts `x'
		local tipo  = r(type)
		local name  = r(name)
		local base  = r(base)
		local nivel = r(level)
		if ("`tipo'"=="factor") {
			local opa = r(op)
			local dsnm "`dsnm' `name'"
			local ds0  "`ds0' `x'"
			local noms "`noms' `name'"
		}
		if ("`tipo'"=="variable") {
			local noms "`noms' `name'"
			local cnoms "`cnoms' c.`name'"
			local cnoms2 "`cnoms2' `name'"
			capture summarize i.`name'
			local rc = _rc
			local interk: list name & known
			if (`rc'==0 & "`interk'"=="") {
				_level_err `name', minlevel(`minlevel')
			}
		}
		if ("`tipo'"=="interaction") {
			display as error "interactions are unnecessary `blb'"
			di as err "{p 4 4 2}" 
			di as err "You are estimating an arbitrary function" 
			di as err "of the regressors. All interactions" 
			di as err "are accounted for."
			di as smcl as err "{p_end}"
			exit 198		
		}
	}
	
	local k2: list sizeof dsnm
	local k2 = `k2' + 1
	local j1 = 0
	forvalues i=1/`k2' {
		local cero: word `i' of `dsnm'
		if (`i'==1) {
			local uno "`cero'"
		}
		if ("`uno'"!="`cero'") {
			local jn = `jn' + 1
			matrix `cuentas' = nullmat(`cuentas'), `j1'
			local j1 = 1 
		}
		else {
			local j1 = `j1' + 1
		}
		local uno "`cero'"
	}
	local j2 = 1 
	local j3 = 0 
	local j4 = 1
	
	if ("`dsnm'"!="") {
		local k2 = colsof(`cuentas')
		forvalues i=1/`k2' {
			local kd = `cuentas'[1,`i'] 
			tempname lev`i'
			forvalues j=1/`kd' {
				local x: word `j4' of `ds0'
				_ms_parse_parts `x'
				local base  = r(base)
				local nivel = r(level)
				if (`kd'>1) {
					if (`base') {
						matrix `matbase' =	///
						nullmat(`matbase'),	///
						`nivel'
							local j3 = 1				
					}
					if (`j3'==0 & `j'==`kd') {
						matrix `matbase' =	///
							nullmat(`matbase'), .			
					}
					local j4 = `j4' + 1
					matrix `lev`i'' = ///
						nullmat(`lev`i''), `nivel'
				}
				else {
					matrix `lev`i'' =	///
						nullmat(`lev`i''), `nivel'
					matrix `matbase' = 	///
					nullmat(`matbase'), -`nivel'
				}
			}
			local j3 = 0 
		}
	}

	local dlist: list uniq dsnm
	local nombres: list uniq noms
	
	if ("`dsnm'"!="") {
		forvalues i=1/`k2' {
			local x: word `i' of `dlist'
			local kd = `cuentas'[1,`i'] 
			quietly tab `x'
			local tot  = r(r)
			local ind = `matbase'[1,`i']
			if (`tot'>`kd') {
				forvalues j=1/`kd' {
					local lvf = `lev`i''[1, `j']
					if (`ind'>=0 & `ind'!=.) {
						local newd	///
						"`newd' i`lvf'b`ind'.`x'"
					}
					if (`ind'<0) {
						local b = abs(`ind')
						local newd "`newd' i`b'.`x'"					
					}
					if (`ind'==.) {
						if (`j'==1) {
							local newd ///
							"`newd' `lvf'bn.`x'"
							local queda ///
							"`queda' `lvf'.`x'"
						}
						else {
							local newd	///
							"`newd' `lvf'.`x'"
						}
					}
				}
			}
			else {
				forvalues j=1/`kd' {
					local lvf = `lev`i''[1, `j']
					if (`ind'>=0 & `ind'!=.) {
						local newd "`newd' ib`ind'.`x'"
					}
					if (`ind'<0) {
						local b = abs(`ind')
						local newd "`newd' i`b'.`x'"					
					}
					if (`ind'==.) {
						local newd "`newd' ibn.`x'"
						if (`j'==1) {
							local queda ///
							"`queda' `lvf'.`x'"
						}
					}
				}		
			}
		}
	}

	local newd: list uniq newd
	local newl: list uniq noms
	local kt:  list sizeof newl
	local ktd: list sizeof newd
	local j1 = 1 	

	forvalues i=1/`kt' {
		local x: word `i' of `newl'
		if ("`newd'"!="") {
			forvalues j=1/`ktd' {
				local y: word `j' of `newd'
				fvexpand `y'  if `touse'
				local y0 = r(varlist)
				local y1: word 1 of `y0'
				_ms_parse_parts `y1'
				local nombre = r(name)
				local tipo = r(type)
				local inter: list x & cnoms
				local interd: list x & nombre
				if ("`inter'"!="") {
					local final "`final' c.`x'"
				}
				if ("`interd'"!="" & "`tipo'"!="variable") {
					local final "`final' `y'"
				}
			}
		}
		else {
			local final "`cnoms'"
		}
	}

	local final "`final' `cnoms'"
	local final: list uniq final
	

	sreturn local noms "`final'"
	sreturn local cnoms "`cnoms'"
	sreturn local dnoms "`newd'"
	sreturn local dnp "`dlist'"
	sreturn local queda "`queda'"
end  

program define _cv_compute, rclass
	syntax [if] [in] [fw pw iw], vars(string) y(string) 		///
				     [criterion(string) noCONstant 	///
				     cells(string) mat(integer -1) 	///
				      *					///
				      ]	
	marksample touse 
	tempvar ehat ehat2 cv d dm ic

	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
	}
	local estimator = ("`criterion'"=="cv"| "`criterion'"=="aic"| ///
				"`criterion'"=="bic")

	capture regress `y' `vars' if `touse' `wgt', notable ///
		noheader `constant'
	local rc = _rc
	if (`rc'>0 & `rc'!=908 & `rc'!=907) {
		display as err "while computing cross-validation regression:"
		quietly regress `y' `vars' if `touse' `wgt', notable ///
			noheader `constant'
	}
	if (`rc'==908|`rc'==907) {
		return scalar err = 1
		_big_matrix_prob
		display as err "while computing cross-validation regression:"
		quietly regress `y' `vars' if `touse' `wgt', notable ///
			noheader `constant' 
	}
	else {
		return scalar err = 0 
	}
	
	local k = e(rank)
	quietly count if `touse'
	local N = r(N)
	quietly _predict double `ehat' if `touse', residuals
	quietly _predict double `d' if `touse', hat
	quietly generate double `ehat2' = `ehat'*`ehat'
	if ("`criterion'"==""|"`criterion'"=="cv") {
		quietly generate double `cv' = `ehat2'/(1 -`d')^2
		summarize `cv', meanonly
		scalar cvc = r(mean)
	}
	else if ("`criterion'"=="gcv") {
		quietly generate double `cv' = `ehat2'/(1-(`k'/`N'))^2
		summarize `cv', meanonly
		scalar cvc = r(mean)
	}
	else if ("`criterion'"=="mallows") {
		quietly egen double `dm'     = total(`ehat2')
		quietly generate double `cv' = `ehat2' + 2*(`dm'*`k')/(`N'^2)
		summarize `cv', meanonly
		scalar cvc = r(mean)
	}
	else if ("`criterion'"=="aic" | "`criterion'"=="bic") {
		quietly estat ic
		matrix `ic' = r(S)
		scalar aic = `ic'[1,5]
		scalar bic = `ic'[1,6]
		if ("`criterion'"=="aic") {
			scalar cvc = aic 
		}
		if ("`criterion'"=="bic") {
			scalar cvc = bic 
		}
	}
	
	return scalar cv = cvc
	
end 

program define _criterion, rclass 
	syntax [if] [in] [fw pw iw], [vars(string) 		///
				      y(string)			///
				      noCONstant		///
				     criterion(string)		///
				     known(string)		///
				     ITERate(integer 30)	///
				     TOLerance(real 1e-4)	///
				     cells(string)		///
				     mat(integer -1)		///
				     vce(string)		///
				     polynomial(integer -1)	///
				     cname(string)		///
				     iname(string)		///
				     sname(string)		///
				     cvars(string)		///
				     dnoms(string)		///
				     nointer(string)		///
				     cnointer(string)		///
				     dnointer(string)		///
				     rescale(string)		///
				     espoly			///
				     noLOg			///
				     *				///
				    ] 		   
	marksample touse 
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
	}
	
	tempname n beta Var ll ll_0 V_modelbased sample ilog milog

	if ("`rescale1'"!=""|"`rescale'"!="") {
		display as error "option {bf:rescale} not allowed with" ///
			" polynomial regression"
		exit 198
	}
	
	matrix `milog' = J(1, 20, 0)

	quietly count if `touse'
	local N = r(N)
	display ""
	display as txt "Computing approximating function"
	display ""

	if (`polynomial'==-1) {
		local mall "criterion"
		if ("`sname'"=="Mallows's Cp") {
			local mall ""
		}
		display as txt "Minimizing `sname' `mall'"
		if ("`log'"=="") {
			display ""
		}
	} 

	local comparison = .

	local cnointerorig "`cnointer'"
	
	_inter_sec, known(`known') varsuno(`cvars') varsdos(`cvars')	///
		dnoms(`dnoms') cnointer(`cnointer') 			///
		dnointer(`dnointer') cnointerorig(`cnointerorig')	///
		polynomial(`polynomial') espoly primero
		 
	local nomscv   = "`s(nomscv)'"
	local prenoms  = "`s(prenoms)'"
	local cnointer = "`s(cnointer)'"
	local dnointer = "`s(dnointer)'"
	local cantes   = "`s(cantes)'"

	local i        = 1
	local st1      = 0
	local st2      = 0   
	local st3      = 0 
	local j        = -1
	local converge = 0 
	local polk     = 32 
	local isp    = 0 
	
	if (`polynomial'!=-1) {
		local isp = 1 
		local polk = `polynomial' 
		local ilog = 0
	}
	
	while (`st1'==0 & `st2'==0 & `st3'==0 & `j'<`iterate' & ///
		`i'< `polk' & `isp'==0){
		local ilog = 1 
		local j = `i' - 1 
		_cv_compute if `touse' `wgt', vars("`nomscv'") 		///
					      y("`y'")			///
					      criterion("`criterion'")	///
					      `constant' cells(`cells') ///
					      mat(`mat')
		local cv1 = r(cv)
		local err = r(err)
		local regs`i' "`nomscv'"
		local cant`i' "`cantes'"
		if (`i'==1) {
			local cv0 = r(cv)
		}
		if (`cv0'< `cv1' & `isp'==0) {
			local st1 = 1
		}
		if ((reldif(`cv0', `cv1') < `tolerance') & `i'>1 & `isp'==0) {
			local st3 = 1 
		}
		if (`st1'==0 & `st2'==0 & `st3'==0 & `j'<`iterate') {
			if (`isp'==0 & "`log'"=="") {
				local mall "criterion"
				if ("`iname'"=="Mallows's Cp") {
					local mall ""
				}
				display as txt ///
			    "Iteration `j':  `iname' `mall' = " ///
				as result %9.0g `r(cv)'
			}
			matrix `milog'[1,`j'+1] =  r(cv)
			local cv0 = r(cv)	
			_inter_sec, known(`known') varsuno(`prenoms')	///
				varsdos(`cvars') dnoms(`dnoms') 	///
				cnointer(`cnointer') 			///
				dnointer(`dnointer') 			///
				cnointerorig(`cnointerorig')		
			local nomscv   = "`s(nomscv)'"
			local prenoms  = "`s(prenoms)'"
			local cnointer = "`s(cnointer)'"
			local dnointer = "`s(dnointer)'"
			local cantes   = "`s(cantes)'"
			quietly cap fvexpand `nomscv'  if `touse'
			local rc = _rc
			if (`rc') {
				_big_matrix_prob, fvexpand erro(103)					
			}
			local lcoefs = r(varlist)
			local coefs: list sizeof lcoefs
			local limit = (`coefs')
			quietly estat ic 
		}
		local i = `i' + 1	
	}
	local iter = `i' - 1
	if (`isp'==1) {
		local iter = `i' - 1 
		local comparison = .
		local cv0        = .
		local regs`iter' "`nomscv'"
	}
	quietly regress  `y' `regs`iter'' if `touse' `wgt', ///
		`constant' vce(`vce')
	quietly generate `sample' = e(sample)
	_r_squared if `sample', y(`y')
	local rsqs  = r(rsqs)
	local rsqsa = r(rsqsa)
	local norsq = r(norsq)
	matrix `beta' = e(b)
	matrix `Var'  = e(V)
	if ("`e(vce)'"=="robust") {
		matrix  `V_modelbased' = e(V_modelbased)
	}

	local n       = e(N)
	local ll      = e(ll)
	local ll_0    = e(ll_0)
	local r2      = e(r2)
	local r2_a    = e(r2_a)
	local rank    = e(rank)
	local converged = 1
	return scalar rank  = `rank'
	if (`polynomial'!=-1) {
		if ("`cvars'"=="") {
			fvexpand `regs`iter''
			local plista "`r(varlist)'"
			local kord: list sizeof plista
			local k = 1 
			forvalues i=1/`kord' {
				local xpol: word `i' of `plista'
				_ms_parse_parts `xpol'
				local tipo "`r(type)'"
				if ("`tipo'"=="interaction") {
					local knames = r(k_names)
					local k = max(`k', `knames')
				}
			}
			return scalar order = `k'
		}
		else {
			return scalar order = `polynomial'
		}
	}
	else {
		if ("`cvars'"=="") {
			fvexpand `regs`iter''
			local plista "`r(varlist)'"
			local kord: list sizeof plista
			local k = 1 
			forvalues i=1/`kord' {
				local xpol: word `i' of `plista'
				_ms_parse_parts `xpol'
				local tipo "`r(type)'"
				if ("`tipo'"=="interaction") {
					local knames = r(k_names)
					local k = max(`k', `knames')
				}
			}
			return scalar order = `k'
		}
		else {
			return scalar order = `iter' 
		}
	}
	return scalar r2    = `rsqs' 
	if (`ilog') {
		return matrix milog = `milog'
	}
	return local ilog   = `ilog'
	return scalar r2_a  = `rsqsa' 
	return scalar norsq = `norsq'
	return scalar converged = `converged'
	return scalar ll       = `ll'
	return scalar ll_0     = `ll_0'
	return local cv        = `cv0'
	return matrix b        = `beta'
	return hidden local cantes "`cant`iter''"
	*return scalar comparison = `comparison'
	return matrix V        = `Var'
	if ("`e(vce)'"=="robust") {
		return matrix  V_modelbased = `V_modelbased'
	}
	return local vce  "`e(vce)'"
	return local vcetype "`e(vcetype)'"
	return hidden local regressors "`regs`iter''"
end 

program define _criterion_spline, rclass
	syntax [if] [in] [fw pw iw], [orden(integer 3) 		///
				      cvars(string)		///
				      knots(string) 		///
				      vars(string)		///
				      y(string)			///
				      noCONstant		///
				      noLOg			///
				      criterion(string)		///
				      known(string)		///
				      ITERate(integer 1000)	///
				      TOLerance(real 1e-4)	///
				      cells(string)		///
				      mat(string)		///
				      dnp(string)		///
				      vce(string)		///
				      cname(string)		///
				      iname(string)		///
				      rescale(string)		///
				      sname(string)		///
				      predict(string)		///
				      csvars(string)		///
				      dvars(string)		///
				      matcint(string)		///
				      matdint(string)		///
				      knotsmat(string)		///
				      uniformknots		///
				      *				///
				     ] 
	marksample touse 
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
	}
	
	tempname n beta Var ll ll_0 matknots matmm matmm2	///
		 V_modelbased sample matc matd milog 
	
	quietly count if `touse'
	local N = r(N)
	display ""
	display as txt "Computing approximating function"
	display ""

	local st4 = 0 
	local nudos "`knots'"

	if ("`knots'"=="" | "`knotsmat'"!=""){
		local mall "criterion"
		if ("`sname'"=="Mallows's Cp") {
			local mall ""
		}
		display as txt "Minimizing `sname' `mall'"
		if ("`log'"=="") {
			display ""
		}
		local knots = 1 
		if ("`knotsmat'"!="") {
			local knots = colsof(`knotsmat')
		}
	} 
	
	matrix `matc' = `matcint'
	matrix `matd' = `matdint'
	
	_making_knots if `touse' `wgt',  predict(`predict') 		///
					knots(`knots') cvars(`cvars')	///
					vars(`vars') orden(`orden')	///
					csvars(`csvars') dvars(`dvars') ///
					primero `rescale1' 		///
					rescale(`rescale') dnp(`dnp')	///
					knotsmat(`knotsmat') 		///
					`uniformknots' known(`known')	///
					matcint(`matc') matdint(`matd')	
	local nomscv = "`r(nomscv)'"
	local notsp       = "`r(notsp)'"
	local dinter  "`r(dinter)'"
	local renoms "`r(renoms)'"
	local checknoms "`r(checknoms)'"
	
	matrix `matknots' = r(matknots)
	matrix `matmm'    = r(matmm)
	matrix `matmm2'    = r(matmm2)

	quietly cap fvexpand `nomscv'  if `touse'
	local rc = _rc
	if (`rc') {
		_big_matrix_prob, fvexpand			
	}
	
	local i        = 1
	local st1      = 0
	local st2      = 0   
	local st3      = 0 
	local j        = -1
	local converge = 0 
	matrix `milog' = J(1, 20, 0)
	
	if ("`nudos'"!="" | "`knotsmat'"!="") {
		local st4 = 1 
		capture regress  `y' `nomscv' if `touse' `wgt', ///
		`constant' notable noheader vce(`vce')
		local rc = _rc
		if (`rc') {
			display as err "while computing the regression model"
			cap noi regress  `y' `nomscv' if `touse' `wgt', ///
			`constant' vce(`vce') noomitted
			exit `rc'
		}
		local ilog = 0 
	}
	while (`st1'==0 & `st2'==0 & `st3'==0 & `j'<`iterate' & `st4'==0){
		local ilog = 1 
		local j = `i' - 1 
		local knots0 = `knots'
		local knots  = `knots'*2 + 1
		_cv_compute if `touse' `wgt', vars("`nomscv'") 		///
					      y("`y'")			///
					      criterion("`criterion'")	///
					      `constant' cells(`cells') ///
					      mat(`mat')	
		local cv1 = r(cv)
		local err = r(err)
		local regs`i' "`nomscv'"
		if (`i'==1) {
			local cv0 = r(cv)
		}
		if (`cv0'< `cv1') {
			local st1 = 1
		}
		if ((reldif(`cv0', `cv1') < `tolerance') & `i'>1) {
			local st3 = 1 
		}
		if (`st1'==0 & `st2'==0 & `st3'==0 & `j'<`iterate') {
			if ("`log'"=="") {
				local mall "criterion"
				if ("`iname'"=="Mallows's Cp") {
					local mall ""
				}
				display as txt ///
				"Iteration `j':  `iname' `mall' = " ///
				as result %9.0g `r(cv)'
			}
			local cv0 = r(cv)
			matrix `milog'[1,`j'+1] =  r(cv)
			_making_knots if `touse' `wgt',  	///
					predict(`predict')	///	 		
					knots(`knots') 		///
					cvars(`cvars')		///
					vars(`vars') 		///
					orden(`orden')		///
					csvars(`csvars') 	///
					`rescale1'		///
					dvars(`dvars')		///
					dnp(`dnp')		///
					rescale(`rescale')	///
					known(`known')		///
					matcint(`matc')		///
					matdint(`matd')		///
					`uniformknots'	
			local nomscv      = "`r(nomscv)'"
			local notsp       = "`r(notsp)'"
			local checknoms "`r(checknoms)'"
			matrix `matknots' = r(matknots)
			quietly cap fvexpand `nomscv'  if `touse'
			local rc = _rc
			if (`rc') {
				_big_matrix_prob, fvexpand
				local rc = _rc					
			}
			local lcoefs = r(varlist)
			local coefs: list sizeof lcoefs
			local limit = (`coefs')
			local i = `i' + 1
		}
	} 	
	if ("`nudos'"!="" | "`knotsmat'"!="") {
		quietly regress, noomitted
		_r_squared, y(`y')
		local rsqs  = r(rsqs)
		local rsqsa = r(rsqsa)
		local norsq = r(norsq)
	}
	else {
		capture drop *knot*
		if ("`predict'"!="") {
			local predict0 "`predict'"
			gettoken dpredict predict0: predict0, parse(,)
			capture drop `dpredict'*
		}
		if ("`rescale'"!="") {
			local rescale0 "`rescale'"
			gettoken drescale rescale0: rescale0, parse(,)
			capture drop `drescale'*
		}
		local knots = (`knots0' - 1)/2
		_making_knots if `touse' `wgt',  	///
		predict(`predict')			///	 		
		knots(`knots') 				///
		cvars(`cvars')				///
		vars(`vars') 				///
		orden(`orden')				///
		csvars(`csvars') 			///
		dvars(`dvars')				///
		dnp(`dnp')				///
		`rescale1'				///
		rescale(`rescale')			///
		known(`known')				///
		matcint(`matc') 			///
		matdint(`matd')				///
		`uniformknots'	
		local nomscv      = "`r(nomscv)'"
		local dinter  "`r(dinter)'"
		local renoms "`r(renoms)'"
		local checknoms "`r(checknoms)'"
		matrix `matknots' = r(matknots)
		matrix `matmm'    = r(matmm)
		matrix `matmm2'   = r(matmm2)
		quietly regress  `y' `nomscv' if `touse' `wgt', ///
		`constant' vce(`vce') 
		quietly generate `sample' = e(sample)
		_r_squared if `sample', y(`y')
		local rsqs  = r(rsqs)
		local rsqsa = r(rsqsa)
		local norsq = r(norsq)
	}

	matrix `beta' = e(b)
	matrix `Var'  = e(V)
	if ("`e(vce)'"=="robust") {
		matrix  `V_modelbased' = e(V_modelbased)
	}
	local n       = e(N)
	local ll      = e(ll)
	local ll_0    = e(ll_0)
	local r2      = e(r2)
	local r2_a    = e(r2_a)
	local rank    = e(rank)
	local converged = 1
	return scalar rank  = `rank'
	if (`ilog') {
		return matrix milog = `milog'
	}
	return local ilog   = `ilog'
	return scalar order = `orden'
	return scalar r2    = `rsqs' 
	return scalar r2_a  = `rsqsa' 
	return scalar norsq = `norsq'
	return scalar converged = `converged'
	return scalar ll       = `ll'
	return scalar ll_0     = `ll_0'
	return matrix b        = `beta'
	return matrix V        = `Var'
	if ("`e(vce)'"=="robust") {
		return matrix  V_modelbased = `V_modelbased'
	}
	return local vce  "`e(vce)'"
	return local vcetype "`e(vcetype)'"
	return hidden local regressors "`nomscv'"
	return local dinter "`dinter'"
	return scalar nudos = `knots'
	if ("`nudos'"=="" & "`knotsmat'"=="") {
		return local cv        = `cv0'
	}
	return hidden local notsp "`notsp'"
	return hidden local issp "`issp'"
	return hidden local renoms "`renoms'"
	return hidden local checknoms "`checknoms'"
	return hidden matrix matknots = `matknots'
	return hidden matrix matmm    = `matmm'
	return hidden matrix matmm2   = `matmm2'
end

program define _criterion_bspline, rclass
	syntax [if] [in] [fw pw iw], [orden(integer 3) 		///
				      cvars(string)		///
				      knots(string) 		///
				      vars(string)		///
				      y(string)			///
				      noCONstant		///
				      noLOg			///
				      criterion(string)		///
				      known(string)		///
				      ITERate(integer 1000)	///
				      TOLerance(real 1e-4)	///
				      cells(string)		///
				      mat(string)		///
				      vce(string)		///
				      cname(string)		///
				      iname(string)		///
				      sname(string)		///
				      predict(string)		///
				      rescale(string)		///
				      csvars(string)		///
				      dvars(string)		///
				      dnp(string)		///
				      matcint(string)		///
				      matdint(string)		///
				      knotsmat(string)		///
				      uniformknots		///
				      *				///
				     ] 
	marksample touse 
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
	}
	
	tempname n beta Var ll ll_0 matknots matmm matmm2 V_modelbased	///
		 tmpkn sample matc matd milog 
	
	quietly count if `touse'
	local N = r(N)
	display ""
	display as txt "Computing approximating function"
	display ""
	
	local st4 = 0 
	local nudos "`knots'"
	
	if ("`knots'"=="" & "`knotsmat'"==""){
		local mall "criterion"
		if ("`sname'"=="Mallows's Cp") {
			local mall ""
		}
		display as txt "Minimizing `sname' `mall'"
		if ("`log'"=="") {
			display ""
		}
		local knots = 1
	} 
	if ("`knotsmat'"!="") {
		matrix `tmpkn' = `knotsmat'
		local knots = colsof(`tmpkn')
	}
	
	matrix `matc' = `matcint'
	matrix `matd' = `matdint'
	matrix `milog' = J(1, 20, 0)
	
	_making_bsknots if `touse' `wgt',  predict(`predict') 		///
				  knots(`knots') cvars(`cvars')		///
				  vars(`vars') orden(`orden')		///
				  csvars(`csvars') dvars(`dvars')	///
				  primero dnp(`dnp') 			///
				  knotsmat(`knotsmat') `uniformknots'	///
				  rescale(`rescale') known(`known')	///
				  matcint(`matc') matdint(`matd')	
	local nomscv = "`r(nomscv)'"
	local notsp  = "`r(notsp)'"
	local dinter  "`r(dinter)'"
	local renoms "`r(renoms)'"
	local checknoms "`r(checknoms)'"
	matrix `matknots' = r(matknots)
	matrix `matmm'    = r(matmm)
	matrix `matmm2'   = r(matmm2)
	quietly cap fvexpand `nomscv'  if `touse'
	local rc = _rc
	if (`rc') {
		_big_matrix_prob, fvexpand				
	}
	
	local i        = 1
	local st1      = 0
	local st2      = 0   
	local st3      = 0 
	local j        = -1
	local converge = 0 
	
	if ("`nudos'"!="" | "`knotsmat'"!="") {
		local st4 = 1 
		capture _cv_compute  if `touse' `wgt', vars("`nomscv'") ///
					       y("`y'")			///
					      criterion("`criterion'")	///
					      `constant'  		///
					      cells(`cells') 		///
					      mat(`mat')
		local cv0 = r(cv)
		capture regress  `y' `nomscv' if `touse' `wgt', ///
		`constant' notable noheader vce(`vce')
		local rc = _rc
		if (`rc') {
			display as err "while computing the regression model"
			cap noi regress  `y' `nomscv'  if `touse' `wgt', ///
				`constant' vce(`vce') noomitted	
			exit `rc'
		}
		local ilog = 0 
	}
	while (`st1'==0 & `st2'==0 & `st3'==0 & `j'<`iterate' & `st4'==0){
		local ilog = 1 
		local j = `i' - 1 
		local knots0 = `knots'
		local knots  = `knots'*2 + 1
		_cv_compute  if `touse' `wgt', vars("`nomscv'") 	///
					       y("`y'")			///
					      criterion("`criterion'")	///
					      `constant'  		///
					      cells(`cells') 		///
					      mat(`mat')	
		local cv1 = r(cv)
		local err = r(err)
		local regs`i' "`nomscv'"
		if (`i'==1) {
			local cv0 = r(cv)
		}
		if (`cv0'< `cv1') {
			local st1 = 1
		}
		if ((reldif(`cv0', `cv1') < `tolerance') & `i'>1) {
			local st3 = 1 
		}
		if (`st1'==0 & `st2'==0 & `st3'==0 & `j'<`iterate') {
			if ("`log'"=="") {
				local mall "criterion"
				if ("`iname'"=="Mallows's Cp") {
					local mall ""
				}
				display as txt ///
				"Iteration `j':  `iname' `mall' = " ///
				as result %9.0g `r(cv)'
			}
			local cv0 = r(cv)
			matrix `milog'[1,`j'+1] =  r(cv)
			_making_bsknots if `touse',  		///
					predict(`predict')	///	 		///
					knots(`knots') 		///
					cvars(`cvars')		///
					vars(`vars') 		///
					orden(`orden')		///
					csvars(`csvars') 	///
					dvars(`dvars')		///
					dnp(`dnp')		///
					rescale(`rescale')	///
					known(`known')		///
					matcint(`matc') 	///
					matdint(`matd')		///
					`uniformknots'		
			local nomscv      = "`r(nomscv)'"
			local notsp       = "`r(notsp)'"
			matrix `matknots' = r(matknots)
			local catnames    = "`r(catnames)'"
			quietly cap fvexpand `nomscv'  if `touse'
			local rc = _rc
			if (`rc') {
				_big_matrix_prob, fvexpand					
			}
			local lcoefs = r(varlist)
			local coefs: list sizeof lcoefs
			local limit = (`coefs')
			local i = `i' + 1
		}
	} 	
	if ("`nudos'"!=""| "`knotsmat'"!="") {
		quietly regress, noomitted
		quietly generate `sample' = e(sample)
		_r_squared if `sample', y(`y')
		local rsqs  = r(rsqs)
		local rsqsa = r(rsqsa)
		local norsq = r(norsq)
	}
	else {
		capture drop *__b*
		if ("`predict'"!="") {
			local predict0 "`predict'"
			gettoken dpredict predict0: predict0, parse(,)
			capture drop `dpredict'*
		}
		if ("`rescale'"!="") {
			local rescale0 "`rescale'"
			gettoken drescale rescale0: rescale0, parse(,)
			capture drop `drescale'*
		}
		local knots = (`knots0' - 1)/2
		_making_bsknots if `touse',  		///
		predict(`predict')			///	 		
		knots(`knots') 				///
		cvars(`cvars')				///
		vars(`vars') 				///
		orden(`orden')				///
		csvars(`csvars') 			///
		dvars(`dvars')				///
		rescale(`rescale')			///
		dnp(`dnp')				///
		known(`known')				///
		matcint(`matc') 			///
		matdint(`matd')				///
		`uniformknots'				
		local nomscv      = "`r(nomscv)'"
		local dinter  "`r(dinter)'"
		local renoms "`r(renoms)'"
		local catnames ="`r(catnames)'"
		local checknoms "`r(checknoms)'"
		matrix `matknots' = r(matknots)
		matrix `matmm'    = r(matmm)
		matrix `matmm2'   = r(matmm2)
		quietly regress  `y' `nomscv'  if `touse' `wgt', ///
		`constant' vce(`vce') 
		quietly generate `sample' = e(sample)
		_r_squared if `sample', y(`y')
		local rsqs  = r(rsqs)
		local rsqsa = r(rsqsa)
		local norsq = r(norsq)
	}
	matrix `beta' = e(b)
	matrix `Var'  = e(V)
	if ("`e(vce)'"=="robust") {
		matrix  `V_modelbased' = e(V_modelbased)
	}
	local n       = e(N)
	local ll      = e(ll)
	local ll_0    = e(ll_0)
	local r2      = e(r2)
	local r2_a    = e(r2_a)
	local rank    = e(rank)
	local converged = 1
	return scalar rank  = `rank'
	return scalar order = `orden'
	return scalar r2    = `rsqs' 
	return scalar r2_a  = `rsqsa' 
	return scalar norsq = `norsq'
	if (`ilog') {
		return matrix milog = `milog'
	}
	return local ilog   = `ilog'
	return scalar converged = `converged'
	if ("`nudos'"=="" & "`knotsmat'"=="") {
		return local cv        = `cv0'
	}
	/*else {
		return local cv = `ll'
	}*/
	return scalar ll       = `ll'
	*return local cv        = `ll'
	return scalar ll_0     = `ll_0'
	return matrix b        = `beta'
	return matrix V        = `Var'
	if ("`e(vce)'"=="robust") {
		return matrix  V_modelbased = `V_modelbased'
	}
	return local vce  "`e(vce)'"
	return local renoms "`renoms'"
	return local vcetype "`e(vcetype)'" 
	return hidden local regressors "`nomscv'"
	return hidden local catnames "`catnames'"
	return scalar nudos = `knots'
	return hidden local notsp "`notsp'"
	return hidden local issp "`issp'"
	return local dinter "`dinter'"
	return hidden local checknoms "`checknoms'"
	return hidden matrix matknots = `matknots'
	return hidden matrix matmm    = `matmm'
	return hidden matrix matmm2   = `matmm2'
end

program define _ccheck, sclass
	syntax, criterion(string)
	local ccheck = inlist("`criterion'", "cv", "gcv", 	///
			      "aic", "bic", "mallows")
	if (`ccheck'==0) {
		display as error ///
			"{bf:criterion()} `criterion' not allowed"
		di as err "{p 2 2 2}" 
		di as smcl as err "{bf:criterion()} should be one of" 
		di as smcl as err "{bf: cv}, {bf:gcv}, {bf:aic}, {bf:bic},"
		di as smcl as err " or {bf:mallows}."
		di as smcl as err "{p_end}"
		exit 198
	}
	if ("`criterion'"=="cv") {
		sreturn  local cname "cross validation"
		sreturn  local sname "cross-validation"
		sreturn local iname "Cross-validation"
	}
	if ("`criterion'"=="gcv") {
		sreturn local cname "generalized cross validation"
		sreturn local sname "generalized cross-validation"
		sreturn local iname "Generalized cross-validation"
	}
	if ("`criterion'"=="mallows") {
		sreturn local cname "Mallows's Cp"
		sreturn local iname "Mallows's Cp"
		sreturn local sname "Mallows's Cp"
	}
	if ("`criterion'"=="aic") {
		sreturn local cname "Akaike's information"
		sreturn local iname "Akaike's information"
		sreturn local sname "Akaike's information"
	}
	if ("`criterion'"=="bic") {
		sreturn local cname "Bayesian information"
		sreturn local iname "Bayesian information"
		sreturn local sname "Bayesian information"
	}
	sreturn local crit = "`criterion'"
end

program define _level_err
	syntax varname(numeric fv), [inter minlevel(integer 10)]
	local blb ""
	if ("`inter'"!="") {
		local blb "for the {bf:nointeract()} option "
	}
	capture tab `varlist'
	local rc  = _rc
	local levs = r(r)
	if (`rc'==0 & `levs'>=10 & `levs'<=20) {
		di as txt "{p 0 8 2}" 					///
"warning: `blb'you have entered variable {bf:`varlist'} as"		///
" continuous but it only has `levs' distinct values. "			///
" The estimates may differ substantially if you "		   		///	
" inadvertently include a discrete variable as continuous {p_end}"				
	}
	if (`rc'==0 & `levs'<`minlevel') {
		di as error "`blb'variable {bf:`varlist'} has too"	///
		" few distinct values"
		di as err "{p 4 4 2}" 
		di as smcl as err "{bf:`varlist'} has less than `minlevel'"
		di as smcl as err "distinct values."
		di as smcl as err "Please  use i.`varlist' to enter"
		di as smcl as err "{bf:`varlist'} as a discrete covariate"
		di as smcl as err "or use the {bf:distinct()} option to"
		di as smcl as err "change the minimum number of distinct "
		di as smcl as err "values that determines when a variable is"
		di as smcl as err "continuous."
		di as smcl as err "{p_end}"
		exit 198
	 }

end

program define _inter_sec, sclass 
	syntax  [if] [in] [fw pw iw], [known(string)		///
				      varsuno(string)		///
				      varsdos(string)		///
				      (string)			///
				      zero			///
				      dnoms(string)		///
				      cnointer(string)		///
				      cnointerorig(string)	///
				      dnointer(string)		///
				      polynomial(integer -1)	///
				      espoly			///
				      primero			///
				      noCONstant]
				   
	marksample touse 	
	if ("`known'"=="") {
		local nomscv "(`varsuno')##(`varsdos')"		
		if ("`zero'"!="") {
			local nomscv "`varsuno'"
		}
		local prenoms "`nomscv'"
		if ("`espoly'"!="") {
			local prenoms "`varsuno'"
			local nomscv "`varsuno'"
		}
	}
	else {
		local prenoms "(`varsuno')##(`varsdos')"		
		if ("`zero'"!=""|"`espoly'"!="") {
			local prenoms "`varsuno'"
		}
		local prenom: list prenoms | known
		quietly _rmcoll `prenom' if `touse', `constant'
		local pre = r(varlist)
		fvexpand `pre'  if `touse'
		local nomscv0 = r(varlist)
		_give_me_cvars, vars(`nomscv0')
		local nomscv = "`s(varsane)'"
		fvexpand `known' if `touse'
		local knownpre = r(varlist)
		_give_me_cvars, vars(`knownpre')
		local knownpre = "`s(varsane)'"
		if ("`known'"!="") {
			local nomscv: list nomscv - knownpre
		}
	}
	if (`polynomial'>1 & `polynomial'!=.) {
		local kpol = `polynomial'-1
		local nomscv1 "`nomscv'"
		forvalues i=1/`kpol' {
			local nomscv "(`nomscv')##(`nomscv1')"
		}
	}
	local cantes "`nomscv'"
	if ("`dnoms'"!="") {
		_dvar_inter_new, dvars(`dnoms')
		local dnoms "`s(dinter)'"
		local nomscv "(`nomscv')##(`dnoms')"
	}
	if ("`cnointer'"!="" | "`dnointer'"!="") {
		local k: list sizeof cnointer 
		forvalues i=1/`k' {
			local x: word `i' of `cnointer'
			local y: word `i' of `cnointerorig'
			if ("`primero'"=="") {
				local cfinal "`cfinal' `x'##`y'"
			}
			else {
					local cfinal "`cfinal' `y'"
			}
		}
		if (`polynomial'==-1) {
			local nomscv "`nomscv' `cfinal' `dnointer'"		
		}
		else {
			local nomscv "`nomscv' `cnointerorig' `dnointer'"			
		}
	}
	if ("`known'"!="") {
			local nomscv "`nomscv' `knownpre'"
	}

	sreturn local prenoms "`prenoms'"
	sreturn local nomscv "`nomscv'"
	sreturn local cnointer "`cfinal'"
	sreturn local dnointer "`dnointer'"
	sreturn local cantes "`cantes'"

end 

program define _big_matrix_prob
	syntax, [fvexpand erro(integer 0)]
	if ("`fvexpand'"!="" & `erro'==103) {
		di as err "polynomial estimator implied by data is too large"
		di as err "{p 4 4 2}" 					 
		di as smcl as err "The optimizer suggests that your model is "
		di as smcl as err "best approximated by a polynomial of order" 
		di as smcl as err "8 or greater. Please consider a spline model"   
		di as smcl as err "instead."  
		di as smcl as err "{p_end}"	
		exit 198	
	}
	else {
		local maxv "`c(maxvar)'"
		display as err "maxvar too small"
		di as err "{p 4 4 2}" 	
		di as smcl as err "The model implied has more than"
		di as result in red %13.0gc `maxv'
		di as smcl as err " regressors. "
		di as smcl as err "You need to increase maxvar; it is "
		di as smcl as err "currently;"
		di as result in red %13.0gc `maxv' _c
		di as smcl as err ". Use {cmd:set maxvar};"
		di as smcl as err "see help {help maxvar}."
		di as smcl as err "{p_end}"
		di 
		di as err "{p 4 4 2}" 	
		di as smcl as err "You may reduce the complexity of"
		di as smcl as err " your model using the {bf:asis()}"
		di as smcl as err " option to exclude some terms from the"
		di as smcl as err " series search or the {bf:nointeract()}"
		di as smcl as err " option to exclude terms from interactions."
		di as smcl as err "{p_end}"
		di 
		di as err "{p 4 4 2}" 	
		di as smcl as err "If you are using "
		di as smcl as err "{help fvvarlist:factor variables} and "
		di as smcl as err "included an interaction that has lots of "
		di as smcl as err " missing cells, try "
		di as smcl as err "{cmd:set emptycells drop} to "
		di as smcl as err "reduce the required matrix size; see help "
		di as smcl as err "{help set emptycells}."
		di as smcl as err "{p_end}"
		exit 198
	}
end

program define _crit_stripe, sclass
	syntax, [criterion(string)]
	
	local cvstrip   "cross-validation"
	local iterstrip "Cross-validation"
	
	if ("`criterion'"=="gcv") {
		local cvstrip   "generalized cross-validation"
		local iterstrip "Generalized cross-validation"
	}
	if ("`criterion'"=="mallows") {
		local cvstrip   "mallows's cp"
		local iterstrip "Mallows's Cp"
	}
	if ("`criterion'"=="aic" | "`criterion'"=="bic") {
		estat ic
		matrix `ic' = r(S)
		scalar aic = `ic'[1,5]
		scalar bic = `ic'[1,6]
		if ("`criterion'"=="aic") {
			scalar cvc = aic 
		}
		if ("`criterion'"=="bic") {
			scalar cvc = bic 
		}
	}
end

program define _series_opts, rclass
	syntax [if] [in], [polynomial(string)	///
	                   spline(string) 	///
			   SPLINEs1 		///
			   BSPLINEs1		///
			   POLYnomial1		///
			   bspline(string)	///
			   knots(string)]
	marksample touse
	local options =  ("`polynomial'"!="")  +  ("`spline'"!="") +	///
			 ("`splines1'"!="")     + ("`bsplines1'"!="") +	///
			 ("`bspline'"!="") + ("`polynomial1'"!="")	
	
	local estis  = 3
	local prelist "{bf:bspline()}, {bf:polynomial()}, {bf:spline()}, "
	local lista "`prelist' {bf:bspline}, {bf:polynomial}, or {bf:spline}"
	
	if (`options'>1) {
		display as error "you may use at most one of `lista'"
		exit 198
	}
	if ("`knots'"!="" & ("`spline'"!=""|"`splines1'"!="")) {
		_string_or_real if `touse', mystring("`knots'") optn("knots")
		quietly count if `touse'
		local N = min(int(r(N)*(2/3)), 4096)
		if (`knots'<1 | `knots'> `N') {
			display as error "option {bf:knots()} "	///
				"incorrectly specified"
			di as err "{p 2 2 2}" 			
			di as smcl as err " {bf:knots()} should be an integer"
			di as smcl as err " between 1 and `N'."
			di as smcl as err "{p_end}"
			di as smcl as err "{p_end}"			
			exit 198		
		}
	}
	if ("`knots'"!="" & ("`spline'"==""|"`splines1'"=="")) {
		_string_or_real if `touse', mystring("`knots'") optn("knots")
		quietly count if `touse'
		local N = min(int(r(N)*(2/3)), 4096)
		if (`knots'<1 | `knots'> `N') {
			display as error "option {bf:knots()} "	///
				"incorrectly specified "
			di as err "{p 2 2 2}" 		
			di as smcl as err " {bf:knots()} should be an integer"
			di as smcl as err " between 1 and `N'."
			di as smcl as err "{p_end}"			
			exit 198		
		}
	}
	if ("`polynomial'"!="") {
		_string_or_real if `touse', mystring("`polynomial'")	///
			optn("polynomial")
		if ((`polynomial'<1) | `polynomial'>32) {
			display as error "option {bf:polynomial()} "	///
				"incorrectly specified "
			di as err "{p 2 2 2}" 		
			di as smcl as err "{bf:polynomial()} should be an"
			di as smcl as err " integer between 1 and 16"
			di as smcl as err "{p_end}"			
			exit 198
		}
	}
	if ("`spline'"!="") {
		_string_or_real if `touse', mystring("`spline'") optn("spline")
		if ((`spline'<1) | `spline'>3) {
			display as error "option {bf:spline()} incorrectly" ///
				" specified"
			di as err "{p 2 2 2}" 		
			di as smcl as err "spline may be of order 1, 2, or 3."
			di as smcl as err "{p_end}"			
			exit 198
		}
	}
	if ("`bspline'"!="") {
		_string_or_real if `touse', mystring("`bspline'")	///
			optn("bspline")
		if ((`bspline'<1) | `bspline'>3) {
			display as error "option {bf:bspline()} incorrectly" ///
				" specified"
			di as err "{p 2 2 2}" 		
			di as smcl as err ///
				"{bf:bspline()} may be of order 1, 2, or 3."
			di as smcl as err "{p_end}"			
			exit 198
		}
	}
	if ("`polynomial1'"!=""|"`polynomial'"!="") {
		local estis  = 1
		if ("`polynomial'"!="") {
			local sorder = `polynomial' 
		}
		else {
			local sorder = 1 		
		}
		return local sorder = `sorder'
	}
	if ("`splines1'"!="") {
		return local stit "Cubic-spline estimation"
		return local sorder = 3
		local estis  = 2
	}
	if ("`bsplines1'"!=""|`options'==0) {
		return local stit "Cubic B-spline estimation"
		return local sorder = 3
		local estis  = 3
	}
	if ("`spline'"!="") {
		if (`spline'==1) {
			return local stit "Linear-spline estimation"		
		}
		if (`spline'==2) {
			return local stit "Quadratic-spline estimation"		
		}
		if (`spline'==3) {
			return local stit "Cubic-spline estimation"		
		}
		return local sorder = `spline'
		local estis  = 2
	}
	if ("`bspline'"!="") {
		if (`bspline'==1) {
			return local stit "Linear B-spline estimation"		
		}
		if (`bspline'==2) {
			return local stit "Quadratic B-spline estimation"		
		}
		if (`bspline'==3) {
			return local stit "Cubic B-spline estimation"		
		}
		return local sorder = `bspline'
		local estis  = 3
	}
	local fijo = 0 
	if ("`polynomial'"!="" | "`knots'"!="") {
		local fijo = 1
	}
	return local fijo  = `fijo'
	return local estis = `estis'
end

program define _string_or_real 
	syntax [if][in], [mystring(string) optn(string)]
	marksample touse 
	quietly count if `touse'
	local N = min(int(r(N)*2/3), 4096)
	local sp = real("`mystring'")
	if (`sp'==.) {
		display as error "option {bf:`optn'()} "	///
			"incorrectly specified"
		di as err "{p 2 2 2}" 		
		di as smcl as err " You should specify an"
		di as smcl as err " integer not a string."
		di as smcl as err "{p_end}"		
		exit 198		
	}
	if (int(`mystring')!=`mystring') {
		display as error "option {bf:`optn'()} "	///
			"incorrectly specified"
		if ("`optn'"=="bspline"|"`optn'"=="spline") {
			di as err "{p 2 2 2}" 		
			di as smcl as err ///
				"{bf:`optn'()} may be of order 1, 2, or 3."
			di as smcl as err "{p_end}"	
		}
		if ("`optn'"=="knots"){
			di as err "{p 2 2 2}" 		
			di as smcl as err "{bf:`optn'()} should be an"
			di as smcl as err " integer between 1 and `N'"
			di as smcl as err "{p_end}"		
		}
		exit 198		
	}
end

program define _making_knots, rclass 
	syntax [if][in][fw pw iw], [predict(string) knots(integer 1)	///
		 cvars(string) vars(string) orden(integer 3) 		///
		 csvars(string)	dvars(string) inside primero 		///
		 iter(integer 1) known(string)				///
		 dnp(string) rescale(string)  knotsmat(string)		///
		 uniformknots matcint(string) matdint(string)]	
	
	marksample touse 
	tempname matxk matxn matmm mgn mgn0 matmm2 matc matd 
	tempvar launiforme
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
	}

	if ("`matcint'"!="") {
		matrix `matc' = `matcint'
	}
	else {
		matrix `matc' = .
	}
	if ("`matdint'"!="") {
		matrix `matd' = `matdint'
	}
	else {
		matrix `matd' = . 
	}
	
	_parse_predict `predict'
	local mypre = r(mypre)
	local pname = `"`r(pname)'"'

	_parse_predict `rescale'
	local myprer = r(mypre)
	local pnamer = `"`r(pname)'"'
	
	local k:  list sizeof cvars
	local l   = `knots'
	local k2  = 1 
	local p   = `orden'
	local cnames ""
	if ("`cvars'"!= "") {
		if ("`knotsmat'"!="") {
			matrix `mgn0' = `knotsmat'
		}
		matrix `mgn' = J(`k', `l', .)
		matrix `matxk'  = J(`k', `l', 0)
		matrix `matmm'  = J(`k', 2, 0)
		matrix `matmm2' = J(`k', 2, .)
		forvalues i=1/`k' {
			local x: word `i' of `cvars'
			_ms_parse_parts `x'
			local xlabel "`r(name)'"
			quietly summarize `x' if `touse' `wgt', meanonly 
			matrix `matmm2'[`i',1] = r(min)
			matrix `matmm2'[`i',2] = r(max)
			local xe "`x'"
			capture noisily break {
				if (`myprer'==1) {
					capture drop __x`i'rs
					qui summarize `x' if `touse' `wgt', ///
						meanonly 
					matrix `matmm'[`i',1] = r(min)
					matrix `matmm'[`i',2] = r(max)
					quietly generate double	///
						__x`i'rs =	///
						(`x' - r(min))	///
						/(r(max)-r(min))	///
						if `touse'
					local xe "__x`i'rs"
					label var `xe' ///
						"`xlabel' rescaled to [0,1]"
					local renoms "`renoms' `xe'"
					if (`matc'[1,`i']!=0) {
						local checknoms ///
						"`checknoms' `xe'"
					}
				}
				if (`myprer'==2) {
					cap confirm variable `pnamer'`i'
					local rc = _rc
					if (`rc'==0 & "`primero'"!="") {
		display as error ///
		"variable {bf:`pnamer'`i'} already defined" 
		di as err "{p 4 4 2}" 
		di as smcl as err "If you want to replace {bf:`pnamer'`i'} " 
		di as smcl as err "you may use the {bf:replace} option of " 
		di as smcl as err "{bf:rescale()}." 
		di as smcl as err "{p_end}"
		exit 198
					}
					if ("`primero'"=="") {
						capture drop `pnamer'`i'
					}
					qui summarize `x' if `touse' ///
					`wgt', meanonly 
					matrix `matmm'[`i',1] = r(min)
					matrix `matmm'[`i',2] = r(max)
					quietly generate double	///
						`pnamer'`i' =	///
						(`x' - r(min))	///
						/(r(max)-r(min))	///
						if `touse'
					local xe "`pnamer'`i'"	
					label var `xe'	///
						"`xlabel' rescaled to [0,1]"
					local renoms "`renoms' `pnamer'`i'"
					if (`matc'[1,`i']!=0) {
						local checknoms ///
						"`checknoms' `pnamer'`i'"
					}
				}
				if (`myprer'==3) {
					capture drop `pnamer'`i'
					qui summarize `x' if `touse'	///
					`wgt', meanonly 
					matrix `matmm'[`i',1] = r(min)
					matrix `matmm'[`i',2] = r(max)
					quietly generate double		///
						`pnamer'`i' =	 	///
						(`x' - r(min))/		///
						(r(max)-r(min))	 ///
						if `touse'
					local xe "`pnamer'`i'"	
					label var `pnamer'`i' ///
					"`xlabel' rescaled to [0,1]"	
					local renoms "`renoms' `pnamer'`i'"
					if (`matc'[1,`i']!=0) {
						local checknoms ///
						"`checknoms' `pnamer'`i'"
					}
				}
				if (`p'==1) {
					local xint`i' "c.`xe'"
				}
				if (`p'==2) {
					local xint`i' "c.`xe'##c.`xe'"
				}
				if (`p'==3) {
					local xint`i' ///
						"c.`xe'##c.`xe'##c.`xe'"
				}
				if ("`knotsmat'"=="") {
					local knotsnew = `knots' + 1 
					if (`knotsnew'>4097) {
						if ("`uniformknots'"!="") {
	local untx "Using evenly spaced knots with the"
	local untx2 " {bf:uniform} option may be helpful"
						}
		display as error "too many knots"
		di as err "{p 4 4 2}" 
		di as smcl as err "The potential model could have "
		di as smcl as err "more than 4,096 knots. `untx' `untx2'." 
		di as smcl as err "{p_end}"
		exit 198
					}
					if (`knotsnew'<2) {
						display as error ///
						"you must have more " ///
						" than 1 knot"
						exit 198		
					}
					if (`knotsnew'>1 & `knotsnew'<=4097) {
						_ms_parse_parts `xe'
						local xe2 = r(name)
						if ("`uniformknots'"!="") {
							qui gen double	///
							`launiforme' =  ///
							_n if `touse'
							quietly summarize ///
							`launiforme' if ///
							`touse' `wgt', meanonly
							quietly replace ///
							`launiforme' =	///
							(`launiforme' - ///
							r(min))/(r(max)-r(min))
							_pctile ///
							`launiforme' if	///
							`touse' `wgt', ///
							nquantiles(`knotsnew')
							forvalues j=1/`l' {
							    matrix ///
							    `mgn'[`i', `j']= ///
								r(r`j')
							}
						}
						else {
							_pctile `xe2' ///
							if `touse' `wgt', ///
							nquantiles(`knotsnew')
							forvalue j=1/`l' {
							    matrix ///
							    `mgn'[`i', `j']= ///
								r(r`j')
							}
						}
					}
				}
				else {
					matrix `mgn' =	`mgn0'
				}
				forvalues j=1/`l' {
					if (`mypre'==1) { 
						capture drop __x`i'__knot_`j'
						quietly generate double ///
						__x`i'__knot_`j' = ///
						(max(0, `xe'- ///
						`mgn'[`i',`j']))^`p'  ///
						if `touse' 
						local cnames`i' ///
						"`cnames`i'' c.__x`i'__knot_`j'"
						label var ///
						__x`i'__knot_`j'	///
	"variable `xlabel' minus knot `j' out of `l' to the power of `p'"
					}
					if (`mypre'==2) {
						cap confirm variable `pname'`k2'
						local rc = _rc
						if (`rc'==0 & "`primero'"!="") {
		display as error "variable {bf:`pname'`k2'} already defined" 
		di as err "{p 4 4 2}" 
		di as smcl as err "If you want to replace {bf:`pname'`k2'} " 
		di as smcl as err "you may use the {bf:replace} option of " 
		di as smcl as err "{bf:basis()}." 
		di as smcl as err "{p_end}"
		exit 198
						}
						if ("`primero'"=="") {
							capture drop `pname'`k2'
						}
						quietly generate double ///
						`pname'`k2' =	///
						max(0, `xe'- ///
						`mgn'[`i',`j'])^`p'	///
							if `touse'
						label var `pname'`k2' ///
	"variable `xlabel' minus knot `j' out of `l' to the power of `p'"
						local cnames`i' ///
						"`cnames`i'' c.`pname'`k2'"
					}
					if (`mypre'==3) {
						capture drop `pname'`k2'
						quietly generate double	///
						`pname'`k2' =	 ///
					max(0, `xe'-`mgn'[`i',`j'])^`p' ///
						if `touse'
					label var `pname'`k2' 		///
	"variable `xlabel' minus knot `j' out of `l' to the power of `p'"
						local cnames`i' ///
						"`cnames`i'' c.`pname'`k2'"
					}
					local k2 = `k2' + 1
					matrix `matxk'[`i', `j'] = ///
						`mgn'[`i',`j']
				}
			}
			local rc = _rc
			if (`rc') {
				if ("`pname'"!=""|"`pnamer'"!="") {
					capture drop `pname'*
				}
				capture drop *__knot*
				capture drop __*rs
				exit `rc'
			}
		}
	}

	local kfix: list sizeof dinter
	local dz: list sizeof dnp 
	
	if (`matd'[1,1]!=.) {
		local kdnt: list sizeof dvars
		forvalues i=1/`kdnt' {
			local x: word `i' of `dvars'
			if (`matd'[1,`i']==1) {
				local newdnt "`newdnt' `x'"
			}
			else {
				local newnod "`newnod' `x'"
			}
		}
		local dvars "`newdnt'"
	}
	
	local dinter "`dvars'"
	
	if ("`dvars'"!="") {
		_dvar_inter_new, dvars(`dvars') cvars(`cvars')
		local dinter "##(`s(dinter)')"
		local nocv "`s(dinter)'" 
		/*if (`dz'==1) {
			local dinter "##(`dvars')"
			local nocv "`dvars'"
		}
		else if (`dz'==2){
			local dinter "##((`dvars')#(`dvars'))"
			local nocv "(`dvars')#(`dvars')"
		}
		else if (`dz'>2) {
			local dinter "##(((`dvars')#(`dvars'))#(`dvars'))"
			local nocv   "((`dvars')#(`dvars'))#(`dvars')"
		}*/
	}
	
	local kxn  = 1

	forvalues i=1/`k' {
		if (`matc'[1,`i']==.|`matc'[1,`i']==1) {
			local ins "(`xint`i'' `cnames`i'')"
			local ins1 "`xint1' `cnames`i''"
			if (`orden'==1) {
				if (`k'==1) {
					local nomscv`kxn' "`ins1'"
				}
				else {
					local nomscv`kxn' "`ins'"
				}
				local notsp "`notsp' `xint`i''"
			}
			if (`orden'==2) {
				local notsp "`notsp' `xint`i''"
				local nomscv`kxn' "`xint`i'' `cnames`i''"
			}
			if (`orden'==3) {
				local notsp "`notsp' `xint`i''"	
				local nomscv`kxn' "`xint`i'' `cnames`i''"	
			}
			local kxn = `kxn' + 1
		}
		else if (`matc'[1,`i']==0) {
			local newnoc "`newnoc' `xint`i'' `cnames`i''"
		}
	}
	
	local kxn = `kxn'-1
	local nomscvs "`nomscv1'"

	if (`kxn'>1) {
		forvalues i=2/`kxn' {
			if ("`dinter'"=="") {
				local nomscvs "(`nomscvs')##(`nomscv`i'')"
			}
			else if (`i'==`kxn') {
				local nomscvs ///
					"((`nomscvs')##(`nomscv`i''))`dinter'"
			}
		}	
	}
	else {
		if ("`dvars'"!="") {
			local nomscvs "(`nomscvs')`dinter'"
		}
		else {
			local nomscvs "`nomscvs'"
		}
	}
	if ("`cvars'"=="") {
		local nomscvs "`nocv'"
		local notsp "`nocv'"
	}
	if ("`known'"!="") {
		local nomscvs "`nomscvs' `known'"
	}
	local nomscvs `"`nomscvs' `newnoc' `newnod'"'
	
	return local nomscv `"`nomscvs'"'
	return local notsp "`notsp'"
	return local dinter "`nocv'"
	return local checknoms "`checknoms'"
	return local renoms "`renoms'"
	if ("`cvars'"!="") {
		return matrix matknots = `matxk'
		return matrix matmm    = `matmm'
		return matrix matmm2   = `matmm2'
	}
end

program define _making_bsknots, rclass 
	syntax [if][in][fw pw iw], [predict(string) knots(integer 1)	///
		 cvars(string) vars(string) orden(integer 3)		///
		 csvars(string)	dvars(string) inside primero 		///
		 iter(integer 1) dnp(string) knotsmat(string)		///
		 uniformknots rescale(string) known(string)		///
		 matcint(string) matdint(string) ]	
	
	marksample touse 
	tempname K L U mptc mptc2 matmm matmm2 matc matd 
	tempvar launiforme
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
	}
	
	if ("`matcint'"!="") {
		matrix `matc' = `matcint'
	}
	else {
		matrix `matc' = .
	}
	if ("`matdint'"!="") {
		matrix `matd' = `matdint'
	}
	else {
		matrix `matd' = . 
	}
	
	_parse_predict `predict'
	local mypre = r(mypre)
	local pname = `"`r(pname)'"'
	
	_parse_predict `rescale'
	local myprer = r(mypre)
	local pnamer = `"`r(pname)'"'
	
	
	local kx:  list sizeof cvars
	if ("`cvars'"!="") {
		matrix `matmm'  = J(`kx', 2, .)
		matrix `matmm2' = J(`kx', 2, .)
	}
	forvalues i=1/`kx' {
		tempvar nmx`i'
		local x: word `i' of `cvars'
		_ms_parse_parts `x'
		local xlabel "`r(name)'"
		quietly summarize `x' if `touse', meanonly
		matrix `matmm2'[`i', 1] = r(min) 
		matrix `matmm2'[`i', 2] = r(max) 
		quietly generate double `nmx`i'' = 	///
			(`x' - r(min))/(r(max)-r(min)) if `touse'
		matrix `matmm'[`i', 1] = -.01
		matrix `matmm'[`i', 2] = 1.01
		local xvars "`xvars' `nmx`i''"
		if (`myprer'==1) {
			capture drop __x`i'rs
			quietly generate double	__x`i'rs = `nmx`i'' if `touse'
			label var __x`i'rs "`xlabel' rescaled to [0,1]"	
			local renoms "`renoms' __x`i'rs"
			if (`matc'[1,`i']!=0) {
				local checknoms "`checknoms' __x`i'rs"
			}
		}
		if (`myprer'==2) {
			cap confirm variable `pnamer'`i'
			local rc = _rc
			if (`rc'==0 & "`primero'"!="") {
				display as error ///
				"variable {bf:`pnamer'`k2'} already defined" 
				di as err "{p 4 4 2}" 
				di as smcl as err "If you want to replace "
				di as smcl as err "{bf:`pnamer'`k2'} " 
				di as smcl as err "you may use the "
				di as smcl as err "{bf:replace} option of " 
				di as smcl as err "{bf:rescale()}." 
				di as smcl as err "{p_end}"
				exit 198
			}
			if ("`primero'"=="") {
					capture drop `pnamer'`i'
			}
			quietly generate double	`pnamer'`i' = `nmx`i'' ///
				if `touse'
			label var `pnamer'`i' "`xlabel' rescaled to [0,1]"	
			local renoms "`renoms' `pnamer'`i'"
			if (`matc'[1,`i']!=0) {
				local checknoms "`checknoms' `pnamer'`i'"
			}
		}
		if (`myprer'==3) {
			capture drop `pnamer'`i'
			quietly generate double	`pnamer'`i' = `nmx`i'' ///
				if `touse'
			label var `pnamer'`i' "`xlabel' rescaled to [0,1]"	
			local renoms "`renoms' `pnamer'`i'"
			if (`matc'[1,`i']!=0) {
				local checknoms "`checknoms' `pnamer'`i'"
			}
		}
	} 	
	if ("`knotsmat'"=="") {
		local knotsnew = `knots' + 1
		local k = `knotsnew'-1
	}
	else {
		matrix `mptc2' = `knotsmat'
		local knotsnew = colsof(`mptc2') + 1
		local k = `knotsnew' - 1
	}
	
	// matrix with knots 
	
	if ("`knotsmat'"=="" & "`uniformknots'"=="") {
		if (`knotsnew'>4097) {
			display as error "too many knots"
			di as err "{p 4 4 2}" 
			di as smcl as err "The potential model could have "
			di as smcl as err "more than 4,096" 
			di as smcl as err "knots." 
			di as smcl as err "{p_end}"
			exit 198
		}
		forvalues i=1/`kx' {
			_pctile `nmx`i'' if `touse' `wgt', ///
				nquantiles(`knotsnew')
			forvalues j=1/`k' {
				matrix `mptc' = nullmat(`mptc'), r(r`j')
			}
			matrix `mptc2' = nullmat(`mptc2') \ `mptc'
			matrix drop `mptc'
		}
	}
	if ("`knotsmat'"=="" & "`uniformknots'"!="") {
		if (`knotsnew'>4097) {
			display as error "too many knots"
			di as err "{p 4 4 2}" 
			di as smcl as err "The potential model could have "
			di as smcl as err "more than 4,096" 
			di as smcl as err "knots." 
			di as smcl as err "{p_end}"
			exit 198
		}
		quietly generate double `launiforme' = _n if `touse'
		quietly summarize `launiforme' if `touse' `wgt', meanonly
		quietly replace `launiforme' =	///
			(`launiforme' - r(min))/(r(max)-r(min))
		_pctile `launiforme' if `touse' `wgt', nquantiles(`knotsnew')
		forvalues i=1/`k' {
			matrix `mptc' = nullmat(`mptc'), r(r`i')
		}
		mata: st_matrix("`mptc2'", J(`kx', 1, st_matrix("`mptc'")))
		matrix drop `mptc'
	}

	local k2 = `knotsnew' + `orden'
	local km = 1 
	forvalues i=1/`kx'{
		local x: word `i' of `cvars'
		_ms_parse_parts `x'
		local xlabel "`r(name)'"
		forvalues j=1/`k2' {
			capture noisily break {
				if (`mypre'==1) {
					capture drop _x`i'__b`j'
					quietly generate double	///
						_x`i'__b`j' = . ///
						if `touse'
					local cnames`i' ///
						"`cnames`i'' c._x`i'__b`j'"
					local cnoms`i' ///
						"`cnoms`i'' _x`i'__b`j'"
					label var _x`i'__b`j' ///
					"basis term `j' for variable `xlabel'"
				}
				if (`mypre'==2) {
					cap confirm variable `pname'`km'
					local rc = _rc	
					if (`rc'==0 & "`primero'"!="") {
		display as error "variable {bf:`pname'`k2'} already defined" 
		di as err "{p 4 4 2}" 
		di as smcl as err "If you want to replace {bf:`pname'`k2'} " 
		di as smcl as err "you may use the {bf:replace} option of " 
		di as smcl as err "{bf:basis()}." 
		di as smcl as err "{p_end}"
		exit 198
					}
					if ("`primero'"=="") {
						capture drop `pname'`km'
					}
					quietly generate double 	///
						`pname'`km' = . ///
						if `touse' 
					label var `pname'`km'	///
					"basis term `j' for variable `xlabel'"	
					local cnames`i' ///
						"`cnames`i'' c.`pname'`km'"
					local cnoms`i' ///
						"`cnoms`i'' `pname'`km'"		
				}
				if (`mypre'==3) {
					capture drop `pname'`km'
					quietly generate double	///
						`pname'`km' = . ///
						if `touse'
					label var `pname'`km'	///
					"basis term `j' for variable `xlabel'"
					local cnames`i' ///
						"`cnames`i'' c.`pname'`km'"
					local cnoms`i' ///
						"`cnoms`i'' `pname'`km'"
				}
				local km = `km' + 1
			}
			local rc = _rc
			if (`rc') {
				if ("`pname'"!=""|"`pnamer'"!="") {
					capture drop `pname'*
				}
				capture drop *__b*
				capture drop __*rs
				exit `rc'
			}
		}
		local cnames "`cnames' `cnoms`i''"
	}	
	if ("`cvars'"!="") {
		mata: _kroenecker_knots("`xvars'", "`mptc2'", `orden',	///
			`kx', "`cnames'", "`matmm'", "`touse'")
	}

	local kfix: list sizeof dinter
	local dz: list sizeof dnp 
	
	if (`matd'[1,1]!=.) {
		local kdnt: list sizeof dvars
		forvalues i=1/`kdnt' {
			local x: word `i' of `dvars'
			if (`matd'[1,`i']==1) {
				local newdnt "`newdnt' `x'"
			}
			else {
				local newnod "`newnod' `x'"
			}
		}
		local dvars "`newdnt'"
	}
	
*	local dinter "`dvars'"

	if ("`dvars'"!="") {
/*program define _dvar_inter_new, sclass
	syntax [anything], [dvars(string) cvars(string)]*/
	
		_dvar_inter_new, dvars(`dvars') cvars(`cvars')
		local dinter "##(`s(dinter)')"
		local nocv "`s(dinter)'"
		/*if (`dz'==1) {
			if (`kfix'<=1 & "`cvars'"=="") {
				local dinter "`dvars'"	
				local nocv "`dvars'"		
			}
			else {
				local dinter "##(`dvars')"
				local nocv "(`dvars')"
			}	
		}
		else if (`dz'==2){
			local dinter "##((`dvars')#(`dvars'))"
			local nocv "(`dvars')#(`dvars')"
		}
		else if (`dz'>2) {
			local dinter "##(((`dvars')#(`dvars'))#(`dvars'))"
			local nocv   "((`dvars')#(`dvars'))#(`dvars')"
		}*/
	}	

	local kxn  = 1
	local kxn2 = 1
	forvalues i=1/`kx' {
		if (`matc'[1,`i']==.|`matc'[1,`i']==1) {
			local nomscv`kxn' "`cnames`i''"
			local kxn2 = `kxn2' + 1
		}
		else if (`matc'[1,`i']==0) {
			local newnoc "`newnoc' `cnames`i''"
		}
		if ("`dinter'"!="") {
			local nomscv`kxn' "(`nomscv`kxn'')"
		}
		local kxn = `kxn2'
	}
	local kxn = `kxn'-1
	local nomscvs "`nomscv1'" 
	if (`kxn'>1) {
		forvalues i=2/`kxn' {
			local nomscvs "(`nomscvs')##(`nomscv`i'')"
		}	
	}
	if ("`dinter'"!="") {
		local nomscvs "(`nomscvs')`dinter'"
	}
	if ("`cvars'"=="") {
		local nomscvs "`nocv'"
		local notsp "`nocv'"
	}

	local nomscvs `"`nomscvs' `newnoc' `newnod'"'
	if ("`known'"=="") {
		return local nomscv `"`nomscvs'"'
	}
	else {
		local nomscvs "`nomscvs' `known'"
		return local nomscv `"`nomscvs'"'
	}
	return local notsp "`notsp'"
	return local dinter "`nocv'"
	return local renoms "`renoms'"
	return local catnames "`cnames'"
	return local checknoms "`checknoms'"
	if ("`cvars'"!="") {
		return matrix matknots = `mptc2'
		return matrix matmm    = `matmm'
		return matrix matmm2   = `matmm2'
	}
end

program define _parse_predict, rclass
	capture syntax [anything], [replace]
	local rc = _rc
	if (`rc') {
		display as error "option {bf:basis()} incorrectly specified"
		exit 198
	}
	if ("`anything'"=="") {
		return scalar mypre = 1 
	}
	if ("`anything'"!="") {
		local k: list sizeof anything 
		if (`k'>1) {
			display as error ///
				"option {bf:basis()} incorrectly specified"
			di as err "{p 2 2 2}" 		
			di as smcl as err " You may specify at most"
			di as smcl as err "one stub. "
			di as smcl as err "{p_end}"		
			exit 198
		}
		capture confirm name `anything'
		local rc = _rc 
		if (`rc') {
			display as error ///
				"option {bf:basis()} incorrectly specified"
			di as err "{p 2 2 2}" 		
			di as smcl as err "`anything'"
			di as smcl as err " is an invalid name. "
			di as smcl as err "{p_end}"		
			exit 198		
		}
		return scalar mypre = 2
		return local pname "`anything'"
	}
	if ("`anything'"!="" & "`replace'"!="") {
		return scalar mypre = 3
		return local pname "`anything'"
	}
end

program define _convergent_list
	syntax [anything], [orig(string) known(string)]
	fvexpand `orig' 
	local orig2 = r(varlist)
	capture fvexpand `known'
	local rc2 = _rc
	if (`rc2'==0 & "`orig'"!="") {
		local known2 = r(varlist)
	}
	if (`rc2'>0 & "`orig'"!="") {
		display as error "option {bf:asis()} incorrectly specified;"
		fvexpand `known'
	}
	local inter: list orig2 & known2
	if ("`inter'"!="") {
		display as error "variables in {it:varlist} cannot be" ///
			" specified in {bf:asis()}"
		exit 198
	}
end

program define _dvar_list_p, sclass
	syntax [anything][if][in], [dvars(string) queda(string)]
	marksample touse 
	fvexpand `dvars' if `touse'
	local dinter "`r(varlist)'"
	quietly mata: _dinter_expand_("`dinter'")
	if ("`queda'"!="") {
		local a "`dinter'"
		local b "`queda'"
		local k2: list sizeof b
		forvalues i=1/`k2' {
			local x: word `i' of `b'
			_ms_parse_parts `x'
			local lv = r(level)
			local nm = r(name)
			local b0 = subinstr("`a'", "`x'", "`lv'bn.`nm'", .)
			local a "`b0'"
		}
		local dinter "`a'"
	}
	sreturn local dinter "`dinter'"
end 

program define _check_vce_cluster, sclass
	syntax [anything], [vce(string)]
	
	local first: word 1 of `vce'
	if ("`first'"=="cluster"|"`first'"=="cluste"|	///
		"`first'"=="clust"|"`first'"=="clus"|	///
		"`first'"=="clu"|"`first'"=="cl") {
		display as error ///
			"{bf:vce()} with {it:vcetype} {bf:cluster} not allowed"
		exit 198
	}
        if !inlist(`"`vce'"', "", "ols", "robust", "robus", ///
		"robu", "rob", "ro", "r") {
		display as error ///
			"{bf:vce()} with {it:vcetype} {bf:`vce'} not allowed"
		exit 198		
	}
	if ("`vce'"=="") {
		local vce "robust"
	}
	sreturn local vce "`vce'"
                

end

program define ot_matrix, rclass
	syntax [anything], [mat(string) cvars(string) rescale]
	tempname matknots A MIN MAX B
	local numero: list sizeof mat
	local k: list sizeof cvars
	local formar = 0 
	if (`numero'==1) {
		checkmymatrix, mat(`mat') cvars(`cvars')
		matrix `A' = `mat'
	}
	else if (`k'==1) {
		capture _mkvec `A', from(`mat')
		local rc = _rc
		if (`rc') {
			display as error "option {bf:knotsmat()} "	///
				"incorrectly specified"	
			_mkvec `A', from(`mat')
		}
	}
	else if (`k'>1) {
		display as error "option {bf:knotsmat()} "	///
			"incorrectly specified"	
		di as err "{p 2 2 2}" 	
		di as smcl as err "With more than one regressor" 
		di as smcl as err " you should specify a matrix instead of"
		di as smcl as err " a number list."
		di as smcl as err "{p_end}"		
		exit 198				
	}
	forvalues i=1/`k' {
		tempname  C  
		matrix `C' = `A'[`i',1..colsof(`A')]
		capture _mkvec `matknots', from(`C')
		local rc = _rc
		if (`rc') {
			display as error "option {bf:knotsmat()} "	///
				"incorrectly specified"	
			_mkvec `matknots', from(`C')
		}
		mata:st_matrix("`matknots'", ///
			sort(st_matrix("`matknots'")', 1)')
		local x: word `i' of `cvars'
		_ms_parse_parts `x'
		local xe = r(name)
		summarize `x', meanonly 
		local min = r(min)
		local max = r(max)
		matrix `MAX' = .
		matrix `MIN' = . 
		mata: st_matrix("`MIN'", min(st_matrix("`matknots'")))
		mata: st_matrix("`MAX'", max(st_matrix("`matknots'")))
		local minmat = `MIN'[1,1]
		local maxmat = `MAX'[1,1]
		if ((`minmat' < `min')|(`maxmat' > `max')) {
			display as error "option {bf:knotsmat()} "	///
				"incorrectly specified"	
			di as err "{p 2 2 2}" 	
			di as smcl as err "The minimum and maximum values" 
			di as smcl as err " in row `i' of {bf:knotsmat()}"
			di as smcl as err " should not exceed the minimum"
			di as smcl as err " and maximum values of {bf:`xe'}."
			di as smcl as err "{p_end}"		
			exit 198			
		}
		if ("`rescale'"!="") {
			local div = `max'-`min'
			mata: st_matrix("`matknots'", ///
				(st_matrix("`matknots'"):-`min')/(`div'))
		}
		matrix `B' = nullmat(`B') \ `matknots'
	}
	return matrix knotsmat = `B'
end

program define checkmymatrix
	syntax [anything], [mat(string) cvars(string) rescale]
	tempname A 
	capture matrix `A' = `mat'
	local rc = _rc 
	if (`rc') {
		display as error "option {bf:knotsmat()} "	///
			"incorrectly specified"	
		di as err "{p 2 2 2}" 	
		di as smcl as err "`mat' in {bf:knotsmat()}"
		di as smcl as err " is not a matrix."
		di as smcl as err "{p_end}"		
		exit 198		
	}
	local k: list sizeof cvars
	if (`k'!=rowsof(`A')) {
		local mir "rows"
		if (`k'==1) {
			local mir "row"
		}
		display as error "option {bf:knotsmat()} "	///
			"incorrectly specified"	
		di as err "{p 2 2 2}" 	
		di as smcl as err "The matrix in {bf:knotsmat()}"
		di as smcl as err " should have `k' `mir'."
		di as smcl as err "{p_end}"		
		exit 198			
	}
end

program define _r_squared, rclass
	syntax [anything] [if][in], [* y(string) noCONstant]
	
	marksample touse 
	tempvar ehat d ehat2 rsqs0 dmean rsqs1 rsqs2 rsqs rsqsa
	tempname norsq
	
	local c = 0 
	if ("`constant'"=="") {
		local c = 1
	}
	summarize `y' if `touse', meanonly 
	local N    = r(N)
	local ybar = r(mean)
	quietly _predict double `ehat' if `touse', residuals
	capture quietly _predict double `d' if `touse', hat
	local rc = _rc
	if (`rc') {
		scalar `norsq' = 1 
		return scalar norsq = `norsq'
	}
	else {
		summarize `d', meanonly
		local max = r(max)
		local min = r(min)
		if (`max'>1 | `min'<0) {
			quietly replace `d' = . 
		} 
		quietly generate double `ehat2' = `ehat'*`ehat'
		quietly generate double `rsqs0'  = `ehat2'/(1 -`d')^2
		quietly generate double `dmean'  = (`y' - `ybar')^2
		quietly egen double `rsqs1'      =  total(`rsqs0'), missing
		quietly egen double `rsqs2'      =  total(`dmean')	
		local rsqs   = 1 - (`rsqs1'[1]/`rsqs2'[1])
		local rsqsa  = 1 - (1-`rsqs')*(`N'-`c')/(e(df_r))
		if (`rsqs'<0) {
			local rsqs  = . 
			local rsqsa = .
		}
		return scalar rsqs  = `rsqs'
		return scalar rsqsa = `rsqsa'
		scalar `norsq' = 0 
		return scalar norsq = `norsq'
	}
end

program define _covariates_known, rclass
	syntax [anything] [if][in][fw pw iw],	///
			  [rhs(string) 		///
			  noCONstant		///
			  known(string)		///
			  POLYnomial(string)	///
			  POLYnomial1]

	marksample touse 
	
	tempname minmaxp 
	
	if ("`known'"!=""){
		gettoken known uno: known, parse(",")
		local knewknown "`known' if `touse' `uno'"
		local known "`knewknown'"
	}

	_parse_known `known'
	local known      = "`r(kname0)'"
	local knownp     = "`r(kname0)'"
	local knownj     = "`r(knamej)'"
	local knpr       = r(knpr)
        matrix `minmaxp' = r(minmaxp)
	
	if ("`polynomial'"=="" &  "`polynomial1'"=="") {
		local known  = "`r(kname)'"	
		local known0 = "`r(kname0)'"	
	}
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
	}
	
	if ("`rhs'"!="") {
		fvexpand `rhs' if `touse'
		local covariates = r(varlist)
	}
	if ("`known'"!="") {
		if ("`known0'"=="") {
			capture fvexpand `known' if `touse'
		}
		else {
			capture fvexpand `known0' if `touse'		
		}
		local rc = _rc
		if (`rc') {
			display in red	///
			"option {bf:asis()} incorrectly specified"
			fvexpand `known' if `touse'
		}
		local newknown "`r(varlist)'"
	}
	local k: list sizeof newknown

	forvalues i=1/`k' {
		local x: word `i' of `newknown'
		_ms_parse_parts `x'
		local k2 = r(k_names)
		if (`k2'!=.) {
			forvalues j=1/`k2' {
				if ("`r(op`j')'"=="c") {
					local namesk "`namesk' `r(name`j')'"
				}
				else {
					local namesk ///
					"`namesk' `r(op`j')'.`r(name`j')'"				
				}
			}
		}
		else {
			if ("`r(op)'"!="") {
				local namesk "`namesk' `r(op)'.`r(name)'"
			}
			else {
				local namesk "`namesk' `r(name)'"			
			}
		}
	}
	local k: list sizeof covariates
	forvalues i=1/`k' {
		local x: word `i' of `covariates'
		_ms_parse_parts `x'
		local k2 = r(k_names)
		if (`k2'!=.) {
			forvalues j=1/`k2' {
				local namesr "`namesr' `r(name`j')'"
			}
		}
		else {
			local namesr "`namesr' `r(name)'"
		}
	}
	local inter: list namesr & namesk
	if ("`inter'"!="") {
		display in red "option {bf:asis()} incorrectly specified"
		di as err "{p 2 2 2}" 	
		di as smcl as err "The variables in {bf:asis()}"
		di as smcl as err " may not be in the list of covariates."
		di as smcl as err "{p_end}"		
		exit 198
	}
	local newcovars "`covariates' `namesk'"
	local newcovars: list uniq newcovars
	return local newcovars "`newcovars'"
	return local known "`known'"
	return local knownp "`knownp'"
	return local knownj "`knownj'"

	if (`knpr'>0) {
		return matrix minmaxp = `minmaxp' 
	}
	return scalar knpr = `knpr'

end

program define _parse_known, rclass
	syntax varlist(numeric fv) [if][in], [predict(string)]
	
	marksample touse 
	
	tempname minmaxp
	
	_parse_predict `predict'
	local mypre = r(mypre)
	local pname = `"`r(pname)'"'
	fvexpand `varlist' if `touse'
	local newcovars = r(varlist)
	local k: list sizeof newcovars
	local kn = 1 
	local knpr = 0 
	local forjml ""
	forvalues i=1/`k' {
		local x: word `i' of `newcovars'
		_ms_parse_parts `x'
		local tipo   = r(type)
		if ("`tipo'"=="interaction") {
			local k2 = r(k_names)
			forvalues j=1/`k2' {
				_ms_parse_parts `x'
				local myop  = r(op`j')
				local namej = r(name`j')
				local forjml "`forjml' `namej'"
				if ("`myop'"=="c") {
					local inter: list namej & cnamel 
					if (`mypre'==1 & "`inter'"=="") {
						capture drop __x`i'`j'p
						summarize `namej'	///
						if `touse', meanonly
						quietly generate double ///
						__x`i'`j'p = ///
						(`namej'-r(min))/ ///
						(r(max)-r(min))	if `touse'
						local nomxp "c.__x`i'`j'p"
						local nomxp0 "c.`namej'"
						label var __x`i'`j'p ///
						"`namej' rescaled to [0,1]"
						local knpr = `knpr' + 1 
						matrix `minmaxp' = ///
							nullmat(`minmaxp') \ ///
							(r(min), r(max))
						
					}
					if (`mypre'==2 & "`inter'"=="") {
						capture confirm variable ///
						`pname'`kn'
						local rc = _rc
						if (`rc'==0) {
display as error ///
"variable {bf:`pname'`kn'} already defined" 
di as err "{p 4 4 2}" 
di as smcl as err "If you want to replace "
di as smcl as err "{bf:`pname'`kn'} " 
di as smcl as err "you may use the "
di as smcl as err "{bf:replace} option of " 
di as smcl as err "{bf:asis()}." 
di as smcl as err "{p_end}"
exit 198
						}
						summarize `namej' if ///
							`touse', meanonly
						quietly generate double ///
						`pname'`kn' = ///
						(`namej'-r(min))/ ///
						(r(max)-r(min)) if `touse' 
						local nomxp "c.`pname'`kn'"
						local nomxp0 "c.`namej'"
						label var `pname'`kn' ///
						"`namej' rescaled to [0,1]"
						local kn = `kn' + 1
						local knpr = `knpr' + 1 
						matrix `minmaxp' = ///
							nullmat(`minmaxp') \ ///
							(r(min), r(max))
					}
					if (`mypre'==3 & "`inter'"=="") {
						capture drop `pname'`kn'
						summarize `namej' if ///
							`touse', meanonly
						quietly generate double ///
						`pname'`kn' = ///
						(`namej'-r(min))/ ///
						(r(max)-r(min)) if `touse' 
						local nomxp "c.`pname'`kn'"
						local nomxp0 "c.`namej'"
						label var `pname'`kn' ///
						"`namej' rescaled to [0,1]"
						local kn = `kn' + 1
						local knpr = `knpr' + 1
						matrix `minmaxp' = ///
							nullmat(`minmaxp') \ ///
							(r(min), r(max))
					}
					if (`j'==1) {
						local newnom	///
						"`nomxp'#"
						local newnom0	///
						"c.`namej'#"
					}
					else if (`j'<`k2') {
						local newnom	///
						"`newnom'`nomxp'#"	
						local newnom0	///
						"`newnom0'c.`namej'#"			
					}
					if (`k2'>1 & `j'==`k2') {
						local newnom	///
						"`newnom'`nomxp'"
						local newnom0	///
						"`newnom0'c.`namej'"
					}
				}
				else {
					local dnomj "`myop'.`namej'"
					if (`j'==1) {
						local newnom	///
						"`dnomj'#"
					}
					else if (`j'<`k2') {
						local newnom	///
						"`newnom'`dnomj'#"			
					}
					if (`k2'>1 & `j'==`k2') {
						local newnom	///
						"`newnom'`dnomj'"
					}
					local newnom0 "`newnom'"
				}
				local cnamel "`cnamel' `namej'"
			}
			local kname "`kname' `newnom'"
			local kname0 "`kname0' `newnom0'"
		}
		else if ("`tipo'"=="variable") {
			local namej = r(name)
			local forjml "`forjml' `namej'"
			local inter: list namej & cnamel 
			if (`mypre'==1 & "`inter'"=="") {
				capture drop __x`i'p
				summarize `namej'	///
				if `touse', meanonly
				matrix `minmaxp' = ///
					nullmat(`minmaxp') \ ///
					(r(min), r(max))
				quietly generate double ///
				__x`i'p = ///
				(`namej'-r(min))/ ///
				(r(max)-r(min))	if `touse'
				local nomxp "c.__x`i'p"
				label var __x`i'p ///
				"`namej' rescaled to [0,1]"
				local knpr = `knpr' + 1
			}
			if (`mypre'==2 & "`inter'"=="") {
				capture confirm variable ///
				`pname'`kn'
				local rc = _rc
				if (`rc'==0) {
display as error ///
"variable {bf:`pname'`kn'} already defined" 
di as err "{p 4 4 2}" 
di as smcl as err "If you want to replace "
di as smcl as err "{bf:`pname'`kn'} " 
di as smcl as err "you may use the "
di as smcl as err "{bf:replace} option of " 
di as smcl as err "{bf:asis()}." 
di as smcl as err "{p_end}"
exit 198
				}
				summarize `namej' if ///
					`touse', meanonly
				quietly generate double ///
				`pname'`kn' = ///
				(`namej'-r(min))/ ///
				(r(max)-r(min)) if `touse' 
				local nomxp "c.`pname'`kn'"
				label var `pname'`kn' ///
				"`namej' rescaled to [0,1]"
				local kn = `kn' + 1
				local knpr = `knpr' + 1
				matrix `minmaxp' = ///
					nullmat(`minmaxp') \ ///
					(r(min), r(max))
			}
			if (`mypre'==3 & "`inter'"=="") {
				capture drop `pname'`kn'
				summarize `namej' if ///
					`touse', meanonly
				quietly generate double ///
				`pname'`kn' = ///
				(`namej'-r(min))/ ///
				(r(max)-r(min)) if `touse' 
				local nomxp "c.`pname'`kn'"
				label var `pname'`kn' ///
				"`namej' rescaled to [0,1]"
				local kn = `kn' + 1
				local knpr = `knpr' + 1
				matrix `minmaxp' = ///
					nullmat(`minmaxp') \ ///
					(r(min), r(max))
			}
			local cnamel "`cnamel' `namej'"
			local kname "`kname' `nomxp'"
			local kname0 "`kname0' c.`namej'"
		}
		if ("`tipo'"=="factor"){
			local namej = r(name)
			local forjml "`forjml' `namej'"
			local opa "`r(op)'"
			local kname "`kname' `opa'.`namej'"
			local kname0 "`kname0' `opa'.`namej'"
		}
	}
 
	local kname: list uniq kname
	local kname0: list uniq kname0
	local knamej: list uniq forjml 
	
	return local kname "`kname'"
	return local kname0 "`kname0'"
	return local knamej "`knamej'"
	if (`knpr'>0) {
		return matrix minmaxp = `minmaxp' 
	}
	return local knpr "`knpr'"

end

program define _intersect_list
	syntax [anything], [orig(string) nointer(string)]
	fvexpand `orig' 
	local orig2 = r(varlist)
	capture fvexpand `nointer'
	local rc2 = _rc
	if (`rc2'==0) {
		local nointer2 = r(varlist)
	}
	if (`rc2'>0) {
		display as error	///
			"option {bf:nointeract()} incorrectly specified;"
		fvexpand `nointer'
	}
	local inter: list orig2 & nointer2
	local inter3: list nointer2 - inter 
	if ("`inter3'"!="") {
		display as error "all variables in {bf:nointeract()} must" ///
			" also be in the list of covariates"
		exit 198
	}
end

program define _nointer_cont_disc, sclass
	syntax [anything][if][in], [dvars(string) 		///
				    cvars(string)		///
				    vars(string)		///
				    nointer(string)		///
				    estis(integer 3)		///
				    orden(integer 1)		///
				    espoly]
	marksample touse 

	fvexpand `vars' if `touse'
	local vars "`r(varlist)'"
	fvexpand `cvars' if `touse'
	local cvars  "`r(varlist)'"
	fvexpand `dvars' if `touse'
	local dvars "`r(varlist)'"
	fvexpand `nointer' if `touse'
	local nointer "`r(varlist)'"
	
	local newvars: list  vars - nointer
	local newcvars: list cvars - nointer
	local cvarsint: list cvars & nointer
	local newdvars: list dvars - nointer 
	local dvarsint: list dvars & nointer 


	local kc: list sizeof newcvars 
	
	forvalues i=1/`kc' {
		local x: word `i' of `newcvars'
		local newcvars2 "`newcvars2' c.`x'"
	}
	if ("`newcvars2'"!="") {
		local newcvars "`newcvars2'"
	}

	if (`estis'==1) {
		local k: list sizeof cvarsint
		forvalues i=1/`k' {
			local x: word `i' of `cvarsint'
			local k1 = `orden'
				local intcvarsj "" 
				forvalues j=1/`k1' {
					if (`j'==1 & `k1'==1) {
						local intcvarsj ///
							"`intcvarsj' c.`x'"
					}
					if (`j'==1 & `k1'>1) {
						local intcvarsj ///
						"`intcvarsj' c.`x'##"
					}
					if (`j'>1 & `k1'>1 & `k1'>`j') {
						local intcvarsj ///
						"`intcvarsj'c.`x'##"					
					}
					if (`j'>1 & `j'==`k1') {
						local intcvarsj ///
						"`intcvarsj'c.`x'"						
					}
				}
			local intcvars "`intcvars' `intcvarsj'"
		}
		if ("`dvarsint'"!="") {
			_contordisc if `touse', vars(`dvarsint')
			local dvarsint "`s(dnoms)'" 
		}
		local intvars "`intcvars' `dvarsint'"
	}

	if (`estis'==1 & "`espoly'"!="") {
		if ("`newdvars'"!="") {
			local newvars "(`newcvars')#`newdvars'"
		}
	}

	sreturn local newcvars "`newcvars'"
	sreturn local newdvars "`newdvars'"
	sreturn local newvars "`newvars'"
	sreturn local intvars "`intvars'"
	if (`estis'==1) {
		sreturn local intcvars "`intcvars'"
	}
	else {
		sreturn local intcvars "`cvarsint'"	
	}
	sreturn local intdvars "`dvarsint'"
end

program define _mat_cvar_dvar, rclass
	syntax [anything], [cvars(string) intcvars(string) ///
			    intdvars(string) dvars(string)]

	if ("`cvars'"!="") {
		fvexpand `cvars' 
		local cvars = r(varlist)
	}

	if ("`intcvars'"!="") {
		fvexpand `intcvars' 
		local intcvars = r(varlist)
	}

	local k1: list sizeof cvars
	local k2: list sizeof dvars

	tempname cinter dinter

	forvalues i=1/`k1' {
		local x: word `i' of `cvars'
		local int: list x & intcvars
		if ("`int'"=="") {
			matrix `cinter' = nullmat(`cinter'), 1 
		}
		else {
			matrix `cinter' = nullmat(`cinter'), 0 
		}
	}
	forvalues i=1/`k2' {
		local y: word `i' of `dvars'
		local int: list y & intdvars
		if ("`int'"=="") {
			matrix `dinter' = nullmat(`dinter'), 1 
		}
		else {
			matrix `dinter' = nullmat(`dinter'), 0 
		}
	}
	if (`k2'>0) {
		return matrix dinter = `dinter'
	}
	if (`k1'>0) {
		return matrix cinter = `cinter'
	}	
end

program define _known_errs
	capture syntax varlist(numeric fv)
	local rc = _rc 
	if (`rc') {
		display as error "option {bf:asis()} incorrectly specified" 
		syntax varlist(numeric fv)
	}
end

program define _give_me_cvars, sclass
	syntax [anything][if][in], [vars(string)]
	
	marksample touse 
	fvexpand `vars' if `touse'
	local nomscv0 = r(varlist)
	local ksan: list sizeof nomscv0
	forvalues i=1/`ksan' {
		local xsan: word `i' of `nomscv0'
		_ms_parse_parts `xsan'
		local tipo  = r(type)
		local sname = r(name)
		if ("`tipo'"=="variable") {
			local nomscv "`nomscv' c.`sname'"
		}
		else {
			local nomscv "`nomscv' `xsan'"
		}
	}
	sreturn local varsane "`nomscv'"
end

program define making_knot_matrix, rclass
	syntax [anything] [if] [in] [fw iw], 		///
	       [mat(string) cvars(string) rescale]
	
	marksample touse 
	tempname matknots A B K miss K2 K3
	capture matrix `A' = `mat'
	local rc = _rc 
	if (`rc') {
		display as error "option {bf:knotsmat()} "	///
			"incorrectly specified "	
		di as err "{p 2 2 2}" 	
		di as smcl as err "`mat' in {bf:knotsmat()}"
		di as smcl as err " is not a matrix."
		di as smcl as err "{p_end}"		
		exit 198		
	}
	scalar `miss' = 0
	mata: st_numscalar("`miss'", missing(st_matrix("`A'")))
	if (`miss'==1) {
		display as error "option {bf:knotsmat()} "	///
			"incorrectly specified "	
		di as err "{p 2 2 2}" 	
		di as smcl as err "`mat' in {bf:knotsmat()}"
		di as smcl as err " should have no missing values."
		di as smcl as err "{p_end}"		
		exit 198	
	} 
	local k: list sizeof cvars
	if (`k'!=rowsof(`A')) {
		local mir "rows"
		if (`k'==1) {
			local mir "row"
		}
		display as error "option {bf:knotsmat()} "	///
			"incorrectly specified"	
		di as err "{p 2 2 2}" 	
		di as smcl as err "The matrix in {bf:knotsmat()}"
		di as smcl as err " should have `k' `mir'."
		di as smcl as err "{p_end}"		
		exit 198			
	}
	forvalues i=1/`k' {
		tempname  C  
		matrix `C' = `A'[`i',1..colsof(`A')]
		capture _mkvec `matknots', from(`C')
		local rc = _rc
		if (`rc') {
			display as error "option {bf:knotsmat()} "	///
				"incorrectly specified"	
			_mkvec `matknots', from(`C')
		}
		mata:st_matrix("`matknots'", ///
			sort(st_matrix("`matknots'")', 1)')
		matrix `B' = nullmat(`B') \ (`matknots')
	}

	capture local mnames: rownames `mat'
	local rc = _rc
	if (`rc'==0) {
		matrix rownames `B' = `mnames'
	}
	_mk_newmat, cvars(`cvars') mknots(`B')
	matrix `K' = r(kmatrix)
	forvalues i=1/`k' {
		if ("`rescale'"!="") {
			local x: word `i' of `cvars'
			summarize `x' if `touse', meanonly 
			local min = r(min)
			local max = r(max)
			local div = `max'-`min'
			matrix `K2' = `K'[`i', 1..colsof(`K')]
			mata: st_matrix("`K2'", ///
				(st_matrix("`K2'"):-`min'):/(`div'))
			matrix `K3' = nullmat(`K3') \ (`K2')
		}
	}
	return matrix knotsmat = `K3'
end

program define _dvar_inter_new, sclass
	syntax [anything], [dvars(string) cvars(string)]
	
	fvexpand `dvars'
	local names = r(varlist)
	local cvars "`cvars'"
	local k1: list sizeof names 
	local j = 1 
	forvalues i=1/`k1' {
		local uno: word `i' of `names'
		_ms_parse_parts `uno'
		local name1 = r(name)
		if (`i'==1) {
			local name0 "`name1'"
		}
		if("`name1'"=="`name0'") {
			local n`j' "`n`j'' `uno'"
		}
		else {
			local j = `j' + 1
			local n`j' "`uno'"
		}
		local name0 "`name1'"
	}
	local k2 = `j'
	if ("`cvars'"=="" & `k2'==1) {
		local dinter "`n1'"
	}
	if ("`cvars'"!="" & `k2'==1) {
		local dinter "(`n1')"
	}
	local dinter0 "(`n1')"
	if (`k2'>1) {
		forvalues i=2/`k2' {
			local dinter "`dinter0'##(`n`i'')"
			local dinter0 "`dinter'"
		}
	}
	sreturn local dinter "`dinter'"
end

program define _mk_newmat, rclass
	syntax [anything], [cvars(string) mknots(string)]
	
	tempname matkn matknew
	
	matrix `matkn' = `mknots'
	local mnames: rownames `matkn'
	capture fvexpand `mnames'
	local rc = _rc
	local varlist = r(varlist)
	fvexpand `cvars'
	local original = r(varlist)
	local n1: list sizeof original
	local inter: list original & varlist
	local n2: list sizeof inter
	if (`rc'==0 & `n1'==`n2') {
		local k: list sizeof varlist
		forvalues i=1/`k' {
			local x: word `i' of `original'
			forvalues j=1/`k' {
			local y: word `j' of `varlist'
				if ("`y'"=="`x'") {
					matrix `matknew' =		///
						nullmat(`matknew') \	///
						`matkn'[`j', 		///
							1..colsof(`matkn')]
				}
			}
		}
	}
	else {
		matrix `matknew' = `mknots'
	}
	return matrix kmatrix  `matknew'
end

program define _polycheck
	capture syntax [anything], [polynomials(integer 2)]
	local rc = _rc
	if (`polynomials'>16| `polynomials'< 1 | `rc') {
		display as error ///
			"option {bf:polynomial()} incorrectly specified"
			di as err "{p 2 2 2}" 	
			di as smcl as err "{bf:polynomial()}"
			di as smcl as err " should be an integer between"
			di as smcl as err "1 and 16"
			di as smcl as err "{p_end}"			
		exit 198	
	}
 end

 program define _knotcheck
	capture syntax [anything][if][in], [knots(integer 1) knotsmat(string)]
	local rc = _rc
	if (`rc') {
		display as error ///
			"option {bf:knots()} incorrectly specified"
		exit 198
	}
	marksample touse 
	quietly count if `touse'
	local N = min(int(r(N)*2/3), 4096)
	if (`knots'< 1) {
		display as error ///
			"option {bf:knots()} incorrectly specified"
			di as err "{p 2 2 2}" 	
			di as smcl as err "{bf:knots()}"
			di as smcl as err " should be an integer between"
			di as smcl as err "1 and `N'"
			di as smcl as err "{p_end}"			
		exit 198	
	}
 end
 
 program _parse_min_level
	syntax [anything], [minlevel(integer 10)]
 	if (`minlevel'<=2) {
		di as error "option {bf:distinct()} incorrectly specified"
		di as txt "{p 4 4 2}" 	
                di as smcl as err "{bf:distinct()} should be an integer"
                di as smcl as err "greater than 2"
                di as smcl as err "{p_end}"
		exit 198
	}
 end
