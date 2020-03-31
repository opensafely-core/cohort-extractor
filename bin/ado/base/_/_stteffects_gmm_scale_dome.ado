*! version 1.0.0  17jan2015

program define _stteffects_gmm_scale_dome, rclass
	version 14.0
	syntax varlist [if], wgt(varname) levels(string) expo(integer) ///
			eqs(passthru)

	local klev : list sizeof levels
	forvalues i=1/`klev' {
		local lev : word `i' of `levels'
		/* scale dOM/dom					*/
		_stteffects_gmm_var `varlist', `eqs' req(OME`lev') ///
			ceq(OME`lev')
		local d `r(varname)'
		qui replace `d' = `d'*`wgt' `if'
		if `expo' {
			continue
		}
		/* scale dOME/doma					*/
		_stteffects_gmm_var `varlist', `eqs' req(OME`lev') ///
			ceq(OME`lev'_lnshape)
		local d `r(varname)'
		qui replace `d' = `d'*`wgt' `if'
		/* scale dOMA/dom					*/
		_stteffects_gmm_var `varlist', `eqs' req(OME`lev'_lnshape) ///
			ceq(OME`lev')
		local d `r(varname)'
		qui replace `d' = `d'*`wgt' `if'
		/* scale dOMA/doma					*/
		_stteffects_gmm_var `varlist', `eqs' req(OME`lev'_lnshape) ///
			ceq(OME`lev'_lnshape)
		local d `r(varname)'
		qui replace `d' = `d'*`wgt' `if'
	}
end

exit

