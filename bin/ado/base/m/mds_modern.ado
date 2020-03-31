*! version 1.2.0  26mar2018
program mds_modern, rclass
	version 10

	// note that there is no abbreviation at this stage
	#del ;
	syntax  anything(id="dissimilarity matrix" name=DM),
		loss(string)
		transform(string)
	[
		copy
		DIMensions(numlist integer max=1 >=1)
		weight(name)
		initialize(string)
		normalize(string)
		iterate(numlist integer max=1 >=0)
		tolerance(numlist max=1 >=0)
		ltolerance(numlist max=1 >=0)
		NOLOg LOg
		trace
		gradient
		protect(numlist integer max=1 >=0)
		sdprotect(numlist max=1 >0)
		callver(string)			/* undocumented */
		SHOWSTATEs			/* undocumented */
	] ;
	#del cr

	if `"`callver'"' != "" {
		local vv "version `callver':"
	}
	local dcopy `copy'
	confirm matrix `DM'
	local n = rowsof(`DM')
	if rowsof(`DM') != colsof(`DM') {
		dis as err "dissimilarity matrix is not square"
		exit 505
	}
	if !issym(`DM') {
		dis as err "dissimilarity matrix is not symmetric"
		exit 505
	}

// dimensions -----------------------------------------------------------------

	local dim `dimensions'
	if "`dim'" == "" {
		local dim 2
	}
	else if `dim'>`n' {
		dis as err "dimension exceeds #rows of dissimilarity matrix"
		exit 498
	}

// weights & missing values in DM ---------------------------------------------

	if "`weight'" != "" {
		local 0 `weight'
		capture syntax [anything] [, Copy]
		if _rc {
			di as err "weight(): invalid syntax"
			exit 198
		}
		local weight `anything'
		local wcopy `copy'
		capture confirm matrix `weight'
		if _rc {
			di as err "argument to weight() must be a matrix"
			exit 198
		}
		if rowsof(`weight') != colsof(`weight') {
			dis as err "weight matrix not square"
			exit 198
		}
		if !issym(`weight') {
			dis as err "weight matrix is not symmetric"
			exit 505
		}
		mata: _mds_check_irreducible(st_matrix("`weight'"))
		if rowsof(`weight')!=`n' {
			dis as err "dissimilarity and weight matrix " ///
				"are not conformable"
			error 503
		}
		if matmissing(`weight') {
			dis as txt ///
				"(weight matrix has missing values; assumed 0)"
			mata: st_replacematrix("weight", ///
				editmissing(st_matrix("weight"),0))
		}
	}

	if matmissing(`DM') {
		if "`weight'" == "" {
			tempname weight
			matrix `weight' = J(`n',`n',1)
			matrix rownames `weight' = `:rownames `DM''
			matrix colnames `weight' = `:colnames `DM''
		}
		mata: _mds_MissingD("`DM'","`weight'")
	}

	if "`weight'" != "" {
		tempname obs
		mata: st_matrix("`obs'",rowsum(st_matrix("`weight'"):>0))

		forvalues i = 1/`n' {
			if (`obs'[`i',1] < `dim') local ilist `ilist' `i'
		}
		local nilist : list sizeof ilist
		if `nilist' > 0 {
			local row = plural(`nilist',"row")
			local has = plural(`nilist',"has","have")
			dis as err "`row' `ilist' of the dissimilarity " ///
				"matrix `has' <`dim' valid values"
			exit 498
		}
		matrix drop `obs'
	}


// maxopt ---------------------------------------------------------------------

	tempname maxopt

	if ("`iterate'"    == "") local iterate    .
	if ("`tolerance'"  == "") local tolerance  .
	if ("`ltolerance'" == "") local ltolerance .
	if ("`protect'"    == "") local protect    .
	if ("`sdprotect'"  == "") local sdprotect  .

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	matrix `maxopt' = (	`iterate',           ///
				`tolerance',         ///
				`ltolerance',        ///
				"`log'" == "",       ///
				"`trace'" != "",     ///
				"`gradient'" != "",  ///
				`protect',           ///
				`sdprotect',	     ///
				"`showstates'" != "" )

// initialize () --------------------------------------------------------------

	parse_initialize `"`initialize'"'
	local imethod `s(method)'
	local iarg    `s(arg)'
	local icopy   `s(copy)'

	if "`imethod'" == "random" & "`iarg'" != "." {
		`vv' set seed `iarg'
		local iarg
	}
	local iseed `c(seed)'
	if "`imethod'" == "from" {
		confirm matrix `iarg'
		if (rowsof(`iarg')!=`n')  | (colsof(`iarg')!=`dim') {
			dis as err ///
				"initial configuration matrix not conformable"
			exit 198
		}
		if matmissing(`iarg') {
			dis as err ///
			   "initial configuration matrix has missing values"
			exit 504
		}
	}

// normalize() ----------------------------------------------------------------

	mds_parse_normalize `"`normalize'"'
	local nmethod `s(method)'
	local narg    `s(arg)'
	local ncopy   `s(copy)'

	if "`nmethod'" == "target" {
		confirm matrix `narg'
		if (rowsof(`narg')!=`n')  | (colsof(`narg')!=`dim') {
			dis as err "target matrix not conformable"
			dis as err "need `n' rows by `dim' columns"
			exit 198
		}
		if matmissing(`narg') {
			dis as err "target matrix has missing values"
			exit 504
		}
	}

// check naming conflicts -----------------------------------------------------

	if "`dcopy'" == "" {
		local rD : rownames `DM'
		local cD : colnames `DM'
		if !`:list rD==cD' {
			dis as err "row and column names of " ///
			           "dissimilarity matrix do not match"
			exit 198
		}
	}
	if "`wcopy'"== "" {
		if "`weight'" != "" {
			local rW : rownames `weight'
			local cW : rownames `weight'
			if !`:list rW==cW' {
				dis as err "row and column names of " ///
					"weight matrix do not match"
				exit 198
			}
			if !`:list rW==rD' {
				dis as err "names of dissimilarity and " ///
					"weight matrix do not match"
				exit 198
			}
			local rW
			local cW
		}
	}

	if "`icopy'" == "" {
		if "`imethod'" == "from" {
			local rF : rownames `iarg'
			if !`:list rD==rF' {
				dis as err "names of dissimilarity and " ///
					"init(from()) matrix do not match"
				exit 198
			}
			local rF
		}
	}

	if "`ncopy'" == "" {
		if "`nmethod'" == "`target'" {
			local rT : rownames `narg'
			if !`:list rD==rT' {
			dis as err "names of dissimilarity and " ///
	 			"norm(target()) matrix do not match"
				exit 198
			}
			local rT
		}

		local rD
		local cD
	}

// computation in Mata --------------------------------------------------------

	tempname alpha critval Disp norm_stats rc seed Y ic

	#del ;
	mata: _mds_modern_shell( "`DM'", "`weight'", `dim', "`loss'",
			"`transform'", "`imethod'", "`iarg'",
			"`nmethod'", "`narg'", "`maxopt'",
			"`Y'", "`critval'", "`alpha'", "`Disp'",
 			"`seed'", "`norm_stats'", "`rc'", "`ic'" ) ;
	#del cr

// assign row/column stripes ----------------------------------------

	local p = colsof(`Y')
	forvalues i = 1/`dim' {
		local cnames `cnames' dim`i'
	}
	matrix colnames `Y' = `cnames'
	matrix rownames `Y' = `:rownames `DM''

	if "`transform'" ~= "identity" {
		matrix rownames `Disp' = `:rownames `DM''
		matrix colnames `Disp' = `:colnames `DM''
	}

// return results in r() --------------------------------------------

	return local method    modern
	if "`transform'" == "monotonic" {
		return local method2	nonmetric
	}
	return local loss      `loss'
	return local tfunction `transform'

	return scalar N = `n'
	return scalar p = `dim'
	return scalar critval = `critval'
	return scalar ic = scalar(`ic')

	local rc2 0
	if `rc' {
		if `rc' == 1 {
			local rmsg convergence not achieved: tolerance /*
				*/criterion failed
			local rc2 430
		}
		if `rc' == 2 {
			local rmsg convergence not achieved: ltolerance/*
				*/criterion failed
			local rc2 430
		}
		if `rc' == 3 {
			local rmsg convergence not achieved: tolerance /*
				*/and ltolerance criteria failed
			local rc2 430
		}
		if `rc' == 4 {
			local rmsg classical mds failed: eigenvalues too /*
				*/close; could not compute initial values
			local rc2 498
		}
 		if `rc' == 5 {
			local rmsg classical mds failed: all eigenvalues /*
				*/too close to 0; could not compute initial /*
				*/values
			local rc2 498
		}
		if `rc' == 6 {
			local rmsg loss could not be computed or is missing
			local rc2 498
		}
		if `rc' == 7 {
			local rmsg gradient of loss could not be /*
				*/computed or is missing
			local rc2 498
		}
		if `rc' == 8 {
			local rmsg stepsize determination failed
			local rc2 498
		}
		if `rc' == 9 {
			local rmsg transformation to disparities failed
			local rc2 498
		}
	}
	return local rmsg `rmsg'
	return scalar rc = `rc2'

	return matrix D = `DM'

	if "`weight'" != "" {
		tempname npos wsum
		mata: _mds_CountWeights("`weight'", "`npos'", "`wsum'")
		return scalar npos = `npos'
		return scalar wsum = `wsum'
		return matrix W    = `weight'
	}

	return matrix Y = `Y'

	if "`transform'" == "power" {
		return scalar alpha = `alpha'
	}
	else if "`transform'" == "monotonic" {
		return matrix Disparities = `Disp'
	}

	return local init `imethod'
	if "`imethod'" == "random" {
		return hidden local iseed `iseed'
		return local irngstate `iseed'
	}
	return hidden local seed : di `seed'
	return local rngstate : di `seed'

	return local norm `nmethod'
	if "`nmethod'" == "target" {
		return local targetmatrix `narg'
	}
	if inlist("`nmethod'","target","classical") {
		return matrix norm_stats = `norm_stats'
	}
end


// parsing utilities ==========================================================

program opt_error
	args optname detail

	dis as err `"option `optname'() invalid"'
	if `"`detail'"' != "" {
		dis as err `"`detail'"'
	}
	exit 198
end


program parse_initialize, sclass
	args opt

	sreturn clear
	local 0 `opt'
	capture noisily syntax [anything] [, Copy]
	if _rc {
		opt_error init
	}
	local 0 , `anything'
	capture noisily syntax [, Classical Random Random2(numlist max=1) ///
					From(name) ]
	if _rc {
		opt_error init
	}
	local method `classical' `random' `random2' `from'
	if (`:list sizeof method' > 1) {
		opt_error init
	}

	if "`from'" == "" & "`copy'" != "" {
		di as err "initialize(): copy only valid with from()"
		exit 198
	}
	local arg .
	if "`method'" == "" {
		local method classical
	}

	if "`random2'" != "" {
		local method random
		local arg    `random2'
	}

	if `"`from'"' != "" {
		capture confirm matrix `from'
		if _rc {
			opt_error init "matrix `from' not found"
		}
		local method from
		local arg    `from'
	}

	sreturn local arg    `arg'
	sreturn local method `method'
	sreturn local copy `copy'
end

// ============================================================================

mata:

// checks that the weight matrix is irreducible
void _mds_check_irreducible(real matrix W)
{
	if (anyof(invsym(I(cols(W))-(W:!=0):/(cols(W)+1)),0)) {
		errprintf("weight matrix is not irreducible\n")
		exit(198)
	}
}

// modify the Stata matrix _D and _W for missing values in D
//
void _mds_MissingD( string scalar _D, string scalar _W )
{
	real matrix  D, W
	real scalar  i, j, mn

	D = st_matrix(_D)
	W = st_matrix(_W)

	mn = sum(D)/sum(D:<.)

	for (i=1; i<=rows(D); i++) {
		for (j=1; j<i; j++) {
			if (missing(D[i,j])) {
				// set missing D[i,j] to mn
				D[i,j] = D[j,i] = mn

				// ... and weight W[i,j] = 0
				W[i,j] = W[j,i] = 0
			}
		}
	}

	st_replacematrix(_D, D)
	st_replacematrix(_W, W)
}


// returns the number of strictly positive values of (the lower diagonal of)
// W and the sum of the weights in the Stata scalars _npos _wsum.
//
void _mds_CountWeights( string scalar _W, string scalar _npos, string scalar _wsum )
{
	real scalar  i, j, npos, wsum
	real matrix  W

	W = st_matrix(_W)
	npos = wsum = 0
	for (i=1; i<=rows(W); i++) {
		for (j=1; j<i; j++) {
			npos = npos + (W[i,j]>0)
			wsum = wsum + W[i,j]
		}
	}
	st_numscalar(_npos, npos)
	st_numscalar(_wsum, wsum)
}


// invokes the "work horse" _mds_modern, taking care of the translation
// between Stata and Mata objects
//
void _mds_modern_shell(
	// ----------------------- // input arguments
	string scalar  _D,
	string scalar  _W,
	real   scalar  dim,
	string scalar  loss,
	string scalar  transform,
	string scalar  imethod,
	string scalar  _iarg,
	string scalar  nmethod,
	string scalar  _narg,
	string scalar  _maxopt,
	// ----------------------- // output arguments
	string scalar  _Y,
	string scalar  _critval,
	string scalar  _alpha,
	string scalar  _Disp,
	string scalar  _seed,
	string scalar  _norm_stats,
	string scalar  _rc,
	string scalar  _ic)
{
	real matrix	D, W, iarg, narg, Y, Disp, alpha, norm_stats
	real scalar	critval, rc
	string scalar	seed
	real matrix	maxopt
	real scalar	ic

	D = st_matrix(_D)

	if (_W != "." & _W != "")
		W = st_matrix(_W)
	else
		W = .

	if (_iarg != "." & _iarg != "")
		iarg = st_matrix(_iarg)
	else
		iarg = .

	if (_narg != "." & _narg != "")
		narg = st_matrix(_narg)
	else
		narg = .

	maxopt = st_matrix(_maxopt)

	rc = _mds_modern( D, W, dim, loss,
				transform, imethod, iarg, nmethod,
				narg, maxopt, Y=., critval=.,
				alpha=., Disp=., seed="", norm_stats=., ic = 0)

	st_matrix(_Y, Y)
	st_matrix(_Disp, Disp)
	st_numscalar(_alpha, alpha)
	st_numscalar(_critval, critval)
	st_strscalar(_seed, seed)
	st_matrix(_norm_stats, norm_stats)
	st_numscalar(_rc, rc)
	st_numscalar(_ic, ic)
}

end
exit
