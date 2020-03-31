*! version 1.0.1  05sep2019
program define cmclogit_p
	version 16

	if ("`e(cmd)'" != "cmclogit") {
	
di as err "{helpb cmclogit##|_new:cmclogit} estimation results not found"
		
		exit 301
	}
	
	syntax anything [if] [in] [iw] [, Pr XB STDP SCores ///
				     noOFFset          /// 
	                             SINGLEtons        /// undocumented
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
	 *	alternative() - margins only
	 *	dydx()     - margins only
	 *	dyex()     - margins only
	 *	eydx()     - margins only
	 *	eyex()     - margins only				*/
	
	if ("`pr'`xb'`stdp'`scores'" == "") {
		local pr pr
		di "{txt}(option {bf:pr} assumed; Pr(`e(altvar)'))"
	}

	if ("`e(casevars)'" != "") {
		local casevars casevars(`e(casevars)')
	}
	
	if ("`scores'" != "") {
		local choice choice(`e(depvar)')
	}
	
	if ("`e(marktype)'" == "altwise") {
		local altwise altwise
	}
	
	if ("`offset'" != "nooffset" & "`e(offset)'" != "") {
		local offvar `e(offset)'
	}

	if "`alternative'" != "" {
		GetAltIndex, `alternative'
		local altidx altidx(`s(altidx)')
	}
	
	tempvar touse
		
	// cmsample will issue errors and warnings.
	
	cmsample `e(altspvars)' `offvar' `if' `in', ///
		gen(`touse')		            ///
		`casevars'		            ///
		`choice'		            ///
		`altwise'		            ///
		`singletons'			    ///
		marksample

	asclogit_p `anything' if `touse' [`weight'`exp'], `pr' `xb' `stdp' ///
		`scores' `offset' `altwise' `outcome' `j1' `j2'	`altidx'   ///
		`dydx' `dyex' `eydx' `eyex'

end

program define GetAltIndex, sclass
	syntax, alternative(string asis)

	gettoken var at: alternative, parse("==")
	gettoken eq at: at, parse("==")

	sreturn local altidx `at'
end

exit
