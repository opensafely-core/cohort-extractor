*! version 1.1.3  09feb2015  
program gsort 
	if _caller() >= 12 {
		local vv : di "version " string(_caller()) ":"
	}
        
        tempname myr
       _return hold `myr'

	version 6.0, missing
	parse `"`*'"', parse(" +-,")
	local noryet 1
	local i 1
	while `"`1'"'!="" & `"`1'"'!="," {
		if `"`1'"'=="-" | `"`1'"'=="+" { 
			local sign `"`1'"'
			mac shift 
			if `"`1'"'=="," | `"`1'"'=="" { error 198 }
		}
		else 	local sign "+"
		unabbrev `1'
		if `noryet' & `"`sign'"'=="+" {
			local part1 `"`part1' `s(varlist)'"'
		}
		else {
			local noryet 0
			local sign`i' `"`sign'"'
			local names `"`names' `1'"'
			local i=`i'+1
		}
		mac shift
	}
	if `"`part1'"'=="" & `"`names'"'=="" { 
		di in red "varlist required"
		exit 100
	}
	local options "Generate(string) Mfirst"
	parse `"`*'"'
	if `"`generat'"'!="" { 
		confirm new var `generat'
	}

	parse `"`names'"', parse(" ")
	local i 1
	while `"``i''"'!="" {
		`vv' sort ``i''
		tempvar n
		quietly gen long `n' = .
		quietly by ``i'': replace `n'=1 if _n==1
		quietly replace `n'= 0 `sign`i'' sum(`n')
		if `"`mfirst'"' == "" {
			local typ : type ``i''
			if bsubstr("`typ'",1,3) != "str" {
				if "`sign`i''" == "-" {
					// missing values must sort in
					// descending order
					tempvar nn
					qui gen long `nn' = .
					qui by ``i'': replace `nn' = 1 ///
							if _n==1 & ``i''>=.
					qui sum `nn' if ``i''>=., meanonly
					local nsum = `r(sum)'
					qui replace `nn' = sum(`nn') ///
								if ``i''>=.
					qui replace `n' = `nsum' - `nn' ///
								if ``i''>=.
				}
				else {
					qui replace `n'=``i'' if ``i''>=.
				}
			}
		}
		local tvars `"`tvars' `n'"'
		quietly compress `n'
		local i=`i'+1
	}
	`vv' sort `part1' `tvars'
	if `"`generat'"'!="" {
		tempvar mark 
		qui by `part1' `tvars': gen `c(obs_t)' `mark' = 1 if _n==1
		qui replace `mark' = sum(`mark')
		qui compress `mark'
		`vv' sort `mark'
		rename `mark' `generat'
	}
        

	_return restore `myr'

end
