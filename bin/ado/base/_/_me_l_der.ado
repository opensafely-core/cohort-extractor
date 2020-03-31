*! version 1.0.0  25aug2000
program define _me_l_der, rclass
	version 6
	args 	X		/* matrix of evaluation points
	*/	predopt		/* option for predict 
	*/	lny		/* 1 : ln(y); 0 : y */

	tempname B eqnum dfdxbi dfdxb
	mat `B' = e(b)
	local ncol = colsof(`B')
	mat `eqnum' = J(1, `ncol', 1)	/* matrix stores equation numbers */
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
	local total = `eqnum'[1,`ncol'] 	/* how many equations */
	mat `dfdxb' = J(1, `total', 0) 
	local i = 1
	while `i' <= `total' {
		tempname b dfdx
		mat `b' = `B'
		local j = 1
		while `eqnum'[1,`j'] != `i' {
			local j = `j' + 1
		}
		local name : word `j' of `cname'
		cap confirm var `name'
		if _rc  {		   		/* constant only */
			_me_derb `X' `j' "`predopt'" `lny' /* df/dxb = df/db*/
			mat `dfdxb'[1,`i'] = r(dfdb)
		}
		else {						
			_me_der `X' `j' "`predopt'" `lny'
			scalar `dfdx' = r(dfdx)
			mat `dfdxb'[1,`i'] = `dfdx'/`b'[1,`j']
		} 
		local i = `i' + 1
	}	
	return matrix dfdxb  `dfdxb'
end

exit

 	F(X,B)	=	F(X_1B_1, X_2B_2, ... X_mB_m)
      
this program calculates:

	d F(X,B)
	--------
	d X_iB_i

if equation i is a constant only term

	d F(X,B)	d F(X, B)
	-------- = 	---------		call _me_derb to get dfdb	
	d X_iB_i 	  d B_i1

otherwise,

	d F(X,B)	d F(X, B)
	-------- = 	--------- / B_i1	call _me_der to get dfdx 
	d X_iB_i 	d X_i1
