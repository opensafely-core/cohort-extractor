*! version 1.2.6  08jan2020
program _me_estimate, sortpreserve eclass prop(or irr mi)
	version 13
	local vv : di "version " string(_caller()) ", missing:"

	gettoken bytouse 0 : 0
	local byvar : length local bytouse
	if `byvar' {
		confirm var `bytouse'
	}

	local 0_orig `0'

	_parse expand EQ opt : 0, common(streg)
	local neq = `EQ_n'
	local gopts `opt_op'

	local is_st : list posof "streg" in gopts

	local ife 0
	local ire 1
	forval i = 1/`neq' {
		if strpos(`"`EQ_`i''"',":") == 0 {
			if `ife' {
				di as err ///
				"only one fixed-effects equation allowed"
				exit 198
			}
			local eq_1 : copy local EQ_`i'
			local ife `i'
		}
		else {
			local ++ire
			local eq_`ire' : copy local EQ_`i'
		}
	}

	_parse_fe `eq_1'
	local f_p	`"`s(f_p)'"'
	local fe_eq	`"`s(fe_eq)'"'
	local ifin	`"`s(ifin)'"'
	local c_opt	`"`s(c_opt)'"'
	local off	`"`s(off)'"'
	local opts	`"`s(opts)'"'
	local fwt 0
	local iwt 0
	local pwt 0
	if "`s(wtype)'" != "" {
		if "`s(wtype)'" == "fweight" {
			local fwt 1
		}
		if "`s(wtype)'" == "iweight" {
			local iwt 1
		}
		if "`s(wtype)'" == "pweight" {
			local pwt 1
		}
		local wexp_0 `"`s(wexp)'"'
	}

	if `is_st' {
		local 0 `f_p' `ifin' , `off'
	}
	else {
		local 0 `ifin' , `off'
	}
	syntax [varlist(ts fv default=none)] [if] [in] ///
		[, OFFset(varname) EXPosure(varname)]
	marksample touse
	if "`offset'`exposure'" != "" {
		markout `touse' `offset' `exposure'
	}
	if `byvar' {
		qui replace `touse' = 0 if !`bytouse'
	}

	local Rremap 0
	Check4Rremap `Rremap' `eq_1'
	local k_re 0
	local oldd
	Check4Rremap `Rremap' , `opt_op'
	forvalues i = 2/`neq' {
		if strpos(`"`eq_`i''"',":") == 0 {
			di as err "only one fixed-effects equation allowed"
			exit 198
		}
		gettoken d rest : eq_`i', parse(":")
		if `"`d'"' != "_all" {
			capture unab d : `d'
		}
		if `"`d'"' != `"`oldd'"' {
			local ++k_re
			local oldd : copy local d
		}
		gettoken d rest : rest, parse(":")
		Check4Rremap `Rremap' `rest'
		if `Rremap' == 1 {
			continue, break
		}
	}
	if `k_re' == 1 {
		local Rremap 0
	}

	// figure out the structure of random effects
	// save this information in local "labels"

	forvalues i = 2/`neq' {
		gettoken d rest : eq_`i', parse(":")
		if `:list sizeof d' > 1 {
			di as err "{bf:`d'} invalid level specification"
			exit 198
		}
		gettoken COLON 0 : rest, parse(" :")
		if `"`COLON'"' == "" {
			di as err "nothing found where colon {bf::} expected"
			exit 198
		}
		else if `"`COLON'"' != ":" {
			di as err "{bf:`COLON'} found where colon {bf::} expected"
			exit 198
		}
		syntax [anything(name=xs)] [ , noCONstant * ]
		local has_r = bsubstr("`xs'",1,2)=="R."
		if `has_r' {
			if `: list sizeof xs' > 1 {
				di as err "{bf:`xs'} invalid level " ///
					"specification"
				exit 198
			}
			local has_r 1
			local xs : subinstr local xs "R." ""
			capture unab xs : `xs'
			local rdots `rdots' `xs'
		}

		local rlist `rlist' `has_r'

		local all = "`d'"=="_all"
		if !`all' {
			unab d: `d'
		}

		if `has_r' {
			if `all' local levels `levels' _all
			else local levels `levels' `d'
			if `Rremap' {
				local labels `labels' `d'
			}
			else {
				local labels `labels' `d'>`xs'
			}
		}
		else {
			if `all' {
				local levels `levels' _all
				local labels `labels' _all
			}
			else {
				local levels `levels' `d'
				local labels `labels' `d'
			}
		}

		if "`constant'"=="" {
			local cons constant
		}
		else {
			local cons `constant'
		}
		local consinfo `consinfo' `cons'
	}

	gettoken first rest : levels
	if `: list posof "_all" in rest' {
		if "`first'" != "_all" {
			di as err "_all cannot be nested within levels"
			exit 198
		}
	}

	if `: list sizeof labels' > 1 {
	    mata: _me_make_labels("`levels'","`labels'","`consinfo'","`rlist'")
	}

	foreach name of local levels {
		gettoken name : name, parse(">")
		local newlevels `newlevels' `name'
	}
	local levels : copy local newlevels
	mata: _me_check_levels("`levels'")

	// loop through the equations again, this time more thoroughly

	local imp_cns 0
	local req 1
	local reqix 1
	local ix 1
	local iw 0
	forvalues i = 2/`neq' {
		local lab : word `req' of `labels'
		local cons : word `req' of `consinfo'
		if "`cons'"=="constant" {
			local cons
		}
		local ++req
		local reqlist `reqlist' `reqix'
		local ++reqix
		gettoken d rest : eq_`i', parse(":")
		local 0 `eq_`i''
		syntax anything [, noCONstant * ]
		local eq_`i' `anything' , `options'
		`vv' ///
		_parse_re `touse' `Rremap' `eq_`i'' ix(`ix') lab(`lab') `cons'
		local re_eq `re_eq' `s(re_eq)'
		local re_cov`i' `s(re_cov)'
		local covs `covs' `s(re_cov)'
		local imp_cns = `s(imp_cns)' | `imp_cns'
		local latent `latent' `s(latent)'
		local revars `revars' `s(revars)'
		local redim `redim' `s(redim)'
		local opts `opts' `s(opts)'
		local ix `s(ix)'
		if !`:list lab in wlabels' {
			local ++iw
			local wlabels `wlabels' `lab'
		}
		if "`s(wtype)'" != "" {
			if "`s(wtype)'" == "fweight" {
				local fwt 1
			}
			if "`s(wtype)'" == "iweight" {
				local iwt 1
			}
			if "`s(wtype)'" == "pweight" {
				local pwt 1
			}
			if `"`wexp_`iw''"' != "" {
				ErrMultWeights
			}
			local wexp_`iw' `"`s(wexp)'"'
		}
	}

	ErrMixedWeights, fw(`fwt') pw(`pwt') iw(`iwt')
	local wtype `s(wtype)'

	// extra check for weights for mestreg
	local st_note 0
	if `is_st' {
		local st_wt : char _dta[st_wt]
		local st_wv : char _dta[st_wv]
		if !missing("`st_wt'") local st_note 1
	}

	// final check for blocked-diagonal covariance structures
	if `neq'>2 {
		// creates macro: extracovs
		mata: _me_chk_blockdiag("`labels'",`neq')
	}

	local re_eq : list uniq re_eq
	local k_r : list sizeof re_eq

	// process common options

	_parse_opts , `opts' `gopts'
	local from `s(from)'
	local title `s(title)'
	local model `s(model)'
	local fname `s(fname)'
	local lname `s(lname)'
	local has_cns `s(has_cns)'
	local binom `s(binomial)'
	local disper `s(dispersion)'
	local family `s(family)'
	local intmethod `s(intmethod)'
	local intpoints `s(intpoints)'
	local link `s(link)'
	local 0 `s(opts)'
	_get_diopts diopts rest, `0'
	local 0 , `rest'

	syntax [, ESTMetric1(string) BINomial(string) Dispersion(passthru) ///
		noRETable noFETable noTABle noLRtest noGRoup noHEADer ///
		NOLOg LOg ///
		nohr TRatio or irr eform EFORM1(string) * ]

	_chk_model_diopts, model(`model') `or' `irr'
	if "`retable'`fetable'" != "" local table notable
	if "`irr'" != "" local eform eform(IRR)
	local diopts `diopts' `table' `lrtest' `group' `header' `log' ///
		`nolog' ///
		`or' `eform'
	local opts `options'

	local latent : list uniq latent

	if `is_st' {
		qui replace `touse' = 0 if !_st
		qui stdescribe if `touse'
		if `r(t0_max)' | `r(N_gap)' {
			di as err "delayed entries or gaps not allowed"
			exit 498
		}
	}

	if "`fname'"=="ordinal" & "`c_opt'"!="" {
		di as err "option {bf:`c_opt'} not allowed "	///
			"with {bf:`fname'} family"
		exit 198
	}

	if "`wtype'" != "" {
		local PROD
		forval i = 1/`iw' {
			if `"`wexp_`i''"' != "" {
				local wtlist `wexp_`i'' `wtlist'
				local margwexp `"`margwexp'`PROD'`wexp_`i''"'
				local PROD "*"
			}
			else {
				local wtlist _cons `wtlist'
			}
		}
		if `"`wexp_0'"' != "" {
			tempname wvar
			cap gen double `wvar' = `wexp_0' if `touse'
			if c(rc) {
				di as err "weight expression invalid"
				exit 111
			}
			local wtlist `wvar' `wtlist'
			local margwexp `"`margwexp'`PROD'(`wexp_0')"'
		}
		else {
			local wtlist _cons `wtlist'
		}
		local wtopt `wtype'(`wtlist')
	}

	if "`rdots'" != "" {
		local rdots rdots(`rdots')
	}

	local cmdargs gsem `fe_eq' `re_eq'
	local cmdopts	`extracovs'		///
			`opts'			///
			`wtopt'			///
			`log'			///
			`nolog'			///
			`from'			///
			`rdots'			///
			mecmd			///
			latent(`latent')	///
			nocapslatent

	local cmd `cmdargs' if `touse' , `cmdopts'
	local cmd2 `cmdargs' `ifin' , `cmdopts'
	local cmd2 : list clean cmd2

	// call gsem

	`vv' `cmd' notable noheader nocnsreport

	capture test [#1]
	if _rc	local k_f 0
	else	local k_f `r(df)'

	// manipulate the ereturn list here

	// ereturns matrices N_g, g_min, g_avg, and g_max
	if `fwt' {
		local wopt : copy local wtlist
	}
	_group_info `"`levels'"' `"`wopt'"'

	// scalars for LR test
	if `k_r' {
		ereturn scalar chi2_c = 2*(e(ll) - e(ll_c))
		if e(chi2_c) < 0 {
			ereturn scalar chi2_c = 0
		}
		ereturn scalar df_c = e(rank) - e(rank_c)
		ereturn scalar p_c = chi2tail(e(df_c),e(chi2_c))
		if e(df_c) == 1 & e(chi2_c) > 1e-5 {
			ereturn scalar p_c = 0.5*e(p_c)
		}
	}

	if `"`e(offset1)'"' != "" {
		ereturn local offset = `"`e(offset1)'"'
		ereturn hidden local offset1 = `"`e(offset)'"'
	}
	ereturn hidden scalar has_cns = `has_cns' | `imp_cns'
	ereturn hidden local revars `revars'
	ereturn hidden local redim `redim'
	ereturn hidden local labels `labels'

	ereturn local ivars `levels'

	tempname b_pclass
	mat `b_pclass' = e(b_pclass)
	ereturn hidden matrix b_pclass `b_pclass'

	if "`e(intmethod)'"=="laplace" ereturn local n_quad
	else ereturn local n_quad `e(n_quad)'

	if "`wtype'" != "" {
		// -me- fixup for the obs-level weight expression
		if `"`wexp_0'"' != "" {
			ereturn local wtype "`wtype'"
			ereturn local wexp "= `wexp_0'"
		}
		else if `"`e(wexp_robust)'"' != "" {
			ereturn local wtype "`wtype'"
			ereturn local wexp "= _cons"
		}
		else {
			ereturn local wtype
			ereturn local wexp
		}
		local dsvars `"`e(datasignaturevars)'"'
		local dsvars : list dsvars - wvar
		if "`dsvars'" != "" {
			signestimationsample `dsvars'
		}
		if inlist(`"`margwexp'"', "", `"(`wexp_0')"') {
			ereturn local marginswtype
			ereturn local marginswexp
		}
		else if `"`wexp_0'"' != "" {
			ereturn local marginswtype "`wtype'"
			ereturn local marginswexp `"= `margwexp'"'
		}
	}
	ereturn hidden scalar st_note = `st_note'

	ereturn local marginsnotok	stdp		///
					reffects	///
					scores

	ereturn scalar k_f = `k_f'
	ereturn scalar k_r = `k_r'

	ereturn local estat_cmd meglm_estat
	ereturn local predict meglm_p

	ereturn local model `model'
	ereturn local family `fname'
	ereturn local dispersion `disper'
	ereturn local binomial `binom'

	ereturn local title `title'

	ereturn local cmd gsem
	ereturn hidden local cmdline2 `cmd2'

	capture ereturn hidden scalar k_autoCns = e(k_autoCns)
	capture ereturn hidden scalar rank_c = e(rank_c)
	ereturn hidden local footnote `e(footnote)'
	ereturn hidden local method `e(method)'

	ereturn local cmd2 meglm
	ereturn local cmdline meglm `0_orig'

	local iccfam	// empty
	if e(xtcmd) == 0 {
		local iccfam bernoulli binomial ordinal
	}

	if `:list fname in iccfam' {
		if "`lname'" == "logit" {
			ereturn hidden local iccok "ok"
			ereturn hidden local icctype logit
		}
		if "`lname'" == "probit" {
			ereturn hidden local iccok "ok"
			ereturn hidden local icctype probit
		}
		if "`lname'" == "cloglog" {
			ereturn hidden local iccok "ok"
			ereturn hidden local icctype cloglog
		}
	}
	if "`fname'" == "gaussian" & "`lname'" == "identity" {
		ereturn hidden local iccok "ok"
		ereturn hidden local icctype linear
	}

end

program Check4Rremap
	gettoken Rremap 0 : 0
	if `Rremap' == 1 {
		exit
	}
	capture syntax [anything] [if] [in] [fw pw iw] ///
		[, INTMethod(string) INTPoints(string) *]
	if c(rc) {
		exit
	}
	local len = strlen(`"`intmethod'"')
	if `len' == 0 {
		if strlen(`"`intpoints'"')  == 0 {
			exit
		}
	}
	else if substr("laplace",1,min(3,`len')) != `"`intmethod'"' {
		c_local Rremap 1
	}
	if !inlist("`intpoints'", "", "1") {
		c_local Rremap 1
	}
end

program _parse_fe, sclass

	quietly ///
	syntax anything [if] [in] [fw pw iw/] [ , noCONstant	///
		OFFset(passthru) EXPosure(passthru)		///
		FWeight(string)					///
		PWeight(string)					///
		IWeight(string)					///
		AWeight(string)					///
		*						///
	]

	if `"`pweight'"' != "" {
		di as error						///
		"option pweight() not allowed with fixed-effects equation"
		exit 198
	}
	if `"`fweight'"' != "" {
		di as error						///
		"option fweight() not allowed with fixed-effects equation"
		exit 198
	}
	if `"`iweight'"' != "" {
		di as error						///
		"option iweight() not allowed with fixed-effects equation"
		exit 198
	}
	if `"`aweight'"' != "" {
		di as error						///
		"option aweight() not allowed"
		exit 198
	}

	fvunab anything : `anything'
	gettoken y x : anything
	tsunab y : `y'
	local fe_eq `y' <-`x'

	sreturn local f_p `y' `x'
	sreturn local fe_eq `fe_eq'
	sreturn local ifin `if' `in'
	sreturn local c_opt `constant'
	sreturn local off `offset' `exposure'
	sreturn local opts `constant' `offset' `exposure' `options'
	sreturn local wtype "`weight'"
	sreturn local wexp "`exp'"

end

program _parse_re, sclass
	version 13
	gettoken touse  0 : 0
	gettoken Rremap 0 : 0

	syntax [anything] [, noCONstant COVariance(string)	///
		lab(string) ix(integer 1) COLlinear 		///
		OFFset(passthru) EXPosure(passthru)		///
		FWeight(varname numeric)			///
		PWeight(varname numeric)			///
		IWeight(varname numeric)			///
		AWeight(varname numeric)			///
		*						///
	]

	if `"`aweight'"' != "" {
		di as error						///
		"option aweight() not allowed"
		exit 198
	}

	local fw = !missing(`"`fweight'"')
	local pw = !missing(`"`pweight'"')
	local iw = !missing(`"`iweight'"')
	ErrMixedWeights, fw(`fw') pw(`pw') iw(`iw')
	local wtype `s(wtype)'

	if "`offset'" != "" {
di as err "option {bf:`offset'} allowed only in the fixed-effects equation"
exit 198
	}
	if "`exposure'" != "" {
di as err "option {bf:`exposure'} allowed only in the fixed-effects equation"
exit 198
	}

	local hascons = "`constant'"==""
	local opts `options' `collinear'

	gettoken id covars : anything, parse(":")
	unab id : `id'

	local covars : subinstr local covars ":" ""
	local covars : list clean covars

	if bsubstr("`covars'",1,2)=="R." {
		if `: list sizeof covars' > 1 {
			di as err "`covars' invalid level specification"
			exit 198
		}
		local revars : copy local covars
		local rvar : copy local covars
		local has_r 1
		local hascons 1
		local covars
	}
	else {
		local has_r 0
		local 0 `covars'
		capture syntax [ varlist(numeric fv ts default=none) ]
		if _rc {
			di "{err}invalid {bf:`covars'}"
			exit 198
		}
		if "`s(fvops)'"=="true" {
			if _caller() < 16 {
				di as err ///
"{p 0 2 2}factor variables not allowed in random effects equations{p_end}"
				exit 198
			}
			fvexpand `varlist' if `touse', skipomitted
			local covars `"`r(varlist)'"'
		}
		else {
			local covars : copy local varlist
		}
		local revars : copy local covars
		if `hascons' {
			local revars `revars' _cons
		}
	}

	local nvars : list sizeof covars
	if `hascons' {
		local ++nvars
	}
	if `nvars'==0 & `has_r'==0 {
		di as err "random effects level {cmd:`id'} is empty"
		exit 198
	}
	local redim `nvars'

	foreach i of local covars {
		_ms_parse_parts `i'
		if r(type) == "variable" {
			_msparse __S`ix'[`lab']#c.`i'
		}
		else {
			_msparse __S`ix'[`lab']#`i'
		}
		local re_eq `re_eq' `r(stripe)'@1
		local re_cov `re_cov' __S`ix'[`lab']
		local latent `latent' __S`ix'
		local ++ix
	}

	if `has_r' & `Rremap' {
		local rvar : subinstr local rvar "R." "bn."
		fvexpand `rvar'
		local rvarlist `"`r(varlist)'"'
		foreach rvar of local rvarlist {
			local covars `covars' `rvar'
			local re_eq `re_eq' __S`ix'[`lab']#`rvar'@1
			local re_cov `re_cov' __S`ix'[`lab']
			local latent `latent' __S`ix'
			local ++ix
		}
		local covstruct covstruct(`re_cov', identity)
	}
	else if `hascons' {
		local covars `covars' __I[`lab']
		local re_eq `re_eq' __I[`lab']@1
		local re_cov `re_cov' __I[`lab']
		local latent `latent' __I
	}

	if "`re_eq'"=="" & `has_r'==0 {
		di as err "no random effects on level {cmd:`id'} found"
		exit 198
	}

	gettoken cov junk : covariance, parse("(")
	local 0 , `cov'
	capture syntax [, INDependent EXchangeable IDentity UNstructured ///
		FIXed PATtern]
	if _rc {
		di as err "covariance structure {bf:`cov'} invalid"
		exit 198
	}
	local cov `independent' `exchangeable' `identity' `unstructured' ///
		`fixed' `pattern'
	if "`cov'"=="" {
		if !`has_r' local covariance diagonal
	}
	if "`cov'"=="independent" {
		local covariance diagonal
	}

	if inlist("`cov'","fixed","pattern") local imp_cns 1
	else local imp_cns 0

	if !`has_r' {
		local covstruct covstruct(`re_cov', `covariance')
	}
	local opts `covstruct' `opts'
	sreturn local redim `redim'
	sreturn local revars `revars'
	sreturn local latent `latent'
	sreturn local re_eq `re_eq'
	sreturn local re_cov `re_cov'
	sreturn local opts `opts'
	sreturn local imp_cns `imp_cns'
	sreturn local ix `ix'

	sreturn local wtype `wtype'
	sreturn local wexp `"``wtype''"'
end

program _parse_opts, sclass

	syntax [anything] [, Family(string) Link(string) ///
		etitle(string) model(string) ///
		INTMethod(string) INTPoints(string) ///
		from(passthru) CONSTraints(passthru) streg 	///
		ul(string) ll(string) udepvar(string) * ]

	local opts `options' `constraints'
	local has_cns = !missing(`"`constraints'"')
	local is_st = !missing("`streg'")

if !`is_st' {
	local 0 `family'
	syntax [ anything ] [, * ]

	if "`options'"!="" {
		di as err "option family() invalid"
		exit 198
	}
	if (`=`: list sizeof anything'' > 2) {
		di as err "option family() invalid"
		exit 198
	}

	local opt : word 2 of `anything'
	local 0 : word 1 of `anything'
	local 0 , `0'
	syntax [, BErnoulli BInomial GAMma GAUssian NBinomial Ordinal Poisson]
	local fam `bernoulli'`binomial'`gamma'`gaussian'`nbinomial'`ordinal' ///
		`poisson'
	if "`fam'"=="" local fam gaussian

	// default links

	if "`link'"=="" {
		if "`fam'"=="gaussian" 	local link identity
		if "`fam'"=="gamma" 	local link log
		if "`fam'"=="bernoulli"	local link logit
		if "`fam'"=="binomial"	local link logit
		if "`fam'"=="ordinal"	local link logit
		if "`fam'"=="poisson"	local link log
		if "`fam'"=="nbinomial"	local link log
	}

	if !missing("`ul'`ll'") {
		local family `fam', lcensored(`ll') rcensored(`ul')
	}
	else if !missing("`udepvar'") {
		local family `fam', udepvar(`udepvar')
	}
	else local family `fam' `opt'
}
	local family family(`family')

	if "`intmethod'"!="" local intm intmethod(`intmethod')
	if "`intpoints'"!="" local intp intpoints(`intpoints')

	if `"`etitle'"'=="" local etitle "Mixed-effects GLM"

	// info for e(model)

	if "`fam'"=="gaussian" local model linear
	if "`fam'"=="gamma" local model gamma
	if "`fam'"=="bernoulli" | "`fam'"=="binomial" {
		if "`link'"=="logit" local model logistic
		else local model `link'
	}
	if "`fam'"=="ordinal" local model o`link'
	if "`fam'"=="poisson" local model Poisson
	if "`fam'"=="nbinomial" local model nbinomial

	// binomial trials/dispersion

	if "`fam'"=="binomial" {
		local binomial `opt'
		_me_chk_opts, binomial(`binomial')
		local binomial `s(binomial)'
	}
	if "`fam'"=="nbinomial" {
		local dispersion `opt'
		_me_chk_opts, dispersion(`dispersion') sret
		local dispersion `s(dispersion)'
	}

	local lin `link'
	local link link(`link')
	local opts `family' `link' `opts' `intm' `intp'

	sreturn local from `from'
	sreturn local opts `opts'
	sreturn local fname `fam'
	sreturn local lname `lin'
	sreturn local dispersion `dispersion'
	sreturn local binomial `binomial'
	sreturn local family `family'
	sreturn local link `link'
	sreturn local intmethod `intmethod'
	sreturn local intpoints `intpoints'
	sreturn local has_cns `has_cns'
	sreturn local title `etitle'
	sreturn local model `model'

end

program _group_info, eclass
	args levelvars wtvars

	// encode levels
	foreach nm of local levelvars {
		tempvar level
		if ("`nm'" == "_all")  local nm `one'
		local nms `nms' `nm'
		qui egen long `level' = group(`nms') if e(sample)
		local levnames `levnames' `level'
	}

	local levels : list uniq levnames
	local k : word count `levels'
	if `k' == 0 {
		exit
	}

	tempvar obsc
	qui gen byte `obsc' = 1 if e(sample)

	local kw : list sizeof wtvars
	if `kw' {
		local j = `kw'
		forval i = 1/`kw' {
			local wt`i' : word `j' of `wtvars'
			quietly replace `obsc' = `obsc' * `wt`i'' if e(sample)
			local --j
		}
	}

	tempname gmin gmax gavg Ng
	mat `Ng' = J(1,`k',0)
	mat `gmin' = J(1,`k',0)
	mat `gavg' = J(1,`k',0)
	mat `gmax' = J(1,`k',0)

	tempvar fw
	qui gen long `fw' = 1 if e(sample)
	local wopt [fw = `fw']

	forvalues i = 1/`k' {
		if `"`wt`i''"' != "" {
			qui replace `obsc' = `obsc' / `wt`i'' if e(sample)
			qui replace `fw' = `fw' * `wt`i'' if e(sample)
		}
		local w : word `i' of `levels'
		_group_stats `w' if e(sample) `wopt', obsvar(`obsc')
		mat `Ng'[1,`i'] = r(ng)
		mat `gmin'[1,`i'] = r(min)
		mat `gavg'[1,`i'] = r(avg)
		mat `gmax'[1,`i'] = r(max)
		local ++i
	}
	ereturn matrix N_g `Ng'
	ereturn matrix g_min `gmin'
	ereturn matrix g_avg `gavg'
	ereturn matrix g_max `gmax'

end

program _group_stats, rclass

	syntax name [fw] [if], obsvar(varname)
	marksample touse

	if "`namelist'" == "_all" {
		tempvar one
		qui gen byte `one' = 1 if `touse'
		local namelist `one'
	}
	if "`weight'" != "" {
		local wopt [`weight'`exp']
	}
	tempname T
	qui {
		bysort `touse' `namelist': ///
		    gen double `T' = cond(_n==_N,sum(`obsvar'),.) if `touse'
		sum `T' `wopt' if `touse', mean
	}
	return scalar ng = r(N)
	return scalar min = r(min)
	return scalar max = r(max)
	return scalar avg = r(mean)

end

program _chk_model_diopts
	syntax [, model(string) or irr]

	if !missing("`or'") {
		if !inlist("`model'","logistic","ologit") {
			di as err "option {bf:or} not allowed"
			exit 198
		}
	}
	if !missing("`irr'") {
		if !inlist("`model'","nbinomial","Poisson") {
			di as err "option {bf:irr} not allowed"
			exit 198
		}
	}
end

program ErrMixedWeights, sclass
	syntax [, fw(integer 0) pw(integer 0) iw(integer 0)]

	local bad = (`fw'>0) + (`pw'>0) + (`iw'>0)

	if `bad' < 2 {
		if `fw' sreturn local wtype fweight
		if `iw' sreturn local wtype iweight
		if `pw' sreturn local wtype pweight
		exit
	}
	if `bad'==2 {
		if `fw' local names fweights
		if `iw' local names `names' iweights
		if `pw' local names `names' pweights
		gettoken w1 w2 : names
		local names = itrim("`w1' and `w2'")
	}
	if `bad'==3 {
		local names "fweights, iweights, and pweights"
	}

	di as err "only one weight type allowed;"
	di as err "you specified `names'"
	exit 198
end

program ErrMultWeights
	di as err "{p 0 4 2}you cannot have "
	di as err "multiple weight specifications "
	di as err "within the same model level"
	di as err "{p_end}"
	exit 198
end

exit
