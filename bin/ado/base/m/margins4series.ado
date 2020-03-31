*! version 1.0.0  09may2019
program margins4series, eclass
	version 16
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
		if (`"`e(cmd_loco)'"' == "") {
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
	
	// parsing predict 	
	_parse_predict `ZERO'
	
	// stripe for contrast 
	
	local cualquiercosa "(`anything'), atequations"

	// citype option 
	
	_ci_type, `citype'
	local cmat `"`s(cmat)'"'
	local ctit `"`s(ctit)'"'
	
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
		else if ("`vcetype'" != "bootstrap" & ///
			 "`vcetype'" != "unconditional" &	///
			 "`vcetype'" != "delta"){
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
			
		tempname tousetwo
		quietly generate byte `tousetwo' = `touse' `if' `in'
		local nudos = e(knots)

		local REFIT `anything' if `tousetwo'		///
				[`weight'`exp'],		///
				`options' knots(`nudos')		

		bootstrap,	altcmdname(margins)	///
				noclear			///
				noheader		///
				nolegend		///
				notable			///
				nowarn			///
				`VCEOPTS' :		///
		margins4series `ARGS' , refit(`REFIT') post `OPTS'	///
			predict(`predict') nose
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

program Margins

	tempname m t
	.`m' = ._marg_series.new `t'

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
	marksample touse 
	if `:length local refit' {
		npregress `refit'
	}
	if `:length local weight' {
		local wgt [`weight'`exp']
	}
	Margins `anything' if `touse' , `options' 
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

program define _parse_predict
        syntax [anything] [if] [in], [predict(string) *]

	if ("`predict'"!="") {
		local 0 ",`predict'"
		capture syntax [anything], [	///
			Mean			///
			tolerance(string)	///
			atsample ]
		local rc = _rc
		if (`rc') {
			display as error "invalid {bf:predict} option for" ///
			" {bf:npregress series} using {bf:margins}"
			exit `rc'
		}
	}
end

exit
