*! version 1.4.2  12aug2019
program define _vecu, eclass sort
	version 8.1

local m1 = _N
	syntax varlist(ts numeric) [if] [in]		///
		,					///
		[   					///
		LTOLerance(numlist max=1 )		///
		TOLerance(numlist max=1)		///
		ITERate(numlist max=1 integer )		///
		Trend(string)				///
		Lags(numlist integer max=1 >0 <`m1')	///
		SIndicators(varlist numeric)    	///
		Seasonal				///
		VRank					///
		VEst					///
		Rank(integer 1 )			///
		noTRace					///
		Max					///
		Ic					///
		level99					///
		levela					///
		BConstraints(string)			///
		AConstraints(string)			///
		AFrom(name)				///
		BFrom(name)				///
		NOLOg LOg				///
		btrace					///
		toltrace				///
		noreduce				///
		]

// vrank is switch for running vecrank
// vest is switch for running vec

	_vectparse ,`trend'	
	local trend "`r(trend)'"
	
	local trends : word count `trend'
	if `trends' > 1 {
		di as err "only one {cmd:trendtype} may be "	///
			"specified in {cmd:trend()}"
		exit 198
	}	

	if "`seasonal'" != "" & "`trend'" == "none" {
		di as err "{cmd:seasonal} cannot be specified "	///
			"with {cmd:trend(none)}"
		exit 198	
	}

	if "`seasonal'" != "" & "`trend'" == "rconstant" {
		di as err "{cmd:seasonal} cannot be specified "	///
			"with {cmd:trend(rconstant)}"
		exit 198	
	}

	if "`sindicators'" != "" & "`trend'" == "none" {
		di as err "{cmd:sindicators()} cannot be specified "	///
			"with {cmd:trend(none)}"
		exit 198	
	}

	if "`sindicators'" != "" & "`trend'" == "rconstant" {
		di as err "{cmd:sindicators()} cannot be specified "	///
			"with {cmd:trend(rconstant)}"
		exit 198	
	}

	if "`lags'" == "" {
		local lags 2
	}	
		
	qui tsset, noquery
	local tvar "`r(timevar)'"
	local tsfmt "`r(tsfmt)'"
	local stype "`r(unit1)'"

	if "`r(timevar)'" == "" {
		di as err "dataset is not properly {help tsset}"
		exit 498
	}	

	marksample touse

	tempvar touse2
	qui gen byte `touse2' = (`touse' & L`lags'.`touse'<.)
	local p = `lags'
	local pm1 = `p' - 1

	if "`sindicators'" != "" & "`seasonal'" != "" {	
		di as err "sindicators() and seasonal may not both "	///
			"be specified"
		exit 498
	}

//	parse  alpha and beta constraints 

	if "`vest'" == "" & "`aconstraints'`bconstraints'" != "" {
		di as err "constraints are not allowed when determining " ///
			"the cointegrating rank"
		exit 498
	}

	markout `touse' `tvar'

// deal with collinearity 

	qui _rmcoll `varlist' if `touse'
	local rm_vlist "`r(varlist)'"
	local clean : list rm_vlist == varlist
	if `clean' != 1 {
		di as err "the endogenous variables are perfectly collinear"
		di as err "{p 4 4 2}a list of noncollinear variables "	///
			"is{p_end}"
		di as err "{p 8 8 2}`rm_vlist'{p_end}"
		exit 459
	}	

	if "`reduce'" == "" {
		vec_rmcoll `varlist' , touse(`touse') p(`p') rmcoll
		local varlist "`r(varlist)'"
		local p = r(p)
		local pm1 = `p' - 1
		local reduced "`r(reduced)'"
	
		vec_rmcoll `varlist' , touse(`touse') p(`p')
		local varlist "`r(varlist)'"
		local p = r(p)
		local pm1 = `p' - 1
		local reduced "`reduced' `r(reduced)'"

		vec_rmcoll `varlist' , touse(`touse') p(`p') ownonly
		local varlist "`r(varlist)'"
		local p = r(p)
		local pm1 = `p' - 1
		local reduced "`reduced' `r(reduced)'"

		local reduced : list uniq reduced
	}
	else {

	}

	if "`sindicators'" != "" {
		_rmcoll `sindicators'
		local sindicators "`r(varlist)'"
	}

	local ck_vlist0 "`varlist' `sindicators'"
	qui _rmcoll `ck_vlist0'
	local ck_vlist1 "`r(varlist)'"

	local ck_vlist2 : list ck_vlist0 == ck_vlist1
	if `ck_vlist2' != 1 {
		di as err "{p 0 4 4}at least one of the "	///
			"seasonal indicator variables is "	///
			"perfectly collinear with at least "	///
			"one of the dependent variables{p_end}"
		exit 498	
	}

// z2base is defined here to get e(sample) right now

	if `pm1' > 0 {
		tsunab z2base : l(1/`pm1').d.(`varlist') 
		markout `touse' `z2base'
	}
	else {
		markout `touse' d.(`varlist')
		local z2base
	}

	local K : word count `varlist' 
	local Kp1 = `K' + 1
	
	if "`vest'" != "" {
		if `rank' >= `K' {
			di as err "rank() must be less than `K'"
			exit 498
		}	
		forvalues i=1/`rank' {
			capture confirm new variable _ce`i'
			if _rc > 0 {
				di as txt "dropping _ce`i'"
				drop _ce`i'
			}	
		}
	}

	qui sum `tvar' if `touse'

	local tmin = r(min)
	local tmax = r(max)

	local tmins : di `tsfmt' `tmin'
	local tmaxs : di `tsfmt' `tmax'

// create seasonal tempvars if needed 

	if "`seasonal'" != "" {

//  never include a full set
		if "`trend'" == "none" {
			local tconstant 
		}
		else {
			local tconstant 
		}

		_vecmksi , stype(`stype') timevar(`tvar')	///
			touse(`touse') `tconstant'

		local sindicators "`r(vlist)'"
		global S_DROP_sindicators "`r(vlist)'"
		local s_names "`r(vlist)'"	
		local ns = r(ns)
	}
	else {
		if "`sindicators'" != "" { 
			local s_names "`sindicators'"	
			local ns : word count `sindicators'
		}
		else {
			local ns 0
		}	
	}

	if "`r(panelvar)'" != "" {
		qui sum `r(panelvar)' if `touse' 
		if r(min) < r(max) {
			di as err "sample contains more than one panel"
			exit 498
		}
	}
	
	qui tsreport if `touse' ==1 	

	if r(N_gaps) > 0 {
		di as err "the sample has gaps"
		exit 498
	}

// form model and make auxiliary variables

	if "`trend'" == "none" {
		local dt ""
		local dt_names ""
		
		local nz1 = `K'
		local nz2 = (`K'*`pm1' + `ns')
		local tterms = `ns'
	}

	if "`trend'" == "rconstant" {
		tempvar mu 
		qui gen double `mu' = 1 if `touse'
		local z1ex `mu'
		local z1exn _cons

		local nz1 = `K'+1
		local nz2 = (`K'*`pm1' + `ns')
		local tterms = `ns'
	}

	if "`trend'" == "constant" {
		tempvar mu
		qui gen double `mu' = 1
		local dt `mu'
		local dt_names "_cons"

		local nz1 = `K'
		local nz2 = (`K'*`pm1' + 1 + `ns')
		local tterms = `ns' + 1
	}
	
	if "`trend'" == "rtrend" {
		tempvar mu 
		qui gen double `mu' = 1 if `touse'

		_vecmktrend if `touse', nvecyet tvar(`tvar') 	///
			tmin(`tmin')

		local dt `mu'
		local z1ex _trend
		local z1exn _trend
		local dt_names "_cons"

		local nz1 = `K' + 1
		local nz2 = (`K'*`pm1' + 1 + `ns')
		local tterms = `ns' + 1
	}

	if "`trend'" == "trend" {
		tempvar mu 
		qui gen double `mu' = 1 if `touse'
		_vecmktrend if `touse', nvecyet tvar(`tvar') 	///
			tmin(`tmin')
		local dt _trend `mu'
		local dt_names "_trend _cons"

		local nz1 = `K' 
		local nz2 = (`K'*`pm1' + 2 + `ns')
		local tterms = `ns' + 2
	}

/* make varlists for Z_0t, Z_1t, Z_2t */

	tsunab z0t : d.(`varlist')		// z0t contains K vars

	tsunab endog_vars : `varlist'	
	local endog_names : subinstr local endog_vars "." "_" , all		

	tsunab z1tb : l.(`varlist') 
	local z1t `z1tb' `z1ex'			// z1t contains K vars
						// or K+1 when 
						// trend == "rtrend"
						// or trend == "rconstant"

	local z1tn `z1tb' `z1exn'		// names for z1t
	
	local K1 : word count `z1t'

	local z2t `z2base' `sindicators' `dt' 
	local z2t_names  `z2base' `s_names' `dt_names'
	local COVAR : list z2t - dt
				// z2t contains K2 = (p-1)*K + m vars

	local K2 : word count `z2t'

	local z3t `sindicators' `dt' 
	local z3t_names  `s_names' `dt_names'
				// z3t contains K3 =  m vars
	local K3 : word count `z3t'

	local parms_smp =(`K'*`nz2'+(`K'+`nz1'-`rank')*`rank')
	local df_smp = int(`parms_smp'/`K')

	qui count if `touse' > 0
	if r(N) <= `df_smp'  {
		local smp_obs = r(N)
		di as err "there are too many parameters in the model"
		di as err "{p}the model uses up `df_smp' "	///
			"degrees of freedom, but there are "	///
			"only `smp_obs' observations{p_end}"
		exit 498
	}

	if `K2' > 0 {
// Partial-out Z2

		local i 0
		foreach var of local z0t {
			local ++i
			tempvar r0t_`i' 
			qui regress `var' `z2t' if `touse', nocons
			qui predict double `r0t_`i'' if `touse', res
			local r0t `r0t' `r0t_`i''
		}

		local i 0
		foreach var of local z1t {
			local ++i
			tempvar r1t_`i' 
			qui regress `var' `z2t' if `touse', nocons
			qui predict double `r1t_`i'' if `touse', res
			local r1t `r1t' `r1t_`i''
		}
	}
	else {
		local r0t `z0t'
		local r1t `z1t'
	}

// Get s## matrices and T

	tempname s00 s01 s10 s11 T
	Getsmats , r0t(`r0t') r1t(`r1t') touse(`touse')		///
		s00(`s00') s01(`s01') s10(`s10') s11(`s11')  	///
		t(`T') k(`K')

/* pieces used by optimization with and without constraints */

	forvalues j = 1/`rank' {
		local ce_lab `ce_lab' _ce`j'
	}

	foreach nm of local ce_lab {
		local Lce_lab "`Lce_lab' L.`nm' "
	}

// do unconstrained Johansen method

	tempname alpha omega lam beta

	capture noi Johansen , alpha(`alpha') beta(`beta') 	///
		omega(`omega') lam(`lam') s10(`s10') 		///
		s01(`s01') s11(`s11') s00(`s00')
	if _rc > 0 {
		DerrMsg
		exit _rc
	}

// diffvarlist holds the first differenced varlist of endogenous variables
// diffvarlist2 holds the equation name version of diffvarlist

	tsunab tsvarlist : `varlist'
	tsunab diffvarlist : D.(`tsvarlist')
	tsunab lagvarlist : L.(`tsvarlist')

// this method assumes that there is only period in each token
	local diffvarlist2 : subinstr local diffvarlist "." "_" , all
	local tsvarlist2 : subinstr local tsvarlist "." "_" , all

	mat colnames `omega' = `tsvarlist'
	mat rownames `omega' = `tsvarlist'

	tempname ll llvals smat1 smat2 llcons parms
	forvalues i = 1/`K' {
		mat `llvals' = (nullmat(`llvals') \ ln1m(`lam'[1,`i']) )
		mat `parms'  = (nullmat(`parms') \ 		///
			(`K'*`nz2'+(`K'+`nz1'-`i')*`i') )
	}

	mat `llvals' = (0 \ `llvals' )
	mat `parms'  = (`K'*`nz2' \ `parms')' 

	ltriang , mat(`smat1') dimen(`Kp1') value(1)

	scalar `llcons' = 						///
		(- .5*`T'*`K'*ln(2*_pi)-.5*`T'*ln(det(`s00'))-.5*`T'*`K')
	mat `ll' = J(`Kp1',1,1)*`llcons'
	
	mat `ll' = `ll' -.5*`T'*`smat1'*`llvals' 
	mat `ll' = `ll''

	tempname aic bic hqic 
	
	matrix `aic'  = J(1,`K'+1,.)
	matrix `bic'  = J(1,`K'+1,.)
	matrix `hqic' = J(1,`K'+1,.)

	MKic `aic' `bic' `hqic' `ll' `parms' `T'

	if "`trend'" == "rconstant" | "`trend'" == "rtrend" {
		mat `lam' = `lam'[1,1..colsof(`lam')-1]
		mat `alpha' = `alpha'[1...,1..colsof(`alpha')-1]
	}	
	
	if "`vest'" == "" {

		tempname tracem maxm ctrace
	
		mat `maxm' = -1*`T'*ln1m(`lam'[1,1])
		mat `ctrace' = J(`K',1,1)

		forvalues i = 2/`K' {
			local r1 = `i' -1
			local r2 = `K'-`i'+1
			
			mat `maxm' = `maxm', -1*`T'*ln1m(`lam'[1,`i'])
			mat `ctrace'   = ( `ctrace', (J(`r1', 1, 0) \ 	///
				J( `r2',1,1) ) )
		}

		mat `tracem' = `maxm'*`ctrace'
	
// compute rank selected by different methods
	
		tempname cv95 cv99 cvc95 cvc99
		_vecgetcv `trend'
		mat `cv95' = r(cv95)
		mat `cv99' = r(cv99)
		
		_vecgtn `trend'
		local trendnumber = r(trendnumber)
	
		local cvcols = colsof(`tracem') 
	
		forvalues i = `cvcols'(-1)1 {
			mat `cvc95' = (nullmat(`cvc95'), 	///
				`cv95'[`i',`trendnumber'] )
			mat `cvc99' = (nullmat(`cvc99'),	///
				`cv99'[`i',`trendnumber'] )	
		}

// find rank selected by Johansen sequential trace tests
	
		foreach cval in 95 99 {
			local r_`cval' = -1 
			local row`cval' = 0
			while (`r_`cval'' < 0 & `row`cval'' < `cvcols' ) {
				local ++row`cval'
				if `tracem'[1,`row`cval''] <=		///
					`cvc`cval''[1,`row`cval''] {
					local r_`cval' = `row`cval''
				}
			}
		
			if `r_`cval'' < 0 local r_`cval' = .
		}
	
// find rank selected by IC 
	
		tempname icmin
	
		foreach icf in bic hqic {
			scalar `icmin' = ``icf''[1,1]
			local r_`icf' 1
			forvalues i = 2/`cvcols' {
				if ``icf''[1,`i'] < `icmin' {
					scalar `icmin' = ``icf''[1,`i']
					local r_`icf' `i'
				}	
			}
		}
	
		local cnames0
		local Km1 = `K' - 1
		forvalues i = 0/`Km1'  {
			local cnames0 "`cnames0' `i'_ce "
		}

		local cnames1
		forvalues i = 1/`K'  {
			local cnames1 "`cnames1' `i'_ce "
		}

		local cnames2
		forvalues i = 0/`K'  {
			local cnames2 "`cnames2' `i'_ce "
		}

		matrix rownames `maxm' = max
		matrix rownames `tracem' = trace
		matrix rownames `lam' = eigenvalues
		matrix rownames `parms' = parameters
		matrix rownames `bic' = SBIC
		matrix rownames `hqic' = HQIC
		matrix rownames `aic' = AIC
		matrix rownames `ll' = LL
		
		matrix colnames `maxm' = `cnames0'
		matrix colnames `tracem' = `cnames0'
		matrix colnames `lam' = `cnames1'
		matrix colnames `parms' = `cnames2'
		matrix colnames `bic' = `cnames2'
		matrix colnames `hqic' = `cnames2'
		matrix colnames `aic' = `cnames2'
		matrix colnames `ll' = `cnames2'
	
		ereturn clear
	
// save off e() for vecrank 
	
		eret mat ll      `ll'
		eret mat aic     `aic'
		eret mat sbic    `bic'
		eret mat hqic    `hqic'
		eret mat k_rank  `parms'
		
		eret mat lambda `lam'

		eret mat trace `tracem'
		eret mat max `maxm'
	
		eret scalar N      = `T'
		eret scalar k_eq      = `K'
		eret scalar k_dv      = `K'
		eret scalar n_lags = `p'
		eret scalar tmin   = `tmin'
		eret scalar tmax   = `tmax'
	
		eret scalar k_ce95   = `r_95' - 1
		eret scalar k_ce99   = `r_99' - 1
		eret scalar k_cesbic  = `r_bic' - 1
		eret scalar k_cehqic = `r_hqic' - 1
		
		eret local trend  "`trend'"
		eret local tsfmt  "`tsfmt'"

		if "`seasonal'" != "" {
			eret local seasonal "`stype'"
		}	
		else if "`sindicators'" != "" {
			eret local sindicators "`sindicators'"
		}	

		if "`reduce'" != "" {
			eret local reduce_opt `reduce'
		}
		eret local reduce_lags "`reduced'"
		
		eret local cmd    "vecrank"

		exit 
	}

	if "`vest'" != "" {
		if "`afrom'" != "" {

			cap noi confirm matrix `afrom'
			if _rc  {
				di as err "afrom(`afrom') does not "	///
					"specify a matrix"
				exit 198
			}

			tempname alpha_st alpha_stp
			mat `alpha_st' = J(`K',`rank',0)
			local acols = `K'*`rank'
			mat `alpha_stp' = `afrom''

			capture va2a , vec_alphap(`alpha_stp') alpha(`alpha_st')
			if _rc > 0 {
				di as err "starting value vector for "	///
					"alpha does not have the "	///
					"correct dimension"
				di as err "starting value vector for "	///
					"alpha must be 1 by `acols'"
				exit 498	
			}
		}

		if "`bfrom'" != "" {

			cap noi confirm matrix `bfrom'
			if _rc  {
				di as err "bfrom(`bfrom') does not "	///
					"specify a matrix"
				exit 198
			}

			tempname beta_st beta_stp
			mat `beta_st' = J(`nz1',`rank',0)
			local bcols = `nz1'*`rank'
			mat `beta_stp' = `bfrom''

			capture vb2b , vecbeta(`beta_stp') beta(`beta_st')
			if _rc {
				di as err "starting value vector for "	///
					"beta does not have the "	///
					"correct dimension"
				di as err "starting value vector for "	///
					"beta must be 1 by `bcols'"
				exit 498	
			}		
		}

		tempname beta2 temp tempb beta_v alpha2 betab

// section for with and without constraints

		tempname beta2m b betaJ alphaJ omegaJ

// betab contains r, unidentified cointegrating vectors 

		mat `betab' = `beta'[1...,1..`rank']
		mat `betab' = syminv(`betab''*`betab')

// identification check

		local r_cnt 0
		forvalues i = 1/`rank' {
			if `betab'[`i', `i'] > 1e-15 	{
				local ++r_cnt
			}	
		}
		
		if `r_cnt' < `rank' {
			di as err "the parameters of the "	///
				"cointegrating equations are "	///
				"not identified by the sample"
			di as err "check your sample and the "	///
				"number of lags specified"
			exit 498	
		}

// section without constraints
	
// beta2 is Johansen identified beta
// betaJ is Johansen identified beta

		mat `beta2' = `beta'[1...,1..`rank']*			///
			inv((I(`rank'),J(`rank',			///
			colsof(`beta')-`rank',0))* 			///
			`beta'[1...,1..`rank'])

		mat colnames `beta2' = `ce_lab'
		mat rownames `beta2' = `varlist' `z1exn'
		mat `betaJ' = `beta2'
	
// alpha2 is Johansen identified alpha
// alphaJ is Johansen identified alpha

		mat `alpha2' = `s01'*`beta2'*syminv(`beta2''*`s11'*`beta2')

		mat colnames `alpha2' = `ce_lab'
		mat rownames `alpha2' = `varlist'
		mat `alphaJ' = `alpha2'

		mat `omega' =( `s00' - `alpha2'*`beta2''*`s01'')

		mat colnames `omega' = `diffvarlist2'
		mat rownames `omega' = `diffvarlist2'

// omegaJ is Johansen identified omega
		mat `omegaJ' = `omega'

// section with constraints
// make constraints on alpha or beta 

		if "`aconstraints'`bconstraints'" != "" {

			local constraints constraints
			if "`aconstraints'" != "" {
				tempname gmat tmat jmat
		
				mkcns , rownames(`diffvarlist2')	///
					colnames(`Lce_lab') 		///
					cmat(`gmat') amat(`tmat')	///
					constraints(`aconstraints')	///
					transpose

				mat `jmat' = J(rowsof(`tmat'), 		///
					colsof(`tmat'), 0)
				if mreldif(`tmat', `jmat') > 1e-16 {
					di as err "restrictions on alpha " ///
						"are not homogeneous"
					exit 498
				}

				local nacns = r(k)
				local acnsmac "`r(cns1)'"
				forvalues j = 2/`nacns' {
					local acnsmac "`acnsmac':`r(cns`j')'"
				}
	
			}
			else {
				local gmat NONE
			}
	
			if "`bconstraints'" != "" {
				tempname hmat amat rmat
		
				mkcns , rownames(`endog_vars' `z1exn')	///
					colnames(`ce_lab') 		///
					cmat(`hmat') 			///
					constraints(`bconstraints')	///
					amat(`amat') rmat(`rmat')

				local nbcns = r(k)
				local bcnsmac "`r(cns1)'"
				forvalues j = 2/`nbcns' {
					local bcnsmac "`bcnsmac':`r(cns`j')'"
				}
			}
			else {
				local hmat NONE
				local amat NONE
			}

//  get starting values here 

			tempname part1 part2i rkpart2 part2 temp vecs vals 
			tempname betao0 vps2 oi iter_n converge

			if "`beta_st'" != "" {
				local bstarts *
				mat `beta2' = `beta_st'
			}

			mat `oi' = syminv(`omega')
			mat `vps2' = vec((`s01'*inv(`s11'))')

			if "`alpha_st'" != "" {
				local astarts *
				mat `alpha2' = `alpha_st'
			}
			else {
				if "`gmat'" != "NONE" {
					GetAlpha , 			///
						gmat(`gmat')		///
						omegai(`oi')		///
						beta(`beta2')		///
						s11(`s11')		///
						vecpils(`vps2')		///
						alpha(`alpha2')
				}
				else {
					mat `alpha2' =			///
					`s01'*`beta2'*			///
					syminv(`beta2''*`s11'*`beta2')
				}
			}

			GetOmega , 	s00(`s00')		///
					s01(`s01')		///
					s11(`s11')		///
					alpha(`alpha2')		///
					beta(`beta2')		///
					omega(`omega')		

			scalar `iter_n' = 0
			GetSWest , 	gmat(`gmat')			///
					hmat(`hmat')			///
					amat(`amat')			///
					omega(`omega')			///
					beta(`beta2')			///
					alpha(`alpha2')			///
					s11(`s11')			///
					s01(`s01')			///
					s00(`s00')			///
					tolerance(`tolerance')		///
					ltolerance(`ltolerance')	///
					t(`T')				///
					k(`K')				///
					iter_n(`iter_n')		///
					iterate(`iterate')		///
					converge(`converge')		///
					`log' `nolog'			///
					`btrace'			///
					`toltrace'

				mat rownames `beta2' = `endog_vars' `z1exn'
				mat colnames `beta2' = `ce_lab'

				GetDF , gmat(`gmat') hmat(`hmat') 	///
					beta(`beta2') alpha(`alpha2')	///
					k(`K') nz1(`nz1') rmat(`rmat')	///
					rank(`rank')

				local beta_iden      = r(beta_iden)
				local beta_iden_cnt  = r(beta_iden_cnt)

				local df             = r(jacob_hat_rank)
				local jacob_rank     = r(jacob_hat_rank)
				local jacob_cols     = r(jacob_cols)
				local alphabeta_iden = 			///
					(`jacob_cols'<=`jacob_rank')
				local df_lr          = r(jacob_hat_lrdf)

				local parms1 = `K'*`nz2' + `df'
				local df = int(`parms1'/`K')
		}
		else {
			local parms1 =(`K'*`nz2'+(`K'+`nz1'-`rank')*`rank')
			local df = int(`parms1'/`K')

			local hmat NONE
			local amat NONE
			local gmat NONE

			local beta_iden = 1
			local beta_iden_cnt  = `rank'^2
			local df_lr = 0
		}
		
		tempname llvalue aic bic hqic detsig llvalueJ
		scalar `detsig' = det(`omega')

		LLval , alpha(`alpha2') beta(`beta2') omega(`omega') 	///
			t(`T') k(`K') val(`llvalue') 
	
		LLval , alpha(`alphaJ') beta(`betaJ') omega(`omegaJ') 	///
			t(`T') k(`K') val(`llvalueJ') 
	
		MKic `aic' `bic' `hqic' `llvalue' `parms1' `T' scalar


// now get Gamma_i and VCE's using alpha2, beta2 and omega obtained with or
// without constraints 

		tempname b V bvec 

// bvec holds vec(beta) beta2m holds beta in matrix form
		mat `beta2m' = `beta2'
		mat `bvec' = vec(`beta2')'

		mat `beta2' = vec(`beta2')'

// Make ceq`j' tempvars concatenate them into zbeta, ceq_vars, ceqs and zbetan

// use names _ce1, _ce2, ... not tempnames 

		local j 0
		foreach ceq of local ce_lab {
			local ++j
			local zbeta `zbeta' L._ce`j'
			local ceqs `ceqs' _ce`j'
			local ceq_vars `ceq_vars' L._ce`j'
			local zbetan `zbetan' L._ce`j'
		}

		Mkceqj `ceqs', beta2(`beta2')

// make constraints on temporary variables that hold cointegrating equations

		tsunab xvars : `varlist'

// exclude constant 

		local zbeta `zbeta' `z2base' `sindicators'
		local zbetan `zbetan' `z2t_names'

// do regression 

		tempname bt mu0 p0 mmss mu1 

		tsunab Ldiffvarlist : L.(`diffvarlist')
		qui mat accum `mmss' = `ceq_vars' `Ldiffvarlist', nocons dev
		mat `mmss' = syminv(`mmss')

		Getb `diffvarlist' if `touse', 		///
			pm1(`pm1') 			///
			exog(`z3t')			///
			exfront(`ceq_vars')		///
			df(`df')			///
			bmat(`b')			///
			vmat(`V')			///
			dvlist2(`diffvarlist2')		///
			zbetan(`zbetan')		///
			const(`aconstraints')		///
			`log' `nolog'

		foreach evar of local diffvarlist2 {
			if "`trend'" == "constant" | 			///
			   "`trend'" == "rtrend"   |			///
			   "`trend'" == "trend"   {
				mat `mu0' = (nullmat(`mu0'), 		///
					`b'[1,"`evar':_cons"] )
			}
		}

		if "`trend'" == "trend"   {
			foreach evar of local diffvarlist2 {
				mat `mu1' = (nullmat(`mu1'), 		///
					`b'[1,"`evar':_trend"] )
			}
		}

		tempname beta_s

		if "`trend'" == "rconstant" | "`trend'" == "rtrend" {
			mat `beta_s' = `beta2m'[1..rowsof(`beta2m')-1,1...]
		}
		else {
			mat `beta_s' = `beta2m'
		}

		tempname betao alphao 

		_vecortho `beta_s' `betao'
		_vecortho `alpha2' `alphao'

		if "`trend'" == "constant" | "`trend'" == "rtrend"	///
			| "`trend'" == "trend" {
			mat `p0' = syminv(`alpha2''*`alpha2')*`alpha2''*`mu0''

			mat rownames `p0' = `ce_lab'
			mat colnames `p0' = _cons

			if "`trend'" == "trend" {
				tempname p1
				mat `p1' = syminv(`alpha2''*`alpha2')*	///
					`alpha2''*`mu1''
				mat rownames `p1' = `ce_lab'
				mat colnames `p1' = _trend

				tempname beta3
				mat `beta3' = vec((`beta2m' \ `p1'' \ `p0''))'
				drop `ceqs'
				Mkceqj `ceqs', beta2(`beta3') 

			}
			else {
				tempname beta3
				mat `beta3' = vec((`beta2m' \ `p0''))'
				drop `ceqs'
				Mkceqj `ceqs', beta2(`beta3') 
			}
			
			Getb `diffvarlist' if `touse', 		///
				pm1(`pm1') 			///
				exog(`z3t')			///
				exfront(`ceq_vars')		///
				df(`df')			///
				bmat(`b')			///
				vmat(`V')			///
				dvlist2(`diffvarlist2')		///
				zbetan(`zbetan')		///
				const(`aconstraints')		///
				quietly
		}

// save of equation level stats

		forvalues i = 1/`K' {
			tempname obs_`i' k_`i' rmse_`i' r2_`i'	///
				ll_`i' df_m`i' chi2_`i'
			
			scalar `k_`i''    = e(k_`i')
			scalar `rmse_`i'' = e(rmse_`i')
			scalar `r2_`i''   = e(r2_`i')
			scalar `df_m`i''  = e(df_m`i')
			scalar `chi2_`i''    = e(chi2_`i')
		}

		tempname omegai b1 b2 b3 b4 H Itheta Ithetai pi

		tempname rho base
		mat `omegai' = syminv(`omega')

		mat `rho' = `alpha2''*`omegai'*`alpha2'

		if "`constraints'" == "" {
			mat `H' = J(`rank',`nz1'-`rank', 0) \ I(`nz1'-`rank')
			mat `base' = `H''*`s11'*`H'
			mat `Ithetai' = (1/(`T'-`df'))*(syminv(`rho' # `base'))

			tempvar H2
			mat `H2' = I(`rank') # `H'
			mat `Ithetai' = `H2'*`Ithetai'*`H2''

		}
		else {
			if "`hmat'" == "NONE" {
mat `base' = `s11'
mat `Ithetai' = (1/(`T'-`df'))*(syminv(`rho' # `base'))
			}
			else {
mat `Ithetai' = syminv(`hmat''*(`rho' # `s11')*`hmat')
mat `Ithetai' = (1/(`T'-`df'))*`hmat'*`Ithetai'*`hmat''

			}
		}

		local bnames : colfullnames `beta2'
		mat colnames `Ithetai' = `bnames'
		mat rownames `Ithetai' = `bnames'


		if "`trend'" == "constant" | "`trend'" == "rtrend" {
			tempname  block
			mat `beta2' = `beta2m' \ `p0''
			mat `beta2' = vec(`beta2')'
			mat `block' = I(`rank') # (I(`nz1') \ J(1,`nz1',0))
			mat `Ithetai' = ( `block'*`Ithetai'*`block'')
			
			local bnames : colfullnames `beta2' 
			mat colnames `Ithetai' = `bnames'
			mat rownames `Ithetai' = `bnames'
		}

		if "`trend'" == "trend" {
			tempname  block
			mat `beta2' = `beta2m' \ `p1'' \ `p0''
			mat `beta2' = vec(`beta2')'
			mat `block' = I(`rank') # (I(`K') \ J(2,`K',0))
			mat `Ithetai' = ( `block'*`Ithetai'*`block'')
			
			local bnames : colfullnames `beta2' 
			mat colnames `Ithetai' = `bnames'
			mat rownames `Ithetai' = `bnames'
		}	
		
		tempname pivec pi_V sigmabbi alpha_V

		mat `sigmabbi' = syminv(`beta2m''*`s11'*`beta2m')
		mat `pi' = `alpha2'*`beta2m''
		mat colnames `pi' = `lagvarlist' `z1exn'
		mat rownames `pi' = `diffvarlist2'
		mat `pivec' = vec(`pi'')'
		local pinames : colfullnames `pivec'
		
		mat `pi_V' = `omega' # (`beta2m' * `sigmabbi' *`beta2m'')
		mat `alpha_V' = 1/(`T' - `df') *( `omega' # `sigmabbi' )
		if "`gmat'" != "NONE" {

			mat `pi_V' = syminv(`gmat''*			///
				(`omegai'#(`beta2m''*`s11'*`beta2m'))*	///
				`gmat')
			mat `alpha_V' = 1/(`T'-`df') * `gmat'*`pi_V'*`gmat''

			tempname outer
			mat `outer' = (`beta2m' # I(`K'))
			mat `outer' = (I(`K') # `beta2m')

			mat `pi_V' = `outer'*`gmat'*`pi_V'*`gmat''*`outer''
		}

		mat `pi_V' = (1/(`T'-`df'))*`pi_V'

		mat colnames `pi_V' = `pinames'
		mat rownames `pi_V' = `pinames'

		tempname V2

		mat `V2' = `V'
		
		tempname chi2_res bcopy
		scalar `chi2_res' = 2*(`llvalueJ' - `llvalue')

		mat `bcopy' = `b'

		eret clear
		ereturn post `b' `V' ,  esample(`touse') buildfvinfo
		
// seasonal is an undocumented e-result that results from 
// the undocumented option seasonal

		if "`seasonal'" != "" {
			eret local seasonal "`stype'"
		}	
		else if "`sindicators'" != "" {
			eret local sindicators "`sindicators'"
		}	

		eret local trend `trend'
		eret local tsfmt "`tsfmt'"
		eret local tvar  "`tvar'"
		eret local endog   `tsvarlist'
		eret local eqnames `diffvarlist2'
		if "`reduce'" != "" {
			eret local reduce_opt `reduce'
		}
		eret local reduce_lags `reduced'
		if `:list sizeof COVAR' {
			eret local covariates `"`COVAR'"'
		}
		else	eret local covariates _NONE
		eret local marginsok xb
		eret local marginsnotok	stdp		///
					Residuals	///
					ce		///
					Levels		///
					Usece(passthru)
		local eqnames `"`e(eqnames)'"'
		foreach eq of local eqnames {
			local mdflt `mdflt' predict(xb equation(`eq'))
		}
		eret local marginsdefault `"`mdflt'"'
		eret local predict "vec_p"

		if "`acnsmac'`bcnsmac'" != "" {
			if `converge' == 0 {
				scalar `converge' = 1
			}
			else {
				scalar `converge' = 0
			}
			eret scalar converge = `converge'
		}

		if "`acnsmac'" != "" {
			eret local aconstraints "`acnsmac'"
		}

		if "`bcnsmac'" != "" {
			eret local bconstraints "`bcnsmac'"
		}
		
		eret scalar N          = `T'
		eret scalar beta_iden  = `beta_iden'
		eret scalar beta_icnt  = `beta_iden_cnt'

		eret scalar df_lr      = `df_lr'
		
// BPP: saving off names of cointegrating equations _ce1, _ce2, ...
// needed for dialog boxes, and hard to do in dialog programming code
		local cenames
		forvalues i = 1 / `rank' {
			local cenames "`cenames' _ce`i'"
		}
		local cenames `=trim("`cenames'")'	// rm leading space
		eret local cenames "`cenames'"
// end BPP modification
		eret scalar k_ce       = `rank'
		eret scalar n_lags     = `p'
		eret scalar k_eq       = `K'
		eret scalar k_dv       = `K'
		eret scalar k_rank     = `parms1'
		eret scalar df_m       = `df'
		eret scalar ll         = `llvalue'
		eret scalar chi2_res   = `chi2_res'
		eret scalar tmin       = `tmin'
		eret scalar tmax       = `tmax'
		eret scalar aic        = `aic'
		eret scalar sbic       = `bic'
		eret scalar hqic       = `hqic'
		eret scalar detsig_ml  = `detsig'

// save off equation level stats

		forvalues i = 1/`K' {
			eret scalar k_`i'    = `k_`i''
			eret scalar rmse_`i' = `rmse_`i''
			eret scalar r2_`i'   = `r2_`i''
			eret scalar df_m`i'  = `df_m`i''
			eret scalar chi2_`i'    = `chi2_`i''
		}

// now get long-run impact matrix and its VCE

		tempname C Gam xi1 xi2 xi C_V qstar  alpha_bar

// _vecmkgam uses e(b) and e(trend) , they must already be posted 

		_vecmkgam, g(`Gam') b(`bcopy') rank(`rank')	///
			trend(`trend') pm1(`pm1') k(`K')

		mat `C' = `betao'*inv(`alphao''*`Gam'*`betao')*`alphao''

		mat `alpha_bar' = `alpha2'* syminv(`alpha2''*`alpha2')

		mat `xi1' = (`C''*`Gam''-I(`K'))*`alpha_bar'

		if `pm1' > 0 {
			mat `xi2' = J(1,`pm1',1)#(`C'')

			mat `xi' = `xi1', `xi2'
		}
		else {
			mat `xi' = `xi1'
		}

		mat `qstar' = (`xi1',`C'')
		
		tempname dofw2 zmat smat lq1

// this next program uses e(V)
		_vecmkapvp `dofw2' `rank' `pm1' `K' `tterms'
		mat `smat' = (`C'#`xi')
		mat `C_V'  = ((`T'-`df')/`T')*(`smat')*`dofw2'*`smat''

		mat colnames `C' = `tsvarlist2'
		mat rownames `C' = `tsvarlist2'
		mat `C' = vec(`C'')'

		local cnames : colfullnames `C'

		
		mat rownames `C_V' = `cnames'
		mat colnames `C_V' = `cnames'

		local anames 
		foreach nm1 of local diffvarlist2 {
			foreach nm2 of local Lce_lab {
				local anames "`anames' `nm1':`nm2' "
			}
		}

		mat colnames `alpha_V' = `anames'
		mat rownames `alpha_V' = `anames'

		mat `alpha2'     = vec(`alpha2'')'

		mat colnames `alpha2' = `anames'
		mat rownames `alpha2' = alpha

		eret mat alpha   = `alpha2'
		eret mat V_alpha = `alpha_V'

		mat colnames `omega' = `diffvarlist2'
		mat rownames `omega' = `diffvarlist2'

		mat rownames `beta2' = beta
		mat rownames `bvec' = betavec
		mat rownames `pivec' = pi
		mat rownames `C' = mai

		eret mat beta = `beta2'
		eret mat V_beta = `Ithetai'
		eret mat betavec = `bvec'
		eret mat pi      = `pivec'
		eret mat V_pi    = `pi_V'
		eret mat omega   = `omega'
		eret mat mai     = `C'
		eret mat V_mai   = `C_V'
		eret local title "Vector error-correction model"
		eret local cmd "vec"

	}
end

program define MATsqrt 

// syntax MATsqrt newmat oldmat
// 	oldmat is name of symmetric matrix of which to take the square root 
// 	newmat is name of matrix to hold the matrix square root
// 	matrix square root is defined as 
//       newmat = W (1/sqrt(r_1), 1/sqrt(r_2), ..., 1/sqrt(r_k)) W'
//		where W is matrix of eigenvectors of oldmat and 
//			r_i is i^th eigenvector of oldmat
//	NB:  return exits with 498 if r_i <= 1e-14

	local newmat `1'
	local oldmat `2'

	confirm matrix `oldmat'
	confirm name `newmat'

	tempname w v v2
	matrix symeigen `w' `v' = `2'
	
	local k = colsof(`v') 

	mat `v2' = J(`k',`k',0)

	forvalues i = 1/`k' {
		if `v'[1,`i'] <= 1e-15 {
			mat `v2'[`i',`i'] = 0
		}
		else {
			mat `v2'[`i',`i'] = 1/sqrt(`v'[1,`i']) 
		}	
	}

	mat `newmat' = `w'*`v2'*`w''
end

program define MKic

// arguments are passed in
//	aic  is 1 by (K+1) matrix to hold AIC
//	bic  is 1 by (K+1) matrix to hold BIC
//	hqic is 1 by (K+1) matrix to hold HQIC
//	ll   is 1 by (K+1) matrix that already holds Loglikelihoods
//      parms is 1 by (K+1) matrix that already holds number of parameters
//	T    is a scalar that already holds number of time periods in sample
//      [ scalar ]

	args aic bic hqic ll parms T scalar

	if "`scalar'" == "" {
		local r = colsof(`aic')

		forvalues i = 1/`r' {
			mat `aic'[1,`i']  = (-2*`ll'[1,`i'] + 		///
				2*`parms'[1,`i'])/`T'
			mat `bic'[1,`i']  = (-2*`ll'[1,`i'] +		///
				ln(`T')*`parms'[1,`i'])/`T'
			mat `hqic'[1,`i'] = (-2*`ll'[1,`i'] +		///
				2*ln(ln(`T'))*`parms'[1,`i'])/`T'
		}
	}
	else {
		scalar `aic'  = (-2*`ll' + 2*`parms')/`T'
		scalar `bic'  = (-2*`ll' + ln(`T')*`parms')/`T'
		scalar `hqic' = (-2*`ll' + 2*ln(ln(`T'))*`parms')/`T'

	}
end

program define mkcns

	syntax , rownames(string)		///
		 colnames(string) 		///
		 cmat(name) 			///
		 constraints(string)		///
		 [				///
		 amat(name)			///
		 rmat(name)			///
		 transpose			///
		 ]

	foreach cns of local constraints {
		constraint get `cns'
		if r(defined) != 1 {
			di as err "constraint `cns' not defined"
			exit 498
		}
	}

	tempname b v cur_est cur_samp  C

	if "`amat'" == "" {
		tempname amat
	}

	if "`rmat'" == "" {
		tempname rmat
	}

	local rows : word count `rownames'
	local cols : word count `colnames'

	mat `b' = J(`rows', `cols', .1)

	mat rownames `b' = `rownames'
	mat colnames `b' = `colnames'

	if "`transpose'" != "" {
		mat `b' = vec(`b'')'
	}
	else {
		mat `b' = vec(`b')'
	}

	local names : colfullnames `b'

	mat `v' = `b''*`b'

	mat rownames `v' = `names'
	mat colnames `v' = `names'

	_estimates hold `cur_est', restore nullok varname(`cur_samp')

	ereturn post `b' `v'
	
	matrix makeCns `constraints'
	matrix dispCns, r
	matcproc `cmat' `amat' `rmat'

	mat `rmat' = `rmat'[1...,1..colsof(`rmat')-1]
	mat `amat' = `amat''
	_estimates unhold `cur_est'
	
end

program define GetSWest

	syntax 	, 	gmat(name)		///
			hmat(name)		///
			amat(name)		///
			omega(name)		///
			beta(name)		///
			alpha(name)		///
			s11(name)		///
			s01(name)		///
			s00(name)		///
			tolerance(real)		///
			ltolerance(real)	///
			iter_n(name)		///
			iterate(integer)	/// 
			t(name)			///
			k(integer)		///
			converge(name)		///
			[			///
			NOLOg LOg		///
			btrace			///
			toltrace		///
			]

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'" == "" {
		di
	}	

	tempname diff oldval vecpils ip1 omegai newval
	tempname alpha0 beta0 omega0 mdiff tval 

	scalar `diff' = .
	scalar `mdiff' = .

	lcfunc , 	alpha(`alpha') 		///
			beta(`beta') 		///
			omega(`omega') 		///
			t(`t')			///
			s00(`s00')		///
			s01(`s01')		///
			s11(`s11')		///
			val(`oldval')		///
			k(`k')

	mat `vecpils' = vec((`s01'*inv(`s11'))')
	mat `ip1'     = I(rowsof(`beta'))

	mat `alpha0' = `alpha'
	mat `beta0' = `beta'
	mat `omega0' = `omega'
	
	Tolck , converge(`converge') fdiff(`diff') 	///
		mdiff(`mdiff') ftolvalue(`ltolerance')	///
		btolvalue(`tolerance') iter_n(`iter_n')	///
		iterate(`iterate')

	while `converge' == 1 {
		scalar `iter_n' = `iter_n' + 1
		mat `omegai'  = syminv(`omega')
		GetBeta , 	hmat(`hmat')		///
				alpha(`alpha')		///
				omegai(`omegai')	///
				s11(`s11')		///
				vecpils(`vecpils')	///
				ip1(`ip1')		///
				beta(`beta')		///
				amat(`amat')

		GetAlpha , 	gmat(`gmat')		///
				omegai(`omegai')	///
				beta(`beta')		///
				s11(`s11')		///
				vecpils(`vecpils')	///
				alpha(`alpha')

		GetOmega , 	s00(`s00')		///
				s01(`s01')		///
				s11(`s11')		///
				alpha(`alpha')		///
				beta(`beta')		///
				omega(`omega')		

		lcfunc , 	alpha(`alpha') 		///
				beta(`beta') 		///
				omega(`omega') 		///
				t(`t')			///
				s00(`s00')		///
				s01(`s01')		///
				s11(`s11')		///
				val(`newval')		///
				k(`k')
	
		scalar `tval' = mreldif(`alpha0',`alpha')
		scalar `mdiff' = mreldif(`beta0',`beta')
		scalar `mdiff' = cond( `tval' > `mdiff', `tval', `mdiff')

		scalar `tval' = mreldif(`omega0',`omega')
		scalar `mdiff' = cond( `tval' > `mdiff', `tval', `mdiff')

		mat `alpha0' = `alpha'
		mat `beta0' = `beta'
		mat `omega0' = `omega'

		if "`log'" == "" {
			local iter = `iter_n'
			local iter_d = int(log10(`iter'))
			local iter_d2 = cond(5-`iter_d'> 0, 5-`iter_d',1)

			local iter_sp : di "{space `iter_d2'}"
di as txt "Iteration `iter':`iter_sp'log likelihood = " as res `newval' %10.9g	
		}

		scalar `diff' = reldif(`oldval',`newval')
		
		if "`toltrace'" != "" {
di as txt "{col 5}The relative difference in log likelihood values " ///
	"is   " as res `diff' %8.7g	
di as txt "{col 5}The relative difference in the coefficient " ///
	"vectors is " as res `mdiff' %8.7g	
		}

		if "`btrace'" != "" {
			local mdisp
			local rows = rowsof(`beta')
			local cols = colsof(`beta')
		
			di as txt "{col 14}beta"
			forvalues i = 1/`rows' {
				forvalues j = 1/`cols' {
					local val : display %10.9g	///
						`beta'[`i',`j']
					local mdisp "`mdisp'`val'  "	
				}
			}
			di as res "{p 13 13}`mdisp'{p_end}"

			local mdisp
			local rows = rowsof(`alpha')
			local cols = colsof(`alpha')
		
			di as txt "{col 14}alpha"
			forvalues i = 1/`rows' {
				forvalues j = 1/`cols' {
					local val : display %10.9g	///
						`alpha'[`i',`j']
					local mdisp "`mdisp'`val'  "	
				}
			}
			di as res "{p 13 13}`mdisp'{p_end}"
		}

		scalar `oldval' = `newval'
		Tolck , converge(`converge') fdiff(`diff') 	///
			mdiff(`mdiff') ftolvalue(`ltolerance')	///
			btolvalue(`tolerance') iter_n(`iter_n')	///
			iterate(`iterate')
	}

end

program define Tolck
	syntax , converge(name) 		///
		fdiff(name)			///
		iter_n(name)			///
		iterate(integer)		///
		ftolvalue(real)			///
		btolvalue(real)			///
		[				///
		mdiff(name)			///
		]

		if `iterate' == `iter_n' {
			scalar `converge' = 430
			exit
		}

		scalar `converge' = max( 				///
				cond(`fdiff' < `ftolvalue',0,1), 	///
				cond(`mdiff' < `btolvalue' ,0,1)  )
end

program define LLval 

	syntax , 	alpha(name)		///
			beta(name)		///
			omega(name)		///
			t(name)			///
			val(name)		///
			k(integer)
	
	tempname pi omegai

	mat `pi' = `alpha'*`beta''
	
	scalar `val'  = -.5*`t'*`k'*ln(2*_pi) -		///
		.5*`t'*ln(abs(det(`omega'))) -.5*`t'*`k'

end

program define lcfunc 

	syntax , 	alpha(name)		///
			beta(name)		///
			omega(name)		///
			t(name)			///
			s00(name)		///
			s01(name)		///
			s11(name)		///
			val(name)		///
			k(integer)
	
	tempname pi mat1 omega2 temp omegai

	mat `pi' = `alpha'*`beta''
	mat `mat1' = `pi'*(`s01'')
	
	GetOmega , 	s00(`s00')		///
			s01(`s01')		///
			s11(`s11')		///
			alpha(`alpha')		///
			beta(`beta')		///
			omega(`omega2')		

	scalar `val'  = -.5*`t'*`k'*ln(2*_pi) -		///
		.5*`t'*ln(abs(det(`omega'))) -.5*`t'*`k'

end

program define GetAlpha

	syntax , 	gmat(name)		///
			omegai(name)		///
			beta(name)		///
			s11(name)		///
			vecpils(name)		///
			alpha(name)

	tempname psi vec_alphap
	if "`gmat'" == "NONE"  {
		mat `psi' = syminv(`omegai'#(`beta''*`s11'*`beta'))*	///
			(`omegai'#(`beta''*`s11'))*`vecpils'
// in this case psi = vec_alphap
		va2a , vec_alphap(`psi') alpha(`alpha')
	}
	else {
		mat `psi' = syminv(`gmat''*(`omegai'#(`beta''*`s11'*`beta')) ///
			*`gmat')*`gmat''*(`omegai'#(`beta''*`s11'))*`vecpils'
		mat `vec_alphap' = `gmat'*`psi'	
		va2a , vec_alphap(`vec_alphap') alpha(`alpha')
	}


end

program define GetOmega 
	syntax , 	s00(name)		///
			s01(name)		///
			s11(name)		///
			alpha(name)		///
			beta(name)		///
			omega(name)		

	tempname mat1 pi

	mat `pi' = `alpha'*`beta''

	mat `mat1' = `s01'*(`pi'')

	mat `omega' = `s00' - `mat1' - `mat1'' + `pi'*`s11'*`pi''

end

program define GetBeta

	syntax , 	hmat(name)		///
			alpha(name)		///
			omegai(name)		///
			s11(name)		///
			vecpils(name)		///
			ip1(name)		///
			beta(name)		///
			[			///
			amat(name)		///
			]

	tempname phi vec_beta
	if "`hmat'" == "NONE" {
		mat `phi' = syminv((`alpha''*`omegai'*`alpha')#`s11')* 	///
			((`alpha''*`omegai')#`s11')*`vecpils'
// in this case phi = vec(beta)

		vb2b , vecbeta(`phi') beta(`beta')

	}
	else {

		mat `phi' = syminv(`hmat''*((`alpha''*`omegai'*`alpha')#  ///
			`s11')*`hmat')*`hmat''*((`alpha''*`omegai')#`s11') ///
			*(`vecpils' - (`alpha'#`ip1')*`amat')
		mat `vec_beta'	= `hmat'*`phi' + `amat'
		vb2b , vecbeta(`vec_beta') beta(`beta')
	}
end

program define vb2b

	syntax  , vecbeta(name) 		///
		  beta(name)

	local rows = rowsof(`beta')
	local cols = colsof(`beta')

	tempname beta2

	if rowsof(`vecbeta') != `rows'*`cols' | colsof(`vecbeta') != 1 {
		di as err "parameter estimates of beta do not have "	///
			"correct dimension"
		exit 498
	}

	forvalues i = 1/`cols' {
		mat `beta2' = (nullmat(`beta2'), 		///
			`vecbeta'[(`i'-1)*`rows' + 1..`i'*`rows',1] )
	}

	mat `beta' = `beta2'
end		

program define va2a 
	syntax ,	vec_alphap(name)	///
			alpha(name)

	local r = colsof(`alpha')
	local k = rowsof(`alpha')

	tempname alpha2

	if rowsof(`vec_alphap') != `r'*`k' | colsof(`vec_alphap') != 1 {
		di as err "parameter estimates of alpha do not have "	///
			"the correct dimension"
		exit 498	
	}		

	forvalues i = 1/`k' {

		mat `alpha2' = (nullmat(`alpha2') \ 	///
			(`vec_alphap'[(`i'-1)*`r' + 1..`i'*`r', 1])' )
	}

	mat `alpha' = `alpha2'
end

program define 	Getsmats 

	syntax , 			///
		r0t(varlist ts) 	///
		r1t(varlist ts) 	///
		touse(varname)		///
		s00(name) 		///
		s01(name) 		///
		s10(name) 		///
		s11(name)  		///
		t(name) 		///
		k(integer)

	tempname bigs

	qui mat accum `bigs' = `r0t' `r1t' if `touse', nocons
	scalar `t' = r(N)
	mat `bigs' = (1/`t')*`bigs'

	mat `s00' =`bigs'[1..`k',1..`k']
	mat `s01' =`bigs'[1..`k',`k'+1...]
	mat `s10' = `s01''
	mat `s11' =`bigs'[`k'+1...,`k'+1...]

end		

program define Johansen 

	syntax , alpha(name)	///
		beta(name)	///
		omega(name)	///
		lam(name)	///
		s10(name)	///
		s01(name)	///
		s11(name)	///
		s00(name)

	tempname s11_sqrt bigs2 s00i u 

	MATsqrt `s11_sqrt' `s11'

	mat `s00i' = syminv(`s00')
	mat `bigs2' = `s11_sqrt'*`s10'*`s00i'*`s01'*`s11_sqrt'
	
	mat symeigen `u' `lam' = `bigs2'
	mat `beta' = (`s11_sqrt'*`u')

	mat `alpha' = `s01'*`beta'

	mat `omega' = `s00' -`alpha'*`alpha''

end

program define Mkceqj

	syntax newvarlist, beta2(name) 

	local j 0
	foreach ceq of local varlist {
		local ++j
		local ceqj : word `j' of `varlist'
		mat score double `ceqj' = `beta2' , eq(#`j')
		global S_madece madece
	}

end

program define Getb

		syntax varlist(ts numeric) 		///
			[if] , 				///
			pm1(integer) 			///
			exfront(varlist ts)		///
			df(integer)			///
			bmat(name)			///
			vmat(name)			///
			dvlist2(namelist)		///
			zbetan(string)			///
			[				///
			exog(varlist ts)		///
			const(numlist)			///
			from(passthru)			///
			quietly				///
			NOLOg LOg			///
			]

		marksample touse

		if "`quietly'" == "" di 

		if "`const'" != "" {
			`quietly' _cvar `varlist' if `touse', 		///
				lags(1/`pm1')				///
				const(`const') exog(`exog')		///
				noconstant exfront(`exfront')		///
				dfmodel(`df') isure tol(1e-9) `log' `nolog'

// adjustment on next line properly counts df when there are 
// constraints on alpha
			mat `vmat' = (e(N)/(e(N)-`df'))*e(V)
			
		}
		else {
			if `pm1' > 0 {
				local qslags " lags(1/`pm1') "
			}
			else {
				local qslags " zlags "
			}
			`quietly' _qsur `varlist' if `touse', `qslags'	///
				 exfront(`exfront') exog(`exog')	///
				 noconstant dfmodel(`df')
			mat `vmat' = e(V)
		}		

		mat `bmat' = e(b)

		foreach evar of local dvlist2 {
			foreach zvar of local zbetan {
				local vnames "`vnames' `evar':`zvar' "
			}
		}

		mat colnames `bmat' = `vnames'
		mat colnames `vmat' = `vnames'
		mat rownames `vmat' = `vnames'

end			

//  This program calculates the rank of the full jacobian and the rank of the
//  jacobian with respect to beta only for the values of alpha and beta passed
//  or for the ``consecutive full rank" matrix

program define GetDF, rclass

	syntax , gmat(string) 		///
		hmat(string) 		///
		beta(name) 		///
		alpha(name)		///
		k(integer)		///
		nz1(integer)		///
		rank(integer)		///
		[			///
		rmat(string)		///
		]

	tempname rbeta ralpha
	
	local row_alpha = rowsof(`alpha')
	local col_alpha = colsof(`alpha')

	local row_beta = rowsof(`beta')
	local col_beta = colsof(`beta')

	MKcfrm `rbeta' `row_beta' `col_beta'
	MKcfrm `ralpha' `row_alpha' `col_alpha'

	CKjacob , k(`k') beta(`beta') alpha(`alpha') 		///
		gmat(`gmat') hmat(`hmat') nz1(`nz1') 		///
		rank(`rank')

	local jacob_cols     = r(jacob_cols)	
	local jacob_hat_rank = r(jacob_rank)
	local jacob_hat_lrdf = r(df_lr)

	CKjacob_b , k(`k') beta(`beta') hmat(`hmat') 		///
		rmat(`rmat') nz1(`nz1') rank(`rank')	

	local beta_iden      = r(beta_iden)
	local beta_iden_cnt  = r(beta_iden_cnt)

	ret scalar jacob_cols      = `jacob_cols'
	ret scalar jacob_hat_rank  = `jacob_hat_rank'
	ret scalar jacob_hat_lrdf  = `jacob_hat_lrdf'

	ret scalar beta_iden       =  `beta_iden'
	ret scalar beta_iden_cnt   =  `beta_iden_cnt'
end

// This program makes and checks the rank of a jacobian for a 
// given alpha and beta

program define CKjacob , rclass

	syntax ,	k(integer) 		///
			beta(name)		///
			alpha(name) 		///
			gmat(string) 		///
			hmat(string)		///
			nz1(integer)		///
			rank(integer)

	tempname j1 j2 jacob idmat

	if "`gmat'" == "NONE" {
		mat `j1' = I(`k')#`beta'
	}
	else {
		mat `j1' = (I(`k')#`beta')*`gmat'
	}

	if "`hmat'" == "NONE" {
		mat `j2' = `alpha' # I(`nz1')
	}
	else {
		mat `j2' = (`alpha' # I(`nz1'))*`hmat'
	}

	mat `jacob' = `j1', `j2'

	mat `idmat' = syminv(`jacob''*`jacob')

	local c1 = colsof(`idmat')
		
	local df_b 0 
	forvalues i = 1/`c1' {
		if `idmat'[`i',`i'] > 5e-16 local ++df_b
	}

	local df_lr = ( `k' + `nz1' -`rank')*`rank' -`df_b'

	ret scalar jacob_cols = `c1'
	ret scalar jacob_rank = `df_b'

	ret scalar df_lr = `df_lr'

end			

// This program checks the jacobian for beta only for a given beta
program define CKjacob_b , rclass

	syntax ,	k(integer) 		///
			beta(name)		///
			hmat(string)		///
			nz1(integer)		///
			rank(integer)		///
			[			///
			rmat(string)		///
			]


	if "`hmat'" == "NONE" {
		ret scalar beta_iden_cnt = 0
		ret scalar beta_iden     = 0
	}
	else {
		tempname brmat
		mat `brmat' = `rmat'*(I(`rank') # `beta')
		mat `brmat' = syminv(`brmat''*`brmat')
		local brcols = colsof(`brmat')
		local beta_iden_cnt 0

		forvalues i = 1/`brcols' {
			if `brmat'[`i',`i'] > 1e-15 {
				local ++ beta_iden_cnt
			}
		}

		if `beta_iden_cnt' >= `rank'^2 {
			ret scalar beta_iden = 1
		}
		else {
			ret scalar beta_iden = 0
		}

		ret scalar beta_iden_cnt = `beta_iden_cnt'

	}

end

// This program makes a ``consecutive full rank" matrix

program define MKcfrm 
	
	args mat rows cols

	mat `mat' = J(`rows', `cols', 0)

	local cnt 0

	forvalues j=1/`cols' {
		forvalues i=1/`rows' {
			local ++cnt
			mat `mat'[`i',`j'] = `cnt'
		}
	}
	mat `mat' = .01*`mat'


end

program define vec_rmcoll, rclass

	syntax varlist(ts), 		///
		touse(varname)		///
		p(integer)		///
		[			///
		rmcoll			///
		ownonly			///
		]



	_rmcoll `varlist' if `touse'
	local varlist "`r(varlist)'"

	local pm1 = `p' - 1

	if "`ownonly'" == "" {
		Getz2base `varlist', pm1(`pm1')
		local z2base "`r(varlist)'"
	}

	foreach dvar of local varlist {
		if "`ownonly'" != "" {
			tsunab dvar0 : `dvar'
			Getz2base `dvar0', pm1(`pm1')
			local z2base "`r(varlist)'"

		}

		tsunab ddvar : d.`dvar'
		local clean 0
		while `clean' == 0 {
			local ext_vlist `ddvar' `z2base'
			
			if "`rmcoll'" == "" {
				qui reg `ext_vlist' if `touse'
				if reldif(_b[_cons], 0) < 5e-16 {
					local clean 0
				}
				else {
					local clean 1
				}
			}
			else {
				qui _rmcoll `ext_vlist'
				local rm_vlist "`r(varlist)'"
				local clean : list ext_vlist == rm_vlist
			}


			if `clean' == 0 {
				local p = `p' - 1
				if `p' <1 {
					di as err "cannot fit model "	///
						"because of collinearity"
					exit 498
				}

				local pm1 = `p' - 1
				di as txt "maximum lag reduced to "	///
					"`p' because of collinearity"
				local reduced `reduced' `p'	

				if "`ownonly'" == "" {
					Getz2base `varlist', pm1(`pm1')
					local z2base "`r(varlist)'"
				}
				else {
					tsunab dvar0 : `dvar'
					Getz2base `dvar0', pm1(`pm1')
					local z2base "`r(varlist)'"
		
				}
			}
		}
	}

	ret local varlist "`varlist'"
	ret scalar p = `p'
	ret local reduced "`reduced'"
end

program define Getz2base, rclass

	syntax varlist(ts), pm1(integer) 

	if `pm1' > 0 {
		tsunab z2base : l(1/`pm1').d.(`varlist') 
	}
	else {
		local z2base
	}

	ret local varlist "`z2base'"
end

program define DerrMsg
	di as err "cannot perform estimation using Johansen's method"

end
exit



