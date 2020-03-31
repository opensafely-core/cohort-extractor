*! version 6.7.2  04dec2019
program define stcurve
	version 6
	local vv : di "version " string(_caller()) ", missing:"
	
	if _caller() < 8 {
		stcurve_7 `0'
		exit
	}
	if "`e(cmd2)'" != "streg" & "`e(cmd2)'" != "stcox" & ///
	   "`e(cmd)'" != "stcrreg" & "`e(cmd2)'" != "mestreg" & ///
	   "`e(cmd2)'" != "xtstreg" & "`e(cmd2)'" != "stintreg" {
		error 301
	}

	if "`e(cmd2)'" != "stintreg" {
		st_is 2 analysis
	}

	syntax [, CUMHaz SURvival HAZard CIF AT0(string) AT1(string) /*
		*/ AT2(string) AT3(string) AT4(string) AT5(string) /*
		*/ AT6(string) AT7(string) AT8(string) AT9(string) /*
		*/ AT10(string) LOWer /*UNDOC*/ UPper /*UNDOC*/ /*
		*/ Range(numlist ascending min=2 max=2 ) OUTfile(string) /*
		*/ Kernel(passthru) width(real -1) noBoundary /*
		*/ ALPHA1 FIXEDonly UNCONDitional MARGinal /*
		*/ LEFTBOUNDARY(passthru) USEOLDBASE mmat(passthru) * ]

	opts_exclusive "`uncondi' `margina'"

	_get_gropts , graphopts(`options') getallowed(plot addplot recast)
	local options `"`s(graphopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	if `"`s(recast)'"' != "" {
		local options `"`options' recast(`s(recast)')"'
		CheckRecast, `s(recast)'
		local recast `s(recast)'
	}

	local type "`cumhaz' `survival' `hazard' `cif'"
	if `:word count `type'' > 1 {
		di as err "only one of " _c
	        di as err "`: list uniq type' " _c
                di as err "may be specified"
		exit 198
	}
	if `:word count `type'' == 0 {
		di as err "at least one of " _c
	        di as err "survival, cumhaz, hazard, or cif " _c
                di as err "must be specified"
		exit 198
	}

	if "`e(cmd2)'" == "stcox" | "`e(cmd)'" == "stcrreg" {
		if "`cumhaz'`surviva'`cif'" != "" ///
		 & inlist("`recast'", "", "line", "connected") {
			local step connect(J ...)
		}
	}

	if "`e(cmd2)'" == "stintreg" {
		if "`cif'" != "" {
			di as err "cif is not allowed after " ///
				"stintreg"
			exit 198
		}
		if "`marginal'"!="" {
			di as err "marginal is not allowed after " ///
				"stintreg"
			exit 198
		}
		if "`unconditional'"!="" {
			di as err "unconditional is not allowed " ///
				"after stintreg"
			exit 198
		}
		if "`fixedonly'"!="" {
			di as err "fixedonly is not allowed " ///
				"after stintreg"
			exit 198
		}
		if "`alpha1'"!="" {
			di as err "alpha1 is not allowed " ///
				"after stintreg"
			exit 198
		}
	}

	local mecmd = inlist("`e(cmd2)'","mestreg","xtstreg")
	if `mecmd' { local k_r = `e(k_r)' }
	else local k_r = 0
	local has_fr = (`"`e(fr_title)'"'!="" & "`e(cmd2)'"!="stcox")

	if !`k_r' & "`fixedon'"!="" {
		di as err "`fixedon' allowed only with random effects models"
		exit 198
	}

	if `k_r' {
		if "`alpha1'"!="" {
			di as err "`alpha1' allowed only with parametric " ///
				"frailty models"
			exit 198
		}
		if "`e(cmd2)'"=="mestreg" {
			if "`fixedon'`margina'`uncondi'"=="" {
				di in smcl as txt ///
				"(option {bf:unconditional} assumed)"
			}
		}		
		if "`e(cmd2)'"=="xtstreg" {
if _caller() > 14 {
			if "`fixedon'`margina'`uncondi'"=="" {
				di in smcl as txt ///
				"(option {bf:marginal} assumed)"
				local fixedon unconditional
			}
}
else {
			if "`margina'"!="" {
				di as err "`margina' not allowed after xtstreg"
				exit 198
			}
			if "`uncondi'"!="" {
				di as err "`uncondi' not allowed after xtstreg"
				exit 198
			}
			if "`fixedon'"=="" {
				di in smcl as txt ///
				"(option {bf:fixedonly} assumed)"
				local fixedon fixedonly
			}
}
		}
	}
	else if !`has_fr' {
		if "`alpha1'"!="" {
di as err "`alpha1' allowed only with parametric frailty models"
			exit 198
		}
		if "`uncondi'"!="" {
di as err "`uncondi' allowed only with parametric frailty models"
			exit 198
		}
		if "`margina'"!="" {
di as err "`margina' allowed only with parametric frailty models"
			exit 198
		}
	}
	else {   /* frailty model: tell user what they are getting */
		if "`alpha1'`uncondi'`margina'"=="" {
			if "`e(shared)'"!="" {
				local alpha1 alpha1
				local name alpha1
			}
			else {
				local uncondi unconditional
				if "`margina'"!="" {
					local name marginal
				}
				else {
					local name unconditional
				}
			}
			di as txt "(option `name' assumed)"
		}
		else {
			if "`margina'"!="" {
				local uncondi unconditional
			}
		}
	}
	
	if "`e(cmd)'"=="stcox_fr" {
		di as txt "note: all plots evaluated at frailty equal to one"
	}

	if `"`e(texp)'"' != "" {
		_tvc_notallowed command 1
	}

	if `"`range'"'~="" {
		local ranopt range(`range')
	}
	else {      // rgg wants evenly spaced grids here for streg
		if "`e(cmd2)'"=="streg" {
			qui summ _t if e(sample), meanonly
			local ranopt range(`r(min)' `r(max)')
		}
	}
	if ("`e(cmd)'"== "cox" | "`e(cmd)'" == "stcox_fr") & /// 
	   ("`useoldbase'" == "") { 
		tempvar base
		if "`surviva'"!="" {
			qui predict double `base' if e(sample), basesurv
		}
		if "`hazard'"!="" {
			qui predict double `base' if e(sample), basehc
		}
		if "`cumhaz'"!="" {             /* cumhaz */
			qui predict double `base' if e(sample), basechaz
		}
		// If we eventually allow it
		if "`cif'"!="" {
			qui predict double `base' if e(sample), basec
		}
		local baseopt base(`base')
	}
	if "`e(cmd)'" == "stcrreg" {
		tempvar base
		qui predict double `base' if e(sample), basecsh
		local baseopt base(`base')
	}

	preserve
	qui keep if e(sample)

	if "`e(cmd2)'" == "stintreg" {
		tokenize `e(depvar)'
		local ltime `1'
		local rtime `2'
		qui replace `ltime' = 0 if `ltime' == .
		
		if `"`range'"' == "" {
			if "`upper'" != "" {
				qui summ `rtime' if e(sample), meanonly
				local ranopt range(`r(min)' `r(max)')
			}
			else {
				qui summ `ltime' if e(sample), meanonly
				local ranopt range(`r(min)' `r(max)')
			}
		}
	}

	local type = bsubstr("`cumhaz' `survival' `hazard' `cif'",1,5)
	tempfile tcurve
	tempfile tcurve2
	tempname nt
	if `"`boundary'"'~="" {
		if `"`hazard'"'=="" {
			di as err `"`boundary' allowed only with hazard"'
			exit 198
		}
		else if "`e(cmd2)'" != "stcox" {
			di as err "option `boundary' is only valid after stcox" 
			exit 198
		}
	}
	local bnd `boundary'
	if _caller() < 10 & `"`hazard'"' != "" {
		local bnd noboundary
	}
	if `"`at0'`at1'`at2'`at3'`at4'`at5'`at6'`at7'`at8'`at9'`at10'"' ~= "" {
		local saved 0
		local i 0
		local j 1
		while `i'<=10 {
			if "`at`i''"~="" {
			    `vv' ///
			    _stcurv, `cumhaz' `survival' `hazard' `cif' ///
				`uncondi' `alpha1' ///
				at(`at`i'') `kernel' width(`width') `bnd' ///
				save(`"`tcurve'"') `ranopt' ///
				`leftboundary' `baseopt' `fixedon' `mmat'
				qui use `"`tcurve'"', clear
				tokenize `r(myvars)'
				local prim _`type'`j'
				rename `1' `prim'
				local yvars `"`yvars' `prim'"'
				local tmplbl: variable label `prim'
				label var `prim' "`at`i''"
				rename `2' `nt'
				qui compress
				sort `nt'
				if `saved' {
					tempvar mvar
					qui merge `nt' using `"`tcurve2'"', ///
						_merge(`mvar')
					sort `nt'
					qui save `"`tcurve2'"',replace
				}
				else {
					qui save `"`tcurve2'"',replace
					local saved 1
				}
			restore, preserve
			}
			local ++i
			local ++j
		}
		qui use `"`tcurve2'"', clear
	}
	else {
		`vv' ///
		_stcurv, `cumhaz' `survival' `hazard' `cif' ///
			`uncondi' `alpha1' `kernel' width(`width') `bnd' ///
			save(`"`tcurve'"') `ranopt' `leftboundary' ///
			`baseopt' `fixedon' `mmat'
			qui use `"`tcurve'"', clear
			tokenize `r(myvars)'
			rename `1' _`type'1
			local yvars _`type'1
			rename `2' `nt'
	}
	if `"`r(bb)'"' != "" {
		local ttl title(`"`r(bb)'"')
	}
	if `"`tmplbl'"' != "" {
		local yttl `"ytitle("`tmplbl'")"'
	}
	local xttl "analysis time"
	if `"`plot'`addplot'"' == "" {
		if  0`:word count `yvars'' == 1 {
			local legend legend(nodraw)
		}
	}
	else	local draw nodraw
	
	version 8: graph twoway		///
	(line `yvars' `nt',		///
		sort			///
		`yttl'			///
		xtitle(`"`xttl'"')	///
		`ttl'			///
		`legend'		///
		`draw'			///
		`step'                  ///
		`options'		///
	)				///
	// blank

	if "`outfile'"~="" {
		keep `yvars' `nt'
		order `yvars' `nt'
		label data
		// remove the underscore "_"
		foreach var of local yvars {
			local vn = bsubstr(`"`var'"',2,.)
			rename `var' `vn'
		}
		cap rename `nt' _t
		if "`e(cmd2)'" == "stintreg" {
			if "`upper'" != "" {
				label var _t `rtime'
			}
			else {
				label var _t `ltime'
			} 
		}
		tokenize "`outfile'", parse(",")
		// trim any trailing spaces in the filename
		local 1 `1'
		qui save "`1'" `2' `3'
        }
	if `"`plot'`addplot'"' != "" {
		restore
		version 8: graph addplot `plot' || `addplot' || , norescaling
	}
end

program CheckRecast, sclass
	syntax [, SCatter LIne CONnected * ]
	sreturn local recast `scatter'`line'`connected'`options'
end
exit
