*! version 1.7.0  20apr2019
program _get_diopts, sclass
	/* Syntax:
	 * 	_get_diopts <lmacname> [<lmacname>] [, <options>]
	 *
	 * Examples:
	 * 	_get_diopts diopts, `options'
	 * 	_get_diopts diopts options, `options'
	 */
	version 11

	syntax namelist(max=2) [, *]
	gettoken name1 namelist : namelist
	gettoken name2 namelist : namelist

	GetDiopts diopts options, `options'
	c_local `name1' `"`diopts'"'
	local snames : s(macros)
	foreach sname of local snames {
		local S_`sname' = s(`sname')
	}

	sreturn clear
	GetDiopts DEFAULT
	if `"`name2'"' == "" {
		GetDiopts DUPS, `options'
	}
	else {
		GetDiopts DUPS options, `options'
		c_local `name2' `"`options'"'
	}
	local DUPS : list DUPS - DEFAULT
	gettoken DUPS : DUPS
	if `"`DUPS'"' != "" {
		if (strpos(`"`DUPS'"', "(")) {
			gettoken DUPS : DUPS, parse("(")
			local DUPS `"`DUPS'()"'
		}
		di as err "duplicate {bf:`DUPS'} option not allowed"
		exit 198
	}
	sreturn clear
	foreach sname of local snames {
		sreturn local `sname' = `"`S_`sname''"'
	}
end

program GetDiopts, sclass
	local DIOPTS	Level(cilevel)		///
			vsquish			///
			NOALLBASElevels		/// [sic]
			ALLBASElevels		///
			NOBASElevels		/// [sic]
			BASElevels		///
			noCNSReport		///
			FULLCNSReport		///
			NOEMPTYcells		///
			EMPTYcells		///
			NOOMITted		///
			OMITted			///
			NOLSTRETCH		///
			LSTRETCH		///
			COEFLegend		///
			SELEGEND		///
			cformat(string)		///
			sformat(string)		///
			pformat(string)		///
			CODING			/// NOT DOCUMENTED
			VERSUS			/// NOT DOCUMENTED
			COMPARE			/// NOT DOCUMENTED
			FVWRAP(passthru)	///
			FVWRAPON(string)	///
			NOFVLABel		/// [sic]
			FVLABel			///
			NOCI			///
			NOPValues		///
			MARKDOWN		///
			CITYPE(passthru)	///
			NOABBREV		///
			ABBREV			///
						 // blank

	syntax namelist(max=2) [, `DIOPTS' *]

	opts_exclusive "`allbaselevels' `noallbaselevels'"
	opts_exclusive "`allbaselevels' `nobaselevels'"
	opts_exclusive "`baselevels' `nobaselevels'"
	opts_exclusive "`emptycells' `noemptycells'"
	opts_exclusive "`fvlabel' `nofvlabel'"
	opts_exclusive "`omitted' `noomitted'"
	opts_exclusive "`lstretch' `nolstretch'"
	opts_exclusive "`cnsreport' `fullcnsreport'"
	opts_exclusive "`coeflegend' `selegend'"
	local K : list sizeof namelist
	gettoken c_diopts c_opts : namelist

	opts_exclusive "`coding' `compare'"
	opts_exclusive "`versus' `compare'"
	opts_exclusive "`abbrev' `noabbrev'"

	local allbaselevels `allbaselevels' `noallbaselevels'
	local baselevels `baselevels' `nobaselevels'
	local emptycells `emptycells' `noemptycells'
	local omitted `omitted' `noomitted'
	local lstretch `lstretch' `nolstretch'
	local fvlabel `fvlabel' `nofvlabel'
	local abbrev `abbrev' `noabbrev'
	if "`allbaselevels'`baselevels'" == "" {
		if c(showbaselevels) == "all" {
			local allbaselevels allbaselevels
		}
		else if c(showbaselevels) == "on" {
			local baselevels baselevels
		}
	}
	if "`emptycells'" == "" {
		if c(showemptycells) == "off" {
			local emptycells noemptycells
		}
	}
	if "`omitted'" == "" {
		if c(showomitted) == "off" {
			local omitted noomitted
		}
	}
	if "`lstretch'" == "" {
		if c(lstretch) == "off" {
			local lstretch nolstretch
		}
	}

	if `:length local cformat' {
		confirm numeric format `cformat'
		if fmtwidth(`"`cformat'"') > 9 {
			local cformat "%9.0g"
			di "{txt}note: invalid cformat(), using default"
		}
		sreturn local cformat `"`cformat'"'
		local cformat `"cformat(`cformat')"'
	}
	if `:length local sformat' {
		confirm numeric format `sformat'
		if fmtwidth(`"`sformat'"') > 8 {
			local sformat "%8.2f"
			di "{txt}note: invalid sformat(), using default"
		}
		sreturn local sformat `"`sformat'"'
		local sformat `"sformat(`sformat')"'
	}
	if `:length local pformat' {
		confirm numeric format `pformat'
		if fmtwidth(`"`pformat'"') > 5 {
			local pformat "%5.3f"
			di "{txt}note: invalid pformat(), using default"
		}
		sreturn local pformat `"`pformat'"'
		local pformat `"pformat(`pformat')"'
	}

	if `K' == 1 & `:length local options' {
		syntax namelist(max=2) [, `DIOPTS']
	}

	if reldif(`level', c(level)) > 1e-3 {
		local levelopt level(`level')
	}

	Wrapon , `fvwrapon'

	if "`fvwrap'" != "" {
		FVWrap, `fvwrap'
	}

	c_local `c_diopts'			///
			`levelopt'		///
			`vsquish'		///
			`allbaselevels'		///
			`baselevels'		///
			`cnsreport'		///
			`fullcnsreport'		///
			`emptycells'		///
			`omitted'		///
			`lstretch'		///
			`coeflegend'		///
			`selegend'		///
			`cformat'		///
			`sformat'		///
			`pformat'		///
			`coding'		///
			`versus'		///
			`compare'		///
			`fvwrap'		///
			`fvwrapon'		///
			`fvlabel'		///
			`noci'			///
			`nopvalues'		///
			`markdown'		///
			`citype'		///
			`abbrev'		///
						 // blank

	if `K' == 2 {
		c_local `c_opts' `"`options'"'
	}
	sreturn local coding `coding'
	sreturn local versus `versus'
	sreturn local compare `compare'
	sreturn local level `level'
end

program Wrapon
	capture syntax [, WOrd WIdth]
	if c(rc) {
		di as err "invalid fvwrapon() option;"
		syntax [, WOrd WIdth]
		exit 198	// [sic]
	}
	opts_exclusive "`word' `width'" fvwrapon
	local fvwrapon `word' `width'
	if `:length local fvwrapon' {
		c_local fvwrapon fvwrapon(`fvwrapon')
	}
end

program define FVWrap
	syntax, fvwrap(integer)

	if `fvwrap' < 0 {
		di as err "{p}invalid option {bf:fvwrap(`fvwrap')}; " ///
		 "nonnegative integer required{p_end}"
		exit 198
	}
end

exit
