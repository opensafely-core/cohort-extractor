*! version 1.0.2  07feb2012
program define _me_derb, rclass
	version 6
	args	X	/* matrix of evaluation points
	*/	i	/* index of B matrix
	*/	predopt /*
	*/ 	lny	/* 1 : ln(y); 0 y */ 
	
	tempname est0 B
	est hold `est0', copy
	preserve
	cap noi {
		AddX `X'					/* add obs X */
		mat `B' = e(b)
		tempname h dfdb
		local epsf 1e-6
		scalar `h' = (abs(`B'[1,`i']) + `epsf')*`epsf'	/* init h    */
		GetH `h' `X' `B' `i' "`predopt'" `lny'	 	/* choose h  */
	 	if `h' == 0 {
			scalar `dfdb' = 0
		}
		else GetDfdb `dfdb' `h' `B' `i' "`predopt'" `lny' /* get dfdb */
		return scalar dfdb = `dfdb'
		return scalar h = `h'
	}
	restore
	est unhold `est0'
	if _rc != 0 {
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
                        local rc1 = _rc
                        cap confirm new var ``j''
                        local rc2 = _rc
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

program define GetH
	args  h X B i predopt lny 
	tempname f0 f1 B1 goal0 goal1 diff lh uh
	GetF	`f0' `B' "`predopt'" `lny'
	mat `B1' = `B'
	mat `B1'[1,`i'] = `B'[1,`i'] + `h'
	GetF	`f1' `B1' "`predopt'" `lny'
	scalar `diff' = abs(`f0' - `f1')
	if `diff' < abs(`m0' + 1e-8)*1e-8 {             /* dfdb = 0 */
                scalar  `h' = 0
        }
	else {
	        local ep0 1e-7
                local ep1 1e-6
                scalar `goal0' = abs(`f0'+`ep0')*`ep0'
                scalar `goal1' = abs(`f0'+`ep1')*`ep1'

	/* we want h such that goal0 < diff < goal1     */

                local flag1 1
                local flag2 1

                while (`diff' < `goal0' | `diff' > `goal1' ) {
                        if `diff' < `goal0' {
                                scalar `lh' = `h'
                                local flag1 0
                                if `flag2' {
                                        scalar `uh' = 2*`h'
                                }
                        }
                        else {
                                scalar `uh' = `h'
                                local flag2 0
                                if `flag1' {
                                        scalar `lh' = 0.5*`h'
                                }
                        }
                        scalar `h' = (`lh'+`uh')/2
                        if (`uh'-`lh') < 1e-15 {
                        dis in red "fail in getting numerical derivatives"
                                exit 430
                        }
                        mat `B1'[1,`i'] = `B'[1,`i'] + `h'
                        GetF `f1' `B1' "`predopt'" `lny'
                        scalar `diff' = abs(`f0' - `f1')
                }
        }
end

program define GetF, eclass
	args f B predopt lny
	tempname y  V C
	mat `C' = `B' 
	mat `V' = e(V)
	est post `C' `V', noclear
	$T_mfver qui predict double `y' in 1, `predopt'
	if `lny' { scalar `f' = ln(`y'[1]) }
	else scalar `f' = `y'[1]
end

program define GetDfdb
	args dfdb h B i predopt lny
	tempname B1 f1 f2
	mat `B1' = `B'
	mat `B1'[1,`i'] = `B'[1, `i'] + `h'/2
	GetF `f1' `B1' "`predopt'" `lny'
	mat `B1'[1,`i'] = `B'[1, `i'] - `h'/2
	GetF `f2' `B1' "`predopt'" `lny'
	scalar `dfdb' = (`f1' - `f2') / `h'
end

/*
this program is to calculate 

		d F(X, B)
	      -------------
	       	  d B_i
*/
