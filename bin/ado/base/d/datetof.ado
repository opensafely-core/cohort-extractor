*! version 2.1.2  13feb2015
program define datetof
	version 3.1
	local varlist "req ex max(1)"
	local if "opt"
	local in "opt"
	local options "Generate(string)"
	parse "`*'"
	if "`generat'"=="" { error 198 }
	conf new var `generat'
	conf string var `varlist'
	local type : type `varlist'
	tempvar touse s1 left right mid yr
	quietly { 
		gen byte `touse' = 0
		replace `touse' = 1 `if' `in'
		gen byte `s1'=index(`varlist',"/") if `touse' 
		replace `touse'=0 if `s1'<=1 & `touse'
		gen `type' `left' = bsubstr(`varlist',1,`s1'-1) if `touse'
		compress `left'
		gen `type' `right' = bsubstr(`varlist',`s1'+1,.) if `touse' 
		compress `right'
		replace `s1' = index(`right',"/") if `touse'
		replace `touse'=0 if `s1'<=1 & `touse'
		gen `type' `mid' = bsubstr(`right',1,`s1'-1) if `touse'
		compress `mid'
		replace `right' = bsubstr(`right',`s1'+1,.) if `touse'
		drop `s1'
		compress `right'
		trim right `left' if `touse'
		trim right `mid' if `touse'
		trim right `right' if `touse'
		gen int `yr'=real(`right') if `touse'
	}
	#delimit ;
	gen long `generat'= cond(`yr'>1900,`yr'-1900,`yr')*10000
				+ real(`left')*100
				+ real(`mid') if `touse' ;
	#delimit cr
end
