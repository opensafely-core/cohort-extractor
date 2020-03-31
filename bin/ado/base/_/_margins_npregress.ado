*! version 2.0.7  25sep2018

program define _margins_npregress, rclass
	version 15
	syntax [anything] [if][in], [*]
	
	marksample touse 
	
	local sinvars = e(sinvars)
	if (`sinvars' | "`e(yname)'"=="") {
		tempname A 
		local y       = e(depvar)
		local xvars   = e(rhs)
		local mmgradn = e(mggrad)
		local margen = e(kp2)*2	
		if (`mmgradn'==0) {
			matrix `A' = e(meanbwidth)
			local bwidth "meanbwidth(`A')"
			local margen = 1
		}
		else {
			matrix `A' = e(bwidth)
			local bwidth "bwidth(`A')"
		}
		local predijo = e(predijo)
		local predice = e(predice)
		local nomy    = e(yname)
		local kestnm  = e(kestnm)  
		local noderivative ""
		if (`e(kgrad)'==0 & "`kestnm'"=="constant") {
			local noderivative "noderivative"
		}
		
		local zero "`0'"
		quietly capture checkestimationsample
		local rc = _rc
		if (`rc') {
			 display as error ///
			"data have changed since estimation"
			di as err "{p 4 4 2}" 
			di as smcl as err "{bf:margins} after {bf:npregress} "
			di as smcl as err "will not work if your covariates or " 
			di as smcl as err "your dependent variable have changed" 
			di as smcl as err " since estimation." 
			di as smcl as err "{p_end}"
			exit 198		
		}
		preserve, changed	
			quietly npregress kernel `y' `xvars'		///
			if `touse',			 		///
			elnombredey(`nomy') estimator(`kestnm') 	///
			predict(__npreg__pre*, replace) `noderivative'	///
			`bwidth' elmargen(`margen') kernel(`e(kname)')	///
			dkernel(`e(dkname)')		
		_margins_npreg_estimate `zero'
		return add
		restore 
	}
	else {
		_margins_npreg_estimate `0'
		return add
	}
end

program define _margins_npreg_estimate, rclass
        version 15
	syntax [anything] [if] [in] 		///
		[fweight iweight pweight] 	///
		[,				///
		dydx(string)			///
		at(string)			///
		atmeans				///
		atmat(string)			///
		atnames(string)			///
		atnames2(string)		///
		over(string)			///
		subpop(string)			///
		within(string)			///
		noSE				///
		noWEIGHTS			///
		grand				///
		noEsample			///
		noestimcheck			///
		force				///
		Level(cilevel)                  ///
		noatlegend			///
		post				///
		df(string)			///
		cformat(string)			///
		vce(string)			///
		predict(string)			///
		refit(string)			///
		Reps(string)			///
		seed(string)			///
		CONTRast			///
		CONTRast1(string)		///
		PWCOMPare			///
		PWCOMPare1(string)		///
		interaccion_np			///
		*				///
		]
	
	// Parsing options

	strip_refit `0'
	local newzero `"`s(newzero)'"'
	_get_diopts diopts rest, `options'
	
	marksample touse 
	
	tempvar contador 
	quietly generate byte `contador' = e(sample)
	
	if ("`subpop'"!="") {
		cap quietly replace `touse' = `subpop'*`contador'
		local rc = _rc
		if (`rc') {
			 display as error ///
			"option {bf:subpop} incorrectly specified"
			exit 198
		}
	}
	
	quietly replace `touse' = `touse'*`contador'

	gettoken first: newzero, parse(",")
	
	_strip_contrast `anything'
	
	local hascontrast = r(contrast)
	local contrastvars = r(varlist)
	local interact     = 0

	if (`hascontrast') {
		_np_has_contrast, vars(`contrastvars')
		local anything = r(varlist)
		local interact = r(interact)
	}
	
	if (`interact'==0) {
		CuAlQuIeR_CoSa, anything(`anything')	///
			dvars(`e(dvars)')	///
			rest(`rest') 	
		local interact = r(interaction)
	}	
	
	local  y    = e(lhs)
	local yhat  = e(yname)
	local cdnum = e(cdnum)
	
	gettoken bla second: newzero, parse(",")
 
	local tercero "`second'"
	gettoken bli third: tercero, parse(",")
	local fourth: list third & second
	if "`fourth'"!="" {
		local losotros "`fourth'"
	}
	else {
		local losotros  "`third' `second'"
	}
	local comma ","
	local losotros: list losotros - comma
	
	shall_not_allow if `touse', anything(`anything')	///
				   specify(`newzero')	///
				   `rest' `losotros' 	///
				   predict(`predict')	///
				   cdnum(`cdnum')	
	// More vce parsing
	local rest: list rest - grand	
	if ("`predict'"!="") {
		local pstm "predict(mean)"
		local rest: list rest - pstm
		local second: list second - pstm
	}
	
	if (`"`vce'"'!="") {
		local vcesec vce(unconditional)
		local rest: list rest - vce
		local second: list second - vcesec
	}

	// weights 
	tempvar  newwgt ttot 
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
		local wgtc = 0 
		gettoken wgtbc wgtac: exp
		if ("`weight'"=="fweight"|"`weight'"=="iweight") {
			local wgtc = 1
		}
		egen `ttot' = total(`wgtac') if `touse'
		if (`wgtc'==0) {
			clonevar `newwgt' = `wgtac'
			summarize `touse', meanonly 
			local n = r(N)
			quietly replace `newwgt' = `newwgt'*`n'/(`ttot')
			quietly replace `ttot' = `n'
			local wgt "[iweight =`newwgt']"
		}	 
	}
	if ("`weight'"=="" & "`e(wtype)'"!="") {
		local wgtb "`e(wtype)'"
		if ("`e(wtype)'"=="pweight") {
			local  wgtb "iweight"
		}
		local wgta "`e(wexp)'"
		local wgt "[`wgtb' `wgta']"
	}
	
	_anything_sanity if `touse', anything(`anything')
	
	// margins without arguments 
	
	if ("`anything'"=="" & "`rest'"=="" & ///
		("`second'"==""| ("`atnames'"=="" & "`at'"=="")) ///
			& "`dydx'"==""){
		tempname b0 b1 V0 V1 errar
		if ("`over'"=="" & "`within'"=="") {
			casezero if `touse' `wgt'
		}
		else {
			local overnew "`over' `within'"
			local overnew : list uniq overnew
			casezeroover if `touse', over(`overnew')
			local lista "`r(lista)'"
			return local lista "`lista'"
		}
		matrix `b0' = r(b0)
		matrix `V0' = J(colsof(`b0'), colsof(`b0'), 0)
		matrix `b1' = r(b0)
		matrix `V1' = J(colsof(`b0'), colsof(`b0'), 0)
		local   N   = r(N)
		
		_an_exact_zero, beta(`b1') 
		matrix `errar' = r(error)
		local exactzero  = `r(exactzero)'
		return scalar exactzero = `exactzero'
		return matrix error = `errar'
		return matrix b0 = `b0'
		return matrix V0 = `V0'
		return matrix b1 = `b1'
		return matrix V1 = `V1'
		return scalar N  = `N'
		
	}
	
	// margins with no options and marginslist 
	
	if ("`anything'"!="" & "`rest'"=="" & ///
		("`second'"=="" | "`atnames'"=="") & "`at'"=="" & ///
			"`dydx'"==""){
		tempname b1 V1 b0 V0 errar
		if ("`over'"=="" & "`within'"=="" & `interact'==0) {
			caseuno if `touse' `wgt', anything(`anything') 
			matrix `b1' = r(b1)
			matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
			local N     = r(N)
			_an_exact_zero, beta(`b1') 
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return matrix b1 = `b1'
			return matrix V1 = `V1'
			return scalar N  = `N'
		}
		if (("`over'"!="" | "`within'"!="") & `interact'==0) {
			local overnew "`over' `within'"
			local overnew : list uniq overnew
			caseunoover if `touse' `wgt', anything(`anything') ///
				over(`overnew')
			matrix `b0' = r(b0)
			matrix `V0' = r(V0)
			matrix `b1' = r(b1)
			matrix `V1' = r(V1)
			local N     = r(N)
			_an_exact_zero, beta(`b1') 
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return matrix b1 = `b1'
			return matrix V1 = `V1'
			return matrix b0 = `b0'
			return matrix V0 = `V0'
			return scalar N  = `N'
		}
		if ("`over'"=="" & "`within'"=="" & `interact'==1) {
			_contrast_uno if `touse', anything(`anything')
			matrix `b0' = r(b0)
			matrix `b1' = r(b1)
			matrix `V1' = J(colsof(`b0'), colsof(`b0'), 0)
			matrix `V0' = J(colsof(`b0'), colsof(`b0'), 0)
			local N     = r(N)
			_an_exact_zero, beta(`b1') 
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return matrix b1 = `b1'
			return matrix V1 = `V1'
			return matrix b0 = `b0'
			return matrix V0 = `V0'
			return scalar N  = `N'
		}
		if (("`over'"!="" | "`within'"!="") & `interact'==1) {
			local overnew "`over' `within'"
			local overnew : list uniq overnew
			_contrastunoover if `touse', ///
				anything(`anything') over(`overnew')
			matrix `b0' = r(b0)
			matrix `b1' = r(b1)
			matrix `V1' = J(colsof(`b0'), colsof(`b0'), 0)
			matrix `V0' = J(colsof(`b0'), colsof(`b0'), 0)
			local N     = r(N)
			_an_exact_zero, beta(`b1') 
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return matrix b1 = `b1'
			return matrix V1 = `V1'
			return matrix b0 = `b0'
			return matrix V0 = `V0'
			return scalar N  = `N'
		}
	}
	
	// dydx() option with no options and no marginslist

	dydx_unique `second'
	local unica = r(unica)

	if ("`dydx'"!="" & 	///
		(`unica'==1|"`over'"!=""|"`within'"!=""|	///
		"`subpop'"!=""|"`pwcompare'"!="")  ///
		& "`anything'"=="" & (`"`atnames'"'=="" & "`at'"=="")) {
		tempname b1 V1 b0 errar
		if ("`over'"==""  & "`within'"=="") {
			local cdnum = e(cdnum)
			case_dos if `touse' `wgt', dydx("`dydx'")
			local lista      = "`r(lista)'"
			local bfinf      = r(bfinf)
			matrix `b1'      = r(b2)
			matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
			local N       = r(N)
			_an_exact_zero, beta(`b1') dydxs("`lista'") 
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return matrix b1 = `b1'
			return scalar N = `N'
			return matrix V1 = `V1'
			return local lista "`lista'"
			return local dlist "`lista'"
			return scalar bfinf = `bfinf'
		}
		else {
			local overnew "`over' `within'"
			local overnew : list uniq overnew
			casedosover  if `touse' `wgt', dydx("`dydx'")	///
						 over(`overnew')
			local lista      = "`r(lista)'"
			local lista2     = "`r(lista2)'"
			local dlist      = "`r(dlist)'"
			local bfinf      = r(bfinf)
			matrix `b1'      = r(b1)
			matrix `b0'      = r(b1)
			matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
			local N       = r(N)
			_an_exact_zero, beta(`b1') dydxs("`lista'")
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return matrix b1 = `b1'
			return matrix b0 = `b0'
			return scalar N = `N'
			return matrix V1 = `V1'
			return local lista "`lista'"
			return local lista2 "`lista2'"
			return local dlist "`dlist'"
			return scalar bfinf = `bfinf'
		}
	}
	
	// at with no marginslist or other estimation options 

	atmeans_unique `second'
	local unica = r(unica)	
	if ((`"`atnames'"'!=""|"`at'"!="") & `unica'==1 &	///
		"`anything'"=="" & "`dydx'"=="") {
		tempname b1 V1 errar
		if ("`over'"=="" & "`within'"=="") {
			case_tres if `touse' `wgt', atnames(`atnames') ///
						    atmat(`atmat')
			local N       = r(N)
			matrix `b1' = r(b1)
			matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
			_an_exact_zero, beta(`b1') 
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return scalar N = `N'
			return matrix b1 = `b1'
			return matrix V1 = `V1'		
		}
		else {
			local overnew "`over' `within'"
			local overnew : list uniq overnew
			casetresover if `touse' `wgt',	atnames(`atnames') ///
							atmat(`atmat')	   ///
							over(`overnew')	
			local N       = r(N)			
			matrix `b1' = r(b1)
			matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
			local lista "`r(lista)'"
			return local lista "`lista'"
			_an_exact_zero, beta(`b1') 
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return scalar N = `N'	
			return matrix b1 = `b1'
			return matrix V1 = `V1'		
		}
	}
	
	// marginslist with dydx()
	
	if ("`anything'"!="" & "`dydx'"!="" & `"`atnames'"'=="") {
		tempname b1 V1 b0 V0 errar
		if ("`over'"=="" & "`within'"=="" & `interact'==0) {
			_case_cuatro if `touse' `wgt', dydx(`dydx') ///
				anything(`anything')
		}
		if (("`over'"!="" | "`within'"!="") & `interact'==0){
			local overnew "`over' `within'"
			local overnew : list uniq overnew
			casecuatroover if `touse' `wgt', dydx(`dydx') ///
				anything(`anything') over(`overnew')	
		}
		if ("`over'"=="" & "`within'"=="" & `interact'==1) {
			_contrast_cuatro if `touse', ///
				anything(`anything') dydx(`dydx')
		}
		if (("`over'"!="" | "`within'"!="") & `interact'==1){
			local overnew "`over' `within'"
			local overnew : list uniq overnew
			contrastcuatroover if `touse', dydx(`dydx') ///
				anything(`anything') over(`overnew')	
		}
		
		local N       = r(N)
		local dlist      = "`r(dlist)'"
		local lista      = "`r(lista)'"
		matrix `b1' = r(b1)
		matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
		matrix `V0' = `V1'
		matrix `b0' = `b1'
		_an_exact_zero, beta(`b1') dydxs("`lista'")
		matrix `errar' = r(error)
		local exactzero  = `r(exactzero)'
		return scalar exactzero = `exactzero'
		return matrix error = `errar'
		return scalar N = `N'
		return matrix b1 = `b1'
		return matrix V1 = `V1'
		return matrix b0 = `b0'
		return matrix V0 = `V0'
		return local lista "`lista'"
		return local dlist "`dlist'"
	}
	
	// marginslist with at()
	
	if ((`"`atnames'"'!="" | "`at'"!="") & ///
		"`anything'"!="" & "`dydx'"=="") {
		tempname b1 V1 b0 V0 errar
		if ("`over'"=="" & "`within'"=="" & `interact'==0) {
			casecinco if `touse' `wgt', anything(`anything')  ///
					            atnames(`atnames') 	  ///
					            atmat(`atmat')
			local N       = r(N)
			matrix `b1' = r(b1)
			matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
			_an_exact_zero, beta(`b1') 
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return scalar N = `N'
			return matrix b1 = `b1'
			return matrix V1 = `V1'
		}
		if (("`over'"!="" | "`within'"!="") & `interact'==0) {
			local overnew "`over' `within'"
			local overnew : list uniq overnew
			casecinco if `touse' `wgt', anything(`anything') ///
					            atnames(`atnames') 	 ///
					            atmat(`atmat') 	 ///
					            over(`overnew') 	
			local lista = "`r(lista)'"
			local N       = r(N)
			matrix `b1' = r(b1)
			matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
			matrix `V0' = `V1'
			matrix `b0' = `b1'
			_an_exact_zero, beta(`b1') 
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return scalar N = `N'
			return matrix b1 = `b1'
			return matrix V1 = `V1'
			return matrix b0 = `b0'
			return matrix V0 = `V0'
			return local lista "`lista'"
		}
		if ("`over'"=="" & "`within'"=="" & `interact'==1) {
			_contrast_cinco if `touse', anything(`anything')  ///
					            atnames(`atnames') 	  ///
					            atmat(`atmat') 
			local N       = r(N)
			matrix `b1' = r(b1)
			matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
			matrix `V0' = `V1'
			matrix `b0' = `b1'
			_an_exact_zero, beta(`b1') 
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'			
			return matrix error = `errar'
			return scalar N = `N'
			return matrix b1 = `b1'
			return matrix V1 = `V1'
			return matrix b0 = `b0'
			return matrix V0 = `V0'
		}
		if (("`over'"!="" | "`within'"!="") & `interact'==1) {
			local overnew "`over' `within'"
			local overnew : list uniq overnew
			contrastcincoover if `touse', anything(`anything') ///
					              atnames(`atnames')   ///
					              atmat(`atmat') 	   ///
					              over(`overnew') 	
			local lista = "`r(lista)'"
			local N       = r(N)
			matrix `b1' = r(b1)
			matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
			matrix `V0' = `V1'
			matrix `b0' = `b1'
			_an_exact_zero, beta(`b1') 
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return scalar N = `N'
			return matrix b1 = `b1'
			return matrix V1 = `V1'
			return matrix b0 = `b0'
			return matrix V0 = `V0'
			return local lista "`lista'"
		}

	}

	
	// marginslist and at() and dydx() 
	
	if (`"`atnames'"'!="" & "`anything'"!="" & "`dydx'"!="") {
		tempname b1 V1 b0 V0 errar
		if ("`over'"=="" & "`within'"=="" & `interact'==0) {
			caseseis if `touse' `wgt', dydx(`dydx')		/// 
						   atnames(`atnames')	///
						   atmat(`atmat') 	///
						   anything(`anything')
			local dlist = "`r(dlist)'"
			local lista = "`r(lista)'" 
			local N       = r(N)
			matrix `b1' = r(b1)
			matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
			matrix `V0' = `V1'
			matrix `b0' = `b1'
			_an_exact_zero, beta(`b1') dydxs("`lista'")
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return scalar N = `N'
			return local dlist "`dlist'"
			return local lista "`lista'"	
			return matrix b1 = `b1'
			return matrix V1 = `V1'	
			return matrix b0 = `b0'
			return matrix V0 = `V0'	
			if ("`pwcompare'"!="") {
				return scalar bfinf = 1
			}
		}
		if (("`over'"!="" | "`within'"!="") & `interact'==0) {
			local overnew "`over' `within'"
			local overnew : list uniq overnew
			caseseis if `touse' `wgt', dydx(`dydx')		///
					           atnames(`atnames') 	///
						   atmat(`atmat') 	///
						   anything(`anything')	///
						   over(`overnew')
			local dlist = "`r(dlist)'"
			local lista = "`r(lista)'" 
			local N       = r(N)
			matrix `b1' = r(b1)
			matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
			matrix `V0' = `V1'
			matrix `b0' = `b1'
			_an_exact_zero, beta(`b1') dydxs("`lista'")
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return scalar N = `N'
			return local dlist "`dlist'"
			return local lista "`lista'"	
			return matrix b1 = `b1'
			return matrix V1 = `V1'	
			return matrix b0 = `b0'
			return matrix V0 = `V0'		
		}
		if ("`over'"=="" & "`within'"=="" & `interact'==1) {
			_contrast_seis if `touse', dydx(`dydx')		/// 
						   atnames(`atnames')	///
						   atmat(`atmat') 	///
						   anything(`anything')	
			local dlist = "`r(dlist)'"
			local lista = "`r(lista)'" 
			local N       = r(N)
			matrix `b1' = r(b1)
			matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
			matrix `V0' = `V1'
			matrix `b0' = `b1'
			_an_exact_zero, beta(`b1') dydxs("`lista'")
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return scalar N = `N'
			return local lista "`lista'"	
			return matrix b1 = `b1'
			return matrix V1 = `V1'	
			return matrix b0 = `b0'
			return matrix V0 = `V0'	
 	
		}
		if (("`over'"!="" | "`within'"!="") & `interact'==1) {
			local overnew "`over' `within'"
			local overnew : list uniq overnew
			contrastseisover if `touse', dydx(`dydx')	 ///
					             atnames(`atnames')  ///
						    atmat(`atmat') 	 ///
						    anything(`anything') ///
						    over(`overnew')
			*local dlist = "`r(dlist)'"
			local lista = "`r(lista)'" 
			local N       = r(N)
			matrix `b1' = r(b1)
			matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
			matrix `V0' = `V1'
			matrix `b0' = `b1'
			_an_exact_zero, beta(`b1') dydxs("`lista'")
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return scalar N = `N'
			return local lista "`lista'"	
			return matrix b1 = `b1'
			return matrix V1 = `V1'	
			return matrix b0 = `b0'
			return matrix V0 = `V0'		
		}
	}

	
	// Nothing and dydx() with at()
	
	if (`"`atnames'"'!="" & "`anything'"=="" & "`dydx'"!="") {
		tempname b1 V1 b0 V0 errar
		if ("`over'"==""  & "`within'"=="") {
			casesiete if `touse' `wgt', dydx(`dydx') 	///
					            atnames(`atnames')  ///
					            atmat(`atmat')
			
			local dlist = "`r(dlist)'"
			local lista = "`r(lista)'" 
			local N       = r(N)
			matrix `b1' = r(b1)
			matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
			_an_exact_zero, beta(`b1') dydxs("`lista'")
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return scalar N = `N'
			return local dlist "`dlist'"
			return local lista "`lista'"	
			return matrix b1 = `b1'
			return matrix V1 = `V1'	
			return scalar bfinf = 1		
		}
		else {
			local overnew "`over' `within'"
			local overnew : list uniq overnew
			casesiete if `touse' `wgt', dydx(`dydx') 	///
					            atnames(`atnames') 	///
						    atmat(`atmat') 	///
						    over(`overnew')
			local dlist = "`r(dlist)'"
			local lista = "`r(lista)'" 
			local N       = r(N)
			matrix `b1' = r(b1)
			matrix `V1' = J(colsof(`b1'), colsof(`b1'), 0)
			matrix `V0' = `V1'
			matrix `b0' = `b1'
			_an_exact_zero, beta(`b1') dydxs("`lista'")
			matrix `errar' = r(error)
			local exactzero  = `r(exactzero)'
			return scalar exactzero = `exactzero'
			return matrix error = `errar'
			return scalar N = `N'
			return local dlist "`dlist'"
			return local lista "`lista'"	
			return matrix b1 = `b1'
			return matrix V1 = `V1'	
			return matrix b0 = `b0'
			return matrix V0 = `V0'
			return scalar bfinf = 1	
		}
	}
	
end

  ////////////////////////////////////////////////////////////////////////
  //////////////////////////////////// PARSING ///////////////////////////
  ////////////////////////////////////////////////////////////////////////

program shall_not_allow
        syntax [if][in], [anything(string) 	///
		specify(string)			///
		PRedict(string)			///
		EXPression(string)		///
		ASBALanced			///
		CONTRASTuno			///
		contrast(string)		///	
		CONTinuous			///
		PWCOMPAREuno			///
		pwcompare(string)		///	
		vce(string)			///
		emptycells			///
		ESTIMTOLerance(string)		///
		NOCHAINrule			///
		CHAINrule			///
		MCOMPare(string)		///
		eyex(string)			///
		eydx(string)			///
		dyex(string)			///
		dydx(string)			///
		atmeans				///
		cdnum(integer 1)		///
		*				///
		]
	marksample touse 
	quietly capture checkestimationsample
	local rc = _rc
	if (`rc' &  "`e(wtype)'"=="") {
		 display as error ///
		"data have changed since estimation"
		di as err "{p 4 4 2}" 
		di as smcl as err "{bf:margins} after {bf:npregress}"
		di as smcl as err " will not work if your covariates or" 
		di as smcl as err " your dependent variable have changed" 
		di as smcl as err " since estimation." 
		di as smcl as err "{p_end}"
		exit 198		
	}
	if (`rc' & "`e(wtype)'"!="") {
		tempname A B C D
		matrix `A' = e(matsigmg) 
		matrix `C' = e(nchk)
		local b "`e(wtype)'"
		if ("`e(wtype)'"=="pweight") {
			local b "iweight"
		}
		local a "`e(wexp)'"
		local c "`e(lhs)'"
		quietly summarize `c' `if' `in' [`b'`a']
		matrix `B' = r(mean)
		matrix `D' = r(N)
		local varscheck "`e(rhs)'"
		local k: list sizeof varscheck
		forvalues i=1/`k' {
			local xvar: word `i' of `varscheck'
			quietly summarize `xvar' `if' `in' [`b'`a']
			matrix `B' = `B', r(mean)
			matrix `D' = `D', r(N)
		}
		capture assert mreldif(`A',`B') < 1e-8
		local rc = _rc
		capture assert mreldif(`C',`D') < 1e-12
		local rc2 = _rc
		if (`rc'>0 | `rc2'>0) {
			 display as error ///
			"data have changed since estimation"
		       di as err "{p 4 4 2}" 
		       di as smcl as err "{bf:margins} after {bf:npregress}"
		       di as smcl as err " will not work if your covariates or" 
		       di as smcl as err " your dependent variable have changed" 
	               di as smcl as err " since estimation." 
		       di as smcl as err "{p_end}"
		       exit 198			
		}
	}
	if ("`atmeans'"!="" & "`anything'"!="") {
		 display as error ///
		"incorrect {bf:margins} specification after" ///
		" {bf:npregress kernel}"
		di as err "{p 4 4 2}" 
		di as smcl as err " The option {bf:atmeans} is only"
		di as smcl as err " well defined for continuous covariates" 
		di as smcl as err " and {it:marginslist} is only well" 
		di as smcl as err " defined for discrete covariates." 
		di as smcl as err " These options make no sense together." 
		di as smcl as err "{p_end}"
		exit 198		
	}
	if (`cdnum'>1 & "`atmeans'"!=""){
		 display as error ///
		"incorrect {bf:margins} specification after" ///
		" {bf:npregress kernel}"
		di as err "{p 4 4 2}" 
		di as smcl as err "The kernel used for discrete"
		di as smcl as err " covariates is degenerate at values" 
		di as smcl as err " other than the original discrete levels." 
		di as smcl as err " Option {bf:atmeans} is not allowed." 
		di as smcl as err "{p_end}"
		exit 198
	 }
	if ("`anything'"!="") {
		local a ///
		"{bf:margins} specification {bf:margins `specify'} invalid"
	}
	else {
		local a ///
		"{bf:margins} specification {bf:margins `specify'} invalid"
	}
	local b "after {bf:npregress}"
	
	if ("`asbalanced'"!="") {
		display as error ///
		"option {bf:asbalanced} not allowed after {bf:npregress}"
		exit 198
	}
	if ("`continuous'"!="") {
		display as error ///
		     "option {bf:continuous} not allowed after {bf:npregress}"
		di as err "{p 4 4 2}" 
		di as smcl as err "Kernel choice and"		
		di as smcl as err " estimates hinge on the distinction" 
		di as smcl as err " between continuous and discrete variables."
		di as smcl as err "{p_end}"
		exit 198	
	}			
	if ("`predict'"!="mean" & "`predict'"!="") {
		 display as error ///
		"incorrect {bf:margins} specification after" ///
		" {bf:npregress kernel}"
		di as err "{p 4 4 2}" 
		di as smcl as err "{bf:predict()} is only allowed with the"	
		di as smcl as err "argument {bf:mean}. All {bf:margins} "
		di as smcl as err "computations are"		
		di as smcl as err " based on the estimated mean function." 
		di as smcl as err "{p_end}"
		exit 198
	}	
	if ("`expression'"!="") {
		display as error `"`a' `b'"'
		di as err "{p 4 4 2}" 
		di as smcl as err "{bf:expression()} relies on the concept of"
		di as smcl as err " a coefficient vector. Therefore, it is not"
		di as smcl as err "allowed after {bf:npregress}."
		di as smcl as err "{p_end}"
		exit 198
	}
	if ("`vce'"=="delta") {
		display as error `"`a' `b'"'
		di as err "{p 4 4 2}" 
		di as smcl as err "Covariates in {bf:npregress}"
		di as smcl as err " are not assumed to be fixed. "
		di as smcl as err "{p_end}"
		exit 198
	} 
	if ("`emptycells'"!="") {
		display as error `"`a' `b'"'
		di as err "{p 4 4 2}" 
		di as smcl as err " Margins are not obtained as though the"
		di as smcl as err " data were balanced."
		di as smcl as err "{p_end}"	
		exit 198
	}
	if ("`estimtolerance'"!="") {
		display as error ///
		"option {bf:estimtolerance()} not allowed after {bf:npregress}"
		di as err "{p 4 4 2}" 
		di as smcl as err "The concept of estimability used for linear " 
		di as smcl as err "models is not applicable to kernel"
		di as smcl as err " regression. "
		di as smcl as err "{p_end}"	
		exit 198	
	}
	if ("`mcompare'"!="" & "`mcompare'"!="noadjust") {
		display as error `"`a' `b'"'
		di as err "{p 4 4 2}" 
		di as smcl as err "Adjustments for multiple comparisons are " 
		di as smcl as err "not allowed." 
		di as smcl as err "{p_end}"	
		exit 198	
	}
	if ("`eyex'"!=""|"`eydx'"!=""|"`dyex'"!="") {
		display as error `"`a' `b'"'
		di as err "{p 4 4 2}" 	
		di as smcl as err "Elasticities and" 
		di as smcl as err "semielasticities are not available." 
		di as smcl as err "{p_end}"	
		exit 198	
	}
	if ("`dydx'"!="" & "`e(kestnm)'"=="constant" & `e(cdnum)'!=2) {
		display as error `"`a' `b'"'
		di as err "{p 4 4 2}" 
		di as smcl as err "option {bf: dydx()} is not available if"  
		di as smcl as err " {bf:npregress} did not compute derivatives" 
		di as smcl as err "{p_end}"	
		exit 198		
	}
	if ("`chainrule'"!=""|"`nochainrule'"!="") {
		display as error ///
		"incorrect {bf:margins} specification after {bf:npregress}"
		di as err "{p 4 4 2}" 
		di as smcl as err " Derivatives are computed directly."  
		di as smcl as err " This option is" 
		di as smcl as err " unnecessary. "
		di as smcl as err "{p_end}"	
		exit 198	
	}
end

program _varlistcheck, rclass
	syntax [if] [in] [fw pw iw], variables(string)
	
	tempname A B
	if "`weight'" != "" {
                local wgt "[`weight'`exp']"
        }
	local k : word count `variables'
	local varsnew0 ""
	matrix `A' = 0
	forvalues i=1/`k' {
		local x: word  `i' of `variables'
		cap _ms_parse_parts `x'
		local rc   = _rc 
		local voy  = 0
		if (`rc'==0) {
			local type  = r(type)
			local name  = r(name)
			local base  = r(base)
			local level = r(level)
			if ("`type'"=="factor") {
				matrix `A' = `A', `level'
				local voy = 1
			}
			if ("`type'"=="variable") {
				matrix `A' = `A', 0
			}
		}
		else {
			fvexpand `x'
			local kv = r(varlist)
			local b: list sizeof kv
			matrix `B' = J(1, `b', 0) 
			matrix `A' = `A', `B'
		}
	}
	matrix `A' = `A'[1, 2..colsof(`A')]
	_rmcoll `variables' `wgt' `if' `in'
	local varsnew = r(varlist)
	fvexpand `varsnew' `if' `in'
	local vars = r(varlist)
	return local vars = "`vars'" 
	return matrix A   = `A'
	return local voy  = "`voy'"
end 

program CuAlQuIeR_CoSa, rclass
        syntax, [anything(string) 		///
		 dvars(string)			///
		 rest(string)			///
		 ]
	local interaction = 0
	if ("`anything'"!="") { 
		cap fvexpand i.(`anything') 
		local rc = _rc 
		if `rc'>0 {
			display as error ///
				"incorrect {it:marginslist} specification" ///
				" after {bf:npregress}"
			cap noi fvexpand i.(`anything')
			exit 198
		}
		local variables = r(varlist)
		local kd: list sizeof dvars 
		
		forvalues i=1/`kd' {
			local y: word `i' of `dvars'
			_ms_parse_parts `y'
			local nom = r(name)
			local dvarsnew "`dvarsnew' `nom'"
		}
		
		local k: list sizeof variables
		forvalues i=1/`k' {
			local x: word `i' of `variables'
			_ms_parse_parts `x'
			local tipo = r(type)
			if ("`tipo'"!="interaction") {
				local name = r(name)
				local inter: list name & dvarsnew
				if ("`inter'"=="") {
					display as error ///
				    "incorrect {it:marginslist} specification"
					di as err "{p 4 4 2}" 
					di as smcl as err "{it:marginslist}"	
					di as smcl as err " should be a" 	
					di as smcl as err " categorical" 	
					di as smcl as err " variable specified" 
					di as smcl as err " during estimation." 
					di as smcl as err "{p_end}"	
					exit 198
				}
			}
			else {
				local k2 = r(k_names)
				forvalues j=1/`k2' {
					local name = r(name`j')
					local inter: list name & dvarsnew
					if ("`inter'"=="") {
						display as error ///
					    "incorrect {it:marginslist}" ///
					    " specification"
						di as err "{p 4 4 2}" 
					di as smcl as err "{it:marginslist}"	
					di as smcl as err " should be a" 	
					di as smcl as err " categorical" 	
					di as smcl as err " variable specified" 
					di as smcl as err " during estimation." 
					di as smcl as err "{p_end}"	
					exit 198
					}
				}
				local interaction = 1
			}
		}
		return local interaction = `interaction'
	}
end 

program casedos_parse
	syntax, [lista(string) dydx(string)]
	
	if ("`lista'"=="") {
		display as error "option {bf:dydx()} specified incorrectly"
			di as err "{p 4 4 2}" 
			di as smcl as err "`dydx' is not in estimation variable"  
			di as smcl as err " list. "
			di as smcl as err "{p_end}"	
			exit 198
	}
end

program PaRsE_NiVeLeS, sclass
	syntax [if][in], [dvars(string) casezero(integer 0)]
	marksample touse 
	tempname A 
	local k: list sizeof dvars
	local newnivelazo ""
	local j2 = 1
	local noches = 0 
	forvalues i=1/`k' {
		local x: word `i' of `dvars'
		capture quietly tab `x' if `touse', matrow(`A')
		local rc = _rc
		if (`rc'> 0) {
			_ms_parse_parts `x'
			local nightlab = r(name)
			local nightlev = r(level)
			local newnivelazo "`newnivelazo' `nightlev'"
			tempvar night
			quietly generate `night' = `x'
			quietly tab `night', matrow(`A')
			local noches = `noches' + 1 
		}
		local k2 = r(r)
		if (`rc'>0) {
			local a: value label `nightlab'
			if ("`a'"!="") {
				label values `night' `a'
			}
			fvexpand i.`night' if `touse'
		}
		else {
			local a: value label `x'
			fvexpand i.`x' if `touse'
		}
		local nivel = e(niveles)
		local fvlist = r(varlist)

		forvalues j=1/`k2' {
			local p0: word `j' of `fvlist'
			_ms_parse_parts `p0'
			local p1 = r(base)
			if ("`a'"!="" & ///
			   ((`p1'==0 & `casezero'==0)| `casezero'==1)) {
				local j3 = `A'[`j',1]
				local w: label `a' `j3'
				local w =  subinstr("`w'"," ","",.)
				if (`noches'==0) {
					local newnivelazo "`newnivelazo' `w'"
				}
				local j2 = `j2' + 1
			}
			if ("`a'"=="" & ///
			   ((`p1'==0 & `casezero'==0)| `casezero'==1)) {
				local w: word `j2' of `nivel'
				local w =  subinstr("`w'"," ","",.)
				if (`noches'==0) {
					local newnivelazo "`newnivelazo' `w'"
				}
				local j2 = `j2' + 1
			}
			if (`p1'==1 & `casezero'==0) {
				if (`noches'==0) {
					local newnivelazo "`newnivelazo'"
				}
				local j2 = `j2' + 1
			}
		}
		local noches = 0 
	}
	sreturn local newnivelazo "`newnivelazo'"
end

program define UnIqUeLy_opts, rclass
	syntax, [sopt(string) segundo(string) atnames(string) atmat(string)]
	
	if ("`atnames'"!= "" | "`atmat'"!= "") {
		local inter: list sopt - atnames
		local unica = 1
		if "`inter'"!="" {
			display "`inter'"
			local unica = 0
		}
	}
	else {
		local sopt0 "`sopt'"
		local sopt2 "`sopt' ,"
		local sopt1: list sopt0 | segundo
		
		if ("`sopt1'"=="`sopt0'"|"`sopt1'"=="`sopt2'") {
			local unica = 1
		}
		else {
			local unica = 0 
		}
	}
	return local unica = `unica'
end

program define VaRlIsT_Ob, rclass
	local varlist = `"`e(variables)'"'
	local k: word count `varlist'
	local sinob ""
	forvalues i=1/`k' {
		local base = 0
		local x: word `i' of `varlist'
		_ms_parse_parts `x'
		if ("`r(type)'"=="variable") {
			local base = 0
		}
		else {
			local base = `r(base)'
		}
		if (`base'!=1) {
			local sinob "`sinob' `x'"
		} 
	}
	return local sinob "`sinob'"
end

program define strip_refit, sclass
	syntax [anything][if] [in] 		///
		[fweight iweight pweight] 	///
		, [refit(string) *]
	gettoken uno dos: 0, parse(",")
	local newzero `"`uno', `options'"'
	sreturn local newzero `"`newzero'"'
end

program define dydx_unique, rclass
	syntax, [dydx(string) post 		///
		 over(string)			///
		 subpop(string)			///
		 within(string)			///
		 noSE				///
		 noWEIGHTS			///
		 PWCOMPare			///
		 noEsample			///
		 noestimcheck			///
		 force				///
		 Level(cilevel)                 ///
		 noatlegend			///
		 df(string)			///
		 cformat(string)		///
		 vce(string)			///
		 predict(string)		///
		 refit(string)			///
		 Reps(string)			///
		 contrast(string)		///
		 seed(string)			///
		 *				///
		 ]
	local unica = 1 
	if ("`options'"!="") {
		local unica = 0 
	}
	return local unica = `unica'
end 

program define atmeans_unique, rclass
	syntax, [post 				///
		 over(string)			///
		 subpop(string)			///
		 within(string)			///
		 noSE				///
		 noWEIGHTS			///
		 PWCOMPare			///
		 noEsample			///
		 noestimcheck			///
		 force				///
		 Level(cilevel)                 ///
		 noatlegend			///
		 df(string)			///
		 cformat(string)		///
		 vce(string)			///
		 predict(string)		///
		 refit(string)			///
		 Reps(string)			///
		 seed(string)			///
		 atmeans			///
		 atnames(string)		///
		 contrast(string)		///
		 atmat(string)			///
		 *				///
		 ]
	local unica = 1 
	if ("`options'"!="") {
		local unica = 0 
	}
	return local unica = `unica'
end 

  ////////////////////////////////////////////////////////////////////////
  //////////////////////////////////// CASES /////////////////////////////
  ////////////////////////////////////////////////////////////////////////


program define casezero, rclass
	syntax [if] [in] [fw pw iw]
	tempname b0 V0 BC nhs
	tempvar yhat rdos newwgt ttot touse sigma ehat fden ehat2 naranjas
	local myvar   = "`e(yname)'"
	local myvarse = "`e(sename)'" 
	capture confirm numeric variable `e(yname)'
	local rc = _rc
	local wgtc = 0 
	marksample touse 
	if("`e(wexp)'"!="") {
		local wgtb "`e(wtype)'"
		if ("`e(wtype)'"=="pweight") {
			local  wgtb "iweight"
		}
		local wgta "`e(wexp)'"
		local wgt "[`wgtb' `wgta']"
		local wgtc = 0 
		gettoken wgtbc wgtac: wgta
		if ("`weight'"=="fweight"|"`weight'"=="iweight") {
			local wgtc = 1
			clonevar `newwgt' = `wgtac' if `touse'
		}
		egen `ttot' = total(`wgtac') 
		if (`wgtc'==0) {
			clonevar `newwgt' = `wgtac'
			summarize `touse', meanonly 
			local n = r(N)
			quietly replace `newwgt' = `newwgt'*`n'/(`ttot')
		}	
	}
	else {
		quietly generate `newwgt' = 1
	}
	if (`rc') {
		quietly generate byte `naranjas' = 1
		quietly generate double `yhat'   = . 
		quietly generate double `rdos'   = .
		quietly generate double `sigma'  = .
		quietly generate double `fden'   = .
		quietly generate double `ehat2'  = .
		mata: _kernel_regression(`e(ke)', "`e(cvars)'", 	 ///
		"`e(dvars)'", "`e(lhs)'", "`e(kest)'", "`yhat'", 1, 	 ///
		"e(pbandwidths)", `e(aicm)', `e(cdnum)', 1, "`rdos'", 0, ///
		`e(tolerance)', `e(ltolerance)', `e(iterate)', 0, 0,	 ///
		`e(nmsdelta)', `e(cellnum)', "`newwgt'", "`naranjas'",	 ///
		"e(converged_mean)", "e(ilog_mean)", "`touse'")

		quietly summarize `yhat' if `touse', meanonly
		matrix `b0' = r(mean)
		local  N    = r(N) 
	}
	else {
		quietly summarize `myvar' if `touse', meanonly
		matrix `b0' = r(mean)
		local  N    = r(N) 
	}
	matrix colnames `b0' = _cons

	return matrix b0 = `b0'
	return local  N  = `N'
end

program define caseuno, rclass
	syntax [if] [in] [fw pw iw], anything(string)
	
	marksample touse 
	tempname dvarlist gradsen gbase indica b1 V1 usar basev uniq	///
		 hband rdos dgselist A avars H HC usarnew H2 pomatrix	///
		 HT 
	tempvar ehat2 ehat fden newwgt 
	
	// Weights 
	local wgtc = 0 
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
		gettoken wgtbc wgtac: exp
		if ("`weight'"=="fweight"|"`weight'"=="iweight") {
			local wgtc = 1
		}
		if (`wgtc'==0) {
			local wgt "[iweight =`newwgt']"
		}
		clonevar `newwgt' = `wgtac'	
	}
	else {
		quietly generate `newwgt' = 1
	}
	
	local dvars     = "`e(dvars)'"
	local cvars     = "`e(cvars)'"
	local eqnoms    = "`e(repito2)'"
	local eqnoms2   = "`e(repito)'"
	local eq1: list sizeof eqnoms
	local eq2: list sizeof eqnoms2	
	local lhs       = "`e(lhs)'"
	local rhs       = "`e(rhs)'"
	matrix `A'      = nullmat(`A')
	matrix `basev'  = e(basevals)
	matrix `uniq'   = e(uniqvals)
	matrix  `hband' = e(bandwidthgrad)
	local ku:  list sizeof dvars
	matrix `usar' = J(1, `ku', 0)
	local yesrhs = e(yesrhs)
	local quieto0 = e(quieto)
	local quieto1 = e(quieto3)
	if (`yesrhs'==0) {
		fvexpand i.(`anything') if `touse'
		local otro = r(varlist)
	}
	else {
		local kuu: list sizeof anything
		forvalues i=1/`kuu' {
			local auu: word `i' of `anything'
			local buu: list auu & dvars
			if ("`buu'"!="") {
				fvexpand i.(`auu') if `touse'
				local otrosi = r(varlist)
				local otro "`otro' `otrosi'"
			}
			else {
				local otro "`otro' `auu'"	
			}
		}
	} 

	local casos = 0 
	local kotro: list sizeof otro
	local pos ""
	local posl ""
	local listvars ""
	local listvars2 ""
	local selistvars ""
	local selistvars2 ""
	local dlistvars ""
	local dvarlist ""
	local gradsen ""
	local selist ""
	local dgselist ""
	local dnames   ""
	local colnames ""
	local dvarnew   ""
	
	local j = 1
		local k = rowsof(e(basevals))
		forvalues i = 1/`k' {
			tempvar d`i' dse`i' selist`i' dgselist`i'
			quietly generate `d`i''= . if `touse'
			quietly generate `dse`i''= . if `touse'
			quietly generate `selist`i''= . if `touse'
			quietly generate `dgselist`i''= . if `touse'
			local dvarlist "`dvarlist' `d`i''"
			local gradsen  "`gradsen' `dse`i''"
			local selist   "`selist' `selist`i''"
			local dgselist   "`dgselist' `dgselist`i''"
		}

		mata: _kernel_margins_marginslist(`e(ke)', 		///
		      "`e(cvars)'", "`e(dvars)'", "`e(lhs)'",		///
		      "`dvarlist'", "`gradsen'", "e(pbandwidths)", 	///
		      `e(cdnum)',  "e(basevals)", "e(uniqvals)", 	///
		      "`e(kest)'", `e(cellnum)', "`newwgt'", "`touse'")

		forvalues i = 1/`ku' {
			local a: word `i' of `dvars'
			fvexpand i.`a'
			local c = r(varlist)
			if ("`a'"=="c") {
				local usarzeros = 1
			}
			else {
				local usarzeros = 0				
			}
			local kcufn: list sizeof c
			local c2dos ""
			forvalues j=1/`kcufn' {
				local c2x: word `j' of `c'
				_ms_parse_parts `c2x'
				local c2xl = r(level)
				local c2xn = r(name)
				local c2dos "`c2dos' `c2xl'.`c2xn'"
			}
			local b: list a & anything
			local d: list c & anything
			local dc2x: list c2dos & anything
			local f: list a & otro
			local g: list c & otro
			local gc2x: list c2dos & otro
			
			if ("`b'"!=""|"`d'"!=""|"`g'"!=""|"`f'"!=""| ///
			     "`dc2x'"!=""|"`gc2x'"!="") {
				matrix `usar'[1,`i'] = 1
			}
		} 

		PaRsE_NiVeLeS, dvars("`e(dvars)'") casezero(1)
		local veqlev    = "`s(newnivelazo)'"
		local dvars     = "`e(dvars)'"
		local dvarszero = "`dvars'"
		matrix `basev'  = e(basevals)
		matrix `uniq'   = e(uniqvals)

		tempname tester 	
		mata: _kernel_margins_list("`basev'", "`uniq'",	///
		      "`dvars'", "`usar'", "`dvarlist'", 	///
		      "`eqnoms'", "`tester'")	

		local ku: list sizeof dvars
		local jk = 0 
		forvalues i=1/`ku' {
			local z: word `i' of `dvars'
			capture tab `z'
			local rc = _rc
			if (`rc') {
				local dvarz "`dvarz' `z'"
				local quieto2 "`quieto2' movete"
			}
			else {
				local dvarz "`dvarz' `z'"
				local quieto2 "`quieto2' quieto"
			}
		} 
		
		// Getting list for r(b) 
			
		if (`yesrhs'==0) {
			fvexpand i.(`dvars') if `touse'
			local newdvars = r(varlist)
		}
		else { 
			_lista_yesrhs `dvarz' if `touse', quieto(`quieto2')
			local newdvars = "`s(lyesrhsrep)'"	
			local quietico = "`s(quietico)'"	
		}
		
		local knv: list sizeof newdvars
		matrix `usarnew' = J(1, `knv', 0)	
		forvalues i=1/`kotro' {
			local b: word `i' of `otro'
			_ms_parse_parts `b'
			local posn  = r(name)
			local nva = r(level)
			local pos "`pos' `posn'"
			forvalues j=1/`knv' {
				local a: word `j' of `newdvars'
				local qza: word `j' of `quietico'
				_ms_parse_parts `a'
				local nvb   = r(level)
				local posnb = r(name)
				if (("`a'"=="`b'" & ///
				     "`nvb'"=="`nva'") | ///
				     ("`posn'"=="`posnb'" & ///
					"`nvb'"=="`nva'") ) {
					if (`yesrhs'==0) {
						matrix ///
						`usarnew'[1,`j'] = 1
					}
					else if ("`qza'"=="uno") {
						matrix ///
						`usarnew'[1,`j'] = 1						
					}
					local colnames ///
						"`colnames' `a'"
				}
			}
		}

		local pos: list uniq pos
		local kpos: list sizeof pos
		local m = 1
		matrix `pomatrix' = J(1, `knv', 0)
		forvalues j=1/`kpos' {
			local b: word `j' of `pos'
			_ms_parse_parts `b'
			local lb = r(level)
			forvalues i=1/`knv' {
				local nkn: word `i' of `newdvars'
				_ms_parse_parts `nkn'
				local a  = r(name) 
				if ("`a'"=="`b'") {
					matrix `pomatrix'[1,`i'] = `m'
					local m = `m' + 1
				}
			}
		}

		matrix `usarnew' = (`usarnew'\(`pomatrix'))'
		mata: st_matrix("`usarnew'", 	///
			sort(st_matrix("`usarnew'"), 2))
		matrix `usarnew' = `usarnew''
		matrix `usarnew' = `usarnew'[1,1..colsof(`usarnew')]		
		local pok = colsof(`pomatrix')
		local klv: list sizeof dvarlist
		forvalues i=1/`klv'{
			forvalues j = 1/`pok' {
				if (`pomatrix'[1,`j']==`i') {
					local a: word `j' of `dvarlist'
					local listvars ///
					"`listvars' `a'"
				}
			}
		}

		forvalues i=1/`klv' {
			if (`usarnew'[1,`i']==1) {
				local c: word `i' of `listvars'
				local listvars2 "`listvars2' `c'"
			}
		}

		local dvars     = "`e(dvars)'"
		local eqnoms    = "`e(repito2)'"
		matrix `basev'  = e(basevals)
		matrix `uniq'   = e(uniqvals)
		matrix  `hband' = e(bandwidthgrad)
		local kbeta: list sizeof listvars2
		forvalues i=1/`kbeta' {
			local a: word `i' of `listvars2'
			local c: word `i' of `selistvars2'	
			summarize `a' if `touse' `wgt', meanonly
			local b = r(mean)
			local N = r(N)
			matrix `b1' = nullmat(`b1'), `b'
		} 
		return matrix b1 = `b1'
		return scalar N  = `N'
end

program define case_dos, rclass
	syntax [if] [in] [fw pw iw], dydx(string)

	marksample touse 
	tempname muso b2 V2 tracks
	tempvar newwgt
	
	// Weights 
	
	local wgtc = 0 
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
		gettoken wgtbc wgtac: exp
		if ("`weight'"=="fweight"|"`weight'"=="iweight") {
			local wgtc = 1
		}
		if (`wgtc'==0) {
			local wgt "[iweight =`newwgt']"
		}
		clonevar `newwgt' = `wgtac'	
	}
	else {
		quietly generate `newwgt' = 1
	}
	
	
	local listad  = "`e(dvars)'"
	local listac  = "`e(cvars)'"
	local quieto  = "`e(quieto)'"
	local quieto2 = "`e(quieto2)'"
	local yesrhs  = e(yesrhs)
	local cdnum   = e(cdnum)
	if (`cdnum'==1) {
		local tuti "`listac'"
	}
	if (`cdnum'==2) {
		local tuti "`listad'"
	}
	if (`cdnum'==3) {
		local tuti "`listac' `listad'"
	}
	fvexpand `dydx'
	local dydx0 = r(varlist)
	local tutituti: list tuti & dydx0
	local todas = 0 
	local espacio = 1 

	if ("`tuti'"=="`tutituti'" | "`dydx'"=="*" | ///
		"`dydx'"=="_all" ) {
		local todas = 1 
		local espacio = 0
		if (`cdnum'==1) {
			fvexpand `listac'
			local lalista = r(varlist)		
		}
		if (`cdnum'==2) {
			if (`yesrhs'==0) {
				fvexpand i.(`listad')
				local lalista = r(varlist)
			}
			else {
				_lista_yesrhs `listad', quieto(`quieto')
				local lalista = "`s(lyesrhs)'"
			}		
		}
		if (`cdnum'==3) {
			if (`yesrhs'==0) {
				fvexpand `listac' i.(`listad')
				local lalista = r(varlist)	
			}
			else {
				_lista_yesrhs `listad', quieto(`quieto')
				local lalistad = "`s(lyesrhs)'"
				local lalista "`listac' `lalistad'"	
			}
		}
		local h "`lalista'"
	}
	else {
		if (`cdnum'==1) {
			fvexpand `dydx'
			local dydx2 = r(varlist)
			fvexpand `listac' if `touse'
			local lalista = r(varlist)	
			local a: list listac  & dydx2	
			local b: list lalista & dydx2	
			local c "`a' `b'"
			local h: list uniq c		
		}
		if (`cdnum'==2) {
			_lista_yesrhs `dydx', quieto(`quieto') dq(`quieto2')
			local dydx2 = "`s(lyesrhs)'"
			_lista_yesrhs `listad', quieto(`quieto') 

			local lalista = "`s(lyesrhs)'"
			local a: list listad  & dydx2	
			local b: list lalista & dydx2	
			local c "`a' `b'"	
			local h: list uniq c		
		}
		if (`cdnum'==3) {
			local dydx22 "`dydx'"
			local kdydxh: list sizeof dydx22
			forvalues i=1/`kdydxh' {
				local xdydx2: word `i' of `dydx22'
				capture _ms_parse_parts `xdydx2'
				local rc = _rc
				if (`rc') {
					fvexpand `xdydx2'
					local tempx = r(varlist)
					local dydx22 "`dydx22' `tempx'"
				}
			}
			_lista_yesrhs `listad', quieto(`quieto') 
			local lalistad = "`s(lyesrhs)'"
			local lalista "`listac' `lalistad'"
			local a0 "`lalistad'"
			local dydx3: list dydx22 & listad
			local dydx32: list dydx22 & lalistad
			local dydx5: list dydx22 & listac
			if ("`dydx3'"!=""|"`dydx32'"!="") {
				_lista_yesrhs `dydx3' `dydx32', ///
					quieto(`quieto') dq(`quieto2')
				local dydx4 = "`s(lyesrhs)'"
			}
			local dydx1 "`dydx5' `dydx4'" 
			local a: list listac  & dydx1	
			local b0: list dydx1 - a
			if ("`b0'"!="") {
				_lista_yesrhs `b0',	///
					quieto(`quieto') dq(`quieto2')
				local b1 = "`s(lyesrhs)'"
			}
			local b: list b1 & a0
			local dydx2 "`a' `b1'" 
			local g: list lalista & dydx2	
			local c "`a' `b' `g'"
			local h: list uniq c
			local btable "`b'"
		}
		casedos_parse, lista("`h'") dydx("`dydx'")
	}

	local kl: list sizeof lalista 
	local km: list sizeof h
	local lalista2 ""
	local lalista3 ""
	local h2 ""
	local eqnoms ""
	local nivelc ""
	if (`todas'== 0) {
		local ccount = 0
	} 
	else {
		local ccount: list sizeof listac
	}
	forvalues i=1/`kl' {
		local x: word `i' of `lalista'
		_ms_parse_parts `x'
		local a = r(base)
		local b = r(name)
		local d = r(level)
		if (`a'!=1) {
			local lalista2 "`lalista2' `x'"
			local eqnoms "`eqnoms' `b'"
			if ("`a'"==".") {
				local nivelc "`nivelc' _cons"
			}
		}
	}
	forvalues i=1/`km' {
		local x: word `i' of `h'
		_ms_parse_parts `x'
		local a = r(base)
		local p = r(type)
		local b = r(name)
		if (`a'!=1) {
			local h2 "`h2' `x'"
			if ("`p'"=="variable" & `todas'== 0) {
				local ccount = `ccount' + 1
			}
		}
	}
	
	if ("`km'"=="`kl'") {
		local todas = 1 
	}
	
	if ("`h2'"=="" & `todas'==0) {
		di as error "option {bf:dydx()} specified incorrectly"
		exit 198			
	}
	
	local kl: list sizeof lalista2 
	local km: list sizeof h2
	
	matrix `muso' = J(1, `kl', 0)
	if (`todas'==0) {
		forvalues i=1/`km' {
			forvalues j=1/`kl' {
				local x: word `i' of `h2'
				local z: word `j' of `lalista2'
				local w: list x & z
				if "`w'"!="" {
					matrix `muso'[1,`j'] = 1
				}
			}
		}
	}

	local dvarlist   = "`e(cigradnoms)'"
	local dvarlistse = "`e(cigradnomse)'"
	
	PaRsE_NiVeLeS, dvars("`e(dvars)'") 
	local nivel  = "`nivelc'`s(newnivelazo)'"

	if (`todas'==0) {
		mata: _kernel_dydx_list("`muso'", "`dvarlist'",	///
		"`eqnoms'", "`nivel'", "`lalista2'")
	}

	local kll: list sizeof lalista2
	local jk = 0
	forvalues i=1/`kll' {
		local xkll: word `i' of `lalista2'
		_ms_parse_parts `xkll'
		local tipo = r(type)
		local nomx = r(name)
		if ("`tipo'"=="factor") {
			quietly capture tab `xkll'
			local rc = _rc
			if `rc' {
				fvexpand i.(`nomx')
				local tempxl1 = r(varlist)
				local kll2: list sizeof tempxl1
				forvalues j=1/`kll2' {
					local xkll1: word `j' of `tempxl1'
					local mix: list xkll1 & xkll
					_ms_parse_parts `xkll1'
					local base = r(base)
					local op   = r(op)
					if ("`mix'"!="") {
						local jk = 1
					}
					if (`base'==1 & `jk'==0) {
						local tempx ///
							"`op'.`nomx' `xkll'"
					}
					if (`base'==1 & `jk'==1) {
						local tempx ///
							"`xkll' `op'.`nomx'"
					}
				}
			}
			else {
				fvexpand i.(`nomx')
				local tempx = r(varlist)
			} 
			
			local lalista3 "`lalista3' `tempx'"
		}
		else {
			local lalista3 "`lalista3' `xkll'"
		}
	}
	local lalista3: list uniq lalista3
	
	local kdv: list sizeof dvarlist
	matrix `b2' = J(1, `kdv', 0)
	matrix `V2' = J(`kdv', `kdv', 0)
	
	local colnames ""
	forvalues i=1/`kdv' {
		local x: word `i' of `dvarlist'
		local z: word `i' of `dvarlistse'
		local m: word `i' of `eqnoms'
		local q: word `i' of `nivel'
		summarize `x' if `touse' `wgt', meanonly
		matrix `b2'[1,`i'] = r(mean)
		summarize `z' if `touse' `wgt', meanonly
		matrix `V2'[`i',`i'] = r(mean)
		local colnames "`colnames' `m':`q'"
	}
	local N = r(N)
	return local N       = `N'
	
	tempname covar_np
	quietly correlate `dvarlist', cov
	matrix `covar_np' = r(C)
	mata: _np_covariances_se("`covar_np'", `N')
	matrix `V2' = `V2' + `covar_np'
	
	local bfinf        = 1
	return local lista "`lalista3'"
	return local dlist "`lalista3'"
	return local espacio = `espacio' 
	return local todas   = `todas'
	return local btable "`btable'"
	return local ccount  = `ccount'
	return scalar bfinf  = `bfinf'
	return matrix b2     = `b2'
	return matrix V2     = `V2'
end

program define case_tres, rclass
	syntax [if] [in] [fw pw iw], atnames(string) atmat(string)
	tempname A AT atmatrix atnew cuentas prelim dorc posx rdos	///
		 b1 V1 fin vmatrix 
	
	tempvar newwgt
	
	marksample touse 
	
	// Weights 
	
	local wgtc = 0 
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
		gettoken wgtbc wgtac: exp
		if ("`weight'"=="fweight"|"`weight'"=="iweight") {
			local wgtc = 1
		}
		if (`wgtc'==0) {
			local wgt "[iweight =`newwgt']"
		}
		clonevar `newwgt' = `wgtac' if `touse'
	}
	else {
		quietly generate `newwgt' = 1 if `touse'
	} 	 
		 
	local covariates `"`e(covariates)'"'
	local allvars    `"`e(allvars)'"'
	local dvarsat    `"`e(dvars)'"'
	local cvarsat    `"`e(cvars)'"'
	local rhzero     `"`e(rhzero)'"'
	local quietoat   `"`e(quieto3)'"'
	local yesrhs     = e(yesrhs)
	local  y         = e(lhs)
	local stripe ""
	local tipo ""
	local nombre ""
	local namesrhs ""
	local newxvars ""
	local newdvars ""
	local newcvars ""
	local evars ""
	local kcm: list sizeof cvarsat
	local kdm: list sizeof dvarsat
	local rhs = "`e(rhzero)'"
	local krh: list sizeof rhs
	matrix `dorc' = J(1, `krh', 0)
	matrix `posx' = J(1, `krh', 0)
	forvalues i=1/`krh' {
		local a: word `i' of `rhs'
		fvexpand `a'
		local b = r(varlist)
		local b: word 1 of `b'
		_ms_parse_parts `b'
		local c = r(name)
		local namesrhs "`namesrhs' `c'"
	}
	local k: list sizeof covariates
	matrix `atmatrix' = `atmat'
	local k2 = rowsof(`atmatrix')
	matrix `A'   = J(1, `k', 0)

	forvalues i=1/`k' {
		local a: word `i' of `covariates'
		local stripe "`stripe' `y':`a'"
		_ms_parse_parts `a'
		local b   = r(type)
		local c   = r(name)
		local mtf = r(level)
		local tipo "`tipo' `b'"
		local qa: word `i' of `quietoat'
		if ("`qa'"=="quieto") {
			local nombre "`nombre' `c'"
		}
		else {
			local nombre "`nombre' `a'"
		}
	}

	local fordorc: list uniq nombre

	forvalues i=1/`krh' {
		local ft0: word `i' of `fordorc'
		local ftc: list ft0 & cvarsat
		if ("`ftc'"!="") {
			matrix `dorc'[1,`i'] = `i'
		}
		else {
			matrix `dorc'[1,`i'] = -`i'
		}
		forvalues j=1/`krh' {
			local alist: word `i' of `fordorc'
			local alist2: word `i' of `rhzero'
			local blist: word `j' of `allvars'
			if ("`alist'"=="`blist'"|"`alist2'"=="`blist'") {
				matrix `posx'[1,`i'] = `j' 
			}
		}
	} 

	local j = 1
	matrix colnames `A' = `stripe'
	_ms_at_parse `at', asobserved mat(`A')
	local estad    = r(statlist)
	local atvars   = r(atvars)
	local atvars1 "`atvars'"
	local  stats1  "`estad'"
	local pct ""
	forvalues i=1/99 {
		local pct "p`i'"
	}
	local listas "asobserved asbalanced value values"
	local lista1 "mean median min max `pct' zero base `listas'"
	local 0 `",`atnames'"'
	syntax [, at(string) *]

	while (`:length local at'){
		_ms_at_parse `at', asobserved mat(`A')
		local estad    = r(statlist)
		local atvars   = r(atvars)
		local atvars`j' "`atvars'"
		local  stats`j'  "`estad'"		
		local kgtk = colsof(`A')
		local empiezo "`stats`j''"
		local final ""
		forvalues ppd=1/`kgtk' {
			gettoken empiezo depord: empiezo, match(paren) bind
			local empiezo = subinstr("`empiezo'"," ","",.) 
			local final "`final' `empiezo'"
			local empiezo "`depord'"
		}
		local final2 ""
		forvalues ppd=1/`kgtk' {
			local ppdx: word `ppd' of `final'
			local interpp: list ppdx & lista1
			if ("`interpp'"=="") {
				local final2 "`final2' (`ppdx')"
			}
			else {
				local final2 "`final2' `ppdx'"
			}
		}
		local stats`j' "`final2'"
		local estad "`stats`j''" 
		local j = `j' + 1
		forvalues i=1/`k' {
			local a: word `i' of `estad'
			if ("`a'"=="("| "`a'"==")") {
				local innew = `i' + 1
				local a: word `innew' of `estad'
				local anew "`a'"
			}
			local b: word `i' of `tipo'
			local c: word `i' of `nombre'
			local inter: list c & atvars
			if ("`a'"=="mean" & "`b'"=="factor" & ///
			    "`inter'"!="") {
				 display as error ///
				"incorrect {bf:margins}"	///
				 " specification after"		///
				 " {bf:npregress kernel}"
				di as err "{p 4 4 2}" 
				di as smcl as err "The kernel used for" 
				di as smcl as err " discrete"
				di as smcl as err " covariates is" 
				di as smcl as err " only well defined"
				di as smcl as err "for the original " 
				di as smcl as err " values of the" 
				di as smcl as err " discrete"
				di as smcl as err " covariates."
				di as smcl as err " The kernel is"
				di as smcl as err " degenerate at " 
				di as smcl as err " values other than" 
				di as smcl as err " the original"
				di as smcl as err " discrete levels." 
				di as smcl as err "{p_end}"
				exit 198
			} 
		}
		local 0 `",`options'"'
		syntax [, at(string) *]
	}
	local pct ""
	forvalues i=1/99 {
		local pct "p`i'"
	}
	local listas "asobserved asbalanced value values"
	local lista1 "mean median min max `pct' zero base `listas'"
	
	matrix `cuentas' = J(1, `k2', 0)
	
	forvalues i=1/`k2' {
		local cuentas`i' = 0 
		local nom`i' ""
		local xvars`i' "" 
		forvalues j=1/`k' {
			if ("`stats`i''"==""){
				local b: word `j' of `stats1'
			}
			else {
				local b: word `j' of `stats`i''
			}
			local var: word `j' of `covariates'
			local qat: word `j' of 	`quietoat'
			_ms_parse_parts `var'
			local nivel   = r(level)
			local tipo    = r(type)
			local nom     = r(name)		
			if ("`qat'"=="movete") {
				local nom "`var'"
			}
			if (`j'==1) {
				local nomprev "."
			}	
			if (`atmatrix'[`i',`j']==1 &	///
				"`tipo'"=="factor") {
				tempvar x`i'`j'
				if ("`qat'"=="movete") {
					quietly generate double `x`i'`j'' = ///
						1 
				}
				else {
					quietly generate double `x`i'`j'' = ///
					`nivel' 
				}
				local cuentas`i' = `cuentas`i'' + 1 
				local nom`i' "`nom`i'' `nom'" 
				local xvars`i' "`xvars`i'' `x`i'`j''"
			}
			if (`atmatrix'[`i',`j']==0 & "`qat'"=="movete") {
				tempvar x`i'`j'
				quietly generate double `x`i'`j'' = `var' 
				local cuentas`i' = `cuentas`i'' + 1  
				local nom`i' "`nom`i'' `nom'"
				local xvars`i' "`xvars`i'' `x`i'`j''"			
			}
			local a: list b & lista1
			if (`atmatrix'[`i',`j']!=. &	///
				"`tipo'"=="variable" & "`a'"!="") {
				tempvar x`i'`j'
				quietly generate double `x`i'`j'' ///
					= `atmatrix'[`i',`j']  if `touse'
				local cuentas`i' = `cuentas`i'' + 1  
				local nom`i' "`nom`i'' `nom'"
				local xvars`i' "`xvars`i'' `x`i'`j''"
			}
			if "`a'"=="" {
				 tempvar x`i'`j'
				 gettoken a1 a2: b, parse("(") bind
				 gettoken a3 a4: a2, parse(")") bind
				 if ("`anew'"!="") {
					local a3 "`anew'"
				 }
				 quietly generate double `x`i'`j'' = ///
					`a3' if `touse'
				 local cuentas`i' = `cuentas`i'' + 1 
				 local nom`i' "`nom`i'' `nom'" 
				 local xvars`i' "`xvars`i'' `x`i'`j''"
			}
			if (`atmatrix'[`i',`j']==. &	///
				"`tipo'"=="factor") {
				if ("`qat'"=="quieto" & "`nomprev'"!="`nom'") {
					tempvar x`i'`j'
					quietly generate double `x`i'`j'' = ///
						`nom' 
				}
				if ("`qat'"=="movete") {
					tempvar x`i'`j'
					quietly generate double `x`i'`j'' = ///
						`var' 
				}
				local cuentas`i' = `cuentas`i'' + 1 
				local nom`i' "`nom`i'' `nom'" 
				local xvars`i' "`xvars`i'' `x`i'`j''"
			}
			if (`atmatrix'[`i',`j']==. & "`tipo'"=="variable") {
				tempvar x`i'`j'
				quietly generate double `x`i'`j'' = ///
				`nom' if `touse'
				local xvars`i' "`xvars`i'' `x`i'`j''"
			}
			local nomprev "`nom'"
		}
		local nom`i': list uniq nom`i'
		if (`cuentas`i'' == `krh') {
			matrix `cuentas'[1,`i'] = 1
		}
	}

	quietly generate double `fin'  = . 	
	local j = 1 
	local z = 1 

	forvalues i = 1/`k2' {
		tempvar evar`i'
		quietly generate double `evar`i'' = . 
		local evars "`evars' `evar`i'"
		while (`z' <= `krh' & `posx'[1,`j']!=0) {
			if (`posx'[1,`j'] ==`z') {
				local xvarnew: word `j' of `xvars`i''
				if `dorc'[1,`j']<0 {
					local newdvars	///
					 "`newdvars' `xvarnew'"
				}
				else {
					local newcvars	///
					 "`newcvars' `xvarnew'"
				}
				local z = `z' + 1
				local j = 0 
			}
			local j = `j' + 1
		}
		local z = 1 
	}
	
	local covarnoms ""
	forvalues i=1/`k2' {
		tempvar covar`i'
		quietly generate `covar`i'' = . 
		local covarnoms "`covarnoms' `covar`i''"
	}

	mata: _kernel_regression_at(`e(ke)', `e(cdnum)', `kcm', `kdm',	///
		`k2', "`newcvars'", "`newdvars'", `"`e(cvars)'"',	///
		`"`e(dvars)'"', "`e(lhs)'", "`prelim'", "`fin'", 	///
		"`vmatrix'", "`e(kest)'", `e(cellnum)', "`covarnoms'",	///
		"`newwgt'", `wgtc', "`touse'")
	
	quietly summarize `touse' `wgt', meanonly
	local N = r(N)
	matrix `b1' = `prelim'
	return matrix b1 = `b1'
end

program define _case_cuatro, rclass
	syntax [if] [in] [fw pw iw], dydx(string) anything(string)	
			
		marksample touse 
		tempname newbaseval muso muso2 baseval uniqval mgrad	///
			 gbase ehat rdos finse mgradse ehat2 beta1 V1 	///
			 beta0 V0 covarmat indice beta2 V2 indice2 usar
		tempvar newwgt
		
		// Weights 
		
		local wgtc = 0 
		if ("`weight'" != "") {
			local wgt "[`weight'`exp']"
			gettoken wgtbc wgtac: exp
			if ("`weight'"=="fweight"|"`weight'"=="iweight") {
				local wgtc = 1
			}
			if (`wgtc'==0) {
				local wgt "[iweight =`newwgt']"
			}
			clonevar `newwgt' = `wgtac'	
		}
		else {
			quietly generate `newwgt' = 1
		}
		local continuous = "`e(cvars)'"
		local discrete   = "`e(dvars)'"
		local celulas    = e(cellnum)
		local quieto  = "`e(quieto)'"
		local quieto2 = "`e(quieto2)'"
		local yesrhs  = e(yesrhs)
	
		// Getting a list of discrete values to evaluate gradients 
		
		capture _lista_yesrhs `anything' if `touse', quieto(`quieto')
		local rc = _rc
		if (`rc') {
			fvexpand `anything' if `touse'
			local anything = r(varlist)
		}
		else {
			local anything = "`s(lyesrhs)'"
		}

		local k0c: list sizeof continuous
		local k0:  list sizeof anything
		local kd:  list sizeof discrete
		
		forvalues i=1/`k0' {
			local w: word `i' of `anything'
			quietly capture tab `w'
			local rc = _rc
			if (`rc') {
				local dlist "`dlist' `w'"
			}
			else {
				fvexpand i.`w' if `touse'
				local w0   = r(varlist)		
				local dlist "`dlist' `w0'"
			}
		}

 		local k: list sizeof dlist

		forvalues i=1/`k' {
			local _dlx: word `i' of `dlist'
			_ms_parse_parts `_dlx'
			local _name0 = r(name)
			forvalues j = 1/`k' {
				local _dly: word `j' of `dlist'
				_ms_parse_parts `_dly'
				local _name1 = r(name)
				if ("`_name0'"=="`_name1'") {
					local _name "`_name' `_dlx' `_dly'"
				}
				else{
					local _name "`_name' `_dlx'"
				}
			}
		}

		local _name: list uniq _name
		local dlist "`_name'"
		local j = 1
		local k: list sizeof dlist
		local tamano = `k'

		forvalues i=1/`k' {
			local x: word `i' of `dlist'
			_ms_parse_parts `x'
			local base  = r(base)
			local value = r(level)
			local nomxx = r(name)
			local nomx: list x & discrete
			if ("`nomx'"!="") {
				local other: list discrete - nomx
			}
			else {
				local other: list discrete - nomxx			
			}
			local other: list other - x
			tempvar x`j'
			if ("`nomx'"=="") {
				quietly generate `x`j'' = `value'
				local names`j' "`nomxx' `other'"
			}
			else {
				quietly generate `x`j'' = 1	
				local names`j' "`nomx' `other'"	
			}
			local dnames`j' "`x`j'' `other'"
			local dnames "`dnames' `dnames`j''"
			local j = `j' + 1
		} 
			
		local kmuso = `j' - 1
		matrix `muso' = J(`kmuso',`kd', 0)	
		forvalues i=1/`k' {
			forvalues j=1/`kd' {
				local uno: word `j' of `names`i''
				forvalues l=1/`kd' {
					local dos: word `l' of `discrete'
					if ("`dos'"=="`uno'") {
						matrix `muso'[`i',`j'] = `l' 	
					}
				}
			}
		}

		local jk = 1
		local j  = 1 
		local wk = 1 
		forvalues i=1/`k' {
			while (`wk'<=`kd'){
				forvalues j= 1/`kd' {
						local a = `muso'[`i',`j']
						if (`wk'==`a') {
						local b: ///
							word `j' of `dnames`i''
						local newd`i' "`newd`i'' `b'"
						local newd "`newd' `b'"
						local wk = `wk' + 1
					}
				}
			}
			local wk = 1
		}

		// Getting list of discrete variables to combine with dydxlist
		
		local mixlist ""
		
		forvalues i=1/`k' {
			local mxv: word `i' of `dlist'
			_ms_parse_parts `mxv'
			local mxbase = r(base)
			local mxname = r(name)
			if (`mxbase'==1) {
				local op = r(op)
				local mixlist "`mixlist' `op'n.`mxname'"
			}
			else {
				local mixlist "`mixlist' `mxv'"
			}
		}

		// Getting gradient list 
		
		local cdnum  = e(cdnum)
		if (`cdnum'==2) {
			local k0c = 1
		}
		_dydx_listas, dydx(`dydx') continuous(`continuous')	///
			      discrete(`discrete') quieto(`quieto')	///
			      quieto2(`quieto2')
		
		local h       = "`s(h)'"
		local lalista = "`s(lalista)'"

		local taman: list sizeof h
		local ktaman  = `taman'*`tamano'
		local a : word 1 of `newd1'
		local b : word 2 of `newd1'
		local rmgrad     = e(kgrad) 
		local cmgrad     = e(kderiv)
		local klong      = `k'*`cmgrad'
		local klong2     = `k'*`rmgrad'
		matrix `mgrad'   = J(`klong', 1,  0)
		matrix `gbase'   = J(1,`rmgrad', 0)
		matrix `mgradse' = J(`klong', `klong',  0)

		// Creating stripe for margins combining both lists 

		local lmgs  ""
		local lmgs2 ""
		forvalues i=1/`taman' {
			local xdydx: word `i' of `h'
			forvalues j=1/`tamano' {
				local xdlist: word `j' of `mixlist'
				local lmgs  "`lmgs' `xdydx':`xdlist'"
				local lmgs2 "`lmgs2' `xdydx'"
			}
		}

		// Computing gradients for different values of discrete
		// covariates  
		
		forvalues i=1/`cmgrad' {
			tempvar xcm`i'
			quietly generate double `xcm`i'' = . 
			local dserrin "`dserrin' `xcm`i''"
		}
		forvalues i=1/`klong2' {
			tempvar gm`i'
			quietly generate double `gm`i''  = . 
			local gradsen "`gradsen' `gm`i''"
		}
		local j   = 1
		local j3  = 1
		local ink = `klong'/`k'
		matrix `covarmat' = J(1, `klong', 0)
		forvalues i=1/`klong' {
			tempvar covar`i' 
			matrix `covarmat'[1,`i'] = `j' 
			if (`i'>0) {
				local j = `j' + `ink'
			}
			if (int(`i'/`k') ==`i'/`k') {
				local j3 = `j3' + 1
				local j  = `j3'
			}
			quietly generate double `covar`i''  = . 
			local covarlist "`covarlist' `covar`i''"
		}

		local knewd: list sizeof newd
		forvalues i=1/`knewd' {
			local xnewd: word `i' of `newd'
			capture tab `xnewd'
			local rc = _rc
			if (`rc') {
				tempvar xnewd`i'
				generate `xnewd`i'' = `xnewd'
				local newdtwo "`newdtwo' `xnewd`i''"
			}
			else {
				local newdtwo "`newdtwo' `xnewd'"			
			}
		}

		mata: _marginslist_gradient(`e(ke)', `kd', "`e(cvars)'", ///
		"`newdtwo'", "`e(lhs)'", "`e(kest)'", "`mgrad'", "`gbase'", ///
		 "e(pbandwidthgrad)", `cdnum', "e(basemat)",		 ///
		 "e(basevals)", "e(uniqvals)", `k', `klong', 		 ///
		 "`gradsen'", "`e(dvars)'", 0, "`covarlist'", ///
		 "`covarmat'", `k0c', 0, "`e(cvars)'", "`newwgt'", "`touse'") 
	
		quietly generate double `ehat2' = . 
		quietly generate double `rdos'  = . 
		quietly generate double `finse' = .
		quietly generate double `ehat'  = (`e(lhs)' -  `e(yname)')^2

		// Selecting a list of derivatives 
		 
		_select_dydx, lalista(`lalista') h(`h') k(`k') ///
			      gradm(`mgrad') ktaman(`ktaman') lmgs2(`lmgs2')
		
		matrix `beta0' = r(beta0)
		quietly count if `touse'
		local N = r(N)
	
		return local dlist "`h'"	
		return local lista "`lmgs'"
		return local N       = `N'
		return matrix b1 = `beta0'
end

program define casezeroover, rclass
	syntax [if] [in] [fw pw iw], over(string) 
	marksample touse 
	tempname matindex matcount beta0 var0
	
	_how_many_over if `touse', over(`over')
	local over "`r(noms)'"

	local k: list sizeof over
	local varover ""
	forvalues i=1/`k' {
		local a: word `i' of `over'
		if (`i'==1) {
			local varover "`varover' i.`a'"
		}
		else {
			local varover "`varover'#i.`a'"
		}
	}
	fvexpand `varover' if `touse'
	local varlistover = r(varlist)
	local k2: list sizeof varlistover 
	matrix `matindex' = J(`k2', `k', 0)
	forvalues i=1/`k2' {
		local a: word `i' of `varlistover'
		_ms_parse_parts `a'
		forvalues j=1/`k' {
			if (`k'==1) {
				local b = r(level)		
			}
			else {
				local b = r(level`j')			
			}
			matrix `matindex'[`i',`j'] = `b'
		}
	}
	forvalues i=1/`k2' {
		local cond`i' ""
		local conds`i' ""
		forvalues j=1/`k' {
			local a = `matindex'[`i', `j']
			local b: word `j' of `over'
			if (`j'==1) {
				local cond`i' "`cond`i'' if `b'==`a'"
				local conds`i' "`conds`i'' `b'==`a'"
			}
			else {
				local cond`i' "`cond`i'' & `b'==`a'"
				local conds`i' "`conds`i'' & `b'==`a'"
			}
		}
	}
	matrix `beta0' = J(1,`k2', 0)
	matrix `var0'  = J(`k2', `k2', 0)
	
	forvalues i=1/`k2' {
		local myvar   = "`e(yname)'"
		summarize `myvar', meanonly
		local N = r(N)
		summarize `myvar' `cond`i'' & `touse', meanonly 
		matrix `beta0'[1,`i'] = r(mean)
	}

	forvalues i=1/`k2' {
		forvalues j=1/`k2' {
			tempvar betavar`i' sevar`j'
			quietly generate `betavar`i'' = `myvar'*(`conds`i'')
			summarize `betavar`i'', meanonly
			local a = r(mean)
		}
	}
	
	local vlt ""
	forvalues i=1/`k2' {
		local a: word `i' of `varlistover'
		_ms_parse_parts `a'
		local vlt`i' ""
		forvalues j=1/`k' {
			local b = r(level`j')
			local c = r(name`j')
			if (`k'==1) {
				local b = r(level)
				local c = r(name)			
			}
			if (`j'==1) {
				local vlt`i' "`b'.`c'"
			}
			if (`j'==`k' & `k'>1) {
				local vlt`i' "`vlt`i''#`b'.`c'"
			}
			if (`j'<`k' & `k'>1 & `j'>1)  {
				local vlt`i' "`vlt`i''#`b'.`c'#"				
			}
		}
		local vlt "`vlt' `vlt`i''"
	}
	
	matrix colnames `beta0' = `vlt'
	return local lista  "`vlt'"
	return local N   = `N'
	return matrix b0 = `beta0'

end

program define caseunoover, rclass
	syntax [if] [in] [fw pw iw], anything(string) over(string)
	
	marksample touse 
	tempname matindex b1 V1 covar_np b0 V0
	tempvar newwgt

	// Weights 
	local wgtc = 0 
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
		gettoken wgtbc wgtac: exp
		if ("`weight'"=="fweight"|"`weight'"=="iweight") {
			local wgtc = 1
		}
		if (`wgtc'==0) {
			local wgt "[iweight =`newwgt']"
		}
		quietly clonevar `newwgt' = `wgtac'	
	}	
	else {
		quietly generate `newwgt' = 1
	}
	
	
	// Getting overlist 

	_parse_over if `touse', over(`over')
	local k2vlt = s(k2vlt)
	local vlt   = `"`s(vlt)'"'

	local listvarsf ""
	matrix `b1' = 0
	matrix `V1' = 0
	forvalues lk=1/`k2vlt' {
		tempname dvarlist gradsen gbase indica usar basev uniq	///
			 hband rdos dgselist A avars H HC usarnew H2 	///
			 pomatrix HT matcount beta0 var0 tester matst	///
			 betabla
			 
		tempvar ehat2 ehat fden touselk
	
		local dvars     = "`e(dvars)'"
		local cvars     = "`e(cvars)'"
		local eqnoms    = "`e(repito2)'"
		local eqnoms2   = "`e(repito)'"
		local eq1: list sizeof eqnoms
		local eq2: list sizeof eqnoms2	
		local lhs       = "`e(lhs)'"
		local rhs       = "`e(rhs)'"
		matrix `A'      = nullmat(`A')
		matrix `basev'  = e(basevals)
		matrix `uniq'   = e(uniqvals)
		matrix  `hband' = e(bandwidthgrad)
		local ku:  list sizeof dvars
		matrix `usar' = J(1, `ku', 0)
		local yesrhs = e(yesrhs)
		local quieto0 = e(quieto)
		local condvlt: word `lk' of `vlt'
		quietly generate `touselk' = `condvlt'*`touse'
		
		_anything_sanity if `touselk', anything(`anything')
		
		if (`yesrhs'==0) {
			fvexpand i.(`anything') if `touselk'
			local otro = r(varlist)
		}
		else {
			local kuu: list sizeof anything
			forvalues i=1/`kuu' {
				local auu: word `i' of `anything'
				local buu: list auu & dvars
				if ("`buu'"!="") {
					fvexpand i.(`auu') if `touselk'
					local otrosi = r(varlist)
					local otro "`otro' `otrosi'"
				}
				else {
					local otro "`otro' `auu'"	
				}
			}		
		}
		
		fvexpand `anything' if `touselk'
		local anything = r(varlist)
	
		local casos = 0 
		local kotro: list sizeof otro
		local pos ""
		local posl ""
		local listvars ""
		local listvars2 ""
		local selistvars ""
		local selistvars2 ""
		local dlistvars ""
		local dvarlist ""
		local dvarz   ""
		local gradsen ""
		local selist ""
		local dgselist ""
		local dnames   ""
		local colnames ""
		local dvarnew   ""

		local j = 1
		while (`j'<`kotro' & `casos'==0) {
			local xotro: word `j' of `otro'
			_ms_parse_parts `xotro' 
			local type = r(type)
			if ("`type'"=="interaction") {
				local casos = -2 
			}
			local j = `j' + 1
		}
			local k = rowsof(e(basevals))
			forvalues i = 1/`k' {
				tempvar d`i' dse`i' selist`i' dgselist`i'
				quietly generate `d`i''= . if `touselk'
				quietly generate `dse`i''= . if `touselk'
				quietly generate `selist`i''= . if `touselk'
				quietly generate `dgselist`i''= . if `touselk'
				local dvarlist "`dvarlist' `d`i''"
				local gradsen  "`gradsen' `dse`i''"
				local selist   "`selist' `selist`i''"
				local dgselist   "`dgselist' `dgselist`i''"
			}

			mata: _kernel_margins_marginslist(`e(ke)', 	   ///
			      "`e(cvars)'", "`e(dvars)'", "`e(lhs)'",	   ///
			      "`dvarlist'", "`gradsen'", "e(pbandwidths)", ///
			      `e(cdnum)',  "e(basevals)", "e(uniqvals)",   ///
			      "`e(kest)'", `e(cellnum)', "`newwgt'",	   ///
			      "`touselk'")

			forvalues i = 1/`ku' {
				local a: word `i' of `dvars'
				fvexpand i.`a' if `touselk'
				local c = r(varlist)
				local kcufn: list sizeof c
				local c2dos ""
				forvalues j=1/`kcufn' {
					local c2x: word `j' of `c'
					_ms_parse_parts `c2x'
					local c2xl = r(level)
					local c2xn = r(name)
					local c2dos "`c2dos' `c2xl'.`c2xn'"
				}
				local b: list a & anything
				local d: list c & anything
				local dc2x: list c2dos & anything
				local f: list a & otro
				local g: list c & otro
				local gc2x: list c2dos & otro
				
				if ("`b'"!=""|"`d'"!=""|"`g'"!=""|"`f'"!=""| ///
				     "`dc2x'"!=""|"`gc2x'"!="") {
					matrix `usar'[1,`i'] = 1
				}
			} 

			PaRsE_NiVeLeS, dvars("`e(dvars)'") casezero(1)
			local veqlev  = "`s(newnivelazo)'"
			local dvars     = "`e(dvars)'"
			matrix `basev'  = e(basevals)
			matrix `uniq'   = e(uniqvals)

			mata: _kernel_margins_list("`basev'", "`uniq'",	///
			      "`dvars'", "`usar'", "`dvarlist'", 	///
			      "`eqnoms'", "`tester'")
			     
			local ku: list sizeof dvars
			forvalues i=1/`ku' {
				local z: word `i' of `dvars'
				capture tab `z'
				local rc = _rc
				if (`rc') {
					local dvarz "`dvarz' `z'"
					local quieto2 "`quieto2' movete"
				}
				else {
					local dvarz "`dvarz' `z'"
					local quieto2 "`quieto2' quieto"
				}
			} 
			
			// Getting list for r(b) 
			
			if (`yesrhs'==0) {
				fvexpand i.(`dvars') if `touselk'
				local newdvars = r(varlist)
			}
			else {
				_lista_yesrhs `dvarz' if `touselk', ///
					quieto(`quieto2')
				local newdvars = "`s(lyesrhsrep)'"	
				local quietico = "`s(quietico)'"		
			}
			local knv: list sizeof newdvars
			matrix `usarnew' = J(1, `knv', 0)		
			forvalues i=1/`kotro' {
				local b: word `i' of `otro'
				_ms_parse_parts `b'
				local posn  = r(name)
				local nva = r(level)
				local pos "`pos' `posn'"
				forvalues j=1/`knv' {
					local a: word `j' of `newdvars'
					local qza: ///
						word `j' of `quietico'
					_ms_parse_parts `a'
					local nvb   = r(level)
					local posnb = r(name)
					if (("`a'"=="`b'" & ///
					     "`nvb'"=="`nva'") | ///
					     ("`posn'"=="`posnb'" & ///
						"`nvb'"=="`nva'") ) {
						if (`yesrhs'==0) {
							matrix ///
						  `usarnew'[1,`j'] = 1
						}
						else if ( ///
						    "`qza'"=="uno") {
						   matrix ///
						   `usarnew'[1,`j'] = 1						
						}
						local colnames ///
							"`colnames' `a'"
						}
				}
			} 
			local pos: list uniq pos
			local kpos: list sizeof pos
			local m = 1
			matrix `pomatrix' = J(1, `knv', 0)
			forvalues j=1/`kpos' {
				local b: word `j' of `pos'
				_ms_parse_parts `b'
				local lb = r(level)
				forvalues i=1/`knv' {
					local nkn: word `i' of `newdvars'
					_ms_parse_parts `nkn'
					local a  = r(name) 
					if ("`a'"=="`b'") {
						matrix ///
						`pomatrix'[1,`i'] = `m'
						local m = `m' + 1
					}
				}
			}
			matrix `usarnew' = (`usarnew'\(`pomatrix'))'
			mata: st_matrix("`usarnew'", 	///
				sort(st_matrix("`usarnew'"), 2))
			matrix `usarnew' = `usarnew''
			matrix `usarnew' =	///
				`usarnew'[1,1..colsof(`usarnew')]
			
			local pok = colsof(`pomatrix')
			local klv: list sizeof dvarlist
			forvalues i=1/`klv'{
				forvalues j = 1/`pok' {
					if (`pomatrix'[1,`j']==`i') {
						local a: ///
						word `j' of `dvarlist'
						local listvars ///
						"`listvars' `a'"
					}
				}
			}
		
			forvalues i=1/`klv' {
				if (`usarnew'[1,`i']==1) {
					local c: word `i' of `listvars'
					local listvars2 ///
						"`listvars2' `c'"
				}
			}
			
			local dvars     = "`e(dvars)'"
			local eqnoms    = "`e(repito2)'"
			matrix `basev'  = e(basevals)
			matrix `uniq'   = e(uniqvals)
			matrix  `hband' = e(bandwidthgrad)
			tempvar finse 
			quietly generate double `finse' = . 

			mata: _kernel_margins_marginslist_se(`e(ke)', 	    ///
			      "`e(cvars)'", "`e(dvars)'", "e(pbandwidths)", ///
			     `e(cdnum)', "`dgselist'", "`gradsen'", 	    ///
			     "e(basevals)", "e(uniqvals)", "`finse'",	    ///
			     `e(cellnum)', "`newwgt'", `wgtc', "`touselk'") 

			local dvarlist "`dgselist'"
			
			mata: _kernel_margins_list_se("`basev'", "`uniq'",  ///
			      "`dvars'", "`usar'","`dvarlist'")

			local pok = colsof(`pomatrix')
			local klv: list sizeof dvarlist
			forvalues i=1/`klv'{
				forvalues j = 1/`pok' {
					if (`pomatrix'[1,`j']==`i') {
						local a: word `j' of `dvarlist'
						local selistvars ///
						"`selistvars' `a'"
					}
				}
			}	
			forvalues i=1/`klv' {
				if (`usarnew'[1,`i']==1) {
					local c: word `i' of `selistvars'
					local selistvars2 "`selistvars2' `c'"
				}
			}
			local kbeta: list sizeof listvars2

			forvalues i=1/`kbeta' {
				local a: word `i' of `listvars2'
				local c: word `i' of `selistvars2'	
				summarize `a' if `touselk', meanonly
				local b = r(mean)
				matrix `b1' = nullmat(`b1'), `b'
				summarize `c' if `touselk', meanonly
				local d = r(mean)
				local N = r(N)
				matrix `V1' = `V1', `d'	
			}
			local listvarsf "`listvarsf' `listvars2'" 
		}
		matrix `b1' = `b1'[1, 2..colsof(`b1')]
		matrix `V1' = `V1'[1, 2..colsof(`V1')]
		quietly summarize `lhs' if `touse'
		local N = r(N)
		local kcorr: list sizeof listvarsf
		matrix `covar_np' = J(colsof(`V1'), colsof(`V1'), 0)
		forvalues i=1/`kcorr' {
			forvalues j=1/`kcorr' {
				local  betavar`i': word `i' of  `listvarsf'
				summarize `betavar`i'', meanonly
				local a = r(mean)
				local  sevar`j': word `j' of  `listvarsf'
				summarize `sevar`j'', meanonly
				local b = r(mean)
				if (`i'!=`j') {
					matrix `covar_np'[`i',`j'] = ///
						-`a'*`b'/`N'
				}
			}
		}

		fvexpand `anything' if `touselk'
		local anything = r(varlist)
		local k: list sizeof anything
		local jx = 1

		forvalues i=1/`k' {
			local _xvar: word `i' of `anything'
			_ms_parse_parts `_xvar'
			local nzero0 = r(name)
			local inter: list nzero0 & ninter
			if ("`inter'"=="") {
				local name`i' "`_xvar'"
			}
			forvalues j=1/`k' {
				local _yvar: word `j' of `anything'
				_ms_parse_parts `_yvar'
				local nzero1 = r(name)
				if ("`nzero0'"=="`nzero1'" & ///
					"`_xvar'"!="`_yvar'" & "`inter'"=="") {
					local name`i' "`name`i'' `_yvar'"
					local ninter "`ninter' `nzero0'"
				}
			}
			if ("`name`i''"!="") {
				local names`jx' "`name`i''"
				local formatst "`formatst' `name`i''"
				local jx = `jx' + 1
			}		
		}

		local bla = `jx' - 1 
		forvalues i=1/`bla' {
			local xbla: list sizeof names`i'
			if (`xbla'==1) {
				fvexpand i.`names`i'' if `touselk'
				local xblapre = r(varlist)
				local xbla: list sizeof xblapre
			}
			matrix `matst' = nullmat(`matst'), `xbla'
		}
		
		matrix `betabla' = `b1'
	    mata: _np_reorder_mglist(`k2vlt', `bla',	///
			"`betabla'", "`matst'")

		local j1 = 1 
		local j2 = 1
		local j3 = 1
		local tirando ""
		local kls: list sizeof anything

		local kld: list sizeof newdd
		local knf = (`jx'-1)*`k2vlt'	
		while (`j1' <= `knf') {
			local a: word `j3' of `vlt'
			local b "`names`j2''"
			local ktt: list sizeof b
			if (`ktt'==1) {
				fvexpand i.`b' if `touselk'
				local alista = r(varlist)
			}
			else {
				local alista "`b'"
			}
			local klista: list sizeof alista
			forvalues i=1/`klista' {
				local c: word `i' of `alista'
				_ms_parse_parts `c'
				local nom0 = r(level)
				local nom1 = r(name)
				local nom "`nom0'.`nom1'"
				local tirando "`tirando' `a'#`nom'"			
			}
			local j4 = `j3'
			if (`j3' < `k2vlt') {
				local j3 = `j3' + 1 
			}
			if (`j4'==`k2vlt') {
				local j3 = 1
				if (`j2'<(`jx'-1)) {
					local j2 = `j2' + 1
				}
				else {
					local j2 = 1
				}
			}
			local j1 = `j1' + 1	
		}

		matrix `V1' = diag(`V1') + `covar_np'
		matrix colnames `betabla' = `tirando'
		matrix colnames `V1' = `tirando'
		matrix rownames `V1' = `tirando'
		matrix `b0' = `betabla'
		matrix `V0' = `V1'
		return local lista  "`tirando'"
		return matrix V0 = `V0'
		return matrix b0 = `b0'
		return matrix V1 = `V1'
		return matrix b1 = `betabla'
		return scalar N  = `N'
end

program define casetresover, rclass
	syntax [if] [in] [fw pw iw], atnames(string) atmat(string) over(string)
		 
	marksample touse 
	tempname b1 V1 atmatrix atmatrix0 covar_np b1pre b2pre
	tempvar newwgt
	
	local wgtc = 0 
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
		gettoken wgtbc wgtac: exp
		if ("`weight'"=="fweight"|"`weight'"=="iweight") {
			local wgtc = 1
		}
		if (`wgtc'==0) {
			local wgt "[iweight =`newwgt']"
		}
		quietly clonevar `newwgt' = `wgtac'	
	}
	else {
		quietly generate `newwgt' = 1
	} 

	// Getting overlist 
	
	_parse_over if `touse', over(`over')
	local k2vlt = s(k2vlt)
	local vlt   = `"`s(vlt)'"'
	
	local listvarsf ""
	matrix `atmatrix0' = `atmat'
	local katov = rowsof(`atmatrix0')
	local kfatov = `katov'/`k2vlt'
	local jkatov = `k2vlt' 
	forvalues i=1/`kfatov' {
		matrix `atmatrix' = ///
			nullmat(`atmatrix') \ ///
			`atmatrix0'[`jkatov', 1..colsof(`atmatrix0')]
			local jkatov = `jkatov' + `k2vlt' 
	}
	
	local tirando ""
	forvalues i=1/`kfatov' {
		forvalues j=1/`k2vlt' {
			local a: word `j' of `vlt'
			local tirando "`tirando' `i'._at#`a'"
		}
	}

	if (`kfatov'==1) {
		local tirando "`vlt'"
	}

	forvalues lk=1/`k2vlt' {
		tempname A AT atnew cuentas prelim dorc posx rdos fin	///
			vmatrix b0 V0
		tempvar touselk
		local covariates `"`e(covariates)'"'
		local allvars    `"`e(allvars)'"'
		local dvarsat    `"`e(dvars)'"'
		local cvarsat    `"`e(cvars)'"'
		local rhzero     `"`e(rhzero)'"'
		local quietoat   `"`e(quieto3)'"'
		local yesrhs     = e(yesrhs)
		local  y   = e(lhs)
		local stripe ""
		local tipo ""
		local nombre ""
		local namesrhs ""
		local newxvars ""
		local newdvars ""
		local newcvars ""
		local evars ""
		local kcm: list sizeof cvarsat
		local kdm: list sizeof dvarsat
		local rhs = "`e(rhzero)'"
		local krh: list sizeof rhs
		local condvlt: word `lk' of `vlt'
		quietly generate `touselk' = `condvlt'*`touse'
		matrix `dorc' = J(1, `krh', 0)
		matrix `posx' = J(1, `krh', 0)
		forvalues i=1/`krh' {
			local a: word `i' of `rhs'
			fvexpand `a'
			local b = r(varlist)
			local b: word 1 of `b'
			_ms_parse_parts `b'
			local c = r(name)
			local namesrhs "`namesrhs' `c'"
		}
		local k: list sizeof covariates
		local k2 = rowsof(`atmatrix')
		matrix `A'   = J(1, `k', 0)
		forvalues i=1/`k' {
			local a: word `i' of `covariates'
			local stripe "`stripe' `y':`a'"
			_ms_parse_parts `a'
			local b = r(type)
			local c = r(name)
			local tipo "`tipo' `b'"
			local qa: word `i' of `quietoat'
			if ("`qa'"=="quieto") {
				local nombre "`nombre' `c'"
			}
			else {
				local nombre "`nombre' `a'"
			}
		}
		local fordorc: list uniq nombre
		forvalues i=1/`krh' {
			local ft0: word `i' of `fordorc'
			local ftc: list ft0 & cvarsat
			if ("`ftc'"!="") {
				matrix `dorc'[1,`i'] = `i'
			}
			else {
				matrix `dorc'[1,`i'] = -`i'
			}
			forvalues j=1/`krh' {
				local alist: word `i' of `fordorc'
				local blist: word `j' of `allvars'
				local alist2: word `i' of `rhzero'
				if ("`alist'"=="`blist'"| ///
					"`alist2'"=="`blist'") {
					matrix `posx'[1,`i'] = `j' 
				}
			}
		} 
		local j = 1
		matrix colnames `A' = `stripe'
		_ms_at_parse `at', asobserved mat(`A')
		local estad    = r(statlist)
		local atvars   = r(atvars)
		local atvars1 "`atvars'"
		local  stats1  "`estad'"
		local pct ""
		forvalues i=1/99 {
			local pct "p`i'"
		}
		local listas "asobserved asbalanced value values"
		local lista1 "mean median min max `pct' zero base `listas'"
		local 0 `",`atnames'"'
		syntax [, at(string) *]
		while `:length local at'{
			_ms_at_parse `at', asobserved mat(`A')
			local estad    = r(statlist)
			local atvars   = r(atvars)
			local atvars`j' "`atvars'"
			local  stats`j'  "`estad'"
			local kgtk = colsof(`A')
			local empiezo "`stats`j''"
			local final ""
			forvalues ppd=1/`kgtk' {
				gettoken empiezo depord: ///
					empiezo, match(paren) bind
				local empiezo = subinstr("`empiezo'"," ","",.) 
				local final "`final' `empiezo'"
				local empiezo "`depord'"
			}
			local final2 ""
			forvalues ppd=1/`kgtk' {
				local ppdx: word `ppd' of `final'
				local interpp: list ppdx & lista1
				if ("`interpp'"=="") {
					local final2 "`final2' (`ppdx')"
				}
				else {
					local final2 "`final2' `ppdx'"
				}
			}
			local stats`j' "`final2'"
			local estad "`stats`j''" 
			local j = `j' + 1
			forvalues i=1/`k' {
				local a: word `i' of `estad'
				if ("`a'"=="("| "`a'"==")") {
					local innew = `i' + 1
					local a: word `innew' of `estad'
					local anew "`a'"
				}
				local b: word `i' of `tipo'
				local c: word `i' of `nombre'
				local inter: list c & atvars
				if ("`a'"=="mean" & "`b'"=="factor" & ///
				    "`inter'"!="") {
					 display as error ///
					"incorrect {bf:margins}"	///
					 " specification after"		///
					 " {bf:npregress kernel}"
					di as err "{p 4 4 2}" 
					di as smcl as err "The kernel used for" 
					di as smcl as err " discrete"
					di as smcl as err " covariates is" 
					di as smcl as err " only well defined"
					di as smcl as err "for the original " 
					di as smcl as err " values of the" 
					di as smcl as err " discrete"
					di as smcl as err " covariates."
					di as smcl as err " The kernel is"
					di as smcl as err " degenerate at " 
					di as smcl as err " values other than" 
					di as smcl as err " the original"
					di as smcl as err " discrete levels." 
					di as smcl as err "{p_end}"
					exit 198
				} 
			}
			local 0 `",`options'"'
			syntax [, at(string) *]
		}
		local pct ""
		forvalues i=1/99 {
			local pct "p`i'"
		}
		local listas "asobserved asbalanced value values"
		local lista1 "mean median min max `pct' zero base `listas'"
		matrix `cuentas' = J(1, `k2', 0)
		forvalues i=1/`k2' {
			local cuentas`i' = 0 
			local nom`i' ""
			local xvars`i' ""
			forvalues j=1/`k' {
				if ("`stats`i''"==""){
					local b: word `j' of `stats1'
				}
				else {
					local b: word `j' of `stats`i''
				}
				local var: word `j' of `covariates'
				local qat: word `j' of 	`quietoat'
				_ms_parse_parts `var'
				local nivel   = r(level)
				local tipo    = r(type)
				local nom     = r(name)
				if ("`qat'"=="movete") {
					local nom "`var'"
				}
				if (`j'==1) {
					local nomprev = .
				}
				if (`atmatrix'[`i',`j']==1 &	///
					"`tipo'"=="factor") {
					tempvar x`i'`j'
					if ("`qat'"=="movete") {
						quietly generate ///
							double `x`i'`j'' = ///
							1 
					}
					else {
						quietly generate ///
						double `x`i'`j'' = ///
						`nivel' 
					}
					local cuentas`i' = `cuentas`i'' + 1 
					local nom`i' "`nom`i'' `nom'"
					local xvars`i' "`xvars`i'' `x`i'`j''" 
				}
				if (`atmatrix'[`i',`j']==0 & ///
					"`qat'"=="movete") {
					tempvar x`i'`j'
					quietly generate double ///
						`x`i'`j'' = `var' 
					local cuentas`i' = `cuentas`i'' + 1  
					local nom`i' "`nom`i'' `nom'"
					local xvars`i' "`xvars`i'' `x`i'`j''"			
				}
				local a: list b & lista1
				if (`atmatrix'[`i',`j']!=. &	///
					"`tipo'"=="variable" & "`a'"!="") {
					tempvar x`i'`j'
					qui generate double `x`i'`j'' ///
						= `atmatrix'[`i',`j'] 
					local cuentas`i' = `cuentas`i'' + 1  
					local nom`i' "`nom`i'' `nom'"
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				if "`a'"=="" {
					tempvar x`i'`j'
					gettoken a1 a2: b, parse("(")
					gettoken a3 a4: a2, parse(")")
					if ("`anew'"!="") {
						local a3 "`anew'"
					}
					qui generate double `x`i'`j'' = `a3'
					local cuentas`i' = `cuentas`i'' + 1 
					local nom`i' "`nom`i'' `nom'" 
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				if (`atmatrix'[`i',`j']==. &	///
					"`tipo'"=="factor") {
					if ("`qat'"=="quieto" & ///
						"`nomprev'"!="`nom'") {
						tempvar x`i'`j'
						quietly generate ///
							double `x`i'`j'' = ///
							`nom' 
					   local xvars`i' "`xvars`i'' `x`i'`j''"
					}
					if ("`qat'"=="movete") {
						tempvar x`i'`j'
						quietly generate ///
							double `x`i'`j'' = ///
							`var' 
					   local xvars`i' "`xvars`i'' `x`i'`j''"
					}
					local cuentas`i' = `cuentas`i'' + 1 
					local nom`i' "`nom`i'' `nom'" 
				}
				if (`atmatrix'[`i',`j']==. &	///
					("`tipo'"=="variable")) {
					tempvar x`i'`j'
					qui generate double `x`i'`j'' =	///
						`nom' if `touse'
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				local nomprev "`nom'"
			}	
			local nom`i': list uniq nom`i'
			if (`cuentas`i'' == `krh') {
				matrix `cuentas'[1,`i'] = 1
			}
		}
		quietly generate double `fin'  = . 		
		local j = 1 
		local z = 1 
		forvalues i = 1/`k2' {
			tempvar evar`i'
			quietly generate double `evar`i'' = . 
			local evars "`evars' `evar`i'"
			while (`z' <= `krh'  & `posx'[1,`j']!=0) {
				if (`posx'[1,`j'] == `z') {
					local xvarnew: word `j' of `xvars`i''
					if `dorc'[1,`j']<0 {
						local newdvars	///
						 "`newdvars' `xvarnew'"
					}
					else {
						local newcvars	///
						 "`newcvars' `xvarnew'"
					}
					local z = `z' + 1
					local j = 0 
				}
				local j = `j' + 1
			}
			local z = 1 
		}
		
		local covarnoms ""
		forvalues i=1/`k2' {
			tempvar covar`i'
			quietly generate `covar`i'' = .
			local covarnoms "`covarnoms' `covar`i''"
		}
		mata: _kernel_regression_at(`e(ke)', `e(cdnum)', `kcm', ///
			`kdm', `k2', "`newcvars'", "`newdvars'", 	///
			`"`e(cvars)'"', `"`e(dvars)'"', "`e(lhs)'", 	///
			"`prelim'", "`fin'", "`vmatrix'", "`e(kest)'",	///
			 `e(cellnum)', "`covarnoms'", "`newwgt'", 	///
			 `wgtc', "`touselk'")

		matrix `b1pre' = nullmat(`b1pre')\ `prelim'
		matrix `V1' = nullmat(`V1'), `vmatrix'
	}
	
	matrix `b1pre' = vec(`b1pre')'
	
	local b1k = colsof(`b1pre')
	matrix `b1' = J(1, `b1k', 0)
	
	forvalues i=1/`b1k' {
		matrix `b1'[1,`i'] = `b1pre'[1,`i']
	} 

	quietly summarize `touselk' `wgt', meanonly
	local N = r(N)
	local kfin = colsof(`b1')
	matrix `covar_np' = J(`kfin', `kfin', 0)
	
	forvalues i=1/`kfin' {
		forvalues j=1/`kfin' {
			local a = `b1'[1,`i']
			local b = `b1'[1,`j']
			if (`i'!=`j') {
				matrix `covar_np'[`i',`j'] = -`a'*`b'/`N'
			}
		}
	}

	matrix `V1' = diag(`V1') + `covar_np'
	matrix colnames `b1' = `tirando'
	matrix colnames `V1' = `tirando'
	matrix rownames `V1' = `tirando'
	return local lista  "`tirando'"
	return matrix b1 = `b1'
	return matrix V1 = `V1'
	
end

program define casedosover, rclass
	syntax [if] [in] [fw pw iw], dydx(string) over(string)	
			
	marksample touse 
	tempname beta1 V1 matindex covar_np
	tempvar newwgt
	
	// Weights 
	local wgtc = 0 
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
		gettoken wgtbc wgtac: exp
		if ("`weight'"=="fweight"|"`weight'"=="iweight") {
			local wgtc = 1
		}
		if (`wgtc'==0) {
			local wgt "[iweight =`newwgt']"
		}
		clonevar `newwgt' = `wgtac'	
	}
	else {
		quietly generate `newwgt' = 1
	}
	
	
	// Getting overlist 
	
	_parse_over if `touse', over(`over')
	local k2vlt = s(k2vlt)
	local vlt   = `"`s(vlt)'"'
	
	local listvarsf ""		
	forvalues lk=1/`k2vlt' {	
		tempname muso b2 V2 tracks
		tempvar touselk
		local listad = "`e(dvars)'"
		local listac = "`e(cvars)'"
		local cdnum  = e(cdnum)
		local quieto  = "`e(quieto)'"
		local quieto2 = "`e(quieto2)'"
		local yesrhs  = e(yesrhs)	
		
		if (`cdnum'==1) {
			local tuti "`listac'"
		}
		if (`cdnum'==2) {
			local tuti "`listad'"
		}
		if (`cdnum'==3) {
			local tuti "`listac' `listad'"
		}
		fvexpand `dydx' 
		local dydx0 = r(varlist)
		local tutituti: list tuti & dydx0
		local todas = 0 
		local espacio = 1 
		if ("`tuti'"=="`tutituti'"| "`dydx'"=="*" | ///
			"`dydx'"=="_all" ) {
			local todas = 1 
			local espacio = 0
			if (`cdnum'==1) {
				fvexpand `listac' 
				local lalista = r(varlist)		
			}
			if (`cdnum'==2) {
				if (`yesrhs'==0) {
					fvexpand i.(`listad') 
					local lalista = r(varlist)
				}
				else {
					_lista_yesrhs `listad', ///
						quieto(`quieto')
					local lalista = "`s(lyesrhs)'"
				}		
			}
			if (`cdnum'==3) {
				if (`yesrhs'==0) {
					fvexpand `listac' i.(`listad') 
					local lalista = r(varlist)	
				}
				else {
					_lista_yesrhs `listad', ///
						quieto(`quieto')
					local lalistad = "`s(lyesrhs)'"
					local lalista "`listac' `lalistad'"	
				}	
			}
			local h "`lalista'"
		}
		else {
			if (`cdnum'==1) {
				fvexpand `dydx'
				local dydx2 = r(varlist)
				fvexpand `listac'
				local lalista = r(varlist)	
				local a: list listac  & dydx2	
				local b: list lalista & dydx2	
				local c "`a' `b'"
				local h: list uniq c		
			}
			if (`cdnum'==2) {
				_lista_yesrhs `dydx', ///
					quieto(`quieto')	///
					dq(`quieto2')
				local dydx2 = "`s(lyesrhs)'"
				_lista_yesrhs `listad', ///
					quieto(`quieto') 

				local lalista = "`s(lyesrhs)'"
				local a: list listad  & dydx2	
				local b: list lalista & dydx2	
				local c "`a' `b'"	
				local h: list uniq c		
			}
			if (`cdnum'==3) {
				local dydx22 "`dydx'"
				local kdydxh: list sizeof dydx22
				forvalues i=1/`kdydxh' {
					local xdydx2: word `i' of `dydx22'
					capture _ms_parse_parts `xdydx2'
					local rc = _rc
					if (`rc') {
						fvexpand `xdydx2'
						local tempx = r(varlist)
						local dydx22 "`dydx22' `tempx'"
					}
				}
				_lista_yesrhs `listad', ///
					quieto(`quieto') 
				local lalistad = "`s(lyesrhs)'"
				local lalista "`listac' `lalistad'"
				local a0 "`lalistad'"
				local dydx3: list dydx22 & listad
				local dydx32: list dydx22 & lalistad
				local dydx5: list dydx22 & listac
				if ("`dydx3'"!=""|"`dydx32'"!="") {
					_lista_yesrhs `dydx3' `dydx32',	///
						quieto(`quieto') dq(`quieto2')
					local dydx4 = "`s(lyesrhs)'"
				}
				local dydx1 "`dydx5' `dydx4'" 
				local a: list listac  & dydx1	
				local b0: list dydx1 - a
				if ("`b0'"!="") {
					_lista_yesrhs `b0',	///
						quieto(`quieto') dq(`quieto2')
					local b1 = "`s(lyesrhs)'"
				}
				local b: list b1 & a0
				local dydx2 "`a' `b1'" 
				local g: list lalista & dydx2	
				local c "`a' `b' `g'"
				local h: list uniq c
				local btable "`b'"		
			}
			casedos_parse, lista("`h'") dydx("`dydx'")
		}

		local kl: list sizeof lalista 
		local km: list sizeof h
		
		local lalista2 ""
		local lalista3 ""
		local h2 ""
		local eqnoms ""
		local nivelc ""
		if (`todas'== 0) {
			local ccount = 0
		} 
		else {
			local ccount: list sizeof listac
		}
		forvalues i=1/`kl' {
			local x: word `i' of `lalista'
			_ms_parse_parts `x'
			local a = r(base)
			local b = r(name)
			local d = r(level)
			if (`a'!=1) {
				local lalista2 "`lalista2' `x'"
				local eqnoms "`eqnoms' `b'"
				if ("`a'"==".") {
					local nivelc "`nivelc' _cons"
				}
			}
		}
		forvalues i=1/`km' {
			local x: word `i' of `h'
			_ms_parse_parts `x'
			local a = r(base)
			local p = r(type)
			local b = r(name)
			if (`a'!=1) {
				local h2 "`h2' `x'"
				if ("`p'"=="variable" & `todas'== 0) {
					local ccount = `ccount' + 1
				}
			}
		}
		
		if ("`km'"=="`kl'") {
			local todas = 1 
		}
		
		if ("`h2'"=="" & `todas'==0) {
			di as error "option {bf:dydx()} specified incorrectly"
			exit 198			
		}
		
		local kl: list sizeof lalista2 
		local km: list sizeof h2

		matrix `muso' = J(1, `kl', 0)
		if (`todas'==0) {
			forvalues i=1/`km' {
				forvalues j=1/`kl' {
					local x: word `i' of `h2'
					local z: word `j' of `lalista2'
					local w: list x & z
					if "`w'"!="" {
						matrix `muso'[1,`j'] = 1
					}
				}
			}
		}

		local dvarlist   = "`e(cigradnoms)'"
		local dvarlistse = "`e(cigradnomse)'"

		PaRsE_NiVeLeS, dvars("`e(dvars)'")
		local nivel  = "`nivelc'`s(newnivelazo)'"

		if (`todas'==0) {
			mata: _kernel_dydx_list("`muso'", "`dvarlist'",	///
			"`eqnoms'", "`nivel'", "`lalista2'")
		}

		local kll: list sizeof lalista2
		local jk = 0
		forvalues i=1/`kll' {
			local xkll: word `i' of `lalista2'
			_ms_parse_parts `xkll'
			local tipo = r(type)
			local nomx = r(name)
			if ("`tipo'"=="factor") {
				quietly capture tab `xkll'
				local rc = _rc
				if `rc' {
					fvexpand i.(`nomx')
					local tempxl1 = r(varlist)
					local kll2: list sizeof tempxl1
					forvalues j=1/`kll2' {
						local xkll1: ///
						word `j' of `tempxl1'
						local mix: list xkll1 & xkll
						_ms_parse_parts `xkll1'
						local base = r(base)
						local op   = r(op)
						if ("`mix'"!="") {
							local jk = 1
						}
						if (`base'==1 & `jk'==0) {
							local tempx ///
							"`op'.`nomx' `xkll'"
						}
						if (`base'==1 & `jk'==1) {
							local tempx ///
							"`xkll' `op'.`nomx'"
						}
					}
				}
				else {
					fvexpand i.(`nomx')
					local tempx = r(varlist)
				} 
				
				local lalista3 "`lalista3' `tempx'"
			}
			else {
				local lalista3 "`lalista3' `xkll'"
			}
		}
		local lalista3: list uniq lalista3		
		local kdv: list sizeof dvarlist
		matrix `b2' = J(1, `kdv', 0)
		matrix `V2' = J(1, `kdv', 0)
		local condvlt: word `lk' of `vlt'
		quietly generate `touselk' = `condvlt'*`touse'
		local colnames ""
		forvalues i=1/`kdv' {
			local x: word `i' of `dvarlist'
			local z: word `i' of `dvarlistse'
			local m: word `i' of `eqnoms'
			local q: word `i' of `nivel'
			summarize `x' if `touselk' `wgt', meanonly
			matrix `b2'[1,`i'] = r(mean)
			summarize `z' if `touselk' `wgt', meanonly
			matrix `V2'[1,`i'] = r(mean)
			local colnames "`colnames' `m':`q'"
		}
		summarize `y' if `touse', meanonly
		local N = r(N)
		matrix `beta1' = nullmat(`beta1'), `b2'
		matrix `V1'    = nullmat(`V1'), `V2'
	}
	
	// Reordering 

	mata: _np_reorder_dydx(`kdv', `k2vlt', "`beta1'")
	
	// Stripes 
	
	local luno: list sizeof lalista3
	local tirando ""
	local tirando2 ""
	forvalues i=1/`luno' {
		forvalues j=1/`k2vlt' {
			local a: word `i' of `lalista3'
			local b: word `j' of `vlt'
			local tirando "`tirando' `a':`b'"
			local tirando2 "`tirando2' `a'"
		}
	}
	local kfo = colsof(`V1')
	matrix `covar_np' = J(`kfo', `kfo', 0)
	
	forvalues i=1/`kfo' {
		forvalues j=1/`kfo' {
			local a = `beta1'[1,`i']
			local b = `beta1'[1,`j']
			if (`i'!=`j') {
				matrix `covar_np'[`i',`j'] = -`a'*`b'/`N'
			}
		}
	}
	
	local tamanos: list sizeof tirando

	matrix `V1' = diag(`V1') + `covar_np'
	return local lista "`tirando'"
	return local lista2 "`tirando2'"
	return local dlist "`lalista3'"
	return local espacio = `espacio' 
	return local todas   = `todas'
	return local btable "`btable'"
	return local ccount  = `ccount'
	return matrix b1     = `beta1'
	return matrix V1     = `V1'
	return scalar N      = `N'
	return scalar bfinf  = 1

end

program define casecuatroover, rclass
	syntax [if] [in] [fw pw iw], dydx(string) anything(string) over(string)	
			
	marksample touse 
	tempname  betauno varuno covar_np matindex 
	tempvar newwgt
	
	// Weights 

	local wgtc = 0 
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
		gettoken wgtbc wgtac: exp
		if ("`weight'"=="fweight"|"`weight'"=="iweight") {
			local wgtc = 1
		}
		if (`wgtc'==0) {
			local wgt "[iweight =`newwgt']"
		}
		clonevar `newwgt' = `wgtac'	
	}
	else {
		quietly generate `newwgt' = 1
	}

	// Getting overlist 
	
	_parse_over if `touse', over(`over')
	local k2vlt = s(k2vlt)
	local vlt   = `"`s(vlt)'"'
	
	local listvarsf ""
	forvalues lk=1/`k2vlt' {
		tempname newbaseval muso muso2 baseval uniqval mgrad	///
			 gbase ehat rdos finse mgradse ehat2 beta1 V1 	///
			 beta0 V0 covarmat indice beta2 V2 indice2 usar	///
			 matst beta2new matst2
		
		tempvar touselk 
		
		local continuous = "`e(cvars)'"
		local discrete   = "`e(dvars)'"
		local celulas    = e(cellnum)
		local quieto  = "`e(quieto)'"
		local quieto2 = "`e(quieto2)'"
		local yesrhs  = e(yesrhs)
		
		local condvlt: word `lk' of `vlt'
		quietly generate `touselk' = `condvlt'*`touse'
		
		_anything_sanity if `touselk', anything(`anything')
	
		// Getting a list of discrete values to evaluate gradients 
		
		capture _lista_yesrhs `anything' if `touselk', ///
			quieto(`quieto')
		local rc = _rc
		if (`rc') {
			fvexpand `anything' if `touselk'
			local anything = r(varlist)
		}
		else {
			local anything = "`s(lyesrhs)'"
		}
		
		local oldanything "`anything'"
		
		local k0c: list sizeof continuous
		local k0:  list sizeof anything
		local kd:  list sizeof discrete
		local dlist ""
		local wcont ""
		local wnames ""
		matrix `matst' = J(1, `k0', 0)
		forvalues i=1/`k0' {
			local w: word `i' of `anything'
			quietly capture tab `w'
			local rc = _rc
			_ms_parse_parts `w'
			local w_name = r(name)
			local wnames "`wnames' `w_name'"
			if (`rc') {
				local dlist "`dlist' `w'"
				local kfst: list sizeof w
				matrix `matst'[1,`i'] = `kfst'
				local wcont "`wcont' `kfst'"
			}
			else {
				fvexpand i.`w' if `touselk'
				local w0   = r(varlist)		
				local dlist "`dlist' `w0'"
				local kfst: list sizeof w0
				matrix `matst'[1,`i'] = `kfst'
				local wcont "`wcont' `kfst'"
			}
		}
		
		local k: list sizeof dlist
		local _name ""
		forvalues i=1/`k' {
			local _dlx: word `i' of `dlist'
			_ms_parse_parts `_dlx'
			local _name0 = r(name)
			forvalues j = 1/`k' {
				local _dly: word `j' of `dlist'
				_ms_parse_parts `_dly'
				local _name1 = r(name)
				if ("`_name0'"=="`_name1'") {
					local _name "`_name' `_dlx' `_dly'"
				}
				else{
					local _name "`_name' `_dlx'"
				}
			}
		}
		
		local _name: list uniq _name
		local dlist "`_name'"
		
		local _name ""
		local k: list sizeof oldanything
		forvalues i=1/`k' {
			local _dlx: word `i' of `oldanything'
			_ms_parse_parts `_dlx'
			local _name0 = r(name)
			forvalues j = 1/`k' {
				local _dly: word `j' of `oldanything'
				_ms_parse_parts `_dly'
				local _name1 = r(name)
				if ("`_name0'"=="`_name1'") {
					local _name "`_name' `_dlx' `_dly'"
				}
				else{
					local _name "`_name' `_dlx'"
				}
			}
		}

		local _name: list uniq _name
		local oldanything "`_name'"
		
		local j = 1
		local k: list sizeof dlist
		local tamano = `k'

		forvalues i=1/`k' {
			local x: word `i' of `dlist'
			_ms_parse_parts `x'
			local base  = r(base)
			local value = r(level)
			local nomxx = r(name)
			local nomx: list x & discrete
			if ("`nomx'"!="") {
				local other: list discrete - nomx
			}
			else {
				local other: list discrete - nomxx			
			}
			local other: list other - x
			tempvar x`j'
			if ("`nomx'"=="") {
				quietly generate `x`j'' = `value'
				local names`j' "`nomxx' `other'"
			}
			else {
				quietly generate `x`j'' = 1	
				local names`j' "`nomx' `other'"	
			}
			local dnames`j' "`x`j'' `other'"
			local dnames "`dnames' `dnames`j''"
			local j = `j' + 1
		} 
		
		local kmuso = `j' - 1
		matrix `muso' = J(`kmuso',`kd', 0)	
		forvalues i=1/`k' {
			forvalues j=1/`kd' {
				local uno: word `j' of `names`i''
				forvalues l=1/`kd' {
					local dos: word `l' of `discrete'
					if ("`dos'"=="`uno'") {
						matrix `muso'[`i',`j'] = `l' 	
					}
				}
			}
		}

		local jk = 1
		local j  = 1 
		local wk = 1
		local newd ""
		forvalues i=1/`k' {
			while (`wk'<=`kd'){
				forvalues j= 1/`kd' {
						local a = `muso'[`i',`j']
						if (`wk'==`a') {
						local b: ///
							word `j' of `dnames`i''
						local newd`i' "`newd`i'' `b'"
						local newd "`newd' `b'"
						local wk = `wk' + 1
					}
				}
			}
			local wk = 1
		}

		// Getting list of discrete variables to combine with dydxlist
		
		local mixlist ""
		
		forvalues i=1/`k' {
			local mxv: word `i' of `dlist'
			_ms_parse_parts `mxv'
			local mxbase = r(base)
			local mxname = r(name)
			if (`mxbase'==1) {
				local op = r(op)
				local mixlist "`mixlist' `op'n.`mxname'"
			}
			else {
				local mixlist "`mixlist' `mxv'"
			}
		}

		// Getting gradient list 
		
		local tuti ""
		local dydxk: list sizeof dydx
		local cdnum  = e(cdnum)
		if (`cdnum'==2) {
			local k0c = 1
		}
		_dydx_listas, dydx(`dydx') continuous(`continuous')	///
			      discrete(`discrete') quieto(`quieto')	///
			      quieto2(`quieto2')
		
		local h       = "`s(h)'"
		local lalista = "`s(lalista)'"


		local taman: list sizeof h
		local ktaman  = `taman'*`tamano'
		local a : word 1 of `newd1'
		local b : word 2 of `newd1'
		local rmgrad     = e(kgrad) 
		local cmgrad     = e(kderiv)
		local klong      = `k'*`cmgrad'
		local klong2     = `k'*`rmgrad'
		matrix `mgrad'   = J(`klong', 1,  0)
		matrix `gbase'   = J(1,`rmgrad', 0)
		matrix `mgradse' = J(`klong', `klong',  0)

		// Creating stripe for margins combining both lists 
	
		local lmgs  ""
		local lmgs2 ""
		forvalues i=1/`taman' {
			local xdydx: word `i' of `h'
			forvalues j=1/`tamano' {
				local xdlist: word `j' of `mixlist'
				local lmgs  "`lmgs' `xdydx':`xdlist'"
				local lmgs2 "`lmgs2' `xdydx'"
			}
		}

		// Computing gradients for different values of discrete
		// covariates  
		
		local dserrin ""
		local gradsen ""
		local covarlist ""
		forvalues i=1/`cmgrad' {
			tempvar xcm`i'
			quietly generate double `xcm`i'' = . 
			local dserrin "`dserrin' `xcm`i''"
		}
		forvalues i=1/`klong2' {
			tempvar gm`i'
			quietly generate double `gm`i''  = . 
			local gradsen "`gradsen' `gm`i''"
		}
		local j   = 1
		local j3  = 1
		local ink = `klong'/`k'
		matrix `covarmat' = J(1, `klong', 0)
		forvalues i=1/`klong' {
			tempvar covar`i' 
			matrix `covarmat'[1,`i'] = `j' 
			if (`i'>0) {
				local j = `j' + `ink'
			}
			if (int(`i'/`k') ==`i'/`k') {
				local j3 = `j3' + 1
				local j  = `j3'
			}
			quietly generate double `covar`i''  = . 
			local covarlist "`covarlist' `covar`i''"
		}
		
		local knewd: list sizeof newd
		forvalues i=1/`knewd' {
			local xnewd: word `i' of `newd'
			capture tab `xnewd'
			local rc = _rc
			if (`rc') {
				tempvar xnewd`i'
				generate `xnewd`i'' = `xnewd'
				local newdtwo "`newdtwo' `xnewd`i''"
			}
			else {
				local newdtwo "`newdtwo' `xnewd'"			
			}
		}

		mata: _marginslist_gradient(`e(ke)', `kd', "`e(cvars)'", ///
		"`newdtwo'", "`e(lhs)'", "`e(kest)'", "`mgrad'", "`gbase'", ///
		 "e(pbandwidthgrad)", `cdnum', "e(basemat)",		 ///
		 "e(basevals)", "e(uniqvals)", `k', `klong', 		 ///
		 "`gradsen'", "`e(dvars)'", 0, "`covarlist'", 		 ///
		 "`covarmat'", `k0c', 0, "`e(cvars)'", "`newwgt'", 	 ///
		 "`touselk'") 
	
		quietly generate double `ehat2' = . 
		quietly generate double `rdos'  = . 
		quietly generate double `finse' = .
		quietly generate double `ehat'  = (`e(lhs)' -  `e(yname)')^2

		// Selecting a list of derivatives 
		
		_select_dydx, lalista(`lalista') h(`h') k(`k') ///
			      gradm(`mgrad') ktaman(`ktaman')  ///
			      lmgs2(`lmgs2')
		
		matrix `beta0'   = r(beta0)
		matrix `betauno' = nullmat(`betauno'), `beta0'

	}

	// Reordering 

	local kco  = colsof(`betauno')
	local kbet = colsof(`betauno')/(`taman'*`k2vlt')

	local jx = 1 
	local k: list sizeof oldanything
	forvalues i=1/`k' {
		local _xvar: word `i' of `oldanything'
		_ms_parse_parts `_xvar'
		local nzero0 = r(name)
		local inter: list nzero0 & ninter
		if ("`inter'"=="") {
			local name`i' "`_xvar'"
		}
		forvalues j=1/`k' {
			local _yvar: word `j' of `oldanything'
			_ms_parse_parts `_yvar'
			local nzero1 = r(name)
			if ("`nzero0'"=="`nzero1'" & ///
				"`_xvar'"!="`_yvar'" & "`inter'"=="") {
				local name`i' "`name`i'' `_yvar'"
				local ninter "`ninter' `nzero0'"
			}
		}
		if ("`name`i''"!="") {
			local names`jx' "`name`i''"
			local jx = `jx' + 1
		}
		
	}
	
	local bla = `jx' - 1 
	forvalues i=1/`bla' {
		local xbla: list sizeof names`i'
		if (`xbla'==1) {
			fvexpand i.`names`i'' if `touselk'
			local xblapre = r(varlist)
			local xbla: list sizeof xblapre
		}
		matrix `matst2' = nullmat(`matst2'), `xbla'
	}
	
	matrix `matst' = `matst2'

	mata: _np_reorder(`taman', `k2vlt', `kbet', "`betauno'", "`matst2'")

	_cuatro_stripes, kco(`kco') taman(`taman') k2vlt(`k2vlt') ///
			 dydxk(`dydxk') betaunom(`betauno') 	  ///
			 matstm(`matst2') kbet(`kbet')
		 
	matrix `beta2new' = r(beta2new)
	
	// Stripes 
	
	local kls: list sizeof anything

	local kh: list sizeof h 
	local kld: list sizeof newdd
	local knf = (`jx'-1)*`k2vlt'

	local tirando ""

	forvalues khi =1/`kh' {
		local j1 = 1 
		local j2 = 1
		local j3 = 1
		local khw: word `khi' of `h'
		while (`j1' <= `knf') {
			local a: word `j3' of `vlt'
			local b "`names`j2''"
			local ktt: list sizeof b
			if (`ktt'==1) {
				fvexpand i.`b' if `touselk'
				local alista = r(varlist)
			}
			else {
				local alista "`b'"
			}
			local klista: list sizeof alista
			forvalues i=1/`klista' {
				local c: word `i' of `alista'
				_ms_parse_parts `c'
				local nom0 = r(level)
				local nom1 = r(name)
				local nom "`nom0'.`nom1'"
			local tirando "`tirando' `khw':`a'#`nom'"			
			}
			local j4 = `j3'
			if (`j3' < `k2vlt') {
				local j3 = `j3' + 1 
			}
			if (`j4'==`k2vlt') {
				local j3 = 1
				if (`j2'<(`jx'-1)) {
					local j2 = `j2' + 1
				}
				else {
					local j2 = 1
				}
			}
			local j1 = `j1' + 1		
		}
	}

	matrix colnames `beta2new' = `tirando'
	quietly summarize `lhs' if `touse'
	local N = r(N)

	return local dlist "`h'"	
	return local lista "`tirando'"
	return local N       = `N'
	return matrix b1 = `beta2new'
end

program define casecinco, rclass
	syntax [if] [in] [fw pw iw], atnames(string) anything(string) ///
				     atmat(string) [over(string)]	

	tempvar newwgt
	marksample touse 
	
	// Weights 
	
	local wgtc = 0 
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
		gettoken wgtbc wgtac: exp
		if ("`weight'"=="fweight"|"`weight'"=="iweight") {
			local wgtc = 1
		}
		if (`wgtc'==0) {
			local wgt "[iweight =`newwgt']"
		}
		clonevar `newwgt' = `wgtac'	
	}
	else {
		quietly generate `newwgt' = 1
	}

	if ("`over'"=="") {
		tempname newbaseval muso muso2 baseval uniqval 	///
			mgrad gbase ehat rdos finse mgradse 	///
			ehat2 A AT atmatrix atnew cuentas 	///
			prelim dorc posx rdos fin gradsen 	///
			vmatrix b1 V1 matorig
			 
		local continuous = "`e(cvars)'"
		local discrete   = "`e(dvars)'"
		local celulas    = "`e(cellnum)'"
		local quieto  = "`e(quieto)'"
		local quieto2 = "`e(quieto2)'"
		local yesrhs  = e(yesrhs)
		
		// Getting a list of discrete values 
		
		capture _lista_yesrhs `anything' if `touse', quieto(`quieto')
		local rc = _rc
		if (`rc') {
			fvexpand `anything' if `touse'
			local anything = r(varlist)
		}
		else {
			local anything = "`s(lyesrhs)'"
		}
		
		
		local k0: list sizeof anything
		local kd: list sizeof discrete
		forvalues i=1/`k0' {
			local w: word `i' of `anything'
			quietly capture tab `w'
			local rc = _rc
			if (`rc') {
				local dlist "`dlist' `w'"
			}
			else {
				fvexpand i.`w' if `touse'
				local w0   = r(varlist)		
				local dlist "`dlist' `w0'"
			}
		}			
		local k: list sizeof dlist
		forvalues i=1/`k' {
			local _dlx: word `i' of `dlist'
			_ms_parse_parts `_dlx'
			local _name0 = r(name)
			forvalues j = 1/`k' {
				local _dly: word `j' of `dlist'
				_ms_parse_parts `_dly'
				local _name1 = r(name)
				if ("`_name0'"=="`_name1'") {
					local _name "`_name' `_dlx' `_dly'"
				}
				else{
					local _name "`_name' `_dlx'"
				}
			}
		}

		local _name: list uniq _name
		local dlist "`_name'"
		local _name ""
		local jacum = 0 
		forvalues i=1/`k' {
			local _dlx: word `i' of `dlist'
			_ms_parse_parts `_dlx'
			local _name0 = r(name)
			local level0 = r(level)
			local jacum = 0 
			forvalues j = 1/`k' {
				local _dly: word `j' of `dlist'
				_ms_parse_parts `_dly'
				local _name1 = r(name)
				local level1 = r(level)
				if ("`_name0'"=="`_name1'" ///
					& `level1'< `level0') {
					local _name "`_name' `_dly' `_dlx'"
					local jacum = `jacum' + 1
				}
				if (`jacum'==0 & `j'==`k') {
					local _name "`_name' `_dlx'"
					local jacum = 0 
				}
			}
		}

		local _name: list uniq _name
		local dlist "`_name'"

		_retirando, anything(`dlist')
		matrix `matorig' = r(matstat)

		local j = 1
		local k: list sizeof dlist
		local kdlf = `k'
		forvalues i=1/`k' {
			local x: word `i' of `dlist'
			_ms_parse_parts `x'
			local base  = r(base)
			local value = r(level)
			local nomxx = r(name)
			local nomx: list x & discrete
			if ("`nomx'"!="") {
				local other: list discrete - nomx
			}
			else {
				local other: list discrete - nomxx			
			}
			local other: list other - x
			tempvar x`j'
			if ("`nomx'"=="") {
				quietly generate `x`j'' = `value'
				local names`j' "`nomxx' `other'"
			}
			else {
				quietly generate `x`j'' = 1	
				local names`j' "`nomx' `other'"	
			}
			local dnames`j' "`x`j'' `other'"
			local dnames "`dnames' `dnames`j''"
			local j = `j' + 1
		} 

		local kmuso = `j' - 1
		matrix `muso' = J(`kmuso',`kd', 0)	
		forvalues i=1/`k' {
			forvalues j=1/`kd' {
				local uno: word `j' of `names`i''
				forvalues l=1/`kd' {
					local dos: ///
						word `l' of `discrete'
					if ("`dos'"=="`uno'") {
						matrix ///
						`muso'[`i',`j'] = `l' 	
					}
				}
			}
		}
		local jk = 1
		local j  = 1 
		local wk = 1
		local bla = 1 
		forvalues i=1/`k' {
			while (`wk'<=`kd'){
				forvalues j= 1/`kd' {
						local a =	///
							`muso'[`i',`j']
						if (`wk'==`a') {
						local b: ///
							word `j' ///
							of `dnames`i''
						local ///
						newd`i' "`newd`i'' `b'"
						local newd "`newd' `b'"
						local wk = `wk' + 1
					}
				}
			}
			local wk = 1
		}
		local newd_zero "`newd'"
		local knewd: list sizeof newd
		forvalues i=1/`knewd' {
			local xnewd: word `i' of `newd'
			capture tab `xnewd'
			local rc = _rc
			if (`rc') {
				tempvar xnewd`i'
				generate `xnewd`i'' = `xnewd'
				local newdtwo "`newdtwo' `xnewd`i''"
			}
			else {
				local newdtwo "`newdtwo' `xnewd'"			
			}
		}
		
		local newd "`newdtwo'"

		// Getting at varlist 
		
		local covariates `"`e(covariates)'"'
		local allvars    `"`e(allvars)'"'
		local dvarsat    `"`e(dvars)'"'
		local cvarsat    `"`e(cvars)'"'
		local quietoat   `"`e(quieto3)'"'
		local  y   = e(lhs)
		local stripe ""
		local tipo ""
		local nombre ""
		local namesrhs ""
		local newxvars ""
		local newdvars ""
		local ndlt ""
		local newcvars ""
		local evars ""
		local kcm: list sizeof cvarsat
		local kdm: list sizeof dvarsat
		local rhs = "`e(rhs)'"
		local krh: list sizeof rhs
		matrix `dorc' = J(1, `krh', 0)
		matrix `posx' = J(1, `krh', 0)
		forvalues i=1/`krh' {
			local a: word `i' of `rhs'
			fvexpand `a' if `touse'
			local b = r(varlist)
			local b: word 1 of `b'
			_ms_parse_parts `b'
			local c = r(name)
			local namesrhs "`namesrhs' `c'"
		}
		local k: list sizeof covariates
		matrix `atmatrix' = `atmat'
		local k2 = rowsof(`atmatrix')
		matrix `A'   = J(1, `k', 0)
		forvalues i=1/`k' {
			local a: word `i' of `covariates'
			local stripe "`stripe' `y':`a'"
			_ms_parse_parts `a'
			local b   = r(type)
			local c   = r(name)
			local mtf = r(level)
			local tipo "`tipo' `b'"
			local qa: word `i' of `quietoat'
			if ("`qa'"=="quieto") {
				local nombre "`nombre' `c'"
			}
			else {
				local nombre "`nombre' `a'"
			}
		}
		local fordorc: list uniq nombre
		forvalues i=1/`krh' {
			local ft0: word `i' of `fordorc'
			local ftc: list ft0 & cvarsat
			if ("`ftc'"!="") {
				matrix `dorc'[1,`i'] = `i'
			}
			else {
				matrix `dorc'[1,`i'] = -`i'
			}
			forvalues j=1/`krh' {
				local alist: word `i' of `fordorc'
				local alist2: word `i' of `rhzero'
				local blist: word `j' of `allvars'
				if ("`alist'"=="`blist'"| ///
					"`alist2'"=="`blist'") {
					matrix `posx'[1,`i'] = `j' 
				}
			}
		} 
		local j = 1
		tempvar nospace
		matrix colnames `A' = `stripe'
		_ms_at_parse `at', asobserved mat(`A')
		local estad    = r(statlist)
		local atvars   = r(atvars)
		local atvars1 "`atvars'"
		local  stats1  "`estad'"
		local pct ""
		forvalues i=1/99 {
			local pct "p`i'"
		}
		local listas "asobserved asbalanced value values"
		local lista1 "mean median min max `pct' zero base `listas'"
		local 0 `",`atnames'"'
		syntax [, at(string) *]
		while `:length local at'{
			_ms_at_parse `at', asobserved mat(`A')
			local estad    = r(statlist)
			local atvars   = r(atvars)
			local atvars`j' `"`atvars'"'
			local  stats`j'  `"`estad'"'
			local kgtk = colsof(`A')
			local empiezo "`stats`j''"
			local final ""
			forvalues ppd=1/`kgtk' {
				gettoken empiezo depord:	///
					empiezo, match(paren) bind
				local empiezo = subinstr("`empiezo'"," ","",.) 
				local final "`final' `empiezo'"
				local empiezo "`depord'"
			}
			local final2 ""
			forvalues ppd=1/`kgtk' {
				local ppdx: word `ppd' of `final'
				local interpp: list ppdx & lista1
				if ("`interpp'"=="") {
					local final2 "`final2' (`ppdx')"
				}
				else {
					local final2 "`final2' `ppdx'"
				}
			}
			local stats`j' "`final2'"
			local estad "`stats`j''" 
			local j = `j' + 1
			forvalues i=1/`k' {
				local a: word `i' of `estad'
				if ("`a'"=="("| "`a'"==")") {
					local innew = `i' + 1
					local a: word `innew' of `estad'
					local anew "`a'"
				}
				local b: word `i' of `tipo'
				local c: word `i' of `nombre'
				local inter: list c & atvars
				if ("`a'"=="mean" & ///
					"`b'"=="factor" & ///
					"`inter'"!="") {
					 display as error ///
					"incorrect {bf:margins}"  ///
					 " specification after"	  ///
					 " {bf:npregress kernel}"
				di as err "{p 4 4 2}" 
				di as smcl as err "The kernel used for" 
				di as smcl as err " discrete"
				di as smcl as err " covariates is" 
				di as smcl as err " only well defined"
				di as smcl as err "for the original " 
				di as smcl as err " values of the" 
				di as smcl as err " discrete"
				di as smcl as err " covariates."
				di as smcl as err " The kernel is"
				di as smcl as err " degenerate at " 
				di as smcl as err " values other than" 
				di as smcl as err " the original"
				di as smcl as err " discrete levels." 
				di as smcl as err "{p_end}"
				exit 198
				} 
			}
			
			local 0 `",`options'"'
			syntax [, at(string) *]
		}
		local pct ""
		forvalues i=1/99 {
			local pct "p`i'"
		}
		local listas "asobserved asbalanced value values"
		local lista1 ///
			"mean median min max `pct' zero base `listas'"
		matrix `cuentas' = J(1, `k2', 0)
		forvalues i=1/`k2' {
			local cuentas`i' = 0 
			local nom`i' ""
			local xvars`i' ""
			forvalues j=1/`k' {
				if (`"`stats`i''"'==""){
					local b: word `j' of `stats1'
				}
				else {
					local b: word `j' of `stats`i''
				}
				local var: word `j' of `covariates'
				local qat: word `j' of 	`quietoat'
				_ms_parse_parts `var'
				local nivel   = r(level)
				local tipo    = r(type)
				local nom     = r(name)
				if ("`qat'"=="movete") {
					local nom "`var'"
				}
				if (`j'==1) {
					local nomprev "."
				}
				if (`atmatrix'[`i',`j']==1 &	///
					"`tipo'"=="factor") {
					tempvar x`i'`j'
					if ("`qat'"=="movete") {
						quietly generate ///
							double `x`i'`j'' = ///
							1 
					}
					else {
						quietly generate ///
							double `x`i'`j'' = ///
						`nivel' 
					}
					local cuentas`i' = `cuentas`i'' + 1 
					local nom`i' "`nom`i'' `nom'" 
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				if (`atmatrix'[`i',`j']==0 & ///
					"`qat'"=="movete") {
					tempvar x`i'`j'
					quietly generate double `x`i'`j'' ///
						= `var' 
					local cuentas`i' = `cuentas`i'' + 1  
					local nom`i' "`nom`i'' `nom'"
					local xvars`i' "`xvars`i'' `x`i'`j''"			
				}
				local a: list b & lista1
				if (`atmatrix'[`i',`j']!=. &	///
					"`tipo'"=="variable" & "`a'"!="") {
					tempvar x`i'`j'
					quietly generate double `x`i'`j'' ///
						= `atmatrix'[`i',`j']  ///
							if `touse'
					local cuentas`i' = `cuentas`i'' + 1  
					local nom`i' "`nom`i'' `nom'"
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				if "`a'"=="" {
					tempvar x`i'`j'
					gettoken a1 a2: b, parse("(")
					gettoken a3 a4: a2, parse(")")
					if ("`anew'"!="") {
						local a3 "`anew'"
					}
					qui generate double 	///
						`x`i'`j'' = `a3'
					local cuentas`i' = 	///
						`cuentas`i'' + 1 
					local nom`i' "`nom`i'' `nom'" 
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				if (`atmatrix'[`i',`j']==. &	///
					"`tipo'"=="factor") {
					if ("`qat'"=="quieto" & ///
						"`nomprev'"!="`nom'") {
						tempvar x`i'`j'
						quietly generate double ///
							`x`i'`j'' = ///
							`nom' 
					}
					if ("`qat'"=="movete") {
						tempvar x`i'`j'
						quietly generate double ///
							`x`i'`j'' = ///
							`var' 
					}
					local cuentas`i' = `cuentas`i'' + 1 
					local nom`i' "`nom`i'' `nom'" 
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				if (`atmatrix'[`i',`j']==. & ///
					"`tipo'"=="variable") {
					tempvar x`i'`j'
					quietly generate double `x`i'`j'' = ///
					`nom' if `touse'
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				local nomprev "`nom'"
			}	
			local nom`i': list uniq nom`i'
			if (`cuentas`i'' == `krh') {
				matrix `cuentas'[1,`i'] = 1
			}
		}

		quietly generate double `fin'  = . 		
		local j = 1 
		local z = 1 
		forvalues i = 1/`k2' {
			tempvar evar`i'
			quietly generate double `evar`i'' = . 
			local evars "`evars' `evar`i'"
			while (`z' <= `krh' & `posx'[1,`j']!=0) {
				if (`posx'[1,`j'] == `z' ) {
					local xvarnew: 	///
						word `j' of `xvars`i''
					if `dorc'[1,`j']<0 {
						local newdvars	///
						 "`newdvars' `xvarnew'"
					}
					else {
						local newcvars	///
						 "`newcvars' `xvarnew'"
					}
					local z = `z' + 1
					local j = 0 
				}
				local j = `j' + 1
			}
			local z = 1 
		}
		local kmgl:  list sizeof newd
		local kat:   list sizeof newdvars
		local kdd:   list sizeof dvarsat 
		local knew = `kmgl'*`kdd'
		local i  = 1
		local j  = 1 
		local i2 = 1
		local j2 = 1
		local bd = 0
		while `j2'<= `kat'  {
			while `i' <= `kmgl' {
				while `j' <=`kdd' {
					local x: word `i' of `newd_zero'
					local y: word `j2' of `newdvars'
					local z: list x & dvarsat
					if ("`z'"=="") {
						local ndlt "`ndlt' `x'"
					}
					else {
						local ndlt "`ndlt' `y'"
					}
					local j  = `j' + 1
					local i  = `i' + 1
					local j2 = `j2' + 1
				}
				local j  = 1 
				local j2 = `j' + `bd'
			}
			local j2 = `j2' + `kdd'
			local bd = `bd' + `kdd'
			local j  = 1
			local i  = 1 
		} 
 
		local tester: list sizeof ndlt
		local kfin: list sizeof ndlt
		local kcnv: list sizeof newcvars
		local nclt ""
		local ncf ""
		forvalues i=1/`kcnv' {
			local x: word `i' of `newcvars'
			local nclt "`nclt' `x'"
			if (int(`i'/`kcm')==`i'/`kcm') {
				local nclt`i'  = `"`nclt'"'*`kdlf'
				local nclt ""
				local ncf "`ncf' `nclt`i''"
			}
		}
		local kloop = `kdlf'*`k2'
		local klong = `kloop'
		local kgradsen = `e(kgrad)'*`kloop'
		matrix `mgrad'     = J(`kloop', 1,  0)
		matrix `mgradse'   = J(`kloop', `kloop',  0)
		local gradsen ""
		forvalues i=1/`kgradsen' {
			tempvar gm`i'
			quietly generate double `gm`i''  = . 
			local gradsen "`gradsen' `gm`i''"	
		}

		local kfin: list sizeof ndlt		
		local covarnoms ""
		
		forvalues i=1/`kloop' {
			tempvar covar`i'
			quietly generate `covar`i'' = .
			local covarnoms "`covarnoms' `covar`i''"
		}

		mata: _kernel_regression_at(`e(ke)', 		///
		`e(cdnum)', `kcm', `kdm',	`kloop', 	///
		"`ncf'", "`ndlt'", `"`e(cvars)'"',		///
		`"`e(dvars)'"', "`e(lhs)'", "`prelim'", 	///
		"`fin'", "`vmatrix'", "`e(kest)'", 		///
		`e(cellnum)', "`covarnoms'", "`newwgt'", 	///
		`wgtc', "`touse'")

		if (`k2'>1) {
			mata: _np_reorder_atlevels(`k2', "`matorig'",	///
				"`prelim'")
		}
		quietly summarize `touse' `wgt', meanonly
		local N = r(N)
		tempname covar_np
		quietly correlate `covarnoms', cov
		matrix `covar_np' = r(C)

		mata: _np_covariances_se("`covar_np'", `N')
		matrix `b1' = `prelim'
		matrix `V1' = diag(`vmatrix') + `covar_np'
		return matrix b1 = `b1'
		return matrix V1 = `V1'
	}
	else {
		marksample touse 
		tempname b1 V1 b0 V0 matindex atmatrix	///
		atmatrix0 covar_np matst

		// Getting overlist 
		
		_parse_over if `touse', over(`over')
		local k2vlt = s(k2vlt)
		local vlt   = `"`s(vlt)'"'
		
		local listvarsf ""
		matrix `atmatrix0' = `atmat'
		local katov = rowsof(`atmatrix0')
		local kfatov = `katov'/`k2vlt'
		local jkatov = `k2vlt' 
		forvalues i=1/`kfatov' {
			matrix `atmatrix' = ///
			nullmat(`atmatrix') \ ///
			`atmatrix0'[`jkatov', 1..colsof(`atmatrix0')]
			local jkatov = `jkatov' + `k2vlt' 
		}
		
		local tirando ""
		forvalues i=1/`kfatov' {
			forvalues j=1/`k2vlt' {
				local a: word `j' of `vlt'
				local tirando "`tirando' `i'._at#`a'"
			}
		}

		if (`kfatov'==1) {
			local tirando "`vlt'"
		}		
		forvalues lk=1/`k2vlt' {
			tempname newbaseval muso muso2 baseval	///
			uniqval mgrad gbase ehat rdos finse 	///
			mgradse ehat2 A AT atnew 	///
			cuentas prelim dorc posx rdos fin 	///
			gradsen vmatrix matst2 matorig matst
			
			tempvar touselk
			local condvlt: word `lk' of `vlt'
			quietly generate `touselk' = `condvlt'*`touse'	 
			local continuous = "`e(cvars)'"
			local discrete   = "`e(dvars)'"
			local celulas    = "`e(cellnum)'"
			local quieto  = "`e(quieto)'"
			local quieto2 = "`e(quieto2)'"
			local yesrhs  = e(yesrhs)
			*local oldanything "`anything'"
			
			_anything_sanity if `touselk', anything(`anything')

			// Getting a list of discrete values 
			
			capture _lista_yesrhs `anything' if `touselk', ///
				quieto(`quieto')
			local rc = _rc
			if (`rc') {
				fvexpand `anything' if `touselk'
				local anything = r(varlist)
			}
			else {
				local anything = "`s(lyesrhs)'"
			}
			local oldanything "`anything'"
			
			local k0: list sizeof anything
			local kd: list sizeof discrete
			local dlist ""
			matrix `matst' = J(1, `k0', 0)
			forvalues i=1/`k0' {
				local w: word `i' of `anything'
				quietly capture tab `w'
				local rc = _rc
				if (`rc') {
					local dlist "`dlist' `w'"
					local kfst: list sizeof w
					matrix `matst'[1,`i'] = `kfst'
				}
				else {
					fvexpand i.`w' if `touse'
					local w0   = r(varlist)		
					local dlist "`dlist' `w0'"
					local kfst: list sizeof w0
					matrix `matst'[1,`i'] = `kfst'
				}
			}
			
			local k: list sizeof dlist
			local _name ""
			forvalues i=1/`k' {
				local _dlx: word `i' of `dlist'
				_ms_parse_parts `_dlx'
				local _name0 = r(name)
				forvalues j = 1/`k' {
					local _dly: word `j' of `dlist'
					_ms_parse_parts `_dly'
					local _name1 = r(name)
					if ("`_name0'"=="`_name1'") {
						local _name ///
							"`_name' `_dlx' `_dly'"
					}
					else{
						local _name "`_name' `_dlx'"
					}
				}
			}

			local _name: list uniq _name
			local dlist "`_name'"
			
			local _name ""
			local k: list sizeof oldanything
			forvalues i=1/`k' {
				local _dlx: word `i' of `oldanything'
				_ms_parse_parts `_dlx'
				local _name0 = r(name)
				forvalues j = 1/`k' {
					local _dly: word `j' of `oldanything'
					_ms_parse_parts `_dly'
					local _name1 = r(name)
					if ("`_name0'"=="`_name1'") {
					local _name "`_name' `_dlx' `_dly'"
					}
					else{
					local _name "`_name' `_dlx'"
					}
				}
			}

			local _name: list uniq _name
			local oldanything "`_name'"

			jacum, dlist(`dlist')
			local dlist "`r(dname)'"

			jacum, dlist(`oldanything')
			local oldanything "`r(dname)'"

			_retirando, anything(`dlist')
			matrix `matorig' = r(matstat)			
				
			local dnames ""
			local j = 1
			local k: list sizeof dlist
			local kdlf = `k'
			forvalues i=1/`k' {
				local x: word `i' of `dlist'
				_ms_parse_parts `x'
				local base  = r(base)
				local value = r(level)
				local nomxx = r(name)
				local nomx: list x & discrete
				if ("`nomx'"!="") {
					local other: list discrete - nomx
				}
				else {
					local other: list discrete - nomxx			
				}
				local other: list other - x
				tempvar x`j'
				if ("`nomx'"=="") {
					quietly generate `x`j'' = `value'
					local names`j' "`nomxx' `other'"
				}
				else {
					quietly generate `x`j'' = 1	
					local names`j' "`nomx' `other'"	
				}
				local dnames`j' "`x`j'' `other'"
				local dnames "`dnames' `dnames`j''"
				local j = `j' + 1
			} 
			
			local kmuso = `j' - 1
			matrix `muso' = J(`kmuso',`kd', 0)	
			forvalues i=1/`k' {
				forvalues j=1/`kd' {
					local uno: word `j' ///
						of `names`i''
					forvalues l=1/`kd' {
						local dos: ///
						word `l' of `discrete'
						if ("`dos'"=="`uno'") {
							matrix ///
						  `muso'[`i',`j'] = `l' 	
						}
					}
				}
			}

			local jk = 1
			local j  = 1 
			local wk = 1
			local newd ""

			forvalues i=1/`k' {
				while (`wk'<=`kd'){
					forvalues j= 1/`kd' {
							local a = ///
							`muso'[`i',`j']
							if (`wk'==`a') {
							local b: ///
							word `j' ///
							of `dnames`i''
							local ///
						newd`i' "`newd`i'' `b'"
						local newd "`newd' `b'"
						local wk = `wk' + 1
						}
					}
				}
				local wk = 1
			}
			
			local newd_zero "`newd'"
			local knewd: list sizeof newd
			forvalues i=1/`knewd' {
				local xnewd: word `i' of `newd'
				capture tab `xnewd'
				local rc = _rc
				if (`rc') {
					tempvar xnewd`i'
					generate `xnewd`i'' = `xnewd'
					local newdtwo "`newdtwo' `xnewd`i''"
				}
				else {
					local newdtwo "`newdtwo' `xnewd'"			
				}
			}
			
			local newd "`newdtwo'"
		
			// Getting at varlist 
			
			local covariates `"`e(covariates)'"'
			local allvars    `"`e(allvars)'"'
			local dvarsat    `"`e(dvars)'"'
			local cvarsat    `"`e(cvars)'"'
			local quietoat   `"`e(quieto3)'"'
			local  y   = e(lhs)
			local stripe ""
			local tipo ""
			local nombre ""
			local namesrhs ""
			local newxvars ""
			local newdvars ""
			local ndlt ""
			local newcvars ""
			local evars ""
			local kcm: list sizeof cvarsat
			local kdm: list sizeof dvarsat
			local rhs = "`e(rhs)'"
			local krh: list sizeof rhs
			matrix `dorc' = J(1, `krh', 0)
			matrix `posx' = J(1, `krh', 0)
			forvalues i=1/`krh' {
				local a: word `i' of `rhs'
				fvexpand `a' if `touse'
				local b = r(varlist)
				local b: word 1 of `b'
				_ms_parse_parts `b'
				local c = r(name)
				local namesrhs "`namesrhs' `c'"
			}
			local k: list sizeof covariates
			local k2 = rowsof(`atmatrix')
			matrix `A'   = J(1, `k', 0)
			forvalues i=1/`k' {
				local a: word `i' of `covariates'
				local stripe "`stripe' `y':`a'"
				_ms_parse_parts `a'
				local b   = r(type)
				local c   = r(name)
				local mtf = r(level)
				local tipo "`tipo' `b'"
				local qa: word `i' of `quietoat'
				if ("`qa'"=="quieto") {
					local nombre "`nombre' `c'"
				}
				else {
					local nombre "`nombre' `a'"
				}
			}
			local fordorc: list uniq nombre
			forvalues i=1/`krh' {
				local ft0: word `i' of `fordorc'
				local ftc: list ft0 & cvarsat
				if ("`ftc'"!="") {
					matrix `dorc'[1,`i'] = `i'
				}
				else {
					matrix `dorc'[1,`i'] = -`i'
				}
				forvalues j=1/`krh' {
					local alist: word `i' of `fordorc'
					local alist2: word `i' of `rhzero'
					local blist: word `j' of `allvars'
					if ("`alist'"=="`blist'"| ///
						"`alist2'"=="`blist'") {
						matrix `posx'[1,`i'] = `j' 
					}
				}
			} 
			local j = 1
			matrix colnames `A' = `stripe'
			_ms_at_parse `at', asobserved mat(`A')
			local estad    = r(statlist)
			local atvars   = r(atvars)
			local atvars1 "`atvars'"
			local  stats1  "`estad'"
			local pct ""
			forvalues i=1/99 {
				local pct "p`i'"
			}
			local listas "asobserved asbalanced value values"
			local lista1 ///
				"mean median min max `pct' zero base `listas'"
			local 0 `",`atnames'"'
			syntax [, at(string) *]
			while `:length local at'{
				_ms_at_parse `at', asobserved mat(`A')
				local estad    = r(statlist)
				local atvars   = r(atvars)
				local atvars`j' "`atvars'"
				local  stats`j'  "`estad'"
				local kgtk = colsof(`A')
				local empiezo "`stats`j''"
				local final ""
				forvalues ppd=1/`kgtk' {
					gettoken empiezo depord: empiezo, ///
						match(paren) bind
					local empiezo = ///
						subinstr("`empiezo'"," ","",.) 
					local final "`final' `empiezo'"
					local empiezo "`depord'"
				}
				local final2 ""
				forvalues ppd=1/`kgtk' {
					local ppdx: word `ppd' of `final'
					local interpp: list ppdx & lista1
					if ("`interpp'"=="") {
						local final2 "`final2' (`ppdx')"
					}
					else {
						local final2 "`final2' `ppdx'"
					}
				}
				local stats`j' "`final2'"
				local estad "`stats`j''" 
				local j = `j' + 1
				forvalues i=1/`k' {
					local a: word `i' of `estad'
					if ("`a'"=="("| "`a'"==")") {
						local innew = `i' + 1
						local a: word `innew' of `estad'
						local anew "`a'"
					}
					local b: word `i' of `tipo'
					local c: word `i' of `nombre'
					local inter: list c & atvars
					if ("`a'"=="mean" & ///
						"`b'"=="factor" & ///
						"`inter'"!="") {
						 display as error ///
					"incorrect {bf:margins}"  ///
					" specification after"	  ///
					" {bf:npregress kernel}"
					di as err "{p 4 4 2}" 
				di as smcl as err "The kernel used for" 
				di as smcl as err " discrete"
				di as smcl as err " covariates is" 
				di as smcl as err " only well defined"
				di as smcl as err "for the original " 
				di as smcl as err " values of the" 
				di as smcl as err " discrete"
				di as smcl as err " covariates."
				di as smcl as err " The kernel is"
				di as smcl as err " degenerate at " 
				di as smcl as err " values other than" 
				di as smcl as err " the original"
				di as smcl as err " discrete levels." 
				di as smcl as err "{p_end}"
						exit 198
					} 
				}
				local 0 `",`options'"'
				syntax [, at(string) *]
			}
			local pct ""
			forvalues i=1/99 {
				local pct "p`i'"
			}
		local listas "asobserved asbalanced value values"
		local lista1 ///
			"mean median min max `pct' zero base `listas'"
			matrix `cuentas' = J(1, `k2', 0)
			forvalues i=1/`k2' {
				local cuentas`i' = 0 
				local nom`i' ""
				local xvars`i' ""
				forvalues j=1/`k' {
					if ("`stats`i''"==""){
						local b: word `j' ///
						of `stats1'
					}
					else {
						local b: word `j' ///
						of `stats`i''
					}
					local var: word `j' of	///
					 `covariates'
					 local qat: word `j' of `quietoat'
					_ms_parse_parts `var'
					local nivel   = r(level)
					local tipo    = r(type)
					local nom     = r(name)
					if ("`qat'"=="movete") {
						local nom "`var'"
					}
					if (`j'==1) {
						local nomprev "."
					}
					if (`atmatrix'[`i',`j']==1 &	///
						"`tipo'"=="factor") {
						tempvar x`i'`j'
						if ("`qat'"=="movete") {
							quietly generate ///
							double `x`i'`j'' = ///
								1 
						}
						else {
							quietly generate ///
							double `x`i'`j'' = ///
							`nivel' 
						}
						local cuentas`i' = ///
						`cuentas`i'' + 1 
						local nom`i' "`nom`i'' `nom'" 
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"
					}
					if (`atmatrix'[`i',`j']==0 & ///
						"`qat'"=="movete") {
						tempvar x`i'`j'
						quietly generate double ///
							`x`i'`j'' = `var' 
						local cuentas`i' = ///
						`cuentas`i'' + 1  
						local nom`i' ///
							"`nom`i'' `nom'"
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"			
					}
					local a: list b & lista1
					if (`atmatrix'[`i',`j']!=. &	///
						"`tipo'"=="variable" & ///
						"`a'"!="") {
						tempvar x`i'`j'
						quietly generate ///
							double `x`i'`j'' ///
							= ///
							`atmatrix'[`i',`j']  ///
								if `touse'
						local cuentas`i' = ///
							`cuentas`i'' + 1  
						local nom`i' "`nom`i'' `nom'"
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"
					}
					local a: list b & lista1
					if "`a'"=="" {
						tempvar x`i'`j'
						gettoken a1 a2: b, parse("(")
						gettoken a3 a4: a2, parse(")")
						if ("`anew'"!="") {
							local a3 "`anew'"
						}
						qui generate double 	///
							`x`i'`j'' = `a3'
						local cuentas`i' = 	///
							`cuentas`i'' + 1 
						local nom`i' "`nom`i'' `nom'" 
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"
					}
					if (`atmatrix'[`i',`j']==. &	///
						"`tipo'"=="factor") {
						if ("`qat'"=="quieto" & ///
							"`nomprev'"!="`nom'") {
							tempvar x`i'`j'
							quietly generate ///
							double `x`i'`j'' = ///
								`nom' 
						}
						if ("`qat'"=="movete") {
							tempvar x`i'`j'
							quietly generate ///
							double `x`i'`j'' = ///
								`var' 
						}
						local cuentas`i' = ///
							`cuentas`i'' + 1 
						local nom`i' "`nom`i'' `nom'" 
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"
					}
					if (`atmatrix'[`i',`j']==. & ///
						"`tipo'"=="variable") {
						tempvar x`i'`j'
						quietly generate double ///
							`x`i'`j'' = ///
						`nom' if `touse'
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"
					}
					local nomprev "`nom'"
			}	
			local nom`i': list uniq nom`i'
				if (`cuentas`i'' == `krh') {
					matrix `cuentas'[1,`i'] = 1
				}
			}
			quietly generate double `fin'  = . 		
			local j = 1 
			local z = 1 
			forvalues i = 1/`k2' {
				tempvar evar`i'
				quietly generate double `evar`i'' = . 
				local evars "`evars' `evar`i'"
				while (`z' <= `krh' & `posx'[1,`j']!=0) {
					if (`posx'[1,`j'] == `z') {
						local xvarnew: 	 ///
							word `j' ///
						of `xvars`i''
						if `dorc'[1,`j']<0 {
							local 	 ///
							newdvars ///
						"`newdvars' `xvarnew'"
						}
						else {
							local	 ///
							newcvars ///
						"`newcvars' `xvarnew'"
						}
						local z = `z' + 1
						local j = 0 
					}
					local j = `j' + 1
				}
				local z = 1 
			}

			local kmgl:  list sizeof newd
			local kat:   list sizeof newdvars
			local kdd:   list sizeof dvarsat 
			local knew = `kmgl'*`kdd'
			local i  = 1
			local j  = 1 
			local i2 = 1
			local j2 = 1
			local bd = 0 
			local ndlt ""
			while `j2'<= `kat'  {
				while `i' <= `kmgl' {
					while `j' <=`kdd' {
						local x: word `i' ///
						of `newd_zero'
						local y: word `j2' ///
						of `newdvars'
						local z: list x & dvarsat
						if ("`z'"=="") {
							local ndlt ///
							"`ndlt' `x'"
						}
						else {
							local ndlt ///
							"`ndlt' `y'"
						}
						local j  = `j' + 1
						local i  = `i' + 1
						local j2 = `j2' + 1
					}
					local j  = 1 
					local j2 = `j' + `bd'
				}
				local j2 = `j2' + `kdd'
				local bd = `bd' + `kdd'
				local j  = 1
				local i  = 1 
			}
			local tester: list sizeof ndlt
			local kfin: list sizeof ndlt
			local kcnv: list sizeof newcvars
			local nclt ""
			local ncf ""
			forvalues i=1/`kcnv' {
				local x: word `i' of `newcvars'
				local nclt "`nclt' `x'"
				if (int(`i'/`kcm')==`i'/`kcm') {
					local nclt`i' = ///
						`"`nclt'"'*`kdlf'
					local nclt ""
					local ncf "`ncf' `nclt`i''"
				}
			}
			local kloop = `kdlf'*`k2'
			local klong = `kloop'
			local kgradsen = `e(kgrad)'*`kloop'
			matrix `mgrad'     = J(`kloop', 1,  0)
			matrix `mgradse'   = J(`kloop', `kloop',  0)
			local gradsen ""
			forvalues i=1/`kgradsen' {
				tempvar gm`i'
				quietly generate double `gm`i''  = . 
				local gradsen "`gradsen' `gm`i''"	
			}
			local kfin: list sizeof ndlt	
			local covarnoms ""
			forvalues i=1/`kloop' {
				tempvar covar`i'
				quietly generate `covar`i'' = .
				local covarnoms "`covarnoms' `covar`i''"
			}
		
			mata: _kernel_regression_at(`e(ke)', 	 ///
			`e(cdnum)', `kcm', `kdm',	`kloop', ///
			"`ncf'", "`ndlt'", `"`e(cvars)'"',	 ///
			`"`e(dvars)'"', "`e(lhs)'", "`prelim'",  ///
			"`fin'", "`vmatrix'", "`e(kest)'", 	 ///
			`e(cellnum)', "`covarnoms'", "`newwgt'", ///
			`wgtc', "`touselk'")

			if (`k2'>1) {
				mata: _np_reorder_atlevels(`k2', ///
					"`matorig'", "`prelim'")
			}

			quietly summarize `touse' `wgt', meanonly
			local N = r(N)
			matrix `b1' = nullmat(`b1'), `prelim'
			matrix `V1' = nullmat(`V1'), `vmatrix'
		}

		local tirando ""
		local kls: list sizeof anything
		local newdd ""

		_retirando, anything(`oldanything')
		matrix `matst2' = r(matstat)
		local rjxl = r(jx)
		forvalues i=1/`rjxl' {
			local names`i' "`r(names`i')'"
		}
		
		matrix `matst' = `matst2'
		local kls = colsof(`matst2')

		local kld: list sizeof newdd
		local knf = `kls'*`k2vlt'

		mata: _np_reorder_ml_at(`kls', `k2', `k2vlt', ///
		      "`matst'", "`b1'")
		     
		local attira ""
		forvalues i=1/`k2' {
			if (`k2'>1) {
				local attira `i'._at#
			}
			local j1 = 1 
			local j2 = 1
			local j3 = 1
			while (`j1' <= `knf') {
				local a: word `j3' of `vlt'
				local b "`names`j2''"
				local ktt: list sizeof b
				if (`ktt'==1) {
					fvexpand i.`b' if `touselk'
					local alista = r(varlist)
				}
				else {
					local alista "`b'"
				}
				local klista: list sizeof alista
				forvalues i=1/`klista' {
					local c: word `i' of `alista'
					_ms_parse_parts `c'
					local nom0 = r(level)
					local nom1 = r(name)
					local nom "`nom0'.`nom1'"
					local tirando ///
					"`tirando' `attira'`a'#`nom'"			
				}
				local j4 = `j3'
				if (`j3' < `k2vlt') {
					local j3 = `j3' + 1 
				}
				if (`j4'==`k2vlt') {
					local j3 = 1
					if (`j2'<`kls') {
						local j2 = `j2' + 1
					}
					else {
						local j2 = 1
					}
				}
				local j1 = `j1' + 1		
			}
		}

		local kbt = colsof(`b1')
		mata: _restripe_ml_at("`tirando'", "`matst2'", `k2',	///
			`k2vlt', `kbt')
		matrix colnames `b1' = `tirando'
		local bla: list sizeof tirando
		local lhs = e(lhs)
		quietly summarize `lhs' if `touse' `wgt'
		local N = r(N)
		matrix `covar_np' = J(`bla', `bla', 0)
		forvalues i=1/`bla' {
			forvalues j=1/`bla' {
				local a = `b1'[1,`i']
				local b = `b1'[1,`j']
				if (`i'!=`j') {
					matrix 			///
					`covar_np'[`i',`j'] =	///
					 -`a'*`b'/`N'
				}
			}
		}
		matrix `V1' = diag(`V1') + `covar_np'
		matrix colnames `V1' = `tirando'
		matrix rownames `V1' = `tirando'
		matrix `b0' = `b1'
		matrix `V0' = `V1'
		return local lista  "`tirando'"
		return matrix V0 = `V0'
		return matrix b0 = `b0'
		return matrix V1 = `V1'
		return matrix b1 = `b1'
		return scalar N  = `N'
	}
end 

program define caseseis, rclass
	syntax [if] [in] [fw pw iw], dydx(string)  atnames(string)	///
				     atmat(string) anything(string)	///
				   [over(string)]
	tempvar newwgt
	marksample touse 
	
	// Weights 
	
	local wgtc = 0 
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
		gettoken wgtbc wgtac: exp
		if ("`weight'"=="fweight"|"`weight'"=="iweight") {
			local wgtc = 1
		}
		if (`wgtc'==0) {
			local wgt "[iweight =`newwgt']"
		}
		clonevar `newwgt' = `wgtac'	
	}
	else {
		quietly generate `newwgt' = 1
	}
				   
	if ("`over'"=="") {
		tempname newbaseval muso muso2 baseval uniqval	///
			mgrad gbase ehat rdos finse mgradse	///
			ehat2 A AT atmatrix atnew cuentas 	///
			prelim dorc posx rdos fin gradsen 	///
			covarmat usar beta2 V2 indice beta0 V0	///
			indice2 matst bkro selectkro betat	///
			betatest beta2new matorig matst2 betaf
			 
		local continuous = "`e(cvars)'"
		local discrete   = "`e(dvars)'"
		local celulas    = e(cellnum)
		local quietoat   `"`e(quieto3)'"'
		local quieto  = "`e(quieto)'"
		local quieto2 = "`e(quieto2)'"
		local rhzero     `"`e(rhzero)'"'
		local yesrhs     = e(yesrhs)
		
		// Dimensions of atmat 
		
		matrix `atmatrix' = `atmat'
		local k2 = rowsof(`atmatrix')
		
		// Getting a list of discrete values 
		
		capture _lista_yesrhs `anything' if `touse', quieto(`quieto')
		local rc = _rc
		if (`rc') {
			fvexpand `anything' if `touse'
			local anything = r(varlist)
		}
		else {
			local anything = "`s(lyesrhs)'"
		}
		
		local k0c: list sizeof continuous
		local k0: list sizeof anything
		local kd: list sizeof discrete
		local dlistf " "
		matrix `matst' = J(1, `k0', 0)
		forvalues i=1/`k0' {
			local w: word `i' of `anything'
			quietly capture tab `w'
			local rc = _rc
			if (`rc') {
				local dlist "`dlist' `w'"
				local kfst: list sizeof w
				matrix `matst'[1,`i'] = `kfst'
			}
			else {
				fvexpand i.`w' if `touse'
				local w0   = r(varlist)		
				local dlist "`dlist' `w0'"
				local kfst: list sizeof w0
				matrix `matst'[1,`i'] = `kfst'
			}
		}
		
 		local k: list sizeof dlist

		forvalues i=1/`k' {
			local _dlx: word `i' of `dlist'
			_ms_parse_parts `_dlx'
			local _name0 = r(name)
			forvalues j = 1/`k' {
				local _dly: word `j' of `dlist'
				_ms_parse_parts `_dly'
				local _name1 = r(name)
				if ("`_name0'"=="`_name1'") {
					local _name "`_name' `_dlx' `_dly'"
				}
				else{
					local _name "`_name' `_dlx'"
				}
			}
		}

		local _name: list uniq _name
		local dlist "`_name'"
		local jacum = 0 
		local _name ""
		
		forvalues i=1/`k' {
			local _dlx: word `i' of `dlist'
			_ms_parse_parts `_dlx'
			local _name0 = r(name)
			local level0 = r(level)
			local jacum = 0 
			forvalues j = 1/`k' {
				local _dly: word `j' of `dlist'
				_ms_parse_parts `_dly'
				local _name1 = r(name)
				local level1 = r(level)
				if ("`_name0'"=="`_name1'" ///
					& `level1'< `level0') {
					local _name "`_name' `_dly' `_dlx'"
					local jacum = `jacum' + 1
				}
				if (`jacum'==0 & `j'==`k') {
					local _name "`_name' `_dlx'"
					local jacum = 0 
				}
			}
		}

		local _name: list uniq _name
		local dlist "`_name'"
	
		forvalues i=1/`k' {
			local w: word `i' of `dlist'
			local wf = `" `w' "'*`k2'
			local dlistf "`dlistf' `wf'"
		}

		_retirando, anything(`dlist')
		matrix `matorig' = r(matstat)
		
		local j = 1
		local k: list sizeof dlist
		local kdlf = `k'
		forvalues i=1/`k' {
			local x: word `i' of `dlist'
			_ms_parse_parts `x'
			local base  = r(base)
			local value = r(level)
			local nomxx = r(name)
			local nomx: list x & discrete
			if ("`nomx'"!="") {
				local other: list discrete - nomx
			}
			else {
				local other: list discrete - nomxx			
			}
			local other: list other - x
			tempvar x`j'
			if ("`nomx'"=="") {
				quietly generate `x`j'' = `value'
				local names`j' "`nomxx' `other'"
			}
			else {
				quietly generate `x`j'' = 1	
				local names`j' "`nomx' `other'"	
			}
			local dnames`j' "`x`j'' `other'"
			local dnames "`dnames' `dnames`j''"
			local j = `j' + 1
		} 
		local kmuso = `j' - 1
		matrix `muso' = J(`kmuso',`kd', 0)	
		forvalues i=1/`k' {
			forvalues j=1/`kd' {
				local uno: word `j' of `names`i''
				forvalues l=1/`kd' {
					local dos: word `l' of ///
					`discrete'
					if ("`dos'"=="`uno'") {
						matrix ///
						`muso'[`i',`j'] = `l' 	
					}
				}
			}
		}

		local jk = 1
		local j  = 1 
		local wk = 1
		forvalues i=1/`k' {
			while (`wk'<=`kd'){
				forvalues j= 1/`kd' {
						local a = ///
							`muso'[`i',`j']
						if (`wk'==`a') {
						local b: ///
							word `j' ///
						of `dnames`i''
						local newd`i' ///
						"`newd`i'' `b'"
						local newd "`newd' `b'"
						local wk = `wk' + 1
					}
				}
			}
			local wk = 1
		}
		
		local newd_zero "`newd'"
		local knewd: list sizeof newd
		forvalues i=1/`knewd' {
			local xnewd: word `i' of `newd'
			capture tab `xnewd'
			local rc = _rc
			if (`rc') {
				tempvar xnewd`i'
				generate `xnewd`i'' = `xnewd'
				local newdtwo "`newdtwo' `xnewd`i''"
			}
			else {
				local newdtwo "`newdtwo' `xnewd'"			
			}
		}
		local newd "`newdtwo'"	
		
		// Getting at varlist 
		
		local covariates `"`e(covariates)'"'
		local allvars    `"`e(allvars)'"'
		local dvarsat    `"`e(dvars)'"'
		local cvarsat    `"`e(cvars)'"'
		local  y   = e(lhs)
		local stripe ""
		local tipo ""
		local nombre ""
		local namesrhs ""
		local newxvars ""
		local newdvars ""
		local ndlt ""
		local newcvars ""
		local evars ""
		local kcm: list sizeof cvarsat
		local kdm: list sizeof dvarsat
		local rhs = "`e(rhzero)'"
		local krh: list sizeof rhs
		matrix `dorc' = J(1, `krh', 0)
		matrix `posx' = J(1, `krh', 0)
		forvalues i=1/`krh' {
			local a: word `i' of `rhs'
			fvexpand `a'
			local b = r(varlist)
			local b: word 1 of `b'
			_ms_parse_parts `b'
			local c = r(name)
			local namesrhs "`namesrhs' `c'"
		}
		local k: list sizeof covariates
		matrix `A'   = J(1, `k', 0)
		forvalues i=1/`k' {
			local a: word `i' of `covariates'
			local stripe "`stripe' `y':`a'"
			_ms_parse_parts `a'
			local b = r(type)
			local c = r(name)
			local tipo "`tipo' `b'"
			local qa: word `i' of `quietoat'
			if ("`qa'"=="quieto") {
				local nombre "`nombre' `c'"
			}
			else {
				local nombre "`nombre' `a'"
			}
		}
		local fordorc: list uniq nombre
		forvalues i=1/`krh' {
			local ft0: word `i' of `fordorc'
			local ftc: list ft0 & cvarsat
			if ("`ftc'"!="") {
				matrix `dorc'[1,`i'] = `i'
			}
			else {
				matrix `dorc'[1,`i'] = -`i'
			}
			forvalues j=1/`krh' {
				local alist: word `i' of `fordorc'
				local blist: word `j' of `allvars'
				local alist2: word `i' of `rhzero'
				if ("`alist'"=="`blist'"| ///
					"`alist2'"=="`blist'") {
					matrix `posx'[1,`i'] = `j' 
				}
			}
		} 
		local j = 1
		matrix colnames `A' = `stripe'
		_ms_at_parse `at', asobserved mat(`A')
		local estad    = r(statlist)
		local atvars   = r(atvars)
		local atvars1 "`atvars'"
		local  stats1  "`estad'"
		local pct ""
		forvalues i=1/99 {
			local pct "p`i'"
		}
		local listas "asobserved asbalanced value values"
		local lista1 "mean median min max `pct' zero base `listas'"
		local 0 `",`atnames'"'
		syntax [, at(string) *]
		while `:length local at'{
			_ms_at_parse `at', asobserved mat(`A')
			local estad    = r(statlist)
			local atvars   = r(atvars)
			local atvars`j' "`atvars'"
			local  stats`j'  "`estad'"
			local kgtk = colsof(`A')
			local empiezo "`stats`j''"
			local final ""
			forvalues ppd=1/`kgtk' {
				gettoken empiezo depord: empiezo, ///
					match(paren) bind
				local empiezo = subinstr("`empiezo'"," ","",.) 
				local final "`final' `empiezo'"
				local empiezo "`depord'"
			}
			local final2 ""
			forvalues ppd=1/`kgtk' {
				local ppdx: word `ppd' of `final'
				local interpp: list ppdx & lista1
				if ("`interpp'"=="") {
					local final2 "`final2' (`ppdx')"
				}
				else {
					local final2 "`final2' `ppdx'"
				}
			}
		local stats`j' "`final2'"
		local estad "`stats`j''" 
			local j = `j' + 1
			forvalues i=1/`k' {
				local a: word `i' of `estad'
				if ("`a'"=="("| "`a'"==")") {
					local innew = `i' + 1
					local a: word `innew' of `estad'
					local anew "`a'"
				}
				local b: word `i' of `tipo'
				local c: word `i' of `nombre'
				local inter: list c & atvars
				if ("`a'"=="mean" & 	///
				    "`b'"=="factor" & ///
				    "`inter'"!="") {
					 display as error ///
					"incorrect {bf:margins}" ///
					 " specification after"	 ///
					 " {bf:npregress kernel}"
				di as err "{p 4 4 2}" 
				di as smcl as err "The kernel used for" 
				di as smcl as err " discrete"
				di as smcl as err " covariates is" 
				di as smcl as err " only well defined"
				di as smcl as err "for the original " 
				di as smcl as err " values of the" 
				di as smcl as err " discrete"
				di as smcl as err " covariates."
				di as smcl as err " The kernel is"
				di as smcl as err " degenerate at " 
				di as smcl as err " values other than" 
				di as smcl as err " the original"
				di as smcl as err " discrete levels." 
				di as smcl as err "{p_end}"
					exit 198
				} 
			}
			local 0 `",`options'"'
			syntax [, at(string) *]
		}
		local pct ""
		forvalues i=1/99 {
			local pct "p`i'"
		}
		local listas "asobserved asbalanced value values"
		local lista1 ///
			"mean median min max `pct' zero base `listas'"
		matrix `cuentas' = J(1, `k2', 0)
		forvalues i=1/`k2' {
			local cuentas`i' = 0 
			local nom`i' ""
			local xvars`i' ""
			forvalues j=1/`k' {
				if ("`stats`i''"==""){
					local b: word `j' of `stats1'
				}
				else {
					local b: word `j' of `stats`i''
				}
				local var: word `j' of `covariates'
				local qat: word `j' of 	`quietoat'
				_ms_parse_parts `var'
				local nivel   = r(level)
				local tipo    = r(type)
				local nom     = r(name)
				if (`j'==1) {
					local nomprev "."
				}
				if (`atmatrix'[`i',`j']==1 &	///
					"`tipo'"=="factor") {
					tempvar x`i'`j'
					if ("`qat'"=="movete") {
						quietly generate ///
							double `x`i'`j'' = ///
							1 
					}
					else {
						quietly generate ///
							double `x`i'`j'' = ///
						`nivel' 
					}
					local cuentas`i' = `cuentas`i'' + 1 
					local nom`i' "`nom`i'' `nom'" 
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				if (`atmatrix'[`i',`j']==0 & ///
					"`qat'"=="movete") {
					tempvar x`i'`j'
					quietly generate double ///
						`x`i'`j'' = `var' 
					local cuentas`i' = `cuentas`i'' + 1  
					local nom`i' "`nom`i'' `nom'"
					local xvars`i' "`xvars`i'' `x`i'`j''"			
				}
				local a: list b & lista1
				if (`atmatrix'[`i',`j']!=. &	///
					"`tipo'"=="variable" & "`a'"!="") {
					tempvar x`i'`j'
					quietly generate double `x`i'`j'' ///
						= `atmatrix'[`i',`j']  ///
							if `touse'
					local cuentas`i' = `cuentas`i'' + 1  
					local nom`i' "`nom`i'' `nom'"
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				if "`a'"=="" {
					 tempvar x`i'`j'
					 gettoken a1 a2: b, parse("(") bind
					 gettoken a3 a4: a2, parse(")") bind
					 if ("`anew'"!="") {
						local a3 "`anew'"
					 }
					 quietly generate ///
						double `x`i'`j'' = ///
						`a3' if `touse'
					 local cuentas`i' = `cuentas`i'' + 1 
					 local nom`i' "`nom`i'' `nom'" 
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				if (`atmatrix'[`i',`j']==. &	///
					"`tipo'"=="factor") {
					if ("`qat'"=="quieto" & ///
						"`nomprev'"!="`nom'") {
						tempvar x`i'`j'
						quietly generate ///
							double `x`i'`j'' = ///
							`nom' 
					}
					if ("`qat'"=="movete") {
						tempvar x`i'`j'
						quietly generate ///
							double `x`i'`j'' = ///
							`var' 
					}
					local cuentas`i' = `cuentas`i'' + 1 
					local nom`i' "`nom`i'' `nom'" 
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				if (`atmatrix'[`i',`j']==. & ///
					"`tipo'"=="variable") {
					tempvar x`i'`j'
					quietly generate double `x`i'`j'' = ///
					`nom' if `touse'
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}	
				local nomprev "`nom'"
			}	
			local nom`i': list uniq nom`i'
			if (`cuentas`i'' == `krh') {
				matrix `cuentas'[1,`i'] = 1
			}
		}
		quietly generate double `fin'  = . 		
		local j = 1 
		local z = 1  
		forvalues i = 1/`k2' {
			tempvar evar`i'
			quietly generate double `evar`i'' = . 
			local evars "`evars' `evar`i'"
			while (`z' <= `krh' & `posx'[1,`j']!=0) {
				if (`posx'[1,`j'] == `z') {
					local xvarnew: word `j' ///
						of `xvars`i''
					if `dorc'[1,`j']<0 {
						local newdvars	///
						 "`newdvars' `xvarnew'"
					}
					else {
						local newcvars	///
						 "`newcvars' `xvarnew'"
					}
					local z = `z' + 1
					local j = 0 
				}
				local j = `j' + 1
			}
			local z = 1 
		} 

		local kmgl:  list sizeof newd
		local kat:   list sizeof newdvars
		local kdd:   list sizeof dvarsat 
		local knew = `kmgl'*`kdd'
		local i  = 1
		local j  = 1 
		local i2 = 1
		local j2 = 1
		local bd = 0 
		while `j2'<= `kat'  {
			while `i' <= `kmgl' {
				while `j' <=`kdd' {
					local x: word `i' of `newd_zero'
					local y: word `j2' of `newdvars'
					local z: list x & dvarsat
					if ("`z'"=="") {
						local ndlt "`ndlt' `x'"
					}
					else {
						local ndlt "`ndlt' `y'"
					}
					local j  = `j' + 1
					local i  = `i' + 1
					local j2 = `j2' + 1
				}
				local j  = 1 
				local j2 = `j' + `bd'
			}
			local j2 = `j2' + `kdd'
			local bd = `bd' + `kdd'
			local j  = 1
			local i  = 1 
		}
		
		// Getting gradient list 
		
		local cdnum  = e(cdnum)
		if (`cdnum'==2) {
			local k0c = 1
		}
		_dydx_listas, dydx(`dydx') continuous(`continuous')	///
			      discrete(`discrete') quieto(`quieto')	///
			      quieto2(`quieto2')
		
		local h       = "`s(h)'"
		local lalista = "`s(lalista)'"

		local taman: list sizeof h
		local ktaman       = `taman'*`kdlf'*`k2'
		local kloop        = `kdlf'*`k2'
		local klong        = `kloop'
		local kgradsen     = `e(kgrad)'*`kloop'
		local rmgrad       = e(kgrad) 
		local cmgrad       = e(kderiv)
		local klong        = `kdlf'*`cmgrad'
		local klong2       = `kdlf'*`rmgrad'
		local katdydx      = `kdlf'*`cmgrad'*`k2'
		matrix `gbase'     = J(1,`rmgrad', 0)
		matrix `mgrad'     = J(`katdydx', 1,  0)
		matrix `mgradse'   = J(`katdydx', `katdydx',  0)
		
		/*
			1. Size of gradient 
			2. Size of marginslist
			3. Number of at() conditions
		*/
		
		local kcnv: list sizeof newcvars
		local nclt ""
		local ncf ""
		forvalues i=1/`kcnv' {
			local x: word `i' of `newcvars'
			local nclt "`nclt' `x'"
			if (int(`i'/`kcm')==`i'/`kcm') {
				local nclt`i'  = `"`nclt'"'*`kdlf'
				local nclt ""
				local ncf "`ncf' `nclt`i''"
			}
		}
		
		local gradsen ""
		forvalues i=1/`kgradsen' {
			tempvar gm`i'
			quietly generate double `gm`i''  = . 
			local gradsen "`gradsen' `gm`i''"	
		}
		
		forvalues i=1/`cmgrad' {
			tempvar xcm`i'
			quietly generate double `xcm`i'' = . 
			local dserrin "`dserrin' `xcm`i''"
		}
		
		local j   = 1
		local j3  = 1
		local ink = `katdydx'/`kloop'
		matrix `covarmat' = J(1, `katdydx', 0)
		forvalues i=1/`katdydx' {
			tempvar covar`i' 
			matrix `covarmat'[1,`i'] = `j' 
			if (`i'>0) {
				local j = `j' + `ink'
			}
			if (int(`i'/`kloop') ==`i'/`kloop') {
				local j3 = `j3' + 1
				local j  = `j3'
			}
			quietly generate double `covar`i''  = . 
			local covarlist "`covarlist' `covar`i''"
		}

		mata: _marginslist_gradient(`e(ke)', `kdd', 	///
		"`e(cvars)'", "`ndlt'", "`e(lhs)'", 		///
		"`e(kest)'", "`mgrad'", "`gbase'", 		///
		"e(pbandwidthgrad)", `cdnum', "e(basemat)",	///
		"e(basevals)", "e(uniqvals)", `kloop',		///
		`katdydx', "`gradsen'", "`e(dvars)'", 		///
		`e(cellnum)', "`covarlist'", "`covarmat'", 	///
		`k0c', 1, "`ncf'", "`newwgt'", "`touse'") 

		quietly generate double `ehat2' = . 
		quietly generate double `rdos'  = . 
		quietly generate double `finse' = .
		quietly generate double `ehat'  = ///
			(`e(lhs)'- `e(yname)')^2
	 
		
		// Selecting a list of derivatives 
		
		local kmas: list sizeof h	
		
		summarize `ehat' if `touse' `wgt', meanonly 
		local N = r(N)
		
		local k: list sizeof dlistf
		local mixlist ""

		local dlistfn ""
		forvalues i=1/`k' {
			local mxn: word `i' of `dlistf'
			_ms_parse_parts `mxn'
			local level = r(level)
			local name  = r(name)
			local dlistfn "`dlistfn' `level'.`name'"
		}
	
		forvalues i=1/`k' {
			local mxv: word `i' of `dlistf'
			_ms_parse_parts `mxv'
			local mxbase = r(base)
			local mxname = r(name)
			if (`mxbase'==1) {
				local op = r(op)
				local mixlist "`mixlist' `op'n.`mxname'"
			}
			else {
				local mixlist "`mixlist' `mxv'"
			}
		}
		
		local bli: list sizeof mixlist

		local kdlfn = `kdlf'*`k2'
		local lmgs  ""
		forvalues i=1/`kmas' {
			local xdydx: word `i' of `h'
			forvalues j=1/`k' {
				local xdlist: word `j' of `mixlist'
				local lmgs "`lmgs' `xdydx'"
			}
		}
		
		_select_dydx, lalista(`lalista') h(`h') k(`k')	///
			      gradm(`mgrad') ktaman(`ktaman') 	///
			      lmgs2(`lmgs')		
		
		matrix `beta0' = r(beta0)
		
		local bli: list sizeof lmgs
		local j  = 1
		local j1 = 1
		local j2 = 1
		local mytira ""	
	
		forvalues i=1/`kmas' {
			local x: word `i' of `h'
			_ms_parse_parts `x'
			local base = r(base)
			forvalues l = 1/`k' {
				local y: word `l' of `dlistfn'
				_ms_parse_parts `y'
				local na = r(name)
				local le = r(level)
				local j3 = `matst'[1,`j2']
				if (`base'!=1) {
					local pwt "`j1'._at#"
					if (`k2'==1) {
						local pwt ""
					}
					local b "`x':`pwt'`y'"
					local mytira "`mytira' `b'"
				}
				else {
					local b "`x':`j1'o._at#"
					if (`k2'==1) {
						local b "`x':"
					}
					local c "`le'o.`na'"
					local mytira "`mytira' `b'`c'"
				}
				if (`j'<`j3') {
					local j  = `j' + 1
				}
				else {
					local j  = 1
					local j1 = `j1' + 1
				}
				if (`j1'>`k2') {
					local j1 = 1
					local j2 = `j2' + 1
				}
			}
				local j2 = 1 
		}

		local ll = 1
		local ul = `k'

		forvalues i=1/`kmas' {
			tempname betaf`i'
			matrix `betaf`i'' = `beta0'[1, `ll'..`ul']
			if (`k2'>1) {
				mata: _np_reorder_atlevels(`k2', ///
					"`matorig'", "`betaf`i''")
			}
			matrix `betaf' = nullmat(`betaf'), `betaf`i''
			local ll = `ll' + `k'
			local ul = `ul' + `k'
		}		
		return local dlist "`h'"
		return local lista "`mytira'"	
		return local N       = `N'
		return matrix b1 = `betaf'
	}
	else {
		marksample touse 
		tempname beta1 Var1 matindex atmatrix	///
		atmatrix0 covar_np Var0 B0

		// Getting overlist 
		
		_parse_over if `touse', over(`over')
		local k2vlt = s(k2vlt)
		local vlt   = `"`s(vlt)'"'	
	
		local listvarsf ""
		matrix `atmatrix0' = `atmat'
		local katov = rowsof(`atmatrix0')
		local kfatov = `katov'/`k2vlt'
		local jkatov = `k2vlt' 
		forvalues i=1/`kfatov' {
			matrix `atmatrix' = ///
				nullmat(`atmatrix') \ ///
				`atmatrix0'[`jkatov', ///
				1..colsof(`atmatrix0')]
				local jkatov = `jkatov' + `k2vlt' 
		}	
		forvalues lk=1/`k2vlt' {		
			tempname newbaseval muso muso2 baseval	///
			uniqval mgrad gbase ehat rdos finse 	///
			mgradse	ehat2 A AT atnew cuentas prelim	///
			dorc posx rdos fin gradsen covarmat 	///
			usar beta2 V2 indice indice2 matst	///
			beta0 V0 bkro selectkro betat betatest	///
			beta2new matorig betaf matst2
			
			tempvar touselk
			
			local condvlt: word `lk' of `vlt'
			generate `touselk' = `condvlt'*`touse'	
			local continuous = "`e(cvars)'"
			local discrete   = "`e(dvars)'"
			local celulas    = e(cellnum)
			local quietoat   `"`e(quieto3)'"'
			local quieto  = "`e(quieto)'"
			local quieto2 = "`e(quieto2)'"
			local rhzero     `"`e(rhzero)'"'
			local yesrhs     = e(yesrhs)
			
			// Dimensions of atmat 
			
			_anything_sanity if `touselk', anything(`anything')
			
			local k2 = rowsof(`atmatrix')
			
			// Getting a list of discrete values 
			
			capture _lista_yesrhs `anything' if `touselk', ///
				quieto(`quieto')
			local rc = _rc
			if (`rc') {
				fvexpand `anything' if `touselk'
				local anything = r(varlist)
			}
			else {
				local anything = "`s(lyesrhs)'"
			}
			
			local k0c: list sizeof continuous
			local k0: list sizeof anything
			local kd: list sizeof discrete
			local dlistf " "
			local dlist ""
			matrix `matst' = J(1, `k0', 0)
			forvalues i=1/`k0' {
				local w: word `i' of `anything'
				quietly capture tab `w'
				local rc = _rc
				if (`rc') {
					local dlist "`dlist' `w'"
					local kfst: list sizeof w
					matrix `matst'[1,`i'] = `kfst'
				}
				else {
					fvexpand i.`w' if `touselk'
					local w0   = r(varlist)		
					local dlist "`dlist' `w0'"
					local kfst: list sizeof w0
					matrix `matst'[1,`i'] = `kfst'
				}
			}
					
			local k: list sizeof dlist
			local _name ""
			
			forvalues i=1/`k' {
				local _dlx: word `i' of `dlist'
				_ms_parse_parts `_dlx'
				local _name0 = r(name)
				forvalues j = 1/`k' {
					local _dly: word `j' of `dlist'
					_ms_parse_parts `_dly'
					local _name1 = r(name)
					if ("`_name0'"=="`_name1'") {
						local _name ///
							"`_name' `_dlx' `_dly'"
					}
					else{
						local _name "`_name' `_dlx'"
					}
				}
			}

			local _name: list uniq _name
			local dlist "`_name'"
			local jacum = 0 
			local _name ""
			
			forvalues i=1/`k' {
				local _dlx: word `i' of `dlist'
				_ms_parse_parts `_dlx'
				local _name0 = r(name)
				local level0 = r(level)
				local jacum = 0  
				forvalues j = 1/`k' {
					local _dly: word `j' of `dlist'
					_ms_parse_parts `_dly'
					local _name1 = r(name)
					local level1 = r(level)
					if ("`_name0'"=="`_name1'" ///
						& `level1'< `level0') {
						local _name ///
							"`_name' `_dly' `_dlx'"
						local jacum = `jacum' + 1
					}
					if (`jacum'==0 & `j'==`k') {
						local _name "`_name' `_dlx'"
						local jacum = 0 
					}
				}
			}

			local _name: list uniq _name
			local dlist "`_name'"
		
			local dlistf ""
			forvalues i=1/`k' {
				local w: word `i' of `dlist'
				local wf = `" `w' "'*`k2'
				local dlistf "`dlistf' `wf'"
			}
			
			_retirando, anything(`dlist')
			matrix `matorig' = r(matstat)
			
			local j = 1
			local k: list sizeof dlist
			local kdlf = `k'
			local dnames ""
			forvalues i=1/`k' {
				local x: word `i' of `dlist'
				_ms_parse_parts `x'
				local base  = r(base)
				local value = r(level)
				local nomxx = r(name)
				local nomx: list x & discrete
				if ("`nomx'"!="") {
					local other: list discrete - nomx
				}
				else {
					local other: list discrete - nomxx			
				}
				local other: list other - x
				tempvar x`j'
				if ("`nomx'"=="") {
					quietly generate `x`j'' = `value'
					local names`j' "`nomxx' `other'"
				}
				else {
					quietly generate `x`j'' = 1	
					local names`j' "`nomx' `other'"	
				}
				local dnames`j' "`x`j'' `other'"
				local dnames "`dnames' `dnames`j''"
				local j = `j' + 1
			} 
			local kmuso = `j' - 1
			matrix `muso' = J(`kmuso',`kd', 0)	 
			forvalues i=1/`k' {
				forvalues j=1/`kd' {
					local uno: word `j' of ///
						`names`i''
					forvalues l=1/`kd' {
						local dos: word `l' ///
						of `discrete'
						if ("`dos'"=="`uno'") {
							matrix ///
						   `muso'[`i',`j'] = `l' 	
						}
					}
				}
			}

			local jk = 1
			local j  = 1 
			local wk = 1
			local newd ""

			local bla = 1
			forvalues i=1/`k' {
				while (`wk'<=`kd'){
					forvalues j= 1/`kd' {
							local a = ///
							`muso'[`i',`j']
							if (`wk'==`a') {
							local b: ///
							word `j' ///
							of `dnames`i''
							local ///
							newd`i' ///
							"`newd`i'' `b'"
							local newd ///
							"`newd' `b'"
							local wk = ///
							`wk' + 1
						}
					}
				}
				local wk = 1
			}
			
			local newd_zero "`newd'"
			local knewd: list sizeof newd
			forvalues i=1/`knewd' {
				local xnewd: word `i' of `newd'
				capture tab `xnewd'
				local rc = _rc
				if (`rc') {
					tempvar xnewd`i'
					generate `xnewd`i'' = `xnewd'
					local newdtwo "`newdtwo' `xnewd`i''"
				}
				else {
					local newdtwo "`newdtwo' `xnewd'"			
				}
			}
			
			local newd "`newdtwo'"
			
			// Getting at varlist 
			
			local covariates `"`e(covariates)'"'
			local allvars    `"`e(allvars)'"'
			local dvarsat    `"`e(dvars)'"'
			local cvarsat    `"`e(cvars)'"'
			local  y   = e(lhs)
			local stripe ""
			local tipo ""
			local nombre ""
			local namesrhs ""
			local newxvars ""
			local newdvars ""
			local ndlt ""
			local newcvars ""
			local evars ""
			local kcm: list sizeof cvarsat
			local kdm: list sizeof dvarsat
			local rhs = "`e(rhzero)'"
			local krh: list sizeof rhs
			matrix `dorc' = J(1, `krh', 0)
			matrix `posx' = J(1, `krh', 0)
			forvalues i=1/`krh' {
				local a: word `i' of `rhs'
				fvexpand `a'
				local b = r(varlist)
				local b: word 1 of `b'
				_ms_parse_parts `b'
				local c = r(name)
				local namesrhs "`namesrhs' `c'"
			}
			local k: list sizeof covariates
			matrix `A'   = J(1, `k', 0)
			forvalues i=1/`k' {
				local a: word `i' of `covariates'
				local stripe "`stripe' `y':`a'"
				_ms_parse_parts `a'
				local b = r(type)
				local c = r(name)
				local tipo "`tipo' `b'"
				local qa: word `i' of `quietoat'
				if ("`qa'"=="quieto") {
					local nombre "`nombre' `c'"
				}
				else {
					local nombre "`nombre' `a'"
				}
			}
			local fordorc: list uniq nombre
			forvalues i=1/`krh' {
				local ft0: word `i' of `fordorc'
				local ftc: list ft0 & cvarsat
				if ("`ftc'"!="") {
					matrix `dorc'[1,`i'] = `i'
				}
				else {
					matrix `dorc'[1,`i'] = -`i'
				}
				forvalues j=1/`krh' {
					local alist: word `i' of `fordorc'
					local blist: word `j' of `allvars'
					local alist2: word `i' of `rhzero'
					if ("`alist'"=="`blist'"| ///
						"`alist2'"=="`blist'") {
						matrix `posx'[1,`i'] = `j' 
					}
				}
			} 
			local j = 1
			matrix colnames `A' = `stripe'
			_ms_at_parse `at', asobserved mat(`A')
			local estad    = r(statlist)
			local atvars   = r(atvars)
			local atvars1 "`atvars'"
			local  stats1  "`estad'"
			local pct ""
			forvalues i=1/99 {
				local pct "p`i'"
			}
			local listas "asobserved asbalanced value values"
			local lista1	///
				"mean median min max `pct' zero base `listas'"
			local 0 `",`atnames'"'
			syntax [, at(string) *]
			while `:length local at'{
				_ms_at_parse `at', asobserved mat(`A')
				local estad    = r(statlist)
				local atvars   = r(atvars)
				local atvars`j' "`atvars'"
				local  stats`j'  "`estad'"
				local kgtk = colsof(`A')
				local empiezo "`stats`j''"
				local final ""
				forvalues ppd=1/`kgtk' {
					gettoken empiezo depord: empiezo, ///
						match(paren) bind
					local empiezo = ///
						subinstr("`empiezo'"," ","",.) 
					local final "`final' `empiezo'"
					local empiezo "`depord'"
				}
				local final2 ""
				forvalues ppd=1/`kgtk' {
					local ppdx: word `ppd' of `final'
					local interpp: list ppdx & lista1
					if ("`interpp'"=="") {
						local final2 "`final2' (`ppdx')"
					}
					else {
						local final2 "`final2' `ppdx'"
					}
				}
				local stats`j' "`final2'"
				local estad "`stats`j''" 
				local j = `j' + 1
				forvalues i=1/`k' {
					local a: word `i' of `estad'
					if ("`a'"=="("| "`a'"==")") {
						local innew = `i' + 1
						local a: word `innew' of `estad'
						local anew "`a'"
					}
					local b: word `i' of `tipo'
					local c: word `i' of `nombre'
					local inter: list c & atvars
					if ("`a'"=="mean" & 	///
					    "`b'"=="factor" & ///
					    "`inter'"!="") {
						 display as error ///
					"incorrect {bf:margins}" ///
					 " specification after"	 ///
					 " {bf:npregress kernel}"
					di as err "{p 4 4 2}" 
				di as smcl as err "The kernel used for" 
				di as smcl as err " discrete"
				di as smcl as err " covariates is" 
				di as smcl as err " only well defined"
				di as smcl as err "for the original " 
				di as smcl as err " values of the" 
				di as smcl as err " discrete"
				di as smcl as err " covariates."
				di as smcl as err " The kernel is"
				di as smcl as err " degenerate at " 
				di as smcl as err " values other than" 
				di as smcl as err " the original"
				di as smcl as err " discrete levels." 
				di as smcl as err "{p_end}"
						exit 198
					} 
				}
				local 0 `",`options'"'
				syntax [, at(string) *]
			}
			local pct ""
			forvalues i=1/99 {
				local pct "p`i'"
			}
			local listas ///
			"asobserved asbalanced value values"
			local lista1 ///
			"mean median min max `pct' zero base `listas'"
			matrix `cuentas' = J(1, `k2', 0)
			local nomprev ""
			forvalues i=1/`k2' {
				local cuentas`i' = 0 
				local nom`i' ""
				local xvars`i' ""
				forvalues j=1/`k' {
					if ("`stats`i''"==""){
						local b: word `j' of `stats1'
					}
					else {
						local b: word `j' of `stats`i''
					}
					local var: word `j' of `covariates'
					local qat: word `j' of 	`quietoat'
					_ms_parse_parts `var'
					local nivel   = r(level)
					local tipo    = r(type)
					local nom     = r(name)
					if (`j'==1) {
						local nomprev "."
					}
					if (`atmatrix'[`i',`j']==1 &	///
						"`tipo'"=="factor") {
						tempvar x`i'`j'
						if ("`qat'"=="movete") {
							quietly generate ///
							double `x`i'`j'' = ///
								1 
						}
						else {
							quietly generate ///
								double ///
								`x`i'`j'' = ///
							`nivel' 
						}
						local cuentas`i' = ///
							`cuentas`i'' + 1 
						local nom`i' "`nom`i'' `nom'" 
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"
					}
					if (`atmatrix'[`i',`j']==0 & ///
						"`qat'"=="movete") {
						tempvar x`i'`j'
						quietly generate double ///
							`x`i'`j'' = `var' 
						local cuentas`i' = ///
							`cuentas`i'' + 1  
						local nom`i' "`nom`i'' `nom'"
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"			
					}
					local a: list b & lista1
					if (`atmatrix'[`i',`j']!=. &	///
						"`tipo'"=="variable" &  ///
						"`a'"!="") {
						tempvar x`i'`j'
						quietly generate double ///
							`x`i'`j'' ///
							= ///
							`atmatrix'[`i',`j']  ///
								if `touse'
						local cuentas`i' = ///
							`cuentas`i'' + 1  
						local nom`i' ///
							"`nom`i'' `nom'"
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"
					}
					if "`a'"=="" {
						 tempvar x`i'`j'
						 gettoken a1 a2: ///
							b, parse("(") bind
						 gettoken a3 a4: ///
							a2, parse(")") bind
						 if ("`anew'"!="") {
							local a3 "`anew'"
						 }
						 quietly generate ///
							double `x`i'`j'' = ///
							`a3' if `touse'
						 local cuentas`i' = ///
							`cuentas`i'' + 1 
						 local nom`i' ///
							"`nom`i'' `nom'" 
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"
					}
					if (`atmatrix'[`i',`j']==. &	///
						"`tipo'"=="factor") {
						if ("`qat'"=="quieto" & ///
							"`nomprev'"!="`nom'") {
							tempvar x`i'`j'
							quietly generate ///
								double ///
								`x`i'`j'' = ///
								`nom' 
						}
						if ("`qat'"=="movete") {
							tempvar x`i'`j'
							quietly generate ///
								double ///
								`x`i'`j'' = ///
								`var' 
						}
						local cuentas`i' = ///
							`cuentas`i'' + 1 
						local nom`i' "`nom`i'' `nom'" 
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"
					}
					if (`atmatrix'[`i',`j']==. & ///
						"`tipo'"=="variable") {
						tempvar x`i'`j'
						quietly generate double ///
							`x`i'`j'' = ///
						`nom' if `touse'
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"
					}	
					local nomprev "`nom'"
				}	
				local nom`i': list uniq nom`i'
				if (`cuentas`i'' == `krh') {
					matrix `cuentas'[1,`i'] = 1
				}
			}
			quietly generate double `fin'  = . 		
			local j = 1 
			local z = 1 
			forvalues i = 1/`k2' {
				tempvar evar`i'
				quietly generate double `evar`i'' = . 
				local evars "`evars' `evar`i'"
				while (`z' <= `krh' & `posx'[1,`j']!=0) {
					if (`posx'[1,`j'] == `z') {
						local xvarnew: ///
						word `j' of `xvars`i''
						if `dorc'[1,`j']<0 {
							local 	 ///
							newdvars ///
						"`newdvars' `xvarnew'"
						}
						else {
							local 	 ///
							newcvars ///
						 "`newcvars' `xvarnew'"
						}
						local z = `z' + 1
						local j = 0 
					}
					local j = `j' + 1
				}
				local z = 1 
			}
			local kmgl:  list sizeof newd
			local kat:   list sizeof newdvars
			local kdd:   list sizeof dvarsat 
			local knew = `kmgl'*`kdd'
			local i  = 1
			local j  = 1 
			local i2 = 1
			local j2 = 1
			local bd = 0 
			while `j2'<= `kat'  {
				while `i' <= `kmgl' {
					while `j' <=`kdd' {
						local x: word `i' ///
						of `newd_zero'
						local y: word `j2' ///
						of `newdvars'
						local z: ///
							list x & dvarsat
						if ("`z'"=="") {
							local ndlt ///
							"`ndlt' `x'"
						}
						else {
							local ndlt ///
							"`ndlt' `y'"
						}
						local j  = `j' + 1
						local i  = `i' + 1
						local j2 = `j2' + 1
					}
					local j  = 1 
					local j2 = `j' + `bd'
				}
				local j2 = `j2' + `kdd'
				local bd = `bd' + `kdd'
				local j  = 1
				local i  = 1 
			}
			
			// Getting gradient list 
			
			local cdnum  = e(cdnum)
			if (`cdnum'==2) {
				local k0c = 1
			}
			_dydx_listas, dydx(`dydx') continuous(`continuous') ///
				      discrete(`discrete') quieto(`quieto') ///
				      quieto2(`quieto2')
			
			local h       = "`s(h)'"
			local lalista = "`s(lalista)'"
			local taman: list sizeof h
			local ktaman       = `taman'*`kdlf'*`k2'
			local kloop        = `kdlf'*`k2'
			local klong        = `kloop'
			local kgradsen     = `e(kgrad)'*`kloop'
			local rmgrad       = e(kgrad) 
			local cmgrad       = e(kderiv)
			local klong        = `kdlf'*`cmgrad'
			local klong2       = `kdlf'*`rmgrad'
			local katdydx      = `kdlf'*`cmgrad'*`k2'
			matrix `gbase'     = J(1,`rmgrad', 0)
			matrix `mgrad'     = J(`katdydx', 1,  0)
			matrix `mgradse'   = J(`katdydx', `katdydx',  0)
			
			/*
				1. Size of gradient 
				2. Size of marginslist
				3. Number of at() conditions
			*/
			
			local kcnv: list sizeof newcvars
			local nclt ""
			local ncf ""
			forvalues i=1/`kcnv' {
				local x: word `i' of `newcvars'
				local nclt "`nclt' `x'"
				if (int(`i'/`kcm')==`i'/`kcm') {
					local nclt`i'  = ///
						`"`nclt'"'*`kdlf'
					local nclt ""
					local ncf "`ncf' `nclt`i''"
				}
			}
			
			local gradsen ""
			local dserrin ""
			forvalues i=1/`kgradsen' {
				tempvar gm`i'
				quietly generate double `gm`i''  = . 
				local gradsen "`gradsen' `gm`i''"	
			}
			
			forvalues i=1/`cmgrad' {
				tempvar xcm`i'
				quietly generate double `xcm`i'' = . 
				local dserrin "`dserrin' `xcm`i''"
			}
			
			local j   = 1
			local j3  = 1
			local ink = `katdydx'/`kloop'
			matrix `covarmat' = J(1, `katdydx', 0)
			local covarlist ""
			forvalues i=1/`katdydx' {
				tempvar covar`i' 
				matrix `covarmat'[1,`i'] = `j' 
				if (`i'>0) {
					local j = `j' + `ink'
				}
				if (int(`i'/`kloop') ==`i'/`kloop') {
					local j3 = `j3' + 1
					local j  = `j3'
				}
				quietly generate double `covar`i''  = . 
				local covarlist "`covarlist' `covar`i''"
			}
			
			mata: _marginslist_gradient(`e(ke)', 	///
			`kdd', "`e(cvars)'", "`ndlt'", 		///
			"`e(lhs)'", "`e(kest)'", "`mgrad'", 	///
			"`gbase'", "e(pbandwidthgrad)", 	///
			`cdnum', "e(basemat)",	"e(basevals)", 	///
			"e(uniqvals)", `kloop',	`katdydx', 	///
			"`gradsen'", "`e(dvars)'", 		///
			`e(cellnum)', "`covarlist'",		///
			 "`covarmat'", 	`k0c', 1, "`ncf'", 	///
			 "`newwgt'", "`touselk'") 

			quietly generate double `ehat2' = . 
			quietly generate double `rdos'  = . 
			quietly generate double `finse' = .
			quietly generate double `ehat'  = ///
				(`e(lhs)'- `e(yname)')^2
		 
			// Selecting a list of derivatives 
			
			local kmas: list sizeof h
				
			summarize `ehat' if `touse' `wgt', meanonly 
			local N = r(N)
			matrix `beta2' = `mgrad''
			
			local k: list sizeof dlistf
			local mixlist ""
			local dlistfn ""
			forvalues i=1/`k' {
				local mxn: word `i' of `dlistf'
				_ms_parse_parts `mxn'
				local level = r(level)
				local name  = r(name)
				local dlistfn "`dlistfn' `level'.`name'"
			}
	
			forvalues i=1/`k' {
				local mxv: word `i' of `dlistf'
				_ms_parse_parts `mxv'
				local mxbase = r(base)
				local mxname = r(name)
				if (`mxbase'==1) {
					local op = r(op)
					local mixlist ///
						"`mixlist' `op'n.`mxname'"
				}
				else {
					local mixlist "`mixlist' `mxv'"
				}
			}
		
			local bli: list sizeof mixlist
			local kdlfn = `kdlf'*`k2'
			local lmgs  ""
			forvalues i=1/`kmas' {
				local xdydx: word `i' of `h'
				forvalues j=1/`k' {
					local xdlist: word `j' ///
						of `mixlist'
					local lmgs "`lmgs' `xdydx'"
				}
			}
			_select_dydx, lalista(`lalista') h(`h') k(`kloop') ///
			      gradm(`mgrad') ktaman(`ktaman') lmgs2(`lmgs')
		
			matrix `beta0' = r(beta0)		
					
			local bli: list sizeof lmgs
			local j  = 1
			local j1 = 1
			local j2 = 1
			local mytira ""
			forvalues i=1/`kmas' {
				local x: word `i' of `h'
				_ms_parse_parts `x'
				local base = r(base)
				forvalues l = 1/`k' {
					local y: word `l' of `dlistfn'
					_ms_parse_parts `y'
					local na = r(name)
					local le = r(level)
					local j3 = `matst'[1,`j2']
					if (`base'!=1) {
						local b ///
						"`x':`j1'._at#`y'"
						local mytira ///
						"`mytira' `b'"
					}
					else {
						local b "`x':`j1'o._at#"
						local c "`le'o.`na'"
						local mytira ///
						"`mytira' `b'`c'"
					}
					if (`j'<`j3') {
						local j  = `j' + 1
					}
					else {
						local j  = 1
						local j1 = `j1' + 1
					}
					if (`j1'>`k2') {
						local j1 = 1
						local j2 = `j2' + 1
					}
				}
				local j2 = 1 
			}
				
			local ll = 1
			local ul = `k'
		forvalues i=1/`kmas' {
				tempname betaf`i'
				matrix `betaf`i'' = `beta0'[1, `ll'..`ul']
				if (`k2'>1) {
					mata: _np_reorder_atlevels(`k2', ///
						"`matorig'", "`betaf`i''")
				}
				matrix `betaf' = nullmat(`betaf'), `betaf`i''
				local ll = `ll' + `k'
				local ul = `ul' + `k'
			}			
			matrix `beta1' = nullmat(`beta1'), `betaf'
		}
		
		_retirando, anything(`anything')
		matrix `matst2' = r(matstat)

		local klss1 = colsof(`beta1')/(`k2vlt')
		local klss2 = colsof(`matst2')
		local klss4 = `taman'*`k2vlt'
		local klss3 = colsof(`beta1')/(`klss4')
		tempname betatester betatester2 
		local ll = 1 
		local al = 1
		local ul = `klss3'
		local au = `klss3'		
		forvalues i=1/`taman' {
			tempname betat`i'
			forvalues j=1/`k2vlt' {
				tempname betaj`j'
				matrix `betaj`j'' = `beta1'[1, `ll'..`ul']
				local ll = `ll' + `klss1'
				local ul = `ul' + `klss1'
				matrix `betat`i'' = nullmat(`betat`i''), ///
							`betaj`j''
			}
			local al = `al' + `klss3'
			local au = `au' + `klss3' 
			local ll = `al'
			local ul = `au'
		}
	
		forvalues i=1/`taman' {
			mata: _np_reorder_ml_at(`klss2', `k2', `k2vlt', ///
			"`matst2'", "`betat`i''")
			matrix `betatester2' = nullmat(`betatester2'), ///
				`betat`i''
		}
		
		local tirando ""
		local kls: list sizeof anything
		local newdd ""
		forvalues i=1/`kls' {
			local ta: word `i' of `anything'
			cap tab `ta'
			local rc = _rc
			if (`rc') {
				local newdd "`newdd' `ta'"
			}
			else {
				fvexpand i.`ta' if `touselk'
				local pre = r(varlist)
				local newdd "`newdd' `pre'"
			}
		}

		local kld: list sizeof newdd
		local k2dydx: list sizeof h
		local knf = `kls'*`k2vlt'
		
		local attira ""
  	
		_dydx_new_stripe if `touselk', anything(`anything')	///
					       k2(`k2') 		///
					       vlt(`vlt')		///
					       beta(`betatester2')	///
					       h(`h')			///
					       matst(`matst2')		///
					       k2vlt(`k2vlt')		

		local tirita = "`s(stripe)'"
		
		local bli: list sizeof mitira
		local lhs = e(lhs)
		quietly summarize `lhs' if `touse' `wgt'
		local N = r(N)
		
		matrix colnames `betatester2' = `tirita'
		matrix `B0'            = `betatester2'
		return local dlist "`h'"
		return local lista "`tirita'"	
		return local N       = `N'
		return matrix b1 = `betatester2'
		return matrix b0 = `B0'	
	}
end 

program define casesiete, rclass
	syntax [if] [in] [fw pw iw], dydx(string)  atnames(string)	///
				     atmat(string) [over(string)]

	tempvar newwgt
	
	// Weights 
	
	local wgtc = 0 
	if ("`weight'" != "") {
		local wgt "[`weight'`exp']"
		gettoken wgtbc wgtac: exp
		if ("`weight'"=="fweight"|"`weight'"=="iweight") {
			local wgtc = 1
		}
		if (`wgtc'==0) {
			local wgt "[iweight =`newwgt']"
		}
		quietly clonevar `newwgt' = `wgtac'	
	}
	else {
		quietly generate `newwgt' = 1
	}
	
	marksample touse 
	
	if ("`over'"=="") { 
		tempname newbaseval muso muso2 baseval uniqval	///
			 mgrad gbase ehat rdos finse mgradse 	///
			 ehat2 A AT atmatrix atnew cuentas 	///
			 prelim dorc posx rdos	fin gradsen	///
			 covarmat usar beta2 V2 indice 	beta0 	///
			 V0 indice2 matst
			 
		local continuous = "`e(cvars)'"
		local discrete   = "`e(dvars)'"
		local celulas    = e(cellnum)
		local quietoat   `"`e(quieto3)'"'
		local quieto  = "`e(quieto)'"
		local quieto2 = "`e(quieto2)'"
		local rhzero     `"`e(rhzero)'"'
		local yesrhs     = e(yesrhs)
		
		// Dimensions of atmat 
		
		matrix `atmatrix' = `atmat'
		local k2 = rowsof(`atmatrix')
		local kdlf = 1
		local k0c: list sizeof continuous
		
		// Getting at varlist 
		
		local covariates `"`e(covariates)'"'
		local allvars    `"`e(allvars)'"'
		local dvarsat    `"`e(dvars)'"'
		local cvarsat    `"`e(cvars)'"'
		local  y   = e(lhs)
		local stripe ""
		local tipo ""
		local nombre ""
		local namesrhs ""
		local newxvars ""
		local newdvars ""
		local ndlt ""
		local newcvars ""
		local evars ""
		local kcm: list sizeof cvarsat
		local kdm: list sizeof dvarsat
		local rhs = "`e(rhzero)'"
		local krh: list sizeof rhs
		matrix `dorc' = J(1, `krh', 0)
		matrix `posx' = J(1, `krh', 0)
		forvalues i=1/`krh' {
			local a: word `i' of `rhs'
			fvexpand `a' if `touse'
			local b = r(varlist)
			local b: word 1 of `b'
			_ms_parse_parts `b'
			local c = r(name)
			local namesrhs "`namesrhs' `c'"
		}
		local k: list sizeof covariates
		matrix `A'   = J(1, `k', 0)
		forvalues i=1/`k' {
			local a: word `i' of `covariates'
			local stripe "`stripe' `y':`a'"
			_ms_parse_parts `a'
			local b = r(type)
			local c = r(name)
			local tipo "`tipo' `b'"
			local qa: word `i' of `quietoat'
			if ("`qa'"=="quieto") {
				local nombre "`nombre' `c'"
			}
			else {
				local nombre "`nombre' `a'"
			}
		}
		local fordorc: list uniq nombre
		forvalues i=1/`krh' {
			local ft0: word `i' of `fordorc'
			local ftc: list ft0 & cvarsat
			if ("`ftc'"!="") {
				matrix `dorc'[1,`i'] = `i'
			}
			else {
				matrix `dorc'[1,`i'] = -`i'
			}
			forvalues j=1/`krh' {
				local alist: word `i' of `fordorc'
				local blist: word `j' of `allvars'
				local alist2: word `i' of `rhzero'
				if ("`alist'"=="`blist'"| ///
					"`alist2'"=="`blist'") {
					matrix `posx'[1,`i'] = `j' 
				}
			}
		} 
		local j = 1
		matrix colnames `A' = `stripe'
		_ms_at_parse `at', asobserved mat(`A')
		local estad    = r(statlist)
		local atvars   = r(atvars)
		local atvars1 "`atvars'"
		local  stats1  "`estad'"
		forvalues i=1/99 {
			local pct "p`i'"
		}
		local listas "asobserved asbalanced value values"
		local lista1	///
			"mean median min max `pct' zero base `listas'"
		local 0 `",`atnames'"'
		syntax [, at(string) *]
		while `:length local at'{
			_ms_at_parse `at', asobserved mat(`A')
			local estad    = r(statlist)
			local atvars   = r(atvars)
			local atvars`j' "`atvars'"
			local  stats`j'  "`estad'"
			local kgtk = colsof(`A')
			local empiezo "`stats`j''"
			local final ""
			forvalues ppd=1/`kgtk' {
				gettoken empiezo depord: empiezo, ///
					match(paren) bind
				local empiezo = subinstr("`empiezo'"," ","",.) 
				local final "`final' `empiezo'"
				local empiezo "`depord'"
			}
			local final2 ""
			forvalues ppd=1/`kgtk' {
				local ppdx: word `ppd' of `final'
				local interpp: list ppdx & lista1
				if ("`interpp'"=="") {
					local final2 "`final2' (`ppdx')"
				}
				else {
					local final2 "`final2' `ppdx'"
				}
			}
			local stats`j' "`final2'"
			local estad "`stats`j''" 
			local j = `j' + 1
			forvalues i=1/`k' {
				local a: word `i' of `estad'
				if ("`a'"=="("| "`a'"==")") {
					local innew = `i' + 1
					local a: word `innew' of `estad'
					local anew "`a'"
				}
				local b: word `i' of `tipo'
				local c: word `i' of `nombre'
				local inter: list c & atvars
				if ("`a'"=="mean" & "`b'"=="factor" ///
					& "`inter'"!="") {
					 display as error ///
					"incorrect {bf:margins}"  ///
					 " specification after"	  ///
					 " {bf:npregress kernel}"
				di as err "{p 4 4 2}" 
				di as smcl as err "The kernel used for" 
				di as smcl as err " discrete"
				di as smcl as err " covariates is" 
				di as smcl as err " only well defined"
				di as smcl as err "for the original " 
				di as smcl as err " values of the" 
				di as smcl as err " discrete"
				di as smcl as err " covariates."
				di as smcl as err " The kernel is"
				di as smcl as err " degenerate at " 
				di as smcl as err " values other than" 
				di as smcl as err " the original"
				di as smcl as err " discrete levels." 
				di as smcl as err "{p_end}"
					exit 198
				} 
			}
			local 0 `",`options'"'
			syntax [, at(string) *]
		}
		local pct ""
		forvalues i=1/99 {
			local pct "p`i'"
		}
		local listas "asobserved asbalanced value values"
		local lista1 "mean median min max `pct' zero base `listas'"
		matrix `cuentas' = J(1, `k2', 0)

		forvalues i=1/`k2' {
			local cuentas`i' = 0 
			local nom`i' ""
			local xvars`i' ""
			forvalues j=1/`k' {
				if ("`stats`i''"==""){
					local b: word `j' of `stats1'
				}
				else {
					local b: word `j' of `stats`i''
				}
				local var: word `j' of `covariates'
				local qat: word `j' of 	`quietoat'
				_ms_parse_parts `var'
				local nivel   = r(level)
				local tipo    = r(type)
				local nom     = r(name)
				if (`j'==1) {
					local nomprev "."
				}
				if (`atmatrix'[`i',`j']==1 &	///
					"`tipo'"=="factor") {
					tempvar x`i'`j'
					if ("`qat'"=="movete") {
						quietly generate ///
							double `x`i'`j'' = ///
							1 
					}
					else {
						quietly generate ///
							double `x`i'`j'' = ///
						`nivel' 
					}
					local cuentas`i' = `cuentas`i'' + 1 
					local nom`i' "`nom`i'' `nom'" 
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				if (`atmatrix'[`i',`j']==0 & ///
					"`qat'"=="movete") {
					tempvar x`i'`j'
					quietly generate double ///
						`x`i'`j'' = `var' 
					local cuentas`i' = `cuentas`i'' + 1  
					local nom`i' "`nom`i'' `nom'"
					local xvars`i' "`xvars`i'' `x`i'`j''"			
				}
				local a: list b & lista1
				if (`atmatrix'[`i',`j']!=. &	///
					"`tipo'"=="variable" & "`a'"!="") {
					tempvar x`i'`j'
					quietly generate double `x`i'`j'' ///
						= `atmatrix'[`i',`j']  ///
							if `touse'
					local cuentas`i' = `cuentas`i'' + 1  
					local nom`i' "`nom`i'' `nom'"
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				if "`a'"=="" {
					 tempvar x`i'`j'
					 gettoken a1 a2: b, parse("(") bind
					 gettoken a3 a4: a2, parse(")") bind
					 if ("`anew'"!="") {
						local a3 "`anew'"
					 }
					 quietly generate ///
						double `x`i'`j'' = ///
						`a3' if `touse'
					 local cuentas`i' = `cuentas`i'' + 1 
					 local nom`i' "`nom`i'' `nom'" 
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				if (`atmatrix'[`i',`j']==. &	///
					"`tipo'"=="factor") {
					if ("`qat'"=="quieto" & ///
						"`nomprev'"!="`nom'") {
						tempvar x`i'`j'
						quietly generate ///
							double `x`i'`j'' = ///
							`nom' 
					}
					if ("`qat'"=="movete") {
						tempvar x`i'`j'
						quietly generate ///
							double `x`i'`j'' = ///
							`var' 
					}
					local cuentas`i' = `cuentas`i'' + 1 
					local nom`i' "`nom`i'' `nom'" 
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}
				if (`atmatrix'[`i',`j']==. & ///
					"`tipo'"=="variable") {
					tempvar x`i'`j'
					quietly generate double `x`i'`j'' = ///
					`nom' if `touse'
					local xvars`i' "`xvars`i'' `x`i'`j''"
				}	
				local nomprev "`nom'"
			} 	
			local nom`i': list uniq nom`i'
			if (`cuentas`i'' == `krh') {
				matrix `cuentas'[1,`i'] = 1
			}
		}

		quietly generate double `fin'  = . 		
		local j = 1 
		local z = 1 
		forvalues i = 1/`k2' {
			tempvar evar`i'
			quietly generate double `evar`i'' = . 
			local evars "`evars' `evar`i'"
			while (`z' <= `krh'  & `posx'[1,`j']!=0) {
				if (`posx'[1,`j'] == `z') {
					local xvarnew: word `j'	///
					 of `xvars`i''
					if `dorc'[1,`j']<0 {
						local newdvars	///
						 "`newdvars' `xvarnew'"
					}
					else {
						local newcvars	///
						 "`newcvars' `xvarnew'"
					}
					local z = `z' + 1
					local j = 0 
				}
				local j = `j' + 1
			}
			local z = 1 
		}
		
		local kmgl:  list sizeof newd
		local kat:   list sizeof newdvars
		local kdd:   list sizeof dvarsat 
		local knew = `kmgl'*`kdd'
		local i  = 1
		local j  = 1 
		local i2 = 1
		local j2 = 1
		local bd = 0 
	
		// Getting gradient list 
		
		local cdnum  = e(cdnum)
		if (`cdnum'==2) {
			local k0c = 1
		}
		_dydx_listas, dydx(`dydx') continuous(`continuous')	///
			      discrete(`discrete') quieto(`quieto')	///
			      quieto2(`quieto2')
		
		local h       = "`s(h)'"
		local lalista = "`s(lalista)'"
		
		local taman: list sizeof h
		local ktaman       = `taman'*`kdlf'*`k2'
		local kloop        = `kdlf'*`k2'
		local klong        = `kloop'
		local kgradsen     = `e(kgrad)'*`kloop'
		local rmgrad       = e(kgrad) 
		local cmgrad       = e(kderiv)
		if (`cdnum'==1) {
			local rmgrad    = `kcm'
			local cmgrad    = `kcm'
			local kgradsen  = `kcm'*`kloop'
		}
		local klong        = `kdlf'*`cmgrad'
		local klong2       = `kdlf'*`rmgrad'
		local katdydx      = `kdlf'*`cmgrad'*`k2'
		matrix `gbase'     = J(1,`rmgrad', 0)
		matrix `mgrad'     = J(`katdydx', 1,  0)
		matrix `mgradse'   = J(`katdydx', `katdydx',  0)
			
		local gradsen ""
		forvalues i=1/`kgradsen' {
			tempvar gm`i'
			quietly generate double `gm`i''  = . 
			local gradsen "`gradsen' `gm`i''"	
		}
		
		forvalues i=1/`cmgrad' {
			tempvar xcm`i'
			quietly generate double `xcm`i'' = . 
			local dserrin "`dserrin' `xcm`i''"
		}
		
		local j   = 1
		local j3  = 1
		local ink = `katdydx'/`kloop'
		matrix `covarmat' = J(1, `katdydx', 0)
		forvalues i=1/`katdydx' {
			tempvar covar`i' 
			matrix `covarmat'[1,`i'] = `j' 
			if (`i'>0) {
				local j = `j' + `ink'
			}
			if (int(`i'/`kloop') ==`i'/`kloop') {
				local j3 = `j3' + 1
				local j  = `j3'
			}
			quietly generate double `covar`i''  = . 
			local covarlist "`covarlist' `covar`i''"
		}

		mata: _marginslist_gradient(`e(ke)', `kdd', 	///
		"`e(cvars)'", "`newdvars'", "`e(lhs)'", 	///
		"`e(kest)'", "`mgrad'", "`gbase'", 		///
		"e(pbandwidthgrad)", `cdnum', "e(basemat)",	///
		 "e(basevals)", "e(uniqvals)", `kloop', 	///
		 `katdydx', "`gradsen'", "`e(dvars)'", 		///
		 `e(cellnum)', "`covarlist'", "`covarmat'",	///
		 `k0c', 1, "`newcvars'", "`newwgt'", "`touse'") 

		quietly generate double `ehat2' = . 
		quietly generate double `rdos'  = . 
		quietly generate double `finse' = .
		quietly generate double `ehat'  = ///
					(`e(lhs)' -  `e(yname)')^2
		
		// Selecting a list of derivatives 
		
		local kmas: list sizeof h
		summarize `ehat' if `touse' `wgt', meanonly 
		local N = r(N)

		local kdlfn = `kdlf'*`k2'
		local lmgs  ""
		forvalues i=1/`kmas' {
			local xdydx: word `i' of `h'
			forvalues j=1/`k2' {
				local lmgs "`lmgs' `xdydx'"
			}
		}

		_select_dydx, lalista(`lalista') h(`h') k(`kloop') ///
			      gradm(`mgrad') ktaman(`ktaman') lmgs2(`lmgs')
		
		matrix `beta0' = r(beta0)

		local mytira ""
		forvalues i=1/`kmas' {
			local x: word `i' of `h'
			_ms_parse_parts `x'
			local base = r(base)
			forvalues j=1/`k2' {
				if (`base'!=1) {
					local b "`x':`j'._at"
					local mytira "`mytira' `b'"
				}
				else {
					local b "`x':`j'o._at"
					local mytira "`mytira' `b'"
				}
			}
		}
		if (`k2'==1) {
			local mytira "`h'"
		}
		
		/*mata: _pedazos_mat("`V0'", "`V2'", "`indice'",	///
			"`indice'")*/
		
		return local dlist "`h'"
		return local lista "`mytira'"	
		return local N       = `N'
		return matrix b1 = `beta0'
		*return matrix V1 = `V0'		
		return scalar bfinf = 1
	}
	else {	
		tempname beta1 V1 matindex atmatrix atmatrix0 ///
			 covar_np betazero

		// Getting overlist 
		
		_parse_over if `touse', over(`over')
		local k2vlt = s(k2vlt)
		local vlt   = `"`s(vlt)'"'
		
		local listvarsf ""
		matrix `atmatrix0' = `atmat'
		local katov = rowsof(`atmatrix0')
		local kfatov = `katov'/`k2vlt'
		local jkatov = `k2vlt' 
		forvalues i=1/`kfatov' {
			matrix `atmatrix' = ///
			nullmat(`atmatrix') \ ///
			`atmatrix0'[`jkatov', 1..colsof(`atmatrix0')]
			local jkatov = `jkatov' + `k2vlt' 
		}	
		
		forvalues lk=1/`k2vlt' {		
			tempname newbaseval muso muso2 baseval	///
			uniqval	mgrad gbase ehat rdos finse 	///
			mgradse ehat2 A AT atnew 		///
			cuentas prelim dorc posx rdos fin 	///
			gradsen	covarmat usar beta2 V2 indice 	///
			beta0 V0 indice2 matst
			
			tempvar touselk
			local condvlt: word `lk' of `vlt'
			quietly generate `touselk' = `condvlt'*`touse'	 
			local continuous = "`e(cvars)'"
			local discrete   = "`e(dvars)'"
			local celulas    = e(cellnum)
			local quietoat   `"`e(quieto3)'"'
			local quieto  = "`e(quieto)'"
			local quieto2 = "`e(quieto2)'"
			local rhzero     `"`e(rhzero)'"'
			local yesrhs     = e(yesrhs)
			
			// Dimensions of atmat 
			
			local k2 = rowsof(`atmatrix')
			local kdlf = 1
			local k0c: list sizeof continuous
			
			// Getting at varlist 
			
			local covariates `"`e(covariates)'"'
			local allvars    `"`e(allvars)'"'
			local dvarsat    `"`e(dvars)'"'
			local cvarsat    `"`e(cvars)'"'
			local  y   = e(lhs)
			local stripe ""
			local tipo ""
			local nombre ""
			local namesrhs ""
			local newxvars ""
			local newdvars ""
			local ndlt ""
			local newcvars ""
			local evars ""
			local kcm: list sizeof cvarsat
			local kdm: list sizeof dvarsat
			local rhs = "`e(rhzero)'"
			local krh: list sizeof rhs
			matrix `dorc' = J(1, `krh', 0)
			matrix `posx' = J(1, `krh', 0)
			forvalues i=1/`krh' {
				local a: word `i' of `rhs'
				fvexpand `a' if `touse'
				local b = r(varlist)
				local b: word 1 of `b'
				_ms_parse_parts `b'
				local c = r(name)
				local namesrhs "`namesrhs' `c'"
			}
			local k: list sizeof covariates
			matrix `A'   = J(1, `k', 0)
			forvalues i=1/`k' {
				local a: word `i' of `covariates'
				local stripe "`stripe' `y':`a'"
				_ms_parse_parts `a'
				local b = r(type)
				local c = r(name)
				local tipo "`tipo' `b'"
				local qa: word `i' of `quietoat'
				if ("`qa'"=="quieto") {
					local nombre "`nombre' `c'"
				}
				else {
					local nombre "`nombre' `a'"
				}
			}
			local fordorc: list uniq nombre
			forvalues i=1/`krh' {
				local ft0: word `i' of `fordorc'
				local ftc: list ft0 & cvarsat
				if ("`ftc'"!="") {
					matrix `dorc'[1,`i'] = `i'
				}
				else {
					matrix `dorc'[1,`i'] = -`i'
				}
				forvalues j=1/`krh' {
					local alist: word `i' ///
						of `fordorc'
					local blist: word `j' ///
						of `allvars'
					local alist2: word `i' of `rhzero'
					if ("`alist'"=="`blist'"| ///
						"`alist2'"=="`blist'") {
						matrix `posx'[1,`i'] ///
							= `j' 
					}
				}
			} 
			local j = 1
			matrix colnames `A' = `stripe'
			_ms_at_parse `at', asobserved mat(`A')
			local estad    = r(statlist)
			local atvars   = r(atvars)
			local atvars1 "`atvars'"
			local  stats1  "`estad'"
			forvalues i=1/99 {
				local pct "p`i'"
			}
			local listas "asobserved asbalanced value values"
			local lista1	///
				"mean median min max `pct' zero base `listas'"
			local 0 `",`atnames'"'
			syntax [, at(string) *]
			while `:length local at'{
				_ms_at_parse `at', asobserved mat(`A')
				local estad    = r(statlist)
				local atvars   = r(atvars)
				local atvars`j' "`atvars'"
				local  stats`j'  "`estad'"
				local kgtk = colsof(`A')
				local empiezo "`stats`j''"
				local final ""
				forvalues ppd=1/`kgtk' {
					gettoken empiezo depord: empiezo, ///
						match(paren) bind
					local empiezo =	///
						subinstr("`empiezo'"," ","",.) 
					local final "`final' `empiezo'"
					local empiezo "`depord'"
				}
				local final2 ""
				forvalues ppd=1/`kgtk' {
					local ppdx: word `ppd' of `final'
					local interpp: list ppdx & lista1
					if ("`interpp'"=="") {
						local final2 "`final2' (`ppdx')"
					}
					else {
						local final2 "`final2' `ppdx'"
					}
				}
				local stats`j' "`final2'"
				local estad "`stats`j''" 
				local j = `j' + 1
				forvalues i=1/`k' {
					local a: word `i' of `estad'
					if ("`a'"=="("| "`a'"==")") {
						local innew = `i' + 1
						local a: word `innew' of `estad'
						local anew "`a'"
					}
					local b: word `i' of `tipo'
					local c: word `i' of `nombre'
					local inter: list c & atvars
					if ("`a'"=="mean" & ///
						"`b'"=="factor" ///
						& "`inter'"!="") {
				display as error 		///
				"incorrect {bf:margins}"  	///
				" specification after"	  	///
				" {bf:npregress kernel}"
				di as err "{p 4 4 2}" 
				di as smcl as err "The kernel used for" 
				di as smcl as err " discrete"
				di as smcl as err " covariates is" 
				di as smcl as err " only well defined"
				di as smcl as err "for the original " 
				di as smcl as err " values of the" 
				di as smcl as err " discrete"
				di as smcl as err " covariates."
				di as smcl as err " The kernel is"
				di as smcl as err " degenerate at " 
				di as smcl as err " values other than" 
				di as smcl as err " the original"
				di as smcl as err " discrete levels." 
				di as smcl as err "{p_end}"
						exit 198
					} 
				}
				local 0 `",`options'"'
				syntax [, at(string) *]
			}
			local pct ""
			forvalues i=1/99 {
				local pct "p`i'"
			}
			local listas ///
			"asobserved asbalanced value values"
			local lista1 ///
			"mean median min max `pct' zero base `listas'"
			matrix `cuentas' = J(1, `k2', 0)
			forvalues i=1/`k2' {
				local cuentas`i' = 0 
				local nom`i' ""
				local xvars`i' ""
				forvalues j=1/`k' {
					if ("`stats`i''"==""){
						local b: word `j' ///
							of `stats1'
					}
					else {
						local b: word `j' ///
							of `stats`i''
					}
					local var: word `j' of `covariates'
					local qat: word `j' of 	`quietoat'
					_ms_parse_parts `var'
					local nivel   = r(level)
					local tipo    = r(type)
					local nom     = r(name)
					if (`j'==1) {
						local nomprev "."
					}
					if (`atmatrix'[`i',`j']==1 &	///
						"`tipo'"=="factor") {
						tempvar x`i'`j'
						if ("`qat'"=="movete") {
							quietly generate ///
							double `x`i'`j'' = ///
								1 
						}
						else {
							quietly generate ///
							double `x`i'`j'' = ///
							`nivel' 
						}
						local cuentas`i' = ///
							`cuentas`i'' + 1 
						local nom`i' "`nom`i'' `nom'" 
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"
					}
					if (`atmatrix'[`i',`j']==0 & ///
						"`qat'"=="movete") {
						tempvar x`i'`j'
						quietly generate double ///
							`x`i'`j'' = `var' 
						local cuentas`i' = ///
							`cuentas`i'' + 1  
						local nom`i' "`nom`i'' `nom'"
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"			
					}
					if (`atmatrix'[`i',`j']!=. &	///
						"`tipo'"=="variable" &  ///
						"`a'"!="") {
						tempvar x`i'`j'
						quietly generate ///
							double `x`i'`j'' ///
							= ///
						`atmatrix'[`i',`j']  ///
								if `touse'
						local cuentas`i' = ///
						`cuentas`i'' + 1  
						local nom`i' "`nom`i'' `nom'"
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"
					}
					local a: list b & lista1
					if "`a'"=="" {
						 tempvar x`i'`j'
						 gettoken a1 a2: b, ///
							parse("(") bind
						 gettoken a3 a4: a2, ///
							parse(")") bind
						 if ("`anew'"!="") {
							local a3 "`anew'"
						 }
						 quietly generate ///
							double `x`i'`j'' = ///
							`a3' if `touse'
						 local cuentas`i' = ///
							`cuentas`i'' + 1 
						 local nom`i' "`nom`i'' `nom'" 
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"
					}
					if (`atmatrix'[`i',`j']==. &	///
						"`tipo'"=="factor") {
						if ("`qat'"=="quieto" & ///
							"`nomprev'"!="`nom'") {
							tempvar x`i'`j'
							quietly generate ///
								double ///
								`x`i'`j'' = ///
								`nom' 
						}
						if ("`qat'"=="movete") {
							tempvar x`i'`j'
							quietly generate ///
								double ///
								`x`i'`j'' = ///
								`var' 
						}
						local cuentas`i' = ///
							`cuentas`i'' + 1 
						local nom`i' "`nom`i'' `nom'" 
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"
					}
					if (`atmatrix'[`i',`j']==. & ///
						"`tipo'"=="variable") {
						tempvar x`i'`j'
						quietly generate double ///
							`x`i'`j'' = ///
						`nom' if `touse'
						local xvars`i' ///
							"`xvars`i'' `x`i'`j''"
					}	
					local nomprev "`nom'"
				} 		
				local nom`i': list uniq nom`i'
				if (`cuentas`i'' == `krh') {
					matrix `cuentas'[1,`i'] = 1
				}
			}
			quietly generate double `fin'  = . 		
			local j = 1 
			local z = 1 
 
			forvalues i = 1/`k2' {
				tempvar evar`i'
				quietly generate double `evar`i'' = . 
				local evars "`evars' `evar`i'"
				while (`z' <= `krh' &  ///
						 `posx'[1,`j']!=0) {
					if (`posx'[1,`j'] == `z' ) {
						local xvarnew: ///
						 word `j' of `xvars`i''
						if `dorc'[1,`j']<0 {
						   local newdvars  ///
						 "`newdvars' `xvarnew'"
						}
						else {
							local ///
							newcvars ///
						"`newcvars' `xvarnew'"
						}
						local z = `z' + 1
						local j = 0 
					}
					local j = `j' + 1
				}
				local z = 1 
			}

			local kmgl:  list sizeof newd
			local kat:   list sizeof newdvars
			local kdd:   list sizeof dvarsat 
			local knew = `kmgl'*`kdd'
			local i  = 1
			local j  = 1 
			local i2 = 1
			local j2 = 1
			local bd = 0 

			
			// Getting gradient list 
			
			local cdnum  = e(cdnum)
			if (`cdnum'==2) {
				local k0c = 1
			}
			_dydx_listas, dydx(`dydx') continuous(`continuous') ///
				      discrete(`discrete') quieto(`quieto') ///
				      quieto2(`quieto2')
			
			local h       = "`s(h)'"
			local lalista = "`s(lalista)'"	
					
			local taman: list sizeof h
			local ktaman       = `taman'*`kdlf'*`k2'
			local kloop        = `kdlf'*`k2'
			local klong        = `kloop'
			local kgradsen     = `e(kgrad)'*`kloop'
			local rmgrad       = e(kgrad) 
			local cmgrad       = e(kderiv)
			if (`cdnum'==1) {
				local rmgrad    = `kcm'
				local cmgrad    = `kcm'
				local kgradsen  = `kcm'*`kloop'
			}
			local klong        = `kdlf'*`cmgrad'
			local klong2       = `kdlf'*`rmgrad'
			local katdydx      = `kdlf'*`cmgrad'*`k2'
			matrix `gbase'     = J(1,`rmgrad', 0)
			matrix `mgrad'     = J(`katdydx', 1,  0)
			matrix `mgradse'   = J(`katdydx', `katdydx',  0)
			
			local covarlist ""
			local gradsen ""
			forvalues i=1/`kgradsen' {
				tempvar gm`i'
				quietly generate double `gm`i''  = . 
				local gradsen "`gradsen' `gm`i''"	
			}
			
			local dserrin ""
			forvalues i=1/`cmgrad' {
				tempvar xcm`i'
				quietly generate double `xcm`i'' = . 
				local dserrin "`dserrin' `xcm`i''"
			}
			
			local j   = 1
			local j3  = 1
			local ink = `katdydx'/`kloop'
			matrix `covarmat' = J(1, `katdydx', 0)
			forvalues i=1/`katdydx' {
				tempvar covar`i' 
				matrix `covarmat'[1,`i'] = `j' 
				if (`i'>0) {
					local j = `j' + `ink'
				}
				if (int(`i'/`kloop') ==`i'/`kloop') {
					local j3 = `j3' + 1
					local j  = `j3'
				}
				quietly generate double `covar`i''  = . 
				local covarlist "`covarlist' `covar`i''"
			}

			local blin: list sizeof ncf
			local blan: list sizeof covarlist

			mata: _marginslist_gradient(`e(ke)', 	///
			`kdd', "`e(cvars)'", "`newdvars'", 	///
			"`e(lhs)'", "`e(kest)'", "`mgrad'", 	///
			"`gbase'", "e(pbandwidthgrad)", 	///
			`cdnum', "e(basemat)", "e(basevals)", 	///
			"e(uniqvals)", `kloop', `katdydx', 	///
			"`gradsen'", "`e(dvars)'", 		///
			`e(cellnum)', "`covarlist'", 		///
			"`covarmat'", `k0c', 1, "`newcvars'", 	///
			"`newwgt'", "`touselk'") 

			quietly generate double `ehat2' = . 
			quietly generate double `rdos'  = . 
			quietly generate double `finse' = .
			quietly generate double `ehat'  = ///
					(`e(lhs)' -  `e(yname)')^2
			
			// Selecting a list of derivatives 
			
			local kmas: list sizeof h
		
			summarize `ehat' if `touse' `wgt', meanonly 
			local N = r(N)
		
			local bli: list sizeof mixlist
			local kdlfn = `kdlf'*`k2'
			local lmgs  ""
			forvalues i=1/`kmas' {
				local xdydx: word `i' of `h'
				forvalues j=1/`k2' {
					local lmgs "`lmgs' `xdydx'"
				}
			}
			
			_select_dydx, lalista(`lalista') h(`h') 	///
				      k(`kloop') gradm(`mgrad') 	///
				      ktaman(`ktaman') lmgs2(`lmgs')
		
			matrix `beta0' = r(beta0)
			
			local bli: list sizeof lmgs
			local mytira ""
			forvalues i=1/`kmas' {
				local x: word `i' of `h'
				_ms_parse_parts `x'
				local base = r(base)
				forvalues j=1/`k2' {
					if (`base'!=1) {
						local b "`x':`j'._at"
						local mytira ///
							"`mytira' `b'"
					}
					else {
						local b "`x':`j'o._at"
						local mytira ///
							"`mytira' `b'"
					}
				}
			}
			if (`k2'==1) {
				local mytira "`h'"
			}
			
			matrix `beta1' = nullmat(`beta1') \ `beta0'
		}	
		matrix `beta1' = vec(`beta1')'
		local tirando ""
		local ati ""
		local k2dydx: list sizeof h
		local trdydx ""
		forvalues q = 1/`k2dydx' {
			local dydn: word `q' of `h'
			local trdydx "`dydn':"
			forvalues i=1/`kfatov' {
				if (`kfatov'>1) {
					local ati "`i'._at#"
				}
				forvalues j=1/`k2vlt' {
					local a: word `j' of `vlt'
					local tirando ///
					"`tirando' `trdydx'`ati'`a'"
				}
			
			}
		}

		matrix colnames `beta1' = `tirando'
		local bla: list sizeof tirando
		local lhs = e(lhs)
		quietly summarize `lhs' if `touse' `wgt'
		local N = r(N)
		matrix `betazero' = `beta1'
		return local dlist "`h'"
		return local lista "`tirando'"	
		return local N       = `N'
		return matrix b1 = `beta1'	
		return matrix b0 = `betazero'	
		return scalar bfinf = 1
	}
end 

program define _lista_yesrhs, sclass 
	syntax [anything(name=listad)][if][in], [quieto(string) dq(string) *]
	marksample touse 
	local kyrhs: list sizeof listad
	forvalues i=1/`kyrhs' {
		local xkyrhs: word `i' of `listad'
		local posyrhs: word `i' of `quieto'
		if ("`dq'"=="") {
			if ("`posyrhs'"=="movete") {
				local lalista ///
				"`lalista' `xkyrhs'"
				local lalista2 "`lalista2' `xkyrhs' `xkyrhs'"
				local quietico "`quietico' zero uno"
				local quietico2 "`quietico2' movete"
			}
			else {
				fvexpand i.(`xkyrhs') if `touse'
				local lalista0 = r(varlist)
				local expande: list sizeof lalista0
				local lalista ///
					"`lalista' `lalista0'"	
				local lalista2 "`lalista2' `lalista0'"	
				local trans = "uno " * `expande'
				local trans2 = "quieto " * `expande'
				local quietico = "`quietico' `trans'"	
				local quietico2 "`quietico2' `trans2'"		
			}
		}
		else {
			local x3 "movete=`xkyrhs'"
			local x4: list x3 & dq		
			if ("`x4'"!="") {
				local lalista ///
				"`lalista' `xkyrhs'"
				local lalista2 "`lalista2' `xkyrhs' `xkyrhs'"
				local quietico "`quietico' zero uno"
				local quietico2 "`quietico2' movete"	
			}
			else {
				fvexpand i.(`xkyrhs') if `touse'
				local lalista0 = r(varlist)
				local expande: list sizeof lalista0
				local lalista ///
					"`lalista' `lalista0'"	
				local lalista2 "`lalista' `lalista0'"	
				local trans = "uno " * `expande'
				local quietico "`quietico' `trans'"
				local quietico2 "`quietico2' quieto"				
			}		
		}
	}
	sreturn local lyesrhs "`lalista'"
	sreturn local lyesrhsrep "`lalista2'"
	sreturn local quietico "`quietico'"
	sreturn local quietico2 "`quietico2'"
end  

program define _at_mat_reshuffle, rclass 
	syntax, atmats(string) stripe(string)

	tempname matriz matf
	
	matrix `matriz' = `atmats'
	local stripe0: colnames `matriz'
	local k: list sizeof stripe0
	matrix `matf' = J(1, `k', .)
	forvalues i=1/`k' {
		local x: word `i' of `stripe'
		forvalues j=1/`k' {
			local y: word `j' of `stripe0'	
			if ("`x'"=="`y'") {
				matrix `matf'[1,`i'] = `j'
			}	
		}
	}
end

program define _retirando, rclass
	syntax [if] [in], [anything(string)]
	
	marksample touse 
	tempname matst2
	local jx = 1 
	local k: list sizeof anything
	forvalues i=1/`k' {
		local _xvar: word `i' of `anything'
		_ms_parse_parts `_xvar'
		local nzero0 = r(name)
		local inter: list nzero0 & ninter
		if ("`inter'"=="") {
			local name`i' "`_xvar'"
		}
		forvalues j=1/`k' {
			local _yvar: word `j' of `anything'
			_ms_parse_parts `_yvar'
			local nzero1 = r(name)
			if ("`nzero0'"=="`nzero1'" & ///
				"`_xvar'"!="`_yvar'" & "`inter'"=="") {
				local name`i' "`name`i'' `_yvar'"
				local ninter "`ninter' `nzero0'"
			}
		}
		if ("`name`i''"!="") {
			local names`jx' "`name`i''"
			return local names`jx' "`names`jx''"
			local jx = `jx' + 1
		}
		
	}
	
	local bla = `jx' - 1 
	forvalues i=1/`bla' {
		local xbla: list sizeof names`i'
		if (`xbla'==1) {
			fvexpand i.`names`i'' if `touse'
			local xblapre = r(varlist)
			local xbla: list sizeof xblapre
		}
		matrix `matst2' = nullmat(`matst2'), `xbla'
	}
	return matrix matstat = `matst2'
	return local jx = `bla'
end

program define jacum, rclass
	syntax, [dlist(string)]	
	local _name ""
	local k: list sizeof dlist 
	forvalues i=1/`k' {
		local _dlx: word `i' of `dlist'
		_ms_parse_parts `_dlx'
		local _name0 = r(name)
		local level0 = r(level)
		local jacum = 0 
		forvalues j = 1/`k' {
			local _dly: word `j' of `dlist'
			_ms_parse_parts `_dly'
			local _name1 = r(name)
			local level1 = r(level)
			if ("`_name0'"=="`_name1'" ///
				& `level1'< `level0') {
				local _name "`_name' `_dly' `_dlx'"
				local jacum = `jacum' + 1
			}
			if (`jacum'==0 & `j'==`k') {
				local _name "`_name' `_dlx'"
				local jacum = 0 
			}
		}
	}
	
	local _name: list uniq _name
	return local dname "`_name'"
end

program define _np_has_contrast, rclass
	syntax [if] [in], [vars(string)]
	marksample touse 
	fvexpand `vars' if `touse'
	local newvars = r(varlist)
	local counter 0 
	local i = 1 
	local k: list sizeof newvars
	local interact = 0
	while (`counter'==0) {
		local x: word `i' of `newvars'
		_ms_parse_parts `x'
		local tipo = r(type)
		if ("`tipo'"=="interaction") {
			local counter = 1
			local interact = 1 
		}
		if (`i'==`k') {
			local counter = 1 
		}
		local i = `i' + 1
	}
	return local varlist "`newvars'"
	return local interact = `interact'
end

program define _contrast_uno, rclass
	syntax [if][in], anything(string) [over(string)]
	
	marksample touse 

	_strip_contrast `anything' 
	local variables = r(varlist)
	local dvars     = e(dvars)
	local cvars     = e(cvars)

	fvexpand `variables' if `touse'
	local newvars = r(varlist)
	local k: list sizeof newvars
	local k1: list sizeof dvars
	local jd = 1 

	forvalues i=1/`k' {
		tempvar cv`i'
		quietly generate `cv`i'' = . 
		local x: word `i' of `newvars'
		_ms_parse_parts `x'
		local tipo = r(type)
		local dvars`i' "`dvars'"
		if ("`tipo'"=="interaction") {
			local k2 = r(k_names)
			forvalues j=1/`k2' {
				local z = r(name`j')
				local nivel = r(level`j')
				local nom`i' "`nom`i'' `z'"
				forvalues l=1/`k1' {
					local y: word `l' of `dvars`i''
					if ("`y'"=="`z'") {
						tempvar xnew`j'`l' 
						generate `xnew`j'`l'' = ///
							`nivel'
						local newdlist`i' ///
						"`newdlist`i'' `xnew`j'`l''"
						local newdlist_`j' ///
						"`newdlist_`j'' `xnew`j'`l''"
					}
					else {
						local newdlist`i' ///
						"`newdlist`i'' `y'"
						local newdlist_`j' ///
							"`newdlist_`j'' `y'"
					}
				}
				local dvars`i' "`newdlist_`j''"
				local newdlist_`j' ""
			}
		}
		else {
			local base  = r(base)
			local value = r(level)
			local nomxx = r(name)
			local nomx: list x & dvars
			if ("`nomx'"!="") {
				local other: list dvars - nomx
			}
			else {
				local other: list dvars - nomxx			
			}
			local other: list other - x
			tempvar xf`jd'
			if ("`nomx'"=="") {
				quietly generate `xf`jd'' = `value'
				local names`jd' "`nomxx' `other'"
			}
			else {
				quietly generate `xf`jd'' = 1	
				local names`jd' "`nomx' `other'"	
			}
			local dnames`jd' "`xf`jd'' `other'"
			local dvarst ""
			forvalues w1=1/`k1' {
				local xw1: word `w1' of `dvars'
				local inter: list xw1 & dnames`jd'
				local menos: list dnames`jd' - dvars 
				if ("`inter'"=="") {
					local dvarst "`dvarst' `menos'"
				}
				else {
					local dvarst "`dvarst' `inter'"
				}
			}
			local dvars`i' "`dvarst'"
			local jd = `jd' + 1
		} 
		local newdvars "`newdvars' `dvars`i''"
		local covarnoms "`covarnoms' `cv`i''"
	}
	
	tempvar newwgt fin 
	tempname beta prelim vmatrix b1 b0
	quietly generate `newwgt'   = 1
	quietly generate `fin' = . 
	local newcvars = "`cvars' "*`k'
	local kcm: list sizeof cvars
	local kdm: list sizeof dvars
	mata: _kernel_regression_at(`e(ke)', `e(cdnum)', `kcm', `kdm',	///
		`k', "`newcvars'", "`newdvars'", `"`e(cvars)'"',	///
		`"`e(dvars)'"', "`e(lhs)'", "`prelim'", "`fin'", 	///
		"`vmatrix'", "`e(kest)'", `e(cellnum)', "`covarnoms'",	///
		"`newwgt'", 0, "`touse'")
	matrix `b1' = `prelim'
	matrix `b0' = `prelim'
	return matrix b0 = `b0'
	return matrix b1 = `b1'
end 

program define _contrast_cuatro, rclass
	syntax [if][in], anything(string) dydx(string)
	
	marksample touse 
	
	// getting dydx list 
	
	local quieto  = "`e(quieto)'"
	local quieto2 = "`e(quieto2)'"
	local yesrhs  = e(yesrhs)
	local continuous = "`e(cvars)'"
	local discrete   = "`e(dvars)'"
	local cdnum  = e(cdnum)
	
	_dydx_listas, dydx(`dydx') continuous(`continuous') ///
		      discrete(`discrete') quieto(`quieto') ///
		      quieto2(`quieto2')
	
	local h       = "`s(h)'"
	local lalista = "`s(lalista)'"	
	
	local taman: list sizeof h
	
	// marginslist creation 
	
	_strip_contrast `anything' 
	local variables = r(varlist)
	local dvars     = e(dvars)
	local cvars     = e(cvars)

	fvexpand `variables' if `touse'
	local newvars = r(varlist)
	local k: list sizeof newvars
	local k1: list sizeof dvars
	local kcv: list sizeof cvars 
	local jd = 1 
	if (`cdnum'==2) {
		local kcv = 1
	}
	local ktaman  = `taman'*`k'

	forvalues i=1/`k' {
		tempvar cv`i'
		quietly generate `cv`i'' = . 
		local x: word `i' of `newvars'
		_ms_parse_parts `x'
		local tipo = r(type)
		local dvars`i' "`dvars'"
		if ("`tipo'"=="interaction") {
			local k2 = r(k_names)
			forvalues j=1/`k2' {
				local z = r(name`j')
				local nivel = r(level`j')
				local nom`i' "`nom`i'' `z'"
				forvalues l=1/`k1' {
					local y: word `l' of `dvars`i''
					if ("`y'"=="`z'") {
						tempvar xnew`j'`l' 
						generate `xnew`j'`l'' = ///
							`nivel'
						local newdlist`i' ///
						"`newdlist`i'' `xnew`j'`l''"
						local newdlist_`j' ///
						"`newdlist_`j'' `xnew`j'`l''"
					}
					else {
						local newdlist`i' ///
						"`newdlist`i'' `y'"
						local newdlist_`j' ///
							"`newdlist_`j'' `y'"
					}
				}
				local dvars`i' "`newdlist_`j''"
				local newdlist_`j' ""
			}
		}
		else {
			local base  = r(base)
			local value = r(level)
			local nomxx = r(name)
			local nomx: list x & dvars
			if ("`nomx'"!="") {
				local other: list dvars - nomx
			}
			else {
				local other: list dvars - nomxx			
			}
			local other: list other - x
			tempvar xf`jd'
			if ("`nomx'"=="") {
				quietly generate `xf`jd'' = `value'
				local names`jd' "`nomxx' `other'"
			}
			else {
				quietly generate `xf`jd'' = 1	
				local names`jd' "`nomx' `other'"	
			}
			local dnames`jd' "`xf`jd'' `other'"
			local dvarst ""
			forvalues w1=1/`k1' {
				local xw1: word `w1' of `dvars'
				local inter: list xw1 & dnames`jd'
				local menos: list dnames`jd' - dvars 
				if ("`inter'"=="") {
					local dvarst "`dvarst' `menos'"
				}
				else {
					local dvarst "`dvarst' `inter'"
				}
			}
			local dvars`i' "`dvarst'"
			local jd = `jd' + 1
		} 
		local newdvars "`newdvars' `dvars`i''"
		local covarnoms "`covarnoms' `cv`i''"
	}
	
	// Ready to compute gradients 
	
	tempname mgrad gbase covarmat usar beta2 indice beta0 indice2 b1 b0
	tempvar newwgt
	
	generate `newwgt' = 1 
	local rmgrad      = e(kgrad) 
	local cmgrad      = e(kderiv)
	local klong       = `k'*`cmgrad'
	local klong2      = `k'*`rmgrad'
	matrix `mgrad'    = J(`klong', 1,  0)
	matrix `gbase'    = J(1,`rmgrad', 0)
	matrix `covarmat' = J(1, `klong', 0) 
	forvalues i=1/`klong2' {
		tempvar gm`i'
		quietly generate double `gm`i''  = . 
		local gradsen "`gradsen' `gm`i''"
	}
	forvalues i=1/`klong' {
		tempvar covar`i' 
		quietly generate `covar`i''  = . 
		local covarlist "`covarlist' `covar`i''"
	} 
	mata: _marginslist_gradient(`e(ke)', `k1', "`e(cvars)'",	///
	"`newdvars'", "`e(lhs)'", "`e(kest)'", "`mgrad'", "`gbase'",	///
	"e(pbandwidthgrad)", `e(cdnum)', "e(basemat)", "e(basevals)",	///
	"e(uniqvals)", `k', `klong', "`gradsen'", "`e(dvars)'", 0,	///
	"`covarlist'", "`covarmat'", `kcv', 0, "`e(cvars)'",		///
	"`newwgt'", "`touse'") 
	
	// Selecting a list of derivatives 
	
	forvalues i=1/`taman' {
		local xdydx: word `i' of `h'
		forvalues j=1/`k' {
			local lmgs2 "`lmgs2' `xdydx'"
		}
	}
	
	_select_dydx, lalista(`lalista') h(`h') k(`k') ///
		      gradm(`mgrad') ktaman(`ktaman') lmgs2(`lmgs2')
		
	matrix `beta0' = r(beta0)
	
	_tira_marginslist, newvars(`newvars') overnot
	
	local tira0 = "`s(tirando)'"
	local ktira: list sizeof tira0
	
	forvalues i=1/`taman' {
		local x: word `i' of `h'
		forvalue j=1/`ktira' {
			local y: word `j' of `tira0'
			local tirando "`tirando' `x':`y'"
		}
	}
	
	quietly count if `touse' 
	local N = r(N)
	
	return local N = `N'
	return local dlist "`h'"
	return local lista "`tirando'"
	matrix `b1' = `beta0'
	matrix `b0' = `beta0'
	return matrix b0 = `b0'
	return matrix b1 = `b1'

end

program define _contrast_cinco, rclass
	syntax [if] [in], atnames(string) atmat(string)		///
			  anything(string)
	
	marksample touse 
	
	tempname newbaseval muso muso2 baseval uniqval 	///
	mgrad gbase ehat rdos finse mgradse 	///
	ehat2 A AT atmatrix atnew cuentas 	///
	prelim dorc posx rdos fin gradsen 	///
	vmatrix b1 V1 matorig newwgt b0 b1
	
	// Getting discrete list 
	
	_strip_contrast `anything' 
	local variables = r(varlist)
	local dvars     = e(dvars)
	local cvars     = e(cvars)

	fvexpand `variables' if `touse'
	local newvars = r(varlist)
	local k: list sizeof newvars
	local k1: list sizeof dvars
	local jd = 1 

	forvalues i=1/`k' {
		tempvar cv`i'
		quietly generate `cv`i'' = . 
		local x: word `i' of `newvars'
		_ms_parse_parts `x'
		local tipo = r(type)
		local dvars`i' "`dvars'"
		if ("`tipo'"=="interaction") {
			local k2 = r(k_names)
			forvalues j=1/`k2' {
				local z = r(name`j')
				local nivel = r(level`j')
				local nom`i' "`nom`i'' `z'"
				forvalues l=1/`k1' {
					local y: word `l' of `dvars`i''
					if ("`y'"=="`z'") {
						tempvar xnew`j'`l' 
						generate `xnew`j'`l'' = ///
							`nivel'
						local newdlist`i' ///
						"`newdlist`i'' `xnew`j'`l''"
						local newdlist_`j' ///
						"`newdlist_`j'' `xnew`j'`l''"
					}
					else {
						local newdlist`i' ///
						"`newdlist`i'' `y'"
						local newdlist_`j' ///
							"`newdlist_`j'' `y'"
					}
				}
				local dvars`i' "`newdlist_`j''"
				local newdlist_`j' ""
			}
		}
		else {
			local base  = r(base)
			local value = r(level)
			local nomxx = r(name)
			local nomx: list x & dvars
			if ("`nomx'"!="") {
				local other: list dvars - nomx
			}
			else {
				local other: list dvars - nomxx			
			}
			local other: list other - x
			tempvar xf`jd'
			if ("`nomx'"=="") {
				quietly generate `xf`jd'' = `value'
				local names`jd' "`nomxx' `other'"
			}
			else {
				quietly generate `xf`jd'' = 1	
				local names`jd' "`nomx' `other'"	
			}
			local dnames`jd' "`xf`jd'' `other'"
			local dvarst ""
			forvalues w1=1/`k1' {
				local xw1: word `w1' of `dvars'
				local inter: list xw1 & dnames`jd'
				local menos: list dnames`jd' - dvars 
				if ("`inter'"=="") {
					local dvarst "`dvarst' `menos'"
				}
				else {
					local dvarst "`dvarst' `inter'"
				}
			}
			local dvars`i' "`dvarst'"
			local jd = `jd' + 1
		} 
		local newdvars "`newdvars' `dvars`i''"
		local covarnoms "`covarnoms' `cv`i''"
	}
	
	local newd "`newdvars'"
	local newd_zero "`newd'"
	local kdlistk = `k'
	
	// Getting at varlist 
	
	local covariates `"`e(covariates)'"'
	local allvars    `"`e(allvars)'"'
	local dvarsat    `"`e(dvars)'"'
	local cvarsat    `"`e(cvars)'"'
	local quietoat   `"`e(quieto3)'"'
	local  y   = e(lhs)
	local stripe ""
	local tipo ""
	local nombre ""
	local namesrhs ""
	local newxvars ""
	local newdvars ""
	local ndlt ""
	local newcvars ""
	local evars ""
	local kcm: list sizeof cvarsat
	local kdm: list sizeof dvarsat
	local rhs = "`e(rhs)'"
	local krh: list sizeof rhs
	matrix `dorc' = J(1, `krh', 0)
	matrix `posx' = J(1, `krh', 0)
	forvalues i=1/`krh' {
		local a: word `i' of `rhs'
		fvexpand `a' if `touse'
		local b = r(varlist)
		local b: word 1 of `b'
		_ms_parse_parts `b'
		local c = r(name)
		local namesrhs "`namesrhs' `c'"
	}
	local k: list sizeof covariates
	matrix `atmatrix' = `atmat'
	local k2 = rowsof(`atmatrix')
	matrix `A'   = J(1, `k', 0)
	forvalues i=1/`k' {
		local a: word `i' of `covariates'
		local stripe "`stripe' `y':`a'"
		_ms_parse_parts `a'
		local b   = r(type)
		local c   = r(name)
		local mtf = r(level)
		local tipo "`tipo' `b'"
		local qa: word `i' of `quietoat'
		if ("`qa'"=="quieto") {
			local nombre "`nombre' `c'"
		}
		else {
			local nombre "`nombre' `a'"
		}
	}
	local fordorc: list uniq nombre
	forvalues i=1/`krh' {
		local ft0: word `i' of `fordorc'
		local ftc: list ft0 & cvarsat
		if ("`ftc'"!="") {
			matrix `dorc'[1,`i'] = `i'
		}
		else {
			matrix `dorc'[1,`i'] = -`i'
		}
		forvalues j=1/`krh' {
			local alist: word `i' of `fordorc'
			local alist2: word `i' of `rhzero'
			local blist: word `j' of `allvars'
			if ("`alist'"=="`blist'"| ///
				"`alist2'"=="`blist'") {
				matrix `posx'[1,`i'] = `j' 
			}
		}
	} 
	local j = 1
	tempvar nospace
	matrix colnames `A' = `stripe'
	_ms_at_parse `at', asobserved mat(`A')
	local estad    = r(statlist)
	local atvars   = r(atvars)
	local atvars1 "`atvars'"
	local  stats1  "`estad'"
	forvalues i=1/99 {
		local pct "p`i'"
	}
	local listas "asobserved asbalanced value values"
	local lista1	///
		"mean median min max `pct' zero base `listas'"
	local 0 `",`atnames'"'
	syntax [, at(string) *]
	while `:length local at'{
		_ms_at_parse `at', asobserved mat(`A')
		local estad    = r(statlist)
		local atvars   = r(atvars)
		local atvars`j' `"`atvars'"'
		local  stats`j'  `"`estad'"'
		local kgtk = colsof(`A')
		local empiezo "`stats`j''"
		local final ""
		forvalues ppd=1/`kgtk' {
			gettoken empiezo depord: empiezo, match(paren) bind
			local empiezo = subinstr("`empiezo'"," ","",.) 
			local final "`final' `empiezo'"
			local empiezo "`depord'"
		}
		local final2 ""
		forvalues ppd=1/`kgtk' {
			local ppdx: word `ppd' of `final'
			local interpp: list ppdx & lista1
			if ("`interpp'"=="") {
				local final2 "`final2' (`ppdx')"
			}
			else {
				local final2 "`final2' `ppdx'"
			}
		}
		local stats`j' "`final2'"
		local estad "`stats`j''" 
		local j = `j' + 1
		forvalues i=1/`k' {
			local a: word `i' of `estad'
			if ("`a'"=="("| "`a'"==")") {
				local innew = `i' + 1
				local a: word `innew' of `estad'
				local anew "`a'"
			}
			local b: word `i' of `tipo'
			local c: word `i' of `nombre'
			local inter: list c & atvars
			if ("`a'"=="mean" & ///
				"`b'"=="factor" & ///
				"`inter'"!="") {
				 display as error ///
				"incorrect {bf:margins}"  ///
				 " specification after"	  ///
				 " {bf:npregress kernel}"
			di as err "{p 4 4 2}" 
			di as smcl as err "The kernel used for" 
			di as smcl as err " discrete"
			di as smcl as err " covariates is" 
			di as smcl as err " only well defined"
			di as smcl as err "for the original " 
			di as smcl as err " values of the" 
			di as smcl as err " discrete"
			di as smcl as err " covariates."
			di as smcl as err " The kernel is"
			di as smcl as err " degenerate at " 
			di as smcl as err " values other than" 
			di as smcl as err " the original"
			di as smcl as err " discrete levels." 
			di as smcl as err "{p_end}"
			exit 198
			} 
		}
		
		local 0 `",`options'"'
		syntax [, at(string) *]
	}
	local pct ""
	forvalues i=1/99 {
		local pct "p`i'"
	}
	local listas "asobserved asbalanced value values"
	local lista1 ///
		"mean median min max `pct' zero base `listas'"
	matrix `cuentas' = J(1, `k2', 0)
	forvalues i=1/`k2' {
		local cuentas`i' = 0 
		local nom`i' ""
		local xvars`i' ""
		forvalues j=1/`k' {
			if (`"`stats`i''"'==""){
				local b: word `j' of `stats1'
			}
			else {
				local b: word `j' of `stats`i''
			}
			local var: word `j' of `covariates'
			local qat: word `j' of 	`quietoat'
			_ms_parse_parts `var'
			local nivel   = r(level)
			local tipo    = r(type)
			local nom     = r(name)
			if ("`qat'"=="movete") {
				local nom "`var'"
			}
			if (`j'==1) {
				local nomprev "."
			}
			if (`atmatrix'[`i',`j']==1 &	///
				"`tipo'"=="factor") {
				tempvar x`i'`j'
				if ("`qat'"=="movete") {
					quietly generate ///
						double `x`i'`j'' = ///
						1 
				}
				else {
					quietly generate ///
						double `x`i'`j'' = ///
					`nivel' 
				}
				local cuentas`i' = `cuentas`i'' + 1 
				local nom`i' "`nom`i'' `nom'" 
				local xvars`i' "`xvars`i'' `x`i'`j''"
			}
			if (`atmatrix'[`i',`j']==0 & ///
				"`qat'"=="movete") {
				tempvar x`i'`j'
				quietly generate double `x`i'`j'' ///
					= `var' 
				local cuentas`i' = `cuentas`i'' + 1  
				local nom`i' "`nom`i'' `nom'"
				local xvars`i' "`xvars`i'' `x`i'`j''"			
			}
			local a: list b & lista1
			if (`atmatrix'[`i',`j']!=. &	///
				"`tipo'"=="variable" & "`a'"!="") {
				tempvar x`i'`j'
				quietly generate double `x`i'`j'' ///
					= `atmatrix'[`i',`j']  ///
						if `touse'
				local cuentas`i' = `cuentas`i'' + 1  
				local nom`i' "`nom`i'' `nom'"
				local xvars`i' "`xvars`i'' `x`i'`j''"
			}
			if "`a'"=="" {
				tempvar x`i'`j'
				gettoken a1 a2: b, parse("(")
				gettoken a3 a4: a2, parse(")")
				if ("`anew'"!="") {
					local a3 "`anew'"
				}
				qui generate double 	///
					`x`i'`j'' = `a3'
				local cuentas`i' = 	///
					`cuentas`i'' + 1 
				local nom`i' "`nom`i'' `nom'" 
				local xvars`i' "`xvars`i'' `x`i'`j''"
			}
			if (`atmatrix'[`i',`j']==. &	///
				"`tipo'"=="factor") {
				if ("`qat'"=="quieto" & ///
					"`nomprev'"!="`nom'") {
					tempvar x`i'`j'
					quietly generate double ///
						`x`i'`j'' = ///
						`nom' 
				}
				if ("`qat'"=="movete") {
					tempvar x`i'`j'
					quietly generate double ///
						`x`i'`j'' = ///
						`var' 
				}
				local cuentas`i' = `cuentas`i'' + 1 
				local nom`i' "`nom`i'' `nom'" 
				local xvars`i' "`xvars`i'' `x`i'`j''"
			}
			if (`atmatrix'[`i',`j']==. & ///
				"`tipo'"=="variable") {
				tempvar x`i'`j'
				quietly generate double `x`i'`j'' = ///
				`nom' if `touse'
				local xvars`i' "`xvars`i'' `x`i'`j''"
			}
			local nomprev "`nom'"
		}	
		local nom`i': list uniq nom`i'
		if (`cuentas`i'' == `krh') {
			matrix `cuentas'[1,`i'] = 1
		}
	}

	quietly generate double `fin'  = . 
	quietly generate `newwgt'   = 1
		
	local j = 1 
	local z = 1 
	forvalues i = 1/`k2' {
		tempvar evar`i'
		quietly generate double `evar`i'' = . 
		local evars "`evars' `evar`i'"
		while (`z' <= `krh' & `posx'[1,`j']!=0) {
			if (`posx'[1,`j'] == `z' ) {
				local xvarnew: 	///
					word `j' of `xvars`i''
				if `dorc'[1,`j']<0 {
					local newdvars	///
					 "`newdvars' `xvarnew'"
				}
				else {
					local newcvars	///
					 "`newcvars' `xvarnew'"
				}
				local z = `z' + 1
				local j = 0 
			}
			local j = `j' + 1
		}
		local z = 1 
	}
	
	local kmgl:  list sizeof newd
	local kat:   list sizeof newdvars
	local kdd:   list sizeof dvarsat 
	local knew = `kmgl'*`kdd'
	local i  = 1
	local j  = 1 
	local i2 = 1
	local j2 = 1
	local bd = 0
	while `j2'<= `kat'  {
		while `i' <= `kmgl' {
			while `j' <=`kdd' {
				local x: word `i' of `newd_zero'
				local y: word `j2' of `newdvars'
				local z: list x & dvarsat
				if ("`z'"=="") {
					local ndlt "`ndlt' `x'"
				}
				else {
					local ndlt "`ndlt' `y'"
				}
				local j  = `j' + 1
				local i  = `i' + 1
				local j2 = `j2' + 1
			}
			local j  = 1 
			local j2 = `j' + `bd'
		}
		local j2 = `j2' + `kdd'
		local bd = `bd' + `kdd'
		local j  = 1
		local i  = 1 
	} 

	local tester: list sizeof ndlt
	local kfin: list sizeof ndlt
	local kcnv: list sizeof newcvars
	local nclt ""
	local ncf ""
	local kdlf = `kdlistk'
	forvalues i=1/`kcnv' {
		local x: word `i' of `newcvars'
		local nclt "`nclt' `x'"
		if (int(`i'/`kcm')==`i'/`kcm') {
			local nclt`i'  = `"`nclt'"'*`kdlf'
			local nclt ""
			local ncf "`ncf' `nclt`i''"
		}
	}
	local kloop = `kdlf'*`k2'
	local klong = `kloop'
	local kgradsen = `e(kgrad)'*`kloop'
	matrix `mgrad'     = J(`kloop', 1,  0)
	local rmgrad       = e(kgrad) 
	matrix `gbase'     = J(1,`rmgrad', 0)
	matrix `mgradse'   = J(`kloop', `kloop',  0)
	local gradsen ""
	forvalues i=1/`kgradsen' {
		tempvar gm`i'
		quietly generate double `gm`i''  = . 
		local gradsen "`gradsen' `gm`i''"	
	}

	local kfin: list sizeof ndlt		
	local covarnoms ""
	
	forvalues i=1/`kloop' {
		tempvar covar`i'
		quietly generate `covar`i'' = .
		local covarnoms "`covarnoms' `covar`i''"
	}

	mata: _kernel_regression_at(`e(ke)', 		///
	`e(cdnum)', `kcm', `kdm',	`kloop', 	///
	"`ncf'", "`ndlt'", `"`e(cvars)'"',		///
	`"`e(dvars)'"', "`e(lhs)'", "`prelim'", 	///
	"`fin'", "`vmatrix'", "`e(kest)'", 		///
	`e(cellnum)', "`covarnoms'", "`newwgt'", 	///
	0, "`touse'")
	
	_matorig_contrast, dvarscont(`newvars')
	matrix `matorig' = r(matorig)
	
	if (`k2'>1) {
		mata: _np_reorder_atlevels(`k2', "`matorig'",	///
			"`prelim'")
	}
	
	matrix `b1' = `prelim'
	matrix `b0' = `prelim'
	quietly count if `touse'
	local N = r(N)
	return local N = `N'
	return matrix b1 = `b1'
	return matrix b0 = `b0'	
end 

program define _contrast_seis, rclass
	syntax [if] [in], atnames(string) atmat(string)		///
			  anything(string) dydx(string) 	///
			  [over(string)]
			  
	marksample touse 
	
	tempname newbaseval muso muso2 baseval uniqval 	///
	mgrad gbase ehat rdos finse mgradse ehat2 A AT	///
	atmatrix atnew cuentas prelim dorc posx rdos 	///
	fin gradsen covarmat usar beta2 V2 indice beta0	///
	V0 indice2 matst bkro selectkro betat betatest	///
	beta2new matorig matst2 betaf vmatrix b1 V1 	///
	matorig newwgt b0 b1
	
	// Getting discrete list 
	
	_strip_contrast `anything' 
	local variables = r(varlist)
	local dvars     = e(dvars)
	local cvars     = e(cvars)

	fvexpand `variables' if `touse'
	local newvars = r(varlist)
	local k: list sizeof newvars
	local k1: list sizeof dvars
	local jd = 1 

	forvalues i=1/`k' {
		tempvar cv`i'
		quietly generate `cv`i'' = . 
		local x: word `i' of `newvars'
		_ms_parse_parts `x'
		local tipo = r(type)
		local dvars`i' "`dvars'"
		if ("`tipo'"=="interaction") {
			local k2 = r(k_names)
			forvalues j=1/`k2' {
				local z = r(name`j')
				local nivel = r(level`j')
				local nom`i' "`nom`i'' `z'"
				forvalues l=1/`k1' {
					local y: word `l' of `dvars`i''
					if ("`y'"=="`z'") {
						tempvar xnew`j'`l' 
						generate `xnew`j'`l'' = ///
							`nivel'
						local newdlist`i' ///
						"`newdlist`i'' `xnew`j'`l''"
						local newdlist_`j' ///
						"`newdlist_`j'' `xnew`j'`l''"
					}
					else {
						local newdlist`i' ///
						"`newdlist`i'' `y'"
						local newdlist_`j' ///
							"`newdlist_`j'' `y'"
					}
				}
				local dvars`i' "`newdlist_`j''"
				local newdlist_`j' ""
			}
		}
		else {
			local base  = r(base)
			local value = r(level)
			local nomxx = r(name)
			local nomx: list x & dvars
			if ("`nomx'"!="") {
				local other: list dvars - nomx
			}
			else {
				local other: list dvars - nomxx			
			}
			local other: list other - x
			tempvar xf`jd'
			if ("`nomx'"=="") {
				quietly generate `xf`jd'' = `value'
				local names`jd' "`nomxx' `other'"
			}
			else {
				quietly generate `xf`jd'' = 1	
				local names`jd' "`nomx' `other'"	
			}
			local dnames`jd' "`xf`jd'' `other'"
			local dvarst ""
			forvalues w1=1/`k1' {
				local xw1: word `w1' of `dvars'
				local inter: list xw1 & dnames`jd'
				local menos: list dnames`jd' - dvars 
				if ("`inter'"=="") {
					local dvarst "`dvarst' `menos'"
				}
				else {
					local dvarst "`dvarst' `inter'"
				}
			}
			local dvars`i' "`dvarst'"
			local jd = `jd' + 1
		} 
		local newdvars "`newdvars' `dvars`i''"
		local covarnoms "`covarnoms' `cv`i''"
	}
	
	local newd "`newdvars'"
	local newd_zero "`newd'"
	local kdlistk = `k'
	
	// Getting at varlist 
	
	local covariates `"`e(covariates)'"'
	local allvars    `"`e(allvars)'"'
	local dvarsat    `"`e(dvars)'"'
	local cvarsat    `"`e(cvars)'"'
	local quietoat   `"`e(quieto3)'"'
	local  y   = e(lhs)
	local stripe ""
	local tipo ""
	local nombre ""
	local namesrhs ""
	local newxvars ""
	local newdvars ""
	local ndlt ""
	local newcvars ""
	local evars ""
	local kcm: list sizeof cvarsat
	local kdm: list sizeof dvarsat
	local rhs = "`e(rhs)'"
	local krh: list sizeof rhs
	matrix `dorc' = J(1, `krh', 0)
	matrix `posx' = J(1, `krh', 0)
	forvalues i=1/`krh' {
		local a: word `i' of `rhs'
		fvexpand `a' if `touse'
		local b = r(varlist)
		local b: word 1 of `b'
		_ms_parse_parts `b'
		local c = r(name)
		local namesrhs "`namesrhs' `c'"
	}
	local k: list sizeof covariates
	matrix `atmatrix' = `atmat'
	local k2 = rowsof(`atmatrix')
	matrix `A'   = J(1, `k', 0)
	forvalues i=1/`k' {
		local a: word `i' of `covariates'
		local stripe "`stripe' `y':`a'"
		_ms_parse_parts `a'
		local b   = r(type)
		local c   = r(name)
		local mtf = r(level)
		local tipo "`tipo' `b'"
		local qa: word `i' of `quietoat'
		if ("`qa'"=="quieto") {
			local nombre "`nombre' `c'"
		}
		else {
			local nombre "`nombre' `a'"
		}
	}
	local fordorc: list uniq nombre
	forvalues i=1/`krh' {
		local ft0: word `i' of `fordorc'
		local ftc: list ft0 & cvarsat
		if ("`ftc'"!="") {
			matrix `dorc'[1,`i'] = `i'
		}
		else {
			matrix `dorc'[1,`i'] = -`i'
		}
		forvalues j=1/`krh' {
			local alist: word `i' of `fordorc'
			local alist2: word `i' of `rhzero'
			local blist: word `j' of `allvars'
			if ("`alist'"=="`blist'"| ///
				"`alist2'"=="`blist'") {
				matrix `posx'[1,`i'] = `j' 
			}
		}
	} 
	local j = 1
	tempvar nospace
	matrix colnames `A' = `stripe'
	_ms_at_parse `at', asobserved mat(`A')
	local estad    = r(statlist)
	local atvars   = r(atvars)
	local atvars1 "`atvars'"
	local  stats1  "`estad'"
	forvalues i=1/99 {
		local pct "p`i'"
	}
	local listas "asobserved asbalanced value values"
	local lista1	///
		"mean median min max `pct' zero base `listas'"
	local 0 `",`atnames'"'
	syntax [, at(string) *]
	while `:length local at'{
		_ms_at_parse `at', asobserved mat(`A')
		local estad    = r(statlist)
		local atvars   = r(atvars)
		local atvars`j' `"`atvars'"'
		local  stats`j'  `"`estad'"'
		local kgtk = colsof(`A')
		local empiezo "`stats`j''"
		local final ""
		forvalues ppd=1/`kgtk' {
			gettoken empiezo depord: empiezo, match(paren) bind
			local empiezo = subinstr("`empiezo'"," ","",.) 
			local final "`final' `empiezo'"
			local empiezo "`depord'"
		}
		local final2 ""
		forvalues ppd=1/`kgtk' {
			local ppdx: word `ppd' of `final'
			local interpp: list ppdx & lista1
			if ("`interpp'"=="") {
				local final2 "`final2' (`ppdx')"
			}
			else {
				local final2 "`final2' `ppdx'"
			}
		}
		local stats`j' "`final2'"
		local estad "`stats`j''" 
		local j = `j' + 1
		forvalues i=1/`k' {
			local a: word `i' of `estad'
			if ("`a'"=="("| "`a'"==")") {
				local innew = `i' + 1
				local a: word `innew' of `estad'
				local anew "`a'"
			}
			local b: word `i' of `tipo'
			local c: word `i' of `nombre'
			local inter: list c & atvars
			if ("`a'"=="mean" & ///
				"`b'"=="factor" & ///
				"`inter'"!="") {
				 display as error ///
				"incorrect {bf:margins}"  ///
				 " specification after"	  ///
				 " {bf:npregress kernel}"
			di as err "{p 4 4 2}" 
			di as smcl as err "The kernel used for" 
			di as smcl as err " discrete"
			di as smcl as err " covariates is" 
			di as smcl as err " only well defined"
			di as smcl as err "for the original " 
			di as smcl as err " values of the" 
			di as smcl as err " discrete"
			di as smcl as err " covariates."
			di as smcl as err " The kernel is"
			di as smcl as err " degenerate at " 
			di as smcl as err " values other than" 
			di as smcl as err " the original"
			di as smcl as err " discrete levels." 
			di as smcl as err "{p_end}"
			exit 198
			} 
		}
		
		local 0 `",`options'"'
		syntax [, at(string) *]
	}
	local pct ""
	forvalues i=1/99 {
		local pct "p`i'"
	}
	local listas "asobserved asbalanced value values"
	local lista1 ///
		"mean median min max `pct' zero base `listas'"
	matrix `cuentas' = J(1, `k2', 0)
	forvalues i=1/`k2' {
		local cuentas`i' = 0 
		local nom`i' ""
		local xvars`i' ""
		forvalues j=1/`k' {
			if (`"`stats`i''"'==""){
				local b: word `j' of `stats1'
			}
			else {
				local b: word `j' of `stats`i''
			}
			local var: word `j' of `covariates'
			local qat: word `j' of 	`quietoat'
			_ms_parse_parts `var'
			local nivel   = r(level)
			local tipo    = r(type)
			local nom     = r(name)
			if ("`qat'"=="movete") {
				local nom "`var'"
			}
			if (`j'==1) {
				local nomprev "."
			}
			if (`atmatrix'[`i',`j']==1 &	///
				"`tipo'"=="factor") {
				tempvar x`i'`j'
				if ("`qat'"=="movete") {
					quietly generate ///
						double `x`i'`j'' = ///
						1 
				}
				else {
					quietly generate ///
						double `x`i'`j'' = ///
					`nivel' 
				}
				local cuentas`i' = `cuentas`i'' + 1 
				local nom`i' "`nom`i'' `nom'" 
				local xvars`i' "`xvars`i'' `x`i'`j''"
			}
			if (`atmatrix'[`i',`j']==0 & ///
				"`qat'"=="movete") {
				tempvar x`i'`j'
				quietly generate double `x`i'`j'' ///
					= `var' 
				local cuentas`i' = `cuentas`i'' + 1  
				local nom`i' "`nom`i'' `nom'"
				local xvars`i' "`xvars`i'' `x`i'`j''"			
			}
			local a: list b & lista1
			if (`atmatrix'[`i',`j']!=. &	///
				"`tipo'"=="variable" & "`a'"!="") {
				tempvar x`i'`j'
				quietly generate double `x`i'`j'' ///
					= `atmatrix'[`i',`j']  ///
						if `touse'
				local cuentas`i' = `cuentas`i'' + 1  
				local nom`i' "`nom`i'' `nom'"
				local xvars`i' "`xvars`i'' `x`i'`j''"
			}
			if "`a'"=="" {
				tempvar x`i'`j'
				gettoken a1 a2: b, parse("(")
				gettoken a3 a4: a2, parse(")")
				if ("`anew'"!="") {
					local a3 "`anew'"
				}
				qui generate double 	///
					`x`i'`j'' = `a3'
				local cuentas`i' = 	///
					`cuentas`i'' + 1 
				local nom`i' "`nom`i'' `nom'" 
				local xvars`i' "`xvars`i'' `x`i'`j''"
			}
			if (`atmatrix'[`i',`j']==. &	///
				"`tipo'"=="factor") {
				if ("`qat'"=="quieto" & ///
					"`nomprev'"!="`nom'") {
					tempvar x`i'`j'
					quietly generate double ///
						`x`i'`j'' = ///
						`nom' 
				}
				if ("`qat'"=="movete") {
					tempvar x`i'`j'
					quietly generate double ///
						`x`i'`j'' = ///
						`var' 
				}
				local cuentas`i' = `cuentas`i'' + 1 
				local nom`i' "`nom`i'' `nom'" 
				local xvars`i' "`xvars`i'' `x`i'`j''"
			}
			if (`atmatrix'[`i',`j']==. & ///
				"`tipo'"=="variable") {
				tempvar x`i'`j'
				quietly generate double `x`i'`j'' = ///
				`nom' if `touse'
				local xvars`i' "`xvars`i'' `x`i'`j''"
			}
			local nomprev "`nom'"
		}	
		local nom`i': list uniq nom`i'
		if (`cuentas`i'' == `krh') {
			matrix `cuentas'[1,`i'] = 1
		}
	}

	quietly generate double `fin'  = . 
	quietly generate `newwgt'   = 1

	local j = 1 
	local z = 1 
	forvalues i = 1/`k2' {
		tempvar evar`i'
		quietly generate double `evar`i'' = . 
		local evars "`evars' `evar`i'"
		while (`z' <= `krh' & `posx'[1,`j']!=0) {
			if (`posx'[1,`j'] == `z' ) {
				local xvarnew: 	///
					word `j' of `xvars`i''
				if `dorc'[1,`j']<0 {
					local newdvars	///
					 "`newdvars' `xvarnew'"
				}
				else {
					local newcvars	///
					 "`newcvars' `xvarnew'"
				}
				local z = `z' + 1
				local j = 0 
			}
			local j = `j' + 1
		}
		local z = 1 
	}
	
	local kmgl:  list sizeof newd
	local kat:   list sizeof newdvars
	local kdd:   list sizeof dvarsat 
	local knew = `kmgl'*`kdd'
	local i  = 1
	local j  = 1 
	local i2 = 1
	local j2 = 1
	local bd = 0
	while `j2'<= `kat'  {
		while `i' <= `kmgl' {
			while `j' <=`kdd' {
				local x: word `i' of `newd_zero'
				local y: word `j2' of `newdvars'
				local z: list x & dvarsat
				if ("`z'"=="") {
					local ndlt "`ndlt' `x'"
				}
				else {
					local ndlt "`ndlt' `y'"
				}
				local j  = `j' + 1
				local i  = `i' + 1
				local j2 = `j2' + 1
			}
			local j  = 1 
			local j2 = `j' + `bd'
		}
		local j2 = `j2' + `kdd'
		local bd = `bd' + `kdd'
		local j  = 1
		local i  = 1 
	}
	
	// Getting gradient list 
	
	local continuous = "`e(cvars)'"
	local discrete   = "`e(dvars)'"
	local k0c: list sizeof continuous
	
	local cdnum  = e(cdnum)
	if (`cdnum'==2) {
		local kc0 = 1
	}
	_dydx_listas, dydx(`dydx') continuous(`continuous') ///
		      discrete(`discrete') quieto(`quieto') ///
		      quieto2(`quieto2')
	
	local h       = "`s(h)'"
	local lalista = "`s(lalista)'"	
	
	local kdlf = `kdlistk'	
	local taman: list sizeof h
	local ktaman       = `taman'*`kdlf'*`k2'
	local kloop        = `kdlf'*`k2'
	local klong        = `kloop'
	local kgradsen     = `e(kgrad)'*`kloop'
	local rmgrad       = e(kgrad) 
	local cmgrad       = e(kderiv)
	local klong        = `kdlf'*`cmgrad'
	local klong2       = `kdlf'*`rmgrad'
	local katdydx      = `kdlf'*`cmgrad'*`k2'
	matrix `gbase'     = J(1,`rmgrad', 0)
	matrix `mgrad'     = J(`katdydx', 1,  0)
	matrix `mgradse'   = J(`katdydx', `katdydx',  0)
	
	/*
		1. Size of gradient 
		2. Size of marginslist
		3. Number of at() conditions
	*/
	
	local kcnv: list sizeof newcvars
	local nclt ""
	local ncf ""
	forvalues i=1/`kcnv' {
		local x: word `i' of `newcvars'
		local nclt "`nclt' `x'"
		if (int(`i'/`kcm')==`i'/`kcm') {
			local nclt`i'  = `"`nclt'"'*`kdlf'
			local nclt ""
			local ncf "`ncf' `nclt`i''"
		}
	}
	
	local gradsen ""
	forvalues i=1/`kgradsen' {
		tempvar gm`i'
		quietly generate double `gm`i''  = . 
		local gradsen "`gradsen' `gm`i''"	
	}
	
	forvalues i=1/`cmgrad' {
		tempvar xcm`i'
		quietly generate double `xcm`i'' = . 
		local dserrin "`dserrin' `xcm`i''"
	}
	
	local j   = 1
	local j3  = 1
	local ink = `katdydx'/`kloop'
	matrix `covarmat' = J(1, `katdydx', 0)
	forvalues i=1/`katdydx' {
		tempvar covar`i' 
		matrix `covarmat'[1,`i'] = `j' 
		if (`i'>0) {
			local j = `j' + `ink'
		}
		if (int(`i'/`kloop') ==`i'/`kloop') {
			local j3 = `j3' + 1
			local j  = `j3'
		}
		quietly generate double `covar`i''  = . 
		local covarlist "`covarlist' `covar`i''"
	}

	mata: _marginslist_gradient(`e(ke)', `kdd', 	///
	"`e(cvars)'", "`ndlt'", "`e(lhs)'", 		///
	"`e(kest)'", "`mgrad'", "`gbase'", 		///
	"e(pbandwidthgrad)", `cdnum', "e(basemat)",	///
	"e(basevals)", "e(uniqvals)", `kloop',		///
	`katdydx', "`gradsen'", "`e(dvars)'", 		///
	`e(cellnum)', "`covarlist'", "`covarmat'", 	///
	`k0c', 1, "`ncf'", "`newwgt'", "`touse'") 
 
	// Selecting a list of derivatives 
	

	local kmas: list sizeof h
	local ksel = `k2'*`kdlistk'
	
	forvalues i=1/`taman' {
		local xdydx: word `i' of `h'
		forvalues j=1/`ksel' {
			local lmgs2 "`lmgs2' `xdydx'"
		}
	}
	
	_select_dydx, lalista(`lalista') h(`h') k(`ksel') ///
		      gradm(`mgrad') ktaman(`ktaman') lmgs2(`lmgs2')
		
	matrix `beta0' = r(beta0)

	_matorig_contrast, dvarscont(`newvars')
	matrix `matorig' = r(matorig)

	local ll = 1
	local ul = `ksel'
	forvalues i=1/`kmas' {
		tempname betaf`i'
		matrix `betaf`i'' = `beta0'[1, `ll'..`ul']
		if (`k2'>1) {
			mata: _np_reorder_atlevels(`k2', ///
				"`matorig'", "`betaf`i''")
		}
		matrix `betaf' = nullmat(`betaf'), `betaf`i''
		local ll = `ll' + `ksel'
		local ul = `ul' + `ksel'
	}

	_dydx_new_stripe,	anything(`newvars')	///
				k2(`k2') 		///
				vlt(`vlt')		///
				beta(`betaf')		///
				h(`h')			///
				matst(`matorig')	///
				overnot		

	local tira = "`s(stripe)'"
	quietly count if `touse'
	local N = r(N)
	return local dlist "`h'"
	matrix colnames `betaf' = `tira'
	return local lista "`tira'"
	return local N       = `N'
	return matrix b1 = `betaf'
end

program define _parse_over, sclass
	syntax [if] [in], over(string)
	
	marksample touse 
	tempname matindex 
	
	_how_many_over if `touse', over(`over')
	local over "`r(noms)'"
	
	local kvlt: list sizeof over
	local varover ""
	forvalues i=1/`kvlt' {
		local a: word `i' of `over'
		if (`i'==1) {
			local varover "`varover' i.`a'"
		}
		else {
			local varover "`varover'#i.`a'"
		}
	}
	fvexpand `varover' if `touse'
	local varlistover = r(varlist)
	local k2vlt: list sizeof varlistover 
	matrix `matindex' = J(`k2vlt', `kvlt', 0)
	forvalues i=1/`k2vlt' {
		local a: word `i' of `varlistover'
		_ms_parse_parts `a'
		forvalues j=1/`kvlt' {
			if (`kvlt'==1) {
				local b = r(level)		
			}
			else {
				local b = r(level`j')			
			}
			matrix `matindex'[`i',`j'] = `b'
		}
	}
	forvalues i=1/`k2vlt' {
		local cond`i' ""
		local conds`i' ""
		forvalues j=1/`kvlt' {
			local a = `matindex'[`i', `j']
			local b: word `j' of `over'
			if (`j'==1) {
				local cond`i' "`cond`i'' if `b'==`a'"
				local conds`i' "`conds`i'' `b'==`a'"
			}
			else {
				local cond`i' "`cond`i'' & `b'==`a'"
				local conds`i' "`conds`i'' & `b'==`a'"
			}
		}
	}
	
	local vlt ""
	forvalues i=1/`k2vlt' {
		local a: word `i' of `varlistover'
		_ms_parse_parts `a'
		local vlt`i' ""
		forvalues j=1/`kvlt' {
			local b = r(level`j')
			local c = r(name`j')
			if (`kvlt'==1) {
				local b = r(level)
				local c = r(name)			
			}
			if (`j'==1) {
				local vlt`i' "`b'.`c'"
			}
			if (`j'==`kvlt' & `kvlt'>1) {
				local vlt`i' "`vlt`i''#`b'.`c'"
			}
			if (`j'<`kvlt' & `kvlt'>1 & `j'>1)  {
				local vlt`i' "`vlt`i''#`b'.`c'#"				
			}
		}
		local vlt "`vlt' `vlt`i''"
	}
	
	sreturn local vlt "`vlt'"
	sreturn local k2vlt = `k2vlt'

end

program define _dydx_listas, sclass
	syntax, [dydx(string) continuous(string) ///
		discrete(string) quieto(string) quieto2(string)]
	
	marksample touse 
		
	local cdnum  = e(cdnum)
	if (`cdnum'==1) {
		local tuti "`continuous'"
	}
	if (`cdnum'==2) {
		local tuti "`discrete'"
		local k0c = 1
	}
	if (`cdnum'==3) {
		local tuti "`continuous' `discrete'"
	}
	
	local dydxw = 0
	local dydxk: list sizeof dydx
	local dydxn ""
	forvalues i=1/`dydxk' {
		local tdy: word `i' of `dydx'
		quietly capture tab `tdy'
		local rc = _rc
		if (`rc') {
			capture _ms_parse_parts `tdy'
			local rc = _rc 
			if (`rc') {
				fvexpand `tdy' 
				local newtdy = r(varlist)
				local jdydx: list sizeof newtdy
				forvalues j = 1/`jdydx' {
					local xdydx: ///
						word `j' of `newtdy'
					_ms_parse_parts `xdydx'
					local tdybase = r(base)
					local tdyname = r(name)
					local dydxn ///
				   "`dydxn' `tdybase'.`tdyname' `tdy'"
				}
			}
			else {
				local tdybase = r(base)
				local tdyname = r(name)
				local dydxn ///
				"`dydxn' `tdybase'.`tdyname' `tdy'"
			}
			local dydxw = 1
		}
		else {
			local dydxn "`dydxn' `tdy'"
		}
	}
	fvexpand `dydx' 
	local dydx0 = r(varlist)
	local tutituti: list tuti & dydx0
	if ("`tuti'"=="`tutituti'"| "`dydx'"=="*" | ///
	"`dydx'"=="_all" ) {
		if (`cdnum'==1) {
			fvexpand `continuous' 
			local lalista = r(varlist)		
		}
		if (`cdnum'==2) {
			local kddd: list sizeof discrete
			forvalues i=1/`kddd' {
				local xkddd: word `i' ///
					of `discrete'
				fvexpand i.`xkddd' 
				local ykddd = r(varlist)
				local discreteddd ///
					"`discreteddd' `ykddd'"
			}
			_lista_yesrhs `discreteddd', ///
				quieto(`quieto')
			local lalista = "`s(lyesrhs)'"

		}
		if (`cdnum'==3) {
			local kddd: list sizeof discrete
			forvalues i=1/`kddd' {
				local xkddd: word `i' ///
					of `discrete'
				fvexpand i.`xkddd' 
				local ykddd = r(varlist)
				local discreteddd ///
					"`discreteddd' `ykddd'"
			}
			_lista_yesrhs `discreteddd', ///
				quieto(`quieto')
			local lalista = "`continuous' `s(lyesrhs)'"			
		}
		local h "`lalista'"
	}
	else {
		if (`cdnum'==1) {
			if (`dydxw'==0) {
				fvexpand `dydx' 
			}
			else {
				fvexpand `dydxn'
			}
			local dydx2 = r(varlist)
			fvexpand `continuous'
			local lalista = r(varlist)	
			local a: list continuous  & dydx2	
			local b: list lalista & dydx2	
			local c "`a' `b'"
			local h: list uniq c		
		}
		if (`cdnum'==2) {
			if (`dydxw'==0) {
				local kddd: list sizeof discrete
				forvalues i=1/`kddd' {
					local xkddd: word `i' ///
						of `discrete'
					fvexpand i.`xkddd' 
					local ykddd = r(varlist)
					local discreteddd ///
						"`discreteddd' `ykddd'"
				}
				_lista_yesrhs `dydx', ///
				quieto(`quieto') dq(`quieto2')
				local dydx2 = "`s(lyesrhs)'"
				_lista_yesrhs `discreteddd', ///
					quieto(`quieto') 
			}
			else {
				local kddd: list sizeof discrete
				forvalues i=1/`kddd' {
					local xkddd: word `i' ///
						of `discrete'
					fvexpand i.`xkddd'
					local ykddd = r(varlist)
					local discreteddd ///
						"`discreteddd' `ykddd'"
				}
				_lista_yesrhs `dydxn', ///
				quieto(`quieto') dq(`quieto2')
				local dydx2 = "`s(lyesrhs)'"
				_lista_yesrhs `discreteddd', ///
					quieto(`quieto') 
			}
			local lalista = "`s(lyesrhs)'"	
			local a: list discrete  & dydx2	
			local b: list lalista & dydx2	
			local c "`a' `b'"	
			local h: list uniq c		
		}
		if (`cdnum'==3) {
			local kddd: list sizeof discrete
			forvalues i=1/`kddd' {
				local xkddd: word `i' of `discrete'
				fvexpand i.`xkddd' 
				local ykddd = r(varlist)
				local discreteddd ///
					"`discreteddd' `ykddd'"
			}
			_lista_yesrhs `discreteddd', ///
				quieto(`quieto') 
			local lalistad = "`s(lyesrhs)'"
			local lalista "`continuous' `lalistad'"
			local a0 = "`s(lyesrhs)'"
			if (`dydxw'==0) {
				local dydx3: list dydx & discrete
				local dydx32: list dydx & lalistad
				local dydx5: list dydx & continuous
				_lista_yesrhs `dydx3' ///
					`dydx32',	///
					quieto(`quieto') dq(`quieto2')
				local dydx4 = "`s(lyesrhs)'"
			}
			else {
				local dydx3: list dydxn & discrete
				local dydx32: list dydxn & lalistad
				local dydx5: list dydxn & continuous
				_lista_yesrhs `dydx3' ///
					`dydx32',	///
					quieto(`quieto') dq(`quieto2')
				local dydx4 = "`s(lyesrhs)'"
			}
			local dydx1 "`dydx5' `dydx4'" 
			local a: list continuous  & dydx1	
			local b0: list dydx1 - a
			if ("`b0'"!="") {
				_lista_yesrhs `b0', ///
					quieto(`quieto') dq(`quieto2')
				local b1 = "`s(lyesrhs)'"
			}
			local b: list b1 & a0
			local dydx2 "`a' `b1'" 
			local g: list lalista & dydx2	
			local c "`a' `b' `g'"
			local h: list uniq c
			local btable "`b'"		
		}
		casedos_parse, lista("`h'") dydx("`dydx'")
	}
	sreturn local h "`h'"
	sreturn local lalista "`lalista'"
end

program define _select_dydx, rclass
	syntax, [lalista(string) h(string) k(integer 1) ///
		 gradm(string) ktaman(integer 1) lmgs2(string)]
	
	tempname usar beta2 beta0 indice indice2 mgrad
	
	local listax ""
	local listacomp ""
	local ktal: list sizeof lalista
	local kmas: list sizeof h
	
	matrix `mgrad' = `gradm'

	forvalues i=1/`ktal' {
		local x: word `i' of `lalista'
		_ms_parse_parts `x'
		local base = r(base)
		if (`base'!=1) {
			local x2 = `"`x' "'*`k'
			local listax "`listax' `x2'"
		}
	}
	
	forvalues i=1/`kmas' {
		local x: word `i' of `h'
		_ms_parse_parts `x'
		local base = r(base)
		if (`base'!=1) {
			local listacomp "`listacomp' `x'"
		}
	}

	local j1: list sizeof listacomp
	local j2: list sizeof listax
	matrix `usar' = J(`j2', 1, 0)
	
	forvalues i=1/`j1' {
			local x1: word `i' of `listacomp'
		forvalues j=1/`j2' {
			local x2: word `j' of `listax'
			local a: list x1 & x2
			if ("`a'"!="") {
				matrix `usar'[`j',1] = 1
			}
		}
	}

	mata: st_matrix("`mgrad'", select(st_matrix("`mgrad'"),	///
		st_matrix("`usar'")))
	
	local kmgcov = rowsof(`mgrad')

	matrix `beta2' = `mgrad''
	matrix `indice' = 1
	matrix `beta0'	= J(1, `ktaman', 0)
	forvalues i=1/`ktaman' {
		local x: word `i' of `lmgs2'	
		_ms_parse_parts `x'
		local bla = r(type)
		if ("`bla'"!="factor") {
			matrix `indice' = `indice', `i'
		}
		else {
			local bli = r(base)
			if (`bli'!=1) {
				matrix `indice' = `indice', `i'
			}
		}
	}
	matrix `indice'= `indice'[1, 2..colsof(`indice')]
	matrix `indice2' = 1

	mata: _pedazos_mat("`beta0'", "`beta2'", "`indice2'",	///
		"`indice'")
	
	return matrix beta0 = `beta0'
end 

program define _matorig_contrast, rclass
	syntax, [dvarscont(string)]
	
	tempname mataccum
	
	local jaccum = 0 
	local kmat: list sizeof dvarscont
	
	forvalues i=1/`kmat' {
		local x: word `i' of `dvarscont'
		_ms_parse_parts `x'
		local typo = r(type)
		if ("`typo'"!="`interaction'") {
			if (`i'==1) {
				local nom0 = r(name)
			}
			local nom1 = r(name)
			if ("`nom1'"=="`nom0'") {
				local jaccum = `jaccum' + 1 
			}
			else {
				matrix `mataccum' = nullmat(`mataccum'), ///
						    `jaccum'
				if (`i'<`kmat') {
					local jaccum = 1
				}
			}
			local nom0 "`nom1'"
		}
		else {
			local kint = r(k_names)
			if (`i'==1) {
				forvalues j=1/`kint' {
					local nomp = r(name`j')
					local nom0 "`nom0' `nomp'"
				}
			}
			forvalues j=1/`kint' {
				local nomp = r(name`j')
				local nom1 "`nom1' `nomp'"
			}
			if ("`nom1'"=="`nom0'") {
				local jaccum = `jaccum' + 1 
			}
			else {
				matrix `mataccum' = nullmat(`mataccum'), ///
						    `jaccum'
				if (`i'<`kmat') {
					local jaccum = 1
				}
			}
			local nom0 "`nom1'"
			local nom1 ""
		}
		if (`i'==`kmat') {
			matrix `mataccum' = nullmat(`mataccum'), `jaccum'
		}
	}
	return matrix matorig = `mataccum'
end

program define _contrastunoover, rclass
	syntax [if][in], [anything(string) over(string)]
	
	marksample touse 
	
	tempname betaf beta0 beta1 matst betabla
	
	_parse_over if `touse', over(`over')
	local k2vlt = s(k2vlt)
	local vlt   = `"`s(vlt)'"'
	
	forvalues i=1/`k2vlt' {
		tempvar touselk
		tempname b0
		local condvlt: word `i' of `vlt'
		quietly generate `touselk' = `condvlt'*`touse'
		_contrast_uno if `touselk', anything(`anything')
		matrix `b0'    = r(b0)
		matrix `betaf' = nullmat(`betaf'), `b0' 
	}
	
	_strip_contrast `anything' 
	local variables = r(varlist)

	fvexpand `variables' if `touse'
	local newvars = r(varlist)
	
	_matorig_contrast, dvarscont(`newvars')
	
	matrix `matst'   = r(matorig)
	matrix `betabla' = `betaf'
	local bla = colsof(`matst')
	
	mata: _np_reorder_mglist(`k2vlt', `bla', "`betabla'", "`matst'")
	
	_tira_marginslist, vlt(`vlt') newvars(`newvars') matorig(`matst')
	
	local tirando = "`s(tirando)'"
	
	matrix colnames `betabla' = `tirando'
	matrix `beta0' = `betabla'
	matrix `beta1' = `betabla'
	
	return local lista  "`tirando'"
	return matrix b0 = `beta0'
	return matrix b1 = `beta1'
	
end

program define contrastcuatroover, rclass
	syntax [if][in], [anything(string) over(string) dydx(string)]
	
	marksample touse 
	
	tempname betaf beta0 beta1 matst betabla beta2new 
	
	_parse_over if `touse', over(`over')
	local k2vlt = s(k2vlt)
	local vlt   = `"`s(vlt)'"'
	
	forvalues i=1/`k2vlt' {
		tempvar touselk
		tempname b0
		local condvlt: word `i' of `vlt'
		quietly generate `touselk' = `condvlt'*`touse'
		_anything_sanity if `touselk', anything(`anything')
		_contrast_cuatro if `touselk', anything(`anything') ///
					       dydx(`dydx')
		local h = "`r(dlist)'"
		matrix `b0'    = r(b0)
		matrix `betaf' = nullmat(`betaf'), `b0' 
	}
	
	_strip_contrast `anything' 
	local variables = r(varlist)

	fvexpand `variables' if `touse'
	local newvars = r(varlist)
	
	_matorig_contrast, dvarscont(`newvars')
	
	matrix `matst'   = r(matorig)
	
	local taman: list sizeof h
	local dydxk: list sizeof dydx
	
	local kbet = colsof(`betaf')/(`taman'*`k2vlt')
	local kco  = colsof(`betaf')
	
	mata: _np_reorder(`taman', `k2vlt', `kbet', "`betaf'", "`matst'")

	_cuatro_stripes, kco(`kco') taman(`taman') k2vlt(`k2vlt') ///
			 dydxk(`dydxk') betaunom(`betaf') 	  ///
			 matstm(`matst') kbet(`kbet')
			 
	matrix `beta2new' = r(beta2new)
	
	_tira_marginslist, vlt(`vlt') newvars(`newvars') matorig(`matst')
	
	local tira0 = "`s(tirando)'"
	local ktira: list sizeof tira0
	
	forvalues i=1/`taman' {
		local x: word `i' of `h'
		forvalue j=1/`ktira' {
			local y: word `j' of `tira0'
			local tirando "`tirando' `x':`y'"
		}
	}
	
	matrix colnames `beta2new' = `tirando'
	
	quietly count if `touse'
	local N = r(N)
	
	return local dlist "`h'"	
	return local lista "`tirando'"
	return local N = `N'
	return matrix b1 = `beta2new'
end 

program define contrastcincoover, rclass
	syntax [if][in], [anything(string)	///
			  over(string)		///
			  atnames(string)	///
			  atmat(string)]
	
	marksample touse 
	
	tempname betaf beta0 beta1 matst betabla beta2new atmatrix atmatrix0
	
	_parse_over if `touse', over(`over')
	local k2vlt = s(k2vlt)
	local vlt   = `"`s(vlt)'"'
	
	matrix `atmatrix0' = `atmat'
	local katov = rowsof(`atmatrix0')
	local kfatov = `katov'/`k2vlt'
	local jkatov = `k2vlt' 
	forvalues i=1/`kfatov' {
		matrix `atmatrix' = ///
		nullmat(`atmatrix') \ ///
		`atmatrix0'[`jkatov', 1..colsof(`atmatrix0')]
		local jkatov = `jkatov' + `k2vlt' 
	}
	
	forvalues i=1/`k2vlt' {
		tempvar touselk
		tempname b0
		local condvlt: word `i' of `vlt'
		quietly generate `touselk' = `condvlt'*`touse'
		_anything_sanity if `touselk', anything(`anything')
		_contrast_cinco if `touselk', anything(`anything')  ///
					    atnames(`atnames') 	  ///
					    atmat(`atmatrix') 
		matrix `b0'    = r(b0)
		matrix `betaf' = nullmat(`betaf'), `b0' 
	}
	
	_strip_contrast `anything' 
	local variables = r(varlist)

	fvexpand `variables' if `touse'
	local newvars = r(varlist)
	
	_matorig_contrast, dvarscont(`newvars')
	matrix `matst'   = r(matorig)
	
	local kls = colsof(`matst')
	local k2 = rowsof(`atmatrix')
	
	mata: _np_reorder_ml_at(`kls', `k2', `k2vlt', ///
	      "`matst'", "`betaf'")	

	return matrix b1 = `betaf'
end

program define contrastseisover, rclass
	syntax [if][in], [anything(string)	///
			  over(string)		///
			  atnames(string)	///
			  atmat(string)		///
			  dydx(string)]
			  
	marksample touse 
	
	tempname betaf beta0 beta1 matst betabla betanew atmatrix atmatrix0
	
	_parse_over if `touse', over(`over')
	local k2vlt = s(k2vlt)
	local vlt   = `"`s(vlt)'"'
	
	matrix `atmatrix0' = `atmat'
	local katov = rowsof(`atmatrix0')
	local kfatov = `katov'/`k2vlt'
	local jkatov = `k2vlt' 
	forvalues i=1/`kfatov' {
		matrix `atmatrix' = ///
		nullmat(`atmatrix') \ ///
		`atmatrix0'[`jkatov', 1..colsof(`atmatrix0')]
		local jkatov = `jkatov' + `k2vlt' 
	}
	
	forvalues i=1/`k2vlt' {
		tempvar touselk
		tempname b0
		local condvlt: word `i' of `vlt'
		quietly generate `touselk' = `condvlt'*`touse'
		_anything_sanity if `touselk', anything(`anything')
		_contrast_seis if `touselk', anything(`anything')	///
					    atnames(`atnames') 	 	///
					    atmat(`atmatrix')		///
					    dydx(`dydx')	
		local h = "`r(dlist)'"
		matrix `b0'    = r(b1)
		matrix `betaf' = nullmat(`betaf'), `b0' 
	}
	
	_strip_contrast `anything' 
	local variables = r(varlist)

	fvexpand `variables' if `touse'
	local newvars = r(varlist)
	
	_matorig_contrast, dvarscont(`newvars')
	matrix `matst'   = r(matorig)
	
	local taman: list sizeof h
	local k2 = rowsof(`atmatrix')
	
	_seis_stripes , taman(`taman') k2vlt(`k2vlt') k2(`k2')	///
			beta1(`betaf') matst2(`matst') 
	
	matrix `betanew' = r(betanew)
	
	_dydx_new_stripe,	anything(`newvars')	///
				k2(`k2') 		///
				vlt(`vlt')		///
				beta(`betanew')		///
				h(`h')			///
				matst(`matst')		///
				k2vlt(`k2vlt') 	
				
	local tira = "`s(stripe)'"
	matrix colnames `betanew' = `tira'
	return local lista "`tira'"
	return matrix b1 = `betanew'
end

program define _tira_marginslist, sclass
	syntax, [vlt(string) newvars(string) matorig(string) overnot]
	
	local k1: list sizeof newvars
	local k2: list sizeof vlt

	tempname matst
	
	forvalues i=1/`k1' {
		local x: word `i' of `newvars'
		_ms_parse_parts `x'
		local tipo = r(type)
		if ("`tipo'"!="interaction") {
			local name  = r(name)
			local nivel = r(level)
			local lista "`lista' `nivel'.`name'"
		}
		else {
			local kint = r(k_names)
			forvalues j=1/`kint' {
				local name  = r(name`j')
				local nivel = r(level`j')
				if (`j'==1) {
					local listax "`nivel'.`name'"
				}
				else {
					local listax "`listax'#`nivel'.`name'"
				}
			}
			local lista "`lista' `listax'"
		}
	}

	local knf = `k1'*`k2'
	local jov  = 1
	local jmat = 1
	local j1   = 1 
	local j2   = 1 
	local ul   = 0 
	
	if ("`overnot'"=="") {
		matrix `matst' = `matorig'
		while (`j1' <= `knf') {
			local vover: word `jov' of `vlt'
			local kx = `matst'[1, `jmat'] + `ul'
			forvalues i=`j2'/`kx' {
				local xnom: word `i' of `lista'
				local tirando "`tirando' `vover'#`xnom'"
				local j1  = `j1' + 1
			}
			local jov = `jov' + 1
			if (`jov'>`k2') {
				local jov  = 1
				local kx2  = `matst'[1, `jmat']
				local jmat = `jmat' + 1
				local j2   = `j2' + `kx2' 
				local ul   = `ul' + `kx2' 
			}
			local j1  = `j1' + 1
		}
	}
	else {
		local tirando "`lista'"
	}
	
	sreturn local tirando "`tirando'"
end


program define _cuatro_stripes, rclass
	syntax, [ kco(integer 1) taman(integer 1) 	///
		  k2vlt(integer 1) dydxk(integer 1)	///
		  betaunom(string) matstm(string) 	///
		  kbet(integer 1)]
	
	tempname beta2new betauno matst
	
	local kha = `kco'/`taman'
	local krl = 1
	local klu = `kha'
	local kcl = `dydxk'*`k2vlt' 
	
	matrix `betauno'  = `betaunom'
	matrix `matst'    = `matstm' 

	matrix `beta2new' = 0

 	forvalues lm = 1/`taman' {
		local kdl = 0
		tempname bkro selectkro 
		forvalues i = 1/`kcl' {
			tempname betadydx`i'
			matrix `betadydx`i'' =	///
				`betauno'[1, 1 + `kdl'..`kbet' + `kdl']
			local kdl = `kdl' + `kbet'
		}

		
		local kro = colsof(`matst')

		local j  = 0 
		forvalues i=1/`kro' {
			local j = `matst'[1,`i'] + `j'
		}
		
		matrix `bkro' = J(1, `j', 0)
		mata: st_matrix("`bkro'", 1..`j')
		
		local ku = 0
		local kl = 0 
		matrix `selectkro' = J(1,`kro', 1)
		
		forvalues i=1/`kro' {
			tempname A`i' c`i' s`i'
			local ku = `ku' + `matst'[1,`i']
			matrix `A`i'' = `bkro'[1,1+`kl'..`ku']
			local kl = `kl' + `matst'[1,`i']
			matrix `s`i'' = `selectkro'
			matrix `s`i''[1,`i'] = 0
			matrix `c`i'' = 0 
			mata: st_matrix("`c`i''", ///
				sum(select(st_matrix("`matst'"), ///
				st_matrix("`s`i''"))))
			local add`i' = `c`i''[1,1] + `matst'[1,`i'] 
		}

		local k2 = `k2vlt'

		forvalues i=1/`kro' {
			tempname M`i'
			matrix `M`i'' = `A`i''
			local kat = `k2'-1
			forvalues j=1/`kat' {
				matrix `M`i'' = `M`i'', (`A`i'' ///
					+ J(1,colsof(`A`i''), `add`i''*`j'))
			}
		}
		
		forvalues i=1/`kro' {
			tempname betakro`i'
			matrix `betakro`i'' = `betauno'[1, `krl'..`klu']
			mata: st_matrix("`betakro`i''", ///
			st_matrix("`betakro`i''")[1, st_matrix("`M`i''")])
			matrix `beta2new' = `beta2new', `betakro`i''
		}	
		local krl = `krl' + `kha'
		local klu = `kha'*(1 +`lm')
	}
	local kco2 = `kco' + 1
	matrix `beta2new' = `beta2new'[1, 2..`kco2']
	
	return matrix beta2new = `beta2new'
end 

program define _seis_stripes, rclass
	syntax, [ taman(integer 1) 			///
		  k2vlt(integer 1) k2(integer 1)	///
		  beta1(string) matst2(string) ]
		  
	local klss1 = colsof(`beta1')/(`k2vlt')
	local klss2 = colsof(`matst2')
	local klss4 = `taman'*`k2vlt'
	local klss3 = colsof(`beta1')/(`klss4')
	tempname betatester betatester2 
	local ll = 1 
	local al = 1
	local ul = `klss3'
	local au = `klss3'		
	forvalues i=1/`taman' {
		tempname betat`i'
		forvalues j=1/`k2vlt' {
			tempname betaj`j'
			matrix `betaj`j'' = `beta1'[1, `ll'..`ul']
			local ll = `ll' + `klss1'
			local ul = `ul' + `klss1'
			matrix `betat`i'' = nullmat(`betat`i''), ///
						`betaj`j''
		}
		local al = `al' + `klss3'
		local au = `au' + `klss3' 
		local ll = `al'
		local ul = `au'
	}

	forvalues i=1/`taman' {
		mata: _np_reorder_ml_at(`klss2', `k2', `k2vlt', ///
		"`matst2'", "`betat`i''")
		matrix `betatester2' = nullmat(`betatester2'), ///
			`betat`i''
	}
	return matrix betanew = `betatester2'
end

program define _anything_sanity
	syntax [if][in], [anything(string)]
	marksample touse 
	if ("`anything'"!="") {
		fvexpand `anything' if `touse'
		local vars = r(varlist)
		local k: list sizeof vars
		forvalues i=1/`k' {
			local x: word `i' of `vars'
			_ms_parse_parts `x'
			local base  = r(base)
			local omit  = r(omit)
			local nivel = r(level)
			local name  = r(name)
			local tipo  = r(type)
			if ("`tipo'"!="interaction") {
				if (`base'==0 & `omit'==1) {
					display as error "margin is not" ///
					 " estimable " 
					di as err "{p 4 4 2}" 
					di as smcl as err "For `name' in "
					di as smcl as err " the" 
					di as smcl as err " {it:marginslist}"
					di as smcl as err "`x' " 
					di as smcl as err " is empty" 
					di as smcl as err "{p_end}"	
					exit 198
				}
			}
			else {
				local k2 = r(k_names)
				forvalues j=1/`k2' {
					local level = r(level`j')
					local nom   = r(name`j')
					if (`j'==1) {
						local inter "`level'.`nom'"
					}
					else {
						local inter ///
						  "`inter'#`level'.`nom'"
					}
				}
				quietly summarize `inter' if `touse'
				local N = r(N)
				if (`N'==0) {
					display as error "margin " ///
					 "is not estimable" 
					di as err "{p 4 4 2}" 
					di as smcl as err "The interaction "
			   di as smcl as err " `x' in {it:marginslist}"
					di as smcl as err " is empty" 
					di as smcl as err "{p_end}"
					exit 198	
				}
			}
		}
	}
	
end

program define _dydx_new_stripe, sclass
	syntax [if][in], [	anything(string)	///
				k2(integer 1) 		///
				vlt(string)		///
				beta(string)		///
				h(string)		///
				matst(string)		///
				k2vlt(integer 1) 	///
				overnot]
	marksample touse 
	
	tempname matst2 betatester2
	
	matrix `matst2'      = `matst'
	matrix `betatester2' = `beta'
	
	local kst1: list sizeof anything
	local k2dydx: list sizeof h
	local knf = `kst1'*`k2vlt'

	local j = 1 
	forvalues i=1/`kst1' {
		local x: word `i' of `anything'
		_ms_parse_parts `x'
		local nom1 = r(name)
		local mitipo = r(type)
		if ("`mitipo'"!="interaction") {
			if (`i'==1) {
				local nom0 "`nom1'"
			}
			if ("`nom1'"=="`nom0'") {
				local nombre`j' "`nombre`j'' `x'"
			}
			else {
				local j = `j' + 1
				local nombre`j' ""
				local nombre`j' "`nombre`j' '`x'"		
			}
			local nom0 "`nom1'"
		}
		else {
			local knoms = r(k_names)
			forvalues zu=1/`knoms' {
				local namez`zu' = r(name`zu')
				local noms1 "`noms1' `namez`zu''"
			}
			if (`i'==1) {
				local noms0 "`noms1'"
			}
			if ("`noms1'"=="`noms0'") {
				local nombre`j' "`nombre`j'' `x'"
			}
			else {
				local j = `j' + 1
				local nombre`j' ""
				local nombre`j' "`nombre`j' '`x'"		
			}
			local noms0 "`noms1'"
			local noms1 ""
		}
	}
		
	forvalues i=1/`k2' {
		if (`k2'>1) {
			local attira `i'._at#
		}
		local j1 = 1 
		local j2 = 1
		local j3 = 1
		while (`j1' <= `knf') {
			local a: word `j3' of `vlt'
			local b "`nombre`j2''"
			local ktt: list sizeof b
			if (`ktt'==1) {
				local b = strltrim("`b'")
				fvexpand i.`b' if `touse'
				local alista = r(varlist)
			}
			else {
				local alista "`b'"
			}
			local klista: list sizeof alista
			forvalues i=1/`klista' {
				local c: word `i' of `alista'
				_ms_parse_parts `c'
				local nom0 = r(level)
				local nom1 = r(name)
				local mitipo = r(type)
				if ("`mitipo'"!="interaction") {
					local nom "`nom0'.`nom1'"
					if ("`overnot'"=="") {
						local tirando2 ///
						"`tirando2' `attira'`a'#`nom'"	
					}
					else {
						local tirando2 ///
						"`tirando2' `attira'`nom'"						
					}
				}	
				else {
					local kz = r(k_names)
					forvalues zu=1/`kz' {
						local nm`zu' = r(name`zu')
						local lv`zu' = r(level`zu')
						if (`zu'==1) {
							local nom ///
							"`lv`zu''.`nm`zu''"
						}
						else {
							local pr ///
							"`lv`zu''.`nm`zu''"
							local nom ///
							"`nom'#`pr'"
						}	
					}
					if ("`overnot'"=="") {
						local tirando2 ///
						"`tirando2' `attira'`a'#`nom'"  
					}
					else {
						local tirando2 ///
						"`tirando2' `attira'`nom'" 					
					}
				}	
			}
			local j4 = `j3'
			if (`j3' < `k2vlt') {
				local j3 = `j3' + 1 
			}
			if (`j4'==`k2vlt') {
				local j3 = 1
				if (`j2'<`kst1') {
					local j2 = `j2' + 1
				}
				else {
					local j2 = 1
				}
			}
			local j1 = `j1' + 1		
		}
	}
	
	local bla: list sizeof h
	local kbeta = colsof(`betatester2')
	local kst = `kbeta'/`bla'

	local tirando "`tirando2'"
	mata: _restripe_ml_at("`tirando'", "`matst2'", `k2',	///
		`k2vlt', `kst')
	local tirando2 "`tirando'"
	
	local ktira2: list sizeof tirando2
	local tirita ""
	forvalues i = 1/`k2dydx' {
		local dydn: word `i' of `h'
		forvalues j=1/`ktira2' {
			local x: word `j' of `tirando2'
			local tirita "`tirita' `dydn':`x'"
		}
	}
	sreturn local stripe "`tirita'"
end

program define _how_many_over, rclass
	syntax [anything] [if][in], [over(string)]
	
	marksample touse 
	_strip_contrast `over', notsops nointeractions opt(over) 
	local varszero = r(varlist)
	fvexpand `varszero' if `touse'
	local varsnew = r(varlist)
	local k: list sizeof varsnew 

	forvalues i=1/`k' {
		local x: word `i' of `varsnew'
		_ms_parse_parts `x'
		local name = r(name) 
		local noms "`noms' `name'"
	} 
	local noms: list uniq noms
	return local noms "`noms'"
end

program define _an_exact_zero, rclass 
	syntax [anything], [beta(string) dydxs(string)]
	tempname b errores 
	matrix `b' = `beta'
	local k = colsof(`b')
	matrix `errores' = J(1, `k', 0)
	local exactzero = 0
	forvalues i=1/`k' {
		if (`b'[1,`i']==0) {
			local exactzero = `exactzero' + 1 
			matrix `errores'[1,`i']= 8 
		}
	}
	if ("`dydxs'"!="") {
		local bases = 0 
		local k: list sizeof dydxs
		forvalues i=1/`k' {
			local x: word `i' of `dydxs'
			_ms_parse_parts `x'
			local omit = r(omit) 
			gettoken dydx2 other: x, parse(": ")
			_ms_parse_parts `dydx2'
			local omit2 = r(omit)
			if (`omit'==1|`omit2'==1) {
				local bases = `bases' + 1 
			}	
		}
		local exactzero = `exactzero' - `bases'
		if (`exactzero'<0) {
			local exactzero = 0 
		}
	}
	if (`exactzero'>0) {
		return matrix  error = `errores'
	}
	return local exactzero = `exactzero'
end 



