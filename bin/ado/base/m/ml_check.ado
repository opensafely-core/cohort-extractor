*! version 3.1.1  02feb2012
program define ml_check
	version 6
	ml_defd
	syntax [, MAXFEAS(integer 1000)] 	/* undocumented; for testing
						   purposes */

	capture ml trace off
	capture ml count off
	global ML_dots "*"

	Test1
	Test2

	if scalar($ML_f)==. {
		GetFeas `maxfeas'
		Test1
		Test2
	}

	Test3
	Test4

	Test5
	Test6

	tempname b0 f0 g0 V0
	matrix `b0' = $ML_b
	scalar `f0' = scalar($ML_f)
	capture matrix `g0' = $ML_g
	if _rc==1 { exit 1 }
	capture matrix `V0' = $ML_V
	if _rc==1 { exit 1 }

	GetFeas2
	if mreldif(matrix(`b0'),matrix($ML_b))==0 {
		di _n in gr "Stata found the same coefficient vector again!" /*
		*/ _n "That is unlikely.  Searching again:"
		GetFeas2
		if mreldif(matrix(`b0'),matrix($ML_b))==0 {
			#delimit ;
			di _n in gr
"Stata found the same coefficient vector a second time!" ;
			di in gr
"Given that Stata uses a random search method to find feasible vectors, to find"
_n
"the same vector twice in a row is so unlikely that the cause must be" _n
in ye "$ML_user" in gr "." ;
			#delimit cr
			exit 9
		}
	}
	Test7 `b0' `f0' `g0' `V0'
	Test8 `b0' `f0' `g0' `V0'
	Test9 `b0' `f0' `g0' `V0'

	di in smcl in ye _n "{hline 78}" _n _col(26)  /*
	*/ "$ML_user HAS PASSED ALL TESTS" /*
	*/ _n "{hline 78}"

	Test10

	SetVal
	if `r(val)'==0 {
		exit
	}

	di _n in gr "You should check that the derivatives are right."

	if "$ML_meth"=="d1" | "$ML_meth"=="d2" {
		di in gr _n "Stata recommends that you reissue the " /*
		*/ in ye "ml model"  /*
		*/ in gr " statement and this time specify" _n "method " /*
		*/ in ye "${ML_meth}debug" in gr ".  Then use " /*
		*/ in ye "ml maximize" in gr /*
		*/ " to obtain estimates."
	}
	else if "$ML_meth"=="d1debug" | "$ML_meth"=="d2debug" {
		di in gr _n "Use " in ye "ml maximize" in gr /*
			*/ " to obtain estimates."
	}
	else	exit

	#delimit ;
	di _n in gr
"The output will include a report comparing analytic to numeric derivatives." _n
"Do not be concerned if your analytic derivatives differ from the numeric ones"
_n "in early iterations." _n(2)
"The analytic gradient will differ from the numeric one in early iterations," _n
"then the mreldif() difference should become less than 1e-6 in the middle" _n
"iterations, and the difference will increase again in the final iterations" _n
"as the gradient goes to zero." ;

	if "$ML_meth"=="d1" | "$ML_meth"=="d1debug" { exit } ;

	di _n in gr
"The analytic negative Hessian will differ from the numeric one in early" _n
"iterations, but the mreldif() difference should decrease with each iteration"
_n
"and become less than 1e-6 in the final iterations." ;
	#delimit cr
end


program define Test1
	di _n in gr "Test 1:  Calling " in ye "$ML_user" in gr /*
	*/ " to check if it computes $ML_crtyp and" _n /*
	*/ _col(10) "does not alter coefficient vector..."
	tempname b0
	matrix `b0 ' = $ML_b
	capture scalar drop $ML_f
	capture $ML_eval 0
	if _rc==0 {
		CheckF			/* created f 	*/
					/* b undamaged 	*/
		if "$ML_meth"=="lf" {
			ML_elf
		}
		else	EqualB `b0'
		Passed
		exit
	}
	local rc = _rc
	Break
	Failed `rc'
	capture scalar drop $ML_f
	Trace 0 `rc'
	exit `rc'
end


program define Test2
	di _n in gr "Test 2:  Calling " in ye "$ML_user" in gr /*
	*/ " again to check if the same $ML_crtyp value" _n /*
	*/ _col(10) "is returned..."
	tempname f0
	scalar `f0' = scalar($ML_f)
	capture scalar drop $ML_f
	capture $ML_eval 0
	if _rc==0 {
		EqualF `f0'		/* created f and equal */
		Passed
		exit
	}
	local rc = _rc
	Break
	Failed `rc'
	di _col(10) in gr "Perhaps " in ye "$ML_user" in gr /*
	*/ " attempted to redefine something defined previously."
	di in gr _col(10) "Did you forget to drop some working variable?"
	Trace 0 `rc'
	exit `rc'
end


program define GetFeas /* #_maxfeas */
	di in smcl in gr _n "{hline 78}"
	#delimit ;
	di in gr
"The initial values are not feasible.  This may be because the initial values"
_n
"have been chosen poorly or because there is an error in "
in ye "$ML_user" in gr " and it" _n
"always returns missing no matter what the parameter values." ;
	di _n in gr
"Stata is going to use " in ye "ml search"
in gr " to find a feasible set of initial values." _n
"If " in ye "$ML_user" in gr
" is broken, this will not work and you will have to press "
in ye "Break" _n in gr "to make " in ye "ml search" in gr " stop". ;
	#delimit cr
	di _n in gr "Searching..."
	ml_searc, trace maxfeas(`1')
	di _n in smcl in gr "restarting tests..." _n "{hline 78}"
end

program define Test3
	di _n in gr "Test 3:  Calling " in ye "$ML_user" in gr /*
	*/ " to check if 1st derivatives are computed..."
	if "$ML_meth"=="lf" | "$ML_meth"=="d0" {
		NotRel
		exit
	}
	tempname f0 b0
	scalar `f0' = scalar($ML_f)
	matrix `b0' = $ML_b
	capture mat drop $ML_g
	capture $ML_eval 1
	if _rc==0 {
		EqualB `b0'		/* b undamaged	*/
		EqualF `f0'		/* equal f 	*/
		CheckG			/* created g	*/
		Passed
		exit
	}
	local rc = _rc
	Break
	Failed `rc'
	capture mat drop $ML_g
	Trace 1 `rc'
	exit `rc'
end

program define Test4
	di _n in gr "Test 4:  Calling " in ye "$ML_user" in gr /*
	*/ " again to check if the same 1st derivatives are" _n /*
	*/ _col(10) "returned..."
	if "$ML_meth"=="lf" | "$ML_meth"=="d0" {
		NotRel
		exit
	}
	tempname g0
	matrix `g0 ' = $ML_g
	capture mat drop $ML_g
	capture $ML_eval 1
	if _rc==0 {
		EqualG `g0'		/* equal g	*/
		Passed
		exit
	}
	local rc = _rc
	Break
	Failed `rc'
	capture mat drop $ML_g
	Trace 1 `rc'
	exit `rc'
end

program define Test5
	di _n in gr "Test 5:  Calling " in ye "$ML_user" in gr /*
	*/ " to check if 2nd derivatives are computed..."
	if "$ML_meth"=="lf" | "$ML_meth"=="d0" | "$ML_meth"=="d1" | /*
		*/ "$ML_meth" == "d1debug" {
		NotRel
		exit
	}
	tempname f0 b0 g0
	scalar `f0' = scalar($ML_f)
	matrix `b0' = $ML_b
	matrix `g0' = $ML_g
	capture mat drop $ML_V
	capture $ML_eval 2
	if _rc==0 {
		EqualB `b0'		/* b undamaged	*/
		EqualF `f0'		/* equal f 	*/
		EqualG `g0'		/* equal g	*/
		CheckV			/* created g	*/
		Passed
		exit
	}
	local rc = _rc
	Break
	Failed `rc'
	capture mat drop $ML_V
	Trace 2 `rc'
	exit `rc'
end

program define Test6
	di _n in gr "Test 6:  Calling " in ye "$ML_user" in gr /*
	*/ " again to check if the same 2nd derivatives are" _n /*
	*/ _col(10) "returned..."
	if "$ML_meth"=="lf" | "$ML_meth"=="d0" | "$ML_meth"=="d1" | /*
		*/ "$ML_meth" == "d1debug" {
		NotRel
		exit
	}
	tempname V0
	matrix `V0' = $ML_V
	capture $ML_eval 2
	if _rc==0 {
		EqualV `V0'		/* equal V	*/
		Passed
		exit
	}
	local rc = _rc
	Break
	Failed `rc'
	capture mat drop $ML_V
	Trace 1 `rc'
	exit `rc'
end

program define Test7 /* b0 f0 g0 V0 */
	di _n in gr "Test 7:  Calling " in ye "$ML_user" in gr /*
	*/ " to check $ML_crtyp at the new values..."
	tempname b0
	capture scalar drop $ML_f
	capture $ML_eval 0
	if _rc==0 {
		CheckF			/* created f 	*/
		NoteqF `0'
		Passed
		exit
	}
	local rc = _rc
	Break
	Failed `rc'
	capture scalar drop $ML_f
	Trace 0 `rc'
	exit `rc'
end

program define Test8 /* b0 f0 g0 V0 */
	di _n in gr "Test 8:  Calling " in ye "$ML_user" in gr /*
	*/ " requesting 1st derivatives at the new values..."
	if "$ML_meth"=="lf" | "$ML_meth"=="d0" {
		NotRel
		exit
	}
	capture $ML_eval 1
	if _rc==0 {
		CheckG			/* created f 	*/
		NoteqG `0'
		Passed
		exit
	}
	local rc = _rc
	Break
	Failed `rc'
	Trace 0 `rc'
	exit `rc'
end

program define Test9 /* b0 f0 g0 V0 */
	di _n in gr "Test 9:  Calling " in ye "$ML_user" in gr /*
	*/ " requesting 2nd derivatives at the new values..."
	if "$ML_meth"=="lf" | "$ML_meth"=="d0" | "$ML_meth"=="d1" | /*
		*/ "$ML_meth" == "d1debug" {
		NotRel
		exit
	}
	capture $ML_eval 2
	if _rc==0 {
		CheckV
		NoteqV `0'
		Passed
		exit
	}
	local rc = _rc
	Break
	Failed `rc'
	Trace 0 `rc'
	exit `rc'
end

program define Test10
	#delimit ;
	di _n in gr "Test 10: Does " in ye "$ML_user" in gr
	" produce unanticipated output?" ;
	di _col(10) in gr
"This is a minor issue.  Stata has been running " in ye "$ML_user"
in gr " with all" _n _col(10)
"output suppressed.  This time Stata will not suppress the output." _n _col(10)
"If you see any unanticipated output, you need to place " in ye "quietly" in gr
" in" _n _col(10)
"front of some of the commands in " in ye "$ML_user" in gr "." ;

	#delimit cr
	SetVal
	local val `r(val)'

	di _n in smcl in gr "{hline 62}" " begin execution"
	capture noisily $ML_eval `val'
	di in smcl in gr "{hline 64}" " end execution"
	local rc = _rc
	if `rc'==0 {
		exit
	}
	if `rc'==1 {
		exit `rc'
	}
	di _n in gr "This time " in ye "$ML_user" in gr /*
	*/ " returned error " in ye "`rc'" in gr "."


	di in gr _n "Here is a trace of the execution:"
	di in smcl in gr "{hline 78}"
	capture noisily {
		qui ml trace on
		capture noisily $ML_eval `val'
		local rc2 = _rc
		di in smcl in gr "{hline 78}"
		qui ml trace off
	}
	if _rc { exit _rc }
	if `rc2'==0 {
		di in ye "$ML_user" in gr " worked this time!"
	}
	else if `rc2'!=`rc' {
		di in ye "$ML_user" in gr " returned error " in ye "`rc2'" /*
		*/ in gr " this time!"
		di in gr "(It returned error " in ye "`rc'" in gr " last time.)"
	}
	di in gr "Fix " in ye "$ML_user" in gr "."
	exit `rc'
end


program define SetVal, rclass
	if "$ML_meth"=="lf" | "$ML_meth"=="d0" {
		return local val "0"
		exit
	}
	if "$ML_meth"=="d1" | "$ML_meth"=="d1debug" {
		return local val "1"
		exit
	}
	return local val "2"
end

program define Failed
	if `"`1'"'=="" {
		di in red _col(10) "FAILED."
		exit
	}
	di in red _col(10) "FAILED; " in ye "$ML_user" /*
		*/ in gr " returned error `1'."
	exit
end

program define Passed
	di in gr _col(10) "Passed."
end

program define Break
	if _rc==1 {
		exit 1
	}
end

program define Trace /* call_type [rc] */
	di in gr _n "Here is a trace of its execution:"
	di in smcl in gr "{hline 78}"
	capture noisily {
		qui ml trace on
		capture noisily $ML_eval `1'
		local rc2 = _rc
		di in smcl in gr "{hline 78}"
		qui ml trace off
	}
	if _rc { exit _rc }
	if "`2'" != "" {
		if `rc2'==0 {
			di in ye "$ML_user" in gr " worked this time!"
			di in gr "Probably something is uninitialized."
		}
		else if `rc2'!=`2' {
			di in ye "$ML_user" in gr " returned error " /*
			*/ in ye "`rc2'" in gr " this time!"
			di in gr "(It returned error " in ye "`2'" /*
			*/ in gr " last time.)"
		}
		di in gr "Fix " in ye "$ML_user" in gr "."
	}
end

program define CheckF
	capture scalar list $ML_f
	if _rc==0 { exit }
	Break
	Failed
	di in ye _col(10) in ye "$ML_user" in gr /*
		*/ " did not issue an error, " /*
		*/ "but it also did not set the" _n /*
		*/ _col(10) "$ML_crtyp scalar."
	exit 111
end

program define CheckG
	Gexists
	Gright
end

program define Gexists
	capture local junk = $ML_g[1,1]
	if _rc==0 { exit }
	Break
	Failed
	di in ye _col(10) in ye "$ML_user" in gr /*
		*/ " did not issue an error, " /*
		*/ "but it also did not set the" _n /*
		*/ _col(10) "gradient vector."
	exit 111
end

program define Gright
	if rowsof(matrix($ML_g))==1 & colsof(matrix($ML_g))==$ML_k {
		exit
	}
	Failed
	di in ye _col(10) in ye "$ML_user" in gr /*
		*/ " returned a gradient vector that was " in ye /*
		*/ rowsof(matrix($ML_g)) " x " colsof(matrix($ML_g)) /*
		*/ in gr ", not " in ye "1 x $ML_k" in gr "."
	exit 503
end

program define CheckV
	Vexists
	Vright
	Vsym
end

program define Vexists
	capture local junk = $ML_V[1,1]
	if _rc==0 { exit }
	Break
	Failed
	di in ye _col(10) in ye "$ML_user" in gr /*
		*/ " did not issue an error, " /*
		*/ "but it also did not set the" _n /*
		*/ _col(10) "Hessian matrix."
	exit 111
end

program define Vright
	if rowsof(matrix($ML_V))==$ML_k & colsof(matrix($ML_V))==$ML_k {
		exit
	}
	Failed
	di in ye _col(10) in ye "$ML_user" in gr /*
		*/ " returned a Hessian matrix that was " in ye /*
		*/ rowsof(matrix($ML_V)) " x " colsof(matrix($ML_V)) /*
		*/ in gr ", not " in ye "$ML_k x $ML_k" in gr "."
	exit 503
end

program define Vsym
	tempname Vinv
	capture matrix `Vinv' = syminv($ML_V)
	if _rc == 0 { exit }
	Break
	local rc = _rc
	if _rc == 505 {
		di in ye _col(10) in ye "$ML_user" in gr /*
		*/ " returned a Hessian matrix that was not symmetric."
		exit 505
	}
	di in ye _col(10) in ye "$ML_user" in gr /*
		*/ " returned an invalid Hessian matrix"
	noisily matrix `Vinv' = syminv($ML_V)
	exit `rc'
end

program define EqualF /* <f0_scalar> */
	CheckF
	if scalar(`1') == scalar($ML_f) { exit }
	Failed
	di in ye _col(10) "$ML_user" in gr " returned LnL = " /*
	*/ in ye %10.0g scalar($ML_f) in gr " this time," _n /*
	*/ _col(28) "lnL = " in ye %10.0g scalar(`1') in gr " last time," _n /*
	*/ _col(21) "difference = " %10.0g scalar($ML_f-`1')
	di in gr _col(10) "The coefficient vectors were the same."
	exit 9
end

program define EqualG /* <g0_vector> */
	CheckG
	if matrix(mreldif($ML_g,`1'))==0 { exit }
	Failed
	di in ye _col(10) "$ML_user" in gr /*
	*/ " returned a different gradient vector this time;"
	di in gr _col(10) "mreldif(this time, last time) = " /*
	*/ in ye %10.0g matrix(mreldif($ML_g,`1'))
	di in gr _col(10) "The coefficient vectors were the same."
	exit 9
end

program define EqualV /* <v0_matrix> */
	CheckV
	if matrix(mreldif($ML_V,`1'))==0 { exit }
	Failed
	di in ye _col(10) "$ML_user" in gr /*
	*/ " returned a different Hessian matrix this time;"
	di in gr _col(10) "mreldif(this time, last time) = " /*
	*/ in ye %10.0g matrix(mreldif($ML_V,`1'))
	di in gr _col(10) "The coefficient vectors were the same."
	exit 9
end

program define CheckB
	capture local junk = $ML_b[1,1]
	if _rc==0 { exit }
	Break
	Failed
	di in ye _col(10) in ye "$ML_user" in gr /*
		*/ " did not issue an error, " /*
		*/ "but it dropped the input" _n /*
		*/ _col(10) "coefficient vector."
	exit 111
end

program define EqualB /* <b0 vector> */
	CheckB
	if matrix(mreldif($ML_b,`1')) == 0 { exit }
	Failed
	di in ye _col(10) "$ML_user" in gr /*
	*/ " changed the coefficient vector." _n /*
	*/ _col(10) "Your program must not change this input value."
	exit 9
end

program define NotRel
	di in gr _col(10) "test not relevant for method " /*
	*/ in ye "$ML_meth" in gr "."
end

program define GetFeas2
	di in smcl in gr _n "{hline 78}"
	#delimit ;
	di in gr
"Searching for alternate values for the coefficient vector to verify that"
_n in ye "$ML_user" in gr
" returns different results when fed a different coefficient vector:" ;
	#delimit cr
	di _n in gr "Searching..."
	ml_searc, trace restart
	di _n in smcl in gr "continuing with tests..." _n "{hline 78}"
end

program define NoteqF /* b0 f0 g0 V0 */
	local b0 "`1'"
	local f0 "`2'"
	if scalar(`f0')!=scalar($ML_f) { exit }
	Failed
	di in gr _col(10) /*
*/ "Two different coefficient vectors resulted in equal $ML_crtyp" /*
*/ _n _col(10) "values of " in ye %10.0g scalar($ML_f) in gr "."
	NotProof
	TwoParm `b0'
	exit 9
end

program define NoteqG /* b0 f0 g0 V0 */
	local b0 "`1'"
	local g0 "`3'"
	if mreldif(matrix(`g0'),matrix($ML_g)) { exit }
	Failed
	di in gr _col(10) /*
	*/ "Two different coefficient vectors resulted in equal gradient" /*
	*/ " vectors."
	NotProof
	TwoParm `b0'
	di _n in gr "Gradient vector:"
	mat list $ML_g, nohead noblank
	exit 9
end

program define NoteqV /* b0 f0 g0 V0 */
	local b0 "`1'"
	local V0 "`4'"
	if mreldif(matrix(`V0'),matrix($ML_V)) { exit }
	Failed
	di in gr _col(10) /*
	*/ "Two different coefficient vectors resulted in equal Hessians."
	NotProof
	TwoParm `b0'
	di _n in gr "Negative Hessian matrix:"
	mat list $ML_V, nohead noblank
	exit 9
end

program define NotProof
	di in gr _col(10) /*
	*/ "This does not prove there is a problem, but it suggests it."
end

program define TwoParm /* b0 */
	local b0 "`1'"
	tempname t
	mat `t' = nullmat($ML_b) \ `b0'
	di _n in gr "two coefficient vectors:"
	mat list `t', nohead noblank
end


/* the following is included to verify method lf evaluators do not
   corrupt b
*/

program define ML_elf /* <nothing> */
	local i 1
	while `i' <= $ML_n {
		tempname x`i' y`i'
		qui mat score double `x`i'' = $ML_b if $ML_samp, eq(#`i')
		if "${ML_xo`i'}" != "" {
			qui replace `x`i'' = `x`i'' + ${ML_xo`i'}
		}
		else if "${ML_xe`i'}" != "" {
			qui replace `x`i'' = `x`i'' + ln(${ML_xe`i'})
		}
		qui gen double `y`i'' = `x`i''
		local list `list' `x`i''
		local i = `i' + 1
	}
	tempvar lnf
	qui gen double `lnf' = .
	version 7
	$ML_vers $ML_user `lnf' `list'
	version 6
	local i 1
	while `i' <= $ML_n {
		capture assert `x`i''==`y`i''
		if _rc {
			Failed
			di in ye _col(10) "$ML_user" in gr " changed an"/*
			*/ " input variable (arguments 2, 3,...)." /*
			*/ _n _col(10) "It must not do that."
			exit 9
		}
		local i = `i' + 1
	}
end

exit
