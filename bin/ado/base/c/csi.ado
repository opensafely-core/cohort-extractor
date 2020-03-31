*! version 3.1.5  17mar2005
program define csi, rclass
* touched by kth
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

	syntax [, Exact Level(cilevel) COL(string) OR Woolf TB ]

	di

	local m1=`a'+`b'
	local m0=`c'+`d'
	local n1=`a'+`c'
	local n0=`b'+`d'
	local t=`n1'+`n0'

	_crc4fld `a' `b' `c' `d' `"`col'"' "" Exposed Unexposed Cases Noncases
	#delimit ; 
	di in smcl in gr _col(18) "{c |}" _col(43) "{c |}" ;

	di in smcl in gr "            Risk {c |} " 
		in ye %9.0g `a'/`n1' "   " %9.0g `b'/`n0'
		in gr "  {c |}  " in ye %9.0g `m1'/`t' _n 
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
`"{c |}      Point estimate    {c |}`spaces'[`=strsubdp("`level'")'% Conf. Interval]"' _n
		_col(18) "{c LT}{hline 24}{c +}{hline 24}" ;

	_crcrd `a' `b' `c' `d' `level' `tb' ;
	local rd = r(rd) ;
	local rd0 = r(lb) ;
	local rd1 = r(ub) ;
	di in smcl in gr " Risk difference {c |} " in ye
		_col(27) %9.0g `rd' in gr _col(43) "{c |}   "
		in ye %9.0g `rd0' "   " %9.0g `rd1' in gr `" `r(label)'"' ;
	_crcrr `a' `b' `c' `d' `level' `tb' ;
	local rr = r(rr) ;
	local rr0 = r(lb) ;
	local rr1 = r(ub) ;
	local how `r(label)' ;
	di in smcl in gr "      Risk ratio {c |} " in ye
		_col(27) %9.0g `rr' in gr _col(43) "{c |}   "
		in ye %9.0g `rr0' "   " %9.0g `rr1' in gr `" `r(label)'"' ;

	#delimit cr
	if `rr'>=1 {
		local afe = cond(`b'==0 & `a'>0,1,(`rr'-1)/`rr')
		local afe0=(`rr0'-1)/`rr0'
		local afe1=(`rr1'-1)/`rr1'
		local afp=(`a'/`m1')*`afe'
		local hdr " Attr. frac."
	}
	else {
		local hdr " Prev. frac."
		local afe=1-`rr'
		local afe0=1-`rr1'
		local afe1=1-`rr0'
		local afp=(`n1'/`t')*`afe'
	}
	di in smcl in gr `"`hdr' ex. {c |} "' in ye /*
		*/ _col(27) %9.0g `afe' in gr _col(43) "{c |}   " /*
		*/ in ye %9.0g `afe0' "   " %9.0g `afe1' in gr `" `how'"' _n /*
		*/ `"`hdr' pop {c |} "' in ye /*
		*/ _col(27) %9.0g `afp' in gr _col(43) "{c |}"

	if `"`or'"'!="" {
		_crcor `a' `b' `c' `d' `level' `woolf' `tb'
		local rnf = r(nf)
		local r0 = r(lb)
		local r1 = r(ub)
		di in smcl in gr "      Odds ratio {c |} " in ye /*
		*/ _col(27) %9.0g `rnf' in gr _col(43) "{c |}   " /* 
		*/ in ye %9.0g `r0' "   " %9.0g `r1' in gr `" `r(label)'"'
	}

	if `"`exact'"'=="" {
		_crcchi2 `a' `b' `c' `d'
		ret scalar chi2 = r(chi2) /* double save r() and S_ */
		ret scalar p = chiprob(1,r(chi2))
		global S_1=return(chi2)
		global S_2=return(p)
		di in smcl in gr _col(18) /*
		*/ "{c BLC}{hline 24}{c BT}{hline 24}" _n /*
		*/ _col(22) "          chi2(1) =" /*
		*/ in ye %9.2f return(chi2) in gr /*
		*/ "  Pr>chi2 =" in ye %7.4f return(p)
	}
	else {
		quietly tabi `a' `b' \ `c' `d', exact
		ret scalar p1_exact = r(p1_exact) /* double save r() and S_ */
		ret scalar p_exact = r(p_exact)
		global S_1=return(p1_exact)
		global S_2=return(p_exact)
		di in smcl in gr _col(18) /*
		*/ "{c BLC}{hline 24}{c BT}{hline 24}" _n /*
		*/ _col(35) "1-sided Fisher's exact P =" /*
		*/ in ye %7.4f return(p1_exact) _n /*
		*/ in gr _col(35) "2-sided Fisher's exact P =" /*
		*/ in ye %7.4f return(p_exact)
	}

	/* double save in r() and S_# */
	ret scalar rd = `rd'
	ret scalar lb_rd = `rd0'
	ret scalar ub_rd = `rd1'
	ret scalar rr = `rr'
	ret scalar lb_rr = `rr0'
	ret scalar ub_rr = `rr1'
	if `"`or'"'!="" {
		ret scalar or = `rnf'
		ret scalar lb_or = `r0'
		ret scalar ub_or = `r1'
	}
	ret scalar afe = `afe'
	ret scalar lb_afe = `afe0'
	ret scalar ub_afe = `afe1'
	ret scalar afp = `afp'

	global S_3 `rd'
	global S_4 `rd0'
	global S_5 `rd1'
	global S_6 `rr'
	global S_7 `rr0'
	global S_8 `rr1'
	global S_9 `rnf'
	global S_10 `r0'
	global S_11 `r1'
	global S_12 `afe'
	global S_13 `afe0'
	global S_14 `afe1'
	global S_24 `afp'
end
