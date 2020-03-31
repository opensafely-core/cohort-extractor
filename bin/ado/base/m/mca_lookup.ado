*! version 1.0.1  16feb2015
program mca_lookup, sclass 
	version 9
	args name names

	foreach n of local names {
		if "`name'" == "`n'" {
			local matching `n'
			local done done
		}
	}
	if "`done'" =="" {
		foreach n of local names {
			if "`name'" == bsubstr("`n'",1,length("`name'")) {
				local matching `matching' `n' 
			}	
		}
		local nmatching : word count `matching'  
		if `nmatching' == 0 { 
			dis as err "`name' matches none of the MCA variables" 
			dis as err "valid names: `names'"
			exit 198
		}
		else if `nmatching' > 1 { 
			dis as err "`name' matches multiple MCA variables" 
			dis as err "valid names: `names'"
			exit 198
		}
	}
	
	sreturn clear
	sreturn local name `matching' 
end
exit
