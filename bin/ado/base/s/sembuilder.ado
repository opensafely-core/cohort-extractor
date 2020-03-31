*! version 1.0.1  23feb2017
program sembuilder

	syntax [ anything ]
	local name `anything'

	capture mata:  sg__global()
	if _rc {
		mata:  sg__global()
	}

	if `"`name'"' == `""' {
		mata:  sg__global.signal("", "New", "", "")
	}
	else {
		mata:  st_local("exists", strofreal(fileexists(`"`name'"')))
		if ! 0`exists' {
		    local name0 `"`name'"'
		    local name `"`name'.stsem"'
		    mata:  st_local("exists", strofreal(fileexists(`"`name'"')))
		}
		if 0`exists' {
               		capture window menu add_recentfiles `"`name'"', rlevel(1)
			mata:  sg__global.signal("", "Open", `"`name'"', "")
		}
		else {
			di as error `"file `name0' not found"'
			exit 601
		}
	}

end

