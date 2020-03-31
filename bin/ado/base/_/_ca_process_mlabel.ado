*! version 1.0.0  19may2005
*  routine used by cabiplot and caprojection

program _ca_process_mlabel, sortpreserve
	version 9.0
	
	args mlabel colon var mlabvar touse type
	// touse is expected to be (-e(sample))
	
	tempvar temp
	sort `touse' `var'
	quietly by `touse' `var' : 					///
		generate `temp' = `mlabvar' == `mlabvar'[_n+1] | _n == _N
	sort `touse' `temp'
	if ! `temp'[1] {
		display as text ///
			"warning: `type' marker labels are not "	///
			"consistent within groups (ignored)"
		c_local `mlabel' ""
	}
	else {
		c_local `mlabel' "mlabel(`mlabvar')"
	}
end
