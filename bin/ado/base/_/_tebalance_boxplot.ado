*! version 1.0.3  24aug2017

program define _tebalance_boxplot, rclass
	version 14.0
	local match = ("`e(subcmd)'"=="nnmatch" | "`e(subcmd)'"=="psmatch")
	if !`match' {
		di as err "{p}{bf:tebalance box} is not allowed after " ///
		 "{bf:teffects `e(subcmd)'}; box plots are only allowed "   ///
		 "after the matching estimators{p_end}"
		exit 198
	}
	if "`e(subcmd)'" == "psmatch" {
		syntax [ varname(numeric fv default=none) ], [ * ]
	}
	else {
		syntax varname(numeric fv), [ * ]
	}
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
		local vopt var(`vname')
		_ms_parse_parts `varlist'
		if "`r(type)'" == "variable" {
			local lab : variable label `varlist'
		}
		if ("`lab'"!="") local lopt label(`lab')
		else local lopt label(`varlist')
	}
	else local lopt label(Propensity Score)

	ParseGraphOpts `varlist' : `options'
	local sgopts sgopts(`s(sgopts)')
	local byopts byopts(`s(byopts)')
	local name name(`s(name)')

	if "`e(wtype)'" == "fweight" {
		tempvar w

		qui gen long `w'`e(wexp)' if `tu'
		local wopt wt(`w')
	}
	if "`e(indexvar)'" == "" {
		di as txt "{p 0 6 2}note: refitting the model using the " ///
		 "{bf:generate()} option{p_end}"
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
		/* calls -keep if `tu'-					*/
		_tebalance_stackvar, `vopt' xt(`xt') xc(`xc') `wopt' tu(`tu')
		local N = r(N)

		BoxPlot, xt(`xt') xc(`xc') `wopt' n0(`N') `lopt' `sgopts' ///
			`byopts' `name'
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

program define BoxPlot
	syntax, xt(string) xc(string) n0(integer) label(string)      ///
		[ wt(string) sgopts(string asis) byopts(string asis) ///
		name(string) ]

	local 0, `sgopts'
	syntax, [ ytitle(passthru) * ]
	if "`ytitle'" == "" {
		local ytitle ytitle(`label')
	}

	if "`wt'" != "" {
		local wght [fw=`wt']
	}
	ParseLegend, `sgopts'
	local sgopts `"`s(sgopts)'"'
	/* place legend(off) into byopts so it works			*/
	local byopts `"`byopts' `s(byopts)'"'

	local tlab : variable label `xt'
	if "`tlab'" == "" {
		local tlab treated
	}
	local clab : variable label `xc'
	if "`clab'" == "" {
		local clab control
	}

	tempvar rm
	tempname lrm

	qui gen byte `rm' = 1 if _n<=`n0'
	if "`e(stat)'" == "atet" {
		qui replace `rm' = 2 if _n>`n0'

		label define `lrm' 1 Raw 2 Matched
	
		label values `rm' `lrm'
		label variable `xt' "`tlab'"
		label variable `xc' "`clab'"

		graph box `xc' `xt' `wght', `sgopts' by(`rm',`byopts') ///
			`ytitle'
	}
	else {
		tempvar st sc srm rm2

		gen byte `rm2' = 2
		if "`wt'" == "" {
			stack `rm' `xt' `xc' `rm2' `xt' `xc', ///
				into(`srm' `st' `sc') clear
		}
		else {
			tempvar swt
			stack `rm' `xt' `xc' `wt' `rm2' `xt' `xc' `wt', ///
				into(`srm' `st' `sc' `swt') clear 
			qui drop if missing(`srm')

			local wght [fw=`swt']
		}
		label define `lrm' 1 Raw 2 Matched
		label values `srm' `lrm'
		label variable `srm' "raw and matched data"
		label variable `st' "`tlab'"
		label variable `sc' "`clab'"

		graph box `sc' `st' `wght', `sgopts' by(`srm',`byopts') ///
			`ytitle'
	}
end

program define ParseGraphOpts, sclass

	_on_colon_parse `0'
	local varname `s(before)'
	local 0, `s(after)'

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
	
	local allow name

	_get_gropts, graphopts(`options') getallowed(`allow') 
	local gropts `"`s(graphopts)'"'
	local name `s(name)'
	if "`s(varlist)'" != "" {
		di as err "{p}option {bf:`plot'(}{it:varlist}{bf:)} is " ///
		 "not allowed{p_end}"
		exit 198
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

	ForbidenBoxOpts, `gropts'

	if "`name'" != "" {
		local 0 `name'
		syntax anything(name=name), [ replace ]
	}
	else {
		local 0, `gropts'
		syntax, [ replace * ]
		local gropts `"`options'"'
	}
	qui graph dir, memory	// named graphs in memory (no spaces in name)
	local gnames `r(list)'
	local k : list posof "`name'" in gnames
	if `k' {
		if "`replace'" == "" {
			di as err "graph `name' already exists"
			exit 110
		}
		qui graph drop `name'
	}
	local sgopts `"name(`name',`replace') `stitle' `gropts' `scheme'"'
	sreturn local sgopts `"`sgopts'"'
	sreturn local name `name'
	sreturn local byopts `byopts'
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
			local sgopts `"`sgopts' legend(`options')"'
			local blegend = 1
		}
	}
	sreturn local sgopts `"`sgopts'"'
	sreturn local byopts `"`byopts'"'
	sreturn local blegend `blegend'	// flag to build a legend
end

program define ForbidenBoxOpts
	/* yvar_options							*/
	syntax , [ ASCategory ASYvars cw * ]
	local yvaropts  `ascategory' `asyvars' `cw'
	local k : word count `yvaropts'
	if `k' {
		local opt = plural(`k',"option")
		di as err "{p}{bf:graph box} `opt' {bf:`yvaropts'} not " ///
		 "allowed{p_end}"
		exit 198
	}

	/* group_options						*/
	local 0, `options'
	syntax , [ nofill MISSing ALLCategories * ]

	local grpopts `fill' `missing' `allcategories'
	local k : word count `grpopts'
	if `k' {
		local opt = plural(`k',"option")
		di as err "{p}{bf:graph box} `opt' {bf:`grpopts'} not " ///
		 "allowed{p_end}"
		exit 198
	}

	/* over_options							*/
	local 0, `options'
	syntax , [ over(passthru) * ]

	if `"`over'"' != "" {
		di as err "{p}{bf:graph box} option {bf:`over'} not " ///
		 "allowed{p_end}"
		exit 198
	}
end

exit

