*! version 1.0.5  13feb2015 
* see notes at end of _getxel.ado
program define _getxel2, sclass
	version 6
	args type eq
	sret clear 

	tempname b
	mat `b' = e(b)

	if `"`eq'"'=="" {
		local fnames : colfullnames `b', quote
		tokenize `"`fnames'"'
		local i 1
		while `"``i''"' != "" {
			local c = index(`"``i''"',":")
			if `c'==0 {
				sret local e`i' `type'[``i'']
			}
			else {
				local eq = bsubstr(`"``i''"',1,`c'-1)
				local eq `eq'
				local na = bsubstr(`"``i''"',`c'+1,.)
				sret local e`i' `"[`eq']`type'[`na']"'
			}
			local i = `i' + 1
		}
		sret local n = `i'-1
		exit
	}
	if bsubstr(`"`eq'"',1,1)=="#" {
		local neq = bsubstr(`"`eq'"',2,.)
		FindName `b' `neq'
		sret local eq `s(name)'
		mat `b' = `b'[1,"`s(name)':"]
		local names : colnames `b'
		tokenize `"`names'"'
		local i 1
		while `"``i''"' != "" {
			sret local e`i' [`s(name)']`type'[``i'']
			local i = `i' + 1
		}
		sret local name
		sret local n = `i'-1
		exit
	}
	capture mat `b' = `b'[1,"`eq':"]
	if _rc {
		di in red `"equation [`eq'] not found"'
		exit 111
	}
	local names : colnames `b'
	tokenize `"`names'"'
	local i 1
	while `"``i''"' != "" {
		sret local e`i' `"[`eq']`type'[``i'']"'
		local i = `i' + 1
	}
	sret local n = `i'-1
end

program define FindName, sclass
	args b neq

	local enames : coleq `b', quote
	tokenize `"`enames'"'

	if `neq'==1 {
		sret local name `"`1'"'
		exit
	}
	local cur `"`1'"'
	local ieq 1
	local i 2 
	while `"``i''"' != "" {
		if `"``i''"' != `"`cur'"' {
			local cur = `"``i''"'
			local ieq = `ieq' + 1 
			if `ieq' == `neq' {
				sret local name `"``i''"'
				exit
			}
		}
		local i = `i' + 1
	}
	di in red "equation [#`neq'] not found"
	exit 111
end
exit
