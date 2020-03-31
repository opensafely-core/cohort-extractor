*! version 3.10.1  21oct2019
program _svy_tabulate, sortpreserve
	version 9
	if replay() {
		if `"`e(cmd)':`e(prefix)'"' != "tabulate:svy" {
			error 301
		}
		Display `0'
		exit
	}
	capture noisily SvyTab `0'
	if c(rc) {
		ClearE
	}
	exit c(rc)
end

program ClearE, eclass
	ereturn clear
end

program SvyTab, eclass
	syntax varlist(min=1 max=2) [if] [in] [,	///
		TAB(varname numeric)			/// <tabulate_options>
		MISSing					///
		SUBpop(passthru)			/// <svy_options>
		VCE(string)				///
		OVER(passthru)				/// NOT ALLOWED
		dof(passthru)				///
		Level(passthru)				///
		noLABel					///
		*					/// Display options
	]
	// this subroutines checks the display options and creates the
	// appropriate local macros, including `options' which contains other
	// options not allowed with Display but possibly with -svy:-
	_get_diopts ignore
	_get_diopts diopts options, `options'
	local diopts : list diopts - ignore
	CheckSyntax, `options' `level' `label'
	if `dostdize' {
		// splits the -stdize()- option out of the 'options' macro and
		// generates a separate 'stdopts' macro
		ParseStdize, `options'
	}
	if `:list sizeof diopts' {
		local 0 `", `diopts'"'
		syntax [, NULLOPT]
	}
	if `:length local over' {
		local 0 `", `over'"'
		syntax [, NULLOPT]
	}

	if "`srssubpop'" != "" & `"`subpop'"' == "" {
		di as err "option {bf:srssubpop} requires option {bf:subpop()}"
		exit 198
	}

	// collect the display options in the following macros:
	// 	diitems		: <display_items>
	// 	diopts		: <display_options>
	// 	tabopts		: -tabdisp- options
	// 	statopts	: <stat_options>
	local diitems `cell' `count' `row' `column' `obs' ///
		`se' `cv' `ci' `deff' `deft'
	local diopts `proportion' `percent' `label' `marginals' ///
		`format' `vertical' `level'
	local tabopts `cellwidth' `csepwidth' `stubwidth' `notable'
	local statopts `pearson' `lr' `fuller' `null' `wald' `llwald' `adjust'

	// defaults for building labels for the matrix stripes
	if "`cellw'" == "" {
		local cellw 8
	}
	if "`stubw'" == "" {
		local stubw 8
	}

	if "`se'`cv'`ci'`deff'`deft'" != "" | `dostdize' {
		local setype `count'`row'`column'
	}

	// check/get svy settings
	tempvar touse subuse
	mark `touse' `if' `in'
	markout `touse' `stdize' `stdweight'
	_svy_setup `touse' `subuse',	///
		svy cmdname(tabulate) `subpop' `srssubpop'
	if "`missing'" == "" {
		tempvar vltouse
		mark `vltouse' if `touse'
		markout `vltouse' `varlist', strok
		quietly replace `touse' = 0 if `subuse' & !`vltouse'
		quietly replace `subuse' = 0 if !`touse'
	}
	else	local vltouse `touse'
	if "`r(poststrata)'" != "" & "`deff'`deft'" != "" {
		di as err ///
"options {bf:deff} and {bf:deft} are not allowed with poststratification"
		exit 198
	}
	if "`tab'" != "" & "`r(wtype)'" != "" {
		tempvar wvar
		if "`r(calmethod)'" != "" {
			quietly				///
			svycal `r(calmethod)'		///
				`r(calmodel)'		///
				[`r(wtype)'`r(wexp)']	///
				if `touse',		///
				`r(calopts)'		///
				generate(`wvar')
		}
		else if "`r(poststrata)'" != "" {
			svygen post `wvar'		///
				[`r(wtype)'`r(wexp)']	///
				if `touse',		///
				posts(`r(poststrata)')	///
				postw(`r(postweight)')
		}
		else {
			quietly gen double `wvar' `r(wexp)' if `touse'
		}
	}
	local vce2 `r(vce)'
	if `"`subpop'"' != "" {
		local srssub	`r(srssubpop)'
		local subopt	subpop(`subuse')
		local subpop	`"`r(subpop)'"'
		local subopt2	subpop(`subuse', `srssub')
		if "`r(strata1)'" != "" & `"`subpop'"' != "" {
			// update 'touse' to omit strata that contain no
			// subpopulation members
			tempname tv
			_svy2 `touse' if `touse',	///
				type(total)		///
				svy			///
				v(`tv')			///
				jknife			/// first stage only
				`subopt'		///
				touse(`touse')
			local N_omit = r(N_strata_omit)
			matrix drop `tv'
			if `N_omit' & "`vltouse'" != "`touse'" {
				quietly replace `vltouse' = 0 if !`touse'
			}
		}
	}

	// rebuild the vce() option for -_svy_summarize-
	if `"`vce'"' != "" {
		_svy_check_vce `vce'
		if `"`s(vce)'"' != "" {
			local vce `s(vce)'
			// this will only be used by replication VCE type
			local mse `s(mse)'
			local vceopt vce(`vce', `mse')
		}
	}
	else	local vce `vce2'

	gettoken v1 v2 : varlist
	foreach var in `v1' `v2' {
		if bsubstr("`:type `var''",1,3) == "str" {
			tempvar nvar
			encode `var', generate(`nvar')
			label var `nvar' "`var'"
		}
		else	local nvar `var'
		local nvlist `nvlist' `nvar'
	}
	local ori_list `varlist'
	local varlist `nvlist'

	quietly count if `touse'
	if r(N) == 0 {
		exit 2000
	}

	// identify the row and column vars individually
	local rowvar : word 1 of `varlist'
	local colvar : word 2 of `varlist'
	local rowvar_ori : word 1 of `ori_list'
	local colvar_ori : word 2 of `ori_list'
	if "`rowvar_ori'" == "`colvar_ori'" {
		di as err "row and column variable may not be the same"
		exit 198
	}
	if "`colvar'" == "" & `:word count `statopts'' {
		di as err ///
"option {bf:`:word 1 of `statopts''} is not allowed with one-way tables"
		exit 198
	}

	// tabulate results

	// matrices
	tempname Obs ObsSub b V cstub rstub b0 row col	///
		 Vrow Vcol X1 X2 D Da

	// scalars
	tempname s zero Xp Xlr Wl Wp tr tr2 tra tr2a		///
		 total N_pop

	tempvar cat

	if "`tab'" != "" {
		local mult "`tab'*"
		local vartype : type `tab'
		local type ratio
		Total `total' `tab' `touse' `subuse' "`wvar'" "`subpop'"
	}
	else {
		local vartype byte
		local type mean
	}

quietly {

	sort `vltouse' `varlist', stable
	by `vltouse' `varlist': gen byte `cat' = (_n == 1) if `vltouse'
	if `"`subpop'"' != "" {
		tabulate `varlist' if `touse', ///
			`missing' matcell(`ObsSub') subpop(`subuse')
	}
	if "`colvar'" != "" {
		local matcol matcol(`cstub')
	}
	else {
		matrix `cstub' = 1
		matrix colname `cstub' = "one"
	}
	tabulate `varlist' if `touse', ///
		`missing' matcell(`Obs') matrow(`rstub') `matcol'
	matrix `rstub' = `rstub''
	local nrow = r(r)
	local ncol = cond("`colvar'" == "", 1, r(c))
	CheckRowCol `nrow' `ncol' `row'`column'

	replace `cat' = sum(`cat') if `vltouse'
	local ncat = `cat'[_N]

	forval k = 1/`ncat' {
		tempvar x
		gen `vartype' `x' = `mult'(`cat'==`k') if `touse'
		// cell proportions
		if "`type'" == "ratio" {
			local vars `vars' (`x' `tab')
		}
		else	local vars `vars' `x' `tab'
		// totals
		local vt `vt' `x'
	}

	if inlist("`setype'","row","column") {
		if "`setype'" == "row" {
			local var `rowvar'
			local colo "*"
		}
		else {
			local var `colvar'
			local rowo "*"
		}
		tempvar catx
		sort `vltouse' `var', stable
		by `vltouse' `var': gen byte `catx' = (_n==1) if `vltouse'
		replace `catx' = sum(`catx') if `touse'
		local ncatx = `catx'[_N]
		forval i = 1/`ncatx' {
			tempvar x`i'
			gen `vartype' `x`i'' = `mult'(`catx'==`i') if `touse'
		}
		local i 1
		local j 1
		forval k = 1/`ncat' {
			tempvar x
			gen `vartype' `x' = `mult'(`cat'==`k') if `touse'
			while `Obs'[`i',`j'] == 0 {
				local j = mod(`j', `ncol') + 1
				local i = cond(`j'==1, `i'+1, `i')
			}
			`rowo' local vs "`vs' (`x' `x`i'')"
			`colo' local vs "`vs' (`x' `x`j'')"
			local j = mod(`j', `ncol') + 1
			local i = cond(`j'==1, `i'+1, `i')
		}
	}

} // quietly

	ValueLab `rowvar' `rstub' `stubw'
	local rowlab `r(label)'
	local rowttl `"`r(titles)'"'
	if "`colvar'" != "" {
		ValueLab `colvar' `cstub' `cellw'
		local collab `r(label)'
		local colttl `"`r(titles)'"'
	}

	// estimation for the cell proportions
	_prefix_note tabulate
	quietly svy, notable `subopt2' `vceopt' `options' `dof' ///
		: `type' `vars' if `touse', `stdopts'
	quietly replace `touse' = 0 if !e(sample)
	local vce	`"`e(vce)'"'
	local mse	`"`e(mse)'"'
	local vetype	`"`e(vcetype)'"'
	local brrweight	`"`e(brrweight)'"'
	local jkrweight	`"`e(jkrweight)'"'
	matrix `b' = e(b)
	matrix `V' = e(V)
	if "`setype'" != "count" {
		if "`e(V_srs)'" == "matrix" {
			tempname Vsrs
			if "`srssub'" == "" {
				matrix `Vsrs' = e(V_srs)
			}
			else	matrix `Vsrs' = e(V_srssub)
		}
		if "`e(V_srswr)'" == "matrix" {
			tempname Vsrswr
			if "`srssub'" == "" {
				matrix `Vsrswr' = e(V_srswr)
			}
			else	matrix `Vsrswr' = e(V_srssubwr)
		}
	}
	local N		= e(N)
	local N_strata	= e(N_strata)
	local N_psu	= e(N_psu)
	local dof	= e(df_r)
	scalar `N_pop'	= e(N_pop)
	if `"`subpop'"' != "" {
		tempname N_subpop
		local N_sub = e(N_sub)
		scalar `N_subpop' = e(N_subpop)
	}

	if "`tab'" == "" {
		if `"`subpop'"' == "" {
			scalar `total' = `N_pop'
		}
		else	scalar `total' = `N_subpop'
	}

	// computations for the totals
	if "`wald'" != "" | "`setype'" == "count" {
		if "`setype'" == "count" {
			local topt "`subopt2'"
		}
		else	local topt "`subopt'"
		if "`dots'" == "" & `"`vce'"' != "linearized" {
			di as txt _n "`e(vcetype)': for cell counts"
		}
		// 'stdopts' not allowed with -total-
		quietly svy, notable `topt' `vceopt' `options'	///
			: total `vt' if `touse'
		tempname Vt
		matrix `Vt' = e(V)
		if "`setype'" == "count" {
			if "`e(V_srs)'" == "matrix" {
				tempname Vsrs
				if "`srssub'" == "" {
					matrix `Vsrs' = e(V_srs)
				}
				else	matrix `Vsrs' = e(V_srssub)
			}
			if "`e(V_srswr)'" == "matrix" {
				tempname Vsrswr
				if "`srssub'" == "" {
					matrix `Vsrswr' = e(V_srswr)
				}
				else	matrix `Vsrswr' = e(V_srssubwr)
			}
			tempname bs
			matrix `bs' = e(b)
		}
	}

	// computations for the row or column proportions
	if inlist("`setype'", "row", "column") {
		if "`dots'" == "" & `"`vce'"' != "linearized" {
			di as txt _n "`e(vcetype)': for `setype's"
		}
		quietly svy, notable `subopt' `vceopt' `options'	///
			: ratio `vs' if `touse', `stdopts'
		tempname bs Vs
		matrix `bs' = e(b)
		matrix `Vs' = e(V)
		if "`e(V_srs)'" != "" {
			tempname Vs_srs
			if "`srssub'" == "" {
				matrix `Vs_srs' = e(V_srs)
			}
			else	matrix `Vs_srs' = e(V_srssub)
		}
		if "`e(V_srswr)'" == "matrix" {
			tempname Vs_srswr
			if "`srssub'" == "" {
				matrix `Vs_srswr' = e(V_srswr)
			}
			else	matrix `Vs_srswr' = e(V_srssubwr)
		}
	}

	// add zeroes for empty cells
	if `ncat' != `nrow'*`ncol' {
		AddZeros `Obs'	`b'		///
				`V'		///
				`Vsrs'		///
				`Vsrswr'	///
				`Vs_srs'	///
				`Vs_srswr'	///
				`Vt'		///
				`bs'		///
				`Vs'
	}

	// get marginal row and column sums
	Marginal `nrow' `ncol' `b' `row' `col'

	// variance estimates for margins
	if "`setype'" != "count" {
		VMargin `nrow' `ncol' `V' `Vrow' `Vcol'
	}
	else	VMargin `nrow' `ncol' `Vt' `Vrow' `Vcol'
	if "`Vs_srs'" != "" {
		tempname Vs_srsrow Vs_srscol
		VMargin `nrow' `ncol' `Vs_srs' `Vs_srsrow' `Vs_srscol'
	}
	if "`Vsrs'" != "" {
		tempname Vsrsrow Vsrscol
		VMargin `nrow' `ncol' `Vsrs' `Vsrsrow' `Vsrscol'
	}
	if "`Vs_srswr'" != "" {
		tempname Vs_srswrrow Vs_srswrcol
		VMargin `nrow' `ncol' `Vs_srswr' `Vs_srswrrow' `Vs_srswrcol'
	}
	if "`Vsrswr'" != "" {
		tempname Vsrswrrow Vsrswrcol
		VMargin `nrow' `ncol' `Vsrswr' `Vsrswrrow' `Vsrswrcol'
	}

	// expected values of proportions assuming independence:
	//	b0 = pi.*p.j
	Getb0 `row' `col' `b0'

	// `zero' = true if there is a zero in marginal totals
	// (sum of weights must be zero for this to occur)
	ChkZero `row' `col' `zero'

	// check for single row or column
	local one = (`nrow'==1 | `ncol'==1)

	if !`zero' & !`one' {

		// unadjusted statistics

		// Pearson statistic
		Pearson `N' `b' `b0' `Xp'

		// likelihood ratio statistic
		LikeRat `N' `b' `b0' `Xlr'

		// contrasts for test of independence
		IndCon `nrow' `ncol' `X1' `X2'

		// adjustment factors and Wald tests

		// design effects matrix D using b0
		DeffMat `N' `b0' `V' `X2' `D' `tr' `tr2'

		// design effects matrix D using b
		DeffMat `N' `b' `V' `X2' `Da' `tra' `tr2a'

		// Standard log-linear Wald test
		LLWald `b' `b' `V' `X2' `Wl'

		// Pearson Wald test
		if "`wald'" != "" {
			PearWald `b' `Vt' `total' `row' `col' `Wp'
		}
	}
	else	SetMiss `Xp' `Xlr' `tr' `tr2' `tra' `tr2a' `Wl' `Wp'

	// mean generalized deff and C.V. of eigenvalues
	local dfnom = (`nrow'-1)*(`ncol'-1)
	if "`Vsrs'`Vsrswr'" != "" {
		tempname mgdeff cvgdeff
		scalar `mgdeff' = `tr'/`dfnom'
		scalar `cvgdeff' = sqrt(`dfnom'*`tr2'/`tr'^2 - 1)
	}

	// saved results

	// e(b) and e(V)
	if "`setype'" == "" {
		// `bs' is destroyed by post we save a copy of `b'
		tempname bs
		matrix `bs' = `b'
		local Vs "`V'"
	}
	else if "`setype'" == "count" {
		local Vs  "`Vt'"
	}
	LabelMat `nrow' `ncol' `b' `bs' `Vs'
	if "`Vs_srs'" != "" {
		LabelMat `nrow' `ncol' `Vs_srs' `Vs_srswr'
	}
	if "`Vsrs'" != "" {
		LabelMat `nrow' `ncol' `Vsrs' `Vsrswr'
	}

	local xsca k_eq k_eform N_over
	local xmac cmd varlist namelist title cmdname command
	local xmat V_srs V_srswr V_srssub V_srssubwr ///
		deff deft deffsub deftsub error _N _N_subp
	_e2r, xsca(`xsca') xmac(`xmac')  xmat(`xmat')
	ereturn post `bs' `Vs', dof(`dof') obs(`N') esample(`touse')
	_r2e

	// adjust and save Pearson and LR statistics
	if !missing(`dfnom') & `dfnom' != 0 {
		MakeStat `dfnom' `tr'  `tr2'  `Xp'  Penl
		MakeStat `dfnom' `tra' `tr2a' `Xp'  Pear
		MakeStat `dfnom' `tr'  `tr2'  `Xlr' LRnl
		MakeStat `dfnom' `tra' `tr2a' `Xlr' LR
		MakeFull `dfnom' `tr'  `tr2'  `Xp'  Full

		// adjust and save Wald tests
		MakeWald `dfnom' `Wl' LLW
		if "`wald'" != "" {
			MakeWald `dfnom' `Wp' Wald
		}
	}

	ereturn scalar N        = `N'
	ereturn scalar N_strata = `N_strata'
	if "`N_omit'" != "" {
		ereturn scalar N_strata_omit = `N_omit'
	}
	ereturn scalar N_psu    = `N_psu'
	ereturn scalar N_pop    = `N_pop'
	if "`subpop'" != "" {
		ereturn scalar N_sub    = `N_sub'
		ereturn scalar N_subpop = `N_subpop'
	}
	ereturn local setype    = cond("`setype'" != "", "`setype'", "cell")
	ereturn local subpop	`"`subpop'"'
	ereturn local srssubpop	`"`srssub'"'
	ereturn local rowvar	`"`rowvar_ori'"'
	ereturn local rowvlab	`"`: variable label `rowvar_ori''"'
	if "`colvar'" != "" {
		ereturn local colvar    `"`colvar_ori'"'
		ereturn local colvlab   `"`: variable label `colvar_ori''"'
	}
	ereturn local rowlab    `rowlab'
	ereturn local collab    `collab'
	ereturn hidden local rowtitles `"`rowttl'"'
	ereturn hidden local coltitles `"`colttl'"'
	ereturn local tab       `"`tab'"'

	ereturn scalar r        = `nrow'
	ereturn scalar c        = `ncol'
	ereturn scalar total    = `total'
	if `zero' {
		ereturn local zero "zero marginal"
	}
	if "`mgdeff'" != "" {
		ereturn sca mgdeff = `mgdeff'	// mean deff eigenvalue
		ereturn sca cvgdeff = `cvgdeff'	// c.v. of deff eigenvalues
	}

	ereturn matrix Obs `Obs'		// cell # of observations
	if "`subpop'" != "" {
		ereturn matrix ObsSub `ObsSub'	// cell # of obs in subpop
	}
	// convert cell proportions to matrix
	VectoMat `b' e(r) e(c)
	ereturn matrix Prop `b'			// proportions

	ereturn matrix Row  `rstub'		// row stub
	ereturn matrix Col  `cstub'		// column stub
	ereturn matrix V_row `Vrow'		// variance of row margins
	ereturn matrix V_col `Vcol'		// variance of column margins

	if "`Vs_srs'" != "" {
		MakeDeff `Vs_srs'		// e(Deff) and e(Deft)
		MakeDeff `Vsrsrow' _row		// e(Deff_row) and e(Deft_row)
		MakeDeff `Vsrscol' _col		// e(Deff_col) and e(Deft_col)
	}
	else if "`Vsrs'" != "" {
		MakeDeff `Vsrs'			// e(Deff) and e(Deft)
		MakeDeff `Vsrsrow' _row		// e(Deff_row) and e(Deft_row)
		MakeDeff `Vsrscol' _col		// e(Deff_col) and e(Deft_col)
	}
	if "`Vs_srswr'" != "" {
		ereturn matrix V_srswr `Vs_srswr'
		ereturn matrix V_srswr_row `Vs_srswrrow'
		ereturn matrix V_srswr_col `Vs_srswrcol'
	}
	else if "`Vsrswr'" != "" {
		ereturn matrix V_srswr `Vsrswr'
		ereturn matrix V_srswr_row `Vsrswrrow'
		ereturn matrix V_srswr_col `Vsrswrcol'
	}

	ereturn local estat_cmd	svy_estat
	ereturn hidden local predict	_no_predict
	ereturn local marginsnotok _ALL
	ereturn local cmdname	"tabulate"
	ereturn local prefix	"svy"
	ereturn local cmd	"tabulate"

	// display results
	Display, `diitems' `diopts' `tabopts' `statopts'
end

program ValueLab, rclass
	args var stub maxwidth
	local dim = colsof(`stub')

	local lab : value label `var'
	if "`lab'" == "" {
		exit
	}

	forval i = 1/`dim' {
		local x = `stub'[1,`i']
		local xlab : label `lab' `x'
		local xlab : subinstr local xlab "`" "'", all
		if `"`xlab'"'==`"`x'"' | `x' == . {
			local list `"`list' __no__label__"'
			local LIST `"`LIST' __no__label__"'
		}
		else {
			local xlab = trim(usubstr(`"`xlab'"',1,`maxwidth'))
			local LIST `"`LIST' `"`xlab'"'"'
			// change periods to commas and colons to semicolons
			if index(`"`xlab'"',".") {
				local xlab : subinstr local xlab "." ",", all
			}
			if index(`"`xlab'"',":") {
				local xlab : subinstr local xlab ":" ";", all
			}
			local list `"`list' `"`xlab'"'"'
		}
	}

	version 11: matrix colnames `stub' = `list'
	return local label label
	return local titles `"`:list retok LIST'"'
end

program SetMiss
	local i 1
	while "``i''"!="" {
		scalar ``i'' = .
		local i = `i' + 1
	}
end

program Total
	args total y touse subvar wvar subpop

quietly {

	if "`wvar'" != "" {
		tempvar x
		gen double `x' = `wvar'*`y'
	}
	else	local x "`y'"
	if "`subpop'" == "" {
		summarize `x' if `touse', meanonly
	}
	else	summarize `x' if `touse' & `subvar', meanonly
	scalar `total' = r(sum)

} // quietly

end

program AddZeros
	gettoken cell rest : 0
	local nrow = rowsof(`cell')
	local ncol = colsof(`cell')
	local k 1
	local i 1
	forval i = 1/`nrow' {
		forval j = 1/`ncol' {
			if `cell'[`i',`j'] == 0 {
				foreach mat of local rest {
					PutZero `mat' `k'
				}
			}
			local k = `k' + 1
			local j = `j' + 1
		}
	}
end

program PutZero
	args A i

	tempname B Z

	if `i' <= colsof(`A') {
		matrix `B' = `A'[.,`i'...]
		local matAB "mat `A' = `A' , `B'"
	}

	local dim = rowsof(`A')
	matrix `Z' = J(`dim',1,0)
	local i1 = `i' - 1

	if `i1' >= 1 {
		matrix `A' = `A'[.,1..`i1']
		matrix `A' = `A' , `Z'
	}
	else	matrix `A' = `Z'

	`matAB'

	if `dim' == 1 {
		exit
	}

	if `i' <= `dim' {
		matrix `B' = `A'[`i'...,.]
		local matAB "mat `A' = `A' \ `B'"
	}

	local dim = `dim' + 1
	matrix `Z' = J(1,`dim',0)

	if `i1' >= 1 {
		matrix `A' = `A'[1..`i1',.]
		matrix `A' = `A' \ `Z'
	}
	else	matrix `A' = `Z'

	`matAB'
end

program Marginal
	args nrow ncol b row col
	tempname A B
	matrix `A' = I(`nrow')
	matrix `B' = J(1,`ncol',1)
	matrix `A' = `A' # `B'
	matrix `row' = `b'*`A''
	matrix `A' = J(1,`nrow',1)
	matrix `B' = I(`ncol')
	matrix `A' = `A' # `B'
	matrix `col' = `b'*`A''
end

program VMargin
	args nrow ncol V Vrow Vcol
	tempname A B
	matrix `A' = I(`nrow')
	matrix `B' = J(1,`ncol',1)
	matrix `A' = `A' # `B'
	matrix `Vrow' = `V'*`A''
	matrix `Vrow' = `A'*`Vrow'
	Sym `Vrow'
	matrix `A' = J(1,`nrow',1)
	matrix `B' = I(`ncol')
	matrix `A' = `A' # `B'
	matrix `Vcol' = `V'*`A''
	matrix `Vcol' = `A'*`Vcol'
end

program Getb0
	args row col b0
	tempname A B
	// expected cell proportions
	matrix `A' = `row''*`col'
	// Convert into a row vector
	matrix `b0' = `A'[1,1...]
	local nrow = colsof(`row')
	local i 2
	while `i' <= `nrow' {
		matrix `B' = `A'[`i',1...]
		matrix `b0' = `b0' , `B'
		local i = `i' + 1
	}
end

program ChkZero
	args row col zero

	scalar `zero' = 0
	local nrow = colsof(`row')
	local i 1
	while `i' <= `nrow' {
		scalar `zero' = `zero' | (`row'[1,`i']==0)
		local i = `i' + 1
	}
	local ncol = colsof(`col')
	local i 1
	while `i' <= `ncol' {
		scalar `zero' = `zero' | (`col'[1,`i']==0)
		local i = `i' + 1
	}
end

program IndCon
	args r c X1 X2

	tempname A X J

	local r1 = `r' - 1
	local c1 = `c' - 1

// Build first `r'-1 columns: dummies for main effects of first variable.

	matrix `A' = I(`r1')
	matrix `J' = J(1,`r1',-1)
	matrix `A' = `A' \ `J'
	matrix `J' = J(`c',1,1)
	matrix `X1' = `A' # `J'

// Build next `c'-1 columns: dummies for main effects of second variable.

	matrix `A' = I(`c1')
	matrix `J' = J(1,`c1',-1)
	matrix `A' = `A' \ `J'
	matrix `J' = J(`r',1,1)
	matrix `X' = `J' # `A'
	matrix `X1' = `X1' , `X'

// Build last (`r'-1)*(`c'-1) columns: interaction terms.

	matrix `X2' = I(`r1')
	matrix `X2' = `X2' # `A'
	matrix `J'  = J(1,`r1',-1)
	matrix `A'  = `J' # `A'
	matrix `X2' = `X2' \ `A'
end

program LabelMat
	gettoken nrow rest : 0
	gettoken ncol rest : rest
	forval i = 1/`nrow' {
		forval j = 1/`ncol' {
			local names "`names' p`i'`j'"
		}
	}
	local i 0
	foreach mat of local rest {
		local ++i
		matrix colnames `mat' = `names'
		if rowsof(`mat') > 1 | `i'==3 {
			matrix rownames `mat' = `names'
		}
	}
end

program MakeStat, eclass
	args dfnom tr tr2 stat name

	ereturn scalar cun_`name' = `stat'

	if missing(e(df_r)) & inlist(e(vce), "bootstrap", "sdr") {
		exit
	}

	ereturn scalar F_`name'   = `stat'/`tr'
	ereturn scalar df1_`name' = `tr'^2/`tr2'
	ereturn scalar df2_`name' = (`tr'^2/`tr2')*e(df_r)
	ereturn scalar p_`name'   = fprob(e(df1_`name'),e(df2_`name'),e(F_`name'))
end

program MakeFull, eclass // Fuller et al. variant
	args dfnom tr tr2 stat name

	local h historical(16)
	ereturn `h' scalar cun_`name' = `stat'

	if missing(e(df_r)) & inlist(e(vce), "bootstrap", "sdr") {
		exit
	}

	tempname tr3
	scalar `tr3' = `tr2' - `tr'^2/e(df_r)
	if `tr3' < 0 {
		scalar `tr3' = .
	}

	ereturn `h' scalar F_`name'   = `stat'/`tr'
	ereturn `h' scalar df1_`name' = min(`tr'^2/`tr3',`dfnom')
	ereturn `h' scalar df2_`name' = e(df_r)
	ereturn `h' scalar p_`name'   = fprob(e(df1_`name'),e(df2_`name'),e(F_`name'))
end

program MakeWald, eclass
	args df1 chi name

	ereturn scalar cun_`name' = `chi'        // unadjusted

	if missing(e(df_r)) & inlist(e(vce), "bootstrap", "sdr") {
		exit
	}

	local dfv = e(df_r)

	ereturn scalar F_`name' = (`dfv'-`df1'+1)*`chi'/(`df1'*`dfv')
	if e(F_`name') < 0 {
		ereturn scalar F_`name' = .
	}

	ereturn scalar p_`name' = fprob(`df1',`dfv'-`df1'+1,e(F_`name'))

	ereturn scalar Fun_`name' = `chi'/`df1'
	ereturn scalar pun_`name' = fprob(`df1',`dfv',`chi'/`df1')
end

program Pearson
	args n b b0 X

	tempname A B
	matrix `A' = diag(`b0')
	matrix `A' = syminv(`A')
	matrix `B' = `b' - `b0'
	matrix `A' = `A'*`B''
	matrix `A' = `B'*`A'
	scalar `X' = `n'*`A'[1,1]
end

program LikeRat
	args n b b0 X

	local dim = colsof(`b')
	scalar `X' = 0
	local i 1
	while `i' <= `dim' {
		scalar `X' = `X' + `b'[1,`i']*log(`b'[1,`i']/`b0'[1,`i'])
		local i = `i' + 1
	}

	scalar `X' = 2*`n'*`X'
end

program LLWald
	args b b0 V C X

	if e(singleton) & e(singleunit) == "missing" {
		scalar `X' = .
		exit
	}

	tempname A B G logbi
	local dim = colsof(`b')
	matrix `G' = J(`dim',1,0)
	local i 1
	while `i' <= `dim' {
		scalar `logbi' = log(`b'[1,`i'])
		if `logbi'>=. {
			scalar `X' = .
			exit
		}
		matrix `G'[`i',1] = `logbi'
		local i = `i' + 1
	}

	matrix `G' = `C''*`G'
	matrix `B' = diag(`b0')
	matrix `B' = syminv(`B')
	matrix `A' = `V'*`B'
	matrix `A' = `B'*`A'
	matrix `A' = `A'*`C'
	matrix `A' = `C''*`A'
	SymInv `A'
	matrix `A' = `A'*`G'
	matrix `A' = `G''*`A'

	scalar `X' = `A'[1,1]
end

program PearWald
	args b V total row col X

	if e(singleton) & e(singleunit) == "missing" {
		scalar `X' = .
		exit
	}
	tempname A B W b0ij

	local nrow = colsof(`row')
	local ncol = colsof(`col')
	local dfnom = (`nrow'-1)*(`ncol'-1)
	local dim = `nrow'*`ncol'

	matrix `A' = J(`dfnom',`dim',0)
	matrix `B' = J(1,`dfnom',0)

	local k 1
	local i 1
	while `i' < `nrow' {
		local j 1
		while `j' < `ncol' {
			local l = `ncol'*(`i'-1) + `j'
			scalar `b0ij' = `row'[1,`i']*`col'[1,`j']
			matrix `B'[1,`k'] = `b'[1,`l'] - `b0ij'
			local m 1
			local g 1
			while `g' <= `nrow' {
				local h 1
				while `h' <= `ncol' {

		if `g'==`i' | `h'==`j' {
			if `g'==`i' & `h'!=`j' {
				matrix `A'[`k',`m'] = -`col'[1,`j'] + `b0ij'
			}
			else if `g'!=`i' & `h'==`j' {
				matrix `A'[`k',`m'] = -`row'[1,`i'] + `b0ij'
			}
			else {
				matrix `A'[`k',`m'] = ///
				1 - `row'[1,`i'] - `col'[1,`j'] + `b0ij'
			}
		}
		else	matrix `A'[`k',`m'] = `b0ij'

					local m = `m' + 1
					local h = `h' + 1
				}
				local g = `g' + 1
			}
			local k = `k' + 1
			local j = `j' + 1
		}
		local i = `i' + 1
	}

	matrix `W' = `V'*`A''
	matrix `W' = `A'*`W'
	SymInv `W'
	matrix `W' = `W'*`B''
	matrix `W' = `B'*`W'

	scalar `X' = `total'^2*`W'[1,1]
end

program DeffMat
	args n b V C D tr tr2

	if e(singleton) & e(singleunit) == "missing" {
		scalar `tr' = .
		scalar `tr2' = .
		exit
	}

	tempname B
	matrix `B' = diag(`b')
	matrix `B' = syminv(`B')
	matrix `D' = `V'*`B'
	matrix `D' = `B'*`D'
	matrix `D' = `D'*`C'
	matrix `D' = `C''*`D'
	matrix `B' = `B'*`C'
	matrix `B' = `C''*`B'
	SymInv `B'
	matrix `D' = `B'*`D'
	matrix `D' = `n'*`D'

	scalar `tr' = trace(`D')
	matrix `B' = `D'*`D'
	scalar `tr2' = trace(`B')
end

program Sym
	args X // matrix in, replaced with exactly symmetric matrix
	matrix `X' = 0.5*(`X'' + `X')
	*tempname Y
	*mat `Y' = `X''
	*mat `Y' = `Y' + `X' * labels picked from right
	*mat `X' = 0.5*`Y'
end

program SymInv
	args X // matrix in, replaced with inverse
	Sym `X'
	matrix `X' = syminv(`X')
end

program ParseStdize
	syntax [,	STDize(varname)			///
			STDWeight(varname numeric)	///
			*				///
	]
	c_local options `"`options'"'
	c_local stdopts	stdize(`stdize') stdweight(`stdweight')
end

program CheckSyntax
	syntax [name(name=caller)] [, * ]
	if "`name'" == "" {
		local star				///
			noDOTS				///
			NOIsily				///
			TRace				///
			STDize(varname)			///
			STDWeight(varname numeric)	///
			*				 // end
	}
	syntax [name(name=caller)] [,			///
		CELl					/// <display_items>
		COUnt					///
		ROW					///
		COLumn					///
		OBS					///
		SE					///
		CI					///
		DEFF					///
		DEFT					///
		CV					///
		SRSsubpop				///
		PROPortion				/// <display_options>
		PERcent					///
		noLABel					///
		noMARGinals				///
		FORmat(string)				///
		VERTical				///
		Level(cilevel)				///
		CELLWidth(integer 0)			/// -tabdisp- options
		CSEPwidth(integer 0)			///
		STUBWidth(integer 0)			///
		NOTABle					///
		PEArson					/// <stat_options>
		LR					///
		FULLER					/// not documented
		NULl					///
		WALD					///
		LLWALD					///
		noADJust				/// <svy_options>
		`star'					///
	]

	if "`name'" == "" {
		c_local dostdize = "`stdize'" != ""
		c_local stdize `"`stdize'"'
		c_local stdweight `"`stdweight'"'
	}
	else	c_local dostdize = "`e(stdize)'" != ""

	// check for syntax errors
	if "`null'" != "" & "`pearson'`lr'" == "" & "`wald'`llwald'" != "" {
		di as err "option {bf:null} modifies options {bf:pearson} and {bf:lr} only"
		exit 198
	}
	if "`unadjust'" != "" {
		local adjust "noadjust"
	}
	if "`adjust'" != "" & "`wald'`llwald'" == "" {
		di as err ///
		"option {bf:noadjust} modifies options {bf:wald} and {bf:llwald} only"
		exit 198
	}
	if "`format'" != "" {
		quietly di `format' 0
	}
	if "`cell'`count'`row'`column'" == "" {
		local cell cell
	}
	if "`se'`cv'`ci'`deff'`deft'" != "" {
		local nopts : word count `cell' `count' `row' `column'
		if `nopts' > 1 {
			local opt : word 1 of `se' `cv' `ci' `deff' `deft'
			di as err ///
"{p}only one of options {bf:cell}, {bf:count}, {bf:row}, or {bf:column} "	///
"can be specified when option {bf:`opt'} is specified{p_end}"
			exit 198
		}
	}
	if "`stdize'" != "" & "`count'`wald'" != "" {
		local opt : word 1 of `count' `wald'
		di as err ///
"option {bf:`opt'} is not allowed with direct standardization"
		exit 198
	}
	if "`percent'" != "" & "`proportion'" != "" {
		opts_exclusive "percent proportion"
	}
	if "`notable'" != "" {
		local noopts : word 1 of ///
			`proportion' `percent' `vertical' `marginals' `label'
		if "`noopts'" != "" {
			opts_exclusive "notable `noopts'"
		}
		if "`format'" != "" {
			opts_exclusive "notable format()"
		}
		if "`cellwidth'" != "0" {
			opts_exclusive "notable cellwidth()"
		}
		if "`csepwidth'" != "0" {
			opts_exclusive "notable csepwidth()"
		}
		if "`stubwidth'" != "0" {
			opts_exclusive "notable subwidth()"
		}
	}

	if `cellwidth' < 4 {
		local cellwidth
	}
	else {
		local cellw `cellwidth'
		local cellwidth cellwidth(`cellwidth')
	}
	if `csepwidth' <= 0 {
		local csepwidth
	}
	else	local csepwidth csepwidth(`csepwidth')
	if `stubwidth' < 4 {
		local stubwidth
	}
	else if `stubwidth' > 32 {
		local stubwidth 32
	}
	if "`stubwidth'" != "" {
		local stubw `stubwidth'
		local stubwidth stubwidth(`stubwidth')
	}
	if "`cellwidth'" == "" {
		local cellw
	}
	if "`stubwidth'" == "" {
		local stubw
	}
	if "`notable'" != "" {
		local cellwidth
		local cellw
		local csepwidth
		local stubwidth
		local stubw
	}

	if "`caller'" == "DispTab" {
		if "`e(poststrata)'" != "" & "`deff'`deft'" != "" {
			di as err ///
"options {bf:deff} and {bf:deft} are not allowed with poststratification"
			exit 198
		}

		if `"`e(stdize)'"' != "" {
			if "`deff'`deft'" != "" {
				di as err ///
"options {bf:deff} and {bf:deft} are not allowed with direct standardization"
				exit 198
			}
			if "`count'" != "" {
				di as err ///
"option {bf:count} is not allowed with direct standardization"
				exit 198
			}
		}

		if "`wald'" != "" & "`e(F_Wald)'" == "" {
			if "`e(df_r)'" != "" {
				di as err "{p 0 0 2}"		///
"option {bf:wald} not available on redisplay; it must be specified at run time{p_end}"
				exit 198
			}
		}

		if "`srssubpop'" != "" & `"`e(subpop)'"' == "" {
			di as err ///
"option {bf:srssubpop} requires subpopulation estimation results"
			exit 198
		}

		if "`se'`cv'`ci'`deff'`deft'" != ""		///
		 & "`e(setype)'" != "`cell'`count'`row'`column'" {
			if "`se'" != "" {
				di as err "standard errors are only available for `e(setype)'s"
				di as err "{p 4 4 2}"		///
"To compute `cell'`count'`row'`column' standard errors, "	///
"rerun command with options {bf:`cell'`count'`row'`column'} and {bf:se}.{p_end}"
				exit 111
			}
			if "`cv'" != "" {
				di as err "coefficients of variation are only available for `e(setype)'s"
				di as err "{p 4 4 2}"		///
"To compute `cell'`count'`row'`column' coefficients of variation, "	///
"rerun command with options {bf:`cell'`count'`row'`column'} and {bf:cv}.{p_end}"
				exit 111
			}
			if "`ci'" != "" {
				di as err "confidence intervals are only available for `e(setype)'s"
				di as err "{p 4 4 2}"		///
"To compute `cell'`count'`row'`column' confidence intervals, "	///
"rerun command with options {bf:`cell'`count'`row'`column'} and {bf:ci}.{p_end}"
				exit 111
			}

			local deff : word 1 of `deff' `deft'

			di as err strupper("`deff'") " is only available for `e(setype)'s"
			di as err "{p 4 4 2}"			///
"To compute `cell'`count'`row'`column' " strupper("`deff', ")	///
"rerun command with options {bf:`cell'`count'`row'`column'} and {bf:`deff'}.{p_end}"
			exit 111
		}

		local statopts `pearson' `lr' `fuller'	///
			`null' `wald' `llwald' `adjust'
		if "`e(colvar)'" == "" & `:word count `statopts'' {
			di as err ///
"option {bf:`:word 1 of `statopts''} is not allowed with one-way tables"
			exit 198
		}
	}
	else {
		if `:word count `stdize' `stdweight'' == 1 {
			if "`stdweight'" == "" {
				di as err ///
				"option {bf:stdize()} requires option {bf:stdweight()}"
			}
			if "`stdize'" == "" {
				di as err ///
				"option {bf:stdweight()} requires option {bf:stdize()}"
			}
			exit 198
		}
		if "`stdize'" != "" {
			local options ///
			`"`options' stdize(`stdize') stdweight(`stdweight')"'
		}

		if `"`stdize'"' != "" & "`count'" != "" {
			di as err ///
"option {bf:count} is not allowed with direct standardization"
			exit 198
		}

		if `"`stdize'"' != "" & "`deff'`deft'" != "" {
			di as err ///
"options {bf:deff} and {bf:deft} are not allowed with direct standardization"
			exit 198
		}

		local ncell : word count `obs' `se' `cv' `deff' `deft'
		if "`ci'" != "" & "`vertical'" != "" & `ncell' > 2 {
			di as err "{p 0 0 2}"		///
"only 2 of options {bf:se}, {bf:cv}, {bf:deff}, {bf:deft}, and {bf:obs} can be specified"	///
" when options {bf:ci} and {bf:vertical} are specified{p_end}"
			exit 198
		}
		if "`ci'" != "" {
			local ncell = `ncell' + 1
		}
		if "`vertical'" == "" & `ncell' > 4 {
			di as err ///
"only 4 of options {bf:se}, {bf:cv}, {bf:ci}, {bf:deff}, {bf:deft}, and {bf:obs} can be specified"
			exit 198
		}
		local format "format(`format')"
		if `"`noisily'`trace'"' != "" {
			local dots nodots
		}
		local options `"`options' `noisily' `trace' `dots'"' 
		c_local dots	`"`dots'"'
		c_local options	`"`:list retok options'"'
		local level level(`level')
	}
	local nopts : word count `cell'`count'`proportion'`percent' ///
		`se' `cv' `ci' `deff' `deft' `vertical'
	if `nopts' >= 5 {
		di as err "{p 0 0 2}" ///
		"too many {it:display_items} options specified;" ///
		`" see help {help "svy_tabulate##|_new":svy: tabulate}{p_end}"'
		exit 198
	}

	c_local cell		`cell'
	c_local count		`count'
	c_local row		`row'
	c_local column		`column'
	c_local obs		`obs'
	c_local se		`se'
	c_local cv		`cv'
	c_local ci		`ci'
	c_local deff		`deff'
	c_local deft		`deft'
	c_local srssubpop	`srssubpop'
	c_local proportion	`proportion'
	c_local percent		`percent'
	c_local label		`label'
	c_local marginals	`marginals'
	c_local format		`format'
	c_local vertical	`vertical'
	c_local level		`level'
	c_local cellwidth	`cellwidth'
	c_local cellw		`cellw'
	c_local csepwidth	`csepwidth'
	c_local stubwidth	`stubwidth'
	c_local stubw		`stubw'
	c_local notable		`notable'
	c_local pearson		`pearson'
	c_local lr		`lr'
	c_local fuller		`fuller'
	c_local null		`null'
	c_local wald		`wald'
	c_local llwald		`llwald'
	c_local adjust		`adjust'
end

program VectoMat	// converts `A' from vector to matrix
	args A nrow ncol
	tempname row New
	matrix `New' = `A'[1,1..`ncol']
	local i = `ncol' + 1
	while `i' <= `nrow'*`ncol' {
		local end = `i' + `ncol' - 1
		matrix `row' = `A'[1,`i'..`end']
		matrix `New' = `New' \ `row'
		local i = `end' + 1
	}
	matrix `A' = `New'
end

program MakeDeff, eclass
	args Vsrs name

	tempname v f deff deft
	matrix `v' = vecdiag(e(V`name'))

	matrix `deff' = `v'
	matrix `deft' = `v'

	if "`e(fpc1)'" != "" {
		tempname c
		if "`e(srssubpop)'" == "" {
			scalar `c' = 1 - e(N)/e(N_pop)
		}
		else	scalar `c' = 1 - e(N_sub)/e(N_subpop)
	}
	else	local c 1

	local dim  = colsof(`v')
	local i 1
	while `i' <= `dim' {
		scalar `f' = `v'[1,`i']/`Vsrs'[`i',`i']
		matrix `deff'[1,`i'] = cond(`f'<., `f', 0)

		scalar `f' = sqrt(`c'*`f')
		matrix `deft'[1,`i'] = cond(`f'<., `f', 0)

		local i = `i' + 1
	}

	ereturn matrix Deff`name' `deff'
	ereturn matrix Deft`name' `deft'
	ereturn matrix V_srs`name' `Vsrs'
end

// subroutines for reporting the results

program Display
	// display the table
	DispTab `0'
	// local macros created by DispTab:
	// 	pearson	
	// 	lr
	// 	fuller
	// 	null
	// 	wald
	// 	llwald
	// 	adjust
	// 	deff
	// 	deft
	// 	se
	// 	cv
	// 	ci

	// display error and warning messages
	local showtest 1
	if "`e(zero)'" != "" {
		di _n as txt ///
		"  Table contains a zero in the marginals." _n ///
		"  Statistics cannot be computed."
		local showtest 0
	}
	if e(r) == 1 {
		di _n as txt ///
		"  Only one row category." _n ///
		"  Statistics cannot be computed."
		local showtest 0
	}
	else if e(c) == 1 {
		if "`e(colvar)'" != "" {
			di _n as txt ///
			"  Only one column category." _n ///
			"  Statistics cannot be computed."
		}
		local showtest 0
	}
	if e(df_r) < (e(r) - 1)*(e(c) - 1) {
		di as txt "{p 0 6 2}" ///
		"Note: Variance estimate degrees of freedom = " ///
		as res e(df_r) as txt ///
		" are less than nominal table degrees of freedom = " ///
		as res (e(r) - 1)*(e(c) - 1) "{p_end}"
	}

	if "`pearson'`lr'`fuller'`wald'`llwald'" == "" {
		local pearson "pearson"
	}
	else	local showtest 1

	// display statistics
	if `showtest' {
		if "`pearson'" != "" {
			if "`null'" != "" {
				DispStat "Pearson:" Pear Penl
			}
			else	DispStat "Pearson:" Pear
		}
		if "`lr'" != "" {
			if "`null'" != "" {
				DispStat "Likelihood ratio:" LR LRnl
			}
			else	DispStat "Likelihood ratio:" LR
		}
		if "`fuller'" != "" {
			DispStat "Pearson (Fuller version):" Full
		}
		if "`wald'" != "" {
			DispWald "Wald (Pearson):" Wald `adjust'
		}
		if "`llwald'" != "" {
			DispWald "Wald (log-linear):" LLW `adjust'
		}
	}

	// display mean generalized deff and cv
	if "`deff'`deft'" != "" & e(r) != 1 & e(c) != 1 {
		di _n as txt ///
		"  Mean generalized deff" _col(35) "= " ///
		as res %9.4f e(mgdeff) _n ///
		as txt "  CV of generalized deffs" _col(35) "= " ///
		as res %9.4f e(cvgdeff)
	}
	local di di
	if `showtest' & e(singleton) {
		di
		local di
		if (e(singleunit) == "missing") {
			di as txt "{p 0 6 2}" ///
			"Note: Missing test statistics because of" ///
			" stratum with single sampling unit.{p_end}"
		}
		else if "`se'`cv'`ci'" == "" {
			_svy_singleton_note
		}
	}
	if "`se'`cv'`ci'" != "" & (e(singleton) | e(N_strata_omit)) {
		`di'
		_prefix_footnote
	}
	else if e(N_strata_omit) {
		`di'
		_svy_subpop_note
	}
end

program CheckRowCol
	args nrow ncol rowcol
	if (`nrow' == 1 | `ncol' == 1) & "`rowcol'" != "" {
		if `ncol' == 1 & bsubstr("`rowcol'",1,3) == "row" {
			di as err ///
	"option {bf:row} is not allowed for tables with a single column"
			exit 198
		}
		if `nrow' == 1 & bsubstr("`rowcol'",-6,.)  == "column" {
			di as err ///
	"option {bf:column} is not allowed for tables with a single row"
			exit 198
		}
	}
end

program DispTab
	CheckSyntax DispTab `0'
	c_local pearson		`pearson'
	c_local lr		`lr'
	c_local fuller		`fuller'
	c_local null		`null'
	c_local wald		`wald'
	c_local llwald		`llwald'
	c_local adjust		`adjust'
	c_local deff		`deff'
	c_local deft		`deft'
	c_local se		`se'
	c_local cv		`cv'
	c_local ci		`ci'

	if "`notable'" != "" {
		exit
	}
	CheckRowCol `e(r)' `e(c)' `row' `column'

	// check for one or two-way table logic
	if e(r) != 1 & e(c) == 1 {
		local rowvar `e(rowvar)'
		tempvar colvar
		local varlist `e(rowvar)'
	}
	else if e(r) == 1 & e(c) != 1 {
		tempvar rowvar
		local colvar `e(colvar)'
		local varlist `e(colvar)'
	}
	else {
		local rowvar `e(rowvar)'
		local colvar `e(colvar)'
		if "`colvar'" == "" {
			tempvar colvar
		}
		local varlist `e(rowvar)' `e(colvar)'
		if e(r) == 1 {	// both are 1
			local marginals nomarginals
		}
	}
	if e(r) == 1 | e(c) == 1 {
		local oneway 1
	}
	else	local oneway 0

	if "`format'" == "" {
		local format "%6.0g"
	}

	if `oneway' {
		local vertical vertical
	}

	// preserve, then make dataset for -tabdisp-
	preserve
	drop _all

	tempname b matr matc Row Col

	local ncat = e(r)*e(c)
	local iii "int((_n-1)/e(c))+1"		// row position
	local jjj "mod(_n-1,e(c))+1"		// column position

	matrix `b' = e(Prop)
	local bij "`b'[`iii',`jjj']"

	matrix `matr' = J(1,e(c),1)*`b''	// row marginals
	matrix `matc' = J(1,e(r),1)*`b'		// column marginals
	local denr : copy local matr
	local denc : copy local matc
	local EXP "!= 0"

	if "`e(stdize)'" != "" & "`row'`column'" != "" {
		// the standardized estimates were already computed
		tempname eb
		matrix `eb' = e(b)
		forval i = 1/`e(r)' {
			forval j = 1/`e(c)' {
				matrix `b'[`i',`j'] = `eb'[1,(`i'-1)*e(c)+`j']
			}
		}
		// recompute the marginals
		if "`column'" != "" {
			tempname denc
			matrix `denc' = J(1,e(c),1)
			matrix `matc' = J(1,e(r),1)*`b'
		}
		if "`row'" != "" {
			tempname denr
			matrix `denr' = J(1,e(r),1)
			matrix `matr' = J(1,e(c),1)*`b''
		}
		local EXP
	}

	matrix `Row' = e(Row)
	matrix `Col' = e(Col)

	local zero = `"`e(zero)'"' != ""

quietly {

	// set obs
	if "`marginals'" == "" {
		if e(c) != 1 {
			local Nr1 = `ncat'+1	// start row marginals
			local Nr2 = `ncat'+e(r)	// end row marginals
		}
		else {
			local Nr1 = 0
			local Nr2 = `ncat'
		}
		if e(r) != 1 {
			local Nc1 = `Nr2'+1	// start column marginals
			local Nc2 = `Nr2'+e(c)	// end column marginals
		}
		else {
			local Nc1 = 0
			local Nc2 = `Nr2'
		}
		local N   = `Nc2'+1		// end

		local total "total dotz"
	}
	else {
		local Nr1 = 1
		local Nr2 = `ncat'
		local Nc1 = 1
		local Nc2 = `ncat'
		local N `ncat'
	}
	set obs `N'

	// make stubs of table
	gen double `rowvar' = .z
	gen double `colvar' = .z
	replace `rowvar' = `Row'[1,`iii'] in 1/`ncat'
	replace `colvar' = `Col'[1,`jjj'] in 1/`ncat'

	if "`marginals'" == "" {
		if `Nr1' {
			replace `rowvar' = `Row'[1,_n-`Nr1'+1] in `Nr1'/`Nr2'
		}
		if `Nc1' {
			replace `colvar' = `Col'[1,_n-`Nc1'+1] in `Nc1'/`Nc2'
		}
	}

	// make variable labels and value labels for stub variables
	if "`label'" == "" {
		label variable `rowvar' `"`e(rowvlab)'"'
		label variable `colvar' `"`e(colvlab)'"'

		if "`e(rowlab)'" != "" { 
			tempname lblname
			MakeLab `lblname' `rowvar' `Row' : `"`e(rowtitles)'"'
		}
		if "`e(collab)'" != "" {
			tempname lblname
			MakeLab `lblname' `colvar' `Col' : `"`e(coltitles)'"'
		}
	}

	// handle display of missing values if necessary
	if `Nr1' {
		tempname lblname
		SwitchMiss `lblname' `rowvar' `ncat' `Nr1' `Nr2' `Row'
	}
	if `Nc1' {
		tempname lblname
		SwitchMiss `lblname' `colvar' `ncat' `Nc1' `Nc2' `Col'
	}

	// make counts and proportions or percents
	local keyi 0

	if "`count'" != "" {
		GetNewVar xc count
		gen double `xc' = e(total)*`bij' in 1/`ncat'

		if "`marginals'" == "" {
			if `Nr1' {
				replace `xc' = ///
				e(total)*`matr'[1,_n-`Nr1'+1] in `Nr1'/`Nr2'
			}
			if `Nc1' {
				replace `xc' = ///
				e(total)*`matc'[1,_n-`Nc1'+1] in `Nc1'/`Nc2'
			}
			replace `xc' = e(total) in l
		}

		local ++keyi
		if "`e(wtype)'" != "" {
			local key`keyi' "weighted count"
		}
		else	local key`keyi' "count"
	}

	// percent or proportion
	if "`percent'" != "" {
		local porp 100
		local kporp "percentage"
	}
	else {
		local porp 1
		local kporp "proportion"
	}

	if "`cell'" != "" {
		GetNewVar xp `kporp'
		gen double `xp' = `porp'*`bij' in 1/`ncat'

		if "`marginals'" == "" {
			if `Nr1' {
				replace `xp' = ///
				`porp'*`matr'[1,_n-`Nr1'+1] in `Nr1'/`Nr2'
			}
			if `Nc1' {
				replace `xp' = ///
				`porp'*`matc'[1,_n-`Nc1'+1] in `Nc1'/`Nc2'
			}
			replace `xp' = `porp' in l
		}
		local ++keyi
		local key`keyi' "cell `kporp'"
	}
	if "`row'" != "" {
		GetNewVar xrow row
		gen double `xrow' = `porp'*`bij'/`denr'[1,`iii'] in 1/`ncat'
		if `zero' {
			replace `xrow' = 0 if `matr'[1,`iii'] == 0 in 1/`ncat'
		}

		if "`marginals'" == "" {
			if `Nr1' {
				replace `xrow' = ///
					`porp'*(`matr'[1,_n-`Nr1'+1]`EXP') ///
					in `Nr1'/`Nr2'
			}
			if `Nc1' {
				replace `xrow' = ///
				`porp'*`matc'[1,_n-`Nc1'+1] in `Nc1'/`Nc2'
			}
			replace `xrow' = `porp' in l
		}
		local ++keyi
		local key`keyi' "row `kporp'"
	}
	if "`column'" != "" {
		GetNewVar xcol column
		gen double `xcol' = `porp'*`bij'/`denc'[1,`jjj'] in 1/`ncat'
		if `zero' {
			replace `xcol' = 0 if `matc'[1,`jjj'] == 0 in 1/`ncat'
		}

		if "`marginals'" == "" {
			if `Nr1' {
				replace `xcol' = ///
				`porp'*`matr'[1,_n-`Nr1'+1] in `Nr1'/`Nr2'
			}
			if `Nc1' {
				replace `xcol' = ///
					`porp'*(`matc'[1,_n-`Nc1'+1]`EXP') ///
					in `Nc1'/`Nc2'
			}
			replace `xcol' = `porp' in l
		}
		local ++keyi
		local key`keyi' "column `kporp'"
	}

	// From here to `obs', only one of count, cell, row, or column is
	// chosen.

	local item "`key`keyi''"

	if "`count'" != "" {
		local porp 1
	}

	if e(singleton) & e(singleunit) == "missing" {
		local se
		local cv
		local ci
	}

	if "`se'`cv'`ci'" != "" {
		GetNewVar xse se
		tempname V
		matrix `V' = e(V)
		gen double `xse' = `porp'*sqrt(`V'[_n,_n]) in 1/`ncat'

		if "`marginals'" == "" & `Nc1' & `Nr1' {
			if "`row'" == "" {
				matrix `V' = e(V_row)
				replace `xse' = ///
				`porp'*sqrt(`V'[_n-`Nr1'+1,_n-`Nr1'+1]) ///
					in `Nr1'/`Nr2'
			}
			if "`column'" == "" {
				matrix `V' = e(V_col)
				replace `xse' = ///
				`porp'*sqrt(`V'[_n-`Nc1'+1,_n-`Nc1'+1]) ///
					in `Nc1'/`Nc2'
			}
		}

		if "`se'" != "" {
			local ++keyi
			if "`vertical'" == "" {
				local key`keyi' ///
				"(`e(vce)' standard error of `item')"
			}
			else {
				local key`keyi' ///
				"`e(vce)' standard error of `item'"
			}
		}
	}
	if "`cv'" != "" {
		GetNewVar xcv cv
		if "`count'" == "" {
			local x "`xp'`xrow'`xcol'"
		}
		else {
			local x : copy local xc
		}
		gen double `xcv' = 100*`xse'/`x'
		local ++keyi
		local key`keyi' "coefficients of variation of `item'"
	}
	if "`ci'" != "" {
		tempname t
		GetNewVar lb lb
		GetNewVar ub ub
		if missing(e(df_r)) & inlist(e(vce), "bootstrap", "sdr") {
			scalar `t' = invnormal((100+`level')/200)
		}
		else	scalar `t' = invttail(e(df_r),(1-`level'/100)/2)

		if "`count'" == "" {
			local x "`xp'`xrow'`xcol'"
			if `porp' == 100 {
				local x "(`x'/100)"
			}

			gen double `lb' = `porp'/(1 +		///
				exp(-(log(`x'/(1-`x'))		///
				- `t'*`xse'/(`porp'*`x'*(1-`x')))))

			gen double `ub' = `porp'/(1 +		///
				exp(-(log(`x'/(1-`x'))		///
				+ `t'*`xse'/(`porp'*`x'*(1-`x')))))
		}
		else {
			gen double `lb' = `xc' - `t'*`xse'
			gen double `ub' = `xc' + `t'*`xse'
		}

		local xci "`lb' `ub'"

		local ++keyi
		if "`vertical'" == "" {
			local key`keyi' ///
`"[`=strsubdp("`level'")'% confidence interval for `item']"'
		}
		else {
			local key`keyi' ///
`"lower `=strsubdp("`level'")'% confidence bound for `item'"'
			local ++keyi
			local key`keyi' ///
`"upper `=strsubdp("`level'")'% confidence bound for `item'"'
		}
	}
	if "`se'" == "" {
		local xse /* erase tempvar */
	}

	if "`vertical'" == "" & "`se'`ci'" != "" {
		if "`se'" != "" {
			tempvar xxse
			gen str1 `xxse' = "" in 1
		}
		else	local nose "*"
		if "`ci'" != "" {
			tempvar xci
			gen str1 `xci' = "" in 1
		}
		else	local noci "*"

		forval i = 1/`N' {
			`nose'	local ses : di `format' `xse'[`i']
			`nose'	replace `xxse' = "("+trim("`ses'")+")"	///
			`nose'		in `i' if `xse'<.
			`noci'	local slb : di `format' `lb'[`i']
			`noci'	local sub : di `format' `ub'[`i']
			`noci'	replace `xci' = "["+trim("`slb'")	///
			`noci'		+","+trim("`sub'")+"]" in `i'	///
			`noci'		if `lb'<. & `ub'<.
		}

		`nose' drop `xse'
		`nose' rename `xxse' `xse'
	}
	if "`deff'" != "" {
		GetNewVar xdeff deff
		DeffVar `xdeff' f `Nr1' `Nr2' `Nc1' `Nc2' ///
			"`marginals'" "`row'" "`column'"
		local ++keyi
		local key`keyi' "deff for variance of `item'"
	}
	if "`deft'" != "" {
		GetNewVar xdeft deft
		DeffVar `xdeft' t `Nr1' `Nr2' `Nc1' `Nc2' ///
			"`marginals'" "`row'" "`column'"
		local ++keyi
		local key`keyi' "deft for variance of `item'"
	}
	if "`obs'" != "" {
		tempname Obs
		GetNewVar xobs obs
		if "`e(ObsSub)'" ~= "" {
			matrix `Obs' = e(ObsSub)
		}
		else	matrix `Obs' = e(Obs)
		gen long `xobs' = `Obs'[`iii',`jjj'] in 1/`ncat'
		if "`marginals'" == "" {
			tempname J
			if `Nr1' {
				matrix `J' = J(1,e(c),1)
				matrix `J' = `J'*`Obs''
				replace `xobs' = `J'[1,_n-`Nr1'+1] ///
					in `Nr1'/`Nr2'
			}
			if `Nc1' {
				matrix `J' = J(1,e(r),1)
				matrix `J' = `J'*`Obs'
				replace `xobs' = `J'[1,_n-`Nc1'+1] ///
					in `Nc1'/`Nc2'
			}
			if "`e(N_sub)'" ~= "" {
				replace `xobs' = e(N_sub) in l
			}
			else replace `xobs' = e(N) in l
		}
		local ++keyi
		local key`keyi' "number of observations"
	}

} // quietly

	local vars `xc' `xp' `xrow' `xcol' `xse' `xcv' `xci' `xdeff' `xdeft' `xobs'

	if `:word count `vars'' > 6 {
		di as err "{p 0 0 2}" ///
		"too many {it:display_items} options specified;" ///
		`" see help {help "svy_tabulate##|_new":svy: tabulate}{p_end}"'
		exit 198
	}

	// Display results

	// display the header
	_coef_table_header

	// table of results
	// NOTE: using `e(colvar)' on purpose

	tabdisp `varlist',				///
		cell(`vars') `total' format(`format')	///
		`cellwidth' `csepwidth' `stubwidth'

	// identify tabulated variable
	if "`e(tab)'" != "" {
		di as txt "  Tabulated variable:  `e(tab)'"
	}

	// key for two-way tables
	if "`e(tab)'" != "" {
		di
	}
	if !`oneway' {
		di as txt "  Key:  " _c
		local col 1
		forval i = 1/`keyi' {
			di _col(`col') as res "`key`i''"
			local col 9
		}
	}
	else {
		if "`cellw'" == "" {
			local cellw = max(length("`:word 1 of `vars''"),8)
		}
		di as txt "  Key:  " _c
		local col 1
		forval i = 1/`keyi' {
			local var : word `i' of `vars'
			di _col(`col') as txt %-`cellw's ///
				abbrev("`var'",`cellw') "  =  " ///
				as res "`key`i''"
			local col 9
		}
	}
end

program GetNewVar
	args macro name
	capture confirm new var `name'
	if c(rc) {
		local i 0
		while c(rc) {
			capture confirm new var `name'`++i'
		}
	}
	c_local `macro' `name'`i'
end

program DeffVar
	args var ft Nr1 Nr2 Nc1 Nc2 marginals row column

	local ncat = e(r)*e(c)
	tempname def
	matrix `def' = e(Def`ft')

quietly {

	gen double `var' = cond(`def'[1,_n]!=0,`def'[1,_n],.) ///
		in 1/`ncat'
	if "`marginals'" == "" & `Nr1' & `Nc1' {
		if "`row'" == "" {
			matrix `def' = e(Def`ft'_row)
			replace `var' = ///
				cond(`def'[1,_n-`Nr1'+1]!=0, ///
				`def'[1,_n-`Nr1'+1],.) in `Nr1'/`Nr2'
		}
		if "`column'" == "" {
			matrix `def' = e(Def`ft'_col)
			replace `var' = ///
				cond(`def'[1,_n-`Nc1'+1]!=0, ///
				`def'[1,_n-`Nc1'+1],.) in `Nc1'/`Nc2'
		}
	}

}

end

program SwitchMiss
	args lblname var N N1 N2 mat

	local lab : value label `var'
	if "`lab'" == "" {
		local lab `lblname'
	}
	else	local add ", add"

	// Note that a key assumption here is that after encountering the
	// first missing value, the rest of the columns of `mat' (moving to
	// the right) contain missing values.  Otherwise the `newid' may
	// collide with non-missing valued labels.

	local newid 0
	local ncols = colsof(`mat')
	forval i = 1/`ncols' {
		if missing(`mat'[1,`i']) {
			local miss = `mat'[1,`i']
			local ++newid
			if `miss' == . {
				label define `lab' `newid' "`miss'" `add'
				qui replace `var' = `newid'		///
					if `var' == `miss'		///
					& (_n<=`N'|(`N1'<=_n&_n<=`N2'))
	
				local add ", add"
			}
		}
		else	local newid = `mat'[1,`i']
	}
	if "`lab'" == "`lblname'" {
		label value `var' `lab'
	}
end

program FixMiss
	args lblname var missval N N1 N2
	local missval = round((`missval')+1,1)

	local lab : value label `var'
	if "`lab'" == "" {
		local lab `lblname'
		label define `lab' `missval' "."
		label value `var' `lab'
	}
	else	label define `lab' `missval' "." , add

	qui replace `var' = `missval'		///
		if missing(`var') & (_n<=`N'|(`N1'<=_n&_n<=`N2'))
end

program MakeLab
	args labname var stub COLON list

	tempname imat
	local dim = colsof(matrix(`stub'))
	local i 1
	while `i' <= `dim' {
		matrix `imat' = `stub'[1,`i'..`i']
		gettoken lab list : list
		if `"`lab'"' != "__no__label__" {
			local x = `stub'[1,`i']
			label define `labname' `x' `"`lab'"', `add'
			local add "add"
		}
		local i = `i' + 1
	}
	if `"`add'"' != "" {
		label value `var' `labname'
	}
end

program DispStat
	args title stat null

	local col0  5	// left margin
	local col1 19	// statistic
	local col2 35	// equal sign
	local col3 51	// p-value

	local dfnom = (e(r)-1)*(e(c)-1)

	di _n as txt "  `title'"

	di as txt _col(`col0') "Uncorrected" _col(`col1')	///
		"chi2(" as res `dfnom' as txt ")" _col(`col2')	///
		"= " as res %9.4f e(cun_`stat')

	if "`null'" != "" {
		local df1n "e(df1_`null')"
		local df2n "e(df2_`null')"

	    if !missing(`df2n') | !inlist(e(vce), "bootstrap", "sdr") {

		if `df1n' != int(`df1n') {
			local df1n "%4.2f `df1n'"
		}
		if `df2n' != int(`df2n') {
			local df2n "%4.2f `df2n'"
		}

		di as txt _col(`col0') "D-B (null)" _col(`col1') ///
			"F(" as res `df1n' as txt ", "		///
			as res `df2n' as txt ")"		///
			_col(`col2') "= "			///
			as res %9.4f e(F_`null') _col(`col3')	///
			as txt "P = " as res %6.4f e(p_`null')
	    }
	}

	local df1 "e(df1_`stat')"
	local df2 "e(df2_`stat')"

	if missing(`df2') & inlist(e(vce), "bootstrap", "sdr") {
		exit
	}

	if `df1' != int(`df1') {
		local df1 "%4.2f `df1'"
	}
	if `df2' != int(`df2') {
		local df2 "%4.2f `df2'"
	}

	di as txt _col(`col0') "Design-based" _col(`col1')	///
		"F(" as res `df1' as txt ", "			///
		as res `df2' as txt ")" _col(`col2') "= "	///
		as res %9.4f e(F_`stat') _col(`col3')		///
		as txt "P = " as res %6.4f e(p_`stat')
end

program DispWald
	args title stat unadj

	local col0  5	// left margin
	local col1 19	// statistic
	local col2 35	// equal sign
	local col3 51	// p-value

	di _n as txt "  `title'"

	local df1 = (e(r) - 1)*(e(c) - 1)

	di as txt _col(`col0') "Unadjusted" _col(`col1')	///
		"chi2(" as res `df1' as txt ")" _col(`col2')	///
		"= " as res %9.4f e(cun_`stat')

	if missing(e(df_r)) & inlist(e(vce), "bootstrap", "sdr") {
		exit
	}

	if "`unadj'" != "" {
		di as txt _col(`col0') "Unadjusted"		///
			_col(`col1') "F(" as res `df1'		///
			as txt ", " as res e(df_r) as txt ")"	///
			_col(`col2') "= "			///
			as res %9.4f e(Fun_`stat')		///
			_col(`col3') as txt "P = "		///
			as res %6.4f e(pun_`stat')
	}

	di as txt _col(`col0') "Adjusted"			///
		_col(`col1') "F(" as res `df1' as txt ", "	///
		as res e(df_r)-`df1'+1 as txt ")"		///
		_col(`col2') "= "				///
		as res %9.4f e(F_`stat') _col(`col3')		///
		as txt "P = " as res %6.4f e(p_`stat')
end

exit

(1) Non-Wald statistics:

    Pear = Pearson with observed misspecified variance
    Penl = Pearson with null misspecified variance
    LR   = LR      with observed
    LRnl = LR      with null

    all these yield

	cun_Pear   uncorrected (i.e., misspecified) chi2
	F_Pear     F-statistic: F = chi2/df1
	df1_Pear   df1 = tr^2/tr2
	df2_Pear   df2 = df1*(#psu - #strata)
	p_Pear     p-value for above F-statistic ~ F(df1,df2)

(2) Fuller variant:

    Full = Pearson with null misspecified variance using Fuller et al.'s
    formula.

	F_Full     F = chi2/df1 ~ F(df1,df2)
	df1_Full   df1 = <complex formula>
	df2_Full   df2 = #psu - #strata
	p_Full     p-value for above F-statistic ~ F(df1,df2)

(3) Wald statistics:

    Wald = "Pearson" Wald
    LLW  = log-linear Wald

    both of these produce (with W or T in place of W below):

	F_Wald     adjusted F = (dfv-df1+1)*chi2/(df1*dfv)
	df1_Wald   (# rows - 1)*(# columns - 1)
	df2_Wald   df2 = dfv - df1 + 1, where dfv = #psu - #strata
	p_Wald     p-value for adjusted F-statistic ~ F(df1,df2)

	cun_Wald   unadjusted chi2
	Fun_Wald   unadjusted F = chi2/df1
	pun_Wald   p-value for unadjusted F-statistic ~ F(df1,dfv)

<end of file>
