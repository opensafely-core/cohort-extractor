*! version 3.1.4  07apr2016
program define _crc4fld
	version 6
	args a b c d stub1 stub2 col1 col2 row1 row2 notot addpro
	if `"`stub1'"'!="" { 
		local header yes
		local s1 : piece 1 23 of `"`stub1'"'
		di in smcl _col(18) in gr `"{c |} `s1'"' _col(43) "{c |}" _c
		local s1 : piece 2 23 of `"`stub1'"'
		local j 2
		while `"`s1'"' != "" {
			di in smcl _n _col(18) in gr `"{c |} `s1'"' /*
				*/ _col(43) "{c |}" _c
			local j = `j' + 1
			local s1 : piece `j' 23 of `"`stub1'"'
		}
	}
	local s1 = 9-length(`"`col1'"')
	local s2 = 9-length(`"`col2'"')
	if `"`addpro'"'!="" { 
		if `"`header'"'=="yes" {
			di in gr _skip(13) "Proportion"
		}
		else	di in gr _col(57) " Proportion"
		local total " Total     Exposed"
		local dd 24
		local cc "_c"
	}
	else {
		if `"`header'"'=="yes" { di }
		local total " Total"
		local dd 12
	}
	di in smcl in gr `"`stub2'"' _col(18) "{c |} " /*
		*/ _skip(`s1') `"`col1'"' "   " /*
		*/ _skip(`s2') `"`col2'  {c |}     `total'"' _n /*
		*/ "{hline 17}{c +}{hline 24}{c +}{hline `dd'}"
	local row1=udsubstr(`"`row1'"',1,16)
	local s1 = 16-udstrlen(`"`row1'"')
	di in smcl in gr _skip(`s1') `"`row1' {c |} "' /*
		*/ in ye %9.0g `a' "   " %9.0g `b' /*
		*/ in gr "  {c |}  " in ye %9.0g `a'+`b' `cc'
	if `"`addpro'"'!="" { 
		di " " %12.4f `a'/(`a'+`b')
	}
	local row2=udsubstr(`"`row2'"',1,16)
	local s1 = 16-udstrlen(`"`row2'"')
	di in smcl in gr _skip(`s1') `"`row2' {c |} "' /*
		*/ in ye %9.0g `c' "   " %9.0g `d' /*
		*/ in gr "  {c |}  " in ye %9.0g `c'+`d' `cc'
	if `"`addpro'"'!="" { 
		di " " %12.4f `c'/(`c'+`d')
	}
	di in smcl in gr "{hline 17}{c +}{hline 24}{c +}{hline `dd'}"
	if `"`notot'"'!="" { exit } 
	di in smcl in gr _col(12) "Total {c |} " in ye /*
		*/ %9.0g `a'+`c' "   " %9.0g `b'+`d' /*
		*/ in gr "  {c |}  " in ye %9.0g `a'+`b'+`c'+`d' `cc'
	if `"`addpro'"'!="" { 
		di " " %12.4f (`a'+`c')/(`a'+`b'+`c'+`d')
	}
end
