*! version 2.1.0  04feb2015
program define boxcox_p
	
       local ver = _caller()
	version 7.0, missing

	if `ver' >=13 {

		syntax newvarname [if] [in], [ YHAT REsiduals ///
		Smearing BTransform] 

		local a {p} options
		local b may not be combined{p_end}
		local sopt "`smearing'`btransform'"
		local twostat "`yhat'`residuals'"

		if "`smearing'" !="" & "`btransform'"!="" {

			display as error ///
			"`a' {bf:smearing} and {bf:btransform} `b'"
			exit 184
		}
		
		if "`twostat'"=="" & "`sopt'"!="" {
	
			local yhat `sopt'
			local twostat .
			display as text ///
			"(statistic {bf:yhat} assumed)"
		}
		
		if "`twostat'"=="" & "`sopt'"=="" {
			
			local yhat smearing
			local twostat .
			display as text ///
			"(statistic {bf:yhat} and option {bf:smearing} are assumed)"
		}
		
		if "`twostat'"=="`yhat'" & "`sopt'"!=""{

			local yhat `sopt'
		}	

		if "`twostat'"=="`residuals'" & "`sopt'"!=""{
	
			local residuals `sopt'
		}

		if "`twostat'"=="`yhat'" & "`sopt'"=="" {
		
			local yhat smearing
			display as text /// 
			"(option {bf:`yhat'} assumed to compute predicted values)"
		}

		if "`twostat'"=="`residuals'" & "`sopt'"==""{
		
			local residuals smearing
			display as text /// 
			"(option {bf:`residuals'} assumed to compute residuals)"
		}

	}
	else {
		syntax newvarname [if] [in], [ YHAT XBT REsiduals] 
	}	
	
	local sumt = ("`yhat'"!="") + ("`residuals'"!="") + ("`xbt'"!="") 
 
	if `sumt' >1 {
		di as err "only one statistic may be specified"
		exit 198
	}
	else { 
		if `sumt' == 0 & `ver'<13 {
			local stat xbt
			di as txt /*
		*/ "(option `stat' assumed to compute predicted values)"
		}
		else 	local stat "`yhat'`xbt'`residuals'"
	}
	
	if "`yhat'"=="smearing"|"`residuals'"=="smearing"{
	
		getvars
		local ntvars `s(ntvars)'
		local tvars `s(tvars)'
		local ncons `s(ncons)'
		local tcons `s(tcons)'
		tempvar smear 
		tempvar touse
		marksample touse, novarlist
		markout `touse' `e(depvar)' `ntvars' `tvars'
		if (`ncons' | `tcons') {
			tempvar cons
			qui gen byte `cons' = 1 if `touse'
			if (`ncons') {
				local ntvars `ntvars' `cons'
			}
			if (`tcons'){
				local tvars `tvars' `cons'
			}
		}

		qui generate double `smear' = . 	
		mata: _boxcox_smearing("`smear'", "`ntvars'", "`tvars'", ///
		"`yhat'"!="", "`touse'", 1)

		if "`yhat'"!="" {
	
			generate `typlist' `varlist' = `smear'
			label variable `varlist' "smearing fitted values"
		}
		else if "`residuals'"!="" {
		
			generate `typlist' `varlist' = ///
			`e(depvar)'-`smear'
			label variable `varlist' "smearing residuals"
		}

		exit
	}
	else if "`yhat'"=="btransform"|"`residuals'"=="btransform" {
		
		getvars
		local ntvars `s(ntvars)'
		local tvars `s(tvars)'
		local ncons `s(ncons)'
		local tcons `s(tcons)'
		tempvar smear 
		tempvar touse
		marksample touse, novarlist
		markout `touse' `e(depvar)' `ntvars' `tvars'
		if (`ncons' | `tcons') {
			tempvar cons
			qui gen byte `cons' = 1 if `touse'
			if (`ncons') {
				local ntvars `ntvars' `cons'
			}
			if (`tcons'){
				local tvars `tvars' `cons'
			}
		}

		qui generate double `smear' = . 	
		mata: _boxcox_smearing("`smear'", "`ntvars'", "`tvars'", ///
		"`yhat'"!="", "`touse'", 0)
		
		if "`yhat'"!="" {
	
			generate `typlist' `varlist' = `smear'
			label variable `varlist' ///
			"back-transform fitted values"
		}
		else if "`residuals'"!="" {
		
			generate `typlist' `varlist' = ///
			`e(depvar)'-`smear'
			label variable `varlist' ///
			"back-transform residuals"
		}

		exit
	}

	tempname diff

	if "`e(model)'" == "rhsonly" {
		tempname bvec lam1 lam
		tempvar ntrans

		matrix `bvec'=e(b)

		matrix `lam1'=`bvec'[1,"lambda:_cons"]
		scalar `lam'=`lam1'[1,1]

/* 	Get linear part using _predict */

		if "`e(ntrans)'" != "" {
			quietly _predict double `ntrans', xb eq(#1) 
		}
		else 	scalar `ntrans' = 0

		local cnames : colnames `bvec'
		local ceqs : coleq `bvec'

		tokenize `ceqs'
		local i 1
		local rhs
	
		while "`1'" != "" {
			if "`1'" == "Trans" {
				local var : word `i' of `cnames'
				scalar `diff'=reldif(`lam', 0) 
				if `diff'>1e-10 {
				   local rhs /*
*/ "`rhs' + `bvec'[1,`i']*( `var'^`lam' -1 )/`lam' "
				}
				else {
				   local rhs /*
*/ "`rhs' +  `bvec'[1,`i']*ln(`var') "
				}
			}
			local i = `i' + 1
			macro shift
		}

		if "`stat'"=="residuals" {
			gen `typlist' `varlist' = `e(depvar)' /*
				*/  -( `ntrans' `rhs' ) `if' `in'

		}
		else {
			gen `typlist' `varlist'= `ntrans'  `rhs' `if' `in'
			label variable `varlist' "fitted values"
		}
		exit
	}
	if "`e(model)'"=="lhsonly" {

		tempname bvec theta1 theta
		tempvar ntrans

		matrix `bvec'=e(b)
		matrix `theta1'=`bvec'[1,"theta:_cons"]
		scalar `theta'=`theta1'[1,1]

		scalar `diff'=reldif(`theta', 0)


/* 	Get linear part using _predict */
		quietly  _predict double `ntrans', xb eq(#1) 

		if "`stat'"=="xbt" {
			gen `typlist' `varlist'= `ntrans' `if' `in'
			local lab "(Transformed) Linear Prediction"	
			label variable `varlist' "`lab'"
			exit
		}
		if "`stat'" =="yhat" {
			if `diff'>1e-10 {
				gen `typlist' `varlist'= /*
					*/ (`theta'*`ntrans'+1 )^(1/`theta') /*
					*/ `if' `in'
			}
			else 	gen `typlist' `varlist'=/* 
					*/ exp(`ntrans') `if' `in'
			label variable `varlist' "fitted values"
			exit
		}
/* if not xbt nor yhat then must be residuals */
		if `diff'>1e-10 {
			gen `typlist' `varlist'=`e(depvar)'- /*
				*/ (`theta'*`ntrans'+1 )^(1/`theta') `if' `in'
		}
		else 	gen `typlist' `varlist'=`e(depvar)' - /* 
				*/ exp(`ntrans') `if' `in'
		label variable `varlist' "residuals"
		exit
	}

	if "`e(model)'" == "lambda" {
		tempname bvec lam1 lam
		tempvar ntrans

		matrix `bvec'=e(b)

		matrix `lam1'=`bvec'[1,"lambda:_cons"]
		scalar `lam'=`lam1'[1,1]

/* 	Get linear part using _predict */
		
		if "`e(ntrans)'" != "" {
			quietly _predict double `ntrans', xb eq(#1) 
		}
		else 	scalar `ntrans' = 0

		local cnames : colnames `bvec'
		local ceqs : coleq `bvec'

		tokenize `ceqs'
		local i 1
		local rhs 
	
		while "`1'" != "" {
			if "`1'" == "Trans" {
				local var : word `i' of `cnames'
				scalar `diff'=reldif(`lam', 0.0)
				if `diff'>1e-10 {
					local rhs  /*
*/ "`rhs' + `bvec'[1,`i']*(`var'^`lam' -1 )/`lam' "
				}
				else {
				   local rhs " `rhs'+`bvec'[1,`i']*ln( `var' ) "
				}
			}
			local i = `i' + 1
			macro shift
		}

		if "`stat'"=="xbt" {
			gen `typlist' `varlist' = ( `ntrans' `rhs' ) `if' `in'
		}
		else {
			if "`stat'" =="yhat" {
			
				gen `typlist' `varlist' = (`lam'*( `ntrans' /*
					*/  `rhs' )+1)^(1/`lam') /*
					*/  `if' `in'
				label variable `varlist' "fitted values"
			}
			else {
				gen `typlist' `varlist' = `e(depvar)' - /* 
					*/ (`lam'*( `ntrans' `rhs' /*
					*/ )+1)^(1/`lam')   `if' `in'
				label variable `varlist' "residuals"
			}
	
		}
		exit
	}

	if "`e(model)'" == "theta" {
		tempname bvec lam1 lam theta1 theta
		tempvar ntrans

		matrix `bvec'=e(b)

		matrix `lam1'=`bvec'[1,"lambda:_cons"]
		scalar `lam'=`lam1'[1,1]

		matrix `theta1'=`bvec'[1,"theta:_cons"]
		scalar `theta'=`theta1'[1,1]


/* 	Get linear part using _predict */
		
		if "`e(ntrans)'" != "" {
			quietly  _predict double `ntrans', xb eq(#1) 
		}
		else 	scalar `ntrans' = 0.0

		local cnames : colnames `bvec'
		local ceqs : coleq `bvec'

		tokenize `ceqs'
		local i 1
		local rhs
	
		while "`1'" != "" {
			if "`1'" == "Trans" {
				local var : word `i' of `cnames'
				scalar `diff'=reldif(`lam', 0.0) 
				if `diff'>1e-10 {
				   local rhs  /*
*/ " `rhs' + `bvec'[1,`i']*( `var'^`lam' -1 )/`lam' "
				}
				else {
				   local rhs /*
*/  " `rhs' + `bvec'[1,`i']*ln( `var' ) "
				}
			}
			local i = `i' + 1
			macro shift
		}

		if "`stat'"=="xbt" {
			gen `typlist' `varlist' = ( `ntrans' `rhs' ) `if' `in'
			local lab "(Transformed) Linear Prediction"	
			label variable `varlist' "`lab'"
		}
		else {
			if "`stat'" =="yhat" {

				gen `typlist' `varlist' = (`theta'*( `ntrans'/*
					*/ `rhs' )+1)^(1/`theta')  `if' `in'
				label variable `varlist' "fitted values"
			}
			else {
				gen `typlist' `varlist' = `e(depvar)' - /*
					*/ (`theta'*( `ntrans' `rhs' /*
					*/ )+1)^(1/`theta')   `if' `in'
				label variable `varlist' "residuals"
			}
	
		}
		exit
	}

end


program define getvars, sclass

	local eq:coleq e(b)
	local names: colnames e(b)
	local tcons = 0
	local ncons = 0
	gettoken eqi eq: eq
	while "`eqi'" == "Notrans" {
		
		gettoken ni names: names
		if "`ni'" == "_cons" {

			local ncons = 1
			gettoken eqi eq: eq
			continue, break
		}
		local ntvars `ntvars' `ni'
		gettoken eqi eq: eq
	}
	while "`eqi'" == "Trans" {
		
		gettoken ni names : names
		if "`ni'" == "_cons" {

			local tcons = 1
			continue, break
		}

		local tvars `tvars' `ni'
		gettoken eqi eq: eq
	}
	local knt : list sizeof ntvars
	local kt : list sizeof tvars

	sreturn local ntvars `ntvars'
	sreturn local knt = `knt'
	sreturn local tvars `tvars'
	sreturn local kt = `kt'
	sreturn local tcons = `tcons'
	sreturn local ncons = `ncons'
end

