*! version 11.2.3  29apr2019
program define nlogit, eclass byable(onecall) 
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	version 14
	if _caller() < 10.0 {
		_nlogit `0'
		exit
	}
	if replay() {
		if ("`e(cmd)'"!="nlogit") error 301
		if (_by()) error 190
		Replay `0'
		exit
	}
	if _by() {
		local by `"by `_byvars'`_byrc0':"'
	}
	local cmdline : copy local 0
	local cmdline : list retokenize cmdline

	`vv' `by' VceParseRun  `0'
	if $NLOGIT_exit {
		ereturn local cmdline `"nlogit `0'"'
		mac drop NLOGIT_*
		exit
	}

	cap noi `vv' `by' Estimate `0'
	local rc = _rc
	ereturn local cmdline `"nlogit `cmdline'"'
	mac drop NLOGIT_*
	exit `rc'
end

program define Estimate, eclass byable(recall) sort
	if _caller() >= 11 {
		local caller = _caller()
		local vv : di "version `caller':"
		if (`caller'>=14) local fv fv
	}
	version 14

	/* nlogit options	*/
	local nlspec case(varname)
	local nlopts noTRee noLABel noBRANCHes NOLOg LOg Robust altwise
	local nlopts `nlopts' cluster(passthru) from(string) Level(cilevel) 
	local nlopts `nlopts' CONSTraints(string) COLlinear vce(passthru)
	local nlopts `nlopts' NONNormalized

	/* undocumented	options */
	local nlopts `nlopts' debug noDROP trace CLUSTERCHECK(varname)

	/* ml options		*/
	local mlopts NONRTOLerance NRTOLerance(string) TRace GRADient HESSian
	local mlopts `mlopts' showstep TECHnique(string) SHOWNRtolerance
	local mlopts `mlopts' ITERate(string) TOLerance(string)  
	local mlopts `mlopts' LTOLerance(string) GTOLerance(string) DIFficult 
	local mlopts `mlopts' NOCNSReport COEFLegend selegend
	local mlopts `mlopts' QTOLerance(string)
	local mlopts `mlopts' cformat(passthru)
	local mlopts `mlopts' sformat(passthru)
	local mlopts `mlopts' pformat(passthru)
	local mlopts `mlopts' nolstretch

	_parse expand model nlog: 0, common(`nlspec' `nlopts' `mlopts')
	if `model_n' == 1 {
		di as err "{p}no alternatives specified; see help " ///
		 "{help nlogit} for the proper syntax{p_end}"
		exit 198
	}

	/* container for hierarchy levels containing indepvars and level id */
	tempname levels leveli
	.`levels' = .null.new
	.`levels' .Declare array l
	local jconst = 0
	local constmsg1 "{p}{bf:estconst} cannot be specified more than "
	local constmsg1 `"`constmsg1'once{p_end}"'
	local constmsg2 "{p}must specify {bf:noconstant} if {bf:estconst} is "
	local constmsg2 `"`constmsg2'specified at lower levels of the "'
	local constmsg2 `"`constmsg2'hierarchy{p_end}"'
	local constmsg constmsg1

	forvalues i=1/`model_n' {
		local 0 `"`model_`i''"'
		local j = `i'-1
		if `i' == 1 {
			cap noi syntax varlist(min=1 numeric `fv') [if] [in] ///
				[fw pw iw]
			if _rc {
				di as err "{p}main equation that "   ///
				 "includes the dependent variable "  ///
				 "is improperly specified{p_end}"
				exit _rc
			}
			if "`weight'" != "" {
				/* programmer error	*/
				if "`wgt'" != "" {
					di as err "weights specified twice"
					exit 198
				}
				local wgt = `"[`weight'`exp']"'
				local wght = "`weight'"

				if "`weight'"=="pweight" {
					local wtml [iweight`exp']
					local _robust robust
				}
				else local wtml `wgt'
			}
			if "`altwise'"=="" & ("`if'`in'"!="" | _by()) {
				/* marksample using [if] [in] or by: only */
				tempvar uifin
				mark `uifin' `if' `in'
				local ifinopt ifin(`uifin')
			}
			marksample touse
			markout `touse' `varlist' 
			gettoken dep indep0 : varlist
			_fv_check_depvar `dep'
			local indep0 `"`:list retok indep0'"'
			local indep `"`indep0'"'
		}
		else {
			.`leveli' = .null.new
			.`leveli' .Declare string indepvar
			.`leveli' .Declare string altvar
			.`leveli' .Declare string base
			.`leveli' .Declare double const
			.`levels'.l[`j'] = .`leveli'.ref
			
			global NLOGIT_j = `j'
			ParseAltvar `0'

			.`leveli'.altvar = `"`s(before)'"'
			local 0 `s(after)'

			markout `touse' `.`leveli'.altvar', strok

			local hlevels `.`leveli'.altvar' `hlevels'
			if `i' == `model_n' {
				cap noi syntax [varlist(default=none   ///
					numeric `fv')] [, base(string) ///
					noCONstant]
				local constmsg constmsg2
				.`leveli'.const = ("`constant'"=="") 
			}
			else {
				cap noi syntax [varlist(default=none        ///
					numeric `fv')] [, base(string) ESTConst]
				.`leveli'.const = ("`estconst'"!="") 
			}
			if _rc { 
				di as err "equation `i' defining level " ///
				 "`j' is improperly specified"
				exit _rc
			}
			if `.`leveli'.const' {
				if `jconst' {
					di as err `"``constmsg''"'
					exit 184
				}
				local jconst = `j'
			}
			markout `touse' `varlist' 

			.`leveli'.indepvar = `"`varlist'"' 
			.`leveli'.base = "`base'"
			local indep `"`indep' `varlist'"'
			local dupsi: list dups indep 
			local dups `dups' `dupsi'
			local dups: list uniq dups

			/* release reference */
			classutil drop .`leveli'
		}
	}
	local nlev = `model_n'-1
	forvalues i=1/`nlev' {
		local altv `.`levels'.l[`i'].altvar'
		if `:list posof "`altv'" in indep' > 0 {
			di as err "{p}variable {bf:`altv'} is specified as " ///
			 "an alternatives variable and as an independent " ///
			 "variable; this is not allowed{p_end}"
			exit 198
		}
	}

	local 0 `nlog_if' `nlog_in', `nlog_op'
	syntax [if] [in], `nlspec' [`nlopts' *]

	if "`collinear'"=="" & "`dups'"!="" {
		local k : word count `dups'
		if `k' > 1 { 
			di as err `"{p}variables "`dups'" are "' _c
		}
		else di as err "{p}variable {bf:`dups'} is " _c 

		di as err "specified in more than one equation; " ///
		 "this is not allowed{p_end}"
		exit 198
	}
	if `"`if'`in'"' != "" {
		marksample touse2
		quietly replace `touse' = 0 if `touse2' == 0
		drop `touse2'
	}
	if ("`nonnormalized'"=="") local rum rum

	if `nlev' < 2 {
		dis as txt "{p}note: nonnested model, results are the " ///
		 "same as {help clogit}{p_end}"
	}
	_vce_parse, argopt(CLuster) opt(Robust oim) old: `wgt', `vce' ///
		`cluster' `robust'

	local cluster `r(cluster)'
	local robust `r(robust)'
	local vce `r(vce)'

	if "`robust'" != "" {
		local vce oim
		local robust robust
	}
	if ("`vce'"!="") local vceopt vce(`vce')

	_get_diopts diopts options, `options'
	mlopts mlopts, `options' 
	if ("`s(technique)'"=="") local tech technique(bfgs)
	else CheckTech, `s(technique)'

	if ("`level'"!="") local level level(`level')
	
	local prefix `c(prefix)' 
	local isloop : list posof "_loop" in prefix

	if (`"`cluster'"'!="") | ("`clustercheck'"!="" & !`isloop') {
		if "`cluster'" != "" {
			markout `touse' `cluster', strok
			local robust robust
			local cvar `cluster'
		}
		else {
			local cvar `clustercheck'
		}
	}
	else if ("`_robust'"!="") local robust robust

	if ("`robust'"!="") local crtopt crittype("log pseudolikelihood")

	cap count if `touse'
	if (r(N) == 0) error 2000

	tempname model
	if `caller' >= 16 {
		local cm cm
	}
	`vv' ///
	.`model' = ._nlogitmodel.new `dep' `indep0' `wgt', touse(`touse') ///
		levels(`levels') case(`case') `wtopt' `rum' `collinear'   ///
		`ifinopt' `altwise' `cm'

	if "`cvar'" != "" {
		/* make sure cluster is constant with case		*/
		.`model'._assertnovar `cvar', bylist(`case')
		if _rc==9 {
			di as err "{p}cases must be nested within clusters" ///
			 "{p_end}"
			exit 459
		}
	}

	if "`tree'"=="" & `nlev'>=2 {
		if ("`wght'"=="fweight") nlogittree `hlevels' if `touse' ///
			`wgt', choice(`dep') `label' `branches'
		else nlogittree `hlevels' if `touse', choice(`dep') `label' ///
			`branches'
	}
	if ("`debug'"!="") local trace trace

	/* flag to warn of rank deficient model		*/
	local warn = ("`trace'"!="")
	/* flag to compute test of IIA			*/
	local testiv = ("`robust'"=="")
	/* expected rank of the -clogit- model		*/
	local ncoef = `.`model'.kcoef, all'
	local ntau = `.`model'.kanc'
	CheckMatSize `=`ncoef'+`ntau''
	if "`from'"=="" | ("`constraints'"!=""&`testiv') { 
		tempname b
		if (!`warn') local nowarn nowarn

		.`model'.initest, b(`b') `trace' `nowarn'
		local initopt init(`b',copy)
		local collin = `r(collin)'
		if "`constraints'" != "" {
			tempname C
			ClogitCns `b', constraints(`constraints') ///
				ntau(`.`model'.kanc') `trace'

			if r(k) > 0 {
			   /* update expected rank of the -clogit- model  */
			   local ncoef = `ncoef' - r(k)
			   /* not all constraints on inclusive-value parm */
			   matrix `C' = r(C)
			   local copt constraints(`C')
			}
		}
	}
	if ("`constraints'"!="") ///
		local mlopts `mlopts' constraints(`constraints')
	if "`from'" != "" {
		local initopt init(`from')
		gettoken b rest: from, parse(", ")
	}

	if `testiv' {
		local clmodel `.`model'.clmodel'
		local case0 `.`model'.case.varname'

		if ("`trace'"!="") local cap cap noi
		else local cap cap

		`cap' clogit `clmodel' `wgt' if `touse', group(`case0') ///
			iter(50) `copt'
		local rc = _rc
		cap
		if `rc' == 503 {
			/* dropped a collinear variable in constraints */
			`cap' clogit `clmodel' `wgt' if `touse', ///
				group(`case0') iter(50) 
		}
		if `rc'!=0 | !e(converged) {
			di as txt "{p 0 6 2}note: {help clogit} model " ///
			 "failed; null likelihood is invalid{p_end}"
 
			local testiv = 0
		}
		else {
			/* null likelihood  */
			local ll_c = e(ll)
			local ll_0 = e(ll_0)
			local df_mc = e(df_m)
		}
		if `rc'==0 & `warn' & e(rank)<`ncoef' {
			/* can trip if using indicators in a level 	*/
			/* equation 					*/
			di as txt "{p 0 6 2}note: two or more of the " ///
			 "variables are collinear; convergence may "   ///
			 "not be achieved{p_end}"
		}
	}
	if !`testiv' {
		di as txt "{p 0 6 2}note: the LR test for IIA will not " ///
		 "be computed{p_end}"
	}
	else local testiv = (`nlev'>1)

	.`model'.droptvars, all
	local mlmodel `.`model'.mlmodel'
	global NLOGIT_model `model'

	if "`trace'" != "" {
		di _n `"mlmodel |`mlmodel'|"'
		mat li `b'
		di "mlopts   |`mlopts'|"
	}
	if ("`rum'"!="") local title RUM-consistent nested logit regression
	else local title Nonnormalized nested logit regression

	/* generate model score variables */
	.`model'.genscvar

	if "`debug'" == "" {
		`vv' ///
		ml model d1 nlogit_lf `mlmodel' `wtml' if `touse', `constr' ///
			`initopt' `tech' max miss noscvars `mlopts' ///
			`log' `nolog'  ///
			collinear search(off) `crtopt' title("`title'")     ///	
			waldtest(`.`model'.keq') `vceopt'
	}
	else {
		`vv' ///
		ml model d1debug nlogit_lf `mlmodel' `wtml' if `touse',     ///
			`constr' `initopt' trace noscvars gradient showstep ///
			max miss `mlopts' `crtopt' title("`title'")         ///
			search(off) waldtest(`.`model'.keq') collinear
	}
	if "`robust'" != "" {
		tempname b V
		mat `V' = e(V)
		mat `b' = e(b)
		if ("`cluster'"!="") local clopt cluster(`cluster')
		.`model'.robust, b(`b') v(`V') `clopt' 
	}
	else if `testiv' {
		if e(rank)-`df_mc' <= 0 {
			di as txt "{p 0 6 2}note: the rank of the "         ///
			 "{bf:nlogit} model is `=e(rank)' and the rank of " ///
			 "the {bf:clogit} model is `df_mc'; the LR test "   ///
			 "for IIA cannot not be computed{p_end}"
		}
		else {
			/* test for inclusive-value parms */
			ereturn scalar ll_c = `ll_c'
			local chi2_c = -2 * (`ll_c'-e(ll))
			ereturn scalar df_c = e(rank)-`df_mc'
			ereturn scalar chi2_c = `chi2_c'
			ereturn scalar p_c = chiprob(e(df_c), `chi2_c')
		}
	}
	if ("`wght'"=="pweight") ereturn local wtype "pweight"

	.`model'.eretpost

	signestimationsample `.`model'.dep' `.`model'.strvars, all' `case' ///
		`cluster'  
	
	if ("`altwise'" != "") {
		ereturn local marktype "altwise"
	}
	else {
		ereturn local marktype "casewise"
	}

	ereturn hidden local marginsmark "cm_margins_marksample"
	ereturn local k
	ereturn local k_dv
	ereturn local estat_cmd "nlogit_estat"
	ereturn local predict "nlogit_p"
	ereturn local iv_names "`name'"
	ereturn local marginsnotok _ALL
	ereturn local cmd "nlogit"
	if `"`ivcons'"' != "" {
		constraint drop `ivcons'
	}
	Replay, `level' `diopts'

	mac drop NLOGIT_*
end

program define Replay
	version 9.0
	syntax [, level(cilevel) *]

	_get_diopts diopts, `options'
	if ("`level'"!="") local level level(`level')

	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) +             ///
		bsubstr(`"`e(crittype)'"',2,.)
	di _n in gr `"`e(title)'"' _col(48) "Number of obs" _col(67) "= " ///
	 in ye %10.0gc e(N)
	di in gr `"Case variable: `=abbrev("`e(case)'",24)'"' _col(48) ///
	 "Number of cases" _col(67) "= " in ye %10.0g e(N_case) 

	local altvar `=abbrev("`e(altvar)'",17)'
	di in gr _n `"Alternative variable: `altvar'"' _col(48)           ///
	 "Alts per case: min = " in ye %10.0g e(alt_min) 
	if "`e(clustvar)'" != "" {
		di in gr `"Cluster variable: `=abbrev("`e(clustvar)'",24)'"' _c
	}
	di _col(63) in gr "avg = " in ye %10.1f e(alt_avg) _n _col(63)    ///
	 in gr "max = " in ye %10.0g e(alt_max) _n

	if "`e(chi2type)'" != "" {
		local stat chi2
        	local cfmt=cond(e(chi2)<1e+7,"%10.2f","%10.3e")
       		if e(chi2) >= . {
			local h help j_robustsingular:
			di in gr _col(51)                               ///
			 "{`h'`e(chi2type)' chi2(`e(df_m)'){col 67}= }" ///
			 in ye `cfmt' e(chi2)
       		}
        	else {
			di in gr _col(51) "`e(chi2type)' chi2(" in ye     ///
			 "`e(df_m)'" in gr ")" _col(67) "= " in ye `cfmt' ///
			 e(chi2)
       		}
	}
	else {
		/* F statistic from test after _robust */
		local stat F
		local cfmt=cond(e(F)<1e+7,"%10.2f","%10.3e")
		if e(F) < . {
			di in gr _col(51) "F(" in ye %3.0f e(df_m) in gr ///
			 "," in ye %6.0f e(df_r) in gr ")" _col(67) "= " ///
			 in ye `cfmt' e(F)
		}
		else {
			local dfm = e(df_m)
			local dfr = e(rank)
			local h help j_robustsingular:

			di in gr _col(51) "{`h'F( `dfm', `dfr')}" ///
			 _col(67) "{`h'=          .}"
		}
	}
	di in gr "`crtype' = " in ye %10.0g e(ll) _col(51) in gr ///
	 "Prob > `stat'" _col(67) "= "  in ye %10.4f e(p) _n

	_coef_table, cmdextras `level' `diopts'
	local robust = ("`e(vcetype)'"=="Robust")
	local nlv1 = e(levels)-1
	if `nlv1' > 0 {
		if !`robust' & e(df_c)<. {
			local chi : di %8.2f e(chi2_c)
			local chi = trim("`chi'")
			
			di as txt "LR test for IIA (tau=1): "		///
				"chi2(" as res e(df_c) as txt ") = "	///
				as res "`chi'" _col(59) as txt		///
				"Prob > chi2 = " as res %6.4f e(p_c)
		}
	}
	ml_footnote
end

program ClogitCns, rclass
	syntax name, constraints(string) ntau(integer) [ trace ]

	cap mat li `constraints'
	if _rc {
		cap numlist "`constraints'", sort
		if _rc {
			di as err "constraints must be a numlist, see "    ///
			 "{help constraint}, or a constraint matrix, see " ///
			 "{help makecns}"
			exit 198
		}
		local constraints `r(numlist)'
	}
	tempname T a C V b 

	mat `b' = `namelist'
	local n1 = colsof(`b')-`ntau'
	mat `V' = `b''*`b'

	ereturn post `b' `V'

	if ("`trace'"!="") makecns `constraints', r
	else makecns `constraints', nocnsnotes r

	if r(k) == 0 {
		di as err "all constraints are invalid" 
		exit 459
	}
	matcproc `T' `a' `C'

	if `ntau' == 0 {
		local nc = rowsof(`C')
		return scalar k = `nc'
		return matrix C = `C'
		exit
	}
	tempname c d D
	/* drop inclusive-valued parameters */
	mat `D' = `C'[1...,1..`n1']
	mat `d' = trace(`D'*`D'')
	if `d'[1,1] == 0 {
		return scalar k = 0
		exit 
	}
	mat `d' = vecdiag(`D'*`D'')
	local n2 = colsof(`C')
	mat `D' = (`D',`C'[1...,`n2'])
	local nc = rowsof(`D')
	cap mat drop `C'
	forvalues i=1/`nc' {
		if `d'[1,`i'] > 0 {
			mat `C' = (nullmat(`C') \ `D'[`i',1...])
		}
	}
	return scalar k = rowsof(`C')
	return matrix C = `C'
end

program CheckTech
	syntax, [ technique(string) ]

	while "`technique'" != "" {
		gettoken tok technique : technique
		if "`tok'" == "bhhh" {
			di as err "option {bf:technique(bhhh)} is not allowed"
			exit 198
		}
	}
end

program ChkVCE, rclass
	syntax, [ VCE(string) ]

	gettoken vce rest : vce, parse(", ")

	if "`vce'" == "opg" {
		di as err "option {bf:vce(opg)} is not allowed"
		exit 198
	}
	return local vce `vce'
end

program VceParseRun, eclass byable(onecall)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	version 10

	if _by() {
		local by `"by `_byvars'`_byrc0':"'
	}
 
	local cmnopt VCE(string) Cluster(varname) case(varname) Level(string)
	_parse expand mod vce: 0, common(`cmnopt')
	
	local 0, `vce_op'
	qui syntax, case(varname) [ Cluster(varname) VCE(passthru) ///
		Level(string) CLUSTERCHECK(varname) ]

	if `:length local level' {
		local level level(`level')
	}

	global NLOGIT_exit = 0
	if (`"`vce'"'=="") exit
		
	ChkVCE, `vce'
	local vtype `r(vce)'
	local lt = strlen("`vtype'")
	local vtype = bsubstr("`vtype'",1,min(`lt',4))

	local case0 "`case'"
	tempname id
	_vce_cluster nlogit,		///
		groupvar(`case')	///
		newgroupvar(`id')	///
		groptname(case)		///
		`vce'			///
		cluster(`cluster')
	local vce `"`s(vce)'"'
	local idopt `s(idopt)'
	local clopt `s(clopt)'
	local gropt `s(gropt)'
	local bsgropt `s(bsgropt)'

	if "`s(cluster)'" != "" {
		local ccheckopt clustercheck(`s(cluster)')
	}

	local numdepvars 1
	local model `"(`mod_1')"'
	local 0 `"`mod_1'"'
	cap noi syntax varlist(min=1 numeric `fv') [if] [in] [fw pw iw]
	if _rc {
		di as err "{p}main equation that includes the dependent " ///
		 "variable is improperly specified{p_end}"
		exit _rc
	}
	forvalues i=2/`mod_n' {
		ParseAltvar `mod_`i''
		local 0 `s(after)'
		local numdepvars `numdepvars' 0
		if `i' < `mod_n' {
			cap noi syntax [varlist(default=none numeric `fv')] ///
				[, base(string) ESTConst ]
			local model `"`model' (`mod_`i'')"'
			local const estconst
			local cval `const'
		}
		else {
			cap noi syntax [varlist(default=none numeric `fv')] ///
				[, base(string) noCONstant * ]
			local m_n (`mod_`mod_n''), `gropt' `vce' `level'
			local model `"`model' `m_n'"'
			local const constant
			local cval
		}
		if _rc { 
			di as err "equation `i' defining level `=`i'-1' is " ///
			 "improperly specified"
			exit _rc
		}

		// NOTE: see _vce_parserun.ado for some of the undocumented
		// abbreviations for -bootstrap- and -jackknife-
		if inlist("`vtype'", ///
				"boot","bs","bst","bstr" ///
				,"jack","jk","jkn","jkni") {
			/* make sure model is fully specified */
			global NLOGIT_j = `i'-1
			local const = ("``const''"=="`cval'")

			/* don't want base to change with each 	*/
			/*  resample 				*/
			if ("`varlist'"!="" | `const') & "`base'"=="" {
				if ("`vtype'"=="boot") ///
					local vtype bootstrap
				else local vtype jackknife

				di as err "{p}{bf:vce(`vtype')} requires " ///
				 "{bf:base()} to be explicitly specified " ///
				 "for each level equation containing "     ///
				 "covariates or constant terms{p_end}"
				exit 198
			}
		}
	}
	local vceopts jkopts(`clopt' notable noheader)               ///
		bootopts(`clopt' `idopt' `bsgropt' notable noheader) ///
		numdepvars(`numdepvars') ignorenocons

	`vv' `by' _vce_parserun nlogit, `vceopts' : `model' `ccheckopt'
	if "`s(exit)'" != "" {
		ereturn local case `case'
		ereturn local clustvar `cluster'
		if "`cluster'" == "" {
			local cmd1 `"`e(command)'"'
			local cmd2 : subinstr local cmd1 "`id'" ///
					"`case'"
			ereturn local command `"`cmd2'"'
		}
		if ! `:length local level' {
			local level "level(`s(level)')"
		}
		Replay, `level'
		global NLOGIT_exit = 1
	}
end

program ParseAltvar, sclass

	cap _on_colon_parse `0'
	
	if _rc | "`s(before)'"=="" {
		di as err "{p}alternatives variable defining level " ///
		 "$NLOGIT_j of the hierarchy is improperly specified{p_end}"
		exit 198
	}
	local n : word count `s(before)'
	if `n' > 1 {
		di as err "{p}there are `n' alternative variables " ///
		 "specified for level $NLOGIT_j; this is not allowed{p_end}"
		exit 198
	}
	cap confirm variable `s(before)'
	if _rc {
		di as err "{p}level $NLOGIT_j alternative variable " ///
		 "`s(before)' not found{p_end}" 
		exit 111
	}
end

program CheckMatSize
	args np

	if `np' > c(max_matdim) {
		error 915
	}
end

exit
