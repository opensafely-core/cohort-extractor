*! version 1.0.4  05apr2017
program _estat_moran, sortpreserve
	
	ComputeMoranI `0'
	Display
end
					//--  compute moran I --//
program ComputeMoranI, rclass

	syntax [, *]		// options are repeatable ERRorlag(string)
	
	_get_diopts diopts opts, `options'
						// get id
	__sp_parse_id
	local id `s(id)'
						// touse
	tempvar touse
	qui gen `touse' = e(sample)
						// parse errorlag
	ParseErrorlag,	id(`id') touse(`touse') `opts'
	local elmat_list `s(elmat_list)'
	local opts `s(opts)'
						// Check elmat_list
	CheckElmat, elmat_list(`elmat_list')
						// Check Extra options
	CheckExtraOptions, `opts'
						// compute predicted error
	tempvar u 
	PredictError , u(`u')  touse(`touse')
						// resort the data to match id
						// in errorlag
	_spreg_match_id , id(`id') touse(`touse') lag_list(`elmat_list')

						// compute moran I test
	mata : __estat_moran(		///
		"`u'", 			///
		`"`touse'"', 		///
		`"`elmat_list'"')
end
					//-- ParseErrorlag --//
program ParseErrorlag, sclass
	syntax , id(string) 		///
		[ERRorlag(string)	///
		elmat_list(string)	///
		touse(string)		///
		*]

	if (!ustrregexm(`"`options'"', "errorlag\((.*)\)")) {
		ParseOneErrorlag,			///
			id(`id')	 		///
			errorlag(`errorlag')		///
			touse(`touse')			///
			elmat_list(`elmat_list')
		local elmat_list `s(elmat_list)'

		local elmat_list : list uniq elmat_list
		sret local elmat_list `elmat_list'
		sret local opts `options'
	}
	else {
		ParseOneErrorlag,			///
			id(`id')			///
			errorlag(`errorlag')		///
			touse(`touse')			///
			elmat_list(`elmat_list')	
		local elmat_list `s(elmat_list)'

		ParseErrorlag,				///
			id(`id')			///
			elmat_list(`elmat_list')	///
			touse(`touse')			///
			`options'
	}
end

					//-- CheckExtraOptions --//
program CheckExtraOptions
	syntax [, *]
	if (`"`options'"'!="") {
		di as error "option {bf:`options'} not allowed"
		exit(198)
	}
end
					//-- Parse One Errorlag  --//
program ParseOneErrorlag, sclass
	sret clear
	syntax , id(string) 		///
		touse(string)		///
		[ ERRorlag(string) 	///
		elmat_list(string)	///
		]
	
	if (`"`errorlag'"'=="") {
		sret local elmat_list `elmat_list'	
		exit
	}

	gettoken errorlag tmp : errorlag, parse(",")	
	if (`"`tmp'"'!="") {
		di as err "option {bf:errorlag()} does not allow options"
		exit(198)
	}

	local n_errorlag : word count `errorlag'
	if (`n_errorlag' > 1) {
		di as err "option {bf:errorlag()} allows only " ///
			  "one weighting matrix"
		exit(198)
	}

	local elmat_list `elmat_list' `errorlag' 
	sret local elmat_list `elmat_list'
end
					//--  PredictError --//
program PredictError
	syntax [, u(string) touse(string) ]

	tempvar yp
	qui predict double `yp'
	local y `e(depvar)'

	qui gen double `u' = `y' - `yp'
end
					//-- CheckElmat --//
program CheckElmat
	syntax [, elmat_list(string)]

	local n_elmat : word count `elmat_list'

	if (`n_elmat' < 1) {
		di as error "option {bf:errorlag()} required" 
		exit 198
	}
end
					//-- Display --//
program Display
	
	di 
	di as txt "Moran test for spatial dependence"
	di as txt _col(10) "Ho: error is i.i.d. "
	di as txt _col(10) "Errorlags: {bf : `r(elmat)'}"
	di 
	di as txt _col(10) "chi2(" as res r(df)	///
		as txt ")" _col(23) "=" as res %9.2f r(chi2)
	di as txt _col(10) "Prob > chi2" _col(23) "="	///
		as res %9.4f r(p)

end
