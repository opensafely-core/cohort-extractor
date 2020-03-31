*! version 1.2.0  19feb2019

program ivtob_lf

	version 8
	
	local lf `1'
	local xb `2'
	local pos = 2
        forvalues i = 1/$IVT_NEND {
                local j = `i' + `pos'
                local zp`i' ``j''
        }
        local pos = `pos' + $IVT_NEND
        tempname sigchol
        mat `sigchol' = I($IVT_NEND+1)
        loc row = 1
        loc col = 1
        loc np = 1 + $IVT_NEND + $IVT_NEND*($IVT_NEND+1) / 2 
        forvalues i = 1/`np' {
                loc j = `i' + `pos'
                mat `sigchol'[`row', `col'] = ``j''[_N] // sorted by touse
                loc row = `row' + 1
                if `row' > ($IVT_NEND + 1) {
                        loc col = `col' + 1
                        loc row = `col'
                }
        }

        tempname sigma
        mat `sigma' = `sigchol' * `sigchol''
        
        tempname sig21 sig22 sig22i
        mat `sig21' = `sigma'[2..., 1]
        mat `sig22' = `sigma'[2..., 2...]
        mat `sig22' = 0.5*(`sig22' + `sig22'')   // Guarantee symmetric
	mat `sig22i' = syminv(`sig22')

        loc enames ""
        forv i = 1/$IVT_NEND {
                tempvar e`i'
                loc j = `i' + 1
                qui gen double `e`i'' = ${ML_y`j'} - `zp`i''
                loc enames "`enames' `e`i''"
        }

        tempname scinv
	mat `scinv' = cholesky(`sig22i')
        mat colnames `scinv' = `enames'
        mat rownames `scinv' = `enames'

        tempname sc scvar scsum
        qui gen double `scsum' = 0
        forv i = 1/$IVT_NEND {
                mat `sc' = `scinv'[1..., `i']'
                cap drop `scvar'
                mat score double `scvar' = `sc'
                qui replace `scsum' = `scsum' + `scvar'^2
        }

        tempname det
        sca `det' = det(`sig22')
        tempvar lndens
        qui gen double `lndens' = ln(1 / ///
                ((2*_pi)^($IVT_NEND/2)*sqrt(`det'))*exp(-1*`scsum'/2)) ///
                
        tempname sige
        mat `sige' = `sig21''*`sig22i'*`sig21'
        sca `sige' = sqrt(`sigma'[1,1] - trace(`sige'))
        
        tempname sig22isig21
        mat `sig22isig21' = `sig22i'*`sig21'
        mat `sig22isig21' = `sig22isig21''
        mat colnames `sig22isig21' = `enames'
        tempvar m  
        mat score double `m' = `sig22isig21'
        qui replace `m' = (`m' + `xb')

	qui replace `lf' =   -0.5*ln(2*_pi) - 0.5*ln(`sige'^2) - ///
                (($ML_y1-`m')^2 / (2*`sige'^2)) ///
                if $ML_y1 > $IVT_ll & $ML_y1 < $IVT_ul
        qui replace `lf' = ln1m(norm((`m'-$IVT_ll) / `sige')) ///
                if $ML_y1 <= $IVT_ll
        qui replace `lf' = ln(norm((`m'-$IVT_ul)/`sige')) if $ML_y1 >= $IVT_ul
	qui replace `lf' = `lf' + `lndens'

end
