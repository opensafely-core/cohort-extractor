*! version 1.0.7  30nov2018
program _mswitch_p, rclass 
	version 14.0
	syntax anything(name=vlist id="varlist") [if] [in] [, yhat xb pr    ///
			Residuals RSTAndard SMETHod(string) 		    ///
			EQuation(string) 				    ///
			state(numlist int min=0 max=1 >0 <=20) 	    	    ///
			DYNamic(passthru) rmse(string) ]


/**Check errors**/
	local whichopts `yhat' `xb' `pr' `residuals' `rstandard'
	if ("`whichopts'"==""|"`whichopts'"=="yhat") {
		if ("`whichopts'"=="") {
			di in gr "(option {bf:yhat} assumed; predicted values)"
			local yhat yhat
			local whichopts `whichopts' `yhat'
		}
	}
	if (wordcount("`whichopts'") != 1) {
		di as err "{p 0 8 2}only one of {bf:yhat}, {bf:xb}, "
		di as err "{bf:pr}, {bf:residuals} or {bf:rstandard} "
		di as err "allowed{p_end}"
		exit 184
	}

	if ("`dynamic'"!="" & "`whichopts'"!="yhat") {
		di as err "{p 0 8 2} option {bf:`whichopts'} and {bf:dynamic()}"
		di as err "may not be combined{p_end}"
		exit 184
	}

	if ("`whichopts'"=="rstandard" & "`rmse'"!="") {
		di as err "{p 0 8 2} options {bf:rmse()} and {bf:`whichopts'}"
		di as err "may not be combined{p_end}"
		exit 184
	}


	if ("`smethod'"!="" & "`whichopts'"=="xb") {
		di as err "{p 0 8 2} options {bf:smethod()} and {bf:xb} may not"
		di as err "be combined{p_end}"
		exit 184
	}

/**Set -smethod()-**/
	if ("`smethod'"=="")	local smethod onestep
	else {
		local len = strlen(`"`smethod'"')
		if (`"`smethod'"'==bsubstr("filter",1,max(2,`len'))) {
			local smethod filter
		}
		else if (`"`smethod'"'==bsubstr("smooth",1,max(2,`len'))) {
			local smethod smooth
		}
		else if (`"`smethod'"'==bsubstr("onestep",1,max(3,`len'))) {
			local smethod onestep
		}
		else {
			di as err "{p 0 8 2} unknown method `smethod'{p_end}"
			exit 198
		}
	}

	local depvar `e(depvar)'
	local nstates = e(states)
	if ("`state'"=="")	local state 1
	if (`state'>`nstates') {
		di as err "{p 0 8 2}invalid number of states in option "
		di as err "{bf:state(`state')}{p_end}"
		exit 198
	}


/**Check variable labels**/
	local eqlist `e(eqnames)'
	if ("`xb'"!="" & "`equation'"=="") local equation: word 1 of `eqlist'
	if ("`xb'"!="" & "`equation'"!="") {
		CheckEQ `equation', eq(`eqlist')
		local whreg
		foreach eq of local equation {
			if ("`eq'"!="`depvar'") {
				local wh = usubstr("`eq'",7,1)
				local whreg `whreg' `wh'
			}
		}
		local neq = wordcount("`equation'")
		_stubstar2names `vlist', nvars(`neq')
	}
	else if ("`xb'"=="" & "`equation'"!="") {
		di as err "{p 0 8 2}{bf:equation()} may only be specified with"
		di as err "option {bf:xb}{p_end}"
		exit 198
	}
	else {
		cap _stubstar2names `vlist', nvars(`nstates')
		if c(rc) {
			_stubstar2names `vlist', nvars(1)
		}
	}
	local varnem `s(varlist)'
	local numvars = wordcount("`varnem'")
	local typ `s(typlist)'


/**Set labels**/
	local nreg 1
	if ("`smethod'"=="onestep") local dispmethod one-step
	else local dispmethod `smethod'
	foreach var of local varnem {
		qui gen `typ' `var' = .
		if ("`whichopts'"=="yhat" & "`dynamic'"=="") {
label var `var' `"`whichopts' prediction, `dispmethod'"'
			if (`numvars'>1) {
label var `var' `"`whichopts' prediction, State`nreg',`dispmethod'"'
			}
		}	
		else if ("`whichopts'"=="yhat" & "`dynamic'"!="") {
label var `var' `"`whichopts' prediction, `dynamic'"'
			if (`numvars'>1) {
label var `var' `"`whichopts' prediction, State`nreg', `dynamic'"'
			}
		}
		else if ("`whichopts'"=="xb") {
//local xblab: word `nreg' of `equation'
label var `var' `"`whichopts' prediction, `dispmethod'"'
			if (`numvars'>1) {
label var `var' `"`whichopts' prediction, `dispmethod'"'
			}
		}
		else if ("`whichopts'"=="residuals") {
			label var `var' `"`whichopts', `dispmethod'"'
			if (`numvars'>1) {
label var `var' `"`whichopts', State`nreg', `dispmethod'"'
			}
		}
		else if ("`whichopts'"=="rstandard") {
			label var `var' `"`whichopts', `dispmethod'"'
			if (`numvars'>1) {
label var `var' `"`whichopts', State`nreg', `dispmethod'"'
			}
		}
		else if ("`whichopts'"=="pr") {
label var `var' `"State`nreg', `dispmethod' probabilities"'
		}
		local nreg = `nreg'+1
	}


/**RMSE option related**/
	if ("`rmse'"!="") {
		cap noi _stubstar2names `rmse', nvars(`numvars')
		local rc = _rc
		if (`rc'==102 | `rc'==103) {
			local nr : word count `rmse'
			di as err "{p 0 8 2}specification {bf:rmse(`rmse')}" ///
				" requires `numvars' "			     ///
				`"`= plural(`numvars',"name","names")', "'   ///
				"or use the {bf:{it:stub*}} notation{p_end}"
			exit `rc'
		}
		else if (`rc') exit `rc'

		local rmselist 	`"`s(varlist)'"'
		local rtyplist	`"`s(typlist)'"'
		local alllist `"`varnem' `rmselist'"'
		local kall: word count `alllist'
		local alllist : list uniq alllist
		if (`:word count `alllist'' != `kall') {
			di as err "{p}duplicate names exist in the "	     ///
				"{bf:varlist} and the {bf:rmse()} option{p_end}"
			exit 189
		}
		foreach var of local rmselist {
			local nreg 1
			qui gen `rtyplist' `var' = .
			if ("`whichopts'"=="yhat" | "`whichopts'"=="xb") {
				label var `var' `"`whichopts' RMSE, `smethod'"'
				if (`numvars'>1) {
label var `var' `"`whichopts' RMSE, State`nreg', `smethod'"'
				}
			}	
			else if ("`whichopts'"=="residuals") {
				label var `var' `"`whichopts', `smethod'"'
				if (`numvars'>1) {
label var `var' `"`whichopts', State`nreg', `smethod'"'
				}
			}
			local nreg = `nreg'+1
		}
	}


	marksample touse
	_ts tvar panvar if `touse', sort onepanel
	local tsdeps = 0
	local nsindeps `e(nonswitchvars)'
	local swindeps `e(switchvars)'

	if ("`dynamic'"!="" & "`e(model)'"=="dr" | "`dynamic'"!="" & 	     ///
							"`e(ar)'"=="0") {
		local touse_nsindeps
		local touse_swindeps
		foreach varn of local varnem {
			foreach var of local nsindeps {
				_ms_parse_parts `var'
				if "`r(type)'" == "variable" {
					local iy : list posof "`r(name)'" in ///
									depvar
					if `iy' & "`r(ts_op)'"!="" {
local marktsvar `marktsvar' `var'
local predvar `r(ts_op)'.`varn'
local touse_nsindeps `touse_nsindeps' `predvar'
					}
					else local touse_nsindeps 	     ///
							`touse_nsindeps' `var'
				}
				local markindvars `markindvars' `var'
			}
			foreach var of local swindeps {
				_ms_parse_parts `var'
				if "`r(type)'" == "variable" {
					local iy : list posof "`r(name)'" in ///
									depvar
					if `iy' & "`r(ts_op)'"!="" {
local marktsvar `marktsvar' `var'
local predvar `r(ts_op)'.`varn'
local touse_swindeps `touse_swindeps' `predvar'
					}
					else local touse_swindeps 	     ///
							`touse_swindeps' `var'
				}
				local markindvars `markindvars' `var'
			}
		}
		if ("`markindvars'"!="") markout `touse' `markindvars'
	}
	else if ("`dynamic'"!="" & "`e(model)'"=="ar" & "`e(ar)'"!="0") {
		foreach varn of local varnem {
			foreach var of local nsindeps {
				_ms_parse_parts `var'
				if ("`r(type)'" == "variable") {
					if ("`r(ts_op)'"!="" & "`r(name)'"== ///
									"ar") {
local var `r(ts_op)'.`e(depvar)'
local marktsvar `marktsvar' `var'
local predvar `r(ts_op)'.`varn'
local touse_nsindeps `touse_nsindeps' `predvar'
					}
				//	else local touse_nsindeps	     ///
				//		`touse_nsindeps' `var'
				}
				local markindvars `markindvars' `var'
			}
			foreach var of local swindeps {
				_ms_parse_parts `var'
				if ("`r(type)'" == "variable") {
					if ("`r(ts_op)'"!="" & "`r(name)'"== ///
									"ar") {
local var `r(ts_op)'.`e(depvar)'
local marktsvar `marktsvar' `var'
local predvar `r(ts_op)'.`varn'
local touse_swindeps `touse_swindeps' `predvar'
					}
					else local marktsvar `marktsvar' `var'
				}
				local markindvars `markindvars' `var'
			}
		}
		if ("`markindvars'"!="") markout `touse' `markindvars'
	}

	qui count if `touse'
	if (r(N)==0) error 2000
	

	
	local depvar	`e(depvar)'
	local nsvars	`e(nonswitchvars)'	
	local swvars	`e(switchvars)'
	local usevars	.
	local tousevars	.
	if ("`e(model)'"=="dr") {
		local model msdr
		markout `touse' `depvar' `nsvars' `swvars'
	}
	else if ("`e(model)'"=="ar") 	local model msar

	local varswitch `e(varswitch)'
	if ("`e(arswitch)'"=="")		local ar_sw 0 
	else if ("`e(arswitch)'"=="arswitch")	local ar_sw 1

	if ("`model'"=="msar") {
		local nsvars `e(ar_nsvars)'
		local swvars `e(ar_swvars)'
		local arterms `e(arterms)'
		local usevars `depvar' `nsvars' `swvars'
		marksample tousevars
		if (`"`if'`in'"'=="") {
			local arlag = `e(mlag)'
			local 0 `depvar' L`arlag'.`depvar' `nsvars' `swvars'
			syntax varlist(ts)
			marksample touse
		}
		if ("`arterms'"!="0") {
			foreach num of numlist `arterms' {
				local vars_ns
				local vars_sw
				foreach var of varlist `usevars' {
					local vars_ns `vars_ns' L`num'.`var'
				}
				if ("`nsvars'"=="") {
					tempvar __nswvars`num'__
					cap qui gen `__nswvars`num'__' = 0
					local vars_ns `vars_ns' 	     ///
							`__nswvars`num'__'
				}
				if ("`swvars'"=="") {
					tempvar __swvars`num'__
					cap qui gen `__swvars`num'__' = 0
					local vars_sw `vars_sw' 	     ///
							`__swvars`num'__'
				}
				local allvars `allvars' `vars_ns' `vars_sw'
			}
		}
		else	local allvars `e(allvars)'
		markout `touse' `allvars'
	}	
	if "`dynamic'" != "" {
		Check_dynamic `tvar', touse(`touse') `dynamic' ///
				markindvars(`markindvars') myvars(`varnem')
		local tdynamic = r(value)
		local idynamic = r(index)
	}
        else {
		markout `touse' `e(depvar)'
		local tdynamic = .
		local idynamic = .
	}
        _check_ts_gaps `tvar', touse(`touse')

	if ("`in'"!="") {
		local touse_in `touse'
		local tsin `in'
		local 0 `depvar' `nsvars' `swvars' `allvars'
		syntax varlist(ts)
		marksample touse
	}

	mata: mswitch_predict("`depvar'", "`nsvars'", "`swvars'", 	    ///
		"`touse'", "`model'", st_global("e(p0)"), "`varswitch'", ., ///
		"`allvars'", `nstates', st_numscalar("e(cons)"), 	    ///
		st_numscalar("e(nocons)"), `ar_sw', st_matrix("e(armat)"),  ///
		st_matrix("e(svecnsw)"), st_matrix("e(svecsw)"), 	    ///
		st_matrix("e(svecmsar)"), ., ., "`whichopts'", "`usevars'", ///
		"`tousevars'", "`varnem'", "`smethod'", "`equation'", 	    ///
		"`touse_nsindeps'", "`touse_swindeps'", "`rmselist'", 	    ///
		`numvars', `state', `tdynamic', `idynamic')


	if ("`tsin'"!="") {
		replace `varnem' = . if (`touse_in'==0)
	}
	tempname mval obs
	qui des
	scalar `obs' = r(N)
	qui count if `touse'
	scalar `mval' = r(N)
/*
	if (`obs'-`mval'==1) {
		di as txt "(" `obs'-`mval' " missing value generated)"
	}
	else di as txt "(" `obs'-`mval' " missing values generated)"
*/
end


program CheckEQ
	syntax anything(name=elist id="equation"), eq(string)
	       
	local neq = wordcount("`eq'")
	foreach ei of local elist {
		local i : list posof "`ei'" in eq
		if `i' == 0 {
			di as err "{p}equation {bf:`ei'} is not in the model; "
			if `:word count `eq'' == 1 {
				di as err "only available equation name "  ///
					 "is {bf:`eq'}{p_end}"
			 }
			else {
				di as err "available equation names are "  ///
					 "{bf:`eq'}{p_end}"
			 }
			exit 322
		}
		local ind `ind' `i'
	}

end


program Check_dynamic, rclass
	syntax varname, touse(varname) dynamic(string) [ markindvars(string) ///
							myvars(string) ]

	local tvar `varlist'
	/* depvars with TS operators                                    */
	local depvar `e(depvar)'

	summarize `tvar' if `touse', meanonly
	if `dynamic'<r(min) | `dynamic'>r(max)+1 {
		local fmt : format `tvar'
		di as err "{p}{bf:dynamic(`dynamic')} is invalid; " ///
			 "dynamic() must be in [" `fmt' r(min) ", " `fmt'   ///
			  r(max)+1 "]{p_end}"
		drop `myvars'
		exit 459
	}

        tempvar dy
	/* with delta > 1 dynamic may not be equal to any of the        */
	/*  elements in tvar                                            */
	cap gen byte `dy' = (`tvar'<`dynamic')

	if _rc {
		di as err "{bf:dynamic(`dynamic')} is invalid"
		exit 198
	}
        qui count if `dy'
	local index = r(N) + 1	
	//Indexing the beginning of dynamic predictions in the sample
	local value = `index'

	qui replace `touse' = (`touse'&(`depvar'<.)) if `dy'

	/**Do not allow out-of-sample dynamic predictions if there are
	   exogenous variables**/
        if "`markindvars'" != "" {
		foreach var of local markindvars {
			_ms_parse_parts `var'
			if ("`r(name)'"!="`depvar'") {
				qui count if `touse' & `tvar'>=`dynamic'
				if r(N) == 0 {
di as err "{p}there are no valid observations beyond "  ///
`"{bf:dynamic(`dynamic')}; check for missing values in your variables{p_end}"' 
drop `myvars'
exit 459
				}
			}
		}
	}

        /* index of dynamic after dropping all missings */
        qui count if `touse' & `dy'
	//Indexing the beginning of dynamic predictions in the touse sample
	local index = r(N)+1			
	if (`index'<=0) local index = 1
	return local index = `index'
	return local value = `value'
end


local SS	string scalar
local RS	real scalar
local RMAT	real matrix
local CL	class _mswitch_p scalar

mata:

void mswitch_predict(`SS' depvar, nsvars, swvars, touse, model, p0, varswitch,
				rstart, allvars,
			`RS' nstates, constant, nscons, ar_sw, 
			`RMAT' ar_mat, svecnsw, svecsw, svecmsar, from, 
				p0usrinit,
			`SS' whichopts, usevars, tousevars, varnem, 
				smethod, equation, touse_ns, touse_sw, rmselist,
			`RS' numvars, state, tdynamic, idynamic)
{

	`CL' MSPredobj

	MSPredobj.model_init(depvar, touse, model, p0, rstart, ar_sw, from, 
			p0usrinit)
	MSPredobj.model_setup(nsvars, swvars, varswitch, allvars, nstates, 
			constant, nscons, ar_mat, svecnsw, svecsw, svecmsar)
	MSPredobj.predict_setup(whichopts, model, usevars, tousevars, varnem,
			smethod, equation, touse_ns, touse_sw, rmselist, 
			numvars, state, tdynamic, idynamic)

}

end
