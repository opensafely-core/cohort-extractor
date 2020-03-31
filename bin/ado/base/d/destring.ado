*! version 2.4.4  15sep2016
program define destring
	version 14

	local cmdargs = `"`0'"'
	
	local verpre : display "version " %4.1f _caller() ":"

	syntax [varlist], [Generate(string) replace] [force] [float] ///
	  [Ignore(string asis)] [percent] [dpcomma]

	if _caller() >= 14 {
		if ustrpos(`"`ignore'"',",") & ///
		  !ustrpos(`"`ignore'"',`"""')  { // " required if , used
			display as error `"ignore string must be enclosed with quotes to ignore commas or use options"'
			exit 198
		}
	}

	** parsing to capture bad usage under version control
	`verpre' _parse_ignore `ignore'
	** now parsing older versions the way older destrings parsed
	if _caller() < 14 {
		local aschars 0
		syntax [varlist], [Generate(string) replace] [force] [float] ///
		  [Ignore(string)] [percent] [dpcomma]
	}
	else {
		if `"`s(ignore)'"'!="" {
			local ignore `"`s(ignore)'"'
		}
		local aschars `s(aschars)'
		if `s(illegal)' {
			local illegal = ustrunescape("\ufffd")
		}
	}
	
	if "`percent'" == "percent" {
		if !ustrpos(`"`ignore'"', "%") {
			local ignore `"`ignore'%"'
		}
	}
	
	// for illegal chars
	if "`illegal'"!="" {
		local ignore `"`ignore'`illegal'"'
	}

	if `"`float'"'!="" {
		local gtype "float"
	}
	else {
		local gtype "double"
	}

	/* Perform user error checks */

	if "`generate'" != "" & "`replace'" != "" {
		di as err "options generate and replace are mutually exclusive"
		exit 198
	}

	if "`generate'" == "" & "`replace'" == "" {
		di as err "must specify either generate or replace option"
		exit 198
	}

	if "`generate'" != "" {
		local ct1: word count `varlist'
		local save "`varlist'" 
		local 0 "`generate'" 
		capture syntax newvarlist 
		if _rc { 
			di as err "generate() contains existing variable(s) and/or illegal variable name(s)" 
			exit _rc 
		}	
		local generate "`varlist'" 
		local varlist "`save'" 
		local ct2: word count `generate'
		if `ct1' != `ct2' {
			di as err "number of variables in varlist must equal" 
			di as err "number of variables in generate(newvarlist)"
			exit 198
		}
	}


	/* Place each character from ignore in its own macro */
	/* named char1 char2 char3... */

	local m 1
	if `"`ignore'"' == "" {
		local ignore ""
	}
	if `aschars' {
		local l = ustrlen(`"`ignore'"')
	}
	else {
		local l = length(`"`ignore'"')
	}
	while `m' <= `l' {
		if `aschars' {
			local char`m' = usubstr(`"`ignore'"', `m', 1)
		}
		else {
			local char`m' = substr(`"`ignore'"', `m', 1)
		}
*		if usubstr(`"`ignore'"', `m', 1) == " " {
*			local char`m' " "
*		}
		local m = `m' + 1
	}

	/* set up some printing specs */
	if `aschars' {
		local aswhat "character"
	}
	else {
		local aswhat "byte"
	}
	if "`generate'"!="" {
		local genrep "generate"
	}
	else {
		local genrep "replace"
	}

	/* Cycle through varlist creating tempvar for each variable and */
	/* remove characters */

	local tvars OLDVAR NEWVAR ismissing found topct
	tempvar `tvars'

	local varno 0
	foreach var of varlist `varlist' {
		local varno = `varno' + 1
		// for output related to -generate- vs. -replace-
		if "`generate'"!="" {
			local finalvarname : word `varno' of `generate'
			local finalprint "`finalvarname' "
		}
		else {
			local finalvarname "`var'"
			local finalprint ""
		}
      
		capture confirm string variable `var'
		if _rc != 0 {
			di as txt "`var' already numeric; no " ///
			  as res "`genrep'"
		}
		else {
			* wrr: 18jul2016: removed double removals
			qui gen `OLDVAR' = `var'
			local jj 1
			local b
			local bcnt = 0
			local c
			local makepct
			while `"`char`jj''"' != "" {
				capture drop `found'
				capture drop `topct'
				local t `"`char`jj''"'
				if `aschars' {
					qui gen byte `found' = ///
					    ustrpos(`OLDVAR', `"`t'"') != 0
				}
				else {
					qui gen byte `found' = ///
					    strpos(`OLDVAR', `"`t'"') != 0
				}
				qui summarize `found', meanonly
				if r(sum) > 0 {
					if `"`t'"'=="`illegal'" {
						local b `"`b' illegal Unicode"'
					}
					else if `"`t'"' == " " {
						local b `"`b' space"'
					}
					else {
						local b `"`b' `t'"'
					}
					local ++bcnt
				}
				if `aschars' {
					if `"`t'"'=="%" {
						if "`percent'"!="" {
							if `"`makepct'"'=="" {
							  qui count if ///
							   ustrpos(`OLDVAR', ///
								    `"`t'"')
							  local makepct = r(N)
							}
						}
					}
					qui replace `OLDVAR' = ///
					usubinstr(`OLDVAR', `"`t'"', "", .)
				}
				else {
					if `"`t'"'=="%" {
						if "`percent'"!="" {
							if `"`makepct'"'=="" {
							  qui count if ///
							    strpos(`OLDVAR', ///
								   `"`t'"')
							  local makepct = r(N)
							}
						}
					}
					qui replace `OLDVAR' = ///
					subinstr(`OLDVAR', `"`t'"', "", .)
				}
				local jj = `jj' + 1
			} // done looping over -ignore()-
			// stripping whitespace should always be done by chars
			//   but... need version control here
			if _caller() >= 14 {
				qui replace `OLDVAR' = ustrtrim(`OLDVAR')
			}
			else {
				qui replace `OLDVAR' = strtrim(`OLDVAR')
			}
			// need to mark missing values
			quietly gen byte `ismissing' = `OLDVAR'=="" | ///
			    `OLDVAR'=="." | ///
			    (strlen(`OLDVAR')==2 & inrange(`OLDVAR',".a",".z"))
			if ("`dpcomma'" != "") {
				// replace . by X when not a missing value, so
				//  that things like 1.25 are missing when
				//  using -dpcomma-
				qui replace `OLDVAR' = ///
				      subinstr(`OLDVAR',".","X",.) ///
				      if !`ismissing'
				qui replace `OLDVAR' = ///
				      subinstr(`OLDVAR', ",", ".", 1) ///
				      if !ustrregexm(`OLDVAR',"(,[a-z])|(^,$)")
			}
			// last pass to turn many leading zeros into 1
			if _caller() >= 14 {
				qui replace `OLDVAR' = ///
					ustrregexrf(`OLDVAR',"^0+","0")
			}
			else {
				qui replace `OLDVAR' = ///
					regexr(`OLDVAR',"^0+","0")
			}
			qui gen `gtype' `NEWVAR' = real(`OLDVAR')
			qui summarize `ismissing', meanonly
			local oldmiss = r(sum)
			qui count if missing(`NEWVAR')
			local newmiss = r(N)
			local flag = `oldmiss'!=`newmiss'

			if `flag' & ("`force'" == "") {
				if `"`ignore'"' != "" {
					di as txt "`var': contains " ///
					  "`aswhat's not specified in " ///
					  as res "ignore()" ///
					  as txt "; no " as res "`genrep'"
				}
				else {
					di as txt "`var': contains " ///
					  "nonnumeric `aswhat's; no " ///
					  as res "`genrep'"
				}
			}
			else { // !`flag' | "`force'"=="force"
				order `NEWVAR', after(`var')
				if `aschars' {
					local dispb `"`b'"'
				}
				else {
					local dispb = printablebytes(`"`b'"')
				}
				local c = ///
				    plural(`bcnt',strproper("`aswhat'")) + ///
				    " removed " + ///
				    plural(`bcnt',"was","were") + `":`dispb'"'
				if "`makepct'" != "" {
					if `makepct' {
						qui replace `NEWVAR' = ///
							`NEWVAR'/100
					}
				}
				qui compress `NEWVAR'
				local type : type `NEWVAR'

				if `flag' {
					di as txt ///
				    "`var': contains nonnumeric `aswhat's" ///
				    _continue
					if `"`ignore'"'!="" {
						display " not specified in " ///
						  as result "ignore()" _continue
					}
					if `"`b'"'=="" {
						display "; `finalprint'" ///
						  as res "`genrep'd " ///
						  as txt "as " ///
						  as res "`type'" _continue
					}
					display
				}
				if `"`b'"' != "" {
					di as txt "`var': " ///
					  plural(`bcnt',"`aswhat'") ///
					  as res `"`dispb'"' ///
					  as txt " removed; `finalprint'" ///
					  as res "`genrep'd " as txt "as " ///
					  as res "`type'"
				}
				else if `"`b'"' == "" & !`flag' {
					di as txt ///
					  "`var': all characters numeric; " ///
					  "`finalprint'" ///
					  as res "`genrep'd " ///
					  as txt "as " as res "`type'"
				}

				if `newmiss' != 0 {
					di as txt "(`newmiss' missing " ///
					plural(`newmiss',"value") " generated)"
				}
				label variable `NEWVAR' ///
					`"`: variable label `var''"'
				char `NEWVAR'[destring] `c'
				char `NEWVAR'[destring_cmd] ///
					`"destring `cmdargs'"'
				char `var'[destring]
				char `var'[destring_cmd]
				if "`genrep'"=="generate" {
					Charcopy `var' `NEWVAR'
					rename `NEWVAR' ///
						`: word `varno' of `generate''
				}
				else {
					char rename `var' `NEWVAR'
					drop `var'
					rename `NEWVAR' `var'
				}
			} // end check for successful destring
			foreach varmac of local tvars {
				capture drop ``varmac''
			}
		}
	}

end


program def Charcopy 
	syntax varlist(min=2 max=2) 
	tokenize `varlist' 
	args from to 

	local chfrom : char `from'[] 
	if "`chfrom'" == "" { 
		exit
	}
	
	foreach char of local chfrom {
		local fchar : char `from'[`char']
		char `to'[`char'] `"`fchar'"'
	}
end
