*! version 1.0.3  02dec2013
/*
	
	Checks if any `_dta[_mi_ivars]' (minus <ivars>) are used in 
	expressions and displays notes.  Checks if any <ivars> are used 
	in expressions and issues errors.  Returns expression lists and 
	expression variables names for each variable in -ivarsexpnames()-.
	
	Assumptions:
		If <anything> is empty, assumes:
			1.  All expressions are valid.

			2.  Expressions are saved in r() as follows:

			k_exp			# of expressions
			<stub>_1_exp		expr. corresponding to <stub>_1
			<stub>_2_exp		expr. corresponding to <stub>_2
			...
			<stub>_<k_exp>_exp	expr. corresp. to <stub>_<k_exp>
			expnames		names <stub>_# for each expr.
			<ivexp>_expnames	names of expr. vars for <ivexp>
			<ivexp>_explists	expressions involving <ivexp>
			iv_expnames		all <ivexp>_expnames
			iv_explists		all <ivexp>_explists

		<ivexp> is any variable in -ivarsexpnames()-.

		Otherwise, uses -u_mi_impute_parse_exp- to check validity of 
		expressions in <anything> and to save s().
*/
program u_mi_impute_parse_exp_ivars
	version 11.0

	syntax [anything(equalok)] [, IVARSNOTALLOWED(string) 		  ///
				      IVARSALLOWED(varlist) 		  ///
				      IVARSEXPNAMES(varlist)		  ///
				      STUB(string) ERRNAME(string) NOCHK  ///
					]
	qui u_mi_impute_parse_exp "`stub'" `"`anything'"' "`errname'"
	local allivars `_dta[_mi_ivars]'
	if ("`allivars'"=="") exit

	if ("`r(expnames)'"=="") {
		exit
	}
	if ("`ivarsnotallowed'"!="") {
		local unab ivarsnotallowed : `ivarsnotallowed'
	}
	if ("`ivarsallowed'"!="") {
		local unab ivarsallowed : `ivarsallowed'
	}
	if ("`ivarsexpnames'"!="") {
		local unab ivarsexpnames : `ivarsexpnames'
	}
	if ("`nochk'"=="") {
		local allivars : list allivars - ivarsnotallowed
		local allivars : list allivars - ivarsallowed
		chkexpr "`allivars'" "`ivarsexpnames'"
	}
	if ("`ivarsnotallowed'"=="") exit
	chkexpr "`ivarsnotallowed'" "" "err"
end

program chkexpr
	args ivars ivarsexpnames err

	if ("`err'"=="") {
		local dias di as txt
		local tag bf
	}
	else {
		local dias di as err
		local tag bf
	}
	local ivars : list ivars - ivarsexpnames
	if ("`ivarsexpnames'"!="") {
		local k_exp `r(k_exp)'
		tokenize `r(expnames)'
		foreach var in `ivarsexpnames' {
			cap noi nobreak {
				local enames
				local elist
				forvalues i=1/`k_exp' {
					local expr `r(``i''_exp)'
					_expr_query hasivar : `var' `"`expr'"'
					if (`hasivar') {
						local enames `enames' ``i''
						local elist `elist' `expr'
					}
				}
				local allenames `allenames' `enames'
				local allelists `allelists' `elist'
				mata: st_global("r(`var'_expnames)","`enames'")
				mata: st_global("r(`var'_explists)","`elist'")
			}
			if _rc {
				exit _rc
			}
		}
		mata: st_global("r(iv_expnames)","`allenames'")
		mata: st_global("r(iv_explists)","`allelists'")
	}

	local p: word count `ivars'
	if (!`p') exit

	cap noi nobreak {
		local haserr 0
		local k_exp `r(k_exp)'
		tokenize `r(expnames)'
		forvalues i=1/`k_exp' {
			local expr `r(``i''_exp)'
			_expr_query hasivars : "`ivars'" `"`expr'"'
			if (`hasivars') {
				local diexpr `diexpr' `expr'
				local ++haserr
			}
		}
	}
	local rc = _rc
	if `rc'==1 exit 1
	if (`haserr') {
		note `"`diexpr'"' `haserr' "`err'" "`ivars'"
		if ("`err'"!="") {
			local rc = 198
		}
	}
	exit `rc'
end

program note
	args expr haserr err ivars

	local n : word count `ivars'
	if ("`err'"=="") {
		local dias  as txt
di `dias' "{p 0 6 2}note: " plural(`haserr', "expression") 
di `dias' `"{bf:`expr'} "' plural(`haserr', "includes", "include") 
di `dias' "variable(s) registered as imputed;"
di `dias' "this may cause some observations"
di `dias' "to be omitted from the estimation and may lead"
di `dias' "to missing imputed values{p_end}"
	}
	else {
		local dias as err
di `dias' "{p 0 0 2}" plural(`haserr', "expression") 
di `dias' `"{bf:`expr'} "' plural(`haserr', "includes", "include") 
di `dias' plural(`n',"variable","one or more variables") " which have not"
di `dias' "yet been imputed ({bf:`ivars'}); this is not allowed{p_end}"
	}
end

program _expr_query
	args hasivars colon ivars expr

	tempname rhold
	_return hold `rhold'

	expr_query = `expr'
	local vars `r(varnames)'
	local isvars : list ivars & vars
	if ("`isvars'"!="") {
		c_local `hasivars' 1
	}
	else { 
		c_local `hasivars' 0
	}

	_return restore `rhold'
end

exit
