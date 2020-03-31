*! version 1.0.6  19nov1998
program define _crcseq
	version 6.0

	gettoken cmd 0 : 0
	syntax [, noRMDUP noIF noIN noRMCOLL WEIGHT(string) /*
		*/ TOUSE(string) EXPOK ]

	if "`rmdup'" != ""  { local dupcom "*" }
	else                { local dupcom "noisily" }
	if "`touse'" == ""  { local usecom "*" }
	else		    { confirm new var `touse' }

	quietly {
		if "`weight'"!="" {
			local weight "[`weight'/]"
		}
		local if = cond("`if'"=="", "[if]", "") 
		local in = cond("`in'"=="", "[in]", "")
		if "`expok'" != "" {
			local expok "Exposure(varname max=1 numeric)"
		}

		local 0 `"`cmd'"'
		noi syntax [varlist] `weight' `if' `in' [, /*
			*/ noCONstant OFFset(varname max=1 numeric) /*
			*/ Robust CLuster(varname max=1) SCore(string) /*
			*/ FROM(string) `expok' * ]

		tokenize `varlist'
		local dep 	"`1'"
		mac shift
		local ind	"`*'"

		c_local dep	"`dep'"
		c_local ind	"`ind'"
		c_local nc	"`constan'"
		c_local opts	`"`options'"'
		c_local ifx	`"`if'"'
		c_local inx	`"`in'"'
		c_local scvar	`"`score'"'
		c_local clvar	`"`cluster'"'
		c_local from	`"`from'"'

		local nc1	"`constan'"

		if "`weight'" != "" {
			c_local wtexp	`"`exp'"'
			c_local	wtype	`"`weight'"'
			c_local	wgt	`"[`weight'=`exp']"'
			local wtexp "[`weight'=`exp']"
			local wtype	`"`weight'"'
		}

		`usecom' mark `touse' `if' `in' `wtexp'
		`usecom' markout `touse' `dep' `ind' 

		if "`exposur'" != "" & "`offset'" != "" {
			noi di in red "may not specify exposure() and offset()"
			exit 198
		}

		if "`exposur'" != "" {
			c_local exposur	`"`exposur'"'
			tempvar tt
			gen double `tt' = ln(`exposur')
			`usecom' markout `touse' `tt'
		}
		if "`offset'" != "" {
			c_local off	`"`offset'"'
			c_local offo	`"offset(`offset')"'
			`usecom' markout `touse' `offset'
		}
                if "`cluster'" != "" {
			c_local cluster `"`cluster'"'
                        c_local clopt   `"cluster(`cluster')"'
			local rob "robust"
			`usecom' markout `touse' `cluster', strok
                }
		if "`wtype'" == "pweight" | "`clvar'" != "" {
			local rob "robust"
		}
		if "`robust'`rob'" != "" {
			local rob "robust"
			c_local robust "robust"
		}
		if "`score'" != "" {
			local n : word count `score'
			c_local nscores	`"`n'"'
			local i 1
			while `i' <= `n' {
				local sss : word `i' of `score'
				confirm new var `sss'  
				local i = `i'+1
			}
		}

		if "`ind'" == "" | "`nc1'" != "" { 
			local skip "skip"
		}
		c_local skip `"`skip'"'

		if "`rmcoll'" == "" & "`touse'" != "" {
			noi _rmcoll `ind' if `touse', `nc'
			c_local ind "`r(varlist)'"
		}
	}
end
