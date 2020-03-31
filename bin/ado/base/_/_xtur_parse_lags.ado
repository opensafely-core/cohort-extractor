*! version 1.0.2  23mar2017

program _xtur_parse_lags, sclass

	args input
	local wc : word count `input'

	if `wc' == 1 {
		capture confirm number `input'
		if _rc == 0 {
			if `input' < 0  | `input' != int(`input') {
				di in smcl as error 		///
				   "{bf:lags()} must be a nonnegative integer"
				exit 198
			}
			sreturn local lags = `input'
			sreturn local lagsel ""
			exit
		}
	}
	gettoken first rest : input
	// Must be aic, bic, hqic, or junk
	local compare = lower("`first'")
	if "`compare'" != "aic" & "`compare'" != "bic" & "`compare'" != "hqic" {
		di in smcl as error `"{bf:lags(`input')} invalid"'
		exit 198
	}
	if "`rest'" != "" {
		capture confirm integer number `rest'
		if _rc {
			di in smcl as error `"{bf:lags(`input')} invalid"'
			exit 198
		}
		else if `rest' < 1 {
			di in smcl as error `"{bf:lags(`input')} invalid"'
			exit 198
		}
		sreturn local lags = `rest'
	}
	else {
		sreturn local lags 1		// default
	}	
	sreturn local lagsel "`compare'"

end
