*! version 2.2.4  13dec2000
program define avplots_7
	version 6.0
	_isfit cons
	syntax [, SAVing(passthru) xsize(passthru) ysize(passthru) /*
		*/ noDISPLAY MARgin(integer 10) /*
		*/ Symbol(string) * ]
			/* Option [no]display] is out of date, 
			   it does nothing.
			*/

	if "`symbol'"=="" { local symbol "s(o)" } 
	else	local symbol "s(`symbol')"

	_getrhs rhs
	tokenize `rhs'
	local wasgr : set graphics 
	local wasmore : set more 
	capture {
		set graphics off 
		set more off
		while "`1'"!="" { 
			tempfile TF
			local base `"`files'"'
			local files `"`files' `"`TF'"'"'
			capture avplot `1', saving(`"`TF'"') `symbol' `options'
			if _rc { 
				if _rc!=399 { exit _rc } 
				local files `"`base'"'
			}
			mac shift 
		}
		set graphics `wasgr'
		set more `wasmore'
		noisily gr7 using `files', margin(`margin') `saving' `xsize' `ysize'
	}
	local rc=_rc
	set graphics `wasgr'
	set more `wasmore'
	error `rc'
end
