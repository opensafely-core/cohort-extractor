*! version 1.3.20  03dec2018
program varirf_graph, rclass
	version 8.0
	if _caller() < 9 {
		local BYOPTS BYopts(string asis)
	}
	else {
		local BYOPTS  // allow _gs_byopts_combine to parse BYOPts
	}
	syntax [anything(id="statlist" name=statlist)]	///
	[,						///
		IRf(string)				///
		Impulse(string)				///
		Response(string)			///
		noCI					///
		Level(passthru)				///
		LSTep(numlist max=1 integer >=0 <=500)	///
		USTep(numlist max=1 integer >0 <=500)	///
		CILines					///
		PLOT1opts(string asis)			///
		PLOT2opts(string asis)			///
		PLOT3opts(string asis)			///
		PLOT4opts(string asis)			///
		CIOPTS1(string asis)			///
		CIOPTS2(string asis)			///
		CI1opts(string asis)			///
		CI2opts(string asis)			///
		INdividual				///
		ISAving(string asis)			///
		INAME(string)				///
		`BYOPTS'				///
		set(string)				///
		SAVing(passthru)			///
		name(passthru)				///
		*					/// tw_opts
	]

	if `"`BYOPTS'"' == "" {
		_gs_byopts_combine  byopts options : `"`options'"'
	}

	_check4gropts plot1opts, opts(`plot1opts')
	_check4gropts plot2opts, opts(`plot2opts')
	_check4gropts plot3opts, opts(`plot3opts')
	_check4gropts plot4opts, opts(`plot4opts')
	_check4gropts ciopts1, opts(`ciopts1')
	_check4gropts ciopts2, opts(`ciopts2')
	_check4gropts ci1opts, opts(`ci1opts')
	_check4gropts ci2opts, opts(`ci2opts')

	_get_gropts, graphopts(`options')
	local tw_opts `"`s(graphopts)'"'

	// check for syntax errors
	local nstats : word count `statlist'
	if `nstats' > 4 {
		di as err ///
"at most four statistics may be included in one graph"
		exit 103
	}
	if `nstats' < 1 {
		di as err "no statistics specified"
		exit 102
	}
	// check plot options
	forval i = `=`nstats'+1'/4 {
		if `nstats' < `i' {
			if `"`plot`i'opts'"' != "" {
				di as err ///
"option {cmd:plot`i'opts()} is not allowed with only `nstats' statistics"
				exit 198
			}
		}
	}
	if `"`ci'"' == "" {
		if `nstats' > 2 {
			di as err ///
"only two statistics may be included with CIs in one graph"
			exit 198
		}
		if `nstats' == 1 {
			if "`ciopts2'" != "" {
				di as err ///
"option {cmd:ciopts2()} is not allowed with only one statistic"
				exit 198
			}
			if "`ci2opts'" != "" {
				di as err ///
"option {cmd:ci2opts()} is not allowed with only one statistic"
				exit 198
			}
		}
	}
	else {
		if `"`ciopts1'`ciopts2'"' != "" {
			local i = cond(`"`ciopts1'"' != "", 1, 2)
			di as err ///
"options {cmd:noci} and {cmd:ciopts`i'()} may not be combined"
			exit 198
		}
		if `"`ci1opts'`ci2opts'"' != "" {
			local i = cond(`"`ci1opts'"' != "", 1, 2)
			di as err ///
"options {cmd:noci} and {cmd:ci`i'opts()} may not be combined"
			exit 198
		}
		if `"`cilines'"' != "" {
			di as err ///
"options {cmd:noci} and {cmd:cilines} may not be combined"
			exit 198
		}
	}
	// check for duplicates
	if "`: list dups statlist'" != "" {
		di as err "duplicate elements found in statlist: `statlist'"
		exit 198
	}
	if "`: list dups irf'" != "" {
		di as err "duplicate elements found in irf(`irf')"
		exit 198
	}
	if "`: list dups impulse'" != "" {
		di as err "duplicate elements found in impulse(`impulse')"
		exit 198
	}
	if "`: list dups response'" != "" {
		di as err "duplicate elements found in response(`response')"
		exit 198
	}
	if "`e(cmd)'"=="arima" | "`e(cmd)'"=="arfima" {
		local tmp irf cirf oirf coirf sirf
		local out : list statlist | tmp
		local out : list uniq out
		local out : list out - tmp
		if "`out'"!="" {
			di as err "{cmd:`out'} not available after `e(cmd)'"
			exit 198
		}
	}
	if ("`e(cmd)'"=="dsge" | ///
		 ("`e(cmd)'"=="dsgenl" & "`e(solvetype)'"== "firstorder")) {
		local tmp irf
		local out : list statlist | tmp
		local out : list uniq out
		local out : list out - tmp
		if "`out'"!="" {
			di as err "{cmd:`out'} not available after `e(cmd)'"
			exit 198
		}
	}
	// options that may not be combined
	if "`level'" != "" & "`ci'" != "" {
		di as err ///
"options {cmd:level()} and {cmd:noci} may not be combined"
		exit 198
	}
	
	local zero `0'
	local 0 ", `level'"
	local backopt `options'
	syntax [, level(cilevel)]
	local 0 `zero'
	local options `backopt'

	if `"`byopts'"' != "" & "`individual'" != "" {
		di as err ///
"options {cmd:byopts()} and {cmd:individual} may not be combined"
		exit 198
	}
	if `"`name'"' != "" & "`individual'" != "" {
		di as err ///
"options {cmd:name()} and {cmd:individual} may not be combined"
		exit 198
	}
	if `"`saving'"' != "" & "`individual'" != "" {
		di as err ///
"options {cmd:saving()} and {cmd:individual} may not be combined"
		exit 198
	}

	// options that require -individual-
	if `"`individual'"' == "" {
		if "`isaving'" != "" {
			di as err ///
"option {cmd:isaving()} requires the {cmd:individual} option"
			exit 198
		}
		if "`iname'" != "" {
			di as err ///
"option {cmd:iname()} requires the {cmd:individual} option"
			exit 198
		}
	}

	if ("`ci'`level'" == "") local level = c(level)

	// set a new irf data file
	if (`"`set'"' != "") irf set `set'

	// check for currently set irf data file
	if `"$S_vrffile"' == "" {
		di as err "no irf file active"
		exit 198
	}
	
	preserve
	_virf_use `"$S_vrffile"'

	// default for irf() option is all irfnames
	local allirfnames : char _dta[irfnames]
	if ("`irf'" == "") local irf `allirfnames'
	else {
		local bad : list irf - allirfnames
		if `"`bad'"' != "" {
			if (`: word count `bad'' > 1) ///
				local s s
			else	local s
			di as err `"irfname`s' `bad' not found"'
			exit 498
		}
	}
	local myirf `irf'

	qui sum step
	local mstep = r(max)

	if ("`lstep'" == "") local lstep 0
	if ("`ustep'" == "") local ustep `mstep'

	// bad values for *step() options
	if `ustep' < `lstep' {
		di as err "{cmd:ustep()} may not be less than {cmd:lstep()}"
		exit 198
	}

	if ("`cilines'" == "")	///
		local ciplottype rarea
	else	local ciplottype rline

	// build and check the lists of combinations
	foreach irfn of local myirf {
		local allorder : char _dta[`irfn'_order]
		local irfmodel : char _dta[`irfn'_model]

		// default for impulse() option after dsge: all state
		//         variables with shocks attached to them
		if ("`irfmodel'"=="dsge" & "`impulse'" == "") {
			local shocks : char _dta[`irfn'_shocks]
			local myimpulse `shocks'
		}
		// default for impulse() option all of them
		else if ("`impulse'" == "") local myimpulse `allorder'
		else {
			local dmult dm cdm
			local dmult : list dmult & statlist
			if "`dmult'" != "" {
				local fullimp : char _dta[`irfn'_exogvars]
				local fullimp `fullimp' `allorder'
			}
			else {
				local fullimp `allorder'
			}

//			local bad : list impulse - allorder
			local bad : list impulse - fullimp
			if "`bad'" != "" {
				if (`: word count `bad'' > 1) ///
					local s s
				else	local s
				di as err ///
`"impulse`s' `bad' not found in results from `irfn'"'
				exit 498
			}
			local myimpulse `impulse'
		}

		// default for response() option all of them
		if ("`response'" == "") local myresponse `allorder'
		else {
			local bad : list response - allorder
			if "`bad'" != "" {
				if (`:word count `bad'' > 1) ///
					local s s
				else	local s
				di as err ///
`"response`s' `bad' not found in results from `irfn'"'
				exit 498
			}
			local myresponse `response'
		}
		foreach imp of local myimpulse {
			foreach res of local myresponse {
				local irflist `irflist' `irfn'
				local implist `implist' `imp'
				local reslist `reslist' `res'
			}
		}
	}

	local k : word count `irflist'

	local allvec true
	// indicator for which groups of results are to be plotted
	tempname touse
	qui gen byte `touse' = 0
	forval i = 1/`k' {
		local irf : word `i' of `irflist'
		local ckvec : char _dta[`irf'_model]
		if "`ckvec'" != "vec" {
			local allvec false
		}
		local imp : word `i' of `implist'
		local res : word `i' of `reslist'
		qui replace `touse' = 1	///
			if irfname  == "`irf'"	///
			 & impulse  == "`imp'"	///
			 & response == "`res'"
		foreach stat of local statlist {
			qui count if !missing(`stat')		///
				   & irfname  == "`irf'"	///
				   & impulse  == "`imp'"	///
				   & response == "`res'"
			if r(N) == 0 {
				di as txt ///
`"{p 0 4 2}`stat' values are all missing for `irf': `imp' -> `res'{p_end}"'
			}
		}
	}

	if "`allvec'" == "true" local ci noci

	// check for totally missing CIs
	if `"`ci'"' != "noci" {
		local nocibands 1
		foreach var of local statlist {
			qui count if ! missing(std`var') & `touse'
			if (r(N) > 0) local nocibands 0
		}
		if (`nocibands') {
			di as txt ///
"{p 0 4 2}standard errors from all selected results are missing," ///
" cannot compute confidence intervals for the chosen statistics{p_end}"
			local ci noci
		}
	}

	// build the CI plots
	if "`ci'" == "" {

		capture confirm variable stdirf
		if _rc > 0 {
			di as err ///
`"irf file $S_vrffile does not have the correct structure"'
			exit 111
		}	
		foreach tirf of local myirf {
			qui count if stdirf < . & irfname == "`tirf'"
			if r(N) == 0 {
				di as txt ///
"{p 0 4 2}standard errors from irf results `irfname' are missing," ///
" cannot compute confidence intervals for the chosen statistics{p_end}"
			}		
		}
	
		local adj_level = `level'/100 + (100-`level')/200
		local pstyle1 pstyle(ci)
		local pstyle2 pstyle(ci2)
		forval i = 1/`nstats' {
			local var : word `i' of `statlist'
			if (`nstats' > 1) local ylabadd " for `var'"
			
			confirm variable std`var'
			tempvar `var'l `var'u
			qui gen double ///
			``var'l' = `var' - std`var'*invnorm(`adj_level')
			qui gen double ///
			``var'u' = `var' + std`var'*invnorm(`adj_level')

			local ciplot				///
			(`ciplottype' ``var'l' ``var'u' step,	///
				sort				///
				`pstyle`i''			///
				yvarlabel(			///
				`"`=strsubdp("`level'")'% CI`ylabadd'"'	///
				`"`=strsubdp("`level'")'% CI`ylabadd'"'	///
				)				///
				`ciopts`i'' `ci`i'opts'		///
			)
			local ciplots `"`ciplots' `ciplot'"'
		}
	}

	// build the line plots
	forval i = 1/`nstats' {
		local var : word `i' of `statlist'
		confirm variable `var'
		local plot			///
		(line `var' step,		///
			sort			///
			pstyle(p`i'line)	///
			`plot`i'opts'		/// other graph options
		)
		local plots `"`plots' `plot'"'
	}


	if `"`individual'"' == "" {
		BYPARSE , `byopts'
		if (`"`r(iscale)'"' == "") local iscale iscale(*.75)

		graph twoway				///
			`ciplots'			///
			`plots'				///
			if `touse'			///
		 	& step <= `ustep'		///
		 	& step >= `lstep',		///
			by(irfname impulse response,	///
				`byopts'		///
				`iscale'		///
			)				///
			ytitle("")			///
			ylabels(#4,			///
				angle(horizontal)	///
			)				///
			xlabels(#4)			///
			`saving'			///
			`name'				///
			`tw_opts'			///
			// blank
	}
	else {
		ISAPARSE `isaving'
		local istub "`r(stub)'"
		local ireplace "`r(replace)'"
		INAPARSE `iname'
		local instub "`r(stub)'"
		local inreplace "`r(replace)'"

		local name
		local saving
		// plot each combination separately
		forval i = 1/`k' {
			local irf : word `i' of `irflist'
			local imp : word `i' of `implist'
			local res : word `i' of `reslist'
			if `"`istub'"' != "" {
				local saving ///
				`"saving("`istub'`i'", `ireplace')"'
			}
			if `"`instub'"' != "" {
				local name ///
				`"name("`instub'`i'", `inreplace')"'
			}
			local sttl`i' "`irf': `imp' -> `res'"

			graph twoway				///
				`ciplots'			///
				`plots'				///
				if irfname  == "`irf'"		///
			 	 & impulse  == "`imp'"		///
			 	 & response == "`res'",		///
				ytitle("")			///
				ylabels(#4,			///
					grid			///
					gmax			///
					gmin			///
					angle(horizontal)	///
				)				///
				xlabels(#4)			///
				subtitle(			///
					`"`sttl`i''"',		///
					box			///
					bexpand			///
				)				///
				`saving'			///
				`name'				///
				`tw_opts'			///
				// blank
		}

	}

	// saved results
	return scalar k = `k'
	return local stats	`"`statlist'"'
	return local irfname	`"`: list uniq irflist'"'
	return local impulse	`"`: list uniq implist'"'
	return local response	`"`: list uniq reslist'"'
	return local plot1	`"`plot1opts'"'
	return local plot2	`"`plot2opts'"'
	return local plot3	`"`plot3opts'"'
	return local plot4	`"`plot4opts'"'
	return local ciopts1	`"`ciopts1'"'
	return local ciopts2	`"`ciopts2'"'
	return local ci1opts	`"`ci1opts'"'
	return local ci2opts	`"`ci2opts'"'
	return local byopts	`"`byopts'"'
	return hidden local tw_opts	`"`tw_opts'"'
	if `"`individual'"' == "" {
		return local saving		`"`saving'"'
		return local name		`"`name'"'
	}
	else {
		return local individual		`"`individual'"'
		return local isaving		`"`isaving'"'
		return local iname		`"`iname'"'
		forval i = 1/`k' {
			return local subtitle`i' `"`sttl`i''"'
		}
	}

	if "`ci'" == "" {
		return local ci "`level'"
	}
	else {
		return local ci "noci"
	}
end

program ISAPARSE, rclass
	if (`"`0'"' == "") exit
	syntax name(id="filenamestub" name=stub) [, replace]

	local chars = length("`stub'")
	if `chars' > 32 {
		di as err "filenamestub may not have more than 32 characters"
		exit 198
	}
	return local stub `stub'
	return local replace `replace'
end

program INAPARSE, rclass
	if (`"`0'"' == "") exit
	syntax name(id="namestub" name=stub) [, replace]

	local chars = length("`stub'")
	if `chars' > 24 {
		di as err "namestub may not have more than 24 characters"
		exit 198
	}
	return local stub `stub'
	return local replace `replace'
end

program BYPARSE, rclass
	syntax , [ iscale(string asis) * ]

	return local iscale `"`iscale'"'
	return local byopts `"`options'"'
end

exit
