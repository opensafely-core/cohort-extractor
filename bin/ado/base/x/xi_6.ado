*! version 1.3.12  29jan2015
program define xi_6
	version 6, missing

	capture _ts timevar panvar, panel
	if _rc==0 { 
		local sorder : sortedby
	}

	gettoken colon : 0, parse(" :,") 
	if `"`colon'"' == ":" {
		gettoken colon 0 : 0, parse(" :,")
		local xeq "yes"
	}

	capture drop I*		/* (crude but necessary) */
	global X__in
	global X__out
	global X__cont
	local orig `0'
	gettoken t 0 : 0, parse(`" :,"()[]="') quotes
	while `"`t'"' != "" {
		if upper(bsubstr(`"`t'"',1,2))=="I." {
			if index(`"`t'"',"*") { xi_eii `"`t'"' "*" }
			else if index(`"`t'"',"|") { xi_eii `"`t'"' "|" }
			else xi_ei `"`t'"'
			if `"$S_1"' != "." {
				local orig : subinstr local orig `"`t'"' `"$S_1"'
			}
			else {
				local orig : subinstr local orig `"`t'"' ""
			}
		}
		gettoken t 0 : 0, parse(`" :,"()[]="') quotes
	}
	if "`sorder'" != "" { sort `sorder' }
	global X__in
	global X__out
	global X__cont
	if "`xeq'"=="yes" {
		local vers = string(_caller())
		version `vers', missing
		`orig'
		version 6, missing
	}
end

program define xi_ei /* I.<name> */
	args orig

	tempvar g on
	local vn = substr(`"`orig'"',3,.)
	unabbrev `vn'
	local vn "`s(varlist)'"

	if "$X__in" != "" {
		tokenize $X__in
		local i 1 
		while "``i''"!="" { 
			if "``i''"=="`vn'" {
				global S_1 : word `i' of $X__out  
				exit
			}
			local i=`i'+1
		}
	}

	qui egen `g' = group(`vn')
	qui summ `g'
	local ng = r(max)    
	local lowcode 1
	local topcode `ng'
	local useuser 0
	cap confirm string var `vn'
	if _rc {
		local isnumb "yes"
		cap assert `vn'==int(`vn') & `vn'<100 & `vn'>=0 if `vn'<.
		if _rc==0 { 
			qui summ `vn'
			local lowcode = r(min)    
			local topcode = r(max)    
			local useuser 1
		}
	}
	xi_mkun `vn' `topcode'
	local svn "$S_1"

				/* user char vn[omit] containing <value> */
	local omis : char `vn'[omit]
	if "`omis'" != "" {
		tempvar umark
		if "`isnumb'"=="yes" {
			capture confirm number `omis'
			if _rc { 
				di in red /*
			*/" characteristic `vn'[omit] (`omis') invalid;" /*
			*/ _n "variable `vn' is numeric"
				exit 198
			}
			gen byte `umark'= float(`vn')==float(`omis')
		}
		else	gen byte `umark'= `vn'=="`omis'"
		capture assert `umark'==0
		if _rc==0 {
			di in gr "(characteristic `vn'[omit]: `omis'" _n /*
		*/ "yet variable `vn' never equals `omis'; characteristic ignored)"
			local umark
		}
	}

				/* code for dropping first category */
	local ximode : char _dta[omit]
	if "`umark'"=="" & "`ximode'"=="" {
		tempvar umark
		qui gen byte `umark'=(`g'==1)
	}



	local max 0 
	local jmax 0
	local j 1
	qui gen long `on'=. 
	while `j'<=`ng' {
				/* obtain value */
		qui replace `on'=cond(`g'==`j',_n,`on'[_n-1])
		local value = `vn'[`on'[_N]]

		if `useuser' { local k `value' }
		else	local k `j'
		qui gen byte `svn'`k' = `g'==`j' if `g'<.

		label var `svn'`k' "`vn'==`value'"
		if "`umark'"=="" {
			qui count if `g'==`j'
			if r(N)>`max' { 
				local max = r(N)      
				local jmax `k'
				local dval "`value'"
			}
		}
		else {
			capture assert `umark' if `g'==`j'
			if _rc==0 {
				local jmax `k'
				local dval "`value'"
			}
		}
		local j=`j'+1
	}
	if `useuser' {
		di in gr "`orig'" /*
			*/ _col(23) "`svn'`lowcode'-`topcode'" /*
			*/ _col(36) "(naturally coded; `svn'`jmax' omitted)"
	}
	else	di in gr "`orig'" /*
			*/ _col(23) "`svn'`lowcode'-`topcode'" /*
			*/ _col(36) "(`svn'`jmax' for `vn'==`dval' omitted)"

	drop `svn'`jmax'
	capture list `svn'* in 1
	if _rc {
		global S_1 "."
	}
	else	global S_1 "`svn'*"
	global X__in "$X__in `vn'"
	global X__out "$X__out $S_1"
end


program define xi_eic
	args orig ichar 
			/* of form i.<varname>*<varname> */

	local lstar = index(`"`orig'"',`"`ichar'"')
	local part1 = substr(`"`orig'"',1,`lstar'-1)
	local part2 = substr(`"`orig'"',`lstar'+1,.)
	unabbrev `part2'
	local part2 "`s(varlist)'"
	local type : type `part2'

	xi_ei `part1'
	local res1 "$S_1"

	if "`res1'"=="." {
		di in gr "`orig'" _col(36) "(requires no interaction terms)"
		xi_eicu `part2'
		exit
	}

	unabbrev `res1'
	local uab1 "`s(varlist)'"
	tokenize `uab1'
	local len1 0
	while "`1'"!="" {
		if length("`1'")>`len1' {
			local len1 = length("`1'")
		}
		mac shift
	}
	local len1 = `len1'-length("`res1'") + 1
	local c1 = substr("`res1'",2,1)
	local c2 = substr("`part2'",1,4-`len1')
	local stub "I`c1'X`c2'_"
	
	xi_mkun2 `stub'
	local stub "$S_1"

	tokenize `uab1'
	local i 1
	while "``i''"!="" {
		local num1 = substr("``i''",length("`res1'"),.)
		local lbl1 : variable label ``i''
		qui gen `type' `stub'`num1' = ``i''*`part2'
		label var `stub'`num1' "(`lbl1')*`part2'"
		local i=`i'+1
	}
	xi_eicu `part2'
	if "`ichar'"=="*" {
		global S_1 "`res1' ${S_1}`stub'*"
	}
	else	global S_1 "${S_1}`stub'*"
	di in gr "`orig'" _col(23) "`stub'#" _col(36) "(coded as above)"
end

program define xi_eicu	/* <contvar_name> */
	args vn
	global S_1
	if "$X__cont" != "" {
		tokenize $X__cont
		local i 1
		while "``i''"!="" {
			if "``i''"=="`vn'" { exit }
			local i=`i'+1
		}
	}
	global S_1 "`vn' "		/* sic */
	global X__cont "$X__cont `vn'"
end

program define xi_eii
	args orig ichar

	local lstar = index(`"`orig'"',"`ichar'")
	local part1 = substr(`"`orig'"',1,`lstar'-1)
	local part2 = substr(`"`orig'"',`lstar'+1,.)
	if upper(substr(`"`part2'"',1,2))!="I." {
		xi_eic `orig' "`ichar'"
		exit
	}
	else if "`ichar'"!="*" { 
		di in red "I.xxx|I.yyy not allowed"
		exit 198
	}
	xi_ei `part1'
	local res1 "$S_1"
	xi_ei `part2'
	local res2 "$S_1"

	if "`res1'"=="." | "`res2'"=="." { 
		di in gr "`orig'" _col(36) "(requires no interaction terms)"
		exit
	}

	unabbrev `res1'
	local uab1 "`s(varlist)'"
	tokenize `uab1'
	local len1 0
	while "`1'"!="" {
		if length("`1'")>`len1' {
			local len1 = length("`1'")
		}
		mac shift
	}
	unabbrev `res2'
	local uab2 "`s(varlist)'"
	tokenize `uab2'
	local len2 0
	while "`1'"!="" {
		if length("`1'")>`len2' {
			local len2 = length("`1'")
		}
		mac shift
	}

	local len1 = `len1'-length("`res1'") + 1
	local len2 = `len2'-length("`res2'") + 1
	local len = `len1'+`len2'
	local c1 = substr("`res1'",2,1)
	local c2 = substr("`res2'",2,1)
	if `len'==2 {
		local stub "I`c1'X`c2'_"
	}
	else if `len'==3 { 
		local stub "I`c1'`c2'_"
	}
	else if `len'==4 {
		local stub "I`c1'`c2'"
	}
	else if `len'==5 { 
		local stub "IX"
	}
	else {
		di in red /*
*/ "too many interaction combinations to form reasonable variable names"
		exit 198
	}

	xi_mkun2 `stub'
	local stub "$S_1"

	tokenize `uab2'
	local i 1
	local a : word `i' of `uab1'
	while "`a'"!="" {
		local num1 = substr("`a'",length("`res1'"),.)
		local lbl1 : variable label `a'
		local j 1
		while "``j''"!="" {
			local num2 = substr("``j''",length("`res2'"),.)
			qui gen byte `stub'`num1'_`num2' = `a'*``j''
			local lbl2 : variable label ``j''
			label var `stub'`num1'_`num2' "`lbl1' & `lbl2'"
			local j=`j'+1
		}
		local i=`i'+1
		local a: word `i' of `uab1'
	}
	global S_1 "`res1' `res2' `stub'*"
	di in gr "`orig'" _col(23) "`stub'#-#" _col(36) "(coded as above)"
end


program define xi_mkun /* meaning make_unique_name <suggested_name> <topcat> */
	args base ng

	local name "I`base'"
	if `ng'<10 {
		local name = substr("`name'",1,6) + "_"
	}
	else if `ng'<100 {
		local name = substr("`name'",1,5) + "_"
	}
	else if `ng'<1000 {
		local name = substr("`name'",1,5)
	}
	else {
		di in red "too many groups for `base'"
		exit 499
	}
	xi_mkun2 `name' `ng'
end

program define xi_mkun2 /* meaning make_unique_name <suggested_name> */
	args name

	local totry "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local l 0
	local len = length("`name'")
	capture list `name'* in 1		/* try name out */
	while _rc==0 {
		local l=`l'+1
		local name = substr("`name'",1,`len'-1)+substr("`totry'",`l',1)
		capture list `name'* in 1
	}
	global S_1 "`name'"
end
exit

Note, use of S_1 in this version 6 program is approved with reservations.
It is not good style but S_1 is used throughout and tracing from where 
each S_1 comes from (or whether it is inherited) is too dangerous.


I.myvar		means dummies for myvar, drop the most frequent
I.myvar*this	means continuous interaction (still drop most frequent)
I.myvar*I.that	means dummy interaction.


I.myvar[what]	means dummies for myvar, drop dummy for myvar==what
I.myvar*thatvar means interaction of myvar and thatvar 
I.myvar[val]*thatvar[val] means drop corresponding.
	
12345678
I123_#x#
I12##x##


For I.name*I.name
We try:
	12345
	IrXr_	e.g., IrXr_#_#   for two 1-digit numbers
	Irr_    e.g., Irr_#_## or Irr_##_# for 1 and 2 digit numbers
	Irr     e.g., Irr##_##   for two 2-digit numbers

For I.name*name
	Irr_#

I.abc*I.def

IrXr_ we try, then shorten to 
Irr_

I12345_#
I1234_##
I1234###
