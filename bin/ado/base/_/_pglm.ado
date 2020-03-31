*! version 1.0.14  10feb2020
/*
	Penalized generalized linear regression
*/
program _pglm
	version 16.0
	tempname OBJ
	cap noi EstimateObj `OBJ' : `0'
	local rc = _rc
 	nobreak {
		_pglm_clean_obj `OBJ' `rc' 	//  clean up object
	}
	if (`rc' != 0) exit `rc'
end
					//----------------------------//
					// EstimateObj
					//----------------------------//
program EstimateObj, eclass sortpreserve
	_pglm_parse_colon `0'		// parse OBJ
						//  syntax	
	syntax anything 		///
		[if] [in] 		///
		[fw iw]			/// fweights and aweights
		[, noCONStant		///
		grid(passthru)		/// grid setup
		LAMBDAs(passthru) 	/// lasso penalty
		TOLerance(passthru)	/// convergence tolerance for coeff
		DTOLerance(passthru)	/// tolerance for deviance
		cdupdate(passthru)	/// lasso update method
		stop(passthru)		/// % change in deviation tolerance
		CV			/// cv optional on
		FOLDs(passthru)		/// C.V folds
		penaltywt(passthru)	/// lasso penalty weights for each coe
		ALPHAs(passthru)	/// elastic net penalty
		CROSSgrid(passthru)	/// cross grid for multiple enet
		saving(passthru)	/// saving the parameter path
		PLUGIN			/// plugin Lasso penalty (default)
		PLUGIN1(passthru)	/// plugin Lasso penalty 
		sqrt			/// square-root Lasso
		ITERate(passthru)	/// # of iteration
		nolog			/// display log
		EPSilon(passthru)	/// tolerance for absolute change in b
		RMCOLlinear		/// remove perfect collinear variables
		serule			/// standard error rule
		power(passthru)		/// power in adaptive lasso
		ALLlambdas		/// flag if run fastcv 
		OFFset(passthru)	/// offset
		EXPosure(passthru)	/// exposure
		stopok			/// default stopping rule
		strict			/// flag if strict cv
		gridminok		/// flag if select min(lambda) 
		adaptstep(passthru)	/// step index in adlasso      (NotDoc)
		noCOMPUTE		/// do not fit model (notDoc)
		PREKLPenalty(passthru)	/// previous total k_lpenalty (notDoc)
		depname(passthru)	/// depvar name (NotDoc)
		nodebug			/// do not display output (NotDoc)
		laout(passthru)		/// lasso output (NotDoc)
		nopost			/// don't post to esrf file (NotDoc)
		esrf_append		/// append esrf file (NotDoc)
		esrf_subspace(passthru) /// subspace in an esrf file (NotDoc)
		esrf_savefn		/// save e(esrf1) in the file (NotDoc)
		cmd(passthru)		/// cmd name (NotDoc)
		cmdline(passthru)	/// cmdline  (NotDoc)
		unpenalized		/// unpenalized regression (NotDoc)
		adapt			/// flag if adaptive (NotDoc)
		adapt_ridge		/// flag if adaptive with ridge (NotDoc)
		noswitch_ridge		/// flag if switch ridge algo (NotDoc)
		rngstate(passthru)	/// random state (NotDoc)
		dslog			/// inferential lasso log
		relog			/// resampling log
		noxcheck		/// not check X (NotDoc)
		xfold_idx(passthru)	/// cross-fitting fold idx (NotDoc)
		resample_idx(passthru)	/// resample idx (NotDoc)
		nodisplay		/// no output and no exit
		CVTOLerance(passthru)	/// cv tolerance for fastcv
		seldefault		/// if selection is default (NotDoc)
		]

						// touse
	marksample touse
						// weights var
	tempvar wvar
	local wgt [`weight'`exp']
						//  parse common syntax
	_pglm_common_syntax  `OBJ' 	///
		, touse(`touse')	///
		wvar(`wvar') : 		///
		`anything' `if' `in',   ///
		`constant'		///
		`lambdas'		///
		`tolerance'		///
		`dtolerance'		///
		`cvtolerance'		///
		`cdupdate'		///
		`stop'			///
		`cv'			///
		`folds'			///
		`penaltywt'		///
		`alphas'		///
		`saving'		///
		`adaptstep'		///
		`preklpenalty'		///
		`plugin'		///
		`plugin1'		///
		`sqrt'			///
		wgt(`wgt')		///
		`iterate'		///
		`depname'		///
		`log'			///
		`laout'			///
		`epsilon'		///
		`post'			///
		`esrf_append'		///
		`esrf_subspace'		///
		`esrf_savefn'		///
		`cmd'			///
		`grid'			///
		`crossgrid'		///
		`rmcollinear'		///
		`serule'		///
		`unpenalized'		///
		`power'			///
		`cmdline'		///
		`adapt'			///
		`adapt_ridge'		///
		`switch_ridge'		///
		`alllambdas'		///
		`stopok'		///
		`strict'		///
		`gridminok'		///
		`offset'		///
		`exposure'		///
		`rngstate'		///
		`dslog'			///
		`relog'			///
		`xcheck'		///
		`xfold_idx'		///
		`resample_idx'		///
		`seldefault'
	
	if (`"`compute'"'!= "nocompute") {
		mata : `OBJ'.fit_model()
		if (`"`display'"' != "nodisplay") {
			_pglm_display, `debug'
		}
	}
	else {
		mata : `OBJ'.st_lasso_penalty()
	}
end
