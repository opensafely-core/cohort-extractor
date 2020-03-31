*! version 1.0.17  10feb2020
/*
	parse pglm common syntax 

	syntax :
		OBJ, touse() : {common_syntax}

		The parsed element in common syntax is passed to mata object
		OBJ
*/
program _pglm_common_syntax
	
	version 16.0
	
	_on_colon_parse `0'
	local before `s(before)'
	local after `s(after)'

	local 0 `before'
	syntax anything(name=OBJ),  touse(string) wvar(string)

	local 0 `after'
	syntax anything [if] [in],	///
		[noCONstant		///
		LAMBDAs(string)		///
		tolerance(passthru)	///
		dtolerance(passthru)	///
		cvtolerance(passthru)	///
		cdupdate(string)	///
		stop(passthru)		///
		CV			///
		folds(passthru)		///
		penaltywt(string)	///
		alphas(passthru) 	///
		saving(string)		///
		adaptstep(passthru)	///
		PREKLPenalty(passthru) 	///
		plugin			///
		plugin1(string)		///
		sqrt			///
		iterate(passthru)	///
		wgt(string)		///
		depname(passthru)	///
		nolog			///
		epsilon(passthru)	///
		laout(string)		///
		nopost			///
		esrf_append		///
		esrf_savefn		///
		esrf_subspace(passthru)	///
		cmd(passthru)		///
		crossgrid(string)	///
		grid(string) 		///
		rmcollinear 		///
		power(passthru)		///
		unpenalized		///
		cmdline(passthru)	///
		adapt			///
		adapt_ridge		///
		noswitch_ridge		///
		alllambdas		///
		stopok			///
		strict			///
		gridminok		///
		serule			///
		offset(passthru)	///
		exposure(passthru)	///
		rngstate(passthru)	///
		dslog			///
		relog			///
		noxcheck		///
		xfold_idx(passthru)	///
		resample_idx(passthru)	///
		seldefault		///
		]

	gettoken model anything: anything
	local rlasso `plugin' `plugin1'
						// parse model
	ParseModel `OBJ' : `wgt' , `model' rlasso(`rlasso') 	///
		`sqrt' `alphas' `unpenalized' `switch_ridge'
						// touse
	mata : `OBJ'.touse = `"`touse'"'	
						// parse depvar and indepvars
	ParseVars `OBJ' : `anything',	///
		wgt(`wgt') touse(`touse') `depname' `rmcollinear'
						// mark out missing 
	MarkOut `OBJ' 
						// parse lambdas()
	ParseLambdas `OBJ' : `lambdas'	
						// parse grid()
	ParseGrid `OBJ' : `grid'	
						// check lambdas and grid
	CheckGridLambdas , lambdas(`lambdas') grid(`grid')
						// parse constant	
	ParseConst `OBJ' : , `constant'		
						// parse ltolerance
	ParseLptol `OBJ' : , `tolerance'	
						// parse epsilon
	ParseLpEps `OBJ' : , `epsilon'	
						// parse update method
	ParseLupdate `OBJ' :, `cdupdate' `sqrt'	
						// parse fractional deviance tol
	ParseFdevtol `OBJ' :, `stop'	
						// parse cross-validation
	ParseCV `OBJ' : `wgt' , `cv' `folds' rlasso(`rlasso') 	///
		`unpenalized' `seldefault'
						// parse penalty factor
	ParsePfactor `OBJ' : `penaltywt'	
						// parse alphas
	ParseAlpha `OBJ' : , `alphas' rlasso(`rlasso') `sqrt'
						// parse saving
	ParseSaving `OBJ': `saving'		
						// parse step
	ParseAdaptStep `OBJ' : , `adaptstep'	
						// parse previous k_lpenalty
	ParsePreklp `OBJ' : , `preklpenalty'	
						// parse rigorous lasso penalty
	ParseRlpenalty `OBJ' : , `plugin' `plugin1' `sqrt' model(`model')
						//  parse weights
	ParseWeights `OBJ' : `wgt' , wvar(`wvar')  touse(`touse')
						//  parse iterate
	ParseIterate `OBJ' : , `iterate'
						//  parse strict
	ParseStrict `OBJ' : , `strict' `gridminok'
						//  parse nolog
	ParseLog `OBJ': , `log'
						// parse laout
	ParseLaout `OBJ': `laout'		
						//  parse sqrt
	ParseSqrt `OBJ': , `sqrt'
						// parse nopost
	ParsePost `OBJ': , `post'		
						// parse esrf_append
	ParseEsrfAppend `OBJ': , `esrf_append'		
						// parse esrf_subspace
	ParseEsrfSubspace `OBJ': , `esrf_subspace'		
						// parse esrf_savefn
	ParseEsrfSaveFn `OBJ': , `esrf_savefn'		
						// parse cmd 
	ParseCmd `OBJ': , `cmd'		
						// parse cmdline
	ParseCmdline `OBJ': , `cmdline'		
						// parse crossgrid
	ParseCrossGrid `OBJ' : , `crossgrid'
						// parse serule
	ParseSerule `OBJ' : , `serule'
						//  parse power
	ParsePower `OBJ' : , `power'
						//  parse unpenalized
	ParseUnpen `OBJ' : , `unpenalized'
						//  parse adapt
	ParseAdapt `OBJ' : , `adapt'
						//  parse adapt_ridge
	ParseAdaptRidge `OBJ' : , `adapt_ridge'
						//  parse alllambdas
	ParseFastcv `OBJ' : , `alllambdas' `adaptstep' `adapt'
						//  parse gridminok
	ParseGridminok `OBJ' : , `gridminok'
						// parse offset
	ParseOffset `OBJ' : , `offset' `exposure' model(`model') touse(`touse')
						// parse stopok
	ParseStopok , `stopok' `strict' `gridminok'
						// parse rngstate
	ParseRngstate `OBJ': , `rngstate'
						// dslog
	ParseDslog `OBJ':, `dslog' `relog'
						// valueconv
	ParseValueconv `OBJ':, `tolerance'  `dtolerance'
						// xcheck
	ParseXcheck `OBJ':, `xcheck'
						//  parse xfold and resample
	ParseCrossFitInfo `OBJ': , `xfold_idx' `resample_idx'

						// parse cvtol
	ParseCvtol `OBJ': , `cvtolerance'
end
					//----------------------------//
					// parse model
					//----------------------------//
program ParseModel
	_pglm_parse_colon `0'		// parse OBJ

	syntax [fw iw] 		///
		[, linear	///
		logit	 	///
		probit	 	///
		poisson  	///
		mlogit		///
		rlasso(string)	///
		sqrt		///
		cox		///
		alphas(real 1)	///
		unpenalized	///
		noswitch_ridge  ///
		* ]
	
	if (`"`options'"' != "" & `"`sqrt'"' == "") {
		di as err "invalid {bf:model}"
		di "{p 4 4 2}"
		di as err "only one of linear, logit, "	///
			"probit, or poisson is allowed."
		di "{p_end}"
		exit 198
	}
	else if (`"`options'"' != "" & `"`sqrt'"' != "") {
		di as err "invalid {bf:model}"
		di "{p 4 4 2}"
		di as err "only linear model is allowed."
		di "{p_end}"
		exit 198
	}

	local model `linear' `logit' 	///
		`probit' `poisson' `mlogit' `cox'

	local n_model : word count `model'
	if (`n_model' >= 2 | `n_model' == 0) {
		di "{p 0 2 2}"
		di as err "only one of linear, logit, "	///
			"probit, or poisson is allowed"
		di "{p_end}"
		exit 198
	}

	if (`"`rlasso'"' != "") {
		local rlasso rlasso
	}

	if (`"`rlasso'"'!="" 			///
		& `"`model'"'!="linear"		///
		& `"`model'"'!="logit"		/// 	
		& `"`model'"'!="poisson"	///
		& `"`model'"' != "probit" ) {
		di "{p 0 2 2}"
		di as err "Only linear, logit, probit, and poisson model " ///
			"allows plug-in Lasso penalty"
		di "{p_end}"
		exit 198
	}

	if (`"`rlasso'"' != "" & `"`unpenalized'"' != "") {
		di as err "option {bf:unpenalized} cannot be specified " ///
			"with option {bf:plugin}"
		exit 198
	}

	if (`"`unpenalized'"' != "" & `alphas' == 0) {
		di as err "option {bf:unpenalized} cannot be specified " ///
			"with option {bf:alphas(0)}"
		exit 198
	}

	local wtype `weight'

	if (`"`switch_ridge'"' == "noswitch_ridge") {
		local switch_ridge = 0
	}
	else {
		local switch_ridge = 1
	}

						// create object
	mata : _st_get_elastic_net(	///
		`"`model'"', 		///
		`"`OBJ'"', 		///
		`"`rlasso'"',		///
		`"`sqrt'"',		///
		`alphas',		///
		`switch_ridge')
						//  model 
	mata : `OBJ'.model = `"`model'"'
end
					//----------------------------//
					// parse depvar indepvars
					//----------------------------//
program ParseVars

	local ZERO `0'

	_pglm_parse_colon `0'		// parse OBJ

	mata : st_local("model", `OBJ'.model)

	if (`"`model'"' == "linear") {
		ParseVarsLinear `ZERO'
	}
	else if (`"`model'"' == "logit") {
		ParseVarsLogit `ZERO'
	}
	else if (`"`model'"' == "poisson") {
		ParseVarsPois `ZERO'
	}
	else if (`"`model'"' == "probit") {
		ParseVarsLogit `ZERO'
	}
	else if (`"`model'"' == "mlogit") {
		ParseVarsMlogit `ZERO'
	}
	else if (`"`model'"' == "cox") {
		ParseVarsCox `ZERO'
	}
end
					//----------------------------//
					// parse lasso penalty
					//----------------------------//
program ParseGrid
	_pglm_parse_colon `0'			// parse OBJ

	syntax [anything(name=gridpoints)] 	///
		[, min(passthru)		///
		max(passthru)			///
		ratio(passthru)]
						//  default case	
	local ZERO `0'
	if (`"`ZERO'"' == "") {
		mata : `OBJ'.gridpoints = 100
		mata : `OBJ'.st_lp_min = .
		mata : `OBJ'.st_lp_max = .
		mata : `OBJ'.lp_ratio = 1E-4
		mata : `OBJ'.default_ratio = 1
		exit 				
		// NotReached
	}
						// parse gridpoints
	ParseGridPoints `OBJ' : `gridpoints'
						// parse min max	
	ParseGridMinMax `OBJ': , `min' `max'
						//  parse ratio
	ParseGridRatio `OBJ': , `ratio' `min' 
end
					//----------------------------//
					// parse grid(, min() max())
					//----------------------------//
program ParseGridMinMax
	_pglm_parse_colon `0'			// parse OBJ

	syntax [, min(string)	///
		max(string) ]
	
	CheckGridBound, num(`min') num_name(min)
	local lp_min = `s(num)'

	CheckGridBound, num(`max') num_name(max)
	local lp_max = `s(num)'

	if ("`min'"!="" & "`max'"!="") {
		cap assert `min' <= `max'
		if _rc {
			di as err "minimum of lambda must be "	///
				"smaller than the maximum of lambda"
			exit 198
		}
	}

	mata : `OBJ'.st_lp_min = `lp_min'
	mata : `OBJ'.st_lp_max = `lp_max'
end
					//----------------------------//
					// check lambda min() or max()
					//----------------------------//
program CheckGridBound, sclass
	syntax [, num(string)	///
		num_name(string) ]
	
	if ("`num'"=="") {
		sret local num = .
		exit
		// NotReached
	}

	cap confirm number `num' 
	if _rc {
		di as err "option {bf:grid(, `num_name'(#))} " ///
			"must be a number"
		exit 198
	}
	cap assert `num' > 0
	if _rc {
		di as err "option {bf:grid(, `num_name'(#))} " ///
			"must be a number > 0 "
		exit 198
	}
	sret local num = `num'
end
					//----------------------------//
					// parse grid(#)
					//----------------------------//
program ParseGridPoints
	_pglm_parse_colon `0'			// parse OBJ

	syntax [anything(name=gridpoints)]

	if (`"`gridpoints'"' == "") {
		local gridpoints = 100
	}

	cap confirm integer number `gridpoints'
	local rc = _rc

	cap assert `gridpoints' > 0 
	local rc = _rc + `rc'

	if (`rc') {
		di as err "option {bf:grid(#)} must be a positive integer"
		exit 198
	}
	mata : `OBJ'.gridpoints = `gridpoints'
end
					//----------------------------//
					// parse lambdas(#)
					//----------------------------//
program ParseLambdas
	_pglm_parse_colon `0'			// parse OBJ

	syntax [anything(name=lambdas)]

	if (`"`lambdas'"'=="") {
		mata : `OBJ'.lp_mat = ""	
		exit
		// NotReached
	}


	local lp_mat `OBJ'_lp_mat

	cap confirm matrix `lambdas'
	local is_mat = !_rc

	local is_num = 0
	if (!`is_mat') {
		local 0 , lambdas(`lambdas')
		cap syntax , lambdas(numlist)
		local is_num = !_rc
	}

	if (!`is_num' & !`is_mat') {
		di as err "option {bf:lambdas()} must be either a matrix " ///
			"or numlist"
		exit 198
	}

	mata : parse_lp(`"`lambdas'"', `is_mat' , `"`lp_mat'"')
	mata : `OBJ'.lp_mat = `"`lp_mat'"'
end
					//----------------------------//
					// parse constant
					//----------------------------//
program ParseConst
	_pglm_parse_colon `0'			// parse OBJ

	syntax [, noCONstant]

	if (`"`constant'"' == "noconstant") {
		local cn = 0
		local cn_label 
	}
	else {
		local cn = 1
		local cn_label _cons
	}


	mata : `OBJ'.cn = `cn'
	mata : `OBJ'.cn_label = `"`cn_label'"'
end
					//----------------------------//
					// parse lasso tolerance
					//----------------------------//
program ParseLptol 
	_pglm_parse_colon `0'			// parse OBJ

	syntax [, tolerance(numlist max=1 >0 <1000)]

	if ("`tolerance'" == "") {
		local tolerance = 1E-7
	}

	mata : `OBJ'.lp_tol = `tolerance'
end
					//----------------------------//
					// parse lasso epsilon
					//----------------------------//
program ParseLpEps
	_pglm_parse_colon `0'			// parse OBJ

	syntax [, EPSilon(real 1E-12)]

	if (`epsilon' < 0) {
		di as err "option {bf:epsilon()} contains negative value"
		exit 198
		// NotReached
	}

	mata : `OBJ'.eps = `epsilon'
end
					//----------------------------//
					// parse lupdate
					//----------------------------//
program ParseLupdate
	_pglm_parse_colon `0'		// parse OBJ

	cap syntax [, naive 	///
		cov		///
		active		///
		strong		///
		sqrt]

	local rc = _rc

	local lupdate `naive' `cov' `active' `strong' 

	local n_up : word count `lupdate'

	if (`n_up'>1 | `rc') {
		di as err "option {bf:cdupdate()} allows only one "	///
			"of naive, cov, active, or strong"
		exit 198
		// NotReached
	}

	mata : `OBJ'.lupdate = `"`lupdate'"'
	mata : `OBJ'.custom_lupdate = `n_up'
end

					//----------------------------//
					// parse grid(, ratio(#))
					//----------------------------//
program ParseGridRatio
	_pglm_parse_colon `0'		// parse OBJ
	
	syntax [, ratio(string) min(string)]

	if (`"`ratio'"' != "" & "`min'" != "") {
		di as err "only one of {bf:ratio()} or {bf:min()} is allowed"
		exit 198
	}

	if (`"`ratio'"' == "") {
		mata : `OBJ'.default_ratio = 1
		local ratio = 1E-4
	}
	else {
		mata : `OBJ'.default_ratio = 0
	}

	cap confirm number `ratio'
	local rc = _rc

	if (`rc') {
		di as err "option {bf:grid(,ratio(#))} allows "	///
			"only positive number < 1"
		exit 198
		// NotReached
	}

	if (`ratio' <=0) {
		di as err "option {bf:grid(,ratio(#))} allows "	///
			"only positive number"
		exit 198
		// NotReached
	}

	if (`ratio' > 1) {
		di as err "option {bf:grid(,ratio(#))} allows "	///
			"only positive number < 1"
		exit 198
		// NotReached
	}

	mata : `OBJ'.lp_ratio = `ratio'
end
					//----------------------------//
					// parse stop 
					//----------------------------//
program ParseFdevtol
	_pglm_parse_colon `0'		// parse OBJ
	
	syntax [, stop(numlist max=1 >=0 <1000)]

	if (`"`stop'"' == "") {
		local stop = 1E-5
	}

	mata : `OBJ'.fdev_tol = `stop'
end
					//----------------------------//
					// parse CV
					//----------------------------//
program ParseCV
	_pglm_parse_colon `0'		// parse OBJ

	syntax [fw iw/] [,		///
		cv 			///
		folds(string) 		///
		rlasso(string) 		///
		seldefault		///
		unpenalized]


	if (`"`unpenalized'"' != "") {			// case 0: unpenalized
		mata : `OBJ'.cv = 0
	}
	else if ("`cv'" == "") {			// case 1 : no cv
		mata : `OBJ'.cv = 0
	}
	else if (`"`cv'"' != "" & `"`folds'"' == "") { // case 2 : default cv
		mata : `OBJ'.cv = 1
		mata : `OBJ'.nfold = 10
	}
	else if (`"`cv'"' != "" & `"`folds'"' != "") {	// case 3 : custom cv
		ParseCvSpec `OBJ' : `folds'
	}

	if ("`cv'" != "" & `"`rlasso'"' != "") {
		di "{p 0 2 2}"
		di as err "cross-validation is not allowed when "	///
			"plug-in lasso penalty value is specified"
		di "{p_end}"
		exit 198
	}

	if ("`cv'" != "" & `"`weight'"' == "fweight") {
		if (`"`seldefault'"' != "") {
			local default ", assumed by default"
		}

		di as err "{p}frequency weights not supported with "	///
			"cross-validation, {bf:selection(cv)}`default'{p_end}"
		exit 198
	}
end
					//----------------------------//
					// parse CV spec
					//----------------------------//
program ParseCvSpec
	_pglm_parse_colon `0'		// parse OBJ

	syntax [anything(name=nfold)] 
					// parse nfold		
	mata : `OBJ'.cv = 1

	if (`"`nfold'"' == "") {
		mata : `OBJ'.nfold = 10
	}
	else {
		cap confirm integer number `nfold'
		if (_rc) {
			di as err "option {bf:folds()} must be an integer >=3"	
			exit 198
		}
		if (`nfold' < 3) {
			di as err "option {bf:folds()} must be an integer >=3"	
			exit 198
		}
		mata : `OBJ'.nfold = `nfold'
	}
end

					//----------------------------//
					// parse nfold
					//----------------------------//
program ParseNfold
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, nfold(integer 10)]

	if (`nfold' <3) {
		di as err "option {bf:nfold()} must be an integer >=3"
		exit 198
	}
	mata : `OBJ'.nfold = `nfold'
end
					//----------------------------//
					// parse linear vars
					//----------------------------//
program ParseVarsLinear
	_pglm_parse_colon `0'		// parse OBJ

	syntax anything(name=eq id="depvar [(alwaysvars)] othervars")	///
		[, wgt(passthru)	///
		touse(passthru)		///
		depname(string)		///
		rmcollinear]
						//  depvar
	GetDepvar , eq(`eq')
	local depvar `s(depvar)'
	local eq `s(eq)'
						//  indepvars and ainclude
	ParseEq `eq', `wgt' `touse' depvar(`depvar') `rmcollinear'
 	local indepvars `s(indepvars)'
	local ainclude `s(ainclude)'

	if (`"`depname'"'=="") {
		local depname `depvar'
	}

	mata : `OBJ'.depvar = strtrim(`"`depvar'"')
	mata : `OBJ'.indepvars = strtrim(`"`indepvars'"')
	mata : `OBJ'.depname = strtrim(`"`depname'"')
	mata : `OBJ'.ainclude = strtrim(`"`ainclude'"')
end
					//----------------------------//
					// parse logit vars
					//----------------------------//
program ParseVarsLogit
	_pglm_parse_colon `0'		// parse OBJ

	syntax anything(name=eq id="depvar [(alwaysvars)] othervars")	///
		[, wgt(passthru)	///
		touse(string)		///
		depname(string)		///
		rmcollinear]

						//  depvar
	GetDepvar , eq(`eq')
	local depvar `s(depvar)'
	local eq `s(eq)'
						// check logit depvar
	CheckLogitDepvar , depvar(`depvar') touse(`touse')
						//  indepvars and ainclude
	ParseEq `eq', `wgt' touse(`touse') depvar(`depvar') `rmcollinear'
 	local indepvars `s(indepvars)'
	local ainclude `s(ainclude)'

	local tmp_depvar `OBJ'_depvar
	qui gen `tmp_depvar' = `depvar' > 0 if `depvar' != .

	if (`"`depname'"' == "") {
		local depname `depvar'
	}

	mata : `OBJ'.depvar = strtrim(`"`tmp_depvar'"')
	mata : `OBJ'.indepvars = strtrim(`"`indepvars'"')
	mata : `OBJ'.depname = strtrim(`"`depname'"')
	mata : `OBJ'.ainclude = strtrim(`"`ainclude'"')
end

					//----------------------------//
					// parse poisson vars
					//----------------------------//
program ParseVarsPois
	_pglm_parse_colon `0'		// parse OBJ

	syntax anything(name=eq id="depvar [(alwaysvars)] othervars")	///
		[, wgt(passthru)	///
		touse(passthru)		///
		depname(string)		///
		rmcollinear]

						//  depvar
	GetDepvar , eq(`eq')
	local depvar `s(depvar)'
	local eq `s(eq)'
						//  indepvars and ainclude
	ParseEq `eq', `wgt' `touse' depvar(`depvar') `rmcollinear'
 	local indepvars `s(indepvars)'
	local ainclude `s(ainclude)'

	cap assert `depvar' >= 0
	if _rc {
		di as err "`depvar' must be greater than or equal to zero"
		exit 459
	}

	if (`"`depname'"' == "") {
		local depname `depvar'
	}

	mata : `OBJ'.depvar = strtrim(`"`depvar'"')
	mata : `OBJ'.indepvars = strtrim(`"`indepvars'"')
	mata : `OBJ'.depname = strtrim(`"`depname'"')
	mata : `OBJ'.ainclude = strtrim(`"`ainclude'"')
end
					//----------------------------//
					// parse mlogit vars
					//----------------------------//
program ParseVarsMlogit
	_pglm_parse_colon `0'		// parse OBJ

	syntax anything(name=eq id="depvar [(alwaysvars)] othervars")	///
		[, wgt(passthru)	///
		touse(passthru) 	///
		depname(string)		///
		rmcollinear]
		
						//  depvar
	GetDepvar , eq(`eq')
	local depvar `s(depvar)'
	local eq `s(eq)'
						//  indepvars and ainclude
	ParseEq `eq', `wgt' `touse' depvar(`depvar') `rmcollinear'
 	local indepvars `s(indepvars)'
	local ainclude `s(ainclude)'

	mata: st_local("touse", `OBJ'.touse)
	fvexpand ibn.`depvar' if `touse'
	local tmp_depvar `r(varlist)'

	if (`"`depname'"' == "") {
		local depname `tmp_depvar'
	}

	mata : `OBJ'.depvar = strtrim(`"`tmp_depvar'"')
	mata : `OBJ'.indepvars = strtrim(`"`indepvars'"')
	mata : `OBJ'.depname = strtrim(`"`depname'"')
	mata : `OBJ'.depvar_s = strtrim(`"`depvar'"')
	mata : `OBJ'.ainclude = strtrim(`"`ainclude'"')
end
					//----------------------------//
					// parse Cox vars
					//----------------------------//
program ParseVarsCox
	_pglm_parse_colon `0'		// parse OBJ

	syntax anything(name=eq id="[(alwaysvars)] othervars")	///
		[, wgt(passthru)	///
		touse(string)		///
		depname(string)		///
		rmcollinear]
	
	qui st_is 2 analysis			
						//  indepvars and ainclude
	ParseEq `eq', `wgt' touse(`touse') depvar(_t) `rmcollinear'
 	local indepvars `s(indepvars)'
	local ainclude `s(ainclude)'
						//  depvar
	local depvar _t
	_fv_check_depvar `depvar'
						//  sort data
	tempvar dinv
	gen byte `dinv' = cond(_d, 0, 1)
	sort _t `dinv' _t0, stable
						//  markout again
	markout `touse' _t _t0 _d _st

	if (`"`depname'"' == "") {
		local depname `depvar'
	}

	mata : `OBJ'.depvar = strtrim(`"`depvar'"')
	mata : `OBJ'.indepvars = strtrim(`"`indepvars'"')
	mata : `OBJ'.depname = strtrim(`"`depname'"')
	mata : `OBJ'.ainclude = strtrim(`"`ainclude'"')

	st_show
end

					//----------------------------//
					// parse penalty factor
					//----------------------------//
program ParsePfactor
	_pglm_parse_colon `0'		// parse OBJ

	syntax [anything(name=penaltywt)] [, nonormalize]
					//  default case
	if (`"`normalize'"' == "nonormalize") {
		local norm_pfactor = 0
	}
	else {
		local norm_pfactor = 1
	}
	if (`"`penaltywt'"' == "") {
		mata : `OBJ'.pfactor = .
		mata : `OBJ'.norm_pfactor = `norm_pfactor'
		exit
		// NotReached
	}

	cap confirm matrix `penaltywt'
	local is_mat = !_rc

	local is_num = 0
	if (!`is_mat') {
		local 0 , penaltywt(`penaltywt')
		cap syntax , penaltywt(numlist)
		local is_num = !_rc
	}

	if (!`is_num' & !`is_mat') {
		di as err "option {bf:penaltywt()} must be either a matrix " ///
			"or numlist"
		exit 198
	}

	local pfactor_vec `OBJ'_pfactor_vec

	mata : parse_pfactor(`"`penaltywt'"', `is_mat', `"`pfactor_vec'"')
	mata : `OBJ'.pfactor = st_matrix(`"`pfactor_vec'"')
	mata : `OBJ'.norm_pfactor = `norm_pfactor'
end

					//----------------------------//
					// parse alphas
					//----------------------------//
program ParseAlpha
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, alphas(real 1) 	///
		rlasso(string) 		///
		sqrt ]

	if (`alphas' >1 | `alphas' < 0) {
		di as err `"{bf:alphas(`alphas')} invalid"'
		di as err `"{bf:alphas()} must specify "'	///
			`"a number between 0 and 1"'
		exit 198
	}
	
	if (`alphas' != 1 & `"`rlasso'"' != "") {
		di "{p 0 2 2}"
		di as err "alphas should be 1 when plug-in "	///
			"Lasso penalty is specified"
		di "{p_end}"
		exit 198
	}

	if (`alphas' != 1 & `"`sqrt'"' != "") {
		di "{p 0 2 2}"
		di as err "alphas should be 1 when square-root "	///
			"Lasso is specified"
		di "{p_end}"
		exit 198
	}

	mata : `OBJ'.alpha = `alphas'
end
					//----------------------------//
					// parse saving
					//----------------------------//
program ParseSaving
	_pglm_parse_colon `0'		// parse OBJ

	syntax [name(name=saving id="saving")]	///
		[, REPlace]

	if (`"`saving'"' == "") {
		mata : `OBJ'.saving = "lassoresults"
		mata : `OBJ'.replace = "replace"
	}
	else {
		mata : `OBJ'.saving = `"`saving'"'
		mata : `OBJ'.replace = `"`replace'"'
	}
end
					//----------------------------//
					// parse laout
					//----------------------------//
program ParseLaout
	_pglm_parse_colon `0'		// parse OBJ

	syntax [anything(name=laout id="lasso output")]	///
		[, REPlace]

	if (`"`laout'"' == "") {
		esrf default_filename
		local laout_default `s(stxer_default)'
		mata : `OBJ'.laout_name = `"`laout_default'"'
		mata : `OBJ'.laout_replace = 1
		exit
		// NotReached
	}

	mata : `OBJ'.laout_name = `"`laout'"'
	if (`"`replace'"' == "replace") {
		mata : `OBJ'.laout_replace = 1
	}
	else {
		mata : `OBJ'.laout_replace = 0
	}

	mata : `OBJ'.verify_laout()
end

					//----------------------------//
					// parse indepvars
					//----------------------------//
program ParseIndepvars, sclass
	syntax [varlist(fv numeric default=none)]	///
		[, wgt(string) 				///
		touse(string) 				///
		rmcollinear				///
		notransform]
	
	RmColl, varlist(`varlist') wgt(`wgt') 	///
		touse(`touse') `rmcollinear'	///
		`transform'
	sret local indepvars `s(myvars)'
end
					//----------------------------//
					// parse power
					//----------------------------//
program ParsePower
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, power(real 1)] 

	if (`power' < 0.25 | `power' > 2) {
		di as err "option {bf:power()} must specify a real number " ///
			"between 0.25 and 2"
		exit 198
	}

	mata : `OBJ'.power = `power'
end
					//----------------------------//
					// parse step
					//----------------------------//
program ParseAdaptStep
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, adaptstep(integer 1)] 
	mata : `OBJ'.adaptstep = `adaptstep'
end
					//----------------------------//
					// parse iterate
					//----------------------------//
program ParseIterate
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, iterate(integer 100000)] 
	
	cap assert `iterate' > 0
	if (_rc) {
		di as err "option {bf:iterate(#)} must be a positive integer"
		exit 198
	}

	mata : `OBJ'.maxit = `iterate'
end
					//----------------------------//
					// parse pretotal
					//----------------------------//
program ParsePreklp
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, preklpenalty(integer 0)] 
	mata : `OBJ'.preklp = `preklpenalty'
end

					//----------------------------//
					// parse rigorous lasso penalty
					//----------------------------//
program ParseRlpenalty
	_pglm_parse_colon `0'

	syntax [, sqrt model(string) *]
	if (`"`options'"' == "") {
		mata : `OBJ'.plugin = 0
		exit
		//NotReached
	}


	syntax [, PLUGIN 			///
		HETeroskedastic 		///
		HOMoskedastic			///
		XDEPendent			///	undocumented below
		gamma(real 0.1)			///
		maxiter(real 15)		///
		tol(real 1E-8)			///
		c(real 1.1)			///
		CORRNum(real 5)			///
		numsim(real 5000)		///
		lassoup				///
		sqrt				///
		WARMSTART			///
		WARMSTART1(numlist max=1 >0)	///
		model(string)]
	
	local err_type `heteroskedastic' `homoskedastic'
	local n_err_type : list sizeof err_type

	if (`n_err_type' == 2) {
		di as err "option {bf:heteroskedastic} cannot be specified " ///
			"with option {bf:homoskedastic}"
		exit 198
	}

	if (`"`err_type'"' == "") {
		local heteroskedastic heteroskedastic	
	}

	if (`"`lassoup'"'!="") {
		local lassoup = 1
	}
	else {
		local lassoup = 0
	}
	
	if (`"`plugin'"' != "") {
		local xdep = 0
		local heter = 1
		local lassoup = 0
	}

	if (`"`xdependent'"' != "") {
		local xdep = 1
	}
	else {
		local xdep = 0
	}

	if (`"`heteroskedastic'"' != "") {
		local heter = 1
	}
	else {
		local heter = 0
	}

	if (`c' < 0) {
		di as error "{bf:plugin(c(#))} must be a real " 	///
			"number bigger than 0"
		exit 198
	}

	if (`gamma' > 1) {
		di as error "{bf:plugin(gamma(\#))}" must be a real " ///
			"number smaller than 1 and bigger than 0"
		exit 198
	}

	if (`"`sqrt'"'!="" & `heter' & `xdep') {
		di "{p 0 2 2}"
		di as error "square-root Lasso does not allow "		///
			"X-dependent penalty values with "		///
			"heteroskedastic error. "			///
			"option {bf:plugin(xdep hetero)} cannot "	///
			"be specified with option {bf:sqrt}"
		di "{p_end}"
		exit 198
	}

	if (`"`warmstart'"' != "") {
		local plugin_warm = 1
		local warm_points = 30
	}
	else if (`"`warmstart1'"' != "") {
		local plugin_warm = 1
		local warm_points = `warmstart1'
	}
	else {
		local plugin_warm = 0
		local warm_points = 1
	}

	
	mata : `OBJ'.plugin = 1
	mata : `OBJ'.gamma = `gamma'
	mata : `OBJ'.plugin_warm = `plugin_warm'
	mata : `OBJ'.warm_points = `warm_points'

	if (`"`model'"' != "linear") {
		exit
		// NotReached
	}
	mata : `OBJ'.xdep = `xdep'
	mata : `OBJ'.heter = `heter'
	mata : `OBJ'.c = `c'
	mata : `OBJ'.maxiter_plugin = `maxiter'
	mata : `OBJ'.sigmatol = `tol'
	mata : `OBJ'.corrnum = `corrnum'
	mata : `OBJ'.lassoup = `lassoup'
	mata : `OBJ'.numsim = `numsim'
end

					//----------------------------//
					// parse observational weights
					//----------------------------//
program ParseWeights
	_pglm_parse_colon `0'		// parse OBJ

	syntax [fw iw/] , wvar(string) touse(string)


	if ("`weight'" == "") {
		mata : `OBJ'.wvar = ""
	}
	else {
		qui gen double `wvar' =`exp' if `touse'
		mata : `OBJ'.wvar = `"`wvar'"'
		mata : `OBJ'.wtype = `"`weight'"'
		mata : `OBJ'.wexp = `"=`exp'"'
	}

	if (`"`weight'"' != "") {
		local wgt [`weight'=`exp']
	}

	mata : `OBJ'.wgt = `"`wgt'"'
end
					//----------------------------//
					// parse CVCheck
					//----------------------------//
program ParseStrict
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, strict gridminok] 

	if (`"`strict'"' != "" & `"`gridminok'"' != "") {
		di as err "option {bf:strict} cannot be specified with " ///
			"option {bf:gridminok}"
		exit 198
	}

	if (`"`strict'"' == "strict") {
		local strict = 1
	}
	else {
		local strict = 0
	}

	mata : `OBJ'.strict = `strict'
end
					//----------------------------//
					// parse log
					//----------------------------//
program ParseLog
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, nolog] 

	if (`"`log'"' == "nolog") {
		local showlog = 0
	}
	else if (c(iterlog) == "off") {
		local showlog = 0
	}
	else {
		local showlog = 1
	}

	mata : `OBJ'.showlog = `showlog'
end
					//----------------------------//
					// parse ds log
					//----------------------------//
program ParseDslog
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, dslog relog]

	if (`"`dslog'"' == "") {
		local dslog = 0
	}
	else {
		local dslog = 1
	}

	mata: `OBJ'.dslog = `dslog'

	if (`"`relog'"' == "") {
		local relog = 0
	}
	else {
		local relog = 1
	}

	mata: `OBJ'.relog = `relog'
end
					//----------------------------//
					// parse value convergence
					//----------------------------//
program ParseValueconv
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, tolerance(passthru)	///
		dtolerance(passthru) ]

	if (`"`tolerance'"' != "" & `"`dtolerance'"' != "") {
		di as err "only one of {bf:tolerance()} and "	///
			"{bf:dtolerance()} is allowed"
		exit 198
	}

	if (`"`dtolerance'"' != "") {
		local 0 , `dtolerance'
		syntax , dtolerance(numlist max=1 >0 <1000) 
		local dev_tol = `dtolerance'
		mata : `OBJ'.lp_tol = `dev_tol'

		local valueconv = 1
	}
	else {
		local valueconv = 0
	}

	mata: `OBJ'.valueconv = `valueconv'
end
					//----------------------------//
					// parse value convergence
					//----------------------------//
program ParseXcheck
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, noxcheck]

	if (`"`xcheck'"' == "noxcheck") {
		local xcheck = 0
	}
	else {
		local xcheck = 1
	}

	mata: `OBJ'.xcheck = `xcheck'
end
					//----------------------------//
					// parse value convergence
					//----------------------------//
program ParseCrossFitInfo
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, xfold_idx(string)	///
		resample_idx(string)]
	
	mata : `OBJ'.xfold_idx = `"`xfold_idx'"'
	mata : `OBJ'.resample_idx = `"`resample_idx'"'
end

					//----------------------------//
					// Parse sqrt
					//----------------------------//
program ParseSqrt
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, sqrt] 

	if (`"`sqrt'"' == "") {
		mata: `OBJ'.sqrt_lasso = 0
	}
	else {
		mata: `OBJ'.sqrt_lasso = 1
	}

end

					//----------------------------//
					// Parse post
					//----------------------------//
program ParsePost
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, nopost] 

	if (`"`post'"' == "nopost") {
		mata: `OBJ'.esrf_post = 0
	}
	else {
		mata: `OBJ'.esrf_post = 1
	}

end
					//----------------------------//
					// Parse esrf_append
					//----------------------------//
program ParseEsrfAppend
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, esrf_append] 

	if (`"`esrf_append'"' == "esrf_append") {
		mata: `OBJ'.esrf_append = 1
	}
	else {
		mata: `OBJ'.esrf_append = 0
	}

end
					//----------------------------//
					// Parse esrf_savefn
					//----------------------------//
program ParseEsrfSaveFn
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, esrf_savefn] 

	if (`"`esrf_savefn'"' == "esrf_savefn") {
		mata: `OBJ'.esrf_savefn = 1
	}
	else {
		mata: `OBJ'.esrf_savefn = 0
	}

end
					//----------------------------//
					// Parse esrf_subspace
					//----------------------------//
program ParseEsrfSubspace
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, esrf_subspace(string)] 

	mata: `OBJ'.esrf_subspace= `"`esrf_subspace'"'
end
					//----------------------------//
					// Parse cmd 
					//----------------------------//
program ParseCmd
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, cmd(string) ] 

	if ("`cmd'" == "") {
		local cmd lasso
	}

	mata: `OBJ'.cmd = `"`cmd'"'

end
					//----------------------------//
					// Parse cmdline 
					//----------------------------//
program ParseCmdline
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, cmdline(string)]


	mata: `OBJ'.cmdline = `"`cmdline'"'

end
					//----------------------------//
					// Parse Eq
					//----------------------------//
program ParseEq, sclass
	syntax [anything(name=eq)] 	///
		[, wgt(passthru)	///
		touse(passthru)		///
		rmcollinear]		///
		depvar(string)
	
	_lasso_parse_controls `eq'
	local othervars `s(othervars)'
	local ainclude `s(ainclude)'

						//  rmcoll indepvars
	ParseIndepvars `othervars', `wgt' `touse' `rmcollinear'
	local othervars `s(indepvars)'

						//  rmcoll ainclude
	ParseIndepvars `ainclude', `wgt' `touse' rmcollinear notransform
	local ainclude `s(indepvars)'

	AddBN, vars(`ainclude')
	local tmp_ainclude `s(myvars)'
	CheckCommonAlways, othervars(`othervars')	///
		tmp_ainclude(`tmp_ainclude')		///
		ainclude(`ainclude')
	local othervars : list othervars - tmp_ainclude

						// merge indepvars
	local indepvars : list ainclude | othervars

						//  check if depvar in indepvars
	local in : list depvar in indepvars
	if (`in') {
		di as err "{it:depvar} can not be specified in "	///
			"({it:alwaysvars}) {it:othervars}"
		exit 198
	}
						//  check empty indepvars
	if (`"`indepvars'"' == "") {
		_lasso_errors_eq
	}

	sret local indepvars `indepvars'
	sret local ainclude `ainclude'
end
					//----------------------------//
					// Mark out touse
					//----------------------------//
program MarkOut
	args OBJ

	mata: st_local("touse", `OBJ'.touse)
	mata: st_local("depvar", `OBJ'.depvar)
	mata: st_local("indepvars", `OBJ'.indepvars)

	markout `touse' `depvar' `indepvars'

	sum `depvar' if `touse', meanonly
	local n_obs = r(N)

	if (`n_obs' == 0) {
		di as err "no observations"
		exit 2000
	}
end
					//----------------------------//
					// check if lambdas and grid are both
					// specified
					//----------------------------//
program CheckGridLambdas
	syntax [, lambdas(string) 	///
		grid(string) ]
	
	if (`"`lambdas'"' != "" & `"`grid'"' != "") {
		di as error "option {bf:lambdas()} cannot be specified " ///
			"with option {bf:grid()}"
		exit 198
	}
end

					//----------------------------//
					// parse cross grid
					//----------------------------//
program ParseCrossGrid
	_pglm_parse_colon `0'		// parse OBJ

	cap syntax [, AUGmented	///
		union			///
		DIFFerent]
	local rc = _rc

	local opts `augmented' `union' `different'
	local n_opts : word count `opts'

	if (`n_opts' >=2 | `rc' ) {
		di as err "only one of augmented, union or different " ///
			"is allowed in option {bf:crossgrid()}"
		exit 198
	}
	
	if (`n_opts' == 0) {
		mata : `OBJ'.crossgrid = "augmented"
	}
	else {
		mata : `OBJ'.crossgrid = "`opts'"
	}
end
					//----------------------------//
					// remove collinearity
					//----------------------------//
program RmColl, sclass
	syntax [, varlist(string)	///
		wgt(string) 		///
		touse(string) 		///
		rmcollinear		///
		notransform]
	
	if (`"`rmcollinear'"' == "") {
		_lasso_fvexpand `varlist' if `touse', `transform'
		local myvars `r(varlist)'
		sret local myvars `myvars'
		exit
		// NotReached
	}
	else {
		fvexpand `varlist'
		local myvars `r(varlist)'
	}
						//  get n_obs and pvars
	tempvar obs
	qui gen `obs' = 1
	sum `obs' if `touse', meanonly
	local n_obs = r(N)
	local pvars : list sizeof myvars
						//  check if can do rmcoll
	if (`pvars' > `n_obs') {
		di "cannot remove collinearity"
		di "{p 4 4 2}"
		di "number of observations is smaller than the "	///
			"number of variables"
		di "{p_end}"
		sret local myvars `myvars'
		exit
		// NotReached
	}

	_rmcoll `varlist' if `touse' `wgt', expand
	local full_vars `r(varlist)'
	local full_vars: list uniq full_vars

	foreach var of local full_vars {
		_ms_parse_parts `var'
		if (!r(omit)) {
			local myvars_rmcoll `myvars_rmcoll' `var'
		}
	}

	if (`"`transform'"' != "notransform") {
		_lasso_fvexpand `myvars_rmcoll' if `touse', `transform'
		local myvars_rmcoll `r(varlist)'
	}

	sret local myvars `myvars_rmcoll'
end
					//----------------------------//
					// parse iterate
					//----------------------------//
program ParseSerule
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, serule ] 
	
	if (`"`serule'"' == "") {
		local serule = 0
	}
	else {
		local serule = 1
	}

	mata : `OBJ'.serule = `serule'
end
					//----------------------------//
					// parse unpenalized
					//----------------------------//
program ParseUnpen
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, unpenalized ] 
	
	if (`"`unpenalized'"' == "") {
		local unpen = 0
	}
	else {
		local unpen = 1
	}

	mata : `OBJ'.unpen = `unpen'
end
					//----------------------------//
					// parse adapt 
					//----------------------------//
program ParseAdapt
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, adapt ] 

	if (`"`adapt'"'' == "") {
		local adapt = 0
	}
	else {
		local adapt = 1 
	}
	
	mata : `OBJ'.adapt = `adapt'
end
					//----------------------------//
					// parse adapt 
					//----------------------------//
program ParseAdaptRidge
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, adapt_ridge ] 

	if (`"`adapt_ridge'"'' == "") {
		local adapt_ridge = 0
	}
	else {
		local adapt_ridge = 1 
	}
	
	mata : `OBJ'.adapt_ridge = `adapt_ridge'
end
					//----------------------------//
					// parse alllambdas
					//----------------------------//
program ParseFastcv
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, alllambdas 		///
		adaptstep(string)	///
		adapt] 

	if (`"`alllambdas'"'' != "") {
		local fastcv = 0
	}
	else {
		local fastcv = 1
	}

	if ("`adaptstep'" != "1" & "`adaptstep'" != "" & `"`adapt'"' != "") {
		local fastcv = 0
	}
	
	mata : `OBJ'.fastcv = `fastcv'
end
					//----------------------------//
					// parse gridminok
					//----------------------------//
program ParseGridminok
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, gridminok] 

	if (`"`gridminok'"'' == "gridminok") {
		local gridminok = 1
	}
	else {
		local gridminok = 0
	}
	
	mata : `OBJ'.gridminok = `gridminok'
end
					//----------------------------//
					// parse offset
					//----------------------------//
program ParseOffset
	_pglm_parse_colon `0'		// parse OBJ
	
	syntax , model(string)			///
		touse(string)			///
		[offset(varname numeric)	///
		exposure(varname numeric)]
	
	if (`"`model'"' != "poisson" & `"`exposure'"' !="") {
		di as err "option {bf:exposure()} not allowed for " ///
			"{bf:`model'} model"
		exit 198
	}

	if (`"`offset"'"' != "" & `"`exposure'"' != "") {
		di as err "only one of offset() or exposure() can be specified"
		exit 198
	}

	if (`"`exposure'"' != "") {
		sum `exposure' if `touse', meanonly
		if (r(min) <= 0) {
			di as error "{bf:exposure()} must be greater than zero"
			exit 459
		}
	}

	mata : `OBJ'.st_offset = `"`offset'"'
	mata : `OBJ'.st_exposure = `"`exposure'"'
end

					//----------------------------//
					// parse rngstate
					//----------------------------//
program ParseRngstate
	_pglm_parse_colon `0'		// parse OBJ
	
	syntax [, rngstate(string)]

	mata : `OBJ'.rngstate = `"`rngstate'"'
end
					//----------------------------//
					// parse stopok
					//----------------------------//
program ParseStopok
	syntax [, stopok strict gridminok]

	local stop_rule `stopok' `strict' `gridminok'
	local n_stop : list sizeof stop_rule

	if (`n_stop' > 1) {
		di as err "only one of {bf:stopok}, {bf:strict}, " ///	
			"or {bf:gridminok} can be specified."
		exit 198
	}
end

					//----------------------------//
					// check logit depvar must be 0/1
					//----------------------------//
program CheckLogitDepvar
	syntax , depvar(string) 	///
		touse(string)

	sum `depvar' if `touse', meanonly
	local min = r(min)
	local max = r(max)

	if (`min' == `max') {
		di as err "outcome does not vary, and it must be 0 or 1."
		exit 2000
	}

	if (`min'!=0 | `max' != 1) {
		di as err "outcome must be 0 or 1."
		exit 2000
	}

	qui tabulate `depvar' if `touse'
	local k = r(r)

	if (`k' != 2) {
		di as err "outcome must be 0 or 1."
		exit 2000
	}
end
					//----------------------------//
					// add bn
					//----------------------------//
program AddBN, sclass
	syntax [, vars(string)]

	if (`"`vars'"' == "") {
		exit
		// NotReached
	}

	mata : _lasso_add_bn(tokens(`"`vars'"'), "myvars")
	sret local myvars `myvars'
end

					//----------------------------//
					// check common
					//----------------------------//
program CheckCommonAlways
	syntax [, othervars(string)	///
		tmp_ainclude(string)	///
		ainclude(string)]
	
						// check if there is common
						// always vars
	local common: list othervars & tmp_ainclude

	local i = 1
	foreach var of local common {
		local myvar : word `i' of `tmp_ainclude'
		if (`"`var'"' == `"`myvar'"') {
			local good : word `i' of `ainclude'
			local newcommon `newcommon' `good'
		}
		local i = `i' + 1
	}

	if (`"`newcommon'"' != "") {
		di as txt "{p 0 6 2}note: {bf:`newcommon'} specified "	///
			"as {it:alwaysvar} and {it:othervar}; "		///
			"assumed to be {it:alwaysvar} and always "	///
			"selected{p_end}"
	}
end
					//----------------------------//
					// parse cv tolerance
					//----------------------------//
program ParseCvtol
	_pglm_parse_colon `0'		// parse OBJ

	syntax [, cvtolerance(numlist max=1 >=0 <1000)]

	if (`"`cvtolerance'"' == "") {
		local cvtolerance = 1E-3
	}

	mata: `OBJ'.cvtol = `cvtolerance'
end
					//----------------------------//
					// Get depvar
					//----------------------------//
program GetDepvar, sclass
	syntax [, eq(string) ]

	_lasso_parse_controls `eq'
	local ainclude `s(ainclude)'

	if (`"`ainclude'"' == "") {
		local 0 `eq'
		syntax varlist(numeric fv)
		local eq `varlist'
		gettoken depvar eq : eq
		_fv_check_depvar `depvar'
	}
	else {
		local loc = ustrpos(`"`eq'"', `"("')

		if (`loc' == 1) {
			_lasso_errors_eq
		}

		local eq_before = usubstr(`"`eq'"', 1, `loc'-1)
		local 0 `eq_before'
		syntax varlist(numeric fv)
		local depvar `varlist'

		_fv_check_depvar `depvar'

		if (`:list sizeof depvar' != 1) {
			_lasso_errors_eq
		}

		local eq : list eq - eq_before 
	}

	if (`"`eq'"' == "") {
		_lasso_errors_eq
	}
	
	sret local eq `eq'
	sret local depvar `depvar'
end


/*--------------------------------Mata utility -----------------------------*/
mata :
mata set matastrict on
					//----------------------------//
					// parse lambdas
					//----------------------------//
void parse_lp(			///
	string scalar	_lp,	///
	real scalar	is_mat,	///
	string scalar	st_lp_mat)
{
	real colvector lp	

	if (is_mat) {		
		lp = st_matrix(_lp)		// case 1 : matrix
	}
	else {
		lp = strtoreal(tokens(_lp))'	// case 2: numlist or scalar
	}

	check_lp(lp)		//  check lp
	_sort(lp, -1)		// sort in descending order
	st_matrix(st_lp_mat, lp)
}

					//----------------------------//
					// check lambdas vector
					//----------------------------//
void check_lp(real matrix lp)
{
	real scalar	row_lp, col_lp

	if (sum(lp:<0)>0) {
		errprintf("{p 0 2 2}")
		errprintf("option {bf:lambdas()} contains at least "	///
			+ "one negative value")
		errprintf("{p_end}")
		exit(198)
	}
	row_lp = rows(lp)
	col_lp = cols(lp)
						//  check if vector
	if (row_lp >1 & col_lp > 1) {
		errprintf("{p 0 2 2}")
		errprintf("option {bf:lambdas()} must be a "	///
			+ "vector")
		errprintf("{p_end}")
		exit(198)
	}
						// transpose to col vector
	if (row_lp ==1 & col_lp >= 1) {
		lp = lp'
	}
}

					//----------------------------//
					// parse pfactor
					//----------------------------//
void parse_pfactor(			///
	string scalar	_pfactor,	///
	real scalar	is_mat,		///
	string scalar	st_pfactor)
{
	real colvector pf

	if (is_mat) {
		pf = st_matrix(_pfactor)
	}
	else {
		pf = strtoreal(tokens(_pfactor))'
	}
	check_pf(pf)
	st_matrix(st_pfactor, pf)
}
					//----------------------------//
					// check pfactor
					//----------------------------//
void check_pf(real matrix pf)
{
	real scalar	row_pf, col_pf

	if (sum(pf:<0)>0) {
		errprintf("{p 0 2 2}")
		errprintf("option {bf:penaltywt()} contains at least "	///
			+ "one negative value")
		errprintf("{p_end}")
		exit(198)
	}
	row_pf = rows(pf)
	col_pf = cols(pf)
						//  check if vector
	if (row_pf >1 & col_pf > 1) {
		errprintf("{p 0 2 2}")
		errprintf("option {bf:penaltywt()} must be a "	///
			+ "vector")
		errprintf("{p_end}")
		exit(198)
	}
						// transpose to col vector
	if (row_pf ==1 & col_pf >= 1) {
		pf = pf'
	}
}

end
exit
