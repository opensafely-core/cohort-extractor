*! version 1.2.0  12mar2018
program heckpoisson, eclass byable(onecall) properties(svyb svyj svyr)
	version 15.0

	if _by() {
		local by `"by `_byvars'`_byrc0':"'
	}
	`by' _vce_parserun heckpoisson, mark(CLuster) : `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"heckpoisson `0'"'	
		exit
	}

	if replay() {
		if _by() {
			error 190
		}
		else {
			Playback `0'
		}
	}
	else {
		`by' Estimate `0'
	}
end
						//------Playback----//
program Playback
	syntax [,*]
	if `"`e(cmd)'"' != "heckpoisson" {
		di as error "results for {bf:heckpoisson} not found"
		exit 301
	}
	else {
		Display `0'
	}
end
						//-----Display-------//
program Display
	syntax 	[,					///
		SELect(passthru)			/// Model options
		noCONstant				///
		COLlinear				///
		OFFset(passthru)			///
		EXPosure(passthru)			///
		INTPoints(integer 25)			///
		CONSTraints(string)			///
		vce(string)				///
		IRr					///
		DIFficult            			/// Maximization Options 
		TECHnique(string)      			///
		ITERate(real 1500)     			///
		NOLOg LOg                		///
		TRace                			///
		GRADient               			///
		showstep               			///
		HESSian              			///
		SHOWTOLerance        			///
		TOLerance(string)   			///
		LTOLerance(string)  			///
		NRTOLerance(string) 			///
		NONRTOLerance        			///
		from(string)				///
		*]					 // Display options

						// parse display options
	_get_diopts diopts rest, `options'
	OptionCheck, extra_option(`rest')
						// coef table
	_crcshdr
	_coef_table, `diopts' `irr'
	Footnote
	ml_footnote
end
						//-----Footnote------//
program Footnote
        di in gr  "`e(chi2_ct)' test of indep. eqns. (rho = 0):" /*
                 */ _col(38) "chi2(" in ye "1" in gr ") = "   /*
                 */ in ye %8.2f e(chi2_c)                     /*
                 */ _col(59) in gr "Prob > chi2 = " in ye %6.4f e(p_c)
end
						//------Estimate------//
program Estimate, eclass byable(recall)
	syntax varlist(fv ts numeric)			///
		[if]					///
		[in]					///
		[fw iw pw] ,				///
		[SELect(passthru)			/// Model options
		noCONstant				///
		COLlinear				///
		OFFset(passthru)			///
		EXPosure(passthru)			///
		INTPoints(integer 25)			///
		CONSTraints(string)			///
		vce(string)				///
		IRr					///
		DIFficult            			/// Maximization Options 
		TECHnique(string)      			///
		ITERate(real 1500)     			///
		NOLOg LOg               		///
		TRace                			///
		GRADient               			///
		showstep               			///
		HESSian              			///
		SHOWTOLerance        			///
		TOLerance(string)   			///
		LTOLerance(string)  			///
		NRTOLerance(string) 			///
		NONRTOLerance        			///
		from(string)				///
		moptobj(passthru)			///
		*]					 // Display options
	
	_get_diopts diopts rest, `options'
	OptionCheck, extra_option(`rest')
						// check intpoints
	CheckIntpoints, intpoints(`intpoints')	
						// parse weight
	tempvar wvar
	ParseWeight [`weight'`exp'], wvar(`wvar')
	local wt `s(wt)'
	local wt_type `s(wt_type)'
	local wt_exp `"`s(wt_exp)'"'
	local wt_var `s(wt_var)'
						// Parse vce		
	ParseVce, vce(`vce') wt(`wt') wt_type(`wt_type')	
	local vce `s(vce)'
	local vcetype `s(vcetype)'
	local clusterv `s(clusterv)'
						// parse depvar 	
	gettoken depvar indepvars : varlist
	ParseDepvar `depvar', wt_type(`wt_type') wt_exp(`wt_exp')
	local depvar `s(depvar)'
						// parse indepvars
	ParseIndepvars `indepvars', `constant' `offset'	`exposure'
	local indep `s(indep)'
	local cons_indep `s(cons_indep)'
	local nocon_indep `s(nocon_indep)'
	local offset_indep `s(offset)'
	local exp_indep `s(exposure)'
						// parse select equation
	tempvar seldepvar
	ParseSelect, `select' depvar(`depvar') seldepvar(`seldepvar')
	local selindep `s(selindep)'
	local cons_selindep `s(cons_selindep)'
	local nocon_selindep `s(nocon_selindep)'
	local offset_sel `s(offset_sel)'
	local seldeps `s(seldeps)'
	local sel_eqname `s(sel_eqname)'
						// ignore depvar which are not
						// selected
	tempvar tmp_depvar
	qui IgnoreDepvar, depvar(`depvar') 	///
		seldepvar(`seldepvar')		///
		tmp_depvar(`tmp_depvar')
						// mark obs and _rmcoll
	tempvar touse
	MarkObs `if' `in' , touse(`touse') depvar(`tmp_depvar')		///
		indep(`indep') offset_indep(`offset_indep')		///
		seldepvar(`seldepvar') 	selindep(`selindep') 		///
		exp_indep(`exp_indep')					///
		offset_sel(`offset_sel') nocon_indep(`nocon_indep') 	///
		nocon_selindep(`nocon_selindep') wt(`wt') 		///
		clusterv(`clusterv') wt_var(`wt_var') `collinear'
	local indep `s(indep)'
	local selindep `s(selindep)'
	local N_cens `s(N_cens)'
						// handle -by- with mark
	if _by() {
		qui replace `touse' = 0 if `_byindex' != _byindex()	
	}
	qui sum `touse'
	NobsError,n(`r(sum)')
						// Starting Values
	qui StartingValues if `touse', depvar(`tmp_depvar')		///
		indep(`indep') seldepvar(`seldepvar')			///
		selindep(`selindep') nocon_indep(`nocon_indep')		///
		nocon_selindep(`nocon_selindep') wt(`wt')	
	tempname b0
	mat `b0' = r(b0)
						// Parse Equations for ml
	ParseEqs, depvar(`depvar') 			///
		indep(`indep') 				///
		nocon_indep(`nocon_indep')		///
		offset_indep(`offset_indep')		///
		exp_indep(`exp_indep')			///
		sel_eqname(`sel_eqname')		///
		seldepvar(`seldepvar')			///
		selindep(`selindep')			///
		nocon_selindep(`nocon_selindep')	///
		offset_sel(`offset_sel')		
	local eqs `s(eqs)'
						// technique
	ParseTechnique, technique(`technique')
	local technique `s(technique)'
						// crittype
	ParseCrittype, wt_type(`wt_type') 	///
		vce(`vce') 			///
		clusterv(`clusterv')
	local crittype `s(crittype)'
						// parse from
	if (`"`from'"'=="") {
		local init init(`b0', copy)		
	}
	else {
		local init init(`from')
	}
							// ml
	tempname Myobj
	cap mata : mata drop `Myobj'
	cap noi {	// capture start
		mata: `Myobj'	= __HECKPOISSON_gh_init(`intpoints')
		ml model lf1 _LL_heckpoisson()		///
			`eqs' 				///
			if `touse'			///
			`wt',				/// 
			maximize			///
			missing				///
			`collinear'			///
			userinfo(`Myobj')		///
			`init'				///
			vce(`vce' `clusterv')		///
			constraints(`constraints')	///
			crittype(`crittype')		///
			`difficult'			///
			technique(`technique')		///
			iterate(`iterate')		///
			`log'	`nolog'			///
			`trace'				///
			`gradient'			///
			`showstep'			///
			ltolerance(`ltolerance')	///
			tolerance(`tolerance') 		///
	 		nrtolerance(`nrtolerance')	/// 
			`nonrtolerance'			/// 
			`moptobj'			
	}	// capture end
	local rc = _rc
	capture mata : mata drop `Myobj'
	if (`rc' != 0) {
		exit `rc'
	}
						// post results
	ereturn hidden local diparm1 athrho, tanh label("rho")
	ereturn hidden local diparm2 lnsigma, exp label("sigma")
	ereturn hidden local seldeps `seldeps'

	ereturn scalar n_quad = `intpoints'
	ereturn scalar N_selected  = e(N)-`N_cens'
	ereturn scalar N_nonselected = `N_cens'

	ereturn local title "Poisson regression with endogenous selection"
	ereturn local title2 "(`intpoints' quadrature points)"
	ereturn local depvar `depvar'
	ereturn local wtype `wt_type'
	ereturn local wexp `"`wt_exp'"'
	ereturn local clustvar `clusterv'
	ereturn local vce `vce'
	ereturn local vcetype `vcetype'
	ereturn local cmdline heckpoisson `0'
	ereturn local chi2type "Wald"
	ereturn local chi2_ct "Wald"
	ereturn local predict "heckpoisson_p"
	ereturn local marginsok "default n ncond pr psel xb xbsel"
	ereturn hidden local marginsderiv default N
	ereturn local marginsnotok "scores"
							// Wald test	
	qui test [`depvar']
	ereturn scalar chi2 	  = r(chi2)
	ereturn scalar p    	  = r(p)
	ereturn scalar df_m 	  = r(df)
	ereturn scalar k_eq_model = 1
	ereturn scalar k_eq	  = 4
	ereturn scalar k_aux	  = 2
							// test for rho=0
	qui test athrho 	  = 0
	ereturn scalar chi2_c 	  = r(chi2)
	ereturn scalar p_c    	  = r(p)

 	Display, `diopts'  `coef' `irr'
	ereturn local cmd "heckpoisson"
end
					  	//---StartingValues-----//
program StartingValues
	syntax [if] [,			///
		depvar(string)		///
		indep(string)		///
		seldepvar(string)	///
		selindep(string)	///
		nocon_indep(string)	///
		nocon_selindep(string)	///
		wt(string) ]
	
	capture qui StartingValuesWNLS 	`0'	
	if (_rc != 0) {
		StartingValuesDefault `0'
	}
end
						//---StartinvValuesDefault---//
program StartingValuesDefault, rclass
	syntax [if] [,			///
		depvar(string)		///
		indep(string)		///
		seldepvar(string)	///
		selindep(string)	///
		nocon_indep(string)	///
		nocon_selindep(string)	///
		wt(string) ]
	
	tempname b10 b20
	local n1 : word count `indep'	
	local n2 : word count `selindep'

	if ("`nocon_indep'" != "noconstant") {
		local n1 = `n1' + 1	
	}
	if ("`nocon_selindep'" != "noconstant") {
		local n2 = `n2' +1 
	}

	mat `b10' = J(1,`n1',0)
	mat `b20' = J(1,`n2', 0)

	local r1 = atanh(0.1)
	local s1 = ln(1)

	tempname b0
	mat `b0' = (`b10', `b20', `r1', `s1')
	return matrix b0 `b0'
end
						//---StartingValuesWNLS-----//
program StartingValuesWNLS, rclass
	syntax [if] [,			///
		depvar(string)		///
		indep(string)		///
		seldepvar(string)	///
		selindep(string)	///
		nocon_indep(string)	///
		nocon_selindep(string)	///
		wt(string) ]
						// Step 1: Probit on y2
	probit `seldepvar' `selindep' `if' `wt', `nocon_selindep'
	tempname b20
	mat `b20' = e(b)

						// Step 2: Nonlinear-LS based 
						// E(y|y2=1,x,w)
	tempvar zr	
	predict double `zr', xb
	tempvar mills
	gen double `mills' = normalden(`zr')/normal(`zr')
	poisson `depvar' `mills' `indep' `if' `wt'
	tempname b_poisson
	mat `b_poisson' = e(b)

	ParseIndepNL, indep(`indep')	
	local xb `s(xb)'

	local eq_m `depvar' = normal(`zr'+{theta})/normal(`zr')*exp(`xb')
	nl (`eq_m') `if' `wt', initial(`b_poisson')
	tempname b_nl b10_nl
	mat `b_nl'   = e(b)
	local theta = `b_nl'[1,1]
	mat `b10_nl' = `b_nl'[1,2...]
	mat colnames `b10_nl' = `depvar':
	mat colnames `b10_nl' = `indep' _cons	
	
						// V(y|y2=1,x,w)
	tempvar e_nl xb_nl delta phi phi2 
	predict double `e_nl', residuals
	tempvar e_var
	gen double `e_var' = `e_nl'^2
	matrix score double `xb_nl' = `b10_nl'	
	gen double `delta' = exp(`xb_nl')
	gen double `phi'   = normal(`zr'+`theta')/normal(`zr')
	gen double `phi2'  = exp(2*`theta'^2)*			///
		normal(`zr'+2*`theta')/normal(`zr')

	local eq_v `e_var' = `delta'*`phi'+(`delta')^2*		///
		(exp({sigma2}-2*`theta'^2)*`phi2'-(`phi')^2)
	nl (`eq_v') `if' `wt'
	tempname b_sig
	mat `b_sig' = e(b)
	
	if (`b_sig'[1,1] > 0){
		local sigma_reg = sqrt(`b_sig'[1,1])
	}
	else {
		local sigma_reg = 1
	}

						//Step3:  Weighted-NLS
	tempvar e2_p
	predict double `e2_p', yhat 
	tempvar y_wnls 
	gen double `y_wnls' = `depvar'/sqrt(`e2_p') 
	local eq_wnls `y_wnls' = normal(`zr'+{theta})/normal(`zr')*	///
		exp(`xb')/sqrt(`e2_p')
	nl (`eq_wnls') `if' `wt' , initial(`b_nl')
	tempname b_wnls b10_wnls
	mat `b_wnls'   = e(b)
	local theta_wnls = `b_wnls'[1,1]
	mat `b10_wnls' = `b_wnls'[1,2...]
	local rho_wnls = `theta_wnls'/`sigma_reg'

	if (`rho_wnls' > 1){
		local rho_wnls = 0.9
	}
	else if (`rho_wnls' < -1) {
		local rho_wnls = -0.9
	}

	local s1 = ln(`sigma_reg')
	local r1 = atanh(`rho_wnls')
							// b10
	tempname b10
	local n_indep : word count `indep'
	if `"`nocon_indep'"' == "noconstant" {
		mat `b10' = `b10_wnls'[1,1..`n_indep']
	}
	else {
		mat `b10' = `b10_wnls'
		mat `b10'[1,`n_indep'+1] =	///
			`b10_wnls'[1,`n_indep'+1]-0.5*`sigma_reg'^2
	}
	
	tempname b0
	mat `b0' = (`b10', `b20', `r1', `s1')
	return matrix b0 `b0'
end
						//-------ParseIndepNL---//
program ParseIndepNL, sclass
	syntax , indep(string)	
	local x_num : word count `indep'
	local x : word 1 of `indep'
	local xb {b1}*`x'
	if (`x_num'>=2) {
		forvalues i=2/`x_num' {
			local x : word `i' of `indep'
			local xb `xb'+{b`i'}*`x'	
		}
	}
	local xb `xb'+{b0}
	sreturn local xb `xb'
end
						//-------ParseVce----//
program ParseVce, sclass
	syntax [, vce(string) wt(string) wt_type(string)]		

	local w: word count `vce'
	if `w' == 0 {
		sreturn local vce oim
		sreturn local vcetype
	}
	else {
		_vce_parse, argopt(CLuster) opt(OIM Robust opg)	///
			pwallowed(Robust CLuster)		///
			: `wt', vce(`vce')
		local vce
		if `"`r(cluster)'"' != "" {
			sreturn local clusterv `r(cluster)'
			sreturn local vce cluster
			sreturn local vcetype Robust
		}
		else if `"`r(vce)'"' == "robust" {
			sreturn local vce robust
			sreturn local vcetype Robust
		}
		else if `"`r(vce)'"' == "oim" {
			sreturn local vce oim
			sreturn local vcetype
		}
		else if `"`r(vce)'"' == "opg" {
			sreturn local vce opg
			sreturn local vcetype OPG
		}
	}
					// pweight implies robust weight
	if `"`wt_type'"' == "pweight" {
		if `"`r(cluster)'"' != "" {
			sreturn local vce cluster
		}
		else {
			sreturn local vce robust
		}
		sreturn local vcetype Robust
	}
end
						//-----MarkObs------//
program MarkObs , sclass 
	syntax	[if] [in]  [, 		///
		touse(string)		///
		COLlinear		///
		depvar(string)		///
		indep(string)		///
		offset_indep(string)	///
		seldepvar(string)	///
		selindep(string)	///
		offset_sel(string)	///
		exp_indep(string)	///
		nocon_indep(string)	///
		nocon_selindep(string) 	///
		clusterv(string)	///
		wt(string)		///
		wt_var(string)]
						// preliminary mark sample
	mark `touse' `if' `in' `wt' 
	markout `touse' `clusterv' `wt_var'
						// markout sample	
	markout `touse' `seldepvar' `selindep' `offset_sel'
	tempvar rtouse
	qui gen byte `rtouse' = `touse'
	markout `rtouse' `depvar' `indep' `offset_indep' `exp_indep'
	qui replace `touse' = 0 if `seldepvar' & !`rtouse'
						// remove collinearity
	_rmcoll `selindep' if `touse' `wt', `nocon_selindep' expand `collinear'
	sreturn local selindep `r(varlist)'

	_rmcoll `indep' if `touse' `wt', `nocon_indep' expand `collinear'
	sreturn local indep `r(varlist)'
	
	qui sum if `touse' & missing(`depvar')
	sreturn local N_cens = r(N)
end
						//----ParseSelect----//
program ParseSelect , sclass
	syntax , SELect(string)	depvar(string) seldepvar(string)
						// parse seldepvar
	tokenize `"`select'"', parse("=")		
	if `"`1'"' == "=" {
		local 1 
		local sel_eq `"`2'"'
	}
	else if `"`2'"' == "=" {
		local lseldep `1'
		_fv_check_depvar `lseldep'
		capture tsunab lseldep : `lseldep'
		local sel_eq `"`3'"'
	}
	else {
		local sel_eq `"`1'"'
	}
	
	if `"`lseldep'"' != ""{
		qui gen `seldepvar' = `lseldep'	
		local sel_eqname `lseldep'
	}
	else {
		qui gen `seldepvar' = 1 if !missing(`depvar')	
		qui replace `seldepvar' = 0 if missing(`depvar')
		local sel_eqname select
	}

	CheckSelDepvar `seldepvar'
						// parse selindepvars
	local 0 `sel_eq'
	ParseIndepSel `0'	
	sreturn local cons_selindep `s(cons_indep)'
	sreturn local selindep `s(indep)'
	sreturn local nocon_selindep `s(nocon_indep)'
	sreturn local offset_sel `s(offset)'
	sreturn local seldeps `lseldep'
	sreturn local sel_eqname `sel_eqname'
end
						//---ParseIndepSel---//
program ParseIndepSel, sclass
	syntax [varlist(default=none fv ts numeric)]	///
		[, noCONstant				///
		OFFset(varname numeric)]			

	if `"`varlist'"' == "" & `"`constant'"'=="noconstant" {
		di as err "one or more variables must be "	///
			"specified in {bf:select()} "
		di as err "option when the {bf:noconstant} "	///
			"suboption is specified"
		exit 198
	}

	if `"`constant'"' != "noconstant" {
		local cons_indepvars "_cons"
	}
	else {
		local cons_indepvars
	}

	sreturn local cons_indep `cons_indepvars'
	sreturn local indep `varlist'
	sreturn local nocon_indep `constant'
	sreturn local offset `offset'
	sreturn local exposure `exposure'
end
						//---CheckSelDepvar--//
program CheckSelDepvar
	capture {
		syntax varname(numeric)
	}
	if _rc == 101 {
		di as err "    dependent variable may not contain " ///
			"time-series" 
		di as err "    or factor-variable operators"
		exit _rc
	}
	else if _rc == 109 {
		di as err "    dependent variable may not be a string"
		exit _rc
	}
	else if _rc != 0{
		exit _rc
	}
	else {
		local seldepvar `varlist'
	}
	
	capture assert (`seldepvar'==0 | `seldepvar'==1)	///
		if !missing(`seldepvar')
	if _rc {
		di as error `"depvar in {bf:select()} must be a 0/1 variable"'
		exit _rc
	}
end
						//---ParseIndepvars---//
program ParseIndepvars, sclass
	syntax [varlist(default=none fv ts numeric)]	///
		[, noCONstant				///
		OFFset(varname numeric)			///
		EXPosure(varname numeric)]

	if `"`varlist'"' == "" {
		di as err "one or more variables must be "	///
			"specified in {it:indepvars} "
		exit 198
	}

	if `"`offset'"'!="" & `"`exposure'"'!="" {
		di as err "only one of {bf:offset()} "		///
			"or {bf:exposure()} can be specified"	
		exit 198
	}


	if `"`constant'"' != "noconstant" {
		local cons_indepvars "_cons"
	}
	else {
		local cons_indepvars
	}

	sreturn local cons_indep `cons_indepvars'
	sreturn local indep `varlist'
	sreturn local nocon_indep `constant'
	sreturn local offset `offset'
	sreturn local exposure `exposure'
end
						//---ParseWeight---//
program ParseWeight, sclass	
	syntax [if] [fw iw pw], wvar(string)
	if `"`weight'"' != "" {
		qui gen double `wvar'`exp' `if'
		local wt `"[`weight'=`wvar']"'
		local wt_type `"`weight'"'
		local wt_exp `"`exp'"'
		local wt_var `wvar'
	}
	else {
		local wt
		local wt_type
		local wt_exp
		local wt_var 
	}
	sreturn local wt `wt'
	sreturn local wt_type `wt_type'
	sreturn local wt_exp `"`wt_exp'"'
	sreturn local wt_var `wt_var'
end
						//----ParseDepvar---//
program ParseDepvar, sclass
	capture noisily {
		syntax varname(numeric) [if] ,	///
			[ wt_type(string) 		///
			wt_exp(string) ]
	}
						// check fv and ts
	if _rc == 101 {
		di as err "    dependent variable may not contain " ///
			"time-series" 
		di as err "    or factor-variable operators"
		exit _rc
	}
	else if _rc == 109 {
		di as err "    dependent variable may not be a string"
		exit _rc
	}
	else if _rc != 0{
		exit _rc
	}
	else {
		local depvar `varlist'
	}
						// special treatment of weight
	if `"`wt_type'"' != "" {
		if `"`wt_type'"' == "fweight" {
			local wt `"[fw`wt_exp']"'	
		}
		else {
			local wt `"[aw`wt_exp']"'
		}
	}	
	qui sum `depvar' `if' `wt' 
						// check observation number	
	if r(N) == 0 {
		error 2000
	}
	if r(N) == 1 {
		error 2001
	}
						// check nonnegative values
	if r(min) < 0 {
		di as err 	///
			`"{bf:`depvar'} must be greater than or equal to zero"'
		exit 459
	}
	if r(min) == r(max) & r(min) == 0 {
		di as err `"{bf:`depvar'} is zero for all observations"'
		exit 498
	}
						// check integer-valued 
	capture assert `depvar' == int(`depvar') `if'
	if _rc {
		di as error `"{bf:`depvar'} must be nonnegative integers"'
		exit 459
	}
	sreturn local depvar `depvar'
end
						//---OptionCheck---//
program  OptionCheck
	syntax , [extra_option(string)]
	if `"`extra_option'"'!="" {
		di as err `"option {bf:`extra_option'} not allowed"'
		exit 198
	}
end
						//---NobsError---//
program define NobsError
	syntax ,n(integer)
	if `n'<=1 {
		di as err "insufficient observations"
		exit 2001
	}
end
						//---CheckIntpoints---//
program define CheckIntpoints
	syntax [, intpoints(integer 25) ]			
	if (`intpoints'>128 | `intpoints'<= 1) {
		di as error "{bf:intpoints()} must be an integer"	///
			" greater than 1 and less than 129" 
		exit 198
	}
end

					//-- ParseEqs --//
program ParseEqs , sclass
	syntax [, depvar(string) 	///
		indep(string) 		///
		nocon_indep(string)	///
		offset_indep(string)	///
		exp_indep(string)	///
		sel_eqname(string)	///
		seldepvar(string)	///
		selindep(string)	///
		nocon_selindep(string)	///
		offset_sel(string)]
						// eq_depvar	
	local eq_depvar (`depvar': `depvar' = `indep',		///
		`nocon_indep' offset(`offset_indep') exposure(`exp_indep'))
						// eq_select
	local eq_select (`sel_eqname' : `seldepvar' = `selindep',	///
		`nocon_selindep' offset(`offset_sel'))
						// eq_athrho
	local eq_athrho /athrho
						// eq_lnsigma
	local eq_lnsigma /lnsigma
						// eqs
	local eqs `eq_depvar' `eq_select' `eq_athrho' `eq_lnsigma'

	sret local eqs `eqs'
end
					//-- ParseTechnique --//
program ParseTechnique, sclass
	syntax [, technique(string) ]
	if (`"`technique'"'=="") {
		local technique bhhh 10 nr 1000
	}
	
	sret local technique `technique'
end
					//-- ParseCrittype --//
program ParseCrittype, sclass
	syntax [, wt_type(string) 	///
		vce(string) 		///
		clusterv(string)]

	if (`"`wt_type'"'=="pweight" 		///
		| `"`vce'"' == "robust" |	///
		`"`clusterv'"'!="") {
		local crittype log pseudolikelihood
	}
	else {
		local crittype log likelihood
	}
	sret local crittype `crittype'
end
					//-- Ignore depvar which are not
					//selected --//	
program IgnoreDepvar
	syntax , depvar(string)		///
		seldepvar(string)	///
		tmp_depvar(string)	
	gen `tmp_depvar' = `depvar'
	replace `tmp_depvar' = . if !`seldepvar'
end
