*! version 1.0.1  13oct2015
program u_mi_impute_cmd_poisson_parse, sclass
	version 12
	// preliminary syntax check
	syntax [anything(everything equalok)] [fw pw iw],	///
			impobj(string)				/// //internal
		[						/// 
			NOCONStant				///
			Exposure(passthru)			///
			OFFset(passthru)			///
			NOCMDLEGend				/// //undoc.
			*					///
		]
	u_mi_get_maxopts maxopts uvopts : `"`options'"'
	local cmdopts `noconstant' `offset' `exposure' `maxopts'
	local uvopts `uvopts' `nocmdlegend'
	if ("`weight'"!="") { // accommodates default weights
		local wgtexp [`weight' `exp']
	}
	u_mi_impute_cmd__uvmethod_parse `anything' `wgtexp', 		///
		impobj(`impobj') method(poisson) cmdopts(`cmdopts')	///
		`uvopts' cmdname(poisson) cmd(`cmd') `noconstant'
end
