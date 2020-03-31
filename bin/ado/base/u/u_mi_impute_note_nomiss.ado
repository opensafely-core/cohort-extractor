*! version 1.0.0  12jun2011
program u_mi_impute_note_nomiss, sclass
	version 12
	args ivarsc ivarsinc nonote

	if ("`nonote'"!="") exit

	if ("`ivarsinc'"!="") { // not all ivars complete
		local semicolon ;
	}
	// completely-observed imputation variables
	local n : word count `ivarsc'
	if (`n'>0) {
		di as txt "{p 0 6 2}note: " plural(`n',"variable")
		di as txt " {bf:`ivarsc'} " plural(`n',"contains","contain") 
		di as txt " no soft missing (.) values`semicolon'"
		if ("`ivarsinc'"=="") {
			di as txt "{p_end}"
			di as txt "(imputation " 			///
			   plural(`n', "variable is ", "variables are ") ///
			  "complete; imputing nothing)"
			local nomiss nomiss
		}
		else {
			di as txt "imputing nothing{p_end}"
		}
	}
	sret local nomiss `nomiss'
end
