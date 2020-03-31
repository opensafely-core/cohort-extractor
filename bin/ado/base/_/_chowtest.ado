*! version 1.0.0  12dec2014

program _chowtest, sclass
	syntax [anything], break(string) test(string) [ 		    ///
				modelcons(string) breakcons(string) 	    ///
				touse(string) model_est(string) 	    ///
				nonbrk(varlist ts fv) ]
	
	qui estimates restore `model_est'
	local vcetype `e(vce)'
	local wgt "`e(wtype)'"
	local wgtexp "`e(wexp)'"

	local varlist `anything'
	tempname ReducedModel
	local k = wordcount("`varlist'") 
	if ("`modelcons'"=="" & "`breakcons'"!="") local k = `k' + 1
	tempvar ind miscount
	qui gen `ind' = 0 if `touse'
	local cnt = 0
	foreach i of local break {
		local j = `j' + 1
		qui replace `ind' = `j' if _n >= `i' & `touse'
	}
	if ("`e(cmd)'"=="regress") {
		foreach var of local varlist {
			_ret_op `var'
			local indx `indx' `ind'#`r(op)'.`var'
			local tindx `tindx' i(1/`j')`ind'#`r(op)'.`var'
		}
		if ("`modelcons'"=="" & "`breakcons'"!="") {
			qui reg `e(depvar)' `varlist' `nonbrk' i.`ind' 	    ///
				`indx' if `touse' [`wgt'`wgtexp'], 	    ///
				vce(`vcetype')
		}
		else if ("`breakcons'"=="") {
			qui reg `e(depvar)' `varlist' `nonbrk' `indx' if    ///
				`touse' [`wgt'`wgtexp'], `modelcons' 	    ///
				vce(`vcetype') 
		}
		if ("`test'"=="wald") {
			qui testparm i(1/`j').`ind' `tindx'
		}
		else if ("`test'"=="lr") {
			estimates store `ReducedModel'
			qui lrtest `model_est' `ReducedModel'
		}
		else {
			qui testparm i(1/`j').`ind' `tindx'
			sreturn local waldstat = `r(df)'*`r(F)'
			estimates store `ReducedModel'
			qui lrtest `model_est' `ReducedModel'
			sreturn local lrstat = `r(chi2)'
		}
	}
	else if ("`e(cmd)'"=="ivregress") {
		local instd `e(instd)'
		local insts `e(insts)'
		local exogr `e(exogr)'
		local rvars: list insts - exogr

		if ("`nonbrk'"!="") {
			foreach ins of local instd {
				_ret_op `ins'
				local brkinstd : list ins & varlist
				if ("`brkinstd'"!="") {
local in_indx `in_indx' `ind'#`r(op)'.`brkinstd'
local in_tindx `in_tindx' i(1/`j')`ind'#`r(op)'.`brkinstd'
				}
			}
			if ("`in_indx'"!="") {
				foreach rv of local rvars {
_ret_op `rv'
local rv_indx `rv_indx' `ind'#`r(op)'.`rv'
				}
			}
			foreach exo of local exogr {
				_ret_op `exo'
				local brkexo : list exo & varlist
				if ("`brkexo'"!="") {
local ex_indx `ex_indx' `ind'#`r(op)'.`brkexo'
local ex_tindx `ex_tindx' i(1/`j')`ind'#`r(op)'.`brkexo'
				}
			}
		}
		else {
			foreach var of local exogr {
				_ret_op `var'
				local ex_indx `ex_indx' `ind'#`r(op)'.`var'
				local ex_tindx `ex_tindx' 		    ///
					i(1/`j')`ind'#`r(op)'.`var'
			}
			foreach var of local instd {
				_ret_op `var'
				local in_indx `in_indx' `ind'#`r(op)'.`var'
				local in_tindx `in_tindx' 		    ///
					i(1/`j')`ind'#`r(op)'.`var'
			}
			foreach var of local rvars {
				_ret_op `var'
				local rv_indx `rv_indx' `ind'#`r(op)'.`var'
			}
		}
		if ("`instd'"!="") {
			local endg_part (`instd' `in_indx' = `rvars' `rv_indx')	
		}
		else local endg_part 
		if ("`modelcons'"=="" & "`breakcons'"!="") {
			qui ivregress 2sls `e(depvar)' `exogr' i.`ind' 	    ///
				`ex_indx' `endg_part'  if `touse' 	    ///
				[`wgt'`wgtexp'] , vce(`vcetype') 
		}
		else if ("`breakcons'"=="") {
			qui ivregress 2sls `e(depvar)' `exogr' `ex_indx'    ///
				`endg_part' if `touse' [`wgt'`wgtexp'],     ///
				`modelcons' vce(`vcetype') 
		}
		qui testparm i(1/`j').`ind' `ex_tindx' `in_tindx' 
	}
	
	sreturn local nparms = `k'
end


program _ret_op, rclass
	syntax varname(ts fv)

	cap qui _fv_check_depvar `varname'
	if (_rc) 	return local op = "i"
	else 		return local op = "c"

end
