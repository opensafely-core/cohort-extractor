*! version 1.0.3  13oct2015
program u_mi_impute_cmd_logit_parse, sclass
	version 12
	// preliminary syntax check
	syntax [anything(equalok)] [if] [fw pw iw],		///
			impobj(string)				/// //internal
		[						/// 
			NOCONStant				///
			OFFset(passthru)			///
			AUGment					///
			BOOTstrap				///
			NOCMDLEGend				/// //undoc.
			NOFVLEGend				/// //undoc.
			AUGNOIsily				/// //undoc.
			NOPPCHECK				/// //undoc.
			ASIS					/// //undoc.
			internalcmd				/// //undoc.
			NOFVREVAR				/// //internal
			*					/// //internal
		]
	opts_exclusive "`augment' `bootstrap'"
	if ("`augment'"!="") {
		u_mi_check_augment_maximize , `options'
	}
	if ("`weight'"=="iweight" & "`augment'"!="") {
		di as err "`weight' not allowed with option {bf:augment}"
		exit 101
	}
	if ("`nocmdlegend'"!="") {
		local nofvlegend nofvlegend
	}
	opts_exclusive "`asis' `augment'"
	u_mi_get_maxopts maxopts uvopts : `"`options'"'
	local cmdopts `noconstant' `offset' `asis' `maxopts'
	local uvopts `uvopts' `nocmdlegend' `bootstrap' `internalcmd'
	mata: `impobj'.augment = ("`augment'"!="")	
	if ("`weight'"!="") { // accommodates default weights
		local wgtexp [`weight' `exp']
	}
	local cmd logit
	u_mi_impute_cmd__uvmethod_parse `anything' `if' `wgtexp', 	///
		impobj(`impobj') method(logit) cmdopts(`cmdopts')	///
		`noconstant' `uvopts' cmdname(logit) cmd(`cmd')

	sret local cmdlineinit `"`s(cmdlineinit)' "`augment'" "`nofvlegend'" "`augnoisily'" "`noppcheck'""'
	if ("`augment'`internalcmd'"!="" & "`nofvrevar'"=="") {
		// to handle factor variables during augmented regression or
		// when internal command is used
		sret local cmdlineimpute `"`s(cmdlineimpute)' "`s(xlist)'""'
	}
end
