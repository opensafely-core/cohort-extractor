*! version 1.1.0  01may2009
program discrim_logistic, eclass
	version 10

	if replay() {
		if "`e(subcmd)'" != "logistic" | "`e(cmd)'" != "discrim" {
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
		TIEs(string)		/// ties
		noLABELKEY		/// undocumented: suppress label key
		*			/// (mlogit options passed through)
		]			    // document the -noLOg- option
					    // for suppressing the mlogit log

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
	local dispopts `"`dispopts' `table' ties(`ties') `labelkey'"'

	if "`weight'" != "" {
		local fwgt [fweight`exp']
	}

	tempname grpvals grpcnts grppriors matchk theb

	discrim prog_utility groups `group' `touse' `fwgt'
	local Ng = r(N_groups)
	mat `grpvals' = r(groupvalues)
	mat `grpcnts' = r(groupcounts)
	local grplabs `"`r(grouplabels)'"'

	discrim prog_utility priors `"`priors'"' `Ng' `grpcnts'
	mat `grppriors' = r(grouppriors)

	mlogit `group' `varlist' `if' `in' `fwgt' , `options' notable

	local basei = e(ibaseout)
	mat `matchk' = e(out)
	local wex `"`e(wexp)'"'

	// paranoid check that # of groups and group values did not change
	// in running mlogit
	if e(k_out) != `Ng' {
		di as err ///
		 "mlogit produced e(k_out) = `e(k_out)' when `Ng' was expected"
		exit 322
	}
	capture assert mreldif(`grpvals',`matchk') < 1e-15
	if _rc {
		di as err "mlogit produced an unexpected e(out) matrix;"
		di as err "mlogit produced:"
		matlist e(out)
		di as err "discrim logistic expected it to produce:"
		matlist `grpvals'
		exit 322
	}

	tempvar theesamp
	qui gen byte `theesamp' = e(sample)

	mat `theb' = e(b)

	// Determine if -mlogit- dropped any vars
	// if so adjust -varlist- and store names of dropped vars
	local tmpv : colnames `theb'
	local tmpv2 : list uniq tmpv
	local uncons _cons
	local tmpv : list tmpv2 - uncons
	local droppedv : list varlist - tmpv
	local varlist `tmpv'
	local thek : word count `varlist'

	forvalues i = 1/`Ng' {
		if `i' != `basei' {
			mata: st_local("oneeq", "group`i' "*`= `thek'+1')
			local eqstp `eqstp' `oneeq'
		}
	}
	mat coleq `theb' = `eqstp'

	mata: _discrim_AdjCons("`theb'","`grpcnts'", `basei')

	ereturn post `theb' , obs(`e(N)') esample(`theesamp') properties(b noV)

	ereturn local groupvar		`group'
	ereturn local varlist		`varlist'
	ereturn scalar N_groups		= `Ng'
	ereturn scalar k		= `thek'
	if "`weight'" != "" {
		ereturn local wtype	"fweight"
		ereturn local wexp	`"`wex'"'
	}
	if "`droppedv'" != "" {
		ereturn local dropped	`droppedv'
	}
	ereturn matrix groupvalues	= `grpvals'
	ereturn matrix groupcounts	= `grpcnts'
	ereturn matrix grouppriors	= `grppriors'
	ereturn scalar ibaseout		= `basei'
	ereturn local grouplabels	`"`grplabs'"'
	ereturn local ties		"`ties'"
	ereturn local estat_cmd		"discrim_logistic_estat"
	ereturn local predict		"discrim_logistic_p"
	ereturn local title		"Logistic discriminant analysis"
	ereturn local subcmd		"logistic"
	ereturn local cmdline		`"discrim logistic `cmdline'"'
	ereturn local marginsnotok _ALL
	ereturn local cmd		"discrim"

	Displayer , `dispopts'	// display results
end

program Displayer
	syntax [, noTable PRIors(passthru) TIEs(passthru) noLABELKEY ]

	if "`table'" != "notable" {
		if `"`e(wtype)'"' != "" {
			local wt `"[`e(wtype)'`e(wexp)']"'
		}
		di ""
		if `"`e(title)'"' != "" {
			di as text `"`e(title)'"'
		}
		discrim prog_utility classtable `e(groupvar)'	///
		if e(sample) `wt', `priors' `labelkey'		///
		predopts(classification `ties')			///
		title("Resubstitution classification summary")
	}
end
