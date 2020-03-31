*! version 1.0.3  15oct2019
program u_mi_predictions
	local version : di "version " string(_caller()) ":"

	version 12

	_parse comma lhs rhs : 0
	local 0 `rhs'
	syntax [, predcmd(string) * ]
	local miopts `options'
	local rhs , `options'

	local M	`_dta[_mi_M]'
	local style `_dta[_mi_style]'

	if (`M'==0) {
		di as err "no imputations"
		exit 2000
	}
	else if (`M'==1) {
		di as err "insufficient imputations"
		exit 2001
	}

	// parse LHS specification
	local 0 `lhs'
	syntax [anything(name=predexp equalok)] [if/] using/ 
	local miest `"`using'"'
	if (`"`if'"'!="") {
		if (strmatch(`"`if'"',"*e(sample)*")) {
			di as err "{p}{bf:`predcmd'}: reference to "	///
				  "{bf:e(sample)} is not allowed; use " ///
				  "option {bf:esample()}{p_end}"
			exit 198
		}
		local ifspec if (`if')
	}
	// check MI estimation file	
	tempname esthold
	_estimates hold `esthold', restore nullok
	u_mi_estimate_check_using `"`miest'"' "mi `predcmd'" "norestore"
	local M_max = `s(N_est)'-1
	local fname	`"`s(fname)'"'
	local m_mi	"`s(m_mi)'"		// saved imputation numbers
	local cmdname 	"`s(cmdname)'"
	local command	`e(cmdline)'
	if ("`predcmd'"=="predictnl") {
		local census = ("`e(census)'"=="1")
		tempname df_c
		scalar `df_c' = e(df_c_mi)
	}
	if (`M_max'>`M') {
		di as err "{p 0 2 2}{bf:mi `predcmd'}: saved estimation results"
		di as err "inconsistent with current {bf:mi} data{p_end}"
		di as err "{p 4 4 2}Number of estimation results in"
		di as err `"{bf:`fname'}, `M_max', exceeds the current number"'
		di as err "of imputations, `M'.  Perhaps used estimation"
		di as err "results correspond to a different {bf:mi} dataset."
		exit 459
	}
	// check predict specification
	gettoken vlist predexp : predexp, parse("=")
	if (`"`vlist'"'=="") {
		di as err "'' found where {it:varname} expected"
		exit 7
	}
	tokenize `vlist'
	if ("`3'"!="") {
		di as err "too many variables specified"
		exit 103
	}
	if ("`2'"!="") {
		local vname `2'
		local vtype `1'
		
		if !inlist("`vtype'","byte","int","long","float","double") {
			di as err `"{bf:`vtype'} is not a valid numerical data type"'
			exit 198
		}
	}
	else {
		local vname `1'
	}
	confirm new variable `vname'
	if ("`predcmd'"=="predictnl" & ///
	    (`"`predexp'"'=="" | `"`predexp'"'=="=")) {
		di as err `"'{bf:`vlist'`predexp'}' found where {bf:`=trim("`vlist'")' = }{help mi_predict##pnl_exp:{it:pnl_exp}} expected"'
		exit 198
	}

	// check options
	_mi_`predcmd'_parse `rhs'
	local synopts `s(synopts)'
	local compute `s(compute)'
	local 0 `rhs'
	syntax [, `synopts'		///
		  ESAMPLE(varname)	///
		  STORECOMPleted ]

	// check common mi options and build macro estimations
	u_mi_estimate_chk_commonopts , ///
		implist(`m_mi') cmd(`predcmd') usingspec `miopts'
	if ("`estimations'"=="") {
		local estimations `s(estimations)'
	}
	local M : list sizeof estimations

	// check -esample()-
	if ("`esample'"!="") {
		cap assert `esample'==0 | `esample'==1
		if _rc {
			di as err "option {bf:esample()} must contain a binary " ///
				  "variable"
			exit 459
		}
		local ipvars `_dta[_mi_ivars]' `_dta[_mi_pvars]'
		local isregistered : list esample in ipvars
		if (`isregistered') {
			di as err "{p 0 2 2}option {bf:esample()}: variable"
			di as err "{bf:`esample'} cannot be registered as"
			di as err "imputed or passive; use"
			di as err "{manhelp mi_unregister MI:mi unregister}"
			di as err "to unregister this variable.{p_end}"
			exit 198
		}
	}
	// build if statement
	if ("`esample'"!="") {
		if (`"`ifspec'"'!="") {
			local ifspec `ifspec' & (`esample')
		}
		else {
			local ifspec if (`esample')
		}
	}

	// check -storecompleted-
	if ("`storecompleted'"!="" & ("`style'"=="wide" | "`style'"=="mlong")) {
		di as err "{p}option {bf:storecompleted} is allowed only in {bf:flong}"
		di as err "or {bf:flongsep}; see"
		di as err "{manhelp mi_convert MI: mi convert} to"
		di as err "convert to one of those styles{p_end}"
		exit 198
	}

	tempvar pred touse
	if ("`predcmd'"=="predict") {
		local predopts `equation' `nooffset'
		local pred1 `version' qui predict double `pred' `ifspec', ///
								xb `predopts'
		if ("`stdp'"!="") {
			tempvar sevar
			local pred2 `version' qui predict double `sevar' ///
						`ifspec', stdp `predopts'
		}
	}
	else { //predictnl
		local predopts `force' `iterate'
		local pval `p'
		local bv `bvariance'
		local wv `wvariance'
		local se2 `variance'
		tokenize `ci'
		local cil `1'
		local ciu `2'
		local newvaropts se se2 wald pval bv wv df rvi fmi re cil ciu
		if (`census'==1) {
			local nosmall nosmall
		}
		if ("`nosmall'"!="") {
			scalar `df_c' = .
		}
		if (`compute'>0) {
			tempvar sevar
			local predopts `predopts' se(`sevar')
		}
		local pred1 `version' qui predictnl double `pred'`predexp' ///
							`ifspec', `predopts'
	}

	// display notes
	if ("`replay'"=="") {
		local lnote "{p 0 2 2}("
		local rnote "){p_end}"
	}
	else {
		local lnote "{p 0 6 6}Note: "
		local rnote "{p_end}"
	}
	local blank 0
	if ("`showimputations'"!="") {
		local diimps = subinstr("`m_mi'", " ", ",", .)
		di as txt `"(`fname' contains {it:m}=`diimps')"'
	}
	if ("`predcmd'"=="predict" & "`xb'`stdp'"=="") {
		di as txt "(option {bf:xb} assumed; linear prediction)"
	}
	if ("`cmdlegend'"!="") {
		di as txt _n `"{p 2 13 2}command: {cmd:`command'}{p_end}"'
		if ("`replay'"=="") di
	}
	if ("`replay'"!="") {
		local blank 1
	}

	// sort data
	if ("`style'"=="flong" | "`style'"=="mlong") {
		sort _mi_m _mi_id
		local id _mi_id
		if ("`storecompleted'"!="" & "`style'"=="flong") {
			tempvar currid
			qui gen `c(obs_t)' `currid' = _n
			qui compress `currid'
		}
	}
	else if ("`style'"=="flongsep") {
		sort _mi_id
		local id _mi_id
		local basename `_dta[_mi_name]'
	}
	else {
		tempvar id
		qui gen `c(obs_t)' `id' = _n
		qui compress `id'
		sort `id'
	}

	// create structure to store intermediate results
	mata: u_mi_get_mata_instanced_var("mipred","__mi_pred_struct")
	mata: `mipred' = _mipred_new(`compute', ("`style'"=="flong"), ///
				     "`pval'", "`ci'", "`storecompleted'")

	// main loop
cap noi { //cap noi block -- begin
	preserve
	mi select init
	local priorcmd `r(priorcmd)'
	local rc_mi 0
	local firstimp 1
	local m_mi
	foreach i in `estimations' {
		qui estimates use `"`miest'"', number(`i')
		local imp `e(m_mi)'
		if (`e(rc_mi)'!=0) { //failed estimations
			if (`e(rc_mi)'==.) {
				mata: ///
			_mi_estimate_using_errors(`"`miest'"',"mi `predcmd'")
			}
			if ("`noerrnotes'"=="") {
				if ("`replay'"!="") {
					di
				}
				di as txt "{p}(error occurred when"
				di as txt "{bf:mi estimate} executed"
				di as txt "{bf:`cmdname'}"
				di as txt "on {it:m}=`imp'){p_end}"
			}
			local ++rc_mi
			local --M
			continue
		}
		// perform computation
		`priorcmd'
		mi select `imp'
		sort `id'
		if ("`esample'"!="") {
			qui estimates esample : `esample'
		}
		mark `touse' `ifspec'
		qui count if `touse'
		if (`firstimp') {
			local N = r(N)
			// initialize structure
			mata: _mipred_set(`mipred', "`id'", "`touse'")
			local firstm `imp'
		}
		else { //check varying sets of obs.
			local varies 0
			if (r(N)!=`N') {
				local varies 1
			}
			else {
				mata: ///
  st_local("varies", strofreal(_mipred_chk_varying(`mipred',"`id'","`touse'")))
			}
			if (`varies') {
				di as err "{p 0 2 2}"
				di as err "{bf:mi `predcmd'}: prediction"
				di as err "sets vary across imputations{p_end}"
				di as err "{p 4 4 2}The set of observations"
				di as err "used to compute predictions"
				di as err "varies between imputations"
				di as err "{it:m}=`firstm' and {it:m}=`imp';"
				di as err "this is not allowed.{p_end}"
				exit 459
			}
		}
		if ("`replay'"!="") {
			di
			di as txt "(replaying {bf:`cmdname'} on {it:m}=`imp')"
			`cmdname'
		}

		// compute and store completed-data predictions and SEs
		local firstimp 0
		`pred1'
		`pred2'
		mata: _mipred_update(`mipred', "`touse'", "`currid'",	///
				     "`pred'", "`sevar'")
		if ("`storecompleted'"!="" & "`style'"=="flongsep") {
			local m_mi `m_mi' `imp'
		}
	}
	restore

	//check that M is sufficient
	if (`M'==0) {
		di as err "no imputations to compute MI results"
		exit 2000
	}
	else if (`M'==1) {
		di as err "insufficient imputations to compute MI results"
		exit 2001
	}

	// create new variables
	if ("`predcmd'"=="predict") {
		if (`compute'==0) {
			local newvars `""`vname'", """'
			local vlab "MI linear prediction"
			local vlabsep "Linear prediction"
		}
		else {
			local newvars `""", "`vname'""'
			local vlab "S.E. of the MI prediction"
			local vlabsep "S.E. of the prediction"
		}
		if ("`storecompleted'"=="") {
			local vlabsep "`vlab'"
		}
	}
	else { //predictnl
		local compspec `",`=`df_c'',("`nosmall'"!=""),`level',`census'"'
		local newvars `""`vname'", "`se'", "`se2'", "`wald'""'
		local newvars `"`newvars', "`pval'", "`cil'", "`ciu'""'
		local newvars `"`newvars', "`bv'", "`wv'", "`df'""'
		local newvars `"`newvars', "`rvi'","`fmi'","`re'""'
		local vlab "MI prediction"
		local vlabsep "Prediction"
		local vlabse "S.E. of the MI prediction: `vname'"
		local vlabsepse "S.E. of the prediction: `vname'"
		local vlabse2 "Var. of the MI prediction: `vname'"
		local vlabsepse2 "Var. of the prediction: `vname'"
		local vlabwald "MI Wald test statistic: `vname'"
		local vlabsepwald "Wald test statistic: `vname'"
		local vlabpval "MI level of significance: `vname'"
		local vlabseppval "Level of significance: `vname'"
		local vlabdf "MI degrees of freedom: `vname'"
		local vlabsepdf "Completed-data degrees of freedom"
		local vlabcil "MI `level'% lower bound: `vname'"
		local vlabciu "MI `level'% upper bound: `vname'"
		local vlabsepcil "`level'% lower bound: `vname'"
		local vlabsepciu "`level'% upper bound: `vname'"
		local vlabbv "Between-imputation variance: `vname'"
		local vlabwv "Within-imputation variance: `vname'"
		local vlabrvi "Relative variance increase: `vname'"
		local vlabfmi "Fraction missing information: `vname'"
		local vlabre "Relative efficiency: `vname'"
		if ("`storecompleted'"=="") {
			local vlabsep "`vlab'"
			local vlabsepse "`vlabse'"
			local vlabsepse2 "`vlabse2'"
			local vlabsepwald "`vlabwald'"
			local vlabseppval "`vlabpval'"
			local vlabsepdf "`vlabdf'"
			local vlabsepcil "`vlabcil'"
			local vlabsepciu "`vlabciu'"
		}
		else {
			local storespec `",`=`df_c'',`level', `census'"'
		}
		local vlabsepbv "`vlabbv'"
		local vlabsepwv "`vlabwv'"
		local vlabseprvi "`vlabrvi'"
		local vlabsepfmi "`vlabfmi'"
		local vlabsepre "`vlabre'"
	}
	foreach newvaropt in `newvaropts' {
		if ("``newvaropt''"!="") {
			qui gen `vtype' ``newvaropt'' = .
			qui label variable ``newvaropt'' "`vlab`newvaropt''"
		}
	}
	qui gen `vtype' `vname' = .
	qui label variable `vname' "`vlab'"

	// compute and store MI results in new variables
	mata: _mipred_compute(`mipred',`M'`compspec');	///
	      _mipred_store(`mipred', `newvars')
	if ("`storecompleted'"!="") {
		if ("`predcmd'"=="predictnl") {
			local newvars `""`vname'", "`se'", "`se2'""'
			local newvars `"`newvars', "`wald'", "`pval'""'
			local newvars `"`newvars', "`cil'", "`ciu'", "`df'""'
		}
		if ("`style'"=="flong") {
			mata: _mipred_store_flong(`mipred',`newvars'`storespec')
		}
	}
	if ("`style'"=="flongsep") {
		preserve
		local basename `_dta[_mi_name]'
		local i 1
		forvalues m=1/`_dta[_mi_M]' {
			qui use _`m'_`basename', clear
			qui gen `vtype' `vname' = .
			qui label variable `vname' "`vlabsep'"
			foreach newvaropt in `newvaropts' {
				if ("``newvaropt''"!="") {
					qui gen `vtype' ``newvaropt'' = .
					qui label variable ``newvaropt'' ///
							"`vlabsep`newvaropt''"
				}
			}
			if ("`storecompleted'"!="" & `: list m in m_mi') {
				mata: 	///
		       _mipred_store_flongsep(`mipred',`i',`newvars'`storespec')
				local ++i
			}
			qui save, replace
		}
		restore
	}

	if (`rc_mi') {
		if (`blank') di
		di as txt ///
			"`lnote'MI results are based on `M' imputations`rnote'"
		local blank 0
	}
} //cap noi block -- end
local rc = _rc

	// clean up
	cap mata: mata drop `mipred'
	nobreak {
		if `rc' { // drop variables on error
			cap drop `vname'
			foreach newvaropt in `newvaropts' {
				cap drop ``newvaropt''
			}
		}
		// u_mi_xeq_on_tmp_flongsep takes cares of the flongsep style
	}

	//note about missing values generated
	if (`rc'==0) {
		if ("`style'"=="flong" | "`style'"=="mlong") {
			local ifm0 & _mi_m==0
		}
		qui count if `vname'>=. `ifm0'
		if (r(N)>0) {
			if (`blank') di
			di as txt 	///
				"`lnote'`r(N)' missing values generated`rnote'"
		}
	}

	exit `rc'	
end

program _mi_predict_parse, sclass

	local synopts XB STDP NOOFFset EQuation(passthru)
	
	u_mi_estimate_get_commonopts "predict" "usingspec"
	local synopts `synopts' `s(common_opts)'

	// check options
	syntax [, XB STDP * ]
	opts_exclusive "`xb' `stdp'"

	// determine type of computation
	if ("`xb'`stdp'"=="" | "`xb'"!="") {
		local compute 0
	}
	else {
		local compute 1
	}

	sret clear
	sret local synopts "`synopts'"
	sret local compute "`compute'"
end

program _mi_predictnl_parse, sclass

	local synopts SE(string) VARiance(string) Wald(string) p(string)	
	local synopts `synopts' ci(string) ITERate(passthru) FORCE
	local synopts `synopts' BVARiance(string) WVARiance(string) DF(string)
	local synopts `synopts' RVI(string) FMI(string)	RE(string)
	
	u_mi_estimate_get_commonopts "predictnl" "usingspec"
	local synopts `synopts' `s(common_opts)'

	// check options
	syntax [,	SE(string)		///
			VARiance(string)	///
			Wald(string)		///
			p(string)		///
			ci(string)		///
			BVARiance(string)	///
			WVARiance(string)	///
			DF(string)		///
			RVI(string)		///
			FMI(string)		///
			RE(string)		///
			*			///
		]

	local newvaropts se variance wald p bvariance wvariance df rvi fmi re
	foreach newvaropt in `newvaropts' {
		if ("``newvaropt''"!="") {
			cap noi confirm new variable ``newvaropt''
			if _rc {
				di as err "in option {bf:`newvaropt'()}"
				exit _rc
			}
			if (`:word count ``newvaropt''' != 1) {
				di as err "{p}option {bf:`newvaropt'()} requires one"
				di as err "new variable name{p_end}"
				exit 102
			}
		}
	}
	if (`"`ci'"'!="") {
		if (`:word count `ci'' != 2) {
			di as err "{p}option {bf:ci()} requires two new variable " ///
				  "names to contain lower and upper "	 ///
				  "confidence bounds{p_end}"
			exit 102
		}
		tokenize `ci'
		local cil `1'
		local ciu `2'
		cap noi confirm new variable `cil'
		if _rc {
			di as err "in option {bf:ci()}"
			exit _rc
		}
		cap noi confirm new variable `ciu'
		if _rc {
			di as err "in option {bf:ci()}"
			exit _rc
		}
	}

	// determine type of computation
	local mistats = ("`p'`ci'`df'`rvi'`fmi'`re'"!="")
	if (`mistats' | "`se'`variance'`wald'`bvariance'`wvariance'"!="") {
		local stdp stdp
	}
	if (`mistats') {
		local compute 2
	}
	else if ("`stdp'"!="") {
		local compute 1
	}
	else {
		local compute 0
	}

	sret clear
	sret local synopts "`synopts'"
	sret local compute "`compute'"
end

