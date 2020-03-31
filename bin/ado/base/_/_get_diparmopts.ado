*! version 1.3.0  08mar2016
program _get_diparmopts, sclass
	if _caller() < 8.2 {
		_get_diparmopts_8 `0'
		exit
	}
	version 9
	local version : di "version " string(_caller()) ":"

	syntax [, diparmopts(string asis)	///
		EXECute soptions bottom plus	///
		SYNTAXonly			///
		*				///
	]
	// `goptions' has global options to splice into the -diparm()- options
	local goptions `options'

	// check syntax of global options
	SpliceGlobals junk , `goptions'

	local 0 `", `diparmopts'"'
	local diparmopts
	local k 0
	syntax [, diparm(string asis) * ]
	while `"`diparm'"' != "" {
		local ++k
		local single 1
		local after		// empty out `after'
		capture _on_colon_parse `diparm'
		if !c(rc) {
			local single 0
			local diparm `"`s(before)'"'
			local after `"`s(after)'"'
		}
		capture
		SpliceGlobals diparm , diparm(`diparm')	///
			`syntaxonly' `goptions'		///
			// blank
		local diparm`k' `"`diparm'"'
		local diparmopts `"`diparmopts' : `diparm'"'
		if `single' | `"`:list retok after'"' == "" {
			local 0 `", `options'"'
			syntax [, diparm(string asis) * ]
		}
		else {
			local diparm `"`after'"'
		}
	}

	// check if other options should be present
	if `"`soptions'"' == "" {
		syntax [, diparm(string asis) ]
	}

	if ("`execute'" == "") {
		sreturn clear
		sreturn local options `"`options'"'
		sreturn local diparm `"`diparmopts'"'	
		forval i = 1/`k' {
			sreturn local diparm`i' `"`diparm`i''"'
		}
		sreturn local k `k'
		exit
	}

	forval i = 1/`k' {
		`version' _diparm `diparm`i''
	}
	if (`"`bottom'"' != "")	_diparm __bot__
	if (`"`plus'"' != "")	_diparm __sep__
end

program SpliceGlobals
	syntax name(id="macro name" name=c_diparm) [,	///
		diparm(string asis)			///
		Level(cilevel)				///
		dof(passthru)				///
		syntaxonly				///
	]
	if `"`dof'"' == "" & `"`e(df_r)'"' != "" {
		capture confirm integer number `e(df_r)'
		if !c(rc) {
			local gdof dof(`e(df_r)')
		}
		capture
	}
	else	local gdof `"`dof'"'
	local glevel `level'
	local lopt level(`glevel')

	if (`"`diparm'"' == "") exit

	local 0 `diparm'
	syntax anything(id="eqname(s)" name=eqspecs) ///
		[, Level(passthru) dof(passthru) * ]

	if ("`eqspecs'" == "__sep__") exit

	if "`level'" == "" {
		local lopt level(`glevel')
	}
	else	local lopt `level'
	if `"`dof'"' == "" {
		local dof `"`gdof'"'
	}
	if "`syntaxonly'" == "" {
		c_local `c_diparm' `"`eqspecs', `options' `lopt' `dof'"'
	}
	else {
		c_local `c_diparm' `"`diparm'"'
	}
end

exit
