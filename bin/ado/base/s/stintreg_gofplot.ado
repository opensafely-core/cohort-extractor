*! version 1.0.2  17sep2019
program stintreg_gofplot, sortpreserve

	version 15

	syntax [, OUTfile(string) ///
		  TOLerance(real 1e-8) /*UNDOCUMENTED*/ 	///
		  EPSilon(real 1e-6) /*UNDOCUMENTED*/ 		///
		  MAXIter(integer 1000) /*UNDOCUMENTED*/ * ]

	_get_gropts, graphopts(`options') gettwoway ///
			getallowed(RLOPts addplot LEGend)
	local options `"`s(graphopts)'"'
	local rlopts `"`s(rlopts)'"'
	local twowayopts `"`s(twowayopts)'"'
	local addplot `"`s(addplot)'"'
	local legend `"`s(legend)'"'
	_check4gropts rlopts, opt(`rlopts')

	preserve

	// compute csnell
	tempvar cs_l cs_r

	qui predict double `cs_l', csnell lower
	qui predict double `cs_r', csnell upper

	// compute npmle for csnell 
	stintreg_em `cs_l' `cs_r', tol(`tolerance') maxiter(`maxiter') ///
		    notable 

	// get timepoint and survivor function
	tempname mat outmat
	mat `mat' = r(M)

	mata: stintreg_pf("`mat'", "`outmat'")

	mat colnames `outmat' = csresid surv
	
	tempvar result
	qui svmat `outmat', names(`result')
	qui keep `result'1 `result'2
	qui drop if `result'1 == . & `result'2 == .
	qui drop if `result'2 < 1e-4  // drop when survival is close to 0 

	label data
	rename `result'1 csresid
	rename `result'2 surv
	label var csresid "Cox-Snell residuals"
	label var surv "S(t)"

	qui gen double cumhaz = -log(surv)
	label var cumhaz "Cumulative hazard"

	qui drop surv

	// outfile
	if `"`outfile'"' != "" {
		tokenize "`outfile'", parse(",")
		local 1 `1'
		qui save "`1'" `2' `3'
	}

	local yttl : var label cumhaz
	local xttl : var label csresid

	if `"`legend'"' == "" local legend off	

	// Graph
	if `"`addplot'"' != "" local draw nodraw

	graph twoway ///
	(line cumhaz csresid, ///
		sort ytitle(`"`yttl'"') xtitle(`"`xttl'"') `options' ) ///
	(line csresid csresid, ///
		sort `rlopts' ), legend(`legend') `twowayopts' `draw'

	if `"`addplot'"' != "" {
		restore
		graph addplot `addplot', norescaling
	}

end

mata: 

void function stintreg_pf(string scalar mat, string scalar outmat) 
{
	real matrix M, result, t2, S2, t_interval, S_interval
	real scalar n
	real colvector t0, t1, S0, S1, t, S, t_exact, S_exact 

	M = st_matrix(mat)
	n = rows(M)

	t0 = M[1..n,1]
	S0 = 1\M[1..(n-1),4]
	t1 = M[1..n,2]
	S1 = M[1..n,4] 

	t2 = t0, t1
	S2 = S0, S1
	t_exact = select(t1, t0:== t1)
	S_exact = select(S1, t0:== t1)
	t_interval = select(t2, t0:!= t1)
	S_interval = select(S2, t0:!= t1)
	
	t0 = t_interval[.,1]
	t1 = t_interval[.,2]
	S0 = S_interval[.,1]
	S1 = S_interval[.,2]
	t = t0\t1\t_exact
	S = S0\S1\S_exact

	result = t, S
	_sort(result,(1,2))
	st_matrix(outmat, result)
}

end

exit

