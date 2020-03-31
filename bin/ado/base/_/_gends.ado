*! version 1.2.5  13feb2015

program define _gends
	version 6.0, missing

	gettoken type 0 : 0
	gettoken g    0 : 0
	gettoken eqs  0 : 0

	syntax varlist(max=1 string) [if] [in] [, Punct(str) /*
					*/ Head Last Tail TRim BY(string)]
        if `"`by'"' != "" {
                _egennoby ends() `"`by'"'
        }

	local j = 0

	if "`head'" != "" { local j = `j'+1}
	if "`tail'" != "" { local j = `j'+1}
	if "`last'" != "" { local j = `j'+1}
	if `j' > 1 {
		di in red "you can only specify one option, head, tail or last"
		exit 198
	}
	marksample touse, strok
	local type "str1" /* ignores type passed from -egen- */
	if `"`punct'"' == `""' { local punct " " }
	local plen = length(`"`punct'"')
	if "`last'" != "" {
		quietly {
			tempvar index after next
			gen byte `index' = 0
			replace  `index' = `touse' * /*
					*/ index(`varlist', `"`punct'"')
			gen str1 `after' = ""
			gen byte `next' = 0
			local goon 1
			while `goon' {
				replace `after' = /*
					*/ bsubstr(`varlist',`index' + `plen',.)
				replace `next' = `touse' * /*
						*/ index(`after', `"`punct'"')
				capture assert `next' == 0
				if _rc == 9 {
					replace `index' = `index' + `plen' + /*
							*/ `next' - 1 if `next'
					}
				else local goon 0
			}
			gen `type' `g' = ""
			replace `g' = `varlist' if `touse'
			replace `g' = bsubstr(`varlist', `index' + `plen',.) /*
								*/ if `index'
		}
	}
	else {
		quietly {
			tempvar index
			gen `type' `g' = ""
			gen byte `index' = 0
			replace  `index' = index(`varlist',`"`punct'"')
			if "`tail'" == "" { local star = "*" }
			replace `g' = `varlist' if `index' == 0 & `touse'
			replace `g' = bsubstr(`varlist',1,`index'-1) /*
				*/ if `index' & `touse'
			`star' replace `g'= bsubstr(`varlist',`index'+`plen',.) /*
				*/ if `index' & `touse' /*option for  tail*/
			`star' replace `g' = "" if `index' == 0 /*option for tail*/
			if "`trim'" != "" {
				replace `g' = trim(`g')
			}
		}

	}
	quietly compress `g'
end
