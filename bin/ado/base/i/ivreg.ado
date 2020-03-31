*! version 5.5.0  03dec2018
program define ivreg, byable(onecall) prop(svyb svyj svyr)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if _caller() < 11 {
		local vv : di "version " string(_caller()) ":"
	}
	else	local vv "version 10.1:"
	`vv' `BY' _vce_parserun ivreg, unparfirsteq equal ///
	unequalfirsteq	mark(CLuster) : `0'
	if "`s(exit)'" != "" {
		exit
	}

	version 6.0, missing
	local version 05.00.9

	if replay() {
		if `"`e(cmd)'"' != "ivreg"  { error 301 }
		else {
			if _by() { error 190 } 
			regress `0'
		}
		exit
	}
	`BY' Estimate `0'
end

program Estimate, eclass byable(recall)
	local n 0

	gettoken lhs 0 : 0, parse(" ,[") match(paren)
	IsStop `lhs'
	if `s(stop)' { error 198 }
	while `s(stop)'==0 { 
		if "`paren'"=="(" {
			local n = `n' + 1
			if `n'>1 { 
capture noi error 198 
di in red `"syntax is "(all instrumented variables = instrument variables)""'
exit 198
			}
			gettoken p lhs : lhs, parse(" =")
			while "`p'"!="=" {
				if "`p'"=="" {
capture noi error 198 
di in red `"syntax is "(all instrumented variables = instrument variables)""'
di in red `"the equal sign "=" is required"'
exit 198 
				}
				local end`n' `end`n'' `p'
				gettoken p lhs : lhs, parse(" =")
			}
			tsunab end`n' : `end`n''
			tsunab exog`n' : `lhs'
		}
		else {
			local exog `exog' `lhs'
		}
		gettoken lhs 0 : 0, parse(" ,[") match(paren)
		IsStop `lhs'
	}
	local 0 `"`lhs' `0'"'

	tsunab exog : `exog'
	tokenize `exog'
	local lhs "`1'"
	local 1 " " 
	local exog `*'

	syntax [if] [in] [aw fw pw iw] [, PSCore(string) /*
	*/ FIRST hc2 hc3 NOConstant SCore(passthru)	/*
	*/ Level(cilevel) Beta EForm(passthru)		/*
	*/ * ]

	local diopts level(`level') `beta' `eform'

	if `"`score'"' != "" {
		local 0 `", `score'"'
		syntax [, NONOPT ]
		error 198	// [sic]
	}

	if "`hc2'`hc3'" != "" {
		if "`hc2'"!="" {
			di in red "option `hc2' invalid"
		}
		else	di in red "option `hc3' invalid"
		exit 198
	}

	if `"`exp'"' != "" { 
		local wgt `"[`weight'`exp']"'
	}

	marksample touse
	markout `touse' `lhs' `exog' `exog1' `end1'

	Subtract newexog : "`exog1'" "`exog'"

/* now check for perfect collinearity in instrument list */
	_rmcoll `newexog'
	local newexog "`r(varlist)'"


	local endo_ct : word count `end1'
	local ex_ct : word count `newexog'
	if `endo_ct' > `ex_ct' {
		di in red "equation not identified; must have at " /*
		*/ "least as many instruments not in"
		di in red "the regression as there are "           /*
		*/ "instrumented variables"
		exit 481
	}

	if "`first'"!="" {
		doFirst "`end1'" "`exog' `newexog'" `touse' `"`wgt'"' /*
		*/ `"`noconstant'"' `"level(`level')"'
	}

	_regress `lhs' `end1' `exog' (`exog' `newexog') /*
		*/ if `touse' `wgt', `noconstant' `options' `diopts'

	if `"`pscore'"' != "" {
		quietly ///
		_predict double `pscore' if e(sample), residuals
		est local pscorevars `pscore'
	}
	est local cmd 
	est local version `version'
	est local instd `end1'
	est hidden local marginsprop nolinearize
	est local title "Instrumental variables (2SLS) regression"
	est local footnote "ivreg_footnote"
	if "`end1'" != "" {
		est local insts `exog' `newexog'
	}
	est local cmd ivreg
	_prefix_footnote
end


program define IsStop, sclass
				/* sic, must do tests one-at-a-time, 
				 * 0, may be very large */
	if `"`0'"' == "[" {		
		sret local stop 1
		exit
	}
	if `"`0'"' == "," {
		sret local stop 1
		exit
	}
	if `"`0'"' == "if" {
		sret local stop 1
		exit
	}
	if bsubstr(`"`0'"',1,3) == "if(" {
		sret local stop 1
		exit
	}
	if `"`0'"' == "in" {
		sret local stop 1
		exit
	}
	if `"`0'"' == "" {
		sret local stop 1
		exit
	}
	else	sret local stop 0
end


program define Disp 
	local first ""
	local piece : piece 1 64 of `"`0'"'
	local i 1
	while "`piece'" != "" {
		di in gr "`first'`piece'"
		local first "               "
		local i = `i' + 1
		local piece : piece `i' 64 of `"`0'"'
	}
	if `i'==1 { di }
end

					/* performs first-stage regressions */
program define doFirst  /* <endoglst> <instlst> <if> <in> <weight> */
	args    endolst    /*  variable list  (including depvar)
		*/  instlst    /*  list of instrumental variables 
		*/  touse      /*  touse sample
		*/  weight     /*  full weight expression w/ []
		*/  nocons     /*  noconstant option 
		*/  levopt     /*  CI level */	

	di in gr _newline "First-stage regressions"
	di in smcl in gr     "{hline 23}"

	tokenize `endolst'
	local i 1
	while "``i''" != "" {
		regress ``i'' `instlst' `weight' if `touse', `nocons' `levopt'
		local i = `i' + 1
	}
	di
end

/*  Remove all tokens in dirt from full */
 *  Returns "cleaned" full list in cleaned */

program define Subtract   /* <cleaned> : <full> <dirt> */
	args	    cleaned     /*  macro name to hold cleaned list
		*/  colon	/*  ":"
		*/  full	/*  list to be cleaned 
		*/  dirt	/*  tokens to be cleaned from full */
	
	tokenize `dirt'
	local i 1
	while "``i''" != "" {
		local full : subinstr local full "``i''" "", word all
		local i = `i' + 1
	}

	tokenize `full'			/* cleans up extra spaces */
	c_local `cleaned' `*'       
end

exit
