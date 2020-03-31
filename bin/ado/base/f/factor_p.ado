*! version 1.0.2  01nov2018
program factor_p, rclass
	version 8

// check that factor scoring is possible

	if "`e(cmd)'" != "factor" {
		dis as err "factor estimation results not found"
		error 301
	}
	
	if e(f) == 0 { 
		dis as err "no factors retained"
		exit 321
	}	

	local vnames : rownames e(C)
	unab evnames : `vnames' 
	if !`:list evnames == vnames' { 
		dis as err "impossible to predict; variables not found"
		exit 111
	}
	capture noisily confirm numeric variable `vnames'
	if _rc {
		dis as err "impossible to predict;"
		dis as err "factor variables no longer numeric"
		exit 111
	}
	local nvar : list sizeof vnames

// parsing and input checking

	#del ;
	syntax  anything(name=vlist)  [if] [in] 
	[,
		Bartlett     // Bartlett's factor score estimator
		REGression   // regression factor score estimator
		Thompson     // undocumented 
		
		noRotated    // help says: noROTated 
		             // shorter form for backward comp with -score-
		noTABle 
		FORmat(str) 
	] ; 
	#del cr

	local what `bartlett' `regression' `thompson' 
	if `:list sizeof what' > 1 {
		opts_exclusive "`what'" 
	}

	if ("`rotated'" == "") & ("`e(r_criterion)'" != "") {
		local rtxt     "; based on `e(r_ctitle)' rotated factors"
		local rprefix  "r_"
	}
	else if ("`rotated'" != "") & ("`e(r_criterion)'" != "") {
		local rtxt     "; based on unrotated factors"
		local rprefix
	}
	else { 		
		local rtxt
		local rprefix
	}

	if "`what'" == "" {
		local regression regression
		dis as txt "(option {bf:regression} assumed; regression scoring)"
	}

	local nv = e(f)
	if strpos("`vlist'","*") {
		_stubstar2names `vlist', nvars(`nv')
		local varlist `s(varlist)'
		local typlist `s(typlist)'
	}
	else {
		local myif `if'
		local myin `in'
		local 0 `vlist'
		syntax newvarlist(numeric)
		local if `myif'
		local in `myin'
	}
	local nf : list sizeof varlist
	if `nf' > e(f) {
		// this behavior is for backward compatibility
		dis as txt "(excess variables dropped)"
		local nf = e(f)
	}

// compute matrix SC of Scoring Coefficients

	// the coefficients are stored as a #vars x #factors matrix
	// some references define the transpose.

	tempname b fj Load SC means sds

	local C   e(C)             // correlation matrix
	local L   e(`rprefix'L)    // loading matrix
	local Phi e(`rprefix'Phi)  // variance matrix of common factors 
	local Psi e(Psi)           // uniqueness

	if "`regression'" != "" {
		// see Harman (1967, 2nd ed): page 352: (16.20)
		
		local title regression
		matrix `SC' = syminv(`C')*`L'*`Phi'
	}
	else if "`bartlett'" != "" {
		// see Harman (1967, 2nd ed): page 370: (16.57)
	
		local title Bartlett
		tempname Ipsi
		matrix `Ipsi' = syminv(diag(`Psi'))
		matrix `SC'   = `Ipsi'*`L'*syminv(`L''*`Ipsi'*`L')
	}
	else if "`thompson'" != "" {
		// see Mardia-Kent-Bibby: page 9.7.4
	
		local title Thompson
		tempname Ipsi
		matrix `Ipsi' = syminv(diag(`Psi'))
		matrix `SC'   = `Ipsi'*`L'*syminv(I(e(f)) + `L''*`Ipsi'*`L')
	}
	else {
		_stata_internalerror
	}
	
// display scoring coefficients

	if "`table'" == "" {
		if `"`format'"' == "" { 
			local format %8.5f
		}
		
		matlist `SC' , left(4) rowtitle(Variable) border(row)   ///
		   title(Scoring coefficients (method = `title'`rtxt')) ///
		   format(`format') 
		display
	}

// means() and sds()

	if "`e(means)'" != "matrix" {
		dis in smcl as txt /// 
			"{p}(variable means assumed 0; use means()" ///
			" option of factormat for nonzero means){p_end}"
		matrix `means' = J(1,`nvar',0)
	}
	else {
		matrix `means' = e(means)
	}

	if "`e(sds)'" != "matrix" {
		dis in smcl as txt ///
			"{p}(variable std. deviations assumed 1; use sds()" ///
			" option of factormat to change){p_end}"
		matrix `sds' = J(1,`nvar',1)
	}
	else {
		matrix `sds' = e(sds)
	}

// create scores

	marksample touse, novarlist
	forvalues j = 1 / `nf' {
		capture drop `fj'
		gen double `fj' = 0

		local i = 0
		foreach v of local vnames {
			quietly replace `fj' = `fj' + ///
			   `SC'[`++i',`j'] * /// 
			   ((`v'-`means'[1,`i'])/`sds'[1,`i']) if `touse'
		}

		gettoken vn varlist : varlist
		gettoken tp typlist : typlist
		// kth: should we display #mv's ?
		quietly gen `tp' `vn' = `fj' if `touse'
		label var `vn' "Scores for factor `j'"
	}

// saved results

	return local method `title'
	return matrix scoef = `SC'
end
exit

References

  Harman, chapter 16
  
  Mardia, Kent,Bibby: section 9.7
  
  Seber (1984), Multivariate Observations, New York: Wiley
     Pages 220 e.a. on Factor scores
       
       

