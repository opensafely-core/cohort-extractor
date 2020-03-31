*! version 1.1.9  28jan2015  
program define canon_8, eclass byable(recall)
	version 6.0, missing
	local options `"Level(cilevel)"'

	if !replay() {
		if bsubstr("`1'",1,1)=="(" {
			GetEq `0'
			local eq1 `s(name)'
			local vl1 `s(varlist)'

			GetEq `s(rest)'
			local eq2 `s(name)'
			local vl2 `s(varlist)'

			local 0 `"`s(rest)'"'
			sret clear
			if "`eq1'" == "" {
				local eq1 "u"
			}
			if "`eq2'"== "" { 
				local eq2 "v"
			}
		}
		else {
			local iseq True
			gettoken eq1 0 : 0, parse(" ,")
			gettoken eq2 0 : 0, parse(" ,")
		}

		syntax [aw fw] [if] [in] [, `options' noConstant LC(int 1) ]
		if "`constan'"=="" { 
			local dev "dev"
		}
		else 	local nocons "nocons" 

		marksample touse

		if "`iseq'"=="True" {
			eq ? `eq1'
			local vl1 `"`r(eq)'"'
			local eq1 `"`r(eqname)'"'
			eq ? `eq2'
			local vl2 `"`r(eq)'"'
			local eq2 `"`r(eqname)'"'
		}

		markout `touse' `vl1' `vl2'
		

		tempname ABC A B C Ai Ci T L LL SD V SD1 SD2
		tempname sse t r2 tt ccor
		tempvar xx yy

		qui mat accum `ABC' = `vl2' `vl1' if `touse' /*
			*/ [`weight'`exp'] , nocons `dev'
		local nobs = r(N)
		local nobs1 = `nobs' - 1
		scalar `sse' = 1/(`nobs1')
		mat def `ABC' = `ABC' * `sse' /* convert to covariance */
		local v2e = rowsof(`ABC')
		local v1e : word count `vl2'
		local v2 = `v1e' + 1
		mat `SD' = vecdiag(`ABC')
		mat `ABC' = corr(`ABC')
		mat `A' = `ABC'[1..`v1e',1..`v1e']
		mat `B' = `ABC'[1..`v1e',`v2'..`v2e']
		mat `C' = `ABC'[`v2'..`v2e',`v2'..`v2e']
		mat `Ai' = syminv(`A')
		mat `Ci' = syminv(`C')
		local n2e = `v2e' - `v1e'
		if (`n2e' > `v1e') {
			local r1list "vl1"
			local r2list "vl2"
			* looking for left symeigenvectors of B' Ai B Ci
			mat `SD1' = `SD'[1,`v2'..`v2e']
			mat `SD2' = `SD'[1,1..`v1e']
			mat `T' = (`B'' * `Ai') * `B'
			mat `L' = cholesky(`Ci')
			mat `T' = (`L'' * `T') * `L'
			mat symeigen `V' `LL' = `T'
			mat `LL' = `LL'[1,1..`v1e']
			local n2s = `v1e' + 1
			local XXi `Ai'
			local YYi `Ci'
			local XY `B''
		}
		else {
			local r1list "vl2"
			local r2list "vl1"
			local x `eq1'
			local eq1 `eq2'
			local eq2 `x'
			* looking for left symeigenvectors of B Ci B' Ai
			mat `SD2' = `SD'[1,`v2'..`v2e']
			mat `SD1' = `SD'[1,1..`v1e']
			mat `T' = (`B' * `Ci') * `B''
			mat `L' = cholesky(`Ai')
			mat `T' = (`L'' * `T') * `L'
			mat symeigen `V' `LL' = `T'
			mat `LL' = `LL'[1,1..`n2e']
			local n2s = `n2e' + 1
			local XXi `Ci'
			local YYi `Ai'
			local XY `B'
			local flip True
		}
		mat colnames `SD1' = `eq1':
		mat `SD1' = syminv(cholesky(diag(`SD1')))
		mat `V' = `L' * `V'       /* Undo the similarity transform */

		mat `L' = (`V''*`XY')*`XXi' 	/* the other lin. comb. */
		mat colnames `SD2' = `eq2':
		mat `SD2' = syminv(cholesky(diag(`SD2')))
		mat `V' = `V'' * `SD1'
		mat `V' = `V'[`lc',1...]  /* The linear combination we want */
		mat `L' = `L' * `SD2'
		mat `L' = `L'[`lc',1...]  /* The linear combination we want */
		scalar `r2' = `LL'[1,`lc']
		scalar `t' = 1 / sqrt(`r2')
		mat `L' = `L' * `t'
		mat `T' = `L',`V'
		local nv : colnames(`T')
		local ne : coleq(`T')

		/* conditional variance calculation */
		mat `XXi' = `SD2' * (`XXi' * `SD2')
		scalar `tt' = (1 - `r2')/`r2'/(1/`sse'-colsof(`XXi'))
		mat `XXi' = `XXi' * `tt'
		mat `YYi' = `SD1' * (`YYi' * `SD1')
		scalar `tt' = (1 - `r2')/`r2'/(1/`sse'-colsof(`YYi'))
		mat `YYi' = `YYi' * `tt'
		mat rownames `ABC' = `nv'
		mat roweq `ABC' = `ne'
		mat colnames `ABC' = `nv'
		mat coleq `ABC' = `ne'
		mat `ABC' = `ABC' * 0
		mat subst `ABC'[1,1] = `XXi'
		mat subst `ABC'[`n2s',`n2s'] = `YYi'

						/* post results */
		matrix `ccor' = vecdiag(cholesky(diag(`LL')))

		if "`flip'"=="" {		/* sic */
			mat `T' = (`T'[1,"`eq1':"], `T'[1,"`eq2':"])
			tempname Z
			mat `Z' = `ABC'["`eq1':", "`eq2':"] * 0
			mat `ABC' = ( /*
				*/ (`ABC'["`eq1':","`eq1':"], `Z'  ) \  /*
				*/ (`Z'', `ABC'["`eq2':","`eq2':"] )    /*
				*/ )
		}

		est post `T' `ABC', dof(`nobs1') esample(`touse')
		if _caller()<6 {
			mat S_E_ccor = `ccor'
		}
		est matrix ccorr `ccor'

		/* double save in S_E_<stuff> and e()  */
		est scalar N = `nobs'
		est scalar df = `nobs1'
		est scalar n_lc = `lc'
		global S_E_nobs `e(N)'
		global S_E_tdf `e(df)'
		global S_E_lc `e(n_lc)'

		est local predict "canon_8_p"
		est local cmd "canon"
		est local wtype "`weight'"
		est local wexp "`exp'"
		global S_E_cmd "canon"
	}
	else {
		if `"`e(cmd)'"'!="canon" { 
			error 301 
		}
		if _by() { error 190 }
		syntax [, `options']
		di
	}
	di _n in gr "Linear combinations for canonical correlation " e(n_lc) /* 
	*/ _col(56) "Number of obs =" in ye %8.0f e(N)
	est di, level(`level')
	di in gr _col(38) "(Standard errors estimated conditionally)"
	di in gr "Canonical correlations:"
	mat list e(ccorr), nohead nonames noblank format(%9.4f)
end


program define GetEq, sclass 
	sret clear
	gettoken open 0 : 0, parse("(") 
	if `"`open'"' != "(" {
		error 198
	}
	gettoken next 0 : 0, parse(")")
	while `"`next'"' != ")" {
		if `"`next'"'=="" { 
			error 198
		}
		local list `list'`next'
		gettoken next 0 : 0, parse(")")
	}
	sret local rest `"`0'"'
	tokenize `list', parse(" :")
	if "`2'"==":" {
		sret local name "`1'"
		mac shift 2
	}
	local 0 `*'
	syntax varlist
	sret local varlist "`varlist'"
end
