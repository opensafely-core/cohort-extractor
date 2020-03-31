*! version 1.0.1  10may2000
program define me_derd, rclass
	version 6 
	args 	X 	/* matrix of evaluation points
	*/	i 	/* index of the matrix 
	*/	predopt /* predict option */

	preserve
	tempname dfdx f1 f2 X1 
	cap noi {
		AddX `X'
		mat `X1'=`X'
		mat `X1'[1,`i'] = 1
		GetF `f1' `X1' `i' "`predopt'"
		mat `X1'[1,`i'] = 0
		GetF `f2' `X1' `i' "`predopt'"
		scalar `dfdx' = `f1' - `f2'
		return scalar dfdx = `dfdx'
		return scalar h = 1 
	}
	restore
	if _rc !=0 {
		dis in red "fail in getting f(x=1) - f(x=0)"
		exit _rc
	}
end

program define AddX
        args X
        local cname : colnames `X'
        tokenize "`cname'"
        local j=1
        while "``j''" != "" {
                if "``j''" != "_cons" {
			cap confirm var ``j''
			local rc1 _rc
			cap confirm new var ``j''
			local rc2 _rc
			if `rc1' == 0 | `rc2' == 0 {
                        	tempvar junk
                        	qui gen double `junk' = `X'[1,`j'] in 1
                        	cap drop ``j''
                        	rename `junk' ``j''
                	}
        	}
               	local j = `j' + 1
	}
end


program define GetF
        args f X i predopt
        tempname y Z
        local varlist : colnames `X'
	cap noi {
                local iname : word `i' of `varlist'
                tempvar junk
                qui gen double `junk' = `iname' in 1
                qui replace `junk' = `X'[1,`i'] in 1
                drop `iname'
                rename `junk' `iname'
                qui predict double `y', `predopt'
                scalar `f' = `y'[1]
        }
end
