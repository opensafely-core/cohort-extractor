*! version 7.0.4  13feb2015
program define _gconcat12
	version 7, missing
	local strlen = c(maxstrvarlen)
	
	version 6.0, missing

	gettoken type 0 : 0
	gettoken g    0 : 0
	gettoken eqs  0 : 0

	syntax varlist(min=1) [if] [in],/* 
		*/ [Punct(str) Decode MAXLength(str) Format(str) BY(string)]
	if `"`by'"' != "" {
		_egennoby concat() `"`by'"'
	}

	tempvar xy
	gen `xy'=1
	if "`format'" != "" { 
		capture format `xy' `format'
		if _rc == 120 {
			noi di in r "Invalid format"
			exit 120
		}		 
		local format `","`format'""'
	}
	local plen = length(`"`punct'"')
	local type "str1" /* ignores type passed from -egen- */
	if "`maxleng'" != "" {
		capture confirm integer n `maxleng'
		if _rc | `maxleng' < 1 | `maxleng' > `strlen' {
			di in r "invalid maxlength( )"
			exit 198
		}
		else {
			local maxleng "maxl(`maxleng')"
		}
	}
	local decode = "`decode'" == "decode"

	quietly {
		gen `type' `g' = "" 
		tokenize `varlist'
		while "`1'" != "" {
			capture confirm string variable `1'
			if _rc {
				local decoded 0
				if `decode' {
					tempvar dcdd
					capture decode `1', /*
						*/ gen(`dcdd') `maxleng'
					if _rc == 0 {
						replace `dcdd' = /*
						*/ string(`1'`format') /*
							*/ if `dcdd' == ""  
						replace `g' = /*
						*/ `g' + `dcdd' + /*
						*/ `"`punct'"' `if' `in'
						local decoded 1
					}
					capture drop `dcdd'
				}
				if !`decoded' {
					replace `g' = /*
					*/ `g' + string(`1'`format') + /*
					*/ `"`punct'"'  `if' `in'
				}
			}
			else {
				replace `g' = /*
					*/ `g' + `1' + `"`punct'"' `if' `in'
			}
			mac shift
		}
		replace `g' = trim(bsubstr(`g',1,length(`g') - `plen'))
	}
	local gtype : type `g'
	if "`gtype'" == "str`strlen'" {
		di in gr /*
		*/ "(note: str`strlen' variable created; truncated values possible)"
	}
end
