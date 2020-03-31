*! version 1.0.0  16jan2015

program define _stteffects_gmm_surv, rclass
	version 14.0
	syntax varlist(numeric) [if], b(name) dist(string) stat(string)    ///
		tvar(varname) levels(string) control(integer) 	           ///
		tlevel(integer) to(passthru) do(passthru) [ deriv(varlist) ]

	tempvar ti xb zg
	tempname bt bm bc

	local klev : list sizeof levels
	local pomean = ("`stat'"=="pomeans")
	local atet = ("`stat'"=="atet")
	local expo = ("`dist'"=="exponential")
	local bderiv = ("`deriv'"!="")
	local eqs : coleq `b'
	local eqs : list uniq eqs

	if !`pomean' {
		tempname bc0
		mat `bm' = `b'[1,"POmean`control':_cons"]
		scalar `bc0' = `bm'[1,1]
		/* control index					*/
		if `atet' {
			tempvar tr
			qui gen byte `tr' = `tlevel'.`tvar' `if'
		}
		if "`stat'" == "cot" {
			local STAT ATET
		}
		else {
			local STAT = upper("`stat'")
		}
	}
	scalar `bc' = 0
	qui gen byte `ti' = .
	local k = `klev'
	forvalues i=1/`klev' {
		local lev : word `i' of `levels'
		qui replace `ti' = `lev'.`tvar' `if'

		/* OME score						*/
		local s : word `++k' of `varlist'
		if `pomean' {
			local poeq POmean`lev'
		}
		else if `lev' == `control' {
			/* control POmean at location klev		*/
			local poeq POmean`lev'
			scalar `bc' = 0
		}
		else {
			/* treatment vs control at location ib		*/
			local poeq `STAT'`lev'
			scalar `bc' = `bc0'
		}
		mat `bm' = `b'[1,"`poeq':_cons"]
		scalar `bt' = `bm'[1,1]
		if `bc' {
			scalar `bt' = scalar(`bt') + scalar(`bc')
		}
		/* POM score						*/
		_stteffects_gmm_var `varlist', eqs(`eqs') eq(`poeq')
		local e `r(varname)'
		/* OME score						*/
		_stteffects_gmm_var `varlist', eqs(`eqs') eq(OME`lev')
		local s `r(varname)'
		local slist `slist' `e' `s'
		if `bderiv' {
			/* dPO/dpo, dPO/dom, dOM/dom			*/
			_stteffects_gmm_var `deriv', eqs(`eqs') req(`poeq') ///
				ceq(`poeq')
			local dpp `r(varname)'
			_stteffects_gmm_var `deriv', eqs(`eqs') req(`poeq') ///
				ceq(OME`lev')
			local dpo `r(varname)'
			_stteffects_gmm_var `deriv', eqs(`eqs') ///
				req(OME`lev') ceq(OME`lev')
			local doo `r(varname)'
			local dlist `dpp' `dpo'
			if !`expo' {
				/* dPO/doma				*/
				_stteffects_gmm_var `deriv', eqs(`eqs') ///
					req(`poeq') ceq(OME`lev'_lnshape)
				local dpa `r(varname)'
				local dlist `dlist' `dpa'
			}
			local dlist `dlist' `doo'
		}
		mat score double `xb' = `b' `if', eq(OME`lev')
		if `expo' {
			_stteffects_exponential_moments `e' `s'  `if',      ///
				`stat' xb(`xb') ti(`ti') `to' `do' bt(`bt') ///
				tr(`tr') deriv(`dlist') 
		}
		else  {
			/* OME shape parameter score			*/
			mat score double `zg' = `b' `if', eq(OME`lev'_lnshape)
			_stteffects_gmm_var `varlist', eqs(`eqs') ///
				eq(OME`lev'_lnshape)
			local sa `r(varname)'
			local slist `slist' `sa'

			if `bderiv' {
				/* dOM/doma, dOMA/dom, dOMA/doma	*/
				_stteffects_gmm_var `deriv', eqs(`eqs') ///
					req(OME`lev') ceq(OME`lev'_lnshape)
				local doa `r(varname)'
				_stteffects_gmm_var `deriv', eqs(`eqs') ///
					req(OME`lev'_lnshape) ceq(OME`lev')
				local dao `r(varname)'
				_stteffects_gmm_var `deriv', eqs(`eqs') ///
					req(OME`lev'_lnshape)           ///
					ceq(OME`lev'_lnshape)
				local daa `r(varname)'
				local dlist `dlist' `doa' `dao' `daa'
			}
			_stteffects_`dist'_moments `e' `s' `sa' `if', `stat' ///
				xb(`xb') zg(`zg') ti(`ti') `to' `do'         ///
				bt(`bt') tr(`tr') deriv(`dlist')

			qui drop `zg'
		}
		qui drop `xb'
	}
	if `bderiv' & !`pomean' {
		_stteffects_gmm_var `deriv', eqs(`eqs') req(POmean`control') ///
			ceq(POmean`control')
		local dc `r(varname)'
		forvalues i=1/`klev' {
			local lev : word `i' of `levels'
			if `lev' == `control' {
				continue
			}
			/* dSTAT/dpo					*/
			_stteffects_gmm_var `deriv', eqs(`eqs') ///
				req(`STAT'`lev') ceq(POmean`control')
			local di `r(varname)'
			qui replace `di' = `dc' `if'
		}
	}
	return local varlist `slist'
end

exit


derivative layout

                linear form
eq   po1 po2 om1 oma1 om2 oma2
PO1   1       2   3
PO2       4            5   6
OM1           7   8
OMA1          9  10
OM2                   11  12
OMA2                  13  14

