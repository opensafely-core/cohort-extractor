*! version 1.0.0  03jan2005
program _strip_labels, sclass
	version 9
	syntax varlist

capture {

	foreach var of local varlist {
		local lab : value label `var'
		if "`lab'" != "" {
			label values `var'
			local vlist `vlist' `var'
			local llist `llist' `lab'
		}
	}

} // capture 

	local rc = c(rc)
	if `rc' {
		nobreak _restore_labels `vlist', labels(`llist')
		exit `rc'
	}
	sreturn local labellist `"`llist'"'
	sreturn local varlist `"`vlist'"'
end
exit
