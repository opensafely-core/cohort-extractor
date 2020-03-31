*! version 1.0.1  22sep2009

program u_mi_trcoef_legend
	version 11

	args names

	if (e(k_exp_mi)>0 & `"`names'"'=="") {
		tokenize `e(expnames_mi)'
		forvalues i=1/`e(k_exp_mi)' {
			di as txt %13s abbrev(`"``i''"',12) ": " ///
        	           `"{res:`e(exp`i'_mi)'}"'
		}
	}
	else if (`"`names'"'!="") {
		local expnames `e(expnames_mi)'
		local k_exp : word count `names'
		tokenize `names'
		forvalues i=1/`k_exp' {
			local j : list posof `"``i''"' in expnames
			if (`j'!=0) {
				di as txt %13s abbrev(`"``i''"',12) ": " ///
        		           `"{res:`e(exp`j'_mi)'}"'
			}
		}
		
	}
end
