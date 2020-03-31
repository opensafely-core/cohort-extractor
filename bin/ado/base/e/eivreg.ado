*! version 3.0.4  15jul2019
program define eivreg, eclass byable(recall)
	version 6, missing
	local options "Level(cilevel)"
	if !replay() {
		local cmdline : copy local 0
		syntax varlist(fv) [if] [in] [aw fw] [,	///
			`options' Reliab(string) oldstderrors *]
		_get_diopts diopts, `options'
		local fvops = "`s(fvops)'" == "true" | _caller() >= 11
		tokenize `varlist'
		local dv `1'
		_fv_check_depvar `dv'
		mac shift
		local ivars "`*'"

		marksample touse

		tempname xpx xx xy xxi b bp ev mm vv ym2 rr i origxx
		qui mat accum `xpx' = `dv' `ivars' if `touse' [`weight'`exp']
		local nobs = r(N)
		if `nobs'<=0 | `nobs'>=. { error 2001 }
		local dim = rowsof(`xpx')
		local NN = `xpx'[`dim',`dim']

		mat `xx' = `xpx'[2..`dim',2..`dim']
		local indep : colnames `xx'
		local indep : subinstr local indep "_cons" "", all
		tokenize `"`indep'"', parse(" ")
		while ("`*'"!="") {
			_ms_parse_parts `1'
			if "`r(type)'" == "interaction" {
				forvalue k = 1(1)`r(k_names)' {
					local inter `inter' `r(name`k')'
				}
			}
			
			mac shift 1
		}
		local inter : list uniq inter

		mat `xxi' = syminv(`xx')
		local notcc = diag0cnt(`xxi')
		local nomit 0
		if `fvops' {
			tempname omit
			_ms_omit_info `xx'
			matrix `omit' = r(omit)
			local nomit = r(k_omit)
		}
		if `notcc' & `fvops' {
			local K = colsof(`omit')
			local notcc = 0
			forval k = 1/`K' {
				if `xxi'[`k',`k'] == 0 & `omit'[1,`k'] == 0 {
					local ++notcc
					continue, break
				}
			}
		}
		if `notcc' {
			di in red /*
			*/ "too few observations or collinear variables"
			exit 2001
		}
		mat drop `xxi'
		mat `origxx' = `xx'

		tokenize `"`reliab'"', parse(" ")
		tempname r
		mat `r' = J(1, `=`dim'-1', 1)
		while ("`*'"!="") {
			confirm variable `1'
			unabbrev `1'
			local 1 "`s(varlist)'"
			confirm number `2'
			local rlist "`rlist' `1' `2'"
			local rn = rownumb(`xx',"`1'")
			if `: list posof "`1'" in inter ' > 0 {
				di in red ///
			"cannot specify interaction variable `1' in reliab()"
				exit 198
			}
			if `rn'>=. { 
				di in red "`1' not independent variable"
				exit 111
			}
			if `2'<=0 | `2'>1 {
				di in red "0 < r <= 1 required"
				exit 399
			}
			local vvxx = `xx'[`rn',`rn']
			local vm = `xpx'[`dim',`rn'+1]
			mat `r'[1, `rn'] = `2'
			mat `xx'[`rn',`rn'] = /*
				*/ `vvxx' - (1-`2')*(`vvxx'-`vm'*`vm'/`NN')
			mac shift 2
		}
		local rlist "`rlist' * 1"
		mat `xy' = `xpx'[1,2..`dim']
		mat `xxi' = syminv(`xx')
		mat `b' = `xy' * `xxi'
		mat `ev' = (`b' * `xx') * `b''
		local Nmk = `NN' - `dim' + `nomit' + 1
		scalar `ym2' = (`xpx'[1,`dim'])^2/`NN'
		scalar `rr' = (`xpx'[1,1] - `ev'[1,1]) /(`Nmk')
					/* could be improved: */
		local r2 = (`ev'[1,1]-`ym2')/(`xpx'[1,1]-`ym2') 
		mat `vv' = ((`xxi' * `rr') * `origxx') * `xxi'

		if ("`oldstderrors'"=="") {
			tempvar wt one
			if ("`weight'`exp'") != "" {
				gen `wt' `exp'
			}
			else {
				gen byte `wt' = 1
			}

			qui gen byte `one' = 1
			local ivars `ivars' `one' 
			mata: getnewcov()
		}

		scalar `i'=1
		while `i' <= rowsof(`vv') {
			local notcc = `vv'[`i',`i']<=0 
			if `notcc' & `fvops' {
				if `omit'[1,`i'] {
					local notcc 0
				}
			}
			if (`notcc' | `r2' >= 1) {
				di in red "reliability r() too small"
				exit 399
			}
			scalar `i' = `i' + 1
		}

		est post `b' `vv' [`weight'`exp'], ///
			depname(`dv') dof(`Nmk') esample(`touse') buildfvinfo
		local colna : colna e(b)
		local cons _cons
		local colna : list colna - cons
		
		quietly test `colna'
		est scalar df_m = r(df)
		est scalar df_r = r(df_r)
		est scalar F = r(F)

		/* double save in S_E_<stuff> and e() */
		est scalar rmse = sqrt(`rr')
		est scalar N = `NN'
		est scalar r2 = `r2'
		est local rellist "`rlist'"
		global S_E_rmse `e(rmse)'
		global S_E_mdf `e(df_m)'
		global S_E_tdf `e(df_r)'
		global S_E_f `e(F)'
		global S_E_nobs `NN'
		global S_E_r2 `r2'
		global S_E_rvn "`rlist'"
		if "`weight'`exp'" != "" {
			est local wtype `"`weight'"'
			est local wexp `"`exp'"'
		}
		est local depvar "`dv'"
		est local predict "eivreg_p"
		est local marginsok default XB
		version 10: ereturn local cmdline `"eivreg `cmdline'"'
		est local cmd "eivreg"
		global S_E_cmd "eivreg"
		_post_vce_rank
	}
	else {
		if ("`e(cmd)'"!="eivreg") { error 301 }
		if _by() { error 190 }
		syntax [, `options' *]
		_get_diopts diopts, `options'
	}

	di in gr _n _col(20) "assumed" /*
		*/ _col(49) "Errors-in-variables regression" _n /*
		*/ _col(5) "variable" _col(18) "reliability"  
	di in smcl in gr "{hline 28}" /*
		*/ _col(49) "Number of obs" _col(67) "= " in ye %10.0fc e(N)

	tokenize "`e(rellist)'", parse(" ")
	local k 1
		while "`1'"!="" {
			di in gr %12s abbrev("`1'",12) _col(16) %10.4f `2' _col(49) _c
			mac shift 2
			if `k'==1 {
				di in smcl /*
				*/ in gr "F(" %3.0f e(df_m) "," %10.0f e(df_r) ")" /*
				*/ _col(67) "=   " /*
				*/ in ye %8.2f e(F)
			}
			else if `k'==2 {
				di in smcl in gr "Prob > F" _col(67) "=   " /*
				*/ in ye %8.4f fprob(e(df_m),e(df_r),e(F))
			}
			else if `k'==3 {
				di in smcl in gr "R-squared" _col(67) "=   " /*
				*/ in ye %8.4f e(r2)
			}
			else if `k'==4 {
				di in smcl in gr "Root MSE" _col(67) "=   " /*
				*/ in ye %8.0g e(rmse)
			}
			else    di
			local k=`k'+1
		}
		while `k'<=4 {
			di _col(49) _c
			if `k'==2 {
				di in smcl in gr "Prob > F" _col(67) "=   " /*
				*/ in ye %8.4f fprob(e(df_m),e(df_r),e(F))
			}
			else if `k'==3 {
				di in smcl in gr "R-squared" _col(67) "=   " /*
				*/ in ye %8.4f e(r2)
			}
			else if `k'==4 {
				di in smcl in gr "Root MSE" _col(67) "=   " /*
				*/ in ye %8.0g e(rmse)
			}
			local k=`k'+1
		}	
	di
	_coef_table, level(`level') `diopts'
end

version 15

mata: 

void getnewcov()
{
	real scalar  	N, p, M
	real colvector 	y, wt, b, v
	real rowvector 	X_bar, r, s, rb	
	real matrix 	X, S, A, Xy, XX2, invA, result, H, G

	st_view(y=., ., st_local("dv"), st_local("touse"))
	st_view(X=., ., st_local("ivars"), st_local("touse"))
	st_view(wt=., ., st_local("wt"), st_local("touse"))
	r = st_matrix(st_local("r"))
	N = rows(X)
	if (st_local("weight") == "aweight") {
		wt = wt/sum(wt)*N
	}
	M = sum(wt)
	p = cols(X)

	X_bar = mean(X, wt)	
	XX2 = (X :- X_bar):^2
	s = mean(XX2, wt)

	S = (1:-r):*s
	S = M*diag(S)
	
	A = cross(X,wt,X) :- S
	invA = invsym(A)
	Xy = cross(X,wt,y)
	b = cross(invA, Xy)

	v = y - cross(X',b)
	rb = (1:-r):*b'
	H = J(1, p, v):*X :+ XX2:*J(N,1,rb)

	if (st_local("weight") == "aweight") {
		wt = wt:^2
	}
	G = cross(H,wt,H)
	result = invA*G*invA

	st_replacematrix(st_local("vv"), result)
}

end

exit
