*! version 3.1.9  08feb2015
program define adopath
	version 6
				/* handle + and ++ */
	gettoken op 0: 0, parse("+- ")
	if `"`op'"'=="+" {
		gettoken op: 0, parse("+- ") 
		if `"`op'"' == "+" { 
			gettoken op 0: 0, parse("+- ")
			local op "++"
		}
		else	local op "+"
		Chkrest `op' `0'
		local dir `"`s(token)'"'
		sret clear
		capture adopath - `"`dir'"'
		if "`op'" == "++" { 
			global S_ADO `"`"`dir'"';$S_ADO"'
		}
		else	global S_ADO `"$S_ADO;`"`dir'"'"'
		adopath 
		exit
	}

				/* unload S_ADO into e`i', i = 1,...,`n' */
	parse `"$S_ADO"', parse(" ;")
	local n 0
	while `"`1'"' != "" {
		if `"`1'"' != ";" {
			local n = `n' + 1
			local e`n' `"`1'"'
		}
		mac shift
	}

				/* handle -adopath- without arguments */
	if `"`op'"' == "" {
		local i 1 
		while `i' <= `n' { 
			IsKey `"`e`i''"'
			if r(builtin) {
				local realdir : sysdir `"`e`i''"'
				di in gr `"  [`i']"' _col(8) /*
				*/ `"(`e`i'')"' _col(20) /*
				*/ `"""' in ye `"`realdir'"' in gr `"""'
			}
			else {
				di in gr `"  [`i']"' _col(20) /*
				*/ `"""' in ye `"`e`i''"' in gr `"""'

			}
			* di in gr `"  [`i']  ""' in ye `"`e`i''"' in gr `"""'
			local i = `i' + 1
		}
		exit
	}

				/* handle adopath - ... */
	if `"`op'"'=="-" {
		Chkrest - `0'
		local dir `"`s(token)'"'
		sret clear
		capture confirm number `dir'
		if _rc==0 { 
			if `dir' > `n' | `dir'<1 {
				di in red /*
				*/ "no `dir'th element in current adopath"
				exit 111
			}
			global S_ADO
			local i 1
			local sim
			while `i' <= `n' { 
				if `i' != `dir' {
					global S_ADO `"$S_ADO`sim'`"`e`i''"'"'
					local sim ";"
				}
				local i = `i' + 1
			}
			adopath
			exit
		}
		local i 1
		while `i' <= `n' { 
			if `"`e`i''"' == `"`dir'"' {
				adopath - `i'
				exit
			}
			local i = `i' + 1
		}
		di in red `""`dir'" not found in adopath"'
		exit 111
	}
	error 198 
end

program define Chkrest, sclass /* op <rest> */
	gettoken op 0: 0
	local hold `"`0'"'
	gettoken mytok 0: 0
	sret local token `"`mytok'"'
	if trim(`"`s(token)'"')=="" {
		error 198
	}
	if trim(`"`0'"') != "" {
		capture noisily error 198
		local hold = trim(`"`hold'"')
		di in red /*
		*/ `"perhaps you meant to type  adopath `op' "`hold'""'
		exit 198
	}
end

program define IsKey, rclass /* dirname */
	if `"`1'"'==bsubstr(`"`1'"',1,8) {
		if `"`1'"'=="UPDATES" | `"`1'"'=="BASE" | `"`1'"'=="SITE" | /* 
		*/ `"`1'"'=="STBPLUS" | `"`1'"'=="PLUS" | `"`1'"'=="PERSONAL" | /*
		*/ `"`1'"'=="OLDPLACE" | `"`1'"'=="FUTURE" {
			return scalar builtin = 1
			exit
		}
	}
	return scalar builtin = 0
end
