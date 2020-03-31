*! version 1.0.5  17jun2019
/*
	multiple elastic net
*/
program _mult_enet
	version 16.0
	syntax anything 		///
		[if] [in]		///
		[, enp(string)		/// elastic net penalty numlist
		lambdas(passthru)	/// lasso penalty
		stop(passthru)		/// smallest change in deviance
		wgt(string)		/// observational weights
		laout(string)		///
		nodebug			///
		nolog			///
		grid(passthru)		///
		*]			//  other options for _pglm

	local options `options' `log'

	local state = c(rngstate)
						//  touse
	marksample touse	
						//  laout
	_lasso_parse_laout `laout'
	local laout_name `s(laout_name)'
	local laout_isreplace `s(laout_isreplace)'

	if (`"`stop'"'=="") {
		local scdev_opts stop(0)
	}
	else {
		local scdev_opts `stop'
	}

	local n_alpha : word count `enp'
						//  get lasso penalty vector
	tempname lpvec
	qui GetLassoPenalty `anything' `if' `in', lpvec(`lpvec') 	///
		enp(`enp') cv_opts(`cv_opts') `lambdas' 	///
		`scdev_opts' `options' wgt(`wgt') `grid'
	local en_method `s(en_method)'
						//  do lasso for each alpha
	tempname lpvec_i 
	tempfile fname esfname
	local preklp = 0
	forvalues i=1/`n_alpha' {
		local alpha : word `i' of `enp'
		if ( `"`en_method'"' == "different") {
			matrix `lpvec_i' = `lpvec'[1..., `i']
		}
		else {
			matrix `lpvec_i' = `lpvec'
		}
		set rngstate `state'
		tempname laout_aux

		ShowLog , `log' i(`i') n_alpha(`n_alpha') alpha(`alpha')

		_pglm `anything' `if' `in' `wgt',	///
			alphas(`alpha')			///
			lambdas(`lpvec_i')		///
			`cv_opts'			///
			`scdev_opts'			///
			preklp(`preklp')		///
			laout(`laout_aux', replace)	///
			nodisplay			///
			nopost				///
			`options'			
		local preklp = `preklp' + e(n_lambda)
		local laout_list `laout_list' `laout_aux'
	}
	set rngstate `state'
						//  merge laout results
	mata : _LASYS_merge(		///
		"`laout_list'", 	///
		`"`laout_name'"',	///
		`laout_isreplace',	///
		`"`touse'"')
	_pglm_display, `debug'
end
					//----------------------------//
					// get lasso penalty vector 
					//----------------------------//
program GetLassoPenalty, sclass
	syntax [anything] [if] [in]	///
		,enp(string)		///
		lpvec(string)		///
		[cv_opts(string)	///
		wgt(string)		///
		grid(passthru)		///
		*]

	foreach alpha of local enp {
		_pglm `anything' `if' `in' `wgt', nocompute 	///
			alphas(`alpha') `options' `cv_opts' nopost `grid'
		mat `lpvec' = nullmat(`lpvec'), e(lpvec)
	}

	local en_method `e(crossgrid)'
	mata : reset_lasso_penalty(`"`lpvec'"', `"`en_method'"')
	sret local en_method `en_method'
end

program ShowLog
	syntax [, nolog i(string) n_alpha(string) alpha(string)]

	if (`"`log'"' == "nolog") {
		exit
		// NotReached
	}
	
	di 
	di "{p 0 2 2}"
	di as text "alpha "		///
		as res `i'		///
		as text " of "		///
		as res `n_alpha'	///
		as text ": alpha = "	///
		as res %5.4f "`alpha'"
	di "{p_end}
end

mata :
mata set matastrict on
					//----------------------------//
					// reset lasso penalty based on
					// crossgrid method
					//----------------------------//
void reset_lasso_penalty(		///
	string scalar	st_lpvec,	///
	string scalar	method)
{
	real matrix	lpmat
	real colvector	lp_step
	real scalar	i, lpmax

	lpmat = st_matrix(st_lpvec)

	if (method == "union") {		// union
		lpmat = vec(lpmat)
		_sort(lpmat, -1)
	}
	else if (method == "augmented") {	// augmented
		lp_step = lpmat[.,1]
		for (i=2; i<=cols(lpmat); i++) {
			lpmax = lp_step[1]
			lp_step = select(lpmat[.,i], lpmat[.,i]:>=lpmax) ///
				\ lp_step
		}
		lpmat = lp_step
	}
	/* return results, note that if method == "different", we return the
	  original matrix */
	st_matrix(st_lpvec, lpmat)
}
end
