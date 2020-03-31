*! version 1.2.1  02may2019
program u_mi_estimate, eclass sortpreserve
	local version : di "version " string(_caller()) ":"
	version 11

	gettoken miest 0 : 0
	check_class_exists `miest'
	
	local cmdline : copy local 0
	 _on_colon_parse `0'
        local command `"`s(after)'"'
        local 0 `"`s(before)'"'
	
	// parse expressions and eform_opts 
	// note: common to -mi estimate using-
	syntax [anything(name=exprlist id="expression list")] , [ ///
						CMDOK 	 ///
						VCEOK	 /// //undocumented
						NOARGSOK /// //undocumented
						* ]
	// get command name
	if ("`cmdok'"!="") {
		local noargsok noargsok
	}
	qui CheckCommand `"`command'"' "`vceok'" "`noargsok'"
	local cmdname `s(cmd)'
	local fullcmdname `s(cmdname)'
	local props : properties `cmdname'
	local ismi : list posof "mi" in props
	if (!`ismi' & "`cmdok'"=="") {
		di as err "{bf:mi estimate}: command not supported"
		di as err "{p 4 4 2}{bf:`fullcmdname'} is not officially "
		di as err "supported by {bf:mi} {bf:estimate}; see"
		di as err "{help mi estimation} for a list of Stata"
		di as err "estimation commands that are supported by"
		di as err "{bf:mi} {bf:estimate}.  You can use option"
		di as err "{bf:cmdok} to allow estimation anyway.{p_end}"
		exit 198
	}

	// parse expressions	
	tempname mi_expr
        .`mi_expr'    = .u_mi_expr_parser.new, stub(_mi_) cmdname("`cmdname'")
        .`mi_expr'.parse `exprlist', `options'
	local k_exp	= r(k_exp)
	local eform	`"`r(eform)'"'
	local efopt 	`r(efopt)'
	if (`"`eform'"'=="") {
		local eform `efopt'
	}
	local opts	`r(options)'
	if (`k_exp') {
	        .`mi_expr'.build_nlcom
		local nlcom `"`s(nlcom)'"'
	}

	//check all allowed options w/o eform_opts
	u_mi_estimate_get_commonopts `cmdname'
	local syntax_opts `s(common_opts)'
	local 0 , `opts'
	syntax	[,				///
	  		SAVing(string asis)	///
			ESAMPLE(name)		///
			NOUPdate		///
			`syntax_opts'		/// // common to -mi est using-
			KEEPERESULTS(string)	/// // undocumented
			SORTSEED(string)	///
			*			/// // reporting factor opts
		]
	if ("`errorok'"!="") {
		local errok errok
	}
	if `"`saving'"'!="" {
		local errnote "no results will be saved"
	}
	// check factor-related estimation options
	_get_diopts diopts rest, `options'
	if (`"`rest'"'!="") {
		di as err `"option {bf:`rest'} not allowed"'
		exit 198
	}

	local style	`_dta[_mi_style]'
	if ("`esample'"!="") {
		if ("`style'"!="flong" & "`style'"!="flongsep") {
			di as err "{p}"
			di as err "{bf:esample()} requires {bf:mi} data "  ///
				"in styles {bf:flong} or {bf:flongsep}. " ///
				"The current style is {bf:`style'}; use "  ///
				"{helpb mi convert} to convert to "	   ///
				"{bf:flong} or {bf:flongsep}."
			di as err "{p_end}"
			exit 198
		}
		confirm new variable `esample'
		local saveall 1
	}
	else {
		local saveall 0
	}
	// saving()
	if `"`saving'"'!="" {
		_savingopt_parse fname replace : saving ".ster" `"`saving'"'
		if ("`replace'"=="") {
			confirm new file `"`fname'"'
		}
	}
	// check common options and build macro imputations
	local M_max	`_dta[_mi_M]'
	u_mi_estimate_chk_commonopts , maxm(`M_max') cmd(`cmdname') `opts'
	local imputations `s(imputations)'
	local diopts `diopts' `s(diopts)'
	local diopts `diopts' `eform'
	
	local M : word count `imputations'

	local dotsnoi 
	local replaynote 0
	if ("`noisily'"!="") {
		local dots
		local replaynote 1
		local action "running"
	}
	if ("`trace'"!="") {
		local traceon "set trace on"
		local traceoff "set trace off"
		local dots
		local replaynote 1
		local action "tracing"
		local noisily noisily
	}
	// sort order must be consistent for completed-data analysis
	if ("`_dta[_mi_style]'"=="wide") {
		tempvar myid
		qui gen `c(obs_t)' `myid' = _n
		qui compress `myid'
	}
	else {
		local myid _mi_id
	}
	local tsvars `_dta[_TSpanel]' `_dta[_TStvar]'

	// display imputations header
	if ("`dots'"!="") {
		di
		di as txt "Imputations ({res:`M'}):"
		u_mi_dots, indent(2)
		local dotsnoi noi
	}
	
	// main loop -- fitting models
	tempfile estfile
	tempname firstest
	tempname b V
	
	preserve	// main preserve

	mi select init
	local priorcmd `r(priorcmd)'
	local holdmarker `_dta[_mi_marker]'

	local dierr
	if ("`errok'"!="") {
		local dierr cap `noisily'
	}
	if ("`noisily'"=="") {
		local cmdqui qui
	}
	if ("`errok'"=="" | ("`errok'"!="" & "`noisily'"!="")) {
		local cmdnoi noi
	}
	tempname omit1 omit1nl omit errmat1 errmat
	local M_out = `M'
	local i 1
	local miter  1
	local e_vary 0
	local is_errmat 0
	if ("`sortseed'"=="") {
		qui query sortseed
		local sortseed `r(sortseed)'
	}
	set buildfvinfo off //turns off H matrix computation, for speed
	cap noi foreach m of numlist `imputations' { // begin main loop
		set sortseed `sortseed'
		// select imputation m
		`priorcmd'
		mi select `m'
		tempvar sortid
		qui gen `c(obs_t)' `sortid' = _n
		qui compress `sortid'
		qui des, varlist
		local sortedby `r(sortlist)'

		sort `tsvars' `myid'
		// clear mi marker to allow <cmd> to use set commands
		char _dta[_mi_marker]
		mata: _note_replay("`action'","`fullcmdname'","`m'",`replaynote')
		// fit the model
		if (`i'==1) {
			qui q sortseed
			local sortseedcmd `r(sortseed)'
		}
		`traceon'		
		cap `cmdnoi' `cmdqui' `version' `command'
		`traceoff'
		local rc_cmd = _rc
		if (e(converged)!=.) {
			local converged `e(converged)'
		}
		if (`rc_cmd'==1) {
			sort `sortedby' `sortid'
			error 1
		}
		if (`rc_cmd'==0) {
			if (`i'==1) { // check eclass command
				check_eclass
			}
			if (e(converged)==0) {
				local rc_cmd = 498
			}
		}
		// handle expressions
		local rc_nlcom = 0
		if (`k_exp'>0 & `rc_cmd'==0) {
			mata: 	///
			    _note_replay("`action'","nlcom","`m'",`replaynote')
			if (`i'==1) {
				// check expressions
				cap .`mi_expr'.chk_exprs
				local rc_nlcom = _rc
				if (`rc_nlcom' & `rc_nlcom'!=498) |	///
				   (`rc_nlcom'==498 & "`errok'"=="") {
					// if syntax error then stop
					cap `dotsnoi' u_mi_dots ///
						`miter' `rc_nlcom', every(10)
					cap `dotsnoi' di
					cap noi .`mi_expr'.chk_exprs
					`dierr' mi_cmderr "nlcom" `m' `errok'
					exit `rc_nlcom'
				}

			}
			// perform -nlcom-
			`traceon'		
			cap `cmdnoi' `cmdqui' `version' nlcom `nlcom'
			`traceoff'		
			local rc_nlcom = _rc
			if (`rc_nlcom'==1) {
				restore
				error 1
			}
			if (!`rc_nlcom') {
				mat `b' = r(b)
				mat `V' = r(V)
				eret matrix b_Q_mi = `b', copy
				eret matrix V_Q_mi = `V', copy
			}
		}
		char _dta[_mi_marker] "`holdmarker'"	//restore mi marker

		// save estimation results in a temporary file
		if (`rc_cmd') {
			eret clear
			eret post
			eret local cmd `cmdname'
			eret local cmdline `command'
		}
		else {
			local m_est_mi `m_est_mi' `m'
		}
		if ("`converged'"!="") {
			eret scalar converged = `converged'
		}
		eret scalar rc_mi = `rc_cmd'
		eret scalar rc_nl_mi = `rc_nlcom'
		eret local m_mi "`m'"
		nobreak qui estimates save `"`estfile'"', `append'
		local append append
		eret local m_mi
		mata: st_global("e(rc_mi)","")
		mata: st_global("e(rc_nl_mi)","")

		local err = (`rc_cmd'!=0 | `rc_nlcom'!=0)
		if (`err') {
			local M_out = `M_out'-1
			if (`rc_cmd') {
				local errname `fullcmdname'
			}
			else if (`rc_nlcom') {
				local errname nlcom
			}
			if ("`converged'"=="0") {
				`dierr' mi_cmderr_nonconvergent `m' `errok'
			}
			else {
				`dierr' mi_cmderr "`errname'" `m' `errok'
			}
			if ("`errok'"=="") {
				exit `=max(`rc_cmd',`rc_nlcom')' 
			}
		}
		else { // successful fit for both <command> and -nlcom-
			if (`i'==1) { // initialize
				if ("`e(error)'"=="matrix") {
					local is_errmat 1
					mat `errmat1' = e(error)
				}
				// add expressions to e()
				.`mi_expr'.post_legend "_mi"
				// ref. omitted vars
				mata: _st_chk_omitted("`omit1'")
				if (`k_exp'>0) {
					mata: 	///
				   _st_chk_omitted("`omit1nl'", "`b'","`V'")
				}
				_mi_get_keq k_eq
				mata: `miest'.init0(`M', `k_exp', `level')
				_estimates hold `firstest', copy
				local m_first `m'
			}
			mata: `miest'.e_update()
			// check that omitted vars are consistent
			mata: _st_chk_omitted("`omit'")
			if (`is_errmat') {
mat `errmat' = e(error)
if (mreldif(`errmat1', `errmat')!=0 & colsof(`errmat1')==colsof(`errmat')) {
	cap `dotsnoi' u_mi_dots `miter' 498, every(10)
	cap `dotsnoi' di
	mata: _error_note("`errmat1'","`errmat'", "errornote")
	di as err "{bf:mi estimate}: `errornote' in some imputations"
	di as err "{p 4 4 2}This is not allowed.  To identify offending"
	di as err "imputations, you can use {helpb mi xeq} to run the"
	di as err "command on individual imputations or you can reissue"
	di as err "the command with {bf:mi estimate, noisily}{p_end}"
	exit(498)
}
			}
			if (mreldif(`omit1', `omit')!=0) {
cap `dotsnoi' u_mi_dots `miter' 498, every(10)
cap `dotsnoi' di
di as err "{bf:mi estimate}: omitted terms vary"
di as err "{p 4 4 2}The set of omitted variables or categories is not "
di as err "consistent between {it:m}=`m_first' and {it:m}=`m'; "
di as err "this is not allowed.  To identify varying sets, you can use"
di as err "{helpb mi xeq} to run the command on individual imputations "
di as err "or you can reissue the command with {bf:mi estimate, noisily}{p_end}"
exit(498)
			}
			// check that omitted expressions are consistent
			if (`k_exp'>0) {
				mata: _st_chk_omitted("`omit'", "`b'","`V'")
				if (mreldif(`omit1nl', `omit')!=0) {
cap `dotsnoi' u_mi_dots `miter' 498, every(10)
cap `dotsnoi' di
di as err "{bf:mi estimate}: omitted expressions vary"
di as err "{p 4 4 2}The set of omitted expressions is not "
di as err "consistent between {it:m}=`m_first' and {it:m}=`m'; "
di as err "this is not allowed.  To identify varying sets, you can reissue"
di as err "the command with {bf:mi estimate, noisily}{p_end}"
exit(498)
				}
			}
			// check if e(sample) varies between imputations
			// (always checks against the first e(sample))
			tempvar touse
			qui gen byte `touse' = e(sample)
			qui count if `touse'
			local Ni = r(N)
			if (`i'==1) {
				local N1 = r(N)
			}
			if (r(N)>c(N)/2) {
				qui replace `touse' = 1-`touse'
				local neg -1
			}
			else {
				local neg 1
			}
			mata: `miest'.check_esample(	"`touse'",	///
							"`myid'",	///
							`i',		///
							`neg',		///
							`saveall')
			mata: st_local("e_vary", strofreal(`miest'.esampvary))
			if (`Ni'!=`N1') {
				local e_vary 1
			}
			cap drop `touse'
			local ++i
		}
		sort `sortedby' `sortid'	
		if (`e_vary' & "`esampvaryok'"=="") {
			cap `dotsnoi' u_mi_dots `miter' 459, every(10)
			di
			di as err "estimation sample varies "		///
			   "between {it:m}=`m_first' and {it:m}=`m'; "	/// 
			   "click {bf:{help mi_ewarning:here}} for details"
			exit 459
		}
		cap `dotsnoi' u_mi_dots `miter' `err', every(10)
		local ++miter
	}
	local rc = _rc
	char _dta[_mi_marker] "`holdmarker'"	//restore mi marker
	if `rc' {
		if ("`errnote'"!="") {
			di as err `"`errnote'"'
		}
		exit `rc'
	}
	cap `dotsnoi' u_mi_dots, last
	
	restore // end main loop -- fitting models
	mata: _chk_M(`M_out', "`errnote'")
	if ("`mcerror'"!="" & `M_out'<3) {
		di as err "Monte Carlo error computation "	///
			  "(option {bf:mcerror}) "		///
			  "requires at least 3 imputations"
		exit 198
	}
	
	// compute MI estimates
	mata: `miest'.combine("`estfile'")
	mata: `miest'.analyze()

	// compute Monte Carlo estimates using jackknife method
	if ("`mcerror'"!="") {
		mata: `miest'.jknife(`"`eform'"')
	}

	// post to e()
	eret post
	mata: `miest'.post()
	_ms_op_info e(b_mi)
	if r(tsops) {
		quietly mi tsset, noquery
		sort `r(panelvar)' `r(timevar)'
	}
	_ms_build_info e(b_mi), elabels
	eret local cmdline_mi `"mi estimate`cmdline'"'
	eret local _sortseed_mi		`sortseed'
	eret local _sortseedcmd_mi	`sortseedcmd'

	if `"`saving'"'!="" {
		// add -mi estimate- est. results to the end of the file
		nobreak qui estimates save `"`estfile'"', append
	}

	// display
	u_mi_estimate_display , `diopts'

	// save e(sample)
	if ("`esample'"!="") {
		qui _save_esample_`style' 	///
					`miest' `esample' "`imputations'"
	}
	// copy temp. estimation file to -saving()-
	if `"`saving'"'!="" {
		nobreak qui copy `"`estfile'"' `"`fname'"', `replace'
	}

end

program CheckPrefix, sclass
	
	capture _on_colon_parse `0'
	if (_rc) {
		sreturn local prefix	 ""
		sreturn local prefixopts ""
		sreturn local command	 `"`0'"'
		exit
	}
	
	mata: st_local("prefix", strrtrim(strltrim(`"`s(before)'"'))); ///
	      st_local("command", strrtrim(strltrim(`"`s(after)'"')))
	_parse comma prefix prefixopts : prefix
	gettoken prefix prefixrest : prefix
	local melist1 "xtmixed","xtmelogit","xtmepoisson"
	local melist1 `""`melist1'","mixed","meqrlogit","meqrpoisson""'
	local melist2 `""meglm","melogit","meprobit","mecloglog","meologit""'
	local melist2 `"`melist2',"meoprobit","mepoisson","menbreg""'
	local melist3 `""meintreg","metobit","mestreg""'
	if (inlist("`prefix'",`melist1') | inlist("`prefix'",`melist2') | ///
	    inlist("`prefix'",`melist3') | "`prefix'"=="ratio") {
		local command `prefix' `prefixrest' `prefixopts'
		local prefix
	}

	sreturn local prefix	 "`prefix'"
	sreturn local prefixrest "`prefixrest'"
	sreturn local prefixopts "`prefixopts'"
	sreturn local command	 `"`command'"'
end


program CheckCommand, sclass
	args cmdline vceok noargsok

	CheckPrefix `cmdline'
	local prefix	`"`s(prefix)'"'
	local prefixrest `"`s(prefixrest)'"'
	local prefixopts `"`s(prefixopts)'"'
	local command	`"`s(command)'"'

	// for -xtmixed/mixed- with weights
	local dblbar = ustrpos(`"`command'"', "||") - 1
	local command = cond(`dblbar' > 0, ///
		usubstr(`"`command'"', 1, `dblbar'), `"`command'"')
	local 0 `command'

	if ("`prefix'"!="") {
		if ("`prefix'"!="svy") {
			di as err `"command prefix {bf:`prefix'`prefixrest':} not allowed"'
			exit 198
		}
		// no nested prefixes allowed
		CheckPrefix `0'
		local prefix2	`"`s(prefix)'"'
		local prefixrest2 `"`s(prefixrest)'"'
		local command	`"`s(command)'"'
		if ("`prefix2'"!="") {
			di as err `"command prefix {bf:`prefix2'`prefixtrest2':} not allowed"'
			exit 198
		}
	}

	syntax anything(id="command name" equalok) 	///
		[fw iw pw aw] [if] [in] [, VCE(string asis) LRMODEL * ]
	if ("`prefix'"!="") {
		if ("`vceok'"=="") {
			_chk_svy_vce , `prefixrest'
			_chk_svy_vce `prefixopts'
		}
	}
	if (`"`command'"'=="") {
		local command `anything'
	}
	_prefix_command mi estimate : `command'
	local cmd "`s(cmdname)'"
	if (`"`s(anything)'"'=="" & "`noargsok'"=="") {
		di as err "varlist specification required"
		exit 198
	}
	if ("`vceok'"=="") {
		_parse comma vce vceopts : vce
		_chk_vce , `vce'
	}
	if ("`prefix'"!="") {
		local cmdname `prefix':`cmd'
	}
	else {
		local cmdname `cmd'
	}
	if ("`cmdname'"=="mixed") {
		Check_dfmethod `"`cmdline'"'
	}
	if ("`lrmodel'"!="") {
		_check_lrmodel `cmdname', prefix(mi estimate)
	}	
	sret clear
	sreturn local prefix	`"`prefix'"'
	sreturn local prefixopts `"`prefixopts'"'
	sreturn local cmdname	`"`cmdname'"'
	sreturn local cmd	`"`cmd'"'
end

program Check_dfmethod
	args cmdline

	while (`"`cmdline'"'!="") {
		gettoken opts cmdline : cmdline, parse("||") bind
	}
	_parse comma lhs rhs : opts
	if (`"`rhs'"'!="") {
		local 0 `rhs'
		syntax [, DFMethod(string) * ]
		if (`"`dfmethod'"'!="") {
			di as err ///
		"{bf:mi estimate} does not support {bf:mixed, dfmethod()}"
			exit 198
		}
	}
end

program _mi_get_keq

	args keq

	tempname b
	mat `b' = e(b)
	local cols : coleq `b'
	local cols : list uniq cols
	local k : word count `cols'

	c_local `keq' `k'
end

program _chk_vce

	syntax [, BOOTstrap BStrap JACKknife JACKNife JKnife * ]

	local vce `jackknife'`jacknife'`jknife'`bootstrap'`bstrap'
	if ("`vce'"!="") {
		di as err 	///
			"{bf:vce(`vce')} is not allowed with {bf:mi estimate}"
		exit 198
	}
end

program _chk_svy_vce

	syntax [, VCE(string) * ]

	if ("`vce'"!="") {
		local 0 , `vce'
	}
	else {
		local 0 , `options'
	}
	syntax [, JACKknife JACKNife JKnife BRR BOOTstrap BStrap SDR * ]

	local svyvce `jackknife'`jacknife'`jknife'`brr'`bootstrap'`bstrap'`sdr'
	if ("`svyvce'"!="") {
		di as err ///
		   "{bf:svy `svyvce'} is not allowed with {bf:mi estimate}"
		exit 198
	}
	local svyvce `_dta[_svy_vce]'
	if inlist("`svyvce'","brr","jackknife","bootstrap","sdr") {
		di as err "{p 0 0 2}{bf:vce(`svyvce')} previously set by " ///
		   "{bf:mi svyset} is not allowed with {bf:mi estimate}{p_end}"
		exit 198
	}
end

program _save_esample_flong, sortpreserve
	args miest varname imps

	preserve

	sort _mi_m _mi_id
	tempvar id

	//Add new variable 'varname' = 0
	qui gen byte `varname' = 0

	//reset 'varname'=e(sample) in imputations for which it is set
	local i = 1
	foreach m of local imps {
		qui count if _mi_m==`m'
		local N = r(N)
		gen `c(obs_t)' `id' = _n if _mi_m==`m' & _mi_id==1
		summ `id', meanonly
		local istart = r(mean)
		mata: `miest'.save_esample("`varname'", `i',`N',`istart')
		cap drop `id'
		local ++i
	}
	restore, not
end

program _save_esample_flongsep
	args miest varname imps

	preserve

	local M `_dta[_mi_M]'
	local fname `_dta[_mi_name]'
	local i = 1
	cap noi forvalues m=1/`M' {
		use _`m'_`fname', clear
		gen byte `varname' = 0
		local pos : list posof "`m'" in imps
		if (`pos') { // reset 'varname'=e(sample) in imputations 
			     // for which it is set
			mata: `miest'.save_esample("`varname'", `i',`c(N)')
			local ++i
		}
		save _`m'_`fname', replace
	}
	local rc = _rc
	if (!`rc') {
		restore
		qui gen byte `varname' = 0
	}
	exit `rc'
end

program mi_cmderr_nonconvergent
	args m errok

	if ("`errok'"!="") {
		local msg ", ignoring {it:m}=`m'"
	}
	else {
		local msg " on {it:m}=`m'"
	}
	di as err "{p 0}"
	di as err `"model did not converge`msg'"'
	di as err "{p_end}"
end

program mi_cmderr

	args cmdname m errok
	
	if ("`errok'"!="") {
		local msg ", ignoring {it:m}=`m'"
	}
	else {
		local msg " on {it:m}=`m'"
	}

	di as err "{p 0}"
	di as err "an error occurred when {bf:mi} {bf:estimate} executed "
	di as err "{bf:`cmdname'}" _c
	if ("`m'"!="") {
		di as err `"`msg'"'
	}
	di as err "{p_end}"
end

program check_eclass
	
	local err 0

	if (`"`e(cmd)'"'=="") {
		di as err "macro {bf:e(cmd)} is not set"
		local err 301
	}
	if ("`e(b)'"!="matrix") {
		di as err "matrix {bf:e(b)} is not set"
		local err 301
	}
	if ("`e(V)'"!="matrix") {
		di as err "matrix {bf:e(V)} is not set"
		local err 301
	}
	exit `err'
end

program check_class_exists
	args miest

	mata : st_local("empty",strofreal((findexternal("`miest'") == NULL)))
	if (`empty') {
		di as err "{bf:mi estimate} internal error: "	///
		   "{bf:_Mi_Estimate} class instance {bf:`miest'} not found"
                exit 111
        }
end

local RS 	real scalar
local SS 	string scalar
local RRVEC	real rowvector
local SRVEC	string rowvector

version 12
mata:

void _error_note(`SS' err1name, `SS' errname, `SS' errnote /* OUT */)
{
	`RS'	errcode
	`RRVEC'	err1, err, ind
	`SRVEC'	notes

	// NOTE: the following were adapted from _b_stat::validate(),
	// which is defined in _b_stat.mata

	notes = J(1,10,"")
	notes[1]	= "no observations"
	notes[2]        = "stratum with 1 PSU detected"
	notes[3]        = "sum of weights equals zero"
	notes[4]        = "denominator estimate equals zero"
	notes[5]	= "omitted level"
	notes[6]	= "base level"
	notes[7]	= "empty level"
	notes[8]	= "not estimable"
	notes[9]	= "constrained parameter"
	notes[10]	= "no path"

	err1	= st_matrix(err1name)
	err	= st_matrix(errname)
	ind	= select(range(1,cols(err1),1)', (err1:!=err))

	if (err1[ind[1]]==0) errcode = err[ind[1]]
	else errcode = err1[ind[1]]
	st_local(errnote, notes[errcode])
}
end

exit
