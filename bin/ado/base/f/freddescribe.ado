*! version 1.0.0  24aug2016
program define freddescribe
	version 15
	
	gettoken serlist rest : 0, parse(",")
	
	syntax [anything], [REALtime(string) DETail]
		
	if `"`anything'"' == "" {
		di as err "invalid syntax"
		di as err "{p 4 4 2}series id must be specified{p_end}"
		exit 198
	}
	
	local _uniqseries : list uniq anything
	
	local rstart
	local rend
	check_fdate rstart rend : 1 `"`realtime'"'

	javacall com.stata.plugins.fred.Fred2Stata getSeries, 		///
		args(`"`rstart'"' `"`rend'"' `"`detail'"') 		///
		jars(libstata-plugin.jar)		
end

program define check_fdate
	args fstart fend colon ftype fdate 
	
	local startdate
	local enddate
	if `"`fdate'"' != "" {
		local 0 `"`fdate'"'
		gettoken startdate 0 : 0
		if `"`0'"' == "" {
			if `ftype'==1 {
				di as err "option {bf:realtime()} "	///
					"incorrectly specified"
				di as err "{p 4 4 2}an end date must"	///
					" be specified; specify either" ///
					" . or an end date {p_end}"
				exit 198
			}
			else {
				di as err "option {bf:daterange()} "	///
					"incorrectly specified"
				di as err "{p 4 4 2}an end date must"	///
					" be specified; specify either" ///
					" . or an end date {p_end}"
				exit 198
			}
		}
		
		local enddate = strtrim(`"`0'"')
		if `"`startdate'"' != "." {
			if `"`enddate'"' == "." {
				local enddate ""
			}
		}
		else {
			if `"`enddate'"' == "." {
				if `ftype'==1 {
					di as err "option {bf:realtime()} "	///
						"incorrectly specified"
					di as err "{p 4 4 2}at least one of "	///
						"the start or end date must"	///
						" be specified{p_end}"
					exit 198
				}
				else {
					di as err "option {bf:daterange()} "	///
						"incorrectly specified"
					di as err "{p 4 4 2}at least one of "	///
						"the start or end date must"	///
						" be specified{p_end}"
					exit 198
				}
			}
			local startdate ""
		}
	}

	c_local `fstart' `"`startdate'"'
	c_local `fend' `"`enddate'"'
end
