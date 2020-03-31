*! version 1.0.0  24apr2019
program cmrologit, eclass byable(onecall) prop(cm)
	version 16

	if (_by()) {
		local BY `"by `_byvars'`_byyrc0':"'
	}

	if (replay()) {
		if (`"`BY'"' != "") {
			error 190
		}

		if ("`e(cmd)'" != "cmrologit") {
			error 301
		}

		rologit `0'
		exit
	}

	local cmdline : copy local 0

	syntax varlist(numeric fv min=1) [fw pw iw] [if] [in] [, ///
		GRoup(passthru)					 ///
		ALTWISE						 ///
		OFFset(varname numeric)				 ///
		VCE(passthru)					 ///
		TEMPCASEID(varname numeric)			 ///
		* ]

	if (`"`group'"' != "") {

		di as error "option {bf:group()} not allowed"

		cap cmset
		if (c(rc) == 459) {

di as error "{p 4 4 2}"
di as error "Data must be {bf:cmset}. Use {bf:cmset} {it:caseidvar}{bf:, noalternatives}"
di as error "{p_end}"

		}

		exit 198
	}

	gettoken y varlist : varlist

	tempvar touse

	// cmsample will issue errors and warnings.

	cmsample `varlist' `offset' [`weight'`exp'] `if' `in', ///
		gen(`touse')			               ///
		choice(`y')		       	               ///
		`altwise'			               ///
		rank				               ///
		tempcaseid(`tempcaseid')		       ///
		marksample

	_cm

	if ("`tempcaseid'" != "") {
		local caseid `tempcaseid'
	}
	else {
		local caseid `r(caseid)'
	}

	local origpanelvar `r(origpanelvar)'  // only if panel data

	// When `origpanelvar' exists, vce() may be altered.

	if (   "`origpanelvar'" != ""				    /// 
	     & !inlist("`c(prefix)'", "bootstrap", "jackknife") ) {

		_cm_vcepanel `origpanelvar', cmd(cmrologit) `vce' ///
			allowed("oim robust cluster bootstrap jackknife")
		local vce `"`s(vce)'"'
	}

	`BY' rologit `y' `varlist' [`weight'`exp'] if `touse', ///
		group(`caseid')                    	       ///
		offset(`offset')			       ///
		`vce'					       ///
		cm				       	       ///
		`options'

	if ("`altwise'" != "") {
		ereturn local marktype altwise
	}
	else {
		ereturn local marktype casewise
	}

	ereturn hidden local indvars     `varlist'
	ereturn hidden local marginsmark cm_margins_marksample
	
	local cmdline : list retokenize cmdline
	ereturn local cmdline `"cmrologit `cmdline'"'
	ereturn local cmd       cmrologit
end

