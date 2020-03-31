*! version 1.0.4  07/17/93  (anachronism)
program define _crc2use /* newvarname [varlist] [weight] [if] [in] */
	version 3.1
	local touse "`1'"
	qui gen byte `touse'=0
	local varlist "req ex"
	local if "opt"
	local in "opt"
	local weight "aweight fweight pweight iweight noprefix"
	quietly { 
		parse "`*'"
		replace `touse'=1 `if' `in'
		if "`weight'"!="" {
			replace `touse'=0 if (`exp')==. | (`exp')==0
			if "`weight'"=="fweight" { 
				capt assert (`exp')==round(`exp',1) if `touse'
				if _rc { error 401 }
			}
			if "`weight'"!="iweight" {
				capt assert (`exp')>=0 if `touse'
				if _rc { 
					di in red "negative weights encountered"
					exit 411
				}
			}
		}
	}
	local count : word count `varlist'
	if (`count'>1) { 
		_crcause `varlist' 
	}
end
