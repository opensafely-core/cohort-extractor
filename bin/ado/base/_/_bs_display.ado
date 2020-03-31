*! version 1.3.1  28jun2017
program _bs_display
	version 9

	if "`e(prefix)'" != "bootstrap" {
		error 301
	}

	if "`e(cmd)'" != "bstat" {
		// eform options are allowed only with -bootstrap-
		local star "*"
	}

	syntax [,			///
		SEParate		/// -bstat- only option
		BCA			/// display opts
		BC			///
		NORmal			///
		Percentile		///
		ALL			///
		notable			///
		noHeader		///
		noLegend		///
		Verbose			///
		TItle(string)		///
		level(passthru)		/// for error message; dont change
		`star'			/// -eform- opts
	]

	if "`all'" != "" {
		if "`e(ci_bca)'" != "" {
			local bca bca
		}
		local bc bc
		local normal normal
		local percentile percentile
	}
	local citype `bca' `bc' `normal' `percentile'
	if `"`citype'"' == "" {
		local bc bc
	}

	if "`star'" != "" {
		// verify only valid -eform- option specified
		_check_eformopt `e(cmdname)', eformopts(`options')
		local efstring `"`s(str)'"'
		local eform = (`"`efstring'"' != "")
	}
	else	local eform 0

	// check options
	if `"`level'"' != "" {
		di as err ///
	"option level() may not be used when reporting bootstrap results"
		exit 198
	}
	else	local level `e(level)'

	// options for the footnote
	local footopts `bca' `bc' `normal' `percentile'

	// retrieve a local copy of the relevant matrices
	tempname n b_bs
	matrix `n' = e(reps)
	matrix `b_bs' = e(b_bs)
	if "`normal'" != "" {
		tempname normal
		matrix `normal' = e(ci_normal)
	}
	if "`bc'" != "" {
		tempname bc
		matrix `bc' = e(ci_bc)
	}
	if "`percentile'" != "" {
		tempname percentile
		matrix `percentile' = e(ci_percentile)
	}
	if "`bca'" != "" {
		if "`e(ci_bca)'" == "" {
			di as err "{p 0 0 2}option bca requires BCa" ///
			" confidence intervals to be saved by the" ///
			" bootstrap prefix command{p_end}"
			exit 198
		}
		tempname bca
		matrix `bca' = e(ci_bca)
	}

	Check4Scalars k_eq k_aux k_extra
	// check for total number of equations
	local k_eq 1
	Chk4PosInt k_eq
	// check for auxiliary parameters
	local k_aux 0
	Chk4PosInt k_aux
	// check for extra equations
	local k_extra 0
	Chk4PosInt k_extra
	local neq1 = `k_eq' - `k_aux' - `k_extra'
	local neq2 = `k_eq' - `k_extra'

	if `neq1' == 1 & `k_extra' == 0 {
		local first first
	}
	if `eform' {
		if `neq1' == 0 {
			local k_eform 0
		}
		else if "`e(cmdname)'" == "mlogit" {
			local k_eform `neq1'
		}
		else {
			if `"`e(k_eform)'"' != "" {
				capture confirm integer number `e(k_eform)'
				if !c(rc) {
					if 0 < `e(k_eform)' & ///
					`e(k_eform)' <= `neq1' {
						local k_eform `e(k_eform)'
					}
					else	local k_eform 0
				}
				else	local k_eform 1
			}
			else	local k_eform 1
		}
	}
	else	local k_eform 0
	if `k_eform' == 0 {
		local eform 0
	}

	// column names and equations
	local colna : colnames e(b)
	local coleq : coleq e(b), quote
	local coleq : list clean coleq
	if `"`:list uniq coleq'"' == "_" {
		local coleq
	}

	if "`e(bs_version)'" == "" {
		local version = cond("`e(version)'"=="","1","`e(version)'")
	}
	else	local version = e(bs_version)
	if "`header'" == "" {
		local C1 _col(1)
		local C2 _col(20)
		local c3 = 49
		local C3 _col(`c3')
		local C4 _col(67)
		local wfmt 10
		if `"`title'"' == "" {
			local title `"`e(title)'"'
		}
		local ltitle : length local title
		di
		if `ltitle' > `c3' | !missing(e(N_strata)) {
			di as txt `"{p}`title'{p_end}"'
		}
		else if `"`title'"' != "" {
			di as txt `"`title'"' _c
		}
		if !missing(e(N_strata)) {
			di as txt `C1' "Number of strata" `C2' "= " ///
			   as res %`wfmt'.0fc e(N_strata) _c
		}
		di as txt `C3' "Number of obs" `C4' "= " ///
		   as res %`wfmt'.0fc e(N)
		if "`e(clustvar)'" == "" & !missing(e(N_clust)) {
			di as txt `C3' "N. of clusters" `C4' "= " ///
			   as res %`wfmt'.0fc e(N_clust)
		}
		if !missing(e(N_reps)) {
			di as txt `C3' "Replications" `C4' "= " ///
			   as res %`wfmt'.0f e(N_reps)
		}
		if `version' >= 3 & "`legend'" == "" {
			_prefix_legend bootstrap, `verbose'
		}
	}

	// check to exit early
	if ("`table'" != "") {
		exit
	}
	else if "`header'" == "" {
		di
	}

	tempname Tab
	.`Tab' = ._tab.new, col(7) lmargin(0) ignore(.b)
	// column        1      2     3      4     5     6   7
	.`Tab'.width	13    |12    11     13    12    10   6
	.`Tab'.titlefmt  .   %12s  %11s   %13s    ""     .   .
	.`Tab'.strfmt    .      .     .      .     .     . %6s
	.`Tab'.pad	 .      2     2      2     2     1   .
	.`Tab'.numfmt    . %10.0g %9.0g %10.0g %9.0g %9.0g   .

	// table header
	if `eform' {
		local coef `"`efstring'"'
	}
	else	local coef "Coef."
	if inlist("`e(prefix)'","bootstrap","jackknife") {
		local msg1 "Replications based on"
		local msg2 "Replications based on"
	}
	else {
		local msg1 "Std. Err. adjusted for"
		local msg2 "Standard errors adjusted for"
	}
	if "`e(clustvar)'" != "" & !missing(e(N_clust)) {
		local nclust = string(e(N_clust), "%12.0fc")
		di as txt ///
"{ralign 78:(`msg1' {res:`nclust'} clusters in `e(clustvar)')}"
	}
	else if "`e(clustvar)'" != "" {
		di as txt ///
"{ralign 78:(`msg2' clustering on `e(clustvar)')}"
	}
	ColumnTitles `Tab' `level' `"`coef'"'

	// table body
	tempname b se
	local K : word count `colna'
	local eq
	local ieq 0
	if `"`coleq'"' != "" {
		// ignore -separate- option when there are equations
		local separate
	}
	forval k = 1/`K' {
		local name : word `k' of `colna'
		if `"`coleq'"' != "" {
			gettoken curreq coleq : coleq, qed(qed)
			if `qed' {
				local beq `"["`curreq'"]"'
			}
			else {
				local beq "[`curreq']"
			}
		}
		if `eform' & `"`name'"' == "_cons" {
			continue
		}
		local i = colnumb(`n',"`curreq':`name'")
		scalar `b' = `beq'_b[`name']
		scalar `se' = el(e(se),1,colnumb(e(se),`"`curreq':`name'"'))

		// Equation name and separator
		if "`eq'" != "`curreq'" {
			local ++ieq
			if `ieq' > `k_eform' {
				local eform 0
			}
			if `ieq' <= `neq1' | `neq2' < `ieq'{
				.`Tab'.sep
				if "`first'" == "" {
					local eq = abbrev("`curreq'",12)
					.`Tab'.strcolor result . . . . . .
					.`Tab'.strfmt   %-12s  . . . . . .
					.`Tab'.row      "`eq'" "" "" "" "" "" ""
					.`Tab'.strcolor text   . . . . . .
					.`Tab'.strfmt   %12s   . . . . . .
				}
			}
			else {
				if `ieq' == `neq1'+1 {
					.`Tab'.sep
				}
				if "`name'" != "_cons" {
					di as err "[_cons] not found"
					exit 111
				}
				local name /`curreq'
			}
			local eq `curreq'
		}
		else if `"`separate'"' != "" | `k' == 1 {
			.`Tab'.sep
		}

		// Print results
		local full `name' `n'[1,`i'] `b' `b_bs'[1,`i'] `se'
		if `"`normal'"' != "" {
			local ci `normal'[1,`i'] `normal'[2,`i']
			Row `Tab' `eform' `full' `ci' "(N)"
			local full
		}
		if `"`percentile'"' != "" {
			local ci `percentile'[1,`i'] `percentile'[2,`i']
			Row `Tab' `eform' `full' `ci' "(P)"
			local full
		}
		if `"`bc'"' != "" {
			local ci `bc'[1,`i'] `bc'[2,`i']
			Row `Tab' `eform' `full' `ci' "(BC)"
			local full
		}
		if `"`bca'"' != "" {
			local ci `bca'[1,`i'] `bca'[2,`i']
			Row `Tab' `eform' `full' `ci' "(BCa)"
		}
	}
	.`Tab'.sep, bottom

	// table footer
	Footer, `footopts'
	_prefix_footnote
end

program ColumnTitles
	args Tab level coef

	// display any constraints
	tempname cns
	capture mat `cns' = get(Cns)
	if !_rc {
		matrix dispCns
	}

	is_svysum `e(cmd)'
	if r(is_svysum) {
		if "`e(by)'" != "" {
			if `:word count `e(by)'' != 1 {
				local depvar "By"
			}
			else {
				local depvar = abbrev("`e(by)'",12)
			}
		}
		local coef = proper("`e(cmd)'")
	}
	else {
		if `:word count `e(depvar)'' == 1 {
			local depvar = abbrev(`"`e(depvar)'"', 12)
		}
	}
	local level = string(round(`level',.01))
	local obs Observed
	.`Tab'.sep, top
	// column        1       2  3              4  5  6  7
	.`Tab'.titles   "" "`obs'" "" `" Bootstrap"' "" "" ""
	.`Tab'.titles	"`depvar'"			/// 1
			"`coef'"			/// 2
			"Bias"				/// 3
			"Std. Err."			/// 4
			"  [`level'% Conf. Interval]"	/// 5
			"" ""				//  6 7
end

program Row
	if `:word count `0'' == 5 {
		args Tab eform ll ul comment
		local full 0
	}
	else {
		args Tab eform name reps b b_bs se ll ul comment
		tempname bias
		local full 1
	}

	if `eform' {
		local ll exp(`ll')
		local ul exp(`ul')
		if `full' {
			local b exp(`b')
			local se `b'*`se'
			scalar `bias' = exp(`b_bs')-`b'
		}
	}
	else if `full' {
		scalar `bias' = `b_bs'-`b'
	}
	if `full' {
		local name = abbrev(`"`name'"',12)
		.`Tab'.row "`name'" `b' `bias' `se' `ll' `ul' "`comment'"
	}
	else {
		.`Tab'.row "`name'" "" "" "" `ll' `ul' "`comment'"
	}
end

program Footer
	syntax [, NORmal percentile bc bca]
	if `"`e(ties)'"' == "ties" { 
		local ties_message " (adjusted for ties) "
	}	
	local ci " confidence interval"
	local c1 _col(0)
	local c2 _col(8)
	if `"`normal'"' != "" {
		local desc `c1' "(N)" `c2' "normal`ci'"
		local break _n
	}
	if `"`percentile'"' != "" {
		local desc `desc' `break' `c1' "(P)" ///
			`c2' "percentile`ci'"
		local break _n
	}
	if `"`bc'"' != "" {
		local desc `desc' `break' `c1' "(BC)" ///
			`c2' "bias-corrected`ci'" `"`ties_message'"'
		local break _n
	}
	if "`bca'" != "" {
		local desc `desc' `break' `c1' "(BCa)" ///
			`c2' "bias-corrected and accelerated`ci'" `"`ties_message'"'
	}
	di `desc'
end

program Check4Scalars
	syntax namelist
	local nonscalars `: r(macros)' `: r(matrices)'
	local badmac : list nonscalars & namelist
	if "`badmac'" != "" {
		gettoken name : badmac
		di as err "type mismatch: e(`name') is not a scalar"
		exit 109
	}
end

program Chk4PosInt
	args ename
	if `"`e(`ename')'"' != "" {
		capture confirm integer number `e(`ename')'
		if !c(rc) {
			if `e(`ename')' > 0 {
				c_local `ename' `e(`ename')'
			}
		}
	}
end

exit

NOTES:

Output ruler:
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
Logit estimates                                   Number of obs   =        100
                                                  LR chi2(1)      =       0.83
                                                  Prob > chi2     =     0.3610
Log likelihood = -5.1830091                       Pseudo R2       =     0.0745
        
------------------------------------------------------------------------------
           y |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
           x |  -3.712523   4.739402    -0.78   0.433    -13.00158    5.576535
       _cons |  -3.374606   1.441799    -2.34   0.019    -6.200481   -.5487309
------------------------------------------------------------------------------
        
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
Bootstrap results                                 Number of obs    =       100
                                                  Replications     =        50

------------------------------------------------------------------------------
Variable     |    Observed        Bias    Std. Err. [95% Conf. Interval]
-------------+----------------------------------------------------------------
       _bs_1 |    2.924468   -.0042756    .1243375   2.674602   3.174334   (N)
             |                                       2.677798   3.123902   (P)
             |                                       2.677798   3.246877  (BC)
             |                                       2.734447   3.246877 (BCa)
------------------------------------------------------------------------------
Note:  N   = normal
       P   = percentile
       BC  = bias-corrected
       BCa = bias-corrected and accelerated

<end>
