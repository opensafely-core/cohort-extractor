*! version 1.0.6  16sep2019 
program _mixed_wcorr, rclass
	version 13
	
	if "`e(cmd)'" != "mixed" {
		error 301
	}
	
	syntax [, at(string) format(string) all list noSORT COVariance *]
	
	if `"`format'"' == "" {
		local format %6.3f
	}
	
	if `"`at'"' != "" & "`all'" != "" {
		di as err "{p 0 4 2}at() may not be specified with "
		di as err "all{p_end}"
		exit 198
	}
	
	local dicor = "`covariance'" == ""
	
// Step 0: Linear regression
	
	local ivars `e(ivars)'
	if "`ivars'" == "" {
		di _n as txt "{p 0 4 2}model is linear regression; all "
		di as txt "observations are independent with standard "
		di as txt "deviation " as res exp([lnsig_e]_cons)
		di as txt "{p_end}"
		exit
	}
	
// Step 1: Determine the group to represent
	
	preserve
	tempvar touse obs
	qui gen `c(obs_t)' `obs' = _n
	qui gen byte `touse' = e(sample)
	local ivars : list uniq ivars

	local uall _all
	local hasall : list uall in ivars
	if `hasall' {
		tempvar one 
		qui gen byte `one' = 1 if e(sample)
		local ivars : subinstr local ivars "_all" "`one'", all
	}
	
	GetGroup `touse' `obs' `"`at'"' "`ivars'" "`one'" "`all'"
	
	if `dicor' di as txt _n "{p 0 4 2}Standard deviations and correlations "
	else di as txt _n "{p 0 4 2}Covariances "
	di as txt `"for `mtitle':{p_end}"'
	
// Step 2: Sort out by variable, if it exists
	
	if "`e(rbyvar)'" != "" {
		tempvar byvar
		sort `e(rbyvar)'
		qui egen long `byvar' = group(`e(rbyvar)') if e(sample)
	}
	
// Step 3: Deal with factor variables before reducing dataset
	
	local revars `e(revars)'
	local i 1
	foreach var in `revars' {
		if strpos("`var'", "R.") {
			tempname vv`i'
			local var : subinstr local var "R." ""
			qui egen long `vv`i'' = group(`var') if e(sample)
			local var `vv`i''
			qui sum `var' if e(sample)
			local varlevs `varlevs' `r(max)'
			local ++i
		}
		else {
			local varlevs `varlevs' 0
		}
		local vlist `vlist' `var'
	}
	local revars `vlist'
	
// Step 4: Get the time variable squared away, if it exists
	
	qui keep if `touse'  		// Can stop using `touse' now
	
	if "`e(timevar)'" != "" {
		tempvar time gap
		ProcessTimeVar `time' `gap' `byvar' 
	}
	
// Step 5: Sort the data
	
	sort `ivars' `byvar' `time' `obs'
	
// Step 6: Get R matrix

	foreach nm in `ivars' {
		tempvar level
		local nms `nms' `nm'
		qui egen long `level' = group(`nms')
		local levelvars `levelvars' `level'
	}
	
	tempname R 
	local rstructure `e(rstructure)'
	local rglabels `e(rglabels)'
	
	mata: _xtmc_get_R_matrix("`R'")
	mata: _xtmc_change_R_matrix("`R'")

// Step 7: Get design matrix Z
	
	tempname Z
	local redim `e(redim)'
	local ivars `e(ivars)'			
	local ivars : subinstr local ivars "_all" "`one'", all
	local uivars : list uniq ivars
	
	mata: _xtmc_get_Z_matrix("`Z'")
	
// Step 8: Get random-effects variance matrix psi
	
	tempname psi
	local ivars `e(ivars)'
	local ivars : list uniq ivars		
	local revars `e(revars)'
	local i 1
	foreach lev in `ivars' {
		tempname rmat`i'
		qui estat recovariance, relevel(`lev') noredim
		mat `rmat`i'' = r(cov)
		local cnames : colnames `rmat`i''
		mata: _xtmc_factor_up_rmat("`rmat`i''")
		local ++i
	}
	local ivars `e(ivars)'
	local ivars : subinstr local ivars "_all" "`one'", all
	local uivars : list uniq ivars		
	mata: _xtmc_get_psi_matrix("`psi'")
	
// Step 9: Put it all together
	
  	tempname V 
	mat `V' = `R'
	if colsof(`Z') {
		mat `V' = `V' + `Z'*`psi'*`Z''
	}
	
// Step 10: Do a little rounding near zero, and undo sorting if asked
	
	if "`sort'" != "" {
		tempvar nobs
		qui gen `c(obs_t)' `nobs' = _n
		sort `obs'
	}
	mata: _xtmc_round_V("`V'", 1e-8)
	
// Step 11: Standard deviations and correlations
	
	tempname corr sd
	mat `corr' = corr(`V')
	local k = colsof(`V')
	mat `sd' = J(1,`k',0)
	forvalues i = 1/`k' {
		mat `sd'[1,`i'] = sqrt(`V'[`i',`i'])
	}
	
// Step 12: Column names
	
	GetColumnNames "`time'" "`all'"
	mat colnames `corr' = `names'
	mat rownames `corr' = `names'
	mat colnames `sd' = `names'
	mat rownames `sd' = sd
	mat colnames `V' = `names'
	mat rownames `V' = `names'
	
// Step 13: Output
	
	if `dicor' {
		matlist `sd', format(`format') rowtitle("`rowtitle'") ///
			title("Standard deviations:") `options'
		matlist `corr', format(`format') rowtitle("`rowtitle'") ///
			title("Correlations:") `options'
	}
	else {
		matlist `V', format(`format') rowtitle("`rowtitle'") `options'
	}
	
// Step 14: List data
	
	if "`list'" != "" {
		GetVarList 
		
		if `"`vlist'"' != "" {
			di _n as txt "Data:"
			list `vlist'
		}
	}
	
// Step 15: Returned results
	
	return matrix sd = `sd'
	return matrix Corr = `corr'
	return matrix Cov = `V'
	return matrix G = `psi'
	return matrix Z = `Z'
	return matrix R = `R'
end

program GetGroup, sort
	args touse obs at ivars one all
	
	if "`all'" != "" {
		c_local mtitle all the data
		exit
	}
	
	local m_min : word count `ivars'
	if `"`at'"' != "" {
		tokenize `"`at'"', parse(" =,")
		while `"`1'"' != "" {
			confirm var `1'
			if "`3'" == "=" {
				mac shift 1
			}
			
			unab lev: `1' 
			local k : list lev in ivars
			if !`k' {
				di as err "{p 0 4 2}`lev' is not a level "
				di as err "variable in your model{p_end}"
				exit 198
			}	
			local m : list posof "`lev'" in ivars
			if `m' < `m_min' {
				local m_min `m'
			}
			local type : type `lev'
			if bsubstr("`type'",1,3) == "str" {
				local 3 `""`3'""'
			}
			qui count if `touse' & (`lev' == `3') 
			if !r(N) {
				di as err "{p 0 4 2}`lev' == `=`3'' not "
				di as err "represented in the estimation " 
				di as err "sample or at other "
				di as err "specified level values{p_end}"
				exit 459
			}
			qui replace `touse' = `touse' & (`lev' == `3')
			local mtitle `mtitle' `lev' = `=`3''
			
		 	if "`4'" == "," {
				mac shift 4
			}
			else { 
				mac shift 3
			}
		}
		if `m_min' > 1 {
			forvalues i = `=`m_min'-1'(-1)1 {
				local levp : word `i' of `ivars'
				CheckNesting `levp' `touse'
			}
		}
	}
	else {				// default first lowest-level group
		gsort -`touse' `obs'
		foreach lev in `ivars' {
			qui replace `touse' = `touse' & (`lev' == `lev'[1])
			if "`lev'" != "`one'" {
				local mtitle `mtitle' `lev' = `=`lev'[1]'
			}
		}
	}
	if "`mtitle'" == "" {
		local mtitle all the data
	}
	c_local mtitle `mtitle'
end

program ProcessTimeVar, sort
	args time gap byvar
	
	local struct `e(rstructure)'
	local tvar `e(timevar)'
	if "`byvar'" == "" {
		tempvar byvar
		qui gen `byvar' = 1
	}
        if inlist("`struct'", "ar", "ma", "toeplitz") {
        	sort `byvar' `tvar'
      		qui by `byvar': gen long `time'=`tvar'-`tvar'[1] + 1
		qui by `byvar': gen byte `gap' = `time' != _n 
		qui by `byvar': replace `gap' = `gap'[_N]
	}
	else if inlist("`struct'", "unstructured", "banded") {
		tempname tmap
		mat `tmap' = e(tmap)
		qui gen long `time' = 0
		local levs = colsof(`tmap')
		forvalues i = 1 /`levs' {
			qui replace `time' = `i' if `tmap'[1,`i'] == `tvar'	
		}
		sort `byvar' `time'
		qui by `byvar': gen byte `gap' = (`time'!=_n) | (_N != `levs')
		qui by `byvar': replace `gap' = `gap'[_N]
	}
	else {	// exponential
		qui gen double `time' = `tvar'
		qui gen byte `gap' = 0
		exit
	}
end

program GetColumnNames
      	args time all
	
	local struct `e(rstructure)'
	local tvar `e(timevar)'
	
	if "`time'" == "" | "`all'" != "" {
		forvalues i = 1/`=_N' {
			local names `"`names' `i'"'
		}
		local rowtitle obs
		c_local names `names'
		c_local rowtitle `rowtitle'
		exit
	}
	forvalues i = 1/`=_N' {
		local names `"`names' `=`tvar'[`i']'"'
	}
	local rowtitle `tvar'
	c_local names `names'
	c_local rowtitle `rowtitle'
end

program GetVarList
	local vlist
	local ivars `e(ivars)'
	local ivars : subinstr local ivars "_all" "", all
	local ivars : list uniq ivars
	local vlist `vlist' `ivars' 
	
	local vlist `vlist' `e(depvar)'
	
	local fnames : colnames e(b)
	local fnames : subinstr local fnames "_cons" "", all
	fvrevar `fnames', list
	local fnames `r(varlist)'
	local vlist `vlist' `fnames'
	
	local vlist `vlist' `e(rbyvar)'
	local vlist `vlist' `e(timevar)'
	
	local revars `e(revars)'
	local revars : subinstr local revars "R." "", all
	local vlist `vlist' `revars'
	
	local vlist : subinstr local vlist "_cons" "", all
	local vlist : list uniq vlist
	
	c_local vlist `vlist'
end

program CheckNesting
	args blev touse
	
	qui sum `blev' if `touse'
	if r(sd) > 0 {
		di as err "{p 0 4 2}Because of implied nesting, "
		di as err "you must also specify a value for `blev'{p_end}"
		exit 459
	}
end

mata:

void function _xtmc_get_R_matrix(string scalar rmat) 
{
	string rowvector			levels
	real matrix				Vid, R, info, irgamma
	real scalar				N, p, nrho, i
	real scalar				first, last, s2
	real colvector				beta, rho
	struct _xtm_resid scalar		resid
	
	levels = tokens(st_local("levelvars"))
	st_view(Vid=. , ., levels)
	N = rows(Vid)
	R = I(N)
	
	// Set up structure
	
	resid.rtype = st_local("rstructure")
	resid.ar_p = st_numscalar("e(ar_p)")
	resid.ma_q = st_numscalar("e(ma_q)")
	resid.order = st_numscalar("e(res_order)")
	resid.un_n = cols(st_matrix("e(tmap)"))
	if(resid.rtype == "unstructured") {
		resid.order = resid.un_n
	}
	if(st_local("time") != "") {
		resid.time = st_data(., st_local("time"))
	}
	if(st_local("byvar") != "") {
		resid.group = st_data(., st_local("byvar"))
	}
	else {
		resid.group = J(N, 1, 1)
	}
	if(st_local("gap") != "") {
		resid.gap = st_data(., st_local("gap"))
	}
	else {
		resid.gap = J(N, 1, 0)
	}
	resid.ngroups = cols(tokens(st_local("rglabels")))
	
	beta = st_matrix("e(b)")'
	p = rows(beta)
	nrho = st_numscalar("e(k_res)")
	if((resid.rtype != "independent") | (st_local("byvar") != "")) {
		rho = beta[(p-nrho+1)..p]
		info = panelsetup(Vid, cols(Vid))
		for(i=1; i<=rows(info); i++) {
			first = info[i,1]
			last = info[i,2]
			irgamma = _xtm_get_irgamma(resid, rho, first, last)
			irgamma = cross(irgamma, irgamma)
			irgamma = cholinv(irgamma)
			R[|first,first\last,last|] = irgamma
		}
	}
	s2 = exp(2*beta[(p-nrho)])
	st_matrix(rmat, s2*R)
	return
}

void function _xtmc_change_R_matrix(string scalar rmat) 
{
	real matrix				R, tempR
	real scalar				p, i, j, n, maxt
	struct _xtm_resid scalar		resid
	
	R = st_matrix(rmat)
	
	// Set up structure
	
	resid.rtype = st_local("rstructure")
	resid.order = st_numscalar("e(res_order)")
	if(st_local("time") != "") {
		resid.time = st_data(., st_local("time"))
	}
	maxt = colmax(resid.time)

	tempR = diag(R)
	p = resid.order
	n = rows(tempR)

	if (resid.rtype == "banded" | resid.rtype == "ma"| 
	    resid.rtype=="toeplitz") {
		if (resid.order > 0 & resid.order < (maxt-1)) {
			for (i=1; i<=p; i++) {
				for(j=1; j<=n-i;j++) {				
					tempR[j+i,j] = R[j+i, j]
				}
			}
			_makesymmetric(tempR)
			R = tempR					
		}
	}

	st_matrix(rmat, R)
	return
}

void function _xtmc_get_Z_matrix(string scalar zmat) 
{
	string rowvector	        lvars, redim, zvars, vlevs
	string rowvector	        levelvars, uivars
	string scalar			levelvar
	real matrix			Z, Vid, Zi, info, Zdata, F
	real rowvector			dim, zlevs, sdim, levpos
	real scalar			N, i, j, l, r, first, last, pos
	
	lvars = tokens(st_local("ivars"))
	redim = tokens(st_local("redim"))
	zvars = tokens(st_local("revars"))
	vlevs = tokens(st_local("varlevs"))
	dim = strtoreal(redim)

	if(cols(vlevs)) {
		zlevs = strtoreal(vlevs)
	}
	
	levelvars = tokens(st_local("levelvars"))
	uivars = tokens(st_local("uivars"))
	st_view(Vid=., ., lvars[1])
	N = rows(Vid)
	Z = J(N,0,0)
	Zdata = J(N,0,0)
	
	for(i=1;i<=cols(zvars);i++) {
		if(zvars[i] == "_cons") {
			Zdata = Zdata, J(N,1,1)
		}
		else if(zlevs[i]) {		// Factor variable
			F = J(N,zlevs[i],0)
			Zi = st_data(., zvars[i])
			for(j=1;j<=N;j++) {
				F[j,Zi[j]] = 1
			}
			Zdata = Zdata, F
		}
		else {				// Continuous variable
			Zdata = Zdata, st_data(., zvars[i])
		}
	}

	pos = 1
	sdim = J(1,cols(lvars),0)
	for(i=1;i<=cols(lvars);i++) {
		if (dim[i]) {
			for(j=1;j<=dim[i];j++){
				if (zlevs[pos]) sdim[i] = sdim[i]+zlevs[pos]
				else sdim[i] = sdim[i]+1
 
				pos = pos + 1			
			}
		}
	}

	pos = 1
	for(i=1;i<=cols(lvars);i++) {
		levpos = J(1,cols(uivars),0)
		for(l=1;l<= cols(uivars);l++) {
			if (uivars[l]==lvars[i]) levpos[l] = 1 
		}
		levelvar = select(levelvars, levpos)

		st_view(Vid, ., levelvar)
		// count the unique values in Vid; the number of columns
		// you need to add to Z is dim*(that number)
		info = panelsetup(Vid, 1)
		r = rows(info)
		for(j=1; j<=r; j++) {
			first = info[j,1]
			last = info[j,2]
			if(sdim[i]) {
				Zi = J(N, sdim[i], 0)
				Zi[|first,1\last,.|] = 
					Zdata[|first,pos\last,pos+sdim[i]-1|]
				Z = Z, Zi
			}
		}
		pos = pos + sdim[i]
	}
	
	st_matrix(zmat, Z)
	return
}

void function _xtmc_get_psi_matrix(string scalar psimat) 
{
	string rowvector		lvars, redim, vlevs
	string rowvector		levelvars, uivars
	string scalar			rmatname
	real rowvector			dim, zlevs, sdim
	real matrix			psi, rmat, Vid, info, subrmat
	real scalar			i, j, k, p, pos, l, rmatpos, r
	
	p = cols(st_matrix(st_local("Z")))
	if(!p) {
		st_matrix(psimat, J(1,0,0))
		return
	}
	psi = J(p, p, 0)
	uivars = tokens(st_local("uivars"))
	lvars = tokens(st_local("ivars"))
	redim = tokens(st_local("redim"))
	vlevs = tokens(st_local("varlevs"))
	levelvars = tokens(st_local("levelvars"))

	dim = strtoreal(redim)
	if(cols(vlevs)) {
		zlevs = strtoreal(vlevs)
	}

	pos = 1
	sdim = J(1,cols(lvars),0)
	for(i=1;i<=cols(lvars);i++) {
		if (dim[i]) {
			for(j=1;j<=dim[i];j++){
				if (zlevs[pos]) sdim[i] = sdim[i]+zlevs[pos]
				else sdim[i] = sdim[i]+1
 
				pos = pos + 1			
			}
		}
	}

	pos = 1
	for(i=1;i<=cols(uivars);i++) {
		rmatname = sprintf("rmat%f", i)
		rmat = st_matrix(st_local(rmatname))

		rmatpos = 1
		for(l=1;l<= cols(lvars);l++) {
			if(lvars[l]==uivars[i]){
				k = sdim[l]

				if (k>0) {
					subrmat = rmat[|rmatpos,rmatpos\
						rmatpos+k-1, rmatpos+k-1|]
				}
				else subrmat = .

				if (!missing(subrmat)) {
					st_view(Vid=. , ., levelvars[i])
					info = panelsetup(Vid, 1)
					r = rows(info)

					for(j=1;j<=r;j++) {
						psi[|pos,pos\	
						    pos+k-1,pos+k-1|] = subrmat
						pos = pos + k
					}
				}
				rmatpos = rmatpos + k
			}
		}
	}

	st_matrix(psimat, psi)
	return
}

void function _xtmc_factor_up_rmat(string scalar rmat)
{
	string rowvector		revars, varlevs, colnames
	string scalar			vname
	real rowvector			zlevs
	real matrix			R
	real scalar			pos, i, j, k

	revars = tokens(st_local("revars"))
	varlevs = tokens(st_local("varlevs"))
	colnames = tokens(st_local("cnames"))
	zlevs = strtoreal(varlevs)
	R = st_matrix(rmat)

	pos = 1 
	for(i=1;i<=cols(colnames);i++) {
		if(strpos(colnames[i], "R_") == 1) {
			vname = bsubstr(colnames[i], 3)
			// verify vname is in revars and find position
			k = 0
			for(j=1;j<=cols(revars);j++) {
				if(revars[j] == ("R."+vname)) {
					k = j
					break
				}
			}
			if(k) {
				// expand R for factor variable
				R = _xtmc_blowup_mat(R, pos, zlevs[k], 1)
				pos = pos + zlevs[k]
			}
		}
		else if (strpos(colnames[i], "Ri_") == 1) {
			vname = bsubstr(colnames[i], 4)
			// verify vname is in revars and find position
			k = 0 
			for(j=1;j<=cols(revars); j++) {
		 		if(revars[j]== ("R."+vname)) {
					k = j
					break
				}
			}
			if(k) {
				R = _xtmc_blowup_mat(R, pos, zlevs[k], 2)
				pos = pos +zlevs[k]
			}
		}
		else if (strpos(colnames[i], "Rj_")==1) {
			vname = bsubstr(colnames[i], 4)
			pos = pos 	
		}
		else {
			pos = pos + 1
		}
	}
	
	st_matrix(rmat, R)
	return	
}

real matrix function _xtmc_blowup_mat(real matrix R, 
	 			      real scalar p, 
				      real scalar q, 
				      real scalar type)
{
	real matrix		      Rnew
	real scalar		      r, i, j, nr

	if (type==1) {	
		r = rows(R)
		nr = r + q - 1
		Rnew = J(nr, nr, 0)
		for(i=1; i<=nr; i++) {
			if(i<p) {
				Rnew[1..(p-1), 1..(p-1)] = R[1..(p-1),1..(p-1)]
			}
			if(i>=p & i<=(p+q-1)) {
				Rnew[i,i] = R[p,p]
			}
			else if(i>(p+q-1)) {
				Rnew[(p+q)..nr, (p+q)..nr] = 
						R[(p+1)..r,(p+1)..r]
			}
		}
	} 
	else {
		r = rows(R)
		nr = r + q -2
		Rnew = J(nr, nr ,0)
		
		for(i=1;i<=nr; i++) {
			if(i<p) {
				Rnew[1..(p-1), 1..(p-1)] = R[1..(p-1),1..(p-1)]
			}
			else if (i>=p & i<=(p+q-1)) {
				for(j=p;j<=i;j++) {
					if(j==i) Rnew[i,i] = R[p,p]
					else Rnew[i,j] = Rnew[j,i]= R[p,p+1]
				}
			}
			else if(i>(p+q-1)) {
				Rnew[(p+q)..nr, (p+q)..nr] = 
						R[(p+2)..r,(p+2)..r]
			}
		}
	}
	return(Rnew)
}

void function _xtmc_round_V(string scalar vmat, real scalar eps)
{
	real matrix			V
	real scalar			i, j, p
	real colvector			obs
	
	V = st_matrix(vmat)
	p = cols(V)
	for(i=1; i<=p; i++) {
		for(j=1;j<=i; j++) {
			if(abs(V[i,j]) < eps) {
				V[i,j] = V[j,i] = 0
			}
		}
	}
	if(st_local("sort")=="nosort") {
		obs = st_data(., st_local("nobs"))
		V = V[obs,obs]
	}
	
	st_matrix(vmat, V)
	return
}

end

exit
