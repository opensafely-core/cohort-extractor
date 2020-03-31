*! version 1.4.0  16mar2016
program define scob_p
	version 6, missing

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		ml score `0'
		exit
	}

		/* Step 1:
			place command-unique options in local myopts
			Note that standard options are
			LR:
				Index XB Cooksd Hat 
				REsiduals RSTAndard RSTUdent
				STDF STDP STDR CONstant(varname) 
			SE:
				Index XB STDP CONstant(varname)
		*/
	local myopts "Pr"

		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
	_pred_se "`myopts'" `0'
	if `s(done)' { exit }
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'


		/* Step 3:
			Parse your syntax.
		*/
	syntax [if] [in] [, `myopts' noOFFset]

	if "`pr'"=="" {
		di in smcl in gr "(option {bf:pr} assumed; Pr(`e(depvar)'))"
	}
	tempvar tt
	tempname a alpha
	qui _predict double `tt' `if' `in' , xb
	mat `a' = get(_b)
	if `:colnfreeparms e(b)' {
		mat `a' = `a'[1,"/lnalpha"]
	}
	else {
		mat `a' = `a'[1,"lnalpha:_cons"]
	}
	scalar `alpha' = `a'[1,1]
	scalar `alpha' = exp(`alpha')
	gen double `vtyp' `varn' = 1 - 1/(1+exp(`tt'))^`alpha'
	#delimit cr
	label var `varn' "Pr(`e(depvar)')"
end
