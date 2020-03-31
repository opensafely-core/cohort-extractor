*! version 1.1.0  16aug2018
program metobit, eclass byable(onecall) prop(or svyg bayes xtbs)
	version 13
	local vv : di "version " string(_caller()) ", missing:"
	
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	if replay() {
		if "`e(cmd2)'" != "metobit" {
			error 301
		}
		if _by() {
			error 190
		}
		_me_display `0'
		exit
	}
	
	capture noisily `vv' `by' Estimate `0'
	local rc = _rc
	exit `rc'
end

program Estimate, sortpreserve eclass byable(recall)
	version 13
	local vv : di "version " string(_caller()) ", missing:"
	
	if _by() {
		tempname bytouse
		mark `bytouse'
	}
	
	local 0_orig `0'
	_parse expand eq opt : 0
	local gopts `opt_op'
	
	forvalues i=1/`=`eq_n'-1' {
		local 0 `eq_`i''
		syntax [anything] [if] [in] [fw pw iw] [, or irr eform 	///
			BINomial(string) Family(string) Link(string) 	///
			EXPosure(string) *]
		_me_chk_opts, binomial(`binomial') exposure(`exposure')  ///
			irr(`irr') family(`family') link(`link')
		
		if "`weight'" != "" local wopt [`weight'`exp']
		else local wopt
		if `i' == 1 {
			if `"`opt_if'"' != "" {
				local if `if' `opt_if'
			}
			if `"`opt_in'"' != "" {
				local if `in' `opt_in'
			}
			marksample touse
			if _by() {
				qui replace `touse' = 0 if !`bytouse'
			}
			gettoken y junk : anything
		}
		
		local 0 `anything' `if' `in', family(`family') link(`link') ///
			binomial(`binomial') exposure(`exposure') `options'
		quietly ///
		syntax [anything] [if] [in] [, family(passthru) ///
			link(passthru) binomial(passthru) exposure(passthru) *]
		local eq_`i' `anything' `if' `in' `wopt', `family' `link' ///
			`binomial' `exposure' `options'
		
		local eqs `eqs' `eq_`i'' ||
		local dixtra `dixtra' `or' `eform'
	}
	
	local 0 `eq_`eq_n''
	syntax [anything] [if] [in] [fw pw iw] [, *]
	if `eq_n' == 1 {
		if `"`opt_if'"' != "" {
			local if `if' `opt_if'
		}
		if `"`opt_in'"' != "" {
			local if `in' `opt_in'
		}
		marksample touse
		if _by() {
			qui replace `touse' = 0 if !`bytouse'
		}
		gettoken y junk : anything
	}
	if "`weight'" != "" {
		local eqn `anything' `if' `in' [`weight'`exp']
	}
	else {
		local eqn `anything' `if' `in'
	}
	local 0 , `options' `gopts'
	syntax [anything] [, BINomial(string) noTABle noLRtest noGRoup 	///
		noHEADer NOLOg LOg or irr eform Family(string) Link(string) ///
		EXPosure(string) noESTimate COEFLegend ul(string) ll(string) ///
		LL1 UL1 * ]

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
	
	_chk_limit "`ll'" "ll()"
	local ll `s(lmt)'
	_chk_limit "`ul'" "ul()"
	local ul `s(lmt)'
	
	if "`ll'" != "" & "`ul'" != "" {
		capture assert `ll' <= `ul'
		if _rc {
			di as err "observations with {bf:ll()} > {bf:ul()}" ///
				" not allowed"
			exit 198
		}
	}
	
	_me_chk_opts, family(`family') link(`link') exposure(`exposure') ///
		irr(`irr') binomial(`binomial')
	local dixtra `dixtra' `or' `eform'
	local dixtra : list uniq dixtra
	opts_exclusive "`dixtra'"
	
	_get_diopts diopts opts, `options'
	local diopts `diopts' `table' `lrtest' `group' `header' 	///
		`log' `nolog' ///
		`estimate' `coeflegend' `dixtra'
	local opts `opts' ul(`ul') ll(`ll')
	
	local 0 `eqs' `eqn' , link(identity) `family' `opts' `log' `nolog' ///
		`estimate' `coeflegend'
	`vv' _me_estimate "`bytouse'" `0'
	
	ereturn local family gaussian
	ereturn local link identity
	ereturn local llopt `ll'
	ereturn local ulopt `ul'

	ereturn hidden local limit_l `ll'
	ereturn hidden local limit_u `ul'
	if missing("`ll'") {
		ereturn hidden local limit_l "-inf"
	}
	if missing("`ul'") {
		ereturn hidden local limit_u "+inf"
	}
	
	if missing("`ul'`ll'") {
		ereturn scalar N_unc = `e(N)'
		ereturn scalar N_lc  = 0
		ereturn scalar N_rc  = 0
	}
	else {
		tempname cmat
		mat `cmat' = e(yinfo1_cens_info)
		ereturn scalar N_unc = `cmat'[1,1]
		ereturn scalar N_lc  = `cmat'[1,2]
		ereturn scalar N_rc  = `cmat'[1,3]
	}
	
	local off `e(offset1)'
	ereturn local offset `off'
	ereturn hidden local offset1 `off'
	ereturn hidden local footnote `e(footnote)'
	
	if e(k_r) ereturn local title "Mixed-effects tobit regression"
	else ereturn local title "Tobit regression"
	ereturn local model tobit
	
	ereturn local cmd2 metobit
	ereturn local cmdline metobit `0_orig'
	
	ereturn local predict metobit_p
	ereturn local estat_cmd metobit_estat
	ereturn local cmd meglm
	ereturn hidden local cmdline2
	
	_me_display , `diopts'
	
end

program _chk_limit, sclass
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
