*! version 1.1.6  08feb2019
program rotatemat, rclass
	version 9

	#del ;
	syntax  anything(id=matrix name=A)
	[,
	    // ----------------------- display options
	     
		BLanks(real 0)         // display small loadings as blanks
		noDISPlay              // suppresses all output
		noLOADing              // suppresses display rotated loadings
		noROTAtion             // suppresses display rotation matrix
		FORmat(str)            // display format for matrices
		MATName(string)        // name for matrix
		COLNames(string)       // name for columns of matrix (plural)
		
	    //  ---------------------- minimization options
	    
		INIT(string)           // initial rotation matrix (dflt = I)
		RANdom                 // use random initial matrix (dflt = I)
		LOG                    // display iteration log
		TRAce                  // display trace 
		ITERate(passthru)      // max number of iterations
		PROTect(str)           // #trials (protect agnst local conv)
		TOLerance(passthru)    // tolerance in rotation matrix T
		LTOLerance(passthru)   // tolerance for optim criterion 
		GTOLerance(passthru)   // tolerance for projected gradient
		MAXSTEP(passthru)      // max #step halvings within iter
		MAXABSCORR(passthru)   // max abs(correlation), oblique only
		                       //
		PERturb(passthru)      // undocumented
		
	    //  ---------------------- rotation class
	    
		NORMalize              // apply kaiser normalization 
		KAISer                 // synonym for normalize (undocumented)
		Horst                  // synonym for normalize	(undocumented)
	  	OBLIQue                // normal rotations
		ORTHOgonal             // orthonormal rotations
		
	    //  ---------------------- rotation criterion
	    
		BENtler
	  	CF(str)		       // no default argument with cf()
	  	ENTRopy
	  	EQUAmax
	  	OBLIMAx
	  	OBLIMIn                // short for oblimin(0)
	  	OBLIMInn(string)
	  	PARSImax
	  	PARTIAL(string)
	  	Promax                 // short for promax(3)
	  	Promaxn(string)        // abbrev for backward compatibility
	  	QUARTIMAx
	  	QUARTIMIn
	  	TANDEM1
	  	TANDEM2
	  	TARget(string)
	  	Varimax                // abbrev for backward compatibility
	  	VGPF
	] ;
	#del cr

// check/parse input

	if `"`matname'"' == "" {
		local matname `"`A'"'
	}
	
	if `"`colnames'"' == "" {
		local colnames "factors"
	}
	
	if `"`format'"' != "" { 
		local junk : display `format' 0.3
	}
	else {
		local format %9.5f     // default mentioned in help file
	}	

	confirm matrix `A'
	local p = rowsof(`A')   // number of rows/variables
	local k = colsof(`A')   // number of columns/factors
	if (`p' < 2) | (`k' < 1) {
		dis as err "too few variables or factors"
		exit 503 
	}
	if `p' < `k' {
		dis as err /// 
		    "number of variables should exceed number of factors" 
		exit 503
	}	
	
	NoMiss   `A' `"`matname'"'
	FullRank `A' `"`matname'"'

	// row-wise normalization ?
	if "`normalize'" != "" {
		if "`horst'" != "" { 
			dis as err "options horst and normalize are synonyms"
			exit 198
		}
		if "`kaiser'" != "" {
			dis as err "options kaiser and normalize are synonyms"
			exit 198
		}
		local kaiser kaiser
	}
	else if "`horst'" != "" {
		if "`kaiser'" != "" { 
			dis as err "options horst and kaiser are synonyms"
			exit 198
		}
		local kaiser kaiser
	}

	// gpopt := options for GPFcmd
	local gp_opt  `maxstep'   `maxabscorr' `iterate'  `tolerance' ///
	              `gtolerance' `ltolerance'

	// options for protected-optimization
	local nprotect  `protect'
	local protect   protect(`protect')
	local pargs     `protect' `perturb' `oblique' `log' `trace'
	if (`k'==1) & ("`nprotect'"!="") {
		dis as txt "(protect() ignored)"
		local nprotect
		local protect
		local pargs
	}	

	Check_args , `pargs' `gp_opt'

// specification of rotation class 

	if "`orthogonal'" != "" & "`oblique'" != "" {
		opts_exclusive "orthogonal oblique"
	}
	
// specification of rotation criterion

	if "`promax'" != "" & "`promaxn'" != "" {
		dis as err "promax and promax() are exclusive"
		exit 198
	}
	else if "`promax'" != "" { 
		local promaxn = 3
	}
	
	if "`oblimin'" != "" & "`obliminn'" != "" { 
		dis as err "oblimin and oblimin() are exclusive"
		exit 198
	}
	else if "`oblimin'" != "" { 
		local obliminn = 0
	}	

	local critn `bentler' `entropy' `equamax' `oblimax' `parsimax' ///
	   `quartimax' `quartimin' `tandem1' `tandem2' `varimax' `vgpf' 
	   
	if ("`cf'"       != "")   local critn `critn' cf
	if ("`obliminn'" != "")   local critn `critn' oblimin
	if ("`partial'"  != "")   local critn `critn' partial
	if ("`target'"   != "")   local critn `critn' target

	if "`promax'`promaxn'" != "" {
		local critn `critn' promax
		if "`orthogonal'" != "" {
			dis as err "promax is always oblique"
			exit 198
		}
		
		local oblique   // NOTE: later switched on again
		
		if "`promaxn'" != "" {
			confirm number `promaxn'
			if `promaxn' < 1 {
				dis as err "promax() should be at least 1"
				exit 198
			}
			else if `promaxn' > 4 {
				dis as txt "(promax() > 4 is ill advised)"
			}
		}
		else {
			local promaxn = 3
		}
	}

	if `"`critn'"' == "" {
		local critn   "varimax"
		local varimax "varimax"
		// dis as txt "(orthogonal varimax rotation assumed)"
	}
	
	if `:list sizeof critn' > 1 {
		dis as err "multiple rotation criteria specified"
		exit 198
	}

// INTERNAL CODE //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

if inlist("`critn'","varimax","promax") {
	tempname AT f Gq iter rc T

	scalar `f' = .
	scalar `iter' = .
	
	local mxopts `init' `random' `nprotect' `log' `trace' `iterate' /// 
	        `tolerance' `ltolerance' `gtolerance' `maxstep' `maxabscorr'
	local nmax : word count `mxopts'
	if `nmax' > 0 {
		dis as error `"{p}maximize options for rotatemat do not "' ///
		    `"apply for the varimax or promax criterion{p_end}"'
		exit 198
	}
	
	if "`critn'" == "varimax" {
		NoOblique varimax `oblique'
		
		capture noisily {
			_rotate_mat `A' `AT' `T' , /// 
			   varimax `kaiser' 
		}
		scalar `rc' = _rc
		if colsof(`AT') < colsof(`A') { 
			dis as err "degenerate solution for varimax rotation"
			exit 198
		}
		
		local ctitle   "varimax"
		local ctitle12 "varimax"
		local class    "orthogonal"
	}
	else {
		// promax
		capture noisily { 
			_rotate_mat `A' `AT' `T' , /// 
			   promax(`promaxn') `kaiser' 
		}	
		scalar `rc' = _rc
		if colsof(`AT') < colsof(`A') { 
			dis as err "degenerate solution for promax rotation"
			exit 198
		}
		
		// _rotate_mat returns the varimax rotation
		// we solve for T in AT = A*inv(T')
		// note that T is not -normal- 
		
		matrix `T' = (`A''*`A')* inv(`AT''*`A')  
		
		local ctitle   "promax(`promaxn')"
		local ctitle12 "promax(`promaxn')"
		if length("`ctitle12'") > 12 {
			local ctitle12 "promax(..)"
		}
		local class   "oblique"
		local oblique oblique 
		local carg    `promaxn'
	}
}

// GRADIENT PROJECTION ALGORITHM //////////////////////////////////////////////
// code is indented to the left; all comments are preceded with [GPF]
///////////////////////////////////////////////////////////////////////////////

else {

//[GPF] initialize rotation T
	if "`init'"!="" & "`random'"!="" {
		di as err "only one of init() or random are allowed"
		exit 198
	}
	if "`nprotect'"!="" & "`init'"!="" {
		di as error "init() cannot be used with protect(); " ///
		   "protect() implies random"
		exit 198
	}

	tempname T
	Init `T' `A' "`init'" "`random'" "`oblique'"
	
//[GPF] normalization A --> L D

	if "`kaiser'" != "" {
		tempname L D
		Normalize `A' `L' `D'
	}
	else {
		local L `A'
	}

//[GPF] minimize orthogonal/oblique rotation L over suitable class of rotations

	// default criterion title, may be overwritten below
	local ctitle `critn'
	local ctitle12 `critn'
	if ustrlen("`ctitle12'") > 12 {
		local ctitle12 = usubstr("`ctitle12'",1,12)
	}
	
	if "`bentler'" != "" {
		local ctitle    "Bentler's invariant pattern simplicity"
		local ctitle12  "Bentler"
		local copt      "crit(Bentler)"
	}
	else if `"`cf'"' != "" {
		tempname carg
		capture scalar `carg' = `cf'
		if _rc {
			dis as err "argument of cf() invalid"
			exit 198
		}
		if `carg' < 0 | `carg' > 1 {
			dis as err "cf() must be between 0 and 1"
			exit 198
		}
		local ctitle    "Crawford-Ferguson(`cf')"
		local ctitle12  "cf(`cf')" 
		if length("`ctitle12'") > 12 {
			local ctitle12 "cf(..)"
		}
		local copt      "crit(Cf) critopt(`carg')"
		local carg = `carg'
	}
	else if "`entropy'" != "" {
		NoOblique entropy `oblique'
		local ctitle    "minimum entropy"
		local ctitle12  "min. entropy"
		local copt      "crit(Entropy)"  
	}
	else if "`equamax'" != "" {
		NoOblique equamax `oblique'
		local gam = `p'/2
		local copt "crit(Oblimin) critopt(`gam')"
	}
	else if "`oblimax'" != "" {
		local copt "crit(Oblimax)" 
	}
	else if `"`obliminn'"' != "" {
		tempname carg
		capture scalar `carg' = `obliminn'
		if _rc {
			dis as err "argument of oblimin() invalid"
			exit 198
		}
		local ctitle  "oblimin(`obliminn')"
		local ctitle12 `ctitle'
		if length("`ctitle12'") > 12 {
			local ctitle12 "cf(..)"
		}
		local copt    "crit(Oblimin) critopt(`carg')" 
		local carg = `carg'
	}
	else if "`parsimax'" != "" {
		NoOblique parsimax `oblique'
	  	local kap = (`k'-1) / (`p'+`k'-2)
	  	local copt  "crit(Cf) critopt(`kap')" 
	}
	else if `"`partial'"' != "" {
		if `:word count `partial'' != 2 {
			dis as err "partial() expects two matrices"
			exit 198
		}
		gettoken H W : partial
		CheckPartial `L' `H' `W'
		local ctitle   "partial target (target=`H' weight=`W')"
		local ctitle12 "ptarget(..)"
		local carg     "`H' `W'"
		local copt     "crit(PartialTarget) critopt(`carg')"
	}
	else if "`quartimax'" != "" {
		NoOblique quartimax `oblique'
		local copt  "crit(Quartimax) "
	}
	else if "`quartimin'" != "" {
		local copt  "crit(Quartimin)"
	}
	else if "`tandem1'" != "" {
		NoOblique tandem1 `oblique'
		local ctitle   "Comrey's principle 1"
		local ctitle12 "tandem-1"
		local copt     "crit(Tandem1)"
	}
	else if "`tandem2'" != "" {
		NoOblique tandem2 `oblique'
		local ctitle   "Comrey's principle 2"
		local ctitle12 "tandem-2"
		local copt     "crit(Tandem2)"
	}
	else if `"`target'"' != "" {
		CheckTarget `A' `target'
		local ctitle   "target(`target')"
		local ctitle12 "target(..)"
		local carg     `target'
		local copt     "crit(Target) critopt(`carg')"
	}
	else if "`vgpf'" != "" {
		NoOblique varimax `oblique'
		local ctitle   varimax
		local ctitle12 varimax
		local critn    varimax
		local gam = 1
		local copt  "crit(Oblimin) critopt(`gam')"
	}
	else {
		_stata_internalerror rotatemat
	}

	
	local GPFcmd = cond("`oblique'"!="", "GPFoblique", "GPFortho")
		
	Minimize `"`GPFcmd' `L', `copt' `gp_opt' colnames(`colnames')"' ///
	         `T'   "`pargs'"

//[GPF] retrieve results

	tempname AT f fmin iter nnconv rc T

	local  class  "`r(class)'"
	scalar `iter' = r(iter)
	scalar `f'    = r(f)
	matrix `T'    = r(Th)
	matrix `AT'   = r(Lh)

	if "`nprotect'" != "" {
		scalar `nnconv' = r(nnconv)
		matrix `fmin'   = r(fmin)
	}
	scalar `rc' = r(rc)

//[GPF] invert normalization r(AT)

	if "`kaiser'" != "" {
		InvertNormalize `AT' `D'
	}
}
///// END-OF-GPF //////////////////////////////////////////////////////////////

// unique representation wrt direction and L1 norm	

	Order `AT' `T' 
	
// set column and row names

	matrix rownames `AT' = `:rownames `A''
	matrix colnames `AT' = `:colnames `A''
	matrix rownames  `T' = `:colnames `A''
	matrix colnames  `T' = `:colnames `A''

// display results ////////////////////////////////////////////////////////////

if "`display'" == "" {
	dis _n as txt `"Rotation of `matname'[`p',`k']"' _n

	dis as txt "    Criterion               " as res `"`ctitle'"'
	dis as txt "    Rotation class          " as res `"`class'"'
	dis as txt "    Kaiser normalization    " as res ///
	                                        cond("`kaiser'"!="","on","off")
	    
	if `f' != . {
		local lf : display %9.0g `f' 
		dis as txt "    Criterion value         " as res `lf' 
	}
	
	if `iter' != . {
		dis as txt "    Number of iterations    " as res `iter'
	}
	
	if `rc' != 0 {
		dis as txt "    Warning: convergence not achieved"
	}

	if "`loading'" == "" { 
		if `blanks' == 0 {
			dis _n as txt `"Rotated `colnames'"'
			matlist `AT', format(`format') border(row) left(4)
		}
		else {
			dis _n as txt `"Rotated `colnames' "' /// 
			              `"(blanks represent abs()<`blanks')"'
			     
			tempname AT0
			matrix `AT0' = `AT'
			_small2dotz `AT0' `blanks'
			matlist `AT0', /// 
			   format(`format') border(row) left(4) nodotz
			matrix drop `AT0'
		}
	}
	if "`rotation'" == "" {
		dis _n as txt proper("`class'") " rotation"
		matlist `T', format(`format') border(row) left(4)
	}	

	if "`nprotect'" != "" {
		dis
		if rowsof(`fmin') > 1 {
			dis as txt /// 
			    "    Warning: convergence to multiple minima"
			dis _n as txt "  criterion       freq" 
			mat list `fmin', nonames noheader
		}
		else {
			dis as txt "{pstd}criterion minimization from " ///
			   "`nprotect' random initial rotations converged " /// 
			   "to the same minimum{p_end}"
		}
	}
}

// return results ////////////////////////////////////////////////////////////

	return clear

	return scalar rc   = `rc'                // return code
	return scalar iter = `iter'              // number of GPF iterations
	return scalar f    = `f'                 // crit. f(L.T), L = norm(A)
	return matrix T    = `T'                 // optimal transformation T
	return matrix AT   = `AT'                // optimal AT = A.T

	if "`nprotect'" != "" {
		return scalar nnconv = `nnconv'  // #non-convergent trails
		return matrix fmin   = `fmin'    // minima found
	}

	return local ctitle    `"`ctitle'"'      // label of rotation method
	return local ctitle12  `"`ctitle12'"'    // title of at most 12 chars
	return local criterion `"`critn'"'       // criterion name (eg oblimin)
	return local class     `class'           // orthogonal or oblique
	return local carg      `carg'            // argument for criterion

	if "`kaiser'" != "" { 
		return local normalization kaiser
	}
	else {
		return local normalization none 
	}	

	return local cmd rotatemat
end

// ----------------------------------------------------------------------------
// criterion minimization commands
//
//    GPFortho   -- with respect to orthogonal matrices
//    GPFoblique -- with respect to normal matrices
//
// convergence is declared if all these conditions are met:
//
//    npg   = norm(projected gradient)           < gtolerance
//    dcoef = mreldif(A(iter),A(iter-1))         < tolerance
//    dcrit = reldif(crit(iter), crit(iter-1))   < ltolerance
//
// return codes
//    rc = 0     convergence achieved
//    rc = 1001  stephalving failed
//    rc = 1002  maxiter reached
// ----------------------------------------------------------------------------

program GPFortho, rclass

	#del ;
	syntax  name(name=A) ,
		crit(str)
		t0(str)
	  	COLNAMES(str)				
	[
	  	critopt(str)
	  	ITERate(int 1000)
	  	MAXSTEP(int   20)
	  	MAXABSCORR(str)
	  	LOG
	  	TRAce
	  	TOLerance(real  1e-6)
	  	GTOLerance(real 1e-6)
	  	LTOLerance(real 1e-6)
	] ;
	#del cr

	if `"`maxabscorr'"' != "" { 
		dis as err /// 
		    "option maxabscorr() not valid with orthogonal rotations"
		exit 198
	}

	confirm matrix `A' `t0'
	assert colsof(`t0') == rowsof(`t0')
	assert colsof(`A')  == rowsof(`t0')

	tempname a1 f ft frel G Gq Gp L Lh M s T Tt Trel X U D V

	matrix `T'  = `t0'
	scalar `a1' = 1
	matrix `L'  =`A' * `T'

	// evaluate criterion and gradient in L
	`crit' 1 `f' `Gq' = `L' `critopt'

	if colsof(`A') == 1 {
		return local  class  orthogonal
		return scalar rc     = 0
		return scalar iter   = 0
		return scalar f      = `f'
		return matrix Th     = `t0'
		return matrix Lh     = `A', copy
		exit
	}

	if "`log'`trace'" != "" {
		dis _n as txt _col(19) " Criterion    norm(grad)  stepsize"
	}

	matrix `G' = `A'' * `Gq'
	local rc   = 1002
	local iter = 0
	while `++iter' <= `iterate' { 

		// compute projected gradient Gp
		matrix `M'  = `T'' * `G'
		matrix `Gp' = `G' -  0.5*`T'*(`M'+`M'')
		
		// s = norm of projected gradient
		Frobenius `s' = `Gp'

	// log and trace 
	
		if "`log'`trace'" != "" {
			dis as txt "Iteration " as res %3.0f `iter' "     " ///
			    %10.0g `f'  "    " %10.0g `s'  "  " %8.0g `a1'
		}
		if "`trace'" != "" {
			matlist `T' , noheader format(%10.0g)
			dis
		}

	// check for convergence

		if (`iter' > 1) {
			if (`s' < `gtolerance') & ///
			   (`frel' < `ltolerance') & ///
			   (`Trel'[1,1] < `tolerance') {
				// dis as txt "all convergence criteria met" 
				local rc = 0 
				continue, break
			}	
		}

	// step halving in direction of projected gradient Gp

		scalar `a1'  = 2 * `a1'
		local okstep = 0
		forvalues i = 0 / `maxstep' {
			matrix `X' = `T' - `a1' * `Gp'
			matsvd `U' `D' `V' = `X'
			matrix `Tt' = `U' * `V''
			matrix `L'  = `A' * `Tt'
			
			// evaluate criterion in L
			`crit' 0 `ft' `Gq' = `L' `critopt'
	
			/*
				dis %8.0g `a1' "  " %12.0g `ft' ///
				   " (best: "%12.0g `f' ")"
			*/
			
			if `ft' < `f' - 0.5 * `a1' * `s'^2 {
				local okstep = 1
				continue, break
			}
			scalar `a1' = 0.5 * `a1'
		}
		
		if `okstep' == 0 {
		 	// stephalving failed
		 	
			if "`log'`trace'" != "" { 
				dis as txt "Iteration " /// 
				    as res %3.0f `++iter' /// 
				    as txt "     productive step not found" 
			}
			local rc = 1001
			continue, break
		}

	// update (T,f,G)
	
		// evaluate criterion and gradient in L
		`crit' 1 `ft' `Gq' = `L' `critopt'
		
		matrix `Trel' = mreldif(`T',`Tt')
		scalar `frel' = reldif(`f',`ft')

		matrix `T' = `Tt'
		scalar `f' = `ft'
		matrix `G' = `A'' * `Gq'
	}

	matrix `Lh' = `A' * `T'

	return local  class orthogonal
	return scalar rc   = `rc'     //  return code
	return scalar iter = `iter'   //  number of GPF iterations
	return scalar f    = `f'      //  rotation criterion
	return matrix Th   = `Tt'     //  optimal ortho transformation
	return matrix Lh   = `Lh'     //  optimal L
end


program GPFoblique, rclass

	#del ;
	syntax  name(name=A) ,
		crit(str)
		t0(str)
	  	COLNAMES(str)				
	[
		critopt(str)
		ITERate(int 1000)
		MAXSTEP(int   20)
		MAXABSCORR(real 0.95)
		LOG
		TRAce
		TOLerance(real  1e-6)
		GTOLerance(real 1e-6)
		LTOLerance(real 1e-6)
	] ;
	#del cr

	confirm matrix `A' `t0'
	assert colsof(`t0') == rowsof(`t0')
	assert colsof(`A')  == rowsof(`t0')

	tempname a1 f ft frel G Gq Gp J L M s SXX T Ti Tt Trel X U D v V

	if !inrange(`maxabscorr',0,1) {
		dis as err "maxabscorr() out of range [0,1]"
		exit 198
	}

	if "`log'`trace'" != "" {
		dis _n as txt _col(19) " Criterion    norm(grad)  stepsize"
	}

	matrix `T'  = `t0'
	scalar `a1' = 1
	matrix `Ti' = inv(`T')
	matrix `L'  = `A' * `Ti''

	// evaluate criterion and gradient in L
	`crit' 1 `f' `Gq' = `L' `critopt'

	if colsof(`A') == 1 {
		return local  class  oblique
		return scalar rc     = 0
		return scalar iter   = 0
		return scalar f      = `f'
		return matrix Th     = `t0'
		return matrix Lh     = `A', copy
		exit
	}

	matrix `G' = - (`L'' * `Gq' * `Ti')'
	local nf   = colsof(`T')
	matrix `J' = J(1,`nf',1)  // useful to compute sums
	matrix `v' = I(`nf')      // pre-allocate diagonal matrix
	
	local rc   = 1002
	local iter = 0 
	while `++iter' <= `iterate' {
	
		// projected gradient
		matrix `Gp' = `G' - `T' * diag(`J' * hadamard(`T',`G'))

		// s = norm of projected gradient
		Frobenius `s' = `Gp'

	// log and trace 
	
		if "`log'`trace'" != "" {
			dis as txt "Iteration " as res %3.0f `iter' "     " ///
			  %10.0g `f'  "    " %10.0g `s'  "  " %8.0g `a1'
		}
		if "`trace'" != "" {
			matlist `T'
			dis
		}

	// check for convergence

		if (`iter' > 1) {
			if (`s' < `gtolerance') & ///
			   (`frel' < `ltolerance') & ///
			   (`Trel'[1,1] < `tolerance') {
				local rc = 0 // all convergence criteria met
				continue, break
			}
		}

	// stephalving in direction Gp

		local okstep = 0
		scalar `a1' = 2 * `a1'
		forvalues i = 0 / `maxstep' {
			matrix `X'   = `T' - `a1' * `Gp'
			
			// scale X to be normal
			matrix `SXX' = `J' * hadamard(`X',`X')
			forvalues j = 1 / `nf' {
				matrix `v'[`j',`j'] = 1 / sqrt(`SXX'[1,`j'])
			}
			matrix `Tt' = `X' * `v'
			
			// transformed A
			matrix `Ti' = inv(`Tt')
			matrix `L'  = `A' * `Ti''
			
			// evaluate criterion in L
			`crit' 0 `ft' `Gq' = `L' `critopt'
			
			if `ft' < `f' - 0.5 * `s'^2 * `a1' {
				local okstep = 1
				continue, break
			}
			scalar `a1' = `a1' / 2
		}
		
		if ! `okstep' {
		 	// step halving failed
		
			if "`log'`trace'" != "" { 
				dis as txt "Iteration " ///
				    as res %3.0f `++iter' /// 
				    as txt "     productive step not found" 
			}
			local rc = 1001
			continue, break
		}

		// update (T,f,G)

		// evaluate criterion and gradient in L
		
		`crit' 1 `ft' `Gq' = `L' `critopt'
		matrix `Trel' = mreldif(`T',`Tt')
		scalar `frel' = reldif(`f',`ft')

		matrix `T' = `Tt'
		scalar `f' = `ft'
		matrix `G' = - (`L'' * `Gq' * `Ti')'
		
		CheckCorr `T' `maxabscorr' `colnames'  
	}

	return local  class oblique
	return scalar rc   = `rc'     //  return code
	return scalar iter = `iter'   //  number of GPF iterations
	return scalar f    = `f'      //  rotation criterion
	return matrix Th   = `T'      //  optimal normal transformation
	return matrix Lh   = `L'      //  optimal loadings
end


// ----------------------------------------------------------------------------
// protected minimization
// these utility commands perform no validity checks of inputs
// ----------------------------------------------------------------------------

// generates p x p random orthogonal matrix
// distribution : unknown (irrelevant)
program RandOrtho
	args T p

	tempname X Val
	matrix `X' = matuniform(`p',`p')
	matrix `T' = `X' * inv(cholesky(`X'' * `X'))'
end


// generates an orthogonal matrix T that is derived from a random perturbation
// of T0 with Uniform(-a,a)
program PerturbOrtho
	args T To a

	tempname X
	local p = colsof(`To')
	matrix `X' = `To' + `a' * (matuniform(`p',`p') - J(`p',`p',0.5))
	matrix `T' = `X' * inv(cholesky(`X'' * `X'))'
end


// generates p x p random oblique matrix
// distribution: unknown (irrelevant)
program RandOblique
	args T p

	tempname X Z
	matrix `X' = matuniform(`p',`p')

	matrix `Z' = vecdiag(`X' * `X'')
	forvalues i = 1 / `p' {
		matrix `Z'[1,`i'] = 1 / sqrt(`Z'[1,`i'])
	}
	matrix `T' = diag(`Z') * `X'
end


// generates an oblique matrix T that is derived from a random perturbation
// of T0 with Uniform(-a,a)
program PerturbOblique
	args T To a

	tempname X Z
	local p = colsof(`To')
	matrix `X' = `To' + `a' * (matuniform(`p',`p') - J(`p',`p',0.5))

	matrix `Z' = vecdiag(`X' * `X'')
	forvalues i = 1 / `p' {
		matrix `Z'[1,`i'] = 1 / sqrt(`Z'[1,`i'])
	}
	matrix `T' = diag(`Z') * `X'
end


// Protected optimization procedure
//
// options pargs specify how repeated minimization attempts are made from
// different starting positions.  Best result is returned.
//
program Minimize, rclass
	args cmd T pargs

	confirm matrix `T'

	local 0 , `pargs'
	syntax [, PERturb(str) PROTect(str) OBLIQUE LOG TRACE ]

	// unprotected run: optimize from "initial" starting vals T and return
	if "`protect'" == "" | colsof(`T')==1 {
		`cmd' t0(`T') `log' `trace'
		return add
		exit
	}

	// protection that global minimum is attained by repeatedly starting
	// from random starting values

	tempname b_f b_iter b_Lh b_rc b_Th fmin nnconv Ti

	local k = colsof(`T')
	local multmax = 0
	scalar `b_f'    = 1e300  // best result among convergent cases
	scalar `nnconv' = 0      // number of non-convergent trials

	if "`log'`trace'" == "" {
		dis
	}
	
	forvalues i = 1 / `protect' {
		if "`perturb'" == "" {
			if "`oblique'" == "" {
				RandOrtho   `Ti' `k'
			}
			else {
				RandOblique `Ti' `k'
			}
		}
		else if `i' > 1 {
			if "`oblique'" == "" {
				PerturbOrtho   `Ti' `b_Th' `perturb'
			}
			else {
				PerturbOblique `Ti' `b_Th' `perturb'
			}
		}
		else {
			matrix `Ti' = `T'
		}

		if "`log'`trace'" != "" {
			dis _n as txt "Criterion minimization -- trial `i'"
		}

		`cmd' t0(`Ti') `log' `trace'

		if "`log'`trace'" == "" {
			dis as txt "Trial " %3.0f `i' " : min criterion  " ///
		    	  as res %9.0g r(f)
		}

		scalar `nnconv' = `nnconv' + (r(rc) != 0)
		if (r(rc) != 0) & ("`log'`trace'" != "") {
			dis as txt "(convergence not achieved)"
		}

		if `i' == 1 {
			matrix `fmin' = (r(f), 1)
			matrix colnames `fmin' = f n
		}
		else {
			local ffound = 0
			forvalues j = 1 / `=rowsof(`fmin')' {
				if reldif(r(f),`fmin'[`j',1]) < 1e-8 {
					matrix `fmin'[`j',2] = `fmin'[`j',2]+1
					local ffound = 1
					continue, break
				}
			}
			if ! `ffound' {
				matrix `fmin' = `fmin' \ (r(f), 1)
			}
		}

		if (`i' == 1) | (r(f) < `b_f') {
			// new best result
			local class `r(class)'
			scalar `b_rc'   = r(rc)
			scalar `b_iter' = r(iter)
			scalar `b_f'    = r(f)
			matrix `b_Th'   = r(Th)
			matrix `b_Lh'   = r(Lh)
		}
	}

	return scalar nnconv = `nnconv' // number of non-convergent trails
	return matrix fmin   = `fmin'   // minima found

	return local  class `class'
	return scalar iter  = `b_iter'
	return scalar rc    = `b_rc'
	return scalar f     = `b_f'
	return matrix Th    = `b_Th'
	return matrix Lh    = `b_Lh'

	if return(rc) != 0 {
		dis as txt "(convergence not achieved in best among " /// 
		           "minimization attempts)"
	}
	exit r(rc)
end

// ----------------------------------------------------------------------------
// criteria commands
//
// Syntax   Criterion todo q Gq = L options
//
// Purpose  returns the criterion f(L) in the scalar q and,
//          if todo>0, the gradient df(L)/dL is returned in the matrix Q
// ----------------------------------------------------------------------------

// Bentler's invariant pattern simplicity criterion.
program Bentler
	args todo q Gq equal L
	// assert inlist("`equal'", "=", ":")

	tempname LL X D

	matrix `LL' = hadamard(`L',`L')
	matrix `X'  = `LL'' * `LL'
	matrix `D'  = diag(vecdiag(`X'))
	matrix `q'  = -( log(det(`X')) - log(det(`D')) )
	scalar `q'  = el(matrix(`q'),1,1)
	if (`todo' == 0)  exit

	matrix `Gq' = - hadamard(`L', `LL'*(inv(`X')-inv(`D')))
end


// Crawford-Ferguson family cf(kappa)
program Cf
	args todo q Gq equal L kappa
	// assert inlist("`equal'", "=", ":")
	// confirm number `kappa'

	tempname s LL X

	local   p   = rowsof(`L')
	local   k   = colsof(`L')
	
	matrix `LL' = hadamard(`L',`L')
	matrix `X'  = (1-`kappa')*`LL'*(J(`k',`k',1) - I(`k')) ///
	              + `kappa'*(J(`p',`p',1) - I(`p'))*`LL'
	matrix `q'  = 0.25 * J(1,`p',1) * hadamard(`LL',`X') * J(`k',1,1)
	scalar `q'  = el(matrix(`q'),1,1)
	if (`todo' == 0)  exit

	matrix `Gq' = hadamard(`L',`X')
end


// Entropy (orthonormal rotations only)
program Entropy
	args todo q Gq equal L
	// assert inlist("`equal'", "=", ":")

	tempname s LL LogLL

	local   p   = rowsof(`L')
	local   k   = colsof(`L')
	
	matrix `LL' = hadamard(`L',`L')
	matrix `LogLL' = J(`p',`k',0)
	forvalues i = 1/`p' {
		forvalues j = 1/`k' {
			matrix `LogLL'[`i',`j'] = log(`LL'[`i',`j'])
		}
	}
	matrix `q'  = - 0.50*J(1,`p',1)*hadamard(`LL',`LogLL')*J(`k',1,1)
	scalar `q'  = el(matrix(`q'),1,1)
	if (`todo' == 0)  exit

	matrix `Gq' = - hadamard(`L',`LogLL') - `L'
end


// Oblimax
program Oblimax
	args todo q Gq equal L gamma
	// assert inlist("`equal'", "=", ":")

	tempname LL sLL sLLLL

	local   p   = rowsof(`L')
	local   k   = colsof(`L')
	
	matrix `LL'    = hadamard(`L',`L')
	matrix `sLL'   = J(1,`p',1) * `LL' * J(`k',1,1)
	matrix `sLLLL' = J(1,`p',1) * hadamard(`LL',`LL') * J(`k',1,1)

	matrix `q'  = - (log(`sLLLL'[1,1]) - 2*log(`sLL'[1,1]))
	scalar `q'  = el(matrix(`q'),1,1)
	if (`todo' == 0)  exit

	matrix `Gq' = - (4*hadamard(`L',`LL')/`sLLLL'[1,1] - 4*`L'/`sLL'[1,1])
end


// Oblimin(gamma)
program Oblimin
	args todo q Gq equal L gamma
	// assert inlist("`equal'", "=", ":")
	// confirm number `gamma'

	tempname s LL X

	local   p   = rowsof(`L')
	local   k   = colsof(`L')

	matrix `LL' = hadamard(`L',`L')
	matrix `X'  = (I(`p') - `gamma'*J(`p',`p',1)/`p') ///
	              * `LL' * (J(`k',`k',1) - I(`k'))
	matrix `q'  = 0.25 * J(1,`p',1) * hadamard(`LL',`X') * J(`k',1,1)
	scalar `q'  = el(matrix(`q'),1,1)
	if (`todo' == 0)  exit

	matrix `Gq' = hadamard(`L',`X')
end


// Quartimax
program Quartimax
	args todo q Gq equal L
	// assert inlist("`equal'", "=", ":")

	tempname s L2

	matrix `L2'   = hadamard(`L',`L')
	Frobenius `s' = `L2'
	scalar `q'    = - 0.25 * `s'^2
	if (`todo' == 0)  exit

	matrix `Gq'   = - hadamard(`L' ,`L2')
end


// Quartimin
program Quartimin
	args todo q Gq equal L
	// assert inlist("`equal'", "=", ":")

	tempname s LL X

	local   p   = rowsof(`L')
	local   k   = colsof(`L')

	matrix `LL' = hadamard(`L',`L')
	matrix `X'  = `LL' * (J(`k',`k',1) - I(`k'))
	matrix `q'  = 0.25 * J(1,`p',1) * hadamard(`LL',`X') * J(`k',1,1)
	scalar `q'  = el(matrix(`q'),1,1)
	if (`todo' == 0)  exit

	matrix `Gq' = hadamard(`L',`X')
end


// Comrey's tandem 1 principle (Comrey Psychometrika 1967)
program Tandem1
	args todo q Gq equal L
	// assert inlist("`equal'", "=", ":")

	tempname LL LL2 L2

	matrix `LL'  = `L' * `L''
	matrix `LL2' = hadamard(`LL',`LL')
	matrix `L2'  = hadamard(`L',`L')

	matrix `q'  = - trace(`L2'' * `LL2' * `L2')
	scalar `q'  = el(matrix(`q'),1,1)
	if (`todo' == 0)  exit

	matrix `Gq' = - 4 * hadamard(`L', `LL2' * `L2') - ///
	                4 * hadamard(`LL', `L2' * `L2'') * `L'
end


// Comrey's tandem II principle (Comrey Psychometrika 1967)
program Tandem2
	args todo q Gq equal L
	// assert inlist("`equal'", "=", ":")

	tempname J LL LL2 L2

	matrix `J'   = J(rowsof(`L'), rowsof(`L'), 1)
	matrix `LL'  = `L' * `L''
	matrix `LL2' = hadamard(`LL',`LL')
	matrix `L2'  = hadamard(`L',`L')

	matrix `q'  = trace(`L2'' * (`J'-`LL2') * `L2')
	scalar `q'  = el(matrix(`q'),1,1)
	if (`todo' == 0)  exit

	matrix `Gq' = 4 * hadamard(`L', (`J'-`LL2') * `L2') - ///
	              4 * hadamard(`LL', `L2' * `L2'') * `L'
end


// target rotation
program Target
	args todo q Gq equal L H
	// assert inlist("`equal'", "=", ":")
	// confirm matrix `H'

	tempname s X

	matrix `X' = `L' - `H'
	Frobenius `s' = `X'
	scalar `q'  = `s'^2
	if (`todo' == 0)  exit

	matrix `Gq' = 2*`X'
end


// partially specified target rotation
program PartialTarget
	args todo q Gq equal L H W
	// assert inlist("`equal'", "=", ":")
	// confirm matrix `H' `W'

	tempname s X

	matrix `X' = hadamard(`W', `L'-`H')
	Frobenius `s' = `X'
	scalar `q'  = `s'^2
	if (`todo' == 0)  exit

	matrix `Gq' = 2*`X'
end

// ----------------------------------------------------------------------------
// utility commands
// ----------------------------------------------------------------------------

// a syntax and range checker of max options
program Check_args
	#del ;
	syntax  [,
		OBLIQue
		log
  		TRAce
   		RANdom
  		ITERate(numlist max=1 >=1 integer)
  		PERturb(numlist max=1 >=0 )
  		PROTect(numlist max=1 >=1 integer)
  		TOLerance(numlist max=1 >0)
  		LTOLerance(numlist max=1 >0)
  		GTOLerance(numlist max=1 >0)
  		MAXSTEP(numlist max=1 >=1 integer)
  		MAXABSCORR(numlist max=1 >=0 <=1)
  	] ;
	#del cr
end


program NoOblique
	args crit oblique
	// assert "`crit'" != ""

	if "`oblique'" != "" {
		dis as err "the `crit' criterion is not suitable " /// 
		           "for oblique rotations"
		exit 496
	}
end


program CheckTarget
	args A Target
	confirm matrix `A' `Target'

	if colsof(`Target')!=colsof(`A') | rowsof(`Target')!=rowsof(`A') {
		dis as err "matrix `Target' is not conformable with `A'"
		exit 503
	}
	
	NoMiss `Target' target
end


// checks the target and weight matrices of a partial target rotation
program CheckPartial
	args A Target W
	confirm matrix `A' `Target' `W'

	if colsof(`Target') != colsof(`A') | ///
	   rowsof(`Target') != rowsof(`A') | ///
	   colsof(`W')      != colsof(`A') | /// 
	   rowsof(`W')      != rowsof(`A') {
		dis as err "partial() not conformable with `A'"
		exit 503
	}
	
	NoMiss `Target' target
	NoMiss `W' weight

	local unit = 1
	forvalues i = 1 / `=rowsof(`W')' {
		forvalues j = 1 / `=colsof(`W')' {
			if `W'[`i',`j'] < 0 {
				dis as err "matrix `W' has negative elements"
				exit 198
			}
			if !inlist(`W'[`i',`j'],0,1) {
				local unit = 0
			}
		}
	}

	if !`unit' {
		// warning msg only
		dis as txt "(matrix `W' is not 0/1 valued)"
	}
end


program NoMiss
	args X name
	// confirm matrix `X'
	// assert "`name'" != ""

	if matmissing(`X') {
		dis as err "matrix `X' has missing values"
		exit 504
	}
end


program FullRank 
	args X name
	// confirm matrix `X'
	// assert "`name'" != ""

	tempname Z
	
	matrix `Z' = diag0cnt(syminv(`X'' * `X'))
	if `Z'[1,1] > 0 {
		dis as err "matrix `X' is not of full rank"
		exit 506 
	}	
end


program CheckSteps
	args ok

	if !`ok' {
		dis as err "convergence failed -- " /// 
		    "step halving did not yield productive step"
		exit 1001
	}
end


program CheckConvergence
	args ok

	if !`ok' {
		dis as err "convergence failed -- " /// 
		           "projected gradient too large"
		exit 1002
	}
end

// ----------------------------------------------------------------------------
// Kaiser normalization
// ----------------------------------------------------------------------------

// Kaiser normalization: rows have unit L2-norm
program Normalize
	args A L D
	confirm matrix `A'

	tempname d
	local k = rowsof(`A')
	local p = colsof(`A')
	matrix `D' = J(`k',1,0)
	matrix `L' = `A'
	forvalues i = 1 / `k' {
		scalar `d' = 0
		forvalues j = 1 / `p' {
			scalar `d' = `d' + (`A'[`i',`j'])^2
		}
		matrix `D'[`i',1] = sqrt(`d')
		forvalues j = 1 / `p' {
			matrix `L'[`i',`j'] = `A'[`i',`j'] / `D'[`i',1]
		}
	}
end


program InvertNormalize, rclass
	args L D
	confirm matrix `L' `D'

	local k = rowsof(`L')
	local p = colsof(`L')
	forvalues i = 1 / `k' {
		forvalues j = 1 / `p' {
			matrix `L'[`i',`j'] = `L'[`i',`j'] * `D'[`i',1]
		}
	}
end

// ----------------------------------------------------------------------------
// computational utilities
// ----------------------------------------------------------------------------

program Init
	args T A init random oblique
	// confirm matrix `A'

	local k = colsof(`A')
	if `"`init'"' != "" {
		confirm matrix `init'
		NoMiss `init' "init()"

		matrix `T' = `init'
		if colsof(`T') != rowsof(`T') {
			dis as err "init() invalid: `init' not square"
			exit 503
		}
		if colsof(`T') != `k' {
			dis as err "init() invalid: " ///
			    "`A' and `init' not conformable"
			exit 503
		}

		tempname X
		if "`oblique'" == "" {
			matrix `X' = mreldif(`T''*`T', I(`k'))
			if `X'[1,1] > 1e-8 {
				dis as err "init() invalid: " ///
				  "matrix `init' is not orthonormal (T'T = I)"
				exit 506
			}
		}
		else {
			matrix `X' = mreldif(vecdiag(`T''*`T'), J(1,`k',1))
			if `X'[1,1] > 1e-8 {
				dis as err "init() invalid: " ///
				  "matrix `init' is not normal (diag(T'T)=1)"
				exit 506
			}
		}
		capture matrix `X' = inv(`T')
		if _rc {
			dis as err "matrix `init' is singular"
			exit 506
		}
	}

	else if "`random'" != "" {
		if "`oblique'" == "" {
			RandOrtho   `T' `k'
		}
		else {
			RandOblique `T' `k'
		}

	}
	
	else {
		matrix `T' = I(`k') // identity matrix
	}

	local cnames : colnames `A'
	matrix colnames `T' = `cnames'
	matrix rownames `T' = `cnames'
end


// computes the Frobenius norm of a matrix
// s = sqrt(sum(diag(X'*X))).
program Frobenius
	args s equal X
	// assert inlist("`equal'", "=", ":")
	// confirm matrix `X'

	matrix `s' = trace(`X'' * `X')
	scalar `s' = sqrt(`s'[1,1])
end


// reorient so that columns have positive sums
// reorder columns to be of nonincreasing norm
program Order
	args AT T p 
	
	tempname RT s X
	
	local r = rowsof(`AT')
	local c = colsof(`AT')

// get the directions all > 0

	matrix `X' = J(1,`r',1) * `AT'
	matrix `RT' = I(`c')
	local change_sign = 0
	forvalues j = 1/`c' {
		if `X'[1,`j']  < 0 {
			matrix `RT'[`j',`j'] = -1
			local change_sign = 1
		}
	}
	if `change_sign' { 
		matrix `AT' = `AT' * `RT' 
		matrix `T'  = `T'  * `RT' 
	}	

// reorder in decreasing order of Lp norm
	
	if "`p'" == "" {
		// euclidean 
		matrix `X' = vecdiag(`AT'' * `AT')
		
		// check if `X' constant, otherwise switch to L1
		forvalues j = 2/`c' { 
			if reldif(`X'[1,`j'],`X'[1,1])  > 1e-8 {
				local diff = 1
			}
		}
		
		if "`diff'" == "" { 
			local p = 1
		}
	}

	if "`p'" != "" {
		confirm number `p' 
		matrix `X'  = J(1,`c',0)
		forvalues j = 1/`c' { 
			scalar `s' = 0
			forvalues i = 1/`r' { 
				scalar `s' = `s' + abs(`AT'[`i',`j'])^(`p')
			}
			matrix `X'[1,`j']  = `s' 
		}
	}

	forvalues j = 1/`c' {
		local Xmac `Xmac' `=`X'[1,`j']'
	}
	_qsort_index `Xmac' \ * , descending
	local sortorder  `r(order)' 

	matrix `RT' = J(`c',`c',0)		
	forvalues j = 1/`c' {
		local jj : word `j' of `sortorder' 
		matrix `RT'[`jj',`j'] = 1
	}
	
	matrix `AT' = `AT' * `RT'
	matrix `T'  = `T'  * `RT'
end	


program matsvd 
	args U D V equal X 
	assert "`equal'" == "="

	local n = rowsof(`X')
	local m = colsof(`X')
	if `n' < `m' {
		tempname Xt
		matrix `Xt' = `X''
		matsvd `V' `D' `U' = `Xt' `svd'
		exit
	}

	local svd 
	if "`svd'" != "" { 
		matrix svd `U' `D' `V' = `X' 
	}
	else { 
		tempname XtX TU Z 
	
		// get left singular vectors = eigenvectors of X'X
		matrix `XtX' = `X'' * `X'
		matrix symeigen `V' `D' = `XtX'

		// turn into singular values
		forvalues j = 1/`m' {
			matrix  `D'[1,`j'] = sqrt(`D'[1,`j'])
		}

		// right hand singular values
		matrix `U' = `X' * `V'

		// normalize U
		matrix `Z' = `U'' * `U'
		matrix `TU' = I(`m')
		forvalues j = 1/`m' {
			matrix `TU'[`j',`j'] = 1/sqrt(`Z'[`j',`j'])
		}
		matrix `U' = `U' * `TU' 
	}
end	


program CheckCorr
	args T maxabscorr cnames
	
	tempname TtT
	matrix `TtT' = `T'' * `T' // correlations of factors
	
	local k = colsof(`TtT')
	forvalues i = 1/`k'  {
		if reldif(`TtT'[`i',`i'],1) > 1e-6 {
			dis as err "T is not normal; " /// 
			           "diagonal of T'T should be 1"
			exit 198
		}

		forvalues j = 1 / `=`i'-1' {
			if abs(`TtT'[`i',`j']) > `maxabscorr' {
dis as err "{p 0 0 2}" ///
    "one or more correlations between `cnames' exceeds `maxabscorr'; " ///  
    "use the undocumented maxabscorr() option to control the maximum "   /// 
    "acceptable absolute value of correlations between `cnames'{p_end}"
				exit 498
			}
		}
	}
end
exit
