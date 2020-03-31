*! version 1.0.0  16jan2017

program define _asmixtest, eclass

        syntax [ , svy noADJust noSVYadjust ]
	
	tempname b out
        mat `b'   = e(b)
        mat `out' = e(fg2)
        ereturn local df_m
        ereturn local F
        ereturn local chi2
        ereturn local chi2type
        ereturn local p
        if ("`svy'" != "" & "`adjust'`svyadjust'" != "") {
                local adjust nosvyadjust
        }
        else local adjust
        local cfnames : colfullnames `b'
        local cnames  : colnames     `b'
        local ceqs    : coleq        `b'
        local ncols   : colsof       `b'
        local ncolsix : colsof       `out'
        forval c = 1/`ncolsix' {
                local pos = `out'[1,`c']
                local idx1 `idx1' `pos'
        }
        forval c = 1/`ncols' {
                local idx2 `idx2' `c'
        }
        local idx : list idx2 - idx1
        local cnt = 1
        foreach c of numlist `idx' {
                local weq : word `c' of `ceqs'
                local weqs `weqs' `weq'
                local icons : word `c' of `cnames'
                local cfn   : word `c' of `cfnames'
                if (`cnt' > 1) local accum accum
                if ("`icons'" != "_cons") {
                        qui test _b[`cfn'] = 0, `accum' `adjust'
                }
                local ++cnt
        }
        local weqs : list uniq weqs
        local k_eq_model : list sizeof weqs
        ereturn scalar k_eq_model = `k_eq_model'
        if ( !missing(e(df_r)) ) {
                ereturn scalar F = r(F)
        }
        else {
                ereturn scalar chi2 = r(chi2)
                ereturn local chi2type Wald
        }		
        ereturn scalar df_m = r(df)
        ereturn scalar p    = r(p)

end

