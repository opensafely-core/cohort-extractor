*! version 1.1.0  01may2009
program discrim_qda, sortpreserve eclass
	version 10

	if replay() {
		if "`e(subcmd)'" != "qda" | "`e(cmd)'" != "discrim" {
			error 301
		}
		Displayer `0'
		exit
	}

	local cmdline : copy local 0

	syntax varlist(numeric) [if] [in] [fweight] , ///
		Group(varname numeric)	/// The group identifying variable
		[			///
		PRIors(string)		/// prior probabilities
		noTable			/// suppress classification table
		LOOtable		/// display LOO class. table
		TIEs(string)		/// ties
			/// undocumented
		noLABELKEY		/// suppress label key
		]

	ereturn clear
	marksample touse
	markout `touse' `group'

	discrim prog_utility ties, `ties'
	local ties `s(ties)'
	if "`ties'" == "nearest" {
		di as err "ties(nearest) not allowed"
		exit 198
	}

	if `"`priors'"' == "" {
		local dispopts priors(equal)
	}
	else {
		local dispopts `"priors(`priors')"'
	}
	// dispopts contains options that alter the display
	local dispopts `"`dispopts' `table' `lootable' ties(`ties') `labelkey'"'

	tempvar fwvar
	if "`weight'" != "" {
		local fwgt [fweight`exp']
		cap gen byte `fwvar' `exp'
		if c(rc) {
			di as err "[`weight'`exp'] invalid frequency weight"
			exit 198
		}
	}
	else {
		qui gen byte `fwvar' = 1
	}
	tempname grpvals grpcnts grppriors
	discrim prog_utility groups `group' `touse' `fwgt'
	local N = r(N)
	local Ng = r(N_groups)
	mat `grpvals' = r(groupvalues)
	mat `grpcnts' = r(groupcounts)
	local grplabs `"`r(grouplabels)'"'

	discrim prog_utility priors `"`priors'"' `Ng' `grpcnts'
	mat `grppriors'	= r(grouppriors)

	mat rownames `grpcnts' = Counts
	mat rownames `grpvals' = Values
	mat colnames `grpvals' = `: colnames `grppriors''
	mat colnames `grpcnts' = `: colnames `grppriors''

	sort `group' `touse' , stable

	tempvar tmptouse
	qui gen byte `tmptouse' = `touse'
	// the following will clear e() and so must be done before the rest
	ereturn post ,  esample(`tmptouse') 		/// set e(sample)
			properties(nob noV)		 // set e(properties)

	mata: _discrim_qdaDiscrim("`group'", `Ng', "`varlist'", ///
						"`touse'", "`fwvar'")

	ereturn local groupvar		"`group'"
	ereturn local varlist		"`varlist'"
	ereturn scalar N		= `N'
	ereturn scalar N_groups		= `Ng'
	ereturn scalar k		= `: word count `varlist''
	ereturn matrix groupvalues	= `grpvals'
	ereturn matrix groupcounts	= `grpcnts'
	ereturn matrix grouppriors	= `grppriors'
	ereturn local ties		"`ties'"
	if "`fwgt'" != "" {
		ereturn local wtype	"fweight"
		ereturn local wexp	`"`exp'"'
	}
	ereturn local grouplabels	`"`grplabs'"'
	ereturn local estat_cmd		"discrim_qda_estat"
	ereturn local predict		"discrim_qda_p"
	ereturn local title		"Quadratic discriminant analysis"
	ereturn local subcmd		"qda"
	ereturn local cmdline		`"discrim qda `cmdline'"'
	ereturn local marginsnotok _ALL
	ereturn local cmd		"discrim"

	Displayer , `dispopts'	// display results
end

program Displayer
	syntax [, noTable LOOtable PRIors(passthru) TIEs(passthru) noLABELKEY ]

	if "`table'" == "notable" & "`lootable'" == "" {
		// nothing to display
		exit
	}

	if `"`e(wtype)'"' != "" {
		local wt `"[`e(wtype)'`e(wexp)']"'
	}
	di ""
	if `"`e(title)'"' != "" {
		di as text `"`e(title)'"'
	}

	if "`table'" != "notable" {
		discrim prog_utility classtable `e(groupvar)'	///
			if e(sample) `wt', `priors' `labelkey'	///
			predopts(classification `ties')		///
			title("Resubstitution classification summary")
		local doblank `"di """'
		local labelkey nolabelkey
	}

	if "`lootable'" != "" {
		`doblank'
		discrim prog_utility classtable `e(groupvar)'	///
			if e(sample) `wt', `priors' `labelkey'	///
			predopts(looclass `ties')		///
			title("Leave-one-out classification summary")
	}
end
