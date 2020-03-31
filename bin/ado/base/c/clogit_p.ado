*! version 1.4.1  29nov2018
program define clogit_p, sortpreserve
	version 6, missing

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		GenScores `0'
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
	local myopts "Pc1 PU0 Residuals Hat RSTAndard DX2 DBeta GDX2 GDBeta"


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
	local type ///
	       "`pc1'`pu0'`residuals'`hat'`rstandard'`dx2'`dbeta'`gdx2'`gdbeta'"


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

	if "`type'"=="" | "`type'"=="pc1" {
		if "`type'"=="" {
			#delimit ;
			di in smcl in gr 
"(option {bf:pc1} assumed; probability of success given one success within group)";
			#delimit cr
		}
		tempvar xb denom p
		quietly { 
			_predict double `xb' if `touse', xb `offset'
			sort `e(group)'
			by `e(group)': gen double `denom' = sum(exp(`xb'))
			by `e(group)': gen double `p' = exp(`xb')/`denom'[_N]
			drop `denom'
		}
		gen `vtyp' `varn' = `p' if `touse'
		label var `varn' "Pr(`e(depvar)'|single outcome w/i `e(group)')"
		exit
	}

	if "`type'" == "pu0" {
		tempvar xb 
		quietly { 
			_predict double `xb' if `touse', xb `offset'
		}
		gen `vtyp' `varn' = 1/(1+exp(-`xb')) if `touse'
		label var `varn' "Pr(`e(depvar)'|fixed effect is 0)"
		exit
	}

		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/
	
	qui replace `touse'=0 if !e(sample)
			
			/* 
                                these regression diagnostics are applicable
                                for the 1:M matched data only and are not
                                allowed with -robust- or -cluster()- 
			*/

	if "`e(vcetype)'"=="Robust" {
		di as err "diagnostics are not allowed after robust " ///
			  "estimation"
		exit 198
	}

	if "`type'"=="rstandard" {
		tempvar resid hat
		qui predict double `resid' if `touse', resid `offset'
		qui predict double `hat' if `touse', hat `offset'
		gen `vtyp' `varn' = `resid'/sqrt(1-`hat') if `touse'
		label var `varn' "standardized Pearson residual"
		exit
	}
	
	if "`type'"=="dx2" {
		tempvar rstd
		qui predict double `rstd' if `touse', rstandard `offset'
		gen `vtyp' `varn' = `rstd'^2
		label var `varn' "Lack of fit diagnostic dX^2"
		exit
	}

	if "`type'"=="dbeta" {
		tempvar resid hat 
		qui predict double `resid' if `touse', resid `offset'
		qui predict double `hat' if `touse', hat `offset'
		gen `vtyp' `varn' = `resid'^2*`hat'/(1-`hat')^2
		label var `varn' "Delta-Beta influence statistic"
		exit
	}
		/* remaining types require we know the group id */

	local group `e(group)'
	if "`type'"=="gdx2" {
		tempvar dx2
		qui predict double `dx2' if `touse', dx2 `offset'
		egen `vtyp' `varn' = sum(`dx2') if `touse', by(`group')
		label var `varn' "Lack of fit diagnostic for each group"
		exit
	}

	if "`type'"=="gdbeta" {
		tempvar dbeta
		qui predict double `dbeta' if `touse', dbeta `offset'
		egen `vtyp' `varn' = sum(`dbeta') if `touse', by(`group')
		label var `varn' ///
			"Delta-Beta influence statistics for each group"
		exit
	}

		/* 
                        remaining types require we know model variables,
                        predicted probabilities, linear prediction and weights
                        (if any) 
		*/

	local y `e(depvar)'	
	tempvar mvar
	qui egen `mvar' = sum(`y') if `touse', by(`group')
	cap assert `mvar' <=1 if e(sample)
	if _rc != 0 {
		di as err ///
		   "diagnostics after clogit are allowed only for 1-M matched data"
		exit 459
	}
	
	if `"`e(wtype)'"' != "" {
		if `"`e(wtype)'"' != "fweight" {
			di in red `"not possible with `e(wtype)'s"'
			exit 135
		}
		tempvar w
		qui {
			gen double `w' `e(wexp)'
			compress `w'
		}
		local lab "weighted "
	}
	else	local w 1
	
	if "`type'"=="residuals" {
		tempvar pr
		qui predict double `pr' if `touse', pc1 `offset'
		gen `vtyp' `varn' = (`y'-`pr')/sqrt(`pr') if `touse'
		label var `varn' `"`lab'Pearson residual"'
		exit
	}

	if "`type'"=="hat" {
		if "`offset'" != "" {
			di as err "option nooffset not allowed"
			exit 198
		}
		if "`e(offset)'" != "" {
			local moffset "-`e(offset)'"
		}
		// check if constraints() is specified
		tempname cns
		cap mat `cns' = get(Cns)
		if _rc == 0 {
			if rowsof(`cns') != e(k_autoCns) {
				di as err ///
				"hat predictions not possible with constraints"
				exit 198
			}
		}
		else if _rc != 111 {
			exit _rc
		}	
		tempvar xb pr
		qui predict double `pr' if `touse', pc1
		qui predict double `xb' if `touse', xb
			/*get centered rhs*/
		GetRhs rhs
		tokenize `rhs'
		local xvarsc
		while "`1'"!="" {
			tempvar xm xc
			qui bysort `group': ///
				gen double `xm' = cond(_n==_N, sum(`pr'*`1'),.)
			qui by `group': replace `xm'=`xm'[_N] if `xm' == .
			qui by `group': gen `xc'= `1' - `xm'
			local xvarsc `xvarsc' `xc'
			mac shift
		}
			/* generate new dependent variable*/
		tempvar z
		qui gen double `z' = `xb' + (`y' - `pr')/`pr' `moffset' ///
								 if `touse'
		
			/* fit regression */
			tempname esthold
			estimates hold `esthold'
			cap noi {
				tempvar wght hat
				qui gen double `wght' = `w'*`pr'
				qui regress `z' `xvarsc' [iw=`wght'] ///
								if `touse', noc
				qui predict double `hat', hat
			}
			estimates unhold `esthold'
			if _rc!=0 {
				exit _rc
			}
		
		gen `vtyp' `varn' = `hat'*`pr' if `touse'
		label var `varn' `"`lab'Leverage"'
		exit
	}
			/* Step 10.
				Issue r(198), syntax error.
				The user specified more than one option
			*/
	error 198
end

program define GetRhs /* name */ 
	args where
	tempname b 
	mat `b' = get(_b)
	local rhs : colnames `b'
	mat drop `b'
	local n : word count `rhs'
	tokenize `rhs'
	if "``n''"=="_cons" {
		local `n'
	}
	c_local `where' "`*'"
end

program GenScores, rclass
	version 9, missing
	syntax [anything] [if] [in] [, * ]
	marksample touse
	_score_spec `anything', `options'
	local varn `s(varlist)'
	local vtyp `s(typlist)'
	tempname eb
	matrix `eb' = e(b)
	local xvars : colna `eb'
	local CONS _cons
	local xvars : list xvars - CONS
	_get_offopt `e(offset)'
	local offopt `"`s(offopt)'"'
	quietly _clogit_lf `e(depvar)' `xvars' if `touse', ///
		group(`e(group)') score(`varn') beta(`eb') `offopt'
	if ("`e(cmd2)'"=="xtlogit") {
		label var `varn' "equation-level score from xtlogit"	
	}
	else {
		label var `varn' "equation-level score from clogit"
	}
	return local scorevars `varn'
end

exit
