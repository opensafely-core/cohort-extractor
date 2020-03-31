*! version 4.2.1  19aug2019
* asmprobit - multinomial probit model for alternative specific
* 		and case specific variables
	
program asmprobit, eclass byable(onecall) prop(cm) 
	version 14

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	
	if replay() {
		if `"`BY'"' != "" error 190
		
		if ("`e(cmd)'" != "asmprobit" & "`e(cmd)'" != "cmmprobit") {
			error 301
		}
		
		if "`e(diparm1)'" == "" {
			_asprobit_diparm
		}
		
		_asprobit_replay `0'
		exit
	}
	
	local vv : di "version " string(_caller()) ":"
	
	`vv' ///
        _asprobit_vce_parserun asmprobit, by(`BY'): `0'
	
	local cmdline `"asmprobit `0'"'
	local cmdline : list retokenize cmdline
        
        if ("`s(exit)'" != "") {
		ereturn local cmdline `"`cmdline'"'
		exit
	}

	`vv' ///
	cap noi `BY' Estimate `0'
	local rc = _rc
	
	ereturn local cmdline `"`cmdline'"'
	
	cap mata : mata drop _mprobit_panel_info
	cap mata : mata drop _mprobit_P
	if ("$ASPROBIT_seed0"!="") set seed $ASPROBIT_seed0
	macro drop ASPROBIT_*
	exit `rc'
end

program Estimate, eclass byable(recall) sortpreserve
	local vv : di "version " string(_caller()) ":"
	version 14
	syntax varlist(numeric fv) [if] [in] [fw pw iw], ///
		case(passthru)			///
		ALTernatives(varname) [ 	///
		CASEVars(passthru)		///
		BASEalternative(string)		///
		SCALEalternative(string)	///
		CORRelation(passthru)		///
		STDdev(passthru)		///
		STRUCtural			///
		FACTor(passthru)		///
		INTMethod(passthru)		///
		INTPoints(passthru)		///
		INTBurn(passthru)		///
		INTSeed(passthru) 		///
		ANTIthetics			///
		noPIVot				///
		favor(passthru)			///
		CLuster(varname)		///
		noCONstant			///
		COLlinear			///
		altwise				///
		Level(cilevel) 			///
                CM				///
		CLUSTERCHECK(passthru)		///
                * ]

	_get_diopts diopts options, `options'
	if ("`level'"!="") local levopt level(`level')

	if "`altwise'"=="" & ("`if'`in'"!="" | _by()) {
		/* marksample using [if] [in] or by: only */
		tempvar uifin
		mark `uifin' `if'`in'
		local ifinopt ifin(`uifin')
	}
	marksample touse
	if (`"`cluster'"'!="") {
		markout `touse' `cluster', strok
		local clopt cluster(`cluster')
	}
	cap count if `touse'
	if (r(N) == 0) error 2000

	local const = ("`constant'"=="")
	if ("`basealternative'"!="") local bopt base("`basealternative'")
	if ("`scalealternative'"!="") local sopt scale("`scalealternative'")

	/* save seed incase this is a bootstrap call			*/
	if ("`intseed'"!="") global ASPROBIT_seed0 = c(seed)

	tempname model
	`vv' ///
	.`model' = ._asmprobitmodel.new `varlist' [`weight'`exp'],       ///
		touse(`touse') altern(`alternatives') `case' `casevars'  ///
		const(`const') `bopt' `sopt' `correlation' `stddev'      ///
		`structural' `intmethod' `intpoints' `intburn' `intseed' ///
		`antithetics' `pivot' `favor' `collinear' `ifinopt'      ///
		`altwise' `factor' `cm'

	`vv' ///
	_asprobit_estimator, model(`model') cluster(`cluster') ///
			     `clustercheck' `options'
	_asprobit_diparm

	if ("`altwise'" != "") {
		ereturn local marktype altwise
	}
	else {
		ereturn local marktype casewise
	}
	
	ereturn hidden local marginsmark cm_margins_marksample 
	ereturn hidden local marginsprop addcons cm allcons
	
	ereturn local marginsnotok stdp SCores
	ereturn local marginsok    default Pr XB
	
	if "`cm'" != "" {
		ereturn local estat_cmd cmmprobit_estat
		ereturn local predict   cmmprobit_p
		ereturn local title     "Multinomial probit choice model"
		ereturn local cmd       cmmprobit
	}
	else {
		ereturn local mfx_dlg   asmprobit_mfx
		ereturn local estat_cmd asmprobit_estat
		ereturn local predict   asmprobit_p
		ereturn local title     "Alternative-specific multinomial probit"

		ereturn hidden local cmd2 asmprobit
		ereturn local cmd	asmprobit
	}
	
	_asprobit_replay, level(`level') `diopts'
end

exit
