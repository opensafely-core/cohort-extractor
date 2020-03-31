*! version 1.0.0 PR 10Oct97.
program define frac_in, sclass /* target_varname varlist_to_check */
	version 6
	* Returns s(k) = index # of target_varname in varlist_to_check.
	args v vl
	sret clear
	local nx: word count `vl'
	sret local k 0
	local j 0
	while `j'<`nx' {
		local j = `j'+1
		local vj: word `j' of `vl'
		if "`v'"=="`vj'" {
			sret local k `j'
			local j `nx'
		}
	}
	if `s(k)'==0 {
    		di in red "`v' is not an xvar"
    		exit 198
	}
end
