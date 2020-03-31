*! version 1.0.0  17jan2015

program define _stteffects_gmm_dcensor, rclass
	version 14.0
	syntax varlist [if], levels(string) eqs(string)  expo(integer) ///
		cexpo(integer) wgt(varname) do(varname) [ dwgt(string) ///
		deriv(varlist) noscale ]

	local scale = ("`scale'"=="")
	local bderiv = ("`deriv'"!="")
	if `bderiv' {
		gettoken dwc dwa : dwgt
		if `bderiv' & !`cexpo' & "`dwa'"=="" {
			/* programmer error				*/
			di as err "{p}censoring weight derivatives w.r.t. " ///
			 "log-shape linear form is required{p_end}"
			exit 498
		}
	}
	local klev : list sizeof levels
	forvalues i=1/`klev' {
		local lev : word `i' of `levels'
		/* OME score						*/
		_stteffects_gmm_var `varlist', eqs(`eqs') eq(OME`lev')	
		local s `r(varname)'
		if `bderiv' {
			/* compute dOM/dcm				*/
			_stteffects_gmm_var `deriv', eqs(`eqs') ///
				req(OME`lev') ceq(CME)
			local d `r(varname)'
			qui replace `d' = cond(`do',`dwc'*`s',0) `if'
			if !`cexpo' {
				/* compute dOM/doma			*/
				_stteffects_gmm_var `deriv', eqs(`eqs') ///
					req(OME`lev') ceq(CME_lnshape)
				local d `r(varname)'
				qui replace `d' = cond(`do',`dwa'*`s',0) `if'
			}
		}
		if `scale' {
			/* now scale OME score				*/
			qui replace `s' = cond(`do',`s'*`wgt',0) `if'
			local slist `slist' `s'
		}
		if !`expo' {
			/* OME_lnshape score				*/
			_stteffects_gmm_var `varlist', eqs(`eqs') ///
				eq(OME`lev'_lnshape)
			local s `r(varname)'
			if `bderiv' {
				/* compute dOMA/dcm			*/
				_stteffects_gmm_var `deriv', eqs(`eqs') ///
					req(OME`lev'_lnshape) ceq(CME)
				local d `r(varname)'
				qui replace `d' = cond(`do',`dwc'*`s',0) `if'
				if !`cexpo' {
					/* compute dOMA/dcma		*/
					_stteffects_gmm_var `deriv',  ///
						eqs(`eqs')            ///
						req(OME`lev'_lnshape) ///
						ceq(CME_lnshape)
					local d `r(varname)'
					qui replace `d' = `dwa'*`s'
				}
			}
			if `scale' {
				/* now scale OME_lnshape score		*/
				qui replace `s' = cond(`do',`s'*`wgt',0) `if'
				local slist `slist' `s'
			}
		}
	}
	return local varlist `slist'
end

exit

