*! version 2.2.1  08sep2017
program mdsmat, eclass
	local vv : di "version " string(_caller()) ":"
	version 10

	if replay() {
		if "`e(cmd)'" != "mdsmat" {
			dis as err "mdsmat estimation results not found"
			exit 301
		}
		Display `0'
		exit
	}

	Estimate "`vv'" `0'
	ereturn local cmdline `"mdsmat `0'"'
end


program Estimate, eclass
	gettoken vv 0 : 0

	#del ;
	syntax  anything(name=m id=matrix)
	[,
	    // data options
		SHape(passthru)
		NAMes(passthru)
		SIMilarity // Not to be documented
		s2d(passthru)
		FORCE
	    // general options
		METhod(str)	// Classical | Modern | Nonmetric
		LOSS(passthru)
		TRANSformation(passthru)                 // doc as transform()
		DIMensions(numlist integer >=1 max=1)    // doc as dim()
		WEIght(name)
	    // specific options are split up below
		*
	] ;
	#del cr

	mds_parse_method `method', `loss' `transformation'
	local loss        `s(loss)'
	local losstitle   `s(losstitle)'
	local transf      `s(transf)'
	local transftitle `s(transftitle)'
	local classical `s(classical)'	

	if "`classical'" != "" {
		if "`weight'" != "" {
			dis as err "weight() not allowed with classical MDS"
			exit 198
		}
		if matmissing(`m') {
			dis as err "missing values in (dis)similarity " ///
			           "matrix not allowed with classical MDS"
			exit 198
		}
	}

	mds_parse_cdopts `"`options'"' "`classical'"
	local copts `s(copts)'
	local dopts `s(dopts)'
	
	if "`dimensions'" != "" {
		local p `dimensions' 	
	}
	else {
		local p 2
	}
	local dim_opt dim(`p')
	
	
// get dissimilarity matrix D (and weight W) in full storage mode ////////////

	tempname DM WM X

	if "`weight'" != "" {
		confirm matrix `weight'
		local wopt weight(`weight')
	}

	GetFullDissim `m', `similarity' `names' `shape' `s2d' `force' ///
	                   `classical' `wopt'

	matrix `DM' = r(D)
	local dtype `r(dtype)'
	local s2d   `r(s2d)'
	
	// if no weight matrix was specified, a weight matrix is still returned
	// if the dissim matrix has missing values.  If classical was specified,
        // GetFullDissim would have already errored out.

	if "`r(W)'" == "matrix" {
		matrix `WM' = r(W)
		local weight_opt weight(`WM')
	}	

// MDS calculations ///////////////////////////////////////////////////////////

	if "`classical'" != "" {
		mds_classical `DM', `dim_opt' `copts'
	}
	else {
		`vv' mds_modern `DM', `dim_opt' `copts'  ///
		   loss(`loss') transform(`transf') `weight_opt'
	}

//  save rclass objects into eclass ///////////////////////////////////////////

	if "`classical'" == "classical" {
		ereturn post, prop(nob noV eigen)
	}
	else{
		ereturn post, prop(nob noV)
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
	foreach x in `:r(scalars)' {
		if "`x'" == "rc" {
			local rc `r(`x')'
			if `r(`x')' == 430 {
				eret scalar converged = 0
			}
			else if `r(`x')' == 0 & "`classical'" == ""  {
				eret scalar converged = 1
			}
		}
		ereturn	scalar `x' = r(`x')
	}
	if "`rc'" == "" {
		local rc 0
		ereturn scalar rc = 0
		if "`classical'" == "" {
			ereturn scalar converged = 1
		}
	}
	foreach x in `:r(matrices)'  {
		matrix `X' = r(`x')
		ereturn matrix `x' = `X'
	}

	ereturn local  dtype        `dtype'
	ereturn local  s2d          `s2d'
	ereturn local  dmatrix      `m'
	ereturn hidden local  id           Category
	ereturn hidden local  duplicates   0    // is enforced in GetFullDissim

	ereturn local  loss         `loss'
	ereturn local  losstitle    `losstitle'
	ereturn local  tfunction    `transf'
	ereturn local  transftitle  `transftitle'
	
	ereturn local  predict      mds_p
	ereturn local  estat_cmd    mds_estat
	ereturn local  marginsnotok _ALL

	ereturn local  cmd          mdsmat

// display output
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

// subroutines ================================================================

program ParseShape, sclass
	local 0 `", `0'"'
	syntax [, Full Lower LLower Upper UUpper ]

	local opt `full' `lower' `llower' `upper' `uupper'
	opts_exclusive "`opt'" shape

	sreturn clear
	sreturn local shape `opt'
end


program GetFullDissim, rclass
	#del ;
	syntax  anything(name=d id=matrix)
	[ ,
		SHape(str)
		NAMes(str)
		SIMilarity
		s2d(str)
		weight(str)
		classical
		FORce
	] ;
	#del cr
	confirm matrix `d'
	
	ParseShape  `shape'
	local shape `s(shape)'

	if `"`s2d'"' != "" {
		mds_parse_s2d `s2d'
		local s2d   `s(s2d)'
		local dtype similarity
	}
	else if `"`similarity'"' != "" {
		local s2d   standard	
		local dtype similarity
	}
	else {
		local dtype dissimilarity
	}	

	tempname D W
	mata: _mdsmat_GetFullDW( "`d'", "`weight'", "`shape'",	///
			"`names'", "`dtype'"=="dissimilarity",	///
			"`classical'"!="", "`force'"!="",	///
			"`D'", "`W'" )
	
	if "`dtype'" == "similarity" {
		mds_s2d `D' , `s2d'
	}	

	return clear	
	return local s2d   `s2d'
	return local dtype `dtype'
	return matrix D = `D'
	capture return matrix W = `W'
end


// ==================================================================

mata:

void _mdsmat_GetFullDW(
	string scalar _d, string scalar _w, string scalar shape,
	string scalar names, real scalar dissimilarity, real scalar classical,
	real scalar force, string scalar _D, string scalar _W )
{
	real scalar    hasW, hj, i, j, ij, lj, missW, n, nc, nn, nr, nrc
	real matrix    d, w, D, W
	string matrix  cnames

	d = st_matrix(_d)
	hasW = (_w != "")
	if (hasW) {
		w = st_matrix(_w)
	}

	assert(classical==0 | classical==1)
	assert(dissimilarity==0 | dissimilarity==1)
	assert(force==0 | force==1 )

// verify shape() vs matrix ---------------------------------------------

	nr = rows(d)
	nc = cols(d)

	if (nr == nc) {
		if (nc > 1 & shape!="" & shape!="full") {
			errprintf("shape() inconsistent with shape matrix\n")
			exit(503)
		}
		n = nc
		shape = "full"
	}
	else if (nc > 1 & nr > 1) {
		errprintf("matrix invalid; neither square nor vector\n")
		exit(503)
	}
	else {
		if (shape == "") {
			errprintf("shape() should be specified\n")
			exit(198)
		}
		else if (shape == "full") {
			errprintf("shape() invalid; matrix is a vector\n")
			exit(198)
		}

		nrc = length(d)
		nn = (1+sqrt(1+8*nrc))/2
		if (abs(nn - round(nn)) > 1e-8) {
			errprintf("length of (dis)similarity vector not " +
			"feasible for a triangle of a square matrix\n")
			exit(503)
		}
		else {
			n = round(nn)
		}

		if (shape=="lower" | shape=="upper") {
			--n
		}
	}

	if (hasW) {
		if (rows(w)!=nr | cols(w)!=nc) {
			errprintf("(dis)similarity matrix and weight " +
				"matrix not of same size\n")
			exit(198)
		}
	}

// verify names() ----------------------------------------

	if (names != "") {
		names = _mds_strcleanup(tokens(names)')
		if (rows(names) != n) {
			errprintf("names invalid; incorrect number of names\n")
			exit(198)
		}

		names = J(n,1,""), names
	}

	if (names == "" & shape != "full") {
		errprintf("names() required with triangular matrix input\n")
		exit(198)
	}

	if (names == "" & shape == "full") {
		names  = st_matrixrowstripe(_d)
		cnames = st_matrixcolstripe(_d)
		if (names != cnames) {
			printf(`"{txt}(row names of (dis)similarity "' +
				`"matrix differ from column names; "' +
				`"row names used)\n"')
		}

		if (hasW) {
			if (st_matrixrowstripe(_w)!= st_matrixcolstripe(_w)) {
				printf("{txt}(row and column names of " +
					"weight matrix differ; " +
					"this is ignored)\n")
			}
			if (st_matrixrowstripe(_w)!=names) {
				printf("{txt}(row names of weight matrix " +
					"differ from those of " +
					"(dis)similarity matrix; " +
					"this is ignored)\n")
			}
		}
	}

	for (i=2; i<=n; i++) {
		for (j=1; j<i; j++) {
			if (names[i,.]==names[j,.]) {
				errprintf("names invalid; duplicates found\n")
				exit(198)
			}
		}
	}

// create square matrix M --------------------------------------------------

	if (shape == "full") {
		D = d
		if (!issymmetric(D)) {
			if (!force) {
				errprintf("(dis)similarity matrix should " +
					"be symmetric; specify option " +
					"force to symmetrize\n")
				exit(198)
			}
			D = 0.5*(D + D')
		}

		if (hasW) {
			W = w
			if (!issymmetric(W)) {
				if (!force) {
					errprintf( "weight matrix should " +
						"be symmetric; " +
						"specify option force " +
						"to symmetrize\n")
					exit(198)
				}
				W = 0.5*(W + W')
			}
		}
	}
	else {
		D = J(n,n,0)
		if (hasW) {
			W = I(n)
		}

		ij = 1
		for (i=1; i<=n; i++) {
			if (shape == "lower") {
				lj = 1; hj = i;
			}
			else if (shape == "llower") {
				lj = 1; hj = i-1
			}
			else if (shape == "upper") {
				lj = i; hj = n
			}
			else if (shape == "uupper") {
				lj = i+1; hj = n
			}

			for (j=lj; j<=hj; j++) {
				D[i,j] = D[j,i] = d[ij]
				if (hasW)
					W[i,j] = W[j,i] = w[ij]
				++ij
			}
		}
	}

	if (!dissimilarity) {
		if ((shape=="llower" | shape=="uupper") | force) {
			for (i=1; i<=n; i++) {
				D[i,i] = 1
			}
		}
		else {
			for (i=1; i<=n; i++) {
				if (D[i,i] != 1) {
					errprintf("diagonal of similarity " +
						"matrix should be 1\n")
					exit(198)
				}
			}
		}

		for (i=1; i<=n; i++) {
			for (j=1; j<=i-1; j++) {
				if (D[i,j]<0 | D[i,j]>1) {
					errprintf("entries of similarity " +
						"matrix should be " +
						"in the range [0,1]\n")
					exit(198)
				}
			}
		}
	}

	if (dissimilarity) {
		if (force) {
			for (i=1; i<=n; i++) {
				D[i,i] = 0
			}
		}
		else if (shape!="llower" & shape!="uupper") {
			for (i=1; i<=n; i++) {
				if (D[i,i] != 0) {
				errprintf("diagonal of dissimilarity " +
					"matrix should be 0\n")
				exit(198)
				}
			}
		}

		for (i=1; i<=n; i++) {
			for (j=1; j<=i-1; j++) {
				if (D[i,j] < 0) {
					errprintf("entries of dissimilarity " +
						"matrix should be >= 0\n")
					exit(198)
				}
			}
		}
	}

// check for negative weights; missing weights set to 0 ---------------

	if (hasW) {
		missW = 0
		for (i=1; i<=n; i++) {
			for (j=1; j<=i; j++) {
				if (W[i,j]<0) {
					errprintf("negative weights " +
						"not allowed\n")
					exit(198)
				}
				if (missing(W[i,j])) {
					W[i,j] = W[j,i] = 0
					missW  = 1
				}
			}
		}
		if (missW) {
			printf("{txt}(missing weights set to 0)\n")
		}
	}

// deal with missing values in D

	if (missing(D)) {
		if (classical) {
			errprintf("Classical MDS does not allow missing " +
				"values\n")
			exit(198)
		}

		if (!hasW) {
			W = J(n,n,1)
			hasW = 1
		}
		for (i=1; i<=cols(D); i++) {
			for (j=1; j<=i; j++) {
				if (missing(D[i,j])) {
					D[i,j] = D[j,i] = !dissimilarity
					W[i,j] = W[j,i] = 0
				}
			}
		}
	}

// convert to dissimilarities ------------------------------------------

	st_matrix(_D, D)
	st_matrixrowstripe(_D, names)
	st_matrixcolstripe(_D, names)

	if (hasW) {
		st_matrix(_W, W)
		st_matrixrowstripe(_W, names)
		st_matrixcolstripe(_W, names)
	}
}
end
exit
