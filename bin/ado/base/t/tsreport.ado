*! version 1.2.4  10oct2016
program tsreport, rclass sortpreserve
        if _caller() < 13 {
                tsreport_12 `0'
		return add
		exit
        }
	version 13.0
	syntax [varlist(default=none numeric ts)] [if] [in] /*
		*/	[, Detail  	/*
		*/ 	   Casewise 	/*
		*/	   NOPanel	/*	to quietly allow nopanel
		*/	   Panel	/*	default is (no) panel
		*/	]
	
	if "`panel'" != "" & "`nopanel'" != "" {
		di as error "cannot specify both {bf:panel} and {bf:nopanel}"
		exit 198
	}
	
	quietly tsset
	local tsfmt `r(tsfmt)' 
	local timevar `r(timevar)'
	local unit1 `r(unit1)'
	local tdelta `r(tdelta)'
	local panelvar `r(panelvar)'
	capture assert "`panel'`nopanel'" == "" if "`r(panelvar)'" == ""
	if _rc {
		di as error  ///
"must specify panelvar; use {bf:tsset} or {bf:xtset}"
		exit 321
	}
	if ("`panelvar'" != "") {
		local pfmt: format `panelvar'
	}
	if (inlist("`unit1'","c","C") & `tdelta' < 1000) {
		if ("`unit1'"=="c" & "`tsfmt'" == "%tc") { 
			local tsfmt %tcDDmonCCYY_HH:MM:SS.sss
		}
		else if ("`tsfmt'" == "%tc") {
			local tsfmt %tCDDmonCCYY_HH:MM:SS.sss
		}		
	}
	
	marksample touse, novarlist
	tempvar otouse
	qui gen `otouse' = `touse'
	markout `touse' `timevar' `panelvar'

	// original order, for reporting gaps by observation
	tempvar origo
	qui gen `c(obs_t)' `origo' = _n
		
	if ("`varlist'" != "") {
		tokenize `varlist'
		if ("`2'" == "" & "`casewise'" != "") {
			di as error ///
"{bf:casewise} can only be specified with two or more variables"
			exit 198			
		} 
		if ("`casewise'" == "") {
			TsrVarlist `varlist' if `touse', `detail' ///
			`panel'	tsfmt(`tsfmt') timevar(`timevar') ///
			tdelta(`tdelta') panelvar(`panelvar') 	  ///
			pfmt(`pfmt') otouse(`otouse') origo(`origo')
		}
		else {
			TsrVarlistANY `varlist' if `touse', `detail' ///
			`panel' tsfmt(`tsfmt') timevar(`timevar')    ///
			tdelta(`tdelta') panelvar(`panelvar') 	     ///
			pfmt(`pfmt') otouse(`otouse') origo(`origo')
		}	
		return add
	}
	else if ("`casewise'" != "") {
		di as error ///
"{bf:casewise} can only be specified with two or more variables"
		exit 198
	}
	else {
		TsrWork if `touse', `detail' `panel' 		     ///
		tsfmt(`tsfmt') timevar(`timevar') tdelta(`tdelta')   ///
		panelvar(`panelvar') pfmt(`pfmt') origo(`origo')
		return add
	} 
end

program TsrWork, rclass sortpreserve
	syntax [if] [, Detail  	 	/*
		*/     Panel	 	/*
		*/     tsfmt(string) 	/*
		*/     timevar(string) 	/*
		*/     tdelta(string) 	/*
		*/     panelvar(string)	/*
		*/     pfmt(string)     /*
		*/     origo(string)   ]

	marksample touse
	qui count if `touse'
	local tobs = r(N)
	
	tempname tmax tmin
	qui sum `timevar' if `touse'
	scalar `tmax' = r(max)
	scalar `tmin' = r(min)
	
	tempvar gap
	if ("`panelvar'" != "") {
		local pcheck (`panelvar'[_n+1] == `panelvar')
	}
	else {
		local pcheck 1
	}	

	if ("`panel'" == "" & "`panelvar'" != "") {
		qui sum `panelvar' if `touse'
		local ptop = r(max)
		qui gen `gap' = 1 if (F.`touse' != 1 & `touse') & ///
				     !(`timevar' == `tmax' & 	  ///
					`panelvar' == `ptop')		
	}
	else {
		qui gen `gap' = 1 if F.`touse' != 1 & `touse' & ///
			`pcheck' & !missing(`timevar'[_n+1]) &  ///
			 (`timevar' < `tmax')
	}

	qui count if !missing(`gap')
	local ngaps = r(N)	
	
	return scalar end = `tmax'
	return scalar start = `tmin'
	return scalar N_obs = `tobs'
	return scalar N_gaps = `ngaps'	
	
	return local tsfmt `tsfmt'
	return local timevar `timevar'
	return local panelvar `panelvar'

	if ("`detail'" == "" | `ngaps' == 0) {
		DisplayIt, ///
		start(`tmin') end(`tmax')  obs(`tobs') gap(`ngaps') 	 ///
		timevar(`timevar') tsfmt(`tsfmt') panelvar(`panelvar')   ///
		pfmt(`pfmt') `panel'	
		exit
	}
	tempvar order
	qui gen `c(obs_t)' `order' = _n
        sort `touse' `panelvar' `timevar' `order'
	tempvar gaps gape gapobs
	qui gen double `gaps'=`timevar'+`tdelta' if !missing(`gap')

	qui gen double `gape' = `timevar'[_n+1] - `tdelta' if ///
		(!missing(`gap')) & `pcheck'
	tempvar origogaps origogape
	qui gen `c(obs_t)' `origogaps' = `origo' if `gap' == 1
	qui gen `c(obs_t)' `origogape' = `origo'[_n+1] if !missing(`gape')

	qui gen double `gapobs' = (`gape' - `gaps' + `tdelta')/`tdelta' if ///
		!missing(`gap')
	tempname mmat
	mkmat `origogaps' `origogape' `panelvar' `gaps' `gape' `gapobs' ///
		if !missing(`gap'), matrix(`mmat') 
	
	DisplayIt, start(`tmin') end(`tmax')  obs(`tobs') gap(`ngaps') 	    ///
			timevar(`timevar') tsfmt(`tsfmt') table(`mmat')     ///
			panelvar(`panelvar') pfmt(`pfmt') `panel'
		
	local gapnolist ""
	forvalues i = 1/`ngaps' {
		if(`mmat'[`i',1] == `mmat'[`i',2] | `mmat'[`i',2] == .) {
			local ib = `mmat'[`i',1]
		}
		else {
			local ib = `mmat'[`i',1]
			local ib2 = `mmat'[`i',2]
			local ib `ib'--`ib2'
		}
		local gapnolist `gapnolist' "`ib'"
	}	
	
	matrix colnames `mmat' = ///
		ObsBefore ObsAfter `panelvar' StartTime EndTime Obs
	matrix rownames `mmat' = `gapnolist'
	return matrix table = `mmat'	
end


program TsrVarlist, rclass sortpreserve
	syntax varlist(numeric ts) [if], 	/*
		*/	[, Detail  	 	/*
		*/	   Panel	 	/*
		*/	   tsfmt(string) 	/*
		*/	   timevar(string) 	/*
		*/	   tdelta(string) 	/*
		*/	   panelvar(string) 	/*
		*/	   pfmt(string)    	/*
		*/	   otouse(string) 	/*
		*/	   origo(string) ]
	
	
	marksample touse, novarlist

	if ("`detail'" == "") {
		// set up display stuff
	        local fmtwidth = fmtwidth("`tsfmt'")
	        local ffmtwidth = `fmtwidth' + 2
        	local ffmtwidth = max(`ffmtwidth',12)
	        local left = bsubstr("`tsfmt'",2,1) == "-"
	        local llit
	        if (`left') {
	                local llit -
	        }
	        if (`fmtwidth' <= 9) {
        	        if (`left' == 0) {
                	        local padit1 = 12-(`fmtwidth'+1)
	                }
        	        else {
                	        local padit1 = 2
	                }
	        }
        	else {
                	local padit1 1
	        }

		local l = 11
		foreach var of varlist `varlist' {
			local l = max(`l',length("`var'"))
		}
		if ("`c(lstretch)'" == "on") {
			tempname myteb
			.`myteb' = ._tab.new, col(5) lmargin(0)
			.`myteb'.width 13 | `ffmtwidth' `ffmtwidth' 8 8	
			.`myteb'.width_of_table
			local w = s(width)
			local vardispsize = min(`l'+1,13 + c(linesize) -`w')
			local vardispsize = max(13,`vardispsize')
		}
		else {
			local vardispsize = 13
		}
		
		local vc: word count `varlist'
		tempname table
		matrix `table' = J(`vc',4,.)
		// get results from tsreport 
		local j = 1
		foreach var of varlist `varlist' {
			qui TsrWork if `touse' & !missing(`var'), `panel' ///
				tsfmt(`tsfmt') timevar(`timevar') 	  ///
				tdelta(`tdelta') panelvar(`panelvar') 	  ///
				pfmt(`pfmt') origo(`origo')	
			matrix `table'[`j',1] = r(start)
			matrix `table'[`j',2] = r(end)
			matrix `table'[`j',3] = r(N_obs)
			matrix `table'[`j',4] = r(N_gaps)	
			return local var`j' `var'
			return scalar end`j' = r(end)
			return scalar start`j' = r(start)
			return scalar N_obs`j' = r(N_obs)
			return scalar N_gaps`j' = r(N_gaps)
			local j = `j' + 1
		}
		matrix colnames `table' = Start End Obs Gaps
		matrix rownames `table' = `varlist'
		tempname mytab
		.`mytab' = ._tab.new, col(5) lmargin(0)
		.`mytab'.width ///
			`vardispsize' | `ffmtwidth' `ffmtwidth' 9 9
		.`mytab'.pad       . `padit1' `padit1' 1 1
		.`mytab'.strfmt    . . . .  .
		.`mytab'.numfmt    . `tsfmt' `tsfmt'  %8.0fc %8.0fc
		di
		di in smcl as text "Gap summary report"
		.`mytab'.sep, top
		local c1 = `vardispsize' + 1
		local c2 = `vardispsize' + 2*`ffmtwidth' + 7
		di in smcl as text _col(`c1') "{c |}" 			///
				   _col(`c2') "{hline 2}Number of{hline 2}"
		.`mytab'.titlefmt %-8s . . %9s %9s
		.`mytab'.titles "Variable" "Start" "End" "Obs." "Gaps"
		.`mytab'.sep

		local j = 1
		foreach var of varlist `varlist' {
			local avar = abbrev("`var'",`vardispsize'-1)
			.`mytab'.row  ///
				 "`avar'" `table'[`j',1] `table'[`j',2] ///
					  `table'[`j',3] `table'[`j',4]		
			local j = `j' + 1
		}
		.`mytab'.sep, bottom 		
		.`mytab'.width_of_table
		local sw = s(width)
	}
	else {
		local j = 1
		foreach var of varlist `varlist' {
			qui TsrWork if `touse' & !missing(`var'), `panel' ///
				tsfmt(`tsfmt') timevar(`timevar') 	  ///
				tdelta(`tdelta') panelvar(`panelvar') 	  ///
				pfmt(`pfmt') detail origo(`origo')		
			return local var`j' `var'
			tempname end`j' start`j' N_obs`j' N_gaps`j'
			scalar `end`j'' = r(end)
			scalar `start`j'' = r(start)
			scalar `N_obs`j'' = r(N_obs)
			scalar `N_gaps`j'' = r(N_gaps)
			local tablepass
			if (`N_gaps`j'' != 0) {
				tempname table`j'
				matrix `table`j'' = r(table)
				local tablepass `table`j''			
			}
			DisplayIt, var(`var') 	///
				start(`start`j'') end(`end`j'') 	///
				obs(`N_obs`j'') gap(`N_gaps`j'') 	///
				table(`tablepass') timevar(`timevar') 	///
				tsfmt(`tsfmt') panelvar(`panelvar') 	///
				pfmt(`pfmt') `panel'	
				
			return scalar end`j' = `end`j''
			return scalar start`j' = `start`j''
			return scalar N_obs`j' = `N_obs`j''
			return scalar N_gaps`j' = `N_gaps`j''	
			if ("`tablepass'" != "") {
				return matrix table`j' = `table`j''
				local sw = r(width)	
			}				
			local j = `j' + 1
		}
	}
		
	Mvar,  varlist(`varlist') otouse(`otouse') ///
		timevar(`timevar') panelvar(`panelvar') width(`sw')
	return local tsfmt `tsfmt'
	return local timevar `timevar'
        return local panelvar `panelvar'
end	

program TsrVarlistANY, rclass
	syntax varlist(numeric ts) [if] [in],	/*
		*/	[, Detail  	 	/*
		*/	   Panel	 	/*
		*/	   tsfmt(string) 	/*
		*/	   timevar(string) 	/*
		*/	   tdelta(string) 	/*
		*/	   panelvar(string) 	/*
		*/	   pfmt(string)   	/*
		*/	   otouse(string) 	/*
		*/	   origo(string) ]

        marksample touse, novarlist
	// create one variable, and pass it through TsrVarlist
	tempvar passit0 passit 
	tsrevar `varlist', substitute
	qui egen `passit0' = rowmiss(`r(varlist)') 
	qui gen `passit' = 1 if `passit0' == 0
	qui TsrVarlist `passit' if `touse', `detail' `panel'  ///
			tsfmt(`tsfmt') timevar(`timevar')     ///
			tdelta(`tdelta') panelvar(`panelvar') ///
			pfmt(`pfmt') otouse(`otouse') origo(`origo')

	tempname N_gaps N_obs start end table

	scalar `N_gaps' = r(N_gaps1)
	scalar `N_obs' = r(N_obs1)
	scalar `start' = r(start1)
	scalar `end' = r(end1)	
	local tablepass
	if (`N_gaps' != 0 & "`detail'" != "") {
		matrix `table' = r(table1)
		local tablepass `table'
	}
	
	DisplayIt, start(`start') end(`end')  obs(`N_obs') gap(`N_gaps')  ///
		table(`tablepass') timevar(`timevar') tsfmt(`tsfmt') 	  ///
		panelvar(`panelvar') pfmt(`pfmt') var4any(`varlist')	  ///
		`panel'

	return local tsfmt `tsfmt'
	return local timevar `timevar'
        return local panelvar `panelvar'
	return scalar N_gaps = `N_gaps'
	return scalar N_obs = `N_obs'
	return scalar start = `start'
	return scalar end = `end'
	
	local sw
	if !("`detail'" == "" | `N_gaps' == 0) {
		return matrix table = `table'
		local sw = r(width)
	}
	
	Mvar,  varlist(`varlist') otouse(`otouse') ///
		timevar(`timevar') panelvar(`panelvar') width(`sw')
end

program Mvar
	syntax, varlist(string) otouse(string) timevar(string) ///
		[panelvar(string) width(string)]
	if ("`width'" == "") {
		local width 0
	}
        local mvar
        local mvc = 0
        foreach var of varlist `varlist' {
                qui count if missing(`timevar') & (!missing(`var') & `otouse')
                if (r(N) > 0) {
                        local mvar `mvar', `var'
                        local lastvar `var'
                        local mvc = `mvc' + 1
                }
        }
        local mvar = subinstr("`mvar'",", ","",1)
        if (`mvc' == 2) {
                local mvar = subinstr("`mvar'",", ", " and ",1)
        }
        else if (`mvc' > 0) {
                local mvar=subinstr("`mvar'",", `lastvar'",", and `lastvar'",1)
        }
        if ("`mvar'" != "") {
                di ///
		"{txt}{p 0 6 0 `width'}Note: There are observations on `mvar'"
                di "for which `timevar' is missing{p_end}"
        }
        local mvar
        local mvc = 0
        foreach var of varlist `varlist' {
                qui count if missing(`panelvar') & (!missing(`var') & `otouse')
                if (r(N) > 0) {
                        local mvar `mvar', `var'
                        local lastvar `var'
                        local mvc = `mvc' + 1
                }
        }
        local mvar = subinstr("`mvar'",", ","",1)
        if (`mvc' == 2) {
                local mvar = subinstr("`mvar'",", ", " and ",1)
        }
        else if (`mvc' > 0) {
                local mvar=subinstr("`mvar'",", `lastvar'",", and `lastvar'",1)
        }
        if ("`mvar'" != "") {
                di ///
		"{txt}{p 0 6 0 `width'}Note: There are observations on `mvar'"
                di "for which `panelvar' is missing{p_end}"
        }	
end			

program DisplayIt, rclass
	syntax, start(string) end(string) obs(string)  			///
		gap(string) timevar(string) tsfmt(string) 		///
		[var(string) table(string) panel			///
		panelvar(string) pfmt(string) var4any(varlist ts)] 	
	
	local left = bsubstr("`tsfmt'",2,1) == "-"
	local llit
	if (`left') {
		local llit -
	}

	di 
	if ("`var4any'" != "") {
		local mvar 
		local mvc = 0
		local maxvarlength = 0
		foreach var of varlist `var4any' {
			local mvar `mvar', `var'
			local lastvar `var'
			local mvc = `mvc' + 1
			local maxvarlength = max(`maxvarlength', ///
						 length("`var'"))
		}
		local mvar = subinstr("`mvar'",", ","",1)
		if (`mvc' == 2) {
			local mvar = subinstr("`mvar'",", ", " and ",1)	
		}
		else if (`mvc' > 0) {
			local mvar = ///
				subinstr("`mvar'",", `lastvar'", ///
				", and `lastvar'",1)
		}
	}
	local fmtwidth = fmtwidth("`tsfmt'")
	local obseq = `obs'
	local digits = length("`obseq'")+2
	local digits = max(4,`digits')
	local llength = max(	length("Variable:         `var'"), 	 ///
				length("Panel variable:   `panelvar'"),  ///
				length("Time variable:    `timevar'"),	 ///
				length("Starting period = ")+`fmtwidth', ///
				length("Observations    = `obseq'"))
	if ("`var4any'" != "") {
		//Variables + maximum variable length + comma
		local llength = max(`llength',length("Variables:        ") ///
					+`maxvarlength'+1)
		di "{p 0 18 0 `llength'}{txt}Variables:{space 8}`mvar'{p_end}"
	}
	if ("`var'" != "") {
		di "{txt}Variable:         {res}`var'"
	}
	if ("`panelvar'" != "") {
		di "{txt}Panel variable:   {res}`panelvar'"
	}
	di "{txt}Time variable:    {res}`timevar'"
	
	// now draw dividing line
        di as text "{hline `llength'}"				 	
	di "{txt}Starting period = " as result `tsfmt' `start'
	di "{txt}Ending period   = " as result `tsfmt' `end'
	
	if (`fmtwidth' > `digits') {
		local digits = `fmtwidth'
		di "{txt}Observations    = " as result %`llit'`digits'.0fc `obs'
		di "{txt}Number of gaps  = " as result %`llit'`digits'.0fc `gap'		
	}
	else {
		di "{txt}Observations    = " as result `obs'
		di "{txt}Number of gaps  = " as result `gap'		
	}
	if "`panel'" == "" & "`panelvar'" != "" {
		di "{txt}(Gap count includes panel changes)"
	}
	if ("`table'" == "") {
		exit
	}
	
		di 
	
	local ffmtwidth = max(`fmtwidth' + 2,12)
        local gapdispsize = 13
	tempname gaptentative
	scalar `gaptentative' = .
	mata: st_numscalar("`gaptentative'",max((`gapdispsize' \	///
		(strlen(subinstr(strofreal(st_matrix("`table'")[,1],	///
			"%30.0f")," ","")):+ 2:+			///
		strlen(subinstr(strofreal(st_matrix("`table'")[,2],	///
			"%30.0f")," ","")):+1))))
	local gapdispsize = `gaptentative'
	if (`fmtwidth' <= 9) {
		if (`left' == 0) {
			local padit1 = 12-(`fmtwidth'+1)
		}
		else {
			local padit1 = 2
		}
	}
	else {
		local padit1 1
	}
	
	
        tempname mytab
	if ("`panelvar'" == "") {
		.`mytab' = ._tab.new, col(4) lmargin(0)
		.`mytab'.width  `gapdispsize'  |`ffmtwidth'  `ffmtwidth' 12
		.`mytab'.pad       . `padit1' `padit1'  3 
		.`mytab'.strfmt    %`gapdispsize's . . .
		.`mytab'.numfmt    . `tsfmt' `tsfmt'  %`llit'9.0fc
		di as text "Gap report"
		.`mytab'.sep, top
		.`mytab'.titlefmt %-`gapdispsize's . . %12s 
		.`mytab'.titles "Obs." "Start" "End" "N. Obs."
		.`mytab'.sep
		local ngaps = `gap'
		forvalues i = 1/`ngaps' {
			if(`table'[`i',1] == `table'[`i',2] | ///
				`table'[`i',2]== .) {
				local ib = `table'[`i',1]
				.`mytab'.row "`ib'" ///
					`table'[`i',3] ///
					`table'[`i',4] ///
					`table'[`i',5]
			}
			else {
				local ib = `table'[`i',1]
 				local ib2 = `table'[`i',2]
				local a =`gapdispsize' - ///
					length(`"`ib'--`ib2'"') 
				local ib= "{space `a'}`ib'{hline 2}`ib2'"
				.`mytab'.row "`ib'" ///
					`table'[`i',3] ///
					`table'[`i',4] ///
					`table'[`i',5]
			}
		}
		.`mytab'.sep, bottom 
	}
	else {
		local apanelvar = abbrev("`panelvar'",9)
		local pleft = bsubstr("`pfmt'",2,1) == "-"
		local pllit
		if (`pleft') {
			local pllit -
		}
		local pfmtwidth = fmtwidth("`pfmt'")
		local ppfmtwidth = max(`pfmtwidth'+2,12)
		if (`pfmtwidth' <= 9) {
			if (`left' == 0) {
				local padit2 = 12-(`pfmtwidth'+1)
			}	
			else {
				local padit2 = 2
			}
		}
		else {
			local padit2 1
		}		
		
		.`mytab' = ._tab.new, col(5) lmargin(0)
		.`mytab'.width  `gapdispsize' | ///
			`ppfmtwidth' `ffmtwidth' `ffmtwidth' 12
		// adjust gapdispsize as necessary
		local wtab = `.`mytab'.width_of_table'
		if (`wtab' > c(linesize)) {
			local gapdispsize = min(`gapdispsize' - ///
				(`wtab' - c(linesize)),6)
			if (`gapdispsize' < 2) {
				//table will just be long
				local gapdispsize 6
			}
		}
		.`mytab'.width  `gapdispsize' | ///
			`ppfmtwidth' `ffmtwidth' `ffmtwidth' 12
			
		.`mytab'.pad       . `padit2' `padit1' `padit1'  3 
		.`mytab'.strfmt    %`gapdispsize's . . . .
		.`mytab'.numfmt    . `pfmt' `tsfmt' `tsfmt'  %`llit'9.0fc
		di as text "Gap report"
		.`mytab'.sep, top
		.`mytab'.titlefmt %-`gapdispsize's . . . %12s
		.`mytab'.titles "Obs." "`apanelvar'" "Start" "End" "N. Obs."
		.`mytab'.sep
		local ngaps = `gap'
		forvalues i = 1/`ngaps' {
			if(`table'[`i',1] == `table'[`i',2] | ///
				`table'[`i',2] == .) {
				local ib = `table'[`i',1]
				.`mytab'.row "`ib'" ///
					`table'[`i',3] ///
					`table'[`i',4] ///
					`table'[`i',5] ///
					`table'[`i',6]
			}
			else {
				local ib = `table'[`i',1]
 				local ib2 = `table'[`i',2]
				local a = `gapdispsize' - ///
					length(`"`ib'--`ib2'"')
				local ib= "{space `a'}`ib'{hline 2}`ib2'"
				.`mytab'.row "`ib'" ///
					`table'[`i',3] ///
					`table'[`i',4] ///
					`table'[`i',5] ///
				 	`table'[`i',6]	
			}
		}
		.`mytab'.sep, bottom 	
	}
	.`mytab'.width_of_table
	return local width = s(width)
end	
