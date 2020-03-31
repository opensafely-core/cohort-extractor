*! version 1.0.1  10may2000
program define _me_der2, rclass 
	version 6 
	args 	X	/* matrix of evaluation points
	*/	i 	/* index of X matrix
	*/ 	j 	/* index of B matrix 
	*/      isdum   /* mark dummy or not (1: dummy, 0: continuous)
	*/	predopt /* prediction option 
	*/	lny	/* 1 : ln(y); 0 y */

	tempname est0 B
	est hold `est0', copy	
	preserve
	cap noi {
		mat `B' = e(b)
		tempname hb dmdb 
		local epsf 1e-3
		scalar `hb' = (abs(`B'[1, `j']) + `epsf')*`epsf' /*initial hb*/
		GetHb `hb' `X' `i' `B' `j' `isdum' "`predopt'" `lny' /* hb  */
		if `hb' == 0 {				       /* dmdb = 0   */
			scalar `dmdb' = 0
		}
		else 						/* get dmdb 
		*/ GetDmdb `dmdb' `hb' `X' `i' `B' `j' `isdum' "`predopt'" `lny'  

		return scalar dmdb = `dmdb'		      /* return dmdb */
		return scalar h = `hb'
	}
	restore
	est unhold `est0'
	if _rc! = 0 {
		exit _rc
	}
end

program define GetHb
	args hb X i B j isdum predopt lny
	tempname m0 m1 B1 goal0 goal1 diff lh uh 
	GetM	`m0' `X' `i' `B' `isdum' "`predopt'" `lny' /* get m0(X,B) */
	mat `B1' = `B'
	mat `B1'[1,`j'] = `B'[1,`j'] + `hb'
	GetM `m1' `X' `i'  `B1' `isdum' "`predopt'" `lny'  /* get m1(X,B+hb) */
	scalar `diff' = abs(`m0' - `m1') 		/* difference */
	if `diff' < abs(`m0' + 1e-8)*1e-8 {		/* dmdb = 0 */
		scalar	`hb' = 0
	}
	else {
		local ep0 1e-5
		local ep1 1e-3
		scalar `goal0' = abs(`m0'+`ep0')*`ep0'
		scalar `goal1' = abs(`m0'+`ep1')*`ep1'
		local flag1 1
		local flag2 1
		local count1 0
		local count2 0
		local out 1 
		while ((`diff' < `goal0') | `diff' > `goal1') & `out'  {
			if `diff' < `goal0' {
				scalar `lh' = `hb'
				local flag1 0
				local count1 = `count1' + 1
				if `flag2' {
					scalar `uh' = 2* `hb'
				}
			}
			else {
				scalar `uh' = `hb'
				local flag2 0
				local count2 = `count2' + 1
				if `flag1' {
					scalar `lh' = 0.5*`hb'
				}
			}
			scalar `hb' = (`lh' + `uh')/2
			if (`uh' - `lh') < abs(`B'[1, `j']+1e-8)*1e-8 {
			di in red "fail in getting second derivatives"
				exit 430
			}
			if (`count1' >= 5) & (`count2' == 0) {
				scalar `hb' = 0
				local out 0 
			}
			else {
				mat `B1'[1, `j']=`B'[1, `j'] + `hb'
			      GetM `m1' `X' `i' `B1'  `isdum' "`predopt'" `lny' 
				scalar `diff' = abs(`m0' - `m1')
			}
		}
	}
end

program define GetM, eclass
	args m X i B isdum predopt lny
	tempname V C
	mat `C' = `B'
	mat `V'= e(V)
	est post `C' `V', noclear
	if `isdum' {
		me_derd `X' `i' "`predopt'" `lny'
	}		
	else _me_der `X' `i' "`predopt'" `lny'
	scalar `m'=r(dfdx)
end

program define GetDmdb
	args dmdb hb X i B j isdum predopt lny
	tempname B1 m1 m2
	mat `B1' = `B'
	mat `B1'[1, `j'] = `B'[1,`j'] + `hb'/2
	GetM `m1' `X' `i' `B1' `isdum' "`predopt'" `lny'
	mat `B1'[1, `j'] = `B'[1,`j'] - `hb'/2
	GetM `m2' `X' `i' `B1' `isdum' "`predopt'" `lny' 
	scalar `dmdb' = (`m1'-`m2')/`hb'
end

				
