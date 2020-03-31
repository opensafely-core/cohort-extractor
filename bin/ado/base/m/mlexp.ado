*! version 2.1.0  25mar2018
program mlexp,	properties(svyb svyj svyr swml)	///
		eclass byable(onecall) sortpreserve
	version 14

        local vv : di "version " string(_caller()) ":"

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	
	`BY' _vce_parserun mlexp, jkopts(eclass) noeqlist: `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"mlexp `0'"'
		exit
	}
	
	if replay() {
		if "`e(cmd)'"!="mlexp" { 
			exit 301 
		} 
		if _by() { 
			exit 190 
		}
		Display `0'
		exit
	}
	`vv' ///	
	`BY' Estimate `0'

	ereturn local cmdline `"mlexp `:list clean 0'"'
end

program Estimate, eclass byable(recall) sortpreserve

	version 14

        local version = _caller()
        local vv : di "version `version':"
	
	local zero `0'		// backup copy

	local wtsyntax [aw fw pw iw]

	local type
	gettoken expr 0 : 0 , match(paren)
	if "`paren'" != "(" {
		// -mlexp- only accepts an expression bound in parens
		// no programmable version -- use -ml- instead
		di as err "invalid syntax; expression representing the " ///
		 "log-likelihood function must be enclosed in "          ///
		 "parentheses, {bf:(}{it:<lexp>}{bf:)}{p_end}"
		exit 198
	}

	local expr `expr'
	// Back up expression to return to user
	local origexpr `"`expr'"'

	// qui to suppress repeated '(... weights assumed)' message 
	qui syntax [if] [in] `wtsyntax' [, 		///
			VAriables(varlist numeric ts fv) ///
			NOLOg LOg			///
			VCE(passthru)			///
			FROM(string)			///
			Level(cilevel)			///
			title(string)			///
			title2(string)			///
			debug				///
			* ]				// derivative()s
	local WEIGHT `weight'	// backup, since we call syntax again
	local EXP    `"`exp'"'	// backup, since we call syntax again

	marksample touse
	if "`variables'" != "" {
		markout `touse' `variables'
	}
	
	_vce_parse, argopt(CLuster) opt(OIM OPG Robust) : 	///
		[`WEIGHT'`EXP'], `vce'
	if "`r(cluster)'" != "" {
		local clustvar `r(cluster)'
		local vce cluster
		markout `touse' `clustvar'
	}
	else if "`r(vce)'" != "" {
		local vce `r(vce)'
	}
	else {
		local vce oim
	}

	// Parse display options
	_get_diopts diopts options, `options'

	// Parse ml options
	mlopts mlopts options, `options'
	if "`s(constraints)'" != "" {
		local constraints constraints(`s(constraints)')
	}
	local collinear `s(collinear)'

	tempname parmvec parseobj
	.`parseobj' = ._parse_sexp_c.new

	local params
	`vv' _parse_sexp, parseobj(`parseobj') expression(`expr') lfonly ///
		`collinear'
	
	if (`version'<14) local expr `r(expr)'
	else local expr `r(exprlf)'

	local params `r(parmlist)'
	local kp : list sizeof params
	if `kp' == 0 { 
		di as err "{p}there are no parameters or linear-form " ///
		 "equations in the expression{p_end}"
		di as txt "{phang}Be sure to enclose all parameters and " ///
		 "linear-form equations in braces, "                      ///
		 "{bf:{{it:eqname}:{it:equation}}} or "                   ///
		 "{bf:{{it:parameter}}}{p_end}"
		exit 198
	}
	tempname parmvec
	matrix `parmvec' = r(initmat)

	local lexp `expr'			// for return to user
	mat colnames `parmvec' = `params'
	local searchoff = 0
	// from() overrides default initial values of zero
	if "`from'" != "" {
		_parse_initial `"`from'"' : `parmvec' `"`params'"'
		local searchoff = 1
	}	
	if `version' < 14 {
		foreach parm of local params {
			local j = colnumb(`parmvec', "`parm'")
			local expr : subinstr local expr "{`parm'}" ///
				"`parmvec'[1,`j']", all
		}
		local kep = `kp'
		local eqparm `params'
		local what parameter
		local clist J(1,0,0)
	}
	else {
		tempname peq
		// equation and variable names in the same order as
		// the parameter vector	
		local eqnames : coleq `parmvec'
		local eqnames : list uniq eqnames
		local keq : list sizeof eqnames
		local none _
		local clist (
		forvalues i=1/`keq' {
			tempvar xb`i'

			local eq : word `i' of `eqnames'
			mat `peq' = `parmvec'[1,"`eq':"]
			local vars `.`parseobj'.lcvarfetch `eq''
			local cons = `.`parseobj'.lcconst `eq''
			if strlen("`vars'") {
				local vlist `"`vlist'`sep'`vars'"'
			}
			else {
				local vlist `"`vlist'`sep'`none'"'
			}
			local clist "`clist'`c'`cons'"
			mat score double `xb`i'' = `peq' if `touse'

			local expr : subinstr local expr "{`eq':}" ///
				"`xb`i''", all
			local xbvlist `xbvlist' `xb`i''
			local sep |
			local c ,
		}
		local clist "`clist')"
		local kep = `keq'
		local eqparm `eqnames'
		local what equation
	}
	
	// parse derivative() -- in `options'
	local hasderiv = 0
	if `"`options'"' != "" {
		forvalues k=1/`kep' {
			tempvar d`k'
			local d`k'v `d`k''
			qui gen double `d`k'' = .
			local dvlist `dvlist' `d`k''
		}
		local zero `0'
		local 0 , `options'

		syntax [, DERIVative(string) * ]
		while "`derivative'"' != "" {
			local sep
			local hasderiv = 1
			if `version' < 14 {
				ParseDeriv13, deriv(`derivative') ///
					mlname(1)                 ///
					parseobj(`parseobj')      ///
					params(`params')          ///
					paramvec(`parmvec') `delist'

				local klist `r(klist)'

				foreach k of local klist {
					local d`k'e `"`r(d`k'e)'"'
					local d`k'e0 `"`r(d`k'e0)'"'
					local dklist `"`dklist' d`k'e"'
				}
			}
			else {
				ParseDeriv `xbvlist', deriv(`derivative') ///
					mlname(1)                         ///
					parseobj(`parseobj')              ///
					eqnames(`eqnames') `delist'

				local k = `r(k)'
				local d`k'e `r(xderiv)'
				local d`k'e0 `r(deriv)'
				local dklist `"`dklist' d`k'e"'
			}
			local 0 , `options'
			syntax [, DERIVative(string) * ]
		}
		// verify that we have a deriv for each param/eq
		if `hasderiv' {
			forvalues k=1/`kep' {
				if `"`d`k'e'"' != "" {
					local delist `"`delist'`sep'`d`k'e'"'
				}
				else {
					local ep : word `k' of `eqparm' 
					di as err "{p}no derivative for " ///
					 "`what' `ep' has been specified{p_end}"
					exit 498
				}
				local sep |
			}
		}
	}
	if !`hasderiv' & "`debug'"!="" {
		di as err "{p}option {bf:debug} is only allowed when the " ///
		 "{bf:derivative()} option is specified{p_end}"
		exit 198
	}
	if `"`options'"' != "" {
		local 0 : subinstr local 0 "," ""
		local 0 `=trim(`"`0'"')'
		local k : list sizeof 0
		local opt = plural(`k',"option")
		local is = plural(`k',"is","are")
		di as err "{p}`opt' `is' {bf:`0'} not allowed{p_end}"
		exit 198
	}
	local kpc = `kp'
	if "`constraints'" != "" {
		_make_constraints, b(`parmvec') `constraints'
		if `e(ncns)' {
			tempname Cm T a
			mat `Cm' = e(Cm)
			mat `T' = e(T)
			mat `a' = e(a)
			/* stripe will not be modified			*/
			mat `parmvec' = `parmvec'*`T'*`T'' + `a'
			local kpc = colsof(`T')
		}
	}

	qui count if `touse'
	if r(N) < `kpc' {
		di as err "{p}cannot have fewer observations than " ///
		 "parameters{p_end}"
		exit 2001
	}

	// weights
	if "`WEIGHT'" != "" {
		// needed in case the user specifies an expression for weights
		tempvar weightvar
		qui gen double `weightvar' `EXP' if `touse'
	}
	tempname initvec
	matrix `initvec' = `parmvec'
	tempvar lf
	// allow to see the error
	cap gen double `lf' = `expr' if `touse'
	if _rc {
		cap drop `lf'
		cap noi gen double `lf' = `expr' if `touse'
		local rc = c(rc)
		di as txt "{phang}The likelihood expression could not be " ///
		 "evaluated. Check the syntax of the expression.{p_end}"
		exit `rc'
	}

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	// estimation
	if "`log'" == "" {
		di
	}
	// estimation, sets ereturn
	mata: _mlexp_wrk("`parmvec'","`params'","`eqnames'","`xbvlist'",  ///
		`"`vlist'"',`clist',"`lf'","`touse'",`"`expr'"',          ///
		"`WEIGHT'","`weightvar'","`vce'","`clustvar'",`hasderiv', ///
		`"`dvlist'"',`"`delist'"',"`Cm'",`version',("`log'"!=""), ///
		"`debug'",`"`mlopts'"',`searchoff')

	if (missing(e(k_aux))) {
		/* count the number of ancillary parameters		*/
		local plist `params'
		local kaux = 0
		while "`plist'" != "" {
			gettoken par plist : plist, bind
			gettoken eq var : par, parse(":")
			if "`var'"==":_cons" & "`eq'"!="`eq0'" {
				local `++kaux'
			}
			else {
				local kaux = 0
			}
			local eq0 `eq'
		}
		ereturn scalar k_aux = `kaux'
	}
	ereturn local k_dv = ""		// can't tell -- depends on model
	ereturn local user ""		// hide private Mata function
					// " of no use to end user
	ereturn local k_autoCns ""
	ereturn local which ""
	ereturn scalar df_m = `kp'
	ereturn scalar k_eq_model = 0
	if "`WEIGHT'" != "" {
		ereturn local wtype "`WEIGHT'"
		ereturn local wexp  "`EXP'"
		if "`WEIGHT'" == "fweight" {
			qui summ `weightvar' if `touse', mean
			ereturn scalar N = r(sum)
		}
	}

	if `hasderiv' {
		ereturn local hasderiv "yes"
		forvalues k=1/`kep' {
			local ep : word `k' of `eqparm' 
			ereturn local d_`ep' `d`k'e0'
		}
	}
	
	ereturn matrix init = `initvec'
	
	if `"`title'"' != "" {
		ereturn local usrtitle `"`title'"'
	}
	if `"`title2'"' != "" {
		ereturn local usrtitle2 `"`title2'"'
	}
	
	if "`variables'" != "" {
		ereturn local rhs `variables'
	}
	ereturn hidden scalar version = `version'
	ereturn local params "`params'"
	ereturn local lexp "`lexp'"
	ereturn local marginsprop nochainrule
	ereturn local marginsok default xb
	ereturn local marginsnotok "SCores"
	ereturn local estat_cmd "mlexp_estat"
	ereturn local predict "mlexp_p"
	// For survey data:
	if "`WEIGHT'" == "iweight" {
		ereturn hidden local crittype "log pseudolikelihood"
	}
	ereturn local cmd "mlexp"
	
	Display, level(`level') `diopts'
end

program Display

	syntax [, level(cilevel) * ]

	if "`e(usrtitle)'`e(usrtitle2)'" == "" {
		di
		di as text "Maximum likelihood estimation" 
	}
	else {
		if "`e(usrtitle)'" != "" {
			di as text "`e(usrtitle)'" 
		}
		if "`e(usrtitle2)'" != "" { 
			di as text "`e(usrtitle2)'"
		}
	}		
	_prefix_display, showeqns level(`level') `options'
end

// version < 14 parameter derivatives
program  ParseDeriv13, rclass
	version 13
	syntax, deriv(string) mlname(string) parseobj(name) params(string) ///
		paramvec(name) [ * ]

	_parse_sexp_deriv `"`deriv'"' `"`mlname'"'
	local eqn = real("`s(eqn)'")
	local deriv `s(deriv)'
	local eq `s(param)'
	if `eqn' != 1 {	
		// only 1 eqn in -mlexp- 
		di as err "{p}option {bf: derivatives()} is invalid; " ///
		 "equation `s(eqn)' out of range{p_end}"
		exit 498
	}
	// convert linear combinations to long form
	cap noi _parse_sexp, parseobj(`parseobj') expression(`deriv') noinit
	local rc = c(rc)
	if `rc' {
		di as txt "{phang}An error occurred while parsing the " ///
		 "derivative expression. Check the expression syntax.{p_end}"
		exit `rc'
	}
	local deriv `r(expr)'
	return add

	if `.`parseobj'.islcin `eq'' {
		// equation level derivative, e.g. xb:
		local vlist `.`parseobj'.lcvarfetch `eq''
		local lcderiv : list sizeof vlist
		local eqparm `.`parseobj'.lcparmfetch `eq''
	}
	else {
		di as err "{p}option {bf: derivatives()} is invalid; " ///
		 "parameter `eq' is undeclared{p_end}"
		exit 498
	}
	local jp = 1
	foreach p of local eqparm {
		local k : list posof "`p'" in params
		local 0, `options'
		syntax, [ d`k'e * ]
		if `"`d`k'e'"' != "" {
			di as err "{p}derivative is already defined for " ///
			 "parameter `p'{p_end}"
			exit 498
		}
		if `lcderiv' {
			local var : word `jp' of `vlist'
			local xderiv (`deriv')*`var'
		}
		else local xderiv `deriv'

		local klist `klist' `k'
		return local d`k'e0 `"`xderiv'"'
		// replace par names with paramvec elements
		foreach p of local params {
			local j = colnumb(`paramvec',"`p'")
			local xderiv : subinstr local xderiv "{`p'}" ///
				"`paramvec'[1,`j']", all
		}
		return local d`k'e `"`xderiv'"'
		local `++jp'
	}
	return local klist `klist'
end

// version >= 14 linear form derivatives
program  ParseDeriv, rclass
	version 14
	syntax varlist(numeric), deriv(string) mlname(string) parseobj(name) ///
		eqnames(string) [ * ]

	local vlist `varlist'
	_parse_sexp_deriv `"`deriv'"' `"`mlname'"'
	local eqn = real("`s(eqn)'")
	local deriv `s(deriv)'
	local eq `s(param)'
	if `eqn' != 1 {	
		// only 1 eqn in -mlexp- 
		di as err "{p}option {bf: derivatives()} is invalid; " ///
		 "equation `s(eqn)' out of range{p_end}"
		exit 498
	}
	// convert linear combinations to long form
	cap noi _parse_sexp, parseobj(`parseobj') expression(`deriv') noinit
	local rc = c(rc)
	if `rc' {
		di as txt "{phang}An error occurred parsing the derivative " ///
		 "expression.{p_end}"
		exit `rc'
	}
	if "`r(initmat)'" != "" {
		mat li r(initmat)
	}
	local deriv `r(exprlf)'
	return add

	local k : list posof "`eq'" in eqnames
	if !`k' {
		di as err "{p}invalid derivative; equation `eq' not " ///
		 "found{p_end}"
		exit 498
	}
	local 0, `options'
	syntax, [ d`k'e * ]
	if `"`d`k'e'"' != "" {
		di as err "{p}derivative is already defined for equation " ///
		 "`eq'{p_end}"
		exit 498
	}
	local xderiv `deriv'

	// replace LF names with LF variable
	local i = 0
	foreach eq of local eqnames {
		local xb : word `++i' of `vlist'
		local xderiv : subinstr local xderiv "{`eq':}" "`xb'", all
	}
	return local k = `k'
	return local deriv `deriv'
	return local xderiv `xderiv'
end
exit
