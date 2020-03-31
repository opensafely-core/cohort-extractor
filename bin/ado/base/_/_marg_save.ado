*! version 1.4.2  21oct2019
program _marg_save, rclass
	version 15
	local vv : display "version " string(_caller()) ":"
	syntax [, eclass MCOMPare(passthru) Level(passthru) *]

	local eclass : length local eclass

	if !`eclass' {
		if !inlist("margins", "`r(cmd)'", "`r(cmd2)'") {
			error 301
		}
		tempname ehold
		_est hold `ehold', restore nullok
		Post
		if "`mcompare'" == "" {
			if inlist("pwcompare", "`r(cmd)'", "`r(cmd2)'") {
				local vs "_vs"
			}
			local mcompare ///
			`"mcompare(`r(mcmethod`vs')' `r(mcadjustall`vs')')"'
		}
		if "`level'" == "" {
			local level "level(`r(level)')"
		}
		return add
	}
	else {
		if !inlist("margins", "`e(cmd)'", "`e(cmd2)'") {
			local cmdlist	mean		///
					proportion	///
					ratio		///
					total
			if 0`:list posof "`e(cmd)'" in cmdlist' {
				if missing(e(version)) {
					error 301
				}
			}
			else {
				error 301
			}
		}
	}

	`vv' Save `ehold' , `mcompare' `level' `options'
end

program Post, eclass
	tempname b
	matrix `b' = r(b)
	if `"`r(V)'"' == "matrix" {
		tempname V
		matrix `V' = r(V)
	}
	ereturn post `b' `V'
	_r2e, noclear
end

program Save
	version 15
	local sum_cmd	mean		///
			proportion	///
			ratio		///
			total
	local is_sum_cmd :list posof "`e(cmd)'" in sum_cmd
	if !`is_sum_cmd' {
		local mcompare MCOMPare(passthru)
	}
	else if "`e(cmd)'" == "proportion" {
		local percent percent NOPERCENT
	}

	syntax [name(name=ehold)],	///
		SAVing(string)		///
	[	`mcompare'		///
		Level(passthru)		///
		`percent'		///
	]

	local percent `percent' `nopercent'
	opts_exclusive "`percent'"

	_prefix_saving `saving'
	local saving	`"`s(filename)'"'
	local dbl	`"`s(double)'"'
	local replace	`"`s(replace)'"'

	if `"`e(nofvlabel)'"' == "nofvlabel" {
		local nofvlabel nofvlabel
	}

	local title
	if `is_sum_cmd' {
		if "`r(table)'`level'`percent'" != "matrix" {
			quietly `e(cmd)', `level' `percent'
		}
		local title `"`r(title)'"'
	}
	else {
		quietly margins, `mcompare' `level'
	}
	local level = r(level)
	if `"`title'"' == "" {
		local title `"`e(title)'"'
	}

	mata: _st_marg_save_double("dbl")

	tempname table code
	if "`e(cmd)'" == "pwcompare" {
		local matrix matrix(e(b_vs))
		matrix `table' = r(table_vs)
		matrix `code' = e(error_vs)
	}
	else {
		matrix `table' = r(table)
		matrix `code' = e(error)
	}

	if _caller() >= 16 {
		local SE _se_margin
	}
	else {
		local SE _se
	}

	local altvar `"`e(altvar)'"'
	local hascm : list sizeof altvar

	tempname PP _deriv _term _at _atopt _margin _se _stat _p _lb _ub
	tempname _predict

	if missing(e(df_r)) {
		local df = 0
		local trow = rownumb(`table', "z")
	}
	else {
		local df = e(df_r)
		local trow = rownumb(`table', "t")
	}

	local brow = rownumb(`table', "b")
	local serow = rownumb(`table', "se")
	local prow = rownumb(`table', "pvalue")
	local llrow = rownumb(`table', "ll")
	local ulrow = rownumb(`table', "ul")

	local XVARS `"`e(xvars)'"'
	foreach x of local XVARS {
		_ms_parse_parts `x'
		if r(base) != 1 {
			local xvars `xvars' `x'
		}
	}
	local cvars_idx 0
	if `:length local xvars' {
		scalar `_deriv'	= 0
	}
	else	scalar `_deriv'	= .
	scalar `_term'	= .
	scalar `_predict'	= .
	scalar `_at'	= .
	scalar `_atopt'	= .

	_ms_lf_info, `matrix'
	local keq = r(k_lf)
	forval i = 1/`keq' {
		local k`i' = r(k`i')
		local eq`i' = r(lf`i')
		local varlist`i' = r(varlist`i')
	}
	if `keq' == 1 {
		if `"`eq1'"' == "_" {
			local eq1
		}
	}

	local vlist0	_deriv			///
			_term			///
			_predict		///
			_at			///
			_atopt			///
			`dbl'	_margin		///
			`dbl'	`SE'		///
			`dbl'	_statistic	///
			`dbl'	_pvalue		///
			`dbl'	_ci_lb		///
			`dbl'	_ci_ub
	local plist0	(`_deriv')		///
			(`_term')		///
			(`_predict')		///
			(`_at')			///
			(`_atopt')		///
			(`_margin')		///
			(`_se')			///
			(`_stat')		///
			(`_p')			///
			(`_lb')			///
			(`_ub')

	local _CONS _cons

	local klabs 0

	local vnames

	// initialize the list of variables with the special choice
	// models (CM) variables
	if `hascm' {
		local alttype : type `altvar'
		if substr(`"`alttype'"',1,3) == "str" {
			tempname lab
			local k_alt = e(k_alt)
			label define `lab' 0 ""
			forval i = 1/`k_alt' {
				label define `lab' `i' `"`e(alt`i')'"', add
			}
			local templab : copy local lab
		}
		else {
			local lab : value label `altvar'
		}
		local altvarlab : var label `altvar'
		local vnames `vnames' `altvar' _outcome
		local vlist `vlist' int `altvar' int _outcome
		tempname cm_altvar cm_outcome
		scalar `cm_altvar' = .
		scalar `cm_outcome' = .
		local plist `plist' (`cm_altvar') (`cm_outcome')
		if `:length local lab' {
			if `:label `lab' maxlength' {
				local ++klabs
				local ++klabs
				local vllist `vllist' `altvar' _outcome
				local lllist `lllist' `lab' `lab'
			}
		}
	}

	// build the list of margin variables
	local k 0
	if `is_sum_cmd' {
		_b_term_info
		local k = r(k_terms)
	}
	else {
		local margins `"`e(margins)'"'
		if `:length local margins' {
			_fv_term_info `margins', noc
			local k = r(k_terms)
		}
	}
	local mlist
	forval i = 1/`k' {
		if "`r(level`i')'" == "matrix" {
			local colna : colna r(level`i')
			local mlist : list mlist | colna
		}
	}
	local mlist : list uniq mlist
	local mlist : list mlist - _CONS
	if `is_sum_cmd' {
		local bylist `"`e(over)'"'
		local mlist : list mlist - bylist
	}
	local MLIST : copy local mlist
	local km : list sizeof MLIST
	forval i = 1/`km' {
		local vname _m`i'
		gettoken m MLIST : MLIST
		_ms_parse_parts `m'
		local hasrcp = "`r(ts_op)'" != ""
		local m`i'name : copy local m
		if `hasrcp' {
			local type double
		}
		else {
			local m`i'lab : var label `m'
			local m`i'fmt : format `m'
			local type : type `m'
			local lab : value label `m'
		}
		local vnames `vnames' `vname'
		local vlist `vlist' `type' `vname'
		tempname m`i'
		scalar `m`i'' = .
		local plist `plist' (`m`i'')
		if `:length local lab' {
			if `:label `lab' maxlength' {
				local ++klabs
				local vllist `vllist' `vname'
				local lllist `lllist' `lab'
			}
		}
	}

	// setup for multiple predict()
	if e(k_predict) > 1 & !missing(e(k_predict)) {
		local k_predict = e(k_predict)
	}
	else	local k_predict 0

	// build the list of at() variables
	if "`e(at)'" == "matrix" {
		local rat = rowsof(e(at))
		local cat = colsof(e(at))
		local ATCOLNA : colna e(at)
		local atcolna : copy local ATCOLNA
		tempname atdim
		matrix `atdim' = e(atdims)
		local catdim = colsof(`atdim')
		local sum = `atdim'[1,1]
		forval i = 2/`catdim' {
			local sum = `sum' + `atdim'[1,`i']
			matrix `atdim'[1,`i'] = `sum'
		}
	}
	else {
		local rat 0
		local cat 0
	}
	local i 0
	forval j = 1/`cat' {
		gettoken at ATCOLNA : ATCOLNA
		_ms_parse_parts `at'
		local type = r(type)
		local hasrcp = "`r(ts_op)'" != ""
		local fmt : format `r(name)'
		if `hasrcp' {
			local name `r(ts_op)'.`r(name)'
		}
		else {
			local name `r(name)'
		}
		local pos : list posof "`name'" in atlist
		if `pos' == 0 {
			local atlist `atlist' `name'
			local atlist_type `atlist_type' `type'
			local ++i
			local vname _at`i'
			local at`i'name : copy local name
			local at`i'vname : copy local vname
			if `hasrcp' {
				local type double
			}
			else {
				local at`i'lab : var label `name'
				local type double
				local lab : value label `name'
			}
			local at`i'fmt : copy local fmt
			local vnames `vnames' `vname'
			local vlist `vlist' `type' `vname'
			tempname at`i'
			scalar `at`i'' = .
			local plist `plist' (`at`i'')
			if `:length local lab' {
				if `:label `lab' maxlength' {
					local ++klabs
					local vllist `vllist' `vname'
					local lllist `lllist' `lab'
				}
			}
		}
		else {
			local TYPE : word `pos' of `atlist_type'
			if "`type'" != "`TYPE'" {
				di as err "{p 0 0 2}"
				di as err ///
"invalid at() dimension information;{break}"
				di as err ///
"using variable `name' as a factor variable and a regular variable is"
				di as err "not supported"
				di as err "{p_end}"
				exit 322
			}
		}
	}
	local kat = `i'

	// build the list of by variables
	if `is_sum_cmd' {
		local bylist `"`e(over)'"'
	}
	else {
		local bylist `"`e(by)'"'
	}
	local hasby : list sizeof bylist
	if `hasby' {
		local BYLIST : copy local bylist
		local kby : list sizeof BYLIST
		forval i = 1/`kby' {
			local vname _by`i'
			gettoken by BYLIST : BYLIST
			local by`i'name : copy local by
			local by`i'lab : var label `by'
			local by`i'fmt : format `by'
			local type : type `by'
			local vnames `vnames' `vname'
			local vlist `vlist' `type' `vname'
			tempname by`i'
			scalar `by`i'' = .
			local plist `plist' (`by`i'')
			local lab : value label `by'
			if `:length local lab' {
				if `:label `lab' maxlength' {
					local ++klabs
					local vllist `vllist' `vname'
					local lllist `lllist' `lab'
				}
			}
		}
		local rby = e(k_by)
	}
	else {
		local rby = 1
	}

	local vlist `vlist0' `vlist'
	local plist `plist0' `plist'

	postfile `PP' `vlist' using `"`saving'"', `replace'
	local bpos 0
	local atbarpos 0
	forval i = 1/`keq' {
		if !missing(`_deriv') {
			if "`eq`i''" != "" {
				_ms_parse_parts `eq`i''
				if r(base) == 1 {
					local bpos = `bpos' + `k`i''
					continue
				}
			}
			scalar `_deriv' = `i'
		    if `"`eq`i''"' != "" {
			local derivlab `"`derivlab' `i' "`eq`i''""'
		    }
			capture local eq`i'_lab : variable label `eq`i''
			if `"`eq`i'_lab'"' == "" {
				local eq`i'_lab : copy local eq`i'
			}
		    if `"`eq`i'_lab'"' != "" {
			local derivlab2 `"`derivlab2' `i' `"`eq`i'_lab'"'"'
		    }
		}
		local oldterm	"_"
		scalar `_term'	= 0
		local oldbylevs	""
		forval j = 1/`k`i'' {
			local ++bpos
			local k 0
			if `hascm' {
				scalar `cm_altvar' = .
				scalar `cm_outcome' = .
			}
			foreach m of local mlist {
				local ++k
				scalar `m`k'' = .
			}
			local k 0
			foreach at of local atlist {
				local ++k
				scalar `at`k'' = .
			}
			local k 0
			foreach by of local bylist {
				local ++k
				scalar `by`k'' = .
			}

			_ms_element_info,	///
				element(`j')	///
				eq(#`i')	///
				`matrix'	///
				nofvlabel
			if !missing(`_deriv') {
				if "`r(note)'" == "(base)" {
					continue
				}
			}
			local term `"`r(term)'"'
			local type `"`r(type)'"'
			scalar `_margin'= `table'[`brow',`bpos']
			scalar `_se'	= `table'[`serow',`bpos']
			if missing(`_se') & `code'[1,`bpos'] != 0 {
				scalar `_margin' = .
			}
			scalar `_stat'	= `table'[`trow',`bpos']
			scalar `_p'	= `table'[`prow',`bpos']
			scalar `_lb'	= `table'[`llrow',`bpos']
			scalar `_ub'	= `table'[`ulrow',`bpos']

			local MTERM

	if `is_sum_cmd' {
		local term : subinstr local term "@" "#", all
		gettoken el varlist`i' : varlist`i'
		GetCVARS `el'
	}

	if "`type'" == "variable" {
		local pos : list posof "`term'" in xvars
		if `pos' {
			scalar `_deriv' = `pos'
			local derivlab `"`derivlab' `pos' "`term'""'
			local varlab
			capture local varlab : variable label `term'
			if `"`varlab'"' == "" {
				local varlab : copy local term
			}
			local derivlab2 `"`derivlab2' `pos' "`varlab'""'
		}
		if `is_sum_cmd' {
			if `:list sizeof CVARS' {
				local MTERM `CVARS' `MTERM'
			}
		}
	}
	else {
		if `keq' == 1 {
			if "`type'" == "factor" {
				local op "`r(level)'"
				if "`r(note)'" == "(base)" {
					local op "`op'b"
				}
				if "`r(operator)'" != "" {
					local op "`op'`r(operator)'"
				}
				local name `op'.`term'
			}
			local pos : list posof "`name'" in xvars
			if `pos' {
				scalar `_deriv' = `pos'
				local derivlab `"`derivlab' `pos' "`name'""'
				local derivlab2 `"`derivlab2' `pos' "`name'""'
			}
		}

		local LEVEL `"`r(level)'"'
	if `i' == 1 {
		local atbarpos 0
		gettoken pre post : term, parse("@|")
		if `:length local post' {
			gettoken atbar post : post, parse("@|")
			local pre : subinstr local pre "#" " ",	///
				all count(local atbarpos)
			local ++atbarpos
		}
	}
		_at_strip_contrast `term'
		local TLIST `"`r(varlist)'"'
		local TLIST : subinstr local TLIST "#" " ", all

		local k 0
		foreach m of local mlist {
			local ++k
			if strpos("`m'", ".") {
				local pos : list posof "i`m'" in TLIST
			}
			else {
				local pos : list posof "i.`m'" in TLIST
			}
			if `pos' {
				local MTERM `MTERM' `m'
				scalar `m`k'' = `:word `pos' of `LEVEL''
			}
			else {
				scalar `m`k'' = .
			}
		}

		if `is_sum_cmd' {
			if `:list sizeof CVARS' {
				local MTERM `CVARS' `MTERM'
			}
		}

		if `k_predict' {
			local pos : list posof "i._predict" in TLIST
			if `pos' {
				local plev : word `pos' of `LEVEL'
				scalar `_predict' = `plev'
			}
		}

		local atterm
		local atsharp

		local hasaltspec 0
		if `hascm' {
			local pos : list posof "i.`altvar'" in TLIST
			if `pos' {
				local alev : word `pos' of `LEVEL'
				scalar `cm_altvar' = `alev'
				local atterm `atterm'`atsharp'`alev'.`altvar'
				local atsharp "#"
				local hasaltspec 1
			}
			local pos : list posof "i._outcome" in TLIST
			if `pos' {
				local olev : word `pos' of `LEVEL'
				scalar `cm_outcome' = `olev'
			}
		}

		local k 0
		foreach by of local bylist {
			local ++k
			local pos : list posof "i.`by'" in TLIST
			if `pos' {
				local bylev : word `pos' of `LEVEL'
				scalar `by`k'' = `bylev'
				local bylevs `bylevs' `bylev'
				local atterm `atterm'`atsharp'`bylev'.`by'
				local atsharp "#"
				local byterm `byterm'`bysharp'`bylev'.`by'
				local bysharp "#"
			}
		}

		if `rat' {
			local pos : list posof "i._at" in TLIST
			if `pos' {
				local atlev : word `pos' of `LEVEL'
				local jat = rownumb(e(at), ///
						"`atlev'._at`atsharp'`atterm'")
				if `jat' == . {
					local jat = rownumb(e(at), ///
						"`atlev'._at`bysharp'`byterm'")
				}
				if `jat' == . {
					local jat = rownumb(e(at), ///
						"`atlev'._at")
				}
				if `jat' == . {
					local jat 1
				}
				local atspec
				if `hascm' {
					local atspec `"`e(atstats`jat')'"'
				}
				if `"`atspec'"' == "" {
					local atspec `"`e(atstats`atlev')'"'
				}
			}
			else { 
				if `:length local atterm' {
					local jat = rownumb(e(at), "`atterm'")
				}
				else {
					local jat 1
				}
				local atlev 1
				local atspec `"`e(atstats`atlev')'"'
			}
			scalar `_at' = `atlev'
			local jatopt 1
			while `_at' > `atdim'[1,`jatopt'] {
				local ++jatopt
			}
			scalar `_atopt' = `jatopt'
			local k 0
			foreach at of local atcolna {
				gettoken spec atspec : atspec
				local ++k
				_ms_parse_parts `at'
				local hasrcp = "`r(ts_op)'" != ""
				if `hasrcp' {
					local name `r(ts_op)'.`r(name)'
				}
				else {
					local name `r(name)'
				}
				local pos : list posof "`name'" in atlist
				if r(type) == "variable" {
					if "`spec'" == "asobserved" {
						scalar `at`pos'' = .o
					}
					else {
						scalar `at`pos'' = ///
							el(e(at),`jat',`k')
					}
				}
				else {
					if "`spec'" == "asbalanced" {
						scalar `at`pos'' = .b
					}
					else if "`spec'" == "asobserved" {
						scalar `at`pos'' = .o
					}
					else if el(e(at),`jat',`k') == 1 {
						scalar `at`pos'' = r(level)
					}
				}
			}
		}

	}

			if !`:list MTERM == oldterm' {
				scalar `_term' = `_term' + 1
				local oldterm : copy local MTERM 
			}

	if `i' == 1 {
			local k = `_term'
			RebuildMTERM MTERM : `atbarpos' "`atbar'" `MTERM'
			local mVlab `"`mVlab' `k' "`MTERM'""'
	}

			post `PP' `plist'
		}
	}
	postclose `PP'

	if "`nofvlabel'" != "" {
		local klabs 0
	}
	else if `klabs' {
		tempfile labfile
		quietly label save `lllist' using `"`labfile'"'
	}

	preserve
	quietly use `"`saving'"', clear

	// variable labels and characteristics
	label var _deriv	"Derivatives w.r.t."
	label var _term		"Margin term index"
	label var _predict	"predict() option index"
	label var _at		"Covariates fixed values index"
	label var _atopt	"at() option index"

	if `hascm' {
		if `:length local altvarlab' {
			label var `altvar'	"`altvarlab'"
			label var _outcome	"`altvarlab'"
		}
		else {
			label var `altvar'	"Alternative"
			label var _outcome	"Outcome"
		}
	}

	// margining variable characteristics
	if `:length local mVlab' {
		label define _term `mVlab'
		label values _term _term
	}
	local i 0
	foreach m of local mlist {
		local ++i
		if `:length local m`i'lab' {
			label var _m`i' `"`m`i'lab'"'
		}
		else {
			label var _m`i' `"`m`i'name'"'
		}
		char _m`i'[varname] `"`m`i'name'"'
		format _m`i' `m`i'fmt'
	}
	if _caller() >= 16 {
		char _dta[marg_save_version] "2"
	}
	char _dta[margin_vars] `"`mlist'"'
	char _dta[cmd] `"`e(cmd)'"'

	if `hascm' {
		char _dta[altvar] `altvar'
		char `altvar'[varname] `altvar'
		char _outcome[varname] _outcome
	}

	// at() variable characteristics
	if `is_sum_cmd' {
		local k_at 0
	}
	else {
		local k_at = e(k_at)
	}
	forval i = 1/`k_at' {
		local atoptVlab `"`atoptVlab' `i' `"`e(atopt`i')'"'"'
	}
	forval i = 1/`rat' {
		local speclist
		local atspec `"`e(atstats`i')'"'
		local oldname
		foreach at of local atcolna {
			gettoken spec atspec : atspec
			_ms_parse_parts `at'
			local hasrcp = "`r(ts_op)'" != ""
			if `hasrcp' {
				local name `r(ts_op)'.`r(name)'
			}
			else {
				local name `r(name)'
			}
			if r(type) == "factor" {
				if `"`name'"' != `"`oldname'"' {
					local speclist `speclist' `spec'
				}
				local oldname : copy local name
			}
			else {
				local speclist `speclist' `spec'
				local oldname
			}
		}
		local atspec`i' : copy local speclist
		char _dta[atopt`i'] `"`e(atopt`i')'"'
		char _dta[atstats`i'] `"`speclist'"'
	}
	if `:length local atoptVlab' {
		label define _atopt `atoptVlab'
		label values _atopt _atopt
	}
	char _dta[k_at] `"`k_at'"'
	local i 0
	foreach at of local atlist {
		local ++i
		if `:length local at`i'lab' {
			label var _at`i' `"`at`i'lab'"'
		}
		else {
			label var _at`i' `"`at`i'name'"'
		}
		char _at`i'[varname] `"`at`i'name'"'
		char _at`i'[stats] `"`atspec`i''"'
		format _at`i' `at`i'fmt'
	}
	char _dta[at_vars] `"`atlist'"'
	local uatvars `"`e(u_at_vars)'"'
	foreach var of local uatvars {
		local pos : list posof "`var'" in atlist
		local _u_at_vars `"`_u_at_vars' _at`pos'"'
	}
	char _dta[u_at_vars] `"`e(u_at_vars)'"'
	char _dta[_u_at_vars] `"`:list retok _u_at_vars'"'

	// over() and within() variable characteristics
	local i 0
	foreach by of local bylist {
		local ++i
		if `:length local by`i'lab' {
			label var _by`i' `"`by`i'lab'"'
		}
		else {
			label var _by`i' `"`by`i'name'"'
		}
		local BYLIST `BYLIST' _by`i'
		char _by`i'[varname] `"`by`i'name'"'
		format _by`i' `by`i'fmt'
	}
	char _dta[over]			`"`e(over)'"'
	char _dta[within]		`"`e(within)'"'
	char _dta[by_vars]		`"`bylist'"'
	char _dta[title]		`"`title'"'
	char _dta[predict_label]	`"`e(predict_label)'"'
	char _dta[expression]		`"`e(expression)'"'

	// predict() variable characteristics
	if `k_predict' {
		char _dta[k_predict] `k_predict'
		forval i = 1/`k_predict' {
			local label `"predict(`e(predict`i'_opts)')"'
			local predVlab `"`predVlab' `i' `"`label'"'"'
		}
		label define _predict `predVlab'
		label values _predict _predict
	}

	local label `"`e(predict_label)'"'
	if `:length local label' {
		local comma ", "
	}
	label var _margin	`"`label'`comma'`e(expression)'"'
	label var `SE'		"Standard error"
	if "`e(df_r)'" == "" {
		local z z
	}
	else	local z t
	label var _statistic	"`z'-statistic"
	label var _pvalue	"P>|`z'|"
	label var _ci_lb	"`level'% Confidence interval, LB"
	label var _ci_ub	"`level'% Confidence interval, UB"
	label data "Created by command margins; also see char list"

	// add value labels
	if `:length local derivlab' {
		label define _deriv `derivlab'
		label values _deriv _deriv
	}
	if `:length local derivlab2' {
		label define _derivl `derivlab2'
		quietly label language derivlabels, new
		label values _deriv _derivl
		quietly label language default
	}

	if `klabs' {
		// add value labels from the original dataset
		run `"`labfile'"'
		forval i = 1/`klabs' {
			gettoken var vllist : vllist
			gettoken lab lllist : lllist
			label values `var' `lab'
		}
		if `"`templab'"' != "" {
			label copy `templab' `altvar', replace
			label values `altvar' `altvar'
			label values _outcome `altvar'
			label drop `templab'
		}
	}
	if `k_predict' {
		local nopredict	contrast	///
				pwcompare	///
				mean		///
				proportion	///
				ratio		///
				total
		if 0`:list posof "`e(cmd)'" in nopredict' == 0 {
			if "`ehold'" == "" {
				tempname ehold
				_est hold `ehold', restore copy
			}
			label copy _predict _predict, eclass
		}
	}
	if "`e(cmd)'" == "contrast" {
		tempname t
		_ms_to_vl, prefix(`t') nopar `nofvlabel'
		local k = r(k_names)
		forval i = 1/`k' {
			local name = r(name`i')
			local vl = r(vl`i')
			local pos : list posof "`name'" in mlist
			if `pos' {
				label copy `vl' _m`pos'
				label values _m`pos' _m`pos'
			}
			local pos : list posof "`name'" in atlist
			if `pos' {
				label copy `vl' _at`pos'
				label values _at`pos' _at`pos'
			}
			local pos : list posof "`name'" in bylist
			if `pos' {
				label copy `vl' _by`pos'
				label values _by`pos' _by`pos'
			}
			if "`name'" == "_predict" {
				label copy `vl' _predict, replace
				label values _predict _predict
			}
			if "`name'" == "_outcome" {
				label copy `vl' _outcome, replace
				label values _outcome _outcome
			}
			if "`name'" == "`altvar'" {
				label copy `vl' `altvar', replace
				label values `altvar' `altvar'
			}
			label drop `vl'
		}
	}
	else if "`e(cmd)'" == "pwcompare" {
		CMP2VL
	}

	// characteristics from the scalars and macros in 'e()'
	quietly compress
	quietly save `"`saving'"', replace
end

program GetCVARS
	tempname H
	_return hold `H'

	_ms_parse_parts `0'

	if "`r(type)'" == "variable" {
		if "`r(ts_op)'" == "" {
			local CVARS `r(name)'
		}
		else {
			local CVARS `r(ts_op)'.`r(name)'
		}
	}
	else if "`r(type)'" == "interaction" {
		local CVARS
		local k = r(k_names)
		forval i = 1/`k' {
			if "`r(level`i')'" != "" {
			continue
			}
			if "`r(ts_op`i')'" == "" {
				local CVARS `CVARS' `r(name`i')'
			}
			else {
				local CVARS `CVARS' `r(ts_op`i')'.`r(name`i')'
			}
		}
	}

	c_local CVARS `CVARS'

	_return restore `H'
end

program RebuildMTERM
	gettoken c_mterm	0 : 0
	gettoken COLON		0 : 0
	gettoken atbarpos	0 : 0
	gettoken atbar		MTERM : 0

	local dim : list sizeof MTERM
	if `atbarpos' < `dim' {
		local mterm : copy local MTERM
		local MTERM
		forval i = 1/`atbarpos' {
			gettoken term mterm : mterm
			local MTERM `MTERM' `term'
		}
		local MTERM `MTERM'`atbar'`:list retok mterm'
	}
	else if `dim' == 0 {
		local MTERM _cons
	}
	local MTERM : list retok MTERM
	local MTERM : subinstr local MTERM " " "#", all
	c_local `c_mterm' `"`MTERM'"'
end

program CMP2VL
	_ms_eq_info, matrix(e(b_vs))
	local keq = r(k_eq)
	forval eq = 1/`keq' {
		local k`eq' = r(k`eq')
	}
	gen _pw = _n
	local j 0
	forval eq = 1/`keq' {
		forval el = 1/`k`eq'' {
			local ++j
			_ms_element_info,	el(`el')	///
						eq(#`eq')	///
						width(900)	///
						matrix(e(b_vs))	///
						compare		///
						nofvlabel	///
								 // blank
			label define _pw `j' `"`r(level)'"', add
		}
	}
	label values _pw _pw
end

exit

