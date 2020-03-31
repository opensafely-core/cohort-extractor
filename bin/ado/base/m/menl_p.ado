*! version 1.1.7  15apr2019

program menl_p
	version 15
	
	if "`e(cmd)'" != "menl" {
		di "{err}last estimates not found"
		exit 198
	}
	Predict `0'
end

program define Predict, sortpreserve

	tempname EXPR
	mata: _menl_create_instance("`EXPR'")

	cap tsset
	local tsset = !c(rc)

	if !`tsset' {
		tempvar panels tsvar
	}

	cap noi Predict1 `EXPR' `tsvar' `panels' : `0'
	local rc = c(rc)

	mata: _menl_remove_instance(`EXPR',"`EXPR'")

	if !`tsset' {
		/* -predict- tsset the data with tempvars		*/
		cap tsset
		if !c(rc) {
			tsset, clear
		}
		capture // clear c(rc)
	}
	exit `rc'
end

program define Predict1
	_on_colon_parse `0'

	local EXPR `s(before)'
	local 0 `s(after)'

	gettoken EXPR tsvname: EXPR

	local EXPR : list retokenize EXPR

	if "`tsvname'" != "" {
		gettoken tsvname panels: tsvname

		local tsvname : list retokenize tsvname
		local panels : list retokenize panels
	}

	syntax  anything(id="stub*, newvarlist or newvar = {param:}" ///
		equalok) 	///
		[if] [in] [,				///
		REFfects				///
		RELEVel(string)				///
		reses(string)	 			///
		yhat					///
		mu					///
		RESiduals				///
		RSTAndard				///
		FIXEDonly				///
		ITERate(passthru)			///
		TOLerance(passthru)			///
		NRTOLerance(passthru)			///
		NONRTOLerance				///
		TRace					///
		log					///
		skip					///
		*					///
	]
	/* undocumented: trace	- __sub_expr trace
	 *  		 skip 	- skip coef names no longer in stripe
	 *  		 log	- RE PNLS optimization log		*/
	marksample touse
	
	local implied = 0
	if "`c(marginscmd)'" == "on" {
		if "`yhat'" != "" {
			if "`fixedonly'" == "" {
				local fixedonly fixedonly
				local implied = 1
			}
		}
		local skip skip
	}
	if "`mu'" != "" {
		if "`yhat'" != "" {
			di as err "{p}options {bf:mu} and {bf:yhat} cannot " ///
			 "both be specified{p_end}"
			exit 184
		}
		local yhat yhat
	}
	if "`options'" != "" {
		ParseParameters, `options'
		local parameters `s(parameters)'
		local plist `s(plist)'
		local k : list sizeof plist
		if "`parameters'"!="" & "`c(marginscmd)'"=="on" {
			if `k' != 1 {
				di as err "{p}{bf:predict}'s option " ///
				 "{bf:parameters} with more than one " ///
				 "parameter is not appropriate with " ///
				 "{bf:margins}{p_end}"
				exit 322
			}
			if "`fixedonly'" == "" {
				local fixedonly fixedonly
				local implied = 1
			}
		}	
	}
	local STAT `yhat' `residuals' `rstandard' `reffects' `parameters'
	opts_exclusive `"`STAT'"'

	if `"`reses'"' != "" {
		local sevlist `reses'
		local reses reses
		local STAT `yhat' `residuals' `rstandard' `parameters' ///
			`fixedonly'
		opts_exclusive `"`STAT' reses"'
		
		if "`reffects'" == "" {
			di as err "{p}option {bf:reses()} requires the " ///
				"{bf:reffects}  option{p_end}"
			exit 198
		}
	}
	
	if "`reffects'" != "" {
		opts_exclusive "`reffects' `fixedonly'"
	}
	
	if `"`relevel'"' != `""' {
		opts_exclusive "relevel(`relevel') `fixedonly'"
	}
	local klev = e(k_hierarchy)
	if "`fixedonly'" == "" {
		if "`nrtolerance'"!="" & "`nonrtolerance'"!="" {
			di as err "{p}option {bf:nrtolerance(#)} and " ///
			 "{bf:nonrtolerance} cannot both be specified{p_end}"
			exit 184
		}
		local relevel0 `relevel'
		menl_validate_relevel, relevel(`relevel')
		local relevel `s(relevel)' 	// unabr variable
		local ilev = `s(ilevel)'	// index level for relevel
		local repath `s(repath)'	// canonical path
		local klev = `s(klevels)'	// # levels in the model
		forvalues i=1/`klev' {
			local path`i' `s(path`i')'
			local lvs`i' `s(lvs`i')'
			local klv`i' = `s(klv`i')'	// # LV in path
			local nlv`i' = `s(nlv`i')'	// cumulative count
		}
		if !`klev' {
			if "`reffects'" != "" {
				di as err "{p}option {bf:reffects} not "  ///
				 "allowed; no random effects are in the " ///
				 "model{p_end}"
				exit 322
			}
			/* no random effects				*/
			local fixedonly fixedonly
		}
	}
	else {
		if "`iterate'" != "" {
			di as err "{p}options {bf:iterate(#)} and " ///
			 "{bf:fixedonly} cannot both be specified{p_end}"
			exit 184
		}
		if "`tolerance'" != "" {
			di as err "{p}option {bf:tolerance(#)} and " ///
			 "{bf:fixedonly} cannot both be specified{p_end}"
			exit 184
		}
		if "`nrtolerance'" != "" {
			di as err "{p}option {bf:nrtolerance(#)} and " ///
			 "{bf:fixedonly} cannot both be specified{p_end}"
			exit 184
		}
		if "`nonrtolerance'" != "" {
			di as err "{p}option {bf:nonrtolerance} and " ///
			 "{bf:fixedonly} cannot both be specified{p_end}"
			exit 184
		}
	}
	ParseIterTol, `iterate' `tolerance' `nrtolerance' `nonrtolerance'
	local iterate = `s(iterate)'
	local tolerance = `s(tolerance)'
	local nrtolerance = `s(nrtolerance)'	 // missing if nonrtolerance

	local e_exprs `e(expressions)'
	local ke_expr : list sizeof e_exprs
	forvalues i=1/`ke_expr' {
		tempvar temp`i'
		local exname`i' : word `i' of `e_exprs'
		local elist `elist' `exname`i''
		local e_expr`i' `"`e(ex_`exname`i'')'"'
		local tvars `tvars' `temp`i''
	}
	
	local spec `"`anything'"'
	gettoken vtyp : spec
	if inlist("`vtyp'", "float", "double", "byte", "int" "long") {
		gettoken vtyp spec: spec
	}
	else {
		local vtyp float
	}

	gettoken expr spec : spec , match(paren)

        if "`paren'" == "(" {	// list of subexpr param to be predicted	
		local STAT "`yhat'`reffects'`residuals'`rstandard'`parameters'"
		local STAT "`STAT'`reses'"
		if `:list sizeof STAT' {
			di as err "{p}option {bf:`STAT'} may not be " ///
			 "specified when predicting specific parameters{p_end}"
			exit 198
		}
		local expr1 `expr'
		if "`elist'" == "" {
			di as err "{p}invalid specification "               ///
			 "{bf:(`expr1')}; there are no named expressions "  ///
			 "in the model{p_end}"
			exit 322
		}
		// Now loop through and get remaining subexpr
		local i 1
		while "`spec'" != "" {
			gettoken expr spec : spec, match(paren)
			if "`paren'" == "(" {
				local `++i'
				local expr`i' `expr'
			}
			else {
				di as err "{p}{bf:`expr'} not allowed{p_end}"
				exit 198
			}
		}
		local kexpr `i'

		forvalues i=1/`kexpr' {
			ParseExprSpec, espec(`expr`i'') elist(`elist') ///
				kexpr(`ke_expr')

			local jexpr = `s(jexpr)'
			local exname `s(exname)'
			local tvar : word `jexpr' of `tvars'
			local tlist `tlist' `tvar'
			local vlist `vlist' `vtyp' `exname'  // same type
			local exlist `exlist' `exname`jexpr''
		}
		_stubstar2names `vlist', nvars(`kexpr') nosubcommand
		local varn `s(varlist)'
		local vtyp `s(typlist)'

		local type "sexp"

		local parameters parameters
		// predict `vtyp' () (), ...
        }
	else if "`parameters'" != "" {
		if "`plist'" != "" {
			local kexpr : list sizeof plist
			forvalues i=1/`kexpr' {
				local pname : word `i' of `plist'
				local j : list posof "`pname'" in elist
				if !`j' {
					di as err "{p}invalid "              ///
					 "{bf:parameters()} specification; " ///
					 "parameter {bf:`pname'} not in "    ///
					 "the model{p_end}"
					exit 198
				}
				local tvar : word `j' of `tvars'
				local tlist `tlist' `tvar'
				local exlist `exlist' `exname`j''
			}
		}
		else {
			/* estimate all parameters
			 * ke_expr = total # of named expressions	*/
			local kexpr = `ke_expr'
			local tlist `tvars'
			local exlist `elist'
		}
		
		_stubstar2names `anything', nvars(`kexpr') nosubcommand
		local varn `s(varlist)'
		local vtyp `s(typlist)'
		
		local type "sexp"
	}
	else if "`reffects'" != "" {
		if "`relevel0'" == "" {
			/* all random effects				*/
			local kvar = `nlv`klev''
		}
		else {
			/* for specified relevel only			*/
			local kvar = `klv`ilev''
		}
		_stubstar2names `anything', nvars(`kvar') nosubcommand
		local varn `s(varlist)'
		local vtyp `s(typlist)'
		local type "RE"
		
		if "`reses'" != "" {
			_stubstar2names `sevlist', nvars(`kvar') ///
				nosubcommand

			local sevarn `s(varlist)'
			local sevtyp `s(typlist)'
		}
	}
	else {
		_stubstar2names `anything', nvars(1) nosubcommand
		local varn `s(varlist)'
		local vtyp `s(typlist)'
		
		local type "`yhat'`residuals'`rstandard'"
		if "`type'" == "" {
			local type yhat
			di "{txt}(option {bf:yhat} assumed)"
		}
	}
	/* construct Mata __menl_expr object from ereturn		*/
	tempname b
	tempvar tivar
	tempvar touse2
	if "`panels'" == "" {
		/* -panels- name not passed down from top level 	*/
		tempvar panels
	}
	menl_ereturn_construct, obj(`EXPR') touse(`touse') touse2(`touse2') ///
		tivar(`tivar') b(`b') `skip' tsvname(`tsvname') ///
		panels(`panels') nodepmarkout

	local touse1 `s(touse)'	// equation estimation sample
	local rc = 0
	if "`fixedonly'" == "" {
		/* compute BLUPs					*/
		/* REs are needed everywhere except if -fixedonly- 	*/
		PredictBLUPs, object(`EXPR') iterate(`iterate')           ///
			tolerance(`tolerance') nrtolerance(`nrtolerance') ///
			touse(`touse1') `reses' `trace' `log' touse2(`touse2')
		/* final computations using blups			*/
		if "`type'" == "RE" {
			/* reset parameters, BLUPs scales RE covariance	*/
			mata: _menl_set_parameters(`EXPR',"`b'")
			if `rc' {
				di as err "{p}`errmsg'{p_end}"
				exit `rc'
			}
			if "`relevel0'" == "" {
				/* all random effects			*/
				local i1 = 1
			}
			else {
				local i1 = `ilev'
			}
			local ivar = 0
			forvalues i=`i1'/`ilev' {
				local k : word count `lvs`i''
				forvalues j=1/`k' {
					tempvar re`++ivar'
					local revars `revars' `re`ivar''
					if "`reses'" != "" {
						tempvar se`ivar'
						local sevars `sevars' `se`ivar''
					}
				}
			}
			local path `path`ilev''

			mata: _menl_blup_post(`EXPR',"`path'","`revars'", ///
					"`sevars'", ("`relevel0'"==""))
			local ivar = 0
			/* touse is the full estimation sample		*/
			forvalues i=`i1'/`ilev' {
				GenerateREvars, lvs(`lvs`i'') varn(`varn') ///
					vtyp(`vtyp') revars(`revars')      ///
					path(`path`i'') touse(`touse')     ///
					sevarn(`sevarn') sevtyp(`sevtyp')  ///
					sevars(`sevars')

				local varn `s(varn)'
				local vtyp `s(vtyp)'
				local revars `s(revars)'
				local sevarn `s(sevarn)'
				local sevtyp `s(sevtyp)'
				local sevars `s(sevars)'
			}
			exit
		}
	}
	if "`type'" == "sexp" {
		mata: _menl_post_eval_expr(`EXPR',"`elist'","`tvars'", ///
			"`repath'")
		local extouse `"`s(touse)'"'
		forvalues i=1/`kexpr' {
			local tvar : word `i' of `tlist'
			local vt : word `i' of `vtyp'	
			local var : word `i' of `varn'
			local exn : word `i' of `exlist'
			local j : list posof "`tvar'" in tvars
			local touse : word `j' of `extouse'
			/* expression estimation sample			*/
			gen `vt' `var' = `tvar' if `touse'
			if `klev'>0 & "`fixedonly'"!="" {
				local lab "fixed portion"
				if `implied' {
					local lab "`lab' implied"
					local lab "Parameter `exn', `lab'"
				}
				else {
					local lab "Parameter `exn', `lab'"
				}
			}
			else {
				local lab "Parameter `exn'"
			}
			label variable `var' "`lab'"
		}		
		exit
	}
	tempvar tvar

	PredictStat `tvar', object(`EXPR') stat(`type') relevel(`relevel') ///
			`fixedonly'

	gen `vtyp' `varn' = `tvar' if `touse' // full estimation sample
	if "`type'" == "yhat" {
		local lab "Mean prediction"
	}
	else if "`type'" == "residuals" {
		local lab "Residuals"
	}
	else { // "`type'" == "rstandard" 
		local lab "Standardized residuals"
	}
	if "`relevel0'" != "" {
		label variable `varn' "`lab', level(`relevel')"	
	}	
	else if `klev'>0 & "`fixedonly'"!="" {
		if `implied' {
			label variable `varn' "`lab', fixed portion implied"	
		}
		else {
			label variable `varn' "`lab', fixed portion"
		}
	}
	else {
		label variable `varn' "`lab'"
	}
end

program define PredictBLUPs
	syntax, object(name) iterate(integer) tolerance(real) ///
		nrtolerance(real) touse(varname) [ touse2(varname) reses ///
		trace log ]

	local EXPR `object'

	if "`e(Cns)'" != "" {
		tempname Cm T a b est
		local cnsopt cns(`Cm' `T' `a')

		/* restripe coefficient vector to the same state that
		 * it was just after parsing. Stata can adorn o.
		 * operators						*/
		mat `b' = e(b)
		local stripe `e(bstripe)'
		mat colnames `b' = `stripe'
		mat `Cm' = e(Cns)
		local cstripe : colfullnames `Cm'
		local k = colsof(`Cm')
		local astripe : word `k' of `cstripe'
		local cstripe `"`stripe' `astripe'"'
		mat colnames `Cm' = `cstripe'
		estimates store `est'

		/* do not really need matrix Cm for factor variable 
		 *  auto constraints					*/
		_make_constraints, b(`b') constraints(`Cm')

		/* make all stripes consistent, stata interchanges
		 * o. and b. operators					*/
		mat `T' = e(T)
		mat rownames `T' = `stripe'
		mat `Cm' = e(Cm)
		mat colnames `Cm' = `cstripe'
		mat `a' = e(a)
		mat colnames `a' = `stripe'

		qui estimate restore `est'

		estimates drop `est'
	}
	/* missing nrtolerance means nonrtolerance			*/
	/* REs are needed everywhere except if -fixedonly- 		*/
	mata: _menl_lbates_blups(`EXPR',`iterate',`tolerance',`nrtolerance', ///
			"`log'", ("`reses'"!=""),("`e(method)'"=="REML"),    ///
			"`Cm' `T' `a'", "`touse2'")
end

program define PredictStat
	syntax newvarlist(max=1), object(string) stat(string) ///
		[ relevel(string) fixedonly ]

	mata: _menl_predict_stat(`object',"`varlist'","`stat'","`relevel'", ///
			("`fixedonly'"!=""))
end

program define GenerateREvars, sclass
	syntax, lvs(string) varn(string) vtyp(string) revars(string) ///
			path(string) touse(string) [ sevarn(string)  ///
			sevtyp(string) sevars(string) ]

	local k : word count `lvs'
	forvalues j=1/`k' {
		local lv : word `j' of `lvs'

		gettoken var varn : varn
		gettoken ty vtyp : vtyp
		gettoken revar revars : revars
		gen `ty' `var' = `revar' if `touse'
		local lab "BLUP r.e. for `lv'[`path']"
		label var `var' "`lab'"
		if "`sevarn'" != "" {
			gettoken var sevarn : sevarn
			gettoken ty sevtyp : sevtyp
			gettoken sevar sevars : sevars
			gen `ty' `var' = `sevar' if `touse'
			local lab "BLUP r.e. std. errors for `lv'[`path']"
			label var `var' "`lab'"
		}
	}
	/* return whats left						*/
	sreturn local varn `varn'
	sreturn local vtyp `vtyp'
	sreturn local revars `revars'
	sreturn local sevarn `sevarn'
	sreturn local sevtyp `sevtyp'
	sreturn local sevars `sevars'
end

program define ParseParameters, sclass
	syntax, [ PARAMeters * ]

	if "`parameters'" == "" {
		local 0, `options'
		syntax, [ PARAMeters(string) * ]

		sreturn local plist `parameters'
	}
	if "`options'" != "" {
		gettoken opt rest : options, bind
		di as err "{p}option {bf:`opt'} not allowed{p_end}"
		exit 198
	}
	sreturn local parameters parameters
end

program define ParseIterTol, sclass
	syntax, [ ITERate(passthru) TOLerance(passthru) ///
		NRTOLerance(passthru) NONRTOLerance ]

	if "`iterate'" == "" {
		sreturn local iterate = 50
	}
	else {
		local 0, `iterate'
		syntax, ITERate(integer)

		if `iterate'<0 | floor(float(`iterate'))!=`iterate' {
			di as err "{p}invalid {bf:iterate(#)} " ///
			 "specification; nonnegative integer required{p_end}"
			exit 198
		}
		sreturn local iterate = `iterate'
	}

	if "`tolerance'" == "" {
		sreturn local tolerance = 1E-6
	}
	else {
		local 0, `tolerance'
		syntax, TOLerance(real)

		if `tolerance' < 0 {
			di as err "{p}invalid {bf:tolerance(#)} " ///
			 "specification; nonnegative real " ///
			 "value required{p_end}"
			exit 198
		}
		sreturn local tolerance = `tolerance'
	}
	if "`nrtolerance'"!="" & "`nonrtolerance'"!="" {
		di as err "{p}option {bf:nrtolerance(#)} and " ///
		 "{bf:nonrtolerance} cannot both be specified{p_end}"
		exit 184
	}
	if "`nonrtolerance'" != "" {
		sreturn local nrtolerance .
	}
	else if "`nrtolerance'" == "" {
		sreturn local nrtolerance = 1E-5
	}
	else {
		local 0, `nrtolerance'
		syntax, NRTOLerance(real)

		if `nrtolerance' < 0 {
			di as err "{p}invalid {bf:nrtolerance(#)} " ///
			 "specification; nonnegative real " ///
			 "value required{p_end}"
			exit 198
		}
		sreturn local nrtolerance = `nrtolerance'
	}
end

program define ParseExprSpec, sclass
	syntax, espec(string) elist(string) kexpr(integer)

	gettoken exname expr : espec, parse("=")
	if "`exname'" == "`espec'" {
		di as err "{p}invalid specification "                 ///
		 "{char 96}`espec'{char 39}; equal sign required to " ///
		 "delimit {it:newvar} from "                          ///
		 "{bf:{char 123}}{it:param}{bf:{char 58}{char 125}}{p_end}"
		exit 198
	}
	gettoken equal expr : expr, parse("=")
	gettoken lb expr : expr, parse("{")
	if "`lb'" != "{" {
		di as err "{p}invalid specification "                  ///
		 "{char 96}`espec'{char 39}; parameter specification " ///
		 "must be enclosed in braces "                         ///
		 "{bf:{char 123}}{it:param}{bf:{char 58}{char 125}}"
		exit 198
	}
	gettoken expr junk : expr, parse(":")
	gettoken colon rb : junk, parse(":")
	local rb : list retokenize rb
	if "`colon'"!=":" | "`rb'" != "}" {
		di as err "{p}invalid specification "                  ///
		 "{char 96}`espec'{char 39}; parameter specification " ///
		 "must be in the form "                                ///
		 "{bf:{char 123}}{it:param}{bf:{char 58}{char 125}}"
		exit 198
	}
	local exname : list retokenize exname
	local expr : list retokenize expr
	local found = 0
	forvalues j=1/`kexpr' {
		local exprj : word `j' of `elist'
		if "`exprj'" == "`expr'" {
			local found = `j'
			continue, break
		}
	}
	if !`found' {
		di as err "{p}parameter {bf:`expr'} not found; available " ///
		 "parameters are {bf:`elist'}{p_end}"
		exit 198
	}
	sreturn local jexpr = `found'
	sreturn local exname `exname'
end

exit
