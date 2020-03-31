*! version 2.0.5  13jul2004
program define tabi, rclass
	version 6.0
	parse "`*'", parse(",\ ")

	local r 1 
	local c 1
	local cols .
	while (`"`1'"'!="" & `"`1'"'!=",") { 
		if `"`1'"'=="\" {
			local r = `r' + 1
			if `cols'==. { 
				if (`c'<=2) { 
					di in red "too few columns"
					exit 198
				}
				local cols `c'
			}
			else {
				if (`c'!=`cols') { error 198 }
			}
			local c 1
		}
		else {
			conf integer num `1'
			if `1'<0 { error 411 } 
			local n`r'_`c' `1'
			local c = `c' + 1
		}
		mac shift
	}
	if (`c'!=`cols') { error 198 } 
	local cols = `cols' - 1
	local rows = `r' 
			
	local options "REPLACE *"
	parse `"`*'"'
	if `"`options'"'=="" { 
		if `rows'==2 & `cols'==2 { local options "exact" }
		else local options "chi2"
	}
	if `"`replace'"'=="" & _N!=0 { 
		preserve
	}
	capture {
		drop _all
		local obs 1 
		set obs 1 
		gen byte row = . 
		gen byte col = . 
		gen long pop = . 
		local r 1 
		while (`r'<=`rows') { 
			local c 1
			while (`c'<=`cols') { 
				set obs `obs'
				replace row = `r' in l 
				replace col = `c' in l 
				replace pop = `n`r'_`c'' in l 
				local obs = `obs' + 1
				local c = `c' + 1 
			}
			local r = `r' + 1
		}
		noisily tabulate row col [fw=pop], `options'
		ret add   /* inherits -tabulate- return values  */
	}
	if _rc { 
		drop _all
		exit _rc
	}
end
