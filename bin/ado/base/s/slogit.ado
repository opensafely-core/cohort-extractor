*! version 1.8.0  29mar2018
* slogit - maximum likelihood estimation of a stereotype regression model 

program slogit, eclass sortpreserve byable(onecall) ///
		prop(ml_score svyb svyj svyr)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun slogit, required(Baseoutcome) mark(CLuster) : `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"slogit `0'"'
		exit
	}

	version 9
	if replay() {
		if _by() error 190
		if `"`e(cmd)'"' != "slogit" error 301
		Replay `0'
		exit
	}

	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	cap noi `vv' `BY' Estimate `0'
	local rc = _rc
	ereturn local cmdline `"slogit `0'"'
	if `"$STEREO_corcon"' != "" {
		constraint drop $STEREO_corcon
	}
	macro drop STEREO_*
	exit `rc'
end

program Estimate, eclass byable(recall)
	version 9
	syntax varlist(min=2 fv) [if] [in] [fw pw iw] [, ///
		DIMension(integer 1) 			///
		Baseoutcome(string)			///
		Level(cilevel)		 		///
		Robust 					///
                NOLOg LOg                               ///
		CONSTraints(numlist > 0 integer)	///
		noCORNer				///
		INITialize(passthru)			///
		noNORMalize				///
		FROM(string)				///
                SCore(passthru)                         ///
		CLuster(passthru)			///
		DEBug					///
		DOOPT					///
		* ]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	gettoken resp covar : varlist
	_fv_check_depvar `resp'
	_get_diopts diopts options, `options' level(`level')
	mlopts mlopts rest, `options'
	local collinear "`s(collinear)'"
	if `fvops' {
		if _caller() < 11 {
                	local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
        }
        else {
                local mm d2
        }

	if "`rest'" != "" {
		PostError, `rest'
	}
	if "`score'" != "" {
		local nopre  nopre
	}
	marksample touse
	cap confirm string variable `resp'
	if _rc == 0 {
		di as error "{p}dependent variable is a string variable; " ///
		 "use {help encode##|_new:encode} to convert it{p_end}"
		exit 108
	}
	/* remove collinear variables */
	`vv' _rmcoll `covar' if `touse' [`weight'`exp'], `collinear'
	local covar `"`r(varlist)'"'
	fvexpand `covar' if `touse'
	local covar "`r(varlist)'"
	local tabwgt  "`weight'"
	if "`tabwgt'" == "pweight" {
		local tabwgt "iweight"
	}
	tempname levels labels
	local labels : value label `resp'
	qui tabulate `resp' [`tabwgt'`exp'] if `touse', matrow(`levels')

	local nlev = r(r)
	if `nlev' == 1 {
		di as error "there is only one outcome in `resp'"
		exit 148
	}
	if `nlev' > 30 {
		di as error "there are `nlev' outcomes in `resp'; the maximum " ///
		 "number of outcomes is 30"
		exit 149
	}

	local nlm1 = `nlev'-1
	local nreg: word count `covar'

	local maxdim = min(`nlm1',`nreg')
	if `dimension'<=0 | `dimension'>`maxdim' {
		di as error "{p}dimension() must be a positive integer and "   ///
"cannot exceed `maxdim'; see {help slogit##|_new:slogit} for a definition " ///
		 "of the dimension limits{p_end}"
		exit 198
	}
	local ncoef = `dimension'*(`nreg'+`nlm1')+`nlm1'
	
	CategoryIndex "`levels'" "`labels'" "`baseoutcome'" "`resp'"
	local levls `"`r(levels)'"' 
	local ibase = `r(index)'

	/* create a proper factor variable for the response */
	tempvar fresp
	cap qui egen `fresp' = group(`resp') if `touse'
	if _rc > 0 {
		/* should not happen */
		di as error "failed to renumber outcome levels"
		error _rc
	}

        global STEREO_nreg = `nreg'
	global STEREO_dim = `dimension'
	global STEREO_nlev = `nlev'
	global STEREO_levels `"`levls' `ibase'"'
	global STEREO_levels1 `"`levls'"'
	global STEREO_base = `ibase'
	global STEREO_resp `"`fresp'"'

	tempname ll_0 df_0
	if "`from'" == "" {
		`vv' ///
		InitStereo `resp' `covar' [`weight'`exp'] if `touse', ///
			constr(`constraints') `corner' `initialize'   /// 
			`normalize' `log' `nolog' ///
			`robust' `cluster' `mlopts' ///
			`doopt'

		if "`normalize'" == "" {
			local log nolog
			local qui qui 
			tempname ic ilog
			scalar `ic' = e(ic)
			matrix `ilog' = e(ilog)
			local converged = e(converged)
			local rc = e(rc)
			if `converged' == 0 {
				/* prevent exceeding maxit again */
				local 0 ,`mlopts'
				syntax [, ITERate(int -1) *]
				mlopts mlopts rest, `options'
				local iteropt iterate(1)
			}
		}

		tempname from
		matrix `from' = e(b)
		tempname ll_0 df_0 
		scalar `ll_0' = e(ll_0)
		scalar `df_0' = e(df_0)
		local d2 `mm'
	}
	else {
		`vv' ///
		qui mlogit `fresp' if `touse', `doopt'
		local search quietly
		scalar `df_0' = e(k_cat)-1
		scalar `ll_0' = e(ll)
		if ("`debug'" == "") local d2 `mm'
		else {
			local d2 `mm'debug
			local debopt trace gradient hessian   
		}	
	}
	MakeModel `"`resp'"' `"`covar'"'
	local model `"`r(model)'"'
	if "`corner'" == "" {
		GenConstr 
		global STEREO_corcon `"`r(constr)'"'
		local constraints `"$STEREO_corcon `constraints'"'
	}
	`vv' ///
	`qui' ml model `d2' slogit_d2 `model' [`weight'`exp'] if `touse',  ///
		constraints(`constraints') `robust' `nopre' init(`from')   ///
		max nooutput `log' `nolog' ///
		`score' `cluster' waldtest(`dimension') ///
		search(off) collinear `mlopts' `iteropt' `debopt' `negh'

	forvalues i=`nlev'(-1)1 {
		local a`i' = `levels'[`i',1]
		if "`labels'" != "" {
			local lab`i' : label `labels' `a`i''
			ereturn local out`i' `"`lab`i''"'
		}
		else {
			ereturn local out`i' `"`a`i''"'
		}
	}
	ereturn matrix outcomes = `levels'
	ereturn local indvars `"`covar'"'
	ereturn local title "Stereotype logistic regression"
	ereturn scalar k_dim = `dimension'
	ereturn scalar k_indvars = $STEREO_nreg
	ereturn scalar k_out = $STEREO_nlev
	ereturn scalar i_base = $STEREO_base
	ereturn scalar ll_0 = `ll_0'
	ereturn scalar df_0 = `df_0'
	if "`ic'" != "" {
		ereturn scalar ic = `ic'
		ereturn scalar converged = `converged'
		ereturn matrix ilog = `ilog'
		ereturn scalar rc = `rc'
	}
	local idp 0
	forvalues dm = 1/`e(k_dim)' {
		forvalues j= 1/`e(k_out)' {
			if `j' == e(i_base) {
				ereturn hidden local diparm`++idp'	///
					__lab__,		///
					label("/phi`dm'_`j'")	///
					value(0)		///
					comment("  (base outcome)")
			}
			else {
				ereturn hidden local diparm`++idp' phi`dm'_`j'
			}
		}
		ereturn hidden local diparm`++idp' __sep__
	}
	forvalues j= 1/`e(k_out)' {
		if `j' == e(i_base) {
			ereturn hidden local diparm`++idp'	///
				__lab__,		///
				label("/theta`j'")	///
				value(0)		///
				comment("  (base outcome)")
		}
		else {
			ereturn hidden local diparm`++idp' theta`j'
		}
		local mdflt `mdflt' predict(pr outcome(#`j'))
	}
	ereturn local marginsdefault `"`mdflt'"'
	ereturn local k_dv 
	ereturn hidden local k_eq_skip = e(k_eq) - e(k_dim)

	ereturn local footnote "slogit_footnote"
	ereturn local marginsnotok SCores stdp
	ereturn hidden local marginsprop addcons
	ereturn local predict "slogit_p"
	ereturn repost, buildfvinfo ADDCONS
	ereturn local cmd slogit

	Replay, `diopts'
end

program Replay
	version 9
	syntax [, Level(cilevel) *]

	_get_diopts diopts, `options'
	ml display, level(`level') nofootnote `diopts'
	_prefix_footnote
end

program PostError
        syntax [, DIMension(string) ]

	if "`dimension'" != "" {
		di as error "option dimension() must be a positive integer"
		exit 198
	}
end

program InitStereo, eclass
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
	}
	else	local mm d2
	version 9
        syntax varlist(fv) [fw pw iw] if, [constr(numlist) NOCOrner   ///
		INITialize(string) NONORMalize NOLOg LOg Robust       ///
		CLuster(passthru) *]

        gettoken resp covar : varlist
	fvexpand `covar' `if'
	local covar "`r(varlist)'"
	mlopts mlopts, `options' 

	local nreg = $STEREO_nreg
	local dim  = $STEREO_dim
	local nlev = $STEREO_nlev
	local levls `"$STEREO_levels"'
	local base = $STEREO_base
	local fresp `"$STEREO_resp"'

	local nlm1 = `nlev' - 1
	local ncoef = `dim'*(`nreg'+`nlm1')+`nlm1'

	local linit = length("`initialize'")
	if "`initialize'"=="" || "`initialize'"==bsubstr("constant",1,max(5,`linit')) {
		local initialize "const"
	}
	else if "`initialize'" == bsubstr("random",1,max(4,`linit')) {
		local initialize "rand"
	}

	/* create standardized variables */
	tempname m sd
	matrix `m' = J(1,`nreg',0)
	matrix `sd' = J(1,`nreg',1)

	if "`nonormalize'" == "" {
		local i = 0
		foreach vari of local covar {
			cap confirm byte variable `vari'
			if _rc == 0 { 
				local scovar `"`scovar' `vari'"'
				local i = `i' + 1
			}
			else {
				tempvar x`++i'
				local sumwgt  "`weight'"
				if "`sumwgt'" == "pweight" {
					local sumwgt "iweight"
				}
				qui summarize `vari' [`sumwgt'`exp']
				matrix `m'[1,`i'] = r(mean)
				if r(sd) > 0.0 {
					matrix `sd'[1,`i'] = r(sd)
				}
				qui gen double `x`i'' = (`vari'-r(mean))/`sd'[1,`i']
				local scovar `"`scovar' `x`i''"'
			}
		}
	}
	else local scovar `"`covar'"'

	`vv' ///
	cap mlogit `fresp' `scovar' [`weight'`exp'] `if', base(`base') ///
		nolog iter(50) `doopt'
	if _rc {
		di as err "{p}{cmd:mlogit} initial estimates failed; try " ///
		 "using the from() option{p_end}" 
		exit 498
	}
	tempname ll_0 df_0 b from B D U V P v
	_getmlogitcoef `scovar'
	matrix `b' = r(b)
	scalar `ll_0' = e(ll_0)
	scalar `df_0' = e(k_out)-1

	local nb = colsof(`b')
	local nrp1  = `nreg'+1
	forvalues i = 1(`nrp1')`nb' {
		local j = `i'+`nreg'-1
		matrix `B' = (nullmat(`B') \ `b'[1,`i'..`j'])
	}
	local p = `dim'*`nlm1'
	local k = `nreg'*`dim'+1

	if "`initialize'" == "const" {
		local d = min(1/`dim',.5)
		matrix `P' = J(`p',1,`d')
	}
	else if "`initialize'" == "rand" {
		matrix `P' = matuniform(`p',1)
	}
	else if "`initialize'" == "svd" {
		if `nlm1' >= `nreg' {
			matrix svd `U' `D' `V' = `B'
			matrix `V' = `V''
		}
		else {
			matrix `B' = `B''
			matrix svd `V' `D' `U' = `B'
			matrix `U' = `U''
		}
		if `U'[1,1] < 0.0 {
			matrix `U' = -`U'
			matrix `V' = -`V'
		}
		matrix drop `B'
		forvalues i = 1/`dim' {
			matrix `v' = `D'[1,`i']*`V'[1...,`i']
			matrix `B' = (nullmat(`B'),`v')
			matrix `P' = (nullmat(`P') \ `U'[1...,`i'])
		}
		matrix drop `D' `V' `U' `v'
	}
	else {
		di as error "option initialize() must specify " ///
		 "constant, random, or svd"
		exit 198
	}
	MakeModel `"`resp'"' `"`covar'"'
	local names `"`r(names)'"'
	matrix `from' = J(1,`ncoef',0.0)
	`vv' matrix colnames `from' = `names'

	if "`nocorner'" == "" {
		GenConstr 
		local corcon `"`r(constr)'"'
		global STEREO_corcon = `"`corcon'"'
		local constr `"`corcon' `constr'"'
	}
	local nc = 0
	if "`constr'" != "" {
		matrix `D' = `from'
		matrix `V'= I(`ncoef')
		`vv' matrix rownames `V' = `names'
		`vv' matrix colnames `V' = `names'
		ereturn post `D' `V'
		MakeConstr "`constr'" `p' `k' `nlm1' "`P'"
		local nc = `r(nc)'
		if `r(nc)' > 0 {
			tempname C c s
			matrix `C' = r(C)
			matrix `P' = r(P)
			local conopt "constraint(`C')"
			if `"`corcon'"' != "" {
				constraint drop `corcon'
			}
			local nc =  rowsof(`C')
			local p = `nreg'*`dim'
			forvalues j = 1/`p' {
				local k =  mod(`j'-1,`nreg')+1 
				scalar `s' = `sd'[1,`k']
				forvalues i = 1/`nc' {
					matrix `C'[`i',`j'] = `C'[`i',`j']/`s'
				}
			}
		}
	}
	if `nc' == 0 {
		tempname P1 
		matrix `P1' = `P'
		matrix `P'  = J(`nlm1',`dim',0)
		
		local i1 = 0
		forvalues j=1/`dim' {
			forvalues i=1/`nlm1' {
				matrix `P'[`i',`j'] = `P1'[`i1'+`i',1]
			}
			local i1 = `i1'+`nlm1'
		}
	}
	if "`initialize'" != "svd" {
		if `nc' == 0 {
			matrix `B' = `B''
		}
		else {
			tempname DV
			matrix svd `U' `D' `V' = `P'
			matrix `V' = `V''
       			forvalues i = 1/`dim' {
				if `D'[1,`i'] > c(epsdouble) {
					matrix `v' = `V'[1...,`i']/`D'[1,`i']
					matrix `DV' = (nullmat(`DV'),`v')
				}
				else {
					matrix `DV' = (nullmat(`DV'),J(`dim',`dim',0.0))
				}
			}
			matrix `B' = `B''*`U'*`DV'
			matrix drop `D' `V' `U' `DV'
		}
	}
	local kb = 0
	local k = `dim'*`nreg'
	/* initial beta */
	forvalues dm = 1/`dim' {
		forvalues i=1/`nreg' {
			matrix `from'[1,`++kb'] = -`B'[`i',`dm']
		}
		/* initial phi */
		forvalues i = 1/`nlm1' {
			matrix `from'[1,`++k'] = `P'[`i',`dm']
		}
	}
	matrix drop `B' `A'

	/* initial theta */
	forvalues i = `nrp1'(`nrp1')`nb' {
		matrix `from'[1,`++k'] = `b'[1,`i']
	}
	if "`nonormalize'" == "" {
		MakeModel `"`resp'"' `"`scovar'"'
		local model `"`r(model)'"'
		`vv' matrix colnames `from' = `r(names)'
		`vv' ///
		ml model `mm' slogit_d2 `model' [`weight'`exp'] `if', ///
			`conopt' init(`from') search(off) max nooutput ///
			`log' `nolog' ///
			`robust' `cluster' `mlopts' `negh' collinear

		matrix `from' = e(b)
		local lev: word 1 of `levls'
	        local l = colnumb(`from',"phi1_`lev':") 
        	local t = colnumb(`from',"theta`lev':") - 1
		local k = 1
		forvalues i = 1/`dim' {
			scalar `V' = 0.0
			forvalues j = 1/`nreg' {
				matrix `from'[1,`k'] = `from'[1,`k']/`sd'[1,`j']
				scalar `V' = `V' + `from'[1,`k']*`m'[1,`j']
				local k = `k' + 1
			}
			forvalues j = 1/`nlm1' {
				matrix `from'[1,`j'+`t'] = `from'[1,`j'+`t'] + ///
					`from'[1,`l']*`V'
				local l = `l' + 1
			}
		}
		`vv' matrix colnames `from' = `names'
		ereturn repost b = `from' [`e(wtype)'`e(wexp)'], rename
	}
	else ereturn post `from'
	
	ereturn scalar ll_0 = `ll_0'
	ereturn scalar df_0 = `df_0' 
end

program MakeModel, rclass
        args resp covar

	local nreg = $STEREO_nreg
	local dim  = $STEREO_dim
	local nlev = $STEREO_nlev
	local levls `"$STEREO_levels1"'

	local nlm1 = `nlev' - 1
	local beta "(dim1: `resp' = `covar', nocons)"
	/* initial beta */
	forvalues dm = 1/`dim' {
		if `dm' > 1 {
			local beta `"`beta' (dim`dm': `covar', nocons)"'
		}
		foreach vari of local covar {
			/* column names of the `from' vector */
			local bfrom `"`bfrom' dim`dm':`vari'"'
		}
		/* initial phi */
		local i = 0
		foreach j of local levls {
			/* names of the score variables */
			local dpv `"`dpv' dpv`dm'`++i'"'
			/* ml model specification */
			local phi `"`phi' (phi`dm'_`j':)"'
			/* column names of the `from' vector */
			local pfrom `"`pfrom' phi`dm'_`j':_cons"'
		}
		local dbv `"`dbv' dbv`dm'"'
	}

	/* initial theta */
	local i = 0
	foreach j of local levls {
		/* column names of the `from' vector */
		local tfrom `"`tfrom' theta`j':_cons"'
		/* names of the score variables */
		local dtv `"`dtv' dtv`++i'"'
		/* ml model specification */
		local theta `"`theta' (theta`j':)"'
	}
	global STEREO_dv `"`dbv'`dpv' `dtv'"'
	return local names `"`bfrom'`pfrom'`tfrom'"'
	return local model `"`beta'`phi'`theta'"'
end

program GenConstr, rclass
	local nlm1 = $STEREO_nlev-1

        forvalues dm = 1/$STEREO_dim {
        	forvalues j = 1/$STEREO_dim {
                	local i : word `j' of $STEREO_levels
                        constraint free
			local val = (`j'==`dm')
                        constraint `r(free)' [phi`dm'_`i']_cons = `val'
                        local constraint `"`constraint' `r(free)'"'
		}
	}
	return local constr `"`constraint'"'
end

/* taken from matcproc to apply constraints only on Phi's */
program MakeConstr, rclass
	args constr p k q P

	tempname C0 C1 C V V2 D Z v a c c1
	matrix makeCns `constr'
	matrix `C0' = get(Cns)
	local j = `k'+`p'-1
	matrix `C1' = `C0'[.,`k'..`j']
	/* remove rows of C with zeros */
	local nc = rowsof(`C1')
	local j = colsof(`C0')
	matrix `c1' = `C0'[1...,`j']
	forvalues i = 1/`nc' {
		matrix `v' = `C1'[`i',1...]
		matrix `a' = `v'*`v''
		/* phi constraint */
		if `a'[1,1] > c(epsdouble) {
			matrix `C' = (nullmat(`C') \ `v')
			matrix `c' = (nullmat(`c') \ `c1'[`i',1])
		}
	}
	cap local nc = rowsof(`C')
	if _rc > 0 {
		return local nc = 0
		exit 0
	}
	local k = `p' - `nc'
	local kp1 = `k'+1
	matrix `Z' = I(`p') - `C''*syminv(`C'*`C'')*`C'

	matrix symeig `V' `D' = `Z'
    	if `D'[1,`kp1'] > .5 { 
		error 412
	}
	matrix `V2' = `V'[.,`kp1'...]
	matrix `a' = `V2'*inv(`C'*`V2')*`c'
	if `k' > 0 {
		matrix `V' = `V'[.,1..`k']
		matrix `a' = `V'*`V''*`P' + `a'
	}
	matrix drop `D'
	forvalues j = 1(`q')`p' {
		local k = `j' + `q' - 1
		matrix `D' = (nullmat(`D'),`a'[`j'..`k',1])
	}
	local nc = rowsof(`C0')
	return local nc = `nc'
	return matrix C = `C0'
	return matrix P = `D'
end

program CategoryIndex, rclass
        args  catlevels catlabels level resp

        local index = .
        local ncat = rowsof(`catlevels')
        if "`level'"!="" {
                local i = 0
                while `++i'<=`ncat' & `index'>=. {
                        local icat = `catlevels'[`i',1]
                        if (`"`level'"'==`"`icat'"') local index = `i'
                }
                if `index'>=. & "`catlabels'"!="" {
                        local i = 0
                        while `++i'<=`ncat' & `index'>=. {
                                local label : label `catlabels' `=`catlevels'[`i',1]'
                                if (`"`level'"'==`"`label'"') local index = `i'
                        }
                }
                if `index' >= . {
			di as error "{p}baseoutcome(`level') is not an "  ///
	"outcome of `resp'; use {help tabulate##|_new:tabulate} for a " ///
			 "list of values{p_end}"
			exit 459
                }
	
        }
	else local index = `ncat'
	
	forvalues i=1/`ncat' {
		if (`i' == `index') continue
		local levels `"`levels' `i'"'
	}

        return local index = `index'
	return local levels  `"`levels'"'
end

