*! version 1.2.4  20mar2019

program define ucm, eclass byable(onecall)
	local vv : display "version " _caller() ":"
	version 12

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if replay() {
		if ("`e(cmd)'"!="ucm") error 301

		Replay `0'
		exit
	}
	`vv' cap noi `BY' Estimate mnames : `0'
	local rc = c(rc)

	/* clean up Mata matrices with temporary names			*/
	foreach m of local mnames {
		cap mata: mata drop `m'
	}
	cap
	exit `rc'
end

program define Estimate, eclass byable(recall)
	local version  = string(_caller())
	local vv "version `version':"
	version 12

	gettoken _mnames 0 : 0, parse(":")
	gettoken colon 0 : 0, parse(":")

	syntax varlist(numeric fv ts) [if] [in], 	///
		[ MODel(string)				///
		  SEAsonal(string)	 		///
		  METHod(string)			///
		  CONSTraints(numlist integer >=1 <=1999) ///
		  COLlinear				///
		  from(string)				///
		  seed(string)				///
		* ]

	/* undocumented: 						*/
	/* 	seed(string), seed for 10 random initial estimates	*/
	/* 	seasonal(#,deterministic), deterministic seasonal	*/
	/*	cycle(#,period(#)), time-domain initial estimate for 	*/
	/*			period					*/

	local cmdline `"ucm `:list retokenize 0'"'

	marksample touse 
	qui count if `touse'
	if (r(N)==0) error 2000

	_ts tvar panvar if `touse', sort onepanel
	cap tsset
	local tdelta = r(tdelta)
	local tunit `r(unit)'
	local tdeltas `r(tdeltas)'

	markout `touse' `tvar'
	qui count if `touse'
	local N  = r(N)
	if (`N'==0) error 2000

	_check_ts_gaps `tvar', touse(`touse')

	tempname tmin tmax
	summarize `tvar' if `touse', meanonly
	scalar `tmax' = r(max)
	scalar `tmin' = r(min)
	local fmt : format `tvar'
	local tmins = trim(string(r(min), "`fmt'"))
	local tmaxs = trim(string(r(max), "`fmt'"))

	gettoken depvar indeps : varlist

	ParseMethod, `method'
	local method `s(method)'

	_parse_optimize_options, `options'
	local mlopt `s(mlopts)'

	_get_diopts diopts options, `s(rest)'

	ParseCycles, n(`N') `options'
	local ncycles = `s(k)'
	forvalues i=1/`ncycles' {
		local cfreq`i' `s(freq`i')'
		local corder`i' `s(order`i')'
	}
	ParseModel, `model'
	local model `s(model)'

	local options `s(options)'
	local options : list retokenize options
	if "`options'" != "" {
		local wc: word count `options'
		di as err `"{p} `=plural(`wc',"option")' {bf:`options'} "' ///
		 `"`=plural(`wc',"is","are")' not allowed{p_end}"'
		exit 198
	}

	tempname Qinfo Gamma Amat Bmat Cmat Dmat Fmat Gmat Qmat Rmat

	local mlist `Qinfo' `Amat' `Bmat' `Cmat' `Dmat' `Fmat' 
	local mlist `mlist' `Gmat' `Qmat' `Rmat'
	c_local `_mnames' `mlist'

	local k_state = 0		// number of states
	local k_state_err = 0		// number of state error terms
	local k_obser_err = 1		// number of obser error terms
	local lorder = -1		// order of trend polynomial
	local lerror = 0		// trend polynomial error flag
	local derror = 0		// trend 1st derivative error flag
	if "`model'" == "none" {
		local k_obser_err = 0
	}
	else if "`model'" == "dconstant" {
		/* deterministic constant			*/
		local lcomp deterministic constant
		local k_state = 1
		local states level 
		local lorder = 0
	}
	else if "`model'" == "llevel" {
		/* local level					*/
		local lcomp local level
		local k_state = 1
		local states level 
		local lerror = 1
	}
	else if "`model'" == "rwalk" {
		/* random walk, default				*/
		local lcomp random walk
		local k_state = 1
		local states level 
		local k_obser_err = 0
		local lerror = 1
	}
	else if "`model'" == "dtrend" {
		/* deterministic trend				*/
		local lcomp deterministic trend
		local k_state = 2
		local states level slope
		local lorder = 1
	}
	else if "`model'" == "lldtrend" {
		/* local level with deterministic trend		*/
		local lcomp local level with deterministic trend
		local k_state = 2
		local states level slope
		local lorder = 1
		local lerror = 1
	}
	else if "`model'" == "rwdrift" {
		/* random walk with drift			*/
		local lcomp random walk with drift
		local k_state = 2
		local states level slope
		local k_obser_err = 0
		local lorder = 1
		local lerror = 1
	}
	else if "`model'" == "lltrend" {
		/* local linear trend				*/
		local lcomp local linear trend
		local k_state = 2
		local states level slope
		local lorder = 1
		local lerror = 1
		local derror = 1
	}
	else if "`model'" == "strend" {
		/* smooth trend					*/
		local lcomp smooth trend
		local k_state = 2
		local states level slope
		local lorder = 1
		local derror = 1
	}
	else if "`model'" == "rtrend" {
		/* random trend					*/
		local lcomp random trend
		local k_state = 2
		local states level slope
		local k_obser_err = 0
		local lorder = 1
		local derror = 1
	}
	/* else "`model'" == "ntrend" 				*/

	local ltrend = (`k_state'>0)
	local k_state_err = `lerror' + `derror'
	local state_eq `states'

	if "`seasonal'" != "" {
		/* seasonal, time domain			*/
		ParseSeasonal `seasonal'

		local seasonal = `s(period)'
		/* allow up to a year cycle with weekly data	*/
		local m = min(52,`N')
		if `seasonal' > `m' {
			if (`m'<52) local extra "the size of the data, "
			di as err "{p}{bf:seasonal(`seasonal')} exceeds " ///
			 "`extra'`m'; this is not allowed{p_end}"
			exit 459
		}
		local serror ("`s(error)'"!="deterministic")
		local s1 = `seasonal'-1
		local states `states' seasonal
		local state_eq `state_eq' seasonal
		forvalues s=2/`s1' {
			local states `states' s`s'
		}
		local k_state = `k_state' + `s1'
		if `serror' {
			local `++k_state_err'
		}

		tempname As
		mata: `As' = I(`seasonal')[|1,2\ `s1',`seasonal'|]
		mata: `As'[1,.] = J(1,`s1',-1)
	} 
	else local seasonal = 0

	forvalues ci=1/`ncycles' {
		tempname Ac`ci'
		mata: `Ac`ci'' = I(2*`corder`ci'')
		mata: `Ac`ci''[1,1] = `cfreq`ci''
		forvalues i=1/`corder`ci'' {
			local state_eq `state_eq' cycle`ci'
			local states `states' cycle`ci'_`i'_1 
			local states `states' cycle`ci'_`i'_2
			local k_state = `k_state' + 2
			if `i' > 1 {
				local k = 2*(`i'-1)-1
				local j = 2*`i'-1
				mata: `Ac`ci''[`k',`j'] = 1
				local `++j'
				local `++k'
				mata: `Ac`ci''[`k',`j'] = 1
			}
		}
		local `++k_state_err'
	} 
	if !`k_state_err' & !`k_obser_err' {
		di as err "{p}at least one variance term is required in " ///
		 "the model{p_end}"
		exit 498
	}
	if !`k_state' {
		local k_state = 1
		/* A matrix has rank 0; sdejong method does not work	*/
		local method hybrid
	}
	/* covariates for depvar					*/
	local ky : word count `indeps'
	if `ky' > 0 {
		/* initial state is the constant term when there is 	*/
		/*  a linear trend					*/
		if "`model'"=="none" | "`model'"=="ntrend" {
			local noconstant noconstant
		}
		local indeps1 : list uniq indeps
		if `:word count `indeps1'' != `ky' {
			local drop : list indeps - indeps1
			di as txt "{p 0 7 2}note: duplicate variables " ///
			 "detected: {bf:`drop'}{p_end}"
			local indeps `indeps1'
		}
		_rmdcoll `depvar' `indeps' if `touse', `noconstant' `collinear'
		local fvindeps `r(varlist)'
		local ky : word count `fvindeps'
	}
	if `ky' > 0 {
		mata: `Fmat' = J(1,`ky',0)
		/* first ky covariates for depvar			*/
		forvalues i=1/`ky' {
			local xi : word `i' of `fvindeps'
			_ms_parse_parts `xi'
			mat `Gamma' = (nullmat(`Gamma'),(5\1\scalar(`i')\0))
			local dnames `"`dnames' `depvar':`xi'"'
		}
		local depvar0 `depvar'
	}
	else mata: `Fmat' = J(0,0,.)

	mata: `Amat' = J(`k_state',`k_state',0)
	mata: `Bmat' = J(0,0,.)
	mata: `Dmat' = J(1,`k_state',0)
	if (`k_state_err') mata: `Cmat' = J(`k_state',`k_state_err',0)
	else mata: `Cmat' = J(0,0,.)
	mata: `Gmat' = J(0,0,.)
	mata: `Qmat' = J(`k_state_err',`k_state_err',0)
	mata: `Rmat' = J(`k_obser_err',`k_obser_err',0)

	mata: `Qinfo' = J(1,7,0)
	/* Q dim							*/
	mata: `Qinfo'[1,3] = `k_state_err'
	/* Q has scalar or diagonal structure				*/
	if (`k_state_err'==1) mata: `Qinfo'[1,2] = 1
	else if (`k_state_err'>1) mata: `Qinfo'[1,2] = 2

	local is = 0
	local iq = 0
	if `version' >= 16 {
		local kv = 0
	}
	if `ltrend' {
		local is0 = `is'
		local `++is'
		mata: `Amat'[`is',`is'] = 1
		mata: `Dmat'[1,`is'] = 1

		if `lerror' {
			local `++iq'
			mata: `Cmat'[`is',`iq'] = 1
			mata: `Qmat'[`iq',`iq'] = 1
			/* must have spaces before `iq'			*/
			mat `Gamma' = (nullmat(`Gamma'),(7\ `iq'\ `iq'\0))
			if `version' < 16 {
				local dnames `"`dnames' var(level):_cons"'
				local veqs `"`veqs' var(level)"'
			}
			else {
				local dnames `"`dnames' /:var(level)"'
				local `++kv'
			}
		}

		local dti = 1
		forvalues i=1/`lorder' {
			local `++is'
			local dti = `dti'/`i'
			mata: `Amat'[`is',`is'] = 1
			local k = `is0'
			forvalues j=`is'/`=`lorder'+1' {
				mata: `Amat'[`++k',`j'] = `dti'
			}
			if `derror' & `i'==1 {
				if `version' < 16 {
					local nm "var(slope):_cons"
					local dnames `"`dnames' `nm'"'
					local veqs `"`veqs' var(slope)"'
				}
				else {
					local dnames `"`dnames' /:var(slope)"'
					local `++kv'
				}
				local `++iq'
				mata: `Qmat'[`iq',`iq'] = 1
				mata: `Cmat'[`is',`iq'] = 1
				/* must have spaces before `iq'		*/
				mat `Gamma' = (nullmat(`Gamma'), ///
					(7\ `iq'\ `iq'\0))
			}
		}
		local list level linear quadratic cubic
	}
	if (`seasonal') {
		/* time domain seasonal					*/
		local `++is'
		if `serror' {
			local `++iq'
			mata: `Qmat'[`iq',`iq'] = 1
			mata: `Cmat'[`is',`iq'] = 1
			mat `Gamma' = (nullmat(`Gamma'),(7\ `iq'\ `iq'\0))
			if `version' < 16 {
				local dnames `"`dnames' var(seasonal):_cons"'
				local veqs `"`veqs' var(seasonal)"'
			}
			else {
				local dnames `"`dnames' /:var(seasonal)"'
				local `++kv'
			}
		}
		local is1 = `is'+`seasonal'-2
		mata: `Amat'[|`is', `is'\ `is1', `is1'|] = `As'
		mata: mata drop `As'
		mata: `Dmat'[1,`is'] = 1

		local is = `is1'
		local scomp seasonal(`seasonal')
	}
	tempname G1
	forvalues ci=1/`ncycles' {
		/* frequency domain cycle				*/
		local `++is'
		local `++iq'
		mat `G1' = (nullmat(`G1'), (9\ `is' \ `is' \ `corder`ci''))
		local d1 `"`d1' cycle`ci':frequency"'

		local is1 = `is' + (`corder`ci''-1)*2 - 1
		mat `Gamma' = (nullmat(`Gamma'),(7\ `iq'\ `iq'\ 0))
		if `version' < 16 {
			local dnames `"`dnames' var(cycle`ci'):_cons"'
			local veqs `"`veqs' var(cycle`ci')"'
		}
		else {
			local dnames `"`dnames' /:var(cycle`ci')"'
			local `++kv'
		}

		/* var(cycle)>0 --> damping < 1
		 * else var(cycle)=0 --> damping = 1			*/
		mat `G1' = (nullmat(`G1'), (10\ `is'\ `is'\ `corder`ci''))
		local d1 `"`d1' cycle`ci':damping"'
		local eqs1 `"`eqs1' cycle`ci'"'
		mata: `Qmat'[`iq',`iq'] = 1
		forvalues i=1/2 {
			local `++is1'
			mata: `Cmat'[`is1',`iq'] = 1
		}

		local is1 = `is' + 2*`corder`ci''-1
		mata: `Amat'[|`is', `is'\ `is1', `is1'|] = `Ac`ci''
		mata: mata drop `Ac`ci''
		mata: `Dmat'[1,`is'] = 1

		local is = `is1'
		local orders `orders' `corder`ci''
	}
	if `ncycles' {
		/* flag for cycles					*/
		mata: `Qinfo'[1,1] = 2

		local periods (`periods')

		if (`ncycles'==1) local ccomp order `corder1' cycle
		else {
			local o1 : word 1 of `orders'
			local orders : subinstr local orders "`o1'" "`o1'", ///
				all word count(local on)

			if (`on'==`ncycles') local orders `o1'

			local ccomp `ncycles' cycles of order `orders'
		}
		mat `Gamma' = (`G1',`Gamma')
		local dnames `"`d1' `dnames'"'
		local eqs `"`eqs1' `eqs'"'
	}
	if `k_obser_err' {
		/* idiosyncratic error is a sspace observation eq error	*/

		mat `Gamma' = (nullmat(`Gamma'),(8\1\1\0))
		if `version' < 16 {
			local dnames `"`dnames' var(`depvar'):_cons"'
			local veqs `"`veqs' var(`depvar')"'
		}
		else {
			local dnames `"`dnames' /:var(`depvar')"'
			local `++kv'
		}
		/* R dscalar structure					*/
		mata: `Qinfo'[1,4] = 1 
		/* dim R						*/
		mata: `Qinfo'[1,5] = 1
		if ("`depvar0'"=="") local depvar0 `depvar'
	}
	if `version' >= 16 {
		/* always at least one variance component		*/
		local veqs `"`veqs' /"'
	}
	local veqs : list retokenize veqs

	`vv' ///
	mat colnames `Gamma' = `dnames'
	_sspace_equation_order, gamma(`Gamma') state_deps(`state_eq') ///
		obser_deps(`depvar0')
	mat `Gamma' = r(gamma)
	local dnames : colfullnames `Gamma'
	/* colnames morphs /:name to /name, put the colon back		*/
	FixFreeParams, stripe(`"`dnames'"')
	local dnames `"`s(stripe)'"'

	/* user constraints and implied constraints from factor 	*/
	/* variables							*/
	tempname b V
	mat `b' = J(1,colsof(`Gamma'),1)
	`vv' ///
	matrix colnames `b' = `dnames'
	matrix rownames `b' = ucm

	matrix `V' = `b''*`b'
	`vv' ///
	matrix colnames `V' = `dnames'
	`vv' ///
	matrix rownames `V' =  `dnames'

	ereturn post `b' `V'

	`vv' ///
	makecns `constraints' 

	local k_autoCns = r(k_autoCns)
	local ncns = 0
	if "`constraints'"!="" | `k_autoCns' {
		tempname T a Cm
		cap matcproc `T' `a' `Cm'
		if c(rc) {
			/* all constraints were dropped in makecns	*/
			local Cm
			local T
			local a
		}
		else local ncns = rowsof(`Cm')

		if "`Cm'" != "" {
			CheckVarConstr, gamma(`Gamma') cm(`Cm')
			if `r(vzeros)' > 0 {
				di as err "{p}constraining variance " ///
				 "components to zero is not allowed{p_end}"
				exit 412
			}
			if `r(dzeros)' > 0 {
				di as err "{p}constraining damping effects " ///
				 "to zero is not allowed{p_end}"
				exit 412
			}
			if `r(dones)' > 0 {
				di as err "{p}constraining damping effects " ///
				 "to one is not allowed{p_end}"
				exit 412
			}
			else if "`method'"=="cdejong" & `r(nv)'>0 {
				di as err "{p}{bf:method(cdejong)} may not " ///
				 "be used when constraints are placed on "   ///
				 "the variance components{p_end}"
				exit 412
			}
		}
	}
	local nest = colsof(`Gamma')-`ncns'

	if (`N'<=`=`nest'+1') error 2001
	if `k_state' >= `N' {
		di as err "{p}`N' observations is insufficient to fit " ///
		 "your model; the state-space representation has "      ///
		 "`k_state' states{p_end}"
		exit 459
	}
	if `N' < 10*`nest' {
		di as txt "{p}note: attempting to estimate `nest' " ///
		 "parameters using `N' observations{p_end}"
	}

	local ssvec (&`Amat',&`Bmat',&`Cmat',&`Dmat',&`Fmat',&`Gmat'
	local ssvec `ssvec',&`Qmat',&`Rmat',&`Qinfo')
	local csropt ("`Cm'","`T'","`a'")
	local initopt ("ucm","`method'","","","`seed'")

	mata: _sspace_entry(`ssvec', "`Gamma'", "`from'", `csropt', `mlopt', ///
		`initopt', "`touse'", `"`depvar'"', `"`fvindeps'"')

	tempname b V

	mat `b' = r(b)
	mat `V' = r(V)

	local k = colsof(`b')
	`vv' ///
	mat colnames `b' = `dnames'
	mat rownames `b' = ucm

	local eqs : coleq `b'
	local eqs : list uniq eqs
	if "`eqs'" == "_" {
		/* if no equation names coleq returns _			*/
		local eqs
	}

	`vv' ///
	mat rownames `V' = `dnames'
	`vv' ///
	mat colnames `V' = `dnames'

	ereturn post `b' `V' `Cm', obs(`=r(N)') esample(`touse') 

	_sspace_epost, state_deps(`states') obser_deps(`depvar') ///
		indeps(`fvindeps') k_obser_err(`k_obser_err')  ///
		k_state_err(`k_state_err') method(`method')      ///
		dnames(`dnames') hidden

	local keq : list sizeof eqs
	ereturn scalar k_eq = `keq'
	local weqs : list eqs - veqs
	local df_m = 0
	foreach eq of local weqs {
		qui test [`eq'], `accum'

		local df_m = r(df)
		local accum accum
	}
	ereturn hidden scalar version = cond(`version'<16,1,2)
	ereturn scalar p = r(p)
	ereturn scalar df_m = `df_m'
	ereturn scalar chi2 = r(chi2)
	ereturn local chi2type Wald
	ereturn hidden matrix gamma = `Gamma', copy
	if `version' < 16 {
		local kv : list sizeof veqs
		ereturn scalar k_aux = `kv'
	}
	else {
		ereturn hidden scalar k_var = `kv'
	}
	tempname bp
	_b_pclass PCDEF : default
	 mat `bp' = J(1,`k',`PCDEF')
	`vv' ///
	mat colnames `bp' = `dnames'
	if (`kv') {
		_b_pclass PCVAR : VAR
		if `k_obser_err' {
			_b_pclass PCVAR1 : VAR1
		}
		forvalues i=1/`k' {
			if `Gamma'[1,`i'] == 7 {
				mat `bp'[1,`i'] = `PCVAR'
			}
			else if `Gamma'[1,`i'] == 8 {
				mat `bp'[1,`i'] = `PCVAR1'
			}
		}
	}
	ereturn hidden mat b_pclass = `bp'

	ereturn hidden scalar k_obser = 1
	ereturn hidden scalar k_state = `k_state'
	ereturn hidden scalar k_state_err = `k_state_err'
	ereturn hidden scalar k_obser_err = `k_obser_err'
	if ("`k_autoCns'"!="") ereturn hidden scalar k_autoCns = `k_autoCns'

	/* -margins- are not allowed					*/
	ereturn local marginsok	
	ereturn local marginsnotok _ALL 

	ereturn scalar tmax = `tmax'
	ereturn scalar tmin = `tmin'
	ereturn hidden scalar tdelta = `tdelta'
	ereturn local tmins `tmins'
	ereturn local tmaxs `tmaxs'
	ereturn hidden local tunit `tunit'
	ereturn hidden local tdeltas `tdeltas'

	fvrevar `depvar', list
	local depvar `r(varlist)'
	ereturn local depvar `depvar'
	ereturn local tvar `tvar'
	/* observed dependent variables with TS operators		*/
	ereturn hidden local obser_deps `depvar'
	/* state variables for postestimation labeling			*/ 
	ereturn hidden local state_deps `states'
	/* method is always dejong					*/
	ereturn hidden local method `e(method)'
	ereturn scalar k_dv = `:word count `depvar''
	/* k = # estimated state space parameters 			*/
	ereturn scalar k = `ky' + `kv'
	ereturn local eqnames `eqs'
	ereturn local model `model'
	ereturn scalar k_cycles = `ncycles'

	/* observed indep vars with TS operators and expanded factors	*/
	if `ky' {
		ereturn local covariates `fvindeps'
	}
	else {
		ereturn local covariates _NONE
	}
	ereturn local predict ucm_p
	ereturn local estat_cmd ucm_estat
	ereturn local cmdline `"`cmdline'"'
	local comp Components: `lcomp'
	if "`scomp'" != "" {
		if ("`lcomp'"!="") local comp `comp',
		local comp `comp' `scomp'
	}
	if "`ccomp'" != "" {
		if ("`lcomp'"!="") local comp `comp',
		local comp `comp' `ccomp'
	}
	ereturn hidden local title2 "`comp'"
	ereturn local title "Unobserved-components model"
	ereturn local cmd ucm

	Replay, `diopts'
end

program define Replay
	version 12
	syntax, [ * ]

	_get_diopts diopts, `options'

	local ever = cond(missing(e(version)),1,e(version))

	if (e(df_m)==0) _coef_table_header, nomodeltest
	else _coef_table_header

	_coef_table, `diopts'
	local w `"`s(width)'"'
	if !e(stationary) di as txt "Note: Model is not stationary."

	local kvar = cond(`ever'==1,e(k_aux),e(k_var))
	if `kvar' {
		di as smcl "{p 0 6 2 `w'}"
		di as smcl "Note: Tests of variances against zero " ///
		 "are one sided, and the two-sided confidence intervals "  ///
		 "are truncated at zero."
		di as smcl "{p_end}"
	}
	if e(tdelta) > 1 {
		di as smcl "{p 0 6 2 `w'}"
		di as smcl "Note: Time units are in `e(tdeltas)'."
		di as smcl "{p_end}"
	}
	if !e(converged) di as smcl "Note: Convergence not achieved."
end

program define ParseSeasonal, sclass
	version 12
	cap syntax anything(name=period id="period") [, STOchastic ///
		DETerministic ]
	if c(rc) {
		di as err "{bf:seasonal(`0')} is invalid; " _c
		/* display the specific problem				*/
		syntax anything(name=period id="period") [, STOchastic ///
			DETerministic ]
	}
	/* undocumented: deterministic, stochastic always		*/
	tempname k
	cap scalar `k' = `period'
	if c(rc) {
		di as err "the seasonal period must be an integer"
		exit 198
	}
	local per = trunc(float(`k'))
	if float(`k') != `per' {
		di as err "the seasonal period must be an integer"
		exit 198
	}
	if `per' < 2 {
		di as error "{p}the seasonal period must be an integer " ///
		 "greater than 1{p_end}"
		exit 198
	}
	sreturn local period = `per'

	local wc : word count `stochastic' `deterministic'
	if `wc' > 1 {
		di as err "{p}{bf:stochastic} and {bf:deterministic} may " ///
		 "not be combined{p_end}"
		exit 198
	}
	sreturn local error `stochastic'`deterministic'
end

program define ParseMethod, sclass
	version 12
	cap syntax, [ HYBrid DEJong KDIFfuse CDEJong ]

	if c(rc) {
		gettoken comma 0 : 0, parse( ,)
		local opt : list retokenize 0
		
		di as err "{bf:method(`opt')} is not allowed"
		exit c(rc)
	}
	local method `hybrid' `dejong' `kdiffuse' `cdejong'
	/* not documented: kdiffuse, cdejong, hybrid			*/

	local wc : word count `method'

	if `wc' > 1 {
		local method `method' `options'
		local method : list retokenize method
		di as err "option {bf:method(`method')} is not allowed"

		exit 198
	}
	sreturn clear
	if (`wc'==1) sreturn local method `method'
	else sreturn local method dejong
end

program ParseCycles, sclass
	version 12
	syntax, n(integer) [ * ]

	sreturn clear
	sreturn local k = 0

	ParseCycle, k(0) n(`n') `options'

	tempname cy
	local ncycles = `s(k)'
	if (`ncycles'==0) exit

	local nc = 0
	forvalues i=1/`ncycles' {
		local nc = `nc' + ("`s(freq`i')'"!="")
	}
	if (`nc'==`ncycles') exit

	/* start frequencies 						*/
	cap tsset
	local tsunit `r(unit1)'
	local tdelta = r(tdelta)
	if `tdelta' > 1 {
		if "`tsunit'" == "d" {
			if (`tdelta'==7) local tsunit w
			else if (`tdelta'>==28 & `tdelta'<=31) local tsunit m
			else if (`tdelta'>31 & `tdelta'<=93) local tsunit q
			else if (`tdelta'>93 & `tdelta'<365) local tsunit h
			else if (`tdelta'>=365) local tsunit y
		}
		else if "`tsunit'" == "w" {
			if (`tdelta'==4) local tsunit m
			else if (`tdelta'>4 & `tdelta'<=12) local tsunit q
			else if (`tdelta'>12 & `tdelta'<52) local tsunit h
			else if (`tdelta'>=52) local tsunit y
		}
		else if "`tsunit'" == "m" {
			if (`tdelta'==3) local tsunit q
			else if (`tdelta'>3 & `tdelta'<12) local tsunit h
			else if (`tdelta'>=12) local tsunit y
		}
		else if "`tsunit'" == "q" {
			if (`tdelta'>=2 & `tdelta'<4) local tsunit h
			else if (`tdelta'>=4) local tsunit y
		}
		else if "`tsunit'" == "h" {
			if (`tdelta'>=2) local tsunit y
		}
	}
	/* cycles distributed through out first 1/3 of the series	*/
	local q = (`ncycles'+1)*(`ncycles'+2)/2
	local inc = ceil(`n'/3/`q')
	if "`tsunit'" == "d" {
		local z = 30
	}
	else if "`tsunit'" == "w" {
		local z = 26
	}
	else if "`tsunit'" == "m" {
		local z = 24
	}
	else if "`tsunit'" == "q" {
		local z = 12
	}
	else if "`tsunit'" == "h" {
		local z = 20
	}
	else if "`tsunit'" == "y" {
		local z = 10
	}
	else { // generic
		local z = 20
	}
	if (`inc'>`z') local inc = `z'

	local m = `n'/3
	local pi = `m'+1
	local inc = `inc' + 1
	while `pi' > `m' {
		local inc = `inc'-1
		if `inc' <= 2 {
			di as err "{p}failed to find appropriate cycle " ///
			 "initial frequency; use option "		 ///
			 "{bf:cycle({it:#},frequency({it:#}))} to set "	 ///
			 "the initial cycle frequency{p_end}"
			exit 480
		}
		local pi = `inc'
		forvalues i=2/`ncycles' {
			local pi = `pi' + `i'*`inc'
		}
	}
	forvalues i=`ncycles'(-1)1 {
		local fi = 2*c(pi)/`pi'
		if ("`s(freq`i')'"=="") sreturn local freq`i' = `fi'

		local pi = `pi'-`i'*`inc'
	}
end

program define ParseCycle, sclass
	version 12
	syntax, k(integer) n(integer) [ CYCle(string) * ]

	if "`cycle'" == "" {
		sreturn local options `options'
		sreturn local k = `k'
		exit
	}
	ParseCycleOrder `n': `cycle'

	local `++k'
	if `k' > 3 {
		di as err "{p}too many cycles; no more than three cycles " ///
		 "can be estimated by {bf:ucm}{p_end}"
		exit 198
	}
	sreturn local order`k' = `s(o)'
	sreturn local o
	if "`s(f)'" != "" {
		sreturn local freq`k' = `s(f)'
		sreturn local f
		forvalues j=1/`=`k'-1' {
			if "`s(freq`j')'" != "" {
				if `s(freq`k')' > `s(freq`j')' {
					local tf = `s(freq`j')'
					local to = `s(order`j')'
					sreturn local freq`j' = `s(freq`k')'
					sreturn local freq`k' = `tf'
					sreturn local order`j' = `s(order`k')'
					sreturn local order`k' = `to'
				}
			}
		}
	}
	ParseCycle, k(`k') n(`n') `options'
end

program define ParseCycleOrder, sclass
	version 12

	gettoken n 0 : 0, parse(":")
	gettoken colon 0 : 0, parse(":")
	cap syntax anything(id=order name=order) [, Period(string) ///
		Frequency(string) ]
	/* undocumented: cycle(#, period(#))				*/
	if c(rc) {
		local 0 : list retokenize 0
		di as err "{bf:cycle(`0')} is invalid; " _c
		/* display the specific problem				*/
		syntax anything(id=order name=order) [, PERiod(string) ///
			FREQuency(string) ]
	}
	cap numlist "`order'", min(1) max(1) integer 
	if c(rc) {
		di as err "cycle order {bf:`order'} is invalid"
		exit 198
	}
	local order = `r(numlist)'
	if (`order'<1 | `order'>3) {
		di as err "cycle order must be 1, 2, or 3"
		exit 198
	}
	sreturn local o = `order'

        local k : word count `period' `frequency'
	if (!`k') exit

	if "`period'"!="" & "`frequency'"!="" {
		di as err "{p}{bf:cycle()} suboptions {bf:period({it:#})} " ///
		 "and {bf:frequency({it:#})} may not be combined{p_end}"
		exit 198
	}
	if "`frequency'" != "" {
		tempname f
		cap scalar `f' = `frequency'
		if c(rc) {
			di as err "{p}{bf:cycle()} suboption " ///
			 "{bf:frequency()} is incorrectly specified{p_end}"
			exit 198
                }
		local rc = 0
		local min = 2*_pi/`n'
		if `frequency' <= `min' {
			di as err "{p}cycle frequency must be in (2*_pi/" ///
			 "{help _variables:_N}, {help _variables:_pi}) "  ///
			 "and must not be too close to zero{p_end}"
			exit 198
		}
		if `frequency' >= c(pi)*(1-c(epsfloat)) { 
			di as err "{p}cycle frequency must be in (2*_pi/" ///
			 "{help _variables:_N}, {help _variables:_pi}) "  ///
			 "and must not be too close to _pi{p_end}"
			exit 198
		}
	}
	else { // period
		tempname p
		cap scalar `p' = `period'
		if c(rc) {
			di as err "{p}{bf:cycle()} suboption {bf:period()} " ///
			 "is incorrectly specified{p_end}"
			exit 198
		}
		if `period'<=2 | `period'>=`n' { 
			local N = _N
			di as err "{p}cycle period must be in " ///
				"[3,`=`n'-1']{p_end}"
			exit 198
		}
		local frequency = 2*c(pi)/`p'
	}
	sreturn local f = `frequency'
end

/* leave NONE capitalized					*/
program ParseModel, sclass
	version 12
	cap syntax, [ NONE ntrend dconstant llevel rwalk dtrend lldtrend ///
		rwdrift lltrend strend rtrend ]
	local rc = c(rc)
	if `rc' {
		di as err "{p}{bf:model()} must be one of {bf:none}, "      ///
		 "{bf:ntrend}, {bf:dconstant}, {bf:llevel}, {bf:rwalk}, "   ///
		 "{bf:dtrend}, {bf:lldtrend}, {bf:rwdrift}, {bf:lltrend}, " ///
		 "{bf:strend}, or {bf:rtrend}; see help {helpb ucm}{p_end}"
		exit `rc'
	}
	local model `none' `ntrend' `dconstant' `llevel' `rwalk' `dtrend' 
	local model `model' `lldtrend' `rwdrift' `lltrend' `strend' `rtrend'
	local wc : word count `model'

	if `wc' > 1 {
		di as err "only one {bf:model()} option is allowed"
		exit 198
	}
	if `wc' == 1 {
		sreturn local model `:list retokenize model'
	}
	else { // default model
		sreturn local model rwalk
	}
end

program CheckVarConstr, rclass
	version 12
	syntax, gamma(string) cm(string)

	local p = colsof(`gamma')
	local m = rowsof(`cm')
	local p1 = `p' + 1
	if `m'==0 | (`=colsof(`cm')'!=`p1') {
		return local n = 0
		return local vzeros = 0
		return local dzeros = 0
		return local dones = 0
		exit
	}
	local vzeros = 0
	local dzeros = 0
	local dones = 0
	local nv = 0
	local nd = 0
	local eps = c(epsdouble)*2^20
	forvalues j=1/`m' {
		local nvi = 0
		local ndi = 0
		forvalues i=1/`p' {
			if `gamma'[1,`i']==7 | `gamma'[1,`i']==8 {
				/* variance component			*/
				if `cm'[`j',`i'] != 0 {
					local `++nvi'
				}
			}
			if `gamma'[1,`i'] == 10 {
				/* damping effect			*/
				if `cm'[`j',`i'] != 0 {
					local `++ndi'
				}
			}
		}
		local nv = `nv' + (`nvi'!=0)
		if `nvi' == 1 {
			/* avoid two variances constrained to be equal	*/
			local vzeros = `vzeros' + (`cm'[`j',`p1']<=`eps')
		}
		local nd = `nd' + (`ndi'!=0)
		if `ndi' == 1 {
			/* avoid two damping effects constrained to 	*/
			/*  be equal					*/
			local dzeros = `dzeros' + (`cm'[`j',`p1']<`eps')
			local dones = `dones' + (`cm'[`j',`p1']>1-`eps')
		}
	}
	return local nv = `nv'
	return local nd = `nd'
	/* number of variances constrained to 0				*/
	return local vzeros = `vzeros'
	/* number of damping effects constrained to 1			*/
	return local dones = `dones'
	/* number of damping effects constrained to 0			*/
	return local dzeros = `dzeros'
end

program	FixFreeParams, sclass
	version 12
	syntax, stripe(string)

	while "`stripe'" != "" {
		gettoken coef stripe : stripe, bind
		local k = ustrlen("`coef'")
		if `k' > 1 {
			local s = usubstr("`coef'",1,1)
			if "`s'" == "/" {
				local c = ustrpos("`coef'",":")
				if !`c' {
					local name = usubstr("`coef'",2,`--k')
					local coef "/:`name'"
				}
			}
		}
		local stripe1 `"`stripe1' `coef'"'
	}
	sreturn local stripe `"`stripe1'"'
end

exit
