*! version 1.0.6  20oct2005
program findfile, rclass
	version 8
	gettoken fn 0 : 0, parse(" ,")
	syntax [, ALL noDEScend PATH(string)]
	if `"`path'"'=="" {
		local path `"`c(adopath)'"'
	}

	local n 0
	local subdir : adosubdir `"`fn'"'
	if `"`subdir'"' != "" {
		gettoken d path : path, parse(";")
		while `"`d'"'!="" {
			if `"`d'"' != ";" {
				local d : sysdir `"`d'"'
				local ffn `"`d'`fn'"'
				capture confirm file `"`ffn'"'
				if _rc==0 {
					di as txt `"`ffn'"'
					if "`all'"=="" {
						ret local fn `"`ffn'"'
						exit
					}
					if `n' {
						ret local fn `"`return(fn)' "`ffn'""'
					}
					else	ret local fn `""`ffn'""'
					local n 1
				}
				if "`descend'"=="" {
					local ffn `"`d'`subdir'`c(dirsep)'`fn'"'
					capture confirm file `"`ffn'"'
					if _rc==0 {
						di as txt `"`ffn'"'
						if "`all'"=="" {
							ret local fn `"`ffn'"'
							exit
						}
						if `n' {
							ret local fn `"`return(fn)' "`ffn'""'
						}
						else	ret local fn `"`ffn'"'
						local n 1
					}
				}
			}
			gettoken d path : path, parse(" ;")
		}
	}
	if "`all'"=="" | `n'==0 {
		di as err `"file "`fn'" not found"'
		exit 601
	}
end
