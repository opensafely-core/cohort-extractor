*! version 1.3.1  03may2019
program u_mi_estimate_display
	version 11

	local cmdname `e(cmd_mi)'
	is_svysum `e(cmd_mi)'
	local is_sum `r(is_svysum)'

	// get display options and the default eform opts.
	u_mi_estimate_get_commonopts `cmdname'
	local diopts `s(diopts)'
	local cmddiopts `s(cmddiopts)'
	syntax [,	`diopts'		///
			`cmddiopts'		///
			ESAMPVARYFLAG		/// // only for -using- specific
			NOCNSReport		///
			cformat(passthru)	///
			sformat(passthru)	///
			pformat(passthru)	///
			COEFlegend		///
			SELEGEND		///
			NOLSTRETCH		///	
		  	*		/// // eform_opts and factor diopts
		]

	local formatopts `cformat' `sformat' `pformat'
	if ("`mcerror'"=="") {
		local nomcerror nomcerror
	}
	else if (!`e(mcerror_mi)') {
		di as txt "{p 0 6 0}note: Monte Carlo error estimates are not"
		di as txt "available; {bf:mcerror} ignored{p_end}"
	}
	u_mi_estimate_chk_eform `e(cmd_mi)', `options'
	_get_diopts msopts eform, `options' `sformat' `pformat'
	if `"`eform'"'!="" & "`estmetric'"!="" {
		di as txt "{p 0 6 2}note: eform options are ignored with " ///
		  "{bf:estmetric}.{p_end}"
		local eform
	}
	if (`is_sum' & `"`eform'"'!="") {
		_get_eformopts, eformopts(`eform')
		local eform
		di as txt "{p 0 6 2}note: eform options are ignored with " ///
		  "{bf:mi estimate: `e(cmd_mi)'}.{p_end}"
	}
	if (`is_sum' & `"`msopts'"'!="") {
		local nopt : word count `msopts'
		di as txt "{p 0 6 2}note: " plural(`nopt',"option") ///
			  `" {bf:`msopts'} "' plural(`nopt',"is","are") ///
			  " ignored with {bf:mi estimate: `e(cmd_mi)'}.{p_end}"
		
		local msopts `cformat' `coeflegend' `selegend' `nolstretch'
		local nocnsreport
	}
	else {
		local msopts `msopts' `cformat' `coeflegend' `selegend' ///
			     `nolstretch'
	}
	local M `_dta[_mi_M]'
	if ("`M'"=="") {
		if ("`mcerror'"=="") {
			local M 2
		}
		else {
			local M 3
		}
	}
	if `"`0'"'=="" {
		local comma ,
	}
	u_mi_estimate_chk_commonopts `comma' `0' maxm(`M') cmd(`cmdname')
	local cmddiopts `s(cmddiopts)' `formatopts'
	if ("`nocoef'"!="" & (e(k_exp_mi)==0 | "`notrcoef'"!="")) {
		if ("`post'"!="") {
			u_mi_postbv
		}
		exit
	}
	
	local is_xtme = inlist("`e(cmd_mi)'","xtmixed","xtmelogit", ///
		"xtmepoisson","mixed","meqrlogit","meqrpoisson")
	local is_mixed = inlist("`e(cmd_mi)'","xtmixed","mixed")
	
	// check eform opts
	_get_eformopts, eformopts(`eform') allowed(EForm hr shr IRr or RRr)
	if "`e(cmd_mi)'"=="streg" {
		if "`e(_efopt_mi)'"=="hr" & "`e(frm2)'"=="time" {
			local eform	// ignore -hr- with AFT form
			local cmdftnote mi_streg_hrnote
		}
	}
	else if "`e(cmd_mi)'"=="xtreg" {
		local cmdftnote mi_xtreg_note
	}
	else if `is_xtme' & "`estmetric'`dftable'`vartable'`noretable'"=="" {
		if ("`variance'"!="") {
			local isres = inlist("`e(rstructure)'",	///
					     "exchangeable",	///
					     "toeplitz")
			local vartypes `e(vartypes)'
			local posexch : list posof "Exchangeable" in vartypes
			local posunstr : list posof "Unstructured" in vartypes
			if `isres' | `posexch' | `posunstr' {
				local cmdftnote mi_me_note
			}
		}
		if `is_mixed' & 					///
		     (inlist("`e(rstructure)'","unstructured","banded") ///
		      | "`e(rbyvar)'"!="") {
			local cmdftnote mi_me_note
		}
	}

	// post Cns to e() to display constraints
	local unhold 0
	if ("`e(Cns_mi)'"=="matrix") {
		tempname esthold
		_estimates hold `esthold', copy
		u_mi_postbv
		local unhold 1
		local cnsmat cnsmat(e(Cns_mi)) 
	}
	// command legend
	local cmdline `"`e(cmdline)'"'
	if ("`nocoef'"=="" | "`notrcoef'`nolegend'`nocmdlegend'"!="") {
		local cmdline
	}

	// Display results
	if ("`nocmdnote'"=="") {
		mi_notes `cmdname'
	}
	if ("`vartable'"!="") { // display VI table
		u_mi_estimate_table_header, `noheader' `nomiheader' miheader ///
					nocompact noobs nomistats
		if ("`noheader'"=="") {
			di
			di as txt "Variance information"
		}
		_mi_vartable , cmdline(`cmdline') cmdname(`cmdname') 	///
			     `nolegend' `nocoef' `notrcoef' `notable' 	///
			     `nomcerror' `msopts'
		if "`notable'"=="" {
			mi_mcerror_footnote1 "79" "`nomcerror'" "nolevel"
		}
		if "`notable'"=="" & ///
		   (!mi(`e(df_c_mi)') & "`e(dfadjust_mi)'"=="Large sample") ///
		 | (`e(caller_mi)'<12 & "`e(dfadjust_mi)'"=="Small sample") {
			di as txt "{p 0 6 0 79}Note: FMIs are based on " ///
			  "Rubin's large-sample degrees of freedom.{p_end}"
		}
		di
	}

	//_coef_table opts for coeff. and transf.
	if ("`eform'"!="" & "`e(b_eform_mc_mi)'"=="" & "`nomcerror'"=="") {
		local mi_mcerror_footnote2 mi_mcerror_footnote2
		local nomcerror nomcerror
	}
	else if ("`eform'"!="") {
		local mceform mceform
	}
	if (`is_sum') {
		local emat ematrix(e(error))
	}
	if (`e(mcerror_mi)' & "`nomcerror'"=="") {
		if (`"`cformat'"'!="") {
			local coeftabopts row`cformat'
		}
		if (!`is_sum') {
			if (`"`sformat'"'!="") {
				local coeftabopts row`sformat'
			}
			if (`"`pformat'"'!="") {
				local coeftabopts row`pformat'
			}
		}
		local trtabopts `coeftabopts'
		// -rowmatrix()- is specified in _mi_tables
	}
	local coeftabopts `coeftabopts' bmat(e(b_mi)) vmat(e(V_mi)) 
	local coeftabopts `coeftabopts' `cnsmat'
	local coeftabopts `coeftabopts' dfmat(e(df_mi)) pisemat(e(pise_mi)) 
	local coeftabopts `coeftabopts' `msopts' l(`level') `eform' `mceform'
	local coeftabopts `coeftabopts' `nocnsreport' `emat'
	local xtlist `""xtprobit","xtlogit","xtcloglog","xtpoisson","xtnbreg""'
	if (inlist("`cmdname'",`xtlist')) {
		local coeftabopts `coeftabopts' notest
	}
	else if (`is_xtme') {
		if ("`estmetric'`dftable'`vartable'"=="") {
			local coeftabopts `coeftabopts' first
		}
		if (inlist("`cmdname'","xtmelogit","meqrlogit",	///
		    "xtmepoisson","meqrpoisson")) {
			local coeftabopts `coeftabopts' offsetonly1
		}
	}
	if ("`cmdname'"=="xtreg") {
		if inlist("`e(model)'","re","fe") {
			local coeftabopts `coeftabopts' plus
		}
	}
	local trtabopts `trtabopts' bmat(e(b_Q_mi))  vmat(e(V_Q_mi)) 
	local trtabopts `trtabopts' dfmat(e(df_Q_mi)) pisemat(e(pise_Q_mi)) 
	local trtabopts `trtabopts' l(`level') `msopts' noeqcheck
	if (!`is_sum') {
		local trtabopts `trtabopts' nodiparm
	}
	local clegend clegend
	if ("`citable'"=="" & "`dftable'"!="") {
		local dilevel "nolevel"
	}
	else {
		local dilevel "`level'"
	}
	if ("`nocoef'"=="") { // display coeff. table
		_mi_tables, `coeftabopts' cmdname(`cmdname') `notable'	 ///
			    `citable' `dftable' `nocitable'		 ///
			    `noheader' `nolegend' `clegend'		 ///
			    `nofetable' `nogroup' cmdextras `nomcerror'
		// s(width) is returned by _coef_table
		if ("`s(width)'"=="") {
			local linesize 79
		}
		else {
			local linesize = `s(width)'+1
		}
		// coef. table determines how transf. table is displayed
		local cmdline
		local nomiheader nomiheader
		local nocmdheader nocmdheader
		local trcoeftitle trcoeftitle
		local clegend
		local nocnsreport nocnsreport
		local toshow 1
		if ("`nocitable'"!="" & "`dftable'"=="") {
			local toshow 0
		}
		if ("`notable'"=="" & `toshow') {
			if (`is_mixed') {
				mi_mcerror_footnote1 	///
					"`linesize'" "`nomcerror'" "`dilevel'"
				if "`mi_mcerror_footnote2'"!="" {
					`mi_mcerror_footnote2' `linesize'
				}
				_mi_cmd_table, cmdname(`cmdname') ///
						`cmddiopts' l(`level')
			}
			else {
				_mi_cmd_table, cmdname(`cmdname') ///
						`cmddiopts' l(`level')
				mi_mcerror_footnote1	///
					"`linesize'" "`nomcerror'" "`dilevel'"
				if "`mi_mcerror_footnote2'"!="" {
					`mi_mcerror_footnote2' `linesize'
				}
			}
			`cmdftnote'
		}
	}
	if (e(k_exp_mi)>0 & "`notrcoef'"=="") { // display transf. table
		if ("`nocoef'"=="") di
		_mi_tables, `trtabopts' `nocnsreport' cmdname(`cmdname') ///
			    `notable' `citable' `dftable' `nocitable' 	///
			    `noheader' `nomiheader' `nocmdheader'	///
			     trcoef `trcoeftitle' nomodeltest		///
			    `nolegend' `clegend' trlegend cmdline(`cmdline') ///
			    `nomcerror'
		// s(width) is returned by _coef_table
		if ("`s(width)'"=="") {
			local linesize 79
		}
		else {
			local linesize = `s(width)'+1
		}
		mi_mcerror_footnote1 "`linesize'" "`nomcerror'" "`dilevel'"
	}
	if ("`notable'"=="" & `toshow') {
		// warning message
		if ("`nowarning'"=="") {
			if ("`esampvaryflag'"!="") {
				esample_warning2 `linesize'
			}
			else if (e(esampvary_mi)) {
				esample_warning1 `linesize'
			}
		}
		// footnotes
		mi_footnotes "`linesize'"
	}

	if (`unhold') {
		_estimates unhold `esthold'
	}
	if ("`post'"!="") {
		u_mi_postbv
	}
end

program mi_notes
	args cmd

	if (inlist("`cmd'", "xtlogit", "clogit")) {
		mi_xtlogit_notes
	}
end

program mi_xtlogit_notes

	local mlist `e(names_vvl_mi)'
	local multiple : list posof "multiple" in mlist
	local multiple = `multiple' + ("`e(multiple_mi)'"!="")
	if `multiple' {
		di as txt "{p 0 6 2}note: multiple positive outcomes " ///
			 "within groups encountered{p_end}"
	}
	tempname maxgr maxobs
	mata: st_numscalar("`maxgr'",max(st_matrix("e(N_group_drop_vs_mi)")))
	mata: st_numscalar("`maxobs'",max(st_matrix("e(N_drop_vs_mi)")))
	if `maxgr'==. & `maxobs'==. {
		scalar `maxgr' = e(N_group_drop_mi)
		scalar `maxobs' = e(N_drop_mi)
		if `maxgr'<. & `maxgr'>0 {
			mi_xtlogit_note `=`maxgr'' `=`maxobs''
		}
	}
	else {
		local ngr `e(N_group_drop_mi)'
		local nobs `e(N_drop_mi)'
		forvalues i=1/`e(M_mi)' {
			if `maxgr'<. {
				local ngr = el(e(N_group_drop_vs_mi),`i',1)
			}
			if `maxobs'<. {
				local nobs = el(e(N_drop_vs_mi),`i',1)
			}
			if `maxgr'>0 {
				mi_xtlogit_note `ngr' `nobs' `i'
			}
		}
	}
end

program mi_xtlogit_note

	args ndrop nobs m

	if ("`m'"!="") {
		local diimp "in {it:m}=`m' "
	}
	di as txt "{p 0 6 2}note: `ndrop' " `"`=plural(`ndrop',"group")'"' ///
	   " (`nobs' obs) dropped `diimp'"				   ///
	   "because of all positive or all negative outcomes{p_end}" 
end

program mi_footnotes
	args linesize

	if ("`linesize'"=="") {
		local linesize 79
	}
	// omitted imputations
	local M_out = `e(M_mi)'
	local M : word count `e(m_mi)'
	mata: _note_failed(`M', `M_out', `linesize')
	_svy_fpc_note "" "`linesize'" "e(b_mi)"
	_svy_singleton_note, bmat(e(b_mi)) linesize(`linesize')
	_svy_subpop_note, linesize(`linesize')
	mi_varying_notes `linesize'
end

program mi_varying_notes
	args linesize

	local mac `e(names_vvm_mi)'
	local N_g_vs : list posof "N_g" in mac
	if ("`e(N_g_vs_mi)'"=="matrix" | `N_g_vs') {
		di_varying_note "Number of groups" "`linesize'"	
	}
	local g_max_vs : list posof "g_max" in mac
	if ("`e(g_max_vs_mi)'"=="matrix" | `g_max_vs') {
		di_varying_note "Number of observations per group" "`linesize'"
	}
	if ("`e(_N_vm_mi)'"=="matrix") {
		di_varying_note "Numbers of observations in {cmd:e(_N)}" ///
				"`linesize'" "vary"
	}
	if ("`e(N_clust_vs_mi)'"=="matrix") {
		di_varying_note "Number of clusters" "`linesize'"
	}
	if ("`e(N_strata_vs_mi)'"=="matrix") {
		di_varying_note "Number of strata" "`linesize'"
	}
	if ("`e(N_psu_vs_mi)'"=="matrix") {
		di_varying_note "Number of primary clusters" "`linesize'"	
	}
	if ("`e(N_pop_vs_mi)'"=="matrix") {
		di_varying_note "Population size" "`linesize'"
	}
	if ("`e(N_subpop_vs_mi)'"=="matrix") {
		di_varying_note "Subpopulation size" "`linesize'"
	}
	if ("`e(N_sub_vs_mi)'"=="matrix") {
		di_varying_note "Number of observations in a subpopulation" ///
				"`linesize'"
	}
	if ("`e(N_poststrata_vs_mi)'"=="matrix") {
		di_varying_note "Number of poststrata" "`linesize'"
	}
	if ("`e(N_poststrata_vs_mi)'"=="matrix") {
		di_varying_note "Number of standardization strata" "`linesize'"
	}	
	if ("`e(census_vs_mi)'"=="matrix") {
		di as txt "{p 0 6 0 `linesize'}Note: 100% sampling rate is" ///
		    " detected for FPC in the first stage in some imputations."
	 	
	}
end

program di_varying_note
	args msg linesize vary
	if ("`vary'"=="") {
		local vary varies
	}
	di as txt ///
	      "{p 0 6 0 `linesize'}Note: `msg' `vary' among imputations.{p_end}"
end

program mi_streg_hrnote

	di as txt "{p 0 6 0 79}Note: Option {bf:hr} is ignored with the " ///
		  "accelerated failure-time form.{p_end}"
end

program mi_xtreg_note
	if inlist("`e(model)'","re","fe","ml") {
		di as txt "{p 0 6 0 79}{help mi_xtreg_note:Note}: "	///
			  "{cmd:sigma_u} and {cmd:sigma_e} "		///
			  "are combined in the original metric.{p_end}"
	}
end

program mi_me_note
	di as txt "{p 0 6 0 79}{help mi_me_note:Note}: "	///
		  "confidence intervals are not computable for some "	///
		  "random-effects parameters because MI degrees of "	///
		  "freedom cannot be estimated.{p_end}"
end

program mi_mcerror_footnote1
	args linesize nomcerror level

	if (!`e(mcerror_mi)' | "`nomcerror'"!="") exit

	if ("`level'"=="") {
		local level 95
	}

	di as txt "{p 0 6 0 `linesize'}Note: Values displayed beneath"
	di as txt "estimates are Monte Carlo error estimates" _c

	if ("`level'"=="nolevel" | "`level'"=="`e(cilevel_mi)'") {
		di as txt ".{p_end}"
	}
	else {
		di as txt "; {help mi_mcerrorci:error estimates are only available for `e(cilevel_mi)'% confidence intervals}.{p_end}"
	}
end

program mi_mcerror_footnote2
	args linesize

	di as txt "{p 0 6 0 `linesize'}{help mi_mcerroreform:Note}: Monte"
	di as txt "Carlo error estimates are not available for" 
	di as txt "exponentiated coefficients.{p_end}"
end


program _mi_tables
	is_svysum `e(cmd_mi)'
	local is_sum `r(is_svysum)'
	syntax [, 	NOTABle			///
			NOCITable		///
			CITable			///
			DFTable			///
			NOLEGend		///	//      --- legend opts
			CMDNAME(passthru)	///
			CMDLINE(passthru)	///
			TRLEGend		///
			CLEGend			///
			NOHEADer 		///	//      --- header opts
			NOMIHEADer 		///	
			NOCMDHEADer 		///	
			NOMODELTEST		///
			NOCLUSTREPORT		///
			TRCOEF			///
			TRCOEFTITLE		///
			NOFETable		///	// --- xtm<...> opts
			NOGRoup			///
			NOCNSReport		///	// --- _coef_table opts
			CMDEXTRAS		///
			NOMCERROR		///
			MCEFORM			///
			Level(string)		///
			* 			/// 	
		]
	if ("`nofetable'"!="") {
		local notable notable
	}
	local coeftabopts `options' level(`level')
	if ("`citable'`dftable'"=="") {
		local citable citable
	}
	if ("`nocitable'"!="") {
		local citable
	}
	if ("`citable'`dftable'"=="") exit
	if ("`nomiheader'"=="" | "`nocmdheader'"=="") {
		u_mi_estimate_table_header, `noheader' `nomiheader' ///
				    miheader cmdheader nright(nr) nleft(nl) ///
				    `nogroup'
		if ("`nr'"!="" & "`nl'"!="") {
			if (`nr'==`nl' & `nl'>2) di
		}
	}
	local hopts nomiheader nocmdheader nospace `nomodeltest' `trcoef'
	u_mi_estimate_table_header, `noheader' `hopts' `trcoeftitle'

	if ("`notable'"!="") exit

	di
	_mi_table_legend, `nolegend' `clegend' `cmdname' ///
			  `trlegend' `cmdline'

	if (`e(mcerror_mi)' & "`nomcerror'"=="") { //display MC errors
		if ("`trcoef'"=="") {
			local mcsuf "_mc_mi"
			if ("`mceform'"!="") {
				local efsuf "_eform"
			}
		}
		else {
			local mcsuf "_mc_Q_mi"
		}
		tempname mctable
		mat `mctable' = e(b`efsuf'`mcsuf')\e(se`efsuf'`mcsuf')
		if (!`is_sum') {
			mat `mctable'=`mctable'\e(tstat`mcsuf')\e(pvalue`mcsuf')
		}
		if ("`citable'"!="") {
			tempname cimctable
			mat `cimctable' = `mctable'\e(ci`efsuf'`mcsuf')
			mat `cimctable' = `cimctable''
			local cirowmatopts rowmatrix(`cimctable')
		}
		if ("`dftable'"!="") {
			tempname dfmctable
			mat `dfmctable' = `mctable'\e(df`mcsuf')\e(pise`mcsuf')
			mat `dfmctable' = `dfmctable''
			local dfrowmatopts rowmatrix(`dfmctable')
		}
		if ("`level'"!="`e(cilevel_mi)'") {
			local cirowmatopts `cirowmatopts' norowci
		}
	}

	if ("`citable'"!="") {
		if (`is_sum') {
			_sum_table, `coeftabopts' `cirowmatopts'
		}
		else {
			_coef_table, `coeftabopts' `e(aux_notest)' ///
				     `nocnsreport' `noclustreport' ///
				     `cmdextras' `cirowmatopts'
		}
		if ("`dftable'"!="") {
			if ("`e(cmd_mi)'"=="xtreg") {
				if inlist("`e(model)'","re","fe") {
					_xtreg_varcomp_display
				}
			}
		}
	}
	if ("`dftable'"!="") {
		if ("`citable'"!="" & "`noheader'"=="") {
			di
			di as txt "Degrees of freedom"
		}
		if ("`citable'"!="") {
			if ("`cmdname'"=="xtreg") {
				if inlist("`e(model)'","re","fe") {
					_xtreg_varcomp_display
				}
			}
			local noclustreport noclustreport
			if ("`trcoef'"!="") { // transf. table
				local nocnsreport nocnsreport
			}
		}
		if (`is_sum') {
			_sum_table, `coeftabopts' dfonly `noclustreport' ///
				    `dfrowmatopts'
		}
		else {
			_coef_table, dftable `coeftabopts' `e(aux_notest)' ///
			     `nocnsreport' `noclustreport' `cmdextras' ///
			     `dfrowmatopts'
		}
	}
end

program _mi_cmd_table

	syntax , CMDNAME(string) [*]

	if !inlist("`cmdname'","xtmixed","xtmelogit","xtmepoisson",	///
	  "mixed","meqrlogit","meqrpoisson","xtreg") {
		exit
	}

	if inlist("`cmdname'","xtmixed","xtmelogit","xtmepoisson",	///
	   "mixed","meqrlogit","meqrpoisson") {
		local SYNOPTS noFETable ESTMetric noRETable
		local ecmd `e(cmd)'
	}
	
	syntax , CMDNAME(string) [`SYNOPTS' *]

	if inlist("`cmdname'","xtmixed","mixed") {
		if ("`estmetric'`retable'"!="") {
			exit
		}
		_xtmixed_display, noheader nolrtest nofetable mi `options'
		exit
	}
	if inlist("`cmdname'","xtmelogit","xtmepoisson",	///
	  "meqrlogit","meqrpoisson") {
		if ("`estmetric'`retable'"!="") {
			exit
		}
		_xtme_display, noheader nolrtest nofetable mi `options'
		exit
	}
	if ("`cmdname'"=="xtreg") {
		if inlist("`e(model)'","re","fe") {
			_xtreg_varcomp_display, `options'
		}
	}
end

program _xtreg_varcomp_display
	syntax [, cformat(string asis) * ]

	tempname rho
	scalar `rho' = e(sigma_u_mi)^2/(e(sigma_u_mi)^2+e(sigma_e_mi)^2)

	local c1 = `"`s(width_col1)'"'
	local w = `"`s(width)'"'
	capture {
		confirm integer number `c1'
		confirm integer number `w'
	}
	if c(rc) {
		local c1 13
		local w 78
	}
	local c = `c1' - 1
	local rest = `w' - `c1' - 1
	if `"`cformat'"' != "" {
		local r		: display `cformat' `rho'
		local sigma_u	: display `cformat' e(sigma_u_mi)
		local sigma_e	: display `cformat' e(sigma_e_mi)
	}
	else {
		local r		: display %10.0g `rho'
		local sigma_u	: display %10.0g e(sigma_u_mi)
		local sigma_e	: display %10.0g e(sigma_e_mi)
	}
	di in smcl as txt %`c's "sigma_u" " {c |} " as res %10s "`sigma_u'"
	di in smcl as txt %`c's "sigma_e" " {c |} " as res %10s "`sigma_e'"
	di in smcl as txt %`c's "rho" " {c |} " as res %10s "`r'" /*
		*/ as txt "   (fraction of variance due to u_i)"
	di in smcl as txt "{hline `c1'}{c BT}{hline `rest'}"

end

program _mi_table_legend
	syntax [, NOLEGend CLEGend CMDNAME(string) 	///
		  TRLEGend CMDLINE(passthru) ]
	
	if ("`nolegend'"!="") exit
	if ("`clegend'`trlegend'"=="") exit
	
	_mi_cmdline_legend, `cmdline'
	if ("`clegend'"!="") {
		local cmdlist ratio mean proportion total
		local incmdlist : list cmdname in cmdlist 
		if (`incmdlist') {
			 _mi_summarize_legend vskip : "`cmdname'"
		}
	}
	if ("`trlegend'"!="") {
		u_mi_trcoef_legend
		local vskip di
	}
	`vskip'
end

program _mi_summarize_legend
	args vskip colon cmd

	_svy_summarize_legend "noblank" "`cmd'"
	
	c_local vskip ""	// no additional blank line
end

program _mi_cmdline_legend
	syntax [, CMDLINE(string asis) ]
	if `"`cmdline'"' != "" {
		di "{p2colset 7 16 20 2}{...}"
		di as txt `"{p2col :command:}`cmdline'{p_end}"'
	}
end

program _mi_vartable

	syntax [, NOCOEF NOLEGend NOTRCOEF NOTABle ///
		  CMDLINE(passthru) CMDNAME(passthru) NOMCERROR * ]

	local msopts `options'

	if ("`notable'"!="") exit
	if ("`nocoef'"!="" & (e(k_exp_mi)==0 | "`notrcoef'"!="")) exit

	if (!`e(mcerror_mi)') {
		local nomcerror nomcerror
	}

	local clegend clegend	// always displayed, even if -nocoef-
	local trlegend trlegend	
	if ("`notrcoef'"!="" | e(k_exp_mi)==0) {
		local trlegend
	}
	else {
		di
	}

	is_svysum `e(cmd_mi)'
	local is_sum `r(is_svysum)'
	if (`is_sum' & "`trlegend'"=="") {
		di
	}
	_mi_table_legend, `nolegend' `clegend' `cmdname' ///
			  `trlegend' `cmdline'

	// create variance information table
	tempname Tab
	.`Tab' = ._tab.new, col(7) lmargin(0) ignore(.b) 
	// column        1      2     3     4     5     6      7
	.`Tab'.width	13    |10    10    10    10     10     14
	.`Tab'.strfmt    .   %10s     .     .     .     .      .
	.`Tab'.pad       .      2     2     2     2     2      6
	.`Tab'.numfmt    .  %8.0g %8.0g %8.0g %8.0g %8.0g  %8.0g
	.`Tab'.strcolor  . result    .     .      .     .      .
	
	// display variance information table header
	.`Tab'.sep, top
	.`Tab'.titlefmt  .  %27s                  .  .	. . %14s
	.`Tab'.titles   "" "Imputation variance" "" "" "" "" "Relative"
	.`Tab'.titlefmt  .   %10s  %10s  %10s %10s %10s %14s
	.`Tab'.titles	""		/// 1
			"Within"	/// 2
			"Between"	/// 3
			"Total"		/// 4
			"RVI"		/// 5
			"FMI"		/// 6
			"efficiency"	 // 7

	// display VI table for coefficients
	if ("`nocoef'"=="") {
		.`Tab'.sep
		_mi_vartable_rows `Tab', `msopts' `nomcerror'
	}
	// display VI table for transformed coefficients
	if (e(k_exp_mi)>0 & "`notrcoef'"=="") {
		.`Tab'.sep
		_mi_vartable_rows `Tab', `msopts' trcoef `nomcerror'
	}
	.`Tab'.sep, bottom

end

program _mi_vartable_rows

	syntax namelist(name=Tab id="table class instance") [, 		///
							trcoef 		///
							NOMCERROR	///
							* 		///
						]
	local msopts `options'

	if ("`trcoef'"!="") {
		local Q _Q
	}

	// get column names from b_mi or b_Q_mi
	_ms_lf_info, matrix(e(b`Q'_mi))
	local k_eq = r(k_lf)
	forval i = 1/`k_eq' {
		local coleq `"`coleq' `"`r(lf`i')'"'"'
		local coleqdim `coleqdim' `r(k`i')'
	}

	// check for auxiliary equations
	if ("`trcoef'"=="") { // if not transformed coeff.
		local k_aux 0
		if (!missing(e(k_aux))) { 
			local k_aux `e(k_aux)'
		}
		local k_eq_model = `k_eq' - `k_aux'
	}
	else {
		local k_eq_model `k_eq'
	}
	is_svysum `e(cmd_mi)'
	if (`k_eq_model'==1 & !r(is_svysum)) {
		local hideeq hideeqname
	}

	// display equations (do not skip equations)
	local showbase = (!missing(e(k_eq_base)) & ("`trcoef'"==""))	
	local eqstart 0
	forvalues eqno=1/`k_eq' {
		gettoken eq coleq : coleq
		if (`eqno'>`k_eq_model') { // aux. equations
			local hideeq hideeqname
			local eqaux `"`eq'"'
			if (`eqno'==`k_eq') {
				local last last
			}
		}
		gettoken eqdim coleqdim : coleqdim
		if (`showbase' & `eqno'==e(k_eq_base)) {
			local comment "  (base outcome)"
			_mi_vartable_base_comment `Tab', 	///
						base(`eq') comment(`comment')
		}
		else {
			_mi_vartable_showeqname `Tab', eq(`eq') `hideeq'
			_mi_vartable_showeqs `Tab', 		///
					eqno(`eqno') 		///
					eqdim(`eqdim') 		///
					eqstart(`eqstart')	///
					eqaux(`eqaux')		///
					`trcoef'		///
					`nomcerror'		///
					`last'			///
					`msopts'		
		}
		if (`eqno'<`k_eq' & `"`eqaux'"'=="") {
			.`Tab'.sep
		}
		local eqstart = `eqstart'+`eqdim'
	}
end

program _mi_vartable_showeqname
	
	syntax namelist(name=Tab id="table class instance") [, 	///
					eq(string asis) hideeqname  ]
	
	if `"`eq'"' == "_" {
		local hideeqname hideeqname
	}
	else	local eqlgnd "`eq':"

	if ("`hideeqname'"!="") exit

	// show the equation name
	// columns         1   2  3  4  5  6  7
	.`Tab'.strcolor result   .  .  .  .  .  .
	.`Tab'.strfmt    %-12s   .  .  .  .  .  .
	if strpos(`"`eq'"', ".") {
		local p1 = 1
		local abeq : copy local eq
		while `:length local abeq' > 12 {
			local sub = udsubstr(`"`eq'"',`p1',12)
			local p1 = `p1' + ustrlen(`"`sub'"')
			.`Tab'.row   `"`sub'"' "" "" "" "" "" ""
			local abeq = usubstr(`"`eq'"',`p1',.)
		}
	}
	else {
		local abeq = abbrev(`"`eq'"',12)
	}
	.`Tab'.row   `"`abeq'"' "" "" "" "" "" ""
	.`Tab'.strcolor   text   .  .  .  .  .  .
	.`Tab'.strfmt     %12s   .  .  .  .  .  .
end

program _mi_vartable_base_comment
	
	syntax namelist(name=Tab id="table class instance") [, 	///
				base(string asis) comment(string asis)  ]

	local base = abbrev(`"`base'"', 12)
	.`Tab'.strcolor result          text   .  .  .  .  .
	.`Tab'.strfmt    %-12s             .   .  .  .  .  .
	.`Tab'.row     `"`base'"' `"`comment'"' "" "" "" "" ""
	.`Tab'.strfmt     %12s             .   .  .  .  .  .
	.`Tab'.strcolor   text        result   .  .  .  .  .
end

program _mi_vartable_showeqs

	syntax namelist(name=Tab id="table class instance") 	///
				[, 	eqno(integer 1) 	///
					eqdim(integer 1)	///
					eqstart(integer 0)	///
					eqaux(string asis)	///
					trcoef			///
					NOMCERROR		///
					LAST			///
					*			/// //msopts 
				]
	local diopts `options'
	local ms_diopts `diopts'
	if !`:list posof "vsquish" in diopts' {
		local ms_diopts `ms_diopts' vsquish
	}

	if ("`trcoef'"!="") {
		local Q _Q
	}

	local error1 "  (no observations)"
	local error2 "  (stratum with 1 PSU detected)"
	local error3 "  (sum of weights equals zero)"
	local error4 "  (denominator estimate equals zero)"
	local error5 "  (omitted)"
	local error6 "  (base)   "
	local error7 "  (empty)  "

	local output 0
	local first
	tempname b0 se0 btw wth tot rvi fmi re
	forvalues i=1/`eqdim' {
		if ("`eqaux'`last'"=="" & `i'==`eqdim') {
			local last last
		}
		if (`"`eqaux'"'!="") { // display aux. equation name
			if substr(`"`eqaux'"',1,1) != "/" {
				local label = "/" + abbrev(`"`eqaux'"', 11)
			}
			else {
				local label = abbrev(`"`eqaux'"', 12)
			}
			di as txt `"{ralign 14: `label' {c |}}"' _c
		}
		else { // display row name
			_ms_display, eq(#`eqno') el(`i') 	///
				     matrix(e(b`Q'_mi)) `first' `ms_diopts'
			if r(output) {
				local first
				if !`output' {
					local output 1
					local ms_diopts `diopts'
				}
			}
			else {
				if r(first) {
					local first first
				}
				continue
			}
			local note	`"`r(note)'"'
		}

		local err 0
		if "`note'" == "(base)" {
			local err 6
		}
		if "`note'" == "(empty)" {
			local err 7
		}
		if "`note'" == "(omitted)" {
			local err 5
		}

		local el = `eqstart' + `i'
		scalar `b0'  = el(e(b`Q'_mi),1,`el')
		scalar `se0' = sqrt(el(e(W`Q'_mi),`el',`el'))
		if `se0' == 0 & `"`e(census)'"' != "1" {
			scalar `se0' = .
		}
		local error 0
		if `b0' == 0 {
			if missing(`se0') {
				if `err' {
					local error : copy local err
				}
				else {
					local error 5
				}
				if ("`e(error)'"=="matrix") {
					if (el(e(error),1,`el')!=0) {
						local error 0
						//display missing values
					}
				}
			}
		}

		// display row values
		.`Tab'.width . . . . . . ., noreformat
		if `error' {
			local note : copy local error`error'
			.`Tab'.row "" "`note'" "" "" "" "" ""
		}
		else if missing(`se0') {
			.`Tab'.row "" . . . . . . 
			if ("`nomcerror'"=="") {
				.`Tab'.width . |. . . . . ., noreformat
				.`Tab'.row "" . . . . . . 
				if ("`last'"=="") {
					.`Tab'.row "" .b .b .b .b .b .b
				}
			}
		}
		else {
			scalar `btw'	= el(e(B`Q'_mi),`el',`el')
			scalar `wth'	= el(e(W`Q'_mi),`el',`el')
			scalar `tot'	= el(e(V`Q'_mi),`el',`el')
			scalar `rvi'	= el(e(rvi`Q'_mi),1,`el')
			scalar `fmi'	= el(e(fmi`Q'_mi),1,`el')
			scalar `re'	= el(e(re`Q'_mi),1,`el')

			.`Tab'.row "" `wth' `btw' `tot' `rvi' `fmi' `re'

			if ("`nomcerror'"=="") {
				.`Tab'.width . |. . . . . ., noreformat
				scalar `btw'	= el(e(B_mc`Q'_mi),1,`el')
				scalar `wth'	= el(e(W_mc`Q'_mi),1,`el')
				scalar `tot'	= el(e(V_mc`Q'_mi),1,`el')
				scalar `rvi'	= el(e(rvi_mc`Q'_mi),1,`el')
				scalar `fmi'	= el(e(fmi_mc`Q'_mi),1,`el')
				scalar `re'	= el(e(re_mc`Q'_mi),1,`el')

				.`Tab'.row "" `wth' `btw' `tot' `rvi' `fmi' `re'
				if ("`last'"=="") {
					.`Tab'.row "" .b .b .b .b .b .b
				}
			}
		}
		.`Tab'.width . |. . . . . ., noreformat
	} // end forvalues	

end

program esample_warning1
	args linesize
	di as txt as smcl "{p 0 9 0 `linesize'}"
	di as txt as smcl "{help mi_ewarning:Warning}: " _c
	di as txt "estimation sample varies across imputations;"
	di as txt "results may be biased."
	if (e(N_min_mi)==e(N_max_mi)) {
		di as txt "Sample sizes are constant but observations vary."
	}
	else {
		di as txt 	///
		   "Sample sizes vary between `e(N_min_mi)' and `e(N_max_mi)'."
	}
	di as txt as smcl "{p_end}"
end

program esample_warning2
	args linesize
	di as txt as smcl "{p 0 9 0 `linesize'}"
	di as txt as smcl "{help mi_ewarning:Warning}: " _c
	di as txt "varying estimation sample flag, {bf:e(esampvary_mi)},"
	di as txt "is one; results may be biased."
	di as txt as smcl "{p_end}"
end
