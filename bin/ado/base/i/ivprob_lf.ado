*! version 1.1.0  19feb2019

program ivprob_lf

	version 8.0
	
	local lf `1'
	local xb `2'
	local pos = 2
	forvalues i = 1/$IV_NEND {
		local j = `i' + `pos'
		local zp`i' ``j''
	}
	local pos = `pos' + $IV_NEND
	tempname sigchol
	mat `sigchol' = I($IV_NEND+1)
	loc row = 2
	loc col = 1
	loc np = $IV_NEND + $IV_NEND*($IV_NEND+1) / 2
	forvalues i = 1/`np' {
		loc j = `i' + `pos'
		mat `sigchol'[`row', `col'] = ``j''[_N] // sorted by touse
		loc row = `row' + 1
		if `row' > ($IV_NEND + 1) {
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
	forv i = 1/$IV_NEND {
		tempvar e`i'
		loc j = `i' + 1
		qui gen double `e`i'' = ${ML_y`j'} - `zp`i'' 
		loc enames "`enames' `e`i''"
	}
	
        tempname scinv
        mat `scinv' = cholesky(`sig22i')
	mat colnames `scinv' = `enames'
	mat rownames `scinv' = `enames'
	
	tempname sc scvar scsum det
	qui gen double `scsum' = 0
	scalar `det' = 0
	forv i = 1/$IV_NEND {
        	mat `sc' = `scinv'[1..., `i']'
        	cap drop `scvar'
		mat score double `scvar' = `sc'
		qui replace `scsum' = `scsum' + `scvar'^2 
		scalar `det' = `det' + ln(`scinv'[`i',`i'])
	}
	
	tempvar lndens
	qui gen double `lndens' = -$IV_CONST + `det' - `scsum'/2
	
	tempname sige
	mat `sige' = `sig21''*`sig22i'*`sig21'
	sca `sige' = sqrt(1 - trace(`sige'))
	
	tempname sig22isig21
	mat `sig22isig21' = `sig22i'*`sig21'
	mat `sig22isig21' = `sig22isig21''
	mat colnames `sig22isig21' = `enames'
	tempvar m
	mat score double `m' = `sig22isig21' 
	qui replace `m' = (`m' + `xb') / `sige'  
	
	qui replace `lf' = ln1m(norm(`m')) if $ML_y1 == 0
	qui replace `lf' = ln(norm(`m')) if $ML_y1 == 1
	qui replace `lf' = `lf' + `lndens'
	
end
