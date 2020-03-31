*! version 1.0.2  07jun2019
program _lasso_p

	version 16.0
	
	if (`"`e(cmd)'"' != "lasso" &	///
		`"`e(cmd)'"' != "sqrtlasso" & ///
		`"`e(cmd)'"' != "elasticnet" ) {
		error 301
	}

	syntax newvarname [if] [in] [, * noOFFset]
						//  marksample
	marksample touse, novarlist
						//  get prediction options
	ParsePreOpt , `options'
	local preopt `s(preopt)'
	local var_lb `s(var_lb)'
	local typeb `s(typeb)'
						// parse offset
	ParseOffset , `offset' preopt(`preopt')
	local is_offset = `s(is_offset)'
						//  compute prediction
	ComputePredict, 		///
		varlist(`varlist')	///
		typlist(`typlist')	///
		preopt(`preopt') 	///
		typeb(`typeb') 		///
		touse(`touse')		///
		var_lb(`var_lb')	///
		is_offset(`is_offset')
end

					//----------------------------//
					// parse prediction options
					//----------------------------//
program ParsePreOpt, sclass
	syntax [, POSTselection PENalized xb pr n hr ir]

						//  parse type b
	ParseTypeb, `postselection' `penalized'
	local typeb `s(typeb)'
	local optxt `s(optxt)'
	local tbtxt1 `s(tbtxt1)'
	local tbtxt2 `s(tbtxt2)'

						//  parse type of prediction
	ParseTypePre, `xb' `pr' `n' `hr' `ir' 	///
		typeb(`typeb')			///
		optxt(`optxt')			///
		tbtxt1(`tbtxt1')		///
		tbtxt2(`tbtxt2')		
	local preopt `s(preopt)'

						//  check preopt
	CheckPreopt, preopt(`preopt') 

						//  parse variable label
	ParseVarlb, preopt(`preopt') typeb(`typeb')
	local var_lb `s(var_lb)'

						//  sreturn results
	sret local typeb `typeb'
	sret local preopt `preopt'
	sret local var_lb `var_lb'
end

					//----------------------------//
					// parse type of e(b)
					//----------------------------//
program ParseTypeb, sclass
	syntax [, postselection penalized]

	local typeb `postselection' `penalized'
	local n_typeb : list sizeof typeb

	if (`n_typeb' > 1) {
		di as err "only one of {bf:postselection} and "	///
			"{bf:penalized} may be specified"
		exit 198
		// NotReached
	}
	
	local optxt option
	local tbtxt1 assumed

	if (`n_typeb' == 0) {
		local typeb penalized
		local tbtxt1 "{bf:penalized} assumed"
		local tbtxt2 penalized 
		local optxt options
	}
	else if (`"`typeb'"' == "postselection") {
		local tbtxt2 postselection
	}
	else if (`"`typeb'"' == "penalized") {
		local tbtxt2 penalized
	}

	sret local typeb `typeb'
	sret local optxt `optxt'
	sret local tbtxt1 `tbtxt1'
	sret local tbtxt2 `tbtxt2'
end

					//----------------------------//
					// Parse type of prediction
					//----------------------------//
program ParseTypePre, sclass
	syntax [, xb pr n hr 	///
		ir		///
		typeb(string) 	///
		optxt(string) 	///
		tbtxt1(string) 	///
		tbtxt2(string) ]
	
	local model `e(model)'

	local preopt `xb' `pr' `n' `hr' `ir'
	local n_case : list sizeof preopt

	if (`n_case' > 1) {
		di as err "only one {it:statistic} may be specified"
		exit 198
	}
						//  default case
	if (`"`model'"' == "linear") {
		local def_txt `"(`optxt' {bf:xb} `tbtxt1'; "'	///
			`"linear prediction with `tbtxt2' coefficients)"'
		local def_preopt xb
	}
	else if (`"`model'"' == "logit" | `"`model'"' == "probit") {
		local def_txt `"{p}(`optxt' {bf:pr} `tbtxt1'; "'	///
			`"Pr(`e(depvar)') with `tbtxt2' coefficients){p_end}"'
		local def_preopt pr
	}
	else if (`"`model'"' == "poisson") {
		local def_txt `"{p}(`optxt' {bf:n} `tbtxt1'; "'		///
		       `"predicted number of events with `tbtxt2' "'	///
		       `"coefficients){p_end}"'
		local def_preopt n
	}
	else if (`"`model'"' == "cox") {
		local def_txt `"(`optxt' {bf:hr} `tbtxt1'; "'	///
			`"predicted hazard ratio with `tbtxt2' coefficients)"'
		local def_preopt hr
	}

	if (`n_case'==0) {
		di as txt `"`def_txt'"'
		local preopt `def_preopt'
	}
	else if (`"`xb'"' != "") {
		if (`"`tbtxt1'"' != "assumed") {
			local def_txt `"(option `tbtxt1'; "'	///
			       `"linear prediction with `tbtxt2' coefficients)"'
			di as txt `"`def_txt'"'
		}
	}
	else if (`"`pr'"' != "") {
		if (`"`tbtxt1'"' != "assumed") {
			local def_txt `"{p}(option `tbtxt1'; "'		///
				`"Pr(`e(depvar)') with `tbtxt2' "'	///
				`"coefficients){p_end}"'
			di as txt `"`def_txt'"'
		}
	}
	else if (`"`n'"' != "") {
		if (`"`tbtxt1'"' != "assumed") {
			local def_txt `"{p}(option `tbtxt1'; "'	     	     ///
				`"predicted number of events with `tbtxt2'"' ///
				`" coefficients){p_end}"'
			di as txt `"`def_txt'"'
		}
	}
	else if (`"`ir'"' != "") {
		if (`"`tbtxt1'"' != "assumed") {
			local def_txt `"{p}(option `tbtxt1'; "'	   ///
				`"predicted incidence rate with `tbtxt2'"' ///
				`" coefficients){p_end}"'
			di as txt `"`def_txt'"'
		}
	}

	sret local preopt `preopt'
end
					//----------------------------//
					// Check conflicts between model and
					// preopt
					//----------------------------//
program CheckPreopt
	syntax [, preopt(string)]

	local model `e(model)'

	if (    (`"`model'"' == "linear" & `"`preopt'"' == "n")	  |	///
		(`"`model'"' == "linear" & `"`preopt'"' == "pr")  |	///
		(`"`model'"' == "linear" & `"`preopt'"' == "ir")  |	///
		(`"`model'"' == "linear" & `"`preopt'"' == "hr")  |	///
	    	(`"`model'"' == "logit" & `"`preopt'"' == "n") 	  |	///
	    	(`"`model'"' == "logit" & `"`preopt'"' == "ir")	  |	///
		(`"`model'"' == "logit" & `"`preopt'"' == "hr")   |	///
		(`"`model'"' == "probit" & `"`preopt'"' == "n")   |	///
		(`"`model'"' == "probit" & `"`preopt'"' == "ir")  |	///
		(`"`model'"' == "probit" & `"`preopt'"' == "hr")  |	///
		(`"`model'"' == "cox" & `"`preopt'"' == "n") 	  |	///
		(`"`model'"' == "cox" & `"`preopt'"' == "ir") 	  |	///
		(`"`model'"' == "cox" & `"`preopt'"' == "pr") 	  |	///
		(`"`model'"' == "poisson" & `"`preopt'"' == "hr") |	///
		(`"`model'"' == "poisson" & `"`preopt'"' == "pr") ) {
		di as err "option {bf:`preopt'} not allowed with `model' model"
		exit 198
	}
end
					//----------------------------//
					// Parse prediction variable label
					//----------------------------//
program ParseVarlb, sclass
	syntax , preopt(string) typeb(string)

	if (`"`preopt'"' == "xb") {
		local var_lb "Fitted values, `typeb'"
	}
	else if (`"`preopt'"' == "pr") {
		local var_lb `"Pr(`e(depvar)'), `typeb'"'
	}
	else if (`"`preopt'"' == "n") {
		local var_lb `"Predicted number of events, `typeb'"'
	}
	else if (`"`preopt'"' == "ir") {
		local var_lb `"Predicted incidence rate, `typeb'"'
	}
	else if (`"`preopt'"' == "hr") {
		local var_lb `"Predicted hazard ratio, `typeb'"'
	}

	sret local var_lb `var_lb'
end

					//----------------------------//
					// ComputePredict
					//----------------------------//
program ComputePredict, eclass
	syntax , preopt(string)		///
		typeb(string)		///
		touse(string)		///
		varlist(string)		///
		[typlist(string) 	///
		var_lb(string) 		///
		is_offset(string)]

	tempvar yhat
	qui gen `typlist' `yhat' = .
	
	mata : lasso_predict(	///
		`"`yhat'"',	///
		`"`preopt'"',	///
		`"`typeb'"',	///
		`"`touse'"',	///
		`is_offset')
						//  copy to the target var
	qui gen `typlist' `varlist' = `yhat' if `touse'
	label var `varlist' `"`var_lb'"'
end
					//----------------------------//
					// parse offset
					//----------------------------//
program ParseOffset, sclass
	syntax [, nooffset preopt(string)]

	if (`"`offset'"' == "nooffset") {
		local is_offset = 0
	}
	else {
		local is_offset = 1
	}

	if (`"`preopt'"' == "ir") {
		local is_offset = 0
	}

	sret local is_offset = `is_offset'
end
