*! version 1.0.0  15mar2004
program define _vec_pgparse , sclass
	version 8.2

	syntax [anything(name=nlist id="numlist")] [, * ]
	
	if `"`nlist'"' != "" {
		numlist "`nlist'" , range(>0 <=1) sort
		local nlist `r(numlist)'
	}

	sret clear
	sret local numlist "`nlist'"
	sret local popts `"`options'"'
	
end
