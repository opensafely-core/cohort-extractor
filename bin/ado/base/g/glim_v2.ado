*! version 1.2.0  19feb2019
program define glim_v2
	version 7
	args todo eta mu return touse

	if `todo' == -1 {
		local y     "$SGLM_y"
		cap assert `y'== 0 | `y' == 1
		if "$SGLM_m" != "1" |  _rc {			/* Title */
			global SGLM_vt "Binomial"
			global SGLM_vf "u*(1-u/$SGLM_m)"
		}
		else {
			global SGLM_vt "Bernoulli"
			global SGLM_vf "u*(1-u)"
		}
		
		local m     "$SGLM_m"
		local touse "`eta'"

		capture assert `m'>0 if `touse'         /* sic, > */
		if _rc {
			di as err `"`m' has nonpositive values"'
			exit 499
		}
		capture assert `m'==int(`m') if `touse'
		if _rc {
			capture confirm number `m'
			if _rc {
				di as txt `"note: `m' has noninteger values"'
			}
			else {
				di as txt `"note: `m' is a noninteger"'
			}
		}
                capture assert `y'>=0 if `touse'
                if _rc {
                        di as err `"dependent variable `y' has negative values"'
                        exit 499
                }
                capture assert `y'<=`m' if `touse' & `y' != .
                if _rc {
                        di as err `"`y' > `m' in some cases"'
                        exit 499
                }
		capture assert `y'==int(`y') if `touse'
		if _rc {
		 	di as txt `"note: `y' has noninteger values"'	
		}
		global SGLM_mu "glim_mu 0 $SGLM_m"
		exit
	}
	if `todo' == 0 {			/* Initialize eta */
		if "$SGLM_L" == "glim_l01" {			/* Identity */
			gen double `eta' = `mu'/$SGLM_m
		}
		else if "$SGLM_L" == "glim_l02" {		/* Logit */
			gen double `eta' = ln(`mu'/($SGLM_m-`mu'))
		}
		else if "$SGLM_L" == "glim_l03" {		/* Log */
			gen double `eta' = ln(`mu'/$SGLM_m)
		}
		else if "$SGLM_L" == "glim_l05" {		/* Log compl */
			gen double `eta' = ln1m(`mu'/$SGLM_m)
		}
		else if "$SGLM_L" == "glim_l06" {		/* Loglog */
			gen double `eta' = -ln(-ln(`mu'/$SGLM_m))
		}
		else if "$SGLM_L" == "glim_l07" {		/* Cloglog */
			gen double `eta' = ln(-ln1m(`mu'/$SGLM_m))
		}
		else if "$SGLM_L" == "glim_l08" {		/* Probit */
			gen double `eta' = invnorm(`mu'/$SGLM_m)
		}
		else if "$SGLM_L" == "glim_l09" {		/* Reciprocal */
			gen double `eta' = $SGLM_m/`mu'
		}
		else if "$SGLM_L" == "glim_l10" {		/* Power(-2) */
			gen double `eta' = ($SGLM_m/`mu')^2
		}
		else if "$SGLM_L" == "glim_l11" {		/* Power(a) */
			gen double `eta' = (`mu'/$SGLM_m)^$SGLM_a
		}
		else if "$SGLM_L" == "glim_l12" {		/* OPower(a) */
			gen double `eta' = /*
				*/ ((`mu'/($SGLM_m-`mu'))^$SGLM_a-1) / $SGLM_a
		}
		else {
			gen double `eta' = $SGLM_m*($SGLM_y+.5)/($SGLM_m+1)
		}
		exit 
	}
	if `todo' == 1 {			/* V(mu) */
		gen double `return' =  `mu'*(1-`mu'/$SGLM_m)
		exit 
	}
	if `todo' == 2 {			/* (d V)/(d mu) */
		gen double `return' = 1 - 2*`mu'/$SGLM_m
		exit
	}
	if `todo' == 3 {			/* deviance */
		local y "$SGLM_y"
		local m "$SGLM_m"
		if "`y'" == "" {
			local y "`e(depvar)'"
		}
		cap assert `y' == 0 | `y' == 1
		local isbinary = (_rc == 0)
		if "`m'" == "" {
			local m "`e(m)'"
		}
		if `m' == 1 & `isbinary' == 1 {
			gen double `return' = cond(`y', /*
				*/ -2*ln(`mu'), -2*ln1m(`mu'))
			exit
		}
		gen double `return' = cond(`y'>0 & `y'<`m', /*
			*/ 2*`y'*ln(`y'/`mu') + /*
			*/ 2*(`m'-`y') * /*
			*/ ln((`m'-`y')/(`m'-`mu')), /*
			*/ cond(`y'==0, 2*`m' * /*
			*/ ln(`m'/(`m'-`mu')), /*
			*/ 2*`y'*ln(`y'/`mu')) )
		exit
	}
	if `todo' == 4 {			/* Anscombe */
		local y "$SGLM_y"
		local m "$SGLM_m"
		if "`y'" == "" {
			local y "`e(depvar)'"
		}
		if "`m'" == "" {
			local m "`e(m)'"
		}
		gen double `return' = /*
			*/ 1.5*(`y'^(2/3)*_hyp2f1(`y'/`m') -  /*
			*/      `mu'^(2/3)*_hyp2f1(`mu'/`m')) / /*
			*/ ((`mu'*(1-`mu'/`m'))^(1/6))
		exit
	}
	if `todo' == 5 {			/* ln-likelihood */
		local y "$SGLM_y"
		local m "$SGLM_m"
		if "`y'" == "" {
			local y "`e(depvar)'"
		}
		if "`m'" == "" {
			local m "`e(m)'"
		}
		tempname sig2
                if $SGLM_s1 {
                        scalar `sig2' = $SGLM_s1
                }
                else {
			if _caller()>=11 {
                        	scalar `sig2' = /// 
					$SGLM_ph*(($ML_N-$ML_kCns)/$ML_N)
			}
			else {
				scalar `sig2' = ///
                                        $SGLM_ph*(($ML_N-$ML_k)/$ML_N)
			}
                }
		gen double `return' = `sig2'*cond(`y'==0, /*
			*/ lngamma(`m'+1)-lngamma(`m'-`y'+1) + /*
			*/ `m'*ln1m(`mu'/`m'), /*
			*/ cond(`y'==`m', /*
			*/ lngamma(`m'+1)-lngamma(`y'+1) + /*
			*/ `m'*ln(`mu'/`m'),/*
			*/ lngamma(`m'+1)-lngamma(`y'+1)-lngamma(`m'-`y'+1) + /*
			*/ `y'*ln(`mu'/`m') + (`m'-`y')*ln1m(`mu'/`m')))
		exit
	}
	if `todo' == 6 {
		local m "$SGLM_m"
		if "`m'" == "" {
			local m "`e(m)'"
		}
		gen double `return' = (1-2*`mu'/`m')/(6*sqrt(`mu'*(1-`mu'/`m')))
		exit
	}
	noi di as err "Unknown call to glim variance function"
	error 198
end

exit
