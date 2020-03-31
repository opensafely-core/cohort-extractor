*! version 2.7.2  11mar2015
program testnl, rclass
	local vv : display "version " string(_caller()) ":"
	version 8

        if "`e(properties)'" == "" {
                error 301
        }

	if (!has_eprop(b) | !has_eprop(V)) {
		error 321
	}

	is_svy
	local is_svy `r(is_svy)'
	if "`is_svy'" == "1" {
		if "`e(complete)'" == "available" {
			di as err /*
			*/ `"must run svy command with "complete" option before using this command"'
			exit 301
		}
	}


// parse input

	// parse off constraints

	local nc 0
	if _caller() < 6 {        /* v<=5 syntax with eq */

		gettoken tok 0 : 0, parse(" ,")
		while "`tok'" != "" & "`tok'"!="," {
			eq ?? `tok'
			local tok `r(eq)'
			local eqns `"`eqns' `"`tok'"'"'
			local ++nc
			gettoken tok 0 : 0, parse(" ,")
		}
	}

	else {			/* v>5 syntax */
		local single single
		local zero `"`0'"'
		gettoken tok : 0, parse(" (,")
		if `"`tok'"' == "(" {  /* eqns within parens */
			local single 
			while `"`tok'"' == "(" {
				local ++nc
				gettoken tok 0 : 0, parse(" (,") match(paren)
				local eqns `"`eqns' `"`tok'"'"'
				gettoken tok : 0, parse(" (,")
			}
			if `"`tok'"' != "," & `"`tok'"' != "" {
				local eqns
				local single single
			}
		}

		if "`single'"=="single" {	/* eqn without parens */
			local 0 `"`zero'"'
			while `"`tok'"' != "" & `"`tok'"' != "," {
				gettoken tok 0 : 0, parse(" ,")
				local eq `"`eq' `tok'"'
				gettoken tok : 0, parse(" ,")
			}
			if `"`eq'"' == "" {
				error 198
			}
			local nc 1
			local eqns `" `"`eq'"'"'
			local eq
		}
	}


	// rest of syntax

	syntax [,	noSVYadjust			///
			Mtest				///
			Mtest2(passthru)		///
			G(string)			///
			R(string)			///
			ITERate(integer 100)		///
			DF(numlist max=1 >0 missingok)	///
		]

	if "`df'" != "" {
		local dof = `df'
	}
	else if "`e(df_r)'"!="" & _caller() < 13 {
		local dof = e(df_r)
	}
	else {
		local dof = .
	}

	if !`is_svy' & "`svyadjust'" != "" {
		di as err "nosvyadjust is allowed only with svy models"
		exit 198
	}

	if `"`mtest'`mtest2'"' != "" {
		if inlist("`e(cmd)'", "svymean", "svytotal", "svyratio") {
			di as err `"mtest option not allowed after `e(cmd)'"'
			exit 301
		}
		_mtest syntax, `mtest' `mtest2'
		local mtmethod `r(method)'
	}

	if `is_svy' { 
		if missing(`dof') {
			local svyadjust nosvyadjust
		}
	}
	local svy_adjust = ("`is_svy'"=="1") & ("`svyadjust'"=="")


	// bring constraints into expected format and display them

	// translate == into =
	local eqns : subinstr local eqns "==" "=", all

	// translate  eq1=eq2=eq3  syntax style into  eq1=eq2  eq1=eq3 etc
	ExpandEqns `eqns'
	local eqns `"`r(eqns)'"'
	local nc    `r(neq)'
	if `nc' == 1 & "`mtmethod'" != "" {
		di as txt "(option mtest ignored with a single condition)"
		local mtmethod
	}

	DisplayEqns `eqns'

	// translate format eqns from x=y to x-(y)
	FixEqns `eqns'
	local eqns `"`r(eqns)'"'


// Compute R, G (= dR/db) and Wald's test

	tempname b df_r G IVR oldest R VR w Wald

	matrix `b' = e(b)
	local k = colsof(`b')

	mat `R' = J(`nc',1,0)
	MakeR `R' = `eqns'
	if "`r'" != "" { 	/* return via option r() */
		mat `r' = `R'
	}
	return matrix R  `R'
	mat `R' = return(R)

	_estimates hold `oldest', copy restore

	mat `G' = J(`nc', `k', 0)
	MakeG `G' = `R' `iterate' `eqns' 
	`vv' ///
	mat colnames `G' = `: colfullnames `b''

	_estimates unhold `oldest'

	if "`g'" != "" {  /* return via option g() */
		mat `g' = `G'
	}
	return matrix G  `G'

	// VR = inv(G e(V) G')
	mat `VR' = return(G) * e(V) * return(G)'

	// Wald = R' Inv(V(R)) R
	mat `IVR' = syminv(0.5*(`VR' + `VR''))
	mat `Wald' = `R'' * `IVR' * `R'

	DenomDOF
	scalar `df_r' = `dof'

	// mdf = df of test
	local mdf `nc'
	forvalues i = 1/`nc' {
		if `IVR'[`i',`i'] == 0 {
			di as txt _col(8) "Constraint (`i') dropped" ///
			  cond("`mtmethod'"!="", " in simultaneous test", "")
			local --mdf
		}
	}

	if `mdf' == 0 {
		if `df_r' != . {
			return scalar F = 0
			return scalar df_r = `df_r'
		}
		else	return scalar chi2 = 0
		return scalar p = .
		return scalar df = 0
		//di as txt "no constraints left to be tested"
		//exit
	}

	if `svy_adjust' {
		// adjust for svy estimation commands
		local testtype F
		local svy_d `dof'
		if missing(`svy_d') {
			di as err "internal error in adjustment for svy"
			exit 10001
		}
		scalar `w' = ((`svy_d'-`mdf'+1)/(`svy_d'*`mdf')) * `Wald'[1,1]
		scalar `df_r' = `svy_d' - `mdf' + 1
	}
	else if `df_r' == . {
		local testtype chi2
		scalar `w' = `Wald'[1,1]
	}
	else {
		local testtype F
		scalar `w' = `Wald'[1,1] / `mdf'
	}


	if "`testtype'" == "chi2" {
		return scalar df   = `mdf'
		return scalar chi2 = `w'
		return scalar p    = chi2tail(return(df), return(chi2))
	}
	else {
		return scalar df   = `mdf'
		return scalar df_r = `df_r'
		return scalar F    = `w'
		return scalar p    = Ftail(return(df),return(df_r),return(F))
	}

	global S_6 = `w'     /* double saves for backward compatibility */
	global S_3 = `mdf'
	global S_5 = `df_r'


// multiple testing each of the conditions

	if "`mtmethod'" != "" & `mdf' > 1 {

		tempname tm
		mat `tm' = J(`nc', 3, .)
		`vv' ///
		mat colnames `tm' = `testtype' df p

		local it 0
		forvalues i = 1/`nc' {
			if `VR'[`i',`i'] == 0 {
				continue
			}

			local ++it

			mat `tm'[`it',1] = (`R'[`i',1]^2) / `VR'[`i',`i']
			mat `tm'[`it',2] = 1

			if `svy_adjust' {
				mat `tm'[`it',3] = Ftail(1,`svy_d',`tm'[`it',1])
			}
			else if `df_r' == . {
				mat `tm'[`it',3] = chi2tail(1,`tm'[`it',1])
			}
			else {
				mat `tm'[`it',3] = Ftail(1,`df_r',`tm'[`it',1])
			}
		}

		if "`mtmethod'" != "noadjust" {
			_mtest adjust `tm', mtest(`mtmethod') pindex(3) append
			mat `tm' = r(result)
			local pindex 4
		}
		else 	local pindex 3

		return local   mtmethod `mtmethod'
		return matrix  mtest    `tm'
		mat `tm' = return(mtest)
	}
	else {
		local mtmethod
	}

//  display output

	if "`mtmethod'" == "" {

		// simultaneous test only

		if "`testtype'" == "chi2" {
			di _n as txt "{ralign 22:chi2({res:`return(df)'})} =  " ///
			      as res %10.2f return(chi2)
		}
		else {
			di _n as txt ///
			  "{ralign 22:F({res:`return(df)'}, {res:`return(df_r)'})} =  " ///
			  as res %10.2f return(F)
		}
		di as txt "{ralign 22:Prob > `testtype'} =  " ///
		 as res %12.4f return(p) as txt `"`delta'"'

	}
	else {
		// multiple tests

		if "`testtype'" == "F" {
			local d "F(df,`=return(df_r)')"
		}
		else 	local d chi2

		di
		di as txt "{hline 7}{c TT}{hline 31}"
		di as txt "       {c |}{ralign 12:`d'}     df       p"
		di as txt "{hline 7}{c  +}{hline 31}"

		local it 0
		forvalues i = 1/`nc' {
			if `VR'[`i',`i'] == 0 {
				continue
			}
			local ++it
			di as txt "  (`i'){col 8}{c |}"          ///
			   as res _col(12)  %9.2f  `tm'[`it',1]  ///
			          _col(22)  %6.0f  `tm'[`it',2]  ///
			          _col(33)  %6.4f  `tm'[`it',`pindex'] ///
			   as txt " #"
		}

		di as txt  "{hline 7}{c +}{hline 31}"

		di as txt "  all  {c |}"                     ///
		   as res _col(12) %9.2f  return(`testtype') ///
		          _col(22) %6.0f  return(df)         ///
		          _col(33) %6.4f  return(p)

		di as txt  "{hline 7}{c BT}{hline 31}"

		_mtest footer 39 "`mtmethod'" "#"
	}
end


// ===========================================================================
// subroutines
// ===========================================================================


/* MakeR R = quoted_eqtn_list
   returns a  neq x 1 matrix with values of the conditions

   MakeR tests whether the conditions are scalar-like by evaluating them for
   the first and last observation, and verifying that the results are equal.
*/
program MakeR
	args R equal
	assert `"`equal'"' == "="
	mac shift 2

	tempname w1 w2
	local ieq 1
	while `"``ieq''"' != "" {
		scalar `w1' = ``ieq''
		if `w1' == . {
			di as err "equation (`ieq') evaluates to missing"
			exit 498
		}
		if _N > 1 {
			scalar `w2' = ``ieq'' in l  /* used to be -in 2- */
			if `w1' != `w2' {
				di as err /*
				 */ "equation (`ieq') contains reference to X rather than _b[X]"
				exit 198
			}
		}
		mat `R'[`ieq',1] = `w1'
		local ++ieq
	}
end


/* MakeG G = R iter quoted_equation_list
*/
program MakeG /* G = R iter quoted_equation_list */
	args G equal R iter
	assert `"`equal'"' == "="
	mac shift 4

	tempname b
	mat `b' = e(b)
	local nb = colsof(`b')

	local i 1
	while "``i''" != "" {
		local eq ``i''
		forvalues j = 1/`nb' {
			Deriv `G' `i' `j' = "`eq'" `b' `R' `iter'
		}
		local ++i
	}
end


/* Deriv G i j = quoted-equation b R iter
*/
program define Deriv
	args G i j equal eq b R iter
	assert `"`equal'"' == "="

	tempname origb
	scalar `origb' = `b'[1,`j']
	Post `b' `j' "abs(`b'[1,`j'])*.01+.01"
	local nn	// blank
	if (missing(`eq')) {
		// try moving to the left
		matrix `b'[1,`j'] = `origb'
		local nn "-"
		Post `b' `j' "`nn'(abs(`b'[1,`j'])*.01+.01)"
		if (missing(`eq')) {
			di as err "could not calculate numerical derivative"
			exit 498
		}
	}
	if (`eq') == `R'[`i',1] {
		exit				/* deriv is zero */
	}

	tempname db w w2 goal0 goal1 r0

	scalar `db' = abs(`b'[1,`j'])*.01 + .01
	scalar `w' = `eq'
	scalar `r0' = `R'[`i',1]

	scalar `goal0' = abs(`r0')*1e-6 + 1e-6
	scalar `goal1' = abs(`r0')*1e-5 + 1e-5

	local k 0
	while abs(`w'-`r0') < `goal0' | abs(`w'-`r0') > `goal1' {
 		scalar `db' = `nn'((`goal0'+`goal1')/2)*`db'/abs(`w'-`r0')
		if `db' < . & `k'<=`iter' { 
			Post `b' `j' `db' 
		}
		else {				/* deriv is essentially zero */
			if `k'>`iter' {
di as err "Maximum number of iterations exceeded."
				exit 498
			}
			local name : colfullnames `b'
			local name : word `j' of `name'
			di as txt _col(8) /*
*/ "warning: derivative with respect to `name' coefficient is near zero,"
			di as txt _col(8) /*
*/ "         derivative treated as zero"
			Post `b' `j' (`origb'-`b'[1,`j'])
			exit
		}
		scalar `w' = `eq'
		local k = `k' + 1
	}

	Post `b' `j' -`db'
	scalar `w2' = `eq'
	mat `G'[`i',`j'] = (`w' - `w2') / (2*`db')
end



/* Post b j deltab
*/
program Post, eclass
	args b j deltab

	tempname b2 v2
	mat `b2' = `b'
	mat `b2'[1,`j'] = `b'[1,`j'] + (`deltab')
	mat `v2' = e(V)
	ereturn post `b2' `v2'
end


/* FixEq eqno eq

   return in r(eq) the translation x-(y) from the expected format x=y
   or x==y. FixEq produces an error message referring to equation eqno
   if no "=" or >1 "="s were found.
*/
program FixEq /* # unquoted_equation */, rclass

	gettoken eqno 0 : 0
	tokenize `"`0'"', parse("=")
	local neq 0
	while "`1'" != "" {
		if "`1'" == "=" | "`1'" == "==" {
			local neq = `neq' + 1
			if `neq' > 1 {
				di as err "equation (`eqno') has too many = signs"
				exit 198
			}
			local res "`res'-("
		}
		else	local res "`res'`1'"
		mac shift
	}
	if `neq' == 0 {
		di as err "equation (`eqno') has no = sign"
		exit 198
	}
	return local eq `"`res')"'
end


/* FixEqns
   invoke FixEq on all equations
*/
program FixEqns, rclass
	local i 1
	while `"``i''"' != "" {
		FixEq `i' ``i''
		local eqns `"`eqns' `"`r(eq)'"'"'
		local ++i
	}
	return local eqns `"`eqns'"'
end


/* DenomDOF
   returns in r(df_r) the residual_degrees_of_freedom
*/
program DenomDOF, rclass
	return scalar df_r = e(df_r)

	/* the following code is legacy code that we believe was never run 
 	   because the line above was inside an -if- block that was executed 
           when e(cmd) was not empty.  However, there was a check at the 
           top of the program that would give an error message if e(cmd) was 
           empty. 

	capture est dir
	if _rc == 0 {
		return scalar df_r = _result(5) 
		exit
	}
	return scalar df_r = .
	*/
end


/* ExpandEqns eqlist

   returns in
     r(eqns) the lists of quoted-equations,
     r(neq)  the number of equations
*/
program ExpandEqns, rclass
	local eqlist
	local neq 0
	local i 1
	while `"``i''"' != "" {
		SplitEq `i' ``i''
		local ni `r(neq)'
		local neq = `neq' + `ni'
		forvalues j = 1/`ni' {
			local eqlist `"`eqlist' `"`r(eq`j')'"'"'
		}
		local ++i
	}
	return local neq   `neq'
	return local eqns `"`eqlist'"'
end


/* SplitEq multi-equation     (exp1 = exp2 [... = exp3 ...])

   return in
     r(neq)  the number of equations of the form exp1 = exp_i
     r(eqi)  the i'th equation exp1=expi
*/
program SplitEq, rclass
	gettoken eqno 0 : 0
	tokenize `"`0'"', parse("=")
	local neq -1
	while "`1'" != "" {
		if "`1'" == "=" | "`1'" == "==" {
			local ++neq
			if `neq' == 0 {
				local lhs `res'
				local res
			}
			else {
				return local eq`neq' "`lhs' = `res'"
				local res
			}
		}
		else	local res "`res'`1'"
		mac shift
	}
	if `neq' == -1 {
		di as err "equation (`eqno') has no = sign"
		exit 198
	}
	if "`res'" == "" {
		di as err "correct format is exp1 = exp2 [= exp3 ..]"
		exit 198
	}
	else {
		local ++neq
		return local eq`neq' "`lhs' = `res'"
	}
	return local neq `neq'
end


/* DisplayEqns quoted_equations
*/
program DisplayEqns
	di
	local i 1
	while `"``i''"' != "" {
		// no code to wrap equation
		di _col(3) as txt "(`i')" as res `"{col 8}{bind:``i''}"'
		local ++i
	}
end
exit


Internal documentation
----------------------

The Wald-test formula is (Greene, 336)

                         -1
      W = (R(b)-q)'[GVG']  (R(b)-q)

where G is the derivative matrix of R(b) with respect to b.


History
-------

2.3.1 - adopted adjusted Deriv by jsp
2.3.0 - support for svy commands
2.2.1 - adopted code for new syntax _mtest
2.2.0 - fixed bug: syntax parsing would fail if equations were not
        parenthesized, while options were specified.
      - added multiple testing
2.1.0 - moved FixEqns to separate routine, called only once
      - changed output format to SMCL
