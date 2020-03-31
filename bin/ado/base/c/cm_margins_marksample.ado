*! version 1.0.0  05oct2018
program cm_margins_marksample
	version 16

	// Marks sample for -margins, noesample- after cm estimation commands
	// that set e(marginsmark) to cm_margins_marksample.

	syntax newvarlist(min=2 max=2) [fw pw iw] [if] [in] ///
		[, 					    ///
		ZEROweight				    ///
		OVER(varlist fv)			    ///
		WITHIN(varlist fv)			    ///
		SUBPOP(passthru)			    ///
		]

	local newtouse  : word 1 of `varlist'
	local newsubvar : word 2 of `varlist'

	if ("`e(marktype)'" == "altwise") {
		local altwise altwise
	}
	else if ("`e(marktype)'" != "casewise") {
		error 301
	}

	// Only one of over(), within(), or subpop() allowed.

	if ((`"`over'"'!="") + (`"`within'"'!="") + (`"`subpop'"'!="") > 1) {

		opts_exclusive "over() within() subpop()"
	}

	// Markout weights, if, in, e(indvars), e(casevars), and e(offset)
	// without doing any checks.

	tempvar touse

	cmsample `e(indvars)' `e(offset)' [`weight'`exp'] `if' `in', ///
		casevars(`e(casevars)')				     ///
		generate(`touse')				     ///
		marksample					     ///
		nocheck						     ///
		`altwise'					     ///
		`zeroweight'

	// Markout and check svy design variables.

	if ("`e(prefix)'" == "svy") {

		tempvar svyvar
		qui gen byte `svyvar' = `touse'

		svymarkout `svyvar'

		// Cases must be nested within svyvar when casewise.
		// Otherwise it is an error.

		if ("`altwise'" == "") {
			cmsample if `touse', casevar(`svyvar')  ///
					     casevartype("svy") ///
					     noerror2000
		}

		drop `touse'
		rename `svyvar' `touse'
	}

	// Note: touse is in the state to be used for checking.

	// Check weights, alternatives, and casevars.

	cmsample [`weight'`exp'] if `touse', ///
		casevars(`e(casevars)')      ///
		generate(`touse', replace)   ///
		marksample		     ///
		`altwise'                    ///
		`zeroweight'		     ///
		noerror2000

	// Note: touse is now in its final state. Above call might have marked
	// out choice sets of size 1 (and given a warning if this happened).

	// Check subpop().

	tempvar subvar

	if (`"`subpop'"' != "") {

		// Generate subpop() variable, treat missings like zero
		// by not updating touse.

		tempvar tousetmp

		qui gen byte `tousetmp' = `touse'

		_svy_subpop `tousetmp' `subvar', `subpop'

		cmsample if `touse', casevar(`subvar')     ///
				     casevartype("subpop") ///
				     noerror2000
	}
	else {
		qui gen byte `subvar' = `touse'
	}

	// Cases must be nested with over() and within().
	// Otherwise it is an error.
	// Missing values of over() and within() are not marked out.
	// Missing values are treated like any other value.

	if (`"`over'"' != "") {
		cmsample if `touse', casevar(`over')     ///
				     missing             ///
				     casevartype("over") ///
				     noerror2000
	}

	if (`"`within'"' != "") {
		cmsample if `touse', casevar(`within')     ///
				     missing               ///
				     casevartype("within") ///
				     noerror2000
	}

	rename `touse'  `newtouse'
	rename `subvar' `newsubvar'
end

exit

Markout order:

1. Markout done together:

	[if] [in]
	e(indvars)
	e(offset)
	weights
	e(casevars)

   Note: If -predict(nooffset)- is specified with -margins, noesample-, this
   program does not know this, and this program will still markout missings
   in the offset variable.

2. svymarkout: Markout and check svy design variables.

	- If missing and casewise, check that they don't split up a case;
	  otherwise error. If altwise, no error, just marked out.

3. Check together:

	- Choice sets of size one: Markout and warning, possibly error 2000
	  (no observations).

 	- Check weight not constant within case. Error if not case specific.

	- Check repeated alternatives within case. Error if repeated.
   	  Note that an earlier svy check would have checked this.

	- Check casevar not constant within case. Error if not constant.

	- Note that an error 2000 is never given. Let -margins- do it.

*** At this point, touse variable is final. ***

4. Generate subpop() variable, treat missings like zero.

	- Check subpop variable. Error if not constant within case, regardless
	  of whether markout is casewise or altwise.

5. Check over() or within().

	- Missing treated like any other value.
	- Error if not constant within case, regardless of whether markout is
	  casewise or altwise.
	- Any missing values in over() or within() are NOT marked out.

END

