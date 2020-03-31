*! version 1.0.2  14jan2020
program _gsem_eret_sd, eclass
	version 15
	tempname b V pclass
	mat `b' = e(b_sd)
	mat `V' = e(V_sd)
	if "`e(b_sd_pclass)'" == "matrix" {
		mat `pclass' = e(b_sd_pclass)
	}
	else {
		mat `pclass' = e(b_pclass)
		mat `pclass' = e(b_pclass)
		local dim = colsof(`pclass')
		_b_pclass cov : cov
		_b_pclass corr : corr
		_b_pclass tanh : tanh
		forval i = 1/`dim' {
			if `pclass'[1,`i'] == `cov' {
				matrix `pclass'[1,`i'] = `corr'
			}
			if `pclass'[1,`i'] == `tanh' {
				matrix `pclass'[1,`i'] = `corr'
			}
		}
		matrix colname `pclass' = `:colfullname `b''
	}
	local family = e(family)
	ereturn post `b' `V'
	ereturn matrix b_pclass `pclass'
	ereturn scalar mecmd = 1
	ereturn scalar gsem_vers = 3
	ereturn local family "`family'"
	ereturn local cmd2 "meglm"
	ereturn local cmd "estat sd"
end

