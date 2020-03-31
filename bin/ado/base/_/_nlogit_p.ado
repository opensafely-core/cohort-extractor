*! version 7.2.0  02aug2006
program define _nlogit_p, sort
	version 7, missing
	
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

	local k = e(levels)
	forvalues i = 1/`k' {
        	local myopts `myopts' p`i' xb`i' condp`i' iv`i' 
	}
	local myopts `myopts' pb xbb condpb ivb

                /* Step 2:
                        call _pred_se, exit if done,
                        else collect what was returned.
                */

        _pred_se `"`myopts'"' `0'
        if `s(done)' { exit }
        local vtyp `s(typ)'
        local varn `s(varn)'
        local 0 `"`s(rest)'"'

                /* Step 3:
                        Parse your syntax.
                */

	syntax [if] [in] [, `myopts']

                /* Step 4:
                        Concatenate switch options together
                */

	forvalues i = 1/`k' {
			local args `args'`p`i''`xb`i''`condp`i''`iv`i'' 
	}
	local args `args'`pb'`xbb'`condpb'`ivb'
		/* Step 5:
                        quickly process default case if you can
                        Do not forget -nooffset- option.
                */

					/* calculation */
	marksample touse
					/* main eqs */
	forvalues i = 1/`k' {
		tempvar beta`i'
		_predict double `beta`i'' if `touse', equation(#`i')
	}
					/* taus */
	tempname b
	mat `b' = e(b)
	local j = `k' + 1
	local t = `k' - 1
	forvalues i = 1/`t' {
		tempvar tau`i'
		qui gen double `tau`i'' = 0 
		local a = `k' - `i' 
		qui tab `e(level`a')'
		local r = r(r)
		forvalues x = 1/`r' {
			qui replace `tau`i'' = [#`j']_b[_cons]  /*
			*/ if `e(level`a')' == `x'
			local j = `j' + 1
		} 	
	}
	local bylist`k' `e(group)'
	local i = `k' - 1
	while `i' > 0 {
		local j = `i' + 1
		local l = `k' - `i'
		local bylist`i' `bylist`j'' `e(level`l')'
		local i = `i' -1
	}

                                                /* level 1 */
        tempvar I1 P1
        qui bysort `bylist1': gen double `I1' = sum(exp(`beta1'))
        qui by `bylist1': replace `I1' = `I1'[_N]
        qui gen double `P1' = exp(`beta1')/`I1'
        qui replace `I1' = ln(`I1')
                                                /* rest levels */
        local i 2
        while `i' <= `k' {
                tempvar I`i' P`i'
                local j = `i' - 1
                qui gen double `P`i'' = exp(`beta`i'' + `tau`j''*`I`j'')
                tempvar tmp
                qui gen double `tmp' = 0
                qui bysort `bylist`j'' : replace `tmp' = `P`i'' if _n == 1
                qui by `bylist`i'': gen double `I`i'' = sum(`tmp')
                qui by `bylist`i'' : replace `I`i'' = `I`i''[_N]
                qui replace `P`i'' = `P`i''/`I`i''
                qui replace `I`i'' = ln(`I`i'')
                local i = `i' + 1
        }
						
	if `"`args'"' == "" | (`"`args'"' == "`pb'") | `"`args'"' == "`p`k''" {
		if `"`args'"' == "" {
			di as txt "(option pb assumed; Pr(`e(level`k')'))
		}
		qui gen `vtyp' `varn' = 1 if `touse'
		forvalues i = 1/`k' {
			qui replace `varn' = `varn'*`P`i'' if `touse'
		}	
		label var `varn' "Pr(`e(depvar)')"
	}
	else {
		forvalues i = 2/`k' {
			local l = `k' - `i' + 1
			if `"`args'"' == "`p`l''" {
				qui gen `vtyp' `varn' = 1 if `touse'
				forvalues j = `i'/`k' {
				qui replace `varn'= `varn'*`P`j'' if `touse' 
				}
				label var `varn' "Pr(`e(level`l')')"
			}
		}

		if `"`args'"' == "`xb`k''"  | `"`args'"' == "`xbb'" {
			qui gen `vtyp' `varn' = `beta1' if `touse'
			label var `varn' /*
			*/"linear prediction for the bottom-level alternatives"
		}
		if `"`args'"' == "`condp`k''" | `"`args'"' == "`condpb'" {
			qui gen `vtyp' `varn' = `P1' if `touse'
			label var `varn' /*
*/ "Pr(bottom alternative | alternative is available after all earlier choices)"
		}
		if `"`args'"' == "`iv`k''" | `"`args'"' == "`ivb'" {
			qui gen `vtyp' `varn' = `I1' if `touse'
			label var `varn' /*
			*/ "inclusive value for the bottom-level alternatives"
		}
		forvalues i = 2/`k' {
			local l = `k' - `i' + 1
			if `"`args'"' == "`xb`l''" {
				qui gen `vtyp' `varn' = `beta`i'' if `touse'
				label var `varn' /*
			*/ "linear prediction for the level `l' alternatives"
			}
			if `"`args'"' == "`condp`l''" {
				qui gen `vtyp' `varn' = `P`i'' if `touse'
				if `l' == 1 {
					label var `varn' /*
					*/"Pr(each first-level alternative)"
				}
				else label var `varn' /*
*/ "Pr(level `l' alternative | alternative is available after earlier choices)"
			}
			if `"`args'"' == "`iv`l''" {
				if `i' == `k' { 
					dis as err "invalid option"
					exit 198
				}
				qui gen `vtyp' `varn' = `I`i'' if `touse'
				label var `varn' /*
			*/ "inclusive value for the level `l' alternatives"
			}
		}
	}
end 

