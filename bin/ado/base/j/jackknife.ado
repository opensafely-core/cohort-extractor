*! version 9.13.0  13dec2018
program jackknife, eclass sortpreserve
	version 9, missing
	local version : di "version " string(_caller()) ", missing:"

	set prefix jackknife

	// version control
	if _caller()<=6 {
		`version' jknife_6 `0'
		exit
	}

	capture _on_colon_parse `0'
	if c(rc) | `"`s(after)'"' == "" {
		gettoken old : 0 , qed(qed)
		if `qed' {
			// version control
			`version' jknife_8 `0'
			exit
		}
		if !c(rc) {
			local 0 `"`s(before)'"'
		}

		// replay output
		if replay() {
			if "`e(vce)'" != "jackknife" {
				error 301
			}
			`version' Display `0'
			exit
		}
	}

	quietly ssd query
	if (r(isSSD)) {
		di as err "jackknife not possible with summary statistic data"
		exit 111
	}
	`version' JKnife `0'
	ereturn local cmdline `"jackknife `0'"'
end

program JKnife, eclass
	version 9
	local version : di "version " string(_caller()) ":"

	// <my_stuff> : <command>
	_on_colon_parse `0'
	local command `"`s(after)'"'
	local 0 `"`s(before)'"'

	// quick check for -svy- and -nodrop- options
	syntax [anything(name=exp_list equalok)]	///
		[fw iw pw aw] [if] [in] [,		///
			SVY				///
			COEF				/// for -logistic-
			noDROP				///
			Level(passthru)			///
			FORCE				///
			CLuster(passthru)		/// cluster options
			NOECLUSTER			///
			IDcluster(string)		///
			*				/// other options
		]
	if "`svy'" != "" {
		if "`cluster'" != "" {
			di as err "option cluster() is not allowed with svy"
			exit 198
		}
		_svy_newrule
	}
	_get_eformopts, soptions eformopts(`options') allowed(__all__)
	local options `"`s(options)'"'
	local efopt = cond(`"`s(opt)'"'=="",`"`s(eform)'"',`"`s(opt)'"')

	if "`weight'" != "" {
		local wgt [`weight'`exp']
	}

	// parse the command and check for conflicts
	`version' _prefix_command jackknife `wgt' `if' `in' , ///
		`svy' checkvce `coef' `efopt' `cluster' `level' ///
		checkcluster : `command'
	local options `"`options' `s(prefix_options)'"'

	if `"`s(vce)'"' != "" {
		if "`svy'" != "" {
			di as err "option vce() not allowed"
			exit 198
		}
		local vce `"vce(`s(vce)')"'
	}

	while inlist(`"`s(cmdname)'"', "svy", ///
		"jackknife", "jknife", "jacknife") {
		if `"`s(cmdname)'"' == "svy" {
			local svy svy
		}
		if `"`s(cmdname)'"' == "svy" & `"`s(cmdargs)'"' != "" {
			_svy_check_vce `vcetype'
			if `"`s(vce)'"' != "jackknife" {
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
			`svy' `wgt' `if' `in', ///
				`efopt' `cluster' `level' `options'
			exit
		}
		`version' _prefix_command jackknife `wgt' `if' `in' , ///
			svy checkvce `efopt' `cluster' `level' ///
			checkcluster `s(rest)'
	}

	local version	`"`s(version)'"'
	local cmdname	`"`s(cmdname)'"'
	local cmdargs	`"`s(anything)'"'
	local wgt	`"`s(wgt)'"'
	local wtype	`"`s(wtype)'"'
	local wexp	`"`s(wexp)'"'
	local cmdif	`"`s(if)'"'
	local cmdin	`"`s(in)'"'
	local cluster	`"`s(cluster)'"'
	local rest	`"`s(rest)'"'
	local efopt	`"`s(efopt)'"'
	local command	`"`s(command)'"'
	local level	`"`s(level)'"'
	if "`level'" != "" {
		local level level(`level')
	}
	local cmdopts	`"`s(options)'"'
	CheckLRMODEL `cmdname', `cmdopts'
	if `:length local vce' {
		local cmdopts `"`cmdopts' `vce'"'
	}
	_get_diopts diopts cmdopts, `cmdopts'
	if "`cmdname'" == "sem" {
		// -sem- has some unique display options
		sem_parse_display semdiopts cmdopts, `cmdopts'
	}

	local not_allowed dprobit mswitch threshold menl dsge
	if `:list cmdname in not_allowed' {
		di as err "{p}prefix command {bf:jackknife} not allowed with"
		di as err "{bf:`cmdname'}{p_end}"
		exit 322
	}

	if `"`efopt'"' != "" & !inlist(`"`:list retok exp_list'"', "", "_b") {
		local efopt
	}

	if "`svy'" != "" {
		// -_svy_check_cmdopts- resets -s()-
		_svy_check_cmdopts `cmdname', vce(jackknife) `cmdopts'
		local first	`"`s(first)'"'
		local chk_group	`"`s(check_group)'"'
		local cmdlog	`"`s(log)'"'
		local cmddiopts	`"`s(diopts)'"'
	}

	local exclude bs bstrap bootstrap brr statsby
	if `:list cmdname in exclude' ///
	 | ("`force'" == "" & bsubstr("`cmdname'",1,3) == "svy") {
		di as err "`cmdname' is not supported by jackknife"
		exit 199
	}

	if "`s(replay)'" != "" {
		if "`e(cmdname)'" == "`cmdname'" &	///
		   "`e(vce)'" == "jackknife" {
			`version' Display, `options' `cmdopts' `efopt' ///
				`level' `rest'
			exit
		}
	}

	is_svysum `cmdname'
	local is_sum = r(is_svysum)
	is_st `cmdname'
	local is_st = r(is_st)
	local svyprop = inlist("`cmdname'", "prop", "proportion")
	if `is_st' {
		local stset stset
	}

	if "`svy'" != "" {
		local svyopts	SUBpop(passthru)		///
				noADJust			///
				TWOperstratum 			///
				dof(numlist max=1 >0)
	}

	// now check the rest of the options
	local 0 `", `options'"'
	syntax [,				///
		NOCOUNT				/// not documented
		Eclass Eclass1			///
		N(string)			///
		Rclass				///
		KEEP				///
		SAving(string)			///
		DOUBle				/// not documented
		MSE MSE1 NOMSE			///
		TRace				/// "prefix" options
		REJECT(string asis)		///
		noHeader			/// Display options
		noLegend			///
		notable				///
		Verbose				///
		TItle(string asis)		///
		`svyopts'			/// -svy- options
		*				///
	]

	_get_dots_option, `options'
	local dots `"`s(dotsopt)'"'
	local nodots `"`s(nodots)'"'
	local noisily `"`s(noisily)'"'
	local options `"`s(options)'"'

	_get_diopts diopts, `diopts' `options'
	local diopts	`diopts'	///
			`level'		///
			`table'		///
			`header'	///
			`legend'	///
			`verbose'	///
			`efopt'		///
			`semdiopts'	///
			`cmddiopts'	///
			// blank

	// NOTE: MSE1 exists just in case the `mse' option is specified twice
	// due to -svyset-

	// check expressions
	tempname N touseN nobs wnclust
	tempvar subuse touse clid ncl

	if `is_sum' {
		Check4Over, `cmdopts'
		local overopt `"`s(overopt)'"'
	}

	mark `touse' `cmdif' `cmdin'
	if `"`svy'"' != "" {
		tempvar wvar
		tempname npop nsub nsubpop nomit nstrata npsu
		if `"`subpop'"' != "" {
			tempvar otouse
			quietly gen byte `otouse' = `touse'
		}
		else	local otouse `touse'
		_svy_setup `touse' `subuse' `wvar',	///
			cmdname(`cmdname')		///
			svy				///
			jackknife			///
			`subpop'			///
			`overopt'			///
			`stset'				///
			`chk_group'			///
			// blank
		if `is_sum' {
			_prefix_checkopt sovar(passthru), `cmdopts'
			if `"`s(sovar)'"' == "" {
				local cmdopts `cmdopts' sovar(`subuse')
			}
			local firstcall firstcall
		}
		if "`r(wtype)'" != "" {
			local wtype	`"`r(wtype)'"'
			local wexp	`"`r(wexp)'"'
			local wgt	[`wtype'=`wvar']
			if !`is_sum' {
				quietly replace `subuse' = 0 ///
					if `subuse' & `wvar' == 0
			}
			local stwgt	`"`r(stwgt)'"'
		}
		if "`mse'" == "" {
			local mse `r(mse)'
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
		local jkrw	`r(jkrweight)'
		local singleu	singleunit(`r(singleunit)')
		if "`jkrw'" != "" {
			if "`keep'" != "" {
				di as err ///
"option keep is not allowed with replicate weights"
				exit 198
			}
		}
		else {
			local fpc	`r(fpc1)'
			local strata	`r(strata1)'
			local cluster	`r(su1)'
		}
		if "`r(wtype)'" != "" {
			sum `wvar' if `otouse', mean
			scalar `npop' = r(sum)
		}
		else {
			quietly count if `otouse'
			scalar `npop' = r(N)
		}
		if `"`posts'"' != "" {
			tempname postwvar
			svygen post double `postwvar' `wgt'	///
				if `touse' == 1, posts(`posts') postw(`postw')
			local npost = r(N_poststrata)
			local pstropt pstrwvar(`postwvar') ///
				posts(`posts') postw(`postw')
			if "`wtype'" == "" {
				local wgt [pw=`postwvar']
			}
			else {
				local wgt [`wtype'=`postwvar']
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
	}
	else {
		if "`wtype'" != "" {
			tempvar wvar
			quietly gen double `wvar' `wexp'
			local wgt [`wtype'=`wvar']
		}
		else if "`stset'" != "" & `"`: char _dta[st_wt]'"' != "" {
			tempvar wvar
			local wtype : char _dta[st_wt]
			local stwv  : char _dta[st_wv]
			quietly gen double `wvar' = `stwv'
			local wgt [`wtype'=`wvar']
			local stwgt : char _dta[st_w]
		}
		if `is_sum' & `:length local overopt' {
			_svy_subpop `touse' `subuse', `overopt'
			_prefix_checkopt sovar(passthru), `cmdopts'
			if `"`s(sovar)'"' == "" {
				local cmdopts `cmdopts' sovar(`subuse')
			}
			local firstcall firstcall
		}
		else {
			quietly gen byte `subuse' = `touse'
		}
	}

	if "`trace'" != "" {
		local noisily	noisily
		local traceon	set trace on
		local traceoff	set trace off
	}
	if "`cmdlog'" != "" {
		local noisily noisily
	}

	// this allows us to restore original sort order later for the
	// unweighted jackknife; we restore sort order only to accommodate time
	// series operators in commands like -regress-
	tempvar order
	quietly gen `c(obs_t)' `order' = _n
	local sortvars : sortedby		// restore sort order later

	// preliminary parse of <exp_list>
	_prefix_explist `exp_list', stub(_jk_)
	local eqlist	`"`s(eqlist)'"'
	local idlist	`"`s(idlist)'"'
	local explist	`"`s(explist)'"'
	local eexplist	`"`s(eexplist)'"'

	_prefix_note `cmdname', `nodots'
	if "`noisily'" != "" {
		di "jackknife: First call to `cmdname' with data as is:" _n
		di as inp `". `command'"'
	}

	local usesvy 0
	if "`svy'" != "" {
		local props : properties `cmdname'
		local svyr svyr svylb svyg
		if `"`:list svyr & props'"' != ""	///
		 & inlist(`"`exp_list'"', "", "_b") {
			local usesvy 1
		}
	}

	// run the command using the entire dataset
	_prefix_clear, e r
	if `"`cmdopts'"' != "" {
		local ccmdopts `", `cmdopts'"'
	}
	if `usesvy' {
		if `"`subpop'`srssub'"' != "" {
			local subopt subpop(`subpop', `srssub')
		}
		`traceon'
		capture noisily quietly `noisily' `version'	///
			svy, `subopt'				///
			vce(linearized) : `cmdname' `cmdargs'	///
			if `touse', `cmdopts' `firstcall' `rest'
		`traceoff'
		if e(census) == 1 | ///
		  (e(singleton) == 1 & "`e(singleunit)'" == "missing") {
			// -jackknife- can do nothing more, so just
			// report results and exit
			svy
			exit
		}
		scalar `nobs'	 = e(N)
		scalar `npop'	 = e(N_pop)
		if "`subpop'" != "" {
			scalar `nsubpop' = e(N_subpop)
			scalar `nsub' = e(N_sub)
		}
		scalar `nstrata' = e(N_strata)
		scalar `nomit'	 = e(N_strata_omit)
		scalar `npsu'	 = e(N_psu)
		if "`subpop'" != "" {
			quietly count if `subuse'
			if r(N) != e(N_sub) {
				di as txt "{p 0 6 0}"
				di as txt 				 ///
"Note: Some subpopulation observations were dropped during estimation."	 ///
" This is most likely because of missing values in the model variables." ///
" If there are insufficient observations to compute jackknife"		 ///
" standard errors, consider changing the subpopulation to exclude"	 ///
" these observations."
				di as txt "{p_end}"
			}
		}
	}
	else if !`is_st' | "`wgt'" == "" {
		`traceon'
		capture noisily quietly `noisily' `version'	///
			`cmdname' `cmdargs'			///
			`wgt' if `subuse' `ccmdopts' `firstcall' `rest'
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
		_prefix_run_error `rc' jackknife `cmdname'
	}
	// do a preliminary check (or some other processing) based
	// on first full run
	_prefix_validate jackknife `cmdname'
	// check for rejection of results from entire dataset
	if `"`reject'"' != "" {
		_prefix_reject jackknife `cmdname' : `reject'
		local reject `"`s(reject)'"'
	}
	capture confirm matrix e(b) e(V)
	if !_rc {
		tempname fullmat
		_check_omit `fullmat',get
		local checkmat "checkmat(`fullmat')"
	}
	if "`nocount'" == "" {
		if trim(`"`rclass'`eclass'`n'"') == "" {
			// get implied n() option based on e(N) or r(N)
			local Nimplied 1
			if !missing(e(N)) {
				local eclass eclass
			}
			else if !missing(r(N)) {
				local rclass rclass
			}
		}
	}

	// check for time-series operators
	local junk : subinstr local cmdargs "." "_", count(local hasdot)
	if "`drop'" == "" & `hasdot' == 0 {
		// check e(sample)
		_prefix_check4esample jackknife `cmdname'
		local keepesample `"`s(keep)'"'
	}
	// ignore s(diwarn)

	if `"`keepesample'"' != "" & `"`subpop'"' == "" {
		quietly replace `touse' = 0 if ! e(sample)
		quietly replace `subuse' = 0 if ! e(sample)
	}
	else if "`eclass'" != "" {
		quietly replace `touse' = 0 if `subuse' & ! e(sample)
		quietly replace `subuse' = 0 if ! e(sample)
	}

	if !`usesvy' & `"`svy'"' != "" {
		tempname rhold
		_return hold `rhold'
		capture _svy2 `touse' if `touse' `wgt',	///
			type(total)			///
			strata(`strata')		///
			cluster(`cluster')		///
			subpop(`subuse')		///
			novariance
		if c(rc) {
			// possible for r(2000); but we'll catch it later when
			// we evaluate the value of the -n()- function
			scalar `nstrata' = .
			scalar `nomit'	 = 0
			scalar `npsu'	 = .
		}
		else {
			scalar `nstrata' = r(N_strata)
			scalar `nomit'	 = r(N_strata_omit)
			if `"`cluster'"' == "" {
				scalar `npsu'	 = r(N)
			}
			else {
				scalar `npsu'	 = r(N_clust)
			}
		}
		_return restore `rhold'
	}

	// determine default <exp_list>, or generate an error message
	if `"`exp_list'"' == "" {
		_prefix_explist, stub(_jk_) edefault
		local eqlist	`"`s(eqlist)'"'
		local idlist	`"`s(idlist)'"'
		local explist	`"`s(explist)'"'
		local eexplist	`"`s(eexplist)'"'
	}
	// expand eexp's that may be in eexplist, and build a matrix of the
	// computed values from all expressions
	tempname b
	_prefix_expand `b' `explist',		///
		stub(_jk_)			///
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
	if `is_sum' {
		if `k_exp' == 0 & "`eexpress'" == "(_b)" {
			// speed things up with the -novariance-
			_prefix_checkopt NOVARiance, `cmdopts'
			if `"`noisily'`s(novariance)'"' == "" {
				local novar " novar"
			}
		}
		if "`svy'" != "" {
			_prefix_checkopt ZEROweight, `cmdopts'
			if `"`s(zeroweight)'"' == "" {
				local novar "`novar' zeroweight"
			}
		}
	}

	if `"`reject'"' != "" {
		local reject `"reject(`reject')"'
	}

	capture confirm integer number `r(N)'
	if !c(rc) {
		local RN = r(N)
	}

	forvalues i = 1/`K' {
		local name`i' : word `i' of `names'
	}

	if "`force'" == "" & "`wtype'" == "aweight" {
		local 0 `wgt'
		syntax [fw]
		exit 101
	}

	// check options
	if `"`keep'"' != "" {
		confirm new variable `names'
	}
	if `"`idcluster'"' != "" & `"`cluster'"' == "" {
		di as err "option idcluster() requires the cluster() option"
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
	local ntype `nocount' `eclass' `rclass' `=cond(`"`n'"'!="","n()","")'
	if `:word count `ntype'' > 1 {
		di as err "options `:list retok ntype' may not be combined"
		exit 198
	}

	if "`:sortedby'" != "`sortvars'" {
		sort `sortvars' `order'
	}

	if "`jkrw'" == "" {
		if !`usesvy' {
			if "`rclass'" != "" {
				local nfunc "r(N)"
			}
			else if "`eclass'" != "" {
				local nfunc "e(N)"
			}
			else	local nfunc `"`n'"'
		}
		else {
			if `"`n'`rclass'"' != "" {
				if "`rclass'" != "" {
					local nfunc "r(N)"
				}
				else	local nfunc `"`n'"'
			}
			else	local nfunc "e(N)"
		}
	}
	else if `"`rclass'`eclass'`n'"' != "" & "`Nimplied'" == "" {
		if `"`n'"' != "" {
			local opt "n()"
		}
		else	local opt `rclass'`eclass'
		di as txt "{p 0 0 2}note: " ///
"ignoring `opt' option since jkrweight() was specified with svyset"
	}
	quietly replace `touse'  = 2 if `touse'  == 0
	tempname rhold
	_return hold `rhold'
	if "`wtype'" == "fweight" {
		quietly sum `wvar' if `touse' == 1
		scalar `touseN' = r(sum)
	}
	else {
		quietly count if `touse' == 1
		scalar `touseN' = r(N)
	}
	if !`usesvy' {
		scalar `nobs' = r(N)
	}
	_return restore `rhold'
	// sort observations to use
	sort `touse' `strata' `cluster' `subuse', stable
	quietly replace `order' = _n

	// sample size function
	if `"`nfunc'"' != "" {
		if `"`nfunc'"' == "r(N)" & "`RN'" != "" {
			capture scalar `N' = `RN'
		}
		else if `"`nfunc'"' == "r(N)" & "`RN'" == "" {
			capture scalar `N' = .
		}
		else {
			if `usesvy' {
				if `svyprop' {
					capture scalar `N' = e(N)
				}
				else if missing(e(N_sub)) {
					quietly count if `subuse'
					capture scalar `N' = r(N)
				}
				else	capture scalar `N' = int(e(N_sub))
			}
			else	capture scalar `N' = int(`nfunc')
		}
		if c(rc) {
			di as err `"n(`nfunc') invalid"'
			exit c(rc)
		}
		if missing(`N') | `N' == 0 {
			local zm = cond(missing(`N'),"missing","zero")
			di as err ///
`"number of obs. `nfunc' evaluated to `zm' in full sample"'
			exit 322
		}
	}
	else 	scalar `N' = `touseN'

	if "`strata'" != "" {
		tempvar strid
		quietly by `touse' `strata': ///
			gen `strid' = (_n==1) if `touse' == 1
		quietly replace `strid' = sum(`strid') if `touse' == 1
	}

	// check clusters
	if "`cluster'" != "" {
		tempvar cluse
		mark `cluse' if `touse' == 1
		markout `cluse' `cluster', strok
		capture assert `cluse' == 1 if `touse' == 1
		if c(rc) {
			gettoken clname : cluster
			di as err ///
"missing values not allowed in cluster variable `clname'"
			exit 459
		}
		tempvar firstofcl
		quietly by `touse' `strata' `cluster': ///
			gen `clid' = (_n == 1) if `touse' == 1
		quietly gen byte `firstofcl' = `clid'
		// total number of clusters
		quietly count if `clid' & `touse' == 1
		if r(N) <= 2 & "`svy'" == "" {
			di as err "jackknife requires more than 2 clusters"
			exit 459
		}
		local nclust = r(N)
		if "`strata'" != "" {
			quietly by `touse' `strata': ///
				gen double `ncl' = sum(`clid')
			quietly by `touse' `strata': replace `ncl' = `ncl'[_N]
		}
		else	quietly gen double `ncl' = `nclust'
		quietly replace `clid' = sum(`clid') if `touse' == 1
		if "`wtype'" == "fweight" {
			// fweights must be constant within cluster
			capture by `touse' `cluster':	///
				assert `wvar' == `wvar'[1] if `touse' == 1
			if c(rc) {
				di as err ///
			"fweights must be constant within `cluster'"
				exit 198
			}
		}
	}
	else {
		local nclust = `nobs'
		// count the number of strata
		local clid `order'
		sort `touse' `strata', stable
		by `touse' `strata': gen double `ncl' = _N
	}
	if min(`nclust',_N) <= 1 {
		di as err "insufficient observations to perform jackknife"
		exit 459
	}

	// jackknife temp pseudovalue variables
	forval i = 1/`K' {
		tempname tv`i'
		local pseudo `pseudo' `tv`i''
	}

nobreak {
capture noisily break {

	local buildfv 0
	if "`eexpress'" == "(_b)" {
		if "`svy'" == "" &		///
		   `k_extra' == 0 &		///
		   !inlist("`cmdname'", "anova", "manova") {
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

	if "`sortvars'" != "" {
		// NOTE: this must be run before calling -RWeights-
		sort `sortvars', stable
	}

	local jkstrvar  __jk_strata
	local jkmultvar __jk_multiplier
	local jkfpcvar  __jk_fpc
	if "`jkrw'" != "" {
		tempvar jkrm fpc strid
		RWeights `jkrm' `strid' `fpc' : `jkrw'
		local postextra ///
			`:type `strid'' `jkstrvar' `jkmultvar' `jkfpcvar'
		local strata `strid'
		local goodstrid `s(goodstrid)'
	}
	else {
		if `"`strata'"' != "" {
			local postextra `strata'
			local jkstrvar `strata'
		}
		local postextra `postextra' `clid'
		if `"`fpc'"' != "" {
			local postextra `postextra' `:type `fpc'' `fpc'
			local jkfpcvar `fpc'
		}
		if "`wtype'" == "fweight" {
			local postextra `postextra' `jkmultvar'
		}
		else if !inlist("`svy'`wtype'", "", "aweight", "fweight") {
			if `"`wtype'"' != "" {
				local jk_wtype `wtype'
			}
			else	local jk_wtype pweight
			local postextra `postextra' `jkmultvar'
		}
	}
	if "`jkrw'" != "" {
		if "`mse'" != "" {
			local sumwgt [pw=`jkmultvar']
		}
		local jk_wtype pweight
	}
	// prepare post
	tempname postid
	postfile `postid' `postextra' `names'	///
		using `"`saving'"', `double' `every' `replace'

	if inlist("`svy'`wtype'", "aweight", "") {
		local cmd1 `"cmd1(`version' `cmdname' `cmdargs' `wgt')"'
	}
	else	local cmd1 `"cmd1(`version' `cmdname' `cmdargs')"'
	local cmd2 `"cmd2(`cmdopts'`novar'`rest')"'
	if inlist("`svy'`wtype'", "", "aweight") {
		_loop_jknife `touse' `clid' `pseudo',		///
			command(`command')			///
			express(`express')			///
			`cmd1' `cmd2'				///
			n0(`N')					///
			nclust(`nclust')			///
			nfunc(`nfunc')				///
			postid(`postid')			///
			`nodots'				///
			`dots'					///
			`noisily'				///
			`trace'					///
			`reject'				///
			`checkmat'				///
			// blank
	}
	else if "`wtype'" == "fweight" {
		_loop_jknife_fw `touse' `clid' `pseudo',	///
			command(`command')			///
			express(`express')			///
			`cmd1' `cmd2'				///
			wvar(`wvar')				///
			n0(`N')					///
			nclust(`nclust')			///
			nfunc(`nfunc')				///
			postid(`postid')			///
			`nodots'				///
			`dots'					///
			`noisily'				///
			`trace'					///
			`reject'				///
			`stset'					///
			`checkmat'				///
			// blank
		// use the same weights to summarize results
		local sumwgt [fw=`jkmultvar']
		local jk_wtype fweight
	}
	else {
		if "`jkrw'" != "" {
			_loop_rw `touse' `subuse' `pseudo',	///
				caller(Jackknife)		///
				command(`command')		///
				express(`express')		///
				`cmd1' `cmd2'			///
				rwvars(`jkrw')			///
				owvar(`wvar')			///
				`pstropt'			///
				`calopt'			///
				postid(`postid')		///
				postextra(`strid' `jkrm' `fpc')	///
				`nodots'			///
				`dots'				///
				`noisily'			///
				`trace'				///
				`reject'			///
				`stset'				///
				`checkmat'			///
				sdot				///
				// blank
		}
		else {
			if "`wvar'" == "" {
				tempname wvar
				quietly gen double `wvar' = `touse'
			}
			if "`strata'" == "" {
				tempvar strid
				quietly gen byte `strid' = 1
			}
			if "`fpc'" != "" {
				local fpcopt fpc(`fpc')
			}
			if `usesvy' {
				local svyopt svy
			}
			_loop_jknife_iw `touse' `subuse'	///
				`strid' `clid' `ncl' `pseudo',	///
				command(`command')		///
				express(`express')		///
				`cmd1' `cmd2' `svyopt'		///
				`wtype'				///
				wvar(`wvar')			///
				`pstropt'			///
				`calopt'			///
				n0(`N')				///
				nclust(`nclust')		///
				strata(`strata')		///
				`fpcopt'			///
				nfunc(`nfunc')			///
				postid(`postid')		///
				`nodots'			///
				`dots'				///
				`noisily'			///
				`trace'				///
				`reject'			///
				`stset'				///
				`checkmat'			///
				// blank
		}
	}

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

	// merge in the pseudovalues, and label them
	if "`keep'" != "" {
		preserve
		quietly use `"`saving'"', clear
		_jk_pseudo `names' `sumwgt', b(`b') strata(`strata')
		sort `strata' `clid'
		tempfile keepfile
		quietly save `"`keepfile'"', replace
		restore
		sort `strata' `clid'
		quietly merge m:1 `strata' `clid' using `"`keepfile'"', nogen
		forval i = 1/`K' {
			local var : word `i' of `names'
			if "`firstofcl'" != "" {
				quietly replace `var' = . if !`firstofcl'
			}
			local label = usubstr(`"`exp`i''"',1,65)
			label var `var' `"pseudovalues: `label'"'
		}
		if "`idcluster'" != "" {
			capture confirm new variable `idcluster'
			if c(rc) {
				confirm variable `idcluster'
				drop `idcluster'
			}
			rename `clid' `idcluster'
		}
	}

	if "`svy'" != "" {
		if `"`subpop'"' != "" & !`usesvy' {
			if `"`posts'"' != "" {
				sum `subuse' [aw=`postwvar'] if `subuse', mean
			}
			else if `"`calmethod'"' != "" {
				sum `subuse' [aw=`calwvar'] if `subuse', mean
			}
			else {
				sum `subuse' [aw=`wvar'] if `subuse', mean
			}
			scalar `nsub' = r(N)
			scalar `nsubpop' = r(sum_w)
		}
		if "`jkrw'" != "" {
			if `goodstrid' {
				quietly tabulate `strid'
				if r(r) != `nstrata' + `nomit' {
					scalar `nstrata' = r(r)
				}
			}
			else if !`usesvy' {
				scalar `nstrata' = 1
			}
			scalar `npsu' = .
		}
	}

	// load/save file with jknife results
	preserve
	capture use `"`saving'"', clear
	if c(rc) {
		if inrange(c(rc),900,903) {
			di as err ///
"insufficient memory to load file with jackknife results"
		}
		error c(rc)
	}
	capture confirm var `clid'
	if !c(rc) {
		quietly drop `clid'
	}
	capture confirm var `jkstrvar'
	if c(rc) {
		local jkstrvar
	}
	else {
		char _dta[jk_strata] `"`jkstrvar'"'
	}
	if `"`jk_wtype'"' != "" {
		char _dta[jk_wtype] `jk_wtype'
		char _dta[jk_multiplier] `"`jkmultvar'"'
	}
	else {
		capture drop `jkmultvar'
		local jkmultvar
	}
	capture confirm var `jkfpcvar'
	if ! c(rc) {
		char _dta[jk_fpc] `"`jkfpcvar'"'
	}
	label data `"jackknife: `cmdname'"'
	char _dta[jk_command]		`"`command'"'
	char _dta[jk_cmdname]		`"`cmdname'"'
	char _dta[jk_names]  		`"`names'"'
	char _dta[jk_nfunction]		`"`nfunc'"'
	if "`svy'" != "" {
		char _dta[jk_svy]	`"`svy'"'
		char _dta[jk_su1]	`"`cluster'"'
		char _dta[jk_N_pop]	`"`=`npop''"'
		char _dta[jk_N_strata]	`"`=`nstrata''"'
		char _dta[jk_N_strata_omit]	`"`=`nomit''"'
		char _dta[jk_N_psu]	`"`=`npsu''"'
		if `"`subpop'"' != "" {
			char _dta[jk_N_sub]	`"`=`nsub''"'
			char _dta[jk_N_subpop]	`"`=`nsubpop''"'
			char _dta[jk_subpop]	`"`subpop'"'
		}
	}
	else if "`cluster'" != "" {
		char _dta[jk_cluster] 	`"`cluster'"'
		char _dta[jk_N_cluster]	`"`nclust'"'
	}
	if `"`wexp'"' != "" {
		if `:length local jk_wtype' == 0 {
			char _dta[jk_wtype]	`"`wtype'"'
		}
		char _dta[jk_wexp]	`"`wexp'"'
	}
	char _dta[jk_rweights]	`"`jkrw'"'
	char _dta[jk_N]		`=`nobs''

	// fix the column stripes
	if "`eexpress'" == "(_b)" ///
	 & inlist("`cmdname'", "ologit", "oprobit") ///
	 & missing(e(version)) {
		_prefix_relabel_eqns `b'
		local k_eq = s(k_eq)
		local k_aux = `k_eq' - 1
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
		if substr(`"`eq'"',1,1) == "/" {
			local eq `"`eq':"'
		}
		char `name'[coleq] `eq'
		char `name'[colname] `na'
		if `i' <= `k_eexp' {
			char `name'[is_eexp] 1
		}
	}
	char _dta[jk_version]	1

	if `"`filetmp'"' == "" {
		quietly save `"`saving'"', replace
	}

	// saved results
	tempname jk_v
	`version' ///
	capture noisily _jk_sum, `mse' `singleu'
	if c(rc) {
		ereturn clear
		exit c(rc)
	}
	matrix `jk_v'  = r(V)
	local singleton = r(singleton)
	if "`r(_N_strata)'" == "matrix" {
		tempname nstr nsin ncer
		matrix `nstr' = r(_N_strata)
		matrix `nsin' = r(_N_strata_single)
		matrix `ncer' = r(_N_strata_certain)
	}
	_copy_mat_stripes `jk_v' : `b'
	restore

	if "`eexpress'" == "(_b)" {
		if "`svy'" != "" {
			local xsca chi2_c p p_c ll ll_c ll0 ll_0 ///
				r2_p r2_a rmse rss mss
		}
		// make a copy of what is in -e()-, with some eXclusions
		local xmac cmd _estimates_name chi2type novariance
		if "`noecluster'" == "" {
			local xmac `xmac' clustvar
		}
		local xsca `xsca' F chi2 df_r df_m
		local xmat b V
		if "`svy'" != "" {
			local xmat `xmat' ///
				_N_strata _N_strata_single _N_strata_certain
		}
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
		if "`e(cmd)'" == "manova" {
			local xmac `xmac' r2 rmse
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

	if inlist("`cmdname'", "binreg", "glm") {
		if !missing(r(vf)) & r(vf) != 1 {
			matrix `jk_v' = r(vf)*`jk_v'
		}
	}

	quietly replace `touse' = (`touse'==1)
	ereturn post `b' `jk_v' `Cns', esample(`touse') `depname'

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
	ereturn local wtype	`wtype'
	ereturn local wexp	`"`wexp'"'
	if `:length local dof' {
		ereturn scalar df_r = `dof'
	}
	ereturn scalar k_eq	= `k_eq'
	ereturn scalar k_exp	= `k_exp'
	ereturn scalar k_eexp	= `k_eexp'
	ereturn scalar k_extra	= `k_extra'
	if missing(e(singleton)) {
		ereturn scalar singleton = `singleton'
	}
	if "`nstr'" != "" {
		ereturn matrix _N_strata	 `nstr'
		ereturn matrix _N_strata_single	 `nsin'
		ereturn matrix _N_strata_certain `ncer'
	}
	if "`k_aux'" != "" {
		ereturn scalar k_aux = `k_aux'
	}
	if "`eexpress'`k_exp'" != "(_b)0" {
		ereturn hidden local predict _no_predict
	}
	if "`svy'" != "" {
		ereturn scalar N_pop	= `npop'
		ereturn local N_sub
		ereturn local N_subpop
		ereturn local subpop
		ereturn local srssubpop
		if `"`subpop'"' != "" {
			ereturn scalar N_sub	= `nsub'
			ereturn scalar N_subpop	= `nsubpop'
			ereturn local subpop	`"`subpop'"'
			if "`vsrs'" != "" {
				ereturn local srssubpop	`srssub'
			}
		}
		ereturn scalar N_strata	= `nstrata'
		if missing(`npsu') {
			ereturn local N_psu
		}
		else	ereturn scalar N_psu	= `npsu'
		if "`jkrw'" == "" {
			ereturn local strata1	`strata'
			ereturn local fpc1	`fpc'
		}
		else {
			ereturn local strata1
			ereturn local fpc1
			ereturn local jkrweight	`jkrw'
		}
		ereturn local su1		`cluster'
		if !missing(e(stages)) {
			forval i = 2/`e(stages)' {
				ereturn local strata`i'
				ereturn local su`i'
				ereturn local fpc`i'
			}
		}
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
		if `is_sum' & "`nsubp'" != "" {
			ereturn matrix _N_subp = `nsubp'
		}
		if "`vsrswr'" != "" {
			ereturn matrix V_srswr = `vsrswr'
		}
		if "`vsrs'" != "" {
			ereturn matrix V_srs = `vsrs'
			// NOTE: V_srswr must be posted before the next line
			_svy_mkdeff
		}
	}
	else if `"`cluster'"' != "" {
		ereturn scalar N_clust = `nclust'
		ereturn local cluster `cluster'
		ereturn local clustvar `cluster'
	}
	if "`subpop'" == "" {
		if "`wtype'" == "fweight" {
			ereturn scalar N = `N'
		}
		else	ereturn scalar N = `nobs'
	}
	else if !`usesvy' {
		ereturn scalar N = `touseN'
	}
	if `"`title'"' != "" {
		ereturn local title `"`title'"'
	}
	else {
		_prefix_title `cmdname' "Jackknife results"
		ereturn local title `"`r(title)'"'
	}
	forval i = 1/`K' {
		ereturn local exp`i' `"`exp`i''"'
	}
	ereturn local command	`"`:list retok command'"'
	ereturn local nfunction	`"`nfunc'"'
	ereturn local keep `keep'
	if "`keep'" != "" {
		ereturn local pseudo `names'
	}
	// NOTE: this must be the last thing posted to -e()-
	ereturn local cmdname `cmdname'
	if "`svy'" != "" {
		ereturn local prefix svy
	}
	else	ereturn local prefix jackknife
	if "`eexpress'`k_exp'" != "(_b)0" {
		ereturn hidden local predict _no_predict
		ereturn local cmd jackknife
	}
	else {
		if !inlist("`e(predict)'", "_no_predict") &	///
		   !inlist("`ecmd'", "anova", "manova") {
			// compute e(F) or e(chi2), and e(df_m)
			_prefix_model_test `cmdname', `svy' `adjust'
		}
		if "`ecmd'" == "" {
			ereturn local cmd jackknife
		}
		else {
			ereturn local cmd `ecmd'
			if `"`e(prefix_epilog)'"' != "" {
				`e(prefix_epilog)'
			}
		}
	}
	// Display output
	if "`replay'" != "" & "`svy'`table'`header'`legend'`verbose'" == "" {
		`version' `replay', `diopts'
	}
	else {
		if "`e(cmd)'`first'" == "ivregfirst" {
			_svy_ivreg_first, `diopts'
		}
		`version' Display, `diopts'
	}
end

program Display, sclass
	version 9.2
	local version : di "version " string(_caller()) ":"
	local extra = `"`e(cmd)'"' != `"`e(cmdname)'"'
	if `"`e(cmd)'"' != "" {
		is_svysum `e(cmd)'
		local is_svysum = r(is_svysum)
		local svylist svyb svyj svyr svylb svyg
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

program RWeights, sortpreserve sclass
	// NOTE: this routine assumes the number of replicate weight variables
	// is less or equal to the number of observations in the dataset.

	_on_colon_parse `0'
	// replicate weight variables
	local varlist `s(after)'
	local nvars : word count `varlist'

	// output variables
	tokenize `s(before)'
	args jkrm strata fpc		// typically tempvar names
	tempvar id

quietly {

	// default values for output variables
	gen double `jkrm' = (`nvars'-1)/`nvars'	in 1/`nvars'
	gen str `strata' = ""			in 1/`nvars'
	gen double `fpc' = 0			in 1/`nvars'
	gen `c(obs_t)' `id' = _n

	local calldefault noisily ///
		RW_defaults `jkrm' `strata' `fpc' `id' `nvars'

	forval i = 1/`nvars' {
		local var : word `i' of `varlist'
		// get stratum id
		replace `strata' = `"`: char `var'[jk_stratum]'"' in `i'
		// get FPC value
		local fpcval : char `var'[jk_fpc]
		if `"`fpcval'"' != "" {
			capture {
				confirm number `fpcval'
				assert `fpcval' >= 0
			}
			if c(rc) {
				`calldefault'
				exit
			}
			replace `fpc' = `fpcval' in `i'
		}
		// get multiplier
		local multiplier : char `var'[jk_multiplier]
		if `"`multiplier'"' != "" {
			capture {
				confirm number `multiplier'
				assert `multiplier' > 0
			}
			if c(rc) {
				`calldefault'
				exit
			}
			replace `jkrm' = `multiplier' in `i'
		}
	}
	local goodstrid 1
	sreturn clear
	capture assert `strata' == "" in 1/`nvars'
	if !c(rc) {
		replace `strata' = "one" in 1/`nvars'
		local goodstrid 0
	}
	else {
		capture assert `strata' != "" in 1/`nvars'
		if c(rc) {
			`calldefault'
			local goodstrid 0
		}
	}
	capture bysort `strata': assert `fpc' == `fpc'[1]
	if c(rc) {
		`calldefault'
		local goodstrid 0
	}
	capture by `strata': assert reldif(`jkrm', `jkrm'[1]) < 1e-7
	if c(rc) {
		`calldefault'
		local goodstrid 0
	}
	sreturn local goodstrid `goodstrid'

} // quietly

end

program RW_defaults
	args jkrm strata fpc id nvars
	di as txt "{p 0 0 2}" ///
"(note: some replicate weight variables have inconsistent " ///
"characteristics; ignoring these characteristics){p_end}"
	sort `id'
	quietly replace `jkrm' = (`nvars'-1)/`nvars'	in 1/`nvars'
	quietly replace `strata' = "one"		in 1/`nvars'
	quietly replace `fpc' = 0			in 1/`nvars'
end

program Check4Over, sclass
	syntax [, over(passthru) * ]
	sreturn local overopt `"`over'"'
end

program CheckLRMODEL
	syntax name(name=cmdname) [, LRMODEL * ]
	if ("`lrmodel'"!="") {
		_check_lrmodel `cmdname', prefix(jackknife)
	}
end

exit
