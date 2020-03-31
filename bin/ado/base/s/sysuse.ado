*! version 1.0.5  04feb2015
program sysuse
	version 8
	gettoken first : 0, parse(" ,") quotes
	if `"`first'"'=="dir" {
		gettoken first 0 : 0, parse(" ,")
		sysusedir `0'
		exit
	}
	local 0 `"using `0'"'
	syntax using/ [, CLEAR REPLACE]
	local clear = cond("`replace'"!="", "clear", "`clear'")
	if bsubstr(`"`using'"',-4,.)!=".dta" {
		local using `"`using'.dta"'
	}
	quietly findfile `"`using'"'
	capture noisily use `"`r(fn)'"', `clear'
	if _rc==0 {
		capture window menu add_recentfiles `"`r(fn)'"', rlevel(1)
	}
	else {
		exit _rc
	}
end

program sysusedir, rclass
	syntax [, ALL]

	local subdirs "_ a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9"

	local path `"`c(adopath)'"'
	gettoken d path : path, parse(" ;")
	while `"`d'"' != "" {
		if `"`d'"' != ";" {
			local d : sysdir `"`d'"'

			capture local x : dir "`d'" files "*.dta"
			if _rc==0 {
				local list : list list | x
			}

			foreach l of local subdirs {
				capture local x : dir "`d'`l'" files "*.dta"
				if _rc==0 {
					local list : list list | x
				}
			}
		}
		gettoken d path : path, parse(" ;")
	}

	local list : list clean list
	local list : list sort list

	if "`all'"=="" {
		local list2
		foreach el of local list {
			if index("`el'", "_")==0 {
				local list2 `"`list2' "`el'""'
			}
		}
		local list `"`list2'"'
	}
	ret local files `"`list'"'
	DisplayInCols res 2 0 0 `list'
end

program DisplayInCols /* sty #indent #pad #wid <list>*/
	gettoken sty    0 : 0
	gettoken indent 0 : 0
	gettoken pad    0 : 0
	gettoken wid	0 : 0

	local indent = cond(`indent'==. | `indent'<0, 0, `indent')
	local pad    = cond(`pad'==. | `pad'<1, 2, `pad')
	local wid    = cond(`wid'==. | `wid'<0, 0, `wid')
	
	local n : list sizeof 0
	if `n'==0 { 
		exit
	}

	foreach x of local 0 {
		local wid = max(`wid', length(`"`x'"'))
	}

	local wid = `wid' + `pad'
	local cols = int((`c(linesize)'+1-`indent')/`wid')

	if `cols' < 2 { 
		if `indent' {
			local col "_column(`=`indent'+1')"
		}
		foreach x of local 0 {
			di as `sty' `col' `"`x'"'
		}
		exit
	}
	local lines = `n'/`cols'
	local lines = int(cond(`lines'>int(`lines'), `lines'+1, `lines'))

	/* 
	     1        lines+1      2*lines+1     ...  cols*lines+1
             2        lines+2      2*lines+2     ...  cols*lines+2
             3        lines+3      2*lines+3     ...  cols*lines+3
             ...      ...          ...           ...               ...
             lines    lines+lines  2*lines+lines ...  cols*lines+lines

             1        wid
	*/


	* di "n=`n' cols=`cols' lines=`lines'"
	forvalues i=1(1)`lines' {
		local top = min((`cols')*`lines'+`i', `n')
		local col = `indent' + 1 
		* di "`i'(`lines')`top'"
		forvalues j=`i'(`lines')`top' {
			local x : word `j' of `0'
			di as `sty' _column(`col') "`x'" _c
			local col = `col' + `wid'
		}
		di as `sty'
	}
end
