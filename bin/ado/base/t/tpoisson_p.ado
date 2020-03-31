*! version 1.0.8  21oct2019
program define tpoisson_p
	version 11.0

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		global ZTP_tp_ `e(llopt)'
		global ZTP_ul_tp_ `e(ulopt)'
		cap noi ml score `0'
		macro drop ZTP_tp_
		macro drop ZTP_ul_tp_
		if (_rc) exit _rc
		exit
	}

		/* Step 1:
			place command-unique options in local myopts
			Note that standard options are
			LR:
				Index XB Cooksd Hat
				REsiduals RSTAndard RSTUdent
				STDF STDP STDR noOFFset
			SE:
				Index XB STDP noOFFset
		*/
	local myopts "N IR CM Pr(string) CPr(string) "

		/* Step 2:
			call _propts, exit if done,
			else collect what was returned.
		*/
	_pred_se "`myopts'" `0'
	if `s(done)'  exit
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'


		/* Step 3:
			Parse your syntax.
		*/
	syntax [if] [in] [, `myopts' noOFFset]


		/* Step 4:
			Concatenate switch options together
		*/
	local type "`n'`ir'`cm'"
	local args `"`pr'`cpr'"'
	if "`pr'" != "" {
		local propt pr(`pr')
	}

		/* Step 5:
			mark sample (this is not e(sample)).
		*/
	marksample touse
							// Parse LL
	local ll `e(llopt)'
	local tp = e(llopt)
							// Check UL
	local ul `e(ulopt)'
	local ul_isvar = `e(ul_isvar)'
	local y `e(depvar)'
	CheckDepUL, ul_tp(`ul') ul_isvar(`ul_isvar')		///
		dep(`y') touse(`touse')

		/* Step 6:
			quickly process default case if you can
			Do not forget -nooffset- option.
		*/
	if ("`type'"=="" & `"`args'"'=="") | "`type'"=="n" {
		if "`type'"=="" {
			di in gr /*
			*/ "(option {bf:n} assumed; predicted number of events)"
		}
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset'
		qui gen `vtyp' `varn' = exp(`xb') if `touse'
		label var `varn' "Predicted number of events"
		exit
	}
		/* Step 7:
			handle options that take argument one at a time.
			Comment if restricted to e(sample).
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/

		/* Step 8:
			handle switch options that can be used in-sample or
			out-of-sample one at a time.
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/

	if "`type'"=="ir" {
		tempvar xb
		qui _predict double `xb' if `touse', xb nooffset
		qui gen `vtyp' `varn' =exp(`xb')  if `touse'
		label var `varn' "Predicted incidence rate"
		exit
	}

	if "`type'"=="cm" {
		tempvar xb d1 x m d0
		if ("`ll'" != ""){
			cap confirm names `ll'
			if _rc {
			/* it is not a name, should be a number */
				cap confirm number `ll'
				if _rc{
					di as error
					"{cmd:ll(`ll')} must specify " ///
					"a nonnegative value"
					exit 200
				}
				else{
					local tp = `ll' + 1
					capture noisily
				}
			}
			else{
			/* ll() does not contain a number */
				cap confirm variable `ll'
				if _rc!=0 {
				/* ll() contains a name that is not a */
				/* variable.  possibly it is a scalar */
					local tp = `ll'
					cap confirm number `tp'
					if _rc!=0{
						di as error ///
						"{cmd:ll(`ll')} must " ///
						"specify a nonnegative value"
						exit 200
					}
				}
				else {
				/* ll() contains the name of a variable */
					qui summarize `ll' if `touse'
					if r(min) < 0 {
						di as error ///
						"{cmd:ll(`ll')} must " ///
						"contain all " ///
						"nonnegative values"
						exit 200
					}
					tempvar tp
					gen double `tp' = `ll' + 1
				}
			}
		}
		qui _predict double `xb' if `touse', xb `offset'
		if (`"`ul'"'=="") {
			qui gen double `d0'= 	///
				poissontail(exp(`xb'), `ll') if `touse'
			qui gen double `d1'=	///
				poissontail(exp(`xb'), `tp') if `touse'
			local lb "Conditional mean of n > ll(`ll')"
		}
		else if (`"`ll'"'!="") {
			qui gen double `d0' = 	///
				poissontail(exp(`xb'), `ll')-	///
				poissontail(exp(`xb'), `ul'-1) if `touse'
			qui gen double `d1' = 	///
				poissontail(exp(`xb'),`ll'+1)-	///
				poissontail(exp(`xb'), `ul') if `touse'
			local lb "Conditional mean of ll(`ll') < n < ul(`ul')"
		}
		else if (`"`ll'"'=="") {
			qui gen double `d0' = 	///
				1 - poissontail(exp(`xb'), `ul'-1) if `touse'
			qui gen double `d1' = 	///
				1 - poissontail(exp(`xb'), `ul') if `touse'
			local lb "Conditional mean of n < ul(`ul')"
		}
		qui gen `vtyp' `varn' = exp(`xb')* (`d0')/(`d1') if `touse'
		label var `varn' `"`lb'"'
		exit
	}
	local type `type'
	if `"`args'"'!="" {
		if "`type'" != "" {
			error 198
		}
		if (`"`ul'"'=="") | (`"`cpr'"'=="" & `"`pr'"'!="") {
			tpredict_p2 "`vtyp'" "`varn'" "`touse'" "`offset'" /*
				*/ "`pr'" "`cpr'"
		}
		else {
							// cpr with ul()
			PredictCpr `vtyp' `varn' if `touse', 		///
				`offset' cpr(`cpr')			///
				ll(`ll') ul(`ul')
		}
		exit
	}
	error 198
end
							//--PredictCpr--//
program PredictCpr
	syntax newvarname [if] [, 	///
		noOFFset]		///
		cpr(passthru)		///
		[ll(passthru)]		///
		ul(passthru)
	tempvar cprv1 cprv2
	CheckCpr `if',  `cpr' cprv1(`cprv1') cprv2(`cprv2') `ll' `ul'
	local cpr1 `s(cpr1)'
	local cpr2 `s(cpr2)'
	if `"`cpr2'"' == "" {
		PredictCpr1 `typlist' `varlist' `if',		///
			cprv1(`cprv1') cpr1(`cpr1') 		///
			`offset' `ll' `ul'
	}
	else {
		PredictCpr2 `typlist' `varlist' `if',		///
			cprv1(`cprv1') cpr1(`cpr1')		/// 
			cprv2(`cprv2') cpr2(`cpr2') 		///
			`offset' `ll' `ul'
	}
end
							//------PredictCpr1---//
program PredictCpr1
	syntax newvarname [if],		///
		cprv1(string)		///
		cpr1(string)		///
		[noOFFset]		///
		[ll(string)]		///
		ul(string)
	tempvar xb mu PrB Pr1
	qui _predict double `xb' `if', xb `offset'
	qui gen double `mu' = exp(`xb') `if' 
	if (`"`ll'"'!="") {
		qui gen double `PrB' = 	///
			poissontail(`mu',`ll'+1)-poissontail(`mu',`ul')	`if'
	}
	else {
		qui gen double `PrB' = 1 - poissontail(`mu',`ul') `if'
	}
	qui gen double `Pr1' = poissonp(`mu', `cprv1') `if'
	gen `typlist' `varlist' = `Pr1'/`PrB' `if'
	local y `e(depvar)'
	if (`"`ll'"'!="") {
		label var `varlist' `"Pr(`y'=`cpr1' | `ll'<`y'<`ul')"'
	}
	else {
		label var `varlist' `"Pr(`y'=`cpr1' | `y'<`ul')"'
	}
end
							//------PredictCpr2---//
program PredictCpr2
	syntax newvarname [if],		///
		cprv1(string)		///
		cprv2(string)		///
		cpr1(string)		///
		cpr2(string)		///
		[ll(string)]		///
		ul(string)		///
		[noOFFset]
	tempvar xb mu PrB Pr12	
	qui _predict double `xb' `if', xb `offset'
	qui gen double `mu' = exp(`xb') `if'
	if (`"`ll'"'!="") {
		qui gen double `PrB' = 	///
			poissontail(`mu',`ll'+1)-poissontail(`mu',`ul')	`if'
	}
	else  {
		qui gen double `PrB' = 1 -poissontail(`mu',`ul') `if'
	}
	qui gen double `Pr12' = poisson(`mu', `cprv2')	///
		-poisson(`mu',`cprv1'-1) `if' 
	gen `typlist' `varlist' = `Pr12'/`PrB' `if'
	local y `e(depvar)'
	if (`"`ll'"'!="") {
		label var `varlist' `"Pr(`cpr1'<=`y'<=`cpr2' | `ll'<`y'<`ul')"'
	}
	else {
		label var `varlist' `"Pr(`cpr1'<=`y'<=`cpr2' | `y'<`ul')"'
	}

end
							//-----CheckCpr----//
program CheckCpr, sclass
	syntax [if] , cpr(string)	///
		cprv1(string)		///
		cprv2(string)		///
		[ll(passthru)]		///
		ul(passthru)
	
	gettoken cpr1 cpr2 : cpr, parse(", ")	
	
	if (`"`cpr2'"'=="") {				// check cpr1
		CheckCpr1 `if', cpr1(`cpr1') cprv1(`cprv1') `ll' `ul'
	}
	else {						// check cpr2
		CheckCpr2 `if', cpr1(`cpr1') cpr2(`cpr2')	///
			cprv1(`cprv1') cprv2(`cprv2') `ll' `ul'
	}
	sreturn local cpr1 `s(cpr1)'
	sreturn local cpr2 `s(cpr2)'
end
							//---CheckCpr1---//
program CheckCpr1, sclass
	syntax [if],			///
		cpr1(string)		///
		cprv1(string)		///
		[ll(string)]		///
		ul(string)

	capture confirm integer number `cpr1'
	local cpr1n = !_rc
	capture assert `cpr1'>0
	local cpr1p = !_rc
	capture confirm numeric variable `cpr1'
	local cpr1v = !_rc
	if ((!`cpr1n'&!`cpr1v') | !`cpr1p') {
		di as error ///
			"argument to {bf:cpr()}" ///
			" must be positive integer"    ///
			" or numeric variable"
		exit 198
	}
	qui gen `cprv1' = `cpr1' `if'
	if (`"`ll'"'!= "") {
		capture assert `cprv1' > `ll' `if'
		local cpr1ll = !_rc
	}
	else {
		local cpr1ll = 1
	}
	capture assert `cprv1' < `ul' `if'
	local cpr1ul = !_rc
	if (!`cpr1ll' | !`cpr1ul') & (`"`ll'"'!="") {
		di as error	///
			"{p 0 4 2}argument to {bf:cpr()} "	///
			"must be greater than "			///
			"left truncation point `ll' "		///
			"and less than right "			///
			"truncation point `ul'{p_end}" 
		exit 198
	}
	else if (!`cpr1ll' | !`cpr1ul') & (`"`ll'"'=="") {
		di as error	///
			"{p 0 4 2}argument to {bf:cpr()} "	///
			"must be less than right "		///
			"truncation point `ul'{p_end}" 
		exit 198
	}
	sreturn local cpr1 `cpr1'
end
							//-------CheckCpr2--//
program CheckCpr2, sclass
	syntax [if], 			///
		cpr1(string)		///
		cpr2(string)		///
		cprv1(string)		///
		cprv2(string)		///
		[ll(string)]		///
		ul(string)
	
	capture confirm integer number `cpr1'
	local cpr1n = !_rc
	capture assert `cpr1'>0
	local cpr1p = !_rc
	capture confirm numeric variable `cpr1'
	local cpr1v = !_rc
						// valid separator	
	gettoken sep cpr2 : cpr2, parse(", ")		
	if `"`sep'"' != "," {
		di as error ///
			"invalid separator in {bf:cpr()}, " ///
			"must use comma: ex. {bf:cpr(1 ,3)}"
		exit 198
	}
						// check the second number
	capture confirm integer number `cpr2'
	local cpr2n = !_rc
	capture assert `cpr2' == .
	local cpr2m = !_rc
	capture confirm numeric variable `cpr2'
	local cpr2v = !_rc
	capture assert `cpr2' > 0
	local cpr2p = !_rc
						// first argument
	if (!`cpr1p' |(!`cpr1n' & !`cpr1v')) {
		di as error ///
		"first argument to {bf:cpr()}" ///
		" must be positive integer" ///
		" or numerical variable"
		exit 198
	}
						// second argument
	if ((!`cpr2n' & !`cpr2v') | !`cpr2p' | `cpr2m') {
		di as error ///
		"{p 0 4 2}second argument to {bf:cpr()}" ///
		" must be nonmissing, positive integer," ///
		" or numeric variable{p_end}"
		exit 198
	}
						// cpr1 <=cpr2
	capture assert `cpr1' <= `cpr2'	
	if _rc {
		di as error ///
			"{p 0 4 2}upper bound of `cpr2' must be" ///
			" greater than or equal to the" ///
			" lower bound of `cpr1'{p_end}"
		exit 198
	}
	qui gen `cprv1' = `cpr1' `if'
	qui gen `cprv2' = `cpr2' `if'
						//check cpr with ul and ll
	if (`"`ll'"'!="") {
		capture assert `cprv1' > `ll' `if'
		local cpr1ll = !_rc
		capture assert `cprv1' < `ul' `if'
		local cpr1ul = !_rc
		capture assert `cprv2' > `ll' `if'
		local cpr2ll = !_rc
		capture assert `cprv2' < `ul' `if'
		local cpr2ul = !_rc
		if (!`cpr1ll' | !`cpr1ul') {
			di as error	///
				"{p 0 4 2}first argument to {bf:cpr()} " ///
				"must be greater than "			///
				"left truncation point `ll' "		///
				"and less than right "			///
				"truncation point `ul'{p_end}" 
			exit 198
		}
		if (!`cpr2ll' | !`cpr2ul') {
			di as error	///
				"{p 0 4 2}second argument to {bf:cpr()} " ///
				"must be greater than "			///
				"left truncation point `ll' "		///
				"and less than right "			///
				"truncation point `ul'{p_end}" 
			exit 198
		}
	}
	else {
		capture assert `cprv1' < `ul' `if'
		local cpr1ul = !_rc
		capture assert `cprv2' < `ul' `if'
		local cpr2ul = !_rc
		if (!`cpr1ul') {
			di as error	///
				"{p 0 4 2}first argument to {bf:cpr()} " ///
				"must be and less than right "		///
				"truncation point `ul'{p_end}" 
			exit 198
		}
		if (!`cpr2ul') {
			di as error	///
				"{p 0 4 2}second argument to {bf:cpr()} " ///
				"must be and less than right "		///
				"truncation point `ul'{p_end}" 
			exit 198
		}
	}
	sreturn local cpr1 `cpr1'
	sreturn local cpr2 `cpr2'
end

							//------CheckDepUL--//
program CheckDepUL
	syntax [, ul_tp(string) 	///
		ul_isvar(string) 	///
		dep(string) 		///
		touse(string)]

	qui sum `dep' if `touse' 
	local max_dep = r(max)
	
	if (`"`ul_tp'"' == "") {
		cap noisily	
	}
	else if (`ul_isvar' == 0) {
		if `max_dep' >= `ul_tp' {
			di as error	///
				"{p 0 4 2}truncation value specified in "  ///
				"{bf:ul()} must be "			   ///
				"greater than `max_dep', the greatest "  ///
				"value in `dep'{p_end}"
			exit 459
		}
	}
	else if (`ul_isvar' == 1) {
		cap assert `ul_tp' > `dep' if `touse' & !missing(`dep')
		if _rc != 0{
			di as error ///
				"{p 0 4 2}values in `dep' must be smaller " ///
				"than their truncation value specified "  ///
				"in {bf:ul(`ul_tp')}{p_end}"
			exit 459
		}
	}
end
