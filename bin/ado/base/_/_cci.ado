*! version 3.1.5  17mar2005
program define _cci, rclass
	version 6

	gettoken a 0 : 0, parse(" ,")
	gettoken b 0 : 0, parse(" ,")
	gettoken c 0 : 0, parse(" ,")
	gettoken d 0 : 0, parse(" ,")

	confirm integer number `a'
	confirm integer number `b'
	confirm integer number `c'
	confirm integer number `d'

	if `a'<0 | `b'<0 | `c'<0 | `d'<0 { 
		di in red "negative numbers invalid"
		exit 498
	}

	syntax [, Exact Level(cilevel) COL(string) Woolf TB ]

	di
	
	local m1=`a'+`b'
	local m0=`c'+`d'
	local n1=`a'+`c'
	local n0=`b'+`d'
	local t=`n1'+`n0'
	local iz=invnorm(1-(1-`level'/100)/2)

	_crc4fld `a' `b' `c' `d' `"`col'"' "" /*
		*/ Exposed Unexposed Cases Controls /*
		*/ "" yes
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	local spaces " "
	if `cil' == 2 {
		local spaces "    "
	}
	else if `cil' == 4 {
		local spaces "  "
	}
	di in smcl in gr _col(18) "{c |}" _col(43) "{c |}"
	di in smcl in gr _col(18) /*
*/ `"{c |}      Point estimate    {c |}`spaces'[`=strsubdp("`level'")'% Conf. Interval]"' _n /*
	*/ _col(18) "{c |}{hline 24}{c +}{hline 24}"

	_crcor `a' `b' `c' `d' `level' `woolf' `tb'
	local r  = r(nf)
	local r0 = r(lb)
	local r1 = r(ub)
	local how `r(label)'
	di in smcl in gr "      Odds ratio {c |} " in ye /* 
		*/ _col(27) %9.0g `r' in gr _col(43) "{c |}   " /*
		*/ in ye %9.0g `r0' "   " %9.0g `r1' in gr `" `r(label)'"'

	if `r'>=1 {
		local afe=cond(`a'>0 & `b'>0 & `c'==0 & `d'>0,1,(`r'-1)/`r')
		local afe0=(`r0'-1)/`r0'
		local afe1=(`r1'-1)/`r1'
		local afp=(`a'/`m1')*`afe'
		local hdr " Attr. frac."
	}
	else {
		local hdr " Prev. frac."
		local afe=1-`r'
		local afe0=1-`r1'
		local afe1=1-`r0'
		local afp=((`a'/`m1')*`afe')/((`a'/`m1')*`afe'+`r')
	}
	di in smcl in gr `"`hdr' ex. {c |} "' in ye /*
		*/ _col(27) %9.0g `afe' in gr _col(43) "{c |}   " /*
		*/ in ye %9.0g `afe0' "   " %9.0g `afe1' in gr `" `how'"' _n /*
		*/ `"`hdr' pop {c |} "' in ye /*
		*/ _col(27) %9.0g `afp' in gr _col(43) "{c |}"

	if `"`exact'"'=="" {
		_crcchi2 `a' `b' `c' `d'
                global S_1 = r(chi2) /* double save in S_ and r() */
		global S_2 = chiprob(1,r(chi2)) 
		ret scalar chi2 = r(chi2)
		ret scalar p = chiprob(1,r(chi2))
		di in smcl in gr /*
		*/ _col(18) "{c BLC}{hline 24}{c BT}{hline 24}" _n /*
		*/ _col(22) "          chi2(1) =" in ye %9.2f return(chi2) /*
		*/ in gr "  Pr>chi2 =" in ye %7.4f return(p)
	}
	else {
		quietly tabi `a' `b' \ `c' `d', exact
		global S_1 = r(p1_exact)  /* double save in S_ and r() */
		global S_2 = r(p_exact)
		ret scalar p1_exact = r(p1_exact)
		ret scalar p_exact = r(p_exact)
		di in smcl in gr /*
		*/ _col(18) "{c BLC}{hline 24}{c BT}{hline 24}" _n /*
		*/ _col(35) "1-sided Fisher's exact P =" /*
		*/ in ye %7.4f return(p1_exact) _n /*
		*/ in gr _col(35) "2-sided Fisher's exact P =" /*
		*/ in ye %7.4f return(p_exact)
	}

	ret scalar or = `r'
	ret scalar lb_or = `r0'
	ret scalar ub_or = `r1'
	ret scalar afe = `afe'
	ret scalar lb_afe = `afe0'
	ret scalar ub_afe = `afe1'
	ret scalar afp = `afp'

	/* double save in S_# and r() */
	global S_3
	global S_4
	global S_5
	global S_6
	global S_7
	global S_8
	global S_9 `r'
	global S_10 `r0'
	global S_11 `r1'
	global S_12 `afe'
	global S_13 `afe0'
	global S_14 `afe1'
	global S_24 `afp'
end
