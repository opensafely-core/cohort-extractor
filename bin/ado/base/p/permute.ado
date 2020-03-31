*! version 2.8.0  13dec2018
program permute, rclass
	version 9
	local version : di "version " string(_caller()) ":"

	set prefix permute

	capture syntax [anything] using [, * ]
	if !c(rc) {
		if _by() {
			error 190
		}
		Results `0'
		return add
		exit
	}

	quietly ssd query
	if (r(isSSD)) {
		di as err "permute not possible with summary statistic data"
		exit 111
	}
	// Stata 8 syntax
	capture _on_colon_parse `0'
	if c(rc) | `"`s(after)'"' == "" {
		local zero `"`0'"'
		gettoken permvar zero : zero
		capture confirm var `permvar'
		if !c(rc) {
			gettoken old : zero , qed(qed)
			if `qed' {
				`version' permute_8 `0'
				return add
				exit
			}
		}

		capture syntax [anything] [using] [, * ]
		if !c(rc) {
			if _by() {
				error 190
			}
			Results `0'
			return add
			exit
		}
	}

	preserve
	`version' Permute `0'
	return add
end

program Permute, rclass
	version 9
	set buildfvinfo off			// auto-reset on exit
	local version : di "version " string(_caller()) ":"

	// get name of variable to permute
	gettoken permvar 0 : 0, parse(" ,:")
	confirm variable `permvar'
	unab permvar : `permvar'

	// <my_stuff> : <command>
	_on_colon_parse `0'
	local command `"`s(after)'"'
	local 0 `"`s(before)'"'

	// quick check for -force- and -nodrop- options
	// NOTE: exp_list is required
	syntax anything(name=exp_list			///
		id="expression list" equalok)		///
		[fw iw pw aw] [if] [in] [,		///
			FORCE				///
			noDROP				///
			Level(passthru)			///
			*				/// other options
		]

	if "`weight'" != "" {
		local wgt [`weight'`exp']
	}

	// parse the command and check for conflicts
	`version' _prefix_command permute `wgt' `if' `in' , ///
		`efopt' `level': `command'

	if "`force'" == "" & `"`s(wgt)'"' != "" {
		// permute does not allow weights
		local 0 `s(wgt)'
		syntax [, NONOPTION ]
	}

	local version	`"`s(version)'"'
	local cmdname	`"`s(cmdname)'"'
	local cmdargs	`"`s(anything)'"'
	local wgt	`"`s(wgt)'"'
	local wtype	`"`s(wtype)'"'
	local wexp	`"`s(wexp)'"'
	local cmdopts	`"`s(options)'"'
	local rest	`"`s(rest)'"'
	local efopt	`"`s(efopt)'"'
	local level	`"`s(level)'"'
	// command initially executed using entire dataset
	local xcommand	`"`s(command)'"'
	if "`drop'" != "" {
		// command with [if] [in]
		local command	`"`s(command)'"'
	}
	else {
		// command without [if] [in]
		local command	`"`cmdname' `cmdargs' `wgt'"'
		if `"`cmdopts'"' != "" {
			local command `"`:list retok command', `cmdopts'`rest'"'
		}
		else	local command `"`:list retok command'`rest'"'
		local cmdif	`"`s(if)'"'
		local cmdin	`"`s(in)'"'
	}

	local exclude permute statsby
	if `:list cmdname in exclude' ///
	 | ("`force'" == "" & bsubstr("`cmdname'",1,3) == "svy") {
		di as err "`cmdname' is not supported by permute"
		exit 199
	}

	// now check the rest of the options
	local 0 `", `options'"'
	syntax [,			///
		Reps(integer 100)	///
		SAving(string)		///
		DOUBle			/// not documented
		STRata(varlist)		///
		SEED(string)		///
		noDROP			///
		TRace			/// "prefix" options
		REJECT(string asis)	///
		nowarn			///
		EPS(real 1e-7)		/// -Results- options
		LEft RIght		///
		noHeader		///
		noLegend		///
		Verbose			///
		TItle(passthru)		///
		notable			/// not documented
		*			///
	]

	_get_dots_option, `options'
	local dots `"`s(dotsopt)'"'
	local nodots `"`s(nodots)'"'
	local noisily `"`s(noisily)'"'
	local options `"`s(options)'"'

	_get_diopts diopts, `options'
	if "`s(cformat)'" != "" {
		di as err "option cformat() not allowed"
		exit 198
	}
	if "`s(sformat)'" != "" {
		di as err "option sformat() not allowed"
		exit 198
	}
	if "`s(pformat)'" != "" {
		di as err "option pformat() not allowed"
		exit 198
	}
	// set the seed
	if "`seed'" != "" {
		`version' set seed `seed'
	}
	local seed `c(seed)'

	if "`trace'" != "" {
		local noisily noisily
		local traceon	set trace on
		local traceoff	set trace off
	}

	local star = cond("`nodots'"=="nodots", "*", "_dots")
	local noi = cond("`noisily'"=="", "*", "noisily")

	// preliminary parse of <exp_list>
	_prefix_explist `exp_list', stub(_pm_)
	local eqlist	`"`s(eqlist)'"'
	local idlist	`"`s(idlist)'"'
	local explist	`"`s(explist)'"'
	local eexplist	`"`s(eexplist)'"'

	_prefix_note `cmdname', `nodots'
	if "`noisily'" != "" {
		di "permute: First call to `cmdname' with data as is:" _n
		di as inp `". `xcommand'"'
	}

	// run the command using the entire dataset
	preserve
	_prefix_clear, e r
	`traceon'
	capture noisily quietly `noisily'		///
		`version' `xcommand'
	`traceoff'
	local rc = c(rc)
	local checkmat 0
	capture confirm matrix e(b) e(V)
        if !_rc {
                tempname fullmat
                _check_omit `fullmat',get
		local checkmat 1
        }
	// error occurred while running on entire dataset
	if `rc' {
		_prefix_run_error `rc' permute `cmdname'
	}
	// check for rejection of results from entire dataset
	if `"`reject'"' != "" {
		_prefix_reject permute `cmdname' : `reject'
		local reject `"`s(reject)'"'
	}

	// check e(sample)
	_prefix_check4esample permute `cmdname'
	if "`drop'" == "" {
		local keepesample `"`s(keep)'"'
	}
	if "`warn'" == "" {
		local diwarn	`"`s(diwarn)'"'
	}

	// expand eexp's that may be in eexplist, and build a matrix of the
	// computed values from all expressions
	tempname b
	_prefix_expand `b' `explist',		///
		stub(_pm_)			///
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
	local coleq	`"`s(ecoleq)' `s(coleq)'"'
	local colna	`"`s(ecolna)' `s(colna)'"'
	forval i = 1/`K' {
		local exp`i' `"`s(exp`i')'"'
	}
	// setup list of missings
	forvalues j = 1/`K' {
		local mis `mis' (.)
		if missing(`b'[1,`j']) {
			di as err ///
			`"'`exp`j''' evaluated to missing in full sample"'
			exit 322
		}
	}


	local ropts	eps(`eps')		///
			`left' `right'		///
			level(`level')		///
			`header'		///
			`verbose'		///
			`title'			///
			`table'			///
			`diopts'

	// check options
	if `reps' < 1 {
		di as err "reps() must be a positive integer"
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

	// keep only the estimation sample
	if `"`keep'"' != "" {
		quietly `keep'
		restore, not
		preserve
	}
	else {
		restore, preserve
		if "`cmdif'`cmdin'" != "" {
			quietly keep `cmdif' `cmdin'
		}
	}

	if `"`strata'"' != "" {
		if `:list permvar in strata' {
			di as err ///
"permutation variable may not be specified in strata() option"
			exit 198
		}
		tempvar sflag touse
		mark `touse'
		markout `touse' `strata'
		sort `touse' `strata', stable
		by `touse' `strata': gen `sflag' = _n==1 if `touse'
		qui replace `sflag' = sum(`sflag')
		local nstrata = `sflag'[_N]
		local ustrata `strata'
		local strata `sflag'
		sort `strata' , stable
	}

	local obs = _N
	if "`strata'"!="" {
		local bystrata "by `strata':"
	}
	if `eps' < 0 {
		di as err "eps() must be greater than or equal to zero"
		exit 198
	}

	// display the resample warning
	`diwarn'

	// temp variables for post
	local stats
	forvalues j = 1/`K' {
		tempname x`j'
		local stats `stats' (`b'[1,`j'])
		local xstats `xstats' (`x`j'')
	}

	// prepare post
	tempname postnam
	postfile `postnam' `names' using `"`saving'"', ///
		`double' `every' `replace'
	post `postnam' `stats'

	// check if `permvar' is a single dichotomous variable
	tempvar v
	qui summarize `permvar'
	local binary 0
	capture assert r(N)==_N & (`permvar'==r(min) | `permvar'==r(max))
	if c(rc)==0 {
		tempname min max
		scalar `min' = r(min)
		scalar `max' = r(max)

		qui `bystrata' gen long `v' = sum(`permvar'==`max')
		qui `bystrata' replace `v' = `v'[_N]

		local binary 1
	}
	else	gen `c(obs_t)' `v' = _n

	if "`star'" == "*" {
		local noiqui noisily quietly
	}

	// do permutations
	if "`nodots'" == "" | "`noisily'" != "" {
		di
		_dots 0, title(Permutation replications) reps(`reps') `nodots' `dots'
	}
	local rejected 0
	forvalues i = 1/`reps' {
		if `binary' {
			PermDiV "`strata'" `v' `min' `max' `permvar'
		}
		else {
			`version' PermVars "`strata'" `v' `permvar'
		}

		// analyze permuted data
		`noi' di as inp `". `command'"'
		`traceon'
		capture `noiqui' `noisily' `version' `command'
		`traceoff'
		if (c(rc) == 1) error 1
		local bad = c(rc) != 0
		if c(rc) {
			`noi' di in smcl as error ///
`"{p 0 0 2}an error occurred when permute executed `cmdname', "' ///
`"posting missing values{p_end}"'
			post `postnam' `mis'
		}
		else {
			if `checkmat' {
                                _check_omit `fullmat', check result(res)
                                if `res' {
                                        local bad 1
                                        `noi' di as error ///
`"{p 0 0 2}collinearity in replicate sample is "' ///
`"not the same as the full sample, posting missing values{p_end}"'
					post `postnam' `mis'
                                        `star' `i' `bad' , `dots'
                                        continue
                                }
                        }
			if `"`reject'"' != "" {
				capture local rejected = `reject'
				if c(rc) {
					local rejected 1
				}
			}
			if `rejected' {
				local bad 1
				`noi' di as error ///
`"{p 0 0 2}rejected results from `cmdname', "' ///
`"posting missing values{p_end}"'
				post `postnam' `mis'
			}
			else {
				forvalues j = 1/`K' {
					capture scalar `x`j'' = `exp`j''
					if (c(rc) == 1) error 1
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
				post `postnam' `xstats'
			}
		}
		`star' `i' `bad' , `dots'
	}
	`star' `reps' , `dots'

	// cleanup post
	postclose `postnam'

	// load file `saving' with permutation results and display output
	capture use `"`saving'"', clear
	if c(rc) {
		if c(rc) >= 900 & c(rc) <= 903 {
			di as err ///
"insufficient memory to load file with permutation results"
		}
		error c(rc)
	}
	label data `"permute `permvar' : `cmdname'"'

	// save permute characteristics and labels to data set
	forvalues i = 1/`K' {
		local name : word `i' of `names'
		local x = `name'[1]
		char `name'[permute] `x'
		local label = usubstr(`"`exp`i''"',1,80)
		label variable `name' `"`label'"'
		char `name'[expression] `"`exp`i''"'
		if `"`coleq'"' != "" {
			local na : word `i' of `colna'
			local eq : word `i' of `coleq'
			char `name'[coleq] `eq'
			char `name'[colname] `na'
			if `i' <= `k_eexp' {
				char `name'[is_eexp] 1
			}
		}
	}
	char _dta[k_eq] `k_eq'
	char _dta[k_eexp] `k_eexp'
	char _dta[k_exp] `k_exp'
	char _dta[N_strata] `nstrata'
	char _dta[strata] `ustrata'
	char _dta[N] `obs'
	char _dta[seed] "`seed'"
	char _dta[permvar] "`permvar'"
	char _dta[command] "`command'"
	char _dta[pm_version] 2
	quietly drop in 1

	if `"`filetmp'"' == "" {
		quietly save `"`saving'"', replace
	}

	ClearE
	Results, `ropts'
	return add
	return scalar N_reps = `reps'
end

program Results
	syntax [anything(name=namelist)]	///
		[using/] [,			///
			eps(real 1e-7)		/// -GetResults- options
			left			///
			right			///
			TItle(passthru)		///
			Level(cilevel)		/// -DisplayResults- options
			noHeader		///
			noLegend		///
			Verbose			///
			notable			/// not documented
			*			///
		]

	_get_diopts diopts, `options'
	if `"`using'"' != "" {
		preserve
		qui use `"`using'"', clear
	}
	else if `"`namelist'"' != "" {
		local namelist : list uniq namelist
		preserve
	}
	local 0 `namelist'
	syntax [varlist(numeric)]
	if "`namelist'" != "" {
		keep `namelist'
		local 0
		syntax [varlist]
	}

	GetResults `varlist',	///
		eps(`eps')	///
		`left' `right'	///
		level(`level')	///
		`title'
	DisplayResults, `header' `table' `legend' `verbose' `diopts'
end

program GetResults, rclass
	syntax varlist [,		///
		Level(cilevel)		///
		eps(real 1e-7)		///
		left			///
		right			///
		TItle(string asis)	///
	]

	// get data characteristics
	// data version
	local version : char _dta[pm_version]
	capture confirm integer number `version'
	if c(rc) | "`version'" == "" {
		local version 1
	}
	else if `version' <= 0 {
		local version 1
	}
	// original number of observations
	local obs : char _dta[N]
	if "`obs'" != "" {
		capture confirm integer number `obs'
		if c(rc) {
			local obs
		}
		else if `obs' <= 0 {
			local obs
		}
	}
	// number of strata
	local nstrata : char _dta[N_strata]
	if "`nstrata'" != "" {
		capture confirm integer number `nstrata'
		if c(rc) {
			local nstrata
		}
	}
	// strata variable
	if "`nstrata'" != "" {
		local strata : char _dta[strata]
		if "`strata'" != "" {
			capture confirm names `strata'
			if c(rc) {
				local strata
			}
		}
	}
	// permutation variable
	local permvar : char _dta[permvar]
	capture confirm name `permvar'
	if c(rc) | `:word count `permvar'' != 1 {
		local permvar
	}
	if `"`permvar'"' == "" {
		di as error ///
"permutation variable name not present as data characteristic"
		exit 9
	}

	// requested event
	GetEvent, `left' `right' eps(`eps')
	local event `s(event)'
	local rel `s(rel)'
	local abs `s(abs)'
	local minus `"`s(minus)'"'

	tempvar diff
	gen `diff' = 0
	local K : word count `varlist'
	tempname b c reps p se ci
	matrix `b' = J(1,`K',0)
	matrix `c' = J(1,`K',0)
	matrix `reps' = J(1,`K',0)
	matrix `p' = J(1,`K',0)
	matrix `se' = J(1,`K',0)
	matrix `ci' = J(1,`K',0) \ J(1,`K',0)

	local seed : char _dta[seed]
	local k_eexp 0
	forvalues j = 1/`K' {
		local name : word `j' of `varlist'
		local value : char `name'[permute]
		capture matrix `b'[1,`j'] = `value'
		if c(rc) | missing(`value') {
			di as err ///
`"estimates of observed statistic for `name' not found"'
			exit 111
		}
		quietly replace ///
		`diff' = (`abs'(`name') `rel' `abs'(`value') `minus' `eps')
		sum `diff' if `name'<., meanonly
		if r(N) < c(N) {
			local missing missing
		}
		mat `c'[1,`j'] = r(sum)
		mat `reps'[1,`j'] = r(N)
		quietly cii `=`reps'[1,`j']' `=`c'[1,`j']', level(`level')
		mat `p'[1,`j'] = r(mean)
		mat `se'[1,`j'] = r(se)
		mat `ci'[1,`j'] = r(lb)
		mat `ci'[2,`j'] = r(ub)
		local coleq `"`coleq' `"`:char `name'[coleq]'"'"'
		local colname `colname' `:char `name'[colname]'
		if `version' >= 2 {
			local exp`j' : char `name'[expression]
		}
		if `"`:char `name'[is_eexp]'"' == "1" {
			local ++k_eexp	
		}
	}
	local coleq : list clean coleq

	if `version' >= 2 {
		// command executed for each permutation
		local command : char _dta[command]
		local k_exp = `K' - `k_eexp'
	}
	else {
		local k_eexp 0
		local k_exp 0
	}

	// put stripes on matrices
	if `"`coleq'"' == "" {
		version 11: matrix colnames `b' = `varlist'
	}
	else {
		version 11: matrix colnames `b' = `colname'
		if `"`coleq'"' != "" {
			version 11: matrix coleq `b' = `coleq'
		}
	}
	matrix rowname `b' = y1
	_copy_mat_stripes `c' `reps' `p' `se' `ci' : `b', novar
	matrix rowname `ci' = ll ul
	matrix roweq `ci' = _ _

	// Save results
	return clear
	return hidden scalar version = `version'
	if "`obs'" != "" {
		return scalar N = `obs'
	}
	return scalar level = `level'
	return scalar k_eexp = `k_eexp'
	return scalar k_exp = `k_exp'
	return matrix reps `reps'
	return matrix c `c'
	return matrix b `b'
	return matrix p `p'
	return matrix se `se'
	return matrix ci `ci'
	return hidden local seed `seed'
	return local rngstate `seed'
	return local missing `missing'
	return local permvar `permvar'
	if "`nstrata'" != "" {
		return scalar N_strata = `nstrata'
		if "`strata'" != "" {
			return local strata `strata'
		}
	}
	return local event `event'
	return local left `left'
	return local right `right'
	forval i = 1/`K' {
		return local exp`i' `"`exp`i''"'
	}
	if `"`title'"' != "" {
		return local title `"`title'"'
	}
	else	return local title "Monte Carlo permutation results"
	return local command `"`command'"'
	return local cmd permute
end

program DisplayResults, rclass
	syntax [,			///
		noHeader		///
		noLegend		///
		Verbose			///
		notable			///
		*			///
	]

	_get_diopts diopts, `options'
	if "`header'" == "" {
		_coef_table_header, rclass
		if r(version) >= 2 & "`legend'" == "" {
			_prefix_legend permute, rclass `verbose'
			di as txt %`s(col1)'s "permute var" ":  `r(permvar)'"
		}
	}

	// NOTE: _coef_table_header needs the results in r() to work properly,
	// thus the following line happens here instead of at the very top.
	return add

	if ("`table'" != "") {
		exit
	}
	else if "`header'" == "" {
		di
	}

	tempname Tab results
	.`Tab' = ._tab.new, col(8) lmargin(0) ignore(.b)
	ret list
	// column           1      2     3     4     5     6     7     8
	.`Tab'.width	   13    |12     8     8     8     8    10    10
	.`Tab'.titlefmt %-12s      .     .     .     .     .  %20s     .
	.`Tab'.pad	    .      2     0     0     0     0     0     1
	.`Tab'.numfmt       .  %9.0g     .     . %7.4f %7.4f     .     .

	local cil `=string(`return(level)')'
	local cil `=length("`cil'")'
	if `cil' == 2 {
		local cititle "Conf. Interval"
	}
	else {
		local cititle "Conf. Int."
	}
                                                                                
	// begin display
	.`Tab'.sep, top
	.`Tab'.titles "T" "T(obs)" "c" "n" "p=c/n" "SE(p)" ///
		"[`return(level)'% `cititle']" ""

	tempname b c reps p se ci
	matrix `b' = return(b)
	matrix `c' = return(c)
	matrix `reps' = return(reps)
	matrix `p' = return(p)
	matrix `se' = return(se)
	matrix `ci' = return(ci)
	local K = colsof(`b')
	local colname : colname `b'
	local coleq   : coleq `b', quote
	local coleq   : list clean coleq
	if `"`:list uniq coleq'"' == "_" {
		local coleq
		.`Tab'.sep
	}
	local error5 "  (omitted)"
	local error6 "  (base)   "
	local error7 "  (empty)  "
	gettoken start : colname
	local ieq 0
	local i 1
	local output 0
	local first	// starts empty
	forvalues j = 1/`K' {
		local curreq : word `j' of `coleq'
		if "`curreq'" != "`eq'" {
			.`Tab'.sep
			di as res %-12s abbrev("`curreq'",12) as txt " {c |}"
			local eq `curreq'
			local i 1
			local ++ieq
		}
		else if "`name'" == "`start'" {
			.`Tab'.sep
		}
		_ms_display, el(`i') eq(#`ieq') matrix(`b') `first' `diopts'
		if r(output) {
			local first
			if !`output' {
				local output 1
			}
		}
		else {
			if r(first) {
				local first first
			}
			local ++i
			continue
		}
		local note	`"`r(note)'"'
		local err 0
		if "`note'" == "(base)" {
			local err 6
		}
		if "`note'" == "(empty)" {
			local err 7
		}
		if "`note'" == "(omitted)" {
			local err 5
		}
		.`Tab'.width . 13 . . . . . ., noreformat
		if `err' {
			local note : copy local error`err'
			.`Tab'.row "" "`note'" .b .b .b .b .b .b
		}
		else {
			.`Tab'.row ""		///
				`b'[1,`j']	///
				`c'[1,`j']	///
				`reps'[1,`j']	///
				`p'[1,`j']	///
				`se'[1,`j']	///
				`ci'[1,`j']	///
				`ci'[2,`j']	///
				// blank
		}
		.`Tab'.width . |12 . . . . . ., noreformat
		local ++i
	}
	.`Tab'.sep, bottom
	TableFoot "`return(event)'" `K' `return(missing)'
end

program ClearE, eclass
	ereturn clear
end

program GetEvent, sclass
	sret clear
	syntax [, left right eps(string)]
	if "`left'"!="" & "`right'"!="" {
		di as err "only one of left or right can be specified"
		exit 198
	}
	if "`left'"!="" {
		sreturn local event "T <= T(obs)"
		sreturn local rel "<="
		sreturn local minus "+"
	}
	else if "`right'"!="" {
		sreturn local event "T >= T(obs)"
		sreturn local rel ">="
		sreturn local minus "-"
	}
	else {
		sreturn local event "|T| >= |T(obs)|"
		sreturn local rel ">="
		sreturn local abs "abs"
		sreturn local minus "-"
	}
end

program PermVars // "byvars" k var
	version 9
	local vv = _caller()
	args strata k x
	tempvar r y
	quietly {
		if `vv' <= 9 {
			if "`strata'"!="" {
				by `strata': gen double `r' = uniform()
			}
			else	gen double `r' = uniform()
		}
		else {
			tempname w
			gen double `r' = uniform()
			gen double `w' = uniform()
		}

		sort `strata' `r' `w'
		local type : type `x'
		gen `type' `y' = `x'[`k']
		drop `x'
		rename `y' `x'
	}
end

program PermDiV // "byvars" k min max var
	version 9
	args strata k min max x
	tempvar y
	if "`strata'"!="" {
		sort `strata'
		local bystrata "by `strata':"
	}
	quietly {
		gen byte `y' = . in 1
		`bystrata' replace `y' = ///
			uniform()<(`k'-sum(`y'[_n-1]))/(_N-_n+1)
		replace `x' = cond(`y',`max',`min')
	}
end

program TableFoot
	args event K missing
	if `K' == 1 {
		di as txt ///
"Note: Confidence interval is with respect to p=c/n."
	}
	else {
		di as txt ///
"Note: Confidence intervals are with respect to p=c/n."
	}
	if "`event'"!="" {
		di in smcl as txt "Note: c = #{`event'}"
	}
	if "`missing'" == "missing" {
		di as txt ///
"Note: Missing values observed in permutation replicates."
	}
end

exit

----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
Logit estimates                                   Number of obs   =        100
                                                  LR chi2(1)      =       0.83
                                                  Prob > chi2     =     0.3610
Log likelihood = -5.1830091                       Pseudo R2       =     0.0745
        
------------------------------------------------------------------------------
           y |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
           x |  -3.712523   4.739402    -0.78   0.433    -13.00158    5.576535
       _cons |  -3.374606   1.441799    -2.34   0.019    -6.200481   -.5487309
------------------------------------------------------------------------------
        
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
Monte Carlo Permutation Statistics                Number of obs    =        74
                                                  Replications     =       100

------------------------------------------------------------------------------
T            |     T(obs)       c       n   p=c/n   SE(p) [95% Conf. Interval]
-------------+----------------------------------------------------------------
_pm1         |   24.77273       0     100  0.0000  0.0000         0   .0362167 
------------------------------------------------------------------------------
Note:  Confidence interval(s) are with respect to p=c/n.
Note:  c = #{|T| >= |T(obs)|}
