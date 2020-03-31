*! version 1.6.4  13may2019
program webuse
	version 8
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
	syntax using/ [, CLEAR noLabel]

	GetDefault prefix

	capture noisily use `"`prefix'/`using'"', `clear' `label'
	if _rc==0 {
		if (strlower(substr(`"`using'"',-4,.))!=".dta") {
			local using `"`using'.dta"'
		}
		capture window menu add_recentfiles `"`prefix'/`using'"', rlevel(1)
	}
	else {
		exit _rc
	}
end

program GetDefault
	args d
	if `"$S_WEB"'=="" {
 		c_local `d' "https://www.stata-press.com/data/r16"
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
		local prefix = substr(`"`prefix'"',1,length(`"`prefix'"')-1)
	}
	if "`prefix'"=="" {
		error 198
	}
	if bsubstr(`"`prefix'"',1,7)!="http://" 			///
			& bsubstr(`"`prefix'"',1,8)!="https://" 	///
			& bsubstr(`"`prefix'"',1,6)!="ftp://"	{
		local prefix `"http://`prefix'"'
	}
	global S_WEB `"`prefix'"'
	Query
end

program Query, rclass
	syntax [, return]
	GetDefault prefix
	di as txt `"(prefix now ""' as res `"`prefix'"' as txt `"")"'
	return local prefix `"`prefix'"'
end
