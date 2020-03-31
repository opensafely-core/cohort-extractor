*! version 1.0.2  09feb2015
program u_mi_impute_cmd_mvn_parse, sclass
	version 12
	// initial parse
	syntax [anything(equalok)] [if],		///
			impobj(string)			///	//internal
		[					/// 
			NOCONStant			///
			BURNin(integer 100)		///
			BURNBetween(integer 100)	///
			PRIor(string)                   ///
			MCMCONLY			///
			INITMcmc(string)		///
			WLFWGT(string)			///
			SAVEWlf(string asis)		///
			SAVEPtrace(string asis)		///
			EMLOG				/// 
			EMOUTput			///
			NOIsily				///
			MCMCDOTS			///
			ALLDOTS				///
			NOLOG				///
			EMONLY				///
			EMONLY1(passthru)		///
			NOMISSNOTE			/// //undoc.
			NOCHECKPD			/// //undoc.
			SAVINGPARAMS(string asis)	/// //undoc.
			IMPLOG				/// //undoc.
			IMPITERDOTS			/// //undoc.
			DOTS				///
			FORCE				///
			float				///
			double				///
			ifgroup(string)			/// //internal
		]
	if ("`mcmcdots'"!="") {
		local impiterdots impiterdots
		local dots
	}
	opts_exclusive "`implog' `alldots'"
	opts_exclusive "`implog' `mcmcdots'"
	opts_exclusive "`implog' `impiterdots'"
	opts_exclusive "`implog' `dots'"
	if (`"`ifgroup'"')!="" { 
		if (`"`wlfwgt'`savewlf'`saveptrace'"'!="") {
			di as err "{bf:wlfwgt()}, {bf:savewlf()}, and"	///
				  " {bf:saveptrace()} are not allowed"	///
				  " in combination with {bf:by()}"
			exit 198
		}
	}
	if ("`indent'"=="") {
		local indent 0 4 2
	}
	if ("`errindent'"=="") {
		local errindent 0 4 2
	}
	if ("`alldots'"!="") {
		local impiterdots impiterdots
	}
	if ("`implog'"!="") {
		local dots
	}
	local emopts `noconstant' `nocheckpd'

	// parse and check <ivars>
	gettoken ivars aftereq: anything, parse("=")
	gettoken eq xlist: aftereq, parse("=")
	u_mi_impute_check_ivars ivars : "`ivars'"
	local p : word count `ivars'
	if (`"`xlist'"'!="") {
		_chk_ts `xlist'
		fvunab xlist : `xlist'
		unopvarlist `xlist'
		local xvars `r(varlist)'
		confirm numeric variable `xvars'
	}
	else if ("`xlist'"=="" & "`noconstant'"!="") { // -noconstant-
		di as err as smcl "{p `errindent'}{bf:noconstant} is " 	///
				  "not allowed without independent "	///
				  "variables{p_end}"
		exit 198
	}
	// 'touse' must refer to the analysis sample
	tempvar touse
	mark `touse' `if' `in'
	markout `touse' `ivars', sysmissok
	if ("`ifgroup'"!="") {
		qui replace `touse' = 0 if !(`ifgroup')
	}
	// must use m0
	local style `_dta[_mi_style]'
	if ("`style'"=="mlong" | "`style'"=="flong") {
		qui replace `touse' = 0 if _mi_m>0
		local dosort sort _mi_m _mi_id
	}
	else if "`style'"=="wide" {
		tempvar id
		qui gen `c(obs_t)' `id' = _n
		qui compress `id'
		local dosort sort `id'
	}
	else {
		local dosort sort _mi_id
	}
	local nxterms 0
	if (`"`xlist'"'!="") {
		fvexpand `xlist' if `touse'
		local nxterms : word count `r(varlist)'
	}
	if ("`noconstant'"=="") {
		local ++nxterms
	}

	//check options
	if (`"`emonly1'"'!="") {
		local emonly emonly
	}
	if (`"`emonly'"'!="") {
		local initmcmc		// ignore initmcmc()'s options
	}	
	if ("`emonly'"!="" | "`noisily'"!="") {
		local emoutput emoutput
	}
	if ("`nolog'"!="") {
		local alldots
		local dots
		local impiterdots
		local implog
		local emlog
		local emoutput
	}
	if ("`emoutput'"!="") {
		local emlog emlog
	}
	if ("`nolog'"!="" | "`emoutput'`emlog'"=="") {
		local emopts `emopts' nolog
	}
	if ("`mcmconly'"!="" & "`emonly'"!="") {
		di as err "{bf:mcmconly} and {bf:emonly} cannot be combined"
		exit 198
	}
	if (`burnin'<1) {
		di as err "{bf:burnin()} must be a positive integer"
		exit 198
	}
	if (`burnbetween'<1) {
		di as err "{bf:burnbetween()} must be a positive integer"
		exit 198
	}
	if ("`mcmconly'"!="") {
		local impiterdots
	}
	if (`"`initmcmc'"'!="") {
		_parse comma inittype initopts : initmcmc
		if ("`inittype'"=="") {
			local inittype em
		}
	}
	else {
		local inittype em
	}
	// -wlfwgt()-
	if (`"`wlfwgt'"'!="") {
		cap confirm matrix `wlfwgt'
		if (_rc) {
			di as err "{bf:wlfwgt()} must contain " ///
				  "valid Stata matrix"
			exit 198
		}
	}
	// -savewlf()-
	if (`"`savewlf'"'!="") {
		if ("`inittype'"!="em" & "`wlfwgt'"=="") {
			di as err "{p 0 0 2}{bf:savewlf()} "	///
				  "requires specification of "	///
				  "{bf:wlfwgt()} when {bf:initmcmc(em)} " ///
				  "is not used{p_end}"
			exit 198
		}
		_savingopt_parse wlffname wlfreplace : ///
			savewlf ".dta" `"`savewlf'"'
		if ("`wlfreplace'"=="") {
			confirm new file `"`wlffname'"'
		}
		mata: st_local("postfwlf", `impobj'.postfwlf)
		qui postfile `postfwlf' long(iter) long(m) 		///
				    double(wlf)				///
				    using `"`wlffname'"', `wlfreplace'
	}
	// saveptrace()
	local savemcmc `"`saveptrace'"'
	if (`"`savemcmc'"'!="") {
		_savingopt_parse mcfilename mcreplace : ///
					saveptrace ".stptrace" `"`savemcmc'"'
		if ("`mcreplace'"=="") {
			confirm new file `"`mcfilename'"'
		}
	}
	// -savingparams()-
	local impsaving `"`savingparams'"'
	if (`"`impsaving'"'!="") {
		_savingopt_parse fname replace : ///
			savingparams ".dta" `"`impsaving'"'
		if ("`replace'"=="") {
			confirm new file `"`fname'"'
		}
		u_build_postnames "`ivars'" "`xlist'" "`noconstant'"
		local postnames `s(names)'
		mata: st_local("postfimp", `impobj'.postfimp)
		qui postfile `postfimp' long(iter) long(m) 		///
				    double(`postnames') 		///
				    double(wlf)				///
				    using `"`fname'"', `replace'
	}
	// prior()
	if (`"`prior'"'!="") {
		_chk_prior `prior'
		local prior `s(prior)'
		local priordf `s(priordf)'
		mata:  `impobj'.prior	= "`prior'" ;	///
			`impobj'.EM.prior	= "`prior'"
		if ("`priordf'"!="") {
			mata:	`impobj'.priordf	= `priordf'; ///
				`impobj'.EM.priordf	= `priordf'
		}
	}
	local emopts `emopts' ivars(`ivars') xvars(`xlist')
	if (`"`initmcmc'"'!="") {
		if (`"`inittype'"'=="em" | `"`inittype'"'=="") {
			local inittype em
			if (`"`initopts'"'=="") {
				local emopts , `emopts'
			}
			_chk_emopts `impobj' `initopts' `emopts'
		}
		else {
			di
 			di as txt "Using supplied initial values ..."
			u_mi_impute_initmat, `initmcmc' p(`p') q(`nxterms') ///
						name("{bf:initmcmc()}")
			mata:	`impobj'.Init.type = "user";		///
				`impobj'.Init.m0 = st_matrix("r(Beta)"); ///
				`impobj'.Init.S0 = st_matrix("r(Sigma)")
		}
	}
	else {
		_chk_emopts `impobj', `emonly1' `emopts'
		if ("`s(nolog)'"!="") {
			local emlog
		}
	}

	local opts `opts' burnin(`burnin') burnbetween(`burnbetween')
	local opts `opts' `initmcmc'
	mata: `impobj'.init_opts()

	// check if imputed vars are used as regressors
	local bad : list ivars & xvars
	if ("`bad'"!="") {
		local n : word count `bad'
		di as err "{p `errindent'}"			///
			  "{bf:`bad'}: cannot be used "		///
			  "as independent " 			///
			  plural(`n',"variable") "{p_end}"
		exit 198
	}
	// check if any registered imp. vars are used as regressors
	local imputed	`_dta[_mi_ivars]'
	local tochk : list imputed - ivars
	local bad : list tochk & xvars
	if ("`bad'"!="") {
		local n1: word count `bad'
		local n2: word count `ivars'
		di as txt "{p 0 6 2}note: " plural(`n1',"variable") 	/// 
			  " {txt:`bad'} registered as "		///
			  "imputed and used to model "		///
			  plural(`n2',"variable") 		///
			  " {txt:`ivars'}; this may cause "	///
			  "some observations to be omitted "  	///
			  "from the estimation and may lead "	///
			  "to missing imputed values{p_end}"	
	}
	// check if sufficient observations
	qui count if `touse'
	if (r(N)==0) {
		error 2000
	}
	else if (r(N)==1) {
		error 2001
	}
	// check if <ivars> have missing
	qui u_mi_ivars_musthave_missing nbadvars bad : ///
				"`ivars'" "`touse'" "nomissok" "`indent'"
	local ivarscmsg hasincomplete
	if (`nbadvars'==`p') {
		local ivarscmsg
		local nomiss nomiss
	}
	u_mi_impute_note_nomiss "`bad'" "`ivarscmsg'" "`nomissnote'"
	local ivarsinc : list ivars - bad
	if ("`nomiss'"!="" & "`emonly'"=="") {
		mata: `impobj'.setup("`ivars'","`touse'")
		sret clear
		sret local nomiss	"`nomiss'"
		sret local xeqmethod	"mvn"
		sret local ivars	"`ivars'"
		sret local ivarsinc	"`ivarsinc'"
		exit
	}
	if ("`emonly'`mcmconly'"!="") {
		qui recast `float'`double' `ivars'
		`dosort'
		if ("`noconstant'"=="") {
			tempvar one
			qui gen byte `one' = 1
		}
		mata: `impobj'.init("`ivars'","`xlist'","`one'","`touse'")
	}
	else { // for m=0 and m>0
		qui recast `float'`double' `ivars'
		`dosort'
		u_mi_getstubname mvn_one : "__mi_impute_mvn_one"
		u_mi_getstubname mvn_touse : "__mi_impute_mvn_touse"
		qui gen byte `mvn_one' = 1
		qui gen byte `mvn_touse' = `touse'
		local addedvars `mvn_one' `mvn_touse'
		mata: `impobj'.init("`ivars'","`xlist'", ///
				"`mvn_one'","`mvn_touse'")
		if ("`style'"=="mlong" | "`style'"=="flong") {
			qui replace `mvn_touse' = ///
						`mvn_touse'[_mi_id]
		}
	}
	if ("`dots'"=="") {
		local dots nodots
	}
	if ("`mcmconly'"=="") {
		sret clear
		sret local nomiss	"`nomiss'"
		sret local dots		"`dots'"
		sret local xeqmethod	"mvn"
		sret local ivars	"`ivars'"
		sret local ivarsinc	"`ivarsinc'"
		sret local cmdlineinit "`impobj'"
		sret local cmdlineimpute "`impobj'"
		sret local addedvars	"`addedvars'"
		exit
	}
	if ("`mcmconly'"!="") {
		mata: `impobj'.da_burnin(0, 1)
	}
	sret clear
	sret local nomiss	"`nomiss'"
	sret local xeqmethod	"mvn"
	sret local ivars	"`ivars'"
	sret local ivarsinc	"`ivarsinc'"
	sret local cmdlineinit	"`impobj'"
	sret local cmdlineimpute "`impobj'"
	sret local dots		"`dots'"
end

program _chk_emopts, sclass

	syntax anything(name=impobj) [, EMONLY1(string asis) NOLOG * ]
	local nolog_gl `nolog'
	if (`"`emonly1'"'!="") {
		local 0 , `emonly1' `options'
	}
	else {
		local 0 , `options'
	}

	syntax [,					///
			NOCONStant			/// //passthru
			ITERate(integer 100)		///
			TOLerance(real 1e-5)		///
			INIT(string)			///
			MISSing				///
			NOLOG				///
			SAVEPtrace(string asis)		///
			SAVINGPARAMS(string asis)	/// //undoc.
			NOCHECKPD			/// //passthru, undoc.
			SWEEP				/// //undoc.
			ivars(varlist)			/// //internal
			xvars(varlist fv)		/// //internal
	]
	if (`tolerance'<0) {
		di as err "{bf:tolerance()} must be a nonnegative number"
		exit 198
	}
	InitParse em, `init' name("init()")
	mata: `impobj'.EM.emInit.type = "`s(init)'"
	// saveptrace()
	if (`"`saveptrace'"'!="") {
		_savingopt_parse emcfilename emcreplace : ///
			saveptrace ".stptrace" `"`saveptrace'"'
		if ("`emcreplace'"=="") {
			confirm new file `"`emcfilename'"'
		}
	}
	// -savingparams()-
	if (`"`savingparams'"'!="") {
		_savingopt_parse fname replace : ///
			savingparams ".dta" `"`savingparams'"'
		if ("`replace'"=="") {
			confirm new file `"`fname'"'
		}
		u_build_postnames "`ivars'" "`xvars'" "`noconstant'"
		local postnames `s(names)'
		mata: st_local("postfem", `impobj'.EM.postfem)
		qui postfile `postfem' long(iteration)	 		///
				    double(`postnames') 		///
				    using `"`fname'"', `replace'
	}
	mata:`impobj'.EM.init_opts()
	sret local nolog "`nolog'`nolog_gl'"
end

program InitParse, sclass

	syntax [anything(name=method)] [, * ]
	if ("`method'"=="em") {
		local ADDOPTS ac cc
		local default ac
	}
	else if ("`method'"=="da") {
		local ADDOPTS em
		local default em
	}
	else {
		di as err "InitParse:  unknown method {bf:`method'}"
		exit 198
	}
	sret clear

	local 0 , `options' 
	syntax [,			///
			Betas(string)	///
			SDs(string)	///
			VARs(string)	///
			COV(string)	///
			CORR(string)	///
			`ADDOPTS'	///
			NAME(string) 	///
		  	* 		/// //options
		]

	if ("`name'"=="") {
		local name init()
	}

	if ("`options'"!="") {
		di as err as smcl "`name':  {bf:`options'} not allowed"
		exit 198
	}	
	local opts `betas'`sds'`cov'`corr'`vars'
	local addopts `cc'`ac'`em'

	if ("`addopts'`opts'"=="") {
		sret local init "`default'"
		exit 0
	}
	
	if ("`addopts'"!="") {
		if ("`cc'"!="" & "`ac'"!="") {
			di as err as smcl ///
				"`name':  {bf:cc} and {bf:ac} cannot " ///
				"be combined"
			exit 198
		}
		if ("`opts'"!="") {
			di as err as smcl ///
				"`name':  {bf:`addopts'} cannot be " ///
				"combined with other {bf:`name'}'s suboptions"
			exit 198
		}
		sret local init "`addopts'"
		exit 0
	}
	if ("`cov'"!="" & ("`sds'`vars'`corr'"!="")) {
		di as err as smcl "`name':  {bf:cov()} cannot be "	///
		   "combined with {bf:sds()}, {bf:vars()} or {bf:corr()}"
		exit 198
	}
	if ("`sds'"!="" & "`vars'"!="") {
		di as err as smcl "`name':  {bf:sds()} and {bf:vars()}" ///
			"cannot be combined"
		exit 198
	}
	sreturn local init "user"
end

program _chk_prior, sclass

	syntax [anything] [, df(string) ]

	local prior `anything'

	local n : word count `prior'
	if (`n'>1) {
		di as err "{bf:prior()}: only one of {bf:uniform}, "	///
			  "{bf:jeffreys}, or {bf:ridge} is allowed"
		exit 198
	}
	if ("`prior'"=="") {
		local prior uniform
	}
	local len = strlen("`prior'")
	if ("`prior'"==bsubstr("uniform",1,`len')) {
		if ("`df'"!="") {
			di as err 	///
			"{bf:prior()}: suboption {bf:df()} is not allowed " ///
				  "with {bf:uniform} or {bf:jeffreys}"
			exit 198
		}
		local prior uniform
	}
	else if ("`prior'"==bsubstr("jeffreys",1,`len')) {
		if ("`df'"!="") {
			di as err ///
		"{bf:prior()}: suboption {bf:df()} is not allowed " ///
				  "with {bf:uniform} or {bf:jeffreys}"
			exit 198
		}
		local prior jeffreys
	}
	else if ("`prior'"==bsubstr("ridge",1,`len')) {
		if ("`df'"=="") {
			di as err ///
			  "{bf:prior()}: suboption {bf:df()} is required " ///
				  "with {bf:ridge}"
			exit 198
		}
		else {
			cap confirm number `df'
			local rc1 = _rc
			if (`rc1' | `df'<0) {
di as err "{bf:prior()}: suboption {bf:df()} must contain nonnegative number"
exit 198
			}
			if (`df'>=2^28)	{
di as err "{bf:prior()}: degrees of freedom in {bf:df()} are too large; the maximum is 2^28"
exit 198
			}
		}
		local prior ridge
	}
	else {
		di as err "{bf:prior()}: {bf:`prior'} is not allowed"
		exit 198
	}

	sret clear
	sret local prior `prior'
	sret local priordf `df'
end

program _chk_ts
	syntax [varlist(default=none fv)]
end

program u_build_postnames, sclass
	args yvars xvars noconstant
	tokenize `yvars'
	local p: word count `yvars'
	forvalues i=1/`p' {
		local xlist `xvars'
		while ("`xlist'"!="") {
			gettoken var xlist: xlist
			local bnames `bnames' beta_``i''_`var'
		}
		if ("`noconstant'"=="") {
			local bnames `bnames' beta_``i''_cons
		}
		local cnames `cnames' var_``i''
		forvalues j=`=`i'+1'/`p' {
			local cnames `cnames' cov_``i''_``j''
		}
	}

	sret clear
	sret local names "`bnames' `cnames'"
end
