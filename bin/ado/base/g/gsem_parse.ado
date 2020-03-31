*! version 1.4.3  09jan2020
program gsem_parse, rclass
	version 13
	local vv : di "version " string(_caller()) ", missing:"

	// syntax:
	//	<mname> [, touse()] : <pathlist> [if] [in] [, options]

	_on_colon_parse `0'
	local 0 `"`s(before)'"'

	syntax name(name=GSEM) , TOUSE(name) [BYTOUSE(name) NOSTART]

	capture mata: rmexternal("`GSEM'")
	capture drop `GSEM'*

	local byvar : length local bytouse
	if `byvar' {
		confirm var `bytouse'
	}

	if "`nostart'" != "" {
		local NOSTART nostart noest
	}

	confirm new var `touse'

	local ZERO `"`s(after)'"'
	mata: st_sem_bind_eqns()

	local 0 : copy local ZERO
	syntax [anything(equalok)] [if] [in] [fw pw aw iw] [, moptobj(passthru) *]
	if "`weight'" == "" {
		local ZERO `"`anything' `if' `in', `options'"'
	}
	else {
		local ZERO `"`anything' `if' `in' [`weight'`exp'], `options'"'
	}

	local DVOPTS					///
			Family(passthru)		///
			Link(passthru)			///
			EXPosure(passthru)		///
			OFFset(passthru)		///
			NOCONStant	CONStant	///
							 // blank

	local DIOPTS					///
			noHeader			///
			noDVHeader			///
			noLegend			///
			notable				///
			BYPARM				///
							 // blank

	local LATOPTS					///
			LATent(passthru)		///
			NOCAPSlatent CAPSlatent		///
							 // blank

	local OPTS					///
			SVYSET				/// NODOC
			CRITTYPE(passthru)		/// NODOC
			VCE(passthru)			///
			TECHnique(passthru)		///
			CONSTraints(string)		///
			FROM(string)			///
			METHod(string)			///
			FVSTANDard			///
			MECMD				/// NODOC
			XTCMD				/// NODOC
			IRTCMD				/// NODOC
			FMMCMD				/// NODOC
			NOANCHOR	ANCHOR		///
			NOESTimate			///
			NOLISTwise	LISTwise	///
			NOLOg		LOg		///
			PWeights(string)		///
			FWeights(string)		///
			IWeights(string)		///
			GROUP(varname numeric)		///
							 // blank

	
	local EVALTYPE					///
			EVALTYPE(passthru)		/// NODOC
			DNUMERICAL			///
							 // blank

	local COMMON					///
			COVSTRucture(passthru)		///
			COVariance(passthru)		///
			RELiability(passthru)		///
			STARTGrid(passthru)		///
			STARTValues(passthru)		///
			VARiance(passthru)		///
			FORCENOANchor			///
			GINvariant(passthru)		///
			MEANs(passthru)			///
			NOMEANs				///
			NOSTART				/// NODOC
			`EVALTYPE'			///
			LCLASS(string)			///
			MCSTART				/// NODOC
			RDOTS(passthru)			/// NODOC
							 // blank

	_parse expand EQ GL : ZERO,			///
		common(					///
			`DIOPTS'			///
			`LATOPTS'			///
			`OPTS'				///
			`COMMON'			///
		)					///
		gweight

	// prelim parse of the path specifications; make global the 'if'/'in'
	// specifications and all non-equation-specific options

	local MEOPTS mecmd xtcmd
	if "`:list MEOPTS & GL_op'" != "" {
		local MECMD mecmd
	}

	if `EQ_n' != 1 {
		local CHECK COLlinear noASIS
	}

	forval i = 1/`EQ_n' {
		local 0 : copy local EQ_`i'
		syntax [anything(equalok)] [if] [in]	///
		[fw pw aw iw] [,			///
			`DVOPTS'			///
			`CHECK'				///
			*				///
		]
		Duplicates, `options'
		Check `collinear' `asis'
		ShortCuts, `MECMD' `family' `link' `options'
		local family	`"`s(family)'"'
		local link	`"`s(link)'"'
		local options	`"`s(options)'"'
		opts_exclusive "`noconstant' `constant'"
		opts_exclusive "`offset' `exposure'"
		local offset `offset' `exposure'
		if `:length local if' {
			if `:length local GL_if' {
				di as err ///
				"multiple 'if' specifications not allowed"
				exit 198
			}
			local GL_if : copy local if
		}
		if `:length local in' {
			if `:length local GL_in' {
				di as err ///
				"multiple 'in' specifications not allowed"
				exit 198
			}
			local GL_in : copy local in
		}
		if `:length local weight' {
			if `:length local GL_wt' {
				di as err ///
				"multiple 'weight' specifications not allowed"
				exit 198
			}
			else {
				local GL_wt "[`weight'`exp']"
			}
		}
		local EQ_`i' `"`anything', `family' `link' `noconstant' `offset'"'
		if `:length local options' {
			local GL_op `"`GL_op' `options'"'
		}
	}

	if `:length local GL_in' & `byvar' {
		di as error "in may not be combined with by"
		exit 190 
	}

	local neq = `EQ_n'
	if `neq' > 1 {
		_parse canon 0 : EQ GL, drop
		syntax anything(equalok				///
				name=PATHLIST			///
				id="path specification")	///
			[if] [in] [fw pw aw iw] [, *]
		local GL_if : copy local if
		local GL_in : copy local in
		if "`weight'" != "" {
			local GL_wt "[`weight'`exp']"
		}
	}
	else {
		local PATHLIST `"(`EQ_1')"'
		local options : copy local GL_op
	}

	while `:length local PATHLIST' {
		gettoken path PATHLIST : PATHLIST, match(par)
		if "`path'" != "" {
			local pathlist `"`pathlist' (`path')"'
		}
	}

	if `:length local pathlist' == 0 {
		di as err "invalid model specification;"
		di as err "no paths specified"
		exit 322
	}

	_get_diopts diopts options, `options'
	local 0 `", `NOSTART' `options'"'
	syntax [, `DIOPTS' *]
	local diopts	`diopts'	///
			`byparm'	///
			`header'	///
			`dvheader'	///
			`legend'	///
			`table'		///
					 // blank

	// combine the contents of the following options if they are specified
	// multiple times:
	// 	latent()
	// 	ginvariant()
	_parse combop options : options, opsin option(LATENT)
	_parse combop options : options, opsin option(GINVARIANT)
	local 0 `", `options'"'
	syntax [, `LATOPTS' *]
	opts_exclusive `"`nocapslatent' `capslatent'"'
	opts_exclusive `"`latent' `capslatent'"'
	local latent `nocapslatent' `capslatent' `latent'

	// parse globally specified equation options
	local 0 `", `options'"'
	syntax [, `DVOPTS' `OPTS' `EVALTYPE' *]
	if !inlist("`method'", "", "ml") {
		di as err "invalid {bf:method()} option;"
		di as err "option {bf:`method'} not allowed"
		exit 198
	}
	if "`xtcmd'" != "" {
		local mecmd mecmd
	}
	if "`mecmd'" != "" {
		local fvstandard fvstandard
	}
	Duplicates, `options'
	ShortCuts, `mecmd' `family' `link' `options'
	local family	`"`s(family)'"'
	local link	`"`s(link)'"'
	local options	`"`s(options)'"'
	opts_exclusive "`offset' `exposure'"
	opts_exclusive "`noconstant' `constant'"
	opts_exclusive "`noanchor' `anchor'"
	opts_exclusive "`nolistwise' `listwise'"
	_parse_iterlog, `log' `nolog'
	local nolog "`s(nolog)'"
	opts_exclusive "`evaltype' `dnumerical'"
	local offset `offset' `exposure'
	local dvopts `"`family' `link' `offset' `noconstant'"'
	if "`GL_wt'" != "" {
		if "`pweights'" != "" {
			local werr p
		}
		else if "`fweights'" != "" {
			local werr f
		}
		else if "`iweights'" != "" {
			local werr i
		}
		if "`werr'" != "" {
			di as err ///
"weight expression `GL_wt' is not allowed with the {bf:`werr'weights()} option"
			exit 198
		}
		// Generates one of the following macros:
		// 	pweights
		// 	fweights
		// 	iweights
		// 	wexp
		ParseWEXP `GSEM' `GL_wt'
	}
	else if "`pweights'" != "" {
		if "`fweights'" != "" {
			opts_exclusive "pweights() fweights()"
		}
		if "`iweights'" != "" {
			opts_exclusive "pweights() iweights()"
		}
	}
	else if "`fweights'" != "" {
		if "`iweights'" != "" {
			opts_exclusive "fweights() iweights()"
		}
	}

	if "`dnumerical'" != "" {
		local evaltype evaltype(gf0)
	}

	mlopts mlopts options, `options' `technique'
	local collinear "`s(collinear)'"
	local mlopts : list mlopts - collinear
	local mlopts `mlopts' `crittype'
	local options	`noanchor'	///
			`listwise'	///
			`collinear'	///
			`evaltype'	///
			`options'
	ChkFrom `from'

	mark `touse' `GL_if' `GL_in' `GL_wt'
	if `"`GL_wt'"' == "" {
		if "`pweights'" != "" {
			ParseWOPT `touse' pweights `pweights'
		}
		else if "`fweights'" != "" {
			ParseWOPT `touse' fweights `fweights'
		}
		else if "`iweights'" != "" {
			ParseWOPT `touse' iweights `iweights'
		}
	}

	if `byvar' {
		qui replace `touse' = 0 if !`bytouse'
	}

	if "`group'" != "" {
		tempname gvec
		GroupInfo `group' `touse' `gvec'
		local ngroups 	`s(ngroups)'
		if `ngroups' > 1 {
			local groupvar	`s(groupvar)'
		}
		else {
			local gvec
		}
	}
	else {
		local ngroups 1
	}

	// NOTE: this subroutine loops through the specified lclass()
	// options, building the following macros:
	//
	// 	lcvars		- list of latent class varnames
	// 	lcnlevs		- list of latent class level counts
	// 	lcbases		- list of latent class base levels
	// 	options		- remaining unparsed options

	gsem_parse_lclass, `options'

	if `"`GL_wt'"' != "" {
		local wt : copy local GL_wt
	}
	else if `"`pweights'"' != "" {
		local wt [pw=1]
	}

	_vce_parse `touse',		///
		opt(OIM OPG Robust)	///
		argopt(CLuster)		///
		: `wt', `vce'
	local vce `"`r(vceopt)'"'

	qui count if `touse'
	if (r(N)==0) error 2000
	if (r(N)==1) error 2001

	// This function consumes the following local macros:
	//
	//	fvstandard
	//	latent
	//	dvopts
	//	pathlist
	//	from
	//	nolog
	//	noestimate
	//	mecmd
	//	xtcmd
	//	irtcmd
	//	vce
	//	technique
	//	constraints
	//	pweights
	//	fweights
	//	iweights
	//	wexp
	//	svyset
	//   	ngroups
	//   	groupvar
	//   	gvec
	//   	lcvars
	//   	lcnlevs
	//   	lcbases
	//	options
	//
	// See the source _gsem_return.mata for details.

	foreach var of varlist * {
		local ORIGBASE `ORIGBASE' (`var' `:char `var'[_fv_base]')
	}

nobreak {
capture noisily break {

	`vv' mata: st_gsem_parse("`GSEM'", "`touse'")

} // capture noisily break
	local rc = c(rc)

	SetBase `ORIGBASE'

} // nobreak
	if `rc' {
		exit `rc'
	}

	return add
	return local mlopts	`"`nolog' `log' `mlopts'"'
	return local mlvce	`"`vce'"'
	return local nolog	`"`nolog'"'
	return local diopts	`"`diopts'"'
	return scalar estimate = `"`noestimate'"' == ""
	return local moptobj	`"`moptobj'"'
end

program ParseWEXP
	syntax anything(name=GSEM) [fw pw aw iw /]
	local wexp `"= `exp'"'
	capture confirm numeric variable `exp'
	if c(rc) {
		tempname wgt
		local exp `GSEM'`wgt'
		quietly gen double `exp' `wexp'
	}
	c_local `weight's : copy local exp
	c_local wexp `"`wexp'"'
end

program ParseWOPT
	gettoken touse	0 : 0
	gettoken type	0 : 0

	local varlist : subinstr local 0 "_cons" "`touse'", word all

	local 0 `", `type'(`varlist')"'
	syntax [, `type'(varlist numeric)]

	gsem_mark_weights `touse' ``type''
	c_local `type' ``type''
end

program Check
	if "`1'" != "" {
		di as err "option {bf:`1'} not allowed;"
		di as err "{p 0 0 2}"
		di as err "The {bf:`1'} option is global and"
		di as err "is not allowed as an option in a path"
		di as err "specification."
		di as err "{p_end}"
		exit 198
	}
end

program Duplicates
	syntax [, VCE(passthru) offset(passthru) exposure(passthru) *]
	if `"`vce'"' != "" {
		di as err "duplicate {bf:vce()} option not allowed"
		exit 198
	}
	if `"`offset'"' != "" {
		di as err "duplicate {bf:offset()} option not allowed"
		exit 198
	}
	if `"`exposure'"' != "" {
		di as err "duplicate {bf:exposure()} option not allowed"
		exit 198
	}
end

program ShortCuts, sclass
	syntax [,	Family(passthru)	///
			Link(passthru)		///
			mecmd			///
			cloglog			/// bernoulli
			logit			/// bernoulli
			probit			/// bernoulli
			ocloglog		/// ordinal
			ologit			/// ordinal
			oprobit			/// ordinal
			mlogit			/// multinomial
			REGress			/// gaussian
			poisson			/// poisson
			nbreg			/// nbreg
			gamma			/// gamma
			EXPonential		///
			WEIbull			///
			LOGNormal		///
			LNormal			///
			LOGLogistic		///
			LLogistic		///
			*			///
	]

	if "`lnormal'" != "" {
		local lognormal lognormal
	}
	if "`llogistic'" != "" {
		local loglogistic loglogistic
	}

	local cmd	`cloglog'	///
			`logit'		///
			`probit'	///
			`ocloglog'	///
			`ologit'	///
			`oprobit'	///
			`mlogit'	///
			`regress'	///
			`poisson'	///
			`nbreg'		///
			`gamma'		///
			`exponential'	///
			`weibull'	///
			`lognormal'	///
			`loglogistic'

	if "`cmd'" != "" {
		if "`mecmd'" != "" {
			local 0 `", `cmd'"'
			syntax [, NOOPT]
			error 198	// [sic]
		}

		opts_exclusive "`cmd'"
		opts_exclusive "`cmd' `family'"
		opts_exclusive "`cmd' `link'"
		if "`cmd'" == "cloglog" {
			local family	family(bernoulli)
			local link	link(cloglog)
		}
		else if "`cmd'" == "logit" {
			local family	family(bernoulli)
			local link	link(logit)
		}
		else if "`cmd'" == "probit" {
			local family	family(bernoulli)
			local link	link(probit)
		}
		else if "`cmd'" == "ocloglog" {
			local family	family(ordinal)
			local link	link(cloglog)
		}
		else if "`cmd'" == "ologit" {
			local family	family(ordinal)
			local link	link(logit)
		}
		else if "`cmd'" == "oprobit" {
			local family	family(ordinal)
			local link	link(probit)
		}
		else if "`cmd'" == "mlogit" {
			local family	family(multinomial)
			local link	link(logit)
		}
		else if "`cmd'" == "regress" {
			local family	family(gaussian)
			local link	link(identity)
		}
		else if "`cmd'" == "poisson" {
			local family	family(poisson)
			local link	link(log)
		}
		else if "`cmd'" == "nbreg" {
			local family	family(nbinomial mean)
			local link	link(log)
		}
		else if "`cmd'" == "gamma" {
			local family	family(gamma, aft)
			local link	link(log)
		}
		else if "`cmd'" == "exponential" {
			local family	family(exponential, ph)
			local link	link(log)
		}
		else if "`cmd'" == "weibull" {
			local family	family(weibull, ph)
			local link	link(log)
		}
		else if "`cmd'" == "lognormal" {
			local family	family(lognormal, aft)
			local link	link(log)
		}
		else if "`cmd'" == "loglogistic" {
			local family	family(loglogistic, aft)
			local link	link(log)
		}
	}
	sreturn local family	`"`family'"'
	sreturn local link	`"`link'"'
	sreturn local options	`"`options'"'
end

program ChkFrom
	gettoken FROM 0 : 0, parse(",") bind
	capture syntax [, skip]
	if c(rc) {
		di as err "invalid {bf:from()} option;"
		syntax [, skip]
		exit 198	// [sic]
	}
	if `"`FROM'"' != "" {
		capture numlist `"`FROM'"'
		if c(rc) == 0 {
			di as err "invalid {bf:from()} option;"
			di as err "list of numbers not allowed"
			exit 198
		}
	}
end

program MakeCns, eclass
	gettoken b cnslist : 0
	ereturn post `b'
	makecns `cnslist', r
end

program BadBase
	di as err "invalid base specification;"
	di as err "'`0'' found where base level factor variable expected"
	exit 198
end

program SetBase
	gettoken set 0 : 0, match(par)
	while `:length local set' {
		gettoken var set : set
		char `var'[_fv_base] `set'
		gettoken set 0 : 0, match(par)
	}
end

/* Group Information

    checks for multiple group structure returning
	    s(ngroups)
	    s(groupvar)		empty if ngroups==1

*/

program GroupInfo, sclass
	args group touse gvec

	capture assert `group'==floor(`group') & `group'>=0 if `touse'
	if _rc {
		di as err "invalid {bf:group()} option;"
		di as err ///
		"variable {bf:`group'} must contain only nonnegative integers"
		exit 459
	}
	// missing values in the group variable are marked out of the
	// estimation sample
	qui replace `touse' = 0 if missing(`group') & `touse'

	qui tab `group' if `touse', matrow(`gvec')
	if (r(N)==0) {
		error 2000
	}
	local ngroups = rowsof(`gvec')
	if (`ngroups'==1) {
		sreturn clear
		sreturn local ngroups 1
		exit
	}

	sreturn clear
	sreturn local ngroups	`ngroups'
	sreturn local groupvar	`group'
end

exit
