*! version 1.4.0  16mar2018
* exlogistic - exact logistic regression

program exlogistic, eclass byable(onecall) 
	version 10

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun exlogistic : `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"exlogistic `0'"'
		exit
	}
	if replay() {
		if `"`e(cmd)'"' != "exlogistic" error 301
		_exactreg_replay `0'
		exit
	}
	cap noi `BY' Estimate `0'
	local rc = _rc
	ereturn local cmdline `"exlogistic `0'"'
	macro drop EXREG_*
	exit `rc'
end

program Estimate, eclass byable(recall)
	syntax varlist(min=1 numeric) [if] [in] [fw], [ CONDvars(string)  ///
		GRoup(varname numeric) ESTConstant noCONStant MUE(string) ///
		BINomial(string) Level(cilevel) TERMs(passthru) NOLOg LOg ///
		SAVing(string) eps(string) midp noSORT coef	 	  ///
		Test(string) MEMory(passthru) COLlinear trace ]

	/* options eps, nosort, trace, and collinear are not documented	*/
	/* eps       	changes the number of significant digits used	*/
	/*  		 floating point comparisons			*/
	/* nosort	prevents sorting conditioned variables; this 	*/
	/* 		 will create a different enumeration path	*/
	/* trace	shows -ml- computation of CMLE and conditional 	*/
	/*		 scores/probabilities computations		*/
	/* collinear    do not call _rmcoll and _rmdcoll; used for 	*/
	/* 		 testing  					*/

	CheckDups `varlist', arg(the varlist)

	local level level(`level')

	tokenize `varlist'
	local y `1'
	macro shift
	local X `*'

	ParseTest, `test'
	local test `s(test)'

	if "`saving'" != "" {
		ParseSaving `saving'
		local saving `s(saving)'
		local replace `s(replace)'
		if ("`replace'" == "") confirm new file "`saving'"
		local saveopt saving(`saving')
	}
	if "`terms'" != "" {
		CheckTerms `X', `terms'
		local X `s(varlist)'

		if "`test'" == "sufficient" {
			di as txt "{p 0 6 2}note: P-values cannot be "    ///
			 "computed for the joint tests of the terms() "   ///
			 "option using the default method of sufficient " ///
			 "statistics; to obtain p-values replay with "    ///
			 "either test(score) or test(probability){p_end}"
		}
        }
	tempname feps
	if "`eps'" != "" {
		cap scalar `feps' = `eps'
		if _rc {
			di as err "{p}invalid eps = `eps'; eps must be " ///
			 "greater than 0 and less than 1{p_end}"
			exit 198
		}
		else if `feps'<0 | `feps'>=1 {
			/* we actually allow eps = 0.0 which	*/
			/*  means eps <= c(epsdouble) 		*/
			di as err "eps = `eps' must be greater than or " ///
			 "equal to 0 and less than 1"
			exit 198
		}
	}
	if "`constant'"!="" & "`estconstant'"!="" {
		di as err "{p}options noconstant and estconstant may " ///
		 "not be combined{p_end}"
		exit 184
	}
	if ("`constant'"!=""|"`estconstant'"!="") & "`group'" != "" {
		di as err "{p}options group() and `constant'" ///
		 "`estconstant' may not be combined{p_end}"
		exit 184
	}

	local bcondv = ("`condvars'"!="")
	local bcons = 0
	if `bcondv' {
		local condvars : subinstr local condvars "_cons" "", ///
			word count(local bcons)

		local bcondv = ("`condvars'"!="")
	}
	if `bcons' {
		if "`constant'"!="" | "`estconstant'"!="" {
			di as err "options condvars(_cons) and "  ///
			 "`constant'`estconstant' may not be combined"
			exit 184
		}
		if "`group'" != "" {
			di in gr "{p}note: group(" abbrev("`group'",12) ///
			 ") implies condvars(_cons){p_end}" 
		}
		local ccopt condcons
	}

	marksample touse

	if "`group'" != "" {
		markout `touse' `group'
		local gropt group(`group')
	}
	if `bcondv' {	
		cap CheckVarlist `condvars'
		if _rc {
			/* string variable				*/
			if (_rc == 109) CheckVarlist `condvars'
			/* general parsing error			*/
			di as err "{p}invalid varlist in condvars(): " ///
			 "`condvars'{p_end}"    
			exit 198
		}
		CheckDups `condvars', arg(condvars())
		foreach cv of local condvars {
			unab cv : `cv'
			if `:list posof "`cv'" in X' {
 				di as err "{p}condvars() cannot contain " ///
				 "independent variables specified in "    ///
				 "indepvars; `cv' violates this{p_end}"
				exit 498
			}
			if "`cv'" == "`y'" {
 				di as err "{p}condvars() cannot contain " ///
				 "the dependent variable{p_end}"
				exit 498
			}
			local condv `condv' `cv'
		}
		local condvars `condv'
		local condopt condvars(`condvars')
		markout `touse' `condvars'
	}
	if "`binomial'" != "" {
		cap confirm variable `binomial'
		if _rc == 0 {
			cap confirm numeric variable `binomial'
			if _rc {
				di as err "{p}binomial() must specify a " ///
				 "numeric variable or an integer scalar{p_end}"
				exit 198
			}
			markout `touse' `binomial'
		}
		local binopt binomial(`binomial')
	}
	
	if ("`constant'"=="" & "`estconstant'"=="" & "`ccopt'"=="") ///
		local ccopt condcons

	if "`mue'"!="" {
		if ("`mue'"=="_all") local mueopt mue(_all)
		else {
			CheckMUE `X', mue(`mue')
			local mueopt mue(`s(mue)')
		}
	}

	local X0 `X'

	if "`estconstant'" != "" {
		tempvar cons

		gen byte `cons' = 1
		local X0 `X0' `cons'
		local constopt constvar(`cons')
	}
	if `:word count `X0'' == 0 {
		di as err "{p}too few variables specified; no independent " ///
		 "variables or constant term{p_end}"
		exit 102
	}
	if "`saving'" != "" {
		foreach x of varlist `X0' {
			if "`x'" == "_f_" {
				di as err "{p}cannot have a variable " ///
				 "named _f_ when using the saving() "  ///
				 "option{p_end}"
				exit 184
			}
			if ("`cons'"!="" & "`x'"=="_cons_") {
				di as err "{p}cannot have a variable " ///
				 "named _cons_ with the estconst and " ///
				 "saving() options{p_end}"
				exit 184
			}
		}
	}

	local bfloat = 0
	foreach x of varlist `X0' `condvars' {
		local type : type  `x'
		if "`type'" == "float" {
			local bfloat = 1
			continue, break
		}
	}
	if `bfloat' {
		if ("`eps'" == "") scalar `feps' = 1.0e-5
		if `feps' < 10*c(epsfloat) {
			di as text "{p 0 6 2}note: eps = " `feps'      ///
			 " < 10*c(epsfloat) and at least one of your " ///
			 "variables is of type float{p_end}"
		}
	}
	else {
		if ("`eps'" == "") scalar `feps' = 1.0e-10
		if `feps' < 10*c(epsdouble) {
			di as text "{p 0 6 2}note: eps = " `feps' ///
			 " < 10*c(epsdouble){p_end}"
		}
	}

	E1timate `y' `X0' [`weight'`exp'] if `touse', eps(`feps')    ///
		`condopt' `gropt' `ccopt' `constopt' `constant'	     ///
		`terms' `saveopt' `midp' `mueopt' `level' `binopt'   ///
		`sort' `trace' `memory' `log' `nolog' `collinear'
	
	ereturn repost, esample(`touse') 

	signestimationsample `e(depvar)' `e(indvars)' `e(condvars)' ///
		`e(binomial)'

	ereturn local title  "Exact logistic regression"
	ereturn local estat_cmd exlogistic_estat
	ereturn local marginsnotok _ALL
	ereturn hidden local predict _exactreg_p
	ereturn local cmd exlogistic

	_exactreg_replay, test(`test') `coef'
end

program E1timate, eclass 
	syntax varlist [fw] [if], eps(name) [ condvars(varlist)        ///
		group(varname) condcons constvar(varname) noCONSTant   ///
		saving(string) midp mue(string) terms(string) 	       ///
		BINOMial(string) level(passthru) noSORT MEMory(string) ///
		collinear trace NOLOg LOg ]

	tokenize `varlist'
	local y `1'
	macro shift
	local X `*'

	if "`memory'" != "" {
		_parsememsize "`memory'" 
		local memopt memory(`s(size)')
	}
	/* preserve e(sample) to be reposted on return */
	preserve
	qui keep `if'
	if (_N == 0) error 2000

	if "`group'" != "" {
		cap assert float(`group')==float(floor(`group')) 
		if _rc != 0 {
			di as err "{p}group() variable `group' must be " ///
			 "coded as integers{p_end}"
			exit 459 
		}
		tempvar mark
		sort `group', stable
		qui by `group': gen byte `mark' = (_n==1)  
		summarize `mark', meanonly
		local kgroups = r(sum)
		if `kgroups' == 1 {
			di as err "there is only one group in your data"
			exit 459
		}
		if c(max_matdim) < `kgroups' {
			error 915
		}
		qui drop `mark'
		
		local X0
		foreach x of varlist `X' {
			cap by `group': assert(float(`x')==float(`x'[1]))
			if _rc == 0 {
				di as txt "note: `x' dropped because it " ///
				 "is constant within groups"
			}
			else local X0 `X0' `x'
		}
		local X `X0'
		local gropt group(`group')
	}
	else  local kgroups = 1

	if "`collinear'" == "" {
		if ("`constvar'"!="") local X0 : list X - constvar
		else local X0 `X'
	
		local mn = cond("`binomial'"=="",0,1)
		local nx : word count `X0'
		if _N>`mn' & `nx'+`:word count `condvars''>0 {
			_rmcollright `X0' `condvars', `constant'
			local vlist `r(varlist)'
			local X0 : list X0 & vlist
			if "`condvars'" != "" {
				local condvars : list condvars & vlist
			}
			local X `X0'
			if ("`constvar'"!="" & "`condcons'"=="") ///
				local X `X' `constvar'
		}
		if "`X'" == "" {
			di as err "no independent variables remain after " ///
			 "dropping collinear variables"
			exit 459
		}
		if "`terms'"!="" & `:word count `X0''<`nx' {
			/* rconstruct the model terms	*/
			_parse_terms `X0', termvars(`terms') drop
			local terms `s(termlist)'
        	}
	}
	if ("`terms'"!="") local terms terms(`terms')
	if "`condvars'" != "" {
		local condopt condvars(`condvars')
		local X1 `X' `condvars'
	}
	else local X1 `X'

	if "`weight'" != "" {
		tempvar wt
		gen long `wt'`exp'
		local exwgt `weight'
		local wexp "=`wt'"
		local wopt weight(`wt')
	}

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`binomial'" != "" {
		if "`weight'" == "" {
			tempvar wt
			gen long `wt' = 1
			local exwgt fweight
			local wexp "=`wt'"
			local wopt weight(`wt')
		}
		_binomial2bernoulli `y', fw(`wt') binomial(`binomial')
		local binomtype `r(binom_type)'
	}
	else {
		*maybe a bug, `nolog' is not used
		if ("`trace'"=="") local nolog nolog
		_float2binary `y' `wt', nolog 
		cap assert `y' == `y'[1]
		if _rc==0 & "`constvar'"=="" {
			if "`s(converted)'" != "" {
				local conv " after converting it to binary"
			}
			local val = `y'[1]
			di as err `"{p}dependent variable is all `val''"' ///
			 "s`conv'; the conditional distribution is "      ///
			 "degenerate{p_end}"
			exit 459
		}
	}
	if ("`sort'"=="") _exactreg_sort `condvars', `wopt' `gropt' `dopt'

	tempname b0 se0
	mat `b0' = J(1,`: word count `X'',0)
	mat `se0' = J(1,`: word count `X'',0)
	mat colnames `b0' = `X'
	mat colnames `se0' = `X'

	InitEst `y' `X1' [`exwgt'`wexp'], `gropt' `constant' ///
		kgroups(`kgroups') `trace'
	if _rc == 0 {
		local bnames : colnames e(b)
		tempname bk
		forvalues k=1/`:word count `X'' {
			local x : word `k' of `X'
			if ("`x'"=="`cons'") local x _cons
			cap scalar `bk' = _b[`x']
			if _rc == 0 {
				mat `b0'[1,`k'] = `bk'
				mat `se0'[1,`k'] = _se[`x']
			}
		}
	}

	if ("`mue'" != "") local mueopt mue(`mue')
	if ("`constvar'" != "") local constopt constant(`constvar')
	tempvar f
	return clear

	_exact_msa `y' `X1' [`exwgt'`wexp'], f(`f') eps(`eps') `condopt' ///
		`gropt' `condcons' `memopt' `log'

	if _N == 1 {
		di as err "{p}only one observation in the conditional " ///
		 "distribution{p_end}"
		exit 2000
	}

	tempname yx yx0 n sy N scale
	scalar `n' = r(n)
	scalar `N' = r(N)
	scalar `scale' = r(scale)
	mat `yx' = r(yx)	
	scalar `sy' = r(sy)
	if "`group'" != "" {
		tempname gn gsy
		mat `gn' = r(gn)
		mat `gsy' = r(gsy)
	} 

	mat `yx0' = `yx'[1,1..`:word count `X'']

	format `f' %15.0g
	if ("`saving'" != "") ///
		Save `X', f(`f') saving("`saving'") `constopt' 

	tempname b se ci imue pyx prob pprob pscore score nterms

	/* compute each estimate conditional on all others 	*/
	_exactreg_coef `X', f(`f') yx(`yx0') b0(`b0') se0(`se0') `mueopt' ///
		eps(`eps') `level' `constopt' `midp' `trace'
	mat `b' = r(b)
	mat `se' = r(se)
	mat `ci' = r(ci)
	mat `pyx' = r(p)
	mat `imue' = r(imue)
	local level = `r(level)'

	local modtest = 0
	scalar `nterms' = 0
	tempname mprob mpprob mpscore mscore

	if "`terms'" != "" {
		_exactreg_tests `X', f(`f') yx(`yx0') eps(`eps') `terms' ///
			`midp' `constopt' `trace'
		mat `mprob' = r(prob)
		mat `mpprob' = r(pprob)
		mat `mscore' = r(scores)
		mat `mpscore' = r(pscores)
		scalar `nterms' = colsof(`mpprob')

		local termlabels `"`r(terms)'"'
		local stripe `"`r(stripe)'"'
		mat colnames `b' = `stripe'
		mat colnames `ci' = `stripe'
		mat colnames `se' = `stripe'
		mat colnames `imue' = `stripe'
		mat colnames `pyx' = `stripe'
	}
	if "`condvars'"=="" & "`X'"!="`constvar'" {
		if "`constvar'" != "" { 
			local X0: list X - constvar
			local modopt terms(model=`X0')
		}
		else local modopt terms(model=`X')

		_exactreg_tests `X', f(`f') yx(`yx0') eps(`eps') `modopt' ///
			`midp' `constopt' `trace'

		mat `mprob' = (nullmat(`mprob'),r(prob))
		mat `mpprob' = (nullmat(`mpprob'),r(pprob))
		mat `mscore' = (nullmat(`mscore'),r(scores))
		mat `mpscore' = (nullmat(`mpscore'),r(pscores))
		local modtest = 1
	}
	_exactreg_tests `X', f(`f') yx(`yx0') eps(`eps') `midp' `constopt' ///
		`trace' 

	mat `prob' = r(prob)
	mat `pprob' = r(pprob)
	mat `score' = r(scores)
	mat `pscore' = r(pscores)
	if "`stripe'" != "" {
		mat colnames `pprob' = `stripe'
		mat colnames `prob' = `stripe'
		mat colnames `score' = `stripe'
		mat colnames `pscore' = `stripe'
	}
	local bv = 0
	forvalues i=1/`:word count `X'' {
		local bv = (`bv' | `se'[1,`i']<.)
	}
	local bnames
	if "`constvar'" != "" {
		local names: colnames(`b')
		local cnames: coleq(`b')
		local bnames: subinstr local names "`constvar'" "_cons"
		foreach est in b se yx imue ci pprob pscore score prob pyx {
			mat colnames ``est'' = `bnames'
			mat coleq ``est'' = `cnames' 
		}
	}
	ereturn post `b', obs(`=`N'') 
	if (`bv') ereturn matrix se = `se'
	ereturn matrix ci = `ci'
	ereturn matrix p_sufficient = `pyx'
	ereturn matrix p_probtest = `pprob'
	ereturn matrix p_scoretest = `pscore'
	ereturn matrix probtest = `prob'
	ereturn matrix scoretest = `score'
	ereturn matrix mue_indicators = `imue'
	ereturn matrix sufficient = `yx'
	if (`scale' < .) ereturn scalar scale = `scale'
	ereturn scalar n_possible = `n'
	ereturn scalar sum_y = `sy'
	ereturn scalar k_terms = `nterms'
	if (`nterms' > 0) ereturn local terms `"`termlabels'"'
	if `nterms' + `modtest' > 0 {
		ereturn matrix probtest_m = `mprob'
		ereturn matrix p_probtest_m = `mpprob'
		ereturn matrix p_scoretest_m = `mpscore'
		ereturn matrix scoretest_m = `mscore'
	}
	if `kgroups' > 1 {
		ereturn local groupvar `group'
		ereturn matrix N_g = `gn'
		ereturn matrix sum_y_groups = `gsy'
	}
	local level = round(`level',.01)
	ereturn local level = bsubstr("`level'",1,5)
	if "`condvars'" != "" {
		ereturn scalar k_condvars = `:word count `condvars''
		ereturn local condvars `"`condvars'"'
	}
	else ereturn scalar k_condvars = 0

	if ("`constvar'"!="") local X : list X - constvar
	ereturn scalar k_indvars = `:word count `X''
	ereturn local depvar "`y'"
	ereturn local indvars `"`X'"'

	if ("`condcons'"!="" | `kgroups'>1) ereturn scalar condcons = 1
	else ereturn scalar condcons = 0

	ereturn scalar midp = ("`midp'"!="")

	ereturn scalar k_groups = `kgroups'
	ereturn scalar eps = `eps'

	if "`binomial'" != "" {
		if "`binomtype'" == "variable" { 
			restore
			unab binomial: `binomial'
			ereturn local binomial  `binomial'
		}
		else ereturn scalar n_trials = `binomial'
	}

	if "`weight'" != "" {
		ereturn local wexp "`exp'"
		ereturn local wtype "`weight'"
	}
end

program ParseTest, sclass
	cap syntax, [ SUFFicient score Probability ]

	if _rc {
		di as err "test() must be one of score, " ///
		 "probability, or sufficient (statistic)"
		exit 198
	}
	local wc : word count `sufficient' `score' `probability'

	if `wc' > 1 {
		di as err "test() must be one of score, " ///
		 "probability, or sufficient (statistic)"
		exit 198
	}

	if (`wc'==0) sreturn local test sufficient
	else sreturn local test `sufficient'`score'`probability'
end

program InitEst, eclass
	syntax varlist [fw], [ f(varname) group(varname) ///
		kgroups(integer 1) noconstant trace ]

	if ("`trace'" != "") local cap cap noi
	else local cap cap
	
	if "`group'" != "" {
		if "`weight'" != "" {
			/* -clogit- requires weights to be constant 	*/
			/* within group so expand data			*/
			preserve
			tempvar fwt 
			qui gen long `fwt'`exp'
			qui expand `fwt'
		}
		`cap' clogit `varlist', iter(10) group(`group')
	}
	else `cap' logit `varlist' [`weight'`exp'], iter(10) `constant'

	if (_rc) ereturn post
end

program CheckTerms, sclass
	syntax varlist, terms(string) 

        _parse_terms `varlist', termvars(`terms') 
	local nind `s(nind)'
	local ind `s(ind)'
	/* reorder variables so that they are grouped by terms */
	local i = 1
	foreach ng of numlist `nind' {
		forvalues j = `i'/`=`i'+`ng'-1' {
			local k: word `j' of `ind'
			local x: word `k' of `varlist'
			/* make sure variable not in same term */
			if "`X'" != "" {
				if `:list posof "`x'" in X' > 0 {
					di as err "variable `x' is in " ///
					 "terms() more than once"
					exit 198
				}
			}
			local X `X' `x' 
		}
		local i = `i' + `ng'
	}
	local varlist `s(varlist)'
	sreturn local varlist `varlist'
end

program CheckMUE, sclass
	syntax varlist, MUE(varlist)

	local notvar: list mue - varlist
	local wc : word count `notvar'
	if `wc' > 0{
		di as err "{p}mue() specification invalid; `notvar' " _c
		if (`wc'==1) di as err "is not an independent variable{p_end}"
		else di as err "are not independent variables{p_end}" 

		exit 198
	}
	sreturn local mue `"`mue'"'
end

program CheckDups
	syntax [anything], arg(string)

	if ("`anything'" == "") exit

	local dups : list dups anything
	local wc : word count `dups'
	if `wc' == 1 { 
		di as err "variable `dups' is repeated more than once " ///
		 "in `arg'"
		exit 198
	}
	else if `wc' > 1 {
		di as err "variables `dups' are repeated more than once " ///
		 "in `arg'"
		exit 198
	}
end

program Save 
	syntax varlist, f(varname) saving(string) [, constant(varname) ///
		log]

	preserve

	rename `f' _f_
	keep `varlist' _f_ 
	sort `varlist' 
	
	local k: list posof "`constant'" in varlist
	if (`k' > 0) rename `constant' _cons_

	if ("`log'"=="") ///
		di in gr "{p}note: saving distribution to file `saving'{p_end}"
	qui save `saving', replace
end

program ParseSaving, sclass
	cap syntax anything, [ replace ]
	if _rc {
		di as err "invalid saving() specification; " _c
		syntax anything, [ replace ]
	}
	if `:word count `anything'' != 1 {
		di as err "invalid saving() specification; `anything'"
		exit 198
	}
	/* ensure .dta suffix if there is no explicit suffix 	*/
	local k = 0
	local saving `anything'
	while "`saving'" != "" {
		gettoken pre rest: saving, parse(".")
		if ("`rest'"!="") {
			local `++k'
		}
		local file `file'`pre'
		local saving `rest'
	}
	if (`k'==0) local file `file'.dta

	sreturn local saving `"`file'"'
	sreturn local replace `replace'
end

program CheckVarlist
	syntax varlist(numeric)
end

exit
