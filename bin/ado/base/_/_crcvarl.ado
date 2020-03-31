*! 12feb2015
program define _crcvarl, sclass /* varname */
* touched by kth -- done
	version 6.0

	local vl : variable label `1'
	sret local varlabel `"`vl'"'
	if `"`vl'"'=="" {
		sret local varlabel `"`1'"'
		exit
	}
	if index(`"`vl'"',"(")==0 & index(`"`vl'"',")")==0 { 
		exit
	}
	local l = index(`"`vl'"',"(")
	while `l' {
		local vl = trim(bsubstr(`"`vl'"',1,`l'-1)+"["+bsubstr(`"`vl'"',`l'+1,.))
		local l = index(`"`vl'"',"(")
	}
	local l = index(`"`vl'"',")")
	while `l' {
		local vl = trim(bsubstr(`"`vl'"',1,`l'-1)+"]"+bsubstr(`"`vl'"',`l'+1,.))
		local l = index(`"`vl'"',")")
	}
	sret local varlabel `"`vl'"'
end
