*! version 1.4.1  20jan2020
program bayes, eclass
	version 15.0
	local vv : di "version " string(_caller()) ", missing :"

	capture _on_colon_parse `0'
	if _rc & replay() {

		if "`e(prefix)'" != "bayes" {
			error 301
		}

		if ("`e(cmdname)'" != "binreg") {
			syntax [, noHR * ]
			local nohr `hr'
			local 0, `options'
		}

		syntax [, EForm1(passthru) EForm IRr OR RRr RD HR TRatio ///
			SAVing(string asis) INITSUMMary NOHEADER 	 ///
			COEFficients NOMODELSUMMary NOMESUMMary melabel * ]
		if `"`eform'`eform1'"' == "" {
			// logistic displays OR by default unless coef is specified
			if ("`e(cmdname)'" == "logistic") {
				local or
				if (`"`coefficients'"' == "") {
					local or or
				}
			}
			if "`e(cmdname)'" == "binreg" {
				if `"`rrr'"' == "rrr" local rrr rr
			}
		}
		local eformopts `eform1' `eform' `irr' `or' `rrr' `rd' `tratio'
		if `"`coefficients'"' != "" & `"`eformopts'"' != "" {
di as err "only one of {bf:`coefficients'} or {bf:`eformopts'} is allowed"
			exit 198
		}
		_bayes_cmd_eform_allowed `e(cmdname)'
		local eformallowed `s(allowed)'
		_get_eformopts , eformopts(`eformopts' `hr') ///
			allowed(`eformallowed')

		local saveandexit
		if `"`saving'"' != "" & ///
		`"`eformopts'`initsummary'`melabel'`options'"' == "" {
			local saveandexit saveandexit
		}

		if "`e(cmdname)'" == "binreg" {
			local eformopts `eformopts' `hr'
			if `"`rrr'"' == "rrr" local rrr rr
			local eformchk `irr' `or' `rrr' `rd' `tratio' `hr'
			if `"`eformchk'"' != "" & `"`e(default_eform)'"' != "" & ///
				`"`eformchk'"' != `"`e(default_eform)'"' {
				di as err "option {bf:`eformchk'} not allowed"
				exit 198
			}
		}
		if "`e(cmdname)'" == "streg" {
			if `"`e(default_eform)'"' == "hr" & "`tratio'" != "" {
				di as err "option {bf:`tratio'} not allowed with {bf:bayes}"
				exit 198
			}
		}
		if `"`eform1'"' == "" {
			if `"`e(default_eform)'"' !=  "hr" |  "`nohr'" == "" {
				local eformopts `eformopts' `e(default_eform)'
				local eformopts: list uniq eformopts
			}
		}
		if `"`coefficients'"' != "" & `"`eformopts'"' != "" {
			local eformopts
		}

		_bayes_prior_footnotes
		local footnotes `s(footnotes)'

		_bayesmh_check_opts , `options'

		if "`noheader'" != "" {
			local nomesummary nomesummary
			local nomodelsummary nomodelsummary
		}

		if "`melabel'" != "" {
			local nomesummary nomesummary
			local nomodelsummary nomodelsummary
		}

		// create a _c_mcmc_model object
		mata: getfree_mata_object_name("mcmcobject", "g_mcmc_model")
		mata: `mcmcobject' = _c_mcmc_model()

		// make sure mcmcobject goes as option
		local 1 `"`0'"'
		gettoken next 1 : 1, parse(",") bind
		if `"`0'"' != "," & `"`1'"' == "" {
		   local 0 `0',
		}

		if "`nomesummary'" == "" & `"`e(remodel)'"' != "" & ///
			"`saveandexit'" == "" {
			// show RE model summary
			mata: printf(`"`e(remodel)'\n"')
		}

		`vv' capture noisily _mcmc_report , mcmcobject(`mcmcobject') ///
			eformopts(`eformopts') saving(`saving')        	     ///
			footnotes(`"`footnotes'"') `noheader'                ///
			`nomodelsummary' `melabel' `saveandexit'	     ///
			`initsummary' `options' 
		local rc = _rc

		// clean up
		_bayesmh_clear `mcmcobject'
		exit `rc'
	}

	global BAYES_DP_FORMAT `=c(dp)'
	// parsing in bayes routines assume period-dp format
	set dp period
	
	set prefix bayes

	preserve

	// create a _c_mcmc_model object
	mata: getfree_mata_object_name("mcmcobject", "_model")
	mata: `mcmcobject' = _c_mcmc_model()

	// setup Bayesian model
	local cmdline `"bayes`0'"'
	`vv' capture noisily _bayes `mcmcobject' `0'
	local rc = _rc
	if !`rc' {
		ereturn local cmdline = `"`cmdline'"'
	}

	// clean up
	_bayesmh_clear `mcmcobject'

	restore
	
	// restore user's dp format
	set dp $BAYES_DP_FORMAT

	exit `rc'
end

program _bayes, eclass

	capture noisily _bayes_prefix run `0'
	if _rc {
		exit _rc
	}

	local mcmcobject `s(mcmcobject)'
	local blocksize  `s(blocksize)'
	local normalprior `s(normalprior)'
	local igammashape `s(igammashape)'
	local igammascale `s(igammascale)'
	local paramlist  `s(paramlist)'
	local defparlist `"`s(defparlist)'"'
	local paramlogfm `s(paramlogfm)'
	local noshowex   `s(paramnoshow)'
	local paramdispl `s(paramdispl)'
	local optinitial `s(optinitial)'
	local options    `s(options)'
	local eformopts  `s(eformopts)'
	local cmdname    `s(cmdname)'
	local command    `s(command)'
	local headerstr1 `"`s(headerstr1)'"'
	local headerstr2 `"`s(headerstr2)'"'
	local headerstr3 `"`s(headerstr3)'"'
	local subjects   `"`s(subjects)'"'
	local censor     `"`s(censor)'"'
	local remodel    `"`s(remodel)'"'
	local default_eform `"`s(default_eform)'"'
	local offset1  `"`s(eret_offset1)'"'
	local offset2  `"`s(eret_offset2)'"'
	local offset   `"`s(eret_offset)'"'
	local exposure `"`s(eret_exposure)'"'
	local display_st_show `"`s(display_st_show)'"'
	
	local cmd2        `s(cmd2)'
	local k_eq        `s(k_eq)'
	local k_eform     `s(k_eform)'
	local noconstant  `s(noconstant)'
	if "`noconstant'" == "" local noconstant 0
	local consonly    `s(consonly)'
	if "`consonly'" == "" local consonly 0

	local 0, `options'
	capture syntax [anything], [ ///
		BURNin(real 2500)    ///
		INITial(string)      ///
	 	EXCLude(string)      ///
		ADAPTation(string)   ///
		INITRANDom           ///
		NOEXPRession         ///
		NOMODELSUMMary       ///
		NOMESUMMary          ///
		melabel              ///
		INITSUMMary          ///
		BLOCKSUMMary         ///
		NOTABle NOHEADer     ///
		DRYRUN 		     ///
		NOSHOW(passthru) SHOW(passthru)	///
		SHOWREffects1(passthru)		///
		NCHAINs(string)	     ///
		 * ]

	local options `options' `noshow' `show' `showreffects1'

	_bayes_chains opt `"`nchains'"'
	local nchains  `r(nchains)'
	local options `"`options' `r(options)'"'
	if `nchains' > 1 {
		forvalues i = 2/`nchains' {
			local optinitial`i' `s(optinitial`i')'
		}
	}
	
	_bayes_initials parse `"`initial'"' `"`options'"' `"`gtouse'"' `nchains'
	local initial `"`r(initial)'"'
	local options `"`r(options)'"'

	if "`noheader'" != "" {
		local nomesummary nomesummary
		local nomodelsummary nomodelsummary
	}

	if "`melabel'" != "" {
		local nomesummary nomesummary
		local nomodelsummary nomodelsummary
	}

	cap _bayesmh_check_opts , `options'
	if "`s(extraoptions)'" != "" {
		di as err "option {bf:`s(extraoptions)'} not allowed " ///
			"with the {bf:bayes} prefix"
		exit 198
	}
	local extraoptions `options'

	// chance to change some default adaptation parameters
	if "`adaptation'" != "" {
		local 0, `adaptation'
		capture syntax [anything], [*]
		local adaptation `options'
	}
	local extraoptions `extraoptions' burnin(`burnin') adaptation(`adaptation')

	if `"`initial'"' != "" {
		_mcmc_fv_decode	`"`initial'"'
		local initial `"`s(outstr)'"'
	}

	if "`exclude'" != "" {
		_mcmc_fv_decode	`"`exclude'"'
		local exclude `s(outstr)'
	}

	// build the model
	mata: `mcmcobject'.build_factors(NULL, NULL, 0)

	// block processing
	mata: `mcmcobject'.build_blocks()
	mata: `mcmcobject'.block_verify(NULL)

	// first initialize the optional starting values
	// apply optinitial only if initrandom is not specified
	if `"`optinitial'"' != "" & `"`initrandom'"' == "" {
		mata: `mcmcobject'.setDefaultInitialUsed()
		_bayesmh_init_params `mcmcobject' `"`optinitial'"' 1
	}

	// expand shortcuts in `exclude' and `initial'
	local lablist $MCMC_eqlablist
	gettoken ylabel lablist : lablist
	local ylabind 1
	while `"`ylabel'"' != "" {
		local ltemp MCMC_betapar_`ylabind'
		while regexm(`"`exclude'"', `"{`ylabel':}"') {
			local exclude = regexr(`"`exclude'"', ///
				`"{`ylabel':}"', `"$`ltemp'"')
		}
		while regexm(`"`initial'"', `"{`ylabel':}"') {
			local initial = regexr(`"`initial'"', ///
				`"{`ylabel':}"', `"$`ltemp'"')
		}
		gettoken ylabel lablist : lablist
		local `++ylabind'
	}

	if `"`initrandom'"' != "" {
		mata: `mcmcobject'.init_random()
	}

	mata: `mcmcobject'.set_mcmc_chains(`nchains')
	mata: `mcmcobject'.init_parameters_chains(`nchains')

	if `nchains' > 1 &  `"`initrandom'"' == "" {
		forvalues i = 2/`nchains' {
			_bayesmh_init_params `mcmcobject' ///
				`"`optinitial`i''"' 1 `i'
		}
	}

	_bayes_initials push `mcmcobject' `"`initial'"' `nchains'

	if "`exclude'" != "" {
		_mcmc_fv_decode	`"`exclude'"'
		_mcmc_parse expand `s(outstr)'
		local exclude `s(eqline)'
		
		local toklist `exclude'
		gettoken next toklist : toklist, bindcurly
		while "`next'" != "" {
			_mcmc_parse word `next'
			if "`s(prefix)'" != "." {
				mata: `mcmcobject'.exclude_params(	///
					"`s(prefix)':`s(word)'")
			}
			else {
				mata: `mcmcobject'.exclude_params("`s(word)'")
			}
			gettoken next toklist : toklist, bindcurly
		}
	}

	if `"`noshow'`show'`showreffects1'"' != "" {
		_mcmc_show_params, mcmcobject(`mcmcobject')	///
			`noshow' `show' `showreffects1'
	}

	if "`paramlogfm''" != "" {
		mata: `mcmcobject'.set_logfm("`paramlist'", "`paramlogfm'")
	}

	if $MCMC_debug {
		mata: `mcmcobject'.factor_view(NULL)
		mata: `mcmcobject'.block_view (NULL)
	}

	if "`dryrun'" == "" & `"`cmdname'"' == "mixed" {
		local somecoefs 0
		local somevars 0
		local fullgibbs 1
		local mh 0
		mata: `mcmcobject'.gibbs_status("fullgibb", "mh", "allcoefs", /*
			*/ "somecoefs", "allvars", "somevars")
		if "`mh'" == "1" {
			local note "note: MH sampling is used for all parameters"
		}
		else if "`allcoefs'" == "0" & "`somecoefs'" == "0" {
			local note "note: Gibbs sampling is used for"
			if "`somevars'" == "1" & "`allvars'" == "0" {
				local note "`note' some"
			}
			local note "`note' variance components"
		}
		else if "`allvars'" == "0" & "`somevars'" == "0" {
			local note "note: Gibbs sampling is used for"
			if "`somecoefs'" == "1" & "`allcoefs'" == "0" {
				local note "`note' some"
			}
			local note "`note' regression coefficients"
		}
		else { 
			local note "note: Gibbs sampling is used for"
			if "`somecoefs'" == "1" & "`allcoefs'" == "0" {
				local note "`note' some"
			}
			local note "`note' regression coefficients and"
			if "`somevars'" == "1" & "`allvars'" == "0" {
				local note "`note' some"
			}
			local note "`note' variance components"
		}
		di as text `"{p 0 6 2}`note'{p_end}"'
	}

	if `"`e(mecmd)'"' == "1" {
		local haslvparams haslvparams
	}

	// simulation options
	_bayesmh_check_opts , `noexpression' `nomodelsummary' `nomesummary' ///
		`melabel' `initsummary' `blocksummary' `extraoptions' ///
		eformopts(`eformopts') `haslvparams'

	local reportopts `s(repoptions)'
	local simoptions `s(simoptions)'
	local adaptation `s(adaptation)'
	local simoptions `simoptions' `adaptation'

	ereturn local command = `"`command'"'
	ereturn local cmd     = `"`cmdname'"'
	ereturn local cmdname = `"`cmdname'"'
	ereturn local prefix  = "bayes"

	ereturn hidden local cmd2       = `"`cmd2'"'
	ereturn hidden local k_eq       = "`k_eq'"
	ereturn hidden local k_eform    = "`k_eform'"
	ereturn hidden local noconstant = "`noconstant'"
	ereturn hidden local consonly   = "`consonly'"
	
	ereturn hidden local defparlist = "`defparlist'"
	ereturn hidden local cmdparlist = "`paramlist'"

	local tempscalars 0
	if inlist("`cmdname'","intreg","tobit") {
		tempname N_unc N_lc N_rc 
		if "`e(N_unc)'" != "" {
			local tempscalars 1
			scalar `N_unc' = `e(N_unc)'
			scalar `N_lc' = `e(N_lc)'
			scalar `N_rc' = `e(N_rc)'
			if "`cmdname'"=="intreg" {
				tempname N_int
				scalar `N_int' = `e(N_int)'
			}
			else {
				local llopt `e(llopt)'
				local ulopt `e(ulopt)'
				local limit_l `e(limit_l)'
				local limit_u `e(limit_u)'
			}
		}
	}
	else if inlist("`cmdname'","heckman","heckprobit","heckoprobit","heckpoisson") {
		tempname N_sel N_nonsel
		if "`e(N_selected)'" != "" {
			local tempscalars 1
			scalar `N_sel' = e(N_selected)
			scalar `N_nonsel' = e(N_nonselected)
		}
	}

	local glm_scale
	if `"`cmdname'"' == "glm" {
		capture local glm_scale = e(phi)
	}

	local tempmats 0
	if "`e(ivars)'" != "" {
		local tempmats 1
		tempname me_cmd2 me_kr me_ivars me_n me_min me_avg me_max
		local `me_cmd2' = `"`e(cmd2)'"'
		scalar `me_kr'   = `e(k_r)'
		local `me_ivars' = `"`e(ivars)'"'
		mat `me_n'   = e(N_g)
		mat `me_min' = e(g_min)
		mat `me_avg' = e(g_avg)
		mat `me_max' = e(g_max)
	}
	
	local wtype = `"`e(wtype)'"'
	local wexp  = `"`e(wexp)'"'

	local mecmd 0
	if "`e(mecmd)'" == "1" {
		local mecmd 1
	}
	
	// nbreg and menbreg
	local edispersion `e(dispersion)'`e(dispers)'

	_bayes_prior_footnotes
	local footnotes `s(footnotes)'

	if $MCMC_debug {
		di " "
		di `"exclude: `exclude'"'
		di " "
		di `"show: `show'"'
		di " "
		di `"noshow: `noshow'"'
		di " "
		di `"initial: `initial'"'
	}

	// display survival-time variables
	`display_st_show'

	if "`dryrun'" != "" {
		if `"`remodel'"' != "" {
			// show RE model summary
			mata: printf(`"`remodel'\n"')
		}
		_mcmc_model, mcmcobject(`mcmcobject')	///
			`noexpression' `nomodelsummary'
		if "`initsummary'" != "" {
			mata: `mcmcobject'.initsummary_ereport()
		}
		if "`blocksummary'" != "" {	
			mata: `mcmcobject'.blocks_ereport()
			_mcmc_blocksummary
		}
		exit 0
	}

	_bayes_ts_replace_note

	// run simulation
	_mcmc_run, mcmcobject(`mcmcobject')	///
		`simoptions' noheader notable noreport

	if `tempscalars' {
		if inlist("`cmdname'","intreg","tobit") {
			eret scalar N_unc = `N_unc'
			eret scalar N_lc = `N_lc'
			eret scalar N_rc = `N_rc'
			if "`cmdname'"=="intreg" {
				eret scalar N_int = `N_int'
			}
			else {
				eret local llopt "`llopt'"
				eret local ulopt "`ulopt'"
				eret hidden local limit_l `limit_l'
				eret hidden local limit_u `limit_u'
			}
		}
		else if inlist("`cmdname'","heckman","heckprobit","heckoprobit","heckpoisson") {
			eret scalar N_selected = `N_sel'
			eret scalar N_nonselected = `N_nonsel'
		}
	}

	if `tempmats' {
		eret local cmd2 = `"``me_cmd2''"'
		eret hidden scalar k_r = `me_kr'
		eret hidden local  ivars = `"``me_ivars''"'
		eret hidden matrix N_g   = `me_n'
		eret hidden matrix g_min = `me_min'
		eret hidden matrix g_avg = `me_avg'
		eret hidden matrix g_max = `me_max'
	}

	ereturn local wtype = `"`wtype'"'
	ereturn local wexp  = `"`wexp'"'

	if "`mecmd'" == "1" {
		ereturn hidden scalar mecmd = 1
		// -_matrix_table, cmdextras- fails if gsem_vers is empty
		ereturn hidden scalar gsem_vers = 3
	}

	if "`edispersion'" != "" {
		ereturn local dispersion = "`edispersion'"
	}

	if "`nomesummary'" == "" & `"`remodel'"' != "" {
		// show RE model summary
		mata: printf(`"`remodel'\n"')
	}

	if `"`default_eform'"' !=  "" {
		ereturn hidden local default_eform = `"`default_eform'"'
	}

	if `"`noshowex'"' != "" {
		ereturn hidden local noshowex = `"`noshowex'"'
	}

	if `"`glm_scale'"' != "" {
		ereturn hidden local glm_scale = `glm_scale'
	}

	ereturn scalar blocksize  = `blocksize'
	ereturn scalar priorscale = `igammascale'
	ereturn scalar priorshape = `igammashape'
	ereturn scalar priorsigma = `normalprior'

	ereturn local command = `"`command'"'
	ereturn local cmd     = `"`cmdname'"'
	ereturn local cmdname = `"`cmdname'"'
	ereturn local prefix  = "bayes"

	ereturn hidden local cmd2       = `"`cmd2'"'
	ereturn hidden local k_eq       = "`k_eq'"
	ereturn hidden local k_eform    = "`k_eform'"
	ereturn hidden local noconstant = "`noconstant'"
	ereturn hidden local consonly   = "`consonly'"
	
	ereturn hidden local defparlist = "`defparlist'"
	ereturn hidden local cmdparlist = "`paramlist'"

	ereturn hidden local remodel    = "`remodel'"

	ereturn local offset1  = `"`offset1'"'
	ereturn local offset2  = `"`offset2'"'
	ereturn local offset   = `"`offset'"'
	ereturn local exposure  = `"`exposure'"'

	ereturn local exclude  = `"`exclude'"'

	// set user's dp format before rendering output table
	set dp $BAYES_DP_FORMAT

	_mcmc_report , mcmcobject(`mcmcobject')	///
		headerstr1(`"`headerstr1'"')	///
		headerstr2(`"`headerstr2'"')	///
		headerstr3(`"`headerstr3'"')	///
		subjects(`"`subjects'"')	///
		censor(`"`censor'"')		///
		footnotes(`"`footnotes'"')	///
		postdata(`"`e(filename)'"')	///
		`reportopts' `noheader' `notable'

	exit 0
end

program _bayes_prior_footnotes, sclass
	// footnotes after the estimation table
	local footnotes
	if `"`e(defparlist)'"' != "" {
		if `"`e(defparlist)'"' == `"`e(cmdparlist)'"' {
local footnotes "{p 0 6 2}Note: {help j_bayes_defaultpriors:Default priors} are used for model parameters.{p_end}"
		}
		else {
local footnotes "{p 0 6 2}Note: {help j_bayes_defaultpriors:Default priors} are used for some model parameters.{p_end}"
		}
	}
	sreturn local footnotes = `"`footnotes'"'
end
	
program _bayes_cmd_eform_allowed, sclass
	args model
	// footnotes after the estimation table
	local allowed
	if "`model'" == "logit" | "`model'" == "logistic" | ///
		"`model'" == "ologit" | "`model'" == "clogit" | /// 
		"`model'" == "melogit" | "`model'" == "meologit" {
		local allowed `allowed' or
	}
	if "`model'" == "binreg" {
		local allowed `allowed' or rd rr rrr hr
	}
	if "`model'" == "mlogit" {
		local allowed `allowed' rr rrr
	}
	if "`model'" == "poisson" | "`model'" == "nbreg" | ///
		"`model'" == "gnbreg" | "`model'" == "tpoisson" | ///
		"`model'" == "tnbreg" | "`model'" == "zip" | ///
		"`model'" == "zinb" | "`model'" == "mepoisson" | ///
		"`model'" == "menbreg" {
		local allowed `allowed' irr
	}
	if "`model'" == "fracreg" {
		local allowed `allowed' or
	}
	if "`model'" == "streg" | "`model'" == "mestreg" {
		local allowed `allowed' hr tratio
	}
	if "`model'" == "meglm" {
		local allowed `allowed' irr or
	}
	sreturn local allowed = `"`allowed'"'
end

program _bayes_ts_replace_note

	local tssub $MCMC_TSSUB_L
	local tswords $MCMC_TSSUB_L_words
	local tswords: list uniq tswords
	local cnt: list sizeof tswords
	local s
	if `cnt' > 1 local s s
	capture confirm integer number `tssub'
	if _rc == 0 {
		if `tssub' > 0 {
di `"{txt}note: operator {bf:L1.} is replaced with {bf:L.} in parameter name`s' {bf:`tswords'}"'
		}
	}
	local tssub $MCMC_TSSUB_F
	local tswords $MCMC_TSSUB_F_words
	local tswords: list uniq tswords
	local cnt: list sizeof tswords
	local s
	if `cnt' > 1 local s s
	capture confirm integer number `tssub'
	if _rc == 0 {
		if `tssub' > 0 {
di `"{txt}note: operator {bf:F1.} is replaced with {bf:F.} in parameter name`s' {bf:`tswords'}"'
		}
	}
	local tssub $MCMC_TSSUB_D
	local tswords $MCMC_TSSUB_D_words
	local tswords: list uniq tswords
	local cnt: list sizeof tswords
	local s
	if `cnt' > 1 local s s
	capture confirm integer number `tssub'
	if _rc == 0 {
		if `tssub' > 0 {
di `"{txt}note: operator {bf:D1.} is replaced with {bf:D.} in parameter name`s' {bf:`tswords'}"'
		}
	}
	local tssub $MCMC_TSSUB_S
	local tswords $MCMC_TSSUB_S_words
	local tswords: list uniq tswords
	local cnt: list sizeof tswords
	local s
	if `cnt' > 1 local s s
	capture confirm integer number `tssub'
	if _rc == 0 {
		if `tssub' > 0 {
di `"{txt}note: operator {bf:S1.} is replaced with {bf:S.} in parameter name`s' {bf:`tswords'}"'
		}
	}
end
	
exit

