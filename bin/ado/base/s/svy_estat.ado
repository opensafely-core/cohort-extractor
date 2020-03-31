*! version 1.9.0  17may2018
program svy_estat
	version 9
	local vv : di "version " string(_caller()) ":"

	gettoken sub 0 : 0, parse(" ,")
	local lsub : length local sub

	if "`e(cmd)'" == "" {
		error 301
	}

	if inlist(`"`sub'"', "", ",") {
		di as err "subcommand expected"
		exit 198
	}

	if `"`sub'"' == "DisplayTable" {
		DisplayTable `0'
		exit
	}
	if `"`sub'"' == "vce" {
		estat_default vce `0'
		exit
	}
	if `"`sub'"' == "svyset" {
		RequiresSVY
		syntax
		svyset, eclass
		exit
	}
	if `"`sub'"' == "strata" {
		RequiresSVY
		Strata `0'
		exit
	}
	if "`e(cmd)'" == "gsem" | "`e(cmd2)'" == "gsem" {
		if `"`sub'"' == bsubstr("lcprob",1,max(4,`lsub')) { 
			gsem_estat lcprob `0'
			exit 
		}
		if `"`sub'"' == "lcmean" {
			gsem_estat lcmean `0'
			exit 
		}
		if `"`sub'"' == "eform" {
			gsem_estat eform `0'
			exit 
		}
	}
	if "`e(cmd)'" == "eregress" | "`e(cmd)'" == "eprobit" | ///
		"`e(cmd)'" == "eoprobit" | "`e(cmd)'" == "eintreg" {
		if `"`sub'"' == "teffects" {
			_erm_teffects `0'
			exit
		}
	}
	if `"`sub'"' == "sd" {
		if "`e(cmd)'" == "gsem" | "`e(cmd2)'" == "gsem" | ///
		  "`e(cmd)'" == "meglm" | "`e(cmd2)'" == "meglm" {
			gsem_estat sd `0'
			exit 
		}
		NoTab sd
		if `"`e(cmd)'"' != "mean" {
			di as err "mean estimation results not found"
			exit 301
		}
		CheckPost sd
		mean_estat_sd `0'
		exit
	}
	if `"`sub'"' == "size" {
		RequiresSVY
		NoTab size
		Size `0'
		exit
	}
	if `"`sub'"' == bsubstr("effects",1,max(3,`lsub')) {
		RequiresSVY
		NoTab effects
		CheckPost effects
		`vv' Effects `0'
		exit
	}
	if `"`sub'"' == bsubstr("lceffects",1,max(5,`lsub')) {
		RequiresSVY
		NoTab lceffects
		CheckPost lceffects
		`vv' LCEffects `0'
		exit
	}
	if `"`sub'"' == "cv" {
		RequiresSVY
		NoTab cv
		CoefVar `0'
		exit
	}
	if inlist(`"`e(cmd)'"', "logit", "probit", "logistic") {
		if `"`sub'"' == "gof" {
       if "`e(subpop)'"!= ""{
                di as err  ///
                "estat gof is not allowed after subpopulation estimations"
                exit 198
	}
			_svy_gof_hl `0'
			exit
		}
	}
	if inlist(`"`e(cmd)'"', "sem") {
		sem_estat `sub' `0' 
		exit
	}
	if `"`sub'"' == bsubstr("report",1,max(3,`lsub')) {
		if `"`e(cmd2)'"'=="irt" {
			irt_estat `sub' `0'
			exit
		}
	}	
	if `"`sub'"' == "icc" {
		if "`e(iccok)'" == "ok" {
			meglm_estat icc `0'
			exit
		}
	}
	
	di as err "invalid subcommand `sub'"
	exit 321
end

program NoTab
	args sub
	if `"`e(cmd)'"' == "tabulate" {
		di as err ///
"estat `sub' is not allowed after svy: tabulate"
		exit 198
	}
end

program RequiresSVY
	if `"`e(prefix)'"' != "svy" {
		di as err "svy estimation results not found"
		exit 301
	}
end

program CoefVar, rclass
	version 11
	syntax [,			///
		noLegend		///
		VERBose			///
		*			/// display options
	]

	_get_diopts diopts, `options'

	tempname b se cv
	matrix `b' = e(b)
	if "`e(V)'" != "matrix" {
		matrix `se' = (.)*`b''*`b'
	}
	else	matrix `se' = e(V)
	mata: svy_estat_CoefVar("`b'", "`se'", "`cv'")
	local colopts c(`cv' "CV (%)")

	DisplayTable cv, `colopts' `legend' `verbose' `diopts'
	local width = s(width)
	_svy_singleton_note, linesize(`width')
	// saved results
	matrix colna `b' = `:colna e(b)'
	matrix colna `se' = `:colna e(b)'
	matrix colna `cv' = `:colna e(b)'
	return matrix b		`b'
	return matrix se	`se'
	return matrix cv	`cv'
end

program Strata, rclass
	syntax

	if "`e(mse)'" == "mse" {
		di as err ///
"estat strata is not allowed with the MSE estimator of variance"
		exit 322
	}
	if "`e(vce)'" == "brr" {
		di as err "estat strata is not allowed after svy brr "
		exit 322
	}

	tempname nstr nsin ncer Tab
	matrix `nstr' = e(_N_strata)
	matrix `nsin' = e(_N_strata_single)
	matrix `ncer' = e(_N_strata_certain)
	local stages = colsof(`nstr')

	local nstri `nstr'[1,\`i']
	local nsini `nsin'[1,\`i']
	local nceri `ncer'[1,\`i']

	if "`e(singleunit)'" == "scaled" {
		local width	11    12
		local numfmt	 . %6.3g
		local pad	 .     6
		local titlefmt	 .  %12s
		local t1	"Scale"
		local t2	"factor"
		tempname scale vsca 
		matrix `vsca' = J(1,`stages',.)
		local vscai `vsca'[1,\`i']
	}
	else {
		local width	  11 0
		local numfmt	   . .
		local pad	   1 .
		local titlefmt	%11s .
		local t1	`""""'
		local t2	`""""'
		local vscai	`""""'
	}

	.`Tab' = ._tab.new, col(5) lmargin(0) ignore(.b)
	// column         1      2     3               //  4      5
	.`Tab'.width      7|    11    11    `width'    // 11     12
	.`Tab'.numfmt %5.0f      .     .    `numfmt'   //  .  %6.3g
	.`Tab'.pad        1      .     .    `pad'      //  .      6
	.`Tab'.titlefmt   .      .     .    `titlefmt' //  .   %12s

	di
	.`Tab'.sep, top
	.`Tab'.titles      "" "Singleton" "Certainty"  "Total" `t1' 
	.`Tab'.titles "Stage"    "strata"    "strata" "strata" `t2'
	.`Tab'.sep
	forval i = 1/`stages' {
		if "`scale'" != "" {
			scalar `scale' = `nstri' - `nceri'
			if `scale' != 0 {
				scalar `scale' = `scale'/(`scale' - `nsini')
			}
			matrix `vscai' = `scale'
		}
		.`Tab'.row `i'	///
			`nsini'	///
			`nceri'	///
			`nstri'	///
			`vscai'
	}
	.`Tab'.sep, bottom
	local width = "`.`Tab'.width_of_table'"
	_svy_subpop_note, linesize(`width')
	_svy_singleton_note, linesize(`width')

	return matrix _N_strata	 `nstr'
	return matrix _N_strata_single	 `nsin'
	return matrix _N_strata_certain `ncer'
	if "`scale'" != "" {
		return matrix scale	 `vsca'
	}
end

program Size, rclass
	is_svysum `e(cmd)'
	if !r(is_svysum) {
		if `"`e(cmd)'"' != "" {
			di as err ///
"estimation results from svy:`e(cmd)' are not supported by estat size"
			exit 301
		}
		else {
			error 301
		}
	}
	syntax [,			///
		OBS			///
		SIZE			///
		noHeader		///
		noLegend		///
		Verbose			///
	]
	local diopts `obs' `size'
	local ndiopts : word count `diopts'
	if `ndiopts' == 0 {
		local obs obs
		local size size
	}
	tempname Obs Size
	matrix `Obs' = e(_N)
	matrix `Size' = e(_N_subp)
	if "`obs'" != "" {
		local colopts `colopts' c(`Obs' "Obs")
	}
	if "`size'" != "" {
		local colopts `colopts' c(`Size' "Size")
	}
	DisplayTable size, `colopts' `legend' `verbose' size
	local lsize = s(width)
	_svy_fpc_note "" `lsize'
	_svy_singleton_note, linesize(`lsize')
	return matrix _N_subp 	= `Size'
	return matrix _N	= `Obs'
end

program Effects, rclass
	version 9
	local vv : di "version " string(_caller()) ":"
	syntax [,			///
		lceffects		///
		noLegend		///
		Verbose			/// undocumented
		*			/// effects options
	]

	// NOTE: the -verbose- option is not documented because it only has an
	// effect on output when used with -svy:brr- or -svy:jackknife-

	if "`lceffects'" == "" {
		_svy_mkdeff
	}

	_get_diopts diopts options, `options'
	EffectsOpts, `options'
	local deff `s(deff)'
	local deft `s(deft)'
	local meff `s(meff)'
	local meft `s(meft)'
	local sub  `s(sub)'
	local colopts	// start empty
	local matlist deft`sub' deff`sub'

	tempname Deff`sub' Deft`sub' Meff Meft
	matrix `Deff`sub'' = e(deff`sub')
	matrix `Deft`sub'' = e(deft`sub')
	if "`lceffects'" == "" & "`meff'`meft'" != "" & `"`e(V_msp)'"' == "" {
		`vv' _svy_mkvmsp
	}
	if `"`e(meft)'"' == "matrix" {
		local matlist `matlist' meft meff
		matrix `Meft' = e(meft)
		matrix `Meff' = hadamard(`Meft',`Meft')
	}
	else {
		matrix `Meft' = .
		matrix `Meff' = .
	}
	if "`deff'" != "" {
		local colopts `colopts' c(`Deff`sub'' "DEFF")
	}
	if "`deft'" != "" {
		local colopts `colopts' c(`Deft`sub'' "DEFT")
	}
	if "`meff'`meft'" != "" {
		if "`meff'" != "" {
			local colopts `colopts' c(`Meff' "MEFF")
		}
		if "`meft'" != "" {
			local colopts `colopts' c(`Meft' "MEFT")
		}
	}
	if `:length local lceffects' {
		local caller lceffects
	}
	else	local caller effects
	DisplayTable `caller', `colopts' `legend' `verbose' `diopts'
	local lsize = s(width)
	_svy_fpc_note "`deff'" `lsize'
	_svy_singleton_note, linesize(`lsize')
	tempname x
	foreach mat of local matlist {
		local Mat = proper("`mat'")
		return matrix `mat' ``Mat''
	}
end

program LCEffects, rclass
	version 9
	local vv : di "version " string(_caller()) ":"
	syntax anything(name=lexp id="linear expression" equalok) [, * ]
	_svy_mkdeff
	EffectsOpts, `options'
	local deff `s(deff)'
	local deft `s(deft)'
	local meff `s(meff)'
	local meft `s(meft)'
	local sub  `s(sub)'

	local matlist deft`sub' deff`sub'
	if "`meff'`meft'" != "" & `"`e(V_msp)'"' == "" {
		`vv' _svy_mkvmsp
	}
	if `"`e(V_msp)'"' == "matrix" {
		tempname Vmsp
		matrix `Vmsp' = e(V_msp)
	}

	tempname results x b V Vsrs Deff Deft
	_est hold `results', restore copy

	_test `lexp' = 0, notest
	quietly _test `lexp' = 0
	if missing(e(df_r)) {
		scalar `x' = r(chi2)
	}
	else {
		scalar `x' = r(F)
	}
	matrix `b' = e(b)
	matrix `V' = e(V)
	matrix `Vsrs' = e(V_srs`sub')
	if `"`e(V_srswr)'"' == "matrix" {
		tempname Vswr
		matrix `Vswr' = e(V_srs`sub'wr)
	}

	_getbv `x' `b' `V' `"`lexp'"'

	GetCVC `Vsrs' `lexp'
	matrix `Deff' = `V'[1,1]/`Vsrs'[1,1]
	if "`Vmsp'" != "" {
		GetCVC `Vmsp' `lexp'
		tempname Meft
		matrix `Meft' = sqrt(`V'[1,1]/`Vmsp'[1,1])
	}
	if "`Vswr'" != "" {
		GetCVC `Vswr' `lexp'
		matrix `Deft' = sqrt(`V'[1,1]/`Vswr'[1,1])
	}
	else	matrix `Deft' = sqrt(`Deff'[1,1])

	_est unhold `results'
	local df = e(df_r)
	if `:word count `e(depvar)'' == 1 {
		local depvar `e(depvar)'
	}
	local fpc `"`e(fpc1)'"'
	_est hold `results', restore
	Epost `b' `V' `Deff' `Deft' "`Meft'" "`depvar'" "`sub'" "`fpc'"

	Effects, lceffects nolegend `options'
	if "`Vmsp'" != "" {
		matrix `x' = e(meft)
		return scalar meft = `x'[1,1]
		return scalar meff = `x'[1,1]^2
	}
	foreach mat of local matlist {
		matrix `x' = e(`mat')
		return scalar `mat' = `x'[1,1]
	}
	matrix `x' = e(V)
	return scalar se = sqrt(`x'[1,1])
	matrix `x' = e(b)
	return scalar estimate = `x'[1,1]
	return scalar df = `df'
end

program Epost, eclass
	args b V Deff Deft Meft depvar sub fpc cmd
	if "`depvar'" != "" {
		local dopt depname(`depvar')
	}
	local subpop `"`sub'"'
	ereturn post `b' `V', `dopt'
	ereturn matrix deff`sub' `Deff'
	ereturn matrix deft`sub' `Deft'
	ereturn local depvar	`depvar'
	ereturn local subpop	`"`subpop'"'
	ereturn local over	`"`over'"'
	ereturn local prefix	`"svy"'
	ereturn local fpc1	`"`fpc'"'
	ereturn local cmd	`"`cmd'"'
	if "`Meft'" != "" {
		ereturn matrix meft `Meft' 
	}
end

program EffectsOpts, sclass
	syntax [, DEFF DEFT MEFF MEFT SRSsubpop ]
	if "`srssubpop'" != "" {
		is_svysum `e(cmd)'
		if r(is_svysum) {
			local emptyover = "`e(over)'" == ""
		}
		else	local emptyover 1
		if `"`e(subpop)'"' == "" & `emptyover' {
			di as err ///
"option srssubpop requires subpopulation estimation results"
			exit 322
		}
		if "`deff'`deft'" == "" {
			local deff deff
			local deft deft
		}
		local sub sub
	}
	local diopts `deff' `deft' `meff' `meft'
	local ndiopts : word count `diopts'
	if `ndiopts' == 0 {
		if `"`e(deff)'"' == "matrix" {
			local deff deff
			local deft deft
		}
		if `"`e(meft)'"' == "matrix" {
			local meff meff
			local meft meft
		}
	}
	sreturn local deff `deff'
	sreturn local deft `deft'
	sreturn local meff `meff'
	sreturn local meft `meft'
	sreturn local sub  `sub'
end

program GetCVC, eclass
	gettoken V 0 : 0
	tempname w

	local dim = colsof(`V')
	matrix `w' = 0*`V'[1,1..`dim']

	ereturn post `w' `V'

	qui _test `0' = 1
	scalar `w' = r(chi2)

	matrix `V' = (0)
	if !missing(1/`w') {
		matrix `V'[1,1] = 1/`w'
	}
end

program DisplayTable, sclass
	syntax name(name=caller) [,	///
		C1(string)		///
		C2(string)		///
		C3(string)		///
		C4(string)		///
		noLegend		///
		Verbose			///
		SD			///
		SIZE			///
		VSQUISH			///
		ALLBASElevels		///
		BASElevels		///
		noOMITted		///
		noEMPTYcells		///
	]

	local basecaller cv effects
	local checkbase : list caller in basecaller
	if `checkbase' {
		local checkbase = inlist("`e(cmd)'", "mlogit")
	}

	local DIOPTS	`vsquish'	///
			`allbaselevels'	///
			`baselevels'	///
			`omitted'	///
			`emptycells'
	local diopts : copy local DIOPTS
	if !`:list posof "vsquish" in diopts' {
		local diopts `diopts' vsquish
	}

	// check for -_svy_summarize- results
	is_svysum `e(cmd)'
	local is_sum = r(is_svysum)

	local nfreeparms : colnfreeparms e(b)

	// check for total number of equations
	_ms_lf_info
	local neq = r(k_lf)
	forval j = 1/`neq' {
		local k`j' = r(k`j')
		if "`r(lf`j')'" != "_" {
			local eq`j' `"`r(lf`j')'"'
		}
	}
	if `nfreeparms' {
		local k_eq = `neq'
		local k_aux = `nfreeparms'
	}
	else {
		local k_eq 0
		Chk4PosInt k_eq
		if `k_eq' == 0 {
			local k_eq = `neq'
		}
		// check for auxiliary parameters
		local k_aux 0
		Chk4PosInt k_aux
	}
	// check for extra equations
	local k_extra 0
	Chk4PosInt k_extra

	Header, `legend' `verbose' is_sum(`is_sum')

	local fmt %8.0g
	local tfmt2 %11s %10s %10s %10s
	if "`sd'" != "" {
		local spad 2
	}
	else	local spad 1
	if "`sd'" != "" | `"`c1'"' == "" {
		local width2  0  0  0  0
		local pad2    0  0  0  0
	}
	else if "`c2'" == "" {
		local width2 11  0  0  0
		local pad2    3  0  0  0
	}
	else if "`c3'" == "" {
		local width2 11 10  0  0
		local pad2    3  2  0  0
	}
	else if "`c4'" == "" {
		local width2 11 10 10  0
		local pad2    3  2  2  0
	}
	else {
		local width2 11 10 10 10
		local pad2    3  2  2  2
	}
	if "`size'" != "" {
		local fmt %14.0gc
		local tfmt2 %17s %16s %16s %16s
		if "`c1'" == "" {
			local width2  0  0  0  0
			local pad2    0  0  0  0
		}
		else if "`c2'" == "" {
			local width2 17  0  0  0
			local pad2    3  0  0  0
		}
		else {
			local width2 17 16  0  0
			local pad2    3  2  0  0
		}
	}

	// create _tab object
	tempname Tab b se
	.`Tab' = ._tab.new, col(7) lmargin(0) ignore(.b)
	// identify element properties for a full table
	// column        1      2     3      4      5      6     7
	local width1    13|    12    11
	local tfmt1      .      .  %11s
	local nfmt1      .  %9.0g  %9.0g
	local nfmt2                      `fmt'  `fmt'  `fmt' `fmt'
	local pad1       .      2 `spad'
	local titles0                     `"""     ""     ""    """'
	local elements0                   `"""     ""     ""    """'
	local dots0                       `" .      .      .     ."'
	// NOTE: there 4 columns available for display, there is no room to
	// add more columns given a fixed 80 (actually 78) char column table

	// first 3 column elements are already known
	local col1 12
	local widths "`width1'"
	local tfmts
	local nfmts
	local pads

	if "`e(error)'" == "matrix" {
		tempname errmat
		matrix `errmat' = e(error)
	}
	if "`sd'" != "" {
		local cmax 0
		gettoken sdmat c2ttl : c1
		local c2ttl : list retok c2ttl
	}
	else {
		local cmax 4
		local c2ttl "Std. Err."
	}
	forval j = 1/`cmax' {
		if `"`c`j''"' != "" {
			local C`j' : word 1 of `c`j''
			gettoken tok width2 : width2
			local widths `widths' `tok'
			gettoken tok tfmt2 : tfmt2
			local tfmts `tfmts' `tok'
			gettoken tok nfmt2 : nfmt2
			local nfmts `nfmts' `tok'
			gettoken tok pad2 : pad2
			local pads `pads' `tok'
			gettoken tok titles0 : titles0
			gettoken ignore ttl : c`j'
			local titles `"`titles' "`ttl'""'
			gettoken tok elements0 : elements0
			local row `macval(row)' `C`j''[1,\`i']
		}
	}

	// automatically determine neq
	local neq = `k_eq'-`k_aux'-`k_extra'
	if `neq' < 0 {
		if `k_aux' & `k_extra' {
			di as err ///
"estimation command error: e(k_eq) is less than e(k_aux) + e(k_extra)"
			exit 322
		}
		local name = cond(`k_aux',"k_aux","k_extra")
		di as err ///
"estimation command error: e(k_eq) is less than e(`name')"
		exit 322
	}
	if `is_sum' | `neq' != 1 | `k_extra' != 0 {
		local showeqns showeqns
	}
	local neq = `neq' + `k_aux'
	local neq1 = `k_eq'-`k_aux'-`k_extra'

	// set the table parameters
	.`Tab'.width    `widths' `width2'
	.`Tab'.titlefmt `tfmt1'  `tfmts'  `tfmt2'
	.`Tab'.numfmt   `nfmt1'  `nfmts'  `nfmt2'
	.`Tab'.pad      `pad1'   `pads'   `pad2'
	//               1     2 3 4 5 6 7
	.`Tab'.strfmt    . %-64s . . . . .

	GetColTitles `neq1' : depvar coef

	// start drawing the table
	.`Tab'.sep, top
	if "`sd'" == "" & `"`e(vcetype)'"' != "" {
		local vcetype `"`e(vcetype)'"'
		local plus 0
		local vcewd : length local vcetype
		if "`e(prefix)'" != "svy" & "`e(vce)'" == "bootstrap" {
			local obc "Observed"
		}
		if `"`e(mse)'"' != "" {
			capture which `e(vce)'_`e(mse)'.sthlp
			local mycrc = c(rc)
			if `mycrc' {
				capture which `e(vce)'_`e(mse)'.hlp
				local mycrc = c(rc)
			}
			if !`mycrc' {
				local vcetype ///
				"{help `e(vce)'_`e(mse)'##|_new:`vcetype'}"
				local plus = `: length local vcetype' - `vcewd'
			}
		}
		if `vcewd' <= 12 {
			local vcewd = `vcewd' + `plus' + ceil((12-`vcewd')/2)
		}
		// column        1       2                3   4  5  6  7
		.`Tab'.titlefmt  .       .        %`vcewd's   .  .  .  .
		.`Tab'.titles   "" "`obc'"    `" `vcetype'"' "" "" "" ""
		.`Tab'.titlefmt  .       .             %11s   .  .  .  .
	}
	.`Tab'.titles   "`depvar'" "`coef'" "`c2ttl'" `titles' `titles0'
	if "`:word 1 of `coleq''" == "_" {
		local coleq
		local eq
		.`Tab'.sep
	}
	local error1 "  (no observations)"
	local error2 "  (stratum with 1 PSU detected)"
	local error3 "  (sum of weights equals zero)"
	local error4 "  (denominator estimate equals zero)"
	local error5 "  (omitted)"
	local error6 "  (base)   "
	local error7 "  (empty)  "
	local bout   "  (base outcome)"
	local i 0
	forval j = 1/`neq' {
		if `j' <= `neq1' {
			.`Tab'.sep
			if `:length local showeqns' & `:length local eq`j'' {
				local eq = abbrev("`eq`j''", `col1')
				if `checkbase' {
					if `j' == e(ibaseout) {
						di as res %-`col1's "`eq'" _c
						.`Tab'.row "" "`bout'"	///
							.b .b .b .b .b
						local i = `i' + `k`j''
						continue
					}
				}
				di as res %-`col1's "`eq'" as txt " {c |}"
			}
		}
		else if `j' == `neq1' + 1 {
			.`Tab'.sep
		}
		local output 0
		local first
		forval k = 1/`k`j'' {
			local ++i
			local ei 0
			if `j' <= `neq1' {
				_ms_display,	eq(#`j')	///
						el(`k')		///
						`first'		///
						`diopts'
				local note `"`r(note)'"'
				if "`note'" == "(base)" {
					local ei 6
				}
				if "`note'" == "(empty)" {
					local ei 7
				}
				if "`note'" == "(omitted)" {
					local ei 5
				}
				if r(output) {
					local first
					if !`output' {
						local output 1
						local diopts `DIOPTS'
					}
				}
				else {
					if r(first) {
						local first first
					}
					continue
				}
				scalar `b' = r(b)
				scalar `se' = r(se)
				local bvalue : copy local b
				local sevalue : copy local se
				local name
				.`Tab'.width . 13 . `dots0', noreformat
			}
			else {
				if `nfreeparms' {
					local name = abbrev("`eq`j''",`col1')
					local bvalue  _b[`eq`j'']
					local sevalue  _se[`eq`j'']
				}
				else {
					local name = abbrev("/`eq`j''",`col1')
					local bvalue  _b[/`eq`j'']
					local sevalue  _se[/`eq`j'']
				}
			}
			if "`sd'" != "" {
				local sevalue `sdmat'[1,`i']
			}
			if !`ei' {
				if `:length local errmat' {
					local ei = `errmat'[1,`i']
				}
			}
			if `ei' {
				local note : copy local error`ei'
				.`Tab'.row "`name'" "`note'" .b .b .b .b .b
			}
			else {
				.`Tab'.row	"`name'"		///
						`bvalue'		///
						`sevalue'		///
						`row'			///
						`elements0'
			}
			.`Tab'.width . |12 11 `dots0', noreformat
		}
	}
	.`Tab'.sep, bottom
	sreturn local width = "`.`Tab'.width_of_table'"
end

program Header
	syntax [, noHeader noLegend Verbose is_sum(integer 0) ]

	local blank
	if "`legend'" == "" {
		if inlist("`e(vce)'","jackknife","brr") ///
		 & "`e(cmd)'" == "`e(vce)'"{
			_prefix_legend `e(vce)', `verbose'
			if "`e(vce)'" == "jackknife" ///
				& "`e(jkrweight)'" == "" ///
				& "`e(wtype)'" != "iweight" {
				_jk_nlegend `s(col1)' ///
					`"`e(nfunction)'"'
				local blank blank
			}
		}
		if `is_sum' {
			_svy_summarize_legend `blank'
			local blank `s(blank)'
		}
	}
	if "`blank'" == "" {
		di
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

// setup macros for column headings
program GetColTitles
	args neq COLON depvar coef
	is_svysum `e(cmd)'
	local is_sum = r(is_svysum)
	if `is_sum' {
		if "`e(over)'" != "" {
			c_local `depvar' "Over"
		}
		c_local `coef' = proper("`e(cmd)'")
	}
	else {
		local dv `"`e(depvar)'"'
		if `:word count `dv'' == 1 ///
		 & (`neq' <= 1 | !`:list dv in coleq') {
			c_local `depvar' = abbrev("`dv'",12)
		}
		c_local `coef' "Coef."
	}
	
end

program CheckPost
	args sub
	if `"`e(poststrata)'"' != "" {
		di as err ///
		"estat `sub' is not allowed with poststratification"
		exit 322
	}
	is_svysum `e(cmd)'
	if r(is_svysum) & `"`e(stdize)'"' != "" {
		di as err ///
		"estat `sub' is not allowed with direct standardization"
		exit 322
	}
end

mata:

void svy_estat_CoefVar(	string	scalar	st_b,
			string	scalar	st_se,
			string	scalar	st_cv)
{
	st_matrix(st_se, sqrt(diagonal(st_matrix(st_se)))')
	st_matrix(st_cv, 100*st_matrix(st_se):/abs(st_matrix(st_b)))
}

end

exit
