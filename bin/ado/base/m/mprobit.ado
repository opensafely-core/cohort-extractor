*! version 1.6.0  13mar2018
* mprobit - multinomial probit model for case specific variables

program mprobit, eclass byable(onecall) prop(ml_score svyb svyj svyr mi bayes)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	version 9

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`vv' `BY' ///
	_vce_parserun mprobit, required(BASEoutcome) mark(CLuster) : `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"mprobit `0'"'
		exit
	}
	if replay() {
		if `"`BY'"' != "" error 190
		if `"`e(cmd)'"' != "mprobit" error 301
		Replay `0'
		exit
	}
	cap noi `vv' `BY' Estimate `0'
	local rc = _rc
	ereturn local cmdline `"mprobit `0'"'
	macro drop MPROBIT_*
	exit `rc'
end

program Estimate, eclass byable(recall) sortpreserve
	version 9
	syntax varlist(fv) [if] [in] [fw pw iw], [	///
		INTPoints(integer 15) 			///
		noCONstant				///
		BASEoutcome(string)			///
		Robust					///
		PROBITparam				///
		CLuster(varname)			///
		CONSTraints(passthru)			///
		FROM(string)				///
                SCore(passthru)                         ///
		Level(cilevel)				///
		NOLOg LOg				///
		noDROP					///
		moptobj(string)				/// NOT DOCUMENTED
		*]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	gettoken choice indvars : varlist

	_fv_check_depvar `choice'
	_get_diopts diopts options, `options' level(`level')
	mlopts mlopts, `options' `log' `nolog'
	local collinear `s(collinear)'
	local vv : di "version " string(_caller()) ":"
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
		local mm e1
		local fvexp expand
	}
	else {
		local mm d1
	}
	cap confirm string variable `choice'
	if _rc == 0 {
		di as error "{p}depvar `choice' is a string variable; " ///
		 "use {help encode##|_new:encode} to convert it{p_end}"
		exit 108
	}

	marksample touse
	if `"`cluster'"' != "" {
		markout `touse' `cluster'
		local robust robust
		local clopt cluster(`cluster')
	}
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	/* remove collinear variables */
	if _caller() >= 14 {
		if `:length local log' {
			local skipline noskipline
		}
		if `"`baseoutcome'"' != "" {
			local baseopt baseoutcome(`baseoutcome')
		}
		`vv'					///
		_rmcoll `varlist' `wgt' if `touse',	///
			`constant'			///
			`collinear'			///
			`skipline'			///
			mlogit				///
			`baseopt'			///
			expand
		if !`:length local coll' {
			local coll collinear
		}
		local varlist `"`r(varlist)'"'
		gettoken choice indvars : varlist
		tempname out
		matrix `out' = r(out)
		local ibase = r(ibaseout)
		local skipline noskipline
	}
	else {
		`vv' ///
		_rmcoll `indvars' if `touse' [`weight'`exp'],	///
			`constant' `fvexp' `collinear'
		local indvars `"`r(varlist)'"'
	}

	local nvar : word count `indvars'
	if `nvar'==0 & "`constant'"!="" {
		di as error "too few variables specified"
		exit 102
	}

	tempvar depvar 
	tempname label
	cap qui egen `depvar' = group(`choice') if `touse', lname(`label')
	if _rc > 0 {
		/* should not happen */
		di as error "failed to renumber outcome levels"
		error _rc
	}

	tempname N altlevels
	local tabwgt  "`weight'"
	if ("`tabwgt'" == "pweight") local tabwgt "iweight"
	qui tabulate `choice' [`tabwgt'`exp'] if `touse', matcell(`N') matrow(`altlevels')
	local nalt = r(r)
	if `nalt' == 1 {
		di as error "there is only one outcome in `choice'"
		exit 148
	}
	if `nalt' > 30 {
		di as error "there are `nalt' outcomes in `choice'; the maximum " ///
		 "number of outcomes is 30"
		exit 149
	}
	if "`ibase'`baseoutcome'" == "" {
		/* mimic -mlogit-: use maximum frequency as default base outcome */
		local ni = `N'[1,1]
		local ibase = 1
		local baseoutcome = `altlevels'[1,1]
		forvalues i=2/`nalt' {
			if `N'[`i',1] > `ni' {
				local ni = `N'[`i',1]
				local ibase = `i'
				local baseoutcome = `altlevels'[`i',1]
			}
		}
	}
	else if "`ibase'" == "" {
		local altlabels : value label `choice'
		AlternativeIndex "`altlevels'" "`altlabels'" "`baseoutcome'" "`choice'" 
		local ibase = r(index)
	}

	/* number of quadrature points */
	if `nalt' <= 2 {
		local intpoints = 0
	}
	else if `intpoints' < 1 {
		di as error "intpoints() must be greater than zero"
		exit 498
	}
	else if `intpoints' > 500 {
		di as error "{p}intpoints(`intpoints') is excessive; typically " ///
		 "no accuracy is gained beyond 30{p_end}"
		exit 498
	}
	global MPROBIT_NPOINTS = `intpoints'	
	global MPROBIT_NALT = `nalt'
	global MPROBIT_BASE = `ibase'
	global MPROBIT_CHOICE `depvar'
	global MPROBIT_TOUSE `touse'
	global MPROBIT_PROBITPARAM = ("`probitparam'"!="")

	`vv' GetModel `depvar' `indvars' if `touse',	///
		ibase(`ibase') `constant' 

	local models `"`r(models)'"'
	local alteqs `"`r(alteqs)'"'
	local const = `r(const)'
	local coefnames `"`r(coefnames)'"'
	local nout : list sizeof alteqs
	local neq = `nout' - 1

	if _caller() >= 14 & `"`constraints'"' != "" {
		_mult_makecns,	eqlist(`alteqs')	///
				`constant'		///
				rhs(`indvars')		///
				ibase(`ibase')		///
				outcomes(`out')		///
				`constraints'
		if "`r(Cns)'" == "matrix" {
			tempname Cns
			matrix `Cns' = r(Cns)
			local cnsopt constraints(`Cns') `r(nocnsreport)'
		}
	}
	else {
		local cnsopt : copy local constraints
	}

	if `"`from'"' == "" {
		`vv' ///
		cap mlogit `depvar' `indvars' if `touse', base(`ibase') ///
			`constant' iter(50)
		if _rc {
			di as err "{p}{cmd:mlogit} initial estimates " ///
			 "failed; try using the from() option{p_end}" 
			exit 498
		}
		_getmlogitcoef `indvars', `constant'
		tempname from
		if ($MPROBIT_PROBITPARAM)  matrix `from' = r(b)*sqrt(3)/c(pi)
		else matrix `from' = r(b)*sqrt(6)/c(pi)
		`vv' matrix colnames `from' = `coefnames'
	}
	/* need one extra score var for the base; -mprobit_lf- will pass */
	/* it on to mata routine _mprobit_quadrature			 */
	tempvar cb
	gen double `cb' = 0
	global MPROBIT_SCRS `cb'
	global MPROBIT_ALTEQS `alteqs'

	if `nalt' > 2 {
		tempname qx qw
		mata: _mprobit_weights_roots_laguerre(`intpoints', "`qw'", "`qx'")
		if "`moptobj'" != "" {
			mat `moptobj'`qx' = `qx'
			mat `moptobj'`qw' = `qw'
		}
		global MPROBIT_QX `moptobj'`qx'
		global MPROBIT_QW `moptobj'`qw'
	}

	if ("`score'"!="") local nopre  nopre

	global GLIST : all globals "MPROBIT_*"
	
	if "`moptobj'" != "" local mlmoptobj moptobj(`moptobj') 
	
	`vv' ///
	ml model `mm' mprobit_lf `models' if `touse' [`weight'`exp'],	///
		collinear `cnsopt' init(`from') `clopt' `robust'	///
		wald(`neq')  search(off) max nooutput `score'	///
		`nopre' `mlopts' `skipline' `mlmoptobj'

	local labs : value label `choice'
	forvalues i=`nalt'(-1)1 {
		local a`i' = `altlevels'[`i',1]
		if "`labs'" != "" {
			local lab`i' : label `labs' `a`i''
			ereturn local out`i' `"`lab`i''"'
		}
		else ereturn local out`i' `"`a`i''"'
	}
	local kind : list sizeof indvars
	ereturn scalar k_indvars = `kind'
	ereturn scalar const = `const'
	ereturn scalar k_out = `nalt'
	ereturn scalar k_eq_model = `nalt' - 1
	ereturn hidden scalar i_base = `ibase'
	ereturn scalar ibaseout = `ibase'
	ereturn scalar baseout = `altlevels'[`ibase',1]
	ereturn scalar k_points = `intpoints'
	ereturn matrix outcomes = `altlevels'
	ereturn scalar probitparam = $MPROBIT_PROBITPARAM
	 
	ereturn local outeqs `"`alteqs'"'
	ereturn local indvars `"`:list retok indvars'"'
	ereturn local depvar `"`choice'"'

	ereturn scalar k_dv = 1

	ereturn local title  "Multinomial probit regression"
	ereturn local predict mprobit_p
	ereturn local marginsnotok stdp SCores
	if "`out'" != "" {
		forval i = 1/`nalt' {
			local j = `out'[1,`i']
			local mdflt `mdflt' predict(pr outcome(`j'))
			local depvar_outcomes `"`depvar_outcomes' `j'"'
		}
		ereturn local marginsdefault `"`mdflt'"'
		ereturn hidden local depvar_outcomes `"`:list retok depvar_outcomes'"'
	}
	ereturn hidden local cmd2 mprobit

	if _caller() >= 12 {
		version 12	// needed for "`e(Cns)'"
		tempname b v C
		matrix `b' = e(b)
		matrix `v' = e(V)
		local xvars : copy local indvars
		if !`:length local constant' {
			local xvars `xvars' _cons
		}
		local nx : list sizeof xvars
		local pos = (`ibase'-1)*`nx' + 1
		_mat_fill0 `b', k(`nx') col(`pos')
		_mat_fill0 `v', k(`nx') col(`pos') row(`pos')
		if "`e(Cns)'" == "matrix" {
			matrix `C' = e(Cns)
			_mat_fill0 `C', k(`nx') col(`pos')
			local Cns "C=`C'"
		}
		forval i = 1/`nout' {
			gettoken eq alteqs : alteqs
			forval j = 1/`nx' {
				local coleq `coleq'  `eq'
			}
			local colna `colna' `xvars'
		}
		if "`e(V_modelbased)'" == "matrix" {
			tempname vmb
			matrix `vmb' = e(V_modelbased)
			_mat_fill0 `vmb', k(`nx') col(`pos') row(`pos')
			matrix colna `vmb' = `colna'
			matrix rowna `vmb' = `colna'
			ereturn matrix V_modelbased `vmb'
		}
		`vv' matrix colna `b' = `colna'
		matrix coleq `b' = `coleq'
		local fveq = `nout' - (`nout' == `ibase')
		ereturn repost b=`b' V=`v' `Cns' [`e(wtype)'`e(wexp)'], ///
			resize eqvalues(`out') buildfvinfo		///
			findomitted fvinfoeq(`fveq')
		ereturn scalar k_eq = `nout'
		ereturn hidden scalar k_eform = `nout'
		ereturn scalar k_eq_model = `nout'
		ereturn scalar k_eq_base = `ibase'	// used by -_coef_table-
		ereturn hidden local k_eq_model_skip `ibase'
	}

	ereturn repost, esample(`touse')

	ereturn local cmd mprobit

	Replay, `diopts'
end

program Replay
	if e(k_eq) < e(k_out) {
		Replay11 `0'
		exit
	}
	syntax [, notable noHeader noCNSReport *]

	_get_diopts diopts, `options'
	_prefix_display, `table' `header' `rrr' `cnsreport' `diopts'
end

program Replay11
	syntax [, Level(cilevel) notable noHeader noCNSReport *]

	_get_diopts diopts, `options'
	_prefix_display, notable `header'

	if (`:length local table') exit

	if "`header'`s(blank)'" == "" {
		di
	}

	tempname T
	.`T'	= ._b_table.new, level(`level') `diopts'
	.`T'.display_titles, `coeftitle' `cnsreport'
	local eqlist `"`e(outeqs)'"'
	local i 1
	foreach eq of local eqlist {
		if `i' == e(i_base) {
			.`T'.sep
			.`T'.display_comment `eq', comment("  (base outcome)")
		}
		else {
			.`T'.display_eq `eq', `eform'
		}
		local ++i
	}
	.`T'.finish
	if (!missing(e(rc)) & e(rc) != 0) error e(rc)

	_prefix_footnote
end

program GetModel, rclass
	version 9
	syntax varlist(fv) if, ibase(integer) [ noCONstant ] 

	gettoken choice indvars : varlist
	fvexpand `indvars'
	local indvars "`r(varlist)'"
	local const = ("`constant'" == "")
	local nind : word count `indvars'

	if _caller() < 11 {
		_labels2names `choice' `if', stub(_outcome_) noint
		local altlabels `"`s(names)'"'
		local nalt = `s(n_cat)'
	}
	else {
		_labels2eqnames `choice' `if', stub(_outcome_)
		local altlabels `"`r(eqlist)'"'
		local nalt = `r(k_eq)'
	}

	forvalues i=1/`nalt' {
		if (`i' == `ibase') continue

		local ai : word `i' of `altlabels'

		local models `"`models' (`ai':"'

		local eqs `"`eqs' `ai'"'
		if `nind' > 0 {
			foreach cv of local indvars {
				local cfnms `"`cfnms' `ai':`cv'"'
				local models `"`models' `cv'"'
			}
		}
		if `const' {
			local cfnms `"`cfnms' `ai':_cons"'
			local models `"`models')"'
		}
		else local models `"`models',nocons)"'
	}

	return local models `"`models'"'
	return local eqs `"`eqs'"'
	return local const = `const'
	return local coefnames `"`cfnms'"'
	return local alteqs `"`altlabels'"'
end

program AlternativeIndex, rclass
	args  altlevels altlabels level choice

	local index = .
	local nalt = rowsof(`altlevels')
	if "`level'"!="" {
		local i = 0
		while `++i'<=`nalt' & `index'>=. {
			local ialt = `altlevels'[`i',1]
			if (`"`level'"'==`"`ialt'"') local index = `i'
		}
		if `index'>=. & "`altlabels'"!="" {
			local i = 0
			while `++i'<=`nalt' & `index'>=. {
				local label : label `altlabels' `=`altlevels'[`i',1]'
				if (`"`level'"'==`"`label'"') local index = `i'
			}
		}
		if `index'>=. {
			di as error "{p}baseoutcome(`level') is not an "   ///
	"outcome of `choice'; use {help tabulate##|_new:tabulate} for a " ///
			 "list of values{p_end}"
			exit 459
		}
	}
	return local index = `index'
end 

