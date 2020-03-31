*! version 1.0.1  08oct2019
program define _npreg_series_two, properties(svyb svyj svyr) eclass ///
				 byable(onecall)
	version 16
        if _by() {
                local BY `"by `_byvars'`_byrc0':"'
        }
        
        `BY' _vce_parserun _npreg_series_two, noeqlist jkopts(eclass): `0'
        
        if "`s(exit)'" != "" {
                ereturn local cmdline `"_npreg_series_two `0'"'
                exit
        }

        if replay() {
                if `"`e(cmd)'"' != "_npreg_series_two" { 
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
        ereturn local cmdline `"npregress series `0'"'
end

program define Estimate, eclass byable(recall)
	syntax varlist(numeric ts fv) [if] [in] [fw iw]	///
		[,					///
		NOCONstant				///
		CONstant				///
		noLOg					///
		criterion(string)			///
		asis(string)				///
		Level(cilevel)                          ///
		ITERate(integer 30)			///
		TOLerance(real 1e-4)			///
		POLYNOMIALs(string)			///
		SPLINEs(string)				///
		BSPLINEs(string)			///
		CONSTraints(string)			///
		BSPLINEs1				///
		SPLINEs1				///
		POLYNOMIALs1				///
		vce(string)				///
		RESCALE1				///
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
	tempvar b_series V_series b V muestra mymuestra error
	tempname matknots matmm matmm2 select V_modelbased hmat ///
		V_modelbased_series matc matd matmm3 minmaxp 	///
		bootex rango milog 
	
	// Parsing options 

	_get_diopts diopts rest, `options'
	qui cap Display, `diopts' `rest'
	if _rc==198 {
                Display, `diopts' `rest'
        }
	
	local aeq0: list 0 - aequations
	local predict "`basis'"
	nobreak {
		capture noisily break { 
			_npreg_series `aeq0'
			_get_hmat `hmat'
			local nohmat = 0
			if r(rc) {
				local nohmat = 1 
			}
			generate double `muestra'   = e(sample)
			generate double `mymuestra' = `muestra'*`touse'
			matrix `b_series' = e(b)
			matrix `V_series' = e(V)
			local kbv  = colsof(`b_series')
			if ("`e(vce)'"=="robust") {
				matrix `V_modelbased' = e(V_modelbased)
				matrix `V_modelbased_series' = e(V_modelbased)
			}
			local omitir "`e(omitir)'"
			local converged = e(converged)
			local vce "`e(vce)'"
			local vcetype "`e(vcetype)'"
			local depvar "`e(depvar)'"
			local order = e(order)
			if ("`constant'"=="") {
				local ll_0 = e(ll_0)
			}
			local ll    = e(cv)
			local r2    = e(r2)
			local r2_a  = e(r2_a)
			local knppr = e(knppr)
			local known "`e(known)'"
			local norsq = e(norsq)
			local  rank = e(rank)
			local comparison = e(comparison)
			local renoms "`e(renoms)'"
			local renoms = strltrim("`renoms'")
			local root "`e(root)'"
			local fijo "`e(fijo)'"
			local espoly "`e(espoly)'"
			local checknoms "`e(checknoms)'"
			local wexp "`e(wexp)'"
			local wtype "`e(wtype)'"
			if ("`wexp'"!="") {
				local wgt [`e(wtype)' `e(wexp)']
			}
			local estis = e(estis)
			local knots = e(knots) 
			local ilog  = e(ilog)
			local catnames "`e(catnames)'"
			local criterion "`e(criterion)'"
			matrix `matknots' = e(matknots)
			matrix `matmm'    = e(matmm)
			matrix `matmm2'   = e(matmm2)
			matrix `matmm3'   = e(matmm3)
			matrix `matc' 	  = e(matcnint)
			matrix `matd' 	  = e(matdnint)
			if (`ilog') {
				matrix `milog'    = e(milog)
			}
			if (`knppr'>0) {
				matrix `minmaxp'  = e(minmaxp)
			}
			local estat_cmd "`e(regress_estat)'"
			local title "`e(title)'"
			local regressors "`e(regressors)'"
			local lnointeract "`e(lnointeract)'"
			local cantes "`e(cantes)'"
			local covariates "`e(covariates)'"
			local dvars "`e(dvars)'"
			local cvars "`e(cvars)'"
			local dnp "`e(dnp)'"
			local dinter "`e(dinter)'"
			local hascons "`e(hascons)'" 
			local rescala = e(rescala)
			local basis "`e(basis)'"		
			display ""
			display as txt "Computing average derivatives"
			
			local prefix `c(prefix)'
			local isbootstrap : list posof "bootstrap" in prefix
			local isjackknife : list posof "jackknife" in prefix
			
			if (`isbootstrap' | `isjackknife') {
				quietly margins if `mymuestra', dydx(*) nose
				scalar `bootex' = 0 
				local N = r(N)
				mata: st_numscalar("`bootex'", ///
					rowsum(st_matrix("r(error)"))!=0)
				if (`bootex') {
					display as error ///
					 "effects are not estimable"
					 exit 198
				}
			}
			else {
				quietly margins if `mymuestra', dydx(*) 
				local N = r(N)
			}
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
	scalar `rango' = .
	mata: st_numscalar("`rango'", rank(st_matrix("r(V)")))
	matrix `b' = r(b)
	matrix `V' = r(V)
	matrix `error' = r(error)
	local noms: colna `b'
	
	if ("`aequations'"!="") {
		local title2 "`e(title2)'"
		local kt2 = strlen("`title2'")
		display ""
		display as txt "`title2'"
		display as text "{hline `kt2'}"
		display ""
		_npreg_series, aequations `diopts'
		display ""
	}

	local minlevel = `distinct'
	_contordisc if `mymuestra' `wgt', vars("`covariates'")	///
		`hascons' minlevel(`minlevel')
	local tcvars  = "`s(cnoms)'"
	local tdvars  = "`s(dnoms)'"
	_contrast_table_s if `mymuestra' `wgt', dvars("`tdvars'")	///
		cvars("`tcvars'") names("`noms'") `espoly' 

	local newst = "`r(newst)'"
	matrix `select' = r(select)
	local k: list sizeof newst
	
	forvalues i=1/`k' {
		local x: word `i' of `newst'
		local bst "`bst' Effect:`x'"
	}
	local myboot = 0 
	if (!`isbootstrap' & !`isjackknife') {
		mata:	st_matrix("`error'",	///
			select(st_matrix("`error'"), st_matrix("`select'")))
		mata: st_matrix("`b'", select(st_matrix("`b'"), ///
			st_matrix("`select'")))
		mata: st_matrix("`V'", select(st_matrix("`V'"), ///
			st_matrix("`select'")'))
		mata: st_matrix("`V'", select(st_matrix("`V'"), ///
			st_matrix("`select'")))

		matrix rownames `b' = Effect
		matrix colnames `b' = `bst'
		matrix colnames `V' = `bst'
		matrix rownames `V' = `bst'

		ereturn post `b' `V', esample(`touse') obs(`N') ///
			depname(`depvar') buildfvinfo
	}
	else {
		ereturn post `b', esample(`touse') obs(`N') ///
			depname(`depvar') buildfvinfo	
		local myboot = 1 
	}
	
	// Data signature  

	quietly signestimationsample `covariates'
		    	
	ereturn scalar converged = `converged'

	if ("`vce'"=="robust") {
		ereturn matrix V_modelbased = `V_modelbased'
	}
	
	ereturn local vce "`vce'"
	ereturn local vcetype "`vcetype'"
	ereturn local depvar "`depvar'"
	ereturn hidden local lhs "`depvar'"
	ereturn hidden matrix error = `error'
	ereturn scalar order = `order'
	if ("`constant'"=="") {
		ereturn hidden scalar ll_0 = `ll_0'
	}
	ereturn hidden scalar ll   = `ll'
	if (`r2'==.) {
		ereturn hidden scalar r2   = `r2'
	}
	else {
		ereturn scalar r2   = `r2'	
	}
	if (`r2_a'==.) {
		ereturn hidden scalar  r2_a = `r2_a'
	}
	else {
		ereturn scalar  r2_a = `r2_a'	
	}

	ereturn hidden scalar norsq = `norsq' 
	ereturn scalar  rank = `rango'
	ereturn hidden scalar nohmat = `nohmat'
	ereturn hidden scalar  comparison = `comparison'
	ereturn hidden local root "`root'"
	ereturn hidden local fijo "`fijo'"
	ereturn hidden scalar estis = `estis'
	if (`ilog') {
		ereturn matrix ilog = `milog'
	}
	if (`nohmat'==0) {
		ereturn hidden matrix hmat = `hmat'
	} 
	ereturn hidden local catnames "`catnames'"
	if ("`cvars'"=="") {
		ereturn local knots "0"
	}
	else {
		ereturn local knots "`knots'"
	}
	ereturn hidden local renoms "`renoms'"
	ereturn hidden local criterion "`criterion'"
	ereturn local wtype "`wtype'"
	ereturn local wexp  "`wexp'"
	ereturn hidden matrix matknots = `matknots'
	ereturn hidden matrix matmm    = `matmm'
	ereturn hidden matrix matmm2   = `matmm2'
	ereturn hidden matrix matmm3   = `matmm3'
	ereturn hidden matrix matcnint = `matc' 
	ereturn hidden matrix matdnint = `matd'
	if (`knppr'>0) {
		ereturn hidden matrix minmaxp = `minmaxp' 
	}
	ereturn hidden scalar knppr = `knppr'
	ereturn hidden local known "`known'"
	ereturn local estat_cmd "regress_estat"
	ereturn local cmd "_npreg_series"
        ereturn local estat_cmd npregress_estat
	ereturn local title "`title'"
	ereturn hidden local title2 "`title2'"
	ereturn local predict "npregress_series_p"
	ereturn hidden local regressors "`regressors'"
	ereturn hidden local predictnl_altb "b_series"
	ereturn hidden local predictnl_altV "V_series"
	ereturn hidden local cantes "`cantes'"
	ereturn hidden local covariates "`covariates'"
	ereturn hidden local dvars "`dvars'"
	ereturn hidden local cvars "`cvars'"
	ereturn hidden local dnp "`dnp'"
	ereturn hidden local dinter "`dinter'"
	ereturn hidden local hascons "`hascons'" 
	ereturn hidden local rhs "`cvars' `dvars'"
	ereturn hidden local checknoms "`checknoms'"
	ereturn hidden scalar rescala = `rescala'
	ereturn local basis "`basis'"
	ereturn local marginsok "default Mean"
	ereturn local marginsnotok "SCores Residuals"
	ereturn local marginsprop "noeb"
	ereturn local omitir "`omitir'"
	ereturn hidden matrix b_series = `b_series'
	ereturn hidden matrix V_series = `V_series'
	ereturn local cmd "npregress"
	ereturn hidden local lnointeract "`lnointeract'"
	ereturn hidden local cmd_loco "_npreg_series_two"
	ereturn hidden local cmd_predictnl "npregress series"
	ereturn hidden local predictnlprops "_b _se _B _SE _Z _P _LB _UB"
	ereturn hidden local margins_cmd margins4series
	if (`myboot'==0) {
		Display, bmatrix(e(b)) vmatrix(e(V)) level(`level')	///
		 `rest' `diopts' 
	}
	else {
		Display, bmatrix(e(b)) level(`level')	///
		 `rest' `diopts' 	
	}
end

 ///////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////
 /////////////////////////////// SUBROUTINES ///////////////////////////////
 ///////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////

program define Display
        syntax [, bmatrix(passthru) vmatrix(passthru) noTABle *]

        _get_diopts diopts other, `options'
        local myopts `bmatrix' `vmatrix'
        tempname B V        
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
	local norsq      = e(norsq)
	local fijo       = e(fijo)
	local estis      = e(estis)
	local knots      = e(knots)
	local level      = e(nivel)
	local cvars      = "`e(cvars)'"
	local dvars      = "`e(dvars)'"
	local N          = e(N)      
	local order      = e(order)
	local comparison = e(comparison)
	local criterion  = e(ll)
	
	if (`fijo'==0 & e(ll)!=.) {
		local dcr ///
		`"noi display as text _continue "Criterion: {res:`crit'}""'	
	}
	else {
		local dcr display _continue
	}
	
	if (`estis'>1) {
		local root "Number of knots "
		local order = `knots'  
		if ("`cvars'"=="") {
			local order = 0 
		}
	}
	
        display ""
	di as text "`titulo' " 		///
		as text _col(44) "Number of obs      =  "	///
		as result %13.0gc `N'
		`dcr'
		noi display as text _col(44)  "`root'   =  "  ///
		as result %13.0f `order'
		if (`norsq'==0) {
			noi display as text ///
				_col(44)  "R-squared          =  "  ///
			as result %13.4f `r2'
			if (e(ll)!=.) {
				di as txt "`crit' = " as ///
				res %10.0g e(ll) as ///
				txt _col(44) ///
				"Adj R-squared" _col(62) " =  " as res ///
				%13.4f `r2_a'
			}
			else {
				di as txt _col(44) ///
				"Adj R-squared" _col(62) " =  " as ///
				res %13.4f `r2_a'		
			}
		}

	if ("`table'"=="") {
		_coef_table,  `diopts' `myopts' coeftitle("Effect") 
	}
	if ("`cvars'"!="" & "`dvars'"=="") {
		di as txt "{p 0 6 2}" ///
		"Note: Effect estimates are averages of derivatives.{p_end}"
	}
	if ("`cvars'"=="" & "`dvars'"!="") {
		di as txt "{p 0 6 2}" ///
		"Note: Effect estimates are averages of contrasts of"	///
		 " factor covariates.{p_end}"
	}
	if ("`cvars'"!="" & "`dvars'"!="") {
		di as txt "{p 0 6 2}" ///
		"Note: Effect estimates are averages of derivatives for " ///
		"continuous covariates and averages of contrasts for "	  ///
		"factor covariates.{p_end}"	
	}
        ml_footnote
end

program define _contrast_table_s, rclass
	syntax [anything] [if] [in] [fw iw], [dvars(string)	///
		cvars(string) names(string) espoly]
	
	tempname bases factors cuantas select
	
	marksample touse 
	
	local j1 = 1
	local j2 = 0 
	if ("`dvars'"=="") {
		local newst "`names'"
	}
	else {
		local k: list sizeof names
		forvalues i=1/`k' {
			local x: word `i' of `names'
			_ms_parse_parts `x'
			local name0 = r(name)
			local tipo  = r(type)
			local nivel = r(level)
			local base  = r(base)
			if ("`tipo'"!="variable") {
				quietly tab `name0' if `touse'
				local continuo = r(r)
				if (`continuo'==1) {
					local tipo "variable"
					local name0 "`x'"
				}
			}
			if (`i'==1) {
				local name1 "`name0'" 
			}
			if ("`tipo'"=="variable") {
				matrix `factors' = 	///
				(nullmat(`factors'), 0)	
			}
			else {
				if (`base'==1) {
					matrix `bases' = ///
						(nullmat(`bases'), `nivel')
				}
				else {
					matrix `factors' =	///
						(nullmat(`factors'), `nivel')
				}
				local dnom "`dnom' `name0'"
			}
			local name1 "`name0'"
		}
	}
	if ("`dvars'"!="") {
		local j1 = 1
		local j2 = 1
		forvalues i=1/`k' {
			local x: word `i' of `names'
			local y: word `j1' of `dnom'
			_ms_parse_parts `x'
			local name0 = r(name)
			local tipo  = r(type)
			local nivel = r(level)
			local base  = r(base)
			if ("`tipo'"!="variable") {
				quietly tab `name0' if `touse'
				local continuo = r(r)
				if (`continuo'==1) {
					local tipo "variable"
					local name0 "`x'"
				}
			}
			if (`i'==1) {
				local name1 "`y'" 
			}
			if ("`tipo'"=="variable") {
				local newst "`newst' `name0'"
				matrix `select' = nullmat(`select'), 1
			}
			else {
				local j1 = `j1' + 1 
				if ("`name1'"!="`y'") {
					local j2 = `j2' + 1
				}
				if ("`name0'"=="`y'" & `base'==0) {
					local r1 "r`nivel'vs"
					local vs = `bases'[1, `j2']
					local newst "`newst' `r1'`vs'.`y'"
					matrix `select' = nullmat(`select'), 1
				}
				if ("`name0'"=="`y'" & `base'==1) {
					matrix `select' = nullmat(`select'), 0
				}
				local name1 "`name0'"
			}
		}
	}
	else {
		local k: list sizeof cvars
		matrix `select' = J(1, `k', 1)
	}
	return local newst "`newst'"
	return matrix select = `select'

end

program define _contordisc, sclass 
	syntax [if] [in] [fw pw iw], [vars(string) noCONstant inter	///
		minlevel(integer 10)]
	
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
	}
	local blb ""
	if ("`inter'"!="") {
		local blb "for the {bf:nointer()} option"
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
		}
		if ("`tipo'"=="interaction") {
			display as error "interactions are unnecessary `blb'"
			di as err "{p 4 4 2}" 
			di as err "You are estimating an arbitrary function" 
			di as err "of the regressors. All interactions are" 
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
