*! version 1.0.1  06feb2007
program _rotate_text, rclass
	version 9
	
	syntax [, noROTated ]

	if ("`rotated'" == "") & ("`e(r_criterion)'" != "") { 
		if "`e(r_normalization)'" == "horst" ///
				| "`e(r_normalization)'" == "kaiser" { 
			local h Kaiser on	
		}
		else {
			local h Kaiser off
		}
		local rtext `"`e(r_class)' `e(r_criterion)' (`h')"' 
	}	
	else {
		local rtext "(unrotated)"
	}	

	return local rtext `" `rtext'"'
end
exit
