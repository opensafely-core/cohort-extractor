*! version 1.1.0  03feb2015
program discrim_lda_estat, rclass
	version 10
	local vv : di "version " string(_caller()) ":"

	if ("`e(cmd)'" != "discrim" | "`e(subcmd)'" != "lda") & ///
						"`e(cmd)'" != "candisc" {
		error 301
	}

	gettoken key rest : 0, parse(", ")
	local lkey = length(`"`key'"')
	if `"`key'"' == "ic" | `"`key'"' ==  "vce" {
		// override -estat ic- and -estat vce- (they are not allowed)
		di as err "estat `key' not allowed after `e(cmd)' `e(subcmd)'"
		exit 321
	}
	else if `"`key'"' == bsubstr("grmeans",1,max(3,`lkey')) {
		GroupMeans `rest'
	}
	else if `"`key'"' == bsubstr("grdistances",1,max(3,`lkey')) {
		GroupDist `rest'
	}
	else if `"`key'"' == bsubstr("manova",1,max(3,`lkey')) {
		`vv' Manova `rest'
	}
	else if `"`key'"' == bsubstr("anova",1,max(2,`lkey')) {
		`vv' Anova `rest'
	}
	else if `"`key'"' == bsubstr("canontest",1,max(3,`lkey')) {
		CanDisc `rest'
	}
	else if `"`key'"' == bsubstr("loadings",1,max(3,`lkey')) {
		Loadings `rest'
	}
	else if `"`key'"' == bsubstr("structure",1,max(3,`lkey')) {
		CanStruct `rest'
	}
	else if `"`key'"' == bsubstr("classfunctions",1,max(6,`lkey')) {
		ClassFunc `rest'
	}
	else if `"`key'"' == bsubstr("covariance",1,max(3,`lkey')) {
		Cov `rest'
	}
	else if `"`key'"' == bsubstr("correlations",1,max(3,`lkey')) {
		Corr `rest'
	}
	else {	// turn control over for common subcommands
		discrim_estat_common `0'
	}

	return add
end

program GroupMeans, rclass

	if trim(`"`0'"') == "" { // default is raw means only
		local 0 ", raw"
	}

	syntax [, ALL Raw Totalstd Withinstd Canonical ///
			noLABELKEY	/// undocumented
		]

	if "`all'" != "" {
		local raw raw 
		local totalstd totalstd
		local withinstd withinstd
		local canonical canonical
	}

	if "`raw'`totalstd'`withinstd'" != "" {
		ChkIfEMat means
		tempname M
		mat `M' = e(means)
	}
	if "`totalstd'" != "" {
		ChkIfEMat SSCP_T
		tempname T
		mat `T' = e(SSCP_T)
	}
	if "`withinstd'" != "" {
		ChkIfEMat S
		tempname S
		mat `S' = e(S)
	}
	if "`canonical'" != "" {
		ChkIfEMat cmeans
		tempname Cmn
		mat `Cmn' = e(cmeans)
	}

	if "`totalstd'`withinstd'" != "" {
		tempname N
		scalar `N' = e(N)
		if missing(`N') {
			di as err "e(N) not found"
			exit 321
		}
	}

	tempname Ni
	ChkIfEMat groupcounts
	mat `Ni' = e(groupcounts)
	local ngrps = e(N_groups)
	if missing(`ngrps') {
		di as err "e(N_groups) not found"
		exit 321
	}

	local holdnm : colnames `Ni'
	mata: _discrim_NameSub(`"`e(grouplabels)'"', "`holdnm'", ///
				/// these will be set as local macros
				"newnm", "nmlen", "anyus", "anyoth")
	local reset "*"
	local dolk  "*"
	if `nmlen'>0 & `nmlen'<13 & !`anyoth' {
		local reset
		local eqopt showcoleq(lcomb)
	}
	else if "`labelkey'" != "nolabelkey" {
		local dolk
	}

	if "`raw'" != "" {
		tempname tmpM
		mat `tmpM' = `M'
		`reset' mat colnames `tmpM' = `newnm'
		`reset' mat coleq `tmpM' = `e(groupvar)'

		di
		di as txt "Group means"

		`dolk' di
		`dolk' discrim prog_utility groupheader, left(4)
		`dolk' local dolk "*"

		matlist `tmpM', left(4) `eqopt' underscore

		`reset' mat colnames `tmpM' = `holdnm'
		`reset' mat coleq `tmpM' = _

		return matrix means = `tmpM'
	}

	if "`totalstd'" != "" {
		tempname tmpM
		mat `tmpM' = `M'

					// tmpM overwritten with stdized means
		mata: _discrim_StdGrpMeans("`tmpM'", "`T'", "`Ni'", "`N'")

		`reset' mat colnames `tmpM' = `newnm'
		`reset' mat coleq `tmpM' = `e(groupvar)'

		di
		di as txt "Total-sample standardized group means"

		`dolk' di
		`dolk' discrim prog_utility groupheader, left(4)
		`dolk' local dolk "*"

		matlist `tmpM', left(4) `eqopt' underscore

		`reset' mat colnames `tmpM' = `holdnm'
		`reset' mat coleq `tmpM' = _

		return matrix stdmeans = `tmpM'
	}

	if "`withinstd'" != "" {
		tempname tmpM
		mat `tmpM' = `M'

					// tmpM overwritten with stdizd means
		mata: _discrim_WStdGrpMeans("`tmpM'", "`S'", "`Ni'", "`N'")

		`reset' mat colnames `tmpM' = `newnm'
		`reset' mat coleq `tmpM' = `e(groupvar)'

		di
		di as txt "Pooled within-group standardized group means"

		`dolk' di
		`dolk' discrim prog_utility groupheader, left(4)
		`dolk' local dolk "*"

		matlist `tmpM', left(4) `eqopt' underscore

		`reset' mat colnames `tmpM' = `holdnm'
		`reset' mat coleq `tmpM' = _

		return matrix wstdmeans = `tmpM'
	}

	if "`canonical'" != "" {
		// SAS labels this "Class Means on Canonical Variables"
		// SPSS labels this "Functions at Group Centroids"
		//   with subcaption "Unstandardized canonical discriminant
		//   functions evaluated at group means"

		`reset' mat rownames `Cmn' = `newnm'
		`reset' local rtl rowtitle(`e(groupvar)')

		di
		di as txt "Group means on canonical variables"

		`dolk' di
		`dolk' discrim prog_utility groupheader, left(4)
		`dolk' local dolk "*"

		matlist `Cmn', left(4) `rtl' underscore

		`reset' mat rownames `Cmn' = `holdnm'

		return matrix cmeans = `Cmn'
	}
end

program GroupDist, rclass
	syntax [, ALL MAHalanobis2(str) MAHalanobis GENeralized ///
		PRIors(string) FORmat(passthru) ///
		noLABELKEY	/// undocumented: suppress label key
		]

	if `"`mahalanobis'`mahalanobis2'`generalized'"' == "" {	// set default
		local mahalanobis mahalanobis
	}

	if `"`mahalanobis2'"' != "" {
		local mahalanobis mahalanobis
		local 0 `", `mahalanobis2'"'
		capture syntax [, F P ]
		if c(rc) {
			di as err "invalid mahalanobis()"
			exit 198
		}
		syntax [, F P ]

		if "`f'" != "" & "`p'" != ""	local sqdcase 4
		else if "`p'" != ""		local sqdcase 3
		else if "`f'" != ""		local sqdcase 2
	}
	else if "`mahalanobis'" != ""		local sqdcase 1

	if "`all'" != "" {
		local mahalanobis mahalanobis
		local sqdcase 4			// same as mahalanobis(f p)
		local generalized generalized
	}

	tempname M Sinv N Ni gpriors sqd tmpm
	ChkIfEMat means
	mat `M' = e(means)
	ChkIfEMat Sinv
	mat `Sinv' = e(Sinv)

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
		local xopt `"`xopt' colnames(, eq(combined) underscore)"'
		local xopt `"`xopt' rownames(,title(`e(groupvar)') underscore)"'
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
	forvalues i = 1/`ngm1' {
		mat `tmpm' = `M'[1...,`i']
		forvalues j = 2/`ngrps' {
			mat `sqd'[`j',`i'] = (`tmpm'-`M'[1...,`j'])' * ///
						`Sinv' * (`tmpm'-`M'[1...,`j'])
		}
	}
	forvalues i = 1/`ngm1' {
		forvalues j = 2/`ngrps' {
			mat `sqd'[`i',`j'] = `sqd'[`j',`i']
		}
	}
	mat rownames `sqd' = `: colnames `M''		// sic
	mat colnames `sqd' = `: colnames `M''


	if "`mahalanobis'" != "" {
		tempname tmpM tmpF tmpP
		mat `tmpM' = `sqd'

	    // F stats
		mat `tmpF' = J(`ngrps',`ngrps',0)
		local df1 = `nvar'
		local df2 = `N' - `ngrps' - `nvar' + 1
		local tmpc = `df2' / (`nvar'*(`N' - `ngrps'))
		forvalues i=2/`ngrps' {
			local n1 = `Ni'[1,`i']
			forvalues j=1/`ngm1' {
				local n2 = `Ni'[1,`j']
				mat `tmpF'[`i',`j'] = `tmpc' * ///
						(`n1'*`n2'/(`n1'+`n2')) * ///
						`tmpM'[`i',`j']
				mat `tmpF'[`j',`i'] = `tmpF'[`i',`j']
			}
		}
		mat rownames `tmpF' = `: colnames `tmpM''	// sic
		mat colnames `tmpF' = `: colnames `tmpM''

	    // p-values
		mat `tmpP' = J(`ngrps',`ngrps',1)
		forvalues i=2/`ngrps' {
			forvalues j=1/`ngm1' {
				mat `tmpP'[`i',`j'] = Ftail(	///
						`df1',`df2',`tmpF'[`i',`j'])
				mat `tmpP'[`j',`i'] = `tmpP'[`i',`j']
			}
		}
		mat rownames `tmpP' = `: colnames `tmpM''	// sic
		mat colnames `tmpP' = `: colnames `tmpM''

		local mkey Mahalanobis squared distance
		local fkey F with `df1' and `df2' df
		local pkey p-value

	    // Display
		tempname tmpM2 tmpF2 tmpP2
		mat `tmpM2' = `tmpM'
		mat `tmpF2' = `tmpF'
		mat `tmpP2' = `tmpP'
		forvalues i = 1/`ngm1' {
		// set strictly upper triangle to .z to show as blank
			mat `tmpM2'[`i',`i'+1] = J(1,`ngrps'-`i', .z)
			mat `tmpF2'[`i',`i'+1] = J(1,`ngrps'-`i', .z)
			mat `tmpP2'[`i',`i'+1] = J(1,`ngrps'-`i', .z)
		}
		`reset' mat rownames `tmpM2' = `newnm'
		`reset' mat colnames `tmpM2' = `newnm'
		`reset' mat coleq `tmpM2' = `e(groupvar)'

		di
		di as txt "Mahalanobis squared distances between groups"

		if "`reset'" == "*" & "`labelkey'" != "nolabelkey" {
			di
			discrim prog_utility groupheader, left(4)
			local labelkey nolabelkey
		}

		if `sqdcase' == 1 {
			_multiplemat_tab (`tmpM2', blank(.z) `format'), ///
						left(4) `xopt' key(,off)
		}
		else if `sqdcase' == 2 { // F
			_multiplemat_tab ///
			    (`tmpM2', blank(.z) keyentry(`mkey') `format') ///
			    (`tmpF2', blank(.z) keyentry(`fkey') `format') ///
	    		    , left(4) `xopt'
		}
		else if `sqdcase' == 3 { // P
			_multiplemat_tab ///
			    (`tmpM2', blank(.z) keyentry(`mkey') `format') ///
			    (`tmpP2', blank(.z) keyentry(`pkey') `format') ///
	    		    , left(4) `xopt'
		}
		else if `sqdcase' == 4 { // F and P
			_multiplemat_tab ///
			    (`tmpM2', blank(.z) keyentry(`mkey') `format') ///
			    (`tmpF2', blank(.z) keyentry(`fkey') `format') ///
			    (`tmpP2', blank(.z) keyentry(`pkey') `format') ///
	    		    , left(4) `xopt'
		}
		return matrix sqdist   = `tmpM'
		return matrix F_sqdist = `tmpF'
		return matrix P_sqdist = `tmpP'
		return scalar df2 = `df2'
		return scalar df1 = `df1'
	}
	if "`generalized'" != "" {
		// generalized squared distances also does -2*ln(prior) 
		// except (by common convention) when equal priors
		tempname gsqd
		matrix `gsqd' = `sqd'
		mata: st_local("isalleq", ///
				strofreal(allof(st_matrix("`gpriors'"), ///
						st_matrix("`gpriors'")[1])))
		if !`isalleq' {
			mata: st_replacematrix("`gsqd'",st_matrix("`sqd'") ///
					:- (2 * ln(st_matrix("`gpriors'"))))
		}

		tempname gtmp
		mat `gtmp' = `gsqd'
		if issymmetric(`gtmp') {
			forvalues i = 1/`ngm1' {
			// set strictly upper triangle to .z to show as blank
				mat `gtmp'[`i',`i'+1] = J(1,`ngrps'-`i', .z)
			}
		}
		`reset' mat rownames `gtmp' = `newnm'
		`reset' mat colnames `gtmp' = `newnm'
		`reset' mat coleq `gtmp' = `e(groupvar)'

		di
		di as txt "Generalized squared distances between groups"

		if "`reset'" == "*" & "`labelkey'" != "nolabelkey" {
			di
			discrim prog_utility groupheader, left(4)
		}

		_multiplemat_tab (`gtmp', blank(.z) `format'), ///
						left(4) `xopt' key(,off)

		return matrix gsqdist = `gsqd'
	}
end

program CanDisc, rclass

	args stuff

	if `"`stuff'"' != "" {
		error 198
	}

        capture confirm integer number `e(f)'
        if c(rc) {
                di as err "integer valued e(f) not found"
                exit 321
        }
        local Nf = e(f)

        capture confirm integer number `e(N_groups)'
        if c(rc) {
                di as err "integer valued e(N_groups) not found"
                exit 321
        }
        local Ng = e(N_groups)

	capture confirm integer number `e(N)'
        if c(rc) {
                di as err "integer valued e(N) not found"
                exit 321
        }
        local N = e(N)

	capture confirm integer number `e(k)'
	if c(rc) {
		di as err "integer valued e(k) not found"
		exit 321
	}
	local Nvar = e(k)

	ChkIfEMat candisc_stat
	tempname ans tab
	mat `ans' = e(candisc_stat)

	di
	di as txt "Canonical linear discriminant analysis"
	di

	// don't want lines extending under last column, so do my own
	local mymidline "  {hline 4}{c +}{hline 33}{c +}{hline 36}"
	local mybotline "  {hline 4}{c BT}{hline 33}{c BT}{hline 36}"

	.`tab' = ._tab.new, col(11)
	.`tab'.width  4    | 8     9 8     8    | 8     8 6 7 8     2
	.`tab'.numfmt %3.0f  %6.4f . %6.4f %6.4f  %6.4f . . . %6.4f .
	.`tab'.pad    .      1     . 1     1      1     . . . 1     .

	.`tab'.titles "" "" "" "" "" "Like- " "" "" "" "" ""
	// Want "Variance" to span two columns so use -di- to force it
	di "      {c |} Canon.   Eigen-     Variance    {c |} lihood"
	.`tab'.titles "Fcn" "Corr. " "value " "Prop. " "Cumul."	///
			"Ratio " "F   " "df1" "df2" "Prob>F" ""
	di as text "`mymidline'"

	forvalues i = 1/`Nf' {
		if `ans'[`i',10] {		// exact F
			local exchar e
		}
		else {				// approx. F
			local exchar a
		}
		.`tab'.row ///
			`i'		/// Fcn
			`ans'[`i',1]	/// Canonical Corr.
			`ans'[`i',2]	/// Eigenvalue
			`ans'[`i',3]	/// Proportion
			`ans'[`i',4]	/// Cumulative proportion
			`ans'[`i',5]	/// Wilks' Lambda
			`ans'[`i',6]	/// F
			`ans'[`i',7]	/// df1
			`ans'[`i',8]	/// df2
			`ans'[`i',9]	/// p-value
			"`exchar'"	//  e=exact F, a=approximate F
	}
	di as text "`mybotline'"
	di as text "  Ho: this and smaller canon. corr. are zero;" _c
	if `Nf' > 2 {
		di as text "  e = exact F, a = approximate F"
	}
	else {
		di as text "                     e = exact F"
	}

	return scalar N = `N'
	return scalar f = `Nf'
	return scalar N_groups = `Ng'
	return scalar k = `Nvar'

	return matrix stat = `ans'
end

program Manova, rclass
	version 10
	local vv : di "version " string(_caller()) ":"

	args stuff

	if `"`stuff'"' != "" {
		error 198
	}

	ChkIfEMat means

	tempname todo eholder
	qui gen byte `todo' = e(sample)
	local grpvar "`e(groupvar)'"
	local vars "`: rownames e(means)'"
	_estimates hold `eholder', restore

	`vv' manova `vars' = `grpvar' if `todo'

	tempname stm
	mat `stm' = e(stat_m)
	return scalar N = e(N)
	return scalar df_m = e(df_m)
	return scalar df_r = e(df_r)
	return matrix stat_m = `stm'
end

program Anova, rclass
	version 10
	local vv : di "version " string(_caller()) ":"

	args stuff
	if `"`stuff'"' != "" {
		error 198
	}

	ChkIfEMat means

	tempname todo eholder mns
	qui gen byte `todo' = e(sample)
	local grpvar "`e(groupvar)'"
	mat `mns' = e(means)
	local vars "`: rownames `mns''"
	_estimates hold `eholder', restore

	tempname ans
	local nv = rowsof(`mns')
	// columns are: Model MS, Res MS, Tot MS, R-sq, adj R-sq, F, pval
	mat `ans' = J(`nv',7,.)
	local i 0
	local var_abrev = ""
	foreach v of local vars {
		local v2 = abbrev("`v'",11)
		local var_abrev = "`var_abrev' `v2'"
		local ++i
		qui anova `v' `grpvar' if `todo'
		if (`i'==1) {
			local N = e(N)
			local mdf = e(df_m)
			local rdf = e(df_r)
		}
		mat `ans'[`i',1] = e(mss)
		mat `ans'[`i',2] = e(rss)
		mat `ans'[`i',3] = (e(mss)*`mdf' + e(rss)*`rdf')/(`N' - 1)
		mat `ans'[`i',4] = e(r2)
		mat `ans'[`i',5] = e(r2_a)
		mat `ans'[`i',6] = e(F)
		mat `ans'[`i',7] = Ftail(`mdf',`rdf',e(F))
	}
	mat colnames `ans' = ///
		Model_MS Resid_MS Total_MS R-sq Adj_R-sq F Prob_>_F
	mat rownames `ans' = `var_abrev'

	di
	di as txt "Univariate ANOVA summaries"
	di

	tempname tb
	.`tb' = ._tab.new, col(8)
	.`tb'.width     12 | 11  11  11  7  8  8  7
	.`tb'.numfmt	.    .   .   .   %6.4f %7.4f . %6.4f
	.`tb'.pad       .    .   .   .   1  1  1  1
	.`tb'.titles    ""   ""  ""  ""  "" "Adj." "" ""
        .`tb'.titles	"Variable"	///
                        "Model MS"	///
                        "Resid MS"	///
                        "Total MS"	///
                        "R-sq"		///
                        "R-sq"		///
                        "F  "		///
			" Pr > F"
	.`tb'.sep, mid
	forvalues i = 1/`nv' {
		.`tb'.row	"`: word `i' of `var_abrev''"	///
				`ans'[`i',1]			///
				`ans'[`i',2]			///
				`ans'[`i',3]			///
				`ans'[`i',4]			///
				`ans'[`i',5]			///
				`ans'[`i',6]			///
				`ans'[`i',7]
	}
	.`tb'.sep, bot

	di as txt _col(3) "Number of obs = " as res %-12.0fc `N'	///
		as txt _col(32) "Model df = " as res %-8.0fc `mdf'	///
		as txt _col(52) "Residual df = " as res %-12.0fc `rdf'

	return scalar N = `N'
	return scalar df_m = `mdf'
	return scalar df_r = `rdf'
	return matrix anova_stats = `ans'
end

// Display correlation matrices
program Corr, rclass
	syntax [, Within Between Total Groups ALL P FORmat(passthru) noHAlf ]

	if "`p'" != "" {
		local sig sig
	}

	if `"`format'"' == "" {	// default to %8.5f
		local format format(%8.5f)
	}

	if "`all'" != "" {
		local within within
		local between between
		local total total
		local groups groups
	}
	if "`within'`between'`total'`groups'" == "" {
		// Pooled within-group correlation is the default
		local within within
	}

	if "`within'" != "" {	// Pooled within-group correlation matrix
		ChkIfEMat S
		tempname ans
		mat `ans' = corr(e(S))

		if "`sig'" != "" {
			local tdf = e(N) - e(N_groups) - 1
			tempname pmat
			mat `pmat' = `ans' // pmat will be replaced next line
			mata: _discrim_RhoProb("`ans'", "`pmat'", `tdf')
		}

		di
		di as text "Pooled within-group correlation matrix"

		if "`sig'" != "" {
			CorrProbShow `ans' `pmat' "`format'" "`half'"
			return matrix Rho = `ans'
			return matrix P = `pmat'
		}
		else {
			matlist `ans', `format' left(4) `half'
			return matrix Rho = `ans'
		}
	}

	if "`between'" != "" {	// Between-groups correlation matrix
		ChkIfEMat SSCP_B

		local Ng = e(N_groups)

		tempname ans
		mat `ans' = corr(e(SSCP_B) / (e(N)*((`Ng'-1)/`Ng')))

		if "`sig'" != "" {
			local tdf = `Ng' - 2
			tempname pmat
			mat `pmat' = `ans' // pmat will be replaced next line
			mata: _discrim_RhoProb("`ans'", "`pmat'", `tdf')
		}

		di
		di as text "Between-groups correlation matrix"

		if "`sig'" != "" {
			CorrProbShow `ans' `pmat' "`format'" "`half'"
			return matrix Rho_between = `ans'
			return matrix P_between = `pmat'
		}
		else {
			matlist `ans', `format' left(4) `half'
			return matrix Rho_between = `ans'
		}
	}

	if "`total'" != "" {	// Total-sample correlation matrix
		ChkIfEMat SSCP_T
		tempname ans
		mat `ans' = corr(e(SSCP_T) / (e(N)-1))

		if "`sig'" != "" {
			local tdf = e(N) - 2
			tempname pmat
			mat `pmat' = `ans' // pmat will be replaced next line
			mata: _discrim_RhoProb("`ans'", "`pmat'", `tdf')
		}

		di
		di as text "Total-sample correlation matrix"

		if "`sig'" != "" {
			CorrProbShow `ans' `pmat' "`format'" "`half'"
			return matrix Rho_total = `ans'
			return matrix P_total = `pmat'
		}
		else {
			matlist `ans', `format' left(4)
			return matrix Rho_total = `ans'
		}
	}

	if "`groups'" != "" {	// Individual group correlation matrices
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
	}
end

// Display loadings
program Loadings, rclass
	syntax [, ALL STandardized UNSTandardized TOTalstandardized ///
		FORmat(passthru) ]

	if "`all'`unstandardized'`standardized'`totalstandardized'" == "" {
		// default to standardized
		local standardized standardized
	}
	else if "`all'" != "" {
		local unstandardized unstandardized
		local standardized standardized
		local totalstandardized totalstandardized
	}

	if "`unstandardized'" != "" {
		tempname ans

		ChkIfEMat L_unstd
		mat `ans' = e(L_unstd)

		di
		di as text "Canonical discriminant function coefficients"
		matlist `ans', `format' left(4)

		return matrix L_unstd = `ans'
	}

	if "`standardized'" != "" {
		// standardized by within-class variance
		tempname ans2

		ChkIfEMat L_std
		mat `ans2' = e(L_std)

		di
		di as text ///
		    "Standardized canonical discriminant function coefficients"
		matlist `ans2', `format' left(4)

		return matrix L_std = `ans2'
	}

	if "`totalstandardized'" != "" {
		// standardized by total-class variance
		tempname ans3

		ChkIfEMat L_totalstd
		mat `ans3' = e(L_totalstd)

		di
		di as text "Total-sample standardized canonical " ///
			   "discriminant function coefficients"
		matlist `ans3', `format' left(4)

		return matrix L_totalstd = `ans3'
	}
end

// Display canonical structure matrix
program CanStruct, rclass
	syntax [, FORmat(passthru) ]

	tempname ans

	ChkIfEMat canstruct
	mat `ans' = e(canstruct)

	di
	di as text "Canonical structure"
	matlist `ans', `format' left(4)

	return matrix canstruct = `ans'
end

// Display Classification functions
program ClassFunc, rclass
	syntax [, FORmat(passthru) PRIors(string) noPRIors2 ADJUSTEQual ///
			noLABELKEY	/// undocumented: suppress label key
		]

	// -priors()- tells what priors to use in doing the classification
	// -nopriors- only says to not display the priors.

	local adjeq 0
	if "`adjustequal'" != "" {
		local adjeq 1
	}

	tempname C gpriors Ni M

	ChkIfEMat C
	mat `C' = e(C)
	ChkIfEMat means
	mat `M' = e(means)'	// notice the transpose

	ChkIfEMat groupcounts
	mat `Ni' = e(groupcounts)
	local ngrps = e(N_groups)
	if missing(`ngrps') {
		di as err "e(N_groups) not found"
		exit 321
	}

	di
	di as text "Classification functions"

	local holdnm : colnames `Ni'
	mata: _discrim_NameSub(`"`e(grouplabels)'"', "`holdnm'", ///
				/// these will be set as local macros
				"newnm", "nmlen", "anyus", "anyoth")

	local reset "*"
	if `nmlen'>0 & `nmlen'<13 & !`anyoth' {
		local reset
		local eqopt showcoleq(lcomb)
	}
	else if "`labelkey'" != "nolabelkey" {
		di
		discrim prog_utility groupheader, left(4)
	}

	if `"`priors'"' == "" { // get priors from e() if not specified
		mat `gpriors' = e(grouppriors)
	}
	else {
		discrim prog_utility priors `"`priors'"' `ngrps' `Ni'
		mat `gpriors' = r(grouppriors)
	}
	mat colnames `gpriors' = `: colnames `C''
	mat rownames `gpriors' = Priors

	// replace bottom row (_cons row) of C based on gpriors
	mata: _discrim_FixCcons("`C'", "`gpriors'", "`M'", `adjeq')

	`reset' mat colnames `C' = `newnm'
	`reset' mat coleq `C' = `e(groupvar)'

	if "`priors2'" != "nopriors2" {
		`reset' mat colnames `gpriors' = `newnm'
		`reset' mat coleq `gpriors' = `e(groupvar)'

		matlist (`C')\(`gpriors') , `format' left(4) ///
						`eqopt' lines(rowtotal)

		`reset' mat colnames `gpriors' = `holdnm'
		`reset' mat coleq `gpriors' = _
	}
	else {
		matlist `C', `format' left(4) `eqopt'
	}
	// Can't use -underscore- option on 2 -matlist- commands above
	// because we would lose the underscore on _cons

	`reset' mat colnames `C' = `holdnm'
	`reset' mat coleq `C' = _

	return matrix C = `C'
	return matrix priors = `gpriors'
end

// Display covariance matrices
program Cov, rclass
	syntax [, Within Between Total Groups ALL FORmat(passthru) noHAlf ///
		RANK 	/// undocumented
		]

	if "`all'" != "" {
		local within within
		local between between
		local total total
		local groups groups
		// all does not include -rank- (which is undocumented)
	}
	if "`within'`between'`total'`groups'`rank'" == "" {
		// Pooled within-group covariance is the default
		local within within
	}

	if "`within'" != "" {	// Pooled within-group covariance matrix
		ChkIfEMat S
		tempname ans
		mat `ans' = e(S)

		di
		di as text "Pooled within-group covariance matrix"
		matlist `ans', `format' `half' left(4)

		return matrix S = `ans'
	}

	if "`between'" != "" {	// Between-groups covariance matrix
		ChkIfEMat SSCP_B

		local Ng = e(N_groups)

		tempname ans
		mat `ans' = e(SSCP_B) / (e(N)*((`Ng'-1)/`Ng'))

		di
		di as text "Between-groups covariance matrix"
		matlist `ans', `format' `half' left(4)

		return matrix S_between = `ans'
	}

	if "`total'" != "" {	// Total-sample covariance matrix
		ChkIfEMat SSCP_T
		tempname ans
		mat `ans' = e(SSCP_T) / (e(N)-1)

		di
		di as text "Total-sample covariance matrix"
		matlist `ans', `format' `half' left(4)

		return matrix S_total = `ans'
	}

	if "`groups'" != "" {	// Individual group covariance matrices
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
	}

	if "`rank'" != "" {
		RankSMat
		ret add
	}
end

program RankSMat, rclass

	ChkIfEMat S sqrtSinv

	tempname Srank Slndet atab

	mata: st_numscalar("`Slndet'", ///
			2*quadsum(ln(1 :/ diagonal(st_matrix("e(sqrtSinv)")))))

	mata: st_numscalar("`Srank'", rank(st_matrix("e(S)")))

	di

	.`atab' = ._tab.new, col(1) lmarg(4)
	.`atab'.width | 26 |
	.`atab'.sep, top
	.`atab'.titles    "Pooled covariance matrix"
	.`atab'.titles    ""
	.`atab' = ._tab.new, col(2) lmarg(4)
	.`atab'.width     | 8      | 17                |
	.`atab'.numfmt	    .        %10.0g
	.`atab'.pad         .        6
	.`atab'.titles      ""       "Natural log of "
	.`atab'.titles      "Rank"   "the determinant"
	.`atab'.sep, mid
	.`atab'.row `Srank' `Slndet'
	.`atab'.sep, bot

	return scalar lndet = `Slndet'
	return scalar rank = `Srank'
end

program ChkIfEMat
	foreach ename of local 0 {
		capture confirm matrix e(`ename')
		if c(rc) {
			di as err "matrix e(`ename') not found"
			exit 321
		}
	}
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
