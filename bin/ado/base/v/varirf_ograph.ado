*! version 1.0.15  23oct2013
program varirf_ograph, rclass
	version 8.0

	local g_options						///
		LSTep(numlist max=1 integer >=0 <=500)		///
		USTep(numlist max=1 integer  >0 <=500)		///
		Level(passthru)					///
		CI						///
		CILines						///
		// blank
	local g_list lstep ustep level ci cilines

	syntax anything(name=pspecs id="graph specification")	///
		[,						///
		`g_options'					///
		set(string)					///
		*						///
		]						///
		// blank

	_get_gropts, graphopts(`options')
	local tw_options `"`s(graphopts)'"'	// -graph twoway- options
	local holdon `0'
	local 0 , `level'
	syntax [, Level(cilevel)]
	local 0 `holdon'

	// set a new irf data file
	if `"`set'"' != "" {
		irf set `set'
	}
	if `"$S_vrffile"' == "" {
		di as err "no irf file active"
		exit 198
	}
	
	preserve
	_virf_use `"$S_vrffile"'
	sort irfname impulse response step

	qui sum step, meanonly
	local max_step = r(max)

	// get/set global values:
	//	lstep
	if `"`lstep'"' != "" {
		local g_lstep `lstep'
	}
	else	local g_lstep 0
	//	ustep
	if `"`ustep'"' != "" {
		local g_ustep `ustep'
	}
	else	local g_ustep `max_step'
	// 	confidence level
	if `"`level'"' == "" {
		local g_level = c(level)
	}
	else	local g_level = `level'
	if `"`ci'"' != "" {
		local g_ci `ci'
	}
	if `"`cilines'"' != "" {
		local g_cilines `cilines'
		local g_ci ci
	}

	local plots 0
	local ciplots 0
	local maxpstyle 15
	while `"`pspecs'"' != "" {
		gettoken 0 pspecs : pspecs , match(parns)

		syntax anything(id="graph specification" name=spec)	///
			[,						///
			NOCI						///
			`g_options'					///
			*						///
			]						///
			// blank

		_get_gropts, graphopts(`options') getallowed(CIOPts)
		local options `"`s(graphopts)'"'
		local ciopts `"`s(ciopts)'"'
		_check4gropts ciopts, opts(`ciopts')

		// check for conflicting options
		if `"`ciopts'"' != "" {
			if `"`noci'"' != "" {
				di as err ///
				"options ciopts() and noci may not be combined"
				exit 198
			}
			local ci ci
		}
		if `"`ci'"' != "" & `"`noci'"' != "" {
			di as err ///
			"options ci and noci may not be combined"
			exit 198
		}
		if `"`cilines'"' != "" {
			if `"`noci'"' != "" {
				di as err ///
				"options cilines and noci may not be combined"
				exit 198
			}
			local ci ci
		}

		if `"`level'"' != "" {
			if `"`noci'"' != "" {
				di as err ///
				"options level() and noci may not be combined"
				exit 198

			}
		}
		local zero `0'
		local 0 ", `level'"
		local backopt `options'
		syntax [, level(cilevel)]
		local 0 `zero'
		local options `backopt'

		// merge in global options
		foreach g_opt of local g_list {
			if `"``g_opt''"' == "" {
				local `g_opt' `g_`g_opt''
			}
		}
		// override global option
		if `"`noci'"' == "noci" {
			local ci noci
		}

		local cumlevel = 0.5 + `level'/200

		CheckSpec `spec'
		if (`s(statmissing)') continue
		
		local ++plots
		if `plots' > `maxpstyle' {
			di as error ///
"too many graph specifications, at most `maxpstyle' specifications are allowed"
			exit 198
		}
		local cnpstyle pstyle(p`plots'line)

		local irfname	`s(irfname)'
		local impulse	`s(impulse)'
		local response	`s(response)'
		local stat	`s(stat)'
				
		local irflist `irflist' `irfname'
		local implist `implist' `impulse'
		local reslist `reslist' `response'
		local stalist `stalist' `stat'

		local graph`plots'			///
		(line `stat' step			///
			if irfname  == "`irfname'" &	///
			   impulse  == "`impulse'" &	///
			   response == "`response'" &	///
			   step >= `lstep' &		///
			   step <= `ustep'		///
			,				///
			\`yttl'				/// defined later
			yvarlabel(`"\`label`plots''"')	///
			`cnpstyle'			///
			`options'			///
		)					///
		//blank

		if `"`ci'"' == "ci" {
			if `"`cilines'"' != "" {
				local cilines recast(rline)
			}
			if `plots' == 1 {
				local cipstyle pstyle(ci)
			}
			else if `plots' == 2 {
				local cipstyle pstyle(ci2)
			}
			else	local cipstyle `cnpstyle'
			capture confirm variable std`stat'
			if _rc {
				di as err ///
`"irf file $S_vrffile does not have the correct structure"'
				exit 111
			}
			qui count if stdirf < . & irfname == "`irfname'"
			if r(N) == 0 {
				di as txt ///
"{p 0 4 2}standard errors from irf results `irfname' are missing," ///
" cannot compute confidence intervals for `stat'{p_end}"
			}
			else {
				local ++ciplots
				tempvar `stat'_l `stat'_u
				local lcl ``stat'_l'
				local ucl ``stat'_u'
				qui gen double				///
				`lcl'=`stat'-std`stat'*invnorm(`cumlevel') ///
					if irfname  == "`irfname'" &	///
				   	impulse  == "`impulse'" &	///
				   	response == "`response'"	///
				   	// blank
				qui gen double				///
				`ucl'=`stat'+std`stat'*invnorm(`cumlevel') ///
					if irfname  == "`irfname'" &	///
				   	impulse  == "`impulse'" &	///
				   	response == "`response'"	///
				// blank
				local cilab `"`=strsubdp("`level'")'% CI of"'

				local cigraph`ciplots'			///
				(rarea `lcl' `ucl' step			///
					if irfname  == "`irfname'" &	///
				   	impulse  == "`impulse'" &	///
				   	response == "`response'" &	///
				   	step >= `lstep' &		///
				   	step <= `ustep'		///
					,				///
					yvarlabel(			///
					`"`cilab' \`label`plots''"' 	///
					`"`cilab' \`label`plots''"' 	///
					)				///
					\`cipstyle`ciplots''		///
					`cilines'			///
					`ciopts'			///
				)					///
				//blank
	
				local cilist `"`cilist' `level'"'
			}
			else	local cilist `"`cilist' noci"'
		}
		else	local cilist `"`cilist' noci"'
	}

	local xx : list uniq irflist
	if `:word count `xx'' != 1 {
		local irflabels `irflist'
		local colon ": "
	}
	if `plots' == 1 {
		local yttl ytitle(`"`stalist'"')
	}
	else	local yttl ytitle(`""')
	forval i = 1/`plots' {
		local irf : word `i' of `irflabels'
		local imp : word `i' of `implist'
		local res : word `i' of `reslist'
		local sta : word `i' of `stalist'
		local label`i' "`irf'`colon'`sta' of `imp' -> `res'"
		local graphs `"`graphs' `graph`i''"'
		local yttl
	}
	local j `plots'
	forval i = 1/`ciplots' {
		if `i' == 1 {
			local cipstyle1 pstyle(ci)
		}
		else if `i' == 2 {
			local cipstyle2 pstyle(ci2)
		}
		else {
			local ++j
			if `j' > `maxpstyle' {
				local j = mod(`j'-1,`maxpstyle')+1
			}
			local cipstyle`i' pstyle(p`j')
		}
		local cigraphs `"`cigraphs' `cigraph`i''"'
	}
	if `ciplots' > 0 | `plots' > 1 {
		local tw_extra legend(cols(1))
	}

	if ! `plots' & ! `ciplots' {
		di as text "no graphs to produce"
		exit
	}
	graph twoway				///
		`cigraphs'			///
		`graphs'			///
		,				///
		`tw_extra'			///
		`tw_options'			///
		// blank
	
	// saved results
	return scalar ciplots = `ciplots'
	return scalar plots = `plots'
	forval i = `plots'(-1)1 {
		return local ci`i' `: word `i' of `cilist''
		return local stat`i' `: word `i' of `stalist''
		return local response`i' `: word `i' of `reslist''
		return local impulse`i' `: word `i' of `implist''
		return local irfname`i' `: word `i' of `irflist''
	}
end

program CheckSpec, sclass
	args irfname impulse response stat

	local errors 0
	if (`:word count `0'' > 4)	local ++errors
	if (`"`irfname'"' == "")	local ++errors
	if (`"`impulse'"' == "")	local ++errors
	if (`"`response'"' == "")	local ++errors
	if `errors' {
		di as err "invalid specification: `0'"
		exit 103
	}

	_irf_ops `impulse'
	local impulse `s(irfvar)'

	_irf_ops `response'
	local response `s(irfvar)'

	local char : char _dta[irfnames]
	if `"`irfname'"' == "." {
		local irfname : word 1 of `char'
	}
	local ok : list irfname in char
	if ! `ok' {
		di as err `"irfname `irfname' not found"'
		exit 198
	}
	
	local char : char _dta[`irfname'_order]
	local ok : list response in char
	if ! `ok' {
		di as err ///
`"response `response' not found in results from `irfname'"'
		exit 198
	}

	capture confirm variable `stat'
	if _rc {
		di as err "`stat' is not valid statistic"
		exit 198
	}
	
	if "`e(cmd)'"=="arima" | "`e(cmd)'"=="arfima" {
		local tmp irf cirf oirf coirf sirf
		local out : list stat | tmp
		local out : list uniq out
		local out : list out - tmp
		if "`out'"!="" {
			di as err "{cmd:`out'} not available after `e(cmd)'"
			exit 198
		}
	}
	
	local dmult dm cdm
	local dmult : list  stat & dmult
	if "`dmult'" != "" {
		local dmchar : char _dta[`irfname'_exogvars]
		local dmchar `dmchar' `char'
		local ok : list response in dmchar
		if ! `ok' {
			di as err ///
`"impulse `impulse' not found in results from `irfname'"'
			exit 198
		}
	}
	else {
		local char : char _dta[`irfname'_order]
		local ok : list impulse in char
		if ! `ok' {
			di as err ///
`"impulse `impulse' not found in results from `irfname'"'
			exit 198
		}
	}


	sreturn clear
	qui count if !missing(`stat')		///
		   & irfname == "`irfname'"	///
		   & impulse == "`impulse'"	///
		   & response == "`response'"	///
		   // blank
	if r(N) == 0 {
		di as txt ///
`"{p 0 4 2}`stat' values are all missing for"'	///
`"`irfname': `impulse' -> `response'{p_end}"'
		sreturn clear
		sreturn local statmissing 1
		exit
	}

	// save names
	sreturn clear
	sreturn local irfname	`irfname'
	sreturn local impulse	`impulse'
	sreturn local response	`response'
	sreturn local stat	`stat'
	sreturn local statmissing 0
end

exit

