*! version 1.0.2  10jul2017

program define _tebalance_density, rclass
	version 14

	local match = ("`e(subcmd)'"=="psmatch")
	if `match' {
		syntax [ varname(numeric fv default=none) ], [ * ]
	}
	else {
		local match = ("`e(subcmd)'"=="nnmatch")
		syntax varname(numeric fv), [ * ]
	}
	ParseKernelOpts, `options'
	if "`s(kernel)'" != "" {
		local kopts kernel(`s(kernel)')
	}
	if "`s(n)'" != "" {
		local kopts `kopts' n(`s(n)')
	}
	if "`s(bwidth)'" != "" {
		local bwopt bwidth(`s(bwidth)')
	}
	local options `"`s(options)'"'

	preserve
	tempvar tu
	qui gen byte `tu' = e(sample)

	if "`varlist'" != "" {
		fvexpand `varlist' if `tu'
		local vname `r(varlist)'

		local k : list sizeof vname
		if `k' > 1 {
			di as err "{p}expanding {bf:`varlist'} results in " ///
			 "more than one variable; this is not allowed{p_end}"
			exit 198
		}
	}
	if `match' {
		local 0, `options'
		syntax, [ mweights * ]
		/* undocumented: mweights - compute density using 	*/
		/* 			   matching weights as iweights	*/
	}
	ParseGraphOpts `vname' : `options'
	local sgopts sgopts(`s(sgopts)')
	local byopts byopts(`s(byopts)')
	local klev = e(k_levels)
	forvalues i=1/`klev' {
		local lines `"`lines' line`i'(`s(line`i')')"'
	}
	local name name(`s(name)')

	if "`e(wtype)'" == "fweight" {
		tempvar w

		qui gen long `w'`e(wexp)' if `tu'
		local wopt wt(`w')
	}

	if `match' & "`mweights'"=="" {
		if "`vname'" != "" {
			local vopt var(`vname')
			_ms_parse_parts `vname'
			if "`r(type)'" == "variable" {
				local lab : variable label `vname'
			}
			if ("`lab'"!="") local lopt label(`lab')
			else local lopt label(`vname')
		}
		else local lopt label(Propensity Score)

		if "`e(indexvar)'" == "" {
			di as txt "{p 0 6 2}note: refitting the model " ///
			 "using the {bf:generate()} option{p_end}"
			tempname ix est
			qui estimates store `est'

			local ix `ix'_
			_tebalance_cmd_generate `ix'
			local cmd `"`s(cmdline)'"'
		}
		tempvar xt xc
		cap noi {
			if `"`cmd'"' != "" {
				qui `cmd'
			}
			/* calls -keep if `tu'-				*/
			_tebalance_stackvar, `vopt' xt(`xt') xc(`xc') ///
				`wopt' tu(`tu')
			local N = r(N)

			DensityMatch, xt(`xt') xc(`xc') n0(`N') `lopt'  ///
				`wopt' `sgopts' `byopts' `name' `lines' ///
				`kopts' `bwopt'
		}
		local rc = c(rc)
		if (!`rc') return add

		if "`est'" != "" {
			qui estimates restore `est'
			/* clear return code				*/
			capture
		}
		exit `rc'
	}
	tempvar wvar
	if `match' {
		if "`e(indexvar)'" == "" {
			di as txt "{p 0 6 2}note: refitting the model " ///
			 "using the {bf:generate()} option{p_end}"
			tempname ix est
			qui estimates store `est'

			local ix `ix'_
			_tebalance_cmd_generate `ix'
			local cmd `"`s(cmdline)'"'
		}
	}
	cap noi {
		if "`cmd'" != "" {
			qui `cmd'
		}
		_tebalance_weights `wvar', tu(`tu') `wopt'
		if "`vname'" == "" {
			/* psmatch propensity scores			*/
			tempname vname
			qui predict double `vname', ps tlevel(`e(treated)')

			label variable `vname' "Propensity Score"
		}
		DensityIPW `vname', `wopt' tu(`tu') wvar(`wvar') `kopts' ///
			`sgopts' `byopts' `name' `lines' `bwopt'
	}
	local rc = c(rc)
	if (!`rc') return add

	if "`est'" != "" {
		qui estimates restore `est'
	}
	exit `rc'
end

program define ParseKernelOpts, sclass
	syntax, [ kernel(string) n(string) BWidth(string) * ]

	ParseKernelFun, `kernel'
	local kernel `s(kernel)'
	if ("`kernel'"!="") sreturn local kernel `kernel'

	if "`n'" != "" {
		cap confirm integer number `n'
		local rc = c(rc)
		if !`rc' {
			cap assert `n' > 0
			local rc = c(rc)
		}
		if `rc' {
			di as err "{p}option invalid {bf:n(`n')}; number " ///
			 "of points for the kernel density estimate must " ///
			 "be greater than zero{p_end}"
			exit 198
		}
		sreturn local n = `n'
	}
	if "`bwidth'" != "" {
		local bwidth : list clean bwidth
		gettoken star bwval : bwidth, parse(*)
		local rc = 198*("`star'"!="*")
		if !`rc' {
			cap confirm number `bwval'
			local rc = c(rc)
			if !`rc' {
				cap assert `bwval' > 0
				local rc = c(rc)
			}
		}
		if `rc' {
			di as err "{p}invalid {bf:bwidth(`bwidth')} "     ///
			 "specification; use {bf:bwidth(*}{it:#}{bf:)}, " ///
			 "where the kernel half-width scale {it:#} is "   ///
			 "a positive number{p_end}"
			exit 198
		}
		sreturn local bwidth `bwval'
	}
	sreturn local kernel `kernel'
	sreturn local options `"`options'"'
end

program define ParseKernelFun, sclass
	cap noi syntax, [ BIweight COSine EPanechnikov GAUssian PARzen ///
		RECtangle TRIangle epan2 ]

	local rc = c(rc)
	if `rc' {
		di as err "in option {bf:kernel()}"
		exit `rc'
	}

	local fun `biweight' `cosine' `epanechnikov' `gaussian' `parzen'
	local fun `fun' `rectangle' `triangle' `epan2'
	local k : word count `fun'

	if !`k' {
		exit
	}
	else if `k' > 1 {
		di as err "{p}option invalid {bf:kernel()}; only one kernel " //
		 "function may be specified{p_end}"
		exit 184
	}
	local fun : list retokenize fun
	sreturn local kernel `fun'
end

program define DensityIPW, rclass

	local klev = e(k_levels)
	forvalues i=1/`=e(k_levels)' {
		local lines `lines' line`i'(string asis)
	}

	syntax varname(numeric fv), wvar(string) tu(varname) [ wt(string) ///
		kernel(passthru) n(string) BWidth(string)                 ///
		sgopts(string asis) byopts(string asis) name(string) `lines' ]

	local var `varlist'
	local vlabel `var'
	_ms_parse_parts `var'
	if "`r(type)'" != "variable" {
		fvrevar `var'
		local var `r(varlist)'
		label variable `var' "`varlist'"
	}
	else {
		local vlabel : variable label `var'
		if `"`vlabel'"' == "" {
			local vlabel `var'
		}
	}

	tempvar wvar0
	local tvar `e(tvar)'
	local tlev `e(tlevels)'
	local tlab : value label `tvar'
	local match = ("`e(subcmd)'"=="psmatch" | "`e(subcmd)'"=="nnmatch")

	local wght2 [iw=`wvar0']
	qui gen double `wvar0' = .
	if ("`wt'"!="") local wght1 [fw=`wt']
	else {
		tempname wt
		scalar `wt' = 1
	}
	tempvar raw wght

	ParseLegend, `sgopts'
	local sgopts `"`s(sgopts)'"'
	local blegend = `s(blegend)'
	local byopts `"`byopts' `s(byopts)'"'

	gen byte `raw' = 1
	gen byte `wght' = 2

	tempname grp rw z d u

	forvalues i=1/`klev' {	
		tempvar z`i' d`i' zw`i' dw`i' g`i' u`i'

		local ti : word `i' of `tlev'
		if "`tlab'" != "" {
			local lab : label `tlab' `ti'
		}
		else if `klev' == 2 {
			if `ti' == e(control) {
				local lab control
			}
			else {
				local lab treated
			}
		}
		else {
			local lab `tvar'=`ti'
		}
		qui gen int `g`i'' = `ti'

		local glabel `"`glabel' `ti' "`lab'""'
		if `blegend' {
			local legend `"`legend' label(`i' "`lab'")"'
		}
		gen byte `u`i'' = `tvar'==`ti' & `tu'
		local iff if `u`i''
		if "`n'" == "" {
			qui count `iff'
			local N = r(N)
			local nopt n(`N')
		}
		else {
			local N = `n'
			local nopt n(`n')
		}
		/* suppress any notes from -kdensity-			*/
		qui kdensity `var' `wght1' `iff', nograph gen(`z`i'' `d`i'') ///
			`nopt' `kernel'
		if "`bwidth'" != "" {
			local bw = `bwidth'*r(bwidth)
			qui drop `z`i'' `d`i''
			qui kdensity `var' `wght1' `iff', nograph ///
				gen(`z`i'' `d`i'') `nopt' `kernel' bwidth(`bw')
		}
		local N`ti'_raw = r(n)
		local bw`ti'_raw = r(bwidth)

		/* normalized iweights to 1				*/
		summarize `wvar' `iff' `wght1', meanonly
		qui replace `wvar0' = `wt'*`wvar'/r(sum) `iff'

		qui kdensity `var' `wght2' `iff', nograph ///
			gen(`zw`i'' `dw`i'') `nopt' `kernel'
		if "`bwidth'" != "" {
			local bw = `bwidth'*r(bwidth)
			qui drop `zw`i'' `dw`i''
			qui kdensity `var' `wght2' `iff', nograph    ///
				gen(`zw`i'' `dw`i'') `nopt' `kernel' ///
				bwidth(`bw')
		}
		local N`ti'_weighted = r(n)
		local bw`ti'_weighted = r(bwidth)

		qui replace `u`i'' = cond(_n<=`N',1,0)
		local stack `"`stack' `u`i'' `g`i'' `raw' `z`i'' `d`i''"'
		local stack `"`stack' `u`i'' `g`i'' `wght' `zw`i'' `dw`i''"'

		local twoway `"`twoway' (line `d' `z' if `u'&`grp'==`ti',"'
		local twoway `"`twoway' `line`i'')"'
	}
	local kernel `r(kernel)'
	if `blegend' {
		local legopt legend(`legend')
	}
	tempname zr zw raw weighted lrw lgrp
	stack `stack', into(`u' `grp' `rw' `z' `d') clear
	label variable `d' "Density"
	label variable `z' "`vlabel'"
	if `match' {
		label define `lrw' 1 "Raw" 2 "Matched"
		label variable `rw' "raw and matched data"
	}
	else {
		label define `lrw' 1 "Raw" 2 "Weighted"
		label variable `rw' "raw and weighted data"
	}
	label values `rw' `lrw'
	label define `lgrp' `glabel'
	label values `grp' `lgrp'

	twoway `twoway', by(`rw', `byopts') `sgopts' `legopt'

	forvalues i=1/`klev' {	
		local ti : word `i' of `tlev'
		if `klev' == 2 {
			if `ti' == e(control) {
				local li c
			}
			else {
				local li t
			}
		}
		else {
			local li `ti'
		}
		return scalar N`li'_raw = `N`ti'_raw'
		return scalar N`li'_adj = `N`ti'_weighted'
		return scalar bw`li'_raw = `bw`ti'_raw'
		return scalar bw`li'_adj = `bw`ti'_weighted'
	}
	return local kernel `kernel'
end

program define DensityMatch, rclass
	syntax, xt(string) xc(string) n0(integer) label(string) [ wt(string) ///
		sgopts(string asis) byopts(string asis) line1(string asis)   ///
		line2(string asis) name(string) n(string) kernel(passthru)   ///
		bwidth(string) ]

	local defn = ("`n'"=="")

	tempvar zt1 zt2 zc1 zc2 dt1 dt2 dc1 dc2 gt gc raw match
	tempvar tut1 tuc1 tut2 tuc2
	if "`wt'" != "" {
		local wght [fw=`wt']
	}
	/* line options in the same order as e(tlevels)			*/
	local tlev `e(tlevels)'
	local t = e(treated)
	local c = e(control)
	local kt : list posof "`t'" in tlev
	local kc : list posof "`c'" in tlev
	gen byte `raw' = 1
	gen byte `match' = 2

	local iff if _n<=`n0' & !missing(`xt')
	if `defn' {
		qui count `iff'
		local Nt1 = r(N)
	}
	else {
		local Nt1 = `n'
	}
	/* suppress any notes from kdensity				*/
	qui kdensity `xt' `wght' `iff', nograph gen(`zt1' `dt1') n(`Nt1') ///
		`kernel'
	if "`bwidth'" != "" {
		local bw = r(bwidth)*`bwidth'
		qui drop `zt1' `dt1'
		qui kdensity `xt' `wght' `iff', nograph gen(`zt1' `dt1') ///
			n(`Nt1') `kernel' bwidth(`bw')
	}
	gen byte `tut1' = cond(_n<=`Nt1',1,0)
	local Nt_raw = r(n)
	local bwt_raw = r(bwidth)

	local iff if _n<=`n0' & !missing(`xc')
	if `defn' {
		qui count `iff'
		local Nc1 = r(N)
	}
	else {
		local Nc1 = `n'
	}
	qui kdensity `xc' `wght' `iff', nograph gen(`zc1' `dc1') n(`Nc1') ///
		`kernel'
	if "`bwidth'" != "" {
		local bw = r(bwidth)*`bwidth'
		qui drop `zc1' `dc1'
		qui kdensity `xc' `wght' `iff', nograph gen(`zc1' `dc1') ///
			n(`Nc1') `kernel' bwidth(`bw')
	}
	gen byte `tuc1' = cond(_n<=`Nc1',1,0)
	local Nc_raw = r(n)
	local bwc_raw = r(bwidth)

	if "`e(stat)'" == "atet" {
		local iff if _n>`n0' & !missing(`xt')
		if `defn' {
			qui count `iff'
			local Nt2 = r(N)
		}
		else {
			local Nt2 = `n'
		}
	}
	else if `defn' {
		local iff
		qui count if !missing(`xt')
		local Nt2 = r(N)
	}
	else {
		local Nt2 = `n'
	}
	qui kdensity `xt' `wght' `iff', nograph gen(`zt2' `dt2') n(`Nt2') ///
		`kernel'
	if "`bwidth'" != "" {
		local bw = r(bwidth)*`bwidth'
		qui drop `zt2' `dt2'
		qui kdensity `xt' `wght' `iff', nograph gen(`zt2' `dt2') ///
			n(`Nt2') `kernel' bwidth(`bw')
	}
	gen byte `tut2' = cond(_n<=`Nt2',1,0)
	local Nt_matched = r(n)
	local bwt_matched = r(bwidth)

	if "`e(stat)'" == "atet" {
		local iff if _n>`n0' & !missing(`xc')
		if `defn' {
			qui count `iff'
			local Nc2 = r(N)
		}
		else {
			local Nc2 = `n'
		}
	}
	else if `defn' {
		local iff
		qui count if !missing(`xc')
		local Nc2 = r(N)
	}
	else {
		local Nc2 = `n'
	}
	qui kdensity `xc' `wght' `iff', nograph gen(`zc2' `dc2') n(`Nc2') ///
		`kernel'
	if "`bwidth'" != "" {
		local bw = r(bwidth)*`bwidth'
		qui drop `zc2' `dc2'
		qui kdensity `xc' `wght' `iff', nograph gen(`zc2' `dc2') ///
			n(`Nc2') `kernel' bwidth(`bw')
	}
	gen byte `tuc2' = cond(_n<=`Nc2',1,0)
	local Nc_matched = r(n)
	local bwc_matched = r(bwidth)
	local kernel = r(kernel)

	gen byte `gt' = e(treated)
	gen byte `gc' = e(control)

	local stack `tut1' `gt' `raw' `zt1' `dt1' 
	local stack `"`stack' `tuc1' `gc' `raw' `zc1' `dc1'"'
	local stack `"`stack' `tut2' `gt' `match' `zt2' `dt2'"'
	local stack `"`stack' `tuc2' `gc' `match' `zc2' `dc2'"'

	tempvar g rw z d tu
	tempname lrw

	ParseLegend, `sgopts'
	local sgopts `"`s(sgopts)'"'
	local blegend = `s(blegend)'
	local byopts `"`byopts' `s(byopts)'"'

	local tlab : variable label `xt'
	if "`tlab'" == "" {
		local tlab treated
	}
	local clab : variable label `xc'
	if "`clab'" == "" {
		local clab control
	}

	if `kt' == 1 {
		local lines `"(line `d' `z' if `g'==`t',`line1')"'
		local lines `"`lines' (line `d' `z' if `g'==`c',`line2')"'
		if `blegend' {
			local legend `"label(1 `tlab') label(2 `clab')"'
			local sgopts `"`sgopts' legend(`legend')"'
		}
	}
	else {
		local lines `"(line `d' `z' if `g'==`c',`line1')"'
		local lines `"`lines' (line `d' `z' if `g'==`t',`line2')"'
		if `blegend' {
			local legend `"label(1 `clab') label(2 `tlab')"'
			local sgopts `"`sgopts' legend(`legend')"'
		}
	}

	stack `stack', into(`tu' `g' `rw' `z' `d') clear
	qui drop if missing(`d')
	label variable `d' Density
	label variable `rw' "raw and matched data"
	label define `lrw' 1 Raw 2 Matched
	label values `rw' `lrw'
	label variable `z' "`label'"

	twoway `lines', by(`rw',`byopts') `sgopts' 

	return scalar Nt_raw = `Nt_raw'
	return scalar bwt_raw = `bwt_raw'
	return scalar Nc_raw = `Nc_raw'
	return scalar bwc_raw = `bwc_raw'
	return scalar Nt_adj = `Nt_matched'
	return scalar bwt_adj = `bwt_matched'
	return scalar Nc_adj = `Nc_matched'
	return scalar bwc_adj = `bwc_matched'

	return local kernel `kernel'
end

program define ParseGraphOpts, sclass

	_on_colon_parse `0'
	local varname `s(before)'
	local 0 ,`s(after)'

	/* allow multiple byopts() options				*/
	while (1) {
		syntax, [ BYopts(string asis) * ]
		local 0, `options'
		if `"`byopts'"' == "" {
			continue, break
		}
		local byopts0 `"`byopts0' `byopts'"'
	}
	local byopts `"`byopts0'"'

	local gtwow gettwoway
	local klev = e(k_levels)
	forvalues i=1/`klev' {
		local allow `allow' line`i'opts
	}

	_get_gropts, graphopts(`options') gettwoway getallowed(`allow')
	local gropts `"`s(graphopts)'"'
	local twopts `"`s(twowayopts)'"'
	local name `s(name)'
	forvalues i=1/`klev' {
		local line`i' `s(line`i'opts)'
	}
	if "`s(varlist)'" != "" {
		di as err "{p}option {it:varlist}{bf:)} is not allowed{p_end}"
		exit 198
	}
	if `"`twopts'"' != "" {
		local 0, `twopts'
		syntax, [ name(string) * ]
		local gropts `"`gropts' `options'"'
		local twoopts
	}
	if `"`byopts'"' != "" {
		local 0, `byopts'
		syntax, [ TItle(passthru) note(passthru) * ]
		local byopts `"`options'"'
	}
	if `"`title'"' == "" {
		if "`varname'" == "" {	
			local varname "propensity scores"
		}
		local title title(Balance plot)
	}
	if `"`note'"' == "" {
		local note `"note(" ")"'
	}
	local byopts `"`byopts' `title' `note'"'

	sreturn clear

	if "`name'" != "" {
		local 0 `name'
		syntax anything(name=name), [ replace ]
	}

	qui graph dir, memory	// named graphs in memory (no spaces in name)
	local gnames `r(list)'
	local k : list posof "`name'" in gnames
	if `k' {
		if "`replace'" == "" {
			di as err "graph `name`i'' already exists"
			exit 110
		}
		qui graph drop `name'
	}
	local sgopts `"name(`name',`replace') `gropts' `scheme'"'
	sreturn local sgopts `"`sgopts'"'
	sreturn local name `name'
	sreturn local byopts `"`byopts'"'
	forvalues i=1/`klev' {
		sreturn local line`i' `"`line`i''"'
	}
end

program define ParseLegend, sclass
	syntax, [ legend(string asis) * ]

	local blegend = (`"`legend'"'=="")
	local sgopts `"`options'"'
	if !`blegend' {
		local 0, `legend'
		syntax, [ off * ]
		if "`off'" != "" {
			/* put legend(off) into byopts so it works	*/
			local byopts `"`byopts' legend(off)"'
		}
		else {
			local opts `"`options'"'
			local 0, `options'
			syntax, [ label(string) * ]
			local blegend = ("`label'"=="")
			if !`blegend' {
				local options `"`opts'"'
			}
			local sgopts `"`sgopts' legend(`options')"'
		}
	}
	sreturn local sgopts `"`sgopts'"'
	sreturn local byopts `"`byopts'"'
	sreturn local blegend `blegend'	// flag to build a legend
end

program define StackVar, rclass
	syntax, xt(string) xc(string) [ var(string) wt(string) ]

	tempvar x xt0 xc0 xt1 xc1 z wz tu
	tempname mi wi

	qui gen byte `tu' = e(sample)

	local expand = 0
	local wgts = 0
	if "`e(wtype)'" == "fweight" {
		local wgts = 1
		tempvar w
		qui gen long `w'`e(wexp)' if `tu'
	}
	local tvar `e(tvar)'
	local treated = e(treated)
	local control = e(control)
	/* ivars are variables containing matching indices		*/
	local ivars `e(indexvar)'

	/* stacked variables						*/
	if "`var'" == "" {
		if "`e(subcmd)'" != "psmatch" {
			/* programmer error				*/
			di as err "variable required"
			exit 100
		}
		predict double `x', ps tlevel(`treated')
	}
	else {
		fvrevar `var' if `tu'
		local x `r(varlist)'
	}
	local svars `"`xt0' `xc0' `w' `xt1' `xc1' `w'"'
	local att = ("`e(stat)'"=="atet")
	local knn = e(k_nnmax) //e(k_nneighbor)
	/* before matching plots					*/
	qui gen double `xt0' = `x' if `tvar'==`treated' & `tu'
	qui gen double `xc0' = `x' if `tvar'==`control' & `tu'
	if `att' {
		qui gen double `xt1' = `x' if `tvar'==`treated' & `tu'
	}
	else {
		qui gen double `xt1' = .
	}
	qui gen double `xc1' = .
	qui gen double `z' = .
	qui gen double `wz' = .

	local N = _N
	forvalues i=1/`N' {
		if (!`tu'[`i']) {
			continue
		}
		if `att' & `tvar'[`i']==`control' {
			continue
		}
		local kn = 0
		forvalues k=1/`knn' {
			local iv : word `k' of `ivars'
			local i1 = `iv'[`i']
			if missing(`i1') {
				continue, break
			}
			local `++kn'
			qui replace `z' = `x'[`i1'] in `k'

			if (`wgts') scalar `wi' = `w'[`i1'] in `k'
			else scalar `wi' = 1.0

			qui replace `wz' = `wi' in `k'
		}
		summarize `z' [iw=`wz'] if _n<=`kn', meanonly
		if `tvar'[`i'] == `control' {
			qui replace `xt1' = r(mean) in `i'
		}
		else {
			qui replace `xc1' = r(mean) in `i'
		}
	}
	qui keep if `tu'
	local N = _N
	qui stack `svars', into(`xt' `xc' `wt') clear
	if `expand' {
		qui expand `wt'
		qui drop `wt'
	}
	label variable `xt' "treated"
	label variable `xc' "controls"
	/* first N observations are the unmatched distribution		*/
	return local N = `N'
end

exit
