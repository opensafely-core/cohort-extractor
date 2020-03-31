*! version 1.2.2  13may2019
program webdescribe
	version 9
	if `"`0'"' == "" {
		error 198
	}
	gettoken sub : 0, parse(" ,") quotes

	if `"`sub'"'=="set" | `"`sub'"'=="query" {
		gettoken sub 0 : 0, parse(" ,")
		if "`sub'"=="set" {
			Set `0'
		}
		else	Query `0'
		exit
	}

	local 0 `"using `0'"'
	syntax using/ [, Short Detail VARList ]

	GetDefault prefix

	describe using `"`prefix'/`using'"', `short' `detail' `varlist'
end

program GetDefault
	args d
	if `"$S_WEB"'=="" {
 		c_local `d' "http://www.stata-press.com/data/r16"
	}
	else	c_local `d' `"$S_WEB"'
end


program Set
	gettoken prefix 0 : 0, parse(" ")
	if `"`0'"' != "" {
		error 198
	}
	if `"`prefix'"'=="" {
		global S_WEB
		Query
		exit
	}
	if bsubstr(`"`prefix'"',-1,1)=="/" {
		local prefix = bsubstr(`"`prefix'"',1,length(`"`prefix'"')-1)
	}
	if "`prefix'"=="" {
		error 198
	}
	if bsubstr(`"`prefix'"',1,7)!="http://" {
		local prefix `"http://`prefix'"'
	}
	global S_WEB `"`prefix'"'
	Query
end

program Query
	syntax
	GetDefault prefix
	di as txt `"(prefix now ""' as res `"`prefix'"' as txt `"")"'
end
