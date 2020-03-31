*! version 1.1.4  20dec2004
program svyopts, sclass
/*
   Syntax:     svyopts <lmacname> <lmacname> [<lmacname>] [, <options>]

   Examples:   svyopts svyopts diopts, `options'

               svyopts svyopts diopts options, `options'
*/
	version 8

	local svyoptlist		///
		noSVYadjust noADJust	/// (synonyms)
		SCore(string)		///
		SUBpop(string asis)	///
		SRSsubpop		///
		svy			/// ignored
		// blank
	local dioptlist			///
		Level(cilevel)		///
		DEFF DEFT		///
		MEFF MEFT		///
		EForm			///
		Prob			///
		CI			///
		noHeader		///
		// blank
	syntax namelist(id="macro names for svyopts" min=2 max=3) ///
		[, `svyoptlist' `dioptlist' * ]
	tokenize `namelist'
	args svyopts diopts rest
	if "`rest'" == "" {
		syntax namelist [, `svyoptlist' `dioptlist' ]
	}

	// svy options
	if `"`adjust'"' != "" {
		local svyadjust nosvyadjust
	}
	if `"`score'"' != "" {
		local score score(`score')
	}
	if `"`subpop'`srssubpop'"' != "" {
		tempvar doit subv
		quietly gen byte `doit' = 1
		svy_sub `doit' `subv' "" "" "" "" "`srssubpop'" `subpop'
		local subcond `r(subcond)'

		local subopt `subpop'
		local subpop subpop(`subpop')
	}
	// ignore svy, since it should only be used directly by -svy- cmds
	c_local `svyopts' `svyadjust' `score' `subpop' `srssubpop'

	// display options
	if `"`level'"' != "`c(level)'" {
		local level level(`level')
	}
	else	local level
        c_local `diopts' `first' `prob' `ci' `deff' `deft' ///
		`meff' `meft' `eform' `header' `level'

	// other options
	if "`rest'" != "" {
		c_local `rest' `"`options'"'
	}

	sreturn clear
	sreturn local meff `meff' `meft'
	sreturn local subpop `subcond'
end
exit
