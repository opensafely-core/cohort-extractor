*! version 1.0.2  21apr2015
program define gr_replay_mult, rclass
	gettoken pattern : 0, parse(" ,")
	local npats = 0
	if `"`pattern'"' != "" & `"`pattern'"' != "," {
		local pattern1 `pattern'
		local npats = 1
		gettoken pattern 0 : 0, parse(" ,")
		while `"`pattern'"' != "" & `"`pattern'"' != "," {
			local npats = `npats' + 1
			local pattern`npats' `pattern'
			gettoken pattern 0 : 0, parse(" ,")
		}
		if "`pattern'" == "," {
			local 0 , `0'
		}
	}	
	else {
		local pattern1
		local npats = 1
	}
	syntax [, sleep(string) wait noCLOSE]
	if "`sleep'" != "" {
		capture confirm number `sleep'
		local rc = _rc
		if !`rc' {
			capture assert `sleep' >= 0
			local rc = _rc | `rc'
		}
		if `rc' {
			di as err ///
	"{p}option {bf:sleep()} must contain a nonnegative integer{p_end}"
			exit 198
		}
	}
	if "`sleep'" != "" & "`wait'" != "" {
		opts_exclusive "sleep wait()"
	}
	if "`wait'" == "" & "`sleep'" == "" {
		local sleep 3
	}
	local omore `c(more)'
	local grlist
	local plist 
	forvalues i = 1/`npats' {
		if `"`pattern`i''"' == "_all" | "`pattern`i''" == "" {
			qui graph dir, memory
		}
		else {
			qui graph dir `pattern`i''
			local there: list plist & pattern`i'
			local there = "`there'" != ""
			if ltrim("`r(list)'") == "" & !`there' {
				capture confirm name `pattern`i''
				if !_rc {
					noi di as error ///
						"graph `pattern`i'' not found"
				}
				else if bsubstr(`"`pattern`i''"',-4,.) ///
					== ".gph" {
					noi di as error ///
						"file `pattern`i'' not found"
				}
				else {
					noi di as error ///
						"pattern `pattern`i'' "	///
						"is invalid"
				}
			}
			local plist `plist' `pattern`i''
		}
		local grlist `grlist' `r(list)'
	}
	local grlist: list uniq grlist

	if "`wait'" != "" {
		local waitcmd more
	}
	else {
		local sleeptime = `sleep'*1000
		local waitcmd sleep `sleeptime'
	}
	local grcount: word count `grlist'
	local i = 1
	capture noisily break {
	if "`wait'" != "" {
		set more on
	}
	foreach graph of local grlist {
		local subcmd display
		if bsubstr("`graph'",-4,4) == ".gph" {
			local subcmd use 
		}
		graph `subcmd' `graph'
		if `i' != `grcount' {
			`waitcmd'
		}
		if "`close'" != "noclose" & "`subcmd'" == "use" {
			qui graph describe `graph'
			local cmdtime `r(command_time)'
			local cmddate `r(command_date)'
			local cmd `r(command)'
			// match timestamp to any
			qui graph dir *, memory
			local complist `r(list)'
			local match 0
			foreach comp of local complist {
				qui graph describe `comp'
				local ccmdtime `r(command_time)'
				local ccmddate `r(command_date)'
				local ccmd `r(command)'
				if ("`cmdtime'" == "`ccmdtime'")  & ///
					("`cmddate'" == "`ccmddate'") &	///
					(`"`ccmd'"' == `"`cmd'"') {
					local match 1
					local graph `comp'
					continue, break
				}						
			}
			if !`match' {
				local graph = bsubstr("`graph'",1,	///
					length("`graph'")-4)			
			}
			if `i' != `grcount' {
				graph close `graph'
			}
		}
		else if "`close'" != "noclose" & `i' != `grcount' {
			graph close `graph'		
		}
		local i = `i' + 1	
	}
	}
	local rc = _rc
	set more `omore'
	if `rc' {
		exit `rc'
	}
	return local list `grlist'
end	
