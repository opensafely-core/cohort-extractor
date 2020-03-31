*! version 1.3.3  03jan2018
program _svy_check_cmdopts, sclass
	// Common options that -svy- can take over; they are most likely
	// ignored anyway.
	version 9
	syntax name(name=cmdname) [, vce(string) * ]

	if "`vce'" != "" {
		_svy_check_vce `vce'
		local vcetype `"`s(vce)'"'
	}

	local rc 0
	local svycheck `cmdname'_svy_check
	capture which `svycheck'
	if c(rc) {
		capture program list `svycheck'
		local rc = c(rc)
	}
	if `rc' == 0 {
		`svycheck', vce(`vce') `options'
	}

	local is_st = inlist("`cmdname'", "stcox", "streg")
	local mecmds	meglm		///
			melogit		///
			meprobit	///
			mecloglog	///
			meologit	///
			meoprobit	///
			mepoisson	///
			menbreg

	// the following options, when specified, will result in an error msg
	tempname obj
	.`obj' = ._optlist.new
	local chkbad BadOpt `obj' `cmdname'

	// Note: -vce()- is handled by -svy- directly.

	`chkbad' CLuster	passthru	: `cmdname'
	`chkbad' Robust				: `cmdname'

	`chkbad' FWeights	passthru	: gsem
	`chkbad' IWeights	passthru	: gsem
	`chkbad' PWeights	passthru	: gsem

	`chkbad' FWeight	passthru	: `mecmds'
	`chkbad' IWeight	passthru	: `mecmds'
	`chkbad' PWeight	passthru	: `mecmds'

	`chkbad' AT		passthru	: truncreg
	`chkbad' DEPname	passthru	: ivreg regress
	`chkbad' DISP		passthru	: glm
	`chkbad' FISHER		passthru	: glm
	`chkbad' FRailty	passthru	: stcox
	`chkbad' HAzard		passthru	: etreg treatreg
	`chkbad' SCAle		passthru	: glm
	`chkbad' SHared		passthru	: stcox streg
	`chkbad' T		passthru	: glm
	`chkbad' TVC		passthru	: stcox
	`chkbad' VFactor	passthru	: glm

	`chkbad' mdata		passthru	: sem
	`chkbad' NOMEANs			: sem

	`chkbad' MGale		passthru	: stcox
	`chkbad' SCAledsch	passthru	: stcox
	`chkbad' SCHoenfeld	passthru	: stcox

	if inlist("`vcetype'", "brr", "jackknife") {
		`chkbad' BASEChazard	passthru	: stcox
		`chkbad' BASEHC		passthru	: stcox
		`chkbad' BASESurv	passthru	: stcox
		`chkbad' EFFects	passthru	: stcox
		`chkbad' ESR		passthru	: stcox
	}

	`chkbad' Beta		: ivreg regress
	`chkbad' CLOgit		: nlogit
	`chkbad' EFRon		: stcox
	`chkbad' ESTImate	: stcox
	`chkbad' EXACTM		: stcox
	`chkbad' EXACTP		: stcox
	`chkbad' FIRst		: heckman heckprob heckprobit etreg treatreg
	`chkbad' FIRST		: ivprobit ivtobit
	`chkbad' Hascons	: ivreg regress
	`chkbad' hc2		: ivreg nl regress
	`chkbad' hc3		: ivreg nl regress
	`chkbad' IRLS		: glm
	`chkbad' LEAve		: nl
	`chkbad' Marginal	: truncreg
	`chkbad' MSE1		: cnsreg ivreg regress
	`chkbad' NOADJust	: stcox
	`chkbad' NOCOEF		: logit probit
	`chkbad' NODISPLAY	: glm
	`chkbad' NOHEADer	: glm streg
	`chkbad' NOHEader	: ivreg regress
	`chkbad' NOLABel	: nlogit
	`chkbad' NONEST		: clogit
	`chkbad' NOSKIP	: biprobit heckman heckprob heckprobit hetprob hetprobit
	`chkbad' NOSKIP		: etreg treatreg truncreg
	`chkbad' LRMODEL	: biprobit etregress heckman heckprob heckprobit
	`chkbad' LRMODEL        : hetprob hetprobit truncreg 
	`chkbad' NOTABLE	: glm
	`chkbad' NOTRee		: nlogit
	`chkbad' PLUS		: ivreg regress
	`chkbad' tsscons	: ivreg regress
	`chkbad' TWOstep : heckman ivprobit ivtobit etreg treatreg hetregress
	`chkbad' VUONG		: zinb zip
	`chkbad' ZIP		: zinb

	local badopts `"`.`obj'.dumpoptions'"'
	local badnames `"`.`obj'.dumpnames'"'

	// options with side-effects that -svy- needs to be aware of
	if "`cmdname'" == "ivreg" {
		local first FIRST
	}
	if "`cmdname'" == "logistic" {
		// this option is handled by -svy- directly, but may be passed
		// here anyway; only to be ignored
		local coef COEF
	}
	if "`cmdname'" == "stcox" & inlist("`vcetype'", "", "linearized") {
		local esr ESR(string)
	}
	if "`cmdname'" == "clogit" {
		local group GRoup(varname) STrata(varname)
	}
	if "`cmdname'" == "sem" {
		local method method(string)
	}
	if "`cmdname'" != "streg" {
		local trace TRace
	}
	if "`cmdname'" == "proportion" {
		local percent percent
	}

	syntax name(name=cmdname) [,	///
		VCE(passthru)		/// already => `vcetype'
		TECHnique(passthru)	///
		crittype(passthru)	///
		SCore(passthru)		///
		Log NOLog `trace'	///
		`coef'			///
		`badopts'		///
		`first'			///
		`esr'			///
		`group'			///
		`method'		///
		`percent'		///
		*			///
	]
	if "`log'`trace'" != "" {
		local options `"`log' `nolog' `trace' `options'"'
	}

	if "`cmdname'" == "stcox" & "`tvc'" != "" {
		_tvc_notallowed svy svy
	}

	foreach name of local badnames {
		if `"``name''"' != "" {
			_prefix_nonoption with the svy prefix, ``name''
		}
	}

	if "`cmdname'" == "sem" {
		sem_parse_method, `method'
		local method "`s(method)'"
		if !inlist("`method'", "ml", "mlmv") {
			di as err ///
`"option method(`method') not allowed with the svy prefix"'
			exit 198
		}
	}

	// check that the data is -svyset-
	_svy_newrule

	local pseudo	intreg		/// -ml- cmds
			gnbreg		///
			gsem		///
			`mecmds'	///
			heckman		///
			heckprob	///
			poisson		///
			nbreg		///
			zinb		///
			zip		///
			ztnb		///
			ztp		///
			cnreg		/// built-in cmds
			logit		///
			mlogit		///
			ologit		///
			oprobit		///
			probit		///
			sem		///
			tobit		///
			// blank
	if `"`crittype'"' == "" & `: list cmdname in pseudo' {
		local crittype crittype("log pseudolikelihood")
	}

	local cmdopts2 `score'	// start fresh
	local cmdopts2 `cmdopts2' `crittype'
	if "`technique'" != "" {
		local cmdopts2 `technique'
		CheckTechnique vce_oim, `technique'
		if "`vce_oim'" != "" {
			local cmdopts2 `cmdopts2' `vce_oim'
		}
	}
	if inlist("`cmdname'", "cnsreg", "ivreg", "nl", "regress") {
		local cmdopts2 `cmdopts2' mse1
	}

	sreturn clear
	if "`cmdname'" == "stcox" & "`esr'" != "" {
		local cmdopts2 `"`cmdopts2' esr(`esr')"'
		sreturn local esr `"`esr'"'
	}
	if "`cmdname'" == "clogit" {
		if `:length local group' {
			local cmdopts2 `"`cmdopts2' group(`group')"'
		}
		if `:length local strata' {
			local cmdopts2 `"`cmdopts2' strata(`strata')"'
			// NOTE: let -clogit- complain if both -group()- and
			// -strata()- were specified
			local group `group' `strata'
			local groptname groupoptname(strata)
		}
		if `:list sizeof group' == 1 {
			sreturn local check_group group(`group') `groptname'
			sreturn local group `group'
		}
	}
	if "`cmdname'" == "sem" {
		if `:length local method'{
			local options `"`options' method(`method')"'
		}
	}
	sreturn local cmdopts1	`", `options'"'
	sreturn local cmdopts2	`"`cmdopts2'"'
	sreturn local log	`log' `trace'
	sreturn local diopts	`percent'

	// special options
	if "`cmdname'" == "ivreg" & "`first'" != "" {
		sreturn local first first
	}
end

program CheckTechnique
	syntax name [, TECHnique(string)]
	local tech : list retok technique
	local bhhh bhhh
	if `:list bhhh == tech' {
		c_local `namelist' vce(oim)
	}
end

program BadOpt
	_on_colon_parse `0'
	tokenize `s(before)'
	args obj cmdname option passthru
	local cmdlist `s(after)'
	if `: list cmdname in cmdlist' {
		.`obj'.addopt `option', `passthru'
	}
end
exit
