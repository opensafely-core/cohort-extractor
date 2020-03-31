*! version 2.1.1  25jun2000
program define _gma
	version 6.0
	syntax newvarname(gen) =/exp [in] [, T(integer 3) noMiss BY(string) ]
	if `"`by'"' != "" {
		_egennoby ma() `"`by'"'
		/* NOTREACHED */
	}


	tempvar GMAE GMAN
	quietly {
		local ht = (`t'-1)/2
		if (`t' < 3  |  int(`ht') != `ht') { 
			di in red "t() must be odd and >= 3"
			exit 198
		}
		gen double `GMAE' = `exp' `in'
		capture assert `GMAE'!=. `in'
		if _rc { 
			di in red "missing values encountered"
			exit 412
		}
		replace `varlist' = `GMAE'
		gen int `GMAN' = 1 `in'
		local i = 1 
		while (`i' <= `ht') { 
			#delimit ;
			replace `varlist' = `varlist' + 
				cond(`GMAE'[_n-`i']==.,0,`GMAE'[_n-`i']) +
				cond(`GMAE'[_n+`i']==.,0,`GMAE'[_n+`i']) `in' ;
			replace `GMAN' = `GMAN' +
				(`GMAE'[_n-`i']!=.) + (`GMAE'[_n+`i']!=.) `in' ;
			#delimit cr
			local i = `i' + 1 
		}
		replace `varlist' = `varlist' / `GMAN' `in'
		if "`miss'"=="" { 
			replace `varlist' = . if `GMAN'!=`t' `in'
		}
	}
end
