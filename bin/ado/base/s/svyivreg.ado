*! version 3.0.2  29sep2004
program define svyivreg
	version 8, missing

	args flag query doit score

	if "`flag'"!="0" {
		if _caller() < 8 {
			svy_est_7 svyivreg `0'
		}
		else {
			svy_est svyivreg `0'
		}
		exit
	}
	if "`query'"=="syntax" {
		Syntax

	/* Do parse of ivreg syntax. */

		gettoken junk 0 : 0 /* blow off first two tokens */
		gettoken junk 0 : 0

		if `"`0'"'!="" {
			IVParse `0'
		}
		exit
	}
	if "`query'"=="how_many_scores" {
		HowMany

	/* Fix S_VYindv for call to regress. */

		global S_VYindv $S_VYendo $S_VYexo1 ($S_VYexo1 $S_VYexo2)

	/* Fix S_VYmodl for model test. */

		global S_VYmodl $S_VYendo $S_VYexo1
		exit
	}
	if "`query'"=="save" {
		Save
		exit
	}
	if "`query'"=="scores" {

	/* Save R^2. */

		global S_VYr2 `e(r2)'

	/* Compute score. */

		qui _predict double `score' if $S_VYsub, residual

	/* Project endogenous on instruments. */

		tokenize $S_VYendo
		local i 1
		while "``i''"!="" {
			Project ``i''
			local i = `i' + 1
		}
		exit
	}
	if "`query'"=="first" {
		mac shift 2
		doFirst `*'
		exit
	}
	if "`query'"=="footnote" {
		Footnote
		exit
	}

	di in red "0 invalid name"
	exit 198
end

program define Syntax, sclass
	sret clear
	sret local title    "Survey instrumental variables regression"
	sret local cmd      "regress"
	sret local k_depvar "1"
	sret local first    "FIRST"
end

program define HowMany, rclass
	ret scalar k_scores = 1 /* one score index */
	ret scalar cmdcando = 0 /* regress cannot compute it */
end

program define Save, eclass
	eret scalar r2 = $S_VYr2
	eret local predict "svyreg_p"
	eret local instd $S_VYendo

	if "$S_VYexo1"!="" {
		eret local insts $S_VYexo2 + $S_VYexo1
	}
	else	eret local insts $S_VYexo2

	global S_E_r2 = e(r2) /* double save */
end

program define Footnote
	di in smcl in gr "Instrumented:  `e(instd)'" _n /*
	*/       "Instruments:   `e(insts)'" _n /*
	*/  "{hline 78}"
end

program define Project
	args y
	quietly {
		if "$S_VYexp"!="" {
			local wt [iw=$S_VYexp]
		}

		reg `y' $S_VYexo1 $S_VYexo2 `wt' if $S_VYsub

		tempvar newy
		_predict double `newy' if e(sample)
		replace `newy' = 0 if `newy'>=.
		drop `y' /* data is preserved */
		rename `newy' `y'
	}
end

program define IVParse, sclass
	gettoken lhs 0 : 0, parse(" ,[") match(paren)
	Stop `lhs'
	if `s(stop)' {
		error 198
	}
	while `s(stop)' == 0 {
		if "`paren'"=="(" {
			if "`pfound'"!="" { /* already found "(" */
				IVError
			}
			local pfound 1
			gettoken var lhs : lhs, parse(" =")
			while "`var'"!="=" {
				if "`var'"=="" {
					IVError
				}
				local endog `endog' `var'
				gettoken var lhs : lhs, parse(" =")
			}
			unab endog : `endog'
			if "`lhs'"=="" {
				IVError
			}
			unab exog2 : `lhs'
		}
		else {
			if "`first'"=="" {
				local y `lhs'
				local first 1
			}
			else local exog1 `exog1' `lhs'
		}

		gettoken lhs 0 : 0, parse(" ,[") match(paren)
		Stop `lhs'
	}

	unab y : `y'
	unab exog1 : `exog1', min(0)

	sret local new0 `y' `endog' `exog1' `exog2' `lhs' `0'

	global S_VYexo1 `exog1'
	global S_VYexo2 `exog2'
	global S_VYendo `endog'
end

program define IVError
	di in red "invalid syntax" _n /*
	*/ `"syntax is "(all instrumented variables = instrument variables)""'
	exit 198
end

program define Stop, sclass
	if   `"`0'"' == "["  /*
	*/ | `"`0'"' == ","  /*
	*/ | `"`0'"' == "if" /*
	*/ | `"`0'"' == "in" /*
	*/ | `"`0'"' == "" {
		sret local stop 1
	}
	else	sret local stop 0
end

                                        /* performs first-stage regressions */
program define doFirst  /* <endoglst> <instlst> <if> <in> <weight> */
        args    touse      /*  touse sample
            */  nocons     /*  noconstant option */

	local endolst $S_VYendo
	local instlst $S_VYexo1 $S_VYexo2

        di as txt _newline "First-stage regressions"
        di in smcl in gr     "{hline 23}"

	tempname svyivres
	_est hold `svyivres', restore
        tokenize `endolst'
        local i 1
        while "``i''" != "" {
                svyreg ``i'' `instlst' if `touse', `nocons'
                local i = `i' + 1
        }
        di
	_est unhold `svyivres'
end

