*! version 2.1.4  09sep2019
program mdslong, eclass  byable(onecall)
	// needed for backward compatibility / version control
	global T_mdslong_caller : di string(_caller())
	version 10

	if replay() {
		if _by() {
			error 190
		}
		if "`e(cmd)'" != "mdslong" {
			dis as err "mdslong estimation results not found"
			exit 301
		}
		Display `0'
		exit
	}

	if _by() {
		by `_byvars'`_byrc0' : Estimate `0'
	}
	else {
		Estimate `0'
	}
	ereturn local cmdline `"mdslong `0'"'
	
	global T_mdslong_caller
end


program Estimate, eclass byable(recall)
	#del ;
	syntax  varlist(numeric max=1)
		[if] [in] [aw fw],
		id(varlist min=2 max=2)
	[
	// data options
		SIMilarity	                       // not to be documented
		s2d(passthru)
		FORCE
	// model options
		METhod(str)
		LOSS(passthru)
		TRANSformation(passthru)               // doc as transform()
		DIMensions(numlist integer >=1 max=1)  // doc as dim()
		WEightvar(varname)                     // doc as weight()
		*
	];
	#del cr

	_nostrl error : `id'

	mds_parse_method `method',  `loss' `transformation'
	local loss         `s(loss)'
	local losstitle    `s(losstitle)'
	local transf       `s(transf)'
	local transftitle  `s(transftitle)'
	local classical `s(classical)'

	mds_parse_cdopts `"`options'"' "`classical'"
	local copts `s(copts)'	
	local dopts `s(dopts)'

	if "`dimensions'" != "" {
		local p    `dimensions'
		local dim  dim(`p')
	}

	marksample touse
	markout `touse' `id', strok
	quietly count if `touse'
	local N = r(N)
	if (`N' == 0)  error 2000
	if (`N' == 1)  error 2001

// get matrices (DM,WM) -------------------------------------------------------

	if `"`weight'"' != "" {
		if "`classical'" != "" {
			dis as err "weights not allowed with classical MDS"
			exit 101
		}
		local wexp [`weight'`exp']
	}
	
	quiet Long2mat `varlist' if `touse' `wexp' , ///
	               id(`id') `similarity' `s2d' `force'

	tempname DM WM X
	
	matrix `DM' = r(D)
	local N = colsof(`DM')
	
	if "`r(W)'" == "matrix" {
		if "`classical'" != "" {
			// weight matrix was not specified, but was
			// generated because of missing values ...
			dis as err "missing dissimilarities not allowed " ///
			           "with classical MDS"
			exit 101
		}
		matrix `WM' = r(W)
		local weight_opt  weight(`WM')
	}
	
	local dtype      `r(dtype)'
	local s2d        `r(s2d)'
	local codes      `"`r(codes)'"'   // for use in matrix stripes
	local labels     `"`r(labels)'"'  // for labeling in graphs
	local mxlen      `r(mxlen)'
	local idtype     `r(idtype)'
	local duplicates `r(duplicates)'
	
	if "`r(idcoding)'" == "matrix" {
		tempname idcoding
		matrix `idcoding' = r(idcoding)
	}	

// do actual MDS --------------------------------------------------------------	
	
	if "`classical'" != "" {
		mds_classical `DM', `dim' `copts'
	}
	else {
		version $T_mdslong_caller : ///
		mds_modern `DM', loss(`loss') transform(`transf') ///
			`dim' `copts' `weight_opt' 	
	}

// save results in e() --------------------------------------------------------

	if "`classical'" == "classical" {
		ereturn post, esample(`touse') properties(nob noV eigen)
	}
	else {
		ereturn post, esample(`touse') properties(nob noV)
	}

	foreach x in `:r(macros)' {
		if "`x'" == "rmsg" {
			local rmsg `r(`x')'
		}
		else if "`x'" == "seed" | "`x'" == "iseed" {
			ereturn hidden local `x' `r(`x')'
		}
		else {
			ereturn local `x' `r(`x')'
		}
	}
	foreach x in `:r(scalars)'  {
		if "`x'" == "rc" {
			local rc `r(`x')'
			if `r(`x')' == 430 {
				eret scalar converged = 0
			}
			else if `r(`x')' == 0 & "`classical'" == "" {
				eret scalar converged = 1
			}
		}
		ereturn scalar `x' = r(`x')
	}
	if "`rc'" == "" {
		local rc 0
		ereturn scalar rc = 0
		if "`classical'" == "" {
			ereturn scalar converged = 1
		}
	}
	foreach x in `:r(matrices)' {
		matrix `X' = r(`x')
		ereturn matrix `x' = `X'
	}

	ereturn scalar N            = `N'
	ereturn local  depvar       `varlist'
	ereturn local  id           `id'
	ereturn local  dtype        `dtype'
	ereturn local  s2d          `s2d'
	ereturn local  wtype        `weight'
	ereturn local  wexp         "`exp'"
	
	ereturn local  labels       `"`labels'"'
	ereturn local  mxlen        `mxlen'
	ereturn local  idtype       `idtype'
	ereturn local  duplicates   `duplicates'
	if "`idcoding'" != "" {
		ereturn matrix idcoding = `idcoding'
	}	
	
	ereturn local  loss         `loss'
	ereturn local  losstitle    `losstitle'
	ereturn local  tfunction    `transf'
	ereturn local  transftitle  `transftitle'

	ereturn local  predict      mds_p
	ereturn local  estat_cmd    mds_estat
	ereturn local  marginsnotok _ALL
	ereturn local  cmd          mdslong

// output
	if `rc' == 498 {
		ereturn clear
		di as err `"{p}`rmsg'{p_end}"'
		exit `rc'
	}
	if `"`rmsg'"' != "" {
		di as err `"{p}`rmsg'{p_end}"'
		if `rc' != 430 {
			exit `rc'
		}
	}
	Display , `dopts'
end


program Display
	syntax [, *]

	mds_display, `options'
end


program Long2mat, sortpreserve rclass
	version 8

	#del ;
	syntax  varname if [fw aw/],
		id(varlist)
	[
		SIMilarity
		s2d(str)
		FORCE
	] ;
	#del cr

	marksample touse

	if `"`s2d'"' != "" {
		mds_parse_s2d `s2d'
		local s2d   `s(s2d)'
		local dtype similarity
	}
	else if "`similarity'" != "" {
		local s2d   standard	
		local dtype similarity
	}
	else {
		local dtype dissimilarity
	}
	
	if "`weight'" != "" {
		tempvar wvar
		qui gen `wvar' = `exp'
	}	

// comparison identifiers id() -------------------------------------------------

	tempname D W
	tempvar  j1 j2 j12 y diff

	local jj1 : word 1 of `id'
	local jj2 : word 2 of `id'

	CheckId `jj1' `jj2' `touse'
	Long2mat_UnitCodes `j1' `j2' = `jj1' `jj2' `touse'
	
	local n            `r(n)'
	local codes      `"`r(codes)'"'
	local labels     `"`r(labels)'"'
	local mxlen        `r(mxlen)'
	local idtype       `r(idtype)'
	local duplicates   `r(duplicates)'
	
	if "`r(idcoding)'" == "matrix" {
		tempname idcoding
		matrix `idcoding' = r(idcoding)
	}

// check/normalize proximity information --------------------------------------

	qui gen `y' = `varlist'
	compress `y'

	capture assert `y'>=0 if `touse'
	if _rc {
		dis as err "proximity information should be nonnegative"
		if "`force'" != "" {
			dis as err "option force does not apply " ///
			"to this data problem"
		}
		exit 198
	}

	if "`dtype'" == "dissimilarity" {
		capture assert `y'==0 if `j1'==`j2' & `touse'
		if _rc {
			if "`force'" == "" {
				dis as err "objects should have zero " ///
					   "dissimilarity to themselves"
				exit 198
			}
			replace `y' = 0 if `j1'==`j2' & `touse'
		}
	}

	if "`dtype'" == "similarity" {
		capture assert `y'==1 if `j1'==`j2' & `touse'
		if _rc {
			if "`force'" == "" {
				dis as err "objects should have unit " ///
					   "similarity to themselves"
				exit 198
			}
			replace `y' = 1 if `j1'==`j2' & `touse'
		}

		capture assert `y'<=1 if `touse'
		if _rc {
			dis as err "similarity data should take values " ///
				   "in the unit interval [0,1]"
			if "`force'" != "" {
				dis as err "option force does not apply " ///
					   "to this data problem"
			}
			exit 198
		}
	}

// deal with duplicates within (j1,j2) ----------------------------------------

	capture bys `touse' `j1' `j2': assert _N==1 if `touse'
	if _rc {
	// dealing with duplicates by averaging withdrawn
	// under version control in version 10.
	// the new method is to specify means and 1/variance as weights

		if $T_mdslong_caller < 10 {
			if "`force'" == "" {
				dis as err "duplicate observations found"
				exit 198
			}
			if "`weight'" != "" {
				dis as err "handling duplicate " ///
					"observations not possible with weights"
				exit 198
			}
			bys `touse' `j1' `j2': ///
				replace `y' = sum(`y') if `touse' & _N>1
			bys `touse' `j1' `j2': ///
				replace `y'= cond(_n<_N,.,`y'/_N) 	///
					if `touse' & _N>1
			markout `touse' `y'
		}
		else {
			dis as err "duplicate observations found"
			if "`force'" != "" {
				dis as err "force does not apply to this " ///
					"data problem"
			}
			exit 198
		}
	}

// (j1,j2) are unordered pairs, coded 1..n ------------------------------------

	gen `j12' = cond(`j1'<`j2', (`j1'-1)*`n'+`j2', (`j2'-1)*`n'+`j1')
	// at this point, at most two obs per pair
	bys `touse' `j12': assert _N <= 2 if `touse'
		
		
	// check/fix symmetry of proximities and weights
	
	bys `touse' `j12': gen `diff' = `y'!=`y'[_N] if `touse'
	count if `diff' & `touse'
	if r(N) > 0 {
		if "`force'" == "" {
			dis as err "proximity information is asymmetric"
			exit 198
		}
		bys `touse' `j12' : ///
		replace `y' = (`y'[1]+`y'[2])/2 if _N==2 & `touse'
	}
	drop `diff'
	
	if "`weight'" != "" {
		bys `touse' `j12': gen `diff' = `wvar'!=`wvar'[_N] if `touse'
		count if `diff' & `touse'
		if r(N) > 0 {
			if "`force'" == "" {
				dis as err "weight information is asymmetric"
				exit 198
		}
		bys `touse' `j12': ///
			replace `wvar' = (`wvar'[1]+`wvar'[2])/2	///
				 if _N==2 & `touse'
		}	
		drop `diff'
	}
	
	// select one obs within unordered pair
	bys `touse' `j12': replace `touse' = 0 if _n==2 & `touse'
	
// initialize matrices D and W -----------------------------------------------

	matrix `D' = J(`n',`n',.)
	forvalues i = 1/`n' {
		matrix `D'[`i',`i'] = ("`dtype'"  == "similarity")
	}
	mata: _mds_Store("`y'", "`j1'", "`j2'", "`touse'", "`D'")
	matrix rownames `D' = `codes'	
	matrix colnames `D' = `codes'
	
	if "`weight'" != "" {
		matrix `W' = J(`n',`n',.)
		forvalues i = 1/`n' {
			matrix `W'[`i',`i'] = 1
		}
		mata: _mds_Store("`wvar'", "`j1'", "`j2'", "`touse'", "`W'")		
		matrix rownames `W' = `codes'		
		matrix colnames `W' = `codes'
	}		

// convert D to dissimilarities ////////////////////////////////////////////////

	if "`dtype'" == "similarity" {
		mds_s2d `D' , `s2d'
	}
	
 // return stuff /////////////////////////////////////////////////////////////

	return matrix D  =  `D'
	
	if "`weight'" != "" {
		return matrix W = `W'
	}
	if "`idcoding'" != "" {
		return matrix idcoding = `idcoding'
	}

	return local dtype      `dtype'
	return local s2d        `"`s2d'"'
	return local labels     `"`labels'"'
	return local mxlen      `mxlen'
	return local idtype     `idtype'
	return local duplicates `duplicates'
end


program CheckId
	args jj1 jj2 touse

	if "`jj1'" == "`jj2'" {
		dis as err "different id variables expected"
		exit 198
	}
	
	capt assert !missing(`jj1',`jj2') if `touse'
	if _rc {
		dis as err "id variables should be nonmissing"
		exit 198
	}
	
	if $T_mdslong_caller > 9 {
		capt bys `touse' `jj1' `jj2' : assert _N==1 if `touse'
		if _rc {
			dis as err "id-variables do not " ///
				"uniquely identify observations"
			exit 198
		}	
	}
	
	if "`:type `jj1''" != "`:type `jj2''" {
		dis as err "types of id variables differ"
		exit 198
	}
	
	if "`:value label `jj1''" != "`:value label `jj2''" {
		dis as err "value labels of id variables differ"
		exit 198
	}
end
	

// produces codes nj1 nj2 that are integer coded 1..n
//
program Long2mat_UnitCodes, rclass
	args  nj1 nj2  equal  j1 j2 touse

	assert "`equal'" == "="
	confirm variable `j1' `j2'
	confirm new variable `nj1' `nj2'

	// produce coding file

	tempvar jj jcodes merge sjj // ensure unique varnames
	tempfile fjj

	// all distinct values of j1 and j2

	preserve

	keep if `touse'
	keep `j1'
	rename `j1' `jj'
	save `"`fjj'"'

	restore, preserve

	keep if `touse'
	keep `j2'
	rename `j2' `jj'
	append using `"`fjj'"'
	bys `jj' : keep if _n==1
		
	// consecutive integers 		

	sort `jj'
	gen `jcodes' = _n
	gen `touse'  = 1
	
	// get codes

	mds_id2string `jj', touse(`touse') gen(`sjj')
	
	return add
	return local n `c(N)'

	drop `sjj' `touse'
	compress
	save `"`fjj'"', replace

	restore

	// merge coding file

	gen `jj' = `j1'
	sort `jj'
	merge `jj' using `"`fjj'"', nokeep _merge (`merge') uniqusing
	drop `merge'
	rename `jcodes' `nj1'
	replace `jj' = `j2'
	sort `jj'
	merge `jj' using `"`fjj'"', nokeep _merge (`merge') uniqusing
	drop `merge'
	rename `jcodes' `nj2'
	des
end

// ==================================================================

mata:

// stores list information (i1,i2,x) into an existing Stata matrix X
//
void _mds_Store( string scalar _x, string scalar _i1, string scalar _i2,
			string scalar _touse, string scalar _X )
{
	real scalar  i
	real vector  x, i1, i2
	real matrix  X

	pragma unset x
	pragma unset i1
	pragma unset i2

	st_view(  x, .,  _x, _touse )
	st_view( i1, ., _i1, _touse )
	st_view( i2, ., _i2, _touse )
	
	X = st_matrix(_X)
	
	if ((min((i1,i2))<1) | max((i1,i2))>rows(X))
		exit(_error(3498,"internal error in mdslong::_mds_Store"))

	for (i=1; i<=rows(x); i++)
		X[i1[i],i2[i]] = X[i2[i],i1[i]] = x[i]

	st_replacematrix(_X, X)
}

end
exit
