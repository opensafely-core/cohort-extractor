*! version 3.6.0  13dec2018
program statsby
	version 9, missing
	local version : di "version " string(_caller()) ", missing:"

	set prefix statsby

	// Stata 8 syntax
	capture _on_colon_parse `0'
	if c(rc) | `"`s(after)'"' == "" {
		gettoken old : 0 , qed(qed)
		if `qed' {
			`version' statsby_8 `0'
			exit
		}
	}

	quietly ssd query
	if (r(isSSD)) {
		di as err "statsby not possible with summary statistic data"
		exit 111
	}
	`version' capture noisily StatsBy `0'
	exit c(rc)
end

program StatsBy, rclass
	version 9, missing
	local version : di "version " string(_caller()) ", missing:"

	// <my_stuff> : <command>
	_on_colon_parse `0'
	local command `"`s(after)'"'
	local 0 `"`s(before)'"'

	// quick check for -force- option
	syntax [anything(name=exp_list equalok)]	///
		[fw iw pw aw] [if] [in] [,		///
			FORCE				///
			Level(passthru)			///
			*				/// other options
		]

	// NOTE: -force- allows command to be a "svy" command

	if "`weight'" != "" {
		local wgt [`weight'`exp']
	}

	// parse the command and check for conflicts
	`version' _prefix_command statsby `wgt' `if' `in' , ///
		`level': `command'

	if "`s(wtype)'" == "pweight" {
		di as err "`s(wtype)'s are not supported by statsby"
		exit 101
	}

	local version	`"`s(version)'"'
	local cmdname	`"`s(cmdname)'"'
	local cmdargs	`"`s(anything)'"'
	local wgt	`"`s(wgt)'"'
	local wtype	`"`s(wtype)'"'
	local wexp	`"`s(wexp)'"'
	local cmdif	`"`s(if)'"'
	local cmdin	`"`s(in)'"'
	local cmdopts	`"`s(options)'"'
	local rest	`"`s(rest)'"'
	local level	`"`s(level)'"'
	if "`level'" != "" {
		local cmdopts `"`cmdopts' level(`level')"'
	}
	// ignore s(efopt)
	local command	`"`s(command)'"'
	local command1 `"`version' `cmdname' `cmdargs' `wgt'"'
	local command2 `"`cmdopts' `rest'"'
	local command2 : list retok command2

	local exclude permute simulate statsby
	if `:list cmdname in exclude' ///
	 | ("`force'" == "" & bsubstr("`cmdname'",1,3) == "svy") {
		di as err "`cmdname' is not supported by statsby"
		exit 199
	}
	// now check the rest of the options
	local 0 `", `options'"'
	syntax [,			///
		BY(string)		/// allows by(varlist, missing)
		BASEpop(string asis)	///
		Total			///
		Subsets			///
		CLEAR			///
		SAving(string)		///
		DOUBle			/// not documented
		FORCEDROP		///
		noLegend		///
		Verbose			///
		TRace			/// "prefix" options
		*			///
	]

	// check options
	_get_dots_option, `options'
	local dots `"`s(dotsopt)'"'
	local nodots `"`s(nodots)'"'
	local noisily `"`s(noisily)'"'
	local options `"`s(options)'"'
	if `"`options'"' != "" {
		local 0 `", `options'"'
		syntax [, NOTANOPTION]
		error 198	// [sic]
	}

	if `"`saving'"' == "" {
		tempfile saving
		local filetmp "yes"
	}
	else {
		if `"`clear'"' != "" {
			di as err ///
"clear and saving() are mutually exclusive options"
			exit 198
		}
		_prefix_saving `saving'
		local saving	`"`s(filename)'"'
		if "`double'" == "" {
			local double	`"`s(double)'"'
		}
		local every	`"`s(every)'"'
		local replace	`"`s(replace)'"'
	}
	if c(changed) & ("`clear'" == "") & (`"`filetmp'"' == "yes" ) {
		error 4
	}

	if `"`by'"' != "" {
		_parse comma by missing : by
		unab by : `by'
	}
	
	if bsubstr("`missing'", 1, 1) == "," {
		local missing : subinstr local missing "," ""
		local missing `=trim(`"`missing'"')'
		local lkey = length(`"`missing'"')
		if `"`missing'"' != bsubstr("missing", 1, max(3,`lkey')) {
			di as error "by() incorrectly specified"
			exit 198
		}
	}
	
	if "`trace'" != "" {
		local noisily	noisily
		local traceon	set trace on
		local traceoff	set trace off
	}

	local star = cond("`nodots'"=="nodots" | "`noisily'" != "", "*", "_dots")

	// set touse
	tempvar touse
	mark `touse' `cmdif' `cmdin'
	if `"`missing'"' == "" {
		if `"`by'"' != "" {
			markout `touse' `by', strok
		}
	}
	quietly replace `touse' = . if `touse' == 0

	// set base sample
	if `"`basepop'"' != `""' {
		tempvar basepvar
		mark `basepvar' if `basepop'
		if (`"`cmdif'"' == `""')  local baseif `"if `basepvar'"'
		else			  local baseif `"`cmdif' `basepvar'"'
		local basecnd "& `basepvar'"
	}
	else {
		local baseif `"`cmdif'"'
	}

	// preliminary parse of <exp_list>
	_prefix_explist `exp_list', stub(_stat_)
	local eqlist	`"`s(eqlist)'"'
	local idlist	`"`s(idlist)'"'
	local explist	`"`s(explist)'"'
	local eexplist	`"`s(eexplist)'"'

	_prefix_note `cmdname', `nodots'
	if "`noisily'" != "" {
		di "statsby: First call to `cmdname' with data as is:" _n
		di as inp `". `command'"'
	}
	// Save any existing estimation results
	tempname est_hold
	capture estimates store `est_hold'
	if (c(rc)) local est_hold

	// run the command using the entire dataset
	_prefix_clear, e r
	if (`"`cmdopts'"' != "") local comma ","
	local inable inable
	local ifable ifable
	if `"`cmdin'"' == "" {
		local commandin	`"`command1' `baseif' in 1/l`comma'`command2'"'
		capture `noisily' `commandin'
		if c(rc) {
			if `:length local est_hold' {
				quietly estimates restore `est_hold'
			}
			capture `noisily' `commandin'
		}
		if c(rc) local inable
	}
	if "`inable'" == "" | `"`cmdin'"' != "" {
		if (`"`baseif'"' == `""')  local baseif "if 1"
		local commandif	`"`command1' `cmdin' `baseif'`comma'`command2'"'
		capture `noisily' `commandif'
		if c(rc) {
			if `:length local est_hold' {
				quietly estimates restore `est_hold'
			}
			capture `noisily' `commandif'
		}
	}
	if c(rc) {			
	// neither ifable nor inable, or not ifable and has cmdin (last is odd)
		if `"`basepop'`cmdin'`cmdif'"' != `""' {
			preserve
			keep if `touse' `basecnd'
		}
		local commandnor `"`command1' `comma'`command2'"'
		capture `noisily' `version' `commandnor'
		if c(rc) {
			`traceon'
			if `:length local est_hold' {
				quietly estimates restore `est_hold'
			}
			capture noisily quietly `noisily' `commandnor'
			`traceoff'
		}
		if (`"`basepop'`cmdin'`cmdif'"' != `""') restore
		local ifable
	}
	local rc = c(rc)
	// error occurred while running on entire dataset
	if `rc' {
		_prefix_run_error `rc' statsby `cmdname'
	}

	if ("`forcedrop'" != "") {
		local inable
		local ifable
	}


	// determine default <exp_list>, or generate an error message
	if `"`exp_list'"' == "" {
		_prefix_explist, stub(_stat_) default
		local eqlist	`"`s(eqlist)'"'
		local idlist	`"`s(idlist)'"'
		local explist	`"`s(explist)'"'
		local eexplist	`"`s(eexplist)'"'
	}
	// expand eexp's that may be in eexplist, and build a matrix of the
	// computed values from all expressions
	tempname b
	_prefix_expand `b' `explist',		///
		stub(_stat_)			///
		eexp(`eexplist')		///
		colna(`idlist')			///
		coleq(`eqlist')			///
		// blank
	local k_eq	`s(k_eq)'
	local k_exp	`s(k_exp)'
	local k_eexp	`s(k_eexp)'
	local K = `k_exp' + `k_eexp'
	local k_extra	`s(k_extra)'
	local names	`"`s(enames)' `s(names)'"'
	local legnames	`"`names'"'
	local express	`"`s(explist)'"'
	local eexpress	`"`s(eexplist)'"'
	forval i = 1/`K' {
		local exp`i' `"`s(exp`i')'"'
	}
	forval i = 1/`k_eexp' {
		gettoken ename legnames : legnames
		local elegnames `elegnames' `ename'
	}

	local legopts	command(`command')	///
			enames(`elegnames)')	///
			names(`legnames)')	///
			express(`express')	///
			`noisily' `verbose'

	// list of the expressions
	forvalues i = 1/`K' {
		local exps `exps' (`exp`i'')
	}

	// restore held estimates, if command was not an estimation command
	if `:length local est_hold' {
	   if `"`:e(scalars)'`:e(macros)'`:e(matrices)'`:e(functions)'"'==`""' {
		quietly estimates restore `est_hold'
	   }
	   else {
		estimates drop `est_hold'
		local est_hold
	   }
	}

	// display header
	if "`legend'" == "" {
		_prefix_legend statsby, `legopts'
		if `"`by'"' == "" {
			di as txt %`s(col1)'s "by" `":  <none>"'
		}
		else    di as txt %`s(col1)'s "by" `":  `by'"'
	}

	if "`by'" != "" {
		foreach byvar of local by {
			local byvartype : type `byvar'
			local postby `postby' `byvartype' `byvar'
		}
	}

	local badnames : list names & postby
	if `"`badnames'"' != "" {
		gettoken badname : badnames
		di as err "`badname' already defined"
		exit 198
	}

	tempname postname
	postfile `postname' `postby' `names' using `"`saving'"', `double' ///
		`replace' `every'

	di

	if "`subsets'" != "subsets" {
		if "`nodots'" == "" | "`noisily'" != "" {
			_dots 0, title(Statsby groups) `nodots' `dots'
		}
		`version' PostGroups `touse' = `K',	///
			cmd(`command')			///
			command1(`command1')		///
			command2(`command2')		///
			by(`by')			///
			by0(`by')			///
			postname(`postname')		///
			star(`star')			///
			`dots'				///
			`noisily'			///
			`trace'				///
			`total'				///
			express(`exps')			///
			`inable'			///
			`ifable'			///
			// blank
		return scalar N_groups = r(N_groups)
		local count `r(N_groups)'
	}
	else {
		if "`nodots'" == "" | "`noisily'" != "" {
			_dots 0, title(Statsby subsets) `nodots' `dots'
		}
		`version' SubSets `touse' = `K',	///
			cmd(`command')			///
			command1(`command1')		///
			command2(`command2')		///
			by(`by')			///
			postname(`postname')		///
			star(`star')			///
			`dots'				///
			`noisily'			///
			`trace'				///
			express(`exps')			///
			`inable'			///
			`ifable'			///
			// blank
		return scalar N_subsets = r(N_subsets)
		local count `r(N_subsets)'
	}
	`star' `count', `dots'

	// save variable labels of by vars
	if "`by'" != "" {
		tokenize `by'
		local j = 1
		while "``j''" != "" {
			local varlb`j' : variable label ``j''
			local lb`j' : value label ``j''
			if "`lb`j''" != "" {
				tempfile f`j'
				quietly label save `lb`j'' using `"`f`j''"'
			}
			local j = `j' + 1
		}
	}

	postclose `postname'
	if `"`filetmp'"' == "" {
		preserve
	}

	// get/save the labels of the by vars
	quietly use `"`saving'"', clear
	if "`by'" != "" {
		sort `by'
		tokenize `by'
		local j = 1
		while "``j''" != "" {
			label var ``j'' `"`varlb`j''"'
			if `"`f`j''"' != "" {
				quietly run `"`f`j''"'
				label val ``j'' `lb`j''
			}
			local j = `j' + 1
		}
	}

	// save labels for the generated vars
	forval i = 1/`K' {
		local name : word `i' of `names'
		local label = usubstr(`"`exp`i''"',1,80)
		label variable `name' `"`label'"'
	}
	label data `"statsby: `cmdname'"'
	if `"`filetmp'"' == "" {
		quietly save `"`saving'"', replace
	}
	else {
		// make c(changed) != 0
		tempname changed
		unab vlist : *
		gettoken n1 vlist : vlist
		while bsubstr("`n1'",1,1) == "_" {
			gettoken n1 vlist : vlist
		}
		if "`n1'" != "" {
			if bsubstr("`:type `n1''",1,3) == "str" {
				local changed = `n1'[1]
				quietly replace `n1' ///
					= cond(mi("`changed'"),"junk","") in 1
				quietly replace `n1' = "`changed'" in 1
			}
			else {
				scalar `changed' = `n1'[1]
				quietly replace `n1' ///
					= cond(missing(`changed'),0,.) in 1
				quietly replace `n1' = `changed' in 1
			}
		}
		else {
			// all the variable start with "_"
			quietly generate changed = . in 1
			drop changed
		}
	}
	global S_FN
	global S_FNDATE
	return local by `by'

	// restore held estimates
	if `:length local est_hold' {
		quietly estimates restore `est_hold' , drop
	}
end

program PostGroups, rclass
	version 8, missing
	local version : di "version " string(_caller()) ", missing:"

	// parse
	syntax varlist(max=1) =exp,		/// tousevar = # of exps
		cmd(string asis)		///
		command1(string asis)		///
		postname(string)		///
		[				///
			command2(string asis)	///
			by(varlist)		///
			by0(varlist)		///
			count(integer 0)	///
			star(string)		///
			NOIsily			///
			TRace			///
			subset			///
			total			///
			express(string asis)	///
			inable			///
			ifable			///
			dots(passthru)		///
		]
	local touse `varlist'

	if `"`command2'"' != "" {
		local command2 `", `command2'"'
	}
	// get expressions
	local K `exp'
	confirm integer number `K'
	forval i = 1/`K' {
		gettoken stuff express : express , match(parens)
		local exp`i' `stuff'
	}
	if `"`subset'"' == "" {
		local subset group
	}

	// by varlist with individual parens: for -post-
	tempname byobs
	scalar `byobs' = 1
	foreach name of local by {
		local misby `misby' (.)
		local pby `pby' (`name'[`byobs'])
	}
	if "`trace'" != "" {
		local noisily noisily
		local traceon	set trace on
		local traceoff	set trace off
	}
	local noi = cond("`noisily'"=="", "*", "noi")
	forval i = 1/`K' {
		tempname x`i'
		local misexps `misexps' (.)
		local pexps `pexps' (`x`i'')
	}
	if `"`by'"' == "" | `"`by0'"' == "" {
		local count = `count' + 1
		// run command and post results
		`noi' di as txt _n ///
"running (" as inp `"`cmd'"' as txt ") on `subset' `count'" _n
		`noi' di as inp ". `cmd'"
		`traceon'
		capture `noisily' `version' `cmd'
		`traceoff'
		if (c(rc) == 1)	error 1
		`star' `count' `c(rc)', `dots'
		if c(rc) {
			`noi' di in smcl as err ///
`"{p 0 0 2}captured error running (`cmd'), posting missing values{p_end}"'
			post `postname' `pby' `misexps'
		}
		else {
			forval i = 1/`K' {
				capture scalar `x`i'' = `exp`i''
				if (c(rc) == 1)	error 1
				if c(rc) {
					if c(rc) == 1 {
						error 1
					}
					`noi' di in smcl as error ///
`"{p 0 0 2}captured error in `exp`i'', posting missing value{p_end}"'
					scalar `x`i'' = .
				}
			}
			post `postname' `pby' `pexps'
		}
	}
	else {
	 	if "`total'" != "" {
			`traceon'
			capture `version' `cmd'
			`traceoff'
			if (c(rc) == 1)	error 1
			if c(rc) {
				`noi' di in smcl as err ///
`"{p 0 0 2}captured error running (`cmd'), posting missing values{p_end}"'
				post `postname' `pby' `misexps'
			}
			else {
				forval i = 1/`K' {
					capture scalar `x`i'' = `exp`i''
					if (c(rc) == 1)	error 1
					if c(rc) {
						`noi' di in smcl as error ///
`"{p 0 0 2}captured error in `exp`i'', posting missing value{p_end}"'
						scalar `x`i'' = .
					}
				}
				post `postname' `misby' `pexps'
			}
		}

						// groups
		local is_ts 0
		if "`inable'" == "" {
			local fast 0
		}
		else {
			capture tsset, noquery
			if c(rc) == 111 {
				local fast 1
			}
			else {
				local fast 0
				sum `touse' , meanonly
				if r(min) == r(max) {
					tempvar bygrp
					egen `bygrp' = group(`by0')
					capture assert 			   ///
						`bygrp' >= `bygrp'[_n-1] & ///
				           	`touse' >= `touse'[_n-1]   ///
						in 2/l
					if (! c(rc)) {
						local fast 1
						local is_ts = 1
					}
				}
			}
		}
		local sortvars : sortedby

		// begin code split for selecting groups by if or in
		if !(`fast') {			// select using if
			sort `touse' `by0'
			tempvar group
			by `touse' `by0' : gen double `group' = (_n==1)
			quietly replace `group' = sum(`group')
			quietly replace `group' = . if missing(`touse')
			summ `group', mean
			local ngrp = r(max)
			if `"`sortvars'"' != "" {
				sort `sortvars'
			}
			tempvar id
			quietly gen double `id' = _n
			forvalues i = 1/`ngrp' {
				local count = `count' + 1
				sum `id' if `group'==`i', mean
				scalar `byobs' = r(min)
				`noi' di as txt _n ///
"running (" as inp `"`cmd'"' as txt ") on `subset' `count'" _n
				`noi' di as inp ". `cmd'"
				if "`ifable'" != "" {
					`traceon'
					capture `noisily' `command1'	     ///
				 	    if `touse' == 1 & `group' == `i' ///
					    `command2'

					`traceoff'
				}
				else {
					preserve
					quietly 			///
					   keep if `touse' == 1 & `group' == `i'
					`traceon'
					capture `noisily' `command1' `command2'
					`traceoff'
					restore
				}
				if (c(rc) == 1)	error 1
				local bad = c(rc) != 0
				if c(rc) {
					`noi' di in smcl as err ///
`"{p 0 0 2}captured error running (`cmd'), posting missing values{p_end}"'
					post `postname' `pby' `misexps'
				}
				else {
					forval i = 1/`K' {
						capture scalar `x`i'' = `exp`i''
						if (c(rc) == 1) error 1
						if c(rc) {
							local bad 1
						`noi' di in smcl as error ///
`"{p 0 0 2}captured error in `exp`i'', posting missing value{p_end}"'
							scalar `x`i'' = .
						}
					}
					post `postname' `pby' `pexps'
				}
				`star' `count' `bad', `dots'
			}
		}
		else {	// select using in  (`fast' == 1)
			sort `touse' `by0' `sortvars'
			local sortvarsbase: sortedby
			tempvar grpcnt
			quietly bys `touse' `by0' ///
				: gen double `grpcnt' = _N if `touse'==1
			quietly count if `touse'==1
			local usecnt=r(N)
			if (`is_ts') {
				sort `sortvars'
				local sortvarsbase: sortedby
			}
			local j=1
			while `j'<=`usecnt' {
				local sortvarsnow : sortedby
				local samesort ///
					: list sortvarsnow == sortvarsbase
				if !`samesort' sort `sortvarsbase'
				local end=`j'+`grpcnt'[`j']-1
				local count = `count' + 1
				scalar `byobs' = `j'
				`noi' di as txt _n ///
"running (" as inp `"`cmd'"' as txt ") on `subset' `count'" _n
				`noi' di as inp ". `cmd'"
				`traceon'
				capture `noisily' `command1'		///
				 	in `j'/`end' `command2'
				`traceoff'
				if (c(rc) == 1)	error 1
				local bad = c(rc) != 0
				if c(rc) {
					`noi' di in smcl as err ///
`"{p 0 0 2}captured error running (`cmd'), posting missing values{p_end}"'
					post `postname' `pby' `misexps'
				}
				else {
					forval i = 1/`K' {
						capture scalar ///
							`x`i'' = `exp`i''
						if (c(rc) == 1) error 1
						if c(rc) {
							local bad 1
						`noi' di in smcl as error ///
`"{p 0 0 2}captured error in `exp`i'', posting missing value{p_end}"'
							scalar `x`i'' = .
						}
					}
					post `postname' `pby' `pexps'
				}
			local j=`end'+1
				`star' `count' `bad', `dots'
			}
		}
	}
	return scalar N_groups = `count'
end

program SubSets, rclass
	version 8, missing
	local version : di "version " string(_caller()) ", missing:"

	// parse
	syntax varlist(max=1) =exp,		/// tousevar = # of exps
		[				///
			by(varlist)		///
			express(passthru)	///
			*			///
		]

	local bynum : word count `by'
	tempname M
	GetMat `bynum' `M'
	local rnum = 2^`bynum'
	local count = 0
	forval i = 1/`rnum' {
		tokenize `by'
		preserve
		local by0
		forval j = 1/`bynum' {
			if `M'[`i',`j'] {
				local by0  `by0' ``j''
			}
			else {
				if(bsubstr("`:type ``j'''", 1,3) == "str") {
					quietly replace ``j'' = ""
				}
				else {
					quietly replace ``j'' = .
				}
			}
		}
		`version' PostGroups `varlist' `exp',	///
			by(`by')			///
			by0(`by0')			///
			count(`count')			///
			subset				///
			`express'			///
			`options'
		local count = r(N_groups)
		restore
	}
	return scalar N_subsets = `count'
end

// The following generates a matrix of 0's and 1's, each row determining a
// unique subset among all possible subsets.
program GetMat
	args bynum	M
	local rnum = 2^`bynum'
	mat `M' = J(`rnum', `bynum',0)
	local i 0
	while `i' <= `rnum'-1 {
		local j = `bynum'
		local a `i'
		while `j' > = 1 {
			if `a' == 0 {
				local j = 0
			}
			else {
				local b  mod(`a', 2)
				local a  int(`a'/2)
				mat `M'[`i'+1,`j'] = `b'
				local j = `j' - 1
			}
		}
		local i = `i' + 1
	}
end

