*! version 1.1.1  29jan2015
program u_mi_estimate_table_header
	version 11
	local is_xt = bsubstr("`e(cmd_mi)'",1,2)=="xt" | ///
		inlist("`e(cmd_mi)'","mixed","meqrlogit","meqrpoisson")
	if `is_xt' {
		local ADDOPTS NOGRoup
	}
	syntax [,			///
		noHeader		///
		noMODELtest		///
		TItle(string asis)	///
		title2(string asis)	///
		TRCOEFTItle		///
		nocluster		///
		noRULES			///
		TRCOEF			///
		NOMIHEADer		///
		NOCMDHEADer		///
		NOMIDFHEADer		///
		NOWVCE			///
		MIHEADER		///
		CMDHEADER		///
		NOSPACE			///
		NRIGHT(string)		///
		NLEFT(string)		///
		NOCOMPACT		///
		compact			///
		NOOBS			///
		NOMISTATS		///
		`ADDOPTS'		///  <cmd>-specific opts
	]

	opts_exclusive "`compact' `nocompact'"
	if ("`header'" != "") exit

	if ("`miheader'"!="") {
		local nomidfheader nomidfheader
		local nowvce nowvce
		local modeltest nomodeltest
	}
	if ("`cmdheader'"!="") {
		if ("`miheader'"=="") {
			local nomiheader nomiheader
		}
		local nomistats nomistats
		local nomidfheader nomidfheader
		local nowvce nowvce
		local modeltest nomodeltest
	}

	if ("`trcoef'"!="") {
		local misuffix _Q
	}
	
	tempname left right
	.`left' = {}
	.`right' = {}
	
	local is_svy = "`e(prefix)'" == "svy"
	local is_xtme = inlist("`e(cmd_mi)'","xtmixed","xtmelogit",	///
		"xtmepoisson","mixed","meqrlogit","meqrpoisson")
	is_svysum `e(cmd_mi)'
	local is_sum `r(is_svysum)'
	if `is_sum' {
		local compact compact
	}
	if ("`nocompact'"!="") {
		local compact
	}

	if "`compact'"!="" {
		local width 62
		local C1 _col(1)
		local c2 19
		local c3 35
		local c4 51
		local c2wfmt 9
		local c4wfmt 10
		local scheme compact
	}
	else if `is_svy' { // MI header style for -svy:-
		local width 78
		local C1 _col(1)
		local c2 19
		local c3 49
		local c4 67
		local c2wfmt 9
		local c4wfmt 10
		local scheme svy
	}
	else if `is_xt' { // MI header style for xt
		local width 78
		local C1 _col(1)
		local c2 18
		local c3 49
		local c4 67
		local c2wfmt 9
		local c4wfmt 10
		local scheme ml
	}
	else { // MI header style for all cmds
		local width 78
		local C1 _col(1)
		local c2 18
		local c3 49
		local c4 67
		local c2wfmt 10
		local c4wfmt 10
		local scheme ml
	}
	if `is_svy' {
		local maxlen = `width'-`c2'-(`c2wfmt'+2)-2-(`c4'-`c3')-2
		if `maxlen' > 19 {
			local maxlen 19
		}
		local len : display %`maxlen'.0fc e(N_pop_mi)
		local len : list retok len
		local len : length local len
		local ++maxlen
		local ++len
		if `c4wfmt' <= `len' & `len' <= `maxlen' {
			local c3 = `c3' + `c4wfmt' - `len'
			local c4 = `c4' + `c4wfmt' - `len'
			local c4wfmt = `len'
		}
	}

	local C2 _col(`c2')
	local C3 _col(`c3')
	local C4 _col(`c4')
	local max_len_title = `c3' - 2
	local sfmt %13s
	local ablen 14

	local c4wfmt1 = `c4wfmt' + 1

	if ("`miheader'"!="" & "`cmdheader'"=="") {
		local is_svy 0
		local is_sum 0
		local is_xt 0
	}
	if `is_xt' & "`nogroup'"!="" {
		local is_xt 0
	}

	// display title
	if `"`title'"' == "" {
		local title  `"`e(title_mi)'"'
	}
	if `"`title2'"' == "" {
		local cmd `e(cmd_mi)'
		u_mi_prefix_title title2 : `cmd' "" 
	}
	if ("`nomiheader'"!="") {
		local title
	}
	if ("`nocmdheader'"!="") {
		local title2
		local noobs noobs
	}
	if ("`trcoeftitle'"!="") {
		local title Transformations
	}
	// Left hand header *************************************************
	local svyskip 0
	// make title, title2 line part of the header if it fits
	local len_title : length local title2
	if `len_title' < `max_len_title' {
		if (`"`title'"'!="") {
			.`left'.Arrpush `"`"`title'"'"'
			local title
		}
		if `"`title2'"' != "" {
			.`left'.Arrpush `"`"`title2'"'"'
			local title2
		}
		if (`is_svy') {
			.`left'.Arrpush ""
			local svyskip 1
		}
	}
	else {
		if ("`title'"!="") {
			.`left'.Arrpush ""
		}
		if ("`title2'"!="") {
			.`left'.Arrpush ""
		}
	}
	if ("`nocmdheader'"!="") {
		local is_svy 0
		local is_sum 0
		local is_xt 0
	}
	if ("`e(model)'"=="pa") {
		local LC 42
	}
	else { 
		local LC 29
	}
	// display group information
	local nlcmd 0
	if `is_xt' {
		local onegroup 1
		local ivar `e(ivar)'
	}
	else {
		local onegroup 0
	}
	if `is_xt' & `is_xtme' & "`e(binomial)'"!="" {
                cap confirm number `e(binomial)'
                if _rc {
.`left'.Arrpush `"`"Binomial variable: {res:`e(binomial)'}"'"'
                }
                else {
.`left'.Arrpush `"`"Binomial trials = {res:`=string(`e(binomial)',"%3.0f")'}"'"'
                }

	}
	if `is_xt' & `is_xtme' {
		local ivar `e(ivars)'
		if "`e(ivars)'"=="" {
			local is_xt 0
		}
		else if `:word count `e(ivars)''>1 {
			local onegroup 0
			local nlcmd =  `.`left'.arrnels'
			if inlist("`e(cmd_mi)'","xtmixed","mixed") {
				local dicmd _xtmixed_display, grouponly mi
			}
			else {
				local dicmd _xtme_display, grouptable mi
			}
		}
	}
	if `is_xt' & `onegroup' {
		if "`e(binomial)'"=="" {
			.`left'.Arrpush ""
		}
		local groupvar = abbrev("`ivar'",12)
		if ("`e(family)'"!="") {
if ("`e(tvar)'"!="") {
	local tvar = abbrev("`e(tvar)'",12)
	.`left'.Arrpush `"`"Group and time vars:{ralign `=`LC'-20':{res:`groupvar' `tvar'}}"'"'
}
else {
	.`left'.Arrpush `"`"Group variable:{ralign `=`LC'-15':{res:`groupvar'}}"'"'
}
.`left'.Arrpush `"`"Link:{ralign `=`LC'-5':{res:`e(link)'}}"'"'
.`left'.Arrpush `"`"Family:{ralign `=`LC'-7':{res:`e(family)'}}"'"'
.`left'.Arrpush `"`"Correlation:{ralign `=`LC'-12':{res:`e(corr)'}}"'"'
.`left'.Arrpush `"`"Scale parameter:{ralign `=`LC'-16':{res:`e(scale)'}}"'"'
		}
		else {
.`left'.Arrpush `"`"Group variable: {res:`groupvar'}"'"'
if ("`e(distrib)'"!="") {
	.`left'.Arrpush `""Random effects u_i ~ {res:`e(distrib)'}""'
}
else {
	.`left'.Arrpush ""
}
.`left'.Arrpush ""
local w : word count `e(n_quad)'
if `w'==1 { //[xt]melogit, [xt]mepoisson
	.`left'.Arrpush `"`"Integration points = {res:`=string(`e(n_quad)',"%3.0f")'}"'"'
}
else {
	.`left'.Arrpush ""
}
		}
	}
	// display N strata
	if `is_svy' & !missing(e(N_strata_mi)) {
		.`left'.Arrpush					///
			`C1' "Number of strata" `C2' "= "	///
			as res %`c2wfmt'.0fc e(N_strata_mi)
	}

	// display number of PSU/clusters
	if `is_svy' & !missing(e(N_psu_mi)) {
		.`left'.Arrpush					///
			`C1' "Number of PSUs" `C2' "= "		///
			as res %`c2wfmt'.0fc e(N_psu_mi)
	}

	// display N of poststrata
	if `is_svy' & !missing(e(N_poststrata_mi)) {
		.`left'.Arrpush					///
			`C1' "N. of poststrata" `C2' "= "	///
			as res %`c2wfmt'.0fc e(N_poststrata_mi)
	}

	// display N of stdize strata
	if (`is_sum') & !missing(e(N_stdize_mi)) {
		.`left'.Arrpush					///
			`C1' "N. of std strata" `C2' "= "	///
			as res %`c2wfmt'.0fc e(N_stdize_mi)
	}

	// Right hand header ************************************************
	if ( !missing(e(M_mi)) & "`nomiheader'"=="" ) {
		// display number of imputations
		.`right'.Arrpush				///
			`C3' "Imputations" `C4' "= "		///
			as res %`c4wfmt'.0fc e(M_mi)
	}

	// display N obs
	if ("`noobs'"=="" & !missing(e(N_mi))) {
		.`right'.Arrpush					///
			`C3' "Number of obs" `C4' "= "			///
			as res %`c4wfmt'.0fc e(N_mi)
		if (`svyskip') {
			.`right'.Arrpush ""
		}
	}
	
	// display N groups
	if `is_xt' & `onegroup' {
		if `is_xtme' {
			local Ng	el(e(N_g_mi),1,1)
			local gmin	el(e(g_min_mi),1,1)
			local gavg	el(e(g_avg_mi),1,1)
			local gmax	el(e(g_max_mi),1,1)
		}
		else {
			local Ng	e(N_g_mi)
			local gmin	e(g_min_mi)
			local gavg	e(g_avg_mi)
			local gmax	e(g_max_mi)
		}
		.`right'.Arrpush ""
		.`right'.Arrpush					///
			`C3' "Number of groups" `C4' "= "		///
			as res %`c4wfmt'.0fc `Ng'
		.`right'.Arrpush					///
			`C3' "Obs per group:"
		.`right'.Arrpush					///
			`C3' "              min" `C4' "= "		///
			as res %`c4wfmt'.0fc `gmin'
		.`right'.Arrpush					///
			`C3' "              avg" `C4' "= "		///
			as res %`c4wfmt'.1fc `gavg'
		.`right'.Arrpush					///
			`C3' "              max" `C4' "= "		///
			as res %`c4wfmt'.0fc `gmax'
	}

	// display Pop size
	if `is_svy' & !missing(e(N_pop_mi)) {
		.`right'.Arrpush				///
			`C3' "Population size" `C4' "="		///
			as res %`c4wfmt1'.0gc e(N_pop_mi)
	}

	// display subpop N obs and subpop size
	if `is_svy' & !missing(e(N_sub_mi)) {
		local SubNobs "Subpop. no. obs"
		.`right'.Arrpush				///
			`C3' "`SubNobs'" `C4' "="		///
			as res %`c4wfmt1'.0fc e(N_sub_mi)
		.`right'.Arrpush				///
			`C3' "Subpop. size" `C4' "="		///
			as res %`c4wfmt1'.0gc e(N_subpop_mi)
	}

	if ("`nomistats'"=="") {
		// display Ave. rel. var. increase
		.`right'.Arrpush				///
			`C3' "Average RVI" `C4' "= "		///
			as res %`c4wfmt'.4f e(rvi_avg`misuffix'_mi)

		// display largest FMI
		.`right'.Arrpush				///
			`C3' "Largest FMI" `C4' "= "		///
			as res %`c4wfmt'.4f e(fmi_max`misuffix'_mi)
	}
	if ("`nomidfheader'"=="" & !missing(e(df_c_mi))) {
		// display complete DF
		.`right'.Arrpush				///
			`C3' "Complete DF" `C4' "= "		///
			as res %`c4wfmt'.0f e(df_c_mi)
	}
	// display degrees of freedom information
	if ("`nomidfheader'"=="") {
		local dfmis = e(_dfnote`misuffix'_mi)
		local dfti DF
		if (`dfmis') {
			local dflink "{help mi_missingdf##|_new:`dfti'}:"
		}
		else {
			local dflink `dfti':
		}
		.`right'.Arrpush				///
			`C3' "`dflink'     min" `C4' "= "	///
			as res %`c4wfmt'.2fc e(df_min`misuffix'_mi)
		.`right'.Arrpush				///
			`C3' "        avg" `C4' "= "	///
			as res %`c4wfmt'.2fc e(df_avg`misuffix'_mi)
		.`right'.Arrpush				///
			`C3' "        max" `C4' "= "	///
			as res %`c4wfmt'.2fc e(df_max`misuffix'_mi)
	}

	if `"`e(k_eq_model)'"' == "0" & 	///
	   "`e(cmd_mi)'"!="glm" & "`e(cmd_mi)'"!="binreg" { 
		//do not display model test
		local modeltest nomodeltest
	}
	if "`modeltest'" == "" & !missing(e(df_m_mi)) {
		// display a model test
		Ftest `right' `C3' `C4' `c4wfmt' `is_svy'
	}

	if ("`modeltest'"=="" | "`nomidfheader'"=="") { //bottom left header
		// number of elements in the right header
		local kr = `.`right'.arrnels'
		// number of elements in the left header
		local kl = `.`left'.arrnels'
		if ("`nomidfheader'"=="") {
			if ("`modeltest'"=="" & !missing(e(F_mi))) {
				local skip 5
			}
			else {
				local skip 3
			}
			local space = `kr' - `kl' - `skip'
			forval i = 1/`space' {
				.`left'.Arrpush ""
			}
			.`left'.Arrpush 	///
		`""DF adjustment:{ralign `=`LC'-14': {res:`e(dfadjust_mi)'}}""'
		}
		if ("`modeltest'"=="" & !missing(e(F_mi))) {
			if ("`nomidfheader'"=="") {
				.`left'.Arrpush ""
				.`left'.Arrpush ""
			}
			.`left'.Arrpush ///
		`""Model F test:{ralign `=`LC'-13': {res:`e(modeltest_mi)'}}""'
		}
	}
	// put within VCE type at the bottom of the left header
	if ("`nowvce'"=="" & "`e(wvce_mi)'"!="") {
		local kr = `.`right'.arrnels'
		// number of elements in the left header
		local kl = `.`left'.arrnels'
		local space = `kr' - `kl' - 1
		forval i = 1/`space' {
			.`left'.Arrpush ""
		}
		_get_within_vce vtype
		.`left'.Arrpush 	///
		       `""Within VCE type: {ralign `=`LC'-17':{res:`vtype'}}""'
	}

	Display `left' `right' `"`title'"' `"`title2'"' "`nospace'" "`nlcmd'" "`dicmd'"
	if ("`nright'"!="") {
		local nr = `.`right'.arrnels'
		c_local `nright' `nr'
	}
	if ("`left'"!="") {
		local nl = `.`left'.arrnels'
		c_local `nleft' `nl'
	}

end

program Display
	args left right title title2 nospace nleft dicmd

	local nl = `.`left'.arrnels'
	local nr = `.`right'.arrnels'
	local K = max(`nl',`nr')
	if ("`nospace'"=="") {
		di
	}
	if `"`title'"' != "" {
		di as txt `"`title'"'
	}
	if `"`title2'"' != "" {
		di as txt `"`title2'"'
	}
	if (`"`title'`title2'"'!="" & "`nospace'"=="") {
		di
	}
	local c _c
	forval i = 1/`K' {
		di as txt `.`left'[`i']' as txt `.`right'[`i']'
		if (`i'==`nleft') {
			`dicmd'
			di
		}
	}
end

program Ftest
	args right C3 C4 c4wfmt is_svy
	
	local dfr_fmt %7.1f
	local df = e(df_r_mi)
	if !missing(e(F_mi)) {
		if (missing(`df') & !missing(e(p_mi))) {
			local dfm_l : di %4.0f e(df_m_mi)
			local dfm_l2: di `dfr_fmt' `df'
			local mi_missing 	///
			   "{help mi_missingdf##|_new:F(`dfm_l',`dfm_l2')}"
			.`right'.Arrpush				///
				  `C3' "`mi_missing'"			///
				   as txt `C4' "= "as res %`c4wfmt'.2f e(F_mi)
		}
		else {
			.`right'.Arrpush				///
				 `C3' "F("				///
			   as res %4.0f e(df_m_mi)			///
			   as txt ","					///
			   as res `dfr_fmt' `df' as txt ")" `C4' "= "	///
			   as res %`c4wfmt'.2f e(F_mi)
		}
		tempname fprob
		scalar `fprob' = Ftail(e(df_m_mi),`df',e(F_mi))
		if (`df'>2e17) { // use chi-square approxim.
			scalar `fprob' = chi2tail(e(df_m_mi),e(df_m_mi)*e(F_mi))
		}
		.`right'.Arrpush				///
			 `C3' "Prob > F" `C4' "= "		///
		   as res %`c4wfmt'.4f `=`fprob''
	}
	else {
		local dfm_l : di %4.0f e(df_m_mi)
		local dfm_l2: di `dfr_fmt' `df'
		local j_robust 	///
			"{help j_robustsingular##|_new:F(`dfm_l',`dfm_l2')}"
		.`right'.Arrpush				///
			  `C3' "`j_robust'"			///
		   as txt `C4' "= " as result %`c4wfmt's "."
		.`right'.Arrpush				///
			  `C3' "Prob > F" `C4' "= " as res %`c4wfmt's "."
	}
end

program _get_within_vce

	args vce

	local wvce `"`e(vcetype)'"'
	if !`:length local wvce' {
		local wvce `"`e(vce)'"'
		if !`:length local wvce' {
			local wvce `"`e(wvce_mi)'"'
		}
		local proper conventional twostep unadjusted robust analytic
		if `:list wvce in proper' {
			local wvce = strproper(`"`wvce'"')
		}
		else	local wvce = strupper(`"`wvce'"')
	}

	c_local `vce' `wvce'
end

exit
