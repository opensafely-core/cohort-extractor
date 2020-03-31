*! version 1.2.3  15oct2019
/* predict after areg */
program define areg_p, sortpreserve properties(default_xb)
	version 6, missing

	syntax [anything(name=newvar)] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		GenScores `0'
		exit
	}
	_areg_p `newvar' `if'`in', `options'
end

program define _areg_p
	version 6, missing
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

	local myopts "DResiduals Residuals Scores D XBD"
	/* note that DR is full sample, rest are estimation subsample only */
	/* default is XB */



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
	syntax [if] [in] [, `myopts' ]


		/* Step 4:
			Concatenate switch options together
		*/
	local type  "`dresidu'`residua'`d'`xbd'"


		/* Step 5:
			quickly process default case if you can 
			Do not forget -nooffset- option -- none for -areg-.
		*/
	if "`type'"=="" {
		version 7: di in gr "(option {bf:xb} assumed; fitted values)"
		_predict `vtyp' `varn' `if' `in', xb 
		label var `varn' "Xb"
		exit
	}


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

	if "`type'" =="dresiduals" {
		tempvar xb
		quietly _predict double `xb' if `touse', xb 
		gen `vtyp' `varn' = `e(depvar)' - `xb' if `touse'
		label var `varn' "d[`e(absvar)'] + residual"
		exit
	}
			

		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/

	if "`type'"=="residuals" {
		// GenScores updates `touse' wrt e(sample)
		GenScores `vtyp' `varn' if `touse'
		exit
	}
	qui replace `touse'=0 if !e(sample)

	/* for the remaining, we also need to know the full estimation 
	   subsample
	*/
	tempvar smpl
	qui gen byte `smpl' = e(sample)

	if "`type'"=="d" | "`type'"=="xbd" {
		// check that estimation sample has not changed
		checkestimationsample
		tempvar xb u wt
		quietly {
			if `"`e(wexp)'"' != "" {
				tempvar wt
				gen double `wt' `e(wexp)'
			}
			else	local wt 1
			_predict double `xb' if `smpl', xb 
			/* sort after predict in case there are TS opts	*/
			/*  that require the -tsset- sort		*/
			sort `e(absvar)' `smpl'
			by `e(absvar)' `smpl': gen double `u' = 	/*
				*/ sum(`wt'*(`e(depvar)' - `xb')) /	/*
				*/ sum(`wt') if `smpl'
			by `e(absvar)' `smpl': replace `u' = `u'[_N] /* sic */
		}
		if "`type'"=="d" {
			gen `vtyp' `varn' = `u' if `touse'
			label var `varn' "d[`e(absvar)']"
		}
		else {
			gen `vtyp' `varn' = `xb' + `u' if `touse'
			label var `varn' "Xb + d[`e(absvar)']"
		}
		exit
	}
	error 198
end

program GenScores, rclass
	version 9, missing
	syntax [anything] [if] [in] [, * ]
	marksample touse
	qui replace `touse'=0 if !e(sample)
	_score_spec `anything', `options'
	local varn `s(varlist)'
	local vtyp `s(typlist)'
	tempvar xb u
	quietly _predict double `xb' if `touse', xb 
	quietly _areg_p double `u' if `touse', d 
	gen `vtyp' `varn' = `e(depvar)' - `xb' - `u' if `touse'
	label var `varn' "Residuals"
	return local scorevars `varn'
end
