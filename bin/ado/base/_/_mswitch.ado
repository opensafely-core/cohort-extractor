*! version 1.1.0  29mar2018

program _mswitch, eclass byable(recall)
	version 14.0

	_parse comma lhs rhs : 0
	gettoken model lhs : lhs
	local 0 `lhs' `rhs'
	if ("`model'"=="dr" | "`model'"=="ar") {
		local cmd mswitch
		local cmdline mswitch `model' `0'
		if "`model'" == "dr" {
			local model msdr
		}
		else {
			local model msar
		}
	}
	else {
		di as err "{bf:`model'} is not a valid model" 
		exit 198
	}

	syntax varlist(ts fv) [if] [in] 				///
		[, 							///
			switch(string)					///
			states(numlist int min=0 max=1 >0 <=20)		///
			CONstant 					///
			p0(string)					///
			VARSWitch					///
			ar(numlist int >=0 <=10 sort)			///
			ARSWitch					///
			from(string)					///
			CONSTraints(numlist)				///
	/*max options*/							///
			vce(string)					///
			DIFficult					///
			TECHnique(string)				///
			ITERate(integer 16000)				///
			NOLOg LOg					///
			TRace						///
			GRADient					///
			showstep					///
			HESSian						///
			SHOWTOLerance					///
			TOLerance(real 1e-6)				///
			LTOLerance(real 1e-7)				///
			NRTOLerance(real 1e-5)				///
			NONRTOLerance					///
	/*EM options*/							///
			emlog						///
			EMDOTs						///
			EMITERate(numlist int min=0 max=1 >=0 <=1e4)	///
	/*display*/							///
		///	Undocumented or passthrough options below here  ///
			neq(numlist int >0 min=1 max=1)			///
			*						///
			rstart						///
		]


/**Check VCE option**/
	if ("`vce'"=="" | "`vce'"=="oim") local vcetype oim
	else if ("`vce'"==bsubstr("robust",1,max(1,strlen(`"`vce'"')))) {
		local vcetype robust
	}
	else {
		di as err "{bf:vce(`vce')} not allowed"
		exit 198
	}


/**Set EM and display option**/
	if ("`emiterate'"=="") local emiterate 10
	_get_diopts diopts, `options'
	
	local chkdiopts noci nopvalues
	local chkdiopts : list chkdiopts & diopts
	if ("`chkdiopts'"=="noci" | wordcount("`chkdiopts'")==2) {
		di as err "{p}option {bf:noci} not allowed{p_end}"
		exit 198
	}
	else if ("`chkdiopts'"=="nopvalues") {
		di as err "{p}option {bf:nopvalues} not allowed{p_end}"
		exit 198
	}
	
	local diopts "`diopts' neq(`neq')"
	_parse comma lhs rhs : 0
	if ("`rhs'"=="") local rhs ,
	if ("`states'"=="") {
		local states 2 
		local rhs "`rhs' states(`states')"
	}


/**Check syntax errors**/
	if ("`model'"=="msdr" & "`ar'"!="") {
		di as err "{p 0 8 2} option {bf:ar()} may not be specified "
		di as err "with dynamic regression model{p_end}"
		exit 198
	}
	if ("`model'"=="msdr" & "`arswitch'"!="") {
		di as err "{p 0 8 2} option {bf:arswitch} may not be specified"
		di as err "with dynamic regression model{p_end}"
		exit 198
	}

	if ("`constant'"!="") 	local cons = 1
	else			local cons =  0

	_parse comma switchvars nscons_f: switch
	if ("`states'"=="1" & "`switch'"!="") {
		if (`"`switchvars'"'!="") {
			di as err "{p 0 8 2} option {bf:switch()} may not be" 
			di as err "specified with {bf:states(1)}{p_end}"
			exit 198
		}
	}
	if ("`states'"=="1" & "`varswitch'"!="") {
		di as err "{p 0 8 2} option {bf:varswitch()} may not be" 
		di as err "specified with {bf:states(1)}{p_end}"
		exit 198
	}
	if ("`states'"=="1" & "`p0'"!="") {
		di as err "{p 0 8 2} option {bf:p0()} may not be specified with" 
		di as err "{bf:states(1)}{p_end}"
		exit 198
	}


/**Obtain ar() matrix for MSAR model**/
	tempname _tmp_armat 
	local ar_sw = 0
	matrix `_tmp_armat' = 0
	if ("`model'"=="msar") {	
		if ("`states'"=="1" & "`arswitch'"!="") {
			di as err "{p 0 8 2} option {bf:arswitch()}"
			di as err "may not be specified with "
			di as err "{bf:states(1)}{p_end}"
			exit 198
		}
		if ("`ar'"=="0" & `"`arswitch'"'!="") {
			di as err "{p 0 8 2} option {bf:arswitch} may not be "
			di as err "specified with {bf:ar(0)}{p_end}"
			exit 198
		}
	/**Convert numlist into a matrix**/
		if ("`ar'"=="") {
			di as err "option {bf:ar()} required"
			exit 198
		}	
		else {
			local _wc_ar = wordcount("`ar'")
			local _ar `ar'
			mat `_tmp_armat' = J(`_wc_ar',1,.)
			forvalues vals = 1(1)`_wc_ar' {
				gettoken arlag _ar : _ar
				mat `_tmp_armat'[`vals',1] = `arlag' 
				local maxar = `arlag'
				if (`_wc_ar'>1 & "`arlag'"=="0") {
					di as err "{p 0 8 2} you may not"
					di as err "combine {bf:ar(0)} with"
					di as err "other {bf:AR} terms{p_end}"
					exit 198
				}
			}
		}
		if (`"`arswitch'"'!="") {
			if ("`ar'"=="0") {
				di as err "{p 0 8 2} {bf:arswitch} may only be"
				di as err "specified with option {bf:ar()} "
				di as err "{p_end}"
				exit 198
			}
			local ar_sw = 1
		}		
	}


/**Check time series and mark sample**/
	marksample touse	
	_ts if `touse', sort onepanel
	qui tsreport if `touse', `detail'
	local gaps `r(N_gaps)'
	if (`gaps'!=0) {
		di as err "{p 0 8 2} gaps not allowed{p_end}"
		exit 198
	}


/**Remove collinearity for non-switching vars and save var names in locals**/
	_rmcoll `varlist' if `touse', expand 
	local varlist `r(varlist)'
	gettoken depvar nswvars : varlist
	local nswvars = ltrim("`nswvars'")
	_fv_check_depvar `depvar'


/**Check for noconstant in -switch()- and set flag**/	
	local _cmnd `0'
	local _cmndvars `varlist'
	local 0 `switch'
	syntax [varlist(ts fv)] [, NOCONstant]
	local 0 `_cmnd'
	local varlist `_cmndvars'
	if ("`noconstant'"!="")	local nscons = 1
	else			local nscons  = 0


/**Remove collinearity for switching vars and save var names in locals**/
	_rmcoll `varlist' `switchvars' if `touse', expand
	local swvars `r(varlist)'
	local switchvars : list swvars - varlist 
	if ("`switchvars'"=="" & `nscons'==1 & `cons'==1 & `states'!=1 &    ///
					"`varswitch'"=="" & "`arswitch'"=="") {
		di as err "{p 0 8 2} must specify at least one switching"
		di as err "parameter{p_end}"
		exit 198
	}


/**Check constant and noconstant spec**/
	if (`"`switchvars'"'=="" & & `nscons'==1 & 	    ///
			"`constant'"=="" & `"`varswitch'"'=="" & `states'!=1) {
		if ("`model'"=="msdr" | ("`model'"=="msar" & "`ar'"=="0") | ///
				("`model'"=="msar" & "`arswitch'"=="") ){
			di as err "{p 0 8 2}must specify at least one switching"
			di as err "parameter{p_end}"
			exit 198
		}
	}
	if (`nscons'==0 & "`constant'"!="") {
		di as err "{p 0 8 2} {bf:`constant'} is only allowed with"
		di as err "option {bf:switch(,noconstant)}{p_end}"
		exit 198
	}


/**Generate temporary lagged AR variables for MSAR model--if necessary**/
	tempname svecmsar
	mat `svecmsar' = .
	if ("`model'"=="msar" & "`ar'"!="0") {
		foreach num of numlist `ar' {
			local vars_ns
			local vars_sw
			local tvars_ns
			local tvars_sw

			foreach var in `varlist' {
				local vars_ns `vars_ns' L`num'.`var'
			}
			if ("`nswvars'"=="") {
				tempvar __nswvars`num'__
				cap qui gen `__nswvars`num'__' = 0
				local tvars_ns `tvars_ns' `__nswvars`num'__'
			}
			if ("`switchvars'"!="") {
				foreach swvar in `switchvars' {
					local vars_sw `vars_sw' L`num'.`swvar'
				}
			}
			else {
				tempvar __swvars`num'__
				cap qui gen `__swvars`num'__' = 0
				local tvars_sw `tvars_sw' `__swvars`num'__'
			}
			local allvars `allvars' `vars_ns' `tvars_ns' 	    ///
						`vars_sw' `tvars_sw'
			local rvars   `rvars'   `vars_ns'  `vars_sw'
		}

		local _cmnd `0'
		local _cmndvars `varlist'
		local 0 `allvars' `if' `in'
		syntax varlist(ts fv) [if] [in]
		markout `touse' `allvars'
		local 0 `_cmnd'
		local varlist `_cmndvars'

		local i = 0
		mat `svecmsar' = J(1,wordcount("`allvars'"),.)
		foreach val of local allvars {
			local i = `i' + 1
			_ms_parse_parts `val'
			mat `svecmsar'[1,`i'] = abs(r(omit)-1)
		}
	}

/**Setup unconditional probabilities**/
	tempname p0usrinit
	local p0 `p0'
	mat `p0usrinit' = .
	if (`"`p0'"'=="") local p0 transition 
	else {
		cap qui mat list `p0'
		local len = strlen(`"`p0'"')
		if (`"`p0'"'==bsubstr("transition",1,max(2,`len')) 	    ///
								& _rc!=0) {
			local p0 transition
		}
		else if (`"`p0'"'==bsubstr("fixed",1,max(2,`len')) 	    ///
								& _rc!=0) {
			local p0 fixed 
		}
		else if (`"`p0'"'==bsubstr("smoothed",1,max(2,`len'))        ///
								& _rc!=0) {
			local p0 smoothed 
		}
		else {
			di as err "{p 0 8 2}option {bf:p0()} must be one of"
			di as err "{bf:fixed}, {bf:transition}, or "
			di as err "{bf:smoothed}{p_end}"
			exit 198
		}
	}


/**Setup initial value matrix**/
	if (`"`from'"'!="") {
		confirm matrix `from'
		if (rowsof(`from')!=1) {
			di as err "from(`from') does not specify a row vector"
			exit 198
		}
	}
	else {
		tempname from
		mat `from' = .
	}


/**Set number of parameters**/
	if (`nscons'==1 & `cons'==0)            local nmu = 0
        else if (`nscons'==1 & `cons'==1)       local nmu = 1 
	else if (`nscons'==0 & `cons'==0)       local nmu = `states'
	local nparams = `nmu'
	local nsphi: list sizeof nswvars
	local swphi: list sizeof switchvars
	local swphi = `swphi'*`states'
	if ("`model'"=="msar" & "`maxar'"!="0") {
		if ("`ar_sw'"=="0")	local nsphi = `nsphi' + `_wc_ar'
		else	local swphi = `swphi' + `states'*`_wc_ar'
	}
	local nparams = `nparams' + `nsphi' + `swphi'
	local nsig = cond("`varswitch'"!="",`states',1)
	local nparams = `nparams' + `nsig'
	local npij = `states'*(`states'-1)
	local nparams = `nparams' + `npij'
	if ("`p0'"=="smoothed")	local nparams  = `nparams' + `states' - 1
	local num_reg = `states'-1
	if ("`model'"=="msdr")	local mlag = 0
	else if ("`model'"=="msar") local mlag = `maxar'

	markout `touse' `nswvars' `switchvars'


/**Set non-switching variable names**/
	if (`"`model'"'=="msar") {
		local arnswvars `nswvars'
		local arswitchvars `switchvars'
		if (`"`ar'"'!="0") {
			foreach i of numlist `ar' {
				local ycol_names `ycol_names' L`i'.ar
			}
			if (`"`arswitch'"'=="")	{
				local nswvars `nswvars' `ycol_names'
			}
			if (`"`arswitch'"'!="") {
				local switchvars `switchvars' `ycol_names'
			}
		}
	}
	local nscol_names `nswvars'


/**Set number of equations and equation names for nonswitching vars**/
	if (`nsphi'!=0)	local neq = 1
	else local neq = 0
	if (`states'==1) local neq = 0
	local neq = `neq' + `states'
	if (`nscons'==1 & `cons'==0) {
		if (`nsphi'==0 & `swphi'==0)	local neq = 0
		if (`nsphi'!=0 & `swphi'==0) 	local neq = 1
	}
	if (`nscons'==1 & `cons'==1) {
		local neq = 1
		if (`swphi'!=0)	local neq = `neq' + `states'
	}

	local nsvars = `nsphi'
	forvalues i = 1/`nsvars' {
		local eq_names `eq_names' `depvar'
	}
	if (`nmu'==1) {
		local nscol_names `nscol_names' _cons
		local eq_names `eq_names' `depvar'
	}


/**Set equation names for switching vars**/
	if (`states'>1) {
		forvalues i = 1/`states' {
			local state State`i'
			if (`swphi'!=0) {
				if (`nmu'==`states') {
local _tmpnum = wordcount("`switchvars'")+1
local swcol_names `swcol_names' `switchvars' _cons

					forvalues i=1/`_tmpnum' {
local eq_names `eq_names' `state'
					}
				}
				else {
					local _tmpnum = wordcount("`switchvars'")
					local swcol_names `swcol_names' `switchvars'
					forvalues i=1/`_tmpnum' {
local eq_names `eq_names' `state'
					}
				}
			}
			else if (`swphi'==0) {
				if (`nmu'==`states') {
local swcol_names `swcol_names' _cons
local eq_names `eq_names' `state'
				}
			}
		}
	}


/**Set labels for aux params**/
        if (`"`varswitch'"'!="") {
		forvalues i=1/`states' {
			local state State`i'
			local eq_names `eq_names' lnsigma`i'
		}
	}
        else {
		local eq_names `eq_names' lnsigma
	}
        local num_reg = `states'-1
	forvalues i=1/`states' {
		forvalues j=1/`num_reg' {
			local prob_names `prob_names' p`i'`j'
		}
	}

	local col_names `nscol_names' `swcol_names' _cons
	local len = strlen(`"`p0'"')
	if ("`p0'"!=bsubstr("smoothed",1,max(2,`len'))) {
		local eq_names `eq_names' `prob_names'
	}
	else {
		forvalues i=1/`num_reg'{
			local p0_names `p0_names' p`i'
		}
		local eq_names `eq_names' `prob_names' `p0_names'
	}

	if ("`model'"=="msar") {
		local eretnswvars `nswvars'
		local eretswvars `switchvars'
		local nswvars `arnswvars'
		local switchvars `arswitchvars'
	}


/**Post the constraint matrix**/
	tempname b V
	mat `b' = J(1,`nparams',0)
	mat `V' = J(`nparams',`nparams',0)
	mat colname `b' = `col_names'
	mat rowname `b' = `depvar'
	mat colname `V' = `col_names'
	mat rowname `V' = `col_names'
	mat coleq `b' = `eq_names'
	mat coleq `V' = `eq_names'
	mat roweq `V' = `eq_names'
	tempname T_cons a_cons c_cons
	mat `c_cons' = .
	if ("`constraints'"!="") {
		ereturn post `b' `V'
		capture mat makeCns `constraints'
		if _rc {
			local rc = _rc
			di in red "Constraints invalid:"
			mat makeCns `constraints'
			exit _rc
		}
		matcproc `T_cons' `a_cons' `c_cons'
		ereturn scalar constraint = 1
	}
	
	if (`gaps'!=0) {
		di as txt _newline "Number of gaps in sample: " as res `gaps'
	}

/**Start optimization**/
	opts_exclusive "`emlog' `emdots'"
	if ("`technique'"=="") local technique nr
	if ("`technique'"=="nr" | "`technique'"=="bfgs" | "`technique'"=="dfp"){
	}
        else {
		di as err "invalid optimization technique {bf:`technique'}"
		exit 198
	}
	if ("`emiterate'"!="0" & "`emlog'"=="") {
		di as txt ""
		di as txt "Performing EM optimization:"
		di as txt ""
	}

	tempname svecnsw svecsw
	mat `svecnsw' = .
	mat `svecsw'  = .
	local omit 0
	if (`"`nswvars'"'!="") {
		local i = 0
		mat `svecnsw' = J(1,wordcount("`nswvars'"),.)
		foreach val of local nswvars {
			local i = `i' + 1
			_ms_parse_parts `val'
			if (r(omit)==1)	local omit 1
			mat `svecnsw'[1,`i'] = abs(r(omit)-1)
		}
	}
	if (`"`switchvars'"'!="") {
		local i = 0
		mat `svecsw' = J(1,wordcount("`switchvars'"),.)
		foreach val of local switchvars {
			local i = `i' + 1
			_ms_parse_parts `val'
			if (r(omit)==1)	local omit 1
			mat `svecsw'[1,`i'] = abs(r(omit)-1)
		}
	}
	if (`omit'==1) {
		ereturn post `b'
		cap makecns `cnsmat'
		matcproc `T_cons' `a_cons' `c_cons'
	}

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	mata: mswitch_estimate("`depvar'", "`nswvars'", "`switchvars'",     ///
			"`touse'", "`model'", "`p0'", "`varswitch'", 	    ///
			"`rstart'", "`allvars'", `states', `cons', 	    ///
			`nscons', `ar_sw', st_matrix("`_tmp_armat'"), 	    ///
			st_matrix("`from'"), st_matrix("`p0usrinit'"), 	    ///
			`emiterate', `iterate', `tolerance', `ltolerance',  ///
			`nrtolerance', "`emlog'", "`emdots'", 		    ///
			"`difficult'", "`technique'", "`log'", "`trace'",   ///
			"`gradient'", "`showstep'", "`hessian'",	    ///
			"`showtolerance'", "`nonrtolerance'", "`vcetype'",  ///
			st_matrix("`c_cons'"), st_matrix("`svecnsw'"),	    ///
			st_matrix("`svecsw'"), st_matrix("`svecmsar'"))
/**End optimization**/
	

/**Create output**/
	tempname initvals erg 
	mat `initvals' = r(from)
	if (`omit'==1) mat `initvals' = `initvals'*`T_cons'' + `a_cons'
	mat colnames `initvals' = `col_names'
	mat coleq `initvals'	= `eq_names'
	mat `erg'	= r(erg)

	ereturn local col_names = `"`col_names'"'
	ereturn local eq_names  = `"`eq_names'"'
	ereturn scalar neq = `neq'
	ereturn scalar num_reg = `num_reg'
	ereturn local depvar = `"`depvar'"'
	ereturn hidden scalar cons 	= `cons'			//hidden
	ereturn hidden scalar nscons 	= `nscons'			//hidden
	ereturn scalar N_gaps = `gaps'

	_parse comma lhs rhs : 0
	if (`"`rhs'"'=="") local rhs , 
	_mswitch_output `lhs' `rhs' model(`model') touse(`touse')	    ///
		tcons(`T_cons') acons(`a_cons') omit(`omit')

	ereturn matrix initvals = `initvals'
	ereturn scalar emiter = `emiterate'
	ereturn local cmd = `"`cmd'"'
	ereturn local cmdline = `"`cmdline'"'
	ereturn hidden matrix armat	= `_tmp_armat'		
	ereturn hidden matrix svecnsw	= `svecnsw'		
	ereturn hidden matrix svecsw 	= `svecsw'		
	ereturn hidden matrix svecmsar	= `svecmsar'		

	if "`model'" == "msar" {
		ereturn local model "ar"
		ereturn local ar = "`ar'"
		ereturn hidden local arterms	= `"`ar'"'		//hidden
		ereturn local nonswitchvars = `"`eretnswvars'"'
		ereturn local switchvars = `"`eretswvars'"'
		ereturn hidden scalar nswvars = wordcount("`eretswvars'") 
		ereturn hidden local ar_nsvars = `"`nswvars'"'
		ereturn hidden local ar_swvars = `"`switchvars'"'
	}
	else {
		ereturn local model "dr"
		ereturn local nonswitchvars = `"`nswvars'"'
		ereturn local switchvars = `"`switchvars'"'
		ereturn hidden scalar nswvars = wordcount("`switchvars'") 
	}
	ereturn hidden scalar _cmd_comp = 1				//hidden
	if ("`nsvars'"!="")	ereturn hidden scalar nsvars = `nsvars'	//hidden
	ereturn hidden scalar mlag 	= `mlag'			//hidden
	ereturn hidden matrix erg	= `erg'				//hidden
	ereturn hidden local allvars	= `"`rvars'"'			//hidden
	/**Margins not allowed**/
	ereturn local marginsnotok _ALL

end

local SS	string scalar
local RS	real scalar
local RMAT	real matrix
local PS	pointer scalar
local CL	class _mswitch scalar

mata: 

void mswitch_estimate(`SS' depvar, nsvars, swvars, touse, model, p0, 
				varswitch, rstart, allvars,
			`RS' states, constant, nscons, ar_sw, 
			`RMAT' ar_mat, from, p0usrinit,
			`RS'  emiterate, iterate, tolerance,ltolerance,
				nrtolerance,
			`SS'  emlog, emdots, difficult, technique, nolog, trace,
				gradient, showstep, hessian, showtolerance,
				nonrtolerance, vcetype,
			`RMAT'  cons_mat, svecnsw, svecsw, svecmsar) 
{

	`CL' MSobj
	`PS' __Eval

	MSobj.model_init(depvar, touse, model, p0, rstart, ar_sw, from, 
			p0usrinit)
	MSobj.model_setup(nsvars, swvars, varswitch, allvars, states, constant,
			nscons, ar_mat, svecnsw, svecsw, svecmsar)
	MSobj.maxopts_init(emiterate, iterate, tolerance, ltolerance, 
			nrtolerance, emlog, emdots, difficult, technique, 
			nolog, trace, gradient, showstep, hessian, 
			showtolerance, nonrtolerance, vcetype, cons_mat)
	if (model=="msdr")	__Eval = &mswitcheval_msdr()
	else if (model=="msar") __Eval = &mswitcheval_msar()
	_mswitch_optimize(MSobj, __Eval)

}

end
