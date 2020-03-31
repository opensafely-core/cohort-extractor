*! version 1.0.0  31aug1998
program define _crcchkw /* ivar wv touse */
	version 6.0
        args ivar v touse
        cap by `touse' `ivar': assert `v'==`v'[_n-1] if _n>1 & `touse'
        if _rc {
                noi di in red "weight must be constant within `ivar'"
                exit 199
        }
end

