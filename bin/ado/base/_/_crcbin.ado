*! version 1.0.1  23sep2002
program define _crcbin
        tempname bb
        mat `bb' = e(b)
        local names : colnames(`bb')
        tokenize `names'
        local dep "`e(depvar)'"
        while "`1'" != "_cons" {
                qui summ `1' if `dep'==0 & e(sample)
                local m0 = r(min)
                local M0 = r(max)
                qui summ `1' if `dep'!=0 & e(sample)

		local m1 = r(min)
		local M1 = r(max)

		/* Rule 1 */

		if `m0'==`M0' & (`m0'==`m1' | `m0'==`M1') {
			if "`flag'" == "" { noi di _n in bl "Note: " _c }
			else              { noi di in bl "      " _c }
			local flag 1
			noi di in bl "`1'!=`m0' predicts failure perfectly"
		} 
		else if `m1'==`M1' & (`m1'==`m0' | `m1'==`M0') {
			if "`flag'" == "" { noi di _n in bl "Note: " _c }
			else              { noi di in bl "      " _c }
			local flag 1
			noi di in bl "`1'!=`m1' predicts success perfectly"
		} 

		/* Rule 2 */

		else if `M0'==`m1' {
			if "`flag'" == "" { noi di _n in bl "Note: " _c }
			else              { noi di in bl "      " _c }
			local flag 1
			noi di in bl "`1'>`m1' predicts failure perfectly"
		}
		else if `M1'==`m0' {
			if "`flag'" == "" { noi di _n in bl "Note: " _c }
			else              { noi di in bl "      " _c }
			local flag 1
			noi di in bl "`1'>`m0' predicts failure perfectly"
		}

		/* Rule 3 */

		else if `M0' < `m1' {
			if "`flag'" == "" { noi di _n in bl "Note: " _c }
			else              { noi di in bl "      " _c }
			local flag 1
			noi di in bl "`1'>`m1' predicts data perfectly"
			exit 2000 
		}
		else if `M1' < `m0' {
			if "`flag'" == "" { noi di _n in bl "Note: " _c }
			else              { noi di in bl "      " _c }
			local flag 1
			noi di in bl "`1'<`m0' predicts data perfectly"
			exit 2000 
		}

		mac shift
	}
end
