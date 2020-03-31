*! version 1.0.2  20jan2015
program discrim_qda_estat, rclass
	version 10

	if "`e(cmd)'" != "discrim" & "`e(subcmd)'" != "qda" {
		error 301
	}

	gettoken key rest : 0, parse(", ")
	local lkey = length(`"`key'"')
	if `"`key'"' == "ic" | `"`key'"' ==  "vce" {
		// override -estat ic- and -estat vce- (they are not allowed)
		di as err "estat `key' not allowed after discrim qda"
		exit 321
	}
	else if `"`key'"' == bsubstr("covariance",1,max(3,`lkey')) {
		Cov `rest'
	}
	else if `"`key'"' == bsubstr("correlations",1,max(3,`lkey')) {
		Corr `rest'
	}
	else if `"`key'"' == bsubstr("grdistances",1,max(3,`lkey')) {
		GrDist `rest'
	}
	else {	// turn control over for common subcommands
		discrim_estat_common `0'
	}

	return add
end

// Squared Mahalanobis distances between groups and generalized ...
program GrDist, rclass
	syntax [, ALL MAHalanobis GENeralized PRIors(string) ///
		FORmat(passthru) ///
		noLABELKEY	 /// undocumented: suppress label key
		]

	if "`all'" != "" {
		local mahalanobis mahalanobis
		local generalized generalized
	}

	if "`mahalanobis'`generalized'" == "" { // default Mahalanobis
		local mahalanobis mahalanobis
	}

	tempname M Si N Ni gpriors sqd tmpm tmpz
	ChkIfEMat means
	mat `M' = e(means)

	scalar `N' = e(N)
	if missing(`N') {
		di as err "e(N) not found"
		exit 321
	}
	ChkIfEMat groupcounts
	mat `Ni' = e(groupcounts)
	local ngrps = e(N_groups)
	if missing(`ngrps') {
		di as err "e(N_groups) not found"
		exit 321
	}
	local ngm1 = `ngrps' - 1
	local nvar = e(k)
	if missing(`ngrps') {
		di as err "e(k) not found"
		exit 321
	}

	local holdnm : colnames `Ni'
	mata: _discrim_NameSub(`"`e(grouplabels)'"', "`holdnm'", ///
				/// these will be set as local macros
				"newnm", "nmlen", "anyus", "anyoth")
	local reset "*"
	if `nmlen'>0 & `nmlen'<13 & !`anyoth' {
		local reset
		if `nmlen' < 9 & `"`format'"' == ""	local nmlen 9
		if `"`format'"' == ""	local xopt `"widths(`nmlen')"'
		local xopt `"`xopt' colnames(, eq(combined))"'
		local xopt `"`xopt' rownames(,title(`e(groupvar)'))"'
	}

	if `"`priors'"' == "" {		// default to e(grouppriors)
		if `"`e(grouppriors)'"' != "matrix" {
			di as err "matrix e(grouppriors) not found"
			exit 322
		}
		mat `gpriors' = e(grouppriors)
	}
	else {
		discrim prog_utility priors `"`priors'"' `ngrps' `Ni'
		mat `gpriors' = r(grouppriors)
	}

	mat `sqd' = J(`ngrps',`ngrps',0)
	forvalues i = 1/`ngrps' {
		mat `tmpm' = `M'[1...,`i']
		ChkIfEMat sqrtS`i'inv
		mat `Si' = e(sqrtS`i'inv)

		forvalues j = 1/`ngrps' {
			if `i' != `j' {
				mat `tmpz' = `Si' * (`tmpm'-`M'[1...,`j'])
				mat `sqd'[`j',`i'] = `tmpz'' * `tmpz'
			}
		}
	}
	mat rownames `sqd' = `: colnames `M''		// sic
	mat colnames `sqd' = `: colnames `M''


	if "`mahalanobis'" != "" {
		tempname tmpM
		mat `tmpM' = `sqd'

	    // Display

		di
		di as txt "Mahalanobis squared distances between groups"

		if "`reset'" == "*" & "`labelkey'" != "nolabelkey" {
			di
			discrim prog_utility groupheader, left(4)
			local labelkey nolabelkey
		}

		`reset' mat rownames `tmpM' = `newnm'
		`reset' mat colnames `tmpM' = `newnm'
		`reset' mat coleq `tmpM' = `e(groupvar)'

		_multiplemat_tab (`tmpM', `format'), left(4) `xopt' key(,off)

		`reset' mat rownames `tmpM' = `holdnm'
		`reset' mat colnames `tmpM' = `holdnm'
		`reset' mat coleq `tmpM' = _

		return matrix sqdist   = `tmpM'
	}
	if "`generalized'" != "" {
		tempname gsqd lnd aval
		mat `gsqd' = `sqd'
		mat `lnd' = J(1,`ngrps',1)
		forvalues i = 1/`ngrps' {
			mata: st_numscalar("`aval'", ln(1/dettriangular( ///
					st_matrix("e(sqrtS`i'inv)"))^2))
			mat `lnd'[1,`i'] = `aval'
		}

		// add ln(det(cov_i)) for generalized squared distances
		mata: st_replacematrix("`gsqd'",st_matrix("`sqd'") :+ ///
							st_matrix("`lnd'"))

		// generalized squared distances also adds -2*ln(prior) 
		// except (by common convention) when equal priors
		mata: st_local("isalleq", ///
				strofreal(allof(st_matrix("`gpriors'"), ///
						st_matrix("`gpriors'")[1])))
		if !`isalleq' {
			mata: st_replacematrix("`gsqd'",st_matrix("`gsqd'") ///
					:- (2 * ln(st_matrix("`gpriors'"))))
		}

		di
		di as txt "Generalized squared distances between groups"

		if "`reset'" == "*" & "`labelkey'" != "nolabelkey" {
			di
			discrim prog_utility groupheader, left(4)
		}

		`reset' mat rownames `gsqd' = `newnm'
		`reset' mat colnames `gsqd' = `newnm'
		`reset' mat coleq `gsqd' = `e(groupvar)'

		_multiplemat_tab (`gsqd', `format'), left(4) `xopt' key(,off)

		`reset' mat rownames `gsqd' = `holdnm'
		`reset' mat colnames `gsqd' = `holdnm'
		`reset' mat coleq `gsqd' = _

		return matrix gsqdist = `gsqd'
	}
end

// Display covariance matrices
program Cov, rclass
	syntax [, FORmat(passthru) noHAlf ///
		RANK 	/// undocumented
		]

	local Ng = e(N_groups)
	local gnames `"`e(grouplabels)'"'
	tokenize `"`gnames'"'

	ChkIfEMat groupcounts
	tempname gcnts
	mat `gcnts' = e(groupcounts)

	di
	di as text "Group covariance matrices"

	forvalues i = 1/`Ng' {
		ChkIfEMat SSCP_W`i'
		tempname ans
		mat `ans' = e(SSCP_W`i') / (`gcnts'[1,`i']-1)

		di
		di as txt `"{p 2 9 2}`e(groupvar)': {res:``i''}{p_end}"'
		matlist `ans', `format' `half' left(4)

		return matrix S_`i' = `ans'
	}

	if "`rank'" != "" {
		RankSiMat
		ret add
	}
end

// Display correlation matrices
program Corr, rclass
	syntax [, P FORmat(passthru) noHAlf ]

	if "`p'" != "" {
		local sig sig
	}

	if `"`format'"' == "" {	// default to %8.5f
		local format format(%8.5f)
	}

	local Ng = e(N_groups)
	local gnames `"`e(grouplabels)'"'
	tokenize `"`gnames'"'

	ChkIfEMat groupcounts
	tempname gcnts
	mat `gcnts' = e(groupcounts)

	di
	di as text "Group correlation matrices"

	forvalues i = 1/`Ng' {
		ChkIfEMat SSCP_W`i'
		tempname ans
		mat `ans' = corr(e(SSCP_W`i') / (`gcnts'[1,`i']-1))

		if "`sig'" != "" {
			local tdf = `gcnts'[1,`i'] - 2
			tempname pmat
			mat `pmat' = `ans' // pmat will be replaced
			mata: _discrim_RhoProb("`ans'", "`pmat'", `tdf')
		}

		di
		di as txt `"{p 2 9 2}`e(groupvar)': {res:``i''}{p_end}"'

		if "`sig'" != "" {
			CorrProbShow `ans' `pmat' "`format'" "`half'"
			return matrix Rho_`i' = `ans'
			return matrix P_`i' = `pmat'
		}
		else {
			matlist `ans', `format' left(4)
			return matrix Rho_`i' = `ans'
		}
	}
end

program RankSiMat, rclass

	args stuff
	if `"`stuff'"' != "" {
		error 198
	}

	capture confirm integer number `e(N_groups)'
	if c(rc) {
		di as err "integer valued e(N_groups) not found"
		exit 321
	}
	local Ng = e(N_groups)

	tempname Arank Alndet ans atab

	mat `ans' = J(`Ng',2,.)
	forvalues i=1/`Ng' {
		capture confirm matrix e(sqrtS`i'inv)
		if c(rc) {
			di as err "e(sqrtS`i'inv) not found"
			exit 321
		}
		capture confirm matrix e(SSCP_W`i')
		if c(rc) {
			di as err "e(SSCP_W`i') not found"
			exit 321
		}

		local rnam `rnam' group`i'
		mata: st_numscalar("`Alndet'", ///
		    2*quadsum(ln(1 :/ diagonal(st_matrix("e(sqrtS`i'inv)")))))
		mata: st_numscalar("`Arank'", rank(st_matrix("e(SSCP_W`i')")))
		mat `ans'[`i',1] = `Arank'
		mat `ans'[`i',2] = `Alndet'
	}
	mat colnames `ans' = rank ln_det
	mat rownames `ans' = `rnam'

	di
	di as text "Covariance rank information"
	di

	.`atab' = ._tab.new, col(1) lmarg(4)
	.`atab'.width | 32 |
	.`atab'.sep, top
	.`atab'.titles	"Within-group covariance matrix"
	.`atab'.titles  ""
	.`atab' = ._tab.new, col(3) lmarg(4)
	.`atab'.width | 7 | 6 | 17 |
	.`atab'.numfmt . . %10.0g
	.`atab'.pad    . . 6
	.`atab'.titles ""      ""     "Natural log of "
	.`atab'.titles "Group" "Rank" "the determinant"
	.`atab'.sep, mid
	forvalues i=1/`Ng' {
		.`atab'.row `i' `ans'[`i',1] `ans'[`i',2]
	}
	.`atab'.sep, bot

	return matrix ranks = `ans'
end

program CorrProbShow
	args rmat pmat fmt nohalf rkey pkey

	if `"`rkey'"' == "" {
		local rkey Correlation
	}
	if `"`pkey'"' == "" {
		local pkey Two-sided p-value
	}

	if "`nohalf'" != "nohalf" {
		tempname rm pm
		mat `rm' = `rmat'
		mat `pm' = `pmat'

		local n = rowsof(`rmat')	// assuming square matrix

		forvalues i = 1/`= `n'- 1' {
			// set strictly upper triangle to .z to show as blank
			mat `rm'[`i',`i'+1] = J(1,`n'-`i', .z)
			mat `pm'[`i',`i'+1] = J(1,`n'-`i', .z)
		}
	}
	else {
		local rm "`rmat'"
		local pm "`pmat'"
	}

	_multiplemat_tab ///
		(`rm', `fmt' blank(.z) keyentry(`rkey')) ///
		(`pm', `fmt' blank(. .z) keyentry(`pkey')) ///
	    , left(4)
end

program ChkIfEMat
	foreach ename of local 0 {
		capture confirm matrix e(`ename')
		if c(rc) {
			di as err "e(`ename') not found"
			exit 321
		}
	}
end
