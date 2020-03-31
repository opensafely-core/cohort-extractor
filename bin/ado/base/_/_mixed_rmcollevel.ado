*! version 1.2.0  13jan2020
program _mixed_rmcollevel
	local vv : di "version " string(_caller()) ":"
	version 9
	gettoken beg      0 : 0
	gettoken end      0 : 0
	gettoken depvar   0 : 0
	gettoken constant 0 : 0
	gettoken isfctrs  0 : 0
	gettoken collin   0 : 0
	gettoken touse    0 : 0

	local pos 0
	local k : word count `constant'
	forval i = 1/`k' {	
		if `:word `i' of `constant'' == 1  {
			local pos `i'
		}
	}
	if `pos' {
		forval i = 1/`k' {
			local cons `cons' `=(`pos'==`i')'
		}
	}
	else {
		local cons `constant'
	}

	local is2 `isfctrs'

	forvalues s = `beg'/`end' {				// each sublevel
		gettoken vlist 0 : 0
		gettoken isfctr isfctrs : isfctrs
		gettoken con cons : cons
		local nocons
		if !`con' {			// no constant in sublevel
			local nocons noconstant
		}
		if `s' == 0 {
			if "`vlist'" != "" {
			    `vv' ///
			    _rmdcoll `depvar' `vlist' if `touse' ,	///
			    	`nocons' `coll'
			    c_local varnames_0 `r(varlist)'	// c_local
			}
			
		}
		else {
			if `isfctr' {
				c_local varnames_`s' `vlist'	// c_local

				local factors `factors' `vlist'
			}
			else {
				fvunab xx : `vlist' , min(0)
				if "`s(fvops)'" == "" {
					if _caller() > 11 {
						local rmopt force
					}
					else {
						local rmopt
					}
				}
				else {
					local rmopt expand
					set fvbase off
				}
				`vv' ///
				_rmcoll `vlist' if `touse' ,	///
					`nocons' `collin' `rmopt'
				DropOmitted `r(varlist)'
				local vl`s' `r(varlist)'
				local continuous `continuous' `r(varlist)'
				c_local varnames_`s' `r(varlist)'
				// just in case only one sublevel
			}
		}
	}

	foreach fulllist in continuous factors {
		local dups : list dups `fulllist'
		if "`dups'" != "" {
di as error "`:list uniq dups' repeated across equations within the same group"
		   exit 198
		}
	}

	if (`beg' >= `end')  exit
	forvalues s = `beg'/`end' {
		gettoken isfctr is2 : is2
		if !`isfctr' {
		    if `s' > 0 {
			c_local varnames_`s' `:list vl`s' & continuous'
			local continuous : list continuous - vl`s'
		    }
		}
	}
end

program DropOmitted, rclass
	version 9
	foreach var of local 0 {
		capture _msparse `var'
		if c(rc) == 0 {
			if r(omit) == 0 {
				local VARLIST `VARLIST' `var'
			}
		}
	}
	return local varlist `"`VARLIST'"'
end

exit
