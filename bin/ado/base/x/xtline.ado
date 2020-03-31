*! version 1.3.2  16feb2015
program xtline

	if      (_caller() < 8.2)  version 8
	else if (_caller() < 10 )  version 8.2
	else			   version 10

	if _caller() < 9 {
		local BYOPTS BYopts(string asis)
	}
	else {
		local BYOPTS  // allow _gs_byopts_combine to parse BYOPts
	}

	syntax varlist(ts numeric) [if] [in] [,	///
		OVerlayed			/// [sic] official -overlay-
		I(varname) T(varname numeric)	///
		`BYOPTS'			///
		recast(passthru)		///
		*				///
	]
	
	if `"`BYOPTS'"' == "" {
		_gs_byopts_combine  byopts options : `"`options'"'
	}

	marksample touse, novarlist

	if "`i'`t'" != "" {
		// user supplied time and panel variables
		if "`t'" == "" {
			di as err "option i() requires option t()"
			exit 198
		}
		if "`i'" == "" {
			di as err "option t() requires option i()"
			exit 198
		}
	}
	else {
		// check for panel data
		_xt, i(`i') t(`t')
		local i `r(ivar)'
		local t `r(tvar)'
	}
	quietly count if `touse'
	if r(N) == 0 {
		error 2000
	}

	markout `touse' `t'
	markout `touse' `i', strok
	tsrevar `varlist'
	local yvars `r(varlist)'

	_get_gropts , graphopts(`options') getallowed(addplot plot)
	local options `"`s(graphopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'

	// check for bad option combinations
	if "`overlayed'" != "" {
		if `"`byopts'"' != "" {
			di as err ///
"options byopts() and overlay may not be combined"
			exit 198
		}
		if `:word count `varlist'' > 1 {
			di as err ///
"option overlay may not be specified with multiple variables"
			exit 198
		}
	}

	if `:word count `varlist'' == 1 {
		local ylab : var lab `yvars'
		if `"`ylab'"' == "" {
			local ylab `yvars'
		}
		local options `"ytitle(`"`ylab'"') `options'"'
	}
	else {
		local options `"ytitle("") `options'"'
	}

	// check for invalid -plopts()- option
	local 0 `", `options'"'
	syntax [, plopts(passthru) * ]
	if `"`plopts'"' != "" {
		local 0 , `plopts'
		syntax [, invalid_option ]
	}

	if "`overlayed'" != "" {
		// ordered panel id, and panel size
		tempvar id idsize
		sort `touse' `i'
		qui by `touse' `i' : gen `id' = _n==1 if `touse'
		qui replace `id' = sum(`id') if `touse'
		qui by `touse' `i' : gen `c(obs_t)' `idsize' = _N if `touse'
		// number of panels
		local npanels = `id'[_N]

		// index for 1st obs of each panel
		qui count if `touse'
		local ni = _N-r(N)+1

		forval j = 1/`npanels' {
			YVarLabelOpt `i' `ni' `yvars'
			local yvarlabs `"yvarl(`s(yvarlabs)')"'
			local 0 `", `options'"'
			syntax [, plopts`j'(string asis) ///
				  PLOT`j'opts(string asis)* ]
			local ploptsA `plopts`j''
			local ploptsB `plot`j'opts'
			while `"`plopts`j''`plot`j'opts'"' != "" {
				local 0 `", `options'"'
				syntax [, plopts`j'(string asis) ///
					  PLOT`j'opts(string asis)* ]
				if `"`plopts`j''"' != "" {
				    local ploptsA `"`ploptsA' `plopts`j''"'
				}
				if `"`plot`j'opts'"' != "" {
				    local ploptsB `"`ploptsB' `plot`j'opts'"'
				}
			}
			local linecmd `linecmd'		///
			line `yvars' `t' if `id'==`j',	///
				sort			///
				`recast'		///
				`yttl'			///
				`yvarlabs'		///
				`ploptsA' `ploptsB' ||
			local ni = `ni' + `idsize'[`ni']
		}
	}
	else {
		local byopt by(`i', `byopts')
		local linecmd line `yvars' `t' if `touse', ///
			sort `recast' `byopt' `options'
		local options
	}

	if `"`options'"' != "" {
		local options `"|| , `options'"'
	}
	if `"`plot'`addplot'"' != "" {
		local plot `"|| `plot' || `addplot' || , norescaling"'
	}

	graph twoway `linecmd' `options' `plot'
end

program YVarLabelOpt, sclass
	gettoken i     0 : 0
	gettoken ni    0 : 0
	syntax varlist(ts numeric)

	local nvars : word count `varlist'

	local ival `=`i'[`ni']'
	local maxvarnamelen 8
	local maxvallen 20

	local ai = abbrev("`i'",`maxvarnamelen')

	if "`: value label `i''" == "" {
		if `nvars' == 1 {
			local yvarlabs `""`ai' = `ival'""'
		}
		else {
			foreach var of local varlist {
				local avar = abbrev("`var'",`maxvarnamelen')
				local yvarlabs ///
				`"`yvarlabs' "`avar': `ai' = `ival'""'
			}
		}
	}
	else {
		local ivlbl : label (`i') `ival'
		if `nvars' == 1 {
			local yvarlabs `""`ivlbl'""'
		}
		else {
			foreach var of local varlist {
				local avar = abbrev("`var'",`maxvarnamelen')
				local yvarlabs ///
				`"`yvarlabs' "`avar': `ivlbl'""'
			}
		}
	}

	sreturn clear
	sreturn local yvarlabs `"`yvarlabs'"'
end

exit
