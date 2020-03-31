*! version 3.0.2  16jun1998
program define ologitp
* touched by jwh 
	version 6
	if "`e(cmd)'"!="ologit" { error 301 } 
	local varlist "req new min(2)"
	local if "opt"
	local in "opt"
	parse "`*'"
	parse "`varlist'", parse(" ")
	local i 1 
	while "``i''"!="" { 
		tempvar v`i'
		rename ``i'' `v`i''
		local i=`i'+1
	}
	local n 1 
	capture local j=_b[_cut`n']
	while _rc==0 { 
		local n=`n'+1
		capture local j=_b[_cut`n']
	}
	if `i'-1<`n' { error 102 } 
	if `i'-1>`n' { error 103 } 
	tempvar s
	quietly { 
		_predict double `s' `if' `in'
		replace `v1' = 1/(1+exp(`s'-_b[_cut1]))
		label var `v1' "Pr(xb+u<_cut1)"
		local i 2 
		while `i'<`n' { 
			local im1=`i'-1
			replace `v`i''=1/(1+exp(`s'-_b[_cut`i'])) - /*
				*/ 1/(1+exp(`s'-_b[_cut`im1']))
			label var `v`i'' "Pr(_cut`im1'<xb+u<_cut`i')"
			local i=`i'+1
		}
		local im1=`i'-1
		replace `v`i''=1-1/(1+exp(`s'-_b[_cut`im1']))
		label var `v`i'' "Pr(_cut`im1'<xb+u)"
	}
	local i 1
	while `i'<=`n' { 
		rename `v`i'' ``i''
		local i=`i'+1
	}
end
