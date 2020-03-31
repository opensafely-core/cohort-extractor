*! version 2.2.1  10jun2013
program define varstable_w, rclass
	version 8.2 
	syntax , [			///
		Amat(name) 		///
		ESTimates(string) 	///
		vec			/// 	undocumented
		arima(string)		///	undocumented, ar or ma
		]

	if "`estimates'" == "" {
		local estimates .
	}

	if "`estimates'" != "." {
		capture confirm name `estimates'
		if _rc > 0 {
			di as err "estimates(`estimates') specifies "	/*
				*/ "an invalid name"
			exit 198
		}
	}

	tempname real complex modulus A temp bigAP pest
	tempvar samp resmat

	_estimates hold `pest', copy restore nullok varname(`samp') 

	capture estimates restore `estimates'
	if _rc > 0 {
		di as err "could not restore estimates(`estimates')"
		exit _rc
	}

	_cknotsvaroi varstable

	if "`vec'`arima'" == "" {
		if "`e(cmd)'" != "var" & "`e(cmd)'" != "svar" {
			di as err "varstable can only be run after " /*
		*/ "{help var##|_new:var} or {help svar##|_new:svar}"
			exit 198
		}
		if "`e(cmd)'" == "svar" {
			local svar _var
		}

		_var_mka `e(endog`svar')', aname(`A')

		local mlag = e(mlag`svar')
		local lm1 = e(mlag`svar') - 1
		local eqs = e(neqs)
		local dim = `eqs'*`mlag'
	}
	else if "`arima'" != "" {
		mata: get_arma()
		local mlag `=`arima'_lags'
		tempname junk
		mat `junk' = ``arima''
		if "`arima'"=="ma" {
			mat `junk' = -`junk'
		}
		local mlag = rowsof(`junk')
		forvalues i = 1/`mlag' {
			mat `A'`i' = `junk'[`i',1]
		}
		local lm1 =  `mlag' - 1
		local eqs = 1
		local dim = `eqs'*`mlag'
	}
	else {
		_ckvec vecstable

		_vecmka `A'

		local mlag = e(n_lags) 
		local lm1 =  `mlag' - 1
		local eqs = e(k_eq)
		local dim = `eqs'*`mlag'
		local rank = e(k_ce)

		local roots = `eqs' -`rank'
		if `roots' > 1 {
			local mod moduli
		}
		else {
			local mod modulus
		}
	}

	_estimates unhold `pest'

	if `mlag' > 1 {
		forvalues i = 1(1)`mlag' {
			capture mat drop `temp'
			forvalues j=1(1)`lm1' {
				if `j' == `i' {
					mat `temp'=( nullmat(`temp') /*
						*/ \ I(`eqs') )
				}
				else {
					mat `temp'=(nullmat(`temp') /*
			 			*/ \ J(`eqs',`eqs',0))
				}
			}			
			mat `bigAP' = (nullmat(`bigAP'), (`A'`i' \ `temp') )
		}
	}
	else {
			mat `bigAP' =  `A'1
	}
	
	local cols = colsof(`bigAP')
	forvalues i =1/`cols' {
		local rnames `rnames' r`i'
		local cnames " `cnames' :c`i'"
		mat rownames `bigAP' = `rnames'
		mat colnames `bigAP' = `cnames'
	}
	
	if "`amat'" != "" {
		mat `amat' = `bigAP'
	}

	mat eigenvalues `real' `complex' = `bigAP'

	mat `modulus' = J(1,`dim',0)

	local inside "yes"
	forvalues i = 1(1)`dim' {
		mat `modulus'[1,`i'] = sqrt( (`real'[1,`i'])^2 + /*
			*/ (`complex'[1,`i'])^2 )
		if `modulus'[1,`i'] >= 1 {
			local inside "no"
		}
	}

	mat `resmat' = `real'', `complex'', `modulus''	

	_matsort `resmat' 3

	mat `real' = `resmat'[1...,1]'
	mat `complex' = `resmat'[1...,2]'
	mat `modulus' = `resmat'[1...,3]'

	DISP , real(`real') complex(`complex') modulus(`modulus')

	ret mat Re `real'
	ret mat Im `complex'
	ret mat Modulus `modulus'
	
	if "`vec'`arima'" == "" {
		if "`inside'" == "yes" {
			di as txt "{col 4}All the eigenvalues lie "	///
				"inside the unit circle."
			di as txt "{col 4}VAR satisfies stability condition."
		}
		else {
			di as txt "{col 4}At least one eigenvalue "	///
				"is at least 1.0."
			di as txt "{col 4}VAR does not satisfy "	///
				"stability condition."
		}
	}
	else if "`arima'" != "" {
		if "`inside'" == "yes" {
			di as txt "{col 4}All the eigenvalues lie "	///
				"inside the unit circle."
			if "`arima'"=="ar" {
				di as txt "{col 4}AR parameters satisfy " ///
					"stability condition."
			}
			else if "`arima'"=="ma" {
				di as txt "{col 4}MA parameters satisfy " ///
					"invertibility condition."
			}
		}
		else {
			di as txt "{col 4}At least one eigenvalue "	///
				"is at least 1.0."
			if "`arima'"=="ar" {
				di as txt "{col 4}AR parameters do not " ///
					"satisfy stability condition."
			}
			else if "`arima'"=="ma" {
				di as txt "{col 4}MA parameters do not " ///
					"satisfy invertibility condition."
			}
		}
	}
	else {
		if `roots' > 1 {
			local r_txt = `roots'
		}
		else {
			local r_txt  "a"
		}
		ret scalar unitmod = `roots'
		di as txt "{col 4}The VECM specification imposes "	///
			as txt "`r_txt'" as txt " unit `mod'."
	}
end

program define CKmat

	syntax name(name=mname)

	capture confirm matrix `mname'
	if _rc > 0 {
		di as err "results matrix not found"
		exit 498
	}

end

program define DISP
	
	syntax , real(name) complex(name) modulus(name) 

	foreach mname in real complex modulus {
		CKmat ``mname''
	}

	tempname table1 table2
	.`table1' = ._tab.new, col(2) 
	.`table1'.width |26|13| 

	.`table2' = ._tab.new, col(3)
	.`table2'.width |12 14|13|
	
	.`table2'.strcolor . yellow .
	.`table2'.numcolor  yellow  . yellow 
	.`table2'.numfmt %10.7g .  %8.7g
	.`table2'.pad 1 . 2

	di _n as text "{col 4}Eigenvalue stability condition"
	.`table1'.sep, top
	.`table1'.titles	"Eigenvalue       "	/// 1
				"Modulus  "	
	.`table1'.sep, mid
	
	local dim = colsof(`complex')

	forvalues i=1(1)`dim' {
		if reldif(`complex'[1,`i'] , 0) > 1e-10 {
			if  `complex'[1,`i'] < 0 {
local c_el : display "-" %10.7g  -1*`complex'[1,`i'] "{it:i}"  
			}
			else {
local c_el : display "+" %10.7g  `complex'[1,`i'] "{it:i}"  
			}	
			.`table2'.row	`real'[1,`i']	///
					"`c_el'"	///
					`modulus'[1,`i']
		}
		else {
			.`table2'.row	`real'[1,`i']	///
					""		///
					`modulus'[1,`i']
		}
	}	
	.`table1'.sep, bot
	
end				

exit
