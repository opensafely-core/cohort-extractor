*! version 1.3.3  06mar2019

program define sspace, eclass byable(onecall)
	local vv : display "version " _caller() ":"
	version 11

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if replay() {
		if ("`e(cmd)'"!="sspace") error 301
		
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

program Estimate, eclass byable(recall) sortpreserve
	local version = string(_caller())
	local vv "version `version':"
	version 11

	gettoken _mnames 0 : 0, parse(":")
	gettoken colon 0 : 0, parse(":")

	syntax anything(id="equation list") [if] [in], 	///
		[			///
		CONSTraints(numlist integer >=1 <=1999)	///
		COVSTate(string)	///
		COVOBserved(string)	///
		METHod(string)		///
		from(string)		///
		given(string)		///
		seed(string)		///
		NOLOg                   ///
		LOg                     ///
		*]

	/* undocumented: seed(string), seed for 10 random initial	*/
	/*  estimates							*/
        qui tsset, noquery
	local cmdline `"sspace `:list retokenize 0'"'

	ParseMethod, `method'
	local method `s(method)'
	if "`given'" != "" {
		/* option given is not documented			*/
		if "`method'"!="" {
			di as err "{p}options {bf:method()} and " ///
			 "{bf:given()} may not be combined{p_end}"
			exit 184
		}
		ParseGiven `given'
		
		local z0 `r(z0)'
		local Sz0 `r(Sz0)'
		local method user
	}

	// iterlog 
	opts_exclusive "`log' `nolog'"
	if ("`c(iterlog)'"=="off" & "`log'"=="") {
		local log nolog 
	}
	if ("`nolog'"!="") {
		local log nolog
	}
	_parse_optimize_options, `options' `log'
	local mlopt `s(mlopts)'

	_get_diopts diopts rest, `s(rest)'
	if "`rest'" != "" {
		local wc: word count `s(rest)'
		di as err `"{p} `=plural(`wc',"option")' {bf:`s(rest)'} "' ///
		 `"`=plural(`wc',"is","are")' not allowed{p_end}"'
		exit(198)
	}
	_parse expand eqninfo left : anything  
	local k_eqs = `eqninfo_n'

	/* first pass though the equations determines error-terms	*/
	/*  syntax or covariance structure syntax			*/
	forvalues i = 1/`k_eqs' {
		local tmp : subinstr local eqninfo_`i' "," ",",	 ///
			count(local cms)

		EQNparse1 `eqninfo_`i'' `add'

		local eterms `eterms' `r(state_eterms)'`r(obser_eterms)'
		local errors `errors' `r(state_error)'`r(obser_error)'
		local states `states' `r(state_dep)'
		local obser `obser' `r(obser_dep)'
	}

	if `:word count `eterms'' > 0 {
		local edefault noerror
		local tmp : subinstr local errors "noerror" "noerror", ///
			count(local ne)

		if `ne' > 0 {
			di as err "{p}option {bf:noerror} may not be used " ///
			 "with the error-terms syntax{p_end}"
			exit 184
		}
		local defltcov default(identity)
	}
	else local edefault error

	tempname Qinfo Gamma Amat Bmat Cmat Dmat Fmat Gmat Qmat Rmat
	tempname set_mata oet_mata

	local mlist `Qinfo' `Gamma' `Amat' `Bmat' `Cmat' `Dmat' `Fmat' 
	local mlist `mlist' `Gmat' `Qmat' `Rmat' `set_mata' `oet_mata'
	c_local `_mnames' `mlist'

	/* Qinfo (case={0,1}, Q/Q1 structure, dim(Q/Q1), 		*/
	/* 		R/Q2 structure,	 dim(R/Q2), p, q)		*/
	/* case=0 -> standard Q and R (applies to all -sspace- models)	*/
	/*      1 -> kronecker Q with Q1 and Q2 (see -dfactor-)		*/
	/* Q?/R structure = 0->identity, 1->dscalar, 2->diagonal, 	*/
	/* 		3->unstructured					*/
	/* p = Q1 kronecker product parameter (see -dfactor-)		*/
	/* q = Q2 kronecker product parameter (see -dfactor-)		*/
	mata: `Qinfo' = J(1,7,0)
	_sspace_covstructure_parse, opname(covstate) `covstate' `defltcov'
	local state_covstruct `r(structure)'
	mata: `Qinfo'[1,2] = `r(struct_code)'

	_sspace_covstructure_parse, opname(covobserved) `covobserved' `defltcov'
	local obser_covstruct `r(structure)'
	mata: `Qinfo'[1,4] = `r(struct_code)'

	marksample touse 

	tempvar cons
	local i_s 0
	local i_o 0
	local eterms = 0
	local hascons = 0
	forvalues i = 1/`k_eqs' {
		local tmp : subinstr local eqninfo_`i' "," ",",	 ///
			count(local cms)

		/* parsing state: options or variables			*/
		if (mod(`cms',2)>0) local add " cvar(`cons') touse(`touse')"
		else local add ", cvar(`cons') touse(`touse')"

		EQNparse `eqninfo_`i'' `add' edefault(`edefault') ///
			statenames(`states') obsernames(`obser') 

		if "`r(type)'" == "state" {
			local ++i_s
			local seq_dep`i_s'     `r(state_dep)'
			local seq_ind`i_s'     `r(state_indeps)'
			local seq_eterms`i_s'  `r(state_eterms)'
		}
		else {				// must be observed
			local ++i_o
			local oeq_dep`i_o'      `r(obser_dep)'
			local oeq_ind`i_o'      `r(obser_indeps)'
			local oeq_eterms`i_o'   `r(obser_eterms)'
		}

		local state_deps      `state_deps'      `r(state_dep)'
		local state_indeps    `state_indeps'    `r(state_indepns)'
		local state_eterms    `state_eterms'    `r(state_eterms)'
		local state_error     `state_error'     `r(state_error)'

		local obser_deps      `obser_deps'      `r(obser_dep)'
		local obser_indeps    `obser_indeps'    `r(obser_indepns)'
		local obser_eterms    `obser_eterms'    `r(obser_eterms)'
		local obser_error     `obser_error'     `r(obser_error)'

		local hascons = (`hascons'|`r(hascons)')
		local indeps `indeps' `r(indeps)'
	}
	/* independent variables, excluding states, no operators	*/
	local indeps : list uniq indeps

	/* check for collinear dependent variables			*/
	qui _rmcoll `obser_deps', noconstant
	local collvars `r(varlist)'
	local collvars : list obser_deps - collvars 

	local ncoll : word count `collvars'
	if `ncoll' > 0 {
		di as err `"{p}dependent `=plural(`ncoll',"variable")' "' ///
		 `"{bf:`collvars'} `=plural(`ncoll',"is","are")' "'	  ///
		 "collinear with other dependent variables; estimation "  ///
		 "cannot continue{p_end}"
		exit(498)
	}
	/* check for repeated depvars using different TS operators	*/
	fvrevar `obser_deps', list
	local depvar `r(varlist)'
	local dups : list dups depvar
	if "`dups'" != "" {
		local ndup : word count `dups'
		di as err `"{p}dependent `=plural(`ndup',"variable")' "'   ///
		 `"{bf:`dups'} `=plural(`ndup',"is","are")' on the left-"' ///
		 "hand-side of more than one observation equation; this "  ///
		 "is not allowed{p_end}"
		exit 498
	}
	local k_state `i_s'
	local k_obser `i_o'
	local k_state_indep = 0

	local all_indeps `state_indeps' `obser_indeps'
	local all_indeps : list uniq all_indeps

	if `hascons' {
		generate int `cons' = 1
	}	
	else {
		local noconst noconstant
	}
	local k_indeps : word count `all_indeps'

	local state_eterms : list uniq state_eterms
	local extra : list state_eterms - state_deps
	if "`extra'" != "" {
		di as err "{p 0 4}error terms specified for state "	///
		 "equations {bf:`extra'}, which do not exist{p_end}"
		exit 184
	}
	/* state_ecols will have same order as in state_deps		*/
	local state_ecols : list state_deps & state_eterms
	local k_state_ecols : word count `state_ecols'

	local obser_eterms : list uniq obser_eterms
	local extra : list obser_eterms - obser_deps
	if "`extra'" != "" {
		di as err "{p 0 4}error terms specified for observation " ///
		 "equations {bf:`extra'}, which do not exist{p_end}"
		exit 198
	}
	/* obser_ecols will have same order as in obser_deps		*/
	local obser_ecols : list obser_deps & obser_eterms

	mata: `Amat' = J(`k_state', `k_state', 0)
	mata: `Dmat' = J(`k_obser', `k_state', 0)

	if "`state_eterms'" == "" {
		local tmp : subinstr local state_error "noerror" "noerror", ///
			count(local k_state_noerrors) all
		local k_state_err = `k_state' - `k_state_noerrors'	
		if `k_state_err' & (`k_state_err'<`k_state') {
			/* need a selection matrix for state errors 	*/
			mata: `Cmat' = J(`k_state',`k_state_err',0)
			local k = 0
			forvalues i=1/`k_state' {
				local error: word `i' of `state_error'
				if "`error'" == "error" {
					mata: `Cmat'[`i',`++k'] = 1
				}
			}
		}
		else {
			mata: `Cmat' = J(0,0,.)
		}	
	}
	else {
		local k_state_err : word count `state_eterms'	
		mata: `Cmat' = J(`k_state',`k_state_err',0)
	}
	if "`covstate'"!="" & `k_state_err'==0 {
		di as err "{p}may not specify " 			///
		 "{bf:covstate(`state_covstruct')} when there are no " 	///
		 "state errors{p_end}"
		exit 198
	}
	if "`obser_eterms'" == "" {
		local tmp : subinstr local obser_error "noerror" "noerror", ///
			count(local k_obser_noerrors) all
		local k_obser_err = `k_obser' - `k_obser_noerrors'	
		if `k_obser_err' & (`k_obser_err'<`k_obser') {
			/* need a selection matrix for observed errors	*/
			mata: `Gmat' = J(`k_obser',`k_obser_err',0)
			local k = 0
			forvalues i=1/`k_obser' {
				local error: word `i' of `obser_error'
				if "`error'" == "error" {
					mata: `Gmat'[`i',`++k'] = 1
				}
			}
		}
		else {
			mata: `Gmat' = J(0,0,.)
		}
	}
	else {
		local k_obser_err : word count `obser_eterms'	
		mata: `Gmat' = J(`k_obser',`k_obser_err',0)
	}
	if "`covobserved'"!="" & `k_obser_err'==0 {
		di as err "{p}may not specify " 			  ///
		 "{bf:covobserved(`obser_covstruct')} when there are no " ///
		 "observable equation errors{p_end}"
		exit 198
	}
	if `k_state_err' <= 0 {
		di as err "{p}state equations must have at least one " ///
		 "error term{p_end}"
		exit 498
	}
				// Do not change these initializations
	mata: `Qmat' = I(`k_state_err')
	mata: `Rmat' = I(`k_obser_err')

	local k = 0
	forvalues i=1/`k_state' {
		GetFlist `seq_ind`i''
		local seq_state `r(flist)'
		local nv : word count `seq_ind`i''
		forvalues j=1/`nv' {
			local nme : word `j' of `seq_state'
			local col : list posof "`nme'" in state_deps
			if !`col' {
				continue
			}
			local nme : word `j' of `seq_ind`i''
			local dnames `"`dnames' `seq_dep`i'':`nme'"'
			mat `Gamma' = (nullmat(`Gamma'), (1 \ `i'\ `col'))
		}

		local seq_ind`i' : list seq_ind`i' & all_indeps
		foreach nme of local seq_ind`i' {
			if ("`nme'"=="`cons'") local name "`seq_dep`i'':_cons"
			else local name "`seq_dep`i'':`nme'"

			local dnames `"`dnames' `name'"'
			local col : list posof "`nme'" in all_indeps
			mat `Gamma' = (nullmat(`Gamma'), (2 \ `i'\ `col'))
			local `++k'
		}
	}
	if (`k') mata: `Bmat' = J(`k_state', `k_indeps', 0)
	else mata: `Bmat' = J(0,0,.)

	local k = 0
	forvalues i=1/`k_obser' {
		local oeq_ind`i' `oeq_ind`i''
		local oeq_state`i' : list oeq_ind`i' & state_deps
		foreach nme of local oeq_state`i' {
			local dnames `"`dnames' `oeq_dep`i'':`nme'"'
			local col : list posof "`nme'" in state_deps
			mat `Gamma' = (nullmat(`Gamma'), (4 \ `i'\ `col'))
		}

		local oeq_ind`i' : list oeq_ind`i' & all_indeps
		foreach nme of local oeq_ind`i' {
			if ("`nme'"=="`cons'") local name "`oeq_dep`i'':_cons"
			else local name "`oeq_dep`i'':`nme'"

			local dnames `"`dnames' `name'"'
			local col : list posof "`nme'" in all_indeps
			mat `Gamma' = (nullmat(`Gamma'), (5 \ `i'\ `col'))
			local `++k'
		}
	}
	if (`k') mata: `Fmat' = J(`k_obser', `k_indeps', 0)
	else mata: `Fmat' = J(0,0,.)

	if "`state_eterms'" == "" {
		`vv' ///
		Covstruct_mat , state covstruct(`state_covstruct') 	///
			gamma(`Gamma') deps(`state_deps') k(`k_state')	///
			errors(`state_error')
	}
	else {
		mata: `set_mata' = J(`k_state', 1, "")
		forvalues i=1/`k_state' {
			mata: `set_mata'[`i',1] = "`seq_eterms`i''"
		}

		Eterms_mat , gamma(`Gamma') deps(`state_deps') 		///
			k(`k_state') errors(`state_ecols') state	///
			eqterms(`set_mata')

		local dnames `"`dnames' `r(dnames)'"'

		if "`state_covstruct'" == "unstructured" {
			di as err "{p}option {bf:covstate(unstructured)} " ///
			 "may not be used with the error-form syntax{p_end}"
			exit 184
		}	
		`vv' ///
		Covstruct_mat , state covstruct(`state_covstruct') 	///
			gamma(`Gamma') deps(`state_ecols') 		///
			k(`k_state_err') errors(`state_error')
	}
	local dnames `"`dnames' `r(dnames)'"'
	local veqs `"`veqs' `r(veqs)'"'	

	if "`obser_eterms'" == "" {
		`vv' ///
		Covstruct_mat , observation 				///
			covstruct(`obser_covstruct') gamma(`Gamma') 	///
			deps(`obser_deps') k(`k_obser')			///
			errors(`obser_error')
	}		
	else {
		mata: `oet_mata' = J(`k_obser', 1, "")
		forvalues i=1/`k_obser' {
			mata: `oet_mata'[`i',1] = "`oeq_eterms`i''"
		}
		Eterms_mat , gamma(`Gamma') deps(`obser_deps') 		///
			k(`k_obser') errors(`obser_ecols') observation	///
			eqterms(`oet_mata')

		local dnames `"`dnames' `r(dnames)'"'

		if "`obser_covstruct'" == "unstructured" {
			di as err "{p}option "				   ///
			 "{bf:covobserved(unstructured)} may not be used " ///
			 "with the error-form syntax{p_end}"
			exit 184
		}	
		`vv' ///
		Covstruct_mat , observation covstruct(`obser_covstruct') ///
			gamma(`Gamma') deps(`obser_ecols') 		 ///
			k(`k_obser_err') errors(`obser_error')
	}
	local dnames `"`dnames' `r(dnames)'"'	
	local veqs `"`veqs' `r(veqs)'"'	
	local veqs : list retokenize veqs

	`vv' ///
	mat colnames `Gamma' = `dnames'
	_sspace_equation_order, gamma(`Gamma') state_deps(`state_deps') ///
		obser_deps(`obser_deps')
	mat `Gamma' = r(gamma)
	local dnames : colfullnames `Gamma'

	/* Deal with user constraints and implied constraints from	*/
	/*  factor variables						*/
	tempname b V
	mat `b' = J(1,colsof(`Gamma'),1)
	`vv' ///
	matrix colnames `b' = `dnames'
	matrix rownames `b' = sspace

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
	}

	_ts tvar panvar if `touse', sort onepanel
	markout `touse' `obser_deps' `all_indeps' `tvar'

	local nest = colsof(`Gamma')-`ncns'

	qui count if `touse'
	local N  = r(N)
	if (`N'==0) error 2000
	if (`N'<=`nest') error 2001
	if `N' < 10*`nest' {
		di as txt "{p}note: attempting to estimate `nest' " ///
		 "parameters using `N' observations{p_end}"
	}

	_check_ts_gaps `tvar', touse(`touse')

	tempname tmin tmax
	summarize `tvar' if `touse', meanonly
	scalar `tmax' = r(max)
	scalar `tmin' = r(min)
	local fmt : format `tvar'
	local tmins = trim(string(r(min), "`fmt'"))
	local tmaxs = trim(string(r(max), "`fmt'"))

	/* option vectors for sspace mata entry function		*/
	local ssvec (&`Amat',&`Bmat',&`Cmat',&`Dmat',&`Fmat',&`Gmat'
	local ssvec `ssvec',&`Qmat',&`Rmat',&`Qinfo')
	local covopt ("`state_covstruct'","`obser_covstruct'")
	local csropt ("`Cm'","`T'","`a'")
	local initopt ("sspace","`method'",`"`z0'"',`"`Sz0'"',`"`seed'"')

	/* do not call any rclass functions from here to _sspace_epost	*/ 
	mata: _sspace_entry(`ssvec', "`Gamma'", "`from'", `csropt', `mlopt', ///
		`initopt', "`touse'", `"`obser_deps'"', `"`all_indeps'"')

	mat `b' = r(b)
	mat `V' = r(V)

	local k = colsof(`b')
	`vv' ///
	mat colnames `b' = `dnames'
	mat rownames `b' = sspace
	local eqs : coleq `b'
	local eqs : list uniq eqs

	`vv' ///
	mat rownames `V' = `dnames'
	`vv' ///
	mat colnames `V' = `dnames'

	ereturn post `b' `V' `Cm', obs(`=r(N)') esample(`touse') buildfvinfo

	if "`cons'" != "" {
		local all_indeps : subinstr local all_indeps "`cons'" "_cons"
	}

	_sspace_epost, state_deps(`state_deps') obser_deps(`obser_deps') ///
		indeps(`all_indeps') k_obser_err(`k_obser_err')       	 ///
		k_state_err(`k_state_err') method(`method') dnames(`dnames')

	_b_pclass PCDEF : default
	_b_pclass PCVAR : VAR
	tempname bp 
	mat `bp' = J(1,`k',`PCDEF')
	forvalues i=1/`k' {
		if `Gamma'[1,`i']==7 | `Gamma'[1,`i']==8 {
			if `Gamma'[2,`i'] == `Gamma'[3,`i'] {
				mat `bp'[1,`i'] = `PCVAR'
			}
		}
	}
	`vv' ///
	mat colnames `bp' = `dnames'
	ereturn hidden matrix b_pclass = `bp'

	/* k_eq is the # equation names in e(b), used by -_coef_table-,	*/
	/* and is _not_ k_obser + k_state				*/
	local keq : list sizeof eqs
	local weqs : list eqs - veqs

	ereturn scalar k_eq = `keq'
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
	ereturn matrix gamma = `Gamma'
	if `version' < 16 {
		ereturn scalar k_aux = `:list sizeof veqs'
	}
	else {
		ereturn hidden scalar k_var = `:list sizeof veqs'
	}
	ereturn scalar k_obser = `k_obser'
	ereturn scalar k_state = `k_state'
	ereturn scalar k_state_err = `k_state_err'
	ereturn scalar k_obser_err = `k_obser_err'
	if ("`k_autoCns'"!="") ereturn hidden scalar k_autoCns = `k_autoCns'

	ereturn scalar tmax = `tmax'
	ereturn scalar tmin = `tmin'
	ereturn local tmins `tmins'
	ereturn local tmaxs `tmaxs'

	fvrevar `obser_deps', list
	local depvar `r(varlist)'
	local indeps : list indeps - cons
	local sample `depvar' `indeps' `tvar'
	local sample : list uniq sample
	signestimationsample `sample' 
	ereturn local depvar `depvar'
	ereturn local tvar `tvar'
	/* observed dependent variables with TS operators		*/
	ereturn local obser_deps `obser_deps'
	/* state variables for postestimation labeling			*/ 
	ereturn local state_deps `state_deps'
	ereturn scalar k_dv = `:word count `depvar''
	/* k = # estimated state space parameters 			*/
	ereturn scalar k = `k'
	ereturn local eqnames `eqs'

	/* -margins- are not allowed					*/
	ereturn local marginsok 
	ereturn local marginsnotok _ALL
	/* observed indep vars with TS operators and expanded factors	*/
	if `:length local all_indeps' {
		ereturn local covariates `all_indeps'
	}
	else {
		ereturn local covariates _NONE
	}

	ereturn local predict sspace_p
	ereturn local estat_cmd sspace_estat
	ereturn local cmdline `"`cmdline'"'
	ereturn local title "State-space model"
	ereturn local cmd sspace

	Replay, `diopts'
end

program define Replay
	version 11
	syntax, [ * ]

	_get_diopts diopts, `options'

	local ever = cond(missing(e(version)),1,e(version))

	if (e(df_m)==0) _coef_table_header, nomodeltest
	else _coef_table_header

	_coef_table, `diopts'

	if !e(stationary) di as txt "Note: Model is not stationary."

	local kvar = cond(`ever'==1,e(k_aux),e(k_var))
	if `kvar' {
		di as smcl "{p 0 6 0 79}" ///
		 "Note: Tests of variances against zero " ///
		 "are one sided, and the two-sided confidence intervals "  ///
		 "are truncated at zero.{p_end}"
	}
	if !e(converged) di as smcl "Note: Convergence not achieved."
end

program define EQNparse1, rclass
	version 11
	syntax anything(name=equation id=equation), ///
		[			///
		state 			///
		observation 		///
		noERRor 		///
		*			///
		]

	gettoken dep indeps : equation, bind

	cap _ms_parse_parts `dep'
	if c(rc) {
		if ("`state'"!="") di as err "state " _c
		else di as err "independent variable " _c

		di as err "{bf:`dep'} is invalid"
		exit 198
	}
	local dep
	if "`r(type)'" == "variable" {
		if "`r(ts_op)'" != "" {
			if "`state'" != "" {
				di as err "{p}states may not have " ///
				 "time-series operators in the "    ///
				 "{it:statevar}{p_end}" 
				exit 198
			}
			local dep `r(ts_op)'.
		}
		local dep `dep'`r(name)'

		if "`state'" == "" {
			tsunab dep : `dep'
		}
	}
	else {
		if ("`state'"!="") di as err "state " _c
		else di as err "independent variable " _c

		di as err "{bf:`dep'} is invalid"
		exit 198
	}

	while `:length local indeps' {
		gettoken el indeps : indeps, bind

		cap _ms_parse_parts `el'
		if c(rc) {
			continue
		}
		if "`r(type)'" == "error" {
			local eterms `eterms' `r(name)'
		}
	}
	if "`eterms'" != "" & "`error'" != "" {
		di as err "{p}option {bf:`error'} may not be used with " ///
		 "the error-terms syntax{p_end}"
		exit 184
	}
	return clear
	if "`state'" != "" {
		return local state_dep      `dep'
		return local state_eterms   `eterms' 
		return local state_error    `error'
		return local type           state
	}
	else {
		return local obser_dep      `dep'
		return local obser_eterms   `eterms' 
		return local obser_error    `error'
		return local type           obser
	}
end

program define EQNparse, rclass
	version 11
	syntax anything(name=equation id=equation), ///
		touse(varname)		///
		[			///
		state 			///
		observation 		///
		noERRor 		///
		noCONStant		///
		cvar(name)		///
		edefault(string)	///
		statenames(string)	///
		obsernames(string)	///
		]

	gettoken dep indeps : equation, bind

	/* depvars checked on first pass in .EQNpars1			*/
	/* put in canonical form					*/
	cap _ms_parse_parts `dep'
	local dep
	if ("`r(op)'"!="") local dep `r(op)'.
	local dep `dep'`r(name)'

	if "`state'" == "" {
		tsunab dep : `dep'
	}

	while `:length local indeps' {
		gettoken els indeps : indeps, bind

		/* handle varlist using wild card *			*/
		/* -fvexpand- handles ts operators combined with *	*/
		cap fvexpand `els' if `touse'
		if (!c(rc) & ("`r(fvops)'"!="true")) {
			local els `r(varlist)'
			local nels : word count `els'
			local el : word 1 of `els'
		}
		else {
			/* don't use -foreach- in case el has a space	*/
			local el `els'
			local nels = 1
		}
		forvalues iel=1/`nels' {
			local name

			if (`nels'>1) local el : word `iel' of `els'

			OPexpand `el', touse(`touse') 
			local vlist `r(varlist)'

			if `r(fv)' {
				local nv = 0
				foreach vi of local vlist {
					EQNvalidateTerm `vi', `state' ///
						states(`statenames')  ///
						obser(`obsernames')
					local `++nv'

					if "`r(type)'"=="variable" | ///
					   "`r(type)'"=="factor" {
						local indep0 `indep0' `r(name)'
					}
				}
				if `nv'==1 & "`r(type)'" == "state" {
					local ts `r(ts_op)'
					if ("`ts'"!="") local ts `ts'.

					local indepst `indepst' `ts'`r(name)'
				}
				else if "`r(type)'" != "state" {
					local indepns `indepns' `vlist'
				}
			}
			else {
				foreach vi of local vlist {
					EQNvalidateTerm `vi', `state' ///
						states(`statenames')  ///
						obser(`obsernames')

					if "`r(type)'" == "error" {
						if "`r(ts_op)'" != "" {
							local name `r(ts_op)'.
						}
						local name `name'`r(name)'
						local eterms `eterms' `name'
					}
					else if "`r(type)'" == "state" {
						local indepst `indepst' `el'
					}
					else {
						local indepns `indepns' `vi'
						if "`r(type)'"=="variable" | ///
						   "`r(type)'"=="factor" {
						local indep0 `indep0' `r(name)'
						}
					}
				}
			}
		}
	}
	if "`eterms'" != "" & "`error'" != "" {
		di as err "{p}option {bf:`error'} may not be used with " ///
		 "the error-terms syntax{p_end}"
		exit 184
	}
	return clear

	if "`statenames'" != "" {
		/* second pass						*/
		_rmcoll `indepns' if `touse', `constant'
		local indeps `r(varlist)'
		if "`constant'" == "" {
			local constant constant
			local consname `cvar'
		}

		local indeps
		while `:length local indeps' {
			gettoken el indeps : indeps, bind
			fvexpand `el'
			local indepns `indepns' `r(varlist)'
		}
		local indeps `indepst' `indepns'
	}		
	if "`error'" == "" {
		if ("`eterms'"=="") local error `edefault'
		else local error error
	}	
	if "`state'" != "" {
		return local state_dep      `dep'
		return local state_indeps   `indeps' `consname'
		/* varlist with L. stripped from states on RHS		*/
		return local state_indepns `indepns' `consname'
		return local state_eterms   `eterms' 
		return local state_error    `error'
		return local type           state
	}
	else {
		return local obser_dep      `dep'
		return local obser_indeps   `indeps' `consname'
		return local obser_indepns  `indepns' `consname'
		return local obser_eterms   `eterms' 
		return local obser_error    `error'
		return local type           obser
	}
	return local hascons ("`constant'"!="")
	return local indeps `:list uniq indep0'
end

program  OPexpand, rclass
	version 11
	syntax anything(name=expr), touse(varname) 

	cap _ms_parse_parts `expr'
	if !c(rc) & ("`r(type)'"=="variable" | "`r(type)'"=="error") {
		if ("`r(op)'"!="") local varlist `r(op)'.`r(name)'
		else local varlist `r(name)'

		return add
		return local fv = 0
		return local varlist `varlist'
	}
	else {
		cap fvexpand `expr' if `touse'
		if c(rc) {
			di as err `"{p}{bf:`expr'} is invalid{p_end}"'
			exit 198
		}
		return local fv = ("`r(fvops)'"=="true")
		return add
	}
end

program EQNvalidateTerm, rclass
	version 11
	syntax anything(name=var), [ state states(string) obser(string) ]

	cap _ms_parse_parts `var'
	if c(rc) {
		di as err `"{p}{bf:`var'} is invalid{p_end}"'
		exit 198
	}
	if "`states'"=="" & "`obser'"=="" {
		return add
		exit
	}
	if "`r(type)'" == "error" {
		return add
		exit
	}
	local istate : list posof "`r(name)'" in states
	if !`istate' {
		local iobser : list posof "`r(name)'" in obser
		if !`iobser' {
			return add
			exit
		}
		if "`state'" != "" {
			di as err "{p}may not include observed dependent " ///
			 "variables in state equations{p_end}"
			exit 198
		}
		return add
		exit
	}
	if "`state'" != "" {
		if "`r(type)'"=="variable" & "`r(ts_op)'"=="L" {
			return add
			return local type state
			exit
		}
		else {
			di as err "{p}only L.`r(name)' is allowed in state " ///
			 "equations{p_end}"
			exit 198
		}
	}
	else if "`r(ts_op)'" != "" {
		di as err "{p}time-series operators are not allowed " ///
		 "on states in observation equations{p_end}"
		exit 198
	}
	return add
	return local type state
end

program Eterms_mat, rclass
	version 11
	syntax , gamma(string) deps(string)		///
		k(integer) errors(string) 		///
		eqterms(name) [state observation]


	local cnt : word count `state' `observation'
	if `cnt' != 1 {
		di as err "error forming error-term matrix"
		exit 498
	}	
	if "`state'" != "" {
		local type state
		local mcode 3
	}
	else {				// observation case
		local type obser
		local mcode 6
	}

	forvalues i=1/`k' {
		local statei : word `i' of `deps'
		mata: st_local("seq_eterms", `eqterms'[`i', 1])
		foreach et of local seq_eterms {
			local pos : list posof "`et'" in errors
			if `pos' == 0 {
				di as err "error forming error-term matrix"
				exit 498
			}	
			_msparse e.`et'
			local et `r(stripe)'
			local dnames "`dnames' `statei':`et'"
			mat `gamma' = (nullmat(`gamma'), (`mcode' \ `i'\ `pos'))
		}
	}
	return local dnames "`dnames'"
end

program Covstruct_mat, rclass
	version 11
	local version = string(_caller())
	syntax , covstruct(string) gamma(string) deps(string)		///
		k(integer) errors(string) [state observation]

	local cnt : word count `state' `observation'
	if `cnt' != 1 {
		di as err "error forming covariance-structure matrix"
		exit 498
	}	
	if "`state'" != "" {
		local type state
		local mcode 7
		local vtype state
	}
	else {				// observation case
		local type obser
		local mcode 8
		local vtype observable
	}
	if "`covstruct'" == "dscalar" {	
		local tmp : subinstr local errors "error" "error", 	///
			all word count(local n_errors)
		if `n_errors' > 0 {
			local vname  "`type'_sigma2"
			if `version' < 16 {
				local dnames "`vname':_cons"
				local veqs "`vname'"
			}
			else {
				local dnames "/`vtype':`vname'"
				local veqs "/`vtype'"
			}
			mat `gamma' = (nullmat(`gamma'), (`mcode' \ 1\ 1))
		}
	}
	else if "`covstruct'" == "diagonal" {
		local ii = 0
		forvalues i=1/`k' {
			local err : word `i' of `errors'
			if "`err'" != "error" {
				continue
			}
			local eqn : word `i' of `deps'
			local `++ii'
			local vname var(`eqn')
			if `version' < 16 {
				local dnames `"`dnames'  `vname':_cons"'
				local veqs `"`veqs' `vname'"'
			}
			else {
				local dnames `"`dnames'  /`vtype':`vname'"'
				/* repeat vtype to count # variances	*/
				local veqs `"`veqs' /`vtype'"'
			}
			mat `gamma' = (nullmat(`gamma'), (`mcode' \ `ii'\ `ii'))
		}
	}
	else if "`covstruct'" == "unstructured" {
		local ii = 0
		/* covariance parameters in vech() order		*/
		forvalues i=1/`k' {
			local err : word `i' of `errors'
			if "`err'" != "error" {
				continue
			}
			local jj = `ii'
			local `++ii'
			local eqn_i : word `i' of `deps'
			forvalues j=`i'/`k' {
				local err : word `j' of `errors'
				if "`err'" != "error" {
					continue
				}
				local eqn_j : word `j' of `deps'
				local `++jj'

				if (`j'==`i') local vname var(`eqn_i')
				else local vname cov(`eqn_i',`eqn_j')

				if `version' < 16 {
					local dnames `"`dnames' `vname':_cons"'
					local veqs `"`veqs' `vname'"'
				}
				else {
					local dn "/`vtype':`vname'"
					local dnames `"`dnames' `dn'"'
					/* repeat vtype to count
					 *  # covariances		*/
					local veqs `"`veqs' /`vtype'"'
				}
				mat `gamma' = (nullmat(`gamma'), ///
					(`mcode' \ `jj'\ `ii'))
			}
		}
	}
	else if "`covstruct'" != "identity" {	
		di as err "invalid covariance structure for `type' errors"
		exit 498
	}

	return local dnames `"`dnames'"'
	return local veqs `"`veqs'"'
end

program ParseGiven, rclass
	version 11
	syntax namelist(id="given(state_vector cov_matrix)" min=2 max=2)

	tokenize `namelist'

	forvalues m=1/2 {
		cap mat li ``m''
		if _rc {
			di as err "matrix ``m'' does not exist"
			exit _rc
		}
	}
	return local z0 `1'
	return local Sz0 `2'
end

program ParseMethod, sclass
	version 11
	syntax, [ HYBrid DEJong KDIFfuse CDEJong * ]

	local method `hybrid' `dejong' `kdiffuse' `cdejong'
	local wc : word count `method'

	if "`options'"!="" | `wc'>1 {
		local method `method' `options'
		local method : list retokenize method
		di as err "{p}option {bf:method(`method')} is not allowed; " ///
		 "use {bf:hybrid}, {bf:dejong}, or {bf:kdiffuse}{p_end}"
		exit 198
	}
	sreturn clear
	if `wc' == 1 {
		sreturn local method `method'
	}
end

program define GetFlist , rclass
	version 11
	syntax [anything]

	local flist 
	foreach el of local anything {
		qui _msparse F.`el'
		local fel `r(stripe)'
		local flist `flist' `fel'
	}

	return local flist `flist'

end
exit

There are eight parameter matrices in -sspace- models
	
	z_t = A*z_{t-1} + B*x_t + C*e_t
	y_t = D*z_t     + F*x_t + G*v_t

	code	matrix	description
	1	A	m x m
	2	B	m x k
	3	C	m x m0, possibly selection
	4	D	n x m
	5	F	n x k
	6	G	n x n0, possibly selection
	7	Q	Cov(e_t, e_t) m0 x m0
	8	R	Cov(v_t, v_t) n0 x n0
   	Cov(e_t, v_t) = 0
	y_t observed, endogenous variables, length n
	z_t state variables, length m
	x_t exogenous variables, length k

syntax

sspace 	stateeq [stateeq ...stateeq] 
	observationeq [observationeq .. observationeq]
	[if] [in], vce(oim|robust) level(cilevel) constraints(numlist)
	COVSTate(identity|dscalar|diagonal|unstructured)
	COVOBserved(identity|dscalar|diagonal|unstructured)
	method(dejong|sdejong|kdiffuse)

The defaults are

	vce(oim) 
	covstate(diagonal) 
	covobserved(diagonal) 


