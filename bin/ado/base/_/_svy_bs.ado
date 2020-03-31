*! version 1.9.0  13dec2018
program _svy_bs, eclass sortpreserve
	version 11
	local version : di "version " string(_caller()) ":"

	// Stata 8 syntax
	capture _on_colon_parse `0'
	if c(rc) | `"`s(after)'"' == "" {
		if !c(rc) {
			local 0 `"`s(before)'"'
		}

		// replay output
		if replay() {
			if "`e(prefix)'`e(vce)'" != "svybootstrap" {
				error 301
			}
			svy `0'
			exit
		}
	}

	`version' SvyBS `0'
	ereturn local cmdline `"svy bootstrap `0'"'
end

program SvyBS, eclass
	version 11
	local version : di "version " string(_caller()) ":"

	// <my_stuff> : <command>
	_on_colon_parse `0'
	local command `"`s(after)'"'
	local 0 `"`s(before)'"'

	// quick check for -svy- and -nodrop- option
	syntax [anything(name=exp_list equalok)]	///
		[fw iw pw aw] [if] [in] [,		///
			COEF				/// for -logistic-
			SVY				///
			noDROP				///
			Level(passthru)			///
			FORCE				///
			*				/// other options
		]
	_get_eformopts, soptions eformopts(`options') allowed(__all__)
	local options `"`s(options)'"'
	local efopt = cond(`"`s(opt)'"'=="",`"`s(eform)'"',`"`s(opt)'"')

	if "`weight'" != "" {
		local wgt [`weight'`exp']
	}

	// parse the command and check for conflicts
	`version' _prefix_command bootstrap `wgt' `if' `in' , ///
		svy checkvce `coef' `efopt' `level': `command'
	local options `"`options' `s(prefix_options)'"'

	if `"`s(vce)'"' != "" {
		di as err "option vce() not allowed"
		exit 198
	}

	while inlist(`"`s(cmdname)'"', "svy", "bootstrap", "bstrap", "bs") {
		if `"`s(cmdname)'"' == "svy" & `"`s(cmdargs)'"' != "" {
			_svy_check_vce `vcetype'
			if `"`s(vce)'"' != "bootstrap" {
				error 198
			}
		}
		if `"`wgt'"' == "" & `"`s(wgt)'"' != "" {
			local wgt `"[`s(wgt)']"'
		}
		local if	`"`s(if)'"'
		local in	`"`s(in)'"'
		local efopt	`"`s(efopt)'"'
		local options `"`options' `s(cmdopts)'"'
		if `"`s(rest)'"' == "" {
			svy `wgt' `if' `in', ///
				`efopt' `cluster' `level' `options'
			exit
		}
		`version' _prefix_command bootstrap `wgt' `if' `in' , ///
			svy checkvce `efopt' `cluster' `level' ///
			checkcluster `s(rest)'
	}

	// note: weights are allowed only from -svyset-
	local version	`"`s(version)'"'
	local cmdname	`"`s(cmdname)'"'
	local cmdargs	`"`s(anything)'"'
	local cmdif	`"`s(if)'"'
	local cmdin	`"`s(in)'"'
	local rest	`"`s(rest)'"'
	local efopt	`"`s(efopt)'"'
	local command	`"`s(command)'"'
	local level	`"`s(level)'"'
	local cmdopts	`"`s(options)'"'
	_get_diopts diopts cmdopts, `cmdopts'
	if "`cmdname'" == "sem" {
		// -sem- has some unique display options
		sem_parse_display semdiopts cmdopts, `cmdopts'
	}

	if `"`efopt'"' != "" & !inlist(`"`:list retok exp_list'"', "", "_b") {
		local efopt
	}

	// -_svy_check_cmdopts- resets -s()-
	_svy_check_cmdopts `cmdname', vce(bootstrap) `cmdopts'
	local first	`"`s(first)'"'
	local chk_group	`"`s(check_group)'"'
	local cmdlog	`"`s(log)'"'
	local cmddiopts	`"`s(diopts)'"'

	local exclude brr jackknife jknife statsby
	if `:list cmdname in exclude' ///
	 | ("`force'" == "" & bsubstr("`cmdname'",1,3) == "svy") {
		di as err "`cmdname' is not supported by bootstrap"
		exit 199
	}

	if "`s(replay)'" != "" {
		if "`e(cmdname)'" == "`cmdname'" {
			svy, `options' `cmdopts' `efopt' level(`level') `rest'
			exit
		}
	}

	is_svysum `cmdname'
	local is_sum = r(is_svysum)
	is_st `cmdname'
	local is_st = r(is_st)
	if `is_st' {
		local stset stset
	}

	// now check the rest of the options
	local 0 `", `options'"'
	syntax [,				///
		BSN(numlist >0 max=1)		///
		SAving(string)			///
		DOUBle				/// not documented
		MSE MSE1			///
		TRace				/// "prefix" options
		REJECT(string asis)		///
		noHeader			/// Display options
		noLegend			///
		notable				///
		Verbose				///
		TItle(string asis)		///
		SUBpop(passthru)		/// -svy- options
		noADJust			///
		dof(numlist max=1 >0)		///
		*				///
	]

	_get_dots_option, `options'
	local dots `"`s(dotsopt)'"'
	local nodots `"`s(nodots)'"'
	local noisily `"`s(noisily)'"'
	local options `"`s(options)'"'

	_get_diopts diopts, `diopts' `options'

	// MSE1 exists just in case the `mse' option is specified twice due to
	// -svyset-

	if `is_sum' {
		Check4Over, `cmdopts'
		local overopt `"`s(overopt)'"'
	}

	// check expressions
	tempname touseN npop nsubpop
	tempvar subuse touse wvar

	mark `touse' `cmdif' `cmdin'
	_svy_setup `touse' `subuse' `wvar',	///
		cmdname(`cmdname')		///
		svy				///
		bootstrap			///
		`subpop'			///
		`overopt'			///
		`stset'				///
		`chk_group'			///
		// blank
	if `is_sum' {
		local cmdopts `cmdopts' sovar(`subuse')
		local firstcall firstcall
	}
	if "`r(wtype)'" != "" {
		local wtype	`"`r(wtype)'"'
		local wexp	`"`r(wexp)'"'
		local wt	[`wtype'`wexp']
		local wgt	[`wtype'=`wvar']
		local stwgt	`"`r(stwgt)'"'
	}
	else {
		local wgt
	}
	if "`mse'" == "" {
		local mse	`r(mse)'
	}
	if !`:length local dof' {
		local dof `"`r(dof)'"'
	}
	local posts	`"`r(poststrata)'"'
	local postw	`"`r(postweight)'"'
	local calmethod	`"`r(calmethod)'"'
	local calmodel	`"`r(calmodel)'"'
	local calopts	`"`r(calopts)'"'
	local subpop	`"`r(subpop)'"'
	local srssub	`r(srssubpop)'
	if "`r(fpc1)'" != "" {
		di as err "FPC is not allowed with Bootstrap"
		exit 459
	}
	local bsrw	`r(bsrweight)'
	if "`bsrw'" == "" {
		di as err "{p}" ///
"svy bootstrap requires that the replicate weight variables were svyset " ///
"using option bsrweight()" ///
		"{p_end}"
		exit 459
	}
	local creps : word count `bsrw'
	if "`bsn'" == "" {
		if "`r(bsn)'" != "" {
			local bsn = r(bsn)
		}
		else	local bsn 1
	}
	if `"`posts'"' != "" {
		tempname postwvar
		svygen post double `postwvar' `wgt'	///
			if `touse' == 1,		///
			posts(`posts') postw(`postw')
		local npost = r(N_poststrata)
		local pstropt pstrwvar(`postwvar') ///
			posts(`posts') postw(`postw')
		local uwvar `postwvar'
		if "`wtype'" == "" {
			local wgt [pw=`uwvar']
		}
		else {
			local wgt [`wtype'=`uwvar']
		}
	}
	else if `"`calmethod'"' != "" {
		tempname calwvar
		quietly					///
		svycal `calmethod' `calmodel' `wgt'	///
			if `touse' == 1,		///
			generate(`calwvar')		///
			`calopts'
		local calopt	calwvar(`calwvar')	///
				calmethod(`calmethod')	///
				calmodel(`calmodel')	///
				calopts(`calopts')
		local uwvar `calwvar'
		if "`wtype'" == "" {
			local wgt [pw=`uwvar']
		}
		else {
			local wgt [`wtype'=`uwvar']
		}
	}
	else {
		local uwvar `wvar'
	}

	if "`trace'" != "" {
		local noisily	noisily
		local traceon	set trace on
		local traceoff	set trace off
	}
	if "`cmdlog'" != "" {
		local noisily noisily
	}

	tempvar order
	quietly gen `c(obs_t)' `order' = _n
	local sortvars : sortedby		// restore sort order later

	// preliminary parse of <exp_list>
	_prefix_explist `exp_list', stub(_bs_)
	local eqlist	`"`s(eqlist)'"'
	local idlist	`"`s(idlist)'"'
	local explist	`"`s(explist)'"'
	local eexplist	`"`s(eexplist)'"'

	_prefix_note `cmdname', `nodots'
	if "`noisily'" != "" {
		di "bootstrap: First call to `cmdname' with data as is:" _n
		di as inp `". `command'"'
	}

	local props : properties `cmdname'
	local svyr svyr svylb svyg
	local dolin 0
	if inlist(`"`exp_list'"', "", "_b") {
		local dolin : list svyr & props
		local dolin : list sizeof dolin
	}

	// run the command using the entire dataset
	_prefix_clear, e r
	if `"`cmdopts'"' != "" {
		local ccmdopts `", `cmdopts' `firstcall'"'
	}
	if `dolin' {
		if `"`subpop'`srssub'"' != "" {
			local subopt subpop(`subpop', `srssub')
		}
		`traceon'
		capture noisily quietly `noisily' `version'	///
			svy, `subopt'				///
			vce(linearized) : `cmdname' `cmdargs'	///
			if `touse', `cmdopts' `firstcall' `rest'
		`traceoff'
		if e(census) == 1 | e(singleton) == 1 {
			// -bootstrap- can do nothing more, so just
			// report results and exit
			svy
			exit
		}
		quietly replace `touse' = 0 if ! e(sample)
		quietly replace `subuse' = 0 if ! e(sample)
		scalar `npop' = e(N_pop)
		if "`subpop'" != "" {
			scalar `nsubpop' = e(N_subpop)
		}
	}
	else if !`is_st' | "`wgt'" == "" {
		`traceon'
		capture noisily quietly `noisily' `version'	///
			`cmdname' `cmdargs'			///
			`wgt' if `subuse' `ccmdopts' `rest'
		`traceoff'
	}
	else {
		quietly streset `wgt'
		`traceon'
		capture noisily quietly `noisily' `version'	///
			`cmdname' `cmdargs'			///
			if `subuse' `ccmdopts' `rest'
		`traceoff'
	}
	local rc = c(rc)
	if `is_st' {
		// restore st weight settings
		if `"`stwgt'"' != "" {
			quietly streset `stwgt'
		}
		else {
			char _dta[st_w]
			char _dta[st_wt]
			char _dta[st_wv]
		}
	}
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
                _check_omit `fullmat',get
                local checkmat "checkmat(`fullmat')"
        }

	tempname rhold
	_return hold `rhold'
	if !`dolin' {
		sum `uwvar' if `touse' == 1, mean
		scalar `npop' = r(sum)
	}

	quietly count if `touse' == 1
	scalar `touseN' = r(N)
	_return restore `rhold'

	// check e(sample)
	_prefix_check4esample bootstrap `cmdname'
	if "`drop'" == "" {
		local keepesample `"`s(keep)'"'
	}
	// ignore s(diwarn)

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
	forval i = 1/`K' {
		local exp`i' `"`s(exp`i')'"'
		if missing(`b'[1,`i']) {
			di as err ///
`"statistic `exp`i'' evaluated to missing in full sample"'
			exit 322
		}
	}
	if `is_sum' & `k_exp' == 0 & "`eexpress'" == "(_b)" {
		// speed things up with the -novariance-
		_prefix_checkopt NOVARiance, `cmdopts'
		if `"`noisily'`s(novariance)'"' == "" {
			local novar " novar"
		}
	}

	if `"`reject'"' != "" {
		local reject `"reject(`reject')"'
	}

	// -Display- options
	local diopts	`diopts'	///
			level(`level')	///
			`header'	///
			`legend'	///
			`verbose'	///
			`table'		///
			`efopt'		///
			`semdiopts'	///
			`cmddiopts'	///
			// blank

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

	if `"`keepesample'"' != "" & `"`subpop'"' == "" {
		if "`cmdin'" == "" {
			local preserved preserved
			preserve
			quietly `keepesample'
		}
		else {
			quietly replace `touse' = 0 if ! e(sample)
			quietly replace `subuse' = 0 if ! e(sample)
		}
	}

	if "`:sortedby'" != "`sortvars'" {
		sort `sortvars' `order'
	}

	quietly replace `touse'  = 2 if `touse'  == 0
	quietly count if `touse' == 1
	tempname nobs
	scalar `nobs' = r(N)

	if min(`creps',_N) <= 1 {
		di as err "insufficient observations to perform bootstrap"
		exit 459
	}

	// bootstrap temp pseudovalue variables
	forval i = 1/`K' {
		tempvar tv`i'
		local pseudo `pseudo' `tv`i''
	}

nobreak {
capture noisily break {

	local buildfv 0
	if "`eexpress'" == "(_b)" {
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

	if "`sortvars'" != "" {
		sort `sortvars', stable
	}

	// prepare post
	tempname postid
	postfile `postid' `names'	///
		using `"`saving'"', `double' `every' `replace'

	local cmd1 `"cmd1(`version' `cmdname' `cmdargs')"'
	local cmd2 `"cmd2(`cmdopts'`novar'`rest')"'

	_loop_rw `touse' `subuse' `pseudo',	///
		caller(Bootstrap)		///
		command(`command')		///
		express(`express')		///
		`cmd1' `cmd2'			///
		rwvars(`bsrw')			///
		owvar(`wvar')			///
		`pstropt'			///
		`calopt'			///
		postid(`postid')		///
		`nodots'			///
		`dots'				///
		`noisily'			///
		`trace'				///
		`reject'			///
		`stset'				///
		`checkmat'			///
		// blank

} // capture noisily break

	local rc = c(rc)

	if `is_st' {
		// restore st weight settings
		if `"`stwgt'"' != "" {
			quietly streset `stwgt'
		}
		else {
			char _dta[st_w]
			char _dta[st_wt]
			char _dta[st_wv]
			quietly stset
		}
	}

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

	// load/save file with bootstrap results
	if "`preserved'" != "" {
		restore
	}
	preserve
	capture use `"`saving'"', clear
	if c(rc) {
		if inrange(c(rc),900,903) {
			di as err ///
"insufficient memory to load file with bootstrap results"
		}
		error c(rc)
	}
	label data `"svy bootstrap: `cmdname'"'
	char _dta[svy_bs_command]	`"`command'"'
	char _dta[svy_bs_cmdname]	`"`cmdname'"'
	char _dta[svy_bs_names]  	`"`names'"'
	char _dta[svy_bs_wtype]		`"`wtype'"'
	char _dta[svy_bs_wexp]		`"`wexp'"'
	char _dta[svy_bs_rweights]	`"`bsrw'"'
	char _dta[svy_bs_N_pop]		`"`=`npop''"'
	char _dta[svy_bs_bsn]		`"`bsn'"'

	// fix the column stripes
	if "`eexpress'" == "(_b)" ///
	 & inlist("`cmdname'", "ologit", "oprobit") ///
	 & missing(e(version)) {
		_prefix_relabel_eqns `b'
		local k_eq = s(k_eq)
		local k_aux = `k_eq'-1
	}
	local colna : colna `b'
	local coleq : coleq `b', quote
	local coleq : list clean coleq
	if `"`: list uniq coleq'"' == "_" {
		local coleq
	}
	forvalues i = 1/`K' {
		local name : word `i' of `names'
		char `name'[observed] `= `b'[1,`i'] '
		local label = usubstr(`"`exp`i''"',1,80)
		label variable `name' `"`label'"'
		char `name'[expression] `"`exp`i''"'
		local na : word `i' of `colna'
		local eq : word `i' of `coleq'
		char `name'[coleq] `eq'
		char `name'[colname] `na'
		if `i' <= `k_eexp' {
			char `name'[is_eexp] 1
		}
	}
	char _dta[svy_bs_N]	`=`nobs''
	char _dta[svy_bs_version]	1

	if `"`filetmp'"' == "" {
		quietly save `"`saving'"', replace
	}

	// saved results
	tempname bs_v
	capture noisily _svy_bs_sum, `mse'
	if c(rc) {
		ereturn clear
		exit c(rc)
	}
	mat `bs_v'    = r(V)
	restore

	if "`eexpress'" == "(_b)" {
		// make a copy of what is in -e()-, with some eXclusions
		local xmac cmd _estimates_name chi2type clustvar novariance
		local xsca F chi2 chi2_c p p_c ll ll_c ll0 ll_0 df_m ///
			r2_p r2_a rmse rss mss
		local xmat b V _N_strata _N_strata_single _N_strata_certain
		if "`e(cmd)'" != "`cmdname'" {
			local ecmd `e(cmd)'
		}
		else	local ecmd `cmdname'
		if "`cmdname'" == "heckman" {
			local xsca `xsca' selambda
		}
		if "`cmdname'" == "intreg" {
			local xsca `xsca' se_sigma
		}
		if "`cmdname'" == "sem" {
			local xmat `xmat' V_std
		}
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

	quietly replace `touse' = (`touse'==1)
	ereturn post `b' `bs_v' `Cns', esample(`touse') `depname'

	// restore the copied elements back to -e()-
	_r2e, xmat(b V)
	_post_vce_rank
	if `buildfv' {
		_prefix_buildinfo `cmdname', h(`H') i(`I')
		set coeftabresults `coeftabresults'
	}
	_prefix_fvlabel `ecmd'
	if `:length local dof' {
		ereturn scalar df_r = `dof'
	}
	else {
		ereturn local df_r
		local adjust noadjust
	}
	ereturn scalar k_eq	= `k_eq'
	ereturn scalar k_exp	= `k_exp'
	ereturn scalar k_eexp	= `k_eexp'
	ereturn scalar k_extra	= `k_extra'
	ereturn scalar bsn	= `bsn'
	if "`k_aux'" != "" {
		ereturn scalar k_aux = `k_aux'
	}

	if `"`subpop'"' != "" {
		sum `subuse' if e(sample), meanonly
		local byopt by(`subuse') nby(`r(max)')
	}
	_svy `subuse' `wgt'	///
		if e(sample),	///
		`byopt'		///
		novariance	///
		// blank
	ereturn scalar N_pop	= `npop'
	ereturn local N_sub
	ereturn local N_subpop
	ereturn local subpop
	ereturn local srssubpop
	if `"`subpop'"' != "" {
		ereturn scalar N_sub	= r(N_sub)
		if `dolin' {
			ereturn scalar N_subpop	= `nsubpop'
		}
		else {
			ereturn scalar N_subpop	= r(N_subpop)
		}
		ereturn local subpop	`"`subpop'"'
		if "`vsrs'" != "" {
			ereturn local srssubpop	`srssub'
		}
	}
	ereturn local N_strata
	ereturn local N_psu
	ereturn local wtype	`wtype'
	ereturn local wexp	`"`wexp'"'
	ereturn local strata1
	ereturn local bsrweight	`bsrw'
	ereturn local su1
	if "`calmethod'" != "" {
		ereturn hidden local calmethod	`"`calmethod'"'
		ereturn hidden local calmodel	`"`calmodel'"'
		ereturn hidden local calopts	`"`calopts'"'
		ereturn local `calmethod' `"`calmodel', `calopts'"'
	}
	if "`posts'" != "" {
		ereturn local poststrata	`posts'
		ereturn local postweight	`postw'
		ereturn scalar N_poststrata	= `npost'
	}
	ereturn local adjust 		`adjust'
	ereturn local estat_cmd		svy_estat
	if "`vsrs'" != "" {
		ereturn matrix V_srs = `vsrs'
		// NOTE: V_srswr must be posted before the next line
		_svy_mkdeff
	}

	ereturn scalar N = `touseN'
	if `"`title'"' != "" {
		ereturn local title `"`title'"'
	}
	else {
		_prefix_title `cmdname' "Bootstrap results"
		if "`e(prefix)'" == "svy" {
			ereturn local title `"`r(title)'"'
		}
		else	ereturn local title `"Survey: `r(title)'"'
	}
	forval i = 1/`K' {
		ereturn local exp`i' `"`exp`i''"'
	}
	ereturn local command	`"`:list retok command'"'
	// NOTE: this must be the last thing posted to -e()-
	ereturn local cmdname `cmdname'
	ereturn local prefix	svy
	if "`eexpress'`k_exp'" != "(_b)0" {
		ereturn hidden local predict _no_predict
		ereturn local cmd bootstrap
	}
	else {
		if !inlist("`e(predict)'", "", "_no_predict") {
			// compute e(F) and e(df_m)
			_prefix_model_test `cmdname', svy `adjust'
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
	if "`e(cmd)'`first'" == "ivregfirst" {
		_svy_ivreg_first, `diopts'
	}
	svy, `diopts'
end

program Check4Over, sclass
	syntax [, over(passthru) * ]
	sreturn local overopt `"`over'"'
end

exit
