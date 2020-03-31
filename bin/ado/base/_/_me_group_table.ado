*! version 1.0.3  01nov2018
program _me_group_table
	version 15
	
	if !e(k_r) {
		exit
	}
	
	syntax [, table mi NUMOFFset(integer 49)]
	
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

	local beforegrline = inlist("`e(cmd2)'","metobit","meintreg")
	if "`e(prefix)'" == "bayes" & "`e(nchains)'" != "" {
		if `e(nchains)' > 1 {
			local beforegrline 1
		}
	}

	if `w' == 1 & "`table'" == "" {
		local abbr = abbrev("`levels'",14)
		local col1 = 32 - length("`abbr'")
		// don't offset the group variable name
		local col1 = 16

		if `beforegrline' {
			di
		}
		di "{txt}Group variable: " _col(`col1') "{res}`abbr'"  ///
		     _col(`numoffset') "{txt}Number of groups" _col(67) "={res}" ///
		     _col(69) %10.0gc `Ng'[1,1]
		if !`beforegrline' {
			di
		}
		di _col(`numoffset') "{txt}Obs per group:"
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
