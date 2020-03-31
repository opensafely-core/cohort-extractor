*! version 2.3.0  15mar2016
program define mfx, eclass
	version 8.2, missing
	local ver : display string(_caller())
	global T_mfver "version `ver', missing:"
	version 6, missing
	gettoken cmd : 0, parse(" ,")
	if `"`cmd'"'=="," | "`cmd'"=="" {
		local cmd compute
	}
	else gettoken cmd 0 : 0, parse(" ,")
	local l = length("`cmd'")
	if bsubstr("replay",1,`l')==`"`cmd'"' {
		Replay `0'
	}
	else if bsubstr("compute",1,`l')=="`cmd'" {
		Compute `0'
	}
	else if "`cmd'"=="if" | "`cmd'"=="in" {
		Compute `cmd' `0'
	}
	else {
		di in red `"unknown mfx subcommand `cmd'"'
		exit 198
	}
end

*----------------------------------------------------------
program define Compute, eclass
	syntax [if] [in] [, AT(string) EQlist(string) PREDict(string) /*
		*/ VARlist(string) dydx eyex dyex eydx NONLinear noDiscrete /*
		*/ noEsample noWght noSe DIAGnostics(string) /*
		*/ TRacelvl(int 0) noDROP force Level(cilevel) ]

	if "`e(cmd)'" == "" {
		error 301
	}
	if `"`e(prefix)'"' == "" {
		local cmd = "`e(cmd)'"
	}
	else {
		local cmd = "`e(prefix)':`e(cmdname)'"
	}
	if (!has_eprop(b) | (!has_eprop(V) & "`se'" == "") | "`e(predict)'"=="_no_predict") {
		dis in red "mfx not available after `cmd'"
		exit 119
	}

*---- mfx not supported after all estimation commands
        if  e(cmd)=="canon" | e(cmd)=="boxcox" | e(cmd)=="svar" /*
		*/ | e(cmd)=="vec" {
		dis in red "mfx not available after " e(cmd)
		exit 119
	}

*---- options
	local type "`dydx'`eyex'`dyex'`eydx'"
	if "`type'" == "" {
		local type "dydx"
	}
	else if length("`type'") != 4 {
		dis in red "dydx, eyex, dyex, eydx are mutually exclusive"
		exit 198
	}
	if "`type'" == "dydx" | "`type'" == "dyex" {
		local lny 0
	}
	else local lny 1
	if ("`type'" != "dydx") {
		local discret "nodiscret"
	}
	if ("`diagnostics'"=="beta" | "`diagnostics'"=="drop" /*
			*/ | "`diagnostics'"=="vce" | "`diagnostics'"=="all") {
		local diag `"`diagnostics'"'
	}
	else {
		if ("`diagnostics'"!="beta" & "`diagnostics'"!="drop" /*
		*/ & "`diagnostics'"!="vce" & "`diagnostics'"!="all" /*
		*/ & "`diagnostics'"!="" ) {
			dis in red "option `diagnostics' not "/*
				*/"allowed in diagnostics"
			exit 198
		}
		else {
			local diag
		}
	}
	if "`tracelvl'"!="" {
		local trace `tracelvl'
	}
	else {
		local trace
	}
	if ("`e(cmd2)'"=="streg" & "`predict'"=="hr") | /*
			*/ bsubstr("`predict'",1,3)=="std" {
		local nonline "nonlinear"
	}

*---- Clear previous mfx results
	local oldtype `e(Xmfx_type)'
	local list X `oldtype' se_`oldtype' type method dummy variables
	local list `list' predict label_p cmd discrete y off off1 off2 nodrop
	foreach res of local list {
		est local Xmfx_`res'
	}

*---- Preserve original dataset
	preserve

*---- Check that dataset contains some observations for at points
	marksample touse, novarlist
	if "`at'"=="" | "`at'"=="mean" | "`at'"=="median" |/*
		*/("`e(offset)'"!="" | "`e(offset2)'"!="" |/*
		*/ "`e(offset1)'"!="" & index("`predict'", "nooffset")==0) {
		if "`esample'"=="" {
			qui count if `touse' & e(sample)
		}
		else qui count if `touse'
		if r(N)==0 {
			di as error "no observations"
			exit 2000
		}
	}
	else {
		qui count
		if r(N)==0 {
			di as error "no observations"
			exit 2000
		}
	}

*---- get label for predict before any changes to e(cmd)
	if "`force'" == "" {
		tempname junk
		$T_mfver cap noi qui predict `junk', `predict'
		if _rc!=0 {
			exit _rc
		}
		else local labelp : variable label `junk'
	}

*---- preserve original estimates
	tempname origest
	est hold `origest', copy

*---- Override the check of suitability for standard errors for -ivprobit- 
*---- and -ivtobit-, since we can get standard errors even though the check 
*---- says no.  Also, do only first eqn's marginal effects, since the mfx
*---- for additional instruments are identically zero.
	if "`e(cmd)'" == "ivprobit" | "`e(cmd)'" == "ivtobit" {
		local force force
		local maindep : word 1 of `e(depvar)'
		if "`eqlist'" == "" {
			local eqlist `maindep'
		}
	}


*---- Parse varlist and eqlist
	tempname B ism isv
	mat `B' = e(b)
	if "`e(cmd)'" != "nl" & "`e(cmd)'" != "nlsur" {
		local cnum = colsof(`B')
		global T_mfvar : colvarlist `B'
					    /* Used in many subroutines	  */
		global T_mfnum = `cnum'
		mat `ism' = J(1, `cnum',0)
		mat `isv' = J(1, `cnum',0)
				/* ism[1,i]!=0 if not repeated variable	    */
				/* isv[1,i]=1 if variable is to be computed */
		GetEq `ism' `isv' "`eqlist'" "`varlist'" `esample'
		local xscol "`s(xscol)'"    /* colnames of Xs of interest */
		local total `s(total)'	    /* # of Xs of interest	  */
		local xfull "`s(xfull)'"    /* varnames of all Xs	  */
		local totfull `s(totfull)'  /* # of all Xs		  */
		local dummy "`s(dummy)'"    /* 0 continuous 1 dummy	  */
		local flag "`s(flag)'"	    /* 1 nonlinear 0 linear	  */
		if `total' == 0 {
			dis in red "no independent variables"
			exit 102
		}
	}
	else {
		if trim("`e(rhs)'") == "" {
			di as error ///
"you must use the variables option with the" _n as error ///
"interactive version of nl before calling mfx"
			exit 119
		}
		NLGetVars `ism' `isv' "`varlist'" "`e(rhs)'"
		local cnum : word count `e(rhs)'
		global T_mfvar `e(rhs)'
		global T_mfnum = `cnum'
		local xscol `e(rhs)'
		local total : word count `xscol'
		local xfull `xscol'
		local totfull : word count `xfull'
		CheckDummy "`xscol'" `esample'
		local dummy "`s(dummy)'"
		local flag 1		    /* Always use nonlinear for -nl- */
		local total `totfull'
		if "`predict'" == "" {
			local predict "yhat"
		}
	}
	if "`nonline'" != "" {
		local flag = 1
	}
*---- Get point at which to evaluate
	tempname X
	mat `X' = J(1, `totfull', 0)
	mat colnames `X' = `xfull'
	if "`at'" == "" {
		local at "mean"
	}
	at `X' "`totfull'" "`at'" "if `touse', `esample' `wght'"
	tempname matat X matatse
	mat `matat' = r(at)	/* Cols = cols(e(b)) (or # of vars if -nl-)*/
	mat `X' = r(X)
	mat `matatse' = r(at)
		/* X has no entries for repeated variables	*/

*---- Will need to check if predict option depends on dependent vars,
*---- covariance matrix and/or stored scalars. If so, then the
*---- predict option is not suitable for standard errors.
	tempname copy
	mat `copy' =`X'
	if "`se'" == "" & "`force'" == "" {
		Checkse_at `copy' "`totfull'" "`at'" /*
			*/ "`touse'" "`esample'" "`wght'"
		mat `matatse' = r(A)
	}

*---- Look for Time series ops in indep vars.
*---- Change to svy for internal est command so estimates can be reposted.
	EstPost `matat' `matatse'

*---- Check prediction for error now that estimates have been reposted
	if "`force'" == "" {
		tempname junk
		$T_mfver cap noi qui predict `junk', `predict'
		if _rc!=0 {
			est unhold `origest'
			exit _rc
		}
	}

*---- Replace offset with mean
	if ("`e(offset)'"!="" | "`e(offset1)'"!=""	/*
			*/ | "`e(offset2)'"!="")	/*
			*/ & index("`predict'", "nooffset")==0 {
		MeanOffset if `touse', `esample' `wght'
		foreach x in "" "1" "2" {
			if "`r(avoff`x')'"!="" {
				local avoff`x' = r(avoff`x')
			}
		}
	}

*---- Check if predict is constant across e(sample). If so, then
*---- predict option is suitable for marginal effects
	if "`force'" == "" {
		Checkdfdx `matat' "`predict'" `diag'
		if `r(donotdydx)'==1 {
			if "`predict'" != "" {	
				di as error "predict() expression `predict'" /*
				*/ in smcl 				     /*
				*/ " {help j_mfxunsuit##|_new:unsuitable}"   /*
				*/ as error " for marginal-effect" 	     /*
				*/ " calculation"
			}
			else {
				di as error "default predict() is"	     /*
				*/ in smcl 				     /*
				*/ " {help j_mfxunsuit##|_new:unsuitable}"   /*
				*/ as error " for marginal-effect" 	     /*
				*/ " calculation"
			}
			est unhold `origest'
			exit 119
		}
		if `r(donotdrop)'==1 {
			local drop="nodrop"
			if `trace'>0 {
				di as text _n "note: nodrop option enforced"
			}
		}
	}

*---- Drop dataset
	qui keep if e(sample)	/*some only predict into the e(sample)	*/
				/* so need obs 1 to be in e(sample)	*/
	if "`drop'"=="" {
		if ("`diag'"=="drop" | "`diag'"=="all") {
			di as text _n "Kept first e(sample) observation only."
		}
		qui keep in 1
	}
	else {
		if ("`diag'"=="drop" | "`diag'"=="all") {
			di as text _n "All e(sample) observations " /*
				*/ "kept: N = " _c
			count
		}
	}

*---- Calculate predicted value at evaluation point.
	tempname y
	GetY `y' `matat' "`predict'"
	if (`y' <= 0) & `lny' {
		dis in red "y = " `y' " < 0, `type' not available"
		exit 459
	}

*---- Calculate marginal effect dydx
	if `flag' {
		NL_dfdx `matat' `ism' `isv' "`dummy'" `total' /*
			*/ "`predict'" "`discret'" `trace'
	}
	else {
		L_dfdx `matat' `ism' `isv' "`dummy'" `total' /*
			*/ "`predict'" "`discret'" `trace'
		tempname dfdxb
		mat `dfdxb' = r(dfdxb)
	}
	tempname dfdx
	mat `dfdx' = r(dfdx)

*---- Check if prediction option suitable for standard errors
	if "`se'" == "" & "`force'" == "" {
		Checkse_est `matatse' `touse' `flag' `ism' `isv' `dfdx' /*
			*/ "`dummy'" `total' "`predict'" "`discret'"
		tempname newdfdx
		mat `newdfdx' = e(dfdx)
		if ("`diag'"=="vce" | "`diag'"=="all") {
			di _n _n as text "Check prediction function does "/*
				*/ "not depend on dependent variables, "/*
				*/ _n "covariance matrix, or stored scalars."/*
				*/ _n "dfdx: "
			mat list `dfdx', noheader nonames
			di _n _n as text "dfdx, after resetting dependent "/*
				*/ "variables, covariance matrix, and "/*
				*/ "stored scalars: "
			mat list `newdfdx', noheader nonames
			di _n _n as text "Relative difference = " _c /*
				*/ as result mreldif(`dfdx',`newdfdx') _n
		}
		capture assert mreldif(`dfdx',`newdfdx') < 1e-10
		if _rc {
			if "`predict'" != "" {
	                        di as text _n "warning: predict() expression "/*
				*/ "`predict'" in smcl 			      /*
				*/ " {help j_mfxunsuitse##|_new:unsuitable} " /*
				*/ as text "for standard-error calculation;"  /*
				*/ _n "option nose imposed" _n
			}
			else {
	                        di as text _n "warning: default predict() is" /*
				*/ in smcl 				      /*
				*/ " {help j_mfxunsuitse##|_new:unsuitable}"  /*
				*/ as text " for standard-error calculation;" /*
				*/ _n "option nose imposed" _n
			}
			local se="nose"
		}
	}

*---- Calculate standard errors
	if "`se'" == "" {
		if `flag' {
			NL_se `matat' `ism' `isv' "`dummy'" `total' /*
				*/ "`predict'" "`discret'" `lny' `trace'
		}
		else {
			L_se `matat' `ism' `isv' "`dummy'" `total' /*
			*/ "`predict'" "`discret'" `lny' `dfdxb' `trace'
		}
		tempname se_dfdx
		mat `se_dfdx' = r(se_dfdx)
	}

*---- Restore original estimates
	est unhold `origest'

*---- Calculate elasticities if required
	local i = 1
	while `i' <= colsof(`X') {
		if "`type'" == "eyex" {
			mat `dfdx'[1,`i'] = `X'[1,`i']/`y' * `dfdx'[1,`i']
		}
		if "`type'" == "dyex" {
			mat `dfdx'[1,`i'] = `X'[1,`i'] * `dfdx'[1,`i']
		}
		if "`type'" == "eydx" {
			mat `dfdx'[1,`i'] = `dfdx'[1,`i']/`y'
		}
		local i = `i' + 1
	}
	mat colnames `dfdx' = `xscol'
	if "`se'" == "" {
		local i = 1
		while `i' <= colsof(`X') {
			/* NB var(ax) = a^2 var(x) implies
			   se(ax) = abs(a) se(x)		*/ 
			if "`type'" == "eyex" {
				/* `se_dfdx' already divided by Y -- 
				    see `lny' macro above 	*/
				mat `se_dfdx'[1,`i']=abs(`X'[1,`i']) /*
					*/ *`se_dfdx'[1,`i']
			}
			if "`type'" == "dyex" {
				mat `se_dfdx'[1,`i']=abs(`X'[1,`i']) /*
					*/ *`se_dfdx'[1,`i']
			}
			local i = `i' + 1
		}
		mat colnames `se_dfdx' = `xscol'
	}

*---- Return results
	local vars
	tempname B
	mat `B' = e(b)
	local i 1
	while `i' <= $T_mfnum {
		if `ism'[1,`i'] != 0 {
			if `isv'[1,`i']==1 {
				local vars `vars' 1
			}
			else local vars `vars' 0
		}
		local i = `i' + 1
	}
	est mat Xmfx_X `X'
	local cnum = colsof(`dfdx')
	forvalues i= 1/`cnum' {
		local isvar : word `i' of `vars'
		if `isvar'==0 {
			mat `dfdx'[1,`i']=.
		}
	}
	est mat Xmfx_`type' `dfdx'
	if "`se'" == "" {
		local cnum = colsof(`se_dfdx')
		forvalues i= 1/`cnum' {
			local isvar : word `i' of `vars'
			if `isvar'==0 {
				mat `se_dfdx'[1,`i']=.
			}
		}
		est mat Xmfx_se_`type' `se_dfdx'
	}
	if `flag' {
		est local Xmfx_method "nonlinear"
	}
	else est local Xmfx_method "linear"
	est local Xmfx_variables "`vars'"
	est local Xmfx_dummy "`dummy'"
	est local Xmfx_predict "`predict'"
	est local Xmfx_label_p "`labelp'"
	est local Xmfx_cmd "mfx"
	if "`discret'" == "" {
		est local Xmfx_discrete "discrete"
	}
	else est local Xmfx_discrete "nodiscrete"
	est local Xmfx_type "`type'"
	est scalar Xmfx_y = `y'
	if "`drop'" != "" {
		est local Xmfx_nodrop="nodrop"
	}
	foreach x in "" "1" "2" {
		if "`avoff`x''"!="" {
			est scalar Xmfx_off`x'=`avoff`x''
		}
	}
	if "`level'" != "" {
		local level "level(`level')"
	}
	Replay , `level'
	capture mac drop T_mfver T_mfvar T_mfnum
	Clean
	restore
end

*----------------------------------------------------------
program define Checkdfdx, rclass
	args X predict diag
	tempname junk junk1 junk2 junkn mean mean1 meann

*---- Put mean in obs 1 only
	preserve
	qui keep if e(sample)
	AddXck `X' 1
	$T_mfver qui predict double `junk1', `predict'
	scalar `mean1'=`junk1'[1]
	restore
	
*---- Put mean in last obs only
	preserve
	qui keep if e(sample)
	local N=_N
	AddXck `X' `N'
	$T_mfver qui predict double `junkn', `predict'
 	scalar `meann'=`junkn'[_N]
	restore

*---- Put mean in all obs
	preserve
	AddXck `X'
	$T_mfver qui predict double `junk', `predict'

	qui summ `junk' if e(sample)
	scalar `mean'=r(mean)
	if ("`diag'"=="beta" | "`diag'"=="drop" | "`diag'"=="all") {
		di as text _n _col(10) "Predict into observation 1 = " /*
			*/ as result `mean1'
	}
	if ("`diag'"=="beta" | "`diag'"=="all") {
		di as text _col(7) "Predict into last observation = " /*
			*/ as result `meann'
		di as text "Predict into all observations: mean = " /*
			*/ as result `mean'
		di as text _col(3) "Predict into all observations: sd = " /*
			*/ as result r(sd)
	}

*---- Check if predicts are same value
	if r(sd)>1e-10 | abs(`mean'-`mean1')>1e-10 | /*
		*/ abs(`mean'-`meann')>1e-10 {
		return local donotdydx =1
	}
	else {
		return local donotdydx =0
		qui keep if e(sample)
		qui keep in 1
		$T_mfver cap qui predict double `junk2' , `predict'
		if _rc==0 {
			if ("`diag'"=="drop" | "`diag'"=="all") {
				di as text _n _col(7) "Predict into obs 1 "/*
					*/"after drop = " as result `junk2'[1]
			}
			if `junk2'[1] != `mean1' {
				return local donotdrop =1
			}
			else return local donotdrop =0
		}
		else {
			if ("`diag'"=="drop" | "`diag'"=="all") {
				di as text _n "Predict error after drop."
			}
			return local donotdrop =1
		}
	}
	restore
end

program define AddXck
	args X a
	local cname : colvarlist `X'
	tokenize "`cname'"
	if "`a'"=="" {
		local where = ""
	}
	else local where = "in `a'"
	local j=1
	while "``j''" != "" {
		if "``j''" != "_cons" {
			cap confirm var ``j''
 			local rc1 = _rc
			if `rc1' == 0 {
				qui replace ``j'' = `X'[1,`j'] `where'
			}
			else {
				cap confirm new var ``j''
				local rc2 = _rc
				if `rc2' == 0 {
					tempvar junk
					qui gen double `junk' = /*
						*/ `X'[1,`j'] `where'
					cap drop ``j''
					rename `junk' ``j''
				}
			}
		}
		local j = `j' + 1
	}
end

*----------------------------------------------------------
program define Checkse_at, rclass
	args X total at touse esample wght
	preserve
	tsrevar `e(depvar)', list
	if "`r(varlist)'"~="" {
		foreach k of varlist `r(varlist)' {
			capture replace `k' = 0
		}
	}
	qui at `X' "`total'" "`at'" "if `touse', `esample' `wght'"
	tempname i
	mat define `i'=r(at)
	ret mat A = `i'
	restore
end

*----------------------------------------------------------
program define Checkse_est, eclass
	args matatse touse flag ism isv dfdx dummy /*
		*/ total predict discret
	tempname V oldest
	est hold `oldest', copy
	preserve
	EstPost_se
	mat `V' = e(V)
	local k = colsof(`V')
	mat `V'[1,1] = I(`k')
	est repost V = `V'
	local scalars : e(scalars)
	foreach s of local scalars {
		if e(`s')~=int(e(`s')) {
			est local `s'
		}
	}

	tempname junk A
	$T_mfver cap qui predict double `junk' , `predict'
	if _rc!=0 {
		mat `A' = J(1,`total', .)
	}
	else {
		if `flag' {
			qui NL_dfdx `matatse' `ism' `isv' "`dummy'" /*
				*/ `total' "`predict'" "`discret'" 0
		}
		else {
			qui L_dfdx `matatse' `ism' `isv' "`dummy'" /*
				*/ `total' "`predict'" "`discret'" 0
		}
		mat define `A'=r(dfdx)
	}
	restore
	est unhold `oldest'
	est mat dfdx =`A'
end

*----------------------------------------------------------
program define EstPost_se, eclass
	tempname b2 v2
	mat `b2' = e(b)
	mat `v2' = e(V)
	est post `b2' `v2', noclear
end

*----------------------------------------------------------
program define GetEq, sclass
	args ism isv eqlist varlist esamp
	tempname B
	local flag = 0
	mat `B'= e(b)
	local ename : collfnames `B'
	local fullist
	tokenize `ename'
	local fullist `1'
	while "`2'" != "" {
		if "`2'" != "`1'" {
			local fullist "`fullist' `2'"
		}
		mac shift
	}
	if "`fullist'"=="_" {
		local fullist
	}

*---- Parse eqlist
	if "`eqlist'" == "" {
		local eqlist `fullist'
	}
	else {
		local list
		tokenize `fullist'
		tempname T
		local i = 1
		while "``i''" != "" {
			local eqlist : subinstr local eqlist "``i''" "", /*
				*/ count(local isin) word all
			if `isin' {
				cap noi mat `T' = `B'[1,"``i'':"]
				if _rc==111{
					di as err "spaces are not allowed " /*
						*/ "in equation names"
					exit 111
				}
				local c = colsof(`T')
				if `c' == 1 {
					local cname : colvarlist `T'
					cap tsrevar `cname'
					if _rc == 0 {
						local list "`list' ``i''"
					}
					else {
						di in gr _n "warning: "/*
						*/"equation ``i'' is " /*
						*/"constant only;"	/*
						*/" marginal-effects not"/*
						*/" calculated for"	/*
						*/" equation ``i''"
					}
				}
				else local list "`list' ``i''"
			}
			local i = `i' + 1
		}
		local nospace : subinstr local eqlist " " "" , all
		if "`nospace'" != "" {
			di in gr _n "warning: equation(s) `eqlist' not found"
		}
		local eqlist "`list'"
		if "`eqlist'"=="" {
			local eqlist `fullist'
			dis in gr _n "warning: equation list empty. "/*
				*/"Default full variable list used."
		}
	}

	local cname $T_mfvar
	local cnum $T_mfnum
*---- Parse varlist
	if "`varlist'"!="" {
		cap tsunab varlist: `varlist'
		tokenize `varlist'
		local i 1
		while "``i''" !="" {
			cap confirm var `i'
			if _rc != 0 {
				cap tsunab `i' : ``i''
			}
			local k 1
			local found 0
			local which = ""
			while `k' <= `cnum' {
				local cnamek : word `k' of `cname'
				if "`cnamek'"=="``i''" {
					local found=`found'+1
					local which `which' `k'
				}
				local k=`k'+1
			}
			if `found'>0 {
				forvalues m=1/`found' {
				local wh1 : word `m' of `which'
				mat `isv'[1,`wh1']=1
				}
			}
			else {
				dis in gr "warning: variable ``i'' not found"
			}
			local i=`i'+1
		}
	}
	else mat def `isv'=J(1,`cnum',1)

*---- Find variables of interest
	local i 1
	local total 0		/* # of Xs of interest		*/
	local xscol		/* names of Xs of interest	*/
	local dummy
	local isin = 0
	tokenize `fullist'
	while `i' <= `cnum' {
		local enamei : word `i' of `ename'
		local cnamei : word `i' of `cname'
		cap tsrevar `cnamei'
		if _rc == 0 {
			if "`eqlist'" == "" {
				mat `ism'[1,`i'] = 1
				local total = `total' + 1
				local xscol "`xscol' `cnamei'"
			}
			else {
				local junk : subinstr local eqlist "`enamei'" /*
					*/ "`enamei'", count(local isin) word
				local junk : subinstr local xscol "`cnamei'" /*
					*/ "`cnamei'", count(local isdup) word
				if (`isin' != 0) & (`isdup'== 0) {
					local j = 1
					while "``j''" != "`enamei'" {
						local j = `j' + 1
					}
					mat `ism'[1,`i'] = `j'
					local total = `total' + 1
					local xscol "`xscol' `cnamei'"
					local xseq "`xseq' `enamei'"
					
				}
				if `isin' & `isdup' {
					local flag 1
				}
			}
		}
		local i = `i' + 1
	}
*---- Find dummies
	CheckDummy "`xscol'" `esamp'
	local dummy "`s(dummy)'"
*---- Determine linear or nonlinear.
*---- Nonlinear if repeated variable found in fullist.
	local i 1
	local xfull
	local totfull =0
	local isin = 0
	while `i' <= `cnum' {
		local enamei : word `i' of `ename'
		local cnamei : word `i' of `cname'
		cap tsrevar `cnamei'
		if _rc == 0 {
			if "`fullist'" != "" {
				local junk : subinstr local fullist /*
					*/ "`enamei'" "`enamei'", /*
					*/ count(local isin) word
 				local junk : subinstr local xfull /*
					*/ "`cnamei'" "`cnamei'", /*
					*/ count(local isdup) word
				if (`isin' != 0) & (`isdup'== 0) {
					local xfull `xfull' `cnamei'
					local totfull =`totfull'+1
				}
				if `isin' & `isdup' {
					local flag 1
				}
			}
		}
		local i = `i' + 1
	}
	forvalues i=1/`cnum' {
		if `ism'[1,`i']==0 {
			mat `isv'[1,`i']=0
		}
	}
	local check 0
	forvalues i=1/`cnum' {
		if `ism'[1,`i']!=0 & `isv'[1,`i']!=0 {
			local check = `check' + 1
		}
	}
	if `check'==0 {
		local total `check'
	}
	if `totfull'==0 {
		local totfull `total'
	}
	if "`xfull'"=="" {
		local xfull `xscol'
	}
	sreturn local xfull `xfull'
	sreturn local xscol "`xscol'"
	sreturn local total `total'
	sreturn local totfull `totfull'
	sreturn local dummy "`dummy'"
	sreturn local flag `flag'
end

*----------------------------------------------------------
program define EstPost, eclass
	args at atse
	tempname B V
	mat `B' = e(b)
	mat `V' = e(V)
	local cmd "`e(cmd)'"
	IsTs `B' `V' `at' `atse'
	local ts `s(ts)'
	if "`cmd'" == "probit" | "`cmd'"=="dprobit" {
		est post `B' `V', noclear
		est local cmd "svyprobit"
		est local predict "svylog_p"
	}

	if "`cmd'" == "logit" | "`cmd'"=="logistic" {
		est post `B' `V', noclear
		est local cmd "svylogit"
		est local predict "svylog_p"
	}

	if "`cmd'`e(opt)'" == "mlogit" {
		est post `B' `V', noclear
		est local cmd "svymlogit"
	}

	if ("`cmd'" == "ologit" | "`cmd'" == "oprobit") & missing(e(version)) {
		local dep "`e(depvar)'"
		local cname : colnames `B'
		tokenize `cname'
		local fname
		while "`1'" != "" {
			local junk : subinstr local 1 "_cut" "cut", /*
				*/ count(local a)
			if `a' == 1 {
				local fname "`fname' `junk':_cons"
			}
			else local fname "`fname' `dep':`1'"
			mac shift
		}
		mat colnames `B'= `fname'
		mat colnames `V'= `fname'
		mat rownames `V'= `fname'
		est post `B' `V', noclear
		if "`cmd'" == "oprobit" {
			est local cmd "svyoprobit"
			est local predict "ologit_p"
		}
		else	est local cmd "svyologit"
	}
	if ("`cmd'" == "tobit" | "`cmd'" == "cnreg") & missing(e(version)) {
		local cname : colnames `B'
		tokenize `cname'
		local fname
		while "`1'" != "" {
			if "`1'" != "_se" {
				local fname "`fname' model:`1'"
			}
			else local fname "`fname' sigma:_cons"
			mac shift
		}
		tempname sigma
		scalar `sigma' = `B'[1,colsof(`B')]
		mat colnames `B' = `fname'
		mat colnames `V' = `fname'
		mat rownames `V' = `fname'
		est post `B' `V', noclear
		est scalar sigma = `sigma'
		est local cmd "intreg"
	}
	if `ts' {
		cap est post `B' `V', noclear
		mat `B' = e(b)
		mat `V' = e(V)
		local cname : colvarlist `B'
 		tokenize `cname'
		while "`1'" != "" {
			if "`1'" != "_cons" {
				cap drop `1'
 				qui gen `1' =.
			}
			mac shift
		}
		est post `B' `V', noclear
	}
end

program define IsTs, sclass
	args B V at atse
	local cname $T_mfvar
	tokenize `cname'
	local ts 0
	while "`1'" != "" {
		cap tsrevar `1'
		if _rc == 0 {
			if "`r(varlist)'" != "`1'" {
			local cname : subinstr local cname "`1'" /*
				*/ "var`r(varlist)'"
				local ts 1
			}
		}
		mac shift
	}
	if `ts' {
		mat colname `B' = `cname'
		mat colname `at' = `cname'
		mat colname `atse' = `cname'
		mat rowname `V' = `cname'
		mat colname `V' = `cname'
	}
 	sreturn local ts `ts'
end

*----------------------------------------------------------
program define MeanOffset, rclass
	syntax [if] [in] [, noEsample noWght]
	marksample touse
	if "`esample'" == "" {
		qui count if e(sample)
		if r(N) != 0 {
			qui replace `touse' = 0 if ~ e(sample)
		}
	}
	if "`wght'" == "" {
		if "`e(wexp)'" != "" {
			local weight "[aweight`e(wexp)']"
		}
	}
	foreach x in "" "1" "2" {
		if ("`e(offset`x')'"!="" ) {
			local offvar="`e(offset`x')'"
			if "`wght'" == "" {
				if "`e(wexp)'" != "" {
					local weight "[aweight`e(wexp)']"
				}
			}
			cap confirm var `offvar'
			if _rc!=0 {
				local expos = subinstr("`offvar'","ln(","",.)
				local expos = subinstr("`expos'",")","",.)
				cap confirm var `expos'
				if _rc!=0 {
					di as err "exposure variable "/*
						*/"`expos' not found"
					est unhold `origest'
					exit 111
				}
				tempvar lnexp
				qui gen `lnexp'=ln(`expos')
				summ `lnexp' `weight' if `touse', meanonly
				qui replace `expos'=exp(r(mean))
				ret scalar avoff`x' =r(mean)
			}
			else {
				summ `offvar' `weight' if `touse', meanonly
				qui replace `offvar'=r(mean)
				ret scalar avoff`x' =r(mean)
			}
		}
	}
end

*----------------------------------------------------------
program define at, rclass
	args X total cmd opt
	local 0 "`opt'"
	syntax [if] [in] [, noEsample noWght]
	marksample touse
	if "`esample'" == "" {
		qui count if e(sample)
		if r(N) != 0 {
			qui replace `touse' = 0 if ~ e(sample)
		}
	}
	if "`wght'" == "" {
		if "`e(wexp)'" != "" {
			local weight "[aweight`e(wexp)']"
		}
	}
	tempname M B
	mat `B' = e(b)
	local cnum $T_mfnum
 	local cname $T_mfvar
	gettoken stat left: 0, parse(" ,")
	mat `M' = J(1, `cnum', 0)
	mat colnames `M' = `cname'
	local i 1
	while `i' <= `cnum' {
		 mat `M'[1, `i'] = 1
		local i = `i' + 1
	}
	local 0 "`cmd'"
	gettoken thing1 rest : 0 , parse(" ,=")
	if "`thing1'" == "mean" | "`thing1'" == "median" | /*
		*/ "`thing1'" == "zero" {
		Parsemean `X' `thing1' `touse' "`weight'"
		if "`rest'"!="" {
			gettoken thing1 rest2 : rest , parse(" ,=")
			if "`thing1'" =="," {
				Parseatlist `X' "`rest2'"
			}
			else {
				Parseatlist `X' "`rest'"
			}
		}
		Replace `X' `M'
		return mat at `M'
		return mat X `X'
		exit
	}
	cap confirm number `thing1'
	if _rc == 0 {
		Parsenum `X' "`0'"
		Replace `X' `M'
		return mat at `M'
		return mat X `X'
		exit
	}
	cap qui mat list `thing1'
	if _rc == 0 {
		Parsematrix `X' "`0'"
		Replace `X' `M'
		return mat at `M'
		return mat X `X'
		exit
	}
	Parseatlist `X' "`0'"
	local undone= "`r(undone)'"
	local undone : list retok undone
	local undone= trim("`undone'")
	if "`undone'" !="" {
		di as text _n "warning: no value assigned " /*
			*/"in at() for variables `undone';"
		di as text "   means used for `undone'"
		Parsemean `X' mean `touse' "`weight'"
		Parseatlist `X' "`0'"
	}
	local unfnd= "`r(unfnd)'"
	local unfnd : list retok unfnd
	local unfnd= trim("`unfnd'")
	if "`unfnd'" !="" {
		di as text _n "warning: variables `unfnd' " /*
			*/"in at() list not found in model" _n
		Parsemean `X' mean `touse' "`weight'"
		Parseatlist `X' "`0'"
	}
	Replace `X' `M'
	return mat at `M'
	return mat X `X'
end

program define Parsemean
	args X stat touse weight
	local vars : colvarlist `X'
	tokenize `vars'
	local i 1
	while "``i''" !="" {
		cap tsrevar ``i''
		if _rc ==0 {
			if "`stat'" == "zero" {
				mat `X'[1, `i'] = 0
			}
			else {
				if "`stat'" == "mean" {
					sum ``i'' `weight' if `touse', meanonly
					mat `X'[1,`i'] = r(mean)
				}
				else {
					qui sum ``i'' `weight' if `touse',detail
					mat `X'[1,`i'] = r(p50)
				}
			}
		}
		local i = `i' + 1
	}
end

program define Replace
	args X M
	local vars : colvarlist `X'
	tokenize `vars'
	local vnum = colsof(`X')
	local cname $T_mfvar
	local cnum $T_mfnum
	local j 1
	while `j' <= `cnum' {
		local jcol : word `j' of `cname'
		local k = 1
		while "``k''"!= "`jcol'" & `k'<=`cnum' {
			local k = `k' + 1
		}
		if "``k''"== "`jcol'" {
			mat `M'[1,`j'] = `X'[1,`k']
		}
		local j = `j' + 1
	}
end

program define Parseatlist, rclass
	args X opt
	local vars : colvarlist `X'
	tokenize `vars'
	local unfnd
	local undone: colvarlist `X'
 	local vnum = colsof(`X')
	gettoken thing1 vlist: opt, parse(" ,=")
	while "`thing1'" != "" {
		cap tsrevar `thing1'
		if _rc {
			dis in red "`thing1' in at() list not found"
			exit 198
		}
		unab thing1 : `r(varlist)'
		local unfnd `"`unfnd' `thing1'"'
		local unfnd : list unfnd - vars
		gettoken equal vlist : vlist, parse(" =,")
		if "=" != "`equal'" {
		dis in red "`opt' found where `exp' expected in at()"
			exit 198
		}
		gettoken thing2 vlist : vlist, parse(" =,")
		confirm number `thing2'
 		local i = 1
 		while `i' <= `vnum' {
			local name : word `i' of `vars'
			cap tsrevar `name'
			if !_rc & ("`r(varlist)'" == "`thing1'") {
				mat `X'[1,`i'] = `thing2'
				local undone : subinstr local undone /*
					*/ "`thing1'" "", word all
			}
			local i = `i' + 1
		}
		gettoken comma rest: vlist, parse(" =,")
		if "`comma'" == "," {
			local vlist `rest'
		}
		gettoken thing1 vlist: vlist, parse(" =,")
	}
	ret local undone `"`undone'"'
	ret local unfnd `"`unfnd'"'
end

program define Parsenum
	args X opt
	tempname B
	mat `B' = e(b)
	local eqname : collfnames `B'
	tokenize `eqname'
	numlist "`opt'"
	local nlist `r(numlist)'
 	tokenize "`nlist'"
 	local vnum = colsof(`X')
	local i=`vnum'+1
	local i1=`vnum'+2
	if ("``i''"!="" & "``i''"!="1") | "``i1''"!="" {
		di as error "numlist too long in at()"
		exit 503
	}
	forvalues i=1/`vnum' {
		if "``i''"=="" {
			di as error "numlist too short in at()"
			exit 503
		}
		else {
			mat `X'[1,`i']=``i''
		}
	}
end

program define Parsematrix
	args X A
	tempname B
	mat `B' = e(b)
	local eqname : collfnames `B'
	tokenize `eqname'
 	local vnum = colsof(`X')
 	local Anum = colsof(`A')
	if `Anum'==`vnum' | (`Anum'==`vnum' + 1 & `A'[1,`Anum']==1) {
		forvalues i=1/`vnum' {
			if `A'[1,`i']>=. {
				di as error "matrix missing value in at()"
				exit 503
			}
			else {
				mat `X'[1,`i']=`A'[1,`i']
			}
		}
	}
	else {
		di as error "incorrect matrix dimension in at()"
		exit 503
	}
end

*----------------------------------------------------------
program define GetY, sclass
	args y X predopt
	preserve
	local cname : colvarlist `X'
	tokenize "`cname'"
	local j=1
	while "``j''" != "" {
		if "``j''" != "_cons" {
			cap confirm var ``j''
			local rc1 = _rc
			cap confirm new var ``j''
			local rc2 = _rc
			if `rc1' == 0 | `rc2' == 0 {
				tempvar junk
				qui gen double `junk' = `X'[1,`j']
				cap drop ``j''
				rename `junk' ``j''
			}
		}
		local j = `j' + 1
	}
	tempvar Y
	$T_mfver qui predict double `Y', `predopt'
	scalar `y' = `Y'[1]
	restore
end

*----------------------------------------------------------
program define NL_dfdx, rclass
	args at ism isv dummy total predict discret trace
	if (`trace'>=1) {
		di as text _n "calculating dydx (nonlinear method)"
	}
	tempname dfdx names
	local names $T_mfvar
	local cnum $T_mfnum
	tokenize `names'
	mat `dfdx' = J(1,`total', 0)
	mat colnames `dfdx' = `xscol'
	if (`trace'>=1) {
		di in smcl in gr _n			/*
		*/ "{hline 9}{c TT}{hline 15}" _n	/*
		*/ %8s "variable" " {c |}" _col(17)	/*
		*/ "dy/dx" _n "{hline 9}{c +}{hline 15}"
	}
	local i 1
	local j 1
	while `i' <= `cnum' {
		if `ism'[1, `i'] != 0 {
			if `isv'[1,`i'] {
				local isdum : word `j' of `dummy'
				if `isdum' & ("`discret'" == "") {
					dfdx_discrete `at' `i' "`predict'" 0 `trace'
				}
				else {
					dfdx_cts `at' `i' "`predict'" 0 `trace'
				}
				mat `dfdx'[1,`j'] = r(dfdx)
				if (`trace'>=1) {
					di in smcl in gr %8s /*
					*/ abbrev(`"``i''"',8) " {c |}" /*
					*/_col(17) as result %07.5g `dfdx'[1,`j']
				}
			}
		local j = `j' + 1
		}
	local i = `i' + 1
	}
	if (`trace'>=1) {
		di in smcl in gr "{hline 9}{c BT}{hline 15}" _n
	}
	return matrix dfdx `dfdx'
end

*----------------------------------------------------------
program define L_dfdx, rclass
	args at ism isv dummy total predict discret trace
	if (`trace'>=1){
		di as text _n "calculating dydx (linear method)"
	}
	tempname dfdx se_dfdx B names
	mat `B' = e(b)
	local cnum = colsof(`B')
	local names : colvarlist `B'

	tokenize `names'
	mat `dfdx' = J(1,`total', 0)
	mat `se_dfdx' = J(1, `total', 0)
	L_dfdxb `at' "`predict'" 0 `trace'
	tempname dfdxb
	mat `dfdxb' = r(dfdxb)
	if (`trace'>=1) {
		di in smcl in gr _n			/*
		*/ "{hline 9}{c TT}{hline 15}" _n	/*
		*/ %8s "variable" " {c |}" _col(17)	/*
		*/ "dy/dx" _n "{hline 9}{c +}{hline 15}"
	}
	local i = 1
	local j = 1
	while `i' <= `cnum' {
		if `ism'[1,`i']!=0 {
			if `isv'[1,`i'] {
				local isdum : word `j' of `dummy'
				if `isdum' & ("`discret'" == "" ) {
					dfdx_discrete `at' `i' "`predict'" 0
					mat `dfdx'[1,`j'] = r(dfdx)
				}
				else {
					mat `dfdx'[1,`j'] = /*
					*/ `dfdxb'[1,`ism'[1,`i']]*`B'[1,`i']
				}
				if (`trace'>=1) {
					di in smcl in gr /*
					*/ %8s abbrev(`"``i''"',8) " {c |}"/*
					*/ _col(17) as result %07.5g /*
					*/`dfdx'[1,`j']
				}
			}
		local j = `j' + 1
		}
	local i = `i' + 1
	}
	if (`trace'>=1) {
		di in smcl in gr "{hline 9}{c BT}{hline 15}" _n
	}
	return matrix dfdx `dfdx'
	return matrix dfdxb `dfdxb'
end

*----------------------------------------------------------
program define NL_se, rclass
	args at ism isv dummy total predict discret lny trace
	if (`trace'>=1) {
		di as text _n "calculating standard errors " /*
		*/ "(nonlinear method)"
	}
	tempname se_dfdx
	local names $T_mfvar
	local cnum $T_mfnum
	tokenize `names'
	mat `se_dfdx' = J(1, `total', 0)
	local i = 1
	local j = 1
	while `i' < = `cnum' {
		if `ism'[1,`i'] != 0 {
			if `isv'[1,`i'] {
				if (`trace'>=1) {
					di _n as text "``i'' ... " _c
				}
				local isdum : word `j' of `dummy'
				if `isdum' & ("`discret'" == "") {
					if (`trace'>=1) {
						di as text "discrete"
					}
					Delta_meth `at' `i' 1 "`predict'" /*
						*/ `lny' `trace'
				}
				else {
					if (`trace'>=1) {
						di as text "continuous"
					}
					Delta_meth `at' `i' 0 "`predict'" /*
						*/ `lny' `trace'
				}
				mat `se_dfdx'[1,`j'] = r(se_dfdx)
				if (`trace'==1) {
					di
				}
				if (`trace'>=1) {
					di as text "``i'': "/*
					*/"Std. Err. = " as result /*
					*/r(se_dfdx)
				}
			}
			local j = `j' + 1
		}
		local i = `i' + 1
	}
	return matrix se_dfdx `se_dfdx'
end

*----------------------------------------------------------
program define L_se, rclass
	args at ism isv dummy total predict discret lny dfdxb trace
	if (`trace'>=1) {
		di as text _n "calculating standard errors "/*
		*/"(linear method)"
	}
	tempname se_dfdx B eqnum dmdxb
	mat `B' = e(b)
	local cnum = colsof(`B')
	local names : colvarlist `B'
	tokenize `names'
	if `lny'!=0 {
		L_dfdxb `at' "`predict'" `lny' `trace'
		tempname dfdxb
		mat `dfdxb' = r(dfdxb)
	}
	mat `se_dfdx' = J(1, `total', 0)
	L_dmdb `at' "`predict'" `lny' `trace'
	mat `dmdxb' = r(dmdxb)
	mat `eqnum' = r(eqnum)
	local i = 1
	local j = 1
	while `i' <= `cnum' {
		if `ism'[1,`i'] {
			if `isv'[1,`i'] {
				if (`trace'>=1) {
					di _n as text "``i'' ... " _c
				}
				local isdum : word `j' of `dummy'
				if `isdum' & ("`discret'" == "") {
					if (`trace'>=1) {
						di as text "discrete"
					}
					if (`trace'==1) {
						di as text _col(4) "Step: " _c
					}
					Delta_meth `at' `i' 1 "`predict'" /*
						*/ `lny' `trace'
					mat `se_dfdx'[1,`j'] = r(se_dfdx)
				}
				else {
					if (`trace'>=1) {
						di as text "continuous"
					}
					if (`trace'==1) {
						di as text _col(4) "Step: " _c
					}
					L_Delta_meth `at' `i' `ism' /*
						*/ `eqnum' `dfdxb' /*
						*/ `dmdxb' `lny' `trace'
					mat `se_dfdx'[1,`j'] = r(se_dfdx)
				}
				if (`trace'==1) {
					di
				}
				if (`trace'>=1) {
					di as text "``i'':"/*
					*/" Std. Err. = " as result r(se_dfdx)
				}
			}
			local j = `j' + 1
		}
		local i = `i' + 1
	}
	return matrix se_dfdx `se_dfdx'
end

*----------------------------------------------------------
program define Delta_meth, rclass
	args X i isdum predopt lny trace
	tempname dmdb DM se B V
	mat `B' = e(b)
	mat `V' = e(V)
	local m = colsof(`B')		/* Here we do want beta, not vars */
	local cname : colvarlist `B'
	tokenize `cname'
	mat `DM' = J(1, `m', 0)
	local j = 1
	while `j' <= `m' {
		if (`trace'>=1) {
			display as text " `j' " _c
		}
		NL_dmdb `X' `i' `j' `isdum' "`predopt'" `lny' `trace'
		scalar `dmdb' = r(dmdb)
		if (`trace'>=2) {
			di as text " d^2f/dxdb = " as result `dmdb'
		}
		if `dmdb'>=. {
			di in gr in smcl _n "warning: derivative missing;"/*
	*/ " try {help j_mfxscale##|_new:rescaling}" /*
				*/ " variable " as result "``j''" _n
			exit
		}
		mat `DM'[1,`j'] = `dmdb'
		local j = `j'+1
	}
	mat `V'=`DM'*`V'*`DM''
	scalar `se' = sqrt(`V'[1,1])
	return scalar se_dfdx = `se'
end

*----------------------------------------------------------
program define L_Delta_meth, rclass
	args at i ism eqnum dfdxb dmdxb lny trace
	tempname B V DM dmdb eqnm se
	mat `B' = e(b)
	local eqname : collfnames `B'
	mat `V' = e(V)
	local ncol = colsof(`B')
	mat `DM' = J(1,`ncol', 0)
	local j = 1
	while `j' <= `ncol' {
		if (`trace'>=1) {
			di as text " `j' " _c
		}
		scalar `dmdb' = `dmdxb'[`ism'[1,`i'], `eqnum'[1,`j']] /*
			*/ *`B'[1,`i'] * `at'[1,`j']
		if `i' == `j' {
			scalar `dmdb' = `dmdb' + `dfdxb'[1,`ism'[1,`i']]
		}
		if (`trace'>=2) {
			di as text "  d^2f/dxdb = " as result `dmdb'
		}
		mat `DM'[1,`j'] = `dmdb'
		local j = `j' + 1
	}
	mat `V' = `DM'*`V'*`DM''
	scalar `se' = sqrt(`V'[1,1])
	return scalar se_dfdx = `se'
end

*----------------------------------------------------------
program define NL_dmdb, rclass
	args X i j isdum predopt lny trace
	tempname est0 B hb dmdb
	est hold `est0', copy
	preserve
	mat `B' = e(b)
	local epsf 1e-3
	scalar `hb' = (abs(`B'[1, `j']) + `epsf')*`epsf'
	if (`trace'>=4) {
		display as text _n "initial hb = " as result `hb'
	}
	GetHb `hb' `X' `i' `B' `j' `isdum' "`predopt'" `lny' `trace'
	if `hb' == 0 {
		scalar `dmdb' = 0
	}
	else {
		if `hb' >= . {
			scalar `dmdb' = .
		}
		else {
			tempname B1 m1 m2
			mat `B1' = `B'
			mat `B1'[1, `j'] = `B'[1,`j'] + `hb'/2
			if (`trace'>=4) {
				di "   " _c
			}
			GetM `m1' `X' `i' `B1' `isdum' "`predopt'" /*
				*/ `lny' `trace'
			if (`trace'>=4) {
				di "   " _c
			}
			mat `B1'[1, `j'] = `B'[1,`j'] - `hb'/2
			GetM `m2' `X' `i' `B1' `isdum' "`predopt'" /*
				*/ `lny' `trace'
			scalar `dmdb' = (`m1'-`m2')/`hb'
		}
	}
	if (`trace'>=4) {
		di as text "hb = " as result `hb' _c
	}
	return scalar dmdb = `dmdb'
	restore
	est unhold `est0'
end

program define GetHb
	args hb X i B j isdum predopt lny trace
	tempname m0 m1 B1 goal0 goal1 diff lh uh
	local names $T_mfvar
	local cnum $T_mfnum
	tokenize `names'
	GetM `m0' `X' `i' `B' `isdum' "`predopt'" `lny' `trace'
	if (`trace'>=4) {
		di "   " _c
	}
	mat `B1' = `B'
	mat `B1'[1,`j'] = `B'[1,`j'] + `hb'
	GetM `m1' `X' `i' `B1' `isdum' "`predopt'" `lny' `trace'
	scalar `diff' = abs(`m0' - `m1')
	if `diff' < abs(`m0' + 1e-7)*1e-7 {
		scalar `hb' = 0
	}
	else {
		local ep0 1e-5
		local ep1 1e-3
		scalar `goal0' = abs(`m0'+`ep0')*`ep0'
		scalar `goal1' = abs(`m0'+`ep1')*`ep1'
		local flag1 1
		local flag2 1
		local loop 0
		while ((`diff' < `goal0') | `diff' > `goal1') {
			if (`trace'>=3 & `loop'==0) {
				di as text "Iteration (db): " _c
			}
			if `diff' < `goal0' {
				scalar `lh' = `hb'
				local flag1 0
				if `flag2' {
					scalar `uh' = 2* `hb'
				}
			}
			else {
				scalar `uh' = `hb'
				local flag2 0
				if `flag1' {
					scalar `lh' = 0.5*`hb'
				}
			}
			scalar `hb' = (`lh' + `uh')/2
			local loop = `loop'+1
			if (`trace'>=3) {
				di as text "`loop' " _c
			}
			if (`trace'>=4) {
				di as text " hb = " as result `hb' "    "
			}
			if (abs(`uh' - `lh') < abs(`B'[1, `j']+1e-8)*1e-8) /*
				*/ | (abs(`uh' - `lh') > abs(`B'[1, `j']+1e-5)*1e5) /*
				*/ | `loop'>50 {
				scalar `hb'=.
				exit
			}
			else {
				mat `B1'[1, `j']=`B'[1, `j'] + `hb'
				GetM `m1' `X' `i' `B1' `isdum' /*
					*/ "`predopt'" `lny' `trace'
				scalar `diff' = abs(`m0' - `m1')
			}
		}
	}
end

program define GetM, eclass
	args m X i B isdum predopt lny trace
	tempname V C
	mat `C' = `B'
	mat `V'= e(V)
	est post `C' `V', noclear
	if `isdum' {
		dfdx_discrete `X' `i' "`predopt'" `lny' `trace'
	}
	else {
		dfdx_cts `X' `i' "`predopt'" `lny' `trace'
	}
	scalar `m'=r(dfdx)
end

*----------------------------------------------------------
program define dfdx_cts, rclass
	args X i predopt lny trace
	preserve
	AddX `X'
	tempname h dfdx
	local epsf 1e-6
	scalar `h' = (abs(`X'[1,`i'])+`epsf')*`epsf'
	GetH_cts `h' `X' `i' "`predopt'" `lny' `trace'
	if `h' == 0 {
		scalar `dfdx' = 0
	}
	else if `h' >= . {
		scalar `dfdx' = .
	}
	else {
 
		tempname X1 f1 f2
		mat `X1' = `X'
		mat `X1'[1,`i'] = `X'[1,`i'] + `h'/2
 		GetF `f1' `X1' `i' "`predopt'" `lny' `trace'
		mat `X1'[1,`i'] = `X'[1,`i'] - `h'/2
		GetF `f2' `X1' `i' "`predopt'" `lny' `trace'
		scalar `dfdx' = (`f1'-`f2')/`h'
	}
	return scalar dfdx = `dfdx'
	return scalar h= `h'
	if (`trace'>=3) {
		di as text "h= " `h'
	}
	restore
end

program define AddX
	args X
	local cname : colvarlist `X'
	tokenize "`cname'"
	local j=1
	while "``j''" != "" {
		if "``j''" != "_cons" {
			cap confirm var ``j''
			local rc1 = _rc
			cap confirm new var ``j''
			local rc2 = _rc
			if `rc1' == 0 | `rc2' == 0 {
				tempvar junk
				qui gen double `junk' = `X'[1,`j']
				cap drop ``j''
				rename `junk' ``j''
			}
		}
		local j = `j' + 1
	}
end

program define GetF
	args f X i predopt lny
	local varlist : colvarlist `X'
	tempvar y
	local iname : word `i' of `varlist'
	tempvar junk
	qui gen double `junk' = `X'[1,`i'] in 1
	drop `iname'
	rename `junk' `iname'
	$T_mfver qui predict double `y' , `predopt'
	if `lny' {
		scalar `f' = ln(`y'[1])
	}
	else scalar `f' = `y'[1]
end

program define GetH_cts
	args h X i predopt lny trace
	tempname f0 f1 X1 goal0 goal1 diff lh uh
	GetF `f0' `X' `i' "`predopt'" `lny'
	mat `X1' = `X'
	mat `X1'[1,`i'] = `X'[1,`i'] + `h'
	GetF `f1' `X1' `i' "`predopt'" `lny'
	scalar `diff' = abs(`f0' - `f1')
	if `diff' == 0 {
		scalar `h' = 0
	}
	else {
		local ep0 1e-7
		local ep1 1e-6
		scalar `goal0' = abs(`f0'+`ep0')*`ep0'
		scalar `goal1' = abs(`f0'+`ep1')*`ep1'
		local flag1 1
		local flag2 1
		local loop 0
		while (`diff' < `goal0' | `diff' > `goal1' ) {
			if (`trace'>=3 & `loop'==0) {
				di as text _n "Iteration (dx): " _c
				if `trace'>=4{
					di as text "initial h = " `h' 
				}
			}
			if `diff' < `goal0' {
				scalar `lh' = `h'
				local flag1 0
				if `flag2' {
					scalar `uh' = 2*`h'
				}
			}
			else {
				scalar `uh' = `h'
				local flag2 0
				if `flag1' {
					scalar `lh' = 0.5*`h'
				}
			}
			local loop=`loop'+1
			scalar `h' = (`lh'+`uh')/2
			if (`trace'>=3) {
				di as text "`loop'  " _c 
				if `trace'>=4{
					di as text "h= " `h'
				}
			}
			if abs(`uh'-`lh') < 1e-15 | `loop'>100 {
				scalar `h' =.
				exit
			}
			else {
				if (abs(`uh'-`lh') > 1e5) {
					scalar `h' =0
					exit
				}
			}
			mat `X1'[1,`i'] = `X'[1,`i'] + `h'
			GetF `f1' `X1' `i' "`predopt'" `lny'
			scalar `diff' = abs(`f0' - `f1')
		}

	}
end

*----------------------------------------------------------
program define dfdx_discrete, rclass
	args X i predopt
	preserve
	tempname dfdx f1 f2 X1
	AddX `X'
	mat `X1'=`X'
	mat `X1'[1,`i'] = 1
	dGetF `f1' `X1' `i' "`predopt'"
	mat `X1'[1,`i'] = 0
	dGetF `f2' `X1' `i' "`predopt'"
	scalar `dfdx' = `f1' - `f2'
	return scalar dfdx = `dfdx'
	return scalar h = 1
	restore
end

program define dGetF
	args f X i predopt
	tempname y Z
	local iname : word `i' of $T_mfvar
	tempvar junk
	qui gen double `junk' = `iname'
	qui replace `junk' = `X'[1,`i'] in 1
	drop `iname'
	rename `junk' `iname'
	$T_mfver qui predict double `y', `predopt'
	scalar `f' = `y'[1]
end

*----------------------------------------------------------
program define L_dfdxb, rclass
	args X predopt lny trace
	tempname B eqnum dfdxbi dfdxb
	mat `B' = e(b)
	local ncol = colsof(`B')
	mat `eqnum' = J(1, `ncol', 1)
	local ename : collfnames `B'
	local cname : colvarlist `B'
	if "`ename'" != "" {
		tokenize `ename'
		local j = 1
		local i = 1
		while "`1'" != "" {
			mat `eqnum'[1,`i'] = `j'
			if "`2'" != "`1'" {
				local j = `j' + 1
			}
			mac shift
			local i = `i' + 1
		}
	}
	local total = `eqnum'[1,`ncol']	/* how many equations */
	mat `dfdxb' = J(1, `total', 0)
	local i = 1
	while `i' <= `total' {
		if (`trace'>=2) {
			di as text _n "equation i= " as result `i' " " _c
		}
		tempname b dfdx
		mat `b' = `B'
		local j=0
		local k=1
		while `k'<=`ncol' & `j'==0 {
			if `eqnum'[1,`k'] == `i' & `b'[1,`k']!=0 {
				local j = `k'
			}
			local k=`k'+1
		}
		if `j'==0{
			di as error _n "equation with all zero coefficients "/*
				*/"found in linear method; try " in smcl /*
		*/"{help j_mfxnonlinear##|_new:nonlinear}"/*
				*/ as error " option"
				exit 430
		}
		local name : word `j' of `cname'
		cap confirm var `name'
		if _rc { /* constant only */
			L_dfdb `X' `j' "`predopt'" `lny'
			mat `dfdxb'[1,`i'] = r(dfdb)
		}
		else {
			dfdx_cts `X' `j' "`predopt'" `lny' `trace'
			scalar `dfdx' = r(dfdx)
			mat `dfdxb'[1,`i'] = `dfdx'/`b'[1,`j']
		}
		if (`trace'>=2) {
			di as text ": df/d(xb) = " as result `dfdxb'[1,`i']
		}
		local i = `i' + 1
	}
	return matrix dfdxb `dfdxb'
end

*----------------------------------------------------------
program define L_dmdb, rclass
	args X predopt lny trace
	tempname B eqnum dmdxb dmdij
	mat `B' = e(b)
	local ncol = colsof(`B')
	mat `eqnum' = J(1, `ncol', 1)
	local ename : collfnames `B'
	local cname : colvarlist `B'
	if "`ename'" != "" {
		tokenize `ename'
		local j = 1
		local i = 1
		while "`1'" != "" {
			mat `eqnum'[1,`i'] = `j'
			if "`2'" != "`1'" {
				local j = `j' + 1
			}
			mac shift
			local i = `i' + 1
		}
	}
	local total = `eqnum'[1,`ncol']	/* how many equations */
	mat `dmdxb' = J(`total', `total', 0)
	local i = 1
	while `i' <= `total' {
		if (`trace'>=2) {
			di as text _n "equation k = " as result `i' ": "
		}
		local k = 1
		while (`eqnum'[1,`k'] != `i' | `B'[1,`k'] ==0)  & `k'<`ncol' {
			local k = `k' + 1
		}
		local j = 1
		while `j' <= `i' {
			local l = 1
			while (`eqnum'[1, `l'] != `j' | `B'[1,`l'] ==0) & `l'<`ncol'{
				local l = `l' + 1
			}
			local name : word `l' of `cname'
			cap confirm var `name'
			if _rc {
				local namek : word `k' of `cname'
				cap confirm var `namek'
				if `i' == `j' | _rc {
					scalar `dmdij' = 0
				}
				else {
					L2_Dxbxb `dmdij' `X' `l' `k' /*
						*/ "`predopt'" `lny' `trace'
					scalar `dmdij' = `dmdij'/`B'[1,`k']
				}
			}
			else {
				L2_Dxbxb `dmdij' `X' `k' `l' "`predopt'" /*
					*/ `lny' `trace'
				scalar `dmdij' = `dmdij'/`B'[1,`l']
			}
			mat `dmdxb'[`i', `j'] = `dmdij'
			mat `dmdxb'[`j', `i'] = `dmdij'
			if (`trace'>=2) {
				di as text "k= " as result `i' /*
					*/ as text ", l= " as result `j' _c
				di as text ": d^2f/d(xb_k)d(xb_l) = "/*
					*/ as result `dmdij'
			}
			local j = `j' + 1
		}
		local i = `i' + 1
	}
	return mat dmdxb `dmdxb'
	return mat eqnum `eqnum'
end

program define L2_Dxbxb
	args dmdij X k l predopt lny trace
	tempname h
	local epsf 1e-3
	scalar `h' = (abs(`X'[1,`l']) + `epsf')*`epsf'
	preserve
	AddX `X'
	L2_GetH `h' `X' `k' `l' "`predopt'" `lny' `trace'
	if `h' == 0 {
		scalar `dmdij' = 0
	}
	else {
		tempname X1 f1 f2
		mat `X1' = `X'
		mat `X1'[1,`l'] = `X'[1,`l'] + `h'/2
		L2_GetF `f1' `X1' `k' "`predopt'" `lny' `trace'
		mat `X1'[1,`l'] = `X'[1,`l'] - `h'/2
		L2_GetF `f2' `X1' `k' "`predopt'" `lny' `trace'
		scalar `dmdij' = (`f1'-`f2')/`h'
	}
	restore
end

program define L2_GetH
	args h X k l predopt lny trace
	tempname f0 f1 goal0 goal1 diff lh uh X1
	L2_GetF `f0' `X' `k' "`predopt'" `lny' `trace'
	mat `X1' = `X'
	mat `X1'[1,`l'] = `X1'[1,`l'] + `h'
	L2_GetF `f1' `X1' `k' "`predopt'" `lny' `trace'
	scalar `diff' = abs(`f0' - `f1')
	if `diff' < abs(`f0' + 1e-7)*1e-7 {
		scalar `h' = 0
	}
	else {
		local ep0 1e-5
		local ep1 1e-3
		scalar `goal0' = abs(`f0'+`ep0')*`ep0'
		scalar `goal1' = abs(`f0'+`ep1')*`ep1'
		local flag1 1
		local flag2 1
		local loop 0
		while (`diff' < `goal0' | `diff' > `goal1' ) {
			if (`trace'>=3 & `loop'==0) {
				di as text _n "-----Iteration (dx) for "/*
				*/" d^2f/d(xb_k)d(xb_l)-----"
			}
			if `diff' < `goal0' {
				scalar `lh' = `h'
				local flag1 0
				if `flag2' {
					scalar `uh' = 2*`h'
				}
			}
			else {
				scalar `uh' = `h'
				local flag2 0
				if `flag1' {
					scalar `lh' = 0.5*`h'
				}
			}
			local loop=`loop'+1
			if (`trace'>=3 ) {
				di as text "`loop' " _c
			}
			scalar `h' = (`lh'+`uh')/2
			if (abs(`uh'-`lh') < 1e-15) {
				scalar `h' =.
				exit
			}
			else {
				if (abs(`uh'-`lh') > 1e5) {
					scalar `h' =0
					exit
				else {
					if `loop'>100 {
					  di as error _n /*
					  */ "cannot find suitable change "/*
					  */"in x for linear method; try " /*
					  */ in smcl /*
			*/"{help j_mfxnonlinear##|_new:nonlinear}"/*
					  */ as error " option"
					  exit 430
					}
				}
			}
			mat `X1'[1,`l'] = `X'[1,`l'] + `h'
			L2_GetF `f1' `X1' `k' "`predopt'" `lny' `trace'
			scalar `diff' = abs(`f0' - `f1')
		}
	}
end

program define L2_GetF
	args f X k predopt lny trace
	tempname B 
	mat `B' = e(b)
	local cname : colvarlist `B'
	local name : word `k' of `cname'
	cap confirm var `name'
	if _rc {
		L_dfdb `X' `k' "`predopt'" `lny' `trace'
		scalar `f' = r(dfdb)
	}
	else {
		dfdx_cts `X' `k' "`predopt'" `lny' `trace'
		scalar `f' = r(dfdx)/`B'[1,`k']
	}
	if `trace'>=4{
		di as text " dfdxb = " `f'
	}
end

*----------------------------------------------------------
program define L_dfdb, rclass
	args X i predopt lny trace
	tempname est0 B
	est hold `est0', copy
	preserve
	AddX `X'
	mat `B' = e(b)
	tempname h dfdb
	local epsf 1e-6
	scalar `h' = (abs(`B'[1,`i']) + `epsf')*`epsf'
	bGetH `h' `X' `B' `i' "`predopt'" `lny'
	if `h' == 0 {
		scalar `dfdb' = 0
	}
	else bGetDfdb `dfdb' `h' `B' `i' "`predopt'" `lny'
	return scalar dfdb = `dfdb'
	return scalar h = `h'
	restore
	est unhold `est0'
end


program define bGetH
	args h X B i predopt lny
	tempname f0 f1 B1 goal0 goal1 diff lh uh
	bGetF `f0' `B' "`predopt'" `lny'
	mat `B1' = `B'
	mat `B1'[1,`i'] = `B'[1,`i'] + `h'
	bGetF `f1' `B1' "`predopt'" `lny'
	scalar `diff' = abs(`f0' - `f1')
	if `diff' < abs(`m0' + 1e-8)*1e-8 {
		scalar `h' = 0
	}
	else {
		local ep0 1e-7
		local ep1 1e-6
		scalar `goal0' = abs(`f0'+`ep0')*`ep0'
		scalar `goal1' = abs(`f0'+`ep1')*`ep1'
		local flag1 1
		local flag2 1
		local loop 0
		while (`diff' < `goal0' | `diff' > `goal1' ) {
			if `diff' < `goal0' {
				scalar `lh' = `h'
				local flag1 0
				if `flag2' {
					scalar `uh' = 2*`h'
				}
			}
			else {
				scalar `uh' = `h'
				local flag2 0
				if `flag1' {
					scalar `lh' = 0.5*`h'
				}
			}
			scalar `h' = (`lh'+`uh')/2
			local loop=`loop'+1
			if abs(`uh'-`lh') < 1e-15 | abs(`uh'-`lh') > 1e15 /*
					*/ | `loop'>100 {
				di as error _n "cannot find suitable change "/*
					*/"in b for linear method; try "/*
			*/"{help j_mfx_nonlinear##|_new:nonlinear} option"
				exit 430
			}
			mat `B1'[1,`i'] = `B'[1,`i'] + `h'
			bGetF `f1' `B1' "`predopt'" `lny'
			scalar `diff' = abs(`f0' - `f1')
		}
	}
end

program define bGetF, eclass
	args f B predopt lny
	tempname y V C
	mat `C' = `B'
	mat `V' = e(V)
	est post `C' `V', noclear
	$T_mfver qui predict double `y' , `predopt'
	if `lny' {
		scalar `f' = ln(`y'[1])
	}
	else scalar `f' = `y'[1]
end

program define bGetDfdb
	args dfdb h B i predopt lny
	tempname B1 f1 f2
	mat `B1' = `B'
	mat `B1'[1,`i'] = `B'[1, `i'] + `h'/2
	bGetF `f1' `B1' "`predopt'" `lny'
	mat `B1'[1,`i'] = `B'[1, `i'] - `h'/2
	bGetF `f2' `B1' "`predopt'" `lny'
	scalar `dfdb' = (`f1' - `f2') / `h'
end

*----------------------------------------------------------
program define Replay
	syntax , [Level(cilevel)]
	local type "`e(Xmfx_type)'"
	tempname y X B SE
	scalar `y' = e(Xmfx_y)
	cap mat `X' = e(Xmfx_X)
	if _rc!=0 {
		di as error "no mfx results found"
		exit 301
	}
	cap mat list e(Xmfx_se_`type')
	if _rc {
		local se 0
	}
	else local se 1
	mat `B' = e(Xmfx_`type')
	if `se' {
		mat `SE' = e(Xmfx_se_`type')
	}
	local cnum = colsof(`B')
	if "`type'" == "dydx" {
		local title "dy/dx"
	}
	if "`type'" == "eyex" {
		local title "ey/ex"
	}
	if "`type'" == "dyex" {
		local title "dy/ex"
	}
	if "`type'" == "eydx" {
		local title "ey/dx"
	}
	if "`e(Xmfx_predict)'" != "" {
		local predict ", `e(Xmfx_predict)'"
	}
	else local predict
	if `"`e(prefix)'"' == "" {
		if "`e(cmd2)'" != "" {
			local cmd "`e(cmd2)'"
		}
		else{
			local cmd "`e(cmd)'"
		}
	}
	else {
		local cmd = "`e(prefix)':`e(cmdname)'"
	}
	di
	if "`type'" == "dydx" {
		di in gr "Marginal effects after `cmd'"
	}
	else di in gr "Elasticities after `cmd'"
	di in gr _col(7) `"y  = `e(Xmfx_label_p)' (predict`predict')"'
	di in gr _col(10) "= " in ye %10.0g `y'
	if `se' {
		di in smcl in gr "{hline 9}{c TT}{hline 68}"
		Display `X' `B' `SE' "`level'" "`type'" "`title'" `ism' `isv'
	}
	else {
		di in smcl in gr "{hline 33}{c TT}{hline 45}"
		Displaynose `X' `B' "`type'" "`title'" `ism' `isv'
	}
end

program define Display
	args X dfdx se_dfdx level type title
	tempname Z
	local dummy "`e(Xmfx_dummy)'"
	local vars "`e(Xmfx_variables)'"
	local discret "`e(Xmfx_discrete)'"
	local c = colsof(`dfdx')
	scalar `Z' = invnorm(1-(1-`level'/100)/2)
	local 1 "variable"
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	if `cil' == 2 {
		local lspaces "    "
		local rspaces "   "
	}
	else if `cil' == 4 {
		local lspaces "   "
		local rspaces "  "
	}
	else {
		local lspaces "  "
		local rspaces "  "
	}
	di in smcl in gr /*
		*/ %8s abbrev(`"`1'"',8) " {c |}" _col(17) `"`title'"' /*
		*/ _col(26) /*
		*/ `"Std. Err."' _col(40) `"z"' _col(45) `"P>|z|"' /*
		*/ _col(52) `"[`lspaces'`=strsubdp("`level'")'% C.I.   ]"'  /*
		*/ _col(75) `"X"' _n /*
		*/ "{hline 9}{c +}{hline 68}"
	local varlist : colvarlist(`dfdx')
	tokenize `varlist'
	local i 1
	while `i' <= `c' {
		local isvar : word `i' of `vars'
		if `isvar' {
			local isdum : word `i' of `dummy'
			if `isdum' & ("`discret'" == "discrete") {
				local star "*"
				local anydum "true"
			}
			else local star " "
			local C = `dfdx'[1, `i']
			local s = `se_dfdx'[1, `i']
			local ll = `C' - `Z'*`s'
			local ul = `C' + `Z'*`s'
			local z = `C'/`s'
			local xnames: colvarlist(`X')
			local vnum=colsof(`dfdx')
			local k 1
			local tmp: word `k' of `xnames'
			while "`tmp'"!="``i''" {
				local k=`k'+1
				local tmp: word `k' of `xnames'
			}
			local x = `X'[1, `k']
			di in smcl in gr %8s /*
				*/ abbrev(`"``i''"',8) `"`star'{c |}  "' /*
				*/ in ye %9.0g `C' `"   "'_c
			sigfm 5 9 `s'
			if `s(code)' {
				dis in ye %9s "`s(output)'" `" "' _c
			}
			else dis in ye %9.0g `s(output)' `" "' _c
			di in ye /*
				*/ %7.2f `z'  `"  "'	/*
				*/ %6.3f 2*normprob(-abs(`z')) `"  "' /*
				*/ %8.0g `ll' `" "'	/*
 				*/ %8.0g `ul' `"  "'	/*
				*/ %8.6g `x'
			}
		local i = `i' + 1
		}
	foreach x in "" "1" "2" {
		if (e(Xmfx_off`x')< . ) {
		local offvar="`e(offset`x')'"
		di in smcl in gr /*
			*/ %8s abbrev(`"`offvar'"',8) `" {c |}  "' /*
			*/ in gr "(offset`x')" `"   "' /*
			*/ _col(71) %8.6g in ye e(Xmfx_off`x')
		}
	}
	di in smcl in gr "{hline 9}{c BT}{hline 68}"
	if `"`anydum'"'==`"true"' {
		di in gr `"(*) `title'"' " is for discrete " /*
			*/ "change of dummy variable from 0 to 1"
	}
end

program define Displaynose
	args X dfdx type title
	local c = colsof(`dfdx')
	local dummy "`e(Xmfx_dummy)'"
	local vars "`e(Xmfx_variables)'"
	local discret "`e(Xmfx_discrete)'"
	local 1 "variable"
	di in smcl in gr /*
		*/ %32s abbrev(`"`1'"',32) " {c |}" _col(45) `"`title'"' /*
		*/ _col(67) `"X"'
	di in smcl in gr "{hline 33}{c +}{hline 45}"
	local varlist : colvarlist(`dfdx')
	tokenize `varlist'
	local i 1
	while `i' <= `c' {
		local isvar : word `i' of `vars'
		if `isvar'==1 {
			local isdum : word `i' of `dummy'
			if `isdum' & ("`discret'" == "discrete") {
				local star "*"
				local anydum "true"
			}
		else local star " "
		local C= `dfdx'[1, `i']
		local xnames: colvarlist(`X')
		local vnum=colsof(`dfdx')
		local k 1
		local tmp: word `k' of `xnames'
		while "`tmp'"!="``i''" {
			local k=`k'+1
			local tmp: word `k' of `xnames'
		}
		local x = `X'[1, `k']
		di in smcl in gr %32s abbrev(`"``i''"',32) `"`star'{c |}  "'/*
			*/ in ye _col(42) %9.0g `C' `"   "' /*
			*/ _col(62) %8.6g `x'
		}
		local i = `i' + 1
	}
	foreach x in "" "1" "2" {
	if ("`e(offset`x')'"!="" ) /*
		*/ & index("`e(Xmfx_predict)'", "nooffset")==0 {
		local offvar="`e(offset`x')'"
		di in smcl in gr /*
			*/ %32s abbrev(`"`offvar'"',32) `" {c |}  "' /*
			*/ _col(42) in gr "(offset`x')" `"   "' /*
			*/ _col(62) %8.6g in ye e(Xmfx_off`x')
		}
	}
	di in smcl in gr "{hline 33}{c BT}{hline 45}"
	if `"`anydum'"'==`"true"' {
		di in gr `"(*) `title'"' " is for discrete "/*
			*/ "change of dummy variable from 0 to 1"
	}
end

program define sigfm, sclass
	args digits slength number
	sret clear
	if "`number'" == "0" | "`number'" =="" {
		sreturn local output "`number'"
		sreturn local code 0
		exit
	}
	tempname a b output input y
	scalar `input' = abs(`number')
	scalar `a' = log10(`input')
	if ( `a' < 0 ) & ( int(`a') != `a' ) {
		scalar `a' = `a' - 1
	}
	if `a' > `digits ' {
		scalar `b' = int(`a') - `digits' + 1
		scalar `y' = 10^`b'
		local output = round(`input', `y')
		if `a' >= `slength' - 2 {
			if sign(`number') == -1 {
				local output "-`output'"
			}
			sret clear
			sreturn local output "`output'"
			sreturn local code 0	/* number */
		}
		else {
			sret clear
			sreturn local output "`number'"
			sreturn local code 0	/* string */
		}
	}
	else if `a' < -`digits' {
		scalar `y' = 10^(-`digits')
		local output = round(`input', `y')
		if "`output'"== "0" {
			local output "."
			local i = 1
			while `i' < = `digits' {
				local output "`output'0"
				local i = `i' + 1
			}
			if sign(`number') == -1 {
				local output "-`output'"
			}
			sret clear
			sreturn local output "`output'"
			sreturn local code 1	/* string */
		}
		else {
			if sign(`number') == -1 {
				local output "-`output'"
			}
			sret clear
			sreturn local output "`output'"
			sreturn local code 0	/* number */
		}
	}
	else {
		if int(`a') > 0 {
			scalar `y' = 10^(-(`digits'-int(`a')-1))
		}
		else scalar `y' = 10^(-`digits')
		local output = round(`input', `y')
		if sign(`number') == -1 {
			local output "-`output'"
		}
		sret clear
		sreturn local output "`output'"
		sreturn local code 0	/* string */
	}
end

*----------------------------------------------------------
program define CheckDummy, sclass
	args varlist esamp
	local dummy ""
	foreach x of local varlist {
		if "`esamp'" == "" {
			cap assert `x' == 0 | `x' == 1 if e(sample)
		}
		else {
			cap assert `x' == 0 | `x' == 1 | `x' >= .
		}
		if _rc==0 {
			local dummy "`dummy' 1"
		}
		else {
			local dummy "`dummy' 0"
		}
	}
	sreturn local dummy "`dummy'"

end

*----------------------------------------------------------
program define NLGetVars

	args ism isv varlist rhs
	
	cap tsunab rhs : `rhs'
	if trim("`varlist'") == "" {
		local varlist `rhs'
	}
	local goodv ""
	cap tsunab varlist : `varlist'
	foreach i of local varlist {
		cap confirm var `i'
		if _rc != 0 {
			di as txt "warning: variable `i' not found"
		}
		else {
			local goodv `goodv' `i'
		}
	}
	if `:word count `goodv'' == 0 {
		di as error "no independent variables"
		exit 102
	}
	
	local cnum : word count `rhs'
	mat `ism' = J(1, `cnum', 1)
	mat `isv' = J(1, `cnum', 0)
	foreach i of local goodv {
		local j : list posof "`i'" in rhs
		mat `isv'[1, `j'] = 1
	}
	
end

program Clean, rclass
return clear
end
exit
