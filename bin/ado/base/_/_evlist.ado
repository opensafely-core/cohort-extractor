*! version 1.0.2  29jan2015
program define _evlist, sclass
	version 6
	sret clear
	tempname b 
	mat `b' = e(b)
	if `"`e(cmd)'"'!="ologit" & `"`e(cmd)'"'!="oprobit" {
		local eqnames : coleq `b'
		local one : word 1 of `eqnames'
		mat `b' = `b'[1,"`one':"]
		local names : colnames `b'
		local n : word count `names'
		local last : word `n' of `names'
		if `"`last'"' == "_cons" {
			tokenize `names' 
			local `n'
			sret local varlist `*'
		}
		else	sret local varlist `names'
		exit
	}
	local names : colnames `b'
	local n : word count `names'
	tokenize `names'
	while `n' > 0 { 
		if bsubstr(`"``n''"',1,4)=="_cut" { 
			local `n'
		}
		local n = `n' - 1 
	}
	sret local varlist `*'
end
exit

Syntax
	_evlist

Returns
	s(varlist) containing the names of e(b) from the first 
	equation, _cons removed.
