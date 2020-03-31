*! version 1.1.0  01oct2018
program spivregress, sortpreserve eclass
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
	syntax [,*]
	if `"`e(cmd)'"' != "spivregress" {
		di as error "results for {bf:spivregress} not found"
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
					//-- Estimate --/
program Estimate, eclass
	cap noi _spivreg `0'	
	if (_rc) exit _rc
	
	eret local estat_cmd spivregress_estat
	eret local predict spivregress_p
	eret local cmdline spivregress `0'
	eret local estimator gs2sls
	eret local marginsok RForm xb direct indirect
	eret local marginsnotok LImited FULL NAive
	eret local cmd spivregress
	Display `0'
end
					//-- Footnote --//
program Footnote
	footnote_sptest
	footnote_inst
end
					//-- Footnote Spatial test --//
program footnote_sptest
	if (`"`e(lag_list_full)'"'!="")  {
        	di in gr  "Wald test of spatial terms:" 		///
			_col(38) "chi2(" in ye `e(df_c)' in gr ") = "	///
			in ye %-8.2f e(chi2_c)				///
			_col(59) in gr "Prob > chi2 = " in ye %6.4f e(p_c)
	}
end
					//-- Footnote about e(inst) --//
program footnote_inst
	if (`"`e(instd)'"' == "") {
		di as text "(no endogenous regressors)"
		exit
		// NotReached
	}

	 // all colored as {text} as ivregress
	local instd `e(instd)'
	local inst `e(inst)'

	foreach var of local instd {
		_ms_parse_parts `var'
		local omit = r(omit)
		if (!`omit') {
			local instd1 `instd1' `var'	
		}
	}

	foreach var of local inst {
		_ms_parse_parts `var'
		local omit = r(omit)
		if (!`omit') {
			local inst1 `inst1' `var'	
		}
	}

	di as smcl "{p2colset 0 19 19 2}{...}"
	di as smcl "{text}{p2col: Instrumented:}`instd1'{p_end}" 
	di as smcl "{text}{p2col: Raw instruments:}`inst1'{p_end}"
	di as smcl "{p2colreset}{...}"
end
