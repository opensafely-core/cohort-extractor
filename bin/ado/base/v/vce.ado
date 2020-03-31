*! version 2.3.0  10may2016
program vce, rclass
	version 9

	if "`e(cmd)'" == "" {
		dis as err "last estimation result not found"
		exit 301
	}
	
	if has_eprop(V) {
		FullV `0'
	}
	else if has_eprop(diagV) {
		DiagV `0'
	}
	else if has_eprop(V_nonames)  { 
		// -anova- and -manova- have no names on the matrix stripe
		// and must be handled specially
		NonameV `0'
	}
	else if has_eprop(noV){
		dis as err /// 
		   "estimation result does not contain a valid VCE e(V)"
		exit 321
	}
	else {
		dis as err "e(properties) does not describe the status of e(V)"
		exit 322
	}
	
	return add
end

// ---------------------------------------------------------------------  FullV

program FullV, rclass
	version 9
	#del ;
	syntax [, COVariance
	          Correlation
	          Rho             // undocumented; backward compatibility
	          EIgen
	          EQuation(str asis)
	          Block
	          Diag
	          Format(str)
	          noLINes 
	          
	          TOL(str)
		  *
	] ;
	#del cr

	_get_diopts diopts, `options'
	if "`rho'" != "" & "`correlation'" != "" {
		dis as err "options correlation and rho are synonyms"
		exit 198
	}
	if "`rho'" != "" {
		local correlation correlation
	}
	if "`correlation'" != "" & "`covariance'" != "" {
		dis as err "options correlation and covariance are exclusive"
		exit 198
	}

	if "`correlation'" == "" {
		local copt  "cov"
		local ctype "covariance"
	}
	else {
		local copt  ""
		local ctype "correlation"
	}
	
	if `"`tol'"' != "" { 
		capture confirm number `tol' 
		if _rc {
			dis as err "option tol() invalid"
			exit 198
		}
		local eigen eigen	// tol() implies eigen
	}	

	if `"`format'"' != "" {
		if bsubstr(`"`format'"',1,1) != "%" {
			local format %`format'
		}
		
		// triggers error message if invalid numeric format
		local junk : display `format' -1
	}
	
	if "`block'" != "" & "`diag'" != "" {
		opts_exclusive "block diag"
	}

	if "`eigen'" != "" & `"`equation'`block'`diag'`format'`lines'"' != "" {
		dis as error in smcl "{p}eigen not allowed with equation(), " ///
			 "block, diag, nolines, or format() options{p_end}"
		exit 198
	}
	
/*
	if `"`equation'`block'`diag'`format'`eigen'"' == "" {
		correlate, _coef `copt'
		exit
	}
*/

// extract information

	tempname V
	matrix `V' = e(V)

	upRowCol `V', `diopts'

	if "`correlation'" != "" {
		MyCorr `V' 
	}

// eigenanalysis

	if "`eigen'" != "" {
		Full_Eigen `V' "`ctype'" "`tol'" 
		return add
		exit
	}

// select by equation

	if `"`equation'"' != "" & "`diag'`block'" == "" {
		local block block
	}
	if `"`equation'"' != "" {
		Full_EqSelect `V' `"`equation'"'
		local eqn "of selected equations "
	}

// display

	if "`format'" == "" {
		if "`correlation'" != "" {
			local format %8.4f
		}
		else {
			local format %10.0g
		}
	}

	if "`block'" != "" {
		Full_Blocks `V' "`ctype'" "`format'"
	}
	else if "`diag'" != "" {
		Full_Diags  `V' "`ctype'" "`format'"
	}
	else {
		local Ctype = proper("`ctype'")
		dis _n as txt ///
		   `"`Ctype' matrix `eqn'of coefficients "' ///
		   `"of {res:`e(cmd)'} model"'

		local lopt = cond("`lines'"=="", "eq", "oneline")
		
		version 11: ///
		matlist `V', lines(`lopt') /// 
		   format(`format') rowtitle(e(V)) colorcoleq(res)
	}

	return matrix V = `V' // selected part of V
end


program Full_Blocks
	version 9
	args A ctype format

	local req : rowlfnames `A' , quote
	local req : list uniq req
	local nr  : list sizeof req

	local ceq : collfnames `A' , quote
	local ceq : list uniq ceq
	local nc  : list sizeof ceq

	tempname Ab

	dis as txt _n proper("`ctype'") ///
	    " matrix of coefficients of {res:`e(cmd)'} model"

	local issymm = issym(`A')
	forvalues i = 1 / `nr' {
		local ieq : word `i' of `req'
		if bsubstr("`ieq'",1,1) != "/" {
			local IEQ `"`ieq':"'
		}
		else	local IEQ : copy local ieq
		local nj = cond(`issymm', `i', `nc')
		forvalues j = 1 / `nj' {
			local jeq : word `j' of `ceq'
			if bsubstr("`jeq'",1,1) != "/" {
				local JEQ `"`jeq':"'
			}
			else	local JEQ : copy local jeq
			matrix `Ab' = `A'[`"`IEQ'"',`"`JEQ'"']
			matrix coleq `Ab' = _
			matrix roweq `Ab' = _

			if `"`ieq'"' != `"`jeq'"' {
				dis as txt _n "  `ctype's of equation " /// 
				    as res `"`ieq' "' ///
				    as txt "(row) by equation " ///
				    as res `"`jeq' "' as txt "(column)"
			}
			else if `"`ieq'"' != "_" {
				dis as txt _n "  `ctype's of equation " /// 
				    as res `"`ieq'"'
			}
			else {
				dis as txt _n "`ctype'"
			}

			version 11: ///
			matlist `Ab', noheader format(`format') left(4) ///
				colorcoleq(res)
		}
	}
end


program Full_Diags
	version 9
	args A ctype format

	local req : rowlfnames `A' , quote
	local req : list uniq req
	local ceq : collfnames `A' , quote
	local ceq : list uniq ceq

	local eqns : list req & ceq
	if `"`eqns'"' == "" {
		dis as err "no diagonal elements selected"
		exit 198
	}

	dis as txt _n proper("`ctype'") ///
	    " matrix of coefficients of {res:`e(cmd)'} model"

	tempname Ab
	foreach eq of local eqns {
		if bsubstr("`eq'",1,1) != "/" {
			local EQ `"`eq':"'
		}
		else	local EQ : copy local eq
		matrix `Ab' = `A'[`"`EQ'"',`"`EQ'"']
		matrix coleq `Ab' = _
		matrix roweq `Ab' = _
		
		dis _n as txt "  `ctype' matrix of equation " ///
		       as res `"`eq' "'
		       
		version 11: ///
		matlist `Ab', format(`format') left(4) colorcoleq(res)
	}
end


program Full_EqSelect
	args V slct

	local eq  : rowlfnames `V' , quote
	local eq  : list uniq eq
	local neq : list sizeof eq

	local has_fp : rownfreeparms `V'
	if `has_fp' {
		gettoken rslct rest : slct , parse("\") quotes
		if bsubstr(`"`rest'"',1,1) == "\" {
			local cslct = bsubstr(`"`rest'"', 2, .)
		}
	}
	else {
		gettoken rslct rest : slct , parse("\/") quotes
		if inlist(bsubstr(`"`rest'"',1,1), "\", "/") {
			local cslct = bsubstr(`"`rest'"', 2, .)
		}
	}
	if (trim(`"`rslct'"') == "*")  local rslct : copy local eq
	if (trim(`"`cslct'"') == "*")  local cslct : copy local eq
	if (trim(`"`rslct'"') == "" )  local rslct : copy local cslct
	if (trim(`"`cslct'"') == "" )  local cslct : copy local rslct

	local rslct  : list uniq rslct
	local cslct  : list uniq cslct
	local nrslct : list sizeof rslct
	local ncslct : list sizeof cslct

	// check that all equations occur in e(V)
	local rcslct : list rslct | cslct
	local rcslct : list uniq rcslct 
	local diff : list rcslct - eq
	if `"`diff'"' != "" {
		dis as err `"equation(s) not found; `diff'"'
		exit 198
	}
	
	// dis `" slct:|`slct'|"'
	// dis `"rslct:|`rslct'|"'
	// dis `"cslct:|`cslct'|"'

	// induced matrix
	tempname arow newV
	forvalues i = 1/`nrslct' {
		local ieq : word `i' of `rslct'
		if bsubstr("`ieq'",1,1) != "/" {
			local ieq `"`ieq':"'
		}
		capture matrix drop `arow'
		forvalues j = 1/`ncslct' {
			local jeq : word `j' of `cslct'
			if bsubstr("`jeq'",1,1) != "/" {
				local jeq `"`jeq':"'
			}
			mat `arow' = nullmat(`arow'), ///
			             `V'[`"`ieq'"',`"`jeq'"']
		}
		mat `newV' = nullmat(`newV') \ `arow'
	}
	matrix `V' = `newV'
end


program Full_Eigen, rclass
	version 9
	args V ctype Tol

	tempname L Ev tol trace lndet cond

	local k = colsof(`V')
	matrix symeigen `L' `Ev' = `V'
	matrix `Ev' = `Ev''

	if "`Tol'" == "" { 
		scalar `tol' = max(abs(`Ev'[1,1]),abs(`Ev'[`k',1])) * 2.2e-16
	}
	else {
		scalar `tol' = abs(`Tol')
	}	
	
	scalar `trace' = 0
	scalar `lndet' = 0
	local npos  = 0
	local nneg  = 0
	local nzero = 0
	forvalues i = 1 / `k' {
		if `Ev'[`i',1] > `tol' {
			local ++npos
			scalar `trace' = `trace' + `Ev'[`i',1]
			scalar `lndet' = `lndet' + ln(`Ev'[`i',1])
		}
		else if `Ev'[`i',1] < - `tol' {
			local ++nneg
		}
		else {
			local ++nzero
			local izero `izero' `i'
		}
	}

	if `k' == `npos' {
		scalar `trace' = chop(`trace',`trace'*1e-8)
		scalar `cond'  = `Ev'[1,1] / `Ev'[`k',1]

		dis _n as txt "Eigenanalysis of positive-definite " /// 
		              "`ctype' matrix V" _n
		           
		dis _col( 5) as txt "Trace = sum ev " /// 
		    _col(40) as res %9.0g `trace'
		    
		dis _col( 5) as txt "ln(determinant) = sum ln(ev) " /// 
		    _col(40) as res %9.0g `lndet'
		    
		dis _col( 5) as txt "Condition number = max(ev)/min(ev) " /// 
		    _col(40) as res %9.0g `cond'

		matrix `Ev' = `Ev' , (1/`Ev'[1,1])*`Ev'
		
		matrix colnames `Ev' = absolute relative

		version 11: ///
		matlist `Ev', format(%13.7g) twidth(12) row(Eigenvalues) ///
		   left(4) names(all) border(row) colorcoleq(res)

		return scalar trace = `trace'
		return scalar lndet = `lndet'
		return scalar cond  = `cond'
	}
	
	else if `nneg' == 0 {
		dis _n as txt "Eigenanalysis of positive-semidefinite " /// 
		              "`ctype' matrix V" _n

		dis _col( 5) as txt "Number of eigenvalues > tol" /// 
		    _col(40) as res %9.0f `npos'
		            
		dis _col( 5) as txt "Number of eigenvalues [-tol,tol]" /// 
		    _col(40) as res %9.0f `nzero'
		            
		dis _col( 5) as txt "Tolerance tol" /// 
		    _col(40) as res %9.0g `tol'

		dis as txt _n "    Eigenvalues of V"
		version 11: ///
		matlist `Ev', format(%12.7g) twidth(12) left(4) /// 
		   names(row) border(row) noblank colorcoleq(res)

		return scalar npos  = `npos'
		return scalar nzero = `nzero'
	}
	
	else {
		dis _n as txt "This is not a valid `ctype' matrix V" _n

		dis _col( 5) as txt "Number of eigenvalues > tol" /// 
		    _col(40) as res %9.0f `npos'
		    
		dis _col( 5) as txt "Number of eigenvalues [-tol,tol] " /// 
		    _col(40) as res %9.0f `nzero'
		    
		dis _col( 5) as txt "Number of eigenvalues < -tol " /// 
		    _col(40) as res %9.0f `nneg'
		    
		dis _col( 5) as txt "Tolerance tol" /// 
		    _col(40) as res %9.0g `tol'

		dis as txt _n "    Eigenvalues of V"
		version 11: ///
		matlist `Ev', for(%12.7g) tw(12) left(4) names(row) /// 
		   border(row) noblank colorcoleq(res)
	}

	return matrix Ev = `Ev' // eigvals
	return matrix L  = `L'  // eigvecs
end

// ---------------------------------------------------------------------  DiagV

program DiagV, rclass
	version 9
	#del ;
	syntax [, COVariance
	          Correlation
	          Rho             // undocumented; backward compatibility
	          EIgen           // for error message
		  TOL(passthru)   // for error message
	          EQuation(str)
	          Block		  // ignored with diag e(V)
	          Diag            // ignored with diag e(V) 
	          Format(str)
	          noLINes
		  *
	] ;
	#del cr

	_get_diopts diopts, `options'
	if `"`eigen'`tol'"' != "" { 
		dis as err in smcl ///
			"{p}only the diagonal of e(V) is available; " ///
			"eigen not allowed{p_end}"
		exit 498
	}
	
	tempname V DV
	matrix `V' = e(V)
	upRowCol `V', `diopts'
	if "`correlation'`rho'" != "" { 
		local ctype correlation
		matrix `DV' = J(1,colsof(`V'),1)
		matrix colnames `DV' = `:rowfullnames `V''
	}	
	else {
		local ctype covariance
		matrix `DV' = vecdiag(`V')
	}	
	
	if `"`equation'"' != "" { 
		Diag_EqSelect `DV' `"`equation'"' 
	}
	
	if `"`format'"' == "" {
		local format %9.0g
	}	
	
	if "`block'" != "" { 
		Diag_Block `DV' "`ctype'" "`format'" 
	}
	else { 
		dis _n as txt "Diagonal of `ctype' matrix"

		local lopt = cond("`lines'"=="", "eq", "oneline")
		version 11: ///
		matlist `DV', lines(`lopt') format(`format') /// 
		   names(col) left(4) colorcoleq(res)
	}	
		
	return matrix DV = `DV' // selected part of diag(V)
end


program Diag_EqSelect
	args DiagV slct
	
	if inlist(trim(`"`slct'"'), "", "*") {
		exit
	}
	
	local   eq : coleq `DiagV' , quote
	local   eq : list uniq eq
	local slct : list uniq slct
	local diff : list slct - eq
	if `"`diff'"'  != "" { 
		local ndiff : list sizeof diff
		dis as err plural(`ndiff',"equation") `" `diff' not found"'
		exit 198
	}

	tempname D
	foreach eq of local slct {
		matrix `D' = nullmat(`D') , `DiagV'[1,`"`eq':"'] 
	}
	matrix `DiagV' = `D'  
end


program Diag_Block 
	version 9
	args DV ctype format
	
	tempname X
	local ceq : coleq `DV' 
	local ceq : list uniq ceq
	foreach eq of local ceq {
		dis _n as txt /// 
		    `"Diagonal of `ctype' matrix for equation {res:`eq'}"' 
		    
		matrix `X' = `DV'[1,`"`eq':"']  	
		matrix coleq `X' = _
		
		version 11: ///
		matlist `X' , format(`format') names(col) left(4) ///
		colorcoleq(res)
	}
end	


program NonameV, rclass 
	version 9
	#del ;
	syntax [, COVariance
	          Correlation
	          Rho    // undocumented; backward compatibility
	          EIgen  // not allowed here (often have zeros on diagonal)
		  TOL(passthru) // not allowed here (same reason as -eigen-)
	          EQuation(str)
	          Block
	          Diag
	          Format(str)
		  noLINes
	] ;
	#del cr

	local notallowed "`eigen' `tol'"
	if `"`notallowed'"' != " " {
		dis as err in smcl ///
			`"{p}option `notallowed' is not supported "'  ///
			`"after `e(cmd)'{p_end}"'
		exit 198
	}

	if "`rho'" != "" & "`correlation'" != "" {
		dis as err "options correlation and rho are synonyms"
		exit 198
	}
	if "`rho'" != "" {
		local correlation correlation
	}
	if "`correlation'" != "" & "`covariance'" != "" {
		dis as err "options correlation and covariance are exclusive"
		exit 198
	}

	if "`correlation'" == "" {
		local copt  "cov"
		local ctype "covariance"
	}
	else {
		local copt  ""
		local ctype "correlation"
	}

	if `"`format'"' != "" {
		if bsubstr(`"`format'"',1,1) != "%" {
			local format %`format'
		}
		// triggers error message if invalid numeric format
		local junk : display `format' -1
	}

	if "`block'" != "" & "`diag'" != "" {
		dis as err "options block and diag are exclusive"
		exit 198
	}

// extract information

	tempname V
	matrix `V' = e(V)

	if "`correlation'" != "" {
		// anova and manova often have zeros on the diagonal
		// so that the following line will not work
		//     matrix `V' = corr(`V')
		// Instead we do it by hand using the following
		MyCorr `V'
	}

// select by equation

	if `"`equation'"' != "" & "`diag'`block'" == "" {
		local block block
	}
	if `"`equation'"' != "" {
		Full_EqSelect `V' `"`equation'"'
		local eqn "of selected equations "
	}

// display

	if "`format'" == "" {
		if "`correlation'" != "" {
			local format %8.4f
		}
		else {
			local format %10.0g
		}
	}

	if "`block'" != "" {
		Full_Blocks `V' "`ctype'" "`format'"
	}
	else if "`diag'" != "" {
		Full_Diags  `V' "`ctype'" "`format'"
	}
	else {
		local Ctype = proper("`ctype'")
		dis _n as txt `"`Ctype' matrix `eqn'of "' /// 
		    `"coefficients of {res:`e(cmd)'} model"'

		local lopt = cond("`lines'"=="", "eq", "oneline")

		version 11: ///
		matlist `V', format(`format') rowtitle(e(V)) lines(`lopt') ///
			colorcoleq(res)
	}
	return matrix V = `V'
end


program MyCorr
	// This routine allows zeros on the diagonal (in which case it ensures
	// that the corresponding row and column are also all zero).  The all
	// zero rows and columns are replaced with missing value.  The
	// remaining elements are changed from covariances to correlations.

	args m

	local n = rowsof(`m')

	// take care of off diagonal elements
	forval i = 1/`n' {
		if `m'[`i',`i'] == 0 {
			forval j = 1/`n' {
				if `m'[`i',`j'] != 0 | `m'[`j',`i'] != 0 {
					_stata_internalerror vce ///
							"e(V) is malformed"
				}
			}
			continue
		}
		forval j = 1/`=`i'-1' {
			if `m'[`j',`j'] != 0 {
				mat `m'[`i',`j'] = `m'[`i',`j'] /	///
					(sqrt(`m'[`i',`i'])*sqrt(`m'[`j',`j']))
				mat `m'[`j',`i'] = `m'[`i',`j']
			}
		}
	}

	// now take care of diagonal elements
	forval i = 1/`n' {
		if `m'[`i',`i'] != 0 {
			mat `m'[`i',`i'] = 1
		}
		else {
			forval j = 1/`n' {
				mat `m'[`i',`j'] = .
				mat `m'[`j',`i'] = .
			}
		}
	}
end

program upRowCol
	version 11
	syntax name(name=V)		///
		[,	ALLBASElevels	///
			BASElevels	///
			noOMITted	///
			noEMPTYcells	///
		]

	local diopts `allbaselevels' `baselevels' `omitted' `emptycells'
	tempname sel
	matrix `sel' = J(colsof(`V'), 1, 0)
	_ms_eq_info, matrix(`V')
	local k = r(k_eq)
	forval i = 1/`k' {
		local k`i' = r(k`i')
	}
	local el 0
	forval i = 1/`k' {
		forval j = 1/`k`i'' {
			local ++el
			quietly _ms_display,	matrix(`V')	///
						eq(#`i')	///
						el(`j')		///
						`diopts'
			matrix `sel'[`el',1] = r(output)
		}
	}
	mata: vce_upRowCol("`V'", "`sel'")
end

mata:

void vce_upRowCol(string scalar uV, string scalar usel)
{
	real	matrix	V
	real	vector	sel
	string	matrix	S

	V	= st_matrix(uV)
	S	= st_matrixcolstripe(uV)
	sel	= st_matrix(usel)

	V	= select(V, sel)
	V	= select(V, sel')
	S	= select(S, sel)
	st_matrix(uV, V)
	st_matrixcolstripe(uV, S)
	st_matrixrowstripe(uV, S)
}

end

exit
