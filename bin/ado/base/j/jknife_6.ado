*! version 1.0.9  09feb2015
program define jknife_6
	version 4.0, missing
	parse "`*'", parse(" =,")
	if "`1'"=="clear" {
		jk_clear
		exit
	}
	if "`1'"=="cmd" {
		mac shift
		global JK_cmd "`*'"
		jk_setcm `*'
		global JK_mark "jknife"
		exit
	}
	if "`1'"=="n" {
		mac shift 
		if "`1'"!="=" { error 198 } 
		mac shift
		global JK_n "`*'"
		global JK_mark "jknife"
		exit
	}
	if "`1'"=="stat" {	/* stat # newvar = exp */
		mac shift 
		if "$JK_l"=="" | "$JK_mark"!="jknife" { global JK_l 0 }
		local i=$JK_l+1
		local JK_mark "jknife"
		capture confirm integer number `1'
		if _rc==0 { 
			if `1'>`i' { 
				di in red "Next to define is `i'"
				exit 198 
			}
			local k `1'
			mac shift
		}
		else 	local k `i'
		if "`*'"=="" {
			if `k'>=`i' { exit }
			while `k'<=$JK_l {
				local l=`k'+1
				global JK_v`k' "${JK_v`l'}"
				global JK_s`k' "${JK_s`l'}"
				local k `l'
			}
			global JK_l=$JK_l-1
			exit
		}
		global JK_v`k' "`1'"
		mac shift 
		if "`1'"!="=" { error 198 } 
		mac shift
		global JK_s`k' "`*'"
		if `k'==`i' { global JK_l `i' }
		exit
	}
	if "`1'"==bsubstr("query",1,length("`1'")) {
		if "$JK_l"=="" | "$JK_mark"!= "jknife" { exit }
		di _n in gr " cmd:  " in ye "$JK_cmd"
		di in gr "   n:  " in ye "$JK_n"
		local i 1
		while `i'<=$JK_l {
			di in gr "stat:  [`i']  " in ye /*
				*/ "${JK_v`i'} = ${JK_s`i'}"
			local i=`i'+1
		}
		exit
	}
	if "`1'"!="do" { error 198 }
	mac shift
	local options "REPLACE Level(cilevel)"
	parse "`*'"

	if "$JK_mark"!="jknife" | "$JK_cmd"=="" | "$JK_l"=="" | "$JK_l"=="0" { 
		di in red "nothing to do"
		exit 198
	}
	jknife query
	tempvar order N
	gen `c(obs_t)' `order'=_n

	if "$JK_n"!="" { 
		if bsubstr("$JK_n",1,2)=="S_" {
			local fmla_n "\$$JK_n"
		}
		else 	local fmla_n "$JK_n"
	}
	else 	local fmla_n "_N"

	quietly $JK_cmd		/* perform command	*/
	sort `order'		/* put back in original order */
	scalar `N' = `fmla_n'
	if "`fmla_n'" == "_N" {
		local fmla_n "_N-1"
	}

	local i 1 
	while `i'<=$JK_l { 
		if bsubstr("${JK_s`i'}",1,2)=="S_" {
			local fmla`i' "\$${JK_s`i'}"
		}
		else	local fmla`i' "${JK_s`i'}"
		tempname all`i' tn`i'
		scalar `all`i'' = `fmla`i''
		if "`replace'"!="" {
			capture drop ${JK_v`i'}
		}
		else 	confirm new var ${JK_v`i'}

		quietly gen `tn`i''=.
		local i=`i'+1
	}
	local j 1
	while `j'<=_N { 
		quietly $JK_cmd $JK_cma if _n!=`j'
		sort `order'
		local i 1 
		while `i'<=$JK_l { 
			if `fmla_n' == `N'-1 {
				quietly replace `tn`i'' = `fmla`i'' in `j'
			}
			local i=`i'+1
		}
		local j=`j'+1
	}
	local i 1 
	while `i'<=$JK_l { 
		local list "`list' ${JK_v`i'}"
		quietly replace `tn`i''=`N'*(`all`i''-`tn`i'')+`tn`i''
		rename `tn`i'' ${JK_v`i'}
		local i=`i'+1
	}

	local cil `=string(`level')'
	local cil `=length("`cil'")'
	local spaces ""
	if `cil' == 2 {
		local spaces "   "
	}
	else if `cil' == 4 {
		local spaces " "
	}
	#delimit ;
	di in smcl in gr _n
`"Variable |     Obs    Statistic    Std. Err.    `spaces'[`=strsubdp("level")'% Conf. Interval]"'
	_n "{hline 9}{c +}{hline 61}" ;
	#delimit cr

	local i 1
	while `i'<=$JK_l { 
		quietly count if ${JK_v`i'} != .
		di in smcl in gr "${JK_v`i'}" _col(10) "{c |}" 
		di in smcl in gr " overall {c |}" in yel %8.0f _result(1) /*
			*/ _col(23) %9.0g `all`i''
		quietly ci ${JK_v`i'}, level(`level')
		di in smcl in gr "  jknife {c |}" in yel /*
		 	*/ _col(23) %9.0g $S_3 /*
		 	*/ _col(35) %9.0g $S_4 /*
		 	*/ _col(51) %9.0g $S_5 /*
		 	*/ _col(63) %9.0g $S_6 
		global S_2 = `all`i''
		local i=`i'+1
	}
end
	

program define jk_clear
	version 4.0
	if "$JK_mark"=="jknife" {
		capture confirm integer number $JK_l
		if _rc==0 { 
			local i 1
			while `i'<=$JK_l {
				global JK_v`i'
				global JK_s`i'
				local i=`i'+1
			}
		}
	global JK_l
	global JK_cmd
	global JK_n
	global JK_cma
end

program define jk_setcm
	version 4.0
	parse "`*'", parse(" ()[],")
	local np 0
	local cma 0
	local i 1
	while "``i''" != "" {
		if "``i''"=="(" | "``i''"=="[" {
			local np = `np'+1
		}
		else if "``i''"==")" | "``i''"=="]" {
			local np = `np'-1
		}
		else if "``i''"=="," & `np'==0 {
			local cma= (!`cma')
		}
		local i=`i'+1
	}
	if `cma' {
		global JK_cma ","
	}
	else	global JK_cma
end
