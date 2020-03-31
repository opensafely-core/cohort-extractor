*! version 1.2.0  18jan2015
program define gr_drop
	version 8
	local f0 `0'
	gettoken pattern : 0, parse(" ,")
	local npats = 0
	local potnamelist
	if `"`pattern'"' != "" & `"`pattern'"' != "," {
		local pattern1 `pattern'
		local potnamelist `potnamelist' `pattern1'
		local npats = 1
		gettoken pattern 0 : 0, parse(" ,")
		while `"`pattern'"' != "" & `"`pattern'"' != "," {
			local npats = `npats' + 1
			local pattern`npats' `pattern'
			local potnamelist `potnamelist' `pattern`npats''
			gettoken pattern 0 : 0, parse(" ,")
		}
		if "`pattern'" == "," {
			local 0 , `0'
		}
	}	
	else {
		local pattern1
		local potnamelist 
		local npats = 1
	}


	local alllist _all
	local justall: list alllist == potnamelist 
	capture confirm name `potnamelist'
	local justnames = !_rc
	syntax [, LEAVEinlist noFREE]
	if `"`leaveinlist'`free'"' != "" | `justall' | `justnames' {
		gr_drop_namelist `f0'
		exit
	}
	local grlist 
	forvalues i = 1/`npats' {
		if `"`pattern`i''"' == "_all" {
			qui graph dir, memory
		}
		else if `"`pattern`i''"' == "" {
			di as error ///
				"{p 0 4 2}nothing found where graph name or" 
			di as error " matching pattern expected{p_end}"
			exit 198
		}
		else {
			qui graph dir `pattern`i'', memory
		}
		if "`pattern`i''" == "_all" & ltrim("`r(list)'") == "" {
			exit			
		}
		if `"`pattern`i''"' != ""  & ///
			ltrim("`r(list)'") == "" {
			capture confirm name `pattern`i''
			if !_rc {
				noi di as error "graph `pattern`i'' not found"
				noi di as error "no graphs dropped"
				exit 111
			}
			else {
				di as err ///
					"invalid pattern, no graphs dropped"
				exit 111
			}
		}
		local grlist `grlist' `r(list)'
	}
	local grlist: list uniq grlist
	gr_drop_namelist `grlist'
end


exit
