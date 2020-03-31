*! version 1.4.3  13feb2015 
program _xtme_display

	version 10
	syntax [, mi *]

	if ("`e(cmd)'"=="mi estimate" | "`mi'"!="") {
		local sfx _mi
	}
	local is_xtme = inlist("`e(cmd`sfx')'","xtmelogit","xtmepoisson")
	local is_meqr = inlist("`e(cmd`sfx')'","meqrlogit","meqrpoisson")
	if ((!`is_xtme' & !`is_meqr') |"`e(b`sfx')'"==""|"`e(V`sfx')'"=="") {
		error 301
	}

	local 0 , `options'
	syntax [, Level(cilevel) VARiance STDDEViations noLRtest ///
		  noGRoup noHEADer noFETable noRETable ESTMetric grouponly ///
		  IRr or grouptable *]

	if "`variance'"!="" & "`stddeviations'"!="" {
	    di as err "variance and stddeviations may not be specified together"
	    exit 198
	}
	local var_opt `variance' `stddeviations'	
	if "`var_opt'"=="" {
		if `is_meqr' local variance variance
		else local variance
	}
	local stddeviations

	_get_diopts diopts, `options'
	ParseForCformat `"`diopts'"'
	opts_exclusive "`grouponly' `grouptable'"
	local k = ("`fetable'"!="") + ("`retable'"!="") + ("`var_opt'"!="")
	if `k' {
		local badopt `fetable' `retable' `var_opt'
		if "`estmetric'" != "" {
di in smcl "{err}option {bf}estmetric {sf}not allowed with {bf}`badopt'{sf}"
exit 198
		}
	}
	if "`or'" != "" & "`irr'" != "" {
		di as err "only one of or or irr are allowed"
		exit 198
	}

	if "`or'" != "" {
		if "`e(model)'" != "logistic" {
			di as err "or not allowed"
			exit 198
		}
	}

	if "`irr'" != "" {
		if "`e(model)'" != "Poisson" {
			di as err "irr not allowed"
			exit 198
		}
	}
	if "`header'" == "" {
		DiHeader, `group' `grouponly' `grouptable' `mi'
		if "`grouponly'`grouptable'" != "" {
			CheckErc
			exit
		}
	}
	if "`estmetric'" != "" {
		di
		*_coef_table, level(`level')
		_coef_table, level(`level') offsetonly1 `diopts'
		CheckErc
		exit
	}
	if "`fetable'" == "" & e(k_f) > 0 {
		DiEstTable, level(`level') `or' `irr' `diopts'
		tempname rhold
		_return hold `rhold'
	}
	if "`retable'" == "" {
		DiVarComp, `mi' level(`level') `variance' `lrtest' cformat(`cf')
		local note `r(note)'
	}
	if "`e(laplace)'" != "" {
		if "`note'" == "" {
			di
		}
		di as txt "{p 0 6 4}Note: Log-likelihood calculations are "
		di as txt "based on the "
		di as txt "{help j_melaplace##|_new:Laplacian approximation}."
		di as txt "{p_end}"
		local note note
	}
	if "`e(mi)'"!="" {
		if `e(reparm_rc_mi)' {
			if "`note'" == "" {
				di
			}
di as txt "{p 0 6 4 78}Note: Standard errors are missing because "
di as txt "of estimated variance components too close to "
di as txt "the boundary of the parameter space in "
di as txt "some imputations.{p_end}"
		}
	}
	else if `e(reparm_rc)' {
		if "`note'" == "" {
			di
		}
di as txt "{p 0 6 4 78}Note: Standard errors are missing because "
di as txt "of estimated variance components too close to "
di as txt "the boundary of the parameter space.{p_end}"
	}
	if "`rhold'" != "" {
		_return restore `rhold'
	}
	CheckErc
end	

program CheckErc
	if !inlist("`e(rc)'","","0") {
		error e(rc)
	}
end

program DiHeader
	syntax [, noGRoup grouponly grouptable mi ]
	if "`grouponly'" != "" {
		if "`e(ivars)'" == "" {
			di as err "{p 0 4 2}model is `e(model)' regression; "
			di as err "no group information available{p_end}"
			exit 459
		}
		DiGroupTable, table estat `mi'
		exit
	}	
	if "`grouptable'" != "" {
		if "`e(ivars)'" == "" {
			di as err "{p 0 4 2}model is `e(model)' regression; "
			di as err "no group information available{p_end}"
			exit 459
		}
		DiGroupTable, table `mi'
		exit
	}
	di
	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
                */ bsubstr(`"`e(crittype)'"',2,.)
	
	di as txt "`e(title)'" _c
	di _col(49) as txt "Number of obs" _col(67) "=" _col(69) as res ///
		%10.0fc e(N)

	if "`e(binomial)'" != "" {
		cap confirm number `e(binomial)'
		if _rc {
			di as txt "Binomial variable: " as res "`e(binomial)'"
		}
		else {
			di as txt "Binomial trials = " ///
					as res %3.0f `e(binomial)'
		}
	}

	if "`group'" == "" {
 		DiGroupTable, `mi'
		*di
	}
	local w : word count `e(n_quad)'
	if `w' == 1 {
		di as txt "Integration points = " as res %3.0f `e(n_quad)' _c
	}
        di _col(49) as txt "`e(chi2type)' chi2(" as res e(df_m) as txt ")" ///
                _col(67) "=" _col(70) as res %9.2f e(chi2)
	di as txt "`crtype'" " = " as res %10.0g e(ll) /*
                */ _col(49) as txt "Prob > chi2" _col(67) "=" _col(73) /*
                */ as res %6.4f chiprob(e(df_m), e(chi2))
end

program DiGroupTable
	syntax [, table estat mi]
	local ivars `e(ivars)'
	local levels : list uniq ivars
	tempname Ng min avg max
	if ("`e(cmd)'"=="mi estimate" | "`mi'"!="") {
		local sfx _mi
	}
	mat `Ng' = e(N_g`sfx')
	mat `min' = e(g_min`sfx')
	mat `avg' = e(g_avg`sfx')
	mat `max' = e(g_max`sfx')
	local w : word count `levels'
	if `w' == 0 {
		exit
	}
	if `w' == 1 & "`table'" == "" {
		di as txt "Group variable: " as res abbrev("`levels'",14) ///
		     _col(49) as txt "Number of groups" _col(67) "=" ///
		     _col(70) as res %9.0g `Ng'[1,1] _n
		di as txt _col(49) "Obs per group:"
		di as txt _col(63) "min" _col(67) "=" ///
		     _col(69) as res %10.0fc `min'[1,1]
		di as txt _col(63) "avg" _col(67) "=" ///
		     _col(69) as res %10.1fc `avg'[1,1]
		di as txt _col(63) "max" _col(67) "=" ///
		     _col(69) as res %10.0fc `max'[1,1] _n
	}
	//         1         2         3         4         5         6
	//123456789012345678901234567890123456789012345678901234567890
	//                    No. of       Observations per Group
	// Group Variable |   Groups    Minimum    Average    Maximum
	//        level1  | ########  #########  #########  #########
	else {
		if "`estat'" == "" {
			local eline 59 
		}
		else {
			local eline 44
		}
		di
		di as txt "{hline 16}{c TT}{hline `eline'}
		di as txt _col(17) "{c |}" _col(23) "No. of" ///
	          _col(36) "Observations per Group" _c
		if "`estat'" == "" {
			di as txt _col(65) "Integration"
		}
		else {
			di
		}
		di as txt _col(2) "Group Variable" _col(17) "{c |}" ///
		  _col(23) "Groups" _col(33) "Minimum" ///
		  _col(44) "Average" _col(55) "Maximum" _c
		if "`estat'" == "" {
			di as txt _col(68) "Points"
		}
		else {
			di
		}
		di as txt "{hline 16}{c +}{hline `eline'}"
		local i 1
		foreach k of local levels {
			local lev = abbrev("`k'",12)
			local p = 16 - length("`lev'")
			di as res _col(`p') "`lev'" /// 
			  as txt _col(17) "{c |}" ///
			  as res _col(21) %8.0fc `Ng'[1,`i'] ///
                          _col(31) %9.0fc `min'[1,`i'] ///
                          _col(42) %9.1fc `avg'[1,`i'] ///
                          _col(53) %9.0fc `max'[1,`i'] _c
			if "`estat'" == "" {
				local intp : word `i' of `e(n_quad)'
			  	di as res _col(71) %3.0f `intp'
			}
			else {
				di
			}
			local ++i	
		}
		di as txt "{hline 16}{c BT}{hline `eline'}" 
		if "`estat'" == "" {
			di
		}
	}
end

program DiEstTable
	syntax [, level(cilevel) or irr *]

	di
	_coef_table, first level(`level') `or' `irr' `options'
end

program DiLRTest, rclass

	// We have already established that e(chi2_c) exists
	if ((e(chi2_c) > 0.005) & (e(chi2_c)<1e5)) | (e(chi2_c)==0) {
  		local fmt "%8.2f"
        }
        else    local fmt "%8.2e"

	local msg "LR test vs. `e(model)' model:"

	local k1 = strlen("`msg'") + 2
	local chi : di `fmt' e(chi2_c)
	local chi = trim("`chi'")
	local sub = strlen("`chi'")

	di as txt "`msg'" _c
	if `e(df_c)' == 1 {    		// chibar2(01)
		di as txt _col(`k1') "{help j_chibar##|_new:chibar2(01) =} " ///
                   as res "`chi'" ///
		   _col(55) as txt "Prob >= chibar2 = " ///
		   _col(73) as res %6.4f e(p_c)
	}		
	else {
		di as txt _col(`k1') "chi2(" as res e(df_c) ///
		   as txt ") = " as res "`chi'" ///
		   _col(59) as txt "Prob > chi2 =" ///
		   _col(73) as res %6.4f e(p_c)
		return local conserve conserve
	}
end

program DiVarComp, rclass
	syntax [, level(cilevel) VARiance noLRtest cformat(string) mi * ]

	if ("`e(cmd)'"=="mi estimate" | "`mi'"!="") {
		local bmatrix e(b_mi)
	}
	else {
		local bmatrix e(b)
	}
	local depvar `e(depvar)'
	if strpos("`depvar'",".") {
		gettoken ts rest : depvar, parse(".")
		gettoken dot depvar : rest, parse(".")
	}
	
	local dimx `e(k_f)'

	// display header 

	di
	di as txt "{hline 29}{c TT}{hline 48}
	if "`e(vcetype)'" == "Bootstrap" || ///
	   "`e(vcetype)'" == "Bstrap *" {
		local obs "Observed"
		local citype "Normal-based"
	}
	if `"`e(vcetype)'"' == "Bootstrap" || ///
	   `"`e(vcetype)'"' == "Bstrap *"  || ///
	   `"`e(vcetype)'"' == "Jackknife" || ///
	   `"`e(vcetype)'"' == "Jknife *" {
		local vcetype `e(vcetype)'
		if `"`e(mse)'"' != "" {
			capture which `e(vce)'_`e(mse)'.sthlp
			local mycrc = c(rc)
			if `mycrc' {
				capture which `e(vce)'_`e(mse)'.hlp
				local mycrc = c(rc)
			}
			if !`mycrc' {
				local vcetype ///
				"{help `e(vce)'_`e(mse)'##|_new:`vcetype'}"
                        }
		}
		di as txt _col(30) "{c |}" _col(34) `"`obs'"' ///
			  _col(45) `"`vcetype'"' ///
			  _col(63) `"`citype'"'
	}
	local k = length("`level'")
	di as txt _col(3) "Random-effects Parameters" _col(30) "{c |}" ///
		_col(34) "Estimate" _col(45) "Std. Err." _col(`=61-`k'') ///
		`"[`=strsubdp("`level'")'% Conf. Interval]"'
	di as txt "{hline 29}{c +}{hline 48}

	local zvars `e(revars)'
	local dimz `e(redim)'

	// loop over levels

	local foot = 1
	local pos `dimx'
	local levs : word count `e(ivars)'
	forvalues k = 1/`levs' {
		local lev : word `k' of `e(ivars)'
		local vartype : word `k' of `e(vartypes)'
		di as res abbrev("`lev'",12) as txt ": `vartype'" ///
			_col(30) "{c |}"

		GetNames "`vartype'" "`zvars'" "`dimz'" `foot'
		local zvars `s(zvars)'     // collapsed lists
		local dimz `s(dimz)'
		local names `"`s(names)'"'
		if `"`s(footnote)'"' != "" {
			local footnotes `"`footnotes' `s(footnote)'"'
			local ++foot
		}

		local nbeta : word count `names'
	
		DiParms `pos' `nbeta' `"`names'"' "`level'" "`variance'" ///
			"`bmatrix'" "`cformat'"

		local pos = `pos' + `nbeta'
		if `k'==`levs' {
			di as txt "{hline 29}{c BT}{hline 48}
		}
		else {
			di as txt "{hline 29}{c +}{hline 48}
		}
	}
	
	// Footnotes
	if "`e(chi2_c)'" != "" & "`lrtest'" == "" {
		DiLRTest
		local conserve `r(conserve)'
	}
	
	forvalues k = 1/`=`foot'-1' {
		local note: word `k' of `footnotes'
		local indent = 3 + length("`k'")
		di as txt `"{p 0 `indent' 4} `note'{p_end}"'
	}
	if "`conserve'" != "" {
		di as txt _n "{p 0 6 4}Note: {help j_mixedlr##|_new:LR test is conservative} and provided only for reference.{p_end}"
		return local note note
	}
end

program DiParms
	args pos nb names cilev var bmatrix cf

	local stripes : coleq `bmatrix', quoted
	forvalues k = 1/`nb' {
		local label : word `k' of `names'	
		local eq : word `=`pos'+`k'' of `stripes'
		GetParmEqType `eq' `var'
		local parm `s(parm)'
		local label `"`s(type)'`label'"'	
		local diparmeq `"`s(diparmeq)'"'

		local p = 29 - length("`label'")
		qui _diparm `diparmeq', `parm' level(`cilev') notab
		local rest : display `cf' r(est)
	        local rse  : display `cf' r(se)
	        local lrest = length("`rest'")
	        local lrse  = length("`rse'")
		if ("`r(lb)'"==".b" | "`r(ub)'"==".b") {
			di as txt _col(`p') "`label'" _col(30) "{c |}" ///
   				as res _col(`=33+9-`lrest'') `cf' r(est) ///
	   			as res _col(`=44+9-`lrse'')  `cf' r(se)
		}
		else {
			local rcil : display `cf' cond(missing(r(se)),.,r(lb))
		        local rciu : display `cf' cond(missing(r(se)),.,r(ub))
	   		local lrcil = length("`rcil'")
		        local lrciu = length("`rciu'")
			di as txt _col(`p') "`label'" _col(30) "{c |}" ///
			   as res _col(`=33+9-`lrest'') `cf' r(est) ///
			   as res _col(`=44+9-`lrse'') `cf' r(se)  ///
			   as res _col(`=58+9-`lrcil'') /// 
			   `cf' cond(missing(r(se)),.,r(lb))  ///
		   	   as res _col(`=70+9-`lrciu'') ///
			   `cf' cond(missing(r(se)),.,r(ub))
		}
	}
end

program GetNames, sclass
	args type zvars dimz foot

	gettoken dim dimz : dimz
	forvalues k = 1/`dim' {
		gettoken tok1 zvars : zvars
		local fullvarnames `fullvarnames' `tok1'
		local len = length("`tok1'")
		if bsubstr("`tok1'",1,2) == "R." {
			local w = bsubstr("`tok1'",3,`len') 
			local tok1 = "R." + abbrev("`w'",8)
		}
		else {
			local tok1 = abbrev("`tok1'",8)
		}
		local varnames `varnames' `tok1'
	}
	if ("`type'" == "Unstructured") {
		forvalues j = 1/`dim' {
			local w : word `j' of `varnames'
			local names `"`names' "(`w')""'
		}
		forvalues j = 1/`dim' {
			forvalues k = `=`j'+1'/`dim' {
				local w1 : word `j' of `varnames'
				local w2 : word `k' of `varnames'
				local names `"`names' "(`w1',`w2')""'	
			}
		}
	}
	else if ("`type'" == "Independent") {    
		forvalues j = 1/`dim' {
			local w : word `j' of `varnames'
			local names `"`names' "(`w')""'
		}
	}
	else {    // Identity or Exchangeable
		local ex = ("`type'" == "Exchangeable")
		if (`dim' == 1) {		// check for factor variable
			local w `varnames'
			local names `""(`w')""'
			if `ex' {
				local names `"`names' "(`w')""'
			}
		}
		else if (`dim' == 2) {
			local w1 : word 1 of `varnames'
			local w2 : word 2 of `varnames'
			local names `""(`w1' `w2')""'
			if `ex' {
local names `"`names' "(`w1',`w2')""'
			}
		}
		else {
			local k : length local varnames
			if `k' > 20 {		// too long
				local w1 : word 1 of `varnames'	
				local w2 : word `dim' of `varnames'
				local names `""(`w1'..`w2')(`foot')""'
				if `ex' {
local names `"`names' "(`w1'..`w2')(`foot')""'
				}
				local footnote `""(`foot') `fullvarnames'""'
			}
			else {
				local names `""(`varnames')""'
				if `ex' {
local names `"`names' "(`varnames')""'
				}
			}
		}
	}

	sreturn local zvars "`zvars'"
	sreturn local dimz "`dimz'"
	sreturn local names `"`names'"'
	sreturn local footnote `"`footnote'"'
end

program GetParmEqType, sclass
	args eq var
	
	if bsubstr("`eq'",1,1) == "l" {	  // log standard deviation
		if "`var'" == "" {	  // se/corr metric
			local parm exp
			local type sd
		}			
		else {			  // var/cov metric
			local parm f(exp(2*@)) d(2*exp(2*@))
			local type var
		}
		local deq `eq'
	}
	else { // bsubstr("`eq'",1,1) == "a"  atanh correlation
		if "`var'" == "" {        // se/corr metric
			local parm tanh
			local type corr
			local deq `eq'
		}
		else {			  // var/cov metric
			ParseEq `eq'
			local eq2 lns`r(n1)'_`r(n2)'_`r(n3)'
			local eq3 lns`r(n1)'_`r(n2)'_`r(n4)'
			local deq `eq' `eq2' `eq3'	
			local parm f(tanh(@1)*exp(@2+@3))
			local parm `parm' d((1-(tanh(@1)^2))*exp(@2+@3)
			local parm `parm' tanh(@1)*exp(@2+@3)
			local parm `parm' tanh(@1)*exp(@2+@3)) 
			local type cov
		}
	}

	sreturn local parm `"`parm'"'
	sreturn local type `"`type'"'
	sreturn local diparmeq `"`deq'"'
end

program ParseEq, rclass
	args eq

	// I've got "eq" == "atr#_#_#_#", and I need the four #'s
	// returned as r(n1), r(n2), r(n3), and r(n4)

	local len = length("`eq'")
	local eq = bsubstr("`eq'",4,`len')
	forvalues k = 1/4 {
		gettoken n`k' eq : eq, parse(" _")
		return local n`k' `n`k''
		gettoken unscore eq : eq, parse(" _")
	}
end

program ParseForCformat
	args diopts
	local 0 , `diopts'
	syntax [, cformat(string) *]

	if `"`cformat'"' == "" {
                local cformat `c(cformat)'
        }
        if `"`cformat'"' == "" {
                local cformat %9.0g
        }
        c_local cf `cformat'
end

exit
