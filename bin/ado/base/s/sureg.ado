*! version 4.4.0  13mar2018
program define sureg, eclass byable(recall)
	local vv : display "version " string(_caller()) ", missing:"
	version 6.0, missing

	if replay() {
		if `"`e(cmd)'"' != "sureg"  { error 301 }
		else {
			if _by() { error 190 }
			syntax [ , Corr noHeader noTable /*
				*/ Level(cilevel) *]
			_get_diopts diopts, `options'
			`vv' ///
			reg3 , level(`level') `header' `table' `diopts'
		}

	}
	else {
		local cmdline : copy local 0
		local stop 0
		while !`stop' { 
			gettoken eqn 0 : 0, parse(" ,[") match(paren)
			IsStop stop : `"`eqn'"'
			if !`stop' { 
				if "`paren'" != "" {
					local alleqn "`alleqn' (`eqn')"
				}
				else    local alleqn `alleqn' `eqn' 
			}
		}
		local 0 `"`eqn' `0'"'

		syntax [if] [in] [aw fw] [, Constraints(string) CORr /*
			*/ DFK DFK2 noHeader ITerate(int `c(maxiter)') Isure /*
			*/ Level(cilevel) NOLOg LOg SMall /*
			*/ noTable TOLerance(real 1e-6)  TRace *]

		_get_diopts diopts, `options'
		if "`isure'" != "" { local ireg3 "ireg3" }
		if "`constra'" != "" { local constra "constraint(`constra')" }

		marksample touse

		`vv' reg3 `alleqn' if `touse' [`weight'`exp'],		/*
			*/ `constra' `dfk'				/*
			*/ `dfk2' `header' iterate(`iterate') `ireg3'   /*
			*/ level(`level') `log' `nolog' `small' `table' /*
			*/ tolerance(`toleran') `trace' sure `diopts'

		/* saves for backward compatibility */

		if _caller()<6 {
			matrix S_E_rcv = e(Sigma)
		}
		local i 1
		while `i' <= e(k_eq) {
			global S_E_pv "$S_E_pv `e(p_`i')'"
			global S_E_f "$S_E_f `e(F_`i')'"
			global S_E_sd "$S_E_sd `e(rmse_`i')'"
			global S_E_r2 "$S_E_r2 `e(r2_`i')'"
			global S_E_par "$S_E_par `e(df_m`i')'"

			local i = `i' + 1
		}
		global S_E_elis `e(eqnames)'
		global S_E_neq `e(k_eq)'
		global S_E_tdf = e(N)*e(k_eq) - e(k)
		global S_E_nobs `e(N)'
		global S_E_cmd sureg
		if "`isure'" != "" {
			est local method "isure"
		}
		else {
			est local method "sure"
		}
		version 10: ereturn local cmdline `"sureg `cmdline'"'
		est local cmd sureg
		_post_vce_rank
	}

	if "`corr'" != "" {
		di
		di in gr "Correlation matrix of residuals:"
		tempname mymat 
		mat `mymat' = corr(e(Sigma))
		mat list `mymat', nohead format(%9.4f)
		tempname CCp
		mat `CCp' = `mymat' * `mymat''
		local tsig = (trace(`CCp') - e(k_eq))*e(N) / 2
		local df = `e(k_eq)' * (`e(k_eq)' - 1) / 2
		di
		di in gr "Breusch-Pagan test of independence: chi2(`df') = " /*
		*/ in ye %9.3f `tsig' in gr ", Pr = " %6.4f /*
		*/ in ye chiprob(`df',`tsig')

		est scalar chi2_bp = `tsig'
		est scalar df_bp   = `df'

		/* Double saves */
		global S_3 `e(df_bp)'
		global S_4 `e(chi2_bp)'
	}

end


program define IsStop
	args stop colon token
	if 	     `"`token'"' == "[" /*
		*/ | `"`token'"' == "," /*
		*/ | `"`token'"' == "if" /*
		*/ | `"`token'"' == "in" /*
		*/ | `"`token'"' == "" {
		c_local `stop' 1
	}
	else	c_local `stop' 0
end

