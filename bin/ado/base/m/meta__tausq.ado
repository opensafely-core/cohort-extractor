*! version 1.0.0  02may2019

program meta__tausq, rclass
	version 16
	syntax [varlist(fv default=none)], 	///
		esvar(varname) 			///
		sevar(varname) 			///
		method(string) 			///
		touse(varname) 			///
		[noCONStant 			///
		maxiter(real 100) 		///
		TOLerance(real 1e-6)		///
		NRTOLerance(real 1e-5)		///
		from(real -1)			///
		trace]
	
	tempname tau 
	
	local addcons = cond("`constant'" == "", 1,0)
	local display = cond("`trace'" == "", 0, 1)
	
	if inlist("`method'", "hedges", "hschmidt", "dlaird", ///
		"sjonkman", "vc", "mm") {
		mata: st_numscalar("`tau'", _NItau("`varlist'", "`esvar'", ///
		"`sevar'", "`method'", `addcons', "`touse'"))
		
		return scalar _meta_tau2 = `tau'	
	}
	else {
		mata: st_matrix("`tau'", _Itau("`varlist'", "`esvar'", ///
		 "`sevar'", "`method'", `addcons', "`touse'", `maxiter', ///
		  `tolerance', `display', `nrtolerance'))
		  
		return scalar _meta_tau2 = `tau'[1,1]  
	}
	
end	
