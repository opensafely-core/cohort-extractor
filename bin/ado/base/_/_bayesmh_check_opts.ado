*! version 1.2.3  13feb2019

program _bayesmh_check_opts, sclass 
	version 14.0
	syntax , [			///
		MCMCSize(string)	///
		BURNin(string)		///
		THINning(string)	///
		RSEED(passthru)		///
		EXCLude(passthru)	///
/* adaptation */			///
		ADAPTation(string)	///
		SCale(string)		///
		COVariance(passthru)	///
		NOSHOW(passthru)	///
		SHOW(passthru)		///
		CLEVel(passthru)	///
		Level(string)		///
		HPD			///
		BATCH(string)		///
		NODOTS			///
		DOTS			///
		DOTS1(string)		///
		DRYRUN			///
		NOTABle			///
		NOHEADer		///
		NOMODELSUMMary		///
		NOMESUMMary		///
		INITSUMMary		///
		NOEXPRession		///
		BLOCKSUMMary		///
		SAVing(passthru)	///
		NCHAINs(passthru)	///
		chainsdetail		///
		initall(passthru)	///
/* advanced */				///
		CORRLAG(string)		///
		CORRTOL(string)		///
		SEARCH(string)		///
/* supported display options */		///
		NOOMITted		///
		VSQUISH			///
		NOEMPTYcells		///
		BASElevels		///
		ALLBASElevels		///
		NOFVLABel		///
		FVWRAP(integer 1)	///
		FVWRAPON(passthru)	///
		NOLSTRETCH		///
		TITLE(passthru)		///
		EForm1(passthru) EForm 	///
		eformopts(string)	///
		NOGRoup			///
		melabel			///
		SHOWREffects 		///
		SHOWREffects1(passthru)	///
/* undocumented */			///
		NOECOV 			///
		NOTWOCOLHEADER		///
		KEEPINITial	 	///
		NOBURNin		///
		NOBURNin1(passthru)	///
		remargl			///
		haslvparams		///
		]

	local repopts `noshow' `show' `hpd' `dryrun' `notable' `noheader'
	local repopts `repopts' `nomodelsummary' `noexpression' `blocksummary'
	local repopts `repopts' `noomitted' `vsquish' `noemptycells' `baselevels' 
	local repopts `repopts' `allbaselevels' `nofvlabel' fvwrap(`fvwrap')
	local repopts `repopts' `fvwrapon' `nolstretch' `title' 
	local repopts `repopts' `noeqcov' `notwocolheader' `initsummary' 
	local repopts `repopts' `nogroup' `nomesummary' `melabel'
	local repopts `repopts' `showreffects' `showreffects1' `remargl'
	local repopts `repopts' `chainsdetail'

	local simopts `rseed' `saving' `exclude' `covariance' 
	local simopts `simopts' `keepinitial' `nchains' `initall'

	if "`nchains'" != "" & _caller() < 16 {
		di as err "option {bf:`nchains'} not allowed"
		exit 198
	}
	
	if "`nchains'" == "" & "`initall'" != "" {
		di as err "option {bf:`initall'} requires option {bf:nchains()} "
		exit 198
	}
	if "`nchains'" == "" & "`chainsdetail'" != "" {
		if e(nchains) == . {
			di as err "option {bf:`chainsdetail'} requires option {bf:nchains()}"
			exit 198
		}
		if e(nchains) != . & e(nchains) < 2 {
			di as err "option {bf:`chainsdetail'} requires at least 2 chains"
			exit 198
		}
	}
	
	if "`noshow'" != "" & "`show'" != "" {
		di as err "options {bf:`noshow'} and {bf:`show'} " ///
			"cannot be combined"
		exit 198
	}

	if "`showreffects'" != "" & "`showreffects1'" != "" {
		di as err "options {bf:`showreffects'} and {bf:`showreffects1'} " ///
			"cannot be combined"
		exit 198
	}

	if "`eformopts'" == "" {
		_get_eformopts, eformopts(`eform1' `eform' `or') allowed(eform or)
		local eformopts `eform1' `eform' `or'
	}
	if "`eformopts'" != "" {
		local repopts `repopts' eformopts(`eformopts')
	}

	if "`noburnin'" != "" {
		local burnin 0
	}
	if "`noburnin1'" != "" {
		local 0 ,`noburnin1'
		syntax , [NOBURNin1(real 0) *]
		local burnin 0
		local mcmcsize `noburnin1'
	}
	
	// check burnin()
	if (`"`burnin'"'!="") {
		cap confirm integer number `burnin'
		local rc = _rc
		if (!`rc') {
			if (`burnin'<0) {
				local rc 198
			}
		}
		if `rc' {
			di as err "{p}option {bf:burnin()} must contain "
			di as err "a nonnegative integer{p_end}"
			exit `rc'
		}
	}
	else {
		local burnin 2500
	}

	// check mcmcsize()
	if (`"`mcmcsize'"'!="") {
		cap confirm integer number `mcmcsize'
		local rc = _rc
		if (!`rc') {
			if (`mcmcsize'<=0) {
				local rc 198
			}
		}
		if `rc' {
			di as err "{p}option {bf:mcmcsize()} must contain "
			di as err "a positive integer{p_end}"
			exit `rc'
		}
	}
	else {
		local mcmcsize 10000
	}

	// check thinning()
	if (`"`thinning'"'!="") {
		local max = floor(`mcmcsize'/2)
		if (`max'<=0) {
			di as err "MCMC sample size must be larger " ///
				  "to use {bf:thinning()}"
			exit 198
		}
		cap confirm integer number `thinning'
		local rc = _rc
		if (!`rc') {
			if (`thinning'<=0) {
				local rc 198
			}
		}
		if `rc' {
			di as err "{p}option {bf:thinning()} must contain "
			di as err "a positive integer{p_end}"
			exit `rc'
		}
		_bayesmh_note_skip "`=(`thinning'-1)'" "`mcmcsize'" "storing"
	}
	else {
		local thinning 1
	}

	// check scale()
	if (`"`scale'"'!="") {
		_bayes_check_number `scale' "" 0 "." "<" ">" scale()
	}
	else {
		local scale 2.38
	}

	// check summary options common to bayesstats summary
	local summopts batch(`batch') `clevel' level(`level') `hpd' 
	local summopts `summopts' corrlag(`corrlag') corrtol(`corrtol')
	local summopts `summopts' mcmcsize(`mcmcsize')
	_bayesmh_summaryopts `summopts'
	local clevel "`s(clevel)'"
	local hpd    "`s(hpd)'"
	if (`"`batch'"'!="") {
		local batch  "`s(batch)'"
	}
	else {
		local corrlag "`s(corrlag)'"
		local corrtol "`s(corrtol)'"
		// update maximum correlation lag based on specified MCMC size
		_bayesmh_chk_corrlag corrlag : `corrlag' `mcmcsize' nonote
	}

	// check search(); builds s(repeat)
	_check_search, `search'
	local repeat "`s(repeat)'"

	// check dots and dots()
	if ("`haslvparams'"!="" & `"`nodots'`dots'`dots1'"'=="") {
		local dots dots
	}
	_bayes_dot_options `"`nodots'"' `"`dots'"' `"`dots1'"'
	local dots `s(dots)'
	local dotsevery `s(dotsevery)'

	// check adaptation(); builds s(adaptation)
	_check_adaptation, `adaptation' 	///
			   mcmcsize(`mcmcsize') ///
			   burnin(`burnin') thinning(`thinning')

	// store results
	local simopts `simopts' burnin(`burnin') mcmcsize(`mcmcsize') 
	local simopts `simopts' thinning(`thinning') scale(`scale') 
	local simopts `simopts' dotsevery(`dotsevery') dots(`dots') 
	local simopts `simopts' search(`search') searchrepeat(`repeat')

	local repopts `repopts' corrtol(`corrtol') corrlag(`corrlag') 
	local repopts `repopts' batch(`batch') clevel(`clevel') 

	sret local simoptions `"`simopts'`repopts'"'
	sret local repoptions `"`repopts'"'
	sret local extraoptions `"`options'"'
end

program _check_search, sclass
	syntax [, ON OFF REPEAT(string) * ]
	if (`"`options'"'!="") {
		di as err "suboption {bf:`options'} is not allowed in " ///
			  "option {bf:search()}"
		exit 198
	}
	if (`"`repeat'"'!="") {
		_bayes_check_number `repeat' "integer" 0 "." "<" ">" search(repeat())
	}
	else {
		local repeat 500
	}
	if ("`off'"!="") {
		local repeat 0
	}
	sret local repeat "`repeat'"
end

program _check_adaptation, sclass
	syntax [,			///
		EVERY(string)		///
		MINITER(string)		///
		MAXITER(string)		///
		ALPHA(string)	  	///
		BETA(string)		///
		GAMMA(string)		///
		TARATE(string)		/// 
		TOLerance(string)	///
		EPSilon(string)		/// //undocumented
		MCMCSize(string)	/// //internal
		BURNin(string)		/// //internal
		THINning(string)	/// //internal
		*			///
	]
	if (`"`options'"'!="") {
		di as err "suboption {bf:`options'} is not allowed in " ///
			  "option {bf:adaptation()}"
		exit 198
	}
	local mcmctotal = `burnin'+(`mcmcsize'-1)*`thinning'+1
	// check every()
	if (`"`every'"'!="") {
		_bayes_check_number `every' "integer" 0 "`mcmctotal'" "<" ">" ///
			adaptation(every())
		local userevery `every'
	}
	else {
		local every 100
	}
	// check maxiter()
	if (`"`maxiter'"'!="") {
		_bayes_check_number `maxiter' "integer" 0 "." "<" ">" ///
			adaptation(maxiter())
		local usermaxiter `maxiter'
	}
	else {
		local maxiter 25
	}
	// check miniter()
	if (`"`miniter'"'!="") {
		if ("`usermaxiter'"!="") {
			local maxsize = `maxiter'
		}
		else {
			local maxsize .
		}
		_bayes_check_number `miniter' "integer" 0 "`maxsize'" "<" ">" ///
			adaptation(miniter())
		local userminiter `miniter'
	}
	else {
		local miniter 5
	}
	// check alpha()
	if (`"`alpha'"'!="") {
		_bayes_check_number `alpha' "" 0 1 "<" ">" adaptation(alpha())
	}
	else {
		local alpha 0.75
	}
	// check beta()
	if (`"`beta'"'!="") {
		_bayes_check_number `beta' "" 0 1 "<" ">" adaptation(beta())
	}
	else {
		local beta 0.8
	}
	// check gamma()
	if (`"`gamma'"'!="") {
		_bayes_check_number `gamma' "" 0 1 "<" ">" adaptation(gamma())
	}
	else {
		local gamma 0
	}
	// check tarate()
	if (`"`tarate'"'!="") {
		_bayes_check_number `tarate' "" 0 1 "<=" ">=" adaptation(tarate())
	}
	else {
		local tarate 0
	}
	// check tolerance()
	if (`"`tolerance'"'!="") {
		_bayes_check_number `tolerance' "" 0 1 "<=" ">=" ///
			adaptation(tolerance())
	}
	else {
		local tolerance 0.01
	}
	// check epsilon()
	if (`"`epsilon'"'!="") {
		_bayes_check_number `epsilon' "" 0 "." "<" ">" adaptation(epsilon())
		local beta 0 //reset beta() to be zero
	}
	else {
		local epsilon 0
	}

	// update default values based on specified mcmcsize() and burnin()
	if `"`userevery'"' == "" {
		if `maxiter' > 0 {
			if `every' > `mcmctotal' {
				local every `mcmctotal'
				di as txt ///
		"note: option {bf:adaptation(every())} changed to `mcmctotal'"
			}
		}
	}
	if `"`usermaxiter'"' == "" {
		if `every' > 0 {
			local maxiter = max(`maxiter',floor(`burnin'/`every'))
		}	
	}
	local maxitersize = floor((`mcmctotal')/`every')
	if `maxiter' > `maxitersize' {
		local maxiter `maxitersize'
		di as txt "note: option {bf:adaptation(maxiter())} changed " ///
			"to `maxitersize'"
	}
	if `"`userminiter'"' == "" {
		local miniter = min(`miniter',`maxiter')
	}

	// store results
	local adaptopts every(`every') maxiter(`maxiter') miniter(`miniter')
	local adaptopts `adaptopts' alpha(`alpha') beta(`beta') gamma(`gamma') 
	local adaptopts `adaptopts' tarate(`tarate') tolerance(`tolerance')
	local adaptopts `adaptopts' epsilon(`epsilon')
	sret local adaptation `"`adaptopts'"'
end