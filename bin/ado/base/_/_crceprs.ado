*! version 1.0.3  5dec1997
program define _crceprs, rclass
	version 6.0
	parse, parse(" ,[")
	local i 1
	while (`"`1'"'!="" & `"`1'"'!="," & `"`1'"'!="[" & `"`1'"'!="if" & `"`1'"'!="in" & `"`1'"'!="using") {
		eq ? `1'
		local eqnames `"`eqnames' `r(eqname)'"'
		local j 1
		while (`j'<`i') {
			local oldname : word `j' of `eqnames'
			if (`"`oldname'"'==`"`r(eqname)'"') {
				di in re "Cannot specify equation name twice"
				error 198
			}
			local j = `j' + 1
		}
		local i = `i' + 1
		mac shift
	}
	/* double save in S_# and r() */
	global S_1 "`eqnames'"    
	global S_2 "`*'"
	ret local eqnames `"`eqnames'"'
	ret local rest `"`*'"'
end
