*! version 1.0.1  15feb2019

program _bayes_varlist, sclass
	version 16.0
	gettoken cmd    0 : 0
	gettoken output 0 : 0
	gettoken colon  0 : 0
	if `"`colon'"' != ":" {
		di as err "_bayes_varlist expecting a colon"
		exit(198)
	}
	_bayes_varlist_`cmd' res : `0'
	c_local `output' = `"`res'"'
end

program _bayes_varlist_check
	args found colon paramlist comprlist

	c_local `found' 1
	if `: list paramlist in comprlist' {
		exit
	}
	_bayes_varlist expand paramlist : `"`paramlist'"'
	if `: list paramlist in comprlist' {
		exit
	}
	gettoken tok comprlist : comprlist
	while `"`tok'"' != "" {
		tokenize `"`tok'"', parse("-")
		if `"`2'"' != "-" {
			local paramlist: list paramlist - tok
			gettoken tok comprlist : comprlist
			continue
		}
		local tok1 `1'
		local tok2 `3'
		tokenize `"`tok1'"', parse("_")
		if `"`1'"' != "_" | `"`3'"' != "_" {
			gettoken tok comprlist : comprlist
			continue
		}
		local parname _`2'_
		cap confirm number `4'
		if _rc {
			confirm number `4'
			gettoken tok comprlist : comprlist
			continue
		}
		local n1 `4'
		tokenize `"`tok2'"', parse("_")
		if `"`1'"' != "_" | `"`3'"' != "_" {
			gettoken tok comprlist : comprlist
			continue
		}
		cap confirm number `4'
		if _rc {
			gettoken tok comprlist : comprlist
			continue
		}
		local n2 `4'
		local notfound
		while `"`paramlist'"' != "" {
			gettoken param paramlist : paramlist
			tokenize `"`param'"', parse("_")
			if `"`1'"' == "_" & `"`3'"' == "_" {
				local n .
				cap confirm number `4'
				if !_rc {
					local param _`2'_
					local n `4'
				}
				if `"`parname'"' != `"`param'"' | ///
				`n1' > `n' | `n' > `n2' {
					local notfound  `notfound' `param'`n'
				}
			}
			else {
				local notfound  `notfound' `param'`n'
			}
		}
		local paramlist `notfound'
		gettoken tok comprlist : comprlist
	}
	if `"`paramlist'"' != "" {
		c_local `found' 0
	}
end

program _bayes_varlist_expand
	args expanded colon comprlist

	local expandedlist
	while `"`comprlist'"' != "" {
		gettoken tok comprlist : comprlist
		tokenize `"`tok'"', parse("-")
		if `"`2'"' != "-" {
			local expandedlist `expandedlist' `tok'
			continue
		}
		local tok1 `1'
		local tok2 `3'
		tokenize `"`tok1'"', parse("_")
		if `"`1'"' != "_" | `"`3'"' != "_" {
			local expandedlist `expandedlist' `tok'
			continue
		}
		local parname _`2'_
		cap confirm number `4'
		if _rc {
			local expandedlist `expandedlist' `tok'
			continue
		}
		local n1 `4'
		tokenize `"`tok2'"', parse("_")
		if `"`1'"' != "_" | `"`3'"' != "_" {
			local expandedlist `expandedlist' `tok'
			continue
		}
		cap confirm number `4'
		if _rc {
			local expandedlist `expandedlist' `tok'
			continue
		}
		local n2 `4'
		forvalues i = `n1'/`n2' {
			local expandedlist `expandedlist' `parname'`i'
		}
	}
	local expandedlist : list uniq expandedlist
	c_local `expanded' = `"`expandedlist'"'
end
