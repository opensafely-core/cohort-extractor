*! version 2.1.1  07nov2014
program describe, rclass
	version 9
	local version : di "version " string(_caller()) ":"
	syntax [anything] [using] [, SImple REPLACE *] 

	if ("`replace'"!="") {
		describe_mk `0'
		return add
		exit
	}

	local varlist `"`anything'"'

	if ("`simple'" == "") { /* simple not used */
		`version' _describe `0'
		return add
	}
	else {			/* simple was used */
		if (`"`options'"' != "") {
		  di as err "simple may not be combined with other options"
		  exit 198
		}
		if (`"`using'"' != "") {
			qui `version' describe `varlist' `using', varlist
			if "`varlist'" == "" {
				local vars "`r(varlist)'"
			}
			else {
				local vars "`varlist'"
			}
			local wid = 2	
			local n : list sizeof vars  
			if `n'==0 { 
				exit
			}
	
			if "`c(hasicu)'" == "1" {
				foreach x of local vars {
					local wid = max(`wid', udstrlen(`"`x'"'))
				}
			}
			else {
				foreach x of local vars {
					local wid = max(`wid', strlen(`"`x'"'))
				}
			}


			local wid = `wid' + 2
			local cols = int((`c(linesize)'+1)/`wid')
			if `cols' < 2 { 
				foreach x of local `vars' {
					di as txt `col' `"`x'"'
				}
				exit
			}
			local lines = `n'/`cols'
			local lines = int(cond(`lines'>int(`lines'), `lines'+1, `lines'))
			forvalues i=1(1)`lines' {
				local top = min((`cols')*`lines'+`i', `n')
				local col = 1 
				forvalues j=`i'(`lines')`top' {
					local x : word `j' of `vars'
					di as txt _column(`col') "`x'" _c
					local col = `col' + `wid'
				}
				di as txt 
			}

			qui `version' describe `varlist' `using', short
			return add

		}
		else {
			ds `varlist'
			qui `version' _describe `varlist', short
			return add
		}
	}
end

