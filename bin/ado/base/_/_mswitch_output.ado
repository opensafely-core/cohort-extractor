*! version 1.0.0  10mar2015

program _mswitch_output, eclass
	version 14.0
	syntax [varlist(ts fv)] [if] [in][, VARSWitch 			///
					states(integer 2) 		///
					model(string) 			///
					ar(numlist) 			///
					ARSWitch 			///
					touse(string) 			///
					tcons(string)			///
					acons(string)			///
					omit(string)			///
					* ]	
	
	tempname b V Cns
	tempname aic sbic hqic
	tempname neq cons nocons gaps

	mat `b' = r(b)
	mat `V' = r(V)
	if ("`omit'"=="1") {
		mat `b' = `b'*`tcons'' + `acons'
		mat `V' = `tcons'*`V'*`tcons''
	}

	scalar `neq' = `e(neq)'	
	scalar `cons' = `e(cons)'
	scalar `nocons' = `e(nscons)'
	local num_reg = `e(num_reg)'	
	local p0 `r(p0)'
	scalar `gaps' = `e(N_gaps)'


/**Collect all return list before reset**/
	tempname N ll k nsig npi xi_t_T xi_t_t Pmat uncprob tmin tmax 
	tempname V_modelbased
	scalar `N'	= `r(N)'
	scalar `ll'	= `r(ll)'
	scalar `k'	= `r(k)'
	scalar `nsig'	= `r(nsig)'
	scalar `npi'	= `r(npi)'
	local vce `r(vce)'
	if ("`vce'"=="robust")	mat `V_modelbased' = r(V_modelbased)
	local wc = wordcount("`e(eq_names)'")-`nsig'-`npi'
	forvalues i = 1(1)`wc' {
		local eqs: word `i' of `e(eq_names)'
		local eqnames `eqnames' `eqs'
	}

	mat `xi_t_T' = r(xi_t_T)
	mat `xi_t_t' = r(xi_t_t)
	mat `Pmat'   = r(Pmat)
	mat `uncprob' = r(uncprob)

	local tech	`r(tech)'
	local depvar	`e(depvar)'

	mat colname `b' = `e(col_names)'
	mat rowname `b' = `e(depvar)'
	mat colname `V' = `e(col_names)'
	mat rowname `V' = `e(col_names)'
	mat coleq `b' = `e(eq_names)'
	mat coleq `V' = `e(eq_names)'
	mat roweq `V' = `e(eq_names)'

	cap qui tsset
	local timevar `r(timevar)'
	local tsform `r(tsfmt)'	
	local unit1 `r(unit1)'
	qui sum `r(timevar)' if `touse'
	scalar `tmin' = `r(min)'
	scalar `tmax' = `r(max)'


/* Post coefficients */
	if ("`e(constraint)'"=="1") {
		mat `Cns' = e(Cns)
		ereturn post `b' `V' `Cns', esample(`touse')
	}
	else ereturn post `b' `V', esample(`touse')
	_post_vce_rank

	if (`"`model'"'=="msdr") {
		ereturn local title "Markov-switching dynamic regression"
	}
	else ereturn local title  "Markov-switching autoregression"


/* Set ereturn list */
	ereturn local depvar	= `"`depvar'"'
	ereturn scalar N	= `N'
	ereturn scalar N_gaps	= `gaps'
	ereturn scalar ll	= `ll'
	ereturn scalar k	= `k'
//	ereturn scalar ic	= `r(ic)'
	ereturn scalar states	= `states'
	ereturn local technique = `"`tech'"'
	ereturn local vce	= `"`vce'"'
	if ("`vce'"=="robust") {
		ereturn local vcetype = "Robust"
		ereturn matrix V_modelbased = `V_modelbased'
	}
	ereturn local eqnames	= `"`eqnames'"'
	ereturn local predict	= "mswitch_p"
	ereturn local estat_cmd	= "mswitch_estat"

//	ereturn hidden scalar cnum = `r(cnum)'
	ereturn hidden scalar neq 	= `neq' 	//hidden
	ereturn hidden scalar num_reg 	= `num_reg'	//hidden
	ereturn hidden scalar nsig	= `nsig'	//hidden
	ereturn hidden scalar cons	= `cons'	//hidden
	ereturn hidden scalar nocons	= `nocons'	//hidden

	tempname k_eq k_aux
	scalar `k_eq' = `neq'+`nsig'+`npi'
	scalar `k_aux' = `nsig'+`npi'
	if ("`p0'"=="smoothed")	{
		scalar `k_eq' = `k_eq' + `states'-1
		scalar `k_aux' = `k_aux' + `states'-1
	}
	ereturn scalar k_eq  = `k_eq'
	ereturn scalar k_aux = `k_aux'

	if ("`varswitch'"!="") ereturn local varswitch = `"varswitch"'
	if ("`arswitch'"!="") ereturn local arswitch = `"arswitch"'

	ereturn local p0	= "`p0'"

	scalar `aic'	= (-2*`e(ll)' + 2*`e(k)')/`e(N)'
	scalar `sbic'	= (-2*`e(ll)' + ln(`e(N)')*`e(k)')/`e(N)'
	scalar `hqic'	= (-2*`e(ll)' + 2*ln(ln(`e(N)'))*`e(k)')/`e(N)'

	ereturn scalar aic	= `aic'
	ereturn scalar sbic	= `sbic'
	ereturn scalar hqic	= `hqic'

	forvalues _colnames = 1/`states' {
		local _coleq `_coleq' State`_colnames'
	}
	mat colnames `uncprob' = `_coleq'
	mat colnames `Pmat'	= `_coleq'
	mat colnames `xi_t_t'	= `_coleq'
	mat colnames `xi_t_T'	= `_coleq'
	ereturn matrix uncprob = `uncprob'
	//ereturn hidden matrix xi_t_T	= `xi_t_T'	//hidden
	//ereturn hidden matrix xi_t_t	= `xi_t_t'	//hidden
	ereturn hidden matrix Pmat	= `Pmat'	//hidden

	ereturn local timevar	= `"`timevar'"'
	ereturn local tsfmt	= `"`tsform'"'
	
	ereturn scalar tmin	= `tmin'
	ereturn scalar tmax	= `tmax'
	if ("`unit1'"=="." | "`unit1'"=="g") { 
		ereturn local tmins	= `tmin'
		ereturn local tmaxs	= `tmax'
	}
	else {
		local tmins : di `tsform' `e(tmin)'
		local tmaxs : di `tsform' `e(tmax)'
		ereturn local tmins	= `"`tmins'"'
		ereturn local tmaxs	= `"`tmaxs'"'
	}

//	ereturn hidden local stdate	= `"`stdate'"' 	//hidden
//	ereturn hidden local endate	= `"`endate'"' 	//hidden

	
/* Display output for sigma */
	local count = 1
	if ("`varswitch'"=="")  {
		ereturn hidden local diparm1 lnsigma, exp label("sigma")
		if (`states'!=1)	ereturn hidden local diparm2 __sep__
		local count = `count'+2
	}
        else {
		forvalues i=1/`states' {
			ereturn hidden local diparm`count' lnsigma`i', exp /*
				*/ label("sigma`i'")
			local count = `count'+1
			ereturn hidden local diparm`count' __sep__
			local count = `count'+1
		}
	}


/* Display output for transition probabilities*/
	if (`states'!=1) {
	/*Reparameterize transition probabilities*/
        tempname est_mat
	mat `est_mat' = J(`states'*`num_reg',4,.)
	local partderiv = `num_reg'-1
	if (`"`partderiv'"'=="0") local partderiv 1
		local cnt = 0
	forvalues i=1/`states' {
		local pij
		local den 1
		forvalues j=1/`num_reg' {
			local den `den'+exp(-@`j') 
			local pij `pij' p`i'`j'
		}
		forvalues k=1/`num_reg' {

			local cnt = `cnt' + 1   
			if (`states'>2) {
				local func exp(-@`k')/(`den')
				local fderiv
				forvalues l = 1/`num_reg' {
if (`k'==`l')	local fd (-exp(-@`l')*(`den'-exp(-@`l')))
else		local fd (exp(-@`k')*exp(-@`l'))
local fderiv `fderiv' `fd'/(`den')^2
				}
				ereturn hidden local diparm`count' `pij',    /*
					*/ f(`func') d(`fderiv') /*
					*/ ci(logit) label("p`i'`k'") 
				}
			else {
				local den 1+exp(-@)
				local fderiv (-exp(-@))/(`den')^2
				ereturn hidden local diparm`count' `pij', /*
					*/ f(exp(-@)/(`den')) d(`fderiv') /*
					*/ ci(logit) label("`pij'")
			}
				local count = `count'+1
		}
		if ("`i'"!="`states'") {
			ereturn hidden local diparm`count' __sep__
			local count = `count' + 1
		}
	}


/* Display output for initial probabilities*/
	if ("`p0'"=="smoothed") {
		ereturn hidden local diparm`count' __sep__
		local count = `count'+1

		local p
		local den 1

		forvalues j=1/`e(num_reg)' {
			local den `den'+exp(-@`j') 
			local p `p' p`j'
		}

		forvalues k=1/`e(num_reg)' {
			local cnt = `cnt' + 1
			if (`e(states)'>2) {
				local func exp(-@`k')/(`den')
				local fderiv
				forvalues l = 1/`num_reg' {
if (`k'==`l')	local fd (-exp(-@`l')*(`den'-exp(-@`l')))
else		local fd (exp(-@`k')*exp(-@`l'))
local fderiv `fderiv' `fd'/(`den')^2
				}
				ereturn hidden local diparm`count' `p',      /*
					*/ f(`func') d(`fderiv') /*
					*/ ci(logit) label("p`k'")

			}
			else {
				local den 1+exp(-@)
				local fderiv (-exp(-@))/(`den')^2
				ereturn hidden local diparm`count' `p',      /*
					*/ f(exp(-@)/(`den')) d(`fderiv')    /*
					*/ ci(logit) label("p`k'")
			}
			local count = `count'+1
		}
	}

	}

	_mswitch_print, `options'

end
