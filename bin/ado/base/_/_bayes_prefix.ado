*! version 1.7.5  27feb2020
program _bayes_prefix, sclass
	version 15.0

	local version : di "version " string(_caller()) ":"

	// runmode is build or run
	gettoken runmode 0 : 0
	gettoken mcmcobject 0 : 0

	capture _on_colon_parse `0'
	if _rc | `"`s(after)'"' == "" {
		if !_rc {
			local 0 `"`s(before)'"'
		}
		if replay() {
			if "`e(prefix)'" != "bayes" {
				error 301
			}
			local runmode report
		}
	}

	qui mi query
	if "`r(style)'" != "" {
		di as err "{p}{bf:bayes} prefix is not allowed with {helpb mi set} data{p_end}"
		exit 198
	}

	local parseonly = "`runmode'" == "build"

	if `"`s(after)'"' == "" {
		di as err `"`''`'' found where `'':`'' expected"'
		exit 198
	}

	local subcmd `"`s(after)'"'
	// bayesmh options
	local 0 `"`s(before)'"'

	_check_command `subcmd'

	global BAYES_NORMALSIG 100
	global BAYES_GAMSHAPE  0.01
	global BAYES_GAMSCALE  0.01

	local mecommands meglm melogit meqrlogit meprobit mecloglog	///
		meologit meoprobit mepoisson meqrpoisson menbreg	///
		mixed meintreg metobit mestreg
		
	// command spec
	local lhs `"`s(before)'"'
	// command options
	local respec `"`s(respec)'"'
	local rhs `"`s(after)'"'
	if (`"`rhs'"'=="") {
		local rhs , 
	}
	local i 1
	while `"`s(eq_re`i')'"' != "" {
		local eq_re`i' = `"`s(eq_re`i')'"'
		local eq_re`i'_label = `"`s(eq_re`i'_label)'"'
		local eq_re`i'_cov = `"`s(eq_re`i'_cov)'"'
		local i = `i' + 1
	}
	local i 1
	while `"`eq_re`i'_label'"' != "" {
		tsunab eq_re`i'_label: `eq_re`i'_label'
		local i = `i' + 1
	}

	local command `lhs'
	gettoken subcmd lhs : lhs
	local cmdname `subcmd'

	syntax [, noHR * ]
	local nohr `hr'
	syntax [, CMDOK INITRANDom NOMLEINITial GIBBS MLEINITOPTS	///
		BURNin(passthru)					///
		NORMALPRior(real 100) 					///
		IGAMMAPRior(string)					///
		BLOCKSIZE(real 50) NOBLOCKing				///
		REffects(string)					///
		CLEVel(string) COEFficients				///
		EForm1(passthru) EForm IRr OR RRr RD HR TRatio		///
		NOIsily DRYRUN 						///
		EXCLude(string)      					///
		MLEINITFORCE						///
		melabel NOGRoup restubs(string) 			///
		DEBUG reblocksok /* undocumented */			///
		COVariance(string) 					///
		NCHAINs(string)						///
		RSEED(string) * ]
//-mleinitopts- and -mleinitforce- are undocumented

	local bayescov
	if (`"`covariance'"'!="") {
		capture confirm matrix `covariance'
		if _rc {
			di as err "{bf:`covariance'} must be a matrix"
			exit 198
		}
		local bayescov covariance(`covariance')
		local covariance
	}

	local 0 ,`options'
	syntax [, NORMALPRior1 *]
	if `"`normalprior1'"' != "" {
		di as err "option {bf:normalprior()} requires one argument"
		exit 198
	}
	local 0 ,`options'
	syntax [, NORMALPRior1(string) *]

	// filter out -iwishartprior()- options
	local bayesopt
	if `"`exclude'"' != "" {
		local bayesopt exclude(`exclude')
	}
	local default_eform
	local iwishartopts
	while `"`options'"' != "" {
		local 0 ,`options'
		syntax [, IWISHARTPRior(passthru) *]
		if "`iwishartprior'" != "" {
			local iwishartopts `iwishartopts' `iwishartprior'
		}
		else {
			local bayesopt `bayesopt' `options'
			local options
		}
	}
	local bayescoef `coefficients'

	// expand abbreviated commands
	local 0 ,`subcmd'
	syntax [, REGress TOBit LOGIt PROBit OLOGit OPROBit MLOGit CLOGit *]
	local subcmd `regress'`tobit'`logit'`probit'`ologit'`oprobit'`mlogit'/*
		*/`clogit'`options'

	local bayesopt `bayesopt' `dryrun' `initrandom' `gibbs' `melabel' ///
		`nogroup' `bayescov'

	// conflicting options: -RRr- in -mlogit- and -rr- in -binreg- 
	if "`cmdname'" == "binreg" & "`rrr'" != "" {
		local rrr rr
	}
	if `"`eform1'"' != "" & `"`eform'"' != "" {
		local eform
	}
	local beformopts `eform1' `eform' `irr' `or' `rrr' `rd' `hr' `tratio'

	if "`initrandom'" != "" & "`nomleinitial'" != "" {
		di as err "options {bf:`initrandom'} and {bf:`nomleinitial'} " ///
			"cannot be combined"
		exit 198
	}

	if `"`nchains'"' != "" {
		_bayes_chains opt `"`nchains'"'
		local nchains = `r(nchains)'
		local bayesopt `bayesopt' nchains(`nchains')
		gettoken nchains : nchains, parse("\ ,")
	}
	else {
		local nchains 0
	}

	if `normalprior' <= 0 {
		di as err "{bf:normalprior()} must be a positive number"
		exit 198
	}
	local igamshape $BAYES_GAMSHAPE
	local igamscale $BAYES_GAMSCALE
	if `"`igammaprior'"' != "" {
		// list commands for which -igammaprior()- is not applicable
		if "`subcmd'" != "regress" & "`subcmd'" != "tobit" & /*
		*/ "`subcmd'" != "truncreg" & !`:list subcmd in mecommands' {
			di as err `"option {bf:igammaprior(`igammaprior')} not allowed"'
			exit 198
		}
	
		tokenize "`igammaprior'", parse(", ")
local igamerr "{p}invalid option {bf:igammaprior({it:#1} {it:#2})}{p_end}{p 4 4 2}Shape parameter {it:#1} and scale parameter {it:#2} must be positive numbers or dots ({bf:.}) separated by space{p_end}"
		if `"`1'"' != "" & `"`1'"' != "." {
			capture confirm number `1'
			if _rc != 0 {
				di as err `"`igamerr'"'
				exit 198
			}
			else if `1' <= 0 {
				di as err `"`igamerr'"'
				exit 198
			}
			local igamshape = `1'
		}
		if `"`2'"' == "," {
			di as err `"`igamerr'"'
			exit 198
		}
		if `"`2'"' != "" & `"`2'"' != "." {
			capture confirm number `2'
			if _rc != 0 {
				di as err `"`igamerr'"'
				exit 198
			}
			else if `2' <= 0 {
				di as err `"`igamerr'"'
				exit 198
			}
			local igamscale  = `2'
		}
	}

	if `blocksize' < 1 {
		di as err "{bf:blocksize()} must be a positive integer"
		exit 198
	}
	if `blocksize' != floor(`blocksize') {
		di as err "{bf:blocksize()} must be a positive integer"
		exit 198
	}
	if "`noblocking'" != "" {
		local blocksize .
	}
	if `"`reffects'"' != "" {
		di as err `"option {bf:reffects(`reffects')} is not allowed"'
		exit 198
	}

	global MCMC_debug 0
	if "`debug'" != "" {
		global MCMC_debug 1
	}

	gettoken subcmd options : subcmd
	if ("`subcmd'" == "") {
		di as err "{bf:bayes} prefix requires a subcommand"
		exit 198
	}

	local bayesprop bayes
	local properlist : properties `subcmd'
	if !`:list bayesprop in properlist' {
		local options `subcmd'
		local subcmd
	}
	if ("`subcmd'" == "" & "`cmdok'" == "") {
		di as err `"{bf:bayes} prefix: command not supported"'
di as err "{p 4 4 2}{bf:`cmdname'} is not officially supported by the {bf:bayes} prefix;"
di as err "see {bf:help bayes estimation} for a list of Stata estimation "
di as err "commands supported by the {bf:bayes} prefix.{p_end}"
		exit 198
	}
	else if ("`subcmd'" == "") {
		local subcmd `options'
	}
	local model `subcmd'
	local model_f `model'

	local _bayes_error = ///
	`"an error occurred when {bf:bayes} executed {bf:`model'}"'

	if "`gibbs'" != "" & "`model'" != "regress" & "`model'" != "mvreg" {
		di as err "option {bf:`gibbs'} can only be used with " ///
			"commands {bf:regress} and {bf:mvreg}"
		exit 198
	}

	// save the y variables
	gettoken yvars : lhs, match(par) bind
	if `"`par'"' == "(" {
		gettoken yvars : yvars
	}
	if `"`yvars'"' != "" {
		capture tsunab yvars: `yvars'
	}

	if `:list model in mecommands' {
		// default burnin for RE models
		if "`burnin'" == "" & "`model'" != "mixed" {
			local burnin burnin(2500)
		}
	}
	else {
		// options only allowed with me-commands
		if `"`respec'"' != "" {
			di as err "multilevel specification {bf:`respec'} " ///
				  "not allowed with command {bf:`model'}"
			exit 198
		}
		_opt_err_me_bayes melabel `melabel'
		_opt_err_me_bayes nogroup `nogroup'
		_opt_err_me_bayes restubs() `restubs'
	}

	// pass burnin to bayesmh options
	local bayesopt `bayesopt' `burnin'

	// clears some globals
	_bayes_utils init

	local 0 `rhs'
	syntax [, noHR *]
	local nohr `nohr' `hr'

	syntax [, NOCOEf *]
	// COEFficients NOCOEf interfere
	local 0 ,`options'
	syntax [, moptobj(string)		///
		NOCONstant			///
		Hascons				///
	/// maximization options
		SEARCH				///
		DIFficult			///
		TECHnique(string)		///
		ITERate(string)			///
		noLOG trace GRADient HESSian	///
		showstep SHOWTOLerance		///
		FROM(string)			///
		TOLerance(string)		///
		LTOLerance(string)		///
		NRTOLerance(string)		///
		NONRTOLerance			///
		QTOLerance(string)		///
		VCE(string)			///
		FISHER(string)			///
		MLE TWOstep irls ml		///
	/// offset options
		OFFset(varname numeric ts)	///
		Exposure(varname numeric ts)	///
	/// display options
		COEFLegend			///
		NOHEader NOTABle		///
		CONSTraints(string) 		///
		EForm1(passthru) EForm 		///
		IRr OR RRr RD HR TRatio		///
		COEFficients			///
		NOShow				///
	/// common disallowed options
		Robust Level(string)		///
		noCNSReport			///
		SCAle(passthru)			///
	/// biprobit
		PARtial				///
		COVariance(string)		///
	/// hetregress
		lrmodel waldhet			///
	/// binreg
		VFactor(string)		 	///
		NOLRtest			///
	/// mprobit
		vuong zip			///
	/// heckman
		FIRst				///
		nofootnote			///
		NShazard(passthru)		///
		Mills(passthru)			///
	/// glm
		nodisplay			///
	/// me
		time				///
		NOGRoup				///
		DISPERsion(passthru)		///
		INTMethod(passthru)		///
		INTPoints(passthru)		///
		STARTValues(passthru)		///
		STARTGrid			///
		STARTGrid1(passthru)		///
		NOESTimate			///
		dnumerical			///
	/// intreg
		noTRANSform			/// NOT DOCUMENTED 
		* ]

	_get_diopts diopts options, `options'
	_get_diopts bayesdiopts bayesopt, `bayesopt'
	local bayesdiopts : list bayesdiopts - diopts
	local bayesdiopts : list bayesdiopts | diopts
	local bayesopt `bayesopt' `bayesdiopts'
	local options `options' `bayesdiopts'
	local options `options' `noconstant'
	local reoptions `options'
	local extrameopts
	local optinitial
	if `nchains' > 1 {
		forvalues i = 2/`nchains' {
			local optinitial`i'
		}
	}

	// conflicting options: -RRr- in -mlogit- and -rr- in -binreg- 
	if "`cmdname'" == "binreg" & "`rrr'" != "" {
		local rrr rr
	}

	if "`bayescoef'" != "" {
		local coefficients coefficients
	}
	if ("`model'"=="logistic") {
		// logistic reports odds ratios
		if "`coefficients'" != "" {
			// logistic has an option coef not coefficients
			local coefficients coef
		}
		else {
			local or or
		}
	}

	local eformopts
	if `"`eform1'`eform'`irr'`or'`rrr'`rd'`hr'`tratio'"' != "" {
		local eformopts `eform1' `eform' `irr' `or' `rrr' `rd' `hr' `tratio'
	}
	_get_eformopts , eformopts(`eformopts') ///
		allowed(__all__ irr or rr rrr rd hr tratio)
	// consolidate eform options
	local eformopts `eformopts' `beformopts'
	local eformopts : list uniq eformopts
	if "`model'" != "binreg" & "`model'" != "logistic" {
		_get_eformopts , eformopts(`eformopts') ///
			allowed(__all__ irr or rr rrr rd hr tratio)
	}
	if "`cmdname'" != "binreg" {
		if `"`coefficients'"' != "" & `"`eformopts'"' != "" {
di as err "only one of {bf:`coefficients'} or {bf:`eformopts'} is allowed"
			exit 198
		}
	}
		
	local useriterate
	if "`mleinitopts'" != "" & "`initrandom'" == "" & "`nomleinitial'" == "" {	
		local options `options' `difficult' `nonrtolerance' 
		local difficult
		local nonrtolerance
		if "`difficult'" != "" {
			local options `options' `difficult'
			local difficult
		}
		if "`search'" != "" {
			local options `options' `search'
			local search
		}
		if "`technique'" != "" {
			local options `options' technique(`technique')
			local technique
		}
		if "`iterate'" != "" {
			confirm integer number `iterate'
			local useriterate `iterate'
			local iterate
		}
		if "`from'" != "" {
			local options `options' from(`from')
			local from
		}
		if "`tolerance'" != "" {
			local options `options' tolerance(`tolerance')
			local tolerance
		}
		if "`ltolerance'" != "" {
			local options `options' ltolerance(`ltolerance')
			local ltolerance
		}
		if "`nrtolerance'" != "" {
			local options `options' nrtolerance(`nrtolerance')
			local nrtolerance
		}
		if "`qtolerance'" != "" {
			local options `options' qtolerance(`qtolerance')
			local qtolerance
		}
		if "`nonrtolerance'" != "" {
			local options `options' nonrtolerance(`nonrtolerance')
			local nonrtolerance
		}
	}

	if `parseonly' {
		local nomleinitial nomleinitial
	}

	if "`clevel'" != "" & "`level'" != "" {
		if "`clevel'" != "`level'" {
			di as err "options {bf:clevel(`clevel')} and " ///
				"{bf:level(`level')} cannot be combined"
			exit 198
		}
	}
	if "`level'" != "" {
		local bayesopt `bayesopt' clevel(`level')
	}
	else {
		local bayesopt `bayesopt' clevel(`clevel')
	}

	if "`model'"=="betareg" | "`model'"=="glm" {
		local options `options' `scale'
	}
	else {
		_opt_err "`model'" scale() `scale'
	}

	_opt_err "`model'" moptobj()		`moptobj'
	_opt_err "`model'" hascons		`hascons'
	_opt_err "`model'" mle			`mle'
	_opt_err "`model'" twostep		`twostep'
	_opt_err "`model'" difficult		`difficult'
	_opt_err "`model'" search()		`search'
	_opt_err "`model'" technique()		`technique'
	_opt_err "`model'" iterate()		`iterate'
	_opt_err "`model'" nolog		`log'
	_opt_err "`model'" trace		`trace'
	_opt_err "`model'" gradient		`gradient'
	_opt_err "`model'" showstep		`showstep'
	_opt_err "`model'" hessian		`hessian'
	_opt_err "`model'" showtolerance	`showtolerance'
	_opt_err "`model'" tolerance()		`tolerance'
	_opt_err "`model'" ltolerance()		`ltolerance'
	_opt_err "`model'" nrtolerance()	`nrtolerance'
	_opt_err "`model'" nonrtolerance	`nonrtolerance'
	_opt_err "`model'" from()		`from'
	_opt_err "`model'" qtolerance()		`qtolerance'
	_opt_err "`model'" fisher()		`fisher'
	_opt_err "`model'" vce()		`vce'
	_opt_err "`model'" robust		`robust'
	_opt_err "`model'" nocnsreport		`cnsreport'
	_opt_err "`model'" coeflegend		`coeflegend'
	_opt_err "`model'" nocoef		`nocoef'
	_opt_err "`model'" partial		`partial'
	_opt_err "`model'" lrmodel		`lrmodel'
	_opt_err "`model'" waldhet		`waldhet'
	_opt_err "`model'" irls			`irls'
	_opt_err "`model'" ml			`ml'
	_opt_err "`model'" nolrtest		`nolrtest'
	_opt_err "`model'" vfactor		`vfactor'
	_opt_err "`model'" probitparam		`probitparam'
	_opt_err "`model'" vuong		`vuong'
	_opt_err "`model'" zip			`zip'
	_opt_err "`model'" first		`first'
	_opt_err "`model'" nshazard()		`nshazard'
	_opt_err "`model'" mills()		`mills'
	_opt_err "`model'" nodisplay		`display'
	_opt_err "`model'" dnumerical		`dnumerical'
	_opt_err "`model'" transform		`transform'
	_opt_err "`model'" nofootnote		`nofootnote'

	// me
	_opt_err "`model'" intmethod()		`intmethod'
	_opt_err "`model'" intpoints()		`intpoints'
	_opt_err "`model'" startvalues()	`startvalues'
	_opt_err "`model'" startgrid		`startgrid'
	_opt_err "`model'" startgrid()		`startgrid1'
	_opt_err "`model'" noestimate		`noestimate'

	if "`model'" != "tnbreg" & "`model'" != "nbreg" & "`model'" != "menbreg" {
		_opt_err "`model'" dispersion() `dispersion'
	}

	local covariances
	if !`:list model in mecommands' {
		_opt_err_me_cmd covariance() `covariance'
		_opt_err_me_cmd nogroup `nogroup'
		local options `options' `dispersion' `time'
	}
	else {
		local extrameopts `extrameopts' `dispersion' `time'
		local bayesopt `bayesopt' `nogroup'

		local saveopt `options'
		local i 1
		while `"`eq_re`i'_label'"' != "" {
			if `"`eq_re`i'_cov'"' == "" {
				local eq_re`i'_cov independent
			}
			local 0 , `eq_re`i'_cov'
			capture syntax [, INDependent EXchangeable ///
				IDentity UNstructured FIXed PATtern]
			if _rc {
				di as err "covariance structure {bf:`eq_re`i'_cov'} invalid"
				di as error `"`_bayes_error'"'
				exit 198
			}
			local cov `exchangeable' `fixed' `pattern'
			if "`cov'" != "" {
				di as err "covariance structure {bf:`cov'} not supported"
				di as error `"`_bayes_error'"'
				exit 198
			}
			local covariance `independent' `unstructured' `identity'
			if "`independent'" != "" & "`unstructured'" != "" {
				di as err "covariance structure {bf:`covariance'} invalid"
				di as error `"`_bayes_error'"'
				exit 198
			}
			local covariances `covariances' `eq_re`i'_label':`covariance'
			//local reoptions `reoptions' covariance(`covariance')
			local i = `i' + 1
		}
		local options `saveopt'
	}

	if `"`constraints'"' != "" {
		di as err "constraints not allowed with the {bf:bayes} prefix"
		exit 198
	}
	
	if ("`model'"=="binreg") {
		if "`irls'" != "" {
	di as err "{bf:`irls'} option not allowed with the {bf:bayes} prefix"
			exit 198
		}
		local options `options' ml
	}

	if (`"`model'"' == "intreg") {
		// intreg evaluator requires -notransform- option
		local options `options' notransform
	}

	if "`offset'" != "" {
		local options `options' offset(`offset')
	}
	if "`exposure'" != "" {
		local options `options' exposure(`exposure')
	}

	local eret_offset `offset'
	local eret_exposure `exposure'
	
	// form estimation command options
	if "`model'"=="regress" | "`model'"=="mvreg" | "`model'"=="mestreg" {
		// these use -gsem- or -bayesmh- 
		local rhs , `options'
	}
	else {
		local rhs, `options' `coefficients'
		local 0, `eformopts'
		syntax [, EForm1(passthru) EForm *]
		local rhs `rhs' `options'
	}

	// transfer some common options
	local bayesopt `bayesopt' `noheader' `notable' 

	if "`model'" != "streg" & "`model'" != "mestreg" & `"`yvars'`lhs'"' == "" {
		di as error "model specification required"
		di as error `"`_bayes_error'"'
		exit 198
	}

	if `:list model in mecommands' {
		// options in fe_equ
		gettoken lhs 0 : lhs, parse(",")
		syntax [anything][, NOCONstant 		///
			OFFset(varname numeric ts)	///
			Exposure(varname numeric ts)	///
			link(string) family(string)	///
			asis				///
			* ]
		if `"`options'"' != "" {
di as error `"option {bf:`options'} not allowed in the fixed-effects specification"'
			di as error `"`_bayes_error'"'
			exit 198
		}
		local eret_offset `eret_offset' `offset'
		local eret_exposure `eret_exposure' `exposure'
		if `"`link'"' != "" {
			local rhs `rhs' link(`link')
		}
		if `"`family'"' != "" {
			local rhs `rhs' family(`family')
		}
		local 0 `noconstant' `asis'
		if "`offset'" != "" local 0 `0' offset(`offset')
		if "`exposure'" != "" local 0 `0' exposure(`exposure')
		if `"`0'"' != "" & "`respec'" != "" {
			local lhs `lhs', `0'
		}
		else {
			local rhs `rhs' `0'
		}
		local lhs `lhs' `respec'
		// options in re_equ
		local 0 `rhs'
		/// reporting options
		if "`model'" == "meglm" {
			syntax [, eform irr or *] 
		}
		else if "`model'" == "menbreg" | "`model'" == "mepoisson" {
			syntax [, eform irr *] 
		}
		else if "`model'" == "melogit" | "`model'" == "meologit" {
			syntax [, eform or *]
		}
		else {
			syntax [, eform *]
		}
		local rhs , `options'
	}

	_mcmc_definename touse
	local gtouse `s(define)'
	global MCMC_genvars $MCMC_genvars `gtouse'

	local respec
	local remodel
	local headerstr1
	local headerstr2
	local headerstr3
	local subjects
	local censor
	local ylabexcl
	local display_st_show
	
	if ("`model'"=="regress") {
		local subcmd gsem
		gettoken yvar lhs : lhs, bind
		tsunab yvar: `yvar'
		local lhs `yvar' `lhs' 
		gettoken yvar lhs : lhs, bind
		local regresscall = `"`yvar' `lhs' `rhs'"'
		local lhs = `"`yvar' = `lhs'"'
		
		local 0 , `eformopts'
		syntax [, EForm1(string) EForm *]
		if `"`eform1'"' == "" {
			if `"`eform'"' != "" {
				local eform eform(exp(b))
			}
		}
		else {
			local eform  `"eform(`eform1')"'
		}
		cap `version' regress `regresscall' `eform' `options'
		scalar min_rmse = 0
		if _rc {
			// reproduce the error
			cap nois `version' regress `regresscall' `eform' `options'
			di as error `"`_bayes_error'"'
			exit _rc
		}
		else {
			scalar min_rmse = `e(rmse)'
		}
		if min_rmse <= 0 {
			scalar min_rmse = 1
		}
	}
	else if ("`model'"=="mvreg") {
		local subcmd gsem
		gettoken yvars : lhs, parse("=") match(par) bind
		if `"`par'"' == "(" {
			gettoken yvars : yvars
			tsunab yvars: `yvars'
		}
		local regresscall = `"`lhs' `rhs'"'

		cap matrix drop initSigma
		local 0 ,`eformopts'
		syntax [, EForm1(passthru) EForm *]
		cap `version' mvreg `regresscall' `options'
		if _rc {
			cap `version' mvreg `regresscall'
			if _rc == 0 {
				// error due to options
				cap nois `version' mvreg `regresscall' `options'
				di as error `"`_bayes_error'"'
				exit _rc
			}
			else if _rc == 111 | _rc == 198 {
				// syntax errors
				cap nois `version' mvreg `regresscall'
				di as error `"`_bayes_error'"'
				exit _rc
			}
		}
		matrix initSigma = e(Sigma)
		matrix initSigma = 0.5*(initSigma+initSigma')
		if initSigma[1,1] == . {
			matrix drop initSigma
		}
		// add -listwise- options to -gsem- to form the correct e(sample)
		local rhs `rhs' listwise
	}
	else if ("`model'"=="fracreg") {
		gettoken subcmd lhs : lhs
		local 0 ,`subcmd'
		syntax [, PRobit LOGit * ]
		local subcmd `probit'`logit'
		local model_f fracreg_`subcmd'
		local subcmd fracreg `subcmd'
		// the first varname in lhs is yvar
		gettoken yvars : lhs
	}
	else if ("`model'"=="streg" | "`model'"=="mestreg") {
		local 0 `rhs'
		syntax [, DISTribution(string) * ]
		local 0 , `distribution'
		syntax [, Exponential GOMPertz LOGLogistic LLogistic ///
			Weibull LOGNormal LNormal GGAMma * ]
		local distribution `exponential'`gompertz'`loglogistic'/*
		*/`llogistic'`weibull'`lognormal'`lnormal'`ggamma'
		if "`model'"=="streg" & "`distribution'" != "" {
			local model_f streg_`distribution'
		}
		if `"`yvar'"' == "" {
			local yvar _t
		}
		local yvars `yvar'
		if "`noisily'" == "" {
			local display_st_show st_show `noshow'
		}
	}
	else if ("`model'"=="logistic") {
		local or
		if (`"`coef'"' == "") {
			local or or
		}
	}
	else if (`"`model'"' == "intreg") {
		gettoken tok rest : lhs, match(par) bind
		local yvars `tok'
		gettoken tok : rest, match(par) bind
		local yvars `yvars' `tok'
	}
	if "`model'"=="glm" {
		// scale() is undocumented option for -glm- with Gaussian family
		local 0 `rhs'
		syntax [, Family(string) * ]	
		local 0 ,`family'
		if `"`family'"' != "" {
			syntax [, GAUssian * ]
			if `"`gaussian'"' == "" {
				_opt_err "`model'" scale() `scale'
			}
		}
	}

	if `"`mcmcobject'"' != "" {
		capture mata: `mcmcobject'
		if _rc != 0 {
			di as err `"{bf:`mcmcobject'} not found"'
			exit _rc
		}
	}
	else {
		mata: getfree_mata_object_name("mcmcobject", "_model")
		mata: `mcmcobject' = _c_mcmc_model()
	}
	
	if $MCMC_debug {
		mata: `mcmcobject'.m_debug = 1
	}

	mata: `mcmcobject'.m_command = "bayesmh"
	mata: `mcmcobject'.m_cmdline = `"`zero'"'

	mata: getfree_mata_object_name("moptobject", "_mobj")
	capture mata: Mopt_moptobj_cleanup(`moptobject')
	local moptopt moptobj(`moptobject')

	// when nchains > 1, -rnormal- is called for initials
	// set nchains before calling set_rngstate()
	mata: `mcmcobject'.set_mcmc_chains(`nchains')

	_mcmc_set_seed "`mcmcobject'" "`rseed'"
	mata: `mcmcobject'.set_rngstate()
	if "`rseed'" != "" {
		local bayesopt `bayesopt' rseed(`rseed')
	}
	
	tempname metouse
	local metitle
	local yoffsetvar
	local relevellist
	local restublist
	local consnoshow	/* parameters not to be shown in the output */
	local nreparams
	
	 if `:list model in mecommands' {
		local tok `lhs'
		if regexm(`"`lhs'"', ",") == 0 & ///
		regexm(`"`lhs'"', "\|\|") == 0 {
			local tok `tok' `rhs'
		}
		gettoken tok 0: tok, parse(",") bind
		syntax [anything] [, NOCONstant *]
		local fenoconstant `noconstant'
	 }

	if "`model'" == "mixed" {
		//local model regress
		local 0 ,`bayesopt'
		syntax [, GIBBS *]
		local bayesopt gibbs `options'

		local subcmd meglm
		local 0 `rhs'
		syntax [, link(string) family(string) *]
		local rhs , family(gaussian) link(identity) `options'
		capture `version' meglm `lhs' `rhs' iter(0)
		if _rc == 1 {
			exit 1
		}
		if _rc == 430 | _rc == 1400 {
			di as error "{bf:bayes} initialization failed"
			di as err "{p 4 4 2}You should execute the command" 
			di as err "without the {bf:bayes} prefix and verify"
			di as err "that it produces sensible results.{p_end}"
			exit _rc
		}
		if _rc != 0 {
			capture noisily qui `version' `subcmd' `lhs' `rhs' iter(0)
			di as error `"`_bayes_error'"'
			exit _rc
		}
		cap drop `metouse'
		gen `metouse' = e(sample)

		local rhs `rhs' `fenoconstant'

		local metitle "multilevel regression"
		local subcmd gsem
		gen byte `gtouse' = e(sample)
		local respec `e(REspec)'

		gettoken lhs : lhs, parse(",|")
		if `"`lhs'"' == "," | `"`lhs'"' == "|" {
			local lhs
		}
		gettoken yvar lhs : lhs
		local lhs `yvar' <-`lhs'
		
		local ylabel `yvar'
		capture _ms_parse_parts `ylabel'
		if _rc == 0 {
			local ylabel `r(name)'
		}
		_mcmc_definename `ylabel'
		local tmpvar `s(define)'
		global MCMC_xbdeflabs $MCMC_xbdeflabs `ylabel'
		global MCMC_xbdefvars $MCMC_xbdefvars `tmpvar'
		global MCMC_genvars $MCMC_genvars `tmpvar'

		if "`exposure'" != "" {
			di as error "option {bf:exposure(`exposure')} not allowed"
			di as error `"`_bayes_error'"'
			exit 198
		}
		if "`offset'" != "" {
			di as error "option {bf:offset(`offset')} not allowed"
			di as error `"`_bayes_error'"'
			exit 198
		}
		local offset `yvar'
		
		quietly generate double `tmpvar' = `yvar' if `gtouse'
		local yoffsetvar `tmpvar'

		_bayes_reffects `mcmcobject' `moptobject' `model'	 ///
			`"`covariances'"' `gtouse' 			 ///
			`"`ylabel'"' `"`yvar'"' `"`respec'"' `"`offset'"' ///
			`"`tmpvar'"' `"`restubs'"' `"`exclude'"'	 /// 
			`parseonly' `nchains'

		if `nchains' > 1 {
			forvalues i = 2/`nchains' {
				local optinitial`i' = `"`s(optinitial`i')' `optinitial`i''"'
			}
		}
		
		local exparlist `s(exparlist)'
		local reparlist `s(eqlatent)'
		local remodel = `"`s(remodel)'"'
		local relevellist `s(relevellist)'
		local restublist `s(restublist)'
		local nreparams `s(nreparams)'
		local 0 , `options'
		
		local options `options' `noconstant' `asis' 
	}
	else if `:list model in mecommands' {
		capture `version' `subcmd' `lhs' `rhs' `extrameopts' ///
			noestimate startvalues(zero)
		if _rc == 1 {
			exit 1
		}
		if _rc != 0 {
			capture noisily `version' `subcmd' `lhs' `rhs' ///
				noestimate startvalues(zero)
			di as error `"`_bayes_error'"'
			exit _rc
		}
		cap drop `metouse'
		gen `metouse' = e(sample)

		local udepvar
		gettoken lhs : lhs, parse(",|")
		if `"`lhs'"' == "," | `"`lhs'"' == "|" {
			local lhs
		}
		if "`model'" == "mestreg" {
			local yvar `e(yinfo1_name)'
			local 0 `rhs'
			syntax [, Distribution(string) * ]
			local rhs ,`options'
			if `"`e(frm2)'"' == "hazard" & "`e(noeform)'" == "" {
				local default_eform hr
			}
		}
		else {
			gettoken yvar lhs : lhs
			tsunab yvar: `yvar'
			if "`model'" == "meintreg" {
				gettoken udepvar lhs : lhs
			}
		}
		local lhs `yvar' <-`lhs'

		if `"`offset'`exposure'"' == "" {
			local EXTRAOPTS	OFFset(varname numeric ts)	///
					Exposure(varname numeric ts)
		}

		local 0 `rhs'
		syntax [, link(string) family(string) `EXTRAOPTS' /*
		*/ ll(string) ul(string) binomial(passthru) *]		
		local link   `e(link)'
		local family `e(family)'
		if `"`EXTRAOPTS'"' != "" {
			local eret_offset `offset'
			local eret_exposure `exposure'
		}

		if "`e(family)'" == "binomial" {
			local family binomial `e(binomial)'
		}
		if "`e(family)'" == "nbinomial" {
			local family nbinomial `e(dispersion)'
		}
		if "`e(family)'" == "gaussian" & "`udepvar'" != "" {
			local family gaussian,  udepvar(`udepvar')
		}

		if "`model'" == "mestreg" {
			local family `family' `e(yinfo1_finfo_fargs)'
			local link
		}
		else if "`model'" == "metobit" {
			local family gaussian,
			if "`ll'" != "" {
				local family `family' lc(`ll')
			}
			if "`ul'" != "" {
				local family `family' rc(`ul')
			}
		}

		local rhs , family(`family') link(`link') `fenoconstant' `options'

		// header info: family and link
		local metitle `"`e(title)'"'
		local metitle = regexr(`"`metitle'"', "Mixed-effects", "multilevel")

		if "`e(family)'" == "ordinal" {
			local noconstant noconstant
			local rhs `rhs' noconstant
		}

	if "`model'" != "mestreg" {
	
		local cnames `e(yinfo1_finfo_family)'
		if "`cnames'" == "binomial" {
			local cnames `cnames' `e(yinfo1_finfo_fargs)'
		}
		if "`cnames'" == "nbinomial" {
			local cnames `cnames' `e(dispersion)'
		}
		if "`cnames'" == "" {
			local cnames `e(family)'
		}
		_bayes_family_title "`cnames'"
		local cnames `r(cnames)'
		local len = 0
		local headerstr1 = `""Family" _skip(`len') as txt " : " as res "`cnames'""'
		local cnames = lower("`e(link)'")
		local len = 2
		local headerstr2 = `""Link" _skip(`len') as txt " : " as res "`cnames'""'
	}
		local subcmd gsem
		gen byte `gtouse' = e(sample)
		local respec `e(REspec)'

		local ylabel `yvar'
		capture _ms_parse_parts `ylabel'
		if _rc == 0 {
			local ylabel `r(name)'
		}

		_bayes_define_offset `"`ylabel'"' `"`offset'"' `"`exposure'"' ///
			`"`respec'"' `"`gtouse'"'
		local offset `s(offset)'
		local tmpvar `s(tmpvar)'
		local consnoshow `consnoshow' `s(noshow)'

		_bayes_reffects `mcmcobject' `moptobject' `model'	 ///
			`"`covariances'"' `gtouse' 			 ///
			`"`ylabel'"' `"`yvar'"' `"`respec'"' `"`offset'"' ///
			`"`tmpvar'"' `"`restubs'"' `"`exclude'"'	///
			`parseonly' `nchains'

		if `nchains' > 1 {
			forvalues i = 2/`nchains' {
				local optinitial`i' = `"`s(optinitial`i')' `optinitial`i''"'
			}
		}

		local exparlist `s(exparlist)'
		local reparlist `s(eqlatent)'
		local remodel = `"`s(remodel)'"'
		local relevellist `s(relevellist)'
		local restublist `s(restublist)'
		local nreparams `s(nreparams)'
		local 0 , `options'

		local options `options' `noconstant' `asis' 
		local rhs `rhs' offset(`tmpvar') useviews
	}
	
	if `"`e(cmd)'"' == "bayesmh" | `"`e(prefix)'"' == "bayes" {
		// clear any previous -bayesmh- results
		ereturn clear
	}

	if `:list model in mecommands' {
		local k_eq       `e(k_eq)'
		local k_eform    `e(k_eform)'
	}

	if `"`subcmd'"' == "gsem" {
		// capitalized variables should not be considered latent
		local rhs `rhs' nocapslatent
		// gsem does not tolerate spaces after "-" as in "weight- turn"
		local lhs : subinstr local lhs "- " "-", all
	}

	///////////////////////////////////////////
	// obtain likelihood evaluator 
	tempname mb tmodel mdatasize

	capture _estimates hold `tmodel'

	local capt capture `noisily'
	local eqline `subcmd' `lhs' `rhs' `moptopt'

	if "`initrandom'" == "" & "`nomleinitial'" == "" {
		if $MCMC_debug {
			di `"run: `capt' `version' `eqline'"'
		}
		local econv 1
		if "`dryrun'" != "" {
			`capt' `version' `eqline' iter(0)
		}
		else {
			if "`useriterate'" != "" {
				`capt' `version' `eqline' iter(`useriterate')
			}
			else {
				// default maximum ML iterations is 500
				`capt' `version' `eqline' iter(500)
			}
			if _rc == 0 {
				local econv = e(converged)
			}
		}
		if _rc == 1 {
			exit 1
		}
		if _rc == 430 | "`econv'" != "1" {
			// no convergence
			if "`useriterate'" != "" {
				local iterdi `useriterate'
			}
			else {
				local iterdi 500
			}
			if "`mleinitforce'" != "" {
di as txt "{p 0 6 0}note: initial values used are not MLEs because the " ///
	"likelihood model did not converge after {cmd:`useriterate'} iterations{p_end}"
			}
			else {
di as err "{p}failed to obtain ML initial values after `iterdi' iterations{p_end}" 	
di as err "{p 4 4 2}{bf:bayes} could not compute ML initial values because"
di as err "the model did not converge after `iterdi' iterations." 
di as err "You should investigate your model." 
di as err "Use one of options {bf:nomleinitial}, {bf:initrandom}, or"
di as err "{bf:initial()} with the {bf:bayes} prefix to specify" 
di as err "alternative initial values. To increase the number of iterations,"
di as err "specify option {bf:iterate()} with the command and"
di as err "option {bf:mleinitopts} with {bf:bayes}. To use the estimates"
di as err "from the last iteration of the nonconverged model as initial"
di as err "values, specify option {bf:mleinitforce} with {bf:bayes}.{p_end}"
exit 430
			}
		}
		if _rc {
			local rc = _rc
			if "`noisily'" != "noisily" {
				// reproduce the error
				cap nois `version' `eqline' iter(0)
			}
			di as error `"`_bayes_error'"'
			exit `rc'
		}
	}
	else {
		if $MCMC_debug {
			di `"run: `version' `eqline' iter(0)"'
		}
		`capt' `version' `eqline' iter(0)
		if _rc == 1 {
			exit 1
		}
		if _rc {
			// reproduce the error
			cap nois `version' `eqline' iter(0)
			di as error `"`_bayes_error'"'
			exit _rc
		}
	}

	// put moptobject in the global MCMC_moptobjs for release
	capture mata: `moptobject'
	if _rc == 0 {
		global MCMC_moptobjs $MCMC_moptobjs `moptobject'
	}
	else {
		di as err "Cannot initialize moptobj"
		di as error `"`_bayes_error'"'
		exit _rc
	}

	// save for later
	local cmd2       `e(cmd2)'
	local enoconst   `e(noconstant)'
	local consonly   `e(consonly)'
	if !`:list model in mecommands' {
		local k_eq       `e(k_eq)'
		local k_eform    `e(k_eform)'
		// some models such as -biprobit- support equation specific offsets
		local eret_offset1 `e(offset1)'
		local eret_offset2 `e(offset2)'
	}

	cap drop `gtouse'
	gen `gtouse' = e(sample)
	capture confirm variable `metouse'
	if _rc == 0 {
		cap replace `gtouse' = `gtouse' & `metouse'
	}

	local wtype  = "`e(wtype)'"
	local wexp   = `"`e(wexp)'"'
	gettoken tok : wexp, parse("=")
	// for some commands e(wexp) includes the equal sign
	if `"`tok'"' == "=" {
		gettoken tok wexp: wexp, parse("=")
	}

	if "`gibbs'" != "" & "`subcmd'" == "gsem" & `"`e(covariates)'"' != "" {
		marksample touse
		cap markout `touse' `e(covariates)' 
		if  _rc == 0 {
			qui replace `gtouse' = `gtouse' & `touse'
		}
	}

	if "`wtype'" != "" & "`wtype'" != "fweight" {
		di as err "{bf:`wtype'}s not allowed with the {bf:bayes} prefix"
		exit 101
	}

	if "`e(user)'" == "ereg_lf" & "`e(frm2)'"=="time" {
		mata: `moptobject'.adj_func = findexternal("adj_exponential_t()")
		mata: `moptobject'.adj_args = J(1,0,0)
	}

	if "`e(user)'" == "weib_lf0" {
		tempvar lnt
		tempname lntmean
		gen double `lnt' = ln(`e(depvar)') if `gtouse'
		if "`wtype'" != "" {
			summarize `lnt' [`wtype' = `wexp'], meanonly
		}
		else {
			summarize `lnt', meanonly
		}
		scalar lntmean = r(mean)
		scalar cons = "`enoconst'" == "0"
		scalar time = "`e(frm2)'"=="time"
		mata: `moptobject'.adj_func = findexternal("adj_weibull_s()")
		mata: `moptobject'.adj_args =  ///
			(st_numscalar("time"), ///
			 st_numscalar("cons"), ///
			 st_numscalar("lntmean"))
	}

	matrix `mb' = e(b)
	matrix `mdatasize' = J(1,1,`e(N)')

	if "`noconstant'" != "" {
		local colnames : colfullnames `mb'
		foreach tok of local yvars {
			if !regexm("`colnames'", "`tok':_cons") {
				continue
			}
			local colnames = ///
			regexr("`colnames'", "`tok':_cons", "`tok':o._cons")
			local consnoshow `consnoshow' `tok':o._cons
		}
		
		matrix colnames `mb' = `colnames'
	}

	if ("`model'"=="regress") {
		capture confirm scalar min_rmse
		if _rc == 0 {
			local ncols : colsof `mb'
			matrix `mb'[1,`ncols'] = `=(min_rmse^2)'
		}
	}

	if ("`model'"=="mestreg") {
		local toks : colfullnames `mb'
		gettoken family : family, parse(",")
		local family `family'
		local colnames
		foreach tok of local toks {
			if `"`tok'"' == "/_t:logs" {
				if "`family'" == "lognormal" {
					local tok /_t:lnsigma
				}
				if "`family'" == "loglogistic" {
					local tok /_t:lngamma
				}
				if "`family'" == "gamma" {
					local tok /_t:lnscale
				}
			}
			local colnames `colnames' `tok'
		}
		matrix colnames `mb' = `colnames'
	}

	if !`:list model in mecommands' {
		_bayes_model_headers `mcmcobject' `model'
		local headerstr1 = `"`s(headerstr1)'"'
		local headerstr2 = `"`s(headerstr2)'"'
		local headerstr3 = `"`s(headerstr3)'"'
	}

	if ("`model'"=="mlogit") {
		local yvars `e(eqnames)'
		local toks `e(eqnames)'
		local ylabexcl `e(baseout)'
		if `"`ylabexcl'"' == "" {
			local ylabexcl `e(k_eq_base)'
		}
		local ylabexcl: word `ylabexcl' of `toks'
		mata: `mcmcobject'.set_eq_base(`e(k_eq_base)', `"`e(baselab)'"')
	}
	else if ("`model'"=="mprobit") {
		local yvars `e(outeqs)'
		local ylabexcl `e(out`e(k_eq_model_skip)')'
		mata: `mcmcobject'.set_eq_base(`e(k_eq_base)', `"`e(out`e(k_eq_base)')'"')
	}
	else if ("`model'"=="mvreg") {
		local yvars `e(depvar)'
	}

	if "`model'"=="binreg" {
		// for -binreg-, eformopts are also model options and 
		// should be used at replay
		local 0, `eformopts'
		syntax [, EForm1(passthru) EForm *]
		local default_eform `options'
	}

	// models with lower and upper truncation
	if ("`model'"=="truncreg") {
		// replace eq1:param with `depvar':`param'
		local colnames : colfullnames `mb'
		local newcolnames
		foreach tok of local colnames {
			tokenize `tok', parse(":")
			if "`1'" == "eq1" & "`2'" == ":" {
				local newcolnames `newcolnames' `yvars':`3'
			}
			else {
				local newcolnames `newcolnames' `tok'
			}
		}
		matrix colnames `mb' = `newcolnames'
	}

	// models with selection
	if ("`model'"=="heckman" | "`model'"=="heckprobit" | ///
	    "`model'"=="heckoprobit") {
		if !missing(e(N_selected)) {
			local censor `censor' `e(N_selected)'
		}
		else {
			local censor `censor' .
		}
		if !missing(e(N_nonselected)) {
			local censor `censor' `e(N_nonselected)'
		}
		else {
			local censor `censor' .
		}
	}

	// models with censoring
	if ("`model'"=="streg" | "`model'"=="mestreg") {
		if "`e(N_sub)'" != "" {
			local subjects `subjects' `e(N_sub)'
		}
		else {
			local subjects `subjects' .
		}
		if "`e(N_fail)'" != "" {
			local subjects `subjects' `e(N_fail)'
		}
		else {
			local subjects `subjects' .
		}
		if "`e(risk)'" != "" {
			local subjects `subjects' `e(risk)'
		}
		else {
			local subjects `subjects' .
		}
	}

	if `"`e(frm2)'"' == "hazard" & "`e(noeform)'" == "" {
		local default_eform hr
	}

	if ("`model'"=="clogit") {
		// sort by group variable(s)
		gsort -`gtouse' `e(group)' `e(depvar)'
	}
	
	if ("`model'"=="intreg") {
		// intreg has no depvars but a fixed label "model"
		gettoken yvar : yvars
		// replace model:param with `yvar':`param'
		local colnames : colfullnames `mb'
		local newcolnames
		foreach tok of local colnames {
			tokenize `tok', parse(":")
			if "`1'" == "model" & "`2'" == ":" {
				local newcolnames `newcolnames' `yvar':`3'
			}
			else {
				local newcolnames `newcolnames' `tok'
			}
		}
		matrix colnames `mb' = `newcolnames'
	}

	if `"`yvars'"' == "" {
		local cnames : colfullnames `mb'
		gettoken cnames : cnames
		if `"`cnames'"' != "" {
			gettoken yvars : cnames, parse(":")
		}
	}

	// update $MCMC_eqlablist with `yvars'
	foreach tok of local yvars {
		// add `yvar' to $MCMC_eqlablist
		_bayesmh_eqlablist ind `tok'
	}
	
	// save the y variable
	if `"`yvar'"' == "" {
		gettoken yvar : yvars
		if `"`yvar'"' == "" {
			local yvar _t
		}
	}

	local cnames `"`e(title)'"'
	if `:list model in mecommands' {
		local cnames `"`metitle'"'
	}
	gettoken cnames title : cnames
	local cnames = lower(`"`cnames'"')
	if (`"`cnames'"' == "heckman") local cnames Heckman
	if (`"`cnames'"' == "poisson") local cnames Poisson
	if (`"`cnames'"' == "weibull") local cnames Weibull
	local title `cnames'`title'
	if `"`model'"' == "clogit" {
		local title conditional logistic regression
	}
	if `"`model'"' == "regress" {
		local title linear regression
	}
	if `"`model'"' == "mvreg" {
		local title multivariate regression
	}
	if `"`model'"' == "zinb" {
		local title zero-inflated negative binomial model
	}
	if `"`e(cmd2)'"' == "streg" {
		if "`e(frm2)'" == "hazard" {
			local title `cnames' PH regression
		}
		if "`e(frm2)'" == "time" {
			local title `cnames' AFT regression
		}
	}
	if `"`model'"' == "hetoprobit" {
		local title heteroskedastic ordered probit
	}
	local title = `"Bayesian `title'"'

	capture _estimates unhold `tmodel'

	mata: `mcmcobject'.set_data_size("`mdatasize'")
	mata: `mcmcobject'.m_title = st_local("title")

	local paramlist: colfullnames `mb'
	local varlist: colnames `mb'
	if `"`varlist'"' == `"`paramlist'"' {
		local paramlist
		gettoken next varlist : varlist
		while `"`next'"' != "" {
			local paramlist `"`paramlist'`yvar':`next' "'
			gettoken next varlist : varlist
		}
	}

	if "`ylabexcl'" != "" {
		local varlist `paramlist'
		local paramlist
		gettoken next varlist : varlist
		while `"`next'"' != "" {
			gettoken lab par : next, parse(":")
			local n : list lab in ylabexcl
			if `n' == 0 {
				local paramlist `"`paramlist'`next' "'
			}
			gettoken next varlist : varlist
		}
		local yvars : list yvars - ylabexcl
	}

	if "`nomleinitial'" == "" {
	
		local rsigfact 3
		if `"`model'"' == "betareg"	/// 
		| `"`model'"' == "biprobit"	///
		| `"`model'"' == "heckman"	///
		| `"`model'"' == "heckprobit"	///
		| `"`model'"' == "heckoprobit"	///
		| `"`model'"' == "intreg"	///
		| `"`model'"' == "mlogit" 	///
		| `"`model'"' == "ologit" 	///
		| `"`model'"' == "streg"	///
		| `"`model'"' == "truncreg" {
			local rsigfact 0.5
		}
		if `"`model'"' == "oprobit" {
			local rsigfact 0.1
		}

		_bayes_utils optinitial `mb' `nchains' `rsigfact'
		local optinitial = `"`optinitial' `s(optinitial)'"'
		if `nchains' > 1 {
			forvalues i = 2/`nchains' {
				local optinitial`i' = `"`s(optinitial`i')' `optinitial`i''"'
			}
		}
		if "`model'" == "mvreg" {
			capture confirm matrix initSigma
			if _rc == 0 {
				local optinitial = ///
				`"`optinitial' {Sigma,matrix} initSigma"'
			}
		}
	}

	if `"`default_eform'"' !=  "hr" | "`nohr'" == "" {
		local 0 ,`eformopts'
		syntax [, eform eform1(passthr) *]
		if `"`eform'`eform1'"' == "" {
			local eformopts `options' `default_eform'
			local eformopts : list uniq eformopts
		}
	}

	local options touse(`gtouse') wtype(`wtype') wexp(`wexp') `bayesopt'

	// build model
	_bayes_utils setup_model `mcmcobject' `moptobject'		///
		`model_f' `"`yvars'"' `"`yoffsetvar'"' `"`paramlist'"'	///
		`"`exparlist'"' `"`reparlist'"' `"`relevellist'"'	///
		`"`restublist'"' `normalprior' `igamshape' `igamscale'	///
		`"`iwishartopts'"' `blocksize' "`reblocksok'" `parseonly' `"`options'"'

	if "`nomleinitial'" != "" {
		_bayes_utils defaultinitial `"`s(paramlist)'"'
		local optinitial = `"`optinitial' `s(optinitial)'"'
	}
	else if `nchains' > 1 & `"`s(pardefined)'"' != "" {
		// remove optional initialization for parameters with 
		// user-defined priors, excluding reparams
		local pardefined `s(pardefined)'
		local pardefined : list pardefined - reparlist
		forvalues i = 2/`nchains' {
		foreach param of local pardefined {
			local templist `optinitial`i''
			local optinitial`i'
			gettoken tok templist : templist, bind bindcurly
			while `"`tok'"' != "" {
				if `"`tok'"' == `"{`param'}"' ||	///
				`"`tok'"' == `"{`param',matrix}"' ||	///
				regexm(`"`tok'"', `"{`param'[_|0-9]*}"') {
					// remove the next as well
					gettoken tok templist : templist, bind bindcurly
				}
				else {
					local optinitial`i' = ///
					`"`optinitial`i'' `tok'"'
				}
				gettoken tok templist : templist, bind bindcurly
			}
		}

		}
	}

	if "`noblocking'" != "" {
		mata: `mcmcobject'.reset_blocks()
		if "`gibbs'" != "" {
di `"{txt}note: option {bf:gibbs} has no effect when {bf:`noblocking'} is specified"'
		}
	}
	if "`gibbs'" != "" & "`s(gibbsappl)'" != "1" {
di `"{txt}note: option {bf:gibbs} has no effect for any of the model parameters"'
	}

	// if coefficient are requested, ignore all eform report options
	if "`coefficients'" != "" {
		local eformopts
	}

	// bayes prefix uses rng to setup optional initials
	// so restore states to help reproducibility
	mata: `mcmcobject'.restore_rngstates()

	sreturn local mcmcobject  `mcmcobject'
	sreturn local optinitial  `optinitial'
	if `nchains' > 1 {
		forvalues i = 2/`nchains' {
			sreturn local optinitial`i' `optinitial`i''
		}
	}
	sreturn local blocksize   `blocksize'
	sreturn local normalprior `normalprior'
	sreturn local igammashape `igamshape'
	sreturn local igammascale `igamscale'
	sreturn local eformopts   `eformopts'
	sreturn local command     `command'
	sreturn local cmdname     `cmdname'
	sreturn local headerstr1  = `"`headerstr1'"'
	sreturn local headerstr2  = `"`headerstr2'"'
	sreturn local headerstr3  = `"`headerstr3'"'
	sreturn local subjects    = `"`subjects'"'
	sreturn local censor      = `"`censor'"'
	sreturn local remodel     = `"`remodel'"'
	sreturn local reparlist   = `"`reparlist'"'
	sreturn local default_eform = `"`default_eform'"'
	sreturn local eret_offset1  = `"`eret_offset1'"'
	sreturn local eret_offset2  = `"`eret_offset2'"'
	sreturn local eret_offset   = `"`eret_offset'"'
	sreturn local eret_exposure = `"`eret_exposure'"'
	sreturn local display_st_show = `"`display_st_show'"'

	local nparams: word count `s(paramlist)'
	_bayesmh_maxvar_err `nparams' `nreparams'

	sreturn local nparams   = `"`nparams'"'
	sreturn local nreparams = `"`nreparams'"'
	sreturn local nchains   = `nchains'
	
	// don't show reparlist
	local paramlist `s(paramlist)'
	local paramnoshow `consnoshow' `s(paramnoshow)'
	local paramnoshow : list uniq paramnoshow
	sreturn local paramnoshow = `"`paramnoshow'"'

	sreturn local cmd2       `cmd2'
	sreturn local k_eq       `k_eq'
	sreturn local k_eform    `k_eform'
	sreturn local noconstant `enoconst'
	sreturn local consonly   `consonly'

	// collate the eqnames list
	local lablist $MCMC_eqlablist
	local eqnames
	foreach yvar of local lablist {
		local eqnames `eqnames' {`yvar':}
	}
	sreturn local eqnames `"`eqnames'"'
end

program _opt_err
	args model optname opt
	if (`"`opt'"'=="") exit
	di as err "option {bf:`optname'} not allowed with {bf:bayes:`model'}"
	exit 198
end

program _opt_err_me_bayes
	args optname opt
	if (`"`opt'"'=="") exit
	di as err "{p}option {bf:`optname'} is allowed with the {bf:bayes} "
	di as err "prefix only for multilevel commands{p_end}"
	exit 198
end

program _opt_err_me_cmd
	args optname opt
	if (`"`opt'"'=="") exit
	di as err "{p}option {bf:`optname'} is allowed only with " ///
		  "multilevel commands{p_end}"
	exit 198
end

program _check_command, sclass

	gettoken lhs rhs : 0, parse("|")
	gettoken model : lhs
	sreturn clear
	if (`"`rhs'"' != "") {
		// fe_eq, fe_opt
		sreturn local before `"`lhs'"'
		sreturn local eq_fixed `"`lhs'"'
		// REs
		local after `"`rhs'"'
		local i 0
		local respec
		while `"`after'"' != "" {
			// re_eq, re_opt
			gettoken tok after : after, parse("|")
			gettoken tok : after, parse("|")
			if `"`tok'"' == "|" {
				gettoken tok after : after, parse("|")
			}
			gettoken rhs after : after, parse("|")
			local i = `i' + 1
			sreturn local eq_re`i' `"`rhs'"'
			
			gettoken tok : rhs, parse(":")
			sreturn local eq_re`i'_label `"`tok'"'

			gettoken lhs 0 : rhs, parse(",")
			local respec `respec' || `lhs'
			syntax [, COVariance(string) NOCONstant ///
			FWeight(string) IWeight(string) PWeight(string) ///
			* ]
			_opt_err "`model'" fweight() `fweight'
			_opt_err "`model'" iweight() `iweight'
			_opt_err "`model'" pweight() `pweight'
			sreturn local eq_re`i'_cov `"`covariance'"'
			local rhs `lhs', `noconstant' `options'
		}

		_parse comma lhs rhs : rhs
		sreturn local after `"`rhs' `fe_opt'"'
		sreturn local respec `"`respec'"'

		exit
        }
	capture _on_colon_parse `0'
	 if !_rc & "`s(before)'" != "" {
		di as err `"command prefix {bf:`s(before)'} not supported"'
		exit 198
	}
	_parse comma lhs rhs : 0
	sreturn local before `"`lhs'"'
	sreturn local after `"`rhs'"'
end
