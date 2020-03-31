*! version 1.1.6  22apr2019

program _bayespredict_parse, sclass
	version 16.0

	args paramlist

	local ysimvars $BAYESPR_ysimvars
	if `"`ysimvars'"' == "" {
		exit
	}
	local predynames $BAYESPR_predynames

	local ysimlist
	local residlist
	local residsqlist
	local i 0
	foreach tok of local ysimvars {
		local i = `i' + 1
		local ysimlist `ysimlist' _ysim`i' `tok':_ysim`i'
		local residlist `residlist' _resid`i' `tok':_resid`i'
		local mulist `mulist' _mu`i' `tok':_mu`i'
		local labelind_`tok' `i'
	}
	local maxoutcomes `i'

	_mcmc_parse expand `paramlist'
	local paramlist `s(eqline)'

	local paramlist0 `"`paramlist'"'
	local sexpr `"`paramlist'"'

	local predsumlist $BAYESPR_predstats

	local paramlist
	local ct 1
	while `ct' > 0 {
		local sexpr : subinstr local sexpr " }" "}", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local sexpr : subinstr local sexpr "{ " "{", count(local ct)
	}
	local ct 1
	while `ct' > 0 {
		local sexpr : subinstr local sexpr ")(" ") (", count(local ct)
	}

	local isfunction 0
	local ysimfound 0
	local replacelist
	local exprlist `sexpr'
	gettoken tok exprlist : exprlist, bind
	while `"`tok'"' != "" {
		gettoken tok : tok, match(lmatch) bind

		// check for (label:@func(fexpr))
		if regexm(`"`tok'"', "[_A-Za-z0-9 \t]*[:]*@[A-Za-z0-9 \t]+([^ \t]+)") {
			local par = regexs(0)
			if `"`tok'"' == `"`par'"' {
				if regexm(`"`tok'"', "\+|-|\*|/|\\|\^") {
					di as err `"invalid function {bf:`tok'}"'
					exit 198
				}
				if `"(`tok')"' == `"`sexpr'"' {
					local isfunction 1
				}
				// it's a function
				// extract -fexpr- to tok
				gettoken par tok : par, parse("()") bindcurly
				gettoken tok : tok, match(lmatch) bind
			}
		}

		_bayes_varlist expand tok : `"`tok'"'

		while `"`tok'"' != "" {
			local found 0
			foreach par of local predsumlist {
				if regexm(`"`tok'"', "{`par'}") {
					local found 1
					break
				}
			}
			gettoken par tok: tok, parse("\ ,+-*/^()") bindcurly
			if `found' {
				local paramlist `paramlist' `par'
				continue
			}

			//local regpat1 "{.*:_ysim.*}|{_ysim.*}|{.*:_resid.*}|{_resid.*}|{.*:_mu.*}|{_mu.*}"
			//local regpat2 ".*:_ysim.*|_ysim.*|.*:_resid.*|_resid.*|.*:_mu.*|_mu.*"
			_bayespredict_regexm braces regpat1 :
			_bayespredict_regexm nobraces regpat2 :
			if regexm(`"`par'"', "`regpat1'") {
				local par = regexs(0)
				local ysimfound 1
			}
			else if regexm(`"`par'"', "`regpat2'") {
				local par = regexs(0)
				local ysimfound 1
			}
			else if regexm(`"`par'"', "[_A-Za-z]+[_A-Za-z0-9]*") {
				local par = regexs(0)
				local found: list par in predsumlist
				if !`found' {
					local par
				}
			}
			else {
				local par
				break
			}
			local paramlist `paramlist' `par'
		}
		gettoken tok exprlist : exprlist, bind
	}

	local yvarlist
	local ysimvars
	local residvarlist
	local muvarlist
	local predobs
	local usernumspec
	local usernumlist
	local ignoreobs

	local singleparam 0
	local hasresid 0
	local hasmu 0

	local paramlist : list uniq paramlist
	local toklist `paramlist'
	while `"`toklist'"' != "" {
		gettoken tok toklist: toklist, bindcurly
		tokenize `"`tok'"', parse("{}")
		local isbraced 0
		if `"`1'"' == "{" {
			if `"`3'"' != "}" {
				continue
			}
			else {
				local isbraced 1
			}
		}

		local exprparam `tok'
		if `"`exprparam'"' == `"`paramlist'"' {
			local singleparam 1
		}
		local exprparam = regexr(`"`exprparam'"', "\[", "\[")
		local exprparam = regexr(`"`exprparam'"', "\]", "\]")
		local exprparam = regexr(`"`exprparam'"', "\(", "\(")
		local exprparam = regexr(`"`exprparam'"', "\)", "\)")

		local tok = regexr(`"`tok'"', "{", "")
		local tok = regexr(`"`tok'"', "}", "")

		local found: list tok in predsumlist
		if `found' {
			if `"`exprparam'"' != `"`tok'"' {
				while regexm(`"`sexpr'"', `"`exprparam'"') {
				local sexpr = ///
				regexr(`"`sexpr'"', `"`exprparam'"', `"`tok'"')
				}
			}
			local predobs `predobs' `tok'
			continue
		}

		local numlist
		tokenize `"`tok'"', parse("[]")
		if `"`2'"' == "[" {
			local tok `1'
			if `"`5'"' != "" {
				di as err `"invalid expression {bf:`5'}"'
				exit 198
			}
			if `"`2'"' == "[" & `"`4'"' == "]" {
				if `"`3'"' != "_all" {
					local usernumspec `usernumspec' `3'
					numlist `"`3'"'
					local numlist `r(numlist)'
					local usernumlist `usernumlist' `numlist'
				}
			}
		}
		else {
			tokenize `"`tok'"', parse("_")
			if `"`1'"' == "_" & `"`3'"' == "_" {
				cap numlist `"`4'"'
				if !_rc {
					local tok `1'`2'
					local numlist `r(numlist)'
				}
			}
		}

		gettoken label tok : tok, parse(":")
		if `"`label'"' != "" & `"`tok'"' != "" {
			local label `label':
			gettoken col tok : tok, parse(":")
		}
		else {
			local tok `label'
			local label
		}

		local oldtok `tok'
		if `"`label'"' == "" {
			if `"`tok'"' == "_ysim"    local tok _ysim1
			if `"`tok'"' == "_resid"   local tok _resid1
			if `"`tok'"' == "_mu"      local tok _mu1
		}
		else {
			local i `labelind_`label''
			if `"`tok'"' == "_ysim"    local tok _ysim`i'
			if `"`tok'"' == "_resid"   local tok _resid`i'
			if `"`tok'"' == "_mu"	   local tok _mu`i'
		}

		gettoken pref ind: tok, parse("0123456789")
		if `"`pref'"' != "_ysim" & `"`pref'"' != "_resid" & ///
			`"`pref'"' != "_mu" {
			_bayes_varlist check found : `"`tok'"' `"`predynames'"'
			if `found' {
				local predobs `predobs' `tok'
			}
			continue
		}

		local nolabfound: list tok in residlist
		if !`nolabfound' {
			local nolabfound: list tok in mulist
			if !`nolabfound' {
				local nolabfound: list tok in ysimlist
			}
		}
		
		local isresid 0
		local ismu 0

		local label `label'`tok'
		local found: list label in residlist
		if `found' {
			local hasresid 1
			local isresid 1
		}
		if !`found' {
			local found: list label in mulist
			if `found' {
				local hasmu 1
				local ismu 1
			}
			else {
				local found: list label in ysimlist
			}
		}

		if !`found' {
			_bayes_varlist check found : `"`label'"' `"`predynames'"'
		}
		if !`found' {
			if `nolabfound' {
				di as err `"{bf:`tok'} not found"'
				di as err `"Did you mean to specify {bf:{c -(}}{bf:`tok'}{bf:{c )-}}?"'
			}
			else if `"$BAYESPR_using"' != "" {
				di as err `"{bf:`tok'} not found"'
				_bayespredict_notfound `"`tok'"' `"$BAYESPR_using"' `"$BAYESPR_caller"'
			}
			else {
				local ioutcome
				if regexm(`"`tok'"', "_ysim|_resid|_mu") {
					local ioutcome = ///
					regexr(`"`tok'"', "_ysim|_resid|_mu", "")
					cap confirm number `ioutcome'
					if _rc {
						local ioutcome 0
					}
					else {
						local ioutcome = `ioutcome' > `maxoutcomes'
					}
				}
				if `ioutcome' {
					di as err `"outcome {bf:{`tok'}} not found; there are only `maxoutcomes' outcomes in the fitted model"'
					exit 198
				}
				// alternative error
				local outlist
				foreach outtok of local ysimlist {
					if `"`outlist'"' != "" {
						local outlist `outlist',
					}
					local outlist `outlist' {`outtok'}
				}
				di as err `"{bf:`tok'} not available"'
				di as err `"{p 4 4 2}Available outcomes: `outlist'.{p_end}"'
			}
			exit 198
		}

		local residvarlist `residvarlist' `isresid'
		local muvarlist `muvarlist' `ismu'

		local yvar BAYESPR`tok'
		local yvar $`yvar'
		local yvarlist `yvarlist' `yvar'
		local ysimvars `ysimvars' `tok'

		local ysimobs BAYESPR`tok'_obs
		local ysimobs $`ysimobs'

		local ysimtok = regexr(`"`tok'"', "_resid", "_ysim")
		local ysimtok = regexr(`"`ysimtok'"', "_mu", "_ysim")
		local simvars
		local checkobs

		if `"`numlist'"' == "" {

		local simvars
		local checkobs
		foreach obstok of local ysimobs {
			tokenize `"`obstok'"', parse("/")
			if `"`2'"' == "/" {
				local n1 `1'
				local n2 `3'
				cap confirm number `n1'
				if _rc {
					di as err "corrupted estimation results"
					exit 198
				}
				cap confirm number `n2'
				if _rc {
					di as err "corrupted estimation results"
					exit 198
				}
				local simvars `simvars' `tok'_`n1'-`tok'_`n2'
				local checkobs `checkobs' `ysimtok'_`n1'-`ysimtok'_`n2'
			}
			else {
				local numlist `obstok'
				foreach i of local numlist {
					local simvars `simvars' `tok'_`i'
					local checkobs `checkobs' `ysimtok'_`i'
				}
			}
		}
		
		}
		else {
			qui numlist "`ysimobs'"
			local ysimobs `r(numlist)'
			local subind: list numlist - ysimobs
			foreach obsind of local subind {
				local ignoreobs `ignoreobs' `tok'_`obsind'
			}
			local numlist: list numlist - subind
			foreach i of local numlist {
				local simvars `simvars' `tok'_`i'
				local checkobs `checkobs' `ysimtok'_`i'
			}

		}
		local predobs `predobs' `checkobs'

		_bayes_varlist check found : `"`checkobs'"' `"`predynames'"'
		if !`found' {

		di as err `"{bf:`tok'} not available"' 
		if `"`predynames'"' == "" {
			di as err "{bf:$BAYESPR_predfile} has no simulated outcome"
		}
		else {
			di as err `"Available outcomes: `predynames'"'
		}
		//di as err `"{p 4 4 2}Use {bf:bayespredict, saving()} to save predictions.{p_end}"'
			exit 198
		}

		if `"`sexpr'"' == `"`paramlist'"' {
			local sexpr = ///
			regexr(`"`sexpr'"', `"`exprparam'"', `"`simvars'"')
		}
		else if `isbraced' & !`isfunction' {
		
			if `"$BAYESPR_caller"' == "bayespredict" {
				gettoken exprlist : sexpr, match(lmatch)
				if `"`sexpr'"' == `"(`exprlist')"' {
					di as err `"expression {bf:`sexpr'} not allowed"'
					exit 198
				}
			}

			// if expression is requested: expand simvars
			_bayes_varlist expand simvars : `"`simvars'"'

			local exprlist `sexpr'
			local sexpr
			while `"`exprlist'"' != "" {
				gettoken exprtok exprlist : exprlist, match(lmatch)
				if !regexm(`"`exprtok'"', `"`exprparam'"') {
					local sexpr `sexpr' `exprtok'
					continue
				}
				foreach stok of local simvars {
				local newtok `exprtok'
				while regexm(`"`newtok'"', `"`exprparam'"') {
					local newtok = regexr(`"`newtok'"', ///
						`"`exprparam'"', `"`stok'"')
				}
					if `"`lmatch'"' == "(" {
						local newtok (`newtok')
					}
					local sexpr `sexpr' `newtok'
				}
			}
		}
	}

	sreturn clear

	sreturn local isfunction = "`isfunction'"
	
	local predobs : list uniq predobs
	sreturn local predobs = "`predobs'"

	local yvarlist : list uniq yvarlist
	sreturn local varlist = "`yvarlist'"

	local ysimvars : list uniq ysimvars
	sreturn local simvarlist = "`ysimvars'"
	
	sreturn local hasresid = "`hasresid'"
	sreturn local hasmu    = "`hasmu'"
	sreturn local residvarlist = "`residvarlist'"
	sreturn local muvarlist    = "`muvarlist'"
	
	sreturn local usernumspec = "`usernumspec'"
	sreturn local usernumlist = "`usernumlist'"

	local ignoreobs : list uniq ignoreobs
	sreturn local ignoreobs = "`ignoreobs'"

	local sexpr `sexpr'
	sreturn local expr = "`sexpr'"
end
