*! version 1.3.0  16mar2018
program _me_display
	version 13

	local is_st = "`e(cmd2)'"=="mestreg" | "`e(cmd2)'"=="xtstreg"
	if `is_st' local steform noHR TRatio
	if "`e(cmd2)'"!="xtstreg" local table "noTABle"

	syntax [, NOLOg LOg noHEADer noGRoup grouponly grouptable ///
		`table' mi or irr eform EFORM1(string) `steform' ///
		noESTimate 					///
		noDISplay 					///  UNDOC
		noLRtest					///  UNDOC
		* ]

	if "`or'"!="" {
		if !inlist("`e(model)'","logistic","ologit") | `is_st' {
			di "{err}option {bf:or} not allowed"
			exit 198
		}
	}
	if "`irr'"!="" {
		if !inlist("`e(model)'","nbinomial","Poisson") | `is_st' {
			di "{err}option {bf:irr} not allowed"
			exit 198
		}
	}

	if "`display'"!="" {
		local header noheader
		local table notable
		local lrtest nolrtest
		local group nogroup
	}
	
	if "`irr'"!="" local irr irr
	if "`or'"!="" local or or
	if `"`eform1'"'!="" local eform eform(`eform1')
	if `is_st' {
		_st_eform, `hr' `tratio' eform(`eform'`eform1')
		local eform `s(steform)'
	}

	_get_diopts diopts, `options'
	if e(estimates) == 0 | "`estimate'" == "noestimate" {
		local coefl coeflegend selegend
		local coefl : list diopts & coefl
		if `"`coefl'"' == "" {
			local diopts `diopts' coeflegend
		}
	}

	if "`e(prefix)'" != "" {
		_prefix_display, `header' `table' `or' `irr' `eform' `diopts'
		exit
	}
	if "`header'" == "" 	_header, `group' `grouponly' `grouptable'
	if "`grouponly'`grouptable'" != "" {
		exit
	}
	if "`table'" == "" {
		_prefix_display, noheader nofootnote `or' `irr' `eform' `diopts'
		local lsizeopt linesize(`s(width)')
	}
	if "`lrtest'"=="" 	_LR_test
	if "`table'" == "" {
		_prefix_footnote, `lsizeopt'
	}
	
end

program _header

	syntax [, noGRoup grouponly grouptable mi ]
	
	if "`e(cmd2)'"=="meglm" local flink 1
	else local flink 0
	
	if "`grouponly'" != "" {
		if "`e(ivars)'" == "" {
			di "{err}{p 0 4 2}model is `e(model)' regression; "
			di "no group information available{p_end}"
			exit 459
		}
		// alternatively, you can use _me_group_table
		_group_table, table `mi'
		exit
	}
	
	if "`grouptable'" != "" {
		if "`e(ivars)'" == "" {
			di "{err}{p 0 4 2}model is `e(model)' regression; "
			di "no group information available{p_end}"
			exit 459
		}
		// alternatively, you can use _me_group_table
		_group_table, table `mi'
		exit
	}
	
	di
	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
                */ bsubstr(`"`e(crittype)'"',2,.)
	
	di "{txt}`e(title)'" _c
	di _col(49) "{txt}Number of obs" _col(67) "={res}" _col(69) %10.0gc e(N)

	if inlist("`e(cmd2)'","metobit","meintreg") { 
		_censobs_header 67
	}

	if `flink' {
		local family `e(family)'
		if inlist("`family'","gaussian","bernoulli","poisson") {
			local family = proper("`family'")
		}
		if "`family'"=="nbinomial" local family "negative binomial"
		local col1 = 32 - length("`family'")
		di "{txt}Family: " _col(`col1') "{res}`family'"
		
		local link `e(link)'
		if "`link'"=="cloglog" local link "complementary log-log"
		local col1 = 32 - length("`link'")
		di "{txt}Link: " _col(`col1') "{res}`link'"
	}
	
	if "`e(binomial)'" != "" {
		local bin `e(binomial)'
		cap confirm number `bin'
		if _rc {
			local abbr = abbrev("`bin'",12)
			local col1 = 32 - length("`abbr'")
			di "{txt}Binomial variable: " _col(`col1') "{res}`abbr'"
		}
		else {
			local col1 = 32 - length("`bin'")
			di "{txt}Binomial trials: " _col(`col1') %9.0g "{res}`bin'"
		}
	}
	if "`e(dispersion)'" != "" {
		local col1 = 32 - length("`e(dispersion)'")
		di "{txt}Overdispersion: " _col(`col1') "{res}`e(dispersion)'"
	}
	
	local intm `e(intmethod)'
	if "`intm'"=="laplace" local intp 0
	else local intp `e(n_quad)'
		
	if "`group'" == "" {
		// alternatively, you can use _me_group_table
 		_group_table, `mi'
		*di
	}
	else di
	
	local col1 = 32 - length("`intm'")
	local col2 = 79 - length("`e(n_quad)'")
	
	if e(k_r) {
		if `intp' {
			di "{txt}Integration method: " 		///
				_col(`col1') "{res}`intm'" _c
			di _col(49) "{txt}Integration pts." _col(67) "=" ///
				_col(`col2') "{res}`e(n_quad)'"
		}
		else di "{txt}Integration method: " _col(`col1') "{res}`intm'"
	}
		
	di
	if !e(estimates) {
		exit
	}
	di _col(49) "{txt}`e(chi2type)' chi2({res}`e(df_m)'{txt})" ///
		_col(67) "={res}" _col(70) %9.2f e(chi2)
	di "{txt}`crtype'" " = {res}" %10.0g e(ll) ///
		_col(49) "{txt}Prob > chi2" _col(67) "={res}" _col(73) ///
		%6.4f chiprob(e(df_m), e(chi2))
end

program _group_table
	
	if !e(k_r) {
		exit
	}
	
	syntax [, table mi]
	
	local ivars `e(ivars)'
	local levels : list uniq ivars
	tempname Ng min avg max
	if ("`e(cmd)'"=="mi estimate" | "`mi'"!="") {
		local sfx _mi
	}
	mat `Ng' = e(N_g`sfx')
	mat `min' = e(g_min`sfx')
	mat `avg' = e(g_avg`sfx')
	mat `max' = e(g_max`sfx')
	local w : word count `levels'
	if `w' == 0 {
		exit
	}
	
	if `w' == 1 & "`table'" == "" {
		local abbr = abbrev("`levels'",14)
		local col1 = 32 - length("`abbr'")
		
		if inlist("`e(cmd2)'","metobit","meintreg") {
			di
		}
		di "{txt}Group variable: " _col(`col1') "{res}`abbr'"  ///
		     _col(49) "{txt}Number of groups" _col(67) "={res}" ///
		     _col(69) %10.0gc `Ng'[1,1]
		if !inlist("`e(cmd2)'","metobit","meintreg") {
			di
		}
		di _col(49) "{txt}Obs per group:"
		di _col(63) "{txt}min" _col(67) "={res}" ///
		     _col(69) %10.0gc `min'[1,1]
		di _col(63) "{txt}avg" _col(67) "={res}" ///
		     _col(69) %10.1fc `avg'[1,1]
		di _col(63) "{txt}max" _col(67) "={res}" ///
		     _col(69) %10.0gc `max'[1,1] _n
	}
	//         1         2         3         4         5         6
	//123456789012345678901234567890123456789012345678901234567890
	//                    No. of       Observations per Group
	// Group Variable |   Groups    Minimum    Average    Maximum
	//        level1  | ########  #########  #########  #########
	else {
		di
		di "{txt}{hline 16}{c TT}{hline 44}"
		di _col(17) "{txt}{c |}" _col(23) "No. of" ///
		   _col(36) "Observations per Group"
		
		di _col(2) "{txt}Group Variable" _col(17) "{c |}" ///
		   _col(23) "Groups" _col(33) "Minimum" ///
		   _col(44) "Average" _col(55) "Maximum"
		
		di "{txt}{hline 16}{c +}{hline 44}"
		local i 1
		foreach k of local levels {
			local lev = abbrev("`k'",12)
			local p = 16 - length("`lev'")
			di _col(`p') "{res}`lev'" /// 
			   _col(17) "{txt}{c |}{res}" ///
			   _col(21) %8.0gc `Ng'[1,`i'] ///
			   _col(31) %9.0gc `min'[1,`i'] ///
			   _col(42) %9.1fc `avg'[1,`i'] ///
			   _col(53) %9.0gc `max'[1,`i']
			local ++i
		}
		di "{txt}{hline 16}{c BT}{hline 44}"
		di
	}
end

program _LR_test, sclass
	// skip LR test if certain conditions are met
	if !e(k_r) | "`e(vce)'"!="oim" | e(has_cns) | !e(estimates) {
		exit
	}
	if !e(converged) {
		exit
	}
	_lrtest_note_me, msg("LR test vs. `e(model)' model")
	local conserve `s(conserve)'
	if "`conserve'" != "" {
		di _n "{txt}{p 0 6 4 79}Note: "	///
			"{help j_mixedlr##|_new:LR test is conservative} " ///
			"and provided only for reference.{p_end}"
		sreturn local note note
	}
end

program _st_eform, sclass

	syntax [, noHR TRatio eform(string) ]
	
	if !missing(`"`eform'"') {
		di "{err}option {bf:eform} not allowed"
		exit 198
	}
	
	local t1 = inlist("`e(family)'","weibull","exponential")
	local t2 = "`e(frm2)'"=="time"

	if `t1' {
		if `t2' {
			if "`hr'"=="nohr" {
				di "{err}option {bf:nohr} not allowed"
				exit 198
			}
			if "`hr'"=="" local eform
			if "`tratio'"!="" local eform eform(Time Ratio)
		}
		else {
			if "`hr'"=="nohr" local eform
			if "`hr'"=="" local eform eform(Haz. Ratio)
			if "`tratio'"!="" {
				di "{err}option {bf:tratio} not allowed"
				exit 198
			}
		}
	}
	else {
		if "`hr'"=="nohr" {
			di "{err}option {bf:nohr} not allowed"
			exit 198
		}
		if "`tratio'"!="" local eform eform(Time Ratio)
	}
	
	sreturn local steform `eform'

end

exit
