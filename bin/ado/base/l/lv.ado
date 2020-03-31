*! version 3.2.1  16feb2015
program define lv, byable(onecall)
	version 7, missing
	syntax [varlist] [if] [in] [, Tail(integer 1024) Generate ]
	if "`generate'" == "" { 
		if _by() {
			by `_byvars', `_byrc0': lv1 `0'
		}
		else	lv1 `0'
		exit
	}
	if _by() {
		di as err "lv's generate option may not be combined with by"
		exit 190
	}
	lv2 `0'
end

program define lv1, rclass byable(recall) sort
* (Does it's work in S_# then at end puts in r() -- hard to get S_# 
* out of the computation steps.)
	version 6, missing
	syntax [varlist] [if] [in] [, Tail(integer 1024) ]
	marksample touse , strok
	qui replace `touse'=. if `touse'==0
	tokenize `varlist'
	while "`1'"~="" { 
		capture confirm string var `1'
		if _rc { 
			sort `touse' `1'
			local fmt : format `1'
			if (bsubstr("`fmt'",-1,1)=="f" /*
			*/ | bsubstr("`fmt'",-2,2)=="fc") /* 
			*/ & (  bsubstr("`fmt'",3,1)=="."  |  /*
			*/	bsubstr("`fmt'",3,1)=="," )  { 
				local fmt = "%9" + bsubstr("`fmt'",3,.)
			}
			else if (bsubstr("`fmt'",-1,1)=="g" /*
			*/ | bsubstr("`fmt'",-2,2)=="gc") /* 
			*/ & ( bsubstr("`fmt'",3,1)=="."   |  /*
			*/     bsubstr("`fmt'",3,1)=="," ) { 
				local fmt = "%9" + bsubstr("`fmt'",3,.)
			}
			else	local fmt "%9.0g"
			local lbl : variable label `1'
			if `"`lbl'"'=="" { 
				local lbl "`1'"
			}
			else	local lbl = usubstr(`"`lbl'"',1,32) 
			local skip = int((33-udstrlen(`"`lbl'"'))/2+.5)
			quietly count if `touse'==1 & `1'< . 
			global S_1 = r(N)
			di _n in smcl in gr /*
			*/ " # " in ye %6.0f $S_1 in gr "    " /*
			*/ _skip(`skip') "`lbl'" _n /*
			*/ _col(14) "{hline 33}"
			local n = ($S_1+1)/2
			if `n'==int(`n') { 
				global S_2 = `1'[`n']
				di in smcl in gr " M" %7.0f `n' "   {c |} " /*
				*/ _col(26) in ye /*
				*/ `fmt' `1'[`n'] _col(47) in gr /*
				*/ "{c |}    spread  pseudosigma"
			}
			else { 
				global S_2 = (`1'[`n']+`1'[`n'+1])/2
				di in smcl in gr /*
				*/ " M" %9.1f `n' " {c |} " in ye _col(26) /*
				*/ `fmt' $S_2 _col(47) in gr /*
				*/ "{c |}    spread  pseudosigma"
			}
			capture replace `mid'=$S_2 in 1
			LV `1' `n' `fmt' `tail' `z2' `mid' `spread' `psigma'
			LVdi `1' " " $S_1 1 `fmt' S_5 S_6 /*
				*/ 11 `z2' `mid' `spread' `psigma'
			di in smcl in gr /*
			*/ _col(13) "{c |}" _col(47) "{c |}" _n /*
			*/ _col(13) "{c |}" _col(47) /*
			*/ "{c |}   # below     # above"
			local ll = $S_3 - 3*($S_4-$S_3)/2
			local ul = $S_4 + 3*($S_4-$S_3)/2
			quietly count if `1'<=`ll' & `touse'==1
			local nll = r(N)
			quietly count if `1'>=`ul' & `1'< . & `touse'==1
			di in smcl in gr /*
			*/ "inner fence {c |} " in ye `fmt' `ll' /*
			*/ _col(37) `fmt' `ul' in gr " {c |} " /*
			*/ in ye %9.0g `nll' "   " %9.0g r(N)
			local ll = $S_3 - 3*($S_4-$S_3)
			local ul = $S_4 + 3*($S_4-$S_3)
			quietly count if `1'<=`ll' & `touse'==1
			local nll = r(N)
			quietly count if `1'>=`ul' & `1'< . & `touse'==1
			di in smcl in gr /*
			*/ "outer fence {c |} " in ye `fmt' `ll' /*
			*/ _col(37) `fmt' `ul' in gr " {c |} " /*
			*/ in ye %9.0g `nll' "   " %9.0g r(N)
		}
		mac shift 
	}
	/* double save in r() and S_#  */
	if "$S_1"  != "" { ret scalar N      = $S_1 }
	if "$S_2"  != "" { ret scalar median = $S_2 }
	if "$S_3"  != "" { ret scalar l_F    = $S_3 }
	if "$S_4"  != "" { ret scalar u_F    = $S_4 }
	if "$S_5"  != "" { ret scalar min    = $S_5 }
	if "$S_6"  != "" { ret scalar max    = $S_6 }
	if "$S_7"  != "" { ret scalar l_E    = $S_7 }
	if "$S_8"  != "" { ret scalar u_E    = $S_8 }
	if "$S_9"  != "" { ret scalar l_D    = $S_9 }
	if "$S_10" != "" { ret scalar u_D    = $S_10 }
	if "$S_11" != "" { ret scalar l_C    = $S_11 }
	if "$S_12" != "" { ret scalar u_C    = $S_12 }
	if "$S_13" != "" { ret scalar l_B    = $S_13 }
	if "$S_14" != "" { ret scalar u_B    = $S_14 }
	if "$S_15" != "" { ret scalar l_A    = $S_15 }
	if "$S_16" != "" { ret scalar u_A    = $S_16 }
	if "$S_17" != "" { ret scalar l_Z    = $S_17 }
	if "$S_18" != "" { ret scalar u_Z    = $S_18 }
	if "$S_19" != "" { ret scalar l_Y    = $S_19 }
	if "$S_20" != "" { ret scalar u_Y    = $S_20 }
	if "$S_21" != "" { ret scalar l_X    = $S_21 }
	if "$S_22" != "" { ret scalar u_X    = $S_22 }
end



program define lv2, rclass 
* (Does it's work in S_# then at end puts in r() -- hard to get S_# 
* out of the computation steps.)
	version 6, missing
	syntax [varlist] [if] [in] [, Tail(integer 1024) Generate ]
	marksample touse 
	qui replace `touse'=. if `touse'==0
	tokenize `varlist'
	if "`generat'"!="" { 
		tempvar z2 mid spread psigma
		capture drop _mid
		capture drop _z2
		capture drop _psigma
		capture drop _spread
	}
	while "`1'"~="" { 
		capture confirm string var `1'
		if _rc { 
			if "`generat'"!="" {
				capture drop `mid' `z2' `psigma' `spread'
				quietly { 
					gen `mid'=.
					gen `spread'=.
					gen `psigma'=.
					gen `z2'=cond(_n==1,0,.)
					label var `mid' "`1' midsummary"
					label var `z2' "Z squared"
					label var `psigma' "`1' pseudosigma"
					label var `spread' "`1' spread"
				}
			}
			sort `touse' `1'
			local fmt : format `1'
			if (bsubstr("`fmt'",-1,1)=="f" /*
			*/ | bsubstr("`fmt'",-2,2)=="fc") /* 
			*/ & (  bsubstr("`fmt'",3,1)=="."  |  /*
			*/	bsubstr("`fmt'",3,1)=="," )  { 
				local fmt = "%9" + bsubstr("`fmt'",3,.)
			}
			else if (bsubstr("`fmt'",-1,1)=="g" /*
			*/ | bsubstr("`fmt'",-2,2)=="gc") /* 
			*/ & (  bsubstr("`fmt'",3,1)=="."  |  /*
			*/	bsubstr("`fmt'",3,1)=="," )  { 
				local fmt = "%9" + bsubstr("`fmt'",3,.)
			}
			else	local fmt "%9.0g"
			local lbl : variable label `1'
			if `"`lbl'"'=="" { 
				local lbl "`1'"
			}
			else	local lbl = usubstr(`"`lbl'"',1,32) 
			local skip = int((33-udstrlen(`"`lbl'"'))/2+.5)
			quietly count if `touse'==1 & `1'< . 
			global S_1 = r(N)
			di _n in smcl in gr /*
			*/ " # " in ye %6.0f $S_1 in gr "    " /*
			*/ _skip(`skip') "`lbl'" _n /*
			*/ _col(14) "{hline 33}"
			local n = ($S_1+1)/2
			if `n'==int(`n') { 
				global S_2 = `1'[`n']
				di in smcl in gr " M" %7.0f `n' "   {c |} " /*
				*/ _col(26) in ye /*
				*/ `fmt' `1'[`n'] _col(47) in gr /*
				*/ "{c |}    spread  pseudosigma"
			}
			else { 
				global S_2 = (`1'[`n']+`1'[`n'+1])/2
				di in smcl in gr /*
				*/ " M" %9.1f `n' " {c |} " in ye _col(26) /*
				*/ `fmt' $S_2 _col(47) in gr /*
				*/ "{c |}    spread  pseudosigma"
			}
			capture replace `mid'=$S_2 in 1
			LV `1' `n' `fmt' `tail' `z2' `mid' `spread' `psigma'
			LVdi `1' " " $S_1 1 `fmt' S_5 S_6 /*
				*/ 11 `z2' `mid' `spread' `psigma'
			di in smcl in gr /*
			*/ _col(13) "{c |}" _col(47) "{c |}" _n /*
			*/ _col(13) "{c |}" _col(47) /*
			*/ "{c |}   # below     # above"
			local ll = $S_3 - 3*($S_4-$S_3)/2
			local ul = $S_4 + 3*($S_4-$S_3)/2
			quietly count if `1'<=`ll' & `touse'==1
			local nll = r(N)
			quietly count if `1'>=`ul' & `1'< . & `touse'==1
			di in smcl in gr /*
			*/ "inner fence {c |} " in ye `fmt' `ll' /*
			*/ _col(37) `fmt' `ul' in gr " {c |} " /*
			*/ in ye %9.0g `nll' "   " %9.0g r(N)
			local ll = $S_3 - 3*($S_4-$S_3)
			local ul = $S_4 + 3*($S_4-$S_3)
			quietly count if `1'<=`ll' & `touse'==1
			local nll = r(N)
			quietly count if `1'>=`ul' & `1'< . & `touse'==1
			di in smcl in gr /*
			*/ "outer fence {c |} " in ye `fmt' `ll' /*
			*/ _col(37) `fmt' `ul' in gr " {c |} " /*
			*/ in ye %9.0g `nll' "   " %9.0g r(N)
		}
		mac shift 
	}
	if "`generat'"!="" { 
		rename `mid' _mid
		rename `z2' _z2
		rename `psigma' _psigma
		rename `spread' _spread
	}
	/* double save in r() and S_#  */
	if "$S_1"  != "" { ret scalar N      = $S_1 }
	if "$S_2"  != "" { ret scalar median = $S_2 }
	if "$S_3"  != "" { ret scalar l_F    = $S_3 }
	if "$S_4"  != "" { ret scalar u_F    = $S_4 }
	if "$S_5"  != "" { ret scalar min    = $S_5 }
	if "$S_6"  != "" { ret scalar max    = $S_6 }
	if "$S_7"  != "" { ret scalar l_E    = $S_7 }
	if "$S_8"  != "" { ret scalar u_E    = $S_8 }
	if "$S_9"  != "" { ret scalar l_D    = $S_9 }
	if "$S_10" != "" { ret scalar u_D    = $S_10 }
	if "$S_11" != "" { ret scalar l_C    = $S_11 }
	if "$S_12" != "" { ret scalar u_C    = $S_12 }
	if "$S_13" != "" { ret scalar l_B    = $S_13 }
	if "$S_14" != "" { ret scalar u_B    = $S_14 }
	if "$S_15" != "" { ret scalar l_A    = $S_15 }
	if "$S_16" != "" { ret scalar u_A    = $S_16 }
	if "$S_17" != "" { ret scalar l_Z    = $S_17 }
	if "$S_18" != "" { ret scalar u_Z    = $S_18 }
	if "$S_19" != "" { ret scalar l_Y    = $S_19 }
	if "$S_20" != "" { ret scalar u_Y    = $S_20 }
	if "$S_21" != "" { ret scalar l_X    = $S_21 }
	if "$S_22" != "" { ret scalar u_X    = $S_22 }
end


program define LV
	/* S_1 contains N */
	/* `1' is varname */
	local n `2'
	local fmt "`3'"
	local tail `4'
	local v1 `5'
	local v2 "`6' `7' `8'"

	local n= (int(`n')+1)/2
	LVdi `1' F $S_1 `n' `fmt' S_3 S_4 2 `v1' `v2'

	local n = (int(`n')+1)/2
	if `n'<=1 | `tail'<8 { exit } 
	LVdi `1' E $S_1 `n' `fmt' S_7 S_8 3 `v1' `v2'

	local n = (int(`n')+1)/2
	if `n'<=1 | `tail'<16 { exit } 
	LVdi `1' D $S_1 `n' `fmt' S_9 S_10 4 `v1' `v2'

	local n = (int(`n')+1)/2
	if `n'<=1 | `tail'<32 { exit } 
	LVdi `1' C $S_1 `n' `fmt' S_11 S_12 5 `v1' `v2'

	local n = (int(`n')+1)/2
	if `n'<=1 | `tail'<64 { exit } 
	LVdi `1' B $S_1 `n' `fmt' S_13 S_14 6 `v1' `v2'

	local n = (int(`n')+1)/2
	if `n'<=1 | `tail'<128 { exit } 
	LVdi `1' A $S_1 `n' `fmt' S_15 S_16 7 `v1' `v2'

	local n = (int(`n')+1)/2
	if `n'<=1 | `tail'<256 { exit } 
	LVdi `1' Z $S_1 `n' `fmt' S_17 S_18 8 `v1' `v2'

	local n = (int(`n')+1)/2
	if `n'<=1 | `tail'<512 { exit } 
	LVdi `1' Y $S_1 `n' `fmt' S_19 S_20 9 `v1' `v2'

	local n = (int(`n')+1)/2
	if `n'<=1 | `tail'<1024 { exit } 
	LVdi `1' X $S_1 `n' `fmt' S_21 S_22 10 `v1' `v2'
end


program define LVdi /* varname ltr N n fmt sl sh */
	args vn ltr N n fmt sl sh obs z2 mid spread psigma

	if "`ltr'"=="" { 
		local ltr " "
	}
	if `n'==int(`n') { 
		global `sl' = `vn'[`n']
		global `sh' = `vn'[`N'+1-`n']
		di in smcl in gr " `ltr'" %7.0f `n' "   {c |} " _c
	}
	else { 
		global `sl' = (`vn'[`n']+`vn'[`n'+1])/2
		global `sh' = (`vn'[`N'+1-`n']+`vn'[`N'+1-`n'+1])/2
		di in smcl in gr " `ltr'" %9.1f `n' " {c |} " _c
	}
	local gs = -2*invnorm(cond(`n'==1, .695/(`N'+.390), /*
			*/ (`n'-1/3)/(`N'+1/3)) )
	di	in smcl in ye /*
		*/ `fmt' ${`sl'} "  " `fmt' (${`sl'}+${`sh'})/2 "  " /*
		*/ `fmt' ${`sh'} in gr " {c |} " in ye `fmt' ${`sh'}-${`sl'} /*
		*/ "   " `fmt' (${`sh'}-${`sl'})/`gs'
	if "`z2'"!="" {
		capture replace `z2'=(`gs'/2)^2 in `obs'
		capture replace `mid'=(${`sl'}+${`sh'})/2 in `obs'
		capture replace `spread'=${`sh'}-${`sl'} in `obs'
		capture replace `psigma'=`spread'[`obs']/`gs' in `obs'
	}
end
