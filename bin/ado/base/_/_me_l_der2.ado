*! version 1.0.1  07feb2012
program define _me_l_der2, rclass
	version 6
	args 	X	/* at matrix 
	*/	predopt /* prediction option 
	*/	lny	/* 1: ln(y); 0: y */
	tempname B eqnum dmdxb dmdij
	mat `B' = e(b)
	local ncol = colsof(`B')
        mat `eqnum' = J(1, `ncol', 1)   /* matrix stores equation numbers */
        local ename : coleq `B'
        local cname : colname `B'
        if "`ename'" != "" {
                tokenize `ename'
                local j = 1
                local i = 1
                while "`1'" != "" {
                        mat `eqnum'[1,`i'] = `j'
                        if "`2'" != "`1'" {
                                local j = `j' + 1
                        }
                        mac shift
                        local i = `i' + 1
                }
	}	
	local total = `eqnum'[1,`ncol']         /* how many equations */
	mat `dmdxb' = J(`total', `total', 0)
	local i = 1
	while `i' <= `total' {
		local k = 1
		while `eqnum'[1,`k'] != `i' {
			local k = `k' + 1
		} 
		local j = 1
		while `j' <= `i' {
			local l = 1
			while `eqnum'[1, `l'] != `j' {
				local l = `l' + 1
			}
			local name : word `l' of `cname'
			cap confirm var `name'
			if _rc  {
				local namek ; word `k' of `cname'
				cap confirm var `namek'
				if `i' == `j' | _rc  {
					scalar `dmdij' = 0
				}
				else {
				Dxbxb `dmdij' `X' `l' `k' "`predopt'" `lny'
					scalar `dmdij' = `dmdij'/`B'[1,`l']	
				}
			}
			else {
				Dxbxb 	`dmdij' `X' `k' `l' "`predopt'" `lny'
				scalar  `dmdij' = `dmdij'/`B'[1,`l']
			}
			mat `dmdxb'[`i', `j'] = `dmdij'
			mat `dmdxb'[`j', `i'] = `dmdij'
			local j = `j' + 1 	
		}
		local i = `i' + 1
	}
	return mat dmdxb `dmdxb'
	return mat eqnum `eqnum'
end

program define Dxbxb
	args	dmdij		/*  dF/dX_iB_idX_jB_j
	*/	X		/*
	*/	k		/*  the index of the first variable of eq i 
	*/	l		/*  the index of the first variable of eq j
	*/	predopt		/*
	*/	lny		/* 1: ln(y), 0: y */

	tempname h
	local epsf 1e-3
	scalar `h' = (abs(`X'[1,`l']) + `epsf')*`epsf'		/* init h   */
	preserve
	cap noi {
		AddX `X'
		GetH `h' `X' `k' `l' "`predopt'" `lny'		/* choose h */ 	
		if `h' == 0 {
			scalar `dmdij' = 0
		}
		else GetDmdij `dmdij' `h' `X' `k' `l' "`predopt'" `lny'  
	}
	restore
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
	args h X k l predopt lny
	tempname f0 f1 goal0 goal1 diff lh uh X1
	GetF	`f0' `X' `k' "`predopt'" `lny'
	mat `X1' = `X'
	mat `X1'[1,`l'] = `X1'[1,`l'] + `h'
	GetF	`f1' `X1' `k' "`predopt'" `lny'
        scalar `diff' = abs(`f0' - `f1')                /* |f(x+h)-f(x)| */
        if `diff' < abs(`f0' + 1e-8)*1e-8 {             /* dmdxb = 0 */
                scalar  `h' = 0
        }
        else {
                local ep0 1e-5
                local ep1 1e-3
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
                        mat `X1'[1,`l'] = `X'[1,`l'] + `h'
                        GetF `f1' `X1' `k' "`predopt'" `lny'
                        scalar `diff' = abs(`f0' - `f1')
                }
        }

end

program define GetF
	args f X k predopt lny
	tempname B
	mat `B' = e(b)
	local cname : colname `B'
	local name : word `k' of `cname'
	cap confirm var `name'
	if _rc {
		_me_derb `X' `k' "`predopt'" `lny'
		scalar `f' = r(dfdb)
	}
	else {
		_me_der `X' `k' "`predopt'" `lny'
		scalar `f' = r(dfdx)/`B'[1,`k']
	}
end

program define GetDmdij
	args dmdij h X k l predopt lny
	tempname X1 f1 f2
	mat `X1' = `X'
	mat `X1'[1,`l'] = `X'[1,`l'] + `h'/2
	GetF `f1' `X1' `k' "`predopt'" `lny'
	mat `X1'[1,`l'] = `X'[1,`l'] - `h'/2
	GetF `f2' `X1' `k' "`predopt'" `lny'
	scalar `dmdij' = (`f1'-`f2')/`h'
end 

