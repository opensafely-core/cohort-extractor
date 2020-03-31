*! version 1.8.1  16may2019
program predictnl
	version 8.2
	global T_nlver : display string(_caller())
	global T_nlver "version $T_nlver:"

	if "`e(cmd)'" == "" {
		error 301
	}
	if (!has_eprop(b) | !has_eprop(V)) {
		error 321
	}
	is_svy
	local is_svy `r(is_svy)'
	if "`is_svy'"=="1" {
		if "`e(complete)'" == "available" {
			di as err /*
*/ `"must run svy command with "complete" option before using this command"'
			exit 301
		}
		if inlist("`e(cmd)'", "svymean", "svytotal", "svyratio") {
			di as err `"predictnl not possible after `e(cmd)'"'
			exit 301
		}
	}
	if "`e(cmd)'" == "boxcox" | "`e(cmd)'" == "eivreg" {
		di as err "predictnl not available for use after `e(cmd)'"
		exit 301
	}	
	if `"`e(version)'`e(cmd)'"' == "anova" { // old anova
		di as err ///
		    "predictnl not allowed after anova run under version < 11"
		exit 301
	}
	local intcomlist ///
		`""regress","anova","logistic","logit","qreg","prais","rreg""'

	gettoken type 0 : 0, parse(" =")
        gettoken newvar 0 : 0, parse(" =")
	if "`type'"=="" | "`newvar'"=="" {
		error 198
	}

	if `"`newvar'"'=="=" {
		local newvar `"`type'"'
		local type : set type
	}
	else {
		gettoken eqsign 0 : 0, parse(" =")
		if `"`eqsign'"' != "=" {
			error cond("`eqsign'"=="",198,103)
		}
	}

	if !inlist("`type'","byte","int","long","float","double") {
		di as err `"`type' is not a valid numerical data type"'
		exit 198
	}
	confirm new variable `newvar'

	syntax anything(id="expression" name=predexp) [if] [in] /*
		*/ [, Level(cilevel) 				/*
		*/ se(passthru) VARiance(passthru) Wald(passthru) /* 
		*/ p(passthru) ci(passthru) g(string) FORCE /*
		*/ ITERate(integer 100) DF(numlist max=1 >0 missingok)]

	marksample touse

	CheckOpts, `se' `variance' `wald' `p' `ci'
	local se `s(se)'
	local var `s(var)'
	local wald `s(wald)'
	local p `s(p)'
	local ci1 `s(ci1)'
	local ci2 `s(ci2)'
	
	local stub `g'
	if `"`stub'"'!="" {
		local wc : word count `stub'
		if `wc' > 1 {
			di as error "Only one stubname allowed in g()"
			exit 198
		}
	}

	local needvar "`se'`var'`wald'`p'`ci1'`ci2'"

	/* Define variables that hold derivatives */
	tempname b V oldest
	if ("`e(predictnl_altb)'"!="") {
		local bnom "`e(predictnl_altb)'"
		tempname balt 
		matrix `balt' = e(`bnom')
		matrix `b'    = `balt'
	}
	else {
		matrix `b' = e(b)	
	}
	local k = colsof(`b') 

	if `"`needvar'"'!="" | `"`stub'"'!="" {
		if `"`stub'"'!="" {
			forvalues i = 1/`k' {
				local Gvars `Gvars' `stub'`i'
			}
			confirm new variable `Gvars'
		}
		else {
			forvalues i = 1/`k' {
				tempvar G`i'
				local Gvars `Gvars' `G`i''
			}
		}
	}
	confirm new variable `newvar' `se' `var' /*
		*/ `wald' `p' `ci1' `ci2' `Gvars'

	/* Dry run:  determine the number of tempvar's required */
	ParseExp `"`predexp'"' 1 `touse'
	local nvar `r(N)'

	forvalues i = 1/`nvar' {
		tempvar pred`i'
		local predvars `predvars' `pred`i''
	}
	
	tempvar fbeta variance
	local command "`e(cmd)'"

	_estimates hold `oldest', copy
	capture noisily nobreak {

		if !inlist("`e(cmd)'",`intcomlist') {
			PostI
		}

		/* Final pass through predexp */

		ParseExp `"`predexp'"' 0 `touse' `predvars'
		local predexp `"`r(exp)'"'
		forvalues i = 1/`nvar' {
			local predcoms `"`predcoms' `"`r(pred`i')'"'"'
		}

		if inlist("`command'","ologit","oprobit","tobit","cnreg") ///
		 & missing(e(version)) {
			FixExp `"`predexp'"' `command'
			local predexp `"`r(exp)'"'
		}

		ExpEval `fbeta' `"`predexp'"' `touse' /* 
			*/ "`predvars'" `predcoms'

		if "`needvar'"!="" | `"`stub'"'!="" {
			
			if inlist("`e(cmd)'",`intcomlist') {
				PostI
			}

			CheckBeta `fbeta' `"`predexp'"' `touse' /*
				*/ "`predvars'" `"`predcoms'"' `force'
			
			FillG "`Gvars'" `"`predexp'"' /*
			*/ `fbeta' `touse' "`predvars'" `"`predcoms'"' /*
			*/ `iterate'

			if "`needvar'"!="" {
				if ("`e(predictnl_altV)'"!="") {
					local vnom "`e(predictnl_altV)'"
					tempname valt 
					matrix `valt' = e(`vnom')
					mat `V'       = `valt'
				}
				else {
					mat `V' = e(V)
				}
				VarCalc `variance' = "`Gvars'" `V' `touse'
				cap assert `variance'==0 if `touse'
				if !_rc {
					di as txt /*
*/ "Warning: prediction doesn't vary with respect to e(b)."
				}
			}
		}
	}
	_estimates unhold `oldest'

	if _rc {
		exit _rc
	}

	gen `type' `newvar' = `fbeta' if `touse'
	label var `newvar' "Prediction"
	qui summ `newvar' if `touse', meanonly
	if r(min) == r(max) {
		di as txt /*
*/ "Warning: prediction constant over observations; " _c
		di as txt /*
*/ "perhaps you meant to run {help nlcom##|_new:nlcom}."
	}

	if "`var'"!="" {
		qui gen `type' `var' = `variance' if `touse'
		label var `var' "Variance: `newvar'"
	}

	if "`se'"!="" {
		qui gen `type' `se' = sqrt(`variance') if `touse'
		label var `se' "Standard error: `newvar'"
	}

	if "`wald'`p'`ci1'" != "" {
		tempvar ww
		qui gen double `ww' = cond(`variance'==0, . , /*
			*/ `fbeta'^2/`variance') if `touse'
	}

	if "`p'`ci1'" != "" {            /* get the distribution of Wald */
		tempname df_r

		if "`df'" != "" {
			scalar `df_r' = `df'
		}
		else if _caller() < 13 {
			DenomDOF
			scalar `df_r' = r(df_r)
		}
		else {
			scalar `df_r' = .
		}
		
		if `df_r' == . {
			local testtype chi2
		}
		else {
			local testtype F
		}
	}

	if "`wald'"!="" {
		qui gen `type' `wald' = `ww' if `touse'
		label var `wald' "Wald test statistic: `newvar'"
	}

	if "`p'"!="" {
		di as txt /*
		*/ "note: p-values are with respect to the " _c
		if "`testtype'" == "chi2" {
			qui gen `type' `p' = chi2tail(1, `ww') if `touse'
			di as txt "chi-squared({res:1}) distribution"
		}
		else {  		/* F distribution */
			qui gen `type' `p' = Ftail(1, `df_r', `ww') if `touse'
			di as txt /*
*/ "F({res:1}," as res scalar(`df_r') as txt ") distribution"
		}
		label var `p' "Level of significance: `newvar'"
	}

	if "`ci1'"!="" { 
		tempname zs
		di as txt "note: confidence intervals calculated using " _c
		if "`testtype'" == "chi2" {
			di as txt "Z critical values"
			scalar `zs' = invnorm((100+`level')/200)
		}
		else {                 /* F distribution */
			di as txt "t(" as res `df_r' as txt ") critical values"
			scalar `zs' = invttail(scalar(`df_r'), /*
					*/ (100-`level')/200)
		}
		qui gen `type' `ci1' = `fbeta' - /*
			*/ `zs'*sqrt(`variance') if `touse'
		qui gen `type' `ci2' = `fbeta' + /*
			*/ `zs'*sqrt(`variance') if `touse'
label var `ci1' `"`=strsubdp("`level'")'% lower bound: `newvar'"'
label var `ci2' `"`=strsubdp("`level'")'% upper bound: `newvar'"'
	}
	mac drop T_nlver
end

program ExpEval 
	args X exp touse predvars
	capture drop `predvars'
	mac shift 4
	while `"`1'"' != "" {
		`1', if `touse' 
		mac shift
	}
	qui gen double `X' = `exp' if `touse'
end

program ParseExp, rclass
	args exp count touse
	mac shift 3
	local i 0
	if `count' {
		local dont *
	}

	if ("`e(predictnlprops)'"!="") {
		_under_score_not, laexp(`exp') 
	}
	while `"`exp'"' != "" {
		gettoken check exp: exp, /*
			*/ parse(`" "`'~:;,<>\/?!@|#$%^&*()-+=[]{}"') quotes
		if `"`check'"' != "predict" & `"`check'"' != "xb" {
			`dont'local myexp `"`myexp'`check'"'
			continue
		}
		gettoken paren : exp, parse(" (")
		if `"`paren'"' != "(" {             /* False alarm */
			`dont'local myexp `"`myexp'`check'"'
			continue
		}
		local i = `i' + 1
		if !`count' {
			gettoken args exp: exp, match(par)
			if `"`check'"' == "xb" {
				local args : subinstr local args " " "", all
				local eqopt
				if `"`args'"'!="" {
					local eqopt eq(`args')
				}
				local term `"xb(`args')"'
				local command /* 
*/ `"qui Scorebeta `1', `eqopt'"'   
			}
			else {                     /* check == "predict" */
				local term `"predict(`args')"'
				local command /* 
*/ `"$T_nlver qui predict double `1', `args'"'
			}
			CheckValid `"`command'"' `"`term'"' `touse' `1'
			return local pred`i' `"`command'"'
			local myexp `"`myexp'`1'"' 
			mac shift
		}
	}
	`dont'return local exp `"`myexp'"'
	return scalar N = `i'
end

program VarCalc /* Var = G V */
	args var equals G V touse

	local k = colsof(`V')
	if `k' == 0 {
		di as err "no model coefficients"
		exit 322
	}
	tempname jj V2
	tempvar jji
	mat `V2' = `V'
	mat rownames `V2' = `G'
	mat colnames `V2' = `G'
	mat rownames `V2' = _:
	mat colnames `V2' = _:
	qui gen double `var' = 0 if `touse'

	tokenize `G'
	local i 1
	while "``i''" != "" {
		capture confirm variable ``i''
		if !_rc {
			mat `jj' = (`V2'[1...,`i'])'
			capture drop `jji'
			mat score double `jji' = `jj' if `touse', forcezero
			qui replace `var' = `var' + `jji'*``i'' if `touse'
		}
		local i = `i' + 1
	}
end

program FillG
	args G exp y touse pvars pcoms maxiter

	tempname b
	if ("`e(predictnl_altb)'"!="") {
		local bnom "`e(predictnl_altb)'"
		tempname balt
		matrix `balt' = e(`bnom')
		mat `b' = `balt'
	}
	else {
		mat `b' = e(b)
	}

	tokenize `G'
	local i 1
	while "``i''" != "" {
Deriv ``i'' `i' = `"`exp'"' `y' `b' `touse' "`pvars'" `"`pcoms'"' `maxiter'
		local i = `i' + 1
	}
end


program Deriv /* var j = exp y b touse pvars pcoms*/
	args var j equals exp y b touse pvars pcoms maxi

	tempvar w w2 absd absy
	tempname meand r0 

	Post `b' `j' "abs(`b'[1,`j'])*.01+.01" 
	ExpEval `w' `"`exp'"' `touse' "`pvars'" `pcoms'

	capture assert `w'==`y' if `touse'

	if !_rc {                                /* deriv is zero */
		exit
	}

	qui gen double `absd' = abs(`w'-`y') if `touse'
	summ `absd' if `touse', meanonly
	scalar `meand' = r(mean)
	qui gen double `absy' = abs(`y') if `touse'
	summ `absy' if `touse', meanonly
	scalar `r0' = r(mean)

	tempname db goal0 goal1 

	scalar `db' = abs(`b'[1,`j'])*.01 + .01

	scalar `goal0' = `r0'*1e-6 + 1e-6
	scalar `goal1' = `r0'*1e-5 + 1e-5

	local i 0
	while `meand' < `goal0' | `meand' > `goal1' {
 		scalar `db' = ((`goal0'+`goal1')/2)*`db'/`meand'
		if `db' < .  & `i' <= `maxi' { 
			Post `b' `j' `db' 
		}
		else {
			if `i'>`maxi' {
di as err "Maximum number of iterations exceeded."
				exit 498
			}
			exit
		}
		capture drop `w'
		ExpEval `w' `"`exp'"' `touse' "`pvars'" `pcoms'
		qui replace `absd' = abs(`w'-`y') if `touse'
		summ `absd' if `touse', meanonly
		scalar `meand' = r(mean)
		local i = `i' + 1
	}
	
	Post `b' `j' -`db'
	ExpEval `w2' `"`exp'"' `touse' "`pvars'" `pcoms'
	qui gen double `var' = (`w' - `w2') / (2*`db') if `touse'
end

program PostI, eclass 
	tempname b2 v2
	if ("`e(predictnl_altb)'"!="" & "`e(predictnl_altV)'"!="") {
		local bnom "`e(predictnl_altb)'"
		local vnom "`e(predictnl_altV)'"	
		tempname balt valt 
		matrix `balt' = e(`bnom')
		matrix `valt' = e(`vnom')
		mat `b2' = `balt'
		mat `v2' = `valt'
	}
	else {
		mat `b2' = e(b)
		mat `v2' = e(V)
	}

	local cmd "`e(cmd)'"            

	if ("`cmd'"=="probit" | "`cmd'"=="dprobit") & "`e(opt)'" == "" {
		ereturn post `b2' `v2', noclear
		ereturn local cmd "svyprobit"
		ereturn local predict "svylog_p"
		exit
	}
	if ("`cmd'"=="logit" | "`cmd'"=="logistic") & "`e(opt)'" == "" {
		ereturn post `b2' `v2', noclear
		ereturn local cmd "svylogit"
		ereturn local predict "svylog_p"
		exit
	}
	if "`cmd'"=="mlogit" & "`e(opt)'" == "" {
		ereturn post `b2' `v2', noclear
		ereturn local cmd "svymlogit"
		tempname C
		if e(k_out) < . {
			/* outcomes replaced categories in version 10 */
			local cat out
		}
		else {
			assert e(k_cat) < .
			local cat cat
		}
		mat `C' = e(`cat')
		local k = colsof(`C')
		forvalues i = 1/`k' {
			local cati = `C'[1,`i']
			local cats : label (`e(depvar)') `cati'
			local cats = trim(usubstr(`"`cats'"',1,c(namelenchar)))				
			local coln `"`coln' `"`cats'"'"'
		}
		mat coleq `C' = `coln'
		ereturn matrix `cat' = `C'
		exit
	}
        if inlist("`cmd'", "ologit", "oprobit") & missing(e(version)) {
                local dep "`e(depvar)'"
                local cname : colnames `b2'
		tokenize `cname'
		local fname
                while "`1'" != "" {
                        local junk : subinstr local 1 /*
				*/ "_cut" "cut", count(local a)
                        if `a' == 1 {
                                local fname "`fname' `junk':_cons"
                        }
                        else local fname "`fname' `dep':`1'"
                        mac shift
                }
                mat colnames `b2'= `fname'
                mat colnames `v2'= `fname'
                mat rownames `v2'= `fname'
		ereturn post `b2' `v2', noclear
                if "`cmd'" == "oprobit" {
                        ereturn local cmd "svyoprobit"
                        ereturn local predict "ologit_p"
                }
                else ereturn local cmd "svyologit"
		exit
        }
        if ("`cmd'" == "tobit" | "`cmd'" == "cnreg") & missing(e(version)) {
                local cname : colnames `b2'
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
                scalar `sigma' = `b2'[1,colsof(`b2')]
                mat colnames `b2' = `fname'
                mat colnames `v2' = `fname'
                mat rownames `v2' = `fname'
		ereturn post `b2' `v2', noclear
                ereturn scalar sigma = `sigma'
                ereturn local cmd "intreg"
		exit
        }
	if ("`e(predictnl_altV)'"!="" & "`e(predictnl_altb)'"!="") {
		local bnom "`e(predictnl_altb)'"
		local vnom "`e(predictnl_altV)'"
		ereturn matrix  `bnom' = `b2'
		ereturn matrix  `vnom' = `v2'
	}
	else {
		ereturn post `b2' `v2', noclear
	}
end

program CheckValid, eclass
	args command term touse var

	capture drop `var'
	capture noi `command', if `touse'
	if _rc {
		di as err `"`term' invalid"'
		exit 198
	}
end

program CheckBeta, eclass
	args f exp touse pvars pcoms force

	tempvar new
	tempname V oldest

	capture ExpEval `new' `"`exp'"' `touse' "`pvars'" `pcoms'
	capture assert reldif(`new',`f') < 1e-12 if `touse'
	if _rc {
		di as err /*
*/ "expression unsuitable for numerical derivative calculation"
		exit 498
	}

	if "`force'"=="" {
		if ("`e(predictnl_altV)'"!="") {
			local vnom "`e(predictnl_altV)'"
			tempname valt 
			matrix `valt' = e(`vnom')
			mat `V' = `valt'
		}
		else {
			mat `V' = e(V)
		}
		
		local k = colsof(`V')
		if `k' == 0 {
			di as err "no model coefficients"
			exit 322
		}
		mat `V'[1,1] = I(`k')
	
		_estimates hold `oldest', copy	
		preserve
		capture noisily nobreak {
			if ("`e(predictnl_altV)'"!="") {
				local vnom "`e(predictnl_altV)'"
				eret matrix V_series = `V'
				tempname valt 
				matrix `valt' = e(`vnom')
				eret matrix `vnom' = `valt'
			}
			else {
				eret repost V = `V'
			}
			capture drop `new'
			local scalars : e(scalars)
			foreach s of local scalars {
				if e(`s')~=int(e(`s')) {
					ereturn local `s' 
				}
			}
			tsrevar `e(depvar)', list
			if "`r(varlist)'"!="" {
				foreach k of varlist `r(varlist)' {
					capture replace `k' = 0
				}
			}
			capture ExpEval `new' `"`exp'"' `touse' "`pvars'" /*
				*/ `pcoms'
			capture assert reldif(`new',`f') < 1e-12 if `touse'
			if _rc {
				di as err /*
*/ "expression is a function of possibly stochastic quantities other than e(b)"
				exit 498
			}
		}
		restore
		_estimates unhold `oldest'
		if _rc {
			exit _rc
		}
	}
end

program Post, eclass /* b j deltab */
	tempname b2 
	mat `b2' = `1'
	mat `b2'[1,`2'] = `1'[1,`2'] + (`3')
	if ("`e(predictnl_altb)'"!="") {
		local bnom "`e(predictnl_altb)'"
		ereturn matrix `bnom' = `b2'
	}
	else {
		ereturn repost b=`b2'
	}
end

program Scorebeta 
	syntax newvarname [if] [in] [, eq(passthru)]

	tempname beta
	if ("`e(predictnl_altb)'"!="") {
		local bnom "`e(predictnl_altb)'"
		tempname balt 
		matrix `balt' = e(`bnom')
		matrix `beta' = `balt'
	}
	else {
		matrix `beta' = e(b)
	}

	qui mat score double `varlist' = `beta' `if' `in', `eq'
end

program CheckOpts, sclass
	syntax [,  se(string) VARiance(string) wald(string) /* 
		*/ p(string) ci(string)] 

	if `"`se'"'!="" {
		local wc : word count `se'
		if `wc' > 1 {
			di as err "may only specify one se variable"
			exit 103
		}
		confirm new variable `se'
	}
	if `"`variance'"'!="" {
		local wc : word count `variance'
		if `wc' > 1 {
			di as err "may only specify one var variable"
			exit 103
		}
		confirm new variable `variance'
	}
	if `"`wald'"'!="" {
		local wc : word count `wald'
		if `wc' > 1 {
			di as err "may only specify one Wald variable"
			exit 103
		}
		confirm new variable `wald'
	}
	if `"`p'"'!="" {
		local wc : word count `p'
		if `wc' > 1 {
			di as err "may only specify one p variable"
			exit 103
		}
		confirm new variable `p'
	}
	if `"`ci'"'!="" {
		local wc : word count `ci'
		if `wc' != 2 {
			di as err "must specify exactly two ci variables"
			exit cond(`wc'<2,102,103)
		}
		confirm new variable `ci'
		local ci1 : word 1 of `ci'
		local ci2 : word 2 of `ci'
	}
	sreturn local se "`se'"
	sreturn local var "`variance'"
	sreturn local wald "`wald'"
	sreturn local p "`p'"
	sreturn local ci1 "`ci1'"
	sreturn local ci2 "`ci2'"
end

program DenomDOF, rclass
	if "`e(cmd)'" != "" {
		return scalar df_r = e(df_r)
		exit
	}
	capture est dir
	if !_rc {
		return scalar df_r = _result(5)
		exit
	}
	return scalar df_r = .
end

program FixExp, rclass
	args exp com
	while `"`exp'"' != "" {
		gettoken ub exp: exp, /*
			*/ parse(`" "`'~:;,<>\/?!@|#$%^&*()-+=[]{}"') quotes
		if `"`ub'"' != "_b" & `"`ub'"' != "_se" {
			local myexp `"`myexp'`ub'"'
			continue
		}
		gettoken bracket exp : exp, parse(" [")
		if `"`bracket'"' != "[" {             /* False alarm */
			local myexp `"`myexp'`ub'`bracket'"'
			continue
		}
		gettoken arg exp: exp, parse(" ]")
		if "`com'"=="tobit" | "`com'"=="cnreg" {
			local arg : subinstr local arg "_se" "/sigma"
		}
		else {                        /* ologit, oprobit */
			local arg : subinstr local arg "_cut" "/cut"
		}
		local myexp `"`myexp'`ub'`bracket'`arg'"'
	}
	return local exp `"`myexp'"'
end

program define _under_score_not
	syntax [anything], [laexp(string)]

	capture expr_query `laexp' 
	local rc =_rc
	if ("`e(cmd_predictnl)'"!="") {
		local cmd "`e(cmd_predictnl)'"
	}
	else {
		local cmd "`e(cmd)'"
	}
	local lista "`e(predictnlprops)'"
	local k1: list sizeof lista
	local k = 0 
	local tiene ""
	if (`rc'==0) {
		local a "is well defined"
		local b "but not for the"
		forvalues i=1/`k1' {
			local y: word `i' of `lista'
			if ("`r(has`y')'"!="") {
				local k = `k' + 1
				local tiene "`tiene' `y'[]"
			}
		}
		if (`k'==1) {
			display as error "{bf:`tiene'} not allowed with {bf:`cmd'}"
			if ("`cmd'"=="npregress series") {
				di as err "{p 4 4 2}" 
				di as err "{bf:predictnl} with {bf:`cmd'} `a'" 
				di as err "for functions of the mean `b'" 
				di as err "reported effects."
				di as smcl as err "{p_end}"
			}
			exit 198		
		}
		if (`k'==2) {
			local uno: word 1 of `tiene'
			local dos: word 2 of `tiene'
			local todos "`uno' and `dos'"
			display as error "{bf:`todos'} not allowed with {bf:`cmd'}"
			if ("`cmd'"=="npregress series") {
				di as err "{p 4 4 2}" 
				di as err "{bf:predictnl} with {bf:`cmd'} `a'" 
				di as err "for functions of the mean `b'" 
				di as err "reported effects."
				di as smcl as err "{p_end}"
			}
			exit 198			
		}
		if (`k'>2){
			local todos ""
			forvalues i=1/`k' {
				local x: word `i' of `tiene'
				if (`i'==`k') {
					local todos "`todos' and `x'"
				}
				else {
					local todos "`todos' `x',"
				}
			}
			di as err "{bf:`todos'} not allowed with {bf:`cmd'}"
			di as err "{p 4 4 2}" 
			if ("`cmd'"=="npregress series") {
				di as err "{bf:predictnl} with {bf:`cmd'} `a'" 
				di as err "for functions of the mean `b'" 
				di as err "reported effects."
				di as smcl as err "{p_end}"
			}
			exit 198	
		}
	}
end


exit

Internal documentation

The delta-method formula is

           V = GVG'

where G is the derivative vector of predict_exp with respect to e(b).

