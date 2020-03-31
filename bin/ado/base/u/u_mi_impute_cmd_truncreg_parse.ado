*! version 1.0.2  13oct2015
program u_mi_impute_cmd_truncreg_parse, sclass
	version 12
	// preliminary syntax check
	syntax [anything(everything equalok)] [aw fw pw iw],	///
			impobj(string)				/// //internal
		[						/// 
			NOCONStant				///
			ll(string)				///
			ul(string)				///
			OFFset(passthru)			///
			NOCMDLEGend				/// //undoc.
			NOSKIP					/// //undoc.
			*					///
		]
	u_mi_get_maxopts maxopts uvopts : `"`options'"'
	// use noskip to get e(ll_0)
	local cmdopts `noconstant' ll(`ll') ul(`ul') `offset' `maxopts' `noskip'
	local uvopts `uvopts' `nocmdlegend'
	if ("`weight'"!="") { // accommodates default weights
		local wgtexp [`weight' `exp']
	}
	if ("`ll'"=="") {
		local ll -inf
	}
	else {
		cap confirm numeric variable `ll'
		if _rc {
			cap confirm number `ll'
			if _rc {
				di as err "{bf:ll()} must be a number or a numeric variable"
				exit 198
			}
		}
		else {
			unab ll : `ll'
		}
	}
	if ("`ul'"=="") {
		local ul +inf
	}
	else {
		cap confirm numeric variable `ul'
		if _rc {
			cap confirm number `ul'
			if _rc {
				di as err "{bf:ul()} must be a number or a numeric variable"
				exit 198
			}
		}
		else {
			unab ul : `ul'
		}
	}
	mata: `impobj'.stll = "`ll'"; `impobj'.stul = "`ul'"
	u_mi_impute_cmd__uvmethod_parse `anything' `wgtexp', 		///
		impobj(`impobj') method(truncreg) cmdopts(`cmdopts')	///
		`uvopts' cmdname(truncreg) cmd(`cmd') `noconstant'
end
