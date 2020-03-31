*! version 1.0.1  12sep2017
program _xtme_estatsd, eclass
	version 15

	tempname b_sd V_sd se_sd pclass
	mat `b_sd' = e(b)
	mat `V_sd' = e(V)
	local n = colsof(`b_sd')
	mat `pclass' = J(1,`n',1)
	mat `se_sd' = vecdiag(`V_sd')
	local stripe : colfullnames `b_sd'

	// stripe for the fixed-effects equation
	forvalues i=1/`e(k_f)' {
		local name : word `i' of `stripe'
		local newstripe `newstripe' `name'
	}
	
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
	
	local zvars `e(revars)'
	local dimz `e(redim)'

	// loop over levels

	local ix `e(k_f)'
	local levs : word count `e(ivars)'
	forvalues k = 1/`levs' {
		local lev : word `k' of `e(ivars)'
		local vartype : word `k' of `e(vartypes)'
		GetNames "`vartype'" "`zvars'" "`dimz'"
		local zvars `s(zvars)'     // collapsed lists
		local dimz `s(dimz)'
		local names `"`s(names)'"'
		if `"`names'"' != `""()""' {
			local nbeta : word count `names'
			DiParms, pos(`ix') nb(`nbeta') names(`names') 	///
				bmatrix(`bmatrix') relevel(`lev') 	///
				b_sd(`b_sd') se_sd(`se_sd') pclass(`pclass')
			local ix = `ix' + `nbeta'
			local newstripe `newstripe' `r(stripe)'
		}
	}
	
	// Residual Variance
	
	local Struct = proper("`e(rstructure)'")
	if !missing("`Struct'") {
		DiRes`Struct', b_sd(`b_sd') se_sd(`se_sd') pclass(`pclass')
		local newstripe `newstripe' `r(stripe)'
	}
	
	local newstripe : subinstr local newstripe "R." "R_", all
	
	mat colnames `b_sd' = `newstripe'
	mat colnames `pclass' = `newstripe'
	mata: _xtm_sd("`V_sd'","`pclass'")
	mat rownames `V_sd' = `newstripe'
	mat colnames `V_sd' = `newstripe'
	forvalues i = 1/`n' {
		if missing(`se_sd'[1,`i']) mat `se_sd'[1,`i'] = 0
	}
	mat colnames `se_sd' = `newstripe'
	
	ereturn hidden matrix b_sd = `b_sd'
	ereturn hidden matrix V_sd = `V_sd'
	ereturn hidden matrix b_pclass = `pclass'
	ereturn hidden matrix se_sd = `se_sd'
	ereturn hidden local stripe_se `newstripe'
end

program DiResIndependent, rclass
	syntax , b_sd(string) se_sd(string) pclass(string) [relevel(string)]

	_b_pclass var : var
	_b_pclass gr0 : group0
	_b_pclass grj : groupj
	
	if `e(nrgroups)' == 1 {
		local label "sd(Residual)"
		local ix : colnumb `b_sd' lnsig_e:_cons
		DiLogRatioE "" sd
		mat `b_sd'[1,`ix'] = `r(est)'
		mat `se_sd'[1,`ix'] = (`r(se)')^2
		mat `pclass'[1,`ix'] = `var'
		local stripe Residual:sd(e)
	}
	else {
		forval i = 1/`e(nrgroups)' {
			local eq = cond(`i'==1, "", "r_lns`i'ose")
			if "`eq'"=="" local ix : colnumb `b_sd' lnsig_e:_cons
			else local ix : colnumb `b_sd' r_lns`i'ose:_cons
			DiLogRatioE "`eq'" sd
			mat `b_sd'[1,`ix'] = `r(est)'
			mat `se_sd'[1,`ix'] = (`r(se)')^2
			if "`eq'"=="" mat `pclass'[1,`ix'] = `gr0'
			else mat `pclass'[1,`ix'] = `grj'
			local w : word `i' of `e(rgvalues)'
			local stripe `stripe' Residual:sd(e)#`w'
		}
	}
	return local stripe `stripe'
end

program DiResAr, rclass
	syntax , b_sd(string) se_sd(string) pclass(string)
	
	_b_pclass coef : coef
	_b_pclass gr0 : group0
	_b_pclass grj : groupj
	_b_pclass tanh : tanh
	
	tempname mm
	local nn = colsof(`b_sd')
	mata: `mm' = J(1,`nn',"")
	
	forval j = 1/`e(nrgroups)' {
		if `e(nrgroups)'>1 {
			local w : word `j' of `e(rgvalues)'
			local w #`w'
		}
		if `e(ar_p)' == 1 {
			local ix : colnumb `b_sd' r_atr`j':_cons
			qui _diparm r_atr`j', tanh notab
			mat `b_sd'[1,`ix'] = `r(est)'
			mat `se_sd'[1,`ix'] = (`r(se)')^2
			mat `pclass'[1,`ix'] = `tanh'
			mata: `mm'[`ix'] = "Residual:rho`w'"
		}
		else {
			forval i = 1 / `e(ar_p)' {
				local ix : colnumb `b_sd' r_phi`j'_`i':_cons
				qui _diparm r_phi`j'_`i', notab
				mat `b_sd'[1,`ix'] = `r(est)'
				mat `se_sd'[1,`ix'] = (`r(se)')^2
				mat `pclass'[1,`ix'] = `coef'
				mata: `mm'[`ix'] = "Residual:phi`i'`w'"
			}
		}
		local eq = cond(`j'==1, "", "r_lns`j'ose")
		if "`eq'"=="" local ix : colnumb `b_sd' lnsig_e:_cons
		else local ix : colnumb `b_sd' r_lns`j'ose:_cons
		DiLogRatioE "`eq'" sd
		mat `b_sd'[1,`ix'] = `r(est)'
		mat `se_sd'[1,`ix'] = (`r(se)')^2
		if "`eq'"=="" mat `pclass'[1,`ix'] = `gr0'
		else mat `pclass'[1,`ix'] = `grj'
		mata: `mm'[`ix'] = "Residual:sd(e)`w'"
	}
	
	mata: st_local("stripe",invtokens(`mm'))
	mata: mata drop `mm'
	
	return local stripe `stripe'
end

program DiResMa, rclass
	syntax , b_sd(string) se_sd(string) pclass(string)
	
	_b_pclass coef : coef
	_b_pclass gr0 : group0
	_b_pclass grj : groupj
	_b_pclass tanh : tanh
	
	tempname mm
	local nn = colsof(`b_sd')
	mata: `mm' = J(1,`nn',"")
	
	forval j = 1 / `e(nrgroups)' {
		if `e(nrgroups)'>1 {
			local w : word `j' of `e(rgvalues)'
			local w #`w'
		}	
		if `e(ma_q)' == 1 {
			local ix : colnumb `b_sd' r_att`j':_cons
			qui _diparm r_att`j', tanh notab
			mat `b_sd'[1,`ix'] = `r(est)'
			mat `se_sd'[1,`ix'] = (`r(se)')^2
			mat `pclass'[1,`ix'] = `tanh'
			mata: `mm'[`ix'] = "Residual:theta1`w'"
		}
		else {
			forval i = 1 / `e(ma_q)' {
				local ix : colnumb `b_sd' r_theta`j'_`i':_cons
				qui _diparm r_theta`j'_`i', notab
				mat `b_sd'[1,`ix'] = `r(est)'
				mat `se_sd'[1,`ix'] = (`r(se)')^2
				mat `pclass'[1,`ix'] = `coef'
				mata: `mm'[`ix'] = "Residual:theta`i'`w'"
			}
		}
		local eq = cond(`j'==1, "", "r_lns`j'ose")
		if "`eq'"=="" local ix : colnumb `b_sd' lnsig_e:_cons
		else local ix : colnumb `b_sd' r_lns`j'ose:_cons
		DiLogRatioE "`eq'" sd
		mat `b_sd'[1,`ix'] = `r(est)'
		mat `se_sd'[1,`ix'] = (`r(se)')^2
		if "`eq'"=="" mat `pclass'[1,`ix'] = `gr0'
		else mat `pclass'[1,`ix'] = `grj'
		mata: `mm'[`ix'] = "Residual:sd(e)`w'"
	}
	
	mata: st_local("stripe",invtokens(`mm'))
	mata: mata drop `mm'
	
	return local stripe `stripe'
end

program DiResBanded, rclass
	syntax , [*]
	DiResUnstructured, banded `options'
	return local stripe `r(stripe)'
end

program DiResUnstructured, rclass
	syntax , b_sd(string) se_sd(string) pclass(string) [banded]
	
	_b_pclass gr0 : group0
	_b_pclass grj : groupj
	_b_pclass tanh : tanh
	
	if "`banded'" != "" {
		local order `e(res_order)'
	}
	else {
		local order 0
	}	
	tempname tmap
	mat `tmap' = e(tmap)
	local nt = colsof(`tmap')
	
	tempname mm
	local nn = colsof(`b_sd')
	mata: `mm' = J(1,`nn',"")
	
	forval j = 1 / `e(nrgroups)' {
		if `e(nrgroups)'>1 {
			local w : word `j' of `e(rgvalues)'
			local w #`w'
		}
		forval i = 1/`nt' {
			local elab : di "e"`tmap'[1,`i']
			local eq r_lns`j'_`i'ose
			if (`i'==1) & (`j'==1) {
				local eq 
			}
			if "`eq'"=="" local ix : colnumb `b_sd' lnsig_e:_cons
			else local ix : colnumb `b_sd' r_lns`j'_`i'ose:_cons
			DiLogRatioE "`eq'" sd
			mat `b_sd'[1,`ix'] = `r(est)'
			mat `se_sd'[1,`ix'] = (`r(se)')^2
			if "`eq'"=="" mat `pclass'[1,`ix'] = `gr0'
			else mat `pclass'[1,`ix'] = `grj'
			mata: `mm'[`ix'] = "Residual:sd(`elab')`w'"
		}
		forval i = 1/`nt' {
			forval k = `=`i'+1'/`nt' {
				if (`k' > `i'+`order') & "`banded'"!="" {
					continue, break
				}
				local e1 : di "e"`tmap'[1,`i']
				local e2 : di "e"`tmap'[1,`k']
				local ix : colnumb `b_sd' r_atr`j'_`i'_`k':_cons
				qui _diparm r_atr`j'_`i'_`k', tanh notab
				mat `b_sd'[1,`ix'] = `r(est)'
				mat `se_sd'[1,`ix'] = (`r(se)')^2
				mat `pclass'[1,`ix'] = `tanh'
				mata: `mm'[`ix'] = "Residual:corr(`e1',`e2')`w'"
			}
		}
	}
	
	mata: st_local("stripe",invtokens(`mm'))
	mata: mata drop `mm'
	
	return local stripe `stripe'
end

program DiResExchangeable, rclass
	syntax , b_sd(string) se_sd(string) pclass(string)
	
	_b_pclass gr0 : group0
	_b_pclass grj : groupj
	_b_pclass tanh : tanh
	
	forval j = 1 / `e(nrgroups)' {
		if `e(nrgroups)'>1 {
			local w : word `j' of `e(rgvalues)'
			local w #`w'
		}
		local eq = cond(`j'==1, "", "r_lns`j'ose")
		if "`eq'"=="" local ix : colnumb `b_sd' lnsig_e:_cons
		else local ix : colnumb `b_sd' r_lns`j'ose:_cons
		DiLogRatioE "`eq'" sd
		mat `b_sd'[1,`ix'] = `r(est)'
		mat `se_sd'[1,`ix'] = (`r(se)')^2
		if "`eq'"=="" mat `pclass'[1,`ix'] = `gr0'
		else mat `pclass'[1,`ix'] = `grj'
		local stripe `stripe' Residual:sd(e)`w'
		
		local ix : colnumb `b_sd' r_atr`j':_cons
		qui _diparm r_atr`j', tanh notab
		mat `b_sd'[1,`ix'] = `r(est)'
		mat `se_sd'[1,`ix'] = (`r(se)')^2
		mat `pclass'[1,`ix'] = `tanh'
		local stripe `stripe' Residual:corr(ei,ej)`w'
	}
	return local stripe `stripe'
end

program DiResToeplitz, rclass
	syntax , b_sd(string) se_sd(string) pclass(string)
	
	_b_pclass gr0 : group0
	_b_pclass grj : groupj
	_b_pclass tanh : tanh
	
	tempname mm
	local nn = colsof(`b_sd')
	mata: `mm' = J(1,`nn',"")
	
	forval j = 1 / `e(nrgroups)' {
		if `e(nrgroups)'>1 {
			local w : word `j' of `e(rgvalues)'
			local w #`w'
		}
		local eq = cond(`j'==1, "", "r_lns`j'ose")
		forval k = 1 / `e(res_order)' {
			local ix : colnumb `b_sd' r_atr`j'_`k':_cons
			qui _diparm r_atr`j'_`k', tanh notab
			mat `b_sd'[1,`ix'] = `r(est)'
			mat `se_sd'[1,`ix'] = (`r(se)')^2
			mat `pclass'[1,`ix'] = `tanh'
			mata: `mm'[`ix'] = "Residual:rho`k'`w'"
		}
		if "`eq'"=="" local ix : colnumb `b_sd' lnsig_e:_cons
		else local ix : colnumb `b_sd' r_lns`j'ose:_cons
		DiLogRatioE "`eq'" sd
		mat `b_sd'[1,`ix'] = `r(est)'
		mat `se_sd'[1,`ix'] = (`r(se)')^2
		if "`eq'"=="" mat `pclass'[1,`ix'] = `gr0'
		else mat `pclass'[1,`ix'] = `grj'
		mata: `mm'[`ix'] = "Residual:sd(e)`w'"
	}
	
	mata: st_local("stripe",invtokens(`mm'))
	mata: mata drop `mm'
	
	return local stripe `stripe'
end

program DiResExponential, rclass
	syntax , b_sd(string) se_sd(string) pclass(string)
	
	_b_pclass gr0 : group0
	_b_pclass grj : groupj
	_b_pclass ilogi : invlogit
	
	tempname mm
	local nn = colsof(`b_sd')
	mata: `mm' = J(1,`nn',"")
	
	forval j = 1 / `e(nrgroups)' {
		if `e(nrgroups)'>1 {
			local w : word `j' of `e(rgvalues)'
			local w #`w'
		}
		local eq = cond(`j'==1, "", "r_lns`j'ose")
		local ix : colnumb `b_sd' r_logitr`j':_cons
		qui _diparm r_logitr`j', invlogit notab
		mat `b_sd'[1,`ix'] = `r(est)'
		mat `se_sd'[1,`ix'] = (`r(se)')^2
		mat `pclass'[1,`ix'] = `ilogi'
		mata: `mm'[`ix'] = "Residual:rho`w'"
		if "`eq'"=="" local ix : colnumb `b_sd' lnsig_e:_cons
		else local ix : colnumb `b_sd' r_lns`j'ose:_cons
		DiLogRatioE "`eq'" sd
		mat `b_sd'[1,`ix'] = `r(est)'
		mat `se_sd'[1,`ix'] = (`r(se)')^2
		if "`eq'"=="" mat `pclass'[1,`ix'] = `gr0'
		else mat `pclass'[1,`ix'] = `grj'
		mata: `mm'[`ix'] = "Residual:sd(e)`w'"
	}
	
	mata: st_local("stripe",invtokens(`mm'))
	mata: mata drop `mm'
	
	return local stripe `stripe'
end

program DiLogRatioE
	args eq type
	local c = cond("`type'"=="sd", 1, 2)
	if "`eq'" == "" {
		qui _diparm lnsig_e, function(exp(`c'*@)) /// 
				     deriv(`c'*exp(`c'*@)) notab
	}
	else {
		qui _diparm lnsig_e `eq', ///
					 function(exp(`c'*@1+`c'*@2)) ///
				         deriv(`c'*exp(`c'*@1+`c'*@2) ///
				         `c'*exp(`c'*@1+`c'*@2))      ///
					 notab ci(log)
	}
end

program DiParms, rclass
	syntax [, pos(string) nb(string) names(string asis) cilev(string) ///
		bmatrix(string) relevel(string) ///
		b_sd(string) se_sd(string) pclass(string)]
	
	_b_pclass var : var
	_b_pclass tanh : tanh
	
	local stripes : coleq `bmatrix', quoted
	forvalues k = 1/`nb' {
		local label : word `k' of `names'
		local ix = `pos'+`k'
		local eq : word `ix' of `stripes'
		GetParmEqType `eq'
		local type `s(type)'
		local parm `s(parm)'
		local n : list sizeof label
		if "`type'"=="sd" & `n'>1 {
			local label : word 1 of `label'
			local label `label')
		}
		if "`type'"=="corr" & `n'>2 {
			gettoken first label : label
			gettoken second label : label
			local label `first',`second')
		}
		local label `"`s(type)'`label'"'
		local diparmeq `"`s(diparmeq)'"'
		qui _diparm `diparmeq', `parm' notab
		mat `b_sd'[1,`ix'] = `r(est)'
		mat `se_sd'[1,`ix'] = (`r(se)')^2
		local stripe `stripe' `relevel':`label'
		if "`type'" == "sd" {
			mat `pclass'[1,`ix'] = `var'
		}
		if "`type'" == "corr" {
			mat `pclass'[1,`ix'] = `tanh'
		}
	}
	return local stripe `stripe'
end

program GetNames, sclass
	args type zvars dimz

	gettoken dim dimz : dimz
	forvalues k = 1/`dim' {
		gettoken tok1 zvars : zvars
		local fullvarnames `fullvarnames' `tok1'
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
			local names `""(`varnames')""'
			if `ex' {
				local names `"`names' "(`varnames')""'
			}
		}
	}

	sreturn local zvars "`zvars'"
	sreturn local dimz "`dimz'"
	sreturn local names `"`names'"'
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
	else { // substr("`eq'",1,1) == "a"  atanh correlation
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

