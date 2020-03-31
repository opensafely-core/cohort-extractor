*! version 1.0.0  04nov2016
					//----------------------------//
					//_spreg_pseudor2 : compute the pseudo
					//R^2 and comparison test statistics
					//----------------------------//

program _spreg_pseudor2
						// Pseudo R-squared
	PseudoR2	
						// comparison test of
						// non-spatial terms
	NonSpatialTest	
	
end
					//-- Pseudo R2 --//
program PseudoR2, eclass
						// pseudo R-squared =
						// corr^2(y,yp)
	local y `e(depvar)'
	tempname yp
	eret hidden local cmd2 _spreg_pseudor2	
	_spivreg_p double `yp' if e(sample), rform
	qui corr `yp' `y' if e(sample)
	local r = r(rho)
	eret scalar r2_p = `r'^2
end
					//-- Non spatial terms test  --//
program NonSpatialTest, eclass
	local lag_list `e(lag_list_full)'	
	foreach w of local lag_list {
		local eq_spatial `eq_spatial' ([`w'])
	}
	if (`"`eq_spatial'"'!="") {
		qui test `eq_spatial'
		eret scalar chi2_c = r(chi2)
		eret scalar df_c = r(df)
		eret scalar p_c = r(p)
	}
end
