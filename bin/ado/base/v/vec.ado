*! version 1.5.1  17dec2018
program define vec, eclass sort byable(recall)
	local vv : display "version " string(_caller()) ":"
	version 8.0

	if replay() {
		if "`e(cmd)'" != "vec" {
			di as err "{cmd:vec} results not found"
			exit 301
		}
		
		syntax [,				///
			Level(cilevel)			///
			noBTable			///
			ALpha				///
			noPTable			///
			pi				///
			Mai				///
			noETable			///
			noIDtest			///
			dforce				///
			*				///
			]

		_get_diopts options, `options'
		_vec_dreduced 

		CKpdisp , `pi' `ptable'

		DispMain , `dforce' `btable' `alpha'  `pi'	///
			`mai' `etable' level(`level') `idtest'	///
			`ptable' `options'

		exit

	}

	local m1 = _N
	
	local cmdline : copy local 0
	
	syntax varlist(ts numeric min=2) [if] [in]	///
		[ ,  					///
		Trend(string)				///
		LAgs(numlist integer max=1 >0 <`m1')	///
		SIndicators(varlist numeric)    	///
		Seasonal				/// undoc
		Rank(numlist max=1 integer >=1 )	///
		BConstraints(numlist)			///
		AConstraints(numlist)			///
		Level(cilevel)				///
		TOLerance(numlist max=1)		///
		LTOLerance(numlist max=1)		///
		ITERate(numlist max=1 integer)		///
		AFrom(name)				///
		BFrom(name)				///
		NOLOg LOg				///
		TRace					///
		TOLTRace				///
		noBTable				///
		ALpha					///
		pi					///
		noPTable				///
		Mai					///
		noETable				///
		noIDtest				///
		CEKeep(namelist)			/// undoc
		SIKeep(namelist)			/// undoc
		dforce					///
		noreduce				///
		*					///
		]

	_get_diopts diopts, `options'
	marksample touse

	if "`rank'" == "" local rank 1
	if "`bconstraints'" != "" | "`aconstraints'" != "" {
		local cns cns
	}	
	
	if "`cns'" != "" {
		if "`iterate'" == "" local iterate `c(maxiter)'
		if "`tolerance'" == "" local tolerance "1e-7"
		if "`ltolerance'" == "" local ltolerance "1e-10"

		if `iterate' < 0 {
			di as err "{cmd:iterate()} must specify a "	///
				"nonnegative number"
			exit 198	
		}
		local iteratemac "iterate(`iterate')"

		if `tolerance' <= 0 | `tolerance' >=1 {
			di as err "{cmd:tolerance()} must specify a "	///
				"number between 0 and 1"
			exit 198	
		}
		local tolerancemac "tolerance(`tolerance')"

		if `ltolerance' <= 0 | `ltolerance' >= 1 {
			di as err "{cmd:ltolerance()} must specify a "	///
				"number between 0 and 1"
			exit 198	
		}
		local ltolerancemac "ltolerance(`ltolerance')"
	}
	else {

		NoCNSerr iterate paren `iterate'
		NoCNSerr tolerance paren `tolerance'
		NoCNSerr ltolerance paren `ltolerance'
		NoCNSerr bfrom paren `bfrom'
		NoCNSerr afrom paren `afrom'
		NoCNSerr log noparen `log'
		NoCNSerr nolog noparen `nolog'
		NoCNSerr trace noparen `trace'
		NoCNSerr toltrace noparen `toltrace'
	}

	CKpdisp , `pi' `ptable'

	if "`nolog'" != "" & "`trace'" != "" {
		di as err "{cmd:trace} cannot be specified with {cmd:nolog}"
		exit 198
	}

	if "`nolog'" != "" & "`toltrace'" != "" {
		di as err "{cmd:toltrace} cannot be specified with {cmd:nolog}"
		exit 198
	}
	
	if "`trace'" != "" {
		local btrace btrace
	}

	if "`etable'" != "" {
//		local log nolog
	}

	if "`sikeep'" != "" {
		if "`seasonal'" == "" {
			di as err "{cmd:sikeep()} cannot be specified "	///
				"without {cmd:seasonal}"
			exit 198	
		}

		qui tsset, noquery
		local stype "`r(unit1)'"
		local stype_s "`r(unit)'"

		if "`stype'" == "" {
			di as err "type of seasonal data not "		///
				"set in {cmd:tsset}
			exit 498	
		}

		if "`stype'" == "q" {
			local ns 4
		}
		else if "`stype'" == "m" {
			local ns 12
		}
		else {
			di as err "seasonal type `stype_s' not allowed"
			exit 498
		}

		_vectparse ,`trend'	
		local trend "`r(trend)'"

		local ns = `ns' - 1

		local nsi : word count `sikeep'
		if `nsi' != `ns' {
			capture cleanup
			di as err "{p}{cmd:sikeep(`sikeep')} does not "	///
				"specify the correct number of "	///
				"seasonal indicator variables{p_end}"
			exit 198	
		}
		capture noi confirm new variable `sikeep'
		if _rc > 0 {
			local rc = _rc
			capture cleanup
			di as err "{p}{cmd:sikeep(`sikeep')} does not "	///
				"specify a list of new variable names{p_end}"
			exit `rc'	
		}
	}

	if "`cekeep'" != "" {
		local nce : word count `cekeep'
		if `nce' != `rank' {
			capture cleanup
			di as err "{p}{cmd:cekeep(`cekeep')} does not "	///
				"specify the same number of variable "	///
				"names as there are cointegrating "	///
				"equations{p_end}"
			exit 198	
		}
		capture noi confirm new variable `cekeep'
		if _rc > 0 {
			local rc = _rc
			capture cleanup
			di as err "{p}{cmd:cekeep(`cekeep')} does not "	///
				"specify a list of new variable names{p_end}"
			exit `rc'	
		}
	}

	capture macro drop S_madece 

	`vv'							///
	capture noi _vecu `varlist' if `touse', 		///
		trend(`trend') lags(`lags')			///
		sindicators(`sindicators') `seasonal' 		///
		vest rank(`rank') aconstraints(`aconstraints')	///
		bconstraints(`bconstraints') 			///
		`tolerancemac'					///
		ltolerance(`ltolerance')			///
		`iteratemac'					///
		afrom(`afrom') bfrom(`bfrom')			///
		`log' `nolog' `btrace' `toltrace'  `reduce'

	local rc = _rc
	ereturn local cmdline `"vec `cmdline'"'
	_post_vce_rank

	nobreak capture cleanup , rank(`rank') cekeep(`cekeep')	///
		sikeep(`sikeep') nsi(`nsi')

	if `rc' == 0 local rc = _rc

	if (`rc' == 0) {
		DispMain , `dforce' `btable' `alpha' `pi'	///
			`mai' `etable' level(`level') `idtest'	///
			`ptable' `diopts'
	}
	else {
		exit `rc'
	}	

end	

program define cleanup

	syntax ,				///
		rank(integer)			///
		[				///
		nsi(numlist integer max=1)	///
		cekeep(namelist)		///
		sikeep(namelist)		///
		]

	local rc 0
	if "`cekeep'" != "" {
		forvalues j = 1/`rank' {
			local tmp : word `j' of `cekeep'
			capture gen double `tmp' = _ce`j'
			if _rc > 0 local rc = _rc
		}
	}

	forvalues j = 1/`rank' {
		capture drop  _ce`j'
		if _rc > 0 local rc = _rc
	}

	if "`sikeep'" != "" {
		forvalues i = 1/`nsi' {
			local tmp : word `i' of `sikeep' 
			capture rename _season`i' `tmp' 
			if _rc > 0 local rc = _rc
		}
	}
	else {
		capture drop $S_DROP_sindicators
	}

	capture macro drop S_DROP_sindicators
	capture macro drop S_madece 
	capture drop _trend
	capture constraint drop $S_newacns
	capture macro drop S_newacns


	exit `rc'
end

program define Dheadernew
	local vlist "`e(eqnames)'"

	di as txt "Vector error-correction model"
	di

	if "`e(bconstraints)'`e(aconstraints)'" != "" {
		if e(converge) != 1 {
			di as txt "{bf:(convergence not achieved)}"
			di
		}
	}

	_mvtsheadr

	di as txt "{col 49}Number of obs{col 67}= " as res %10.0fc e(N)
	di as txt "{col 49}AIC{col 67}=  " as res %9.8g e(aic)	
	di as txt "Log likelihood = " as res %9.8g e(ll)		///
		as txt "{col 49}HQIC{col 67}=  " as res %9.8g e(hqic)	
	di as txt "Det(Sigma_ml){col 16}= " as res %9.8g e(detsig_ml)	///
		as txt "{col 49}SBIC{col 67}=  " as res %9.8g e(sbic)	
	

end

program define NoCNSerr

	args oname paren oval 

	if "`paren'" == "paren" {
		local p "()"
	}


	if "`oval'" != "" {
		di as err "{bf:`oname'`p'} cannot be "		///
			"specified when no {bf:constraints()} "	///
			"are specified"
		exit 198	
	}		
end

// Not used -- -syntax- checks level(cilevel) automatically
program define _ckLevel

	args level

	if "`level'" == "" {
			exit
	}

	capture confirm integer number `level'
	if _rc > 0 {
		di as err "{cmd:level(`level')} does not specify an integer"
		exit 198
	}

	if `level' < 10 | `level' > 99 {
		di as err "level() must be between 10 and 99"
		exit 198
	}
end


program define CKpdisp
	syntax , [ pi noPTable ]
	if "`pi'" == "pi" & "`ptable'" == "noptable" {
		di as err "{cmd:pi} cannot be specified with "	///
			"{cmd:noptable}"
		exit 198
	}	
end		

program define DispMain, rclass
			
	syntax [,				///
		Level(cilevel)			///
		noBTable			///
		ALpha				///
		noPTable			///
		pi				///
		Mai				///
		noETable			///
		noIDtest			///
		DFOrce				///
		NOCNSReport			///
		*				///
		]
/*
	_ckLevel `level'	<- Not needed: -syntax- did it
*/
	_get_diopts diopts, `options'
	if e(beta_iden) == 0 & "`dforce'" == "" {
		local btable "nobtable"
		local alpha ""
		local etable etable
		local pi pi
	}
	
	if "`ptable'" == "noptable" {
		local pi 
	}

	if "`btable'" == "nobtable" {
		local beta 
	}
	else {
		local beta beta
	}

	local disp `beta' `alpha' `pi' `mai'

	Dheadernew
	
	if "`etable'" == "" {
		DISPRMSE
		di
		if "`nocnsreport'" == "" & "`e(aconstraints)'" != "" {
			local cnsmac "`e(aconstraints)'" 
			local tmp : subinstr local cnsmac ":" ":", 	///
				all count(local nacns)

			local i 1
			while "`cnsmac'" != "" {
				gettoken next cnsmac:cnsmac , parse(":")
				if "`next'" != ":" {
di as txt " (" %2.0f `i' ")" as res "{col 8}`next'"
local ++i
				}
			}
		}
		ereturn display, level(`level') `diopts'
		return add
	}

	tempname tab
	foreach est of local disp {
		di
		_vecauxdisp , estmat(`est') level(`level') 	///
			`idtest' `diopts' `nocnsreport'
		matrix `tab' = r(table)
		return matrix table_`est' `tab'
	}

	if e(beta_iden)==0 & "`dforce'"=="" {
		di as txt _n "Identification:  beta is underidentified" _n
	}

	if e(df_lr) > 0 & e(df_lr) < . & "`idtest'" == ""  {
		local chi : di %7.4g e(chi2_res)
		local chi = trim("`chi'")
		local df : di %3.0f e(df_lr)
		local df = trim("`df'")
		
		di as txt "LR test of identifying restrictions: "	///
			"chi2(" as res 					///
			"`df'" 						///
			as txt ") = "					///
			as res "`chi'"					///	
			as txt _col(60) "Prob > chi2"			///
			_col(72) "="					///
			as res %6.3f _col(73)				///
			chi2tail(e(df_lr), e(chi2_res))
	}

end

program define DISPRMSE

	local vlist "`e(eqnames)'"

	tempname table

	.`table' = ._tab.new, col(6) lmargin(0)
	.`table'.width		17	8	11	10	11	7
	.`table'.numfmt		.	%6.0f	%8.7g	%7.4f	%9.8g	%7.4f
	.`table'.pad		.	.	2	1	.	.
	.`table'.strcolor	green	.	.	.	.	.
	.`table'.strfmt		%-16s	.	.	.	.	.
	.`table'.titlefmt	%-16s	.	.	.	.	.
	di
	.`table'.titles		"Equation"	/// 1
				"Parms"		/// 2
				"RMSE "		/// 3
				"R-sq  "	/// 4
				"chi2   "	/// 5
				" P>chi2"	//  6

	local neqs = e(k_eq)

	.`table'.sep, top
	forvalues i = 1(1)`neqs' {
		local val = chi2tail( e(df_m`i'), e(chi2_`i')) 
		local var : word `i' of `vlist'
		local var = abbrev("`var'", 16)
		.`table'.row	"`var'"		///
				e(k_`i')	///
				e(rmse_`i')	///
				e(r2_`i')	///
				e(chi2_`i')	///
				`val'
	}
	.`table'.sep, bot
end

exit
