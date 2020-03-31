*! version 6.1.3  29may2007
program define stcurve_7
	version 6
	if "`e(cmd2)'" != "streg" & "`e(cmd2)'"!= "stcox"{ 
		error 301
	}
	 syntax [, CUMHaz SURvival HAZard AT1(string) AT2(string) /*
		*/ AT3(string) AT4(string) AT5(string) AT6(string) /*
                */ AT7(string) AT8(string) AT9(string) AT10(string) /*
		*/ TItle(string) B1title(string) B2title(string) /*
		*/ Range(numlist ascending min=2 max=2 ) OUTfile(string) /*
		*/ ALPHA1 UNCONDitional * ]

	if `"`e(fr_title)'"'=="" {
		if "`alpha1'"!="" {
			di as err "`alpha1' allowed only with frailty models"
			exit 198
		}
		if "`uncondi'"!="" {
			di as err "`uncondi' allowed only with frailty models"
			exit 198
		}
	}
	else {   /* frailty model: tell user what they are getting */
		if "`alpha1'`uncondi'"=="" {
			if "`e(shared)'"!="" {
				local alpha1 alpha1
			}
			else {
				local uncondi unconditional
			}
			di as txt "(option `alpha1'`uncondi' assumed)"
		}
	}

	if `"`range'"'~="" {
		local ranopt="range(`range')"
	}
	preserve
	qui keep if e(sample)
	local type = substr("`cumhaz' `survival' `hazard'",1,5)
	tempfile tcurve
	tempfile tcurve2
	tempname nt
	if `"`at1'`at2'`at3'`at4'`at5'`at6'`at7'`at8'`at9'`at10'"' ~= "" {
		local saved 0
		local i 1
		while `i'<=10 {
			if "`at`i''"~="" {
			    _stcurv, `cumhaz' `survival' `hazard' /*
				*/ `uncondi' `alpha1' /*
				*/ at(`at`i'') /*
				*/ save(`"`tcurve'"') `ranopt'
				qui use `"`tcurve'"', clear
				tokenize `r(myvars)'
				local prim _`type'`i'
				rename `1' `prim'
				local yvars `"`yvars' `prim'"'
				local tmplbl: variable label `prim'
				label var `prim' "`at`i''"
				rename `2' `nt'
				qui compress
				sort `nt'
				if `saved' {
					qui merge `nt' using `"`tcurve2'"'
					drop _merge
					sort `nt'
					qui save `"`tcurve2'"',replace
				}
				else {
					qui save `"`tcurve2'"',replace
					local saved 1
				}
			restore, preserve
			}
			local i=`i'+1
		}
		qui use `"`tcurve2'"', clear
	}
	else {
		_stcurv, `cumhaz' `survival' `hazard'  /*
			*/ `uncondi' `alpha1' /*
			*/ save(`"`tcurve'"') `ranopt'
			qui use `"`tcurve'"', clear
			tokenize `r(myvars)'
			rename `1' _`type'1
			local yvars _`type'1
			rename `2' `nt'
	}
	local bb=r(bb)
	local l2="`r(l2opt)'"
	if `"`l2'"'=="" & "`tmplbl'"~="" {	
		local l2="l2(`tmplbl')"
	}
	if "`l2title'"=="" & `"`l2'"'~="" {
		local l2opt=`"`l2'"'
	}
	else {
		local l2opt=`"`l2title'"'
	}
	if `"`title'"' != "" {
		local bb `"`title'"'
	}
	if "`b2title'"=="" {
		local b2title "analysis time"
	}
	if "`b1title'"=="" {
		local b1title `"`bb'"'
	}
	gr7 `yvars' `nt', b1(`b1title') b2(`b2title') `l2opt' `options' sort
	if "`outfile'"~="" {
		keep `yvars' `nt'
		order `yvars' `nt'
		// remove the underscore "_"
		foreach var of local yvars {
			local vn = substr(`"`var'"',2,.)
			rename `var' `vn'
		}
		cap rename `nt' _t
		tokenize "`outfile'", parse(",")
		qui save "`1'" `2' `3'
        }
end	
exit
