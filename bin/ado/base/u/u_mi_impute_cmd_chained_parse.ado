*! version 1.0.3  09may2017
program u_mi_impute_cmd_chained_parse, sclass
	local version : di "version " string(_caller()) ":"
	version 12
	_parse comma lhs rhs : 0
	local 0 `rhs'
	syntax,		impobj(string)		/// //internal
		[				///
			BURNin(string)		///
			CHAINONLY		///
			init(string)		///
			NOIsily			///
			CHAINDOTS		///
			DOTS			///
			SHOWEvery(string)	///
			SHOWIter(string)	///
			FORCE			///
			SAVETRACE(string asis)	///
			Custom			/// //not allowed
			MONITOR			/// //undoc. 
			customchained		/// //undoc.
			itererrok		/// //undoc.
			ifgroup(string asis)	/// //undoc. 
			*			///
		]
	if ("`custom'"!="") {
		di as err "option custom not allowed"
		exit 198
	}
	if ("`customchained'"!="") {
		local customchained custom
	}
	local chainopts ifgroup(`ifgroup') `options' `customchained'
	if (`"`burnin'"'=="") {
		local burnin 10
	}
	else {
		cap confirm integer number `burnin'
		if _rc {
			di as err "{bf:burnin()} must be a nonnegative integer"
			exit 198
		}
		if (`burnin'<0) {
			di as err "{bf:burnin()} must be a nonnegative integer"
			exit 198
		}
	}
	if (`"`showiter'"'!="") {
		if (`"`showevery'"'!="") {
			di as err "only one of {bf:showiter()} or "	///
				  "{bf:showevery()} is allowed"
			exit 198
		}
		cap numlist "`showiter'", integer range(>=0 <=`burnin') sort
		if _rc {
			di as err "{bf:showiter()} must contain integer " ///
				  "numbers between 0 and `burnin', inclusive"
			exit 198
		}
		local showiter `r(numlist)'
		local showiter : list uniq showiter
	}
	else if (`"`showevery'"'!="") {
		cap confirm integer number `showevery'
		if _rc {
			di as err "{bf:showevery()} must contain positive " ///
				  "integer number not exceeding `burnin'"
			exit 198
		}
		if (`showevery'<=0 | `showevery'>`burnin') {
			di as err "{bf:showevery()} must contain positive " ///
				  "integer number not exceeding `burnin'"
			exit 198
		}
		qui numlist "`showevery'(`showevery')`burnin'", sort
		local showiter `r(numlist)'
	}
	else if ("`noisily'"!="") {
		qui numlist "0/`burnin'", sort
		local showiter `r(numlist)'
	}
	if (`"`init'"'=="") {
		local init monotone
	}
	else if !inlist(`"`init'"',"monotone","random") {
		di as err "only {bf:init(monotone)} or {bf:init(random)} is allowed"
		exit 198
	}
	// -savetrace()-
	if (`"`savetrace'"'!="") {
		if (`"`ifgroup'"'!="") {
			di as err "{bf:savetrace()} is not allowed in combination with {bf:by()}"
			exit 198
		}
		gettoken lsave rsave : savetrace, parse(" ,")
		_parse_savetrace_opts rsave detail vtype : `"`rsave'"'
		if ("`vtype'"=="") {
			local vtype float
		}
		_savingopt_parse tracefname tracereplace : ///
			savetrace ".dta" `"`"`lsave'"', `rsave'"'
		if ("`tracereplace'"=="") {
			confirm new file `"`tracefname'"'
		}
	}
	
	sret clear
	`version' u_mi_impute_sequential_parse `lhs', impobj(`impobj') ///
					`noisily' `chainopts' ///
					methodname(chained)
	if ("`showiter'`showevery'"=="" & "`s(noisily)'"!="") {
		qui numlist "0/`burnin'", sort
		local showiter `r(numlist)'
		local noisily noisily
	}
	else if ("`showiter'`showevery'"!="" & "`s(noisily)'`noisily'"=="") {
		di as err ///
		   "{bf:showiter()} or {bf:showevery()} requires {bf:noisily}"
		di as err "{p 4 4 4}You can specify {bf:noisily} with"
		di as err "{bf:mi impute chained} or within univariate"
		di as err "conditional model specifications{p_end}"
		exit 198
	}
	if "`s(domonotone)'"=="1" {
		local burnin 0
		local init monotone
	}
	sret local xeqmethod	"chained"

	local k_eq : word count `s(ivarsincord)'
	if (`"`savetrace'"'!="" & "`s(nomiss)'"=="") {
		local ind 1
		local ivarnames `s(ivarsincord)'	//ordered
		foreach ivar in `ivarnames' {
			local len = strlen("`ivar'", 27)
			if (`len'>27) {
				local ivar _mi_`ind'
				local ++ind
			}
			local postnames `postnames' `vtype'(`ivar'_mean)
			local postnames `postnames' `vtype'(`ivar'_sd)
			if ("`detail'"!="") {
				local postnames `postnames' `vtype'(`ivar'_min) 
				local postnames `postnames' `vtype'(`ivar'_p25) 
				local postnames `postnames' `vtype'(`ivar'_p50) 
				local postnames `postnames' `vtype'(`ivar'_p75) 
				local postnames `postnames' `vtype'(`ivar'_max) 
			}
		}
		local tracepostfile __mi_imp_tracepostfname
		qui postfile `tracepostfile' long(iter) long(m) `postnames' ///
					using `"`tracefname'"', `tracereplace'
	}
	mata:  `impobj'.setup(`burnin',"`init'",`"`tracepostfile'"', ///
		`"`tracefname'"',"`s(incordid)'")
	if ("`s(nomiss)'"!="") exit

	sret local cmdlineinit `""`impobj'" "`noisily'" "`dots'" "`chaindots'""'
	sret local cmdlineimpute `""`impobj'" "`s(ivarsincord)'" "`force'" "`noisily'" "`showiter'" "`k_eq'" "`burnin'" "`init'" "`chaindots'" "`chainonly'" "`monitor'" "`tracepostfile'" "`detail'" "`itererrok'""'
end

program _parse_savetrace_opts
	args opts todetail todouble colon rhs
	local 0 `rhs'
	syntax [, detail double * ]
	c_local `todetail' `detail'
	c_local `todouble' `double'
	c_local `opts' `options'
end
