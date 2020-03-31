*! version 1.0.2  27mar2017
program _spreg_sample_message
	version 15.0
	syntax , n_data(string)		///
		n_excluded(string)	///
		n_missing(string)	///
		n_esample(string)	///
		[ n_spmat(string)	///
		lag_list(string) 	///
		force]
						// n_data
	Msg_N_data, n_data(`n_data')
						// n_excluded
	Msg_N_excluded, n_excluded(`n_excluded')
						// n_missing
	Msg_N_missing, n_missing(`n_missing')
						// n_esample
	Msg_N_esample, n_esample(`n_esample')
						// n_spmat
	Msg_N_spmat, lag_list(`lag_list')	///
		n_spmat(`n_spmat')
						// Check n_spmat < n_esample
	Check_spmat_LE_esample, 		///
		n_spmat(`n_spmat') 		///
		n_esample(`n_esample')		///
		lag_list(`lag_list')
						// Check n_spmat > n_esample	
	if (`"`force'"'=="") {
		Check_spmat_GE_esample,		///
			n_spmat(`n_spmat') 	///
			n_esample(`n_esample')	///
			lag_list(`lag_list')
	}
end

					//-- Msg_N_data --//
program Msg_N_data
	syntax, n_data(string)
						// n_data
	if (`n_data' == 1) {
		di as txt _col(3) "(`n_data' observation)"
	}
	else if (`n_data' >1) {
		di as txt _col(3) "(`n_data' observations)"
	}
end
					//-- Msg_N_excluded --//
program Msg_N_excluded
	syntax, n_excluded(string)

	if (`n_excluded'==1) {
		di as txt _col(3)	///
			"(`n_excluded' observation excluded due to if/in)"
	}
	else if (`n_excluded' > 1) {
		di as txt _col(3) 	///
			"(`n_excluded' observations excluded due to if/in)"
	}
end
					//-- Msg_N_missing --//
program Msg_N_missing
	syntax, n_missing(string)

	if (`n_missing'==1) {
		di as txt _col(3)			///
			"(`n_missing' observation "	///
			"excluded due to missing values)"
	}
	else if (`n_missing' > 1) {
		di as txt _col(3)			///
			"(`n_missing' observations "	///
			"excluded due to missing values)"
	}
end
					//-- Msg_N_esample --//
program Msg_N_esample
	syntax, n_esample(string)

	if (`n_esample'==1) {
		di as txt _col(3)			///
			"(`n_esample' observation (places) used)"
	}
	else if (`n_esample'>1) {
		di as txt _col(3)			///
			"(`n_esample' observations (places) used)"
	}
end
					//-- Msg_N_spmat --//
program Msg_N_spmat
	syntax [, lag_list(string)	///
		n_spmat(string)]

	if (`"`lag_list'"'=="") {
		exit	
		// NOT reached
	}

	GetWmat, lag_list(`lag_list')
	local wmat_def `s(wmat_def)'

	di as txt _col(3)  "(`wmat_def' `n_spmat' places)"
end
					//-- Check_spmat_LE_esample --//
program Check_spmat_LE_esample
	syntax [, lag_list(string)	///
		n_spmat(string)]	///
		n_esample(string)

	if (`"`lag_list'"'=="") {
		exit	
		// NOT reached
	}

	GetWmat, lag_list(`lag_list')
	local wmat `s(wmat)'

	if (`n_spmat' < `n_esample') {
		di as err "{p 0 0 2}"
		di as err "estimation sample defines places not in `wmat'"
		di as err "{p_end}"

		di as err "{p 4 4 2}"
		di as err "You must specify if or in to restrict the "	///
			"estimation sample to the places in the "	///
			"`wmat' or use a different `wmat'."
		di as err "{p_end}"
		exit 459
	}
end
					//-- Check_spmat_GE_esample --//
program Check_spmat_GE_esample
	syntax [, lag_list(string)	///
		n_spmat(string)]	///
		n_esample(string)

	if (`"`lag_list'"'=="") {
		exit	
		// NOT reached
	}

	GetWmat, lag_list(`lag_list')
	local wmat_def `s(wmat_def)'

	if (`n_spmat' > `n_esample') {
		di as err "{p 0 0 2}"	
		di as err "`wmat_def' places not in estimation sample"
		di as err "{p_end}"

		di as err "{p 4 4 2}"
		di as err "Excluding observations excludes the "	///
			"spillovers from those observations to "	///
			"other observations which are not excluded. "	///
			"You must determine whether this is appropriate " ///
			"in this case and, if it is, specify option "	///
			"{bf:force}."
		di as err "{p_end}"
		exit 459
	}
end
					//-- GetWmat --//
program GetWmat, sclass
	syntax [, lag_list(string)]

	if (`"`lag_list'"'=="") {
		exit	
		// NOT reached
	}

	local n_lag : word count `lag_list'	
	if (`n_lag' == 1) {
		local wmat "weighting matrix"
		local wmat_def `wmat' defines
	}
	else {
		local wmat "weighting matrices"
		local wmat_def `wmat' define
	}

	sret local wmat `wmat'
	sret local wmat_def `wmat_def'
end
