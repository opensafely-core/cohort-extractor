*! version 1.0.0  23feb2017
program _sp_update_lag_list, sclass
	version 15.0

/*
input	:

	new_lag_list:		W1_s001 W2_s001
	lag_list:      		W1 W2
	rho_lbs:       		rho*W1:e.y rho*W2:e.y
	elmat_list:    		W1 W2
	dlmat_list_full:	W1 W2
	wy_index:      		W1, x1 || W1, x2 || W2, x1 || W2, x2 

objective	:
	replace W with W_s001 	in rhos_lbs, elmat_list, dlmat_list_full, and
				wy_index

output	:
	lag_list:      		W1_s001 W2_s001
	rho_lbs:       		rho*W1_s001:e.y rho*W2_s001:e.y
	elmat_list:    		W1_s001 W2_s001
	dlmat_list_full:	W1_s001 W2_s001
	wy_index:      		W1_s001, x1 || W1_s001, x2 || 	
				W2_s001, x1 || W2_s001, x2 ||

*/
	syntax [, new_lag_list(string)		///
		lag_list(string)		///
		rho_lbs(string)			///
		elmat_list(string)		///
		dlmat_list_full(string)		///
		wy_index(string) ]
	
	local input_list lag_list rho_lbs elmat_list dlmat_list_full wy_index

	if (`"`new_lag_list'"'=="") {
		foreach output of local input_list {
			sret local `output' ``output''
		}
		exit
		// NotReached
	}

	local n_lag : list sizeof lag_list
	local tmp_list `lag_list'

	forvalues i=1/`n_lag' {
		local old_lag : word `i' of `lag_list'
		local new_lag : word `i' of `new_lag_list'
						// rho_lbs
		local rho_lbs	= usubinstr(`"`rho_lbs'"', 		///
			`"`old_lag':"', `"`new_lag':"', .)
						// elmat_list
		local elmat_list= usubinstr(`"`elmat_list'"',		///
			`"`old_lag'"', `"`new_lag'"', .)
						// dlmat_list_full
		local dlmat_list_full= usubinstr(`"`dlmat_list_full'"',	///
			`"`old_lag'"', `"`new_lag'"', .)
						// wy_index
		local wy_index= usubinstr(`"`wy_index'"',		///
			`"`old_lag',"', `"`new_lag',"', .)
						// tmp_list
		local tmp_list= usubinstr(`"`tmp_list'"',		///
			`"`old_lag'"', `"`new_lag'"', .)
	}
	local lag_list `tmp_list'

	foreach output of local input_list {
		sret local `output' ``output''
	}
end
