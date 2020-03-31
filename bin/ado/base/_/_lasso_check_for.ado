*! version 1.0.2  16jul2019
					//----------------------------//
					// Check For
					//----------------------------//
program _lasso_check_for
	version  16.0

	syntax , estat_cmd(string)	///
		[for(string)		///
		xfold(string)		///
		resample(string) ]
	
	local cmd `e(cmd)'

	if (`"`cmd'"' == "dsregress" 		|	///
		`"`cmd'"' == "dslogit"   	|	///
		`"`cmd'"' == "dspoisson" 	|	///
		`"`cmd'"' == "poregress" 	|	///
		`"`cmd'"' == "poivregress" 	|	///
		`"`cmd'"' == "pologit" 		|	///
		`"`cmd'"' == "popoisson" ) {

		if (`"`for'"' == "" 		| 	///
			`"`xfold'"' != "" 	|	///
			`"`resample'"' != "") {
			di as err "invalid syntax"
			di "{p 4 4 2}"
			di as err "Syntax is {bf:`estat_cmd', "	///
				"for({it:varname})}"
			di "{p_end}"
			exit 198
		}

	}
	else if (`"`cmd'"' == "xporegress" 	|	///
		`"`cmd'"' == "xpoivregress" 	|	///
		`"`cmd'"' == "xpologit" 	|	///
		`"`cmd'"' == "xpopoisson" ) {
		if (e(n_resample) ==1 & 			///
			(`"`for'"' == "" | 		///
			`"`xfold'"' == "" |		///
			`"`resample'"' !="") ) {
			di as err "invalid syntax"
			di "{p 4 4 2}"
			di as err "Syntax is {bf:`estat_cmd', "	///
				"for({it:varname}) xfold({it:#})}"
			di "{p_end}"
			exit 198
		}
		else if (e(n_resample) !=1 & 		///
			(`"`for'"' == "" | 		///
			`"`xfold'"' == "" |		///
			`"`resample'"' =="") ) {
			di as err "invalid syntax"
			di "{p 4 4 2}"
			di as err "Syntax is {bf:`estat_cmd', "		///
				"for({it:varname}) xfold({it:#}) "	///
				"resample({it:#})}"
			di "{p_end}"
			exit 198
		}
	}
	else if (`"`for'"' != "" | 		///
			`"`xfold'"' != "" |	///
			`"`resample'"' !="") {
		if "`for'" != "" {
			di as error "option {bf:for()} not allowed"
			exit 198
		}
		if "`for'" != "" {
			di as error "option {bf:xfold()} not allowed"
			exit 198
		}
		if "`resample'" != "" {
			di as error "option {bf:resample()} not allowed"
			exit 198
		}
	}
end

