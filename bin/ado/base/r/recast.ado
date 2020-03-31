*! version 2.2.8  16feb2015
program define recast, sortpreserve
	version 6
	gettoken type 0 : 0, parse(" ,")
	syntax varlist [, FORCE DRYRUN]
	tokenize `varlist'
	local stop : word count `varlist'
	tempvar RECAST
	local rc 0 
	local i 1
	while `i' <= `stop'{ 
		capture drop `RECAST'
		capture gen `type' `RECAST' = ``i''
		if _rc == 1000 {
			error 1000
		}
		if _rc {
			di in red "``i'':  `type' invalid"
			local rc 109
		}
		else { 
			local ok 1
			quietly count if ``i''~=`RECAST'
			if r(N)>0 & "`dryrun'"!="" {
				exit 4
			}
			if "`dryrun'"!="" {
				local i = `i' +1
				continue
			}
			if r(N)>0 & "`force'"=="" {
				di in gr "``i'':  " in ye r(N) in gr /*
				*/ " value" cond(r(N)==1, "", "s") /*
				*/ " would be changed; not changed"
				local ok 0
			}
			else if r(N)>0 & "`force'"!="" {
				di in gr "``i'':  " in ye r(N) in gr /*
				*/ " value" cond(r(N)==1, "", "s") /*
				*/ " changed"
			}
			if `ok' {
				local varl : variable label ``i''
				label var `RECAST' `"`varl'"'
				local fmt : format ``i''
				capture confirm string var `RECAST'
				if _rc {
					local val : value label ``i''
					label val `RECAST' `val'
					format `RECAST' `fmt'
				}
				else if bsubstr(`"`fmt'"',2,1)=="-" {
					local fmt : format `RECAST'
					if bsubstr(`"`fmt'"',2,1)!="-" {
						local fmt = "%-" + /*
							*/ bsubstr(`"`fmt'"',2,.)

						format `RECAST' `fmt'
					}
				}
				nobreak {
					char rename ``i'' `RECAST'
					move `RECAST' ``i''
					drop ``i''
					rename `RECAST' ``i''
				}
			}
		}
		local i = `i' +1
	}
	exit `rc'
end
