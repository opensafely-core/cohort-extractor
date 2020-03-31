*! version 1.3.4  13feb2015
program define _diparm_8
	version 6

/* Get equation names. */

	gettoken eq 0 : 0, parse(", ")
	local eq1 "`eq'"
	local i 1
	while `"`eq'"'!="" & `"`eq'"'!="," {
		local eqs "`eqs' `eq'"
		gettoken eq 0 : 0, parse(", ")
		local i = `i' + 1
	}

	local neq = `i' - 1

/* Parse options. */

	local 0 `", `0'"' /* put comma back */

	syntax [,			/*
	*/ LABel(str)			/*
	*/ Function(str)		/*
	*/ Derivative(str)		/*
	*/ CI(str)			/*
	*/ DOF(real -1)			/*
	*/ NOProb			/*
	*/ Prob				/*
	*/ Level(cilevel)		/*
	*/ EXP				/*
	*/ TANH				/*
	*/ ILOGIT INVLOGIT		/* synonyms
	*/ SVY				/* cause prob to behave differently
	*/ NOCI				/* cause ci to behave differently
	*/ ]

	if "`ilogit'`invlogit'" != "" {
		local ilogit ilogit
	}

			/* "NOProb Prob" fudge is OK for programmer's command:
			   prob is the default if no transform specified;
			   noprob is the default if a transform is specified
			*/

	if "`label'"=="" { 
		local label = usubstr("/`eq1'",1,12) 
	}

	local hardfun "`exp'`tanh'`ilogit'"

/* Check syntax. */

	local nopts : word count `exp' `tanh' `ilogit'
	local nopts = `nopts' + ("`functio'"!="")
	if `nopts' > 1 {
		di in red "more than one transform specified"
		exit 198
	}

	if   ("`functio'"!="" & "`derivat'"=="") /*
	*/ | ("`functio'"=="" & "`derivat'"!="") {
		di in red "both function() and derivative() must be specified"
		exit 198
	}

/* Compute z or t. */

	tempname z

	if `dof' == -1 {
		scalar `z' = invnorm((100 + `level')/200)
	}
	else	scalar `z' = invt(`dof',`level'/100)

/* Process single equations. */

	if `neq' == 1 {
		tempname b se
		scalar `b' = [`eq1']_cons
		scalar `se' = [`eq1']_se[_cons]
		if `se' == 0 { scalar `se' = . }

		if "`functio'"!="" {
			Function `b' `se' `z' "`functio'" "`derivat'"
		}
		else if "`hardfun'"!="" {
			`hardfun' `b' `se' `z'
		}
		else { /* identity transformation */
			if "`noprob'"=="" { local prob "prob" }
			identity `b' `se' `z'
		}
	}
	else {

/* Process multiple equations. */

		Multiple "`eqs'" `z' "`functio'" "`derivat'" "`ci'"
	}

	if "`prob'"!="" {
		AddP `dof'
	}

	if "`svy'" != "" {
		Display "`label'" "`svy'" "`noci'" "`noprob'"
	}
	else	Display "`label'"
end

program define Display
	args label svy noci noprob

	if "`svy'" != "" {
		if "`noprob'" == "" {
			local col _col(58)
		}
		else	local col _s(2)
	}
	else {
		local col _col(58)
		local noci
		local noprob
	}

	local est %9.0g r(est)
	local se  _s(2) %9.0g r(se)
	if "`r(p)'" != "" & "`noprob'" == "" {
		local stat _s(1) %8.2f r(est)/r(se)
		local p    _s(2) %6.3f r(p)
	}

	if "`noci'" == "" {
		local llb : di %9.0g r(lb)
		if length("`llb'") > 9 {
			local lbfmt "%8.0g"
			local llb : di %8.0g r(lb)
		}
		else	local lbfmt "%9.0g"

		local uub : di %9.0g r(ub)
		if length("`uub'") > 9 {
			local ubfmt "%8.0g"
			local uub : di %8.0g r(ub)
		}
		else	local ubfmt "%9.0g"
	}

	di in smcl in gr %12s abbrev("`label'",12) " {c |}  " /*
	*/ in ye `est' `se' `stat' `p' `col' "`llb'" "   " "`uub'"
end

program define AddP, rclass
	args dof
	return add
	if `dof' == -1 {
		return scalar p = 2*normprob(-abs(return(est)/return(se)))
	}
	else	return scalar p = tprob(`dof',abs(return(est)/return(se)))
end

program define Multiple, rclass
	args eqs z func deriv ci
	tempname b V D se
	local neq : word count `eqs'

/* Compute point estimate. */

	MEval "scalar `b'" "`func'" `eqs'

/* Get variance-covariance of desired equations. */

	GetV `eqs'
	mat `V' = r(V)

/* Compute derivatives. */

	mat `D' = J(1,`neq',0)
	local nder : word count `deriv'
	if `neq' != `nder' {
		di in red "number of derivatives not equal to number " /*
		*/ "of parameters"
		exit 198
	}
	tokenize `deriv'
	local eqi 1
	while `eqi' <= `neq' {
		MEval "mat `D'[1,`eqi']" "``eqi''" `eqs'
		local eqi = `eqi' + 1
	}

	mat `V' = `D'*`V'*`D''
	scalar `se' = sqrt(`V'[1,1])
	if `se' == 0 {
		scalar `se' = .
	}

/* Set return. */

	return scalar est = `b'
	return scalar se  = `se'

/* Compute CI. */

	if "`ci'"=="" {
		return scalar lb = `b' - `z'*`se'
		return scalar ub = `b' + `z'*`se'
	}
	else {
		CI`ci' `b' `se' `z'
		return add
	}
end

program define CIlogit, rclass
	args p se z
	return scalar lb = 1/(1 + exp(-(log(`p'/(1-`p')) /*
	*/ -`z'*`se'/(`p'*(1-`p')))))
	return scalar ub = 1/(1 + exp(-(log(`p'/(1-`p')) /*
	*/ +`z'*`se'/(`p'*(1-`p')))))
end

program define CIprobit, rclass
	args p se z
	tempname y
	scalar `y' = invnorm(`p')
	return scalar lb = normprob(`y'-`z'*`se'/normd(`y'))
	return scalar ub = normprob(`y'+`z'*`se'/normd(`y'))
end

program define CIatanh, rclass
	args x se z
	tempname y lb ub ll ul
	scalar `y' = 0.5*log((1+`x')/(1-`x'))
	scalar `lb' = `y'-`z'*`se'/(1-`x'^2)
	scalar `ub' = `y'+`z'*`se'/(1-`x'^2)
	scalar `ll'  = (exp(`lb')-exp(-`lb'))/(exp(`lb')+exp(-`lb'))
	scalar `ul'  = (exp(`ub')-exp(-`ub'))/(exp(`ub')+exp(-`ub'))
	return scalar lb  = cond(`ll'==.,-1,`ll')
	return scalar ub  = cond(`ul'==.,1,`ul')
end

program define CIlog, rclass
	args x se z
	return scalar lb = exp(log(`x')-`z'*`se'/`x')
	return scalar ub = exp(log(`x')+`z'*`se'/`x')
end

program define GetV, rclass /* get variance-covariance of desired equations */
	tempname V u v
	mat `V' = e(V)
	local eqi 1
	while "``eqi''"!="" {
		mat `u' = `V'[1...,"``eqi'':"]
		mat `v' = nullmat(`v') , `u'
		local eqi = `eqi' + 1
	}
	mat drop `V'
	local eqi 1
	while "``eqi''"!="" {
		mat `u' = `v'["``eqi'':",1...]
		mat `V' = nullmat(`V') \ `u'
		local eqi = `eqi' + 1
	}
	if diag0cnt(`V') > 0 {
		mat `V' = 0*`V'
	}

	return matrix V `V'
end

program define MEval /* substitute @1, @2,..., @9 for equation names */
	args genx func
	macro shift 2 /* `*' = list of equation names */

	while "`func'" != "" {
		gettoken sub func : func, parse("@")
		if "`sub'"=="@" {
			gettoken eqi func : func, parse("123456789")
			local exp "`exp'([``eqi'']_cons)"
		}
		else	local exp "`exp'`sub'"
	}

	capture `genx' = `exp'
	if _rc {
		di in red "expression evaluates to" _n "`exp'"
		exit 198
	}
end

program define Function, rclass
	args b se z func deriv

	Express `b' `deriv'
	return scalar se = abs(`r(exp)')*`se'

	tempname work
	Express `work' `func' /* macroname `work' substituted into function */

	scalar `work' = `b'
	return scalar est = `r(exp)'

	scalar `work' = `b' - `z'*`se'
	return scalar lb = `r(exp)'

	scalar `work' = `b' + `z'*`se'
	return scalar ub = `r(exp)'

	if return(lb) > return(ub) {
		scalar `work' = return(lb)
		return scalar lb = return(ub)
		return scalar ub = `work'
	}
end

program define Express, rclass
	gettoken b 0 : 0

	while "`0'" != "" {
		gettoken sub 0 : 0, parse("@")
		if "`sub'"=="@" { local exp "`exp'`b'"   }
		else		  local exp "`exp'`sub'"
	}

	return local exp "`exp'"
end

program define exp, rclass
	args b se z
	return scalar est = exp(`b')
	return scalar se  = return(est)*`se'
	return scalar lb  = exp(`b'-`z'*`se')
	return scalar ub  = exp(`b'+`z'*`se')
end

program define tanh, rclass
	args b se z
	tempname lb ub ll ul
	scalar `lb' = `b' - `z'*`se'
	scalar `ub' = `b' + `z'*`se'
	return scalar est = (exp(`b')-exp(-`b'))/(exp(`b')+exp(-`b'))
	return scalar se  = (1 - return(est)^2)*`se'
	scalar `ll'  = (exp(`lb')-exp(-`lb'))/(exp(`lb')+exp(-`lb'))
	scalar `ul'  = (exp(`ub')-exp(-`ub'))/(exp(`ub')+exp(-`ub'))
	return scalar lb  = cond(`ll'==.,-1,`ll')
	return scalar ub  = cond(`ul'==., 1,`ul')
end

program define ilogit, rclass
	args b se z
	return scalar est = 1/(1 + exp(-`b'))
	return scalar se  = return(est)*(1 - return(est))*`se'
	return scalar lb  = 1/(1 + exp(-(`b'-`z'*`se')))
	return scalar ub  = 1/(1 + exp(-(`b'+`z'*`se')))
end

program define identity, rclass
	args b se z
	return scalar est = `b'
	return scalar se  = `se'
	return scalar lb  = `b' - `z'*`se'
	return scalar ub  = `b' + `z'*`se'
end
