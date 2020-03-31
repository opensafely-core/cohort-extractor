*! version 3.2.7  17mar2005
program mcci, rclass
	version 6, missing

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

	syntax [, Level(cilevel) TB ]

	di

	_crc4fld `a' `b' `c' `d' /*
		*/ Controls Cases Exposed Unexposed Exposed Unexposed
	local n = `a'+`b'+`c'+`d'
	local den = `b' + `c'
	local low = min(`b',`c')
	local pval = cond(`low'==`den'/2, 1, 2*(1-Binomial(`den',`low'+1,.5)))

	local chi2 = (`b'-`c')^2/(`b'+`c')
	di in gr _n "McNemar's chi2(1) = " in ye %9.2f `chi2' /* 
		*/ _skip(4) in gr "Prob > chi2 =" in ye %7.4f chiprob(1,`chi2')

	di in gr "Exact McNemar significance probability       =" /*
		*/ in ye %7.4f `pval'
	if `pval'>=. { 
		di in gr /*
*/ "(Too many observations for exact test; asymptotic result should hold)"
	}

	local p1=(`a'+`c')/`n'
	local p2=(`a'+`b')/`n'
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	if `cil' == 2 {
		local spaces "     "
	}
	else if `cil' == 4 {
		local spaces "   "
	}
	else {
		local spaces "  "
	}
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	local cil2 20
	local spaces "     "
	if `cil' == 4 {
		local cil2 22
		local spaces "   "
	}
	else if `cil' == 5 {
		local cil2 23
		local spaces "  "
	}
	di _n in smcl in gr "Proportion with factor" _n /*
		*/ _col(9) "Cases      " in ye %9.0g `p2' in gr _n /*
		*/ _col(9) "Controls   " in ye %9.0g `p1' /*
*/ in gr `"`spaces'[`=strsubdp("`level'")'% Conf. Interval]"' _n /*
		*/ _col(20) "{hline 9}`spaces'{hline `cil2'}"

	local pd=(`b'-`c')/`n'
	local sepd=sqrt((`a'+`d')*(`b'+`c')+4*`b'*`c')/(`n'*sqrt(`n'))
	local iz=invnorm(1-(1-`level'/100)/2)
	local pd0=`pd'-`iz'*`sepd'-1/`n'
	local pd1=`pd'+`iz'*`sepd'+1/`n'
	di in gr _col(9) "difference " in ye %9.0g `pd' _skip(5) /*
		*/ %9.0g `pd0' "  " %9.0g `pd1'

	local pr=(`a'+`b')/(`a'+`c')
	local selnpr=sqrt((`b'+`c')/((`a'+`b')*(`a'+`c')))
	local pr0=exp(ln(`pr')-`iz'*`selnpr')
	local pr1=exp(ln(`pr')+`iz'*`selnpr')
	di in gr _col(9) "ratio      " in ye %9.0g `pr' _skip(5) /*
		*/ %9.0g `pr0' "  " %9.0g `pr1'

	local pe=(`b'-`c')/(`b'+`d')
	local sepe=1/((`b'+`d')^2)*sqrt(/*
		*/ (`b'+`c'+`d')*(`b'*`c'+`b'*`d'+`c'*`d')-`b'*`c'*`d')
	local pe0=`pe'-`iz'*`sepe'
	local pe1=`pe'+`iz'*`sepe'
	di in gr _col(9) "rel. diff. " in ye %9.0g `pe' _skip(5) /*
		*/ %9.0g `pe0' "  " %9.0g `pe1'

	local o = `b'/`c'
	if `"`tb'"'=="" { 
		local t=`b'+`c'
		quietly cii `t' `b', level(`level')
		local o0 = r(lb)/(1-r(lb))
		local o1 = r(ub)/(1-r(ub))
		local note "(exact)"
	}
	else {
		local x=(`b'-`c')/sqrt(`b'+`c')
		local o0 = (`o')^(1+`iz'/`x')
		local o1 = (`o')^(1-`iz'/`x')
		if `o0'>`o1' { 
			local hold `o0'
			local o0 `o1'
			local o1 `hold'
		}
		local note "(tb)"
	}
	di _n in gr _col(9) "odds ratio " in ye %9.0g `o' _skip(5) /*
		*/ %9.0g `o0' "  " %9.0g `o1' in gr "   `note'"

	ret scalar chi2 = `chi2'
	ret scalar or = `o'
	ret scalar lb_or = `o0'
	ret scalar ub_or = `o1'
	ret scalar D_f = `pd'
	ret scalar lb_D_f = `pd0'
	ret scalar ub_D_f = `pd1'
	ret scalar R_f = `pr'
	ret scalar lb_R_f = `pr0'
	ret scalar ub_R_f = `pr1'
	ret scalar RD_f = `pe'
	ret scalar lb_RD_f = `pe0'
	ret scalar ub_RD_f = `pe1'
	ret scalar p_exact = `pval'

	/* double save in S_# and r()  */
	global S_1 `chi2'
	global S_2
	global S_3
	global S_4
	global S_5
	global S_6
	global S_7
	global S_8
	global S_9 `o'
	global S_10 `o0'
	global S_11 `o1'
	global S_15 `pd'
	global S_16 `pd0'
	global S_17 `pd1'
	global S_18 `pr'
	global S_19 `pr0'
	global S_20 `pr1'
	global S_21 `pe'
	global S_22 `pe0'
	global S_23 `pe1'
	global S_24 `pval'
end
