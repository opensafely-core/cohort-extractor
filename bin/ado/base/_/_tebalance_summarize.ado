*! version 1.0.1  29may2015

program define _tebalance_summarize, rclass
	version 14.0

	local match = ("`e(subcmd)'"=="nnmatch" | "`e(subcmd)'"=="psmatch")
	if `match' & "`e(indexvar)'" == "" {
		di as txt "{p 0 6 2}note: refitting the model using " ///
		 "the {bf:generate()} option{p_end}"
		tempname ix est
		qui estimates store `est'

		local ix `ix'_
		_tebalance_cmd_generate `ix'
		local cmd `"`s(cmdline)'"'
	}
	cap noi {
		if `"`cmd'"' != "" {
			qui `cmd'
		}
		_tebalanceSummarize `0'
		if "`ix'" != "" {
			qui drop `e(indexvar)'
		}
	}
	local rc = c(rc)
	if (!`rc') return add

	if "`est'" != "" {
		qui estimates restore `est'
		/* clear return code					*/
		capture
	}
	exit `rc'
end

program define _tebalanceSummarize, rclass
	syntax [ varlist(numeric fv default=none) ], [ BASEline ONEScale ]
	/* undocumented: ONEScale -- scale mean differences for matched	*/
	/*				distribution using variance	*/
	/*				from the unmatched distribution	*/
	tempname table nn m0 m1 v0 v1 s m0x m1x v0x v1x sx
	tempvar tu wvar

	qui gen byte `tu' = e(sample)
	if "`e(wtype)'" == "fweight" {
		tempvar w

		qui gen long `w'`e(wexp)' if `tu'
		local wght [fw=`w']
		local wopt wt(`w')
	}
	_tebalance_weights `wvar', tu(`tu') `wopt'

	/* future work: display options					*/
	local diopts

	/* treatment variable						*/
	local tvar `e(tvar)'
	local basel = ("`baseline'"!="")
	local match = ("`e(subcmd)'"=="nnmatch")

	local vlist `varlist'
	if "`vlist'" == "" {
		if (`match') {
			local vlist `"`e(fvdvarlist)'"'
		}
		else {
			local vlist `e(fvtvarlist)'
			local match = ("`e(subcmd)'"=="psmatch")
			if "`e(tmodel)'" == "hetprobit" {
				local hvlist `e(fvhtvarlist)'
				local hvlist : list hvlist - vlist
				local vlist `"`vlist' `hvlist'"'
			}
		}
	}
	else {
		local match = `match' | ("`e(subcmd)'"=="psmatch")
		fvexpand `vlist' if `tu'
		local vlist `r(varlist)'
	}
	local k : list sizeof vlist
	local tlev `e(tlevels)'
	local klev : list sizeof tlev
	local t0 = e(control)
	local t1 = e(treated)
	local att = ("`e(stat)'"=="atet")
	local j0 : list posof "`t0'" in tlev
	local j1 : list posof "`t1'" in tlev
	if (`match') local tech Matched
	else local tech Weighted

	if `basel' {
		local cnames  means:Control means:Treated
		local cnames  `cnames' variance:Control variance:Treated
	}
	else {
		local cnames  std_diff:Raw std_diff:`tech'
		local cnames  `cnames' ratio:Raw ratio:`tech'
	}
	local tlab : value label `tvar'

	local tsz = 0
	local kv = 0
	if `klev' == 2 {
		local nnames `""Number of obs" "Treated obs" "Control obs""'
		
		local jt = 1	// N total
		local j1 = 2	// N treated
		local j0 = 3	// N control

		forvalues j=1/`k' {
			local v : word `j' of `vlist'
			_ms_parse_parts `v'
			if r(omit) {
				continue
			}
			local vlist1 `"`vlist1' `v'"'
			local `++tsz'
			local rnames `"`rnames' `v'"'
		}
		local kv = `tsz'
	}
	else {
		local jt = `klev' + 1
		forvalues i=1/`klev' {
			local ti : word `i' of `tlev'
			if "`tlab'" != "" {
				local eq : label `tlab' `ti'
			}
			else {
				local eq `ti'.`tvar'
			}
			local nnames `"`nnames' "`eq'""'
			if `ti' == `t0' {
				continue
			}
			forvalues j=1/`k' {
				local v : word `j' of `vlist'
				_ms_parse_parts `v'
				if r(omit) {
					continue
				}
				local vlist1 `"`vlist1' `v'"'
				local `++tsz'
				local rnames `"`rnames' "`eq':`v'""'
			}
			if (!`kv') local kv = `tsz'
		}
		local nnames `"`nnames' "Total""'
	}
	local vlist `"`vlist1'"'
	mat `table' = J(`tsz',4,0)
	mat `nn' = J(`klev'+1,2,0)
	mat rownames `nn' = `nnames'
	mat colnames `nn' = Raw `tech'

	mat rownames `table' = `rnames'
	mat colnames `table' = `cnames'

	local l = 0
	forvalues i=1/`kv' {
		local exp : word `i' of `vlist'
		_ms_parse_parts `exp'
		if "`r(type)'" == "variable" {
			local var `exp'
		}
		else {
			fvrevar `exp' if `tu'
			local var `r(varlist)'
			label variable `var' "`exp'"
		}
		local l = max(`l',strlen("`exp'"))
		local label `label' `i' `exp'

		/* unmatched observations				*/
		qui summarize `var' `wght' if `tvar'==`t0' & `tu'
		scalar `m0' = r(mean)
		scalar `v0' = r(Var)
		mat `nn'[`j0',1] = r(sum_w) // N control
		mat `nn'[`jt',1] = r(sum_w) // N total

		/* matched/IPW observations				*/
		qui summarize `var' [iw=`wvar'] if `tvar'==`t0' & `tu'
		scalar `m0x' = r(mean)
		scalar `v0x' = r(Var)
		mat `nn'[`j0',2] = r(sum_w) // N control
		mat `nn'[`jt',2] = r(sum_w) // N total

		local jj = -1
		forvalues j=1/`klev' {
			local tj : word `j' of `tlev'
			if `tj' == `t0' {
				continue
			}
			if (`klev'>2) local j1 = `j'

			qui summarize `var' `wght' if `tvar'==`tj' & `tu'
			scalar `m1' = r(mean)
			scalar `v1' = r(Var)
			mat `nn'[`j1',1] = r(sum_w)
			local ij = `++jj'*`kv'+`i'

			if (`match' & `att') {
				scalar `m1x' = `m1'
				scalar `v1x' = `v1'
				mat `nn'[`j1',2] = `nn'[`j1',1]
			}
			else {
				/* matched/IPW observations		*/
				qui summarize `var' [iw=`wvar'] ///
					if `tvar'==`tj' & `tu'
				scalar `m1x' = r(mean)
				scalar `v1x' = r(Var)
				mat `nn'[`j1',2] = r(sum_w)
			}
			mat `nn'[`jt',2] = `nn'[`jt',2] + `nn'[`j1',2]
			mat `nn'[`jt',1] = `nn'[`jt',1] + `nn'[`j1',1]

			if `basel' {
				mat `table'[`ij',1] = scalar(`m0')
				mat `table'[`ij',2] = scalar(`m1')
				mat `table'[`ij',3] = scalar(`v0')
				mat `table'[`ij',4] = scalar(`v1')
			}
			else {
				scalar `s' = sqrt((scalar(`v1')+scalar(`v0'))/2)
				if "`onescale'" == "" {
					scalar `sx' = sqrt((scalar(`v1x')+ ///
						scalar(`v0x'))/2)
				}
				else scalar `sx' = `s'

				mat `table'[`ij',1] = (scalar(`m1')- ///
					scalar(`m0'))/scalar(`s')
				mat `table'[`ij',2] = (scalar(`m1x')- ///
					scalar(`m0x'))/scalar(`sx')
				mat `table'[`ij',3] = scalar(`v1')/scalar(`v0')
				mat `table'[`ij',4] = scalar(`v1x')/ ///
					scalar(`v0x')
			}
		}
	}
	Display `nn' `table' : `diopts'

	return mat table = `table', copy
	return mat size = `nn'
	return local options `options'
end

program define Display
	_on_colon_parse `0'
	
	local before `s(before)'
	/* future: 0 to have display options 			*/
	local 0 `"`s(after)'"'

	gettoken nn stat : before

	local clab : colnames `nn'
	local rlab : rownames `nn', quoted
	local r = rowsof(`nn')
	local wx = 0
	forvalues i=1/`r' {
		loca rl : word `i' of `rlab'
		local w = strlen("`rl'")
		if (`w'>`wx') local wx = `w'
	}
	local wx = min(`wx',13)
	local c1 : word 1 of `clab'
	local c2 : word 2 of `clab'

	tempname tab

	di as txt _n "{p 2 0 2}Covariate balance summary{p_end}"

	.`tab' = ._tab.new
	if `r' > 3 {
		.`tab'.reset, columns(2) lmargin(26)
		.`tab'.width 15 26
		.`tab'.titlefmt . %~26s
		.`tab'.titles "" "   Observations"
		local tlab Treatment
	}

	.`tab'.reset, columns(3) lmargin(26)
	.`tab'.width 15 13 13
	.`tab'.titlefmt . %13s %13s
	.`tab'.strfmt . . .
	if "`e(subcmd)'"=="nnmatch" | "`e(subcmd)'"=="psmatch" {
		.`tab'.numfmt . %10.0gc %10.0fc
	}
	else {
		.`tab'.numfmt . %10.0gc %10.1fc
	}
	.`tab'.pad . 3 3
	.`tab'.titlecolor . . .
	.`tab'.strcolor . result result
	.`tab'.numcolor . . .
	.`tab'.titles "`tlab'" "`c1'" "`c2'"
	.`tab'.sep, top
	tempname n1 n2
	forvalues i=1/`r' {
		loca rl : word `i' of `rlab'
		
		local w = strlen("`rl'")
		if `w' > `wx' {
			local rl = abbrev("`rl'",`wx')
		}
		else {
			forvalues j=1(1)`=`wx'-`w'' {
				local rl `"`rl' "'
			}
		}
		scalar `n1' = `nn'[`i',1]
		scalar `n2' = `nn'[`i',2]
		.`tab'.row "`rl' =" `n1' `n2'
	}
	.`tab'.sep, bottom

	local clab : colnames `stat'
	local ceq : coleq `stat'
	local which : word 1 of `ceq'
	if "`which'" == "std_diff" {
		local ttitle1 "Standardized differences"
		local ttitle2 "Variance ratio"
		local twidth 24 24
	}
	else {
		local ttitle1 "    Means"
		local ttitle2 "     Variances"
		local twidth 24 24
		local c ~
	}
	local rlab : rownames `stat', quoted
	local r = rowsof(`stat')
	local req : roweq `stat', quoted
	local req : list retokenize req

	local c1 : word 1 of `clab'
	local c2 : word 2 of `clab'
	local c3 : word 3 of `clab'
	local c4 : word 4 of `clab'

	di 
	.`tab'.reset, columns(3) lmargin(2)
	.`tab'.width 16 | `twidth'
	.`tab'.titlefmt . %`c'23s %`c'24s
	.`tab'.sep, top
	.`tab'.titles "" "`ttitle1'" "`ttitle2'"

	.`tab'.reset, columns(5) lmargin(2)
	.`tab'.width 16 | 12 12 12 12
	.`tab'.titlefmt . %11s %11s %13s %11s
	.`tab'.strfmt . . . . .
	.`tab'.numfmt . %9.0g %9.0g %9.0g %9.0g
	.`tab'.pad . 2 2 4 2
	.`tab'.titlecolor result . . . .
	.`tab'.strcolor . result result result result
	.`tab'.numcolor . . . . .
	.`tab'.titles "" "`c1'" "`c2'" "`c3'" "`c4'"
	.`tab'.sep, middle
	local j = 0
	forvalues i=1/`r' {
		local eqi : word `i' of `req'
		local k = strlen("`eqi'")
		if `k' > 15 {
			local eqi = abbrev("`eqi'",15)
		}	
		local neweq = ("`eqi'"!="`eqj'" & "`eqi'"!="_")
		if `neweq'{
			if (`i' > 1) .`tab'.sep, middle

			.`tab'.strfmt %-15s . . . .
			.`tab'.strcolor result result result result result
			.`tab'.row "`eqi'" "" "" "" ""
			.`tab'.strfmt %15s . . . .
			.`tab'.strcolor text result result result result
		}
		local rl : word `i' of `rlab'
		_ms_parse_parts `rl'
		if "`r(type)'" == "factor" {
			local var `r(name)'
			local rl = r(level)
			if "`fvar'" != "`var'" {
				local fvar `var'
				local lab : value label `r(name)'
				if !`neweq' & `i'>1 {
					.`tab'.row "" "" "" "" ""
				}
				if strlen("`var'") > 15 {
					local var = abbrev("`var'",15)
				}	
				.`tab'.strfmt %15s . . . .
				.`tab'.row "`var'" "" "" "" ""
			}
			if ("`lab'"!="") local rl : label `lab' `rl'
		}
		else if "`r(type)'"=="interaction" | "`r(type)'"=="product" {
			local kn = r(k_names)
			local rl
			forvalues j=1/`kn' {
				local varj `r(name`j')'
				if "`r(op`j')'" != "c" {
					local rlj = r(level`j')
					local labj : value label `varj'
					if "`labj'" != "" {
						local rlj : label `labj' `rlj'
					}
				}

				if `j' == 1 {
					local fvar0 `"`varj'"'
					if "`r(op`j')'" != "c" {
						local rl `"`rlj'"'
					}
				}
				else {
					local fvar0 `"`fvar0'#`varj'"'
					if "`r(op`j')'" != "c" {
						if "`rl'" != "" {
							local rl `"`rl'#`rlj'"'
						}
						else  local rl `"`rlj'"'
					}
				}

			}
			if `"`fvar'"' != `"`fvar0'"' {
				local fvar `"`fvar0'"'
				if !`neweq' & `i'>1 {
					.`tab'.row "" "" "" "" ""
				}
				forvalues j=1/`kn' {
					local varj `r(name`j')'
					if strlen("`varj'") > 15 {
						local varj = abbrev("`varj'",15)
					}
					if (`j'<`kn') {
						local varj `"`varj'#"'
						.`tab'.strfmt %16s . . . .
					}
					else {
						.`tab'.strfmt %15s . . . .
					}
					if "`rl'" == "" & `j'==`kn' {
						.`tab'.row "`varj'" ///
							`stat'[`i',1] ///
							`stat'[`i',2] ///
							`stat'[`i',3] ///
							`stat'[`i',4]
					}
					else {
						.`tab'.row "`varj'" "" "" "" ""
					}
				}	
			}
		}
		else if "`fvar'" != "" {
			.`tab'.row "" "" "" "" ""
			local fvar
		}
		local k = strlen("`rl'")
		if "`fvar'" != "" {
			if `k' > 14 {
				local rl = abbrev("`rl'",14)
			}
			.`tab'.strfmt %14s . . . .
		}
		else {
			if `k' > 15 {
				local rl = abbrev("`rl'",15)
			}
			.`tab'.strfmt %15s . . . .
		}
		local rl : list retokenize rl
		if "`rl'" != "" {
			.`tab'.row "`rl'" `stat'[`i',1] `stat'[`i',2] ///
					`stat'[`i',3] `stat'[`i',4]
		}

		local eqj `eqi'
	}
	.`tab'.sep, bottom
end

exit
