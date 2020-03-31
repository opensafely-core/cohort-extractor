*! version 2.3.1  28mar2017
program define prtesti, rclass
	version 15
	syntax [anything] ///
	[, mm1(string) k1(string) mm2(string) k2(string) ///
		cvcl1(string) cvcl2(string) ///
		rho1(string) rho2(string) idname(string) *]
	
	if (`"`options'"'!="") {
		local 0 `anything',  `options'
	}
	else {
		local 0 `anything'
	}
	
	version 5.0
	global S_6		/* will be z	*/
	parse "`0'", parse(" ,")
	if ("`3'" == ""  | ("`5'" != "" & "`5'"!=","i & "`4'"!=",")) {
		version 15:di as err "{p 0 0 2} either three arguments"/*
		*/" for a one-sample test or four arguments for a"/*
		*/" two-sample test must be specified{p_end}"
		exit 198
	}
	cap confirm number `4'
	if "`4'" != "" & _rc == 0 {
		confirm integer number `1'
		confirm number `2'
		confirm integer number `3'
		confirm number `4'
		local n1 `1'
		local p1 `2'
		local n2 `3'
		local p2 `4'

		mac shift 4

		local options "Yname(string) Xname(string) Count "
		local options "`options' Level(cilevel)"
		parse "`*'"

		if "`count'"~="" {
			confirm integer number `p1'
			confirm integer number `p2'
			if `p1' <= `n1' { local p1 = `p1'/`n1' }
			if `p2' <= `n2' { local p2 = `p2'/`n2' }
		}
		if "`count'"~="" {
			if `p1' > 1 | `p1' < 0 {
				noi di in red "`p1' not less than `n1'"
				exit 198
			}
			if `p2' > 1 | `p2' < 0 {
				noi di in red "`p2' not less than `n2'"
				exit 198
			}
		}	
		else {
			if `p1' > 1 | `p1' < 0 {
				noi di in red "`p1' not in [0,1]"
				exit 198
			}
			if `p2' > 1 | `p2' < 0 {
				noi di in red "`p2' not in [0,1]"
				exit 198
			}
		}

		tempname n p dp s1 s2 sp spp pp1 pp2 pp3 q adjs1 adjs2 z
		scalar `n' = `n1'+`n2'
		scalar `p' = (`n1'*`p1'+`n2'*`p2')/(`n1'+`n2')
		scalar `dp' = `p1'-`p2'
		if `n1'<=1 { error 2001 } 

		local xorig `xname'
		
		if `"`xname'"'=="" { local xname "x" }
		else local xname = trim(udsubstr(trim(`"`xname'"'),1,12))
		if `"`yname'"'=="" { local yname "y" }
		else local yname = trim(udsubstr(trim(`"`yname'"'),1,12))
		di

		local c1 = 53 - udstrlen(`"`xname'"')
		local c2 = 53 - udstrlen(`"`yname'"')

		
		if (`"`idname'"'=="") {
			di in gr "Two-sample test of proportions" _col(`c1') /*
		*/ in ye `"`xname'"' in gr _col(53) ": Number of obs = " /*
		*/ in ye %8.0g `n1'
			di in gr _col(`c2') in ye `"`yname'"' in gr /*
		*/ _col(53) ": Number of obs = " in ye %8.0g `n2'
	
			scalar `s1' = sqrt(`p1'*(1-`p1')/(`n1'))
			scalar `s2' = sqrt(`p2'*(1-`p2')/(`n2'))
			scalar `sp' = sqrt(`p1'*(1-`p1')/`n1'+`p2'*(1-`p2')/`n2')
			scalar `spp' = sqrt(`p'*(1-`p')/`n1'+`p'*(1-`p')/`n2')
		}
		else {
			version 15
			local c1 3
			di in gr "Two-sample test of proportions"
			di in gr "Cluster variable: " in ye "`idname'" _n
			di in gr "Group: " in ye "`xname'" _c
			di in gr _col(47) "Group: " in ye "`yname'"
			di in gr _col(`c1') "Number of obs      = " ///
				in ye %9.0fc `n1' _c
			di in gr _col(49) "Number of obs      = " ///
				in ye %9.0fc `n2'
			di in gr _col(`c1') "Number of clusters = " ///
				in ye %9.0fc `k1' _c
			di in gr _col(49) "Number of clusters = " ///
				in ye %9.0fc `k2'
			if (`cvcl1'==0) {
				di in gr _col(`c1') "Cluster size       = " ///
					in ye %9.0gc `mm1' _c
			}
			else {
				di in gr _col(`c1') "Avg. cluster size  = " ///
					in ye %9.2fc `mm1' _c
			}	
			if (`cvcl2'==0) {
				di in gr _col(49) "Cluster size       = " ///
					in ye %9.0gc `mm2' 
			}
			else {
				di in gr _col(49) "Avg. cluster size  = " ///
					in ye %9.2fc `mm2'
			}
			if (`cvcl1'!=0 | `cvcl2'!=0) {
				di in gr _col(`c1') "CV cluster size    = "/* 
					*/ in ye %9.4f `cvcl1' _c
				di in gr _col(49) "CV cluster size    = "/*
					*/ in ye %9.4f `cvcl2'
			}	
			di in gr _col(`c1') "Intraclass corr.   = " ///
				in ye %9.4f `rho1' _c
			di in gr _col(49) "Intraclass corr.   = " ///
			in ye %9.4f `rho2' 
			di	 
			scalar `adjs1' = 1+(`mm1'-1)*`rho1'+ ///
				`mm1'*`cvcl1'^2*`rho1'
			scalar `adjs2' = 1+(`mm2'-1)*`rho2'+ ///
				`mm2'*`cvcl2'^2*`rho2'
			scalar `s1' = sqrt(`p1'*(1-`p1')*`adjs1'/(`n1'))
			scalar `s2' = sqrt(`p2'*(1-`p2')*`adjs2'/(`n2'))
			scalar `sp' = sqrt(`p1'*(1-`p1')*`adjs1'/`n1'+ ///
					`p2'*(1-`p2')*`adjs2'/`n2')
			scalar `spp' = sqrt(`p'*(1-`p')*`adjs1'/`n1'+ ///
					`p'*(1-`p')*`adjs2'/`n2')
			version 5.0
		}
		_ttest1 `"`xorig'"' `level' showwald
		_ttest2 `"`xname'"' `n1' `p1' `s1' `level'
		_ttest2 `"`yname'"' `n2' `p2' `s2' `level'
		DivLine

		
		tnew `level' diff `=`n'' `=`dp'' `=`spp'' `=`sp''
		BotLine
		
		scalar `z' = (`p1'-`p2')/`spp'
		
		di as txt "        diff = prop(" as res `"`xname'"' as txt ///
			") - prop(" as res `"`yname'"' as txt ")" _col(67) ///
			as txt "z = " as res %8.4f `z'

		di as txt "    Ho: diff = 0"
		di

		_ttest center2 "Ha: diff < 0" ///
			       "Ha: diff != 0" ///
			       "Ha: diff > 0" 

		scalar `pp2' = 2*(normprob(-abs(`z')))
		if `z' < 0 {
			scalar `pp1' = `pp2'/2
			scalar `pp3' = 1 - `pp1'
		}
		else {
			scalar `pp3' = `pp2'/2
			scalar `pp1' = 1 - `pp3'
		}

		local pl1 : di %6.4f `pp1'
		local ps2 : di %6.4f `pp2'
		local pr3 : di %6.4f `pp3'
		
		_ttest center2 "Pr(Z < z) = @`pl1'@" ///
			       "Pr(|Z| > |z|) = @`ps2'@" ///
			       "Pr(Z > z) = @`pr3'@" 

		scalar `q' =  invnormal((100+`level')/200)
		if ("`idname'"!="") {
			ret scalar CV_cluster2 = `cvcl2'
			ret scalar CV_cluster1 = `cvcl1'
			ret hidden scalar DE2	= 1+(`mm2'-1)*`rho2'
			ret hidden scalar DE1	= 1+(`mm1'-1)*`rho1'
			ret scalar rho2 = `rho2'
			ret scalar rho1 = `rho1'
			if (`rho1'==`rho2') {
				ret scalar rho = `rho1'
			}
			ret scalar M2 = `mm2'	
			ret scalar M1 = `mm1'
			ret scalar K2 = `k2'
			ret scalar K1 = `k1'
			
		}
		
		ret scalar level = `level'
		ret scalar p_u  = `pp3'
		ret scalar p    = `pp2'
		ret scalar p_l  = `pp1'
		ret scalar z = (`p1'-`p2')/`spp'
		ret scalar ub_diff = `p1' - `p2' +`q'*(`sp')
		ret scalar lb_diff = `p1' - `p2' - `q'*(`sp')
		ret scalar ub2 = `p2' + `q'*(`s2')
		ret scalar lb2 = `p2' - `q'*(`s2')
		ret scalar ub1 = `p1' + `q'*(`s1')
		ret scalar lb1 = `p1' - `q'*(`s1')
		ret scalar se_diff   = `sp'
		ret scalar se_diff0   = `spp'
		ret scalar se2 = `s2'
		ret scalar se1 = `s1'
		
		ret scalar P_diff = `p1' - `p2'
		ret scalar P2 = `p2'
		ret scalar P1 = `p1'
		ret scalar N2 = `n2'
		ret scalar N1 = `n1'
		ret hidden scalar P_2 = `p2'
		ret hidden scalar P_1 = `p1'
		ret hidden scalar N_2 = `n2'
		ret hidden scalar N_1 = `n1'
		
		/* Double saves */
		global S_1  "`return(N_1)'"
		global S_2  "`return(P_1)'"
		global S_3  "`return(N_2)'"
		global S_4  "`return(P_2)'"
		global S_6  "`return(z)'"

		exit
	}
	else {
		confirm integer number `1'
		confirm number `2'
		confirm number `3'
		local n1 `1'
		local p1 `2'
		local p2 `3'

		if `p2' > 1 | `p2' < 0 {
			noi di in red "`p2' not in [0,1]"
			exit 198
		}
		mac shift 3

		local options "Yname(string) Xname(string) Count"
		local options "`options' Level(cilevel)"
		parse "`*'"
		if "`count'"~="" {
			confirm integer number `p1'
			if `p1' <= `n1' { local p1 = `p1'/`n1' }
		}
                if "`count'"~="" {
			if `p1' > 1 | `p1' < 0 {
				noi di in red "`p1' not less than `n1'"
				exit 198
			}
		}
		else {
			// only for prtesti onesample
			if `p2' > 1 | `p2' < 0 {
				noi di in red "`p2' not in [0,1]"
				exit 198
			}
			if `p1' > 1 | `p1' < 0 {
				noi di in red "`p1' not in [0,1]"
				exit 198
			}
		}

		tempname n dp s pp1 pp2 pp3 z q

		scalar `n' = `n1'
		scalar `dp' = `p1'-`p2'
		if `n1'<=1 { error 2001 } 

		local xname "x"
		local c1 = 53 - udstrlen(`"`xname'"')
		di
		di in gr "One-sample test of proportion" /*
		*/ _col(`c1') in ye `"`xname'"' in gr _col(53) /*
		*/ ": Number of obs = " /*
		*/ in ye %8.0g `n1'

		local varlist `"`xname'"'
		local exp `p2'
		scalar `s' = sqrt(`p1'*(1-`p1')/(`n1'))
		_ttest1 `""' `level'
		_ttest2 `"`xname'"' `n1' `p1' `s' `level'
		BotLine

		scalar `z' = (`p1'-`exp')/sqrt(`exp'*(1-`exp')/`n1')

		if `exp' < 1e-6 {
			local m0 : di %8.0g `exp'
		}
		else if `exp' > (1-1e-6) {
			local m0 0.999999
		}
		else {
			local m0 : di %8.6f `exp'
			forvalues i = 0/5 {
				local zz = bsubstr(`"`m0'"',8-`i',8-`i')
				if `"`zz'"' == "0" {
					local m0 = ///
						bsubstr(`"`m0'"',1,7-`i')
				} 
				else {
					continue, break
				}
			}
		}
		local m0 = trim(`"`m0'"')

		local abname=abbrev("`varlist'", 12)
                di as txt "    p = proportion(" as res `"`abname'"' ///
                        as txt ")" ///
                        _col(67) as txt "z = " as res %8.4f `z'
                di as txt "Ho: p = " as res `"`m0'"'
		di
		_ttest center2 "Ha: p < @`m0'@" ///
                	"Ha: p != @`m0'@" ///
                	"Ha: p > @`m0'@"

		
                scalar `pp2' = 2*normprob(-abs(`z'))
                if `z' < 0 {
                        scalar `pp1' = `pp2'/2
                        scalar `pp3' = 1 - `pp1'
                }
                else {
                        scalar `pp3' = `pp2'/2
                        scalar `pp1' = 1 - `pp3'
                }

		local pl1 : di %6.4f `pp1'
		local ps2 : di %6.4f `pp2'
		local pr3 : di %6.4f `pp3'

		_ttest center2 "Pr(Z < z) = @`pl1'@" ///
                	"Pr(|Z| > |z|) = @`ps2'@" ///
                        "Pr(Z > z) = @`pr3'@"
			
		scalar `q' =  invnormal((100+`level')/200)
		ret scalar level = `level'
		ret scalar p_u  = `pp3'
		ret scalar p    = `pp2'
		ret scalar p_l  = `pp1'
		ret scalar z  = `z'
		ret scalar lb = `p1' - `q'*(`s')
		ret scalar ub = `p1' + `q'*(`s')	
		ret scalar se = `s'
		ret scalar P = `p1'
		ret scalar N = `n1'
		ret hidden scalar N_1 = `n1'
		ret hidden scalar P_1 = `p1'
		
		/* Double Saves */
		global S_1  "`return(N_1)'"
		global S_2  "`return(P_1)'"
                global S_6  "`return(z)'"
	
		
		exit
	}
end


program define tnew
	args level name n mean se cse

	local tval = `mean'/`se'
	*local tval = abs(`tval')
	local pval = 2*(1 - normprob(abs(`tval')))

	local vval = (100 - (100-`level')/2)/100
	noi di in smcl in gr %12s abbrev("`name'",12) " {c |}" in ye /*
		*/ _col(17) %9.0g  `mean'   /*
		*/ _col(28) %9.0g  `cse'     /*
		*/ _col(58) %9.0g  `mean'-invnorm(`vval')/*
		*/ *`cse'   /*
		*/ _col(70) %9.0g  `mean'+invnorm(`vval')*`cse'
	noi di in smcl /*
		*/ in gr _col(14) "{c |}" in ye /*
		*/ in gr _col(17) "under Ho:"   /*
		*/ in ye _col(28) %9.0g  `se'     /*
		*/ _col(38) %8.2f  `tval'   /*
		*/ _col(49) %5.3f  `pval'  
end


program define DivLine
	di in smcl in gr "{hline 13}{c +}{hline 64}
end

program define BotLine
	di in smcl in gr "{hline 13}{c BT}{hline 64}
end

program define _ttest1
	local name = abbrev(`"`1'"', 12)
	local level "`2'"
	local show = "`3'" 
	local beg = 13 - length(`"`name'"')
	if "`show'" != "" {
		local z z
		local zp P>|z| 
	}
	local cil `=string(`level')'
	local cil `=length("`cil'")'

	if (`"`name'"'!="") {
		capture confirm variable `name'
		if _rc == 0 {
			local col1 "Variable"
		}
		else	local col1 "   Group"
	}
	
	noi di in smcl in gr "{hline 13}{c TT}{hline 64}"
	noi di in smcl in gr "    `col1'" _col(14) "{c |}" /*
	*/ _col(22) "Mean" _col(29) /*
	*/ "Std. Err." _col(44) "`z'" _col(49) /*
	*/ "`zp'" _col(`=61-`cil'') `"[`=strsubdp("`level'")'% Conf. Interval]"'
	noi di in smcl in gr "{hline 13}{c +}{hline 64}"
end
program define _ttest2
	local name = abbrev(`"`1'"', 12)
	local n "`2'"
	local mean "`3'"
	local se "`4'"
	if `n' == 1 | `n' == . {
		local se = .
	}
	local level "`5'"

	local vval = (100 - (100-`level')/2)/100
	noi di in smcl in gr %12s `"`name'"' " {c |}" in ye /*
 		*/ _col(17) %9.0g  `mean'   /*
		*/ _col(28) %9.0g  `se'     /*
		*/ _col(58) %9.0g  `mean'-invnorm(`vval')/*
		*/ *`se'   /*
		*/ _col(70) %9.0g  `mean'+invnorm(`vval')*`se'
end
exit
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
-------------+----------------------------------------------------------------
   _cons     |  26165.257  1342.8719                     xxxxxxxxx   xxxxxxxxx 

