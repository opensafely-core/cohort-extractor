*! version 2.0.3  03mar2003
program define tutorial
	version 6
	local ttl "`1'"
	if "`ttl'"=="" { 
		help tutorial
		exit
	}

	preserve
	local ops : set display pagesize
	nobreak {
		global TUT_ yes
		global path : sysdir STATA
		if "`ttl'"=="ado" | "`ttl'"=="anova" | "`ttl'"=="contents" | /*
		*/ "`ttl'"=="factor" | "`ttl'"=="graphics" { 
			local stata 1
		}
		else if "`ttl'"=="intro" | "`ttl'"=="logit" | /*
		*/ "`ttl'"=="ourdata" | "`ttl'"=="regress" { 
			local stata 1
		}
		else if "`ttl'"=="survival" | "`ttl'"=="tables" | /*
		*/ "`ttl'"=="yourdata" { 
			local stata 1
		}
		if "`stata'"=="1" {
			break capture noisily run `"$path`ttl'.tut"'
		}
		else 	break capture noisily run `"`ttl'.tut"'
		local rc = _rc
		global TUT_
		global path
		set di pagesize `ops'
	}
	set more on
	exit `rc'
end
exit
