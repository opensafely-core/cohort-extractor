*! version 1.5.1  09sep2019
program camat, eclass
	version 10.0

	if _caller() < 10 {
		if strpos(`"`0'"', ",") > 0 {
			local oldstyle oldstyle
		}
		else{
			local oldstyle ", oldstyle"
		}
	}
	if replay() {
		if _by() {
			error 190
		}
		if "`e(cmd)'" != "ca" {
			error 301
		}
		Display `0' `oldstyle'
		exit
	}

	if _by() {
		by `_byvars'`_byrc0' : Estimate `0'
	}
	else {
		Estimate `0' `oldstyle'
	}
	ereturn local cmdline `"camat `0'"'
end

program Estimate

	#del ;
	syntax  anything(id=matrix name=rawP)
	[,
		DIMensions(numlist integer max=1 >0)
		DDIMensions(passthru)
		FActors(numlist integer max=1 >0)     // undocumented
		NORMalize(str)
		ROWSupp(str)
		COLSupp(str)
		ROWName(str)
		COLName(str)
	// display options
		noROWPoints
		noCOLPoints
		COMPact
		PLOT
		MAXlength(passthru)
		noDISPLAY                             // undocumented		
		oldstyle			      // undoc, vers control
	];
	#del cr
	local display_opts `rowpoints' `colpoints' `compact' `plot' /// 
	                   `maxlength' `ddimensions'  

	local dim `dimensions'
	if "`dim'" != "" & "`factors'" != "" {
		dis as err "dim() and factors() are synonyms"
		exit 198
	}
	else if "`factors'" != "" {
		local dim `factors'
	}
        else if `"`dim'"' == "" {
        	local dim . 
        }	

	if (`"`rowname'"' == "") local rowname rows
	if (`"`colname'"' == "") local colname columns

	ca_parse_normalize `normalize'
	local normalize `s(normalize)'
	local alpha = `s(alpha)'
	local beta  = `s(beta)'
	
	confirm matrix `rawP' 
	if (`"`rowsupp'"' != "") confirm matrix `rowsupp' 
	if (`"`colsupp'"' != "") confirm matrix `colsupp' 

	local osty 0
	if `"`oldstyle'"' != "" {
		local osty 1
	} 

	// Mata: fit model and store in e()
        mata: camat( "`rawP'", `dim', "`rowname'", "`colname'",   ///
                     "`normalize'", `alpha', `beta', "`rowsupp'", /// 
                     "`colsupp'" , `osty')

        if "`display'" == "" { 
		Display, `display_opts' `oldstyle'
	}
	global ca_vv
end

// ----------------------------------------------------------------------------
// display commands
// ----------------------------------------------------------------------------

program Display
	
	#del ;
	syntax [, 
		noROWPoints 
		noCOLPoints 
		COMPact 
		PLOT 
		maxlength(passthru) /// 
	        DDimensions(numlist int max=1 >0 missingok)
		oldstyle
        ];
        #del cr
	if _caller() < 10 {
		local oldstyle oldstyle
	}

	local nr      = rowsof(e(P))
	local nc      = colsof(e(P))
	
	local nr_supp = 0
	local nc_supp = 0
	if ("`e(TR_supp)'" == "matrix")  local nr_supp = rowsof(e(TR_supp))
	if ("`e(TC_supp)'" == "matrix")  local nc_supp = rowsof(e(TC_supp))

// header /////////////////////////////////////////////////////////////////////

	dis _n as txt "Correspondence analysis" ///
	    _col(47) "Number of obs"  _col(66) "= " as res %10.0fc e(N)

	if "`e(X2)'" != "" {
		if (e(X2_df)>10000) local newl _n
		dis as txt _col(47) "Pearson chi2(" ///
				as res `e(X2_df)' as txt ")" `newl' ///
			   _col(66) "=  " as res %9.2f e(X2)

		dis as txt _col(47) "Prob > chi2" ///
			   _col(66) "=  " as res %9.4f e(X2_p)
	}

	dis as txt _col(47) "Total inertia" ///
	    _col(66) "=  " as res %9.4f e(inertia)

	dis as txt _col(5) "{res:`nr'} active " _c
	if (`nr_supp' > 0)  dis "+ {res:`nr_supp'} supplementary " _c

	dis as txt "rows" _col(47) "Number of dim." ///
	    _col(66) "=  " as res %9.0f `e(f)'

	dis as txt _col(5) "{res:`nc'} active " _c
	if (`nc_supp' > 0)  dis "+ {res:`nc_supp'} supplementary " _c

	dis as txt "columns" _col(47) "Expl. inertia (%)" ///
	    _col(66) "=  " as res %9.2f 100*e(pinertia)

// table with singular values /////////////////////////////////////////////////

	tempname csumsq dsq Sv

	matrix `Sv'  = e(Sv)
	local k = colsof(`Sv')
	if "`ddimensions'" != "" {
		local k = min(`k',`ddimensions')
	}	

	dis _n as txt _col(17) ///
	   "{c |}   singular    principal                             cumul  "
	dis as txt _col(5) "  Dimension " ///
	   "{c |}    value       inertia           chi2    percent   percent "

	dis as txt _col(5)"{hline 12}{c +}{hline 60}"

	scalar `csumsq' = 0
	forvalues i = 1 / `k' {
		scalar `dsq' = `Sv'[1,`i']^2
		scalar `csumsq' = `csumsq' + `dsq'
		dis as txt _col( 4) "{ralign 12:dim `i'} {c |}" ///
		    as res _col(20)  %9.0g  `Sv'[1,`i'] ///
			   _col(32)  %9.0g  `dsq' ///
			   _col(47)  %9.2f  e(N)*`dsq' ///
			   _col(58)  %9.2f  100*(`dsq'/e(inertia)) ///
			   _col(68)  %9.2f  100*(`csumsq'/e(inertia))
	}

	if !`e(sv_unique)' {
		dis as txt "(positive singular values are not distinct)"
	}

	dis as txt _col(5)"{hline 12}{c +}{hline 60}"

	dis as txt _col(5) "{ralign 11:total} {c |}" ///
	    as res _col(32) %9.0g e(inertia) ///
		   _col(47) %9.2f e(N)*e(inertia) ///
		   _col(58) %6.0f 100

// table with general information /////////////////////////////////////////////

	if "`compact'" == "" {
		CategoryTables, `rowpoints' `colpoints' `oldstyle'
	}
	else {
		CompactCategoryTables, `rowpoints' `colpoints' `oldstyle'
	}

// estat and graph commands ///////////////////////////////////////////////////

	if "`plot'" != "" {
		if "`e(norm)'" == "row" {
			local opt row
		}
		else if "`e(norm)'" == "column" {
			local opt column
		}
		cabiplot, `opt' `maxlength'
	}
end

// ---------------------------------------------------------------------------

program CategoryTables
	syntax [, norowpoints nocolpoints oldstyle]

	if ("`rowpoints'" != "" & "`colpoints'" != "") exit

	if "`rowpoints'" == "" {
		local r1 : rownames e(GSR)
		capture local r2 : rownames e(GSR_supp)
		local rctxt "row"
	}
	if "`colpoints'" == "" {
		local c1 : rownames e(GSC)
		capture local c2 : rownames e(GSC_supp)
		if "`rctxt'" != "" {
			local rctxt "row and column"
		}
		else {
			local rctxt "column"
		}
	}

	local n = `:list sizeof r1' + `:list sizeof r2' ///
		+ `:list sizeof c1' + `:list sizeof c2'
	local onetable = (`n' <= c(max_matdim))

// display

if `"`oldstyle'"' == "" {
	dis _n as txt "{help ca_statistics##|_new:Statistics} for `rctxt' " ///
		      "categories in `e(norm)' normalization"
}
else {
	dis _n as txt "{help ca_statistics_old##|_new:Statistics} for `rctxt' " ///
		      "categories in `e(norm)' normalization"
}

	if `onetable' {
		tempname X X2
		if "`rowpoints'" == "" {
			matrix `X' = e(GSR)                     // rows
			matrix roweq `X' = `e(Rname)'

			if "`e(GSR_supp)'" == "matrix" {        // supp_rows
				matrix `X2' = e(GSR_supp)
				matrix roweq `X2' = suppl_rows
				matrix `X' = `X' \ `X2'
			}
		}
		if "`colpoints'" == "" {
			matrix `X2' = e(GSC)                    // columns
			matrix roweq `X2' = `e(Cname)'
			matrix `X' = nullmat(`X') \ `X2'

			if "`e(GSC_supp)'" == "matrix" {        // supp_cols
				matrix `X2' = e(GSC_supp)
				matrix roweq `X2' = suppl_cols
				matrix `X' = `X' \ `X2'
			}
		}
		Table `X' "Categories"
	}
	else {
		if "`rowpoints'" == "" {
			Table e(GSR) "`e(Rname)'"
			if "`e(GSR_supp)'" == "matrix" {
				Table e(GSR_supp) "suppl_rows"
			}
		}
		if "`colpoints'" == "" {
			Table e(GSC) "`e(Cname)'"
			if "`e(GSC_supp)'" == "matrix" {
				Table e(GSC_supp) "suppl_cols"
			}
		}
	}
end


program Table
	args X name

	tempname Z
	matrix `Z' = `X'

	local ceq : coleq `Z'
	local ceq : subinstr local ceq "dim" "dimension_", all
	matrix coleq `Z' = `ceq'

	matlist `Z', left(4) format(%7.3f) rowtitle(`name') ///
	   border(bottom) showcoleq(combine) keepcoleq      ///
	   underscore nodotz
end


program CompactCategoryTables
	syntax [, norowpoints nocolpoints oldstyle ]

	if ("`rowpoints'" != "" & "`colpoints'" != "") exit

	if "`rowpoints'" == "" {
		local rctxt = cond("`colpoints'"=="", "row and column", "row")
	}
	else {
		local rctxt "column"
	}

if `"`oldstyle'"'=="" {
	dis _n as txt "{help ca_statistics##|_new:Statistics} for `rctxt' " ///
	    "categories in `e(norm)' norm. (x 1000)"
}
else{
	dis _n as txt "{help ca_statistics_old##|_new:Statistics} for `rctxt' " ///
	    "categories in `e(norm)' norm. (x 1000)"
}
	local f = e(f)
	local ncol = floor((c(linesize)-17)/20)
	local ilow  = 0
	while `ilow' <= `f' {
		local ihigh = min(`ilow'+`ncol'-1,`f')

		dis as txt _n "    {hline 13}" _c
		forvalues j = `ilow'/`ihigh' {
			if `j' == 0 {
				if `"`oldstyle'"' != "" {
					dis "{c TT}{hline 5} overall {hline 5}" _c
				}
				else {
					dis "{c TT}{hline 5} overall {hline 6}" _c
				}
			}
			else {
				dis "{c TT}{hline 3} dimension `j' {hline 3}" _c
			}
		}
		dis

		dis as txt "       Categories" _c
		forvalues j = `ilow'/`ihigh' {
			if `j' == 0 {
				if `"`oldstyle'"' != "" {
					dis "{c |}  mass qualt inert " _c
				}
				else {
					dis "{c |}  mass qualt %inert " _c
				}
			}
			else {
				dis "{c |} coord sqcor contr " _c
			}
		}
		dis

		if "`rowpoints'" == "" {
			CMatrix e(GSR) "`e(Rname)'" `ilow' `ihigh' `oldstyle'
			if "`e(GSR_supp)'" == "matrix" {
				CMatrix e(GSR_supp) "suppl_rows" `ilow'	///
					 `ihigh' `oldstyle'
			}
		}

		if "`colpoints'" == "" {
			CMatrix e(GSC) "`e(Cname)'" `ilow' `ihigh' `oldstyle'
			if "`e(GSC_supp)'" == "matrix" {
				CMatrix e(GSC_supp) "suppl_cols" `ilow'	///
					`ihigh' `oldstyle'
			}
		}

		dis as txt "    {hline 13}" _c
		local ilow1 `ilow'
		if `ilow' == 0 & `"`oldstyle'"' == "" {
			dis as txt "{c BT}{hline 20}" _c
			local ilow1 = `ilow'+1
		}
		forvalues j = `ilow1'/`ihigh' {
			dis as txt "{c BT}{hline 19}" _c
		}
		dis

		local ilow = `ihigh' + 1
	}
end


program CMatrix
	args Xname title ilow ihigh oldstyle

	dis as txt "    {hline 13}" _c
	local ilow1 = `ilow'+1
	if `ilow1' != 1 | "`oldstyle'" != "" {
		local ilow1 = `ilow'
	}
	if `ilow1'!=`ilow' {
		dis as txt "{c +}{hline 20}" _c
	}
	forvalues j = `ilow1'/`ihigh' {
		dis as txt "{c +}{hline 19}" _c
	}
	dis

	local abtitle = abbrev("`title'",12)
	dis as res "    {lalign 12:`abtitle'} " as txt _c
	if `ilow1' != `ilow' {
		dis as txt "{c |}" _skip(20) _c
	}
	forvalues j = `ilow1'/`ihigh' {
		dis as txt "{c |}" _skip(19) _c
	}
	dis

	tempname X
	matrix `X' = `Xname'
	local rnames : rownames `X'

	forvalues i = 1/`=rowsof(`X')' {
		gettoken rname rnames : rnames
		local abrname = abbrev("`rname'",12)
		local abrname = subinstr("`abrname'","_"," ",.)

		dis as txt "    {ralign 12:`abrname'} " _c
		if `ilow1' != `ilow' {
			local j `ilow'
			if `X'[`i',3*`j'+3] != .z {
				local x3 : display %7.0f 1000*`X'[`i',3*`j'+3]
			}
			else 	local x3 `"       "'

			dis as txt "{c |}"              ///
			    as res %6.0f 1000*`X'[`i',3*`j'+1] ///
			    as res %6.0f 1000*`X'[`i',3*`j'+2] ///
			    as res `"`x3' "' _c
		}
		forvalues j = `ilow1'/`ihigh' {
			if `X'[`i',3*`j'+3] != .z {
				local x3 : display %6.0f 1000*`X'[`i',3*`j'+3]
			}
			else 	local x3 `"      "'

			dis as txt "{c |}"              ///
			    as res %6.0f 1000*`X'[`i',3*`j'+1] ///
			    as res %6.0f 1000*`X'[`i',3*`j'+2] ///
			    as res `"`x3' "' _c
		}
		dis
	}
end

// -----------------------------------------------------------------------------
// do work in Mata
// -----------------------------------------------------------------------------

mata:

void camat_positive(real vector r, string scalar margin, string scalar _X)
{
   real scalar i 

   for (i=1; i<=length(r); i++)
      if (r[i]==0) {
         errprintf( "%s margin %f of %s should be strictly positive\n", 
                    margin, i, _X )
         exit(506)
      }
}

void camat_validmatrix(real matrix X, string scalar _X)
{
   real scalar nneg
   
   if (missing(X)) {
      errprintf( "matrix %s contains missing values\n", _X )
      exit(504)
   }

   nneg = sum(X:<0)
   if (nneg > 0) { 
      errprintf( "matrix %s has %f negative %s\n", 
                 _X, nneg, (nneg>1?"values":"value") )
      exit(506)
   }	
}

void camat_ematrix(string scalar ename, real matrix X, 
                   string matrix rowstripeX, string matrix colstripeX)       
{
   st_matrix(ename, X)
   st_matrixrowstripe(ename, rowstripeX)
   st_matrixcolstripe(ename, colstripeX)
}

// -----------------------------------------------------------------------------

void camat( string scalar  _P, 
            real   scalar  dim, 
            string scalar  rowname, 
            string scalar  colname,
            string scalar  normalize, 
            real   scalar  alpha, 
            real   scalar  beta, 
            string scalar  _Rsupp, 
            string scalar  _Csupp,
	    real   scalar  osty)
{
   real scalar    df, dmax, i, j, k, m, N, nr_supp, nc_supp, Inertia, 
                  Pinertia, rc, sv_unique, sv_null, X
   real vector    c, cS, /* FitR, FitC, */ ICol, IColS, InertR, InertC, 
                  IRow, IRowS, r, rS, sgn, Sv, SvAll
   real matrix    srP, P, Rsupp, Csupp, CorrAxesR, CorrAxesC, CorrAxesRS, 
                  CorrAxesCS, R, C, PR, PC, TR, TC, TR_supp, TC_supp, 
                  GSR, GSC, GSR_supp, GSC_supp

   string scalar  dimk 
   string matrix  ROWstripe, COLstripe, SROWstripe, SCOLstripe,
                  SVstripe, GScolstripe


   P = st_matrix(_P)
   camat_validmatrix(P, _P)
   if (rows(P)==1 | cols(P)==1) {
      errprintf("camat requires at least two rows and columns\n")
      exit(198)
   }
   
   N = sum(P)
   P = P:/N
   r = rowsum(P)
   c = colsum(P)'
    
   camat_positive(r, "row",    _P)
   camat_positive(c, "column", _P)

   dmax = min((rows(P)-1,cols(P)-1))
   if (dim != .) {
      if (dim > dmax) {
         errprintf("dim() invalid; dim should be at most %f\n", dmax)
	 exit(498)
      }
   }
   else	{ 
      dim = min((2,dmax))
   }   
  
// Supplementary stuff ---------------------------------------------------------

   if (_Rsupp != "") { 
      Rsupp = st_matrix(_Rsupp)
      camat_validmatrix(Rsupp, _Rsupp)
      if (cols(Rsupp) != cols(P)) { 
         errprintf("rowsupp() invalid; size is not conformable\n")
         exit(503)
      }
      camat_positive(rowsum(Rsupp), "row", _Rsupp)      
   }
   
   if (_Csupp != "") { 
      Csupp = st_matrix(_Csupp)
      camat_validmatrix(Csupp, _Csupp)
      if (rows(Csupp) != rows(P)) { 
         errprintf("colsupp() invalid; size is not conformable\n")
         exit(503)
      }
      camat_positive(colsum(Csupp), "column", _Csupp)      
   }

// Apply the Generalized SVD to P-rc', with respect to the inner products 
// normed by inv(diag(r)) and inv(diag(c)).  The GSVD can be expressed in 
// terms of the orthonormal (or standard) SVD of the matrix  
//   srP = diag(r)^-1/2 (P-rc') diag(c)^{-1}
// See also BG 3.2.11
  
   /* Not the most memory-efficient code, but maybe easier to understand
      srP = (P-r*c') :/ sqrt(r*c')
      if (rows(srP) >= cols(srP)) { 
         svd(srP, R=.,Sv=.,C=.)
         C  = C'
         Sv = Sv' 
      }
      else 
         svd(srP', C=.,Sv=.,R=.)
         R  = R'
         Sv = Sv' 
      }
   */

   // we use the space conserving function _svd()
   srP = (P-r*c') :/ sqrt(r*c')
   if (rows(P)>=cols(P)) {
      R = srP
      _svd(R, Sv=., C=.)
      C  = C'
      Sv = Sv' 
   }
   else {
      C = srP'  
      _svd(C, Sv=., R=.)
      R  = R'
      Sv = Sv' 
   }
   
   sgn = sign(R[1,.])
   R = R:*sgn
   C = C:*sgn

   sv_unique = !any(Sv[1..(cols(Sv)-1)]:==Sv[2..(cols(Sv))])
   sv_null   = sum(Sv:<=1e-8*sum(Sv))

   if (dim > cols(Sv)-sv_null) {
      dim = cols(Sv) - sv_null
      if (dim==0) {
          errprintf("CA table is of rank 1\n")
          exit(498)
      }
      printf("{txt}(dimension is set to %f\n)", dim)
   }
   SvAll = Sv[1..(cols(Sv)-sv_null)]

  // retain m (>=dim) components -----------------------------------------------

   m = max((dim,min((cols(Sv)-sv_null,6))))
   R  = R[.,1..m]
   C  = C[.,1..m]
   Sv = Sv[1..m]
   
// principal coordinates (see BG 3.2.16, 3.2.17) -------------------------------

   PR = (R :* Sv) :/ sqrt(r) 
   PC = (C :* Sv) :/ sqrt(c)

// Obtain coordinates in required normalization --------------------------------
//
// Note that alpha=beta=0 for "standard" coordinates (BG 3.2.18 and 3.2.19)
// Principal coordinates have alpha=beta=1.
// Standard  coordinates have alpha=beta=0 

   if (normalize != "principal") {
      TR = PR :* (Sv:^(alpha-1))
      TC = PC :* (Sv:^(beta -1))
   }
   else {
      TR = PR
      TC = PC
   }   

// Inertia of rows and columns -------------------------------------------------
// see BG 3.2.22, 3.2.28

   IRow = diagonal( srP * srP' )
   ICol = diagonal( srP' * srP )

// correlations between profiles and principal axes ----------------------------
// see BG 3.2.23

   CorrAxesR = (PR:^2) :* (r:/IRow)
   CorrAxesC = (PC:^2) :* (c:/ICol)

// fit of rows and columns: quality of subspace approximation ------------------
// see BG 3.2.24, 3.2.30

//  FitR = rowsum(PR:^2) :* (r:/IRow)
//  FitC = rowsum(PC:^2) :* (c:/ICol)

// Relative contributions of rows and columns to principal inertia ------------
// see BG 3.2.21, 3.2.27

   InertR = (PR:^2 :* r) :/ (Sv :^2)
   InertC = (PC:^2 :* c) :/ (Sv :^2)

// total and explained inertia ------------------------------------------------

   df = (rows(P)-1)*(cols(P)-1)
   Inertia  = sum(SvAll:^2)
   Pinertia = sum(Sv[1..dim]:^2)/Inertia

// collect statistics for active points in summary tables ----------------------
   if (osty==0) {
  	 GScolstripe = ("overall","mass" \ "overall","quality" \ "overall","%inert")
   }
   else {
   	GScolstripe = ("overall","mass" \ "overall","quality" \ "overall","inertia")
   }
   for (k=1; k<=dim; k++) {
      dimk = "dim" + strofreal(k)
      GScolstripe = GScolstripe\(dimk,"coord" \ dimk,"sqcorr" \ dimk,"contrib")
   }   

   if (osty == 0) {
	IRow = IRow:/Inertia
	ICol = ICol:/Inertia
   }

   GSR = (r, rowsum(CorrAxesR[.,1..dim]), IRow)
   for (k=1; k<=dim; k++)
      GSR = GSR, (TR[.,k], CorrAxesR[.,k], InertR[.,k])

   GSC = (c, rowsum(CorrAxesC[.,1..dim]), ICol)
   for (k=1; k<=dim; k++)
      GSC = GSC, (TC[.,k], CorrAxesC[.,k], InertC[.,k])

// supplementary row points ----------------------------------------------------

   if (_Rsupp != "") {
      nr_supp = rows(Rsupp)
      rS = rowsum(Rsupp)
      
      // coordinates TS_Supp
      TR_supp = (Rsupp:/rS) * (TC:*(Sv:^(2*alpha-2)))		
		
      // quality IRowS
      IRowS = J(nr_supp,1,0)
      for (i=1; i<=nr_supp; i++) { 
         X = 0
         for (j=1; j<=cols(P); j++) { 
            rc = (rS[i]/N)*c[j]
            X  = X + ((Rsupp[i,j]/N-rc)^2)/rc
         }
         IRowS[i,1] = X
      }   

     
      CorrAxesRS = ((TR_supp:^2):*(rS:/(N:*IRowS))) :* (Sv:^(2-2*alpha))
   if (osty == 0) {
	IRowS = IRowS:/Inertia
   }

      // combine statistics
      GSR_supp = (rS:/N, rowsum(CorrAxesRS[.,1..dim]), IRowS)
      for (k=1; k<=dim; k++)
          GSR_supp = GSR_supp, (TR_supp[.,k], CorrAxesRS[.,k], J(nr_supp,1,.z))
   }

// supplementary column points -------------------------------------------------

   if (_Csupp != "") {
      nc_supp = cols(Csupp)
      cS = colsum(Csupp)

      // coordinates TS_Supp
      TC_supp = (Csupp:/cS)' * (TR:*(Sv:^(2*beta-2)))		

      // quality IRowS
      IColS = J(nc_supp,1,0)
      for (j=1; j<=nc_supp; j++) { 
         X = 0
         for (i=1; i<=rows(P); i++) { 
            rc = (cS[j]/N)*r[i]
            X  = X + ((Csupp[i,j]/N-rc)^2)/rc
         }
         IColS[j,1] = X
      }


      // quality by dimension

      // quality by dimension
      CorrAxesCS = ((TC_supp:^2):*(cS':/(N:*IColS))) :* (Sv:^(2-2*beta))

	if (osty==0) {
		IColS = IColS:/Inertia
	}
      // combine statistics
      GSC_supp = (cS':/N, rowsum(CorrAxesCS[.,1..dim]), IColS)
      for (k=1; k<=dim; k++)
          GSC_supp = GSC_supp, (TC_supp[.,k], CorrAxesCS[.,k], J(nc_supp,1,.z))
   }

// save results ///////////////////////////////////////////////////////////////

   SVstripe = J(length(SvAll),2,"")
   for (k=1; k<=length(SvAll); k++) 
      SVstripe[k,2] = "dim" + strofreal(k)
   
   ROWstripe = st_matrixrowstripe(_P)
   COLstripe = st_matrixcolstripe(_P)


   stata(`"ereturn post, prop(nob noV eigen)"')

   camat_ematrix("e(P)", P, ROWstripe, COLstripe)
   camat_ematrix("e(r)", r, ROWstripe, ("","mass"))
   camat_ematrix("e(c)", c, COLstripe, ("","mass"))

   st_numscalar("e(N)", N)
   st_numscalar("e(inertia)", Inertia)
   st_numscalar("e(f)", dim)
   st_numscalar("e(pinertia)", Pinertia)
   st_numscalar("e(X2)", N*Inertia)
   st_numscalar("e(X2_df)", df)
   st_numscalar("e(X2_p)", chi2tail(df,N*Inertia))

   // singular vectors and values

   camat_ematrix("e(Sv)", SvAll, ("","sv"), SVstripe)
   SVstripe = SVstripe[1..m,.]
   camat_ematrix("e(R)", R, ROWstripe, SVstripe) 
   camat_ematrix("e(C)", C, COLstripe, SVstripe)  

   camat_ematrix("e(TR)",  TR,  ROWstripe, SVstripe)
   camat_ematrix("e(TC)",  TC,  COLstripe, SVstripe)
   camat_ematrix("e(GSR)", GSR, ROWstripe, GScolstripe)
   camat_ematrix("e(GSC)", GSC, COLstripe, GScolstripe)
   
   if (_Rsupp != "") {
      SROWstripe = st_matrixrowstripe(_Rsupp)

      camat_ematrix("e(PR_supp)",  Rsupp,    SROWstripe, COLstripe)
      camat_ematrix("e(TR_supp)",  TR_supp,  SROWstripe, SVstripe)
      camat_ematrix("e(GSR_supp)", GSR_supp, SROWstripe, GScolstripe)
   }

   if (_Csupp != "") {
      SCOLstripe = st_matrixcolstripe(_Csupp)
      
      camat_ematrix("e(PC_supp)",  Csupp,    ROWstripe, SCOLstripe)
      camat_ematrix("e(TC_supp)",  TC_supp,  SCOLstripe, SVstripe)
      camat_ematrix("e(GSC_supp)", GSC_supp, SCOLstripe, GScolstripe)
   }

   st_global("e(properties)", "nob noV eigen")
   st_global("e(sv_unique)", strofreal(sv_unique))
   st_global("e(norm)", normalize)
   st_global("e(Rname)", rowname)
   st_global("e(Cname)", colname)
   st_global("e(title)", "correspondence analysis")
   st_global("e(predict)", "ca_p")
   st_global("e(estat_cmd)", "ca_estat")
   st_global("e(ca_data)", "matrix")
   st_global("e(marginsnotok)", "_ALL")
   st_global("e(cmd)", "ca")
}

end
exit

The computations are based on
* Blasius and Greenacre, Computation of Correspondence Analysis, Ch 3, 53-78.
* Greenacre (1984)

Compact layout

    -------------+----- overall -----+--- dimension 1 ---+--- dimension 2 ---
      Categories |  mass qualt inert | coord sqcor contr | coord sqcor contr
    -------------+-------------------+-------------------+-------------------
    123456789012 | -1000 -1000 -1000 | -1000 -1000 -1000 | -1000 -1000 -1000
    123456789012 | -1000 -1000 -1000 | -1000 -1000 -1000 | -1000 -1000 -1000
    -------------+-------------------+-------------------+-------------------

