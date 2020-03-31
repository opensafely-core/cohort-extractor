*! version 1.0.5  17jun2019
/*
	_lassogph_common_parse parses some common options in 
		_lassogph_coeff, _lassogph_nonzero, _lassogph_cv
*/
program _lassogph_common_parse, sclass
	version 16.0

	syntax [name]			///
		[, touse(passthru)	///
		i(passthru)		///
		legend(passthru)	///
		note(passthru) drawcv]	
	sreturn clear
						//  parse xvar	
	ParseXvar `namelist'
	sret local xvar `s(xvar)'
						//  restrict sample
	ParseTouse , `touse' `i'
	sret local iff_enp `s(iff_enp)'
	sret local iff `s(iff)'
						//  parse legend
	ParseLegend , `legend'
	sret local legend `s(legend)'
						//  parse note
	ParseNote , `note' `i' `drawcv'
	sret local note `s(note)'
	sret local snote `s(snote)'
end
					//----------------------------//
					// parse note
					//----------------------------//
program ParseNote, sclass
	syntax , [note(passthru)	///
		i(string) drawcv]
	if (`"`note'"'== "note(__off)") {
		sret local note note()
		exit
	}
	if (`"`note'"' != "") {
		sret local note `note'
		exit
		// NotReached
	}
	
	if (`"`i'"'!="") {
		local enp : char _dta[enp`i']
	}
	else {
		local enp = e(alpha_sel)
	}

	local snote
	local sel_idx = e(sel_idx)
	if `enp'== e(alpha_cv) & "`drawcv'" == "" {
		if "`e(sel_crit_orig)'" == "CV min." {
			local note ///
			note(`"{&alpha}{sub:CV} Cross-validation minimum alpha.  {&alpha}=`enp'"')
		}
		else if "`e(sel_crit_orig)'" == "stop" {
			local note ///
			note(`"{&alpha}{sub:stop}  Stopping tolerance reached.  {&alpha}=`enp'"')
			local snote snote
		}
		else if "`e(sel_crit_orig)'" == "grid min." {
			local note ///
			note(`"{&alpha}{sub:gmin}  Grid minimum reached.  {&alpha}=`enp'"')
			local snote snote
		}
		else {
			local note ///
			note(`"{&alpha}{sub:CV}  Cross-validation minimum alpha.  {&alpha}=`enp'"')
		}			
	}
	else if `enp'== e(alpha_cv) & "`drawcv'" != "" {
		if "`e(sel_crit_orig)'" == "CV min." {
			local note ///
			note(`"{&alpha}{sub:CV}  Cross-validation minimum alpha.  {&alpha}=`enp'"')
		}
		else if "`e(sel_crit_orig)'" == "stop" {
			local note ///
			note(`"{&alpha}{sub:stop}  Stopping tolerance reached.  {&alpha}=`enp'"')
			local snote snote
		}
		else if "`e(sel_crit_orig)'" == "grid min." {
			local note ///
			note(`"{&alpha}{sub:gmin}  Grid minimum reached.  {&alpha}=`enp'"')
			local snote snote
		}
		else {
			local note ///
			note(`"{&alpha}{sub:CV}  Cross-validation minimum alpha.  {&alpha}=`enp'"')
		}			
	}
	else if `enp' == e(alpha_sel) & "`drawcv'" != "" {
		if "`e(sel_crit_orig)'" == "CV min." {
			local note ///
			note(`"{&alpha}{sub:LS}  {bf:lassoselect} specified alpha.  {&alpha}=`enp'"')
		}
		else if "`e(sel_crit_orig)'" == "stop" {
			local note ///
			note(`"{&alpha}{sub:LS}   {bf:lassoselect} specified alpha.  {&alpha}=`enp'"')
		}
		else if "`e(sel_crit_orig)'" == "grid min." {
			local note ///
			note(`"{&alpha}{sub:LS}   {bf:lassoselect} specified alpha.  {&alpha}=`enp'"')
		}
		else {
			local note ///
			note(`"{&alpha}{sub:LS}  {bf:lassoselect} specified alpha.  {&alpha}=`enp'"')
		}		
	}
	else if `enp' == e(alpha_sel) {
		local note ///
		note(`"{&alpha}{sub:LS}  {bf:lassoselect} specified alpha.  {&alpha}=`enp'"')
	}
	else {
		local note note({&alpha} = `enp')
	}
	if ("`e(cmd)'" != "elasticnet") {
		local note
	}

	sret local note `note'
	sret local snote `snote'
end

					//----------------------------//
					// parse legend
					//----------------------------//
program ParseLegend, sclass
	syntax , [legend(string)]

	if (`"`legend'"' == "" | `"`legend'"' == "_off") {
		local legend legend(off)
	}
	else {
		local legend legend(`legend')
	}

	sret local legend `legend'
end
					//----------------------------//
					// Parse Touse and restrict sample
					//----------------------------//
program ParseTouse, sclass
	syntax , touse(string) [i(string)]
	if (`"`i'"'=="") {
		local enp : char _dta[enp]
		local iff_enp if alpha == `enp'
		local iff if alpha == `enp' & `touse'
	}
	else if (`"`i'"' != "") { 
		local enp : char _dta[enp`i']
		local iff_enp if alpha == `enp'
		local iff if alpha == `enp' & `touse'
	}

	local adaptive = e(adaptive)
	if (`adaptive') {
		local adaptstep = e(adaptstep)
		local iff_adap  step == `adaptstep'
		local iff `iff' & `iff_adap'
		local iff_enp `iff_enp' & `iff_adap'
	}


	sret local iff `iff'
	sret local iff_enp `iff_enp'
end
					//----------------------------//
					// ParseXvar
					//----------------------------//
program ParseXvar, sclass

	cap syntax [varname(default=none numeric)] 
	local rc = _rc

	local xvar `varlist'

	if (`"`xvar'"' == "") {
		local xvar l1norm
	}

	local 0 , `xvar'
	cap syntax , [ 		///
		l1normraw01	///
		l2normraw01	///
		l1normraw	///
		l2normraw	///
		lambda		///
		lnlambda	///
		l1norm		///
		l1norm01	///
		]

	local rc = `rc' + _rc

	local xvar `l1normraw' `l2normraw' `l1normraw01' `l2normraw01'	///
		`lambda' `lnlambda' `l1norm' `l1norm01'	

	local n_xvar : word count `xvar'

	if (`n_xvar' > 1 | `rc' !=0 ) {
		di "{p 0 2 2}"
		di as err "{bf:xvar} allows only one of l1normraw01, "	///
"l2normraw01, l1normraw, l2normraw, lambda, lnlambda, l1norm, or l1norm01"
		di "{p_end}"
		exit 198
	}
	sret local xvar `xvar'
end
