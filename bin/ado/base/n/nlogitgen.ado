*! version 7.2.0  26mar2018
program define nlogitgen
	version 7.0
						/* parse */
	gettoken newvar 0 : 0, parse("= ")
	confirm new var `newvar'
	gettoken equal 0 : 0, parse("= ")
	IsToken = `equal'		
	gettoken varname 0 : 0, parse(" (") match (par)
	cap confirm numeric var `varname'
	if _rc { 
		local isnum = 0
	}
	else {
		local isnum = 1
	}

	local labname = usubstr("lb_`newvar'", 1, 32)
	cap label list `labname'
	if _rc == 0 {
		dis as err "{p}label `labname' already exists; use " /*
		 */ "{help label drop} to free the label name for use " /* 
		 */ "or use a variable name other than `newvar'{p_end}"
		exit 110
	}
	gettoken clist 0: 0, match(par) parse(", ")
	IsToken ( `par'
 	local k 0 	
	gettoken first clist : clist, parse(",")
	while "`first'" != "" {
		local k = `k' + 1
		local first : subinstr local first "|" " ", all
		local group`k' `first'
		gettoken comma clist : clist, parse(",")
		gettoken first clist : clist, parse(",")
	}
	if `k' < 2 {
                dis as err "two or more branches are required"
                exit 198
        }
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	syntax [, NOLOg LOg]
	if "`log'" != "" { local log qui }
						/* END parsing */
						/* BEGIN generate newvar */
	tempvar tempnew
	qui gen int `tempnew' = .
	local label
	forvalue i = 1/`k' {
		gettoken labnew rest : group`i', parse(":")
						/* define label
						   default `varname'`i' */
		if "`rest'" == "" {	
			local templab = usubstr("`newvar'", 1, 30)
			local rest `labnew'
			local label `label' `i' `templab'`i'
		}
		else  {
			local label `label' `i' `labnew'
			gettoken colon rest : rest, parse(":")
		}
		local lab : value label `varname'
		foreach x of local rest {
                        cap confirm number `x'
                        if _rc {
				if `isnum' {
	                                local y : dis ("`x'":`lab')
				}
				else local y `""`x'""'
                        }
                        else local y `x'
                        qui count if `varname' == `y'
                        if r(N) == 0 {
                                dis as err "no observations for `varname' " /*
				 */ "== `x'"
                                exit 198
                        }
                        qui replace `tempnew' = `i' if `varname' == `y'
                }
	}
	qui gen int `newvar' = `tempnew'
	`log' dis as txt "new variable `newvar' is generated with `k' groups"
	label define `labname' `label'
	label values `newvar' `labname'
	`log' dis `"label list `labname'"'
	`log' label list `labname'
	cap
end		


program define IsToken
	args exp opt
	if "`exp'" != "`opt'" {
		dis as err "`opt' found where `exp' expected"
		exit 198
	}
end

exit
syntax

	nlogitgen newvar = varname(choicelist)

where

	choicelist := choice, choice [, choice ...]
	choice := [label:] outcome [| outcome[| outcome ...] ] 


