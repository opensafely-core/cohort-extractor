*! version 1.0.1  22feb2019

program define ivpostsigma, eclass
	local version = string(_caller())
	syntax, b(name) vars(string) [ probit ]

	tempname cor sig

	local k : list sizeof vars
	mat `cor' = I(`k')
	mat `sig' = I(`k')
	forvalues j=1/`k' {
		local yj : word `j' of `vars'
		_msparse e.`yj'
		local evars `evars' `r(stripe)'
	}
	if "`probit'" != "" {
		local j1 = 2
	}
	else {
		local j1 = 1
	}
	local jd = 0
	forvalues j=1/`k' {
		local yj : word `j' of `evars'
		local lab `lab' `yj'
		forvalues i=`=`j'+1'/`k' {
			local yi : word `i' of `evars'
			if `version' < 16 {
				local l = colnumb(`b',"athrho`i'_`j':_cons")
			}
			else {
				local l = colnumb(`b',"/:athrho`i'_`j'")
			}
			mat `cor'[`i',`j'] = tanh(`b'[1,`l'])
			mat `cor'[`j',`i'] = `cor'[`i',`j']
			ereturn hidden local diparm`++jd' athrho`i'_`j', ///
					label("corr(`yi',`yj')")         ///
					function(tanh(@))                ///
					derivative(1/cosh(@)^2)
			
		}
		if `j' > 1 {
			if `version' < 16 {
				qui test [athrho`j'_1]_b[_cons], `acc'
			}
			else {
				qui test /athrho`j'_1 = 0, `acc'
			}
			local acc accumulate
		}
	}
	forvalues j=`j1'/`k' {
		local yj : word `j' of `evars'
		if `version' < 16 {
			local l = colnumb(`b',"lnsigma`j':_cons")
		}
		else {
			local l = colnumb(`b',"/:lnsigma`j'")
		}
		mat `sig'[`j',`j'] = exp(`b'[1,`l'])
		ereturn hidden local diparm`++jd' lnsigma`j', ///
			label("sd(`yj')") function(exp(@)) ///
			derivative(exp(@))

	}
	local kaux = `k'*(`k'+1)/2
	if "`probit'" != "" {
		local `--kaux'
	}
	local ken = `k'-1
	ereturn scalar chi2_exog = r(chi2)
	ereturn scalar p_exog = chiprob(`ken',r(chi2))
	ereturn scalar endog_ct = `ken'		// df_exog
	if `version' < 16 {
		ereturn scalar k_aux = `kaux'
	}
	mat `sig' = `sig'*`cor'*`sig'
	/* make perfectly symmetric					*/
	mat `sig' = (`sig'+`sig'')/2
	mat colnames `sig' = `lab'
	mat rownames `sig' = `lab'
	ereturn matrix Sigma = `sig'
end

exit
