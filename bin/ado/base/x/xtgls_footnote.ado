*! version 1.0.1  05may2015
program xtgls_footnote
        version 13.1
	local w = `"`s(width)'"'
        capture {
                confirm integer number `w'
        }
        if c(rc) {
                local w 78
        }
        if (e(N_g)>=e(N_t) & e(PC)==1) {
 		di as text"{p 0 6 6 `s(width)'}Note: when the number of " ///
		"panels is greater than or equal to the number of periods, " ///
		"results are based on a generalized inverse of a singular " ///
		"matrix."
		di as text "{p_end}"
        }
	if e(df_pear) <= 0 {
		noi di as text `"Note: "' _c
		noi di as text `"you estimated at least as many quantities "' _c
		noi di as text `"as you have observations."'
	}
end
exit
