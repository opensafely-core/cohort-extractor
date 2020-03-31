*! version 2.3.4  17feb2015
program define xi
	version 8.2, missing
	set prefix xi
	version 7, missing

	if _caller() <=6 {
		local v : di string(_caller()) 
		version `v', missing: xi_6 `0'
		exit
	}

	capture _ts timevar panvar, panel
	if _rc==0 {
		local sorder : sortedby
	}

	gettoken first second : 0, parse(":")
	if `"`second'"' != "" {
		if `"`first'"' != ":" {			/* xi, pre() : */
			local 0 `first'
			syntax [, PREfix(string) NOOMIT ]
			if length("`prefix'") > 4 {
				dis as err /*
				*/ "prefix() invalid; stub name too long ( >4 )"
				exit 198
			}
			else if length("`prefix'") == 0 {
				local prefix "_I"
			}
			gettoken colon 0: second, parse(" :")
		}
		else {					/* xi : */
			local 0 `second'
			local prefix "_I"
		}
		local xeq "yes"
		gettoken cmd : 0, parse(" ,()[]") bind
		local cmd : subinstr local cmd "i." ""
		local cmd : subinstr local cmd "I." ""
		capture confirm var `cmd'
		if !c(rc) {
			capture which `cmd'
			if c(rc) {
				capture program list `cmd'
				if c(rc) {
					error 198
				}
			}
		}
	}
	else {						/* xi items */
		gettoken comma : 0, parse(" ,")
		if `"`comma'"' == "," {			/* xi, pre() i.var */
			gettoken comma 0 : 0, parse(" ,")
			gettoken prefix rest: 0, parse(" ")
			if `"`prefix'"' == "noomit" {
				local noomit noomit
				gettoken prefix tmp : rest, parse("()")
				local len : length local prefix
				if substr(`"prefix"',1,max(3,`len')) ///
				== "`prefix'" {
					gettoken tmp2 : tmp, match(par) bind
					if "`par'" == "(" {
						gettoken prefix rest: ///
						rest, parse(" ") bind
					}
				}
				else	local prefix
			}
			if `"`noomit'"' == "" {
				gettoken omit : rest, parse(" ")
				if `"`omit'"' == "noomit" {
					local noomit noomit
					local rest : list rest - noomit
				}
				local omit
			}
			local 0  ",`prefix'"
			syntax [, PREfix(string) ]
			if length("`prefix'") > 4 {
				dis as err /*
				*/ "prefix() invalid; stub name too long ( >4 )"
				exit 198
			}
			else if length("`prefix'") == 0 {
				local prefix "_I"
			}
			local 0 `"`rest'"'
		}
		else {
			/* check for alternate syntax -- xi i.var , pre() */
			syntax [anything(id="terms")] [, PREfix(string) NOOMIT ]
			if "`prefix'" != "" {		/* xi i.var , pre() */
				if `"`anything'"' == "" {
					error 198
				}
				if length("`prefix'") > 4 {
					dis as err /*
				*/ "prefix() invalid; stub name too long ( >4 )"
					exit 198
				}
				local 0 `"`anything'"'
			}
			else {				/* xi i.var */
				local prefix "_I"
			}
		}
	}
	global X__pre "`prefix'"

	local todrop : char _dta[__xi__Vars__To__Drop__]
	local varpre : char _dta[__xi__Vars__Prefix__]

	local k : word count `todrop'
	local kcheck : word count `varpre'
	if `k' != `kcheck' { /* _dta[__xi__Vars__Prefix__] is bad, reset it */
		char _dta[__xi__Vars__Prefix__]
		foreach item of local todrop {
			capture confirm var `item'
			if ~_rc {
				local realtodrop `realtodrop' `item'
			}
		}
		local todrop `realtodrop'
		local k : word count `todrop'
		char _dta[__xi__Vars__To__Drop__] `todrop'
		foreach item of local todrop {
			local tdname : var label `item'
			if bsubstr("`tdname'",1,1) == "(" {
				local tdname = substr("`tdname'",2,.)
			}
			local eqloc = index("`tdname'","=")
			if `eqloc' == 0 {
				local eqloc .
			}
			local tdname = substr("`tdname'",1,min(3,`eqloc'-1))
			local plen = index("`item'","`tdname'") - 1
			local pfix = substr("`item'",1,`plen')
			char _dta[__xi__Vars__Prefix__] /*
				*/ `_dta[__xi__Vars__Prefix__]' `pfix'
		}
		local varpre : char _dta[__xi__Vars__Prefix__]
	}

	if `k' > 0 {
		forvalues i = 1/`k' {
			local item : word `i' of `todrop'
			local vpitem : word `i' of `varpre'
			if `"`prefix'"' == `"`vpitem'"' {
				local togo `togo' `item'
			}
			else {
				local left `left' `item'
				local vpleft `vpleft' `vpitem'
			}
		}
		capture drop `togo'
		if _rc {
			foreach item of local togo {
				capture drop `item'
			}
		}
		char _dta[__xi__Vars__To__Drop__] `left'
		char _dta[__xi__Vars__Prefix__] `vpleft'
	}

	global X__in
	global X__out
	global X__cont
	local orig `0'
	gettoken t 0 : 0, parse(`" :,"()[]="') quotes
	local update 0
	while `"`t'"' != "" {
		if upper(bsubstr(`"`t'"',1,2))=="I." {
			if index(`"`t'"',"*") {
				xi_eii `"`t'"' "*" "`noomit'"
			}
			else if index(`"`t'"',"|") {
				xi_eii `"`t'"' "|" "`noomit'"
			}
			else	xi_ei `"`t'"' "`noomit'"
			if `"$S_1"' != "." {
			    local orig : subinstr local orig `"`t'"' `"$S_1"'
			}
			else {
			    local orig : subinstr local orig `"`t'"' ""
			}
			if "`c(os)'"=="MacOSX" {
				local ++update
			}
		}
		gettoken t 0 : 0, parse(`" :,"()[]="') quotes
	}
	if "`sorder'" != "" {
		sort `sorder'
	}

	global X__in
	global X__out
	global X__cont
	global X__pre
	if "`xeq'"=="yes" {
		local vers : display string(_caller())
		version `vers', missing
		`orig'
		version 6, missing
	}
end

program define xi_ei /* I.<name> [noomit] */
	args orig noomit

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
	_nostrl error : `vn'
	cap confirm string var `vn'
	if _rc {
		local isnumb "yes"
		cap assert `vn'==int(`vn') & `vn'<1e9 & `vn'>=0 if `vn'<.
		if _rc==0 {
			qui summ `vn'
			local lowcode = r(min)
			local topcode = r(max)
			local useuser 1
		}
	}
	xi_mkun `vn'
	local svn "$S_1"

	if "`noomit'" == "" {
				/* user char vn[omit] containing <value> */
		local omis : char `vn'[omit]
		if "`omis'" != "" {
			tempvar umark
			if "`isnumb'"=="yes" {
				capture confirm number `omis'
				if _rc {
					di as err ///
" characteristic `vn'[omit] (`omis') invalid;" _n "variable `vn' is numeric"
					exit 198
				}
				gen byte `umark'= float(`vn')==float(`omis')
			}
			else	gen byte `umark'= `vn'=="`omis'"
			capture assert `umark'==0
			if _rc==0 {
				di as txt ///
				"(characteristic `vn'[omit]: `omis'" _n ///
				"yet variable " abbrev("`vn'",22) ///
				" never equals `omis'; characteristic ignored)"
				local umark
			}
		}
	
					/* code for dropping first category */
		local ximode : char _dta[omit]
		if "`noomit'" == "" & "`umark'"=="" & "`ximode'"=="" {
			tempvar umark
			qui gen byte `umark'=(`g'==1)
		}
	}


	local max 0
	local jmax 0
	qui gen long `on'=.
	forvalues j = 1/`ng' {
				/* obtain value */
		qui replace `on'=cond(`g'==`j',_n,`on'[_n-1])
		local value = `vn'[`on'[_N]]

		if `useuser' {
			local k `value'
		}
		else	local k `j'
		qui gen byte `svn'`k' = `g'==`j' if `g'<.
		local zz `zz' `svn'`k'

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
	}
	local newo = substr("`orig'",1,2) + abbrev("`vn'",13)
	if "`noomit'" == "" {
		if `useuser' {
			di as txt "`newo'" _col(19) /*
				*/ "`svn'`lowcode'-`topcode'" _col(39) /*
				*/ "(naturally coded; `svn'`jmax' omitted)"
		}
		else {
			local rlen = 41 - /*
				*/length("(`svn'`jmax' for ==`dval' omitted)")
			di as txt "`newo'" _col(19) /*
				*/ "`svn'`lowcode'-`topcode'" _col(39) /*
				*/ "(`svn'`jmax' for " abbrev("`vn'",`rlen') /*
				*/ "==`dval' omitted)"
		}
	}

	if "`noomit'" == "" {
		drop `svn'`jmax'
	}
	foreach item of local zz {
		if "`noomit'" != "" | "`item'" != "`svn'`jmax'" {
			char _dta[__xi__Vars__To__Drop__] /*
				*/ `_dta[__xi__Vars__To__Drop__]' `item'
			char _dta[__xi__Vars__Prefix__] /*
				*/ `_dta[__xi__Vars__Prefix__]' $X__pre
		}
	}
	capture list `svn'* in 1
	if _rc {
		global S_1 "."
	}
	else	global S_1 "`svn'*"
	global X__in "$X__in `vn'"
	global X__out "$X__out $S_1"
end

program define xi_eic
	args orig ichar noomit
	local pre $X__pre
			/* of form i.<varname>*<varname> */

	local lstar = index(`"`orig'"',`"`ichar'"')
	local part1 = substr(`"`orig'"',1,`lstar'-1)
	local part1nm = substr(`"`part1'"',3,.)
	local part2 = substr(`"`orig'"',`lstar'+1,.)
	unabbrev `part2'
	local part2 "`s(varlist)'"
	local type : type `part2'
	unabbrev `part1nm'
	local part1nm "`s(varlist)'"

	xi_ei `part1' `noomit'
	local res1 "$S_1"

	if length("`part1nm'") < 6 {
		local lenp2 = 12 - length("`part1nm'")
	}
	else {
		local lenp2 6
	}
	if length("`part2'") < 6 {
		local lenp1 = 12 - length("`part2'")
	}
	else {
		local lenp1 6
	}
	local newo = substr("`orig'",1,2) + abbrev("`part1nm'",`lenp1') + /*
				*/ "`ichar'" + abbrev("`part2'",`lenp2')

	if "`res1'"=="." {
		di as txt "`newo'" _col(39) "(requires no interaction terms)"
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
	local c1 = substr("`res1'",length("`pre'")+1, /*
				*/ min(3,length("`res1'")-2-length("`pre'")))
	local c2 = substr("`part2'",1,max(3,6-`len1'))
	local stub "`pre'`c1'X`c2'_"

	xi_mkun2 `stub'
	local stub "$S_1"

	tokenize `uab1'
	local i 1
	while "``i''"!="" {
		local num1 = substr("``i''",length("`res1'"),.)
		local lbl1 : variable label ``i''
		qui gen `type' `stub'`num1' = ``i''*`part2'
		char _dta[__xi__Vars__To__Drop__] /*
			*/ `_dta[__xi__Vars__To__Drop__]' `stub'`num1'
		char _dta[__xi__Vars__Prefix__] /*
			*/ `_dta[__xi__Vars__Prefix__]' $X__pre
		label var `stub'`num1' "(`lbl1')*`part2'"
		local i=`i'+1
	}
	xi_eicu `part2'
	if "`ichar'"=="*" {
		global S_1 "`res1' ${S_1}`stub'*"
	}
	else	global S_1 "${S_1}`stub'*"
	di as txt "`newo'" _col(19) "`stub'#" _col(39) "(coded as above)"
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
	args orig ichar noomit

	local pre $X__pre
	local lstar = index(`"`orig'"',"`ichar'")
	local part1 = substr(`"`orig'"',1,`lstar'-1)
	local part2 = substr(`"`orig'"',`lstar'+1,.)
	if upper(substr(`"`part2'"',1,2))!="I." {
		xi_eic `orig' "`ichar'" `"`noomit'"'
		exit
	}
	else if "`ichar'"!="*" {
		di as err "I.xxx|I.yyy not allowed"
		exit 198
	}
	xi_ei `part1' `noomit'
	local res1 "$S_1"
	xi_ei `part2' `noomit'
	local res2 "$S_1"

	local part1nm = substr(`"`part1'"',3,.)
	local part2nm = substr(`"`part2'"',3,.)
	unabbrev `part2nm'
	local part2nm "`s(varlist)'"
	unabbrev `part1nm'
	local part1nm "`s(varlist)'"
	if length("`part1nm'") < 5 {
		local lenp2 = 10 - length("`part1nm'")
	}
	else {
		local lenp2 5
	}
	if length("`part2'") < 5 {
		local lenp1 = 10 - length("`part2'")
	}
	else {
		local lenp1 5
	}
	local newo = substr("`orig'",1,2) + abbrev("`part1nm'",`lenp1') + /*
	      */ "`ichar'" + substr("`part2'",1,2) + abbrev("`part2nm'",`lenp2')

	if "`res1'"=="." | "`res2'"=="." {
		di as txt "`newo'" _col(39) "(requires no interaction terms)"
		if "`res1'" != "." {
			global S_1 `res1'
		}
		if "`res2'" != "." {
			global S_2 `res2'
		}
		exit
	}

	unabbrev `res1'
	local uab1 "`s(varlist)'"
	unabbrev `res2'
	local uab2 "`s(varlist)'"

	local c1 = substr("`res1'",length("`pre'")+1, /*
				*/ min(3,length("`res1'")-2-length("`pre'")))
	local c2 = substr("`res2'",length("`pre'")+1, /*
				*/ min(3,length("`res2'")-2-length("`pre'")))

	local stub "`pre'`c1'X`c2'_"

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
			char _dta[__xi__Vars__To__Drop__] /*
				*/ `_dta[__xi__Vars__To__Drop__]' /*
				*/ `stub'`num1'_`num2'
			char _dta[__xi__Vars__Prefix__] /*
				*/ `_dta[__xi__Vars__Prefix__]' $X__pre
			local lbl2 : variable label ``j''
			label var `stub'`num1'_`num2' "`lbl1' & `lbl2'"
			local j=`j'+1
		}
		local i=`i'+1
		local a: word `i' of `uab1'
	}
	global S_1 "`res1' `res2' `stub'*"
	di as txt "`newo'" _col(19) "`stub'#_#" _col(39) "(coded as above)"
end


program define xi_mkun /* meaning make_unique_name <suggested_name> <topcat> */
	args base

	local pre $X__pre
	local name = substr("`pre'`base'",1,11) + "_"

	xi_mkun2 `name'
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


Version 7, change I to _I, add -prefix()- option allowing users to specify
the prefix other than _I.

_I.myvar		means dummies for myvar, drop the most frequent
_I.myvar*this	means continuous interaction (still drop most frequent)
_I.myvar*I.that	means dummy interaction.

_I.myvar[what]	means dummies for myvar, drop dummy for myvar==what
_I.myvar*thatvar means interaction of myvar and thatvar
_I.myvar[val]*thatvar[val] means drop corresponding.
