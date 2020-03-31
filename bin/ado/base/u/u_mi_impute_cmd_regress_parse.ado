*! version 1.0.4  17may2019
program u_mi_impute_cmd_regress_parse
	version 12	
	// preliminary syntax check
	syntax [anything(everything equalok)] [aw fw pw iw],	///
			impobj(string)			/// //internal
		[					/// 
			NOCONStant			///
			BOOTstrap			///
			CONDitional(passthru)		///
			OFFset(passthru)		/// //undoc.
			*				/// //common univ. opts
		]
	if ("`weight'"!="") { // accommodates default weights
		local wgtexp [`weight' `exp']
	}
	if ("`offset'" != "") {
		if ("`bootstrap'" != "") {
			di as err ///
		    	"option {bf:bootstrap} and option {bf:offset()} " /// 
		    	"may not be specified together"
			exit 198
		}
		if ("`conditional'" != "") {
			di as err "option {bf:conditional()} " ///
				"and option {bf:offset()} may not be " ///
				"specified together"
			exit 198
		}
	}
	local options `options' `conditional' `bootstrap'
	u_mi_impute_cmd__uvmethod_parse `anything' `wgtexp',		///
		impobj(`impobj') method(regress) cmd(_regress)		///
		cmdopts(`noconstant' `offset') `noconstant' `options'
end
