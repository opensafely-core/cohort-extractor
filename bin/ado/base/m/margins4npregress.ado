*! version 1.0.7  06may2019
program margins4npregress, eclass
	version 15
	local prefix = c(prefix)
	local bootstrap bootstrap
	local loop _loop_bs
	if !`:list loop in prefix' {
		if replay() {
			if inlist("margins", "`e(cmd)'", "`e(cmd2)'") {
				_marg_report `0'
				exit
			}
		}
		if `"`e(cmd)'"' != "npregress" {
			error 301
		}
	}
	local ZERO : copy local 0
	syntax [anything] [if] [in] [fw iw pw]	///
		[,	vce(string)		///
			vce1(passthru)		///
			post			///
			refit(string asis)	///
			Reps(string)		///
			seed(string)		///
			citype(string)		///
			predict(string)		///
			*			///
		]


	if ("`reps'"!="" | "`seed'"!="") {
		_parse_reps `ZERO'
		local vce `"`s(newvce)'"'
	}
	
	// Invalid predict 
	
	if ("`predict'"!="mean" & "`predict'"!="") {
		 display as error ///
		"incorrect {bf:margins} specification after" ///
		" {bf:npregress kernel}"
		di as err "{p 4 4 2}" 
		di as smcl as err "{bf:predict()} is only allowed with the"	
		di as smcl as err "argument {bf:mean}. All {bf:margins} "
		di as smcl as err "computations are"		
		di as smcl as err " based on the estimated mean function." 
		di as smcl as err "{p_end}"
		exit 198
	}
	
	// stripe for contrast 
	
	local cualquiercosa "(`anything'), atequations"

	// citype option 
	_ci_type, `citype'
	local cmat `"`s(cmat)'"'
	local ctit `"`s(ctit)'"'
	
	// For pwcompare 
	
	_parse_pwcompare `ZERO'
	local pwc `"`s(pwc)'"'
	local contwc `"`s(contwc)'"'
	local pwst `"`s(pwstring)'"'

	if ("`contwc'"=="tiene") {
		ereturn hidden local contwc_np "tiene" 
	}
	
	if `"`vce'"' != "" {
		gettoken vcetype vceargs : vce, parse(" ,")
		GetVcetype vcetype, `vcetype'
		if "`vcetype'" == "none" {
			if `"`vceargs'"' != "" {
				di as err "invalid vce() option;" _n	///
		"vcetype {bf:none} does not allow arguments or options"
				exit 198
			}
		}
		else if "`vcetype'" != "bootstrap" {
			di as err "vcetype '`vcetype'' not allowed"
			exit 198
		}
	}
	if (`"`vce'"'=="" & "`citype'"!="") {
		di as error "{bf:citype()} must be specified with" ///
		 " {bf:vce(bootstrap)} or {bf:reps()}"
		exit 198
	}

	if `"`vcetype'"' == "bootstrap" {
		if `"`if'`in'"' != "" {
			marksample touse
		}
		else {
			tempname touse
			quietly gen byte `touse' = e(sample)
		}
		local ARGS `anything' if `touse'
		local OPTS : copy local options
		_plot_hidden, `OPTS'
		local OPTS "`s(opciones)'"
		local tieneplot `"`s(hasplot)'"'
		local 0 : copy local vceargs
		capture syntax [, *]
		if c(rc) {
			di as err "invalid vce() option;"
			syntax [, *]
			exit 198	// [sic]
		}
		local VCEOPTS : copy local options
		if `"`weight'"' != "" {
			di as error ///
		"{bf:`weight'}s are not allowed with {bf:vce(bootstrap)}"
			exit 198
		}
		if "`post'" == "" {
			tempname ehold
			_est hold `ehold' , restore copy
		}

		_get_diopts diopts OPTS , `OPTS'

		local 0 `"`e(cmdline)'"'
		gettoken cmd 0 : 0
		syntax [anything] [if] [in] [fw pw iw]	///
			[,	vce(passthru)		/// ignored
				BWidth(string)		/// ignored
				*			///
			]
		tempname BWIDTH 
		matrix `BWIDTH' = e(bwidth)
		local raiz  = e(rngstate)
		local bwrep = e(bwrep)
		tempname tousetwo
		quietly generate byte `tousetwo' = `touse' `if' `in'
		if (`bwrep'==0) {
			local REFIT `anything' if `tousetwo'	///
				[`weight'`exp'],		///
				bwidth(`BWIDTH')		///
				`options'
		}
		else {
			local REFIT `anything' if `tousetwo'	///
				[`weight'`exp'],		///
				`options'		
		}
		bootstrap,	altcmdname(margins)	///
				noclear			///
				noheader		///
				nolegend		///
				notable			///
				nowarn			///
				`VCEOPTS' :		///
		margins4npregress `ARGS' , refit(`REFIT') post `OPTS'
		ereturn hidden local ///
		cidefault cimatrix(`cmat') cititle("`ctit'")
		ereturn local cmdline margins `ZERO'
		ereturn hidden local cualquiercosa `cualquiercosa'
		local contrastopts "`e(contrastoptsnp)'"

		if ("`pwc'"=="") {
			_parse_contrast_opts, `contrastopts' ///
					       contraste(`contrastopts')
			if ("`contwc'"!="") {
				local contraste "`s(micontraste)'"
			}
			_marg_report, `diopts' `contraste'
		}
		else {
			pwcompare `pwst' `diopts'
		}
		if "`post'" == "" {
			_e2r, add
		}
		if ("`tieneplot'"=="tiene") {
			marginsplot 
		}
		exit
	}

	local Estimate Margins

	if `:list bootstrap in prefix' {
		if `:list loop in prefix' {
			if `:length local refit' {
				local Estimate RefitThenMargins
			}
		}
	}

	`Estimate' `ZERO'
end

program GetVcetype
	syntax name(name=cmacro) [, BOOTstrap BStrap NONE *]
	if "`bstrap'" != "" {
		local bootstrap bootstrap
	}
	c_local `cmacro' `bootstrap' `options'
end

program RefitThenMargins
	syntax [anything] [if] [in] [fw pw iw]	///
		[,	refit(string asis)	///
			*			///
		]
	if `:length local refit' {
		npregress `refit'
	}
	if `:length local weight' {
		local wgt [`weight'`exp']
	}
	Margins `anything' `if' `in' `wgt' , `options' 
end

program Margins

	tempname m t
	.`m' = ._marg_npreg.new `t'

nobreak {

	if `"`e(margins_prolog)'"' != "" {
		`e(margins_prolog)'
	}

capture noisily break {

	.`m'.parse `0'
	.`m'.estimate_and_report

} // capture noisily break
	local rc = c(rc)

	if `"`e(margins_epilog)'"' != "" {
		`e(margins_epilog)'
	} 

} // nobreak
	exit `rc'
end

program define _parse_reps, sclass
	syntax [anything][if][in][fw pw iw], [Reps(string) seed(string) ///
					vce(string)	*]
	if (`"`reps'"'!="" & `"`vce'"'!="") {
		display as error "If you specify" ///
		" {bf:reps()} you may not specify another {bf:vce()}"
		exit 198
	}
	if (`"`reps'"'=="" & "`seed'"!="") {
		display as error ///
			"option {bf:seed()} must be specified with option" ///
			" {bf:reps()}"
		exit 198		
	}
	if (`"`reps'"'!="") {
		local reps = real("`reps'")
		if (`reps'==. ) {
			display as error ///
				"option {bf:reps()} incorrectly specified"
			exit 198
		}
		if (`reps'>1 & "`seed'"=="") {
			local vce `"bootstrap, reps(`reps')"' 
		}
		if (`reps'>1 & "`seed'"!="") {
			local vce `"bootstrap, reps(`reps') seed(`seed')"' 
		}
		if (`reps'<2) {
			display as error ///
				"option {bf:reps()} incorrectly specified"
			exit 198
		}
		local vce `"`vce'"'
	}
	local newvce `"`vce'"'	
	sreturn local newvce `"`newvce'"'
end 

program define _parse_pwcompare, sclass
	syntax [anything][if][in][fw pw iw], [ pwcompare CONTRAST1 ///
		refit(string)	///
		post vce(string) reps(string) seed(string) at(string)	///
		dydx(string) predict(string) contrast(string) *]
		
	if ("`pwcompare'"!="") {
		local pwc tiene
	}
	if ("`contrast'"!="" | "`contrast1'"!="") {
		local contwc tiene
	}
	
	capture _strip_contrast `anything'
	local contraste = r(contrast)
	if (`contraste'==1) {
		local contwc tiene
	}
	
	sreturn local pwc `"`pwc'"'
	sreturn local contwc `"`contwc'"'
	sreturn local pwstring "`anything', `options'"

end 

program define _parse_contrast_opts, sclass
	syntax, [noWALD			///
		 NOEFFects EFFects	///
		 CIeffects		///
		 PVeffects		///
		 noATLEVELS		///
		 contraste(string)	///
		 *			///
		 ]	 
	local inter: list contraste - options
	sreturn local micontraste "`inter'"
end


program define _ci_type, sclass
	capture syntax [anything], [bc NORmal Percentile *]
	_get_diopts diopts rest, `options'
	local citype "`percentile'`normal'`bc'"
	local ctipo = inlist("`citype'", "percentile", "normal", "bc")
	if (`ctipo'==0 & "`options'"!="") {
		display as error "{bf:`options'} invalid {bf:citype()}"
		exit 198
	} 
	if ("`citype'"=="percentile" |"`citype'"=="") {
		local cmat "e(ci_percentile)"
		local ctit "Percentile"
	}
	if "`citype'"=="normal" {
		local cmat "e(ci_normal)"
		local ctit "Normal-based"
	}
	if "`citype'"=="bc" {
		local cmat "e(ci_bc)"
		local ctit "Bias-corrected"
	}
	sreturn local cmat "`cmat'"
	sreturn local ctit "`ctit'"
end

program define _plot_hidden, sclass
	syntax, [plot *]
	_get_diopts diopts rest, `options' 
	local hasplot ""
	if ("`plot'"!="") {
		local hasplot "tiene"
	}
	sreturn local opciones `"`options'"'
	sreturn local hasplot "`hasplot'"
end

exit
