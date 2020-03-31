*! version 1.1.1  19aug2019
program _threshold, eclass byable(recall)
	version 15.0

	syntax varlist(ts fv) [if] [in] ,                                   ///
			threshvar(varname ts)                               ///
			[                                                   ///
			regionvars(string)                                  ///
			noCONstant                                          ///
			CONSINVariant					    ///
			NTHRESHolds(numlist integer max=1 >=0)              ///
			optthresh(string)				    ///
			trim(numlist int min=0 max=1)                	    ///
			vce(string)                                         ///
			CONSTraints(numlist)                                ///
			ssrs(string)                                        ///
			/// undocumented or passthru options below          ///
			threshval(string)                                   ///
			repartition                                         ///
			NOIsily                                             ///
			*                                                   ///
			]

	if `"`noisily'"' != "" {
		di as err "option {bf:noisily} not allowed"
		exit 198
	}

	_get_dots_option, `options'
	local dots `"`s(dots)'"'
	local nodots `"`s(nodots)'"'
	local options `"`s(options)'"'

	_get_diopts diopts, `options'
	local cmdline `0'

/**Check VCE option**/
	if ("`vce'"=="" | "`vce'"=="oim") local vcetype oim
	else if ("`vce'"==bsubstr("robust",1,max(1,strlen(`"`vce'"')))) {
		local vcetype robust
	}
	else {
		di as err "{bf:vce(`vce')} not allowed"
		exit 198
	}
	
	if ("`trim'"!="") {
		if (`trim'<=0 | `trim'>=50) {
			di as err "{p}{bf:trim()} must specify an integer "
			di as err "between 1 and 49{p_end}"
			exit 125
		}
	}
/***Parse varlist and constant***/
	opts_exclusive "`consinvariant' `constant'"
	gettoken depvar indepvars: varlist
	if (`"`depvar'"'==`"`threshvar'"') {
		di as err "{p}may not specify dependent variable in "
		di as err "{bf:threshvar()}{p_end}"
		exit 198
	}
	if (`"`regionvars'"'!="")	fvunab regionvars: `regionvars'

	if ("`constant'"!="" & "`regionvars'"=="") {
		di as err "{p}must specify at least one region-dependent "  ///
			"variable{p_end}"
		exit 198
	}
/*
	if ("`consinvariant'"!="" & "`regionvars'"=="") {
		di as err "{p}must specify at least one region-dependent "  ///
			"variable{p_end}"
		exit 198
	}
*/


	foreach ivar of local indepvars {
		foreach rvar of local regionvars {
			local dupvar = strmatch("`ivar'","`rvar'")
			if (`dupvar') {
				di as err "{p}{bf:`ivar'} may not be specified "
				di as err "both as an independent variable and "
				di as err "in {bf:regionvars()}{p_end}"
				exit 198
			}
		}
	}
/***Parse thresholds***/
	if ("`nthresholds'"!="" & "`optthresh'"!="") {
		di as err "{p}options {bf:nthresholds()} and {bf:optthresh()} "
		di as err "may not be specified together{p_end}"
		exit 198
	}
	else if ("`nthresholds'"=="" & "`optthresh'"!="") {
		_parse comma maxthresholds rhs: optthresh
		confirm integer number `maxthresholds'
		if (!_rc & `maxthresholds'<=0) {
			di as err "{p}must specify a positive integer in "
			di as err "{bf:optthresh()}{p_end}"
			exit 198
		}
		if (`maxthresholds'==0) {
			di as err "{p}the maximum number of thresholds in "
			di as err "option {bf:optthresh()} must be greater "
			di as err "than 0{p_end}"
			exit 198
		}
		gettoken comma ictype: rhs, parse(", ")
		local ictype = strtrim("`ictype'")
		if (`"`ictype'"'!="" & (`"`ictype'"'!="aic" & 		    ///
			`"`ictype'"'!="bic" & `"`ictype'"'!="hqic")) {
			di as err "{p}invalid information criteria "
			di as err "{bf:`ictype'}{p_end}"
			exit 198
		}
		else if (`"`ictype'"'=="") local criteria bic
		else local criteria `ictype'
		local nthresholds = `maxthresholds'
	}
	else if ("`nthresholds'"=="" & "`optthresh'"=="") local nthresholds 1

	if (`nthresholds'==0 & "`regionvars'"!="") {
		di as err "{p}option {bf:regionvars()} may not be specified" ///
		" with {bf:thresholds(`nthresholds')}{p_end}"
		exit 198
	}

/**additional parsing**/
	if (`nthresholds'==0 ) {
		local consinvariant = "consinvariant"
	}

/**Check time series and mark sample**/
	marksample touse
	_rmcoll `varlist' if `touse', expand
	if (r(k_omitted)!=0) {
		local varlist `r(varlist)'
		local indepvars : list varlist - depvar
	}
	cap _ts if `touse', sort
	if (_rc!=111) {
		qui tsreport if `touse', `detail'
		local gaps `r(N_gaps)'
		if (`gaps'!=0) {
			di as err "{p}gaps not allowed{p_end}"
			exit 198
		}
	}

	if (`nthresholds'==0)    markout `touse' `regionvars'
	else                 markout `touse' `regionvars' `threshvar'
	_rmcoll `varlist' `regionvars' if `touse', expand
	if (r(k_omitted)!=0) {
		local allvarlist `r(varlist)'
		local regionvars : list allvarlist - varlist
	}

	if ("`trim'"=="")       local trim = 10
	if ("`maxthresholds'"=="") {
		local maxthresholds = .
/**Set number of parameters**/
		local states = `nthresholds'+1
		if (`"`constant'"'!="")  		local nmu = 0
		else if (`"`consinvariant'"'!="") 	local nmu = 1
		else 					local nmu = `states'

		local nsphi: list sizeof indepvars
		local neq = `nsphi' + `states'

		local swphi: list sizeof regionvars
		local swphi = `swphi'*`states'
		local nparams = `nmu' + `nsphi' + `swphi'



/**edge case when there are no switching vars**/
	if ("`regionvars'"=="" & "`consinvariant'" == "consinvariant") {
		local nthresholds = 0
	}

/**Set eqnames and colnames for parameter matrix**/
		if ("`indepvars'"!="") local eqlabel `depvar'
		foreach var of local indepvars {
			local eqnames `eqnames' `depvar'
			local colnames `colnames' `var'
		}
		if (`nmu'==1) {
			local eqnames `eqnames' `depvar'
			local colnames `colnames' _cons
		}
		forvalues i=1/`states' {
			local eqlabel `eqlabel' Region`i'
			foreach var of local regionvars {
				if (`states'>1) local eqnames `eqnames' Region`i'
				local colnames `colnames' `var'
			}
			if (`nmu'>1) {
				local eqnames `eqnames' Region`i'
				local colnames `colnames' _cons
			}
		}

/**Post constraint matrix**/
		tempname b V Cns
		cap mat `b' = J(1,`nparams',0)
		if (_rc) {
			di as err "{p}not enough observations between "
			di as err "thresholds{p_end}"
			exit 198
		}
		mat `V' = J(`nparams',`nparams',0)
		mat colname `b' = `colnames'
		mat rowname `b' = `depvar'
		mat colname `V' = `colnames'
		mat rowname `V' = `colnames'
		mat coleq `b' = `eqnames'
		mat coleq `V' = `eqnames'
		mat roweq `V' = `eqnames'
		tempname T_cons a_cons c_cons
		mat `c_cons' = .
		if ("`constraints'"!="") {
			ereturn post `b' `V'
			cap mat makeCns `constraints'
			if _rc {
				local rc = _rc
				di in red "Constraints invalid:"
				mat makeCns `constraints'
				exit _rc
			}
			matcproc `T_cons' `a_cons' `c_cons'
			ereturn scalar constraint = 1
			ereturn matrix Tcons = `T_cons'
			ereturn matrix acons = `a_cons'
		}
	}
	else {
		if ("`constraints'"!="") {
		di as err "{p}{bf:constraints} may not be specified "	    ///
			"with option {bf:optthresh()}{p_end}"
		exit 198
		}
	}
/*Check threshold matrix*/
	if (`"`threshval'"'!="") {
		confirm matrix `threshval'
		if (rowsof(`threshval')!=1) {
			di as err "{p}threshval(`threshval') does not "	    ///
				"specify a row vector{p_end}"
			exit 198
		}
	}
	else {
		tempname threshval
		mat `threshval' = .
	}

/**Check ssrs option**/
	if (`"`ssrs'"'!="") {
		cap confirm new var `ssrs'
		if (_rc==198) {
			_stubstar2names `ssrs', nvars(`nthresholds')
			local ssrs `s(varlist)'
			local stubflag 1
		}
		else local stubflag 0
		if wordcount("`ssrs'") > `nthresholds' {
			di as err "{p}the number of variables in "	    ///
				"{bf:ssrs()} may not exceed the number "    ///
			        "of thresholds{p_end}"
			exit 198
		}
		local i = 1
		foreach var of local ssrs {
			qui gen double `var' = .
			label var `var' "SSR for estimating threshold`i'"
			local i = `i'+1
		}
	}
	if `dots'==0 {
		local dots 
		local nodots nodots
	}

/**Estimation**/
	tempname b V T estholds estssr thtable ic nobs ordthresh finalssr
	mata: _estreg("`depvar'", "`indepvars'", "`regionvars'",            ///
		"`threshvar'", "`ssrs'", "`touse'", "`consinvariant'", 	    ///
		"`constant'", "`criteria'", "`vcetype'", "`repartition'",   ///
		"`nodots'", "`dots'", `trim', `nthresholds', 		    ///
		`maxthresholds', st_matrix("`threshval'"))

	if (`"`ssrs'"'!="") {
		foreach var of local ssrs {
			qui replace `var' = . if `var'==0
		}
		if (`stubflag' & !missing(`maxthresholds')) {
			local _dropfvar = r(nthreshold)+1
			tokenize `ssrs'
			if (r(nthreshold)<`maxthresholds') quietly drop ``_dropfvar''-``maxthresholds''
		}
	}

	mat `ordthresh' = r(orderthresh)
	local nthresh   = r(nthreshold)
	mat `estholds'  = r(estholds)
	mat `thtable'   = r(thtable)
	if (`nthresh'==0)    mat `estssr' = r(ssr)
	else	mat `estssr' = `thtable'[1..`nthresh',3]
	mat `estssr' = `estssr''
	scalar `T'      = r(N)
	scalar `ic'     = r(ic)

	if !missing(`maxthresholds') {
/**Set number of parameters**/
		local nparams = colsof(`b')
		local states = `nthresh'+1
		if (`"`constant'"'!="")  		local nmu = 0
		else if (`"`consinvariant'"'!="") 	local nmu = 1
		else 					local nmu = `states'

		local nsphi: list sizeof indepvars
		local neq = `nsphi' + `states'
		/*
		local swphi: list sizeof regionvars
		local swphi = `swphi'*`states'
		local nparams = `nmu' + `nsphi' + `swphi'
		*/

/**Set eqnames and colnames for parameter matrix**/
		if ("`indepvars'"!="") local eqlabel `depvar'
		foreach var of local indepvars {
			local eqnames `eqnames' `depvar'
			local indcolnames `indcolnames' `var'
		}
		if (`nmu'==1) {
			local eqnames `eqnames' `depvar'
			local colnames `indcolnames' _cons
		}
		else	local colnames `indcolnames'
		forvalues i=1/`states' {
			local eqlabel `eqlabel' Region`i'
			foreach var of local regionvars {
				if (`states'>1) {
					local eqnames `eqnames' Region`i'
					local colnames `colnames' `var'
				}
			}
			if (`nmu'>1) {
				local eqnames `eqnames' Region`i'
				local colnames `colnames' _cons
			}
		}
		if (`states'==1) {
			local colnames `indcolnames' `regionvars'
			if (`nmu'==1) local colnames `colnames' _cons
		}
	}

/**Compute information criteria**/
	tempname aic bic hqic
	if (`nthresh'!=0) scalar `finalssr' = `estssr'[1,`nthresh']
	else	scalar `finalssr' = `estssr'[1,1]
	local aic = `T'*log(`finalssr'/`T') + 2*`nparams'
	local bic = `T'*log(`finalssr'/`T') + log(`T')*`nparams'
	local hqic = `T'*log(`finalssr'/`T') + 2*log(log(`T'))*`nparams'

/**Post estimates**/
	mat colname `b' = `colnames'
	mat rowname `b' = `depvar'
	mat colname `V' = `colnames'
	mat rowname `V' = `colnames'
	mat coleq `b'   = `eqnames'
	mat coleq `V'   = `eqnames'
	mat roweq `V'   = `eqnames'

	tempvar touse1
	clonevar `touse1' = `touse'
	if ("`e(constraint)'"=="1") {
		mat `Cns'       = e(Cns)
		ereturn post `b' `V' `Cns', esample(`touse')
	}
	else ereturn post `b' `V', esample(`touse')
	_post_vce_rank


/**Set ereturn list**/
	ereturn scalar N = `T'
	ereturn scalar nthresholds = `nthresh'
	ereturn scalar aic = `aic'
	ereturn scalar bic = `bic'
	ereturn scalar hqic = `hqic'
	if (`maxthresholds'!=.) {
		ereturn scalar optthresh = `maxthresholds'
		ereturn local criteria = "`criteria'"
	}

	ereturn local threshvar = "`threshvar'"
	ereturn hidden local lowt = "`lowt'"
	ereturn hidden local upt = "`upt'"
	ereturn hidden matrix thtable = `thtable'

	mat colname `estssr' = `tname'
	mat rowname `estssr' = SSR
	
	if (`nthresh'!=0)    {
		local nthresh = `nthresh'+1
		mat `nobs' = J(1,`nthresh',.)
		forvalues i = 1/`nthresh' {
			if (`i'==1) {
				qui count  ///
				if `threshvar'<=`estholds'[1,`i'+1] & `touse1'
				mat `nobs'[1,`i'] = r(N)
			}
			else if (`i'<`nthresh') {
				qui count if `threshvar'> 		    ///
				`estholds'[1,`i'] & `threshvar'<=	    ///
				`estholds'[1,`i'+1]                         ///
				& `touse1'
				 mat `nobs'[1,`i'] = r(N)
			 }
			else {
				qui count if `threshvar'>`estholds'[1,`i']  ///
				& `touse1'
				mat `nobs'[1,`i'] = r(N)
			 }
			local nmatcolname `nmatcolname' Region`i'
		}
		mat colname `nobs' = `nmatcolname'
		mat rowname `nobs' = N
		ereturn matrix nobs `nobs'
		ereturn matrix thresholds `estholds'
		ereturn scalar ssr = `finalssr'
		ereturn hidden matrix ordthresh `ordthresh'
	}
	else {
		tempname estholds0
		matrix `estholds0' = (-1e10, 1e10)
		ereturn matrix thresholds `estholds0'
		ereturn scalar ssr = `estssr'[1,1]
	}


/**Set ereturn list**/
	ereturn scalar k = `nparams'
	ereturn local depvar = `"`depvar'"'
	ereturn local title = "Threshold regression"
	ereturn matrix ssrmat `estssr'
	ereturn local vce = "`vcetype'"
	if ("`vcetype'"=="robust") ereturn local vcetype = "Robust"
	ereturn local cmd = "threshold"
	ereturn local regionvars = "`regionvars'"
	ereturn local cmdline = "threshold `cmdline'"
	local indepvars = strltrim("`indepvars'")
	ereturn local indepvars = "`indepvars'"
	ereturn local predict = "threshold_p"
	ereturn local eqnames = "`eqlabel'"
	ereturn local marginsnotok _ALL

	ereturn hidden local cons = "`constant'"
	ereturn hidden local nscons = "`nsconstant'"

	ereturn hidden local cons1 = "`consinvariant'"
	ereturn hidden local nscons1 = "`constant'"

/**Output**/
	_threshold_print, `diopts'

end


mata:

void function _estreg(                                                      ///
	string scalar   depvar, indepvars, regionvars, threshvar, genvars,  ///
			touse, constant, nsconstant, criteria, vcetype,     ///
			repartition, nodots, dots,                          ///
	real scalar     trim, nthreshold, maxthreshold,               	    ///
	real matrix     threshval
)
{
	class _threshold scalar Trobj

	Trobj._setuptreg(depvar, indepvars, regionvars, threshvar, genvars, 
		touse, constant, nsconstant, criteria, vcetype, repartition, 
		nodots, dots, trim, nthreshold, maxthreshold, threshval)
	Trobj._estreg()
}

end
