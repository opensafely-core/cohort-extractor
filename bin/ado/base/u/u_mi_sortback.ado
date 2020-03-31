*! version 1.0.1  09feb2015
/*
	u_mi_sortback <varlist>

	Removes dropped nonexisting variables from varlist 
	and sorts the data and the remaining.  For use when 
	data might be subjected to substantial editing.

	Usage:
		local sortedby : sortedby
		tempvar recnum
		gen `c(obs_t)' `recnum' = _n 
		compress `recnum'
		...
		u_mi_sortback `sortedby' `recnum'
*/

program u_mi_sortback
	version 11

	capture syntax varlist
	if (_rc) { 
		if (_rc != 111) { 
			error _rc
		}
		local varlist
		foreach el of local 0 {
			capture noabbrev confirm var `el'
			if (_rc==0) { 
				local varlist `varlist' `el'
			}
		}
		if ("`varlist'"=="") {
			exit
		}
	}
	sort `varlist'
end
