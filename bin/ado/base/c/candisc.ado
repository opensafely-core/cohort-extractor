*! version 1.1.0  01may2009
program candisc, eclass
	version 10

	if replay() {
		if "`e(cmd)'" == "discrim" & "`e(subcmd)'" == "lda" {
			Displayer `0'
			exit
		}
		if "`e(cmd)'" != "candisc" {
			error 301
		}
		Displayer `0'
		exit
	}

	DoIt `0'
end

program DoIt, eclass

	local cmdline : copy local 0

	syntax varlist(numeric) [if] [in] [fweight] ,	///
		Group(varname numeric)	/// The group identifying variable
                [			///
                PRIors(passthru)	/// prior probabilities
		noSTats			/// suppress canon. statistics / tests
		noCOef			/// suppress canon. stand. coefs
		noSTRuct		/// suppress canon. structure mat
		noMeans			/// suppress canon. means
                noTable			/// suppress resub classification table
                LOOtable		/// display LOO classification table
                TIEs(string)		/// ties
		noLABELKEY		/// undocumented: suppress label key
                ]

	if "`weight'" != "" {
		local wgt `"[`weight' `exp']"'
	}
	discrim lda `varlist' `if' `in' `wgt', group(`group') notable `priors'

	discrim prog_utility ties, `ties'
	local ties `s(ties)'
	if "`ties'" == "nearest" {
		di as err "ties(nearest) not allowed"
		exit 198
	}

	if `"`priors'"' == "" {
		local dispopts priors(equal)
	}

	// dispopts contains options that alter the display
	local dispopts `"`dispopts' `stats' `coef' `struct' `means'"'
	local dispopts `"`dispopts' `table' `lootable' ties(`ties') `labelkey'"'


	// reset a couple of -discrim- e() items (leave the rest as is)
	ereturn local title "Canonical linear discriminant analysis"
	ereturn local cmdline `"candisc `cmdline'"'
	ereturn local subcmd		// reset to empty
	ereturn local marginsnotok _ALL
	ereturn local cmd "candisc"

	Displayer , `dispopts'
end

program Displayer
	syntax [, noSTats noCOef noSTRuct noMeans ///
		noTable LOOtable PRIors(passthru) TIEs(passthru) ///
		noLABELKEY	/// undocumented
		]

	// display canonical discrim. stats
	if "`stats'" != "nostats" {
		estat canon
	}

	// display standardized canonical discrim. function coefs
	if "`coef'" != "nocoef" {
		estat loadings, standardized
	}

	// display canonical structure matrix
	if "`struct'" != "nostruct" {
		estat structure
	}

	// display canonical means
	if "`means'" != "nomeans" {
		estat grmeans, canonical `labelkey'
		local labelkey nolabelkey
	}

	if `"`e(wtype)'"' != "" {
		local wt `"[`e(wtype)'`e(wexp)']"'
	}

	// resubstitution classification table
	if "`table'" != "notable" {
		di
		discrim prog_utility classtable `e(groupvar)'	///
			if e(sample) `wt', `priors' `labelkey'	///
			predopts(classification `ties')		///
			title("Resubstitution classification summary")
		local labelkey nolabelkey
	}

	// LOO classification table
	if "`lootable'" != "" {
		di
		discrim prog_utility classtable `e(groupvar)'	///
			if e(sample) `wt', `priors' `labelkey'	///
			predopts(looclass `ties')		///
			title("Leave-one-out classification summary")
	}
end
