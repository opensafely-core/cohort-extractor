*! version 1.7.0  21jun2018
program define xtregar, eclass sortpreserve byable(recall) prop(xt xtbs)
	local vv : display "version " string(_caller()) ":"
	version 7, missing

	if replay() {
                if `"`e(cmd)'"'!="xtregar" { error 301 }
		if _by() { error 190 } 

		syntax [, Level(cilevel) LBI LBIC *]

		_get_diopts diopts, `options'
		if "`lbi'" != "" & "`e(wtype)'"!= "" {
			di as error "lbi cannot be specified with weights"
			exit 198
		}
               	if "`e(model)'"=="fe" {
			if "`lbi'" != "" {
				est local dw "lbi"
				est local LBI ""
			}	
			`vv' DispFE, level(`level') `diopts'
		}
		else {
			if "`lbi'" != "" {
				est local dw "lbi"
				est local LBI ""
			}	
			`vv' ///
			DispRE, level(`level') `diopts'
		}	
                exit
        }


	local cmdline : copy local 0
	syntax varlist(fv ts) [if] [in] [fw aw],[ RE FE RHOType(string) /* 
		*/ TWOstep RHOF(real -2 ) SIGEF(real 0) SIGUF(real 0) /*
		*/ LBI Level(cilevel) *]
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	if `fvops' {
		local vv : di "version " string(max(11,_caller())) ", missing:"
	}
	_get_diopts diopts, `options'
	marksample touse 
	
	qui sum `touse'
	if `r(sum)'==0 {
		error 2000
	}	

	if "`weight'" != "" {
		local weights "weights"
		if "`lbi'" != "" {
			di as error "lbi cannot be specified with weights"
			exit 198
		}
	}
	else {
		local weights ""
	}
		
	_xt, trequired
	local id "`r(ivar)'"
	local t  "`r(tvar)'"
	tempname tdelta
	scalar `tdelta' = r(tdelta)
	
	if "`re'" !="" & "`fe'" != "" {
		di as error "specify re or fe, not both"
		exit 198
	}	
	
	/* only allow weights with fe model */
	if "`weight'" != "" & "`fe'" == "" {
		di as error "weights allowed only with fe estimator"
		exit 198
	}

	markout `touse' `id' `t'

	if `fvops' {
		fvrevar `varlist', list
	}
	else {
		tsrevar `varlist', list
	}
	local tvlist "`r(varlist)'"
	foreach var of local tvlist {
		if "`var'" == "`t'" {
			di as err "time variable may not be included in varlist"
			exit 198 
		}
	}	

	gettoken depvar xvars : varlist
	_fv_check_depvar `depvar'

	local depname "`depvar'"
	local depname_o "`depvar'"

	tsrevar `depvar', substitute
	local depvar `r(varlist)'
	
	if `fvops' {
		local rmcoll "version 11: _rmcoll"
		local fvexp expand
		local rmif "if `touse'"
	}
	else	local rmcoll _rmcoll
	`rmcoll' `xvars' `rmif', `fvexp'
	
	local indepsn "`r(varlist)'"
	if `fvops' {
		local rmcoll "quietly version 11: _rmcoll"
		fvexpand `indepsn'
		local indepsn_o `"`r(varlist)'"'
		fvrevar `indepsn', list
		local olist `"`r(varlist)'"'
		fvrevar `indepsn', substitute
	}
	else {
		local indepsn_o `indepsn'
		tsrevar `indepsn', substitute
	}
	local varlist "`depvar' `r(varlist)'"

	tokenize `varlist'
	macro shift
	local indeps "`*'"

	tempname rho_f
	rtparse ,`rhotype' rhof(`rhof')

	local rhot "`r(type)'"
	scalar `rho_f'=r(rho_f)

	if "`rhot'" == "onestep" & "`twostep'" != "" { 
		di as err "cannot specify both onestep and twostep"
		error 198 
	}

	if "`weight'" != "" {
		if "`rhotype'" != "regress" & "`rhotype'" != "freg" /*
			*/ & reldif(`rho_f',-2) < 1e-8  {
				di as error ///
"weights can only be used with regress or freg rhotypes, or with a fixed rho"
				exit 198
		}
	}
	

	tempname cons
	gen double `cons'=1
	local varlist "`varlist' `cons'"

	sort `id' `t'

	/* check that weights are constant in panel */
	if "`weight'"!= "" {
		tempvar myweight
		qui gen double `myweight'`exp'
		qui xtsum `myweight'
		if abs(r(sd_w)) > 1e-8 {
			di as error "weights must be constant within panel"
			exit 198
		}
	}
		
	tempname origsmp
	gen byte `origsmp'=`touse'


/* estimate rho */
	tempname rho

	if `rhof'==-2 {
		if  "`rhot'" =="onestep" {
		 	/* estimate rho by onestep from within model */
			qui preserve 
			capture drop `cons'
			qui keep if `touse'
			qui sort `id' `t'
			local vlist2 : subinstr local varlist "`cons'" " "

			qui demean `vlist2', i(`id')

			tokenize `vlist2'
			macro shift 
			`rmcoll' `*', `fvexp'
			if `fvops' {
				RmCollMsg `r(varlist)'
			}
		 	if "`fe'" != "" {
		 		local indepsn `r(varlist)'
			}	
				
			local vlistfe "`depvar' `r(varlist)'"


			`vv' ///
			qui _regress `vlist2', nocons
			
			tempname top1 top2
			tempvar res_w Lres_w ettm1 et2 mc
			qui {
				predict double `res_w', residuals
				by `id': gen double `Lres_w' = L.`res_w'
			
				gen double `ettm1'=`Lres_w'*`res_w'
			
				gen double `et2'=`res_w'*`res_w'
			
				gen long `mc'=(`ettm1' <.)
		
				summ `ettm1', meanonly
				scalar `top1'=r(sum)
			
				summ `mc', meanonly
				scalar `top2'=r(sum)
			
				summ `et2', meanonly
				scalar `rho'=(`top1'/`top2')/(r(sum)/r(N))
				restore 
			}	
		}
		else {
			qui {
				preserve 
				capture drop `cons'
				local vlist2 : subinstr local /* 
					*/ varlist "`cons'" " "
				keep if `touse'
				demean `vlist2', i(`id')
				
				tokenize `vlist2'

				macro shift 
				if "`fe'" != "" {
					local noi noi
				}	
		 		`noi' `rmcoll' `*', `fvexp'
				if `fvops' {
					`noi' RmCollMsg `r(varlist)'
				}
		 		if "`fe'" != "" {
		 			local indepsn `r(varlist)'
				}	
				local vlistfe "`depvar' `r(varlist)'"
			
				prais `vlist2' [`weight'`exp'] if `touse',  /*
					*/ nocons rhotype(`rhot') `twostep' /*
					*/ `weights' 
				scalar `rho'=e(rho)
				restore
			}	
		}	
	}
	else {
		scalar `rho'=`rhof'
		if abs(`rho')>=1 {
			di as err "|rho|<1, specify a valid rho"
			exit 198
		}	
		qui preserve 
		qui capture drop `cons'
		local vlist2 : subinstr local /* 
			*/ varlist "`cons'" " "
		qui keep if `touse'

		demean `vlist2', i(`id')

		tokenize `vlist2'
		macro shift 
		`rmcoll' `*', `fvexp'
		if `fvops' {
			RmCollMsg `r(varlist)'
		}
		if "`fe'" != "" {
		 	local indepsn `r(varlist)'
		}	
		local vlistfe "`depvar' `r(varlist)'"

		restore
	}	


/* Transform data to remove AR component preserve data and keep if `touse' */

	tempvar touse3
	gen byte `touse3'=`touse'
	preserve 
	qui keep  if `touse'

	qui sort `id' `t'

	tempvar difft
	qui by `id': gen double `difft'=(`t'[_n]-`t'[_n-1]) / `tdelta' if _n>1

	foreach x of local varlist {
	
		/* These next two lines implement C_i(rho) transform from 
			page 816 of Baltagi and Wu 199 */
		/*  note calculation depends on user defined time */

		tempvar tvar	
		qui by `id': gen `tvar'=(sqrt(1-`rho'^2))*`x' if _n==1
		qui by `id': replace `tvar'=(sqrt(1-`rho'^2))*		///
			(`x'[_n]*(1/sqrt((1-`rho'^(2*`difft')))) - 	///
			`x'[_n-1]*(`rho'^(`difft')/ 			///
				sqrt(1-`rho'^(2*`difft')))) if _n>1
		qui replace `x'=`tvar'
	}

	if "`fe'" != "" {
		qui {
			by `id': drop if _n==1
			keep if `touse'
			sort `id' `t'
			
			`vv' ///
			_regress `vlistfe' `cons' [`weight'`exp'], nocons
			tempname rrss
			scalar `rrss'=e(rss)
			
			capture drop `cons'

		 	/* xtdata `vlistfe', i(`id') fe clear */
			fevars `vlistfe' [`weight'`exp'], i(`id') 

			`vv' ///
			_regress `vlistfe' [`weight'`exp']

			tempname df_b df_r r2 rmse_r rmse mss rss
			tempname ll ll_0 F
			scalar `F' =e(F)
			scalar `df_b'=e(df_m)
			scalar `rss'=e(rss)
			scalar `mss'=e(mss)
			scalar `ll'=e(ll)
			scalar `ll_0'=e(ll_0)
			scalar `r2'=e(r2)
			scalar `rmse_r'=e(rmse)
			
			tempname b V V1
			mat `b'=e(b)
			mat `V'=e(V)
				
			tempname NT N K scale sigma_e sigma2_u
			scalar `NT'=e(N)
			scalar `K'=e(df_m)+1 /* assumes cons in mod */
			tempvar Ti 
			tempname g_max g_min g_avg Tbar df_m r2_a F_f df_a
			by `id': gen `c(obs_t)' `Ti'=_N if _n==_N
			summ `Ti' [`weight'`exp']
			scalar `N'=r(N)
				
			scalar `df_m'=`K'-1+`N'-1
			scalar `df_b'=`K'-1
			scalar `df_r'=`NT'-`df_m'-1
			scalar `df_a'=`N'-1
			scalar `F'=`F'*`df_r'/(`NT'-`K')
			scalar `F_f'=`df_r'/(`N'-1) *(`rrss'-`rss')/(`rss')
			scalar `sigma_e'=sqrt( (`rmse_r'^2) /*
				*/ *((`NT'-`df_b'-1) /*
				*/ /(`NT'-`df_m'-1) ) )
			scalar `g_max'=r(max)
			scalar `g_min'=r(min)
			scalar `g_avg'=r(mean)
			scalar `r2_a'=1-((`NT'-1)/`df_r')*(1-`r2')

			if "`weight'" == "" {
				means `Ti'
				scalar `Tbar'=r(mean_h)
			}	
			scalar `scale'=(`NT'-`K')/(`NT'-`N'-`K'+1)
			mat `V1'=`scale'*`V' 

			restore	
			tempname bc Vc 
			mat `bc'=`b'
			mat `Vc'=`V1'

			tempvar ftouse
			by `id': gen long `ftouse'  = sum(`touse')
			replace `touse'=0 if `ftouse'==1 
/*			
			mat colnames `b' = `indepsn_o' _cons
			mat colnames `V1' = `indepsn_o' _cons
			mat rownames `V1' = `indepsn_o' _cons
*/
			est post `b' `V1' [`weight'`exp'], ///
				depname(`depname_o') esample(`touse')
			_post_vce_rank


	/* now calculate corr(u_i, xb), r2_b and  r2_o.  
	Note _predict assumes that e(b) exists.  
	Thus, this section must come after est post */
				
			tempvar touse2
			qui by `id': gen byte `touse2'=e(sample) & (_n!=1)

			sort `id' `touse2'
			tempvar ui xb xib ym xitb 
	
			_predict double `xb' if `touse2', xb 

			by `id' `touse2': gen double `ui' = /*
				*/ cond(`touse2' & _n==_N, /*
				*/ sum(`depvar')/_n-sum(`xb')/_n,.) /*
				*/ if `touse2'
			by `id': replace `ui'=`ui'[_N] if `touse2'

			sort `id' `touse2'
			corr `ui' `xb' [`weight'`exp'] if `touse2'
			est scalar corr=r(rho)
			

			by `id' `touse2': gen double `xib' = /*
				*/ cond(`touse2' & _n==_N, /*
				*/ sum(`xb')/_n,.) if `touse2'
			by `id': replace `xib'=`xib'[_N] if `touse2'

			by `id' `touse2': gen double `ym' = /*
				*/ cond(`touse2' & _n==_N, /*
				*/ sum(`depvar')/_n,.) if `touse2'
			by `id': replace `ym'=`ym'[_N] if `touse2'

			tempname r2_b r2_o
			corr `xib' `ym' [`weight'`exp'] if `touse2'
			scalar `r2_b'=(r(rho))^2
			est scalar r2_b=`r2_b'

			corr `xb' `depvar' [`weight'`exp'] if `touse2'
			scalar `r2_o'=(r(rho))^2
			est scalar r2_o=`r2_o'
				
			by `id' `touse2': replace `ui'=. if _n!=_N
			sum `ui' [`weight'`exp']	
			est scalar rho_ar=`rho'
			scalar `sigma2_u' = r(Var)

			
			tempname b2 V2
			mat `b2'=e(b)
			local tcols : colnames `b2'

			if `fvops' {
				local indepsn_o2 : copy local indepsn_o
			}
			else {
				local ncnt 1
				local ncnt2 1
				foreach vtn of local indeps {
					local vtn `vtn'
					local vto : word `ncnt' of `indepsn'
					local vto `vto'
					if "`vtn'" == "`vto'" {
					    local vtb : ///
						word `ncnt2' of `indepsn_o'
					    local indepsn_o2  ///
							`indepsn_o2' `vtb'
					    local ++ncnt	
					}
					local ++ncnt2	
				}
			}

			version 11: mat colnames `b2' = `indepsn_o2' _cons
								/* adj cons */ 
			tempname colsb
			scalar `colsb'=colsof(`b2')
			mat `b2'[1,`colsb']=`b2'[1,`colsb']/((1-`rho') )

			_ms_op_info `b2'
			if r(tsops) {
				quietly tsset, noquery
			}
			est repost b = `b2' [`weight'`exp'], ///
				rename esample(`touse3') buildfvinfo

			est scalar sigma_u = sqrt(`sigma2_u')
			est scalar rho_fov=`sigma2_u'/(`sigma_e'^2+`sigma2_u')
			est scalar sigma_e=`sigma_e'
			est scalar F = `F'
			est scalar F_f=`F_f'
			est scalar r2_w=`r2'
			est scalar r2_a=`r2_a'
			est scalar mss=`mss'
			est scalar ll=`ll'
			est scalar ll_0=`ll_0'
			est scalar rss= `rss' 
			est scalar df_m=`df_m'
			est scalar df_r=`df_r'
			est scalar df_b=`df_b'
			est scalar df_a=`df_a'
			est scalar N= `NT'
			est scalar N_g= `N'
			est scalar g_max= `g_max'
			est scalar g_min= `g_min'
			est scalar g_avg= `g_avg'
			est scalar rmse = `rmse_r'
			if "`weight'" == "" {
				est scalar Tbar =`Tbar'
			}	
			else {
				est local wtype "`weight'"
				est local wexp  "`exp'"
			}
			if `g_max'==`g_min' {
				est scalar Tcon=1
			}
			else {
				est scalar Tcon=0
			}	
			est scalar df_m =`df_m'
			
			est local rhotype "`rhot'"	
			est local depvar "`depname'"
			est local ivar "`id'"
			est local tvar "`t'"
			est local model "fe"
			est local predict "xtrar_p"
			est local marginsok "XB default"
			est local marginsnotok "ue u e"
			est local dw "`lbi'"
			version 10: ereturn local cmdline `"xtregar `cmdline'"'
			est local cmd "xtregar"
		}
		`vv' DispFE, level(`level') `diopts'
		exit
		
	}


/* FROM HERE ON APPLIES TO RE ONLY */
	/* now do OLS on transformed data 
		and get residuals  */

	qui {
		`vv' ///
		_regress `varlist' ,  nocons 
		tempvar mu 
		predict double `mu', residuals

	/* now make g_i */

		tempvar g_i
		by `id': gen double `g_i'=1 if _n==1
		by `id': replace `g_i'=( (1-`rho'^`difft')/ /*
			   */ (sqrt(1-`rho'^(2*`difft'))) ) if _n>1

		replace `g_i'=sqrt(1-`rho'^2)*`g_i'

		tempvar g_i2 g_i2s g_i2ss
		gen double `g_i2'=`g_i'*`g_i'
		by `id': gen double `g_i2s'=sum(`g_i2')
		by `id': replace `g_i2s'=. if _n<_N  /* g_i2s is g_i'g_i */
		sum `g_i2s', mean
		scalar `g_i2ss'=r(sum)  	/* g_i2ss = sum_i^N(g_i'g_i)*/

		by `id': replace `g_i2'=`g_i2s'[_N]   /* g_i2 has gi'gi in all 
								of i's obs */
		/* now make mu_i g_i */
		tempvar muigi muigi2 
		gen double `muigi'=`mu'*`g_i'
		by `id': gen double `muigi2'=sum(`muigi')
		by `id': replace `muigi2'=. if _n<_N
		replace `muigi2'=`muigi2'*`muigi2'  /* muigi2 is (mu_i'g_i)^2 */

		/* now get sigmaw2 */
		tempname sigmaw2

		replace `muigi2'= `muigi2'/`g_i2s' 
		sum `muigi2', meanonly
		scalar `sigmaw2'=r(sum)     /* sigmaw2=hat{sigma}_w^2 */

        	/* now make sigmae2 */
		tempname sigmae2 mui2s nim1s
		tempvar mu2 mui2 nim1
		gen double `mu2'=`mu'*`mu'
		by `id': gen double `mui2'=sum(`mu2')
		by `id': replace `mui2'=. if _n<_N
		sum `mui2', mean 
		scalar `mui2s'=r(sum) /* mui2s is sum_i^N (mu_i'mu_i) */

		by `id': gen `c(obs_t)' `nim1'=_n
		by `id': replace `nim1'=. if _n<_N
		replace `nim1'=`nim1'-1
		sum `nim1', mean
		scalar `nim1s'=r(sum)	/* nim1s is sum_i^N (n_i-1) */

		scalar `sigmae2'=(`mui2s'-`sigmaw2')/`nim1s' 

		/* now make sigmau2 */
		tempname N sigmau2
		tempvar idc
		by `id': gen byte `idc'=(_n==_N)
		sum `idc', mean
		scalar `N'=r(sum)

		scalar `sigmau2'=( `sigmaw2'-`N'*`sigmae2')/`g_i2ss'	

		/* now make omega_i^2 and thetai */
		tempvar omi2 thetai

		if `sigef' != 0 {
			scalar `sigmae2'=`sigef'
		}
		if `siguf' != 0 {
			scalar `sigmau2'=`siguf'
		}
	
		scalar `sigmau2' = max(0,`sigmau2') 

		gen double `omi2'=`g_i2'*`sigmau2'+`sigmae2' 
							/* omi2 is constant 
							over i */

		gen double `thetai' = 1-sqrt(`sigmae2'/`omi2') 
							/* thetai is constant
							over i */
		sum `thetai', detail
		tempname thta_mi thta_5 thta_50 thta_95 thta_ma
		scalar `thta_mi'=r(min)
		scalar `thta_5'=r(p5)
		scalar `thta_50'=r(p50)
		scalar `thta_95'=r(p95)
		scalar `thta_ma'=r(max)
		
		
		
		/* now transform data to y** and x** */
		tempvar yigi 

		foreach x of local varlist {
			capture drop `yigi'
			gen double `yigi'=`x'*`g_i'
			by `id': replace `yigi'=sum(`yigi')
			by `id': replace `yigi'=`yigi'[_N]
			replace `x'=`x'-`thetai'*`g_i'*(`yigi'/`g_i2')
		}	

		/* now get gls estimates */
		`vv' ///
		qui _regress `varlist',  nocons  
		local obs = e(N)

		if "`constan'" == "" {
			local mnames "`indeps' _cons"
		}
		else {
			local mnames "`indeps'"
		}

		tempname b V
		mat `b'=e(b)
		version 11: mat colnames `b' = `mnames'

		mat `V'=e(V)
		version 11: mat rownames `V' = `mnames'
		version 11: mat colnames `V' = `mnames'

		tempname df_m r2 
		scalar `df_m'=e(df_m)
		scalar `r2'=e(r2)
			
		tempvar Ti 
		tempname g_max g_min g_avg Tbar N_g
		by `id': gen `c(obs_t)' `Ti'=_N if _n==_N
		summ `Ti'
		scalar `N_g'=r(N)
				
		scalar `g_max'=r(max)
		scalar `g_min'=r(min)
		scalar `g_avg'=r(mean)

		means `Ti'
		scalar `Tbar'=r(mean_h)
		
		restore
		estimates post `b' `V', depname(`depname') obs(`obs') /*
			*/ esample(`touse')
		_post_vce_rank
			
		tempname chi2
		if "`indeps'" != "" {	
			test `indeps'
			local chi2t Wald
			scalar `chi2'=r(chi2)
		}
		else {
			scalar `chi2'=.
		}

		est local depvar `depname'	
		est local ivar `id'	
		est local chi2type `chi2t'
		est local model "re"
		est local predict "xtrar_p"
		est local marginsok "XB default"
		est local marginsnotok "ue u e"
		est local dw "`lbi'"
		est local tvar "`t'"
		est local rhotype "`rhot'"	

		tempvar xb xbmean depmean 
	
		gen byte `touse'=e(sample)
                                /* obtain R^2 overall   */
                _predict double `xb' if `touse', xb
                corr `xb' `depvar'
                est scalar r2_o = r(rho)^2

		sort `id' `touse'
                                /* obtain R^2 between */
                by `id' `touse': gen double `xbmean' = /*
                       */ cond(_n==_N & `touse', /*
                       */ sum(`xb'/_N), .)

                by `id' `touse': gen double `depmean' = /*
                      */ cond(_n==_N & `touse', /*
                      */ sum(`depvar'/_N), .)
                corr `xbmean' `depmean'
                est scalar r2_b = r(rho)^2

                      /* obtain R^2 within */
                by `id' `touse': replace `xbmean' = `xb'-`xbmean'[_N]
                by `id' `touse': replace `depmean'=`depvar'-`depmean'[_N]
                corr `xbmean' `depmean'
                est scalar r2_w = r(rho)^2
			
		tempname b2
		mat `b2'=e(b)
		version 11: mat colnames `b2' = `indepsn' _cons
		_ms_op_info `b2'
		if r(tsops) {
			quietly tsset, noquery
		}
		est repost b = `b2' , rename buildfvinfo
		
		est scalar sigma_u = sqrt(`sigmau2')
		est scalar sigma_e = sqrt(`sigmae2')
		est scalar rho_fov=`sigmau2'/(`sigmae2'+`sigmau2')
		est scalar df_m =`df_m'
		est scalar N_g=`N_g'
		est scalar g_max=`g_max'
		est scalar g_min=`g_min'
		est scalar g_avg=`g_avg'
		est scalar Tbar =`Tbar'
		if `g_max'==`g_min' {
			est scalar Tcon=1
		}
		else {
			est scalar Tcon=0
		}	
	
		est scalar chi2=`chi2'

		est scalar thta_min=`thta_mi'
		est scalar thta_5=`thta_5'
		est scalar thta_50=`thta_50'
		est scalar thta_95=`thta_95'
		est scalar thta_max=`thta_ma'

		est scalar rho_ar =`rho'
		version 10: ereturn local cmdline `"xtregar `cmdline'"'
		est local cmd "xtregar"
	}
	`vv' ///
	DispRE, level(`level') `diopts'
		
end	


program define demean
	syntax varlist(fv), i(varname)
	tempvar mean

	foreach x of local varlist {
		capture drop `mean'
		qui by `i': gen double `mean'=sum(`x')
		qui by `i': replace `mean'=`mean'[_N]/_N
		qui replace `x'=`x'-`mean'
	}

end	

program define fevars
	syntax varlist(fv) [aw fw], i(varname)
	tempvar imean mean N Ti temp notmiss

	foreach x of local varlist {

		fvrevar `x', list
		local x = r(varlist)
		recast double `x'

		capture drop `imean' `mean'  `Ti' `temp' `notmiss'

		qui sum `x' [`weight'`exp']
		qui gen double `mean'=r(mean)

		qui gen byte `notmiss'=(`x'<.)

/*
		gen `temp'=1 if `notmiss'
		gen `N'=sum(`temp')
		replace `N'=`N'[_N]
		
		gen double `mean'=sum(`x')
		replace `mean'=`mean'[_N]/`N'
		drop `temp'
	*/	
		gen `temp'=1 if `notmiss'
		qui by `i': gen `Ti'=sum(`temp')
		qui by `i': replace `Ti'=`Ti'[_N]
		
		qui by `i': gen double `imean'=sum(`x')
		qui by `i': replace `imean'=`imean'[_N]/`Ti'
		qui replace `x'=`x'+`mean'-`imean'
		qui replace `x'=. if `notmiss'!=1
	}

end	

program define rtparse, rclass
	syntax , [  RHOF(real -2)  ONEstep REGress FREG TSCorr DW THeil /* 
		*/ NAGar]

	tempname cnt
	scalar `cnt'=0
	
	if "`regress'" != "" { scalar `cnt' = `cnt'+ 1}
	if "`onestep'" != "" { scalar `cnt' = `cnt' +1}
	if "`freg'" != "" { scalar `cnt' = `cnt'+1}
	if "`tscorr'" != "" { scalar `cnt' = `cnt'+1}
	if "`dw'" != "" { scalar `cnt' = `cnt'+1}
	if "`theil'" != "" { scalar `cnt' = `cnt'+1}
	if "`nagar'" != "" { scalar `cnt' = `cnt'+1}

	local rtype "`regress'`onestep'`freg'`dw'`theil'`nagar'`tscorr'"
	if `cnt' > 1 {
		di as err "Only one rhotype may be specified."	
		error 198
	}

	if `cnt' >0  & `rhof' != -2 {
		di as err "rho cannot be fixed and estimated, specify " \*
			*/ "rhotype( ) or rhof(), not both "
		error 198
	}	
	
	if "`rtype'"=="" & `rhof'==-2 {
		local rtype "dw"
	}	

	return local type "`rtype'"
	return scalar rho_f=`rhof'
end	


program define DispFE
	local vv : display "version " string(_caller()) ":"
	version 7, missing
	syntax [, Level(cilevel) *]
	_get_diopts diopts, `options'
	local cfmt `"`s(cformat)'"'
	if `"`cfmt'"' != "" {
		local rho_ar	: display `cfmt' e(rho_ar)
		local sigma_u	: display `cfmt' e(sigma_u)
		local sigma_e	: display `cfmt' e(sigma_u)
		local rho_fov	: display `cfmt' e(rho_fov)
	}
	else {
		local rho_ar	: display %10.0g e(rho_ar)
		local sigma_u	: display %10.0g e(sigma_u)
		local sigma_e	: display %10.0g e(sigma_e)
		local rho_fov	: display %10.0g e(rho_fov)
	}

	if "`e(dw)'" != "" & "`e(LBI)'"=="" {
		`vv' lbi2  
	}	

	local dft = e(N) - 1
	local dfe = `dft' - e(df_m)

	local mse = e(rss)/`dfe'
	local p = fprob(e(df_b),`dfe',e(F))

	#delimit ;
        di _n as txt "FE (within) regression with AR(1) disturbances"
                _col(49) as txt "Number of obs" _col(67) "="
                _col(69) as res %10.0fc e(N) ;
        di as txt "Group variable: " as res "`e(ivar)'" as txt
		_col(49) "Number of groups" _col(67) "="
                _col(69) as res %10.0fc e(N_g) _n ;
	di as txt "R-sq:" _col(49) as txt "Obs per group:" ;
	di as txt "     within  = " as res %6.4f e(r2_w)
		_col(63) as txt "min" _col(67) "="
		_col(69) as res %10.0fc e(g_min) ;
	di as txt "     between = " as res %6.4f e(r2_b)
		_col(63) as txt "avg" _col(67) "="
		_col(69) as res %10.1fc e(g_avg) ;
	di as txt "     overall = " as res %6.4f e(r2_o)
		_col(63) as txt "max" _col(67) "="
		_col(69) as res %10.0fc e(g_max) _n ;

        di as txt _col(49) "F(" as res e(df_b) as txt "," as res `dfe' 
		as txt ")" _col(67) "=" _col(70) as res %9.2f e(F) ;
        di as txt "corr(u_i, Xb)" _col(16) "= " as res %6.4f e(corr)
                as txt _col(49) "Prob > F" _col(67) "="
                _col(73) as res %6.4f `p' _n ;
	#delimit cr

	est di, level(`level') plus `diopts'
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
        
        di in smcl as txt %`c's "rho_ar" " {c |} " as res %10s "`rho_ar'"
        di in smcl as txt %`c's "sigma_u" " {c |} " as res %10s "`sigma_u'"
        di in smcl as txt %`c's "sigma_e" " {c |} " as res %10s "`sigma_e'"
        di in smcl as txt %`c's "rho_fov" " {c |} " as res %10s "`rho_fov'" /*
		*/ as txt "   (fraction of variance because of u_i)"
        di in smcl as txt "{hline `c1'}{c BT}{hline `rest'}"

	local ff : di %8.2f e(F_f)
	local ff = trim("`ff'")
	#delimit ;
	di as txt "F test that all u_i=0: " 
		"F(" as res e(df_a) as txt "," as res e(df_r) as txt ") = " 
		as res %8.2f "`ff'" _col(62) as txt "Prob > F = " 
		as res %6.4f fprob(e(df_a),e(df_r),e(F_f)) ;

	#delimit cr
	if "`e(dw)'" != "" {
		di as txt "modified Bhargava et al. Durbin-Watson = "/* 
			*/ as res e(d1)
		di as txt "Baltagi-Wu LBI = " as res e(LBI)
	}	

end

program RmCollMsg
	syntax [varlist(default=none fv)]
	if "`s(fvops)'" == "" {
		exit
	}
	foreach var of local varlist {
		if bsubstr("`var'", 1, 2) == "o." {
			local var = bsubstr("`var'", 3, .)
			if `"`:char `var'[fvrevar]'"' == "" ///
			 & `"`:char `var'[tsrevar]'"' == "" {
				di as txt ///
"note: `var' dropped because of collinearity"
			}
		}
	}
end


/* this program computes fixed effect residuals */
program define fe_res
	syntax varlist(fv), res(string) i(varname)

	tempvar xb u
	_predict double `xb'
	MkUi `varlist' , new(`u') i(`i')
	tokenize `varlist'
	gen double `res'=`1'-`xb'-`u'
end	
	

program define DispRE
	local vv : display "version " string(_caller()) ":"
	version 7, missing
	syntax [, Level(cilevel) *]
	_get_diopts diopts, `options'
	local cfmt `"`s(cformat)'"'
	if `"`cfmt'"' != "" {
		local rho_ar	: display `cfmt' e(rho_ar)
		local sigma_u	: display `cfmt' e(sigma_u)
		local sigma_e	: display `cfmt' e(sigma_u)
		local rho_fov	: display `cfmt' e(rho_fov)
		if e(Tcon)==1 {
			local thta_min : display `cfmt' e(thta_min)
		}
	}
	else {
		local rho_ar	: display %10.0g e(rho_ar)
		local sigma_u	: display %10.0g e(sigma_u)
		local sigma_e	: display %10.0g e(sigma_e)
		local rho_fov	: display %10.0g e(rho_fov)
		if e(Tcon)==1 {
			local thta_min : display %10.0g e(thta_min)
		}
	}

	if "`e(dw)'" != "" & "`e(LBI)'"=="" {
		`vv' ///
		lbi2 
	}	
	#delimit ;
	di _n as txt "RE GLS regression with AR(1) disturbances" 
		_col(49) as txt "Number of obs" _col(67) "=" 
		_col(69) as res %10.0fc e(N) ;
	di as txt "Group variable: " as res "`e(ivar)'" as txt
		_col(49) "Number of groups" _col(67) "="
		_col(69) as res %10.0fc e(N_g) _n ;
	di as txt "R-sq:" _col(49) as txt "Obs per group:" ;
	di as txt "     within  = " as res %6.4f e(r2_w)
		_col(63) as txt "min" _col(67) "="
		_col(69) as res %10.0fc e(g_min) ;
	di as txt "     between = " as res %6.4f e(r2_b)
		_col(63) as txt "avg" _col(67) "="
		_col(69) as res %10.1fc e(g_avg) ;
	di as txt "     overall = " as res %6.4f e(r2_o)
		_col(63) as txt "max" _col(67) "="
		_col(69) as res %10.0fc e(g_max) _n ;

	di as txt _col(49) "`e(chi2type)' chi2(" 
			as res e(df_m) as txt ")" _col(67) "="
		_col(70) as res %9.2f e(chi2) ;
	di as txt "corr(u_i, Xb)" _col(20) "= " as res "0"
		as txt " (assumed)" _col(49) "Prob > chi2" _col(67) "="
		_col(73) as res %6.4f 1-chi2(e(df_m),e(chi2)) ;
	#delimit cr

	if e(Tcon)==0 {
		di in smcl as txt _n "{hline 19} theta {hline 20}"
		di as txt "  min      5%       median        95%" /*
			*/ "      max" 
		di as res %6.4f e(thta_min) %9.4f e(thta_5) /*
			*/ %11.4f e(thta_50) %11.4f e(thta_95) /*
			*/ %9.4f e(thta_max) 
	}
	display

	est di, level(`level') plus `diopts'
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
	di in smcl as txt %`c's "rho_ar" " {c |} " as res %10s "`rho_ar'" /*
		*/ as txt "   (estimated autocorrelation coefficient)"
	di in smcl as txt %`c's "sigma_u" " {c |} " as res %10s "`sigma_u'"
	di in smcl as txt %`c's "sigma_e" " {c |} " as res %10s "`sigma_e'"
	di in smcl as txt %`c's "rho_fov" " {c |} " as res %10s "`rho_fov'" /*
		*/ as txt "   (fraction of variance due to u_i)"
	if e(Tcon)==1 {
		di in smcl as txt %`c's "theta" " {c |} " as res /*
			*/ %10s "`thta_min'"
	}	
	di in smcl as txt "{hline `c1'}{c BT}{hline `rest'}"
	if "`e(dw)'" != "" {
		di as txt "modified Bhargava et al. Durbin-Watson = "/* 
			*/ as res e(d1)
		di as txt "Baltagi-Wu LBI = " as res e(LBI)
	}	
end


program define lbi2, eclass
	local vv : display "version " string(_caller()) ":"
	version 7, missing
	
	sort `e(ivar)' `e(tvar)'

	tempname touse
	qui gen byte `touse'=e(sample)

	tempname b
	mat `b'=e(b)
	local names : colnames `b'
	local names : subinstr local names "_cons" ""
	local vars "`e(depvar)' `names'"

	`vv' lbiw2 `vars', id(`e(ivar)') t(`e(tvar)') touse(`touse') 

end	

program define lbiw2, eclass
	local vv : display "version " string(_caller()) ":"
	version 7, missing
	syntax varlist(fv ts), id(varname) t(varname) touse(varname) 
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	if `fvops' {
		local rmcoll "version 11: _rmcoll"
		fvrevar `varlist', substitute
	}
	else {
		local rmcoll _rmcoll
		tsrevar `varlist', substitute
	}
	local varlist `"`r(varlist)'"'

	tempvar zres zresLD Itj zres2I zres2 first last bhvar Itjf
	tempname d d1 d2 d3 d4 Szres2 bhstat NT xtest

	 qui {
		est hold `xtest'

		sort `id' `t' 
		preserve
 		keep if `touse'
	
		demean `varlist', i(`id') 

		tokenize `varlist'
		local depvar "`1'"
		macro shift 
 		`rmcoll' `*', `fvexp'
		local varlist "`depvar' `r(varlist)'"

		tokenize `varlist'
		macro shift
		local indeps "`*'"
		tempname tdelta
		scalar `tdelta' = `: char _dta[_TSdelta]'
		tsset `id' `t', delta(`=`tdelta'') noquery
	
		`vv' ///
		_regress `varlist'
		scalar `NT'=e(N)

		predict double `zres', res
		by `id': gen byte `Itj'=(`t'-`t'[_n-1]==`tdelta')
		by `id': gen byte `Itjf'=(`t'[_n+1]-`t'==`tdelta')
		by `id': gen double `zresLD'=(`zres'-`zres'[_n-1]*`Itj')^2
		by `id': gen double `bhvar'=(`zres'-`zres'[_n-1])^2
		gen double `zres2'=`zres'^2
		gen double `zres2I'=`zres2'*(1-`Itjf')
		by `id': replace `zres2I'=. if _n==_N

		sum `zres2', meanonly
		scalar `Szres2'=r(sum)
	
		sum `bhvar', meanonly
		scalar `bhstat'=r(sum)
		scalar `bhstat'=`bhstat'/`Szres2'

		sum `zresLD', meanonly
		scalar `d1'=r(sum)
		scalar `d1'=`d1'/`Szres2'

		sum `zres2I', meanonly
		scalar `d2'=r(sum)
		scalar `d2'=`d2'/`Szres2'

		by `id': gen byte `first'=(_n==1)
		by `id': gen byte `last'=(_n==_N)
	
		sum `zres2' if `first'==1
		scalar `d3'=r(sum)
		scalar `d3'=`d3'/`Szres2'

		sum `zres2' if `last'==1
		scalar `d4'=r(sum)
		scalar `d4'=`d4'/`Szres2'

		scalar `d'=`d1'+`d2'+`d3'+`d4'
		restore 

		est unhold `xtest'

		est scalar d1=`d1'
		est scalar LBI=`d'
	 	est scalar N_LBI=`NT'
	}
end

