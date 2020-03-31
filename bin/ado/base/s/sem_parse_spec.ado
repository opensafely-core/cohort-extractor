*! version 1.6.0  30mar2018
program sem_parse_spec, sclass
	version 12

	// syntax:
	//	<mname> [, replacestructure ] : <eqspeclist> [, options]

	_on_colon_parse `0'
	local 0 `"`s(before)'"'

	syntax name(name=mname id="mname") ///
		[,BYTOUSE(name) TOUSE(name) REPLACESTRUCTURE]

	quietly ssd query
	local is_ssd = r(isSSD)
	if (`:length local touse') {
		confirm new var `touse'
	}
	else if `is_ssd' == 0 {
		tempname touse
	}
	local byvar : length local bytouse
	if `byvar' {
		confirm var `bytouse'
	}

	local ZERO `"`s(after)'"'
	mata: st_sem_bind_eqns()
	local 0 : copy local ZERO
	syntax [anything(equalok)] [if] [in] [fw pw iw] [, *]
	if "`weight'" == "" {
		local ZERO `"`anything' `if' `in', `options'"'
	}
	else {
		local ZERO `"`anything' `if' `in' [`weight'`exp'], `options'"'
	}

	local MAXOPTS						///
		/// maximize options
			NODIFficult				///
			DIFficult				///
			TECHnique(string)			///
			ITERate(numlist integer >=0) 		///
			TOLerance(numlist max=1 >=0)		///
			LTOLerance(numlist max=1 >=0)		///
			NRTOLerance(numlist max=1 >=0)		///
		///  reporting
			NOLOg LOg				///
			TRace					///
			GRADient				///
			showstep				///
			HESSian					///
			SHOWTOLerance				///
								 // blank

	local DIOPTS						///
			Level(passthru)				///
			STANDardized				///
			COEFLegend				///
			SELEGEND				///
			NOCNSReport				///
			NODEScribe				///
			NOHEADer				///
			NOFOOTnote				///
			NOTABLE					///
			NOLABel					///
			NOFVLABel				///
			FVLABel					///
			wrap(passthru)				///
			fvwrap(passthru)			///
			fvwrapon(passthru)			///
			SHOWGinvariant				///
			BYPARM					///
								 // blank

	_parse expand EQ GL : ZERO,				///
		common( 					///
			NOCAPSlatent				///
			CAPSlatent				///
			CLuster(passthru)			///
			RELiability(passthru)			///
			COVariance(passthru)			///
			COVSTRucture(passthru)			///
			EVALTYPE(passthru)			/// NODOC
			GINvariant(passthru)			///
			GROUP(passthru)				///
			SELect(passthru)			///
			FROM(passthru)				///
			CONSTraints(passthru)			///
			LATent(passthru)			///
			MEANs(passthru)				///
			METHod(string)				///
			noDEScribe				///
			ROBust					///
			VARiance(passthru)			///
			VCE(passthru)				///
			NM1					///
			NOANCHOR				///
			FORCENOANCHOR				///
			NOIVSTART				/// NODOC
			CRITtype(passthru)			/// NODOC
			noXCONDitional				///
			SKIPCONDitional				///
			SKIPCFATRANSform			///
			FORCEXCONDitional			///
			FORCECORrelations			///
			ALLMISSing				///
			COLlinear				///
			NOESTimate				///
			NOMEANs					///
			`MAXOPTS'				///
			SATOPTs(string)				///
			BASEOPTs(string)			///
			`DIOPTS'				///
			SBentler				///
		)						///
		gweight
	local neq = `EQ_n'
	// make -if/in/weight- specifications global
	forval i = 1/`neq' {
		local 0 : copy local EQ_`i'
		syntax [anything(equalok)] [if] [in] [fw pw iw] [, *]
		if `:length local if' {
			if `:length local GL_if' {
				Error "multiple 'if' specifications not allowed"
			}
			else {
				local GL_if : copy local if
			}
		}
		if `:length local in' {
			if `:length local GL_in' {
				Error "multiple 'in' specifications not allowed"
			}
			else {
				local GL_in : copy local in
			}
		}
		if `:length local weight' {
			if `:length local GL_wt' {
			  Error "multiple 'weight' specifications not allowed"
			}
			else {
				local GL_wt "[`weight'`exp']"
			}
		}
		local EQ_`i' `"`anything'"'
		if `:length local options' {
			local EQ_`i' `"`EQ_`i'', `options'"'
		}
	}
	if `:length local GL_in' & `byvar' {
		di as error "in may not be combined with by"
		exit 190 
	}
	if "`GL_wt'" == "[]" {
		local GL_wt
	}
	_parse canon 0 : EQ GL, drop gweight
	syntax anything(equalok name=MODEL id="equations")	///
		[if] [in] [fw pw iw] [,				///
		/// estimator
			METHod(string)				///
			VCE(passthru)				///
			CLuster(passthru)			///
			ROBust					///
			EVALTYPE(name)				/// NODOC
		/// misc
			GROUP(varname numeric)			///
			SELect(numlist int sort)		///
			FROM(string)				///
			CONSTraints(numlist integer >0)		///
			noDEScribe				///
			NM1					///
			NOANCHOR				///
			FORCENOANCHOR				///
			NOIVSTART				/// NODOC
			CRITtype(string)			/// NODOC
			NOCONstant				///
			noXCONDitional				///
			SKIPCONDitional				///
			SKIPCFATRANSform			///
			COLlinear				///
			FORCEXCONDitional			///
			FORCECORrelations			///
			ALLMISSing				///
			NOMEANs					///
			SATOPTs(string)				///
			BASEOPTs(string)			///
			SBentler				///
			*					///
		]

	local caller = _caller()
	MaxOpts		, `options'
	MaxOpts sat	, `satopts'
	MaxOpts base	, `baseopts'

	opts_exclusive "`xconditional' `forcexconditional'"

	// prevent information from being cleared by parsing below
	local OPTS	`"`options'"'
	local GL_weight	`"`weight'"'
	local GL_exp	`"`exp'"'
	local GL_if	`"`if'"'
	local GL_in	`"`in'"'

// method() -------------------------------------------------------------------

	sem_parse_method, `method'
	local method `"`s(method)'"'

// obtain group structure from group() ----------------------------------------

	if `is_ssd' {
		local ssdmsg "summary statistics data"
		if `:length local GL_if' {
			Error "if not allowed with `ssdmsg'" 101
		}
		if `:length local GL_in' {
			Error "in not allowed with `ssdmsg'" 101
		}
		if `:length local GL_weight' {
			Error "weights not allowed with `ssdmsg'" 101
		}
		if inlist("`method'","adf","mlmv") {
			Error "method(`method') not allowed with `ssdmsg'"
		}
		local select : list uniq select
	}
	else if "`select'" != "" {
		di as err "option select() requires summary statistics data"
		exit 198
	}

	if "`method'`GL_weight'"=="adfpweight"{
		di as err "pweights not allowed with method(adf)"
		exit 198
	}
	
	if "`allmissing'" != "" & "`method'" != "mlmv" {
		di as err "allmissing not allowed with method(`method')"
		exit 198
	}

	if "`GL_weight'"!="" {
		local wght [`GL_weight'`GL_exp']
	}

	// will later be adjusted for cluster etc
	if `is_ssd' == 0 {
		mark `touse' `GL_if' `GL_in' `wght'
	}
	// adjust touse for by group
	if `byvar' {
		qui replace `touse' = 0 if !`bytouse'
	}
	if `is_ssd' == 0 {
		qui count if `touse'
		if (c(N)>0 & r(N)==0) error 2000
		if (c(N)>0 & r(N)==1) error 2001
	}

	if "`group'" != "" {
		if `is_ssd' {
			quietly ssd describe
			if "`group'" != "`r(groupvar)'" {
				di as err ///
"variable `group' does not match the name of the ssd set group variable name"
				exit 459
			}
			local ngroups : list sizeof select
			if `ngroups' == 0 {
				local ngroups = r(G)
			}
			if `ngroups' == 1 {
				local groupvar
			}
			else {
				local groupvar : copy local group
			}
		}
		else {
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
	}
	else {
		local ngroups 1
	}

// vce() stuff ----------------------------------------------------------------

	_vce_parse `touse', 				///
		optlist(oim eim opg Robust sbentler) 	///
		argoptlist(CLuster) 			///
		: `wght' 				///
		, `vce' `cluster' `robust'

	local vce     `r(vce)'
	local cluster `r(cluster)'

	if (`is_ssd' & !inlist("`vce'","","oim","eim")) {
		Error "vce(`vce') not allowed with summary statistics data" 101
	}
	if !inlist("`method'", "", "ml", "mlmv") {
		if !inlist("`vce'", "", "oim", "eim") {
			di as err "vce(`vce') not allowed with method(`method')"
			exit 198
		}
	}
        if "`vce'"=="sbentler" {
                if "`method'"=="mlmv" {
                        di as err "vce(`vce') not allowed with method(`method')"
                        exit 198
                }
                if "`GL_weight'"=="iweight" {
                        di as err "iweights not allowed with vce(`vce')"
                        exit 198
                }
        }


// merge options --------------------------------------------------------------

	// combine the contents of the following options if they are specified
	// multiple times:
	// 	latent()
	// 	ginvariant()
	// 	satopts()
	// 	baseopts()
	_parse combop OPTS : OPTS, opsin option(LATENT)
	_parse combop OPTS : OPTS, opsin option(GINVARIANT)
	_parse combop OPTS : OPTS, opsin option(SATOPTS)
	_parse combop OPTS : OPTS, opsin option(BASEOPTS)

	local 0 `", `OPTS'"'
	syntax [, LATent(passthru) NOCAPSlatent CAPSlatent *]

	opts_exclusive `"`nocapslatent' `capslatent'"'
	opts_exclusive `"`latent' `capslatent'"'
	local LATENT `nocapslatent' `capslatent' `latent'

	sem_parse_display DIOPTS OPTS, `options'

// from() ---------------------------------------------------------------------

	if `:length local from' {
		gettoken FROM rest : from, parse(",") bind
		loca 0 : copy local rest
		capture syntax [, skip]
		if c(rc) {
			di as err "invalid from() option;"
			syntax [, skip]
			exit 198	// [sic]
		}
		local FROMSKIP : copy local skip
	}

// weights --------------------------------------------------------------------

	if "`GL_weight'" != "" {
		tempname Wvar
		qui gen double `Wvar' `GL_exp' if `touse'
	}
	if "`GL_weight'" == "fweight" {
		sum `touse' [`GL_weight'=`Wvar'] if `touse', mean
	}


// locals to be copied into Mata object ---------------------------------------

	if (`neq'==1 & bsubstr(trim(`"`MODEL'"'),1,1)!="(") {
		local MODEL `"(`MODEL')"'
	}

	// processing continues with the Mata function _sem_util_parse():
	//
	// (1) 	it reads from the calling context the following local macros:
	//
	//   	mname
	//	replacestructure
	//	describe
	//	nm1
	//	noanchor
	//	forcenoanchor
	//	noivstart
	//	noconstant
	//	crittype
	//	allmissing
	//	nomeans
	//	collinear
	//	xconditional
	//	skipconditional
	//	forcexconditional
	//	forcecorrelations
	//   	method
	//   	vce
	//   	touse
	//   	cluster
	//   	GL_weight
	//   	GL_wexp
	//   	Wvar
	//	evaltype
	//	slow
	//   	ngroups
	//   	groupvar
	//   	gvec
	//   	select
	//   	FROM
	//   	FROMSKIP
	//   	constraints
	//
	//	[sat|base]nodifficult
	//	[sat|base]difficult
	//	[sat|base]technique
	//   	[sat|base]iterate
	//   	[sat|base]tolerance
	//   	[sat|base]ltolerance
	//   	[sat|base]nrtolerance
	//   	[sat|base]log
	//   	[sat|base]trace
	//   	[sat|base]gradient
	//   	[sat|base]showstep
	//   	[sat|base]hessian
	//   	[sat|base]showtolerance
	//
	//   	LATENT
	//   	MODEL
	//   	OPTS
	//
	// (2)  continues parsing the model specification : _sem_parse()
	//
	// (3)  and it returns
	//	-  in a Mata structure named -mname-
	//   	-  in s() for debugging purposes

	mata: st_sem_parse_and_build(`caller')
	sreturn clear
	sreturn local mname `"`mname'"'
	sreturn local display_opts `"`DIOPTS'"'
end

program MaxOpts
	gettoken ch : 0, parse(" ,")
	if "`ch'" == "," {
		local STAR "*"
	}
	else if "`ch'" == "sat" {
		local IMPUTE IMPute
	}
	syntax [name(name=p)][,			///
		NODIFficult			/// maximize options
		DIFficult			///
		TECHnique(string)		///
		ITERate(numlist integer >=0) 	///
		TOLerance(numlist max=1 >=0)	///
		LTOLerance(numlist max=1 >=0)	///
		NRTOLerance(numlist max=1 >=0)	///
		NOLOg LOg			/// reporting
		TRace				///
		GRADient			///
		showstep			///
		HESSian				///
		SHOWTOLerance			///
		`IMPUTE'			///
		`STAR'				///
	]

	if "`p'" == "" {
		c_local options `"`options'"'
	}

	opts_exclusive "`difficult' `nodifficult'"

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	c_local `p'difficult		`difficult'
	c_local `p'nodifficult		`nodifficult'
	c_local `p'technique		`technique'
	c_local `p'iterate		`iterate'
	c_local `p'tolerance		`tolerance'
	c_local `p'ltolerance		`ltolerance'
	c_local `p'nrtolerance		`nrtolerance'
	c_local `p'log			`log'
	c_local `p'trace		`trace'
	c_local `p'gradient		`gradient'
	c_local `p'showstep		`showstep'
	c_local `p'hessian		`hessian'
	c_local `p'showtolerance	`showtolerance'
	if `"`p'"' == "sat" {
		c_local `p'impute	`impute'
	}

end

// ============================================================================
// subroutines
// ============================================================================

/* Group Information

    checks for multiple group structure returning
	    s(ngroups)
	    s(groupvar)		empty if ngroups==1

*/

program GroupInfo, sclass
	args group touse gvec

	capture assert `group'==floor(`group') & `group'>=0 if `touse'
	if _rc {
		ErrOpt group ///
		"variable '`group'' is not nonnegative integer valued"
	}
	// missing values in the group variable are marked out of the
	// estimation sample
	if "`touse'" != "1" {
		qui replace `touse' = 0 if missing(`group') & `touse'
	}

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

// general error
program Error
	args msg rc
	dis as err `"`msg'"'
	if ("`rc'"=="") {
		local rc 198
	}
	exit `rc'
end

// error in option optname()
program ErrOpt
	args optname msg rc

	dis as err `"`msg'"'
	dis as err "in option `optname'()"

	if ("`rc'"=="") {
		local rc 198
	}
	exit `rc'
end
exit
