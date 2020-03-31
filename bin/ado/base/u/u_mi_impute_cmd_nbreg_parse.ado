*! version 1.0.1  13oct2015
program u_mi_impute_cmd_nbreg_parse, sclass
	version 12
	// preliminary syntax check
	syntax [anything(everything equalok)] [fw pw iw],	///
			impobj(string)				/// //internal
		[						/// 
			NOCONStant				///
			Exposure(passthru)			///
			OFFset(passthru)			///
			Dispersion(passthru)			///
			NOCMDLEGend				/// //undoc.
			*					///
		]
	u_mi_get_maxopts maxopts uvopts : `"`options'"'
	local cmdopts `noconstant' `offset' `exposure' `maxopts' `dispersion'
	local uvopts `uvopts' `nocmdlegend'
	if ("`weight'"!="") { // accommodates default weights
		local wgtexp [`weight' `exp']
	}
	u_mi_impute_cmd__uvmethod_parse `anything' `wgtexp', 		///
		impobj(`impobj') method(nbreg) cmdopts(`cmdopts')	///
		`uvopts' cmdname(nbreg) cmd(`cmd') `noconstant'
end
