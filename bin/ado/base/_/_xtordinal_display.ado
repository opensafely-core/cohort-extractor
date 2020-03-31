*! version 1.0.3  02feb2015
program define _xtordinal_display

	syntax [, Level(cilevel) OR noLRtest noDISplay *]
        
        if "`or'" != "" local earg "eform(Odds Ratio)" 
	_get_diopts diopts, `options'
	
	if "`display'"=="" {
		_crcphdr
		_coef_table, `earg' level(`level') `diopts' cmdextras
		if "`lrtest'"=="" {
			_LR_test
		}
	}
	
end

program _LR_test, sclass
	
	// skip LR test if certain conditions are met
	if !e(k_r) | "`e(vce)'"!="oim" | e(has_cns) | !e(estimates) {
		exit
	}
	if !e(converged) {
		exit
	}
	
	_lrtest_note_me, msg("LR test vs. `e(model)' model")

end

exit

