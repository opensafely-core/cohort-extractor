*! version 1.0.2  13oct2015
program u_mi_impute_cmd_pmm_parse
	local caller = _caller()
	version 12
	// preliminary syntax check
	syntax [anything(everything equalok)] [aw fw pw iw],	///
			impobj(string)			/// //internal
		[					/// 
			NOCONStant			///
			KNN(string)			///
			PMTOLerance(string)		/// //undoc.
			*				/// //common univ. opts
		]
	// knn()
	if ("`knn'"!="") {
		if (`"`pmtolerance'"'!="") {
			di as err "only one of {bf:knn()} or "	///
				  "{bf:pmtolerance()} is allowed"
			exit 198
		}
		cap confirm integer number `knn'
		if (_rc) {
			di as err "{bf:knn()} must be a positive integer"
			exit 198
		}
		if (`knn'<=0) {
			di as err "{bf:knn()} must be a positive integer"
			exit 198
		}
	}
	else {
		if (`caller'>=14 & `"`pmtolerance'"'=="") {
			di as err "option {bf:knn()} must be specified"
			exit 198
		}
		local knn 1
	}
	// pmtolerance()
	if (`"`pmtolerance'"'!="") {
		cap confirm number `pmtolerance'
		if (_rc) {
			di as err ///
			   "{bf:pmtolerance()} must be a number between 0 and 1"
			exit 198
		}
		if (`pmtolerance'<0 | `pmtolerance'>=1) {
			di as err ///
			   "{bf:pmtolerance()} must be a number between 0 and 1"
			exit 198
		}
	}
	else {
		local pmtolerance 0
	}
	mata:	`impobj'.knn	= `knn'; ///
		`impobj'.pmtol	= `pmtolerance'
	if ("`weight'"!="") { // accommodates default weights
		local wgtexp [`weight' `exp']
	}
	u_mi_impute_cmd__uvmethod_parse `anything' `wgtexp', 		    ///
		impobj(`impobj') method(pmm) cmd(_regress) cmdname(regress) ///
		cmdopts(`noconstant') `noconstant' `options'
end
