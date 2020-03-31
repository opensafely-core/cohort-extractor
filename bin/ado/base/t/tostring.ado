*! version 3.0.0  01aug2003
* NJC 2.0.1 25 July 2003
* NJC 2.0.0 27 June 2003
* NJC 1.2.3 1 August 2000
* NJC and JBW 1.2.2 30 March 2000  (STB-57: dm80.1)
* NJC 1.0.0 2 November 1999
program tostring
	version 8.0
	syntax varlist, [Generate(string) replace] [force] /// 
	[format(str) Usedisplayformat] 
			
	// perform user error checks 

	if "`generate'" != "" & "`replace'" != "" {
		di as err "{p}options generate and replace are mutually exclusive{p_end}"
		exit 198
	}

	if "`generate'" == "" & "`replace'" == "" {
		di as err "{p}must specify either generate or replace option{p_end}"
		exit 198
	}

	if "`generate'" != "" {
		local ct1: word count `varlist'
		local save "`varlist'" 
		local 0 "`generate'" 
		capture syntax newvarlist 
		if _rc { 
			di as err "generate(newvarlist) invalid" 
			exit _rc 
		}
		local generate "`varlist'" 
		local varlist "`save'" 
		local ct2: word count `generate'
		if `ct1' != `ct2' {
			di as err "{p}number of variables in varlist " ///
			"must equal number of variables in generate(newvarlist){p_end}"
			exit 198
		}
	}

	if "`usedisplayformat'" != "" & "`format'" != "" {
		di as err /// 
	"{p}must choose between usedisplayformat and format() options{p_end}"
		exit 198
	}

	if "`format'" != "" { 
		if index("`format'", "s") { 
			di as err "use numeric format in format() option" 
			exit 198 
		} 	
		capture di `format' 12345.67890
		if _rc {
			di as err "format() option invalid"
			exit 198
		}
		local fmt "`format'"
		local format `", "`format'""'
	}
	else { 
		local fmt "%12.0g" 
		local format `", "%12.0g""' 
	}	

	local u = "`usedisplayformat'" != "" 

	// cycle through varlist   
	
	if "`generate'" != "" {
		tokenize `generate'
		local i = 0 
		foreach v of local varlist { 
			local ++i 
			capture confirm string variable `v'
			if _rc == 0 {
				di as txt "`v' already string; no " ///
					as res "generate"
			}
			else {
	      			if `u' {
					local fmt "`: format `v''" 
					local format `", "`: format `v''""'
				}

				tempvar temp
				qui gen str `temp' = string(`v'`format')
				qui count if `v' != real(`temp') 
				local flag = r(N) 
				if `flag' & "`force'" == "" {
					di as txt "`v' cannot be converted " ///
					"reversibly; no " as res "generate"
				}
				else { 
					gen ``i'' = `temp' 
			di as txt "``i'' generated as {res:`: type ``i'''}"
					_crcslbl ``i'' `v'
					move ``i'' `v'
					move `v' ``i''
					Charcopy `v' ``i''
					if `flag' & "`force'" != "" {
						di as txt ///
		       "``i'' was forced to string; some loss of information" 
       						char ``i''[tostring] ///
					"forced to string; `fmt'"
					}
					else char ``i''[tostring] ///
					"converted to string" 
				}
				drop `temp'
			}
		}
	}
	else if "`replace'" != "" {
		foreach v of local varlist {
			capture confirm string variable `v'
			if _rc == 0 {
				di as txt "`v' already string; no " ///
					as res "replace"
			}
			else if `"`: value label `v''"' != "" & "`force'" == "" {
				di as txt "`v' has value label; no " ///
				as res "replace"
			} 
			else {
				if `u' { 
					local fmt "`: format `v''"
				        local format `", "`: format `v''""'
			       	}
				
				tempvar temp
				qui gen str `temp' = string(`v'`format')
				qui count if `v' != real(`temp') 
				local flag = r(N)
				if `flag' & "`force'" == "" {
					di as txt "`v' cannot be converted " ///
					"reversibly; no " as res "replace"
				}
				else {
					local oldtype : type `v' 
					char rename `v' `temp'
					move `temp' `v'
					local vl: variable label `v'
					drop `v'
					rename `temp' `v' 
					label variable `v' `"`vl'"'
		di as txt "`v' was {res:`oldtype'} now {res:`: type `v''}"
					if `flag' & "`force'" != "" {
						di as txt ///
			"`v' was forced to string; some loss of information" 
       						char `v'[tostring] ///
						"forced to string; `fmt'"
					}
					else char `v'[tostring] ///
					"converted to string" 
				}
			}
		}
	}
end

program Charcopy 
	syntax varlist(min=2 max=2) 
	tokenize `varlist' 
	args from to 

	local chfrom : char `from'[] 
	if "`chfrom'" == "" { 
		exit
	}
	
	tokenize `chfrom'
	while "`1'" != "" {
		local fchar : char `from'[`1']
		char `to'[`1'] `"`fchar'"'
		mac shift
	}
end
