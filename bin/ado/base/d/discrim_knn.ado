*! version 1.1.2  23sep2010
program define discrim_knn, eclass sortpreserve
	version 10 

	if replay() {
		if "`e(subcmd)'" != "knn" | "`e(cmd)'" != "discrim" {
			error 301
		}
		Displayer `0'
		exit
	}

	local cmdline : copy local 0

	syntax varlist [if] [in] [fw], Group(varname numeric)	///
		k(numlist min=1 max=1) 	///
		[			///
		MEAsure(str)		/// distance measure
		PRIors(str)		/// prior probabilities
		noTable			/// suppress classification table
		LOOtable		/// show leave-one-out class. table
		TIEs(str)		/// ties
		MAHalanobis		/// mahalanobis 
					/// (continuous measures only)
		s2d(str)		/// transformation for sim. measures
		noLABELKEY		/// undocumented: suppress label key
		]

	ereturn clear
	if `"`k'"' == "" {
		noi di as err "k() required"
		exit 198
	}
	capture confirm integer number `k'
	local rc = _rc
	capture assert `k' > 0
	local rc = `rc' + _rc
	if `rc' {
		di as err "k() must be a positive integer"
		exit 198
	}

	local dispopts `table' `lootable' `labelkey'
	if "`priors'"=="" {
		local dispopts `dispopts' priors(equal)
	}
	else {
		local dispopts `dispopts' priors(`priors')
	}

	marksample touse
	markout `touse' `group'

	tempvar fwvar
	if "`weight'" != "" {
		local fwgt [fweight`exp']
		local wtype fweight
		local wexp `""`exp'""'
		cap gen double `fwvar' `exp' if `touse'
		qui compress `fwvar'
		if c(rc) {
			di as err "[`weight'`exp'] invalid frequency weight"
			exit 198
		}
		qui summ `fwvar' if `touse', meanonly
		local N = `r(sum)'
	}
	else{
		qui gen byte `fwvar' = 1
		qui count if `touse'
		local N `r(N)'
	}
	local deps `""`fwvar'""'
	local colnames fweight

	tempvar tmptouse
	tempname grpvals grpcnts grppriors

	qui gen byte `tmptouse' = `touse'

	discrim prog_utility ties , `ties'
	local ties `s(ties)'

	parse_dissim `measure'
	local dname `s(dist)' // measure
	local dtype `s(dtype)' // (dis)similarity
	local darg  `s(darg)' // argument for L() Lpower()
	local dbin  `s(binary)' // binary measure
	if lower(`"`dname'"') == "gower" {
		di as err "measure(`dname') not allowed"
		exit 198
	}
	if "`mahalanobis'" != "" & "`dbin'"=="binary" {
		di as err "mahalanobis not allowed with binary measures"
		exit 198
	}

	Parse_s2d , `s2d' `dtype'
	local s2d `s(s2d)'

	discrim prog_utility groups `group' `touse' [fw=`fwvar']
	local ng = r(N_groups)
	mat `grpvals' = r(groupvalues)
	mat `grpcnts' = r(groupcounts)
	local grplabs = `"`r(grouplabels)'"'

	discrim prog_utility priors `"`priors'"' `ng' `grpcnts'
	mat `grppriors' = r(grouppriors)

	mat rownames `grpcnts' = Counts
	mat rownames `grpvals' = Values
	mat colnames `grpvals' = `: colnames `grppriors''
	mat colnames `grpcnts' = `: colnames `grppriors''

	ereturn post, esample(`tmptouse') obs(`N') properties("nob noV")

	mata: _discrim_knnCreatecommunity("`group'", `ng', "`varlist'", "`touse'", "`fwvar'", "`mahalanobis'")

	eret local measure_type `dtype'
	eret local measure_arg `darg'
	eret local measure `dname'
	eret local measure_binary `dbin'
	eret local s2d `s2d'
	eret local mahalanobis `mahalanobis'
	eret local wtype `wtype'
	eret local wexp `wexp'
	ereturn local ties `ties'
	ereturn local grouplabels `"`grplabs'"'
	ereturn scalar k_nn = `k'
	ereturn local groupvar `group'
	ereturn local predict knear_p
	ereturn scalar N_groups = `ng'
	ereturn local title "Kth-nearest-neighbor discriminant analysis"
	ereturn matrix groupcounts = `grpcnts'
	ereturn matrix groupvalues = `grpvals'
	ereturn matrix grouppriors = `grppriors'
	ereturn scalar k = `: word count `varlist''
	ereturn local  varlist `varlist'
	ereturn local predict "discrim_knn_p"
	ereturn local estat_cmd "discrim_knn_estat"
	ereturn local subcmd "knn"
	ereturn local cmdline `"discrim knn `cmdline'"'
	ereturn local marginsnotok _ALL
	ereturn local cmd "discrim"
	Displayer , `dispopts' //
end

program Displayer
	syntax [, noTable PRIors(passthru) LOOtable TIEs(passthru) noLABELKEY ]

	local predopts `ties' `priors'

	if `"`e(wtype)'"' != "" {
		local wt `"[`e(wtype)'`e(wexp)']"'
	}
	di
	if `"`e(title)'"' != "" {
		di as text `"`e(title)'"'
	}

	if "`table'" != "notable" {
		discrim prog_utility classtable `e(groupvar)' 	///
			if e(sample) `wt', `priors' `labelkey'	///
			predopts(classification `ties')		///
			title("Resubstitution classification summary")
		local doblank `"di """'
		local labelkey nolabelkey
	}

	if `"`lootable'"' != "" {
		`doblank'
		discrim prog_utility classtable `e(groupvar)' 	///
			if e(sample) `wt', `priors' `labelkey'	///
			predopts(looclass `ties')		///
			title("Leave-one-out classification summary")
	}
end

program Parse_s2d, sclass
	capture syntax [, STandard ONEminus similarity dissimilarity]
	if _rc {
		di as err "s2d() may be standard or oneminus"
		exit 198
	}
	if "`dissimilarity'" == "" & "`similarity'" == "" {
		// this shouldn't happen
		di as err "{p}either similarity or dissimilarity must be " ///
			"sent to subroutine Parse_s2d"
		exit 198
	}
	opts_exclusive "`standard' `oneminus'" s2d
	if "`similarity'" != "" & "`oneminus'" == "" { // make sure you got one
		local standard standard
	}
	if "`dissimilarity'" != "" & "`standard'`oneminus'" != "" {
		di as err "s2d() allowed only with similarity measures;" ///
			" see {help measure option}"
		exit 198
	}
	sreturn local s2d `standard'`oneminus'
end
