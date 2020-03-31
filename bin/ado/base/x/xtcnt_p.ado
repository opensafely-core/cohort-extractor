*! version 1.2.8  04apr2019
program define xtcnt_p
	version 6, missing
	local vv : display "version " string(_caller()) ":"

	local 0_orig `0'
	
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
	local myopts "XB N NU0 IRU0 pr0(string) pr(string)"


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


		/* Step 4:
			Concatenate switch options together
		*/
	local type "`n'`nu0'`iru0'`xb'"
	
	if "`type'" == "n" {
		`vv' _xtcmd_p `0_orig'
		exit
	}
	
	local args `"`pr0'`pr'"'
	if "`pr0'" != "" {
		if "`e(model)'"!="re" & "`e(cmd2)'"!="xtn_re" {
			di as err "the pr0() option is allowed only " ///
				"for random-effects models"
			exit 198
		}
		local propt pr0(`pr0')
	}
	if "`pr'" != "" {
		if "`e(model)'"!="pa" {
			if "`e(cmd)'" == "xtnbreg" {
			di as err "xtnbreg does not support the " ///
				"pr() option"
			}
			else if "`e(cmd)'" == "xtpoisson" {
				di as err "the pr() option in " ///
					"xtpoisson is only allowed for " ///
					"population-averaged models"
			}
			exit 198
		}
		local propt pr0(`pr')
	}

		/* Step 5:
			quickly process default case if you can
			Do not forget -nooffset- option.
		*/

		/* Step 6:
			mark sample (this is not e(sample)).
		*/
	marksample touse


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

	if ("`type'"=="" & `"`args'"'=="") | "`type'"=="xb" {
		if "`type'"=="" {
			version 8: ///
			di "{txt}(option {bf:xb} assumed; linear prediction)"
		}
		_predict `vtyp' `varn' if `touse', xb `offset'
		exit
	}
	if "`e(model)'"=="" {
		local cmd2mac	cmd2
		local cmd2val	xtn_re
	}
	else {
		local cmd2mac	model
		local cmd2val	re
	}

	if "`type'"=="nu0" {
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset'
		gen `vtyp' `varn' = exp(`xb') if `touse'
		label var `varn' "Predicted number of events (assuming u_i=0)"
		if "`e(cmd)'"=="xtnbreg" & "`e(`cmd2mac')'"=="`cmd2val'" {
			tempname rr
			scalar `rr' = (exp(_b[/ln_r]))
			if `rr' > 1 {
				qui replace `varn' = /*
					*/ `varn'*(exp(_b[/ln_s]))/(`rr'-1)
			}
			else {
				di as txt "warning:  estimated value of r " _c
				di as txt "is less than one; expected value" _c
				di as txt " undefined."
				qui replace `varn' = .
			}
		}
		exit
	}

	if "`type'"=="iru0" {
		tempvar xb
		qui _predict double `xb' if `touse', xb nooffset
		gen `vtyp' `varn' = exp(`xb') if `touse'
		label var `varn' "Predicted incidence rate (assuming u_i=0)"
		if "`e(cmd)'"=="xtnbreg" & "`e(`cmd2mac')'"=="`cmd2val'" {
			tempname rr
                        scalar `rr' = (exp(_b[/ln_r]))
                        if `rr' > 1 {
                               qui replace `varn' = /*
                                        */ `varn'*(exp(_b[/ln_s]))/(`rr'-1)
                        }
                        else {
                                di as txt "warning:  estimated value of r " _c
                                di as txt "is less than one; expected value" _c
                                di as txt " undefined."
                                qui replace `varn' = .
                        }
		}
		exit
	}
	local type `type'
	if `"`args'"'!="" {
		if "`type'" != "" {
			error 198
		}
		tpredict_p2 "`vtyp'" "`varn'" "`touse'" "`offset'" "`pr0'"
		exit
	}

	error 198
end
