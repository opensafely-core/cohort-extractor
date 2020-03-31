*! version 7.1.9  05feb2014
program define cci, rclass
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

	syntax [, Woolf TB COrnfield Exact  Level(cilevel) * ]
	if `a'==0 | `b'==0 | `c'==0 | `d'==0 & "`woolf'`tb'"=="" { 
		local cornfie="cornfield"
		local mymsg ///
"Note: Exact confidence levels not possible with zero count cells."
	}
	local levopt="level(`level')"
	if "`woolf'"~="" | "`tb'"~="" | "`cornfield'"~="" {
			_cci `a' `b' `c' `d', /*
			*/ `woolf' `tb' `exact' `levopt' `options'
		if "`mymsg'"~="" {
			di in gr _n _col(2) "`mymsg'"
		}
		ret scalar or = r(or)
		ret scalar lb_or = r(lb_or)
		ret scalar ub_or = r(ub_or)
		ret scalar afe = r(afe)
		ret scalar lb_afe = r(lb_afe)
		ret scalar ub_afe = r(ub_afe)
		ret scalar afp = r(afp)
		if "`exact'"=="" {
			ret scalar p = r(p)
			ret scalar chi2 = r(chi2)
			global S_1 = r(chi2)
			global S_2 = chiprob(1,r(chi2))
		}
		else {
			ret scalar p_exact=r(p_exact)
			ret scalar p1_exact=r(p1_exact)
			global S_1 = r(p1_exact)
			global S_2 = r(p_exact)
		}

		/* double save in S_# and r() */
		ret scalar lb_afe = r(lb_afe)
		ret scalar ub_afe = r(ub_afe)
		ret scalar afp = r(afp)
		global S_3
		global S_4
 		global S_5
		global S_6
		global S_7
 		global S_8
		global S_9 r(or)
 		global S_10 r(lb_or)
		global S_11 r(ub_or)
 		global S_12 r(afe)
		global S_13 r(lb_afe)
		global S_14 r(ub_afe)
		global S_24 r(afp)
		exit
	}
	/*
	  Calculate starting values for iterative estimate of the
	  exact confidence interval.
	*/
	_xcrnfd `a' `b' `c' `d' `level'
	tempvar adj_lb adj_ub savadlb savadub
	scalar `adj_lb' = r(lb)
	scalar `adj_ub' = r(ub)
	scalar `savadlb'=`adj_lb'
	scalar `savadub'=`adj_ub'
    	local flag_lb=0
	if `adj_lb'<=0 {
		local flag_lb=1
	}
	local flag_ub=0
	if `adj_ub' == . {
		local flag_ub=1
	}
	qui _cci `a' `b' `c' `d', `levopt'   `exact' /* cornfield by default*/
	if "`exact'"~="" {
		ret scalar p_exact=r(p_exact)
		ret scalar p1_exact= r(p1_exact)
	}
	else {
		ret scalar p=r(p)
		ret scalar chi2=r(chi2)
	}
	tempname or afp afe unad_lb unad_ub savlb savub r iz sdlnr
	tempname woolflb woolfub  
	scalar `or'=r(or)
	scalar `afp'= r(afp)
	scalar `afe'= r(afe)
	scalar `unad_lb' = r(lb_or)
	scalar `unad_ub' = r(ub_or)
	scalar `savlb'=`unad_lb'
	scalar `savub'=`unad_ub'
	if `unad_lb'<0 | `unad_ub'==. | `flag_ub'==1 | `flag_lb'==1 {
		scalar `r'=(`a'*`d')/(`b'*`c')
		scalar `iz'=invnorm(1-(1-`level'/100)/2)
		scalar `sdlnr'=sqrt(1/`a'+1/`b'+1/`c'+1/`d')
		scalar `woolflb' = exp(ln(`r')-`iz'*`sdlnr')
		scalar `woolfub' = exp(ln(`r')+`iz'*`sdlnr')
		if `unad_lb'<0 | `flag_lb'==1 {
			scalar `unad_lb'=`woolflb'
			scalar `adj_lb'=`woolflb'*0.75
		}
		if `unad_ub'==. | `flag_ub'==1 {
			scalar `unad_ub'=`woolfub'
			scalar `adj_ub'=`woolfub'*1.3
		}
	}
	quietly xcnfint `a' `b' `c' `d' `level' `unad_lb' /*
		*/ `unad_ub' `adj_lb' `adj_ub'
	tempname ex_lb ex_ub
	scalar `ex_lb' = r(ex_lb)
	scalar `ex_ub' = r(ex_ub)
	_crc4fld `a' `b' `c' `d' /*
	*/ `"`col'"' "" Exposed Unexposed Cases Controls "" yes
	tempname afe0 afe1
	if `or'>=1 {
		local hdr " Attr. frac."
		scalar `afe0'=(`ex_lb'-1)/`ex_lb'
		scalar `afe1'=(`ex_ub'-1)/`ex_ub'
	}
	else {
		local hdr " Prev. frac."
		scalar `afe0'=1-`ex_ub'
		scalar `afe1'=1-`ex_lb'
	}
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
*/ `"{c |}      Point estimate    {c |}`spaces'[`=strsubdp("`level'")'% Conf. Interval]"' /*
	*/ _n _col(18) "{c LT}{hline 24}{c +}{hline 24}"
	di in smcl in gr "      Odds ratio {c |} " in ye _col(27) %9.0g `or' /*
	*/ in gr _col(43) "{c |}   " in ye %9.0g `ex_lb' "   " /*
	*/ %9.0g `ex_ub' in gr `" (exact)"'

	di in smcl in gr `"`hdr' ex. {c |} "' in ye _col(27) %9.0g `afe' /*
	*/ in gr _col(43) "{c |}   " in ye %9.0g `afe0' "   " %9.0g `afe1' /*
	*/ in gr `" (exact)"' _n `"`hdr' pop {c |} "' in ye  _col(27) /*
	*/ %9.0g `afp' in gr _col(43) "{c |}"
	di in smcl in gr _col(18) "{c BLC}{hline 24}{c BT}{hline 24}"
	if "`exact'"~="" {
		di in gr _col(35) /*
		*/ "1-sided Fisher's exact P =" in ye %7.4f /*
		*/ return(p1_exact) _n in gr _col(35) /*
		*/ "2-sided Fisher's exact P =" in ye %7.4f return(p_exact)
	}
	else {
		di in gr _col(20) /*
		*/ "            chi2(1) =" in ye %9.2f return(chi2) /*
		*/ in gr "  Pr>chi2 =" in ye %7.4f return(p)
	}
	ret scalar or = `or'
	ret scalar lb_or = `ex_lb' 
	ret scalar ub_or = `ex_ub'
	ret scalar lb_afe = `afe0'
	ret scalar ub_afe =  `afe1'
	ret scalar afe = `afe'
	ret scalar afp = `afp'
end
/*
 *  ======== _xcrnfd =====================================================
 */
program define _xcrnfd, rclass
	version 3.1
	local a `1'
	local b `3' /* sic */
	local c `2' /* sic */
	local d `4'
	tempname iz m1 n1 n2 al alold i
	scalar `iz'=invnorm(1-(1-`5'/100)/2)
	scalar `m1'=`a'+`b'
	scalar `n1'=`a'+`c'
	scalar `n2'=`b'+`d'
	scalar `i' = 0 
	scalar `al'= `a'
	scalar `alold'= .
	while abs(`al'-`alold')>.0000001 & `al'!=. { 
		scalar `alold' = `al'
		scalar `al'=`a'- 0.5 -`iz'*1/sqrt(1/`al'+1/(`m1'-`al')+/*
			*/ 1/(`n1'-`al')+ 1/(`n2'-`m1'+`al'))
		scalar `i'=`i'+1
                scalar `al'=(`i'*`al'+(`i'-1)*`alold')/(2*`i'-1)


		if `al'==. {
			scalar `i'=`i'+1
			scalar `al'=`a'-`i'
			if (`al'<0 | (`n2'-`m1'+`al')<0) { scalar `al'= . } 
		}
	}
	if `al'==. { scalar `al'= 0 } 
	ret scalar lb = `al'*(`n2'-`m1'+`al')/((`m1'-`al')*(`n1'-`al'))
	scalar `al'= `a'
	scalar `alold'= . 
	scalar `i'= 0 
	while abs(`al'-`alold')>.0000001 & `al'!=. {
		scalar `alold'= `al'
		scalar `al'=`a'+ 0.5 +`iz'*1/sqrt(1/`al'+1/(`m1'-`al')+/*
			*/ 1/(`n1'-`al')+ 1/(`n2'-`m1'+`al'))

		scalar `i'=`i'+1
                scalar `al'=(`i'*`al'+(`i'-1)*`alold')/(2*`i'-1)

		if `al'==. {
			scalar `i'=`i'+1
			scalar `al'=`a'+`i'
			if (`al'>`n1'|`al'>`m1') { scalar `al' = . } 
		}
	}
	ret scalar ub = `al'*(`n2'-`m1'+`al')/((`m1'-`al')*(`n1'-`al'))
end

/*
 *  ======== _crcrnfd =====================================================
 */
program define _crcrnfd, rclass
	version 3.1
	local a `1'
	local b `3' /* sic */
	local c `2' /* sic */
	local d `4'

	tempname iz m1 n1 n2 al alold i

	scalar `iz'=invnorm(1-(1-`5'/100)/2)
	scalar `m1'=`a'+`b'
	scalar `n1'=`a'+`c'
	scalar `n2'=`b'+`d'
	scalar `i' = 0 
	scalar `al'= `a'
	scalar `alold'= .
	while abs(`al'-`alold')>.001 & `al'!=. { 
		scalar `alold' = `al'
		scalar `al'=`a'-`iz'*1/sqrt(1/`al'+1/(`m1'-`al')+/*
			*/ 1/(`n1'-`al')+ 1/(`n2'-`m1'+`al'))
		if `al'==. {
			scalar `i'=`i'+1
			scalar `al'=`a'-`i'
			if (`al'<0 | (`n2'-`m1'+`al')<0) { scalar `al'= . } 
		}
	}
	if `al'==. { scalar `al'= 0 } 
	ret scalar lb = `al'*(`n2'-`m1'+`al')/((`m1'-`al')*(`n1'-`al'))
	scalar `al'= `a'
	scalar `alold'= . 
	scalar `i'= 0 
	while abs(`al'-`alold')>.001 & `al'!=. {
		scalar `alold'= `al'
		scalar `al'=`a'+`iz'*1/sqrt(1/`al'+1/(`m1'-`al')+/*
			*/ 1/(`n1'-`al')+ 1/(`n2'-`m1'+`al'))
		if `al'==. {
			scalar `i'=`i'+1
			scalar `al'=`a'+`i'
			if (`al'>`n1'|`al'>`m1') { scalar `al' = . } 
		}
	}
	ret scalar ub = `al'*(`n2'-`m1'+`al')/((`m1'-`al')*(`n1'-`al'))
end

 /*  ======== xcnfint ================================ */
program define xcnfint, rclass  /* a b c d level */
args a b c d level unadjlb unadjub adjlb adjub

	confirm integer number `a'
	confirm integer number `b'
	confirm integer number `c'
	confirm integer number `d'
	confirm number `level'
    	local m1=`a'+`b'
	local m0=`c'+`d'
	local n1=`a'+`c'
	local n0=`b'+`d'
	local alpha=(100-`level')/100
	local ao2=`alpha'/2
	preserve

 * ---- Calculate the exact lower limit -----------------------------------
	tempname psi_im1 psi_i aindex

	scalar `psi_im1'=`unadjlb'
	scalar `psi_i'=`adjlb'
	mkdata0 `n1' `n0' `m1' `m0'
	mkdata `psi_im1'
	local a=`a'
        local index=1
        while a[`index'] ~= `a' {
                local index=`index'+1
                if `index'>_N {
                        display "index out of range"
                        exit
                }
        }
	scalar `aindex'=`index'
	*scalar `aindex'=r(index)
	if `psi_i' ~= . & `psi_im1' ~= . & abs(`psi_i'-`psi_im1') /*
	*/ >= 0.005*`psi_i' {

		tempname p_im1 p_i
		scalar `p_im1'=1
		if `aindex' ~= 1 { 
			scalar `p_im1'=1-cum[`aindex'-1] 
		}
		mkdata `psi_i'
		scalar `p_i'=1
		if `aindex' ~= 1 {
			scalar `p_i'=1-cum[`aindex'-1]
		} 

		tempname slope psi_ip1 p_ip1 
 		local lcount=0
		while abs(`psi_i'-`psi_im1') >= 0.005*`psi_i' {
			local lcount=`lcount'+1
			if `lcount'==100 {
			    display in red "Too many iterations:lower"
				exit 19
			}
			scalar `slope'=(`p_i'-`p_im1')/(`psi_i'-`psi_im1')
			scalar  `psi_ip1'=(`ao2'+`slope'*`psi_i'-`p_i')/`slope'
			mkdata `psi_ip1'
 			scalar `p_ip1'=1
			if `aindex' ~= 1 { 
				scalar `p_ip1'=1-cum[`aindex'-1]
			} 
			scalar `psi_im1'=`psi_i'
			scalar `p_im1'=`p_i'
			scalar `psi_i'=`psi_ip1'
			scalar `p_i'=`p_ip1'
		}
		
	}
	if `psi_i'==. {
			scalar `psi_i'=0
	}
	return scalar ex_lb=`psi_i'
	
 * ---- Calculate the exact upper limit -----------------------------------

	scalar `psi_im1'=`unadjub'
	scalar `psi_i'=`adjub'
	if `psi_i' ~= . & `psi_im1' ~= . & abs(`psi_i'-`psi_im1') /*
		*/ >= 0.005*`psi_i' {

		tempname p_im1 p_i

		mkdata `psi_im1'
		scalar `p_im1'=cum[`aindex']
		mkdata `psi_i'
		scalar `p_i'=cum[`aindex']
		local lcount=0
		while abs(`psi_i'-`psi_im1') >= 0.005*`psi_i' {
			local lcount=`lcount'+1
			if `lcount'==100 {
			    display "Too many iterations:upper"
				exit 29
			}

			tempname slope psi_ip1 p_ip1 
			scalar `slope' =(`p_i'-`p_im1')/(`psi_i'-`psi_im1')
			scalar `psi_ip1'=(`ao2'+`slope'*`psi_i'-`p_i')/`slope'

			mkdata `psi_ip1'
			
			scalar `p_ip1'=cum[`aindex']

			scalar `psi_im1'=`psi_i'
			scalar `p_im1'=`p_i'
			scalar `psi_i'=`psi_ip1'
			scalar `p_i'=`p_ip1'
		}
	}
	return scalar ex_ub=`psi_i'
	restore
end

 *  ======== mkdata =====================================================
program define mkdata  /* psi  */

	local psi= `1'	/* psi  */
	gen double g1a0=a*log(`psi')+fac
	sort g1a0
	gen double k1 = - g1a0[_N]
	gen double g2a1 = exp(k1 + g1a0)
	gen double k2 = sum(g2a1)
	gen double fa = g2a1/k2[_N]
	sort a
	replace cum=sum(fa)
	keep a cum fac
end

 *  ======== mkdata0 =====================================================

program define mkdata0  /* exposed unexposed cases controls */
    drop _all
	local n1= `1'   /* exposed */
	local n0= `2'   /* unexposed */
	local m1= `3'   /* cases */
	local m0= `4'   /* controls */
	local alow=max(0,`m1'-`n0')
	local ahigh=min(`n1',`m1')
	local nobs=`ahigh'-`alow'+1
	set obs `nobs'
	gen n1=`n1'
	gen n0= `n0'
	gen m1= `m1'
	gen m0= `m0'
	gen a=`alow'
	quietly replace a=a[_n-1]+1 if _n ~=1
	gen double fac = -lnfact(a)-lnfact(n1-a)-lnfact(m1-a)-lnfact(n0-m1+a)
	sort fac
	generate double cum=.
end
