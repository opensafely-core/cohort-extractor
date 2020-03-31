*! version 1.0.2  05sep2019
program define cmroprobit_p
	version 16

	if ("`e(cmd)'" != "cmroprobit") {
	
di as err "{helpb cmroprobit##|_new:cmroprobit} estimation results not found"
		
		exit 301
	}
	
	syntax anything [if] [in] [iw] [, Pr PR1 XB STDP SCores ///
	                             SINGLEtons            /// undocumented
				outcome(passthru)	///
				j1(passthru)		///
				j2(passthru)		///
				alternative(passthru)	///
				altidx(passthru)	///
				dydx(passthru)		///
				dyex(passthru)		///
				eydx(passthru)		///
				eyex(passthru)		///
	                          ]
	
	/* undocumented: 
	 * 	iweight    - margins only
	 * 	outcome()  - margins only
	 * 	j1()       - margins only
	 * 	j2()       - margins only 
	 *	altidx()   - margins only
	 *	dydx()     - margins only
	 *	dyex()     - margins only
	 *	eydx()     - margins only
	 *	eyex()     - margins only				*/
	
	if ("`pr'`pr1'`xb'`stdp'`scores'" == "") {
		local pr pr
		di as txt "(option {bf:pr} assumed; Pr(`e(altvar)'))"
	}

	if ("`e(casevars)'" != "") {
		local casevars casevars(`e(casevars)')
	}
	
	if ("`scores'" != "") {
		local choice choice(`e(depvar)') ranks
	}
	
	if ("`e(marktype)'" == "altwise") {
		local altwise altwise
	}

	if "`alternative'" != "" {
		GetAltIndex, `alternative'
		local altidx altidx(`s(altidx)')
	}
	
	tempvar touse
		
	// cmsample will issue errors and warnings.
	
	cmsample `e(altspvars)' `if' `in', ///
		gen(`touse')		   ///
		`casevars'		   ///
		`choice'		   ///
		`altwise'		   ///
		`singletons'		   ///
		marksample

	asprobit_p `anything' if `touse' [`weight'`exp'], `pr' `pr1' `xb' ///
		`stdp' `scores' `altwise' `outcome' `j1' `j2' `altidx'    ///
		`dydx' `dyex' `eydx' `eyex'
			
end

program define GetAltIndex, sclass
	syntax, alternative(string asis)

	gettoken var at: alternative, parse("==")
	gettoken eq at: at, parse("==")

	sreturn local altidx `at'
end

exit
