*! version 2.1.0  03/27/93
program define etomdy
	version 3.1
	local varlist "req ex max(1)"
	local if "opt"
	local in "opt"
	local options "Generate(string)"
	parse "`*'"
	parse "`generat'", parse(" ")
	if ("`3'"=="" | "`4'"~="") { error 198 }
	conf new var `*'
	tempvar Temp2 Temp1 MOwrk touse good mo da yr
	quietly {
		gen long `Temp2' = int(4*((`varlist')+2505504)/146097) `if' `in'
		gen long `Temp1'  = (`varlist') + 2505504 - /*
				   */   int((146097*`Temp2'+3)/4) `if' `in'
		gen int `yr' = int(4000*(`Temp1'+1)/1461001) `if' `in'
		replace `Temp1' = `Temp1' - int(1461*`yr'/4) + 31 `if' `in'
		gen int  `MOwrk' = int(80*`Temp1'/2447) `if' `in'
		gen byte `da' = `Temp1' - int(2447*`MOwrk'/80) `if' `in'
		replace `Temp1' = int(`MOwrk'/11) `if' `in'
		gen byte `mo' = `MOwrk' + 2 - 12*`Temp1' `if' `in'
		replace `yr' = 100*(`Temp2'-49) + (`yr') + `Temp1' `if' `in'
		gen byte `touse' = 1 `if' `in' 
	}
	gen byte `good' = 1 if `touse'==1 & `mo'!=. & `da'!=. & `yr'!=.
	quietly {
		replace `mo'=. if `good'!=1
		replace `da'=. if `good'!=1
		replace `yr'=. if `good'!=1
	}
	rename `mo' `1'
	rename `da' `2'
	rename `yr' `3'
end
