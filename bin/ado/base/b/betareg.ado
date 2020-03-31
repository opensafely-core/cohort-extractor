*! version 1.2.1  19feb2019
program betareg, eclass byable(onecall) properties(swml svyb svyj svyr bayes)
	version 14.0
	if _by() {
		local by `"by `_byvars'`_byrc0':"'  
	}
	`by' _vce_parserun betareg, mark(CLuster) : `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"betareg `0'"'
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

				//------Playback---------//
program Playback
	syntax [,*]
	if "`e(cmd)'"!="betareg" {
		di as error "results for {bf:betareg} not found"
		exit 301
	}
	else {
		Display `0'
	}
end

				//-------Display---------//
program Display
	syntax [,                     			///
		noCONstant             			///  Model Options
		SCAle(string)          			///
		LInk(string)           			///
		SLInk(string)          			///
		CONSTraints(string)  			///
		vce(string)            			///
		Level(real 95)         			///
		DIFficult            			/// Maximization Options 
		TECHnique(string)      			///
		ITERate(real 1500)     			///
		NOLOg LOg                		///
		TRace                			///
		GRADient               			///
		showstep               			///
		HESSian              			///
		SHOWTOLerance        			///
		TOLerance(real 1e-6)   			///
		LTOLerance(real 1e-7)  			///
		NRTOLerance(real 1e-5) 			///
		noNRTOLerance        			///
		from(string)           			///
		*]                      		 // Display Options
	
						// parse display options
	_get_diopts diopts rest, `options'  
	OptionCheck, extra_option(`rest')
						// check level 
	CheckLevel, level(`level')

	if "`e(prefix)'" == "svy" {
		_prefix_display `0'
		exit
	}
						// table head
	Head 
						// coef table
	_coef_table,`diopts' level(`level')
	ml_footnote
end

program Head
//--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----
	di
	di as txt "Beta regression"			     ///
		_col(49) "Number of obs" 	_col(67) "=" ///
		_col(69) as res %10.0fc e(N)

	if !missing(e(N_reps)) {
		di as txt _col(49) "Replications" _col(67) "=" ///
			_col(69) as res %10.0fc e(N_reps)
	}
	
	if "`e(prefix)'" == "jackknife" {   	 	// Ftest
		di as txt _col(49) 			/// 
			"F(" 				///
			as res %4.0g e(df_m) 		///
			as txt "," 			///
			as res %7.0f e(df_r) as txt ")" ///
			_col(67) "=" _col(70) as res %9.5g e(F)

		di as txt _col(49) "Prob > F" 		///
			_col(67) "=" _col(70) as res %9.4f e(p)
	}
	else{							// Chi2 test
		di as txt _col(49) "`e(chi2type)' chi2({res:`e(df_m)'})" ///
			_col(67) "=" _col(70) as res %9.2f e(chi2)
		
		di as txt _col(49) "Prob > chi2" 			///
			_col(67) "=" _col(70) as res %9.4f e(p)
	}
	di
	
	if `"`e(crittype)'"'=="log likelihood" {
		local col_link	= 16
	}
	else {
		local col_link	= 22
	}
	di as txt "Link function" _col(`col_link') ":" 		///
		_skip(2) as res "g(u) = `e(linkf)'" 		///
		as txt _col(49) "[{res:`e(linkt)'}]" 

	di as txt "Slink function"  _col(`col_link') ":" 	/// 
		_skip(2) as res "g(u) = `e(slinkf)'" 		///
		as txt _col(49) "[{res:`e(slinkt)'}]" 
	di
	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + ///
		bsubstr(`"`e(crittype)'"',2,.)
	di as txt "`crtype'" _col(`col_link') "=" ///
		 as res %11.8g e(ll) 
	di
end

			//------------Estimate-----------//
program Estimate, eclass byable(recall) 
	// syntax
	syntax varlist(numeric fv ts) 			///
		[if] [in] [fw iw pw/] 			///
		[, 					///
		noCONstant             			/// Model Options
		SCAle(string)          			///
		LInk(string)           			///
		SLInk(string)          			///
		CONSTraints(string)  			///
		vce(string)            			///            
		Level(real 95)         			///
		DIFficult            			///Maximization Options
		TECHnique(string)      			///
		ITERate(real 1500)     			///
		NOLOg LOg                		///
		TRace                			///
		GRADient               			///
		showstep               			///
		HESSian              			///
		SHOWTOLerance        			///
		TOLerance(real 1e-6)   			///
		LTOLerance(real 1e-7)  			///
		NRTOLerance(real 1e-5) 			///
		NONRTOLerance        			///
		from(string)           			///
		moptobj(string)				/// not documented
		*]                     			//  Display Options        
	
	_get_diopts diopts rest, `options'
	OptionCheck, extra_option(`rest')
						// check level
	CheckLevel, level(`level')
						// check maximize options
	MaximizeOptionsCheck , technique(`technique') iterate(`iterate') ///
		tolerance(`tolerance') ltolerance(`ltolerance')          ///
		nrtolerance(`nrtolerance') `nonrtolerance'

						// marksample
	marksample touse
	qui sum `touse'
	NobsError,n(`r(sum)')
	
						// parse weight
	local wt_type `weight'
	local wt_exp `"`exp'"'
	if `"`weight'"'!="" {
		tempvar w
		qui gen double `w' =`exp' if `touse'
		local wgt [`weight'=`w']
	}
	else {
		local wgt 
	}
						// get indepvar and depvars
	gettoken depvar indepvars: varlist
	_fv_check_depvar `depvar'   
						// verify depvar in (0,1) 
	CheckDepvar `depvar' , touse(`touse')

						// parse indepvars
	ParseIndepvars `indepvars',`constant'
	local indepvars `"`s(indepvars)'"'
	local cons_indepvars "`s(cons_indepvars)'"
	local nocons_indepvars "`s(nocons_indepvars)'"

						// parse svars
	ParseSvars `scale'
	local svars `"`s(svars)'"'
	local cons_svars "`s(cons_svars)'"
	local nocons_svar "`s(nocons_svars)'"

						// n_const in two equations
	local n_const = 2
	if `"`cons_indepvars'"'=="" {
		local n_const = `n_const'-1  
	}
	if `"`cons_svars'"'=="" {
		local n_const = `n_const'-1
	}
	
						// remove collinearity and 
						// expand factor variables
						// rmcol for indepvars
	RemoveColl,vars(`indepvars') `nocons_indepvars' ///
		wgt(`wgt') touse(`touse')
	local indepvars `"`s(vars)'"'
						// rmcol for svars
	RemoveColl,vars(`svars') `nocons_svar'		///
		wgt(`wgt') touse(`touse')
	local svars `"`s(vars)'"'

						// markout missing values
	markout  `touse' `depvar' `indepvars' `svars' `w'

						// Few observation error
	qui sum `touse'
	NobsError,n(`r(sum)')
	
						// parse link and slink
	ParseLink, `link'
	local link `s(link)'
	local linkf `s(linkf)'
	local linkt `s(linkt)'
	ParseSlink, `slink'
	local slink `s(slink)'
	local slinkf `s(slinkf)' 
	local slinkt `s(slinkt)'  

						// set starting values 
	StartingValues, depvar(`depvar') indepvars(`indepvars') 	/// 
		svars(`svars') nocons_depvars(`nocons_indepvars')	///
		touse(`touse') link(`link') wgt(`wgt') slink(`slink') 	///
		nocons_svars(`nocons_svar')  wt_type(`wt_type')
	tempname b10 b20
	matrix `b10' = r(b10)
	matrix `b20' = r(b20)
						// parse vce
	ParseVce, vce(`vce') wgt(`wgt') wt_type(`wt_type')
	local vce `s(vce)'
	local vcetype `s(vcetype)'
	local clusterv `s(clusterv)'
	local clustdos `s(clusterv)'
						// markout missing clusterv
	if "`clusterv'"!="" {
		capture local sclust = string(`clusterv')
		if _rc!=0 {
			tempvar clustdos
			encode `clusterv', generate(`clustdos')
		}
	}
	markout `touse' `clustdos'
	
						// parse b V names
	ParseColnames, depvar(`depvar')	indepvars(`indepvars')		///
		sindepvars(`svars') cons_indepvars(`cons_indepvars') 	///
		cons_svars(`cons_svars')  
	local coef_label `s(coef_label)'

						// parse constraints
	tempname k_autoCns Cns
	ParseConstraints `constraints', coef_label(`coef_label')
	if `"`e(Cns)'"'=="matrix" { 
		matrix `Cns'      = e(Cns)   
		scalar `k_autoCns'= e(k_autoCns) 
	}
	else {
		scalar `k_autoCns'= 0
	}
	
						// parse from
	if `"`from'"'!="" {
		tempname b_from
		_mkvec `b_from', from(`from') colnames(`coef_label')
	}


	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'`s(log)'"
						// Estimation
	tempname ll ll_0 chi2type
	mata: _BETAREG_estimate("`depvar'", 		/// Model Options 
		"`indepvars'",			///
		"`touse'", 			///  
		"`svars'", 			///
		"`link'", 			///
		"`slink'", 			///
		"`cons_indepvars'", 		///
		"`cons_svars'", 		/// 
		"`vce'", 			///
		"`clusterv'", 			///
		"`wt_type'", 			///
		"`w'",	 			///
		"`Cns'", 			/// 
		"`difficult'", 			///  Maximization Options
		"`technique'", 			///
		`iterate', 			///
		"`log'", 			///
		"`trace'", 			///
		"`gradient'", 			///
		"`showstep'", 			///
		"`hessian'", 			///
		"`showtolerance'", 		///
		`tolerance', 			///
		`ltolerance', 			///
		`nrtolerance', 			///
		"`nonrtolerance'", 		///
		"`b_from'", 			///
		"`ll'", 			///
		"`ll_0'" , 			///
		"`chi2type'", 			///
		"`b10'", 			///
		"`b20'")

						// hidden
	ereturn hidden scalar k_autoCns = `k_autoCns'

	ereturn local linkf `linkf'
	ereturn local linkt `linkt'
	ereturn local slinkf `slinkf'
	ereturn local slinkt `slinkt'

	ereturn local title "Beta regression"
	ereturn local wtype `wt_type'
	ereturn local wexp `wt_exp'
	ereturn hidden local link `link'
	ereturn hidden local slink `slink'
	ereturn local clustvar `clusterv'
	ereturn local vce `vce'
	ereturn local vcetype `vcetype'
	ereturn local depvar `depvar'
	ereturn local cmdline `0'
	ereturn local predict "betareg_p"
	ereturn local marginsok "default CMean CVARiance xb XBSCAle"
	ereturn local marginsnotok "stdp SCores"
	ereturn hidden local marginsderiv default CMean
	ereturn scalar ll         = `ll'
	ereturn scalar ll_0       = `ll_0'
	ereturn scalar k_eq_model = 2
	ereturn scalar df_m       = e(rank)-`n_const'
						//  compute LR or Wald    
	local chi2type=`chi2type'
	ComputeChi2,chi2type(`chi2type') 	///
		indepvars(`indepvars') 		/// 
		svars(`svars') 			///
		constraints(`constraints')
	ereturn scalar chi2 = r(chi2)
	ereturn scalar p    = r(p)
	ereturn local chi2type `r(chi2type)'
						// Display Estimation Results 
	Display, `diopts' level(`level') `coef'
	ereturn local cmd "betareg"
end

program define CheckLevel
	syntax [, level(real 95)]
	if `level'<10 | `level' > 99.99 {
		di as err " {bf:level()} must be between 10 and 99.99 inclusive"
		exit 198
	}
end

program define MaximizeOptionsCheck
	syntax  [,			///
		TECHnique(string)      	///
		ITERate(real 1500)     	///
		TOLerance(real 1e-6)   	///
		LTOLerance(real 1e-7)  	///
		NRTOLerance(real 1e-5) 	///
		NONRTOLerance        	///
		]
	
	opts_exclusive "nrtolerance() `nonrtolerance'"
							// iterate	
	if `iterate' < 0 {
		di as error "{bf:iterate()} must be a nonnegative integer"
		exit 125
	}
							// nrtolerance
	if `nrtolerance' < 0 {
		di as error "{bf:nrtolerance()} should be nonnegative"
		exit 198
	}
							// tolerance	
	if `tolerance' < 0 {
		di as error "{bf:tolerance()} should be nonnegative"
		exit 198
	}
							// ltolerance
	if `ltolerance' < 0 {
		di as error "{bf:ltolerance()} should be nonnegative"
		exit 198
	}
							// technique
	ml_technique , technique(`technique')
end


program define StartingValues, rclass
	syntax [ , 				///
		depvar(string) 			///
		indepvars(string) 		///
		svars(string) 			/// 
		nocons_depvars(string) 		///
		nocons_svars(string) 		///
		touse(string) 			///
		link(string) 			///
		wgt(string) 			///
		slink(string)			///
		wt_type(string)			///
		]

						// b10 for cmean equation
	tempvar yt yt_p mu
	if `"`link'"'=="logit" {
		qui gen double `yt'=logit(`depvar') 
	}
	else if `"`link'"'=="probit" {
		qui gen double `yt'=invnormal(`depvar')
	} 
	else if `"`link'"'=="cloglog" {
		qui gen double `yt'=cloglog(`depvar')
	} 
	else if `"`link'"'=="loglog" {
		qui gen double `yt'=-log(-log(`depvar'))
	}

	qui regress `yt' `indepvars' if `touse' `wgt', `nocons_depvars'       
	qui predict double `yt_p' if `touse'
	
	if `"`link'"'=="logit" {
		qui gen double `mu' = exp(`yt_p')/(1+exp(`yt_p')) 
	}
	else if `"`link'"'=="probit" {
		qui gen double `mu'=normal(`yt_p')
	}
	else if `"`link'"'=="cloglog" {
		qui gen double  `mu'= -expm1(-exp(`yt_p'))
	}
	else if `"`link'"'=="loglog" {
		qui gen double `mu'=exp(-exp(-`yt_p')) 
	}

	tempname b10
	matrix `b10'=e(b)
	return matrix b10 `b10'
						// b20 for cvar equation
	tempvar phi phit
	tempname var
	if `"`wt_type'"' == "fweight" {
		qui sum `depvar' if `touse' `wgt'
	}
	else {
		qui sum `depvar' if `touse'
	}
	scalar  `var'= r(Var)
	
	qui gen double `phi'= ((`mu'*(1-`mu'))/(`var'))-1
	if `"`slink'"'=="identity" {
		qui gen double `phit'=`phi'
	}
	else if `"`slink'"'=="log" {
		qui gen double `phit'=log(`phi')
	}
	else if `"`slink'"'=="root" {
		qui gen double `phit'=sqrt(`phi')
	}
	
	qui regress `phit' `svars' if `touse' `wgt', `nocons_svars'
	tempname b20
	matrix `b20'= e(b)
	return matrix b20 `b20'
	ereturn clear
end

				//------compute chi2---//
program define ComputeChi2, rclass
	syntax [,			///
		chi2type(string) 	///
		indepvars(string) 	///
		svars(string) 		/// 
		constraints(string)	///
		]
	if `"`chi2type'"'=="LR" & `"`constraints'"'=="" {
		tempname chi2
						// LR test
		scalar `chi2'   = 2*(e(ll)-e(ll_0))
		ret scalar chi2 = `chi2'
		ret scalar p    = chi2tail(e(df_m),`chi2')
		ret local chi2type "LR"
	}
	else if !(`"`indepvars'"'=="" & `"`svars'"'=="") {
		qui test `indepvars' `svars'
		tempname chi2 p
		scalar `chi2'   = r(chi2)
		scalar `p'      = r(p)
		return clear 
		ret scalar chi2 = `chi2'
		ret scalar p    = `p'
		ret local chi2type "Wald"
	}
end

		//-------check interval of depvar-------------//
program define CheckDepvar, sclass
	capture noisily {
		syntax varname(numeric) , touse(string)
	}	
	if _rc == 101 {
		di as err "    Dependent variables may not contain " ///
			"time series" 
		di as err "    or factor variable operators"
		exit _rc
	}
	else if _rc == 109 {
		di as err "    Dependent variables may not be string"
		exit _rc
	}
	else if _rc != 0{
		exit _rc
	}

	qui sum `varlist' if `touse' 
	if r(min)<=0 | r(max)>=1 {
		di as err "{bf:`varlist'} must be greater " /// 
			"than zero and less than one"
		exit 459
	}
	if r(sd) == 0 {
		di as err "dependent variable does not vary"
		exit 2000
	}
end

		//----------remove collinearity and expand fv--------//
program define RemoveColl,sclass
	syntax [,vars(string) noCONstant wgt(string) touse(string)] 
	if `"`vars'"'!="" {
		_rmcoll `vars' `wgt' if `touse', expand `constant'  
		sreturn local vars `r(varlist)'
	}
	else {
		sreturn local vars
	}
end

		//--------ParseColnames-------//
program define ParseColnames,sclass
	syntax ,[depvar(string) 	///
		indepvars(string) 	///
		sindepvars(string) 	///
		cons_indepvars(string) 	///
		cons_svars(string)]
	// construct colnames for b and V
	local eq1_name `depvar'
	local eq2_name scale
	local b1_names
	foreach var in `indepvars' `cons_indepvars' {
		local b1_names   = `"`b1_names' `eq1_name':`var'"'  
	}
	local b2_names
	foreach var in `sindepvars' `cons_svars' {
		local b2_names   = `"`b2_names' `eq2_name':`var'"'
	}
	sreturn local coef_label = `"`b1_names' `b2_names'"'
end

			//------------ParseConstraints--------//
program define ParseConstraints,eclass
	syntax [anything(name=constraints)], coef_label(string)	///
	
	local k : word count `coef_label'
	// dummy estimation to construct constraint
	tempname b V
	matrix `b'	    = J(1,`k',1)  
	matrix `V'          = `b''*`b'
	matrix colnames `b' = `coef_label'
	matrix colnames `V' = `coef_label'
	matrix rownames `V' = `coef_label'
	ereturn post `b' `V'
	
	makecns `constraints'
	eret scalar k_autoCns=r(k_autoCns)  
end

			//------ParseLink-------------------//
program define ParseLink, sclass
	syntax [, 		///
		logit		///
		PROBit		///
		CLOGlog		///
		LOGLog		///
		*]
	
	local rest `options'
	local link `logit' `probit' `cloglog' `loglog' `options'
							// unrecognized link	
	if `"`rest'"' != "" {
		di as error "unrecognized {bf:link()} function: `rest'"
		exit 199 
	}
							// more than one link	
	capture {
		qui opts_exclusive "`logit' `probit' `cloglog' `loglog'"
	}
	if _rc != 0 {
		di as error "only one of logit, probit, cloglog, or loglog" ///
			" is allowed"
		exit 198
	}
	
	if "`link'" == "" {
		sreturn local link "logit"		
	}
	else {
		sreturn local link `"`link'"'
	}
	
	if `"`link'"'=="logit" | `"`link'"'=="" {
		sreturn local linkf `"log(u/(1-u))"'  
		sreturn local linkt "Logit"
	}
	else if `"`link'"'=="probit" {
		sreturn local linkf `"invnormal(u)"'  
		sreturn local linkt "Probit"
	}
	else if `"`link'"'=="cloglog" {
		sreturn local linkf `"log(-log(1-u))"'  
		sreturn local linkt "Comp. log-log"
	}
	else if `"`link'"'=="loglog" {
		sreturn local linkf `"-log(-log(u))"' 
		sreturn local linkt "Log-log"
	}
end

			//--------------ParseSlink---------------//
program define ParseSlink,sclass
	syntax [,		///
		log		///
		root		///
		IDENtity	///
		*]	

	local rest `options'
	local slink `log' `root' `identity' 
							// unrecognized slink	
	if `"`rest'"' != "" {
		di as error "unrecognized {bf:slink()} function: `rest'"
		exit 199 
	}
							// more than one link	
	capture {
		qui opts_exclusive "`identity' `root' `log'"
	}
	if _rc != 0 {
		di as error "only one of log, root, or identity" ///
			" is allowed"
		exit 198
	}

	if "`slink'" == "" {
		sreturn local slink "log"		
	}
	else {
		sreturn local slink `"`slink'"'
	}
	
	if `"`slink'"'=="log" | `"`slink'"'=="" {
		sreturn local slinkf `"log(u)"' 
		sreturn local slinkt "Log"
	}
	else if `"`slink'"'=="root" {
		sreturn local slinkf `"sqrt(u)"'  
		sreturn local slinkt "Square root"
	}
	else if `"`slink'"'=="identity" {
		sreturn local slinkf `"u"'  
		sreturn local slinkt "Identity"
	}
end
				//---------ParseSvars-----//
program define ParseSvars, sclass
	syntax [varlist(default=none numeric fv ts)] [, noCONstant]
	
	if `"`varlist'"'=="" & `"`constant'"'=="noconstant" {
		di as err "one or more variables must be " 	///
			"specified in {bf:scale()} " 
		di as err "option when the {bf:nonconstant} "	///
			"suboption is specified"
		exit 198
	}
	if `"`constant'"'!="noconstant" { 
		sreturn local cons_svars "_cons"
	}
	else {
		sreturn local cons_svars ""
	}
	sreturn local svars `varlist'
	sreturn local nocons_svars `constant'
end

				//---------ParseIndepvars-----//
program define ParseIndepvars, sclass
	syntax [varlist(default=none numeric fv ts)] [, noCONSTant]
	
	if `"`varlist'"'=="" & `"`constant'"'=="noconstant" {
		di as err "one or more variables must be "	///
			"specified in {it:indepvars} " 
		di as err "when the option {bf:nonconstant} "	///
			"is specified"
		exit 198
	}
	if `"`constant'"'!="noconstant" { 
		sreturn local cons_indepvars "_cons"
	}
	else {
		sreturn local cons_indepvars ""
	}
	sreturn local indepvars `varlist'
	sreturn local nocons_indepvars `constant'
end


				//-------ParseVce-----//
program define ParseVce , sclass
	syntax [, vce(string) wgt(string) wt_type(string)]

	local w: word count `vce'
	
	if `w'==0 {
		sreturn local vce oim
		sreturn local vcetype 
	}
	else {
		_vce_parse, argopt(CLuster) opt(OIM Robust) 	///
			pwallowed(Robust CLuster)  		///
			: `wgt', vce(`vce') 
		local vce
		if "`r(cluster)'" !="" {
			sreturn local clusterv `r(cluster)'
			sreturn local vce cluster
			sreturn local vcetype Robust  
		} 
		else if "`r(vce)'"=="robust" {
			sreturn local vce robust
			sreturn local vcetype Robust
		}
		else if "`r(vce)'"=="oim" {
			sreturn local vce oim
			sreturn local vcetype
		}
	}
	
					// pweight implied robust weight
	if `"`wt_type'"'=="pweight" {
		if `"`r(cluster)'"' != "" {
			sreturn local vce cluster
		}
		else {
			sreturn local vce robust
		}
		sreturn local vcetype Robust
	}
end


program define NobsError
	syntax ,n(integer)
	if `n'<=1 {
		di as err "insufficient observations"
		exit 2001
	}
end

program define OptionCheck
	syntax , [extra_option(string)]
	if `"`extra_option'"'!="" {
		di as err `"option {bf:`extra_option'} not allowed"'
		exit 198
	}
end
