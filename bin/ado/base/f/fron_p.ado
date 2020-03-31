*! version 1.2.3  15oct2019
program define fron_p
	version 8 

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		if ("`e(dist)'"== "tnormal") {
			version 16: display as error "option {bf:scores} not"	///
			 " allowed with {bf:distribution(tnormal)}"
			 exit 198
		}
		global S_COST = cond(`"`e(function)'"'=="production",1,-1)
		ml score `0'
		macro drop S_COST
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

	local myopts "U M TE"

		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/

	_pred_se "`myopts'" `0'

	if `s(done)' {
		exit
	}
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'

		/* Step 3:
			Parse your syntax.
		*/

	syntax [if] [in] [, `myopts']

	marksample touse

	local sumt = ("`u'"!="") + ("`te'"!="") + ("`m'"!="")
	if `sumt' >1 {
		di as err "only one statistic may be specified"
		exit 198
	}
	else { 
		if `sumt' == 0 {
			local stat "xb"
			di as txt "(option {bf:xb} assumed; fitted values)"
		}
		else 	local stat "`u'`m'`te'"
	}

	Calc `"`vtyp'"' `varn' `stat' `touse' 
end

program define Calc
	args vtyp varn stat cond
			/* vtyp: type of new variable
			   varn: name of new variable
	 		   cond: if & in
		 	   stat: option specified
			*/

	local y `e(depvar)'
	if "`e(function)'" == "cost" { 
		local COST=-1 
	}
	else { 
		local COST=1 
	}

				/* half-normal or exponential */
	if "`e(dist)'" != "tnormal" {
		if "`e(het)'" == "" {
			tempname sigma_v sigma_u
			scalar `sigma_v' = exp(0.5*[lnsig2v]_cons)
			scalar `sigma_u' = exp(0.5*[lnsig2u]_cons)
		}

		else if "`e(het)'" == "u" {
			tempname sigma_v
			scalar `sigma_v' = exp(0.5*[lnsig2v]_cons)

			tempvar xb_u sigma_u
			qui _predict double `xb_u' if `cond', xb eq(lnsig2u)
			qui gen double `sigma_u' = exp(0.5*`xb_u')
		}

		else if "`e(het)'" == "v" {
			tempname sigma_u
			scalar `sigma_u' = exp(0.5*[lnsig2u]_cons)

			tempvar xb_v sigma_v
			qui _predict double `xb_v' if `cond', xb eq(lnsig2v)
			qui gen double `sigma_v' = exp(0.5*`xb_v')
		}

		else if "`e(het)'" == "uv" {
			tempvar xb_u xb_v sigma_v sigma_u
			qui _predict double `xb_u' if `cond', xb eq(lnsig2u)
			qui gen double `sigma_u' = exp(0.5*`xb_u')

			qui _predict double `xb_v' if `cond', xb eq(lnsig2v)
			qui gen double `sigma_v' = exp(0.5*`xb_v')
		}
	}
				/* truncated-normal */
	else {
		tempname gamma sigmaS2 sigma_v sigma_u
		scalar `sigmaS2' = exp([lnsigma2]_cons)
		scalar `gamma' = [lgtgamma]_cons
		scalar `gamma' = exp(`gamma')/(1+exp(`gamma'))		
		scalar `sigma_u' = sqrt(`gamma'*`sigmaS2')
		scalar `sigma_v' = sqrt((1-`gamma')*`sigmaS2')

		tempvar zd
		qui _predict double `zd' if `cond', xb eq(mu)
	}			

					/* Predict xb, and get ei */
	tempvar xb res
	qui _predict double `xb' if `cond', xb
	qui gen double `res'=`y'-`xb' if `cond'

					/* assume u_i|e_i is distributed
					   as N(mu1, sigma1^2) */
	tempvar mu1 sigma1
	if "`e(dist)'" == "hnormal" {
		qui gen double `mu1' = -`COST'*`res'*`sigma_u'^2 /*
			*/ /(`sigma_u'^2+`sigma_v'^2) if `cond'
		qui gen double `sigma1' = `sigma_u'*`sigma_v' /*
			*/ /sqrt(`sigma_u'^2+`sigma_v'^2) if `cond'
	}
	else if "`e(dist)'" == "exponential" {
		qui gen double `mu1'=-`COST'*`res'-(`sigma_v'^2/`sigma_u') /*
			*/ if `cond'
		qui gen `sigma1' = `sigma_v' if `cond'
	}
	else {
		qui gen double `mu1' = (-`COST'*`res'*`sigma_u'^2 + /*
		*/ `zd'*`sigma_v'^2)/(`sigma_u'^2+`sigma_v'^2) if `cond'
		qui gen double `sigma1' = `sigma_u'*`sigma_v' /*
			*/ /sqrt(`sigma_u'^2+`sigma_v'^2) if `cond'
	}

	local z (`mu1'/`sigma1') 

	if "`stat'"=="xb" {
		gen `vtyp' `varn'=`xb' if `cond'
		label var `varn' `"`:var label `xb''"'
	}

					/* Get estimates for u=E(u|e) */
	else if "`stat'"=="u" {
		gen `vtyp' `varn'=`mu1'+`sigma1'* /*
			*/ (normd(-`z')/norm(`z')) /*
			*/ if `cond'
		label variable `varn' ///
			"minus log of technical efficiency via mean E(u|e)"
	}
	
					/* Get estimates for M(u|e) */
	else if "`stat'"=="m" {
		gen `vtyp' `varn'=cond(`mu1'>=0, `mu1', 0) if `cond'
		label variable `varn' ///
			"minus log of technical efficiency via mode M(u|e)"
	}

			/* Get estimates for Technical Efficiency (TE) */
	else if "`stat'"=="te" {
		gen `vtyp' `varn'= (norm(-`COST'*`sigma1'+`z')) /*
			*/ /norm(`z') /*
			*/ *exp(-`COST'*`mu1'+1/2*`sigma1'^2)/*
			*/ if `cond'
		label variable `varn' ///
			"technical efficiency via E[exp(-su)|e]"
	}
end
