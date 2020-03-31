*! version 1.0.1  16mar2017
program _spmatrix_subset, sclass
	version 15.0

	syntax, id(string)		///
		touse(string)		///
		[lag_list(string) ]	
	
	if (`"`lag_list'"' == "" ) {
		exit
		// NOT reached
	}
						// check spmat
	CheckSpmat, w(`lag_list')
						// get the subset
	foreach old of local lag_list {
		local new `old'_s001	
		capture noi mata : _SPMATRIX_get_subset(	///
			`"`old'"', 				///
			`"`new'"',				///
			`"`id'"',				///
			`"`touse'"')
		if _rc {
			exit _rc
		}
		local new_lag_list `new_lag_list' `new'
	}
	MsgMatched, n_matched(`n_matched') new_lag_list(`new_lag_list')	
	sret local new_lag_list `new_lag_list'
end
						//-- CheckSpmat --//
program CheckSpmat
	syntax [, w(string)] 

	if `"`w'"'=="" { 
		exit(0)
	}
	foreach wi of local w {
		capture mata : _SPMATRIX_assert_object("`wi'")
		if _rc {
			di as err "{bf:`wi'} is not a valid "	///
				"weighting matrix"
			exit 498
		}
	}
end
					//-- MsgMatched --//
program MsgMatched
	syntax [, n_matched(string)	///
		new_lag_list(string)	///
		]
	
	local n_lag : word count `new_lag_list'

	if (`n_lag' ==1) {
		local wmat weighting matrix
	}
	else if (`n_lag' > 1) {
		local wmat weighting matrices
	}

	di "{p 2 2 2}"
	di as txt "(`wmat' matched `n_matched' places in data)"
	di "{p_end}"

	foreach lag of local new_lag_list {
		di "{p 2 2 2}"
		di "{txt} (weighting matrix `lag' created)"
		di "{p_end}"
	}
end
