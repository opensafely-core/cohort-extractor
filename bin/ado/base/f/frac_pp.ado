*! 13May96. Was _jprfppp.
program define frac_pp, sclass
/* parse powers, sort if necessary, store results */
	version 6.0
	args p powers tosort toone 
	sret clear
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
	if `np'>_N {
		di in blue "need more space, increasing no. of obs. to " `np'
		set obs `np'
	}
	local i 1
	while `i'<=`np' {
		qui replace `p' = `p`i'' in `i'
		local i=`i'+1
	}
	if `np'>0 {
		if `tosort' { sort `p' }
		loc pwrs = `p'[1]
		loc i 1
		while `i'<`np' {
			loc i = `i'+1
			loc pj = `p'[`i']
			loc pwrs "`pwrs',`pj'"
		}
	}
	sret local np `np'
	sret local unsorted `unsortd'  /* flag for whether sorted */
	sret local powers "`pwrs'"       /* comma-delimited powers */
end
