*! version 6.7.0  21jun2018
program define xtpcse, eclass byable(onecall) prop(xt xtbs)
	if replay() {
		if "`e(cmd)'" != "xtpcse" {
			error 301
		}
		if _by() {
			error 190
		}
		Display `0'
		exit
	}

	if _by() {
		by `_byvars'`_byrc0': Estimate `0'
	}
	else	Estimate `0'
	version 10: ereturn local cmdline `"xtpcse `0'"'

end

program define Estimate, eclass byable(recall) sort
	version 7, missing

	syntax [varlist(fv ts)] [if] [in] [iweight aweight] [, CAsewise	  /*
		*/ noConstant Correlation(string) Detail FORCERHO HETonly /*
		*/ Independent Level(cilevel) NMK 	NP1	  /*
		*/ Pairwise  RHOtype(string) SIGmavar(string) *]
	if "`s(fvops)'" == "true" | _caller() >= 11 {
		local vv : di "version " string(max(11,_caller())) ", missing:"
	}

	_get_diopts diopts, `options'
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	if _by() {
		_byoptnotallowed sigmavar() `"`sigmavar'"'
	}

					/* sic, sigmavar() undocumented */

	_xt, trequired
	local panvar  `r(ivar)'
	local timevar `r(tvar)'
	tempname tdelta
	scalar `tdelta' = r(tdelta)
	local tvreal `timevar'
	local tfmt : format `timevar'
					/* syntax errors */
	if "`forcerho'" != "" { global T_fcrho True }
	if "`hetonly'" != "" & "`independent'" != "" {
		di in red "options hetonly and independent may not be"  /*
			*/ " specified together"
		exit 198
	}
	if "`sigmavar'" != "" & "`hetonly'`independent'" == "" {
		di in red "option sigmavar may only be specified when"	/*
			*/ " options hetonly or independent "
		di in red "are specified"
		exit 198
	}
	if "`sigmavar'" != "" { confirm new variable `sigmavar' }

	local ct : word count `casewise' `pairwise' `mle'
	if `ct' > 1 {
		di in red "options casewise and pairwise are"	/*
			*/ " mutually exclusive"
		exit 198
	}
	local casewis = "`pairwise'" == ""

	gettoken depvar varlist : varlist
	_fv_check_depvar `depvar'
	local depname "`depvar'"
		
	getCorr corrtyp : `correlation'
	
					/* Set sample */
	marksample touse
	markout `touse' `depvar' `timevar' `panvar'

					/* Report time gaps */
	tsreport if `touse', report `detail' panel
	local gaps `r(N_gaps)'
	if `gaps' > 0 & "`corrtyp'" != "independent" {
	     di in bl "(note: computations for rho restarted at each gap)"
	}

capture noisily {

					/* set up weight */
	tempvar wtvar
	local constant1 `constant'
	if `fvops' {
		fvexpand `varlist' if `touse'
		local varlist `"`r(varlist)'"'
	}
	local vnames `varlist'
	if "`constant'" == "" {
		local vnames `vnames' _cons
	}
	local varlst1 `varlist'
	local depvar1 `depvar'

	if "`weight'" != "" { 
		qui gen double `wtvar'`exp'

		if "`weight'" == "aweight" { 
					/* standardize aweights, 
					   make e(rmse) correct */
			sum `wtvar', meanonly
			qui replace `wtvar' = `wtvar' / r(mean)
			
			noi `vv' _rmcoll `depvar' `varlist' [aw=`wtvar']
			local qq "quietly"

			tempvar yvar
			qui gen double `yvar' = `depvar'*sqrt(`wtvar')
			local depvar `yvar'

			local i = 1
			foreach var of local varlist {
				tempvar var`i'
				qui gen double `var`i'' = `var'*sqrt(`wtvar')
				local varlist1 `varlist1' `var`i''
				local i = `i'+1
			}

			if "`constant'" == "" {
				tempvar cons
				qui gen double `cons' = sqrt(`wtvar')
				local varlist `varlist1' `cons'
				local constant "noconstant"
                                local tssopt "tsscons"	  
			}

			qui replace `wtvar' = 1
		}

		local wgt "[`weight'=`wtvar']"

/* -- deleted --
		if "`corrtyp'" == "ar1" | "`corrtyp'"=="psar1" {
			sort `touse' `panvar'
			capture assert `wtvar' == `wtvar'[_n-1] 	/*
				*/ if `panvar'==`panvar'[_n-1] & 	/*
				*/ `touse' & `touse'[_n-1]
			if _rc {
				di in red "weights must be constant within" /*
					*/ " panel when correlation(ar1) or"
				di in red "     or correlation(psar1) are"  /*
					*/ " specified"
				sort `panvar' `timevar'
				exit 459
			}
			sort `panvar' `timevar'
		}

		if "`independent'`hetonly'"== "" {
			sort `touse' `timevar'
			capture assert `wtvar' == `wtvar'[_n-1] 	/*
				*/ if `timevar'==`timevar'[_n-1] & 	/*
				*/ `touse' & `touse'[_n-1]
			if _rc {
				di in red "weights must be constant within" /*
				   */ " time period when panels are correlated"
				di in red "     (the default)"
				sort `panvar' `timevar'
				exit 459
			}
			sort `panvar' `timevar'
		}
  --------------- */

	}
	else	qui gen byte `wtvar' = 1

			/* Note, aweights currently do what regress does
			 * and report sum of int(sum of weights) in e(N) */

					/* check remaining syntax */
	tempvar e
	tempname rho sigma V XomegaX XpXi rhomat
	global T_rhomat `rhomat'
	

	_crcar1 `rho' rhotype : `e', `rhotype' check
	if "`rhotype'" == "theil" | "`rhotype'" == "nagar" {
		di in red "invalid method for rhotype(), rhotype(`rhotype')"
		exit 198
	}

					/* initial regression */

	`vv' `qq' ///
	_regress `depvar' `varlist' `wgt' if `touse', ///
		`constant' `tssopt' noheader notable
	local exp1 "`exp'"	/* save for later use */
	est local wexp "`exp'"
	qui predict double `e' if `touse', resid

	local k = e(df_m)
	local kc = e(df_m) + ("`constant'" == "")
	tempname b
	mat `b' = e(b)
	version 11: mat colnames `b' = `vnames'

					/* handle operated variables */
	local vartype : set type
	set type double
	tsrevar `depvar'
	local depvar `r(varlist)'
	if `fvops' {
		fvrevar `varlist'		
	}
	else {
		tsrevar `varlist'		
	}
	local varlist `r(varlist)'
	set type `vartype'	
	local restore 0
	if "`corrtyp'" != "independent" | "`independent'`hetonly'" == "" { 
/* moved outside. Otherwise ts operator may not work with -hetonly-
   or -independent- (whg)
		local vartype : set type
		set type double
		tsrevar `depvar'
		local depvar `r(varlist)'
		tsrevar `varlist'		
		local varlist `r(varlist)'
		set type `vartype'
*/
					/* possibly, preserve the data */
					/* NOTE:  there is a strong
					 * presumption that all data is used
					 * if autocorrelation is specified */
		if "`corrtyp'" != "independent" { 
			preserve 
			keep `depvar' `varlist' `wtvar' `panvar' `timevar' /*
				*/ `touse' `e'
			qui keep if `touse'
			*qui replace `touse' = 1
			local restore 1
		}
	}

					/* get a sequential 1..M panel id */
	tempvar ivar sigvar
	sort `touse' `panvar' `timevar'
	quietly by `touse' `panvar': gen `c(obs_t)' `ivar' = 1 if _n==1 & `touse'
	qui replace `ivar' = sum(`ivar')
	local M = `ivar'[_N]			/* number of panels -- M */
	qui replace `ivar' = . if !`touse'


					/* possibly do prais-transformation */
	if "`corrtyp'" != "independent" { 

		if "`constant'" == "" {
			tempname one
			qui gen double `one' = 1
			local varlist `varlist' `one'
			local constant "noconstant"
			local tssopt "tsscons"
		}

		tempname rhos
		tempvar tvname
		gen double `tvname' = `timevar'	/* just so we can use t as */
		local timevar `tvname'		/* a regressor		   */
						/* proper tsset required   */
		qui tsset `ivar' `timevar', delta(`=`tdelta'') ///
			format(`tfmt') noquery
		doPrais `depvar' `varlist' , residuals(`e') 		/*
			*/ corrtype(`corrtyp') rhotype(`rhotype') 	/*
			*/ m(`M') k(`kc') ivar(`ivar') panvar(`panvar') `np1'
		`vv' ///
		qui _regress `depvar' `varlist' `wgt', nocons `tssopt'
		est local wexp "`exp1'"
		drop `e'
		qui predict double `e' if `touse', resid
		mat `b' = e(b)
		version 11: mat colnames `b' = `vnames'

		if "`corrtyp'" == "ar1" {
			local n_cr 1
		}
		else	local n_cr `M'
	}
	else	local n_cr 0

					/* adjust R^2 */
	if "`weight'" == "aweight" & "`constant1'" == "" {
		tempname rss tss y2sum yconsum
		tempvar y2 ycons
		scalar `rss' = e(rss)
		qui gen double `y2' = `depvar'^2 if e(sample)
		qui gen double `ycons' = `cons'*`depvar' if e(sample)
		summ `y2' if e(sample), meanonly
		scalar `y2sum' = r(sum)
		summ `ycons' if e(sample), meanonly
		scalar `yconsum' = r(sum)
		qui count if e(sample)
		local N = r(N)
		scalar `tss' = `y2sum' - `yconsum'^2/`N'
		est scalar r2 = 1 - `rss'/`tss'
	} 


					/* get estimate of sigma and
					 * X'(Omega)X			*/

	if "`hetonly'" == "hetonly" {
		getSigH `sigvar' `sigma' : `e' `M' `ivar' `touse' `wtvar'
		qui mat accum `XomegaX' = `varlist' [iw=`sigvar'*`wtvar']  /*
			*/ if `touse' , `constant'
	}
	else if "`independent'" == "independent" {
		tempname sigscal
		getSigI `sigscal' `sigma' : `e' `M' `touse' `wtvar'
		if "`sigmavar'" != "" { qui gen double `sigvar' = `sigscal' }
		qui mat accum `XomegaX' = `varlist' `wgt' 	/*
			*/ if `touse' , `constant'
		qui mat `XomegaX' = `sigscal' * `XomegaX'
	}
	else {
		getSigma `sigma' n_sigma :  /*
			*/ `e' `M' `ivar' `timevar' `touse' `casewis' `wtvar'
			/* leaves correct sort for glsaccum, timevar ivar */
		qui mat glsaccum `XomegaX' = `varlist' `wgt' if `touse',    /*
			*/ `constant' glsmat(`sigma') row(`ivar') 	    /*
			*/ group(`timevar')
	}

					/* compute pcse/ols variance */

	if e(rmse) == 0 {
		di in red "model perfectly predicts dependent variable"
		exit 2001
	}
	mat `XpXi' = e(V) / e(rmse)^2
	mat `V' = `XpXi' * `XomegaX' * `XpXi'
	if "`nmk'" != "" { mat `V' = e(N)*`V'/e(df_r) }
		/* For large # of regressors, `V' might not be symmetric */
	mat `V' = 0.5*(`V' + `V'')
	
	version 11: mat colnames `V' = `vnames'
	version 11: mat rownames `V' = `vnames'
					/* post results */
	est scalar n_cf = e(N) - e(df_r)

				/* clear some e() results from -regress- */
	est local df_r 
	est local r2_a
	est local ll
	est local ll_0
	est local model
	est local F

	qui tsset `panvar' `timevar', delta(`=`tdelta'') format(`tfmt')
	isBalCt `touse'
	est local balance `r(balance)'
	est scalar g_min = `r(min)'
	est scalar g_avg = `r(mean)'
	est scalar g_max = `r(max)'
	capture est scalar n_sigma = `n_sigma'
	if !_rc {
		est local missmeth "casewise"
		if `n_sigma' < r(mean) / 2 {
			#delimit ;
			di in bl 
"(note: the number of observations per panel, e(n_sigma) = `n_sigma'," _n
"       used to compute the disturbance of covariance matrix e(Sigma)" _n
"       is less than half of the average number of observations per panel," ; 
			di in blu "       e(n_avg) = " r(mean)
			"; you may want to consider the pairwise option)" ;
			#delimit cr
		}
	}
	else {
		est local missmeth "`pairwise'"
	}
						/* clear some regress e()s */
	if `restore' {
		restore
	}
	if `fvops' {
		local fvopts findomitted buildfvinfo
	}
	capture noi est post `b' `V' [`weight'`exp'], noclear ///
		depname(`depname') `fvopts'
	if _rc == 506 & "`pairwise'" != "" {
		di in red "estimated VCE is not positive definite, "	/*
			*/ "option pairwise may not be used."
		exit _rc
	}
	else if _rc {
		exit _rc
	}
	_post_vce_rank

	if "`varlst1'" != "" {
		qui test `varlst1'
		est scalar df   = r(df)
		est scalar chi2 = r(chi2)
		est scalar p    = r(p)
	}
	else {
		est scalar df   = 0
		est scalar chi2 = .
		est scalar p    = .
	}
	est local chi2type Wald
	
	est local cons `constant1'
	est local rhotype `rhotype'
	est local corr `corrtyp'

	if "`sigmavar'" != "" { rename `sigvar' `sigmavar' }

	capture di `sigma'[1,1]
	if !_rc { est matrix Sigma `sigma' }

	est scalar n_cr = `n_cr'
	est scalar N_gaps = `gaps'
	est scalar N_g = `M'

	if "$T_rho" != "" { est local rho $T_rho }
	capture est matrix rhomat $T_rhomat 

	if "`hetonly'" == "hetonly" {
		est local vcetype Het-corrected
		est scalar n_cv = `M'
	}
	else if "`independent'" == "independent" {
		est local vcetype Indep-corrected
		est scalar n_cv = 1
	}
	else {
		est local vcetype Panel-corrected
		est scalar n_cv = `M' * (`M'+1) / 2
	}
	est local vce ""		// unset; was set by -regress-
	est local ivar `panvar'
	est local tvar `tvreal'
	est local depvar `depvar1'
	setTitle
	est local predict xtpcse_p
	est local marginsok XB default
	est local marginsnotok stdp
	est local estat_cmd ""
	est scalar rc = 0
	est local cmd xtpcse

	Display, level(`level') `diopts'

}	/* end capture noisily */

	nobreak
	local rc = _rc

	if !`restore' {
		qui tsset `panvar' `timevar', delta(`=`tdelta'') ///
			format(`tfmt') noquery
		capture mac drop T_rho T_fcrho
	}

	break
	exit `rc'

end



program define Display
	version 7, missing
	
	syntax , level(cilevel) [*]
	
	_get_diopts diopts, `options'
	local cfmt `"`s(cformat)'"'
	if "`e(corr)'" == "ar1" {
		local corr "common AR(1)"
	}
	else if "`e(corr)'" == "psar1" {
		local corr "panel-specific AR(1)"
	}
	else	local corr "no autocorrelation"


	if "`e(wtype)'" == "iweight" {
		local obs "Sum of weights"
	}
	else	local obs "Number of obs"
	di in gr _n `"`e(title)'"' _n
	di in gr "Group variable:" _col(19) in ye "`e(ivar)'"		/*
		*/ _col(49) in gr "`obs'" _col(67) "= "			/*
		*/ in ye %10.0gc e(N)
	di in gr "Time variable:" _col(19) in ye "`e(tvar)'"		/*
		*/ _col(49) in gr "Number of groups" _col(67) "= " 	/*
		*/ in ye %10.0fc e(N_g)
	di in gr "Panels:" _col(19) in ye "`e(panels)' (`e(balance)')"	/*
		*/ _col(49) in gr "Obs per group:"
	di in gr "Autocorrelation:" _col(19) in ye "`corr'"		/*
		*/ _col(63) in gr "min" _col(67) "= " in ye %10.0gc e(g_min)
	if "`e(balance)'" == "unbalanced" & "`e(panels)'" == "correlated" {
		di in gr "Sigma computed by " _col(19) 		/*
			*/ in ye "`e(missmeth)' selection"	/*
			*/ in gr _col(63) in gr "avg" _col(67)  /*
			*/ "= " in ye %10.0gc e(g_avg)
	}
	else {
		di in gr _col(63) in gr "avg" _col(67) "= " in ye %10.0gc e(g_avg)
	}
	di in gr _col(63) in gr "max" _col(67) "= " in ye %10.0gc e(g_max)
	di in gr "Estimated covariances" _col(28) "= " in ye %9.0g e(n_cv)  /*
		*/ _col(49) in gr "R-squared" _col(67) "= " in ye %10.4f e(r2)
	di in gr "Estimated autocorrelations" _col(28) "= " 		/*
		*/ in ye %9.0g e(n_cr)  _col(49) in gr "Wald chi2(" 	/*
		*/ in ye e(df) in gr ")"_col(67) "= " in ye %10.2f e(chi2)
	di in gr "Estimated coefficients" _col(28) "= " 		/*
		*/ in ye %9.0g e(n_cf)  _col(49) in gr "Prob > chi2"  	/*
		*/ _col(67) "= " in ye %10.4f e(p) _n

	local case = e(n_cr)
	local case = cond(e(n_cr)>0, cond(e(n_cr)==1,1,2), 0) 
	local plus = cond(`case'==1, "plus", "")

	_coef_table, `plus' level(`level') `diopts'
	local c1 = `"`s(width_col1)'"'
	local w = `"`s(width)'"'
	capture {
		confirm integer number `c1'
		confirm integer number `w'
	}
	if c(rc) {
		local c1 13
		local w 78
	}
	local c = `c1' - 1
	local rest = `w' - `c1' - 1
	if e(n_cr) > 0  {

	    tempname rhos
	    capture matrix `rhos' = e(rhomat)
	    if _rc {
		local cw = `c' + 3
		di in gr %`cw's "rhos = " in ye "(not saved)" _c
	    }
	    else {

		if `"`cfmt'"' != "" {
			local rho	: display `cfmt' `rhos'[1,1]
		}
		else {
			local rho	: display %9.0g `rhos'[1,1]
		}
		if e(n_cr) == 1 {
			di in smcl in gr /*
			*/ %`c's "rho" " {c |}  " in ye %9s "`rho'" _c
		}
		else	{
			local cw = `c' + 3
			di in gr %`cw's "rhos = " in ye %9s "`rho'" _c
		}

		local k = colsof(`rhos')
		local done 0
		local i 2
		while `i' <= `k' & !`done'{
			if `k' > 6 & `i' == 6 { 
				di in gr " ..." _c 
				local done 1
			}
			if `"`cfmt'"' != "" {
				local rho	: display `cfmt' `rhos'[1,`i']
			}
			else {
				local rho	: display %9.0g `rhos'[1,`i']
			}
			di in gr " " in ye %9s "`rho'" _c
			local i = `i' + 1
		}
	    }

	    di ""
	    if "`plus'" != "" {
		    di in smcl in gr "{hline `c1'}{c BT}{hline `rest'}"
	    }
	    else    di in smcl in gr "{hline `w'}"
	}
end


program define getCorr
	args corrtyp colon corrstr

	local 0 ", `corrstr'"
	syntax [, Ar1 Psar1 Independent ]

	local ct : word count `ar1' `psar1' `independent'

	if `ct' > 1 {
		di in red "may only specify one from ar1, psar1, and "  /*
			*/ "independent in option corr()"
		exit 198
	}
	else if `ct' == 0 {
		local independent "independent"
	}

	c_local `corrtyp' `ar1'`psar1'`independent'
end


program define Getar1, eclass
	args rhovar colon e rhotype ivar panvar M k np1

	tempname rhomat rho_i rho obs

	if "`np1'" != "" { 
		local adj 1
	}
	else	local adj 0

	scalar `rho' = 0
	scalar `obs' = 0
	local i 1
	while `i' <= `M' {
		_crcar1 `rho_i' rhotypf : `e' if `ivar'==`i' , `rhotype' k(`k')
		if `rho_i' <. {
			if "$T_fcrho" == "" {
				if `rho_i' > 1 {
					scalar `rho_i' = 1
					local rhobnd true
				}
				if `rho_i' < -1 {
					scalar `rho_i' = -1
					local rhobnd true
				}
			}
			scalar `rho' = `rho' + (r(N)+`adj')*`rho_i'
			scalar `obs' = `obs' + r(N) + `adj'
		}
		local i = `i' + 1
	}
	if `obs' == 0 { error 2001 }
	if "`rhobnd'" != "" {
		di in blue "(note: estimates of rho outside [-1,1] "	/*
			*/ "bounded to be in the range [-1,1])"
	}

	scalar `rho' = `rho' / `obs'
	qui gen double `rhovar' = `rho' 

	mat $T_rhomat  = `rho'

	global T_rho = `rho'
end


program define Getpsar1, eclass
	args rhovar colon e rhotype ivar panvar M k np1 /* np1, sic, unused */

	if `M' <= c(max_matdim) {
		local savrho 1
	}
	else	di in blue "could not save matrix e(rhomat), too many elements"

	tempname rhomat rho 
	qui gen double `rhovar' = .

	local i 1
	while `i' <= `M' {
		_crcar1 `rho' rhotypf : `e' if `ivar'==`i' , `rhotype' k(`k')
		if `rho' >=. {
			scalar `rho' = 0
			sum `panvar' if `ivar'==`i', meanonly
			di in blue /*
*/ "(note: rho_i could not be computed for panel `panvar' " r(mean) ";" _n /*
*/ "       assumed to be 0.)"
		}
		else {
			if "$T_fcrho" == "" {
				if `rho' > 1 {
					scalar `rho' = 1
					local rhobnd true
				}
				if `rho' < -1 {
					scalar `rho' = -1
					local rhobnd true
				}
			}
		}
		qui replace `rhovar' = `rho' if `ivar' == `i'
		local tr = `rho'
		local rhos `rhos' `tr'
		if 0`savrho' { mat $T_rhomat = nullmat($T_rhomat) , `rho' }
		local i = `i' + 1
	}

	if "`rhobnd'" != "" {
		di in blue "(note: estimates of rho outside [-1,1] "	/*
			*/ "bounded to be in the range [-1,1])"
	}

	global T_rho `rhos'
end

program define doPrais

	syntax varlist , Residuals(varlist min=1 max=1) Corrtype(string)  /*
		*/ Rhotype(string) M(integer) K(integer) 		  /*
		*/ Ivar(varlist min=1 max=1) Panvar(varlist min=1 max=1) [ NP1 ]

	tempname rhovar
	Get`corrtype' `rhovar' : `residuals' `rhotype' `ivar' `panvar' 	/*
		*/ `m' `k' `np1'

	sum `rhovar', meanonly
	if r(max) > 1 {
		di in blue "Prais-Winsten transformation not possible "	/*
			*/ "where estimate of rho exceeds 1,"
		di in blue "some observations may be dropped"
	}

	recast double `varlist'
	tempvar tvar
	qui gen double `tvar' = .

	tokenize `varlist'
	local i 1
	while "``i''" != "" {
		qui replace `tvar' = ``i'' - `rhovar'*l.``i'' if l.``i'' <.
		qui replace `tvar' = ``i'' * sqrt(1 - `rhovar'^2)	/*
			*/ if l.``i'' >=.
		qui replace ``i'' = `tvar'
		local i = `i' + 1
	}

end


program define getSigma		/* assumes sort `touse' `ivar' ... */
	args sigma n_sigma colon e M ivar timevar touse casewis wtvar

	qui tsset `timevar' `ivar', noquery     /* yes!  backwards */

	if `casewis' {			/* bit more work, but avoids sort */
		tempname ct touse2
		qui by `timevar' : gen long `ct' = sum(`touse')
		qui by `timevar' : gen byte `touse2' = `ct'[_N] == `M'
		local touse `touse2'

		sum `touse', meanonly
		if r(sum) == 0 {
			di in red "no time periods are common to all "	/*
			*/ "panels, cannot estimate disturbance"
			di in red "covariance matrix using casewise inclusion"
			exit 459
		}
		c_local `n_sigma' = r(sum) / `M'
	}


	tempname eiej cov_ij sum_ij
	mat `sigma' = I(`M')*0

	local warned 0
	local delta 0
	while `delta' < `M' {
		qui gen double `eiej' = `wtvar' * `e'*L`delta'.`e'  /*
			*/ if L`delta'.`touse'
					/* iw not allowed on -sum- */
		local i 1
		while `i' <= `M'-`delta' {
			local j = `i' + `delta'
			sum `eiej' if `touse' & `ivar'==`j', meanonly
			scalar `sum_ij' = r(sum)	
			sum `wtvar' if `touse' & `ivar'==`j' & `eiej' <., /*
				*/ meanonly 
			if r(sum) == 0 {
				scalar `cov_ij' = 0
				if !`warned' {
					#delimit ;
					di in blu 
"(note: at least one disturbance covariance assumed 0, no common time periods"
_n
"       between panels)" ;
					#delimit cr
					local warned 1
				}
			}
			else	scalar `cov_ij' = `sum_ij' / r(sum)
			mat `sigma'[`i',`j'] = `cov_ij'
			if `i' != `j' {
				mat `sigma'[`j',`i'] = `cov_ij'
			}
			local i = `i' + 1
		}
		drop `eiej'
		local delta = `delta' + 1
	}

	/* for speed above could be internal. */
end


program define getSigH		/* assumes sort `touse' `ivar' ... */
	args sigvar sigma colon e M ivar touse wtvar

	if "`wtvar'" == "" { local wtvar 1 }

	sort `touse' `ivar'
	qui by `touse' `ivar':						/*
	   */ gen double `sigvar' = sum(`wtvar'*(`e'^2)) / sum(`wtvar')	/*
	   */ if `touse'
	qui by `touse' `ivar': replace `sigvar' = `sigvar'[_N]

	if `M' <= c(max_matdim) {
		tempvar first
		qui by `touse' `ivar': gen byte `first' = _n == 1
		mkmat `sigvar' if `touse' & `first', mat(`sigma')   /* ineff */
		mat `sigma' = diag(`sigma')
	}
	else	di in blue "could not save matrix e(Sigma), too many elements"
	
end


program define getSigI		/* assumes sort `touse' ... */
	args sigscal sigma colon e M touse wtvar

	if "`wtvar'" == "" { local wtvar 1 }

	tempvar sigvar
	qui gen double `sigvar' = sum(`wtvar'*(`e'^2)) / sum(`wtvar')	/*
		*/ if `touse'
	qui replace `sigvar' = `sigvar'[_n-1] if `sigvar' >=.
	scalar `sigscal' = `sigvar'[_N]

	if `M' <= c(max_matdim) {
		mat `sigma' = I(`M') * `sigscal'
	}
	else	di in blue "could not save matrix e(Sigma), too many elements"
	
end




program define isBalCt, rclass
	args touse

	_ts timevar panvar, panel
	tempname touse2
	gen byte `touse2' = `touse'
	qui replace `touse2' = 2 if `touse2' == 0
	qui replace `touse2' = 3 if `touse2' >=.
	local touse `touse2'
	sort `touse' `panvar' `timevar'

	qui count if `panvar' == `panvar'[1] & `touse'==1
	capture assert `timevar' == `timevar'[_n-r(N)] 			/*
		*/ if _n > r(N) & `touse'==1
	if _rc {
		return local balance "unbalanced"
	}
	else	return local balance "balanced"

	tempvar ct
	qui by `touse' `panvar' : gen `c(obs_t)' `ct' = _N if _n == 1
	sum `ct'  if `touse'==1, meanonly
	return scalar min = r(min)
	return scalar max = r(max)
	return scalar mean = r(mean)

	sort `panvar' `timevar'

end
program define isBal			/* clean version for balance only */
	args balmac colon touse

	_ts timevar panvar, panel
	qui replace `touse' = 2 if `touse' == 0
	qui replace `touse' = 3 if `touse' >=.
	sort `touse' `panvar' `timevar'

	qui count if `panvar' == `panvar'[1] & `touse'==1
	capture assert `timevar' == `timevar'[_n-r(N)] 			/*
		*/ if _n > r(N) & `touse' == 1
	c_local `balmac' = !_rc

	qui replace `touse' = 0 if `touse' == 2
	qui replace `touse' = . if `touse' == 3
	sort `panvar' `timevar'

end

program define setTitle, eclass

	if "`e(vcetype)'" == "Het-corrected" {
		local cov "heteroskedastic"
	}
	else if "`e(vcetype)'" == "Panel-corrected" {
		local cov "correlated"
		local tail " (PCSEs)"
	}
	else	local cov "independent"

	if "`e(corr)'" == "independent" {
		local prefix "Linear regression,"
	}
	else	local prefix "Prais-Winsten regression,"

	est local panels "`cov'"
	est local title "`prefix' `cov' panels corrected standard errors`tail'"
end


exit

 i    t    e   
---  ---  ---
  1   1    .1
  2   1    .2
  3   1   -.2
  1   2    -4
  2   2    .1
  3   2   -.2
  1   3    .1
  2   3    .2
  3   3   -.2

