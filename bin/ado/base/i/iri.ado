*! version 3.0.7  14apr2009
program define iri, rclass
	version 6

	gettoken a  0 : 0, parse(" ,")
	gettoken b  0 : 0, parse(" ,")
	gettoken n1 0 : 0, parse(" ,")
	gettoken n0 0 : 0, parse(" ,")

	confirm integer number `a'
	confirm integer number `b'
	confirm number `n1'
	confirm number `n0'

	if `a'<0 | `b'<0 | `n1'<0 | `n0'<0 { 
		di in red "negative numbers invalid"
		exit 498
	}

	syntax [, Level(cilevel) COL(string) ROW(string) /*
		*/ ROW2(string) TB ]
	if `"`row'"' =="" { local row "Cases" }
	if `"`row2'"'=="" { local row2 "Person-time" }

	di
	#delimit ; 
	_crc4fld `a' `b' `n1' `n0' `"`col'"' "" Exposed Unexposed `"`row'"'
		`"`row2'"' no ;

	di in smcl in gr _col(18) "{c |}" _col(43) "{c |}" _n
		"  Incidence rate {c |} " in ye
		%9.0g `a'/`n1' "   " %9.0g `b'/`n0'
		in gr "  {c |}  " in ye %9.0g (`a'+`b')/(`n1'+`n0') _n
		in gr _col(18) "{c |}" _col(43) "{c |}" ;

	local cil `=string(`level')' ;
	local cil `=length("`cil'")' ;
	local spaces " " ;
	if `cil' == 2 { ;
		local spaces "    " ;
	} ;
	else if `cil' == 4 { ;
		local spaces "  " ;
	} ;
	di in smcl in gr _col(18) 
`"{c |}      Point estimate    {c |}`spaces'[`=strsubdp("`level'")'% Conf. Interval]"'
		_n
		_col(18) "{c LT}{hline 24}{c +}{hline 24}" ;

	_crcird `a' `b' `n1' `n0' `level' `tb';
	local ird  "`r(ird)'" ;
	local ird0 "`r(lb_ird)'" ;
	local ird1 "`r(ub_ird)'" ;
	di in smcl in gr " Inc. rate diff. {c |} " in ye 
		_col(27) %9.0g `ird' in gr _col(43) "{c |}   "
		in ye %9.0g `ird0' "   " %9.0g `ird1' in gr " `r(label)'" ;

	#delimit cr
	_crcirr `a' `b' `n1' `n0' `level' `tb'
	local irr   `r(irr)'
	local irr0  `r(lb_irr)'
	local irr1  `r(ub_irr)'
	local P=Binomial(`a'+`b',`a',`n1'/(`n1'+`n0'))
	local p=`P'-Binomial(`a'+`b',`a'+1,`n1'/(`n1'+`n0'))
	if `irr'>=1 { 
		local  rel ">="
		local P = `P'-`p'/2
	}
	else {
		local rel "<="
		local P = 1-`P'+`p'/2
	}
	di in smcl in gr " Inc. rate ratio {c |} " in ye /*
		*/ _col(27) %9.0g `irr' in gr _col(43) "{c |}   " /*
		*/ in ye %9.0g `irr0' "   " %9.0g `irr1' in gr `" `r(label)'"'
	local aom1=`a'/(`a'+`b')
	if `irr'>=1 {
		local afe=cond(`a'>0 & `b'==0,1,(`irr'-1)/`irr')
		local afe0=(`irr0'-1)/`irr0'
		local afe1=cond(`a'>0 & `b'==0,1,(`irr1'-1)/`irr1')
		local afp=`aom1'*`afe'
		local hdr " Attr. frac."
	}
	else {
		local hdr " Prev. frac."
		local afe=1-`irr'
		local afe0=1-`irr1'
		local afe1=1-`irr0'
		local afp=cond(`irr'==0,1,/*
			*/ (`aom1'*(1-`irr'))/(`aom1'*(1-`irr')+`irr'))
	}
	#delimit ;
	di in smcl in gr "`hdr' ex. {c |} " in ye
		_col(27) %9.0g `afe' in gr _col(43) "{c |}   " 
		in ye %9.0g `afe0' "   " %9.0g `afe1' in gr `" `r(label)'"' _n
		in gr `"`hdr' pop {c |} "' _col(27) in ye %9.0g `afp' 
		in gr _col(43) "{c |}" _n
		_col(18) "{c BLC}{hline 24}{c BT}{hline 24}" ;
	di in gr _col(22) "(midp)   Pr(k`rel'`a') =" _col(61) 
		in ye %7.4f `P' in gr " (exact)" _n
		_col(22)  "(midp) 2*Pr(k`rel'`a') =" _col(61)
		in ye %7.4f 2*`P' in gr " (exact)" ;
	#delimit cr

	/* double save in S_# and r() */
	ret scalar ird = `ird'
	ret scalar lb_ird = `ird0'
	ret scalar ub_ird = `ird1'
	ret scalar irr = `irr'
	ret scalar lb_irr = `irr0'
	ret scalar ub_irr = `irr1'
	ret scalar p = `P'
	ret scalar afe = `afe'
	ret scalar lb_afe = `afe0'
	ret scalar ub_afe = `afe1'
	ret scalar afp = `afp'
	mac def S_1 `ird'
	mac def S_2 `ird0'
	mac def S_3 `ird1'
	mac def S_4 `irr'
	mac def S_5 `irr0'
	mac def S_6 `irr1'
	mac def S_7 `P'
	mac def S_12 `afe'
	mac def S_13 `afe0'
	mac def S_14 `afe1'
	mac def S_24 `afp'
end
