*! version 1.0.1  01may2019
program define cmrologit_p
	version 16

	if ("`e(cmd)'" != "cmrologit") {
	
di as err "{helpb cmrologit##|_new:cmrologit} estimation results not found"
		
		exit 301
	}
	
	syntax anything [if] [in] [, Pr XB STDP ///
				     noOFFset   /// 
	                             SINGLEtons /// undocumented
	                          ]
	
	if ("`pr'`xb'`stdp'" == "") {
		local pr pr
			
di as txt "(option {bf:pr} assumed; conditional probability that alternative is ranked first)"
	
	}

	if ("`e(marktype)'" == "altwise") {
		local altwise altwise
	}
	
	if ("`offset'" != "nooffset" & "`e(offset)'" != "") {
		local offvar `e(offset)'
	}
	
	tempvar touse
		
	// cmsample will issue errors and warnings.
	
	cmsample `e(indvars)' `offvar' `if' `in', ///
		gen(`touse')		          ///
		`altwise'		          ///
		`singletons'			  ///
		marksample
	
	// Compute prediction for xb and stdp.

	_pred_se "Pr" `anything' if `touse', `pr' `xb' `stdp' `offset'
	
	if (`s(done)') { 
		exit 
	}
	
	local vtyp `s(typ)'
	local varn `s(varn)'
	local 0    `"`s(rest)'"'
	
	syntax [if] [in] [, Pr noOFFset ]

	marksample touse

	tempvar p
	
	GetP `p' if `touse', `offset'
	
	gen `vtyp' `varn' = `p' if `touse'
	
	label variable `varn' "Prob that alternative is most attractive"
end

program define GetP, sortpreserve
	syntax newvarname if/ [, noOFFSET ]
	
	local touse `if'

	tempvar xb
	
	quietly {

		_predict double `xb' if `touse', xb `offset'
	
		bysort `touse' `e(caseid)': gen double `varlist' ///
					    = sum(exp(`xb')) if `touse'
						
		bysort `touse' `e(caseid)': replace `varlist' ///
					    = exp(`xb')/`varlist'[_N] if `touse'
	}
end

