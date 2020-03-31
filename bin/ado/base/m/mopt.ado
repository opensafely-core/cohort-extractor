*! version 1.7.3  23aug2019
program mopt
	local vv : di "version " string(_caller()) ":"
	version 12

	gettoken subcmd 0 : 0, parse(" ,")

	local lcmd : length local subcmd

	if "`subcmd'" == "clear" {
		Clear
		exit
	}
	if `"`subcmd'"' == "hold" {
		ml_hold `0'
		exit
	}
	if `"`subcmd'"' == "unhold" {
		ml_unhold `0'
		exit
	}
	if "`subcmd'" == "score" {
		if _caller() > 12 {
			`vv' Score `0'
		}
		else {
				Score `0'
		}
		exit
	}
	if "`subcmd'" == "count" {
		Count `0'
		exit
	}
	if "`subcmd'" == "trace" {
		Trace `0'
		exit
	}
	if "`subcmd'" == bsubstr("graph",1,max(2,`lcmd')) {
		Graph `0'
		exit
	}
	if "`subcmd'" == "init" {
		Interactive 0
		`vv' Init `0'
		exit
	}
	if "`subcmd'" == bsubstr("maximize",1,max(3,`lcmd')) {
		Interactive 1
		`vv' MaxMin maximize `0'
		exit
	}
	if "`subcmd'" == bsubstr("minimize",1,max(3,`lcmd')) {
		Interactive 1
		`vv' MaxMin minimize `0'
		exit
	}
	if "`subcmd'" == bsubstr("display",1,max(2,`lcmd')) {
		Display `0'
		exit
	}
	if "`subcmd'" == bsubstr("footnote",1,max(4,`lcmd')) {
		ml_footnote `0'
		exit
	}
	if "`subcmd'" == "," {
		Display, `0'
		exit
	}
	if "`subcmd'" == bsubstr("model",1,max(3,`lcmd')) {
		`vv' capture noi Model `0'
		if c(rc) {
			local rc = c(rc)
			Clear
			exit `rc'
		}
		exit
	}
	if inlist("`subcmd'", "", bsubstr("query",1,max(1,`lcmd'))) {
		Query `0'
		exit
	}
	if "`subcmd'" == bsubstr("report",1,max(3,`lcmd')) {
		Report `0'
		exit
	}
	if "`subcmd'" == bsubstr("search",1,max(3,`lcmd')) {
		Interactive 1
		Search `0'
		exit
	}
	if "`subcmd'" == bsubstr("plot",1,max(2,`lcmd')) {
		`vv' Plot `0'
		exit
	}
	if "`subcmd'" == "check" {
		Check `0'
		exit
	}

	di as err `"subcommand {bf:ml} {bf:`subcmd'} is unrecognized"'
	exit 199
end

// subcommands --------------------------------------------------------------

program Clear
	syntax [, NOTANOPTION]
	capture drop $ML_w
	capture drop $ML_samp
	capture drop $ML_sample
	capture drop $ML_subv
	capture drop $ML_grp
	mata: Mopt_drop_external()
	macro drop ML_*
end

program Score, rclass
	syntax anything(name=scvars id="newvarlist")	///
		[if] [in] [, OLDOLOGit MISSing USERinfo(passthru) * ]

	marksample touse, novarlist

	if "`oldologit'" != "" {
		// option -oldologit- is not allowed
		local 0 , `oldologit'
		syntax [, NONOPTION ]
		exit 198		// [sic]
	}
	if "`e(cmd)'" != "" {
		if "`e(prefix)'" == "svy" {
			local pre "svy:"
		}
		local cmd `e(cmd)'
		ChkMethod method : `cmd'
	}
	else	error 301

	local depvars	`e(depvar)'
	tempname b
	if "`e(b)'" != "matrix" {
		error 301
	}
	matrix `b' = e(b)

	// Macros
	// eqnames	 : list of equation names
	// eq`i'freeparm : freeparm option for the `i'th equation
	// eq`i'xvars	 : list of predictors for the `i'th equation
	// eq`i'nocons	 : noconstant option for the `i'th equation
	// neq		 : number of equations
	_get_eqspec eqnames eq neq : `b'

	local vtype v0 v1 v2 gf0 gf1 gf2
	local vtype : list method in vtype
	if `vtype' {
		local nscore = colsof(`b')
		local ignoreeq ignoreeq
	}
	else	local nscore `neq'

	_score_spec `scvars', b(`b') `ignoreeq' `options'
	local spec	`s(eqspec)'
	local scvars	`s(varlist)'
	local typlist	`s(typlist)'
	if `nscore' > 1 & `:list sizeof typlist' == 1 {
		forval i = 1/`neq' {
			local typcp `typcp' `typlist'
		}
		local typlist `typcp'
	}
	if "`spec'" != "" {
		local spec = bsubstr("`spec'",2,.)	// drop '#'
		local scvari `scvars'			// newvarname
		local scvars
		forval i = 1/`nscore' {
			tempname sci
			local scvars `scvars' `sci'
		}
	}
	else {
		local spec _all_
	}

	confirm new var `scvars' `scvari'

	if "`e(group)'" != "" {
		local group group(`e(group)')
	}

	// build equation specifications for -ml model-
	local EQNAMES : copy local eqnames
	local TYPLIST : copy local typlist
	forval i = 1/`neq' {
		gettoken eq EQNAMES : EQNAMES
		gettoken typ TYPLIST : TYPLIST
		_get_offopt `e(offset`i')'
		if `"`s(offopt)'"' == "" & `i' == 1 {
			_get_offopt `e(offset)'
		}
		local opts `eq`i'nocons' `eq`i'freeparm' `s(offopt)'
		if "`missing'" == "" & `:length local eq`i'xvars' {
			markout `touse' `eq`i'xvars'
		}
		if `i' == 1 {
			if "`missing'" == "" {
				markout `touse' `depvars'
			}
			local model "(`eq': `depvars' = `eq`i'xvars', `opts')"
		}
		else {
			local model "`model' (`eq': `eq`i'xvars', `opts')"
		}
		local xvars `xvars' `eq`i'xvars'
	}
	if "`e(wtype)'" != "" {
		local wt [`e(wtype)'`e(wexp)']
	}
	ChkEval eval

	local scores
	forval i = 1/`nscore' {
		tempname scorei
		quietly gen `typ' `scorei' = . in 1
		local scores `scores' `scorei'
	}

nobreak {

	ml_hold

	tempname ehold
	_est hold `ehold', restore copy

capture noisily quietly break {

	if "`method'" == "lf" {
		tempname scale h
		matrix `scale'	= e(ml_scale)
		matrix `h'	= e(ml_h)
	}
	local which = e(which)

	Model `method' `eval' `model' `wt' if `touse',	///
		init(`b') nopreserve collinear `missing' `group' `userinfo'

	noisily mata: Mopt_score(1)

	if `neq' == 1 & !`vtype' {
		label var `scores' "equation-level score from `pre'`cmd'"
	}
	else {
		local SCORES : copy local scores
		local EQNAMES : copy local eqnames
		if !`vtype' {
			forval i = 1/`neq' {
				gettoken scorei SCORES : SCORES
				gettoken eq EQNAMES : EQNAMES
				if "`eq`i'xvars'" == "" & `i' != 1 {
					local eqi "/`eq'"
				}
				else	local eqi "[`eq']"
				label var `scorei' ///
"equation-level score for `eqi' from `pre'`cmd'"
			}
		}
		else {
			local j 1
			forval i = 1/`neq' {
				gettoken eq EQNAMES : EQNAMES
				if `"`eq'"' == "_" | `neq' == 1 {
					local eq
				}
				else	local eq `"[`eq']"'
				foreach x of local eq`i'xvars {
					gettoken scorei SCORES : SCORES
					label var `scorei' ///
				"score for `eq'_b[`x'] from `pre'`cmd'"
					local ++j
				}
				if ! `:length local eq`i'nocons' {
					gettoken scorei SCORES : SCORES
					label var `scorei' ///
				"score for `eq'_b[_cons] from `pre'`cmd'"
					local ++j
				}
			}
		}
	}
	if "`spec'" != "_all_" {
		forval i = 1/`spec' {
			gettoken score scores : scores
		}
		rename `score' `scvari'
		local scores `scvari'
	}
	else {
		local SCORES : copy local scores
		local SCVARS : copy local scvars
		forval i = 1/`nscore' {
			gettoken old SCORES : SCORES
			gettoken new SCVARS : SCVARS
			rename `old' `new'
		}
		local scores : copy local scvars
	}

} // capture noisily quietly break

	local rc = c(rc)

	ml_unhold
	Clear

} // nobreak

	if (`rc') exit `rc'

	tempvar nomis
	mark `nomis'
	markout `nomis' `scores'
	quietly count if !`nomis'
	if r(N) > 0 {
		di as txt "(`r(N)' missing values generated)"
	}

	return local scorevars `scores'
end

program Count
	if ! `:length local 0' {
		if "$ML_stat" == "model" {
			mata: Mopt_get_counts()
			if ! `:length local user' {
				di as txt "count off"
				exit
			}
			CountList		///
				"`user'"	///
				"`cnt0'"	///
				"`cnt1'"	///
				"`cnt2'"	///
				"`cnt_'"
			exit
		}
		else if "`e(opt)'" == "moptimize" {
			CountList		///
				"`e(user)'"	///
				"`e(cnt0)'"	///
				"`e(cnt1)'"	///
				"`e(cnt2)'"	///
				"`e(cnt_)'"
			exit
		}
	}
	local 0 : list retok 0
	mata: Mopt_set_count("`0'")
end

program Trace
	syntax name(name=onoff id="trace argument")
	if !inlist("`onoff'", "on", "off") {
		error 198
	}
	mata: Mopt_set_trace()
end

program Graph
	syntax [anything(name=n)] [, SAVing(passthru) NAME(passthru)]
	if ! `:length local n' {
		local n 20
	}
	else {
		capture numlist "`n'", max(1) integer range(>=2 <=20)
		if c(rc) {
			di as err "# must be between 2 and 20"
			exit 198
		}
		local n : copy local numlist
	}
	tempname y x
	local N = `n' + 1
	if `N' > c(N) {
		preserve
		quietly set obs `N'
	}
	quietly gen `y' = .
	quietly gen `x' = .

	// generates macro `crittype' and fills in the following stata
	// variables:
	// 	`y'	-- value of the optimization criterion
	// 	`x'	-- iteration id
	mata: Mopt_graph_gen()

	sum `x' in 1/`n', mean
	if ! r(N) {
		error 2000
	}
	local min = r(min)
	local max = r(max)
	if `min' == `max' {
		local max = `max' + 1
	}
	local np = `max' - `min' + 1
	if `np' <= 10 {
		local xlab "xlab(`min'/`max')"
	}
	else {
		local xlab "xlab(`min'(2)`max')"
	}

	graph twoway (connected `y' `x' in 1/`n'),	///
		ytitle("`crittype'")			///
		xtitle("Iteration number")		///
		`xlab'					///
		`saving'				///
		`name'
end

program Interactive
	args val
	ChkMacros
	mata: Mopt_init_interactive(`val')
end

program Init
	version 12
	local vv : di "version " string(_caller()) ":"
	// parsing/setting initial values
	tempname b0
	mata: Mopt_get_b0()
	`vv' ///
	_mkvec `b0', from(`0') update first error("initial vector")
	mata: Mopt_set_b0()
end

program MaxMin, eclass
	local vv : di "version " string(_caller()) ":"
	version 12
	ChkMacros
	syntax name(name=maxmin) [,		///
		NEGH				///
		TOLerance(numlist max=1 >=0)	///
		LTOLerance(numlist max=1 >=0)	///
		NONRTOLerance			///
		NRTOLerance(numlist max=1 >=0)	///
		QTOLerance(numlist max=1 >=0)	///
		GTOLerance(numlist max=1 >=0)	///
		ITERate(numlist max=1 >=0)	///
		NOTCONCAVE(numlist max=1 >=0)	/// NOT documented
		ndami				///
		DIFficult			///
		HALFSTEPonly			/// NOT documented
		DOOPT				/// NOT documented
		SEArch(name)			/// search options
		Repeat(passthru)		///
		Bounds(string)			///
		SCore(string)			///
		noWARNing			///
		noCLEAR				///
		NOLOg LOg			/// tracelog:	none
		DOTs				///		dots
		SHOWTOLerance			///		tolerance
		SHOWNRtolerance			///		tolerance
		SHOWSTEP			///		step
		TRace				///		params
		COEFDIffs			///		paramdiffs
		GRADient			///		gradient
		HESSian				///		hessian
		noSKIPline			///
		noOUTput			/// display options
		Level(cilevel)			///
		moptobj(string)			/// NOT documented
		*				///
	]

	if `:length local nrtolerance' {
		opts_exclusive "nrtolerance() `nonrtolerance'"
	}
	if `:length local qtolerance' {
		opts_exclusive "qtolerance() `nonrtolerance'"
	}
	opts_exclusive "`nonrtolerance' `shownrtolerance'"
	if `:length local shownrtolerance' {
		local showtolerance showtolerance
	}

	if "$ML_preserve" != "no" {
		if `:length local score' {
			#delimit ;
			di as err
"May not specify score() option unless" _n
"     a)  estimation subsample is the entire data in memory, or" _n
"     b)  you specify nopreserve option on -ml model- statement (meaning" _n
"         your evaluation program explicitly restricts itself to obs." _n
"         for which $" "ML_samp==1." ;
			#delimit cr
			exit 198
		}
		preserve
		local N = c(N)
		quietly keep if $ML_sample
		if (`N' != c(N)) {
			mata: Mopt_init_regetviews()
		}
	}
	if `:length local score' {
		SetupScore `"$ML_evaltype"' `"`score'"' $ML_n $ML_dim
		local scores "`s(scores)'"
	}
	
	_parse_iterlog, `nolog' `log'
	local log "`s(nolog)'"

	local tropts	`log'			///
			`dots'			///
			`showtolerance'		///
			`showstep'		///
			`trace'			///
			`coefdiffs'
	if "`tropts'" != "nolog" {
		local tropts	`tropts'		///
				`gradient'		///
				`hessian'
		if "`skipline'" == "" {
			if "`iterate'" != "0" | `:length local tropts' {
				di
			}
		}
	}
	else {
		local gradient
		local hessian
		local nolog nolog
	}

	if "`search'" != "off" & "`iterate'" != "0" {
		if "`search'" == "quietly" {
			local sopts nolog
		}
		else {
			if `:length local tropts' {
				if "`tropts'" != "nolog" {
					local sopts trace
				}
				else	local sopts nolog
			}
		}
		if "`search'" == "norescale" {
			local sopts `sopts' norescale
		}
		Search `bounds', nopreserve `sopts' `repeat' `maxmin'
	}

	tempname value b V iV
	`vv' mata: Mopt_maxmin()

	ereturn scalar k_eq_model = abs($ML_waldtest)
	if `:length global ML_ll_0' {
		ereturn scalar ll_0 = $ML_ll_0
		if `:length global ML_rank0' {
			ereturn scalar rank0 = $ML_rank0
			ereturn scalar df_m = e(rank) - $ML_rank0
		}
		else	ereturn scalar df_m = e(rank) - $ML_k0
	}
	if !`:length global ML_ll_0' ///
	 | inlist(e(vce), "robust", "cluster", "linearized") {
		// NOTE: requires e(k_eq_model)
		if "$ML_svy" == "" {
			_prefix_model_test, minimum
		}
		else {
			_prefix_model_test, $ML_svy $ML_noadj
		}
	}
	else if `:length global ML_ll_0' {
		if `"`maxmin'"' == "minimize" {
			ereturn scalar chi2 = -2*(e(ll)-e(ll_0))
		}
		else {
			ereturn scalar chi2 = 2*(e(ll)-e(ll_0))
		}
		ereturn scalar p    = chi2tail(e(df_m), e(chi2))
		ereturn local chi2type "LR"
	}
	if `:length global ML_wexp' {
		ereturn local wtype `"$ML_wtyp"'
		ereturn local wexp `"$ML_wexp"'
	}
	if `:length global ML_group' {
		ereturn local group `"$ML_group"'
		if `"`e(clustvar)'"' == "$ML_grp" & "$ML_grp" != "" {
			ereturn local clustvar `"$ML_group"'
		}
	}
	ereturn local cmd "ml"

	if `:length local score' {
		// NOTE: 'scores' macro defined earlier by -SetupScore-
		mata: Mopt_score(0)
		ereturn local scorevars `scores'
	}

	if "$ML_preserve" != "no" {
		restore
		if "`e(prefix)'" == "svy" & e(N_strata_omit) {
			// NOTE: Update $ML_sample for omitted strata.
			tempname v
			quietly _svy2 $ML_sample	///
				if $ML_sample,		///
				type(total)		///
				svy			///
				v(`v')			///
				subpop(`e(subpop)')	///
				touse($ML_sample)
		}
		ereturn repost, esample($ML_sample)
	}

	if `"`moptobj'"' != "" {
		local clear noclear
	}
	
	if !`:length local clear' {
		Clear
	}
	else {
		capture confirm var $ML_sample
		if c(rc) {
			quietly gen byte $ML_sample = e(sample)
		}
	}

	if `:length local output' == 0 {
		Display, level(`level') `options'
	}
end

program Display
	if !inlist("`e(opt)'", "ml", "moptimize") {
		error 301
	}
	if "`e(svyml)'" != "" | "`e(prefix)'" == "svy" {
		_prefix_display `0'
		exit
	}
	syntax [,			///
		Level(cilevel) 		///
		PLus			///
		noHeader		///
		First			///
		SHOWEQns		///
		NEQ(integer -1)		///
		noFOOTnote		///
		NOSKIP			///
		TItle(passthru)		/// NOT documented
		NOTEST			///
		*			///
	]

	if "`plus'" != "" {
		local footnote nofootnote
	}

	if `neq' >= 0 {
		local neqopt neq(`neq')
	}
	// check syntax elements in `options'
	_get_diopts diopts options, `options'
	_get_eformopts , eformopts(`options') soptions allowed(__all__)
	local eform `s(eform)'
	// `diparm' should only contain -diparm()- options
	local diparm `s(options)'
	_get_diparmopts , diparmopts(`diparm') level(`level')

	if "`header'"=="" {
		_coef_table_header, `title'
		di
	}

	// display the table of results
	_coef_table, `first' level(`level') `neqopt' `plus' ///
		`noskip' `showeqns' `diopts' `options' `notest'

	if "`footnote'" == "" {
		ml_footnote
	}
end

program Model
	local version = string(_caller())
	local vv : di "version `version':"
	version 12
	
	syntax anything(id="model" name=spec)		///
		[if] [in] [fw aw pw iw]			///
		[,					///
			BRACKET				///
			COLlinear			///
			MISSing				///
			CONTinue lf0(string)		/// LR test opts
			INIT(string)			///
			CONSTraints(string)		///
			noCNSNOTEs			///
			VCE(passthru)			///
			NEGH				///
			NOPREserve			///
			TECHnique(string)		/// moptimize_init_*()
			ITERID(string)			///
			CRITtype(string)		///
			OBS(numlist max=1 >0)		///
			TItle(string)			///
			WALDtest(integer -1)		///
			SVY SUBpop(string) SRSsubpop	/// svy options
			noSVYadjust			///
			SCore(passthru)			///
			noOUTput			/// ignored
			noSCVARS			/// ignored
			GROUP(varname)			///
			ITERPROLOG(string)		///
			DERIVPROLOG(string)		///
			DERIVH(string)			///
			DERIVSCALE(string)		///
			GNWMATrix(string)		///
			KAUXiliary(numlist int >=0)	///
			MAXimize MINimize		/// maxmin options
			USERinfo(namelist)		///
			PUPDATED			/// NOT DOCUMENTED
			Robust CLuster(passthru)	///
			moptobj(string)			/// NOT DOCUMENTED
			USEVIEWS			///
			*				///
		]

	if `"`moptobj'"' == "" {
		Clear
	}

	local maxmin `minimize' `maximize'
	opts_exclusive "`maxmin'"
	if `:length local maxmin' {
		local interactive 0
	}
	else	local interactive 1

	_get_diparmopts, diparmopts(`options') soptions syntaxonly
	forval k = 1/`s(k)' {
		local diparm`k' `"`s(diparm`k')'"'
	}
	local ndiparm `s(k)'
	local options `"`s(options)'"'

	if `interactive' & `:length local options' {
		local 0 , `options'
		syntax [, NOTANOPTION]
	}

	if `:length local nopreserve' | `:length local score' {
		global ML_preserve no
	}
	else	global ML_preserve yes

	gettoken evaltype	spec : spec
	confirm name `evaltype'
	gettoken evaluator	spec : spec

	global ML_evaltype : copy local evaltype

	if `:length local srssubpop' {
		local 0 , srssubpop
		syntax [, NONOPTION]
		exit 198	// [sic]
	}
	if `:length local subpop' {
		local svy svy
	}

	if `:length local svy' {
		opts_exclusive "`vce' `svy'" vce
		if `:length local weight' {
			di as err "svy option not allowed with weights"
			exit 198
		}
		global ML_noadj : copy local svyadjust
	}
	global ML_svy : copy local svy

	if _caller() >= 15 & c(userversion) >= 15 {
		local fparm ", freeparm"
	}

	// change '/eqname' to '(eqname:)'
	local eqspec : copy local spec
	local ieq 0
	while `:length local eqspec' {
		local ++ieq
		gettoken eq eqspec : eqspec, bind
		if bsubstr(trim("`eq'"),1,1) == "/" {
			local eq = bsubstr(trim("`eq'"),2,.)
			local spec : subinstr local spec	///
				"/`eq'" `"("`eq'":`fparm')"',	///
				word
		}
		else {
			gettoken p1 p2 : eq, parse("()")
			local p2 = trim(`"`p2'"')
			if bsubstr("`p2'",1,1) == "," {
				gettoken comma p2 : p2, parse(",")
				local p2 = trim(`"`p2'"')
			}
			if `"`p1'`p2'"' == "()" {
				local spec :				///
					subinstr local spec		///
						"`eq'"			///
						"(eq`ieq':)", word
			}
		}
	}

	if `interactive' {
		SetGlobalVar ML_sample : _MLtua
	}
	else {
		global ML_sample : tempvar
		if `"`moptobj'"' != "" {
			global ML_sample `moptobj'$ML_sample
		}
	}

	if `"`moptobj'"' != "" {
		cap drop $ML_sample
	}
	`vv' ///
	mark $ML_sample `if' `in' [`weight'`exp'], `zeroweight'

	tempname eqlist
	.`eqlist' = ._eqlist.new,			///
		eqopts(NOCONStant FREEParm)		///
		eqargopts(OFFset EXPosure)		///
		noneedvarlist				///
		numdepvars(0)				///
		needequal
	.`eqlist'.parse `spec'

	if "`subpop'" != "" & "`missing'" == "" {
		if `interactive' {
			SetGlobalVar ML_samp : _MLtu
		}
		else {
			global ML_samp : tempvar
			if `"`moptobj'"' != "" {
				global ML_samp `moptobj'$ML_samp
			}
		}
		tempvar markuse
		_svy_setup $ML_sample $ML_samp, svy subpop(`subpop')
		quietly gen byte `markuse' = $ML_samp
	}
	else	global ML_samp $ML_sample
	if "`collinear'" == "" {
		.`eqlist'.rmcoll $ML_samp, replace `missing'
	}
	else if "`missing'" == "" {
		.`eqlist'.markout $ML_samp, replace
	}
	if "$ML_samp" != "$ML_sample" {
		`vv' ///
		quietly replace $ML_sample = 0 if `markuse' & !$ML_samp
		drop `markuse'
	}

	local eq_n = `.`eqlist'.eq count'
	global ML_n : copy local eq_n
	global ML_dim = `.`eqlist'.dim'
	forval i = 1/`eq_n' {
		local depvars		`.`eqlist'.eq depvars `i''
		local eq		`.`eqlist'.eq name `i''
		if !`:length local eq' {
			local eq eq`i'
		}
		if `:list eq in eqnames' {
			di as err "equation '`eq'' multiply defined"
			exit 110
		}
		local eqnames `eqnames' `eq'
		fvexpand `.`eqlist'.eq indepvars `i'' if $ML_samp
		if "`r(tsops)'" == "true" {
			global ML_preserve no
		}
		local eq_rhs`i'		`"`r(varlist)'"'
		local eq_nocons`i'	`.`eqlist'.eq nocons `i''
		local eq_offset`i'	`.`eqlist'.eq offset `i''
		local eq_exposure`i'	`.`eqlist'.eq exposure `i''
		local eq_freeparm`i'	`.`eqlist'.eq freeparm `i''
		local lhs `lhs' `depvars'
		local eq_names `eq_names' `eq'
		local nxvars :list sizeof eq_rhs`i'
		local TMP : copy local eq_rhs`i'
		forval j = 1/`nxvars' {
			gettoken xvar TMP : TMP
			local colna `"`colna' `eq':`xvar'"'
		}
		if `eq_freeparm`i'' {
			if `nxvars' {
				di as err ///
"{it:xvars} not allowed with option {bf:freeparm}"
				exit 198
			}
			if strpos(`"`eq'"', ":") {
				local colna `"`colna' /`eq'"'
			}
			else {
				local colna `"`colna' /:`eq'"'
			}
		}
		else if !`eq_nocons`i'' {
			local colna `"`colna' `eq':_cons"'
		}
		if "`moptobj'" != "" {
			if "`eq_offset`i''" != "" {
				if usubstr("`eq_offset`i''",1,2)=="__" {
					capture clonevar `moptobj'`eq_offset`i'' = `eq_offset`i''
					local dropmetoo `dropmetoo' `moptobj'`eq_offset`i''
				}
			}
		}
	}
	
	// if needed, use permanent ML_y* variables instead of temporary
	if "`moptobj'" != "" {
		foreach y of local lhs {
			if usubstr("`y'",1,2)=="__" {
				capture clonevar `moptobj'`y' = `y'
				local tmp `tmp' `moptobj'`y'
				local dropmetoo `dropmetoo' `moptobj'`y'
			}
			else {
				local tmp `tmp' `y'
			}
		}
		local lhs `tmp'
	}

	if `waldtest' > 0 & `:length local lf0' {
		opts_exclusive "waldtest() lf0()"
	}

	// continue option
	if `:length local continue' {
		if !`:length local init' {
			tempname init
			local ub0 `init'
		}
		else	tempname ub0
		mat `ub0' = e(b)

		tempname v0 iv0
		mat `v0' = e(V)
		mat `iv0' = syminv(`v0')
		global ML_rank0 = colsof(`v0') - diag0cnt(`iv0')
		if !`:length local lf0' & !missing(e(ll)) {
			local lf0 `=colsof(`ub0')' `e(ll)'
		}
		local ub0
	}

	if `:length local init' {
		// parsing/setting initial values
		tempname b0
		local dim : list sizeof colna
		matrix `b0' = J(1,`dim',0)
		matrix colna `b0' = `colna'
		`vv' ///
		_mkvec `b0', from(`init') update first error("initial vector")
	}

	tempname bomit
	matrix `bomit' = J(1,`:list sizeof colna',0)
	matrix colna `bomit' = `colna'
	_ms_omit_info `bomit'
	if r(k_omit) | `:length local constraints' {
		nobreak {
			capture noisily break {
				_b_post0 `colna'
				local clist : subinstr local constraints ///
					"," " ", all
				`vv' ///
				makecns `clist', `cnsnotes'
				local constraints `"`r(clist)'"'
				local k_autoCns = e(k_autoCns)
				tempname C
				capture matrix `C' = e(Cns)
				local rcc = c(rc)
			}
			local rc = c(rc)
			ereturn clear
		}
		if (`rc') exit `rc'
		if (`rcc') {
			local C
			local k_autoCns
		}
	}

	if `:length local constraints' {
		// LR test not allowed with constraints
		local lf0
	}

	local vce `vce' `robust' `cluster'
	if `:length local vce' {
		_vce_parse,				///
			argoptlist(CLuster)		///
			optlist(OIM OPG Robust)		///
			old				///
			: `wt', `vce'
		local vce `r(vce)'
	}
	else if "`weight'" == "pweight" {
		local vce robust
	}
	if `:length local svy' {
		local vce svy
	}
	if `"`vce'"' == "cluster" {
		local cluster `r(cluster)'
		markout $ML_sample `cluster', strok
	}
	if `:length local group' {
		markout $ML_sample `group', strok
		global ML_group : copy local group
		if bsubstr("`:type `group''",1,3) == "str" {
			if `interactive' {
				SetGlobalVar ML_grp : _MLgr
			}
			else {
				global ML_grp : tempvar
				if `"`moptobj'"' != "" {
					global ML_grp `moptobj'$ML_grp
				}
			}
			quietly egen $ML_grp = group(`group')
			if ! `:length local cluster' {
				local cluster : copy global ML_grp
			}
		}
		else {
			if ! `:length local cluster' {
				local cluster : copy global ML_group
			}
		}
	}
	if "$ML_samp" != "$ML_sample" {
		quietly replace $ML_samp = 0 if $ML_samp & $ML_sample == 0
	}
	if `:length local vce' == 0 {
		if `"`technique'"' == "bhhh" {
			local vce opg
		}
		else	local vce oim
	}

	if inlist("`vce'", "robust", "cluster")		///
			& bsubstr("`evaltype'",1,1) == "d" {
		local optname = cond("`svy'"=="","vce(`vce')","svy")
		di as err ///
		"option `optname' is not allowed with evaltype `evaltype'"
		exit 198
	}
	if `:length local crittype' == 0 {
		if inlist("`vce'", "cluster", "robust", "svy") {
			local crittype "log pseudolikelihood"
		}
		else	local crittype "log likelihood"
	}
	global ML_waldtest `waldtest'

	if `:length local svy' | `:length local weight' {
		if `interactive' {
			SetGlobalVar ML_w : _MLw
		}
		else {
			global ML_w : tempvar
			if `"`moptobj'"' != "" {
				global ML_w `moptobj'$ML_w
			}
		}
	}
	if `:length local weight' {
		if `"`moptobj'"' != "" {
			cap drop $ML_w
		}
		quietly gen double $ML_w `exp' if $ML_samp
		local wtype	`"`weight'"'
		local wexp	`"`exp'"'
		global ML_wtyp	: copy local wtype
		global ML_wexp	: copy local wexp
		if "`wtype'" == "iweight" | "`svy'" != "" {
			local zeroweight zeroweight
		}
	}

	if inlist("`vce'", "svy", "cluster") {
		if `interactive' {
			SetGlobalVar ML_subv : _MLsu
		}
		else {
			global ML_subv : tempvar
			if `"`moptobj'"' != "" {
				global ML_subv `moptobj'$ML_subv
			}
		}
	}

	// check estimation sample
	quietly count if $ML_sample
	if r(N) == 0 {
		error 2000
	}
	if `"`weight'"' != "" {
		quietly count if $ML_sample & $ML_w != 0
		if r(N) == 0 {
			di in gr "all observation have zero weights"
			exit 2000
		}
	}

	// we should check -lf0()/continue- last to allow other options a
	// chance to turn them off
	if `:length local lf0' {
		if `:list sizeof lf0' != 2 {
			di as err "lf0(`lf0') invalid"
			exit 198
		}
		global ML_k0	: word 1 of `lf0'
		global ML_ll_0	: word 2 of `lf0'
		confirm integer number $ML_k0
		confirm number $ML_ll_0
		if $ML_k0 < 0 {
			di as err "lf0(`lf0') invalid"
			exit 198
		}
	}

	if "`obs'" == "" {
		if "`wtype'" != "fweight" {
			quietly count if $ML_sample
			local obs = r(N)
		}
		else {
			sum $ML_w if $ML_sample, mean
			local obs = r(sum)
		}
	}
	if `:length local iterid' {
		local iterid = trim(bsubstr(`"`iterid'"',1,32))
	}
	if `:length local crittype' {
		local crittype = trim(bsubstr(`"`crittype'"',1,32))
	}

	if `:length local derivscale' {
		confirm matrix `derivscale'
	}
	if `:length local derivh' {
		confirm matrix `derivh'
	}

	if `:length local gnwmatrix' {
		confirm matrix `gnwmatrix'
	}

	`vv' mata: Mopt_model()

	global ML_stat model

	if !`interactive' {
		`vv' MaxMin `maxmin', nooutput `score' `options' ///
			moptobj(`moptobj')
	}
end

program Query
	syntax [, NOOPTIONS]
	if "$ML_stat"!="model" { 
		if "`e(opt)'"=="moptimize" { 
			di as txt ///
"ml model already fit; type {cmd:ml display} to display results"
			exit
		}
		di as txt "no ml model defined"
		exit
	}
	mata: Mopt_query()
end

program Report
	syntax [, NOOPTIONS]
	mata: Mopt_report()
end

program Search
	syntax [anything(id="bounds" name=bounds)] [,	///
		Repeat(numlist max=1 int >=0)	///
		noRESCale			///
		RESTart				/// NOT DOCUMENTED
		MAXimize MINimize		///
		NOPREserve			///
		NOLOg LOg			/// tracelog:	none
		DOTs				///		dots
		SHOWTOLerance			///		tolerance
		SHOWNRtolerance			///		tolerance
		SHOWSTEP			///		step
		TRace				///		params
		COEFDIffs			///		paramdiffs
	]

	_parse_iterlog, `nolog' `log'
	local log "`s(nolog)'"
	
	local maxmin `minimize' `maximize'
	opts_exclusive "`maxmin'"
	if `:length local shownrtolerance' {
		local showtolerance showtolerance
	}

	// parse bounds:
	// 	        #1 #2		- implies first equation
	// 	/eqname #1 #2
	// 	eqname: #1 #2
	while `:length local bounds' {
		gettoken tok bounds : bounds, parse("/ ")
		if `"`tok'"' != "/" {
			local len : length local tok
			if bsubstr("`tok'",`len',1) == ":" {
				local tok = bsubstr("`tok'",1,`len'-1)
			}
			capture confirm number `tok'
			if ! c(rc) {
				gettoken v2 bounds : bounds
				confirm number `v2'
				local lb_1 `tok'
				local ub_1 `v2'
			}
			else {
				gettoken v1 bounds : bounds
				gettoken v2 bounds : bounds
				confirm number `v1'
				confirm number `v2'
				local lb_`tok' `v1'
				local ub_`tok' `v2'
			}
		}
	}

	if !`:length local nopreserve' & "$ML_preserve" != "no" {
		preserve
		local N = c(N)
		quietly keep if $ML_samp
		if (`N' != c(N)) {
			mata: Mopt_init_regetviews()
		}
	}

	mata: Mopt_search()
end

program Plot
	version 12
	syntax anything(id="parameter") [, SAVing(passthru) NAME(passthru)]

	gettoken parm values : anything

	// parse for [eqname:]name or /eqname, allowing FV & TS operators
	tokenize "`parm'", parse(" :/")
	if "`2'" == ":" {
		local eqnam `"`1'"'
		local colnam `"`3'"'
	}
	else if "`1'" == "/" {
		if _caller() < 15 | c(userversion) < 15 {
			local eqnam `"`2'"'
			local colnam `"_cons"'
		}
		else {
			local eqnam `"/"'
			local colnam `"`2'"'
		}
	}
	else {
		local colnam `"`1'"'
	}
	if `"`colnam'"' != "_cons" {
		_ms_unab colnam: `colnam'
	}

	// parse for [# [# [#]]]
	tokenize `values'
	args x0 x1 n
	if `:length local x0' {
		confirm number `x0'
	}
	if `:length local x1' {
		confirm number `x1'
	}
	if `:length local n' {
		confirm integer number `n'
		if `n' < 1 {
			di as err "n=`n' must be positive"
			exit 198
		}
	}
	else {
		local n 20
	}
	if `:list sizeof values' > 3 {
		error 123
	}

	local N = `n' + 1
	if `N' > c(N) {
		preserve
		quietly set obs `N'
		quietly replace $ML_samp = 0 if missing($ML_samp)
	}

	tempvar x y
	quietly gen double `x' = .
	quietly gen double `y' = .

	capture noisily mata: Mopt_plot_gen()
	if c(rc) {
		exit c(rc)
	}

	if `:length local xval' {
		local xline "xline(`xval')"
		local yline "yline(`yval')"
	}

	label var `y'  `"`ytitle'"'
	label var `x'  `"`colnam'"'
	nobreak capture noisily		///
	MakePlot `y' `x',		///
		n(`n')			///
		ytitle(`ytitle')	///
		`yline'			///
		`xline'			///
		`name'			///
		`saving'

	if (c(rc)) exit c(rc)
end

program Check
	syntax [, MAXFEAS(integer 1000)]

	mata: Mopt_check()
end

// subroutines --------------------------------------------------------------

program ChkEval
	args c_eval
	if "`e(ml_score)'" != "" {
		local eval `e(ml_score)'
	}
	else	local eval `e(user)'
	if "`eval'" == "" {
		di as err ///
"{p 0 0 2}ml score requires that the name of the likelihood evaluator "	///
"is in e(ml_score) or e(user){p_end}"
		exit 301
	}
	c_local `c_eval' `eval'
end

program ChkMacros
	if "$ML_stat" != "model" { 
		di as err "you must issue -ml model- first"
		exit 198
	}
	capture confirm var $ML_samp $ML_w $ML_subv
	if c(rc) { 
		di as err ///
"Since issuing the -ml model- statement, you have done something to drop" _n ///
"temporary variables ml added to your data.  You must start again."
		Clear
		exit 111
	}
end

program ChkMethod
	args c_method COLON cmd force
	if "`e(opt)'" != "moptimize" {
		di as err ///
"`cmd' not supported by ml score; see help {help ml score##|_new:ml score}"
		exit 301
	}
	local method `e(ml_method)'
	if "`method'" == "" {
		di as err ///
"ml score requires that the ml method is in e(ml_method)"
		exit 301
	}
						/* NB e1, e2, v* deprecated */
	local supported lf lf0 lf1 lf2 gf0 gf1 gf2 e1 e2 v0 v1 v2
	if !`:list method in supported' {
		di as err "scores cannot be produced with method `method'"
		exit 301
	}
	c_local method `method'
end

program CountList
	args user c0 c1 c2 c_
	mac shift
	if "`c0'"=="" & "`c1'"=="" & "`c2'"=="" & "`c_'"=="" {
		di as err "you did not -ml count on- before estimation"
		di as err "no counts recorded"
		exit 198
	}
	if `c0'==0 & `c1'==0 & `c2'==0 & `c_'==0 { 
		di as txt "(all counts are zero)"
		exit
	}
	if `c0'!=0 { 
		di as txt `"`user' 0"' as res %9.0g `c0'
	}
	if `c1'!=0 { 
		di as txt `"`user' 1"' as res %9.0g `c1'
	}
	if `c2'!=0 { 
		di as txt `"`user' 2"' as res %9.0g `c2'
	}
	if `c_'!=0 { 
		di as txt `"`user'  "' as res %9.0g `c_'
	}
end

program MakePlot, rclass
	syntax varlist(min=2 max=2) , n(int) ytitle(string) [*]
	gettoken y x : varlist

	sum `y', mean
	if r(N) == 0 {
		di as txt "(all `ytitle' values are missing)"
		exit
	}
	tempname max
	scalar `max' = r(max)

	local N = `n' + 1
	if (r(N) == `N') {
		graph twoway connected `y' `x',	ytitle(`ytitle') `options'
	}
	else {
		tempvar good bad
		quietly gen  `good' = `y'	if !missing(`y')
		quietly gen   `bad' = r(min)	if  missing(`y')
		quietly replace `y' = r(min)	if  missing(`y')
		label var `good' "`ytitle' value"
		label var `bad'  "`ytitle' could not be evaluated"
		graph twoway connected			///
			`y' `good' `bad' `x',		///
			msymbol(none			///
				circle			///
				plus			///
			)				///
			clpattern(. dot dot)		///
			`options'

		// in case `min'==`max'
		quietly replace `y' = . if missing(`good')
	}

	sum `x' if `y'==`max', mean
	return scalar b   = r(min)
	return scalar lnf = `max'
end

program SetGlobalVar
	args mac COLON stub
	local i 1
	capture confirm new var `stub'`i'
	while c(rc) {
		local ++i
		capture confirm new var `stub'`i'
	}
	global `mac' `stub'`i'
end

program SetupScore, sclass
	args method score neq dim

	local umethod : copy local method
	if strmatch("`method'", "linearform*") {
		local method = "lf" + bsubstr("`method'",11,.)
	}
	if strmatch("`method'", "generalform*") {
		local method = "gf" + bsubstr("`method'",12,.)
	}
	if inlist("`method'", "lf", "lf0", "lf1", "lf2", "e1", "e2") {
		loca nscore `neq'
	}
	else if inlist("`method'", "v0", "v1", "v2", "gf0", "gf1", "gf2") {
		loca nscore `dim'
	}
	else {
		di as err "option score() not allowed with method '`umethod''"
		exit 198
	}
	local len : length local score
	if bsubstr("`score'",`len',1) == "*" {
		local stub = bsubstr("`score'", 1, `len' - 1)
		forval i = 1/`nscore' {
			local sclist `sclist' `stub'`i'
		}
		local score : copy local sclist
	}
	else {
		local nuscore : list sizeof score
		if `nuscore' != `nscore' {
			di as err ///
"score() requires you specify `nscore' new variable names in this case"
			exit 198
		}
		local sclist : copy local score
	}
	forval i = 1/`nscore' {
		gettoken sci score : score
		quietly gen double `sci' = . in 1
	}
	sreturn local scores `sclist'
end

exit
