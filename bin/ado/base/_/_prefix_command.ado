*! version 1.7.0  03oct2018
program _prefix_command, sclass
	version 9
	local version : di "version " string(_caller()) ":"

	_on_colon_parse `0'
	local command `"`s(after)'"'
	local 0 `"`s(before)'"'
	local def_level `"`c(level)'"'
	syntax anything(name=caller id="command name")	///
		[fw iw pw aw] [if] [in] [,		///
		SVY NOREST				///
		CHECKCLuster				///
		CHECKVCE				///
		CHECKBS					///
		CLuster(varlist)			///
		Level(cilevel)				/// -Display- opts
		COEF					/// for -logistic-
		*					///
	]

	if "`checkcluster'" == "" & `"`cluster'"' != "" {
		local 0 `", cluster(string asis)"'
		syntax [, notanoption ]
	}

	// NOTE: `caller' does not have to be an existing command name, but it
	// will be used in error messages

	confirm name `caller'
	ParseCommand "`checkbs'" "`caller'" `command'

	if `"`r(cmdname)'"' == "xi" {
		if `"`caller'"' != "table" {
			di as err "xi is allowed only as a prefix to `caller'"
			exit 199
		}
	}

	// NOTE: `options' should only contain an eform option
	_check_eformopt `r(cmdname)', eformopts(`options')
	local efopt = cond(`"`s(opt)'"'=="",`"`s(eform)'"',`"`s(opt)'"')
	local eform `"`s(eform)'"'

	sreturn clear
	if r(replay) {
		CheckReplay `r(cmdname)', `r(options)'
	}
	sreturn local version	`"`r(version)'"'
	sreturn local cmdname	`"`r(cmdname)'"'
	sreturn local anything	`"`r(anything)'"'
	sreturn local anything0	`"`r(anything0)'"'
	sreturn local wtype	`"`r(wtype)'"'
	sreturn local wexp	`"`r(wexp)'"'
	sreturn local wgt	`"`r(wgt)'"'
	sreturn local if	`"`r(if)'"'
	sreturn local in	`"`r(in)'"'
	sreturn local rest	`"`r(rest)'"'
	sreturn local efopt	`"`r(efopt)'"'
	sreturn local eform	`"`r(eform)'"'
	if "`r(level)'" != "" {
		if "`level'" != "`def_level'" & "`level'" != "`r(level)'" {
			di as err ///
`"option {bf:level()} of {bf:`caller'} conflicts with "'	///
`"option {bf:level()} of {bf:`s(cmdname)'}"'
			exit 198
		}
		// NOTE: r(level) is not equal to c(level), otherwise it would
		// be empty
		sreturn local level	`"`r(level)'"'
	}
	else if "`level'" != "`def_level'" {
		sreturn local level	`"`level'"'
	}

	if "`weight'" != "" {
		if !inlist(`"`s(wgt)'"', "", `"[`weight'`exp']"') {
			di as err ///
"weights of {bf:`caller'} conflict with weights of {bf:`s(cmdname)'}"
			exit 198
		}
		else {
			sreturn local wtype	`"`weight'"'
			sreturn local wexp	`"`exp'"'
			sreturn local wgt	`"[`weight'`exp']"'
		}
	}
	if "`svy'" != "" & `"`s(wgt)'"' != "" {
		di as err "{p 0 0 2}"
		di as err "weights not allowed with the"
		di as err "{bf:svy} prefix;{break}"
		di as err "the {bf:svy} prefix assumes survey weights were"
		di as err "already specified using {bf:svyset}"
		di as err "{p_end}"
		exit 101
	}
	if `"`if'"' != "" {
		if `"`s(if)'"' != "" {
			di as err ///
"{bf:`caller'} and {bf:`s(cmdname)'} may not both specify an {it:if} condition"
			exit 198
		}
		sreturn local if	`"`:list retok if'"'
	}
	if `"`in'"' != "" {
		if `"`s(in)'"' != "" {
			di as err ///
"{bf:`caller'} and {bf:`s(cmdname)'} may not both specify an {it:in} condition"
			exit 198
		}
		sreturn local in	`"`in'"'
	}

	if `"`efopt'"' != "" {
		if `"`s(eform)'"' != "" & `"`s(eform)'"' != `"`eform'"' {
			di as err ///
`"option {bf:`efopt'} of {bf:`caller'} conflicts with "'	///
`"option {bf:`s(efopt)'} of {bf:`s(cmdname)'}"'
			exit 198
		}
		else if `"`s(efopt)'"' == "" {
			sreturn local efopt	`"`efopt'"'
		}
	}
	if `"`coef'"' == "" {
		local coef `"`r(coef)'"'
	}
	if `"`coef'"' != "" {
		if `"`s(efopt)'"' != "" {
			if `"`s(eform)'"' != `"`s(efopt)'"' {
				opts_exclusive "eform() coef"
			}
			else {
				opts_exclusive "`s(efopt)' coef"
			}
		}
		sreturn local efopt `coef'
	}
	if `"`r(cmdname)'"' == "logistic" {
		if !inlist("`s(efopt)'", "", "coef", "or") {
			local 0 ", `s(efopt)'"
			syntax [, NULLOP]
			error 198	// [sic]
		}
	}
	if "`checkvce'" == "" {
		if `"`r(vce)'"' != "" {
			local options	`"`r(options)' vce(`r(vce)')"'
		}
		else	local options	`"`r(options)'"'
		// put the -eform- option back in the list of options
		if `"`s(efopt)'"' != "" ///
		 & bsubstr(`"`s(efopt)'"',1,5) != "eform" {
			local options	`"`options' `s(efopt)'"'
		}
		sreturn local options	`"`:list retok options'"'
	}
	else {
		// put the -eform- option back in the list of options
		if `"`s(efopt)'"' != "" ///
		 & bsubstr(`"`s(efopt)'"',1,5) != "eform" {
			local options	`"`r(options)' `s(efopt)'"'
		}
		else	local options	`"`r(options)'"'
		sreturn local options	`"`:list retok options'"'
		sreturn local vce	`"`r(vce)'"'
	}
	sreturn local prefix_options	`r(legend)'	///
					`r(header)'	///
					`r(table)'	///
					`r(dots)'
	if `"`s(version)'"' == "" {
		sreturn local version	`"`version'"'
	}
	local command `"`s(cmdname)' `s(anything)' `s(wgt)' `s(if)' `s(in)'"'
	if `"`s(options)'"' != ""  {
		local command `"`:list retok command', `s(options)'`s(rest)'"'
	}
	else	local command `"`:list retok command'`s(rest)'"'
	sreturn local command `"`:list retok command'"'
	if "`checkcluster'" != "" & `"`s(cluster)'"' == "" {
		CheckCluster
	}
	if `"`cluster'"' != "" {
		if `"`s(cluster)'"' != "" & `"`s(cluster)'"' != `"`cluster'"' {
			di as err			///
`"option {bf:cluster()} of {bf:`caller'} conflicts with "'	///
`"option {bf:cluster()} of {bf:`s(cmdname)'}"'
			exit 198
		}
		else if `"`s(cluster)'"' == "" {
			sreturn local cluster	`"`cluster'"'
		}
	}
end

program ParseCommand, rclass
	gettoken checkbs 0 : 0
	gettoken caller  0 : 0
	local found 0
	while !`found' & `"`0'"' != "" {
		gettoken cmd 0 : 0, parse(" :,")
		if "`cmd'" == ":" {
			local cmd
			continue, break
		}
		local lcmd : length local cmd

		// check for commands that used to be internal, and thus had
		// abbreviations that are now very difficult to unabbreviate
		local cmdlist	cnreg	///
				clogit	///
				logit	///
				mlogit	///
				ologit	///
				oprobit	///
				probit	///
				regress	///
				tobit	///
				proportion
		local minlist	3	///
				3	///
				4	///
				4	///
				3	///
				3	///
				4	///
				3	///
				3	///
				4
		local k_list : word count `minlist'
		forval i = 1/`k_list' {
			local name : word `i' of `cmdlist'
			local abbr : word `i' of `minlist'
			if "`cmd'" == bsubstr("`name'",1,max(`abbr',`lcmd')) {
				local cmd `name'
				continue, break
			}
		}

		// get full command name if an abbreviation
		capture unabcmd `cmd'
		if !c(rc) {
			local cmd `r(cmd)'
		}
		else {
			if "`cmd'" == "," {
				di as err "command not found"
				exit 111
			}
			capture program list `cmd'
			if c(rc) {
				di as error `"{bf:`cmd'} command not found"'
				exit 111
			}
		}

		if `"`cmd'"' == "version" {
			capture _on_colon_parse `0'
			if c(rc) {
				di as err "invalid use of {bf:version} command"
				exit 198
			}
			local version `"version `s(before)':"'
			local 0 `"`s(after)'"'
			if `"`0'"' == "" {
				CommandNotFound
			}
			CheckVersion `version'
			local cmd
		}
		else if inlist(`"`cmd'"', "capture", "noisily", "quietly") {
			di as txt "(note: ignoring `cmd')"
			local cmd
			// look for optional colon ":"
			gettoken COLON : 0, parse(" :")
			if "`COLON'" == ":" {
				gettoken COLON 0 : 0, parse(" :")
			}
		}
		else if inlist(`"`cmd'"', "by", "bysort", "mi", "sw", "bayes") {
			// excluded commands
			di as err "{bf:`cmd'} may not be used in this context"
			exit 199
		}
		else	local found 1
	}

	if "`:list retok cmd'" == "" {
		CommandNotFound
	}

	is_svysum `cmd'
	local issvysum = r(is_svysum)

	if `"`cmd'"' == "glm" {
		local levelopt LEvel(cilevel)
	}
	else if `"`cmd'"' == "xtgee" {
		local levelopt LEVel(cilevel)
	}
	else if "`caller'" != "simulate"{
		local levelopt Level(cilevel)
	}

	cap syntax [anything(name=anything0 equalok)]	///
		[using] [fw aw pw iw] [if] [in] [, *]
	local rc = c(rc)

       // st commands do not have a depvar in the varlist
       local stcmds    stcox           ///
                       stcrreg         ///
                       streg
       local is_st : list cmd in stcmds

	// xtme commands are better parsed in canonical form
	local mecmds	xtmixed		///
			xtmelogit	///
			xtmepoisson	///
			meqrlogit	///
			meqrpoisson	///
			mixed		///
			meglm		///
			melogit		///
			meprobit	///
			mecloglog	///
			meologit	///
			meoprobit	///
			mepoisson	///
			menbreg		///
			mestreg		///
			metobit		///
			meintreg
	local is_me :list cmd in mecmds
	if `is_me' {
		_parse expand stub1 stub2 : 0
		if "`checkbs'" != "" {
			forval i = 1/`stub1_n' {
				_bs_check `stub1_`i''
			}
		}
		_parse canon 0 : stub1 stub2
		if `rc' {
			qui syntax [anything(name=anything0 equalok)]	///
				[using] [fw aw pw iw] [if] [in] [, *]
		}
	}
	else {
		if _rc {
			syntax [anything(name=anything0 equalok)]	///
				[using] [fw aw pw iw] [if] [in] [, *]
		}
	
		if "`weight'" == "" {
			local 0 `"`anything0' `using' `if' `in', `options'"'
		}
		else {
			local 0 `"`anything0' `using' `if' `in' [`weight'`exp'], `options'"'
		}
	}
	local USING0 `"`using'"'

	local prseXtra	NOLegend		///
			NOHeader		///
			NOTable			///
			NODOTS
	local commopts	`levelopt'		///
			`prseXtra'		///
			VCE(passthru)		///
			COEF
	local add_or	xtmelogit		///
			meqrlogit		///
			melogit			///
			meologit
	local add_irr	xtmepoisson		///
			meqrpoisson		///
			mepoisson		///
			menbreg
	if `:list cmd in add_or' {
		local commopts `commopts' or
	}
	else if `:list cmd in add_irr' {
		local commopts `commopts' irr
	}
	else if "`cmd'" == "mestreg" {
		local commopts `commopts' nohr TRatio
	}
	else if "`cmd'" == "meglm" {
		local commopts `commopts' EForm irr or
	}
	_parse expand part gg : 0, gweight common(`commopts')

	local replay = replay()
	if `part_n' > 1 {
		if !`is_st' {
			forval i=1/`part_n' {
				local 0 : copy local part_`i'
				syntax [anything(equalok)] ///
					[using] [fw aw pw iw] [if] [in] [, *]
				if `"`gg_if'"' == "" {
					local gg_if : copy local if
				}
				else if `"`if'"' != "" {
					di as err ///
"multiple {it:if} conditions not allowed"
					exit 198
				}
				if `"`gg_in'"' == "" {
					local gg_in : copy local in
				}
				else if `"`in'"' != "" {
					di as err ///
"multiple {it:in} conditions not allowed"
					exit 198
				}
				if `"`gg_wt'"' == "" & "`weight'" != "" {
					local gg_wt `"[`weight'`exp']"'
				}
				else if "`weight'" != "" {
					di as err ///
"multiple weight expressions not allowed"
					exit 198
				}
				if `"`using'"' != "" {
					local using `" `using'"'
				}
				if `"`options'"' != "" {
					local options `", `options'"'
				}
				local cmdargs `"`cmdargs' (`anything'`using'`options')"'
			}
			local 0 `"`gg_if' `gg_in' `gg_wt', `gg_op'"'
		}
	}
	else {
		if !`issvysum' {
			capture _on_colon_parse `0'
			if !c(rc) {
				local 0 `"`s(before)'"'
				local rest `":`s(after)'"'
				local replay = replay()
			}
		}
	}

	if `"`cmd'"' == "logistic" {
		local coef COEF
	}

	syntax [anything(equalok)] [using] [fw aw pw iw] [if] [in] [, ///
		`levelopt' VCE(string asis) `coef' `prseXtra' * ]

	_check_eformopt `cmd', soptions eformopts(`options')
	local options	`"`s(options)'"'
	local efopt = cond(`"`s(opt)'"'=="",`"`s(eform)'"',`"`s(opt)'"')
	local eform `"`s(eform)'"'

	return local version	`"`version'"'
	return local cmdname	`"`cmd'"'
	if `part_n' > 1 {
		local anything	`"`cmdargs'"'
	}
	if `:length local USING0' {
		local anything `"`anything' `USING0'"'
		local anything0 `"`anything0' `USING0'"'
	}
	return local anything `"`anything'"'
	return local anything0 `"`anything0'"'
	if `"`weight'`exp'"' != "" {
		return local wgt	`"[`weight'`exp']"'
		return local wtype	`"`weight'"'
		return local wexp	`"`exp'"'
	}
	return local if	`"`:list retok if'"'
	return local in	`"`in'"'
	local options `"`options' `nolegend' `noheader' `notable' `nodots'"'
	return local options	`"`options'"'
	return local vce	`"`vce'"'
	return local legend	`"`nolegend'"'
	return local header	`"`noheader'"'
	return local table	`"`notable'"'
	return local dots	`"`nodots'"'
	if "`levelopt'" != "" {
		if `level' != c(level) {
			return local level	`"`level'"'
		}
	}
	return local rest	`"`rest'"'
	return local efopt	`"`efopt'"'
	return local eform	`"`eform'"'
	return local coef	`"`coef'"'
	return scalar replay = `replay'
end

// A simple test case to verify that the user supplied -version- is valid.

program CheckVersion
	capture `0' di "checking version"
	if c(rc) {
		di as err "invalid use of version command"
		exit 198
	}
end

program CheckCluster, sclass
	if `"`s(vce)'"' != "" {
		local vceopt `"vce(`s(vce)')"'
	}
	local 0 `", `vceopt' `s(options)'"'
	syntax [, VCE(passthru) CLuster(passthru) * ]
	capture _vce_parse, argopt(CLuster) old :, `vce' `cluster'
	if c(rc) == 100 {
		// conflicting -cluster()- and -vce()- options
		_vce_parse, argopt(CLuster) old :, `vce' `cluster'
	}
	else if "`r(cluster)'" != "" {
		sreturn local cluster = r(cluster)
		sreturn local vce
	}
end

program CheckReplay, sclass
	syntax [name] [, Distribution(passthru) ESTImate * ]
	if bsubstr("`namelist'",1,2) != "st" & "`namelist'" != "mestreg" {
		sreturn local replay replay
		exit
	}
	if "`namelist'" == "mestreg" {
		if `"`distribution'"' == "" & "`e(cmd2)'" == "mestreg" {
			sreturn local replay replay
		}
		exit
	}
	if bsubstr("`namelist'",1,5) == "streg" {
		if `"`distribution'"' == "" & "`e(cmd2)'" == "streg" {
			sreturn local replay replay
		}
		exit
	}
	if bsubstr("`namelist'",1,5) == "stcox" {
		if `"`estimate'"' == "" & "`e(cmd2)'" == "stcox" {
			sreturn local replay replay
		}
		exit
	}
end

// Common error message
program CommandNotFound
	di as err "'' found where command expected"
	exit 198
end

exit
