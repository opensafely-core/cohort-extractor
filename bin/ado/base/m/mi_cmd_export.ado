*! version 1.1.1  08jun2011

/*
	mi export <exportstyle> [...]

		(does not change the data in memory)
		except -mi export ice- does
*/

program mi_cmd_export
	version 11

	u_mi_assert_set
	gettoken exportstyle 0 : 0, parse(" ,[]()=")
	if ("`exportstyle'"=="") { 
		di as err "nothing found where export style expected"
		di as err "syntax is -mi export <exportstyle> ...-"
		display_export_styles_error
		/*NOTREACHED*/
	}

	local styleset 0
	if ("`exportstyle'"=="nhanes1") {
		local styleset 1 
	}
	else if ("`exportstyle'"=="ice") {
		local styleset 1
	}

	if (!`styleset') {
		di as err "invalid export style `style'"
		display_export_styles_error
	}
	if (_N==0) {
		error 2000
	}
	mi_export_`exportstyle' `0'
end


program display_export_styles_error
	di as smcl as err "{p}"
	di as smcl as err "there are currently two export"
	di as smcl as err "styles: {bf:ice} and {bf:nhanes1}"
	di as smcl as err "{p_end}"
	exit 198
end

/*
	mi export nhanes1 <filenamestub>,
		[
		replace
		passiveok
		nacode(<#>)			default nacode(0)
		obscode(<#>)			default obscode(1)
		impcode(<#>)			default impcode(2)

		impprefix(<string>)		default impsuffix("" "")
		impsuffix(<string>)		default impsuffix(if mi)
		uppercase			uppercase prefix/suffix
		]
	

*/

program mi_export_nhanes1
	u_mi_certify_data, acceptable

	/* ------------------------------------------------------------ */
						/* parse		*/
	gettoken filestub 0 : 0, parse(" ,")
	if ("`filestub'"=="" | "`filestub'"==",") { 
		di as err "nothing found where filename stub expected"
		di as err "syntax is -mi export nhanes1 {it:filenamestub} ...-"
		exit 198
	}
	capture confirm name `filestub'
	if (_rc) { 
		di as err "`filestub' is an invalid filename stub"
		exit 198
	}

	syntax [,				///
		IMPCODE(real 2)			///
		IMPuted(string)			///
		IMPSUFfix(string asis)		///
		IMPPREfix(string asis)		///
		NACODE(real 0)			///
		OBSCODE(real 1)			///
		PASSIVEok			///
		REPLACE				///
		UPPERcase			///
	      ]

						/* parse		*/
	/* ------------------------------------------------------------ */
						/* check values		*/

	local M `_dta[_mi_M]'
	if ("`replace'"=="") {
		confirm new file "`filestub'.dta"
		forvalues i=1(1)`M' {
			confirm new file "`filestub'`i'.dta"
		}
	}
			
	u_mi_imexport_fix_pre_suf if_p mi_p : impprefix `"`impprefix'"' ""  ""
	u_mi_imexport_fix_pre_suf if_s mi_s : impsuffix `"`impsuffix'"' "if" "mi"

	local seqn "seqn"
	if ("`uppercase'"!="") {
		local if_p = strupper("`if_p'")
		local if_s = strupper("`if_s'")
		local mi_p = strupper("`mi_p'")
		local mi_p = strupper("`mi_s'")
		local seqn   "SEQN"
	}

	if (`nacode' ==`obscode' |	///
	   `nacode' ==`impcode' |       ///
	   `obscode'==`impcode') {
		di as err as smcl "{p}
		di as smcl as err ///
			"{bf:obscode()}, {bf:impcode()}, and {bf:nacode()}"
		di as smcl as err "must be distinct numeric values"
		exit 198
	}

	if ("`passiveok'"=="" & "`_dta[_mi_pvars]'"!="") {
		di as smcl as err "{p 0 4 2}"
		di as smcl as err "no; data have passive variables{break}"
		di as smcl as err "The nhanes1 format cannot handle passive"
		di as smcl as err "variables. Your alternatives are (1) to drop"
		di as smcl as err "the passive variables or (2) to specify"
		di as smcl as err "{bf:mi export}'s {bf:passiveok} option."
		di as err
		di as smcl as err "{p 4 4 2}"
		di as smcl as err "Option {bf:passiveok} specifies that"
		di as smcl as err "the passive variables are to be treated"
		di as smcl as err "as if they were imputed variables."
		di as smcl as err "{p_end}"
		exit 459
	}

	confirm new var `seqn'
						/* check values		*/
	/* ------------------------------------------------------------ */
						/* execute		*/
	if ("`replace'"!="") {
		capture erase "`filestub'.dta"
		forvalues i=1(1)`M' {
			capture erase "`filestub'`i'.dta"
		}
	}

	if (`M'==0) { 
		preserve
		mi extract 0
		qui save "`filestub'"
		di as smcl "file `filestub'.dta created"
		exit
	}

	u_mi_get_flongsep_tmpname name : miexport

	capture noi novarabbrev 				 ///
		mi_export_nhanes1_u "`name'" "`filestub'" `seqn' ///
		"`if_p'" "`mi_p'"				 ///
		"`if_s'" "`mi_s'"				 ///
		`obscode' `impcode' `nacode'
	nobreak {
		local rc = _rc 
		if (`rc') { 
			capture erase "`name'.dta"
			capture erase "`filestub'.dta"
			forvalues i=1(1)`M' {
				capture erase "_`i'_`name'.dta"
				capture erase "`filestub'`i'.dta"
			}
		}
	}
	exit `rc'
end



program mi_export_nhanes1_u 
	args name filestub seqn if_p mi_p if_s mi_s obscode impcode nacode

	preserve

	qui mi convert flongsep `name', clear
	local name `_dta[_mi_name]'
	local M    `_dta[_mi_M]'
	local ivars `_dta[_mi_ivars]' `_dta[_mi_pvars]'
	// sic, above, we treat passive and imputed as the same

	quietly {
		forvalues m=1(1)`M' {
			use _`m'_`name', clear 
			foreach v of local ivars {
				rename `v' `mi_p'`v'`mi_s'
			}
			u_mi_zap_chars
			rename _mi_id `seqn'
			order `seqn'
			save _`m'_`name', replace
		}
		use `name', clear
		drop _mi_miss
		rename _mi_id `seqn'
		order `seqn'
		u_mi_zap_chars
		tempvar flg
		foreach v of local ivars {
			gen byte `flg' = `obscode'
			replace `flg' = `impcode' if `v'==.
			replace `flg' = `nacode' if `v'>.
			drop `v'
			rename `flg' `if_p'`v'`if_s'
		}
		nobreak { 
			save "`filestub'"
			erase `name'.dta
			local files "`filestub'.dta"
			forvalues m=1(1)`M' {
				use _`m'_`name', clear 
				save "`filestub'`m'"
				erase _`m'_`name'.dta
				local files `files' `filestub'`m'.dta
			}
		}
	}
	di as smcl as txt "{p 0 1 1}"
	di as smcl "files"
	di as smcl "`files'"
	di as smcl "created"
	di as smcl "{p_end}"
end

program mi_export_ice
	syntax [, CLEAR]

	if (c(changed) & "`clear'"=="") {
		error 4
	}

	novarabbrev {
		capture confirm new var _mi 
		if (_rc) {
			local bad _mi
		}
		capture confirm new var _mj
		if (_rc) {
			local bad `bad' _mj
		}
	}
	if ("`bad'"!="") {
		local n : word count `bad'
		local variables = cond(`n'==1, "variable", "variables")
		local exist     = cond(`n'==1, "exists",   "exist")
		di as err "`variables' {bf:`bad'} already `exist'"
		di as err "{p 4 4 2}"
		di as err "You must drop or rename {bf:`bad'}"
		di as err "before the data can be converted to {bf:ice} format."
		di as err "{p_end}"
		exit 110
	}
	u_mi_certify_data, acceptable proper
	preserve
	if ("`_dta[_mi_style]'" != "flong") {
		mi convert flong, clear
	}
	rename _mi_m  _mj
	rename _mi_id _mi
	label var _mi "obs. number"
	label var _mj "imputation number"
	drop _mi_miss
	u_mi_zap_chars
	char _dta[mi_id] 
	global S_FN
	restore, not
end
