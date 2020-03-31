*! v 1.0.0 PR 11Jun1999.
program define frac_pq, rclass
/* parse powers, sort if necessary, store results in r(p1), r(p2), etc. */
	version 6
	args powers tosort toone 
	tokenize "`powers'", parse(" ,")
	local np 0
	local lastp -1e10
	local unsortd 0	/* flag for powers enter sorted or not	*/
	local one 0	/* flag for powers contain 1 or not	*/
	while "`1'"!="" {
		if "`1'" == "," { mac shift }
		confirm number `1'
		if `1'==1 { local one 1 }
		local np = `np'+1
		local p`np' `1'
		if `1'<`lastp' { local unsortd 1 }
		local lastp `1'
		mac shift
	}
	if `toone' & !`one' {
		local np = `np'+1
		local p`np' 1
		local unsortd 1
	}
	if `np'>0 {
		if `tosort' {
			* Apply sort (Kernighan & Ritchie p 58)
			local gap=int(`np'/2)
			while `gap'>0 {
				local i `gap'
				while `i'<`np' {
					local j=`i'-`gap'
					while `j'>=0 {
						local j1=`j'+1
						local j2=`j'+`gap'+1
						if `p`j1''>`p`j2'' {
							local temp `p`j1''
							local p`j1' `p`j2''
							local p`j2' `temp'
						}
						local j=`j'-`gap'
					}
					local i=`i'+1
				}
				local gap=int(`gap'/2)
			}
		}	
		ret local p1 `p1'
		local pwrs `p1'
		local i 2
		while `i'<=`np' {
			ret local p`i' `p`i''
			local pwrs `pwrs',`p`i''
			local i = `i'+1
		}
	}
	ret local np `np'
	ret local unsorted `unsortd'  /* flag for whether sorted */
	ret local powers "`pwrs'"       /* comma-delimited powers */
end

