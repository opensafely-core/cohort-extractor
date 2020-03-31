*! version 1.0.13  24sep2018
program fmm, eclass byable(onecall) prop(svyg svyj svyb)
	version 15
	local vv : di "version " string(_caller()) ", missing:"

	if _by() {
		local by "by `_byvars'`_byrc0':"
	}

	capture _on_colon_parse `0'
	if c(rc) | `"`s(after)'"' == "" {
		if !c(rc) {
			local 0 `"`s(before)'"'
		}
		if replay() {
			if "`e(prefix)'" != "fmm" {
				error 301
			}
			`vv' gsem `0'
			exit
		}
	}
	
	`vv' `by' Estimate `0'

	ereturn local cmdline `"fmm `0'"'
end

program Estimate, sortpreserve eclass byable(recall)
	version 15
	local vv : di "version " string(_caller()) ", missing:"

	local 0_orig : copy local 0
	
	if _by() {
		tempname bytouse
		mark `bytouse'
	}
	
	_on_colon_parse `0'
	local 0 `"`s(before)'"'
	local after `"`s(after)'"'

	syntax [anything(name=first)] [if] [in] [fw pw iw] [,*]
	
	if `: list sizeof first' > 1 {
		di as err "invalid {bf:`first'}"
		exit 198
	}
	
	if "`weight'" != "" {
		local wopt [`weight'`exp']
	}
	
	capture confirm number `first'
	if !_rc {
		capture assert `first' > 0
		local rc1 = _rc
		capture assert `first' == int(`first')
		local rc2 = _rc
		if `rc1' | `rc2' {
			di as err "invalid {bf:fmm} #; # must be an integer > 0"
			exit 198
		}
		local 0 `if' `in' `wopt', `options'
		local hybrid 0
	}
	else {
		local hybrid 1
	}
	
	local glopts : copy local 0
	
	// if not hybrid, rewrite as hybrid
	local after = trim(`"`after'"')
	if !`hybrid' {
		if substr(`"`after'"',1,1) == "(" {
			di as err "parentheses not allowed " ///
				"with {bf:fmm} #{bf::} syntax"
			exit 198
		}

		local 0 `after'
		gettoken model 0 : 0
		syntax anything [fw iw pw] [if] [in] [, *]
		local iff : copy local if
		local inn : copy local in
		if "`weight'" != "" {
			local weightt `weight'
			local expp : copy local exp
		}
		
		local after `model' `anything', `options'		
		
		local models = `first'*`"(`after')"'
	}
	else {
		local paren = substr(`"`after'"',1,1)
		if "`paren'" != "(" {
			di as err "invalid syntax"
			di as err "You must specify"
			di as err _col(2) "{bf:fmm} #{bf::} {it:component}"
			di as err "or"
			di as err _col(2) "{bf:fmm:}"	///
				" {bf:(}{it:component_1}{bf:)}" ///
				" {bf:(}{it:component_2}{bf:)} ..."
			exit 198
		}
		local models : copy local after
	}

	_parse expand eq opt : models
	local neq = `eq_n'
	
	if `"`opt_op'"' != "" {
		di as err `"option {bf:`opt_op'} not allowed"'
		exit 198
	}
	
	// parse fmm prefix options
	local 0 `glopts'
	syntax [if] [in] [fw pw iw] [, LCPRob(string) ///
		LCBase(numlist >0 integer max=1) LCLabel(string) ///
		LCINVariant(string) COLlinear ASIS *]
	
	if `"`if'"' != "" & `"`iff'"' != "" {
		di as err "too many if conditions specified"
		exit 198
	}
	if `"`if'"' == "" {
		local if : copy local iff
	}
	
	if "`in'" != "" & "`inn'" != "" {
		di as err "too many in conditions specified"
		exit 198
	}
	if `"`in'"' == "" {
		local in : copy local inn
	}

	if "`weight'" != "" & "`weightt'" != "" {
		di as err "weights specified too many times"
		exit 198
	}
	if "`weight'" == "" {
		local weight `weightt'
		local exp : copy local expp
	}
	
	if "`lcbase'" == "" {
		local lcbase 1
		local hasbase 0
	}
	else local hasbase 1
	
	if `lcbase' < 1 | `lcbase' > `neq' {
		di as err "{bf:lcbase()} has to be an integer " ///
			"between 1 and `neq'"
		exit 198
	}
	
	if `"`lclabel'"' == "" local C Class
	else local C `lclabel'
	
	marksample touse
	if _by() {
		qui replace `touse' = 0 if !`bytouse'
	}
	
	local hasprob 0
	local n_prob 0
	local n_pmass 0
	forvalues i = 1/`neq' {
		MakeEq "`touse'" "`i'" `"`C'"' `eq_`i''
		local eqs `eqs' `s(eq)'
		local covs `covs' `s(cov)'
		local hasprob = `hasprob' | `s(hasprob)'
		local n_prob = `n_prob' + `s(hasprob)'
		local asis `asis' `s(asis)'
		local collinear `collinear' `s(collinear)'
		if "`ix_noprob'" == "" & !`s(hasprob)' {
			local ix_noprob `i'
		}
		local n_pmass = `n_pmass' + `s(pmass)'
		if "`st_wt'"=="" local st_wt `s(st_wt)'
	}

	if `n_pmass' == `neq' {
		di as err "{bf:pointmass} must be combined with another " ///
			"fmm {it:{help fmm_estimation:model}}"
		exit 198
	}
	
	// update lcbase if needed
	if !`hasbase' & `n_prob' < `neq' {
		local lcbase `ix_noprob'
	}
	
	if `"`lcprob'"' != "" & `hasprob' {
		di as err "global {bf:lcprob()} not allowed with " ///
			"component {bf:lcprob()}"
		exit 198
	}
	
	if `hasbase' | !`hasprob' {
		if `"`lcprob'"' == "" local lcprob "_cons"
		local preq `preq' (i.`C' <- `lcprob')
	}
	
	if "`weight'" != "" & "`st_wt'" != "" {
		di as err "weights not allowed; weights are already {bf:stset}"
		exit 101
	}
	
	if "`weight'" != "" {
		local wopt [`weight'`exp']
	}
	else if "`st_wt'" != "" {
		local wopt `st_wt'
	}
	else local wopt
	
	if `"`lcinvariant'"' == "" {
		local lcinvariant none
	}
	
	local asis : list uniq asis
	local collinear : list uniq collinear
	
	local glopts if `touse' `wopt', `options' ///
		lclass(`C' `neq', base(`lcbase')) ///
		lcinvariant(`lcinvariant') latent(`C') ///
		`asis' `collinear'

	gsem `eqs' `preq' `glopts' `covs' fmmcmd
	
	ereturn local cmdline fmm `0_orig'
	ereturn hidden local cmdline2 `"gsem `eqs' `preq' `glopts' `covs'"'
	ereturn local prefix fmm
	ereturn local cmd gsem
	ereturn local cmd2 fmm
	ereturn local predict fmm_p
	ereturn hidden scalar k_components = `neq'
	ereturn hidden scalar lcbase = `lcbase'
	ereturn hidden scalar k_autoCns = `e(k_autoCns)'
end

program MakeEq, sclass
	gettoken touse 0 : 0
	gettoken ix 0 : 0
	gettoken C 0 : 0
	
	syntax anything [, LCPRob(string) *]

	gettoken model vars : anything
	
	if "`model'" == "streg" {
		local y _t
	}
	else {
		gettoken y vars : vars
	}
	
	if "`model'" == "intreg" {
		gettoken y2 vars : vars
		if "`y2'" == "" {
			di as err "intreg component: " ///
				"two dependent variables required"
			exit 198
		}
	}

	local eq `y' <- `vars'

	local opts `options'

	if "`model'" == "regress" {
		local 0 , `options'
		syntax [, noCONstant]
		local eq `eq', `opts'
	}
	else if "`model'" == "ivregress" {
		local 0 `y' `vars', `options'
		_iv_parse `0'
        	local lhs `s(lhs)'
		local endog `s(endog)'
		local exog `s(exog)'
		local inst `s(inst)'
		local opt `s(zero)'
		
		local 0 `opt'
		syntax [, noCONstant]
		
		if "`endog'" != "" {
			capture tsunab endog : `endog'
			if _rc {
				di as err "{p 0 4 2}ivregress component: " ///
				    "factor variables not allowed in the " ///
				    "list of endogenous variables{p_end}"
				exit 198
			}
			else {
				tsunab endog : `endog'
			}
			
			local eq (`ix': `lhs' <- `exog' `endog', `constant') ///
				(`ix': `endog' <- `exog' `inst')
			foreach e of local endog {
				local cov `cov' cov(`ix': e.`lhs'*e.`e')
			}
		}
		else {
			local eq (`ix': `lhs' <- `exog', `constant')
		}
	}
	else if "`model'" == "intreg" {
		local 0 , `options'
		syntax [, noCONstant OFFset(passthru) COLlinear]
		if "`vars'" == "" & "`constant'" == "noconstant" {
			di as err "intreg component: independent variables " ///
				"required with noconstant option"
			exit 100
		}
		local eq `eq', `constant' `offset' family(gaussian, ud(`y2'))
	}
	else if "`model'" == "tobit" {
		local 0 , `options'
		syntax [, noCONstant LL(string) UL(string) LL1 UL1 ///
			OFFset(passthru) COLlinear]

		if "`ll'" != "" & "`ll1'" != "" {
			di as err "only one of {bf:ll} or {bf:ll()} is allowed"
			exit 198
		}
		if "`ul'" != "" & "`ul1'" != "" {
			di as err "only one of {bf:ul} or {bf:ul()} is allowed"
			exit 198
		}
		
		if "`ll1'" != "" | "`ul1'" != "" {
			qui su `y' if `touse', meanonly
			if "`ll1'" != "" local ll `r(min)'
			if "`ul1'" != "" local ul `r(max)'
		}
		
		CheckLimit "`ll'" "ll()"
		local ll `s(lmt)'
		CheckLimit "`ul'" "ul()"
		local ul `s(lmt)'
		if "`ll'" != "" & "`ul'" != "" {
			capture assert `ll' <= `ul'
			if _rc {
				di as err "observations with " ///
					"{bf:ll()} > {bf:ul()} not allowed"
				exit 198
			}
		}

		local eq `eq', `constant' `offset' ///
			family(gaussian, lc(`ll') rc(`ul'))
	}
	else if "`model'" == "truncreg" {
		local 0 , `options'
		syntax [, noCONstant LL(string) UL(string) OFFset(passthru) ///
			COLlinear]
		
		CheckLimit "`ll'" "ll()"
		local ll `s(lmt)'
		CheckLimit "`ul'" "ul()"
		local ul `s(lmt)'
		if "`ll'" != "" & "`ul'" != "" {
			capture assert `ll' <= `ul'
			if _rc {
				di as err "observations with " ///
					"{bf:ll()} > {bf:ul()} not allowed"
				exit 198
			}
		}
		
		local eq `eq', `constant' `offset' ///
			family(gaussian, lt(`ll') rt(`ul'))
	}
	else if "`model'" == "betareg" {
		qui sum `y' if `touse'
		if r(min)<=0 | r(max)>=1 {
			di as err "betareg component: {bf:`y'} must be " ///
				"greater than zero and less than one"
			exit 459
		}
		local 0 , `options'
		syntax [, noCONstant LInk(string)]
		local eq `eq', `opts' family(beta)
	}
	else if "`model'" == "logit" {
		local 0 , `options'
		syntax [, noCONstant OFFset(passthru) ASIS COLlinear]
		local eq `eq', `constant' `offset' family(bern)
	}
	else if "`model'" == "probit" {
		local 0 , `options'
		syntax [, noCONstant OFFset(passthru) ASIS COLlinear]
		local eq `eq', `constant' `offset' family(bern) link(probit)
	}
	else if "`model'" == "cloglog" {
		local 0 , `options'
		syntax [, noCONstant OFFset(passthru) ASIS COLlinear]
		local eq `eq', `constant' `offset' family(bern) link(cloglog)
	}
	else if "`model'" == "ologit" {
		local 0 , `options'
		syntax [, OFFset(passthru) COLlinear]
		local eq `eq', `offset' family(ordinal)
	}
	else if "`model'" == "oprobit" {
		local 0 , `options'
		syntax [, OFFset(passthru) COLlinear]
		local eq `eq', `offset' family(ordinal) link(probit)
	}
	else if "`model'" == "mlogit" {
		local 0 , `options'
		syntax [, noCONstant Baseoutcome(string) COLlinear]
		if "`baseoutcome'" != "" local b b`baseoutcome'.
		local eq `b'`eq', `constant' family(multinomial)
	}
	else if "`model'" == "poisson" {
		local 0 , `options'
		syntax [, noCONstant EXPosure(passthru) OFFset(passthru) ///
			COLlinear]
		local eq `eq', `constant' `exposure' `offset' family(poisson)
	}
	else if "`model'" == "tpoisson" {
		local 0 , `options'
		syntax [, noCONstant LL(string) EXPosure(passthru) ///
			OFFset(passthru) COLlinear]
		CheckLimit "`ll'" "ll()"
		local ll `s(lmt)'
		if "`ll'" == "" local ll 0
		local eq `eq', `constant' `exposure' `offset' ///
			family(poisson, lt(`ll'))
	}
	else if "`model'" == "nbreg" {
		local 0 , `options'
		syntax [, noCONstant Dispersion(string) EXPosure(passthru) ///
			OFFset(passthru) COLlinear]
		local 0 , `dispersion'
		capture syntax [, Mean Constant]
		if _rc {
			di as err "invalid {bf:dispersion()}"
			exit 198
		}
		local eq `eq', `constant' `exposure' `offset' ///
			family(nbinomial `dispersion')
	}
	else if "`model'" == "streg" {
		st_is 2 analysis
		local st_wt : char _dta[st_w]
		local 0 , `options'
		syntax [, noCONstant Distribution(string) TIme ///
			OFFset(passthru) COLlinear]
		if "`distribution'" == "" {
			di as err "streg component: " ///
				"option {bf:distribution()} required"
			exit 198
		}
		if "`vars'" == "" & "`constant'" == "noconstant" {
			di as err "streg component: independent variables " ///
				"required with noconstant option"
			exit 100
		}
		if "`time'"=="time" {
			local aft aft
			local frm2 time
		}
		else {
			local frm2 hazard
		}
		local eq `eq', `constant' `offset' ///
			family(`distribution', fail(_d) ltr(_t0) `aft')
		sreturn local st_wt `st_wt'
	}
	else if "`model'" == "glm" {
		local 0 , `options'
		syntax [, noCONstant Family(passthru) Link(passthru) ///
			EXPosure(passthru) OFFset(passthru) ASIS COLlinear]
		local eq `eq', `constant' `family' `link' `exposure' `offset'
	}
	else if "`model'" == "pointmass" {
		if "`vars'" != "" {
			di as err "invalid pointmass component: " ///
				"indepvars not allowed"
			exit 198
		}
		local 0 , `options'
		syntax [, value(integer 0)]
		local dep : word 1 of `eq'
		capture _ms_parse_parts `dep'
		capture tsunab dep : `r(name)'
		if _rc {
			di as err "invalid pointmass component"
			exit 198
		}
		capture confirm numeric variable `dep'
		if _rc {
			di as err "invalid pointmass component"
			exit 198
		}
		local eq `eq', family(pointmass `value')
	}
	else {
		di as err "model {bf:`model'} not allowed"
		exit 198
	}
	
	if `"`lcprob'"' != "" {
		local preq (`ix'.`C' <- `lcprob')
		sreturn local hasprob 1
	}
	else sreturn local hasprob 0
	
	if "`model'" == "pointmass" {
		sreturn local pmass 1
	}
	else 	sreturn local pmass 0
	
	if "`model'" == "ivregress" {
		sreturn local eq `eq' `preq'
		sreturn local cov `cov'	
	}
	else {
		sreturn local eq (`ix': `eq') `preq'
		sreturn local cov
	}
	
	sreturn local model "`model'"
	sreturn local asis `asis'
	sreturn local collinear `collinear'
end

program CheckLimit, sclass
	args limit name
	
	if missing("`limit'") | "`limit'"=="." {
		sreturn local lmt
		exit
	}
	
	capture confirm numeric variable `limit'
	local rc1 = _rc
	if `rc1' {
		capture confirm number `limit'
		local rc2 = _rc
		capture local x = `limit'
		capture confirm number `x'
		local rc3 = _rc
		if `rc2' & `rc3' {
			di "{err}invalid option {bf:`name'}"
			exit 198
		}
		else {
			if `rc2' local lmt `x'
			else	 local lmt `limit'
			local rc1 0
		}
		if `rc1' {
			di `"{err}variable {bf:`limit'} not found"'
			exit 198
		}
	}
	else local lmt `limit'
	sreturn local lmt "`lmt'"
end

exit
