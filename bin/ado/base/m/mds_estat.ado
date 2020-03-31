*! version 1.1.6  20jan2015 
program mds_estat, rclass
	version 10

	if !inlist("`e(cmd)'", "mds", "mdsmat", "mdslong") {
		dis as err "last estimation results not found"
		exit 301
	}

	gettoken key args : 0, parse(", ")
	local lkey = length(`"`key'"')
	if `"`key'"' == bsubstr("config",1,max(3,`lkey')) {
		Config `args'
	}
	else if `"`key'"' == bsubstr("correlations",1,max(3,`lkey')) {
		Correlations `args'
	}
	else if `"`key'"' == bsubstr("losses",1,max(3,`lkey')) {
		// not to be documented yet
		Losses `args'
	}
	else if `"`key'"' == bsubstr("pairwise",1,max(4,`lkey')) {
		Pairwise `args'
	}
	else if `"`key'"' == bsubstr("quantiles",1,max(3,`lkey')) {
		Quantiles `args'
	}
	else if `"`key'"' == bsubstr("stress",1,max(3,`lkey')) {
		Stress `args'
	}
	else if `"`key'"' == bsubstr("summarize",1,max(2,`lkey')) {
		Summarize `args'
	}
	else {
		estat_default `0'
	}

	return add
end


// MDS configuration
program Config
/* MAXlen is set between 5 and 32 because titles in matlist cannot
   be less than 5 chars long.  This is consistent throughout the file. */
	syntax [, MAXlength(numlist integer min=1 max=1 >=5 <=32) ///
	          FORmat(str) * ]

	local id : word 1 of `e(id)'
	local lent = length("`id'")
	if "`maxlength'" == "" {
		local maxlength 12
	}
	local chars `maxlength'
	tempname Y
	mat Y = e(Y)
	mata: _mds_mrownamlen("Y", "loc")
	local chars = min(`loc',`maxlength')
	local lent = min(`maxlength', `lent')
	local chars = max(`chars', 5, `lent')
	
	if (`"`id'"'     != "") local ropt   rowtitle(`id')
	if (`"`format'"' == "") local format %12.4f

	dis _n as txt "Configuration in `e(p)'-dimensional Euclidean " ///
		      "space (`e(norm)' normalization)"

	matlist e(Y), left(4) border(b) `ropt' ///
	   twidth(`chars') format(`format') `options'
end


program Correlations, rclass
	syntax [, MAXlength(numlist integer min=1 max=1 >=5 <=32) ///
	          FORmat(str) noTOTal noTRANSform ]
	
	tempfile f
	predict disp diss dist wexp, pairwise(disp diss dist weights) ///
	   saving(`"`f'"') full

	preserve
	quietly use `"`f'"', clear
	
	if "`transform'" == "" {
		local yt disparities
		local y  disp
	}
	else {
		local yt dissimilarities
		local y  diss
	}
	
	local nid : word count `e(id)'
	if `nid' == 1 {
		local id1 `e(id)'1
		local id2 `e(id)'2
	}
	else if `nid' == 2 {
		local id1 : word 1 of `e(id)'
		local id2 : word 2 of `e(id)'
	}
	else {
		di as err "e(id) should contain one or two variables"
		exit 498
	}
	quiet drop if `id1' == `id2'
		
	// weights

	capture assert inlist(wexp,0,1)
	local unitweights = _rc==0

	// statistics per category

	tempname R Ri
	matrix `Ri' = J(1,3,.)
	local i = 1
	local rsp &-
	while `i' <= c(N) {
		quietly correlate `y' dist [aw=wexp] if (`id1'==`id1'[`i'])
		matrix `Ri'[1,1] = r(N)
		matrix `Ri'[1,2] = r(rho)

		quietly spearman `y' dist if (`id1'==`id1'[`i']) & (wexp>0)
		matrix `Ri'[1,3] = r(rho)

		matrix `R' = nullmat(`R') \ `Ri'
		local i = `i' + r(N)
		
		if (`i' < c(N)) local rsp `rsp'&
	}
	matrix rownames `R' = `:rownames e(Y)'
	matrix colnames `R' = N Pearson Spearman

// statistics for total

	tempname T
	matrix `T' = J(1,3,.)

	quietly correlate `y' dist [aw=wexp]
	matrix `T'[1,1] = r(N)
	matrix `T'[1,2] = r(rho)

	quietly spearman `y' dist if wexp>0
	matrix `T'[1,3] = r(rho)

	matrix rownames `T' = Total
	matrix colnames `T' = N Pearson Spearman
	
// output

	local rsp `rsp'-
	tempname RT
	mat `RT'=  `R'
	if "`total'" == "" {
		local rsp `rsp'&
		mat `RT' =  (`R' \ `T')
	}

	local lent = length("`:word 1 of `e(id)''")
	if "`maxlength'" == "" {
		local maxlength 12
	}
	local chars `maxlength'
	mata: _mds_mrownamlen("`RT'", "loc")
	local chars = min(`loc',`maxlength')
	local lent = min(`maxlength', `lent')
	local chars = max(`chars', 5, `lent')
	
	if (`"`format'"' == "") local format %9.4f

	dis as txt _n "Correlations of `yt' and Euclidean distances"
	if !`unitweights' {
		dis as txt "(unweighted Spearman correlations)"
	}		
	
	matlist `RT',  row(`:word 1 of `e(id)'') rspec(`rsp') ///
   	   cspec( o4& %`chars's | %5.0f & `format' & `format' o1&)

// return

	return matrix R = `R'
	return matrix T = `T'
end


program Losses
	syntax [, FORmat(str) *]
	
	tempname L
	matrix `L'= J(8,3,.)
	
	if "`e(W)'" == "matrix" {
		local w e(W)
	}
	
	mata: _mds_losses_shell( "e(D)", "`w'", "e(Y)", "`L'")
		
	matrix colnames `L' = unscaled scale scaled
	matrix rownames `L' = raw_stress  stress  nstress   ///
	                      raw_sstress sstress nsstress  ///
	                      strain sammon
	
	if (`"`format'"' == "") local format %10.5f
	
	dis _n as txt "Loss criteria for scaled and unscaled configuration"
	matlist `L', left(4) format(%10.5g) border(bot) `options'
end


// displays the disparities/dissimilarities, distances, & residuals
program Pairwise
	syntax [, stats(str) noTRANSform Full Separator ///
	   MAXlength(numlist integer min=1 max=1 >=5 <=32) ]

	if "`maxlength'" == "" {
		local maxlength 12
	}

	if "`stats'" == "" {
		if "`transform'" == "" {
			local stats dispar distance tresidual
		}
		else {
			local stats dissim distance rresidual
		}
	}	
	
	preserve
	tempfile f
	predict `stats', pairwise(`stats') `full' saving(`"`f'"')
	qui use `"`f'"', clear
	
	unab varlist: _all
	tokenize `varlist'
	local id1 `2'
	local id2 `4'
	tempname id1a id2a
	_nostrl error : `id1'
	capture confirm string variable `id1'
	if _rc {
		capture noi decode `id1', gen(`id1a')
		if _rc {
			qui gen str `id1a' = string(`id1')
		}
	}
	else {
		qui gen `id1a'= `id1'
	}
	qui drop `id1'
	qui gen `id1' = abbrev(`id1a', `maxlength')

	_nostrl error : `id2'
	capture confirm string variable `id2'
	if _rc {
		capture decode `id2', gen(`id2a')
		if _rc {
			qui gen str `id2a' = string(`id2')
		}
	}
	else {
		qui gen `id2a'= `id2'
	}
	qui drop `id2'
	qui gen `id2' = abbrev(`id2a', `maxlength')

	// do not show numeric indices
	mac shift 4
	local statvar `*'

	if "`separator'" != "" {
		local sep sepby(`id1')
	}
	
	list `id1' `id2' `statvar' , `sep' noobs
	restore
end


program Quantiles, rclass
	syntax [, MAXlength(numlist integer min=1 max=1 >=5 <=32) ///
		  FORmat(str) noTOTal noTRANSform  ]

	tempfile f
	tempname Q Qi T

	if "`transform'" == "" {
		local typeres tres
		local rtype   transformed
	}
	else {
		local typeres rres
		local rtype   raw
	}
	
	predict res wexp, pairwise(`typeres' weight) saving(`"`f'"') full

	preserve
	quietly use `"`f'"', clear

	local nid : word count `e(id)'
	if `nid' == 1 {
		local id1 `e(id)'1
		local id2 `e(id)'2
	}
	else if `nid' == 2 {
		local id1 : word 1 of `e(id)'
		local id2 : word 2 of `e(id)'
	}
	else {
		di as err "e(id) should contain one or two variables"
		exit 498
	}
	quiet drop if `id1' == `id2'
	sort `id1'

// statistics per category

	matrix `Qi' = J(1,6,.)
	local rsp &-
	local i = 1
	while `i' <= c(N) {
		quietly summ res [aw=wexp] if `id1'==`id1'[`i'], detail
		matrix `Qi'[1,1] = r(N)
		matrix `Qi'[1,2] = r(min)
		matrix `Qi'[1,3] = r(p25)
		matrix `Qi'[1,4] = r(p50)
		matrix `Qi'[1,5] = r(p75)
		matrix `Qi'[1,6] = r(max)

		matrix `Q' = nullmat(`Q') \ `Qi'

		quietly count if `id1'==`id1'[`i']		
		local i = `i' + r(N)
		
		if (`i' < c(N)) local rsp `rsp'&
	}
	matrix rownames `Q' = `:rownames e(Y)'
	matrix colnames `Q' = N min p25 q50 q75 max

// statistics overall

	matrix `T' = J(1,6,.)

	quietly summ res [aw=wexp], detail
	matrix `T'[1,1] = r(N)
	matrix `T'[1,2] = r(min)
	matrix `T'[1,3] = r(p25)
	matrix `T'[1,4] = r(p50)
	matrix `T'[1,5] = r(p75)
	matrix `T'[1,6] = r(max)

	matrix rownames `T' = Total
	matrix colnames `T' = N min p25 q50 q75 max

// display

	local rsp `rsp'-
	tempname QT
	mat `QT' = `Q'
	if "`total'" == "" {
		local rsp `rsp'&
		mat `QT' = (`Q' \ `T')
	}
	
	local lent = length("`: word 1 of `e(id)''")
	if "`maxlength'" == "" {
		local maxlength 12
	}
	local chars `maxlength'
	mata: _mds_mrownamlen("`QT'", "loc")
	local chars = min(`loc',`maxlength')
	local lent = min(`maxlength', `lent')
	local chars = max(`chars', 5, `lent')

	if (`"`format'"' == "") local format %8.0g

	dis as txt _n "Quantiles of `rtype' residuals"
	
	matlist `QT', row(`:word 1 of `e(id)'') rspec(`rsp') ///
	   cspec( o4& %`chars's | %5.0f & ///
		  `format' & `format' & `format' & `format' & `format' o1&)

// return

	return matrix Q = `Q'
	return matrix T = `T'
	return local  dtype `rtype'
end


program Stress, rclass
	if "`e(method)'" != "classical" {
		dis as error "(allowed only with classical scaling)"
		exit 198
	}	

	syntax [, noTRANSform ///
	   MAXlength(numlist integer min=1 max=1 >=5 <=32) ///
	   FORmat(str) noTOTal ]

	local id : word 1 of `e(id)'
	
	if (`"`id'"'     != "") local ropt   row(`id')
	if (`"`format'"' == "") local format %8.4f

	tempname linearf S T

	if "`transform'" == "" {
		matrix `linearf' = e(linearf)
		local rtype adjusted
		local dvar  disparities
	}
	else{
		matrix `linearf' = (0,1)
		local rtype raw
		local dvar  dissimilarities
	}
	matrix `S' = (.)
	matrix `T' = (.)

	mata: _mds_Stress("e(D)","e(Y)","`linearf'","`S'","`T'")

	matrix colnames `S' = Kruskal
	matrix colnames `T' = Kruskal
	matrix rownames `S' = `:rownames e(Y)'
	matrix rownames `T' = Total

	local lent = length("`id'")
	if "`maxlength'" == "" {
		local maxlength 12
	}
	local chars `maxlength'
	mata: _mds_mrownamlen("`S'", "loc")
	local chars = min(`loc',`maxlength')
	local lent = min(`maxlength', `lent')
	local chars = max(`chars', 5, `lent')

	if "`total'" == "" {
		local ST   (`S' \ `T')
		local lopt lines(rowtotal)
	}
	else {
		local ST   `S'
		local lopt border(b)
	}
	
	dis _n as txt "Stress between `dvar' and Euclidean distances"
	matlist `ST', left(4) twidth(`chars') `ropt' `lopt' format(`format')

	return matrix S = `S'
	return matrix T = `T'
	return local  dtype `rtype'
end


// Summarize displays summ statistics of variables in MDS
// only available after mds
program Summarize, rclass
	syntax [, VARlist(str) LAbel *]

	if `"`varlist'"' != "" {
		dis as err "option varlist() invalid"
		exit 198
	}

	if "`e(cmd)'" != "mds" {
		dis as err "estat summarize not valid after `e(cmd)'"
		exit 198
	}

	if "`e(coding)'" == "matrix" {
		dis as txt _n "Dissimilarities computed with "     ///
			      "respect to normalized variables" _n ///
   		              "  normalized = (original - loc)/scale"
		if "`label'" == "" {
			local lft left(2)
		}
		matlist e(coding), border(b) row(Variable) `lft'
	}

	estat_summ `e(varlist)', `options' `label'
	return add
end

// UTILITY COMMANDS //////////////////////////////////////////////////////////

program Pairwise_Hline
	args chars c
	
	dis as txt _col(5) "{hline `=2*`chars'+3'}{c `c'}{hline 41}"
end

// Mata FUNCTIONS /////////////////////////////////////////////////////////////

mata:

/* notation D(ij): disparity or dissimilarity
	    E(ij): Euclidean distance between rows of Y

   Loss or stress functions are distance measures between D and E

		     sum (E(ij) - D(ij))^2
     Kruskal = SQRT ----------------------              (Cox & Cox, p 63)
			sum E(ij)^2                  ( = Stress1 measure)
*/
void _mds_Stress( string scalar _D, string scalar _Y, string scalar _F,
			string scalar _S, string scalar _T )
{
	real scalar   Stress_n,  Stress_d,  tStress_n,  tStress_d
	real scalar   Dij, Eij, i, j, n
	real matrix   dY, D, F, S, T, Y

	D = st_matrix(_D)
	Y = st_matrix(_Y)
	F = st_matrix(_F)

	n = cols(D)
	S = J(n,1,0)
	T = J(1,1,0)

	// counter for "total" statistics
	tStress_n  = tStress_d  = 0

	for (i=1; i<=n; i++) {
		// statistics per category
		Stress_n  = Stress_d  = 0

		for (j=1; j<=n; j++) {
			if (i!=j) {
				Dij = F[1,1] + F[1,2]*D[i,j]
				dY  = Y[i,.]-Y[j,.]
				Eij = sqrt(dY*dY')

				Stress_n  = Stress_n  +	(Eij-Dij)^2
				Stress_d  = Stress_d  +	Eij^2
			}
		}

		S[i,1] = sqrt(Stress_n / Stress_d)
		tStress_n  = tStress_n  + Stress_n
		tStress_d  = tStress_d  + Stress_d
	}

	T[1,1] = sqrt(tStress_n / tStress_d)

	st_matrix(_S,S)
	st_matrix(_T,T)
}

void _mds_losses_shell( string scalar _D, string scalar _W,
			string scalar _Y, string scalar _L )
{
	real matrix L, W
	
	if (_W!="")
		W = st_matrix(_W)
	else
		W = .	

	_mds_losses(st_matrix(_D), W, st_matrix(_Y), L=.)
	
	st_matrix(_L,L)
}

void _mds_mrownamlen(string scalar Mname, string scalar loc)
{
	real matrix Mlen
	real scalar max
	string matrix Mstripe
	Mstripe = st_matrixrowstripe(Mname)
	Mlen = strlen(Mstripe)
	Mlen = rowsum(Mlen)
	max = max(Mlen)
	st_local(loc, strofreal(max))
}
	
	
end
exit
