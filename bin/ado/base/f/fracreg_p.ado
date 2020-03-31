*! version 1.0.3  30aug2016
program define fracreg_p, sort
	version 14

	syntax [anything] [if] [in], 		///
			[ 			///
			SCores			///
			xb  			///
			stdp			///
			cm			///
			Sigma			///
			Equation(string)        ///
			*			///
			]

	if (`"`scores'"'!= "") {
		GenScores `0' fractional
		exit
	}	
	
	if "`equation'"!=""{
		display as error "option {bf:equation()} only valid with" ///
				 " statistic {bf:scores}"
	}
	
	local oopts cm Sigma xb stdp
	local myopts `oopts' 
	_pred_se "`myopts'" `0'
	if `s(done)' { 
		exit 
	}
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'

	syntax [if] [in] [, `myopts' noOFFset]
	if `:length local index' {
		local xb xb
	}

	local type "`xb'`stdp'`cm'`sigma'"
	local verif = ("`xb'"!="") + ("`cm'"!="") + ("`stdp'"!="") + ///
	               ("`sigma'"!="")

	if `verif' > 1 {
			display as error "only one statistic may be specified"
			exit 198
	}
	
	if ("`e(estimator)'"!="hetprobit"& "`type'"=="sigma") {
			di in red as smcl ///
				"option {bf:sigma} invalid"
			di in red as smcl "{p 4 4 2}"
			di in red as smcl "Option {bf:sigma} may only be" 
			di in red as smcl "specified when option {bf:het()}" 
			di in red as smcl "is specified with {bf:fracreg}." 
			di in red as smcl "{p_end}"
		exit 198
	}
		
	if ("`type'"==""|"`type'"=="cm") {
		if ("`type'"==""){
			display as txt "(option {bf:cm} assumed)"
		}
		if "`e(prefix)'`e(opt)'" != "" {
			tempname xb xb2
			quietly _predict double `xb' `if' `in', `offset' xb
			if "`e(estimator)'"=="probit" {
				quietly gen `vtyp' `varn' = normal(`xb')
			}
			if "`e(estimator)'"=="logit" {
				quietly gen `vtyp' `varn' = ///
						exp(`xb')/(1+ exp(`xb'))
			}
			if "`e(estimator)'"=="hetprobit" {
				quietly _predict double `xb2' `if' `in', ///
					`offset' xb equation(#2)
				quietly gen `vtyp' `varn' = ///
						normal(`xb'/exp(`xb2'))
			}
			_pred_missings `varn'
		}
		else {
			_predict `vtyp' `varn' `if' `in', `offset'
		}
		label var `varn' "Conditional mean of `e(depvar)'"
		exit
	}
	if "`type'"=="xb" {
		quietly _predict `vtyp' `varn' `if' `in', `offset' xb
		_pred_missings `varn'
		label var `varn' "Linear prediction"
		exit
	}
	if "`type'"=="sigma" {
		tempname xb
		quietly _predict double `xb' `if' `in', `offset' xb eq(#2)
		quietly gen `vtyp' `varn' = exp(`xb')
		_pred_missings `varn'
		label var `varn' "Sigma"
		exit
	}
	if "`type'"=="stdp" {
		opts_exclusive "stdp `rules'"
		quietly _predict `vtyp' `varn' `if' `in', `offset' stdp
		_pred_missings `varn'
		label var `varn' "S.E. of the prediction"
		exit
	}

*/
end

program define GetRhs /* name */ 
	args where
	tempname b 
	mat `b' = get(_b)
	local rhs : colnames `b'
	mat drop `b'
	local n : word count `rhs'
	tokenize `rhs'
	if "``n''"=="_cons" {
		local `n'
	}
	c_local `where' "`*'"
end

program GenScores, rclass
	version 9, missing
	syntax [anything] [if] [in] [, fractional equation(string)* ]
	
	local equacion = 0 
	if "`equation'"!="" {
		gettoken testing equation: equation, parse("#")
		if (`equation'>2|`equation'<1) {
			display as error "option {bf:equation()} specified" ///
			" incorrectly"
			exit 198
		}
		if ("`e(estimator)'"!="hetprobit"& `equation'==2){
			display as error "`e(estimator)' has only one equation"
			exit 198
		}
		local equacion = `equation'
	}
	
	if "`e(estimator)'"!="hetprobit" {
		_score_spec `anything', `options'
		local varn `s(varlist)'
		local vtyp `s(typlist)'
		tempvar xb
		_predict double `xb' `if' `in', xb
		tempvar uno dos
		
		if "`e(estimator)'"=="probit" {
			quietly gen `vtyp' `uno' = -normden(`xb')/normal(-`xb')
			quietly gen `vtyp' `dos' = normden(`xb')/normal(`xb')
			quietly gen `vtyp' ///
			`varn' = `e(depvar)'*`dos' + (1-`e(depvar)')*`uno'
			local cmd = ///
			cond("`e(prefix)'"=="svy","svy:","")+"`e(cmd)'"
			label var `varn' ///
			"equation-level score from fractional probit"	
		}
		if "`e(estimator)'"=="logit" {
			quietly gen `vtyp' `uno' = 1/(1 + exp(`xb'))
			quietly gen `vtyp' `dos' = -exp(`xb')/(1 + exp(`xb'))
			quietly gen `vtyp' ///
			`varn' = `e(depvar)'*`uno' + (1-`e(depvar)')*`dos'
			local cmd = ///
			cond("`e(prefix)'"=="svy","svy:","")+"`e(cmd)'"
			label var `varn' ///
			"equation-level score from fractional logit"	
		}
		return local scorevars `varn'
	}
	else {
		marksample touse 
		tempname A
		matrix `A' = e(b)
		_stubstar2names `anything', nvars(2) singleok
		local score = real("`s(stub)'")
		local varlist  = s(varlist)
		local typlist `s(typlist)'
		local ns: list sizeof varlist 		
		tempname strin1 strin2 strin3 strin4 strin5 strin6
		quietly generate double `strin1' = .
		quietly generate double `strin2' = .
		local ns2 = `ns'
		if "`equation'"!="" {
			local ns = 2
		}
		
		mata: _HeT_ProbiT__scores("`A'", "`e(depvar)'", 	///
			"`e(xvars)'", "`e(zvars)'", `ns', `e(cons)',	///
			"`touse'", "`strin1'", "`strin2'")
		if (`ns2'>1) {
			local name1 = word("`varlist'",1)
			local name2 = word("`varlist'",2)
			generate `typlist' `name1' = `strin1'
			label var `name1' ///
			"equation-level score for [`e(depvar)']"
			generate `typlist' `name2' = `strin2'
			label var `name2' "equation-level score for [lnsigma]"
		}
		if (`ns2'==1 & (`equacion'==1|`equacion'==0)) {
			local name1 = word("`varlist'",1)
			generate `typlist' `name1' = `strin1'
			label var `name1' ///
			"equation-level score for [`e(depvar)']"
		}
		if (`ns2'==1 &`equacion'==2) {
			local name1 = word("`varlist'",1)
			generate `typlist' `name1' = `strin2'
			label var `name1' ///
			"equation-level score for [lnsigma]"
		}
	}
end

exit
