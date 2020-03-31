*! version 1.1.0  01oct2018
program define spregress, sortpreserve eclass
	version 15.0

	if replay() {
		Playback `0'
	}
	else {
		Estimate `0'
	}
end
					//-- Playback  --//
program Playback
	syntax [, *]
	
	if (`"`e(cmd)'"'!="spregress") {
		di as err "results for {bf:spregress} not found"
		exit 301
	}
	else {
		Display `0'
	}
end
					//-- Display  --//
program Display
	syntax [anything] [if] [in] [,*]
	_get_diopts diopts tmp, `options'

	_coef_table_header
	di
	_coef_table, `diopts' 
	Footnote
	ml_footnote
end
					//-- Estimate --//
program Estimate
	ParseMethod `0'
	local method `s(method)'

	if (`"`method'"' == "ml") {
		_spregress_ml `0'
	}
	else if (`"`method'"'== "gs2sls") {
		_spregress_gs2sls `0'
	}
	else {
		di as error `"{bf:`method'} is not valid estimator"'
		exit 198
	}
	Display `0'
end
					//-- Footnote --//
program Footnote
	if (`"`e(lag_list_full)'"'=="") exit
        di in gr  "Wald test of spatial terms:" 			///
		_col(38) "chi2(" in ye `e(df_c)' in gr ") = " 		///
		in ye %-8.2f e(chi2_c)					///
		_col(59) in gr "Prob > chi2 = " in ye %6.4f e(p_c)
end
					//-- ParseMethod --//
program ParseMethod, sclass
	syntax anything [if] [in]	///
		[, gs2sls		///
		ml			///
		*]
	
	local method `gs2sls' `ml'			
	local n_method : list sizeof method

	if ( `n_method' == 0 ) {
		di as err `"must specify {bf:gs2sls} or {bf:ml}"'
		exit 198
	}
	else if(`n_method' == 2) {
		di as err `"choose only one of {bf:gs2sls} or {bf:ml}"'
		exit 198
	}
	
	sret local method `method'
end
