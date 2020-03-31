*! version 4.0.3   16sep2004
program define brier, rclass byable(recall) sort
        version 6, missing
	syntax varlist(min=2 max=2) [if] [in] [, Group(integer 10)]
        tokenize `varlist'
	if `group' < 2 { error 148 }

        tempvar FMD GID DJ touse NGROUP FJ DJ LOG VB EB

        quietly {
                mark `touse' `if' `in'
		markout `touse' `1' `2'
		count if `touse'
		if r(N)<2 { error 2001 }
		              capture assert `1'==0 | `1'==1 if `touse'
                if _rc {
                        di in red "first variable must be 0/1"
                        exit 198
                }
                capture assert `2'>=0 & `2'<=1 if `touse'
                if _rc {
                        di in red "second variable must be probability"
                        exit 198
                }
                sort `touse' `2'
                by `touse': gen double `FMD' = sum(`touse')
                local totsamp = `FMD'[_N]
                by `touse': replace `FMD' = (`FMD'-1)/`FMD'[_N]        /* relative percentile */
/* old -- allows ties at boundaries and thus stats depend on data order */
*               gen long `GID' = int(`group' *  `FMD') + 1  /* group ID */
/* end old */
/* new -- no ties at boundaries */
		xtile `GID' = `2' if `touse', n(`group')
/* end new */
                sort `touse' `GID'
                
                summ `1' if `touse'
                local dbar = r(mean)
                summ `2' if `touse'
                local fbar = r(mean)
		local fvar = r(Var) * (r(N)-1)/r(N)

                summ `2' if `touse' & `1'==1
                local f1 = r(mean)
                replace `FMD' = `f1' if `1'==1 & `touse'
                summ `2' if `touse' & `1'==0
                local f0 = r(mean)
                replace `FMD' = `f0' if `1'==0 & `touse'
                summ `FMD' if `touse'
                local sfmin = r(Var) * (r(N)-1)/r(N)

                by `touse' `GID': gen long `NGROUP' = sum(`touse')
                by `touse' `GID': replace `NGROUP' = `NGROUP'[_N]
                by `touse' `GID': gen float `FJ' = sum(`2')/`NGROUP'
                by `touse' `GID': replace `FJ' = `FJ'[_N]
                by `touse' `GID': gen float `DJ' = sum(`1')/`NGROUP'
                by `touse' `GID': replace `DJ' = `DJ'[_N]
                by `touse' `GID': gen byte `LOG' = _n == _N

                replace `FMD' = (`2'-`1')^2 if `touse'     /* (f(i)-d(i))^2 */
                summ `FMD' if `touse', meanonly
                local brier = r(mean)
                gen `EB'=`2'*(1-`2') if `touse'
                summ `EB' if `touse', meanonly
                local ebrier = r(mean)
                gen `VB' = `2'*(1-`2')*((1-(2*`2'))^2) if `touse'
                summ `VB' if `touse', meanonly
		local vbrier = r(sum)/(r(N)^2)
                local spieg = (`brier'-`ebrier')/(`vbrier'^.5)

		/* in-line code below replaces ranksum2 code */
		tempname nn mm min max x
		ranksum `2' if `touse', by(`1')
		local ZROC = r(z)
                local V1 = r(group1)
		local W = r(sum_obs)
		summ `1' if `touse'
		scalar `min' = r(min)
		scalar `max' = r(max)
		if `V1' == `min' {
			scalar `x' = `min'
			scalar `min' = `max'
			scalar `max' = `x'
		}
		summ `2' if `touse' & `1' == `max'
		scalar `nn' = r(N)
		summ `2' if `touse' & `1' == `min'
		scalar `mm' = r(N)
		local ROC = (`nn'*`mm' + `nn'*(`nn'+1)/2 - `W')/(`nn'*`mm')
		/* end of in-line code ********************************/

                qui su `1' if `touse'
                local meano= r(mean)
                qui su `2' if `touse'
                local meanf= r(mean)
                qui corr `1' `2' if `touse'
                local corra= r(rho)

                replace `FMD' = (`FJ'-`1')^2 if `touse'
                summ `FMD' if `touse'
                local brier1 = r(mean)

                replace `FMD' = `NGROUP'*`DJ'*(1-`DJ')
                summ `FMD' if `LOG' & `touse'
                local sanders = r(N)*r(mean)/`totsamp'

                replace `FMD' = `NGROUP'*(`FJ'-`DJ')^2
                summ `FMD' if `LOG' & `touse'
                local relinsm = r(N)*r(mean)/`totsamp'

                local oiv = `dbar'*(1-`dbar')

                replace `FMD' = `NGROUP'*(`DJ'-`dbar')^2 if `touse'
                summ `FMD' if `LOG' & `touse'
                local murphy = r(N)*r(mean)/`totsamp'
                local relinla = (`fbar'-`dbar')^2
                local sfd1 = (`f1'-`f0')*`oiv'

                replace `FMD' = (`2'-`FJ')^2 if `touse'
                summ `FMD' if `touse'
                local gerr = r(mean)

        }

	/* return computed quantities */
        /* double save in S_# and r()  */
        ret scalar cov_2f = 2*`sfd1'
        ret scalar relinla = `relinla'
        ret scalar Var_fmin = `sfmin'
        ret scalar Var_fex = `fvar'-`sfmin'
        ret scalar Var_f = `fvar'
        ret scalar relinsm = `relinsm'
        ret scalar murphy = `murphy'
        ret scalar oiv = `oiv'
        ret scalar sanders = `sanders'
        ret scalar brier_s = `brier1'
        ret scalar brier = `brier'
/* new for Stata 6 */
	ret scalar z = `spieg'
	ret scalar p = normprob(-return(z))
	ret scalar roc_area = `ROC'
	ret scalar p_roc = normprob(`ZROC')
/* end new for Stata 6 */
        global S_1 `return(brier)'
        global S_2 `return(brier_s)'
        global S_3 `return(sanders)'
        global S_4 `return(oiv)'
        global S_5 `return(murphy)'
        global S_6 `return(relinsm)'
        global S_7 `return(Var_f)'
        global S_8 `return(Var_fex)'
        global S_9 `return(Var_fmin)'
        global S_10 `return(relinla)'
        global S_11 `return(cov_2f)'
        * global S_12 `gerr'


di
di in gr "Mean probability of outcome" _col(30) in ye %7.4f `meano'
di in gr "                 of forecast" _col(30) in ye %7.4f `meanf'
di
di in gr "Correlation" _col(30) in ye %7.4f `corra'
di in gr "ROC area" _col(30) in ye %7.4f `ROC' in gr "  p =" /*
	*/ in ye %7.4f normprob(`ZROC')
di

        di in gr "Brier score" _col(30) in ye %7.4f `brier'
        di in gr "Spiegelhalter's z-statistic" _col(30) in ye %7.4f `spieg' /*
 */in gr "  p =" in ye %7.4f 1-normprob(`spieg')
        di in gr "Sanders-modified Brier score" _col(30) in ye %7.4f `brier1'
        di in gr "Sanders resolution" _col(30) in ye %7.4f `sanders'
        di in gr "Outcome index variance" _col(30) in ye %7.4f `oiv'
        di in gr "Murphy resolution" _col(30) in ye %7.4f `murphy'
        di in gr "Reliability-in-the-small" _col(30) in ye %7.4f `relinsm'
        di in gr "Forecast variance" _col(30) in ye %7.4f `fvar'
        di in gr "Excess forecast variance" _col(30) in ye %7.4f `fvar'-`sfmin'
        di in gr "Minimum forecast variance" _col(30) in ye %7.4f `sfmin'
        di in gr "Reliability-in-the-large" _col(30) in ye %7.4f `relinla'
        di in gr "2*Forecast-Outcome-Covar" _col(30) in ye %7.4f 2*`sfd1'
*       di in gr "Grouping forecast error" _col(30) in ye %7.4f `gerr'
/*

        di `brier'-(`oiv'+`fvar'+`relinla'-2*`sfd1')
        di `brier1'-`sanders'-`relinsm'
        di `sanders'-`oiv'+`murphy'
        di `relinsm'-`fvar'-`relinla'+2*`sfd1'-`murphy' - `gerr'

        assert abs(`brier1'-`sanders'-`relinsm')<.0001
        assert abs(`sanders'-`oiv'+`murphy')<.0001
        assert abs(`relinsm'-`fvar'-`relinla'+2*`sfd1'-`murphy')<.0001

The last assertion does not hold because there is a difference between
brier and brier1 conceptions.  Yates statements hold for the original
Brier score, but the Sanders and Murphy decompositions hold for the
brier1 score.  The difference between brier and brier1 is the
grouping error.  It is probably somewhat more complicated than I
computed here.

*/
end
