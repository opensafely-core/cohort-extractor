*! version 5.12.1  18apr2019
program glm, eclass byable(onecall) prop(ml_score swml svyb svyj svyr mi bayes)
	local version : di "version " string(_caller()) ", missing:"
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	local vceopts bootopts(noheader notable)	///
		jkopts(noheader notable) 		///
		mark(EXPosure OFFset mu INIt T CLuster)
	`BY' _vce_parserun glm, `vceopts' robustok multivce : `0'
	if "`s(exit)'" != "" {
		// -bootstrap- and -jackknife- are not aware of -vfactor()-
		version 10: ereturn local cmdline `"glm `0'"'
		if e(vf) != 1 {
			tempname V
			matrix `V' = e(vf)*e(V)
			version 9: ereturn repost V = `V'
		}
		version 9: ereturn local clustvar `"`e(cluster)'"'
		version 9: ereturn local cluster
		quietly syntax [anything] [fw aw iw pw] [if] [in] [,	///
			noHEADer noTABLE Level(passthru) eform * ]
		if ! `:length local level' {
			if `"`s(level)'"' != "" {
				local level `"level(`s(level)')"'
			}
		}
		_get_diopts diopts options, `options'
		version 7: Display, `header' `table' `level' `eform' `diopts'
		exit
	}

	version 7, missing
	if replay() {
		if _by() {
			error 190
		}
		if "`e(cmd)'" != "glm" {
			error 301
		}
		if "`e(predict)'" == "glm_p" {
			glm_6 `0'
			exit
		}
		Display `0'
		error `e(rc)'
		exit
	}
	if _caller() < 7 {
		mac drop SGLM_*
		capture noi `BY' glm_6 `0'
		mac drop SGLM_*
		exit _rc
	}
	mac drop SGLM_running SGLM_nonstan
	capture noisily `version' `BY' glm_7 `0'
	if _rc {
		if "$SGLM_running" ~= "" & "$SGLM_nonstan" ~= "" {
			di as err /*
		*/"data not suitable for nonstandard family-link combination"
			mac drop SGLM_*
			exit 459
		}
		else {
			mac drop SGLM_*
			exit _rc
		}
	}
	version 10: ereturn local cmdline `"glm `0'"'
	if "$SGLM_running" == "" & "$SGLM_nonstan" == "" {
		mac drop SGLM_*
	}
end

program glm_7, eclass byable(recall) sort
	version 7, missing

/* Parse. */
	local oldIC oldic
	if _caller() < 9 {
		local iteropt ITERate(integer 50)
	}
	else	local iteropt ITERate(integer `c(maxiter)')

	local dltol -1

	syntax varlist(numeric fv ts) [fw aw pw iw]	///
		[if] [in] [,				///
		EForm					///
		FROM(string)				///
		LEvel(cilevel)				///
		OFFset(varname numeric)			///
        	LNOFFset(varname numeric)		///
		noCONstant				///
		Robust					///
		CLuster(varname)			///
        	Family(string)				///
		Link(string)				///
		ASIS					///
		SEARCH					///
		IRLS					///
		ML					///
        	LTOLerance(real `dltol')		///
        	SCore(string)				///
		NOLOg LOg				///
		noTABLE					///
		noDISPLAY				///
		FISHER(integer -1)			///
		noDOTS					///
		`iteropt'				///
		TRAce					///
		SCAle(string)				///
		estscale 	/* undocumented */	///
		MU(varname)				///
        	INIt(varname)				///
        	T(string)	/* undocumented */	///
		noHEADer				///
		DISP(real 1)				///
		VFactor(real 1)				///
        	EXPosure(varname numeric)		///
        	moptobj(passthru)			/// not documented
		*					///
	]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	if `fvops' {
		local VV : di "version " string(max(11,_caller())) ", missing:"
		local MM e2
		local negh negh
	}
	else {
		local VV "version 8.1:"
		local MM d2
	}

	// NOTE: GetVCE creates one or more of the following local macros:
	// 	brep
	// 	bstrap
	//	cluster
	// 	hac
	// 	jknife
	// 	jknife1
	//	oim
	//	opg
	//	robust
	//	unbiased
	//	vce
	// 	options
	GetVCE, `irls' cluster(`cluster') `robust' `options'

	if "`family'"!= "" {
		local argfam `"family(`family')"'
	}
	if "`link'" != "" {
		local arglink `"link(`link')"'
	}

	if "`init'" != "" & "`mu'" != "" & "`init'" != "`mu'" {
		noi di as err "mu() and init() should use the same varname"
		exit 198
	}

	if "`init'" != "" {
		local init "`init'"
	}
	else	local init "`mu'"

	if "`dots'" == "nodots" {
		local dots ""
	}
	else    local dots "dots"

	if "`unbiased'" != "" {
		local robust "robust"
	}

	if `vfactor' <= 0.0 {
		di as err "vfactor() must be positive"
		exit 198
	}

	if `iterate' < 0 {
		di as err "iterate() must be positive"
		exit 198
	}

	_get_diopts diopts options, `options'
	mlopts mlopts, `options'
	local cns `s(constraints)'
	local coll `s(collinear)'
	if `"`coll'"' != "" & "`irls'" != "" {
		version 8: ///
		di as err "option {bf:collinear} not allowed"
		exit 198
	}
	if `ltolerance' == -1 {
		local ltol 1e-6
	}
	else {
		local ltol `ltolerance'
		if "`irls'" == "" {
			local mlopts `"`mlopts' ltol(`ltol')"'
		}
	}
	if `ltol'>=1 | `ltol'<0 {
		di as err "ltolerance() must be in [0,1)"
		exit 198
	}

/* Check syntax. */
	if "`ml'"!="" & "`irls'"!="" {
		di as err "ml and irls options may not be combined"
		exit 198
	}
	if "`irls'" != "" {
                if `"`from'"' != "" {
                        di as err "option {bf:from()} not allowed " /*
                               */ "in combination with option {bf:irls}"
			exit 198
                }
                if "`search'" != "" {
                        di as err "option {bf:search} not allowed " /*
                               */ "in combination with option {bf:irls}"
			exit 198
                }
	}
	if `"`score'"'!="" {
		if "`irls'" != "" {
			di as err "deviance scores are calculated " /*
			*/ "postestimation via predict, score"
			exit 198
		}
		confirm new variable `score'
		local nword : word count `score'
		if `nword' > 1 {
			di as err "score() must contain the name of only " /*
			*/ "one new variable"
			exit 198
		}
		tempvar scvar
		local scopt score(`scvar')
	}
	if `"`cluster'"'!="" {
		if "`jknife'`bstrap'" == "" {
			local robust "robust"
		}
		local clopt cluster(`cluster')
	}

	if "`bstrap'" == "" {
		if !inlist("`brep'","","-1") {
			di as err "brep() only valid with bstrap"
			exit 198
		}
		else	local brep -1
	}

	if "`bstrap'" != "" {
		if `brep' == -1 {
			local brep = 199
		}
		if `brep' <= 40 {
			di as err "bootstrap replications must be > 40"
			exit 198
		}
	}

	local tsops = index("`varlist'", ".")
	if `tsops' {
		local PROB `bstrap' `jknife' `jknife1'
		if `:length local PROB' {
			gettoken PROB : PROB
			if `"`PROB'"' == "jknife1" {
				local PROB "vce(jackknife1)"
			}
			di as error "{p}"
			di as error "cannot use factor variables or "
			di as error "time-series operators with option `PROB'"
			di as error "{p_end}"
			exit 101
		}
	}

	if `fisher' != -1 {
		if "`irls'" != "" {
			di as err /*
		*/ "fisher() only valid with Newton-Raphson optimization"
			exit 198
		}
		if `fisher' <= 0 {
			di as err "fisher() must be positive"
			exit 198
		}
	}

	if `disp' < 0 {
		di as err "disp() must be positive"
		exit 198
	}

        if `"`scale'"'!="" {
		if "`robust'`opg'`hac'`jknife1'`jknife'`bstrap'" != "" {
			di as err "cannot use scale() with alternate variances"
			exit 198
		}
                if `"`scale'"'=="x2" {
			local scale 0
		}
                else if `"`scale'"'=="dev" {
			local scale -1
		}
                else {
                        capture confirm number `scale'
                        if _rc {
                                di as err "invalid scale()"
                                exit 198
                        }
			if `scale' <= 0 {
				di as err "scale(#) must be positive"
				exit 198
			}
                }
        }

	if "`scale'" == "-1" & "`irls'" == "" {
		di as err ///
"option {bf:scale(dev)} allowed only with option {bf:irls}"
		exit 198
	}

	if `disp' != 1 & "`irls'" == "" {
		di as err "disp() allowed only with irls option"
		exit 198
	}

	MapFL `"`family'"' `"`link'"'
        local family    `"`r(family)'"'
        local link      `"`r(link)'"'
        local pow       `r(power)'
        local scale1    `r(scale)' /* 1 for fams with default scale param 1 */
        local m         `r(m)'
        local mfixed    `r(mfixed)'
        local k         `r(k)'

	tempname canon
	scalar `canon' = 0	
	if ("`family'" == "glim_v1" & "`link'" == "glim_l01") {
		scalar `canon' = 1
	}
	else if ("`family'"=="glim_v5" & ("`link'"=="glim_l10")) {
		scalar `canon' = 1
	}
	else if ("`family'" == "glim_v3" & "`link'" == "glim_l03") {
		scalar `canon' = 1
	}
	else if ("`family'" == "glim_v6" & "`link'" == "glim_l04") {
		scalar `canon' = 1
	}
	else if ("`family'" == "glim_v2" & "`link'" == "glim_l02") {
		scalar `canon' = 1
	}
	else if ("`family'" == "glim_v4" & "`link'" == "glim_l09") {
		scalar `canon' = 1
	}

	if "`link'" == "" | "`family'" == "" {
		di as err "incomplete specification of family() and link()"
		exit 198
	}

	if "`offset'" != "" & "`lnoffset'" != "" {
		di as err ///
		"only one of offset() or lnoffset() can be specified"
		exit 198
	}
	if "`offset'" != "" & "`exposure'" != "" {
		di as err ///
		"only one of offset() or exposure() can be specified"
		exit 198
	}
	if "`lnoffset'" != "" & "`exposure'" != "" {
		di as err ///
		"only one of lnoffset() or exposure() can be specified"
		exit 198
	}
	if "`exposure'" != "" {
		local lnoffset `exposure'
		local exposure
	}
	if "`constant'" != "" {
		local nvar : word count `varlist'"
		if `nvar' == 1 {
			di as err ///
"independent variables required with noconstant option"
			exit 100
		}
	}

/* Mark sample except for offset/exposure. */

	marksample touse
	if "`cluster'" != "" {
		markout `touse' `cluster', strok
	}
	if "`m'" != "" {
		capture confirm number `m'
		if _rc { markout `touse' `m' }	
	}

	if `"`hac'"' == "" {
		if `"`t'"' ~= "" {
			di as err "t() only valid with vce(hac ...)"
			exit 198
		}
	}

	if "`hac'" != "" {	/* jknife1 and jknife removed -- rgg */
		capture xt_tis `t'
		if _rc {
			tsset `t', noquery	// to get centralized error msg
		}
		local tvar `"`s(timevar)'"'
		markout `touse' `tvar'
		sort `touse' `tvar'
		cap assert `tvar'[_n-1] != `tvar' if `touse' & /*
		*/ (`touse'[_n-1]==1)
		if _rc {
			di as err "repeated time values in sample"
			exit 451
		}
		sort `tvar'
	}

/* Process offset/exposure. */

	if "`lnoffset'" != "" {
		capture assert `lnoffset' > 0 if `touse'
		if _rc {
			di as err "exposure() must be greater than zero"
			exit 459
		}
		tempvar offset
		qui gen double `offset' = ln(`lnoffset')
		local offvar "ln(`lnoffset')"
	}

	if "`offset'" != "" {
		markout `touse' `offset'
		local offopt "offset(`offset')"
		if "`offvar'" == "" {
			local offvar "`offset'"
		}
	}

/* Count obs and check for negative values of `y'. */

	gettoken y xvars : varlist
	_fv_check_depvar `y'
	tsunab y : `y'
	local yname : subinstr local y "." "_"

	summarize `y' if `touse', meanonly
	if r(N) == 0 { error 2000 }
	if r(N) == 1 { error 2001 }
	local nobs = round(r(N),1)

	MapHAC `nobs' `hac'
	local hacnam `"`r(hacnam)'"'
	local haclag `"`r(haclag)'"'
	local intlag `"`r(intlag)'"'

	local fwt "1"
	local awt "1"
	tempvar wt
	if "`weight'" != "" {
		qui gen double `wt' `exp' if `touse'
		local awt "`wt'"
		if `"`weight'"'=="aweight" {
			summ `wt' , meanonly
			qui replace `wt' = `wt'/r(mean)
		}
		else if `"`weight'"'=="fweight" {
			if "`bstrap'`hac'" != "" {
				di as err "fweights not allowed"
				exit 198
			}
			if "`jknife'" != ""  & "`cluster'" != "" {
				sort `cluster' `tvar' `touse'
				cap by `cluster' : assert `wt' == `wt'[_n-1]/*
				*/ if `touse' & (`touse'[_n-1]==1)

				if _rc {
					noi di as err "weight must be " /*
						*/ "constant within `cluster'"
					exit 198
				}
			}
			summ `touse' [fw=`wt'] if `touse' , meanonly
			local nobs = round(r(N),1)
			local fwt "`wt'"
			local awt "1"
		}
		if "`weight'" == "pweight" {
			local robust "robust"
		}
	}
	else {
		qui gen byte `wt' = `touse' if `touse'
	}
	
	if "`weight'"=="fweight" {
		local wwt `"[fw=`wt']"'
	}
	else if "`weight'" == "iweight" {
		local wwt `"[iw=`wt']"'
	}
	else 	local wwt `"[aw=`wt']"'
					
	if "`robust'" != "" {
		if "`hacnam'`opg'`jknife'`jknife1'" != "" {
			di as err "robust allowed only with hessian matrices"
			exit 198
		}
	}

	if "`weight'" != "" {
		if "`weight'" != "fweight" {
			if "`hacnam'`opg'`jknife'`jknife1'" != "" {
				di as err ///
"only fweights (if any) are available for non-hessian, non-bootstrap matrices"
				exit 198
			}
		}
	}

/* Remove collinearity. */

	if `fvops' {
		local rmcoll "version 11: _rmcoll"
		local fvexp expand
	}
	else	local rmcoll _rmcoll
	local is_bin = "`family'" == "glim_v2" 
	if `is_bin' & "`m'" != "" {
		capture assert `m' == 1
		if c(rc) {
			local is_bin 0
		}
	}
	if "`asis'" != "" {
		if !`is_bin' {
			di as err			///
"{p 0 0 2}"						///
"option asis not allowed;{break}"			///
"option asis is only allowed with family(binomial) "	///
"with a denominator of 1"				///
"{p_end}"
			exit 198
		}
		local is_bin 0
	}
	if !`fvops' {
		local is_bin 0
	}
	if `is_bin' {
		capture assert inlist(`y', 0, 1) if `touse'
		if c(rc) {
			local is_bin 0
		}
	}
	if "`display'" != "" & "`weight'" == "aweight" {
		/* aweights produce "sum of wgt" message,
		   which is not wanted for -nodisplay-
		*/
		local rmwgt [iw`exp']
		local rmcoll qui `rmcoll'
	}
	else {
		local rmwgt [`weight'`exp']
	}
	if `is_bin' {
		`rmcoll' `y' `xvars' `rmwgt' if `touse' , noskipline ///
			`coll' `constant' `fvexp' logit touse(`touse')
		local VARLIST `r(varlist)'
		gettoken y xvars : VARLIST
	}
	else {
		`rmcoll' `xvars' `rmwgt' if `touse',	///
			`coll' `constant' `fvexp'
		local xvars `r(varlist)'
	}

/* Get initial values. */

	global SGLM_V	`"`family'"'		/* V(mu) program */
	global SGLM_L	`"`link'"'		/* g(mu) g^(-1)(eta) program */
	global SGLM_A	`"`ancilla'"'		/* Ancillary params program */
	global SGLM_y	`"`y'"'			/* dep varname */
	global SGLM_m	`"`m'"'			/* Binomial denominator */

	if `"`k'"' == "ml" {
		qui nbreg `y' `xvars' if `touse' /*
		*/ [`weight'`exp'], `constant' `offopt' `mlopts'
		local k = e(alpha)
		global SGLM_ml = "ml"
	}

	global SGLM_a	`"`k'"'			/* Nbinom alpha */
	global SGLM_p	`"`pow'"'		/* Power, or argument */
						/* for user-defined link */
	global SGLM_f   `"`fisher'"'		/* Number of EIM iterations */
	global SGLM_mu                          /* Set in $SGLM_V -1 call */
	global SGLM_s1  `"`scale1'"'		/* Phi=1 indicator */
	/* Set titles, set range restrictions for mu, check sensibility of y */

	$SGLM_V -1 `touse'
	$SGLM_L -1 `touse'

	global SGLM_running 1

        if "$SGLM_V" == "glim_v1" | "$SGLM_V" == "glim_v3" | /*
	*/ "$SGLM_V" == "glim_v4" | "$SGLM_V" == "glim_v5" {
		if "$SGLM_L" == "glim_l02" | "$SGLM_L" == "glim_l04" | /*
		*/ "$SGLM_L" == "glim_l05" | "$SGLM_L" == "glim_l06" | /*
		*/ "$SGLM_L" == "glim_l07" | "$SGLM_L" == "glim_l08" | /*
		*/ "$SGLM_L" == "glim_l12" {
			global SGLM_nonstan 1
		}
	}
	if "$SGLM_V" == "glim_v2" {
		if "$SGLM_L" == "glim_l04" {
			global SGLM_nonstan 1
		}
	}
	if "$SGLM_V" == "glim_v6" {
		if "$SGLM_L" == "glim_l02" |  /*
                */ "$SGLM_L" == "glim_l05" | "$SGLM_L" == "glim_l06" | /*
                */ "$SGLM_L" == "glim_l07" | "$SGLM_L" == "glim_l08" | /*
                */ "$SGLM_L" == "glim_l12" {
                        global SGLM_nonstan 1
                }
	}

	*mllog contains `log' `nolog', passed to -ml model-
	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if `"`log'"'!=""	{
					local iflog `"*"'
				}
	else			{ local iflog "noi" }

	if "`offset'" != "" {
		local moffset = "-`offset'"
	}

	local reg = "$SGLM_V" == "glim_v1" & "$SGLM_L" == "glim_l01"
	/* Newton-Raphson optimization using ml commands */
	if "`irls'" == "" {
		tempvar  eta mu dmu v z W
		tempname Wscale b0
		if !inlist("`vce'", "eim", "opg") {
			local oim "oim"
		}
		if "`from'" == "" & "`search'" == "" {
			quietly {
				if `"`init'"'!="" {
					gen double `mu' = `init' if `touse'
				}
				else {
					sum `y' `wwt' if `touse'
					if "$SGLM_V" != "glim_v2" {
						gen double `mu' = /*
							*/ (`y'+r(mean))/(`m'+1)
					}
					else {
						gen double `mu' = /*
							*/ `m'*(`y'+.5)/(`m'+1)
					}
				}
				capture drop `eta'
				$SGLM_L 0 `eta' `mu'
				$SGLM_V 1 `eta' `mu' `v'
				$SGLM_L 2 `eta' `mu' `dmu'
				gen double `z' = `eta' + /*
					*/ (`y'-`mu')/`dmu' `moffset'
				gen double `W' = `dmu'*`dmu'/`v'
				summ `W' `wwt', meanonly
				scalar `Wscale' = r(mean)
				if "`cns'" != ""  & _caller() >= 11 {
					foreach c in `cns' {
						local c`c' : constraint `c'
						local c`c'new = subinstr( ///
							"`c`c''","[`y']","",.)
						constraint `c' `c`c'new'
					}
					`VV' ///
					cap noisily quietly cnsreg `z' /*
					*/ `xvars' [iw=`W'*`wt'/`Wscale'], /*
					*/  constr(`cns') mse1 `constant'
					foreach c in `cns' {
						constraint `c' `c`c''
					}
				}
				else {
					`VV' ///
					cap noisily quietly _regress `z' /*
					*/ `xvars' [iw=`W'*`wt'/`Wscale'], /*
					*/ mse1 `constant'
				}
				if e(N)>=. {exit 459}
				if _rc {exit _rc}

/*
		mat `b0' = e(b)
		local k = colsof(`b0')
		_regress `z' [iw=`W'*`wt'/`Wscale'], mse1 `constant'

		capture glm `y', fam(`family') link(`link') irls iter(2)
*/

				capture drop `eta'
				capture drop `mu'
				predict double `eta', xb
				$SGLM_L 1 `eta' `mu'
				$SGLM_mu `mu'
				mat `b0' = e(b)
				_post_vce_rank, checksize
				local k = e(rank)
				local from "`b0'"
				replace `z' = sum(`wt'*(`y'-`mu')^2/`v')
				global SGLM_ph = `z'[_N]/(`nobs'-`k')
			}
		}

		if "`from'" != "" & "`search'" == "" {
			local initopt `"init(`from') search(off)"'
		}
		else	local initopt `"search(on) maxfeas(100)"'
		if `reg' & `"`offopt'"'=="" {
			local iterate 0
			local nowarn "nowarning"
		}
		local initopt "`initopt' iter(`iterate') `nowarn' "

		if "`estscale'" != ""  &  "$SGLM_V" == "glim_v1" {
			local MM d0
			mat `b0' = e(b), $SGLM_ph
			local from "`b0'"
			local initopt `"init(`from', copy) search(off)"'
		}

		if `"`scale'"'=="" {    /* default */
			local scale `scale1'
			local cd
		}
		else if `scale'==0 {    /* Pearson X2 scaling */
			if `scale1' {
				local cd "square root of Pearson"
				local cd "`cd' X2-based dispersion"
			}
		}
		else {                  /* user's scale parameter */
			if !`scale1' | (`scale1' & `scale'!=1) {
				local cd "dispersion equal to square"
				local cd "`cd' root of `scale'"
			}
		}

		if `scale1' == 1 & `scale' != `scale1' {
			global SGLM_s1 = `scale1'
			local fixme 1
		}
		else {
			global SGLM_s1 = `scale'
			local fixme 0
		}

		/*
			        Need to handle k==N case separately
				This must be handled by ml because the
				variance matrix is missing. The irls
				works fine in this case.  Maybe the right
				thing to do is to just pass it on to the
				irls method since the variance matrix is
				missing anyway.
		*/
		tempname newdev

		if "`opg'`unbiased'" != "" {
			if "`scopt'" == "" {
				tempvar scvar
				local scopt score(`scvar')
			}
			if "`unbiased'" != "" {
				local cll "`clopt'"
				local robust
				local clopt
			}
		}

		if (!`iterate') { `iflog' di }

		global GLIST : all globals "SGLM_*"
		
		if "`estscale'" != ""  & "$SGLM_V" == "glim_v1" {
			local sigma2 /sigma2
			local glim_lf glim_lf_scale
			global SGLM_estscale 1
		}
		else {
			local glim_lf glim_lf
			global SGLM_estscale 0
		}

		`VV' ///
		ml model `MM' `glim_lf' /*
		*/ (`yname': `y' = `xvars', `constant' `offopt') `sigma2' /*
		*/ [`weight'`exp'] if `touse', collinear missing max nooutput /*
		*/ nopreserve `mlopts' title(Generalized linear models) /*
		*/ `scopt' `robust' `clopt' `mllog' `initopt' `trace' `negh' /*
		*/ `moptobj'
		local rc = cond(e(rc) == 430 & `reg', 0, e(rc))
		local vcetype `e(vcetype)'

		if $SGLM_estscale {
			global SGLM_ph _b[`sigma2'] 
		}

		if "`vce'" == "eim" {

nobreak {

			tempname esave
			version 9: estimates store `esave'

capture noisily break {

			capture drop `eta'
			capture drop `mu'
			capture drop `v'
			capture drop `dmu'
			capture drop `W'
			capture drop `z'
			quietly predict double `eta', xb
			$SGLM_L 1 `eta' `mu'
			$SGLM_V 1 `eta' `mu' `v'
			$SGLM_L 2 `eta' `mu' `dmu'
			gen double `W' = `dmu'*`dmu'/`v' if `touse'

			tempname V
			version 11: ///
			quietly matrix accum `V' = `xvars' ///
				[iw=`W'*`wt'], `constant'
			matrix `V' = inv(`V')

} // capture noisily break

			local rc = c(rc)
			quietly version 9: estimates restore `esave'
			version 9: ereturn local _estimates_name


} // nobreak
			if `rc' {
				version 9: ereturn clear
				exit `rc'
			}

			local vcetype "EIM"
			estimates repost V = `V'
		}

		if `fixme' {
			tempname V fix
			mat `V' = e(V)
			if `scale' { scalar `fix' = `scale' }
			else         scalar `fix' = $SGLM_ph
			mat `V' = `fix'*`V'
			estimates repost V = `V'
		}

		if "`vcetype'" == "OPG" | "`opg'" == "opg" {
			local vce    "opg"
		}
		else if "`vcetype'" == "" | "`vce'" == "oim" {
			local vce oim
			local vcetype "OIM"
		}

		if "`unbiased'" != "" {
			tempvar hat eta mu v dmu dv d2mu z W
			tempname  ll

			qui _predict double `eta', xb   /* sic -- no nooffset */
			qui $SGLM_L 1 `eta' `mu'
			qui $SGLM_V 1 `eta' `mu' `v'
			qui $SGLM_L 2 `eta' `mu' `dmu'

			qui gen double `z' = `eta' + /*
				*/ (`y'-`mu')/`dmu' `moffset' if `touse'

			qui $SGLM_V 2 `eta' `mu' `dv'
			qui $SGLM_L 3 `eta' `mu' `d2mu'
			qui gen double `W' = `dmu'*`dmu'/`v' - /*
				*/ (`mu'-`y')*(`dmu'*`dmu'*`dv'/(`v'*`v') - /*
				*/ `d2mu'/`v') if `touse'
			nobreak {
				estimates hold `ll'
				`VV' ///
				qui _regress `z' `xvars' [iw=`W'*`wt'], /*
					*/ mse1 `constant'
				qui _predict double `hat' if `touse', /*
					*/ stdp `offset'
				qui replace `hat' = `hat'*`hat'*`v'
				estimates unhold `ll'
			}

			qui replace `scvar' = `scvar' / sqrt(1-`hat')
			qui _robust2 `scvar' [fweight=`fwt'] if `touse', /*
				*/ `cll' minus(0)
			local setype  "Unbiased `setype'"
			local setype "Unbiased Sandwich"
			local vce     "unbiased"
			local vcetype "Unbiased"
		}

		if "`opg'" != "" {
			tempname V1
			mat `V1' = e(V)
			local nms : colnames `V1'
			local ncol = colsof(`V1')
			mat `V1' = I(`ncol')
			version 11: ///
			mat colnames `V1' = `nms'
			version 11: ///
			mat rownames `V1' = `nms'
			_robust2 `scvar' [fweight=`fwt'] if `touse', var(`V1')
			mat `V1' = syminv(`V1')
			estimates repost V = `V1'
			local vcetype "OPG"
		}

		if "`hacnam'" != "" {
			tempname V
			mat `V' = e(V)
			local p = colsof(`V')-1
			capture drop `eta'
			capture drop `mu'
			capture drop `v'
			capture drop `dmu'
			capture drop `z'
			qui _predict `eta', xb
			qui $SGLM_L 1 `eta' `mu'
			qui $SGLM_V 1 `eta' `mu' `v'
			qui $SGLM_L 2 `eta' `mu' `dmu'
			qui gen double `z' = `dmu'*(`y'-`mu')/`v'
			sort `touse' `tvar'
			qui HAC "`hacnam'" "`haclag'" "`wt'" "`z'" ///
				"`touse'" `"`constant'"' `"`xvars'"' "`intlag'"
			tempname vm
			mat `vm' = r(V)
			local pm1 = `p'+1
			`hacnam' `haclag' 0 `nobs' `pm1'
			local delta = 1
			if `scale1' == 0 {
				local delta = $SGLM_ph
			}
			tempname ss
			scalar `ss' = 1/(`delta'*`delta')
			mat `V' = `ss'*`V'*`vm'*`V''
			local hac_kern "`r(setype)'"
			local vce "hac"
			local vcetype "HAC"
			estimates repost V = `V'
		}
		if "`jknife1'" != "" {
			tempname b V
			mat `b' = e(b)
			mat `V' = e(V)
			qui JK1nr `b' `V' `y' "`xvars'" `eta' `mu' `v' `dmu' /*
				*/ "`tvar'" `z' "`moffset'" "`constant'" /*
				*/ `wt' `touse' "`weight'"
			local p = colsof(`b')
			tempname ss
			scalar `ss' = (`nobs'-`p')/`nobs'
			mat `V' = `ss'*`V'
			local vce	"jackknife1"
			local vcetype	"1-step JKnife"
			estimates repost V = `V'
		}
		if "`jknife'" != "" {
			tempname b V
			mat `b' = e(b)
			mat `V' = e(V)
			noi JKnife `b' `V' `y' "`xvars'" "`tvar'" /*
				*/ "`offopt'" "`constant'" "`argfam'" "" /*
				*/ "`arglink'" "[`weight'`exp']" `touse' /*
				*/ "`cluster'" `dots' "`weight'" "`wt'"
			local mm = `nobs'
			if "`cluster'" != "" { local mm = $SGLM_nc }
			else local mm = 1
			local p = colsof(`b')
			local nnn = `nobs'-$SGLM_bm
			tempname ss
			if "`cluster'" != "" {
				scalar `ss' = (`nnn'-`p')/`nnn'
			}
			else {
				scalar `ss' = (`nnn'-`p')/`nnn'
			}
			mat `V' = `ss'*`V'
			local vcetype "Jackknife"
			estimates repost V = `V'
		}
		if "`bstrap'" != "" {
			tempname b V
			mat `b' = e(b)
			mat `V' = e(V)
			noi Bstrap `b' `V' `y' "`xvars'" /*
				*/ "`offopt'" "`constant'" "`argfam'" "" /*
				*/ "`arglink'" "[`weight'`exp']" `touse' /*
				*/ `brep' "`clopt'" `dots'
			local p = colsof(`b')
			tempname ss
			scalar `ss' = (`nobs'-`p')/(`nobs'*(`brep'-$SGLM_bm))
			mat `V' = `ss'*`V'
			local vcetype "Bootstrap"
			estimates repost V = `V'
		}
		if `vfactor' != 1 {
			tempname V
			mat `V' = `vfactor'*e(V)
			estimates repost V = `V'
		}

		capture drop `eta'
		capture drop `mu'
		capture drop `v'
		qui predict double `eta', xb
		qui $SGLM_L 1 `eta' `mu'
		qui $SGLM_mu `mu'
		qui $SGLM_V 1 `eta' `mu' `v'
		mat `b0' = e(b)
		local dfm = e(df_m)
		capture drop `z'
		qui gen double `z' = sum(`wt'*(`y'-`mu')^2/`v')
		local chi2  = `z'[_N]
		local df = e(N)-`dfm'

		_post_vce_rank, checksize
		local rank = e(rank)
		if $SGLM_s1 { global SGLM_ph = $SGLM_s1 }

		capture drop `z'
		qui $SGLM_V 3 `eta' `mu' `z'
		qui replace `z' = sum(`wt'*`z')
		scalar `newdev' = `z'[_N]
		local disp  = $SGLM_ph
		est scalar vf = `vfactor'
		est scalar rc = `rc'
		if "`oldIC'"!="" {
			est scalar aic = (-2*e(ll)+2*`rank')/`nobs'
		}
		else est scalar aic = (-2*e(ll)+2*`rank')
	}
	/* Classical IRLS */
	else {
		if `"`mlopts'"' != "" {
			// mlopts are not allowed with -irls-
			local 0 `", `mlopts'"'
			syntax [, NOOPTION ]
			error 198		// [sic]
		}
		quietly {
			tempvar  eta mu dmu v W z
			tempname Wscale b0
			if "`offset'" != "" {
				local moffset = "-`offset'"
			}
			if `"`init'"'!="" {
				gen double `mu' = `init' if `touse'
			}
			else {
				summ `y' `wwt' if `touse', mean
				if "$SGLM_V" != "glim_v2" {
					gen double `mu' = (`y'+r(mean))/(`m'+1)
				}
				else {
					gen double `mu' = `m'*(`y'+.5)/(`m'+1)
				}
			}

			if `reg' { local iterate 1 }

			capture drop `eta'
			$SGLM_L 0 `eta' `mu'
			tempvar dev
			tempname newdev oldev
			scalar `oldev'  =  0
			scalar `newdev' =  1
			local i 1
			if `iterate' == 0 { local i 0 }
			`iflog' di
			while abs(`newdev'-`oldev')>`ltol' & `i'<=`iterate' {
				capture drop `v'
				capture drop `dmu'
				capture drop `W'
				capture drop `z'
				scalar `oldev' = `newdev'
				$SGLM_V 1 `eta' `mu' `v'
				$SGLM_L 2 `eta' `mu' `dmu'
				gen double `z' = `eta' + /*
					*/ (`y'-`mu')/`dmu' `moffset' if `touse'
				gen double `W' = `disp'*`dmu'*`dmu'/`v' /*
					*/ if `touse'
				summ `W' `wwt', meanonly
				scalar `Wscale' = r(mean)

				`VV' ///
				cap noisily  quietly _regress `z' `xvars' /*
				*/   [iw=`W'*`wt'/`Wscale'], mse1 `constant'
				if e(N)>=. {exit 459}
				if _rc {exit _rc}
				capture drop `eta'
				capture drop `mu'
				capture drop `dev'
				predict double `eta' if `touse', xb
				if "`offset'" != "" {
					replace `eta' = `eta'+`offset'
				}
				$SGLM_L 1 `eta' `mu'
				$SGLM_mu `mu'
				$SGLM_V 3 `eta' `mu' `dev'
				replace `dev' = sum(`wt'*`dev')
				scalar `newdev' = `dev'[_N]/`disp'
				`iflog' di as txt /*
					*/ `"Iteration `i':"' _col(16) /*
					*/ "deviance = " /*
					*/ as res %9.0g `newdev'
				if "`trace'" != "" {
					tempname beta
					`iflog' mat list e(b), noblank noheader
					`iflog' di as txt "{hline 78}"
					`iflog' di
				}
				local ic = `i'
				local i = `i'+1
			}
			if "`unbiased'`jknife1'`jknife'" != "" {
				`VV' ///
				cap noisily quietly _regress `z' `xvars' /*
					*/ [iw=`W'*`wt'], /*
					*/ mse1 `constant'
				if e(N)>=. {exit 459}
				if _rc {exit _rc}
				tempvar h
				qui _predict double `h' if `touse', stdp
				qui replace `h' = `h'*`h'*`v'
				local minus "minus(0)"
			}
			else    local h = 0
			local rc = cond(abs(`newdev'-`oldev')>`ltol' /*
				*/ & !`reg',430,0)
			replace `z' = sum(`wt'*(`y'-`mu')^2/`v')
			local chi2  = `z'[_N]/`disp'
			local p     = e(df_m)
			local df    = `nobs'-`p'-(`"`constant'"'=="")
			local dispc = `chi2'/`df'
			local dispd = `newdev'/`df'

			global SGLM_ph = `dispc'

			/* Apply appropriate scaling */

			if `"`scale'"'=="" {    /* default */
				local scale `scale1'
				if `scale1' { local delta 1 }
				else local delta `dispc'
			}
			else if `scale'==0 {    /* Pearson X2 scaling */
				local delta `dispc'
				if `scale1' {
					local cd "square root of Pearson"
					local cd "`cd' X2-based dispersion"
				}
			}
			else if `scale'==-1 {   /* deviance scaling */
				local delta `dispd'
				local cd "square root of deviance-based"
				local cd "`cd' dispersion"
			}
			else {                  /* user's scale parameter */
				local delta `scale'
				if !`scale1' | (`scale1' & `scale'!=1) {
					local cd "dispersion equal to square"
					local cd "`cd' root of `delta'"
				}
			}
			if !`scale1' | (`scale1' & `scale'!=1) {
				if `scale1' { local dof 100000 }
				else local dof `df'
				if `delta'>=. {
					local zapse "yes"
				}
				else {
					scalar `Wscale' = `Wscale'/`delta'
				}
			}

			tempname b V
			mat `b' = e(b)
			mat `V' = e(V)

			local vce     "eim"
			local vcetype "EIM"
			if "`robust'`oim'`hacnam'`opg'" != ""  {
				capture drop `W'
				capture drop `z'
				capture drop `v'
				capture drop `dmu'

				tempvar xb
				_predict double `xb', xb /* sic--no nooffset */
				$SGLM_V 1 `eta' `mu' `v'
				$SGLM_L 2 `eta' `mu' `dmu'

				tempvar ys yi
				gen double `ys' = `dmu'*(`mu'-`y')/`v'
				gen double `yi' = `dmu'*`dmu'
				if "`oim'" != "" {
					tempvar dv d2m
					$SGLM_V 2 `eta' `mu' `dv'
					$SGLM_L 3 `eta' `mu' `d2m'
					replace `yi' = `yi' + /*
						*/ `d2m'*(`mu'-`y') - /*
						*/ `dmu'*`dv'*`ys'
				}
				replace `yi' = `awt' * `yi' / `v'
				replace `ys' = `awt' * `ys' / sqrt(1-`h')

				`VV' ///
				_regress `xb' `xvars' if `touse' /*
					*/ [iweight=`fwt'*`yi'], `constant' mse1
				mat `V' = e(V)
				local vce     "oim"
				local vcetype "OIM"
				if "`robust'" != "" {
					tempname vmb
					matrix `vmb' = e(V)
					if "`oim'" != "" {
						local vce     "robust"
						local vcetype "Robust"
					}
					else {
						local vce "robust"
						if (`canon'==0) { 
							local vcetype ///
							"Semirobust"
						}
						else {
							local vcetype ///
							"Robust"
						}
					}
					_robust2 `ys' [fweight=`fwt'] /*
						*/ if `touse', var(`V') /*
						*/ `clopt' `minus'
					if "`unbiased'" != "" {
						local setype "Unbiased Sandwich"
						local vce    "unbiased"
						local vcetype "Unbiased"
					}
					if `"`clopt'"' != "" {
						global SGLM_nc = r(N_clust)
					}
				}
				else if "`opg'" != "" {
					local nms : colnames `V'
					local ncol = colsof(`V')
					mat `V' = I(`ncol')
					version 11: ///
					mat colnames `V' = `nms'
					version 11: ///
					mat rownames `V' = `nms'
					replace `ys' = `ys'/`disp'
					_robust2 `ys' [fweight=`fwt'] /*
						*/ if `touse', var(`V')
					mat `V'=`delta'*`delta'*syminv(`V')
					local vce     "opg"
					local vcetype "OPG"
				}
				else if "`hacnam'" == "" {
					tempname ss
					scalar `ss' = `delta'*`Wscale'
					mat `V' = `ss'*`V'
				}
			}

			if "`hacnam'" != "" {
				capture drop `v'
				capture drop `dmu'
				capture drop `z'
				$SGLM_V 1 `eta' `mu' `v'
				$SGLM_L 2 `eta' `mu' `dmu'
				gen double `z' = `dmu'*(`y'-`mu')/`v'
				sort `touse' `tvar'
				qui HAC "`hacnam'" "`haclag'" "`wt'" "`z'" ///
					"`touse'" `"`constant'"' ///
					`"`xvars'"' "`intlag'"
				tempname vm
				mat `vm' = r(V)
				local pm1 = `p'+1
				`hacnam' `haclag' 0 `nobs' `pm1'
				local hac_kern "`r(setype)'"
				local vce "hac"
				local vcetype "HAC"
				local ddd = 1
				tempname ss
				scalar `ss' = 1/(`ddd'*`ddd')
				mat `V' = `ss'*`V'*`vm'*`V''
			}

			if "`jknife1'" != "" {
				JK1irls `b' `V' `y' "`xvars'" `h' `eta' /*
					*/ `mu' `v' `dmu' "`tvar'" `z' /*
					*/ "`moffset'" "`constant'"  /*
					*/ `wt' `touse' "`weight'"
				local p = colsof(`b')
				tempname ss
				scalar `ss' = (`nobs'-`p')/`nobs'
				local vce     "jackknife1"
				local vcetype "1-step JKnife"
				mat `V' = `ss'*`V'
			}

			if "`jknife'" != "" {
				noi JKnife `b' `V' `y' "`xvars'" "`tvar'" /*
					*/ "`offopt'" "`constant'" /*
					*/ "`argfam'" "irls" "`arglink'" /*
					*/ "[`weight'`exp']" `touse' /*
					*/ "`cluster'" `dots' "`weight'" "`wt'"
				local mm = `nobs'
				local vcetype "Jackknife"
				if "`cluster'" != "" { local mm = $SGLM_nc }
				else local mm=1
				local p = colsof(`b')
				local nnn = `nobs'-$SGLM_bm
				tempname ss
				scalar `ss' = (`nnn'-`p')/(`nnn'*`mm')
				mat `V' = `ss'*`V'
			}
			if "`bstrap'" != "" {
				tempname b V
				mat `b' = e(b)
				mat `V' = e(V)
				noi Bstrap `b' `V' `y' "`xvars'" "`offopt'" /*
					*/ "`constant'" "`argfam'" "irls" /*
					*/ "`arglink'" "[`weight'`exp']" /*
					*/ `touse' `brep'       /*
					*/ "`clopt'" `dots'
				local vcetype "Bootstrap"
				if "`cluster'" != "" { local mm = $SGLM_nc }
				else local mm=1
				local p = colsof(`b')
				tempname ss
				scalar `ss' = (`nobs'-`p')/(`nobs'*(`brep'-$SGLM_bm))
				mat `V' = `ss'*`V'
			}

					/* get rid of `Wscale' scaling */

			if "`opg'`hacnam'`robust'`jknife'`jknife1'`bstrap'" == ""  {
				scalar `Wscale' = 1/`Wscale'
				mat `V' = `Wscale'*`V'
			}

			if `"`zapse'"'=="yes" {
				local i 1
				while `i'<=rowsof(`V') {
					mat `V'[`i',`i'] = 0
					local i=`i'+1
				}
			}

			if `vfactor' != 1 {
				mat `V' = `vfactor'*`V'
			}

			tempvar mysamp
			local k = colsof(`b')
			qui gen byte `mysamp' = `touse'
			est post `b' `V' [`weight'`exp'],	///
				depname(`y') obs(`nobs')	///
				`dofopt' esample(`mysamp')	///
				buildfvinfo
			if `:length local vmb' {
				est matrix V_modelbased `vmb'
			}
			est local depvar "`y'"
			est local wtype "`weight'"
			est local wexp  "`exp'"
			est local title "Generalized linear models"
			est scalar rc = `rc'
			est scalar disp = `disp'
			est scalar k = `k'
			est hidden scalar ic = `ic'
			est hidden local crittype "deviance"
		}
		est hidden scalar noconstant = cond("`constant'" == "",0,1)
		est hidden scalar consonly = cond("`xvars'"!="",0,1)
	}

	mac drop SGLM_running SGLM_nonstan

	if "`score'" != "" {
		label var `scvar' "Score index from glm"
		rename `scvar' `score'
		est local scorevars `score'
	}

	_post_vce_rank
	local dfm = e(rank)- (`"`constant'"'=="")
	local df = `nobs'-e(rank)

	est local link      "$SGLM_L"
	est local varfunc  "$SGLM_V"
	est local m	   "$SGLM_m"
	est hidden local a "$SGLM_a"
	est hidden local msg      "`cd'"
	est hidden scalar canonical = `canon'
	est local cons	   "`constant'"
	est hidden local oim "`oim'"
	est local clustvar "`cluster'"
 	capture confirm number $SGLM_p
	if !_rc {
		est scalar power = $SGLM_p
	}
	else {
                version 15: ereturn hidden local power `"$SGLM_p"'
	}

	if "$SGLM_V" == "glim_v2" & "$SGLM_L" == "glim_l01" & "`eform'" == "" {
		est hidden local msg2 "Coefficients are the risk differences"
	}
	if "`irls'" != "" {
		est local opt irls
		if "`oim'" == "" {
			est local opt1 "MQL Fisher scoring"
			est local opt2 "(IRLS EIM)"
		}
		else  {
			est local opt1 "MQL Newton-Raphson"
			est local opt2 "(IRLS OIM)"
		}
	}
	else {
		*est local opt = "ml"	// already set by -ml-
		est local opt1 "ML"
		est local opt2
		if "`vce'" == "eim" & `disp' != 1 {
			matrix `V' = `disp'*e(V)
			est repost V = `V'
		}
	}
	if "$SGLM_bm" != "" {
		if $SGLM_bm > 0 { est scalar Nf = $SGLM_bm }
	}
	est scalar df_m = `dfm'
	est scalar df = `df'
	if "$SGLM_nc" != "" {
		est scalar N_clust = $SGLM_nc
	}
	if `brep' > 0 {
		est scalar N_brep  = `brep'
	}

	est scalar vf             = `vfactor'
	est scalar phi            = `disp'
	est scalar deviance       = abs(`newdev')
	est scalar dispers        = e(deviance)/e(df)
	est scalar deviance_s     = e(deviance)/e(phi)
	est scalar dispers_s      = e(deviance_s)/e(df)
	est scalar deviance_p     = abs(`chi2')
	est scalar dispers_p      = e(deviance_p)/e(df)
	est scalar deviance_ps    = e(deviance_p)/e(phi)
	est scalar dispers_ps     = e(deviance_ps)/e(df)

	capture drop `v'
	qui gen double `v' = sum((`y'-`mu')^2) if `touse'

	if "`oldIC'" != "" | "`irls'" != "" {	
		est scalar bic = e(deviance) - `df'*log(`nobs')
	}
	else  est scalar bic = -2*e(ll)+log(`nobs')*`p'

	est local varfuncf "$SGLM_vf"
	est local varfunct "$SGLM_vt"
	est local linkf "$SGLM_lf"
	est local linkt "$SGLM_lt"
	if "`cluster'" != "" {
		est local vce "cluster"
	}
	else {
		est local vce "`vce'"
	}
	est local vcetype "`vcetype'"

	est local setype  "`setype'"
	est local hac_kernel "`hac_kern'"
	est local hac_lag "`haclag'"

	est local offset  "`offvar'"
	est local offset1 /* erase; set by -ml- */
	est scalar k_eq_model = 0
	est local marginsok	default
	est local marginsnotok	stdp		///
				Anscombe	///
				Cooksd		///
				Deviance	///
				Hat		///
				Likelihood	///
				Pearson		///
				Response	///
				Score		///
				Working		///
				ADJusted	///
				STAndardized	///
				STUdentized	///
				MODified
	est local predict "glim_p"
	est local cmd     "glm"

	capture mac drop SGLM_bm SGLM_nc

	if "$SGLM_V" == "glim_v2" {
		if "$SGLM_L" == "glim_l01" | "$SGLM_L" == "glim_l03" {
			CheckAdmiss
		}
	}

	est scalar nbml = `"$SGLM_ml"' == "ml"

	if "`display'" == "" {
		Display, `eform' level(`level') `header' `table' `diopts'
	}
	error `e(rc)'
end

program GetVCE
	version 9
	syntax [fw aw iw pw] [,		///
		IRLS			///
		BSTRAP			/// old vcetype specification
		BREP(integer -1)	///
		JKNIFE			///
		JKNIFE1			///
		NWEST(string)		///
		OIM			///
		OPG BHHH		///
		UNBiased		///
		VCE(string)		/// new vcetype specification
		VCE1(string)		///
		VCE2(string)		///
		CLuster(varname)	///
		Robust			///
		*			///
	]
	if "`weight'" != "" {
		local wt [`weight'`exp']
	}
	local len : length local vce
	if "`vce'" == bsubstr("unbiased", 1, max(3,`len')) {
		local vce : copy local vce1
		local vce1 : copy local vce2
		local vce2
		local unbiased "unbiased"
	}
	local len : length local vce1
	if "`vce1'" == bsubstr("unbiased", 1, max(3,`len')) {
		local vce1 : copy local vce2
		local vce2
		local unbiased "unbiased"
	}
	local len : length local vce2
	if "`vce2'" == bsubstr("unbiased", 1, max(3,`len')) {
		local vce2
		local unbiased "unbiased"
	}
	if "`vce2'" != "" {
		di as err "too many vce() options specified"
		exit 198
	}
	// -bhhh- is a synonym for -opg-
	if ("`bhhh'" != "")	local opg opg
	local oldvce `bstrap' `jknife' `jknife1' `opg' `unbiased'
	if ("`nwest'" != "")	local oldvce `"`oldvce' nwest(`newst')"'
	opts_exclusive "`oldvce'"

	if "`irls'" == "" {
		local allow eim
	}
	else {
		local allow eim oim
	}

	local optlist EIM OIM OPG Robust jackknife1 jknife1 UNBiased NATIVE
	local argoptlist CLuster HAC
	_vce_parse, opt(`optlist') argopt(`argoptlist') pw(`allow') old	///
		: `wt',	vce(`vce') cluster(`cluster') `robust'
	if "`r(vce)'" != "" {
		if "`r(cluster)'" != "" {
			local cluster `r(cluster)'
			local vce `r(vce)'
		}
		else	local vce `r(vce)' `r(vceargs)'
	}
	_vce_parse, opt(`optlist') argopt(`argoptlist') old :, vce(`vce1')
	if "`r(vce)'" != "" {
		local vce1 `r(vce)' `r(vceargs)'
	}

	// verify -vce(vcetype)-
	if `"`vce'`vce1'"' != "" {
		if `"`vce1'"' != "" {
			// NOTE: only -vce(oim)- or -vce(eim)- can be used
			// jointly with another -vce()- option
			if !inlist("oim",`"`vce'"',`"`vce1'"')	///
			 & !inlist("eim",`"`vce'"',`"`vce1'"') {
				opts_exclusive "vce(`vce') vce(`vce1')"
			}
			else if !inlist("oim",`"`vce'"',`"`vce1'"') {
				local eim eim
			}
			else if !inlist("eim",`"`vce'"',`"`vce1'"') {
				local oim oim
			}
			else {
				opts_exclusive "vce(`vce') vce(`vce1')"
			}
			local vce `vce' `vce1'
			local vce : list vce - oim
			local vce : list vce - eim
			local vce1	// clear
		}
		if `"`vce'"' == "oim" {
			local oim oim
		}
		if `"`vce'"' == "eim" {
			local eim eim
		}
		// check for a conflict between old and new vce() options
		if !("`vce'"=="robust" & "`oldvce'"=="unbiased") ///
		 & !("`vce'"=="cluster" & "`oldvce'"=="unbiased") ///
		 & !inlist("`oldvce'", "", "`vce'")	///
		 & !inlist("`vce'", "", "oim", "eim") {
			opts_exclusive `"vce(`vce') `oldvce'"'
		}
		if !inlist("`vce'", "", "cluster") {
			MapVCE "`irls'" `vce'
			if `"`s(vce)'"' != "" {
				local vce `s(vce)'
				local `vce' `s(vcespec)'
			}
			if `"`s(vceopt)'"' != "" {
				local options `"`options' `s(vceopt)'"'
			}
		}
	}
	else {
		if "`nwest'" != "" {
			local hac `"`nwest'"'
		}
	}

	c_local bstrap		`"`bstrap'"'
	c_local brep		`"`brep'"'
	c_local jknife		`"`jknife'"'
	c_local jknife1		`"`jknife1'"'
	c_local hac		`"`hac'"'
	c_local oim		`"`oim'"'
	c_local opg		`"`opg'"'
	c_local unbiased	`"`unbiased'"'
	if "`robust'" != "" {
		c_local robust	`"`robust'"'
	}
	c_local vce		`"`vce'"'
	c_local cluster		`"`cluster'"'
	c_local options		`"`options'"'
end

program MapVCE, sclass
	// "<irls>" <vcetype> [,] [<vcerest>]
	gettoken irls 0 : 0
	local 0 : list retok 0
	gettoken vce vcerest: 0, parse(", ")
	local vcerest : list retok vcerest
	local len : length local vce
	if inlist(`"`vce'"', "jknife1", "jackknife1") {
		local norest norest
		local vce jknife1
		local vcespec jknife1
	}
	else if `"`vce'"' == "hac" {
		if `"`vcerest'"' == "" {
			di as err "option vce(hac) misspecified"
			exit 198
		}
		local vcespec `"`vcerest'"'
		local vcerest
	}
	else if `"`vce'"' == bsubstr("robust",1,max(1,`len')) {
		local norest norest
		local vce robust
		local vcespec robust
	}
	else if `"`vce'"' == bsubstr("unbiased",1,max(3,`len')) {
		local norest norest
		local vce unbiased
		local vcespec unbiased
	}
	else if `"`vce'"' == "eim" {
		local norest norest
		local vce eim
		local vcespec eim
	}
	else {
		if `"`vce'"' == "oim" {
			local norest norest
			local vcespec oim
		}
		else if `"`vce'"' == "opg" {
			local norest norest
			local vcespec opg
		}
		else if `"`0'"' != "" {
			if "`irls'" != "" {
				di as err ///
				"option vce(`0') is not allowed with irls"
				exit 198
			}
			else {
				local vceopt `"vce(`0')"'
			}
		}
	}
	if "`norest'" != "" & `"`vcerest'"' != "" {
		di as err "option vce(`0') invalid"
		exit 198
	}
	sreturn local vce	`"`vce'"'
	sreturn local vcespec	`"`vcespec'"'
	sreturn local vceopt	`"`vceopt'"'
end

program CheckAdmiss, eclass
	tempvar eta

	qui predict double `eta', eta

	if "`e(link)'" == "glim_l01" {
		cap assert `eta' >= 0 & `eta' <=1 if e(sample)
		local rc = _rc
	}
	else {
		cap assert `eta' <= 0 if e(sample)
		local rc = _rc
	}
	if `rc' {
		est local adm_warn warn
	}
	exit
end

program Display
	if "`e(prefix)'" == "svy" {
		_prefix_display `0'
		exit
	}

	di
	syntax [, noHEADer noTABLE Level(cilevel) eform *]

	_get_diopts diopts, `options'
	if "`eform'" != "" {
		Eform
		local eform  "`r(eform)'"
	}
	if "`eform'" != "" {
		local eopt "eform(`eform')"
	}

	if "`header'" == "" { Head }

	if "`table'"   != "" { exit }

	_coef_table , level(`level') `eopt' first `diopts'
	if "`e(msg)'" != "" {
		noi di as txt "(Standard errors scaled using `e(msg)'.)"
	}
	if "`e(msg2)'" != "" {
		noi di as txt "`e(msg2)'."
	}
	if "`e(adm_warn)'" != "" {
noi di "{help j_glmadmiss##|_new:Warning: parameter estimates produce }" _c
noi di "{help j_glmadmiss##|_new:inadmissible mean estimates in one or }"
noi di "{help j_glmadmiss##|_new:         more observations.}"
	}
	if "`e(Nf)'" != "" {
		if `e(Nf)' > 1 { local s "s" }
		noi di as txt "(" as res `e(Nf)' as txt /*
			*/ " model`s' failed to converge)"
	}
	if `e(nbml)' {
		di as txt "{p 0 6 0 79}Note: Negative binomial " 
		di as txt "parameter estimated via ML and treated "
		di as txt "as fixed once estimated."
	}
	_prefix_footnote
end

program Head
/*
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---
Generalized linear models                         Number of obs   = ##########
Optimization     : ##########################     Residual df     = ##########
                   ##########################     Scale parameter = ##########
Deviance         = #########                      (1/df) Deviance = ##########
Pearson          = #########                      (1/df) Pearson  = ##########

Variance function: V(u) = ###################     ############################
Link function    : g(u) = ###################     ############################

Standard errors  : ##########################     
HAC kernel (lags): Newey-West (72)
                                                  AIC             = ##########
Log likelihood   = ############                   BIC             = ##########

-or-

Generalized linear models                         Number of obs   = ##########
Optimization     : ##########################     Residual df     = ##########
                   ##########################     Scale parameter = ##########
Deviance         = #########                      (1/df) Deviance = ##########
Pearson          = #########                      (1/df) Pearson  = ##########

Variance function: V(u) = ###################     ############################
Link function    : g(u) = ###################     ############################

Standard errors  : ##########################     
HAC kernel (lags): Newey-West (72)

Quasi-likelihood model with dispersion: #####     BIC             = ##########
*/
	di as txt "Generalized linear models" /*
		*/ _col(51) "Number of obs"     _col(67) "=" /*
		*/ _col(69) as res %10.0gc e(N)
	di as txt "Optimization     : " as res "`e(opt1)'" /*
		*/ as txt _col(51) "Residual df" _col(67) "=" /*
		*/ _col(69) as res %10.0gc e(df)

	di as res _col(20) "`e(opt2)'" as txt _col(51) "Scale parameter"  /*
		*/ _col(67) "="  _col(70) as res %9.0g e(phi)

	di as txt "Deviance" _col(18) "=" as res _col(20) %12.0g e(deviance) /*
		*/ as txt _col(51) "(1/df) Deviance" /*
		*/ _col(67) "=" as res _col(70) %9.0g e(dispers)
	di as txt "Pearson" _col(18) "=" as res _col(20) %12.0g e(deviance_p) /*
		*/ as txt _col(51) "(1/df) Pearson" /*
		*/ _col(67) "=" as res _col(70) %9.0g e(dispers_p)

	di
	if `"$SGLM_ml"' == "ml" {
		di as txt "Variance function: " as res "V(u) = " /*
			*/ as res _col(27) "`e(varfuncf)'" /*
			*/ _col(51) as txt "[" as res "`e(varfunct)'" as txt "]"
	}
	else {
 		di as txt "Variance function: " as res "V(u) = " /*
                        */ as res _col(27) "`e(varfuncf)'" /*
                        */ _col(51) as txt "[" as res "`e(varfunct)'" as txt "]"

	}
	di as txt "Link function    : " as res "g(u) = " /*
		*/ as res _col(27) "`e(linkf)'" /*
		*/ _col(51) as txt "[" as res "`e(linkt)'" as txt "]"

	if "`e(hac_kernel)'" != "" {
		di
		di as txt "HAC kernel (lags): " ///
			e(hac_kernel) " ({yellow:`e(hac_lag)'})" _c
		local di di
	}
	else if "`e(setype)'" != "" {
		di
		di as txt "Standard errors  : " as res "`e(setype)'" _c
		local di di
	}
	else	local cr _n

	if "`e(ll)'" != "" {
		local cr
		di
		local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + ///
			bsubstr(`"`e(crittype)'"',2,.)
		local crlen = max(18,length(`"`crtype'"') + 2)
		di as txt _col(51) "{help j_glmic##|_new:AIC}" _col(67) "=" ///
			as res _col(70) %9.0g e(aic)
		di as txt "`crtype'" _col(`crlen') "= " ///
			as res %12.0g e(ll) _c
	}
	else if "`e(disp)'" != "" & "`e(disp)'" != "1" {
		local cr
		`di'
		di
		di as txt "Quasi-likelihood model with dispersion: " /*
			*/ as res `e(disp)' _c
	}
	if "`e(ll)'" != "" {
		di as txt `cr' _col(51) "{help j_glmic##|_new:BIC}" ///
			  _col(67) "=" as res _col(70) %9.0g e(bic)
	}
	else {
		di as txt `cr' _col(51) "BIC" _col(67) "=" ///
			  as res _col(70) %9.0g e(bic)
	}
	di
end

program MapHAC, rclass /* f [lag] */
	args nobs f lag

        local f = lower(trim(`"`f'"'))
        local l = length(`"`f'"')

	local s1
	local s2
	local intlag 0     // Anderson and user-defined lags are allowed to 
	                   // be non-integer and as large as you want
			   // But, the default lag is still _N - 2
        if `"`f'"'==""                                   { local s1 "" }
        else if `"`f'"'==bsubstr("nwest",1,max(`l',2))    { 
		local s1 "glim_nw1" 
		local intlag 1
	}
        else if `"`f'"'==bsubstr("bartlett",1,max(`l',2)) { 
		local s1 "glim_nw1" 
		local intlag 1
	}
        else if `"`f'"'==bsubstr("gallant",1,max(`l',2))  { 
		local s1 "glim_nw2" 
		local intlag 1 
	}
        else if `"`f'"'==bsubstr("parzen",1,max(`l',2))   { 
		local s1 "glim_nw2" 
		local intlag 1
	}
        else if `"`f'"'==bsubstr("anderson",1,max(`l',2)) { local s1 "glim_nw3" }
	else                                             { local s1 "`f'" }

	if "`lag'" != "" {
		if `intlag' {
			confirm integer number `lag'
		}
		if `lag' < 0 {
			noi di as err "Newey-West lag must be positive"
			exit 198
		}
	}
	else local lag = `nobs'-2

	if `lag' >= `nobs'-2 & `intlag' {
		local lag = `nobs'-2
	}
	local s2 `lag'

	ret local hacnam "`s1'"
	ret local haclag "`s2'"
	ret local intlag "`intlag'"
end

program MapFL, rclass /* family link */
        args f ulink

        MapFam `f'                      /* map user-specified family    */
        local fam `"`r(famcode)'"'      /* store program in fam         */

        local mfixed 1
        local m 1
        local k 1
        if `"`fam'"'=="glim_v2" {           /* bin takes an optional argument */
                tokenize `"`f'"'
                if `"`2'"'!="" {
                        capture confirm number `2'
                        if _rc {
                                unabbrev `2'
                                local m `"`s(varlist)'"'
                                local mfixed 0
                        }
                        else {
                                if `2'>=. | `2'<1 {
                                        di as err /*
                                     */ `"`2' in family(binomial `2') invalid"'
                                        exit 198
                                }
                                local m `2'
                        }
                }
		if `"`3'"'!="" {
			di as err "family(`f') invalid"
			exit 198
		}
        }
        if `"`fam'"'=="glim_v6" {    /* nb takes an optional argument */
                tokenize `"`f'"'
                if `"`2'"' != "" {
			if `"`2'"' != "ml" {
                        	confirm number `2'
                        	if `2'<=0 {
                                	di as err /*
                                	*/ `"`2' in family(nbinomial `2') invalid"'
                                	exit 198
                        	}
			}
                        local k `2'
                }
		if `"`3'"'!="" {
			di as err "family(`f') invalid"
			exit 198
		}
        }
	if `"`fam'"'~="glim_v1" & `"`fam'"'~="glim_v2" & /*
	*/ `"`fam'"'~="glim_v3" & `"`fam'"'~="glim_v4" & /*
	*/ `"`fam'"'~="glim_v5" & `"`fam'"'~="glim_v6" {
		tokenize `"`f'"'
		if `"`2'"' != "" {
			global SGLM_fa `2'
		}
		if `"`3'"'!="" {
			di as err "family(`f') invalid"
			exit 198
		}
	}
	MapLink `ulink'
        local link `"`r(link)'"'
        local pow `"`r(power)'"'
        local scale1 = `"`fam'"'=="glim_v2" | /*
			*/ `"`fam'"'=="glim_v3" | `"`fam'"'=="glim_v6"

        if `"`link'"'=="" {             /* apply defaults */
                local link "glim_l11"
                if `"`fam'"'=="glim_v1"      { local link "glim_l01"
					       local pow 1           }
                else if `"`fam'"'=="glim_v2" { local link "glim_l02"
					       local pow 0           }
                else if `"`fam'"'=="glim_v3" { local link "glim_l03"
					       local pow  0          }
                else if `"`fam'"'=="glim_v4" { local link "glim_l09"
					       local pow -1          }
                else if `"`fam'"'=="glim_v5" { local link "glim_l10"
					       local pow -2          }
                else if `"`fam'"'=="glim_v6" { local link "glim_l03"
					       local pow  0          }
                else local link
        }

        ret local family `"`fam'"'
        ret local link   `"`link'"'
        ret local power  `pow'
        ret local scale  `scale1'
        ret local m      `m'
        ret local mfixed `mfixed'
        ret local k      `k'
end


program MapFam, rclass /* <code> */
	args f

        local s1
        local f = lower(trim(`"`f'"'))
        local l = length(`"`f'"')

        if `"`f'"'==""                                    { local s1 "1" }
        else if `"`f'"'==bsubstr("gaussian",1,max(`l',3))  { local s1 "1" }
        else if `"`f'"'==bsubstr("normal",1,`l')           { local s1 "1" }
        else if `"`f'"'==bsubstr("binomial",1,`l')         { local s1 "2" }
        else if `"`f'"'==bsubstr("bernoulli",1,`l')        { local s1 "2" }
        else if `"`f'"'==bsubstr("poisson",1,`l')          { local s1 "3" }
        else if `"`f'"'==bsubstr("gamma",1,max(`l',3))     { local s1 "4" }
        else if `"`f'"'==bsubstr("igaussian",1,max(`l',2)) { local s1 "5" }
        else if `"`f'"'==bsubstr("inormal",1,max(`l',2))   { local s1 "5" }
        else if `"`f'"'=="ivg"                            { local s1 "5" }
        else if `"`f'"'==bsubstr("nbinomial",1,max(2,`l')) { local s1 "6" }

	if "`s1'" != "" {
		local s1 "glim_v`s1'"
	}
	else {
		local s1 "`f'"
	}
        ret local famcode `s1'
end

program MapLink, rclass /* <code> <coderest> ... */
	args ulink upow rest
        if `"`rest'"'!="" {
                di as err "link(`ulink' `upow' `rest') invalid"
                exit 198
        }

        local ulink = lower(`"`ulink'"')
        local l     = length(`"`ulink'"')
        local s1      "11"                /* power(a) link */
        local s2      .                   /* a of power(a) */

        if `"`ulink'"'==""                              { local s1 "" }
        else if `"`ulink'"'==bsubstr("identity",1,`l')   { local s1 "01"
							  local s2 1    }
        else if `"`ulink'"'==bsubstr("reciprocal",1,`l') { local s1 "09"
							  local s2 -1   }
        else if `"`ulink'"'=="log"                      { local s1 "03"
							  local s2 0    }
        else if `"`ulink'"'==bsubstr("power",1,max(`l',3)) {
                capture confirm number `upow'
                if _rc {
                        di as err "invalid # in link(power #)"
                        exit 198
                }
		if `upow' == 0 {
			local s1 "03"
		}
		if `upow' == -1 {
			local s1 "09"
		}
		else if `upow' == -2 {
			local s1 "10"
		}
                local s2 `upow'
                local upow
        }
        else if `"`ulink'"'==bsubstr("opower",1,max(`l',3)) {
                capture confirm number `upow'
                if _rc {
                        di as err "invalid # in link(opower #)"
                        exit 198
                }
                if `upow'==0 {
                        local s1 "02"	/* logit */
                }
                else {
                        local s1 "12"   /* odds-power */
                }
		local s2 `upow'
                local upow
        }
        else if `"`ulink'"'==bsubstr("logit",1,`l')          { local s1 "02"
							      local s2 0    }
        else if `"`ulink'"'==bsubstr("nbinomial",1,max(`l',2)) { local s1 "04" }
        else if `"`ulink'"'==bsubstr("logc",1,4)             { local s1 "05" }
        else if `"`ulink'"'==bsubstr("loglog",1,max(`l',4))  { local s1 "06" }
        else if `"`ulink'"'==bsubstr("cloglog",1,`l')        { local s1 "07" }
        else if `"`ulink'"'==bsubstr("probit",1,`l')         { local s1 "08" }

        else {
		local s1
		local s2 "`upow'"
        }

	if `"`s1'"' != "" {
		local s1 "glim_l`s1'"
	}
	else {
		local s1 "`ulink'"
	}

        ret local link  `s1'
        ret local power `s2'
end

program Eform , rclass
        local var "`e(varfunc)'"
        local lnk "`e(link)'"

        local eform "exp(b)"
        if ("`var'" == "glim_v3" | "`var'" == "glim_v6") {
                if "`lnk'" == "glim_l03" {
                        local eform "IRR"
                }
        }
        else if "`var'" == "glim_v2" {
                if "`lnk'" == "glim_l02" {
                        local eform "Odds Ratio"
                }
                else if "`lnk'" == "glim_l03" {
                        local eform "Risk Ratio"
                }
                else if "`lnk'" == "glim_l05" {
                        local eform "Hlth Ratio"
                }
                else local eform "exp(b)"
        }
        return local eform "`eform'"
end

program HAC, rclass
	args hacnam haclag wv res touse constant xvars intlag

	local xv "`xvars'"
	if "`constant'" == "" {
		tempvar CONS
		gen byte `CONS' = 1
		local xn "`xv' _cons"
		local xv "`xv' `CONS'"
	}
	else {  local xn "`xv'" }
	local nx : word count `xv'

	qui summ `touse', meanonly
	local nobs = r(N)

	tempvar vt1
	tempname tt xtx tx

	capture tsset, noquery
	if _rc == 0 {
		sort `r(panelvar)' `r(timevar)'
	}

	gen double `vt1' = .
	local j 0
	local G = cond(`intlag', `haclag', `nobs'-1)
	while `j' <= `G' {
		capture mat drop `tt'
		local i 1
		while `i' <= `nx' {
			local x : word `i' of `xv'
			fvrevar `x'
			local x `r(varlist)'
			qui replace `vt1' = `x'[_n-`j']*`res'*`res'[_n-`j']* /*
					*/ `wv'[_n-`j'] if `touse'
			if (`j' < `nobs'-1) {
version 11: ///
mat vecaccum `tx' = `vt1' `xv' if `touse', nocons
			}
			else {		// manual calculation on last obs
mat `tx'= J(1, `nx', 0) 
sum `vt1' if `touse', meanonly
local mvt1 = r(mean)
forval k = 1/`nx' {
	local xx : word `k' of `xv'
	summ `xx' if `touse', meanonly
	mat `tx'[1,`k'] = r(mean)*`mvt1'
}
			}
			mat `tt' = nullmat(`tt') \ `tx'
			local i = `i'+1
		}
		`hacnam' `haclag' `j'
		if `r(wt)'>=. {
			noi di as err "Newey-West weights are missing"
			exit 199
		}
		mat `tt' = (`tt' + `tt'')*r(wt)
		if `j' > 0 {
			mat `xtx' = `xtx'+`tt'
		}
		else {
			mat `xtx' = `tt'*.5
		}
		local j = `j'+1
	}
	version 11: ///
	mat colnames `xtx' = `xn'
	version 11: ///
	mat rownames `xtx' = `xn'
	return matrix V `xtx'
end

program LoadXi
	args beta xi i

	local p = colsof(`beta')
	local xv : colnames(`beta')
	local j 1
	while `j'<=`p' {
		local x : word `j' of `xv'
		if "`x'" != "_cons" {
			mat `xi'[1,`j'] = `x'[`i']
		}
		else    mat `xi'[1,`j'] = 1
		local j = `j'+1
	}
end

program JK1nr
	args b V y xvars eta mu v dmu tvar z moffset constant wt touse weight
	capture drop `eta'
	capture drop `mu'
	capture drop `v'
	capture drop `dmu'
	_predict `eta', xb
	$SGLM_L 1 `eta' `mu'
	$SGLM_V 1 `eta' `mu' `v'
	$SGLM_L 2 `eta' `mu' `dmu'
	capture drop `z'
	tempvar W h
	tempname ll
	gen double `z' = `eta' + (`y'-`mu')/`dmu' `moffset' if `touse'
	gen double `W' = `dmu'*`dmu'/`v' if `touse'
	estimates hold `ll'
	`VV' ///
	cap noisily quietly regress `z' `xvars' [iw=`W'*`wt'], mse1 `constant'
	if e(N)>=. {exit 459}
	if _rc {exit _rc}
	_predict double `h' if `touse', stdp
	replace `h' = `h'*`h'*`v'
	estimates unhold `ll'

	capture drop `z'
	gen double `z' = (`mu'-`y')/(1-`h')
	sort `touse' `tvar'
	capture drop `dmu'

	gen `dmu' = _n if `touse'
	local p = colsof(`b')

	tempname bi xtxi xi ss
	mat `xi' = J(1,`p',0)
	mat `V' = 0*`V'
	if "`weight'" == "fweight" {
		version 11: ///
		mat accum `xtxi' = `xvars' [iw=`v'*`wt'] if `touse', `constant'
	}
	else {
		version 11: ///
		mat accum `xtxi' = `xvars' [iw=`v'] if `touse', `constant'
	}
	mat `xtxi' = syminv(`xtxi')
	summ `dmu'
	local factor 1
	local max = r(max)
	local i   = r(min)
	while `i' <= `max' {
		if !`touse'[`i'] {
			local i = `i' + 1
			continue
		}
		LoadXi "`b'" "`xi'" `i'
		mat `bi' = `xi'*`xtxi'
		scalar `ss' = `z'[`i']
		mat `bi' = `ss'*`bi'
		if "`weight'" == "fweight" { local factor = `wt'[`i'] }
		mat `V' = `V' + `factor'*(`bi')'*`bi'
		local i = `i'+1
	}
end

program JK1irls
	args b V y xvars h eta mu v dmu tvar z moffset constant wt touse weight
	capture drop `v'
	capture drop `dmu'
	capture drop `z'
	$SGLM_V 1 `eta' `mu' `v'
	gen double `z' = (`mu'-`y')/(1-`h')
	sort `touse' `tvar'
	gen `dmu' = _n if `touse'
	local p = colsof(`b')

	tempname bi xtxi xi ss
	mat `xi' = J(1,`p',0)
	mat `V' = 0*`V'
	version 11: ///
	mat accum `xtxi' = `xvars' [iw=`v'*`wt'] if `touse', `constant'
	mat `xtxi' = syminv(`xtxi')
	summ `dmu'
	local factor 1
	local max = r(max)
	local i = r(min)
	while `i' <= `max' {
		if !`touse'[`i'] {
			local i = `i' + 1
			continue
		}
		LoadXi "`b'" "`xi'" `i'
		mat `bi' = `xi'*`xtxi'
		scalar `ss' = `z'[`i']
		mat `bi' = `ss'*`bi'
		if "`weight'" == "fweight" { local factor = `wt'[`i'] }
		mat `V' = `V' + `factor'*(`bi')'*`bi'
		local i = `i'+1
	}
end

program JKnife
	args b V y xvars tvar offset constant family irls link /*
		*/ wtopt touse cluster dots weight wt

	if "`dots'" != "" { noi di }
	sort `touse' `tvar'
	local p = colsof(`b')
	mat `V' = 0*`V'

	if "`irls'" == "" {
		local iopt "from(`b')"
	}
	else {
		tempvar xb mu
		qui _predict double `xb' if `touse', xb
		qui $SGLM_L 1 `xb' `mu'
		local iopt "mu(`mu')"
	}
	local reg = "$SGLM_V" == "glim_v1" & "$SGLM_L" == "glim_l01" & "`irls'" == ""
	if `reg' { local iopt }
	tempname bi ll
	estimates hold `ll'
	tempvar dd
	if "`cluster'" != "" {
		qui egen `dd' = group(`cluster') if `touse'
		qui summ `dd'
		local nsize = r(max)
	}
	else    {
		qui gen  `dd' = _n if `touse'
		qui summ `dd'
		local nsize = r(N)
	}
	local max = r(max)
	local min = r(min)
	local i   = `min'
	local nb = 0

	if "`dots'" != "" {
		di as txt "Jackknife iterations (" /*
			*/ as res `nsize' as txt ")"
		di as txt "{hline 4}{c +}{hline 3} 1 "/*
			*/"{hline 3}{c +}{hline 3} 2 "/*
			*/"{hline 3}{c +}{hline 3} 3 "/*
			*/"{hline 3}{c +}{hline 3} 4 "/*
			*/"{hline 3}{c +}{hline 3} 5"
	}

	if "`weight'" == "fweight" {
		local wtopt "[fweight=`wt']"
		local fixwt 1
	}
	else    local fixwt 0


	local nx : word count `xvars'

	while `i' <= `max' {
		if "`cluster'" == "" & !`touse'[`i'] {
			local i = `i'+1
			continue
		}
		if `fixwt' == 0 {
			qui _rmcoll `xvars' `wtopt'	///
				if `touse' & `dd'!=`i', `constant'
			local nxrm : word count `r(varlist)'
		}
		else    local nxrm = `nx'

		if `nxrm' == `nx' {
			capture {
				if `fixwt' {
					qui summ `wt' if `dd'==`i', meanonly
					local factor = r(mean)
					qui replace `wt'=`wt'-1 if `dd'==`i'
					`VV' qui glm_7 `y' `xvars' if `touse' /*
						*/ `wtopt' /*
						*/ , `family' /*
						*/ `link' `offset' /*
						*/ `constant' `irls' `iopt'
				}
				else {
					local factor 1
					`VV' qui glm_7 `y' `xvars' if `touse' /*
					*/ & `dd'!=`i' `wtopt' /*
					*/ , `family' /*
					*/ `link' `offset' /*
					*/ `constant' `irls' `iopt'
				}
				mat `bi' = e(b)
				mat `V' = `V' + `factor'*(`bi'-`b')'*(`bi'-`b')
			}
			if _rc {
				if _rc == 1 { exit _rc }
				local err 1
				local nb = `nb'+`factor'
			}
			else    local err 0
			if `fixwt' {
				qui replace `wt'=`wt'+1 if `dd'==`i'
			}
		}
		else    local err 1
		if "`dots'" != "" {
			local j = `i'-`min'+1
			if `err' {
				noi di as err "x" _c
			}
			else {
				noi di as txt "." _c
			}
			if int(`j'/50)*50 == `j' {
				noi di as res " " `j'
			}
		}
		local i = `i'+1
	}
	estimates unhold `ll'
	global SGLM_nc = `nsize'
	global SGLM_bm = `nb'
	if "`dots'" != "" { noi di }
end

program Bstrap
	args b V y xvars offset constant family irls link /*
		*/ wtopt touse brep clopt dots

	if "`dots'" != "" { noi di }
	sort `touse' `tvar'
	local p = colsof(`b')
	mat `V' = 0*`V'

	if "`irls'" == "" {
		local iopt "from(`b')"
	}
	else {
		tempvar xb mu
		qui _predict double `xb' if `touse', xb
		qui $SGLM_L 1 `xb' `mu'
		local iopt "mu(`mu')"
	}

	local reg = "$SGLM_V" == "glim_v1" & "$SGLM_L" == "glim_l01" & "`irls'" == ""
	if `reg' { local iopt }

	tempname bi ll
	preserve
	qui drop if `touse'==0
	tempfile tmp
	estimates hold `ll'
	qui save `"`tmp'"'
	local nb = 0
	local i 1

	if "`dots'" != "" {
		di as txt "Bootstrap iterations (" /*
			*/ as res `brep' as txt ")"
		di as txt "{hline 4}{c +}{hline 3} 1 "/*
                        */"{hline 3}{c +}{hline 3} 2 "/*
                        */"{hline 3}{c +}{hline 3} 3 "/*
                        */"{hline 3}{c +}{hline 3} 4 "/*
                        */"{hline 3}{c +}{hline 3} 5"
	}

	local nx : word count `xvars'

	while `i' <= `brep' {
		qui use `"`tmp'"', clear
		qui bsample , `clopt'

		qui _rmcoll `xvars' `wtopt', `constant'
		local nxrm : word count `r(varlist)'

		local err 0
		if `nxrm' == `nx' {
			capture {
				`VV' qui glm_7 `y' `xvars' `wtopt' /*
					*/ , `family' /*
					*/ `link' `offset' /*
					*/ `constant' `irls' `iopt'
				mat `bi' = e(b)
				mat `V' = `V' + (`bi'-`b')'*(`bi'-`b')
			}
			if _rc {
				local err 1
				if _rc == 1 { exit _rc }
				local nb = `nb'+1
			}
			else    local err 0
		}
		else local err 1
		if "`dots'" != "" {
			if `err' {
				noi di as err "x" _c
			}
			else {
				noi di as txt "." _c
			}
			if int(`i'/50)*50 == `i' {
				noi di as res " " `i'
			}
		}
		local i = `i'+1
	}
	restore
	estimates unhold `ll'
	global SGLM_bm = `nb'
	if "`dots'" != "" { noi di }
end
exit
