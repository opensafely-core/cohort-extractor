*! version 1.4.0  14mar2018
* expoisson - exact poisson regression

program expoisson, eclass byable(onecall) 
	version 10

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if replay() {
		if `"`e(cmd)'"' != "expoisson" error 301
		_exactreg_replay `0'
		exit
	}
	cap noi `BY' Estimate `0'
	local rc = _rc
	ereturn local cmdline `"expoisson `0'"'
	macro drop EXREG_*
	exit `rc'
end

program Estimate, eclass byable(recall)
	syntax varlist(min=2 numeric) [fw] [if] [in], [                  ///
		CONDvars(varlist numeric) GRoup(varname numeric)         ///
		MUE(string) Level(cilevel) IRR Exposure(varname numeric) ///
		OFFset(varname numeric) NOLOg LOg SAVing(string) midp    ///
		eps(string) noSORT Test(string) MEMory(passthru)         ///
		BLOCKsize(passthru) COLlinear trace noSCALE ]

	/* options eps, nosort, trace, and collinear are not documented */
	/* blocksize    controls the size of size of the memory blocks	*/
	/*		 1000<= blocksize<=100000; default is 1000	*/
	/* eps       	changes the number of significant digits used	*/
	/*  		 floating point comparisons			*/
	/* nosort	prevents sorting conditioned variables; this 	*/
	/* 		 will create a different enumeration path	*/
	/* trace	shows -ml- computation of CMLE and conditional 	*/
	/*		 scores/probabilities computations		*/
	/* collinear    do not call _rmcoll; used for testing		*/
	/* noscale	do not scale exposure/offeset variable		*/

	ParseTest, `test'
	local tstopt test(`s(test)')

	CheckDups `varlist', arg(the varlist)

	tokenize `varlist'
	local y `1'
	macro shift
	local X `*'

	local level level(`level')

	if "`saving'" != "" {
		ParseSaving `saving'
		local saving `s(saving)'
		local replace `s(replace)'
	}
	tempname feps
	if "`eps'" != "" {
		cap scalar `feps' = `eps'
		if _rc {
			di as err "{p}invalid eps = `eps'; eps must be " ///
			 "a scalar greater than 0 and less than 1{p_end}"
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
	marksample touse
	if "`group'" != "" {
		markout `touse' `group'
		local gropt group(`group')
	}
	if "`condvars'" != "" {	
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
	if ("`weight'"!="") local wgts [`weight'`exp']

	if "`offset'"!="" | "`exposure'"!="" {
		if `:word count `offset' `exposure'' == 2 {
			di as err "{p}options exposure() and offset() " ///
			 "cannot be combined{p_end}"
			exit 184
		}
		markout `touse' `exposure' `offset'
		tempvar expo
		/* scale the exposure variable to prevent overflow	*/
		if "`exposure'" != "" {
			cap assert `exposure' > 0  if `touse'
			if _rc {
				di as err "exposure() variable must have " ///
				 "positive values"
				exit 459
			}
			if "`scale'" != "" {
				qui gen double `expo' = `exposure'
			}
			else {
				qui gen double `expo' = log(`exposure')
				summarize `expo' `wgts' if `touse', meanonly
				qui replace `expo' = exp(`expo'-r(mean))
			}
		}
		else if "`scale'" != "" {
			tempvar check
			qui gen double `expo' = exp(`offset') if `touse'
			qui gen byte `check' = (`expo'>=.) if `touse'
			summarize `check' if `touse', meanonly
			if r(sum) > 0 {
				di as err "one or more offset() values are " ///
				 "too large"
				exit 459
			}
			qui drop `check'
		}
		else {
			summarize `offset' `wgts' if `touse', meanonly
			qui gen double `expo' = exp(`offset'-r(mean)) if `touse'
		}
		local exopt exposure(`expo')
	}
	qui count if `touse'
	if (r(N)==0) error 2000
	if ("`wgts'"!="") summarize `touse' `wgts', meanonly
	if (r(N)==1) error 2001

	if "`mue'"!="" {
		if ("`mue'"=="_all") local mueopt mue(_all)
		else {
			CheckMUE `X', mue(`mue')
			local mueopt mue(`s(mue)')
		}
	}
	if "`saving'" != "" {
		foreach x of varlist `X' {
			if "`x'" == "_w_" {
				di as err "{p}cannot have a variable " ///
				 "named _w_ when using the saving() "  ///
				 "option{p_end}"
				exit 184
			}
			if ("`replace'"=="") confirm new file "`saving'_`x'.dta"
		}
		local saveopt saving(`saving')
	}

	local bfloat = 0
	foreach x of varlist `X' `condvars' {
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
	E1timate `y' `X' `wgts' if `touse', eps(`feps')          ///
		`condopt' `gropt' `ccopt'  `terms' `saveopt'     ///
		`midp' `mueopt' `level' `exopt' `sort' `trace'   ///
		`blocksize' `memory' `log' `nolog' `collinear'
	
	ereturn repost, esample(`touse') 

	if "`offset'" != "" {
		local exposure
		ereturn local offset `offset'
	}
	else if ("`exposure'"!="") ereturn local exposure `exposure'

	signestimationsample `e(depvar)' `e(indvars)' `e(condvars)' ///
		`offset' `exposure'

	ereturn local title  "Exact Poisson regression"
	ereturn local estat_cmd expoisson_estat
	ereturn local marginsnotok _ALL
	ereturn hidden local predict _exactreg_p
	ereturn local cmd expoisson

	_exactreg_replay, `tstopt' `irr'
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

program E1timate, eclass 
	syntax varlist [fw] [if], eps(name) [ condvars(varlist)            ///
		group(varname) saving(string) midp mue(string)             ///
		terms(string) exposure(passthru) level(passthru) IRR       ///
		noSORT MEMory(string) collinear trace BLOCKsize(integer 0) ///
		NOLOg LOg ]

	tokenize `varlist'
	local y0 `1'
	macro shift
	local X `*'

	if "`memory'" != "" {
		_parsememsize "`memory'" 
		local memopt memory(`s(size)')
	}
	else local memopt memory(26214400)
	/* memory block size						*/
	if (`blocksize'>=1024) local blkopt blocksize(`blocksize')

	if ("`weight'"!="") {
		/* create fweight variable before preserve		*/
		tempvar wt
		gen long `wt'`exp'

		local wts [`weight'`exp']
	}
	tempvar y w
	qui count `if' & (trunc(`y0')!=`y0')
	local rc = (r(N)>0)
	if !`rc' {
		qui gen long `y' = `y0'
		summarize `y', meanonly
		local rc = (r(min) < 0)
	}
	if `rc' {
		di as err "{p}dependent variable must contain " ///
		 "nonnegative integers{p_end}"
		exit 459
	}
	/* preserve e(sample) to be posted on return 			*/
	preserve	
	qui keep `if'
	tempname mxcnt
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
		qui by `group': gen long `mark' = sum(`y')
		summarize `mark' `wgts', meanonly
		scalar `mxcnt' = r(max)
		if `mxcnt' > 0 {
			qui by `group': replace `mark' = 0 if _n < _N
			qui by `group': replace `mark' = (`mark'[_N]==0) /// 
				if _n == _N
			qui count if `mark'
			if (r(N) > 0) di as txt "{p 0 7 2}note: no events " ///
				"occurred in `=r(N)' groups{p_end}"
		}
		qui drop `mark'
		local gropt group(`group')
	}
	else {
		local kgroups = 1
		summarize `y' `wgts', meanonly
		scalar `mxcnt' = r(sum)
	}
	if `mxcnt' == 0 {
		di as err "no events occurred; sum of depvar is zero"
		exit 459
	}
	if lngamma(`mxcnt'+1) > log(c(maxdouble)) {
		di as err "{p}total number of events, `=`mxcnt'', is too " ///
		 "large for an exact poisson model{p_end}"
		exit 459
	}
	if "`collinear'" == "" {
		local nx : word count `X'
		_rmcollright `X' `condvars'
		local vlist `r(varlist)'
		local X : list X & vlist
		if "`condvars'" != "" {
			local condvars : list condvars & vlist
		}

		if "`X'" == "" {
			di as err "no independent variables remain after " ///
			 "dropping collinear variables"
			exit 459
		}
	}

	tempname b0 se0
	mat `b0' = J(1,`: word count `X'',0)
	mat `se0' = J(1,`: word count `X'',0)
	mat colnames `b0' = `X'
	mat colnames `se0' = `X'

	InitEst `y' `X' `condvars' `wgts', `gropt' `exposure' ///
		kgroups(`kgroups') `trace'

	cap local bnames : colnames e(b)
	if _rc == 0 {
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
	return clear

	tempname yx yx0 w0 sy N
	tempname b se ci imue pyx prob pprob pscore score 
	if ("`group'"!="") tempname gn gsy

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	local N01 = 0
	foreach x of varlist `X' {
		if ("`weight'"!="") qui expand `wt'

		local X0 : list X - x

		if "`X0'`condvars'" != "" {
			if "`sort'" == "" {
				_exactreg_sort `X0' `condvars', `gropt' 
			
				local cvars `r(condvars)'
			}
			else local cvars `X0' `condvars'

			if ("`log'"=="") {
				di as txt _n "Estimating: " ///
				 abbrev("`x'",12)
			}
			local condopt condvars(`cvars')
			local X1 `x' `cvars'
		}
		else local X1 `x'

		_exact_msa `y' `X1', f(`w') eps(`eps') `condopt' `gropt' ///
			condcons `memopt' `log' poisson `exposure' `blkopt'

		if _N == 1 {
			di as err "{p}only one observation in the " ///
			 "conditional distribution for `x'{p_end}"
			exit 2000
		}

		scalar `w0' = r(n)
		scalar `N' = r(N)
		mat `yx0' = r(yx)
		scalar `sy' = r(sy)
		if "`group'" != "" {
			tempname gn gsy
			mat `gn' = r(gn)
			mat `gsy' = r(gsy)
		} 

		mat `yx0' = `yx0'[1,1]
		mat colnames `yx0' = `x'
		mat `yx' = (nullmat(`yx'),`yx0')

		format `w' %15.0g
		if ("`saving'" != "") ///
			Save `x', w(`w') saving("`saving'_`x'.dta")   

		/* compute each estimate conditional on all others 	*/
		_exactreg_coef `x', f(`w') yx(`yx0') b0(`b0') se0(`se0') ///
			`mueopt' eps(`eps') `level' `trace' poisson `midp' 

		mat `b' = (nullmat(`b'),r(b))
		mat `se' = (nullmat(`se'),r(se))
		mat `ci' = (nullmat(`ci'),r(ci))
		mat `pyx' = (nullmat(`pyx'),r(p))
		mat `imue' = (nullmat(`imue'),r(imue))
		local level0 = `r(level)'

		_exactreg_tests `x', f(`w') yx(`yx0') eps(`eps') `midp' ///
			`trace'

		mat `prob' = (nullmat(`prob'),r(prob))
		mat `pprob' = (nullmat(`pprob'),r(pprob))
		mat `score' = (nullmat(`score'),r(scores))
		mat `pscore' = (nullmat(`pscore'),r(pscores))

		restore, preserve
		qui keep `if'
	}
	local bv = 0
	forvalues i=1/`:word count `X'' {
		local bv = (`bv' | `se'[1,`i']<.)
	}
	foreach est in b se yx imue ci pprob pscore score prob pyx {
		mat colnames ``est'' = `X'
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
	ereturn scalar relative_weight = `w0'
	ereturn scalar sum_y = `sy'
	if `kgroups' > 1 {
		ereturn local groupvar `group'
		ereturn matrix N_g = `gn'
		ereturn matrix sum_y_groups = `gsy'
	}
	local level = round(`level0',.01)
	ereturn local level = bsubstr("`level'",1,5)
	if "`condvars'" != "" {
		ereturn scalar k_condvars = `:word count `condvars''
		ereturn local condvars `"`condvars'"'
	}
	else ereturn scalar k_condvars = 0

	ereturn scalar k_indvars = `:word count `X''
	ereturn scalar midp = ("`midp'"!="")
	ereturn scalar k_groups = `kgroups'
	ereturn scalar eps = `eps'

	ereturn local depvar "`y0'"
	ereturn local indvars `"`X'"'

	if "`weight'" != "" {
		ereturn local wexp "`exp'"
		ereturn local wtype "`weight'"
	}
end

program InitEst, eclass
	syntax varlist [fw], [ f(varname) group(varname) exposure(passthru) ///
		kgroups(integer 1) trace ]

	if ("`trace'" != "") local cap cap noi
	else local cap cap

	if "`group'" != "" {
		 `cap' xtpoisson `varlist' [`weight'`exp'], iter(20) fe ///
			i(`group') `exposure'
	}
	else {
		`cap' poisson `varlist' [`weight'`exp'], iter(20) `exposure'
	}
	if (_rc) ereturn post
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
	syntax varlist, w(varname) saving(string) [, log ]

	preserve

	rename `w' _w_
	keep `varlist' _w_ 

	sort `varlist' 
	
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
	/* strip of .dta suffix	*/
	local saving `anything'
	while "`saving'" != "" {
		gettoken pre rest: saving, parse(".*")

		if ("`rest'"==".dta") local rest
		else if ("`rest'"=="*") local rest
		else if ("`pre'" == "*") local pre

		local file `file'`pre'
		local saving `rest'
	}

	sreturn local saving `"`file'"'
	sreturn local replace `replace'
end

exit
