*! version 1.0.0  04oct2012

program _cassert
	version 11
	syntax [, STRing(string) to(string) noSTOP ]

	cap assert `"`string'"' == `"`to'"'
	local rc = c(rc)

	if `rc' == 9 {
		di as err "{p 0 19 }assertion failure: string = " ///
		 `""`string'"{p_end}"' 
		di as err `"{p 23 19}to     = "`to'"{p_end}"'
	}
	if ("`stop'"=="") exit `rc'
end
exit
