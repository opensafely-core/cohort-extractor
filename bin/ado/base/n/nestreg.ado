*! version 1.5.0  28aug2019
program define nestreg, byable(recall) rclass
	version 9.1
	local vv : di "version " string(_caller()) ", missing:"

	set prefix nestreg
	set fvtrack term

	quietly ssd query
	if (r(isSSD)) {
		di as err "nestreg not possible with summary statistic data"
		exit 111
	}
	// <my_stuff> : <command>
	_on_colon_parse `0'
	local command `"`s(after)'"'
	local 0 `"`s(before)'"'

	// quick check for special options
	syntax [fw iw pw aw] [if] [in] [,		///
			WALDtable			///
			LRtable				///
			QUIetly				///
			store(name)			///
		]
	if "`weight'" != "" {
		local wgt [`weight'`exp']
	}
	if _by() & "`store'" != "" {
		di "option store() is not allowed with by"
		exit 190
	}

	// parse the command and check for conflicts
	`vv' _prefix_command nestreg `wgt' `if' `in' : `command'

	local vv	`"`s(version)'"'
	local cmdname	`"`s(cmdname)'"'
	local termlist	`"`s(anything)'"'
	local wgt	`"`s(wgt)'"'
	local weight	`"`s(wtype)'"'
	local exp	`"`s(wexp)'"'
	local if	`"`s(if)'"'
	local in	`"`s(in)'"'
	local cmdopts	`"`s(options)'"'
	if "`s(level)'" != "" {
		local cmdopts `"`cmdopts' level(`s(level)')"'
	}
	local rest	`"`s(rest)'"'

	if `"`cmdname'"' == "svy" {
		local svy `"`cmdname' `termlist', `cmdopts' :"'
		local svyopt svy
		_on_colon_parse `command'
		local command `"`s(after)'"'
		`vv' _prefix_command nestreg `wgt' `if' `in' svy	///
			: `command'

		local vv	`"`s(version)'"'
		local cmdname	`"`s(cmdname)'"'
		local termlist	`"`s(anything)'"'
		local if	`"`s(if)'"'
		local in	`"`s(in)'"'
		local cmdopts	`"`s(options)'"'
		local rest	`"`s(rest)'"'
	}
	local termlist	`"`s(anything0)'"'

	CheckProps `cmdname' `lrtable'
	Check4Robust "`lrtable'" `wgt', `cmdopts' `svyopt'

	// build up part of the command that follows the varlist
	local cmdrest `"`wgt'"'
	if `"`cmdopts'"' != "" {
		local cmdrest `"`cmdrest', `cmdopts'"'
	}
	if `"`rest'"' != "" {
		local cmdrest `"`cmdrest' `rest'"'
	}

	// note: marksample looks at `varlist' `if' `in' and [`weight'`exp']
	// and takes into account if I am being called with the -by:- prefix
	marksample touse, novarlist

	if "`svyopt'" != "" {
		tempvar subuse
		_svy_setup `touse' `subuse', cmdname(nestreg) svy
		drop `subuse'
	}

	// parse termlist, and build the list of variable names
	if _caller() >= 16 {
		local IF "if `touse'"
	}
	`vv' _prefix_depvarblocklist `cmdname'			///
		: depvar termlist vlist k term	"`IF'"		///
		: `termlist'

	// error if there are estimation results stored using our names
	if "`store'" != "" {
		forval i = 1/`k' {
			capture estimates dir `store'`i'
			if !c(rc) {
				di as err ///
				"estimation results `store'`i' already exist"
				exit 322
			}
		}
	}
	if _caller() >= 16 {
		quietly `vv' _rmcollblocks `termlist' if `touse' `wgt'
		local termlist `"`r(varblocklist)'"'
		local vlist `"`r(varlist)'"'
		local k = r(k)
		forval i = 1/`k' {
			local term`i' `"`r(block`i')'"'
		}
	}
	else {
		_rmcollright `termlist' if `touse' `wgt'
		_prefix_varblocklist		///
			termlist vlist k term 	///
			: `r(varblocklist)'
	}
	set fvbase off
	if "`cmdname'" == "intreg" {
		markout `touse' `vlist'
	}
	else {
		markout `touse' `depvar' `vlist'
	}
	if inlist("`cmdname'", "stcox", "streg", "stcrr", "stcrre", "stcrreg") {
		capture replace `touse' = 0 if _st == 0
	}

	quietly `vv' `svy' `cmdname' `depvar' `vlist' if `touse' `cmdrest'
	// check for missing standard errors
	_prefix_omitted `vlist' :
	local dropped "`s(omitted)'"
	// check for dropped variables
	foreach drop of local dropped {
		forval i = `k'(-1)1 {
			_ms_mark_omitted drop `drop' `term`i''
			if `"`s(found)'"' == "yes" {
				local term`i' `"`s(list)'"'
				continue, break
			}
		}
	}
	local tdim 0
	forval i = 1/`k' {
		if `:length local term`i'' {
			local ++tdim
			if `tdim' < `i' {
				local term`tdim' : copy local term`i'
			}
			local tlist `"`tlist' (`term`i'')"'
		}
	}
	if `tdim' == 0 {
		di as err ///
		"all variables were dropped because of estimability"
		exit 322
	}
	local k = `tdim'
	local termlist `"`tlist'"'
	foreach dvar of local dropped {
		_msparse `dvar', noomit
		di as txt ///
"note: `r(stripe)' dropped because of estimability"
	}
	// check for dropped observations
	quietly count if `touse' & !e(sample)
	local lcmd : length local cmdname
	if r(N) & ! inlist("`cmdname'",				///
			bsubstr("logit",1,max(4,`lcmd')),	///
			bsubstr("probit",1,max(4,`lcmd'))) {
		if "`svyopt'" == ""			///
		 | ("`svyopt'" != "" & e(N_strata_omit) == 0) {
			di as err			///
"{p 0 0 2}`r(N)' obs. dropped because of estimability, "	///
"this violates the nested model assumption{p_end}"
			exit 322
		}
	}

	forval i = 1/`k' {
		local rowna `rowna' block`i'
	}

	capture confirm integer number `e(df_r)'
	if !c(rc) {
		local type F
	}
	else {
		local type chi2
	}

	if "`waldtable'`lrtable'" == "" {
		local waldtable waldtable
	}

	if "`waldtable'" != "" {
		tempname wmat
		if "`type'" == "F" {
			matrix `wmat' = J(`k',4,.z)
			matrix colna `wmat' = `type' df_block df_r pvalue
			matrix rowna `wmat' = `rowna'
		}
		else {
			matrix `wmat' = J(`k',3,.z)
			matrix colna `wmat' = "Wald `type'" df_block pvalue
			matrix rowna `wmat' = `rowna'
		}
		local lcmd : length local cmdname
		if "`cmdname'" == bsubstr("regress",1,max(1,`lcmd')) {
			tempname r2mat r2old
			matrix `r2mat' = J(`k',2,.z)
			matrix colna `r2mat' = R2 deltaR2
			matrix rowna `r2mat' = `rowna'
			scalar `r2old' = .
		}
	}

	if "`lrtable'" != "" {
		tempname lmat
		matrix `lmat' = J(`k',6,.z)
		matrix colna `lmat' = LL LR df_block pvalue AIC BIC
		matrix rowna `lmat' = `rowna'

		// fit the empty model
		quietly `vv' `cmdname' `depvar' if `touse' `cmdrest'
		tempname ll0 df0 rank
		GetLR `ll0' `df0'
	}

	local curr // empty
	di
	forval i = 1/`k' {

		di as txt "Block " %2.0f `i' as txt ": `dots'`term`i''"

`quietly' `vv' `svy' `cmdname' `depvar' `curr' `term`i'' if `touse' `cmdrest'

		CmdLine `cmdname' `depvar' `curr' `term`i'' `if' `in' `cmdrest'
		if "`store'" != "" {
			estimates store `store'`i'
		}

		`quietly' di

		if "`lmat'" != "" {
			GetRankV
			scalar `rank' = r(rankV)
			quietly LRtest `ll0' `df0'
			matrix `lmat'[`i',1] = r(ll)
			matrix `lmat'[`i',2] = r(lr)
			matrix `lmat'[`i',3] = r(df)
			matrix `lmat'[`i',4] = r(p)
			// AIC = -2*ll + 2*df
			matrix `lmat'[`i',5] = -2*r(ll) + 2*`rank'
			// BIC = -2*ll + log(N)*edf
			matrix `lmat'[`i',6] = -2*r(ll) + log(e(N))*`rank'
			GetLR `ll0' `df0'
		}
		if "`wmat'" != "" {
			quietly test `term`i''
			if "`type'" == "F" {
				matrix `wmat'[`i',1] = r(`type')
				matrix `wmat'[`i',2] = r(df)
				matrix `wmat'[`i',3] = e(df_r)
				matrix `wmat'[`i',4] = r(p)
			}
			else {
				matrix `wmat'[`i',1] = r(`type')
				matrix `wmat'[`i',2] = r(df)
				matrix `wmat'[`i',3] = r(p)
			}
			if "`r2mat'" != "" {
				matrix `r2mat'[`i',1] = e(r2)
				if `i' != 1 {
					matrix `r2mat'[`i',2] = e(r2)-`r2old'
				}
				scalar `r2old' = e(r2)
			}
		}
		local curr `curr' `term`i''
	}

	if "`wmat'" != "" {
		di
		WaldTable `wmat' "`r2mat'" `svy'
		if "`r2mat'" != "" {
			mat `wmat' = `wmat', `r2mat'
		}
		return matrix wald	= `wmat'
	}
	if "`lmat'" != "" {
		di
		LLTable `lmat'
		return matrix lr	= `lmat'
	}
end

program CmdLine, eclass
	ereturn local cmdline `"`:list retok 0'"'
end

program WaldTable
	args wmat r2mat svy
	local c1 = colsof(`wmat')
	if "`r2mat'" != "" {
		local c2 = colsof(`r2mat')
	}
	else	local c2 0
	local r = rowsof(`wmat')

	local wd 9
	local colna : colna `wmat', quote
	gettoken type : colna
	if "`type'" == "F" {
		local dfw              7    `=`wd'+1'
		local dffmt            .           .
		local dfcol            .           .
		local dftfmt           .           .
		local dfpad            .           .
		if "`svy'" == "" {
			local dft1     `""Block"  "Residual""'
		}
		else	local dft1     `""Block"  "Design""'
		local dft2        `""df"        "df""'
		local tw	       .
		local tfmt	 "%7.2f"
		local ttfmt 	       .
	}
	else {
		local dfw        8
		local dffmt      .
		local dfcol      .
		local dftfmt     .
		local dfpad      .
		local dft1  `""""'
		local dft2  "df"
		local tw 	10
		local tfmt  "%9.2f"
		local ttfmt "%10s"
	}
	if "`r2mat'" != "" {
		local R2w       .        .
		local R2fmt %`=`wd'-3'.4f    %`=`wd'-3'.4f
		local R2col     .        .
		local R2tfmt    .        .
		local R2pad     2        2
		local R2t1   `""" "Change""'
		local R2t2 `""R2"  "in R2""'
	}
	forval j = 1/`c1' {
		local row `"`macval(row)' `wmat'[\`i',`j']"'
	}
	forval j = 1/`c2' {
		local row `"`macval(row)' `r2mat'[\`i',`j']"'
	}

	tempname tab
	// table setup
	.`tab' = ._tab.new, width(`wd') columns(`=1+`c1'+`c2'') ignore(.z)
	.`tab'.width  |     7 |    `tw'    `dfw'         .    `R2w' |
	.`tab'.numfmt       .    `tfmt'  `dffmt'     %6.4f  `R2fmt'
	.`tab'.numcolor  text         .  `dfcol'         .  `R2col'
	.`tab'.pad          .         1  `dfpad'         2  `R2pad'
	.`tab'.titlefmt     .   `ttfmt' `dftfmt'         . `R2tfmt'

	// table display
	.`tab'.sep, top
	if "`type'" == "F" | "`r2mat'" != "" {
	.`tab'.titles      ""        ""   `dft1'       ""   `R2t1'
	}
	.`tab'.titles "Block"  "`type'"   `dft2' "Pr > F"   `R2t2'
	.`tab'.sep, middle
	forval i = 1/`r' {
		.`tab'.row `i' `row'
	}
	.`tab'.sep, bottom
end

program LLTable
	args lmat
	local c = colsof(`lmat')
	local r = rowsof(`lmat')
	forval j = 1/`c' {
		local row `"`macval(row)' `lmat'[\`i',`j']"'
	}

	local wd 9

	tempname tab
	// table setup
	.`tab' = ._tab.new, width(`wd') columns(`=1+`c'') ignore(.z)
	.`tab'.width  |     7 |    11     .       7         .     10    10 |
	.`tab'.numfmt       .   %9.0g %7.2f       .     %6.4f      .     .
	.`tab'.numcolor  text       .     .       .         .      .     .
	.`tab'.pad          .       1     1       .         2      .     .
	// table display
	.`tab'.sep, top
	.`tab'.titles "Block"    "LL"  "LR"    "df" "Pr > LR"  "AIC" "BIC"
	.`tab'.sep, middle
	forval i = 1/`r' {
		.`tab'.row `i' `row'
	}
	.`tab'.sep, bottom
end

// modified code originally taken from estimates.ado
program define GetRankV, rclass
	tempname r V

	scalar `r' = e(rank)
	if `r' >= . {
		mat `V' = syminv(e(V))
		scalar `r' = colsof(`V') - diag0cnt(`V')
	}
	return scalar rankV = `r'
end

program CheckProps
	args cmdname lrtable
	local props : properties `cmdname'
	local swlist sw swml
	local swprop : list swlist & props
	if "`swprop'" == "" { 
		version 16: ///
		di as err "{bf:`cmdname'} is not supported by {bf:nestreg}"
		exit 199
	}
	if "`lrtable'" != "" {
		local swlist swml
		if `"`:list swlist & props'"' == "" {
			version 16: di as err ///
		"{bf:`cmdname'} does not allow the lrtable option of {bf:nestreg}"
			exit 199
		}
	}
end

program Check4Robust
	gettoken lr 0 : 0
	if ("`lr'" == "") exit
	syntax [fw pw aw iw] [, svy Robust CLuster(passthru) vce(string) * ]

	local lvce : length local vce
	if "`weight'" == "pweight" | "`robust'`cluster'`svy'" != "" ///
	 | `"`vce'"' == bsubstr("robust",1,max(1,`lvce')) {
		if "`svy'" != "" {
			di as err "option `lr' is not allowed with svy"
		}
		else	di as err ///
"option `lr' is not allowed with pweights, robust, or cluster()"
		exit 198
	}
end

program LRtest, rclass
	args ll1 df1
	tempname ll0 df0
	GetLR `ll0' `df0'
	return scalar ll = `ll0'
	return scalar lr = 2*abs(`ll1'-`ll0')
	return scalar df = abs(`df1' - `df0')
	return scalar p = chiprob(abs(`df1' - `df0'), abs(2*(`ll1'-`ll0')))
end

program GetLR
	args ll df
	capture confirm number `e(ll)'
	if c(rc) {
		di as err ///
"option lrtable requires that e(ll) contains the " ///
"log likelihood value for the model fit"
		exit 322
	}
	capture {
		confirm integer number `e(df_m)'
		assert e(df_m) >= 0
	}
	if c(rc) {
		di as err ///
"option lrtable requires that e(df_m) contains the " ///
"model degrees of freedom"
		exit 322
	}
	scalar `ll' = e(ll)
	scalar `df' = e(df_m)
end

exit
