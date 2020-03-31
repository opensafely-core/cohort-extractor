*! version 2.1.4  04oct2019

program define gmm_p
	version 14

	/* NB this predictor does not use _predict */
	if "`e(cmd)'" != "gmm" {
		exit 301
	}
	local vn = e(version)
	if (missing(`vn')) local vn = 13.1

	syntax anything(name=vlist) [if] [in] , /*
		*/ [	xb 			/*
		*/  Equation(string)		/*
		*/	SCores 			/* 
		*/	Residuals 		/* 
		*/  scores0			/* undocumented
		*/ ]

	if "`scores'`residuals'`scores0'" == "" {
		if _caller() < 14.2 {
			local residuals residuals
		}
		else {
			local xb xb
		}
		di as txt "(option {bf:xb} assumed; fitted values)"
	}
	if "`xb'" != "" {
		_predict `0'
		exit 0
	}
	tempvar touse 
	mark `touse' `if' `in'

	if "`scores'" != "" {
		local scorevers `e(scorevers)'
		gettoken f scorevers: scorevers
		gettoken nv colon: scorevers, parse(":")
		if `nv' < 14.2 {
			di as err "{bf:scores} not allowed under " ///
				"version `nv'"
			exit 301
		}
		tempname G
		matrix `G' = e(G)
		local n = rowsof(`G')
		local predlist 
		forvalues i = 1/`n' {
			tempvar fscore`i'
			local predlist `predlist' double `fscore`i''
			local spredlist `spredlist' `fscore`i''
		}
		qui predict `predlist', scores0
		tempname b
		matrix `b' = e(b)
		local k = colsof(`b')
		local npredlist 
		forvalues i = 1/`k' {
			tempvar nscore`i'
			qui generate double `nscore`i'' = .	
			local snpredlist `snpredlist' `nscore`i''
		}
		mata: StoreScores("`snpredlist'","`spredlist'")
		_stubstar2names `vlist' , nvars(`k')
		local scorevarlist `s(varlist)'
		local typlist `s(typlist)'
	
		// parse varlist args
		local i = 1
		foreach var of local scorevarlist {
			gettoken typ typlist: typlist
			gettoken score snpredlist: snpredlist
			qui gen `typ' `var' = `score' if `touse'
			label variable `var' "score `i' from gmm"
			local i = `i' + 1
		}
		tempname misscount
		mata:MissCount("`misscount'","`scorevarlist'")
		if `misscount' > 0 {
			local dimisscount = `misscount'
			di "(`dimisscount' missing values generated)"
		}
		exit 0
	}
	else if "`scores0'" != "" {
		local scorevers `e(scorevers)'
		gettoken f scorevers: scorevers
		gettoken nv colon: scorevers, parse(":")
		if `nv' < 14.2 {
			di as err "{bf:scores} not allowed under " ///
				"version `nv'"
			exit 301
		}
		tempname G
		matrix `G' = e(G)
		local n = rowsof(`G')
		local cmdline `e(cmdline)'
		gettoken gmm cmdline: cmdline, parse(" ")
		tempname b
		matrix `b' = e(b)
		tempname W
		local nmom = `n'
		local momlist
		forvalues i = 1/`nmom' {
			tempvar mom`i'
			qui gen double `mom`i'' = .
			local momlist `momlist' `mom`i''			
		}
		ScoreCMDLine, iscorevars(`momlist') 	///
			fromarg(`b') cmdline(`cmdline')
		local scoreby `e(scoreby)'
		local scorecmdline `r(scorecmdline)'
		tempname prevest
		qui estimates store `prevest'
		qui `scoreby' gmm `scorecmdline'
		qui estimates restore `prevest'
		_stubstar2names `vlist' , nvars(`n')
		local scorevarlist `s(varlist)'
		local typlist `s(typlist)'
	
		// parse varlist args
		local i = 1
		foreach var of local scorevarlist {
			gettoken typ typlist: typlist
			gettoken mom momlist: momlist
			qui gen `typ' `var' = `mom' if `touse'
			label variable `var' "score `i' from gmm"
			local i = `i' + 1
		}
		tempname misscount
		mata:MissCount("`misscount'","`scorevarlist'")
		if `misscount' > 0 {
			local dimisscount = `misscount'
			di "(`dimisscount' missing values generated)"
		}
		exit 0
	}
	else if "`equation'" != "" {
		local equation `=trim("`equation'")'
		local myrc = 0
		local eqnames `e(eqnames)'
		local eq : list posof `"`equation'"' in eqnames
		if `eq' == 0 {
			if bsubstr("`equation'", 1, 1) == "#" {
				local equation `=bsubstr("`equation'", 2, .)'
				local pound #
			}
			capture confirm integer number `equation'
			if _rc {
				di as error 		///
					"equation `pound'`equation' not found"
				exit 303
			}
				// next line gets rid of stuff like leading 0
				// from equation number
			local equation = `equation'
		}
		else {
			local equation = `eq'
		}
		if `equation' < 1 | `equation' > `e(n_eq)' {
			di as error "equation number out of range"
			exit 303
		}
		if `:word count `vlist'' > 2 {
			di as error "too many variables specified"
			exit 103
		}
		if `:word count `vlist'' == 2 {
			local typlist `:word 1 of `vlist''
			local varlist `:word 2 of `vlist''
		}
		else {
			local typlist "float"
			local varlist `vlist'
		}
	}
	else {
		_stubstar2names `vlist' , nvars(`=e(n_eq)')
		local typlist `s(typlist)'
		local varlist `s(varlist)'
	}
	
	if "`e(type)'" == "1" & "`options'" != "" {
		di as error "`options' not allowed"
		exit 198
	}
	
	if "`e(type)'" == "1" {
		tempname parmvec	
		matrix `parmvec' = e(b)
		forvalues i = 1/`e(n_eq)' {
			local expr`i' `e(sexp_`i')'
		}
		local params `e(params)'
	
		/* Replace param names with parmvec columns */
		foreach parm of local params {
			if `vn' < 14 {
				local j = colnumb(`parmvec', "`parm':_cons")
			}
			else {
				local tmp : subinstr local parm ":" ":", ///
					count(local k)
				if (!`k') {
					local j = colnumb(`parmvec',  ///
						"`parm':_cons")
				}
				else {
					local j = colnumb(`parmvec', "`parm'")
				}
			}
			forvalues i = 1/`e(n_eq)' {
				local expr`i' : subinstr local expr`i' /*
					*/ "{`parm'}" "\`parmvec'[1,`j']", all
			}
		}
		if "`equation'" != "" {
			tempvar yh`equation'
			quietly generate `typlist' `varlist' = 		///
				`expr`equation'' if `touse'
			label var `varlist' "Equation `equation' residuals"
			tempname misscount
			mata:MissCount("`misscount'","`varlist'")
			if `misscount' > 0 {
				local dimisscount = `misscount'
				di "(`dimisscount' missing values generated)"
			}
		}
		else {
			local fullvlist
			forvalues i = 1/`e(n_eq)' {
				local vi : word `i' of `varlist'
				local ti : word `i' of `typlist'
				quietly generate `ti' `vi' = 		///
					`expr`i'' if `touse'
				local fullvlist `fullvlist' `vi'
				label var `vi' "Equation `i' residuals"
			}
			tempname misscount
			mata:MissCount("`misscount'","`fullvlist'")
			if `misscount' > 0 {
				local dimisscount = `misscount'
				di "(`dimisscount' missing values generated)"
			}
		}
	}
	else {
		tempname parmvec
		matrix `parmvec' = e(b)
		local params `e(params)'
		local rhs `e(rhs)'
		local prog `e(evalprog)'
		local progopts `e(evalopts)'
		local yh
		forvalues i = 1/`e(n_eq)' {
			tempvar yh`i'
			quietly generate double `yh`i'' = .
			local yh `yh' `yh`i''
		}
		capture `prog' `yh' if `touse' , at(`parmvec') `progopts'
		if _rc {
			di as error "`prog' returned " _rc
			exit _rc
		}
		if "`equation'" != "" {
			local which : word `equation' of `yh'
			qui gen `typlist' `varlist' = `which' if `touse'
			label var `varlist' "Equation `equation' residuals"
			tempname misscount
			mata:MissCount("`misscount'","`varlist'")
			if `misscount' > 0 {
				local dimisscount = `misscount'
				di "(`dimisscount' missing values generated)"
			}
		}
		else {
			local fullvlist
			forvalues i = 1/`e(n_eq)' {
				local vi : word `i' of `varlist'
				local ti : word `i' of `typlist'
				local which : word `i' of `yh'
				quietly gen `ti' `vi' = `which' if `touse'
				local fullvlist `fullvlist' `vi'
				label var `vi' "Equation `i' residuals"
			}
			tempname misscount
			mata:MissCount("`misscount'","`fullvlist'")
			if `misscount' > 0 {
				local dimisscount = `misscount'
				di "(`dimisscount' missing values generated)"
			}
		}
	}

end


program ScoreCMDLine, rclass
	syntax, fromarg(string) cmdline(string) iscorevars(string)		
	local 0 `cmdline'
	local zero `0'		// backup copy
	local EXPRESSION = 1
	local PROGRAM = 2
	local type
	gettoken eqn 0 : 0 , match(paren)
	local eqlist
	if "`paren'" == "(" {
		local type = `EXPRESSION'
		local eqn1 (`eqn')
		local eqlist `eqlist' `eqn1'
		// loop through and get remaining equations
		local i 1
		local stop 0
		while !`stop' {
			gettoken eqn 0 : 0, match(paren)
			local eqn : list clean eqn
			if "`paren'" == "(" {
				local `++i'
				local eqn`i' (`eqn')
				local eqlist `eqlist' `eqn`i''
			}
			else {
				local 0 `eqn'`0'
				local stop 1
			}
		}
		local neqn `i'
		// comma before options may have been stripped off by -gettoken-
		// add if no if, in, or weight expression
		if `"`=bsubstr(`"`0'"', 1, 1)'"' != "," &	///
		   `"`=bsubstr(`"`0'"', 1, 2)'"' != "if" &	///
		   `"`=bsubstr(`"`0'"', 1, 2)'"' != "in" &	///
		   `"`=bsubstr(`"`0'"', 1, 1)'"' != "[" {
			local 0 , `0'
		}
	}
	else {
		local type = `PROGRAM'
		local 0 `zero'	// restore what the user typed
		// program version
		syntax anything(name=usrprog id="program name") 	///
			[if] [in] [aw fw pw iw], [* ]
		local 0 `if' `in' `wexp', `options'
		local eqlist `usrprog'
	}

	qui syntax [if] [in] [aw fw pw iw], [TWOstep Igmm 		///
		IGMMITerate(string) igmmeps(string) WMATrix(string)	///
		igmmweps(string) FROM(string) ITERate(string) 		///
		scorevars(string) ONEstep vce(string) *]	
	if `"`weight'`exp'"' != "" {
		local wexp [`weight'`exp']
	}
	else {
		local wexp 
	}
	local s `eqlist' `if' `in' `wexp', `options' onestep	/// 
		iterate(0) from(`fromarg') 			///
		scorevars(`iscorevars')
	return local scorecmdline `s'
end


mata:
void MissCount(string scalar misscount, string scalar varlist) {
	real matrix varlistview
	pragma unset varlistview
	st_view(varlistview,.,varlist)
	st_numscalar(misscount,missing(varlistview))
}
void StoreScores(string scalar newlist, string scalar oldlist) {
	real matrix newView
	real matrix oldView

	pragma unset newView
	pragma unset oldView
	st_view(newView,.,newlist)
	st_view(oldView,.,oldlist)
	newView[.,.] = -(st_matrix("e(G)")'*st_matrix("e(W0)")*oldView')'
}
end
