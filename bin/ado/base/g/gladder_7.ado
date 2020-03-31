*! version 3.3.3  16feb2015 
program define gladder_7
	version 6, missing
	syntax varname(numeric) [if] [in] [, Bin(int -1) * ]
	marksample touse

	qui count if `touse'
	if r(N)<3 { 
		error 2001
	}

	local v `varlist'
	        qui count if `touse' & (`v') < 0
        local r1 = r(N)
        qui count if `touse' & (`v') == 0
        local r2 = r(N)

        local type 3
        if `r1'>0 & `r2'==0  {
                local type 2            /* negative only */
        }
        if `r1'==0 & `r2'>0 {
                local type 1            /* zero only */
        }
        if `r1'==0 & `r2'==0 {
                local type 0            /* all positive */
        }

	tempfile base 
	preserve
	quietly {
		keep if `touse'
		keep `v' 
		gen float _temp = `v' 
		local vrl : variable label `v'
		drop `v'
		rename _temp `v' 
		label var `v' `"`vrl'"'
		sort `v' 
		by `v': gen `c(obs_t)' _wgt = _N
		by `v': keep if _n==_N
		if `bin'<1 { 
			local bin = max( /*
				*/ int(min(sqrt(_N),10*log(_N)/log(10))+.5),/*
				*/ 2) 
		}
		save `"`base'"', replace

		tempfile f1 f2 f3	
		_crcgldr `"`base'"' "`f1'" 1 `v' "`v'^3"  
		_crcgldr `"`base'"' "`f2'" 2 `v' "`v'^2"  
		_crcgldr `"`base'"' "`f3'" 3 `v' "`v'"  

		use `"`f1'"', clear 
		append using `"`f2'"'
		append using `"`f3'"'
		save `"`f1'"', replace
		
		if (`type' == 1) | ( `type' == 0) {
			tempfile f4
			_crcgldr `"`base'"' "`f4'" 4 `v' "sqrt(`v')" 
			use `"`f1'"', clear
			append using `"`f4'"'
			save `"`f1'"', replace
		}
		
		if `type' == 0 {
			tempfile f5 f6
			_crcgldr `"`base'"' "`f5'" 5 `v' "log(`v')" 
			_crcgldr `"`base'"' "`f6'" 6 `v' "-1/sqrt(`v')"
			use `"`f1'"', clear
			append using `"`f5'"'
			append using `"`f6'"'
			save `"`f1'"', replace
		}


		if (`type'== 0) | (`type' == 2 ) {
			tempfile f7 f8 f9
			_crcgldr `"`base'"' "`f7'" 7 `v' "-1/`v'"
			_crcgldr `"`base'"' "`f8'" 8 `v' "-1/(`v'^2)" 
			_crcgldr `"`base'"' "`f9'" 9 `v' "-1/(`v'^3)"
			use `"`f1'"', clear
			append using `"`f7'"'
			append using `"`f8'"'
			append using `"`f9'"'
			save `"`f1'"', replace
		}
	
		capture label drop _group
		label define _group 1 cube 2 square 3 identity 4 sqrt /*
		*/	5 log 6 "1/sqrt" 7 "inverse" /*
		*/	8 "1/square" 9 "1/cube"
		label values _group _group
		label var _group "Transformation"
		sort _group
	}
	gr7 `v' [fw=_wgt], by(_group) rescale normal bin(`bin') `options'
end

program define _crcgldr 
	use `"`1'"', clear
	replace `4' = `5'
	gen byte _group = `3'
	save `"`2'"', replace
end
