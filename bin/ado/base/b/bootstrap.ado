*! version 4.9.1  07aug2019
program bootstrap, eclass
	version 9, missing
	local version : di "version " string(_caller()) ", missing:"

	set prefix bootstrap

	if _caller() < 9 {
		capture syntax [anything] using [, * ]
		if !c(rc) {
			if _by() {
				error 190
			}
			`version' bootstrap_8 `0'
			exit
		}
	}

	// Stata 8 syntax
	capture _on_colon_parse `0'
	if c(rc) | `"`s(after)'"' == "" {
		gettoken old : 0 , qed(qed)
		if `qed' {
			`version' bootstrap_8 `0'
			exit
		}
		else if "`old'" != "" {
			capture which `old'
			if !c(rc) {
				`version' bootstrap_8 `0'
				exit
			}
			capture program list `old'
			if !c(rc) {
				`version' bootstrap_8 `0'
				exit
			}
		}

		// replay output
		capture syntax [, * ]
		if !c(rc) {
			if _caller() < 9 {
				`version' bootstrap_8 `0'
				exit
			}
			if "`e(prefix)'" == "svy" {
				`version' svy `0'
				exit
			}
			if "`e(prefix)'" != "bootstrap" {
				error 301
			}
			`version' Display `0'
			exit
		}
		else {
			`version' bootstrap_8 `0'
			exit
		}
	}

	quietly ssd query
	if (r(isSSD)) {
		di as err "bootstrap not possible with summary statistic data"
		exit 111
	}
	`version' BootStrap `0'
	ereturn local cmdline `"bootstrap `0'"'
end

program BootStrap, eclass
	version 9
	local version : di "version " string(_caller()) ":"

	// <my_stuff> : <command>
	_on_colon_parse `0'
	local command `"`s(after)'"'
	local 0 `"`s(before)'"'

	// quick check for -force- and -nodrop- options
	syntax [anything(name=exp_list equalok)]	///
		[fw iw pw aw] [if] [in] [,		///
			FORCE				///
			noDROP				///
			CLuster(passthru)		///
			IDCLUSTVAR			/// NOT DOCUMENTED
			IDcluster(name)			///
			group(varname)			///
			NOECLUSTER			///
			Level(passthru)			///
			COEF				///
			SVY				///
			NOCLEAR				/// NOT DOCUMENTED
			ALTCMDNAME(name)		/// NOT DOCUMENTED
			*				/// other options
		]
	if "`svy'" != "" {
		`version' _svy_bs `0' : `command'
		exit
	}
	_get_eformopts, soptions eformopts(`options') allowed(__all__)
	local options `"`s(options)'"'
	local efopt = cond(`"`s(opt)'"'=="",`"`s(eform)'"',`"`s(opt)'"')

	if "`weight'" != "" {
		local wgt [`weight'`exp']
	}
	if "`force'" == "" {
		local checkbs checkbs
	}

	// parse the command and check for conflicts
	`version' _prefix_command bootstrap `wgt' `if' `in' , `coef' ///
		`efopt' `cluster' `level' checkcluster `checkbs': `command'

	local version	`"`s(version)'"'
	local cmdname	`"`s(cmdname)'"'
	local cmdargs	`"`s(anything)'"'
	local wgt	`"`s(wgt)'"'
	local wtype	`"`s(wtype)'"'
	local wexp	`"`s(wexp)'"'
	local cluster	`"`s(cluster)'"'
	local rest	`"`s(rest)'"'
	local efopt	`"`s(efopt)'"'
	local level	`"`s(level)'"'
	if "`level'" != "" {
		local level level(`level')
	}
	// command initially executed using entire dataset
	local xcommand	`"`s(command)'"'
	local cmdopts	`"`s(options)'"'
	CheckLRMODEL `cmdname', `cmdopts'
	_get_diopts diopts cmdopts, `cmdopts'
	if "`cmdname'" == "sem" {
		// -sem- has some unique display options
		sem_parse_display semdiopts cmdopts, `cmdopts'
	}

	is_st `cmdname'
	local is_st = r(is_st)
	if `is_st' & `"`force'"' == "" {
		local wgt : char _dta[st_w]
	}
	if "`force'" == "" & `"`wgt'"' != "" {
		// bootstrap does not allow weights
		local 0 `wgt'
		syntax [, NONOPTION ]
	}
	if `is_st' {
		local wgt
	}

	local not_allowed dprobit mswitch threshold menl dsge
	if `:list cmdname in not_allowed' {
		di as err "{p}prefix command {bf:bootstrap} not allowed with"
		di as err "{bf:`cmdname'}{p_end}"
		exit 322
	}

	if `"`efopt'"' != "" & !inlist(`"`:list retok exp_list'"', "", "_b") {
		local efopt
	}

	local tsop 0
	if "`cluster'" != "" {
	    local cmdprops : properties `cmdname'
	    if !`:list posof "cm" in cmdprops' {
		capture tsset, query
		if !c(rc) & "`r(panelvar)'" != "" {
			local tsop 1
			local panelvar `r(panelvar)'
			local timevar `r(timevar)'
		}
	    }
	}

	if !`tsop' {
		local j = 1
		local junk : piece `j' `c(maxstrvarlen)' ///
			of `"`cmdargs'"', nobreak
		while `"`junk'"' != "" {
			local hastsop = ///
                          regexm(`"`junk'"', "[lLfFdDsS][0-9]*C*c*\.")
			if `hastsop' != 0 & !`:list posof "cmxtbs" in cmdprops' {
				di as err "{p 0 0 2}" ///
"time-series operators are not allowed with bootstrap " ///
"without panels, see {help tsset##|_new:tsset}{p_end}"
				exit 198
			}
			local ++j
			local junk : piece `j' `c(maxstrvarlen)' ///
				of `"`cmdargs'"', nobreak
		}
	}

	is_svysum `cmdname'
	local is_sum = r(is_svysum)

	if `"`cluster'"' == "" {
		if `"`idcluster'"' != "" {
			di as err ///
"idcluster() can only be specified with the cluster() option"
			exit 198
		}
	}
	if `"`idcluster'"' == "" {
		if `"`group'"' != "" {
			di as err ///
"group() can only be specified with the idcluster() option"
			exit 198
		}
	}

	if "`drop'" == "" {
		local cmdif	`"`s(if)'"'
		local cmdin	`"`s(in)'"'
	}

	local exclude bs bstrap bootstrap jknife jacknife jackknife statsby
	if `:list cmdname in exclude' ///
	 | ("`force'" == "" & bsubstr("`cmdname'",1,3) == "svy") {
		di as err "`cmdname' is not supported by bootstrap"
		exit 199
	}

	// now check the rest of the options
	local 0 `", `options'"'
	syntax [,				///
		Reps(integer 50)		///
		SAving(string)			///
		DOUBle				/// not documented
		MSE				///
		SIze(string)			/// bsample opts
		STRata(varlist)			///
		SEED(string)			///
		TRace				/// "prefix" options
		REJECT(string asis)		///
		nowarn				///
		bca				///
		TIEs				///
		notable				/// -Display- opts
		TItle(string asis)		///
		noHeader			///
		noLegend			///
		Verbose				///
		JACKknifeopts(string asis)	///
		*				///
	]

	_get_dots_option, `options'
	local dots `"`s(dotsopt)'"'
	local nodots `"`s(nodots)'"'
	local noisily `"`s(noisily)'"'
	local options `"`s(options)'"'

	_get_diopts diopts, `diopts' `options'
	local diopts	`diopts'		///
			`table'			///
			`header'		///
			`legend'		///
			`efopt'			///
			`level'			///
			`semdiopts'		///
			// blank

	// preliminary parse of <exp_list>
	_prefix_explist `exp_list', stub(_bs_)
	local eqlist	`"`s(eqlist)'"'
	local idlist	`"`s(idlist)'"'
	local explist	`"`s(explist)'"'
	local eexplist	`"`s(eexplist)'"'

	if `"`bca'"' == "" {
		if `"`altcmdname'"' != "" {
			_prefix_note `altcmdname', `nodots'
		}
		else {
			_prefix_note `cmdname', `nodots'
		}
	}
	if "`noisily'" != "" {
		di "bootstrap: First call to `cmdname' with data as is:" _n
		di as inp `". `xcommand'"'
	}

	capture confirm new var `idcluster'
	if "`idcluster'" != "" & !c(rc) {
		quietly egen `idcluster' = group(`cluster')
	}

	tempvar touse
	mark `touse' `cmdif' `cmdin'

	// run the command using the entire dataset
	if "`noclear'" == "" {
		_prefix_clear, e r
	}
	`traceon'
	capture noisily quietly `noisily' `version' `xcommand'
	`traceoff'
	local rc = c(rc)
	// error occurred while running on entire dataset
	if `rc' {
		_prefix_run_error `rc' bootstrap `cmdname'
	}
	// do a preliminary check (or some other processing) based
	// on first full run
	_prefix_validate bootstrap `cmdname'
	// check for rejection of results from entire dataset
	if `"`reject'"' != "" {
		_prefix_reject bootstrap `cmdname' : `reject'
		local reject `"`s(reject)'"'
	}
	capture confirm matrix e(b) e(V)
	if !_rc {
		tempname fullmat
		_check_omit `fullmat', get
		local checkmat "checkmat(`fullmat')"
	}

	if "`drop'" == "" {
		// check e(sample)
		_prefix_check4esample bootstrap `cmdname'
		local keepesample `"`s(keep)'"'
	}
	if "`warn'" == "" {
		local diwarn	`"`s(diwarn)'"'
	}

        // Determine whether esample needs to be modified for xt with ts
        local xttsesample 0
        local cmxtbs : list posof "cmxtbs" in cmdprops
	if ("`drop'" == "" & `cmxtbs') {
                local j 1
                local junk : piece `j' `c(maxstrvarlen)' ///
                        of `"`cmdargs'"', nobreak
                while `"`junk'"' != "" {
                        local hastsop = ///
                          regexm(`"`junk'"', "[lLfFdDsS][0-9]*C*c*\.")
                        if `hastsop' != 0 {
                                local xttsesample 1
                                continue, break
                        }
                        local ++j
                        local junk : piece `j' `c(maxstrvarlen)' ///
                                of `"`cmdargs'"', nobreak
                }
	}
	else if ("`timevar'" != "" & "`drop'" == "") {
		local xttsesample 1
        }

	// determine default <exp_list>, or generate an error message
	if `"`exp_list'"' == "" {
		_prefix_explist, stub(_bs_) edefault
		local eqlist	`"`s(eqlist)'"'
		local idlist	`"`s(idlist)'"'
		local explist	`"`s(explist)'"'
		local eexplist	`"`s(eexplist)'"'
	}
	// expand eexp's that may be in eexplist, and build a matrix of the
	// computed values from all expressions
	tempname b
	_prefix_expand `b' `explist',		///
		stub(_bs_)			///
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
	local eexpress	`"`s(eexplist)'"'
	local coleq	`"`s(ecoleq)' `s(coleq)'"'
	local colna	`"`s(ecolna)' `s(colna)'"'
	forval i = 1/`K' {
		local exp`i' `"`s(exp`i')'"'
		if missing(`b'[1,`i']) {
			di as err ///
`"'`exp`i''' evaluated to missing in full sample"'
			exit 322
		}
	}
	is_svysum `cmdname'
	local is_sum = r(is_svysum)
	if "`drop'" != "" {
		// command with [if] [in]
		local command	`"`xcommand'"'
	}
	else {
		if `is_sum' {
			_prefix_checkopt over(passthru), `cmdopts'
			if `"`s(over)'"' != "" {
				tempname subuse
				local cmdopts `cmdopts' sovar(`subuse')
				local overopt `"`s(over)'"'
			}
		}
		if `is_sum' & `k_exp' == 0 & "`eexpress'" == "(_b)" {
			// speed things up with the -novariance-
			_prefix_checkopt NOVARiance, `cmdopts'
			if `"`noisily'`s(novariance)'"' == "" {
				local novar " novar"
			}
		}

		// command without [if] [in]
		local command	`"`cmdname' `cmdargs' `wgt'"'
		local command : list retok command
		if `"`cmdopts'"' != "" {
			local command `"`command', `cmdopts' `novar'`rest'"'
		}
		else if "`novar'" != "" {
			local command `"`command', `novar'`rest'"'
		}
		else	local command `"`command'`rest'"'
	}

	// check options
	if `reps' < 2 {
		di as err "reps() must be an integer greater than 1"
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

	// set the seed
	if "`seed'" != "" {
		`version' set seed `seed'
	}
	local seed `c(seed)'

	// display the resample warning
	`diwarn'

	if `"`strata'`cluster'"' != "" {
		markout `touse' `strata' `cluster', strok
	}
	if `"`keepesample'"' != "" {
                if `xttsesample' {
                        tempvar samp hasob touse_rev
                        generate `samp' = e(sample)
                        bys `cluster' : egen byte `hasob' = max(`samp')
                        qui gen byte `touse_rev' = `touse' 
                        quietly replace `touse_rev' = 0 if ! e(sample)
                        quietly replace `touse' = 0 if !`hasob'
                }
                else {
                        quietly replace `touse' = 0 if ! e(sample)
                }
	}
	if `is_sum' & `:length local overopt' {
		_svy_subpop `touse' `subuse', `overopt'
	}

	// keep only the estimation sample
	preserve
	if `"`keepesample'"' != "" {
                if `xttsesample' {
                        qui count if e(sample)
                        local obs = r(N)
                        qui keep if `touse'
                }
                else {
                        quietly `keepesample'
                }
	}
	else if `"`cmdif'`cmdin'"' != "" {
		quietly keep if `touse'
	}
	if `"`strata'`cluster'"' != "" {
		sort `touse' `strata' `cluster', stable
	}
	// get strata information
	if `"`strata'"' != "" {
		local ustrata `strata'
		tempvar sflag
		by `touse' `strata': gen `sflag' = _n==1
		quietly replace `sflag' = sum(`sflag') if `touse'
		local nstrata = `sflag'[_N]
		local strataopt strata(`sflag')
		local strata `sflag'
		sort `touse' `strata' `cluster', stable
	}
	// bsample prefers call without arguments
	if `"`size'"' == "_N" {
		local size
	}
	// if clusters, count them
        if ("`obs'" == "")  {
	        local obs = _N
        }
	if "`cluster'" != "" {
		foreach clname of local cluster {
			capture assert ! missing(`clname')
			if c(rc) {
				di as err ///
`"missing values in cluster variable `clname' not allowed"'
				exit 459
			}
		}
		if `"`strata'"' != "" {
			local bystrata by `touse' `strata':
		}
		tempvar cflag
		quietly by `touse' `strata' `cluster': ///
			gen `cflag' = (_n==1) if `touse'
		quietly count if `cflag'
		// total number of clusters
		local nclust = r(N)
		quietly `bystrata' replace `cflag' = sum(`cflag')
		// number of clusters per strata
		quietly `bystrata' replace `cflag' = `cflag'[_N]
		
		if "`size'" != "" {
			capture assert `size' <= `cflag'
			if c(rc) {
				di as err ///
"size() must not be greater than number of clusters"
				exit 498
			}
		}
		local clustopts cluster(`cluster')
	}

nobreak {
capture noisily break {

	local buildfv 0
	if "`eexpress'" == "(_b)" {
		if `k_extra' == 0 &		///
		   !inlist("`cmdname'", "anova", "boot", "manova") {
			if `"`e(V)'"' == "matrix" {
				tempname V_model
				matrix `V_model' = e(V)
			}
			// try to use the cmdnames's replay routine
			capture findfile `cmdname'.ado
			if !c(rc) & bsubstr("`cmdname'",1,3) != "svy" {
				capture `cmdname', `diopts'
				if !c(rc) {
					local replay `cmdname'
				}
			}
		}
		if `k_extra' == 0 {
			local buildfv 1
			local coeftabresults `"`c(coeftabresults)'"'
			set coeftabresults off
			tempname H I
			_prefix_getinfo `H' `I'
		}
		tempname esave
		if "`e(cmd)'" == "" {
			tempname tcmd
			ereturn local cmd `tcmd'
		}
		estimates store `esave'
	}

	// jackknife estimates of acceleration
	if `"`bca'"' != "" {
		// expand the expression list
		forvalues i = 1/`K' {
			tempname name
			local exp_list `exp_list' `name'=(`exp`i'')
		}
		if "`cluster'" != "" {
			local clopt cluster(`cluster')
		}
		if "`nodots'`noisily'`trace'" == "" {
			local jkopts notable noheader
		}
		else {
			local jkopts `nodots' `noisily' `trace'
			local qui quietly
		}
		local jkopts `jkopts' `jackknifeopts'
		`qui' `noisily' `version' JKAccel		///
			`exp_list' ,				///
			keep					///
			`clopt' `jkopts' `drop'			///
			reject(`reject')			///
			: `command'
		if "`r(accel)'" == "matrix" {
			tempname accel
			matrix `accel' = r(accel)
		}
		else	local bca
	}
	else if `:length local jackknifeopts' {
		di as err "option jackknifeopts() requires the bca option"
		exit 198
	}

	// prepare post
	tempname postid
	postfile `postid' `names' using `"`saving'"', ///
		`double' `every' `replace'

	// bsample, compute and post
	if `"`idcluster'"' != "" {
		local clustopts `clustopts' idcluster(`idcluster')
	}

	`version' _loop_bs,				///
		cmdname(`cmdname')			///
		command(`command')			///
		express(`express')			///
		postid(`postid')			///
		size(`size')				///
		reps(`reps')				///
		`strataopt'				///
		`clustopts'				///
		`nodots'				///
		`dots'					///
		`noisily'				///
		`trace'					///
		reject(`reject')			///
		group(`group')				///
		panelvar(`panelvar')			///
		`checkmat'				///
		timevar(`timevar')

} // capture noisily break

	local rc = c(rc)

	// cleanup post
	if "`postid'" != "" {
		postclose `postid'
	}

	if "`esave'" != "" {
		if `rc' {
			quietly estimates drop `esave'
		}
		else {
			quietly estimates restore `esave', drop
			if "`tcmd'" != "" {
				ereturn local cmd
			}
		}
	}

} // nobreak

	if (`rc') exit `rc'

	// load file with bootstrap results and display output
	capture use `"`saving'"', clear
	if c(rc) {
		if inrange(c(rc),900,903) {
			di as err ///
"insufficient memory to load file with bootstrap results"
		}
		error c(rc)
	}

	// fix the column stripes
	if "`eexpress'" == "(_b)" ///
	 & inlist("`cmdname'", "ologit", "oprobit") ///
	 & missing(e(version)) {
		_prefix_relabel_eqns `b'
		local k_eq = s(k_eq)
		local k_aux = `k_eq' - 1
		local colna : colna `b'
		local coleq : coleq `b'
	}

	// save bootstrap characteristics and labels to data set
	label data `"bootstrap: `cmdname'"'
	char _dta[command]	`"`command'"'
	char _dta[seed]		`"`seed'"'
	char _dta[N_cluster] 	`nclust'
	char _dta[cluster] 	`cluster'
	char _dta[strata]	`ustrata'
	char _dta[N_strata]	`nstrata'
	char _dta[N]		`obs'
	char _dta[bs_version]	3
	char _dta[k_eq]		`k_eq'
	char _dta[k_extra]	`k_extra'
	forvalues i = 1/`K' {
		local name : word `i' of `names'
		char `name'[observed] `= `b'[1,`i'] '
		if `"`bca'"' != "" {
			char `name'[acceleration] `= `accel'[1,`i'] '
		}
		local label = usubstr(`"`exp`i''"',1,80)
		label variable `name' `"`label'"'
		char `name'[expression] `"`exp`i''"'
		if `"`coleq'"' != "" {
			char `name'[colname]
			local na : word `i' of `colna'
			local eq : word `i' of `coleq'
			if substr(`"`eq'"',1,1) == "/" {
				local eq `"`eq':"'
			}
			char `name'[coleq] `eq'
			char `name'[colname] `na'
			if `i' <= `k_eexp' {
				char `name'[is_eexp] 1
			}
		}
	}

	if `"`filetmp'"' == "" {
		quietly save `"`saving'"', replace
	}

	// compute results
	tempname bs_v
	capture noisily `version' _bs_sum, `level' `mse' `ties'
	if c(rc) {
		ereturn clear
		exit c(rc)
	}
	matrix `bs_v' = r(V)
	restore

	if "`eexpress'" == "(_b)" & `k_extra' == 0 {
		// make a copy of what is in -e()-, with some eXclusions
		local xmac cmd _estimates_name chi2type novariance
		if "`noecluster'" == "" {
			local xmac `xmac' clustvar
		}
		if "`e(cmd)'" == "manova" {
			local xmac `xmac' r2 rmse
		}
		if "`cmdname'" == "sem" {
			local xmat `xmat' V_std
		}
		local xsca F chi2 df_r df_m
		local xmat b V
		if "`e(cmd)'" != "`cmdname'" {
			local ecmd `e(cmd)'
		}
		else	local ecmd `cmdname'
		_e2r, xmac(`xmac') xsca(`xsca') xmat(`xmat') add
		if "`e(depvar)'" != "" {
			local depvar `e(depvar)'
			if `:word count `depvar'' == 1 {
				local depname	depname(`depvar')
			}
		}
	}
	if "`:word 1 of `eexpress''" == "(_b)" {
		tempname Cns
		capture mat `Cns' = get(Cns)
		if (c(rc)) local Cns
		else {
			// get constraints matrix for post
			local cols = colsof(`Cns')
			// note: if no other expressions were added, then the
			// constraint matrix has 1 more column than the
			// coefficient vector
			if `cols' <= colsof(`b') {
				// add columns of zeros for other statistics
				local colsm1 = `cols'-1
				local rows = rowsof(`Cns')
				local fill = colsof(`b')-`colsm1'
				tempname cns1 cns2
				mat `cns1' = `Cns'[1...,1..`colsm1']
				mat `cns2' = `Cns'[1...,`cols']
				mat `Cns' = `cns1',J(`rows',`fill',0),`cns2'
				matrix drop `cns1' `cns2'
			}
		}
	}

	if inlist("`cmdname'", "binreg", "glm") {
		if !missing(r(vf)) & r(vf) != 1 {
			matrix `bs_v' = r(vf)*`bs_v'
		}
	}

        // revert e(sample) for xt ts
        if (`xttsesample' & "`keepesample'" != "") {
                qui replace `touse' = `touse_rev'
        }

	// save results
	ereturn post `b' `bs_v' `Cns', obs(`obs') esample(`touse') ///
		`depname'

	// restore the copied elements back to -e()-
	_r2e, xmat(b V)
	_post_vce_rank
	if `buildfv' {
		_prefix_buildinfo `cmdname', h(`H') i(`I')
		set coeftabresults `coeftabresults'
	}
	_prefix_fvlabel `ecmd'
	if `:length local V_model' {
		ereturn matrix V_modelbased `V_model'
	}
	ereturn hidden local seed `seed'
	ereturn local rngstate `seed'
	ereturn scalar k_eq	= `k_eq'
	ereturn scalar k_exp	= `k_exp'
	ereturn scalar k_eexp	= `k_eexp'
	ereturn scalar k_extra	= `k_extra'
	if "`k_aux'" != "" {
		ereturn scalar k_aux = `k_aux'
	}
	if `"`title'"' != "" {
		ereturn local title `"`title'"'
	}
	else {
		_prefix_title `cmdname' "Bootstrap results"
		ereturn local title `"`r(title)'"'
	}
	if inlist("`wtype'","fweight","iweight") {
                tempvar wvar
                quietly gen `wvar' `wexp'
                sum `wvar' if e(sample), mean
                ereturn scalar N = r(sum)
	}
	else {
                quietly count if e(sample)
                ereturn scalar N = r(N)
	}
	ereturn local prefix bootstrap
	ereturn local cmdname `cmdname'
	if "`size'" != "" {
		ereturn local size `"`size'"'
	}
	if "`idclustvar'" != "" {
		ereturn local cluster	`idcluster'
	}
	if "`e(cluster)'" != "" {
		ereturn local clustvar = e(cluster)
	}
	if "`noecluster'" != "" {
		ereturn local cluster
	}
	// NOTE: this must be the last thing posted to -e()-
	if "`eexpress'`k_exp'" != "(_b)0" {
		ereturn hidden local predict _no_predict
		ereturn local cmd bootstrap
	}
	else {
		if !inlist("`e(predict)'", "", "_no_predict") &	///
		   !inlist("`ecmd'", "anova", "manova") {
			// compute e(chi2) and e(df_m)
			_prefix_model_test `cmdname'
		}
		if "`ecmd'" == "" {
			ereturn local cmd bootstrap
		}
		else {
			ereturn local cmd `ecmd'
			if `"`e(prefix_epilog)'"' != "" {
				`e(prefix_epilog)'
			}
		}
	}

	// Display output
	if "`replay'" != "" & "`table'`header'`legend'`verbose'" == "" {
		`version' `replay', `diopts'
	}
	else	`version' Display, `diopts'
end

program JKAccel, rclass

	jackknife `0'
	tempname accel
	matrix `accel' = e(b)
	local names `e(pseudo)'
	local K = colsof(`accel')

	// The following depends heavily on the fact that jackknife's
	// pseudovalues s[j]=N*s-(N-1)*s(j) and the leave one out values s(j)
	// are equivalent when calculating acceleration, i.e. skew(s[j]) =
	// -skew(s(j)).

	forvalues i = 1/`K' {
		local name : word `i' of `names'
		quietly summ `name', detail
		if r(mean) == 0 & r(sd) == 0 {
			matrix `accel'[1,`i'] = 0
		}
		else if missing(r(skewness)) {
			matrix `accel'[1,`i'] = .
		}
		else	matrix `accel'[1,`i'] = r(skewness)/(6*sqrt(r(N)))
		capture drop `name'
	}
	matrix colnames `accel' = `names'
	if matmissing(`accel') {
		di as txt _n "{p 0 0 2}" ///
"warning: jackknife returned missing acceleration estimates. BCa " ///
"confidence intervals cannot be computed." ///
"{p_end}"
	}
	else	return matrix accel `accel'
end

program Display, sclass
	version 9.2
	local version : di "version " string(_caller()) ":"
	local extra = `"`e(cmd)'"' != `"`e(cmdname)'"'
	if `"`e(cmd)'"' != "" {
		is_svysum `e(cmd)'
		local is_svysum = r(is_svysum)
		local svylist svyb svyj svyr
		local proplist : properties `e(cmd)'
		local svyable = `"`: list proplist & svylist'"' != ""
	}
	else {
		local is_svysum 0
		local svyable 0
	}
	if `extra' | `is_svysum' | `svyable' {
		_prefix_display `0'
		exit
	}
	syntax  [,			///
		notable			///
		TItle(passthru)		///
		noHeader		///
		noLegend		///
		Verbose			///
		*			///
	]
	if ("`table'" != "" & "`header'" != "") {
		sreturn local diopts `"`options'"'
		exit
	}
	if "`e(cmd)'" == "`e(cmdname)'" {
		if !inlist("`e(cmd)'", "anova", "manova") {
			`version' `e(cmd)', `options'
			exit
		}
	}
	_prefix_display `0'
end

program GetPanelVar, rclass
	capture tsset, noquery
	if ! c(rc) {
		local panelvar `r(panelvar)'
		local timevar `r(timevar)'
	}
	if "`panelvar'" == "" {
		capture _xt
		if !c(rc) {
			local panelvar `r(ivar)'
		}
	}
	if "`panelvar'" == "" {
		syntax [, I(varname) * ]
		local panelvar `"`i'"'
	}
	else if "`panelvar'" != "" {
		return local setpanel yes
	}
	return local panelvar `panelvar'
	return local timevar `timevar'
end

program CheckLRMODEL
	syntax name(name=cmdname) [, LRMODEL * ]
	if ("`lrmodel'"!="") {
		_check_lrmodel `cmdname', prefix(bootstrap)
	}
end

exit
