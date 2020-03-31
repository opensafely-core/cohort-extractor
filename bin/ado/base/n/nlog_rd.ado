*! version 7.1.1  02feb2012

program define nlog_rd, sort
	version 7.0
	args todo b lnf g negH $nlog_clist
						/* main eqs */
	local i 1
	while `i' <= $nlog_l {
		tempvar beta`i' 
		mleval `beta`i'' = `b', eq(`i')
		local i = `i' + 1
	}
						/* taus */
	local i 1
	local k = $nlog_l+1 
	tempvar tau
	while `i' <= $nlog_l - 1 {
		tempvar tau`i'
		qui gen double `tau`i'' = 0 
		local nlog_tau `nlog_tau' `tau`i''
		local n = (`i'+1)*2
		local j 1
		while `j' <= $nlog_T[1,`i'] {
			mleval `tau' = `b', eq(`k') 
			qui replace `tau`i'' = `tau' if ${ML_y`n'} == `j'  
			drop `tau'
			local k = `k' + 1
			local j = `j' + 1
		}
		local i = `i' + 1
	}
	local bylist$nlog_l $nlog_id 
	local i = $nlog_l - 1
	while `i' > 0 {
		local j = `i' + 1
		local n = `j' * 2
		local bylist`i' `bylist`j'' ${ML_y`n'}
		local i = `i' - 1
	}
						/* level 1 */
	tempvar I1 p1
	qui gen double `p1' = exp(`beta1')
	qui bysort `bylist1': gen double `I1' = sum(`p1')
	qui by `bylist1': replace `I1' = `I1'[_N]
	qui replace `p1' = `p1'/`I1'
	qui replace `I1' = ln(`I1')
	local nlog_I `I1'
	local nlog_p `p1'
  						/* rest levels */
	local i 2 
	tempvar temp
	gen double `temp' = 0
	while `i' <= $nlog_l {
		tempvar I`i' p`i'
		local nlog_I `nlog_I' `I`i''
		local nlog_p `nlog_p' `p`i''
		local j = `i' - 1
		qui gen double `p`i'' = exp(`beta`i'' + `tau`j''*`I`j'')
		if `i' > 2 {
			qui replace `temp' = 0
		}
		qui bysort `bylist`j'' : replace `temp' = `p`i'' if _n == 1 
		qui by `bylist`i'' : gen double `I`i'' = sum(`temp')	
		qui by `bylist`i'' : replace `I`i'' = `I`i''[_N]
		qui replace `p`i'' = `p`i''/`I`i''	
		qui replace `I`i'' = ln(`I`i'')
		local i = `i' + 1
	}
	drop `temp'
						/* ln(p) = sum(ln(p`i')) */
	local i 1
	tempvar lnp
	qui gen double `lnp' = 0
	while `i' <= $nlog_l {
		qui replace `lnp' = `lnp' + ln(`p`i'')  
		local i = `i' + 1
	}	
	qui replace `lnp' = 0 if $ML_y1 == 0
	
	mlsum `lnf' = `lnp'
	if `todo' == 0 { exit }
						/* BEGIN getting gradients */
						/* main eqs */
	drop `lnp'
	cap matrix drop `g'
	tempvar touse di 
	tempname gk
	gen byte `touse' = 1
	gen double `di' = 0
	local i 1
	while `i' <= $nlog_l {
		if `i' > 1 {
			qui replace `touse' = 1
			qui replace `di' = 0
		}
		qui replace `c`i'' = 0
		if `i' > 1 {
			local k = `i' - 1
			qui bysort `bylist`k'': replace `touse' = 0 if _n != 1
		}
		local j = `i'
		while `j' <= $nlog_l {
			local m = (`j'-1)*2 + 1
			if `j' == $nlog_l {
				qui replace `di' =/*
				*/ (${ML_y`m'} - `p`j'') if `touse'
			}
			else {
				local k = 2*`j' + 1
				qui replace `di' = /*
				*/ (${ML_y`m'} - `p`j''*${ML_y`k'}) if `touse'
			}
			local k = `j' - `i'  
			while `k' >= 1 {
				local m = `k' + `i' - 1	
				qui replace `di' = `di'*`p`m''*`tau`m'' if `touse'
				local k=`k' - 1
			}
			qui replace `c`i'' = `c`i'' + `di'	
			local j = `j' + 1
			if `j' <= $nlog_l {
				qui replace `di' = 0
			}
		}
		mlvecsum `lnf' `gk' = `c`i'', eq(`i')
		matrix `g' = (nullmat(`g'),`gk')
		local i = `i' + 1
	}
	drop `touse' `di' 
	if $nlog_t == 0 { exit }
							/* taus */
	forvalues i=1/$nlog_t {
		local ci : word `=`i'+$nlog_l' of $nlog_clist
		local clist `clist' ``ci''
	}
	tempname g1 nlog_Tj
	tempvar dldt

	gen double `dldt' = -1
	matrix `g1' = J(1,$nlog_t,0)
	local l = $nlog_l-1 
	matrix `nlog_Tj' = J(1,`l',1)

	DlDtau `clist', l(`l') lj(1) tj(`nlog_Tj') g(`g1') inc(`nlog_I') ///
		p(`nlog_p') tau(`nlog_tau') bylist(`bylist$nlog_l')      ///
		dldt(`dldt')

	matrix `g' = (`g',`g1')
end	

program DlDtau, sortpreserve
	syntax varlist, l(integer) lj(integer) tj(string) g(string) ///
		inc(string) p(string) tau(string) bylist(string)    ///
		dldt(string)

	if `l' == 0 {
		exit
	}
	local clist `varlist'
	tempvar Ij pj tauj dldtj
	qui gen double `Ij' = .
	qui gen double `pj' = .
	qui gen double `tauj' = .
	qui gen double `dldtj' = .
	tempname gk
	if $nlog_unbal {
		tempvar miss
		gen int `miss' = 0
	}
	local l1 = `l'-1
	local l2 = 2*(`l'+1)
	local k = 0
	forvalues j=1/`l1' {
		local k = `k'+$nlog_T[1,`j']
	}
	local pl : word `=`l'+1' of `p'
	local Il : word `l' of `inc'
	local taul : word `l' of `tau'
	local j1 = `tj'[1,`l']
	local k = `k' + `j1' - 1
	local jn = ${nlog_T`l'}[1,`lj'] + `j1' - 1
	local bylist1 `bylist' ${ML_y`l2'}

	forvalues j=`j1'/`jn' {
		if `j' != `j1' {
			qui replace `Ij' = .
			qui replace `pj' = .
			qui replace `tauj' = .
			qui replace `dldtj' = .
		}
		local jlev = ${nlog_Tlev`l'}[1,`j']
		qui bysort `bylist': replace `Ij' = `Il'  ///
			if ${ML_y`l2'} == `jlev' 
		qui by `bylist' : replace `pj' = `pl'     ///
			if ${ML_y`l2'} == `jlev'
		qui by `bylist' : replace `tauj' = `taul' ///
			if ${ML_y`l2'} == `jlev'

		qui bysort $nlog_id (`Ij') : replace `Ij' = ///
			`Ij'[_n-1] if `Ij' == . 
		if $nlog_unbal {
			qui by $nlog_id : ///
				replace `miss' = sum(${ML_y`l2'}==`jlev')
			qui by $nlog_id : ///
				replace `miss' = (`miss'[_N]==0)
			qui replace `Ij' = 0 if `miss' 
		}
		qui bysort $nlog_id (`pj') : replace `pj' =  ///
			`pj'[_n-1] if `pj' == . 
		if $nlog_unbal {
			qui replace `pj' = 0 if `miss' 
		}

		qui bysort $nlog_id (`tauj') : replace `tauj' = ///
			`tauj'[_n-1] if `tauj' == . 
		if $nlog_unbal {
			qui replace `tauj' = 0 if `miss' 
		}
		
		qui replace `dldtj' = `pj'*`dldt'

		local ck : word `++k' of `clist'
		qui replace `ck' = cond($ML_y1,`Ij'* ///
			(cond(${ML_y`l2'}==`jlev',1,0)+`dldtj'),0)

		mlsum `gk' = `ck' 
		matrix `g'[1,`k'] = `gk'
		if `l1' > 0 {
			qui replace `dldtj' = cond(${ML_y`l2'}==`jlev', ///
				`tauj'-1,0)+`tauj'*`dldtj'

			DlDtau `clist', l(`l1') lj(`j') tj(`tj') g(`g') ///
			 inc(`inc') p(`p') tau(`tau') bylist(`bylist1') /// 
			 dldt(`dldtj')
		}
	}
	matrix `tj'[1,`l'] = `tj'[1,`l'] + ${nlog_T`l'}[1,`lj']
end

exit

Example 3 levels : (refer to Limdep manual page 591-592)

		math				code

p        = p(k|i,j)*p(j|i)*p(i)			p  = p1*p2*p3

I(ij)    = sum(p(k|i,j))			I1 = sum(p1), by(2,3)
	    k
I(i)     = sum(p(j|i))				I2 = sum(p2), by(3)	
       	    j	

p(k|i,j) = exp(beta1*x)/exp(I(ij))               p1 = exp(`beta1')/exp(I1)

p(i|j)   = exp(beta2*y + tauij*I(ij))/exp(I(i))  p2 = exp(`beta2' + tau1*I1)/..

p(i)     = exp(beta3*z + taui*I(i))/sum(...)     p3 = exp(`beta3' + tau2*I2)/.. 


gradients (use mlvecsum):

level 1:  use the whole dataset

dlnp1/db1 = (ML_y1 - p1*ML_y3)        	   
dlnp2/db1 = (ML_y3 - p2*ML_y5)*tau1*p1     
dlnp3/db1 = (ML_y5 - p3)*tau1*p1*tau2*p2

level 2: keep one obs for each level of ML_y3 within each id

dlnp2/db2 = (ML_y3 - p2*ML_y5)
dlnp3/db2 = (ML_y5 - p3)*tau2*p2

level 3: keep one obs for each level of ML_y5 within each id 

dlnp3/db3 = (ML_y5 - p3)

taus:

dlnp(j|i)/dtau(m|l) = 1(l=i)[1(m=j) - p(m|l)]*I(m|l)

dlnp(i)/dtau(m|l) = tau(i)[1(l=i) - p(l)]*p(m|l)*I(m|l)

dlnp(i)/dtau(l) = [1(l=i) - p(l)]*I(l)


