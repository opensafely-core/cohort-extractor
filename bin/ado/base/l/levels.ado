*! version 1.1.2  14apr2003
program levels, sortpreserve rclass 
        version 8
	syntax varname [if] [in] [, Separate(str) MISSing Local(str) Clean ]
	
        if "`separate'" == "" local sep " " 
	else local sep "`separate'" 

	if "`missing'" != "" local novarlist "novarlist" 
        marksample touse, strok `novarlist' 
	capture confirm numeric variable `varlist'
	local isnum = _rc != 7 
	
        if `isnum' { /* numeric variable */
		capture assert `varlist' == int(`varlist') if `touse' 
		if _rc { 
			di as err "`varlist' contains non-integer values" 
			exit 459
			/* NOT REACHED */ 
		} 
		
                tempname Vals
                qui tab `varlist' if `touse', `missing' matrow(`Vals')
                local nvals = r(r)

                forval i = 1 / `nvals' {
                        local val = `Vals'[`i',1]
			if `i' < `nvals' local vals "`vals'`val'`sep'" 
			else local vals "`vals'`val'" 
                }
        }
	else { /* string variable */
                tempvar select counter
                bysort  `touse' `varlist' : ///
                	gen byte `select' = (_n == 1) * `touse'
                generate `counter' = sum(`select') * (`select' == 1) 
                sort `counter'
		qui count if `counter' == 0 
                local j = 1 + r(N)
		local nvals = _N

		if "`clean'" != "" { 
			forval i = `j' / `nvals' { 
				if `i' < `nvals' { 
					local vals "`vals'`=`varlist'[`i']'`sep'"
				}	
				else local vals "`vals'`=`varlist'[`i']'" 
			}
		}	
		else { 	
			forval i = `j' / `nvals' { 
				if `i' < `nvals' { 
					local vals `"`vals'`"`=`varlist'[`i']'"'`sep'"'
				}	
				else local vals `"`vals'`"`=`varlist'[`i']'"'"' 
			}
		} 	
        }

        di as txt `"`vals'"' 
	return local levels `"`vals'"' 
	if "`local'" != "" { 
		c_local `local' `"`vals'"' 
	} 	
end
