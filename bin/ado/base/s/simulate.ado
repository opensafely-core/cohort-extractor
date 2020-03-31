*! version 4.6.0  13dec2018
program simulate
	version 9, missing
	local version : di "version " string(_caller()) ", missing:"

	set prefix simulate

	// Stata 8 syntax
	capture _on_colon_parse `0'
	if c(rc) | `"`s(after)'"' == "" {
		gettoken old : 0 , qed(qed)
		if `qed' {
			`version' simulate_8 `0'
			exit
		}
		else {
			capture which `old'
			if !c(rc) {
				`version' simulate_8 `0'
				exit
			}
			capture program list `old'
			if !c(rc) {
				`version' simulate_8 `0'
				exit
			}
		}
	}

	`version' Simulate `0'
end

program Simulate
	version 9, missing
	local version : di "version " string(_caller()) ", missing:"

	// <my_stuff> : <command>
	_on_colon_parse `0'
	local command `"`s(after)'"'
	local 0 `"`s(before)'"'

	syntax [anything(name=exp_list equalok)]	///
		[fw iw pw aw] [if] [in] [,		///
			Reps(integer -1) 		///
			SAving(string) 			///
			DOUBle 				/// not documented
			noLegend			///
			Verbose				///
			SEED(string)			/// not documented
			TRace				/// "prefix" options
			*				///
		]

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

	if "`weight'" != "" {
		local wgt [`weight'`exp']
	}

	// parse the command and check for conflicts
	`version' _prefix_command simulate `wgt' `if' `in' : `command'

	local version	`"`s(version)'"'
	local cmdname	`"`s(cmdname)'"'
	local command	`"`s(command)'"'

	local exclude simul simulate sem
	if `:list cmdname in exclude' {
		di as err "`cmdname' is not supported by simulate"
		exit 199
	}
	
	if "`trace'" != "" {
		local noisily	noisily
		local traceon	set trace on
		local traceoff	set trace off
	}

	local star = cond("`nodots'"=="nodots", "*", "_dots")
	local noi = cond("`noisily'"=="", "*", "noisily")

	// preliminary parse of <exp_list>
	_prefix_explist `exp_list', stub(_sim_)
	local eqlist	`"`s(eqlist)'"'
	local idlist	`"`s(idlist)'"'
	local explist	`"`s(explist)'"'
	local eexplist	`"`s(eexplist)'"'

	// set the seed
	if "`seed'" != "" {
		`version' set seed `seed'
	}
	local seed `c(seed)'

	`noi' di as inp `". `command'"'

	// run the command using the entire dataset
	_prefix_clear, e r
	`traceon'
	capture noisily quietly `noisily'		///
		`version' `command'
	`traceoff'
	local rc = c(rc)
	// error occurred while running on entire dataset
	if `rc' {
		_prefix_run_error `rc' simulate `cmdname'
	}

	// determine default <exp_list>, or generate an error message
	if `"`exp_list'"' == "" {
		_prefix_explist, stub(_sim_) default
		local eqlist	`"`s(eqlist)'"'
		local idlist	`"`s(idlist)'"'
		local explist	`"`s(explist)'"'
		local eexplist	`"`s(eexplist)'"'
	}
	// expand eexp's that may be in eexplist, and build a matrix of the
	// computed values from all expressions
	tempname b
	_prefix_expand `b' `explist',		///
		stub(_sim_)			///
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
	local express	`"`s(explist)'"'
	local coleq	`"`s(ecoleq)' `s(coleq)'"'
	local colna	`"`s(ecolna)' `s(colna)'"'
	forval i = 1/`K' {
		local exp`i' `"`s(exp`i')'"'
	}

	local legopts	command(`command')	///
			egroup(`s(ecoleq)')	///
			enames(`s(ecolna)')	///
			group(`s(coleq)')	///
			names(`s(colna)')	///
			express(`express')	///
			`noisily' `verbose'

	// check options
	if `reps' < 1 {
		di as err "reps() is required, and must be a positive integer"
		exit 198
	}
	if `"`saving'"'=="" {
		tempfile saving
		local filetmp "yes"
	}
	else {
		_prefix_saving `saving'
		local saving	`"`s(filename)'"'
		if "`double'" == "" {
			local double	`"`s(double)'"'
		}
		local every	`"`s(every)'"'
		local replace	`"`s(replace)'"'
	}

	// setup list of missings
	forvalues i = 1/`K' {
		local mis "`mis' (.)"
	}

	// temp variables for post
	forvalues i = 1/`K' {
		tempname x`i'
	}

	// this must be done before another command that saves in r() or e()
	// can be run

	forvalues i = 1/`K' {
		scalar `x`i'' = `b'[1,`i']
	}
	local sims
	forvalues i = 1/`K' {
		local sims "`sims' (`x`i'')"
	}

	// check to see if final dataset will fit in memory
	if c(max_N_current)-20 < `reps' {
		di as err "insufficient memory (observations)"
		exit 901
	}

	if "`legend'" == "" {
		_prefix_legend simulate, `legopts'
	}

	tempname postnam
	postfile `postnam' `names' using `"`saving'"', ///
		`double' `every' `replace'

	post `postnam' `sims'
	di
	if "`nodots'" == "" | "`noisily'" != "" {
		_dots 0, title(Simulations) reps(`reps') `nodots' `dots'
	}
	`star' 1 0 , `dots'
	forvalues i = 2/`reps' {
		`noi' di as inp `". `command'"'
		`traceon'
		capture `noisily' `version' `command'
		`traceoff'
		if (c(rc) == 1)	error 1
		local bad = c(rc) != 0
		if c(rc) {
			`noi' di in smcl as error ///
`"{p 0 0 2}captured error running (`command'), posting missing values{p_end}"'
			capture noisily post `postnam' `mis'
			if (c(rc) == 1)	error 1
			local rc = c(rc)
		}
		else {
			forvalues j = 1/`K' {
				capture scalar `x`j'' = `exp`j''
				if (c(rc) == 1)	error 1
				if c(rc) {
					local bad 1
					`noi' di in smcl as error ///
`"{p 0 0 2}captured error in `exp`j'', posting missing value{p_end}"'
					scalar `x`j'' = .
				}
				else if missing(`x`j'') {
					local bad 1
				}
			}
			capture noisily post `postnam' `sims'
			local rc = c(rc)
		}
		if `rc' {
			di as err ///
"this error is most likely due to {cmd:clear} being used within: `command'"
			exit `rc'
		}
		`star' `i' `bad' , `dots'
	}
	`star' `reps' , `dots'

	postclose `postnam'

	capture use `"`saving'"', clear
	if c(rc) {
		if 900 <= c(rc) & c(rc) <= 903 {
			di as err ///
"insufficient memory to load file with simulation results"
		}
		error c(rc)
	}

	label data `"simulate: `cmdname'"'
	char _dta[command] `"`command'"'
	if _caller() < 14 {
		char _dta[seed] `"`seed'"'
	}
	else {
		char _dta[rngstate] `"`seed'"'
	}

	// save labels to data set
	forvalues i = 1/`K' {
		local name : word `i' of `names'
		local label = usubstr(`"`exp`i''"',1,80)
		label variable `name' `"`label'"'
		char `name'[expression] `"`exp`i''"'
		if `"`coleq'"' != "" {
			char `name'[colname]
			local na : word `i' of `colna'
			local eq : word `i' of `coleq'
			char `name'[coleq] `eq'
			char `name'[colname] `na'
			if `i' <= `k_eexp' {
				char `name'[is_eexp] 1
			}
		}
	}
	if "`filetmp'"!="" {
		global S_FN
	}
	else {
		quietly save `"`saving'"', replace
	}
end

exit
